-- ~/.config/nvim/lua/plugins/todo-comments.lua
return {
  'folke/todo-comments.nvim',
  opts = {
    keywords = {
      FIX = { icon = ' ', color = 'error', alt = { 'BUG', 'FIXME' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING' } },
      PERF = { icon = ' ', alt = { 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    },
  },
}
