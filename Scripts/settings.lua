-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
dofile(reaper.GetResourcePath().."/Scripts/ultraschall_soundcheck_functions.lua")

gfx_path=reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/"
ini_file=reaper.GetResourcePath().."/ultraschall-settings.ini"

-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
-- check for required version; alter the version-number if necessary
if reagirl.GetVersion()<1.4 then reaper.MB("Needs ReaGirl v"..(1.4).." to run", "Too old version", 0) return false end

-- 1. add the run-functions for the ui-elements
function button_run_function(element_id)
  if element_id==button_help then
    reaper.CF_ShellExecute("https://ultraschall.github.io/ultraschall-manual/en/docs/adaption#ultraschall-settings")
  end
end

function button_run_function_soundcheck_help(element_id)
  local x,y=reaper.GetMousePosition()
  x=x+20*reagirl.Window_GetCurrentScale()
  y=y+20*reagirl.Window_GetCurrentScale()
  element_id=reagirl.UI_Element_GetSetExtState(element_id, false, "Value", tabs2.soundcheck_saveproject)
  reaper.TrackCtl_SetToolTip(reagirl.UI_Element_GetSetMeaningOfUIElement(element_id, false, ""), x, y, true)
end

function checkbox_run_function(element_id, checked)
  -- Settings-Tab
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
  
  -- Soundcheck Tab
  elseif element_id==tabs2.soundcheck_saveproject then
    if checked==true then
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_unsaved", 1, 0, false, false, SoundcheckUnsaved, {"_Ultraschall_Soundcheck_Startgui,0"})
      ultraschall.SetUSExternalState("ultraschall_soundcheck_unsaved", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_unsaved", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_preparealltracks then
    if checked==true then
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_prepare_for_editing", 1, 0, false, false, SoundcheckTransitionRecordToStop, {"_Ultraschall_Soundcheck_Startgui,0"})
      ultraschall.SetUSExternalState("ultraschall_soundcheck_prepare_for_editing", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_prepare_for_editing", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_48khz_check then
    if checked==true then
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_samplerate", 1, 0, false, false, SoundcheckSamplerate, {"_Ultraschall_Soundcheck_Startgui,0"})
      ultraschall.SetUSExternalState("ultraschall_soundcheck_samplerate", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_samplerate", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_mic_check then
    if checked==true then
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_mic", 1, 0, false, false, SoundcheckMic, {"_Ultraschall_Soundcheck_Startgui,0"})
      ultraschall.SetUSExternalState("ultraschall_soundcheck_mic", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_mic", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_overdub_check then
    if checked==true then
      local event_paused = toboolean(ultraschall.GetUSExternalState("ultraschall_soundcheck_overdub", "EventPaused", "ultraschall-settings.ini"))
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_overdub", 1, 0, false, event_paused, SoundcheckOverdub, {"_Ultraschall_Soundcheck_Startgui,0"})
      
      ultraschall.SetUSExternalState("ultraschall_soundcheck_overdub", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_overdub", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_unknown_interface then
    if checked==true then
      local event_paused = toboolean(ultraschall.GetUSExternalState("ultraschall_soundcheck_changed_interface", "EventPaused", "ultraschall-settings.ini"))
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_changed_interface", 1, 0, false, event_paused, SoundcheckChangedInterface, {"_Ultraschall_Soundcheck_Startgui,0"})
      
      ultraschall.SetUSExternalState("ultraschall_soundcheck_changed_interface", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_changed_interface", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_distortion_prevention then
    if checked==true then
      local event_paused = toboolean(ultraschall.GetUSExternalState("ultraschall_soundcheck_Bsize", "EventPaused", "ultraschall-settings.ini"))
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_Bsize", 1, 0, false, event_paused, SoundcheckBsize, {"_Ultraschall_Soundcheck_Startgui,0"})
      
      ultraschall.SetUSExternalState("ultraschall_soundcheck_Bsize", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_Bsize", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
  elseif element_id==tabs2.soundcheck_input_wizard then
    if checked==true then
      local event_paused = toboolean(ultraschall.GetUSExternalState("ultraschall_soundcheck_inputs", "EventPaused", "ultraschall-settings.ini"))
      local event_identifier = ultraschall.EventManager_AddEvent("ultraschall_soundcheck_inputs", 1, 0, false, event_paused, SoundcheckInputs, {"_Ultraschall_Soundcheck_Startgui,0"})
      
      ultraschall.SetUSExternalState("ultraschall_soundcheck_inputs", "EventIdentifier", event_identifier, "ultraschall-settings.ini")
    else
      local event_identifier = ultraschall.GetUSExternalState("ultraschall_soundcheck_inputs", "EventIdentifier", "ultraschall-settings.ini")
      local retval = ultraschall.EventManager_RemoveEvent(event_identifier)
    end
    
  end
end

-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes
reagirl.Image_Add(0, 0, 65, 42, gfx_path.."settings_logo.png", "Settings-Logo", "Settings-Logo.", nil, nil)
reagirl.Image_Add(77, 12, 109, 18, gfx_path.."headertxt_settings.png", "Settings-Logo", "Settings-Logo.", nil, nil)
button_help = reagirl.Button_Add(300, 12, 10, 0, "Help", "Opens the help page in the manual.", button_run_function, "button_help", mode, width, height)
reagirl.Button_SetRadius(button_help, 6)

decor_rectangle_guid = reagirl.DecorRectangle_Add(0, 0, 1500, 41, 0, 37, 37, 37)
reagirl.NextLine()

tabs_guid = reagirl.Tabs_Add(10, 55, nil, nil, "Tabs.", "Tabs.", {"General", "Soundcheck", "Devices"}, 1, tab_run_func, "tab")

-- Settings-Tab
tabs1={}
reagirl.AutoPosition_SetNextUIElementRelativeTo(tabs_guid)
tabs1.general = reagirl.Label_Add(nil, nil, "General", "General Settings.", false, label_run_function, "label_general", nil)
reagirl.NextLine()
tabs1.startscreen = reagirl.Checkbox_Add(nil, nil, "Show the Startscreen at startup", "Shows the startscreen, when you start Ultraschall.", true, checkbox_run_function, "checkbox_show_startscreen" )
reagirl.Checkbox_LinkToIniValue(tabs1.startscreen, ini_file, "ultraschall_settings_updatecheck", "Value", "0", "1", "1", true)
reagirl.NextLine()
tabs1.update = reagirl.Checkbox_Add(nil, nil, "Check for updates", "Checks at startup, whether a new update is available.", true, checkbox_run_function, "checkbox_check_update" )
reagirl.Checkbox_LinkToIniValue(tabs1.update, ini_file, "ultraschall_settings_startsceen", "Value", "0", "1", "1", true)
reagirl.Label_AutoBackdrop(tabs1.general, tabs1.update)

reagirl.NextLine(10)
tabs1.recording = reagirl.Label_Add(nil, nil, "Recording", "Settings for recording.", false, label_run_function, "label_recording", nil)
reagirl.NextLine()
tabs1.rec_safemode= reagirl.Checkbox_Add(nil, nil, "Safe-mode when recording", "When checked, it shows a message that warns you from (accidentally) aborting recording when hitting space/enter during recording.\nWhen unchecked, recording immediately stops/pauses.", true, checkbox_run_function, "checkbox_rec_safemode" )
reagirl.Checkbox_LinkToIniValue(tabs1.rec_safemode, ini_file, "ultraschall_settings_recording_safemode", "Value", "0", "1", "1", true)
reagirl.NextLine()
tabs1.replace_rec_preview = reagirl.Checkbox_Add(nil, nil, "Preview in replace recording", "This turns preview on for replace recording(punch in).", true, checkbox_run_function, "checkbox_replace_rec_preview" )
reagirl.Checkbox_LinkToIniValue(tabs1.replace_rec_preview, ini_file, "ultraschall_settings_replace_recording_preview", "Value", "0", "1", "1", true)
reagirl.NextLine()
tabs1.replace_rec_tape_mode = reagirl.Checkbox_Add(nil, nil, "Tape Mode Recording", "This turns tape-mode for new recordings, which records over old recordings if recording is not started at end of the project. \n\nTurn off to get old takes-mode(Ultraschall 5.1.1 and earlier).", true, checkbox_run_function, "checkbox_replace_rec_tapemode" )
reagirl.Checkbox_LinkToIniValue(tabs1.replace_rec_tape_mode, ini_file, "ultraschall_settings_tape_mode_recording", "Value", "0", "1", "1", true)
reagirl.NextLine(5)
tabs1.preroll_time_recording = reagirl.Slider_Add(nil, nil, 300, "Preroll time recording:", 140, "Set the time in seconds by which the program jumps back for a preroll recording.", "Seconds", 1, 10.0, 1, 5, 5, slider_run_func, "slider_preroll_time_recording")
reagirl.Slider_LinkToIniValue(tabs1.preroll_time_recording, ini_file, "ultraschall_settings_preroll_recording", "Value", 1.7, true, nil)
reagirl.Label_AutoBackdrop(tabs1.recording, tabs1.preroll_time_recording)--, tabs1.preroll_time_recording)


--x, y, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(tabs1.recording, false, 0, 0)
--reagirl.AutoPosition_SetNextUIElementAtPosition(x+330, y)
reagirl.NextLine(10)
tabs1.playback = reagirl.Label_Add(nil, nil, "Playback", "Settings for playback.", false, label_run_function, "label_playback", nil)
reagirl.NextLine()
tabs1.shuttle_stepper_speed = reagirl.Slider_Add(nil, nil, 300, "Shuttle Stepper Speed:", 140, "Sets the speed of stepwise playback by shuttle (Shift+J and Shift+L) in seconds.", "Seconds", 0.1, 8, 0.1, 0.2, 0.2, slider_run_func, "slider_shuttle_stepper_speed ")
reagirl.Slider_LinkToIniValue(tabs1.shuttle_stepper_speed, ini_file, "ultraschall_settings_shuttle_step_speed", "Value", 0.2, true, nil)
reagirl.Label_AutoBackdrop(tabs1.playback, tabs1.shuttle_stepper_speed)--tabs1.preroll_time_recording)


--_, y2, actual_x, actual_y = reagirl.UI_Element_GetSetPosition(tabs1.preroll_time_recording, false, 0, 0)
--reagirl.AutoPosition_SetNextUIElementAtPosition(x, y2+30)
reagirl.NextLine(10)
tabs1.editing= reagirl.Label_Add(nil, nil, "Editing", "Settings for editing.", false, label_run_function, "label_editing", nil)
reagirl.NextLine()
tabs1.preroll_time_preview = reagirl.Slider_Add(nil, nil, 300, "Preroll time preview:", 140, "Set the time in seconds by which the program jumps back when the \"p\" key is used to preview cuts.", "Seconds", 0.2, 6.0, 0.1, 1.8, 1.8, slider_run_func, "slider_preroll_time_preview")
reagirl.Slider_LinkToIniValue(tabs1.preroll_time_preview, ini_file, "ultraschall_settings_preroll", "Value", 1.7, true, nil)
reagirl.NextLine()
tabs1.ripple_cut_review = reagirl.Checkbox_Add(nil, nil, "Review Ripple-Cut-edits", "Review the edit of a ripple-cut after the edit is made. Set the time with the Preroll time preview-slider.", true, checkbox_run_function, "checkbox_ripple_cut_review" )
reagirl.Checkbox_LinkToIniValue(tabs1.ripple_cut_review, ini_file, "ultraschall_settings_ripplecut_review_edit", "Value", "0", "1", "1", true)
reagirl.NextLine()
tabs1.ripple_cut_ignores_locked_tracks = reagirl.Checkbox_Add(nil, nil, "Ripple-Cut ignores locked tracks", "Ripple cut will ignore locked tracks when set. When unset, Ripple-Cut will cut locked tracks as well.", false, checkbox_run_function, "checkbox_ripple_cut_ignores_locked_tracks" )
reagirl.Checkbox_LinkToIniValue(tabs1.ripple_cut_ignores_locked_tracks , ini_file, "ultraschall_settings_ripplecut_obey_locked", "Value", "0", "1", "1", true)
reagirl.Label_AutoBackdrop(tabs1.editing, tabs1.ripple_cut_ignores_locked_tracks )

reagirl.NextLine(10)
tabs1.soundboard = reagirl.Label_Add(nil, nil, "Soundboard", "Settings for the soundboard.", false, label_run_function, "label_soundboard", nil)
reagirl.NextLine()
tabs1.soundboard_duck_rec = reagirl.Checkbox_Add(nil, nil, "Soundboard ducking during recording", "Activate ducking of the soundboard during recording. If anyone starts to talk to a microphone, the Soundboard track will be gently reduced in volume.", true, checkbox_run_function, "checkbox_soundboard_duck_rec" )
reagirl.Checkbox_LinkToIniValue(tabs1.soundboard_duck_rec, ini_file, "ultraschall_settings_soundboard_ducking", "Value", "0", "1", "1", true)
reagirl.NextLine()
tabs1.soundboard_duck_editing = reagirl.Checkbox_Add(nil, nil, "Soundboard ducking during editing", "Activate ducking of the soundboard during editing. If anyone starts to talk to a microphone, the Soundboard track will be gently reduced in volume.", true, checkbox_run_function, "checkbox_soundboard_duck_editing")
reagirl.Checkbox_LinkToIniValue(tabs1.soundboard_duck_editing, ini_file, "ultraschall_settings_soundboard_ducking_editing", "Value", "0", "1", "1", true)
reagirl.NextLine(5)
tabs1.soundboard_preshow_music_mix = reagirl.Slider_Add(nil, nil, 300, "Preshow music mix:", 140, "Play some music from the Ultraschall-Soundboard in your preshow to entertain the livestream. If you choose the preshow routing preset, you can mix none (0) some or all (1) of the music to your headphones mix.", "%", 0, 100, 1, 30, 30, slider_run_func, "slider_soundboard_preshow_music_mix")
reagirl.Slider_LinkToIniValue(tabs1.soundboard_preshow_music_mix, ini_file, "ultraschall_settings_preshow_mix", "Value", 30, true, 0.01)
reagirl.Label_AutoBackdrop(tabs1.soundboard, tabs1.soundboard_preshow_music_mix)

reagirl.NextLine(10)
tabs1.helpersounds = reagirl.Label_Add(nil, nil, "Helpersounds", "Settings for helper sounds.", false, label_run_function, "label_helpersounds", nil)
reagirl.NextLine()
tabs1.sound_marker_ping = reagirl.Checkbox_Add(nil, nil, "Marker sound during playback", "Play a sound if the playcursor passes through a marker.", false, checkbox_run_function, "checkbox_sound_marker_ping")
reagirl.Checkbox_LinkToIniValue(tabs1.sound_marker_ping, ini_file, "ultraschall_settings_tims_chapter_ping", "Value", "0", "1", "0", true)
reagirl.NextLine()
tabs1.sound_when_render_finishes = reagirl.Checkbox_Add(nil, nil, "Play sound when render is finished/aborted", "When checked, it plays a sound when render is finished/aborted.", false, checkbox_run_function, "checkbox_sound_when_render_finishes")
reagirl.Checkbox_LinkToIniValue(tabs1.sound_when_render_finishes, ini_file, "ultraschall_settings_render_finished_ping", "Value", "0", "1", "0", true)
reagirl.NextLine(5)
tabs1.sound_ping_volume = reagirl.Slider_Add(nil, nil, 300, "Volume of ping-sounds:", 140, "Set volume of the ping sounds.", "%", 0, 100, 1, 50, 50, slider_run_func, "slider_sound_ping_volume")
reagirl.Slider_LinkToIniValue(tabs1.sound_ping_volume, ini_file, "ultraschall_settings_tims_chapter_ping_volume", "Value", 50, true, 0.01)
reagirl.Label_AutoBackdrop(tabs1.helpersounds, tabs1.sound_ping_volume)

reagirl.NextLine(10)
tabs1.soundcheck = reagirl.Label_Add(nil, nil, "Soundcheck", "Settings for the soundcheck.", false, label_run_function, "label_soundcheck", nil)
reagirl.NextLine()
tabs1.soundcheck_graceful = reagirl.Checkbox_Add(nil, nil, "Graceful soundcheck", "Set all open soundcheck warnings to the _ignore_ state by closing the soundcheck window.", true, checkbox_run_function, "checkbox_soundcheck_graceful")
reagirl.Checkbox_LinkToIniValue(tabs1.soundcheck_graceful, ini_file, "ultraschall_settings_graceful_soundcheck", "Value", "0", "1", "1", true)
reagirl.Label_AutoBackdrop(tabs1.soundcheck, tabs1.soundcheck_graceful)

reagirl.NextLine(10)
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
tabs1.zoom_out_sensitivity = reagirl.Slider_Add(nil, nil, 300, "Zoom Out sensitivity:", 140, "Set the sensitivity of zooming out, when zoomed further out of the project.", "", 0.4, 8, 0.1, 0.4, 0.4, slider_run_func, "slider_zoom_out_sensitivity")
reagirl.Slider_LinkToIniValue(tabs1.zoom_out_sensitivity, ini_file, "ultraschall_settings_Zoom_Sensitivity", "Value", 0.4, true, nil)
reagirl.Label_AutoBackdrop(tabs1.visual_settings, tabs1.zoom_out_sensitivity)

reagirl.NextLine(10)
tabs1.magic_routing = reagirl.Label_Add(nil, nil, "Magic Routing", "Settings for Magic Routing.", false, label_run_function, "label_magic_routing", nil)
reagirl.NextLine()
tabs1.magic_routing_always_start_startup = reagirl.Checkbox_Add(nil, nil, "Always start MagicRouting at startup", "When checked, always start MagicRouting at Ultraschall startup. When unchecked, it will retain at startup the last MagicRouting-state from last time closing Ultraschall.", true, checkbox_run_function, "checkbox_magic_routing_always_start_startup")
reagirl.Checkbox_LinkToIniValue(tabs1.magic_routing_always_start_startup, ini_file, "ultraschall_settings_magic_routing_always_on", "Value", "0", "1", "1", true)
reagirl.Label_AutoBackdrop(tabs1.magic_routing, tabs1.magic_routing_always_start_startup)
--]]

-- Soundcheck-Tab
tabs2={}
reagirl.AutoPosition_SetNextUIElementRelativeTo(tabs_guid)
tabs2.soundchecks = reagirl.Label_Add(nil, nil, "Available Soundchecks", "Soundchecks.", false, label_run_function, "label_soundchecks", nil)

reagirl.NextLine()
tabs2.soundcheck_saveproject = reagirl.Checkbox_Add(nil, nil, "Save project before recording", "The project should be saved before recording starts. Ignoring this can lead to difficulties in finding your records or even to loss of data.", true, checkbox_run_function, "checkbox_soundcheck_save_project")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_saveproject, ini_file, "ultraschall_soundcheck_unsaved", "Value", "0", "1", "1", true)
tabs2.button_help = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help, true, "Value", tabs2.soundcheck_saveproject)

reagirl.NextLine()
tabs2.soundcheck_preparealltracks = reagirl.Checkbox_Add(nil, nil, "Prepare all tracks for editing", "Reminder to prepare all tracks for editing after a recording is complete. This starts a series of actions to switch the app from recording to editing behavior.", true, checkbox_run_function, "checkbox_soundcheck_prepare_all_tracks_for_editing")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_preparealltracks, ini_file, "ultraschall_soundcheck_prepare_for_editing", "Value", "0", "1", "1", true)
tabs2.button_help2 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help2, true, "Value", tabs2.soundcheck_preparealltracks )

