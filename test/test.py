from sys import stdout
import tarfile

import pexpect
import pytest
import os
import subprocess

from pathlib import Path

USER_HOME = "/home/tester"
ARTIFACT_FILENAME = "server_homedir.tar.gz"

PROMPT_PATTERN = r'\$$'


@pytest.fixture(scope="module")
def bash_session():
    """
    A pytest fixture that sets up the environment and starts a bash shell.
    This runs once per test module.
    """
    extract_command = f"tar -xzf {USER_HOME}/{ARTIFACT_FILENAME} -C {USER_HOME}"
    print(f"DEBUG: Running initial setup command: '{extract_command}'")

    try:
        output, exit_status = pexpect.run(extract_command, withexitstatus=True, encoding='utf-8', timeout=30)
        assert exit_status == 0, f"Extract command failed with exit status {exit_status}:\n{output}"
        print("DEBUG: Artifact extracted successfully.")
    except Exception as e:
        pytest.fail(f"Failed to extract artifact: {e}")

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

    def _run_version_check(tool, version_argument):
        """Run the version check for a single tool and handle exceptions."""
        try:
            proc = subprocess.run(
                [tool, version_argument],
                capture_output=True,
                text=True,
                timeout=5
            )
            assert proc.returncode == 0, (
                f"'{tool} {version_argument}' failed with exit code {proc.returncode}.\n"
                f"Output:\n{proc.stdout}\n{proc.stderr}"
            )
        except subprocess.TimeoutExpired as e:
            pytest.fail(
                f"'{tool} {version_argument}' timed out after 5 seconds.\n"
                f"Output:\n{e.stdout}\n{e.stderr}"
            )
        except FileNotFoundError:
            pytest.fail(f"'{tool}' not found.")

    TOOLS_TO_CHECK = {
        "--version": [
            "bat", "jq", "fzf", "rg", "curl", "lnav",
            "erd", "delta", "fd", "lsd", "stylua", "nvim", "starship"
        ],
        "-V": ["tmux"],
    }

    for version_arg, tools in TOOLS_TO_CHECK.items():
        for tool in tools:
            _run_version_check(tool, version_arg)

def test_files_present(bash_session):
    """
    Verify:
    - tools are present and executable in ~/.local/bin
    - manpages (where applicable) exist in ~/.local/bin/man/man1
    - bash-completion files (where applicable) exist in ~/.local/share/bash-completion/completions
    """
    base = Path(USER_HOME)
    bin_dir = base / ".local" / "bin"
    man1_dir = bin_dir / "man" / "man1"
    comp_dir = base / ".local" / "share" / "bash-completion" / "completions"

    # Ensure the relevant directories exist
    assert bin_dir.is_dir(), f"Missing bin dir: {bin_dir}"
    assert man1_dir.is_dir(), f"Missing man1 dir: {man1_dir}"
    assert comp_dir.is_dir(), f"Missing bash-completion dir: {comp_dir}"

    tools_expected = [
        "fzf", "lsd", "bat", "delta", "fd", "rg", "jq", "lnav",
        "nvim", "starship", "erd", "curl", "stylua", "tmux"
    ]
    for tool in tools_expected:
        tool_path = bin_dir / tool
        assert tool_path.exists(), f"Missing tool: {tool_path}"
        assert os.access(tool_path, os.X_OK), f"Tool not executable: {tool_path}"

    manpages_expected = ["lsd.1", "jq.1", "bat.1", "delta.1", "fd.1", "rg.1", "fzf.1"]
    for manpage in manpages_expected:
        man_path = man1_dir / manpage
        assert man_path.is_file(), f"Missing manpage: {man_path}"

    completions_expected = ["fzf", "lsd", "bat", "delta", "fd", "erd", "rg"]
    for comp in completions_expected:
        comp_path = comp_dir / comp
        assert comp_path.is_file(), f"Missing bash-completion file: {comp_path}"



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
    bash_session.expect(PROMPT_PATTERN, timeout=5)


