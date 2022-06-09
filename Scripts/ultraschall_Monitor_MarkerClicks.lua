dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- Versuchen das Gfx-Fenster auf Größe 0 zu setzen...

arrange_view, HWND_timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()

ShowMarkerType_In_Menu=true

function GetMarkerMenu(MarkerType)
  -- read the menu from ultraschall_marker_menu.ini and generate this entry
  local actions={}
  if ShowMarkerType_In_Menu==true then actions[1]=0 end
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
  if menuentry=="" then return nil end
  return menuentry:sub(1,-2), actions
end


function main()
  if Retval~=-1 and Retval~=nil then 
    ultraschall.StoreTemporaryMarker(Marker2)
    reaper.Main_OnCommand(MarkerActions[Retval], 0)
  end
  Retval=nil
  local X,Y=reaper.GetMousePosition()
  local HWND_Focus=reaper.JS_Window_FromPoint(X,Y)
  local MouseState=reaper.JS_Mouse_GetState(-1)
  if HWND_Focus==HWND_timeline and MouseState==2 then
    local start_time, end_time = reaper.GetSet_ArrangeView2(0, false, X, X)
    reaper.BR_GetMouseCursorContext()
    local Marker, Marker2 = ultraschall.GetMarkerByScreenCoordinates(X)
    if Marker=="" then
      Marker, Marker2 = ultraschall.GetRegionByScreenCoordinates(X)
    end
    if Marker~="" then
      Marker2=tonumber(Marker2:match("(.-)\n"))
      MarkerType, MarkerTypeIndex=ultraschall.GetMarkerType(Marker2)
      MarkerMenu, MarkerActions=GetMarkerMenu(MarkerType)
      if MarkerMenu~=nil then
        if ShowMarkerType_In_Menu==false then
          Markername=""
        else
          Markername="#\""..MarkerType.."\" - MarkerNr:"..Marker2.."|"
        end
        Retval = ultraschall.ShowMenu("Markermenu:", Markername..MarkerMenu, X, Y)
      end
    end
    A=reaper.time_precise()
  end

  reaper.defer(main)
end

main()


print2("Running the Marker-Right-Click-Listener. This will show a new contextmenu, when right-clicking a marker.")

