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

-- Adjusts zoom stepwise.
-- Will limit the zoom out from 0 to projectlength+edit/play-cursor, depending on what is the last.

-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

_,_,_,_,mode,res,val = reaper.get_action_context()

ultraschall={}
function ultraschall.GetIniFileValue(section, key, errval, inifile)
-- returns the trackname as a string
  if errval==nil then errval="" end
  section=tostring(section)
  key=tostring(key)

  return reaper.BR_Win32_GetPrivateProfileString(section, key, errval, inifile)
end

function ultraschall.GetUSExternalState(section, key, filename)
-- gets a value from ultraschall.ini
-- returns length of entry(integer) and the entry itself(string)
  -- get value
  local A, B = ultraschall.GetIniFileValue(section, key, "", reaper.GetResourcePath().."/"..filename)
  if A==-1 then B="" end
  return B
end

    steplength = 0.4 -- factor to adjust the steplength of the zoom
    sensitivity = tonumber(ultraschall.GetUSExternalState("ultraschall_settings_Zoom_Sensitivity", "Value", "ultraschall-settings.ini"))
    if sensitivity==nil then sensitivity = 5 end -- 0.4-4 are useful values
    length=0
    
    --get end of project or position of play/editcursor in the project, depending on what is the last
    if reaper.GetPlayState()~=0 and reaper.GetPlayState()&4==4 and reaper.GetProjectLength()<reaper.GetPlayPosition() and reaper.GetPlayPosition()>reaper.GetCursorPosition() then 
      length=reaper.GetPlayPosition()
    elseif reaper.GetProjectLength()<reaper.GetCursorPosition() then 
      length=reaper.GetCursorPosition()
    else
      length=reaper.GetProjectLength()
    end

if length<180 then length=180 end   -- zoomlimit does not apply under 3 minutes
    if mode==-1 and res==-1 and val==-1 then val=0 end
    
    
    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    
    if end_time-start_time>1500 then
      steplength=steplength/2^(sensitivity+1)
    --elseif end_time-start_time<3600 and end_time-start_time>1500 then
--      steplength=steplength/2^(sensitivity+1)
    elseif end_time-start_time<1500 then
      steplength=steplength/2^sensitivity
    end
    
    val = val * steplength    
    
    if val<0 and end_time-start_time-((end_time-start_time)/5)>length then
        -- reaper.Main_OnCommand(40295,0)
        reaper.SetExtState("ultraschall_follow", "started", "started", false)
    else
        reaper.adjustZoom(val, 0, false, -1)
        start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
        
        if val < 0 and end_time-start_time>=length then
            -- reaper.Main_OnCommand(40295,0)
            reaper.SetExtState("ultraschall_follow", "started", "started", false)
        end
    end

 reaper.UpdateTimeline()
 reaper.UpdateArrange()
 