reagirl.NextLine()
tabs2.soundcheck_48khz_check = reagirl.Checkbox_Add(nil, nil, "Check for 48 KHz sample rate", "The samplerate of all devices must be set to 48.000 Hz if you want to use StudioLink or StudioLink OnAir.", true, checkbox_run_function, "checkbox_soundcheck_48khz_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_48khz_check, ini_file, "ultraschall_soundcheck_samplerate", "Value", "0", "1", "1", true)
tabs2.button_help3 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help3, true, "Value", tabs2.soundcheck_48khz_check)

reagirl.NextLine()
tabs2.soundcheck_mic_check = reagirl.Checkbox_Add(nil, nil, "Check if internal mic is selected", "Prevents you from accidentally recording with the built-in microphone instead of using your dedicated sound interface.", true, checkbox_run_function, "checkbox_soundcheck_mic_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_mic_check, ini_file, "ultraschall_soundcheck_mic", "Value", "0", "1", "1", true)
tabs2.button_help4 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help4, true, "Value", tabs2.soundcheck_mic_check)

reagirl.NextLine()
tabs2.soundcheck_overdub_check = reagirl.Checkbox_Add(nil, nil, "Start recording only at the end", "This warning appears when a recording is started in the middle of an existing project, not at the end. This would lead to overlapping takes and is usually undesirable.", true, checkbox_run_function, "checkbox_soundcheck_overdub_check")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_overdub_check, ini_file, "ultraschall_soundcheck_overdub", "Value", "0", "1", "1", true)
tabs2.button_help5 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help5, true, "Value", tabs2.soundcheck_overdub_check)

