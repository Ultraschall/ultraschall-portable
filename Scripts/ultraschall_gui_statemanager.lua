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

-- little helpers
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function IsAnyMuteOrVolumePreFXEnvelopeVisible(autotogglebutton)
  -- autotogglebutton
  -- true, set the state of the mute-envelope-button in Main toolbar accordingly
  -- false, just return, if there are any visible Mute/Volume(PreFX)-envelopes
  for i=0, reaper.CountTracks()-1 do
    local Track=reaper.GetTrack(0,i)
    local TrackEnvelope_Mute = reaper.GetTrackEnvelopeByName(Track, "Mute")
    local TrackEnvelope_Volume = reaper.GetTrackEnvelopeByName(Track, "Volume (Pre-FX)")
    if TrackEnvelope_Mute~=nil or TrackEnvelope_Volume~=nil then
      local Aretval2, Aretval
      if TrackEnvelope_Mute~=nil then   Aretval2= reaper.GetEnvelopeInfo_Value(TrackEnvelope_Mute,   "I_TCPH_USED") else Aretval2=0 end
      if TrackEnvelope_Volume~=nil then Aretval = reaper.GetEnvelopeInfo_Value(TrackEnvelope_Volume, "I_TCPH_USED") else Aretval=0  end

      if Aretval2>0 or Aretval>0 then
        if autotogglebutton==true then
          local cmdid=reaper.NamedCommandLookup("_Ultraschall_Mute_Envelope")
          reaper.SetToggleCommandState(0, cmdid, 1)
          reaper.RefreshToolbar(cmdid)
        end
      return true end
    end
  end
  if autotogglebutton==true then
    local cmdid=reaper.NamedCommandLookup("_Ultraschall_Mute_Envelope")
    reaper.SetToggleCommandState(0, cmdid, 0)
    reaper.RefreshToolbar(cmdid)
  end
  return false
end


function checkGuiStates()

  A = IsAnyMuteOrVolumePreFXEnvelopeVisible(true)

  for i = 1, #GUIServices do

    commandid = reaper.NamedCommandLookup(GUIServices[i])
    gui_state = reaper.GetToggleCommandStateEx(0, commandid) -- aktueller Status des jeweiligen Buttons
    retval, project_state = reaper.GetProjExtState(0, "gui_statemanager", GUIServices[i]) -- lade den gespeicherten State aus der Projektdatei

    -- print(gui_state.."-gui:file-"..project_state)

    if project_state == "" then -- es wurde noch kein GUI-Status für dieses Elelemnt in die Projektdatei gespeichert
      reaper.SetProjExtState(0, "gui_statemanager", GUIServices[i], tostring(gui_state)) -- speichere den aktuellen GUI-Status in die Projektdatei
    elseif project_state ~= tostring(gui_state) then -- die states unterscheiden sich
      -- print(GUIServices[i].."-"..project_state.."-"..gui_state)
      if  (string.find(GUIServices[i], "Matrix") or string.find(GUIServices[i], "View")) and project_state == "0" then -- bei den Routingmatrix- und View-Einträgen wird nur der aktiv gespeicherte ausgewertet
        -- abwarten, der relevante Eintrag des Routings/View kommt noch
      else

        reaper.Main_OnCommand(commandid,0) -- stelle den GUI-State um so dass die Werte wieder stimmen

      end

    end -- alles ok, states sind gleich also nichts zu tun

  end

  -- Start Helper Scripts

  for i = 1, #GUIHelpers do

    helperActive = tonumber(ultraschall.GetUSExternalState("ultraschall_settings"..GUIHelpers[i],"value", "ultraschall-settings.ini"))

    -- print (helperActive)

    if helperActive == 1 then
      -- print "huhu"
      commandid = reaper.NamedCommandLookup(GUIHelpers[i])
      reaper.Main_OnCommand(commandid,0)
    end

  end

  -- print ("--")

  timecount = timecount + 1
  if timecount == 600 then
    -- print ("huhu")

    commandid = reaper.NamedCommandLookup("_Ultraschall_Consolidate_Backups")
    reaper.Main_OnCommand(commandid,0)
    timecount = 0
  end

 -------------------------------------------------
 -- Defer-Schleife
 -------------------------------------------------

  ultraschall.Defer(checkGuiStates, "Check GUI Defer", 2, 1) -- alle 2 Sekunden
	return "Check GUI Defer"

end

-- Settings

GUIServices = {
  "_Ultraschall_Toggle_Follow",
  "_Ultraschall_Toggle_Mouse_Selection",
  "_Ultraschall_Toggle_Magicrouting",
  "_Ultraschall_set_Matrix_Preshow",
  "_Ultraschall_set_Matrix_Editing",
  "_Ultraschall_set_Matrix_Recording",
  "_Ultraschall_Set_View_Setup",
  "_Ultraschall_Set_View_Record",
  "_Ultraschall_Set_View_Edit",
  "_Ultraschall_Set_View_Story",
  "_Ultraschall_toggle_item_labels",
}

GUIHelpers = {
  "_Ultraschall_GUI_setmagiccolor",
  "_Ultraschall_GUI_setmagictrackheight",
}

timecount = 0

checkGuiStates()

-- 	retval = ultraschall.StopDeferCycle("Check GUI Defer")
