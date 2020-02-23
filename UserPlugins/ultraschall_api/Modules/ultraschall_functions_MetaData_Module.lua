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


