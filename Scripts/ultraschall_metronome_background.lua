--initial release
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- hole position
-- finde marker in der nähe (vor und nach)
-- falls ein Marker in einem Abstand von x ist dann spiele sound über metronom
--   d.h. Metronom an kurz warten und wieder aus, vorher ggf. die Metronomsettings anpassen


-- forschung1: reicht die Suche mit ultraschall.GetMarkerByTime(number position, boolean retina)


function US_play_sound_using_metronome()
end

function US_get_nearest_markers_from_position()
  --position=reaper.GetCursorPosition()
  position=reaper.GetPlayPosition()
  return ultraschall.GetMarkerByTime(position, false)
end


markers=US_get_nearest_markers_from_position()
if markers ~="" then
   reaper.ShowConsoleMsg("juhu")
    else
    katze="nooooooo"
end







function MainLoop()
    if reaper.time_precise()-lasttime > 1 then
      lasttime=reaper.time_precise()
      marker=US_get_nearest_markers_from_position()
      if marker ~="" then
        reaper.ShowConsoleMsg("Ein Marker! Er hat den Namen: "..marker.."\r")
      end
    end
    reaper.defer(MainLoop)
end



lasttime = reaper.time_precise() + 1
reaper.defer(MainLoop)

