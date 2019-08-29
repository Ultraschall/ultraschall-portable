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

-- Go to playcursor when playing and recording or go to editcursor when stopped
-- Compatible to follow-mode...
   
  if reaper.GetPlayState()~=0 then 
    -- when playing and recording
    reaper.Main_OnCommand(40150,0) -- Go to play position
    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    length=(end_time-start_time)*0.5
    reaper.BR_SetArrangeView(0, (reaper.GetPlayPosition()-length), (reaper.GetPlayPosition()+length))
  else
    -- when stopped
    reaper.Main_OnCommand(40151,0) -- Go to editcursor position
    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    length=(end_time-start_time)*0.5
    reaper.BR_SetArrangeView(0, (reaper.GetCursorPosition()-length), (reaper.GetCursorPosition()+length))    
  end
