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
  --]]

Comment="  --[[\n  ################################################################################\n  # \n  # Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)\n  # \n  # Permission is hereby granted, free of charge, to any person obtaining a copy\n  # of this software and associated documentation files (the \"Software\"), to deal\n  # in the Software without restriction, including without limitation the rights\n  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n  # copies of the Software, and to permit persons to whom the Software is\n  # furnished to do so, subject to the following conditions:\n  # \n  # The above copyright notice and this permission notice shall be included in\n  # all copies or substantial portions of the Software.\n  # \n  # THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n  # THE SOFTWARE.\n  # \n  ################################################################################\n--]]"

-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
-- check for required version; alter the version-number if necessary
if reagirl.GetVersion()<1.32 then reaper.MB("Needs ReaGirl v"..(1.32).." to run", "Too old version", 2) return false end

NewInsertItemAction=[[
-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
A,B,C,cmd=reaper.get_action_context()

inputlatency, outputLatency = reaper.GetInputOutputLatency()
for i=0, reaper.CountTracks(0) do
  if ultraschall.IsTrackSoundboard(i)==true then soundboard_track=i break end
end
if soundboard_track==nil then return end

if reaper.GetPlayState()==0 then position=reaper.GetCursorPosition() else position=reaper.GetPlayPosition() end
retval, item, endposition, numchannels, Samplerate, Filetype, editcursorposition, track = 
  ultraschall.InsertMediaItemFromFile(filename, soundboard_track, position+1.5, -1, 2, 0, false, false)
  volume=reaper.GetMediaItemInfo_Value(item, "D_VOL")
  volume=reaper.SetMediaItemInfo_Value(item, "D_VOL", volume-0.5)
]]

NewSoundboardAction=[[
-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
A,B,C,cmd=reaper.get_action_context()

if reaper.GetExtState("Ultraschall", "Play"..cmd)~="" then 
  address=tonumber(reaper.GetExtState("Ultraschall", "Play"..cmd))
  address2=tonumber(reaper.GetExtState("Ultraschall", "Play2"..cmd))
  
  reaper.SetExtState("Ultraschall", "Play"..cmd, "", false)
  reaper.SetExtState("Ultraschall", "Play2"..cmd, "", false)
  CF_Preview=reaper.JS_Window_HandleFromAddress(address)
  PCM_source=reaper.JS_Window_HandleFromAddress(address2)
  reaper.CF_Preview_Stop(CF_Preview) 
  reaper.PCM_Source_Destroy(PCM_source)
  return
end


for i=0, reaper.CountTracks(0) do
  if ultraschall.IsTrackSoundboard(i)==true then soundboard_track=i-1 break end
end
if soundboard_track==nil then return end

PCM_source=reaper.PCM_Source_CreateFromFile(filename)
CF_Preview=reaper.CF_CreatePreview(PCM_source)
reaper.CF_Preview_SetOutputTrack(CF_Preview, 0, reaper.GetTrack(0, soundboard_track))
retval, new_value = reaper.CF_Preview_SetValue(CF_Preview, "D_VOLUME", ultraschall.DB2MKVOL(volume))
reaper.SetExtState("Ultraschall", "Play"..cmd, "1", false)
reaper.CF_Preview_Play(CF_Preview)

address = reaper.JS_Window_AddressFromHandle(CF_Preview)
address2 = reaper.JS_Window_AddressFromHandle(PCM_source)
reaper.SetExtState("Ultraschall", "Play"..cmd, address, false)
reaper.SetExtState("Ultraschall", "Play2"..cmd, address2, false)

return
]]

