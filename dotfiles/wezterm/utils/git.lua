-- Git helper functions for tab bar
-- Provides branch name and dirty status with caching

local M = {}

-- Cache for git information (to avoid running git commands too frequently)
local git_cache = {}
local cache_duration = 3 -- seconds

-- Get current time in seconds
local function get_current_time()
  return os.time()
end

-- Execute a shell command and return output
local function execute_command(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

-- Get git branch name for a directory
function M.get_git_branch(cwd)
  if not cwd or cwd == "" then
    return nil
  end

  -- Check cache first
  local cache_key = "branch_" .. cwd
  local cached = git_cache[cache_key]
  local current_time = get_current_time()

  if cached and (current_time - cached.time) < cache_duration then
    return cached.value
  end

  -- Get branch name from git
  local cmd = string.format(
    'cd "%s" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null',
    cwd
  )
  local result = execute_command(cmd)

  if not result or result == "" then
    git_cache[cache_key] = { value = nil, time = current_time }
    return nil
  end

  -- Trim whitespace
  local branch = result:gsub("%s+", "")

  -- Cache the result
  git_cache[cache_key] = { value = branch, time = current_time }

  return branch
end

-- Check if git repository has uncommitted changes
function M.is_git_dirty(cwd)
  if not cwd or cwd == "" then
    return false
  end

  -- Check cache first
  local cache_key = "dirty_" .. cwd
  local cached = git_cache[cache_key]
  local current_time = get_current_time()

  if cached and (current_time - cached.time) < cache_duration then
    return cached.value
  end

  -- Check git status
  local cmd = string.format(
    'cd "%s" 2>/dev/null && git status --porcelain 2>/dev/null',
    cwd
  )
  local result = execute_command(cmd)

  local is_dirty = result and result ~= ""

  -- Cache the result
  git_cache[cache_key] = { value = is_dirty, time = current_time }

  return is_dirty
end

-- Get git information for a tab (branch + dirty status)
function M.get_git_info(tab)
  local cwd = tab.active_pane.current_working_dir

  if not cwd then
    return nil
  end

  -- Extract path from URL format
  local path = cwd
  if type(cwd) == "userdata" then
    path = cwd.file_path or ""
  elseif type(cwd) == "string" then
    path = cwd:gsub("^file://[^/]*/", "/")
  end

  local branch = M.get_git_branch(path)

  if not branch then
    return nil
  end

  local is_dirty = M.is_git_dirty(path)

  return {
    branch = branch,
    dirty = is_dirty,
  }
end

-- Format git info for display
function M.format_git_info(git_info)
  if not git_info then
    return ""
  end

  local branch_icon = ""
  local dirty_indicator = git_info.dirty and "*" or ""

  return string.format(" %s %s%s", branch_icon, git_info.branch, dirty_indicator)
end

return M
