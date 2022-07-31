dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

OldActions={reaper.EnumProjectMarkers3(0, marker_id)}
OldActions=OldActions[5]

retval = reaper.PromptForAction(1, 0, 0)
actions="!"

function main()
  local retval = reaper.PromptForAction(0, 0, 0)
  if retval~=-1 then
    if retval>0 then
      aid=reaper.ReverseNamedCommandLookup(retval)
      if aid~=nil then aid="_"..aid else aid=retval end
      actions=actions..aid.." "
      A={reaper.EnumProjectMarkers3(0, marker_id)}
      B=reaper.SetProjectMarkerByIndex2(0, marker_id, A[2], A[3], A[4], A[6], actions, A[7], 0)
    end
  else
    reaper.PromptForAction(-1, 0, 0)
    local A={reaper.EnumProjectMarkers3(0, marker_id)}
    if actions~="!" then
      B=reaper.SetProjectMarkerByIndex2(0, marker_id, A[2], A[3], A[4], A[6], actions, A[7], 0)
    else
    B=reaper.SetProjectMarkerByIndex2(0, marker_id, A[2], A[3], A[4], A[6], OldActions, A[7], 0)
      
    end
    return
  end
  reaper.defer(main)
end

main()

