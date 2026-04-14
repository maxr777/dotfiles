vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "100"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.clipboard = "xclip"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "popup" }
vim.opt.autoread = true

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

local function smart_tab()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.get()
			return ""
		end
	end
	local col = vim.fn.col(".") - 1
	local line = vim.fn.getline(".")
	local char_before = line:sub(col, col)
	local before_cursor = line:sub(1, col)
	if col == 0 or char_before:match("%s") then
		return "<Tab>"
	elseif before_cursor:match("[%w%._/-]*/$") then
		-- File path completion for paths ending in /
		return "<C-x><C-f>"
	else
		-- Use default completion
		return "<C-n>"
	end
end

-- Move selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center cursor' })

-- Keep cursor centered when cycling through search results
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result and center cursor' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result and center cursor' })

-- Select all
vim.keymap.set('n', '<leader>a', 'gg<S-v>G', { desc = 'Select all' })

vim.keymap.set('n', '<leader>d', '"_dd', { desc = 'Delete line without yanking' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete selection without yanking' })

vim.keymap.set('n', '<leader>r', ':!./run.sh<CR>', { desc = 'Run run.sh' })
vim.keymap.set('n', '<leader>m', ':!gcc main.c && ./a.out<CR>', { desc = 'Build and run' })

vim.keymap.set('n', 'S', ':%s//g<Left><Left>', { noremap = true, desc = 'Substitute in current buffer' })

vim.keymap.set('n', '<leader>c', ':!cppcheck --enable=all --suppress=missingIncludeSystem %<CR>', { desc = 'Run cppcheck' })

vim.keymap.set("i", "<Tab>", smart_tab, { expr = true, desc = "Smart Tab - LSP completion" })
vim.keymap.set("i", "<S-Tab>", "<C-p>", { desc = "Previous completion" })

vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { noremap = true, silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { noremap = true, silent = true, desc = "Increase window width" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, desc = "Move to right window" })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false 

vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Outdent selection" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, desc = "Exit terminal mode" })

vim.keymap.set("n", "<F5>", function()
	vim.cmd.packadd("nvim.undotree")
	vim.cmd.Undotree()
end, { desc = "Toggle undo tree" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldopen = "jump,mark,search,tag"


vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>i", function()
	require("nvim-tree.api").filter.git.ignored.toggle()
end, { noremap = true, silent = true, desc = "Toggle gitignored files" })

vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("n", "<F8>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true, desc = "Toggle horizontal terminal" })
vim.keymap.set("t", "<F7>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<F8>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true, desc = "Toggle horizontal terminal" })


vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
local function lsp_rename_with_autosave()
	vim.lsp.buf.rename()
	
	-- Small delay to let the rename complete, then save all modified buffers
	vim.defer_fn(function()
		local current_buf = vim.api.nvim_get_current_buf()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd('write')
				end)
			end
		end
		-- Return to original buffer
		vim.api.nvim_set_current_buf(current_buf)
	end, 100)
end

vim.keymap.set("n", "grn", lsp_rename_with_autosave, { desc = "Rename symbol" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })

vim.keymap.set("n", "<leader>ld", function()
	vim.diagnostic.open_float(0, {
		scope = "line",
		border = "rounded",
		max_width = 80,
		focus = false,
		source = "if_many",
	})
end, { desc = "Show diagnostics in floating window" })

vim.keymap.set("n", "<leader>lx", function()
	require("config.lsp").toggle()
end, { desc = "Toggle LSP" })

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

require("config.pack")
require("config.lsp")

vim.o.background = "dark"
vim.cmd.colorscheme("quiet")

vim.g.qs_hi_priority = 2

local function set_quick_scope_colors()
	vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#e0e0e0", underline = true })
	vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#e0e0e0", underline = true })
end

local function set_which_key_colors()
	vim.api.nvim_set_hl(0, "WhichKeyNormal", { fg = "#f2f2f2", bg = "#202020" })
	vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#505050", bg = "#202020" })
	vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = "#f2f2f2", bg = "#202020", bold = true })
	vim.api.nvim_set_hl(0, "WhichKey", { fg = "#f2f2f2", bg = "#202020", bold = true })
	vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#f2f2f2", bg = "#202020", bold = true })
	vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#f2f2f2", bg = "#202020" })
	vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#9a9a9a", bg = "#202020" })
	vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = "#c0c0c0", bg = "#202020" })
	vim.api.nvim_set_hl(0, "WhichKeyFloat", { fg = "#f2f2f2", bg = "#202020" })
end

local function set_completion_colors()
	vim.api.nvim_set_hl(0, "Pmenu", { fg = "#f2f2f2", bg = "#202020" })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#f2f2f2", bg = "#303030", bold = true })
	vim.api.nvim_set_hl(0, "PmenuKind", { fg = "#d0d0d0", bg = "#202020" })
	vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = "#f2f2f2", bg = "#303030", bold = true })
	vim.api.nvim_set_hl(0, "PmenuExtra", { fg = "#b0b0b0", bg = "#202020" })
	vim.api.nvim_set_hl(0, "PmenuExtraSel", { fg = "#dcdcdc", bg = "#303030" })
	vim.api.nvim_set_hl(0, "PmenuMatch", { fg = "#ffffff", bg = "#202020", bold = true })
	vim.api.nvim_set_hl(0, "PmenuMatchSel", { fg = "#ffffff", bg = "#303030", bold = true })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#252525" })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#505050" })
end

local qs_group = vim.api.nvim_create_augroup("qs_colors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = qs_group,
	callback = function()
		set_quick_scope_colors()
		set_which_key_colors()
		set_completion_colors()
	end,
})
set_quick_scope_colors()
set_which_key_colors()
set_completion_colors()
