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

-- move cursor left to previous edge.
-- You can set the pre-roll-offset in the ultraschall.ini -> [Ultraschall_Jump_To_ItemEdge] -> PrerollTime_left
-- default is one second before the previous splitedge

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
preroll = ultraschall.GetUSExternalState("Ultraschall_Jump_To_ItemEdge", "PrerollTime_left")
if preroll=="" then preroll=-1 end

trackstring= ultraschall.CreateTrackString_SelectedTracks() 

if trackstring=="" then trackstring=ultraschall.CreateTrackString(1, reaper.CountTracks(), 1) end -- get a string with the existing number of tracks

if reaper.GetPlayState()~=0 then
  -- during play and recording, set Play and Editcursor to previous closest item or marker
  elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, reaper.GetPlayPosition()-1, true, false, false)
  ultraschall.SetPlayAndEditCursor_WhenPlaying(elementposition_prev+preroll)
else
  -- during stop, set Editcursor to previous closest item or marker
  elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, reaper.GetCursorPosition()-0.001, true, false, false)
  reaper.SetEditCurPos(elementposition_prev, true, true)
end
