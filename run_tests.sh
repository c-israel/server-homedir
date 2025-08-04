#!/bin/bash
set -e

MAIN_IMAGE_TAG="server-homedir-builder"
ARTIFACT_PATH_IN_IMAGE="/home/ubuntu/server_homedir.zip"
LOCAL_ARTIFACT_NAME="server_homedir.zip"

TEST_DIR="test"
TEST_IMAGE_TAG="env-tester:latest"

REPORT_DIR_IN_CONTAINER="/home/tester/test_results"
LOCAL_REPORT_NAME="test_report.xml"

# --- cleanup on script exit (success or failure) ---
cleanup() {
    echo "--- Cleaning up ---"
    if [ -n "${ARTIFACT_CONTAINER_ID}" ]; then
        echo "Removing artifact extraction container: ${ARTIFACT_CONTAINER_ID}"
        docker rm "${ARTIFACT_CONTAINER_ID}" >/dev/null 2>&1 || true
    fi
    if [ -f "${LOCAL_ARTIFACT_NAME}" ]; then
        echo "Removing local artifact: ${LOCAL_ARTIFACT_NAME}"
        rm "${LOCAL_ARTIFACT_NAME}"
    fi
    if [ -n "${TEST_CONTAINER_ID}" ]; then
        echo "Removing test container: ${TEST_CONTAINER_ID}"
        docker rm "${TEST_CONTAINER_ID}" >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

echo "--- Extracting artifact from ${MAIN_IMAGE_TAG} ---"

ARTIFACT_CONTAINER_ID=$(docker create ${MAIN_IMAGE_TAG})
docker cp "${ARTIFACT_CONTAINER_ID}:${ARTIFACT_PATH_IN_IMAGE}" ./"${LOCAL_ARTIFACT_NAME}"


echo "--- Building test image: ${TEST_IMAGE_TAG} ---"
docker build -t ${TEST_IMAGE_TAG} -f ${TEST_DIR}/Dockerfile ${TEST_DIR}


echo "--- Running tests and generating report ---"

TEST_COMMAND="mkdir -p ${REPORT_DIR_IN_CONTAINER} && \
              cd /home/tester && \
              python3 -m pytest -v tests/test.py --junitxml=${REPORT_DIR_IN_CONTAINER}/${LOCAL_REPORT_NAME}"

TEST_CONTAINER_ID=$(docker create \
                   -v "$(pwd)/${TEST_DIR}:/home/tester/tests" \
                   -v "$(pwd)/${LOCAL_ARTIFACT_NAME}:/home/tester/${LOCAL_ARTIFACT_NAME}" \
                   --user=tester \
                   ${TEST_IMAGE_TAG} \
                   bash -c "${TEST_COMMAND}")

echo "Created test container: ${TEST_CONTAINER_ID}"
echo "Starting test execution (live output below):"

docker start -ia "${TEST_CONTAINER_ID}" # start and attach - block until done
TEST_EXIT_CODE=$?


echo "--- Extracting report: ${LOCAL_REPORT_NAME} ---"

if docker cp "${TEST_CONTAINER_ID}:${REPORT_DIR_IN_CONTAINER}/${LOCAL_REPORT_NAME}" ./"${LOCAL_REPORT_NAME}"; then
    echo "Test report copied to ./${LOCAL_REPORT_NAME}"
else
    echo "WARNING: Could not copy test report. It might not have been generated."
fi

if [ "$TEST_EXIT_CODE" -ne 0 ]; then
    echo "--- Tests FAILED (exit code: ${TEST_EXIT_CODE}) ---"
    exit 1
else
    echo "--- Tests PASSED ---"
fi
