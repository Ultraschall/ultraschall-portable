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

ultraschall={}

function ultraschall.GetUSExternalState(section, key)
  -- get value
  local A, B = reaper.BR_Win32_GetPrivateProfileString(section, key, "", reaper.GetResourcePath().."/".."ultraschall.ini")
  return B
end

lasttime=reaper.GetExtState("ultraschall", "right_key_speedup_time_selection")
lastfactor=reaper.GetExtState("ultraschall", "right_key_speedup_factor_time_selection")

speedupfactor = ultraschall.GetUSExternalState("ultraschall_navigation", "move_cursor_and_timesel_speedup")
if tonumber(speedupfactor)==nil then speedupfactor=0.4 else speedupfactor=tonumber(speedupfactor) end

if lasttime=="" then lasttime=reaper.time_precise() end
if lastfactor=="" then lastfactor=0 end

if tonumber(lasttime)>=reaper.time_precise() then
  lastfactor=lastfactor+speedupfactor
else
  lastfactor=1
end

for i=0, lastfactor do
  reaper.Main_OnCommand(40103,0)
end

reaper.SetExtState("ultraschall", "right_key_speedup_time_selection", reaper.time_precise()+0.1, false)
reaper.SetExtState("ultraschall", "right_key_speedup_factor_time_selection", lastfactor, false)
