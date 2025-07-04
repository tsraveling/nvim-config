vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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

-- todos
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>")
vim.keymap.set("n", "<leader>ts", "<cmd>TodoTelescope keywords=STUB<cr>")

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


-- Run the software in various environments
vim.keymap.set('n', "<leader>br", function()
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
          call feedkeys("cmake ..\r", 't')
          call feedkeys("make\r", 't')
      ]])
    vim.cmd(string.format('call feedkeys("./%s\\r", "t")', build_tar))
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
    vim.cmd([[
          call feedkeys("scons\r", 't')
          call feedkeys("exit", 't')
      ]]) -- scons then type exit but wait for keyboard input
    vim.cmd('startinsert')
  elseif is_godot then
    create_terminal_window()
    vim.cmd([[
          call feedkeys("godot .\r", 't')
          call feedkeys("exit", 't')
      ]]) -- run godot then type exit but wait for keyboard input
    vim.cmd('startinsert')
  else
    vim.notify("No cmake, scons, or godot project detected.", vim.log.levels.WARN)
  end
end)

vim.keymap.set('n', '<leader>cf', '<cmd>ClangdSwitchSourceHeader<CR>', { desc = "Switch source - header file" })

-- Quickly jump between methods
vim.keymap.set('n', '<leader>cm', function()
  require('telescope.builtin').lsp_document_symbols({
    symbols = { 'method', 'function', 'constructor', 'destructor' }
  })
end, { desc = 'List methods in current file' })

-- Markdown formatting hotkeys
vim.keymap.set("i", "<D-b>", "**")

-- Split navigation
vim.keymap.set('n', '<C-.>', '<C-w>w', { desc = 'Switch to next split' })
vim.keymap.set('n', '<C-,>', '<C-w>W', { desc = 'Switch to previous split' })
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Open vertical split' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Open vertical split' })
