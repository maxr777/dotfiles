local plugins = {
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/unblevable/quick-scope",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
}

local pack_group = vim.api.nvim_create_augroup("native-pack", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
	group = pack_group,
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			pcall(vim.cmd.packadd, name)
			pcall(vim.cmd, "TSUpdate")
		end
	end,
})

vim.pack.add(plugins, { load = true, confirm = false })

local function setup_if_available(module_name, fn)
	local ok, mod = pcall(require, module_name)
	if ok then
		fn(mod)
	end
	return ok
end

setup_if_available("Comment", function(mod)
	mod.setup()
end)

setup_if_available("nvim-treesitter.configs", function(mod)
	mod.setup({
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		fold = { enable = true },
	})
end)

setup_if_available("lualine", function(mod)
	local lualine_theme = {
		normal = {
			a = { fg = "#f2f2f2", bg = "#202020", bold = true },
			b = { fg = "#f2f2f2", bg = "#2a2a2a" },
			c = { fg = "#f2f2f2", bg = "#303030" },
		},
		insert = {
			a = { fg = "#f2f2f2", bg = "#202020", bold = true },
			b = { fg = "#f2f2f2", bg = "#2a2a2a" },
			c = { fg = "#f2f2f2", bg = "#303030" },
		},
		visual = {
			a = { fg = "#f2f2f2", bg = "#202020", bold = true },
			b = { fg = "#f2f2f2", bg = "#2a2a2a" },
			c = { fg = "#f2f2f2", bg = "#303030" },
		},
		replace = {
			a = { fg = "#f2f2f2", bg = "#202020", bold = true },
			b = { fg = "#f2f2f2", bg = "#2a2a2a" },
			c = { fg = "#f2f2f2", bg = "#303030" },
		},
		command = {
			a = { fg = "#f2f2f2", bg = "#202020", bold = true },
			b = { fg = "#f2f2f2", bg = "#2a2a2a" },
			c = { fg = "#f2f2f2", bg = "#303030" },
		},
		inactive = {
			a = { fg = "#d0d0d0", bg = "#202020", bold = true },
			b = { fg = "#d0d0d0", bg = "#2a2a2a" },
			c = { fg = "#d0d0d0", bg = "#303030" },
		},
	}

	mod.setup({
		options = {
			theme = lualine_theme,
		},
	})
end)

setup_if_available("nvim-autopairs", function(mod)
	mod.setup()
end)

setup_if_available("toggleterm", function(mod)
	mod.setup({})
end)

setup_if_available("which-key", function(mod)
	mod.setup()
end)

setup_if_available("nvim-tree", function(mod)
	mod.setup({
		filters = {
			git_ignored = true,
		},
		update_focused_file = {
			enable = true,
		},
		view = {
			width = 30,
		},
	})
end)

setup_if_available("conform", function(mod)
	mod.setup({
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			python = { "black" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			html = { "prettier" },
			css = { "prettier" },
		},
	})
end)

setup_if_available("nvim-surround", function(mod)
	mod.setup({})
end)

local telescope_ok, builtin = pcall(require, "telescope.builtin")
if telescope_ok then
	setup_if_available("telescope", function(mod)
		mod.setup({
			defaults = {
				layout_strategy = "vertical",
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
			},
		})
	end)

	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
end
