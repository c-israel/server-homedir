# server-homedir

builds a .tgz file with dotfiles and binaries of useful tools to download and unpack into the home directory of any
server - providing a common work environment

# LICENSE
This repository itself, meaning the code producing the artifact, is provided under the Unlicense. See LICENSE.

The artifact produced by this repository is an aggregate that combines artifacts from projects with various open source licenses:
* [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) 
  [MIT license](https://github.com/nvim-lua/kickstart.nvim/blob/master/LICENSE.md)
  (neovim configuration template)
  <br/> (used mostly as inspiration and maybe some snippets in init.lua)
* [starship](https://github.com/starship/starship/) 
  [v1.23.0](https://github.com/starship/starship/releases/tag/v1.23.0)
  [ISC License](https://github.com/starship/starship/blob/v1.23.0/LICENSE)
  (prompt)
* [neovim](https://github.com/neovim/neovim/) 
  [v0.11.3](https://github.com/neovim/neovim/releases/tag/v0.11.3)
  [Apache 2.0 / Vim License](https://github.com/neovim/neovim/blob/v0.11.3/LICENSE.txt)
  (text editor)
* [fzf](https://github.com/junegunn/fzf/) 
  [v0.64.0](https://github.com/junegunn/fzf/releases/tag/v0.64.0)
  [MIT License](https://github.com/junegunn/fzf/blob/v0.64.0/LICENSE)
  (fuzzy finder, selection tool)
* [ripgrep](https://github.com/BurntSushi/ripgrep/) 
  [14.1.1](https://github.com/BurntSushi/ripgrep/releases/tag/14.1.1)
  [The Unlicense](https://github.com/BurntSushi/ripgrep/blob/14.1.1/UNLICENSE)
  (text search tool)
* [static-curl](https://github.com/stunnel/static-curl/)
  [8.15.0](https://github.com/stunnel/static-curl/releases/tag/8.15.0)
  [MIT License](https://github.com/stunnel/static-curl/blob/8.15.0/LICENSE) and [curl license](https://github.com/curl/curl/blob/curl-8_15_0/COPYING)
* [lnav](https://github.com/tstack/lnav/)
  [v0.13.0](https://github.com/tstack/lnav/releases/tag/v0.13.0)
  [BSD 2-Clause "Simplified" License](https://github.com/tstack/lnav/blob/v0.13.0/LICENSE)
  (log file viewer)
* [erdtree](https://github.com/solidiquis/erdtree/) 
  [v3.1.2](https://github.com/solidiquis/erdtree/releases/tag/v3.1.2)
  [MIT License](https://github.com/solidiquis/erdtree/blob/v3.1.2/LICENSE)
  (shows file tree and disk usage, can search)
* [delta](https://github.com/dandavison/delta)
  [0.18.2](https://github.com/dandavison/delta/releases/tag/0.18.2)
  [MIT License](https://github.com/dandavison/delta/blob/0.18.2/LICENSE)
  (diff tool with syntax highlighting)
* [fd](https://github.com/sharkdp/fd)
  [v10.3.0](https://github.com/sharkdp/fd/releases/tag/v10.3.0)
  [MIT License](https://github.com/sharkdp/fd/blob/v10.3.0/LICENSE-MIT)
  and [Apache 2.0 License](https://github.com/sharkdp/fd/blob/v10.3.0/LICENSE-APACHE)
  (faster `find`)
* [jq](https://github.com/jqlang/jq)
  [1.8.1](https://github.com/jqlang/jq/releases/tag/jq-1.8.1)
  [MIT / CC BY 3.0](https://github.com/jqlang/jq/blob/jq-1.8.1/COPYING)
  (command-line JSON processor)
* [bat](https://github.com/sharkdp/bat/)
  [v0.25.0](https://github.com/sharkdp/bat/releases/tag/v0.25.0)
  [MIT License](https://github.com/sharkdp/bat/blob/v0.25.0/LICENSE-MIT)
  (`cat` with syntax highlighting)
* [lsd](https://github.com/lsd-rs/lsd)
  [v1.1.5](https://github.com/lsd-rs/lsd/releases/tag/v1.1.5) 
  [Apache 2.0](https://github.com/lsd-rs/lsd/blob/v1.1.5/LICENSE)
  (`ls` with added features)
* [StyLua](https://github.com/JohnnyMorganz/StyLua/)
  [v0.20.0](https://github.com/JohnnyMorganz/StyLua/releases/tag/v0.20.0)
  [MPL 2.0](https://github.com/JohnnyMorganz/StyLua/blob/v0.20.0/LICENSE.md)
  (lua formatter)
* [tmux](https://github.com/tmux/tmux)
  via [build-static-tmux](https://github.com/mjakob-gh/build-static-tmux)
  [3.5a](https://github.com/tmux/tmux/releases/tag/3.5a)
  / [3.5d](https://github.com/mjakob-gh/build-static-tmux/releases/tag/v3.5d)
  / [3.1c](https://github.com/tmux/tmux/releases/tag/3.1c)
  / [3.1d](https://github.com/mjakob-gh/build-static-tmux/releases/tag/v3.1d)
  [ISC License](https://github.com/tmux/tmux/blob/3.5a/COPYING)
  and [MIT License](https://github.com/mjakob-gh/build-static-tmux/blob/v3.5d/LICENSE)
  (terminal multiplexer)
 

Neovim plugins are included as well:
* [nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio) 
  [MIT License](https://github.com/nvim-neotest/nvim-nio/blob/master/LICENCE.md)
  asyncio library (dependency of other plugins)
* [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) 
  [MIT License](https://github.com/rafamadriz/friendly-snippets/blob/main/LICENSE)
  snippets collection (see cmp_luasnip below)
* [YaroSpace/lua-console.nvim](https://github.com/YaroSpace/lua-console.nvim/)
  [Apache 2.0 License](https://github.com/YaroSpace/lua-console.nvim/blob/main/LICENSE)
  lua scratch pad
* [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) 
  [MIT License](https://github.com/hrsh7th/cmp-cmdline/blob/main/LICENSE)
  completion source for vim commandline
* [FabijanZulj/blame.nvim](https://github.com/FabijanZulj/blame.nvim/)
  [MIT License](https://github.com/FabijanZulj/blame.nvim/blob/main/LICENSE)
  git blame visualizer
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/)
  [MIT License](https://github.com/nvim-lua/plenary.nvim/blob/master/LICENSE)
  library (dependency of other plugins)
* [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim/)
  [Apache 2.0 License](https://github.com/folke/lazydev.nvim/blob/main/LICENSE)
  language server config for neovim config/plugins
* [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) 
  [Apache 2.0 License](https://github.com/saadparwaiz1/cmp_luasnip/blob/master/LICENSE)
  completion source for snippets (see LuaSnip below)
* [mhartington/formatter.nvim](https://github.com/mhartington/formatter.nvim) 
  [MIT License](https://github.com/mhartington/formatter.nvim/blob/master/LICENSE)
  code formatter runner
* [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path) 
  [MIT License](https://github.com/hrsh7th/cmp-path/blob/main/LICENSE)
  completion source for filesystem paths
* [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim) 
  [MIT License](https://github.com/onsails/lspkind.nvim/blob/master/LICENSE)
  shows completion kind as icon in completion menu
* [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
  [MIT License](https://github.com/lewis6991/gitsigns.nvim/blob/main/LICENSE)
  shows changed/deleted/added lines in sign column
* [folke/lazy.nvim](https://github.com/folke/lazy.nvim) 
  [Apache 2.0 License](https://github.com/folke/lazy.nvim/blob/main/LICENSE)
  plugin manager
* [antoinemadec/FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim/)
  [MIT License](https://github.com/antoinemadec/FixCursorHold.nvim/blob/master/LICENSE)
  dependency of neotest (probably not necessary with the included neovim version)
* [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit/)
  [MIT License](https://github.com/NeogitOrg/neogit/blob/master/LICENSE)
  git interface
* [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) 
  [Apache 2.0 License](https://github.com/mason-org/mason-lspconfig.nvim/blob/main/LICENSE)
  allows automatic LSP installation
* [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) 
  [MIT License](https://github.com/nvim-lualine/lualine.nvim/blob/master/LICENSE)
  statusline
* [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) 
  [MIT License](https://github.com/nvim-tree/nvim-web-devicons/blob/master/LICENSE)
  nerd font icons (dependency of other plugins)
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) 
  [Apache 2.0 License](https://github.com/mason-org/mason.nvim/blob/main/LICENSE)
  package manager (LSP/DAP servers, linters, formatters)
* [legendary](https://github.com/mrjones2014/legendary.nvim)
  [MIT License](https://github.com/mrjones2014/legendary.nvim/blob/master/LICENSE)
  allows searching for key bindings
* [tpope/vim-sleuth](https://github.com/tpope/vim-sleuth) 
  [Vim License](https://vimdoc.sourceforge.net/htmldoc/uganda.html#license)
  automatically sets shiftwidth, expandtab
* [folke/snacks.nvim](https://github.com/folke/snacks.nvim) 
  [Apache 2.0 License](https://github.com/folke/snacks.nvim/blob/main/LICENSE)
  collection of plugins, fuzzy-finder picker
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 
  [Apache 2.0 License](https://github.com/nvim-treesitter/nvim-treesitter/blob/master/LICENSE)
  treesitter parser support (for highlights, indents, folds, ...)
* [kosayoda/nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb/)
  [MIT License](https://github.com/kosayoda/nvim-lightbulb/blob/master/LICENSE)
  shows 💡 where LSP code action is available
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim) 
  [Apache 2.0 License](https://github.com/folke/which-key.nvim/blob/main/LICENSE)
  shows available keybindings
* [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) 
  [GNU GPL v3.0](https://github.com/mfussenegger/nvim-dap/blob/master/LICENSE.txt)
  Debug Adapter Protocol client
* [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim/)
  [GNU GPL v3.0](https://github.com/sindrets/diffview.nvim/blob/main/LICENSE)
  diff and merge tool
* [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) 
  [MIT License](https://github.com/hrsh7th/cmp-buffer/blob/main/LICENSE)
  completion source for words in the buffer
* [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) 
  [Apache 2.0 License](https://github.com/neovim/nvim-lspconfig/blob/master/LICENSE.md)
  adds default LSP client configurations
* [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) 
  [Apache 2.0 License](https://github.com/L3MON4D3/LuaSnip/blob/master/LICENSE) 
  snippet completion engine  
  which depends on 
  * [jsregexp](https://github.com/kmarius/jsregexp/tree/master)
    [MIT License](https://github.com/kmarius/jsregexp/blob/master/LICENSE)
* [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) 
  [GNU GPL v3.0](https://github.com/mfussenegger/nvim-lint/blob/master/LICENSE.txt)
  linter plugin
* [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) 
  [MIT License](https://github.com/rcarriga/nvim-dap-ui/blob/master/LICENCE.md)
  Debugger UI for `nvim-dap`
* [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) 
  [MIT License](https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/LICENSE)
  completion source for the LSP client
* [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb) 
  [MIT License](https://github.com/tpope/vim-rhubarb/blob/master/LICENSE)
  GitHub browsing and completion
* [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) 
  [MIT License](https://github.com/hrsh7th/nvim-cmp/blob/main/LICENSE)
  completion engine
* [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest/)
  [MIT License](https://github.com/nvim-neotest/neotest/blob/master/LICENCE.md)
  testing framework
* [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod)
  [Vim License](https://vimdoc.sourceforge.net/htmldoc/uganda.html#license)
  database interface
* [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)
  [MIT License](https://github.com/kristijanhusak/vim-dadbod-ui/blob/master/LICENSE)
  UI for working with databases
* [kristijanhusak/vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion)
  [MIT License](https://github.com/kristijanhusak/vim-dadbod-completion/blob/master/LICENSE)
  database auto completion
* [mistweaverco/kulala.nvim](https://github.com/mistweaverco/kulala.nvim)
  [MIT License](https://github.com/mistweaverco/kulala.nvim/blob/main/LICENSE)
  REST client
* [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
  [MIT License](https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/main/LICENSE)
  renders Markdown
* [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
  [GNU GPL v3.0](https://github.com/akinsho/bufferline.nvim/blob/main/LICENSE)
  shows open buffers at the top of the window
* [lewis6991/satellite.nvim](https://github.com/lewis6991/satellite.nvim)
  [MIT License](https://github.com/lewis6991/satellite.nvim/blob/main/LICENSE)
  scroll bar
* [soulis-1256/eagle.nvim](https://github.com/soulis-1256/eagle.nvim)
  [Apache 2.0 License](https://github.com/soulis-1256/eagle.nvim/blob/main/LICENSE)
  mouse hover
* [lua-language-server](https://github.com/LuaLS/lua-language-server)
  [MIT License](https://github.com/LuaLS/lua-language-server/blob/master/LICENSE)
  language server for lua
* [shellcheck](https://github.com/koalaman/shellcheck)
  [GNU GPL v3.0](https://github.com/koalaman/shellcheck/blob/master/LICENSE)
  tool for checking bash scripts

Additionally, by running NeoVim with environment variable `NVIM_PYTHON_DEV` set to `1`, `basedpyright`, `nvim-dap-python` and `neotest-python` will be installed and set up.
But those components are not currently included in the artifact built by this repository.  
Nevertheless, here are the links to the relevant repositories and licenses:
* [basedpyright](https://github.com/detachhead/basedpyright)
  [MIT License](https://github.com/DetachHead/basedpyright/blob/main/LICENSE.txt)
* [mfussenegger/nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)
  [GNU GPL v3.0](https://github.com/mfussenegger/nvim-dap-python/blob/master/LICENSE.txt)
* [nvim-neotest/neotest-python](https://github.com/nvim-neotest/neotest-python)
  [MIT License](https://github.com/nvim-neotest/neotest-python/blob/master/LICENCE.md)

Similarly, by running NeoVim with the environment variable `NVIM_AI` set to `1`, AI plugins will be installed and set up.
That is, `NickvanDyke/opencode.nvim` (only if `opencode` is on the PATH), `zbirenbaum/copilot.lua` 
and `zbirenbaum/copilot-cmp`, `AndreM222/copilot-lualine`, `olimorris/codecompanion.nvim` and its dependency
`ravitemer/mcphub.nvim`.
Here are the license links to those:

* [NickvanDyke/opencode.nvim](https://github.com/NickvanDyke/opencode.nvim)
  [MIT License](https://github.com/NickvanDyke/opencode.nvim/blob/main/LICENSE)
* [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)
  [MIT License](https://github.com/zbirenbaum/copilot.lua/blob/master/LICENSE)
* [zbirenbaum/copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)
  [MIT License](https://github.com/zbirenbaum/copilot-cmp/blob/master/LICENSE)
* [AndreM222/copilot-lualine](https://github.com/AndreM222/copilot-lualine)
  [MIT License](https://github.com/AndreM222/copilot-lualine/blob/main/LICENSE)
* [olimorris/codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
  [MIT License](https://github.com/olimorris/codecompanion.nvim/blob/main/LICENSE)
* [ravitemer/mcphub.nvim](https://github.com/ravitemer/mcphub.nvim)
  [MIT License](https://github.com/ravitemer/mcphub.nvim/blob/main/LICENSE.md)
