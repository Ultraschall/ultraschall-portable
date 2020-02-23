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
 
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

reaper.Undo_BeginBlock()

if reaper.GetPlayState() & 2 == 2 then -- if pause, use edit cursor position
  current_position = reaper.GetCursorPosition() 
else
  current_position = reaper.GetPlayPosition() -- Position of play-cursor
end

num_markers = reaper.CountProjectMarkers(0) -- number of markers + regions!
PlannedColor = ultraschall.ConvertColor(100,255,0) -- color of all planned markers

for i=0, num_markers-1 do
  retval, isrgnOut, posOut, rgnendOut, nameOut, markrgnindexnumberOut, colorOut = reaper.EnumProjectMarkers3(0, i)
  if isrgnOut==false and colorOut==PlannedColor then -- green and not a region
    reaper.DeleteProjectMarkerByIndex(0, markrgnindexnumberOut)
    reaper.AddProjectMarker2(0, false, current_position, 0, nameOut, markrgnindexnumberOut, 0)
    --reaper.SetProjectMarker4(0, markrgnindexnumberOut, false, current_position, 0, nameOut, 0, 0)
    break
  end
end

ultraschall.RenumerateMarkers(0, 1)

reaper.Undo_EndBlock("Ultraschall: Set next planned marker to Play-/Rec-Cursor.",0)