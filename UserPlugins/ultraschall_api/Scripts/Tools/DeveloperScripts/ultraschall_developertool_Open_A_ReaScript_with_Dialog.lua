-- Version 1.0 written by Meo-Ada Mespotine - licensed under MIT-license
-- Lets you choose a script to load in the ReaScript-IDE, using a file-dialog.
-- the script will NOT be added to the actionlist, but can be edited and run anyway.

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end


filename=ultraschall.GetUSExternalState("REAPER", "lastscript", "reaper.ini")
if filename~="" and reaper.file_exists(filename)==false then filename=reaper.GetResourcePath().."/Scripts/"..filename end
if filename=="" then filename=reaper.GetResourcePath().."/Scripts/" end

retval, filename = reaper.GetUserFileNameForRead(filename, "Choose Script", "")
if retval==false then return end

retval, retval2 = ultraschall.EditReaScript(filename, true)

