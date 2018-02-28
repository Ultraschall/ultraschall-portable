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
 
-------------------------------------
-- Print Message to console (debugging)
-------------------------------------

function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

-------------------------------------
-- run a command by its name
-------------------------------------

function runcommand(cmd)	
	start_id = reaper.NamedCommandLookup(cmd)
	reaper.Main_OnCommand(start_id,0) 
end


-------------------------------------
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
-------------------------------------

init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)

if init_end_timesel ~= init_start_timesel then		-- there is a time selection
	reaper.Main_OnCommand(40061, 0)						-- Split all Items at time selection
	reaper.Main_OnCommand(40717, 0)						-- Select all items in time selection
	reaper.Main_OnCommand(41383, 0)						-- Copy all items within time selection to clipboard
	reaper.Main_OnCommand(40201, 0)						-- Ripple cut Selection
  reaper.Main_OnCommand(40289, 0)						-- Unselect all Items


elseif reaper.CountSelectedMediaItems(0) == 1 then	-- exacty one item selected
	runcommand("_SWS_SAFETIMESEL")						-- Set time selection to item borders
	reaper.Main_OnCommand(40061, 0)						-- Split all Items at time selection
	reaper.Main_OnCommand(40717, 0)						-- Select all items in time selection
	reaper.Main_OnCommand(41383, 0)						-- Copy all items within time selection to clipboard
	reaper.Main_OnCommand(40201, 0)						-- Ripple cut Selection
	reaper.Main_OnCommand(40289, 0)						-- Unselect all Items

else 													-- no time selection or items selected
 	result = reaper.ShowMessageBox( "No time selection active", "Ultraschall Ripple Cut", 0 )	-- Info window
end

-------------------------------------
reaper.Undo_EndBlock("Ultraschall Ripple Cut", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