-- 1. add the run-functions for the ui-elements
function fileinput_button_runfunction()
  -- select audiofile and add the text into the inputbox
  path=reaper.GetExtState("ultraschall_create_soundboard_action", "path", path, true)
  local retval, filename = reaper.GetUserFileNameForRead(path, "Choose audiofile...", "*.*")
  if retval==true then
    if Play==true then
      reaper.CF_Preview_StopAll()
      reaper.PCM_Source_Destroy(PCM_source)
      Play=false
      reagirl.UI_Element_GetSetCaption(filepreviewinput_button_guid, true, "►")
    end
    path=string.gsub(filename, "\\", "/"):match("(.*/)")
    if path~=nil then
      reaper.SetExtState("ultraschall_create_soundboard_action", "path", path, true)
    end
  end
  if retval==true then
    local fileformat, supported_by_reaper, mediatype = ultraschall.CheckForValidFileFormats(filename)
    if supported_by_reaper==true then
      reagirl.Inputbox_SetText(fileinput_inputbox_guid, filename)
    else
      reaper.MB("Not a supported audio/video-file in Reaper", "Fileformat not supported", 0)
    end
  end
end

function filepreview_button_runfunction()
  local filename=reagirl.Inputbox_GetText(fileinput_inputbox_guid)
  if filename=="" then return end
  if reaper.file_exists(filename)==false then reaper.MB("Audiofile does not exist", "Ooops...", 0) return end
  if Play~=true then
    
    PCM_source=reaper.PCM_Source_CreateFromFile(filename)
    CF_Preview=reaper.CF_CreatePreview(PCM_source)
    for i=0, reaper.CountTracks(0) do
      if ultraschall.IsTrackSoundboard(i)==true then soundboard_track=i break end
    end
    if soundboard_track==nil then 
      return 
    else
      reaper.CF_Preview_SetOutputTrack(CF_Preview, 0, reaper.GetTrack(0, soundboard_track-1))
    end
    volume=ultraschall.DB2MKVOL(reagirl.Slider_GetValue(playvolume_slider_guid))
    reaper.CF_Preview_SetValue(CF_Preview, "D_VOLUME", volume)
    reaper.CF_Preview_Play(CF_Preview)
    Play=true
    old_pos=-1
  else
    Play=false
    reaper.CF_Preview_StopAll()
    reaper.PCM_Source_Destroy(PCM_source)
    reagirl.UI_Element_GetSetCaption(filepreviewinput_button_guid, true, "►")
  end
end

function SliderRunFunc()
  if Play==true then
    volume=ultraschall.DB2MKVOL(reagirl.Slider_GetValue(playvolume_slider_guid))
    reaper.CF_Preview_SetValue(CF_Preview, "D_VOLUME", volume)
  end
end

function action_add_button_runfunction()
  -- create lua-file and add it as action
  local text=reagirl.Inputbox_GetText(fileinput_inputbox_guid)
  if text=="" then return end
  local volume=reagirl.Slider_GetValue(playvolume_slider_guid)
  local filename
  
  if reagirl.DropDownMenu_GetSelectedMenuItem(playtarget_menu_guid)==1 then
    volume=reagirl.Slider_GetValue(playvolume_slider_guid)
    NewSoundboardAction="filename=\""..string.gsub(text,"\\", "/").."\"\nvolume="..(volume).."\n"..NewSoundboardAction
    action="play_in_soundboard_input_"
  else
    volume=reagirl.Slider_GetValue(playvolume_slider_guid)
    NewSoundboardAction="filename=\""..string.gsub(text,"\\", "/").."\"\nvolume="..(volume).."\n"..NewInsertItemAction
    action="insert_file_in_soundboard_track_"
  end
  
  reaper.SetExtState("ultraschall_create_soundboard_action", "target", reagirl.DropDownMenu_GetSelectedMenuItem(playtarget_menu_guid), true)
  
  filename=string.gsub(text,"\\", "/"):match(".*/(.*)%..*")
  if filename==nil then filename=string.gsub(text,"\\", "/"):match(".*/(.*)") end
  if filename==nil then filename=string.gsub(text,"\\", "/") end
  if reaper.file_exists(text)==false then reaper.MB("Audiofile does not exist", "Ooops...", 0) return end
  retval=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/Scripts/ultraschall_"..action..filename..".lua", Comment.."\n\n"..NewSoundboardAction)
  if retval==-1 then 
    reaper.MB("Can't create the action-file. Disk full or restricted file-access in the Reaper-folder "..reaper.GetResourcePath().."?", "Oops...", 0)
    return
  end
  
  actioncmd=reaper.AddRemoveReaScript(true, 0, reaper.GetResourcePath().."/Scripts/ultraschall_"..action..filename..".lua", true)
  if reaper.MB("Action created under the name: \nultraschall_"..action..filename..".lua\"\n\nDo you want to set it to a shortcut?", "Success", 4)==6 then
    --ultraschall.ShowActionList("ultraschall_"..action..filename..".lua")
    reaper.DoActionShortcutDialog(HWND, 0, actioncmd, 0)
  end
  reagirl.Gui_Close()
