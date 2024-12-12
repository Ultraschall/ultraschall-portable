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

function ultraschall.IsValidFXStateChunk(StateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidFXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidFXStateChunk(string StateChunk)</functioncall>
  <description>
    Returns, if a StateChunk is a valid FXStateChunk.
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem or inputFX.
    
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
      Ultraschall=4.75
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string fx_lines, integer startoffset, integer endoffset = ultraschall.GetFXFromFXStateChunk(string FXStateChunk, integer fxindex)</functioncall>
    <description>
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
  local end_offset=-1
  for i=FXStateChunk:len(), 1, -1 do
    if FXStateChunk:sub(i,i)==">" then
      end_offset=i-1
      break
    end
  end
  --print2(end_offset, FXStateChunk)
  --print2(FXStateChunk:sub(0, end_offset))--:match("(BYPASS.-%s)()(BYPASS)"))
  --print2(FXStateChunk:sub(2529, -1))--:match("(BYPASS.-%s)()(BYPASS)"))
  
  local Found=""
  local oldcount=0
  local index_count=0
  local count
  --if lol==nil then return end
  while Found~=nil do    
    Found, count=(FXStateChunk:sub(oldcount, end_offset).."  BYPASS"):match("(%s%sBYPASS.-)() %s%sBYPASS")
    --print2(oldcount, FXStateChunk:len(), Found)
    if Found==nil then return end
    index_count=index_count+1
    if index_count==fxindex then return Found, oldcount, oldcount+count end
    oldcount=oldcount+count
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

function ultraschall.GetParmLearn_FXStateChunk(FXStateChunk, fxid, parmlearn_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer midi_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer parmlearn_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a parameter-learn-setting from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    It is the PARMLEARN-entry
    
    See [GetParmLearnID\_by\_FXParam\_FXStateChunk](#GetParmLearnID_by_FXParam_FXStateChunk) to get the parmlearn_id by fx-parameter-index instead of parm_id.
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only "wet" or "byp" or ""
                    - to get the actual displayed parametername, you need to 
                    - use the reaper.TrackFX_GetParamName-function
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
    integer parmlearn_id - the id of the ParmLearn-settings you want to have, starting with 1 for the first
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
  if math.type(parmlearn_id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk", "parmlearn_id", "must be an integer", -2) return nil end
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
    if count==parmlearn_id then 
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
  <description>
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
  <description>
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
    
    See [GetParmAliasID\_by\_FXParam\_FXStateChunk](#GetParmAliasID_by_FXParam_FXStateChunk) to get the parameter id by fx-parameter-index instead.
    
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
  <description>
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
  <description>
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
    
    See [GetParmLFOLearnID\_by\_FXParam\_FXStateChunk](#GetParmLFOLearnID_by_FXParam_FXStateChunk) to get the parameter id by fx-parameter-index instead.
    
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
  <description>
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
  <description>
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


function ultraschall.DeleteParmLearn_FXStateChunk(FXStateChunk, fxid, parmlearn_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer parmlearn_id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a ParmLearn-entry from an FXStateChunk.
  
    Unlike [DeleteParmLearn2\_FXStateChunk](#DeleteParmLearn2_FXStateChunk), this indexes by the already existing parmlearns and not by parameters.
    
    See [GetParmLearnID\_by\_FXParam\_FXStateChunk](#GetParmLearnID_by_FXParam_FXStateChunk) to get the parmlearn_id by fx-parameter-index instead of parm_id.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmLearn from
    integer fxid - the id of the fx, which holds the to-delete-ParmLearn-entry; beginning with 1
    integer parmlearn_id - the id of the ParmLearn-entry to delete; beginning with 1
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
  if math.type(parmlearn_id)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn_FXStateChunk", "parmlearn_id", "must be an integer", -3) return false end
    
  local count=0
  local FX, UseFX2, start, stop  
  local UseFX, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)

  if UseFX~=nil then
    for k in string.gmatch(UseFX, "    PARMLEARN.-\n") do
      count=count+1
      if count==parmlearn_id then UseFX2=string.gsub(UseFX, k, "") break end
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
    
    See [GetParmAliasID\_by\_FXParam\_FXStateChunk](#GetParmAliasID_by_FXParam_FXStateChunk) to get the parameter id by fx-parameter-index instead.
    
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
    
    See [GetParmLFOLearnID\_by\_FXParam\_FXStateChunk](#GetParmLFOLearnID_by_FXParam_FXStateChunk) to get the parameter id by fx-parameter-index instead.
    
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
    
    See [GetParmLFOLearnID\_by\_FXParam\_FXStateChunk](#GetParmLFOLearnID_by_FXParam_FXStateChunk) to get the parameter id by fx-parameter-index instead.
    
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

function ultraschall.SetParmLearn_FXStateChunk(FXStateChunk, fxid, parmlearn_id, midi_note, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmLearn_FXStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmLearn_FXStateChunk(string FXStateChunk, integer fxid, integer parmlearn_id, integer midi_note, integer checkboxflags, optional string osc_message)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    It's the PARMLEARN-entry
    
    See [GetParmLearnID\_by\_FXParam\_FXStateChunk](#GetParmLearnID_by_FXParam_FXStateChunk) to get the parmlearn_id by fx-parameter-index instead of parm_id.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting new values was successful; false, if setting was unsuccessful(e.g. no such ParmLearn)
    optional string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, in which you want to set a Parm-Learn-entry
    integer fxid - the id of the fx, which holds the to-set-Parm-Learn-entry; beginning with 1
    integer parmlearn_id - the id of the Parm-Learn-entry to set; beginning with 1
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
  if math.type(parmlearn_id)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "parmlearn_id", "must be an integer", -3) return false end    

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "osc_message", "must be either nil or a string", -4) return false end
  if math.type(midi_note)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "midi_note", "must be an integer", -5) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "checkboxflags", "must be an integer", -6) return false end
  
  if osc_message~=nil and midi_note~=0 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "midi_note", "must be set to 0, when using parameter osc_message", -7) return false end
  if osc_message==nil and input_mode==0 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "osc_message", "osc-message missing, when setting midi_note=0", -9) return false end
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
      if count==parmlearn_id then 
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
    ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk", "parmlearn_id", "no such parmlearn existing", -8)
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

  if type(parmalias)~="string" then ultraschall.AddErrorMessage("SetParmAlias_FXStateChunk", "parmalias", "must be a string", -4) return false end
  
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

function ultraschall.SetParmAlias2_FXStateChunk(FXStateChunk, fxid, id, parmalias)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmAlias2_FXStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmAlias2_FXStateChunk(string FXStateChunk, integer fxid, integer id, string parmalias)</functioncall>
  <description>
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    
    Unlike SetParmAlias_FXStateChunk, the parameter id counts by parameter-order, not existing aliasnames. If a parameter has no aliasname yet, it will return false.
    
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
    integer id - the index of the parameter, whose Parm-Alias-entry you want to to set; beginning with 1
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
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("SetParmAlias2_FXStateChunk", "id", "must be an integer", -3) return false end    

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
    UseFX2=string.gsub(UseFX, "\n%s-PARMALIAS "..(id-1).." .-\n", "\n    PARMALIAS "..(id-1).." "..parmalias.."\n")
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
    Ultraschall=4.8
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredStateChunk = ultraschall.SetFXStateChunk(string StateChunk, string FXStateChunk, optional integer TakeFXChain_id)</functioncall>
  <description>
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
  --print2(Start, Stop)
  if Start==1 then
    Start=StateChunk:match("MAINSEND.-\n()")
    --print2(Start)
    StateChunk=StateChunk:sub(1,Start-1)..""..FXStateChunk.."\n"..StateChunk:sub(Start,-1)
  else
    StateChunk=StateChunk:sub(1,Start-1)..FXStateChunk:match("%s-(.*)")..StateChunk:sub(Stop+1,-1)
    StateChunk=string.gsub(StateChunk, "\n%s*", "\n")
  end
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
  <description>
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
  <description>
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
  <description>
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
    integer parmidx - the parameter, whose Parameter Learn you want to add
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
<removed US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
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
<removed /US_DocBloc>
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
  <description>
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
    Ultraschall=4.2
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
  
  if ultraschall.type(fx_lines)~="string" then ultraschall.AddErrorMessage("GetFXSettingsString_FXLines", "fx_lines" , "must be a string", -1) return nil end
  if fx_lines:match("    <VST")~=nil then
    FXSettings=fx_lines:match("<VST.-\n(.-)    >")
  elseif fx_lines:match("    <JS_SER")~=nil then
    FXSettings=fx_lines:match("<JS_SER.-\n(.-)    >")
  elseif fx_lines:match("    <DX")~=nil then
    FXSettings=fx_lines:match("<DX.-\n(.-)    >")
  elseif fx_lines:match("    <AU")~=nil then
    FXSettings=fx_lines:match("<AU.-\n(.-)    >")
  elseif fx_lines:match("    <VIDEO_EFFECT")~=nil then
    return "", string.gsub(fx_lines:match("<VIDEO_EFFECT.-      <CODE\n(.-)      >"), "%s-|", "\n")  
  end
  
  if FXSettings==nil then ultraschall.AddErrorMessage("GetFXSettingsString_FXLines", "fx_lines" , "fx has no base64-encoded fx-lines", -2) return nil end
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default"> 
    Returns a table with all values of a specific Parameter-Modulation from an FXStateChunk.
  
    The table's format is as follows: 
    
        ParmModTable["PARAM_NR"]                - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
        ParmModTable["PARAM_TYPE"]              - the type of the parameter, usually "", "wet" or "bypass"

        ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                  true, checked; false, unchecked
        ParmModTable["PARAMOD_BASELINE"]        - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                    0.000 to 1.000

        ParmModTable["AUDIOCONTROL"]            - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                    Note: if true, this needs all AUDIOCONTROL_-entries to be set
        ParmModTable["AUDIOCONTROL_CHAN"]       - the Track audio channel-dropdownlist; When stereo, the first stereo-channel;
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_STEREO"]     - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                    AUDIOCONTROL_CHAN+1; nil, if not available
        ParmModTable["AUDIOCONTROL_ATTACK"]     - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
        ParmModTable["AUDIOCONTROL_RELEASE"]    - the Release-slider; 0-1000ms; nil, if not available
        ParmModTable["AUDIOCONTROL_MINVOLUME"]  - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_MAXVOLUME"]  - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_STRENGTH"]   - the Strength-slider; 0(0%) to 1000(100%)
        ParmModTable["AUDIOCONTROL_DIRECTION"]  - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
        ParmModTable["X2"]=0.5                  - the audiocontrol signal shaping-x-coordinate
        ParmModTable["Y2"]=0.5                  - the audiocontrol signal shaping-y-coordinate    
        
        ParmModTable["LFO"]                     - if the LFO-checkbox checked; true, checked; false, unchecked
                                                    Note: if true, this needs all LFO_-entries to be set
        ParmModTable["LFO_SHAPE"]               - the LFO Shape-dropdownlist; 
                                                    0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                    nil, if not available
        ParmModTable["LFO_SHAPEOLD"]            - use the old-style of the LFO_SHAPE; 
                                                    0, use current style of LFO_SHAPE; 
                                                    1, use old style of LFO_SHAPE; 
                                                    nil, if not available
        ParmModTable["LFO_TEMPOSYNC"]           - the Tempo sync-checkbox; true, checked; false, unchecked
        ParmModTable["LFO_SPEED"]               - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
        ParmModTable["LFO_STRENGTH"]            - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
        ParmModTable["LFO_PHASE"]               - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
        ParmModTable["LFO_DIRECTION"]           - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
        ParmModTable["LFO_PHASERESET"]          - the LFO Phase reset-dropdownlist; 
                                                    0, On seek/loop(deterministic output)
                                                    1, Free-running(non-deterministic output)
                                                    nil, if not available
        
        ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                    Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
        ParmModTable["PARMLINK"]                - the Link from MIDI or FX parameter-checkbox
                                                  true, checked; false, unchecked
        ParmModTable["PARMLINK_LINKEDPLUGIN"]   - the selected plugin; nil, if not available
                                                - will be ignored, when PARMLINK_LINKEDPLUGIN_RELATIVE is set
                                                    -1, nothing selected yet
                                                    -100, MIDI-parameter-settings
                                                    1 - the first fx-plugin
                                                    2 - the second fx-plugin
                                                    3 - the third fx-plugin, etc
        ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"] - the linked plugin relative to the current one in the FXChain
                                                       - 0, use parameter of the current fx-plugin
                                                       - negative, use parameter of a plugin above of the current plugin(-1, the one above; -2, two above, etc)
                                                       - positive, use parameter of a plugin below the current plugin(1, the one below; 2, two below, etc)
                                                       - nil, use only the plugin linked absolute(the one linked with PARMLINK_LINKEDPARMIDX)
        ParmModTable["PARMLINK_LINKEDPARMIDX"]  - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                    When MIDI, this is irrelevant.
                                                    When FX-parameter:
                                                      0 to n; 0 for the first; 1, for the second, etc

        ParmModTable["PARMLINK_OFFSET"]         - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
        ParmModTable["PARMLINK_SCALE"]          - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

        ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                    Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
        ParmModTable["MIDIPLINK_BUS"]           - the MIDI-bus selected in the button-menu; 
                                                    0 to 15 for bus 1 to 16; 
                                                    nil, if not available
        ParmModTable["MIDIPLINK_CHANNEL"]       - the MIDI-channel selected in the button-menu; 
                                                    0, omni; 1 to 16 for channel 1 to 16; 
                                                    nil, if not available
        ParmModTable["MIDIPLINK_MIDICATEGORY"]  - the MIDI_Category selected in the button-menu; nil, if not available
                                                    144, MIDI note
                                                    160, Aftertouch
                                                    176, CC 14Bit and CC
                                                    192, Program Change
                                                    208, Channel Pressure
                                                    224, Pitch
        ParmModTable["MIDIPLINK_MIDINOTE"]      - the MIDI-note selected in the button-menu; nil, if not available
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
        ParmModTable["WINDOW_ALTERED"]          - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                    Note: if true, this needs all WINDOW_-entries to be set
        ParmModTable["WINDOW_ALTEREDOPEN"]      - if the position of the ParmMod-window is altered and currently open; 
                                                    nil, unchanged; 0, unopened; 1, open
        ParmModTable["WINDOW_XPOS"]             - the x-position of the altered ParmMod-window in pixels; nil, default position
        ParmModTable["WINDOW_YPOS"]             - the y-position of the altered ParmMod-window in pixels; nil, default position
        ParmModTable["WINDOW_RIGHT"]            - the right-position of the altered ParmMod-window in pixels; 
                                                    nil, default position; only readable
        ParmModTable["WINDOW_BOTTOM"]           - the bottom-position of the altered ParmMod-window in pixels; 
                                                    nil, default position; only readable
    
    
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
      ParmModTable["PARMLINK_LINKEDPLUGIN"], ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]=ParmModTable["PARMLINK_LINKEDPLUGIN"]:match("(.-):(.*)")
      ParmModTable["PARMLINK_LINKEDPLUGIN"]=tonumber(ParmModTable["PARMLINK_LINKEDPLUGIN"])
      if ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]~=nil then
        ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]=tonumber(ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"])
      end
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
    <description markup_type="markdown" markup_version="1.0.1" indent="default"> 
      returns a parameter-modulation-table with default settings set.
      You can alter these settings to your needs before committing it to an FXStateChunk.
      
      The checkboxes for "Audio control signal (sidechain)", "LFO", "Link from MIDI or FX parameter" are unchecked and the fx-parameter is set to 1(the first parameter of the plugin).
      To enable and change them, you need to alter the following entries accordingly, or applying the ParmModTable has no effect:
        
              ParmModTable["AUDIOCONTROL"] - the checkbox for "Audio control signal (sidechain)"
              ParmModTable["LFO"]      - the checkbox for "LFO"
              ParmModTable["PARMLINK"] - the checkbox for "Link from MIDI or FX parameter"
              ParmModTable["PARAM_NR"] - the index of the fx-parameter for which the parameter-modulation-table is intended
       
      The table's format and its default-values is as follows:
      
                ParmModTable["PARAM_NR"]                - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
                ParmModTable["PARAM_TYPE"]              - the type of the parameter, usually "", "wet" or "bypass"

                ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                        - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                          true, checked; false, unchecked
                ParmModTable["PARAMOD_BASELINE"]        - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                            0.000 to 1.000

                ParmModTable["AUDIOCONTROL"]            - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all AUDIOCONTROL_-entries to be set
                ParmModTable["AUDIOCONTROL_CHAN"]       - the Track audio channel-dropdownlist; When stereo, the first stereo-channel;
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STEREO"]     - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                            AUDIOCONTROL_CHAN+1; nil, if not available
                ParmModTable["AUDIOCONTROL_ATTACK"]     - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
                ParmModTable["AUDIOCONTROL_RELEASE"]    - the Release-slider; 0-1000ms; nil, if not available
                ParmModTable["AUDIOCONTROL_MINVOLUME"]  - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_MAXVOLUME"]  - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                          nil, if not available
                ParmModTable["AUDIOCONTROL_STRENGTH"]   - the Strength-slider; 0(0%) to 1000(100%)
                ParmModTable["AUDIOCONTROL_DIRECTION"]  - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
                ParmModTable["X2"]=0.5                  - the audiocontrol signal shaping-x-coordinate
                ParmModTable["Y2"]=0.5                  - the audiocontrol signal shaping-y-coordinate    
                
                ParmModTable["LFO"]                     - if the LFO-checkbox checked; true, checked; false, unchecked
                                                            Note: if true, this needs all LFO_-entries to be set
                ParmModTable["LFO_SHAPE"]               - the LFO Shape-dropdownlist; 
                                                            0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                            nil, if not available
                ParmModTable["LFO_SHAPEOLD"]            - use the old-style of the LFO_SHAPE; 
                                                            0, use current style of LFO_SHAPE; 
                                                            1, use old style of LFO_SHAPE; 
                                                            nil, if not available
                ParmModTable["LFO_TEMPOSYNC"]           - the Tempo sync-checkbox; true, checked; false, unchecked
                ParmModTable["LFO_SPEED"]               - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
                ParmModTable["LFO_STRENGTH"]            - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
                ParmModTable["LFO_PHASE"]               - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
                ParmModTable["LFO_DIRECTION"]           - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
                ParmModTable["LFO_PHASERESET"]          - the LFO Phase reset-dropdownlist; 
                                                            0, On seek/loop(deterministic output)
                                                            1, Free-running(non-deterministic output)
                                                            nil, if not available
                
                ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["PARMLINK"]                - the Link from MIDI or FX parameter-checkbox
                                                          true, checked; false, unchecked
                ParmModTable["PARMLINK_LINKEDPLUGIN"]   - the selected plugin; nil, if not available
                                                        - will be ignored, when PARMLINK_LINKEDPLUGIN_RELATIVE is set
                                                            -1, nothing selected yet
                                                            -100, MIDI-parameter-settings
                                                            1 - the first fx-plugin
                                                            2 - the second fx-plugin
                                                            3 - the third fx-plugin, etc
                ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"] - the linked plugin relative to the current one in the FXChain
                                                               - 0, use parameter of the current fx-plugin
                                                               - negative, use parameter of a plugin above of the current plugin(-1, the one above; -2, two above, etc)
                                                               - positive, use parameter of a plugin below the current plugin(1, the one below; 2, two below, etc)
                                                               - nil, use only the plugin linked absolute(the one linked with PARMLINK_LINKEDPARMIDX)
                ParmModTable["PARMLINK_LINKEDPARMIDX"]  - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                            When MIDI, this is irrelevant.
                                                            When FX-parameter:
                                                              0 to n; 0 for the first; 1, for the second, etc

                ParmModTable["PARMLINK_OFFSET"]         - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
                ParmModTable["PARMLINK_SCALE"]          - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

                ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                            Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
                ParmModTable["MIDIPLINK_BUS"]           - the MIDI-bus selected in the button-menu; 
                                                            0 to 15 for bus 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_CHANNEL"]       - the MIDI-channel selected in the button-menu; 
                                                            0, omni; 1 to 16 for channel 1 to 16; 
                                                            nil, if not available
                ParmModTable["MIDIPLINK_MIDICATEGORY"]  - the MIDI_Category selected in the button-menu; nil, if not available
                                                            144, MIDI note
                                                            160, Aftertouch
                                                            176, CC 14Bit and CC
                                                            192, Program Change
                                                            208, Channel Pressure
                                                            224, Pitch
                ParmModTable["MIDIPLINK_MIDINOTE"]      - the MIDI-note selected in the button-menu; nil, if not available
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
                ParmModTable["WINDOW_ALTERED"]          - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                            Note: if true, this needs all WINDOW_-entries to be set
                ParmModTable["WINDOW_ALTEREDOPEN"]      - if the position of the ParmMod-window is altered and currently open; 
                                                            nil, unchanged; 0, unopened; 1, open
                ParmModTable["WINDOW_XPOS"]             - the x-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_YPOS"]             - the y-position of the altered ParmMod-window in pixels; nil, default position
                ParmModTable["WINDOW_RIGHT"]            - the right-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
                ParmModTable["WINDOW_BOTTOM"]           - the bottom-position of the altered ParmMod-window in pixels; 
                                                            nil, default position; only readable
                                                            
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
  ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]=nil
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
    <description>
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
  --if ParmModTable["PARMLINK_LINKEDPLUGIN"]~=nil and ParmModTable["PARMLINK_LINKEDPLUGIN"]<1 then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_LINKEDPLUGIN must be bigger than 0", -50 ) return false end
  if ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]~=nil and math.type(ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"])~="integer" then ultraschall.AddErrorMessage("IsValidParmModTable", "ParmModulationTable", "Entry PARMLINK_LINKEDPLUGIN_RELATIVE must be either nil or an integer", -49 ) return false end
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default"> 
    Takes a ParmModTable and adds with its values a new Parameter Modulation of a specific fx within an FXStateChunk.
  
    The expected table's format is as follows:

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
                                               - will be ignored, when PARMLINK_LINKEDPLUGIN_RELATIVE is set
                                                    -1, nothing selected yet
                                                    -100, MIDI-parameter-settings
                                                    1 - the first fx-plugin
                                                    2 - the second fx-plugin
                                                    3 - the third fx-plugin, etc
        ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"] - the linked plugin relative to the current one in the FXChain
                                                       - 0, use parameter of the current fx-plugin
                                                       - negative, use parameter of a plugin above of the current plugin(-1, the one above; -2, two above, etc)
                                                       - positive, use parameter of a plugin below the current plugin(1, the one below; 2, two below, etc)
                                                       - nil, use only the plugin linked absolute(the one linked with PARMLINK_LINKEDPARMIDX)
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
    local PARMLINK_LINKEDPLUGIN_RELATIVE, PARMLINK_LINKEDPLUGIN
    if ParmModTable["PARMLINK"]==true then 
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]>=0 then
        if ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]==nil then
          PARMLINK_LINKEDPLUGIN_RELATIVE=""
          PARMLINK_LINKEDPLUGIN=ParmModTable["PARMLINK_LINKEDPLUGIN"]-1
        else
          PARMLINK_LINKEDPLUGIN_RELATIVE=":"..(ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"])
          PARMLINK_LINKEDPLUGIN=ParmModTable["PARMLINK_LINKEDPLUGIN"]-1
        end
        LinkedPlugin=PARMLINK_LINKEDPLUGIN..PARMLINK_LINKEDPLUGIN_RELATIVE
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
  if FX==nil then ultraschall.AddErrorMessage("AddParmMod_ParmModTable", "fxindex", "no such index", -7) return nil end
  
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
    
        ParmModTable["PARAM_NR"]                - the parameter that you want to modulate; 1 for the first, 2 for the second, etc
        ParmModTable["PARAM_TYPE"]              - the type of the parameter, usually "", "wet" or "bypass"

        ParmModTable["PARAMOD_ENABLE_PARAMETER_MODULATION"] 
                                                - Enable parameter modulation, baseline value(envelope overrides)-checkbox; 
                                                  true, checked; false, unchecked
        ParmModTable["PARAMOD_BASELINE"]        - Enable parameter modulation, baseline value(envelope overrides)-slider; 
                                                    0.000 to 1.000

        ParmModTable["AUDIOCONTROL"]            - is the Audio control signal(sidechain)-checkbox checked; true, checked; false, unchecked
                                                    Note: if true, this needs all AUDIOCONTROL_-entries to be set
        ParmModTable["AUDIOCONTROL_CHAN"]       - the Track audio channel-dropdownlist; When stereo, the first stereo-channel;
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_STEREO"]     - 0, just use mono-channels; 1, use the channel AUDIOCONTROL_CHAN plus 
                                                    AUDIOCONTROL_CHAN+1; nil, if not available
        ParmModTable["AUDIOCONTROL_ATTACK"]     - the Attack-slider of Audio Control Signal; 0-1000 ms; nil, if not available
        ParmModTable["AUDIOCONTROL_RELEASE"]    - the Release-slider; 0-1000ms; nil, if not available
        ParmModTable["AUDIOCONTROL_MINVOLUME"]  - the Min volume-slider; -60dB to 11.9dB; must be smaller than AUDIOCONTROL_MAXVOLUME; 
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_MAXVOLUME"]  - the Max volume-slider; -59.9dB to 12dB; must be bigger than AUDIOCONTROL_MINVOLUME; 
                                                  nil, if not available
        ParmModTable["AUDIOCONTROL_STRENGTH"]   - the Strength-slider; 0(0%) to 1000(100%)
        ParmModTable["AUDIOCONTROL_DIRECTION"]  - the direction-radiobuttons; -1, negative; 0, centered; 1, positive
        ParmModTable["X2"]=0.5                  - the audiocontrol signal shaping-x-coordinate
        ParmModTable["Y2"]=0.5                  - the audiocontrol signal shaping-y-coordinate    
        
        ParmModTable["LFO"]                     - if the LFO-checkbox checked; true, checked; false, unchecked
                                                    Note: if true, this needs all LFO_-entries to be set
        ParmModTable["LFO_SHAPE"]               - the LFO Shape-dropdownlist; 
                                                    0, sine; 1, square; 2, saw L; 3, saw R; 4, triangle; 5, random
                                                    nil, if not available
        ParmModTable["LFO_SHAPEOLD"]            - use the old-style of the LFO_SHAPE; 
                                                    0, use current style of LFO_SHAPE; 
                                                    1, use old style of LFO_SHAPE; 
                                                    nil, if not available
        ParmModTable["LFO_TEMPOSYNC"]           - the Tempo sync-checkbox; true, checked; false, unchecked
        ParmModTable["LFO_SPEED"]               - the LFO Speed-slider; 0(0.0039Hz) to 1(8.0000Hz); nil, if not available
        ParmModTable["LFO_STRENGTH"]            - the LFO Strength-slider; 0.000(0.0%) to 1.000(100.0%)
        ParmModTable["LFO_PHASE"]               - the LFO Phase-slider; 0.000 to 1.000; nil, if not available
        ParmModTable["LFO_DIRECTION"]           - the LFO Direction-radiobuttons; -1, Negative; 0, Centered; 1, Positive
        ParmModTable["LFO_PHASERESET"]          - the LFO Phase reset-dropdownlist; 
                                                    0, On seek/loop(deterministic output)
                                                    1, Free-running(non-deterministic output)
                                                    nil, if not available
        
        ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                    Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
        ParmModTable["PARMLINK"]                - the Link from MIDI or FX parameter-checkbox
                                                  true, checked; false, unchecked
        ParmModTable["PARMLINK_LINKEDPLUGIN"]   - the selected plugin; nil, if not available
                                                - will be ignored, when PARMLINK_LINKEDPLUGIN_RELATIVE is set
                                                    -1, nothing selected yet
                                                    -100, MIDI-parameter-settings
                                                    1 - the first fx-plugin
                                                    2 - the second fx-plugin
                                                    3 - the third fx-plugin, etc
        ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"] - the linked plugin relative to the current one in the FXChain
                                                       - 0, use parameter of the current fx-plugin
                                                       - negative, use parameter of a plugin above of the current plugin(-1, the one above; -2, two above, etc)
                                                       - positive, use parameter of a plugin below the current plugin(1, the one below; 2, two below, etc)
                                                       - nil, use only the plugin linked absolute(the one linked with PARMLINK_LINKEDPARMIDX)
        ParmModTable["PARMLINK_LINKEDPARMIDX"]  - the id of the linked parameter; -1, if none is linked yet; nil, if not available
                                                    When MIDI, this is irrelevant.
                                                    When FX-parameter:
                                                      0 to n; 0 for the first; 1, for the second, etc

        ParmModTable["PARMLINK_OFFSET"]         - the Offset-slider; -1.00(-100%) to 1.00(+100%); nil, if not available
        ParmModTable["PARMLINK_SCALE"]          - the Scale-slider; -1.00(-100%) to 1.00(+100%); nil, if not available

        ParmModTable["MIDIPLINK"]               - true, if any parameter-linking with MIDI-stuff; false, if not
                                                    Note: if true, this needs all MIDIPLINK_-entries and PARMLINK_LINKEDPLUGIN=-100 to be set
        ParmModTable["MIDIPLINK_BUS"]           - the MIDI-bus selected in the button-menu; 
                                                    0 to 15 for bus 1 to 16; 
                                                    nil, if not available
        ParmModTable["MIDIPLINK_CHANNEL"]       - the MIDI-channel selected in the button-menu; 
                                                    0, omni; 1 to 16 for channel 1 to 16; 
                                                    nil, if not available
        ParmModTable["MIDIPLINK_MIDICATEGORY"]  - the MIDI_Category selected in the button-menu; nil, if not available
                                                    144, MIDI note
                                                    160, Aftertouch
                                                    176, CC 14Bit and CC
                                                    192, Program Change
                                                    208, Channel Pressure
                                                    224, Pitch
        ParmModTable["MIDIPLINK_MIDINOTE"]      - the MIDI-note selected in the button-menu; nil, if not available
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
        ParmModTable["WINDOW_ALTERED"]          - false, if the windowposition hasn't been altered yet; true, if the window has been altered
                                                    Note: if true, this needs all WINDOW_-entries to be set
        ParmModTable["WINDOW_ALTEREDOPEN"]      - if the position of the ParmMod-window is altered and currently open; 
                                                            nil, unchanged; 0, unopened; 1, open
        ParmModTable["WINDOW_XPOS"]             - the x-position of the altered ParmMod-window in pixels; nil, default position
        ParmModTable["WINDOW_YPOS"]             - the y-position of the altered ParmMod-window in pixels; nil, default position
        ParmModTable["WINDOW_RIGHT"]            - the right-position of the altered ParmMod-window in pixels; 
                                                    nil, default position; only readable
        ParmModTable["WINDOW_BOTTOM"]           - the bottom-position of the altered ParmMod-window in pixels; 
                                                    nil, default position; only readable
    
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
    local PARMLINK_LINKEDPLUGIN_RELATIVE, PARMLINK_LINKEDPLUGIN
    if ParmModTable["PARMLINK"]==true then 
      if ParmModTable["PARMLINK_LINKEDPLUGIN"]>=0 then
        if ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"]==nil then
          PARMLINK_LINKEDPLUGIN_RELATIVE=""
          PARMLINK_LINKEDPLUGIN=ParmModTable["PARMLINK_LINKEDPLUGIN"]-1
        else
          PARMLINK_LINKEDPLUGIN_RELATIVE=":"..(ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"])
          PARMLINK_LINKEDPLUGIN=ParmModTable["PARMLINK_LINKEDPLUGIN"]-1
        end
        LinkedPlugin=PARMLINK_LINKEDPLUGIN..PARMLINK_LINKEDPLUGIN_RELATIVE
      else
        LinkedPlugin=tostring(ParmModTable["PARMLINK_LINKEDPLUGIN"])
      end
      
      --print2(PARMLINK_LINKEDPLUGIN_RELATIVE, ParmModTable["PARMLINK_LINKEDPLUGIN_RELATIVE"])
      
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
  if FX==nil then ultraschall.AddErrorMessage("SetParmMod_ParmModTable", "fxindex", "no such index", -7) return nil end  
  
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
    <description>
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
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>integer number_of_parmmodulations = ultraschall.CountParmModFromFXStateChunk(string FXStateChunk, integer fxindex)</functioncall>
    <description>
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
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("CountParmModFromFXStateChunk", "fxindex", "must be an integer", -2) return -1 end
  
  local index=0

  local FX,StartOFS,EndOFS=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxindex)
  if FX==nil then ultraschall.AddErrorMessage("CountParmModFromFXStateChunk", "fxindex", "no such fx", -3) return -1 end
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
  <description>
    Returns all aliasnames of a specific fx within an FXStateChunk
    
    returns -1 in case of an error
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
  <description>
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
  <description>
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


function ultraschall.InputFX_AddByName(fxname, always_new_instance, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_AddByName</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.InputFX_AddByName(string fxname, boolean always_new_instance, optional integer tracknumber)</functioncall>
  <description>
    Adds an FX as monitoring FX.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the newly inserted fx or the index of the already existing fx; -1, in case of an error
  </retvals>
  <parameters>
    string fxname - the name of the fx to be inserted
    boolean always_new_instance - true, always add a new instance of the fx; false, only add if there's none yet
    optional integer tracknumber - the tracknumber, to whose inputFX the fx shall be added; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, add, inputfx, byname</tags>
</US_DocBloc>
]]
  if type(fxname)~="string" then ultraschall.AddErrorMessage("InputFX_AddByName", "fxname", "must be a string", -1) return -1 end
  if type(always_new_instance)~="boolean" then ultraschall.AddErrorMessage("InputFX_AddByName", "always_new_instance", "must be a boolean", -2) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_AddByName", "tracknumber", "no such track; must be an integer", -3) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end
  if always_new_instance==true then instantiate=-1 else instantiate=1 end
  
  local retval = reaper.TrackFX_AddByName(tracknumber, fxname, true, instantiate)+1
  if retval==0 then return -1 else return retval end
