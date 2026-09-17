vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
        border = "rounded",
        focusable = false,
        scope = "cursor",
    })
  end,
})
