vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--I can move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=v")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=v")

--i can scroll w/ ctrl + u/d
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

--keep search terms in middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- tmux sessionizer
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- shoutout
vim.keymap.set("n", "<leader>so", "<cmd>so<CR>", {desc = "Shout out"})

-- backspace pops out to filesystem
vim.keymap.set("n", "<BS>", function()
  vim.cmd("update")
  vim.cmd("Ex")
end)

-- save shortcut
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")

-- TODOs
vim.keymap.set("n", "<leader>td", "<cmd>TodoQuickFix<CR>")
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<CR>")

--_y to copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

--_x to chmod+x a script from right in here
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--git
vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>")
vim.keymap.set("n", "<leader>gf", function() 
  vim.cmd("Git fetch origin")
  print("Fetched latest")
end)
vim.keymap.set("n", "<leader>gg", "<cmd>Git pull origin<CR>")
vim.keymap.set("n", "<leader>gp", "<cmd>Git push origin<CR>")
vim.keymap.set("n", "<leader>gaa", function()
  vim.cmd('Git add --all')
  print('Tracked all changes.')
end, { desc = "Git add all"})
vim.keymap.set('n', '<leader>gc', function()
    -- Prompt the user for a commit message
    local commit_message = vim.fn.input('Commit message: ')
    
    -- Check if a message was actually entered
    if commit_message ~= '' then
        -- Use vim.cmd to run the Git commit command
        vim.cmd('Git commit -m "' .. commit_message .. '"')
    else
        print('Commit cancelled: No message provided')
    end
end, { desc = 'Git commit with message' })
