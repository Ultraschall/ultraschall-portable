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
---        Markers Module         ---
-------------------------------------



if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Markers-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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


function ultraschall.AddNormalMarker(position, shown_number, markertitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddNormalMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer marker_number, string guid = ultraschall.AddNormalMarker(number position, integer shown_number, string markertitle)</functioncall>
  <description>
    Adds a normal marker. Returns the index of the marker as marker_number.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer marker_number  - the overall-marker-index, can be used for reaper's own marker-management functions
     string guid - the guid, associated with this marker
  </retvals>
  <parameters>
    number position - position in seconds.
    integer shown_number - the number, that will be shown within Reaper. Can be multiple times. Use -1 to let Reaper decide the number.
    string markertitle - the title of the marker.
  </parameters>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, add, normal marker, guid</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(position)~="number" then ultraschall.AddErrorMessage("AddNormalMarker", "position", "must be a number", -1) return -1 end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("AddNormalMarker", "shown_number", "must be an integer", -2) return -1 end
  if markertitle==nil then markertitle="" end

  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsMarkerAtPosition(position)

  -- create marker
  local noteID=0
  if position>=0 then noteID=reaper.AddProjectMarker2(0, false, position, 0, markertitle, shown_number, 0)
  else noteID=-1
  end
  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsMarkerAtPosition(position)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  return originals_array1[1]-1, guid
end


function ultraschall.AddPodRangeRegion(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddPodRangeRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer marker_number, string guid = ultraschall.AddPodRangeRegion(number startposition, number endposition)</functioncall>
  <description>
    Adds a region, which shows the time-range from the beginning to the end of the podcast.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer marker_number  - the overall-marker-index, can be used for reaper's own marker-management functions
    string guid - the guid of the PodRangeRegion
  </retvals>
  <parameters>
    number startposition - begin of the podcast in seconds
    number endposition - end of the podcast in seconds
  </parameters>
  <chapter_context>
    Markers
    PodRange Region
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, add, podrange, region, guid</tags>
</US_DocBloc>
--]]
  
  -- prepare variables
  local color=0
  local noteID=0
  
  -- prepare colorvalue
  local Os = reaper.GetOS()
  if string.match(Os, "OSX") then 
    color = 0xFFFFFF|0x1000000
  else
    color = 0xFFFFFF|0x1000000
  end

  local a,nummarkers,numregions=reaper.CountProjectMarkers(0)
  local count=0

  if type(startposition)~="number" then ultraschall.AddErrorMessage("AddPodRangeRegion", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("AddPodRangeRegion", "endposition", "must be a number", -2) return -1 end
  if startposition<0 then return -1 end
  if endposition<startposition then return -1 end
  
  for i=nummarkers+numregions, 0, -1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,10)=="_PodRange:" and isrgn==true then count=count+1 reaper.DeleteProjectMarkerByIndex(0,i) end 
  end
  
  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsRegionAtPosition(startposition)
  
  noteID=reaper.AddProjectMarker2(0, 1, startposition, endposition, "_PodRange:", 0, color)
  
  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsRegionAtPosition(startposition)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  
  return originals_array1[1]-1, guid
end

function ultraschall.GetMarkerByName(searchname, searchisrgn)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerByName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count_markers, array foundmarkers, array found_guids = ultraschall.GetMarkerByName(string searchname, boolean searchisrgn)</functioncall>
  <description>
    Get all markers/regions that have a certain name. This function is not case-sensitive.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count_markers - the number of found markers/regions
    array foundmarkers - an array with all marker/region-numbers of the found markers; counts only regions or markers(depending on parameter searchisrgn); markernumbers are 0-based
    array found_guids - the guids of all markers/regions found
  </retvals>
  <parameters>
    string searchname - the name to look for; must be exact; not case-sensitive
    boolean searchisrgn - true, search only within regions; false, search only within markers
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, marker, region, name, guid</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(searchname)~="string" then ultraschall.AddErrorMessage("GetMarkerByName", "searchname", "must be a string", -1) return -1 end
  if type(searchisrgn)~="boolean" then ultraschall.AddErrorMessage("GetMarkerByName", "searchisrgn", "must be boolean", -2) return -1 end
  
  -- prepare variables
  local foundmarkers={}
  local guids={}
  local count=1
  local markercount=0
  local Aretval
  searchname=searchname:upper()
  
  -- look for markers/regions
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if searchisrgn==isrgn then markercount=markercount+1 end -- count markers/region
    if isrgn==searchisrgn and name:upper()==searchname:upper() then 
      foundmarkers[count]=markercount-1      -- if right marker/region has been found, add it to the foundmarkers-array
      Aretval, guids[count] = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
      count=count+1
    end
  end
  return count-1, foundmarkers, guids
end


function ultraschall.GetMarkerByName_Pattern(searchname, searchisrgn)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerByName_Pattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count_markers, array foundmarkers, array foundguids = ultraschall.GetMarkerByName_Pattern(string searchname, boolean searchisrgn)</functioncall>
  <description>
    Get all markers/regions that have a certain character-sequence in their name. This function is not case-sensitive.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count_markers - the number of found markers/regions
    array foundmarkers - an array with all marker/region-numbers of the found markers; counts only regions or markers(depending on parameter searchisrgn)
    array foundguids - the guids of all found markers/regions
  </retvals>
  <parameters>
    string searchname - the name to look for; a character-sequence that shall be part of the name; not case-sensitive
    boolean searchisrgn - true, search only within regions; false, search only within markers
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, marker, region, pattern, guid</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(searchname)~="string" then ultraschall.AddErrorMessage("GetMarkerByName_Pattern", "searchname", "must be a string", -1) return -1 end
  if type(searchisrgn)~="boolean" then ultraschall.AddErrorMessage("GetMarkerByName_Pattern", "searchisrgn", "must be boolean", -2) return -1 end
  
  -- prepare variables
  local foundmarkers={}
  local count=1
  local markercount=0
  local guids={}
  local Aretval
  
  searchname=searchname:upper()
  
  -- look for markers/regions
  for i=0, reaper.CountProjectMarkers(0)-1 do
    retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    name=name:upper()    
    if searchisrgn==isrgn then markercount=markercount+1 end -- count marker/region
    if searchisrgn==isrgn and name:match(searchname)~=nil then 
      foundmarkers[count]=markercount-1  -- if right marker/region has been found add to foundmarkers-array
      Aretval, guids[count] = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
      count=count+1
    end
  end
  return count-1, foundmarkers, guids
end

function ultraschall.GetMarkerAndRegionsByIndex(idx, searchisrgn)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerAndRegionsByIndex</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string name, integer shown_number, integer color, number pos, optional number rgnend, string guid = ultraschall.GetMarkerAndRegionsByIndex(integer idx, boolean searchisrgn)</functioncall>
  <description>
    Returns the values of a certain marker/region. The numbering of idx is either only for the markers or for regions, depending on what you set with parameter searchisrgn.
    
    returns nil in case of an error
  </description>
  <retvals>
    string name - the name of the marker/region
    integer markrgnindexnumber - the shown number of the marker/region
    integer color - the color-value of the marker/region
    number pos - the position of the marker/region
    optional number rgnend - the end of the region
    string guid - the guid of the marker/region; if it's a marker, the retval rgnend will be nil!
  </retvals>
  <parameters>
    integer idx - the number of the requested marker/region; counts only within either markers or regions, depending on what you've set searchisrgn to; 1-based!
    boolean searchisrgn - true, search only within regions; false, search only within markers
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, marker, region, index, color, name, position, regionend, shownnumber, shown, guid</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetMarkerAndRegionsByIndex", "idx", "must be an integer", -1) return  end
  if type(searchisrgn)~="boolean" then ultraschall.AddErrorMessage("GetMarkerAndRegionsByIndex", "searchisrgn", "must be boolean", -2) return  end

  -- prepare variable
  local markercount=0
  
  -- look for the right marker/region
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    local Aretval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
    if searchisrgn==isrgn then markercount=markercount+1 end -- count marker/region
    if searchisrgn==isrgn and isrgn==true and markercount==idx then return name, markrgnindexnumber, color, pos, rgnend, guid end -- if right region, return values
    if searchisrgn==isrgn and isrgn==false and markercount==idx then return name, markrgnindexnumber, color, pos, nil, guid end -- if right marker, return values
  end
end

function ultraschall.SetMarkerByIndex(idx, searchisrgn, shown_number, pos, rgnend, name, color, flags)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetMarkerByIndex</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetMarkerByIndex(integer idx, boolean searchisrgn, integer shown_number, number position, position rgnend, string name, integer color, integer flags)</functioncall>
  <description>
    Sets the values of a certain marker/region. The numbering of idx is either only for the markers or for regions, depending on what you set with parameter searchisrgn.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the marker/region was successful; false, setting of the marker/region was unsuccessful.
  </retvals>
  <parameters>
    integer idx - the number of the requested marker/region; counts only within either markers or regions, depending on what you've set searchisrgn to
    boolean searchisrgn - true, search only within regions; false, search only within markers
    integer shown_number - the shown-number of the region/marker; no duplicate numbers for regions allowed; nil to keep previous shown_number
    number position - the position of the marker/region in seconds; nil to keep previous position
    position rgnend - the end of the region in seconds; nil to keep previous region-end
    string name - the name of the marker/region; nil to keep the previous name
    integer color - color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000; nil to keep the previous color
    integer flags - flags&1 to clear name; 0, keep it; nil to use the previous setting
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, marker, region, index, color, name, position, regionend, shownnumber, shown</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetMarkerByIndex", "idx", "must be an integer", -1) return false end
  if type(searchisrgn)~="boolean" then ultraschall.AddErrorMessage("SetMarkerByIndex", "searchisrgn", "must be boolean", -2) return false end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("SetMarkerByIndex", "shown_number", "must be an integer", -3) return false end
  if type(pos)~="number" then ultraschall.AddErrorMessage("SetMarkerByIndex", "pos", "must be a number", -4) return false end
  if type(rgnend)~="number" then ultraschall.AddErrorMessage("SetMarkerByIndex", "rgnend", "must be a number", -5) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetMarkerByIndex", "name", "must be a string", -5) return false end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("SetMarkerByIndex", "color", "must be an integer", -6) return false end
  if math.type(flags)~="integer" then ultraschall.AddErrorMessage("SetMarkerByIndex", "flags", "must be an integer", -7) return false end

  -- prepare variable
  local markercount=0
  
  -- search and set marker/region
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval2, isrgn, pos2, rgnend2, name2, markrgnindexnumber2, color2 = reaper.EnumProjectMarkers3(0,i)
    
    -- count marker/region
    if searchisrgn==isrgn then markercount=markercount+1 end
    if searchisrgn==isrgn and isrgn==true and markercount==idx then
      -- if the correct region has been found, change it
      if shown_number==nil then shown_number=markrgnindexnumber2 end
      if pos==nil then pos=pos2 end
      if rgnend==nil then rgnend=rgnend2 end
      if name==nil then name=name2 end
      if color==nil then color=color2 end
      return reaper.SetProjectMarkerByIndex2(0, i, true, pos, rgnend, shown_number, name, color, 0)
    end
    if searchisrgn==isrgn and isrgn==false and markercount==idx then 
      -- if the correct marker has been found, change it
      if shown_number==nil then shown_number=markrgnindexnumber2 end
      if pos==nil then pos=pos2 end
      if rgnend==nil then rgnend=rgnend2 end
      if name==nil then name=name2 end
      if color==nil then color=color2 end
      return reaper.SetProjectMarker4(0, i, false, pos, rgnend, name, color, flags) 
    end
  end
  
  -- if no such marker/region has been found
  if searchisrgn==true then ultraschall.AddErrorMessage("SetMarkerByIndex", "idx", "no such region", -8) return false end
  if searchisrgn==false then ultraschall.AddErrorMessage("SetMarkerByIndex", "idx", "no such marker", -9) return false end
  return false
end



function ultraschall.AddEditMarker(position, shown_number, edittitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddEditMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall> integer marker_number, string guid = ultraschall.AddEditMarker(number position, integer shown_number, string edittitle)</functioncall>
  <description>
    Adds an Edit marker. Returns the index of the marker as marker_number. 
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer marker_number  - the overall-marker-index, can be used for reaper's own marker-management functions
     string guid - the guid, associated with this marker
  </retvals>
  <parameters>
    number position - position in seconds.
    integer shown_number - the number, that will be shown within Reaper. Can be multiple times. Use -1 to let Reaper decide the number.
    string edittitle - the title of the edit-marker; will be shown as _Edit:edittitle
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, add, edit, marker, guid</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local color=0
  local noteID=0
  local Os = reaper.GetOS()
  if string.match(Os, "OSX") then 
    color = 0xFF0000|0x1000000
  else
    color = 0x0000FF|0x1000000
  end
  
  -- check parameters
  if type(position)~="number" then ultraschall.AddErrorMessage("AddEditMarker", "position", "must be a number", -1) return -1 end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("AddEditMarker", "shown_number", "must be a integer", -2) return -1 end
  if edittitle==nil then edittitle="" end
  edittitle=":"..edittitle

  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsMarkerAtPosition(position)

  -- set marker
  if position>=0 then noteID=reaper.AddProjectMarker2(0, false, position, 0, "_Edit"..edittitle, shown_number, color) -- set red edit-marker
  else noteID=-1
  end

  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsMarkerAtPosition(position)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  return originals_array1[1]-1, guid
end

function ultraschall.CountNormalMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountNormalMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer number_of_markers = ultraschall.CountNormalMarkers()</functioncall>
  <description>
    Counts all normal markers. 
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
  </description>
  <retvals>
     integer number_of_markers  - number of normal markers
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, normal marker, marker, count</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  
  -- count normal-markers
  for i=0, a-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if name==nil then name="" end
    if name:sub(1,10)=="_Shownote:" or name:sub(1,5)=="_Edit" or color == ultraschall.planned_marker_color then 
        -- if marker is shownote, chapter, edit or planned chapter
    elseif isrgn==false then count=count+1 -- elseif marker is no region, count up
    end
  end 

  return count
end

function ultraschall.CountEditMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountEditMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer number_of_edit_markers = ultraschall.CountEditMarkers()</functioncall>
  <description>
    Counts all edit-markers.
  </description>
  <retvals>
     integer number_of_edit_markers  - number of edit markers
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, count, edit markers, edit</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  
  -- count edit-markers
  for i=0, a-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,5)=="_Edit" and isrgn==false then count=count+1 end 
  end

  return count
end

