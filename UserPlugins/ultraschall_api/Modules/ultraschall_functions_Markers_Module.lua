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


function ultraschall.AddNormalMarker(position, shown_number, markertitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddNormalMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer marker_number, string guid, integer normal_marker_idx = ultraschall.AddNormalMarker(number position, integer shown_number, string markertitle)</functioncall>
  <description>
    Adds a normal marker. Returns the index of the marker as marker_number.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" or custommarkers with the scheme "_custommarker:" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer marker_number  - the overall-marker-index, can be used for reaper's own marker-management functions
     string guid - the guid, associated with this marker
     integer normal_marker_idx - the index of the normal marker
  </retvals>
  <parameters>
    number position - position in seconds.
    integer shown_number - the number, that will be shown within Reaper. Can be multiple times. Use -1 to let Ultraschall-API add +1 to the highest number used.
    string markertitle - the title of the marker
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
  
  local shown_number, marker_index, guid = ultraschall.AddProjectMarker(0, false, position, 0, markertitle, shown_number, 0)
  
  local A1,B1,C1=ultraschall.GetSetChapterMarker_Attributes(true, marker_index, "chap_guid", "", false)
  
  return marker_index, guid, ultraschall.GetNormalMarkerIDFromGuid(guid)
end


function ultraschall.AddPodRangeRegion(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddPodRangeRegion</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>integer marker_number, string guid = ultraschall.AddPodRangeRegion(number startposition, number endposition)</functioncall>
  <description>
    Deprecated.
    
    Adds a region, which shows the time-range from the beginning to the end of the podcast.
    
    returns -1 in case of an error
  </description>
  <deprecated since_when="US4.4" alternative=""/>
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
  ultraschall.deprecated("AddPodRangeRegion")
  -- prepare variables
  local color=0
  local noteID=0
  
  -- prepare colorvalue
  local Os = reaper.GetOS()
  
  color = 0xFFFFFF|0x1000000

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
    Ultraschall=4.7
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>integer marker_number, string guid, integer edit_marker_idx = ultraschall.AddEditMarker(number position, integer shown_number, string edittitle)</functioncall>
  <description>
    Adds an Edit marker. Returns the index of the marker as marker_number. 
    
    returns -1 in case of an error
  </description>
  <retvals>
     integer marker_number  - the overall-marker-index, can be used for reaper's own marker-management functions
     string guid - the guid, associated with this marker
     integer edit_marker_idx - the index if the edit-marker within all edit-markers; 1-based
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
  if string.match(Os, "Win") then 
    color = 0x0000FF|0x1000000
  else
    color = 0xFF0000|0x1000000
  end
  
  -- check parameters
  if type(position)~="number" then ultraschall.AddErrorMessage("AddEditMarker", "position", "must be a number", -1) return -1 end
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("AddEditMarker", "shown_number", "must be a integer", -2) return -1 end
  if edittitle==nil then edittitle="" else edittitle=": "..edittitle end
  
  local shown_number, marker_index, guid = ultraschall.AddProjectMarker(0, false, position, 0, "_Edit"..edittitle, shown_number, color)
  
  return marker_index, guid, ultraschall.GetEditMarkerIDFromGuid(guid)
end

function ultraschall.CountNormalMarkers(starttime, endtime)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountNormalMarkers</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer number_of_markers = ultraschall.CountNormalMarkers(optional number starttime, optional number endtime)</functioncall>
  <description>
    Counts all normal markers. 
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" or custommarkers with the scheme "_custommarker:" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
  </description>
  <parameters>
    optional number starttime - the starttime, from which to count the markers
    optional number endtime - the endtime, to which to count the markers
  </parameters>
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
  if starttime~=nil and type(starttime)~="number" then ultraschall.AddErrorMessage("CountNormalMarkers", "starttime", "must be nil or a number", -3) return -1 end
  if endtime~=nil and type(endtime)~="number" then ultraschall.AddErrorMessage("CountNormalMarkers", "endtime", "must be nil or a number", -4) return -1 end
  if starttime==nil then starttime=0 end
  if endtime==nil then endtime=reaper.GetProjectLength(0) end

  -- prepare variables
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  
  -- count normal-markers
  for i=0, a-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)
    if name==nil then name="" end
    if name:match("^(_.-:).*")~=nil
    or name:sub(1,5)=="_Edit" or 
    color == ultraschall.planned_marker_color 
    then 
        -- if marker is shownote, chapter, edit or planned chapter
    elseif isrgn==false then 
      if pos>=starttime and pos<=endtime then
        count=count+1 -- elseif marker is no region, count up
      end
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
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall> number start_position, number end_position, string guid = ultraschall.GetPodRangeRegion()</functioncall>
  <description>
    Deprecated.
    
    Gets the start_position and the end_position of the PodRangeRegion.
    
    returns -1 if no PodRangeRegion exists
  </description>
  <deprecated since_when="US4.4" alternative=""/>
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
  ultraschall.deprecated("GetPodRangeRegion")
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
    Ultraschall=4.3
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retnumber, integer shown_number, number position, string markertitle, string guid = ultraschall.EnumerateNormalMarkers(integer number)</functioncall>
  <description>
    Get the data of a normal marker. 
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" or custommarkers with the scheme "_custommarker:" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    Returns -1 in case of error
  </description>
  <retvals>
     integer retnumber - overallmarker/regionnumber of marker beginning with 1 for the first marker; ignore the order of first,second,etc creation of
                       - markers but counts from position 00:00:00 to end of project. So if you created a marker at position 00:00:00 and move the first created marker to
                       - the end of the timeline, it will be the last one, NOT the first one in the retval! For use with reaper's own marker-functions.
     integer shown_number - shown number of the marker
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
      if name==nil then name="" end
      if name:match("^(_.-:).*")==nil and name:sub(1,5)~="_Edit" and color ~= ultraschall.planned_marker_color 
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
    Ultraschall=4.7
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
          editname=name:match(".-:%s*(.*)")--sub(7,-1)
          if editname==nil then editname="" end
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
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> boolean retval = ultraschall.SetNormalMarker(integer number, number position, integer shown_number, string markertitle)</functioncall>
  <description>
     Sets values of a normal Marker(no _Chapter:, _Shownote:, etc). Returns true if successful and false if not(i.e. marker doesn't exist)
     
     Normal markers are all markers, that don't include "_Shownote:" or "_Edit" or custommarkers with the scheme "_custommarker:" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
     
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
  if math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("SetNormalMarker", "shown_number", "must be an integer", -4) return false end
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
      if name:match("^(_.-:).*")==nil and name:sub(1,5)~="_Edit" and color ~= ultraschall.planned_marker_color then 
        count=count+1 
      end
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
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetEditMarker(integer edit_index, number position, integer shown_number, string edittitle)</functioncall>
  <description>
    Sets values of an Edit Marker. Returns true if successful and false if not(i.e. marker doesn't exist)
    
    returns false in case of an error
  </description>
  <parameters>
    integer edit_index - the index of the edit marker
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
  if wentfine==1 then return reaper.SetProjectMarkerByIndex(0, retnumber, 0, position, 0, shown_number, "_Edit: " .. edittitle, color)
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
    Ultraschall=4.4
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.SetPodRangeRegion(number startposition, number endposition)</functioncall>
  <description>
    Deprecated
    Sets "_PodRange:"-Region
    
    returns -1 if it fails.
  </description>
  <parameters>
    number startposition - begin of the podcast in seconds
    number endposition - end of the podcast in seconds
  </parameters>
  <deprecated since_when="US4.4" alternative=""/>
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
  ultraschall.deprecated("SetPodRangeRegion")
  if type(startposition)~="number" then ultraschall.AddErrorMessage("SetPodRangeRegion", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("SetPodRangeRegion", "endposition", "must be a number", -2) return -1 end
  return ultraschall.AddPodRangeRegion(startposition, endposition)
end

function ultraschall.DeletePodRangeRegion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeletePodRangeRegion</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall> integer retval = ultraschall.DeletePodRangeRegion()</functioncall>
  <description>
    deprecated
    deletes the PodRange-Region. 
    
    Returns false if unsuccessful
  </description>
  <deprecated since_when="US4.4" alternative=""/>
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
  ultraschall.deprecated("DeletePodRangeRegion")
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
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteNormalMarker(integer number)</functioncall>
  <description>
    Deletes a Normal-Marker. Returns true if successful and false if not(i.e. marker doesn't exist) Use <a href="#EnumerateNormalMarkers">ultraschall.EnumerateNormalMarkers</a> to get the correct number.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" or custommarkers with the scheme "_custommarker:" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
    
    returns -1 in case of an error
  </description>
  <parameters>
    integer number - number of a normal marker; 0-based
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
  for i=0, c-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if name:match("^(_.-:).*")==nil and name:sub(1,5)~="_Edit" and color ~= ultraschall.planned_marker_color then 
        count=count+1 
      end
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
    string markertitle - the markertitle
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
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string marker, string marker_index = ultraschall.GetMarkerByScreenCoordinates(integer xmouseposition)</functioncall>
  <description>
    returns the markers at a given absolute-x-pixel-position. It sees markers according their graphical representation in the arrange-view, not just their position! Returned string will be "Markeridx\npos\nName\nMarkeridx2\npos2\nName2\n...".    
    Will return "", if no marker has been found.
    
    The second returnvalue has the index of the marker within all markers and regions.
    
    Returns only markers, no time markers or regions!
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all markernumbers, markerpositions and markertitles, separated by a newline. 
                  - Can contain numerous markers, if there are more markers in one position.
    string marker_index - a newline separated string with all marker-index-numbers found; 0-based
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
  xmouseposition=xmouseposition+1
  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
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
  local retstring2=""
  local temp
 
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false then
      if markrgnindexnumber>999999999 then temp=math.floor(ten)
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=math.floor(nine)
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=math.floor(eight)
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=math.floor(seven)
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=math.floor(six)
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=math.floor(five)
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=math.floor(four)
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=math.floor(three)
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=math.floor(two)
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=math.floor(one)
      end
      local Ax,AAx = reaper.GetSet_ArrangeView2(0, false, xmouseposition-temp-1, xmouseposition) -- put offsets in here...
      if pos>=Ax and pos<=AAx then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name.."\n" 
        retstring2=retstring2..tonumber(retval-1).."\n" 
      end             
    end
  end
  return retstring, retstring2--:match("(.-)%c.-%c")), tonumber(retstring:match(".-%c(.-)%c")), retstring:match(".-%c.-%c(.*)")
end

function ultraschall.GetMarkerByTime(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerByTime</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers, string marker_index = ultraschall.GetMarkerByTime(number position)</functioncall>
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
    string marker_index - a newline separated string with all marker-index-numbers found; 0-based
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

  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
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
  local retstring2=""
  local temp
  
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==false then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=math.floor(nine)
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=math.floor(eight)
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=math.floor(seven)
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=math.floor(six)
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=math.floor(five)
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=math.floor(four)
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=math.floor(three)
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=math.floor(two)
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=math.floor(one)
      end 
      local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.get_ini_file())
      local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, ARetval2+57-temp,ARetval2+57) 
      local Bx=AAx-Ax
      if Bx+pos>=position and pos<=position then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name 
        retstring2=retstring2..tonumber(retval-1).."\n" 
      end
    end
  end
  return retstring, retstring2
end


function ultraschall.GetRegionByScreenCoordinates(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRegionByScreenCoordinates</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers, string region_index = ultraschall.GetRegionByScreenCoordinates(integer xmouseposition)</functioncall>
  <description>
    returns the regions at a given absolute-x-pixel-position. It sees regions according their graphical representation in the arrange-view, not just their position! Returned string will be "Regionidx\npos\nName\nRegionidx2\npos2\nName2\n...".
    Returns only regions, no time markers or other markers!
    Will return "", if no region has been found.
    
    Note: there might be an offset, when the drag-edges-cursor is activated at the edges of the "head" of the region.
          So if you notice the edge of the region before the drag-cursor is visible, this is actually precise.
          In the future, I might add an option to correct this offset, so getting the left-draggable areas
          of the region is possible(it's complicated).
        
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all regionnumbers, regionpositions and regionnames, separated by a newline. 
                  - Can contain numerous regions, if there are more regions in one position.
    string region_index - a newline separated string with all region-index-numbers found; 0-based
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

  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
  ten=73*scale
  nine=65*scale
  eight=57*scale
  seven=49*scale
  six=41*scale
  five=33*scale
  four=25*scale
  three=17*scale
  two=10*scale
  one=5*scale
  
  local retstring=""
  local retstring2=""
  local temp
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local ALABAMA=xmouseposition
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=math.floor(nine)
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=math.floor(eight)
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=math.floor(seven)
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=math.floor(six)
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=math.floor(five)
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=math.floor(four)
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=math.floor(three)
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=math.floor(two)
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=math.floor(one)
      end
      local A1, A2=xmouseposition-temp, xmouseposition
      local Ax, AAx= reaper.GetSet_ArrangeView2(0, false, xmouseposition-temp+4, xmouseposition)
      local AAA=xmouseposition-temp
      local AAA2=xmouseposition
      
      if pos>=Ax and pos<=AAx then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name.."\n" 
        retstring2=retstring2..tonumber(retval-1).."\n" 
      elseif Ax>=pos and Ax<=rgnend then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name
        retstring2=retstring2..tonumber(retval-1).."\n" 
      end
    end
  end
  return retstring, retstring2
end

function ultraschall.GetRegionByTime(position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRegionByTime</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string markers, string region_index = ultraschall.GetRegionByTime(number position)</functioncall>
  <description>
    returns the regions at a given position in seconds. It sees regions according their graphical representation in the arrange-view, not just their position! Returned string will be "Regionidx\npos\nName\nRegionidx2\npos2\nName2\n...".
    Returns only regions, no timesignature-markers or other markers!
    Will return "", if no region has been found.
    
    returns nil in case of an error
  </description>
  <retvals>
    string marker - a string with all regionnumbers, regionpositions and regionnames, separated by a newline. 
                  - Can contain numerous regions, if there are more regions in one position.
    string region_index - a newline separated string with all region-index-numbers found; 0-based
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

  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
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
  local retstring2=""
  local temp
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  for i=0, retval do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if isrgn==true then
      if markrgnindexnumber>999999999 then temp=ten
      elseif markrgnindexnumber>99999999 and markrgnindexnumber<1000000000  then temp=math.floor(nine)
      elseif markrgnindexnumber>9999999 and markrgnindexnumber<100000000 then temp=math.floor(eight)
      elseif markrgnindexnumber>999999 and markrgnindexnumber<10000000 then temp=math.floor(seven)
      elseif markrgnindexnumber>99999 and markrgnindexnumber<1000000 then temp=math.floor(six)
      elseif markrgnindexnumber>9999 and markrgnindexnumber<100000 then temp=math.floor(five)
      elseif markrgnindexnumber>999 and markrgnindexnumber<10000 then temp=math.floor(four)
      elseif markrgnindexnumber>99 and markrgnindexnumber<1000 then temp=math.floor(three)
      elseif markrgnindexnumber>9 and markrgnindexnumber<100 then temp=math.floor(two)
      elseif markrgnindexnumber>-1 and markrgnindexnumber<10 then temp=math.floor(one)
      end
      local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.get_ini_file())
      local Ax,AAx=reaper.GetSet_ArrangeView2(0, false, ARetval2+57-temp, ARetval2+57)
      local Bx=AAx-Ax
      if Bx+pos>=position and pos<=position then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name.."\n"
        retstring2=retstring2..tonumber(retval-1).."\n" 
      elseif pos<=position and rgnend>=position then 
        retstring=retstring..markrgnindexnumber.."\n"..pos.."\n"..name, 2
        retstring2=retstring2..tonumber(retval-1).."\n" 
      end
    end
  end
  return retstring, retstring2
end

function ultraschall.GetTimeSignaturesByScreenCoordinates(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTimeSignaturesByScreenCoordinates</slug>
  <requires>
    Ultraschall=4.7
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

  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
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
    Ultraschall=4.7
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

  local scale = ultraschall.GetScaleRangeFromDpi(tonumber(dpi))
  if dpi=="512" then scale=2 elseif dpi=="256" then scale=1 end  
  
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
    local Aretval,ARetval2=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.get_ini_file())
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
    deprecated
    returns true, if the marker is a Podrange-region, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <deprecated since_when="US4.4" alternative=""/>
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
  ultraschall.deprecated("IsRegionPodrange")
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

function ultraschall.AddEditRegion(startposition, endposition, text)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddEditRegion</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>integer markernr, string guid, integer edit_region_index  = ultraschall.AddEditRegion(number startposition, number endposition, string text)</functioncall>
  <description>
    Adds a new edit-region and returns index of the newly created edit-marker-region.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer markernr - the number of the newly created region
    string guid - the guid, associated with this edit-region
    integer edit_region_index - the index of the edit-region within all edit-regions
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
  -- prepare variables
  local color=0
  if string.match(reaper.GetOS(), "Win") then 
    color = 0x0000FF|0x1000000
  else
    color = 0xFF0000|0x1000000
  end
  
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("AddEditRegion", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("AddEditRegion", "endposition", "must be a number", -2) return -1 end
  if startposition<0 then ultraschall.AddErrorMessage("AddEditRegion", "startposition", "must be bigger than 0", -3) return -1 end
  if endposition<startposition then ultraschall.AddErrorMessage("AddEditRegion", "endposition", "must be bigger than startposition", -4) return -1 end
  if text~=nil and type(text)~="string" then ultraschall.AddErrorMessage("AddEditRegion", "text", "must be a string or nil", -5) return -1 end
  if text==nil then text="" end
  
  local shown_number, marker_index, guid = ultraschall.AddProjectMarker(0, true, startposition, endposition, "_Edit: "..text, 0, color)

  return marker_index, guid, ultraschall.GetEditRegionIDFromGuid(guid)
end

--A=ultraschall.AddEditRegion(10,26,"")

function ultraschall.SetEditRegion(number, position, endposition, edittitle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEditRegion</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
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
  if string.match(Os, "Win") then 
    color = 0x0000FF|0x1000000
  else
    color = 0xFF0000|0x1000000
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
                   - true, the time in markerstring must follow the format hh:mm:ss.mss , e.g. 11:22:33.444
                   - false, the time can be more flexible, leading to possible misinterpretation of indexnumbers as time/seconds
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
        local retnumber, retidxnum, position, markertitle, guid= ultraschall.EnumerateNormalMarkers(i)
        if retidxnum==b then 
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
    Ultraschall=4.2
    Reaper=6.20
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

  local MarkerGuids={}
  local MarkerGuids_count=0
  for i=start, stop, step do
    local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)

    if pos>=startposition and pos<=endposition and isrgn==false then
        MarkerGuids_count=MarkerGuids_count+1
        MarkerGuids[MarkerGuids_count]=ultraschall.GetGuidFromMarkerID(sretval)
    end
  end
  for i=1, MarkerGuids_count do
    local sretval=ultraschall.GetMarkerIDFromGuid(MarkerGuids[i])
    local sretval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, sretval-1)
    reaper.SetProjectMarkerByIndex(0, sretval-1, isrgn, pos+moveby, rgnend, markrgnindexnumber, name, color)
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


function ultraschall.RippleCut_Regions_Reverse(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut_Regions_Reverse</slug>
  <requires>
    Ultraschall=5.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean were_regions_altered, integer number_of_altered_regions, array altered_regions  = ultraschall.RippleCut_Regions_Reverse(number startposition, number endposition)</functioncall>
  <description>
    Ripplecuts regions, where applicable.
    It cuts all (parts of) regions between startposition and endposition and moves remaining parts plus all regions before startposition by endposition-startposition toward projectend(!)
    
    Returns false in case of an error.
  </description>
  <parameters>
    number startposition - the startposition from where regions shall be cut from; all regions/parts of regions before that will be moved toward projectend
    number endposition - the endposition to which regions shall be cut from
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
  <tags>marker management, ripple, cut, regions, reverse</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions_Reverse", "startposition", "must be a number", -1) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions_Reverse", "endposition", "must be a number", -2) return false end
  local dif=endposition-startposition
  
  -- get all regions, that are candidates for a ripplecut
  local number_of_all_regions, allregionsarray = ultraschall.GetAllRegionsBetween(0, endposition, true)  
  if number_of_all_regions==0 then ultraschall.AddErrorMessage("RippleCut_Regions_Reverse", "", "no regions found within start and endit", -3) return false, regioncount, regionfound end
  
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
--print2("0")
      -- if region is fully within start and endit, cut it completely
      regionfound[i][6]="CUT COMPLETELY"
      reaper.DeleteProjectMarker(0, markrgnindexnumber, true)
elseif pos1<=start and pos1<endit and rgnend1<endit and rgnend1+dif>endit then --and rgnend1<=endit then
      -- if regionend is within start and endit, move the start toward the end
--print2("A")
      regionfound[i][6]="CUT AT THE END"
      regionfound[i][7]=pos+dif
      regionfound[i][8]=endit
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos+dif, endit, name, color, 0)
--]]
    elseif pos1>=start and pos1<=endit and rgnend1>endit then
      -- if regionstart is within start and endit, shorten the region and move it by difference of start and endit
      --    toward projectend
--print2("B")
      regionfound[i][6]="CUT AT THE BEGINNING"
      regionfound[i][7]=endit
      regionfound[i][8]=rgnend
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, endit, rgnend, name, color, 0)
    elseif pos1<=start and rgnend1<=start then 
--print2("C")
      -- if region is before start, just move the region by difference of start and endit toward projectend
      regionfound[i][6]="MOVED TOWARD PROJECTEND"
      regionfound[i][7]=pos+dif
      regionfound[i][8]=rgnend+dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos+dif, rgnend+dif, name, color, 0)
    elseif start>=pos1 and endit<=rgnend then
      -- if start and endit is fully within a region, cut at the start of the region the difference of start and endit
