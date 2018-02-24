--[[
################################################################################
# 
# Copyright (c) 2014-2016 Ultraschall (http://ultraschall.fm)
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

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

a,A=ultraschall.GetUSExternalState("ultraschall_follow", "state")

if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
	current_position = reaper.GetCursorPosition() -- Position of edit-cursor
else
    if A~="0" then -- follow mode is active
		current_position = reaper.GetPlayPosition() -- Position of play-cursor
--     elseif reaper.GetPlayState()~=0 then
--          current_position = reaper.GetPlayPosition() -- Position of play-cursor
	else
		current_position = reaper.GetCursorPosition() -- Position of edit-cursor
	end
end

retval, retvals_csv = reaper.GetUserInputs("Insert chapter marker", 1, "Name of this chapter marker:", "") -- User input box

if retval == true then -- User pressed ok          
	markername = retvals_csv
	-- reaper.AddProjectMarker(0, false, current_position, 0 , markername, -1) -- Place named marker
	markercount=ultraschall.CountNormalMarkers_NumGap()
	reaper.AddProjectMarker2(0, false, current_position, 0, markername, markercount, 0)
	runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible
end -- Else = user pressed cancel, so nothing to do here.
