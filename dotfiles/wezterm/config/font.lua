-- Font configuration for WezTerm
-- Optimized for macOS with JetBrains Mono (modern, ligatures enabled)

local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
	-- Font: JetBrains Mono (clean, modern)
	config.font = wezterm.font("JetBrains Mono")

	-- Harfbuzz features: Enable ligatures
	config.harfbuzz_features = {
		"calt", -- Contextual alternates
		"liga", -- Standard ligatures
	}

	-- Font size: Slightly larger for better readability
	config.font_size = 13.0

	-- Line height: Increased for taller tab bar
	config.line_height = 1.4

	-- Cell width: Standard
	config.cell_width = 1.0

	-- Font rendering: Use defaults for cleaner rendering
	-- Note: WebGpu front_end is set in performance.lua

	return config
end

return M
