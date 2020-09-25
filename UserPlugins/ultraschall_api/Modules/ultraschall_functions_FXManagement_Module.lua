--[[
################################################################################
# 
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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
---     FX Management Module      ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string3 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string3 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "FXManagement-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string3=="" then string3=10000 
  else 
    string3=tonumber(string3) 
    string3=string3+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end 
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string3, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end


function ultraschall.IsValidFXStateChunk(StateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidFXStateChunk(string StateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns, if a StateChunk is a valid FXStateChunk.
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, it is a valid FXStateChunk; false, it is not
  </retvals>
  <parameters>
    string StateChunk - the StateChunk, which you want to check, whether it's a valid FXStateChunk
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, check, isvalid, fxstatechunk</tags>
</US_DocBloc>
]]
  if type(StateChunk)~="string" then ultraschall.AddErrorMessage("IsValidFXStateChunk", "StateChunk", "Must be a string", -1) return false end
  StateChunk=StateChunk.."\n "
  if StateChunk:match("^%s-<FXCHAIN.-\n->")==nil and StateChunk:match("^%s-<TAKEFX.-\n->")==nil then ultraschall.AddErrorMessage("IsValidFXStateChunk", "StateChunk", "Not a valid FXStateChunk", -2) return false end
  return true
end

--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--A=ultraschall.GetFXStateChunk(SC, 1)
--B=ultraschall.IsValidFXStateChunk(A)



function ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXFromFXStateChunk</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string fx_lines, integer startoffset, integer endoffset = ultraschall.GetFXFromFXStateChunk(string FXStateChunk, integer fxindex)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the statechunk-lines of fx with fxindex from an FXStateChunk
      
      It also returns the start and endoffset of these lines, so you can manipulate these lines and replace them in the
      original FXStateChunk, by replacing the part between start and endoffset with your altered lines.
      
      returns nil in case of an error
    </description>
    <retvals>
      string fx_lines - the statechunk-lines associated with this fx
      integer startoffset - the startoffset in bytes of these lines within the FXStateChunk
      integer endoffset - the endoffset in bytes of these lines within the FXStateChunk
    </retvals>
    <parameters>
      string FXStateChunk - the FXStateChunk from which you want to retrieve the fx's-lines
      integer fxindex - the index of the fx, whose statechunk lines you want to retrieve; with 1 for the first
    </parameters>
    <chapter_context>
      FX-Management
      Get States
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, get, fxlines, fxstatechunk</tags>
  </US_DocBloc>
  --]] 
  -- returns the individual fx-statechunk-lines and the start/endoffset of these lines within the FXStateChunk
  -- so its easy to manipulate the stuff
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXFromFXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return end
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("GetFXFromFXStateChunk", "fxindex", "must be an integer", -2) return end
  local index=0
  for a,b,c in string.gmatch(FXStateChunk, "()(%s-BYPASS.-\n.-WAK.-)\n()") do
    index=index+1
    if index==fxindex then return b,a,c end
  end
  return nil
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC, 1)
--SC=ultraschall.GetFXFromFXStateChunk(SC, 2)
--B=ultraschall.IsValidFXStateChunk(A)
--print2(SC)
--print2("L"..string.gsub(A:match("\n.-\n(.*==)"),"%c","").."L")

--for i=1, 1000 do
--  A=ultraschall.Base64_Decoder("AAB6QwAAAACCEt6+ghJev+GNpr+CEt6/kcsKwOGNJsAxUELAghJewNLUecCRy4rAuayYwOGNpsAJb7TAMVDCwFkx0MCCEt7AqvPrwNLU+cD92gPBkcsKwSW8EcG5rBjBTZ0fweGNJsF1fi3BCW80wZ1fO8ExUELBxUBJwVkxUMHtIVfBghJewRYDZcGq82vBPuRywdLUecGzYoDB/dqDwUdTh8GRy4rB20OOwSW8kcFvNJXBuayYwQMlnMFNnZ/BlxWjweGNpsErBqrBdX6twb/2sMEJb7TBU+e3wZ1fu8Hn177BMVDCwXvIxcHFQMnBD7nMwVkx0MGjqdPB7SHXwTia2sGCEt7BzIrhwRYD5cFge+jBqvPrwfRr78E+5PLBiFz2wdLU+cHHsvrBfLX1wWFB78GSb+jBVobhwT+X2sGxptPBxbXMwcLExcG5077BruK3waTxsMGZAKrBjg+jwYMenMF4LZXBbTyOwWJLh8FXWoDBmdJywYPwZMFtDlfBVyxJwUJKO8EsaC3BFoYfwQCkEcHqwQPBqb/rwH37z8BSN7TAJnOYwPVdecCe1UHARk0KwN6Jpb9NrBy/4A6cvtkhlr3L3ok7Mm6dPV+oPD7yQa0+MWALP/o1Tj9m348/tznAP29T+D8CIBxAtfw/QFauZ0DJiYlAFv2gQD8PukDDldRA2V3wQJeWBkGAYRVBxmwkQd+TM0GIsUJBvqBRQbM9YEG2Zm5B9Px7QZFyhEH3g4pBJSmQQcJalUGcE5pBjlCeQVcQokFqU6VBtRuoQWJsqkGcSaxBW7itQSe+rkHrYK9Bz6avQQ2Wr0HbNK9BTomuQUmZrUFxaqxBIgKrQWZlqUH3mKdBO6GlQUKCo0HMP6FBS92eQeVdnEF5xJlBpxOXQctNlEEPdZFBYouOQYaSi0ERjIhBbnmFQeZbgkE9aX5BQgl4QbSZcUE8HGtBVpJkQVj9XUFxXldBs7ZQQREHSkFlUENBcJM8QeLQNUFUCS9BUj0oQVdtIUHRmRpBIsMTQaLpDEGfDQZBwV7+QEWe8EA72uJABhPVQP1Ix0BwfLlApa2rQNrcnUBHCpBAHTaCQBLBaEBlE01AeGMxQIqxFUCm+/M/C5G8P5kjhT9DZxs/SgsyPkHLhL6mUTG/biCQv3OZx7+9E/+/k0cbwMkFN8BxxFLAf4NuwHQhhcBRAZPAUuGgwHPBrsCxobzACILKwHZi2MD4QubAjSP0wBkCAcFy8gfB0uIOwTfTFcGiwxzBEbQjwYSkKsH7lDHBdYU4wfF1P8FxZkbB8lZNwXZHVMH7N1vBgihiwQsZacGUCXDBUGZ1wScOd8EAAAAAAADYwg=="):sub(i,i)
--  print_alt(A)
--end

function ultraschall.GetParmLearn_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-learn-setting from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is the PARMLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      -   being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...
                      -         
                      -   CC Mode-dropdownlist:
                      -      set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -       &65536 &131072 &262144 
                      -          0       0       0,      Absolute
                      -          1       0       0,      Relative 1(127=-1, 1=+1)
                      -          0       1       0,      Relative 2(63=-1, 65=+1)
                      -          1       1       0,      Relative 3(65=-1, 1=+1)
                      -          0       0       1,      Toggle (>0=toggle)
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLearn
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmLearn-settings
    integer fxid - the fx, of which you want to get the parameter-learn-settings
    integer id - the id of the ParmLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, fxstatechunk, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local name=""
  local idx, midi_note, checkboxes
  for w in string.gmatch(FXStateChunk, "PARMLEARN.-\n") do
    count=count+1    
    if count==id then 
      w=w:sub(1,-2).." " 
      idx, midi_note, checkboxes, osc_message = w:match(" (.-) (.-) (.-) (.*) ") 
      if tonumber(idx)==nil then 
        idx, name = w:match(" (.-):(.-) ")
      end
      break
    end
  end
  if osc_message=="" then osc_message=nil end
  if idx==nil then return end
  return tonumber(idx), name, tonumber(midi_note), tonumber(checkboxes), osc_message
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC, 1)
--O,OO,OOO,OOOO=ultraschall.GetParmLearn_FXStateChunk(SC, 2, 1)
--ultraschall.ShowLastErrorMessage()


