local mini_files = require('mini.files')

mini_files.setup({
  auto_open = false,
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
  local fs_entry = mini_files.get_fs_entry()
  vim.notify(vim.inspect(fs_entry))
  vim.fn.system(string.format("gio open '%s'", fs_entry.path))
end

vim.keymap.set("n", "-", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  mini_files.open(path)
  mini_files.reveal_cwd()
end, { desc = "Open Mini Files" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak left-hand side of mapping to your liking
    vim.keymap.set("n", "-", mini_files.close, { buffer = buf_id })
    vim.keymap.set("n", "o", gio_open, { buffer = buf_id })
  end,
})
