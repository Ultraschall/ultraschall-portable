dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.GetMarkerType(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerType</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string markertype = ultraschall.GetMarkerType(integer idx)</functioncall>
  <description>
    return the type of a marker, either "shownote", "edit", "custom", "normal" for chapter markers and "planned".
    
    Works only on markers!
    
    returns "no such marker", when markerindex is no valid markerindex
    
    returns nil in case of an error
  </description>
  <retvals>
    string markertype - see description for more details
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers in the project, beginning with 0 for the first marker
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
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetMarkerType", "idx", "must be an integer", -1) return end
  
  local MarkerAttributes={reaper.EnumProjectMarkers3(0, idx)}
  
  local Shownote, Shownote_idx=ultraschall.IsMarkerShownote(idx)
  if Shownote==true then return "shownote", Shownote_idx end  
  
  local editmarkers, editmarkersarray = ultraschall.GetAllEditMarkers()
  for i=1, editmarkers do
    if editmarkersarray[i][2]==idx+1 then 
      return "edit", i-1 
    end
  end

  if MarkerAttributes[7]==ultraschall.planned_marker_color then 
    planned_count=-1
    for i=0, idx do
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
      if marker_index==idx then return "custom", i end
    end
  end
  if ultraschall.IsMarkerNormal(idx)==true then 
    for i=1, ultraschall.CountNormalMarkers() do
      retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
      if retnumber-1==idx then return "normal", i end
    end
  end

  return "no such marker"
end

A,B=ultraschall.GetMarkerType(-1)