--print2("D")
      regionfound[i][6]="CUT IN THE MIDDLE"
      regionfound[i][7]=pos+dif
      regionfound[i][8]=rgnend
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos+dif, rgnend, name, color, 0)
    else
      --print2("E")
    end
  end
  -- sort the table of found regions
  return true, regioncount, regionfound
end

function ultraschall.GetAllCustomMarkers(custom_marker_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllCustomMarkers</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table marker_array = ultraschall.GetAllCustomMarkers(string custom_marker_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return all custom-markers with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not check custom-regions, use [GetAllCustomRegions](#GetAllCustomRegions) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will return all custom marker
  </parameters>
  <retvals>
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
  if custom_marker_name=="" then custom_marker_name=".*" end

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
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table marker_array = ultraschall.GetAllCustomRegions(string custom_region_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return all custom-regions with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not check custom-markers, use [GetAllCustomMarkers](#GetAllCustomMarkers) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will return all custom-regions
  </parameters>
  <retvals>
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
  if custom_region_name=="" then custom_region_name=".*" end
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

function ultraschall.CountAllCustomMarkers(custom_marker_name, starttime, endtime)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountAllCustomMarkers</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountAllCustomMarkers(string custom_marker_name, optional number starttime, optional number endtime)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will count all custom-markers with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not count custom-regions, use [CountAllCustomRegions](#CountAllCustomRegions) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" counts all custom markers, regardless of their name
    optional number starttime - the starttime, from which to count the markers
    optional number endtime - the endtime, to which to count the markers
  </parameters>  
  <retvals>
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
  if type(custom_marker_name)~="string" then ultraschall.AddErrorMessage("CountAllCustomMarkers", "custom_marker_name", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(custom_marker_name)==false then ultraschall.AddErrorMessage("CountAllCustomMarkers", "custom_marker_name", "not a valid matching-pattern", -2) return -1 end
  if starttime~=nil and type(starttime)~="number" then ultraschall.AddErrorMessage("CountAllCustomMarkers", "starttime", "must be nil or a number", -3) return -1 end
  if endtime~=nil and type(endtime)~="number" then ultraschall.AddErrorMessage("CountAllCustomMarkers", "endtime", "must be nil or a number", -4) return -1 end
  if starttime==nil then starttime=0 end
  if endtime==nil then endtime=reaper.GetProjectLength(0) end
  local count=0
  if custom_marker_name=="" then custom_marker_name=".*" end
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0,i)    
    if isrgn==false and name:match("^_"..custom_marker_name..":")~=nil then
      if pos>=starttime and pos<=endtime then
        count=count+1 
      end
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
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountAllCustomRegions(string custom_region_name)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will count all custom-regions with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not count custom-markers, use [CountAllCustomMarkers](#CountAllCustomMarkers) instead.
    
    returns -1 in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will count all custom-regions, regardless of their names
  </parameters>
  <retvals>
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
  if custom_region_name=="" then custom_region_name=".*" end
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
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, string name, integer shown_number, integer color, string guid = ultraschall.EnumerateCustomMarkers(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return a specific custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not enumerate custom-regions, use [EnumerateCustomRegions](#EnumerateCustomRegions) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will enumerate over all existing custom-markers
    integer idx - the index of the marker within all same-named custom-markers; 0, for the first custom-marker
  </parameters>
  <retvals>
    boolean retval - true, if the custom-marker exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 1 for the second, etc
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
  if custom_marker_name=="" then custom_marker_name=".*" end

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
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, number regionend, string name, integer shown_number, integer color, string guid = ultraschall.EnumerateCustomRegions(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will return a specific custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
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
  <retvals>
    boolean retval - true, if the custom-region exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 1 for the second, etc
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
  if custom_region_name=="" then custom_region_name=".*" end

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
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, string name, integer shown_number, integer color = ultraschall.DeleteCustomMarkers(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will delete a specific custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not delete custom-regions, use [DeleteCustomRegions](#DeleteCustomRegions) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will delete over all custom-markers available, regardless of their name
    integer idx - the index of the marker within all same-named custom-markers; 0, for the first custom-marker    
  </parameters>
  <retvals>
    boolean retval - true, if the custom-marker exists; false, if not or an error occurred
    integer marker_index - the index of the marker within all markers and regions, as positioned in the project, with 0 for the first, 1 for the second, etc
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
  if custom_marker_name=="" then custom_marker_name=".*" end

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
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, number regionend, string name, integer shown_number, integer color = ultraschall.DeleteCustomRegions(string custom_marker_name, integer idx)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deletes a specific custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not delete custom-markers, use [DeleteCustomMarkers](#DeleteCustomMarkers) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_region_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - Lua-pattern-matching-expressions are allowed. This parameter is NOT case-sensitive.
                              - "" will delete over all custom-regions available, regardless of their name
    integer idx - the index of the region within all same-named custom-regions; 0, for the first custom-region
  </parameters>
  <retvals>
    boolean retval - true, if the custom-region exists; false, if not or an error occurred
    integer marker_index - the index of the region within all custom regions, by position in the project, with 0 for the first, 1 for the second, etc
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
  if custom_region_name=="" then custom_region_name=".*" end

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
    Ultraschall=4.3
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer markernumber, string guid, integer custommarker_index = ultraschall.AddCustomMarker(string custom_marker_name, number pos, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will add new custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
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
  <retvals>
    boolean retval - true, if adding the custom-marker was successful; false, if not or an error occurred
    integer markernumber - the indexnumber of the newly added custommarker within all regions and markers; 0-based
                         - use this for Reaper's own marker-management-functions
    string guid - the guid of the custommarker
    integer custommarker_index - the index of the custom-marker within the custom-markers only(!); 0-based
                               - use this for Ultraschall-API's custom-markers-functions
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
   
  local ocm=custom_marker_name
  local found_custommarker_idx=-99999
  if custom_marker_name==nil then custom_marker_name=name else custom_marker_name="_"..custom_marker_name..": "..name end  
  
  local index, marker_region_index, guid = ultraschall.AddProjectMarker(0, false, pos, 0, custom_marker_name, shown_number, color)

  for i=0, ultraschall.CountAllCustomMarkers(ocm) do    
    local retval, markerindex, pos2, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomMarkers(ocm, i)
    if guid2==guid then found_custommarker_idx=i end
  end

  return true, marker_region_index, guid, found_custommarker_idx
end
--A,B,C=ultraschall.AddCustomMarker("vanillachief", 1, "Hulahoop", 987, 9865)


function ultraschall.AddCustomRegion(custom_region_name, pos, regionend, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddCustomRegion</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shown_number, integer markerindex, string guid, integer customregion_index = ultraschall.AddCustomRegion(string custom_region_name, number pos, number regionend, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will add new custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
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
  <retvals>
    boolean retval - true, if adding the custom-region was successful; false, if not or an error occurred
    integer shown_number - if the desired shown_number is already used by another region, this will hold the alternative number for the new custom-region
    integer markernumber - the indexnumber of the newly added customregion within all regions and markers; 0-based
                         - use this for Reaper's own marker-management-functions
    string guid - the guid of the customregion
    integer customregion_index - the index of the custom-region within the custom-regions only(!); 0-based
                               - use this for Ultraschall-API's custom-regions-functions
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
  
  local ocm=custom_region_name
  local found_custommarker_idx=-99999
  if custom_region_name==nil then custom_region_name=name else custom_region_name="_"..custom_region_name..": "..name end  
  
  local index, marker_region_index, guid = ultraschall.AddProjectMarker(0, true, pos, regionend, custom_region_name, shown_number, color)

  for i=0, ultraschall.CountAllCustomRegions(ocm) do    
    local retval, markerindex, pos2, rgnend2, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomRegions(ocm, i)
    if guid2==guid then found_custommarker_idx=i end
  end
  
  return true, shown_number, marker_region_index, guid, found_custommarker_idx
end

--A,B,C=ultraschall.AddCustomRegion("vanillachief", 105, 150, "Hulahoop", 987, 9865)

-- Mespotine

function ultraschall.SetCustomMarker(custom_marker_name, idx, pos, name, shown_number, color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetCustomMarker</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetCustomMarker(string custom_marker_name, integer idx, number pos, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will set attributes of an already existing custom-marker with a certain name.
    
    A custom-marker has the naming-scheme 
        
        _customname: text for this marker
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-marker has the name
      
       __customname:: test for this marker
        
    Example:
    
    The custom-marker *VanillaChief* has the custom\_marker\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-markers.
    
    Will not set custom-regions, use [SetCustomRegion](#SetCustomRegion) instead.
    
    returns false in case of an error
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-marker. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-marker is called "__CustomMarker::"; nil, make it a normal marker
                              - "" will use idx over all custom-markers, regardless of their name
    integer idx - the index-number of the custom-marker within all custom-markers
    number pos - the position of the marker in seconds
    string name - the name of the marker, exluding the custom-marker-name
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals>
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
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shown_number = ultraschall.SetCustomRegion(string custom_region_name, integer idx, number pos, number regionend, string name, integer shown_number, integer color)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will set an already existing custom-region with a certain name.
    
    A custom-region has the naming-scheme 
        
        _customname: text for this region
        
    You just need to pass customname to this function, leaving out the preceding \_ and the trailing :
    Exception: if the custom-region has the name
      
        __customname:: test for this region
        
    Example:
    
    The custom-region *VanillaChief* has the custom\_region\_name *VanillaChief* and will be shown as *\_VanillaChief: text* in the project.
    So you pass VanillaChief to this function to get all \_VanillaChief:-regions.
    
    Will not add custom-markers, use [AddCustomMarker](#AddCustomMarker) instead.
    
    returns false in case of an error, like the desired shown_number is already taken by another region
  </description>
  <parameters>
    string custom_marker_name - the name of the custom-region. Don't include the _ at the beginning and the : at the end, or it might not be found. Exception: Your custom-region is called "__CustomRegion::"
                              - "" will use idx over all custom-markers, regardless of their name
    integer idx - the index of the custom region to change
    number pos - the position of the region in seconds
    string name - the name of the region, exluding the custom-region-name
    integer shown_number - the regionnumber, that is displayed in the timeline of the arrangeview
    integer color - the color of the marker
  </parameters>
  <retvals>
    boolean retval - true, if adding the region was successful; false, if not or an error occurred
                   - false could be an indicator, that there's already a region using the number passed over in shown_number
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
  
  retval, markerindex = ultraschall.EnumerateCustomRegions(custom_region_name, idx)
  
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
  <retvals>
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
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsMarkerValidCustomMarker(string custom_marker_name, integer markeridx)</functioncall>
  <description>
    returns true, if the marker with id markeridx is a valid custom-marker of the type custom_marker_name
    
    markeridx is the index of all markers and regions!
    
    returns false in case of an error
  </description>
  <paramters>
    string custom_marker_name - the custom-marker-name to check against; can also be a Lua-pattern-matching-expression
                              - "" checks, whether a marker is custom-marker in general, regardless of their name
    integer markeridx - the index of the marker to check; this is the index of all markers and regions!
  </parameters>
  <retvals>
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
    if B[i]["index"]==markeridx then return true, i end
  end
  return false
end

--C=ultraschall.IsMarkerValidCustomMarker("(.*)",0)


function ultraschall.IsRegionValidCustomRegion(custom_region_name, markeridx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsRegionValidCustomRegion</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsRegionValidCustomRegion(string custom_region_name, integer markeridx)</functioncall>
  <description>
    returns true, if the marker with id markeridx is a valid custom-region of the type custom_region_name
    
    markeridx is the index of all markers and regions!
    
    returns false in case of an error
  </description>
  <paramters>
    string custom_region_name - the custom-reion-name to check against; can also be a Lua-pattern-matching-expression
                              - "" checks, whether a region is custom-region in general, regardless of their name
    integer markeridx - the index of the marker to check; this is the index of all markers and regions!
  </parameters>
  <retvals>
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
    integer index - the index of the marker/region, whose guid you have passed to this function; 1 for the first marker/region
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

function ultraschall.GetAllCustomMarkerNames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllCustomMarkerNames</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table custom_marker_names = ultraschall.GetAllCustomMarkerNames()</functioncall>
  <description>
    Will return all names of all available custom-markers.
  </description>  
  <retvals>
    integer count - the number of found markers; -1, in case of an error
    table custom_marker_names - a table with all found custom-markernames. 
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, all, custom marker names</tags>
</US_DocBloc>
]]
  local MarkerNames={}
  local CountMarkerNames=0
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local A,B,C,D,E,F=reaper.EnumProjectMarkers(i)
    if B==false then
      local name=E:match("%_(.-):")
      if name~=nil then CountMarkerNames=CountMarkerNames+1 MarkerNames[CountMarkerNames]=name end
    end
  end
  return CountMarkerNames, MarkerNames
end

--A1,B1=ultraschall.GetAllCustomMarkerNames()

function ultraschall.GetAllCustomRegionNames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllCustomRegionNames</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, table custom_region_names = ultraschall.GetAllCustomRegionNames()</functioncall>
  <description>
    Will return all names of all available custom-regions.
  </description>  
  <retvals>
    integer count - the number of found markers; -1, in case of an error
    table custom_region_names - a table with all found custom-regionnames. 
  </retvals>
  <chapter_context>
    Markers
    Custom Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, all, custom region names</tags>
</US_DocBloc>
]]
  local MarkerNames={}
  local CountMarkerNames=0
  for i=0, reaper.CountProjectMarkers(0)-1 do
    local A,B,C,D,E=reaper.EnumProjectMarkers(i)
    if B==true then
      local name=E:match("%_(.-):")
      if name~=nil then CountMarkerNames=CountMarkerNames+1 MarkerNames[CountMarkerNames]=name end
    end
  end
  return CountMarkerNames, MarkerNames
end

--A,B=ultraschall.GetAllCustomMarkerNames()

function ultraschall.GetGuidFromNormalMarkerID(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromNormalMarkerID</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromNormalMarkerID(integer index)</functioncall>
  <description>
    Gets the corresponding guid of a normal marker with a specific index 
    
    The index is for normal markers only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the normal marker with a specific index
  </retvals>
  <parameters>
    integer index - the index of the normal marker, whose guid you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, normal marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromNormalMarkerID", "idx", "must be an integer", -1) return nil end
  local retnumber, retidxnum, position, markertitle, guid2 = ultraschall.EnumerateNormalMarkers(idx)
  return guid2
end


--A=ultraschall.GetGuidFromNormalMarkerID(1)

function ultraschall.GetNormalMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNormalMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetNormalMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a normal-marker-guid
    
    The index is for all normal markers only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the marker, whose guid you have passed to this function
  </retvals>
  <parameters>
    string guid - the guid of the marker, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, normal marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetNormalMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end
  for i=0, ultraschall.CountNormalMarkers() do
    local retnumber, retidxnum, position, markertitle, guid2 = ultraschall.EnumerateNormalMarkers(i)
    if guid2==guid then return i end
  end
  return -1
end

--B=ultraschall.GetNormalMarkerIDFromGuid(A)


function ultraschall.AddProjectMarker(proj, isrgn, pos, rgnend, name, wantidx, color)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>AddProjectMarker</slug>
    <title>AddProjectMarker</title>
    <functioncall>integer index, integer marker_region_index, string guid = ultraschall.AddProjectMarker2(ReaProject proj, boolean isrgn, number pos, number rgnend, string name, integer wantidx, integer color)</functioncall>
    <requires>
        Ultraschall=4.4
        Reaper=6.22
    </requires>
    <description>
        Creates a new projectmarker/region and returns the shown number, index and guid of the created marker/region. 
        
        Supply wantidx&gt;=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use. color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
        
        Returns -1 in case of an error
    </description>
    <retvals>
        integer index - the shown-number of the newly created marker/region
        integer marker_region_index - the index of the newly created marker/region within all markers/regions
        string guid - the guid of the newly created marker/region
    </retvals>
    <linked_to desc="see:">
        inline:ColorToNative
               to convert color-value to a native(Mac, Win, Linux) colors
    </linked_to>
    <parameters>
        ReaProject proj - the project, in which to add the new marker; use 0 for the current project; 
        boolean isrgn - true, if it shall be a region; false, if a normal marker
        number pos - the position of the newly created marker/region in seconds
        number rgnend - if the marker is a region, this is the end of the region in seconds
        string name - the shown name of the marker
        integer wantidx - the shown number of the marker/region. Markers can have the same shown marker multiple times. Regions will get another number, if wantidx is already given.
        integer color - the color of the marker
    </parameters>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
    <chapter_context>
        Markers
        Project Markers
    </chapter_context>
    <tags>markermanagement, region, marker, name, shownnumber, pos, project, add, guid</tags>
    <changelog>
    </changelog>
  </US_DocBloc>
--]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("AddProjectMarker", "proj", "not a valid project", -1) return -1 end
  if type(isrgn)~="boolean" then ultraschall.AddErrorMessage("AddProjectMarker", "isrgn", "must be a boolean", -2) return -1 end
  if type(pos)~="number" then ultraschall.AddErrorMessage("AddProjectMarker", "pos", "must be a number", -3) return -1 end
  if type(rgnend)~="number" then ultraschall.AddErrorMessage("AddProjectMarker", "rgnend", "must be a number", -4) return -1 end
  if type(name)~="string" then ultraschall.AddErrorMessage("AddProjectMarker", "name", "must be a string", -5) return -1 end
  if math.type(wantidx)~="integer" then ultraschall.AddErrorMessage("AddProjectMarker", "wantidx", "must be an integer", -6) return -1 end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("AddProjectMarker", "color", "must be an integer", -7) return -1 end

  -- add a marker AFTER the current last marker(makes finding Guid for it faster)
  local shown_number=reaper.AddProjectMarker2(proj, isrgn, reaper.GetProjectLength()+100, reaper.GetProjectLength()+100, name, wantidx, color)
  
  -- get the guid of the new last marker
  local retval, Guid = reaper.GetSetProjectInfo_String(proj, "MARKER_GUID:"..reaper.CountProjectMarkers(proj)-1, "", false)

  -- change position to the actual position of the marker
  local LastMarker2={reaper.EnumProjectMarkers3(proj, reaper.CountProjectMarkers(proj)-1)} -- get the current shown marker-number
  reaper.SetProjectMarkerByIndex2(proj, reaper.CountProjectMarkers(proj)-1, isrgn, pos, rgnend, LastMarker2[6], name, color, 0)
  
  -- find the index-position of the marker by its Guid
  local found_marker_index="Buggy" -- debugline, hope it never gets triggered
  for i=0, reaper.CountProjectMarkers() do
    local retval2, Guid2 = reaper.GetSetProjectInfo_String(proj, "MARKER_GUID:"..i, "", false)
    if Guid2==Guid then found_marker_index=i break end
  end
  
  return shown_number, found_marker_index, Guid
end


function ultraschall.GetEditMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEditMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetEditMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of an edit-marker-guid
    
    The index is for all _edit:-markers or _edit-markers only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the edit-marker, whose guid you have passed to this function
  </retvals>
  <parameters>
    string guid - the guid of the edit-marker, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, edit marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetEditMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end  
  for i=1, ultraschall.CountEditMarkers() do
    local retval, marker_index, pos, name, guid2 = ultraschall.EnumerateEditMarkers(i)
    if guid2==guid then return i end
  end
  return -1
end

--A=ultraschall.GetEditMarkerIDFromGuid("{2C501E21-FD5E-47A0-B8A5-0D1A3BEFC7B9}")


function ultraschall.GetGuidFromEditMarkerID(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromEditMarkerID</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromEditMarkerID(integer index)</functioncall>
  <description>
    Gets the corresponding guid of an edit-marker with a specific index 
    
    The index is for _edit:-markers and _edit-markers only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the edit marker with a specific index
  </retvals>
  <parameters>
    integer index - the index of the edit marker, whose guid you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, edit marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromEditMarkerID", "idx", "must be an integer", -1) return end
  local retval, marker_index, pos, name, guid2 = ultraschall.EnumerateEditMarkers(idx)

  return guid2
end

function ultraschall.GetEditRegionIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEditRegionIDFromGuid</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetEditRegionIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of an edit-region-guid
    
    The index is for all _edit:-regions or _edit-regions only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the edit-region, whose guid you have passed to this function
  </retvals>
  <parameters>
    string guid - the guid of the edit-region, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, edit region, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetEditRegionIDFromGuid", "guid", "must be a string", -1) return -1 end  
  for i=0, ultraschall.CountEditRegions() do
    local retval, marker_index, pos, name, color, guid2 = ultraschall.EnumerateEditRegion(i)
    if guid2==guid then return i end
  end
  return -1
end

--A=ultraschall.GetEditRegionIDFromGuid("{3AA001F1-0D79-4BBF-8F46-AD84F9003682}")


function ultraschall.GetGuidFromEditRegionID(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromEditRegionID</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromEditRegionID(integer index)</functioncall>
  <description>
    Gets the corresponding guid of an edit-region with a specific index 
    
    The index is for _edit:-regions and _edit-regions only
    
    returns -1 in case of an error
  </description>
  <retvals>
    string guid - the guid of the edit region with a specific index
  </retvals>
  <parameters>
    integer index - the index of the edit region, whose guid you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, edit region, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromEditRegionID", "idx", "must be an integer", -1) return -1 end
  local retval, marker_index, pos, name, color, guid2 = ultraschall.EnumerateEditRegion(idx)

  return guid2
end


--A=ultraschall.GetGuidFromEditRegionID(1)

function ultraschall.StoreTemporaryMarker(marker_id, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreTemporaryMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.StoreTemporaryMarker(integer marker_id, optional integer index)</functioncall>
  <description>
    Stores a marker/region temporarily for later use.
    
    See GetTemporaryMarker to get the index of the marker, which will also keep in mind, if scripts or the user change the order of the markers/regions in the meantime.
    
    It's good practice to remove a temporary marker you don't need anymore, using marker_id=-1, Otherwise you might accidentally mess around with a temporary marker, that you forgot about but was still stored.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, storing temporary marker was successful; false, storing temporary marker was unsuccessful
  </retvals>
  <parameters>
    integer marker_id - the index of the marker/region within all markers and regions, that you want to temporarily store; 0-based; 
                      - -1, to remove this temporary marker; 
                      - -2, to store the last marker before edit-cursor position
                      - -3, to store the last marker before play-cursor position
                      - -4, to store the last marker before position underneath mouse-cursor
    optional integer index - a numerical index, if you want to temporarily store multiple markers/regions; default is 1
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, store, temporary marker, guid</tags>
</US_DocBloc>
--]]  
  if math.type(marker_id)~="integer" then ultraschall.AddErrorMessage("StoreTemporaryMarker", "marker_id", "must be an integer", -1) return false end
  if marker_id>=0 then marker_id=marker_id+1 end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("StoreTemporaryMarker", "index", "must be an integer", -2) return false end
  if index==nil then index=1 end
  if marker_id==-1 then 
    reaper.DeleteExtState("ultraschall_api", "Temporary_Marker_"..index, false)
    return true
  elseif marker_id==-2 then 
    marker_id=reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())+1
  elseif marker_id==-3 then 
    marker_id=reaper.GetLastMarkerAndCurRegion(0, reaper.GetPlayPosition())+1
  elseif marker_id==-4 then
    reaper.BR_GetMouseCursorContext()
    marker_id=reaper.GetLastMarkerAndCurRegion(0, reaper.BR_GetMouseCursorContext_Position())+1
  end
  local Guid = ultraschall.GetGuidFromMarkerID(marker_id)
  if Guid==-1 then ultraschall.AddErrorMessage("StoreTemporaryMarker", "marker_id", "no such marker", -3) return false end
  
  reaper.SetExtState("ultraschall_api", "Temporary_Marker_"..index, Guid, false)  
  return true
end

function ultraschall.GetTemporaryMarker(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTemporaryMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer marker_id, string guid = ultraschall.GetTemporaryMarker(optional integer index)</functioncall>
  <description>
    returns a temporarily stored marker/region.
    
    See StoreTemporaryMarker to set temporary markers/regions.
    
    It is good practice to "clear" the temporary marker, if not needed anymore, by using StoreTemporaryMarker with marker_id=-1
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer marker_id - the current id of the stored marker/region; 0-based; -1, in case of an error
    string guid - the guid of the marker
  </retvals>
  <parameters>
    optional integer index - a numerical index, if you stored multiple temporary markers/regions; default is 1
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, temporary marker, guid</tags>
</US_DocBloc>
--]]  
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("GetTemporaryMarker", "index", "must be an integer", -1) return false end
  if index==nil then index=1 end
  local marker=reaper.GetExtState("ultraschall_api", "Temporary_Marker_"..index)
  if marker=="" then return -1 else return ultraschall.GetMarkerIDFromGuid(marker)-1, marker  end
end


function ultraschall.AddShownoteMarker(pos, name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddShownoteMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer markernumber, string guid, integer shownotemarker_index = ultraschall.AddShownoteMarker(number pos, string name)</functioncall>
  <description>
    Will add new shownote-marker.
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this shownote
    
    returns -1 in case of an error
  </description>
  <parameters>
    number pos - the position of the marker in seconds
    string name - the name of the shownote-marker
  </parameters>
  <retvals>
    integer markernumber - the indexnumber of the newly added shownotemarker within all regions and markers; 0-based
                         - use this for Reaper's regular marker-functions
                         - -1 in case of an error
    string guid - the guid of the shownotemarker
    integer shownotemarker_index - the index of the shownote-marker within shownotes only; 1-based. 
                                 - Use this for the other Ultraschall-API-shownote-functions!
  </retvals>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, add, shownote, name, position, index, guid</tags>
</US_DocBloc>
]]
  if type(pos)~="number" then ultraschall.AddErrorMessage("AddShownoteMarker", "pos", "must be a number", -2) return -1 end
  if type(name)~="string" then ultraschall.AddErrorMessage("AddShownoteMarker", "name", "must be a string", -3) return -1  end
  local Count = ultraschall.CountAllCustomMarkers("Shownote")
  local Color
  if reaper.GetOS():sub(1,3)=="Win" then
    Color = 0x3E90FF|0x1000000
  else
    Color = 0xFF903E|0x1000000
  end
  local name2=reaper.genGuid("")..reaper.time_precise()..reaper.genGuid("")
  local A={ultraschall.AddCustomMarker("Shownote", pos, name2, Count+1, Color)}  
  A[4]=A[4]+1
  ultraschall.SetShownoteMarker(A[4], pos, name)
  local A1,B1,C1=ultraschall.GetSetShownoteMarker_Attributes(true, A[4], "shwn_guid", "")
  if A[1]==false then A[2]=-1 end
  table.remove(A,1)
  return table.unpack(A)
end



function ultraschall.SetShownoteMarker(idx, pos, name, shown_number)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetShownoteMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetShownoteMarker(integer idx, number pos, string name, optional integer shown_number)</functioncall>
  <description>
    Will set an already existing shownote-marker.
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this shownote
    
    returns false in case of an error
  </description>
  <parameters>
    integer idx - the index of the shownote marker within all shownote-markers you want to set; 1-based
    number pos - the new position of the marker in seconds
    string name - the new name of the shownote-marker
    optional integer shown_number - the shown-number of the marker; set to nil to use the current one
  </parameters>
  <retvals>
    boolean retval - true, if setting the shownote-marker was successful; false, if not or an error occurred
  </retvals>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, set, shownote, name, position, index</tags>
</US_DocBloc>
]]
  if type(pos)~="number" then ultraschall.AddErrorMessage("SetShownoteMarker", "pos", "must be a number", -1) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetShownoteMarker", "name", "must be a string", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetShownoteMarker", "idx", "must be an integer", -3) return false end
  if shown_number~=nil and math.type(shown_number)~="integer" then ultraschall.AddErrorMessage("SetShownoteMarker", "shown_number", "must be nil or an integer", -5) return false end
  idx=idx-1
  local retval, markerindex, pos2, name2, shown_number2 = ultraschall.EnumerateCustomMarkers("Shownote", idx)
  if shown_number==nil then shown_number=shown_number2 end
  if retval==false then ultraschall.AddErrorMessage("SetShownoteMarker", "idx", "no such shownote-marker", -4) return false end
  
  local Count = ultraschall.CountAllCustomMarkers("Shownote")
  local Color
  if reaper.GetOS():sub(1,3)=="Win" then
    Color = 0x3E90FF|0x1000000
  else
    Color = 0xFF903E|0x1000000
  end
  local A={ultraschall.SetCustomMarker("Shownote", idx, pos, name, shown_number, Color)}
  return table.unpack(A)
end

function ultraschall.EnumerateShownoteMarkers(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateShownoteMarkers</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer marker_index, number pos, string name, integer shown_number, string guid = ultraschall.EnumerateShownoteMarkers(integer idx)</functioncall>
  <description>
    Will return a specific shownote-marker.
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this marker
        
    returns false in case of an error
  </description>
  <parameters>
    integer idx - the index of the marker within all shownote-markers; 1, for the first shownote-marker
  </parameters>
  <retvals>
    boolean retval - true, if the shownote-marker exists; false, if not or an error occurred
    integer marker_index - the index of the shownote-marker within all markers and regions, as positioned in the project, with 0 for the first, 1 for the second, etc
    number pos - the position of the shownote in seconds
    string name - the name of the shownote
    integer shown_number - the markernumber, that is displayed in the timeline of the arrangeview
    string guid - the guid of the shownote-marker
  </retvals>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, enumerate, custom markers, name, position, shown_number, index, guid</tags>
</US_DocBloc>
]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("EnumerateShownoteMarkers", "idx", "must be an integer", -1) return false end
  idx=idx-1
  local A = {ultraschall.EnumerateCustomMarkers("Shownote", idx)}
  if A[1]==false then ultraschall.AddErrorMessage("EnumerateShownoteMarkers", "idx", "no such shownote-marker", -2) return false end  
  table.remove(A, 6)
  return table.unpack(A)
end

function ultraschall.CountShownoteMarkers(starttime, endtime)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountShownoteMarkers</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer num_shownotes = ultraschall.CountShownoteMarkers(optional number starttime, optional number endtime)</functioncall>
  <description>
    Returns count of all shownotes
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this marker

  </description>
  <retvals>
    integer num_shownotes - the number of shownotes in the current project
  </retvals>
  <parameters>
    optional number starttime - the starttime, from which to count the markers
    optional number endtime - the endtime, to which to count the markers
  </parameters>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, count, shownote</tags>
</US_DocBloc>
]]
  if starttime~=nil and type(starttime)~="number" then ultraschall.AddErrorMessage("CountShownoteMarkers", "starttime", "must be nil or a number", -3) return -1 end
  if endtime~=nil and type(endtime)~="number" then ultraschall.AddErrorMessage("CountShownoteMarkers", "endtime", "must be nil or a number", -4) return -1 end
  if starttime==nil then starttime=0 end
  if endtime==nil then endtime=reaper.GetProjectLength(0) end
  return ultraschall.CountAllCustomMarkers("Shownote", starttime, endtime)
end
--Kuddel=FromClip()
--A,B,C=ultraschall.GetSetShownoteMarker_Attributes(false, 1, "image_content", "kuchen")
--SLEM()


function ultraschall.DeleteShownoteMarker(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteShownoteMarker</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteShownoteMarker(integer idx)</functioncall>
  <description>
    Deletes a shownotes
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this marker

    will also delete all stored additional attributes with the shownote!

    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, shownote deleted; false, shownote not deleted
  </retvals>
  <parameters>
    integer idx - the index of the shownote to delete, within all shownotes; 1-based
  </parameters>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, delete, shownote</tags>
</US_DocBloc>
]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteShownoteMarker", "idx", "must be an integer", -1) return false end
  idx=idx-1
  local A = {ultraschall.EnumerateCustomMarkers("Shownote", idx)}
  if A[1]==false then ultraschall.AddErrorMessage("DeleteShownoteMarker", "idx", "no such shownote-marker", -2) return false end  
  ultraschall.SetMarkerExtState(A[2], "", "")
  local retval, marker_index, pos, name, shown_number, color = ultraschall.DeleteCustomMarkers("Shownote", idx)
  return retval
end


function ultraschall.PrepareChapterMarkers4ReaperExport()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PrepareChapterMarkers4ReaperExport</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.PrepareChapterMarkers4ReaperExport()</functioncall>
  <description>
    Will add CHAP= to the beginning of each chapter-marker name. This will let Reaper embed this marker into the exported
    media-file as metadata, when rendering.
    
    Will add CHAP= only to chapter-markers, who do not already have that in their name.
  </description>
  <chapter_context>
    Markers
    Chapter Marker
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, prepare, chapter, export</tags>
</US_DocBloc>
]]
  local A,B=ultraschall.GetAllNormalMarkers()
  for i=1, A do
    if B[i][1]:sub(1,5)~="CHAP=" then
      ultraschall.SetNormalMarker(i, B[i][0], B[i][3], "CHAP="..B[i][1])
    end
  end
end

--ultraschall.PrepareChapterMarkers4ReaperExport()

function ultraschall.RestoreChapterMarkersAfterReaperExport()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RestoreChapterMarkersAfterReaperExport</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RestoreChapterMarkersAfterReaperExport()</functioncall>
  <description>
    Will remove CHAP= at the beginning of each chapter-marker name, so you have the original marker-names back after render-export.
    
    Will remove only CHAP= from chapter-markers and leave the rest untouched.
  </description>
  <chapter_context>
    Markers
    Chapter Marker
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, restore, chapter, export</tags>
</US_DocBloc>
]]
  local A,B=ultraschall.GetAllNormalMarkers()
  for i=1, A do
    if B[i][1]:sub(1,5)=="CHAP=" then
      ultraschall.SetNormalMarker(i, B[i][0], B[i][3], B[i][1]:sub(6,-1))
    end
  end
end

--ultraschall.RestoreChapterMarkersAfterReaperExport()

function ultraschall.GetGuidFromShownoteMarkerID(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromShownoteMarkerID</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromShownoteMarkerID(integer index)</functioncall>
  <description>
    Gets the corresponding guid of a shownote marker with a specific index 
    
    The index is for _shownote:-markers only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the shownote marker with a specific index
  </retvals>
  <parameters>
    integer index - the index of the shownote marker, whose guid you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, shownote marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromShownoteMarkerID", "idx", "must be an integer", -1) return end
  local retval, marker_index, pos, name, shown_number, guid2 = ultraschall.EnumerateShownoteMarkers(idx)

  return guid2
end


--A=ultraschall.GetGuidFromShownoteMarkerID(1)
--B={ultraschall.EnumerateShownoteMarkers(1)}
--SLEM()

function ultraschall.GetShownoteMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetShownoteMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetShownoteMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a shownote-marker-guid
    
    The index is for all _shownote:-markers only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the shownote-marker, whose guid you have passed to this function
  </retvals>
  <parameters>
    string guid - the guid of the shownote-marker, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, shownote marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetShownoteMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end  
  for i=0, ultraschall.CountShownoteMarkers() do
    ultraschall.SuppressErrorMessages(true)
    local retval, marker_index, pos, name, shown_number, guid2 = ultraschall.EnumerateShownoteMarkers(i)
    if guid2==guid then ultraschall.SuppressErrorMessages(false) return i end
  end
  ultraschall.SuppressErrorMessages(false)
  return -1
end

--B=ultraschall.GetShownoteMarkerIDFromGuid(A)

function ultraschall.IsMarkerShownote(marker_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMarkerShownote</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shownote_idx = ultraschall.IsMarkerShownote(integer markerid)</functioncall>
  <description>
    returns true, if the marker is a shownote-marker, false if not. Returns nil, if markerid is invalid.
    Markerid is the marker-number for all markers, as used by marker-functions from Reaper.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, if it's an shownote-marker, false if not
    integer shownote_idx - the index of the shownote; 1-based
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
  </parameters>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, navigation, check, shownote marker, normal</tags>
</US_DocBloc>
]]
  if math.type(marker_id)~="integer" then ultraschall.AddErrorMessage("IsMarkerShownote", "marker_id", "must be an integer", -1) return false end
  for i=1, ultraschall.CountShownoteMarkers() do
    local retval, marker_index, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(i)
    if marker_index==marker_id then
      return true, i
    end
  end
  return false
end

function ultraschall.RenumerateNormalMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenumerateNormalMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RenumerateNormalMarkers()</functioncall>
  <description>
    renumerates the shown number of normal markers
  </description>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, renumerate, normal markers</tags>
</US_DocBloc>
]]
  for i=1, ultraschall.CountNormalMarkers() do
    local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
    ultraschall.SetNormalMarker(i, position, i, markertitle)
  end
end

function ultraschall.RenumerateShownoteMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenumerateShownoteMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RenumerateShownoteMarkers()</functioncall>
  <description>
    renumerates the shown number of normal markers
  </description>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, renumerate, shownote markers</tags>
</US_DocBloc>
]]
  for i=1, ultraschall.CountShownoteMarkers() do
    local retval, marker_index, pos, name, shownnumber, guid = ultraschall.EnumerateShownoteMarkers(i)
    ultraschall.SetShownoteMarker(i, pos, name, i)
  end
end

function ultraschall.GetMarkerType(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerType</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string markertype = ultraschall.GetMarkerType(integer markerid)</functioncall>
  <description>
    return the type of a marker or region, either "shownote", "edit", "normal" for chapter markers, "planned", "custom_marker:custom_marker_name", "custom_region:custom_region_name" or "region".
    
    returns "no such marker or region", when markerindex is no valid markerindex
    
    returns nil in case of an error
  </description>
  <retvals>
    string markertype - see description for more details
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers/regions in the project, beginning with 0 for the first marker/region
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, markertype</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("GetMarkerType", "markerid", "must be an integer", -1) return end
  
  local MarkerAttributes={reaper.EnumProjectMarkers3(0, markerid)}
  
  if MarkerAttributes[2]==false then
    local Shownote, Shownote_idx=ultraschall.IsMarkerShownote(markerid)
    if Shownote==true then return "shownote", Shownote_idx end  
    
    local editmarkers, editmarkersarray = ultraschall.GetAllEditMarkers()
    for i=1, editmarkers do
      if editmarkersarray[i][2]==markerid+1 then 
        return "edit", i-1 
      end
    end
  
    if MarkerAttributes[7]==ultraschall.planned_marker_color then 
      planned_count=-1
      for i=0, markerid do
        local TempMarkerAttributes={reaper.EnumProjectMarkers3(0, i)}
        if TempMarkerAttributes[7]==ultraschall.planned_marker_color then
          planned_count=planned_count+1
        end
      end
      return "planned", planned_count
    end
    
    if MarkerAttributes[5]:match("_.-:")~=nil then 
      local name=MarkerAttributes[5]:match("_(.-):")
  
      for i=1, ultraschall.CountAllCustomMarkers(name) do
        local retval, marker_index, pos, name2, shown_number, color, guid = ultraschall.EnumerateCustomMarkers(name, i-1)
        if marker_index==markerid then return "custom_marker:"..name, i end
      end
    end
 
    if MarkerAttributes[5]:sub(1,1)=="!" then
      return "actionmarker"
    end 

    if ultraschall.IsMarkerNormal(markerid)==true then 
      for i=1, ultraschall.CountNormalMarkers() do
        local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
        if retnumber-1==markerid then return "normal", i-1 end
      end
    end
  end

  if MarkerAttributes[5]:match("_.-:")~=nil then 
    local name=MarkerAttributes[5]:match("_(.-):")

    for i=1, ultraschall.CountAllCustomRegions(name) do
      local retval, marker_index, pos, name2, shown_number, color, guid = ultraschall.EnumerateCustomRegions(name, i-1)
      if marker_index==markerid then return "custom_region:"..name, marker_index end
    end
  end

  if MarkerAttributes[2]==true then return "region", MarkerAttributes[1]-1 end

  return "no such marker or region"
end

function ultraschall.MarkerMenu_Start()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Start</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.9.7
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_Start()</functioncall>
  <description>
    starts a background-script, that hijacks the marker/region-context-menu when right-clicking them.
    
    You can set the menu-entries in resourcefolder/ultraschall_marker_menu.ini
    
    Important: this has issues with marker-lanes, so you might be able to open the context-menu when right-clicking above/below the marker!
    
    Markertypes, who have no menuentry set yet, will get their default-menu, instead.
    
    Scripts that shall influence the clicked marker, should use 
    
        -- get the last clicked marker
        marker_id, marker_guid=ultraschall.GetTemporaryMarker() 
        
        -- get the menuentry and additonal values from the markermenu
        markermenu_entry, markermenu_entry_additionaldata, 
        markermenu_entry_markertype, markermenu_entry_number = ultraschall.MarkerMenu_GetLastClickedMenuEntry()
        
    in them to retrieve the marker the user clicked on(plus some additional values), as Reaper has no way of finding this 
    out via API.
    It also means, that marker-actions of Reaper might NOT be able to find out, which marker to influence, so writing 
    your own scripts for that is probably unavoidable. Please keep this in mind and test this thoroughly.
    
    Note: to ensure, that the script can not be accidentally stopped by the user, you can run this function in a defer-loop to restart it, if needed.
  </description>
  <retvals>
    boolean retval - true, marker-menu has been started; false, markermenu is already running
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, start, markermenu</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("ultraschall_api", "markermenu_started")=="" then
    ultraschall.Main_OnCommand_NoParameters=nil
    ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/ultraschall_Marker_Menu.lua")
    ultraschall.Main_OnCommand_NoParameters=nil
    return true
  end
  return false
end

function ultraschall.MarkerMenu_Stop()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Stop</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.MarkerMenu_Stop()</functioncall>
  <description>
    stops the marker-menu background-script.
  </description>
  <retvals>
    boolean retval - true, marker-menu has been started; false, markermenu is already running
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, start, markermenu</tags>
</US_DocBloc>
]]
  reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
end

--SLEM()


function ultraschall.MarkerMenu_Debug(messages)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Debug</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_Debug(integer messages)</functioncall>
  <description>
    toggles debug-messages, that shall be output with the marker-menu-backgroundscript
    
    Messages available are
      0 - no messages
      1 - output the markertype of the clicked marker in the ReaScript-Console
      2 - show marker-information as first entry in the marker-menu(type, overall marker-number, guid)
  </description>
  <retvals>
    boolean retval - true, setting debug-messages worked; false, setting debug-messages did not work
  </retvals>
  <parameters>
    integer messages - 0, show no debug messages in marker-menu-background-script
                     - 1, show the markertype of the last clicked-marker/region
                     - 2 - show marker-information as first entry in the marker-menu(type, overall marker-number, guid)
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, show, debugmessage, markermenu</tags>
</US_DocBloc>
]]
  if math.type(messages)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_Debug", "messages", "must be an integer", -1) return false end
  
  if messages&1==1 then
    reaper.SetExtState("ultraschall_api", "markermenu_debug_messages_markertype", "true", false)
  elseif messages&1==0 then
    reaper.DeleteExtState("ultraschall_api", "markermenu_debug_messages_markertype", false)
  end
  
  if messages&2==2 then
    reaper.SetExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", "true", false)
  elseif messages&2==0 then
    reaper.DeleteExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", false)
  end
  
  return true
