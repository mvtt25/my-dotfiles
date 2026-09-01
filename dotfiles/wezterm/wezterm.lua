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
--   config/tabbar.lua      - Custom fancy tab bar ("Signal" design)
--   config/persistence.lua - Workspace tab persistence (resurrect.wezterm)
--   utils/sysinfo.lua      - CPU / memory sampling for the tab bar
--   utils/icons.lua        - Process glyphs for the tab bar
--   utils/git.lua          - Branch name read from .git/HEAD
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
--   LEADER + p           Show profile/launch menu (Claude accounts)
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
-- Workspaces:
--   LEADER + w           List/switch workspaces (fuzzy picker)
--   LEADER + W           Create new workspace (prompt for name)
--   LEADER + r           Rename current workspace
--
-- Tab Bar:
--   Left:  $USER (LEADER while the leader key is held)
--   Tabs:  ● purple active | ● pink unread output | ● dim idle, then the
--          index, the process glyph and the directory name
--   Right: CPU · MEM · workspace · clock
-- ============================================================================

local wezterm = require("wezterm")

-- Initialize configuration
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Load and apply configuration modules
-- Each module returns a table with an apply_to_config function
-- that immutably applies settings to the config

local modules = {
	"config.colors",
	"config.font",
	"config.performance",
	"config.keybindings",
	"config.tabbar",
	"config.appearance",
	"config.profiles",
	"config.persistence",
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