end

-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes
fileinput_inputbox_guid = reagirl.Inputbox_Add(nil, nil, 350, "Audiofilename: ", 85, "The audio-filename that you want to add.", "", run_function_enter, run_function_type, "fileinput_inputbox")
filepreviewinput_button_guid = reagirl.Button_Add(375, nil, -10, 0, "►", "Preview Chosen File.", filepreview_button_runfunction, "filepreview_button", 0)
fileinput_button_guid = reagirl.Button_Add(395, nil, 0, 0, "Select Filename", "Choose a file.", fileinput_button_runfunction, "fileinput_button", 0)

reagirl.NextLine()
target=tonumber(reaper.GetExtState("ultraschall_create_soundboard_action", "target"))
reagirl.NextLine()
if target==nil then target=1 end
playtarget_menu_guid = reagirl.DropDownMenu_Add(nil,nil, 350, "Playtarget:", 85, "Choose, whether to play the file into the Soundboard track or add the file into the Soundboard track as new item.", {"Play through Soundboard-input", "Add as audio-item into Soundboard-track"}, target, playtarget_run_function, "target_dropdownmenu")
reagirl.NextLine()
playvolume_slider_guid = reagirl.Slider_Add(nil, nil, 388, "Volume", 85, "The volume of how loud the action plays the audio in dB.", "dB", -144, 0, 1, 0, 0, SliderRunFunc, "volume_slider")
reagirl.NextLine(10)
action_add_button_guid = reagirl.Button_Add(-164, nil, 0, 0, "Create audioplay-action", "Create audioplay-action.", action_add_button_runfunction, "action_create_button", 0)

--reagirl.UI_Element_SetFocused(fileinput_inputbox_guid)
function AtEnter()
  if reagirl.Inputbox_GetText(fileinput_inputbox_guid)=="" then
    fileinput_button_runfunction()
  else
    action_add_button_runfunction()
  end
end

reagirl.Gui_AtEnter(AtEnter)

-- 4. open the gui
reagirl.Gui_Open("Create Audio-Play-Action through Soundboard", false, "Create Audio-Play-Action through Soundboard-track", "Choose an audiofilename and create an action, that plays the audiofile through the Soundboard-track.", nil, nil, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
A=0
old_pos=-1
function main()
  reagirl.Gui_Manage()
  if Play==true then
    A=A+1
    if A>30 then A=0 end
    if A==0 then reagirl.UI_Element_GetSetCaption(filepreviewinput_button_guid, true, "") end
    if A==15 then reagirl.UI_Element_GetSetCaption(filepreviewinput_button_guid, true, "►") end
    local B, pos=reaper.CF_Preview_GetValue(CF_Preview, "D_POSITION")
    if pos<old_pos then
      if A==15 then reagirl.UI_Element_GetSetCaption(filepreviewinput_button_guid, true, "►") end
      reaper.PCM_Source_Destroy(PCM_source)
      Play=false
    end
    old_pos=pos
  end
  

  if reagirl.Gui_IsOpen()==true then reaper.defer(main) 
  else
    if Play==true then
      reaper.CF_Preview_StopAll()
      reaper.PCM_Source_Destroy(PCM_source)
    end
  end
end

main()

