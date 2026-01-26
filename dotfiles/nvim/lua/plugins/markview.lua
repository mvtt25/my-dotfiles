return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended for performance
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Configuration options
      modes = { "n", "no", "c" }, -- Modes where markview is enabled
      hybrid_modes = { "n" }, -- Modes where both rendered and raw markdown are visible

      -- Callbacks for when markview is enabled/disabled
      callbacks = {
        on_enable = function(_, win)
          vim.wo[win].conceallevel = 2
          vim.wo[win].concealcursor = "c"
        end,
      },
    },
    config = function(_, opts)
      require("markview").setup(opts)
    end,
  },
}
