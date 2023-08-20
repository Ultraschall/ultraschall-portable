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

-- ducking of all Ultraschall - Soundboard-tracks by influencing the volume-slider

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

VolumeChange    = 15  -- The maximum volume-reduction of the ducking in dB; default-Value is 10dB-toggle
Number_of_steps = 18  -- The duration of the "fadeout/fadein" of the ducking; 1 second==30 steps; default 0.66 seconds

-- this calculates the stepsize of the volume-alteration within each defer-cycle
Stepsize=VolumeChange/Number_of_steps

-- get current toggle-state
retval, state=reaper.GetProjExtState(0, "Ultraschall_Soundboard", "Ducking_Toggle_State")
retval, state2=reaper.GetProjExtState(0, "Ultraschall_Soundboard", "Ducking_running")
if state2~="" then return end
reaper.SetProjExtState(0, "Ultraschall_Soundboard", "Ducking_running", "Hui")

state=tonumber(state)

if state==1 then
  -- if current toggle-state is set to "toggled", we need to make Stepsize negative, which
  -- will make the fader upwards(and louder) again
  Stepsize=-Stepsize
end

function main()
  -- alter volume of each Soundboard-track by a certain Stepsize in each defer-cycle for smoother transition
  for i=0, reaper.CountTracks(0)-1 do
    if ultraschall.IsTrackSoundboard(i+1)==true then
      tr = reaper.GetTrack(0, i)
      found=true
      ok, vol, pan = reaper.GetTrackUIVolPan(tr, 0, 0)
      DBVol=ultraschall.MKVOL2DB(vol)-Stepsize
      vol=ultraschall.DB2MKVOL(DBVol)
      reaper.SetMediaTrackInfo_Value(tr, "D_VOL", vol)
    end
  end

  -- here, we count the number of steps to alter the volume
  -- if Counter isn't 0 yet, keep on altering, otherwise set current toggle-state, if needed
  if Counter>0 then 
    Counter=Counter-1 
    reaper.defer(main) 
  else
    reaper.SetProjExtState(0, "Ultraschall_Soundboard", "Ducking_running", "")
    if found==true then
      -- if we've found a Soundboard-track, alter toggle-state
      if state==1 then
        reaper.SetProjExtState(0, "Ultraschall_Soundboard", "Ducking_Toggle_State", 0)
      else
        reaper.SetProjExtState(0, "Ultraschall_Soundboard", "Ducking_Toggle_State", 1)
      end
    else
      -- if we've found no such Soundboard-track, always set toggle-state to 0
      -- so accidental toggling doesn't lead to problems with newly added Soundboard-tracks.
      -- So you can run this action as often as you like, as soon as you add one Soundboard-track
      -- toggling will toggle properly downward, then upward, etc
      reaper.SetProjExtState(0, "Ultraschall_Soundboard", "Ducking_Toggle_State", 0)
    end
  end
end

-- initialization of some needed variables
found=false
Counter=Number_of_steps

-- let's do the volume alteration
main()