end



function ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string description, string action_command_id, string additional_data, integer submenu, boolean greyed, optional boolean checked = ultraschall.MarkerMenu_GetEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    gets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain custom marker/region
    
    returns nil in case of an error
  </description>
  <retvals>
    string description - the currently set description for this marker-entry; "", entry is a separator
    string action_command_id - the currently set action-command-id for this marker-entry
    string additional_data - potential additional data, stored with this menu-entry    
    integer submenu - 0, entry is no submenu(but can be within a submenu!); 1, entry is start of a submenu; 2, entry is last entry in a submenu
    boolean greyed - true, entry is greyed(submenu-entries will not be accessible!); false, entry is not greyed and therefore selectable
    optional boolean checked - true, entry has a checkmark; false, entry has no checkmark; nil, entry will show checkmark depending on toggle-state of action_command_id
  </retvals>
  <parameters>
    string marker_name - the name of the custom marker/region, whose menu-entry you want to retrieve
    boolean is_marker_region - true, it's a custom-region; false, it's a custom-marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to retrieve
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "marker_name", "must be a string", -1) return end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "is_marker_region", "must be a boolean", -2) return end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "clicktype", "must be an integer", -3) return end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "entry_nr", "must be an integer", -4) return end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "clicktype", "no such clicktype", -5)
    return
  end
  
  local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", "ultraschall_marker_menu.ini")
  local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", "ultraschall_marker_menu.ini")  
  local additional_data = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", "ultraschall_marker_menu.ini")
  local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", "ultraschall_marker_menu.ini")
  local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", "ultraschall_marker_menu.ini")
  local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", "ultraschall_marker_menu.ini")
  additional_data=string.gsub(additional_data, "\\n", "\n")
  
  if submenu=="start" then submenu=1 elseif submenu=="end" then submenu=2 else submenu=0 end
  greyed=greyed=="yes"
  if checked=="yes" then checked=true elseif checked=="no" then checked=false else checked=nil end
  if tonumber(aid)~=nil then aid=tonumber(aid) end
  
  return description, aid, additional_data, submenu, greyed, checked
