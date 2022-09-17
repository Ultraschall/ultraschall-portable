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
---         ReaMote Module        ---
-------------------------------------


function ultraschall.AutoSearchReaMoteClients()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoSearchReaMoteClients</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>ultraschall.AutoSearchReaMoteClients()</functioncall>
  <description>
    Auto-searches for new ReaMote-clients
  </description>
  <chapter_context>
    ReaMote
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaMote_Module.lua</source_document>
  <tags>reamote, scan, search, clients</tags>
</US_DocBloc>
--]]
  local hwnd, hwnd1, hwnd2, retval, prefspage, reopen, id
  local use_prefspage=227
  id=1076
  hwnd = ultraschall.GetPreferencesHWND()
  if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) reopen=true end
  retval, prefspage = reaper.BR_Win32_GetPrivateProfileString("REAPER", "prefspage", "-1", reaper.get_ini_file())
  reaper.ViewPrefs(use_prefspage, 0)
  hwnd = ultraschall.GetPreferencesHWND()
  hwnd1=reaper.JS_Window_FindChildByID(hwnd, 0)
  hwnd2=reaper.JS_Window_FindChildByID(hwnd1, id)
  reaper.JS_WindowMessage_Send(hwnd2, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(hwnd2, "WM_LBUTTONUP", 1,1,1,1)

  if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) end
  retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "prefspage", prefspage, reaper.get_ini_file())
  reaper.ViewPrefs(prefspage, 0) 

  if reopen~=true then 
    hwnd = ultraschall.GetPreferencesHWND() 
    if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) end
  end
end

function ultraschall.AutoSearchReaMoteSlaves()
  local hwnd, hwnd1, hwnd2, retval, prefspage, reopen, id
  local use_prefspage=227
  id=1076
  hwnd = ultraschall.GetPreferencesHWND()
  if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) reopen=true end
  retval, prefspage = reaper.BR_Win32_GetPrivateProfileString("REAPER", "prefspage", "-1", reaper.get_ini_file())
  reaper.ViewPrefs(use_prefspage, 0)
  hwnd = ultraschall.GetPreferencesHWND()
  hwnd1=reaper.JS_Window_FindChildByID(hwnd, 0)
  hwnd2=reaper.JS_Window_FindChildByID(hwnd1, id)
  reaper.JS_WindowMessage_Send(hwnd2, "WM_LBUTTONDOWN", 1,1,1,1)
  reaper.JS_WindowMessage_Send(hwnd2, "WM_LBUTTONUP", 1,1,1,1)

  if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) end
  retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "prefspage", prefspage, reaper.get_ini_file())
  reaper.ViewPrefs(prefspage, 0) 

  if reopen~=true then 
    hwnd = ultraschall.GetPreferencesHWND() 
    if hwnd~=nil then reaper.JS_Window_Destroy(hwnd) end
  end
end

--ultraschall.AutoSearchReaMoteSlaves()

