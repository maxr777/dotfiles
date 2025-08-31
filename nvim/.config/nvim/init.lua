vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "100"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"

vim.opt.autoread = true

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

-- Context-aware tab completion
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
		return "<C-n>"
	end
end

vim.keymap.set("i", "<Tab>", smart_tab, { expr = true, desc = "Smart Tab completion" })
vim.keymap.set("i", "<S-Tab>", "<C-p>", { desc = "Previous completion" })

vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

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

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<F8>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<F7>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<F8>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true })


vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })

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

vim.keymap.set("n", "<leader>lr", lsp_rename_with_autosave, { desc = "Rename symbol" })
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

-- ========================================== color scheme ========================================== 

-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.o.background = 'dark'
vim.g.colors_name = 'mono'

-- Base colors
local colors = {
  bg = '#1a1a1a',        -- Dark background
  fg = '#e0e0e0',        -- Brighter main text for better contrast
  comment = '#777777',   -- Gray for comments (easier navigation) (all 9s or 6s are good too)
  string = '#8dbf88',    -- Grayish green for strings (still visibly green)
  todo = '#88bfd8',      -- Light blue for TODO comments (equivalent of string color)
  cursor = '#cccccc',    -- Lighter cursor that works better with search
  visual = '#404040',    -- Dark gray for visual selection
  line_nr = '#606060',   -- Brighter line numbers
  search = '#4a4a00',    -- Dark yellow background for search matches  
  inc_search = '#666600', -- Brighter yellow background for current search match
  error = '#ff6b6b',     -- Subtle red for errors
  warning = '#ffd93d',   -- Subtle yellow for warnings
}

-- Helper function to set highlights
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor highlights
hl('Normal', { bg = colors.bg, fg = colors.fg })
hl('NormalFloat', { bg = colors.bg, fg = colors.fg })
hl('Cursor', { bg = colors.cursor, fg = colors.bg })
hl('lCursor', { bg = colors.cursor, fg = colors.bg })
hl('CursorLine', { bg = '#252525' })
hl('CursorColumn', { bg = '#252525' })
hl('LineNr', { fg = colors.line_nr })
hl('CursorLineNr', { fg = colors.fg, bold = true })
hl('Visual', { bg = colors.visual })
hl('Search', { bg = colors.search, fg = colors.fg })
hl('IncSearch', { bg = colors.inc_search, fg = colors.fg })
hl('CurSearch', { bg = colors.inc_search, fg = colors.bg, bold = true })

-- Status line
hl('StatusLine', { bg = '#303030', fg = colors.fg })
hl('StatusLineNC', { bg = '#202020', fg = colors.line_nr })

-- Splits
hl('VertSplit', { fg = '#404040' })
hl('WinSeparator', { fg = '#404040' })

-- Tabs
hl('TabLine', { bg = '#202020', fg = colors.line_nr })
hl('TabLineFill', { bg = '#202020' })
hl('TabLineSel', { bg = colors.bg, fg = colors.fg })

-- Popup menu
hl('Pmenu', { bg = '#303030', fg = colors.fg })
hl('PmenuSel', { bg = colors.visual, fg = colors.fg })
hl('PmenuSbar', { bg = '#404040' })
hl('PmenuThumb', { bg = colors.line_nr })

-- Messages and command line
hl('MsgArea', { fg = colors.fg })
hl('ErrorMsg', { fg = colors.error })
hl('WarningMsg', { fg = colors.warning })

-- SYNTAX HIGHLIGHTING - The minimal approach
-- Everything is the default foreground color EXCEPT:

-- 1. Comments (medium gray)
hl('Comment', { fg = colors.comment, italic = true })

-- 2. Strings (slightly brighter than normal text)
hl('String', { fg = colors.string })
hl('Character', { fg = colors.string })

-- 3. For markdown, highlight headers for structure
hl('markdownH1', { fg = colors.fg, bold = true })
hl('markdownH2', { fg = colors.fg, bold = true })
hl('markdownH3', { fg = colors.fg, bold = true })
hl('markdownH4', { fg = colors.fg, bold = true })
hl('markdownH5', { fg = colors.fg, bold = true })
hl('markdownH6', { fg = colors.fg, bold = true })

-- 4. TODO comments (light blue)
hl('Todo', { fg = colors.todo })

