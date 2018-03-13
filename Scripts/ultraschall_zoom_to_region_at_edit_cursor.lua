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

in_pos, out_pos = reaper.GetSet_LoopTimeRange(0,0,0,0,0) --store time selection start and end

pos = reaper.GetCursorPosition()
marker,region = reaper.GetLastMarkerAndCurRegion(0, pos) -- get region at cursor position

retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(region)
duration_of_region = rgnend - pos

if isrgn and duration_of_region>0 then
    reaper.Undo_BeginBlock()
    reaper.GetSet_LoopTimeRange(true,false,n_pos,n_rgnend,false) -- set time selection
    reaper.Main_OnCommand(40031, 0) -- zoom to time selection
    reaper.GetSet_LoopTimeRange(true,false,in_pos,out_pos,false) -- restore time selection
    reaper.Undo_EndBlock("Ultraschall: Zoom out to region at cursor position", -1)
end