end


--A=ultraschall.InputFX_AddByName("ReaCast", false)

function ultraschall.InputFX_QueryFirstFXIndex(fxname, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_QueryFirstFXIndex</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer fxindex = ultraschall.InputFX_QueryFirstFXIndex(string fxname, optional integer tracknumber)</functioncall>
  <description>
    Queries the fx-index of the first inputfx with fxname
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer fxindex - the index of the queried fx; 1-based; -1, in case of an error
  </retvals>
  <parameters>
    string fxname - the name of the fx to be queried
    optional integer tracknumber - the tracknumber, to whose inputFX the fx shall be added; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, query, inputfx, byname</tags>
</US_DocBloc>
]]
  if type(fxname)~="string" then ultraschall.AddErrorMessage("InputFX_QueryFirstFXIndex", "fxname", "must be a string", -1) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_QueryFirstFXIndex", "tracknumber", "no such track; must be an integer", -3) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end

  local retval=reaper.TrackFX_AddByName(tracknumber, fxname, true, 0)+1
  if retval==0 then return -1 else return retval end
end

--A1=ultraschall.InputFX_QueryFirstFXIndex("ReaCast")

function ultraschall.InputFX_MoveFX(old_fxindex, new_fxindex, tracknumber_source, tracknumber_target)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_MoveFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_MoveFX(integer old_fxindex, integer new_fxindex, optional integer tracknumber_source, optional integer tracknumber_target)</functioncall>
  <description>
    Moves a monitoring-fx from an old to a new position
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, moving was successful; false, moving was unsuccessful
  </retvals>
  <parameters>
    integer old_fxindex - the index of the input-fx to be moved; 1-based
    integer new_fxindex - the new position of the input-fx; 1-based
    optional integer tracknumber_source - the tracknumber of the track, from whose inputFX you want to move the fx; 1-based; nil, master-track
    optional integer tracknumber_target - the tracknumber of the track, to which you want to move the inputFX; 1-based; nil, master-track    
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, move, inputfx</tags>
</US_DocBloc>
]]
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFX", "old_fxindex", "must be an integer", -1) return false end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFX", "new_fxindex", "must be an integer", -2) return false end
  
  if tracknumber_source~=nil and (math.type(tracknumber_source)~="integer" or (tracknumber_source<0 or tracknumber_source>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFX", "tracknumber_source", "no such track; must be an integer", -5) return false end
  if tracknumber_source==nil or tracknumber_source==0 then tracknumber_source=reaper.GetMasterTrack() else tracknumber_source=reaper.GetTrack(0,tracknumber_source-1) end
  if tracknumber_target~=nil and (math.type(tracknumber_target)~="integer" or (tracknumber_target<0 or tracknumber_target>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFX", "tracknumber_target", "no such track; must be an integer", -6) return false end
  if tracknumber_target==nil or tracknumber_target==0 then tracknumber_target=reaper.GetMasterTrack() else tracknumber_target=reaper.GetTrack(0,tracknumber_target-1) end
  if old_fxindex<1 or old_fxindex>ultraschall.InputFX_GetCount(tracknumber) then ultraschall.AddErrorMessage("InputFX_MoveFX", "old_fxindex", "no such inputFX", -3) return false end
  if new_fxindex<1 or new_fxindex>ultraschall.InputFX_GetCount(tracknumber) then ultraschall.AddErrorMessage("InputFX_MoveFX", "new_fxindex", "no such inputFX", -4) return false end
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1
  reaper.TrackFX_CopyToTrack(tracknumber_source, old_fxindex+0x1000000, tracknumber_target, new_fxindex+0x1000000, true)
  return true
end

--ultraschall.InputFX_MoveFX(2, 1)

function ultraschall.InputFX_CopyFX(old_fxindex, new_fxindex, tracknumber_source, tracknumber_target)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_CopyFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_CopyFX(integer old_fxindex, integer new_fxindex, optional integer tracknumber_source, optional integer tracknumber_target)</functioncall>
  <description>
    Copies a monitoring-fx and inserts it at a new position
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the inserted fx(in case of being different from new_fxindex); -1, in case of an error; 1-based
  </retvals>
  <parameters>
    integer old_fxindex - the index of the input-fx to be copied; 1-based
    integer new_fxindex - the position of the newly inserted input-fx; 1-based
    optional integer tracknumber_source - the tracknumber of the track, from whose inputFX you want to move the fx; 1-based; nil, master-track
    optional integer tracknumber_target - the tracknumber of the track, to which you want to move the inputFX; 1-based; nil, master-track    
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, copy, inputfx</tags>
</US_DocBloc>
]]
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFX", "old_fxindex", "must be an integer", -1) return false end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFX", "new_fxindex", "must be an integer", -2) return false end
  
  if tracknumber_source~=nil and (math.type(tracknumber_source)~="integer" or (tracknumber_source<0 or tracknumber_source>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFX", "tracknumber_source", "no such track; must be an integer", -5) return false end
  if tracknumber_source==nil or tracknumber_source==0 then tracknumber_source=reaper.GetMasterTrack() else tracknumber_source=reaper.GetTrack(0,tracknumber_source-1) end
  if tracknumber_target~=nil and (math.type(tracknumber_target)~="integer" or (tracknumber_target<0 or tracknumber_target>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFX", "tracknumber_target", "no such track; must be an integer", -6) return false end
  if tracknumber_target==nil or tracknumber_target==0 then tracknumber_target=reaper.GetMasterTrack() else tracknumber_target=reaper.GetTrack(0,tracknumber_target-1) end
  if old_fxindex<1 or old_fxindex>ultraschall.InputFX_GetCount(tracknumber) then ultraschall.AddErrorMessage("InputFX_CopyFX", "old_fxindex", "no such inputFX", -3) return false end
  if new_fxindex<1 then ultraschall.AddErrorMessage("InputFX_CopyFX", "new_fxindex", "no such inputFX", -4) return false end
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1
  reaper.TrackFX_CopyToTrack(tracknumber_source, old_fxindex+0x1000000, tracknumber_target, new_fxindex+0x1000000, false)
  return true
end

--A=ultraschall.InputFX_CopyFX(9, 1)

function ultraschall.InputFX_CopyFXFromTrackFX(track, old_fxindex, new_fxindex, tracknumberInputFX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_CopyFXFromTrackFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.InputFX_CopyFXFromTrackFX(MediaTrack track, integer old_fxindex, integer new_fxindex, optional integer tracknumberInputFX)</functioncall>
  <description>
    Copies a trackfx and inserts it as monitoring-fx at a certain position
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the inserted fx(in case of being different from new_fxindex); -1, in case of an error; 1-based
  </retvals>
  <parameters>
    MediaTrack track - the track from which you want to copy a trackfx
    integer old_fxindex - the index of the track-fx to be copied; 1-based
    integer new_fxindex - the position of the newly inserted input-fx; 1-based
    optional integer tracknumberInputFX - the tracknumber, to whose inputFX the fx shall be copied; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, copy, inputfx, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTrackFX", "track", "must be a mediatrack", -1) return -1 end
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTrackFX", "old_fxindex", "must be an integer", -2) return -1 end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTrackFX", "new_fxindex", "must be an integer", -3) return -1 end
  
  local trackfx
  if tracknumberInputFX~=nil and (math.type(tracknumberInputFX)~="integer" or (tracknumberInputFX<0 or tracknumberInputFX>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFXFromTrackFX", "tracknumberInputFX", "no such track; must be an integer", -4) return -1 end
  if tracknumberInputFX==nil or tracknumberInputFX==0 then trackfx=reaper.GetMasterTrack() else trackfx=reaper.GetTrack(0,tracknumberInputFX-1) end
  
  local newfx=new_fxindex
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1 
  reaper.TrackFX_CopyToTrack(track, old_fxindex, trackfx, new_fxindex+0x1000000, false)
  if new_fxindex>ultraschall.InputFX_GetCount(tracknumberInputFX)-1 then return ultraschall.InputFX_GetCount() else return newfx end
end

--A=ultraschall.InputFX_CopyFXFromTrackFX(reaper.GetMasterTrack(), 1, 10)

function ultraschall.InputFX_CopyFXToTrackFX(old_fxindex, track, new_fxindex, tracknumberInputFX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_CopyFXToTrackFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.InputFX_CopyFXToTrackFX(integer old_fxindex, MediaTrack track, integer new_fxindex, optional integer tracknumberInputFX)</functioncall>
  <description>
    Copies a monitoring-fx and inserts it as trackfx at a certain position
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the inserted fx(in case of being different from new_fxindex); -1, in case of an error
  </retvals>
  <parameters>
    integer old_fxindex - the index of the monitoring-fx to be copied; 1-based
    MediaTrack track - the track into which you want to insert the trackFX
    integer new_fxindex - the position of the newly inserted track-fx; 1-based
    optional integer tracknumberInputFX - the tracknumber, from whose inputFX the fx shall be copied from; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, copy, inputfx, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("InputFX_CopyFXToTrackFX", "track", "must be a mediatrack", -1) return -1 end
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXToTrackFX", "old_fxindex", "must be an integer", -2) return -1 end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXToTrackFX", "new_fxindex", "must be an integer", -3) return -1 end
  
  local trackfx
  if tracknumberInputFX~=nil and (math.type(tracknumberInputFX)~="integer" or (tracknumberInputFX<0 or tracknumberInputFX>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFXToTrackFX", "tracknumberInputFX", "no such track; must be an integer", -4) return -1 end
  if tracknumberInputFX==nil or tracknumberInputFX==0 then trackfx=reaper.GetMasterTrack() else trackfx=reaper.GetTrack(0,tracknumberInputFX-1) end
  
  local newfx=new_fxindex
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1   
  reaper.TrackFX_CopyToTrack(trackfx, old_fxindex+0x1000000, track, new_fxindex, false)  
  if new_fxindex>reaper.TrackFX_GetCount(track)-1 then return reaper.TrackFX_GetCount(track) else return newfx end
end

--A=ultraschall.InputFX_CopyFXToTrackFX(1, reaper.GetMasterTrack(), 1)

function ultraschall.InputFX_MoveFXFromTrackFX(track, old_fxindex, new_fxindex, tracknumberInputFX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_MoveFXFromTrackFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.InputFX_MoveFXFromTrackFX(MediaTrack track, integer old_fxindex, integer new_fxindex, optional integer tracknumberInputFX)</functioncall>
  <description>
    Moves a trackfx to monitoring-fx at a certain position
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the inserted fx(in case of being different from new_fxindex); -1, in case of an error
  </retvals>
  <parameters>
    MediaTrack track - the track from which you want to copy a trackfx to monitoring-fx
    integer old_fxindex - the index of the monitoring-fx to be moved; 1-based
    integer new_fxindex - the position of the newly inserted input-fx; 1-based
    optional integer tracknumberInputFX - the tracknumber, to whose inputFX the fx shall be moved to; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, move, inputfx, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTrackFX", "track", "must be a mediatrack", -1) return -1 end
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTrackFX", "old_fxindex", "must be an integer", -2) return -1 end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTrackFX", "new_fxindex", "must be an integer", -3) return -1 end
  
  local trackfx
  if tracknumberInputFX~=nil and (math.type(tracknumberInputFX)~="integer" or (tracknumberInputFX<0 or tracknumberInputFX>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFXFromTrackFX", "tracknumberInputFX", "no such track; must be an integer", -4) return -1 end
  if tracknumberInputFX==nil or tracknumberInputFX==0 then trackfx=reaper.GetMasterTrack() else trackfx=reaper.GetTrack(0,tracknumberInputFX-1) end
  
  local newfx=new_fxindex
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1 
  reaper.TrackFX_CopyToTrack(track, old_fxindex, trackfx, new_fxindex+0x1000000, true)
  if new_fxindex>ultraschall.InputFX_GetCount(tracknumberInputFX)-1 then return ultraschall.InputFX_GetCount() else return newfx end
end

--A=ultraschall.InputFX_CopyFXFromTrackFX(reaper.GetMasterTrack(), 1, 10)

function ultraschall.InputFX_MoveFXToTrackFX(old_fxindex, track, new_fxindex, tracknumberInputFX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_MoveFXToTrackFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.InputFX_MoveFXToTrackFX(integer old_fxindex, MediaTrack track, integer new_fxindex)</functioncall>
  <description>
    moves a monitoring-fx and inserts it as trackfx at a certain position
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the index of the inserted fx(in case of being different from new_fxindex); -1, in case of an error
  </retvals>
  <parameters>
    integer old_fxindex - the index of the monitoring-fx to be moved; 1-based
    MediaTrack track - the track into which you want to insert the trackFX
    integer new_fxindex - the position of the newly inserted track-fx; 1-based
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, move, inputfx, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("InputFX_MoveFXToTrackFX", "track", "must be a mediatrack", -1) return -1 end
  if math.type(old_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXToTrackFX", "old_fxindex", "must be an integer", -2) return -1 end
  if math.type(new_fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXToTrackFX", "new_fxindex", "must be an integer", -3) return -1 end
  
  --local trackfx
  if tracknumberInputFX~=nil and (math.type(tracknumberInputFX)~="integer" or (tracknumberInputFX<0 or tracknumberInputFX>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFXToTrackFX", "tracknumberInputFX", "no such track; must be an integer", -4) return -1 end
  if tracknumberInputFX==nil or tracknumberInputFX==0 then trackfx=reaper.GetMasterTrack() else trackfx=reaper.GetTrack(0,tracknumberInputFX-1) end
  
  local newfx=new_fxindex
  old_fxindex=old_fxindex-1
  new_fxindex=new_fxindex-1   
  reaper.TrackFX_CopyToTrack(trackfx, old_fxindex+0x1000000, track, new_fxindex, true)  
  if new_fxindex>reaper.TrackFX_GetCount(track)-1 then return reaper.TrackFX_GetCount(track) else return newfx end
end

--A=ultraschall.InputFX_MoveFXToTrackFX(1, reaper.GetMasterTrack(), 1)



--ultraschall.InputFX_MoveFXFromTakeFX(reaper.GetMediaItemTake(reaper.GetMediaItem(0,0),0), 1, 1)

function ultraschall.InputFX_Delete(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_Delete</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_Delete(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    removes a certain monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx to be deleted; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX shall be deleted; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, delete, inputfx</tags>
</US_DocBloc>
]]
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_Delete", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_Delete", "fxindex", "must 1 or higher", -2) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_Delete", "tracknumber", "no such track; must be an integer", -3) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end
  return reaper.TrackFX_Delete(tracknumber, 0x1000000+fxindex-1)
end


--ultraschall.InputFX_Delete(6)

function ultraschall.InputFX_EndParamEdit(fxindex, paramindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_EndParamEdit</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_EndParamEdit(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    This ends the capture of a parameter(e.g when finished writing automation)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, unknown; false, unknown
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx
    integer paramindex - the index of the parameter of the monitoring-fx
    optional integer tracknumber - the tracknumber, whose inputFX-parameter shall be ended in editing; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, end, param edit, parameters, inputfx</tags>
</US_DocBloc>
]]
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_EndParamEdit", "fxindex", "must be an integer", -2) return false end
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_EndParamEdit", "paramindex", "must be an integer", -3) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_EndParamEdit", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end
  return reaper.TrackFX_EndParamEdit(tracknumber, 0x1000000+fxindex-1, paramindex-1)
end

--A=ultraschall.InputFX_EndParamEdit(14, 1)



function ultraschall.InputFX_GetCount(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetCount</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer monitoring_fx_count = ultraschall.InputFX_GetCount(optional integer tracknumber)</functioncall>
  <description>
    counts the available monitoring-fx
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer monitoring_fx_count - the number of available monitoring-fx    
  </retvals>
  <parameters>
    optional integer tracknumber - the tracknumber, whose inputFX you want to count; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, count, inputfx</tags>
</US_DocBloc>
]]
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetCount", "tracknumber", "no such track; must be an integer or nil for global monitoring fx", -1) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end
  return reaper.TrackFX_GetRecCount(tracknumber)
end

--A=ultraschall.InputFX_GetCount()

function ultraschall.InputFX_GetChainVisible(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetChainVisible</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean inputfx_chain_visible, integer visible_inputfx = ultraschall.InputFX_GetChainVisible(optional integer tracknumber)</functioncall>
  <description>
    returns if the monitoring-fx-chain is visible and index of the currently visible monitoring-fx
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean inputfx_chain_visible - true, fxchain is visible; false, fxchain is not visible
    integer visible_inputfx - the index of the currently visible monitoring-fx; -1, if nothing is visible; 1-based    
  </retvals>
  <parameters>
    optional integer tracknumber - the tracknumber, whose inputFX-chain-visibility you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, is visible, inputfx</tags>
</US_DocBloc>
]]
  -- returns:
  -- is inputfx-chain opened?
  -- which fx is currently visible?
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetChainVisible", "tracknumber", "no such track; must be an integer", -1) return nil end
  if tracknumber==nil or tracknumber==0 then tracknumber=reaper.GetMasterTrack() else tracknumber=reaper.GetTrack(0,tracknumber-1) end
  
  local A,B=reaper.TrackFX_GetRecChainVisible(tracknumber)~=-1, reaper.TrackFX_GetRecChainVisible(reaper.GetMasterTrack(0))+1
  if B==0 then B=-1 end
  return A,B
end

--A, B=ultraschall.InputFX_GetChainVisible()


function ultraschall.InputFX_GetEnabled(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetEnabled</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean inputfx_enabled = ultraschall.InputFX_GetEnabled(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns if a certain monitoring-fx is enabled
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean inputfx_enabled - true, fx is enabled; false, fxchain is not enabled
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose enabled state you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-enabledness you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, is enabled, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEnabled", "fxindex", "must be an integer", -1) return nil end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetEnabled", "tracknumber", "no such track; must be an integer", -3) return nil end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or fxindex>ultraschall.InputFX_GetCount(tracknumber) then ultraschall.AddErrorMessage("InputFX_GetEnabled", "fxindex", "no such input fx", -2) return nil end

  return reaper.TrackFX_GetEnabled(tracknumber2, 0x1000000+fxindex-1)
end

--A=ultraschall.InputFX_GetEnabled(1)

function ultraschall.InputFX_GetFloatingWindow(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetFloatingWindow</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>HWND inputfx_floating_hwnd = ultraschall.InputFX_GetFloatingWindow(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the hwnd of a floating monitoring-fx-window
    
    returns nil in case of an error
  </description>
  <retvals>
    HWND inputfx_floating_hwnd - the hwnd of the floating montitoring fx; nil, if not available
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose floating-monitoring-fx-hwnd you want to get; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-floating-window-hwnd you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, hwnd, floating, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFloatingWindow", "fxindex", "must be an integer", -1) return nil end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetFloatingWindow", "tracknumber", "no such track; must be an integer", -3) return nil end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetFloatingWindow", "fxindex", "no such fx", -2) return nil end
  
  return reaper.TrackFX_GetFloatingWindow(tracknumber2, 0x1000000+fxindex-1)
end

--A,B,C,D,E=ultraschall.InputFX_GetFloatingWindow(1)

--A=reaper.TrackFX_GetFloatingWindow(reaper.GetMasterTrack(0), 0)


function ultraschall.InputFX_GetFXGUID(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetFXGUID</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>string fxguid = ultraschall.InputFX_GetFXGUID(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the guid of a monitoring-fx
    
    returns nil in case of an error
  </description>
  <retvals>
    string fxguid - the guid of the monitoring-fx
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose guid you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-fx-guid you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, guid, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFXGUID", "fxindex", "must be an integer", -1) return nil end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetFXGUID", "tracknumber", "no such track; must be an integer", -3) return end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetFXGUID", "fxindex", "no such fx", -2) return nil end
  
  return reaper.TrackFX_GetFXGUID(tracknumber2, 0x1000000+fxindex-1)
end

--A=ultraschall.InputFX_GetFXGUID(2)


function ultraschall.InputFX_GetFXName(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetFXName</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string fxname = ultraschall.InputFX_GetFXName(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the name of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, monitoring fx exists; false, no such monitoring-fx exists
    string fxname - the name of the monitoring-fx
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose name you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-fxname you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, name, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFXName", "fxindex", "must be an integer", -1) return false, "" end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetFXName", "tracknumber", "no such track; must be an integer", -3) return false, "" end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetFXName", "fxindex", "no such fx", -2) return false, "" end
  return reaper.TrackFX_GetFXName(tracknumber2, 0x1000000+fxindex-1, "")
end

--A,B,C=ultraschall.InputFX_GetFXName(1)

function ultraschall.InputFX_GetNumParams(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetNumParams</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer count_params = ultraschall.InputFX_GetNumParams(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the number of parameters of a monitoring-fx
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count_params - the number of parameters of the monitoring-fx
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose number of parameters you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-fxname you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, count, parameters, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetNumParams", "fxindex", "must be an integer", -1) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetNumParams", "tracknumber", "no such track; must be an integer", -3) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end  
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetNumParams", "fxindex", "no such fx", -2) return -1 end
  return reaper.TrackFX_GetNumParams(tracknumber2, 0x1000000+fxindex-1)
end

--A=ultraschall.InputFX_GetNumParams(1)

function ultraschall.InputFX_GetOffline(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetOffline</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean is_offline = ultraschall.InputFX_GetOffline(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the offline-state of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean is_offline - true, fx is offline; false, fx is not offline
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose offline-state you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-offline-state you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, offline, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetOffline", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetOffline", "tracknumber", "no such track; must be an integer", -3) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end  
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetOffline", "fxindex", "no such fx", -2) return false end
  return reaper.TrackFX_GetOffline(tracknumber2, 0x1000000+fxindex-1)
end

--A=ultraschall.InputFX_GetOffline(1)


function ultraschall.InputFX_GetOpen(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetOpen</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean is_open = ultraschall.InputFX_GetOpen(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns if a monitoring-fx is open(currently visible)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean is_open - true, fx is visible; false, fx is not visible
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose visibility-state you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-visibility-state you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, visible, open, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetOpen", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetOpen", "tracknumber", "no such track; must be an integer", -3) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end  
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetOpen", "fxindex", "no such fx", -2) return false end
  return reaper.TrackFX_GetOpen(tracknumber2, 0x1000000+fxindex-1)
end

--A=ultraschall.InputFX_GetOpen(2) 


function ultraschall.InputFX_GetPreset(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetPreset</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string preset = ultraschall.InputFX_GetPreset(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the currently selected preset of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, fx exists; false, fx does not exist
    string preset - the name of the currently selected preset; "", if no preset is selected
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose currently selected presetname-state you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-preset you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, presetname, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetPreset", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetPreset", "tracknumber", "no such track; must be an integer", -3) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end    
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetPreset", "fxindex", "no such fx", -2) return false end
  return reaper.TrackFX_GetPreset(tracknumber2, 0x1000000+fxindex-1, "")
end

--A={ultraschall.InputFX_GetPreset(1)}

function ultraschall.InputFX_GetPresetIndex(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetPresetIndex</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer selected_preset, integer number_of_presets = ultraschall.InputFX_GetPresetIndex(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the index of the currently selected preset of a monitoring-fx as well as the number of available presets
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer selected_preset - the index of the currently selected preset; 0, if no preset is selected
    integer number_of_presets - the number of presets available    
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose currently selected preset-index you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-preset you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, presetname, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetPresetIndex", "fxindex", "must be an integer", -1) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetPresetIndex", "tracknumber", "no such track; must be an integer", -3) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end    
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetPresetIndex", "fxindex", "no such fx", -2) return -1 end
  local presetindex, countpresets = reaper.TrackFX_GetPresetIndex(tracknumber2, 0x1000000+fxindex-1)
  if presetindex==countpresets then presetindex=-1 end
  return presetindex+1, countpresets
end

--A1={ultraschall.InputFX_GetPresetIndex(1)}


function ultraschall.InputFX_GetUserPresetFilename(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetUserPresetFilename</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>string preset_filename = ultraschall.InputFX_GetUserPresetFilename(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    returns the filename of the presetfile, into which the preset's-settings are stored
    
    returns nil in case of an error
  </description>
  <retvals>
    string preset_filename - the filename of the preset-file; nil, of not existing
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose preset's-filename you want to query; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-preset-filename you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, preset filename, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetUserPresetFilename", "fxindex", "must be an integer", -1) return nil end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetUserPresetFilename", "tracknumber", "no such track; must be an integer", -3) return nil end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end    
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_GetUserPresetFilename", "fxindex", "no such fx", -2) return nil end
  return reaper.TrackFX_GetUserPresetFilename(tracknumber2, 0x1000000+fxindex-1, "")
end  

--A=ultraschall.InputFX_GetUserPresetFilename(1)


function ultraschall.InputFX_NavigatePresets(fxindex, presetmove, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_NavigatePresets</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_NavigatePresets(integer fxindex, integer presetmove, optional integer tracknumber)</functioncall>
  <description>
    switches the preset of a monitoring-fx through, relative from its current preset-index.
    You can move by multiple presets, so 1 moves one further, 2 moves 2 further, -3 moves 3 backwards.
    
    If you hit the first/last preset, it will go back to the last/first preset respectively.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, altering was successful; false, altering was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx, whose preset you want to switch through; 1-based
    integer presetmove - positive, move forward by value of presetmove; negative, move backwards by value of presetmove
    optional integer tracknumber - the tracknumber, whose inputFX-preset you want to navigate; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, navigate, switch, preset, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_NavigatePresets", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_NavigatePresets", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_NavigatePresets", "fxindex", "no such fx", -2) return false end
  if math.type(presetmove)~="integer" then ultraschall.AddErrorMessage("InputFX_NavigatePresets", "presetmove", "must be an integer", -3) return false end
  return reaper.TrackFX_NavigatePresets(tracknumber2, 0x1000000+fxindex-1, presetmove)
end


--A,B=ultraschall.InputFX_NavigatePresets(1, 2)
--A1={ultraschall.InputFX_GetPresetIndex(1)}

function ultraschall.InputFX_SetEnabled(fxindex, enabled, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetEnabled</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetEnabled(integer fxindex, boolean enabled, optional integer tracknumber)</functioncall>
  <description>
    Sets a monitoring-fx to enabled.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx which you want to disable/enable; 1-based
    boolean enabled - true, enable the monitoring-fx; false, disable the monitoring-fx
    optional integer tracknumber - the tracknumber, whose inputFX-enabled-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, enabled, disabled, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEnabled", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetEnabled", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end  
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_SetEnabled", "fxindex", "no such fx", -2) return false end
  if type(enabled)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetEnabled", "enabled", "must be a boolean", -3) return false end
  reaper.TrackFX_SetEnabled(tracknumber2, 0x1000000+fxindex-1, enabled)
  return true
end

--A=ultraschall.InputFX_SetEnabled(1, true)



function ultraschall.InputFX_SetOffline(fxindex, offline, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetOffline</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetOffline(integer fxindex, boolean offline, optional integer tracknumber)</functioncall>
  <description>
    Sets a monitoring-fx to online/offline.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx which you want to set offline/online; 1-based
    boolean offline - true, set the monitoring-fx offline; false, set the monitoring-fx online
    optional integer tracknumber - the tracknumber, whose inputFX-offline-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, online, offline, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetOffline", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOffline", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end    
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_SetOffline", "fxindex", "no such fx", -2) return false end
  if type(offline)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetOffline", "offline", "must be a boolean", -3) return false end
  reaper.TrackFX_SetOffline(tracknumber2, 0x1000000+fxindex-1, offline)
  return true
end

--A=ultraschall.InputFX_SetOffline(1, false)



function ultraschall.InputFX_SetOpen(fxindex, open, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetOpen</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetOpen(integer fxindex, boolean open, optional integer tracknumber)</functioncall>
  <description>
    Sets a monitoring-fx visible of invisible
    
    If you change the index while open=true, the visible fx will change to the new one.
    
    Setting open=false closes the monitoring-fx-chain, open=true will open the monitoring-fx-chain if not visible yet.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx which you want to visible/invisible; 1-based
    boolean open - true, set the monitoring-fx visible; false, set the monitoring-fx invisible
    optional integer tracknumber - the tracknumber, whose inputFX-visibility-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, visible, invisible, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetOpen", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOpen", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_SetOpen", "fxindex", "no such fx", -2) return false end
  if type(open)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetOpen", "open", "must be a boolean", -3) return false end
  reaper.TrackFX_SetOpen(tracknumber2, 0x1000000+fxindex-1, open)
  return true
end

--ultraschall.InputFX_SetOpen(1, true)


function ultraschall.InputFX_SetPreset(fxindex, presetname, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetPreset</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetPreset(integer fxindex, string presetname)</functioncall>
  <description>
    Sets the preset of a monitoring-fx by presetname.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx of which you want to set the preset; 1-based
    string presetname - the name of the preset, that you want to select
    optional integer tracknumber - the tracknumber, whose inputFX-preset you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, preset, by name, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPreset", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetPreset", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_SetPreset", "fxindex", "no such fx", -2) return false end
  if type(presetname)~="string" then ultraschall.AddErrorMessage("InputFX_SetPreset", "presetname", "must be a string", -3) return false end
  return reaper.TrackFX_SetPreset(tracknumber2, 0x1000000+fxindex-1, presetname)
end

--A=ultraschall.InputFX_SetPreset(2, "Ultraschall3")


function ultraschall.InputFX_SetPresetByIndex(fxindex, presetindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetPresetByIndex</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetPresetByIndex(integer fxindex, integer presetindex, optional integer tracknumber)</functioncall>
  <description>
    Sets the preset of a monitoring-fx by preset-index.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx which you want to set the preset; 1-based
    integer presetindex - the index of the preset, that you want to select; 0, for default; -1, for no preset; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-preset you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, preset, by index, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPresetByIndex", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetPresetByIndex", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_SetPresetByIndex", "fxindex", "no such fx", -2) return false end
  if math.type(presetindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPresetByIndex", "presetindex", "must be an integer", -3) return false end
  return reaper.TrackFX_SetPresetByIndex(tracknumber2, 0x1000000+fxindex-1, presetindex-1)
end

--A=ultraschall.InputFX_SetPresetByIndex(2, 1)

function ultraschall.InputFX_Show(fxindex, showflag, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_Show</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_Show(integer fxindex, integer showflag, optional integer tracknumber)</functioncall>
  <description>
    Sets visibility and floating-state of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx which you want to set the preset; 1-based
    integer showflag - 0, for hidechain 
                     - 1, for show chain(index valid)
                     - 2, for hide floating window (index valid)
                     - 3, for show floating window (index valid)
    optional integer tracknumber - the tracknumber, whose inputFX-shown-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, visibility, floating, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_Show", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_Show", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 or ultraschall.InputFX_GetCount(tracknumber)<fxindex then ultraschall.AddErrorMessage("InputFX_Show", "fxindex", "no such fx", -2) return false end
  if math.type(showflag)~="integer" then ultraschall.AddErrorMessage("InputFX_Show", "showflag", "must be an integer", -3) return false end
  reaper.TrackFX_Show(tracknumber2, 0x1000000+fxindex-1, showflag)
  return true
end

--A=ultraschall.InputFX_Show(1, 3)

function ultraschall.InputFX_CopyFXToTakeFX(src_fx, dest_take, dest_fx, src_tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_CopyFXToTakeFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer dest_fx = ultraschall.InputFX_CopyFXToTakeFX(integer src_fx, MediaItem_Take take, integer dest_fx, optional integer src_tracknumber)</functioncall>
  <description>
    copies a monitoring-fx to a takeFX
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer dest_fx - the index of the inserted FX, just in case it differs; 1-based
  </retvals>
  <parameters>
    integer src_fx - the index inputFX that shall be copied; 1-based
    MediaItem_Take take - the take, into which you want to insert the fx as takeFX
    integer dest_fx - the index, at which you want to insert the fx; 1-based
    optional integer src_tracknumber - the tracknumber, whose inputFX you want to copy; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, copy, fx, takefx, inputfx</tags>
</US_DocBloc>
]]
  local src_tracknumber2
  if math.type(src_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXToTakeFX", "src_fx", "must be an integer", -1) return -1 end  
  if math.type(dest_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXToTakeFX", "dest_fx", "must be an integer", -3) return -1 end  
  if ultraschall.type(dest_take)~="MediaItem_Take" then ultraschall.AddErrorMessage("InputFX_CopyFXToTakeFX", "dest_take", "must be a MediaItem_Take", -4) return -1 end  
  if src_tracknumber~=nil and (math.type(src_tracknumber)~="integer" or (src_tracknumber<0 or src_tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFXToTakeFX", "tracknumber", "no such track; must be an integer", -5) return -1 end
  if src_tracknumber==nil or src_tracknumber==0 then src_tracknumber2=reaper.GetMasterTrack() else src_tracknumber2=reaper.GetTrack(0,src_tracknumber-1) end
  if src_fx<1 or ultraschall.InputFX_GetCount(src_tracknumber)<src_fx then ultraschall.AddErrorMessage("InputFX_CopyFXToTakeFX", "src_fx", "no such fx", -2) return -1 end
  local FinFX
  if dest_fx>reaper.TakeFX_GetCount(dest_take) then FinFX=reaper.TakeFX_GetCount(dest_take)+1 else FinFX=dest_fx end
  src_fx=src_fx-1
  dest_fx=dest_fx-1 
  
  reaper.TrackFX_CopyToTake(src_tracknumber2, src_fx+0x1000000, dest_take, dest_fx, false)
  return FinFX
end

--A=ultraschall.InputFX_CopyFXToTrackFX(1, reaper.GetMasterTrack(), 1)

function ultraschall.InputFX_CopyFXFromTakeFX(src_take, src_fx, dest_fx, dest_tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_CopyFXFromTakeFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer dest_fx = ultraschall.InputFX_CopyFXFromTakeFX(MediaItem_Take take, integer src_fx, integer dest_fx, optional integer dest_tracknumber)</functioncall>
  <description>
    copies a takeFX to monitoringFX
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer dest_fx - the index of the inserted FX, just in case it differs; 1-based
  </retvals>
  <parameters>
    MediaItem_Take take - the take, from which you want to copy the takeFX
    integer src_fx - the index takeFX that shall be copied; 1-based
    integer dest_fx - the index, at which you want to insert the fx into the monitoring FXChain; 1-based
    optional integer dest_tracknumber - the tracknumber, to which you want to copy a new inputFX; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, copy, fx, takefx, inputfx</tags>
</US_DocBloc>
]]
  local dest_tracknumber2
  if ultraschall.type(src_take)~="MediaItem_Take" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "src_take", "must be a MediaItem_Take", -4) return -1 end  
  if math.type(src_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "src_fx", "must be an integer", -1) return -1 end
  if src_fx<1 or reaper.TakeFX_GetCount(src_take)<src_fx then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "src_fx", "no such fx", -2) return -1 end
  if math.type(dest_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "dest_fx", "must be an integer", -3) return -1 end  
  if dest_fx<1 then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "dest_fx", "must be bigger or equal 1", -5) return -1 end  
  
  if dest_tracknumber~=nil and (math.type(dest_tracknumber)~="integer" or (dest_tracknumber<0 or dest_tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_CopyFXFromTakeFX", "tracknumber", "no such track; must be an integer", -6) return false end
  if dest_tracknumber==nil or dest_tracknumber==0 then dest_tracknumber2=reaper.GetMasterTrack() else dest_tracknumber2=reaper.GetTrack(0,dest_tracknumber-1) end
  
  local FinFX
  if dest_fx>ultraschall.InputFX_GetCount(dest_tracknumber) then FinFX=ultraschall.InputFX_GetCount(dest_tracknumber)+1 else FinFX=dest_fx end
  
  reaper.TakeFX_CopyToTrack(src_take, src_fx-1, dest_tracknumber2, 0x1000000+dest_fx-1, false)
  return FinFX
end

--ultraschall.InputFX_CopyFXFromTakeFX(reaper.GetMediaItemTake(reaper.GetMediaItem(0,0),0), 1, 1)

function ultraschall.InputFX_MoveFXFromTakeFX(src_take, src_fx, dest_fx, dest_tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_MoveFXFromTakeFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer dest_fx = ultraschall.InputFX_MoveFXFromTakeFX(MediaItem_Take take, integer src_fx, integer dest_fx, optional integer dest_tracknumber)</functioncall>
  <description>
    moves a takeFX to monitoringFX
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer dest_fx - the index of the inserted FX, just in case it differs; 1-based
  </retvals>
  <parameters>
    MediaItem_Take take - the take, from which you want to move the takeFX
    integer src_fx - the index takeFX that shall be movd; 1-based
    integer dest_fx - the index, at which you want to insert the fx into the monitoring FXChain; 1-based
    optional integer dest_tracknumber - the tracknumber, to which you want to move a new inputFX; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, move, fx, takefx, inputfx</tags>
</US_DocBloc>
]]
  local dest_tracknumber2
  if ultraschall.type(src_take)~="MediaItem_Take" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "src_take", "must be a MediaItem_Take", -4) return -1 end  
  if math.type(src_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "src_fx", "must be an integer", -1) return -1 end
  if src_fx<1 or reaper.TakeFX_GetCount(src_take)<src_fx then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "src_fx", "no such fx", -2) return -1 end
  if math.type(dest_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "dest_fx", "must be an integer", -3) return -1 end  
  if dest_fx<1 then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "dest_fx", "must be bigger or equal 1", -5) return -1 end  
  
  if dest_tracknumber~=nil and (math.type(dest_tracknumber)~="integer" or (dest_tracknumber<0 or dest_tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFXFromTakeFX", "tracknumber", "no such track; must be an integer", -6) return false end
  if dest_tracknumber==nil or dest_tracknumber==0 then dest_tracknumber2=reaper.GetMasterTrack() else dest_tracknumber2=reaper.GetTrack(0,dest_tracknumber-1) end
  
  local FinFX
  if dest_fx>ultraschall.InputFX_GetCount(dest_tracknumber) then FinFX=ultraschall.InputFX_GetCount(dest_tracknumber)+1 else FinFX=dest_fx end
  
  reaper.TakeFX_CopyToTrack(src_take, src_fx-1, dest_tracknumber2, 0x1000000+dest_fx-1, true)
  return FinFX
end

function ultraschall.InputFX_MoveFXToTakeFX(src_fx, dest_take, dest_fx, src_tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_MoveFXToTakeFX</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer dest_fx = ultraschall.InputFX_MoveFXToTakeFX(integer src_fx, MediaItem_Take take, integer dest_fx)</functioncall>
  <description>
    moves a monitoring-FX to a takeFX
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer dest_fx - the index of the inserted FX, just in case it differs; 1-based
  </retvals>
  <parameters>
    integer src_fx - the index inputFX that shall be moved; 1-based
    MediaItem_Take take - the take, into which you want to insert the fx as takeFX
    integer dest_fx - the index, at which you want to insert the fx; 1-based
    optional integer src_tracknumber - the tracknumber, whose inputFX you want to move; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, move, fx, takefx, inputfx</tags>
</US_DocBloc>
]]
  local src_tracknumber2
  if math.type(src_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXToTakeFX", "src_fx", "must be an integer", -1) return -1 end  
  if math.type(dest_fx)~="integer" then ultraschall.AddErrorMessage("InputFX_MoveFXToTakeFX", "dest_fx", "must be an integer", -3) return -1 end  
  if ultraschall.type(dest_take)~="MediaItem_Take" then ultraschall.AddErrorMessage("InputFX_MoveFXToTakeFX", "dest_take", "must be a MediaItem_Take", -4) return -1 end  
  if src_tracknumber~=nil and (math.type(src_tracknumber)~="integer" or (src_tracknumber<0 or src_tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_MoveFXToTakeFX", "tracknumber", "no such track; must be an integer", -5) return -1 end
  if src_tracknumber==nil or src_tracknumber==0 then src_tracknumber2=reaper.GetMasterTrack() else src_tracknumber2=reaper.GetTrack(0,src_tracknumber-1) end
  if src_fx<1 or ultraschall.InputFX_GetCount(src_tracknumber)<src_fx then ultraschall.AddErrorMessage("InputFX_MoveFXToTakeFX", "src_fx", "no such fx", -2) return -1 end
  local FinFX
  if dest_fx>reaper.TakeFX_GetCount(dest_take) then FinFX=reaper.TakeFX_GetCount(dest_take)+1 else FinFX=dest_fx end
  src_fx=src_fx-1
  dest_fx=dest_fx-1 
  
  reaper.TrackFX_CopyToTake(src_tracknumber2, src_fx+0x1000000, dest_take, dest_fx, true)
  return FinFX
end



function ultraschall.InputFX_GetFXChain(fxstatechunk_type, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetFXChain</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.InputFX_GetFXChain(integer fxstatechunk_type, optional integer tracknumber)</functioncall>
  <description>
    Loads the FXStateChunk from the monitoring-fx-chain.
    
    Returns 
  </description>
  <retvals>
    string FXStateChunk - the loaded FXStateChunk; nil, in case of an error
  </retvals>
  <parameters>
    integer fxstatechunk_type - 0, return the FXStateChunk as Track-FXStateChunk
                              - 1, return the FXStateChunk as Take-FXStateChunk
                              - 2, return the FXStateChunk as Track-InputFX-FXStateChunk
    optional integer tracknumber - the tracknumber of the track, whose fxinput-chain you want to get
                                 - nil or 0, global monitoring-fx; 1 and higher, the inputFX-chain from track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, load, fxstatechunk, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  if math.type(fxstatechunk_type)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFXChain", "fxstatechunk_type", "must be an integer", -1) return nil end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOpen", "tracknumber", "no such track; must be an integer", -4) return false end
  if fxstatechunk_type<0 or fxstatechunk_type>2 then ultraschall.AddErrorMessage("InputFX_GetFXChain", "fxstatechunk_type", "must be between 0 and 2", -3) return nil end
  local FXStateChunk  
  if tracknumber==nil or tracknumber==0 then
    -- return master-inputfx, as read from ResourcePath/reaper-hwoutfx.ini
    FXStateChunk = ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-hwoutfx.ini")
    FXStateChunk = string.gsub(FXStateChunk, "(BYPASS %d- %d-) %d-\n", "%1\n")
    
    local FXChain
    if fxstatechunk_type==0 then FXChain="<FXCHAIN\n" 
    elseif fxstatechunk_type==1 then FXChain="<TAKEFX\n" 
    elseif fxstatechunk_type==2 then FXChain="<FXCHAIN_REC\n"
    end
    
    return ultraschall.StateChunkLayouter(FXChain.."  "..string.gsub(FXStateChunk, "\n", "\n  ").."\n>")
  else
    -- return InputFX from a specific track, that is not master-track
    local retval, TSC=ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)
    TSC = ultraschall.StateChunkLayouter(TSC)
    FXStateChunk=TSC:match("\n  (<FXCHAIN_REC.-\n  >)")
    if FXStateChunk==nil then ultraschall.AddErrorMessage("InputFX_GetFXChain", "tracknumber", "track has no inputFX", -4) return nil end
    FXStateChunk=string.gsub(FXStateChunk, "\n  ", "\n")
    if fxstatechunk_type==0 then FXStateChunk=string.gsub(FXStateChunk, "<FXCHAIN_REC", "<FXCHAIN")
    elseif fxstatechunk_type==1 then FXStateChunk=string.gsub(FXStateChunk, "<FXCHAIN_REC", "<TAKEFX")
    end
    return FXStateChunk
  end
end

function ultraschall.InputFX_SetFXChain(FXStateChunk, replacefx, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetFXChain</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetFXChain(string FXStateChunk, boolean replacefx, optional integer tracknumber)</functioncall>
  <description>
    Inserts an FXStateChunk into the monitoring-fx-chain. Allows replacing it as well.
    
    This could potentially create hiccups in the audio-engine of Reaper.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk that shall be set as monitoring fx-chain
    boolean replacefx - true, replace the current monitoring-fx-chain with the new one; false, only insert the new fx at the end of the FXChain
    optional integer tracknumber - the track, whose inputFX-chain you want to set; 0 or nil, global monitoring fx
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fxstatechunk, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  if type(replacefx)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetFXChain", "replacefx", "must be a boolean", -1) return false end
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("InputFX_SetFXChain", "FXStateChunk", "not a valid FXStateChunk", -2) return false end
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("InputFX_SetFXChain", "tracknumber", "must be an integer", -3) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("InputFX_SetFXChain", "tracknumber", "no such track", -4) return false end
  
  if tracknumber==0 or tracknumber==nil then
    reaper.PreventUIRefresh(1)
    FXStateChunk=string.gsub(FXStateChunk, "<TAKEFX", "<FXCHAIN")
    local TSC=
[[<TRACK
  NAME ""
  PEAKCOL 33530462
  BEAT -1
  AUTOMODE 0
  VOLPAN 1 0 -1 -1 1
  MUTESOLO 0 0 0
  IPHASE 0
  PLAYOFFS 0 1
  ISBUS 0 0
  BUSCOMP 0 0 0 0 0
  SHOWINMIX 1 0.6667 0.5 1 0.5 0 0 0
  FREEMODE 0
  REC 0 0 1 0 0 0 0
  VU 2
  TRACKHEIGHT 0 0 0
  INQ 0 0 0 0.5 100 0 0 100
  NCHAN 2
  FX 1
  PERF 0
  MIDIOUT -1
  MAINSEND 1 0]]..
"\n  "..string.gsub(FXStateChunk, "\n", "\n  ").."\n"
..[[>
]]
    reaper.Undo_BeginBlock()
    local retval, MediaTrack = ultraschall.InsertTrack_TrackStateChunk(TSC)
    local count=ultraschall.InputFX_GetCount()
    if replacefx==true then
      count=0
      for i=1, ultraschall.InputFX_GetCount() do
        ultraschall.InputFX_Delete(1)
      end
    end
  
    for i=1, reaper.TrackFX_GetCount(MediaTrack) do
      --print2(i)
      ultraschall.InputFX_MoveFXFromTrackFX(MediaTrack, 1, i)
    end
    reaper.DeleteTrack(MediaTrack)
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock("Changed InputFX", -1)
    return true
  else
    
    FXStateChunk=string.gsub(FXStateChunk, "<TAKEFX\n", "<FXCHAIN_REC\n")
    FXStateChunk=string.gsub(FXStateChunk, "<FXCHAIN\n", "<FXCHAIN_REC\n")
    
    local retval, TSC = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)    
    TSC = ultraschall.StateChunkLayouter(TSC)
    
    -- get currently existing FXChain(if existing)
    local offset1, FXStateChunk_old, offset2=TSC:match("\n  ()(<FXCHAIN_REC.-\n  >)()")    
    if FXStateChunk_old==nil then 
      FXStateChunk_old="" 
      offset1, offset2 = TSC:match("MAINSEND.-\n()()")
    end
    
    if replacefx==false then
      -- if fx shall be replaced, prepare FXStateChunks for this
      FXStateChunk_old=string.gsub(FXStateChunk_old, "\n    ", "\n  ")
      FXStateChunk_old=FXStateChunk_old:sub(1,-2)
      FXStateChunk=FXStateChunk:match("(BYPASS.*)")     
    else
      -- if fx shall be replaced, make old FXStateChunk="" and layout the new statechunk
      FXStateChunk_old="    "      
      FXStateChunk="  "..ultraschall.StateChunkLayouter(FXStateChunk):sub(1,-3).."  >"
    end
    
    
    TSC=TSC:sub(1, offset1-1)..FXStateChunk_old.."\n"..FXStateChunk.."\n"..TSC:sub(offset2, -1)
    ultraschall.SetTrackStateChunk_Tracknumber(tracknumber, TSC)
  end
end

function ultraschall.InputFX_FormatParamValue(fxindex, paramindex, value, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_FormatParamValue</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string formatted_value = ultraschall.InputFX_FormatParamValue(integer fxindex, integer paramindex, number value, optional integer tracknumber)</functioncall>
  <description>
    You can take a value and format it in the style of the used format of a specific parameter, like the frequency(to Hz), gain(to dB) with ReaEQ or bypass(normal, bypasses), wet with ReaTune, etc.
    
    Note: only works with FX that support Cockos VST extensions.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, formatting was successful; false, formatting was unsuccessful(no such fx, parameter, no support for Cockos VST extension
    string formatted_value - the value in the format of the parameter; "", if not available
  </retvals>
  <parameters>
    integer fxindex - the index of the fx; 1-based
    integer paramindex - the parameter, whose formatting-style you want to applied to value; 1-based
    number value - the value you want to have formatted in the style of the parameter
    optional integer tracknumber - the tracknumber, whose inputFX-parameter you want to format; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, format, value, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "tracknumber", "no such track; must be an integer", -6) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "paramindex", "must be an integer", -3) return false end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "paramindex", "must 1 or higher", -4) return false end  
  if type(value)~="number" then ultraschall.AddErrorMessage("InputFX_FormatParamValue", "value", "must be a number", -5) return false end 

  return reaper.TrackFX_FormatParamValue(tracknumber2, 0x1000000+fxindex-1, paramindex-1, value, "")
end

--A,B,C=ultraschall.InputFX_FormatParamValue(2, 1, 0)

function ultraschall.InputFX_FormatParamValueNormalized(fxindex, paramindex, value, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_FormatParamValueNormalized</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string formatted_value = ultraschall.InputFX_FormatParamValueNormalized(integer fxindex, integer paramindex, number value, optional integer tracknumber)</functioncall>
  <description>
    You can take a value and format it in the style of the used format of a specific parameter, like the frequency(to Hz), gain(to dB) with ReaEQ or bypass(normal, bypasses), wet with ReaTune, etc.
    The value will be normalized.
    
    Note: only works with FX that support Cockos VST extensions.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, formatting was successful; false, formatting was unsuccessful(no such fx, parameter, no support for Cockos VST extension
    string formatted_value - the value in the format of the parameter; "", if not available
  </retvals>
  <parameters>
    integer fxindex - the index of the fx; 1-based
    integer paramindex - the parameter, whose formatting-style you want to applied to value; 1-based
    number value - the value you want to have formatted in the style of the parameter
    optional integer tracknumber - the tracknumber, whose inputFX-parameter you want to get formatted and normalized; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, format, value, normalized, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "tracknumber", "no such track; must be an integer", -6) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "paramindex", "must be an integer", -3) return false end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "paramindex", "must 1 or higher", -4) return false end  
  if type(value)~="number" then ultraschall.AddErrorMessage("InputFX_FormatParamValueNormalized", "value", "must be a number", -5) return false end

  return reaper.TrackFX_FormatParamValueNormalized(tracknumber2, 0x1000000+fxindex-1, paramindex-1, value, "")
end

--A,B,C=ultraschall.InputFX_FormatParamValueNormalized(1, 2, -1)


function ultraschall.InputFX_GetEQ(instantiate, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetEQ</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.InputFX_GetEQ(boolean instantiate, optional integer tracknumber)</functioncall>
  <description>
    Get the index of the first ReaEQ-instance in the monitoringFX, if available.
    
    Optionally add a new instance if ReaEQ isn't existing yet in the monitoring-fx-chain.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index_of_reaeq - the index of the first instance of ReaEQ in the monitoringFX; 0, if no ReaEQ is in the monitoringFX; -1, in case of an error
  </retvals>
  <parameters>
    boolean instantiate - true, add ReaEQ into monitoring-fx if not existing yet; false, don't add a ReaEQ-instance if not existing in monitoring-FXChain yet
    optional integer tracknumber - the tracknumber, whose inputFX-eq-position you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, eq instance, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if type(instantiate)~="boolean" then ultraschall.AddErrorMessage("InputFX_GetEQ", "instantiate", "must be a boolean", -1) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetEQ", "tracknumber", "no such track; must be an integer", -2) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if instantiate==true then instantiate=1 else instantiate=0 end
  return reaper.TrackFX_AddByName(tracknumber2, "ReaEQ", true, instantiate)+1
end

--A1,B1=ultraschall.InputFX_GetEQ(true)



function ultraschall.InputFX_GetFormattedParamValue(fxindex, paramindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetFormattedParamValue</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string formatted_value = ultraschall.InputFX_GetFormattedParamValue(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    Returns the current value of the monitoring-fx's parameter in its formatted style.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, getting was successful; false, getting was unsuccessful
    string formatted_value - the value of the formatted parameter; "", if not available
  </retvals>
  <parameters>
    integer fxindex - the index of the fx; 1-based
    integer paramindex - the parameter, whose formatted value you want to get; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-parameter-value you want to get as formatted; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, format, value, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFormattedParamValue", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetFormattedParamValue", "tracknumber", "no such track; must be an integer", -5) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetFormattedParamValue", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetFormattedParamValue", "paramindex", "must be an integer", -3) return false end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetFormattedParamValue", "paramindex", "must 1 or higher", -4) return false end  
  
  return reaper.TrackFX_GetFormattedParamValue(tracknumber2, 0x1000000+fxindex-1, paramindex-1, "")
end

--A={ultraschall.InputFX_GetFormattedParamValue(2, 1)}

function ultraschall.InputFX_GetIOSize(fxindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetIOSize</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional number inputPins, optional number outputPins = ultraschall.InputFX_GetIOSize(integer fxindex, optional integer tracknumber)</functioncall>
  <description>
    Returns the plugin-type and the input/output-pins available for an inputFX
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the plugin-type
                   - -1, no such plugin
                   - 0, VSTi
                   - 2, JSFX
                   - 3, VST
                   - 5, Mac AU
                   - 6, Video Processor
    optional number inputPins - the number of input-pins available
    optional number outputPins - the number of output-pins available
  </retvals>
  <parameters>
    integer fxindex - the index of the fx; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-plugintype/in-out-pins you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, plugin type, input pins, output pins, pins, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetIOSize", "fxindex", "must be an integer", -1) return -1 end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetIOSize", "tracknumber", "no such track; must be an integer", -2) return -1 end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetIOSize", "fxindex", "must 1 or higher", -2) return -1 end  
  return reaper.TrackFX_GetIOSize(tracknumber2, 0x1000000+fxindex-1)
end

--A={ultraschall.InputFX_GetIOSize(1)}

function ultraschall.InputFX_GetNamedConfigParm(fxindex, parmname, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetNamedConfigParm</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string config_parm_name = ultraschall.InputFX_GetNamedConfigParm(integer fxindex, string parmname, optional integer tracknumber)</functioncall>
  <description>
    gets plug-in specific named configuration value (returns true on success) of a monitoring-fx. 
    
    Special values: 
    'pdc' returns PDC latency. 
    'in_pin_0' returns name of first input pin (if available), 
    'out_pin_0' returns name of first output pin (if available), etc.
    'fx_ident' returns pluginname with path
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, name is available; false, name is not available
    string config_parm_name - the name of the config parameter
  </retvals>
  <parameters>
    integer fxindex - the index of the fx; 1-based
    string parmname - the value of the named config parm you want to get
    optional integer tracknumber - the tracknumber, whose inputFX-named-config-parameter-state you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, named configuration value, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetNamedConfigParm", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetNamedConfigParm", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetNamedConfigParm", "fxindex", "must 1 or higher", -2) return false end  
  if type(parmname)~="string" then ultraschall.AddErrorMessage("InputFX_GetNamedConfigParm", "parmname", "must be a string", -3) return false end

  return reaper.TrackFX_GetNamedConfigParm(tracknumber2, 0x1000000+fxindex-1, parmname)
end

--A3={ultraschall.InputFX_GetNamedConfigParm(2, "")}

function ultraschall.InputFX_GetParam(fxindex, paramindex, tracknumber)
  -- returns nil in case of an error
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetParam</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>number curval, number minval, number maxval = ultraschall.InputFX_GetParam(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    returns the current, maximum and minimum value of a parameter of a monitoring-fx.
    
    returns nil in case of an error
  </description>
  <retvals>
    number curval - the current value of the parameter
    number minval - the minimum value of this parameter
    number maxval - the maximum value of this parameter
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramindex - the parameter, whose value you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-parameter-states you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, value, parameter, minimum, maximum, monitoringfx, inputfx</tags>
</US_DocBloc>
]]  
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParam", "fxindex", "must be an integer", -1) return end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOpen", "tracknumber", "no such track; must be an integer", -5) return end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetParam", "fxindex", "must 1 or higher", -2) return end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParam", "paramindex", "must be an integer", -3) return end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetParam", "paramindex", "must 1 or higher", -4) return end  
  
  return reaper.TrackFX_GetParam(tracknumber2, 0x1000000+fxindex-1, paramindex-1)
end

--A={ultraschall.InputFX_GetParam(1, 4)}


function ultraschall.InputFX_GetParameterStepSizes(fxindex, paramindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetParameterStepSizes</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, number step, number smallstep, number largestep, boolean istoggle = ultraschall.InputFX_GetParameterStepSizes(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    returns the stepsizes of a parameter of a monitoring-fx.
    
    Commonly used for JSFX and VideoProcessor.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, stepsize is available; false; stepsize is not available; nil, in case of an error
    number step - the stepsize of this parameter
    number smallstep - the stepsize of a small step of this parameter
    number largestep - the stepsize of a large step of this parameter
    boolean istoggle - true, this parameter is a toggle parameter; false, this parameter is not a togle parameter
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramindex - the parameter, whose values you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-parameter-stepsizes you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, stepsize, parameter, monitoring fx, inputfx</tags>
</US_DocBloc>
]]  
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParameterStepSizes", "fxindex", "must be an integer", -1) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetParameterStepSizes", "tracknumber", "no such track; must be an integer", -5) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetParameterStepSizes", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParameterStepSizes", "paramindex", "must be an integer", -3) return false end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetParameterStepSizes", "paramindex", "must 1 or higher", -4) return false end  

  return reaper.TrackFX_GetParameterStepSizes(tracknumber2, 0x1000000+fxindex-1, paramindex-1)
end

--A={ultraschall.InputFX_GetParameterStepSizes(4, 2)}

function ultraschall.InputFX_GetParamEx(fxindex, paramindex, tracknumber)
  -- returns nil in case of an error
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetParamEx</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>number curval, number minval, number maxval, number midval = ultraschall.InputFX_GetParamEx(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    returns the current, maximum, minimum and mid-value of a parameter of a monitoring-fx.
    
    returns nil in case of an error
  </description>
  <retvals>
    number curval - the current value of the parameter
    number minval - the minimum value of this parameter
    number maxval - the maximum value of this parameter
    number midval - the mid-value of this parameter
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramindex - the parameter, whose value you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-param-states you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, value, parameter, minimum, maximum, midvalue, monitoringfx, inputfx</tags>
</US_DocBloc>
]]  
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamEx", "fxindex", "must be an integer", -1) return end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOpen", "tracknumber", "no such track; must be an integer", -6) return end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamEx", "fxindex", "must 1 or higher", -2) return end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamEx", "paramindex", "must be an integer", -3) return end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamEx", "paramindex", "must 1 or higher", -4) return end  
  
  return reaper.TrackFX_GetParamEx(tracknumber2, 0x1000000+fxindex-1, paramindex-1)
end

--A={ultraschall.InputFX_GetParamEx(1, 3)}

--mespotine

function ultraschall.InputFX_GetParamName(fxindex, paramindex, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetParamName</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string paramname = ultraschall.InputFX_GetParamName(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    returns the name of a parameter of a monitoring-fx.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, name can be returned; false, name cannot be returned
    string paramname - the name of the parameter
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramindex - the parameter, whose name you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-parameter-name you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, name, monitoringfx, inputfx</tags>
</US_DocBloc>
]]local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamName", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamName", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamName", "paramindex", "must be an integer", -3) return false end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamName", "paramindex", "must 1 or higher", -4) return false end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetParamName", "tracknumber", "no such track; must be an integer", -5) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end

  return reaper.TrackFX_GetParamName(tracknumber2, 0x1000000+fxindex-1, paramindex-1, "")
end

--A={ultraschall.InputFX_GetParamName(4, 2)}


function ultraschall.InputFX_GetParamNormalized(fxindex, paramindex, tracknumber)
  -- returns nil in case of an error
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetParamNormalized</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer normalized_value = ultraschall.InputFX_GetParamNormalized(integer fxindex, integer paramindex, optional integer tracknumber)</functioncall>
  <description>
    returns the value of a parameter of a monitoring-fx in a normalized state.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer normalized_value - the normalized version of the current value 
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramindex - the parameter, whose normalized value you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-param-normalized-state you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, value, normalized, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamNormalized", "fxindex", "must be an integer", -1) return end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamNormalized", "fxindex", "must 1 or higher", -2) return end  
  if math.type(paramindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetParamNormalized", "paramindex", "must be an integer", -3) return end
  if paramindex<1 then ultraschall.AddErrorMessage("InputFX_GetParamNormalized", "paramindex", "must 1 or higher", -4) return end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetParamNormalized", "tracknumber", "no such track; must be an integer", -5) return end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_GetParamNormalized(tracknumber2, 0x1000000+fxindex-1, paramindex-1)
end

--A={ultraschall.InputFX_GetParamNormalized(1, 3)}

function ultraschall.InputFX_GetPinMappings(fxindex, isoutput, pin, tracknumber)
  -- returns nil in case of an error
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetPinMappings</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer pinmappings_Lo32Bit, integer pinmappings_Hi32Bit = ultraschall.InputFX_GetPinMappings(integer fxindex, integer isoutput, integer pin, optional integer tracknumber)</functioncall>
  <description>
    returns the pinmappings as bitfield of a parameter of a monitoring-fx.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer pinmappings_Lo32Bit - a bitmask for the first 32 connectors, where each bit represents, if this pin is connected(1) or not(0)
    integer pinmappings_Hi32Bit - a bitmask for the second 32 connectors, where each bit represents, if this pin is connected(1) or not(0)
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer isoutput - 0, for querying input pins; 1, for querying output pins
    integer pin - the pin requested, like 0(left), 1(right), etc.
    optional integer tracknumber - the tracknumber, whose inputFX-pinmappings you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, pin mapping, inpin, outpin, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetPinMappings", "fxindex", "must be an integer", -1) return end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetPinMappings", "fxindex", "must 1 or higher", -2) return end  
  if math.type(isoutput)~="integer" then ultraschall.AddErrorMessage("InputFX_GetPinMappings", "isoutput", "must be an integer", -3) return end  
  if math.type(pin)~="integer" then ultraschall.AddErrorMessage("InputFX_GetPinMappings", "pin", "must be an integer", -4) return end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetPinMappings", "tracknumber", "no such track; must be an integer", -5) return end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_GetPinMappings(tracknumber2, 0x1000000+fxindex-1, isoutput, pin)--)0x1000000+fxindex-1, isoutput-1, pin-1)
end

--A={ultraschall.InputFX_GetPinMappings(1, 2, 1)}

function ultraschall.InputFX_SetEQBandEnabled(fxindex, bandtype, bandidx, enable, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetEQBandEnabled</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetEQBandEnabled(integer fxindex, integer bandtype, integer bandidx, boolean enable, optional integer tracknumber)</functioncall>
  <description>
    Enable or disable a ReaEQ band of a monitoring-fx.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer bandtype - the bandtype of the band to change;
                     - -1, master gain
                     - 0, hipass
                     - 1, loshelf
                     - 2, band
                     - 3, notch
                     - 4, hishelf
                     - 5, lopass
                     - 6, bandpass
    integer bandidx - 0, first band matching bandtype; 1, 2nd band matching bandtype, etc.
    boolean enable - true, enable band; false, disable band
    optional integer tracknumber - the tracknumber, whose inputFX-eq-band-enabled-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, reaeq, band, bandtype, enable, disable, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "fxindex", "must 1 or higher", -2) return false end
  if math.type(bandtype)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "bandtype", "must be an integer", -3) return false end
  if bandtype<0 then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "bandtype", "must 0 or higher", -4) return false end  
  if math.type(bandidx)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "bandidx", "must be an integer", -4) return false end
  if bandidx<0 then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "bandidx", "must 0 or higher", -5) return false end  
  if type(enable)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "enable", "must be a boolean", -6) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetEQBandEnabled", "tracknumber", "no such track; must be an integer", -7) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_SetEQBandEnabled(tracknumber2, 0x1000000+fxindex-1, bandtype, bandidx, enable)
end

--A=ultraschall.InputFX_SetEQBandEnabled(1, 2, 1, true)


function ultraschall.InputFX_SetEQParam(fxindex, bandtype, bandidx, paramtype, val, isnorm, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetEQParam</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetEQParam(integer fxindex, integer bandtype, integer bandidx, integer paramtype, number val, boolean isnorm)</functioncall>
  <description>
    Sets an EQ-parameter of a ReaEQ-instance in monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer bandtype - the bandtype of the band to change;
                     - -1, master gain
                     - 0, hipass
                     - 1, loshelf
                     - 2, band
                     - 3, notch
                     - 4, hishelf
                     - 5, lopass
                     - 6, bandpass
    integer bandidx - (ignored for master gain): 0, target first band matching bandtype; 1, target 2nd band matching bandtype, etc.
    integer paramtype - 0, freq; 1, gain; 2, Q
    number val - the new value for the paramtype of a bandidx
    boolean isnorm - true, value is normalized; false, value is not normalized
    optional integer tracknumber - the tracknumber, whose inputFX-eq-param-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, reaeq, band, bandtype, gain, frequency, normalize, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_SetEQParam", "fxindex", "must 1 or higher", -2) return false end
  if math.type(bandtype)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "bandtype", "must be an integer", -3) return false end
  if bandtype<0 then ultraschall.AddErrorMessage("InputFX_SetEQParam", "bandtype", "must 0 or higher", -4) return false end  
  if math.type(bandidx)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "bandidx", "must be an integer", -5) return false end
  if bandidx<0 then ultraschall.AddErrorMessage("InputFX_SetEQParam", "bandidx", "must 0 or higher", -6) return false end  
  if math.type(paramtype)~="integer" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "paramtype", "must be an integer", -7) return false end
  if paramtype<0 then ultraschall.AddErrorMessage("InputFX_SetEQParam", "paramtype", "must 0 or higher", -8) return false end  
  if type(val)~="number" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "val", "must be a number", -9) return false end  
  if type(isnorm)~="boolean" then ultraschall.AddErrorMessage("InputFX_SetEQParam", "isnorm", "must be a boolean", -10) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetEQParam", "tracknumber", "no such track; must be an integer", -11) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_SetEQParam(tracknumber2, 0x1000000+fxindex-1, bandtype, bandidx, paramtype, val, isnorm)
end

--ultraschall.InputFX_SetEQParam(1, -1, 1, 1, -1, true)

--mespotine

function ultraschall.InputFX_SetParam(fxindex, parameterindex, val, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetParam</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetParam(integer fxindex, index parameterindex, number val, optional integer tracknumber)</functioncall>
  <description>
    Sets a new value of a parameter of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    index parameterindex - the index of the parameter to be set; 1-based
    number val - the new value to set
    optional integer tracknumber - the tracknumber, whose inputFX-param-state you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parameter, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetParam", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_SetParam", "fxindex", "must 1 or higher", -2) return false end
  if math.type(parameterindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetParam", "parameterindex", "must be an integer", -3) return false end
  if parameterindex<1 then ultraschall.AddErrorMessage("InputFX_SetParam", "parameterindex", "must 1 or higher", -4) return false end  
  if type(val)~="number" then ultraschall.AddErrorMessage("InputFX_SetParam", "val", "must be a number", -5) return false end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetParam", "tracknumber", "no such track; must be an integer", -6) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_SetParam(tracknumber2, 0x1000000+fxindex-1, parameterindex-1, val)
end

--A=ultraschall.InputFX_SetParam(1, 1, 1)


function ultraschall.InputFX_SetParamNormalized(fxindex, parameterindex, val, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetParamNormalized</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetParamNormalized(integer fxindex, index parameterindex, number val, optional integer tracknumber)</functioncall>
  <description>
    Sets a new value as normalized of a parameter of a monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    index parameterindex - the index of the parameter to be set; 1-based
    number val - the new value to set
    optional integer tracknumber - the tracknumber, whose inputFX-parameter you want to set normalized; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, parameter, normalized, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "fxindex", "must 1 or higher", -2) return false end
  if math.type(parameterindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "parameterindex", "must be an integer", -3) return false end
  if parameterindex<1 then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "parameterindex", "must 1 or higher", -4) return false end  
  if type(val)~="number" then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "val", "must be a number", -5) return false end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetParamNormalized", "tracknumber", "no such track; must be an integer", -4) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_SetParamNormalized(tracknumber2, 0x1000000+fxindex-1, parameterindex-1, val)
end

--A=ultraschall.InputFX_SetParamNormalized(1, 2, 0)



function ultraschall.InputFX_SetPinMappings(fxindex, isoutput, pin, low32bits, hi32bits, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_SetPinMappings</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_SetPinMappings(integer fxindex, integer isoutput, integer pin, integer low32bits, integer hi32bits, optional integer tracknumber)</functioncall>
  <description>
    sets the pinmappings as bitfield of a parameter of a monitoring-fx.
    
    returns false in case of an error or if unsupported (not all types of plug-ins support this capability)
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer isoutput - 0, for querying input pins; 1, for querying output pins
    integer pin - the pin requested, like 0(left), 1(right), etc.
    integer pinmappings_Lo32Bit - a bitmask for the first 32 connectors, where each bit represents, if this pin is connected(1) or not(0)
    integer pinmappings_Hi32Bit - a bitmask for the second 32 connectors, where each bit represents, if this pin is connected(1) or not(0)
    optional integer tracknumber - the tracknumber, whose inputFX-pinmappings you want to set; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, pin mapping, inpin, outpin, monitoringfx, inputfx</tags>
</US_DocBloc>
]]
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "fxindex", "must 1 or higher", -2) return false end
  if math.type(isoutput)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "isoutput", "must be an integer", -3) return false end
  if math.type(pin)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "pin", "must be an integer", -4) return false end
  if math.type(low32bits)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "low32bits", "must be an integer", -4) return false end
  if math.type(hi32bits)~="integer" then ultraschall.AddErrorMessage("InputFX_SetPinMappings", "hi32bits", "must be an integer", -4) return false end
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_SetOpen", "tracknumber", "no such track; must be an integer", -5) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_SetPinMappings(tracknumber2, 0x1000000+fxindex-1, isoutput, pin, low32bits, hi32bits)
end

--A={ultraschall.InputFX_GetPinMappings(2, 1, 1)}
--B=ultraschall.InputFX_SetPinMappings(2, 1, 1, 4, 3)



function ultraschall.InputFX_GetEQBandEnabled(fxindex, bandtype, bandidx, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetEQBandEnabled</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.42
    Lua=5.3
  </requires>
  <functioncall>boolean enabled = ultraschall.InputFX_GetEQBandEnabled(integer fxindex, integer bandtype, integer bandidx, optional integer tracknumber)</functioncall>
  <description>
    Gets the enable or disable-state of a ReaEQ band of a monitoring-fx.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean enabled - true, band is enabled; false, band is disabled
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer bandtype - the bandtype of the band to change;
                     - -1, master gain
                     - 0, hipass
                     - 1, loshelf
                     - 2, band
                     - 3, notch
                     - 4, hishelf
                     - 5, lopass
                     - 6, bandpass
    integer bandidx - 0, first band matching bandtype; 1, 2nd band matching bandtype, etc.
    optional integer tracknumber - the tracknumber, whose inputFX-EQ-Band-enabled-state you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, reaeq, band, bandtype, enable, disable, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(bandtype)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "bandtype", "must be an integer", -3) return false end
  if bandtype<0 then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "bandtype", "must 0 or higher", -4) return false end  
  if math.type(bandidx)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "bandidx", "must be an integer", -5) return false end
  if bandidx<0 then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "bandidx", "must 0 or higher", -6) return false end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetEQBandEnabled", "tracknumber", "no such track; must be an integer", -6) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_GetEQBandEnabled(tracknumber2, 0x1000000+fxindex-1, bandtype, bandidx)
end

--A,B,C,D,E=ultraschall.InputFX_GetEQBandEnabled(14, 2, 0)

function ultraschall.InputFX_GetEQParam(fxindex, paramidx, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetEQParam</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval, number bandtype, number bandidx, number paramtype, number normval = ultraschall.InputFX_GetEQParam(integer fxindex, integer paramidx, optional integer tracknumber)</functioncall>
  <description>
    Gets the states and values of an EQ-parameter of a ReaEQ-instance in monitoring-fx
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's a ReaEQ-instance; false, is not a ReaEQ-instance or in case of an error
    integer bandtype - the bandtype of the band to change;
                     - -1, master gain
                     - 0, hipass
                     - 1, loshelf
                     - 2, band
                     - 3, notch
                     - 4, hishelf
                     - 5, lopass
                     - 6, bandpass
    integer bandidx - 0, first band matching bandtype; 1, 2nd band matching bandtype, etc.
    number paramtype -  0, freq; 1, gain; 2, Q
    number normval - the normalized value
  </retvals>
  <parameters>
    integer fxindex - the index of the monitoring-fx; 1-based
    integer paramidx - the parameter whose eq-states you want to retrieve; 1-based
    optional integer tracknumber - the tracknumber, whose inputFX-eq-param you want to get; 0 or nil, global monitoring fx; 1 and higher, track 1 and higher
  </parameters>
  <chapter_context>
    FX-Management
    InputFX
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, reaeq, band, bandtype, gain, frequency, normalize, monitoringfx, inputfx</tags>
</US_DocBloc>
]]    
  local tracknumber2
  if math.type(fxindex)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEQParam", "fxindex", "must be an integer", -1) return false end
  if fxindex<1 then ultraschall.AddErrorMessage("InputFX_GetEQParam", "fxindex", "must 1 or higher", -2) return false end  
  if math.type(paramidx)~="integer" then ultraschall.AddErrorMessage("InputFX_GetEQParam", "paramidx", "must be an integer", -3) return false end
  if paramidx<1 then ultraschall.AddErrorMessage("InputFX_GetEQParam", "paramidx", "must 1 or higher", -4) return false end  
  if tracknumber~=nil and (math.type(tracknumber)~="integer" or (tracknumber<0 or tracknumber>reaper.CountTracks())) then ultraschall.AddErrorMessage("InputFX_GetEQParam", "tracknumber", "no such track; must be an integer", -5) return false end
  if tracknumber==nil or tracknumber==0 then tracknumber2=reaper.GetMasterTrack() else tracknumber2=reaper.GetTrack(0,tracknumber-1) end
  
  return reaper.TrackFX_GetEQParam(tracknumber2, 0x1000000+fxindex-1, paramidx-1)
end

--A={ultraschall.InputFX_GetEQParam(14, 1)}

function ultraschall.GetFocusedFX()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFocusedFX</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer tracknumber, integer fxidx, integer itemnumber, integer takeidx, MediaTrack track, optional MediaItem item, optional MediaItemTake take = ultraschall.GetFocusedFX()</functioncall>
  <description>
    Returns the focused FX
  </description>
  <retvals>
    integer retval -   0, if no FX window has focus
                   -   1, if a track FX window has focus or was the last focused and still open
                   -   2, if an item FX window has focus or was the last focused and still open
                   -   &4, if fx is not focused anymore but is still opened
    integer tracknumber - tracknumber; 0, master track; 1, track 1; etc.
    integer fxidx - the index of the FX; 1-based
    integer itemnumber - -1, if it's a track-fx; 1 and higher, the mediaitem-number
    integer takeidx - -1, if it's a track-fx; 1 and higher, the take-number
    MediaTrack track - the MediaTrack-object
    optional MediaItem item - the MediaItem, if take-fx
    optional MediaItemTake take - the MediaItem-Take, if take-fx
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, focused, fx</tags>
</US_DocBloc>
]]    
  local retval, tracknumber, itemnumber, fxnumber = reaper.GetFocusedFX2()
  if retval==0 then return 0 end
  local FXID, TakeID, item, take, track
  FXID=fxnumber+1
  TakeID=-1
  if itemnumber~=-1 then
    FXID=fxnumber&1+(fxnumber&2)+(fxnumber&4)+(fxnumber&8)+(fxnumber&16)+(fxnumber&32)+(fxnumber&64)+(fxnumber&128)+
         (fxnumber&256)+(fxnumber&512)+(fxnumber&1024)+(fxnumber&2048)+(fxnumber&4096)+(fxnumber&8192)+(fxnumber&16384)+(fxnumber&32768)
    TakeID=fxnumber>>16
    TakeID=TakeID+1
    FXID=FXID+1
    item=reaper.GetMediaItem(0, itemnumber)
    take=reaper.GetMediaItemTake(reaper.GetMediaItem(0, itemnumber), TakeID-1)
    itemnumber=itemnumber+1
  end

  if tracknumber>0 then 
    track=reaper.GetTrack(0, tracknumber-1)
  elseif tracknumber==0 then
    track=reaper.GetMasterTrack(0)
  end
  return retval, tracknumber, FXID, itemnumber, TakeID, track, item, take
end

function ultraschall.GetLastTouchedFX()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastTouchedFX</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer sourcetype, integer track_take_number, integer fxnumber, integer paramnumber, integer takeID, optional MediaTrack track, optional MediaItemTake take = ultraschall.GetLastTouchedFX()</functioncall>
  <description>
    Returns the last touched FX
    
    Note: Does not return last touched monitoring-FX!
  </description>
  <retvals>
    boolean retval - true, valid FX; false, no valid FX
    integer sourcetype - 0, takeFX; 1, trackFX
    integer track_take_number - the track or takenumber(see sourcetype-retval); 1-based
    integer fxnumber - the number of the fx; 1-based
    integer paramnumber - the number of the parameter; 1-based
    integer takeID - the number of the take; 1-based; -1, if takeFX
    optional MediaTrack track - the track of the TrackFX
    optional MediaItemTake take - the take of the TakeFX
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, last touched, fx</tags>
</US_DocBloc>
]]    
  local retval, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX()
  if retval==false then return false end
  local FXID, TakeID, track
  local inputfx=false
  if tracknumber>65536 then
    tracknumber=tracknumber&1+(tracknumber&2)+(tracknumber&4)+(tracknumber&8)+(tracknumber&16)+(tracknumber&32)+(tracknumber&64)+(tracknumber&128)+
         (tracknumber&256)+(tracknumber&512)+(tracknumber&1024)+(tracknumber&2048)+(tracknumber&4096)+(tracknumber&8192)+(tracknumber&16384)+(tracknumber&32768)
    FXID=fxnumber&1+(fxnumber&2)+(fxnumber&4)+(fxnumber&8)+(fxnumber&16)+(fxnumber&32)+(fxnumber&64)+(fxnumber&128)+
         (fxnumber&256)+(fxnumber&512)+(fxnumber&1024)+(fxnumber&2048)+(fxnumber&4096)+(fxnumber&8192)+(fxnumber&16384)+(fxnumber&32768)
    TakeID=fxnumber>>16           
    TakeID=TakeID+1
    Itemnumber=tracknumber
    return retval, 0, Itemnumber,  FXID+1,     paramnumber+1, TakeID, nil,   reaper.GetMediaItemTake(reaper.GetMediaItem(0, tracknumber-1), TakeID-1)
  else
    if tracknumber>0 then 
      track=reaper.GetTrack(0, tracknumber-1)
    elseif tracknumber==0 then
      track=reaper.GetMasterTrack(0)
    end
    return retval, 1, tracknumber, fxnumber+1, paramnumber+1, -1,     track, nil
  end
