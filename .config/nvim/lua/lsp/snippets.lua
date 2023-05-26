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

local function copy(args)
	return args[1]
end

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})

-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
-- 	if ls.expand_or_jumpable() then
-- 		ls.expand_or_jump()
-- 	end
-- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
-- 	if ls.jumpable(-1) then
-- 		ls.jump(-1)
-- 	end
-- end, { silent = true })
--
-- vim.keymap.set("i", "<c-l>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end)
--
-- vim.keymap.set("i", "<M-u>", require("luasnip.extras.select_choice"))

local same = function(index)
	return f(function(arg)
		return arg[1]
	end, { index })
end

ls.add_snippets("cpp", {
	ls.parser.parse_snippet("hel", "#include <iostream>\nusing namespace std;\n\nint main() {\n\t$0\n\treturn 0;\n}"),
})

ls.add_snippets("python", {
	s(
		"ptf",
		fmt("async def {}(update: Update, context: {}):\n\t{}", {
			i(1),
			c(
				2,
				{
					t("ContextTypes.DEFAULT_TYPE"),
					t("CallbackContext"),
				}
			),
			i(0),
		})
	),
})

ls.add_snippets("c", {
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
})
ls.add_snippets("htmldjango", {
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
})

ls.add_snippets("css", {
	s("vd", {
		t("border: 2px solid red;"),
		i(0),
	}),
})

ls.add_snippets("lua", {
	s(
		"mreq",
		fmt([[local {} = require "{}"]], {
			f(function(import_name)
				local parts = vim.split(import_name[1][1], ".", true)
				return parts[#parts] or ""
			end, { 1 }),
			i(1),
		})
	),
	ls.parser.parse_snippet("expand", "-- this is what was expanded"),
})
ls.add_snippets("javascript", {
	ls.parser.parse_snippet("eaf", "export async function $1 ($2) {\n\t$0\n}"),
})
