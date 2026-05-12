-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- LSP keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', '<leader>ci', '<cmd>Telescope lsp_implementations<cr>', opts)
    vim.keymap.set('n', '<leader>cd', '<cmd>Telescope lsp_definitions<cr>', opts)
    vim.keymap.set('n', '<leader>cD', '<cmd>Telescope lsp_declarations<cr>', opts)
    vim.keymap.set('n', '<leader>co', '<cmd>Telescope lsp_type_definitions<cr>', opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '<leader>cr', '<cmd>Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>cs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lua LSP (for editing nvim config)
if vim.fn.executable('lua-language-server') == 1 then
  vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })
  vim.lsp.enable('lua_ls')
end

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  enabled = function()
    local context = require('cmp.config.context')
    return not context.in_treesitter_capture('comment')
        and not context.in_syntax_group('Comment')
  end,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.snippet and vim.snippet.active() then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.snippet and vim.snippet.active() then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
})

-- Spell on markdown/text/commit
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})
