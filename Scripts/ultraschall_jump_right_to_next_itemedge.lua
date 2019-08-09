--[[
################################################################################
# 
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
--]]

-- move cursor right to previous edge.
-- You can set the pre-roll-offset in the ultraschall.ini -> [Ultraschall_Jump_To_ItemEdge] -> PrerollTime_Right
-- default is 1 second before the previous splitedge
-- 
-- only negative-values allowed!

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
preroll = ultraschall.GetUSExternalState("Ultraschall_Jump_To_ItemEdge", "PrerollTime_Right")
lastposition=reaper.GetExtState("ultraschall", "nextitemedge_lastposition")
if lastposition=="" then lastposition=-200 end

if preroll=="" then preroll=0 end

trackstring=ultraschall.CreateTrackString_SelectedTracks()

function ultraschall.IsWithinTimeRange(time, start, stop)
  time=ultraschall.LimitFractionOfFloat(tonumber(time),5,true)
  start=ultraschall.LimitFractionOfFloat(tonumber(start),5,true)
  stop=ultraschall.LimitFractionOfFloat(tonumber(stop),5,true)
  if time>=start and time<=stop then return true else return false end
end

if trackstring=="" then trackstring=ultraschall.CreateTrackString(1, reaper.CountTracks(), 1) end -- get a string with the existing number of tracks

if reaper.GetPlayState()~=0 then
  -- during play and recording, set Play and Editcursor to previous closest item or marker
  if ultraschall.IsWithinTimeRange(reaper.GetPlayPosition(), lastposition+preroll, lastposition) then 
    position=lastposition
  else 
    position=reaper.GetPlayPosition()
  end

  elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, position+0.001, true, false, false)
  ultraschall.SetPlayAndEditCursor_WhenPlaying(elementposition_next+preroll)
  reaper.SetExtState("ultraschall", "nextitemedge_lastposition", elementposition_next, false)
else
  -- during stop, set Editcursor to previous closest item or marker
  if ultraschall.IsWithinTimeRange(reaper.GetCursorPosition(), lastposition+preroll, lastposition) then 
    position=lastposition
  else 
    position=reaper.GetCursorPosition()
  end
  elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, position+0.001, true, false, false)

  reaper.SetEditCurPos(elementposition_next+preroll, true, true)
  reaper.SetExtState("ultraschall", "nextitemedge_lastposition", elementposition_next, false)
end

