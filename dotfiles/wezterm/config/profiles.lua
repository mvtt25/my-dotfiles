-- Launch profiles and workspace definitions
-- Allows switching between Claude CLI accounts and project workspaces

local wezterm = require("wezterm")

local M = {}

-- Predefined workspaces with name and working directory
local workspaces = {
	{
		name = "buzz-up",
		cwd = wezterm.home_dir .. "/Dev-Env/git-repositories/work/buzz-up",
	},
	{
		name = "app-template",
		cwd = wezterm.home_dir .. "/Dev-Env/git-repositories/work/app-template",
	},
	{
		name = "agent-flow",
		cwd = wezterm.home_dir .. "/Dev-Env/git-repositories/work/agent-flow",
	},
}

function M.apply_to_config(config)
	-- Launch Menu configuration
	config.launch_menu = {
		{
			label = "Claude Account 1 (Personal)",
			args = { "zsh", "-l", "-c", "export CLAUDE_CONFIG_HOME=~/.claude-personal && exec zsh" },
		},
		{
			label = "Claude Account 2 (Work)",
			args = { "zsh", "-l", "-c", "export CLAUDE_CONFIG_HOME=~/.claude-work && exec zsh" },
		},
		{
			label = "Default Shell (No Claude Override)",
			args = { "zsh", "-l" },
		},
	}

	-- Workspace setup: restore saved states, then create the predefined
	-- workspaces that had nothing to restore.
	-- default_window: an already-spawned default-workspace window to
	-- restore into (nil when running inside the mux server).
	local function setup_workspaces(default_window)
		local restored = { default = true }

		local ok, persistence = pcall(require, "config.persistence")
		if ok then
			restored = persistence.bootstrap(default_window)
		elseif not default_window then
			wezterm.mux.spawn_window({})
		end

		for _, ws in ipairs(workspaces) do
			if not restored[ws.name] then
				wezterm.mux.spawn_window({
					workspace = ws.name,
					cwd = ws.cwd,
				})
			end
		end

		wezterm.mux.set_active_workspace("default")
	end

	-- Normal launch path: the GUI connects to the unix mux server
	-- (see persistence.lua); this fires once when that server starts.
	wezterm.on("mux-startup", function()
		setup_workspaces(nil)
	end)

	-- Fallback path for a plain `wezterm start` (no mux server): the
	-- default-workspace window is spawned by appearance.lua's gui-startup
	-- handler (registered first) — spawning another one here is what
	-- created the duplicate tab on launch.
	wezterm.on("gui-startup", function()
		setup_workspaces(wezterm.mux.all_windows()[1])
	end)

	return config
end

return M
