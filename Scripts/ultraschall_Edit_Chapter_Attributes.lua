dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

ultraschall.StoreTemporaryMarker(1)
--SLEM()
-- get chapter-marker-id and remove the temporary marker

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then return end

index = ultraschall.GetNormalMarkerIDFromGuid(guid)
if index==-1 then
  index = ultraschall.GetCustomMarkerIDFromGuid("Planned", guid)
end
--index=1
--[[
AAA=ultraschall.CountNormalMarkers()
retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(0)
retnumber2, shown_number2, pos, name2, guid2 = ultraschall.EnumerateNormalMarkers(1)
retnumber3, shown_number3, pos, name3, guid3 = ultraschall.EnumerateNormalMarkers(2)
retnumber4, shown_number4, pos, name4, guid4 = ultraschall.EnumerateNormalMarkers(3)
retnumber5, shown_number5, pos, name5, guid5 = ultraschall.EnumerateNormalMarkers(4)
if lol==nil then return end
--]]
--[[           ]]
--[[ Dialog 1: ]]
--[[           ]]

--print2(1)
retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(index)
--retval, marker_index, pos, name, shown_number, guid = 
retval, chap_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_description", "")
retval, chap_descriptive_tags = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_descriptive_tags", "")
retval, chap_is_advertisement = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_is_advertisement", "")
retval, chap_content_notification_tags = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_content_notification_tags", "")
retval, chap_spoiler_alert = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_spoiler_alert", "")
retval, chap_url = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_url", "")
retval, chap_url_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_url_description", "")

--print2(2)
retval, retvals_csv = reaper.GetUserInputs("Chapter-Attributes", 8, "Name,Description,Description Tags,Is Advertisement(empty if not),Content Notification Tags,Spoiler Alert(yes or leave empty),URL,URL-Description,separator=\b,extrawidth=240", 
name.."\b"..chap_description.."\b"..chap_descriptive_tags.."\b"..chap_is_advertisement.."\b"..chap_content_notification_tags.."\b"..chap_spoiler_alert.."\b"..chap_url.."\b"..chap_url_description)
if retval==false then return end
count, entries = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

--print2(3)
ultraschall.SetNormalMarker(index, pos, shown_number, entries[1])
retval, chap_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_description", entries[2])
retval, chap_descriptive_tags = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_descriptive_tags", entries[3])
retval, chap_is_advertisement = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_is_advertisement", entries[4])
retval, chap_content_notification_tags = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_content_notification_tags", entries[5])
retval, chap_spoiler_alert = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_spoiler_alert", entries[6])
retval, chap_url = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_url", entries[7])
retval, chap_url_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_url_description", entries[8])
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