function ultraschall.GetParmLearn_MediaItem(MediaItem, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_MediaItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLearn_MediaItem(MediaItem MediaItem, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-learn-setting from a MediaItem
    
    It is the PARMLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      -   being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...
                      -         
                      -   CC Mode-dropdownlist:
                      -      set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -       &65536 &131072 &262144 
                      -          0       0       0,      Absolute
                      -          1       0       0,      Relative 1(127=-1, 1=+1)
                      -          0       1       0,      Relative 2(63=-1, 65=+1)
                      -          1       1       0,      Relative 3(65=-1, 1=+1)
                      -          0       0       1,      Toggle (>0=toggle)
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLearn
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose ParmLearn-setting you want to get
    integer fxid - the fx, of which you want to get the parameter-learn-settings
    integer id - the id of the ParmLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, mediaitem, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetParmLearn_MediaItem", "MediaItem", "Not a valid MediaItem", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaItem", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaItem", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetItemStateChunk(MediaItem, "", false)
  local FXStateChunk=ultraschall.GetFXStateChunk(A)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLearn_MediaItem", "MediaItem", "Has no FX-chain", -4) return nil end
  
  return ultraschall.GetParmLearn_FXStateChunk(FXStateChunk, fxid, id)
end

--A1,B,C,D,E,F,G=ultraschall.GetParmLearn_MediaItem(reaper.GetMediaItem(0,0), 2, 1)

function ultraschall.GetParmLearn_MediaTrack(MediaTrack, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_MediaTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLearn_MediaTrack(MediaTrack MediaTrack, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-learn-setting from a MediaTrack
    
    It is the PARMLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      -   being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...
                      -         
                      -   CC Mode-dropdownlist:
                      -      set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -       &65536 &131072 &262144 
                      -          0       0       0,      Absolute
                      -          1       0       0,      Relative 1(127=-1, 1=+1)
                      -          0       1       0,      Relative 2(63=-1, 65=+1)
                      -          1       1       0,      Relative 3(65=-1, 1=+1)
                      -          0       0       1,      Toggle (>0=toggle)
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLearn
  </retvals>
  <parameters>
    MediaTrack MediaTrack - the MediaTrack, whose ParmLearn-setting you want to get
    integer fxid - the fx, of which you want to get the parameter-learn-settings
    integer id - the id of the ParmLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, mediatrack, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "MediaTrack", "Not a valid MediaTrack", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetTrackStateChunk(MediaTrack, "", false)
  A=ultraschall.GetFXStateChunk(A, 1)
  if A==nil then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "MediaTrack", "Has no FX-chain", -4) return nil end
  
  return ultraschall.GetParmLearn_FXStateChunk(A, fxid, id)
end

--A1,B,C,D,E,F,G=ultraschall.GetParmLearn_MediaTrack(reaper.GetTrack(0,0), 1, 2)


-- mespotine

function ultraschall.GetParmAlias_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmAlias_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parm_aliasname = ultraschall.GetParmAlias_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-alias-setting from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Parameter-aliases are only stored for MediaTracks.
    
    It is the PARMALIAS-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parm_aliasname - the alias-name of the parameter
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmAlias-settings
    integer fxid - the fx, of which you want to get the parameter-alias-settings
    integer id - the id of the ParmAlias-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, alias, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmAlias_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmAlias_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmAlias_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmAlias_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local aliasname=""
  local idx
  for w in string.gmatch(FXStateChunk, "PARMALIAS.-\n") do
    count=count+1    
    if count==id then 
      w=w:sub(1,-2).." " 
      idx, aliasname = w:match(" (.-) (.*) ") 
      if tonumber(idx)==nil then 
        idx, aliasname = w:match(" (.-):(.-) ")
      end
      break
    end
  end
  if osc_message=="" then osc_message=nil end
  if idx==nil then return end
  return tonumber(idx), aliasname
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC, 1)
--O,OO,OOO,OOOO=ultraschall.GetParmAlias_FXStateChunk(SC, 1, 1)
--ultraschall.ShowLastErrorMessage()



function ultraschall.GetParmAlias_MediaTrack(MediaTrack, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmAlias_MediaTrack</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parm_aliasname = ultraschall.GetParmAlias_MediaTrack(MediaTrack MediaTrack, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-aliasname-setting from a MediaTrack
    
    It is the PARMALIAS-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parm_aliasname - the alias-name of the parameter
  </retvals>
  <parameters>
    MediaTrack MediaTrack - the MediaTrack, whose ParmAlias-setting you want to get
    integer fxid - the fx, of which you want to get the parameter-alias-settings
    integer id - the id of the ParmAlias-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, alias, mediatrack</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("GetParmAlias_MediaTrack", "MediaTrack", "Not a valid MediaTrack", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmAlias_MediaTrack", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmAlias_MediaTrack", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetTrackStateChunk(MediaTrack, "", false)
  A=ultraschall.GetFXStateChunk(A, 1)
  if A==nil then ultraschall.AddErrorMessage("GetParmAlias_MediaTrack", "MediaTrack", "Has no FX-chain", -4) return nil end
  
  return ultraschall.GetParmAlias_FXStateChunk(A, fxid, id)
end

--A1,B,C,D,E,F,G=ultraschall.GetParmAlias_MediaTrack(reaper.GetTrack(0,0), 2, 1)

function ultraschall.GetParmModulationChunk_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmModulationChunk_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string parm_modulation_chunk = ultraschall.GetParmModulationChunk_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-modulation-chunk from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It's the <PROGRAMENV entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    string parm_modulation_chunk - a chunk of the parameter-modulation settings
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the Parameter-modulation-settings
    integer fxid - the fx, of which you want to get the parameter-modulation-chunk-settings
    integer id - the id of the Parameter-modulation you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Modulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, modulation, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmModulationChunk_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmModulationChunk_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmModulationChunk_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmModulationChunk_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local aliasname=""
  local idx
  for w in string.gmatch(FXStateChunk, "<PROGRAMENV.-\n.->") do
    --print2(w)
    count=count+1    
    if count==id then 
      return w 
    end
  end
  if osc_message=="" then osc_message=nil end
  if idx==nil then return end
  return tonumber(idx), aliasname
end


function ultraschall.GetParmLFOLearn_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLFOLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLFOLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-lfo-learn-setting from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is the LFOLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      - being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...        
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmLFOLearn-settings
    integer fxid - the fx, of which you want to get the parameter-lfo-learn-settings
    integer id - the id of the ParmLFOLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, lfo, fxstatechunk, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLFOLearn_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLFOLearn_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local name=""
  local idx, midi_note, checkboxes
  for w in string.gmatch(FXStateChunk, "LFOLEARN.-\n") do
    count=count+1    
    if count==id then 
      w=w:sub(1,-2).." " 
      idx, midi_note, checkboxes, osc_message = w:match(" (.-) (.-) (.-) (.*) ") 
      if tonumber(idx)==nil then 
        idx, name = w:match(" (.-):(.-) ")
      end
      break
    end
  end
  if osc_message=="" then osc_message=nil end
  if idx==nil then return end
  return tonumber(idx), name, tonumber(midi_note), tonumber(checkboxes), osc_message
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC, 1)
--O,OO,OOO,OOOO=ultraschall.GetParmLFOLearn_FXStateChunk(SC, 1, 1)
--ultraschall.ShowLastErrorMessage()


function ultraschall.GetParmLFOLearn_MediaItem(MediaItem, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLFOLearn_MediaItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLFOLearn_MediaItem(MediaItem MediaItem, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-lfo-learn-setting from a MediaItem
    
    It is the LFOLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      - being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...        
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose ParmLFOLearn-setting you want to get
    integer fxid - the fx, of which you want to get the parameter-lfo-learn-settings
    integer id - the id of the ParmLFOLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, mediaitem, osc, midi, lfo</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaItem", "MediaItem", "Not a valid MediaItem", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaItem", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaItem", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetItemStateChunk(MediaItem, "", false)
  local FXStateChunk=ultraschall.GetFXStateChunk(A)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaItem", "MediaItem", "Has no FX-chain", -4) return nil end
  
  return ultraschall.GetParmLFOLearn_FXStateChunk(FXStateChunk, fxid, id)
end

--A1,B,C,D,E,F,G=ultraschall.GetParmLFOLearn_MediaItem(reaper.GetMediaItem(0,0), 1, 1)

function ultraschall.GetParmLFOLearn_MediaTrack(MediaTrack, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLFOLearn_MediaTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLFOLearn_MediaTrack(MediaTrack MediaTrack, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-lfo-learn-setting from a MediaTrack
    
    It is the LFOLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only wet or bypass
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      - being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...        
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          - 0, no checkboxes
                          - 1, enable only when track or item is selected
                          - 2, Soft takeover (absolute mode only)
                          - 3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          - 4, enable only when effect configuration is focused
                          - 20, enable only when effect configuration is visible
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn
  </retvals>
  <parameters>
    MediaTrack MediaTrack - the MediaTrack, whose ParmLFOLearn-setting you want to get
    integer fxid - the fx, of which you want to get the parameter-lfo-learn-settings
    integer id - the id of the ParmLFOLearn-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, mediatrack, osc, midi, lfo</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaTrack", "MediaTrack", "Not a valid MediaTrack", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaTrack", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaTrack", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetTrackStateChunk(MediaTrack, "", false)
  A=ultraschall.GetFXStateChunk(A, 1)
  if A==nil then ultraschall.AddErrorMessage("GetParmLFOLearn_MediaTrack", "MediaTrack", "Has no FX-chain", -4) return nil end
  
  return ultraschall.GetParmLFOLearn_FXStateChunk(A, fxid, id)
end

--A1,B,C,D,E,F,G=ultraschall.GetParmLFOLearn_MediaTrack(reaper.GetTrack(0,0), 1, 1)

function ultraschall.GetParmAudioControl_FXStateChunk(FXStateChunk, fxid, id)
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmAudioControls_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmAudioControls_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmAudioControls_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  local FXStateChunk1
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmAudioControls_FXStateChunk", "fxid", "no such fx", -4) return nil end
  
  local count=0
  for w in string.gmatch(FXStateChunk, "<PROGRAMENV.->") do
    count=count+1
    if count==id then
      FXStateChunk1=w
      break
    end
  end
  if FXStateChunk1==nil then ultraschall.AddErrorMessage("GetParmAudioControls_FXStateChunk", "id", "no such parameter modulation-setting", -5) return nil end
  local parmname
  local parmidx, enable_parameter_modulation_checkbox = FXStateChunk1:match("<PROGRAMENV (.-) (.-)\n")
  if parmidx:match(":")~=nil then parmidx, parmname=parmidx:match("(.-):(.*)") else parmname="" end
  local PARAMBASE=tonumber(FXStateChunk1:match("PARAMBASE (.-)\n"))
  
  local AUDIOCTL=tonumber(FXStateChunk1:match("AUDIOCTL (.-)\n"))
  local AudioCTL_Strength_slider, AudioCTL_direction_radiobuttons=FXStateChunk1:match("AUDIOCTLWT (.-) (.-)\n")
  
  local CHAN=tonumber(FXStateChunk1:match("CHAN (.-)\n"))
  local STEREO=tonumber(FXStateChunk1:match("STEREO (.-)\n"))
  local RMS_attack, RMS_release = FXStateChunk1:match("RMS (.-) (.-)\n")
  local DBLO=tonumber(FXStateChunk1:match("DBLO (.-)\n"))
  local DBHI=tonumber(FXStateChunk1:match("DBHI (.-)\n"))
  local X2=tonumber(FXStateChunk1:match("X2 (.-)\n"))
  local Y2=tonumber(FXStateChunk1:match("Y2 (.-)\n"))
  
  return tonumber(parmidx), parmname, tonumber(enable_parameter_modulation_checkbox), PARAMBASE, AUDIOCTL, tonumber(AudioCTL_Strength_slider), 
         tonumber(AudioCTL_direction_radiobuttons), CHAN, STEREO, tonumber(RMS_attack), tonumber(RMS_release), DBLO, DBHI, X2, Y2
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC)
--print2(SC)
--A={ultraschall.GetParmAudioControl_FXStateChunk(SC,1,2)}


function ultraschall.GetParmLFO_FXStateChunk(FXStateChunk, fxid, id)
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLFO_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLFO_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLFO_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  local FXStateChunk1
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLFO_FXStateChunk", "fxid", "no such fx", -4) return nil end
  
  local count=0
  for w in string.gmatch(FXStateChunk, "<PROGRAMENV.->") do
    count=count+1
    if count==id then
      FXStateChunk1=w
      break
    end
  end
  -- print2(FXStateChunk1)
  if FXStateChunk1==nil then ultraschall.AddErrorMessage("GetParmLFO_FXStateChunk", "id", "no such parameter modulation-setting", -5) return nil end
  local parmname
  local parmidx, enable_parameter_modulation_checkbox = FXStateChunk1:match("<PROGRAMENV (.-) (.-)\n")
  if parmidx:match(":")~=nil then parmidx, parmname=parmidx:match("(.-):(.*)") else parmname="" end
  local PARAMBASE=tonumber(FXStateChunk1:match("PARAMBASE (.-)\n"))
  
  local LFO=tonumber(FXStateChunk1:match("LFO (.-)\n"))
  local LFO_Strength_slider, LFO_direction_radiobuttons=FXStateChunk1:match("LFOWT (.-) (.-)\n")
  
  local LFOSHAPE=tonumber(FXStateChunk1:match("LFOSHAPE (.-)\n"))
  local TempoSync_checkbox, unknown, phase_reset_dropdownlist= FXStateChunk1:match("LFOSYNC (.-) (.-) (.-)\n")
  local LFOSPEED_slider, LFOSPEED_phase = FXStateChunk1:match("LFOSPEED (.-) (.-)\n")
  
  --integer lfo, number lfo_strength, integer lfo_direction, integer lfo_shape, integer temposync, integer unknown, integer phase_reset, number lfo_speed, number lfo_speedphase
  
  return tonumber(parmidx), parmname, tonumber(enable_parameter_modulation_checkbox), PARAMBASE, LFO, tonumber(LFO_Strength_slider), 
         tonumber(LFO_direction_radiobuttons), LFOSHAPE, tonumber(TempoSync_checkbox), tonumber(unknown), tonumber(phase_reset_dropdownlist),
         tonumber(LFOSPEED_slider), tonumber(LFOSPEED_phase)
end

--temp, SC=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--temp, SC=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--SC=ultraschall.GetFXStateChunk(SC)
--print2(SC)
--A={ultraschall.GetParmLFO_FXStateChunk(SC,1,1)}


-- integer parmidx, string parmname, boolean plink_enabled, number scale, integer midi_fx_idx, integer midi_fx_idx2, integer linked_parmidx, number offset, optional integer bus, optional integer channel, optional integer category, optional integer midi_note
function ultraschall.GetParmMIDIPLink_FXStateChunk(FXStateChunk, fxid, id)
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmMIDIPLink_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmMIDIPLink_FXStateChunk", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmMIDIPLink_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  local FXStateChunk1
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmMIDIPLink_FXStateChunk", "fxid", "no such fx", -4) return nil end
  
  local count=0
  for w in string.gmatch(FXStateChunk, "<PROGRAMENV.->") do
    count=count+1
    if count==id then
      FXStateChunk1=w
      break
    end
  end
  -- print2(FXStateChunk1)
  if FXStateChunk1==nil then ultraschall.AddErrorMessage("GetParmMIDIPLink_FXStateChunk", "id", "no such parameter modulation-setting", -5) return nil end
  local parmname
  local parmidx, enable_parameter_modulation_checkbox = FXStateChunk1:match("<PROGRAMENV (.-) (.-)\n")
  if parmidx:match(":")~=nil then parmidx, parmname=parmidx:match("(.-):(.*)") else parmname="" end
  local PARAMBASE=tonumber(FXStateChunk1:match("PARAMBASE (.-)\n"))
  if FXStateChunk1:match("\n      PLINK ")==nil then return tonumber(parmidx), parmname, tonumber(enable_parameter_modulation_checkbox), PARAMBASE, false end
  
  local scale, midi_fx_idx, parmidx2, offset = FXStateChunk1:match("PLINK (.-) (.-) (.-) (.-)\n")
  local bus, channel, category, midi_note, midi_fx_idx2
  if tonumber(midi_fx_idx)==nil then midi_fx_idx, midi_fx_idx2 = midi_fx_idx:match("(.-):(.*)") else midi_fx_idx2=midi_fx_idx end
  if tonumber(midi_fx_idx)==-100 then
    bus, channel, category, midi_note = FXStateChunk1:match("MIDIPLINK (.-) (.-) (.-) (.-)\n")
  end
  
  return tonumber(parmidx), parmname, tonumber(enable_parameter_modulation_checkbox), PARAMBASE, true, 
         tonumber(scale), tonumber(midi_fx_idx), tonumber(midi_fx_idx2), tonumber(parmidx2), tonumber(offset), 
         tonumber(bus), tonumber(channel), tonumber(category), tonumber(midi_note)
end





function ultraschall.ScanDXPlugins(re_scan)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ScanDXPlugins</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>ultraschall.ScanDXPlugins(optional boolean re_scan)</functioncall>
  <description>
    (Re-)scans all DX-Plugins.
  </description>
  <parameters>
    optional boolean clear_cache - true, re-scan all DX-plugins; false or nil, only scan new DX-plugins
  </parameters>
  <chapter_context>
    FX-Management
    Plugins
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx-management, scan, plugins, dx</tags>
</US_DocBloc>
--]]
  local hwnd, hwnd1, hwnd2, retval, prefspage, reopen, id
  local use_prefspage=209
  if re_scan==true then id=1060 else id=1059 end
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

--ultraschall.ScanDXPlugins()


function ultraschall.DeleteParmLearn_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a ParmLearn-entry from an FXStateChunk.
  
    Unlike [DeleteParmLearn2\_FXStateChunk](#DeleteParmLearn2_FXStateChunk), this indexes by the already existing parmlearns and not by parameters.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmLearn from
    integer fxid - the id of the fx, which holds the to-delete-ParmLearn-entry; beginning with 1
    integer id - the id of the ParmLearn-entry to delete; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, parm, learn, delete, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "id", "must be an integer", -3) return false end
    
  local count=0
  local FX, UseFX2, start, stop  
  local UseFX, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)

  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMLEARN.-\n") do
      count=count+1
      if count==id then UseFX2=string.gsub(UseFX, k, "") break end
    end
  end

  if UseFX2~=nil then
    return true, FXStateChunk:sub(1, startoffset)..UseFX2:sub(2,-2)..FXStateChunk:sub(endoffset-1, -1)
  else
    return false, FXStateChunk
  end
end

--ultraschall.DeleteParmLearn_FXStateChunk(FXStateChunk, 1, 1)

function ultraschall.DeleteParmAlias_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmAlias_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmAlias_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a ParmAlias-entry from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmAlias from
    integer fxid - the id of the fx, which holds the to-delete-ParmAlias-entry; beginning with 1
    integer id - the id of the ParmAlias-entry to delete; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, parm, alias, delete, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("DeleteParmAlias_FXStateChunk", "id", "must be an integer", -3) return false end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMALIAS.-\n") do
      count=count+1
      if count==id then 
        start,stop=string.find(UseFX, k, 0, true)
        UseFX2=UseFX:sub(1,start-2)..UseFX:sub(stop,-1)
        break 
      end
    end
  end  
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false, FXStateChunk
  end
end
--ultraschall.DeleteParmAlias_FXStateChunk(FXStateChunk, 1, 1)

function ultraschall.DeleteParmLFOLearn_FXStateChunk(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmLFOLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmLFOLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a ParmLFO-Learn-entry from an FXStateChunk.
    
    It's the LFOLEARN-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmLFO-Learn-entry from
    integer fxid - the id of the fx, which holds the to-delete-ParmLFO-Learn-entry; beginning with 1
    integer id - the id of the ParmLFO-Learn-entry to delete; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, parm, lfo, delete, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmLFOLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmLFOLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("DeleteParmLFOLearn_FXStateChunk", "id", "must be an integer", -3) return false end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    LFOLEARN.-\n") do
      count=count+1
      if count==id then 
        start,stop=string.find(UseFX, k, 0, true)
        UseFX2=UseFX:sub(1,start-2)..UseFX:sub(stop,-1)
        break 
      end
    end
  end  
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false, FXStateChunk
  end
end

--ultraschall.DeleteParmAlias_FXStateChunk(FXStateChunk, 1, 1)

function ultraschall.SetParmLFOLearn_FXStateChunk(FXStateChunk, fxid, id, midi_note, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmLFOLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmLFOLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id, integer midi_note, integer checkboxflags, optional string osc_message)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing ParmLFO-Learn-entry of an FX-plugin from an FXStateChunk.
    
    It's the LFOLEARN-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLFO)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a ParmLFO-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-ParmLFO-Learn-entry; beginning with 1
    integer id - the id of the ParmLFO-Learn-entry to set; beginning with 1
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      - being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...        
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          -    0, no checkboxes
                          -    1, enable only when track or item is selected
                          -    2, Soft takeover (absolute mode only)
                          -    3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          -    4, enable only when effect configuration is focused
                          -    20, enable only when effect configuration is visible 
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parm, lfo, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "id", "must be an integer", -3) return false end    

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "osc_message", "must be either nil or a string", -4) return false end
  if math.type(midi_note)~="integer" then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "midi_note", "must be an integer", -5) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "checkboxflags", "must be an integer", -6) return false end
  
  if osc_message~=nil and midi_note~=0 then ultraschall.AddErrorMessage("SetParmLFOLearn_FXStateChunk", "midi_note", "must be set to 0, when using parameter osc_message", -7) return false end
  if osc_message==nil then osc_message="" end
  
  if checkboxflags&8==0 then checkboxflags=checkboxflags+8 end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    LFOLEARN.-\n") do
      count=count+1
      if count==id then 
        start,stop=string.find(UseFX, k, 0, true)
        UseFX2=UseFX:sub(1,start-2).."\n"..k:match("    LFOLEARN%s.-%s")..midi_note.." "..checkboxflags.." "..osc_message..""..UseFX:sub(stop,-1)
        break 
      end
    end
  end  
  
  if UseFX2~=nil then
    if osc_message==nil then osc_message="" end
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
  --]]
end

function ultraschall.SetParmLearn_FXStateChunk(FXStateChunk, fxid, id, midi_note, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer id, integer midi_note, integer checkboxflags, optional string osc_message)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    It's the PARMLEARN-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Learn-entry; beginning with 1
    integer id - the id of the Parm-Learn-entry to set; beginning with 1
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      -   being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...
                      -         
                      -   CC Mode-dropdownlist:
                      -      set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -       &65536 &131072 &262144 
                      -          0       0       0,      Absolute
                      -          1       0       0,      Relative 1(127=-1, 1=+1)
                      -          0       1       0,      Relative 2(63=-1, 65=+1)
                      -          1       1       0,      Relative 3(65=-1, 1=+1)
                      -          0       0       1,      Toggle (>0=toggle)
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          -    0, no checkboxes
                          -    1, enable only when track or item is selected
                          -    2, Soft takeover (absolute mode only)
                          -    3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          -    4, enable only when effect configuration is focused
                          -    20, enable only when effect configuration is visible 
    optional string osc_message - the osc-message, that triggers the ParmLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "id", "must be an integer", -3) return false end    

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "osc_message", "must be either nil or a string", -4) return false end
  if math.type(midi_note)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "midi_note", "must be an integer", -5) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "checkboxflags", "must be an integer", -6) return false end
  
  if osc_message~=nil and midi_note~=0 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "midi_note", "must be set to 0, when using parameter osc_message", -7) return false end
  if osc_message==nil then osc_message="" end
  
  if checkboxflags&8==8 then checkboxflags=checkboxflags-8 end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMLEARN.-\n") do
      count=count+1
      if count==id then 
        start,stop=string.find(UseFX, k, 0, true)
        UseFX2=UseFX:sub(1,start-2).."\n"..k:match("    PARMLEARN%s.-%s")..midi_note.." "..checkboxflags.." "..osc_message..""..UseFX:sub(stop,-1)
        break 
      end
    end
  end  
  
  if UseFX2~=nil then
    if osc_message==nil then osc_message="" end
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end

function ultraschall.SetParmAlias_FXStateChunk(FXStateChunk, fxid, id, parmalias)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmAlias_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmAlias_FXStateChunk(string FXStateChunk, integer fxid, integer id, string parmalias)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
    The parameter id counts with the first aliasname found in the FXStateChunk for this fx, regardless, if the first found aliasname is for parameter 1 or 23, etc. 
    If you want to adress it by parameter-index, use [SetParmAlias2_FXStateChunk](#SetParmAlias2_FXStateChunk) instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Alias-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Alias-entry; beginning with 1
    integer id - the id of the Parm-Alias-entry to set; beginning with 1
    string parmalias - the new aliasname of the parameter
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "id", "must be an integer", -3) return false end    

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "parmalias", "must be a string", -4) return false end
  
  if parmalias:match("%s")~=nil then parmalias="\""..parmalias.."\"" end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMALIAS.-\n") do
      count=count+1
      if count==id then 
        start,stop=string.find(UseFX, k, 0, true)
        UseFX2=UseFX:sub(1,start-2).."\n"..k:match("    PARMALIAS%s.-%s")..parmalias..""..UseFX:sub(stop,-1)
        break 
      end
    end
  end  
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end

function ultraschall.SetParmAlias2_FXStateChunk(FXStateChunk, fxid, parmidx, parmalias)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmAlias2_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmAlias2_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx, string parmalias)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    Unlike SetParmAlias_FXStateChunk, the parameter parmidx counts by parameter-order, not existing aliasnames. If a parameter has no aliasname yet, it will return false.
    
    It's the PARMALIAS-entry
    
    
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Alias-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Alias-entry; beginning with 1
    integer parmidx - the index of the parameter, whose Parm-Alias-entry you want to to set; beginning with 1
    string parmalias - the new aliasname of the parameter
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmAlias2_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmAlias2_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("SetParmAlias2_FXStateChunk", "parmidx", "must be an integer", -3) return false end    

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("SetParmLearn2_FXStateChunk", "parmalias", "must be a string", -4) return false end
  
  if parmalias:match("%s")~=nil then parmalias="\""..parmalias.."\"" end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    UseFX2=string.gsub(UseFX, "\n%s-PARMALIAS "..(parmidx-1).." .-\n", "\n    PARMALIAS "..(parmidx-1).." "..parmalias.."\n")
    if UseFX2==UseFX then UseFX2=nil end
  end  
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end


