-- Ultraschall-API demoscript by Meo Mespotine 29.10.2018
-- 
-- Change length of MediaItems by a value, in selected Tracks and Time-Selection
-- MediaItems must be fully within the time-selection, at least in this demo, though you
-- can choose to use MediaItems only partially within time-selection as well
-- see functions-reference-docs for more details on GetAllMediaItemsBetween()

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

selection_start, selection_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, 0)
trackstring = ultraschall.CreateTrackString_SelectedTracks()
count, MediaItemArray = ultraschall.GetAllMediaItemsBetween(selection_start, selection_end, trackstring, true)

if count>0 then
  retval, deltalength = reaper.GetUserInputs("Alter by length(in seconds):", 1, "", "")
  if type(tonumber(deltalength))=="number" then
    retval = ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(MediaItemArray, tonumber(deltalength))
  else
    reaper.MB("Must be a number", "Number needed", 0)
  end
end
