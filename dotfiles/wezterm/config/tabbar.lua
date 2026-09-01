-- Tab bar configuration for WezTerm — "Signal" design
--
-- Fancy tab bar (top of the window): it is the only tab bar with a font of its
-- own, so its height is set by window_frame.font_size instead of leaking into
-- the terminal's line_height.
--
-- Colour only where it carries information:
--   ● purple  active tab
--   ● pink    unread output — the agent finished and is waiting for you
--   ● dim     idle
--
-- Left:  $USER ❯ workspace, read as a prompt (LEADER replaces the name while
--        the leader key is held)
-- Right: CPU · memory · git branch · clock

local wezterm = require("wezterm")
local sysinfo = require("utils.sysinfo")
local git = require("utils.git")
local icons = require("utils.icons")
local theme = require("config.colors").theme

local M = {}

-- Every token the bar needs. A theme that omits statusbar entirely, or just one
-- token, degrades to these instead of taking the whole bar down with it.
local DEFAULTS = {
	bar_bg = "#0B0017",
	active_bg = "#3d2554",
	active_fg = "#e8e0f0",
	active_index = "#bf00ff",
	inactive_bg = "#0e0d16",
	inactive_fg = "#7a6b99",
	inactive_index = "#9d5fff",
	alert = "#ff2e97", -- unread output, hot metric, zoom
	dim = "#2f2745", -- idle dots and hairline rules share one value
	whisper = "#4a3b66", -- metrics at rest
	hover_fg = "#ff2e97", -- tab under the mouse
}

local C = setmetatable(theme.statusbar or {}, { __index = DEFAULTS })

local USER = os.getenv("USER") or "user"

-- Height of the tab bar: bump this to make the bar taller.
local BAR_FONT_SIZE = 15.0

-- A metric only asks for attention past these. Memory sits high on macOS by
-- design (app + wired + compressed), so its threshold is deliberately late:
-- on an 8 GB machine 80% is idle Tuesday, 95% is actually tight.
local HOT_CPU = 80 -- percent of one core-equivalent
local HOT_MEM = 0.95 -- share of total RAM

local MAX_NAME = 14

-- Shortest label that still identifies a tab: repo/dir name, then process,
-- then whatever the pane calls itself.
local function tab_label(tab)
	local pane = tab.active_pane
	local cwd = pane and pane.current_working_dir

	local name
	if cwd and cwd.file_path then
		name = cwd.file_path:match("([^/]+)/?$")
	end
	if not name or name == "" then
		local process = pane and pane.foreground_process_name or ""
		name = process:match("([^/\\]+)[/\\]?$")
	end
	if not name or name == "" then
		name = (pane and pane.title) or "shell"
	end

	if #name > MAX_NAME then
		name = name:sub(1, MAX_NAME - 1) .. "…"
	end
	return name
end

local function any_pane(tab, field)
	for _, pane in ipairs(tab.panes or {}) do
		if pane[field] then
			return true
		end
	end
	return false
end

local function format_tab_title(tab, _tabs, _panes, _config, hover, _max_width)
	local pane = tab.active_pane
	local dot = C.dim
	if tab.is_active then
		dot = C.active_index
	elseif any_pane(tab, "has_unseen_output") then
		dot = C.alert
	end

	local name_fg = C.inactive_fg
	if tab.is_active then
		name_fg = C.active_fg
	elseif hover then
		name_fg = C.hover_fg
	end

	local cells = {
		{ Background = { Color = tab.is_active and C.active_bg or C.bar_bg } },
		{ Foreground = { Color = dot } },
		{ Text = "  ●  " },
		{ Foreground = { Color = tab.is_active and C.active_index or C.inactive_index } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = tostring(tab.tab_index) },
		{ Foreground = { Color = C.dim } },
		{ Attribute = { Intensity = "Normal" } },
		{ Text = " │ " },
		{ Foreground = { Color = name_fg } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = icons.for_process(pane and pane.foreground_process_name) .. "  " .. tab_label(tab) },
	}

	if any_pane(tab, "is_zoomed") then
		table.insert(cells, { Foreground = { Color = C.alert } })
		table.insert(cells, { Text = " " .. wezterm.nerdfonts.oct_zoom_in })
	end

	table.insert(cells, { Attribute = { Intensity = "Normal" } })
	table.insert(cells, { Text = "  " })

	return cells
