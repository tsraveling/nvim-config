vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Switch between recent buffers
vim.keymap.set("n", "<leader><Tab>", ":b#<CR>")

--I can move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv") -- Move up and reselect

--i can scroll w/ ctrl + u/d
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")

--keep search terms in middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "n", "nzzzv")

-- todos in obsidian (may remove later)
vim.keymap.set("n", "<leader>mt", "<cmd>opentodo<cr>")
vim.keymap.set("n", "<leader>mn", "<cmd>opennotebook<cr>")
vim.keymap.set("n", "<leader>ml", "<cmd>openlearning<cr>")

-- shoutout
vim.keymap.set("n", "<leader>so", "<cmd>so<cr>", { desc = "shout out" })

-- clear search
vim.keymap.set("n", "<leader>sc", "<cmd>noh<cr>", { desc = "clear search" })

-- close other panes
vim.keymap.set("n", "<leader><esc>", "<cmd>on<cr>")

-- save shortcut
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")

-- SECTION: Todos
local function quick_search(term)
  require('telescope.builtin').live_grep({
    search_dirs = { vim.fn.expand('%:p') },
    default_text = term,
    layout_config = {
      width = 120,
      height = 20,
    },
    path_display = { "hidden" },
  })
end

vim.keymap.set("n", "<leader>tQ", "<cmd>TodoQuickFix<cr>")
vim.keymap.set("n", "<leader>ta", "<cmd>TodoTelescope<cr>")
vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope keywords=FIXME<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope keywords=TODO<cr>")
vim.keymap.set("n", "<leader>ts", "<cmd>TodoTelescope keywords=STUB<cr>")
vim.keymap.set("n", "<leader>cj", function()
  local filetype = vim.bo.filetype
  local search_term = (filetype == "swift") and "mark: " or "section: "
  quick_search(search_term)
end)
vim.keymap.set("n", "<leader>cJ", "<cmd>TodoTelescope keywords=SECTION<cr>")

-- fuzzy finder
vim.keymap.set("n", "<leader>f", function()
  require('telescope.builtin').current_buffer_fuzzy_find({
    layout_config = {
      width = 0.9,
      height = 0.8,
    },
  })
end)

--_y to copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

--_pp to paste from clipboard
vim.keymap.set("n", "<leader>pp", "\"+p")
vim.keymap.set("v", "<leader>pp", "\"+p")

--_x to chmod+x a script from right in here
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>", { silent = true })

vim.keymap.set("n", "<leader>lw", function()
  vim.cmd([[
      set wrap
      set linebreak
  ]])
end)


-- C stuff

-- Generate build folder and run cmake in it
vim.keymap.set('n', '<leader>bg', function()
  vim.cmd('split')
  vim.cmd('resize 15')
  vim.cmd('terminal')
  vim.cmd([[
        call feedkeys("mkdir -p ./build\r", 't')
        call feedkeys("cd build\r", 't')
        call feedkeys("cmake ..\r", 't')
    ]])
  vim.cmd('startinsert')
end, { noremap = true, desc = "Open terminal, setup build dir & run cmake" })

-- Run the build
vim.keymap.set('n', '<leader>bb', function()
  vim.cmd('vsplit')
  vim.cmd('wincmd L')
  vim.cmd('vertical resize 60')
  vim.cmd('terminal')
  vim.cmd([[
        call feedkeys("cd build\r", 't')
        call feedkeys("cmake ..\r", 't')
        call feedkeys("make\r", 't')
        call feedkeys("exit", 't')
    ]])
  vim.cmd('startinsert')
end, { noremap = true, desc = "Open terminal, setup build dir & run cmake" })