function ultraschall.GetPodRangeRegion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodRangeRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall> number start_position, number end_position, string guid = ultraschall.GetPodRangeRegion()</functioncall>
  <description>
    Gets the start_position and the end_position of the PodRangeRegion.
    
    returns -1 if no PodRangeRegion exists
  </description>
  <retvals>
     number start_position - beginning of the podrangeregion, that marks the beginning of the podcast
     number end_position  - end of the podrangeregion, that marks the end of the podcast
     string guid - the guid associated with this marker
  </retvals>
  <chapter_context>
    Markers
    PodRange Region
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, enumerate, podrange region, podrange, region, guid</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local color=ultraschall.ConvertColor(255,255,255)

  local a,nummarkers,numregions=reaper.CountProjectMarkers(0)
  local startposition=-1
  local endposition=-1
  local count=0
  local Aretval, guid
  
  -- find _Podrange-regions
  for i=nummarkers+numregions, 0, -1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,10)=="_PodRange:" and isrgn==true then startposition=pos endposition=rgnend Aretval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval, "", false) count=count+1 end 
  end
  
  -- return positions
  if count>1 then return -1, -1, ""
  else return startposition, endposition, guid
  end
end



function ultraschall.EnumerateNormalMarkers(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateNormalMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retnumber, integer retidxnum, number position, string markertitle, string guid = ultraschall.EnumerateNormalMarkers(integer number)</functioncall>
  <description>
    Get the data of a normal marker. 
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    Returns -1 in case of error
  </description>
  <retvals>
     integer retnumber - overallmarker/regionnumber of marker beginning with 1 for the first marker; ignore the order of first,second,etc creation of
    - markers but counts from position 00:00:00 to end of project. So if you created a marker at position 00:00:00 and move the first created marker to
    - the end of the timeline, it will be the last one, NOT the first one in the retval! For use with reaper's own marker-functions.
     integer retidxnum - indexnumber of the marker
     number position - the position of the marker
     string markertitle  - the name of the marker
     string guid - the guid of the enumerated marker
  </retvals>
  <parameters>
    integer number - number of the marker(normal markers only). Refer <a href="#CountNormalMarkers">ultraschall.CountNormalMarkers</a> for getting the number of normal markers.
  </parameters>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, normal, normal marker, enumerate, guid</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateNormalMarkers", "number", "must be an integer", -1) return -1 end
  
  -- prepare variables
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local number=number-1
  local wentfine=0
  local count=-1
  local retnumber=0
  local retidxnum=""
  local markername=""
  local position=0
  local Aretval, guid
  
  -- find the right normal-marker
  for i=0, a-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color= reaper.EnumProjectMarkers3(0,i)
	
    if isrgn==false then
      if name:sub(1,10)~="_Shownote:" and 
		 name:sub(1,5)~="_Edit" and 
		 color~=ultraschall.planned_marker_color 
		 then 
			count=count+1 
	  end
    end
    if number>=0 and wentfine==0 and count==number then
        retnumber=retval 
        markername=name
        retidxnum=markrgnindexnumber
        position=pos
        wentfine=1
        Aretval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
    end
  end
  
  -- return the found marker
  if wentfine==1 then return retnumber, retidxnum, position, markername, guid
  else return -1
  end
end

--Aretnumber, Aretidxnum, Aposition, Amarkername = ultraschall.EnumerateNormalMarkers(0)


function ultraschall.EnumerateEditMarkers(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateEditMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retnumber, integer shown_number, number position, string edittitle, string guid = ultraschall.EnumerateEditMarkers(integer edit_index)</functioncall>
  <description>
    Gets the data of an edit marker.
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer retnumber - overallmarker/regionnumber of marker beginning with 1 for the first marker; ignore the order of first,second,etc creation of
                       - markers but counts from position 00:00:00 to end of project. So if you created a marker at position 00:00:00 and move the first created marker to
                       - the end of the timeline, it will be the last one, NOT the first one in the retval! For use with reaper's own marker-functions.
     integer shown_number - indexnumber of the marker
     number position - the position of the marker
     string edittitle  - the name of the marker
     string guid - the guid of the editmarker
  </retvals>
  <parameters>
    integer edit_index - number of the edit-marker. Refer <a href="#CountEditMarkers">ultraschall.CountEditMarkers</a> for getting the number of edit-markers.
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, enumerate, edit, edit marker, guid</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateEditMarkers", "edit_index", "must be an integer", -1) return -1 end
  
  -- prepare variables
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local number=number-1
  local wentfine=0
  local count=-1
  local retnumber=0
  local retidxnum=""
  local editname=""
  local position=0
  local Aretval, guid
  
  -- find the correct edit-marker
  for i=0, a-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if name:sub(1,5)=="_Edit" then count=count+1 end 
      if number>=0 and wentfine==0 and count==number then 
          retnumber=retval 
          editname=name:sub(7,-1)
          retidxnum=markrgnindexnumber
          position=pos
          wentfine=1
          Aretval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
      end
    end
  end
  
  -- return the found edit-marker
  if wentfine==1 then return retnumber, retidxnum, position, editname, guid
  else return -1
  end
end


function ultraschall.GetAllEditMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllEditMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_editmarkers, array editmarkersarray = ultraschall.GetAllEditMarkers()</functioncall>
  <description>
    returns the number of editmarkers and an array with each editmarker in the format:
    
        editmarkersarray[index][0] - position
        editmarkersarray[index][1] - name
        editmarkersarray[index][2] - idx
        editmarkersarray[index][3] - guid
        
  </description>
  <retvals>
    integer number_of_editmarkers - the number of editmarkers returned
    array editmarkersarray  - an array with all the edit-markers of the project
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, get, get all, edit, edit marker, guid</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local count=ultraschall.CountEditMarkers()
  local editmarkersarray = {}
  
  -- find all edit-markers and add their attributes to the editmarkersarray
  for i=1, count do
    editmarkersarray[i]={}
    local idx,b,position,name,guid=ultraschall.EnumerateEditMarkers(i)
    editmarkersarray[i][0]=position
    editmarkersarray[i][1]=name
    editmarkersarray[i][2]=idx
    editmarkersarray[i][3]=guid
  end

  -- return results
  return count, editmarkersarray
end

--A,AA, AAA=ultraschall.GetAllEditMarkers()

function ultraschall.GetAllNormalMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllNormalMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>index number_of_normalmarkers, array normalmarkersarray = ultraschall.GetAllNormalMarkers()</functioncall>
  <description>
    returns the number of normalmarkers and an array with each normalmarker in the format:
    
    normalmarkersarray[index][0] - position
    normalmarkersarray[index][1] - name
    normalmarkersarray[index][2] - idx of the marker within all markers in project
    normalmarkersarray[index][3] - the shown index number of the marker
    normalmarkersarray[index][4] - the guid of the marker
    
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
  </description>
  <retvals>
    integer number_of_normalmarkers - the number of normalmarkers returned
    array normalmarkersarray  - an array, that holds all normal markers of the project
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, get, get all, normal, normal marker, guid</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local count=ultraschall.CountNormalMarkers()
  local normalmarkersarray = {}
  
  -- find all normal markers and add theyre attributes to normalmarkersarray
  for i=1, count do
    normalmarkersarray[i]={}
    local idx,shown,position,name,guid=ultraschall.EnumerateNormalMarkers(i)
    normalmarkersarray[i][0]=position
    normalmarkersarray[i][1]=name
    normalmarkersarray[i][2]=idx
    normalmarkersarray[i][3]=shown
    normalmarkersarray[i][4]=guid
  end

  -- return results
  return count, normalmarkersarray
end

function ultraschall.GetAllMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall> integer number_of_all_markers, array allmarkersarray = ultraschall.GetAllMarkers()</functioncall>
  <description>
    To get all Markers in the project(normal, edit, chapter), regardless of their category.
    Doesn't return regions!
    
    returns the number of markers and an array with each marker in the format:
    
        markersarray[index][0] - position
        markersarray[index][1] - name
        markersarray[index][2] - indexnumber of the marker within all markers in the project
        markersarray[index][3] - the shown index-number
        markersarray[index][4] - the color of the marker
        markersarray[index][5] - the guid of the marker
        
  </description>
  <retvals>
    integer number_of_allmarkers - the number of markers returned
    array allmarkersarray  - an array, that holds all markers(not regions!) of the project
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, get, get all, guid</tags>
</US_DocBloc>
--]]
  -- prepare variable
  local count,aa,bb= reaper.CountProjectMarkers(0)
  local markersarray = {}

  -- get all markers and add their attributes to markersarray
  for i=1, count do
    markersarray[i]={}
    local retval, isrgn, position, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i-1)
    markersarray[i][0]=position
    markersarray[i][1]=name
    markersarray[i][2]=retval-1
    markersarray[i][3]=markrgnindexnumber
    markersarray[i][4]=color
    retval, markersarray[i][5] = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..retval-1, "", false)
  end

  -- return results
  return count, markersarray
end

