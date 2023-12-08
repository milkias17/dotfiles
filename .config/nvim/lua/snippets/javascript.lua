local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local snippets = {
	ls.parser.parse_snippet("eaf", "export async function $1 ($2) {\n\t$0\n}"),
  ls.parser.parse_snippet("ef", "export function $1 ($2) {\n\t$0\n}"),
  ls.parser.parse_snippet("af", "async function $1 ($2) {\n\t$0\n}"),
  ls.parser.parse_snippet("f", "function $1 ($2) {\n\t$0\n}"),
  ls.parser.parse_snippet("cl", "console.log($0);"),
}

local reactSnippets = {
  ls.parser.parse_snippet("rfc", "const $1: React.FC<$2> = ($3) => {\n\t$0\n}\n\nexport default $1;")
}

local languages = {"javascript", "typescript", "typescriptreact", "javascriptreact"}

for _, lang in ipairs(languages) do
  ls.add_snippets(lang, snippets)
end

ls.add_snippets("javascript", snippets)
ls.add_snippets("typescriptreact", reactSnippets)
ls.add_snippets("javascriptreact", reactSnippets)
