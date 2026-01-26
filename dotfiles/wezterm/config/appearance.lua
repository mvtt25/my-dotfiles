-- Appearance configuration for WezTerm
-- Minimalist modern style with optimal window positioning

local wezterm = require("wezterm")

local M = {}

-- Window startup positioning: centered with margin
local function setup_window_positioning()
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

		-- Get active screen dimensions
		local screens = wezterm.gui.screens()
		local active_screen = screens.active

		-- Calculate window dimensions with margin
		local margin = 50
		local width = active_screen.width - (margin * 2)
		local height = active_screen.height - (margin * 2)

		-- Set window position and size
		local gui_window = window:gui_window()
		if gui_window then
			gui_window:set_position(margin, margin)
			gui_window:set_inner_size(width, height)
		end
	end)
end

function M.apply_to_config(config)
	-- Window decorations: Minimalist (resize only)
	config.window_decorations = "RESIZE"

	-- Window close confirmation: Never prompt
	config.window_close_confirmation = "NeverPrompt"

	-- Transparency and blur for premium effect
	config.window_background_opacity = 0.60 -- More readable than 0.90
	config.macos_window_background_blur = 60 -- Enhanced blur

	-- Window padding: Generous spacing
	config.window_padding = {
		left = 32,
		right = 32,
		top = 16,
		bottom = 16,
	}

	-- Initial size (fallback if gui-startup doesn't work)
	config.initial_rows = 45
	config.initial_cols = 180

	-- Scrollbar: Disabled for minimalist look
	config.enable_scroll_bar = false

	-- Font size adjustment: Don't resize window
	config.adjust_window_size_when_changing_font_size = false

	-- Setup window positioning hook
	setup_window_positioning()

	return config
end

return M
