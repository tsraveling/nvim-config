-- _qf: open quickfix list
vim.keymap.set('n', '<leader>qf', function()
  pcall(vim.cmd, 'copen')
end, { desc = 'Qflist next' })

-- Adds jumplist to qf
vim.keymap.set("n", "<leader>qj", function()
  local jumplist = vim.fn.getjumplist()[1]
  local qf_list = {}
  for _, v in pairs(jumplist) do
    if vim.fn.bufloaded(v.bufnr) == 1 then
      table.insert(qf_list, {
        bufnr = v.bufnr,
        lnum = v.lnum,
        col = v.col,
        text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
      })
    end
  end
  vim.fn.setqflist(qf_list, " ")
  vim.cmd("copen")
end, { desc = "Jumplist to quickfix" })

-- next qf
vim.keymap.set('n', '<C-.>', function()
  pcall(vim.cmd, 'cnext')
end, { desc = 'Qflist next' })

-- prev qf
vim.keymap.set('n', '<C-,>', function()
  pcall(vim.cmd, 'cprev')
end, { desc = 'Qflist next' })

vim.keymap.set('n', '<leader>>', function()
  vim.cmd([[silent! grep '>>>']])
  local qf_size = vim.fn.getqflist({ size = 0 }).size
  print('Added ' .. qf_size .. ' instances of >>> to QFList')
  if qf_size > 0 then
    vim.cmd('cfirst')
  else
    print('No instances of >>> found')
  end
end, { noremap = true, silent = true, desc = 'Search for >>> in codebase' })

-- _qda: dump all diagnostics into qflist
vim.keymap.set("n", "<leader>qda", function()
  vim.diagnostic.setqflist()
  vim.notify("All diagnostics dumped to qflist")
end, { desc = "Qf: all diagnostics" })

-- _qde: dump errors into qflist
vim.keymap.set("n", "<leader>qde", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
  vim.notify("Errors dumped to qflist")
end, { desc = "Qf: errors only" })

-- _qa: add the current position into qflist
vim.keymap.set("n", "<leader>qa", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum, col = pos[1], pos[2] + 1
  local text = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
  vim.fn.setqflist({
    { bufnr = bufnr, lnum = lnum, col = col, text = text },
  }, "a")
  vim.notify(string.format("Added to qflist: %s:%d", vim.fn.bufname(bufnr), lnum))
end, { desc = "Qf: add current position" })

-- _qs: dump spelling mistakes in current buffer into qflist
vim.keymap.set("n", "<leader>qs", function()
  if not vim.wo.spell then
    vim.notify("spell not enabled in this window", vim.log.levels.WARN)
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local qf = {}
  for lnum, line in ipairs(lines) do
    local offset = 0
    while offset < #line do
      local rest = line:sub(offset + 1)
      local result = vim.fn.spellbadword(rest)
      local bad, kind = result[1], result[2]
      if bad == "" then break end
      local s = rest:find(bad, 1, true)
      if not s then break end
      local col = offset + s
      table.insert(qf, {
        bufnr = bufnr,
        lnum = lnum,
        col = col,
        text = string.format("[%s] %s", kind, bad),
      })
      offset = col + #bad - 1
    end
  end
  vim.fn.setqflist(qf, " ")
  if #qf > 0 then
    vim.cmd("copen")
    vim.notify(string.format("%d spelling issues", #qf))
  else
    vim.notify("No spelling issues")
  end
end, { desc = "Qf: spelling mistakes in buffer" })

-- _qx: clear the qflist
vim.keymap.set("n", "<leader>qx", function()
  vim.fn.setqflist({}, "r")
  vim.cmd("cclose")
  vim.notify("qflist cleared")
end, { desc = "Qf: clear" })
