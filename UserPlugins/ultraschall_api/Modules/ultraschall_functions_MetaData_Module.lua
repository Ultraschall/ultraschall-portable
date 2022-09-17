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
---        MetaData Module        ---
-------------------------------------


function ultraschall.DeleteProjExtState_Section(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteProjExtState_Section</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeleteProjExtState_Section(string section)</functioncall>
  <description>
    Deletes all key/values from a specific section.
    
    Returns -1 in case of an error.
  </description>
  <parameters>
    string section - the section/extname, whose key/values shall be deleted
  </parameters>
  <retvals>
    integer retval - 0, in case of success; -1, in case of an error
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadatamanagement, project, delete, extension, state, section</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("DeleteProjExtState_Section","section", "must be a string", -1) return -1 end
  if reaper.EnumProjExtState(0, section, 0)==false then ultraschall.AddErrorMessage("DeleteProjExtState_Section","section", "no key/values to delete", -2) return -1 end
  return reaper.SetProjExtState(0, section, "", "")
end

function ultraschall.DeleteProjExtState_Key(section, key)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteProjExtState_Key</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeleteProjExtState_Key(string section, section key)</functioncall>
  <description>
    Deletes the value from a specific section -> key.
    
    Returns -1 in case of an error.
  </description>
  <parameters>
    string section - the section/extname, from whom a key/value shall be deleted
    string key - the key, whose value shall be deleted
  </parameters>
  <retvals>
    integer retval - 0, in case of success; -1, in case of an error
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadatamanagement, project, delete, extension, state, key</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("DeleteProjExtState_Key","section", "must be a string", -1) return -1 end
  if type(key)~="string" then ultraschall.AddErrorMessage("DeleteProjExtState_Key","key", "must be a string", -1) return -2 end
  if reaper.GetProjExtState(0, section, key)==0 then ultraschall.AddErrorMessage("DeleteProjExtState_Key","key", "no such key/value to delete", -3) return -1 end
  return reaper.SetProjExtState(0, section, key, "")
end

function ultraschall.GetProjExtState_AllKeyValues(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjExtState_AllKeyValues</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetProjExtState_AllKeyValues(string section)</functioncall>
  <description>
    Returns the count of all key/values in a specific section, as well as an array with all keynames and their accompanying stored values.
    The array has the format:
       AllValues[idx][1]=Key
       AllValues[idx][2]=Value
    
    Returns -1 in case of an error or if no key exists in the given section
  </description>
  <parameters>
    string section - the section/extname, from whom a key/value shall be deleted
  </parameters>
  <retvals>
    integer retval - 0, in case of success; -1, in case of an error
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadatamanagement, project, extension, state, get, all, key, values, section</tags>
</US_DocBloc>
--]]

  if type(section)~="string" then ultraschall.AddErrorMessage("GetProjExtState_AllKeyValues","section", "must be a string", -1) return -1 end
  if reaper.EnumProjExtState(0, section, 0)==false then ultraschall.AddErrorMessage("GetProjExtState_AllKeyValues","section", "no such section", -2) return -1 end
  local retval=true
  local count=0
  local ProjExtStateArray={}
  local _L, keyname
  
  while retval~=false do
    retval, keyname=reaper.EnumProjExtState(0, section, count)
    if retval==true then 
          ProjExtStateArray[count+1]={}
          ProjExtStateArray[count+1][1]=keyname
      _L, ProjExtStateArray[count+1][2]=reaper.GetProjExtState(0, section, keyname)
    end
    count=count+1
  end
  return count-1, ProjExtStateArray
end

--LL=ultraschall.GetProjExtState_AllKeyValues(2)



function ultraschall.GetGuidExtState(guid, key, savelocation)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, string value = ultraschall.GetGuidExtState(string guid, string key, integer savelocation)</functioncall>
  <description>
    Gets an extension-state using a given guid. Good for storing additional metadata of objects like MediaTracks, MediaItems, MediaItem_Takes, etc(everything, that has a guid).
    The guid can have additional text, but must contain a valid guid somewhere in it!
    A valid guid is a string that follows the following pattern:
    {........-....-....-....-............}
    where . is a hexadecimal value(0-F)
    
    Returns -1 in case of error
  </description>
  <parameters>
    string guid - the guid of the object, for whom you want to get the key/value-pair; can have additional characters before and after the guid, but must contain a valid guid!
    string key - the key for this guid
    integer savelocation - 0, get as project extension state(from the currently opened project); 1, get as global extension state(when persist=true, from reaper-extstate.ini in the resourcesfolder)
  </parameters>
  <retvals>
    integer retval - the idx of the extstate(if a project extension state); 1, successful(with extension states), -1, unsuccessful
    string value - the returned value from the extstate
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States Guid
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadatamanagement, project, extension, state, get, guid, key, values</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidGuid(guid, false)==false then ultraschall.AddErrorMessage("GetGuidExtState","guid", "must be a valid guid", -1) return -1 end
  if type(key)~="string" then ultraschall.AddErrorMessage("GetGuidExtState","key", "must be a string", -2) return -1 end
  if math.type(savelocation)~="integer" then ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "must be an integer", -4) return -1 end
  if tonumber(savelocation)~=0 and tonumber(savelocation)~=1 then ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "only allowed 0 for project-extstate, 1 for global extension state", -5) return -1 end
  
  if savelocation==0 then 
    local retval, string=reaper.GetProjExtState(0, guid, key)
    if retval>0 then return 1, string else return -1 end
  elseif savelocation==1 then 
    return 1, reaper.GetExtState(guid, key, value, persist)
  else 
    ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "no such location", -6) return -1
  end
end

