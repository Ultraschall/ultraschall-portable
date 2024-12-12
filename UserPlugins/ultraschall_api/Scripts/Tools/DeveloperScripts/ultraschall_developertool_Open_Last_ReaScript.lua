-- Version 1.0 written by Meo-Ada Mespotine - licensed under MIT-license
-- Opens the last script
-- the script will NOT be added to the actionlist, but can be edited and run anyway.

ultraschall_override=true

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

A=ultraschall.GetUSExternalState("REAPER", "lastscript", "reaper.ini")
if A=="" then print2("Can't open, as there was no previously edited script.") return end
retval, retval2 = ultraschall.EditReaScript(A, true)
