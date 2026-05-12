if vim.fn.executable('termux-clipboard-set') == 1 then
  vim.g.clipboard = {
    name = 'termux',
    copy = {
      ['+'] = 'termux-clipboard-set',
      ['*'] = 'termux-clipboard-set',
    },
    paste = {
      ['+'] = 'termux-clipboard-get',
      ['*'] = 'termux-clipboard-get',
    },
    cache_enabled = 0,
  }
end
