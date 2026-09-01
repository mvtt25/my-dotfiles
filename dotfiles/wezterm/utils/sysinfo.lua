-- System metrics for the tab bar (macOS)
--
-- Memory is a live reading: vm_stat counts pages as they are right now.
--
-- CPU is a rate, so it needs two samples. macOS exposes no host-level tick
-- counter to the shell (no kern.cp_time, that is FreeBSD), and `top -l 2`
-- measured 140-180ms per call against 10ms here, so the counter is the summed
-- cumulative CPU time of every live process: the delta over the window is real
-- utilisation over the last REFRESH seconds, not the decaying ~1 minute average
-- that `ps -o %cpu` reports.
--
-- Known ceiling: a process that exits inside the window takes its accumulated
-- time out of the sum, so the delta can go negative. We hold the previous
-- reading for one window rather than print a wrong 0.
-- ponytail: process-time delta; a helper binary calling host_statistics would
-- be exact and immune to exits, not worth it for a number in a status bar.

local M = {}

-- Also the averaging window for CPU: shorter reacts faster and costs more.
local REFRESH = 3 -- seconds between samples

-- ── Pure parsers (unit-tested in utils/sysinfo_test.lua) ────────────────────

-- `vm_stat` output -> used memory in GB (app + wired + compressed)
function M.parse_vm_stat(text)
  local page = tonumber(text:match("page size of (%d+) bytes"))
  local anon = tonumber(text:match("Anonymous pages:%s+(%d+)"))
  local purgeable = tonumber(text:match("Pages purgeable:%s+(%d+)"))
  local wired = tonumber(text:match("Pages wired down:%s+(%d+)"))
  local compressed = tonumber(text:match("Pages occupied by compressor:%s+(%d+)"))

  if not (page and anon and purgeable and wired and compressed) then
    return nil
  end

  local used_pages = (anon - purgeable) + wired + compressed
  return used_pages * page / (1024 * 1024 * 1024)
end

-- `ps -A -o time=` output -> CPU seconds consumed by all live processes.
-- macOS prints M:SS.ss (minutes grow past 99) and H:MM:SS.ss for the very old.
function M.parse_cputime(text)
  local total, seen = 0, false

  for line in text:gmatch("[^\n]+") do
    local h, m, sec = line:match("(%d+):(%d+):([%d%.]+)")
    if not h then
      m, sec = line:match("(%d+):([%d%.]+)")
      h = 0
    end

    if m and sec then
      total = total + h * 3600 + m * 60 + tonumber(sec)
      seen = true
    end
  end

  if not seen then
    return nil
  end
  return total
end

-- Two cumulative samples -> utilisation over the window, 0..100 across all
-- cores. nil when the window is unusable or a process exited (negative delta).
function M.cpu_from_delta(previous, current, elapsed, cores)
  if not previous or not current or not elapsed or elapsed <= 0 then
    return nil
  end
  if not cores or cores < 1 then
    return nil
  end

  local delta = current - previous
  if delta < 0 then
    return nil
  end

  return math.min(100, delta / elapsed / cores * 100)
end

-- ── Sampling ───────────────────────────────────────────────────────────────

local cache = { at = 0, cpu = nil, mem = nil, cpu_time = nil }
local hardware = nil

-- wezterm.run_child_process returns (success, stdout, stderr).
local function run(argv)
  local wezterm = require("wezterm")
  local called, success, stdout = pcall(wezterm.run_child_process, argv)
  if not called or not success or type(stdout) ~= "string" then
    return nil
  end
  return stdout
end

-- Core count and total RAM never change: read them once.
local function read_hardware()
  if hardware then
    return hardware
  end

  local cores = tonumber((run({ "sysctl", "-n", "hw.ncpu" }) or ""):match("%d+"))
  local memsize = tonumber((run({ "sysctl", "-n", "hw.memsize" }) or ""):match("%d+"))

  hardware = {
    cores = cores or 1,
    total_gb = memsize and memsize / (1024 * 1024 * 1024) or nil,
  }
  return hardware
end

-- Returns { cpu = 0..100 | nil, mem = gb | nil, total_gb = gb | nil }
-- Never raises: on any failure the previous sample is kept.
function M.sample()
  local now = os.time()
  local hw = read_hardware()

  if cache.at ~= 0 and now - cache.at < REFRESH then
    return { cpu = cache.cpu, mem = cache.mem, total_gb = hw.total_gb }
  end

  local elapsed = now - cache.at
  local previous_cpu_time = cache.cpu_time
  cache.at = now

  local ps = run({ "ps", "-A", "-o", "time=" })
  if ps then
    local cpu_time = M.parse_cputime(ps)
    if cpu_time then
      -- First sample only seeds the counter; a rate needs two.
      cache.cpu = M.cpu_from_delta(previous_cpu_time, cpu_time, elapsed, hw.cores) or cache.cpu
      cache.cpu_time = cpu_time
    end
  end

  local vm = run({ "vm_stat" })
  if vm then
    cache.mem = M.parse_vm_stat(vm) or cache.mem
  end

  return { cpu = cache.cpu, mem = cache.mem, total_gb = hw.total_gb }
end

return M