function ultraschall.SetGuidExtState(guid, key, value, savelocation, overwrite, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetGuidExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetGuidExtState(string guid, string key, string value, integer savelocation, boolean overwrite, boolean persists)</functioncall>
  <description>
    Sets an extension-state using a given guid. Good for storing additional metadata of objects like MediaTracks, MediaItems, MediaItem_Takes, etc(everything, that has a guid).
    The state can be saved as either global extension state or "local" extension-project-state(in the currently opened project)
    The guid can have additional text, but must contain a valid guid somewhere in it!
    A valid guid is a string that follows the following pattern:
    {........-....-....-....-............}
    where . is a hexadecimal value(0-F)
    
    Returns -1 in case of error
  </description>
  <parameters>
    string guid - the guid of the object, for whom you want to store a key/value-pair; can have additional characters before and after the guid, but must contain a valid guid!
    string key - the key for this guid; "", deletes all keys+values stored with this marker
    string value - the value to store into the key/value-store; "", deletes the value for this key
    integer savelocation - 0, store as project extension state(into the currently opened project); 1, store as global extension state(when persist=true, into reaper-extstate.ini in the resourcesfolder)
    boolean overwrite - true, overwrite a previous given value; false, don't overwrite, if a value exists already
    boolean persists - true, make extension state persistent(available after Reaper-restart); false, don't make it persistent; Only with global extension states
  </parameters>
  <retvals>
    integer retval - the idx of the extstate(if a project extension state); >=1 number of stored extension states(means successful), -1, unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States Guid
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>metadatamanagement, project, extension, state, set, guid, key, values</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidGuid(guid, false)==false then ultraschall.AddErrorMessage("SetGuidExtState","guid", "must be a valid guid", -1) return -1 end
  if type(key)~="string" then ultraschall.AddErrorMessage("SetGuidExtState","key", "must be a string", -2) return -1 end
  if type(value)~="string" then ultraschall.AddErrorMessage("SetGuidExtState","value", "must be a string", -3) return -1 end
  if type(overwrite)~="boolean" then ultraschall.AddErrorMessage("SetGuidExtState","overwrite", "must be a boolean", -4) return -1 end
  if math.type(savelocation)~="integer" then ultraschall.AddErrorMessage("SetGuidExtState","savelocation", "must be an integer", -5) return -1 end
  if tonumber(savelocation)~=0 and tonumber(savelocation)~=1 then ultraschall.AddErrorMessage("SetGuidExtState","savelocation", "only allowed 0 for project-extstate, 1 for global extension state", -6) return -1 end
  if savelocation==1 and type(persist)~="boolean" then ultraschall.AddErrorMessage("SetGuidExtState","persist", "must be a boolean", -7) return -1 end
  
  if savelocation==0 then 
    if overwrite==false and reaper.GetProjExtState(0, guid, key)>0 then ultraschall.AddErrorMessage("SetGuidExtState","extension-state", "already exist", -8) return -1 end
    --print(guid, key, value:len())
    return reaper.SetProjExtState(0, guid, key, value) 
  elseif savelocation==1 then 
    if overwrite==false and reaper.HasExtState(guid, key)==true then ultraschall.AddErrorMessage("SetGuidExtState","extension-state", "already exist", -9) return -1 end    
    return 1, reaper.SetExtState(guid, key, value, persist)
  else ultraschall.AddErrorMessage("SetGuidExtState","savelocation", "no such location", -9) return -1
  end
end


function ultraschall.SetItemExtState(item, key, value, overwrite)

    if reaper.ValidatePtr2(0, item, "MediaItem*")==false then ultraschall.AddErrorMessage("SetItemExtState","item", "Must be a valid MediaItem!", -1) return false end
    if type(key)~="string" then ultraschall.AddErrorMessage("SetItemExtState","key", "Must be a string!", -2) return false end
    if type(value)~="string" then ultraschall.AddErrorMessage("SetItemExtState","value", "Must be a string!", -3) return false end
    if type(overwrite)~="boolean" then ultraschall.AddErrorMessage("SetItemExtState","overwrite", "Must be a boolean!", -4) return false end
    local guidString = reaper.BR_GetMediaItemGUID(item)
    local retval = ultraschall.SetGuidExtState("MediaItem-"..guidString, key, value, 0, overwrite, false)
    if retval==-1 then return false else return true end
end

function ultraschall.GetItemExtState(item, key)

    if reaper.ValidatePtr2(0, item, "MediaItem*")==false then ultraschall.AddErrorMessage("GetItemExtState","item", "Must be a valid MediaItem!", -1) return false end
    if type(key)~="string" then ultraschall.AddErrorMessage("GetItemExtState","key", "Must be a string!", -2) return false end
    local guidString = reaper.BR_GetMediaItemGUID(item)
    local retval, retval2 = ultraschall.GetGuidExtState("MediaItem-"..guidString, key, 0)
    if retval==-1 then return false else return true, retval2 end
end


function ultraschall.SetTrackExtState(track, key, value, overwrite)

    if reaper.ValidatePtr2(0, track, "MediaTrack*")==false then ultraschall.AddErrorMessage("SetTrackExtState","track", "Must be a valid MediaTrack!", -1) return false end
    if type(key)~="string" then ultraschall.AddErrorMessage("SetTrackExtState","key", "Must be a string!", -2) return false end
    if type(value)~="string" then ultraschall.AddErrorMessage("SetTrackExtState","value", "Must be a string!", -3) return false end
    if type(overwrite)~="boolean" then ultraschall.AddErrorMessage("SetTrackExtState","overwrite", "Must be a boolean!", -4) return false end
    local guidString = reaper.GetTrackGUID(track)
    local retval = ultraschall.SetGuidExtState("MediaTrack-"..guidString, key, value, 0, overwrite, false)
    if retval==-1 then return false else return true end
end

function ultraschall.GetTrackExtState(track, key)

    if reaper.ValidatePtr2(0, track, "MediaTrack*")==false then ultraschall.AddErrorMessage("GetTrackExtState","track", "Must be a valid MediaTrack!", -1) return false end
    if type(key)~="string" then ultraschall.AddErrorMessage("GetTrackExtState","key", "Must be a string!", -2) return false end
    local guidString = reaper.GetTrackGUID(track)
    local retval, retval2 = ultraschall.GetGuidExtState("MediaTrack-"..guidString, key, 0)
    if retval==-1 then return false else return true, retval2 end
end

function ultraschall.SetMarkerExtState(index, key, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetMarkerExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetMarkerExtState(integer index, string key, string value)</functioncall>
  <description>
    Stores an Extstate for a specific marker/region.
    
    The index is for all markers and regions, inclusive and 1-based
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of an error; >=1 number of stored extension states(means successful), -1, unsuccessful
  </retvals>
  <parameters>
    integer index - the marker/region-index, for which to store an extstate; starting with 1 for first marker/region, 2 for second marker/region
    string key - the key, into which the marker-extstate shall be stored; "", deletes all keys+values stored with this marker
    string value - the value, which you want to store into the marker-extstate; "", deletes the value for this key
  </parameters>
  <chapter_context>
    Metadata Management
    Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>extstate management, marker, region, set, extstate</tags>
</US_DocBloc>
--]]
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("SetMarkerExtState", "index", "must be an integer", -1) return -1 end
  if index<1 or index>reaper.CountProjectMarkers(0) then ultraschall.AddErrorMessage("SetMarkerExtState", "index", "must be between 1 and "..reaper.CountProjectMarkers(0), -2) return -1 end
  if type(key)~="string" then ultraschall.AddErrorMessage("SetMarkerExtState", "key", "must be a string", -3) return -1 end
  if type(value)~="string" then ultraschall.AddErrorMessage("SetMarkerExtState", "value", "must be a string", -4) return -1 end
  local A,B=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..(index-1), 1, false)
  return ultraschall.SetGuidExtState("MarkerExtState_"..B, key, value, 0, true, true)
end

--A1,B1,C1=ultraschall.SetMarkerExtState(2, "Keyt", "marker 2")
--SLEM()

function ultraschall.GetMarkerExtState(index, key)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string value = ultraschall.GetMarkerExtState(integer index, string key)</functioncall>
  <description>
    Retrieves an Extstate for a specific marker/region.
    
    The index is for all markers and regions, inclusive and 1-based
    
    returns nil in case of an error
  </description>
  <retvals>
    string value - the value, that has been stored into the marker-extstate; nil, in case of an error
  </retvals>
  <parameters>
    integer index - the marker/region-index, for which an extstate has been stored; starting with 1 for first marker/region, 2 for second marker/region
    string key - the key, in which the marker-extstate is stored
  </parameters>
  <chapter_context>
    Metadata Management
    Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>extstate management, marker, region, get, extstate</tags>
</US_DocBloc>
--]]
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetMarkerExtState", "index", "must be an integer", -1) return end
  if index<1 or index>reaper.CountProjectMarkers(0) then ultraschall.AddErrorMessage("GetMarkerExtState", "index", "must be between 1 and "..reaper.CountProjectMarkers(0), -2) return end
  if type(key)~="string" then ultraschall.AddErrorMessage("GetMarkerExtState", "key", "must be a string", -3) return end
  local A,B=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..(index-1), 1, false)
  local A1,B1=ultraschall.GetGuidExtState("MarkerExtState_"..B, key, 0, true)
  return B1
end

--A1,B1,C1=ultraschall.GetMarkerExtState(2, "Keyt", "123")


