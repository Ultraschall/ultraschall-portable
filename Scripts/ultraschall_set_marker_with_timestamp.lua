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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- A=ultraschall.GetUSExternalState("ultraschall_follow", "state")

commandid = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
buttonstate = reaper.GetToggleCommandStateEx(0, commandid)
if buttonstate <= 0 then buttonstate = 0 end

if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
  current_position = reaper.GetCursorPosition() -- Position of edit-cursor
else
    if buttonstate == 1 then -- follow mode is active
    current_position = reaper.GetPlayPosition() -- Position of play-cursor
--     elseif reaper.GetPlayState()~=0 then
--          current_position = reaper.GetPlayPosition() -- Position of play-cursor
  else
    current_position = reaper.GetCursorPosition() -- Position of edit-cursor
  end
end

markercount=ultraschall.CountNormalMarkers_NumGap()

runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible

function CreateDateTime(time)
  local D=os.date("*t",time)
  if D.day<10 then D.day="0"..D.day else D.day=tostring(D.day) end
  if D.month<10 then D.month="0"..D.month else D.month=tostring(D.month) end
  if D.hour<10 then D.hour="0"..D.hour else D.hour=tostring(D.hour) end
  if D.min<10 then D.min="0"..D.min else D.min=tostring(D.min) end
  if D.sec<10 then D.sec="0"..D.sec else D.sec=tostring(D.sec) end
  local Date=D.year.."-"..D.month.."-"..D.day
  local Time=D.hour..":"..D.min..":"..D.sec
  return Date.."T"..Time
end

L=CreateDateTime()
timestamp=os.date("%Y-%m-%d; %H:%M:%S")
--reaper.AddProjectMarker2(0, false, current_position, 0, "_Time: "..timestamp, markercount, 274877906943)
ultraschall.pause_follow_one_cycle()
Marker = reaper.AddProjectMarker2(0, false, current_position, 0,
"_Time: "..CreateDateTime(),
0, 274877906943)
