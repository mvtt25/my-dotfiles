-- Graphite — minimal dark theme for WezTerm
-- Neutral grays, desaturated palette, zero distractions
local M = {}

function M.apply_to_config(config)
  -- No color_scheme: "Graphite" is not a builtin scheme (WezTerm logs a hard
  -- error for a missing one) and every colour this theme needs is set below.

  config.colors = {
    -- Main colors
    foreground = "#b0b0b0",
    background = "#131313",

    -- Cursor — soft white
    cursor_bg = "#c8c8c8",
    cursor_fg = "#131313",
    cursor_border = "#c8c8c8",

    -- Selection — subtle lift
    selection_fg = "#d0d0d0",
    selection_bg = "#2a2a2a",

    -- UI elements
    scrollbar_thumb = "#1e1e1e",
    split = "#1e1e1e",
    visual_bell = "#241a1a",

    -- ANSI colors — full palette, muted
    ansi = {
      "#1e1e1e", -- black
      "#c47070", -- red       (dusty rose)
      "#7da67d", -- green     (sage)
      "#c4a96a", -- yellow    (wheat)
      "#7094b8", -- blue      (steel)
      "#9a80b0", -- magenta   (mauve)
      "#6fa5a0", -- cyan      (teal mist)
      "#b0b0b0", -- white
    },

    -- Bright colors — gentle lift
    brights = {
      "#3a3a3a", -- bright black
      "#d98e8e", -- bright red
      "#99bf99", -- bright green
      "#d9c48a", -- bright yellow
      "#8db0d0", -- bright blue
      "#b49ac8", -- bright magenta
      "#8ac0ba", -- bright cyan
      "#d0d0d0", -- bright white
    },

    -- Indexed colors
    indexed = {
      [16] = "#c49a6a", -- muted orange
      [17] = "#c47070", -- alias red
    },

    -- Tab bar — invisible
    tab_bar = {
      background = "#131313",
      active_tab = {
        bg_color = "#1e1e1e",
        fg_color = "#d0d0d0",
        intensity = "Normal",
      },
      inactive_tab = {
        bg_color = "#131313",
        fg_color = "#505050",
      },
      inactive_tab_hover = {
        bg_color = "#1a1a1a",
        fg_color = "#808080",
      },
      new_tab = {
        bg_color = "#131313",
        fg_color = "#505050",
      },
      new_tab_hover = {
        bg_color = "#1a1a1a",
        fg_color = "#808080",
      },
    },
  }

  config.force_reverse_video_cursor = true

  return config
end

-- ── Statusbar colors (consumed by config/tabbar.lua) ──────
M.statusbar = {
  active_bg = "#1e1e1e",
  active_fg = "#d0d0d0",
  active_index = "#7094b8",

  inactive_bg = "#131313",
  inactive_fg = "#505050",
  inactive_index = "#4a5a6a",

  bar_bg = "#131313",
  alert = "#c47070",
  dim = "#2a2a2a",
  whisper = "#3f3f3f",
  hover_fg = "#808080",

  leader_bg = "#7094b8",
  leader_fg = "#131313",
}

return M