function ultraschall.SetFXStateChunk(StateChunk, FXStateChunk, TakeFXChain_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredStateChunk = ultraschall.SetFXStateChunk(string StateChunk, string FXStateChunk, optional integer TakeFXChain_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds/replaces FXStateChunk to/in a TrackStateChunk or a MediaItemStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting fxstatechunk was successful; false, if setting was unsuccessful
    optional string alteredStateChunk - the altered StateChunk
  </retvals>
  <parameters>
    string StateChunk - the TrackStateChunk, into which you want to set the FXChain
    string FXStateChunk - the FXStateChunk, which you want to set into the TrackStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, trackstatechunk, mediaitemstatechunk, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -2) return false end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("SetFXStateChunk", "TakeFXChain_id", "must be an integer", -3) return false end
  if TakeFXChain_id==nil then TakeFXChain_id=1 end
  ultraschall.SuppressErrorMessages(true)
  local OldFXStateChunk=ultraschall.GetFXStateChunk(StateChunk, TakeFXChain_id)
  ultraschall.SuppressErrorMessages(false)
  if OldFXStateChunk==nil then 
    --ultraschall.AddErrorMessage("SetFXStateChunk", "TakeFXChain_id", "no FXStateChunk found", -4) 
    FXStateChunk=string.gsub(FXStateChunk, "\n%s*", "\n")  
    FXStateChunk=string.gsub(FXStateChunk, "^%s*", "")
    
    --print2(FXStateChunk)
    return false, ultraschall.StateChunkLayouter(StateChunk:match("(.*)>").."\n"..FXStateChunk.."\n>")
  end
  OldFXStateChunk=string.gsub(OldFXStateChunk, "\n%s*", "\n")  
  OldFXStateChunk=string.gsub(OldFXStateChunk, "^%s*", "")
  
  
  local Start, Stop = string.find(StateChunk, OldFXStateChunk, 0, true)
  StateChunk=StateChunk:sub(1,Start-1)..FXStateChunk:match("%s-(.*)")..StateChunk:sub(Stop+1,-1)
  StateChunk=string.gsub(StateChunk, "\n%s*", "\n")
  return true, StateChunk
end

function ultraschall.GetFXStateChunk(StateChunk, TakeFXChain_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk, integer linenumber = ultraschall.GetFXStateChunk(string StateChunk, optional integer TakeFXChain_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns an FXStateChunk from a TrackStateChunk or a MediaItemStateChunk.
    
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns nil in case of an error or if no FXStateChunk has been found.
  </description>
  <retvals>
    string FXStateChunk - the FXStateChunk, stored in the StateChunk
    integer linenumber - returns the first linenumber, at which the found FXStateChunk starts in the StateChunk
  </retvals>
  <parameters>
    string StateChunk - the StateChunk, from which you want to retrieve the FXStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, fxstatechunk, trackstatechunk, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("GetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -1) return end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("GetFXStateChunk", "TakeFXChain_id", "must be an integer", -2) return end
  local add, takefx, trackfx
  
  local finallinenumber
  local FXStateChunk=""
  
  if string.find(StateChunk, "\n  ")==nil then
    StateChunk=ultraschall.StateChunkLayouter(StateChunk)
  end

  local linenumber=0
  if ultraschall.IsValidTrackStateChunk(StateChunk)==true then
    for w in string.gmatch(StateChunk, ".-\n") do
      linenumber=linenumber+1
      if w=="  <FXCHAIN\n" then
        trackfx=true
        if finallinenumber==nil then finallinenumber=linenumber end
      elseif trackfx==true and w=="  >\n" then
        trackfx=false
      end
      if trackfx==true then
        FXStateChunk=FXStateChunk..w
      end
    end
    if FXStateChunk~="" then add="  >" else add="" end
    if FXStateChunk:len()<7 then FXStateChunk="" end
    
    return FXStateChunk..add, finallinenumber
  end
  
  if TakeFXChain_id==nil then TakeFXChain_id=1 end
  local count=0
  local FXStateChunk=""
  
  StateChunk="  TAKE\n"..StateChunk.."\n"
  takefx=false
  linenumber=0
  
  for w in string.gmatch(StateChunk, "(.-\n)") do
    linenumber=linenumber+1
    if w:sub(1,7)=="  TAKE\n" or w:sub(1,7)=="  TAKE "then
      count=count+1
    end
    
    if w=="  <TAKEFX\n" then
      takefx=true
    elseif takefx==true and w=="  >\n" then
      takefx=false
    end
    
    if takefx==true and TakeFXChain_id==count then
      if finallinenumber==nil then finallinenumber=linenumber end
      FXStateChunk=FXStateChunk..w
    end
  end
  if FXStateChunk:len()<7 then FXStateChunk="" end
  if FXStateChunk~="" then add="  >" else add="" end
  return FXStateChunk..add, finallinenumber
end


function ultraschall.AddParmLFOLearn_FXStateChunk(FXStateChunk, fxid, parmidx, parmname, midi_note, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddParmLFOLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.AddParmLFOLearn_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a new Parm-LFOLearn-entry to an FX-plugin from an FXStateChunk.
    
    It's the LFOLEARN-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Learn-entry; beginning with 1
    integer parmidx - the parameter, whose alias you want to add
    string parmname - the name of the parameter, usually \"\" or \"byp\" for bypass or \"wet\" for wet; when using wet or bypass, these are essential to give!
    integer midi_note - the midinote, that is assigned to this; this is a multibyte value, with the first byte
                      - being the MIDI-mode, and the second byte the MIDI/CC-note
                      -       0,   OSC is used
                      -       176, MIDI Chan 1 CC 0     (Byte1=176, Byte2=0)
                      -       ...
                      -       432, MIDI Chan 1 CC 1     (Byte1=176, Byte2=1)
                      -       ...
                      -       144,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=0)
                      -       400,  MIDI Chan 1 Note 1  (Byte1=144, Byte2=1)
                      -       ...
                      -       9360, MIDI Chan 1 Note 36 (Byte1=144, Byte2=36)
                      -       9616, MIDI Chan 1 Note 37 (Byte1=144, Byte2=37)
                      -       9872, MIDI Chan 1 Note 38 (Byte1=144, Byte2=38)
                      -         ...        
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          -    0, no checkboxes
                          -    1, enable only when track or item is selected
                          -    2, Soft takeover (absolute mode only)
                          -    3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          -    4, enable only when effect configuration is focused
                          -    20, enable only when effect configuration is visible 
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, add, parm, learn, lfo, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "osc_message", "must be either nil or a string", -4) return false end
  if math.type(midi_note)~="integer" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "midi_note", "must be an integer", -5) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "checkboxflags", "must be an integer", -6) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "parmidx", "must be an integer", -7) return false end
  if type(parmname)~="string" then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "parmname", "must be a string, either \"\" or byp or wet", -8) return false 
  elseif parmname~="" then parmname=":"..parmname
  end
  
  if checkboxflags&8==0 then checkboxflags=checkboxflags+8 end
  
  if osc_message~=nil and midi_note~=0 then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "midi_note", "must be set to 0, when using parameter osc_message", -9) return false end
  if osc_message==nil then osc_message="" end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  if UseFX:match("LFOLEARN "..parmidx..parmname)~=nil then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "parmidx", "there's already an alias for this parmidx", -10) return false end
  if UseFX:match("LFOLEARN "..parmidx)~=nil then ultraschall.AddErrorMessage("AddParmLFOLearn_FXStateChunk", "parmidx", "there's already an alias for this parmidx", -10) return false end
  local UseFX_start, UseFX_end=UseFX:match("(.-)(LFOLEARN.*)")
  if UseFX_start==nil or UseFX_end==nil then UseFX_start, UseFX_end=UseFX:match("(.-)(PARMLEARN.*)") end
  if UseFX_start==nil or UseFX_end==nil then UseFX_start, UseFX_end=UseFX:match("(.-)(WAK.*)") end
  UseFX2=UseFX_start.."LFOLEARN "..parmidx..parmname.." "..midi_note.." "..checkboxflags.." "..osc_message.."\n    "..UseFX_end
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end


function ultraschall.AddParmLearn_FXStateChunk(FXStateChunk, fxid, parmidx, parmname, midi_note, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.AddParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a new Parm-Learn-entry to an FX-plugin from an FXStateChunk.
    
    It's the PARMLEARN-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Learn-entry; beginning with 1
    integer parmidx - the parameter, whose alias you want to add
    string parmname - the name of the parameter, usually \"\" or \"byp\" for bypass or \"wet\" for wet; when using wet or bypass, these are essential to give, otherwise just pass ""
    integer midi_note -   an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-message
                      -    examples:
                      -            0,   OSC is used
                      -            176, MIDI Chan 1 CC 0
                      -            ...
                      -            432, MIDI Chan 1 CC 1
                      -            ...
                      -            9360, MIDI Chan 1 Note 36
                      -            9616, MIDI Chan 1 Note 37
                      -            9872, MIDI Chan 1 Note 38
                      -              ...
                      -              
                      -        CC Mode-dropdownlist:
                      -           set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                      -            &65536 &131072 &262144 
                      -               0       0       0,      Absolute
                      -               1       0       0,      Relative 1(127=-1, 1=+1)
                      -               0       1       0,      Relative 2(63=-1, 65=+1)
                      -               1       1       0,      Relative 3(65=-1, 1=+1)
                      -               0       0       1,      Toggle (>0=toggle) 
    integer checkboxflags - the checkboxes checked in the MIDI/OSC-learn dialog
                          -    0, no checkboxes
                          -    1, enable only when track or item is selected
                          -    2, Soft takeover (absolute mode only)
                          -    3, Soft takeover (absolute mode only)+enable only when track or item is selected
                          -    4, enable only when effect configuration is focused
                          -    20, enable only when effect configuration is visible 
    optional string osc_message - the osc-message, that triggers the ParmLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, add, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "osc_message", "must be either nil or a string", -4) return false end
  if math.type(midi_note)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "midi_note", "must be an integer", -5) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "checkboxflags", "must be an integer", -6) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "parmidx", "must be an integer", -7) return false end
  if type(parmname)~="string" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "parmname", "must be a string, either \"\" or byp or wet", -8) return false 
  elseif parmname~="" then parmname=":"..parmname
  end
  
  if checkboxflags&8==8 then checkboxflags=checkboxflags-8 end
    
  if osc_message~=nil and midi_note~=0 then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "midi_note", "must be set to 0, when using parameter osc_message", -9) return false end
  if osc_message==nil then osc_message="" end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  if UseFX:match("PARMLEARN "..parmidx..parmname)~=nil then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "parmidx", "there's already an alias for this parmidx", -10) return false end
  if UseFX:match("PARMLEARN "..parmidx)~=nil then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk", "parmidx", "there's already an alias for this parmidx", -11) return false end
  local UseFX_start, UseFX_end=UseFX:match("(.-)(PARMLEARN.*)")
  if UseFX_start==nil or UseFX_end==nil then UseFX_start, UseFX_end=UseFX:match("(.-)(WAK.*)") end
  --id, midi_note, checkboxflags, osc_message
  UseFX2=UseFX_start.."PARMLEARN "..parmidx..parmname.." "..midi_note.." "..checkboxflags.." "..osc_message.."\n    "..UseFX_end
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end


function ultraschall.AddParmAlias_FXStateChunk(FXStateChunk, fxid, parmidx, parmalias)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddParmAlias_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.AddParmAlias_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx, string parmalias)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a new Parm-Alias-entry to an FX-plugin from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Alias-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Alias-entry; beginning with 1
    integer parmidx - the parameter, whose alias you want to add
    string parmalias - the new aliasname of the parameter
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return false end

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmalias", "must be a string", -4) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmidx", "must be an integer", -5) return false end
  
  if parmalias:match("%s")~=nil then parmalias="\""..parmalias.."\"" end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  if UseFX:match("PARMALIAS "..parmidx)~=nil then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmidx", "There's already an alias for this parmidx. Please use SetParmAlias_FXStateChunk to set it to a new one.", -6) return false end
  local UseFX_start, UseFX_end=UseFX:match("(.-)(FXID.*)")
  UseFX2=UseFX_start.."PARMALIAS "..(parmidx-1).." "..parmalias.."\n    "..UseFX_end
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)  
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false
  end
end


function ultraschall.CountParmAlias_FXStateChunk(FXStateChunk, fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountParmAlias_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountParmAlias_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Counts already existing Parm-Alias-entries of an FX-plugin from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of ParmAliases found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to count a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-count-Parm-Learn-entry; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, count, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return -1 end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("CountParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return -1 end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMALIAS.-\n") do
      count=count+1
    end
  end  
  return count
end

function ultraschall.CountParmLearn_FXStateChunk(FXStateChunk, fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountParmLearn_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Counts already existing Parm-Learn-entries of an FX-plugin from an FXStateChunk.
    
    It's the PARMLEARN-entry
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of ParmLearn-entries found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to count a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-count-Parm-Learn-entry; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, count, parm, learn</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return -1 end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("CountParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return -1 end
  if fxid<1 then ultraschall.AddErrorMessage("CountParmLearn_FXStateChunk", "fxid", "must be bigger than 1", -3) return -1 end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMLEARN.-\n") do
      count=count+1
    end
  end  
  return count
end

function ultraschall.CountParmLFOLearn_FXStateChunk(FXStateChunk, fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountParmLFOLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountParmLFOLearn_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Counts already existing Parm-LFOLearn-entries of an FX-plugin from an FXStateChunk.
    
    It's the LFOLEARN-entry
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of LFOLearn-entries found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to count a Parm-LFOLearn-entry
    integer fxid - the id of the fx, which holds the to-count-Parm-LFOLearn-entry; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, count, parm, lfo, learn</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountParmLFOLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return -1 end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("CountParmLFOLearn_FXStateChunk", "fxid", "must be an integer", -2) return -1 end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  count=0
  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    LFOLEARN.-\n") do
      count=count+1
    end
  end  
  return count
end

--retval,TrackStateChunk=reaper.GetTrackStateChunk(reaper.GetTrack(0,0), "", false)
--FXStateChunk=ultraschall.GetFXStateChunk(TrackStateChunk, 1)
--A,B,C=ultraschall.CountParmLFOLearn_FXStateChunk(FXStateChunk, 1, 16, "", 0, 1, "WetWetWet")
--retval, TrackStateChunk=ultraschall.SetFXStateChunk(TrackStateChunk, B)
--reaper.SetTrackStateChunk(reaper.GetTrack(0,0), TrackStateChunk,false)
--print2(B)




function ultraschall.ScanVSTPlugins(clear_cache)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ScanVSTPlugins</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>ultraschall.ScanVSTPlugins(optional boolean clear_cache)</functioncall>
  <description>
    Re-scans all VST-Plugins.
  </description>
  <parameters>
    optional boolean clear_cache - true, clear cache before re-scanning; false or nil, just scan vts-plugins
  </parameters>
  <chapter_context>
    FX-Management
    Plugins
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx-management, scan, plugins, vst</tags>
</US_DocBloc>
--]]
  local hwnd, hwnd1, hwnd2, retval, prefspage, reopen, id
  local use_prefspage=210
  if clear_cache==true then id=1058 else id=1057 end
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

--ultraschall.ScanVSTPlugins(true)

function ultraschall.AutoDetectVSTPluginsFolder()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoDetectVSTPluginsFolder</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>ultraschall.AutoDetectVSTPluginsFolder()</functioncall>
  <description>
    Auto-detects the vst-plugins-folder.
  </description>
  <chapter_context>
    FX-Management
    Plugins
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx-management, path, folder, auto-detect, plugins, vst</tags>
</US_DocBloc>
--]]
  local hwnd, hwnd1, hwnd2, retval, prefspage, reopen, id
  local use_prefspage=210
  id=1117
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

--ultraschall.AutoDetectVSTPluginsFolder()

