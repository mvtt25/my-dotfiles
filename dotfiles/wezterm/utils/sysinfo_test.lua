-- Self-check for the sysinfo parsers: lua utils/sysinfo_test.lua
package.path = "./?.lua;" .. package.path

local sysinfo = require("utils.sysinfo")

local VM_STAT = [[
Mach Virtual Memory Statistics: (page size of 16384 bytes)
Pages free:                                     4630.
Pages active:                                  98734.
Pages inactive:                                97982.
Pages speculative:                               378.
Pages throttled:                                   0.
Pages wired down:                             104917.
Pages purgeable:                                   2.
"Translation faults":                       123456789.
Anonymous pages:                              150000.
Pages occupied by compressor:                  50000.
]]

-- (150000 - 2 + 104917 + 50000) = 304915 pages * 16384 B = 4.6526 GB
local used = sysinfo.parse_vm_stat(VM_STAT)
assert(used, "parse_vm_stat returned nil on valid input")
assert(math.abs(used - 4.6526) < 0.01, "unexpected used memory: " .. tostring(used))

assert(sysinfo.parse_vm_stat("garbage") == nil, "parse_vm_stat must be nil on junk")

-- ── parse_cputime: the format macOS `ps -A -o time=` actually prints ──────
local PS_TIME = [[
  0:00.00
  0:12.50
 30:28.71
103:01.48
]]
-- 12.50 + (30*60 + 28.71) + (103*60 + 1.48) = 8022.69
local cumulative = sysinfo.parse_cputime(PS_TIME)
assert(cumulative, "parse_cputime returned nil on valid input")
assert(math.abs(cumulative - 8022.69) < 0.01, "unexpected total: " .. tostring(cumulative))

assert(math.abs(sysinfo.parse_cputime(" 1:02:03.50\n") - 3723.5) < 0.01, "H:MM:SS form")
assert(sysinfo.parse_cputime("no digits here") == nil, "junk -> nil")

-- ── cpu_from_delta: a rate, not an average ───────────────────────────────
-- 24 CPU-seconds burned in 3s of wall time on 8 cores = 100%
assert(sysinfo.cpu_from_delta(100, 124, 3, 8) == 100, "saturation")
-- 1.2 CPU-seconds in 3s on 8 cores = 5%
assert(math.abs(sysinfo.cpu_from_delta(100, 101.2, 3, 8) - 5) < 0.001, "rate math wrong")
assert(sysinfo.cpu_from_delta(100, 200, 3, 8) == 100, "must clamp at 100")
assert(sysinfo.cpu_from_delta(100, 90, 3, 8) == nil, "a process exited -> nil, not a wrong 0")
assert(sysinfo.cpu_from_delta(nil, 100, 3, 8) == nil, "first sample only seeds")
assert(sysinfo.cpu_from_delta(100, 110, 0, 8) == nil, "no window -> nil")
assert(sysinfo.cpu_from_delta(100, 110, 3, 0) == nil, "no cores -> nil")

print("sysinfo: ok")
