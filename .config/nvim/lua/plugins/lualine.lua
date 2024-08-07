local colors = {
	foreground = "#abb2bf",
	background = "#2c323d",
	black = "#2c323c",
	red = "#e06c75",
	green = "#98c379",
	yellow = "#e5c07b",
	blue = "#61afef",
	magenta = "#c678dd",
	cyan = "#56b6c2",
	white = "#5c6370",
	black_alt = "#3e4452",
	red_alt = "#e06c75",
	green_alt = "#98c379",
	yellow_alt = "#e5c07b",
	blue_alt = "#61afef",
	magenta_alt = "#c678dd",
	cyan_alt = "#56b6c2",
	white_alt = "#abb2bf",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.api.nvim_get_option("columns") > 110
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
	lsp_active = function()
		local clients = vim.lsp.get_active_clients()
		return next(clients) ~= nil
	end,
	lsp_loading = function()
		return #vim.lsp.util.get_progress_messages() >= 1
	end,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
	color = { fg = colors.green, gui = "bold" },
}

local filename = {
	"filename",
	file_status = true,
	path = 1,
	color = { fg = colors.blue, gui = "bold" },
}

local location = {
	function()
		return "Ln " .. vim.fn.line(".") .. ",Col " .. vim.fn.col(".")
	end,
	color = { fg = colors.blue, gui = "bold" },
	cond = conditions.hide_in_width,
}

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", {})
end

local lsp_progress = {
	function()
		local progress_msgs = vim.lsp.util.get_progress_messages()
		local chosen_msg = progress_msgs[#progress_msgs]
		local server_name = chosen_msg.name
		local percentage = chosen_msg.percentage
		local message = chosen_msg.message
		local title = chosen_msg.title

		if server_name == "jdtls" then
			return nil
		end

		return string.format("[%s] %s %s %s", server_name, title, percentage .. "%%", message)
	end,
	color = { fg = colors.green, gui = "bold" },
	cond = conditions.lsp_active and conditions.hide_in_width and conditions.lsp_loading,
}

local lsp = {
	function()
		local buf_ft = vim.bo.filetype
		local clients = vim.lsp.get_clients()
		local msg_lsp = ""
		local default_msg = "No Active Lsp"
		local ignore_list = { "gitsigns" }
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if client.name == "jdtls" then
				filetypes = { "java" }
			end
			if filetypes ~= nil and vim.tbl_contains(filetypes, buf_ft) then
				if msg_lsp == "" then
					msg_lsp = client.name
				elseif not string.match(msg_lsp, client.name) then
					msg_lsp = msg_lsp .. "," .. client.name
				end
			end
		end

		local ok, conform = pcall(require, "conform")
		if ok then
			local bufnr = vim.api.nvim_get_current_buf()
			local formatters = conform.list_formatters(bufnr)
			for _, formatter in ipairs(formatters) do
				if msg_lsp == "" then
					msg_lsp = formatter.name
				elseif not string.match(msg_lsp, formatter.name) then
					msg_lsp = msg_lsp .. "," .. formatter.name
				end
			end
		end

		local ok, nvim_lint = pcall(require, "lint")
		if ok then
			local filetype = vim.api.nvim_get_option_value("filetype", {})
			local linters = nvim_lint.linters_by_ft[filetype]
			if linters == nil then
				goto continue
			end
			for _, linter in ipairs(linters) do
				if msg_lsp == "" then
					msg_lsp = linter
				elseif not string.match(msg_lsp, linter) then
					msg_lsp = msg_lsp .. "," .. linter
				end
			end
		end

		::continue::
		if msg_lsp == "" then
			return default_msg
		else
			return msg_lsp
		end
	end,
	-- icon = " LSP:",
	icon = " ",
	color = { fg = colors.white_alt, gui = "bold" },
	cond = conditions.hide_in_width,
}

local config = {
	options = {
		theme = "auto",
		globalstatus = true,
		section_separators = { "", "" },
		component_separators = { "", "" },
		-- section_separators = { "", "" },
		-- component_separators = { "", "" },
		-- always_divide_middle = true,
	},

	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	extensions = { "quickfix", "nvim-tree", "fzf" },
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = { fg = colors.blue }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	function()
		return vim.fn.mode():upper()
		-- return ""
	end,
	color = function()
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.cyan,
			S = colors.cyan,
			[""] = colors.cyan,
			ic = colors.yellow,
			R = colors.magenta_alt,
			Rv = colors.magenta_alt,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan_alt,
			rm = colors.cyan_alt,
			["r?"] = colors.cyan_alt,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	-- color = "LualineMode",
	padding = { right = 1 },
})

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})

-- ins_left(lsp_progress)

ins_left("%=")

ins_left({
	"filetype",
	colored = true,
	icon_only = true,
	padding = 0,
})
ins_left(filename)

ins_right(lsp)

ins_right({
	spaces,
	color = { fg = colors.yellow, gui = "bold" },
})

ins_right(branch)

ins_right({
	"diff",
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.yellow },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})

return {
	{ "nvim-lualine/lualine.nvim", opts = config, event = "VeryLazy" },
}
