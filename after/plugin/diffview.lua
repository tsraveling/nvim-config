require("diffview").setup({})

local function toggle_diffview()
  local lib = require("diffview.lib")
  if lib.get_current_view() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end

vim.keymap.set("n", "<leader>gd", toggle_diffview, { desc = "Toggle Diffview" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo file history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
vim.keymap.set("n", "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", { desc = "Diff branch vs main" })
vim.keymap.set("n", "<leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", { desc = "Diff branch vs master" })
