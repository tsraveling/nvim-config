local M = {}

-- Configuration for the floating window
local function create_float_config()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  }
end

-- Function to toggle markdown checkbox state
local function toggle_checkbox()
  -- Get current line number and content
  local line = vim.api.nvim_get_current_line()

  -- Pattern to match markdown checkbox
  local checkbox_pattern = "^(%s*[-*+]%s*%[)[%s*xX]?(])"

  -- Check if line contains a checkbox
  local prefix, suffix = line:match(checkbox_pattern)
  if prefix and suffix then
    -- If checkbox exists, toggle its state
    local is_checked = line:match("%[[xX]%]")
    local new_line
    if is_checked then
      -- Replace [x] or [X] with [ ]
      new_line = line:gsub("%[[xX]%]", "[ ]")
    else
      -- Replace [ ] with [x]
      new_line = line:gsub("%[%s*%]", "[x]")
    end

    -- Update the line
    vim.api.nvim_set_current_line(new_line)
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>td', function()
    -- Get the full path
    local todo_path = vim.fn.expand('~/notes/todo.md')

    -- Create an empty scratch buffer first
    local buf = vim.api.nvim_create_buf(false, false)

    -- Open it in a floating window
    local win = vim.api.nvim_open_win(buf, true, create_float_config())

    -- Set window options
    vim.api.nvim_win_set_option(win, 'winblend', 10)
    vim.api.nvim_win_set_option(win, 'wrap', true)
    vim.api.nvim_win_set_option(win, 'number', true)
    vim.api.nvim_win_set_option(win, 'relativenumber', true)
    vim.api.nvim_win_set_option(win, 'signcolumn', 'yes')

    -- Now use the standard command to edit the file in this window
    -- This should handle all the normal buffer setup and LSP initialization
    vim.cmd('edit ' .. vim.fn.fnameescape(todo_path))

    -- Set markdown filetype explicitly after loading
    vim.cmd('setlocal filetype=markdown')

    -- Add the backspace mapping to the loaded buffer
    local loaded_buf = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<BS>', function()
      vim.cmd('write')
      vim.cmd('quit')
    end, { buffer = loaded_buf })

    vim.keymap.set('n', '<CR>', toggle_checkbox, {
      desc = "Toggle markdown checkbox",
      buffer = true
    })
  end)
end

return M
