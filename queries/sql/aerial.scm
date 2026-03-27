; Override aerial's default SQL queries to avoid invalid node types
; for the installed tree-sitter-sql grammar.

(create_table
  (object_reference) @name
  (#set! "kind" "Class")) @symbol

(create_view
  (object_reference) @name
  (#set! "kind" "Class")) @symbol

(create_function
  (object_reference) @name
  (#set! "kind" "Function")) @symbol
