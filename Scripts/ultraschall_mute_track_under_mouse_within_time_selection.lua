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
# s
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

-- Meo-Ada Mespotine - 8th of December 2023

-- sets tracks under mouse muted in the mute-envelope within the time-selection
-- shows the mute-envelope

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

start_sel, end_sel = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

reaper.Undo_BeginBlock()

track = reaper.GetTrackFromPoint(reaper.GetMousePosition())
ultraschall.ActivateMute_TrackObject(track, true)
ultraschall.ToggleMute_TrackObject(track, start_sel, 0)
ultraschall.ToggleMute_TrackObject(track, end_sel, 1)

reaper.Undo_EndBlock("Muting mute-envelope of track under mouse", -1)



