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
  s("bl", {
    t("{% block "),
    i(1, "content"),
    t({ " %}", "\t" }),
    i(2),
    t({ "", "{% endblock %}", "" }),
    i(0),
  }),
  s("i", {
    t("{% if "),
    i(1),
    t({ " %}", "\t" }),
    i(2),
    t({ "", "{% endif %}", "" }),
    i(0),
  }),
  s("f", {
    t("{% for "),
    i(1, "i"),
    t(" in "),
    i(2, "items"),
    t({ " %}", "\t" }),
    i(3),
    t({ "", "{% endfor %}", "" }),
    i(0),
  }),
  s("ex", {
    t("{% extends "),
    i(1, '"base.html "'),
    t({ "%}", "" }),
    i(0),
  }),
}

ls.add_snippets("htmldjango", snippets)
