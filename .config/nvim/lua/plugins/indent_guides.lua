local status, indent_guides = pcall(require, "indent_blankline")
if not status then
	return
end

indent_guides.setup({
	show_current_context = true,
	show_current_context_start = true,
})
