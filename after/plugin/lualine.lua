require('lualine').setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_c = {
      'filename',
      {
        'aerial',
        sep = ' > ',
        depth = 1,
        dense = false,
        dense_sep = '.',
      }
    },
    lualine_b = {
      'branch',
      'diff',
    },
  }
}
