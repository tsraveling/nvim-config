vim.api.nvim_create_user_command('LaunchLove', function()
  -- Send love . to the next tmux pane
  vim.fn.system('tmux send-keys -t +1 "love ." Enter')
end, {})

vim.api.nvim_create_user_command('StopLove', function()
  -- Send love . to the next tmux pane
  vim.fn.system('tmux send-keys -t +1 C-c')
end, {})

vim.keymap.set('n', '<leader>lr', ':LaunchLove<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ls', ':StopLove<CR>', { noremap = true, silent = true })
