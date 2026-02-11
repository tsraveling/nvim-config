vim.api.nvim_create_autocmd("FileType", {
  pattern = "skald",
  callback = function()
    vim.lsp.start({
      name = "skald",
      cmd = { "lsp-devtools", "agent", "--", vim.fn.expand("~/repos/skald/build/skald_lsp") },
      root_dir = vim.fs.root(0, { ".git" }),
    })
  end,
})

vim.filetype.add({
  extension = {
    ska = "skald",
  },
})
