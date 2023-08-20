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

followmode_cmdid = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
followmode_togglestate = reaper.GetToggleCommandState(followmode_cmdid)
ar_start, ar_end = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
timesel_start, timesel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)


if timesel_start==0 and timesel_end==0 then return end

reaper.PreventUIRefresh(1)
reaper.MoveEditCursor(-reaper.GetCursorPosition()+timesel_start, false)
reaper.Main_OnCommand(reaper.NamedCommandLookup("_Ultraschall_Preroll"), 0)
reaper.Main_OnCommand(40317, 0)
if followmode_togglestate==0 then
  reaper.GetSet_ArrangeView2(0, true, 0, 0, ar_start, ar_end)
end
reaper.PreventUIRefresh(-1)
