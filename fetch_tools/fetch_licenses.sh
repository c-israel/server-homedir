#!/usr/bin/env bash

#
# This script downloads all third-party license files for the components
# included in the server-homedir artifact.
#
# It reads a list of components and URLs, converts GitHub blob URLs to raw
# URLs, and saves each license file in the 'licenses/' directory.
#
# USAGE:
#   ./fetch-licenses.sh
#
# DEPENDENCIES:
#   - wget
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the output directory
LICENSES_DIR="licenses"

# --- Main Configuration ---
# Associative array to hold component names and their license URLs.
#
# Format:
#   ["component-name"]="https://github.com/user/repo/blob/branch/LICENSE.txt"
#
# The script will automatically create a filesystem-friendly filename.
declare -A GITHUB_LICENSES

# Tools
GITHUB_LICENSES["kickstart-nvim"]="https://github.com/nvim-lua/kickstart.nvim/blob/master/LICENSE.md"
GITHUB_LICENSES["starship"]="https://github.com/starship/starship/blob/v1.23.0/LICENSE"
GITHUB_LICENSES["neovim"]="https://github.com/neovim/neovim/blob/v0.11.3/LICENSE.txt"
GITHUB_LICENSES["fzf"]="https://github.com/junegunn/fzf/blob/v0.64.0/LICENSE"
GITHUB_LICENSES["ripgrep"]="https://github.com/BurntSushi/ripgrep/blob/14.1.1/UNLICENSE"
GITHUB_LICENSES["static-curl_mit"]="https://github.com/stunnel/static-curl/blob/8.15.0/LICENSE"
GITHUB_LICENSES["static-curl_curl"]="https://github.com/curl/curl/blob/curl-8_15_0/COPYING"
GITHUB_LICENSES["lnav"]="https://github.com/tstack/lnav/blob/v0.13.0/LICENSE"
GITHUB_LICENSES["erdtree"]="https://github.com/solidiquis/erdtree/blob/v3.1.2/LICENSE"
GITHUB_LICENSES["delta"]="https://github.com/dandavison/delta/blob/0.18.2/LICENSE"
GITHUB_LICENSES["jq"]="https://github.com/jqlang/jq/blob/jq-1.8.1/COPYING"
GITHUB_LICENSES["bat"]="https://github.com/sharkdp/bat/blob/v0.25.0/LICENSE-MIT"
GITHUB_LICENSES["lsd"]="https://github.com/lsd-rs/lsd/blob/v1.1.5/LICENSE"
GITHUB_LICENSES["stylua"]="https://github.com/JohnnyMorganz/StyLua/blob/v0.20.0/LICENSE.md"

