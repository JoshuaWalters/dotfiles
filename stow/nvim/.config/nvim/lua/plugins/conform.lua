return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			svelte = { "prettier" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			rust = { "rustfmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
