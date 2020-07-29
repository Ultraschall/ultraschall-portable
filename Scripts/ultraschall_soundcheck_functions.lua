--[[
################################################################################
#
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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

function SoundcheckUnsaved(userspace)


  -- print(reaper.GetPlayStateEx(0))
  --print(reaper.IsProjectDirty(0))

  if reaper.GetProjectName(0, "") == "" and ultraschall.CreateTrackString_ArmedTracks() ~= "" then -- das Projekt wurde noch nicht gespeichert und es wurden tracks zur Aufnahme scharf geschaltet
    return true
  else
    return false
    -- if tonumber(reaper.GetExtState ("soundcheck_timer", "unsaved"))+120 < reaper.time_precise() then
    --        soundcheck_unsaved_action()

  end

end


function SoundcheckOverdub(userspace)


  if reaper.GetPlayState() ~= 5 then
    userspace["skip_overdub_check"] = 0 -- stoppen der Aufnahme führt dazu, dass beim nächsten Recording der Check wieder durchgeführt wird
    -- return false
  end

  if userspace["skip_overdub_check"] == 1 then
    return false
  end

  preroll_rec = reaper.GetExtState("ultraschall_PreviewRecording", "RecPosition")
  preroll_dialog = reaper.GetExtState("ultraschall_PreviewRecording", "Dialog")
  if preroll_rec ~= "" or preroll_dialog == "1" then -- es ist ein Preroll-Recording aktiv, also alles ok
    return false
  end

  local length = reaper.GetProjectLength(0)
  local play = reaper.GetPlayPosition()
  local cursor = reaper.GetCursorPosition()

  if cursor >= length then -- alles in Ordnung, muss für diese Aufnahme nicht weiter geprüft werden.
    userspace["skip_overdub_check"] = 1
    userspace["overdub_warning"] = 0
    return false

  elseif (play < length and reaper.GetPlayState() == 5) or userspace["overdub_warning"] == 1 then -- es gibt Elemente, die hinter dem Rec-Cursor stehen und eine Aufnahme läuft

    local itemcount = reaper.CountMediaItems(0)
    if itemcount == 0 then
      userspace["skip_overdub_check"] = 1
      userspace["overdub_warning"] = 0
      return false --ist die erste Aufnahme überhaupt, kann also nicht überlappen
    end

    trackstringarmed = ultraschall.CreateTrackString_ArmedTracks() -- gibt einen String aus aller armed tracks mit Kommas getrennt

    armedtracktable = {}
    for tracknumber in string.gmatch(trackstringarmed, '([^,]+)') do  -- baue einen indexierten Table mit den armed tracks
      armedtracktable[tracknumber] = "armed"
    end


    for i = 0, itemcount-1 do -- gehe alle Items durch ob es irgendwo ein Ende gibt, das hinter der aktuellen Aufnahmeposition steht


      local MediaItem = reaper.GetMediaItem(0, i)
      local MediaItemTrackChunk = reaper.GetMediaItemInfo_Value(MediaItem, "P_TRACK") -- in welchem Track ist das Item
      local MediaItemTrack = reaper.GetMediaTrackInfo_Value(MediaItemTrackChunk, "IP_TRACKNUMBER")
      local MediaItemTrack = string.format("%." .. (0 or 0) .. "f", MediaItemTrack)

      local end_position = reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION") + reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")

      if play < end_position and armedtracktable[MediaItemTrack] then -- es ist wirklich ein overdub und der Track ist armed
        userspace["overdub_warning"] = 1
        userspace["skip_overdub_check"] = 0 -- auch weiter prüfen
        return true
      end
    end

    userspace["skip_overdub_check"] = 1
    userspace["overdub_warning"] = 0
    return false -- war wohl nur eine Kapitelmarke etc.

  elseif userspace["overdub_warning"] == 1 then
    userspace["skip_overdub_check"] = 0
    return true

  else
    return false
  end

end

function SoundcheckMic(userspace)

  retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "")
  -- armed = ultraschall.CreateTrackString_ArmedTracks()
  number = reaper.Master_GetPlayRate(0)
  armed = false

  for i=0, reaper.CountTracks(0)-1 do
    local MediaTrack = reaper.GetTrack(0,i)
    if reaper.GetMediaTrackInfo_Value(MediaTrack, "I_RECARM") == 1 then
      -- print(ultraschall.GetTypeOfTrack(i+1))
      if ultraschall.GetTypeOfTrack(i+1) == "Other" then  -- Soundboard und StudioLink sollen den Mic-Check nicht triggern
        armed = true
      end
    end
  end


  if number ~= 1 and armed then
    reaper.Main_OnCommand(40521,0) -- setze Playrate auf 1 vor Aufnahme
  end

  if armed then -- teste nur, wenn eine Spur zur Aufnahme aktiviert wurde

    if actual_device_name == "CoreAudio Built-in Microph" then -- Das interne Mic ist ausgewählt
      return true
    elseif actual_device_name == "CoreAudio Default" and reaper.GetExtState("ultraschall_mic", "internal") == "true" then -- Das Standard-Device war beim Start ausgewählt und es ist auf das interne Micro geschaltet gewesen
      return true
    else
      return false
    end

  else
    return false
  end

