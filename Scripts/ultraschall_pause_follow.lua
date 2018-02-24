--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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
-- signals the Auto-Followmode-Off-script to not check for follow-off edgecases
-- for one cycle (ultraschall_toggle_follow.lua)
-- will only have an effect, if follow-mode is turned on

  follow_actionnumber = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
  follow_on = reaper.NamedCommandLookup("_Ultraschall_Turn_On_Followmode")
  if reaper.GetToggleCommandState(follow_actionnumber)==1 then
    reaper.SetExtState("follow", "skip", "true", false)
  end
  
--  if tonumber(reaper.GetExtState("follow", "temp"))==nil then reaper.SetExtState("follow", "temp", reaper.time_precise()+100, false) end
  time=reaper.time_precise()
  time2=tonumber(reaper.GetExtState("follow", "temp"))
  if time2==nil then time2=reaper.time_precise() end
  if time<time2+1 then
--    reaper.MB(time,time+100,0)
    reaper.Main_OnCommand(follow_on, 0)
  end

  reaper.SetExtState("follow", "doubleclick", "click", false)
