dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- Versuchen das Gfx-Fenster auf Größe 0 zu setzen...

arrange_view, HWND_timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()

ShowMarkerType_In_Menu=false

function GetMarkerMenu(MarkerType, clicktype, Markernr)
  -- read the menu from ultraschall_marker_menu.ini and generate this entry
  if clicktype&2==2 then 
    clicktype="RightClck"
  --elseif clicktype&1==1 then 
--    clicktype="LeftClck"     
  else
    return
  end
  local actions={}
  if reaper.GetExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu")~="" then
    ShowMarkerType_In_Menu=true
  else
    ShowMarkerType_In_Menu=false
  end
  if ShowMarkerType_In_Menu==true then actions[1]=0 end
  local menuentry=""
  for i=1, 1024 do
    local temp_description = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_Description", "ultraschall_marker_menu.ini")
    local temp_action = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_ActionCommandID", "ultraschall_marker_menu.ini")    
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
  if reaper.GetExtState("ultraschall_api", "markermenu_debug_messages_markertype")~="" then
    print(Markernr..":\""..MarkerType.."_"..clicktype.."\"")
  end
  if menuentry=="" then return nil end
  return menuentry:sub(1,-2), actions
end


function main()
  if Retval~=-1 and Retval~=nil then     
    reaper.Main_OnCommand(MarkerActions[Retval], 0)
  end
  Retval=nil
  local X,Y=reaper.GetMousePosition()
  local HWND_Focus=reaper.JS_Window_FromPoint(X,Y)
  local MouseState=reaper.JS_Mouse_GetState(-1)
  if HWND_Focus==HWND_timeline and MouseState~=0 and MouseState&16~=16 then
    local start_time, end_time = reaper.GetSet_ArrangeView2(0, false, X, X)
    reaper.BR_GetMouseCursorContext()
    local Marker, Marker2 = ultraschall.GetMarkerByScreenCoordinates(X)
    if Marker=="" then
      Marker, Marker2 = ultraschall.GetRegionByScreenCoordinates(X)
    end
    if Marker~="" then
      Marker2=tonumber(Marker2:match("(.-)\n"))
      MarkerType, MarkerTypeIndex=ultraschall.GetMarkerType(Marker2)
      MarkerMenu, MarkerActions=GetMarkerMenu(MarkerType, MouseState, Marker2)
      if MarkerMenu~=nil then        
        if ShowMarkerType_In_Menu==false then
          Markername=""
        else
          Markername="#\""..MarkerType.."\" - MarkerNr:"..Marker2.." Guid:"..ultraschall.GetGuidFromMarkerID(Marker2+1).."|"
        end
        Retval = ultraschall.ShowMenu("Markermenu:", Markername..MarkerMenu, X, Y)
        if Retval~=-1 then ultraschall.StoreTemporaryMarker(Marker2) end
      end
    end
    A=reaper.time_precise()
  end
  if reaper.GetExtState("ultraschall_api", "markermenu_started")~="" then
    OldMouseState=MouseState
    reaper.defer(main)
  end
end

function atexit()
  reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
end

reaper.atexit(atexit)

reaper.SetExtState("ultraschall_api", "markermenu_started", "started", false)
main()


--print2("Running the Marker-Right-Click-Listener. This will show a new contextmenu, when right-clicking a marker.")
