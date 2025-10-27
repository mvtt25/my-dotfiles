return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        style = "night",
        transparent = true,
        borderless_pickers = true,
        terminal_colors = true,
        saturation = 1,
      }
    end,
  },
}
