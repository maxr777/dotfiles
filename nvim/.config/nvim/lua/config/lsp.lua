local M = {}

local servers = { "lua_ls", "clangd", "ts_ls", "html" }
local lsp_group = vim.api.nvim_create_augroup("native-lsp", { clear = true })
local lsp_enabled = true

vim.lsp.config("*", {
	root_markers = { ".git" },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
})

vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local opts = { buffer = ev.buf }

		vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
			desc = "Code action",
		}))
		vim.keymap.set("n", "gri", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, {
			desc = "Go to implementation",
		}))
		vim.keymap.set("n", "grr", vim.lsp.buf.references, vim.tbl_extend("force", opts, {
			desc = "Show references",
		}))
		vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, {
			desc = "Go to type definition",
		}))
		vim.keymap.set("n", "grx", vim.lsp.codelens.run, vim.tbl_extend("force", opts, {
			desc = "Run code lens",
		}))
		vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, vim.tbl_extend("force", opts, {
			desc = "Document symbols",
		}))

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf)
		end
	end,
})

local function clear_all_diagnostics()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		vim.diagnostic.reset(nil, buf)
	end
end

local function set_lsp_enabled(enabled)
	for _, server in ipairs(servers) do
		vim.lsp.enable(server, enabled)
	end

	if enabled then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				vim.api.nvim_exec_autocmds("FileType", {
					buffer = buf,
					modeline = false,
				})
			end
		end
		vim.notify("LSP enabled", vim.log.levels.INFO)
		return
	end

	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop(true)
	end
	clear_all_diagnostics()
	vim.notify("LSP disabled", vim.log.levels.WARN)
end

function M.toggle()
	lsp_enabled = not lsp_enabled
	set_lsp_enabled(lsp_enabled)
end

function M.is_enabled()
	return lsp_enabled
end

vim.lsp.enable(servers)

return M
