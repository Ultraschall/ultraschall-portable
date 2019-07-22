dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--reaper.MB(ultraschall.Api_Path,"",0)

A=ultraschall.OpenURL("file://"..ultraschall.Api_Path .."Documentation/Reaper_Config_Variables.html")
