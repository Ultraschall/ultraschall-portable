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

-- Ultraschall-API demoscript - 7th of July 2020
--
-- Render Regions of current project as FLAC
-- FLAC will be 24 Bit and encoding-speed of 5
-- 
-- To render a region, start the script and Ctrl+Leftclick or CMD+LeftClick on the Region to render
-- It will ask you for an export-filename.
--
-- Your last Exportfilename will be remembered by the script.
--
-- This script requires
--   - the Ultraschall-API (ultraschall.fm/api)
--   - SWS-extension (sws-extension.org)
--   - Julian Sader's-extension-plugin (https://github.com/juliansader/ReaExtensions/tree/master/js_ReaScriptAPI/)

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

render_cfg_string = ultraschall.CreateRenderCFG_FLAC(0, 5)


function main()
  A=reaper.JS_Mouse_GetState(255)
  B,C,D=reaper.BR_GetMouseCursorContext()
  Markers, M2 = ultraschall.GetRegionByScreenCoordinates(reaper.GetMousePosition(), false)
  if A==5 and C=="region_lane" and Markers~="" then
    Oldfilename=reaper.GetExtState("Render", "ExportFilename")
    Count, Split_string = ultraschall.SplitStringAtLineFeedToArray(Markers)
    L=Count-2
    E, F = reaper.GetUserInputs("Export-Filename", 1, "Filename", Oldfilename)
    if E==true then
      retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProjectRegions_RenderCFG(nil, F, tonumber(Split_string[L]), true, false, nil, nil, render_cfg_string)
      reaper.SetExtState("Render", "ExportFilename", F, true)
    end
  end
  
  reaper.defer(main)
end

reaper.MB("Renders Regions, by clicking on them with Ctrl+Leftclick or Cmd+LeftClick.\n\nRegions will be rendered as FLAC with 24 Bit and Encoding-Speed of 5.", "Render Region Of Current Project-Script - by Meo Mespotine", 0)
main()
