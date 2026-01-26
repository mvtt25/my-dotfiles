-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Cursor settings
-- Stili disponibili: block, ver (verticale), hor (orizzontale)
-- Formato: mode-style-blink
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor", -- Normal, Visual, Command: blocco
  "i-ci-ve:ver15-Cursor/lCursor-blinkon500-blinkoff500", -- Insert: linea verticale (25% larghezza) lampeggiante
  "r-cr:hor10-Cursor/lCursor", -- Replace: linea orizzontale (20% altezza)
  "o:hor50-Cursor/lCursor", -- Operator-pending: linea orizzontale (50%)
  "sm:block-Cursor/lCursor-blinkwait175-blinkoff150-blinkon175", -- Showmatch: blocco lampeggiante
}
