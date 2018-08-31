--initial release
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- hole position
-- finde marker in der nähe (vor und nach)
-- falls ein Marker in einem Abstand von x ist dann spiele sound über metronom
--   d.h. Metronom an kurz warten und wieder aus, vorher ggf. die Metronomsettings anpassen


-- forschung1: reicht die Suche mit ultraschall.GetMarkerByTime(number position, boolean retina)


function US_play_sound_using_metronome()
  -- enable 41745
  -- disable 41746
  lastmetronome=reaper.time_precise()
  reaper.Main_OnCommand(41745,0)
  metronome=1
  reaper.ShowConsoleMsg("Metronome=ON\r")
  --reaper.Main_OnCommand(41746,0)
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
    if metronome==1 and reaper.time_precise()-lastmetronome > BEEP_DUR then
      reaper.ShowConsoleMsg("Metronome=OFF\r")
      reaper.Main_OnCommand(41746,0) --stop metronome
      lastmetronome=0
      metronome=0
    end
    if reaper.time_precise()-lasttime > .1 then
      lasttime=reaper.time_precise()
      marker=US_get_nearest_markers_from_position()
      if lasttime-lastmarkertime>1 then lastmarker="" end
      if marker ~="" and marker ~= lastmarker then
        lastmarker=marker
        lastmarkertime=lasttime
        US_play_sound_using_metronome()
        --reaper.ShowConsoleMsg("Ein Marker! Er hat den Namen: "..marker.."\r")
      end
      if marker==lastmarker then lastmarkertime=reaper.time_precise() end
    end
    reaper.defer(MainLoop)
end


BEEP_DUR=2
function theEnd()
end
reaper.atexit(theEnd)


lasttime = reaper.time_precise() + .1
lastmarker=""
lastmetronome=0
metronome=0
lastmarkertime=lasttime
reaper.defer(MainLoop)

