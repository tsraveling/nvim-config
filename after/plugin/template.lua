require("telescope").load_extension('find_template')

vim.keymap.set('n', '<leader>tm', function()
  vim.fn.feedkeys(':Template ')
end, { remap = true })
