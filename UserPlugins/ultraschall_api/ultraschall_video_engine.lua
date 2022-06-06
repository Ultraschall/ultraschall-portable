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

--------------------------------------
--- ULTRASCHALL - API - GFX-Engine ---
--------------------------------------


--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetVideoHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetVideoHWND()</functioncall>
  <description>
    returns the HWND of the Video window, if the window is opened.
    
    returns nil if the Video Window is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Video Window
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_VID</target_document>
  <source_document>ultraschall_video_engine.lua</source_document>
  <tags>user interface, window, hwnd, video</tags>
</US_DocBloc>
--]]

function ultraschall.VID_VideoUIStateCoords2Pixels(uistate_x, uistate_y, videowindow_width, videowindow_height)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>VID_VideoUIStateCoords2Pixels</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.97
    Lua=5.3
  </requires>
  <functioncall>integer x_coordinate, integer y_coordinate = ultraschall.VID_VideoUIStateCoords2Pixels(number uistate_x, number uistate_y, integer videowindow_width, integer videowindow_height)</functioncall>
  <description>
    converts the ui_state-coordinates of the Video-Processor into pixel-coordinates within the Video Window
    
    You should add x and y-position of the Video-Processor-window, to get the actual screen-coordinates.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer x_coordinate - the converted x-coordinate
    integer y_coordinate - the converted y-coordinate
  </retvals>
  <parameters>
    number uistate_x - the x-coordinate, that the function ui_get_state within the videoprocessor returns
    number uistate_y - the y-coordinate, that the function ui_get_state within the videoprocessor returns
    integer videowindow_width - the current width of the Video Window
    integer videowindow_height - the current height of the Video Window
  </parameters>
  <chapter_context>
    User Interface
    Coordinates
  </chapter_context>
  <target_document>US_Api_VID</target_document>
  <source_document>ultraschall_video_engine.lua</source_document>
  <tags>user interface, window, coordinates, pixel, ui_get_state, video-processor, convert</tags>
</US_DocBloc>
--]]
  if type(uistate_x)~="number" or (uistate_x<0 or uistate_x>1) then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "uistate_x", "must be a number between 0 and 1", -1) return end
  if type(uistate_y)~="number" or (uistate_y<0 or uistate_y>1) then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "uistate_y", "must be a number between 0 and 1", -2) return end
  if math.type(videowindow_width)~="integer" or videowindow_width<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_width", "must be an integer>0", -3) return end
  if math.type(videowindow_height)~="integer" or videowindow_height<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_height", "must be an integer>0", -4) return end
  
  return uistate_x*videowindow_width, uistate_y*videowindow_height
end

function ultraschall.VID_Pixels2VideoUIStateCoords(x, y, videowindow_width, videowindow_height)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>VID_Pixels2VideoUIStateCoords</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.97
    Lua=5.3
  </requires>
  <functioncall>number uistate_x, number uistate_y = ultraschall.VID_Pixels2VideoUIStateCoords(integer x, integer y, integer videowindow_width, integer videowindow_height)</functioncall>
  <description>
    converts the ui_state-coordinates of the Video-Processor into pixel-coordinates within the Video Window
    
    You should add x and y-position of the Video-Processor-window, to get the actual screen-coordinates.
    
    returns nil in case of an error
  </description>
  <retvals>
    number x_coordinate - the converted x-coordinate, that reflects the values within the video-processor function ui_get_state
    number y_coordinate - the converted y-coordinate, that reflects the values within the video-processor function ui_get_state
  </retvals>
  <parameters>
    integer x - the x-coordinate within the Video-Window
    integer y - the y-coordinate within the Video-Window
    integer videowindow_width - the current width of the Video Window
    integer videowindow_height - the current height of the Video Window
  </parameters>
  <chapter_context>
    User Interface
    Coordinates
  </chapter_context>
  <target_document>US_Api_VID</target_document>
  <source_document>ultraschall_video_engine.lua</source_document>
  <tags>user interface, window, coordinates, pixel, ui_get_state, video-processor, convert</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" or x<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "x", "must be an integer>0", -1) return end
  if math.type(y)~="integer" or y<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "y", "must be an integer>0", -2) return end
  if math.type(videowindow_width)~="integer" or videowindow_width<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_width", "must be an integer>0", -3) return end
  if math.type(videowindow_height)~="integer" or videowindow_height<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_height", "must be an integer>0", -4) return end
  
  return x/videowindow_width, x/videowindow_height
end

function ultraschall.ProjectSettings_GetVideoFramerate()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ProjectSettings_GetVideoFramerate</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer framerate, string addnotes = ultraschall.ProjectSettings_GetVideoFramerate()</functioncall>
  <description>
    returns the video-framerate of the current project
  </description>
  <retvals>
    integer framerate - the framerate in fps from 1 to 999999999
    string addnotes - either "DF", "ND" or ""
  </retvals>
  <chapter_context>
    Project Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_video_engine.lua</source_document>
  <tags>project settings, get, framerate</tags>
</US_DocBloc>
]]
  local framerate=reaper.SNM_GetIntConfigVar("projfrbase", -999)
  local subframerate=reaper.SNM_GetIntConfigVar("projfrdrop", -999)
  if     subframerate==1 then return 29.97, "DF"
  elseif subframerate==2 then return 23.976, ""
  elseif subframerate==2 then return 29.97, "ND"
  else return framerate, ""
  end
end

function ultraschall.ProjectSettings_SetVideoFramerate(framerate, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ProjectSettings_SetVideoFramerate</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ProjectSettings_SetVideoFramerate(integer framerate, boolean persist)</functioncall>
  <description>
    sets the video-framerate of the current project and optionally the default video-framerate for new projects
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer framerate - the framerate in fps from 1 to 999999999;
                      - 0, 29.97 fps DF
                      - -1, 23.976 fp
                      - -2, 29.97 fps ND
    boolean persist - true, set these values as default for new projects; false, don't set these values as defaults for 
  </parameters>
  <chapter_context>
    Project Settings
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_video_engine.lua</source_document>
  <tags>project settings, set, framerate, default projects</tags>
</US_DocBloc>
]]
  if math.type(framerate)~="integer" then ultraschall.AddErrorMessage("ProjectSettings_SetVideoFramerate", "framerate", "must be an integer", -1) return false end
  if framerate<-2 or framerate>999999999 then ultraschall.AddErrorMessage("ProjectSettings_SetVideoFramerate", "framerate", "must be between -2 and 999999999", -2) return false end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("ProjectSettings_SetVideoFramerate", "persist", "must be a boolean", -3) return false end
  if     framerate==0  then framerate=30 subframerate=1 -- 29.97 fps DF
  elseif framerate==-1 then framerate=24 subframerate=2 -- 23.976 fps 
  elseif framerate==-2 then framerate=30 subframerate=2 -- 29.97 fps ND
  else subframerate=0
  end
  reaper.SNM_SetIntConfigVar("projfrbase", framerate)
  reaper.SNM_SetIntConfigVar("projfrdrop", subframerate)  
  if persist==true then
    reaper.BR_Win32_WritePrivateProfileString("REAPER", "projfrbase", framerate, reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("REAPER", "projfrdrop", subframerate, reaper.get_ini_file())
  end
  return true
end

--A=ultraschall.ProjectSettings_SetVideoFramerate(11, true)