function ultraschall.ProjExtState_CountAllKeys(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ProjExtState_CountAllKeys</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.ProjExtState_CountAllKeys(string section)</functioncall>
  <description>
    Counts all keys stored within a certain ProjExtState-section.
    
    Be aware: if you want to enumerate them using reaper.EnumProjExtState, the first key is indexed 0, the second 1, etc!
    
    returns -1 in case of an error 
  </description>
  <parameters>
    string section - the section, of which you want to count all keys
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Extension States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadate management, projextstate, project, extstate, count</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("ProjExtState_CountAllKeys", "section", "must be a string", -1) return -1 end
  local dingo=1
  local stringer
  while dingo~=0 do
    stringer=reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")
    dingo=reaper.GetProjExtState(0, section, stringer)
  end
  
  return reaper.SetProjExtState(0, section, stringer, "")
end  


function ultraschall.Metadata_ID3_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_ID3_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.34
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_ID3_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored ID3-metadata-tag into the current project(for Wav or MP3).
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    Note: APIC_TYPE allows only specific values, as listed below!
    
    Supported tags are:
      TIT2 - Title
      TIT3 - Subtitle/Description
      TPE2 - Album Artist
      TPE1 - Artist
      TCON - Genre
      TKEY - Key      
      TBPM - Tempo
      TYER - Year, must be of the format yyyy, like 2020
      TIME - Recording Time, like 22:15 or 08:21
      COMM - Comment
      TXXX - User defined(description=value)
      TXXX:REAPER - Media Explorer Tags
      TXXX:TIME_REFERENCE - Start Offset
      TCOM - Composer
      TIPL - Involved People
      TEXT - Lyricist/Text Writer
      TMCL - Musician Credits
      TALB - Album
      TRCK - Track
      TIT1 - Content Group
      TPOS - Part Number
      TRCK - Track number
      TSRC - International Standard Recording Code
      TCOP - Copyright Message
      COMM_LANG - Comment language, 3-character code like "eng"
      APIC_TYPE - the type of the cover-image, which can be of the following:
      
        "", unset
        0, Other
        1, 32x32 pixel file icon (PNG only)
        2, Other file icon
        3, Cover (front)
        4, Cover (back)
        5, Leaflet page
        6, Media
        7, Lead artist/Lead Performer/Solo
        8, Artist/Performer
        9, Conductor
        10, Band/Orchestra
        11, Composer
        12, Lyricist/Text writer
        13, Recording location
        14, During recording
        15, During performance
        16, Movie/video screen capture
        17, A bright colored fish
        18, Illustration
        19, Band/Artist logotype
        20, Publisher/Studiotype
    
    APIC_DESC - the description of the cover-image
    APIC_FILE - the filename+absolute path of the cover-image; must be either png or jpg
    
    Note: Chapters are added via marker with the name: "CHAP=chaptername"
    
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported ID3-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, id3, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  Tag=Tag:upper()
  if Value~="" then
    if Tag=="TYER" and Value:match("^|%d%d%d%d$")==nil then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Value", "TYER: must be of the following format yyyy like 2020", -3) return end
    if Tag=="TDRC" and (Value:match("^|%d%d%d%d%-%d%d%-%d%d$")==nil and Value:match("^|%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d$")==nil) then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Value", "TDRC: must be of the following format yyyy-mm-dd or yyyy-mm-ddThh-mm like 2020-06-27 or 2020-06-27T23:30", -4) return end
    if Tag=="COMM_LANG" and Value:len()~=4 then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Value", "COMM_LANG: must be a 3-character code like \"eng\"", -5) return end
    if Tag=="APIC_FILE" then
      local fileformat = ultraschall.CheckForValidFileFormats(Value)
      if fileformat~="PNG" and fileformat~="JPG" then ultraschall.AddErrorMessage("Metadata_ID3_GetSet", "Value", "APIC_FILE: must be either a jpg or a png-file", -6) return end
    end
  end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:"..Tag:upper()..Value, set)
  return b
end

--A=ultraschall.Metadata_ID3_GetSet("APIC_TYPE", "1")

function ultraschall.Metadata_BWF_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_BWF_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_BWF_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored BWF-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      Description
      OriginationDate
      OriginationTime
      Originator
      OriginatorReference
      ISRC - International Standard Recording Code
      
      Note: TimeReference is set by Reaper itself
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported BWF-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, bwf, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_BWF_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_BWF_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "BWF:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_IXML_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_IXML_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_IXML_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored IXML-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      PROJECT - title
      NOTE - comment
      USER - user-defined "Name=Value"
      USER:REAPER - Media Explorer Tags
      SCENE - Scene
      CIRCLED - Circled Take; either TRUE or FALSE
      TAPE - Sound Roll
      TAKE - Take ID
      FILE_UID - unique identifier for the file
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported IXML-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, ixml, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_IXML_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_IXML_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  if Tag:upper()=="CIRCLED" and Value:upper()~="|TRUE" and Value:upper()~="|FALSE" then 
    ultraschall.AddErrorMessage("Metadata_IXML_GetSet", "Value", "CIRCLED: must be either TRUE or FALSE", -3) return 
  elseif Tag:upper()=="CIRCLED" and (Value:upper()=="|TRUE" or Value:upper()=="|FALSE") then
    Value=Value:upper()
  end

  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "IXML:"..Tag:upper()..Value, set)
  return b
end

function ultraschall.Metadata_INFO_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_INFO_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_INFO_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored INFO-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      INAM - Title
      ISBJ - Description
      IKEY - Keywords
      IART - Artist
      IGNR - Genre
      ICRD - Creation Date, must be of the format yyyy-mm-dd like 2020-06-27
      ICMT - Comment
      IENG - Engineer
      IPRD - Product(Album)
      ISRC - Source
      ICOP - Copyright message
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported INFO-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, info, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_INFO_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_INFO_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end

  if Tag=="ICRD" and Value~="" then
    if Value:match("%d%d%d%d%-%d%d%-%d%d")==nil then
      ultraschall.AddErrorMessage("Metadata_INFO_GetSet", "Value", "ICRD: must be of the format \"yyyy-mm-dd\" like \"2020-06-27\"", -3) return 
    end
  end

  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "INFO:"..Tag:upper()..Value, set)
  return b
end

--A=ultraschall.Metadata_INFO_GetSet("ICRD", "2020-06-27")

function ultraschall.Metadata_CART_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_CART_GetSet</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_CART_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored CART-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      Title - Title
      Artist - the Artist
      Category - the genre
      StartDate - the start-date, must be of the following format, yyyy-mm-dd, like 2020-06-27
      EndDate - the end-date, must be of the following format, yyyy-mm-dd, like 2020-06-27
      TagText - Text
      URL - URL
      ClientID - Client
      CutID - Cut
      
    Note: INT1 is set by the INT1 marker; SEG1 is set by the SEG1-marker
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported CART-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, cart, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_CART_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_CART_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end

  if Tag=="StartDate" and Value~="" then
    if Value:match("%d%d%d%d%-%d%d%-%d%d")==nil then
      ultraschall.AddErrorMessage("Metadata_CART_GetSet", "Value", "StartDate: must be of the format \"yyyy-mm-dd\" like \"2020-06-27\"", -3) return 
    end
  end
  if Tag=="EndDate" and Value~="" then
    if Value:match("%d%d%d%d%-%d%d%-%d%d")==nil then
      ultraschall.AddErrorMessage("Metadata_CART_GetSet", "Value", "EndDate: must be of the format \"yyyy-mm-dd\" like \"2020-06-27\"", -4) return 
    end
  end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "CART:"..Tag..Value, set)
  return b
end

--A=ultraschall.Metadata_CART_GetSet("EndDate", "2020-06-27")

function ultraschall.Metadata_AIFF_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_AIFF_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_AIFF_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored AIFF-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
        NAME - Title
        ANNO - Description
        AUTH - Artist
        COPY - Copyright message
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported AIFF-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, aiff, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_AIFF_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_AIFF_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end

  if Tag=="StartDate" and Value~="" then
    if Value:match("%d%d%d%d%-%d%d%-%d%d")==nil then
      ultraschall.AddErrorMessage("Metadata_AIFF_GetSet", "Value", "StartDate: must be of the format \"yyyy-mm-dd\" like \"2020-06-27\"", -3) return 
    end
  end
  if Tag=="EndDate" and Value~="" then
    if Value:match("%d%d%d%d%-%d%d%-%d%d")==nil then
      ultraschall.AddErrorMessage("Metadata_AIFF_GetSet", "Value", "EndDate: must be of the format \"yyyy-mm-dd\" like \"2020-06-27\"", -4) return 
    end
  end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "IFF:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_XMP_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_XMP_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_XMP_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored XMP-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
        dc/title - title
        dc/description - description
        dm/artist - the artist
        dm/genre - the genre
        dm/key - the key
        dm/tempo - the tempo
        dm/timeSignature - the time-signature
        dc/date - the date
        dm/logComment - Comment
        dm/composer - the composer
        dc/creator - the creator
        dm/engineer - the engineer
        dm/album - the album
        dm/scene - the scene
        dm/copyright - the copyright message
        dc/language - the language
        
      
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported XMP-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, xmp, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_XMP_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_XMP_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "XMP:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_VORBIS_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_VORBIS_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_VORBIS_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored VORBIS-metadata-tag into the current project.
    This is for OPUS and OGG-VORBIS-files.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      TITLE - title
      DESCRIPTION - description
      ALBUMARTIST - album artist
      ARTIST - artist
      PERFORMER - performer
      GENRE - genre
      KEY - key
      BPM - tempo
      DATE - date
      COMMENT - comment
      USER - user defined (Name=Value)
      REAPER - Media Explorer Tags
      ARRANGER - arranger
      AUTHOR - author
      COMPOSER - composer
      CONDUCTOR - conductor
      ENSEMBLE - ensemble
      LYRICIST - lyricist
      PRODUCER - producer
      PUBLISHER - publisher
      ALBUM - album
      LABEL - label
      DISCNUMBER - disc number
      OPUS - number of work
      PART - part
      PARTNUMBER - partnumber
      TRACKNUMBER - tracknumber
      VERSION - version
      EAN/UPN - barcode
      LABELNO - catalog number
      ISRC - isrc
      COPYRIGHT - copyright holder
      LICENSE - license
      ENCODED-BY - encoded by
      ENCODING - encoding settings
      LANGUAGE - language, 3-character-code like "eng"
      LOCATION - location
      SOURCEMEDIA - original recording media
      
      
      Note: Chapters are added via marker with the name: "CHAP=chaptername"
    
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported VORBIS-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, vorbis, metadata, tags, tag, opus, ogg</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_VORBIS_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_VORBIS_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  Tag=Tag:upper()
  if Value~="" then
    if Tag=="DATE" and Value:match("^|%d%d%d%d%-%d%d%-%d%d$")==nil then ultraschall.AddErrorMessage("Metadata_VORBIS_GetSet", "Value", "DATE: must be of the following format yyyy-mm-dd or yyyy-mm-ddThh-mm like 2020-06-27 or 2020-06-27T23:30", -3) return end
  end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "VORBIS:"..Tag:upper()..Value, set)
  return b
