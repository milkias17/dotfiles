local config = {
	show_current_context = true,
	show_current_context_start = true,
}

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = config,
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl"
	},
}
