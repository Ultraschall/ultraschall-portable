--[[
################################################################################
# 
# Copyright (c) 2014-present Ultraschall - ultraschall.fm
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

--[[

Aufbau der ultraschall-settings.ini

Die Ultraschall-Settings werden aus drei Bereichen dynamisch befüllt und über drei reiter angezeigt:
1. General Settings
2. Soundcheck Settings
3. Interface Settings

--------------------
1. General Settings
--------------------
Enthält alle Einträge, die in einem Abschnitt
[ultraschall_settings_wasuachimmer]
liegen.
Es werden immer diese Felder benötigt (Beispiel):

[ultraschall_settings_startsceen]
Value=1 -- Wert des Eintrages. Bei Checkbox 0=aus 1=an, beim Slider ein numerischer Wert (s.u.)

-----------------------
2. Soundcheck Settings
-----------------------
Enthält alle Einträge, die in einem Abschnitt
[ultraschall_soundcheck_wasuachimmer]
liegen.
Es werden immer diese Felder benötigt (Beispiel):

[ultraschall_soundcheck_mic]
Button1Action=40099 -- Aktion, die auf dem ersten Soundcheck-Button liegt
Button1Label=Change interface... -- Label des ersten Buttons
CheckAllXSeconds=1 -- Intervall, in dem der Soundcheck im Hintergrund prüft
CheckForXSeconds=0 -- steht immer auf 0
CheckFunction=SoundcheckMic -- Funktion, die den eigentlichen Check durchführt, muss in ultraschall_soundcheck_functions.lua liegen. Liefert die Funktion false ist das Ereignis nicht eingetreten, bei true hat der Check angeschlagen.
Description=Prevents you from accidentally recording with the built-in microphone|instead of using your dedicated sound interface. -- Hilfetext auf dem "?" Button in den Settings
DescriptionWarning=You have just armed a track for recording, but your recording interface seems to be the internal microphone. |This results in very poor sound quality. |You can ignore this and still continue or change the sound interface. -- Text, der im Soundcheck-Fenster direkt angezeigt wird
EventIdentifier=Ultraschall_Eventidentifier: {B78C2305-5EBF-8F42-90CA-EE2A31F2FB05} -- wird bei jedem Start neu vergeben, nicht von Nutzern zu verändern
Value=0 -- 0 = Soundcheck abgeschaltet, 1 = angeschaltet (Status der Checkbox)

Jeder Soundcheck _muss_ einen Call-to-Action Button haben. Optional kann auch ein zweiter konfiguriert werden (aber kein dritter):

Button2Action= -- Aktion, die auf dem zweiten Soundcheck-Button liegt
Button2Label= -- Label des zweiten Buttons

Jede Änderung in den Settings wirkt sich unmittelbar auf den EventManager aus. Alle aktiven Soundchecks sind in diesem registriert.

-----------------------
3. Interface Settings
-----------------------

Enthält alle Einträge, die in dem Abschnitt
[ultraschall_devices]
liegen. Diese Einträge werden vom Soundcheck "Unknown sound interface check" gesetzt.

Über die EInträge werden zum einen Devices verwaltet, die gängig sind und von denen wir wissen, ob sie Direct Monitoring können, etwa das Zoom H6:

CoreAudio H6=2

Zum anderen werden dort alle bisher unbekannten Devices mit ihrem Namen eingetragen, die NutzerIn anschließt. Wenn ein bisher unbekanntes Device (noch kein Eintrag in diesen Settings) angeschlossen wird, meldet sich ein Soundcheck mit der Abfrage, ob direct monitoring möglich ist oder nicht. Der Wert wird dann eingetragen.

Wird ein Device über die GUI "gelöscht", so verbleibt der Eintrag in den Settings, wird aber auf unsichtbar geschaltet (Wert 2 oder 3). Wenn das Gerät doch noch einmal angeschlossen wird, erscheint dann kein Soundcheck sondern der entsprechende Wert wird auf 0 oder 1 gesetzt.


die States im Überblick:

-- 0 = eingeblendet, kann/soll kein lokales Monitoring
-- 1 = eingeblendet, kann/soll lokales Monitoring
-- 2 = ausgeblendet, kann/soll lokales Monitoring
-- 3 = ausgeblendet, kann/soll kein lokales Monitoring

]]

-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
dofile(reaper.GetResourcePath().."/Scripts/ultraschall_soundcheck_functions.lua")

gfx_path=reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/"
ini_file=reaper.GetResourcePath().."/ultraschall-settings.ini"

-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

-- check for required version; alter the version-number if necessary
if reagirl.GetVersion()<1.4 then reaper.MB("Needs ReaGirl v"..(1.4).." to run", "Too old version", 0) return false end

function tab_run_function(element_id, selected_tab, selected_tab_name)
  if selected_tab==3 then
    local x, y, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(last_interface, false, 0, 0)
    local x2, y2, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(element_id, false, 0, 0)
    if y-y2+10<280 then 
      reagirl.Tabs_SetBackdropDimensions(element_id, 650, 280)
    else
      reagirl.Tabs_SetBackdropDimensions(element_id, 650, y-y2+10)
    end
  elseif selected_tab==1 then
    reagirl.Tabs_SetBackdropDimensions(element_id, 650, 280)
  elseif selected_tab==2 then
    reagirl.Tabs_SetBackdropDimensions(element_id, 650, 280)
  end
end

-- 1. add the run-functions for the ui-elements
function button_run_function(element_id)
  if element_id==button_help then
    reaper.CF_ShellExecute("https://ultraschall.github.io/ultraschall-manual/en/docs/adaption#ultraschall-settings")
  end
end

function button_run_function_soundcheck_help(element_id)
  -- shows a tooltip for when the help-buttons in the soundcheck-tab are clicked
  local x,y=reaper.GetMousePosition()
  x=x+20*reagirl.Window_GetCurrentScale()
  y=y+20*reagirl.Window_GetCurrentScale()
  element_id=reagirl.UI_Element_GetSetExtState(element_id, false, "Value", tabs2.soundcheck_saveproject)
  reaper.TrackCtl_SetToolTip(reagirl.UI_Element_GetSetMeaningOfUIElement(element_id, false, ""), x, y, true)
end

function StartSoundcheck(name, function_name)
  -- starts a specific soundcheck
  local event_identifier = ultraschall.EventManager_AddEvent(name, 1, 0, false, false, function_name, {"_Ultraschall_Soundcheck_Startgui,0"})
  ultraschall.SetUSExternalState(name, "EventIdentifier", event_identifier, "ultraschall-settings.ini")
end

function slider_run_func(element_id, value)
  if element_id==tabs1.sound_ping_volume then
    -- plays a sound, when the helper-sounds-slider is changed
    ultraschall.RunCommand("_Ultraschall_Play_Sound")
  end
end

function SetAllPagesInvisible()
  -- sets all ui-elements of the settings-pages invisible, so we show only, what we want to show as set in label_run_function()
  reagirl.UI_Element_SetHiddenFromTable(tab_general, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_recording, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_playback, false)
  
  reagirl.UI_Element_SetHiddenFromTable(tab_editing, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_mrouting, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_visuals, false)
  
  reagirl.UI_Element_SetHiddenFromTable(tab_soundboard, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_helpersound, false)
  reagirl.UI_Element_SetHiddenFromTable(tab_soundcheck, false)
  
  --reagirl.UI_Element_SetHiddenFromTable(tab_page_misc, false)
  
end

function ResetLabelStyle()
   -- resets the style of all page-labels, so we can set the chosen page-label as bold&italic
   local r, g, b = 155, 155, 155
   reagirl.Label_SetStyle(page_general, 0)
   reagirl.Label_SetStyle(page_rec, 0)
   reagirl.Label_SetStyle(page_playback, 0)
   
   reagirl.Label_SetStyle(page_editing, 0)
   reagirl.Label_SetStyle(page_magicrouting, 0)
   reagirl.Label_SetStyle(page_visual_settings, 0)
   
   reagirl.Label_SetStyle(page_soundboard, 0)
   reagirl.Label_SetStyle(page_helper_sounds, 0)
   reagirl.Label_SetStyle(page_soundcheck, 0)
   
   reagirl.Label_SetStyle(page_misc, 0)
   
   
   reagirl.Label_SetColor(page_general, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_rec, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_playback, 0, 0, 0, r, g, b)
   
   reagirl.Label_SetColor(page_editing, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_magicrouting, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_visual_settings, 0, 0, 0, r, g, b)
   
   reagirl.Label_SetColor(page_soundboard, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_helper_sounds, 0, 0, 0, r, g, b)
   reagirl.Label_SetColor(page_soundcheck, 0, 0, 0, r, g, b)
   
   reagirl.Label_SetColor(page_misc, 0, 0, 0, r, g, b)
end

function label_run_function(element_id)
  -- manages switching pages in Settings-Tab, when the user clicks into the index
  -- also sets the clicked label to bold&italic
  local style1=0
  local style2=0
  local r=251
  local g=208
  local b=0
  ResetLabelStyle()
  if element_id==page_general then
    reagirl.Label_SetStyle(page_general, style1, style2)
    reagirl.Label_SetColor(page_general, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_general)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_rec then
    reagirl.Label_SetStyle(page_rec, style1, style2)
    reagirl.Label_SetColor(page_rec, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_recording)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_playback then
    reagirl.Label_SetStyle(page_playback, style1, style2)
    reagirl.Label_SetColor(page_playback, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_playback)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_editing then
    reagirl.Label_SetStyle(page_editing, style1, style2)
    reagirl.Label_SetColor(page_editing, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_editing)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_magicrouting then
    reagirl.Label_SetStyle(page_magicrouting, style1, style2)
    reagirl.Label_SetColor(page_magicrouting, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_mrouting)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_visual_settings then
    reagirl.Label_SetStyle(page_visual_settings, style1, style2)
    reagirl.Label_SetColor(page_visual_settings, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_visuals)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_soundboard then
    reagirl.Label_SetStyle(page_soundboard, style1, style2)
    reagirl.Label_SetColor(page_soundboard, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_soundboard)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_helper_sounds then
    reagirl.Label_SetStyle(page_helper_sounds, style1, style2)
    reagirl.Label_SetColor(page_helper_sounds, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_helpersound)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_soundcheck then
    reagirl.Label_SetStyle(page_soundcheck, style1, style2)
    reagirl.Label_SetColor(page_soundcheck, 0, 0, 0, r, g, b)
    tabs1=concat_tables(pages, tab_soundcheck)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  elseif element_id==page_misc then
    reagirl.Label_SetStyle(page_misc, style1, style2)
    reagirl.Label_SetColor(page_misc, 0, 0, 0, r, g, b)
    SetAllPagesInvisible()
    tabs1=concat_tables(pages, tab_misc)
    reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
  end
end

function checkbox_run_function(element_id, checked)
  -- when checkboxes are clicked, this function is run and does things according to what the checkbox needs
  
  -- Checkboxes in the Settings-Tab
  if element_id=="" then
  elseif element_id==tabs1.replace_rec_tape_mode then
    if checked==true then
      reaper.Main_OnCommand(41186, 0)
    else
      reaper.Main_OnCommand(41330, 0)
    end
  elseif element_id==tabs1.soundboard_duck_rec then
    if checked==true then
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_soundboard_ducking", "Value", "1", ini_file)
    else
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_soundboard_ducking", "Value", "0", ini_file)
    end
    ultraschall.RunCommand("_Ultraschall_set_Matrix_Recording")
  elseif element_id==tabs1.soundboard_duck_editing then
    if checked==true then
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_soundboard_ducking_editing", "Value", "1", ini_file)
    else
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_soundboard_ducking_editing", "Value", "0", ini_file)
    end
    ultraschall.RunCommand("_Ultraschall_set_Matrix_Editing")
  elseif element_id==tabs1.sound_marker_ping then
    if checked==true then
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_tims_chapter_ping", "Value", "1", ini_file)
    else
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_tims_chapter_ping", "Value", "0", ini_file)
    end
    ultraschall.RunCommand("_Ultraschall_Tims_Ping_Feature")
  elseif element_id==tabs1.sound_ping_volume then
    ultraschall.RunCommand("_Ultraschall_Play_Sound")
  elseif element_id==tabs1.larger_marker_manager then
    if checked==true then
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_Ultraschall_GUI_largemarkermanager", "Value", "1", ini_file)
    else
      reaper.BR_Win32_WritePrivateProfileString("ultraschall_settings_Ultraschall_GUI_largemarkermanager", "Value", "0", ini_file)
    end
    ultraschall.RunCommand("_Ultraschall_Set_View_Record")
    
  -- Checkboxes in the Soundcheck Tab
  elseif element_id==tabs2.soundcheck_saveproject then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_unsaved", SoundcheckUnsaved)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_unsaved", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_preparealltracks then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_prepare_for_editing", SoundcheckTransitionRecordToStop)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_prepare_for_editing", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_48khz_check then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_samplerate", SoundcheckSamplerate)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_samplerate", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_mic_check then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_mic", SoundcheckMic)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_mic", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_overdub_check then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_overdub", SoundcheckOverdub)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_overdub", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_unknown_interface then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_changed_interface", SoundcheckChangedInterface)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_changed_interface", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_distortion_prevention then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_Bsize", SoundcheckBsize)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_Bsize", "EventIdentifier", "ultraschall-settings.ini"))
    end
  elseif element_id==tabs2.soundcheck_input_wizard then
    if checked==true then
      StartSoundcheck("ultraschall_soundcheck_inputs", SoundcheckInputs)
    else
      ultraschall.EventManager_RemoveEvent(ultraschall.GetUSExternalState("ultraschall_soundcheck_inputs", "EventIdentifier", "ultraschall-settings.ini"))
    end
    
  end
