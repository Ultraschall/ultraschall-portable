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

if (reaper.CountSelectedTracks(0) == 0) then  	-- no track selected
	reaper.Main_OnCommand(40296,0) 				-- select all tracks
	runcommand("_XENAK_TOGGLETRACKHEIAB")
	reaper.Main_OnCommand(40297,0) 				-- unselect all tracks
else
	runcommand("_XENAK_TOGGLETRACKHEIAB")
end

-------------------------------------
reaper.Undo_EndBlock("Ultraschall Toggle Track Height", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
