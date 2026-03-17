; Keywords
[
    "if"
    "then"
    "else"
    "let"
    "in"
] @keyword

(when) @keyword
(is) @keyword

(colon) @punctuation.delimiter
(backslash) @keyword
(as) @keyword
(port) @keyword
(exposing) @keyword
(alias) @keyword
(infix) @keyword

; Arrows
(arrow) @operator

; Operators
(operator_identifier) @operator
(eq) @operator

; Functions
(type_annotation (lower_case_identifier) @function)
(port_annotation (lower_case_identifier) @function)
(function_declaration_left (lower_case_identifier) @function)
(function_call_expr target: (value_expr) @function)

; Variables
(field_access_expr (value_expr (value_qid)) @variable)
(lower_pattern) @variable
(record_base_identifier) @variable

; Types
(type_declaration (upper_case_identifier) @type)
(type_ref) @type
(type_alias_declaration name: (upper_case_identifier) @type)

; Variants / Constructors
(union_variant (upper_case_identifier) @variant)
(union_pattern) @variant
(value_expr (upper_case_qid (upper_case_identifier)) @variant)

; Numbers
(number_constant_expr) @number

; Strings
(open_quote) @string
(close_quote) @string
(regular_string_part) @string
(string_escape) @string.escape
(open_char) @string
(close_char) @string

; Comments
(line_comment) @comment
(block_comment) @comment

; Punctuation
"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

"|" @punctuation.delimiter
"," @punctuation.delimiter

; Modules
(import) @keyword
(module) @keyword