end
reagirl.Label_Underline=1 -- sets underline for clickable labels to off
-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes
settings_logo=reagirl.Image_Add(0, 0, 65, 42, gfx_path.."settings_logo.png", "Settings-Logo", "Settings-Logo.", nil, nil)
reagirl.Image_SetDecorative(settings_logo, true)
reagirl.UI_Element_GetSetSticky(settings_logo, true, false, true)

settings_header=reagirl.Image_Add(77, 12, 109, 18, gfx_path.."headertxt_settings.png", "Settings-Logo", "Settings-Logo.", nil, nil)
reagirl.Image_SetDecorative(settings_header, true)
reagirl.UI_Element_GetSetSticky(settings_header, true, false, true)

button_help = reagirl.Button_Add(-86, 12, 35, 5, "Help", "Opens the help page in the manual.", button_run_function, "button_help", mode, width, height)
reagirl.Button_SetRadius(button_help, 10)
reagirl.UI_Element_GetSetSticky(button_help, true, false, true)

decor_rectangle_guid = reagirl.DecorRectangle_Add(0, 0, 1500, 41, 0, 37, 37, 37)
reagirl.UI_Element_GetSetSticky(decor_rectangle_guid, true, false, true)
reagirl.NextLine()

tabs_guid = reagirl.Tabs_Add(10, 55, 650, 100, "Tabs.", "Tabs.", {"General", "Soundcheck", "Devices"}, 1, tab_run_function, "tab")

