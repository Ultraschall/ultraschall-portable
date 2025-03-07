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


--------------------------
-- Start Ultraschall Messaging
--------------------------

cmd=reaper.NamedCommandLookup("_Ultraschall_Messaging")
reaper.Main_OnCommand(cmd,0)



theme_version_now = 20180114 -- version of this theme

-- reaper.SetExtState("ultraschall_versions", "theme", theme_version_now, true)
-- not a good idea: something went wrong during the installation of the theme, so don't fix but reinstall

error_msg = false

---------------------------------------
-- get data from system key/value store
---------------------------------------

theme_version = reaper.GetExtState("ultraschall_versions", "theme")
plugin_version = reaper.GetExtState("ultraschall_versions", "plugin")
-- views = ultraschall.GetUSExternalState("ultraschall_gui", "views")
-- view = ultraschall.GetUSExternalState("ultraschall_gui", "view")
-- sec = ultraschall.GetUSExternalState("ultraschall_gui", "sec")
-- mouse = ultraschall.GetUSExternalState("ultraschall_mouse", "state")
first_start = ultraschall.GetUSExternalState("ultraschall_start", "firststart")
startscreen = ultraschall.GetUSExternalState("ultraschall_settings_startsceen", "Value","ultraschall-settings.ini")
-- follow = ultraschall.GetUSExternalState("ultraschall_follow", "state")
-- follow_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
magicrouting_always_on = ultraschall.GetUSExternalState("ultraschall_settings_magic_routing_always_on", "Value","ultraschall-settings.ini")
magicrouting_state = ultraschall.GetUSExternalState("ultraschall_magicrouting", "state")

if theme_version ~= tostring(theme_version_now) then
  error_msg = "Your ULTRASCHALL THEME is out of date. \n\nULTRASCHALL wil NOT work properly until you fix this. \n\nPlease get the latest release on http://ultraschall.fm/install/"
end

if plugin_version ~= theme_version then -- different versions of theme and plugin isntalled
  error_msg = "There is a configuration mismatch between the ULTRASCHALL THEME ("..theme_version..") and PLUGIN ("..plugin_version..").\n\nULTRASCHALL will NOT work properly until you fix this. \n\nPlease get the latest release on http://ultraschall.fm/install/"
end

if plugin_version == "" then
  error_msg = "The ULTRASCHALL PLUGIN was not properly installed.\n\nULTRASCHALL wil NOT work properly until you fix this.\n\nPlease check the installation guide on http://ultraschall.fm/install/"
end

if theme_version == "" then
  error_msg = "There are parts of the ULTRASCHALL THEME missing.\n\nULTRASCHALL wil NOT work properly until you fix this.\n\nPlease check the installation guide on http://ultraschall.fm/install/"
end

if error_msg then
     result = reaper.ShowMessageBox(error_msg, "Ultraschall Configuration Problem", 0)

elseif first_start == "true" or startscreen == "1" or startscreen == "-1" then
  start_id = reaper.NamedCommandLookup("_Ultraschall_StartScreen")
  reaper.Main_OnCommand(start_id,0)   --Show Startscreen
end

if reaper.GetExtState("ultraschall_version", "version_check")~="5.1.1" then
  if reaper.GetAppVersion():match("6%.83")==nil then
    reaper.MB("This version of Ultraschall requires Reaper 6.83 to work.\n\nAny other version might lead to Ultraschall being not fully functional or not functional at all.\n\nPlease head over to: http://reaper.fm/download-old.php?ver=6x to download Reaper 6.83", "Wrong Reaper version!", 0)
  end
end
reaper.SetExtState("ultraschall_version", "version_check", "5.1.1", true)

--reaper.SetExtState("ultraschall_version", "version_check", "", true)
--print2(reaper.GetExtState("ultraschall_version", "version_check"))
--if lol==nil then return end

