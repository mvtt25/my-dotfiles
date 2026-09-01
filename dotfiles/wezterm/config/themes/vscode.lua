-- Cyberdream theme → VS Code Dark+ inspired
-- Optimized for readability and low eye strain

local M = {}

function M.apply_to_config(config)
	config.color_scheme = "Tokyo Night" -- base, overridden below

	config.colors = {
		-- Main colors (VS Code Dark+)
		foreground = "#d4d4d4",
		background = "#1e1e1e",

		-- Cursor
		cursor_bg = "#d4d4d4",
		cursor_fg = "#1e1e1e",
		cursor_border = "#d4d4d4",

		-- Selection
		selection_fg = "#ffffff",
		selection_bg = "#264f78",

		-- UI elements
		scrollbar_thumb = "#424242",
		split = "#2d2d2d",
		visual_bell = "#3a2020",

		-- ANSI colors (VS Code Dark+)
		ansi = {
			"#1e1e1e", -- black
			"#f44747", -- red
			"#608b4e", -- green
			"#dcdcaa", -- yellow
			"#569cd6", -- blue
			"#c586c0", -- magenta
			"#4ec9b0", -- cyan
			"#d4d4d4", -- white
		},

		brights = {
			"#808080", -- bright black
			"#f44747",
			"#608b4e",
			"#dcdcaa",
			"#569cd6",
			"#c586c0",
			"#4ec9b0",
			"#ffffff",
		},

		-- Indexed colors (extra accents)
		indexed = {
			[16] = "#ce9178", -- strings / orange
			[17] = "#f44747", -- errors
		},

		-- Tab bar (VS Code style)
		tab_bar = {
			background = "#1e1e1e",
			active_tab = {
				bg_color = "#252526",
				fg_color = "#ffffff",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#1e1e1e",
				fg_color = "#858585",
			},
			inactive_tab_hover = {
				bg_color = "#2a2d2e",
				fg_color = "#d4d4d4",
			},
			new_tab = {
				bg_color = "#1e1e1e",
				fg_color = "#858585",
			},
			new_tab_hover = {
				bg_color = "#2a2d2e",
				fg_color = "#d4d4d4",
			},
		},
	}

	-- Cursor visibility like VS Code
	config.force_reverse_video_cursor = true

	return config
end

-- ── Statusbar colors (consumed by config/tabbar.lua) ──────
M.statusbar = {
	active_bg = "#252526",
	active_fg = "#ffffff",
	active_index = "#569cd6",

	inactive_bg = "#1e1e1e",
	inactive_fg = "#858585",
	inactive_index = "#4a7ba8",

	bar_bg = "#1e1e1e",
	alert = "#f44747",
	dim = "#3a3a3a",
	whisper = "#5a5a5a",
	hover_fg = "#d4d4d4",

	leader_bg = "#569cd6",
	leader_fg = "#1e1e1e",
}

return M
