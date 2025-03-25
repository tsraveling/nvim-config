local dap = require("dap")
local dapui = require("dapui")
dapui.setup({
  layouts = { {
    elements = { {
      id = "scopes",
      size = 0.4
    }, {
      id = "breakpoints",
      size = 0.2
    }, {
      id = "stacks",
      size = 0.2
    }, {
      id = "watches",
      size = 0.2
    } },
    position = "left",
    size = 50
  }, {
    elements = { {
      id = "repl",
      size = 0.75
    }, {
      id = "console",
      size = 0.25
    } },
    position = "bottom",
    size = 15
  } },
})


dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- vim.keymap.set("n", "<leader>ch", "<cmd>Cheat<CR>", { desc = "Open Cheat Sheet" })
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Continue debugging" })
vim.keymap.set("n", "<leader>dx", function()
  require("dapui").toggle({ reset = true })
end, { desc = "Toggle DAP ui and reset" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle DAP ui" })
