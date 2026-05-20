[
  (arguments)
  (for_in_statement)
  (for_statement)
  (while_statement)
  (do_statement)
  (with_statement)
  (switch_statement)
  (switch_case)
  (switch_default)
  (if_statement)
  (try_statement)
  (catch_clause)
  (array)
  (object)
] @fold

[
  (interface_declaration)
  (internal_module)
  (type_alias_declaration)
  (enum_declaration)
] @fold

(function_declaration body: (statement_block) @fold)
(function_expression body: (statement_block) @fold)
(arrow_function body: (statement_block) @fold)
(method_definition body: (statement_block) @fold)
(generator_function body: (statement_block) @fold)
(generator_function_declaration body: (statement_block) @fold)

(class_declaration body: (class_body) @fold)

(try_statement body: (statement_block) @fold)
(catch_clause body: (statement_block) @fold)
(finally_clause body: (statement_block) @fold)