reagirl.NextLine()
tabs2.soundcheck_unknown_interface = reagirl.Checkbox_Add(nil, nil, "Unknown sound interface", "Watches for a change in your sound interface.", true, checkbox_run_function, "checkbox_soundcheck_unknown_interface")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_unknown_interface, ini_file, "ultraschall_soundcheck_changed_interface", "Value", "0", "1", "1", true)
tabs2.button_help6 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help6, true, "Value", tabs2.soundcheck_unknown_interface)

reagirl.NextLine()
tabs2.soundcheck_distortion_prevention = reagirl.Checkbox_Add(nil, nil, "Echo and distortion prevention", "If you use a audio device without Direct Monitoring(means, you cannot attach a headphone to it) it is important to set the right block size. \n\nA block size larger than 128 will result in latency and echo effects. A block size smaller than 32 will lead to an unstable audio stack and dropouts. \n\nWe suggest 512 for Direct Monitoring devices and 64 for devices without Direct Monitoring.", true, checkbox_run_function, "checkbox_soundcheck_distortion_prevention")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_unknown_interface, ini_file, "ultraschall_soundcheck_Bsize", "Value", "0", "1", "1", true)
tabs2.button_help7 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help7, true, "Value", tabs2.soundcheck_distortion_prevention)

reagirl.NextLine()
tabs2.soundcheck_input_wizard = reagirl.Checkbox_Add(nil, nil, "Input wizard", "Checks if... \na) an input of the sound interface is used multiple times and \nb) if the interchangeable mic channels of a zoom interface are used.", true, checkbox_run_function, "checkbox_soundcheck_input_wizard")
reagirl.Checkbox_LinkToIniValue(tabs2.soundcheck_input_wizard, ini_file, "ultraschall_soundcheck_inputs", "Value", "0", "1", "1", true)
tabs2.button_help8 = reagirl.Button_Add(-100, nil, 0, 0, "?", "Opens the help page in the manual.", button_run_function_soundcheck_help, "button_help", mode, width, height)
reagirl.UI_Element_GetSetExtState(tabs2.button_help8, true, "Value", tabs2.soundcheck_input_wizard)

reagirl.NextLine(30)
tabs2.soundchecks_description = reagirl.Label_Add(nil, nil, "The soundcheck checks for common mistakes \nand problems, happening during podcast-production.\n\nThe checks try to save you from these problems.\n\nIf you don't need a specific check, deactivate \nthe checkbox for the soundcheck.", "Soundchecks.", false, label_run_function, "label_soundchecks", nil)

reagirl.Label_AutoBackdrop(tabs2.soundchecks, tabs2.soundchecks_description)


-- associate tabs with the ui-elements stored in the tables
reagirl.Tabs_SetUIElementsForTab(tabs_guid, 1, tabs1)
reagirl.Tabs_SetUIElementsForTab(tabs_guid, 2, tabs2)


-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Ultraschall Settings", "Set your preferences for Ultraschall.", width, 520, nil, nil, nil)
--red, green, blue = reagirl.Background_GetSetColor(true, 44, 44, 44)
-- 5. a main-function that runs the gui-management-function


function main()
  reagirl.Gui_Manage()
  
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()