end

--A,B=ultraschall.MarkerMenu_GetEntry("HuchTuch", true, 0, 1)
--SLEM()

function ultraschall.MarkerMenu_SetEntry(marker_name, is_marker_region, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    sets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain custom marker/region
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the name of the custom marker/region, whose menu-entry you want to set
    boolean is_marker_region - true, it's a custom-region; false, it's a custom-marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to set
    string action - the new action-command-id for this marker-entry
    string description - the new description for this marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "entry_nr", "must be an integer", -4) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "action", "must be an integer or a string beginning with _", -5) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "description", "must be a string", -6) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -7) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "greyed", "must be a boolean", -8) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "checked", "must be a boolean", -9) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "submenu", "must be an integer", -10) return false end
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "clicktype", "no such clicktype", -11)
    return false
  end
  additional_data=string.gsub(additional_data, "\n", "\\n")
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return retval
end


function ultraschall.MarkerMenu_GetAvailableTypes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetAvailableTypes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>table marker_types = ultraschall.MarkerMenu_GetAvailableTypes()</functioncall>
  <description>
    gets all available markers/regions, that are added to the marker-menu, including their types.
    
    The table is of the following format:
        table[idx]["name"] - the name of the marker
        table[idx]["is_region"] - true, markertype is region; false, markertype is not a region
        table[idx]["markertype"] - either "default" or "custom"
        table[idx]["clicktype"] - the clicktype; 0, right-click
        
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  local entries={}
  local ini_file=ultraschall.ReadFullFile(reaper.GetResourcePath().."/ultraschall_marker_menu.ini")
  for k in string.gmatch(ini_file, "%[.-%]") do
    entries[#entries+1]={}
    if k:match("(%[custom_).*")==nil then
      entries[#entries]["markertype"]="default"
      entries[#entries]["name"], entries[#entries]["clicktype"]=k:match(".(.*)_(.*).")
      if entries[#entries]["name"]=="region" then entries[#entries]["is_region"]=true else entries[#entries]["is_region"]=false end
    else
      entries[#entries]["custom"]="custom"
      entries[#entries]["is_region"]=k:match("%[custom_(.-):.*")=="region"
      entries[#entries]["name"], entries[#entries]["clicktype"]=k:match(".custom_.-:(.*)_(.*).")
    end
  end
  return entries
end

--A=ultraschall.MarkerMenu_GetAvailableTypes()


function ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string description, string action_command_id, string additional_data, integer submenu, boolean greyed, optional boolean checked = ultraschall.MarkerMenu_GetEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    gets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns nil in case of an error
  </description>
  <retvals>
    string description - the new description for this marker-entry; "", entry is a separator
    string action_command_id - the new action-command-id for this marker-entry
    string additional_data - potentially stored additional data with this menuentry
    integer submenu - 0, entry is no submenu(but can be within a submenu!); 1, entry is start of a submenu; 2, entry is last entry in a submenu
    boolean greyed - true, entry is greyed(submenu-entries will not be accessible!); false, entry is not greyed and therefore selectable
    optional boolean checked - true, entry has a checkmark; false, entry has no checkmark; nil, entry will show checkmark depending on toggle-state of action_command_id
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to get
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to get
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end

  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "marker_type", "no such markertype", -4)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "clicktype", "no such clicktype", -5)
    return false
  end

  local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", "ultraschall_marker_menu.ini")
  local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", "ultraschall_marker_menu.ini")  
  local additional_data = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", "ultraschall_marker_menu.ini")
  local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", "ultraschall_marker_menu.ini")
  local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", "ultraschall_marker_menu.ini")
  local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", "ultraschall_marker_menu.ini")
  additional_data=string.gsub(additional_data, "\\n", "\n")
  
  if submenu=="start" then submenu=1 elseif submenu=="end" then submenu=2 else submenu=0 end
  greyed=greyed=="yes"
  if checked=="yes" then checked=true elseif checked=="no" then checked=false else checked=nil end
  if tonumber(aid)~=nil then aid=tonumber(aid) end
  
  return description, aid, additional_data, submenu, greyed, checked
end

--A,B=ultraschall.MarkerMenu_GetEntry_DefaultMarkers(0, 0, 1)

function ultraschall.MarkerMenu_SetEntry_DefaultMarkers(marker_type, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    sets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to set
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to set
    string action - the new action-command-id for this marker-entry
    string description - the new description for this marker-entry; "", entry is a separator
    string additional_data - optional additional data, that will be passed over by the marker-menu, when this menu-entry has been clicked; "", if not needed
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "action", "must be an integer or a string beginning with _", -4) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -5) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -6) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "greyed", "must be a boolean", -7) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "checked", "must be a boolean", -8) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "submenu", "must be an integer", -9) return false end
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "marker_type", "no such markertype", -10)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "clicktype", "no such clicktype", -11)
    return false
  end
  additional_data=string.gsub(additional_data, "\n", "\\n")
  
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 =  ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  return retval
end

