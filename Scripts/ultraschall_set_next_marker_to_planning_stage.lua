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
 
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

function is_first_position_marker_free()
  _, markers = ultraschall.GetAllPlannedMarkers()
  local counter=1
  while markers[counter]~=nil do
    local _, _, pos, _, _, _, _ = reaper.EnumProjectMarkers3(0, markers[counter]-1)
    if pos==0 then
      return false
    end
    counter=counter+1
  end
  return true
end

function set_next_marker_to_planning_stage()
  cursor_pos=reaper.GetCursorPosition()
  
  markrgnidx, _position, name=ultraschall.GetClosestNextNormalMarker(0)
  if markrgnidx~=-1 then
    reaper.Undo_BeginBlock()
    if is_first_position_marker_free()==false then  --make room for the marker (move all planed markers to the right by 0.001 seconds)
      _ ,markers = ultraschall.GetAllPlannedMarkers()
      ultraschall.MoveMarkers(markers, 0.001, true)
    end
    reaper.SetProjectMarkerByIndex(0, markrgnidx-1, false, 0.000, 0, 0, name, ultraschall.ConvertColor(100,255,0))        
  reaper.Undo_EndBlock("Ultraschall - Set next marker to planning stage.", -1)  
  end
end

set_next_marker_to_planning_stage()

