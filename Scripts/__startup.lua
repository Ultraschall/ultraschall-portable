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
 
if reaper.CF_SetClipboard==nil or reaper.JS_ReaScriptAPI_Version==nil then 
  reaper.MB("It seems, that Ultraschall is not completely installed. Did you follow all installation steps?\n\nUltraschall can not properly run, until you've installed Ultraschall completely.\n\nSee ultraschall.fm for a detailed installation description.", "Ultraschall not properly installed.", 0)
  reaper.MB("Ultraschall will now exit.", "Ultraschall Error", 0)
  reaper.Main_OnCommand(40004,0)
  return
end
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")



theme_version_now = 20180114 -- version of this theme

-- reaper.SetExtState("ultraschall_versions", "theme", theme_version_now, true)
-- not a good idea: something went wrong during the installation of the theme, so don't fix but reinstall

error_msg = false

---------------------------------------
-- get data from system key/value store
---------------------------------------

theme_version = reaper.GetExtState("ultraschall_versions", "theme")
plugin_version = reaper.GetExtState("ultraschall_versions", "plugin")
view = ultraschall.GetUSExternalState("ultraschall_gui", "view")
mouse = ultraschall.GetUSExternalState("ultraschall_mouse", "state")
first_start = ultraschall.GetUSExternalState("ultraschall_start", "firststart")
startscreen = ultraschall.GetUSExternalState("ultraschall_start", "startscreen")
follow = ultraschall.GetUSExternalState("ultraschall_follow", "state")

  follow_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")

if theme_version ~= tostring(theme_version_now) then 
  error_msg = "Your ULTRASCHALL THEME is out of date. \n\nULTRASCHALL will NOT work properly until you fix this. \n\nPlease get the latest release on http://ultraschall.fm/install/" 
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
    type = 0
    title = "Ultraschall Configuration Problem"
     result = reaper.ShowMessageBox( error_msg, title, type )

elseif first_start == "true" or startscreen == "1" or startscreen == "-1" then
  start_id = reaper.NamedCommandLookup("_Ultraschall_StartScreen")
  reaper.Main_OnCommand(start_id,0)   --Show Startscreen    
end

if view=="-1" then view="setup" end

--------------------------
-- Restore GUI and Buttons
--------------------------

if view == "setup" then
  ultraschall.RunCommand("_Ultraschall_Set_View_Setup")
elseif view == "record" then
  ultraschall.RunCommand("_Ultraschall_Set_View_Record")
elseif view == "edit" then
  ultraschall.RunCommand("_Ultraschall_Set_View_Edit")
elseif view == "story" then
  ultraschall.RunCommand("_Ultraschall_Set_View_Story")
end


if tonumber(mouse) <= 0 then -- selection is activated
  mouse_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Mouse_Selection")
  reaper.SetToggleCommandState(0, mouse_id, 1)
  reaper.RefreshToolbar2(0, mouse_id)
end


if follow == "1" and reaper.GetToggleCommandState(follow_id)~=1 then -- follow is activated
  reaper.SetToggleCommandState(0, follow_id, 1)
  reaper.RefreshToolbar2(0, follow_id)
end


-- set OnAir button off

on_air_button_id = reaper.NamedCommandLookup("_Ultraschall_OnAir")
reaper.SetToggleCommandState(0, on_air_button_id, 0) 

--------------------------
-- Restore opened/closed Windows
--------------------------

-- Reset the counter for already opened windows
reaper.SetExtState("Ultraschall_Windows","Ultraschall Routing Snapshots",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall Export Assistant",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall Color Picker",0.0, true)
reaper.SetExtState("Ultraschall_Windows","Ultraschall 3",0.0, true)


--------------------------
-- Run on every start ----
--------------------------

-- remove StudioLink OnAir FX from Master

m = reaper.GetMasterTrack(0)                                                  --streaming is always on the master track
os = reaper.GetOS()

if string.match(os, "OSX") then 
  fx_slot = reaper.TrackFX_GetByName(m, "ITSR: StudioLinkOnAir", 0)      --get the slot of the StudioLink effect. If there is none: initiate one.
else  -- Windows
  fx_slot = reaper.TrackFX_GetByName(m, "StudioLinkOnAir (IT-Service Sebastian Reimers)", 0)      --get the slot of the StudioLink effect. If there is none: initiate one.
end
reaper.SNM_MoveOrRemoveTrackFX(m, fx_slot, 0)

-- is the ReaperThemeZip loaded? Only then (probably on first start) reload the ReaperTheme to get the colors working 

-- curtheme = reaper.GetLastColorThemeFile()
-- if string.find(curtheme, "ReaperThemeZip", 1) then
  themeadress = reaper.GetResourcePath() .. "/ColorThemes/Ultraschall_3.1.ReaperTheme"
  reaper.OpenColorThemeFile(themeadress)
-- end

-- start Followmode-reset-backgroundscript
  follow_reset_cmdid=reaper.NamedCommandLookup("_Ultraschall_Toggle_Reset")
  reaper.SetExtState("ultraschall_follow", "state2", follow, false)
  reaper.Main_OnCommand(follow_reset_cmdid,0)


--------------------------
-- First start actions
--------------------------

-- not really needed right now, but maybe in coming releases

if first_start == "true" or first_start == "-1" then
  ultraschall.SetUSExternalState("ultraschall_start", "firststart", "false", true)  -- there will be only one first start
end


