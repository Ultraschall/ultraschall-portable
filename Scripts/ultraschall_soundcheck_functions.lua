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


function SoundcheckMic(userspace)

  retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "")

  if actual_device_name == "CoreAudio Built-in Microph" and ultraschall.CreateTrackString_ArmedTracks() ~= "" then -- Das interne Mic ist ausgewählt und eine Spur zur Aufnahme scharf geschaltet
    return true
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

  if current_playstate==0 and userspace["old_playstate"]==5 and editing_started ~= "1" then -- 0 = Stop, 5 = recording
    return true
  else
    userspace["old_playstate"]=current_playstate
    return false
  end
end


function SetSoundcheck(EventName)


  local sectionName = EventName
  local CheckAllXSeconds =  tonumber(ultraschall.GetUSExternalState(sectionName,"CheckAllXSeconds"))
  local CheckForXSeconds =  tonumber(ultraschall.GetUSExternalState(sectionName,"CheckForXSeconds"))
  local StartActionsOnceDuringTrue = toboolean(ultraschall.GetUSExternalState(sectionName,"StartActionsOnceDuringTrue"))
  local EventPaused =       toboolean(ultraschall.GetUSExternalState(sectionName,"EventPaused"))
  local CheckFunction =     _G[ultraschall.GetUSExternalState(sectionName,"CheckFunction")]

  local start_id = tostring(reaper.NamedCommandLookup("_Ultraschall_Soundcheck_Startgui"))
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

  local update = ultraschall.SetUSExternalState(sectionName, "EventIdentifier", EventIdentifier , true)

end
