  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
  --]]

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