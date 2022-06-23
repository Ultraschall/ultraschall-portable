dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then return end

reaper.DeleteProjectMarkerByIndex(0, marker_id)
