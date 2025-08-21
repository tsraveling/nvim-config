require('lualine').setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_c = {
      'filename',
      {
        'aerial',
        -- Optional: configure how it displays
        sep = ' > ',     -- separator between nested functions
        depth = nil,     -- nil = show all levels, or set a number
        dense = false,   -- dense mode uses less space
        dense_sep = '.', -- separator for dense mode
      }
    },
    lualine_b = {
      'branch', -- git branch
      'diff',   -- git changes (+3 ~1 -2)
    },
    lualine_x = {
      'diagnostics', -- LSP diagnostics
      'filetype',
    }
  }
}
