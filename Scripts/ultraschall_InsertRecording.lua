--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
]]

reaper.SetExtState("Ultraschall", "Ripple Insert Recording", "", false)

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
    reaper.SetExtState("Ultraschall_RippleInsertRecording", "position", position, false)
    reaper.SetExtState("Ultraschall_RippleInsertRecording", "stopposition", stopposition, false)
    --[[
    marker_number = ultraschall.AddEditMarker(stopposition, -1, "")
    marker_number = ultraschall.AddEditMarker(firststartposition, -1, "")
    --]]
    Aretval = ultraschall.MoveMediaItemsAfter_By(position, -(position-stopposition)+0.001, trackstring)
    retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, -(position-stopposition)+0.001, false)
    retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength()+1, -(position-stopposition)+0.001, false)
    for i=0, reaper.CountTracks(0)-1 do
      ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, -(position-stopposition), reaper.GetTrack(0,i), false)
    end
    --]]
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



function atexit()
  ultraschall.RunCommand("_Ultraschall_CleanUp_RippleInsertRecording")
  reaper.DeleteExtState("Ultraschall", "Ripple Insert Recording", false)
end
reaper.atexit(atexit)

reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "1", false) -- deaktiviere OverDub Soundcheck
firststartposition=reaper.GetCursorPosition()
reaper.SetExtState("Ultraschall_RippleInsertRecording", "firststartposition", firststartposition, false)

main()