function ultraschall.CountFXStateChunksInStateChunk(StateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountFXStateChunksInStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count_of_takefx_statechunks, integer count_of_trackfx_statechunks = ultraschall.CountFXStateChunksInStateChunk(string StateChunk)</functioncall>
  <description>
    Counts all FXStateChunks within a StateChunk.
    You can pass ItemStateChunks, TrackStateChunks and ProjectStateChunks.
    
    returns -1 in case of an error.
  </description>
  <retvals>
    integer count_of_takefx_statechunks - the number of take-fx-StateChunks within the StateChunk. When passing Track/ProjectStateChunks, it returns number of all FXStateChunks from all Takes within the StateChunk
    integer count_of_trackfx_statechunks - the number of TrackFX-StateChunks; each track alawys has a single one, so it should match the number of tracks within the StateChunk; 0, if you pass a ItemStateChunk
  </retvals>
  <parameters>
    string StateChunk - the StateChunk, whose count of FXStateChunks you want to retrieve
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, count, all, fxstatechunk</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidMediaItemStateChunk(StateChunk)==false and
     ultraschall.IsValidTrackStateChunk(StateChunk)==false and
     ultraschall.IsValidProjectStateChunk(StateChunk)==false then
     ultraschall.AddErrorMessage("CountFXStateChunksInStateChunk", "StateChunk", "Must be a valid Project/Track/ItemStateChunk", -1) return -1
  end
  local TrackFX=0
  local TakeFX=0
  for k in string.gmatch(StateChunk, "(.-)\n") do
    if k:match("%s*<FXCHAIN")~=nil then
      TrackFX=TrackFX+1
    elseif k:match("%s*<TAKEFX")~=nil then
      TakeFX=TakeFX+1
    end
  end
  return TakeFX, TrackFX
end 

function ultraschall.RemoveFXStateChunkFromTrackStateChunk(TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveFXStateChunkFromTrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string altered_TrackStateChunk = ultraschall.RemoveFXStateChunkFromTrackStateChunk(string TrackStateChunk)</functioncall>
  <description>
    Clears the FXChain from a TrackStateChunk
    
    returns nil in case of an error.
  </description>
  <retvals>
    string altered_TrackStateChunk - the TrackStateChunk, cleared of the Track-FXStateChunk
  </retvals>
  <parameters>
    string TrackStateChunk - the TrackStateChunk, whose FXStateChunk you want to remove
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, remove, all, fxstatechunk, trackstatechunk</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("RemoveFXStateChunkFromTrackStateChunk", "TrackStateChunk", "Must be a valid TrackStateChunk", -1) return end
  TrackStateChunk=ultraschall.StateChunkLayouter(TrackStateChunk)
  return string.gsub(TrackStateChunk, "(  <FXCHAIN.-\n  >\n", "")
end


function ultraschall.RemoveFXStateChunkFromItemStateChunk(ItemStateChunk, take_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveFXStateChunkFromItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string alteredItemStateChunk = ultraschall.RemoveFXStateChunkFromItemStateChunk(string ItemStateChunk, integer take_id)</functioncall>
  <description>
    Removes a certain Take-FXStateChunk from an ItemStateChunk.
    
    Returns nil in case of failure.
  </description>
  <parameters>
     string ItemStateChunk - the ItemStateChunk, from which you want to remove an FXStateChunk
     integer take_id - the take, whose FXStateChunk you want to remove
  </parameters>
  <retvals>
    string alteredItemStateChunk - the StateChunk, from which the FXStateChunk was removed
  </retvals>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, remove, fxstatechunk, statechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidItemStateChunk(ItemStateChunk)==false then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "ItemStateChunk", "Must be a valid ItemStateChunk!", -1) return nil end
  if math.type(take_id)~="integer" then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "take_id", "Must be an integer", -2) return nil end
  local OldFXStateChunk=ultraschall.GetFXStateChunk(ItemStateChunk, take_id)
  if OldFXStateChunk==nil then ultraschall.AddErrorMessage("RemoveFXStateChunkFromItemStateChunk", "take_id", "No FXChain in this take available", -3) return nil end
  
  ItemStateChunk=ultraschall.StateChunkLayouter(ItemStateChunk)
  local Startpos, Endpos = string.find (ItemStateChunk, OldFXStateChunk, 1, true)
  return string.gsub(ItemStateChunk:sub(1, Startpos)..ItemStateChunk:sub(Endpos+1, -1), "\n%s-\n", "\n")
end

function ultraschall.LoadFXStateChunkFromRFXChainFile(filename, trackfx_or_takefx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LoadFXStateChunkFromRFXChainFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.LoadFXStateChunkFromRFXChainFile(string filename, integer trackfx_or_takefx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Loads an FXStateChunk from an RFXChain-file.
    
    If you don't give a path, it will try to load the file from the folder ResourcePath/FXChains.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the loaded FXStateChunk; nil, in case of an error
  </retvals>
  <parameters>
    string filename - the filename of the RFXChain-file(must include ".RfxChain"); omit the path to load it from the folder ResourcePath/FXChains
    integer trackfx_or_takefx - 0, return the FXStateChunk as Track-FXStateChunk; 1, return the FXStateChunk as Take-FXStateChunk
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, load, fxstatechunk, trackfx, itemfx, takefx, rfxchain</tags>
</US_DocBloc>
]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("LoadFXStateChunkFromRFXChainFile", "filename", "must be a string", -1) return end
  if reaper.file_exists(filename)==false and reaper.file_exists(reaper.GetResourcePath().."/FXChains/"..filename)==false then
    ultraschall.AddErrorMessage("LoadFXStateChunkFromRFXChainFile", "filename", "file not found", -2) return
  end
  if math.type(trackfx_or_takefx)~="integer" then ultraschall.AddErrorMessage("LoadFXStateChunkFromRFXChainFile", "trackfx_or_takefx", "must be an integer", -3) return end
  if trackfx_or_takefx~=0 and trackfx_or_takefx~=1 then ultraschall.AddErrorMessage("LoadFXStateChunkFromRFXChainFile", "trackfx_or_takefx", "must be either 0(TrackFX) or 1 (TakeFX)", -4) return end
  ultraschall.SuppressErrorMessages(true)
  local FXStateChunk=ultraschall.ReadFullFile(filename)
  if FXStateChunk==nil then FXStateChunk=ultraschall.ReadFullFile(reaper.GetResourcePath().."/FXChains/"..filename) end
  ultraschall.SuppressErrorMessages(false)
  if FXStateChunk:sub(1,6)~="BYPASS" then ultraschall.AddErrorMessage("LoadFXStateChunkFromRFXChainFile", "filename", "no FXStateChunk found or RFXChain-file is empty", -5) return end
  if trackfx_or_takefx==0 then 
    FXStateChunk="<FXCHAIN\n"..FXStateChunk
  else 
    FXStateChunk="<TAKEFX\n"..FXStateChunk
  end
  return ultraschall.StateChunkLayouter(FXStateChunk)..">"
end


function ultraschall.SaveFXStateChunkAsRFXChainfile(filename, FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SaveFXStateChunkAsRFXChainfile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SaveFXStateChunkAsRFXChainfile(string filename, string FXStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Loads an FXStateChunk from an RFXChain-file.
    
    If you don't give a path, it will try to load the file from the folder ResourcePath/FXChains.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1 in case of failure, 1 in case of success
  </retvals>
  <parameters>
    string filename - the filename of the output-RFXChain-file(must include ".RfxChain"); omit the path to save it into the folder ResourcePath/FXChains
    string FXStateChunk - the FXStateChunk, which you want to set into the TrackStateChunk
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, save, fxstatechunk, trackfx, itemfx, takefx, rfxchain</tags>
</US_DocBloc>
]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("SaveFXStateChunkAsRFXChainfile", "FXStateChunk", "Must be a string.", -1) return -1 end
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SaveFXStateChunkAsRFXChainfile", "FXStateChunk", "Not a valid FXStateChunk.", -2) return -1 end
  if filename:match("/")==nil and filename:match("\\")==nil then filename=reaper.GetResourcePath().."/FXChains/"..filename end
  local New=FXStateChunk:match(".-\n(.*)>")
  local New2=""
  if New:sub(1,2)=="  " then
    for k in string.gmatch(New, "(.-)\n") do
      New2=New2..k:sub(3,-1).."\n"
    end
    New=New2:sub(1,-2)
  end
  return ultraschall.WriteValueToFile(filename, New)
end

function ultraschall.GetAllRFXChainfilenames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllRFXChainfilenames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count_of_RFXChainfiles, array RFXChainfiles = ultraschall.GetAllRFXChainfilenames()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all available RFXChainfiles in the folder ResourcePath/FXChains
  </description>
  <retvals>
    integer count_of_RFXChainfiles - the number of available RFXChainFiles
    array RFXChainfiles - the filenames of the RFXChainfiles
  </retvals>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, trackfx, itemfx, takefx, rfxchain, all, filenames, fxchains</tags>
</US_DocBloc>
]]
  local A,B=ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/FXChains/")
  local C=(reaper.GetResourcePath().."/FXChains/"):len()
  for i=1, A do
    B[i]=B[i]:sub(C+1, -1)
  end
  return A,B
end

function ultraschall.GetRecentFX()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRecentFX</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer count_of_RecentFX, array RecentFX = ultraschall.GetRecentFX()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the recent fx-list
  </description>
  <retvals>
    integer count_of_RecentFX - the number of available recent fx
    array RecentFX - the names of the recent fx
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, all, recent, fx</tags>
</US_DocBloc>
]]
  local Length_of_value, Count = ultraschall.GetIniFileValue("RecentFX", "Count", -100, reaper.get_ini_file())
  local Count=tonumber(Count)
  local RecentFXs={}
  for i=1, Count do
    if i<10 then zero="0" else zero="" end
    Length_of_value, RecentFXs[i] = ultraschall.GetIniFileValue("RecentFX", "RecentFX"..zero..i, -100, reaper.get_ini_file())  
  end
  
  return Count, RecentFXs
end

function ultraschall.GetTrackFX_AlternativeName(tracknumber, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackFX_AlternativeName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>string alternative_fx_name = ultraschall.GetTrackFX_AlternativeName(integer tracknumber, integer fx_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the alternative name of a specific trackfx.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string alternative_fx_name - the alternative fx-name set for this fx
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber, in which this track is located; 0, for master-track
    integer fx_id - the fx-id within the fxchain; 1, for the first trackfx
  </parameter>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, alternative name, aliasname, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(tracknumber)~="number: integer" then ultraschall.AddErrorMessage("GetTrackFX_AlternativeName", "tracknumber", "must be an integer", -1) return end
  if tracknumber>reaper.CountTracks(0) or tracknumber<0 then ultraschall.AddErrorMessage("GetTrackFX_AlternativeName", "tracknumber", "must be 1 and higher; 0, master track", -2) return end
  if ultraschall.type(fx_id)~="number: integer" then ultraschall.AddErrorMessage("GetTrackFX_AlternativeName", "fx_id", "must be an integer", -3) return end
  if fx_id<1 then ultraschall.AddErrorMessage("GetTrackFX_AlternativeName", "fx_id", "must be 1 and higher", -4) return end
  local Track, _, StatChunk, FXStateChunk, counter, AltName, StartOffset, EndOffset, StateChunk
  if tracknumber~=0 then
    Track=reaper.GetTrack(0,tracknumber-1)
  else
    Track=reaper.GetMasterTrack(0)
  end
  _,StateChunk=reaper.GetTrackStateChunk(Track, "", false)
  FXStateChunk = ultraschall.GetFXStateChunk(StateChunk, 1)

  counter=0
  AltName=""

  FXStateChunk=string.gsub(FXStateChunk, "<JS_", " <JS_")
  for k in string.gmatch(FXStateChunk, "(.-)\n") do
    if k:match("    <(......)")=="VIDEO_" then 
      counter=counter+1
      if counter==fx_id then
        local name=string.gsub(k:match("VIDEO_EFFECT \".-\" (.*)"),"\"", "")
        return name
      end
    elseif k:match("    <(...)")=="DX " then 
      counter=counter+1    
      if counter==fx_id then
        local name=string.gsub(k:match("<DX \".-\" (.*)"),"\"", "")
        return name
      end
    elseif k:match("    <(...)")=="AU " then 
      counter=counter+1
      if counter==fx_id then
        local name=k:match("<AU \".-\" \".-\" (.*)")
        if name:sub(1,1)=="\"" then return name:match("\"(.-)\"") else return name:match(".- ") end
        return name
      end
    elseif k:match("    <(...)")=="VST" then 
      counter=counter+1
      if counter==fx_id then      
        local name=k:match("<VST \".-\" .- .- (.*)")
        if name:sub(1,1)=="\"" then return name:match("\"(.-)\"") else return name:match(".- ") end
        return name
      end
    elseif k:match("    <(...)")=="JS " then 
      counter=counter+1
      if counter==fx_id then      
        local name=string.gsub(k:match("<JS .- (.*)"), "\"", "")
        return name
      end
    end
  end
end

function ultraschall.GetTakeFX_AlternativeName(item, take_id, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTakeFX_AlternativeName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>string alternative_fx_name = ultraschall.GetTakeFX_AlternativeName(integer tracknumber, integer take_id, integer fx_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the alternative name of a specific takefx.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string alternative_fx_name - the alternative fx-name set for this fx
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber, in which this track is located; 0, for master-track
    integer take_id - the id of the take of whose FXChain's fx you want to get the alternative name
    integer fx_id - the fx-id within the fxchain; 1, for the first trackfx
  </parameter>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, alternative name, aliasname, takefx</tags>
</US_DocBloc>
]]
  if ultraschall.type(item)~="MediaItem" then ultraschall.AddErrorMessage("GetTakeFX_AlternativeName", "item", "must be a MediaItem", -1) return end
  if ultraschall.type(take_id)~="number: integer" then ultraschall.AddErrorMessage("GetTakeFX_AlternativeName", "take_id", "must be an integer", -2) return end
  if take_id<1 or reaper.CountTakes(item)<take_id then ultraschall.AddErrorMessage("GetTakeFX_AlternativeName", "take_id", "no such take", -3) return end
  if ultraschall.type(fx_id)~="number: integer" then ultraschall.AddErrorMessage("GetTakeFX_AlternativeName", "fx_id", "must be an integer", -4) return end
  if fx_id<1 then ultraschall.AddErrorMessage("GetTakeFX_AlternativeName", "fx_id", "must be 1 and higher", -6) return end
  local Track, _, StatChunk, FXStateChunk, counter, AltName, StartOffset, EndOffset, StateChunk

  _,StateChunk=reaper.GetItemStateChunk(item, "", false)
  FXStateChunk = ultraschall.GetFXStateChunk(StateChunk, take_id)

  counter=0
  AltName=""

  for k in string.gmatch(FXStateChunk, "(.-)\n") do
    if k:match("    <(......)")=="VIDEO_" then 
      counter=counter+1
      if counter==fx_id then
        local name=string.gsub(k:match("VIDEO_EFFECT \".-\" (.*)"),"\"", "")
        return name
      end
    elseif k:match("    <(...)")=="DX " then 
      counter=counter+1    
      if counter==fx_id then
        local name=string.gsub(k:match("<DX \".-\" (.*)"),"\"", "")
        return name
      end
    elseif k:match("    <(...)")=="AU " then 
      counter=counter+1
      if counter==fx_id then
        local name=k:match("<AU \".-\" \".-\" (.*)")
        if name:sub(1,1)=="\"" then return name:match("\"(.-)\"") else return name:match(".- ") end
        return name
      end
    elseif k:match("    <(...)")=="VST" then 
      counter=counter+1
      if counter==fx_id then      
        local name=k:match("<VST \".-\" .- .- (.*)")
        if name:sub(1,1)=="\"" then return name:match("\"(.-)\"") else return name:match(".- ") end
        return name
      end
    elseif k:match("    <(...)")=="JS " then 
      counter=counter+1
      if counter==fx_id then      
        local name=string.gsub(k:match("<JS .- (.*)"), "\"", "")
        return name
      end
    end
  end
  
end

--AAAA=ultraschall.GetTakeFX_AlternativeName(reaper.GetMediaItem(0,0), 2, 5)


function ultraschall.SetTrackFX_AlternativeName(tracknumber, fx_id, newname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackFX_AlternativeName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTrackFX_AlternativeName(integer tracknumber, integer fx_id, string newname)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    sets the alternative name of a specific trackfx.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber, in which this track is located; 0, for master-track
    integer fx_id - the fx-id within the fxchain; 1, for the first trackfx
    string newname - the new alternative name for the fx
  </parameter>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, alternative name, aliasname, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(tracknumber)~="number: integer" then ultraschall.AddErrorMessage("SetTrackFX_AlternativeName", "tracknumber", "must be an integer", -1) return false end
  if tracknumber>reaper.CountTracks(0) or tracknumber<0 then ultraschall.AddErrorMessage("SetTrackFX_AlternativeName", "tracknumber", "must be 1 and higher; 0, master track", -2) return false end
  if ultraschall.type(fx_id)~="number: integer" then ultraschall.AddErrorMessage("SetTrackFX_AlternativeName", "fx_id", "must be an integer", -3) return false end
  if fx_id<1 then ultraschall.AddErrorMessage("SetTrackFX_AlternativeName", "fx_id", "must be 1 and higher", -4) return false end
  if ultraschall.type(newname)~="string" then ultraschall.AddErrorMessage("SetTrackFX_AlternativeName", "newname", "must be a string", -5) return false end
  
  local Track, _, FXStateChunk, counter, StateChunk, retval, NewFXStateChunk, alteredStateChunk
  if tracknumber~=0 then
    Track=reaper.GetTrack(0,tracknumber-1)
  else
    Track=reaper.GetMasterTrack(0)
  end
  _,StateChunk=reaper.GetTrackStateChunk(Track, "", false)
  FXStateChunk = ultraschall.GetFXStateChunk(StateChunk, 1).."\n"

  counter=0
  
  newname=string.gsub(newname, "\n", "")
  newname=string.gsub(newname, "\"", "")
  if newname:match(" ")~=nil then newname="\""..newname.."\"" end

  NewFXStateChunk=""
  for k in string.gmatch(FXStateChunk, "(.-)\n") do
    if k:match("    <(......)")=="VIDEO_" then 
      counter=counter+1
      if counter==fx_id then
        k=string.gsub(k, "<VIDEO_EFFECT \".-\" (.*)", "<VIDEO_EFFECT \"Video processor\" "..newname)
      end
    elseif k:match("    <(...)")=="DX " then 
      counter=counter+1    
      if counter==fx_id then
        local Pre=k:match("(.-<DX \".-\" ).*")
        k=Pre..newname
      end
    elseif k:match("    <(...)")=="AU " then 
      counter=counter+1
      if counter==fx_id then
        local k1,k2=k:match("(.- \".-\" \".-\" ).*( .- .- .-)")
        k=k1..newname..k2
      end
    elseif k:match("    <(...)")=="VST" then 
      counter=counter+1
      if counter==fx_id then        
        local Pre=k:match("(.-<VST \".-\" .- .- ).*")
        k=Pre..newname
      end
    elseif k:match("    <(...)")=="JS " then 
      counter=counter+1
      if counter==fx_id then      
        local k1=k:match("(.-<.- .- )")
        k=k1..newname
      end
    end
    NewFXStateChunk=NewFXStateChunk..k.."\n"
  end
  retval, alteredStateChunk = ultraschall.SetFXStateChunk(StateChunk, NewFXStateChunk)
  
  _=reaper.SetTrackStateChunk(Track, alteredStateChunk, false)  
  return true
end

function ultraschall.SetTakeFX_AlternativeName(item, take_id, fx_id, newname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTakeFX_AlternativeName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTakeFX_AlternativeName(integer tracknumber, integer take_id, integer fx_id, string newname)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    sets the alternative name of a specific takefx.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber, in which this track is located; 0, for master-track
    integer take_id - the take, in which the fx in question is located
    integer fx_id - the fx-id within the fxchain; 1, for the first trackfx
    string newname - the new alternative name for the fx
  </parameter>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, alternative name, aliasname, takefx</tags>
</US_DocBloc>
]]
  if ultraschall.type(item)~="MediaItem" then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "item", "must be a MediaItem", -1) return end
  if ultraschall.type(take_id)~="number: integer" then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "take_id", "must be an integer", -2) return end
  if take_id<1 or reaper.CountTakes(item)<take_id then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "take_id", "no such take", -3) return end
  if ultraschall.type(fx_id)~="number: integer" then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "fx_id", "must be an integer", -4) return end
  if fx_id<1 then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "fx_id", "must be 1 and higher", -5) return end
  if ultraschall.type(newname)~="string" then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "newname", "must be a string", -6) return false end
  local _, FXStateChunk, counter, StateChunk, retval, NewFXStateChunk, alteredStateChunk

  _,StateChunk=reaper.GetItemStateChunk(item, "", false)
  FXStateChunk = ultraschall.GetFXStateChunk(StateChunk, take_id)
  if FXStateChunk=="" then ultraschall.AddErrorMessage("SetTakeFX_AlternativeName", "fx_id", "no such fxchain", -7) return false end

  counter=0
  newname=string.gsub(newname, "\n", "")
  newname=string.gsub(newname, "\"", "")
  if newname:match(" ")~=nil then newname="\""..newname.."\"" end

  NewFXStateChunk=""
  for k in string.gmatch(FXStateChunk, "(.-)\n") do
    if k:match("    <(......)")=="VIDEO_" then 
      counter=counter+1
      if counter==fx_id then
        k=string.gsub(k, "<VIDEO_EFFECT \".-\" (.*)", "<VIDEO_EFFECT \"Video processor\" "..newname)
      end
    elseif k:match("    <(...)")=="DX " then 
      counter=counter+1    
      if counter==fx_id then
        local Pre=k:match("(.-<DX \".-\" ).*")
        k=Pre..newname
      end
    elseif k:match("    <(...)")=="AU " then 
      counter=counter+1
      if counter==fx_id then
        local k1,k2=k:match("(.- \".-\" \".-\" ).*( .- .- .-)")
        k=k1..newname..k2
      end
    elseif k:match("    <(...)")=="VST" then 
      counter=counter+1
      if counter==fx_id then      
        local Pre=k:match("(.-<VST \".-\" .- .- ).*")
        k=Pre..newname
      end
    elseif k:match("    <(...)")=="JS " then 
      counter=counter+1
      if counter==fx_id then      
        local k1=k:match("(.-<.- .- )")
        k=k1..newname
      end
    end
    NewFXStateChunk=NewFXStateChunk..k.."\n"
  end
  
  retval, alteredStateChunk = ultraschall.SetFXStateChunk(StateChunk, NewFXStateChunk, take_id)  
  _=reaper.SetItemStateChunk(item, alteredStateChunk, false)  
  return true
