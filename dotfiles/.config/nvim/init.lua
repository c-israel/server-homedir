vim.g.mapleader = " " -- Set leader to space
vim.g.maplocalleader = " " -- Set leader to space
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.opt.backup = false -- Disable backup
vim.opt.shelltemp = false -- Disable shell temp
vim.opt.foldlevelstart = 99 -- start with all folds open

vim.opt.smartindent = true -- Default: false
vim.opt.tabstop = 2 -- Default: 8
vim.opt.shiftwidth = 2 -- Default: 8
vim.opt.softtabstop = 2 -- Default: 0
vim.opt.expandtab = true     -- indentation uses spaces

vim.opt.backup = false -- Disable backup
vim.opt.undofile = true -- Enable persistent undo

vim.o.number = true -- show line numbers
vim.o.clipboard = "" -- DON'T sync clipboard
vim.o.breakindent = true -- maintain indent level when line wrapping

-- case insensitive search unless \C used
vim.o.ignorecase = true
vim.o.smartcase = true

-- faster UI
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect" -- better completion menu behavior

vim.o.termguicolors = true -- enables 24-bit RGB color

vim.opt.spell = false -- disable by default so we don't block downloading dictionaries
vim.opt.spelllang = { "en", "de" }

vim.cmd("colorscheme desert")

vim.api.nvim_set_keymap("n", "<leader>#", ":noh<CR>", { desc="Clear Search Highlighting"})
vim.api.nvim_set_keymap("n", "ü", "[", { noremap = true, desc="Previous" })
vim.api.nvim_set_keymap("n", "ä", "]", { noremap = true, desc="Next" })
vim.api.nvim_set_keymap("c", "<C-_>", '<C-R>=expand("%:h")<CR>/', { desc="Insert current file's directory path" })

vim.api.nvim_set_keymap("n", "+", "<C-W>+", { desc="Increase Window Height"})
vim.api.nvim_set_keymap("n", "-", "<C-W>-", { desc="Decrease Window Height"})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W>>", { desc="Increase Window Width"})
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W><", { desc="Decrease Window Width"})

