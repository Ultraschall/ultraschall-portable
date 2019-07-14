#move cursor left to next edge. If one or more items are selected move cursor to the start of most left item.
if reaper.CountSelectedMediaItems(0)==0 then
  reaper.Main_OnCommand(41167,0)
else
  reaper.Main_OnCommand(41173,0)
end
