return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "lua_ls",
            "rust_analyzer",
            "svelte",
            "vtsls",
        },
    },
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {},
        },
        "neovim/nvim-lspconfig",
    },
}
