local status, lualine = pcall(require, "lualine")
if not status then
	return
end

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
		return vim.fn.winwidth(0) > 110
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
    lsp_loading = function ()
        return #vim.lsp.util.get_progress_messages() >= 1
    end
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

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp_progress = {
    function ()
        local progress_msgs = vim.lsp.util.get_progress_messages()
        local chosen_msg = progress_msgs[#progress_msgs]
        local server_name = chosen_msg.name
        local percentage = chosen_msg.percentage
        local message = chosen_msg.message
        local title = chosen_msg.title

        return string.format("[%s] %s %s %s", server_name, title, percentage .. "%%", message)
    end,
    color = { fg = colors.green, gui = "bold"},
	cond = conditions.lsp_active and conditions.hide_in_width and conditions.lsp_loading
}

local lsp = {
	function()
		local buf_ft = vim.bo.filetype
		local clients = vim.lsp.get_active_clients()
		local found_lsp = false
		local msg_lsp = ""
		local default_msg = "No Active Lsp"
		if next(clients) == nil then
			return default_msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if client.name == "jdtls" then
				filetypes = { "java" }
			end
			if filetypes ~= nil and vim.tbl_contains(filetypes, buf_ft) then
				if client.name == "null-ls" then
					goto continue
				end
				if msg_lsp == "" then
					msg_lsp = client.name
				else
					msg_lsp = msg_lsp .. "," .. client.name
				end
			end
			::continue::
		end

		local sources = require("null-ls.sources")
		for _, source in ipairs(sources.get_available(buf_ft)) do
			if msg_lsp == "" then
				msg_lsp = source.name
			else
				msg_lsp = msg_lsp .. "," .. source.name
			end
		end

		if msg_lsp == "" then
			return default_msg
		else
			return msg_lsp
		end
	end,
	-- icon = " LSP:",
	icon = " ",
	color = { fg = colors.white_alt, gui = "bold" },
	cond = conditions.lsp_active and conditions.hide_in_width,
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

ins_left(lsp_progress)

ins_left({
	function()
		return "%="
	end,
})

ins_left({
	"filetype",
	colored = true,
	icon_only = true,
	padding = 0,
})
ins_left(filename)

ins_right(lsp)
ins_right(location)

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

lualine.setup(config)
