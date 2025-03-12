vim.keymap.set('n', "<leader>cmg", "<cmd>CMakeGenerate<CR>", { desc = "Generate CMake Debug folder" })
vim.keymap.set('n', "<leader>cmb", "<cmd>CMakeBuild<CR>", { desc = "CMake build all" })
vim.keymap.set('n', "<leader>cmr", function()
  vim.ui.input({ prompt = "Target >" }, function(target)
    vim.cmd("CMakeRun " .. target)
  end)
end)
vim.keymap.set('n', "<leader>cmt", "<cmd>CMakeToggle<CR>", { desc = "CMake toggle panel" })