--[[ wird alles durch GUI State Manager gelöst

if sec=="-1" then sec=0 end
if view=="-1" then view="setup" end
if views=="-1" then views=55796 end

--------------------------
-- Restore GUI and Buttons
--------------------------


if views then
  reaper.SetToggleCommandState(sec, views, 1)
  reaper.RefreshToolbar2(sec, views)
  if view == "setup" then
    reaper.Main_OnCommand(40454,0)      --(re)load Setup Screenset
  elseif view == "record" then
    reaper.Main_OnCommand(40455,0)      --(re)load Setup Screenset
  elseif view == "edit" then
    reaper.Main_OnCommand(40456,0)      --(re)load Setup Screenset
  elseif view == "story" then
    reaper.Main_OnCommand(40457,0)      --(re)load Setup Screenset
  end
end

if tonumber(mouse) <= 0 then -- selection is activated
  mouse_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Mouse_Selection")
  reaper.SetToggleCommandState(sec, mouse_id, 1)
  reaper.RefreshToolbar2(sec, mouse_id)
end


if follow == "1" and reaper.GetToggleCommandState(follow_id)~=1 then -- follow is activated
  reaper.SetToggleCommandState(sec, follow_id, 1)
  reaper.RefreshToolbar2(sec, follow_id)
end

]]

--------------------------
-- Restore / set GUI/toggle states
--------------------------

mouse_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Mouse_Selection")
reaper.SetToggleCommandState(0, mouse_id, 1)
reaper.RefreshToolbar2(0, mouse_id)

follow_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
reaper.SetToggleCommandState(0, follow_id, 1)
reaper.RefreshToolbar2(0, follow_id)

label_id = reaper.NamedCommandLookup("_Ultraschall_toggle_item_labels")
reaper.SetToggleCommandState(0, label_id, 0)
reaper.RefreshToolbar2(0, label_id)

cmd=reaper.NamedCommandLookup("_Ultraschall_Toggle_Magicrouting")

if magicrouting_always_on=="1" or magicrouting_state=="1" then
  retval, project_state = reaper.GetProjExtState(0, "gui_statemanager", "_Ultraschall_Toggle_Magicrouting")
  if project_state ~= "0" then
    reaper.Main_OnCommand(cmd,0) -- starte MagicRouting
  else
    reaper.SetToggleCommandState(0, cmd, 0)
    reaper.RefreshToolbar(cmd)
  end
end

retval, project_state = reaper.GetProjExtState(0, "gui_statemanager", "_Ultraschall_set_Matrix_Recording")
-- print ("Matrix: "..project_state)
if project_state == "" then
  cmd=reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Recording")
  reaper.Main_OnCommand(cmd,0) -- Preset wenn kein Routing gespeichert ist: Recording
end

retval, project_view = reaper.GetProjExtState(0, "gui_statemanager", "_ULTRASCHALL_SET_VIEW_EDIT")
-- print ("View: "..project_view)
if project_view == "" then
  cmd=reaper.NamedCommandLookup("_Ultraschall_Set_View_Record")
  reaper.Main_OnCommand(cmd,0) -- Preset wenn kein View gespeichert ist: Recording
end

-- set OnAir button off

on_air_button_id = reaper.NamedCommandLookup("_Ultraschall_OnAir")
reaper.SetToggleCommandState(0, on_air_button_id, 0)
reaper.RefreshToolbar2(0, on_air_button_id)


--[[ set current toggling-action-states that have no toolbar-button ]]


--------------------------
-- Restore opened/closed Windows
--------------------------

-- Reset the counter for already opened windows
reaper.SetExtState("Ultraschall_Windows","Ultraschall 5 - Routing Snapshots",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall 5 - Export Assistant",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall Color Picker",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall 5 - Soundcheck",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall 5 - Settings",0.0, true)


------------------------------------------
-- remove StudioLink OnAir FX from Master
------------------------------------------


m = reaper.GetMasterTrack(0)                                                  --streaming is always on the master track

--get the slot of the StudioLink effect.
operationSystem = reaper.GetOS()
if string.match(operationSystem, "OS") then
  fx_slot = reaper.TrackFX_AddByName(m, "StudioLinkOnAir (ITSR)", false, 0)
elseif string.match(operationSystem, "Win") then
  fx_slot = reaper.TrackFX_GetByName(m, "StudioLinkOnAir (IT-Service Sebastian Reimers)", 0)