-- Settings-Tab
tabs1={}
function Build_Settings_General(x, y, width)
  -- Adds all ui-elements for the general-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.general = reagirl.Label_Add(nil, nil, "General", "General Settings.", false, label_run_function, "label_general", nil)
  reagirl.NextLine()
  tabs1.startscreen = reagirl.Checkbox_Add(nil, nil, "Show the Startscreen at startup", "Shows the startscreen, when you start Ultraschall.", true, checkbox_run_function, "checkbox_show_startscreen" )
  reagirl.Checkbox_LinkToIniValue(tabs1.startscreen, ini_file, "ultraschall_settings_updatecheck", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.update = reagirl.Checkbox_Add(nil, nil, "Check for updates", "Checks at startup, whether a new update is available.", true, checkbox_run_function, "checkbox_check_update" )
  reagirl.Checkbox_LinkToIniValue(tabs1.update, ini_file, "ultraschall_settings_startsceen", "Value", "0", "1", "1", true)
  if width~=nil then width=tabs1.startscreen end
  reagirl.Label_AutoBackdrop(tabs1.general, tabs1.update, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Recording(x, y, width)
  -- Adds all ui-elements for the recording-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.recording = reagirl.Label_Add(nil, nil, "Recording", "Settings for recording.", false, label_run_function, "label_recording", nil)
  reagirl.NextLine()
  tabs1.rec_safemode= reagirl.Checkbox_Add(nil, nil, "Safe-mode when recording", "When checked, it shows a message that warns you from (accidentally) aborting recording when hitting space/enter during recording.\nWhen unchecked, recording immediately stops/pauses.", true, checkbox_run_function, "checkbox_rec_safemode" )
  reagirl.Checkbox_LinkToIniValue(tabs1.rec_safemode, ini_file, "ultraschall_settings_recording_safemode", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.replace_rec_preview = reagirl.Checkbox_Add(nil, nil, "Preview in replace recording", "This turns preview on for replace recording(punch in).", true, checkbox_run_function, "checkbox_replace_rec_preview" )
  reagirl.Checkbox_LinkToIniValue(tabs1.replace_rec_preview, ini_file, "ultraschall_settings_replace_recording_preview", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.replace_rec_tape_mode = reagirl.Checkbox_Add(nil, nil, "Tape Mode Recording", "This toggles tape-mode for new recordings, which records over old recordings if recording is not started at end of the project. \n\nTurn off to get old takes-mode(Ultraschall 5.1.1 and earlier).", true, checkbox_run_function, "checkbox_replace_rec_tapemode" )
  reagirl.Checkbox_LinkToIniValue(tabs1.replace_rec_tape_mode, ini_file, "ultraschall_settings_tape_mode_recording", "Value", "0", "1", "1", true)
  reagirl.NextLine(5)
  tabs1.preroll_time_recording = reagirl.Slider_Add(nil, nil, 500, "Preroll time recording:", 140, "Set the time in seconds by which the program jumps back for a preroll recording.", "Seconds", 1, 10.0, 1, 5, 5, slider_run_func, "slider_preroll_time_recording")
  reagirl.Slider_LinkToIniValue(tabs1.preroll_time_recording, ini_file, "ultraschall_settings_preroll_recording", "Value", 1.7, true, nil)
  if width~=nil then width=tabs1.preroll_time_recording end
  reagirl.Label_AutoBackdrop(tabs1.recording, tabs1.preroll_time_recording, width)--, tabs1.preroll_time_recording)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_PlayBack(x, y, width)
  -- Adds all ui-elements for the playback-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.playback = reagirl.Label_Add(nil, nil, "Playback", "Settings for playback.", false, label_run_function, "label_playback", nil)
  reagirl.NextLine()
  tabs1.shuttle_stepper_speed = reagirl.Slider_Add(nil, nil, 500, "Shuttle Stepper Speed:", 140, "Sets the speed of stepwise playback by shuttle (Shift+J and Shift+L) in seconds.", "Seconds", 0.1, 8, 0.1, 0.2, 0.2, slider_run_func, "slider_shuttle_stepper_speed ")
  reagirl.Slider_LinkToIniValue(tabs1.shuttle_stepper_speed, ini_file, "ultraschall_settings_shuttle_step_speed", "Value", 0.2, true, nil)
  if width~=nil then width=tabs1.preroll_time_recording end
  reagirl.Label_AutoBackdrop(tabs1.playback, tabs1.shuttle_stepper_speed, width)--tabs1.preroll_time_recording)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Editing(x, y, width)
  -- Adds all ui-elements for the editing-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)

  tabs1.editing= reagirl.Label_Add(nil, nil, "Editing general", "Settings for editing.", false, label_run_function, "label_editing", nil)
  reagirl.NextLine()
  tabs1.preroll_time_preview = reagirl.Slider_Add(nil, nil, 500, "Preroll time preview:", 140, "Set the time in seconds by which the program jumps back when the \"p\" key is used to preview cuts.", "Seconds", 0.2, 6.0, 0.1, 1.8, 1.8, slider_run_func, "slider_preroll_time_preview")
  reagirl.Slider_LinkToIniValue(tabs1.preroll_time_preview, ini_file, "ultraschall_settings_preroll", "Value", 1.7, true, nil)
  reagirl.Label_AutoBackdrop(tabs1.editing, tabs1.preroll_time_preview, width)
  reagirl.NextLine(5)
  tabs1.ripple_cut = reagirl.Label_Add(nil, nil, "Ripple Cut", "Settings for editing.", false, label_run_function, "label_editing", nil)
  reagirl.NextLine()
  tabs1.ripple_cut_preroll_review = reagirl.Slider_Add(nil, nil, 500, "Preroll edit-review:", 140, "Set the time in seconds by which the playback jumps back when a ripple-cut is made to review the edit.", "Seconds", 0.2, 6.0, 0.1, 1.8, 1.8, slider_run_func, "ripple_cut_preroll_review")
  reagirl.Slider_LinkToIniValue(tabs1.ripple_cut_preroll_review, ini_file, "ultraschall_settings_ripplecut_preroll", "Value", 1.7, true, nil)
  reagirl.NextLine()
  tabs1.ripple_cut_review = reagirl.Checkbox_Add(nil, nil, "Review Ripple-Cut-edits", "Review the edit of a ripple-cut after the edit is made. Set the time with the Preroll time preview-slider.", true, checkbox_run_function, "checkbox_ripple_cut_review" )
  reagirl.Checkbox_LinkToIniValue(tabs1.ripple_cut_review, ini_file, "ultraschall_settings_ripplecut_review_edit", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.ripple_cut_ignores_locked_tracks = reagirl.Checkbox_Add(nil, nil, "Ripple-Cut ignores locked tracks", "Ripple cut will ignore locked tracks when set. When unset, Ripple-Cut will cut locked tracks as well.", false, checkbox_run_function, "checkbox_ripple_cut_ignores_locked_tracks" )
  reagirl.Checkbox_LinkToIniValue(tabs1.ripple_cut_ignores_locked_tracks, ini_file, "ultraschall_settings_ripplecut_obey_locked", "Value", "0", "1", "1", true)
  if width~=nil then width=tabs1.preroll_time_preview end
  reagirl.Label_AutoBackdrop(tabs1.ripple_cut, tabs1.ripple_cut_ignores_locked_tracks, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Misc(x, y, width)
  -- Adds all ui-elements for the editing-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)

  tabs1.work_counter= reagirl.Label_Add(nil, nil, "Work Counter", "Settings for the work-counter of a project.", false, label_run_function, "label_work_counter", nil)
  reagirl.NextLine()
  tabs1.work_counter_checkbox = reagirl.Checkbox_Add(nil, nil, "Count worktime also, when Reaper isn't in focus", "Enabled will count the work-time of a project permanently.\n\nDisable, if you want to count only, when Reaper is in focus.\n\nYou can show the current workcounter-time in the Ultraclock by clicking the wheel-symbol.", false, checkbox_run_function, "checkbox_work_counter_always" )
  reagirl.Checkbox_LinkToIniValue(tabs1.work_counter_checkbox, ini_file, "ultraschall_settings_work_counter_when_reaperfocus", "Value", "0", "1", "1", true)
  if width~=nil then width=tabs1.preroll_time_preview end
  reagirl.Label_AutoBackdrop(tabs1.work_counter, tabs1.work_counter_checkbox, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Soundboard(x, y, width)
  -- Adds all ui-elements for the soundboard-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.soundboard = reagirl.Label_Add(nil, nil, "Soundboard", "Settings for the soundboard.", false, label_run_function, "label_soundboard", nil)
  reagirl.NextLine()
  tabs1.soundboard_duck_rec = reagirl.Checkbox_Add(nil, nil, "Soundboard ducking during recording", "Activate ducking of the soundboard during recording. If anyone starts to talk to a microphone, the Soundboard track will be gently reduced in volume.", true, checkbox_run_function, "checkbox_soundboard_duck_rec" )
  reagirl.Checkbox_LinkToIniValue(tabs1.soundboard_duck_rec, ini_file, "ultraschall_settings_soundboard_ducking", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.soundboard_duck_editing = reagirl.Checkbox_Add(nil, nil, "Soundboard ducking during editing", "Activate ducking of the soundboard during editing. If anyone starts to talk to a microphone, the Soundboard track will be gently reduced in volume.", true, checkbox_run_function, "checkbox_soundboard_duck_editing")
  reagirl.Checkbox_LinkToIniValue(tabs1.soundboard_duck_editing, ini_file, "ultraschall_settings_soundboard_ducking_editing", "Value", "0", "1", "1", true)
  reagirl.NextLine(5)
  tabs1.soundboard_preshow_music_mix = reagirl.Slider_Add(nil, nil, 500, "Preshow music mix:", 140, "Play some music from the Ultraschall-Soundboard in your preshow to entertain the livestream. If you choose the preshow routing preset, you can mix none (0) some or all (1) of the music to your headphones mix.", "%", 0, 100, 1, 30, 30, slider_run_func, "slider_soundboard_preshow_music_mix")
  reagirl.Slider_LinkToIniValue(tabs1.soundboard_preshow_music_mix, ini_file, "ultraschall_settings_preshow_mix", "Value", 30, true, 0.01)
  if width~=nil then width=tabs1.soundboard_preshow_music_mix end
  reagirl.Label_AutoBackdrop(tabs1.soundboard, tabs1.soundboard_preshow_music_mix, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Helpersounds(x, y, width)
  -- Adds all ui-elements for the helper sounds-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.helpersounds = reagirl.Label_Add(nil, nil, "Helpersounds", "Settings for helper sounds.", false, label_run_function, "label_helpersounds", nil)
  reagirl.NextLine()
  tabs1.sound_marker_ping = reagirl.Checkbox_Add(nil, nil, "Marker sound during playback", "Play a sound if the playcursor passes through a marker.", false, checkbox_run_function, "checkbox_sound_marker_ping")
  reagirl.Checkbox_LinkToIniValue(tabs1.sound_marker_ping, ini_file, "ultraschall_settings_tims_chapter_ping", "Value", "0", "1", "0", true)
  reagirl.NextLine()
  tabs1.sound_when_render_finishes = reagirl.Checkbox_Add(nil, nil, "Play sound when render is finished/aborted", "When checked, it plays a sound when render is finished/aborted.", false, checkbox_run_function, "checkbox_sound_when_render_finishes")
  reagirl.Checkbox_LinkToIniValue(tabs1.sound_when_render_finishes, ini_file, "ultraschall_settings_render_finished_ping", "Value", "0", "1", "0", true)
  reagirl.NextLine(5)
  tabs1.sound_ping_volume = reagirl.Slider_Add(nil, nil, 500, "Volume of ping-sounds:", 140, "Set volume of the ping sounds.", "%", 0, 100, 1, 50, 50, slider_run_func, "slider_sound_ping_volume")
  reagirl.Slider_LinkToIniValue(tabs1.sound_ping_volume, ini_file, "ultraschall_settings_tims_chapter_ping_volume", "Value", 50, true, 0.01)
  if width~=nil then width=tabs1.sound_ping_volume end
  reagirl.Label_AutoBackdrop(tabs1.helpersounds, tabs1.sound_ping_volume, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_Soundcheck(x, y, width)
  -- Adds all ui-elements for the soundcheck-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.soundcheck = reagirl.Label_Add(nil, nil, "Soundcheck", "Settings for the soundcheck.", false, label_run_function, "label_soundcheck", nil)
  reagirl.NextLine()
  tabs1.soundcheck_graceful = reagirl.Checkbox_Add(nil, nil, "Graceful soundcheck", "Set all open soundcheck warnings to the _ignore_ state by closing the soundcheck window.", true, checkbox_run_function, "checkbox_soundcheck_graceful")
  reagirl.Checkbox_LinkToIniValue(tabs1.soundcheck_graceful, ini_file, "ultraschall_settings_graceful_soundcheck", "Value", "0", "1", "1", true)
  if width~=nil then width=tabs1.soundcheck_graceful end
  reagirl.Label_AutoBackdrop(tabs1.soundcheck, tabs1.soundcheck_graceful, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_VisualSettings(x, y, width)
  -- Adds all ui-elements for the visual settings-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.visual_settings = reagirl.Label_Add(nil, nil, "Visual settings", "Settings for visual appearance/view.", false, label_run_function, "label_visual_settings", nil)
  reagirl.NextLine()
  tabs1.autocolor_tracks = reagirl.Checkbox_Add(nil, nil, "Autocolor tracks - Sonic Rainboom", "New tracks get a unique color. Local tracks start with blue, remote tracks (StudioLink) will be orange and the Soundboard grey.", true, checkbox_run_function, "checkbox_autocolor_tracks" )
  reagirl.Checkbox_LinkToIniValue(tabs1.autocolor_tracks, ini_file, "ultraschall_settings_Ultraschall_GUI_setmagiccolor", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.autoarrange_trackheight = reagirl.Checkbox_Add(nil, nil, "Autoarrange track height", "Zoom or shrink tracks to fit the arrangeview if new tracks or envelopes are added.", true, checkbox_run_function, "checkbox_autoarrange_trackheight")
  reagirl.Checkbox_LinkToIniValue(tabs1.autoarrange_trackheight, ini_file, "ultraschall_settings_Ultraschall_GUI_setmagictrackheight", "Value", "0", "1", "1", true)
  reagirl.NextLine()
  tabs1.larger_marker_manager = reagirl.Checkbox_Add(nil, nil, "Large marker manager", "Give way more space to the marker manager on the right.", false, checkbox_run_function, "checkbox_larger_marker_manager")
  reagirl.Checkbox_LinkToIniValue(tabs1.larger_marker_manager, ini_file, "ultraschall_settings_Ultraschall_GUI_largemarkermanager", "Value", "0", "1", "0", true)
  reagirl.NextLine()
  tabs1.zoom_out_sensitivity = reagirl.Slider_Add(nil, nil, 500, "Zoom Out sensitivity:", 140, "Set the sensitivity of zooming out, when zoomed further out of the project.", "", 0.4, 8, 0.1, 0.4, 0.4, slider_run_func, "slider_zoom_out_sensitivity")
  reagirl.Slider_LinkToIniValue(tabs1.zoom_out_sensitivity, ini_file, "ultraschall_settings_Zoom_Sensitivity", "Value", 0.4, true, nil)
  if width~=nil then width=tabs1.zoom_out_sensitivity end
  reagirl.Label_AutoBackdrop(tabs1.visual_settings, tabs1.zoom_out_sensitivity, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

function Build_Settings_MagicRouting(x, y, width)
  -- Adds all ui-elements for the magic routing-page in the settings-tab
  -- If you want to add/edit ui-elements in this page, alter this function
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.magic_routing = reagirl.Label_Add(nil, nil, "Magic Routing", "Settings for Magic Routing.", false, label_run_function, "label_magic_routing", nil)
  reagirl.NextLine()
  tabs1.magic_routing_always_start_startup = reagirl.Checkbox_Add(nil, nil, "Always start MagicRouting at startup", "When checked, always start MagicRouting at Ultraschall startup. When unchecked, it will retain at startup the last MagicRouting-state from last time closing Ultraschall.", true, checkbox_run_function, "checkbox_magic_routing_always_start_startup")
  reagirl.Checkbox_LinkToIniValue(tabs1.magic_routing_always_start_startup, ini_file, "ultraschall_settings_magic_routing_always_on", "Value", "0", "1", "1", true)
  if width~=nil then width=tabs1.magic_routing_always_start_startup end
  reagirl.Label_AutoBackdrop(tabs1.magic_routing, tabs1.magic_routing_always_start_startup, width)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end


function concat_tables(tab1, tab2)
  -- this function concatenates two tables. You can ignore this function mostly, as it is used mostly by label_run_function()
  local tab={}
  for k,v in pairs(tab1) do
    tab[k]=v
  end
  
  for k,v in pairs(tab2) do
    tab[k]=v
  end
  return tab
end

function Build_Page_Labels(x, y)
  -- adds all labels of the indes for the settings-tab
  -- You can change the order beginning from the reagirl.NextLine()-function to the lines like "page_general=tabs1.page_general"
  local tabs1={}
  reagirl.AutoPosition_SetNextUIElementAtPosition(x, y)
  tabs1.page_overview = reagirl.Label_Add(nil, nil, "Settings", "Settings.", false, label_run_function, "label_overview_page", nil)
  
  reagirl.NextLine()
  tabs1.page_general  = reagirl.Label_Add(nil, nil, "General", "General settings-page.", true, label_run_function, "label_general_page", nil)
  page_general=tabs1.page_general
  
  reagirl.NextLine()
  tabs1.page_rec      = reagirl.Label_Add(nil, nil, "Recording", "Recording settings-page.", true, label_run_function, "label_recording_page", nil)
  page_rec=tabs1.page_rec
  
  reagirl.NextLine()
  tabs1.page_playback = reagirl.Label_Add(nil, nil, "Playback", "Playback settings-page.", true, label_run_function, "label_playback_page", nil)
  page_playback=tabs1.page_playback
  
  reagirl.NextLine()
  tabs1.page_editing = reagirl.Label_Add(nil, nil, "Editing", "Editing settings-page.", true, label_run_function, "label_editing_page", nil)
  page_editing=tabs1.page_editing
  
  reagirl.NextLine()
  tabs1.page_magicrouting = reagirl.Label_Add(nil, nil, "Magic Routing", "Magic Routing settings-page.", true, label_run_function, "label_magic_routing_page", nil)
  page_magicrouting=tabs1.page_magicrouting
  
  reagirl.NextLine()
  tabs1.page_visual_settings = reagirl.Label_Add(nil, nil, "Visual Settings", "Visual settings-page.", true, label_run_function, "label_visual_settings_page", nil)
  page_visual_settings=tabs1.page_visual_settings
  
  reagirl.NextLine()
  tabs1.page_soundboard = reagirl.Label_Add(nil, nil, "Soundboard", "Soundboard settings-page.", true, label_run_function, "label_soundboard_page", nil)
  page_soundboard=tabs1.page_soundboard
  
  reagirl.NextLine()
  tabs1.page_helper_sounds = reagirl.Label_Add(nil, nil, "Helper Sounds", "Helper sounds settings-page.", true, label_run_function, "label_helper_sounds_page", nil)
  page_helper_sounds=tabs1.page_helper_sounds
  
  reagirl.NextLine()
  tabs1.page_soundcheck= reagirl.Label_Add(nil, nil, "Soundcheck", "Soundcheck settings-page.", true, label_run_function, "label_soundcheck_page", nil)
  page_soundcheck=tabs1.page_soundcheck
  
  reagirl.NextLine()
  tabs1.page_misc= reagirl.Label_Add(nil, nil, "Miscellaneous", "Miscellaneous settings-page.", true, label_run_function, "label_soundcheck_page", nil)
  page_misc=tabs1.page_misc
  
  reagirl.Label_AutoBackdrop(tabs1.page_overview, tabs1.page_misc, tabs1.page_helper_sounds)
  reagirl.UI_Element_SetHiddenFromTable(tabs1, false)
  return tabs1
end

-- add all ui-elements for the Settings-Tab
pages=Build_Page_Labels(30,98)
tab_general     = Build_Settings_General(140, 98, nil)
tab_recording   = Build_Settings_Recording(140, 98, nil)
tab_playback    = Build_Settings_PlayBack(140, 98, nil)
tab_editing     = Build_Settings_Editing(140, 98, nil)
tab_mrouting    = Build_Settings_MagicRouting(140, 98, nil)
tab_visuals     = Build_Settings_VisualSettings(140, 98, nil)
tab_soundboard  = Build_Settings_Soundboard(140, 98, nil)
tab_helpersound = Build_Settings_Helpersounds(140, 98, nil)
tab_soundcheck  = Build_Settings_Soundcheck(140, 98, nil)
tab_misc        = Build_Settings_Misc(140, 98, nil)

-- set the general-page as first tab to see
label_run_function(page_general)


-- add all ui-elements for the Soundcheck-Tab
tabs2={}
reagirl.AutoPosition_SetNextUIElementAtPosition(30, 98)
tabs2.soundchecks = reagirl.Label_Add(nil, nil, "Available Soundchecks", "Soundchecks.", false, label_run_function, "label_soundchecks", nil)

reagirl.NextLine()
tabs2.soundcheck_saveproject = reagirl.Checkbox_Add(nil, nil, "Save project before recording", "The project should be saved before recording starts. Ignoring this can lead to difficulties in finding your records or even to loss of data.", true, checkbox_run_function, "checkbox_soundcheck_save_project")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_saveproject, ini_file, "ultraschall_soundcheck_unsaved", "Value", "0", "1", "1", true)
tabs2.button_help = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for save project before recording.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help, true, "Value", tabs2.soundcheck_saveproject)

reagirl.NextLine()
tabs2.soundcheck_preparealltracks = reagirl.Checkbox_Add(nil, nil, "Prepare all tracks for editing", "Reminder to prepare all tracks for editing after a recording is complete. This starts a series of actions to switch the app from recording to editing behavior.", true, checkbox_run_function, "checkbox_soundcheck_prepare_all_tracks_for_editing")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_preparealltracks, ini_file, "ultraschall_soundcheck_prepare_for_editing", "Value", "0", "1", "1", true)
tabs2.button_help2 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for Prepare all tracks for editing.", button_run_function_soundcheck_help, "button_help2", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help2, true, "Value", tabs2.soundcheck_preparealltracks )

reagirl.NextLine()
tabs2.soundcheck_48khz_check = reagirl.Checkbox_Add(nil, nil, "Check for 48 KHz sample rate", "The samplerate of all devices must be set to 48.000 Hz if you want to use StudioLink or StudioLink OnAir.", true, checkbox_run_function, "checkbox_soundcheck_48khz_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_48khz_check, ini_file, "ultraschall_soundcheck_samplerate", "Value", "0", "1", "1", true)
tabs2.button_help3 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for 48 kilohertz sample rate.", button_run_function_soundcheck_help, "button_help3", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help3, true, "Value", tabs2.soundcheck_48khz_check)

reagirl.NextLine()
tabs2.soundcheck_mic_check = reagirl.Checkbox_Add(nil, nil, "Check if internal mic is selected", "Prevents you from accidentally recording with the built-in microphone instead of using your dedicated sound interface.", true, checkbox_run_function, "checkbox_soundcheck_mic_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_mic_check, ini_file, "ultraschall_soundcheck_mic", "Value", "0", "1", "1", true)
tabs2.button_help4 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for check if internal mix is selected.", button_run_function_soundcheck_help, "button_help4", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help4, true, "Value", tabs2.soundcheck_mic_check)

reagirl.NextLine()
tabs2.soundcheck_overdub_check = reagirl.Checkbox_Add(nil, nil, "Start recording only at the end", "This warning appears when a recording is started in the middle of an existing project, not at the end. This would lead to overlapping takes and is usually undesirable.", true, checkbox_run_function, "checkbox_soundcheck_overdub_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_overdub_check, ini_file, "ultraschall_soundcheck_overdub", "Value", "0", "1", "1", true)
tabs2.button_help5 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for start recording only at the end.", button_run_function_soundcheck_help, "button_help5", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help5, true, "Value", tabs2.soundcheck_overdub_check)

reagirl.NextLine()
tabs2.soundcheck_unknown_interface = reagirl.Checkbox_Add(nil, nil, "Unknown sound interface check", "Watches for a change in your sound interface. This affects Magic Routing, as this will set direct monitoring accordingly in the routing. \n\nIf the interface is unknown yet, the soundcheck will ask, whether direct monitoring(plugging headphones into the audio device) is supported.", true, checkbox_run_function, "checkbox_soundcheck_unknown_interface")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_unknown_interface, ini_file, "ultraschall_soundcheck_changed_interface", "Value", "0", "1", "1", true)
tabs2.button_help6 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for unknown sound interface check.", button_run_function_soundcheck_help, "button_help6", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help6, true, "Value", tabs2.soundcheck_unknown_interface)

reagirl.NextLine()
tabs2.soundcheck_distortion_prevention = reagirl.Checkbox_Add(nil, nil, "Echo and distortion prevention", "If you use a audio device without Direct Monitoring(means, you cannot attach a headphone to it) it is important to set the right block size. \n\nA block size larger than 128 will result in latency and echo effects. A block size smaller than 32 will lead to an unstable audio stack and dropouts. \n\nWe suggest 512 for Direct Monitoring devices and 64 for devices without Direct Monitoring.", true, checkbox_run_function, "checkbox_soundcheck_distortion_prevention")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_unknown_interface, ini_file, "ultraschall_soundcheck_Bsize", "Value", "0", "1", "1", true)
tabs2.button_help7 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for Echo and distortion prevention.", button_run_function_soundcheck_help, "button_help7", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help7, true, "Value", tabs2.soundcheck_distortion_prevention)

reagirl.NextLine()
tabs2.soundcheck_input_wizard = reagirl.Checkbox_Add(nil, nil, "Input wizard", "Checks if... \na) an input of the sound interface is used multiple times and \nb) if the interchangeable mic channels of a zoom interface are used.", true, checkbox_run_function, "checkbox_soundcheck_input_wizard")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_input_wizard, ini_file, "ultraschall_soundcheck_inputs", "Value", "0", "1", "1", true)
tabs2.button_help8 = reagirl.Button_Add(250, nil, 0, 0, "?", "Help for Input wizard-check.", button_run_function_soundcheck_help, "button_help8", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help8, true, "Value", tabs2.soundcheck_input_wizard)

reagirl.NextLine(30)
tabs2.soundchecks_description = reagirl.Label_Add(320, 140, "The soundcheck checks for common mistakes and \nproblems that could happen during podcast-production.\n\nThese checks try to save you from these problems.\n\nIf you don't need a specific check, deactivate \nthe checkbox for this soundcheck.", "Soundchecks.", false, label_run_function, "label_soundchecks_description", nil)

reagirl.Label_SetBackdrop(tabs2.soundchecks, 619, 193)

-- add all ui-elements for the Devices-tab

function button_run_function_devices(element_id)
  local value=reagirl.UI_Element_GetSetExtState(element_id, false, "device")
  local value2 = tonumber(ultraschall.GetUSExternalState("ultraschall_devices", value, "ultraschall-settings.ini"))
  ultraschall.SetUSExternalState("ultraschall_devices", value, value2+2, "ultraschall-settings.ini")
end

function checkbox_run_function2(element_id)
  override_update=true
end

function Build_Devices_Tab()
  if tabs3~=nil then reagirl.UI_Element_SetHiddenFromTable(tabs3, false) end
  local tabs3={}
  
  local Found=true
  local Found_Counter=1
  Found_Devices={}
  while Found==true do
    local found_device=ultraschall.EnumerateIniFileExternalState_key("ultraschall_devices", Found_Counter, reaper.GetResourcePath().."/ultraschall-settings.ini")
    Found_Devices[#Found_Devices+1]=found_device
    Found_Counter=Found_Counter+1
    if found_device==nil then Found=false end
  end
  Found_Devices_Monitoring={}
  for i=1, Found_Counter-2 do
    Found_Devices_Monitoring[i]=tonumber(ultraschall.GetUSExternalState("ultraschall_devices", Found_Devices[i], "ultraschall-settings.ini"))
  end
  
  for i=Found_Counter-2, 1, -1 do
    if Found_Devices_Monitoring[i]>1 then table.remove(Found_Devices_Monitoring, i) table.remove(Found_Devices, i) end
  end
  
  -- next codeline for some reason, buggy with reagirl.NextLine() in ReaGirl
  --reagirl.AutoPosition_SetNextUIElementAtPosition(30, 98) 
  
  -- this line works however
  reagirl.AutoPosition_SetNextUIElementRelativeTo(tabs_guid)
  tabs3.devices = reagirl.Label_Add(nil, nil, "Used interface-devices", "Currently and previously used interface devices.", false, label_run_function, "label_devices", nil)
  reagirl.NextLine()
  tabs3.description= reagirl.Label_Add(nil, nil, "This list shows all audio interfaces you ever connected. \n\nIf you can plug a headphone to your audio interface, it supports Direct Monitoring. \n\nIf you can not connect a headphone direct into your audio interface, make sure \nto uncheck the Direct Monitoring box to get the audio routing right. \n\nYou can delete obsolete devices via the delete from list-button.", "This list shows all audio interfaces you ever connected. If you can plug a headphone to your audio interface, it supports Direct Monitoring. If you can not connect a headphone direct into your audio interface, make sure to uncheck the Direct Monitoring box to get the audio routing right. You can delete obsolete devices.", false, label_run_function, "label_soundchecks", nil)
  
  reagirl.NextLine(10)
  
  --tabs3.devices2 = reagirl.Label_Add(nil, nil, "Available devices", "Currently and previously used interface devices.", false, label_run_function, "label_devices2", nil)
  --reagirl.NextLine()
  
  for i=1, #Found_Devices do
    tabs3[("interface"..i)] = reagirl.Checkbox_Add(nil, nil, Found_Devices[i], "Device with name "..Found_Devices[i]..". Check, if direct monitoring is available(you can plug in headphones to your device) or not.", Found_Devices_Monitoring[i]==1, checkbox_run_function2, ("interface"..i))
    local retval, actual_device=reaper.GetAudioDeviceInfo("IDENT_IN")
    if actual_device==Found_Devices[i] then
       tabs3.active_device = reagirl.Label_Add(400, nil, "Active - cannot be deleted", "This currently used device can not be removed from the list.", false, label_run_function, "label_not_removable", nil)
    else
      tabs3[("interface_button"..i)] = reagirl.Button_Add(400, nil, 0, 0, "Delete from list", "Delete the interface "..Found_Devices[i].." from list.", button_run_function_devices, ("interface_button"..i), mode, width, height)
      reagirl.UI_Element_GetSetExtState(tabs3[("interface_button"..i)], true, "device", Found_Devices[i])
    end
    reagirl.Checkbox_LinkToIniValue(tabs3[("interface"..i)], ini_file, "ultraschall_devices", Found_Devices[i], "0", "1", "1", true)
    reagirl.NextLine()
    if i==#Found_Devices then 
      --reagirl.Label_AutoBackdrop(tabs3.devices, tabs3[("interface"..i)], tabs3.active_device) 
      
      last_interface=tabs3[("interface"..i)] 
      local x, y, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(last_interface, false, 0, 0)
      local x, y2, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(tabs_guid, false, 0, 0)
      y=y-y2-30
      if y<193 then y=193 end
      reagirl.Label_SetBackdrop(tabs3.devices, 619, y)
    end
  end
  reagirl.UI_Element_SetHiddenFromTable(tabs3, false)
  return tabs3
end

tabs3=Build_Devices_Tab()

-- associate tabs with the ui-elements stored in the tables
reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
reagirl.Tabs_SetUIElementsForTab(tabs_guid, 2, tabs2)
reagirl.Tabs_SetUIElementsForTab(tabs_guid, 3, tabs3)

reagirl.Gui_Label_Background_Width(509)

-- 4. open the gui
reagirl.Gui_Open("Ultraschall Settings", false, "Ultraschall Settings", "Set your preferences for Ultraschall.", 670, 370, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
function main()
  local _,_,_,modified=reaper.JS_File_Stat(reaper.GetResourcePath().."/ultraschall-settings.ini")
  local retval, actual_device=reaper.GetAudioDeviceInfo("IDENT_IN")
  if modified~=old_modified_ini_file or actual_device~=old_actual_device then 
    if override_update==nil then
      horizontal_scrolloffs, vertical_scrolloffs = reagirl.Window_GetScrollOffset()
      tabs3=Build_Devices_Tab() 
      reagirl.Tabs_SetUIElementsForTab(tabs_guid, 3, tabs3)
      tab_run_function(tabs_guid, 3) 
      reagirl.Gui_ForceRefresh() 
    end
  end
  override_update=nil
  old_modified_ini_file=modified
  old_actual_device=actual_device
  
  page=reaper.GetExtState("ultraschall", "settings_page_switch")
  if page~="" then
    if page=="page_general" then
      label_run_function(page_general)
    elseif page=="page_rec" then
      label_run_function(page_rec)
    elseif page=="page_playback" then
      label_run_function(page_playback)
    elseif page=="page_editing" then
      label_run_function(page_editing)
    elseif page=="page_magicrouting" then
      label_run_function(page_magicrouting)
    elseif page=="page_visual_settings" then
      label_run_function(page_visual_settings)
    elseif page=="page_soundboard" then
      label_run_function(page_soundboard)
    elseif page=="page_helper_sounds" then
      label_run_function(page_helper_sounds)
    elseif page=="page_soundcheck" then
      label_run_function(page_soundcheck)
    elseif page=="page_misc" then
      label_run_function(page_misc)
    end
  end
  reaper.SetExtState("ultraschall", "settings_page_switch", "", false)
  
  reagirl.Gui_Manage()

  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()

