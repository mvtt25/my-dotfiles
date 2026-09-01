# WezTerm Configuration

Modular WezTerm configuration with optimized font rendering, performance settings, and custom tab bar with git status integration.

## Features

- Modular configuration architecture with error handling
- JetBrains Mono font with ligature support
- WebGPU rendering optimized for 144Hz displays
- Tmux-style keybindings with visual leader key indicator
- Custom tab bar with Powerline separators and git status
- Minimalist window styling with blur effects
- Centered window positioning with intelligent margins

## Structure

```
~/.config/wezterm/
├── wezterm.lua              # Main entry point
├── config/
│   ├── appearance.lua       # Window styling and positioning
│   ├── colors.lua           # Theme loader
│   ├── font.lua             # JetBrains Mono configuration
│   ├── keybindings.lua      # Tmux-style keybindings
│   ├── performance.lua      # WebGPU and FPS settings
│   ├── tabbar.lua           # Custom tab bar
│   └── themes/
│       ├── matt.lua         # Custom theme
│       └── vscode.lua       # VS Code Dark+ theme
└── utils/
    ├── git.lua              # Git status helpers
    └── icons.lua            # Directory icon mapping
```

## Keybindings

### Leader Key

**SHIFT + Space** (2 second timeout)

When active, displays: "recording..." in status line

### Tab Management

| Keybinding | Action |
|------------|--------|
| `LEADER + c` | Create new tab |
| `LEADER + x` | Close current pane (with confirmation) |
| `LEADER + b` | Previous tab |
| `LEADER + n` | Next tab |
| `LEADER + 0-9` | Switch to specific tab |

### Pane Splitting

| Keybinding | Action |
|------------|--------|
| `LEADER + \|` | Split horizontally |
| `LEADER + -` | Split vertically |

### Pane Navigation

| Keybinding | Action |
|------------|--------|
| `LEADER + h` | Move left |
| `LEADER + j` | Move down |
| `LEADER + k` | Move up |
| `LEADER + l` | Move right |

### Pane Resizing

| Keybinding | Action |
|------------|--------|
| `LEADER + LeftArrow` | Increase size left |
| `LEADER + RightArrow` | Increase size right |
| `LEADER + DownArrow` | Increase size down |
| `LEADER + UpArrow` | Increase size up |

### Other

| Keybinding | Action |
|------------|--------|
| `CMD + r` | Reload configuration |

## Configuration Details

### Font

- **Family**: JetBrains Mono
- **Size**: 13pt
- **Line Height**: 1.4
- **Features**: Ligatures enabled (calt, liga)

### Performance

- **Renderer**: WebGPU (fallback to OpenGL)
- **Max FPS**: 144
- **Animation FPS**: 144
- **Scrollback**: 10,000 lines
- **Cursor**: Blinking underline (800ms interval)

### Appearance

- **Window Decorations**: RESIZE (minimalist)
- **Background Opacity**: 0.60
- **macOS Blur**: 60
- **Window Padding**: 32px (left/right), 16px (top/bottom)
- **Tab Bar Position**: Bottom
- **Scrollbar**: Disabled

### Window Positioning

On startup, window is automatically:
- Centered on active screen
- Sized with 50px margin on all sides
- Maintains aspect ratio for optimal viewing

## Theme System

Themes are located in `config/themes/`. To switch themes:

1. Edit `config/colors.lua`
2. Change the require statement to desired theme
3. Reload configuration (`CMD + r`)

Available themes:
- `config.themes.matt` - Custom theme
- `config.themes.vscode` - VS Code Dark+ theme

## Tab Bar

Fancy tab bar, "Signal" design (`config/tabbar.lua`): a state dot per tab
(purple active / pink unread output / dim idle), the index, the process glyph
(`utils/icons.lua`) and the directory name. Height is set by `BAR_FONT_SIZE` at
the top of the file — the bar has its own font, so the terminal's `line_height`
is free to be a typographic choice.

Left: `$USER ❯ workspace`, read as a prompt; `$USER` becomes `LEADER` in pink
while the leader key is held. Right: CPU and memory as numerals behind their
glyphs in a whisper colour, going pink and bold past `HOT_CPU` (80%) /
`HOT_MEM` (95% of RAM), then the git branch of the focused pane and the clock.

Metrics are sampled every 3s by `utils/sysinfo.lua` — memory live from `vm_stat`,
CPU as a real rate from the delta of cumulative process CPU time over the window
(not `ps -o %cpu`, which is a decaying ~1 minute average); the branch is read from
`.git/HEAD` by `utils/git.lua`, never by running `git`. Colours come from the
active theme's `M.statusbar` table, with a full set of defaults in
`config/tabbar.lua` so a theme missing a token degrades instead of breaking.

## Customization

Each module exports an `apply_to_config` function that immutably applies settings:

```lua
function M.apply_to_config(config)
  config.font_size = 14.0
  return config
end
```

To customize:

1. Edit the relevant module file
2. Modify the settings
3. Reload configuration (`CMD + r`)

All changes are validated with error handling at startup.

## Error Handling

The configuration includes automatic error handling:
- Failed module loads are logged with warnings
- Runtime errors during module application are caught
- Graceful degradation if modules are missing

Check logs with:
```bash
wezterm show-debug-overlay
```

## Requirements

- WezTerm (latest version recommended)
- JetBrains Mono font
- macOS (for blur effects and window positioning)
- WebGPU-capable GPU (fallback to OpenGL available)

## Installation

1. Clone or copy this configuration to `~/.config/wezterm/`
2. Install JetBrains Mono font
3. Launch WezTerm
4. Configuration loads automatically

## License

MIT
