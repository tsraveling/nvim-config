-- Register skald filetype for *.ska files
vim.filetype.add({
  extension = {
    ska = 'skald',
  }
})

-- Map the skald parser to the skald filetype
vim.treesitter.language.register('skald', { 'skald' })

-- Register skald parser with nvim-treesitter so it knows where to compile from
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').skald = {
      install_info = {
        path = '/Users/tsraveling/repos/tree-sitter-skald',
        generate = true,
      },
    }
  end,
})
