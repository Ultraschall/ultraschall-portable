dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--ultraschall.StoreTemporaryMarker(0)
-- get shownote-marker-id and remove the temporary marker
marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then return end

index = ultraschall.GetShownoteMarkerIDFromGuid(guid)

retval, marker_index, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(index)
retval, shwn_description = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_description", "")
retval, shwn_descriptive_tags = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_descriptive_tags", "")
retval, shwn_url = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url", "")
retval, shwn_url_description = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_description", "")
retval, shwn_url_retrieval_date = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_date", "")
retval, shwn_url_retrieval_time = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_time", "")
retval, shwn_url_retrieval_timezone_utc = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_timezone_utc", "")
retval, shwn_url_archived_copy_of_original_url = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_archived_copy_of_original_url", "")

retval, retvals_csv = reaper.GetUserInputs("Shownote-Attributes", 9, "Name,Description,Description Tags,URL,URL description,URL retrieve date,URL retrieve time,URL retrieve timezone,URL archived link,separator=\b,extrawidth=240", name.."\b"..shwn_description.."\b"..shwn_descriptive_tags.."\b"..shwn_url.."\b"..shwn_url_description.."\b"..shwn_url_retrieval_date.."\b"..shwn_url_retrieval_time.."\b"..shwn_url_retrieval_timezone_utc.."\b"..shwn_url_archived_copy_of_original_url)
if retval==false then return end
count, entries = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

ultraschall.SetShownoteMarker(index, pos, entries[1])
retval, shwn_description = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_description", entries[2])
retval, shwn_descriptive_tags = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_descriptive_tags", entries[3])
retval, shwn_url = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url", entries[4])
retval, shwn_url_description = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url_description", entries[5])
retval, shwn_url_retrieval_date = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url_retrieval_date", entries[6])
retval, shwn_url_retrieval_time = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url_retrieval_time", entries[7])
retval, shwn_url_retrieval_timezone_utc = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url_retrieval_timezone_utc", entries[8])
retval, shwn_url_archived_copy_of_original_url = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_url_archived_copy_of_original_url", entries[9])


SFEM()