def test_third_party_licenses():
    """
    Test that all expected third-party license files are present in the licenses TAR.GZ
    and contain the expected content based on their license type.
    """
    # expected license files organized by license type
    expected_licenses = {
        "Apache-2.0": [
            "cmp_luasnip.LICENSE", "luasnip.LICENSE", "neovim.LICENSE.txt", "snacks-nvim.LICENSE",
            "lazy-nvim.LICENSE", "mason-lspconfig-nvim.LICENSE", "nvim-lspconfig.LICENSE.md", "which-key-nvim.LICENSE",
            "lsd.LICENSE", "mason-nvim.LICENSE", "nvim-treesitter.LICENSE", "lua-console.nvim.LICENSE",
            "lazydev.LICENSE", "eagle.nvim.LICENSE", "fd-APACHE.LICENSE-APACHE"
        ],
        "BSD2Clause": ["lnav.LICENSE"],
        "CCBY3": ["jq.COPYING"],
        "GPLv3": ["nvim-dap.LICENSE.txt", "nvim-lint.LICENSE.txt", "shellcheck.LICENSE", "nvim-dap-python.LICENSE.txt",
                  "bufferline.nvim.LICENSE"],
        "GPLv3orHigher": ["diffview.nvim.LICENSE"],
        "ISC": ["starship.LICENSE", "tmux.COPYING"],
        "MIT": [
            "bat.LICENSE-MIT", "delta.LICENSE", "jsregexp.LICENSE", "nvim-cmp.LICENSE",
            "build-static-tmux.LICENSE", "erdtree.LICENSE", "kickstart-nvim.LICENSE.md", "nvim-dap-ui.LICENCE.md",
            "cmp-buffer.LICENSE", "formatter-nvim.LICENSE", "legendary.LICENSE", "nvim-nio.LICENCE.md",
            "cmp-cmdline.LICENSE", "friendly-snippets.LICENSE", "lspkind-nvim.LICENSE", "nvim-web-devicons.LICENSE",
            "cmp-nvim-lsp.LICENSE", "fzf.LICENSE", "lua-language-server.LICENSE", "static-curl_mit.LICENSE",
            "cmp-path.LICENSE", "jq.COPYING", "lualine-nvim.LICENSE", "vim-rhubarb.LICENSE", "blame.nvim.LICENSE",
            "plenary.nvim.LICENSE", "gitsigns.LICENSE", "FixCursorHold.nvim.LICENSE", "neogit.LICENSE",
            "nvim-lightbulb.LICENSE", "neotest.LICENCE.md", "kulala.nvim.LICENSE",
            "basedpyright.LICENSE.txt", "neotest-python.LICENCE.md", "opencode.nvim.LICENSE", "copilot.lua.LICENSE",
            "copilot-cmp.LICENSE", "copilot-lualine.LICENSE", "codecompanion.nvim.LICENSE",
            "render-markdown.nvim.LICENSE", "mcphub.nvim.LICENSE.md", "vim-dadbod-ui.LICENSE",
            "vim-dadbod-completion.LICENSE", "satellite.nvim.LICENSE", "fd-MIT.LICENSE-MIT", "lensline.nvim.LICENSE"
        ],
        "MPL2": ["stylua.LICENSE.md"],
        "Unlicense": ["ripgrep.UNLICENSE"],
        "Vim": ["_canonical.vim-license.txt", "neovim.LICENSE.txt", "vim-sleuth.LICENSE.txt", "vim-dadbod.LICENSE.txt"],
        "curl": ["static-curl_curl.COPYING"]
    }

    # expected content strings for each license type
    expected_content = {
        "Apache-2.0": ["Apache License", "Version 2.0, January 2004"],
        "BSD2Clause": ["Redistribution and use"],
        "CCBY3": ["CC BY 3.0"],
        "GPLv3": ["GNU GENERAL PUBLIC LICENSE", "Version 3, 29 June 2007"],
        "GPLv3orHigher": ["GNU General Public License", "version 3", "any later version"],
        "ISC": ["Permission to use, copy, modify,", "DISCLAIMS ALL WARRANTIES"],
        "MIT": ["Permission is hereby granted, free of charge, to any person obtaining"],
        "MPL2": ["Mozilla Public License"],
        "Unlicense": ["This is free and unencumbered software released into the public domain"],
        "Vim": ["VIM LICENSE"],
        "curl": ["Permission to use, copy, modify,", "the name of a copyright holder"]
    }

    licenses_tar_path = Path(USER_HOME) / "server_homedir_THIRD_PARTY_LICENSES.tar.gz"

    assert licenses_tar_path.exists(), f"Third-party licenses TAR.GZ file not found: {licenses_tar_path}"

    with tarfile.open(licenses_tar_path, 'r:gz') as tar_file:
        tar_contents = set(tar_file.getnames())

        all_expected_files = {f"licenses/{file}" for files_list in expected_licenses.values() for file in files_list}

        missing_files = all_expected_files - tar_contents
        assert not missing_files, f"Missing license files in TAR.GZ: {missing_files}"

        # Verify content for license types that have expected content defined
        for license_type, expected_strings in expected_content.items():
            files_for_type = expected_licenses.get(license_type, [])

            for license_file in files_for_type:
                license_file_path_in_tar = f"licenses/{license_file}"
                if license_file_path_in_tar in tar_contents:
                    tar_member = tar_file.extractfile(license_file_path_in_tar)
                    if tar_member:
                        license_in_tar_file_content = tar_member.read().decode('utf-8', errors='ignore')

                        for expected_string in expected_strings:
                            assert expected_string in license_in_tar_file_content, \
                                f"Expected string '{expected_string}' not found in {license_file} (license type: {license_type})"

        print(f"Successfully verified {len(all_expected_files)} license files in the third-party licenses TAR.GZ")
