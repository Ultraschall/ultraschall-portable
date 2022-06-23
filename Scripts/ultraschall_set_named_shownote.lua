--[[
################################################################################
#
# Copyright (c) 2016 Ultraschall (http://ultraschall.fm)
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


if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
	current_position = reaper.GetCursorPosition() -- Position of edit-cursor
else
	current_position = reaper.GetPlayPosition() -- Position of play-cursor
end

retval, shownote_comment = reaper.GetUserInputs("Insert shownote", 1, "Comment:", "") -- User input box

if retval == true then -- User pressed ok
--	reaper.AddProjectMarker2(0, false, current_position, 0 , shownote_comment, -1) -- Place named marker
	reaper.AddProjectMarker2(0, false, current_position, 0, shownote_comment, -1, 0x0000FF|0x1000000) -- set blue shownote marker

end -- Else = user pressed cancel, so nothing to do here.