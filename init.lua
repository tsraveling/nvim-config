-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")
require("tsr")
require("rose-pine").setup({
  variant = "main",
  styles = {
    italic = false,
  }
})
vim.cmd("colorscheme rose-pine")

-- Require custom modules
require("modules")

ColorMyPencils() -- H/T theprimagen!

-- DAT syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dat",
  callback = function()
    vim.bo.filetype = "dat"
  end
})