function ultraschall.SetNormalMarker(number, position, shown_number, markertitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetNormalMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> boolean retval = ultraschall.SetNormalMarker(integer number, number position, integer shown_number, string markertitle)</functioncall>
  <description>
     Sets values of a normal Marker(no _Chapter:, _Shownote:, etc). Returns true if successful and false if not(i.e. marker doesn't exist)
     
     Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
     
     returns false in case of an error
  </description>
  <parameters>
    integer number - the number of the normal marker
    number position - position of the marker in seconds
    integer shown_number - the number of the marker
    string markertitle - title of the marker
  </parameters>
  <retvals>
     boolean retval  - true if successful and false if not(i.e. marker doesn't exist)
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, set, set normal, normal marker</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(position)~="number" and position~=nil then ultraschall.AddErrorMessage("SetNormalMarker", "position", "must be a number", -1) return false end
  if position==nil or position<0 then position=-1 end
  if tonumber(shown_number)==nil then shown_number=-1 end
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("SetNormalMarker", "number", "must be an integer", -2) return false end
  
  -- prepare variable
  local color=0
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  number=tonumber(number)-1
  local wentfine=0
  local count=-1
  local retnumber=0
  
  -- find the right marker, that shall be changed
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==false then
      if name:sub(1,10)~="_Shownote:" and name:sub(1,5)~="_Edit" and color~=ultraschall.planned_marker_color then count=count+1 end
    end
    if number>=0 and wentfine==0 and count==number then
        if tonumber(position)==-1 or position==nil then position=pos end
        if tonumber(shown_number)<=-1 or shown_number==nil then shown_number=markrgnindexnumber end
        if markertitle==nil then markertitle=name end
        retnumber=i
        wentfine=1
    end
  end
  
  if markertitle==nil then markertitle="" end
  
  -- alter marker, if existing
  if wentfine==1 then return reaper.SetProjectMarkerByIndex(0, retnumber, 0, position, 0, shown_number, markertitle, 0)
  else ultraschall.AddErrorMessage("SetNormalMarker", "number", "no such marker", -3) return false
  end
end

--A=ultraschall.SetNormalMarker(0,nil,3,"hu")

function ultraschall.SetEditMarker(number, position, shown_number, edittitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEditMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> boolean retval = ultraschall.SetEditMarker(integer edit_index, number position, integer shown_number, string edittitle)</functioncall>
  <description>
    Sets values of an Edit Marker. Returns true if successful and false if not(i.e. marker doesn't exist)
    
    returns false in case of an error
  </description>
  <parameters>
    integer edit_index - the number of the edit marker
    number position - position of the marker in seconds
    integer shown_number - the number of the marker
    string markertitle - title of the marker
  </parameters>
  <retvals>
     boolean retval  - true if successful and false if not(i.e. marker doesn't exist)
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, set, set edit, edit marker</tags>
</US_DocBloc>
--]]
  
  -- check parameters
  if type(position)~="number" and position~=nil then ultraschall.AddErrorMessage("SetEditMarker", "position", "must be a number", -1) return false end
  if position==nil or position<0 then position=-1 end
  if tonumber(shown_number)==nil then shown_number=-1 end
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("SetEditMarker", "edit_index", "must be an integer", -2) return false end

  -- prepare variables
  local color=ultraschall.ConvertColor(255,0,0)  
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  number=tonumber(number)-1
  local wentfine=0
  local count=-1
  local retnumber=0
  
  -- look for the right edit-marker to change
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if name:sub(1,5)=="_Edit" then count=count+1 end 
      if number>=0 and wentfine==0 and count==number then 
          if tonumber(position)==-1 or position==nil then position=pos end
          if tonumber(shown_number)<=-1 or shown_number==nil then shown_number=markrgnindexnumber end
          if edittitle==nil then edittitle=name:match("(_Edit:.*)") edittitle=edittitle:sub(7,-1) end
          retnumber=i
          wentfine=1
      end
    end
  end
  
  if edittitle==nil then edittitle="" end
  
  -- change edit-marker, if existing
  if wentfine==1 then return reaper.SetProjectMarkerByIndex(0, retnumber, 0, position, 0, shown_number, "_Edit:" .. edittitle, color)
  else ultraschall.AddErrorMessage("SetEditMarker", "edit_index", "no such edit-marker", -3) return false
  end
end


function ultraschall.SetPodRangeRegion(startposition, endposition)
-- Sets _PodRange:-Marker
-- startposition - startposition in seconds, must be positive value
-- endposition - endposition in seconds, must be bigger than startposition
-- returns -1 if it fails
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPodRangeRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.SetPodRangeRegion(number startposition, number endposition)</functioncall>
  <description>
    Sets "_PodRange:"-Region
    
    returns -1 if it fails.
  </description>
  <parameters>
    number startposition - begin of the podcast in seconds
    number endposition - end of the podcast in seconds
  </parameters>
  <retvals>
     integer retval  - number of the region, -1 if it fails
  </retvals>
  <chapter_context>
    Markers
    PodRange Region
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, set, set podrange, podrange region, region</tags>
</US_DocBloc>
--]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("SetPodRangeRegion", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("SetPodRangeRegion", "endposition", "must be a number", -2) return -1 end
  return ultraschall.AddPodRangeRegion(startposition, endposition)
end

function ultraschall.DeletePodRangeRegion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeletePodRangeRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.DeletePodRangeRegion()</functioncall>
  <description>
    deletes the PodRange-Region. 
    
    Returns false if unsuccessful
  </description>
  <retvals>
    boolean retval - true, if deleting was successful; false, if not
  </retvals>
  <chapter_context>
    Markers
    PodRange Region
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, delete, delete podrange, podrange region, region</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local a,nummarkers,numregions=reaper.CountProjectMarkers(0)
  local count=0
  local itworked=false
  
  -- look for podrange-region and remove it when found
  for i=nummarkers+numregions, 0, -1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,10)=="_PodRange:" and isrgn==true then itworked=reaper.DeleteProjectMarkerByIndex(0,i) end 
  end
  if itworked==false then ultraschall.AddErrorMessage("DeletePodRangeRegion", "", "no _Podrange-region found", -1) return false end
  return itworked
end


function ultraschall.DeleteNormalMarker(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteNormalMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> boolean retval = ultraschall.DeleteNormalMarker(integer number)</functioncall>
  <description>
    Deletes a Normal-Marker. Returns true if successful and false if not(i.e. marker doesn't exist) Use <a href="#EnumerateNormalMarkers">ultraschall.EnumerateNormalMarkers</a> to get the correct number.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <parameters>
    integer number - number of a normal marker
  </parameters>
  <retvals>
     boolean retval  - true, if successful, false if not
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, delete, normal marker, normal</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("DeleteNormalMarker", "number", "must be a number", -1) return false end

  -- prepare variables
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  local number=number-1
  local wentfine=0
  local count=-1
  local retnumber=0
  
  -- look for the right normal marker
  for i=1, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if name:sub(1,10)~="_Shownote:" and name:sub(1,5)~="_Edit" and color~=ultraschall.planned_marker_color then count=count+1 end
    end
    if number>=0 and wentfine==0 and count==number then
        retnumber=i
        wentfine=1
    end
  end
  
  -- remove the found normal-marker, if existing
  if wentfine==1 then return reaper.DeleteProjectMarkerByIndex(0, retnumber)
  else ultraschall.AddErrorMessage("DeleteNormalMarker", "number", "no such normal-marker found", -2) return false
  end
end


function ultraschall.DeleteEditMarker(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteEditMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> boolean retval = ultraschall.DeleteEditMarker(integer edit_index)</functioncall>
  <description>
    Deletes an _Edit:-Marker. Returns true if successful and false if not(i.e. marker doesn't exist) Use <a href="#EnumerateEditMarkers">ultraschall.EnumerateEditMarkers</a> to get the correct number.
  </description>
  <parameters>
    integer edit_index - number of an edit marker
  </parameters>
  <retvals>
     boolean retval  - true, if successful, false if not
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, delete, edit marker, edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("DeleteEditMarker", "edit_index", "must be integer", -1) return false end
  
  -- prepare variables
  number=number-1
  local wentfine=0
  local count=-1
  local retnumber=0
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  
  -- look for correct _Edit-marker
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,5)=="_Edit" then count=count+1 end 
    if number>=0 and wentfine==0 and count==number then 
        retnumber=i
        wentfine=1
    end
  end
  
  -- remove found _Edit-marker, if any
  if wentfine==1 then return reaper.DeleteProjectMarkerByIndex(0, retnumber)
  else ultraschall.AddErrorMessage("DeleteEditMarker", "edit_index", "no such _Edit-marker found", -2) return false
  end
end


function ultraschall.ExportEditMarkersToFile(filename_with_path, PodRangeStart, PodRangeEnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ExportEditMarkersToFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.ExportEditMarkersToFile(string filename_with_path, number PodRangeStart, number PodRangeEnd)</functioncall>
  <description>
    Export Edit-Markers (not regions!) to filename_with_path. 
    
    Each line in the exportfile contains an entry for such an edit-marker in the format:
    
    hh:mm:ss.mss Title
    
    Returns -1 in case of error.
  </description>
  <retvals>
     integer retval  - 1 in case of success, -1 if it failed
  </retvals>
  <parameters>
    string filename_with_path - the name of the export-file
     number PodRangeStart - beginning of the podcast in seconds
     number PodRangeEnd - end of the podcast in seconds
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, export, file, edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ExportEditMarkersToFile", "filename_with_path", "must be a filename", -1) return -1 end
  PodRangeStart=tonumber(PodRangeStart)
  PodRangeEnd=tonumber(PodRangeEnd)
  if PodRangeStart==nil then PodRangeStart=0 end
  if PodRangeStart<0 then ultraschall.AddErrorMessage("ExportEditMarkersToFile", "PodRangeStart", "must be a number>=0", -2) return -1 end
  if PodRangeEnd==nil then PodRangeEnd=reaper.GetProjectLength(0) end
  if PodRangeEnd<PodRangeStart then ultraschall.AddErrorMessage("ExportEditMarkersToFile", "PodRangeEnd", "must be bigger than PodRangeStart", -3) return -1 end
  
  -- prepare variables
  number=ultraschall.CountEditMarkers()  
  local timestring="00:00:00.000"
  
  -- open exportfile
  local file=io.open(filename_with_path,"w")
  if file==nil then ultraschall.AddErrorMessage("ExportEditMarkersToFile", "filename_with_path", "exportfile can't be created", -4) return -1 end
  
  -- write editmarkers to exportfile
  for i=1,number do
    local idx,shown_number,pos,name=ultraschall.EnumerateEditMarkers(i)
    if pos>=PodRangeStart and pos<=PodRangeEnd then
      pos=pos-PodRangeStart
      timestring=ultraschall.SecondsToTime(pos)
      file:write(timestring.." "..name.."\n")
    end
  end
  
  -- close file and return
  local fileclose=io.close(file)
  return 1
end


function ultraschall.ExportNormalMarkersToFile(filename_with_path, PodRangeStart, PodRangeEnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ExportNormalMarkersToFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.ExportNormalMarkersToFile(string filename_with_path, number PodRangeStart, number PodRangeEnd)</functioncall>
  <description>
    Export Normal-Markers to filename_with_path. Returns -1 in case of error.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer retval  - 1 in case of success, -1 if it failed
  </retvals>
  <parameters>
    string filename_with_path - the name of the export-file
     number PodRangeStart - beginning of the podcast in seconds
     number PodRangeEnd - end of the podcast in seconds
  </parameters>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, export, file, normal</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ExportNormalMarkersToFile", "filename_with_path", "must be a filename", -1) return -1 end
  PodRangeStart=tonumber(PodRangeStart)
  PodRangeEnd=tonumber(PodRangeEnd)
  if PodRangeStart==nil then PodRangeStart=0 end
  if PodRangeStart<0 then ultraschall.AddErrorMessage("ExportNormalMarkersToFile", "PodRangeStart", "must be a number>=0", -2) return -1 end
  if PodRangeEnd==nil then PodRangeEnd=reaper.GetProjectLength(0) end
  if PodRangeEnd<PodRangeStart then ultraschall.AddErrorMessage("ExportNormalMarkersToFile", "PodRangeEnd", "must be bigger than PodRangeStart", -3) return -1 end
  
  -- prepare variables
  local number=ultraschall.CountNormalMarkers()    
  local timestring="00:00:00.000"
  
  -- open file for write; return with error if impossible
  local file=io.open(filename_with_path,"w")  
  if file==nil then ultraschall.AddErrorMessage("ExportNormalMarkersToFile", "filename_with_path", "file can't be opened", -4) return -1 end
  
  -- write normal markers to fil
  for i=1,number do
    local idx,shown_number,pos,name, URL=ultraschall.EnumerateNormalMarkers(i)
    if pos>=PodRangeStart and pos<=PodRangeEnd then
      pos=pos-PodRangeStart
      timestring=ultraschall.SecondsToTime(pos)
      file:write(timestring.." "..name.."\n")
    end
  end
  
  -- close file and return
  local fileclose=io.close(file)
  return 1
end 

function ultraschall.ImportEditFromFile(filename_with_path,PodRangeStart)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ImportEditFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> array editmarkers = ultraschall.ImportEditFromFile(string filename_with_path, PodRangestart)</functioncall>
  <description>
    Imports editentries from a file and returns an array of the imported values.
    
    returns -1 in case of error
  </description>
  <parameters>
    string filename_with_path - markerfile to be imported
    number PodRangeStart - podcast-start-offset
  </parameters>
  <retvals>
     array chapters  - array[0] is position of marker+PodRangeStart, array[1] is name of the marker
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, import, file, edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path) ~= "string" then ultraschall.AddErrorMessage("ImportEditFromFile", "filename_with_path", "must be a filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ImportEditFromFile", "filename_with_path", "file does not exist", -2) return -1 end
  PodRangeStart=tonumber(PodRangeStart)
  if PodRangeStart==nil then PodRangeStart=0 end
  
  -- prepare variables
  local markername=""
  local entry=0  
  local table = {}
      
  -- read entries from file and split them into time and name; add time and name to new entries in table
  for line in io.lines(filename_with_path) do
    entry=entry+1
    table[entry]={}
    time=ultraschall.TimeToSeconds(line:match("%d*:%d*:%d*.%d*"))+PodRangeStart
    markername=line:match("%s.*")
    if markername==nil then markername="_Edit"
    else markername="_Edit:"..markername
    end
    if time<0 then return -1 end
  
    table[entry][0]=time
    table[entry][1]=markername
  end
  
  -- return resulting marker-table
  return table
end

function ultraschall.ImportMarkersFromFile(filename_with_path,PodRangeStart)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ImportMarkersFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> array markers = ultraschall.ImportMarkersFromFile(string filename_with_path, PodrangeStart)</functioncall>
  <description>
    Imports markerentries from a file and returns an array of the imported values.
    
    returns -1 in case of error
  </description>
  <parameters>
    string filename_with_path - markerfile to be imported
    number PodRangeStart - podcast-start-offset
  </parameters>
  <retvals>
     array chapters  - array[0] is position of marker+PodRangeStart, array[1] is name of the marker
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, import, file</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path) ~= "string" then ultraschall.AddErrorMessage("ImportMarkersFromFile", "filename_with_path", "must be a filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ImportMarkersFromFile", "filename_with_path", "file does not exist", -2) return -1 end
  PodRangeStart=tonumber(PodRangeStart)
  if PodRangeStart==nil then PodRangeStart=0 end
  
  -- prepare variables
  local markername=""
  local entry=0  
  local table = {}
      
  -- read entries from file and split them into time and name; add time and name to new entries in table
  for line in io.lines(filename_with_path) do
    entry=entry+1
    table[entry]={}
    time=ultraschall.TimeToSeconds(line:match("%d*:%d*:%d*.%d*"))+PodRangeStart
    markername=line:match("%s.*")
    if markername==nil then markername=""
    end
    if time<0 then return -1 end
  
    table[entry][0]=time
    table[entry][1]=markername:sub(2,-1)
  end
  
  -- return resulting marker-table
  return table
end

function ultraschall.MarkerToEditMarker(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerToEditMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer idx, integer shown_number, number position, string markertitle = ultraschall.MarkerToEditMarker(integer markerindex)</functioncall>
  <description>
    Converts a normal-marker to an edit-marker.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer idx - overallmarker/regionnumber of marker beginning with 1 for the first marker; ignore the order of first,second,etc creation of
    -markers but counts from position 00:00:00 to end of project. So if you created a marker at position 00:00:00 and move the first created marker to
    -the end of the timeline, it will be the last one, NOT the first one in the retval! For use with reaper's own marker-functions.
     integer shown_number - the shown number of the marker
     number position - the position of the marker in seconds
     string markertitle  - the markertitle
  </retvals>
  <parameters>
    integer markerindex - number of the normal-marker. Refer <a href="#CountNormalMarkers">ultraschall.CountNormalMarkers</a> for getting the number of normal-markers.
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, convert, edit, normal</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("MarkerToEditMarker", "merkerindex", "must be an integer", -1) return -1 end
  if number<1 then ultraschall.AddErrorMessage("MarkerToEditMarker", "markerindex", "must be greater than 0", -2) return -1 end
  
  -- prepare variables and get old marker-attributes
  local color = ultraschall.ConvertColor(255,0,0)
  local idx, shownmarker, position, markername = ultraschall.EnumerateNormalMarkers(number)
  if idx==-1 then  ultraschall.AddErrorMessage("MarkerToEditMarker", "markerindex", "no such normal marker", -3) return -1 end
  
  -- change the found marker to edit
  local itworks=reaper.SetProjectMarkerByIndex(0, idx-1, false, position, 0, shownmarker, "_Edit: "..markername, color)
  
  -- return the altered marker
  return idx, shownmarker, position, markername
end

--A,AA,AAA,AAAA=ultraschall.MarkerToEditMarker(nil)


function ultraschall.EditToMarker(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EditToMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer idx, integer shown_number, number position, string markertitle = ultraschall.EditToMarker(integer edit_index)</functioncall>
  <description>
    Converts an edit-marker to a normal marker.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer idx - overallmarker/regionnumber of marker beginning with 1 for the first marker; ignore the order of first,second,etc creation of
    -markers but counts from position 00:00:00 to end of project. So if you created a marker at position 00:00:00 and move the first created marker to
    -the end of the timeline, it will be the last one, NOT the first one in the retval! For use with reaper's own marker-functions.
     integer shown_number - the shown number of the marker
     number position - the position of the marker in seconds
     string markertitle  - the markertitle
  </retvals>
  <parameters>
    integer edit_index - number of the edit-marker. Refer <a href="#CountEditMarkers">ultraschall.CountEditMarkers</a> for getting the number of edit-markers.
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, convert, normal, edit</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EditToMarker", "edit_index", "must be an integer", -1) return -1 end
  if number<1 then ultraschall.AddErrorMessage("EditToMarker", "edit_index", "must be greater than 0", -2) return -1 end
  
  -- prepare variables and get old marker-attributes  
  local color = ultraschall.ConvertColor(100,100,100)  
  local idx, shownmarker, position, markername = ultraschall.EnumerateEditMarkers(number)
  if idx==-1 then ultraschall.AddErrorMessage("EditToMarker", "edit_index", "no such edit-marker", -3) return -1 end

  -- change the found edit-marker to a normal marker
  if markername=="" then 
    reaper.DeleteProjectMarkerByIndex(0, number-1)
    reaper.AddProjectMarker2(0, false, position, 0, markername:match("%s%d*(.*)"), shownmarker, 0)
  else 
    reaper.DeleteProjectMarkerByIndex(0, number-1)
    reaper.AddProjectMarker2(0, false, position, 0, markername:match("%s%d*(.*)"), shownmarker, 0)
  end

  -- return altered marker-attributes
  return idx, shownmarker, position, markername
end

function ultraschall.GetMarkerByScreenCoordinates(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerByScreenCoordinates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string marker = ultraschall.GetMarkerByScreenCoordinates(integer xmouseposition)</functioncall>
  <description>
    returns the markers at a given absolute-x-pixel-position. It sees markers according their graphical representation in the arrange-view, not just their position! Returned string will be "Markeridx\npos\nName\nMarkeridx2\npos2\nName2\n...".
    Will return "", if no marker has been found.
    
    Returns only markers, no time markers or regions!
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all markernumbers, markerpositions and markertitles, separated by a newline. 
    -Can contain numerous markers, if there are more markers in one position.
  </retvals>
  <parameters>
    integer xmouseposition - the absolute x-screen-position, like current mouse-position
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get marker, position, marker</tags>
</US_DocBloc>
]]
  if math.type(xmouseposition)~="integer" then ultraschall.AddErrorMessage("GetMarkerByScreenCoordinates", "xmouseposition", "must be an integer", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  
  local retstring=""
  local temp
  
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=nine
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=eight
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=seven
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=six
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=five
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=four
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=three
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=two
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=one
      end
      local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, xmouseposition-temp,xmouseposition) 
      local ALABAMA=xmouseposition
      if pos>=Ax and pos<=AAx then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name end
    end
  end
  return retstring--:match("(.-)%c.-%c")), tonumber(retstring:match(".-%c(.-)%c")), retstring:match(".-%c.-%c(.*)")
end

function ultraschall.GetMarkerByTime(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerByTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers = ultraschall.GetMarkerByTime(number position)</functioncall>
  <description>
    returns the markers at a given project-position in seconds. 
    It sees markers according their actual graphical representation in the arrange-view, not just their position. 
    If, for example, you pass to it the current playposition, the function will return the marker as long as the playcursor is behind the marker-graphics.
    
    Returned string will be "Markeridx\npos\nName\nMarkeridx2\npos2\nName2\n...".
    Will return "", if no marker has been found.
    
    Returns only markers, no time markers or regions!
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all markernumbers, markerpositions and markertitles, separated by a newline. 
    -Can contain numerous markers, if there are more markers in one position.
  </retvals>
  <parameters>
    number position - the time-position in seconds
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get marker, position, marker</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("GetMarkerByTime", "position", "must be a number", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  local retstring=""
  local temp
  
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=nine
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=eight
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=seven
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=six
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=five
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=four
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=three
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=two
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=one
      end 
      local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.GetResourcePath()..ultraschall.Separator.."reaper.ini")
      local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, ARetval2+57-temp,ARetval2+57) 
      local Bx=AAx-Ax
      if Bx+pos>=position and pos<=position then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name end      
    end
  end
  return retstring
end


function ultraschall.GetRegionByScreenCoordinates(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRegionByScreenCoordinates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers = ultraschall.GetRegionByScreenCoordinates(integer xmouseposition)</functioncall>
  <description>
    returns the regions at a given absolute-x-pixel-position. It sees regions according their graphical representation in the arrange-view, not just their position! Returned string will be "Regionidx\npos\nName\nRegionidx2\npos2\nName2\n...".
    Returns only regions, no time markers or other markers!
    Will return "", if no region has been found.
        
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all regionnumbers, regionpositions and regionnames, separated by a newline. 
    -Can contain numerous regions, if there are more regions in one position.
  </retvals>
  <parameters>
    integer xmouseposition - the absolute x-screen-position, like current mouse-position
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get region, position, region</tags>
</US_DocBloc>
]]
  if math.type(xmouseposition)~="integer" then ultraschall.AddErrorMessage("GetRegionByScreenCoordinates", "xmouseposition", "must be an integer", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  
  local retstring=""
  local temp
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local ALABAMA=xmouseposition
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=nine
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=eight
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=seven
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=six
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=five
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=four
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=three
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=two
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=one
      end
      local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, xmouseposition-temp,xmouseposition) 
      if pos>=Ax and pos<=AAx then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name.."\n" 
      elseif Ax>=pos and Ax<=rgnend then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name
      end
    end
  end
  return retstring
end

function ultraschall.GetRegionByTime(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRegionByTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers = ultraschall.GetRegionByTime(number position)</functioncall>
  <description>
    returns the regions at a given absolute-x-pixel-position. It sees regions according their graphical representation in the arrange-view, not just their position! Returned string will be "Regionidx\npos\nName\nRegionidx2\npos2\nName2\n...".
    Returns only regions, no timesignature-markers or other markers!
    Will return "", if no region has been found.
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all regionnumbers, regionpositions and regionnames, separated by a newline. 
    -Can contain numerous regions, if there are more regions in one position.
  </retvals>
  <parameters>
    number position - position in seconds
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get region, position, region</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("GetRegionByTime", "position", "must be a number", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  
  local retstring=""
  local temp
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=nine
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=eight
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=seven
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=six
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=five
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=four
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=three
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=two
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=one
      end
      local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.GetResourcePath()..ultraschall.Separator.."reaper.ini")
      local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, ARetval2+57-temp,ARetval2+57) 
      local Bx=AAx-Ax
      if Bx+pos>=position and pos<=position then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name.."\n"
      elseif pos<=position and rgnend>=position then retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name
      end
    end
  end
  return retstring
end

function ultraschall.GetTimeSignaturesByScreenCoordinates(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTimeSignaturesByScreenCoordinates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers = ultraschall.GetTimeSignaturesByScreenCoordinates(integer xmouseposition)</functioncall>
  <description>
    returns the time-signature/tempo-marker at a given absolute-x-pixel-position. It sees time-signature/tempo-markers according their graphical representation in the arrange-view, not just their position! Returned string will be "tempomarkeridx\npos\ntempomarkeridx2\npos2\n...".
    Returns only time-signature-markers, no regions or other markers!
    Will return "", if no timesig-marker has been found.
        
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all markernumbers and markerpositions, separated by a newline. 
    -Can contain numerous markers, if there are more markers in one position.
  </retvals>
  <parameters>
    integer xmouseposition - the absolute x-screen-position, like current mouse-position
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get region, position, time signature, tempo, marker, tempo marker</tags>
</US_DocBloc>
]]
  if math.type(xmouseposition)~="integer" then ultraschall.AddErrorMessage("GetTimesignaturesByScreenCoordinates", "xmouseposition", "must be an integer", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  
  local retstring=""
  local temp
  
  local timeretval = reaper.CountTempoTimeSigMarkers(0)
  for i=0, timeretval-1 do
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
    temp=one
    
    local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, xmouseposition-temp,xmouseposition) 
    local ALABAMA=xmouseposition
    if timepos>=Ax and timepos<=AAx then retstring=retstring..i.."\n"..timepos.."\n" end
  end
  return retstring
end

function ultraschall.GetTimesignaturesByScreenCoordinates(xmouseposition)
  return ultraschall.GetTimeSignaturesByScreenCoordinates(xmouseposition)
end


function ultraschall.GetTimeSignaturesByTime(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTimeSignaturesByTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers = ultraschall.GetTimeSignaturesByTime(number position)</functioncall>
  <description>
    returns the time-signature/tempo-marker at a given absolute-x-pixel-position. It sees time-signature/tempo-markers according their graphical representation in the arrange-view, not just their position! Returned string will be "tempomarkeridx\npos\ntempomarkeridx2\npos2\n...".
    Returns only time-signature-markers, no other markers or regions!
    Will return "", if no timesig-marker has been found.
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all markernumbers and markerpositions, separated by a newline. 
    -Can contain numerous markers, if there are more markers in one position.
  </retvals>
  <parameters>
    number position - position in seconds
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get region, position, time signature, tempo, marker, tempo marker</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("GetTimeSignaturesByTime", "position", "must be a number", -1) return nil end
  local one,two,three,four,five,six,seven,eight,nine,ten,scale
  local retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

  if dpi=="512" then scale=2 else scale=1 end 
  ten=84*scale
  nine=76*scale
  eight=68*scale
  seven=60*scale
  six=52*scale
  five=44*scale
  four=36*scale
  three=28*scale
  two=20*scale
  one=12*scale
  
  local retstring=""
  local temp
  
  local timeretval = reaper.CountTempoTimeSigMarkers(0)
  for i=0, timeretval-1 do
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
    temp=one    
    local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.GetResourcePath()..ultraschall.Separator.."reaper.ini")
    local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, ARetval2+57-temp,ARetval2+57) 
    local Bx=AAx-Ax
    if Bx+timepos>=position and timepos<=position then retstring=retstring..i.."\n"..timepos.."\n" end
  end
  return retstring
end


function ultraschall.IsMarkerEdit(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMarkerEdit</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsMarkerEdit(integer markerid)</functioncall>
  <description>
    returns true, if the marker is an edit-marker, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's an edit-marker, false if not
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, check, edit marker, edit</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("IsMarkerEdit","markerid", "must be an integer", -1) return nil end

  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, markerid)
  if retval>0 then
    if isrgn==false then
      if name:sub(1, 5)=="_Edit" then return true      
      else return false
      end
    end
  end
  return false
end


function ultraschall.IsMarkerNormal(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMarkerNormal</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsMarkerNormal(integer markerid)</functioncall>
  <description>
    returns true, if the marker is a normal-marker, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's an normal-marker, false if not
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
  </parameters>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, check, normal marker, normal</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("IsMarkerNormal","markerid", "must be an integer", -1) return nil end

  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, markerid)
  if retval>0 then
    if isrgn==false then
      if name:sub(1,10)~="_Shownote:" and name:sub(1,5)~="_Edit" and color~=ultraschall.planned_marker_color then return true
      else return false
      end
    end
  end
  return false
end

function ultraschall.IsRegionPodrange(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsRegionPodrange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsRegionPodrange(integer markerid)</functioncall>
  <description>
    returns true, if the marker is a Podrange-region, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's a PodRange-Region, false if not
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
  </parameters>
  <chapter_context>
    Markers
    PodRange Region
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, check, podrangeregion, podrange, region</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("IsRegionPodrange","markerid", "must be an integer", -1) return nil end
  
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, markerid)
  if retval>0 then
    if isrgn==true then
     if name:sub(1, 10)=="_PodRange:" then return true      
     else return false
     end
    end
  end
  return false
end

function ultraschall.IsRegionEditRegion(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsRegionEditRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsRegionEditRegion(integer markerid)</functioncall>
  <description>
    returns true, if the marker is an Edit-region, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's an Edit-Region, false if not
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, check, edit region, edit, region</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("IsRegionEditRegion","markerid", "must be an integer", -1) return nil end
  
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, markerid)
  if retval>0 then
    if isrgn==true then
      if name:sub(1, 5)=="_Edit" then return true      
      else return false
      end
    end
  end
  return false
end

function ultraschall.AddEditRegion(startposition, endposition, text)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddEditRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer markernr, string guid = ultraschall.AddEditRegion(number startposition, number endposition, string text)</functioncall>
  <description>
    Adds a new edit-region and returns index of the newly created edit-marker-region.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer markernr - the number of the newly created region
    string guid - the guid, associated with this edit-region
  </retvals>
  <parameters>
    number startposition - startposition in seconds
    number endposition - endposition in seconds
    string text - the title of the marker
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, add, edit region, edit, region, guid</tags>
</US_DocBloc>
]]
  local color=0
  local retval=0
  local isrgn=true
  local pos=0
  local rgnend=0
  local name=""
  local markrgnindexnumber=""
  local noteID=0
  
  local Os = reaper.GetOS()
  if string.match(Os, "OSX") then 
    color = 0xFF0000|0x1000000
  else
    color = 0x0000FF|0x1000000
  end
  
  local count=0
  if type(startposition)~="number" then ultraschall.AddErrorMessage("AddEditRegion", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("AddEditRegion", "endposition", "must be a number", -2) return -1 end
  if startposition<0 then ultraschall.AddErrorMessage("AddEditRegion", "startposition", "must be bigger than 0", -3) return -1 end
  if endposition<startposition then ultraschall.AddErrorMessage("AddEditRegion", "endposition", "must be bigger than startposition", -4) return -1 end
  if text~=nil and type(text)~="string" then ultraschall.AddErrorMessage("AddEditRegion", "text", "must be a string or nil", -5) return -1 end
  if text==nil then text="" end
  
  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsRegionAtPosition(startposition)
  
  noteID=reaper.AddProjectMarker2(0, 1, startposition, endposition, "_Edit:"..text, 0, color)
  
  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsRegionAtPosition(startposition)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  if originals_array1[1]==nil then ultraschall.AddErrorMessage("AddEditRegion", "startposition", "there is already an edit-region at this position", -6) return -1 end
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  
  return originals_array1[1]-1, guid
end

--A=ultraschall.AddEditRegion(10,26,"")

function ultraschall.SetEditRegion(number, position, endposition, edittitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEditRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetEditRegion(integer number, number position, number endposition, string edittitle)</functioncall>
  <description>
    Sets the values of an already existing edit-region. To retain an already set position, endposition and/or edittitle, use nil.
    Returns true in case of success, false if not.
    Note: if you set the new beginning of the region before another region, the indexnumber of the edit-region changes. So if you want to set an edit-region repeatedly, you should get the indexnumber using <a href="#EnumerateEditRegion">ultraschall.EnumerateEditRegion</a>, or you might accidently change another region!
    
    returns -1 in case of an error
  </description>
  <retvals>
    boolean retval - true, in case of success, false if not
  </retvals>
  <parameters>
    integer number - the number of the edit-region, beginning with 1 for the first edit-region
    number startposition - startposition in seconds, nil to retain the old value
    number endposition - endposition in seconds, nil to retain the old value
    string text - the title of the marker, nil to retain the old value
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, set, edit region, edit, region</tags>
</US_DocBloc>
]]
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("SetEditRegion", "number", "must be an integer", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("SetEditRegion", "position", "must be a number", -2) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("SetEditRegion", "endposition", "must be a number", -3) return -1 end
  if edittitle~=nil and type(edittitle)~="string" then ultraschall.AddErrorMessage("SetEditRegion", "edittitle", "must be either a string or nil", -4) return -1 end
  if endposition<0 then ultraschall.AddErrorMessage("SetEditRegion", "endposition", "must be bigger than 0", -5) return -1 end
  if position<0 then ultraschall.AddErrorMessage("SetEditRegion", "position", "must be bigger than 0", -6) return -1 end
  if endposition<position then ultraschall.AddErrorMessage("SetEditRegion", "endposition", "must be bigger than position", -7) return -1 end

  local color=0
  local Os = reaper.GetOS()
  if string.match(Os, "OSX") then 
    color = 0xFF0000|0x1000000
  else
    color = 0x0000FF|0x1000000
  end
  
  local shown_number=-1
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  number=tonumber(number)-1
  local wentfine=0
  local count=-1
  local retnumber=0
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==true then
      if name:sub(1,5)=="_Edit" then count=count+1 end 
      if number>=0 and wentfine==0 and count==number then 
          if tonumber(position)==-1 or position==nil then position=pos end
          if tonumber(endposition)==-1 or position==nil then endposition=rgnend end
          if tonumber(shown_number)<=-1 or shown_number==nil then shown_number=markrgnindexnumber end
          if edittitle==nil then edittitle=name:match("(_Edit:.*)") edittitle=edittitle:sub(7,-1) end
          retnumber=i
          wentfine=1
      end
      end
  end
  
  if edittitle==nil then edittitle="" end
  
  if wentfine==1 then return reaper.SetProjectMarkerByIndex(0, retnumber, true, position, endposition, shown_number, "_Edit:" .. edittitle, color)
  else return false
  end
end

--A=ultraschall.SetEditRegion(1,10,200,"hula")

function ultraschall.DeleteEditRegion(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteEditRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteEditRegion(integer number)</functioncall>
  <description>
    Deletes an already existing edit-region.
    Returns true in case of success, false if not.
  </description>
  <retvals>
    boolean retval - true, in case of success, false if not
  </retvals>
  <parameters>
    integer number - the number of the edit-region, beginning with 1 for the first edit-region
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, delete, edit region, edit, region</tags>
</US_DocBloc>
]]   
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("DeleteEditRegion","number", "must be an integer", -1) return false end
  
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  local number=tonumber(number)-1
  local wentfine=0
  local count=-1
  local retnumber=-1
  for i=0, c-1 do
     local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==true then
      if name:sub(1,5)=="_Edit" then count=count+1 
        if count==number then retnumber=i end
      end 
    end
  end
  
  return reaper.DeleteProjectMarkerByIndex(0, retnumber)
  
end

--A=ultraschall.DeleteEditRegion(1)


function ultraschall.EnumerateEditRegion(number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateEditRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retval, number position, number endposition, string title, integer rgnindexnumber, string guid = ultraschall.EnumerateEditRegion(integer number)</functioncall>
  <description>
    Returns the values of an edit-region.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the overall marker-index-number of all markers in the project, -1 in case of error
    number position - position in seconds
    number endposition - endposition in seconds
    string title - the title of the region
    integer rgnindexnumber - the overall region index number, as used by other of Reaper's own marker-functions
    string guid - the guid of the edit-region
  </retvals>
  <parameters>
    integer number - the number of the edit-region, beginning with 1 for the first edit-region
  </parameters>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, get, enumerate, edit region, edit, region, guid</tags>
</US_DocBloc>
]]   
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateEditRegion","number", "must be an integer", -1) return -1 end
  
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  number=tonumber(number)-1
  local wentfine=-1
  local count=-1
  local retnumber=0
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==true then
      if name:sub(1,5)=="_Edit" then count=count+1  
        if count==number then wentfine=i end
      end
    end
  end
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber=reaper.EnumProjectMarkers(wentfine)
  local Aretval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..wentfine, "", false) 
  if wentfine~=-1 then return retval, pos, rgnend, name, markrgnindexnumber, guid
  else return -1
  end