-- taken from https://lazy.folke.io/installation
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    config = function ()
      require("legendary").setup({
        keymaps = {
          {'<leader>l', ':Legendary<CR>'},
        },
        extensions = {
          lazy_nvim = true,
        }
      })
    end
  },
  { 'YaroSpace/lua-console.nvim', -- lua repl
    lazy = true,
    opts = {
      buffer = {
        result_prefix = '--[' -- start lua block comment before result
      },
    },
    keys = {
       { "´", function () require("lua-console").toggle_console() end, desc = "lua-console: Toggle Console" },
       { "<Leader>`", desc = "lua-console: Attach To Buffer" },
    }
  },
  { 'kosayoda/nvim-lightbulb', -- shows lightbulb when LSP code action is available
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = {enabled = true},
        virtual_text = {enabled = true, text = "💡", hl_mode = "combine"},
      })
    end
  },
  {'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        numbers = "buffer_id",
      },
    },
  },
  { "mistweaverco/kulala.nvim", -- REST client
     keys = {
       { "<leader>Rs", desc = "Kulala: Send request" },
       { "<leader>Ra", desc = "Kulala: Send all requests" },
       { "<leader>Rb", desc = "Kulala: Open scratchpad" },
     },
     ft = {"http", "rest"},
     opts = {
       global_keymaps = true,
       global_keymaps_prefix = "<leader>R",
       kulala_keymaps_prefix = "",
     },
  },
  {"zbirenbaum/copilot.lua",
    cond = vim.env.NVIM_AI == "1",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        server = { type = "binary", },
      })
    end,
  },
  {"zbirenbaum/copilot-cmp",
    cond = vim.env.NVIM_AI == "1",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  { 'AndreM222/copilot-lualine',
    cond = vim.env.NVIM_AI == "1",
  },
  {"MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }
  },
  { "ravitemer/mcphub.nvim",
    cond = vim.env.NVIM_AI == "1",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua", -- this only runs on installation!
    config = function ()
      require("mcphub").setup({use_bundled_binary = true,})
    end
  },
  {"olimorris/codecompanion.nvim",
    cond = vim.env.NVIM_AI == "1",
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
    keys = { -- suggested keybinds from the getting started documentation
      { "<C-a>", mode={"n", "v"}, "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Action Palette"},
      { "<LocalLeader>a", mode={"n", "v"}, "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat", noremap = true},
      { "ga", mode="v", "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to CodeCompanion Chat", noremap = true},
    },
    dependencies = {
      "ravitemer/mcphub.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { 'NickvanDyke/opencode.nvim',
    cond = vim.env.NVIM_AI == "1" and vim.fn.executable("opencode") == 1,
    config = function()
      -- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }

      -- Required for `opts.auto_reload`
      vim.opt.autoread = true

      -- Recommended keymaps
      vim.keymap.set('n', '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
      vim.keymap.set('n', '<leader>oA', function() require('opencode').ask() end, { desc = 'Ask opencode' })
      vim.keymap.set('n', '<leader>oa', function() require('opencode').ask('@cursor: ') end, { desc = 'Ask opencode about this' })
      vim.keymap.set('v', '<leader>oa', function() require('opencode').ask('@selection: ') end, { desc = 'Ask opencode about selection' })
      vim.keymap.set('n', '<leader>on', function() require('opencode').command('session_new') end, { desc = 'New opencode session' })
      vim.keymap.set('n', '<leader>oy', function() require('opencode').command('messages_copy') end, { desc = 'Copy last opencode response' })
      vim.keymap.set('n', '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, { desc = 'Messages half page up' })
      vim.keymap.set('n', '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, { desc = 'Messages half page down' })
      vim.keymap.set({ 'n', 'v' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select opencode prompt' })

      -- Example: keymap for custom prompt
      vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gh", '<cmd>DiffviewFileHistory<cr>', desc = 'Git: DiffView for the history of the curent file'},
      { "<leader>gc", '<cmd>DiffviewOpen<cr>', desc = 'Git: DiffView for the changes in the current index'},
    },
  },
  { "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>gn", '<cmd>Neogit<cr>', desc = 'Git: open Neogit'},
    },
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    keys = {
      { "<leader>ga", '<cmd>BlameToggle<cr>', desc = 'Git blAme / show Annotations'},
    },
    config = function()
      require('blame').setup {}
    end,
  },
  -- "tpope/vim-fugitive", -- Git (:Git, :Gedit...)
  "tpope/vim-rhubarb", -- GitHub (Omnicompletion, :GBrowse)
  "tpope/vim-sleuth", -- guess
  "lewis6991/gitsigns.nvim", -- shows hints for git added, changed, deleted lines, Git blame,
  "williamboman/mason.nvim", -- Package manager for LSP, DAP, Linter, Formatter
  "williamboman/mason-lspconfig.nvim", -- mason connector to lspconfig
    {"neovim/nvim-lspconfig",  -- LSP client configs
      keys = {
         { "grn", function() vim.lsp.buf.rename() end, desc="LSP: Rename" },
         { "gra", function() vim.lsp.buf.code_action() end, desc="LSP: Code Action" },
         { "grr", function() vim.lsp.buf.references() end, desc="LSP: References" },
         { "gri", function() vim.lsp.buf.implementation() end, desc="LSP: Goto Implementation" },
         { "grt", function() vim.lsp.buf.type_definition() end, desc="LSP: Goto Type Definition" },
         { "gO",  function() vim.lsp.buf.document_symbol() end, desc="LSP: Document Symbol" },
         { "C-s", function() vim.lsp.buf.signature_help() end, mode="i", desc="LSP: Signature Help" },
      }
    },
    { "mfussenegger/nvim-dap",
      keys = {
       { "<F7>", function() require("dap").step_into() end, desc = "DAP: Step Into", mode = "n" },
       { "<F8>", function() require("dap").step_over() end, desc = "DAP: Step Over", mode = "n" },
       { "<S-F8>", function() require("dap").step_out() end, desc = "DAP: Step Out", mode = "n" },
       { "<F9>", function() require("dap").continue() end, desc = "DAP: Continue/Run", mode = "n" },
       { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint", mode = "n" },
       { "<leader>dB",  function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc="DAP: Set Breakpoint" },
       { "<leader>dr",  function() require('dap').repl.open() end, desc="DAP: Open REPL" },
       { "<leader>dl",  function() require('dap').run_last() end, desc="DAP: Run Last" },
      },
      config = function()
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      end,
    },
    { "nvim-neotest/neotest-python",
      cond = vim.env.NVIM_PYTHON_DEV == "1",
    },
    { "mfussenegger/nvim-dap-python",
      cond = vim.env.NVIM_PYTHON_DEV == "1",
      keys = {
        { "<leader>dp", function() require("dap-python").setup("python") end, desc = "DAP: Set Up Python With Currently Active Venv" },
        { "<leader>dP", function() require("dap-python").setup("python3") end, desc = "DAP: Set Up Python With Global Python" },
      }
    },
  {
    "rcarriga/nvim-dap-ui", -- Debugger UI
    dependencies = {
      "mfussenegger/nvim-dap", -- Debug Adapter Protocol client
      "nvim-neotest/nvim-nio", -- Nvim asynchronous IO library
    },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: toggle DAP-UI" },
    },
    config = function ()
      -- close and open window automatically
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  { "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
      },
      config = function()
        local neotest_adapters = {}
        if vim.env.NVIM_PYTHON_DEV == "1" then
          table.insert(neotest_adapters, require("neotest-python")({ dap = { justMyCode = false }, }))
        end
        require("neotest").setup({
          discovery = { enabled = false },
          adapters = neotest_adapters,
        })
      end,
      keys = {
            {"<leader>t", "", desc = "+test"},
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest: Run Tests In File" },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Neotest: Run All Test Files" },
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Neotest: Run Nearest Test" },
            { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Neotest: Run Last Test" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Neotest: Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Neotest: Open Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Neotest: Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end, desc = "Neotest: Stop Test Run" },
               -- Debugging keybindings
            { "<leader>tdt", function() require("neotest").run.run(vim.fn.expand("%"), { strategy = "dap" }) end, desc = "Neotest: Debug File" },
            { "<leader>tdT", function() require("neotest").run.run(vim.uv.cwd(), { strategy = "dap" }) end, desc = "Neotest: Debug All Files" },
            { "<leader>tdr", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Neotest: Debug Nearest" },
            { "<leader>tdl", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Neotest: Debug Last Run" },
          },
      },
  "mfussenegger/nvim-lint",
  "mhartington/formatter.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true }, -- disable syntax on large files
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files", },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep", },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History", },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer", },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers", },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files", },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects", },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent", },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log", },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line", },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash", },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)", },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File", },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep", },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" }, },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
      { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History", },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History", },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands", },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics", },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics", },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages", },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights", },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons", },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps", },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps", },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List", },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks", },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages", },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec", },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume", },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History", },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration", },
      { "<leader>r", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition", },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols", },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols", },
      -- Other
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode", },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom", },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer", },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History", },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" }, },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications", },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal", },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore", },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  "onsails/lspkind.nvim",
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "rafamadriz/friendly-snippets",
      "zbirenbaum/copilot.lua",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- from copilot-cmp install guide
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end

      local cmp_sorting = {}
      if vim.env.NVIM_AI == "1" then
        cmp_sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }
        }
      end

      local cmp_sources = {
        { name = "lazydev" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }
      if vim.env.NVIM_AI == "1" then
        table.insert(cmp_sources, 1, { name = "copilot" })
        table.insert(cmp_sources, { name = 'codecompanion' })
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Add formatting with icons
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Copilot = "", },
            before = function(entry, vim_item)
              return vim_item
            end,
          }),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- from copilot-cmp install guide
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sorting = cmp_sorting,
        sources = cmp.config.sources(cmp_sources),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

