local lsp = {}

function lsp.plugins(use)
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim")
	use("stevearc/aerial.nvim")
end

function lsp.setup()
	if lsp.should_format() then
		require("null-ls").setup()
	end
end

function lsp.on_attach(_, bufnr)
	-- function signature
	require("lsp_signature").on_attach({
		bind = true,
		max_width = vim.fn.winwidth(bufnr),
		padding = " ",
		hint_enable = false,
		hi_parameter = "LspSignatureActiveParameter",
		toggle_key = "<C-k>",
		select_signature_key = "<C-j>",
	}, bufnr)

	-- autocomplete
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- mapping
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gD", vim.lsp.buf.declaration, opts)
	map("n", "gT", vim.lsp.buf.type_definition, opts)
	map("n", "K", vim.lsp.buf.hover, opts)
	map("n", "<leader>cf", vim.lsp.buf.format, opts)
	map("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
	map("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
	map("n", "<leader>rr", "<CMD>LspRestart<CR>", opts)
	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	map("n", "<leader>s", "<CMD>Telescope lsp_document_symbols<CR>", opts)
	map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	map("x", "<leader>ca", "<CMD>'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)

	map("n", "<leader>cf", function()
		vim.lsp.buf.format({ async = true, bufnr = bufnr })
	end, opts)
end

function lsp.default_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function lsp.should_format()
	if vim.b.should_format ~= nil then
		return vim.b.should_format
	end

	if vim.g.should_format ~= nil then
		return vim.g.should_format
	end

	return true
end

return lsp