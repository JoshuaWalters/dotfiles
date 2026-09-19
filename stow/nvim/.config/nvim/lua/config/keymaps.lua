-- Diagnostic
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, {
        border = "rounded",
        scope = "cursor",
    })
end, { desc = "Open diagnostic float" } )

-- LSP
vim.keymap.set("n", "<leader>d", function()
    vim.lsp.buf.hover({
        border = "rounded",
    })
end, { desc = "Open LSP float" } )
