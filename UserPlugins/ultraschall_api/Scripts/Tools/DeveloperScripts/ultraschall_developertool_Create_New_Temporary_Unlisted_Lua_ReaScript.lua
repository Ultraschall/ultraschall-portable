-- Version 1.0 written by Meo-Ada Mespotine - licensed under MIT-license
-- Creates new temporary Lua-script using filename Resourcefolder/Scripts/Ultraschall_TempScripts/temporary_[$date].lua
-- the script will NOT be added to the actionlist, but can be edited and run anyway.

ultraschall_override=true

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

date=string.gsub(os.date(), "[%s%.:]", "_")
path=reaper.GetResourcePath().."/Scripts/Ultraschall_TempScripts/"
reaper.RecursiveCreateDirectory(path, 0)
retval, retval2 = ultraschall.EditReaScript(path.."temporary_"..date..".lua", true)

SLEM()
