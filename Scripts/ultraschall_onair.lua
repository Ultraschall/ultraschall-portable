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
  
																	-- Print Message to console (debugging)
function Msg(val)
	reaper.ShowConsoleMsg(tostring(val).."\n")
end

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)                           --get state of the OnAir Button: on (1) /off (0)

playstate = reaper.GetPlayState()
-- reaper.ShowConsoleMsg(state)
if playstate == 5 and state == 1 then -- is recording and stream active

	--[[type:
	0=OK,
	1=OKCANCEL,
	2=ABORTRETRYIGNORE,
 	3=YESNOCANCEL,
 	4=YESNO,
 	5=RETRYCANCEL]]

	type = 0
	title = "Active Recording"
	msg = "You have to stop the recording before you can stop broadcasting."
	result = reaper.ShowMessageBox( msg, title, type )

	--[[result:
	1=OK,
 	2=CANCEL,
 	3=ABORT,
 	4=RETRY,
 	5=IGNORE,
 	6=YES,
 	7=NO
	]]

	if result == 1 then -- abort
		return
	end
else
	reaper.Undo_BeginBlock()

	m = reaper.GetMasterTrack(0)                                                  --streaming is always on the master track
	-- fx_name_retval, fx_name = reaper.TrackFX_GetFXName(m, 0, "")           --get the name of the first effect, debug only

	os = reaper.GetOS()
	if string.match(os, "OSX") then 
		--		fx_slot = reaper.TrackFX_GetByName(m, "ITSR: StudioLinkOnAir", 1)      --get the slot of the StudioLink effect. If there is none: initiate one.
		-- fx_slot = reaper.TrackFX_GetByName(m, "2StudioLinkOnAir (ITSR)", 1)      --get the slot of the StudioLink effect. If there is none: initiate one.		
		-- fx_slot = reaper.TrackFX_AddByName(m, "ITSR: StudioLinkOnAir", false, 1)	
		fx_slot = reaper.TrackFX_AddByName(m, "StudioLinkOnAir", false, 1)

	else	-- Windows
		fx_slot = reaper.TrackFX_GetByName(m, "StudioLinkOnAir (IT-Service Sebastian Reimers)", 1)      --get the slot of the StudioLink effect. If there is none: initiate one.
	end


	if state ~= 1 then                                                                  --streaming is off: start streaming
		reaper.SetToggleCommandState(sec, cmd, 1)
		test2 = reaper.TrackFX_SetEnabled(m, fx_slot, true)
	else                                                                                --streaming is on: stop streaming
		reaper.SetToggleCommandState(sec, cmd, 0)
		reaper.SNM_MoveOrRemoveTrackFX(m, fx_slot, 0)							-- remove FX
	end     

	reaper.RefreshToolbar2(sec, cmd)

	reaper.Undo_EndBlock("Ultraschall toggle StudioLink OnAir", -1)

-- nix,name = reaper.TrackFX_GetFXName(m,0,"")
-- Msg(name)

end