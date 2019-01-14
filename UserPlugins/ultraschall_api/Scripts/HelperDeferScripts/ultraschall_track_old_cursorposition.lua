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

-- Meo Mespotine, 13th November 2018

-- stores the last editcursorposition into the non-persistant extstate
-- "Ultraschall" -> "last_editcursor_position"
--
-- This is a workaround for scripts, that run after the user left-clicked into the 
-- arrangeview, as this usually changes the editcursorposition before running an action
-- associated with it. But if you want to work with the cursorposition at the old position
-- you usually have a problem in Reaper.
-- This script helps you with that.

cursorpos=reaper.GetCursorPosition()

is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
filename2=filename:match(".*/(.*)")
if filename2==nil then filename2=filename:match(".*\\(.*)") end
if filename2==nil then filename2=filename end

reaper.SetExtState("ultraschall", "last_editcursor_position", cursorpos, false)
reaper.SetExtState("ultraschall", "defer_scripts_"..filename2, "true", false)


function main()
  if reaper.GetCursorPosition()~=cursorpos then
    reaper.SetExtState("ultraschall", "last_editcursor_position", cursorpos, false)
    cursorpos=reaper.GetCursorPosition()
  end
  reaper.defer(main)
end

function exit()
  reaper.SetExtState("ultraschall", "defer_scripts_"..filename2, "false", false)
end

reaper.atexit(exit)
main()
