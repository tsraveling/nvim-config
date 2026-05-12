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

  -- Keys-To-Go has no Esc key; jj exits insert mode
  vim.keymap.set('i', 'jj', '<Esc>')
end
