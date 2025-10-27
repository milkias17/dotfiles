local ls = require("luasnip")

return {
	s("kitauth", {
		t({
			"const session = await lcoals.auth.validate();",
			"if (!session) throw redirect(302, '/signin');",
			"if (!session.user.roles.includes('IT_DEPARTMENT')) {",
			"\tthrow redirect(302, '/');",
			"}",
		}),
	}),
	ls.parser.parse_snippet("cl", "console.log($1);$0"),

	s(
		"kitbload",
		fmt(
			"import type {{ Actions, PageServerLoad }} from './$types';"
				.. "\n\nexport const load: PageServerLoad = async ({{ params{1} }}) => {{\n  {2}\n}};"
				.. "\n\nexport const actions: Actions = {{\n  default: async ({{ request{3} }}) => {{\n\t{4}\n\t}},\n}};",
			{ i(1), i(2), i(3), i(4) }
		)
	),

	s(
		"kitEndpoint",
		fmt(
			"import type {{ RequestHandler }} from './$types';"
				.. "\n\nexport const {}: RequestHandler = async ({{ clientAddress, locals, params, platform, request, routeId, url }}) => {{\n\t{}\n}}",
			{ c(1, { t("GET"), t("POST"), t("PUT"), t("PATCH"), t("DEL") }), i(2) }
		)
	),
}
