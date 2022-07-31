dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--ultraschall.StoreTemporaryMarker(0)
-- get shownote-marker-id and remove the temporary marker

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

index = ultraschall.GetShownoteMarkerIDFromGuid(guid)

retval, ICS_Data = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_ics_data", "")

print_update(ICS_Data)