end

-- Left status as a prompt: who you are ❯ where you are. No background fills —
-- the fancy tab bar does not reliably paint them, and a lone block glyph reads
-- as a stray pipe.
local function left_status(window)
	local leader = window:leader_is_active()

	return wezterm.format({
		{ Foreground = { Color = leader and C.alert or C.active_index } },
		{ Attribute = { Intensity = leader and "Bold" or "Normal" } },
		{ Text = "  " .. (leader and "LEADER" or USER) },

		{ Foreground = { Color = C.whisper } },
		{ Attribute = { Intensity = "Normal" } },
		{ Text = " ❯ " },

		{ Foreground = { Color = C.active_fg } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = window:active_workspace() .. "  " },
		{ Attribute = { Intensity = "Normal" } },
	})
end

-- Right status, "Quiet": at rest the metrics are an icon and a bare numeral in a
-- whisper of a colour. Past HOT the offending one lights up whole — icon and
-- number, pink and bold.
local function metric_cells(cells, icon, value, hot)
	table.insert(cells, { Foreground = { Color = hot and C.alert or C.whisper } })
	table.insert(cells, { Attribute = { Intensity = hot and "Bold" or "Normal" } })
	table.insert(cells, { Text = icon .. " " .. value })
	table.insert(cells, { Attribute = { Intensity = "Normal" } })
end

-- Branch of whatever the focused pane is sitting in, empty outside a repo.
local function branch_of(pane)
	local cwd = pane and pane:get_current_working_dir()
	local dir = cwd and cwd.file_path
	if not dir then
		return nil
	end

	return git.branch(dir)
end

local function right_status(pane)
	local stats = sysinfo.sample()
	local cells = {}

	table.insert(cells, { Text = "  " })

	if stats.cpu then
		metric_cells(cells, wezterm.nerdfonts.md_cpu_64_bit, string.format("%d", math.floor(stats.cpu + 0.5)), stats.cpu >= HOT_CPU)
	end

	if stats.cpu and stats.mem then
		table.insert(cells, { Foreground = { Color = C.whisper } })
		table.insert(cells, { Text = " · " })
	end

	if stats.mem then
		local hot = stats.total_gb ~= nil and stats.mem >= stats.total_gb * HOT_MEM
		metric_cells(cells, wezterm.nerdfonts.md_memory, string.format("%.1f", stats.mem), hot)
	end

	local branch = branch_of(pane)
	if branch then
		table.insert(cells, { Foreground = { Color = C.active_index } })
		table.insert(cells, { Text = "  " .. wezterm.nerdfonts.md_source_branch .. " " })
		table.insert(cells, { Foreground = { Color = C.active_fg } })
		table.insert(cells, { Text = branch })
	end

	table.insert(cells, { Foreground = { Color = C.inactive_fg } })
	table.insert(cells, { Text = "  " .. wezterm.nerdfonts.md_clock_outline .. " " .. wezterm.strftime("%H:%M") .. "  " })

	return wezterm.format(cells)
end

function M.apply_to_config(config)
	-- The fancy tab bar (own font, own height, top of the window), the bar always
	-- visible and a 1s status refresh are all WezTerm defaults: not restated here.
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 32
	config.tab_and_split_indices_are_zero_based = true

	-- This is the tab bar height knob.
	config.window_frame = {
		font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
		font_size = BAR_FONT_SIZE,
		active_titlebar_bg = C.bar_bg,
		inactive_titlebar_bg = C.bar_bg,
		active_titlebar_fg = C.active_fg,
		inactive_titlebar_fg = C.inactive_fg,
	}

	config.colors = config.colors or {}
	config.colors.tab_bar = {
		background = C.bar_bg,
		active_tab = { bg_color = C.active_bg, fg_color = C.active_fg },
		inactive_tab = { bg_color = C.bar_bg, fg_color = C.inactive_fg },
		inactive_tab_hover = { bg_color = C.inactive_bg, fg_color = C.hover_fg },
		inactive_tab_edge = C.bar_bg,
	}

	wezterm.on("format-tab-title", format_tab_title)

	wezterm.on("update-status", function(window, pane)
		window:set_left_status(left_status(window))
		window:set_right_status(right_status(pane))
	end)

	return config
end

return M