end

function ultraschall.GetFXComment_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXComment_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string comment = ultraschall.GetFXComment_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the fx-comment of a specific fx from an FXStateChunk
    
    will return "" if no comment exists
    
    returns nil in case of an error
  </description>
  <retvals>
    string comment - the comment as stored for this specific fx; "", if no comment exists
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return a specific fx-comment
    integer fxid - the fx, whose comment you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, comment</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXComment_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXComment_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXComment_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local Comment=fx_lines:match("\n    <COMMENT%s-\n%s*(.-)>\n")
  if Comment==nil then return "" end
  Comment=string.gsub(Comment,"[%s%c]","")
  
  if Comment~=nil then Comment=ultraschall.Base64_Decoder(Comment) else return "" end
  ultraschall.SuppressErrorMessages(false)
  return Comment
end

--A=ultraschall.GetFXComment_FXStateChunk(FXStateChunk, 4)
--print2(A)


function ultraschall.SetFXComment_FXStateChunk(FXStateChunk, fx_id, NewComment)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXComment_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXComment_FXStateChunk(string FXStateChunk, integer fxid, string NewComment)</functioncall>
  <description>
    sets an fx-comment of a specific fx within an FXStateChunk
    
    Set to "" to remove the comment
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new comment
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new comment
    integer fxid - the fx, whose comment you want to set
    string NewComment - the new comment; "", to remove the currently set comment; newlines are allowed
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, comment</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXComment_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXComment_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if type(NewComment)~="string" then ultraschall.AddErrorMessage("SetFXComment_FXStateChunk", "NewComment", "must be a string", -3) return nil end

  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("SetFXComment_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local Comment=fx_lines:match("()\n    <COMMENT%s-\n")
  if NewComment=="" then 
    FXStateChunk=FXStateChunk:sub(1, startoffset)..fx_lines:sub(1,Comment+1)..FXStateChunk:sub(endoffset, -1)
    return FXStateChunk
  end
  if Comment==nil then Comment=fx_lines:len() end
  --print2(fx_lines)
  NewComment=ultraschall.Base64_Encoder(NewComment)
  if NewComment:len()>280 then
    local temp=NewComment
    NewComment=""
    while temp:len()>1 do
      NewComment=NewComment.."      "..temp:sub(1,280).."\n"
      temp=temp:sub(281,-1)
    end
  else
    NewComment="      "..NewComment.."\n"
  end
  
  fx_lines=fx_lines:sub(1,Comment)..[[
    <COMMENT 
]]..NewComment..[[
    >
 ]]    


  FXStateChunk=FXStateChunk:sub(1, startoffset)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end

--A=ultraschall.SetFXComment_FXStateChunk(FXStateChunk, "Alternative Text", 1)

function ultraschall.CountFXFromFXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountFXFromFXStateChunk</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>integer count_of_fx= ultraschall.CountFXFromFXStateChunk(string FXStateChunk)</functioncall>
    <description>
      count the number of fx available in an FXStateChunk
      
      returns nil in case of an error
    </description>
    <retvals>
      integer count_of_fx - the number of fx within the FXStateChunk
    </retvals>
    <parameters>
      string FXStateChunk - the FXStateChunk in which you want to count the fx
    </parameters>
    <chapter_context>
      FX-Management
      FXStateChunks
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, count, fx, fxstatechunk</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("CountFXFromFXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return end
  local index=0
  
  for b in string.gmatch(FXStateChunk, "(%s-BYPASS.-\n.-WAK.-)\n") do
    index=index+1
  end
  
  return index
end
  
--  retval, StateChunk=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--  FXStateChunk, linenumber = ultraschall.GetFXStateChunk(StateChunk)
--  Count=ultraschall.CountFXFromFXStateChunk(FXStateChunk)
  
function ultraschall.GetTrackFXComment(track, fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackFXComment</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string comment = ultraschall.GetTrackFXComment(MediaTrack track, integer fxid)</functioncall>
    <description>
      returns the comment of a track-fx
      
      returns nil in case of an error
    </description>
    <retvals>
      string comment - the comment of a track-fx
    </retvals>
    <parameters>
      MediaTrack track - the mediatrack, of which you want to request a trackfx's comment
      integer fxid - the id of the fx, whose comment you want to have
    </parameters>
    <chapter_context>
      FX-Management
      Get States
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, get, trackfx, comment</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("GetTrackFXComment", "track", "must be a valid MediaTrack", -1) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetTrackFXComment", "fxid", "must be an integer", -2) return nil end
  local retval, StateChunk=reaper.GetTrackStateChunk(track,"",false)
  local FXStateChunk, linenumber = ultraschall.GetFXStateChunk(StateChunk)
  if ultraschall.CountFXFromFXStateChunk(FXStateChunk)<fxid then ultraschall.AddErrorMessage("GetTrackFXComment", "fxid", "no such an fx", -3) return nil end
  return ultraschall.GetFXComment_FXStateChunk(FXStateChunk, fxid)
end

--A=ultraschall.GetTrackFXComment(reaper.GetTrack(0,0), 1)


function ultraschall.GetTakeFXComment(item, takeid, fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTakeFXComment</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string comment = ultraschall.GetTakeFXComment(MediaItem item, integer takeid, integer fxid)</functioncall>
    <description>
      returns the comment of a take-fx
      
      returns nil in case of an error
    </description>
    <retvals>
      string comment - the comment of a track-fx
    </retvals>
    <parameters>
      MediaItem item - the mediaitem, whose takefx-comment you want to request
      integer take_id - the id of the take, whose takefx-comment you want to request
      integer fxid - the id of the fx, whose comment you want to have
    </parameters>
    <chapter_context>
      FX-Management
      Get States
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, get, takefx, comment</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(item)~="MediaItem" then ultraschall.AddErrorMessage("GetTakeFXComment", "item", "must be a valid MediaItem", -1) return nil end
  if math.type(takeid)~="integer" then ultraschall.AddErrorMessage("GetTakeFXComment", "takeid", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetTakeFXComment", "fxid", "must be an integer", -3) return nil end
  local retval, StateChunk=reaper.GetItemStateChunk(item,"",false)
  local FXStateChunk, linenumber = ultraschall.GetFXStateChunk(StateChunk, takeid)
  if FXStateChunk=="" then ultraschall.AddErrorMessage("GetTakeFXComment", "takeid", "no such take", -4) return nil end
  if ultraschall.CountFXFromFXStateChunk(FXStateChunk)<fxid then ultraschall.AddErrorMessage("GetTakeFXComment", "fxid", "no such an fx", -5) return nil end
  return ultraschall.GetFXComment_FXStateChunk(FXStateChunk, fxid)
end

--A=ultraschall.GetTakeFXComment(reaper.GetMediaItem(0,0), 1, 1)

function ultraschall.InputFX_GetComment(fxid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_GetComment</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string comment = ultraschall.InputFX_GetComment(integer fxid)</functioncall>
    <description>
      returns the comment of an input-fx
      
      returns nil in case of an error
    </description>
    <retvals>
      string comment - the comment of a track-fx
    </retvals>
    <parameters>
      integer fxid - the id of the fx, whose comment you want to have
    </parameters>
    <chapter_context>
      FX-Management
      InputFX
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, get, inputfx, comment</tags>
  </US_DocBloc>
  --]] 
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("InputFX_GetComment", "fxid", "must be an integer", -1) return nil end
  local FXStateChunk = ultraschall.InputFX_GetFXChain(0)
  return ultraschall.GetFXComment_FXStateChunk(FXStateChunk, fxid)
end

--A=ultraschall.InputFX_GetComment(1)
--  print2(fx_lines)


function ultraschall.SetTrackFXComment(track, fxid, Comment)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackFXComment</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SetTrackFXComment(MediaTrack track, integer fxid, string Comment)</functioncall>
    <description>
      sets the comment of a track-fx
      
      Note: you need to switch fxchain off/on or change the shown fx for the new comment to be displayed in Reaper's UI
      
      returns false in case of an error
    </description>
    <retvals>
      boolean retval - true, setting was successful; false, setting was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the mediatrack, of which you want to set a trackfx's comment
      integer fxid - the id of the fx, whose comment you want to set
      string Comment - the new comment
    </parameters>
    <chapter_context>
      FX-Management
      Set States
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, set, trackfx, comment</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("SetTrackFXComment", "track", "must be a valid MediaTrack", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetTrackFXComment", "fxid", "must be an integer", -2) return false end
  if type(Comment)~="string" then ultraschall.AddErrorMessage("SetTrackFXComment", "Comment", "must be a string", -3) return false end

  local retval, StateChunk=reaper.GetTrackStateChunk(track,"",false)
  local FXStateChunk, linenumber = ultraschall.GetFXStateChunk(StateChunk)
  if ultraschall.CountFXFromFXStateChunk(FXStateChunk)<fxid then ultraschall.AddErrorMessage("SetTrackFXComment", "fxid", "no such an fx", -4) return false end
  local FXStateChunk = ultraschall.SetFXComment_FXStateChunk(FXStateChunk, fxid, Comment)
  local retval, alteredStateChunk = ultraschall.SetFXStateChunk(StateChunk, FXStateChunk)
  return reaper.SetTrackStateChunk(track, alteredStateChunk, false)
end


--A=ultraschall.SetTrackFXComment(reaper.GetTrack(0,0), 1, "Later with Jools Holland")

function ultraschall.SetTakeFXComment(item, takeid, fxid, Comment)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTakeFXComment</slug>
    <requires>
      Ultraschall=4.2
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string comment = ultraschall.SetTakeFXComment(MediaItem item, integer takeid, integer fxid, string Comment)</functioncall>
    <description>
      sets the comment of a take-fx
      
      returns nil in case of an error
    </description>
    <retvals>
      string comment - the comment of a track-fx
    </retvals>
    <parameters>
      MediaItem item - the mediaitem, whose takefx-comment you want to set
      integer take_id - the id of the take, whose takefx-comment you want to set
      integer fxid - the id of the fx, whose comment you want to set
      string Comment - the new Comment for this takefx
    </parameters>
    <chapter_context>
      FX-Management
      Set States
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
    <tags>fxmanagement, set, takefx, comment</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(item)~="MediaItem" then ultraschall.AddErrorMessage("SetTakeFXComment", "item", "must be a valid MediaItem", -1) return nil end
  if math.type(takeid)~="integer" then ultraschall.AddErrorMessage("SetTakeFXComment", "takeid", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetTakeFXComment", "fxid", "must be an integer", -3) return nil end
  if type(Comment)~="string" then ultraschall.AddErrorMessage("SetTakeFXComment", "Comment", "must be a string", -4) return false end
  
  local retval, StateChunk=reaper.GetItemStateChunk(item,"",false)
  local FXStateChunk, linenumber = ultraschall.GetFXStateChunk(StateChunk, takeid)
  if FXStateChunk=="" then ultraschall.AddErrorMessage("SetTakeFXComment", "takeid", "no such take", -5) return nil end
  if ultraschall.CountFXFromFXStateChunk(FXStateChunk)<fxid then ultraschall.AddErrorMessage("SetTakeFXComment", "fxid", "no such an fx", -6) return nil end
  local FXStateChunk = ultraschall.SetFXComment_FXStateChunk(FXStateChunk, fxid, Comment)
  local retval, alteredStateChunk = ultraschall.SetFXStateChunk(StateChunk, FXStateChunk, takeid)  
  return reaper.SetItemStateChunk(item, alteredStateChunk, false)
end

function ultraschall.GetFXWak_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXWak_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer keyboard_input_2_plugin, integer fx_embed_state = ultraschall.GetFXWak_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the WAK-entryvalues of a specific fx from an FXStateChunk, as set by the +-button->Send all keyboard input to plugin-menuentry in the FX-window of the visible plugin.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer keyboard_input_2_plugin - 0, don't send all the keyboard-input to plugin; 1, send all keyboard-input to plugin
    integer fx_embed_state - set embedding of the fx; &amp;1=TCP, &amp;2=MCP
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the WAK-entry
    integer fxid - the fx, whose WAK-entryvalues you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, wak, keyboard input, plugin</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXWak_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXWak_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXWak_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local WAK=fx_lines:match("\n.-WAK (.-)\n")
  
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(WAK.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  ultraschall.SuppressErrorMessages(false)
  return table.unpack(individual_values)
end

function ultraschall.GetFXMidiPreset_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXMidiPreset_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer midi_preset = ultraschall.GetFXMidiPreset_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the MIDIPRESET-entryvalues of a specific fx from an FXStateChunk as set by the +-button->Link to MIDI program change-menuentry in the FX-window of the visible plugin.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer midi_preset - 0, No Link; 17, Link all channels sequentially; 1-16, MIDI-channel 1-16
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the MIDIPRESET-entry
    integer fxid - the fx, whose MIDIPRESET-entryvalues you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, midipreset, keyboard input, plugin</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXMidiPreset_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXMidiPreset_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXMidiPreset_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local MIDIPreset=fx_lines:match("\n.-MIDIPRESET (.-)\n")
  if MIDIPreset==nil then ultraschall.SuppressErrorMessages(false) return 0 end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(MIDIPreset.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  ultraschall.SuppressErrorMessages(false)
  return table.unpack(individual_values)
end

function ultraschall.SetFXWak_FXStateChunk(FXStateChunk, fx_id, send_all_keyboard_input_to_fx, fx_embed_state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXWak_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXWak_FXStateChunk(string FXStateChunk, integer fxid, integer send_all_keyboard_input_to_fx, integer fx_embed_state)</functioncall>
  <description>
    sets the fx-WAK-entry of a specific fx within an FXStateChunk, which allows setting "sending all keyboard input to plugin"-option and "embed fx in tcp/mcp"-option of an fx
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new wak-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new wak-state
    integer fxid - the fx, whose wak-state you want to set
    integer send_all_keyboard_input_to_fx - state of sen all keyboard input to plug-in; 0, turned off; 1, turned on
    integer fx_embed_state - set embedding of the fx; &amp;1=TCP, &amp;2=MCP
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, wak, embed fx in tcp mcp, send all keyboardinput to fx</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXWak_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXWak_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if math.type(send_all_keyboard_input_to_fx)~="integer" then ultraschall.AddErrorMessage("SetFXWak_FXStateChunk", "send_all_keyboard_input_to_fx", "must be an integer", -3) return nil end
  if math.type(fx_embed_state)~="integer" then ultraschall.AddErrorMessage("SetFXWak_FXStateChunk", "fx_embed_state", "must be an integer", -4) return nil end
  
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  fx_lines=string.gsub(fx_lines, "WAK.-\n", "WAK "..send_all_keyboard_input_to_fx.." "..fx_embed_state.."\n")
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end


function ultraschall.SetFXMidiPreset_FXStateChunk(FXStateChunk, fx_id, midi_preset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXMidiPreset_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXMidiPreset_FXStateChunk(string FXStateChunk, integer fxid, integer midi_preset)</functioncall>
  <description>
    sets the MIDIPRESET-entryvalues of a specific fx from an FXStateChunk as set by the +-button->Link to MIDI program change-menuentry in the FX-window of the visible plugin.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new comment
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new comment
    integer fxid - the fx, whose comment you want to set
    integer midi_preset - 0, No Link; 17, Link all channels sequentially; 1-16, MIDI-channel 1-16 
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, midi preset</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXMidiPreset_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXMidiPreset_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if math.type(midi_preset)~="integer" then ultraschall.AddErrorMessage("SetFXMidiPreset_FXStateChunk", "midi_preset", "must be an integer", -3) return nil end
  
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if midi_preset==0 then midi_preset="" else midi_preset="MIDIPRESET "..midi_preset.."\n    " end
  fx_lines=string.gsub(fx_lines, "\n( -MIDIPRESET.-\n)", "\n")
  local offset=fx_lines:match("()PRESETNAME")
  fx_lines=fx_lines:sub(1,offset-1)..midi_preset..fx_lines:sub(offset,-1)
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end

function ultraschall.GetFXBypass_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXBypass_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer bypass, integer offline, integer unknown = ultraschall.GetFXBypass_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the BYPASS-entryvalues of a specific fx from an FXStateChunk, like bypass and online-state..
    
    returns nil in case of an error
  </description>
  <retvals>
    integer bypass - 0, non-bypassed; 1, bypassed
    integer offline - 0, online; 1, offline
    integer unknown - unknown; default is 0
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the BYPASS-entry
    integer fxid - the fx, whose BYPASS-entryvalues you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, bypass, online, offline</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXBypass_FXStateChunk.GetFXWAK_FXStateChunk()", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXBypass_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXBypass_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local BYPASS=fx_lines:match("\n.-BYPASS (.-)\n")
  
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(BYPASS.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  ultraschall.SuppressErrorMessages(false)
  return table.unpack(individual_values)
end

function ultraschall.GetFXFloatPos_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXFloatPos_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean floating, integer x, integer y, integer width, integer height = ultraschall.GetFXFloatPos_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the FLOATPOS/FLOAT-entryvalues of a specific fx from an FXStateChunk, like float-state and float-coordinates.
    
    If all coordinates of the floating fx-window are 0, then the fx-window was never in float-state, yet.
    
    There is only one of the FLOATPOS/FLOAT-entries present at any time.
    FLOATPOS, when the fx-window is not floating
    FLOAT, when the fx-window is floating.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean floating - true, fx-window is floating; false, fx-window isn't floating
    integer x - the x-position of the floating window; 0, if it hasn't been floating yet
    integer y - the y-position of the floating window; 0, if it hasn't been floating yet
    integer width - the width of the floating window; 0, if it hasn't been floating yet
    integer height - the height of the floating window; 0, if it hasn't been floating yet
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the FLOAT/FLOATPOS-entry
    integer fxid - the fx, whose FLOAT/FLOATPOS-entryvalues you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, float, floatpos, floatstate</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXFloatPos_FXStateChunk.GetFXWAK_FXStateChunk()", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXFloatPos_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXFloatPos_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local float, FLOATPOS=fx_lines:match("\n.-FLOAT(%a-) (.-)\n")
  
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(FLOATPOS.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  ultraschall.SuppressErrorMessages(false)
  return float~="POS", table.unpack(individual_values)
end



function ultraschall.GetFXGuid_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXGuid_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetFXGuid_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    returns the FXID-entryvalues of a specific fx from an FXStateChunk, which is the guid of the fx.

    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the fx
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the guid-entry
    integer fxid - the fx, whose guid you want to return
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, guid</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXGuid_FXStateChunk.GetFXWAK_FXStateChunk()", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXGuid_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXGuid_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local GUID=fx_lines:match("\n.-FXID (.-)\n")

  ultraschall.SuppressErrorMessages(false)
  return GUID
end

function ultraschall.GetWndRect_FXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetWndRect_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer x, integer y, integer width, integer height = ultraschall.GetWndRect_FXStateChunk(string FXStateChunk)</functioncall>
  <description>
    returns the WNDRECT-entryvalues from an FXStateChunk.
    
    These are the window-positions of the fx-chain, when the window is floating.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer x - the x-position of the floating window; 0, if it hasn't been floating yet
    integer y - the y-position of the floating window; 0, if it hasn't been floating yet
    integer width - the width of the floating window; 0, if it hasn't been floating yet
    integer height - the height of the floating window; 0, if it hasn't been floating yet
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, whose floating-window-position you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, wndrect, fxstatechunk, floating window position</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetWndRect_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  local WNDRect=FXStateChunk:match("\n.-WNDRECT (.-)\n")
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(WNDRect.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  
  return table.unpack(individual_values)
end



function ultraschall.GetShow_FXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetShow_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer showstate = ultraschall.GetShow_FXStateChunk(string FXStateChunk)</functioncall>
  <description>
    returns the SHOW-entryvalues from an FXStateChunk.
    
    This shows, whether the fxchain is currently shown and which fx is visible in Reaper's UI.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer shownstate - 0, the fx-chain is not shown; 1, first fx is shown; 2, second fx is shown, etc
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, whose show-state you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, showstate</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetShow_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  local Show=FXStateChunk:match("\n.-SHOW (.-)\n")
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(Show.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  
  return table.unpack(individual_values)
end

function ultraschall.GetLastSel_FXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastSel_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer last_selected_fx = ultraschall.GetLastSel_FXStateChunk(string FXStateChunk)</functioncall>
  <description>
    returns the LASTSEL-entryvalues from an FXStateChunk.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer last_selected_fx - the last selected fx; 1, the first fx; 2, the second fx; 3, the third fx
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, whose last-selected-fx you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, last selected fx</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetLastSel_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  local LASTSEL=FXStateChunk:match("\n.-LASTSEL (.-)\n")
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(LASTSEL.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  individual_values[1]=individual_values[1]+1
  return table.unpack(individual_values)
end

function ultraschall.GetDocked_FXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetDocked_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer dockstate = ultraschall.GetDocked_FXStateChunk(string FXStateChunk)</functioncall>
  <description>
    returns the DOCKED-entryvalues from an FXStateChunk.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer dockstate - 0, undocked; 1, docked
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, whose dockstate you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, dockstate</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetDocked_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  local GetDocked_FXStateChunk=FXStateChunk:match("\n.-DOCKED (.-)\n")
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(GetDocked_FXStateChunk.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  return table.unpack(individual_values)
end


function ultraschall.SetFXBypass_FXStateChunk(FXStateChunk, fx_id, bypass, online, unknown)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXBypass_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXBypass_FXStateChunk(string FXStateChunk, integer fxid, integer bypass, integer offline, integer unknown)</functioncall>
  <description>
    sets the fx-BYPASS-entry of a specific fx within an FXStateChunk, which allows setting online/offline and bypass-settings.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new BYPASS-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new bypass-state
    integer fxid - the fx, whose bypass-state you want to set
    integer bypass - 0, non-bypassed; 1, bypassed
    integer offline - 0, online; 1, offline
    integer unknown - unknown; default is 0
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, bypass, online/offline</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXBypass_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXBypass_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if math.type(bypass)~="integer" then ultraschall.AddErrorMessage("SetFXBypass_FXStateChunk", "bypass", "must be an integer", -3) return nil end
  if math.type(online)~="integer" then ultraschall.AddErrorMessage("SetFXBypass_FXStateChunk", "online", "must be an integer", -4) return nil end
  if math.type(unknown)~="integer" then ultraschall.AddErrorMessage("SetFXBypass_FXStateChunk", "unknown", "must be an integer", -5) return nil end
  
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  fx_lines=string.gsub(fx_lines, "BYPASS.-\n", "BYPASS "..bypass.." "..online.." "..unknown.."\n")
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end

function ultraschall.SetShow_FXStateChunk(FXStateChunk, showstate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetShow_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetShow_FXStateChunk(string FXStateChunk, integer showstate)</functioncall>
  <description>
    sets the shown-plugin of an FXStateChunk.
    
    It is the SHOW-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new SHOW-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new shown-fx-state
    integer showstate - the fx shown; 1, for the first fx; 2, for the second fx; etc
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, show fx</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetShow_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(showstate)~="integer" then ultraschall.AddErrorMessage("SetShow_FXStateChunk", "showstate", "must be an integer", -2) return nil end
  
  FXStateChunk=string.gsub(FXStateChunk, "\n    SHOW .-\n", "\n    SHOW "..showstate.."\n")
  return FXStateChunk
end

function ultraschall.SetWndRect_FXStateChunk(FXStateChunk, x, y, w, h)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetWndRect_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetWndRect_FXStateChunk(string FXStateChunk, integer x, integer y, integer w, integer h)</functioncall>
  <description>
    sets the docked-state of an FXStateChunk.
    
    It is the WNDRECT-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new WNDRECT-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new undocked-windowposition-state
    integer x - the x-position of the undocked window
    integer y - the y-position of the undocked window
    integer w - the width of the window-rectangle
    integer h - the height of the window-rectangle
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, last selected</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetWndRect_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("SetWndRect_FXStateChunk", "x", "must be an integer", -2) return nil end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("SetWndRect_FXStateChunk", "y", "must be an integer", -3) return nil end
  if math.type(w)~="integer" then ultraschall.AddErrorMessage("SetWndRect_FXStateChunk", "w", "must be an integer", -4) return nil end
  if math.type(h)~="integer" then ultraschall.AddErrorMessage("SetWndRect_FXStateChunk", "h", "must be an integer", -5) return nil end
  
  FXStateChunk=string.gsub(FXStateChunk, "\n    WNDRECT .-\n", "\n    WNDRECT "..x.." "..y.." "..w.." "..h.."\n")
  return FXStateChunk
end

function ultraschall.SetDocked_FXStateChunk(FXStateChunk, docked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetDocked_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetDocked_FXStateChunk(string FXStateChunk, integer docked)</functioncall>
  <description>
    sets the docked-state of an FXStateChunk.
    
    It is the DOCKED-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new DOCKED-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new last-selected-fx-state
    integer docked - the docked-state of the fx-chain-window; 0, undocked; 1, docked
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, docked</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetDocked_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(docked)~="integer" then ultraschall.AddErrorMessage("SetDocked_FXStateChunk", "docked", "must be an integer", -2) return nil end
  
  FXStateChunk=string.gsub(FXStateChunk, "\n    DOCKED .-\n", "\n    DOCKED "..docked.."\n")
  return FXStateChunk
end

function ultraschall.SetLastSel_FXStateChunk(FXStateChunk, lastsel)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetLastSel_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetLastSel_FXStateChunk(string FXStateChunk, integer lastsel)</functioncall>
  <description>
    sets the last selected-plugin of an FXStateChunk.
    
    It is the LASTSEL-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new LASTSEL-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new last-selected-fx-state
    integer lastsel - the last fx selected; 1, for the first fx; 2, for the second fx; etc
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, last selected</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetLastSel_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(lastsel)~="integer" then ultraschall.AddErrorMessage("SetLastSel_FXStateChunk", "lastsel", "must be an integer", -2) return nil end
  lastsel=lastsel-1
  
  FXStateChunk=string.gsub(FXStateChunk, "\n    LASTSEL .-\n", "\n    LASTSEL "..lastsel.."\n")
  return FXStateChunk
end

function ultraschall.SetFXGuid_FXStateChunk(FXStateChunk, floating, fx_id, guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXGuid_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXGuid_FXStateChunk(string FXStateChunk, integer fxid, string guid)</functioncall>
  <description>
    sets the fx-FXID-entry of a specific fx within an FXStateChunk, which holds the guid for this fx.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new BYPASS-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new gui
    integer fxid - the fx, whose guid you want to set
    string guid - a guid for this fx; use reaper.genGuid to create one
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, guid</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXGuid_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXGuid_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if type(guid)~="string" then ultraschall.AddErrorMessage("SetFXGuid_FXStateChunk", "guid", "must be a string", -3) return nil end
  if ultraschall.IsValidGuid(guid, true)==false then ultraschall.AddErrorMessage("SetFXGuid_FXStateChunk", "guid", "must be a valid guid; use reaper.genGuid to create one.", -4) return nil end
  
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  fx_lines=string.gsub(fx_lines, "FXID.-\n", "FXID "..guid.."\n")
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end

function ultraschall.SetFXFloatPos_FXStateChunk(FXStateChunk, fx_id, floating, x, y, w, h)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXFloatPos_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXFloatPos_FXStateChunk(string FXStateChunk, integer fxid, boolean floating, integer x, integer y, integer w, integer h)</functioncall>
  <description>
    sets the fx-FXID-entry of a specific fx within an FXStateChunk, which manages floatstate and position of the floating-fx-window.
    
    Note: when committing it to a track/item of an opened project, keep in mind that setting floating=false will have no effect.
    You will also need to commit a TrackStateChunk/ItemStateChunk twice, as in the first commit, w and h will be ignored if the fx isn't already floating.
    This is probably due a Reaper bug and I can't fix it in here, sorry.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new BYPASS-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new bypass-state
    integer fxid - the fx, whose bypass-state you want to set
    boolean floating - true, window is floating; false, window is not floating
    integer x - the x-position of the floating-window
    integer y - the y-position of the floating-window
    integer w - the width of the window(will be ignored, when committing changed statechunk only once to current project's track/item)
    integer h - the height of the window(will be ignored, when committing changed statechunk only once to current project's track/item) 
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, floatposition, x, y, w, g</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if type(floating)~="boolean" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "floating", "must be a boolean", -3) return nil end
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "x", "must be an integer", -4) return nil end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "y", "must be an integer", -5) return nil end
  if math.type(w)~="integer" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "w", "must be an integer", -6) return nil end
  if math.type(h)~="integer" then ultraschall.AddErrorMessage("SetFXFloatPos_FXStateChunk", "h", "must be an integer", -7) return nil end
  
  if floating==true then floating="" else floating="POS" end
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  fx_lines=string.gsub(fx_lines, "FLOAT.- .-\n", "FLOAT"..floating.." "..x.." "..y.." "..w.." "..h.."\n")
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end


function ultraschall.AddParmLearn_FXStateChunk2(FXStateChunk, fxid, parmidx, parmname, input_mode, channel, cc_note, cc_mode, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddParmLearn_FXStateChunk2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.AddParmLearn_FXStateChunk2(string FXStateChunk, integer fxid, integer parmidx, string parmname, integer input_mode, integer channel, integer cc_note, integer cc_mode, integer checkboxflags, optional string osc_message)</functioncall>
  <description>
    Adds a new Parm-Learn-entry to an FX-plugin from an FXStateChunk.
    Allows setting some values more detailed, unlike AddParmLearn_FXStateChunk.
    
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
    integer parmidx - the parameter, whose Parameter Learn you want to add; 0-based
    string parmname - the name of the parameter, usually \"\" or \"byp\" for bypass or \"wet\" for wet; when using wet or bypass, these are essential to give, otherwise just pass ""
    integer input_mode - the input mode of this ParmLearn-entry
                       - 0, OSC
                       - 1, MIDI Note
                       - 2, MIDI CC
                       - 3, MIDI PC
                       - 4, MIDI Pitch
    integer channel - the midi-channel used; 1-16
    integer cc_note - the midi/cc-note used; 0-127
    integer cc_mode - the cc-mode-dropdownlist
                    - 0, Absolute
                    - 1, Relative 1(127=-1, 1=+1)
                    - 2, Relative 2(63=-1, 65=+1)
                    - 3, Relative 3(65=-1, 1=+1)
                    - 4, Toggle (>0=toggle)
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
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "fxid", "must be an integer", -2) return false end

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "osc_message", "must be either nil or a string", -3) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "checkboxflags", "must be an integer", -4) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "parmidx", "must be an integer", -5) return false end
  if type(parmname)~="string" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "parmname", "must be a string, either \"\" or byp or wet", -6) return false 
  elseif parmname~="" then parmname=":"..parmname
  end
  if math.type(input_mode)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "input_mode", "must be an integer", -7) return false end  
  if math.type(channel)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "channel", "must be an integer", -8) return false end  
  if math.type(cc_note)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "cc_note", "must be an integer", -9) return false end  
  if math.type(cc_mode)~="integer" then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "cc_mode", "must be an integer", -10) return false end  
  if input_mode<0 or input_mode>4 then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "input_mode", "must be between 0 and 4", -11) return false end  
  if channel<1 or channel>16 then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "channel", "must be between 1 and 16", -12) return false end  
  if cc_note<0 or cc_note>127 then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "cc_note", "must be between 0 and 127", -13) return false end  
  if cc_mode<0 or cc_mode>4 then ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", "cc_mode", "must be between 1 and 4", -14) return false end  
  channel=channel-1
  if input_mode==0 then -- osc
    channel=0 
    cc_note=0 
  elseif input_mode==1 then 
    input_mode=144 -- midi note
  elseif input_mode==2 then
    input_mode=176 -- midi cc
  elseif input_mode==3 then
    input_mode=192 -- midi pc
  elseif input_mode==4 then
    input_mode=224 -- midi pitch
  else
  end
  if cc_mode==1 then cc_mode=65536
  elseif cc_mode==2 then cc_mode=131072
  elseif cc_mode==3 then cc_mode=65536+131072
  elseif cc_mode==4 then cc_mode=262144
  end
  input_mode=input_mode+channel
  input_mode=ultraschall.CombineBytesToInteger(0, input_mode, cc_note)
  input_mode=input_mode+cc_mode  
  local errorcounter_old = ultraschall.CountErrorMessages()  
  local A={ultraschall.AddParmLearn_FXStateChunk(FXStateChunk, fxid, parmidx, parmname, input_mode, checkboxflags, osc_message)}
  if errorcounter_old ~= ultraschall.CountErrorMessages() then
    local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage()
    ultraschall.AddErrorMessage("AddParmLearn_FXStateChunk2", parmname, errormessage, errcode-100)
    return false
  end
    
  return table.unpack(A)
end

function ultraschall.SetParmLearn_FXStateChunk2(FXStateChunk, fxid, parmidx, parmname, input_mode, channel, cc_note, cc_mode, checkboxflags, osc_message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmLearn_FXStateChunk2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string alteredFXStateChunk = ultraschall.SetParmLearn_FXStateChunk2(string FXStateChunk, integer fxid, integer parmidx, string parmname, integer input_mode, integer channel, integer cc_note, integer cc_mode, integer checkboxflags, optional string osc_message)</functioncall>
  <description>
    Sets an already existing Parm-Learn-entry of an FX-plugin from an FXStateChunk.
    Allows setting some values more detailed, unlike SetParmLearn_FXStateChunk.
    
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
    integer parmidx - the parameter, whose Parameter Learn you want to add; 0-based
    string parmname - the name of the parameter, usually \"\" or \"byp\" for bypass or \"wet\" for wet; when using wet or bypass, these are essential to give, otherwise just pass ""
    integer input_mode - the input mode of this ParmLearn-entry
                       - 0, OSC
                       - 1, MIDI Note
                       - 2, MIDI CC
                       - 3, MIDI PC
                       - 4, MIDI Pitch
    integer channel - the midi-channel used; 1-16
    integer cc_note - the midi/cc-note used; 0-127
    integer cc_mode - the cc-mode-dropdownlist
                    - 0, Absolute
                    - 1, Relative 1(127=-1, 1=+1)
                    - 2, Relative 2(63=-1, 65=+1)
                    - 3, Relative 3(65=-1, 1=+1)
                    - 4, Toggle (>0=toggle)
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
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "fxid", "must be an integer", -2) return false end

  if osc_message~=nil and type(osc_message)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "osc_message", "must be either nil or a string", -3) return false end
  if math.type(checkboxflags)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "checkboxflags", "must be an integer", -4) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "parmidx", "must be an integer", -5) return false end
  if type(parmname)~="string" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "parmname", "must be a string, either \"\" or byp or wet", -6) return false 
  elseif parmname~="" then parmname=":"..parmname
  end
  if math.type(input_mode)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "input_mode", "must be an integer", -7) return false end  
  if math.type(channel)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "channel", "must be an integer", -8) return false end  
  if math.type(cc_note)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "cc_note", "must be an integer", -9) return false end  
  if math.type(cc_mode)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "cc_mode", "must be an integer", -10) return false end  
  if input_mode<0 or input_mode>4 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "input_mode", "must be between 0 and 4", -11) return false end  
  if channel<1 or channel>16 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "channel", "must be between 1 and 16", -12) return false end  
  if cc_note<0 or cc_note>127 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "cc_note", "must be between 0 and 127", -13) return false end  
  if cc_mode<0 or cc_mode>4 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "cc_mode", "must be between 1 and 4", -14) return false end  
  if osc_message~=nil and input_mode~=0 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "input_mode", "must be set to 0, when using parameter osc_message", -15) return false end
  if osc_message==nil and input_mode==0 then ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", "osc_message", "osc-message missing", -16) return false end
  channel=channel-1
  if input_mode==0 then -- osc
    channel=0 
    cc_note=0 
  elseif input_mode==1 then 
    input_mode=144 -- midi note
  elseif input_mode==2 then
    input_mode=176 -- midi cc
  elseif input_mode==3 then
    input_mode=192 -- midi pc
  elseif input_mode==4 then
    input_mode=224 -- midi pitch
  else

  end
  if cc_mode==1 then cc_mode=65536
  elseif cc_mode==2 then cc_mode=131072
  elseif cc_mode==3 then cc_mode=65536+131072
  elseif cc_mode==4 then cc_mode=262144
  end
  input_mode=input_mode+channel
  input_mode=ultraschall.CombineBytesToInteger(0, input_mode, cc_note)
  input_mode=input_mode+cc_mode  
  local errorcounter_old = ultraschall.CountErrorMessages()
  local A={ultraschall.SetParmLearn_FXStateChunk(FXStateChunk, fxid, parmidx, input_mode, checkboxflags, osc_message )}
  if errorcounter_old ~= ultraschall.CountErrorMessages() then
    local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage()
    ultraschall.AddErrorMessage("SetParmLearn_FXStateChunk2", parmname, errormessage, errcode-100)
    return false
  end
    
  return table.unpack(A)
