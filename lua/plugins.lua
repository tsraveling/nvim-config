return {
  {
    "S1M0N38/love2d.nvim",
    cmd = "LoveRun",
    opts = {},
    keys = {
      { "<leader>ll",  ft = "lua",          desc = "LÖVE" },
    },
  },
  {
    "Freedzone/kerbovim"
  },
  {
    'mfussenegger/nvim-dap'
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        STUB = { icon = "築", color = "#FFFF00" },
      }
    } -- STUB: Test
  }, -- TODO: test
  {
    "windwp/nvim-ts-autotag",
    "windwp/nvim-autopairs"
  },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'neovim/nvim-lspconfig'
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
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "cpp", "cmake", "typescript", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end
  },
  { "nvim-treesitter/playground" }
}
