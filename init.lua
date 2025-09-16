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

-- cut down on the LSP logging -- maybe reenable when we hit the Skald LSP project
vim.lsp.set_log_level("warn")

-- DAT syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dat",
  callback = function()
    vim.bo.filetype = "dat"
  end
})

-- LSP management
local function manage_lsp_log()
  local log_path = vim.fn.stdpath('state') .. '/lsp.log'
  local stat = vim.loop.fs_stat(log_path)

  -- Clear log if larger than 50MB
  if stat and stat.size > 50 * 1024 * 1024 then
    vim.fn.writefile({ '[CLEARED] Log was too large, starting fresh' }, log_path)
    print('LSP log cleared (was too large)')
  end
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = manage_lsp_log,
})

vim.lsp.set_log_level('warn')
