local opts = { noremap = true, silent = true }

local config = {
	global_settings = {
		tabline = true,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
}

local function get_mark_index()
	local utils = require("harpoon.utils")
	local current_file = utils.normalize_path(vim.api.nvim_buf_get_name(0))
	local index = require("harpoon.mark").get_index_of(current_file)
	if index == nil then
		return nil
	end

	return index
end

local function swap_next_mark()
	local index = get_mark_index()
	if index == nil then
		return
	end

	local marks = require("harpoon").get_mark_config().marks
	local next_mark = index + 1
	if next_mark > #marks then
		next_mark = 1
	end

	local tmp = marks[index]
	marks[index] = marks[next_mark]
	marks[next_mark] = tmp
	require("harpoon.mark").set_mark_list(marks)
end

local function swap_prev_mark()
	local index = get_mark_index()
	if index == nil then
		return
	end

	local marks = require("harpoon").get_mark_config().marks
	local prev_mark = index - 1
	if prev_mark < 1 then
		prev_mark = #marks
	end

	local tmp = marks[index]
	marks[index] = marks[prev_mark]
	marks[prev_mark] = tmp
	require("harpoon.mark").set_mark_list(marks)
end

local function remove_current_mark()
	local index = get_mark_index()
	if index == nil then
		return
	end

	local marks = require("harpoon").get_mark_config().marks
	table.remove(marks, index)
	require("harpoon.mark").set_mark_list(marks)
end

return {
	{
		"ThePrimeagen/harpoon",
    dev = true,
    dir="~/Dev/Github_Repos/harpoon",
		event = "VeryLazy",
		keys = {
			{
				"<space>ha",
				function()
					require("harpoon.mark").add_file()
				end,
				opts,
			},
			{
				"<space>hr",
				remove_current_mark,
				opts,
			},
			{
				"<space>hc",
				function()
					require("harpoon.mark").clear_all()
				end,
				opts,
			},
			{
				"<space>hs",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				opts,
			},
			{ "<space>hn", swap_next_mark, opts },
			{ "<space>hp", swap_prev_mark, opts },
			{
				"]c",
				function()
					require("harpoon.ui").nav_next()
				end,
				opts,
			},
			{
				"[c",
				function()
					require("harpoon.ui").nav_prev()
				end,
				opts,
			},
			{
				"<M-1>",
				function()
					require("harpoon.ui").nav_file(1)
				end,
				opts,
			},
			{
				"<M-2>",
				function()
					require("harpoon.ui").nav_file(2)
				end,
				opts,
			},
			{
				"<M-3>",
				function()
					require("harpoon.ui").nav_file(3)
				end,
				opts,
			},
			{
				"<M-4>",
				function()
					require("harpoon.ui").nav_file(4)
				end,
				opts,
			},
			{
				"<M-5>",
				function()
					require("harpoon.ui").nav_file(5)
				end,
				opts,
			},
			{
				"<M-6>",
				function()
					require("harpoon.ui").nav_file(6)
				end,
				opts,
			},
			{
				"<M-7>",
				function()
					require("harpoon.ui").nav_file(7)
				end,
				opts,
			},
			{
				"<M-8>",
				function()
					require("harpoon.ui").nav_file(8)
				end,
				opts,
			},
			{
				"<M-9>",
				function()
					require("harpoon.ui").nav_file(9)
				end,
				opts,
			},
		},
		opts = config,
		config = function()
			vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
			vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
			vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! TabLineFill guibg=#1E2030 guifg=white")
			require("harpoon").setup(config)
		end,
	},
}