end


function ultraschall.GetFXSettingsString_FXLines(fx_lines)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXSettingsString_FXLines</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string fx_statestring_base64, string fx_statestring = ultraschall.GetFXSettingsString_FXLines(string fx_lines)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the fx-states-string of a fx, as stored as an base64-string.byte
    It returns its decoded and encoded version of it.
    
    Use [GetFXFromFXStateChunk](#GetFXFromFXStateChunk) to get the requested parameter "fx_lines"
  
    returns nil in case of an error
  </description>
  <parameters>
    string fx_lines - the statechunk-lines of an fx, as returned by the function GetFXFromFXStateChunk()
  </parameters>
  <retvals>
    string fx_statestring_base64 - the base64-version of the state-string, which holds all fx-settings of the fx
    string fx_statestring - the decoded binary-version of the state-string, which holds all fx-settings of the fx
  </retvals>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, fxstatestring, base64</tags>
</US_DocBloc>
--]]
  if ultraschall.type(FXLines)~="string" then ultraschall.AddErrorMessage("GetFXSettingsString_FXLines", "fx_lines" , "must be a string", -1) return nil end
  if FXLines:match("    <VST")~=nil then
    FXSettings=FXLines:match("<VST.-\n(.-)    >")
  elseif FXLines:match("    <JS_SER")~=nil then
    FXSettings=FXLines:match("<JS_SER.-\n(.-)    >")
  elseif FXLines:match("    <DX")~=nil then
    FXSettings=FXLines:match("<DX.-\n(.-)    >")
  elseif FXLines:match("    <AU")~=nil then
    FXSettings=FXLines:match("<AU.-\n(.-)    >")
  elseif FXLines:match("    <VIDEO_EFFECT")~=nil then
    return "", string.gsub(FXLines:match("<VIDEO_EFFECT.-      <CODE\n(.-)      >"), "%s-|", "\n")
  end
    FXSettings=string.gsub(FXSettings, "[\n%s]*", "")
    FXSettings_dec=ultraschall.Base64_Decoder(FXSettings)
    return FXSettings, FXSettings_dec
end

-- ParmModulation:
function ultraschall.GetParmModTable_FXStateChunk(FXStateChunk, fxindex, parmodindex)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmModTable_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table ParmModulationTable = ultraschall.GetParmModTable_FXStateChunk(string FXStateChunk, integer fxindex, integer parmodindex)</functioncall>
  <description>
    Returns a table with all values of a specific Parameter-Modulation from an FXStateChunk.
  
    The table's format is as follows:
    <pre><code>
                ParmModTable["PARAM_NR"]               - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
                ParmModTable["PARAM_TYPE"]             - the type of the parameter, usually "", "wet" or "bypass"

                ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                        - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                          true, checked; false, unchecked
                ParmModTable["PARAMOD_BASELINE"]       - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                            0.000 to 1.000

                ParmModTable["AUDIOCONTROL"]           - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all AUDIOCONTROL_-entries to be set
                ParmModTable["AUDIOCONTROL_CHAN"]      - the Track audio channel-dropdownlist; When stereo, the first stereo-channel; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STEREO"]    - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                            AUDIOCONTROL_CHAN+1; nil, if not available
                ParmModTable["AUDIOCONTROL_ATTACK"]    - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
                ParmModTable["AUDIOCONTROL_RELEASE"]   - the Release-slider; 0-1000ms; nil, if not available
                ParmModTable["AUDIOCONTROL_MINVOLUME"] - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_MAXVOLUME"] - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STRENGTH"]  - the Strength-slider; 0(0%) to 1000(100%)
                ParmModTable["AUDIOCONTROL_DIRECTION"] - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
                ParmModTable["X2"]=0.5                 - the audiocontrol signal shaping-x-coordinate
                ParmModTable["Y2"]=0.5                 - the audiocontrol signal shaping-y-coordinate    
                
                ParmModTable["LFO"]                    - if the LFO-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all LFO_-entries to be set
                ParmModTable["LFO_SHAPE"]              - the LFO Shape-dropdownlist; 
                                                            0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                            nil, if not available
                ParmModTable["LFO_SHAPEOLD"]           - use the old-style of the LFO_SHAPE; 
                                                            0, use current style of LFO_SHAPE; 
                                                            1, use old style of LFO_SHAPE; 
                                                            nil, if not available
                ParmModTable["LFO_TEMPOSYNC"]          - the Tempo sync-checkbox; true, checked; false, unchecked
                ParmModTable["LFO_SPEED"]              - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
                ParmModTable["LFO_STRENGTH"]           - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
                ParmModTable["LFO_PHASE"]              - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
                ParmModTable["LFO_DIRECTION"]          - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
                ParmModTable["LFO_PHASERESET"]         - the LFO Phase reset-dropdownlist; 
                                                            0, On seek/loop(deterministic output)
                                                            1, Free-running(non-deterministic output)
                                                            nil, if not available

                ParmModTable["PARMLINK"]               - the Link from MIDI or FX parameter-checkbox
                                                          true, checked; false, unchecked
                ParmModTable["PARMLINK_LINKEDPLUGIN"]  - the selected plugin; nil, if not available
                                                            -1, nothing selected yet
                                                            -100, MIDI-parameter-settings
                                                            1 - the first fx-plugin
                                                            2 - the second fx-plugin
                                                            3 - the third fx-plugin, etc
                ParmModTable["PARMLINK_LINKEDPARMIDX"] - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                            When MIDI, this is irrelevant.
                                                            When FX-parameter:
                                                              0 to n; 0 for the first; 1, for the second, etc

                ParmModTable["PARMLINK_OFFSET"]        - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
                ParmModTable["PARMLINK_SCALE"]         - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

                ParmModTable["MIDIPLINK"]              - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["MIDIPLINK_BUS"]          - the MIDI-bus selected in the button-menu; 
                                                            0 to 15 for bus 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_CHANNEL"]      - the MIDI-channel selected in the button-menu; 
                                                            0, omni; 1 to 16 for channel 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_MIDICATEGORY"] - the MIDI_Category selected in the button-menu; nil, if not available
                                                            144, MIDI note
                                                            160, Aftertouch
                                                            176, CC 14Bit and CC
                                                            192, Program Change
                                                            208, Channel Pressure
                                                            224, Pitch
                ParmModTable["MIDIPLINK_MIDINOTE"]     - the MIDI-note selected in the button-menu; nil, if not available
                                                          When MIDI note:
                                                               0(C-2) to 127(G8)
                                                          When Aftertouch:
                                                               0(C-2) to 127(G8)
                                                          When CC14 Bit:
                                                               128 to 159; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When CC:
                                                               0 to 119; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When Program Change:
                                                               0
                                                          When Channel Pressure:
                                                               0
                                                          When Pitch:
                                                               0
                ParmModTable["WINDOW_ALTERED"]         - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                            Note: if true, this needs all WINDOW_-entries to be set
                ParmModTable["WINDOW_ALTEREDOPEN"]     - if the position of the ParmMod-window is altered and currently open; 
                                                            nil, unchanged; 0, unopened; 1, open
                ParmModTable["WINDOW_XPOS"]            - the x-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_YPOS"]            - the y-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_RIGHT"]           - the right-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
                ParmModTable["WINDOW_BOTTOM"]          - the bottom-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
    </code></pre>
    returns nil in case of an error
  </description>
  <parameters>
    string FXStateChunk - an FXStateChunk, of which you want to get the values of a specific parameter-modulation
    integer fxindex - the index if the fx, of which you want to get specific parameter-modulation-values
    integer parmodindex - the parameter-modulation, whose values you want to get; 1, for the first; 2, for the second, etc
  </parameters>
  <retvals>
    table ParmModulationTable - a table which holds all values of a specfic parameter-modulation
  </retvals>
  <chapter_context>
    FX-Management
    Parameter Modulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter modulation, table, all values</tags>
</US_DocBloc>
]]
  if ultraschall.type(FXStateChunk)~="string" then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "FXStateChunk", "must be a string", -1) return end
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -2) return end
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "fxindex", "must be an integer", -3) return end
  if fxindex<1 then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "fxindex", "must be bigger than 0", -4) return end
  
  if ultraschall.type(parmodindex)~="number: integer" then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "parmodindex", "must be an integer", -5) return end
  if parmodindex<1 then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "parmodindex", "must be bigger than 0", -6) return end
  local count=0
  local found=""
  local ParmModTable={}
  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  
  if FX==nil then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "fxindex", "no such index", -7) return nil end
  --[[for k in string.gmatch(FX, "\n    <PROGRAMENV.-\n    >") do
    count=count+1
    if count==parmodindex then found=k break end
  end
  if found=="" then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "parmodindex", "no such index", -8) return nil end
  found=string.gsub(found, "\n", " \n")
  --]]
  
  local Start, found, End = FX:match("()(<PROGRAMENV "..(parmodindex-1).."[:%s]+.-  >)()")
  if found==nil then ultraschall.AddErrorMessage("GetParmModTable_FXStateChunk", "parmodindex", "no such index", -8) return nil end
  

