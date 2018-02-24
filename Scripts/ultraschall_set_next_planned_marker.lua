--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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

-- little helpers

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")


reaper.Undo_BeginBlock()

a,A=ultraschall.GetUSExternalState("ultraschall_follow", "state")

function get_position()
  if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
	current_position = reaper.GetCursorPosition() -- Position of edit-cursor
  else
    if A~="0" then -- follow mode is active
		current_position = reaper.GetPlayPosition() -- Position of play-cursor
--    elseif reaper.GetPlayState()~=0 then
--          current_position = reaper.GetCursorPosition() -- Position of play-cursor
    else
		current_position = reaper.GetCursorPosition() -- Position of edit-cursor
    end
  end
  return current_position
end

play_pos=get_position()
num_markers=reaper.CountProjectMarkers(0) -- number of markers + regions!
PlannedColor = ultraschall.ConvertColor(100,255,0) -- color of all planned markers

for i=0, num_markers-1 do
  retval, isrgnOut, posOut, rgnendOut, nameOut, markrgnindexnumberOut, colorOut = reaper.EnumProjectMarkers3(0, i)
  if isrgnOut==false and colorOut==PlannedColor then -- green and not a region
    -- move to play_pos and change color to grey
    runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible
    
    reaper.SetProjectMarker4(0, markrgnindexnumberOut, false, play_pos, 0, nameOut, 0x666666|0x1000000, 0)
    break
  end
end

ultraschall.RenumerateMarkers(0x666666|0x1000000, 1)

reaper.Undo_EndBlock("Ultraschall: Set next planned marker.",0)
