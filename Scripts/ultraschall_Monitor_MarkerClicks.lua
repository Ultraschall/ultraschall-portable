dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- ToDo:
-- ultraschall_marker_menu.ini reincoden für verschiedene Markertypen
-- eventuell auch Support für Regions, für "Region Rendering"?

arrange_view, HWND_timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()

function GetMarkerMenu(MarkerType)
  -- read the menu from ultraschall_marker_menu.ini and generate this entry
  return "1|2|3", {40016,2,3}
end

--reaper.JS_Window_Move(

function main()
  X,Y=reaper.GetMousePosition()
  HWND_Focus=reaper.JS_Window_FromPoint(X,Y)
  MouseState=reaper.JS_Mouse_GetState(-1)
  if HWND_Focus==HWND_timeline and MouseState==2 then
    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, X, X)
    reaper.BR_GetMouseCursorContext()
    Marker, Marker2 = ultraschall.GetMarkerByScreenCoordinates(X)
    if Marker~="" then
      Marker2=tonumber(Marker2:match("(.-)\n"))
      MarkerType, MarkerTypeIndex=ultraschall.GetMarkerType(Marker2-1)
      MarkerMenu, MarkerActions=GetMarkerMenu(MarkerType)
      Retval = ultraschall.ShowMenu("Menu:"..Marker2, MarkerMenu.."|"..MarkerType.."|"..MarkerTypeIndex, X, Y)
      if Retval~=-1 then 
        ultraschall.StoreTemporaryMarker(Marker2-1)
        C=ultraschall.GetTemporaryMarker()
        reaper.Main_OnCommand(MarkerActions[Retval], 0)
      end
    end
    SLEM()
    A=reaper.time_precise()
  end

  reaper.defer(main)
end

main()

print2("Running the Marker-Right-Click-Listener. This will show a new contextmenu, when right-clicking a marker.")
--A,B=ultraschall.GetMarkerType(11)









