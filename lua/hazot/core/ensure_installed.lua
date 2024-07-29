-- Ensure installed plugins
require("hazot.utils").ensure_installed_treesitter =
	{ "vim", "regex", "lua", "bash", "markdown", "markdown_inline", "comment" }
require("hazot.utils").ensure_installed_lsps =
	{ "lua_ls", "rust_analyzer", "jdtls", "basedpyright", "typst_lsp", "tailwindcss" }
require("hazot.utils").ensure_installed_linters = {
	c = { "trivy" },
	cpp = { "trivy" },
	rust = { "trivy" },
	python = { "trivy" },
	java = { "trivy" },
	javascript = { "trivy" },
	typescript = { "trivy" },
}
require("hazot.utils").ensure_installed_formatters = {
	lua = { "stylua" },
	python = { "isort", "black" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	zsh = { "shfmt" },
	c = { "clang_format" },
	cpp = { "clang_format" },
	java = { "google-java-format" },
	typst = { "typstfmt" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	javascriptreact = { "prettier" },
	typescriptreact = { "prettier" },
	svelte = { "prettier" },
	css = { "prettier" },
	html = { "prettier" },
	json = { "prettier" },
	yaml = { "prettier" },
	markdown = { "prettier" },
	graphql = { "prettier" },
}
require("hazot.utils").ensure_installed_daps = { "codelldb" }