elseif string.match(operationSystem, "Other") then
  fx_slot = reaper.TrackFX_AddByName(m, "StudioLinkOnAir", false, 0)
end

if fx_slot ~= -1 then
  reaper.TrackFX_Delete(m, fx_slot)
end


------------------------------------------
-- Lade das Theme
------------------------------------------

themeadress = reaper.GetResourcePath() .. "/ColorThemes/Ultraschall_5.ReaperTheme"
reaper.OpenColorThemeFile(themeadress)
-- end


--------------------------
-- Reset Windows counter
--------------------------

-- beim Start von Ultraschall werden alle Fenster-Counter auf 0 gesetzt

inipath = reaper.GetResourcePath().."/reaper-extstate.ini"
keyscount = ultraschall.CountIniFileExternalState_key("Ultraschall_Windows", inipath)

for i = 1, keyscount, 1 do
  keyname = ultraschall.EnumerateIniFileExternalState_key("Ultraschall_Windows", i, inipath)
  length, keyvalue = ultraschall.GetIniFileExternalState("Ultraschall_Windows", keyname, inipath)

  if tonumber(keyvalue) > 0 then
    retval = ultraschall.SetIniFileExternalState("Ultraschall_Windows", keyname, "0.0", inipath)

  end
end

--------------------------
-- Check for internal Microphone
--------------------------

operationSystem = reaper.GetOS()
if string.match(operationSystem, "OS") then

  handle = io.popen("system_profiler SPAudioDataType -xml | grep -B 1 'coreaudio_default_audio_input_device' | head -n 1") -- get default input device name
  result = handle:read("*a")
  handle:close()

  result = string.gsub(result, "\n", "") -- remove newline
  result = string.gsub(result, "\t", "") -- remove tabs
  result = string.gsub(result, "(%b<>)", "") -- remove <*> tags

  --print("("..result..")")

  if (result=="Built-in Input" or result=="Built-in Microphone") then
    reaper.SetExtState("ultraschall_mic", "internal", "true", false)
  else
    reaper.SetExtState("ultraschall_mic", "internal", "false", false)
  end
end


--------------------------
-- Start GUI State Manager
--------------------------

cmd=reaper.NamedCommandLookup("_Ultraschall_Gui_Statemanager")
reaper.Main_OnCommand(cmd,0)

--------------------------
-- Start Soundcheck
--------------------------

cmd=reaper.NamedCommandLookup("_Ultraschall_Soundcheck_Controller")
reaper.Main_OnCommand(cmd,0)

--------------------------
-- Start Tims Chapter Ping
--------------------------

if ultraschall.GetUSExternalState("ultraschall_settings_tims_chapter_ping", "Value" ,"ultraschall-settings.ini") == "1" then
  cmd=reaper.NamedCommandLookup("_Ultraschall_Tims_Ping_Feature")
  reaper.Main_OnCommand(cmd,0)
end

--------------------------
-- Start Render Rooster Sound
--------------------------
  cmd=reaper.NamedCommandLookup("_Ultraschall_Play_Sound_When_Render_Is_Finished")
  reaper.Main_OnCommand(cmd,0)

--------------------------
-- Start Followmode-reset-backgroundscript
--------------------------

if ultraschall.GetUSExternalState("ultraschall_settings_followmode_auto", "Value" ,"ultraschall-settings.ini") == "1" then

  cmd=reaper.NamedCommandLookup("_Ultraschall_Toggle_Reset")
  reaper.Main_OnCommand(cmd,0)

end


--------------------------
-- Starte die Ulraclock
--------------------------

cmd=reaper.NamedCommandLookup("_Ultraschall_Clock")
reaper.Main_OnCommand(cmd,0)



-- install hotfixes, if available
if reaper.file_exists(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")==true then
 ultraschall.RunCommand("_Ultraschall_Hotfixes")
end

--------------------------
-- First start actions
--------------------------

-- not really needed right now, but maybe in coming releases

if first_start == "true" or first_start == "-1" then
  ultraschall.SetUSExternalState("ultraschall_start", "firststart", "false")  -- there will be only one first start
end
