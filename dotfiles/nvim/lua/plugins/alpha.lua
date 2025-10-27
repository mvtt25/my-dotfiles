return {
  "goolord/alpha-nvim",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    -- ASCII logo
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

    -- Buttons (with LazyVim fallback check)
    local ok, LazyVim = pcall(require, "lazyvim.util")
    local pick = ok and LazyVim.pick
      or function()
        vim.notify("LazyVim picker not available", vim.log.levels.WARN)
      end

    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Search that damn stuff", "<cmd> lua LazyVim.pick()() <cr>"),
      dashboard.button("n", " " .. " New damn file", [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recently opened crap", [[<cmd> lua LazyVim.pick('oldfiles')() <cr>]]),
      dashboard.button("g", " " .. " Find that damn string", [[<cmd> lua LazyVim.pick('live_grep')() <cr>]]),
      dashboard.button("c", " " .. " Mess with your config again", "<cmd> lua LazyVim.pick.config_files()() <cr>"),
      dashboard.button(
        "s",
        " " .. " Resume the lost damn session",
        [[<cmd> lua require('persistence').load() <cr>]]
      ),
      dashboard.button("x", " " .. " Lazy's extra bullshit", "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy, just like you", "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit and screw it", "<cmd> qa <cr>"),
    }

    -- Highlight setup
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Layout balance
    dashboard.config.layout = {
      { type = "padding", val = 6 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    -- Color highlights
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ac82f5", bold = true })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#fab387", italic = true })
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f38ba8", bold = true })

    return dashboard
  end,

  config = function(_, dashboard)
    -- Close Lazy if open and reopen after Alpha loads
    if vim.o.filetype == "lazy" or vim.o.filetype == "lazy.nvim" then
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

    -- LazyVim startup stats in footer
    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins | " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