-- The runner method
local function run_it(do_log)
  local is_scons = vim.fn.filereadable('SConstruct') == 1
  local is_cmake = vim.fn.filereadable('CMakeLists.txt') == 1
  local is_godot = vim.fn.filereadable('project.godot') == 1

  -- Helper function to create terminal window
  local function create_terminal_window()
    vim.cmd('vsplit')
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 80')
    vim.cmd('terminal')
  end

  local function build_cmake(build_tar)
    create_terminal_window()
    vim.cmd([[
      call feedkeys("cd build\r", 't')
      call feedkeys("cmake .. && make && ", 't')
    ]])
    vim.cmd(string.format('call feedkeys("./%s", "t")', build_tar))
    if (do_log) then
      vim.cmd([[call feedkeys(" > log.txt", 't')]])
    end
    vim.cmd([[call feedkeys("\r", 't')]])
    vim.cmd([[call feedkeys("exit", 't')]])
    vim.cmd('startinsert')
  end

  if is_cmake then
    -- Use current working directory as project identifier
    local project_id = vim.fn.getcwd()

    -- Use a table to store targets by project
    if not _G.project_build_targets then
      _G.project_build_targets = {}
    end

    -- Check if we have a stored target for this project
    if not _G.project_build_targets[project_id] then
      vim.ui.input({ prompt = "Target >" }, function(build_tar)
        -- Store the target for this project
        _G.project_build_targets[project_id] = build_tar
        build_cmake(build_tar)
      end)
    else
      -- Use the stored target
      build_cmake(_G.project_build_targets[project_id])
    end
  elseif is_scons then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("scons > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("scons\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  elseif is_godot then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("godot . > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("godot .\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  else
    vim.notify("No cmake, scons, or godot project detected.", vim.log.levels.WARN)
  end
end

-- Run the software in various environments
vim.keymap.set('n', "<leader>br", function()
  run_it(false)
end)

-- Run the software in various environments and log to log.txt
vim.keymap.set('n', "<leader>bR", function()
  run_it(true)
end)

-- Switch between header and source files in c++ (only works with .h and .cpp)
vim.keymap.set('n', '<leader>cf', function()
  local current_file = vim.fn.expand('%')
  local alternate_file

  if current_file:match('%.cpp$') then
    alternate_file = current_file:gsub('%.cpp$', '.h')
  elseif current_file:match('%.h$') then
    alternate_file = current_file:gsub('%.h$', '.cpp')
  else
    print('Not a .cpp or .h file')
    return
  end

  if vim.fn.filereadable(alternate_file) == 1 then
    vim.cmd('edit ' .. alternate_file)
  else
    print('Alternate file not found: ' .. alternate_file)
  end
end, { desc = "Switch source - header file" })

-- Quickly jump between methods
vim.keymap.set('n', '<leader>cm', function()
  require('telescope.builtin').lsp_document_symbols({
    symbols = { 'method', 'function', 'constructor', 'destructor' }
  })
end, { desc = 'List methods in current file' })

-- Markdown formatting hotkeys
vim.keymap.set("i", "<D-b>", "**")

-- SECTION: Split navigation
vim.keymap.set('n', '<C-.>', '<C-w>w', { desc = 'Switch to next split' })
vim.keymap.set('n', '<C-,>', '<C-w>W', { desc = 'Switch to previous split' })
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Open vertical split' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Open vertical split' })

vim.keymap.set('n', '<Tab>', '<C-w>w', { desc = 'Next split' })
vim.keymap.set('n', '<S-Tab>', '<C-w>W', { desc = 'Previous split' })

-- Restore Ctrl-i functionality (jump forward in jump list)
vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true })

-- Turn off weird esc key nav
vim.keymap.set('n', '<Esc>', '<Nop>', { desc = 'Disable escape' })

-- Copy current file path
vim.keymap.set('n', '<leader>yf', function()
  local filepath = vim.fn.expand('%')
  if filepath == '' then
    vim.notify('No file in current buffer', vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('+', filepath)
  vim.notify('Copied to clipboard: ' .. filepath, vim.log.levels.INFO)
end, { desc = "Copy file path to clipboard" })

-- SECTION: Transparency

local bg_transparent = true

local function toggle_background()
  if bg_transparent then
    vim.cmd("highlight Normal guibg=#1e1e2e") -- Adjust color to match your theme
    vim.cmd("highlight NonText guibg=#1e1e2e")
    vim.cmd("highlight SignColumn guibg=#1e1e2e")
    vim.cmd("highlight EndOfBuffer guibg=#1e1e2e")
    bg_transparent = false
    print("Background: Opaque")
  else
    vim.cmd("highlight Normal guibg=NONE")
    vim.cmd("highlight NonText guibg=NONE")
    vim.cmd("highlight SignColumn guibg=NONE")
    vim.cmd("highlight EndOfBuffer guibg=NONE")
    bg_transparent = true
    print("Background: Transparent")
  end
end

-- Map Ctrl+' in all modes
vim.keymap.set({ 'n', 'i', 'v', 'x', 't' }, '<C-\'>', toggle_background, { desc = 'Toggle background transparency' })

-- Folding
vim.keymap.set("n", "<leader>z{", 'zfi{', { desc = "Fold in brackets" })
