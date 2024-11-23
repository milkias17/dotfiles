local ls = require("luasnip")

return {
	ls.parser.parse_snippet("bfunc", "func (c *Client) $1(b *gotgbot.Bot, ctx *CContext) error {\n\t$0\n\n}"),
}
