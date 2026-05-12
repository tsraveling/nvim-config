return {
  {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  { 'preservim/vim-pencil' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    opts = {
      render_modes = { 'n', 'c', 't', 'i' },
      code = {
        sign = false,
        width = 'block',
        border = 'thin',
        left_pad = 1,
        right_pad = 1,
        disable_background = true,
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
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
  require('plugins.trouble'),
  { 'echasnovski/mini.nvim',      version = '*' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'stevearc/conform.nvim',
    opts = {},
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

    'neovim/nvim-lspconfig',
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  {
    "mbbill/undotree",
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'rafi/telescope-thesaurus.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- Enable treesitter highlighting and indentation via FileType autocmd (new main branch API)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Install parsers (replaces ensure_installed)
      local wanted = {
        "c", "lua", "cpp", "cmake", "typescript", "vim", "vimdoc",
        "query", "elixir", "heex", "javascript", "html", "proto", "markdown",
        "swift", "go", "rust", "sql", "gdscript", "json"
      }
      require("nvim-treesitter").install(wanted)
    end,
  },
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
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
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
