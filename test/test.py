from sys import stdout

import pexpect
import pytest

USER_HOME = "/home/tester"
ARTIFACT_FILENAME = "server_homedir.zip"

PROMPT_PATTERN = r'\$$'


@pytest.fixture(scope="module")
def bash_session():
    """
    A pytest fixture that sets up the environment and starts a bash shell.
    This runs once per test module.
    """
    unzip_command = f"unzip -o {USER_HOME}/{ARTIFACT_FILENAME} -d {USER_HOME}"
    print(f"DEBUG: Running initial setup command: '{unzip_command}'")

    try:
        output, exit_status = pexpect.run(unzip_command, withexitstatus=True, encoding='utf-8', timeout=30)
        assert exit_status == 0, f"Unzip command failed with exit status {exit_status}:\n{output}"
        print("DEBUG: Artifact unzipped successfully.")
    except Exception as e:
        pytest.fail(f"Failed to unzip artifact: {e}")

    with open(f"{USER_HOME}/.config/starship.toml", "w") as file:
        file.write('format = "$directory\\\\$"\n\n[directory]\nstyle = "none"')
        file.flush()

    child_session = pexpect.spawn('bash', ['-l'], encoding='utf-8', dimensions=(24, 80))
    child_session.logfile = stdout
    child_session.sendline()
    child_session.expect(PROMPT_PATTERN, timeout=5)

    yield child_session

    child_session.close()

# --- Test Cases ---

def test_tool_versions(bash_session):
    """Test that all basic tools are installed and executable."""
    tools_to_check = [
        "bat", "jq", "fzf", "rg", "curl", "lnav",
        "erd", "delta", "lsd", "stylua", "nvim", "starship"
    ]
    tools_other_version_arg = ["tmux"]
    for tool in tools_to_check:
        bash_session.sendline(f'{tool} --version')
        bash_session.expect(PROMPT_PATTERN, timeout=2)
        output = bash_session.before
        assert "Error" not in output, f"Error found in output of '{tool} --version':\n{output}"
        assert "command not found" not in output, f"'{tool}' not found."

    for tool in tools_other_version_arg:
        bash_session.sendline(f'{tool} -V')
        bash_session.expect(PROMPT_PATTERN, timeout=2)
        output = bash_session.before
        assert "Error" not in output, f"Error found in output of '{tool} -V':\n{output}"
        assert "command not found" not in output, f"'{tool}' not found."


def test_neovim_startup_no_errors(bash_session):
    """
    Test that Neovim starts without errors on a lua file.
    """
    bash_session.sendline("mkdir -p test; echo 'print(\"hello from lua\")' > test/test.lua")
    bash_session.expect(PROMPT_PATTERN, timeout=2)

    nvim_command = "nvim --headless -c 'sleep 1' -c 'lua print(vim.inspect(Snacks.notifier.get_history()))' -c 'quitall' test/test.lua"

    bash_session.sendline(nvim_command)
    bash_session.expect(r"\{\}$", timeout=5)

    bash_session.sendline('rm test/test.lua; rmdir test')
    bash_session.expect(PROMPT_PATTERN, timeout=2)