end

--A=ultraschall.Metadata_VORBIS_GetSet("DATE", "2020-00-000")

function ultraschall.Metadata_CUE_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_CUE_GetSet</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_CUE_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored CUE-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
      DISC_TITLE - the title
      DISC_PERFORMER - the performer
      DISC_REM - Comment
      DISC_SONGWRITER - the songwriter      
      DISC_CATALOG - UPC/EAN Code of the disc

      
    Note: TRACK_TITLE is added via render-settings, 
          TRACK_PERFORMER is added via a marker with a title of PERF=performername
          TRACK_SONGWRITER is added via a marker with a title of WRIT=writername
          TRACK_ISRC is added via a marker with a title of ISRC=code
    
    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported CUE-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, cue, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_CUE_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_CUE_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  Tag=Tag:upper()
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "CUE:"..Tag:upper()..Value, set)
  return b
end


function ultraschall.Metadata_APE_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_APE_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_APE_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored APE-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    General:
    Title - Title
    Subtitle - Description
    Comment - Comment

    Artist:
    Artist - Artist

    Date:
    Record Date - Date
    Year - Date

    Musical:
    Genre - Genre
    Key - Key
    BPM - Tempo

    Personnel:
    Composer - Composer
    Conductor - Conductor
    Publisher - Publisher

    Project:
    Album - Album

    Parts:
    Track - Track Number

    Reaper:
    REAPER - Media Explorer Tags

    User:
    User Defined - User Defined

    Code:
    ISRC - ISRC
    Catalog - Catalog

    License:
    Copyright - Copyright Holder

    Technical:
    Language - Language
    Record Location - Recording Location

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported APE-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, ape, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_APE_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_APE_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "APE:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_ASWG_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_ASWG_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_ASWG_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored ASWG-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    General:
    project - Title
    session - Description
    notes - Comment

    Artist:
    artist - Artist

    Musical:
    genre - Genre
    instrument - Instrument
    intensity - Intensity
    inKey - Key
    isLoop - Loop
    subGenre - Sub-Genre
    tempo - Tempo
    timeSig - Time Signature

    Performance:
    text - Transcript
    actorGender - Actor Gender
    actorName - Actor Name
    characterAge - Character Age
    characterGender - Character Gender
    characterName - Character Name
    characterRole - Character Role
    efforts - Dialogue Contains Efforts
    effortType - Dialogue Effort Type
    emotion - Dialogue Emotion
    accent - Dialogue Regional Accent
    timingRestriction - Dialogue Timing Restriction
    director - Director
    direction - Director's Notes

    Personnel:
    composer - Composer
    creatorId - Creator
    editor - Editor
    recEngineer - Engineer
    mixer - Mixer
    musicSup - Music Supervisor
    producer - Producer
    musicPublisher - Publisher
    isCinematic - Cinematic
    contentType - Content Type
    isFinal - Final
    isOst - Original
    originator - Originator
    originatorStudio - Originator Studio
    recStudio - Recording Studio
    songTitle - Song Title
    isSource - Source
    musicVersion - Version

    Part:
    orderRef - Part Number

    Code:
    isrcId - ISRC
    billingCode - Billing Code

    Licensed:
    isLicensed - License
    rightsOwner - Rights Owner
    isUnion - Union Contract
    usageRights - Usage Rights

    Technical:
    ambisonicChnOrder - Ambisonic Channel Order
    ambisonicFormat - Ambisonic Format
    ambisonicNorm - Ambisonic Normalization Method
    zeroCrossRate - Average Zero Cross Rate
    channelConfig - Channel Layout Text
    isDesigned - Designed Or Raw
    isDiegetic - Diegetic
    state - File State
    category - FX Category
    catId - FX Category ID
    fxChainName - FX Chain Name
    fxName - FX Name
    subCategory - FX Sub-Category
    fxUsed - FX Used
    language - Language
    loudnessRange - LRA Loudness Range
    loudness - LUFS-I Integrated Loudness
    maxPeak - Maximum Peak Value dBFS
    micConfig - Microphone Configuration
    micDistance - Microphone Distance
    micType - Microphone Type
    papr - Peak To Average Power Ratio
    impulseLocation - Recording Location
    recordingLoc - Recording Location
    rmsPower - RMS Power
    library - Sound Effects Library
    sourceId - Source ID
    specDensity - Spectral Density
    userCategory - User Category
    userData - User Data
    vendorCategory - Vendor Category

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported ASWG-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, aswg, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_ASWG_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_ASWG_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ASWG:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_AXML_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_AXML_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_AXML_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored ASWG-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    Code:
    ISRC - the ISRC-code

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported AXML-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, axml, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_AXML_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_AXML_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "AXML:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_CAFINFO_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_CAFINFO_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_CAFINFO_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored CAFINFO-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    General:
    title - Title
    comments - Comment

    Artist:
    artist - Artist

    Date:
    year - Date
    recorded date - Recording Time

    Musical:
    genre - Genre
    key signature - Key
    tempo - Tempo
    time signature - Time Signature

    Personnel:
    composer - Composer
    lyricist - Lyricist

    Project:
    album - Album

    Parts:
    track number - Track Number

    License:
    copyright - Copyright Message

    Technical:
    nominal bit rate - Bit Rate
    channel configuration - Channel Configuration
    channel layout - Channel Layout Text
    encoding application - Encoded By
    source encoder - Encoding Settings

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported CAFINFO-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, cafinfo, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_CAFINFO_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_CAFINFO_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "CAFINFO:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_FLACPIC_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_FLACPIC_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.26
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_FLACPIC_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored FLACPIC-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    Binary:
    APIC_TYPE - Image Type
    APIC_DESC - Image Description
    APIC_FILE - Image File

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported FLACPIC-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, flacpic, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_FLACPIC_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_FLACPIC_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "FLACPIC:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_IFF_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_IFF_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_IFF_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored IFF-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    General:
    NAME - Title
    ANNO - Description

    Artist:
    AUTH - Artist

    License:
    COPY - Copyright Message

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported IFF-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, iff, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_IFF_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_IFF_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "IFF:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_WAVEXT_GetSet(Tag, Value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_WAVEXT_GetSet</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_WAVEXT_GetSet(string Tag, optional string Value)</functioncall>
  <description>
    Gets/Sets a stored WAVEXT-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
    
    Technical:
    channel configuration - Channel Configuration

    Returns nil in case of an error
  </description>
  <retvals>
    string value - the value of the specific tag
  </retvals>
  <parameters>
    string Tag - the tag, whose value you want to get/set; see description for a list of supported WAVEXT-Tags
    optional string Value - nil, only get the current value; any other value, set the value
  </parameters>
  <chapter_context>
    Metadata Management
    Tags
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, set, wavext, metadata, tags, tag</tags>
</US_DocBloc>
]]
  if ultraschall.type(Tag)~="string" then ultraschall.AddErrorMessage("Metadata_WAVEXT_GetSet", "Tag", "must be a string", -1) return end
  if Value~=nil and ultraschall.type(Value)~="string" then ultraschall.AddErrorMessage("Metadata_WAVEXT_GetSet", "Value", "must be a string", -2) return end
  if Value==nil then Value="" set=false else Value="|"..Value set=true end
  
  local a,b=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "WAVEXT:"..Tag..Value, set)
  return b
