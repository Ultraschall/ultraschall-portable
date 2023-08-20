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

-- ------ USER CONFIG AREA =====>
-- here you can customize the script
-- Envelope Output Properties
-- <===== USER CONFIG AREA ------

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function PutActiveEnvelopesIntoLane_IfSetInPrefs()
  -- shows all visible envelopes in either the track-lane or in it's own envelope-lane, depending
  -- on the setting in preferences -> Envelope Display -> Show new envelopes in separate envelope lanes
  Envlanes=reaper.SNM_GetIntConfigVar("envlanes", "-9999")&1
  if Envlanes&1==1 then
    -- show envelopes under the tracks
    lanevisible=1
  else
    -- show envelopes within the arrange-view-tracklane
    lanevisible=0
  end

  for i=0, reaper.CountTracks(0)-1 do
    for a=0, reaper.CountTrackEnvelopes(reaper.GetTrack(0,i)) do
      TrackEnvelope = reaper.GetTrackEnvelope(reaper.GetTrack(0,i), a)
      visible, lane, unknown = ultraschall.GetEnvelopeState_Vis(TrackEnvelope)
      ultraschall.SetEnvelopeState_Vis(TrackEnvelope, visible, lanevisible, unknown)
    end
  end

end


--PutActiveEnvelopesIntoLane_IfSetInPrefs()

--if LOL==nil then return end

-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

-- Set ToolBar Button OFF
function SetButtonOFF()  -- local (is_new_value, filename, sec, cmd, mode, resolution, val)
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd )
end


 -- Set ToolBar Button ON
function SetButtonON()  -- local (is_new_value, filename, sec, cmd, mode, resolution, val)
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end


 -- Return armed state of an Envelope
function armedEnvelope(env)  -- local br_env, active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling

  -- GET THE ENVELOPE
  br_env = reaper.BR_EnvAlloc(env, false)
  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, atype, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
    reaper.BR_EnvFree(br_env, 1)
  return armed
end



 -- Return armed state: Is there at least one armed envelope anywhere?
function checkArmedEnvelope() -- local (tracks_count, i, j, item, take, track)

    isArmed = false
  -- LOOP TRHOUGH TRACKS
    tracks_count = reaper.CountTracks(0)

    -- if selected_tracks_count > 0 and UserInput() then
    if tracks_count > 0 then
      for i = 0, tracks_count-1  do

        -- GET THE TRACK
        track = reaper.GetTrack(0, i) -- Get selected track i

        -- LOOP THROUGH ENVELOPES
        env_count = reaper.CountTrackEnvelopes(track)
        for j = 0, env_count-1 do

          -- GET THE ENVELOPE
          env = reaper.GetTrackEnvelope(track, j)

          if armedEnvelope(env) == true then
            isArmed = true
          end

        end -- ENDLOOP through envelopes

      end -- ENDLOOP through tracks

    end
  return isArmed
end -- end checkVisibleEnvelope()


 -- Return visible state of an envelope
function visibleEnvelope(env)  -- local (br_env, active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling)
    br_env = reaper.BR_EnvAlloc(env, false)   -- GET THE ENVELOPE
  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, atype, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
    reaper.BR_EnvFree(br_env, 1)
  return visible
end


 -- Return visible state: is there at least one visible envelope anywhere?
function checkVisibleEnvelope() -- local (isVisible, tracks_count, i, j, item, take, track)
    isVisible = false

    tracks_count = reaper.CountTracks(0)
    if tracks_count > 0 then
      for i = 0, tracks_count-1  do        -- LOOP TRHOUGH TRACKS
        track = reaper.GetTrack(0, i) -- Get selected track i

        -- LOOP THROUGH ENVELOPES
        env_count = reaper.CountTrackEnvelopes(track)
        for j = 0, env_count-1 do

          -- GET THE ENVELOPE
          env = reaper.GetTrackEnvelope(track, j)
          if visibleEnvelope(env) == true then
            isVisible = true
          end

        end -- ENDLOOP through envelopes
      end -- ENDLOOP through tracks

    end

  return isVisible
