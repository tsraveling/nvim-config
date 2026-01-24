local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.skald = {
  install_info = {
    url = "/Users/tsraveling/repos/tree-sitter-skald",
    files = { "src/parser.c" },
  },
  filetype = "ska",
}

vim.filetype.add({
  extension = {
    ska = 'skald',
  }
})
