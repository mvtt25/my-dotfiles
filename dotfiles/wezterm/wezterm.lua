-- ============================================================================
-- WezTerm Configuration
-- ============================================================================
-- Modular configuration with optimized font rendering, performance,
-- and custom tab bar with icons and git status.
--
-- Structure:
--   config/font.lua        - Font configuration (JetBrains Mono)
--   config/colors.lua      - Theme loader (VS Code Dark+ / Cyberdream)
--   config/appearance.lua  - Window styling and positioning
--   config/performance.lua - WebGPU rendering and FPS settings
--   config/keybindings.lua - Tmux-style keybindings
--   config/tabbar.lua      - Custom tab bar with Powerline separators
--   config/tabbar-plugin.lua - Tabline.wez plugin (advanced tab bar)
--   utils/icons.lua        - Icon mapping for directories
--   utils/git.lua          - Git status helpers
--
-- ============================================================================
-- Keybindings Documentation
-- ============================================================================
-- Leader Key: SHIFT + Space (timeout: 2 seconds)
--
-- Tab Management:
--   LEADER + c           Create new tab
--   LEADER + x           Close current pane (with confirmation)
--   LEADER + b           Previous tab
--   LEADER + n           Next tab
--   LEADER + <0-9>       Switch to specific tab
--
-- Pane Splitting:
--   LEADER + |           Split horizontally
--   LEADER + -           Split vertically
--
-- Pane Navigation:
--   LEADER + h           Move left
--   LEADER + j           Move down
--   LEADER + k           Move up
--   LEADER + l           Move right
--
-- Pane Resizing:
--   LEADER + LeftArrow   Increase size left
--   LEADER + RightArrow  Increase size right
--   LEADER + DownArrow   Increase size down
--   LEADER + UpArrow     Increase size up
--
-- Status Line:
--   When leader is active, displays: 🌊 recording...
-- ============================================================================

local wezterm = require("wezterm")

-- Initialize configuration
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- ============================================================================
-- TABBAR CONFIGURATION SWITCH
-- ============================================================================
-- Switch between custom tabbar and tabline.wez plugin
-- Options: "config.tabbar" (custom) or "config.tabbar-plugin" (plugin)
local TABBAR_MODULE = "config.tabbar-plugin" -- Change to "config.tabbar-plugin" to use plugin

-- Load and apply configuration modules
-- Each module returns a table with an apply_to_config function
-- that immutably applies settings to the config

local modules = {
	"config.colors",
	"config.font",
	"config.performance",
	"config.keybindings",
	TABBAR_MODULE,
	"config.appearance",
}

-- Apply each module with error handling
for _, module_name in ipairs(modules) do
	local success, module = pcall(require, module_name)

	if success and module and type(module.apply_to_config) == "function" then
		local ok, err = pcall(function()
			config = module.apply_to_config(config)
		end)

		if not ok then
			wezterm.log_error("Error applying module " .. module_name .. ": " .. tostring(err))
		end
	else
		wezterm.log_warn("Could not load module " .. module_name)
	end
end

-- Return the final configuration
return config