end

function ultraschall.CountEditRegions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountEditRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.CountEditRegions()</functioncall>
  <description>
    returns the number of edit-regions in the project.
  </description>
  <retvals>
    integer retval - the number of edit-regions in the project
  </retvals>
  <chapter_context>
    Markers
    Edit Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, count, edit region, edit, region</tags>
</US_DocBloc>
]]  
  local c,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  for i=0, c do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if name:sub(1,6)=="_Edit:" and isrgn==true then count=count+1 end 
  end
  return count
end


function ultraschall.GetAllMarkersBetween(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMarkersBetween</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_all_markers, array allmarkersarray = ultraschall.GetAllMarkersBetween(optional number startposition, optional number endposition)</functioncall>
  <description>
    To get all Markers in the project(normal, edit, chapter), regardless of their category, between startposition and endposition.
    Doesn't return regions!
    
    returns the number of markers and an array with each marker in the format:
    
        markersarray[index][0] - position
        markersarray[index][1] - name
        markersarray[index][2] - indexnumber of the marker within all markers in the project
        markersarray[index][3] - the shown index-number
        markersarray[index][4] - the color of the marker
        markersarray[index][5] - the guid of the marker
    
    returns -1 in case of error
  </description>
  <retvals>
    integer number_of_allmarkers - the number of markers returned
    array allmarkersarray  - an array, that holds all markers(not regions!) of the project
  </retvals>
  <parameters>
    optional number startposition - the earliest position a returned marker may have; nil for projectposition 0
    optional number endposition - the latest position a returned marker may have; nil for end of project
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, get, get all between, guid</tags>
</US_DocBloc>
--]]
  if startposition~=nil and type(startposition)~="number" then ultraschall.AddErrorMessage("GetAllMarkersBetween","startposition", "Must be a number!", -1) return -1 end
  if endposition~=nil and type(endposition)~="number" then ultraschall.AddErrorMessage("GetAllMarkersBetween","endposition", "Must be a number!", -2) return -1 end
  if startposition==nil then startposition=0 end
  if endposition==nil then endposition = ultraschall.GetProjectLength(false,false,false,true) end
  if endposition<startposition then ultraschall.AddErrorMessage("GetAllMarkersBetween","endposition", "Must be bigger than startposition!", -3) return -1 end
  if startposition<0 then ultraschall.AddErrorMessage("GetAllMarkersBetween","startposition", "Must be bigger or equal 0!", -4) return -1 end
  local A,B=ultraschall.GetAllMarkers()
  for i=A, 1, -1 do
    if B[i][0]<startposition or B[i][0]>endposition then table.remove(B,i) A=A-1 end
  end
  return A,B
