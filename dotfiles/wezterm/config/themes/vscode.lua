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

return M
