local vars = {
  description = "Scythe library v3 (developer tools)",
  filename = "Lokasenna_Scythe library v3 (developer tools)",
  folder = "development",
  about = [[
Examples and utilities for developing scripts with Scythe v3.

This package requires "Scythe library v3" to be installed as well.]],
}

local path = debug.getinfo(1, "S").source:match("@(.*/)[^/]+$")
local file, err = loadfile(path .. "generate-metapackage.lua")
if err then
  reaper.ShowConsoleMsg(err)
  return
end

file()(vars)
