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

-- clear search = double escape
vim.keymap.set("n", "<leader>s<esc>", "<cmd>noh<cr>", { desc = "clear search" })

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

--_y to copy to clipboard
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")

--_x to chmod+x a script from right in here
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>", { silent = true })

--git
vim.keymap.set("n", "<leader>gs", "<cmd>git status<cr>")
vim.keymap.set("n", "<leader>gf", function()
  vim.cmd("git fetch origin")
  vim.notify("fetched origin.")
end)
vim.keymap.set("n", "<leader>gp", "<cmd>git pull origin<cr>")
vim.keymap.set("n", "<leader>gp", function()
  vim.cmd("git push origin")
end)

vim.keymap.set("n", "<leader>gaa", function()
  vim.cmd('git add --all')
  vim.notify("added all files")
end, { desc = "git add all" })
vim.keymap.set('n', '<leader>gc', function()
  -- prompt the user for a commit message
  vim.ui.input({
    prompt = "commit message: ",
  }, function(commit_message)
    -- esc to cancel
    if commit_message == nil then
      return
    end

    -- Check if a message was actually entered
    if commit_message ~= '' then
      -- Use vim.cmd to run the Git commit command
      vim.cmd('Git commit -m "' .. commit_message .. '"')
    else
      vim.notify("No commit message provided.", "error")
    end
  end)
end, { desc = 'Git commit with message' })
