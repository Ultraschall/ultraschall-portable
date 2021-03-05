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


-----------------------------
-- Functions for trackheight
-----------------------------



function getAllTracksHeight ()

  local height = 0
  local singleheight = 0
  local numberOfTracks = reaper.CountTracks(0)

  for i=0, numberOfTracks-1 do
    local MediaTrack = reaper.GetTrack(0, i)
    local retval = reaper.GetMediaTrackInfo_Value(MediaTrack, "I_WNDH")
    -- print ("Höhe: "..retval)
    height = height + retval
    singleheight = retval
    -- print (retval)
  end
  return height, singleheight
end

function verticalZoom (maxheight)
  
  local numberOfTracks = reaper.CountTracks(0)
  local allTracksHeight, singleheight = getAllTracksHeight()
  -- print (singleheight)
  
  local offset = maxheight * 0.05 -- ca. 10% der Arangevie Höhe sollen frei bleiben )
  if numberOfTracks == 1 then offset = maxheight * 0.6 end
  if numberOfTracks == 2 then offset = maxheight * 0.3 end
  -- if numberOfTracks == 3 then offset = maxheight * 0.3 end

  if allTracksHeight < maxheight - offset then -- muss Vergößert werden
    while allTracksHeight < maxheight - offset do
      reaper.CSurf_OnZoom(0, 1)
      allTracksHeight = getAllTracksHeight()
    end
  end
  if allTracksHeight > maxheight - offset then -- muss Verkleinert werden
    while allTracksHeight > maxheight - offset and singleheight > 24 do -- kleiner als 24 können Tracks nicht werden
      reaper.CSurf_OnZoom(0, -1)
      allTracksHeight, singleheight = getAllTracksHeight()
      -- print (singleheight)
    end
  end
end

function countAllEnvelopes ()

  local count = 0
  local numberOfTracks = reaper.CountTracks(0)

  for i=0, numberOfTracks-1 do

    local MediaTrack = reaper.GetTrack(0, i)
    local numberOfEnvelopes = reaper.CountTrackEnvelopes(MediaTrack)

    for j = 0, numberOfEnvelopes-1 do
      TrackEnvelope = reaper.GetTrackEnvelope(MediaTrack, j)
      BR_Envelope = reaper.BR_EnvAlloc(TrackEnvelope, false)

      active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, envType, faderScaling, automationItemsOptions = reaper.BR_EnvGetProperties(BR_Envelope)

      if visible == true then
        count = count + 1
      end
    end

  end

  return count
end

-- main trackheight function

function _Ultraschall_GUI_setmagictrackheight()

  numberOfTracks = reaper.CountTracks(0)
  numberOfEnvelopes = countAllEnvelopes()
  override = reaper.GetExtState("ultraschall_gui", "adjustvzoom")
  -- print ("tracks: "..numberOfTracks)
  -- print ("lasttracks: "..lastNumberOfTracks)
  -- print ("envelopes: "..numberOfEnvelopes)
  -- print ("lastNumberOfEnvelopes: "..lastNumberOfEnvelopes)
  
  if numberOfTracks > 0 and (lastNumberOfEnvelopes ~= tostring(numberOfEnvelopes) or lastNumberOfTracks ~= tostring(numberOfTracks)) or override == "1" then
    
    -- print ("last number envelopes:"..lastNumberOfEnvelopes.."-"..tostring(numberOfEnvelopes))
    -- print ("last number tracks:"..lastNumberOfTracks.."-"..tostring(numberOfTracks))

    local _, left, top, right, bottom = reaper.JS_Window_GetClientRect( reaper.JS_Window_FindChildByID( reaper.GetMainHwnd(), 1000) )
    ArrangeViewHeight = math.abs(bottom - top)

    verticalZoom (ArrangeViewHeight)

    retval = ultraschall.ApplyActionToTrack("1,0", 40913) -- verschiebe den Arrangeview hoch zum ersten Track
    reaper.SetExtState("ultraschall_gui", "numbertracks", numberOfTracks, false)
    reaper.SetExtState("ultraschall_gui", "numberenvelopes", numberOfEnvelopes, false)
    reaper.SetExtState("ultraschall_gui", "adjustvzoom", "0", false)
    lastNumberOfTracks = tostring(numberOfTracks)
    lastNumberOfEnvelopes = tostring(numberOfEnvelopes)

  end  
end

-------------------------------
-- End of trackheight functions
-------------------------------



---------------------------------
-- Functions for magic coloring
---------------------------------

function getNextColor (LastColor)

  local ColorPosition = t_invert[LastColor]

  -- print (ColorPosition)

  if ColorPosition == nil then
    ColorPosition = 0
  elseif ColorPosition > 9 then
    ColorPosition = ColorPosition - 9
  else
    ColorPosition = ColorPosition + 2
  end

  return t[ColorPosition]

end


function swapColors (color)


    r, g, b = reaper.ColorFromNative(color)
    -- print ("NewTrack: "..TrackColor.."-"..r.."-"..g.."-"..b)

    if string.match(os, "OS") then
      color = reaper.ColorToNative(b, g, r)
    else
      color = reaper.ColorToNative(r, g, b)
    end
  return color