end



function SoundcheckSamplerate(userspace)

  local retval, actual_samplerate = reaper.GetAudioDeviceInfo("SRATE", "")
  local i = 0

  for i=1, reaper.CountTracks(0) do

    if (ultraschall.IsTrackStudioLink(i) or ultraschall.IsTrackStudioLinkOnAir(0)) and actual_samplerate ~= "48000" then  -- es gibt mindestens eine StudioLink Spur und Samplerate steht nicht auf 48000
      -- print(actual_samplerate.."."..i)
      return true
    end

  end
  return false
end


function SoundcheckTransitionRecordToStop(userspace)
  -- get the current playstate
  local current_playstate=reaper.GetPlayState()
  local retval, editing_started = reaper.GetProjExtState(0, "Editing", "started")
  local retval, recording_started = reaper.GetProjExtState(0, "Recording", "started")

  if current_playstate==5 then --
    reaper.SetProjExtState(0, "Editing", "started", "0")
    reaper.SetProjExtState(0, "Recording", "started", "1")
    userspace["prepare_warning"] = "0"
    -- userspace["old_playstate"]=current_playstate
    return false
  elseif userspace["prepare_warning"] == "1" and editing_started ~= "1" then
    return true

  elseif current_playstate==1 and recording_started == "1" and editing_started ~= "1" then -- 0 = Stop, 5 = recording
    userspace["prepare_warning"] = "1"
    reaper.OnStopButton()

    return true
  else
    userspace["prepare_warning"] = "0"
    return false
  end
end


function SoundcheckBsize(userspace)

  local retval, actual_bsize = reaper.GetAudioDeviceInfo("BSIZE", "")
  local retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "")
  local actual_device_type = tonumber(ultraschall.GetUSExternalState("ultraschall_devices", actual_device_name ,"ultraschall-settings.ini"))
  local retval, step = reaper.GetProjExtState(0, "ultraschall_magicrouting", "step")

  if actual_device_name == "" then -- überhaupt kein Device aktiv - vermutlich während des Renderns
    return false
  end

  if ultraschall.CreateTrackString_ArmedTracks() ~= "" and tonumber(actual_bsize) > 128 and (step == "preshow" or step == "recording") and (actual_device_type == 0 or actual_device_type == 3) then

  -- Latenz zu hoch
    -- Aufnahme oder Preshow
    -- aktuelles Device kein lokales Monitoring
    -- Größer als 128
    -- mindestens ein Track ist für Aufnahme aktiviert

    return true

  elseif tonumber(actual_bsize) < 128 and (actual_device_type == 1 or actual_device_type == 2) then

    -- Kleiner als 128
    -- aktuelles Device hat lokales Monitoring

    return true

  elseif tonumber(actual_bsize) < 32 then

    return true

  -- Latenz zu niedrig

  else
    return false
  end

end


