dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

marker_id, guid = ultraschall.GetTemporaryMarker()
if marker_id==-1 then return end

index = ultraschall.GetShownoteMarkerIDFromGuid(guid)
ultraschall.StoreTemporaryMarker(-1)

ultraschall.DeleteShownoteMarker(index)
