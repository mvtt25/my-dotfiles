return {
  "goolord/alpha-nvim",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
     ███▄ ▄███▓ ██▒   █▓▄▄▄█████▓▄▄▄█████▓
    ▓██▒▀█▀ ██▒▓██░   █▒▓  ██▒ ▓▒▓  ██▒ ▓▒
    ▓██    ▓██░ ▓██  █▒░▒ ▓██░ ▒░▒ ▓██░ ▒░
    ▒██    ▒██   ▒██ █░░░ ▓██▓ ░ ░ ▓██▓ ░ 
    ▒██▒   ░██▒   ▒▀█░    ▒██▒ ░   ▒██▒ ░ 
    ░ ▒░   ░  ░   ░ ▐░    ▒ ░░     ▒ ░░   
    ░  ░      ░   ░ ░░      ░        ░    
    ░      ░        ░░    ░        ░      
         ░         ░                    
                  ░                     
  ]]

    dashboard.section.header.val = vim.split(logo, "\n")
  -- stylua: ignore
  dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Search that damn stuff",       "<cmd> lua LazyVim.pick()() <cr>"),
    dashboard.button("n", " " .. " New damn file",        [[<cmd> ene <BAR> startinsert <cr>]]),
    dashboard.button("r", " " .. " Recently opened crap",    [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
    dashboard.button("g", " " .. " Find that damn string",       [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
    dashboard.button("c", " " .. " Mess with your config again",          "<cmd> lua LazyVim.pick.config_files()() <cr>"),
    dashboard.button("s", " " .. " Resume the lost damn session", [[<cmd> lua require("persistence").load() <cr>]]),
    dashboard.button("x", " " .. " Lazy's extra bullshit",     "<cmd> LazyExtras <cr>"),
    dashboard.button("l", "󰒲 " .. " Lazy, just like you",            "<cmd> Lazy <cr>"),
    dashboard.button("q", " " .. " Quit and screw it",            "<cmd> qa <cr>"),
  }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8

    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ac82f5", bold = true })

    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡" .. stats.loaded .. "/" .. stats.count .. " plugins | " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