end -- end checkVisibleEnvelope()



 -- Return state of automation: is there at least one track with active automation?
function checkAutomation() -- local (isAutomation, tracks_count, i, track)
    isAutomation = false

    tracks_count = reaper.CountTracks(0)
    if tracks_count > 0 then
      for i = 0, tracks_count-1  do      -- LOOP TRHOUGH TRACKS
        track = reaper.GetTrack(0, i) -- Get selected track i
    if reaper.GetTrackAutomationMode(track) == 3 then
      isAutomation = true
    end
      end -- ENDLOOP through tracks
  end
  return isAutomation
end -- end checkAutomation()



function main()
  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

  if reaper.CountSelectedMediaItems(0) > 0 and reaper.CountSelectedTracks(0) == 0 then

    cmd = reaper.NamedCommandLookup("_S&M_TAKEENVSHOW9")
    reaper.Main_OnCommand(cmd,0)

  elseif checkVisibleEnvelope() == true then
    -- if the Mute button is ON
    reaper.Main_OnCommand(41150,0)               -- Envelope: Hide all envelopes for all tracks
    SetButtonOFF()                               -- Set Mute-Button off

  else
    -- if the Mute button is OFF
    state = reaper.GetPlayState()
    if state == 5 then
      -- if a recording is active
      reaper.Main_OnCommand(41152,0)             -- Envelope: Toggle show all envelopes for all tracks
      SetButtonON()                              -- Set Mute-Button on
    else
      -- there is no recording yet
      if reaper.CountMediaItems(0) == 0 then
        -- if there are no items in the project yet
        if (reaper.CountSelectedTracks(0) == 0) then
          -- if there's no track selected
            if checkAutomation() == false then
              -- there is no track with active cough button
              atype = 0
              title = "Cough button and mute envelope"
              msg = "Please select (Num 1-9) the tracks you would like to activate cough buttons for."
              result = reaper.ShowMessageBox( msg, title, atype )
              SetButtonOFF()
            else
              -- there is a track with active cough button
              reaper.Main_OnCommand(41152,0)     -- Envelope: Toggle show all envelopes for all tracks
              SetButtonON()                      -- toggle button on
            end
        else
          reaper.Main_OnCommand(40866,0)         -- Track: Toggle track mute envelope active
          reaper.Main_OnCommand(40867,0)         -- Track: Toggle track mute envelope visible
          reaper.Main_OnCommand(40403,0)         -- Automation: Set track automation mode to write
          reaper.Main_OnCommand(40888,0)         -- Evelope: Show all active envelopes for tracks
          SetButtonON()
        end
      else
        -- there is a recording/existing mediaitems
        if (reaper.CountSelectedTracks(0) == 0) then
          -- no track selected
          if checkArmedEnvelope() == true then
            -- mute envelopes already in place
            reaper.Main_OnCommand(41152,0)       -- Envelope: Toggle show all envelopes for all tracks
            SetButtonON()                        -- toggle button on
          else
          -- no mute envelope in place
            atype = 0
            title = "Cough button and mute envelope"
            msg = "Please select (Num 1-9) the tracks you would like to activate the mute envelope for."
            result = reaper.ShowMessageBox( msg, title, atype )    -- just give a reminder to select some tracks
            SetButtonOFF()
          end
        else                                     -- there is at least one track selected
          reaper.Main_OnCommand(40866,0)         -- Track: Toggle track mute envelope active
          reaper.Main_OnCommand(40867,0)         -- Track: Toggle track mute envelope visible
          reaper.Main_OnCommand(40400,0)         -- Automation: Set track automation mode to write
          reaper.Main_OnCommand(41149,0)         -- Evelope: Show all active envelopes for tracks
          SetButtonON()
        end
      end

      PutActiveEnvelopesIntoLane_IfSetInPrefs()

    end


  end

  reaper.Undo_EndBlock("Hide envelope and set it as inactive", -1) -- End of the undo block. Leave it at the bottom of your main function.
end -- end main()

reaper.PreventUIRefresh(1)
main() -- Execute your main function
reaper.PreventUIRefresh(-1)



reaper.UpdateArrange() -- Update the arrangement (often needed)
