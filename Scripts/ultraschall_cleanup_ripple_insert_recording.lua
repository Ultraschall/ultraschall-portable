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

trackstring=ultraschall.CreateTrackString_AllTracks()
position=tonumber(reaper.GetExtState("Ultraschall_RippleInsertRecording", "position", 0))
if position==nil then return end 
stopposition=tonumber(reaper.GetExtState("Ultraschall_RippleInsertRecording", "stopposition", 0))
firststartposition=tonumber(reaper.GetExtState("Ultraschall_RippleInsertRecording", "firststartposition", 0))

reaper.Undo_BeginBlock()
marker_number = ultraschall.AddEditMarker(firststartposition, -1, "")
marker_number = ultraschall.AddEditMarker(stopposition, -1, "")
Aretval = ultraschall.MoveMediaItemsAfter_By(position, -(position-stopposition), trackstring)
retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, -(position-stopposition), false)
retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength()+1, -(position-stopposition), false)
for i=0, reaper.CountTracks(0)-1 do
  ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, -(position-stopposition), reaper.GetTrack(0,i), false)
end
reaper.Undo_EndBlock("Finish Ripple Insert Recording", -1)

reaper.SetExtState("Ultraschall_RippleInsertRecording", "position", "", false)
reaper.SetExtState("Ultraschall_RippleInsertRecording", "stopposition", "", false)
reaper.SetExtState("Ultraschall_RippleInsertRecording", "firststartposition", "", false)
