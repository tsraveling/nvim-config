local M = {}

local lines = {
  "folke.flash:",
  "s - jump",
  "S - select in treesitter",
  "*r* - operate on remote (eg yr*iw to yank in word somewhere else)",
  "*R* - operate on remote treesitter entity ",
  "<c-s> - when / searching, show jump tags to pick one",
}

function M.show()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local max_line = 0
  for _, l in ipairs(lines) do
    if #l > max_line then max_line = #l end
  end

  local ui_w = vim.o.columns
  local ui_h = vim.o.lines
  local width = math.max(10, math.min(max_line + 2, ui_w - 4))
  local height = math.min(#lines, ui_h - 4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((ui_h - height) / 2),
    col = math.floor((ui_w - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " onboard ",
    title_pos = "center",
  })

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<esc>", close, { buffer = buf, nowait = true, silent = true })
end

vim.keymap.set("n", "<leader>?", M.show, { desc = "Onboard help modal" })

return M