end

function ultraschall.GetParmLearn_FXStateChunk2(FXStateChunk, fxid, id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_FXStateChunk2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>integer parm_idx, string parmname, integer input_mode, integer channel, integer cc_note, integer checkboxflags, optional string osc_message = ultraschall.GetParmLearn_FXStateChunk2(string FXStateChunk, integer fxid, integer id)</functioncall>
  <description>
    Returns a parameter-learn-setting from an FXStateChunk
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem.
    
    Returns some values more detailed, unlike GetParmLearn_FXStateChunk.
    
    It is the PARMLEARN-entry
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_idx - the idx of the parameter; order is exactly like the order in the contextmenu of Parameter List -> Learn
    string parmname - the name of the parameter, though usually only "wet" or "byp" or ""
                    - to get the actual displayed parametername, you need to 
                    - use the reaper.TrackFX_GetParamName-function
    integer input_mode - the input mode of this ParmLearn-entry
                       - 0, OSC
                       - 1, MIDI Note
                       - 2, MIDI CC
                       - 3, MIDI PC
                       - 4, MIDI Pitch
    integer channel - the midi-channel used; 1-16
    integer cc_note - the midi/cc-note used; 0-127
    integer cc_mode - the cc-mode-dropdownlist
                    - 0, Absolute
                    - 1, Relative 1(127=-1, 1=+1)
                    - 2, Relative 2(63=-1, 65=+1)
                    - 3, Relative 3(65=-1, 1=+1)
                    - 4, Toggle (>0=toggle)
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
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk2", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk2", "id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk2", "fxid", "must be an integer", -3) return nil end
    
  local channel, input_mode
  local parm_idx, parmname, midi_note, checkboxflags, osc_message = ultraschall.GetParmLearn_FXStateChunk(FXStateChunk, fxid, id)
  if parm_idx==nil then ultraschall.AddErrorMessage("GetParmLearn_FXStateChunk2", "id", "no such ParmLearn available", -4) return nil end
  local Byte1, cc_note = ultraschall.SplitIntegerIntoBytes(midi_note)
  if Byte1>=224 then input_mode=4 channel=Byte1-224     -- MIDI Pitch
  elseif Byte1>=192 then input_mode=3 channel=Byte1-192 -- MIDI PC
  elseif Byte1>=176 then input_mode=2 channel=Byte1-176 -- MIDI CC
  elseif Byte1>=144 then input_mode=1 channel=Byte1-144 -- MIDI Note 
  else 
    input_mode=0 
    channel=-1
  end
  
  -- cc_mode
  local cc_mode
  channel=channel+1
  if     midi_note&65536==0     and midi_note&131072==0      and midi_note&262144==0 then -- Absolute
    cc_mode=0
  elseif midi_note&65536==65536 and midi_note&131072==0      and midi_note&262144==0 then -- Relative 1(127=-1, 1=+1)
    cc_mode=1
  elseif midi_note&65536==0     and midi_note&131072==131072 and midi_note&262144==0 then -- Relative 2(63=-1, 65=+1)
    cc_mode=2
  elseif midi_note&65536==65536 and midi_note&131072==131072 and midi_note&262144==0 then -- Relative 3(65=-1, 1=+1)
    cc_mode=3
  elseif midi_note&65536==0     and midi_note&131072==0      and midi_note&262144==262144 then -- Toggle (>0=toggle) 
    cc_mode=4
  end
  return parm_idx, parmname, input_mode, channel, cc_note, cc_mode, checkboxflags, osc_message