if vim.env.NVIM_AI == "1" then
  require("lualine").setup({
    sections = { lualine_x = {'copilot', 'encoding', 'fileformat', 'filetype' }, },
  })
else
  require("lualine").setup()
end

require("mason").setup()

mason_lspconfig_ls_list = {"lua_ls"}

if vim.env.NVIM_PYTHON_DEV == "1" then
    table.insert(mason_lspconfig_ls_list, "basedpyright")
end
require("mason-lspconfig").setup({
  ensure_installed = mason_lspconfig_ls_list,
  automatic_enable = false,
})
require("dapui").setup()

-- Setup LSP with completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

vim.lsp.inlay_hint.enable() -- enable inlay hints by default

-- Setup language servers with completion capabilities
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      -- diagnostics = {
      --  globals = { "vim", "snacks", "Snacks" },
      -- },
      hint = { enable = true}
    },
  },
})
if vim.env.NVIM_PYTHON_DEV == "1" then
    lspconfig.basedpyright.setup {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            inlayHints = {
              enabled = true,
              variableTypes = true,
              functionReturnTypes = true,
              callArgumentNames = "all",
              genericTypes = true,
            },
          },
        },
      },
    }
end

-- Add other language servers as needed following the same pattern

-- nvim-lint - try linting automatically after write
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    --require("lint").try_lint("cspell")
  end,
})

-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    -- Formatter configurations for filetype "lua" go here and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the "lua" filetype
      require("formatter.filetypes.lua").stylua,
    },

    -- Use the special "*" filetype for defining formatter configurations on any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any filetype
      require("formatter.filetypes.any").remove_trailing_whitespace,
      -- Remove trailing whitespace without 'sed'
      -- require("formatter.filetypes.any").substitute_trailing_whitespace,
    },
  },
})
