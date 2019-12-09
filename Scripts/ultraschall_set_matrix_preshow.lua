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

-- local profile = require(reaper.GetResourcePath().."/Scripts/profile")
-- consider "Lua" functions only
-- profile.hookall("Lua")


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- dofile(reaper.GetResourcePath().."/Scripts/ser.lua")

-- local serialize = require (reaper.GetResourcePath().."/Scripts/ser")


function buildRoutingMatrix ()

	local AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates()
  local AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives()

--	 print(serialize(AllMainSends))

  for i=1, number_of_tracks do

  	tracktype = ultraschall.GetTypeOfTrack(i)

    if tracktype == "StudioLink" then	-- Behandlung der StudioLink Spuren

    	retval = ultraschall.AddTrackHWOut(i, 0, 0, 1, 0, 0, 0, 0, -1, 0, false) -- StudioLink-Spuren gehen immer auf den MainHardwareOut Zurück

    	for j=1, number_of_tracks do

    		if ultraschall.GetTypeOfTrack(j) ~= "StudioLink" then

					-- boolean retval = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number unknown, integer midichanflag, integer automation, boolean undo)

    			setstate = ultraschall.AddTrackAUXSendReceives(i, j, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, false)
    			-- print(i.j)
    		end
			end

    elseif tracktype == "SoundBoard" then	-- Behandlung der Soundboard Spuren

			AllMainSends[i]["MainSendOn"] = 1 -- Bei der Preshow sendet nur das Soundboard auf den Main

			soundbed_mix = tonumber(ultraschall.GetUSExternalState("ultraschall_settings_preshow_mix", "Value" ,"ultraschall-settings.ini")) -- wie hoch soll der ANteil des Soundbards während der Preshow im Monitormix sein

      retval = ultraschall.AddTrackHWOut(i, 0, 0, soundbed_mix, 0, 0, 0, 0, -1, 0, false) -- Soundboard-Spuren gehen immer auf den MainHardwareOut Zurück

			if ultraschall.GetUSExternalState("ultraschall_settings_soundboard_ducking","Value", "ultraschall-settings.ini") == "1" then -- Ducking ist in den Settings aktiviert

				for j=1, number_of_tracks do

					if ultraschall.GetTypeOfTrack(j) ~= "SoundBoard" then -- jeder Track der nicht Soundboard ist schickt sein Signal auf den 3/4 Kanal des Soundboards

						-- boolean retval = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number unknown, integer midichanflag, integer automation, boolean undo)

						setstate = ultraschall.AddTrackAUXSendReceives(i, j, 0, 1, 0, 0, 0, 0, 0, 2, -1, 0, 0, false)
						-- print(i.j)
					end
				end
			end

		else -- normaler, lokaler Track

			retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "")

			if tonumber(ultraschall.GetUSExternalState("ultraschall_devices",actual_device_name,"ultraschall-settings.ini")) == 0 then  -- Audio-Device kann kein lokales Monitoring
				retval = ultraschall.AddTrackHWOut(i, 0, 0, 1, 0, 0, 0, 0, -1, 0, false) -- sendet auch auf den HWOut in den Kopfhörer
			end

		end
  end

  retval = ultraschall.ApplyAllMainSendStates(AllMainSends)	-- setze alle Sends zum Master

end


-- profile.start()

retval = ultraschall.ClearRoutingMatrix(true, true, true, true, false)

if reaper.CountTracks(0) > 0 then
  buildRoutingMatrix ()
end

reaper.SetProjExtState(0, "ultraschall_magicrouting", "step", "preshow")

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)

ID_1 = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Preshow") -- Setup Button
ID_2 = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Recording") -- Record Button
ID_3 = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Editing") -- Edit Button

if state <= 0 then
  reaper.SetToggleCommandState(sec, cmd, 1)
end

reaper.SetToggleCommandState(sec, ID_2, 0)
reaper.SetToggleCommandState(sec, ID_3, 0)

reaper.RefreshToolbar2(sec, cmd)


-- profile.stop()
-- report for the top 10 functions, sorted by execution time
-- local r = profile.report('time', 10)
-- print(r)