end

function ultraschall.GetParmLearnID_by_FXParam_FXStateChunk(FXStateChunk, fxid, param_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearnID_by_FXParam_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parmlearn_id, = ultraschall.GetParmLearnID_by_FXParam_FXStateChunk(string FXStateChunk, integer fxid, integer param_id)</functioncall>
  <description>
    Returns the parmlearn_id by parameter.

    This can be used as parameter parm_learn_id for Get/Set/DeleteParmLearn-functions
    
    Returns -1, if the parameter has no ParmLearn associated.
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parmlearn_id - the idx of the parmlearn, that you can use for Add/Get/Set/DeleteParmLearn-functions; -1, if parameter has no ParmLearn associated
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the parmlearn
    integer fxid - the fx, of which you want to get the parmlearn_id
    integer param_id - the parameter, whose parmlearn_id you want to get
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
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLearnID_by_FXParam_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(param_id)~="integer" then ultraschall.AddErrorMessage("GetParmLearnID_by_FXParam_FXStateChunk", "param_id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLearnID_by_FXParam_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLearnID_by_FXParam_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local name=""
  local idx, midi_note, checkboxes
  for w in string.gmatch(FXStateChunk, "PARMLEARN.-\n") do
    w=w:sub(1,-2).." " 
    idx = w:match(" (.-) ") 
    if tonumber(idx)==nil then 
      idx, name = w:match(" (.-):(.-) ")
    end
    
    if tonumber(idx)==param_id then 
      return count
    end
    count=count+1
  end
  return -1
end


function ultraschall.GetParmAliasID_by_FXParam_FXStateChunk(FXStateChunk, fxid, param_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmAliasID_by_FXParam_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parmalias_id, = ultraschall.GetParmAliasID_by_FXParam_FXStateChunk(string FXStateChunk, integer fxid, integer param_id)</functioncall>
  <description>
    Returns the parmalias_id by parameter.

    This can be used as parameter parm_alias_id for Get/Set/DeleteParmAlias-functions
    
    Returns -1, if the parameter has no ParmAlias associated.
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parmalias_id - the idx of the parmalias, that you can use for Add/Get/Set/DeleteParmAlias-functions; -1, if parameter has no ParmAlias associated
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the parmalias_id
    integer fxid - the fx, of which you want to get the parmalias_id
    integer param_id - the parameter, whose parmalias_id you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Alias
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, alias, fxstatechunk, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmAliasID_by_FXParam_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(param_id)~="integer" then ultraschall.AddErrorMessage("GetParmAliasID_by_FXParam_FXStateChunk", "param_id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmAliasID_by_FXParam_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmAliasID_by_FXParam_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local name=""
  local idx, midi_note, checkboxes
  for w in string.gmatch(FXStateChunk, "PARMALIAS.-\n") do
    w=w:sub(1,-2).." " 
    idx = w:match(" (.-) ") 
    if tonumber(idx)==nil then 
      idx, name = w:match(" (.-):(.-) ")
    end
    
    if tonumber(idx)==param_id then 
      return count
    end
    count=count+1
  end
  return -1
end


function ultraschall.GetParmLFOLearnID_by_FXParam_FXStateChunk(FXStateChunk, fxid, param_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLFOLearnID_by_FXParam_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer parm_lfolearn_id, = ultraschall.GetParmLFOLearnID_by_FXParam_FXStateChunk(string FXStateChunk, integer fxid, integer param_id)</functioncall>
  <description>
    Returns the parmlfolearn_id by parameter.

    This can be used as parameter parm_lfolearn_id for Get/Set/DeleteLFOLearn-functions
    
    Returns -1, if the parameter has no ParmLFOLearn associated.
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer parm_lfolearn_id - the idx of the parm_lfolearn, that you can use for Add/Get/Set/DeleteParmLFOLearn-functions; -1, if parameter has no ParmLFOLearn associated
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from which you want to retrieve the parm_lfolearn_id
    integer fxid - the fx, of which you want to get the parameter-lfo_learn-settings
    integer param_id - the parameter, whose parm_lfolearn_id you want to get
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping LFOLearn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, lfolearn, fxstatechunk, osc, midi</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetParmLFOLearnID_by_FXParam_FXStateChunk", "StateChunk", "Not a valid FXStateChunk", -1) return nil end
  if math.type(param_id)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearnID_by_FXParam_FXStateChunk", "param_id", "must be an integer", -2) return nil end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("GetParmLFOLearnID_by_FXParam_FXStateChunk", "fxid", "must be an integer", -3) return nil end
  if string.find(FXStateChunk, "\n  ")==nil then
    FXStateChunk=ultraschall.StateChunkLayouter(FXStateChunk)
  end
  FXStateChunk=ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if FXStateChunk==nil then ultraschall.AddErrorMessage("GetParmLFOLearnID_by_FXParam_FXStateChunk", "fxid", "no such fx", -4) return nil end
  local count=0
  local name=""
  local idx, midi_note, checkboxes
  for w in string.gmatch(FXStateChunk, "LFOLEARN.-\n") do
    w=w:sub(1,-2).." " 
    idx = w:match(" (.-) ") 
    if tonumber(idx)==nil then 
      idx, name = w:match(" (.-):(.-) ")
    end
    
    if tonumber(idx)==param_id then 
      return count
    end
    count=count+1
  end
  return -1
end

function ultraschall.GetParmLearn_Default()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParmLearn_Default</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>integer enable_state, boolean softtakeover, integer ccmode = ultraschall.GetParmLearn_Default()</functioncall>
  <description>
    allows getting the current default-settings for the parmlearn-dialog
  </description>
  <retvals>
    integer enable_state - the radiobuttons in the parmlearn-dialog
                         - 0, no option selected 
                         - 1, enable only when track or item is selected
                         - 2, enable only when effect configuration is focused
                         - 3, enable only when effect configuration is visible
    boolean softtakeover - true, set softtakeover checkbox checked; false, set softtakeover checkbox unchecked
    integer ccmode - the ccmode-dropdownlist
                   - 0, Absolute
                   - 1, Relative 1 (127=-1, 1=+1)
                   - 2, Relative 2 (63=-1, 65=+1)
                   - 3, Relative 3 (65=-1, 1=+1)
                   - 4, Toggle (>0=Toggle)
  </retvals>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, parameter, learn, default</tags>
</US_DocBloc>
]]
  local retval, checkbox=reaper.BR_Win32_GetPrivateProfileString("REAPER", "deflearnselonly", "0", reaper.get_ini_file())
  local retval, ccmode=reaper.BR_Win32_GetPrivateProfileString("REAPER", "deflearnccmode", "0", reaper.get_ini_file())
  local ccmode=tonumber(ccmode)
  local checkbox=tonumber(checkbox)
  local enable_state, softtakeover
  if checkbox&1==0 and checkbox&4==0 and checkbox&16==0 then
    enable_state=0
  elseif checkbox&1==1 and checkbox&4==0 and checkbox&16==0 then
    enable_state=1
  elseif checkbox&1==0 and checkbox&4==4 and checkbox&16==0 then
    enable_state=2
  elseif checkbox&1==0 and checkbox&4==4 and checkbox&16==16 then
    enable_state=3
  end
  
  softtakeover=checkbox&2==2
  
  return enable_state, softtakeover, ccmode
end

function ultraschall.SetParmLearn_Default(enable_state, softtakeover, ccmode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetParmLearn_Default</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetParmLearn_Default(integer enable_state, boolean softtakeover, integer ccmode)</functioncall>
  <description>
    allows setting the current default-settings for the parmlearn-dialog
    
    set to 0, false, 0 for the factory defaults
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer enable_state - the radiobuttons in the parmlearn-dialog
                         - 0, no option selected 
                         - 1, enable only when track or item is selected
                         - 2, enable only when effect configuration is focused
                         - 3, enable only when effect configuration is visible
    boolean softtakeover - true, set softtakeover checkbox checked; false, set softtakeover checkbox unchecked
    integer ccmode - the ccmode-dropdownlist
                   - 0, Absolute
                   - 1, Relative 1 (127=-1, 1=+1)
                   - 2, Relative 2 (63=-1, 65=+1)
                   - 3, Relative 3 (65=-1, 1=+1)
                   - 4, Toggle (>0=Toggle)
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, parameter, learn, default</tags>
</US_DocBloc>
]]
  if math.type(enable_state)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_Default", "enable_state", "Must be an integer", -1) return false end
  if type(softtakeover)~="boolean" then ultraschall.AddErrorMessage("SetParmLearn_Default", "softtakeover", "Must be a boolean", -2) return false end
  if math.type(ccmode)~="integer" then ultraschall.AddErrorMessage("SetParmLearn_Default", "ccmode", "Must be an integer", -3) return false end
  
  if enable_state<0 or enable_state>3 then ultraschall.AddErrorMessage("SetParmLearn_Default", "enable_state", "must be between 0 and 3", -4) return false end
  if ccmode<0 or ccmode>4 then ultraschall.AddErrorMessage("SetParmLearn_Default", "ccmode", "must be between 0 and 4", -5) return false end
  
  local checkbox=0
  if enable_state==1 then
    checkbox=checkbox+1
  elseif enable_state==2 then
    checkbox=checkbox+4
  elseif enable_state==3 then
    checkbox=checkbox+4+16
  end
  
  if softtakeover==true then
    checkbox=checkbox+2
  end
  
  local retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "deflearnselonly", checkbox, reaper.get_ini_file())
  local retval2 = reaper.BR_Win32_WritePrivateProfileString("REAPER", "deflearnccmode", ccmode, reaper.get_ini_file())  
  if retval==false then ultraschall.AddErrorMessage("SetParmLearn_Default", "", "could not set ini-file, is reaper.ini accessible?", -6) return false end
  if retval2==false then ultraschall.AddErrorMessage("SetParmLearn_Default", "", "could not set ini-file, is reaper.ini accessible?", -7) return false end
  return retval
end


function ultraschall.GetBatchConverter_FXStateChunk()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetBatchConverter_FXStateChunk</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.GetBatchConverter_FXStateChunk()</functioncall>
  <description>
    Returns the FXStateChunk stored and used by the BatchConverter.
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem or inputFX.
  </description>
  <retvals>
    string FXStateChunk - the FXStateChunk of the BatchConverter
  </retvals>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, fxstatechunk, batchconverter</tags>
</US_DocBloc>
]]
  local FXStateChunk=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-convertfx.ini")
  FXStateChunk=string.gsub(FXStateChunk, "\n", "\n  ")..">"
  return "<FXCHAIN\n  "..FXStateChunk:sub(1,-3)..">"
