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
-- You can set the pre-roll-offset in the ultraschall.ini -> [Ultraschall_Jump_To_ItemEdge] -> PrerollTime_Left
-- default is one second before the previous splitedge; only negative values allowed
--
-- if playstate==stopped or stopped, the editcursor is at a splitposition and preroll~=0 then it jumps only left by the amount 
-- of the preroll-length

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.IsSplitAtPosition(trackstring, position)
  -- helper function which determines, whether there's a split at a certain position
  if type(trackstring)~="string" then ultraschall.AddErrorMessage("IsSplitAtPosition", "trackstring", "must be a valid trackstring", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("IsSplitAtPosition", "number", "must be a number", -2) return false end
  local valid, count, individual_tracknumbers = ultraschall.IsValidTrackString(trackstring)
  
  if valid==false then ultraschall.AddErrorMessage("IsSplitAtPosition", "trackstring", "no valid trackstring", -3) return false end
  local count2, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(position-1, position+1, trackstring, false)
  position=ultraschall.LimitFractionOfFloat(position, 9, true)
  for i=1, count2 do
    local pos=ultraschall.LimitFractionOfFloat(reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION"), 9, true)
    local len=ultraschall.LimitFractionOfFloat(reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH"), 9, true)
    if pos==position then return true end
  end
  return false
end

-- get current settings and selected tracks
preroll = ultraschall.GetUSExternalState("Ultraschall_Jump_To_ItemEdge", "PrerollTime_Left")
if preroll=="" then preroll=-1 end

trackstring= ultraschall.CreateTrackString_SelectedTracks()
if trackstring=="" then trackstring=ultraschall.CreateTrackString(1, reaper.CountTracks(), 1) end -- get a string with the existing number of tracks

if reaper.GetPlayState()~=0 then
  if reaper.GetPlayState()&2==2 and ultraschall.IsSplitAtPosition(trackstring, reaper.GetCursorPosition())==true and preroll~=0 then
    -- if paused and current editcursor-position is already at a split-position/mediaitemedge, within the selected tracks, 
    -- just jump backwards by the amount of pre-roll
    reaper.SetEditCurPos(reaper.GetCursorPosition()+preroll, true, true)
  else  
    -- during play and recording, set Play and Editcursor to previous closest item or marker
    elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, reaper.GetPlayPosition()-1, true, false, false)
    ultraschall.SetPlayAndEditCursor_WhenPlaying(elementposition_prev+preroll)
  end
else
  -- during stop, set Editcursor to previous closest item or marker
  if ultraschall.IsSplitAtPosition(trackstring, reaper.GetCursorPosition())==true and preroll~=0 then
    -- if current editcursor-position is already at a split-position/mediaitemedge, within the selected tracks, 
    -- just jump backwards by the amount of pre-roll
    reaper.SetEditCurPos(reaper.GetCursorPosition()+preroll, true, true)
  else  
    elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next = ultraschall.GetClosestGoToPoints(trackstring, reaper.GetCursorPosition()-0.001, true, false, false)
    reaper.SetEditCurPos(elementposition_prev+preroll, true, true)
  end
end

