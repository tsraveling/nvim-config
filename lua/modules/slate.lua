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

local function find_project_todo()
  -- Try to find git root first
  local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')

  -- If we're in a git repo, use that path
  if vim.v.shell_error == 0 then
    return git_root .. '/TODO.md'
  end

  -- Fallback to current working directory
  return vim.fn.getcwd() .. '/TODO.md'
end

local function open_todo_window(todo_path)
  local buf = vim.api.nvim_create_buf(false, false)
  local win = vim.api.nvim_open_win(buf, true, create_float_config())

  vim.cmd('edit ' .. vim.fn.fnameescape(todo_path))

  -- Set window options
  vim.wo[win].winblend = 10
  vim.wo[win].wrap = true
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true
  vim.wo[win].signcolumn = 'yes'

  -- Set markdown filetype
  vim.cmd('setlocal filetype=markdown')

  -- Add keymaps
  local loaded_buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'q', function()
    vim.cmd('write')
    vim.cmd('quit')
  end, { buffer = loaded_buf })

  vim.keymap.set('n', '<CR>', toggle_checkbox, {
    desc = "Toggle markdown checkbox",
    buffer = true
  })
end

function M.setup()
  vim.keymap.set('n', '<leader>td', function()
    local todo_path = find_project_todo()

    -- If file doesn't exist, show confirmation
    if vim.fn.filereadable(todo_path) == 0 then
      vim.ui.select({ 'Yes', 'No' }, {
        prompt = 'Create new TODO.md at ' .. todo_path .. '?',
      }, function(choice)
        if choice == 'Yes' then
          -- Create directory if needed
          local dir = vim.fn.fnamemodify(todo_path, ':h')
          vim.fn.mkdir(dir, 'p')

          -- Create empty file
          local file = io.open(todo_path, 'w')
          if file then
            file:write('# Project TODO\n\n')
            file:close()
            -- Continue with opening the file
            open_todo_window(todo_path)
          end
        end
      end)
    else
      -- File exists, open it directly
      open_todo_window(todo_path)
    end
  end)

  -- Create autocommand for ALL markdown files, not just the TODO buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set('n', '<CR>', toggle_checkbox, {
        desc = "Toggle markdown checkbox",
        buffer = true
      })
    end,
  })
end

return M
