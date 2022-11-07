--[[
################################################################################
#
# Copyright (c) Ultraschall (http://ultraschall.fm)
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

reaper.PreventUIRefresh(1)

follow_cmd=reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
toggle_state=reaper.GetToggleCommandState(follow_cmd)==1

if toggle_state==false then
  start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0,0,0,0)
end

reaper.Main_OnCommand(40630,0)
ultraschall.RunCommand("_Ultraschall_Preroll")
reaper.Main_OnCommand(40317,0)

if toggle_state==false then
  start_time, end_time = reaper.GetSet_ArrangeView2(0, true, 0, 0, start_time, end_time)
end
reaper.PreventUIRefresh(1)
