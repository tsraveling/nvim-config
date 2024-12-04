require("config.lazy")
require("tsr")
require("rose-pine").setup({
	variant="main",
	styles = {
		italic = false,
	}
})
vim.cmd("colorscheme rose-pine")
ColorMyPencils()
