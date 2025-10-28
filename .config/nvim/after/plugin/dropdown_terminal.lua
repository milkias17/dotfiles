local windows = {
	dropdowns = {},
}

local MAX_TERM = 9

local idx_ns = vim.api.nvim_create_namespace("dropdownterminal_index")
local last_opened = nil

vim.api.nvim_set_hl(0, "DropDownTerminalLabel", { fg = "#ffcc00", bg = "NONE", bold = true })

setmetatable(windows.dropdowns, {
	__index = function(t, k)
		if rawget(t, k) == nil then
			rawset(t, k, { buf = -1, win = -1 })
		end
		return t[k]
	end,
})

local function create_dropdown_window(buf_id, index)
	local buf = nil
	if buf_id ~= nil and vim.api.nvim_buf_is_valid(buf_id) then
		buf = buf_id
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local width = vim.o.columns
	local height = 15
	-- local row = vim.o.lines - height - vim.o.cmdheight
	-- local col = 0
	local opts = {
		style = "minimal",
		width = width,
		focusable = true,
		split = "below",
		height = height,
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.wo[win].winbar = "%#DropDownTerminalLabel# %=Terminal [" .. index .. "]%= %*"
	return { buf = buf, win = win }
end

local function toggle_dropdown()
	local index = 1
	if last_opened ~= nil then
		index = last_opened
	end
	if vim.v.count > 0 then
		index = math.min(vim.v.count, MAX_TERM)
	end

	local window = windows.dropdowns[index]

	if not vim.api.nvim_win_is_valid(window.win) then
		windows.dropdowns[index] = create_dropdown_window(window.buf, index)
		window = windows.dropdowns[index]
		if vim.bo[window.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
		vim.cmd("startinsert") -- Enter terminal mode automatically
	else
		vim.api.nvim_win_hide(window.win)
		vim.api.nvim_buf_clear_namespace(window.buf, idx_ns, 0, -1)
	end
	last_opened = index
end

-- create a command to open the dropdown window
vim.api.nvim_create_user_command("Opendropdown", function()
	toggle_dropdown()
end, {})

vim.keymap.set({ "n", "t" }, "<A-t>", function()
	toggle_dropdown()
end, { silent = true })
