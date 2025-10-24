-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      notify_formatters = true,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        -- Add languages as needed here
      },
    })
  end,
}
