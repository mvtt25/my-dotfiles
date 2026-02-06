-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Cursor settings
-- Available styles: block, ver (vertical), hor (horizontal)
-- Format: mode-style-blink
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor", -- Normal, Visual, Command: block
  "i-ci-ve:ver15-Cursor/lCursor-blinkon500-blinkoff500", -- Insert: vertical line (25% width) blinking
  "r-cr:hor10-Cursor/lCursor", -- Replace: horizontal line (20% height)
  "o:hor50-Cursor/lCursor", -- Operator-pending: horizontal line (50%)
  "sm:block-Cursor/lCursor-blinkwait175-blinkoff150-blinkon175", -- Showmatch: blinking block
}
