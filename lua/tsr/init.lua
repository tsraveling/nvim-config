require("tsr.remap")
require("tsr.set")

vim.api.nvim_create_user_command('OpenTodo', function()
	vim.cmd('botright vsplit ~/notes/TODO.md')
end, {})

vim.api.nvim_create_user_command('OpenNotebook', function()
	vim.cmd('botright vsplit ~/notes/NOTEBOOK.md')
	vim.cmd('normal G')
end, {})

vim.api.nvim_create_user_command('OpenLearning', function()
	vim.cmd('rightbelow split ~/notes/LEARNING.md')
end, {})

-- autocmds
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { '*.md' },
  callback = function()
		vim.opt.wrap = true
    vim.opt.linebreak = true
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  pattern = { '*.md' },
  callback = function()
		vim.opt.wrap = false
    vim.opt.linebreak = false
  end,
})
