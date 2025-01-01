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

-- TODOs in Obsidian (may remove later)
vim.keymap.set("n", "<leader>mt", "<cmd>OpenTodo<CR>")
vim.keymap.set("n", "<leader>mn", "<cmd>OpenNotebook<CR>")
vim.keymap.set("n", "<leader>ml", "<cmd>OpenLearning<CR>")

-- shoutout
vim.keymap.set("n", "<leader>so", "<cmd>so<CR>", { desc = "Shout out" })

-- clear search = double escape
vim.keymap.set("n", "<Esc><Esc>", "<cmd>noh<CR>", { desc = "Clear search" })

-- close other panes
vim.keymap.set("n", "<leader><Esc>", "<cmd>on<CR>")

-- backspace pops out to filesystem
vim.keymap.set("n", "<BS>", function()
	vim.cmd("update")
	vim.cmd("Ex")
end)

-- save shortcut
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")

-- TODOs
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<CR>")
vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>")
vim.keymap.set("n", "<leader>ts", "<cmd>TodoTelescope keywords=STUB<CR>")

-- STUBs in the current project (ie, actual current work designation)
vim.keymap.set("n", "<leader>]", function()
	require("todo-comments").jump_next({ keywords = { "STUB" } })
end, { desc = "Next stub" })

vim.keymap.set("n", "<leader>[", function()
	require("todo-comments").jump_prev({ keywords = { "STUB" } })
end, { desc = "Next stub" })

--_y to copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

--_y to copy to clipboard
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")

--_x to chmod+x a script from right in here
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--git
vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>")
vim.keymap.set("n", "<leader>gf", function()
	vim.cmd("Git fetch origin")
	vim.notify("Fetched origin.")
end)
vim.keymap.set("n", "<leader>gg", "<cmd>Git pull origin<CR>")
vim.keymap.set("n", "<leader>gp", function()
	vim.cmd("Git push origin")
end)

vim.keymap.set("n", "<leader>gaa", function()
	vim.cmd('Git add --all')
	vim.notify("Added all files")
end, { desc = "Git add all" })
vim.keymap.set('n', '<leader>gc', function()
	-- Prompt the user for a commit message
	vim.ui.input({
		prompt = "Commit message: ",
	}, function(commit_message)
		-- Esc to cancel
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
