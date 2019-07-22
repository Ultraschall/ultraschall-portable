-- Ultraschall-API demoscript - 17th of December 2018
--
-- Render Regions of current project as FLAC
-- FLAC will be 24 Bit and encoding-speed of 5
-- 
-- To render a region, start the script and Ctrl+Leftclick or CMD+LeftClick on the Region to render
-- It will ask you for an export-filename.
--
-- Your last Exportfilename will be remembered by the script.
--
-- Before rendering, project must be saved first.
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
--    reaper.ClearConsole()
--    Markers=string.gsub(Markers,"\n\n", "\n")
--    reaper.ShowConsoleMsg(Markers.."A")
    if reaper.IsProjectDirty(0)==0 then
      Oldfilename=reaper.GetExtState("Render", "ExportFilename")
      Count, Split_string = ultraschall.SplitStringAtLineFeedToArray(Markers)
      L=Count-2
      E, F = reaper.GetUserInputs("Export-Filename", 1, "Filename", Oldfilename)
      if E==true then
        retval, renderfilecount, MediaItemStateChunkArray, Filearray = ultraschall.RenderProjectRegions_RenderCFG(nil, F, tonumber(Split_string[L]), true, false, nil, nil, render_cfg_string)
        reaper.SetExtState("Render", "ExportFilename", F, true)
      end
    else
      reaper.MB("Project must be saved first", "Error", 0)
    end
  end
  
  reaper.defer(main)
end

reaper.MB("Renders Regions, by clicking on them with Ctrl+Leftclick or Cmd+LeftClick.\n\nRegions will be rendered as FLAC with 24 Bit and Encoding-Speed of 5.", "Render Region Of Current Project-Script - by Meo Mespotine", 0)
main()
