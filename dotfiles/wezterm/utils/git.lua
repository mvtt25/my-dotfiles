-- Git branch for the tab bar, read straight off the filesystem.
--
-- No `git` subprocess: the status bar redraws every second and shelling out
-- there would block the UI thread. Reading .git/HEAD is a few hundred bytes.
-- Trade-off: no dirty marker (*), that would need a real `git status`.

local M = {}

local MAX_WALK = 24 -- give up rather than climb to /

-- Reads the head of a file; nil for anything unreadable (incl. directories).
local function read_head(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local ok, data = pcall(file.read, file, 512)
  file:close()

  if not ok or type(data) ~= "string" or data == "" then
    return nil
  end
  return data
end

-- ".git/HEAD" contents -> branch name, or a short sha when detached.
function M.parse_head(text)
  if type(text) ~= "string" then
    return nil
  end

  local branch = text:match("ref:%s*refs/heads/(%S+)")
  if branch then
    return branch
  end

  local sha = text:match("^(%x%x%x%x%x%x%x)")
  return sha
end

-- Walks up from `dir` looking for a repository. ".git" is a directory in a
-- normal clone and a "gitdir:" pointer file in a worktree or submodule.
function M.git_dir(dir)
  if type(dir) ~= "string" or dir == "" then
    return nil
  end

  local current = dir:gsub("/+$", "")

  for _ = 1, MAX_WALK do
    if read_head(current .. "/.git/HEAD") then
      return current .. "/.git"
    end

    local pointer = read_head(current .. "/.git")
    local gitdir = pointer and pointer:match("gitdir:%s*(.-)%s*$")
    if gitdir then
      if not gitdir:match("^/") then
        gitdir = current .. "/" .. gitdir
      end
      return gitdir
    end

    local parent = current:match("^(.*)/[^/]+$")
    if not parent or parent == current then
      return nil
    end
    current = parent
  end

  return nil
end

-- Branch name for the repository containing `dir`, or nil outside a repo.
function M.branch(dir)
  local gitdir = M.git_dir(dir)
  if not gitdir then
    return nil
  end
  return M.parse_head(read_head(gitdir .. "/HEAD"))
end

return M
