--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

numberOfTracks = reaper.CountTracks(0)

function getNextColor (LastColor)

  ColorPosition = t_invert[LastColor]

  -- print (ColorPosition)

  if ColorPosition == nil then
    ColorPosition = 0
  else
    ColorPosition = ColorPosition + 3
  end

  return t[ColorPosition]

end


function swapColors (color)

  if string.match(os, "OSX") then
    r, g, b = reaper.ColorFromNative(color)
    -- print ("NewTrack: "..TrackColor.."-"..r.."-"..g.."-"..b)
    color = reaper.ColorToNative(b, g, r)
  end
  return color

end

-- Init

-----------------------
-- Step 1 : get started
-----------------------

max_color = 20  -- Number of colors to cycle
curtheme = reaper.GetLastColorThemeFile()
os = reaper.GetOS()

---------------------------------------------------------
-- Step 2 : build table with color values from theme file
---------------------------------------------------------

t = {}   -- initiate table
t_invert = {}
file = io.open(curtheme, "r");

for line in file:lines() do
  index = string.match(line, "group_(%d+)")  -- use "Group" section
  index = tonumber(index)
    if index then
      if index < max_color then
      color_int = string.match(line, "=(%d+)")  -- get the color value
        if string.match(os, "OSX") then
          r, g, b = reaper.ColorFromNative(color_int)
          color_int = reaper.ColorToNative(r, g, b) -- swap r and b for OSX
        end
      t[index] = tonumber(color_int)  -- put color into table
      t_invert[tonumber(color_int)] = index
    end
  end
end


for key,value in pairs(t_invert) do

  print (key.."-"..value)

end



LastColor = 0

print ("-")



for i=0, numberOfTracks-1 do

  MediaTrack = reaper.GetTrack(0, i)
  TrackColor = reaper.GetTrackColor(MediaTrack)
  TrackColor = swapColors(TrackColor)

  -- print(TrackColor)
  -- print(tostring(TrackColor))


  if TrackColor == 0 then -- frische Spur, noch keine Farbe gesetzt

    -- LastColor = swapColors(LastColor)

    -- print ("last: "..LastColor)

    NewTrackColor = getNextColor(LastColor)

    r, g, b = reaper.ColorFromNative(NewTrackColor)
    -- print ("NewTrack: "..NewTrackColor.."-"..r.."-"..g.."-"..b)
    -- NewTrackColor = reaper.ColorToNative(b, g, r)

    reaper.SetTrackColor(MediaTrack, swapColors(NewTrackColor))
    TrackColor = NewTrackColor
  end

  LastColor = TrackColor



end








--[[




function buildRoutingMatrix ()

	local AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates()
	local AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives()

	soundbed_mix = tonumber(ultraschall.GetUSExternalState("ultraschall_settings_preshow_mix", "Value" ,"ultraschall-settings.ini")) -- wie hoch soll der Anteil des Soundbards während der Preshow im Monitormix sein

--	 print(serialize(AllMainSends))

  for i=1, number_of_tracks do

  	tracktype = ultraschall.GetTypeOfTrack(i)

    if tracktype == "StudioLink" then	-- Behandlung der StudioLink Spuren

    	retval = ultraschall.AddTrackHWOut(i, 0, 0, 1, 0, 0, 0, 0, -1, 0, false) -- StudioLink-Spuren gehen immer auf den MainHardwareOut Zurück

    	for j=1, number_of_tracks do

    		if ultraschall.GetTypeOfTrack(j) ~= "StudioLink" then

					-- boolean retval = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number unknown, integer midichanflag, integer automation, boolean undo)
					if ultraschall.GetTypeOfTrack(j) == "SoundBoard" then
						send_volume = soundbed_mix
					else
						send_volume = 1
					end

    			setstate = ultraschall.AddTrackAUXSendReceives(i, j, 0, send_volume, 0, 0, 0, 0, 0, 0, -1, 0, 0, false)
    			-- print(i.j)
    		end
			end

    elseif tracktype == "SoundBoard" then	-- Behandlung der Soundboard Spuren

			AllMainSends[i]["MainSendOn"] = 1 -- Bei der Preshow sendet nur das Soundboard auf den Main

      retval = ultraschall.AddTrackHWOut(i, 0, 0, soundbed_mix, 0, 0, 0, 0, -1, 0, false) -- Soundboard-Spuren gehen immer auf den MainHardwareOut Zurück

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
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_set_Matrix_Editing", 0)
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_set_Matrix_Recording", 0)
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_set_Matrix_Preshow", 1)

reaper.RefreshToolbar2(sec, cmd)


-- profile.stop()
-- report for the top 10 functions, sorted by execution time
-- local r = profile.report('time', 10)
-- print(r)

]]