end

--A,B=ultraschall.GetAllMarkersBetween(80, 300)


function ultraschall.GetAllRegions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_all_regions, array allregionsarray = ultraschall.GetAllRegions()</functioncall>
  <description>
    To get all Regions in the project(normal, edit, chapter), regardless of their category.
    Doesn't return markers!
    
    returns the number of markers and an array with each marker in the format:
    
        regionarray[index][0] - position
        regionarray[index][1] - endposition
        regionarray[index][2] - name
        regionarray[index][3] - indexnumber of the region within all markers in the project. This is 1-based, unlike in Reaper's own API!
        regionarray[index][4] - the shown index-number
        regionarray[index][5] - the color of the region
        regionarray[index][6] - the guid of the region
        
    returns -1 in case of error
  </description>
  <retvals>
    integer number_of_allregions - the number of regions returned
    array regionsarray - an array, that holds all regions(not markers!) of the project
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, region, get, get all, guid</tags>
</US_DocBloc>
--]]
  local Count=reaper.CountProjectMarkers(0)
  local RegionArray={}
  local RegCount=1
  for i=0, Count-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then
      RegionArray[RegCount]={}
      RegionArray[RegCount][0]=pos
      RegionArray[RegCount][1]=rgnend
      RegionArray[RegCount][2]=name
      RegionArray[RegCount][3]=retval
      RegionArray[RegCount][4]=markrgnindexnumber
      RegionArray[RegCount][5]=color
      retval, RegionArray[RegCount][6]=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false) 
      RegCount=RegCount+1
    end
  end
  return RegCount-1, RegionArray
end

--A,B=ultraschall.GetAllRegions()


function ultraschall.GetAllRegionsBetween(startposition, endposition, partial)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllRegionsBetween</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_all_regions, array allregionsarray = ultraschall.GetAllRegionsBetween(optional number startposition, optional number endposition, optional boolean partial)</functioncall>
  <description>
    To get all Regions in the project(normal, edit, chapter), regardless of their category between start- and endposition.
    Set partial to true, if you want to get regions as well, that are only partially between start- and endposition
    Doesn't return markers!
    
    returns the number of markers and an array with each marker in the format:
    
        regionarray[index][0] - position
        regionarray[index][1] - endposition
        regionarray[index][2] - name
        regionarray[index][3] - indexnumber of the region within all markers in the project
        regionarray[index][4] - the shown index-number
        regionarray[index][5] - the color of the region
        regionarray[index][6] - the guid of the region
    
    returns -1 in case of error
  </description>
  <retvals>
    integer number_of_allregions - the number of regions returned
    array regionsarray - an array, that holds all regions(not markers!) of the project
  </retvals>
  <parameters>
    optional number startposition - the earliest position a returned region may have; nil, startposition=0
    optional number endposition - the latest position a returned region may have; nil, endposition=end of project
    optional boolean retval - true or nil, to get regions that are partially within start and endposition as well; false, only regions completely within start/endposition.
  </parameters>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, region, get, get all, guid</tags>
</US_DocBloc>
--]]
  if startposition~=nil and type(startposition)~="number" then ultraschall.AddErrorMessage("GetAllRegionsBetween","startposition", "Must be a number!", -1) return -1 end
  if endposition~=nil and type(endposition)~="number" then ultraschall.AddErrorMessage("GetAllRegionsBetween","endposition", "Must be a number!", -2) return -1 end
  if startposition==nil then startposition=0 end
  if endposition==nil then endposition = ultraschall.GetProjectLength(false,false,false,true) end

  if endposition<startposition then ultraschall.AddErrorMessage("GetAllRegionsBetween","endposition", "Must be bigger than startposition!", -3) return -1 end
  if startposition<0 then ultraschall.AddErrorMessage("GetAllRegionsBetween","startposition", "Must be bigger or equal 0!", -4) return -1 end
  if partial~=nil and type(partial)~="boolean" then ultraschall.AddErrorMessage("GetAllRegionsBetween","partial", "Must be boolean!", -4) return -1 end
  if partial==nil then partial=true end
  
  local A,B=ultraschall.GetAllRegions()
  for i=A, 1, -1 do
    if partial==false then
      if (B[i][0]<startposition or B[i][0]>endposition)
        or (B[i][1]<startposition or B[i][1]>endposition) then
          table.remove(B,i)
          A=A-1
      end
        
    elseif partial==true then
      if (B[i][0]>=startposition and B[i][0]<=endposition)
      or (B[i][1]>=startposition and B[i][1]<=endposition)
      or (B[i][0]<=startposition and B[i][1]>=endposition) then
      else
          table.remove(B,i)
          A=A-1
      end
    end
  end
  return A,B
end


function ultraschall.ParseMarkerString(markerstring, strict)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ParseMarkerString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer number_of_entries, array markerarray = ultraschall.ParseMarkerString(string markerstring, boolean strict)</functioncall>
  <description>
    Parses the entries in markerstring for timestrings and markertitles.
    It returns the number of entries as well as a table with all marker-information.
    The table works as such:
    
    markertable[1][markernumber] - the timestring of the marker, -1 if no time is available
    markertable[2][markernumber] - the time, converted into position in seconds, -1 if no time is available
    markertable[3][markernumber] - the name of the marker
    
    returns -1 in case of an error
  </description>
  <parameters>
    string markerstring - a string with all markers. An entry is "timestring markertitle\n". Each marker-entry must be separated by a newline from each other.
    boolean strict - interpret the time in timestring more strict or more loosely?
    -true, the time in markerstring must follow the format hh:mm:ss.mss , e.g. 11:22:33.444
    -false, the time can be more flexible, leading to possible misinterpretation of indexnumbers as time/seconds
  </parameters>
  <retvals>
    integer number_of_entries - the number of markers in markerstring
    array markerarray - a table with all the information of a marker
    -markertable[1][markernumber] - the timestring of the marker, -1 if no time is available
    -markertable[2][markernumber] - the time, converted into position in seconds, -1 if no time is available
    -markertable[3][markernumber] - the name of the marker
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, import, parse</tags>
</US_DocBloc>
]]
  if type(markerstring)~="string" then ultraschall.AddErrorMessage("ParseMarkerString","markerstring", "only string is allowed", -1) return -1 end
  local counter=1
  local markertable={}
  markertable[1]={}
  markertable[2]={}
  markertable[3]={}
  
  while markerstring~=nil do
    markertable[1][counter]=markerstring:match("(.-)%s")
    if strict~=true then
      markertable[2][counter]=ultraschall.TimeToSeconds(markertable[1][counter])--reaper.parse_timestr(markertable[1][counter])
    else
      markertable[2][counter]=ultraschall.TimeStringToSeconds_hh_mm_ss_mss(markertable[1][counter])--reaper.parse_timestr(markertable[1][counter])
    end
    if markertable[2][counter]==-1 then markertable[1][counter]="" end

    if markertable[1][counter]=="" then
      markertable[1][counter]=-1
      markertable[2][counter]=-1
      markertable[3][counter]=markerstring:match("(.-)\n")
      if markertable[3][counter]==nil then markertable[3][counter]=markerstring:match(".*") end
    else  
      markertable[3][counter]=markerstring:match("%s(.-)\n")
      if markertable[3][counter]==nil then markertable[3][counter]=markerstring:match("%s(.*)") end
    end
    markerstring=markerstring:match(".-\n(.*)")
    counter=counter+1
  end
  return counter-1, markertable
end



function ultraschall.RenumerateMarkers(colorvalue, startingnumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenumerateMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.RenumerateMarkers(integer colorvalue, integer startingnumber)</functioncall>
  <description>
    Renumbers the shown numbers of markers(not regions!) in the current project, that have the color colorvalue.
    The numbering starts with the number startingnumber.
    
    The markers will be renumbered from the earliest marker in the project to the latest one.
    
    returns -1 in case of an error
  </description>
  <parameters>
    integer colorvalue - the (systemdependent)colorvalue a marker must have. -1 if you want all markers to be numbered.
    -Keep in mind, that colors are differently interpreted on Mac compared to Windows!
    integer startingnumber - the first number that shall be given.
  </parameters>
  <retvals>
    integer retval - -1 in case of error, nil in case of success
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, numerate, shown number</tags>
</US_DocBloc>
]]

  if math.type(colorvalue)~="integer" then ultraschall.AddErrorMessage("RenumerateMarkers","colorvalue", "not a valid volorvalue, must be integer.", -1) return -1 end
  if math.type(startingnumber)~="integer" then ultraschall.AddErrorMessage("RenumerateMarkers","startingnumber", "not a valid starting number, must be integer", -2) return -1 end
  if startingnumber<0 then ultraschall.AddErrorMessage("RenumerateMarkers","startingnumber", "starting number must be bigger than 1", -3) return -1 end
  local counter=startingnumber
  local allmarkers, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color
  for i=0, allmarkers-1 do
    retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false and color==colorvalue then --0 then
      reaper.SetProjectMarkerByIndex2(0, i, isrgn, pos, rgnend, counter, name, color, 0)
      counter=counter+1
    elseif isrgn==false and colorvalue==-1 then
      reaper.SetProjectMarkerByIndex2(0, i, isrgn, pos, rgnend, counter, name, color, 0)
      counter=counter+1    
    end
  end
end


function ultraschall.CountNormalMarkers_NumGap()
-- returns number of normal markers in the project
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountNormalMarkers_NumGap</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer number_normal_markers = ultraschall.CountNormalMarkers_NumGap()</functioncall>
  <description>
    Returns the first "gap" in shown marker-numbers. If you have markers with numbers "1, 2, 4" it will return 3, as this is the first number missing.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
  </description>
  <retvals>
    integer gap_number - the number of the first "gap" in the numbering of the shown marker-numbers
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, count, gap, position</tags>
</US_DocBloc>
]]
  local nix=""
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  for b=1, nummarkers do
    for i=0, a do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color= reaper.EnumProjectMarkers3(0, i)
        if markrgnindexnumber==b then 
            count=b 
            nix="hui" 
            break
        end
    end
    if nix=="" then break end
    nix=""
  end

  return count+1
end  




function ultraschall.IsMarkerAtPosition(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMarkerAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, string markersstring, array markersarray = ultraschall.IsMarkerAtPosition(number position)</functioncall>
  <description>
    returns, if markers are at position and returns the marker-numbers.
    
    The marker-numbers are numerated by order, not the shown marker-numbers!
    
    returns false in case of error
  </description>
  <parameters>
    number position - the position to check for markers in seconds; only positive numbers
  </parameters>
  <retvals>
    boolean retval - true, if the function found marker(s); false, if no markers are available at position
    integer count - the count of markers at position
    string markersstring - a string with all the markernumbers, separated by a ,
    array markersarray - an array with each entry consisting a markernumber
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, marker, position</tags>
</US_DocBloc>
--]]
  if type(position)~="number" then ultraschall.AddErrorMessage("IsMarkerAtPosition","position", "only numbers are allowed", -1) return false end
  if position<0 then ultraschall.AddErrorMessage("IsMarkerAtPosition","position", "only positive numbers are allowed", -2) return false end
  
  local markersstring=""
  local markersarray={}
  local counter=1
  local yes=false
  local localcount=0
  
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false then localcount=localcount+1 end
    if position==pos and isrgn==false then 
      markersstring=markersstring..","..localcount
      markersarray[counter]=localcount
      counter=counter+1
      yes=true
    end
  end
  return yes, counter-1, markersstring:sub(2,-1), markersarray
end

--A,B,C,D=ultraschall.IsMarkerAtPosition(-1)

