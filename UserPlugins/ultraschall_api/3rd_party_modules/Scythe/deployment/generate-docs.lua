local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

ScriptIdentifier=ultraschall.GetScriptIdentifier()
libPath=ultraschall.Api_Path.."/3rd_party_modules/Scythe/"

loadfile(libPath .. "scythe.lua")({ dev = true })

local rmLine = 'rm -rf "' .. Scythe.libRoot .. 'docs"'
os.execute(rmLine)

require("doc-parser.doc-parser")

local cpLine = "cp -r '" .. Scythe.libRoot .. "docs-src/.' '" .. Scythe.libRoot .. "docs'"
os.execute(cpLine)
