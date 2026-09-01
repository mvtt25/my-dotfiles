-- Keybindings configuration for WezTerm
-- Tmux-style navigation with SHIFT+Space leader key

local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
  -- Leader key: SHIFT+Space with 2 second timeout
  config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 2000 }

  -- Keybindings
  config.keys = {
    -- Reload Configuration
    {
      mods = "CMD",
      key = "r",
      action = wezterm.action.ReloadConfiguration,
    },

    -- Profile Switcher (Launch Menu)
    {
      mods = "LEADER",
      key = "p",
      action = wezterm.action.ShowLauncher,
    },

    -- Tab Management
    {
      mods = "LEADER",
      key = "c",
      action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
      mods = "LEADER",
      key = "x",
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
      mods = "LEADER",
      key = "b",
      action = wezterm.action.ActivateTabRelative(-1),
    },
    {
      mods = "LEADER",
      key = "n",
      action = wezterm.action.ActivateTabRelative(1),
    },

    -- Tab Reordering
    {
      mods = "LEADER",
      key = "è",
      action = wezterm.action.MoveTabRelative(-1),
    },
    {
      mods = "LEADER",
      key = "+",
      action = wezterm.action.MoveTabRelative(1),
    },

    -- Pane Splitting
    {
      mods = "LEADER",
      key = "|",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      mods = "LEADER",
      key = "-",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    -- Pane Navigation
    {
      mods = "LEADER",
      key = "h",
      action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
      mods = "LEADER",
      key = "j",
      action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
      mods = "LEADER",
      key = "k",
      action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
      mods = "LEADER",
      key = "l",
      action = wezterm.action.ActivatePaneDirection("Right"),
    },

    -- Workspace: List/Switch (fuzzy picker)
    {
      mods = "LEADER",
      key = "w",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
    -- Workspace: Create new (prompt for name)
    {
      mods = "LEADER",
      key = "W",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(
          wezterm.action.PromptInputLine({
            description = wezterm.format({
              { Attribute = { Intensity = "Bold" } },
              { Foreground = { AnsiColor = "Fuchsia" } },
              { Text = "Enter name for new workspace" },
            }),
            action = wezterm.action_callback(function(inner_window, inner_pane, line)
              if line then
                inner_window:perform_action(
                  wezterm.action.SwitchToWorkspace({ name = line }),
                  inner_pane
                )
              end
            end),
          }),
          pane
        )
      end),
    },
    -- Workspace: Rename current
    {
      mods = "LEADER",
      key = "r",
      action = wezterm.action_callback(function(window, pane)
        local current_workspace = window:active_workspace()
        window:perform_action(
          wezterm.action.PromptInputLine({
            description = wezterm.format({
              { Attribute = { Intensity = "Bold" } },
              { Foreground = { AnsiColor = "Fuchsia" } },
              { Text = "Rename workspace '" .. current_workspace .. "' to:" },
            }),
            action = wezterm.action_callback(function(_, _, line)
              if line and #line > 0 then
                -- Rename all mux windows in the current workspace
                for _, mux_win in ipairs(wezterm.mux.all_windows()) do
                  if mux_win:get_workspace() == current_workspace then
                    mux_win:set_workspace(line)
                  end
                end
              end
            end),
          }),
          pane
        )
      end),
    },
    -- Pane Resizing
    {
      mods = "LEADER",
      key = "LeftArrow",
      action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
    },
    {
      mods = "LEADER",
      key = "RightArrow",
      action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
    },
    {
      mods = "LEADER",
      key = "DownArrow",
      action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
    },
    {
      mods = "LEADER",
      key = "UpArrow",
      action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
    },
  }

  -- Add number keys (0-9) for direct tab access
  for i = 0, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = wezterm.action.ActivateTab(i),
    })
  end

  return config
end

return M
