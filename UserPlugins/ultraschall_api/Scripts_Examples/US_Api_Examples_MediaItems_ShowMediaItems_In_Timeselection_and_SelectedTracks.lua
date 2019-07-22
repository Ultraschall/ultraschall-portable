-- Ultraschall-API demoscript by Meo Mespotine 30.11.2018
-- 
-- shows the MediaItems within time-selection and within selected tracks
-- also shows the number of found items
-- if no time-selection exists, it will display the found items at editcursorposition in selected tracks


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function main()
  -- get selected tracks and time-selection(loop)
  selected_trackstring = ultraschall.CreateTrackString_SelectedTracks()
  loopstart, loopend = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  if loopstart==0 and loopend==0 then loopstart=reaper.GetCursorPosition() loopend=reaper.GetCursorPosition() end
  
  -- get the MediaItems within selected tracks and time-selection
  count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(loopstart, loopend, selected_trackstring, false)
  
  -- if the selection has changed, show the currently found items in the ReaConsole-window
  if oldcount~=count or oldloopstart~=loopstart or oldloopend~=loopend or oldselected_trackstring~=selected_trackstring then
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("Found Items: "..count.."\n\nList of Items:\n")
    for i=1, count do
      reaper.ShowConsoleMsg(tostring(MediaItemArray[i]).."\n")
    end
  end
  
  -- keep the old values to check next defer-cycle, whether anything has changed
  oldcount=count
  oldloopstart=loopstart
  oldloopend=loopend
  oldselected_trackstring=selected_trackstring
  
  -- start the next defer-cycle
  reaper.defer(main)
end

main()