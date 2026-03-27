return {
  { 'preservim/vim-pencil' },
  { 'romariorobby/taskell.nvim' },
  {
    "OmniSharp/omnisharp-vim",
    ft = 'cs',
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends_by_filetype = {
        sql = { 'lsp' },
      },
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },
  {
    'leoluz/nvim-dap-go'
  },
  {
    "sotte/presenting.nvim",
    opts = {
      -- fill in your options here
      -- see :help Presenting.config
    },
    cmd = { "Presenting" },
  },
  {
    'RishabhRD/popfix',
    'RishabhRD/nvim-cheat.sh'
  },
  {
    'glepnir/template.nvim',
    cmd = { 'Template', 'TemProject' },
    config = function()
      require('template').setup({
        temp_dir = '~/.config/nvim/templates',
        author = 'Tim Raveling',
      })
    end
  },
  { "artemave/workspace-diagnostics.nvim" },
  require('plugins.trouble'),
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    }
  },
  { 'echasnovski/mini.nvim',              version = '*' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'rcarriga/nvim-notify'
  },
  {
    'stevearc/conform.nvim',
    opts = {},
  },
  {
    "S1M0N38/love2d.nvim",
    cmd = "LoveRun",
    opts = {},
    keys = {
      { "<leader>ll", ft = "lua", desc = "LÖVE" },
    },
  },
  {
    "Freedzone/kerbovim"
  },
  {
    'mfussenegger/nvim-dap',
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
      ensure_installed = {
        "codelldb",
        "buf"
      }
    }
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        STUB = { icon = "築", color = "#FFFF00" },
        SECTION = { icon = "▶", color = "#FFFFFF" },
        MARK = { icon = "▶", color = "#FFFFFF" },
      }, -- SECTION: Test
      highlight = {
        multiline = false,
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--glob=!vendors/**", -- Exclude vendors directory
          "--glob=!vendor/**",  -- Common variations
          "--glob=!third_party/**"
        },
        pattern = [[\b(KEYWORDS):]],
      }
    },
  },
  {
    "windwp/nvim-ts-autotag",
    "windwp/nvim-autopairs"
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {

    'neovim/nvim-lspconfig',
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  {
    "mbbill/undotree",
    lazy = false,
  },
  {
    "tpope/vim-fugitive"
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "rose-pine/neovim",          name = "rose-pine" },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "cpp", "cmake", "typescript", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "proto", "markdown" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end
  },
  { "nvim-treesitter/playground" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dim = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      zen = {
        toggles = {
          dim = false,
          git_signs = false,
          mini_diff_signs = false,
        },
        enabled = true,
        center = true,
        on_open = function(win)
          -- Defer so the WinEnter autocmd exists before we try to remove it
          vim.schedule(function()
            local aus = vim.api.nvim_get_autocmds({ group = win.augroup, event = "WinEnter" })
            for _, au in ipairs(aus) do
              vim.api.nvim_del_autocmd(au.id)
            end
          end)
        end,
      },
      scratch = {
        enabled = true,
        ft = function()
          if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
            return vim.bo.filetype
          end
          return "markdown"
        end,
        root = vim.fn.stdpath("data") .. "/scratch",
        autowrite = true, -- automatically write when the buffer is hidden
      },
      styles = {
        zen = {
          width = 80
        },
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      },
      dashboard = {
        sections = {
          { section = "header" },
          {
            pane = 2,
            height = 5,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      }
    }
  }
}
