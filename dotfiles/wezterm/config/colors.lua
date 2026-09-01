-- Theme loader for WezTerm
-- Delegates to theme file in themes/ directory

local matt_theme = require("config.themes.tokyonight")

local M = {}

M.theme = matt_theme

function M.apply_to_config(config)
  -- Load VS Code Dark+ theme
  config = matt_theme.apply_to_config(config)

  return config
end

return M
