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

-- Sets Timeselection from Playcursor to Mouseposition(during play/rec) or from
-- Editcursor to Mouseposition(during stop)
-- Will do nothing, when mouse isn't in Arrange-View.

retval, segment, details = reaper.BR_GetMouseCursorContext()
time=reaper.BR_GetMouseCursorContext_Position()

if retval=="arrange" then
  if reaper.GetPlayState()~=0 then
    startloop, endloop = reaper.GetSet_LoopTimeRange2(0, true, false, reaper.GetPlayPosition(), time, false)
  else
    startloop, endloop = reaper.GetSet_LoopTimeRange2(0, true, false, reaper.GetCursorPosition(), time, false)
  end
end