--  print_update(found)

  -- <PROGRAMENV
  ParmModTable["PARAM_NR"], ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]=found:match("<PROGRAMENV (.-) (.-) ")
  if tonumber(ParmModTable["PARAM_NR"])~=nil then
    ParmModTable["PARAM_NR"]=tonumber(ParmModTable["PARAM_NR"])
    ParmModTable["PARAM_TYPE"]=""
  else
    ParmModTable["PARAM_TYPE"]=ParmModTable["PARAM_NR"]:match(":(.*)") -- removes the : separator
    ParmModTable["PARAM_NR"]=tonumber(ParmModTable["PARAM_NR"]:match("(.-):"))
  end
  ParmModTable["PARAM_NR"]=ParmModTable["PARAM_NR"]+1 -- add one to the paramnr(compared to the statechunk) so the 
                                                      -- number matches the shown fx-number in the ui of Reaper
  ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]=tonumber(ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"])==0

  -- PARAMBASE
  ParmModTable["PARAMOD_BASELINE"]=tonumber(found:match("PARAMBASE (.-) "))
  
  ParmModTable["LFO"]=tonumber(found:match("LFO (.-) "))==1

  -- LFOWT  
  ParmModTable["LFO_STRENGTH"], 
  ParmModTable["LFO_DIRECTION"]=found:match("LFOWT (.-) (.-) ")
  ParmModTable["LFO_STRENGTH"]=tonumber(ParmModTable["LFO_STRENGTH"])
  ParmModTable["LFO_DIRECTION"]=tonumber(ParmModTable["LFO_DIRECTION"])

  -- AUDIOCTL
  ParmModTable["AUDIOCONTROL"]=tonumber(found:match("AUDIOCTL (.-) "))==1
  
  -- AUDIOCTLWT
  ParmModTable["AUDIOCONTROL_STRENGTH"], 
  ParmModTable["AUDIOCONTROL_DIRECTION"]=found:match("AUDIOCTLWT (.-) (.-) ")
  ParmModTable["AUDIOCONTROL_STRENGTH"]=tonumber(ParmModTable["AUDIOCONTROL_STRENGTH"])
  ParmModTable["AUDIOCONTROL_DIRECTION"]=tonumber(ParmModTable["AUDIOCONTROL_DIRECTION"])
  
  -- PLINK
  ParmModTable["PARMLINK_SCALE"], 
  ParmModTable["PARMLINK_LINKEDPLUGIN"],
  ParmModTable["PARMLINK_LINKEDPARMIDX"],
  ParmModTable["PARMLINK_OFFSET"]
  =found:match(" PLINK (.-) (.-) (.-) (.-) ")
  
  ParmModTable["PARMLINK_SCALE"]=tonumber(ParmModTable["PARMLINK_SCALE"])
  if ParmModTable["PARMLINK_LINKEDPLUGIN"]~=nil then
    if ParmModTable["PARMLINK_LINKEDPLUGIN"]:match(":")~=nil then 
      ParmModTable["PARMLINK_LINKEDPLUGIN"]=tonumber(ParmModTable["PARMLINK_LINKEDPLUGIN"]:match("(.-):"))+1
    else
      ParmModTable["PARMLINK_LINKEDPLUGIN"]=tonumber(ParmModTable["PARMLINK_LINKEDPLUGIN"])
    end
  end
  ParmModTable["PARMLINK_LINKEDPARMIDX"]=tonumber(ParmModTable["PARMLINK_LINKEDPARMIDX"])
  if ParmModTable["PARMLINK_LINKEDPARMIDX"]~=nil and ParmModTable["PARMLINK_LINKEDPARMIDX"]>-1 then ParmModTable["PARMLINK_LINKEDPARMIDX"]=ParmModTable["PARMLINK_LINKEDPARMIDX"]+1 end
  ParmModTable["PARMLINK_OFFSET"]=tonumber(ParmModTable["PARMLINK_OFFSET"])

  ParmModTable["PARMLINK"]=ParmModTable["PARMLINK_SCALE"]~=nil

  -- MIDIPLINK
  ParmModTable["MIDIPLINK_BUS"], 
  ParmModTable["MIDIPLINK_CHANNEL"],
  ParmModTable["MIDIPLINK_MIDICATEGORY"],
  ParmModTable["MIDIPLINK_MIDINOTE"]
  =found:match("MIDIPLINK (.-) (.-) (.-) (.-) ")
  if ParmModTable["MIDIPLINK_BUS"]~=nil then ParmModTable["MIDIPLINK_BUS"]=tonumber(ParmModTable["MIDIPLINK_BUS"])+1 end -- add 1 to match the bus-number shown in Reaper's UI
  ParmModTable["MIDIPLINK_CHANNEL"]=tonumber(ParmModTable["MIDIPLINK_CHANNEL"])
  ParmModTable["MIDIPLINK_MIDICATEGORY"]=tonumber(ParmModTable["MIDIPLINK_MIDICATEGORY"])
  ParmModTable["MIDIPLINK_MIDINOTE"]=tonumber(ParmModTable["MIDIPLINK_MIDINOTE"])

  ParmModTable["MIDIPLINK"]=ParmModTable["MIDIPLINK_MIDINOTE"]~=nil
  
  -- LFOSHAPE
  ParmModTable["LFO_SHAPE"]=tonumber(found:match("LFOSHAPE (.-) "))
  
  -- LFOSYNC
  ParmModTable["LFO_TEMPOSYNC"], 
  ParmModTable["LFO_SHAPEOLD"],
  ParmModTable["LFO_PHASERESET"]
  =found:match("LFOSYNC (.-) (.-) (.-) ")
  ParmModTable["LFO_TEMPOSYNC"] = tonumber(ParmModTable["LFO_TEMPOSYNC"])==1
  ParmModTable["LFO_SHAPEOLD"]  = tonumber(ParmModTable["LFO_SHAPEOLD"])
  ParmModTable["LFO_PHASERESET"]= tonumber(ParmModTable["LFO_PHASERESET"])
  
  -- LFOSPEED
  ParmModTable["LFO_SPEED"], 
  ParmModTable["LFO_PHASE"]
  =found:match("LFOSPEED (.-) (.-) ")
  ParmModTable["LFO_SPEED"]=tonumber(ParmModTable["LFO_SPEED"])
  ParmModTable["LFO_PHASE"]=tonumber(ParmModTable["LFO_PHASE"])
  
  if found:match("CHAN (.-) ")~=nil then
    ParmModTable["AUDIOCONTROL_CHAN"]  =tonumber(found:match("CHAN (.-) "))+1
  end
  ParmModTable["AUDIOCONTROL_STEREO"]=tonumber(found:match("STEREO (.-) "))

  -- RMS
  ParmModTable["AUDIOCONTROL_ATTACK"], 
  ParmModTable["AUDIOCONTROL_RELEASE"]
  =found:match("RMS (.-) (.-) ")
  ParmModTable["AUDIOCONTROL_ATTACK"]=tonumber(ParmModTable["AUDIOCONTROL_ATTACK"])
  ParmModTable["AUDIOCONTROL_RELEASE"]=tonumber(ParmModTable["AUDIOCONTROL_RELEASE"])
  
  --DBLO and DBHI
  ParmModTable["AUDIOCONTROL_MINVOLUME"]=tonumber(found:match("DBLO (.-) "))
  ParmModTable["AUDIOCONTROL_MAXVOLUME"]=tonumber(found:match("DBHI (.-) "))
  
  -- X2, Y2
  ParmModTable["X2"]=tonumber(found:match("X2 (.-) "))
  ParmModTable["Y2"]=tonumber(found:match("Y2 (.-) "))

  -- MODHWND
  ParmModTable["WINDOW_ALTEREDOPEN"], 
  ParmModTable["WINDOW_XPOS"],
  ParmModTable["WINDOW_YPOS"],
  ParmModTable["WINDOW_RIGHT"],
  ParmModTable["WINDOW_BOTTOM"]
  =found:match("MODWND (.-) (.-) (.-) (.-) (.-) ")
  if ParmModTable["WINDOW_ALTEREDOPEN"]==nil then ParmModTable["WINDOW_ALTERED"]=false else ParmModTable["WINDOW_ALTERED"]=true end
  ParmModTable["WINDOW_ALTEREDOPEN"]=tonumber(ParmModTable["WINDOW_ALTEREDOPEN"])==1
  ParmModTable["WINDOW_XPOS"]  =tonumber(ParmModTable["WINDOW_XPOS"])
  ParmModTable["WINDOW_YPOS"]  =tonumber(ParmModTable["WINDOW_YPOS"])
  ParmModTable["WINDOW_RIGHT"] =tonumber(ParmModTable["WINDOW_RIGHT"])
  ParmModTable["WINDOW_BOTTOM"]=tonumber(ParmModTable["WINDOW_BOTTOM"])  
  
  return ParmModTable
end

function ultraschall.CreateDefaultParmModTable()
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>CreateDefaultParmModTable</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>table ParmModTable = ultraschall.CreateDefaultParmModTable()</functioncall>
    <description>
      returns a parameter-modulation-table with default settings set.
      You can alter these settings to your needs before committing it to an FXStateChunk.
      
      The checkboxes for "Audio control signal (sidechain)", "LFO", "Link from MIDI or FX parameter" are unchecked and the fx-parameter is set to 1(the first parameter of the plugin).
      To enable and change them, you need to alter the following entries accordingly, or applying the ParmModTable has no effect:
        
              ParmModTable["AUDIOCONTROL"] - the checkbox for "Audio control signal (sidechain)"
              ParmModTable["LFO"]      - the checkbox for "LFO"
              ParmModTable["PARMLINK"] - the checkbox for "Link from MIDI or FX parameter"
              ParmModTable["PARAM_NR"] - the index of the fx-parameter for which the parameter-modulation-table is intended
       
      The table's format and its default-values is as follows:
          <pre><code>
                      ParmModTable["PARAM_NR"]=1              - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
                      ParmModTable["PARAM_TYPE"]=""           - the type of the parameter, usually "", "wet" or "bypass"
      
                      ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]=true
                                                              - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                                true, checked; false, unchecked
                      ParmModTable["PARAMOD_BASELINE"]=0     - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                                  0.000 to 1.000
      
                      ParmModTable["AUDIOCONTROL"]=false           - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                                        Note: if true, this needs all AUDIOCONTROL_-entries to be set                      
                      ParmModTable["AUDIOCONTROL_CHAN"]=1          - the Track audio channel-dropdownlist; When stereo, the first stereo-channel; 
                                                                      nil, if not available
                      ParmModTable["AUDIOCONTROL_STEREO"]=0        - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                                        AUDIOCONTROL_CHAN+1; nil, if not available
                      ParmModTable["AUDIOCONTROL_ATTACK"]=300      - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
                      ParmModTable["AUDIOCONTROL_RELEASE"]=300     - the Release-slider; 0-1000ms; nil, if not available
                      ParmModTable["AUDIOCONTROL_MINVOLUME"]=-24   - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                                        nil, if not available
                      ParmModTable["AUDIOCONTROL_MAXVOLUME"]=0     - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                                        nil, if not available
                      ParmModTable["AUDIOCONTROL_STRENGTH"]=1      - the Strength-slider; 0(0%) to 1000(100%)
                      ParmModTable["AUDIOCONTROL_DIRECTION"]=1     - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
                      ParmModTable["X2"]=0.5                        - the audiocontrol signal shaping-x-coordinate
                      ParmModTable["Y2"]=0.5                        - the audiocontrol signal shaping-y-coordinate
      
                      ParmModTable["LFO"]=false                    - if the LFO-checkbox checked; true, checked; false, unchecked
                                                                       Note: if true, this needs all LFO_-entries to be set
                      ParmModTable["LFO_SHAPE"]=0                  - the LFO Shape-dropdownlist; 
                                                                       0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                                       nil, if not available
                      ParmModTable["LFO_SHAPEOLD"]=0              - use the old-style of the LFO_SHAPE; 
                                                                      0, use current style of LFO_SHAPE; 
                                                                      1, use old style of LFO_SHAPE; 
                                                                      nil, if not available
                      ParmModTable["LFO_TEMPOSYNC"]=false         - the Tempo sync-checkbox; true, checked; false, unchecked
                      ParmModTable["LFO_SPEED"]=0.124573          - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
                      ParmModTable["LFO_STRENGTH"]=1              - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
                      ParmModTable["LFO_PHASE"]=0                 - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
                      ParmModTable["LFO_DIRECTION"]=1             - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
                      ParmModTable["LFO_PHASERESET"]=0            - the LFO Phase reset-dropdownlist; 
                                                                      0, On seek/loop(deterministic output)
                                                                      1, Free-running(non-deterministic output)
                                                                      nil, if not available
      
                      ParmModTable["PARMLINK"]=false              - the Link from MIDI or FX parameter-checkbox
                                                                      true, checked; false, unchecked
                      ParmModTable["PARMLINK_LINKEDPLUGIN"]=-1    - the selected plugin; nil, if not available
                                                                      -1, nothing selected yet
                                                                      -100, MIDI-parameter-settings
                                                                      1 - the first fx-plugin
                                                                      2 - the second fx-plugin
                                                                      3 - the third fx-plugin, etc
                      ParmModTable["PARMLINK_LINKEDPARMIDX"]=-1   - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                                      When MIDI, this is irrelevant.
                                                                      When FX-parameter:
                                                                        0 to n; 0 for the first; 1, for the second, etc
      
                      ParmModTable["PARMLINK_OFFSET"]=0           - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
                      ParmModTable["PARMLINK_SCALE"]=1            - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
      
      
                      ParmModTable["MIDIPLINK"]=false             - true, if any parameter-linking with MIDI-stuff; false, if not
                                                                     Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                      ParmModTable["MIDIPLINK_BUS"]=nil           - the MIDI-bus selected in the button-menu; 
                                                                      0 to 15 for bus 1 to 16; 
                                                                      nil, if not available
                      ParmModTable["MIDIPLINK_CHANNEL"]=nil       - the MIDI-channel selected in the button-menu; 
                                                                      0, omni; 1 to 16 for channel 1 to 16; 
                                                                      nil, if not available
                                                                     
                      ParmModTable["MIDIPLINK_MIDICATEGORY"]=nil  - the MIDI_Category selected in the button-menu; nil, if not available
                                                                      144, MIDI note
                                                                      160, Aftertouch
                                                                      176, CC 14Bit and CC
                                                                      192, Program Change
                                                                      208, Channel Pressure
                                                                      224, Pitch
                      ParmModTable["MIDIPLINK_MIDINOTE"]=nil      - the MIDI-note selected in the button-menu; nil, if not available
                                                                      When MIDI note:
                                                                         0(C-2) to 127(G8)
                                                                      When Aftertouch:
                                                                         0(C-2) to 127(G8)
                                                                      When CC14 Bit:
                                                                         128 to 159; see dropdownlist for the commands(the order of the list 
                                                                         is the same as this numbering)
                                                                      When CC:
                                                                         0 to 119; see dropdownlist for the commands(the order of the list 
                                                                         is the same as this numbering)
                                                                      When Program Change:
                                                                         0
                                                                      When Channel Pressure:
                                                                         0
                                                                      When Pitch:
                                                                         0
                      ParmModTable["WINDOW_ALTERED"]=false         - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                                        Note: if true, this needs all WINDOW_-entries to be set
                      ParmModTable["WINDOW_ALTEREDOPEN"]=true      - if the position of the ParmMod-window is altered and currently open; 
                                                                       nil, unchanged; 0, unopened; 1, open
                      ParmModTable["WINDOW_XPOS"]=0                - the x-position of the altered ParmMod-window in pixels; nil, default position
                      ParmModTable["WINDOW_YPOS"]=40               - the y-position of the altered ParmMod-window in pixels; nil, default position
                      ParmModTable["WINDOW_RIGHT"]=594             - the right-position of the altered ParmMod-window in pixels; 
                                                                       nil, default position; only readable
                      ParmModTable["WINDOW_BOTTOM"]=729            - the bottom-position of the altered ParmMod-window in pixels; 
                                                                       nil, default position; only readable
          </code></pre>
    </description>
    <retvals>
      table ParmModTable - a ParmModTable with all settings set to Reaper's defaults 
    </retvals>
    <chapter_context>
      FX-Management
      Parameter Modulation
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, create, default, parameter modulation</tags>
  </US_DocBloc>
  --]] 
  
  local ParmModTable={}
  ParmModTable["AUDIOCONTROL_RELEASE"]=300
  ParmModTable["PARMLINK_LINKEDPLUGIN"]=-1
  ParmModTable["LFO_STRENGTH"]=1
  ParmModTable["LFO_SPEED"]=0.124573
  ParmModTable["WINDOW_ALTERED"]=false
  ParmModTable["AUDIOCONTROL_DIRECTION"]=1
  ParmModTable["AUDIOCONTROL_CHAN"]=1
  ParmModTable["AUDIOCONTROL_MINVOLUME"]=-24
  ParmModTable["AUDIOCONTROL_MAXVOLUME"]=0
  ParmModTable["AUDIOCONTROL_ATTACK"]=300
  ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]=true
  ParmModTable["LFO_SHAPEOLD"]=0
  ParmModTable["WINDOW_ALTEREDOPEN"]=true
  ParmModTable["PARAMOD_BASELINE"]=0
  ParmModTable["PARMLINK_LINKEDPARMIDX"]=-1
  ParmModTable["LFO_TEMPOSYNC"]=false
  ParmModTable["Y2"]=0.5
  ParmModTable["PARMLINK_OFFSET"]=0
  ParmModTable["WINDOW_YPOS"]=40
  ParmModTable["AUDIOCONTROL"]=false
  ParmModTable["WINDOW_XPOS"]=0
  ParmModTable["LFO"]=false
  ParmModTable["WINDOW_BOTTOM"]=729
  ParmModTable["LFO_DIRECTION"]=1
  ParmModTable["WINDOW_RIGHT"]=594
  ParmModTable["X2"]=0.5
  ParmModTable["PARAM_NR"]=1
  ParmModTable["MIDIPLINK"]=false
  ParmModTable["AUDIOCONTROL_STEREO"]=0
  ParmModTable["LFO_SHAPE"]=0
  ParmModTable["LFO_PHASE"]=0
  ParmModTable["AUDIOCONTROL_STRENGTH"]=1
  ParmModTable["PARMLINK_SCALE"]=1
  ParmModTable["PARMLINK"]=false
  ParmModTable["PARAM_TYPE"]=""
  ParmModTable["LFO_PHASERESET"]=0
  
  return ParmModTable
end

