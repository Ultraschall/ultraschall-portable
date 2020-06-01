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
]]

-- Inserts a new soundboard-track with a certain midi-channel as input
-- -1, no input at all, 0 for all midi-channels, 1 to 16 for midi-channel 1-16

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

MidiChannel=10

if MidiChannel>-1 then MidiChannel=MidiChannel+5088 end

trackstatechunk = ultraschall.ReadFullFile(reaper.GetResourcePath().."/TrackTemplates/Insert Ultraschall-Soundboard track.RTrackTemplate")

ArmState, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath = ultraschall.GetTrackRecState(-1, trackstatechunk)

retval, trackstatechunk= ultraschall.SetTrackRecState(-1, ArmState, MidiChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath, trackstatechunk)

retval, MediaTrack = ultraschall.InsertTrack_TrackStateChunk(trackstatechunk)