-- Set up TODO highlighting in comments
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.fn.matchadd("Todo", "\\c\\<\\(todo\\|fixme\\|hack\\|note\\)\\>")
  end,
})

-- Everything else uses the default foreground color (monochromatic)
local mono_groups = {
  'Constant', 'Number', 'Boolean', 'Float',
  'Identifier', 'Function',
  'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword', 'Exception',
  'PreProc', 'Include', 'Define', 'Macro', 'PreCondit',
  'Type', 'StorageClass', 'Structure', 'Typedef',
  'Special', 'SpecialChar', 'Tag', 'Delimiter', 'SpecialComment', 'Debug',
  'Underlined', 'Ignore'
}

for _, group in ipairs(mono_groups) do
  hl(group, { fg = colors.fg })
end

-- Diagnostics (keep minimal but functional)
hl('DiagnosticError', { fg = colors.error })
hl('DiagnosticWarn', { fg = colors.warning })
hl('DiagnosticInfo', { fg = colors.fg })
hl('DiagnosticHint', { fg = colors.comment })

-- Diff (minimal)
hl('DiffAdd', { bg = '#003300' })
hl('DiffChange', { bg = '#333300' })
hl('DiffDelete', { bg = '#330000' })
hl('DiffText', { bg = '#555500' })

-- Git signs (if using gitsigns.nvim)
hl('GitSignsAdd', { fg = '#606060' })
hl('GitSignsChange', { fg = '#606060' })
hl('GitSignsDelete', { fg = '#606060' })

-- Quick-scope (force consistent background highlighting)
vim.g.qs_hi_priority = 2

-- Quick-scope colors with autocmd to persist
vim.api.nvim_create_augroup('qs_colors', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'qs_colors',
  callback = function()
    -- Underlines (current)
    vim.api.nvim_set_hl(0, 'QuickScopePrimary', { fg = '#e0e0e0', underline = true })
    vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { fg = '#e0e0e0', underline = true })
    
    -- Background focus (alternative - uncomment to use)
    -- vim.api.nvim_set_hl(0, 'QuickScopePrimary', { bg = '#404040', fg = '#e0e0e0' })
    -- vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { bg = '#303030', fg = '#e0e0e0' })
  end,
})

-- Apply quick-scope colors immediately (using direct API calls)
-- Underlines (current)
vim.api.nvim_set_hl(0, 'QuickScopePrimary', { fg = '#e0e0e0', underline = true })
vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { fg = '#e0e0e0', underline = true })

-- Background focus (alternative - uncomment to use)
-- vim.api.nvim_set_hl(0, 'QuickScopePrimary', { bg = '#404040', fg = '#e0e0e0' })
-- vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { bg = '#303030', fg = '#e0e0e0' })

-- Treesitter overrides (ensure monochromatic approach)
hl('@comment', { link = 'Comment' })
hl('@string', { link = 'String' })
hl('@string.documentation', { link = 'Comment' })

-- Everything else monochromatic
local ts_mono_groups = {
  '@variable', '@variable.builtin', '@variable.parameter', '@variable.member',
  '@constant', '@constant.builtin', '@constant.macro',
  '@module', '@module.builtin',
  '@label',
  '@string.regexp', '@string.escape', '@string.special',
  '@character', '@character.special',
  '@number', '@number.float',
  '@boolean',
  '@type', '@type.builtin', '@type.definition',
  '@attribute', '@attribute.builtin',
  '@property',
  '@function', '@function.builtin', '@function.call', '@function.macro',
  '@function.method', '@function.method.call',
  '@constructor',
  '@operator',
  '@keyword', '@keyword.coroutine', '@keyword.function', '@keyword.operator',
  '@keyword.import', '@keyword.type', '@keyword.modifier', '@keyword.repeat',
  '@keyword.return', '@keyword.debug', '@keyword.exception', '@keyword.conditional',
  '@keyword.conditional.ternary', '@keyword.directive', '@keyword.directive.define',
  '@punctuation.delimiter', '@punctuation.bracket', '@punctuation.special',
  '@tag', '@tag.builtin', '@tag.attribute', '@tag.delimiter',
}

for _, group in ipairs(ts_mono_groups) do
  hl(group, { fg = colors.fg })
end

-- ========================================== /color scheme ==========================================