function ultraschall.IsRegionAtPosition(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsRegionAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, string regionsstring, array regionsarray = ultraschall.IsRegionAtPosition(number position)</functioncall>
  <description>
    returns, if regions are at position and returns the region-numbers.
    
    The region-numbers are numerated by order, not the shown region-numbers!
    
    returns false in case of error
  </description>
  <parameters>
    number position - the position to check for regions in seconds; only positive numbers
  </parameters>
  <retvals>
    boolean retval - true, if the function found region(s); false, if no regions are available at position
    integer count - the count of regions at position
    string regionsstring - a string with all the regionnumbers, separated by a ,
    array regionsarray - an array with each entry consisting a regionnumber
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, region, position</tags>
</US_DocBloc>
--]]
  if type(position)~="number" then ultraschall.AddErrorMessage("IsRegionAtPosition","position", "only numbers are allowed", -1) return false end
  if position<0 then ultraschall.AddErrorMessage("IsRegionAtPosition","position", "only positive numbers are allowed", -2) return false end
  
  local markersstring=""
  local markersarray={}
  local counter=1
  local yes=false
  local localcount=0
  
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then localcount=localcount+1 end
    if position>=pos and position<=rgnend and isrgn==true then 
      markersstring=markersstring..","..localcount 
      markersarray[counter]=localcount
      counter=counter+1
      yes=true
    end
  end
  return yes, counter-1, markersstring:sub(2,-1), markersarray
end


function ultraschall.CountMarkersAndRegions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountMarkersAndRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count_markers, integer count_regions = ultraschall.CountMarkersAndRegions()</functioncall>
  <description>
    Returns the position of the last projectmarker in the project(no regions or time-sig-markers!).
    Use <a href="#GetMarkerAndRegionsByIndex">GetMarkerAndRegionsByIndex</a> to enumerate markers or regions in particular.
    
    Returns -1 in case of no markers available
  </description>
  <retvals>
    integer count_markers - the number of markers available in the project
    integer count_regions - the number of regions available in the project
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, count, marker, region</tags>
</US_DocBloc>
--]]
  local retval=reaper.CountProjectMarkers(0)
  local markercount=0
  local regioncount=0
  for i=0, retval-1 do
    local retval, isrgn = reaper.EnumProjectMarkers2(0, i)
    if isrgn==false then markercount=markercount+1 
    else regioncount=regioncount+1
    end
  end
  return markercount, regioncount
end

--Markers,Regions=ultraschall.CountMarkersAndRegions()



function ultraschall.GetLastMarkerPosition()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastMarkerPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, integer marker_idx = ultraschall.GetLastMarkerPosition()</functioncall>
  <description>
    Returns the position of the last projectmarker in the project(no regions or time-sig-markers!).
    
    Returns -1 in case of no markers available
  </description>
  <retvals>
    number position - the position of the last marker in the project
    integer marker_idx - the idx of the last marker in the project. Not the shown number!
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, last, marker, position, markeridx</tags>
</US_DocBloc>
--]]
  local Markers=ultraschall.CountMarkersAndRegions()
  if Markers==0 then ultraschall.AddErrorMessage("GetLastMarkerPosition","", "No markers available in project!", -1) return -1 end
  local retval=reaper.CountProjectMarkers(0)
  local markeridx
  local lastpos=0
  for i=0, retval-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2(0, i)
    if pos>lastpos and isrgn==false then lastpos=pos markeridx=retval end
  end
  return lastpos, Markers
end

--L,LL=ultraschall.GetLastMarkerPosition()

function ultraschall.GetLastRegion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, number endposition, integer region_idx = ultraschall.GetLastRegion()</functioncall>
  <description>
    Returns the position of the last region in the project(no markers or time-sig-markers!).
    Note: Last region means the last ending region in the project, even if it's the first starting.
    
    Returns -1 in case of no regions available
  </description>
  <retvals>
    number startposition - the startposition of the last region in the project
    number endposition - the endposition of the last region in the project
    integer region_idx - the idx of the last region in the project. Not the shown number!
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, last, region, position, regionidx</tags>
</US_DocBloc>
--]]
  local Markers, Regions=ultraschall.CountMarkersAndRegions()
  local retval=reaper.CountProjectMarkers(0)
  local regionidx
  if Regions==0 then ultraschall.AddErrorMessage("GetLastRegion","", "No regions available in project!", -1) return -1 end
  local lastpos=0
  local startpos=0
  for i=0, retval-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2(0, i)
    if rgnend>lastpos and isrgn==true then startpos=pos lastpos=rgnend regionidx=retval end
  end
  return startpos, lastpos, Regions
end

--L,LL=ultraschall.GetLastRegionEnd()


function ultraschall.GetLastTimeSigMarkerPosition()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastTimeSigMarkerPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, number measureposition, number beatposition, integer timesig_idx = ultraschall.GetLastTimeSigMarkerPosition()</functioncall>
  <description>
    Returns the position of the last time-signature-marker in the project(no markers or regions!).
    
    Returns -1 in case of no time-signature-markers available
  </description>
  <retvals>
    number position - the position of the last timesig-marker in the project
    number measureposition - the measureposition of the last timesig-marker in the project
    number beatposition - the beatposition of the last timesig-marker in the project
    integer timesig_idx - the idx of the last timesig-marker in the project.
  </retvals>
  <chapter_context>
    Markers
    Time Signature Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, last, timesig, time signature, position, timesigidx, measure, beat</tags>
</US_DocBloc>
--]]
  retval=reaper.CountTempoTimeSigMarkers(0)
  if retval==0 then ultraschall.AddErrorMessage("GetLastTimeSigMarkerPosition","", "No time-signature-markers available in project!", -1) return -1 end
  local btpos, measpos, timesigidx
  local retval2, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, retval-1)
  return timepos, measurepos, beatpos, retval
end

--L,LL,LLL,LLLL=ultraschall.GetLastTimeSigMarker()

function ultraschall.GetMarkerUpdateCounter()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerUpdateCounter</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer marker_update_counter = ultraschall.GetMarkerUpdateCounter()</functioncall>
  <description>
    returns the number of times, a marker in any project has been updated since Reaper started.
    Counts up, if a marker is added, set, moved, deleted from any project opened in Reaper.
    
    This counter includes already closed projects as well
  </description>
  <retvals>
    integer marker_update_counter - the number of times a marker in any project in Reaper has been updated
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markers, update, counter, get</tags>
</US_DocBloc>
--]]
  return reaper.SNM_GetIntConfigVar("g_markerlist_updcnt", -33)
end

--A=ultraschall.GetMarkerUpdateCounter()


function ultraschall.MoveTimeSigMarkersBy(startposition, endposition, moveby, cut_at_borders, update_timeline)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveTimeSigMarkersBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MoveTimeSigMarkersBy(number startposition, number endposition, number moveby, boolean cut_at_borders, boolean update_timeline)</functioncall>
  <description>
    Moves time-signature-markers between startposition and endposition by moveby.
    
    Does NOT move normal projectmarkers or regions!
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    number moveby - in seconds, negative values: move toward beginning of project, positive values: move toward the end of project
    boolean cut_at_borders - shortens or cuts markers, that leave the section between startposition and endposition
    boolean update_timeline - true, updates the timeline after moving time-signature markers; false, don't update timeline(must be done manually then)
  </parameters>
  <chapter_context>
    Markers
    Time Signature Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, move, moveby, timesignature</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","endposition", "must be a number", -2) return -1 end
  if startposition>endposition then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","endposition", "must be bigger than startposition", -3) return -1 end
  if type(moveby)~="number" then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","moveby", "must be a number", -4) return -1 end
  if type(cut_at_borders)~="boolean" then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","cut_at_borders", "must be a boolean", -5) return -1 end
  if type(update_timeline)~="boolean" then ultraschall.AddErrorMessage("MoveTimeSigMarkersBy","update_timeline", "must be a boolean", -6) return -1 end
  if moveby==0 then return -1 end
  local numtimesigmarkers = reaper.CountTempoTimeSigMarkers(0)
  
  local start, stop, step, boolean
  if moveby>0 then start=numtimesigmarkers stop=0 step=-1
  elseif moveby<0 then start=0 stop=numtimesigmarkers step=1
  end

  if cut_at_borders==true then
    for i=numtimesigmarkers, 0, -1 do
      local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
      if timepos>=startposition and timepos<=endposition then
        if (timepos+moveby>endposition or timepos+moveby<startposition) then
          boolean=reaper.DeleteTempoTimeSigMarker(0, i)
        end
      end
    end
  end

  for i=start, stop, step do
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
    if timepos>=startposition and timepos<=endposition then
        boolean = reaper.SetTempoTimeSigMarker(0, i, timepos+moveby, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo)
    end
  end
  
  if update_timeline==true then reaper.UpdateTimeline() end
  return 1
end

--L=ultraschall.MoveTimeSigMarkersBy(20, 55, -1, true, true)

function ultraschall.GetAllTimeSigMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllTimeSigMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer num_timesig_markers, array TimeSigArray = ultraschall.GetAllTimeSigMarkers()</functioncall>
  <description>
    Returns the number of Tempo/Time-Signature-Markers in the project, as well as an array with all attributes of all these markers.
    
    The array is of the format: TimeSigArray[markernumber(1-based)][attribute-idx]
    where attribute-idx is
    1, number timepos
    2, number measurepos
    3, number beatpos
    4, number bpm
    5, number timesig_num
    6, number timesig_denom
    7, boolean lineartempo 
    
    returns -1 in case of error
  </description>
  <retvals>
    integer num_timesig_markers - the number of time-signature-markers in the project
    array TimeSigArray - an array with all time-signature-markers and all their attributes; see Description for more details
  </retvals>
  <chapter_context>
    Markers
    Time Signature Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, time signature, get, all</tags>
</US_DocBloc>
]]
  local markerarray={}
  for i=0, reaper.CountTempoTimeSigMarkers(0) do
    markerarray[i+1] = {reaper.GetTempoTimeSigMarker(0, i)}
    table.remove(markerarray[i+1],1)
  end
  return reaper.CountTempoTimeSigMarkers(0), markerarray
end

--retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo
--A,B=ultraschall.GetAllTimeSigMarkers()

--A,AA,AAA,AAAA=ultraschall.SectionCut_Inverse(2,4,"1",true)
--ultraschall.SectionCut(2, 4, "1", true)

--ultraschall.RippleCut_Reverse(2, 4, "1", false, true)

function ultraschall.MoveMarkersBy(startposition, endposition, moveby, cut_at_borders)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveMarkersBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MoveMarkersBy(number startposition, number endposition, number moveby, boolean cut_at_borders)</functioncall>
  <description>
    Moves the markers between startposition and endposition by moveby.
    
    Does NOT move regions and time-signature-markers!
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    number moveby - in seconds, negative values: move toward beginning of project, positive values: move toward the end of project
    boolean cut_at_borders - shortens or cuts markers, that leave the section between startposition and endposition when applying moveby
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, move, moveby, marker</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveMarkersBy","startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveMarkersBy","endposition", "must be a number", -2) return -1 end
  if startposition>endposition then ultraschall.AddErrorMessage("MoveMarkersBy","endposition", "must be bigger than startposition", -3) return -1 end
  if type(moveby)~="number" then ultraschall.AddErrorMessage("MoveMarkersBy","moveby", "must be a number", -4) return -1 end
  if type(cut_at_borders)~="boolean" then ultraschall.AddErrorMessage("MoveMarkersBy","cut_at_borders", "must be a boolean", -5) return -1 end

  if moveby==0 then return -1 end
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  local start, stop, step, boolean
  if moveby>0 then start=retval-1 stop=0 step=-1
  elseif moveby<0 then start=0 stop=retval step=1
  end

  if cut_at_borders==true then
    for i=retval, 0, -1 do
      local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
      if pos>=startposition and pos<=endposition then
        if (pos+moveby>endposition or pos+moveby<startposition) then
          boolean=reaper.DeleteProjectMarkerByIndex(0, i)
        end
      end
    end
  end

  for i=start, stop, step do
    local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if pos>=startposition and pos<=endposition then
        boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, rgnend, name)
    end
  end
  
  return 1
end

--Aretval = ultraschall.MoveMarkersBy(15, 80, -10, true)


function ultraschall.MoveRegionsBy(startposition, endposition, moveby, cut_at_borders)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveRegionsBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MoveRegionsBy(number startposition, number endposition, number moveby, boolean cut_at_borders)</functioncall>
  <description>
    Moves the regions between startposition and endposition by moveby.
    Will affect only regions, who start within start and endposition. It will not affect those, who end within start and endposition but start before startposition.
    
    Does NOT move markers and time-signature-markers!
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    number moveby - in seconds, negative values: move toward beginning of project, positive values: move toward the end of project
    boolean cut_at_borders - shortens or cuts markers, that leave the section between startposition and endposition
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, move, moveby, marker</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","endposition", "must be a number", -2) return -1 end
  if startposition>endposition then ultraschall.AddErrorMessage("MoveRegionsBy","endposition", "must be bigger than startposition", -3) return -1 end
  if type(moveby)~="number" then ultraschall.AddErrorMessage("MoveRegionsBy","moveby", "must be a number", -4) return -1 end
  if type(cut_at_borders)~="boolean" then ultraschall.AddErrorMessage("MoveRegionsBy","cut_at_borders", "must be a boolean", -5) return -1 end
  if moveby==0 then return -1 end
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  
  local start, stop, step, boolean
  if moveby>0 then start=retval stop=0 step=-1     -- if moveby is positive, count through the markers backwards
  elseif moveby<0 then start=0 stop=retval step=1  -- if moveby is positive, count through the markers forward
  end
  local markerdeleter={}
  local count=0
  
  for i=start, stop, step do
    local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    -- debug line
    --reaper.MB("Pos:"..pos.." - Start:"..startposition.."  End: "..endposition.." "..tostring(isrgn),"",0)
    
    if isrgn==true and (pos>=startposition and pos<=endposition) then
      -- only regions within start and endposition
      if cut_at_borders==true then
        -- if cutting at the borders=true, with borders determined by start and endposition 
        if pos+moveby>endposition and rgnend+moveby>endposition then
          -- when regions would move after endposition, put it into the markerdelete-array
          markerdeleter[count]=markrgnindexnumber
          count=count+1
          --reaper.MB("","0",0)
        elseif pos+moveby<startposition and rgnend+moveby<startposition then
          -- when regions would move before startposition, put it into the markerdelete-array
          markerdeleter[count]=markrgnindexnumber
          count=count+1
          --reaper.MB("","1",0)
        elseif pos+moveby<startposition and rgnend+moveby>=startposition and rgnend+moveby<=endposition then
          -- when start of the region is before startposition and end of the region is within start and endposition,
          -- set start of the region to startposition and only move regionend by moveby
          --reaper.MB("","2",0)
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, startposition, rgnend+moveby, name)
--        elseif rgnend+moveby<endposition and pos+moveby>=startposition and pos+moveby<=endposition then
          -- when end of the region is BEFORE endposition and start of the region is within start and endposition,
          -- set end of the region to endposition and only move regionstart(pos) by moveby
        elseif rgnend+moveby>endposition and pos+moveby>=startposition and pos+moveby<=endposition then
          -- when end of the region is after endposition and start of the region is within start and endposition,
          -- set end of the region to endposition and only move regionstart(pos) by moveby
          --reaper.MB("","2",0)
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, endposition, name)
        else
          -- move the region by moveby
          boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, rgnend+moveby, name)
          --reaper.MB("","3",0)
        end
      else
        -- move the region by moveby
        boolean=reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos+moveby, rgnend+moveby, name)
      end
    end
  end
  for i=0, count-1 do
    reaper.DeleteProjectMarker(0, markerdeleter[i], true)
  end
  return 1
