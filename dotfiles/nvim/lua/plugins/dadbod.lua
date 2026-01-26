return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
      { "<leader>dq", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB Connection" },
    },
    init = function()
      -- DB UI Settings
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      -- Save queries to history
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

      -- Auto-execute on save
      vim.g.db_ui_execute_on_save = 0

      -- Use treesitter for syntax highlighting
      vim.g.db_ui_use_treesitter = 1

      -- Default table display
      vim.g.db_ui_table_helpers = {
        mysql = {
          Count = "select count(*) from {table}",
          Explain = "EXPLAIN {last_query}",
        },
        postgresql = {
          Count = "select count(*) from {table}",
          Explain = "EXPLAIN ANALYZE {last_query}",
        },
        sqlite = {
          Count = "select count(*) from {table}",
        },
      }
    end,
    config = function()
      -- Setup autocomplete for SQL
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
      })
    end,
  },
}
