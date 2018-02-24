--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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
 
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")


theme_version_now = 20180114 -- version of this theme

-- reaper.SetExtState("ultraschall_versions", "theme", theme_version_now, true)
-- not a good idea: something went wrong during the installation of the theme, so don't fix but reinstall

error_msg = false

---------------------------------------
-- get data from system key/value store
---------------------------------------

theme_version = reaper.GetExtState("ultraschall_versions", "theme")
plugin_version = reaper.GetExtState("ultraschall_versions", "plugin")
A,views = ultraschall.GetUSExternalState("ultraschall_gui", "views")
A,view = ultraschall.GetUSExternalState("ultraschall_gui", "view")
A,sec = ultraschall.GetUSExternalState("ultraschall_gui", "sec")
A,mouse = ultraschall.GetUSExternalState("ultraschall_mouse", "state")
A,first_start = ultraschall.GetUSExternalState("ultraschall_start", "firststart")
A,startscreen = ultraschall.GetUSExternalState("ultraschall_start", "startscreen")
A,follow = ultraschall.GetUSExternalState("ultraschall_follow", "state")

  follow_id = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")

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
    type = 0
    title = "Ultraschall Configuration Problem"
     result = reaper.ShowMessageBox( error_msg, title, type )

elseif first_start == "true" or startscreen == "1" or startscreen == "-1" then
  start_id = reaper.NamedCommandLookup("_Ultraschall_StartScreen")
  reaper.Main_OnCommand(start_id,0)   --Show Startscreen    
end

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


-- set OnAir button off

on_air_button_id = reaper.NamedCommandLookup("_Ultraschall_OnAir")
reaper.SetToggleCommandState(sec, on_air_button_id, 0) 

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