end

--A=ultraschall.GetBatchConverterFXStateChunk()

function ultraschall.SetBatchConverter_FXStateChunk(FXStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetBatchConverter_FXStateChunk</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string OldFXStateChunk = ultraschall.GetBatchConverter_FXStateChunk(string FXStateChunk)</functioncall>
  <description>
    Sets the FXStateChunk used by the BatchConverter. Returns the previously used FXStateChunk.
    
    The BatchConverter uses this FXStateChunk when it's opened the next time.
    So if you want to use different FXStateChunks with the BatchConverter, set it first, then (re-)open the BatchConverter.
    
    An FXStateChunk holds all FX-plugin-settings for a specific MediaTrack or MediaItem or inputFX.
    
    Returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    string FXStateChunk - the FXStateChunk of the BatchConverter
  </retvals>
  <parameters>
    string FXStateChunk - the new FXStateChunk to us with the BatchConverter
  </parameters>
  <chapter_context>
    FX-Management
    FXStateChunks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, set, fxstatechunk, batchconverter</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetBatchConverter_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return false end
  local OldFXStateChunk=ultraschall.GetBatchConverterFXStateChunk()
  FXStateChunk=string.gsub(FXStateChunk, "\n  ", "\n"):match(".-\n(.*)\n.->")

  local retval=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-convertfx.ini", FXStateChunk)
  return retval==1, OldFXStateChunk
end

--B,C=ultraschall.SetBatchConverterFXStateChunk(A)
--A=ultraschall.IsValidFXStateChunk()

function ultraschall.TrackFX_JSFX_Reload(track, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackFX_JSFX_Reload</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TrackFX_JSFX_Reload(MediaTrack track, integer fxindex)</functioncall>
  <description>
    Updates a jsfx in a track.
    
    if the desc-line in the jsfx changes, it will not update the name of the jsfx in the fx-chain-list
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, fx has been updated; false, fx has not been updated
  </retvals>
  <parameters>
    MediaTrack track - the track, whose jsfx you want to update
    integer fxindex - the index of the track-jsfx, that you want to refresh
  </parameters>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, update, jsfx, trackfx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("TrackFX_JSFX_Reload", "track", "must be a valid MediaTrack", -1) return false end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("TrackFX_JSFX_Reload", "fx_id", "must be an integer", -2) return false end
  fx_id=fx_id-1
  local Aretval, Abuf = reaper.TrackFX_GetFXName(track, fx_id)
  if Abuf:sub(1,4)~="JS: " then ultraschall.AddErrorMessage("TrackFX_JSFX_Reload", "fx_id", "fx is not jsfx-fx", -3) return false end
  local Aretval2, Abuf2 = reaper.TrackFX_GetNamedConfigParm(track, fx_id, "fx_ident")
  reaper.PreventUIRefresh(1)
  local retval = reaper.TrackFX_Delete(track, fx_id)
  local count=reaper.TrackFX_GetCount(track)
  local retval = reaper.TrackFX_AddByName(track, Abuf2, false, 1)
  reaper.TrackFX_CopyToTrack(track, count, track, fx_id, true)
  reaper.PreventUIRefresh(-1)
  return true
end

--A,B=ultraschall.TrackFX_JSFX_Reload(reaper.GetTrack(0,0), 1)

function ultraschall.TakeFX_JSFX_Reload(take, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TakeFX_JSFX_Reload</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TakeFX_JSFX_Reload(MediaItem_take take, integer fxindex)</functioncall>
  <description>
    Updates a jsfx in a take.
    
    if the desc-line in the jsfx changes, it will not update the name of the jsfx in the fx-chain-list
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, fx has been updated; false, fx has not been updated
  </retvals>
  <parameters>
    MediaItem_take - the take, whose jsfx you want to update
    integer fxindex - the index of the take-jsfx, that you want to refresh
  </parameters>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, update, jsfx, takefx</tags>
</US_DocBloc>
]]
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("TakeFX_JSFX_Reload", "track", "must be a valid MediaTrack", -1) return false end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("TakeFX_JSFX_Reload", "fx_id", "must be an integer", -2) return false end
  fx_id=fx_id-1
  local Aretval, Abuf = reaper.TakeFX_GetFXName(take, fx_id)
  if Abuf:sub(1,4)~="JS: " then ultraschall.AddErrorMessage("TakeFX_JSFX_Reload", "fx_id", "fx is not jsfx-fx", -3) return false end
  local Aretval2, Abuf2 = reaper.TakeFX_GetNamedConfigParm(take, fx_id, "fx_ident")
  reaper.PreventUIRefresh(1)
  local retval = reaper.TakeFX_Delete(take, fx_id)
  local count=reaper.TakeFX_GetCount(take)
  local retval = reaper.TakeFX_AddByName(take, Abuf2, 1)
  reaper.TakeFX_CopyToTake(take, count, take, fx_id, true)
  reaper.PreventUIRefresh(-1)
  return true
end

--item=reaper.GetMediaItem(0,0)
--take=reaper.GetMediaItemTake(item, 0)
--A=ultraschall.TakeFX_JSFX_Reload(take, 1)


function ultraschall.InputFX_JSFX_Reload(track, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InputFX_JSFX_Reload</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.InputFX_JSFX_Reload(MediaTrack track, integer fxindex)</functioncall>
  <description>
    Updates a jsfx in monitoring-fx/rec-input-fx
    
    if the desc-line in the jsfx changes, it will not update the name of the jsfx in the fx-chain-list
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, fx has been updated; false, fx has not been updated
  </retvals>
  <parameters>
    MediaTrack track - the track, whose rec-inputfx-jsfx you want to update; use master track to update within input-monitoring-fx 
    integer fxindex - the index of the track-jsfx, that you want to refresh
  </parameters>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, update, jsfx, monitoring fx, rec input fx</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("InputFX_JSFX_Reload", "track", "must be a valid MediaTrack", -1) return false end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("InputFX_JSFX_Reload", "fx_id", "must be an integer", -2) return false end
  fx_id=fx_id-1
  local Aretval, Abuf = reaper.TrackFX_GetFXName(track, fx_id|0x1000000)
  if Abuf:sub(1,4)~="JS: " then ultraschall.AddErrorMessage("InputFX_JSFX_Reload", "fx_id", "fx is not jsfx-fx", -3) return false end
  local Aretval2, Abuf2 = reaper.TrackFX_GetNamedConfigParm(track, fx_id|0x1000000, "fx_ident")
  reaper.PreventUIRefresh(1)
  local retval = reaper.TrackFX_Delete(track, fx_id|0x1000000)
  local count=reaper.TrackFX_GetRecCount(track)
  local retval = reaper.TrackFX_AddByName(track, Abuf2, true, 1)
  reaper.TrackFX_CopyToTrack(track, count|0x1000000, track, fx_id|0x1000000, true)
  reaper.PreventUIRefresh(-1)
  return true
end


--A,B=ultraschall.InputFX_JSFX_Reload(reaper.GetTrack(0,0), 1)


function ultraschall.GetGuidFromCustomMarkerID(markername, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromCustomMarkerID</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromCustomMarkerID(string markername, integer index)</functioncall>
  <description>
    Gets the corresponding guid of a custom marker with a specific index 
    
    The index is for _custom:-markers only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the custom marker with a specific index
  </retvals>
  <parameters>
    string markername - the name of the custom-marker
    integer index - the index of the custom marker, whose guid you want to retrieve; 0-based
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromCustomMarkerID", "idx", "must be an integer", -1) return end
  if type(markername)~="string" then ultraschall.AddErrorMessage("GetGuidFromCustomMarkerID", "markername", "must be a string", -2) return end

  local retval, marker_index, pos, name, shown_number, color, guid2 = ultraschall.EnumerateCustomMarkers(markername, idx)
  return guid2
end

--A={ultraschall.GetGuidFromCustomMarkerID("Planned", 0)}

--A=ultraschall.GetGuidFromShownoteMarkerID(1)
--B={ultraschall.EnumerateShownoteMarkers(1)}
--SLEM()

function ultraschall.GetGuidFromCustomRegionID(regionname, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromCustomRegionID</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromCustomRegionID(string regionname, integer index)</functioncall>
  <description>
    Gets the corresponding guid of a custom region with a specific index 
    
    The index is for _custom:-regions only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the custom region with a specific index
  </retvals>
  <parameters>
    string regionname - the name of the custom-region
    integer index - the index of the custom region, whose guid you want to retrieve; 0-based
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom region, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromCustomRegionID", "idx", "must be an integer", -1) return end
  if type(markername)~="string" then ultraschall.AddErrorMessage("GetGuidFromCustomRegionID", "regionname", "must be a string", -2) return end

  local retval, marker_index, pos, length, name, shown_number, color, guid2 = ultraschall.EnumerateCustomRegions(regionname, idx)
  return guid2
end

--A=ultraschall.GetGuidFromCustomRegionID("Time", 0)

function ultraschall.GetCustomMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCustomMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, string custom_marker_name = ultraschall.GetCustomMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a custom-marker-guid
    
    The index is for all _custom:-markers only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the custom-marker, whose guid you have passed to this function; 0-based
    string custom_marker_name - the name of the custom-marker
  </retvals>
  <parameters>
    string guid - the guid of the custom-marker, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetCustomMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end  
  local marker_id = ultraschall.GetMarkerIDFromGuid(guid)
  local A,A,A,rgn_end,name=reaper.EnumProjectMarkers(marker_id-1)
  name=name:match("_(.-):")
  if name==nil or rgn_end>0 then ultraschall.AddErrorMessage("GetCustomMarkerIDFromGuid", "guid", "not a custom-marker", -2) return -1 end  

  for idx=0, ultraschall.CountAllCustomMarkers(name) do
    ultraschall.SuppressErrorMessages(true)
    local retval, marker_index, pos, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomMarkers(name, idx)
    if guid2==guid then ultraschall.SuppressErrorMessages(false) return idx, name end
  end
  ultraschall.SuppressErrorMessages(false)
  return -1
end

--B,C=ultraschall.GetCustomMarkerIDFromGuid("{E4C95832-0E52-4164-A879-9AED86D5A66C}")

function ultraschall.GetCustomRegionIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCustomRegionIDFromGuid</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, string custom_region_name = ultraschall.GetCustomRegionIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a custom-region-guid
    
    The index is for all _custom:-regions only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the custom-region, whose guid you have passed to this function; 0-based
    string custom_region_name - the name of the region-marker
  </retvals>
  <parameters>
    string guid - the guid of the custom-region, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom region, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetCustomRegionIDFromGuid", "guid", "must be a string", -1) return -1 end  
  local marker_id = ultraschall.GetMarkerIDFromGuid(guid)
  local A,A,A,rgn_end,name=reaper.EnumProjectMarkers(marker_id-1)
  name=name:match("_(.-):")
  if name==nil or rgn_end==0 then ultraschall.AddErrorMessage("GetCustomRegionIDFromGuid", "guid", "not a custom-region", -2) return -1 end  

  for idx=0, ultraschall.CountAllCustomRegions(name) do
    ultraschall.SuppressErrorMessages(true)
    local retval, marker_index, pos, length, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomRegions(name, idx)
    if guid2==guid then ultraschall.SuppressErrorMessages(false) return idx, name end
  end
  ultraschall.SuppressErrorMessages(false)
  return -1
end

--B,C=ultraschall.GetCustomRegionIDFromGuid("{84144A00-96EA-4AC6-ACB2-D2B0EEEB3CEB}")

function ultraschall.TakeFX_GetAllGuidsFromAllTakes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TakeFX_GetAllGuidsFromAllTakes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>table found_guids = ultraschall.TakeFX_GetAllGuidsFromAllTakes()</functioncall>
  <description>
    Returns all Guids from all Take-FX of all takes in a project
    
    Returned table is of the following format:
      Guids[guid_index]["take"] - the take, that contains the fx with the guid
      Guids[guid_index]["fx_index"] - the index of the fx in the take-fx-chain
      Guids[guid_index]["guid"] - the guid of the found take-fx
  </description>
  <retvals>
    table found_guids - the found guids of all take-fx in the project
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, all guids, guid, takefx</tags>
</US_DocBloc>
]]
  local Guids={}
  for i=0, reaper.CountMediaItems(0)-1 do
    for a=0, reaper.GetMediaItemNumTakes(reaper.GetMediaItem(0,i))-1 do
      local take=reaper.GetMediaItemTake(reaper.GetMediaItem(0,i), a)
      for b=0, reaper.TakeFX_GetCount(take)-1 do
        Guids[#Guids+1]={}
        Guids[#Guids]["guid"]=reaper.TakeFX_GetFXGUID(take, b)
        Guids[#Guids]["take"]=take
        Guids[#Guids]["fx_index"]=b
      end
    end
  end
  return Guids
end

--A=ultraschall.TakeFX_GetAllGuidsFromAllTakes()

function ultraschall.TrackFX_GetAllGuidsFromAllTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TrackFX_GetAllGuidsFromAllTracks</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>table found_guids = ultraschall.TrackFX_GetAllGuidsFromAllTracks()</functioncall>
  <description>
    Returns all Guids from all Track-FX of all tracks in a project
    
    Returned table is of the following format:
      Guids[guid_index]["track"] - the track, that contains the fx with the guid
      Guids[guid_index]["fx_index"] - the index of the fx in the track-fx-chain
      Guids[guid_index]["guid"] - the guid of the found track-fx
  </description>
  <retvals>
    table found_guids - the found guids of all track-fx in the project
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, all guids, guid, trackfx</tags>
</US_DocBloc>
]]
  local Guids={}
  track=reaper.GetMasterTrack(0)
  for a=0, reaper.TrackFX_GetCount(track)-1 do
    Guids[#Guids+1]={}
    Guids[#Guids]["guid"]=reaper.TrackFX_GetFXGUID(track, a)
    Guids[#Guids]["track"]=track
    Guids[#Guids]["fx_index"]=a
  end
  
  for i=0, reaper.CountTracks(0)-1 do
    track=reaper.GetTrack(0,i)
    for a=0, reaper.TrackFX_GetCount(track)-1 do
      Guids[#Guids+1]={}
      Guids[#Guids]["guid"]=reaper.TrackFX_GetFXGUID(track, a)
      Guids[#Guids]["track"]=track
      Guids[#Guids]["fx_index"]=a
    end
  end
  return Guids
end

--A=ultraschall.TrackFX_GetAllGuidsFromAllTracks()

function ultraschall.GetFXByGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXByGuid</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>table found_fx = ultraschall.GetFXByGuid()</functioncall>
  <description>
    Returns the fx-index and track/take object of an FX by guid.
    
    Returned table is of the following format:
      Guids[guid_index]["track"] - the track, that contains the fx with the guid, if the fx in question is trackfx, else nil
      Guids[guid_index]["take"] - the take, that contains the fx with the guid, if the fx in question is takefx, else nil
      Guids[guid_index]["fx_index"] - the index of the fx in the fx-chain of either the take or track-fx-chain
  </description>
  <retvals>
    table found_fx - the found fx with guid
  </retvals>
  <chapter_context>
    FX-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fxmanagement, get, fx, guid, trackfx</tags>
</US_DocBloc>
]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetFXByGuid", "guid", "must be a string", -1) return nil end
  if ultraschall.IsValidGuid(guid, true)==false then ultraschall.AddErrorMessage("GetFXByGuid", "guid", "must be a valid guid", -2) return nil end
  local retval
  local FoundGuids={}
  local Guids=ultraschall.TrackFX_GetAllGuidsFromAllTracks()
  for i=1, #Guids do
    if guid==Guids[i]["guid"] then
      FoundGuids[#FoundGuids+1]={}
      FoundGuids[#FoundGuids]["fx_index"]=Guids[i]["fx_index"]
      FoundGuids[#FoundGuids]["track"]=Guids[i]["track"]
    end
  end
  local Guids2=ultraschall.TakeFX_GetAllGuidsFromAllTakes()
  for i=1, #Guids2 do
    if guid==Guids2[i]["guid"] then
      FoundGuids[#FoundGuids+1]={}
      FoundGuids[#FoundGuids]["fx_index"]=Guids2[i]["fx_index"]
      FoundGuids[#FoundGuids]["take"]=Guids2[i]["take"]
      retval, FoundGuids[#FoundGuids]["name"]=reaper.TakeFX_GetFXName(Guids2[i]["take"], Guids2[i]["fx_index"])
    end
  end
  return FoundGuids
end

function ultraschall.SetFXAutoBypassSettings(reduce_cpu, autobypass_when_fx_open, disable_autobypass_when_offline, auto_bypass_report_tail, auto_bypass_report_tail_thresh)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXAutoBypassSettings</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetFXAutoBypassSettings(boolean reduce_cpu, boolean autobypass_when_fx_open, boolean disable_autobypass_when_offline, boolean auto_bypass_report_tail, integer auto_bypass_report_tail_thresh)</functioncall>
  <description>
    Sets states of various autobypass-settings.
    
    Returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    boolean reduce_cpu - true, reduce CPU use of silent tracks during playback; false, don't reduce cpu use of silent tracks during playback
    boolean autobypass_when_fx_open - true, Auto-bypass FX (when set via project or manual setting) even when FX configuration is open; false, don't auto-bypass fx
    boolean disable_autobypass_when_offline - true, Disable FX auto-bypass when using offline render/apply FX/render stems; false, don't disable FX auto-bypass when using offline render/apply FX/render stems
    boolean auto_bypass_report_tail - true, Auto-bypass FX that report tail length or have auto-tail set; false, don't auto-bypass FX that report tail length or have auto-tail set
    integer auto_bypass_report_tail_thresh - Auto-bypass FX that report tail length or have auto-tail set, threshold in dB; always negative
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, autobypass</tags>
</US_DocBloc>
]]  
  if type(reduce_cpu)~="boolean" then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "reduce_cpu", "must be a boolean", -1) return false end
  if type(autobypass_when_fx_open)~="boolean" then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "autobypass_when_fx_open", "must be a boolean", -2) return false end
  if type(disable_autobypass_when_offline)~="boolean" then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "disable_autobypass_when_offline", "must be a boolean", -3) return false end
  if type(auto_bypass_report_tail)~="boolean" then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "auto_bypass_report_tail", "must be a boolean", -4) return false end
  if math.type(auto_bypass_report_tail_thresh)~="integer" then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "auto_bypass_report_tail_thresh", "must be a boolean", -5) return false end
  if auto_bypass_report_tail_thresh>0 then ultraschall.AddErrorMessage("SetFXAutoBypassSettings", "auto_bypass_report_tail_thresh", "must be a negative value", -6) return false end
  
  local configvar=0
  local configvar2=0
  if reduce_cpu==true then configvar=configvar+1 end
  if autobypass_when_fx_open==true then configvar=configvar+4 end
  if disable_autobypass_when_offline==true then configvar=configvar+8 end
  reaper.SNM_SetIntConfigVar("optimizesilence", configvar)
  
  if auto_bypass_report_tail==true then configvar2=configvar2+1 end
  reaper.SNM_SetIntConfigVar("silenceflags", configvar2)
  
  reaper.SNM_SetIntConfigVar("silencethreshdb", auto_bypass_report_tail_thresh)
  return true
end

--A=ultraschall.SetAutoBypassSettings(true, true, false)
--SLEM()
function ultraschall.GetFXAutoBypassSettings()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXAutoBypassSettings</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean reduce_cpu, boolean autobypass_when_fx_open, boolean disable_autobypass_when_offline = ultraschall.GetFXAutoBypassSettings()</functioncall>
  <description>
    Gets states of various autobypass-settings, as set in Preferences-> Audio and Preferences -> Rendering as well as in Project Settings -> Advanced Tab
  </description>
  <retvals>
    boolean reduce_cpu - true, reduce CPU use of silent tracks during playback; false, don't reduce cpu use of silent tracks during playback
    boolean autobypass_when_fx_open - true, Auto-bypass FX (when set via project or manual setting) even when FX configuration is open; false, don't auto-bypass fx
    boolean disable_autobypass_when_offline - true, Disable FX auto-bypass when using offline render/apply FX/render stems; false, don't disable FX auto-bypass when using offline render/apply FX/render stems
    boolean auto_bypass_report_tail - true, Auto-bypass FX that report tail length or have auto-tail set; false, don't auto-bypass FX that report tail length or have auto-tail set
    integer auto_bypass_report_tail_thresh - Auto-bypass FX that report tail length or have auto-tail set, threshold in dB; always negative
  </retvals>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, autobypass</tags>
</US_DocBloc>
]]  
  local configvar=reaper.SNM_GetIntConfigVar("optimizesilence", -1)
  local configvar2=reaper.SNM_GetIntConfigVar("silenceflags", -1)
  local configvar3=reaper.SNM_GetIntConfigVar("silencethreshdb", -1)
  return configvar&1==1, configvar&4==4, configvar&8==8, configvar2&1==1, configvar3
end

--A,B,C=ultraschall.GetAutoBypassSettings()

function ultraschall.GetFXAutoBypass_FXStateChunk(FXStateChunk, fx_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetFXAutoBypass_FXStateChunk</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    Lua=5.3
  </requires>
  <functioncall>integer state = ultraschall.GetFXAutoBypass_FXStateChunk(string FXStateChunk, integer fxid)</functioncall>
  <description>
    Gets the state of autobypass of an FX within an FXStateChunk.
    
    It is the AUTOBYPASS-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    integer state - 0, autobypass is disabled; 1, autobypass is enabled
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, from whose fx you want to return the autobypass-state
    integer fxid - the fx, whose autobypass-state you want to retrieve
  </parameters>
  <chapter_context>
    FX-Management
    Get States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, get, fx, autobypass</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("GetFXAutoBypass_FXStateChunk.GetFXWAK_FXStateChunk()", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("GetFXAutoBypass_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  ultraschall.SuppressErrorMessages(true)
  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)
  if fx_lines==nil then ultraschall.SuppressErrorMessages(false) ultraschall.AddErrorMessage("GetFXAutoBypass_FXStateChunk", "fx_id", "no such fx", -4) return nil end
  local AutoBypass=fx_lines:match("\n.-AUTOBYPASS (.-)\n")
  if AutoBypass==nil then return 0 end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(AutoBypass.." ", " ")
  for i=1, count do
    individual_values[i]=tonumber(individual_values[i])
  end
  ultraschall.SuppressErrorMessages(false)
  return table.unpack(individual_values)
end

function ultraschall.SetFXAutoBypass_FXStateChunk(FXStateChunk, fx_id, newstate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetFXAutoBypass_FXStateChunk</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.71
    Lua=5.3
  </requires>
  <functioncall>string FXStateChunk = ultraschall.SetFXAutoBypass_FXStateChunk(string FXStateChunk, integer fxid, integer newstate)</functioncall>
  <description>
    Sets the autobypass-state of an fx within an FXStateChunk
    
    It is the AUTOBYPASS-entry.
    
    Keep in mind, when passing 0, the AUTOBYPASS-entry disappears. This is normal.
    
    returns nil in case of an error
  </description>
  <retvals>
    string FXStateChunk - the altered FXStateChunk with the new AUTOBYPASS-state
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, into which you want to set the new bypass-state
    integer fxid - the fx, whose bypass-state you want to set
    integer newstate - 1, autobypass enabled; 0, autobypass disabled
  </parameters>
  <chapter_context>
    FX-Management
    Set States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, set, fx, autobypass</tags>
</US_DocBloc>
]]

  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("SetFXAutoBypass_FXStateChunk", "FXStateChunk", "must be a valid FXStateChunk", -1) return nil end
  if math.type(fx_id)~="integer" then ultraschall.AddErrorMessage("SetFXAutoBypass_FXStateChunk", "fx_id", "must be an integer", -2) return nil end
  if math.type(newstate)~="integer" then ultraschall.AddErrorMessage("SetFXAutoBypass_FXStateChunk", "newstate", "must be a boolean", -3) return nil end

  local fx_lines, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fx_id)

  local newpass
  if newstate==0 then newpass="" else newpass="   AUTOBYPASS "..newstate.."\n " end

  fx_lines=string.gsub(fx_lines, "    AUTOBYPASS.-\n", "")
  local insertoffset=fx_lines:match(".-WAK.-\n()")  
  
  fx_lines=fx_lines:sub(1,insertoffset)..newpass..fx_lines:sub(insertoffset+1, -1)
  --print_update(fx_lines)
  FXStateChunk=FXStateChunk:sub(1, startoffset-1)..fx_lines..FXStateChunk:sub(endoffset, -1)
  return FXStateChunk
end
