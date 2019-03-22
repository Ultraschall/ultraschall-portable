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
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- global lastchange = 0

function checkrouting()
 --  reaper.ShowConsoleMsg(A.."\n")
 --  A=A+1
 -- 	currentmatrix, number_of_tracks = ultraschall.GetAllAUXSendReceives2()
 -- 	changed = ultraschall.AreAUXSendReceivesTablesEqual(currentmatrix, lastmatrix)
 -- 	print (changed)
 	-- if changed == false then

	 	-- currentchange = reaper.GetProjectStateChangeCount(0)
	 	-- if currentchange > lastchange + 1 then 
if reaper.CountTracks(0) > 0 then

		 	step = ultraschall.GetUSExternalState("ultraschall_magicrouting", "step")

		 	if step == "preshow" then 
		 		commandid = reaper.NamedCommandLookup("_Ultraschall_Set_Matrix_Preshow")
		 	elseif step == "recording" then
				commandid = reaper.NamedCommandLookup("_Ultraschall_Set_Matrix_Recording")
		 	else -- editing
				commandid = reaper.NamedCommandLookup("_Ultraschall_Set_Matrix_Editing")
			end

		 	reaper.Main_OnCommand(commandid,0)         -- update Matrix
end
		-- 	lastchange = currentchange
		 	
		-- 	print (lastchange)
		-- end

  retval, defer_identifier = ultraschall.Defer1(checkrouting, 2, 1)
  reaper.CF_SetClipboard(defer_identifier)

end


is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)             


if state ~= 1 then                            
	-- Magicrouting on                                      
	reaper.SetToggleCommandState(sec, cmd, 1)
	ultraschall.SetUSExternalState("ultraschall_magicrouting", "state", 1)
	A=1      
  checkrouting()

else
	-- Magicrouting off
	reaper.SetToggleCommandState(sec, cmd, 0)
	ultraschall.SetUSExternalState("ultraschall_magicrouting", "state", 0)
	-- reaper.ShowConsoleMsg("Stop".."\n")

	defer_identifier_from_clipboard = reaper.CF_GetClipboard("")
	retval = ultraschall.StopDeferCycle(defer_identifier_from_clipboard)
end

reaper.RefreshToolbar2(sec, cmd)

