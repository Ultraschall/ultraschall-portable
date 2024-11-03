--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

tracks_count = reaper.CountTracks(0)
if tracks_count > 0 then
	numberOfSLTracks = 0
	for i = 0, tracks_count+1 do 
		if ultraschall.IsTrackStudioLink(i) then
			numberOfSLTracks = numberOfSLTracks +1
		end
	end
end

if numberOfSLTracks > 0 then
	if numberOfSLTracks > 1 then addon = "s" else addon = "" end
	result = reaper.ShowMessageBox( "Please make sure to end all calls in the StudioLink webbrowser interface BEFORE you proceed!", "Warning: "..numberOfSLTracks.." StudioLink Track"..addon, 1 )
	if result == 2 then
		goto ending
	end  -- Info window
end

reaper.Main_OnCommand(40026, 0) -- Save Project

ultraschall.SetUSExternalState("ultraschall_gui", "donotopen_backupfolder", "true")

reaper.Main_OnCommand(reaper.NamedCommandLookup("_Ultraschall_consolidate_backups"), 0) -- Move all Backups to Backup folder

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
			if ((fx_name) == "AUi: Ultraschall: Soundboard") or ((fx_name) == "VSTi: Soundboard (Ultraschall)") then     -- this is a track with Soundboard Plugin
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

--get the slot of the StudioLink effect.

::tryagain::

if string.match(os, "OS") then
  fx_slot = reaper.TrackFX_AddByName(m, "StudioLinkOnAir (ITSR)", false, 0)
elseif string.match(os, "Win") then -- Windows
  fx_slot = reaper.TrackFX_GetByName(m, "StudioLinkOnAir (IT-Service Sebastian Reimers)", 0)
elseif string.match(os, "Other") then -- Linux
  fx_slot = reaper.TrackFX_GetByName(m, "Studio Link onAir", 0)
end

if fx_slot ~= -1 then
	reaper.TrackFX_Delete(m, fx_slot)
	goto tryagain  -- falls es mehr als einen Effekt gibt
end

on_air_button_id = reaper.NamedCommandLookup("_Ultraschall_OnAir")

reaper.SetToggleCommandState(sec, on_air_button_id, 0)
reaper.RefreshToolbar2(sec, on_air_button_id)


-----------------------------
-- Add the Limiter Effect to the Master to end up at -16LUFS and deactivate ist
-----------------------------

mastertrack = reaper.GetMasterTrack(0)

dynamics_count = 0
limiter_count = 0
lufs_count = 0

-- Gibt es irgendwo schon Dynamics und/oder Limiter-Effekte auf dem Master?

for i = 0, reaper.TrackFX_GetCount(mastertrack) do
	retval, fxName = reaper.TrackFX_GetFXName(mastertrack, i, "")
	if string.find(fxName, "Dynamic") then
		dynamics_count = dynamics_count +1
	elseif string.find(fxName, "Limiter") then
		limiter_count = limiter_count +1
	elseif string.find(fxName, "LUFS") then
		lufs_count = lufs_count +1
	end
end

--[[]

if dynamics_count == 0 then -- wenn schon was da ist: Finger weg
	fx_slot = reaper.TrackFX_AddByName(mastertrack, "Ultraschall_Dynamics", false, 1) -- muss bei JS-Effekten der Filename sein O__o
	reaper.TrackFX_SetEnabled(mastertrack, fx_slot, false)
	reaper.TrackFX_SetPreset(mastertrack, fx_slot, "Master Just Limiter")
end

if limiter_count == 0 then -- wenn schon was da ist: Finger weg
	fx_slot = reaper.TrackFX_AddByName(mastertrack, "MGA_JSLimiter", false, 1) 
	reaper.TrackFX_SetEnabled(mastertrack, fx_slot, false)
	reaper.TrackFX_SetPreset(mastertrack, fx_slot, "Master -16 LUFS")
end

]]

if lufs_count == 0 then -- wenn schon was da ist: Finger weg
	fx_slot = reaper.TrackFX_AddByName(mastertrack, "LUFS_Loudness_Meter", false, 1) 
	reaper.TrackFX_SetEnabled(mastertrack, fx_slot, false)
	-- reaper.TrackFX_SetPreset(mastertrack, fx_slot, "Master -16 LUFS")
end

-----------------------------
-- Enable all sends to master for rendering
-----------------------------

reaper.Main_OnCommand(40296,0) -- select all tracks
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_ENMPSEND"), 0) -- Enable all sends to Master
reaper.Main_OnCommand(40297,0) -- unselect all tracks


-----------------------------
-- reset Soundcheck warnings
-----------------------------

reaper.SetProjExtState(0, "Editing", "started", "1")

-----------------------------
-- Set Routing
-----------------------------

commandid = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Editing")
reaper.Main_OnCommand(commandid,0)         -- update Matrix

-----------------------------
-- Display Info
-----------------------------

txt = "- Automation mode of all tracks is set to trim/read\n- All tracks and envelopes are disarmed for recording\n- All sends to StudioLink tracks (if existent) have been removed\n- All StudioLink FX (if existent) have been removed\n- All Soundboard FX (if existent) have been removed\n- Studio Link OnAir Streaming (if active) has been stopped\n- All sends to Master have been enabled\n- Routing is set to editing stage\n\nYou may proceed editing your project!"
title = "OK! Your project is now ready for editing:"
result = reaper.ShowMessageBox( txt, title, 0 )

-----------------------------

reaper.Undo_EndBlock("Prepare all tracks for editing", -1) -- End of the undo block. Leave it at the bottom of your main function.

::ending::


-- local info = debug.getinfo(1,'S');
-- script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
-- keymap = dofile(script_path .. "/assets/keymap.pdf")
