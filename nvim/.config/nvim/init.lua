vim.opt.relativenumber = true -- Relative line numbers
vim.opt.number = true
vim.opt.scrolloff = 8 -- Keep cursor 8 lines from screen edge while scrolling
vim.opt.signcolumn = "yes" -- Always show sign column for LSP diagnostics
vim.opt.updatetime = 250 -- Faster updates for gitsigns and diagnostics
vim.opt.timeoutlen = 300 -- Shorter timeout for which-key
vim.opt.colorcolumn = "80"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"

-- Context-aware Tab completion function (no LSP)
local function smart_tab()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	local col = vim.fn.col(".") - 1
	local line = vim.fn.getline(".")
	local char_before = line:sub(col, col)
	local before_cursor = line:sub(1, col)
	if col == 0 or char_before:match("%s") then
		return "<Tab>"
	elseif before_cursor:match("[%w%._/-]*[/.]$") then
		return "<C-x><C-f>"
	else
		return "<C-n>" -- Just keyword completion, no LSP
	end
end

-- Set up the keymaps
vim.keymap.set("i", "<Tab>", smart_tab, { expr = true, desc = "Smart Tab completion" })
vim.keymap.set("i", "<S-Tab>", "<C-p>", { desc = "Previous completion" })

-- Optional: Tab in normal mode (enters insert mode first)
vim.keymap.set("n", "<Tab>", function()
	return "a" .. smart_tab()
end, { expr = true, desc = "Smart Tab in normal mode" })

-- Optional: LSP completion on separate key
vim.keymap.set("i", "<C-j>", "<C-x><C-o>", { desc = "LSP completion" })

-- Resize splits
vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { noremap = true, silent = true })

-- Split switching
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Indent selection
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Map <Esc> in terminal mode to switch to normal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- undotree
vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true })

-- Search settings
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Unless uppercase is present
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true }) -- Esc clears the search highlight without canceling the search

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- ToggleTerm
vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<F8>", "<cmd>ToggleTerm direction=vertical<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<F7>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<F8>", "<cmd>ToggleTerm direction=vertical<cr>", { noremap = true, silent = true })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

vim.keymap.set("n", "<leader>ld", function()
	vim.diagnostic.open_float(nil, { border = "rounded", max_width = 80 })
end, { desc = "Show diagnostics in floating window" })

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	signs = true,
	severity_sort = true,
	float = {
		source = "always",
		header = "",
		prefix = "",
	},
})

require("config.lazy")
