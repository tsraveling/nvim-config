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


ColorMyPencils() -- H/T theprimagen!
