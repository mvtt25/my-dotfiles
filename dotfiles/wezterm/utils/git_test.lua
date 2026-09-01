-- Self-check for the branch reader: lua utils/git_test.lua
package.path = "./?.lua;" .. package.path

local git = require("utils.git")

-- ── parse_head ─────────────────────────────────────────────────────────────
assert(git.parse_head("ref: refs/heads/main\n") == "main")
assert(git.parse_head("ref: refs/heads/feat/auth-flow\n") == "feat/auth-flow")
assert(git.parse_head("9f2c1ab7d4e5f6a7b8c9\n") == "9f2c1ab", "detached HEAD -> short sha")
assert(git.parse_head("not a head") == nil)
assert(git.parse_head(nil) == nil)

-- ── git_dir / branch on real fixtures ──────────────────────────────────────
local root = os.getenv("TMPDIR") or "/tmp"
local repo = root .. "/wezterm-git-test"
os.execute("rm -rf " .. repo)
os.execute("mkdir -p " .. repo .. "/plain/.git " .. repo .. "/plain/deep/nested")
local head = io.open(repo .. "/plain/.git/HEAD", "w")
head:write("ref: refs/heads/feat/auth\n")
head:close()

assert(git.branch(repo .. "/plain") == "feat/auth")
assert(git.branch(repo .. "/plain/deep/nested") == "feat/auth", "must walk up to the repo root")
assert(git.branch(repo .. "/plain/") == "feat/auth", "trailing slash must not break the walk")

-- worktree / submodule: .git is a file pointing at the real gitdir
os.execute("mkdir -p " .. repo .. "/linked " .. repo .. "/real-gitdir")
local pointer = io.open(repo .. "/linked/.git", "w")
pointer:write("gitdir: " .. repo .. "/real-gitdir\n")
pointer:close()
local linked_head = io.open(repo .. "/real-gitdir/HEAD", "w")
linked_head:write("ref: refs/heads/release\n")
linked_head:close()

assert(git.branch(repo .. "/linked") == "release", "worktree pointer must be followed")

-- outside any repo
os.execute("mkdir -p " .. repo .. "-bare-dir")
assert(git.branch("") == nil)
assert(git.branch(nil) == nil)

os.execute("rm -rf " .. repo .. " " .. repo .. "-bare-dir")
print("git: ok")
