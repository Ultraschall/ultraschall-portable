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
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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


function ultraschall.GetFXFromFXStateChunk(FXStateChunk, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXFromFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string fx = ultraschall.GetFXFromFXStateChunk(string FXStateChunk, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all lines of a specific TrackFX/ItemFX from a StateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string fx - all lines of an fx from a statechunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the FX-entries
    integer id - the id of the FX-entries you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, fx</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXFromFXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetFXFromFXStateChunk", "id", "must be an integer", -2) return nil end
  local count=0
  FXStateChunk=FXStateChunk:match("(BYPASS.*)")
  for w in string.gmatch(FXStateChunk, ".-WAK %d\n") do
    count=count+1
    if count==id then return w end
  end
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-message
                    -  examples:
                    -          0,   OSC is used
                    -          176, MIDI Chan 1 CC 0
                    -          ...
                    -          432, MIDI Chan 1 CC 1
                    -          ...
                    -          9360, MIDI Chan 1 Note 36
                    -          9616, MIDI Chan 1 Note 37
                    -          9872, MIDI Chan 1 Note 38
                    -            ...
                    -            
                    -      CC Mode-dropdownlist:
                    -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                    -          &65536 &131072 &262144 
                    -             0       0       0,      Absolute
                    -             1       0       0,      Relative 1(127=-1, 1=+1)
                    -             0       1       0,      Relative 2(63=-1, 65=+1)
                    -             1       1       0,      Relative 3(65=-1, 1=+1)
                    -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-message
                    -  examples:
                    -          0,   OSC is used
                    -          176, MIDI Chan 1 CC 0
                    -          ...
                    -          432, MIDI Chan 1 CC 1
                    -          ...
                    -          9360, MIDI Chan 1 Note 36
                    -          9616, MIDI Chan 1 Note 37
                    -          9872, MIDI Chan 1 Note 38
                    -            ...
                    -            
                    -      CC Mode-dropdownlist:
                    -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                    -          &65536 &131072 &262144 
                    -             0       0       0,      Absolute
                    -             1       0       0,      Relative 1(127=-1, 1=+1)
                    -             0       1       0,      Relative 2(63=-1, 65=+1)
                    -             1       1       0,      Relative 3(65=-1, 1=+1)
                    -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-messages
                    -  examples:
                    -          0,   OSC is used
                    -          176, MIDI Chan 1 CC 0
                    -          ...
                    -          432, MIDI Chan 1 CC 1
                    -          ...
                    -          9360, MIDI Chan 1 Note 36
                    -          9616, MIDI Chan 1 Note 37
                    -          9872, MIDI Chan 1 Note 38
                    -            ...
                    -            
                    -      CC Mode-dropdownlist:
                    -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                    -          &65536 &131072 &262144 
                    -             0       0       0,      Absolute
                    -             1       0       0,      Relative 1(127=-1, 1=+1)
                    -             0       1       0,      Relative 2(63=-1, 65=+1)
                    -             1       1       0,      Relative 3(65=-1, 1=+1)
                    -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Ultraschall=4.00
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, parameter, alias, mediatrack</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "MediaTrack", "Not a valid MediaTrack", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "fxid", "must be an integer", -3) return nil end
  local _temp, A=reaper.GetTrackStateChunk(MediaTrack, "", false)
  A=ultraschall.GetFXStateChunk(A, 1)
  if A==nil then ultraschall.AddErrorMessage("GetParmLearn_MediaTrack", "MediaTrack", "Has no FX-chain", -4) return nil end
  
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-message
                    -  examples:
                    -          0,   OSC is used
                    -          176, MIDI Chan 1 CC 0
                    -          ...
                    -          432, MIDI Chan 1 CC 1
                    -          ...
                    -          9360, MIDI Chan 1 Note 36
                    -          9616, MIDI Chan 1 Note 37
                    -          9872, MIDI Chan 1 Note 38
                    -            ...
                    -            
                    -      CC Mode-dropdownlist:
                    -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                    -          &65536 &131072 &262144 
                    -             0       0       0,      Absolute
                    -             1       0       0,      Relative 1(127=-1, 1=+1)
                    -             0       1       0,      Relative 2(63=-1, 65=+1)
                    -             1       1       0,      Relative 3(65=-1, 1=+1)
                    -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-message
                    -  examples:
                    -          0,   OSC is used
                    -          176, MIDI Chan 1 CC 0
                    -          ...
                    -          432, MIDI Chan 1 CC 1
                    -          ...
                    -          9360, MIDI Chan 1 Note 36
                    -          9616, MIDI Chan 1 Note 37
                    -          9872, MIDI Chan 1 Note 38
                    -            ...
                    -            
                    -      CC Mode-dropdownlist:
                    -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                    -          &65536 &131072 &262144 
                    -             0       0       0,      Absolute
                    -             1       0       0,      Relative 1(127=-1, 1=+1)
                    -             0       1       0,      Relative 2(63=-1, 65=+1)
                    -             1       1       0,      Relative 3(65=-1, 1=+1)
                    -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    integer midi_note - an integer representation of the MIDI-note, which is set as command; 0, in case of an OSC-messages
                           -  examples:
                           -          0,   OSC is used
                           -          176, MIDI Chan 1 CC 0
                           -          ...
                           -          432, MIDI Chan 1 CC 1
                           -          ...
                           -          9360, MIDI Chan 1 Note 36
                           -          9616, MIDI Chan 1 Note 37
                           -          9872, MIDI Chan 1 Note 38
                           -            ...
                           -            
                           -      CC Mode-dropdownlist:
                           -         set the following flags to their specific values (0=0, 1=the value beginning &, like &65536 or &131072 or &262144)
                           -          &65536 &131072 &262144 
                           -             0       0       0,      Absolute
                           -             1       0       0,      Relative 1(127=-1, 1=+1)
                           -             0       1       0,      Relative 2(63=-1, 65=+1)
                           -             1       1       0,      Relative 3(65=-1, 1=+1)
                           -             0       0       1,      Toggle (>0=toggle)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmAudioControl_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parmidx, string parmname, integer parameter_modulation, number parmbase, integer audioctrl, number audioctrlstrength, integer audioctrl_direction, integer channels, integer stereo, integer rms_attack, integer rms_release, number db_lo, number db_hi, number audioctrlshaping_x, number audioctrlshaping_y = ultraschall.GetParmAudioControl_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the parameter-modulation-settings of the Audio control signal-settings from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is entries from the <PROGRAMENV-chunk
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parmidx - the id of the parameter, that shall be modulated; order like in the dropdownlist
    string parmname - the name of the parameter, usually bypass or wet
    integer parameter_modulation - the "Enable parameter modulation, baseline value(envelope overrides)"-checkbox; 0, enabled; 1, disabled
    number parmbase - parameter-modulation-baseline-slider; between 0.0000 and 1.0000; default is 0.2500
    integer audioctrl - "Audio control signal (sidechain)"-checkbox - 0, disabled; 1, enabled
    number audioctrlstrength - the strength-slider for AudioControlSignal; 0.0000(0%) to 1.000(100%); 0.493(49.3%); default is 1
    integer audioctrl_direction - the direction-radiobuttons for AudioControlSignal; -1, Negative; 0, Centered; 1, Positive
    integer channels - the Track audio channel-dropdownlist; linked to entry parameter stereo as well
                     - -1, no channel selected(yet) (default)
                     - 0 and higher, track 1 and higher is selected
    integer stereo - linked to channels as well
                   - 0, mono(use only the channel set in CHAN); 1, stereo(use the channel set in CHAN and CHAN+1)
    integer rms_attack - rms attack in milliseconds; 0 to 1000; default is 300
    integer rms_release - rms release in milliseconds; 0 to 1000; default is 300
    number db_lo - db_lo decides the lowest value possible for parameter db_hi; db_hi decides the highest volume for db_lo
                 - Min volume-slider in dB; maximum valuerange possible is -60dB to 11.9dB
    number db_hi - db_lo decides the lowest value possible for parameter db_hi; db_hi decides the highest volume for db_lo
                 - Max volume-slider in dB; maximum valuerange possible is -59.9dB to 12dB
    number audioctrlshaping_x - the x-position of the shaping-dragging-point; between 0.000000 and 1.000000
    number audioctrlshaping_y - the y-position of the shaping-dragging-point; between 0.000000 and 1.000000
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmModulation-settings
    integer fxid - the fx, of which you want to get the parameter-modulation-settings
    integer id - the id of the ParmModulation-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, parameter, modulation, fxstatechunk, audio control signal</tags>
</US_DocBloc>
]]
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
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLFO_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parmidx, string parmname, integer parameter_modulation, number parmbase, integer lfo, number lfo_strength, integer lfo_direction, integer lfo_shape, integer temposync, integer unknown, integer phase_reset, number lfo_speed, number lfo_speedphase = ultraschall.GetParmLFO_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the parameter-modulation-settings of the LFO-settings from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is entries from the <PROGRAMENV-chunk
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parmidx - the id of the parameter, that shall be modulated; order like in the dropdownlist
    string parmname - the name of the parameter, usually bypass or wet
    integer parameter_modulation - the "Enable parameter modulation, baseline value(envelope overrides)"-checkbox; 0, enabled; 1, disabled
    number parmbase - parameter-modulation-baseline-slider; between 0.0000 and 1.0000; default is 0.2500
    integer lfo - LFO checkbox; 0, disabled; 1, enabled
    number lfo_strength - Strength-slider in the LFO parameter-modulation; 0.0000(0%) to 1.000(100%); 0.493(49.3%); default is 1
    integer lfo_direction - Direction-radiobuttons in the LFO parameter modulation; -1, Negative; 0, Centered; 1, Positive
    integer lfo_shape - the shape of the LFO
                    - 0, sine
                    - 1, square
                    - 2, saw L
                    - 3, saw R
                    - 4, triangle
                    - 5, random
    integer temposync - the Tempo sync-checkbox in the LFO parameter-modulation; 0, disabled; 1, enabled
    integer unknown - unknown
    integer phase_reset - phase-reset-dropdownlist
                        - 0, On seek/loop (deterministic output)
                        - 1, Free-running (non-deterministic output)
    number lfo_speed - Speed-slider in the LFO parameter-modulation; either Hz(temposync=0) or QN(temposync=1) 
                     - Hz: 0(0.0039Hz) to 1(8.0000Hz); higher values are possible, lower values go into negative; default is 0.124573(1.0000Hz)
                     - QN: 0(8.0000QN) to 1(0.2500QN); lower values are possible; higher values go into negative; default is 0.9(1.0000QN)
    number lfo_speedphase - Phase-slider in the LFO parameter-modulation; 0.000 to to 1.000; default is 0.5
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmModulation-settings
    integer fxid - the fx, of which you want to get the parameter-modulation-settings
    integer id - the id of the ParmModulation-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, parameter, modulation, fxstatechunk, lfo</tags>
