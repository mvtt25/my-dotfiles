return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      local window_view = require("blame.views.window_view")
      local virtual_view = require("blame.views.virtual_view")

      require("blame").setup({
        views = {
          window = window_view,
          virtual = virtual_view,
          default = virtual_view,
        },
        virtual_style = "right_align",
        date_format = "%Y-%m-%d",
      })
    end,
  },
}
