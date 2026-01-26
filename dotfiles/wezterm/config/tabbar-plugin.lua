-- Tab bar configuration using tabline.wez plugin
-- Advanced tab bar with sections, icons, and customization

local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local M = {}

-- Custom component: Leader status indicator
local function leader_status()
	return function(window)
		if window:leader_is_active() then
			return " 🌊 recording..."
		end
		return " 💲mvtt "
	end
end

-- Custom component: Tab index starting from 0
local function tab_index_zero()
	return function(tab)
		return tostring(tab.tab_index)
	end
end

function M.apply_to_config(config)
	-- Configure tabline plugin with custom settings
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = "Tokyo Night",
			tabs_enabled = true,
			theme_overrides = {
				tab = {
					active = { fg = "#89b4fa", bg = "#313244" },
					inactive = { fg = "#cdd6f4", bg = "#181825" },
					inactive_hover = { fg = "#f5c2e7", bg = "#313244" },
				},
			},
			section_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
			component_separators = {
				left = wezterm.nerdfonts.pl_left_soft_divider,
				right = wezterm.nerdfonts.pl_right_soft_divider,
			},
			tab_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
		},
		sections = {
			tabline_a = { leader_status() },
			tabline_b = { "workspace" },
			tabline_c = { " " },
			tab_active = {
				tab_index_zero(),
				" ",
				wezterm.nerdfonts.pl_left_soft_divider,
				" ",
				{ "parent", padding = 0 },
				"/",
				{ "cwd", padding = { left = 0, right = 1 } },
				{ "zoomed", padding = 0 },
			},
			tab_inactive = {
				tab_index_zero(),
				" ",
				wezterm.nerdfonts.pl_left_soft_divider,
				" ",
				{ "process", padding = { left = 0, right = 1 } },
			},
			tabline_x = { "ram", "cpu" },
			tabline_y = { "datetime", "battery" },
			tabline_z = { "domain" },
		},
		extensions = {},
	})
	-- Apply plugin configuration
	tabline.apply_to_config(config)

	return config
end

return M