</US_DocBloc>
]]
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
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmMIDIPLink_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parmidx, string parmname, integer parameter_modulation, number parmbase, boolean plink_enabled, number scale, integer midi_fx_idx, integer midi_fx_idx2, integer linked_parmidx, number offset, optional integer bus, optional integer channel, optional integer category, optional integer midi_note = ultraschall.GetParmMIDIPLink_FXStateChunk(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the parameter-modulation-settings of the Parameter-Link-Modulation-settings from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is entries from the <PROGRAMENV-chunk
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parmidx - the id of the parameter, that shall be modulated; order like in the dropdownlist
    string parmname - the name of the parameter, usually bypass or wet
    integer parameter_modulation - the "Enable parameter modulation, baseline value(envelope overrides)"-checkbox; 0, enabled; 1, disabled
    number parmbase - parameter-modulation-baseline-slider; between 0.0000 and 1.0000; default is 0.2500
    boolean plink_enabled - true, parameter-linking is enabled; false, parameter linking is disabled
    number scale - the scale-slider; -1.00(-100%) to 1.00(100%); default is 0(0%)
    integer midi_fx_idx - the big MIDI/FX-button in the "Link from MIDI or FX parameter"-area
                        -  -1, nothing selected
                        -  -100, MIDI-parameter-settings
                        -  0 - the first fx
                        -  1 - the second fx
                        -  2 - the third fx, etc
    integer midi_fx_idx2 - the big MIDI/FX-button in the "Link from MIDI or FX parameter"-area; Reaper stores the idx for idx using two values, where this is the second one
                         - it is unknown why, so I include it in here anyway
                         -  -1, nothing selected
                         -  -100, MIDI-parameter-settings
                         -  0 - the first fx
                         -  1 - the second fx
                         -  2 - the third fx, etc
    integer linked_parmidx - the parameter idx, that you want to link; 
                    - When MIDI:
                    -     16
                    - When FX-parameter:
                    -     0 to n; 0 for the first; 1, for the second, etc
    number offset - Offset-slider; -1.00(-100%) to 1.00(100%); default is 0(0%) 
    optional integer bus - the MIDI-bus; 0 to 15 for bus 1 to 16; only available, when midi_fx_idx=-100, otherwise nil
    optional integer channel - the MIDI-channel; 0, omni; 1 to 16 for channel 1 to 16; only available, when midi_fx_idx=-100, otherwise nil
    optional integer category - the MIDI-category, which affects the meaning of parameter midi_note; only available, when midi_fx_idx=-100, otherwise nil
                              - 144, MIDI note
                              - 160, Aftertouch
                              - 176, CC 14Bit and CC
                              - 192, Program Change
                              - 208, Channel Pressure
                              - 224, Pitch
    optional integer midi_note - the midi_note/command, whose meaning depends on parameter category; only available, when midi_fx_idx=-100, otherwise nil
                               -   When MIDI note:
                               -        0(C-2) to 127(G8)
                               -   When Aftertouch:
                               -        0(C-2) to 127(G8)
                               -   When CC14 Bit:
                               -        128 to 159; see dropdownlist for the commands(the order of the list is the same as this numbering)
                               -   When CC:
                               -        0 to 119; see dropdownlist for the commands(the order of the list is the same as this numbering)
                               -   When Program Change:
                               -        0
                               -   When Channel Pressure:
                               -        0
                               -   When Pitch:
                               -        0
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the ParmLinkModulation-settings
    integer fxid - the fx, of which you want to get the parameter-linking-modulation-settings
    integer id - the id of the ParmLinkModulation-settings you want to have, starting with 1 for the first
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, parameter, linking, linked, midi, fx, modulation, fxstatechunk, lfo</tags>
</US_DocBloc>
]]
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, parm, learn, delete, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "id", "must be an integer", -3) return false end
    
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
      if count==id then UseFX2=string.gsub(UseFX, k, "") break end
    end
  end
  
  if UseFX2~=nil then
    start,stop=string.find(FXStateChunk, UseFX, 0, true)
    return true, FXStateChunk:sub(1, start)..UseFX2:sub(2,-2)..FXStateChunk:sub(stop, -1)
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmAlias_FXStateChunk(string FXStateChunk, integer fxid, integer id, string parmalias)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    It's the PARMALIAS-entry
    
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
    string parmalias - the new aliasname of the parameter
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, set, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "id", "must be an integer", -3) return false end    

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "parmalias", "must be a string", -4) return false end
    
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

