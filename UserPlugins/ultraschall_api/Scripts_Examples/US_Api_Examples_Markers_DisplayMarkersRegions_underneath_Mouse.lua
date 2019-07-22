-- Ultraschall-API demoscript by Meo Mespotine 30.11.2018
-- 
-- shows, which markers/regions are underneath the mouse-cursor


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function main()
  -- get mouseposition, markers and regions as well as the mouse-context
  x,y=reaper.GetMousePosition()  
  marker=ultraschall.GetMarkerByScreenCoordinates(x, false)
  region=ultraschall.GetRegionByScreenCoordinates(x, false)
  window = reaper.BR_GetMouseCursorContext()
  
  -- if the markers/regions underneath the mouse have changed and if mouse is in ruler, 
  -- show the currently found markers and regions in the ReaConsole-window
  if (marker~=oldmarker or region~=oldregion) and window=="ruler" then
    if marker=="" then marker="\n\n\n" end -- small hack to avoid the output being 
                                           -- too jumpy when no marker is found
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("Found Markers: \n"..marker.."\n\nFoundRegions:\n"..region)
  end
  
  -- keep the old values to check next defer-cycle, whether anything has changed
  oldmarker=marker
  oldregion=region
  
  -- start the next defer-cycle
  reaper.defer(main)
end

main()