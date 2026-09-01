-- Process glyphs for the tab bar.
--
-- Matched by prefix against the foreground process name, so "claude-code" and
-- "node-22" hit the same entries as "claude" and "node". Glyphs come from
-- Symbols Nerd Font Mono, which WezTerm bundles as a fallback.

local wezterm = require("wezterm")
local n = wezterm.nerdfonts

local M = {}

-- Longest prefix wins, so "lazygit" beats "git" regardless of table order.
local PROCESS = {
	claude = n.md_robot_outline,
	zsh = n.dev_terminal,
	bash = n.cod_terminal_bash,
	sh = n.dev_terminal,
	node = n.md_nodejs,
	pnpm = n.md_npm,
	npm = n.md_npm,
	yarn = n.seti_yarn,
	bun = n.md_hamburger,
	tsc = n.md_language_typescript,
	nvim = n.custom_neovim,
	vim = n.dev_vim,
	lazygit = n.cod_github,
	gh = n.cod_github,
	git = n.dev_git,
	docker = n.md_docker,
	psql = n.dev_postgresql,
	python = n.md_language_python,
	cargo = n.dev_rust,
	go = n.md_language_go,
	ssh = n.md_ssh,
	make = n.seti_makefile,
}

M.DEFAULT = n.dev_terminal

-- Glyph for a process path or name; M.DEFAULT when nothing matches.
function M.for_process(process)
	if type(process) ~= "string" or process == "" then
		return M.DEFAULT
	end

	local name = (process:match("([^/\\]+)[/\\]?$") or process):lower()

	local best, best_len = M.DEFAULT, 0
	for prefix, glyph in pairs(PROCESS) do
		if #prefix > best_len and name:sub(1, #prefix) == prefix then
			best, best_len = glyph, #prefix
		end
	end
	return best
end

return M