function ultraschall.SetFXStateChunk(StateChunk, FXStateChunk, TakeFXChain_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredStateChunk = ultraschall.SetFXStateChunk(string StateChunk, string FXStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an FXStateChunk into a TrackStateChunk or a MediaItemStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful
    optional string alteredStateChunk - the altered StateChunk
  </retvals>
  <parameters>
    string StateChunk - the TrackStateChunk, into which you want to set the FXChain
    string FXStateChunk - the FXStateChunk, which you want to set into the TrackStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, set, trackstatechunk, mediaitemstatechunk, fxstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("SetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -1) return false end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("SetFXStateChunk", "TakeFXChain_id", "must be an integer", -3) return false end
  if TakeFXChain_id==nil then TakeFXChain_id=1 end
  local OldFXStateChunk=ultraschall.GetFXStateChunk(StateChunk, TakeFXChain_id)
  OldFXStateChunk=string.gsub(OldFXStateChunk, "\n%s*", "\n")  
  OldFXStateChunk=string.gsub(OldFXStateChunk, "^%s*", "")
  
  local Start, Stop = string.find(StateChunk, OldFXStateChunk, 0, true)
  StateChunk=StateChunk:sub(1,Start-1)..FXStateChunk:sub(2,-1)..StateChunk:sub(Stop+1,-1)
  StateChunk=string.gsub(StateChunk, "\n%s*", "\n")
  --print3(StateChunk)
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
  <functioncall>string FXStateChunk = ultraschall.GetFXStateChunk(string StateChunk, optional integer TakeFXChain_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns an FXStateChunk from a TrackStateChunk or a MediaItemStateChunk.
    
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns nil in case of an error or if no FXStateChunk has been found.
  </description>
  <retvals>
    string FXStateChunk - the FXStateChunk, stored in the StateChunk
  </retvals>
  <parameters>
    string StateChunk - the StateChunk, from which you want to retrieve the FXStateChunk
    optional integer TakeFXChain_id - when using MediaItemStateChunks, this allows you to choose the take of which you want the FXChain; default is 1
  </parameters>
  <chapter_context>
    FX-Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fxmanagement, get, fxstatechunk, trackstatechunk, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidTrackStateChunk(StateChunk)==false and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("GetFXStateChunk", "StateChunk", "no valid Track/ItemStateChunk", -1) return end
  if TakeFXChain_id~=nil and math.type(TakeFXChain_id)~="integer" then ultraschall.AddErrorMessage("GetFXStateChunk", "TakeFXChain_id", "must be an integer", -2) return end
  if TakeFXChain_id==nil then TakeFXChain=1 end
  
  if string.find(StateChunk, "\n  ")==nil then
    StateChunk=ultraschall.StateChunkLayouter(StateChunk)
  end
  for w in string.gmatch(StateChunk, " <FXCHAIN.-\n  >") do
    return w
  end
  local count=0
  for w in string.gmatch(StateChunk, " <TAKEFX.-\n  >") do
    count=count+1
    if TakeFXChain_id==count then
      return w
    end
  end
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
    optional string osc_message - the osc-message, that triggers the ParmLFOLearn, only when midi_note is set to 0!
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    string parmname - the name of the parameter, usually \"\" or \"byp\" for bypass or \"wet\" for wet; when using wet or bypass, these are essential to give!
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.AddParmAlias_FXStateChunk(string FXStateChunk, integer fxid, string parmalias)</functioncall>
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
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Learn-entry; beginning with 1
    integer parmidx - the parameter, whose alias you want to add
    string parmalias - the new aliasname of the parameter
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, set, parm, aliasname</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "id", "must be an integer", -3) return false end    

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmalias", "must be a string", -4) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmidx", "must be an integer", -5) return false end
  
  local count=0
  local FX, UseFX2, start, stop, UseFX
  for k in string.gmatch(FXStateChunk, "    BYPASS.-WAK.-\n") do
    count=count+1
    if count==fxid then UseFX=k end
  end
  
  if UseFX:match("PARMALIAS "..parmidx)~=nil then ultraschall.AddErrorMessage("AddParmAlias_FXStateChunk", "parmidx", "there's already an alias for this parmidx", -6) return false end
  local UseFX_start, UseFX_end=UseFX:match("(.-)(FXID.*)")
  UseFX2=UseFX_start.."PARMALIAS "..parmidx.." "..parmalias.."\n    "..UseFX_end
  
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
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
    Ultraschall=4.00
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
    integer count - the number of ParmLearn-entried found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to count a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-count-Parm-Learn-entry; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx management, count, parm, learn</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountParmLearn_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return -1 end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("CountParmLearn_FXStateChunk", "fxid", "must be an integer", -2) return -1 end
    
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
    integer count - the number of LFOLearn-entried found
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to count a Parm-LFOLearn-entry
    integer fxid - the id of the fx, which holds the to-count-Parm-LFOLearn-entry; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
