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

-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

-- Adjusts zoom stepwise.
-- Will limit the zoom out from 0 to projectlengt+edit/play-cursor, depending on what is the last.

    steplength = 0.4 -- factor to adjust the steplength of the zoom
    length=0
    
    --get end of project or position of play/editcursor in the project, depending on what is the last
    if reaper.GetPlayState()~=0 and reaper.GetPlayState()&4==4 and reaper.GetProjectLength()<reaper.GetPlayPosition() and reaper.GetPlayPosition()>reaper.GetCursorPosition() then 
      length=reaper.GetPlayPosition()
    elseif reaper.GetProjectLength()<reaper.GetCursorPosition() then 
      length=reaper.GetCursorPosition()
    else
      length=reaper.GetProjectLength()
    end
    
 val = -2
    
    val = val * steplength

    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
        
    if val<0 and end_time-start_time>length then
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
 
