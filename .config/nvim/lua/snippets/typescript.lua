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
}
