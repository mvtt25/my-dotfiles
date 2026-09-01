-- ╔══════════════════════════════════════════════════════════════╗
-- ║  NEON VOID — Cyberpunk theme for WezTerm                   ║
-- ║  Electric purple · Hot pink accents · Soft dark background  ║
-- ╚══════════════════════════════════════════════════════════════╝

local M = {}

-- Palette reference:
--   bg_deep    = #0a0a0f    (main background)
--   bg_surface = #12111a    (surfaces, panels)
--   bg_raised  = #1c1a2e    (elevated elements)
--   purple     = #bf00ff    (primary accent)
--   pink       = #ff2e97    (secondary accent)
--   lavender   = #d4b0ff    (foreground text)
--   muted      = #7a6b99    (comments, inactive)
--   white_soft = #e8e0f0    (bright foreground)

function M.apply_to_config(config)
  config.color_scheme = "Tokyo Night"

  config.colors = {
    -- ── Main ──────────────────────────────────────────────
    foreground = "#d4b0ff",
    background = "#030303",

    -- ── Cursor ────────────────────────────────────────────
    cursor_bg = "#bf00ff",
    cursor_fg = "#0a0a0f",
    cursor_border = "#bf00ff",

    -- ── Selection ─────────────────────────────────────────
    selection_fg = "#e8e0f0",
    selection_bg = "#3d1a5c",

    -- ── UI ────────────────────────────────────────────────
    scrollbar_thumb = "#1c1a2e",
    split = "#2a1845",

    -- Bell flash: a pink-tinted pulse, same signal as the pink tab dot
    visual_bell = "#2e0a24",

    -- ── ANSI (normal) ─────────────────────────────────────
    -- The same palette the tab bar speaks: purple primary, pink accent.
    ansi = {
      "#1c1a2e", -- black        (raised surface)
      "#ff2e97", -- red          (hot pink)
      "#a8e06a", -- green        (lime, slight warm tint)
      "#f0c060", -- yellow       (amber-gold)
      "#bf00ff", -- blue         (electric purple)
      "#e85cba", -- magenta      (pink-magenta)
      "#7ec8f0", -- cyan         (soft sky, cool)
      "#d4b0ff", -- white        (lavender)
    },

    -- ── ANSI (bright) ─────────────────────────────────────
    -- Every one of these differs from its normal counterpart: git diff, ls and
    -- agent output use the distinction to carry meaning, so it has to survive.
    brights = {
      "#3d2a5c", -- bright black   (muted purple)
      "#ff5cad", -- bright red     (lighter pink)
      "#c0f080", -- bright green   (brighter lime)
      "#f5d888", -- bright yellow  (lighter gold)
      "#d24fff", -- bright blue    (lighter electric purple)
      "#ff80d0", -- bright magenta (light pink)
      "#a0dcff", -- bright cyan    (brighter sky)
      "#e8e0f0", -- bright white   (soft white)
    },

    -- ── Indexed ───────────────────────────────────────────
    indexed = {
      [16] = "#d24fff", -- lighter purple
      [17] = "#ff2e97", -- hot pink
    },

    -- ── Tab bar ───────────────────────────────────────────
    tab_bar = {
      background = "#0B0017",

      active_tab = {
        bg_color = "#3d2554",
        fg_color = "#e8e0f0",
        intensity = "Bold",
      },

      inactive_tab = {
        bg_color = "#0e0d16",
        fg_color = "#7a6b99",
      },

      inactive_tab_hover = {
        bg_color = "#1c1a2e",
        fg_color = "#d4b0ff",
      },

      new_tab = {
        bg_color = "#0e0d16",
        fg_color = "#7a6b99",
      },

      new_tab_hover = {
        bg_color = "#1c1a2e",
        fg_color = "#bf00ff",
      },
    },
  }

  config.force_reverse_video_cursor = true

  -- Bold must not shift hue: on a neon palette the bright variants are a
  -- separate signal (see the ansi/brights tables above), not a weight.
  config.bold_brightens_ansi_colors = "No"

  -- ── Command palette (CMD+SHIFT+P) ─────────────────────────
  -- The launcher and workspace pickers have no colour options of their own:
  -- they render on the terminal palette above, so they follow it for free.
  config.command_palette_bg_color = "#12111a"
  config.command_palette_fg_color = "#d4b0ff"
  config.command_palette_font_size = 13.0

  return config
end

-- ── Statusbar colors (for tabbar.lua / plugin use) ────────
M.statusbar = {
  active_bg = "#3d2554",
  active_fg = "#e8e0f0",
  active_index = "#bf00ff",

  inactive_bg = "#0e0d16",
  inactive_fg = "#7a6b99",
  inactive_index = "#9d5fff",

  bar_bg = "#0B0017",
  alert = "#ff2e97", -- unread output / hot metric
  hover_fg = "#ff2e97", -- tab under the mouse
  dim = "#2f2745", -- idle dot, hairline rules
  whisper = "#4a3b66", -- metrics at rest: present, not loud

  leader_bg = "#b7bdf8",
  leader_fg = "#000000",

  plugin_active_fg = "#bf00ff",
  plugin_active_bg = "#1c1a2e",
  plugin_inactive_fg = "#d4b0ff",
  plugin_inactive_bg = "#181825",
  plugin_inactive_hover_fg = "#ff2e97",
  plugin_inactive_hover_bg = "#1c1a2e",
}

return M