end

function ultraschall.Metadata_GetMetaDataTable_Presets(name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_GetMetaDataTable_Presets</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table MetaDataTable = ultraschall.Metadata_GetMetaDataTable_Presets(string PresetName)</functioncall>
  <description>
    returns a table with all metadata from a metadata-preset.
    
    Metadata that is not set in the preset, will be set to "" in the table
    
    returns nil in case of an error of if reaper-metadata.ini isn't found in resource-folder
  </description>
  <parameters>
    string PresetName - the name of the preset, whose metadata you want
  </parameters>
  <retvals>
    table MetaDataTable - a table with all metadata-entries from a preset. Unset entries in the preset will be set to ""
  </retvals>
  <chapter_context>
    Metadata Management
    Reaper Metadata Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, metadata preset, metadata</tags>
</US_DocBloc>
]]
  if type(name)~="string" then ultraschall.AddErrorMessage("Metadata_GetMetaDataTable_Presets", "name", "must be a string", -1) return end
  local File=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-metadata.ini")
  if File==nil then ultraschall.AddErrorMessage("Metadata_GetAllPresetNames", "", "Could not retrieve metadata-presets: reaper-metadata.ini is missing in resourcefolder", -2) return end
  local Tags=""
  local MetaDataTable={}
  local count
  for name_found, k in string.gmatch(File, "<METADATA (.-)\n(.-)\n>") do
    if name==string.gsub(name_found, "\"", "") then Tags=k.."\n" end
  end

  --APE
  MetaDataTable["APE:Album"]=Tags:match("TAG APE:Album (.-)\n") or ""
  MetaDataTable["APE:Artist"]=Tags:match("TAG APE:Artist (.-)\n") or ""
  MetaDataTable["APE:Catalog"]=Tags:match("TAG APE:BPM (.-)\n") or ""
  MetaDataTable["APE:BPM"]=Tags:match("TAG APE:Catalog (.-)\n") or ""
  MetaDataTable["APE:Comment"]=Tags:match("TAG APE:Comment (.-)\n") or ""
  MetaDataTable["APE:Composer"]=Tags:match("TAG APE:Composer (.-)\n") or ""
  MetaDataTable["APE:Conductor"]=Tags:match("TAG APE:Conductor (.-)\n") or ""
  MetaDataTable["APE:Copyright"]=Tags:match("TAG APE:Copyright (.-)\n") or ""
  MetaDataTable["APE:Genre"]=Tags:match("TAG APE:Genre (.-)\n") or ""
  MetaDataTable["APE:ISRC"]=Tags:match("TAG APE:ISRC (.-)\n") or ""
  MetaDataTable["APE:Key"]=Tags:match("TAG APE:Key (.-)\n") or ""
  MetaDataTable["APE:Language"]=Tags:match("TAG APE:Language (.-)\n") or ""
  MetaDataTable["APE:Publisher"]=Tags:match("TAG APE:Publisher (.-)\n") or ""
  MetaDataTable["APE:REAPER"]=Tags:match("TAG APE:REAPER (.-)\n") or ""
  MetaDataTable["APE:Record Date"]=Tags:match("TAG \"APE:Record Date\" (.-)\n") or ""
  MetaDataTable["APE:Record Location"]=Tags:match("TAG \"APE:Record Location\" (.-)\n") or ""
  MetaDataTable["APE:Subtitle"]=Tags:match("TAG APE:Subtitle (.-)\n") or ""
  MetaDataTable["APE:Title"]=Tags:match("TAG APE:Title (.-)\n") or ""
  MetaDataTable["APE:Track"]=Tags:match("TAG APE:Track (.-)\n") or ""
  MetaDataTable["APE:Year"]=Tags:match("TAG APE:Year (.-)\n") or ""
  count=0
  for k, v in string.gmatch(Tags, "  TAG \"APE:User Defined:(.-)\" (.-)\n") do
    count=count+1
    if k:sub(1,1)=="\"" then k=k:sub(2,-2) end
    if v:sub(1,1)=="\"" then v=v:sub(2,-2) end
    MetaDataTable["APE:User Defined:"..count]={}
    MetaDataTable["APE:User Defined:"..count]["key"]=k
    MetaDataTable["APE:User Defined:"..count]["value"]=v
  end

  -- AXML
  MetaDataTable["AXML:ISRC"]=Tags:match("TAG AXML:ISRC (.-)\n") or ""
  
  -- BWF
  MetaDataTable["BWF:Description"]=Tags:match("TAG BWF:Description (.-)\n") or ""  
  MetaDataTable["BWF:OriginationDate"]=Tags:match("TAG BWF:OriginationDate (.-)\n") or ""  
  MetaDataTable["BWF:OriginationTime"]=Tags:match("TAG BWF:OriginationTime (.-)\n") or ""  
  MetaDataTable["BWF:Originator"]=Tags:match("TAG BWF:Originator (.-)\n") or ""  
  MetaDataTable["BWF:OriginatorReference"]=Tags:match("TAG BWF:OriginatorReference (.-)\n") or ""  
  
  -- CART
  MetaDataTable["CART:Artist"]=Tags:match("TAG CART:Artist (.-)\n") or ""  
  MetaDataTable["CART:Category"]=Tags:match("TAG CART:Category (.-)\n") or ""  
  MetaDataTable["CART:ClientID"]=Tags:match("TAG CART:ClientID (.-)\n") or ""  
  MetaDataTable["CART:CutID"]=Tags:match("TAG CART:CutID (.-)\n") or ""  
  MetaDataTable["CART:EndDate"]=Tags:match("TAG CART:EndDate (.-)\n") or ""  
  MetaDataTable["CART:StartDate"]=Tags:match("TAG CART:StartDate (.-)\n") or ""  
  MetaDataTable["CART:TagText"]=Tags:match("TAG CART:TagText (.-)\n") or ""  
  MetaDataTable["CART:Title"]=Tags:match("TAG CART:Title (.-)\n") or ""  
  MetaDataTable["CART:URL"]=Tags:match("TAG CART:URL (.-)\n") or ""  

  -- Cue
  MetaDataTable["CUE:DISC_CATALOG"]=Tags:match("TAG CUE:DISC_CATALOG (.-)\n") or ""  
  MetaDataTable["CUE:DISC_PERFORMER"]=Tags:match("TAG CUE:DISC_PERFORMER (.-)\n") or ""  
  MetaDataTable["CUE:DISC_REM"]=Tags:match("TAG CUE:DISC_REM (.-)\n") or ""  
  MetaDataTable["CUE:DISC_SONGWRITER"]=Tags:match("TAG CUE:DISC_SONGWRITER (.-)\n") or ""  
  MetaDataTable["CUE:DISC_TITLE"]=Tags:match("TAG CUE:DISC_TITLE (.-)\n") or ""  
  MetaDataTable["CUE:INDEX"]=Tags:match("TAG CUE:INDEX (.-)\n") or ""  
  
  -- FlacPic
  MetaDataTable["FLACPIC:APIC_DESC"]=Tags:match("TAG FLACPIC:APIC_DESC (.-)\n") or ""  
  MetaDataTable["FLACPIC:APIC_FILE"]=Tags:match("TAG FLACPIC:APIC_FILE (.-)\n") or ""  
  MetaDataTable["FLACPIC:APIC_TYPE"]=Tags:match("TAG FLACPIC:APIC_TYPE (.-)\n") or ""  
  
  -- ID3-MP3
  MetaDataTable["ID3:APIC_DESC"]=Tags:match("TAG ID3:APIC_DESC (.-)\n") or ""
  MetaDataTable["ID3:APIC_FILE"]=Tags:match("TAG ID3:APIC_FILE (.-)\n") or ""    
  MetaDataTable["ID3:APIC_TYPE"]=Tags:match("TAG ID3:APIC_TYPE (.-)\n") or ""    
  MetaDataTable["ID3:COMM"]=Tags:match("TAG ID3:COMM (.-)\n") or ""    
  MetaDataTable["ID3:COMM_LANG"]=Tags:match("TAG ID3:COMM_LANG (.-)\n") or ""    
  MetaDataTable["ID3:TALB"]=Tags:match("TAG ID3:TALB (.-)\n") or ""    
  MetaDataTable["ID3:TBPM"]=Tags:match("TAG ID3:TBPM (.-)\n") or ""    
  MetaDataTable["ID3:TCOM"]=Tags:match("TAG ID3:TCOM (.-)\n") or ""    
  MetaDataTable["ID3:TCON"]=Tags:match("TAG ID3:TCON (.-)\n") or ""    
  MetaDataTable["ID3:TCOP"]=Tags:match("TAG ID3:TCOP (.-)\n") or ""    
  MetaDataTable["ID3:TDRC"]=Tags:match("TAG ID3:TDRC (.-)\n") or ""    
  MetaDataTable["ID3:TEXT"]=Tags:match("TAG ID3:TEXT (.-)\n") or ""    
  MetaDataTable["ID3:TIME"]=Tags:match("TAG ID3:TIME (.-)\n") or ""    
  MetaDataTable["ID3:TIPL"]=Tags:match("TAG ID3:TIPL (.-)\n") or ""    
  MetaDataTable["ID3:TIT1"]=Tags:match("TAG ID3:TIT1 (.-)\n") or ""    
  MetaDataTable["ID3:TIT2"]=Tags:match("TAG ID3:TIT2 (.-)\n") or ""    
  MetaDataTable["ID3:TIT3"]=Tags:match("TAG ID3:TIT3 (.-)\n") or ""    
  MetaDataTable["ID3:TKEY"]=Tags:match("TAG ID3:TKEY (.-)\n") or ""    
  MetaDataTable["ID3:TMCL"]=Tags:match("TAG ID3:TMCL (.-)\n") or ""    
  MetaDataTable["ID3:TPE1"]=Tags:match("TAG ID3:TPE1 (.-)\n") or ""    
  MetaDataTable["ID3:TPE2"]=Tags:match("TAG ID3:TPE2 (.-)\n") or ""    
  MetaDataTable["ID3:TRCK"]=Tags:match("TAG ID3:TRCK (.-)\n") or ""    
  MetaDataTable["ID3:TSRC"]=Tags:match("TAG ID3:TSRC (.-)\n") or ""    
  MetaDataTable["ID3:TYER"]=Tags:match("TAG ID3:TYER (.-)\n") or ""    
  
  count=0
  for val in string.gmatch(Tags, "TAG ([\"]-ID3:TXXX:.-)\n") do
    if val:sub(1,1)=="\"" then
      k,offset=val:match("\"(.-)\" ()")
      v=val:sub(offset, -1)
    else
      k,v=val:match("ID3:TXXX:(.-) (.*)")
    end  
    count=count+1
    if k:sub(1,1)=="\"" then k=k:sub(2,-2) end
    if v:sub(1,1)=="\"" then v=v:sub(2,-2) end
    MetaDataTable["ID3:TXXX:"..count]={}
    MetaDataTable["ID3:TXXX:"..count]["key"]=k
    MetaDataTable["ID3:TXXX:"..count]["value"]=v
  end

  -- INFO
  MetaDataTable["INFO:IART"]=Tags:match("TAG INFO:IART (.-)\n") or ""    
  MetaDataTable["INFO:ICMT"]=Tags:match("TAG INFO:ICMT (.-)\n") or ""    
  MetaDataTable["INFO:ICOP"]=Tags:match("TAG INFO:ICOP (.-)\n") or ""    
  MetaDataTable["INFO:ICRD"]=Tags:match("TAG INFO:ICRD (.-)\n") or ""    
  MetaDataTable["INFO:IENG"]=Tags:match("TAG INFO:IENG (.-)\n") or ""    
  MetaDataTable["INFO:IGNR"]=Tags:match("TAG INFO:IGNR (.-)\n") or ""    
  MetaDataTable["INFO:IKEY"]=Tags:match("TAG INFO:IKEY (.-)\n") or ""    
  MetaDataTable["INFO:INAM"]=Tags:match("TAG INFO:INAM (.-)\n") or ""    
  MetaDataTable["INFO:IPRD"]=Tags:match("TAG INFO:IPRD (.-)\n") or ""    
  MetaDataTable["INFO:ISBJ"]=Tags:match("TAG INFO:ISBJ (.-)\n") or ""    
  MetaDataTable["INFO:ISRC"]=Tags:match("TAG INFO:ISRC (.-)\n") or ""    
  MetaDataTable["INFO:TRCK"]=Tags:match("TAG INFO:TRCK (.-)\n") or ""    
  
  -- IXML
  MetaDataTable["IXML:CIRCLED"]=Tags:match("TAG IXML:CIRCLED (.-)\n") or ""      
  MetaDataTable["IXML:FILE_UID"]=Tags:match("TAG IXML:FILE_UID (.-)\n") or ""      
  MetaDataTable["IXML:NOTE"]=Tags:match("TAG IXML:NOTE (.-)\n") or ""      
  MetaDataTable["IXML:PROJECT"]=Tags:match("TAG IXML:PROJECT (.-)\n") or ""      
  MetaDataTable["IXML:SCENE"]=Tags:match("TAG IXML:SCENE (.-)\n") or ""      
  MetaDataTable["IXML:TAKE"]=Tags:match("TAG IXML:TAKE (.-)\n") or ""      
  MetaDataTable["IXML:TAPE"]=Tags:match("TAG IXML:TAPE (.-)\n") or ""      

  count=0
  for val in string.gmatch(Tags, "TAG ([\"]-IXML:USER:.-)\n") do
    if val:sub(1,1)=="\"" then
      k,offset=val:match("\"(.-)\" ()")
      v=val:sub(offset, -1)
    else
      k,v=val:match("IXML:USER:(.-) (.*)")
    end  
    count=count+1
    if k:sub(1,1)=="\"" then k=k:sub(2,-2) end
    if v:sub(1,1)=="\"" then v=v:sub(2,-2) end
    MetaDataTable["IXML:USER:"..count]={}
    MetaDataTable["IXML:USER:"..count]["key"]=k
    MetaDataTable["IXML:USER:"..count]["value"]=v
  end
  
  -- VORBIS
  MetaDataTable["VORBIS:ALBUM"]=Tags:match("TAG VORBIS:ALBUM (.-)\n") or ""  
  MetaDataTable["VORBIS:ALBUMARTIST"]=Tags:match("TAG VORBIS:ALBUMARTIST (.-)\n") or ""  
  MetaDataTable["VORBIS:ARRANGER"]=Tags:match("TAG VORBIS:ARRANGER (.-)\n") or ""  
  MetaDataTable["VORBIS:ARTIST"]=Tags:match("TAG VORBIS:ARTIST (.-)\n") or ""  
  MetaDataTable["VORBIS:AUTHOR"]=Tags:match("TAG VORBIS:AUTHOR (.-)\n") or ""  
  MetaDataTable["VORBIS:BPM"]=Tags:match("TAG VORBIS:BPM (.-)\n") or ""  
  MetaDataTable["VORBIS:COMMENT"]=Tags:match("TAG VORBIS:COMMENT (.-)\n") or ""  
  MetaDataTable["VORBIS:COMPOSER"]=Tags:match("TAG VORBIS:COMPOSER (.-)\n") or ""  
  MetaDataTable["VORBIS:CONDUCTOR"]=Tags:match("TAG VORBIS:CONDUCTOR (.-)\n") or ""  
  MetaDataTable["VORBIS:COPYRIGHT"]=Tags:match("TAG VORBIS:COPYRIGHT (.-)\n") or ""  
  MetaDataTable["VORBIS:DATE"]=Tags:match("TAG VORBIS:DATE (.-)\n") or ""  
  MetaDataTable["VORBIS:DESCRIPTION"]=Tags:match("TAG VORBIS:DESCRIPTION (.-)\n") or ""  
  MetaDataTable["VORBIS:DISCNUMBER"]=Tags:match("TAG VORBIS:DISCNUMBER (.-)\n") or ""  
  MetaDataTable["VORBIS:EAN/UPN"]=Tags:match("TAG VORBIS:EAN/UPN (.-)\n") or ""  
  MetaDataTable["VORBIS:ENCODED-BY"]=Tags:match("TAG VORBIS:ENCODED%-BY (.-)\n") or ""  
  MetaDataTable["VORBIS:ENCODING"]=Tags:match("TAG VORBIS:ENCODING (.-)\n") or ""  
  MetaDataTable["VORBIS:ENSEMBLE"]=Tags:match("TAG VORBIS:ENSEMBLE (.-)\n") or ""  
  MetaDataTable["VORBIS:GENRE"]=Tags:match("TAG VORBIS:GENRE (.-)\n") or ""  
  MetaDataTable["VORBIS:ISRC"]=Tags:match("TAG VORBIS:ISRC (.-)\n") or ""  
  MetaDataTable["VORBIS:KEY"]=Tags:match("TAG VORBIS:KEY (.-)\n") or ""  
  MetaDataTable["VORBIS:LABEL"]=Tags:match("TAG VORBIS:LABEL (.-)\n") or ""  
  MetaDataTable["VORBIS:LABELNO"]=Tags:match("TAG VORBIS:LABELNO (.-)\n") or ""  
  MetaDataTable["VORBIS:LANGUAGE"]=Tags:match("TAG VORBIS:LANGUAGE (.-)\n") or ""  
  MetaDataTable["VORBIS:LICENSE"]=Tags:match("TAG VORBIS:LICENSE (.-)\n") or ""  
  MetaDataTable["VORBIS:LOCATION"]=Tags:match("TAG VORBIS:LOCATION (.-)\n") or ""  
  MetaDataTable["VORBIS:LYRICIST"]=Tags:match("TAG VORBIS:LYRICIST (.-)\n") or ""  
  MetaDataTable["VORBIS:OPUS"]=Tags:match("TAG VORBIS:OPUS (.-)\n") or ""  
  MetaDataTable["VORBIS:PART"]=Tags:match("TAG VORBIS:PART (.-)\n") or ""  
  MetaDataTable["VORBIS:PARTNUMBER"]=Tags:match("TAG VORBIS:PARTNUMBER (.-)\n") or ""  
  MetaDataTable["VORBIS:PERFORMER"]=Tags:match("TAG VORBIS:PERFORMER (.-)\n") or ""  
  MetaDataTable["VORBIS:PRODUCER"]=Tags:match("TAG VORBIS:PRODUCER (.-)\n") or ""  
  MetaDataTable["VORBIS:PUBLISHER"]=Tags:match("TAG VORBIS:PUBLISHER (.-)\n") or ""  
  MetaDataTable["VORBIS:REAPER"]=Tags:match("TAG VORBIS:REAPER (.-)\n") or ""  
  MetaDataTable["VORBIS:SOURCEMEDIA"]=Tags:match("TAG VORBIS:SOURCEMEDIA (.-)\n") or ""  
  MetaDataTable["VORBIS:TITLE"]=Tags:match("TAG VORBIS:TITLE (.-)\n") or ""  
  MetaDataTable["VORBIS:TRACKNUMBER"]=Tags:match("TAG VORBIS:TRACKNUMBER (.-)\n") or ""  
  MetaDataTable["VORBIS:VERSION"]=Tags:match("TAG VORBIS:VERSION (.-)\n") or ""  

  count=0
  for val in string.gmatch(Tags, "TAG ([\"]-VORBIS:USER:.-)\n") do
    if val:sub(1,1)=="\"" then
      k,offset=val:match("\"(.-)\" ()")
      v=val:sub(offset, -1)
    else
      k,v=val:match("VORBIS:USER:(.-) (.*)")
    end  
    count=count+1
    if k:sub(1,1)=="\"" then k=k:sub(2,-2) end
    if v:sub(1,1)=="\"" then v=v:sub(2,-2) end
    MetaDataTable["VORBIS:USER:"..count]={}
    MetaDataTable["VORBIS:USER:"..count]["key"]=k
    MetaDataTable["VORBIS:USER:"..count]["value"]=v
  end
  
  -- XMP
  MetaDataTable["XMP:dc/creator"]=Tags:match("TAG XMP:dc/creator (.-)\n") or ""    
  MetaDataTable["XMP:dc/date"]=Tags:match("TAG XMP:dc/date (.-)\n") or ""  
  MetaDataTable["XMP:dc/description"]=Tags:match("TAG XMP:dc/description (.-)\n") or ""  
  MetaDataTable["XMP:dc/language"]=Tags:match("TAG XMP:dc/language (.-)\n") or ""  
  MetaDataTable["XMP:dc/title"]=Tags:match("TAG XMP:dc/title (.-)\n") or ""  
  MetaDataTable["XMP:dm/album"]=Tags:match("TAG XMP:dm/album (.-)\n") or ""  
  MetaDataTable["XMP:dm/artist"]=Tags:match("TAG XMP:dm/artist (.-)\n") or ""  
  MetaDataTable["XMP:dm/composer"]=Tags:match("TAG XMP:dm/composer (.-)\n") or ""  
  MetaDataTable["XMP:dm/copyright"]=Tags:match("TAG XMP:dm/copyright (.-)\n") or ""  
  MetaDataTable["XMP:dm/engineer"]=Tags:match("TAG XMP:dm/engineer (.-)\n") or ""  
  MetaDataTable["XMP:dm/genre"]=Tags:match("TAG XMP:dm/genre (.-)\n") or ""  
  MetaDataTable["XMP:dm/key"]=Tags:match("TAG XMP:dm/key (.-)\n") or ""  
  MetaDataTable["XMP:dm/logComment"]=Tags:match("TAG XMP:dm/logComment (.-)\n") or ""  
  MetaDataTable["XMP:dm/scene"]=Tags:match("TAG XMP:dm/scene (.-)\n") or ""  
  MetaDataTable["XMP:dm/tempo"]=Tags:match("TAG XMP:dm/tempo (.-)\n") or ""  
  MetaDataTable["XMP:dm/timeSignature"]=Tags:match("TAG XMP:dm/timeSignature (.-)\n") or ""  
  MetaDataTable["XMP:dm/trackNumber"]=Tags:match("TAG XMP:dm/trackNumber (.-)\n") or ""  
  
  
  for i, v in pairs(MetaDataTable) do
    if type(i)~="table" and type(v)~="table" then
      if v:sub(1,1)=="\"" then MetaDataTable[i]=v:sub(2,-2) end
    end
  end
  return MetaDataTable
