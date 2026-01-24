local function getWords()
  return tostring(vim.fn.wordcount().words) .. " words"
end

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
    lualine_z = {
      {
        getWords,
        cond = function()
          return vim.bo.filetype == "markdown"
        end,
      },
    },
  }
}
