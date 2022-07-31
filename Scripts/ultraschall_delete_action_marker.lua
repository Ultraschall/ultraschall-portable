dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

reaper.DeleteProjectMarkerByIndex(0, marker_id)
