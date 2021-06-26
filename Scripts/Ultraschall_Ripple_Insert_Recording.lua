-- Meo-Ada Mespotine 5th of February 2019 - licensed under an MIT-license

-- Inserts recording at EditCursorposition
-- will keep a gap until recording is stopped and close the gap after that
-- good for "Oof, I forgot to add this or that to include in the middle of my recording"-usecases


if reaper.GetExtState("Ultraschall", "Ripple Insert Recording")~="" then
  return
else
  reaper.SetExtState("Ultraschall", "Ripple Insert Recording", "running", false)
end

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function MoveUntilStop()
  -- moves items, track-envelope-points, regions and markers after current recording-position to be always at least
  -- 4 seconds away until recording stops
  if position<=reaper.GetPlayPosition()+4 and reaper.GetPlayState()&2==0 then
    retval = ultraschall.MoveMediaItemsAfter_By(position, 4, trackstring)
    retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, 4, false)
    retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength()+1, 4, false)
    for i=0, reaper.CountTracks(0)-1 do
      ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, 4, reaper.GetTrack(0,i), false)
    end
    position=position+4
  end
  if reaper.GetPlayState()&4==4 then
    reaper.defer(MoveUntilStop)
  else
    -- if recording stops, move items, trackenvelope-points, regions and markers after current recording-position
    -- back to close the 4+ second gap
    stopposition=reaper.GetPlayPosition()
    Aretval = ultraschall.MoveMediaItemsAfter_By(position, -(position-stopposition), trackstring)
    retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, -(position-stopposition), false)
    retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength()+1, -(position-stopposition), false)
    for i=0, reaper.CountTracks(0)-1 do
      ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, -(position-stopposition), reaper.GetTrack(0,i), false)
    end
    reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "0", false) -- aktiviere wieder den OverDub Soundcheck
    reaper.UpdateArrange()
  end
end

function main()

  -- get currently existing tracks and current edit-cursorposition
  trackstring=ultraschall.CreateTrackString_AllTracks()
  position=reaper.GetCursorPosition()

  -- move items, trackenvelope-points, regions and markers after current editcursor-position by
  -- 4 seconds toward the end of the project to make room for the recording
  retval, MediaItemArray = ultraschall.SplitMediaItems_Position(position, trackstring, false)
  retval = ultraschall.MoveMediaItemsAfter_By(position, 4, trackstring)
  retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, 4, false)
  retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength()+1, 4, false)
  for i=0, reaper.CountTracks(0)-1 do
    ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, 4, reaper.GetTrack(0,i), false)
  end

  position=position+4
  reaper.CSurf_OnRecord()
  MoveUntilStop()
  positionTOO=os.time()
end

if reaper.GetPlayState()~=0 then
  reaper.CSurf_OnStop()
end

firststartposition=reaper.GetCursorPosition()

function atexit()
  reaper.DeleteExtState("Ultraschall", "Ripple Insert Recording", false)
end
reaper.atexit(atexit)

main()

