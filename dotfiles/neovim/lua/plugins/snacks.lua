return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    explorer = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          show_empty = true,
          ignored = true,
          layout = {
            layout = {
              position = "right",
            },
            preview = true,
            width = 20,
          },
        },
      },
    },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
}