end


function countColoredStudioLinkTracks ()

  local count = 0
  local numberOfTracks = reaper.CountTracks(0)
  for i=1, numberOfTracks do

    local tracktype = ultraschall.GetTypeOfTrack(i)
    -- print (tracktype)
    if tracktype == "StudioLink" then

      local MediaTrack = reaper.GetTrack(0, i-1)
      local TrackColor = reaper.GetTrackColor(MediaTrack)
      -- print (TrackColor)
      if TrackColor ~= 0 then
        count = count +1
      end
    end
  end

  return count
end

function getUsedColors()
  local usedColors = {}
  local numberOfTracks = reaper.CountTracks(0)
  if numberOfTracks > 0 then
    for i=0, numberOfTracks-1 do
      MediaTrack = reaper.GetTrack(0, i)
      TrackColor = reaper.GetTrackColor(MediaTrack)
      TrackColor = swapColors(TrackColor)
      if usedColors[TrackColor] then 
        usedColors[TrackColor] = usedColors[TrackColor] + 1 
      else 
        usedColors[TrackColor] = 1 
      end
    end
  end
  return usedColors
end


---------------------------
-- Main magiccolor function
---------------------------

function _Ultraschall_GUI_setmagiccolor()

  local used_colors = getUsedColors()
  local numberOfTracks = reaper.CountTracks(0)

  if numberOfTracks == 0 then
    LastColor = 0
  end

local processedColors = {}

  for i=0, numberOfTracks-1 do

    MediaTrack = reaper.GetTrack(0, i)
    TrackColor = reaper.GetTrackColor(MediaTrack)
    TrackColor = swapColors(TrackColor)

    if TrackColor == 0 or (used_colors[TrackColor] > 1 and processedColors[TrackColor] == 1) then -- frische Spur, oder Farbe schon vorhanden

      tracktype = ultraschall.GetTypeOfTrack(i+1)

      -- print (tracktype)

      if tracktype == "SoundBoard" then

        soundboardColor = reaper.ColorToNative(100, 100, 100)
        reaper.SetTrackColor(MediaTrack, soundboardColor)

      elseif tracktype == "StudioLink" then

        colored = countColoredStudioLinkTracks() or 0
        -- print (colored)
        StudioLinkColor = t[colored + 11] or t[12]
        reaper.SetTrackColor(MediaTrack, swapColors(StudioLinkColor))

      else -- normaler Track

        NewTrackColor = getNextColor(LastColor)
        r, g, b = reaper.ColorFromNative(NewTrackColor)
        -- print ("NewTrack: "..NewTrackColor.."-"..r.."-"..g.."-"..b)
        -- NewTrackColor = reaper.ColorToNative(b, g, r)

        reaper.SetTrackColor(MediaTrack, swapColors(NewTrackColor))
        TrackColor = NewTrackColor
      end
    end

    --    print (tracktype)

    if tracktype == "Other" then
      LastColor = TrackColor
    end

  processedColors[TrackColor] = 1

  end
end

-- end color functions


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


-- defer Loop:

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

      _G[GUIHelpers[i]]() -- rufe die jeweilige Funktion auf

      -- commandid = reaper.NamedCommandLookup(GUIHelpers[i])
      -- reaper.Main_OnCommand(commandid,0)
    end

  end

  timecount = timecount + 1
  if timecount == 600 and reaper.GetPlayState() ~= 5 then -- alle 10 Minuten, und nur wenn kein Recording läuft werden Backup-Files verschoben
    -- print ("huhu")

    commandid = reaper.NamedCommandLookup("_Ultraschall_Consolidate_Backups")
    reaper.Main_OnCommand(commandid,0)
    timecount = 0
  end

 -------------------------------------------------
 -- Defer-Schleife
 -------------------------------------------------

  ultraschall.Defer(checkGuiStates, "Check GUI Defer", 1, 10) -- alle 0.2 Sekunden
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

-----------------
-- Init color
-----------------

numberOfTracks = reaper.CountTracks(0)
max_color = 20  -- Number of colors to cycle
curtheme = reaper.GetLastColorThemeFile()
os = reaper.GetOS()
LastColor = 0
colored = 0

---------------------------------------------------------
-- Init: build table with color values from theme file
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
      -- color_int = swapColors (color_int)
      t[index] = tonumber(color_int)  -- put color into table
      t_invert[tonumber(color_int)] = index
    end
  end
end

-- end init color

-------------------
-- Init trackheight
-------------------

numberOfEnvelopes = countAllEnvelopes()
lastNumberOfTracks = reaper.GetExtState("ultraschall_gui", "numbertracks") or 0
lastNumberOfEnvelopes = reaper.GetExtState("ultraschall_gui", "numberenvelopes") or 0


-- start main defer loop:

checkGuiStates()

-- 	retval = ultraschall.StopDeferCycle("Check GUI Defer")
