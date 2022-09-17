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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---      TrackManager Module      ---
-------------------------------------

function ultraschall.TrackManager_ClearFilter()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_ClearFilter</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackManager_ClearFilter()</functioncall>
  <description>
    clears the filter of the trackmanager, if the window is opened.
    
    returns false if Track Manager is closed
  </description>
  <retvals>
    boolean retval - true, clearing was successful; false, clearing was unsuccessful
  </retvals>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, clear, filter</tags>
</US_DocBloc>
--]]
  local tm_hwnd=ultraschall.GetTrackManagerHWND()
  if tm_hwnd==nil then ultraschall.AddErrorMessage("TrackManager_ClearFilter", "", "Track Manager not opened", -1) return false end
  local button=reaper.JS_Window_FindChildByID(tm_hwnd, 1056)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONUP", 1,1,1,1)
  return true
end

function ultraschall.TrackManager_ShowAll()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_ShowAll</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackManager_ShowAll()</functioncall>
  <description>
    shows all tracks, if the window is opened.
    
    returns false if Track Manager is closed
  </description>
  <retvals>
    boolean retval - true, showall was successful; false, showall was unsuccessful
  </retvals>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, show, all</tags>
</US_DocBloc>
--]]
  local tm_hwnd=ultraschall.GetTrackManagerHWND()
  if tm_hwnd==nil then ultraschall.AddErrorMessage("TrackManager_ShowAll", "", "Track Manager not opened", -1) return false end
  local button=reaper.JS_Window_FindChildByID(tm_hwnd, 1058)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONUP", 1,1,1,1)
  return true
end

function ultraschall.TrackManager_SelectionFromProject()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_SelectionFromProject</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackManager_SelectionFromProject()</functioncall>
  <description>
    sets trackselection in trackmanager to the trackselection from the project, if the trackmanager-window is opened.
    
    returns false if Track Manager is closed
  </description>
  <retvals>
    boolean retval - true, setting selection was successful; false, setting selection was unsuccessful
  </retvals>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, set, selection, from project</tags>
</US_DocBloc>
--]]
  local tm_hwnd=ultraschall.GetTrackManagerHWND()
  if tm_hwnd==nil then ultraschall.AddErrorMessage("TrackManager_SelectionFromProject", "", "Track Manager not opened", -1) return false end
  local button=reaper.JS_Window_FindChildByID(tm_hwnd, 1057)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONUP", 1,1,1,1)
  return true
end

function ultraschall.TrackManager_SelectionFromList()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_SelectionFromList</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackManager_SelectionFromList()</functioncall>
  <description>
    sets trackselection from trackmanager into the trackselection of the project, if the trackmanager-window is opened.
    
    returns false if Track Manager is closed
  </description>
  <retvals>
    boolean retval - true, setting selection was successful; false, setting selection was unsuccessful
  </retvals>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, set, selection, to project</tags>
</US_DocBloc>
--]]
  local tm_hwnd=ultraschall.GetTrackManagerHWND()
  if tm_hwnd==nil then ultraschall.AddErrorMessage("TrackManager_SelectionFromList", "", "Track Manager not opened", -1) return false end
  local button=reaper.JS_Window_FindChildByID(tm_hwnd, 1062)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(button, "WM_LBUTTONUP", 1,1,1,1)
  return true
end

function ultraschall.TrackManager_SetFilter(filter)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_SetFilter</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackManager_SetFilter(string filter)</functioncall>
  <description>
    sets filter of the trackmanager, if the trackmanager-window is opened.
    
    returns false if Track Manager is closed
  </description>
  <retvals>
    boolean retval - true, setting filter was successful; false, setting filter was unsuccessful
  </retvals>
  <parameters>
    string filter - the new filter-phrase to be set 
  </parameters>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, set, filter</tags>
</US_DocBloc>
--]]
  if ultraschall.type(filter)~="string" then ultraschall.AddErrorMessage("TrackManager_SetFilter", "filter", "must be a string", -1) return false end
  local tm_hwnd=ultraschall.GetTrackManagerHWND()
  if tm_hwnd==nil then ultraschall.AddErrorMessage("TrackManager_SelectionFromList", "", "Track Manager not opened", -2) return false end
  local button=reaper.JS_Window_FindChildByID(tm_hwnd, 1007)
  reaper.JS_Window_SetTitle(button, filter)
  return true
end

function ultraschall.TrackManager_OpenClose(toggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackManager_OpenClose</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional boolean new_toggle_state = ultraschall.TrackManager_OpenClose(optional boolean toggle)</functioncall>
  <description>
    opens/closes the trackmanager
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, opening/closing was successful; false, there was an error
    optional boolean new_toggle_state - true, track manager is opened; false, track manager is closed
  </retvals>
  <parameters>
    optional boolean toggle - true, open the track manager; false, close the track manager; nil, just toggle open/close of the trackmanager
  </parameters>
  <chapter_context>
    TrackManager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManager_Module.lua</source_document>
  <tags>trackmanager, open, close</tags>
</US_DocBloc>
--]]
  if toggle~=nil and ultraschall.type(toggle)~="boolean" then ultraschall.AddErrorMessage("TrackManager_OpenClose", "toggle", "must be a boolean", -1) return false end
  local state=reaper.GetToggleCommandState(40906)
  if (state==0 and toggle==true) or
     (state==1 and toggle==false) then
    reaper.Main_OnCommand(40906,0)
  elseif toggle==nil then
    reaper.Main_OnCommand(40906,0)
    if state==0 then return true, true else return true, false end
  end
  return true, toggle
end

--A,B=ultraschall.TrackManager_OpenClose()

