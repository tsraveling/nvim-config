local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')

local M = {}

function M.pick_template()
  local template_dir = vim.fn.expand('~/.config/nvim/templates')
  local templates = vim.fn.globpath(template_dir, '*', false, true)

  pickers.new({}, {
    prompt_title = 'Templates',
    finder = finders.new_table({
      results = templates,
      entry_maker = function(entry)
        return {
          value = entry,
          display = vim.fn.fnamemodify(entry, ':t'),
          ordinal = vim.fn.fnamemodify(entry, ':t'),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = 'Template Preview',
      define_preview = function(self, entry)
        conf.buffer_previewer_maker(entry.value, self.state.bufnr, {
          bufname = self.state.bufname,
        })
      end,
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local lines = vim.fn.readfile(selection.value)
        vim.api.nvim_put(lines, 'l', true, true)
      end)
      return true
    end,
  }):find()
end

return M
