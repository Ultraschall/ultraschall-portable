--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

selected_items_count = reaper.CountSelectedMediaItems(0)

if selected_items_count > 0 then  -- at least one item selected

  selectedItems = GetAllSelectedItems(selected_items_count) -- baue ein Array mit allen selektierten Items. Da nach einem Ripple-Cut die Selektionen alle weg sind, kommt man so auch an die nachfolgenden Items ran.

  for i = 1, #selectedItems do   -- INITIALIZE loop through selected items

    item = selectedItems[i] -- Get selected item i
    if reaper.ValidatePtr2(0, item, "MediaItem*") == true then  -- liefert false, wenn das item durch eine Überdeckung zu einem vorherigen schon zerschnitten wurde. Edge-Case der nochmal gefixt werden sollte.

      start_of_item_position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      end_of_item_position = start_of_item_position + length

      reaper.GetSet_LoopTimeRange(true, false, start_of_item_position, end_of_item_position, false) -- setzt die Zeitauswahl auf die Kanten des items
      CommandNumber = reaper.NamedCommandLookup("_Ultraschall_Ripple_Cut") -- der bekannte Ripple-Cut einer Zeitauswahl mit Sauce und scharf, Erhalt von Envelope-Points etc.
      reaper.Main_OnCommand(CommandNumber,0)

    end

  end -- ENDLOOP through selected items

else                           -- no items selected
   result = reaper.ShowMessageBox( "You need to select at least one item to ripple-cut.", "Ultraschall Ripple Cut", 0 )  -- Info window
end

-------------------------------------
reaper.Undo_EndBlock("Ultraschall Ripple Cut", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
