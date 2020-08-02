--[[
################################################################################
# 
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

-- Meo-Ada Mespotine - 2nd of August 2020

-- set mutes of a trackenvelope to muted, regardless of its envelope-automation-mode
-- the trackname is taken from the filename of the script:
-- filenameXXX.lua
-- where XXX is the tracknumber you want to togglemute.
-- it must be three digits!

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

is_new_value, filename, sectionID, cmdID, mode, resolution, val=reaper.get_action_context()

track=tonumber(filename:match("(...)%.lua"))

MuteEnvelope = reaper.GetTrackEnvelopeByName(reaper.GetTrack(0, track-1), "Mute")


if track==nil then reaper.MB("You should write a three-digit tracknumber in the filename of the script before .lua, like: mute_track_001.lua", "Error", 0) return end

if reaper.GetPlayState()~=0 then
  position=reaper.GetPlayPosition()
else
  position=reaper.GetCursorPosition()
end

envIDX, envVal, envPosition = ultraschall.GetPreviousMuteState(track, position)

reaper.Undo_BeginBlock()
if envVal==0 then 
  ultraschall.ToggleMute(track, position, 1)
  undomsg="UnMuting mute-envelope of track "..track
else
  ultraschall.ToggleMute(track, position, 0)
  undomsg="Muting mute-envelope of track "..track
end
reaper.Undo_EndBlock(undomsg, -1)