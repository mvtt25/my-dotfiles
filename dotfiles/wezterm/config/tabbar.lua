-- Tab bar configuration for WezTerm
-- Clean tab bar with Powerline separators

local wezterm = require("wezterm")

local M = {}

-- Powerline separators
local SEPARATORS = {
	left = "",
	right = "",
}

-- Colors (matching cyberdream theme)
local COLORS = {
	active_bg = "#3d2554",
	active_fg = "#d8c6f2",
	active_index = "#b7bdf8", -- Bright accent for active tab index
	inactive_bg = "#1a0028",
	inactive_fg = "#8b7aa8",
	inactive_index = "#6366f1", -- Muted accent for inactive tab index
	bar_bg = "#0B0017",
	leader_bg = "#b7bdf8",
	leader_fg = "#24273a",
}

-- Format tab title without icons
local function format_tab_title(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	local tab_index = tab.tab_index

	-- Truncate title if too long
	local max_title_length = 25
	if #title > max_title_length then
		title = title:sub(1, max_title_length - 3) .. "..."
	end

	-- Determine if this tab is active
	local is_active = tab.is_active

	-- Colors
	local bg = is_active and COLORS.active_bg or COLORS.inactive_bg
	local title_fg = is_active and COLORS.active_fg or COLORS.inactive_fg
	local index_fg = is_active and COLORS.active_index or COLORS.inactive_index

	-- Build formatted tab with Powerline separators and colored index
	local formatted_tab = {
		{ Background = { Color = COLORS.bar_bg } },
		{ Foreground = { Color = bg } },
		{ Text = SEPARATORS.left },
		{ Background = { Color = bg } },
		{ Foreground = { Color = index_fg } },
		{ Text = string.format("   %d", tab_index) },
		{ Foreground = { Color = title_fg } },
		{ Text = string.format(" | %s    ", title) },
		{ Background = { Color = COLORS.bar_bg } },
		{ Foreground = { Color = bg } },
		{ Text = SEPARATORS.right },
	}

	return formatted_tab
end

-- Setup status bars: fixed text that switches to recording indicator
local function setup_status_bars()
	wezterm.on("update-right-status", function(window, pane)
		-- Left status: Switch between fixed text and recording indicator
		local solid_left_arrow = " 💲 mvtt "
		local arrow_foreground = { Foreground = { Color = "#000000" } }
		local prefix = ""

		if window:leader_is_active() then
			prefix = " 🌊 recording... "
			solid_left_arrow = utf8.char(0xe0b2)
		end

		window:set_left_status(wezterm.format({
			{ Background = { Color = "#b7bdf8" } },
			{ Foreground = { Color = "#000000" } },
			{ Text = prefix },
			arrow_foreground,
			{ Text = solid_left_arrow },
		}))
	end)
end

function M.apply_to_config(config)
	-- Setup custom tab title formatting
	wezterm.on("format-tab-title", format_tab_title)

	-- Setup status bars (username + leader indicator)
	setup_status_bars()

	return config
end

return M
