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


if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "VID-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "VID-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
end

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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, window, coordinates, pixel, ui_get_state, video-processor, convert</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" or x<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "x", "must be an integer>0", -1) return end
  if math.type(y)~="integer" or y<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "y", "must be an integer>0", -2) return end
  if math.type(videowindow_width)~="integer" or videowindow_width<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_width", "must be an integer>0", -3) return end
  if math.type(videowindow_height)~="integer" or videowindow_height<0 then ultraschall.AddErrorMessage("VID_VideoUIStateCoords2Pixels", "videowindow_height", "must be an integer>0", -4) return end
  
  return x/videowindow_width, x/videowindow_height
end

