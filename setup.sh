#!/bin/bash
set -e

# Set up environment
export PATH="/root/.local/bin:${PATH}"

# Generate bash completions for erd
bash -l -c "erd --completions bash > /root/.local/share/bash-completion/completions/erd"

# Install neovim packages and language servers
bash -l -c "nvim --headless -c MasonUpdate -c 'MasonInstall lua-language-server' -c 'TSInstallSync bash python' -c q"
bash -l -c "nvim --headless -c 'MasonInstall shellcheck' -c q"
bash -l -c "nvim --headless -c 'lua require(\"kulala\")' -c q"

# Fix absolute path in lua language server
sed -i 's/\/root\/.local/~\/.local/g' /root/.local/share/nvim/mason/packages/lua-language-server/lua-language-server

# Clean up unnecessary files
rm -r /root/.wget-hsts /root/.cache /root/.bashrc
