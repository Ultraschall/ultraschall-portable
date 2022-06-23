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

-- little helpers


-- 2. Eine Aktion “set next planned Marker”
-- Sucht sich den Marker mit grünem Farbwert und kleinstem Zeitstempel,
-- und setzt ihn auf die aktuelle Aufnahmezeit/Editposition und stellt den
-- Farbwert auf das normale Grau.

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function get_position()
  if reaper.GetPlayState() & 2 == 2 then -- 2 = Pause
    current_position = reaper.GetCursorPosition() -- Position of edit-cursor
  else
    if buttonstate == 1 then -- follow mode is active
	 current_position = reaper.GetPlayPosition() -- Position of play-cursor
    else
	 current_position = reaper.GetCursorPosition() -- Position of edit-cursor
    end
  end
  return current_position
end



FirstPlannedMarker={ultraschall.EnumerateCustomMarkers("Planned", 0)}
if FirstPlannedMarker[1]~=false then
  commandid = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
  buttonstate = reaper.GetToggleCommandStateEx(0, commandid)
  if buttonstate <= 0 then buttonstate = 0 end
  play_pos = get_position()
  reaper.Undo_BeginBlock()

  runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible

  reaper.SetProjectMarkerByIndex(0, FirstPlannedMarker[2], false, play_pos, 0, 0, FirstPlannedMarker[4], reaper.ColorToNative(102,102,102)|0x1000000) 
  ultraschall.RenumerateNormalMarkers()

  reaper.Undo_EndBlock("Ultraschall: Set next planned marker.",0)
end



