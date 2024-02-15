local ls = require("luasnip")

return {
  ls.parser.parse_snippet("fd", "/**\n\t* $1 - $2\n\t* Description: $3\n\t* Return: $4\n*/\n$0"),
  ls.parser.parse_snippet(
    "bet",
    "#include <stdio.h>\n\n/**\n\t* main - default description\n\t* Description: default description\n\t* Return: 0\n*/\n\nint main(void)\n{\n\t$0\n\treturn (0);\n}"
  ),
  s(
    "bfunc",
    fmt("/**\n\t* {} - {}\n\t* Description: {}\n\t* Return: {}\n*/\n{} {}({})\n{{\n\t{}\n\t{}\n}}", {
      i(1, "main"),
      i(2, "default-description"),
      f(function(text)
        return text[1]
      end, { 2 }),
      i(3, "int"),
      f(function(return_type)
        return return_type[1]
      end, { 3 }),
      f(function(func_name)
        return func_name[1]
      end, { 1 }),
      i(4),
      i(0),
      f(function(return_type)
        if return_type[1][1] == "int" then
          return "return (0);"
        else
          return ""
        end
      end, { 3 }),
    })
  ),
}
