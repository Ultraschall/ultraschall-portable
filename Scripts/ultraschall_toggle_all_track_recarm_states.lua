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



-----------------------------------
---- toggle recarm of all tracks ----
-----------------------------------


if reaper.GetPlayState()&4~=4 then
  RecArms=false
  
  for i=0, reaper.CountTracks()-1 do
    ArmState=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "I_RECARM")
    if ArmState~=0 then RecArms=true end
  end
  
  if RecArms==true then
    reaper.ClearAllRecArmed()
  else
    for i=0, reaper.CountTracks()-1 do
      reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,i), "I_RECARM", 1)
    end
  end
else
  reaper.MB("You must stop recording first, before toggling the arming state for all tracks!","Toggle recarm of all tracks",0)
end
