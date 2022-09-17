dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- Auf Mac und Linux ohne Fenster arbeiten, weil gfx.showmenu dort wohl ohne funzt... 

arrange_view, HWND_timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()

ShowMarkerType_In_Menu=false

function GetMarkerMenu(MarkerType, clicktype, Markernr)
  -- read the menu from ultraschall_marker_menu.ini and generate this entry
  if clicktype&2==2 then 
    reaper.SetExtState("ultraschall_api", "markermenu_clickstate", clicktype, false)
    reaper.SetExtState("ultraschall_api", "markermenu_last_touched_marker", Markernr, false)
    clicktype="RightClck"    
  elseif clicktype&1==1 then 
    reaper.SetExtState("ultraschall_api", "markermenu_clickstate", clicktype, false)
    reaper.SetExtState("ultraschall_api", "markermenu_last_touched_marker", Markernr, false)
    clicktype="LeftClck"-- deactivated for now, until you've added a MarkerMenu_GetLastClickState-function
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
  reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
  ultraschall.StoreTemporaryMarker(Marker2) 
  
  pcall(ultraschall.RunCommand, aid)
  reaper.SetExtState("ultraschall_api", "markermenu_started", "started", false)    
  if ShowMarkerType_In_Menu==true then actions[1]=0 end
  local menuentry=""
  local menu2={}
  local menu3={}
  local menu4={}
  for i=1, 1024 do
    local temp_description = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_Description", "ultraschall_marker_menu.ini")
    local temp_additional_data = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_AdditionalData", "ultraschall_marker_menu.ini")
    local temp_action = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_ActionCommandID", "ultraschall_marker_menu.ini")    
    local submenu = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_SubMenu", "ultraschall_marker_menu.ini")    
    local greyed = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_Greyed", "ultraschall_marker_menu.ini")    
    local checked = ultraschall.GetUSExternalState(MarkerType.."_"..clicktype, "Entry_"..i.."_Checked", "ultraschall_marker_menu.ini")    
    
    if submenu=="start" then submenu=">" skip=true
    elseif submenu=="end" then submenu="<" skip=false
    elseif temp_description=="" then submenu="" skip=true
    else submenu="" skip=false
    end
    
    if greyed=="yes" then greyed="#" else greyed="" end
    --print(submenu)
    
    if temp_action~="" then
      local cmd=reaper.NamedCommandLookup(temp_action)      
      if checked=="" then
        local toggle=reaper.GetToggleCommandState(cmd)
        if toggle==1 then checked="!" end
      else
        if checked=="yes" then checked="!" else checked="" end
      end

      menuentry=menuentry..submenu..greyed..checked..temp_description.."|"
      --print(menuentry)
      --print("A"..submenu.."A")
      if skip==false then        
        actions[#actions+1]=cmd
        menu2[#menu2+1]=temp_description
        if menu2[#menu2]:sub(1,1)=="<" then 
          menu2[#menu2]=menu2[#menu2]:sub(2,-1) 
        end
        menu3[#menu3+1]=temp_additional_data
        menu4[#menu4+1]=i
      end
    else
      break
    end
  end
  if reaper.GetExtState("ultraschall_api", "markermenu_debug_messages_markertype")~="" then
    print(Markernr..":\""..MarkerType.."_"..clicktype.."\"")
  end
  if menuentry=="" then return nil end
  return menuentry:sub(1,-2), actions, menu2, menu3, menu4
end


function main()
  if Retval~=-1 and Retval~=nil then
    reaper.PreventUIRefresh(1)
    local start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
    local position=reaper.GetCursorPosition()    
    reaper.MoveEditCursor(-position, false)
    local A={reaper.EnumProjectMarkers3(0, globalMarker2)}
    reaper.MoveEditCursor(A[3], false)
    
    reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
    pcall(reaper.Main_OnCommand, MarkerActions[Retval], 0)
    reaper.SetExtState("ultraschall_api", "markermenu_started", "started", false)    
    
    reaper.MoveEditCursor(-A[3], false)
    reaper.MoveEditCursor(position, false)
    reaper.GetSet_ArrangeView2(0, true, 0, 0, start_time, end_time)
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
      MarkerMenu, MarkerActions, MenuEntries, MenuEntries_Data, MenuEntry_Nr=GetMarkerMenu(MarkerType, MouseState, Marker2)
      if MouseState&1==1 then 
        ultraschall.StoreTemporaryMarker(Marker2) 
      end
      if MarkerMenu~=nil then        
        if ShowMarkerType_In_Menu==false then
          Markername=""
        else
          Markername="#\""..MarkerType.."\" - MarkerNr:"..Marker2.." Guid:"..ultraschall.GetGuidFromMarkerID(Marker2+1).."|"
        end
        --for i=1, #MenuEntries do
          --print("A"..tostring(MenuEntries[i]).."A")
        --end
        Retval = ultraschall.ShowMenu("Markermenu:", Markername..MarkerMenu, X, Y)
        if Retval~=-1 then 
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry", MenuEntries[Retval], false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType", MarkerType, false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_EntryNumber", MenuEntry_Nr[Retval], false)
          reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData", MenuEntries_Data[Retval], false)
          ultraschall.StoreTemporaryMarker(Marker2) 
        else
          ultraschall.StoreTemporaryMarker(-1)
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
  reaper.DeleteExtState("ultraschall_api", "markermenu_clickstate", false)
  reaper.DeleteExtState("ultraschall_api", "markermenu_last_touched_marker", false)
  reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
  reaper.DeleteExtState("ultraschall_api", "MarkerMenu_Entry", false)
  reaper.DeleteExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType", false)
  reaper.DeleteExtState("ultraschall_api", "MarkerMenu_EntryNumber", false)
  reaper.DeleteExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData", false)
end

reaper.atexit(atexit)

reaper.SetExtState("ultraschall_api", "markermenu_started", "started", false)

main()


--print2("Running the Marker-Right-Click-Listener. This will show a new contextmenu, when right-clicking a marker.")

