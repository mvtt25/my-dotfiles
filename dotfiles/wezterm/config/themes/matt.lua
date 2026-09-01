-- Cyberdream theme for WezTerm (refined)
-- Optimized for reduced eye strain and better readability

local M = {}

function M.apply_to_config(config)
	config.color_scheme = "Tokyo Night" -- Base scheme (can be overridden by custom colors)

	-- Custom cyberdream colors (original)
	config.colors = {
		-- Main colors
		foreground = "#d8c6f2",
		background = "#0B0017",

		-- Cursor
		cursor_bg = "#d8c6f2",
		cursor_fg = "#2e1b47",
		cursor_border = "#d8c6f2",

		-- Selection
		selection_fg = "#5a3d75",
		selection_bg = "#1C0139",

		-- UI elements
		scrollbar_thumb = "#16181a",
		split = "#16181a",
		visual_bell = "#2e1a14",

		-- ANSI colors
		ansi = {
			"#16181a",
			"#ff6e5e",
			"#5eff6c",
			"#f1ff5e",
			"#5ea1ff",
			"#bd5eff",
			"#5ef1ff",
			"#ffffff",
		},

		-- Bright colors
		brights = {
			"#3c4048",
			"#ff6e5e",
			"#5eff6c",
			"#f1ff5e",
			"#5ea1ff",
			"#bd5eff",
			"#5ef1ff",
			"#ffffff",
		},

		-- Indexed colors
		indexed = {
			[16] = "#ffbd5e", -- Orange
			[17] = "#ff6e5e", -- Red-orange
		},

		-- Tab bar colors (will be used in tabbar.lua)
		tab_bar = {
			background = "#0B0017",
			active_tab = {
				bg_color = "#3d2554",
				fg_color = "#e5d4ff",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#1a0028",
				fg_color = "#8b7aa8",
			},
			inactive_tab_hover = {
				bg_color = "#2a1638",
				fg_color = "#b8a5d0",
			},
			new_tab = {
				bg_color = "#1a0028",
				fg_color = "#8b7aa8",
			},
			new_tab_hover = {
				bg_color = "#2a1638",
				fg_color = "#b8a5d0",
			},
		},
	}

	-- Force reverse video cursor for better visibility
	config.force_reverse_video_cursor = true

	return config
end

M.statusbar = {
	active_bg = "#3d2554",
	active_fg = "#d8c6f2",
	active_index = "#b7bdf8",
	inactive_bg = "#1a0028",
	inactive_fg = "#8b7aa8",
	inactive_index = "#6366f1",
	bar_bg = "#0B0017",
	alert = "#ff6e5e",
	dim = "#2f2745",
	whisper = "#4a3b66",
	hover_fg = "#f5c2e7",
	leader_bg = "#b7bdf8",
	leader_fg = "#000000",
	plugin_active_fg = "#89b4fa",
	plugin_active_bg = "#313244",
	plugin_inactive_fg = "#cdd6f4",
	plugin_inactive_bg = "#181825",
	plugin_inactive_hover_fg = "#f5c2e7",
	plugin_inactive_hover_bg = "#313244",
}

return M
