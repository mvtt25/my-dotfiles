-- Appearance configuration for WezTerm
-- Minimalist modern style with optimal window positioning

local wezterm = require("wezterm")

local M = {}

-- Window startup positioning: centered with margin
local function position_window(gui_window)
  local active_screen = wezterm.gui.screens().active
  local margin = 50

  gui_window:set_position(margin, margin)
  gui_window:set_inner_size(active_screen.width - (margin * 2), active_screen.height - (margin * 2))
end

local function setup_window_positioning()
  -- Plain `wezterm start` path: spawn the initial window and position it
  wezterm.on("gui-startup", function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})

    local gui_window = window:gui_window()
    if gui_window then
      position_window(gui_window)
    end
  end)

  -- Mux-server path (default launch, see persistence.lua): gui-startup
  -- never fires, position the attached windows here instead
  wezterm.on("gui-attached", function()
    for _, gui_window in ipairs(wezterm.gui.gui_windows()) do
      position_window(gui_window)
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
  config.macos_window_background_blur = 30 -- Enhanced blur

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

  -- Visual bell: a pane-wide pulse when the bell rings, which is how an agent
  -- says it is done. Colour in config/themes/, pink like the unread-output dot
  -- in the tab bar. Short enough to catch out of the corner of your eye and be
  -- gone before it annoys.
  config.visual_bell = {
    fade_in_function = "EaseOut",
    fade_in_duration_ms = 90,
    fade_out_function = "EaseIn",
    fade_out_duration_ms = 220,
    target = "BackgroundColor",
  }

  -- Scrollbar: Disabled for minimalist look
  config.enable_scroll_bar = false

  -- Font size adjustment: Don't resize window
  config.adjust_window_size_when_changing_font_size = false

  -- Setup window positioning hook
  setup_window_positioning()

  return config
end

return M