end

--A,B=ultraschall.Metadata_GetMetaDataTable_Presets("All Metadata1")

function ultraschall.Metadata_GetAllPresetNames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Metadata_GetAllPresetNames</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>integer count_of_presets, table presetnames = ultraschall.Metadata_GetAllPresetNames(string PresetName)</functioncall>
  <description>
    returns a table with all names of the metadata-presets
    
    returns nil in case of an error of if reaper-metadata.ini isn't found in resource-folder
  </description>
  <retvals>
    integer count_of_presets - the number of found metadata-presetnames
    table presetnames - all metadata-presetnames found
  </retvals>
  <chapter_context>
    Metadata Management
    Reaper Metadata Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadata management, get, metadata preset, name, metadata</tags>
</US_DocBloc>
]]
  local File=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-metadata.ini")
  if File==nil then ultraschall.AddErrorMessage("Metadata_GetAllPresetNames", "", "Could not retrieve metadata-presets: reaper-metadata.ini is missing in resourcefolder", -1) return end
  local PresetNames={}
  local PresetCount=0
  for name_found in string.gmatch(File, "<METADATA (.-)\n") do
    PresetCount=PresetCount+1
    PresetNames[PresetCount]=name_found
  end  
  return PresetCount, PresetNames
end

--A,B=ultraschall.Metadata_GetAllPresetNames()

