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
  vim.cmd('split')
  vim.cmd('resize 15')
  vim.cmd('terminal')
  vim.cmd([[
        call feedkeys("cd build\r", 't')
        call feedkeys("make\r", 't')
    ]])
  vim.cmd('startinsert')
end, { noremap = true, desc = "Open terminal, setup build dir & run cmake" })

vim.keymap.set('n', "<leader>br", function()
  vim.ui.input({ prompt = "Target >" }, function(build_tar)
    vim.cmd('vsplit')
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 80')
    vim.cmd('terminal')
    vim.cmd([[
        call feedkeys("cd build\r", 't')
        call feedkeys("make\r", 't')
    ]])
    vim.cmd(string.format('call feedkeys("./%s\\r", "t")', build_tar))
    vim.cmd('startinsert')
  end)
end)

vim.keymap.set('n', '<leader>cpi', function()
  vim.ui.input({ prompt = "Filename >" }, function(fnm)
    -- Get the current cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row = cursor_pos[1]

    -- get def
    local def_name = string.upper(fnm) .. "_H"

    -- Lines to insert
    local lines = {
      "#ifndef " .. def_name,
      "#define " .. def_name,
      "",
      "",
      "",
      "#endif // " .. def_name
    }

    -- Insert lines at the current cursor position
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)

    -- Move the cursor to the end of the inserted text
    vim.api.nvim_win_set_cursor(0, { row + #lines - 2, 0 })
  end)
end, { desc = "Inserts ifndef for a c++ header file" })

vim.keymap.set('n', '<leader>cf', '<cmd>ClangdSwitchSourceHeader<CR>', { desc = "Switch source - header file" })
