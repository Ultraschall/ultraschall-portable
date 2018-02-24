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

-- sets Arrangeview to that the cursor-position is centered if the cursor is not visible
-- when stopped, it will take the edit-cursor, when playing/recording, it will take the play-cursor instead


local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

a,A=ultraschall.GetUSExternalState("ultraschall_follow", "state")

start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
length=(end_time-start_time)/3

if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
  if reaper.GetCursorPosition() < start_time or reaper.GetCursorPosition() > end_time then -- Cursor is not visible
    reaper.BR_SetArrangeView(0, (reaper.GetCursorPosition()-length), (reaper.GetCursorPosition()+length))
  end
else
    if A~="0" then -- follow mode is active
      if reaper.GetPlayPosition() < start_time or reaper.GetPlayPosition() > end_time then -- Cursor is not visible
        reaper.BR_SetArrangeView(0, (reaper.GetPlayPosition()-length), (reaper.GetPlayPosition()+length))
      end
  else
      if reaper.GetCursorPosition() < start_time or reaper.GetCursorPosition() > end_time then -- Cursor is not visible
        reaper.BR_SetArrangeView(0, (reaper.GetCursorPosition()-length), (reaper.GetCursorPosition()+length))
      end
  end
end


