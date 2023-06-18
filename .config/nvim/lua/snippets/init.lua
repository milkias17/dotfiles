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

local langs = { "python", "javascript", "htmldjango", "css", "cpp", "c" }
for _, lang in ipairs(langs) do
  local modname = "snippets." .. lang
  require(modname)
end
