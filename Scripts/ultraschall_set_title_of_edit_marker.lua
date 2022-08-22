dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

A=ultraschall.GetTemporaryMarker()
marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

index = ultraschall.GetEditMarkerIDFromGuid(guid)
if index==-1 then return end

retnumber, shown_number, position, edittitle, guid = ultraschall.EnumerateEditMarkers(index)

retval, edittitle1 = reaper.GetUserInputs("Edit title of Edit Marker", 1, edittitle..",extrawidth=200,separator=\b", edittitle)

if retval==true and edittitle~=edittitle1 then
  retval = ultraschall.SetEditMarker(index, position, shown_number, edittitle1)
end
