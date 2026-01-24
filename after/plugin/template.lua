vim.keymap.set('n', '<leader>tm', function()
  require('config.template-picker').pick_template()
end, { desc = 'Templates' })

-- quick-make a new template
vim.keymap.set("n", "<leader>tn", function()
  vim.ui.input({ prompt = "Template filename: " }, function(name)
    if name and name ~= "" then
      local path = vim.fn.expand("~/.config/nvim/templates/") .. name
      vim.fn.mkdir(vim.fn.expand("~/.config/nvim/templates"), "p")
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end
  end)
end, { desc = "New template" })
