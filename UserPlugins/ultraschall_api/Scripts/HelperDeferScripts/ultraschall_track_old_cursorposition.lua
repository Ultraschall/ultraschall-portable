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
-- "Ultraschall" -> "editcursor_position_old" - the old editcursor-position
-- "Ultraschall" -> "editcursor_position_new" - the new editcursor-position
-- "Ultraschall" -> "editcursor_position_changetime" - the time the last change has happened
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

reaper.SetExtState("ultraschall", "editcursor_position_old", cursorpos, false)
reaper.SetExtState("ultraschall", "editcursor_position_new", cursorpos, false)
reaper.SetExtState("ultraschall", "editcursor_position_changetime", -1, false)
reaper.SetExtState("ultraschall", "defer_scripts_"..filename2, "true", false)


function main()
  if reaper.GetCursorPosition()~=cursorpos then
    reaper.SetExtState("ultraschall", "editcursor_position_old", cursorpos, false)
    reaper.SetExtState("ultraschall", "editcursor_position_new", reaper.GetCursorPosition(), false)
    reaper.SetExtState("ultraschall", "editcursor_position_changetime", reaper.time_precise(), false)
    cursorpos=reaper.GetCursorPosition()
    --[[reaper.ClearConsole()
    reaper.ShowConsoleMsg("Previous:"..reaper.GetExtState("ultraschall", "editcursor_position_old").."\nCurrent : "..
                          reaper.GetExtState("ultraschall", "editcursor_position_new").."\n".."Time of Last Change: "..
                          reaper.GetExtState("ultraschall", "editcursor_position_changetime"))--]]
  end
  if reaper.GetExtState("ultraschall", "defer_scripts_"..filename2)~="false" then 
    reaper.defer(main) 
  end
end

function exit()
  reaper.DeleteExtState("ultraschall", "editcursor_position_old", false)
  reaper.DeleteExtState("ultraschall", "editcursor_position_new", false)
  reaper.DeleteExtState("ultraschall", "editcursor_position_changetime", false)
  reaper.DeleteExtState("ultraschall", "defer_scripts_"..filename2, false)
end

reaper.atexit(exit)
main()
