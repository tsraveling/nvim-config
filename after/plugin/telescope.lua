local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>ps", function()
  vim.ui.input({ prompt = "Grep >" }, function(search)
    builtin.grep_string({ search = search });
  end)
end)
vim.keymap.set("n", "<leader>pr", function()
  require 'telescope.builtin'.registers {}
end)
vim.keymap.set("n", "<leader>*", function()
  builtin.grep_string()
end)
