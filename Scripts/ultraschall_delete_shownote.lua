dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

marker_id, guid = ultraschall.GetTemporaryMarker()
if marker_id~=-1 then ultraschall.StoreTemporaryMarker(-1) end

if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end
index = ultraschall.GetShownoteMarkerIDFromGuid(guid)


ultraschall.DeleteShownoteMarker(index)