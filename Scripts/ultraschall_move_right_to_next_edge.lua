#move cursor right to next edge. If one or more items are selected move cursor to the end start of right most item.
if reaper.CountSelectedMediaItems(0)==0 then
  reaper.Main_OnCommand(41168,0)
else
  reaper.Main_OnCommand(41174,0)
end
