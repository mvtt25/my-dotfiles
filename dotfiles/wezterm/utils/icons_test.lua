-- Self-check for process glyph matching: lua utils/icons_test.lua
-- Stubs wezterm.nerdfonts so this runs outside WezTerm.
package.path = "./?.lua;" .. package.path
package.preload["wezterm"] = function()
  return setmetatable({}, {
    __index = function()
      return setmetatable({}, { __index = function(_, key) return "<" .. key .. ">" end })
    end,
  })
end

local icons = require("utils.icons")

assert(icons.for_process("/opt/homebrew/bin/claude") == "<md_robot_outline>", "full path must resolve")
assert(icons.for_process("claude-code") == "<md_robot_outline>", "prefix match")
assert(icons.for_process("NVIM") == "<custom_neovim>", "case insensitive")
assert(icons.for_process("lazygit") == "<cod_github>", "longest prefix wins over 'git'")
assert(icons.for_process("git") == "<dev_git>")
assert(icons.for_process("pnpm") == "<md_npm>")
assert(icons.for_process("some-unknown-thing") == icons.DEFAULT, "unknown -> default")
assert(icons.for_process("") == icons.DEFAULT)
assert(icons.for_process(nil) == icons.DEFAULT)

print("icons: ok")