function ultraschall.IsValidParmModTable(ParmModTable)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsValidParmModTable</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.IsValidParmModTable(table ParmModTable)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      checks, if a ParmModTable is a valid one
      
      Does not check, if the value-ranges are valid, only if the datatypes are correct and if certain combinations are valid!
      
      Use SLEM() to get error-messages who tell you, which entries are problematic.
      
      returns false in case of an error
    </description>
    <retvals>
      boolean retval - true, ParmModTable is a valid one; false, ParmModTable has errors(use SLEM() to get which one)
    </retvals>
    <parameters>
      table ParmModTable - the table to check, if it's a valid ParmModTable
    </parameters>
    <chapter_context>
      FX-Management
      Parameter Modulation
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, check, parameter modulation, parmmodtable</tags>
  </US_DocBloc>
  --]] 
  -- check if table is valid in the first place
  if ParmModTable==nil then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModTable", "Warning: empty ParmModTable. This will remove a parameter-modulation if applied.", -100) return true end
  if type(ParmModTable)~="table" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModTable", "must be a table", -1) return false end
  
  -- check, if the contents of the table have valid datatypes
  if type(ParmModTable["AUDIOCONTROL"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL must be boolean", -2 ) return false end
  if math.type(ParmModTable["AUDIOCONTROL_ATTACK"])~=nil and math.type(ParmModTable["AUDIOCONTROL_ATTACK"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_ATTACK must either nil or be integer", -3 ) return false end
  if ParmModTable["AUDIOCONTROL_CHAN"]~=nil and math.type(ParmModTable["AUDIOCONTROL_CHAN"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_CHAN must be either nil or integer", -4) return false end
  if ParmModTable["AUDIOCONTROL_DIRECTION"]~=nil and math.type(ParmModTable["AUDIOCONTROL_DIRECTION"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_DIRECTION must be either nil or an integer", -5 ) return false end
  if ParmModTable["AUDIOCONTROL_MAXVOLUME"]~=nil and type(ParmModTable["AUDIOCONTROL_MAXVOLUME"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_MAXVOLUME must be either nil or a number", -6 ) return false end
  if ParmModTable["AUDIOCONTROL_MINVOLUME"]~=nil and type(ParmModTable["AUDIOCONTROL_MINVOLUME"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL MINVOLUME must be either nil or a number", -7 ) return false end
  if ParmModTable["AUDIOCONTROL_RELEASE"]~=nil and math.type(ParmModTable["AUDIOCONTROL_RELEASE"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_RELEASE must be either nil or an integer", -8 ) return false end
  if ParmModTable["AUDIOCONTROL_STEREO"]~=nil and math.type(ParmModTable["AUDIOCONTROL_STEREO"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_STEREO must be either nil or an integer", -9 ) return false end
  if type(ParmModTable["AUDIOCONTROL_STRENGTH"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL_STRENGTH must be a number", -10 ) return false end
  if type(ParmModTable["LFO"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO must be a boolean", -11 ) return false end
  if math.type(ParmModTable["LFO_DIRECTION"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_DIRECTION must be an integer", -12 ) return false end
  if ParmModTable["LFO_PHASE"]~=nil and type(ParmModTable["LFO_PHASE"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_PHASE must be either nil or a number", -13 ) return false end
  if ParmModTable["LFO_PHASERESET"]~=nil and math.type(ParmModTable["LFO_PHASERESET"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO PHASERESET must be either nil or an integer", -14 ) return false end
  if ParmModTable["LFO_SHAPE"]~=nil and math.type(ParmModTable["LFO_SHAPE"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_SHAPE must be either nil or an integer", -15 ) return false end
  if ParmModTable["LFO_SHAPEOLD"]~=nil and math.type(ParmModTable["LFO_SHAPEOLD"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_SHAPEOLD must be either nil or an integer", -16 ) return false end
  if ParmModTable["LFO_SPEED"]~=nil and type(ParmModTable["LFO_SPEED"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_SPEED must be either nil or a number", -17 ) return false end
  if type(ParmModTable["LFO_STRENGTH"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_STRENGTH must be a number", -18 ) return false end
  if type(ParmModTable["LFO_TEMPOSYNC"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO_TEMPOSYNC must be a boolean", -19 ) return false end
  if type(ParmModTable["MIDIPLINK"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK must be a boolean", -20 ) return false end
  if ParmModTable["MIDIPLINK_BUS"]~=nil and math.type(ParmModTable["MIDIPLINK_BUS"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK_BUS must be either nil or an integer", -21 ) return false end
  if ParmModTable["MIDIPLINK_CHANNEL"]~=nil and math.type(ParmModTable["MIDIPLINK_CHANNEL"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK_CHANNEL must be either nil or an integer", -22 ) return false end
  if ParmModTable["MIDIPLINK_MIDICATEGORY"]~=nil and math.type(ParmModTable["MIDIPLINK_MIDICATEGORY"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK_MIDICATEGORY must be either nil or an integer", -23 ) return false end
  if ParmModTable["MIDIPLINK_MIDINOTE"]~=nil and math.type(ParmModTable["MIDIPLINK_MIDINOTE"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK_MIDINOTE must be either nil or an integer", -24 ) return false end
  if math.type(ParmModTable["PARAM_NR"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARAM_NR must be an integer", -25 ) return false end
  if type(ParmModTable["PARAM_TYPE"])~="string" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARAM_TYPE must be wet or bypass or empty string", -26 ) return false end
  if type(ParmModTable["PARAMOD_BASELINE"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARAMOD_BASELINE must be a number", -27 ) return false end
  if type(ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARAMOD_ENABLE_PARAMETER_MODULATION must be boolean", -28 ) return false end
  if type(ParmModTable["PARMLINK"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK must be a boolean", -29 ) return false end
  if ParmModTable["PARMLINK_LINKEDPARMIDX"]~=nil and math.type(ParmModTable["PARMLINK_LINKEDPARMIDX"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_LINKEDPARMIDX must be either nil or an integer", -30 ) return false end
  if ParmModTable["PARMLINK_LINKEDPLUGIN"]~=nil and math.type(ParmModTable["PARMLINK_LINKEDPLUGIN"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_LINKEDPLUGIN must be either nil or an integer", -31 ) return false end
  if ParmModTable["PARMLINK_OFFSET"]~=nil and type(ParmModTable["PARMLINK_OFFSET"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_OFFSET must be either nil or a number", -32 ) return false end
  if ParmModTable["PARMLINK_SCALE"]~=nil and type(ParmModTable["PARMLINK_SCALE"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_SCALE must be either nil or a number", -33 ) return false end
  if type(ParmModTable["WINDOW_ALTERED"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_ALTERED must be boolean", -34 ) return false end
  if ParmModTable["WINDOW_ALTEREDOPEN"]~=nil and type(ParmModTable["WINDOW_ALTEREDOPEN"])~="boolean" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_ALTEREDOPEN must be either nil or a boolean", -35 ) return false end
  if ParmModTable["WINDOW_BOTTOM"]~=nil and math.type(ParmModTable["WINDOW_BOTTOM"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_BOTTOM must be either nil or an integer", -36 ) return false end
  if ParmModTable["WINDOW_RIGHT"]~=nil and math.type(ParmModTable["WINDOW_RIGHT"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_RIGHT must be either nil or an integer", -37 ) return false end
  if ParmModTable["WINDOW_XPOS"]~=nil and math.type(ParmModTable["WINDOW_XPOS"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_XPOS must be either nil or an integer", -38 ) return false end
  if ParmModTable["WINDOW_YPOS"]~=nil and math.type(ParmModTable["WINDOW_YPOS"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_YPOS must be either nil or an integer", -39 ) return false end
  if ParmModTable["X2"]~=nil and type(ParmModTable["X2"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry X2 must be either nil or a number", -40 ) return false end
  if ParmModTable["Y2"]~=nil and type(ParmModTable["Y2"])~="number" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry Y2 must be either nil or a number", -41 ) return false end
  
  -- check, if certain combinations are valid, like LFO-checkbox=true but some LFO-settings are still set to nil
  if ParmModTable["PARMLINK"]==true then
    local errormsg=""
    if ParmModTable["PARMLINK_LINKEDPARMIDX"]==nil then errormsg=errormsg.."PARMLINK_LINKEDPARMIDX, " end
    if ParmModTable["PARMLINK_LINKEDPLUGIN"]==nil then  errormsg=errormsg.."PARMLINK_LINKEDPLUGIN, " end
    if ParmModTable["PARMLINK_OFFSET"]==nil then        errormsg=errormsg.."PARMLINK_OFFSET, " end
    if ParmModTable["PARMLINK_SCALE"]==nil then         errormsg=errormsg.."PARMLINK_SCALE, " end
    if errormsg~="" then
      ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK=true but "..errormsg:sub(1,-3).." still set to nil", -46 ) 
      return false
    end
  end

  if ParmModTable["MIDIPLINK"]==true then
    if ParmModTable["PARMLINK_LINKEDPLUGIN"]~=-100 then
       ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK=true but PARMLINK_LINKEDPLUGIN is not set to -100", -43 ) return false
    end
    local errormsg=""
    if ParmModTable["MIDIPLINK_BUS"]==nil then           errormsg=errormsg.."MIDIPLINK_BUS, " end
    if ParmModTable["MIDIPLINK_CHANNEL"]==nil then       errormsg=errormsg.."MIDIPLINK_CHANNEL, " end
    if ParmModTable["MIDIPLINK_MIDICATEGORY"]==nil then  errormsg=errormsg.."MIDIPLINK_MIDICATEGORY, " end
    if ParmModTable["MIDIPLINK_MIDINOTE"]==nil then      errormsg=errormsg.."MIDIPLINK_MIDINOTE, " end
    if errormsg~="" then
      ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry MIDIPLINK=true but "..errormsg:sub(1,-3).." still set to nil", -46 ) 
      return false
    end
  end
  
  if ParmModTable["LFO"]==true then
    local errormsg=""
    if ParmModTable["LFO_PHASE"]==nil then       errormsg=errormsg.."LFO_PHASE, " end
    if ParmModTable["LFO_PHASERESET"]==nil then  errormsg=errormsg.."LFO_PHASERESET, " end
    if ParmModTable["LFO_SHAPE"]==nil then       errormsg=errormsg.."LFO_SHAPE, " end
    if ParmModTable["LFO_SHAPEOLD"]==nil then    errormsg=errormsg.."LFO_SHAPEOLD, " end
    if ParmModTable["LFO_SPEED"]==nil then       errormsg=errormsg.."LFO_SPEED, " end
    if errormsg~="" then
      ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry LFO=true but "..errormsg:sub(1,-3).." still set to nil", -46 ) 
      return false
    end
  end
  
  if ParmModTable["WINDOW_ALTERED"]==true then
    local errormsg=""
    if ParmModTable["WINDOW_ALTEREDOPEN"]==nil then errormsg=errormsg.."WINDOW_ALTEREDOPEN, " end
    if ParmModTable["WINDOW_BOTTOM"]==nil then      errormsg=errormsg.."WINDOW_BOTTOM, " end
    if ParmModTable["WINDOW_RIGHT"]==nil then       errormsg=errormsg.."WINDOW_RIGHT, " end
    if ParmModTable["WINDOW_XPOS"]==nil then        errormsg=errormsg.."WINDOW_XPOS, " end
    if ParmModTable["WINDOW_YPOS"]==nil then        errormsg=errormsg.."WINDOW_YPOS, " end
    if errormsg~="" then
      ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry WINDOW_ALTERED=true but "..errormsg:sub(1,-3).." still set to nil", -46 ) 
      return false
    end
  end

  if ParmModTable["AUDIOCONTROL"]==true then
    local errormsg=""
    if ParmModTable["AUDIOCONTROL_ATTACK"]==nil then    errormsg=errormsg.."AUDIOCONTROL_ATTACK, " end
    if ParmModTable["AUDIOCONTROL_CHAN"]==nil then      errormsg=errormsg.."AUDIOCONTROL_CHAN, " end
    if ParmModTable["AUDIOCONTROL_MAXVOLUME"]==nil then errormsg=errormsg.."AUDIOCONTROL_MAXVOLUME, " end
    if ParmModTable["AUDIOCONTROL_MINVOLUME"]==nil then errormsg=errormsg.."AUDIOCONTROL_MINVOLUME, " end
    if ParmModTable["AUDIOCONTROL_RELEASE"]==nil   then errormsg=errormsg.."AUDIOCONTROL_RELEASE, " end
    if ParmModTable["AUDIOCONTROL_STEREO"]==nil then    errormsg=errormsg.."AUDIOCONTROL_STEREO, " end
    if ParmModTable["X2"]==nil then    errormsg=errormsg.."X2, " end
    if ParmModTable["Y2"]==nil then    errormsg=errormsg.."Y2, " end
    if errormsg~="" then 
      ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry AUDIOCONTROL=true but "..errormsg:sub(1,-3).." still set to nil", -47 ) 
      return false
    end
  end
  
  if ParmModTable["MIDIPLINK"]==false and ParmModTable["PARMLINK_LINKEDPLUGIN"]==-100 then
    ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_LINKEDPLUGIN=-100(linked plugin is MIDI) but MIDIPLINK(selected MIDI-plugin) is set to false", -48 ) return false
  end
  return true
end

function ultraschall.AddParmMod_ParmModTable(FXStateChunk, fxindex, ParmModTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddParmMod_ParmModTable</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.AddParmMod_ParmModTable(string FXStateChunk, integer fxindex, table ParmModTable)</functioncall>
  <description>
    Takes a ParmModTable and adds with its values a new Parameter Modulation of a specific fx within an FXStateChunk.
  
    The expected table's format is as follows:
    <pre><code>
                ParmModTable["PARAM_NR"]               - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
                ParmModTable["PARAM_TYPE"]             - the type of the parameter, usually "", "wet" or "bypass"

                ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                        - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                          true, checked; false, unchecked
                ParmModTable["PARAMOD_BASELINE"]       - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                            0.000 to 1.000

                ParmModTable["AUDIOCONTROL"]           - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all AUDIOCONTROL_-entries to be set                
                ParmModTable["AUDIOCONTROL_CHAN"]      - the Track audio channel-dropdownlist; When stereo, the first stereo-channel; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STEREO"]    - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                            AUDIOCONTROL_CHAN+1; nil, if not available
                ParmModTable["AUDIOCONTROL_ATTACK"]    - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
                ParmModTable["AUDIOCONTROL_RELEASE"]   - the Release-slider; 0-1000ms; nil, if not available
                ParmModTable["AUDIOCONTROL_MINVOLUME"] - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_MAXVOLUME"] - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STRENGTH"]  - the Strength-slider; 0(0%) to 1000(100%)
                ParmModTable["AUDIOCONTROL_DIRECTION"] - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
                ParmModTable["X2"]=0.5                 - the audiocontrol signal shaping-x-coordinate
                ParmModTable["Y2"]=0.5                 - the audiocontrol signal shaping-y-coordinate    
                
                ParmModTable["LFO"]                    - if the LFO-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all LFO_-entries to be set
                ParmModTable["LFO_SHAPE"]              - the LFO Shape-dropdownlist; 
                                                            0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                            nil, if not available
                ParmModTable["LFO_SHAPEOLD"]           - use the old-style of the LFO_SHAPE; 
                                                            0, use current style of LFO_SHAPE; 
                                                            1, use old style of LFO_SHAPE; 
                                                            nil, if not available
                ParmModTable["LFO_TEMPOSYNC"]          - the Tempo sync-checkbox; true, checked; false, unchecked
                ParmModTable["LFO_SPEED"]              - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
                ParmModTable["LFO_STRENGTH"]           - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
                ParmModTable["LFO_PHASE"]              - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
                ParmModTable["LFO_DIRECTION"]          - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
                ParmModTable["LFO_PHASERESET"]         - the LFO Phase reset-dropdownlist; 
                                                            0, On seek/loop(deterministic output)
                                                            1, Free-running(non-deterministic output)
                                                            nil, if not available
                
                ParmModTable["MIDIPLINK"]              - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["PARMLINK"]               - the Link from MIDI or FX parameter-checkbox
                                                          true, checked; false, unchecked
                ParmModTable["PARMLINK_LINKEDPLUGIN"]  - the selected plugin; nil, if not available
                                                            -1, nothing selected yet
                                                            -100, MIDI-parameter-settings
                                                            1 - the first fx-plugin
                                                            2 - the second fx-plugin
                                                            3 - the third fx-plugin, etc
                ParmModTable["PARMLINK_LINKEDPARMIDX"] - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                            When MIDI, this is irrelevant.
                                                            When FX-parameter:
                                                              0 to n; 0 for the first; 1, for the second, etc

                ParmModTable["PARMLINK_OFFSET"]        - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
                ParmModTable["PARMLINK_SCALE"]         - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

                ParmModTable["MIDIPLINK"]              - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["MIDIPLINK_BUS"]          - the MIDI-bus selected in the button-menu; 
                                                            0 to 15 for bus 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_CHANNEL"]      - the MIDI-channel selected in the button-menu; 
                                                            0, omni; 1 to 16 for channel 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_MIDICATEGORY"] - the MIDI_Category selected in the button-menu; nil, if not available
                                                            144, MIDI note
                                                            160, Aftertouch
                                                            176, CC 14Bit and CC
                                                            192, Program Change
                                                            208, Channel Pressure
                                                            224, Pitch
                ParmModTable["MIDIPLINK_MIDINOTE"]     - the MIDI-note selected in the button-menu; nil, if not available
                                                          When MIDI note:
                                                               0(C-2) to 127(G8)
                                                          When Aftertouch:
                                                               0(C-2) to 127(G8)
                                                          When CC14 Bit:
                                                               128 to 159; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When CC:
                                                               0 to 119; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When Program Change:
                                                               0
                                                          When Channel Pressure:
                                                               0
                                                          When Pitch:
                                                               0
                ParmModTable["WINDOW_ALTERED"]         - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                            Note: if true, this needs all WINDOW_-entries to be set
                ParmModTable["WINDOW_ALTEREDOPEN"]     - if the position of the ParmMod-window is altered and currently open; 
                                                            nil, unchanged; 0, unopened; 1, open
                ParmModTable["WINDOW_XPOS"]            - the x-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_YPOS"]            - the y-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_RIGHT"]           - the right-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
                ParmModTable["WINDOW_BOTTOM"]          - the bottom-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
    </code></pre>
    
    This function does not check, if the values are within valid value-ranges, only if the datatypes are valid.
    
    returns nil in case of an error
  </description>
  <parameters>
    string FXStateChunk - an FXStateChunk, of which you want to add the values of a specific parameter-modulation
    integer fxindex - the index of the fx, of which you want to add specific parameter-modulation-values
    table ParmModTable - the table which holds all parameter-modulation-values to be added
  </parameters>
  <retvals>
    string FXStateChunk - the altered FXStateChunk, where the ParameterModulation shall be added
  </retvals>
  <chapter_context>
    FX-Management
    Parameter Modulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, parameter modulation, table, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidParmModTable(ParmModTable)==false then ultraschall.AddErrorMessage("AddParmMod_ParmModTable", "ParmModTable", SLEM(nil, 3, 5), -1) return FXStateChunk end
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmMod_ParmModTable", "FXStateChunk", "must be a valid FXStateChunk", -2) return FXStateChunk end
  
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("AddParmMod_ParmModTable", "fxindex", "must be an integer", -3) return FXStateChunk end
  if fxindex<1 then ultraschall.AddErrorMessage("AddParmMod_ParmModTable", "fxindex", "must be bigger than 0", -4) return FXStateChunk end
    
  local NewParmModTable=""
  if ParmModTable~=nil and (ParmModTable["PARMLINK"]==true or ParmModTable["LFO"]==true or ParmModTable["AUDIOCONTROL"]==true) then
    local Sep=""
    local LFO, AudioControl, LinkedPlugin, offset, ParmModEnable, LFOTempoSync, WindowAlteredOpen
    if ParmModTable["PARAM_TYPE"]~="" then Sep=":" end
    if ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]==true then ParmModEnable=0 else ParmModEnable=1 end
    if ParmModTable["LFO"]==true then LFO=1 else LFO=0 end
    if ParmModTable["AUDIOCONTROL"]==true then AudioControl=1 else AudioControl=0 end
    
    NewParmModTable=
    " <PROGRAMENV "..(tonumber(ParmModTable["PARAM_NR"])-1)..Sep..ParmModTable["PARAM_TYPE"].." "..ParmModEnable.."\n"..
    "      PARAMBASE " ..ParmModTable["PARAMOD_BASELINE"].."\n"..
    "      LFO "       ..LFO.."\n"..
    "      LFOWT "     ..ParmModTable["LFO_STRENGTH"].." "..ParmModTable["LFO_DIRECTION"].."\n"..
    "      AUDIOCTL "  ..AudioControl.."\n"..
    "      AUDIOCTLWT "..ParmModTable["AUDIOCONTROL_STRENGTH"].." "..ParmModTable["AUDIOCONTROL_DIRECTION"].."\n"
    
    -- if ParameterLinking is enabled, then add this line
    if ParmModTable["PARMLINK"]==true then 
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]>=0 then
        LinkedPlugin=(ParmModTable["PARMLINK_LINKEDPLUGIN"]-1)..":"..(ParmModTable["PARMLINK_LINKEDPLUGIN"]-1)
      else
        LinkedPlugin=tostring(ParmModTable["PARMLINK_LINKEDPLUGIN"])
      end
      if ParmModTable["PARMLINK_LINKEDPARMIDX"]==-1 then offset=0 else offset=1 end
      NewParmModTable=NewParmModTable..
    "      PLINK "..ParmModTable["PARMLINK_SCALE"].." "..LinkedPlugin.." "..(ParmModTable["PARMLINK_LINKEDPARMIDX"]-offset).." "..ParmModTable["PARMLINK_OFFSET"].."\n"
    
      -- if midi-parameter is linked, then add this line
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]<-1 then
        NewParmModTable=NewParmModTable.."      MIDIPLINK "..(ParmModTable["MIDIPLINK_BUS"]-1).." "..ParmModTable["MIDIPLINK_CHANNEL"].." "..ParmModTable["MIDIPLINK_MIDICATEGORY"].." "..ParmModTable["MIDIPLINK_MIDINOTE"].."\n"
      end
    end
    
    -- if LFO is turned on, add these lines
    if ParmModTable["LFO"]==true then
      if ParmModTable["LFO_TEMPOSYNC"]==true then LFOTempoSync=1 else LFOTempoSync=0 end
      NewParmModTable=NewParmModTable..
    "      LFOSHAPE "..ParmModTable["LFO_SHAPE"].."\n"..
    "      LFOSYNC " ..LFOTempoSync.." "..ParmModTable["LFO_SHAPEOLD"].." "..ParmModTable["LFO_PHASERESET"].."\n"..
    "      LFOSPEED "..ParmModTable["LFO_SPEED"].." "..ParmModTable["LFO_PHASE"].."\n"
    end
    
    -- if Audio Control Signal(sidechain) is enabled, add these lines
    if ParmModTable["AUDIOCONTROL"]==true then
      NewParmModTable=NewParmModTable..
    "      CHAN "  ..(ParmModTable["AUDIOCONTROL_CHAN"]-1).."\n"..
    "      STEREO "..(ParmModTable["AUDIOCONTROL_STEREO"]).."\n"..
    "      RMS "   ..(ParmModTable["AUDIOCONTROL_ATTACK"]).." "..(ParmModTable["AUDIOCONTROL_RELEASE"]).."\n"..
    "      DBLO "  ..(ParmModTable["AUDIOCONTROL_MINVOLUME"]).."\n"..
    "      DBHI "  ..(ParmModTable["AUDIOCONTROL_MAXVOLUME"]).."\n"..
    "      X2 "    ..(ParmModTable["X2"]).."\n"..
    "      Y2 "    ..(ParmModTable["Y2"]).."\n"
    end
    
    -- if the window shall be modified, add these lines
    if ParmModTable["WINDOW_ALTERED"]==true then
      if ParmModTable["WINDOW_ALTEREDOPEN"]==true then 
        WindowAlteredOpen=1
      else
        WindowAlteredOpen=0
      end
      
      NewParmModTable=NewParmModTable..
    "      MODWND "..WindowAlteredOpen.." "..ParmModTable["WINDOW_XPOS"].." "..ParmModTable["WINDOW_YPOS"].." "..ParmModTable["WINDOW_RIGHT"].." "..ParmModTable["WINDOW_BOTTOM"].."\n"
    end
    
    NewParmModTable=NewParmModTable.."    >\n"
  end
  local cindex=0

  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  
  
  FX=FX:match("(.*\n%s-)%sWAK")..NewParmModTable..FX:match("%s-WAK.*")
  
  return string.gsub(FXStateChunk:sub(1,StartOFS)..FX.."\n"..FXStateChunk:sub(EndOFS, -1), "\n\n", "\n")
end


function ultraschall.SetParmMod_ParmModTable(FXStateChunk, fxindex, ParmModTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmMod_ParmModTable</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetParmMod_ParmModTable(string FXStateChunk, integer fxindex, table ParmModTable)</functioncall>
  <description>
    Takes a ParmModTable and sets its values into a Parameter Modulation of a specific fx within an FXStateChunk.
  
    The expected table's format is as follows:
    <pre><code>
                ParmModTable["PARAM_NR"]               - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
                ParmModTable["PARAM_TYPE"]             - the type of the parameter, usually "", "wet" or "bypass"

                ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                        - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                          true, checked; false, unchecked
                ParmModTable["PARAMOD_BASELINE"]       - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                            0.000 to 1.000

                ParmModTable["AUDIOCONTROL"]           - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all AUDIOCONTROL_-entries to be set
                ParmModTable["AUDIOCONTROL_CHAN"]      - the Track audio channel-dropdownlist; When stereo, the first stereo-channel; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STEREO"]    - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                            AUDIOCONTROL_CHAN+1; nil, if not available
                ParmModTable["AUDIOCONTROL_ATTACK"]    - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
                ParmModTable["AUDIOCONTROL_RELEASE"]   - the Release-slider; 0-1000ms; nil, if not available
                ParmModTable["AUDIOCONTROL_MINVOLUME"] - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_MAXVOLUME"] - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STRENGTH"]  - the Strength-slider; 0(0%) to 1000(100%)
                ParmModTable["AUDIOCONTROL_DIRECTION"] - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
                ParmModTable["X2"]=0.5                 - the audiocontrol signal shaping-x-coordinate
                ParmModTable["Y2"]=0.5                 - the audiocontrol signal shaping-y-coordinate    
                
                ParmModTable["LFO"]                    - if the LFO-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all LFO_-entries to be set
                ParmModTable["LFO_SHAPE"]              - the LFO Shape-dropdownlist; 
                                                            0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                            nil, if not available
                ParmModTable["LFO_SHAPEOLD"]           - use the old-style of the LFO_SHAPE; 
                                                            0, use current style of LFO_SHAPE; 
                                                            1, use old style of LFO_SHAPE; 
                                                            nil, if not available
                ParmModTable["LFO_TEMPOSYNC"]          - the Tempo sync-checkbox; true, checked; false, unchecked
                ParmModTable["LFO_SPEED"]              - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
                ParmModTable["LFO_STRENGTH"]           - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
                ParmModTable["LFO_PHASE"]              - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
                ParmModTable["LFO_DIRECTION"]          - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
                ParmModTable["LFO_PHASERESET"]         - the LFO Phase reset-dropdownlist; 
                                                            0, On seek/loop(deterministic output)
                                                            1, Free-running(non-deterministic output)
                                                            nil, if not available

                ParmModTable["PARMLINK"]               - the Link from MIDI or FX parameter-checkbox
                                                          true, checked; false, unchecked
                ParmModTable["PARMLINK_LINKEDPLUGIN"]  - the selected plugin; nil, if not available
                                                            -1, nothing selected yet
                                                            -100, MIDI-parameter-settings
                                                            1 - the first fx-plugin
                                                            2 - the second fx-plugin
                                                            3 - the third fx-plugin, etc
                ParmModTable["PARMLINK_LINKEDPARMIDX"] - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                            When MIDI, this is irrelevant.
                                                            When FX-parameter:
                                                              0 to n; 0 for the first; 1, for the second, etc

                ParmModTable["PARMLINK_OFFSET"]        - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
                ParmModTable["PARMLINK_SCALE"]         - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

                ParmModTable["MIDIPLINK"]              - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["MIDIPLINK_BUS"]          - the MIDI-bus selected in the button-menu; 
                                                            0 to 15 for bus 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_CHANNEL"]      - the MIDI-channel selected in the button-menu; 
                                                            0, omni; 1 to 16 for channel 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_MIDICATEGORY"] - the MIDI_Category selected in the button-menu; nil, if not available
                                                            144, MIDI note
                                                            160, Aftertouch
                                                            176, CC 14Bit and CC
                                                            192, Program Change
                                                            208, Channel Pressure
                                                            224, Pitch
                ParmModTable["MIDIPLINK_MIDINOTE"]     - the MIDI-note selected in the button-menu; nil, if not available
                                                          When MIDI note:
                                                               0(C-2) to 127(G8)
                                                          When Aftertouch:
                                                               0(C-2) to 127(G8)
                                                          When CC14 Bit:
                                                               128 to 159; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When CC:
                                                               0 to 119; see dropdownlist for the commands(the order of the list 
                                                               is the same as this numbering)
                                                          When Program Change:
                                                               0
                                                          When Channel Pressure:
                                                               0
                                                          When Pitch:
                                                               0
                ParmModTable["WINDOW_ALTERED"]         - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                            Note: if true, this needs all WINDOW_-entries to be set
                ParmModTable["WINDOW_ALTEREDOPEN"]     - if the position of the ParmMod-window is altered and currently open; 
                                                            nil, unchanged; 0, unopened; 1, open
                ParmModTable["WINDOW_XPOS"]            - the x-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_YPOS"]            - the y-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_RIGHT"]           - the right-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
                ParmModTable["WINDOW_BOTTOM"]          - the bottom-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
    </code></pre>
    
    This function does not check, if the values are within valid value-ranges, only if the datatypes are valid.
    
    Note: If you want to apply a ParmModulationTable from a bypass/wet-parameter to a non bypass/wet-parameter, you need to set ParmModTable["PARAM_TYPE"]="" or it will remove the parameter-modulation!
    Also note: set ParmModTable["PARAM_NR"] to choose the parameter-index, whose ParameterModulation shall be set.
    
    returns nil in case of an error
  </description>
  <parameters>
    string FXStateChunk - an FXStateChunk, of which you want to set the values of a specific parameter-modulation
    integer fxindex - the index if the fx, of which you want to set specific parameter-modulation-values
    table ParmModTable - the table which holds all parameter-modulation-values to be set
  </parameters>
  <retvals>
    string FXStateChunk - the altered FXStateChunk, where the ParameterModulation had been set
  </retvals>
  <chapter_context>
    FX-Management
    Parameter Modulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, parameter modulation, table, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidParmModTable(ParmModTable)==false then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "ParmModTable", SLEM(nil, 3, 5), -1) return FXStateChunk end
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "FXStateChunk", "must be a valid FXStateChunk", -2) return FXStateChunk end
  
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "fxindex", "must be an integer", -5) return FXStateChunk end
  if fxindex<1 then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "fxindex", "must be bigger than 0", -6) return FXStateChunk end
    
  local NewParmModTable=""
  
  if ParmModTable~=nil and (ParmModTable["PARMLINK"]==true or ParmModTable["LFO"]==true or ParmModTable["AUDIOCONTROL"]==true) then
    
    
    local Sep=""
    local LFO, AudioControl, LinkedPlugin, offset, ParmModEnable, LFOTempoSync, WindowAlteredOpen
    if ParmModTable["PARAM_TYPE"]~="" then Sep=":" end
    if ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"]==true then ParmModEnable=0 else ParmModEnable=1 end
    if ParmModTable["LFO"]==true then LFO=1 else LFO=0 end
    if ParmModTable["AUDIOCONTROL"]==true then AudioControl=1 else AudioControl=0 end
    
    NewParmModTable=
    " <PROGRAMENV "..(tonumber(ParmModTable["PARAM_NR"])-1)..Sep..ParmModTable["PARAM_TYPE"].." "..ParmModEnable.."\n"..
    "      PARAMBASE " ..ParmModTable["PARAMOD_BASELINE"].."\n"..
    "      LFO "       ..LFO.."\n"..
    "      LFOWT "     ..ParmModTable["LFO_STRENGTH"].." "..ParmModTable["LFO_DIRECTION"].."\n"..
    "      AUDIOCTL "  ..AudioControl.."\n"..
    "      AUDIOCTLWT "..ParmModTable["AUDIOCONTROL_STRENGTH"].." "..ParmModTable["AUDIOCONTROL_DIRECTION"].."\n"
    
    -- if ParameterLinking is enabled, then add this line
    if ParmModTable["PARMLINK"]==true then 
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]>=0 then
        LinkedPlugin=(ParmModTable["PARMLINK_LINKEDPLUGIN"]-1)..":"..(ParmModTable["PARMLINK_LINKEDPLUGIN"]-1)
      else
        LinkedPlugin=tostring(ParmModTable["PARMLINK_LINKEDPLUGIN"])
      end
      if ParmModTable["PARMLINK_LINKEDPARMIDX"]==-1 then offset=0 else offset=1 end
      NewParmModTable=NewParmModTable..
    "      PLINK "..ParmModTable["PARMLINK_SCALE"].." "..LinkedPlugin.." "..(ParmModTable["PARMLINK_LINKEDPARMIDX"]-offset).." "..ParmModTable["PARMLINK_OFFSET"].."\n"
    
      -- if midi-parameter is linked, then add this line
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]<-1 then
        NewParmModTable=NewParmModTable.."      MIDIPLINK "..(ParmModTable["MIDIPLINK_BUS"]-1).." "..ParmModTable["MIDIPLINK_CHANNEL"].." "..ParmModTable["MIDIPLINK_MIDICATEGORY"].." "..ParmModTable["MIDIPLINK_MIDINOTE"].."\n"
      end
    end
    
    -- if LFO is turned on, add these lines
    if ParmModTable["LFO"]==true then
      if ParmModTable["LFO_TEMPOSYNC"]==true then LFOTempoSync=1 else LFOTempoSync=0 end      
      NewParmModTable=NewParmModTable..
    "      LFOSHAPE "..ParmModTable["LFO_SHAPE"].."\n"..
    "      LFOSYNC " ..LFOTempoSync.." "..ParmModTable["LFO_SHAPEOLD"].." "..ParmModTable["LFO_PHASERESET"].."\n"..
    "      LFOSPEED "..ParmModTable["LFO_SPEED"].." "..ParmModTable["LFO_PHASE"].."\n"
    end
    
    -- if Audio Control Signal(sidechain) is enabled, add these lines
    if ParmModTable["AUDIOCONTROL"]==true then
      NewParmModTable=NewParmModTable..
    "      CHAN "  ..(ParmModTable["AUDIOCONTROL_CHAN"]-1).."\n"..
    "      STEREO "..(ParmModTable["AUDIOCONTROL_STEREO"]).."\n"..
    "      RMS "   ..(ParmModTable["AUDIOCONTROL_ATTACK"]).." "..(ParmModTable["AUDIOCONTROL_RELEASE"]).."\n"..
    "      DBLO "  ..(ParmModTable["AUDIOCONTROL_MINVOLUME"]).."\n"..
    "      DBHI "  ..(ParmModTable["AUDIOCONTROL_MAXVOLUME"]).."\n"..
    "      X2 "    ..(ParmModTable["X2"]).."\n"..
    "      Y2 "    ..(ParmModTable["Y2"]).."\n"
    end
    
    -- if the window shall be modified, add these lines
    if ParmModTable["WINDOW_ALTERED"]==true then
      if ParmModTable["WINDOW_ALTEREDOPEN"]==true then 
        WindowAlteredOpen=1
      else
        WindowAlteredOpen=0
      end
      
      NewParmModTable=NewParmModTable..
    "      MODWND "..WindowAlteredOpen.." "..ParmModTable["WINDOW_XPOS"].." "..ParmModTable["WINDOW_YPOS"].." "..ParmModTable["WINDOW_RIGHT"].." "..ParmModTable["WINDOW_BOTTOM"].."\n"
    end
    
    NewParmModTable=NewParmModTable.."    >\n"
  end
  local cindex=0

  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  
  local Start, Middle, End = FX:match("()(<PROGRAMENV "..(tonumber(ParmModTable["PARAM_NR"])-1).."[:%s]+.-  >)()")
  if Middle==nil then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "Parameter: "..tonumber(ParmModTable["PARAM_NR"]), "no such parameter-modulation", -4) return FXStateChunk end
  
  FX=FX:sub(1, Start-2)..NewParmModTable..FX:sub(End+1, -1)

  return string.gsub(FXStateChunk:sub(1,StartOFS)..FX.."\n"..FXStateChunk:sub(EndOFS, -1), "\n\n", "\n")
end

function ultraschall.DeleteParmModFromFXStateChunk(FXStateChunk, fxindex, parmidx)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>DeleteParmModFromFXStateChunk</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string altered_FXStateChunk, boolean altered = ultraschall.DeleteParmModFromFXStateChunk(string FXStateChunk, integer fxindex, integer parmidx)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      deletes a parameter-modulation of a specific fx from an FXStateChunk
      
      retval altered returns false in case of an error
    </description>
    <retvals>
      string altered_FXStateChunk - the FXStateChunk, from which the 
      boolean altered - true, deleting was successful; false, deleting was unsuccessful
    </retvals>
    <parameters>
      string FXStateChunk - the FXStateChunk from which you want to delete a parameter-modulation of a specific fx
      integer fxindex - the index of the fx, whose parameter-modulations you want to delete
      integer parmmodidx - the parameter-index, whose parameter-modulation you want to delete
    </parameters>
    <chapter_context>
      FX-Management
      Parameter Modulation
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, delete, parameter modulation, fxstatechunk</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmModFromFXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return FXStateChunk, false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("DeleteParmModFromFXStateChunk", "parmidx", "must be an integer", -2) return FXStateChunk, false end
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("DeleteParmModFromFXStateChunk", "fxindex", "must be an integer", -3) return FXStateChunk, false end
  if parmidx<1 then ultraschall.AddErrorMessage("DeleteParmModFromFXStateChunk", "parmidx", "must be bigger than 0", -4) return FXStateChunk, false end
  
  local index=0
  
  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  
  local Start, Middle, End = FX:match("()(<PROGRAMENV "..(parmidx-1).."[:%s]+.-  >)()")
  if Middle==nil then ultraschall.AddErrorMessage("DeleteParmModFromFXStateChunk", "parmidx", "no such parameter-modulation-entry found", -6) return FXStateChunk, false end
  
  FX=FX:sub(1, Start-4)..""..FX:sub(End+1, -1)

  return string.gsub(FXStateChunk:sub(1,StartOFS)..FX.."\n"..FXStateChunk:sub(EndOFS, -1), "\n\n", "\n"), true
end

function ultraschall.CountParmModFromFXStateChunk(FXStateChunk, fxindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>CountParmModFromFXStateChunk</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>integer number_of_parmmodulations = ultraschall.CountParmModFromFXStateChunk(string FXStateChunk, integer fxindex)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the number of parameter-modulations available for a specific fx in an FXStateChunk
      
      returns -1 in case of an error
    </description>
    <retvals>
      integer number_of_parmmodulations - the number of parameter-modulations available for this fx within this FXStateChunk
    </retvals>
    <parameters>
      string FXStateChunk - the FXStateChunk from which you want to count the parameter-modulations available for a specific fx
      integer fxindex - the index of the fx, whose number of parameter-modulations you want to know
    </parameters>
    <chapter_context>
      FX-Management
      Parameter Modulation
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, count, parameter modulation, fxstatechunk</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountParmModFromFXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return -1 end
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("CountParmModFromFXStateChunk", "fxindex", "must be an integer", -2) return end
  
  local index=0

  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  if FX==nil then ultraschall.AddErrorMessage("CountParmModFromFXStateChunk", "fxindex", "no such fx", -3) return end
  for k,v in string.gmatch(FX, "()  <PROGRAMENV.-\n%s->()\n") do
    index=index+1
  end

  return index
end



function ultraschall.GetAllParmAliasNames_FXStateChunk(FXStateChunk, fxindex)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllParmAliasNames_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>integer count_aliasnames, array parameteridx, array parameter_aliasnames = ultraschall.GetAllParmAliasNames_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all aliasnames of a specific fx within an FXStateChunk
    
    returns false in case of an error
  </description>
  <retvals>
    integer count_aliasnames - the number of parameter-aliases found for this fx
    array parameteridx - an array, which holds all parameter-index-numbers of all fx with parameter-aliasnames
    array parameter_aliasnames - an array with all parameter-aliasnames found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to get all Parm-Aliases
    integer fxid - the id of the fx, whose Parm-Aliases you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, all, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetAllParmAliasNames_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return -1 end
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("GetAllParmAliasNames_FXStateChunk", "fxindex", "must be an integer", -2) return -1 end
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  if fx_lines==nil then ultraschall.AddErrorMessage("GetAllParmAliasNames_FXStateChunk", "fxindex", "no such fx", -3) return -1 end
  local aliasnames={}
  local aliasparm={}
  local aliascount=0
  for parmidx, k in string.gmatch(fx_lines, "%s-PARMALIAS (.-) (.-)\n") do
    aliascount=aliascount+1
    aliasnames[aliascount]=k
    aliasparm[aliascount]=tonumber(parmidx)+1
  end
  for i=1, aliascount do
    if aliasnames[i]:sub(1,1)=="\"" and aliasnames[i]:sub(-1,-1)=="\"" then aliasnames[i]=aliasnames[i]:sub(2,-2) end
  end
  return aliascount, aliasparm, aliasnames
end

function ultraschall.DeleteParmAlias2_FXStateChunk(FXStateChunk, fxid, parmidx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmAlias2_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmAlias2_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a ParmAlias-entry from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
    Unlike DeleteParmAlias_FXStateChunk, this indexes aliasnames by parameter-index directly, not by number of already existing aliasnames.
    When in doubt, use this one.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmAlias from
    integer fxid - the id of the fx, which holds the to-delete-ParmAlias-entry; beginning with 1
    integer parmidx - the id of the parameter, whose parmalias you want to delete; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, parm, alias, delete, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmAlias2_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmAlias2_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("DeleteParmAlias2_FXStateChunk", "parmidx", "must be an integer", -3) return false end
    
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  if UseFX~=nil then
    UseFX2=string.gsub(UseFX, "\n%s-PARMALIAS "..(parmidx-1).." .-\n", "\n")
    if UseFX2==UseFX then UseFX2=nil end
  end  
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
  else
    return false, FXStateChunk
  end
end

function ultraschall.GetParmAlias2_FXStateChunk(FXStateChunk, fxid, parmidx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmAlias2_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parm_aliasname = ultraschall.GetParmAlias2_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-alias-setting of a specific parameter from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Parameter-aliases are only stored for MediaTracks.
    
    It is the PARMALIAS-entry
    
    Returns nil in case of an error or if no such aliasname has been found
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parm_aliasname - the alias-name of the parameter
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmAlias-settings
    integer fxid - the fx, of which you want to get the parameter-alias-settings
    integer parmidx - the id of the parameter whose aliasname you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, alias, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmAlias2_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("GetParmAlias2_FXStateChunk", "parmidx", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmAlias2_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  
  if fx_lines==nil then ultraschall.AddErrorMessage("GetParmAlias2_FXStateChunk", "fxid", "no such fx", -4) return nil end

  local aliasname=fx_lines:match("\n%s-PARMALIAS "..(parmidx-1).." (.-)\n")
  if aliasname:sub(1,1)=="\"" and aliasname:sub(-1,-1)=="\"" then aliasname=aliasname:sub(2,-2) end
  
  return aliasname
end