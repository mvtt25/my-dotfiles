-- Workspace persistence, two complementary layers:
--
-- 1. Unix mux domain: tabs/panes live in a background wezterm-mux-server
--    that survives closing the GUI, so running processes (claude, ssh,
--    dev servers...) stay alive and reattach untouched on reopen.
-- 2. resurrect.wezterm: covers reboots/logouts (which kill the mux
--    server too) by restoring tab/pane structure, cwd and scrollback.
--    Processes are not resurrectable — e.g. rerun `claude --continue`.
--
-- WezTerm has no exit/close event, so resurrect state is saved on a short
-- periodic timer instead.
-- ponytail: 60s periodic save, not save-on-close (no such hook in wezterm)

local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local M = {}

local SAVE_INTERVAL_SECONDS = 60

-- resurrect's own get_workspace_state() only reads the *active* workspace,
-- so build the state for any workspace by filtering mux windows ourselves
local function state_for_workspace(name)
	local state = { workspace = name, window_states = {} }
	for _, win in ipairs(wezterm.mux.all_windows()) do
		if win:get_workspace() == name then
			table.insert(state.window_states, resurrect.window_state.get_window_state(win))
		end
	end
	return state
end

function M.save_all_workspaces()
	for _, name in ipairs(wezterm.mux.get_workspace_names()) do
		local state = state_for_workspace(name)
		if #state.window_states > 0 then
			resurrect.state_manager.save_state(state)
		end
	end
end

-- Names of workspaces that have a saved state file on disk
function M.saved_workspace_names()
	local names = {}
	local dir = resurrect.state_manager.save_state_dir .. "/workspace"
	local ok, entries = pcall(wezterm.read_dir, dir)
	if ok and entries then
		for _, path in ipairs(entries) do
			local name = path:match("([^/]+)%.json$")
			if name then
				table.insert(names, name)
			end
		end
	end
	return names
end

-- Re-launch claude with --continue in panes where it was running, so the
-- conversation resumes after a reboot; everything else gets the default
-- restore (other alt-screen apps re-launched, shells get scrollback back)
local function on_pane_restore(pane_tree)
	local argv = pane_tree.process and pane_tree.process.argv
	local is_claude = pane_tree.alt_screen_active
		and argv
		and argv[1]
		and argv[1]:match("[^/]+$") == "claude"

	if is_claude then
		local resumes = false
		for _, arg in ipairs(argv) do
			if arg == "--continue" or arg == "-c" or arg == "--resume" or arg == "-r" then
				resumes = true
			end
		end

		local cmd = wezterm.shell_join_args(argv)
		if not resumes then
			cmd = cmd .. " --continue"
		end
		pane_tree.pane:send_text(cmd .. "\r\n")
		return
	end

	resurrect.tab_state.default_on_pane_restore(pane_tree)
end

-- Restore a workspace's saved tabs/panes.
-- With target_window, restores into that window (replacing its tabs);
-- otherwise spawns new windows inside the workspace.
-- Returns true when a saved state was found and restored.
function M.restore(name, target_window)
	local loaded, state = pcall(resurrect.state_manager.load_state, name, "workspace")
	if not loaded or not state or not state.window_states or #state.window_states == 0 then
		return false
	end

	local opts = {
		relative = true,
		restore_text = true,
		on_pane_restore = on_pane_restore,
	}
	if target_window then
		opts.window = target_window
		opts.close_open_tabs = true
	else
		opts.spawn_in_workspace = true
	end

	return pcall(resurrect.workspace_state.restore_workspace, state, opts)
end

-- Restore every saved workspace at startup.
-- With default_window (plain `wezterm start` path), the default
-- workspace's tabs are restored into it; inside the mux server a fresh
-- default window is spawned when there is nothing to restore.
-- Returns the set of restored workspace names.
function M.bootstrap(default_window)
	local restored = { default = true }

	if not M.restore("default", default_window) and not default_window then
		wezterm.mux.spawn_window({})
	end

	for _, name in ipairs(M.saved_workspace_names()) do
		if not restored[name] and M.restore(name) then
			restored[name] = true
		end
	end

	return restored
end

local function schedule_periodic_save()
	wezterm.time.call_after(SAVE_INTERVAL_SECONDS, function()
		M.save_all_workspaces()
		schedule_periodic_save()
	end)
end

function M.apply_to_config(config)
	-- Launch the GUI attached to the unix mux server (auto-started on
	-- first connect) so closing the window never kills the sessions
	config.unix_domains = { { name = "unix" } }
	config.default_gui_startup_args = { "connect", "unix" }

	-- Only the mux server saves: it owns the real (local-domain) panes,
	-- while resurrect skips text/process info for the GUI's proxied
	-- unix-domain panes — a GUI save would clobber good state.
	-- ponytail: a plain `wezterm start` (no mux server) never saves
	if wezterm.gui == nil then
		schedule_periodic_save()
	end
	return config
end

return M
