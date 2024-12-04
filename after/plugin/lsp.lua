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

		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		vim.keymap.set('n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', '<leader>cD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set('n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', '<leader>co', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.keymap.set('n', '<leader>cs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	end,
})

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "rust_analyzer", "bashls", "arduino_language_server", "clangd", "tailwindcss", "gopls", "ts_ls", "markdown_oxide", "yamlls" },
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
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
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-,>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
})
