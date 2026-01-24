vim.api.nvim_create_augroup('pencil', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
  group = 'pencil',
  pattern = { 'markdown', 'mkd', 'text' },
  callback = function()
    vim.fn['pencil#init']({ wrap = "soft" })
    -- Markdown styling
    vim.api.nvim_set_hl(0, '@markup.italic', { italic = true })
    vim.api.nvim_set_hl(0, '@markup.raw.block.markdown', { bg = '#1d141e', fg = '#b5a5b7', italic = true })
  end,
})