# Neovim Plugins
GITHUB_LICENSES["nvim-nio"]="https://github.com/nvim-neotest/nvim-nio/blob/master/LICENCE.md"
GITHUB_LICENSES["friendly-snippets"]="https://github.com/rafamadriz/friendly-snippets/blob/main/LICENSE"
GITHUB_LICENSES["lua-console.nvim"]="https://github.com/YaroSpace/lua-console.nvim/blob/main/LICENSE"
GITHUB_LICENSES["cmp-cmdline"]="https://github.com/hrsh7th/cmp-cmdline/blob/main/LICENSE"
GITHUB_LICENSES["blame.nvim"]="https://github.com/FabijanZulj/blame.nvim/blob/main/LICENSE"
GITHUB_LICENSES["plenary.nvim"]="https://github.com/nvim-lua/plenary.nvim/blob/master/LICENSE"
GITHUB_LICENSES["lazydev"]="https://github.com/folke/lazydev.nvim/blob/main/LICENSE"
GITHUB_LICENSES["cmp_luasnip"]="https://github.com/saadparwaiz1/cmp_luasnip/blob/master/LICENSE"
GITHUB_LICENSES["formatter-nvim"]="https://github.com/mhartington/formatter.nvim/blob/master/LICENSE"
GITHUB_LICENSES["cmp-path"]="https://github.com/hrsh7th/cmp-path/blob/main/LICENSE"
GITHUB_LICENSES["lspkind-nvim"]="https://github.com/onsails/lspkind.nvim/blob/master/LICENSE"
GITHUB_LICENSES["gitsigns"]="https://github.com/lewis6991/gitsigns.nvim/blob/main/LICENSE"
GITHUB_LICENSES["lazy-nvim"]="https://github.com/folke/lazy.nvim/blob/main/LICENSE"
GITHUB_LICENSES["FixCursorHold.nvim"]="https://github.com/antoinemadec/FixCursorHold.nvim/blob/master/LICENSE"
GITHUB_LICENSES["neogit"]="https://github.com/NeogitOrg/neogit/blob/master/LICENSE"
GITHUB_LICENSES["mason-lspconfig-nvim"]="https://github.com/mason-org/mason-lspconfig.nvim/blob/main/LICENSE"
GITHUB_LICENSES["lualine-nvim"]="https://github.com/nvim-lualine/lualine.nvim/blob/master/LICENSE"
GITHUB_LICENSES["nvim-web-devicons"]="https://github.com/nvim-tree/nvim-web-devicons/blob/master/LICENSE"
GITHUB_LICENSES["mason-nvim"]="https://github.com/mason-org/mason.nvim/blob/main/LICENSE"
GITHUB_LICENSES["legendary"]="https://github.com/mrjones2014/legendary.nvim/blob/master/LICENSE"
#GITHUB_LICENSES["vim-sleuth"]="https://github.com/tpope/vim-sleuth/blob/master/LICENSE"
GITHUB_LICENSES["snacks-nvim"]="https://github.com/folke/snacks.nvim/blob/main/LICENSE"
GITHUB_LICENSES["nvim-treesitter"]="https://github.com/nvim-treesitter/nvim-treesitter/blob/master/LICENSE"
GITHUB_LICENSES["nvim-lightbulb"]="https://github.com/kosayoda/nvim-lightbulb/blob/master/LICENSE"
GITHUB_LICENSES["which-key-nvim"]="https://github.com/folke/which-key.nvim/blob/main/LICENSE"
GITHUB_LICENSES["nvim-dap"]="https://github.com/mfussenegger/nvim-dap/blob/master/LICENSE.txt"
GITHUB_LICENSES["diffview.nvim"]="https://github.com/sindrets/diffview.nvim/blob/main/LICENSE"
GITHUB_LICENSES["cmp-buffer"]="https://github.com/hrsh7th/cmp-buffer/blob/main/LICENSE"
GITHUB_LICENSES["nvim-lspconfig"]="https://github.com/neovim/nvim-lspconfig/blob/master/LICENSE.md"
GITHUB_LICENSES["luasnip"]="https://github.com/L3MON4D3/LuaSnip/blob/master/LICENSE"
GITHUB_LICENSES["nvim-lint"]="https://github.com/mfussenegger/nvim-lint/blob/master/LICENSE.txt"
GITHUB_LICENSES["nvim-dap-ui"]="https://github.com/rcarriga/nvim-dap-ui/blob/master/LICENCE.md"
GITHUB_LICENSES["cmp-nvim-lsp"]="https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/LICENSE"
GITHUB_LICENSES["vim-rhubarb"]="https://github.com/tpope/vim-rhubarb/blob/master/LICENSE"
GITHUB_LICENSES["nvim-cmp"]="https://github.com/hrsh7th/nvim-cmp/blob/main/LICENSE"
GITHUB_LICENSES["neotest"]="https://github.com/nvim-neotest/neotest/blob/master/LICENCE.md"
GITHUB_LICENSES["kulala.nvim"]="https://github.com/mistweaverco/kulala.nvim/blob/main/LICENSE"
GITHUB_LICENSES["jsregexp"]="https://github.com/kmarius/jsregexp/blob/master/LICENSE"
GITHUB_LICENSES["lua-language-server"]="https://github.com/LuaLS/lua-language-server/blob/master/LICENSE"
GITHUB_LICENSES["shellcheck"]="https://github.com/koalaman/shellcheck/blob/master/LICENSE"
GITHUB_LICENSES["tmux"]="https://github.com/tmux/tmux/blob/3.5a/COPYING"
GITHUB_LICENSES["build-static-tmux"]="https://github.com/mjakob-gh/build-static-tmux/blob/v3.5d/LICENSE"
#GITHUB_LICENSES["vim-fugitive"]="https://github.com/tpope/vim-fugitive/blob/master/LICENSE"

