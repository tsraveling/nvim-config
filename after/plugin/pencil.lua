vim.api.nvim_create_augroup('pencil', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
  group = 'pencil',
  pattern = { 'markdown', 'mkd', 'text', 'skald' },
  callback = function()
    vim.fn['pencil#init']({ wrap = "soft" })

    local yellow = '#fff1ad'
    local borderYellow = '#020202'

    -- Markdown styling
    vim.api.nvim_set_hl(0, '@markup.italic', { italic = true })
    vim.api.nvim_set_hl(0, '@markup.raw.block.markdown', { fg = yellow, italic = true })
    vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', { fg = yellow, italic = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = borderYellow })
  end,
})

vim.keymap.set('n', '<leader>sp', '<cmd>SoftPencil<CR>')
vim.keymap.set('n', '<leader>sn', '<cmd>PencilOff <CR>')
