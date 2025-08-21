local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>ss", function()
  vim.ui.input({ prompt = "Grep >" }, function(search)
    builtin.grep_string({ search = search, additional_args = { "--smart-case" } });
  end)
end)
vim.keymap.set("n", "<leader>si", function()
  vim.ui.input({ prompt = "Grep in current folder >" }, function(search)
    builtin.grep_string({
      search = search,
      additional_args = { "--smart-case" },
      cwd = vim.fn.expand("%:p:h")
    })
  end)
end)
vim.keymap.set("n", "<leader>pr", function()
  require 'telescope.builtin'.registers {}
end)
vim.keymap.set("n", "<leader>pa", function()
  vim.ui.input({ prompt = "Grep >" }, function(search)
    builtin.grep_string({
      search = search,
      additional_args = { "--no-ignore" } -- This will include .gitignore'd files
    });
  end)
end)
vim.keymap.set("n", "<leader>sS", builtin.resume, { desc = "Resume last telescope search" })

vim.keymap.set("n", "<leader>*", function()
  builtin.grep_string()
end)
