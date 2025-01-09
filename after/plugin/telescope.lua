local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<S-o>", builtin.find_files, {})
vim.keymap.set("n", "<S-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
  vim.ui.input({ prompt = "Grep >" }, function(search)
    builtin.grep_string({ search = search });
  end)
end)
