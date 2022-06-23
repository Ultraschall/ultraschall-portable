--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
################################################################################
]]

-------------------------------------
-- Ultraschall Helper Functions
-------------------------------------

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-------------------------------------
-- Functions
-------------------------------------

function GetAllSelectedItems(selected_items_count)
  selectedItems = {}
  for i = 0, selected_items_count-1  do
    item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
    table.insert(selectedItems, item)
    -- print(i.."-"..tostring(item))
  end
  return selectedItems
end

-------------------------------------
-- End of Functions
-------------------------------------

playstate=reaper.GetPlayState()
if playstate&4==4 then return end -- quit if recording

-------------------------------------
reaper.Undo_BeginBlock() -- Beginning of the undo block. Leave it at the top of your main function.
-------------------------------------


init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)  -- get information wether or not a 

if (init_end_timesel ~= init_start_timesel) then    -- there is a time selection

  
  cut1 = reaper.NamedCommandLookup("_Ultraschall_Split_Items_Timeselection") -- Start preview 
  reaper.Main_OnCommand(cut1, 0)
  
  cut1 = reaper.NamedCommandLookup("_Ultraschall_Remove_Items_Tracks_Envelopepoints_Depending_On_Focus") -- Start preview 
  reaper.Main_OnCommand(cut1, 0)
  

else
  Length=reaper.GetProjectLength()
  reaper.Main_OnCommand(40697, 0) -- normal delete

  Length2=reaper.GetProjectLength()

  Diff=Length2-Length

  if Diff~=0 and reaper.GetPlayState()~=0 and reaper.GetCursorContext()==1 and reaper.GetToggleCommandState(40311)==1 then
    reaper.SetEditCurPos(reaper.GetPlayPosition()+Diff, false, true)
  end
end


--[[

selected_items_count = reaper.CountSelectedMediaItems(0)

if selected_items_count > 0 then  -- at least one item selected

  selectedItems = GetAllSelectedItems(selected_items_count) -- baue ein Array mit allen selektierten Items. Da nach einem Ripple-Cut die Selektionen alle weg sind, kommt man so auch an die nachfolgenden Items ran.

  for i = 1, #selectedItems do   -- INITIALIZE loop through selected items
    item = selectedItems[i] -- Get selected item i
    track = reaper.GetMediaItemInfo_Value(item, "P_TRACK")

    reaper.DeleteTrackMediaItem(track, item)
    -- ultraschall.DeleteMediaItem(item)

  end -- ENDLOOP through selected items

else                           -- no items selected
   result = reaper.ShowMessageBox( "You need to select at least one item to ripple-cut.", "Ultraschall Ripple Cut", 0 )  -- Info window
end

]]

reaper.UpdateArrange()

-------------------------------------
reaper.Undo_EndBlock("Ultraschall Delete", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
