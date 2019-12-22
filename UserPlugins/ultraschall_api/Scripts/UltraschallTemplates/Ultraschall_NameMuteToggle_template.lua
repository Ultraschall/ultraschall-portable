--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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

Trackname=


-----------------------------------------------------------------------------------------------------------------
---- Toggle Mute on/off in the Mute-Envelope of Track with "Trackname" in their trackname at Cursor-Position ----
-----------------------------------------------------------------------------------------------------------------

for i=1,reaper.CountTracks() do
  trackname = ultraschall.GetTrackName(i)
  if trackname:lower()==Trackname:lower() then Tracknumber=i
    if reaper.GetPlayState()==0 then
      AenvIDX, AenvVal, AenvPosition = ultraschall.GetPreviousMuteState(Tracknumber, reaper.GetCursorPosition())
      if AenvIDX==-1 then return -1 end
      if AenvVal>0 then ultraschall.ToggleMute(Tracknumber, reaper.GetCursorPosition(), 0)
      else ultraschall.ToggleMute(Tracknumber, reaper.GetCursorPosition(), 1)
      end
    else
      AenvIDX, AenvVal, AenvPosition = ultraschall.GetPreviousMuteState(Tracknumber, reaper.GetPlayPosition())
      if AenvIDX==-1 then return -1 end
      if AenvVal>0 then ultraschall.ToggleMute(Tracknumber, reaper.GetPlayPosition(), 0)
      else ultraschall.ToggleMute(Tracknumber, reaper.GetPlayPosition(), 1)
      end
    end  
  end
end
