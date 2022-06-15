dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- Auf Mac und Linux ohne Fenster arbeiten, weil gfx.showmenu dort wohl ohne funzt... 

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
  local aid = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "StartUpAction", "ultraschall_marker_menu.ini")
  ultraschall.RunCommand(aid)
  if ShowMarkerType_In_Menu==true then actions[1]=0 end
  local menuentry=""
  local menu2={}
  local menu3={}
  for i=1, 1024 do
    local temp_description = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_Description", "ultraschall_marker_menu.ini")
    local temp_additional_data = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_AdditionalData", "ultraschall_marker_menu.ini")
    local temp_action = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_ActionCommandID", "ultraschall_marker_menu.ini")    
    menu2[i]=temp_description
    menu3[i]=temp_additional_data
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
  return menuentry:sub(1,-2), actions, menu2, menu3
end


function main()
  if Retval~=-1 and Retval~=nil then
    reaper.PreventUIRefresh(1)
    local position=reaper.GetCursorPosition()
    reaper.MoveEditCursor(-position, false)
    local A={reaper.EnumProjectMarkers3(0, globalMarker2)}
    reaper.MoveEditCursor(A[3], false)
    
    reaper.Main_OnCommand(MarkerActions[Retval], 0)
    
    reaper.MoveEditCursor(-A[3], false)
    reaper.MoveEditCursor(position, false)
    reaper.PreventUIRefresh(-1)
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
      globalMarker2=Marker2
      MarkerType, MarkerTypeIndex=ultraschall.GetMarkerType(Marker2)
      MarkerMenu, MarkerActions, MenuEntries, MenuEntries_Data=GetMarkerMenu(MarkerType, MouseState, Marker2)
      if MarkerMenu~=nil then        
        if ShowMarkerType_In_Menu==false then
          Markername=""
        else
          Markername="#\""..MarkerType.."\" - MarkerNr:"..Marker2.." Guid:"..ultraschall.GetGuidFromMarkerID(Marker2+1).."|"
        end
        Retval = ultraschall.ShowMenu("Markermenu:", Markername..MarkerMenu, X, Y)
        if Retval~=-1 then 
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry", MenuEntries[Retval], false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType", MarkerType, false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_EntryNumber", Retval, false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData", MenuEntries_Data[Retval], false)
          ultraschall.StoreTemporaryMarker(Marker2) 
        end
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