end

--Aretval = ultraschall.MoveRegionsBy(-10, 180, -1, false)


function ultraschall.RippleCut_Regions(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut_Regions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean were_regions_altered, integer number_of_altered_regions, array altered_regions  = ultraschall.RippleCut_Regions(number startposition, number endposition)</functioncall>
  <description>
    Ripplecuts regions, where applicable.
    It cuts all (parts of) regions between startposition and endposition and moves remaining parts plus all regions after endposition by endposition-startposition toward projectstart.
    
    Returns false in case of an error.
  </description>
  <parameters>
    number startposition - the startposition from where regions shall be cut from
    number endposition - the endposition to which regions shall be cut from; all regions/parts of regions after that will be moved toward projectstart
  </parameters>
  <retvals>
    boolean were_regions_altered - true, if regions were cut/altered; false, if not
    integer number_of_altered_regions - the number of regions that were altered/cut/moved
    array altered_regions - the regions that were altered:
                          -   altered_regions_array[index_of_region][0] - old startposition
                          -   altered_regions_array[index_of_region][1] - old endposition
                          -   altered_regions_array[index_of_region][2] - name
                          -   altered_regions_array[index_of_region][3] - old indexnumber of the region within all markers in the project
                          -   altered_regions_array[index_of_region][4] - the shown index-number
                          -   altered_regions_array[index_of_region][5] - the color of the region
                          -   altered_regions_array[index_of_region][6] - the change that was applied to this region
                          -   altered_regions_array[index_of_region][7] - the new startposition
                          -   altered_regions_array[index_of_region][8] - the new endposition
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, ripple, cut, regions</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions", "startposition", "must be a number", -1) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions", "endposition", "must be a number", -2) return false end
  local dif=endposition-startposition
  
  -- get all regions, that are candidates for a ripplecut
  local number_of_all_regions, allregionsarray = ultraschall.GetAllRegionsBetween(startposition, reaper.GetProjectLength(0), true)  
  if number_of_all_regions==0 then ultraschall.AddErrorMessage("RippleCut_Regions", "", "no regions found within start and endit", -3) return false, regioncount, regionfound end
  
  -- make startposition and endposition with less precision, or we can't check, if startposition=pos
  -- Reaper seems to work with greater precision for floats than shown
  local start = ultraschall.LimitFractionOfFloat(startposition, 10, true)
  local endit = ultraschall.LimitFractionOfFloat(endposition, 10, true)
  
  -- some more preparation for variables, including localizing them
  local pos, rgnend, name, retval, markrgnindexnumber, color  
  local regionfound={}
  
  -- here comes the magic
  for i=number_of_all_regions, 1, -1 do
    -- get regionattributes from the allregionsarray we got before
     pos=allregionsarray[i][0]
     rgnend=allregionsarray[i][1]
     name=allregionsarray[i][2]
     retval=allregionsarray[i][3]
     markrgnindexnumber=allregionsarray[i][4]
     color = allregionsarray[i][5]
    -- make pos and rgnend with less precision, or we can't check, if startposition=pos
    -- Reaper seems to work with greater precision for floats than shown
    local pos1 = ultraschall.LimitFractionOfFloat(pos, 10, true)
    local rgnend1 = ultraschall.LimitFractionOfFloat(rgnend, 10, true)

    regionfound[i]={}
    regionfound[i][0]=allregionsarray[i][0]
    regionfound[i][1]=allregionsarray[i][1]
    regionfound[i][2]=allregionsarray[i][2]
    regionfound[i][3]=allregionsarray[i][3]
    regionfound[i][4]=allregionsarray[i][4]
    regionfound[i][5]=allregionsarray[i][5]

    -- let's do the checking and manipulation. We also create an array with all entries manipulated
    -- and in which way manipulated
    if pos1>=start and rgnend1<=endit then
      -- if region is fully within start and endit, cut it completely
      regionfound[i][6]="CUT COMPLETELY"
      reaper.DeleteProjectMarker(0, markrgnindexnumber, true)
    elseif pos1<start and rgnend1<=endit and rgnend1>start then
      -- if regionend is within start and endit, move the end to start
      regionfound[i][6]="CUT AT THE END"
      regionfound[i][7]=pos
      regionfound[i][8]=start
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos, start, name, color, 0)
    elseif pos1>=start and pos1<=endit and rgnend1>endit then
      -- if regionstart is within start and endit, shorten the region and move it by difference of start and endit
      --    toward projectstart
      regionfound[i][6]="CUT AT THE BEGINNING"
      regionfound[i][7]=endit-dif
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, endit-dif, rgnend-dif, name, color, 0)
    elseif pos1>=endit and rgnend1>=endit then 
      -- if region is after endit, just move the region by difference of start and endit toward projectstart
      regionfound[i][6]="MOVED TOWARD PROJECTSTART"
      regionfound[i][7]=pos-dif
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos-dif, rgnend-dif, name, color, 0)
    elseif start>=pos1 and endit<=rgnend then
      -- if start and endit is fully within a region, cut at the end of the region the difference of start and endit
      regionfound[i][6]="CUT IN THE MIDDLE"
      regionfound[i][7]=pos
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos, rgnend-dif, name, color, 0)
    end
  end
  -- sort the table of found regions
  return true, regioncount, regionfound
end

--  A,B=reaper.GetSet_LoopTimeRange(false,true,0,0,false)
--  C,D,E=ultraschall.RippleCut_Regions(A, B)

--  number_of_all_regions, allregionsarray = ultraschall.GetAllRegionsBetween(A,B, true)


