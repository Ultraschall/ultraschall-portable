dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- eventuell auch Support für Regions, für "Region Rendering"?

arrange_view, HWND_timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()

function GetMarkerMenu(MarkerType)
  -- read the menu from ultraschall_marker_menu.ini and generate this entry
  
  if MarkerType~="edit" and MarkerType~="shownote" and MarkerType~="planned" and MarkerType~="normal" then
    return nil
  end
  local actions={}
  local menuentry=""
  for i=1, 1024 do
    local temp_description = ultraschall.GetUSExternalState(MarkerType, "Entry_"..i.."_Description", "ultraschall_marker_menu.ini")
    local temp_action = ultraschall.GetUSExternalState(MarkerType, "Entry_"..i.."_ActionCommandID", "ultraschall_marker_menu.ini")
    if temp_description~="" and temp_action~="" then
      local checked=""
      local cmd=reaper.NamedCommandLookup(temp_action)
      local toggle=reaper.GetToggleCommandState(cmd)
      if toggle==1 then checked="!" end
      menuentry=menuentry..checked..temp_description.."|"
      actions[#actions+1]=cmd
    else 
      break
    end
  end
  return menuentry:sub(1,-2), actions
end


function main()
  local X,Y=reaper.GetMousePosition()
  local HWND_Focus=reaper.JS_Window_FromPoint(X,Y)
  local MouseState=reaper.JS_Mouse_GetState(-1)
  if HWND_Focus==HWND_timeline and MouseState==2 then
    local start_time, end_time = reaper.GetSet_ArrangeView2(0, false, X, X)
    reaper.BR_GetMouseCursorContext()
    local Marker, Marker2 = ultraschall.GetMarkerByScreenCoordinates(X)
    if Marker~="" then
      Marker2=tonumber(Marker2:match("(.-)\n"))
      local MarkerType, MarkerTypeIndex=ultraschall.GetMarkerType(Marker2-1)
      local MarkerMenu, MarkerActions=GetMarkerMenu(MarkerType)
      if MarkerMenu~=nil then
        local Retval = ultraschall.ShowMenu("Menu:"..Marker2, MarkerMenu.."||#"..MarkerType.."-"..MarkerTypeIndex, X, Y)
        if Retval~=-1 then 
          ultraschall.StoreTemporaryMarker(Marker2-1)
          reaper.Main_OnCommand(MarkerActions[Retval], 0)
        end
      end
    end
    A=reaper.time_precise()
  end

  reaper.defer(main)
end

main()

print2("Running the Marker-Right-Click-Listener. This will show a new contextmenu, when right-clicking a marker.")









