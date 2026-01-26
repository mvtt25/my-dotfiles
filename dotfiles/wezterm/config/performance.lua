-- Performance configuration for WezTerm
-- Optimized for 144 fps with WebGPU rendering

local M = {}

function M.apply_to_config(config)
	-- Front-end: WebGPU for modern rendering (fallback to OpenGL)
	-- WebGPU provides better performance and smoother rendering
	config.front_end = "WebGpu"

	-- FPS settings: Maximum quality for 144Hz displays
	config.max_fps = 144
	config.animation_fps = 144

	-- Scrollback buffer: Generous history
	config.scrollback_lines = 10000

	-- Cursor settings: Optimized for visibility and smoothness
	config.default_cursor_style = "BlinkingUnderline"
	config.cursor_thickness = "2px"
	config.cursor_blink_rate = 800

	-- Tab bar settings (layout only, styling in tabbar.lua)
	config.hide_tab_bar_if_only_one_tab = true -- Always show for consistency
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false -- Custom tab bar
	config.tab_and_split_indices_are_zero_based = true

	return config
end

return M
