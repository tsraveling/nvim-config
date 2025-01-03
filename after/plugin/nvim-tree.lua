-- empty setup using defaults
require("nvim-tree").setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  }
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tc', '<cmd>NvimTreeCollapse<CR>', { noremap = true, silent = true })