function SoundcheckChangedInterface(userspace)
  -- get the current Interface
  local retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "")

  if actual_device_name ~= userspace["old_device_name"] and actual_device_name ~= "" and reaper.CountTracks(0) > 0 then -- Device wurde gewechselt und es wird nicht gerendert und es gibt mindestens 1 Spur

    local known_device_status = ultraschall.GetUSExternalState("ultraschall_devices", actual_device_name, "ultraschall-settings.ini")

    if known_device_status == "" then

      name_short = string.sub(actual_device_name, 1, 17)
      device_string = "Unknown interface: "..name_short
      warning_string = "You connected this sound interface for the first time:|"..actual_device_name.."|Please specify whether or nor you are using local monitoring on this device.|If your headphones are connected to the sound interface - choose local monitoring.|If your headphones are connected to the phones-jack of your computer: choose no local monitoring."

      local update = ultraschall.SetUSExternalState("ultraschall_soundcheck_changed_interface", "EventNameDisplay", device_string, "ultraschall-settings.ini")

      local update = ultraschall.SetUSExternalState("ultraschall_soundcheck_changed_interface", "DescriptionWarning", warning_string, "ultraschall-settings.ini")

      return true

    else

      if known_device_status == "2" then -- Device ist bekannt, aber ausgeblendet und kann lokales monitoring
        new_status = "1"
      elseif known_device_status == "3" then -- Device ist bekannt, aber ausgeblendet und kann kein lokales monitoring
        new_status = "0"
      else
        new_status = known_device_status
      end

      local update = ultraschall.SetUSExternalState("ultraschall_devices", actual_device_name, new_status ,"ultraschall-settings.ini")

      reaper.SetProjExtState(0, "ultraschall_magicrouting", "override", "on")	--Routing-Matrix neu aufbauen

      userspace["old_device_name"] = actual_device_name

      local update = ultraschall.SetUSExternalState("ultraschall_soundcheck_changed_interface", "EventNameDisplay", "Unknown sound interface?", "ultraschall-settings.ini")

      return false

    end

  else -- Device ist gleich geblieben
    return false
  end

end



function SetSoundcheck(EventName)


  local sectionName = EventName
  local CheckAllXSeconds =  tonumber(ultraschall.GetUSExternalState(sectionName,"CheckAllXSeconds","ultraschall-settings.ini"))
  local CheckForXSeconds =  tonumber(ultraschall.GetUSExternalState(sectionName,"CheckForXSeconds","ultraschall-settings.ini"))
  local StartActionsOnceDuringTrue = toboolean(ultraschall.GetUSExternalState(sectionName,"StartActionsOnceDuringTrue","ultraschall-settings.ini"))
  local EventPaused =       toboolean(ultraschall.GetUSExternalState(sectionName,"EventPaused","ultraschall-settings.ini"))
  local CheckFunction =     _G[ultraschall.GetUSExternalState(sectionName,"CheckFunction","ultraschall-settings.ini")]
  local StartFunction =     ultraschall.GetUSExternalState(sectionName,"StartFunction","ultraschall-settings.ini")

  local start_id = tostring(reaper.NamedCommandLookup(StartFunction))
  local start_id = start_id..",0"

  local EventIdentifier = ultraschall.EventManager_AddEvent(
    EventName, -- a descriptive name for the event
    CheckAllXSeconds,                                      -- how often to check within a second; 0, means as often as possible
    CheckForXSeconds,                                      -- how long to check for it in seconds; 0, means forever
    StartActionsOnceDuringTrue,                                   -- shall the actions be run as long as the eventcheck-function
                                                    --       returns true(false) or not(true)
    EventPaused,                                  -- shall the event be paused(true) or checked for right away(true)
    CheckFunction,              -- the eventcheck-functionname,
    {start_id}                            -- a table, which hold all actions and their corresponding sections
                                                    --       in this case action 40157 from section 0
                                                    --       note: both must be written as string "40157, 0"
                                                    --             if you want to add numerous actions, you can write them like
                                                    --             {"40157, 0", "40171,0"}, which would add a marker and open
                                                    --                                      the input-markername-dialog
  )

  ultraschall.ShowLastErrorMessage()

  local update = ultraschall.SetUSExternalState(sectionName, "EventIdentifier", EventIdentifier,"ultraschall-settings.ini")

end