function ultraschall.MarkerMenu_RemoveEntry(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a menu-entry in the marker-menu, associated with a certain default custom marker/region
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to remove
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to remove
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "entry_nr", "must be an integer", -4) return false end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "clicktype", "no such clicktype", -5)
    return false
  end
  
  for i=entry_nr, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval  = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", "", "ultraschall_marker_menu.ini")
      break 
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "ultraschall_marker_menu.ini")
    local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "ultraschall_marker_menu.ini")
    local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "ultraschall_marker_menu.ini")
    
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  return true
end

function ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to remove
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "marker_type", "no such markertype", -4)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "clicktype", "no such clicktype", -5)
    return false
  end
  
  for i=entry_nr, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval  = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", "", "ultraschall_marker_menu.ini")
      break 
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "ultraschall_marker_menu.ini")
    local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "ultraschall_marker_menu.ini")
    local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "ultraschall_marker_menu.ini")
    
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  return true
end

function ultraschall.MarkerMenu_GetLastClickedMenuEntry()
   --[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetLastClickedMenuEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string markermenu_entry, string markermenu_entry_additionaldata, string markermenu_entry_markertype, string markermenu_entry_number = ultraschall.MarkerMenu_GetLastClickedMenuEntry()</functioncall>
  <description>
    gets the last clicked entry of the marker-menu
    
    the markermenu_entry_number is according to the entry-number in the ultraschall_marker_menu.ini
    
    the stored data will be deleted after one use!
  </description>
  <retvals>
    string markermenu_entry - the text of the clicked menu-entry
    string markermenu_entry_additionaldata - additional data, that is associated with this menu-entry
    string markermenu_entry_markertype - the type of the marker
    string markermenu_entry_number - the number of the marker-entry
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, menu entry, last clicked</tags>
</US_DocBloc>
]]
  MarkerMenu_Entry=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry")
  MarkerMenu_Entry_MarkerType=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType")
  MarkerMenu_EntryNumber=reaper.GetExtState("ultraschall_api", "MarkerMenu_EntryNumber")
  MarkerMenu_Entry_AdditionalData=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData")
  
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_EntryNumber", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData", "", false)
  return MarkerMenu_Entry, MarkerMenu_Entry_AdditionalData, MarkerMenu_Entry_MarkerType, MarkerMenu_EntryNumber
end



function ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_CountEntries</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer number_of_entries = ultraschall.MarkerMenu_CountEntries(string marker_name, boolean is_marker_region, integer clicktype)</functioncall>
  <description>
    counts the number of menu-entries in the marker-menu, associated with a certain default custom marker/region
    
    ends conting, when an entry is either missing an action-command-id or description or both
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_entries - the number of entries available; -1, in case of an error
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entries you want to count
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, count, entries, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "marker_name", "must be a string", -1) return -1 end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "is_marker_region", "must be a boolean", -2) return -1 end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "clicktype", "must be an integer", -3) return -1 end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "clicktype", "no such clicktype", -4)
    return false
  end
  
  for i=1, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")
    if aid=="" or description=="" then 
      return i-1
    end
  end
  return -1
end

--A=ultraschall.MarkerMenu_CountEntries("CustomRegion", true, 0)

function ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_CountEntries_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer number_of_entries = ultraschall.MarkerMenu_CountEntries_DefaultMarkers(integer marker_type, integer clicktype)</functioncall>
  <description>
    counts the number of menu-entries in the marker-menu, associated with a certain default markers from Ultraschall
    
    ends counting, when an entry is either missing an action-command-id or description or both
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_entries - the number of entries available; -1, in case of an error
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, count, entries, markermenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "marker_type", "no such markertype", -3)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "clicktype", "no such clicktype", -4)
    return false
  end
  
  for i=1, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")
    if aid=="" or description=="" then 
      return i-1
    end
  end
  return -1
end

function ultraschall.MarkerMenu_InsertEntry(marker_name, is_marker_region, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_InsertEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_InsertEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    inserts a menu-entry into the marker-menu, associated with a certain default custom marker/region and moves all others one up
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, inserting was successful; false, inserting was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to insert
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to insert
    string action - the action-command-id for this new marker-entry
    string description - the description for this new marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "entry_nr", "must be an integer", -4) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "action", "must be an integer or a string beginning with _", -5) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "description", "must be a string", -6) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "description", "must be a string", -7) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "greyed", "must be a boolean", -8) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "checked", "must be a boolean", -9) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "submenu", "must be an integer", -10) return false end

  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "clicktype", "no such clicktype", -11)
    return false
  end
  
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  for i=ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype), entry_nr-1, -1 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "", "ultraschall_marker_menu.ini")
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Checked", "ultraschall_marker_menu.ini")
    local checked= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Greyed", "ultraschall_marker_menu.ini")
    local submenu= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_SubMenu", "ultraschall_marker_menu.ini")
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return true
end

--ultraschall.MarkerMenu_Start()
--ultraschall.MarkerMenu_InsertEntry("CustomRegion", true, 0, 1, 1007, "HudelDudel"..os.date(), "More Data"..reaper.time_precise())
--SLEM()


function ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(marker_type, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_InsertEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    inserts a menu-entry into the marker-menu, associated with a certain default marker/region as in Ultraschall and moves all others one up
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, inserting was successful; false, inserting was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to get
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to insert
    string action - the action-command-id for this new marker-entry
    string description - the description for this new marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>entries, markermenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "action", "must be an integer or a string beginning with _", -4) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "description", "must be a string", -5) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "description", "must be a string", -6) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "greyed", "must be a boolean", -7) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "checked", "must be a boolean", -8) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "submenu", "must be an integer", -9) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "marker_type", "no such markertype", -10)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "clicktype", "no such clicktype", -11)
    return false
  end

  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  for i=ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype), entry_nr-1, -1 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "", "ultraschall_marker_menu.ini")
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Checked", "ultraschall_marker_menu.ini")
    local checked= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Greyed", "ultraschall_marker_menu.ini")
    local submenu= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_SubMenu", "ultraschall_marker_menu.ini")
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return true
end

function ultraschall.MarkerMenu_SetStartupAction(marker_name, is_marker_region, clicktype, action)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetStartupAction</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetStartupAction(string marker_name, boolean is_marker_region, integer clicktype, string action)</functioncall>
  <description>
    adds a startup-action into the marker-menu, associated with a certain default custom marker/region
    
    This startup-action will be run before the menu for this specific marker/region will be opened and can be used to populate/update the menuentries first before showing the menu(for filelists, etc)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding startup-action was successful; false, adding startup-action was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to add a startup-action for
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    string action - the action-command-id for this new marker-entry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, startup action, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "clicktype", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "action", "must be an integer or a string beginning with _", -4) return false end

  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "clicktype", "no such clicktype", -5)
    return false
  end
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "StartUpAction", action, "ultraschall_marker_menu.ini")

  return true
end

--ultraschall.MarkerMenu_AddStartupAction("CustomRegion", true, 0, 1008)

--ultraschall.MarkerMenu_Start()
--ultraschall.MarkerMenu_InsertEntry("CustomRegion", true, 0, 1, 1007, "HudelDudel"..os.date(), "More Data"..reaper.time_precise())
--SLEM()


function ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(marker_type, clicktype, action)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetStartupAction_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(integer marker_type, integer clicktype, string action)</functioncall>
  <description>
    adds a startup-action into the marker-menu, associated with a certain default marker/region as in Ultraschall and moves all others one up
    
    This startup-action will be run before the menu for this specific marker/region will be opened and can be used to populate/update the menuentries first before showing the menu(for filelists, etc)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding startup-action was successful; false, adding startup-action was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to add a startup-action for
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    string action - the action-command-id for this startup-action
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>entries, set, startup action, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "action", "must be an integer or a string beginning with _", -3) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "marker_type", "no such markertype", -7)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "clicktype", "no such clicktype", -8)
    return false
  end
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "StartUpAction", action, "ultraschall_marker_menu.ini")
  return true
end





function ultraschall.MarkerMenu_RemoveSubMenu(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveSubMenu</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveSubMenu(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a submenu from the markermenu of a specific custom marker.
    
    Will also remove nested submenus. 
    If the number of starts of submenus and ends of submenus mismatch, this could cause weird behavior. So keep the starts and ends of submenu-entries consistent!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing submenu worked; false, removing of submenus didn't work
  </retvals>
  <parameters>
    string marker_name - the name of the custom-marker/region, whose sub-menu-entry you want to remove
    boolean is_marker_region - true, the custom-marker is a region; false, the custom-marker is not a region
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that is the first entry in the submenu
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, submenu, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "entry_nr", "must be an integer", -4) return false end
  
  local NumEntries=ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype)
  local Entry={ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)}
  if Entry[4]~=1 then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "entry_nr", "is not a start of a submenu", -5) return false end

  local num_submenus=0
  for i=1, NumEntries do
    Entry={ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)}
    if Entry[4]==1 then num_submenus=num_submenus+1 end
    if Entry[4]==2 then num_submenus=num_submenus-1 end
    ultraschall.MarkerMenu_RemoveEntry(marker_name, is_marker_region, clicktype, entry_nr)
    if num_submenus==0 and Entry[4]==2 then return true end
  end
  return true
end

--A1=ultraschall.MarkerMenu_RemoveSubMenu("Time", false, 0, 3)


function ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveSubMenu_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a submenu from the markermenu of a specific default marker/region.
    
    Will also remove nested submenus. 
    If the number of starts of submenus and ends of submenus mismatch, this could cause weird behavior. So keep the starts and ends of submenu-entries consistent!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing submenu worked; false, removing of submenus didn't work
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose sub-menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that is the first entry in the submenu
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, submenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  
  local NumEntries=ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype)
  local Entry={ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)}
  if Entry[4]~=1 then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "entry_nr", "is not a start of a submenu", -4) return false end

  local num_submenus=0
  for i=1, NumEntries do
    Entry={ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)}
    if Entry[4]==1 then num_submenus=num_submenus+1 end
    if Entry[4]==2 then num_submenus=num_submenus-1 end
    ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(marker_type, clicktype, entry_nr)

    if num_submenus==0 and Entry[4]==2 then return true end
  end
  return true
end


function ultraschall.MarkerMenu_GetLastTouchedMarkerRegion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetLastTouchedMarkerRegion</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer last_touched_marker_region = ultraschall.MarkerMenu_GetLastTouchedMarkerRegion()</functioncall>
  <description>
    Returns the last touched marker/region, when the MarkerMenu is running.
    
    returns nil, if no marker has been touched or markermenu is not running
  </description>
  <retvals>
    integer last_touched_marker - the index of the last touched marker/region; 0-based
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, last touched, marker, region, markermenu</tags>
</US_DocBloc>
]]
  return tonumber(reaper.GetExtState("ultraschall_api", "markermenu_last_touched_marker"))
end


function ultraschall.MarkerMenu_GetLastClickState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetLastClickState</slug>
  <requires>
    Ultraschall=4.7
    JS=0.962
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string last_marker_clickstate = ultraschall.MarkerMenu_GetLastClickState()</functioncall>
  <description>
    Returns the last clickstate including modifiers of the markermenu
    
    returns nil, if no clickstate exists or markermenu is not running
  </description>
  <retvals>
    integer last_marker_clickstate - the last clickstate on a marker
                                   - &1, left mouse button
                                   - &2, right mouse button
                                   - &4, Control key
                                   - &8, Shift key
                                   - &16, Alt key
                                   - &32, Windows key
                                   - &64, middle mouse button
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, last clickstate, modifier, region, markermenu</tags>
</US_DocBloc>
]]
  return tonumber(reaper.GetExtState("ultraschall_api", "markermenu_clickstate"))
end

ultraschall.ChapterAttributes={
              "chap_title",
              "chap_position",
              "chap_description",
              "chap_url",
              "chap_url_description",              
              "chap_descriptive_tags",
              "chap_is_advertisement",
              "chap_content_notification_tags",
              "chap_spoiler_alert",
              "chap_next_chapter_numbers",
              "chap_previous_chapter_numbers",
              "chap_image_description",
              "chap_image_license",
              "chap_image_origin",
              "chap_image_url",
              "chap_guid",
              "chap_image_path"
              }

function ultraschall.GetSetChapterMarker_Attributes(is_set, idx, attributename, content, planned)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetChapterMarker_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetChapterMarker_Attributes(boolean is_set, integer idx, string attributename, string content, optional boolean planned)</functioncall>
  <description>
    Will get/set additional attributes of a chapter-marker.
        
    Supported attributes are:
      "chap_title" - the title of this chapter
      "chap_position" - the current position of this chapter in seconds
      "chap_url" - the url for this chapter(check first, if a shownote is not suited better for the task!)
      "chap_url_description" - a description for this url
      "chap_description" - a description of the content of this chapter
      "chap_is_advertisement" - yes, if this chapter is an ad; "", to unset it
      "chap_image_path" - the path to the filename of the chapter-image(Ultraschall will see it as placed in the project-folder!)
      "chap_image_description" - a description for the chapter-image
      "chap_image_license" - the license of the chapter-image
      "chap_image_origin" - the origin of the chapterimage, like an institution or similar 
      "chap_image_url" - the url that links to the chapter-image
      "chap_descriptive_tags" - some tags, that describe the chapter-content, must separated by commas
      "chap_content_notification_tags" - some tags, that warn of specific content; must be separated by commas
      "chap_spoiler_alert" - "yes", if spoiler; "", if no spoiler
      "chap_next_chapter_numbers" - decide, which chapter could be the next after this one; 
                                   - format is: "chap_number:description\nchap_number:description\n"
                                   - chap_number is the number of the chapter in timeline-order
                                   - it's possible to set multiple chapters as the next chapters; chap_number is 0-based
                                   - this can be used for non-linear podcasts, like "choose your own adventure"
      "chap_previous_chapter_numbers" - decide, which chapter could be the previous before this one
                                   - format is: "chap_number:description\nchap_number:description\n"
                                   - chap_number is the number of the chapter in timeline-order
                                   - it's possible to set multiple chapters as the previous chapters; chap_number is 0-based
                                   - this can be used for non-linear podcasts, like "choose your own adventure"
      "chap_guid" - a unique guid for this chapter-marker; read-only
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer idx - the index of the chapter-marker, whose attribute you want to get; 1-based
    string attributename - the attributename you want to get/set
    string content - the new contents to set the attribute with
    optional boolean planned - true, get/set this attribute with planned marker; false or nil, get/set this attribute with normal marker(chapter marker)
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, set, attribute, chapter, url</tags>
</US_DocBloc>
]]
-- TODO: check for chapter-image-content, if it's png or jpg!!
--       is the code still existing in shownote images so I can copy it?
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "is_set", "must be a boolean", -1) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "idx", "must be an integer", -2) return false end  
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "attributename", "must be a string", -3) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "content", "must be a string", -4) return false end  
  local marker_index=idx
  local tags=ultraschall.ChapterAttributes
  local retval
  
  local found=false
  if attributename=="chap_image_path" then 
    found=true
  else
    for i=1, #tags do
      if attributename==tags[i] then
        found=true
        break
      end
    end
  end
  
  if attributename=="chap_guid" then     
    if ultraschall.GetMarkerExtState(idx, attributename)==nil then
      ultraschall.SetMarkerExtState(idx, attributename, reaper.genGuid(""))
    end
    return true, ultraschall.GetMarkerExtState(idx, attributename)
  end
  
  if attributename=="chap_url" then attributename="url" end
  
  if found==false then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "attributename", "attributename "..attributename.." not supported", -7) return false end
  if planned~=true then
    idx=ultraschall.EnumerateNormalMarkers(idx)
  else
    retval, idx=ultraschall.EnumerateCustomMarkers("Planned", idx-1)
    if idx==nil then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "idx", "no such planned chapter-marker", -9) return false end
    idx=idx+1
  end
    
  if idx<1 then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "idx", "no such chapter-marker", -8) return false end
  local content2=content
  if is_set==false then    
    local B=ultraschall.GetMarkerExtState(idx, attributename)
    if B==nil then B="" end
    if attributename=="chap_title" then    
      local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(marker_index)
      B=markertitle
    elseif attributename=="chap_position" then
      local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(marker_index)
      B=tostring(position)
    end
    return true, B
  elseif is_set==true then
    if attributename=="chap_title" then
      local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(marker_index)
      local retval = ultraschall.SetNormalMarker(marker_index, position, shown_number, content)
      return true, content
    elseif attributename=="chap_position" then
      local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(marker_index)
      local newposition=tonumber(content)
      if newposition==nil then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "content", "chap_position must be a valid number, converted to string", -10) return false end
      local retval = ultraschall.SetNormalMarker(marker_index, newposition, shown_number, markertitle)
      return true, content
    else
      --content2=content
    end
    --print2(content:sub(1,1000))
    return ultraschall.SetMarkerExtState(idx, attributename, content)~=-1, content
  end
end


ultraschall.PodcastAttributes={
              "podc_title", 
              "podc_description", 
              "podc_category",
              "podc_contact_email",
              "podc_descriptive_tags",
              "podc_feed",
              "podc_tagline"
              }
         --[[     
         "podc_twitter" - twitter-profile of the podcast
         "podc_facebook" - facebook-page of the podcast
         "podc_youtube" - youtube-channel of the podcast
         "podc_instagram" - instagram-channel of the podcast
         "podc_tiktok" - tiktok-channel of the podcast
         "podc_mastodon" - mastodon-channel of the podcast
         "podc_twitch" - the twitch-channel of the podcast
         "podc_pinterest" - the pinterest-profile of the podcast
         "podc_reddit" - the reddit-profile of the podcast
         "podc_slack" - the slack-workspace of the podcast
         "podc_discord" - the discord-server of the podcast
         --]]

