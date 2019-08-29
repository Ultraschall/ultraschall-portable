dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

filecount, files = ultraschall.GetAllFilenamesInPath(ultraschall.Api_Path.."/Scripts/Tools")

for i=1, filecount do
  reaper.AddRemoveReaScript(true, 0, files[i], true)
end
