return {
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        identifiers = { italic = false },
        functions = {},
        variables = {},
      },
      terminal_colors = true,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd([[colorscheme tokyodark]])
    end,
  },
  -- Previous configuration (tokyonight):
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = true,
  --   priority = 1000,
  --   opts = function()
  --     return {
  --       style = "night",
  --       transparent = false,
  --       borderless_pickers = true,
  --       terminal_colors = true,
  --       saturation = 1,
  --     }
  --   end,
  -- },
}