function ultraschall.GetSetPodcast_Attributes(is_set, attributename, content, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcast_Attributes</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetPodcast_Attributes(boolean is_set, string attributename, string content, optional integer preset_slot)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will get/set metadata-attributes for a podcast.
    
    This is about the podcast globally, NOT the individual episodes.
    
         "podc_title" - the title of the podcast
         "podc_tagline" - a tagline for this episode
         "podc_description" - a description for your podcast
         "podc_contact_email" - an email-address that can be used to contact the podcasters                  
         "podc_feed" - the url of the podcast-feed
         "podc_descriptive_tags" - some tags, who describe the podcast, must be separated by commas
         "podc_category" - a category that describes the podcast
    
    For episode's-metadata, use [GetSetPodcastEpisode\_Attributes](#GetSetPodcastEpisode_Attributes)
    
    preset-values will be stored into resourcepath/ultraschall\_podcast\_presets.ini
    
    You can either set the current project's attributes(preset\_slot=nil) or a preset(preset\_slot=1 and higher)
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
    string additional_attribute - some attributes allow additional attributes to be set; in all other cases set to ""
                                - when attribute="podcast_website", set this to a number, 1 and higher, which will index possibly multiple websites you have for your podcast
                                - use 1 for the main-website
    string content - the new contents to set the attribute
    optional integer preset_slot - the slot in the podcast-presets to get/set the value from/to; nil, no preset used
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute; when preset_slot is not nil then this is the content of the presetslot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, podcast, attributes</tags>
</US_DocBloc>
]]
  -- check for errors in parameter-values
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "is_set", "must be a boolean", -1) return false end  
  if preset~=nil and math.type(preset)~="integer" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "preset", "must be either nil or an integer", -2) return false end    
  if preset~=nil and preset<=0 then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "preset", "must be higher than 0", -3) return false end 
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "attributename", "must be a string", -4) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "content", "must be a string", -5) return false end  
  --if type(additional_attribute)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "must be a string", -6) return false end
  
  -- check, if passed attributes are supported
  local tags=ultraschall.PodcastAttributes
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local retval
  
  -- management additional additional attributes for some attributes
  if attributename=="podcast_feed" then
    if additional_attribute:lower()~="mp3" and
       additional_attribute:lower()~="aac" and
       additional_attribute:lower()~="opus" and
       additional_attribute:lower()~="ogg" and
       additional_attribute:lower()~="flac"
      then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_feed\" needs content_attibute being set to the audioformat(mp3, ogg, opus, aac, flac)", -10) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_website" then
    --print(attributename.." "..tostring(math.tointeger(additional_attribute)).." "..additional_attribute)
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_website\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -11) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_donate" then
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_donate\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -12) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  else
    additional_attribute=""
  end
  
  if found==false then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "attributename", "attributename "..attributename.." not supported", -7) return false end
  local presetcontent, _
  
  if is_set==true then
    -- set state
    if preset_slot~=nil then
      content=string.gsub(content, "\r", "")
      retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, attributename..additional_attribute, string.gsub(content, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
      return presetcontent~="", presetcontent
    else
      presetcontent=nil      
    end
    local _ = reaper.SetProjExtState(0, "PodcastMetaData", attributename, content)
  else
    -- get state
    if preset_slot~=nil then
      local old_errorcounter = ultraschall.CountErrorMessages()
      presetcontent=ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, attributename, "ultraschall_podcast_presets.ini")
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      presetcontent=string.gsub(presetcontent, "\\n", "\n")
      return presetcontent~="", presetcontent
    end
    _, content=reaper.GetProjExtState(0, "PodcastMetaData", attributename)
  end
  return true, content, presetcontent
end

ultraschall.EpisodeAttributes={
              "epsd_title", 
              "epsd_number",
              "epsd_season", 
              "epsd_release_date",
              "epsd_release_time",
              "epsd_release_timezone",              
              "epsd_description",
              "epsd_cover",
              "epsd_language", 
              "epsd_explicit",
              "epsd_descriptive_tags",
              "epsd_content_notification_tags",
              "epsd_url",
              "epsd_guid"
              }

function ultraschall.GetSetPodcastEpisode_Attributes(is_set, attributename, content, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcastEpisode_Attributes</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetPodcastEpisode_Attributes(boolean is_set, string attributename, string content, optional integer preset_slot)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Will get/set metadata-attributes for a podcast-episode.
    
    This is about the individual podcast-episode, NOT the global podcast itself..
    
    For podcast's-metadata, use [GetSetPodcast\_Attributes](#GetSetPodcast_Attributes)
    
    Supported attributes are:
        "epsd_title" - the title of the episode
        "epsd_number" - the number of the episode
        "epsd_season" - the season of the episode
        "epsd_release_date" - releasedate of the episode; yyyy-mm-dd
        "epsd_release_time" - releasedate of the episode; hh:mm:ss
        "epsd_release_timezone" - the time's timezone in UTC of the release-time; +hh:mm or -hh:mm
        "epsd_description" - the descriptionof the episode
        "epsd_cover" - the cover-image of the episode(path+filename)
        "epsd_language" - the language of the episode; Languagecode according to ISO639-2/T
        "epsd_explicit" - yes, if explicit; "", if not explicit
        "epsd_descriptive_tags" - some tags, that describe the content of the episode, must separated by commas
        "epsd_content_notification_tags" - some tags, that warn of specific content; must be separated by commas
        "epsd_guid" - a unique identifier for this episode; contains three guids in a row; read-only; can't be stored in presets!
    
    preset-values will be stored into resourcepath/ultraschall\_podcast\_presets.ini
    
    You can either set the current project's attributes(preset\_slot=nil) or a preset(preset\_slot=1 and higher)
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
    string content - the new contents to set the attribute
    optional integer preset_slot - the slot in the podcast-presets to get/set the value from/to; nil, no preset used
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute; when preset_slot is not nil then this is the content of the presetslot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, podcast, episode, attributes</tags>
</US_DocBloc>
]]
  -- check for errors in parameter-values
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "is_set", "must be a boolean", -1) return false end  
  if preset~=nil and math.type(preset)~="integer" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "preset", "must be either nil or an integer", -2) return false end    
  if preset~=nil and preset<=0 then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "preset", "must be higher than 0", -3) return false end 
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "attributename", "must be a string", -4) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "content", "must be a string", -5) return false end  
  local additional_attribute=""
  
  -- check, if passed attributes are supported
  local tags=ultraschall.EpisodeAttributes
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local retval
  
  if found==false then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "attributename", "attributename "..attributename.." not supported", -7) return false end
  local presetcontent, _
  
  if attributename=="epsd_guid" then
    local _, content=reaper.GetProjExtState(0, "EpisodeMetaData", attributename)
    if content=="" then
      reaper.SetProjExtState(0, "EpisodeMetaData", attributename, reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")..reaper.genGuid("")) 
    end
    local _, content=reaper.GetProjExtState(0, "EpisodeMetaData", attributename)
    return true, content
  end
  
  if is_set==true then
    -- set state
    if preset_slot~=nil then
      content=string.gsub(content, "\r", "")
      retval = ultraschall.SetUSExternalState("EpisodeMetaData_"..preset_slot, attributename..additional_attribute, string.gsub(content, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
      return presetcontent~="", presetcontent
    else
      presetcontent=nil      
    end
    reaper.SetProjExtState(0, "EpisodeMetaData", attributename, content)
  else
    -- get state
    if preset_slot~=nil then
      local old_errorcounter = ultraschall.CountErrorMessages()
      presetcontent=ultraschall.GetUSExternalState("EpisodeMetaData_"..preset_slot, attributename, "ultraschall_podcast_presets.ini")
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      presetcontent=string.gsub(presetcontent, "\\n", "\n")
      return presetcontent~="", presetcontent
    end
    _, content=reaper.GetProjExtState(0, "EpisodeMetaData", attributename)
  end
  return true, content, presetcontent
end


ultraschall.ShowNoteAttributes={
              "shwn_title", -- shownote-markertitle
              "shwn_position", -- position of the shownote in seconds
              "shwn_language",           -- check for validity ISO639
              "shwn_description",
              "shwn_location",       -- check for validity
              "shwn_location_name",       -- check for validity
              "shwn_date",       -- check for validity
              "shwn_time",       -- check for validity
              "shwn_timezone",   -- check for validity
              "shwn_event_date_beginning",   -- check for validity
              "shwn_event_date_end",     -- check for validity
              "shwn_event_time_beginning",   -- check for validity
              "shwn_event_time_end",     -- check for validity
              "shwn_event_timezone",     -- check for validity
              "shwn_event_name",
              "shwn_event_description",
              "shwn_event_url", 
              "shwn_event_location",       -- check for validity              
              "shwn_event_location_name",       -- check for validity              
              "shwn_event_ics_data",
              "shwn_bibliographical_source", 
              --"image_uri",
              --"image_content",      -- check for validity
              --"image_description",
              --"image_source",
              --"image_license",
              "shwn_url", 
              "shwn_url_description",
              "shwn_url_retrieval_date",
              "shwn_url_retrieval_time",
              "shwn_url_retrieval_timezone_utc",
              "shwn_url_archived_copy_of_original_url",
              "shwn_wikidata_uri",
              "shwn_descriptive_tags",
              "shwn_is_advertisement",
              "shwn_guid",
              "shwn_linked_audiovideomedia"
              }

function ultraschall.GetSetShownoteMarker_Attributes(is_set, idx, attributename, content, additional_content)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetShownoteMarker_Attributes</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetShownoteMarker_Attributes(boolean is_set, integer idx, string attributename, string content, optional string additional_content)</functioncall>
  <description>
    Will get/set additional attributes of a shownote-marker.
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this marker
        
        
    Supported attributes are:
           "shwn_title" - the title of the shownote
           "shwn_position" - the position of the shownote
           "shwn_description" - a more detailed description for this shownote
           "shwn_descriptive_tags" - some tags, that describe the content of the shownote, must separated by commas
           "shwn_url" - the url you want to set
           "shwn_url_description" - a short description of the url
           "shwn_url_retrieval_date" - the date, at which you retrieved the url; yyyy-mm-dd
           "shwn_url_retrieval_time" - the time, at which you retrieved the url; hh:mm:ss
           "shwn_url_retrieval_timezone_utc" - the timezone of the retrieval time as utc; +hh:mm or -hh:mm
           "shwn_url_archived_copy_of_original_url" - if you have an archived copy of the url(from archive.org, etc), you can place the link here
           "shwn_is_advertisement" - yes, if the shownote is an ad; "", to unset it
           "shwn_language" - the language of the content; Languagecode according to ISO639
           "shwn_location" - the coordinates of the location of this shownote; must be in decimal degrees "XX.xxxxxx,YY.yyyyyy" 
           "shwn_location_name" - the name of the location of this shownote
           "shwn_date" - the date of the content of the shownote(when talking about events, etc); yyyy...yyy-mm-dd; 
                       - use XX or XXXX, for when day/month/year is unknown or irrelevant; 
                       - add minus - in front of the yyyy for years BC; like -0999
                       - years can be more than 4 digits, so -10021 (for -10021BC) is valid
           "shwn_time" - the time of the content of the shownote(when talking about events, etc); hh:mm:ss; use XX for when hour/minute/second is unknown or irrelevant
           "shwn_timezone" - the timezone of the content of the shownote(when talking about events, etc); UTC-format; +hh:mm or -hh:mm
           "shwn_event_date_beginning" - the startdate of an event associated with the show; yyyy-mm-dd
           "shwn_event_date_end" - the enddate of an event associated with the show; yyyy-mm-dd
           "shwn_event_time_beginning" - the starttime of an event associated with the show; hh:mm:ss
           "shwn_event_time_end" - the endtime of an event associated with the show; hh:mm:ss
           "shwn_event_timezone" - the timezone of the event assocated with the show; UTC-format; +hh:mm or -hh:mm
           "shwn_event_name" - a name for the event
           "shwn_event_description" - a description for the event
           "shwn_event_url" - an url of the event(for ticket sale or the general url for the event)
           "shwn_event_location" - the coordinates of the location of the event; must be in decimal degrees "XX.xxxxxx,YY.yyyyyy" 
           "shwn_event_location_name" - the name of the location of the event
           "shwn_event_ics_data" - the event as ics-data-format; will NOT set other event-attributes; will not be checked for validity!
           "shwn_bibliographical_source" - a specific place you want to cite, like bookname + page + paragraph + line or something via webcite
           "shwn_wikidata_uri" - the uri to an entry to wikidata
           "shwn_guid" - a unique identifier for this shownote; read-only
           "shwn_linked_audiovideomedia" - a link to a mediafile like a podcast-episode
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer idx - the index of the shownote-marker, whose attribute you want to get; 1-based
    string attributename - the attributename you want to get/set
    string content - the new contents to set the attribute with
    optional string additional_content - additional content, needed by some attributes; see list of attributes for more details
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
    optional string additional_content - additional content, needed by some attributes; see list of attributes for more details
  </retvals>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, set, attribute, shownote, citation</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "is_set", "must be a boolean", -1) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "idx", "must be an integer", -2) return false end    
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "attributename", "must be a string", -3) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "must be a string", -4) return false end  
  if is_set==true and additional_content~=nil and type(additional_content)~="string" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "additional_content", "must be a string", -8) return false end  
  -- WARNING!! CHANGES HERE MUST REFLECT CHANGES IN THE CODE OF CommitShownote_ReaperMetadata() !!!
  local tags=ultraschall.ShowNoteAttributes
  local marker_index=idx
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then      
      found=true
      break
    end
  end
  
  if found==false then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "attributename", "attributename "..tostring(attributename).." not supported", -7) return false end
  
  local A,B,Retval
  A={ultraschall.EnumerateShownoteMarkers(idx)}
  if A[1]==false then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "idx", "no such shownote-marker", -5) return false end
  
  -- add a guid
  if attributename=="shwn_guid" then
    if ultraschall.GetMarkerExtState(A[2]+1, attributename)==nil then
      ultraschall.SetMarkerExtState(A[2]+1, attributename, reaper.genGuid(""))
    end
    return true, ultraschall.GetMarkerExtState(A[2]+1, attributename)
  end
  
  if is_set==true then
    local content2=content
    if attributename=="shwn_title" then
      local retval, marker_index2, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(marker_index)
      ultraschall.SetShownoteMarker(marker_index, pos, content, shown_number)
      return true, content
    elseif attributename=="shwn_position" then
      local retval, marker_index2, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(marker_index)
      if tonumber(content)==nil then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "shwn_position must be a number, converted to string", -10) return false end
      ultraschall.SetShownoteMarker(marker_index, tonumber(content), name, shown_number)
      return true, content
    elseif attributename=="shwn_linked_audiovideomedia" then
      --if tonumber(additional_content)==nil then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "additional_content", "the content for shwn_linked_media must be a number as a string", -9) return false end
      Retval = ultraschall.SetMarkerExtState(A[2]+1, attributename, content2)
      
    end
    if attributename=="shwn_event_ics_data" then 
      content2=ultraschall.Base64_Encoder(content)     
    end
    Retval = ultraschall.SetMarkerExtState(A[2]+1, attributename, content2)
    if Retval==-1 then Retval=false else Retval=true end
    B=content
  else
    if attributename=="shwn_title" then
      local retval, marker_index2, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(marker_index)
      B=name
      Retval=true
    elseif attributename=="shwn_position" then
      local retval, marker_index2, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(marker_index)
      B=tostring(pos)
      Retval=true
    elseif attributename=="shwn_linked_audiovideomedia" then 
      B=ultraschall.GetMarkerExtState(A[2]+1, attributename, content)
      if B==nil then Retval=false B="" else Retval=true C=ultraschall.GetMarkerExtState(A[2]+1, attributename.."_time", content) end
    else
      B=ultraschall.GetMarkerExtState(A[2]+1, attributename, content)
      if attributename=="shwn_event_ics_data" then if B==nil then B="" end B=ultraschall.Base64_Decoder(B) end
      if B==nil then Retval=false B="" else Retval=true end
    end
  end
  return Retval, B, C
end


function ultraschall.GetPodcastAttributesAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string podcastmetadata_json = ultraschall.GetPodcastAttributesAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for podcast as JSON according to PodMeta_v1-standard..
  </description>
  <retvals>
    string podcastmetadata_json - the podcast-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  local JSON="\"podc\":{\n"
  local found=false
  for i=1, #ultraschall.PodcastAttributes do
    local retval, content = ultraschall.GetSetPodcast_Attributes(false, ultraschall.PodcastAttributes[i], "")
    if retval==true and content~="" then
      found=true
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      JSON=JSON.."\t\t\""..ultraschall.PodcastAttributes[i].."\":\""..content.."\",\n"
    end
  end
  --]]  
  local websites=string.gsub(ultraschall.PodcastMetaData_ExportWebsiteAsJSON(), "\n", "\n\t")
  if websites~="" then 
    JSON=JSON.."\t"..string.gsub(ultraschall.PodcastMetaData_ExportWebsiteAsJSON(), "\n", "\n\t").."\n\t}"
    found=true
  else
    JSON=JSON:sub(1,-3).."\n\t}"
  end
  if found==false then 
    return "\"podc\":{}"
  else
    return JSON
  end
end
--print3(ultraschall.PodcastMetadata_GetPodcastAttributesAsJSON())
--if lol==nil then return end

