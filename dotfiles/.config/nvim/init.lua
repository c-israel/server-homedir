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

vim.api.nvim_set_keymap("n", "<leader>#", ":noh<CR>", {}) -- Clear search highlighting
vim.api.nvim_set_keymap("n", "ü", "[", { noremap = true }) -- qcm navigation
vim.api.nvim_set_keymap("n", "ä", "]", { noremap = true })
-- Insert current file's directory path in command mode
vim.api.nvim_set_keymap("c", "<C-_>", '<C-R>=expand("%:h")<CR>/', {})

vim.api.nvim_set_keymap("n", "+", "<C-W>+", {}) -- Increase window height
vim.api.nvim_set_keymap("n", "-", "<C-W>-", {}) -- Decrease window height
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W>>", {}) -- Increase window width
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W><", {}) -- Decrease window width

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
	"tpope/vim-fugitive", -- Git (:Git, :Gedit...)
	"tpope/vim-rhubarb", -- GitHub (Omnicompletion, :GBrowse)
	"tpope/vim-sleuth",
	"williamboman/mason.nvim", -- Package manager for LSP, DAP, Linter, Formatter
	"williamboman/mason-lspconfig.nvim", -- mason connector to lspconfig
	"neovim/nvim-lspconfig", -- LSP client configs
	{
		"rcarriga/nvim-dap-ui", -- Debugger UI
		dependencies = {
			"mfussenegger/nvim-dap", -- Debug Adapter Protocol client
			"nvim-neotest/nvim-nio", -- Nvim asynchronous IO library
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
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
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
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

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
						if cmp.visible() then
							cmp.select_next_item()
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
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
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

require("lualine").setup()

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
})
require("dapui").setup()

-- Setup LSP with completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- Setup language servers with completion capabilities
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "snacks", "Snacks" },
			},
		},
	},
})
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
