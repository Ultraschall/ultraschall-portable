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

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "MetaData-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end

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
    Extension States(Guid)
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MetaData_Module.lua</source_document>
  <tags>metadatamanagement, project, extension, state, get, guid, key, values</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidGuid(guid, false)==false then ultraschall.AddErrorMessage("GetGuidExtState","guid", "must be a valid guid", -1) return -1 end
  if ultraschall.IsValidGuid(guid, false)==false then ultraschall.AddErrorMessage("GetGuidExtState","key", "must be a string", -2) return -1 end
  if math.type(savelocation)~="integer" then ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "must be an integer", -4) return -1 end
  if tonumber(savelocation)~=0 and tonumber(savelocation)~=1 then ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "only allowed 0 for project-extstate, 1 for global extension state", -5) return -1 end
  
  if savelocation==0 then 
    local retval, string=reaper.GetProjExtState(0, guid, key)
    if retval>0 then return 1, string else return -1 end
  elseif savelocation==1 then 
    return 1, reaper.GetExtState(guid, key, value, persist)
  else ultraschall.AddErrorMessage("GetGuidExtState","savelocation", "no such location", -6) return -1
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
    integer retval - -1, in case of an error; 1, in case of success
  </retvals>
  <parameters>
    integer index - the marker/region-index, for which to store an extstate; starting with 1 for first marker/region, 2 for second marker/region
    string key - the key, into which the marker-extstate shall be stored
    string value - the value, which you want to store into the marker-extstate
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
  if type(value)~="string" then ultraschall.AddErrorMessage("SetMarkerExtState", "value", "must be an integer", -4) return -1 end
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
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Metadata_ID3_GetSet(string Tag, optional string Value)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets/Sets a stored ID3-metadata-tag into the current project(for Wav or MP3).
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    Note: APIC\_TYPE allows only specific values, as listed below!
    
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
      TCOM - Composer
      TIPL - Involved People
      TEXT - Lyricist/Text Writer
      TMCL - Musician Credits
      TALB - Album
      TRCK - Track
      TIT1 - Content Group
      TRCK - Track number
      TSRC - International Standard Recording Code
      TCOP - Copyright Message
      COMM\_LANG - Comment language, 3-character code like "eng"
      APIC\_TYPE - the type of the cover-image, which can be of the following:
      
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
    
    APIC\_DESC - the description of the cover-image
    APIC\_FILE - the filename+absolute path of the cover-image; must be either png or jpg
    
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets/Sets a stored APE-metadata-tag into the current project.
    
    To get a value, set parameter Value to nil; to set a value, set the parameter Value to the desired value
    
    Supported tags are:
     Title - title
     Subtitle - description
     Artist - artist
     Genre - genre
     Key - key
     BPM - tempo
     Year - the date; following format: yyyy-mm-dd
     Record Date - the recording date; following format: yyyy-mm-dd
     Comment - comment
     User Defined - user defined metadata
     REAPER - Media Explorer Metadata
     Composer - the composer
     Conductor - the conductor
     Publisher - the publisher
     Album - the album
     Track - the tracknumber
     Catalog - the catalog
     ISRC - the isrc
     Copyright - the copyright holder
     Language - the language, a three character code like "eng"
     Record Location - the recording location


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