function ultraschall.MetaDataTable_Create()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MetaDataTable_Create</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table MetaDataTable = ultraschall.MetaDataTable_Create()</functioncall>
  <description>
    Returns an empty MetaDataTable for all possible metadata, in which metadata can be set.
  </description> 
  <retvals>
    table MetaDataTable - a table with all metadata-entries available in Reaper
  </retvals>
  <chapter_context>
    Metadata Management
    Reaper Metadata Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, create, metadatatable</tags>
</US_DocBloc>
]]
  local A="APE:Album;APE:Artist;APE:BPM;APE:Catalog;APE:Comment;APE:Composer;APE:Conductor;APE:Copyright;APE:Genre;APE:ISRC;APE:Key;APE:Language;APE:Publisher;APE:REAPER;APE:Record Date;APE:Record Location;APE:Subtitle;APE:Title;APE:Track;APE:User Defined:a;APE:User Defined:User;APE:Year;ASWG:accent;ASWG:actorGender;ASWG:actorName;ASWG:ambisonicChnOrder;ASWG:ambisonicFormat;ASWG:ambisonicNorm;ASWG:artist;ASWG:billingCode;ASWG:category;ASWG:catId;ASWG:channelConfig;ASWG:characterAge;ASWG:characterGender;ASWG:characterName;ASWG:characterRole;ASWG:composer;ASWG:contentType;ASWG:creatorId;ASWG:direction;ASWG:director;ASWG:editor;ASWG:efforts;ASWG:effortType;ASWG:emotion;ASWG:fxChainName;ASWG:fxName;ASWG:fxUsed;ASWG:genre;ASWG:impulseLocation;ASWG:inKey;ASWG:instrument;ASWG:intensity;ASWG:isCinematic;ASWG:isDesigned;ASWG:isDiegetic;ASWG:isFinal;ASWG:isLicensed;ASWG:isLoop;ASWG:isOst;ASWG:isrcId;ASWG:isSource;ASWG:isUnion;ASWG:language;ASWG:library;ASWG:loudness;ASWG:loudnessRange;ASWG:maxPeak;ASWG:micConfig;ASWG:micDistance;ASWG:micType;ASWG:mixer;ASWG:musicPublisher;ASWG:musicSup;ASWG:musicVersion;ASWG:notes;ASWG:orderRef;ASWG:originator;ASWG:originatorStudio;ASWG:papr;ASWG:producer;ASWG:project;ASWG:projection;ASWG:recEngineer;ASWG:recordingLoc;ASWG:recStudio;ASWG:rightsOwner;ASWG:rmsPower;ASWG:session;ASWG:songTitle;ASWG:sourceId;ASWG:specDensity;ASWG:state;ASWG:subCategory;ASWG:subGenre;ASWG:tempo;ASWG:text;ASWG:timeSig;ASWG:timingRestriction;ASWG:usageRights;ASWG:userCategory;ASWG:userData;ASWG:vendorCategory;ASWG:zeroCrossRate;AXML:ISRC;BWF:Description;BWF:LoudnessRange;BWF:LoudnessValue;BWF:MaxMomentaryLoudness;BWF:MaxShortTermLoudness;BWF:MaxTruePeakLevel;BWF:OriginationDate;BWF:OriginationTime;BWF:Originator;BWF:OriginatorReference;CAFINFO:album;CAFINFO:artist;CAFINFO:channel configuration;CAFINFO:channel layout;CAFINFO:comments;CAFINFO:composer;CAFINFO:copyright;CAFINFO:encoding application;CAFINFO:genre;CAFINFO:key signature;CAFINFO:lyricist;CAFINFO:nominal bit rate;CAFINFO:recorded date;CAFINFO:source encoder;CAFINFO:tempo;CAFINFO:time signature;CAFINFO:title;CAFINFO:track number;CAFINFO:year;CART:Artist;CART:Category;CART:ClientID;CART:CutID;CART:EndDate;CART:INT1;CART:SEG1;CART:StartDate;CART:TagText;CART:Title;CART:URL;CUE:DISC_CATALOG;CUE:DISC_PERFORMER;CUE:DISC_REM;CUE:DISC_SONGWRITER;CUE:DISC_TITLE;CUE:INDEX;CUE:TRACK_ISRC;FLACPIC:APIC_DESC;FLACPIC:APIC_FILE;FLACPIC:APIC_TYPE;ID3:APIC_DESC;ID3:APIC_FILE;ID3:APIC_TYPE;ID3:COMM;ID3:COMM_LANG;ID3:TALB;ID3:TBPM;ID3:TCOM;ID3:TCON;ID3:TCOP;ID3:TDRC;ID3:TEXT;ID3:TIME;ID3:TIPL;ID3:TIT1;ID3:TIT2;ID3:TIT3;ID3:TKEY;ID3:TMCL;ID3:TPE1;ID3:TPE2;ID3:TPOS;ID3:TRCK;ID3:TSRC;ID3:TXXX:a;ID3:TXXX:REAPER;ID3:TXXX:User;ID3:TYER;IFF:ANNO;IFF:AUTH;IFF:COPY;IFF:NAME;INFO:IART;INFO:ICMT;INFO:ICOP;INFO:ICRD;INFO:IENG;INFO:IGNR;INFO:IKEY;INFO:INAM;INFO:IPRD;INFO:ISBJ;INFO:ISRC;INFO:TRCK;IXML:CIRCLED;IXML:FILE_UID;IXML:NOTE;IXML:PROJECT;IXML:SCENE;IXML:TAKE;IXML:TAPE;IXML:USER:a;IXML:USER:REAPER;IXML:USER:User;VORBIS:ALBUM;VORBIS:ALBUMARTIST;VORBIS:ARRANGER;VORBIS:ARTIST;VORBIS:AUTHOR;VORBIS:BPM;VORBIS:COMMENT;VORBIS:COMPOSER;VORBIS:CONDUCTOR;VORBIS:COPYRIGHT;VORBIS:DATE;VORBIS:DESCRIPTION;VORBIS:DISCNUMBER;VORBIS:EAN/UPN;VORBIS:ENCODED-BY;VORBIS:ENCODING;VORBIS:ENSEMBLE;VORBIS:GENRE;VORBIS:ISRC;VORBIS:KEY;VORBIS:LABEL;VORBIS:LABELNO;VORBIS:LANGUAGE;VORBIS:LICENSE;VORBIS:LOCATION;VORBIS:LYRICIST;VORBIS:OPUS;VORBIS:PART;VORBIS:PARTNUMBER;VORBIS:PERFORMER;VORBIS:PRODUCER;VORBIS:PUBLISHER;VORBIS:REAPER;VORBIS:SOURCEMEDIA;VORBIS:TITLE;VORBIS:TRACKNUMBER;VORBIS:USER:a;VORBIS:USER:User;VORBIS:VERSION;WAVEXT:channel configuration;XMP:dc/creator;XMP:dc/date;XMP:dc/description;XMP:dc/language;XMP:dc/title;XMP:dm/album;XMP:dm/artist;XMP:dm/composer;XMP:dm/copyright;XMP:dm/engineer;XMP:dm/genre;XMP:dm/key;XMP:dm/logComment;XMP:dm/scene;XMP:dm/tempo;XMP:dm/timeSignature;XMP:dm/trackNumber"
  local B={}

  for k in string.gmatch(A..";", "(.-);") do
    B[k]=""
  end
  return B
end

function ultraschall.MetaDataTable_GetProject()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MetaDataTable_GetProject</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table MetaDataTable = ultraschall.MetaDataTable_GetProject()</functioncall>
  <description>
    Returns a MetaDataTable for all possible metadata, in which metadata can be set.
    
    All metadata currently set in the active project will be set in the MetaDataTable.
  </description> 
  <retvals>
    table MetaDataTable - a table with all metadata-entries available in Reaper and set with all metadata of current project
  </retvals>
  <chapter_context>
    Metadata Management
    Reaper Metadata Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, metadatatable</tags>
</US_DocBloc>
]]
  local MetaDataTable=ultraschall.MetaDataTable_Create()
  local retval, ProjMetDat=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "", false)  

  for k in string.gmatch(ProjMetDat..";", "(.-);") do
    _retval, MetaDataTable[k]=reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", k, false)
  end
  return MetaDataTable
end