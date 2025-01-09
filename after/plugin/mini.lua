require('mini.files').setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 60,
  },
  mappings = {
    synchronize = "w",
    go_in_plus = "<CR>",
  },
})

local gio_open = function()
  local fs_entry = require("mini.files").get_fs_entry()
  vim.notify(vim.inspect(fs_entry))
  vim.fn.system(string.format("gio open '%s'", fs_entry.path))
end

vim.keymap.set("n", "-", function()
  require("mini.files").open()
end, { desc = "Open mini files" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak left-hand side of mapping to your liking
    vim.keymap.set("n", "-", require("mini.files").close, { buffer = buf_id })
    vim.keymap.set("n", "o", gio_open, { buffer = buf_id })
  end,
})
