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
planned_color = ultraschall.ConvertColor(100,255,0)

function get_position()
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if playstate & 1 == 1 or playstate & 4==4 then
        return reaper.GetPlayPosition()
    else
        return reaper.GetCursorPosition()
    end
end

function set_next_marker_to_planning_stage()
  cursor_pos=get_position()
  -- iterate over list of all markerz
  retval, num_markers, num_regions = reaper.CountProjectMarkers(0) -- get number of all markers
  
  if num_markers>0 then
    retval, isrgn, last_pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, 0) -- get first marker
    if last_pos>=cursor_pos then last_marker_index=0 else last_marker_index=-1 end
    
    for i=1,num_markers-1 do --loop through all markers and find the next marker relative to cursor position
      retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
      if ((pos >= cursor_pos) and (last_marker_index>-1) and (pos<last_pos)) or ((pos >= cursor_pos) and (last_marker_index==-1)) then
        last_pos=pos
        last_marker_index=i
      end
    end
    
    if last_marker_index>-1 then
      reaper.Undo_BeginBlock()
        retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, last_marker_index)
        reaper.SetProjectMarker4(0, markrgnindexnumber, false, pos, 0, name, planned_color|0x1000000, 0)        
      reaper.Undo_EndBlock("Ultraschall - Set next marker to planning stage)", -1)  
    end
  end
end

set_next_marker_to_planning_stage()