function ultraschall.PodcastMetaData_ExportWebsiteAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PodcastMetaData_ExportWebsiteAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string website_entry_JSON = ultraschall.PodcastMetaData_ExportWebsiteAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for a website as JSON according to PodMeta_v1-standard.
  </description>
  <retvals>
    string website_entry_JSON - the podcast's website-metadata as json according to the PodMeta_v1-standard
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, shownote, website, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  local _,maxindex=reaper.GetProjExtState(0, "PodcastMetaData", "podc_maxindex")
  if maxindex=="" then maxindex=0 end
  local count=0
  local JSON=""
  for index=0, tonumber(maxindex) do
    local _,A=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_name")
    local _,B=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_description")
    local _,C=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_url")
    if A~="" and B~="" and C~="" then
      A=string.gsub(A, "\"", "\\\"")
      A=string.gsub(A, "\\n", "\\\\n")
      A=string.gsub(A, "\n", "\\n")
      B=string.gsub(B, "\"", "\\\"")
      B=string.gsub(B, "\\n", "\\\\n")
      B=string.gsub(B, "\n", "\\n")
      C=string.gsub(C, "\"", "\\\"")
      C=string.gsub(C, "\\n", "\\\\n")
      C=string.gsub(C, "\n", "\\n")
      count=count+1
      JSON=JSON.."\t\"podc_website_"..count.."\":{"
      JSON=JSON.."\n\t\t\"podc_website_name\":\""..A.."\","
      JSON=JSON.."\n\t\t\"podc_website_description\":\""..B.."\","
      JSON=JSON.."\n\t\t\"podc_website_url\":\""..C.."\""
      JSON=JSON.."\n\t},\n"
    end
  end
  if count>0 then JSON=JSON:sub(1,-3) end
  
  JSON=JSON..""
  return JSON
end

function ultraschall.GetEpisodeAttributesAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEpisodeAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string episodemetadata_json = ultraschall.GetEpisodeAttributesAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for the podcast's episode as JSON according to PodMeta_v1-standard..
  </description>
  <retvals>
    string episodemetadata_json - the podcast's episode-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, episode, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  local JSON="\"epsd\":{\n"
  for i=1, #ultraschall.EpisodeAttributes do
    local retval, content = ultraschall.GetSetPodcastEpisode_Attributes(false, ultraschall.EpisodeAttributes[i], "")
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if ultraschall.EpisodeAttributes[i]=="epsd_cover" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
        if content==nil then content="" end
      end
      JSON=JSON.."\t\t\""..ultraschall.EpisodeAttributes[i].."\":\""..content.."\",\n"
    end
  end
  JSON=JSON:sub(1,-3).."\n\t}"
  return JSON
end

--print3(ultraschall.PodcastMetadata_GetEpisodeAttributesAsJSON())
--if lol==nil then return end
function ultraschall.GetChapterAttributesAsJSON(chaptermarker_id, shown_id, within_start, within_end, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetChapterAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string chaptermetadata_json = ultraschall.GetChapterAttributesAsJSON(integer chaptermarker_id, integer shown_id, number within_start, number within_end, optional number offset)</functioncall>
  <description>
    Returns the MetaDataEntry for a chapter as JSON according to PodMeta_v1-standard..
    
    You can choose a range within which the marker must be for chapters only within a certain region, etc. 
    If it is outside of it, this function returns "".
    
    You can set an offset to subtract. This could be important, if you want to render a region and want the 
    chapter be the right position from the starting point of the region.
    
    Returns nil in case of an error
  </description>
  <parameters>
    integer chaptermarker_id - the index of the chapter-marker, whose metadata-entry you want to get as JSON; 1-based
    integer shown_id - the number to give to this chapter within the JSON
    number within_start - the starttime of the range to export valid chapters
    number within_end - the starttime of the range to export valid chapters
    optional number offset - subtracts time from the position of the chapter
  </parameters>
  <retvals>
    string chaptermetadata_json - the chapter-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, chapter, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  if math.type(chaptermarker_id)~="integer" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "chaptermarker_id", "must be an integer", -1) return end
  if chaptermarker_id<1 or chaptermarker_id>ultraschall.CountNormalMarkers() then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "chaptermarker_id", "no such chapter-marker", -2) return end
  if math.type(shown_id)~="integer" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "shown_id", "must be an integer", -3) return end
  if type(within_start)~="number" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "within_start", "must be a number", -4) return end
  if type(within_end)~="number" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "within_end", "must be a number", -5) return end
  if offset~=nil and type(offset)~="number" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "offset", "must be a number", -6) return end
  
  local JSON="\"chap_"..shown_id.."\":{\n"
  local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(chaptermarker_id)
  if within_start==nil then within_start=0 end
  if within_end==nil then within_end=reaper.GetProjectLength() end
  if within_start>position or within_end<position then return "" end
  if offset~=nil then position=position-offset end
  local retval, content = ultraschall.GetSetChapterMarker_Attributes(true, chaptermarker_id, "chap_guid", "")
  
  for i=1, #ultraschall.ChapterAttributes do
    local attribute=ultraschall.ChapterAttributes[i]     
    local retval, content = ultraschall.GetSetChapterMarker_Attributes(false, chaptermarker_id, attribute, "")
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if attribute=="chap_image" then
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..ultraschall.Base64_Encoder(content).."\",\n"
      elseif attribute=="chap_position" then 
        local timestr=reaper.format_timestr_len(content, "", 0, 5)
        local timestr2=reaper.format_timestr_len(content, "", 0, 3)
        local timestr3=timestr:match("(.*):").."."..timestr2:match(".*%.(.*)")
        --local timestr=timestr:match("(.*):").."."..timestr:match(".*:(.*)")
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(timestr3).."\",\n"
      elseif attribute=="chap_image_path" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        content=ultraschall.ReadFullFile(path.."/"..content, true)
        if content==nil then content="" end
        content=ultraschall.Base64_Encoder(content)
        attribute="chap_image"
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      else
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      end
      
    end
  end  
  JSON=JSON:sub(1,-3).."\n}"
  return JSON
end

--print3(ultraschall.PodcastMetadata_GetChapterAttributesAsJSON(1))
--SLEM()
--if lol==nil then return end

function ultraschall.GetShownoteAttributesAsJSON(shownotemarker_id, shown_id, within_start, within_end, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetShownoteAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string shownotemetadata_json = ultraschall.GetShownoteAttributesAsJSON(integer shownotemarker_id, integer shown_id, number within_start, number within_end, optional number offset)</functioncall>
  <description>
    Returns the MetaDataEntry for a shownote as JSON according to PodMeta_v1-standard.
    
    Returns nil in case of an error
  </description>
  <parameters>
    integer chaptermarker_id - the index of the shownote-marker, whose metadata-entry you want to get as JSON; 1-based
    integer shown_id - the number to give to this shownote within the JSON
    number within_start - the starttime of the range to export valid shownotes
    number within_end - the starttime of the range to export valid shownotes
    optional number offset - subtracts time from the position of the shownotes
  </parameters>
  <retvals>
    string shownotemetadata_json - the shownote-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, shownote, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  if math.type(shownotemarker_id)~="integer" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "shownotemarker_id", "must be an integer", -1) return end
  if shownotemarker_id<1 or shownotemarker_id>ultraschall.CountShownoteMarkers() then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "marker_id", "no such shownote-marker", -2) return end
  if math.type(shown_id)~="integer" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "shown_id", "must be an integer", -3) return end
  if type(within_start)~="number" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "within_start", "must be a number", -4) return end
  if type(within_end)~="number" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "within_end", "must be a number", -5) return end
  if offset~=nil and type(offset)~="number" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "offset", "must be a number", -6) return end
    
  local JSON="\"shwn_"..shown_id.."\":{\n"
  
  local retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownotemarker_id, "shwn_guid", "")
  local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateShownoteMarkers(shownotemarker_id)
  if within_start==nil then within_start=0 end
  if within_end==nil then within_end=reaper.GetProjectLength() end
  if within_start>position or within_end<position then return "" end
  if offset~=nil then position=position-offset end
  
  for i=1, #ultraschall.ShowNoteAttributes do
    local attribute=ultraschall.ShowNoteAttributes[i]
    local retval, content = ultraschall.GetSetShownoteMarker_Attributes(false, shownotemarker_id, attribute, "")

    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if attribute=="chap_image" then
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..ultraschall.Base64_Encoder(content).."\",\n"
      elseif attribute=="shwn_position" then
        local timestr=reaper.format_timestr_len(content, "", 0, 5)
        local timestr2=reaper.format_timestr_len(content, "", 0, 3)
        local timestr3=timestr:match("(.*):").."."..timestr2:match(".*%.(.*)")
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(timestr3).."\",\n"        
      elseif attribute=="chap_image_path" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        --content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
        attribute="chap_image"
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      else
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      end
      
    end
  end  
  JSON=JSON:sub(1,-3).."\t\n}\n"
  return JSON
end


function ultraschall.PodcastMetadata_CreateJSON_Entry(start_time, end_time, offset, filename, do_id3, do_vorbis, do_ape, do_ixml)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PodcastMetadata_CreateJSON_Entry</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string podmeta_entry_JSON = ultraschall.PodcastMetadata_CreateJSON_Entry(number start_time, number end_time, optional number offset, optional string filename, optional boolean do_id3, optional boolean do_vorbis, optional boolean do_ape, optional boolean do_ixml)</functioncall>
  <description>
    Returns the MetaDataEntry for the entire podcast as JSON according to PodMeta_v1-standard.
    
    Includes all chapters and shownotes as well as episode and podcast attributes
    
    Returns nil in case of an error
  </description>
  <parameters>
    number start_time - the starttime from which to add chapters/shownotes into the JSON
    number end_time - the endtime to which to add chapters/shownotes into the JSON
    optional number offset - the offset to subtract from the position-attributes of the shownotes/chapters
    optional string filename - path+filename to where the JSON shall be output to
    optional boolean do_id3 - true, add to the ID3-metadata storage of Reaper for the current project; false or nil, don't add(default)
    optional boolean do_vorbis - true, add to the VORBIS-metadata storage of Reaper for the current project;  false or nil, don't add(default)
    optional boolean do_ape - true, add to the APE-metadata storage of Reaper for the current project;  false or nil, don't add(default)
    optional boolean do_ixml - true, add to the IXML-metadata storage of Reaper for the current project;  false or nil, don't add(default)
  </parameters>
  <retvals>
    string podmeta_entry_JSON - the podcast's entire-metadata as json according to the PodMeta_v1-standard
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, shownote, chapter, episode, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  if type(start_time)~="number" then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "start_time", "must be a number", -1) return end
  if start_time<0 then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "start_time", "must be bigger than 0", -2) return end
  if type(end_time)~="number" then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "end_time", "must be a number", -3) return end
  if start_time>end_time then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "end_time", "must be bigger than 0", -4) return end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "offset", "must be a number", -5) return end
  if offset<0 then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "offset", "must be bigger than 0", -6) return end
  
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "filename", "must be nil or a string", -7) return end

  local JSON="{\n\t\"PodMeta\":\"version 1.0\","
  JSON=JSON.."\n\t\"PodMetaContent\":{\n"
  local NumChapter=ultraschall.CountNormalMarkers()
  local NumShownotes=ultraschall.CountShownoteMarkers()
  local chapter, shownote
  
  -- Podcast
  JSON=JSON.."\t\t"..string.gsub(ultraschall.GetPodcastAttributesAsJSON(), "\n", "\n\t")..",\n"
   
  -- Episode
  JSON=JSON.."\t\t"..string.gsub(ultraschall.GetEpisodeAttributesAsJSON(), "\n", "\n\t")
  
  -- Contributors
  if ultraschall.CountContributors()>0 then JSON=JSON..",\n" else end
  local A=ultraschall.GetPodcastContributorAttributesAsJSON()
  if A~="" then JSON=JSON.."\t\t"..string.gsub(A, "\n", "\n\t\t") end
  
  -- Chapters
  if NumChapter>0 then 
    JSON=JSON..",\n" 
    chapter_num=1
    for i=1, NumChapter do
      chapter=ultraschall.GetChapterAttributesAsJSON(i, chapter_num, start_time, end_time, offset)
      if chapter~="" then chapter_num=chapter_num+1 end
      if chapter~="" then 
        JSON=JSON:sub(1,-3)..",\n"
        JSON=JSON.."\t\t"..string.gsub(chapter, "\n", "\n\t\t")..",\n"
      else
        print2(chapter)
      end
    end
    JSON=JSON:sub(1,-3)
  else 
    --JSON=JSON.."\nHUH?"
  end

  -- Shownotes
  if NumShownotes>0 then 
    JSON=JSON..",\n" 
    shownote_num=1
    for i=1, NumShownotes do
      shownote=ultraschall.GetShownoteAttributesAsJSON(i, shownote_num, start_time, end_time, offset)
      if shownote~="" then 
        shownote_num=shownote_num+1
        JSON=JSON.."\t\t"..string.gsub(shownote:sub(1,-2), "\n", "\n\t\t")..",\n"
      end
    end
    JSON=JSON:sub(1,-3)
    --]]
  else 
    JSON=JSON.."\n" 
  end
  --]]
  JSON=JSON:sub(1,-1).."\n\t}\n}"
  
  if do_id3==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TXXX:PodMeta|"..JSON, true)
  end
  
  if do_vorbis==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "VORBIS:USER:PodMeta|"..JSON, true)
  end
  
  if do_ape==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "APE:User Defined:PodMeta|"..JSON, true)
  end
  
  if do_ixml==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "IXML:USER:PodMeta|"..JSON, true)
  end
  
  if filename~=nil then 
    local errorindex = ultraschall.GetErrorMessage_Funcname("WriteValueToFile", 1)
    retval=ultraschall.WriteValueToFile(filename, JSON)
  
    if retval==-1 then 
      local errorindex2, parmname, errormessage = ultraschall.GetErrorMessage_Funcname("WriteValueToFile", 1)
      ultraschall.AddErrorMessage("PodcastMetadata_CreateJSON_Entry", "filename", errormessage, -8) 
      return 
    end
  end
    
  
  local function TestJson()
    --print3(JSON)
    -- test for validity(testsystem only)
    if reaper.file_exists(reaper.GetResourcePath().."/jq-win64.exe")==true then
      ultraschall.WriteValueToFile(reaper.GetResourcePath().."/JSON-test.txt", JSON.."")
      os.execute(reaper.GetResourcePath().."/JSON-test.Bat")
    end
    gfx.quit()
  end
  
  ---WriteMessage("Podcast")
  --reaper.defer(CreatePodcastEntry)
  
  TestJson()
  return JSON
end


function ultraschall.GetSetPodcastWebsite(is_set, index, name, description, url, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcastWebsite</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string name, string description, string url = ultraschall.GetSetPodcastWebsite(boolean is_set, integer index, string name, string description, string url, optional index preset_slot)</functioncall>
  <description>
    Will get/set website-metadata-attributes for a podcast.
    
    This is about the podcast globally, NOT the individual episodes.
    
    preset-values will be stored into resourcepath/ultraschall\_podcast\_presets.ini
        
    You can either set the current project's attributes(preset\_slot=nil) or a preset(preset\_slot=1 and higher)
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer index - the index of the url to store, 1 and higher
    string name - the name of the url
    string description - a description of this url
    string url - the url itself
    optional index preset_slot - nil, don't return any preset's content; 1 and higher, set/return the website of the index-slot
  </parameters>
  <retvals>
    boolean retval - true, if the url could be set; false, if an error occurred
    string name - the name of the url; when preset_slot is not nil then this is the content of the presetslot
    string description - a description of this url; when preset_slot is not nil then this is the content of the presetslot
    string url - the url itself; when preset_slot is not nil then this is the content of the presetslot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, podcast, website</tags>
</US_DocBloc>
]]
--is_set, index, name, description, url, preset_slot
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "is_set", "must be boolean", -1) return false end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "index", "must be an integer", -2) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "name", "must be a string", -3) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "description", "must be a string", -4) return false end
  if type(url)~="string" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "url", "must be a string", -5) return false end
  if preset_slot~=nil and math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "preset_slot", "must be an integer", -6) return false end

  local _, A, B, C, A1, D, E, F
  if is_set==true then
    if preset_slot~=nil then
      name=string.gsub(name, "\r", "")
      description=string.gsub(description, "\r", "")
      url=string.gsub(url, "\r", "")
      retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_name", string.gsub(name, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_description", string.gsub(description, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_url", string.gsub(url, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetPodcastWebsite", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
      return retval, name, description, url
    else
      presetcontent=nil
    end

    _,A1=reaper.GetProjExtState(0, "PodcastMetaData", "podc_maxindex")
    if A1=="" or index>tonumber(A1) then
      reaper.SetProjExtState(0, "PodcastMetaData", "podc_maxindex", index)
    end
    reaper.SetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_name", name)
    reaper.SetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_description", description)
    reaper.SetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_url", url)
    return true, name, description, url
  else
    if preset_slot~=nil then
      --print2("")
      local old_errorcounter = ultraschall.CountErrorMessages()
      D=ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_name", "ultraschall_podcast_presets.ini")
      E=ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_description", "ultraschall_podcast_presets.ini")
      F=ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, "podc_website_"..index.."_url", "ultraschall_podcast_presets.ini")
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      D=string.gsub(D, "\\n", "\n")
      E=string.gsub(E, "\\n", "\n")
      F=string.gsub(F, "\\n", "\n")
      if D=="" and E=="" and F=="" then retval=false else retval=true end
      return retval, D, E, F
    end
    _,A=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_name")
    _,B=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_description")
    _,C=reaper.GetProjExtState(0, "PodcastMetaData", "podc_website_"..index.."_url")
    return true, A, B, C
  end
end


--A,B,C=ultraschall.GetSetPodcastWebsite(true, 34, "My \"url\"", "This\n \\n is my url, use this and not another one", "http://www.name.de")



--A=ultraschall.PodcastMetaData_ExportWebsiteAsJSON()
--print3(A)

ultraschall.PodcastContributorAttributes = {
  "ctrb_name",
  "ctrb_description",
  "ctrb_email",
  "ctrb_role",
  "ctrb_guid"
  --"ctrb_website_name",
  --"ctrb_website_description",
  --"ctrb_website_url"
}

