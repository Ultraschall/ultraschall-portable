local vars = {
  description = "Scythe library v3",
  filename = "Lokasenna_Scythe library v3",
  folder = "library",
  about = [[
Provides a framework allowing Lua scripts to use a graphical interface, since
Reaper has no ability to do so natively, as well as standalone modules to
simplify many repetitive or difficult tasks.

SETUP: After installing this package, you _must_ tell Reaper where to find the
library. In the Action List, find and run:

"Script: Scythe_Set v3 library path.lua"]],
}

local path = debug.getinfo(1, "S").source:match("@(.*/)[^/]+$")
local file, err = loadfile(path .. "generate-metapackage.lua")
if err then
  reaper.ShowConsoleMsg(err)
  return
end

file()(vars)
