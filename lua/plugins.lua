return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  { "sindrets/diffview.nvim" },
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
        "c", "cpp", "rust", "go", "gdscript",
        "lua", "vim", "vimdoc",
        "markdown", "markdown_inline",
        "query", "bash", "json",
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
      quickfile = { enabled = true },
      input = { enabled = true },
      statuscolumn = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      dim = { enabled = false },
      indent = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = false },
      zen = { enabled = false },
      scratch = { enabled = false },
      dashboard = { enabled = false },
    }
  }
}
