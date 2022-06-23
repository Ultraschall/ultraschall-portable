dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


commandid = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
buttonstate = reaper.GetToggleCommandStateEx(0, commandid)
if buttonstate <= 0 then buttonstate = 0 end

if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
  current_position = reaper.GetCursorPosition() -- Position of edit-cursor
else
    if buttonstate == 1 then -- follow mode is active
    current_position = reaper.GetPlayPosition() -- Position of play-cursor
  else
    current_position = reaper.GetCursorPosition() -- Position of edit-cursor
  end
end

markernumber, guid, shownotemarker_index = ultraschall.AddShownoteMarker(current_position, "")
retval = ultraschall.StoreTemporaryMarker(markernumber)

runcommand("_Ultraschall_Edit_Shownote_Attributes")

runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible

SLEM()
