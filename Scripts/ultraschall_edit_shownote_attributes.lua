dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--ultraschall.StoreTemporaryMarker(0)
-- get shownote-marker-id and remove the temporary marker

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then return end

index = ultraschall.GetShownoteMarkerIDFromGuid(guid)

--[[           ]]
--[[ Dialog 1: ]]
--[[           ]]
retval, marker_index, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(index)
retval, shwn_description = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_description", "")
retval, shwn_descriptive_tags = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_descriptive_tags", "")
retval, shwn_url = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url", "")
retval, shwn_url_description = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_description", "")
retval, shwn_url_retrieval_date = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_date", "")
retval, shwn_url_retrieval_time = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_time", "")
retval, shwn_url_retrieval_timezone_utc = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_retrieval_timezone_utc", "")
retval, shwn_url_archived_copy_of_original_url = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_url_archived_copy_of_original_url", "")
retval, shwn_is_advertisement = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_is_advertisement", "")
retval, shwn_language = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_language", "")
retval, shwn_location_gps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_location_gps", "")
retval, shwn_location_google_maps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_location_google_maps", "")
retval, shwn_location_open_street_map = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_location_open_street_map", "")
retval, shwn_location_apple_maps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_location_apple_maps", "")

retval, retvals_csv = reaper.GetUserInputs("Shownote-Attributes", 15, "Name,Description,Description Tags,URL,URL description,URL retrieve date,URL retrieve time,URL retrieve timezone,URL archived link,Is Advertisement(empty if not),Language(ISO639),Location GPS,Location Google Maps,Location Open Street Map,Location Apple Maps,separator=\b,extrawidth=240", 
  name.."\b"..shwn_description.."\b"..shwn_descriptive_tags.."\b"..shwn_url.."\b"..shwn_url_description.."\b"..
  shwn_url_retrieval_date.."\b"..shwn_url_retrieval_time.."\b"..shwn_url_retrieval_timezone_utc.."\b"..
  shwn_url_archived_copy_of_original_url.."\b"..shwn_is_advertisement.."\b"..shwn_language.."\b"..shwn_location_gps.."\b"..
  shwn_location_google_maps.."\b"..shwn_location_open_street_map.."\b"..shwn_location_apple_maps)
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
retval, shwn_is_advertisement = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_is_advertisement", entries[10])
retval, shwn_language = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_language", entries[11])
retval, shwn_location_gps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_location_gps", entries[12])
retval, shwn_location_google_maps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_location_google_maps", entries[13])
retval, shwn_location_open_street_map = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_location_open_street_map", entries[14])
retval, shwn_location_apple_maps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_location_apple_maps", entries[15])

--[[           ]]
--[[ Dialog 2: ]]
--[[           ]]
retval, shwn_date = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_date", "")
retval, shwn_time = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_time", "")
retval, shwn_timezone = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_timezone", "")
retval, shwn_quote = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_quote", "")
retval, shwn_quote_cite_source = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_quote_cite_source", "")
retval, shwn_wikidata_uri = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_wikidata_uri", "")

retval, retvals_csv = reaper.GetUserInputs("Shownote-Attributes", 6, "Date of Shownote(yyyy-mm-dd),Time of Shownote(hh:mm:ss),TimeZone(in UTC),Quote,Cite quote(webcite, etc),WikiData-URI,separator=\b,extrawidth=240", 
  shwn_date.."\b"..shwn_time.."\b"..shwn_timezone.."\b"..shwn_quote.."\b"..shwn_quote_cite_source.."\b"..shwn_wikidata_uri)
if retval==false then return end
count, entries2 = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

retval, shwn_date = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_date", entries2[1])
retval, shwn_time = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_time", entries2[2])
retval, shwn_timezone = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_timezone", entries2[3])
retval, shwn_quote = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_quote", entries2[4])
retval, shwn_quote_cite_source = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_quote_cite_source", entries2[5])
retval, shwn_wikidata_uri = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_wikidata_uri", entries2[6])







--[[                  ]]
--[[ Dialog 3: Events ]]
--[[                  ]]
retval, shwn_event_name = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_name", "")
retval, shwn_event_description = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_description", "")
retval, shwn_event_url = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_url", "")
retval, shwn_event_date_start = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_date_start", "")
retval, shwn_event_date_end = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_date_end", "")
retval, shwn_event_time_start = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_time_start", "")
retval, shwn_event_time_end = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_time_end", "")
retval, shwn_event_timezone = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_timezone", "")
retval, shwn_event_location_gps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_location_gps", "")
retval, shwn_event_location_google_maps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_location_google_maps", "")
retval, shwn_event_location_open_street_map = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_location_open_street_map", "")
retval, shwn_event_location_apple_maps = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_location_apple_maps", "")
retval, shwn_event_ics_data = ultraschall.GetSetShownoteMarker_Attributes(false, index, "shwn_event_ics_data", "")

retval, retvals_csv = reaper.GetUserInputs("Shownote-Attributes", 12, 
"Event Name,Event Description,Event URL,Event Date Start(yyyy-mm-dd),Event Date End(yyyy-mm-dd),Event Time Start(hh:mm:ss),Event Time End(hh:mm:ss),Event Timezone(in UTC),Event Location(GPS),Event Location(Google Maps),Event Location(Open Street Map),Event Location(Apple Maps),separator=\b,extrawidth=240", 
  shwn_event_name.."\b"..shwn_event_description.."\b"..shwn_event_url.."\b"..shwn_event_date_start.."\b"..shwn_event_date_end.."\b"..shwn_event_time_start.."\b"..
  shwn_event_time_end.."\b"..shwn_event_timezone.."\b"..shwn_event_location_gps.."\b"..shwn_event_location_google_maps.."\b"..shwn_event_location_open_street_map.."\b"..
  shwn_event_location_apple_maps)
if retval==false then return end
count, entries2 = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

retval, shwn_event_name = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_name", entries2[1])
retval, shwn_event_description = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_description", entries2[2])
retval, shwn_event_url = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_url", entries2[3])
retval, shwn_event_date_start = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_date_start", entries2[4])
retval, shwn_event_date_end = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_date_end", entries2[5])
retval, shwn_event_time_start = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_time_start", entries2[6])
retval, shwn_event_time_end = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_time_end", entries2[7])
retval, shwn_event_timezone = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_timezone", entries2[8])
retval, shwn_event_location_gps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_location_gps", entries2[9])
retval, shwn_event_location_google_maps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_location_google_maps", entries2[10])
retval, shwn_event_location_open_street_map = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_location_open_street_map", entries2[11])
retval, shwn_event_location_apple_maps = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_location_apple_maps", entries2[12])

Retval=reaper.MB("Do you want to ads ICS-data to this shownote(its content will NOT be added automatically to the event attributes!)?", "Add ICS-Data", 4)
-- Yes=6
-- No=7
if Retval==6 then
  retval, filename = reaper.GetUserFileNameForRead("", "Select ICS-File", "*.ics")
  if retval==true then
    file=ultraschall.ReadFullFile(filename)
    -- To Do: Check, if file is valid ICS-file!!!
    retval, shwn_event_ics2 = ultraschall.GetSetShownoteMarker_Attributes(true, index, "shwn_event_ics_data", file)
  end
end
