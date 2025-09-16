-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', '<leader>ci', '<cmd>Telescope lsp_implementations<cr>', opts)
    vim.keymap.set('n', '<leader>cd', '<cmd>Telescope lsp_definitions<cr>', opts)
    vim.keymap.set('n', '<leader>cD', '<cmd>Telescope lsp_declarations<cr>', opts) -- Note: only available in newer versions
    vim.keymap.set('n', '<leader>co', '<cmd>Telescope lsp_type_definitions<cr>', opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)     -- Keep diagnostic navigation as-is
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '<leader>cr', '<cmd>Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>cs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Xcodebuild plugin keybindings
vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', opts)
vim.keymap.set('n', '<leader>xi', '<cmd>XcodebuildSetup<cr>', opts)
vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', opts)
vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', opts)
vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', opts)
vim.keymap.set('n', '<leader>xs', '<cmd>XcodebuildSelectScheme<cr>', opts)
vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', opts)
vim.keymap.set('n', '<leader>xc', '<cmd>lua vim.diagnostic.reset()<cr>')

require("mason").setup()

require("mason-lspconfig").setup({
  handlers = {
    -- Default handler for most servers
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    -- Custom handler for clangd with your specific configuration
    clangd = function()
      require('lspconfig').clangd.setup({
        filetypes = { "c", "cpp", "objc", "objcpp" },
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--log=verbose',
          '--suggest-missing-includes',
          '--completion-style=detailed',
          '--header-insertion=iwyu',
          '--function-arg-placeholders',
          '--std=c++20'
        },
        init_options = {
          fallbackFlags = { '-std=c++20' },
        },
      })
    end,
  }
})

require('lspconfig').ts_ls.setup({
  root_dir = function(fname)
    local util = require('lspconfig.util')
    local root = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')(fname)
    if root then
      return root
    end
    return util.path.dirname(fname)
  end,
})

require 'lspconfig'.gdscript.setup {
  name = "godot",
  cmd = vim.lsp.rpc.connect("127.0.0.1", 6005)
}
require 'lspconfig'.gdshader_lsp.setup {}

-- Swift LSP configuration
require 'lspconfig'.sourcekit.setup {
  cmd = { 'xcrun', 'sourcekit-lsp' },
  filetypes = { 'swift', 'objective-c', 'objective-cpp' },
}

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  -- Disable completion in comments
  enabled = function()
    -- Disable completion in comments using treesitter
    local context = require('cmp.config.context')
    return not context.in_treesitter_capture('comment')
        and not context.in_syntax_group('Comment')
  end,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- TODO: Figure out an abort command that works
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- Add Tab functionality for jumping between placeholders
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.snippet and vim.snippet.active() then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- Add Shift-Tab to jump backwards
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.snippet and vim.snippet.active() then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
})

-- Typescript organize imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  callback = function()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) }
    })
  end
})
