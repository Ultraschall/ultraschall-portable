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
 
-- little helpers

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)             

starttime=reaper.time_precise()+0.5

-- with high zoom-in-levels, we need to take care a little bit more
play=false
if reaper.GetHZoomLevel()>1500 then play=true end
if reaper.GetHZoomLevel()>1500 then reaper.SetExtState("follow", "skip", "true", false) end

if state ~= 1 then                            
	-- Followmode on                                      
	reaper.SetToggleCommandState(sec, cmd, 1)
	ultraschall.SetUSExternalState("ultraschall_follow", "state", 1)
	reaper.SetExtState("follow", "recognized", "false", false)
	if reaper.GetPlayState()~=0 and play==false then
		-- Follow On with low zoom-in-levels 
		ultraschall.pause_follow_one_cycle()
		ultraschall.ToggleScrollingDuringPlayback(1, false, play)
		reaper.Main_OnCommand(40150,0) -- Go to play position
		start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
		length=((end_time-start_time)/2)+(2/reaper.GetHZoomLevel())
		reaper.BR_SetArrangeView(0, (reaper.GetPlayPosition()-length), (reaper.GetPlayPosition()+length))          
	elseif reaper.GetPlayState()~=0 and play==true then
		-- Follow On with high zoom-in-levels 
		ultraschall.pause_follow_one_cycle()
		reaper.Main_OnCommand(40150,0) -- Go to play position
		ultraschall.ToggleScrollingDuringPlayback(1, false, play)
		ultraschall.pause_follow_one_cycle()
		runcommand("_Ultraschall_Center_Arrangeview_To_Cursor")
	else
		-- Follow On with seldom edge-cases
		ultraschall.pause_follow_one_cycle()
		ultraschall.ToggleScrollingDuringPlayback(1, false, false)
	end
else
	-- Followmode off
	reaper.SetToggleCommandState(sec, cmd, 0)
	ultraschall.ToggleScrollingDuringPlayback(0, false, false)     
	ultraschall.SetUSExternalState("ultraschall_follow", "state", 0)
end

reaper.RefreshToolbar2(sec, cmd)