function ultraschall.GetAllCustomMarkers(custom_marker_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllCustomMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table marker_array = ultraschall.GetAllCustomMarkers(string custom_marker_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return all custom-markers with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not check custom-regions, use [GetAllCustomRegions](#GetAllCustomRegions) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer count - the number of found markers; -1, in case of an error
    table marker_array - an array with all found custom-markers. It follows the scheme:
                       -
                       -    marker_array[index]["index"] - index of the marker, in timeline-order, with 0 for the first in the project
                       -    marker_array[index]["pos"]   - position of the marker in seconds
                       -    marker_array[index]["name"]  - name of the marker, excluding the custom-marker-name
                       -    marker_array[index]["shown_number"]  - the number of the marker, that is displayed in the timeline
                       -    marker_array[index]["color"]  - color-value of the marker
                       -    marker_array[index]["guid"]  - the guid of the marker
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, all, custom markers, color, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("GetAllCustomMarkers", "custom_marker_name", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("GetAllCustomMarkers", "custom_marker_name", "not a valid matching-pattern", -2) return -1 end
  local count=0
  local MarkerArray={}

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==false and name:match("^_"..custom_marker_name..":")~=nil then 
      count=count+1 
      MarkerArray[count]={}
      MarkerArray[count]["index"]=i
      MarkerArray[count]["pos"]=pos
      MarkerArray[count]["name"]=name:match(".-:%s-(.*)")
      MarkerArray[count]["shown_number"]=markrgnindexnumber
      MarkerArray[count]["color"]=color
      retval, MarkerArray[count]["guid"]=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false) 
    end
  end
  return count, MarkerArray
end

--A,B,C = ultraschall.GetAllCustomMarkers("Whiskey")


function ultraschall.GetAllCustomRegions(custom_region_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllCustomRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table marker_array = ultraschall.GetAllCustomRegions(string custom_region_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return all custom-regions with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not check custom-markers, use [GetAllCustomMarkers](#GetAllCustomMarkers) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer count - the number of found regions; -1, in case of an error
    table region_array - an array with all found custom-markers. It follows the scheme:
                       -
                       -    region_array[index]["index"] - index of the region, in timeline-order, with 0 for the first in the project
                       -    region_array[index]["pos"]   - position of the region in seconds
                       -    region_array[index]["regionend"] - the endposition of the region in seconds
                       -    region_array[index]["name"]  - name of the region, excluding the custom-region-name
                       -    region_array[index]["shown_number"]  - the number of the region, that is displayed in the timeline
                       -    region_array[index]["color"]  - color-value of the region
                       -    region_array[index]["guid"]  - the guid of the region
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, all, custom regions, color, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("GetAllCustomRegions", "custom_region_name", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(custom_region_name)==false then ultraschall.AddErrorMessage("GetAllCustomRegions", "custom_region_name", "not a valid matching-pattern", -2) return -1 end
  local count=0
  local MarkerArray={}

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==true and name:match("^_"..custom_region_name..":")~=nil then 
      count=count+1 
      MarkerArray[count]={}
      MarkerArray[count]["index"]=i
      MarkerArray[count]["pos"]=pos
      MarkerArray[count]["regionend"]=rgnend
      MarkerArray[count]["name"]=name:match(".-:%s*(.*)")
      MarkerArray[count]["shown_number"]=markrgnindexnumber
      MarkerArray[count]["color"]=color
      retval, MarkerArray[count]["guid"]=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false) 
    end
  end
  return count, MarkerArray
end

--A,B,C=ultraschall.GetAllCustomRegions("Whiskey")

function ultraschall.CountAllCustomMarkers(custom_marker_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountAllCustomMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountAllCustomMarkers(string custom_marker_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will count all custom-markers with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not count custom-regions, use [CountAllCustomRegions](#CountAllCustomRegions) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer count - the number of found markers; -1, in case of an error
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, count, all, custom markers</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("GetAllCustomMarkers", "custom_marker_name", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("GetAllCustomMarkers", "custom_marker_name", "not a valid matching-pattern", -2) return -1 end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==false and name:match("^_"..custom_marker_name..":")~=nil then 
      count=count+1 
    end
  end
  return count
end

--A,B,C = ultraschall.CountAllCustomMarkers("Whiskey")


function ultraschall.CountAllCustomRegions(custom_region_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountAllCustomRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountAllCustomRegions(string custom_region_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will count all custom-regions with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not count custom-markers, use [CountAllCustomMarkers](#CountAllCustomMarkers) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer count - the number of found regions; -1, in case of an error
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, count, all, custom regions</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("CountAllCustomRegions", "custom_region_name", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(custom_region_name)==false then ultraschall.AddErrorMessage("CountAllCustomRegions", "custom_region_name", "not a valid matching-pattern", -2) return -1 end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==true and name:match("^_"..custom_region_name..":")~=nil then 
      count=count+1 
    end
  end
  return count
end

--B,C=ultraschall.CountAllCustomRegions(true)


function ultraschall.EnumerateCustomMarkers(custom_marker_name, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateCustomMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, string name, integer shown_number, integer color = ultraschall.EnumerateCustomMarkers(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return a specific custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not enumerate custom-regions, use [EnumerateCustomRegions](#EnumerateCustomRegions) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
    integer idx - the index of the marker within all same-named custom-markers; 0, for the first custom-marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if the custom-marker exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 2 for the second, etc
    number pos - the position of the marker in seconds
    string name - the name of the marker, exluding the custom-marker-name
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
    string guid - the guid of the custom-marker
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, enumerate, custom markers, color, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("EnumerateCustomMarkers", "custom_marker_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("EnumerateCustomMarkers", "custom_marker_name", "not a valid matching-pattern", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("EnumerateCustomMarkers", "idx", "must be an integer", -3) return false end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==false and name:match("^_"..custom_marker_name..":")~=nil then 
      count=count+1 
      local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false)
      if idx==count-1 then return true, i, pos, name:match(".-:%s*(.*)"), markrgnindexnumber, color, guid end
    end
  end
  return false
end

--A,B,C,D,E,F,G = ultraschall.EnumerateCustomMarkers("Whiskey",-3)


function ultraschall.EnumerateCustomRegions(custom_region_name, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateCustomRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, number regionend, string name, integer shown_number, integer color, string guid = ultraschall.EnumerateCustomRegions(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return a specific custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not enumerate custom-markers, use [EnumerateCustomMarkers](#EnumerateCustomMarkers) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
    integer idx - the index of the region within all same-named custom-regions; 0, for the first custom-region
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if the custom-region exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 2 for the second, etc
    number pos - the position of the region in seconds
    number rgnend - the end of the region in seconds
    string name - the name of the region, exluding the custom-region-name
    integer shown_number - the regionnumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the region
    string guid - the guid of the custom-region
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, enumerate, custom regions, color, name, position, shown_number, index</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("EnumerateCustomRegions", "custom_region_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_region_name)==false then ultraschall.AddErrorMessage("EnumerateCustomRegions", "custom_region_name", "not a valid matching-pattern", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("EnumerateCustomRegions", "idx", "must be an integer", -3) return false end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==true and name:match("^_"..custom_region_name..":")~=nil then 
      count=count+1 
      local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..i, "", false)
      if idx==count-1 then return true, i, pos, rgnend, name:match(".-:%s*(.*)"), markrgnindexnumber, color, guid end
    end
  end
  return false
end

--A,B,C,D,E,F,G = ultraschall.EnumerateCustomRegions("Whiskey",4)

function ultraschall.DeleteCustomMarkers(custom_marker_name, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteCustomMarkers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, string name, integer shown_number, integer color = ultraschall.DeleteCustomMarkers(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will delete a specific custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not delete custom-regions, use [DeleteCustomRegions](#DeleteCustomRegions) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
    integer idx - the index of the marker within all same-named custom-markers; 0, for the first custom-marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if the custom-marker exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 2 for the second, etc
    number pos - the position of the marker in seconds
    string name - the name of the marker, exluding the custom-marker-name
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, delete, custom markers, color, name, position, shown_number, index</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("DeleteCustomMarkers", "custom_marker_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("DeleteCustomMarkers", "custom_marker_name", "not a valid matching-pattern", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteCustomMarkers", "idx", "must be an integer", -3) return false end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==false and name:match("^_"..custom_marker_name..":")~=nil then 
      count=count+1 
      if idx==count-1 then 
        reaper.DeleteProjectMarkerByIndex(0, i) 
        return true, i, pos, name:match(".-:%s*(.*)"), markrgnindexnumber, color 
      end
    end
  end
  return false
end

--A,B,C,D,E,F,G = ultraschall.DeleteCustomMarkers("Whiskey",2)


function ultraschall.DeleteCustomRegions(custom_region_name, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteCustomRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, number regionend, string name, integer shown_number, integer color = ultraschall.DeleteCustomRegions(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a specific custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not delete custom-markers, use [DeleteCustomMarkers](#DeleteCustomMarkers) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
    integer idx - the index of the region within all same-named custom-regions; 0, for the first custom-region
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if the custom-region exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 2 for the second, etc
    number pos - the position of the region in seconds
    number rgnend - the end of the region in seconds
    string name - the name of the region, exluding the custom-region-name
    integer shown_number - the regionnumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the region
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, delete, custom regions, color, name, position, shown_number, index</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("DeleteCustomRegions", "custom_region_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_region_name)==false then ultraschall.AddErrorMessage("DeleteCustomRegions", "custom_region_name", "not a valid matching-pattern", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteCustomRegions", "idx", "must be an integer", -3) return false end
  local count=0

  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if isrgn==true and name:match("^_"..custom_region_name..":")~=nil then 
      count=count+1 
      if idx==count-1 then 
        reaper.DeleteProjectMarkerByIndex(0, i) 
        return true, i, pos, rgnend, name:match(".-:%s*(.*)"), markrgnindexnumber, color 
      end
    end
  end
  return false
end

--A,B,C,D,E,F,G = ultraschall.DeleteCustomRegions("Whiskey",3)

function ultraschall.AddCustomMarker(custom_marker_name, pos, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddCustomMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer markernumber, string guid = ultraschall.AddCustomMarker(string custom_marker_name, number pos, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will add new custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not add custom-regions, use [AddCustomRegion](#AddCustomRegion) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"; nil, adds a normal marker
    number pos - the position of the marker in seconds
    string name - the name of the marker, exluding the custom-marker-name
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if adding the custom-marker was successful; false, if not or an error occurred
    integer markernumber - the indexnumber of the newly added custommarker
    string guid - the guid of the custommarker
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, add, custom markers, color, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  -- ToDo: return the index of the newly added marker, if that is useful
  if custom_marker_name~=nil and type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("AddCustomMarker", "custom_marker_name", "must be a string", -1) return false end
  if type(pos)~="number" then ultraschall.AddErrorMessage("AddCustomMarker", "pos", "must be a number", -2) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("AddCustomMarker", "name", "must be a string", -3) return false end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("AddCustomMarker", "shown_number", "must be an integer", -4) return false end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("AddCustomMarker", "color", "must be an integer; 0, for default color", -5) return false end  
  
  if custom_marker_name==nil then custom_marker_name=name else custom_marker_name="_"..custom_marker_name..": "..name end
  
  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsMarkerAtPosition(pos)
  
  reaper.AddProjectMarker2(0, false, pos, 0, custom_marker_name, shown_number, color)
  
  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsMarkerAtPosition(pos)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  
  return true, originals_array1[1]-1, guid
end
--A,B,C=ultraschall.AddCustomMarker("vanillachief", 1, "Hulahoop", 987, 9865)


function ultraschall.AddCustomRegion(custom_region_name, pos, regionend, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddCustomRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shown_number, integer markerindex, string guid = ultraschall.AddCustomRegion(string custom_region_name, number pos, number regionend, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will add new custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not add custom-markers, use [AddCustomMarker](#AddCustomMarker) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"; nil, make it a normal regionname
    number pos - the position of the region in seconds
    number regionend - the endposition of the region in seconds
    string name - the name of the region, exluding the custom-region-name
    integer shown_number - the regionnumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if adding the custom-region was successful; false, if not or an error occurred
    integer shown_number - if the desired shown_number is already used by another region, this will hold the alternative number for the new custom-region
    integer markernumber - the indexnumber of the newly added customregion
    string guid - the guid of the customregion
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, add, custom region, color, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  -- ToDo: return the index of the newly added marker, if that is useful
  if custom_region_name~=nil and type(custom_region_name)~="string" then ultraschall.AddErrorMessage("AddCustomRegion", "custom_region_name", "must be a string", -1) return false end
  if type(pos)~="number" then ultraschall.AddErrorMessage("AddCustomRegion", "pos", "must be a number", -2) return false end
  if type(regionend)~="number" then ultraschall.AddErrorMessage("AddCustomRegion", "regionend", "must be a number", -6) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("AddCustomRegion", "name", "must be a string", -3) return false end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("AddCustomRegion", "shown_number", "must be an integer", -4) return false end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("AddCustomRegion", "color", "must be an integer; 0, for default color", -5) return false end  
  
  if custom_region_name==nil then custom_region_name=name else custom_region_name="_"..custom_region_name..": "..name end
  
  local Aretval, Acount, Amarkersstring, Amarkersarray = ultraschall.IsRegionAtPosition(pos)
  
  shown_number=reaper.AddProjectMarker2(0, true, pos, regionend, custom_region_name, shown_number, color)
  
  local A1retval, Acount1, A1markersstring, A1markersarray = ultraschall.IsRegionAtPosition(pos)
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(A1markersarray, Amarkersarray)
  
  if originals_array1[1]==nil then ultraschall.AddErrorMessage("AddCustomRegion", "shown_number", "region with that number already exists", -6) return false end
  
  local retval, guid = reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..originals_array1[1]-1, "", false)
  
  return true, shown_number, originals_array1[1]-1, guid
end

--A,B,C=ultraschall.AddCustomRegion("vanillachief", 105, 150, "Hulahoop", 987, 9865)

-- Mespotine

function ultraschall.SetCustomMarker(custom_marker_name, idx, pos, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetCustomMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetCustomMarker(string custom_marker_name, integer idx, number pos, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will set attributes of an already existing custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        \_customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       \_\_customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not set custom-regions, use [SetCustomRegion](#SetCustomRegion) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"; nil, make it a normal marker
    integer idx - the index-number of the custom-marker within all custom-markers
    number pos - the position of the marker in seconds
    string name - the name of the marker, exluding the custom-marker-name
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if setting the new attributes of the custom-marker was successful; false, if not or an error occurred
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, set, custom markers, color, name, position, shown_number, index</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("SetCustomMarker", "custom_marker_name", "must be a string", -1) return false end
  if type(pos)~="number" then ultraschall.AddErrorMessage("SetCustomMarker", "pos", "must be a number", -2) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetCustomMarker", "name", "must be a string", -3) return false end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("SetCustomMarker", "shown_number", "must be an integer", -4) return false end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("SetCustomMarker", "color", "must be an integer; 0, for default color", -5) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetCustomMarker", "idx", "must be an integer", -6) return false end
  
  local retval, markerindex = ultraschall.EnumerateCustomMarkers(custom_marker_name, idx)
  
  if retval==false then ultraschall.AddErrorMessage("SetCustomMarker", "idx", "no such custom-marker", -7) return false end
  
  custom_marker_name="_"..custom_marker_name..": "..name
  
  return reaper.SetProjectMarkerByIndex2(0, markerindex, false, pos, 0, shown_number, custom_marker_name, color, 0)
end

--A,B,C=ultraschall.SetCustomMarker("vanillachief", -3, 30, "Hulahoop9", 48787, 12)


function ultraschall.SetCustomRegion(custom_region_name, idx, pos, regionend, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetCustomRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shown_number = ultraschall.SetCustomRegion(string custom_region_name, integer idx, number pos, number regionend, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will set an already existing custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        \_customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        \_\_customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not add custom-markers, use [AddCustomMarker](#AddCustomMarker) instead.
    
    returns false in case of an error, like the desired shown_number is already taken by another region
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
    integer idx - the index of the custom region to change
    number pos - the position of the region in seconds
    string name - the name of the region, exluding the custom-region-name
    integer shown_number - the regionnumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, if adding the region was successful; false, if not or an error occurred
    integer shown_number - if the desired shown_number is already used by another region, this will hold the alternative number for the new custom-region
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, set, custom region, color, name, position, shown_number, index</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("SetCustomRegion", "custom_region_name", "must be a string", -1) return false end
  if type(pos)~="number" then ultraschall.AddErrorMessage("SetCustomRegion", "pos", "must be a number", -2) return false end
  if type(regionend)~="number" then ultraschall.AddErrorMessage("SetCustomRegion", "regionend", "must be a number", -7) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetCustomRegion", "name", "must be a string", -3) return false end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("SetCustomRegion", "shown_number", "must be an integer", -4) return false end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("SetCustomRegion", "color", "must be an integer; 0, for default color", -5) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetCustomRegion", "idx", "must be an integer", -6) return false end
  
  local retval, markerindex = ultraschall.EnumerateCustomRegions(custom_region_name, idx)
  
  if retval==false then ultraschall.AddErrorMessage("SetCustomRegion", "idx", "no such custom-region", -7) return false end
  
  custom_region_name="_"..custom_region_name..": "..name
  
  return reaper.SetProjectMarkerByIndex2(0, markerindex, true, pos, regionend, shown_number, custom_region_name, color, 0)
end
--A,B,C=ultraschall.SetCustomRegion("vanillachief", 0, 10, 20, "HudelDudel", 2, 0)


function ultraschall.GetNextFreeRegionIndex()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextFreeRegionIndex</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer free_shown_number = ultraschall.GetNextFreeRegionIndex()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns the next unused region-index-number, beginning with 0.
  </description>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    integer free_shown_number - the next free/unused region-index-number
  </retvals>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, free, region, index</tags>
</US_DocBloc>
]]
  local count=0
  local numbertable={}
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then 
      count=count+1
      numbertable[count]=markrgnindexnumber
    end
  end
  
  table.sort(numbertable)
  
  for i=1, count do
    if numbertable[i]~=i-1 then return i-1 end
  end
  return count
end

--A=ultraschall.GetNextFreeRegionIndex()

function ultraschall.IsMarkerValidCustomMarker(custom_marker_name, markeridx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMarkerValidCustomMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsMarkerValidCustomMarker(string custom_marker_name, integer markeridx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns true, if the marker with id markeridx is a valid custom-marker of the type custom_marker_name
    
    markeridx is the index of all markers and regions!
    
    returns false in case of an error
  </description>
  <paramters>
    string custom_marker_name - the custom-marker-name to check against; can also be a Lua-pattern-matching-expression
    integer markeridx - the index of the marker to check; this is the index of all markers and regions!
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, marker is a valid custom-marker of type custom_marker_name; false, it is not or an error occurred
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, isvalid, custom-marker</tags>
</US_DocBloc>
]]
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("IsMarkerValidCustomMarker", "custom_marker_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("IsMarkerValidCustomMarker", "custom_marker_name", "not a valid matching-pattern", -2) return false end
  if math.type(markeridx)~="integer" then ultraschall.AddErrorMessage("IsMarkerValidCustomMarker", "markeridx", "must be an integer", -3) return false end
  local A,B=ultraschall.GetAllCustomMarkers(custom_marker_name)
  for i=1, A do
    if B[i]["index"]==markeridx then return true end
  end
  return false
end

--C=ultraschall.IsMarkerValidCustomMarker("(.*)",0)


function ultraschall.IsRegionValidCustomRegion(custom_region_name, markeridx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsRegionValidCustomRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsRegionValidCustomRegion(string custom_region_name, integer markeridx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns true, if the marker with id markeridx is a valid custom-region of the type custom_region_name
    
    markeridx is the index of all markers and regions!
    
    returns false in case of an error
  </description>
  <paramters>
    string custom_region_name - the custom-reion-name to check against; can also be a Lua-pattern-matching-expression
    integer markeridx - the index of the marker to check; this is the index of all markers and regions!
  </parameters>
  <retvals markup_type="markdown" markup_version="1.0.1" indent="default">
    boolean retval - true, marker is a valid custom-region of type custom_region_name; false, it is not or an error occurred
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, isvalid, custom-region</tags>
</US_DocBloc>
]]
  if type(custom_region_name)~="string" then ultraschall.AddErrorMessage("IsRegionValidCustomRegion", "custom_region_name", "must be a string", -1) return false end
  if ultraschall.IsValidMatchingPattern(custom_region_name)==false then ultraschall.AddErrorMessage("IsRegionValidCustomRegion", "custom_region_name", "not a valid matching-pattern", -2) return false end
  if math.type(markeridx)~="integer" then ultraschall.AddErrorMessage("IsRegionValidCustomRegion", "markeridx", "must be an integer", -3) return false end
  local A,B=ultraschall.GetAllCustomRegions(custom_region_name)
  for i=1, A do
    if B[i]["index"]==markeridx then return true end
  end
  return false
end

--C=ultraschall.IsRegionValidCustomRegion("vanillachief", 1)


function ultraschall.GetMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a marker-guid
    
    The index is for all markers and regions, inclusive and 1-based
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the marker/region, whose guid you have passed to this function
  </retvals>
  <parameters>
    string guid - the guid of the marker/region, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end
  if ultraschall.IsValidGuid(guid, true)==false then ultraschall.AddErrorMessage("GetMarkerIDFromGuid", "guid", "must be a valid guid", -2) return -1 end
  for i=0, reaper.CountProjectMarkers(0) do
    local A,B=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..(i-1), 1, false)
    if B==guid then return i end
  end
  return -1
end

--A,guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:1", 1, false)
--O=ultraschall.GetMarkerIDFromGuid(guid)

function ultraschall.GetGuidFromMarkerID(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromMarkerID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromMarkerID(integer index)</functioncall>
  <description>
    Gets the corresponding marker-guid of a marker with a specific index 
    
    The index is for all markers and regions, inclusive and 1-based
    
    returns -1 in case of an error
  </description>
  <retvals>
    string guid - the guid of the marker/region of the marker with a specific index
  </retvals>
  <parameters>
    integer index - the index of the marker/region, whose guid you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetGuidFromMarkerID", "index", "must be an integer", -1) return -1 end
  if index<1 or index>reaper.CountProjectMarkers(0) then ultraschall.AddErrorMessage("GetGuidFromMarkerID", "index", "must be between 1 and "..reaper.CountProjectMarkers(0), -2) return -1 end
  local A,B=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..(index-1), 1, false)
  return B
end

function ultraschall.IsTimeSigmarkerAtPosition(position, position_mode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTimeSigmarkerAtPosition</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsTimeSigmarkerAtPosition(number position, optional integer position_mode)</functioncall>
  <description>
    returns, if at position is a time-signature marker
	
	returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, marker found; false, marker not found
  </retvals>
  <parameters>
    number position - the position to check, whether there's a timesignature marker
	optional integer position_mode - nil or 0, use position in seconds; 1, use position in measures
  </parameters>			
  <chapter_context>
    Markers
	Time Signature Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, check, at position, timesig, marker/tags>
</US_DocBloc>
--]]
  if type(position)~="number" then ultraschall.AddErrorMessage("IsTimeSigmarkerAtPosition", "position", "must be a number", -1) return false end
  if position_mode~=nil and math.type(position_mode)~="integer" then ultraschall.AddErrorMessage("IsTimeSigmarkerAtPosition", "position_mode", "must be an integer or nil", -2) return false end
  if position_mode==nil then position_mode=0 end
  if position_mode~=0 and position_mode~=1 then ultraschall.AddErrorMessage("IsTimeSigmarkerAtPosition", "position", "must be either nil, 0 or 1", -3) return false end
  for i=1, reaper.CountTempoTimeSigMarkers(0) do
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
    if position_mode==0 and ultraschall.FloatCompare(position, timepos, 0.00000000000000000001)==true then return true end
    if position_mode==1 and measurepos==position then return true end
  end
  return false
end