function ultraschall.GetSetContributor_Attributes(is_set, index, attributename, content, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetContributor_Attributes</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetContributor_Attributes(boolean is_set, integer index, string attributename, string content, integer preset_slot)</functioncall>
  <description>
    Get/set contributor-metadata-attributes for an episode. You can have multiple contributors per episode.
    
    This is about the the individual episodes.    
    
    Accepted attributes are:
    
      "ctrb_name" - the name of the contributor
      "ctrb_description" - a description of the contributor
      "ctrb_email" - the email of the contributor
      "ctrb_role" - the role of the guest, either "guest", "host", "contributor", "other"
      
    preset-values will be stored into resourcepath/ultraschall\_podcast\_presets.ini
    
    You can either set the current project's attributes(preset\_slot=nil) or a preset(preset\_slot=1 and higher)
    
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer index - the index of the contributor to store, 1 and higher
    string attributename - the name of the attribute for the contributor
    string additional_attribute - the additional attribute for some attributes; set to nil, if not needed.
    string content - the value for this contributor
    optional index preset_slot - nil, don't return any preset's content; 1 and higher, set/return the contributor's entry as stored in the presets
  </parameters>
  <retvals>
    boolean retval - true, if the url could be set; false, if an error occurred
    string content - the content of the attribute for this contributor; when preset_slot is not nil then this will be content of the preset-slot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, contributor</tags>
</US_DocBloc>
]]
--is_set, index, attributename, content, preset_slot
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "is_set", "must be a boolean", -1) return false end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "index", "must be an integer", -2) return false end
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "attributename", "must be a string", -3) return false end
  if type(content)~="string" then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "content", "must be a string", -4) return false end
  if preset_slot~=nil and math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "preset_slot", "must be an integer", -5) return false end
  if is_set==true and attributename=="ctrb_role" then
    if content~="guest" and content~="host" and content~="contributor" and content~="other" then 
      ultraschall.AddErrorMessage("GetSetContributor_Attributes", "attributename", "must be \"host\", \"guest\", \"contributor\" or \"other\"", -10) 
      return false
    end  
  end
  
  local additional_attribute=""
  --if additional_attribute==nil then additional_attribute="" else additional_attribute="_"..additional_attribute end
  local tags=ultraschall.PodcastContributorAttributes 
  local presetcontent, retval
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  if found==false then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "attributename", "attributename "..attributename.." not supported", -7) return false end
  if is_set==true then    
    if preset_slot~=nil then
      content=string.gsub(content, "\r", "")
      retval = ultraschall.SetUSExternalState("ContributorsMetaData_"..preset_slot, attributename.."_"..index..additional_attribute, string.gsub(content, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetContributor_Attributes", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
      return retval, content
    else
      presetcontent=nil
    end
    
    local retval, guid = reaper.GetProjExtState(0, "ContributorsMetaData_", "ctrb_guid"..index, content)
    
    if guid=="" then    
      local newguid=reaper.genGuid()
      _=reaper.SetProjExtState(0, "ContributorsMetaData_", "ctrb_guid"..index, reaper.genGuid(""))        
    end
    if attributename=="ctrb_guid" then
      local _, guid = reaper.GetProjExtState(0, "ContributorsMetaData_", "ctrb_guid"..index, content)
      return _>0, guid
    end
    local _,A1=reaper.GetProjExtState(0, "ContributorsMetaData_", "ctrb_contributors_maxindex")
    if A1=="" or index>tonumber(A1) then
      reaper.SetProjExtState(0, "ContributorsMetaData_", "ctrb_contributors_maxindex", index)
    end
    _=reaper.SetProjExtState(0, "ContributorsMetaData_", attributename..index..additional_attribute, content)  
    return _>0, content, presetcontent
  else
  
    if preset_slot~=nil then
      --print2("")
      local old_errorcounter = ultraschall.CountErrorMessages()
      presetcontent=ultraschall.GetUSExternalState("ContributorsMetaData_"..preset_slot, attributename.."_"..index..additional_attribute, "ultraschall_podcast_presets.ini")
      if presetcontent=="" then return false, "" end
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetContributor_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      presetcontent=string.gsub(presetcontent, "\\n", "\n")
      return true, presetcontent
    end
    local _, content = reaper.GetProjExtState(0, "ContributorsMetaData_", attributename..index..additional_attribute)
    return _>0, content
  end
end


function ultraschall.GetPodcastAttributePresetSlotByName(name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastAttributePresetSlotByName</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetPodcastAttributePresetSlotByName(string name)</functioncall>
  <description>
    Gets the preset-index of a Podcast-Attribute-Preset by its name.
    
    Index must be between 1 and 4096 or it will return -1
    
    returns -1 in case of an error
  </description>
  <parameters>
    string name - the name of the preset, non case-sensitive
  </parameters>
  <retvals>
    integer index - the index of the preset; -1, in case of an error
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, preset</tags>
</US_DocBloc>
]]
  if type(name)~="string" then ultraschall.AddErrorMessage("GetPodcastAttributePresetSlotByName", "name", "must be a string", -1) return -1 end
  name=name:lower()
  for i=1, 4096 do
    local temp=ultraschall.GetPodcastAttributesPreset_Name(i)
    if temp~=nil and name==temp:lower() then 
      return i 
    end
  end
  return -1
end

--A1=ultraschall.GetPodcastPresetSlotByPresetName(1)

function ultraschall.GetEpisodeAttributePresetSlotByName(name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEpisodeAttributePresetSlotByName</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer index = ultraschall.GetEpisodeAttributePresetSlotByName(string name)</functioncall>
  <description>
    Gets the preset-index of an Episode-Attribute-Preset by its name.
    
    Index must be between 1 and 4096 or it will return -1
    
    returns -1 in case of an error
  </description>
  <parameters>
    string name - the name of the preset, non case-sensitive
  </parameters>
  <retvals>
    integer index - the index of the preset; -1, in case of an error
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, episode, preset</tags>
</US_DocBloc>
]]
  if type(name)~="string" then ultraschall.AddErrorMessage("GetEpisodeAttributePresetSlotByName", "name", "must be a string", -1) return -1 end
  name=name:lower()
  for i=1, 4096 do
    local temp=ultraschall.GetPodcastEpisodeAttributesPreset_Name(i)
    if temp~=nil and name==temp:lower() then 
      return i 
    end
  end
  return -1
end

--ultraschall.SetPodcastEpisodeAttributesPreset_Name(1021, "orbital")
--A=ultraschall.GetPodcastEpisodePresetSlotByPresetName(1)

function ultraschall.GetPodcastContributorAttributesAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastContributorAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string podcastmetadata_json = ultraschall.GetPodcastContributorAttributesAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for contributors as JSON according to PodMeta_v1-standard..
  </description>
  <retvals>
    string contributorsmetadata_json - the contributor's-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, contributor, metadata, json, podmeta_v1</tags>
</US_DocBloc>
]]
  local JSON=""
  local _, max_index=reaper.GetProjExtState(0, "ContributorsMetaData_", "ctrb_contributors_maxindex")
  if max_index=="" then max_index=0 end
  for a=1, tonumber(max_index) do
    JSON=JSON.."\"ctrb_"..a.."\":{ \n"
    for i=1, #ultraschall.PodcastContributorAttributes do
      local retval, content = ultraschall.GetSetContributor_Attributes(false, a, ultraschall.PodcastContributorAttributes[i], "")
      if retval==true and content~="" then
        content=string.gsub(content, "\"", "\\\"")
        content=string.gsub(content, "\\n", "\\\\n")
        content=string.gsub(content, "\n", "\\n")
        JSON=JSON.."\t\t\""..ultraschall.PodcastContributorAttributes[i].."\":\""..content.."\",\n"
      end
    end
    -- contributor's websites
    local count=0
    --[[
    -- removed, add again, when new contributor's website-functions are available
    for b=1, 1024 do
      local retval1, name = ultraschall.GetSetContributor_Attributes(false, a, "ctrb_website_name", b, "")
      local retval2, description = ultraschall.GetSetContributor_Attributes(false, a, "ctrb_website_description", b, "")
      local retval3, url = ultraschall.GetSetContributor_Attributes(false, a, "ctrb_website_url", b, "")           
      if retval1==true or retval2==true or retval3==true then
        name=string.gsub(name, "\"", "\\\"")
        name=string.gsub(name, "\\n", "\\\\n")
        name=string.gsub(name, "\n", "\\n")
        
        description=string.gsub(description, "\"", "\\\"")
        description=string.gsub(description, "\\n", "\\\\n")
        description=string.gsub(description, "\n", "\\n")
        
        url=string.gsub(url, "\"", "\\\"")
        url=string.gsub(url, "\\n", "\\\\n")
        url=string.gsub(url, "\n", "\\n")
       --print2(a, b, name, description, url)
        count=count+1
        JSON=JSON.."\t\t\"ctrb_website_"..count.."\":{\n"
        JSON=JSON.."\t\t\t\"ctrb_website_name\":\""..name.."\",\n"
        JSON=JSON.."\t\t\t\"ctrb_website_description\":\""..description.."\",\n"
        JSON=JSON.."\t\t\t\"ctrb_website_url\":\""..url.."\"\n"
        JSON=JSON.."\t\t},\n"
      end
    end
    --]]
    JSON=JSON:sub(1,-3).."\n},\n"
  end

  return JSON:sub(1,-3)
end

function ultraschall.CountContributors()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountContributors</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>integer contributors_count = ultraschall.CountContributors()</functioncall>
  <description>
    Returns the number of podcast-contributors stored in this project.
  </description>
  <retvals>
    integer contributors_count - the number of stored contributors in this project
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, count, contributor</tags>
</US_DocBloc>
]]
  local _, max_index=reaper.GetProjExtState(0, "ContributorsMetaData_", "ctrb_contributors_maxindex")
  if max_index=="" then max_index=0 end
  return tonumber(max_index)
end



function ultraschall.SetPodcastAttributesPreset_Name(preset_slot, preset_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPodcastAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetPodcastAttributesPreset_Name(integer preset_slot, string preset_name)</functioncall>
  <description>
    Sets the name of a podcast-metadata-preset
        
    Note, this sets only the presetname for the podcast-metadata-preset. To set the name of the podcast-episode-metadata-preset, see: [SetPodcastEpisodeAttributesPreset\_Name](#SetPodcastEpisodeAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to set
    string preset_name - the new name of the preset
  </parameters>
  <retvals>
    boolean retval - true, if setting the name was successful; false, if setting the name was unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, set, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  if type(preset_name)~="string" then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_name", "must be a string", -3) return false end
  preset_name=string.gsub(preset_name, "\n", "\\n")
  local retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, "Preset_Name", preset_name, "ultraschall_podcast_presets.ini")
  if retval==false then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "", "couldn't store presetname in ultraschall_podcast_presets.ini; is it accessible?", -3) return false end
  return true
end
  

--ultraschall.SetPodcastAttributesPreset_Name(1, "Atuch")

function ultraschall.GetPodcastAttributesPreset_Name(preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string preset_name = ultraschall.GetPodcastAttributesPreset_Name(integer preset_slot)</functioncall>
  <description>
    Gets the name of a podcast-metadata-preset
        
    Note, this gets only the presetname for the podcast-metadata-preset. To get the name of the podcast-episode-metadata-preset, see: [GetPodcastEpisodeAttributesPreset\_Name](#GetPodcastEpisodeAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to get
  </parameters>
  <retvals>
    string preset_name - the name of the podcast-metadata-preset
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("GetPodcastAttributesPreset_Name", "preset_slot", "must be an integer", -1) return end
  if preset_slot<1 then ultraschall.AddErrorMessage("GetPodcastAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return end
  
  local presetname = ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, "Preset_Name", "ultraschall_podcast_presets.ini")
  return string.gsub(presetname, "\\n", "\n")
end


--A,B=ultraschall.GetPodcastAttributesPreset_Name(1)

function ultraschall.SetPodcastEpisodeAttributesPreset_Name(preset_slot, presetname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPodcastEpisodeAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetPodcastEpisodeAttributesPreset_Name(integer preset_slot, string preset_name)</functioncall>
  <description>
    Sets the name of a podcast-episode-metadata-preset
    
    Note, this sets only the presetname for the episode-metadata-preset. To set the name of the podcast-metadata-preset, see: [SetPodcastAttributesPreset\_Name](#SetPodcastAttributesPreset_Name)
    
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to set
    string preset_name - the new name of the preset
  </parameters>
  <retvals>
    boolean retval - true, if setting the name was successful; false, if setting the name was unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, set, podcast, metadata, preset, name, episode</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  if type(presetname)~="string" then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_name", "must be a string", -3) return false end
  presetname=string.gsub(presetname, "\n", "\\n")
  local retval = ultraschall.SetUSExternalState("Episode_"..preset_slot, "Preset_Name", presetname, "ultraschall_podcast_presets.ini")
  if retval==false then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "", "couldn't store presetname in ultraschall_podcast_presets.ini; is it accessible?", -3) return false end
  return true
end
  

--A=ultraschall.SetPodcastEpisodeAttributesPreset_Name(1, "AKullerauge sei wachsam")

function ultraschall.GetPodcastEpisodeAttributesPreset_Name(preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastEpisodeAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string preset_name = ultraschall.GetPodcastEpisodeAttributesPreset_Name(integer preset_slot)</functioncall>
  <description>
    Gets the name of a podcast-metadata-preset
        
    Note, this gets only the presetname for the episode-metadata-preset. To get the name of the podcast-metadata-preset, see: [GetPodcastAttributesPreset\_Name](#GetPodcastAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to get
  </parameters>
  <retvals>
    string preset_name - the name of the podcast-metadata-preset
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("GetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be an integer", -1) return end
  if preset_slot<1 then ultraschall.AddErrorMessage("GetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return end
  
  local presetname=ultraschall.GetUSExternalState("Episode_"..preset_slot, "Preset_Name", "ultraschall_podcast_presets.ini")
  return string.gsub(presetname, "\\n", "\n")
end

--A,B=ultraschall.GetPodcastEpisodeAttributesPreset_Name(1)

function ultraschall.TakeMarker_GetAllTakeMarkers(take)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TakeMarker_GetAllTakeMarkers</slug>
  <requires>
    Ultraschall=5
    Reaper=7.03
    Lua=5.3
  </requires>
  <functioncall>integer count_takemarkers, table all_takemarkers = ultraschall.TakeMarker_GetAllTakeMarkers(MediaItem_Take take)</functioncall>
  <description>
    returns all take-markers of a MediaItem_Take, inclusing project-position.
    Will obey time-stretch-markers, offsets, etc, as well.

    Note: when the active take of the parent-item is a different one than the one you've passed, this will temporarily switch the active take to the one you've passed.
    That could potentially cause audio-glitches!
    
    Returned table is of the following format:
      Takemarkers[index]["pos"] - position within take
      Takemarkers[index]["project_pos"] - the project-position of the take-marker
      Takemarkers[index]["name"] - name of the takemarker
      Takemarkers[index]["color"] - color of the takemarker
      Takemarkers[index]["visible"] - is the takemarker visible or not
    
    Returns nil in case of an error
  </description>
  <linked_to desc="see:">
    inline:GetTakeSourcePosByProjectPos
           gets the take-source-position by project position
  </linked_to>
  <retvals>
    integer count_takemarkers - the number of available take-markers
    table all_takemarkers - a table with all takemarkers of the take(see description for details)
  </retvals>
  <parameters>
    MediaItem_Take take - the take, whose source-position you want to retrieve
  </parameters>
  <chapter_context>
    Mediaitem Take Management
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem takes, get, all, takemarkers, project position</tags>
</US_DocBloc>
]]
-- TODO:
-- Rename AND Move(!) Take markers by a huge number of seconds instead of deleting them. 
-- Then add new temporary take-marker, get its position and then remove it again.
-- After that, move them back. That way, you could retain potential future guids in take-markers.
-- Needed workaround, as Reaper, also here, doesn't allow adding a take-marker using an action, when a marker already exists at the position...for whatever reason...

  -- check parameters
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "take", "must be a valid MediaItem_Take", -2) return end
  local item = reaper.GetMediaItemTakeInfo_Value(take, "P_ITEM")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_pos_end = item_pos+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  reaper.PreventUIRefresh(1)
  
  -- store item-selection and deselect all
  local count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(0),  ultraschall.CreateTrackString_AllTracks(), false)
  local retval = ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
  
  -- get current take-markers and remove them
  local takemarkers={}
  for i=reaper.GetNumTakeMarkers(take)-1, 0, -1 do
    local position, name, color = reaper.GetTakeMarker(take, i)
    takemarkers[i+1]={}
    takemarkers[i+1]["pos"]=position
    takemarkers[i+1]["name"]=name
    takemarkers[i+1]["color"]=color
    reaper.DeleteTakeMarker(take, i)
  end
  
  -- set take-marker at source-position of take, select the take and use "next take marker"-action to go to it
  -- then get the cursor position to get the project-position
  -- and finally, delete the take marker reset the view and cursor-position
  local starttime, endtime = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  local oldpos=reaper.GetCursorPosition()
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1)
  local active_take=reaper.GetActiveTake(item)
  reaper.SetActiveTake(take)
  takemarkers_visible={}
  for i=1, #takemarkers do
  --print2("")
    reaper.SetTakeMarker(take, -1, "", takemarkers[i]["pos"])
    reaper.SetEditCurPos(-20, false, false)
    reaper.Main_OnCommand(42394, 0)
    local projectpos=reaper.GetCursorPosition()
    takemarkers[i]["project_pos"]=projectpos
    takemarkers[i]["visible"]=projectpos>=item_pos and projectpos<=item_pos_end 
    reaper.DeleteTakeMarker(take, 0)
  end
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
  reaper.SetActiveTake(active_take)
  reaper.SetEditCurPos(oldpos, false, false)
  reaper.GetSet_ArrangeView2(0, true, 0, 0, starttime, endtime)

  -- rename take-markers back to their old name
  for i=1, #takemarkers do
    reaper.SetTakeMarker(take, i-1, takemarkers[i]["name"], takemarkers[i]["pos"], takemarkers[i]["color"])
  end
  
  -- reselect old item-selection
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  
  reaper.PreventUIRefresh(-1)

  return #takemarkers, takemarkers
end

