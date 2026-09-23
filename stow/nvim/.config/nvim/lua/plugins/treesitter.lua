return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").install({
			"bash",
			"lua",
			"rust",
			"toml",
			"svelte",
			"typescript",
			"javascript",
			"html",
			"css",
		})

		-- Start native Neovim Treesitter highlighting for supported buffers
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
