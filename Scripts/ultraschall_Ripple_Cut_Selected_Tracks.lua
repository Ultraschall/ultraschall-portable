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

-- ripple-cuts away all items in all selected tracks within time-selection and puts the cut-items into the clipboard

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

startloop, endloop = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if startloop==0 and startloop==endloop then reaper.MB("No time-selection active", "No time-selection", 0) return end

trackstring = ultraschall.CreateTrackString_SelectedTracks()
if trackstring=="" then reaper.MB("No tracks selected", "No track-selection", 0) return end

reaper.Undo_BeginBlock()
ultraschall.RippleCut(startloop, endloop, trackstring, true, true, false)
reaper.Undo_EndBlock("Ripple cut in selected tracks, markers stay at their position", -1)
