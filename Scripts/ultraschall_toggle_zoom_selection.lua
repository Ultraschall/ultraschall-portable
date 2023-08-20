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
# s
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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-------------
-- Main
-------------

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

zoomfactor=reaper.GetHZoomLevel() -- get current zoom-level
vertical_zoom_factor = ultraschall.GetVerticalZoom()
selected_items_count = reaper.CountSelectedMediaItems(0)
init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)  -- get information wether or not a time selection is set

if (init_end_timesel ~= init_start_timesel) or selected_items_count > 0 then    -- there is a time selection or selected items
  ultraschall.SetUSExternalState("ultraschall_view","zoom_toggle_select",tostring(zoomfactor))
  ultraschall.SetUSExternalState("ultraschall_view","zoom_toggle_select_vertical",tostring(vertical_zoom_factor))
  reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_ZOOMSIT"), 0) -- Zoom to selection
  reaper.Main_OnCommand(reaper.NamedCommandLookup("_Ultraschall_Unselect_All"), 0) -- Zoom to selection
else
  oldzoomfactor=ultraschall.GetUSExternalState("ultraschall_view","zoom_toggle_select")
  if oldzoomfactor ~= "" then -- wurde je schon mal ein zoomfaktor über die Funktion gesetzt?
    reaper.adjustZoom(tonumber(oldzoomfactor), 1, true, 0)
    oldzoomfactorVertical=ultraschall.GetUSExternalState("ultraschall_view","zoom_toggle_select_vertical")
    ultraschall.SetVerticalZoom(tonumber(oldzoomfactorVertical))
    retval = ultraschall.ApplyActionToTrack("1,0", 40913) -- verschiebe den Arrangeview hoch zum ersten Track
  end
end


reaper.Undo_EndBlock("Ultraschall toggle zoom selection", -1) -- End of the undo block. Leave it at the bottom of your main function.
