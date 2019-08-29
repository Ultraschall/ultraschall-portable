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
 
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

reaper.Main_OnCommand(40088, 0) -- set all tracks automation mode to trim/read

reaper.Main_OnCommand(40491, 0) -- unarm all tracks for recording

reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_DISARMALLENVS"), 0) -- Disarm all Envelopes

reaper.Main_OnCommand(40491, 0) -- unarm all tracks for recording

reaper.Main_OnCommand(40297,0) -- unselect all tracks

reaper.Main_OnCommand(reaper.NamedCommandLookup("_Ultraschall_Select_StudioLink"), 0) -- select all StudioLink tracks

reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_SENDS5"), 0) -- remove all receives from selected (StudioLink) tracks 

reaper.Main_OnCommand(reaper.NamedCommandLookup("_Ultraschall_Remove_Studiolink_FX"), 0) -- remove all StudioLink FX

reaper.Main_OnCommand(40297,0) -- unselect all tracks

tracks_count = reaper.CountTracks(0)
if tracks_count > 0 then                                                  
	for i = 0, tracks_count-1 do                                         -- LOOP TRHOUGH TRACKS
		track = reaper.GetTrack(0, i)                                    -- Get selected track i
		count_fx = reaper.TrackFX_GetCount(track)
		for j = 0, count_fx - 1 do                    
			fx_name_retval, fx_name = reaper.TrackFX_GetFXName(track, j, "")
			if ((fx_name) == "AUi: Ultraschall: Soundboard") or ((fx_name) == "VSTi: Soundboard (Ultraschall)") then     -- this is a track with StudioLink Plugin
				--Msg(fx_name)
				reaper.SNM_MoveOrRemoveTrackFX(track, j, 0)  --remove Soundboard Effect
			end

		end     
	end                                                                       -- ENDLOOP through tracks
end

-----------------------------
-- remove StudioLink OnAir FX from Master
-----------------------------

m = reaper.GetMasterTrack(0)                                                  --streaming is always on the master track
os = reaper.GetOS()
sec = ultraschall.GetUSExternalState("ultraschall_gui", "sec")
if sec=="-1" then sec="0" end
sec=tonumber(sec)

if string.match(os, "OSX") then 
	fx_slot = reaper.TrackFX_GetByName(m, "ITSR: StudioLinkOnAir", 1)      --get the slot of the StudioLink effect. If there is none: initiate one.
else     -- Windows
	fx_slot = reaper.TrackFX_GetByName(m, "StudioLinkOnAir (IT-Service Sebastian Reimers)", 1)      --get the slot of the StudioLink effect. If there is none: initiate one.
end

reaper.SNM_MoveOrRemoveTrackFX(m, fx_slot, 0)

on_air_button_id = reaper.NamedCommandLookup("_Ultraschall_OnAir")

reaper.SetToggleCommandState(sec, on_air_button_id, 0)
reaper.RefreshToolbar2(sec, on_air_button_id)

-----------------------------
-- Enable all sends to master for rendering
-----------------------------

reaper.Main_OnCommand(40296,0) -- select all tracks
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_ENMPSEND"), 0) -- Enable all sends to Master
reaper.Main_OnCommand(40297,0) -- unselect all tracks


-----------------------------
-- Display Info
-----------------------------

txt = "- Automation mode of all tracks is set to trim/read\n- All tracks and envelopes are disarmed for recording\n- All sends to StudioLink tracks (if existent) have been removed\n- All StudioLink FX (if existent) have been removed\n- All Soundboard FX (if existent) have been removed\n- Studio Link OnAir Streaming (if active) has been stopped\n- All sends to Master have been enabled\n\nYou may proceed editing your project!"
title = "OK! Your project is now ready for editing:"
result = reaper.ShowMessageBox( txt, title, 0 )

-----------------------------

reaper.Undo_EndBlock("Prepare all tracks for editing", -1) -- End of the undo block. Leave it at the bottom of your main function.



-- local info = debug.getinfo(1,'S');
-- script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
-- keymap = dofile(script_path .. "/assets/keymap.pdf")
