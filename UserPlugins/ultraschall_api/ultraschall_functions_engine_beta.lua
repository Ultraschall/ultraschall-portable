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

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
end

function ultraschall.SplitStringAtNULLBytes(splitstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitStringAtNULLBytes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>integer count, array split_strings = ultraschall.SplitStringAtNULLBytes(string splitstring)</functioncall>
  <description>
    Splits splitstring into individual string at NULL-Bytes.
  </description>
  <retvals>
    integer count - the number of found strings
    array split_strings - the found strings put into an array
  </retvals>
  <parameters>
    string splitstring - the string with NULL-Bytes(\0) into it, that you want to split
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, split, string, nullbytes</tags>
</US_DocBloc>
]]
  if type(splitstring)~="string" then ultraschall.AddErrorMessage("SplitStringAtNULLBytes", "splitstring", "Must be a string.", -1) return -1 end
  -- add a NULL-Byte at the end, helps us finding the end of the string later
  splitstring=splitstring.."\0"
  local count=0
  local strings={}
  local temp, offset
  
  -- let's split the string
  while splitstring~=nil do
    -- find the next string-part
    temp,offset=splitstring:match("(.-)()\0")    
    if temp~=nil then 
      -- if the next found string isn't nil, then add it fo strings-array and count+1
      count=count+1 
      strings[count]=temp
      splitstring=splitstring:sub(offset+1,-1)
    else 
      -- if temp is nil, the string is probably finished splitting
      break 
    end
  end
  return count, strings
end

--A,B=ultraschall.SplitStringAtNULLBytes("splitstrin\0g\0\0\0\0")

function ultraschall.GetLastPlayState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastPlayState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number last_play_state = ultraschall.GetLastPlayState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last playstate before the current one. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    number last_play_state - the last playstate before the current one; -1, in case of an error
                           - Either bitwise: 
                           -    &1=playing
                           -    &2=pause
                           -    &=4 is recording
                           - or 
                           -    0, stop 
                           -    1, play 
                           -    2, paused play 
                           -    5, recording 
                           -    6, paused recording
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>navigation, last playstate, editcursor</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_playstate.lua")~="true" then return -1 end
  return tonumber(reaper.GetExtState("ultraschall", "last_playstate"))
end
--ultraschall.RunBackgroundHelperFeatures()
--A=ultraschall.GetLastPlayState()

ultraschall.ShowLastErrorMessage()
