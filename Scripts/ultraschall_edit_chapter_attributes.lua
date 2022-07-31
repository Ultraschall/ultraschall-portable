dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get chapter-marker-id and remove the temporary marker
marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

index = ultraschall.GetNormalMarkerIDFromGuid(guid)
if index==-1 then
  index, markertype = ultraschall.GetCustomMarkerIDFromGuid(guid)
  if markertype~="Planned" then return else planned=true end
  index=index+1 -- needs to be added, so I don't need to add 1 to all GetSetChapterMarker_Attributes-functions when dealing with planned markers
end

if planned==nil then 
  retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(index) 
else
  retval, marker_index, pos, name, shown_number, color, guid = ultraschall.EnumerateCustomMarkers("Planned", index-1)
end

retval, chap_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_description", "", planned)
retval, chap_descriptive_tags = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_descriptive_tags", "", planned)
retval, chap_is_advertisement = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_is_advertisement", "", planned)
retval, chap_content_notification_tags = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_content_notification_tags", "", planned)
retval, chap_spoiler_alert = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_spoiler_alert", "", planned)
retval, chap_url = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_url", "", planned)
retval, chap_url_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_url_description", "", planned)

--print2(2)
retval, retvals_csv = reaper.GetUserInputs("Chapter-Attributes", 8, "Name,Description,Description Tags,Is Advertisement(empty if not),Content Notification Tags,Spoiler Alert(yes or leave empty),URL,URL-Description,separator=\b,extrawidth=240", 
name.."\b"..chap_description.."\b"..chap_descriptive_tags.."\b"..chap_is_advertisement.."\b"..chap_content_notification_tags.."\b"..chap_spoiler_alert.."\b"..chap_url.."\b"..chap_url_description)
if retval==false then return end
count, entries = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

--print2(3)
if planned==nil then 
  ultraschall.SetNormalMarker(index, pos, shown_number, entries[1])
else
  ultraschall.SetCustomMarker("Planned", index-1, pos, entries[1], shown_number, color)
end
retval, chap_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_description", entries[2], planned)
retval, chap_descriptive_tags = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_descriptive_tags", entries[3], planned)
retval, chap_is_advertisement = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_is_advertisement", entries[4], planned)
retval, chap_content_notification_tags = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_content_notification_tags", entries[5], planned)
retval, chap_spoiler_alert = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_spoiler_alert", entries[6], planned)
retval, chap_url = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_url", entries[7], planned)
retval, chap_url_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_url_description", entries[8], planned)
--print2(4)

--[[
Next/Previous Chapter

Process them in a different script:

retval, chap_next_chapter_numbers = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_next_chapter_numbers", "")
retval, chap_previous_chapter_numbers = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_previous_chapter_numbers", "")

retval, chap_next_chapter_numbers = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_next_chapter_numbers", entries[7])
retval, chap_previous_chapter_numbers = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_previous_chapter_numbers", entries[8])
]]

--[[

Images, process them in a different script:

retval, chap_image = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image", "")
retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_description", "")
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_license", "")
retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_origin", "")
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_url", "")

retval, chap_image = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image", entries[9])
retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_description", entries[10])
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_license", entries[11])
retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_origin", entries[12])
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_license", entries[13])
--]]