# not actually distributing those in the artifact, but include the licenses anyways just to be sure
GITHUB_LICENSES["basedpyright"]="https://github.com/DetachHead/basedpyright/blob/main/LICENSE.txt"
GITHUB_LICENSES["nvim-dap-python"]="https://github.com/mfussenegger/nvim-dap-python/blob/master/LICENSE.txt"
GITHUB_LICENSES["neotest-python"]="https://github.com/nvim-neotest/neotest-python/blob/master/LICENCE.md"
GITHUB_LICENSES["opencode.nvim"]="https://github.com/NickvanDyke/opencode.nvim/blob/main/LICENSE"
GITHUB_LICENSES["copilot.lua"]="https://github.com/zbirenbaum/copilot.lua/blob/master/LICENSE"
GITHUB_LICENSES["copilot-cmp"]="https://github.com/zbirenbaum/copilot-cmp/blob/master/LICENSE"
GITHUB_LICENSES["copilot-lualine"]="https://github.com/AndreM222/copilot-lualine/blob/main/LICENSE"
GITHUB_LICENSES["codecompanion.nvim"]="https://github.com/olimorris/codecompanion.nvim/blob/main/LICENSE"
GITHUB_LICENSES["render-markdown.nvim"]="https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/main/LICENSE"
GITHUB_LICENSES["mcphub.nvim"]="https://github.com/ravitemer/mcphub.nvim/blob/main/LICENSE.md"

# --- Configuration: Canonical Licenses ---
# For licenses like the Vim License, which are referenced but not included.
declare -A CANONICAL_LICENSE_URLS
# The raw text of the Vim license from the official Vim repository.
CANONICAL_LICENSE_URLS["vim-license"]="https://raw.githubusercontent.com/vim/vim/master/runtime/doc/uganda.txt"

declare -A COMPONENTS_BY_CANONICAL_LICENSE
# Space-separated list of components using the Vim License.
COMPONENTS_BY_CANONICAL_LICENSE["vim-license"]="vim-sleuth"

# --- Main Script Logic ---

echo "Creating licenses directory: ${LICENSES_DIR}"
mkdir -p "$LICENSES_DIR"


echo -e "\n--- Downloading and Distributing Canonical Licenses ---"
for license_type in "${!COMPONENTS_BY_CANONICAL_LICENSE[@]}"; do
    url="${CANONICAL_LICENSE_URLS[$license_type]}"
    components="${COMPONENTS_BY_CANONICAL_LICENSE[$license_type]}"

    # Download the canonical license text once
    canonical_filename="_canonical.${license_type}.txt"
    echo "Fetching canonical license '${license_type}' from ${url}"
    wget -q -O "${LICENSES_DIR}/${canonical_filename}" "$url" || { echo "ERROR: Failed to download canonical license ${license_type}"; exit 1; }

    # Copy the canonical license for each component that uses it
    for component in $components; do
        output_path="${LICENSES_DIR}/${component}.LICENSE.txt"
        echo "  -> Applying to '${component}'"
        cp "${LICENSES_DIR}/${canonical_filename}" "$output_path"
    done
done

# Process all GitHub-hosted licenses
echo -e "\n--- Downloading GitHub Licenses ---"
for component in "${!GITHUB_LICENSES[@]}"; do
    url="${GITHUB_LICENSES[$component]}"

    # Convert GitHub blob URL to raw content URL
    # from: https://github.com/user/repo/blob/branch/file
    # to:   https://raw.githubusercontent.com/user/repo/branch/file
    download_url=$(echo "$url" | sed -e 's|github.com|raw.githubusercontent.com|' -e 's|/blob/|/|')

    # Get the original filename from the URL to preserve the extension
    filename=$(basename "$url")
    output_path="${LICENSES_DIR}/${component}.${filename}"

    echo "Fetching license for '${component}'..."
    wget -q -O "$output_path" "$download_url" || { echo "ERROR: Failed to download ${component} from ${download_url}"; exit 1; }
done

# Process special cases that are not on GitHub or have a different format
echo -e "\n--- Downloading Other Licenses ---"


## Spelling Dictionaries (FTP)
## don't include spell files - difficult to meet GPL source distribution requirements.
#echo "Fetching license for 'vim-spell-readme'..."
#wget -q -O "${LICENSES_DIR}/vim-spell.README.txt" "https://ftp.nluug.nl/pub/vim/runtime/spell/README.txt"
#
#echo "Fetching license for 'vim-spell-en'..."
#wget -q -O "${LICENSES_DIR}/vim-spell.README_en.txt" "https://ftp.nluug.nl/pub/vim/runtime/spell/README_en.txt"
#
#echo "Fetching license for 'vim-spell-de'..."
#wget -q -O "${LICENSES_DIR}/vim-spell.README_de.txt" "https://ftp.nluug.nl/pub/vim/runtime/spell/README_de.txt"

echo -e "\n\nLicense fetching complete."
echo "All licenses have been downloaded to the '${LICENSES_DIR}/' directory."
