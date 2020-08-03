--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

-- Meo Mespotine 5th of February 2019

-- Inserts recording at EditCursorposition
-- will keep a gap until recording is stopped and close the gap after that
-- good for "Of, I forgot to add this or that to include in the middle of my recording"-usecases

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


function MoveUntilStop()
  -- moves items, track-envelope-points, regions and markers after current recording-position to be always at least
  -- 4 seconds away until recording stops
  if position<=reaper.GetPlayPosition()+4 and reaper.GetPlayState()&2==0 then
    retval = ultraschall.MoveMediaItemsAfter_By(position, 4, trackstring)
    retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, 4, false)
    retval = ultraschall.MoveRegionsBy(position, reaper.GetProjectLength(), 4, false)
    for i=0, reaper.CountTracks(0)-1 do
      ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, 4, reaper.GetTrack(0,i), false)
    end
    position=position+4
  end
  if reaper.GetPlayState()&4==4 then reaper.defer(MoveUntilStop) else
    -- if recording stops, move items, trackenvelope-points, regions and markers after current recording-position
    -- back to close the 4+ second gap
    stopposition=reaper.GetPlayPosition()
    marker_number = ultraschall.AddEditMarker(stopposition, -1, "")
    marker_number = ultraschall.AddEditMarker(firststartposition, -1, "")
    Aretval = ultraschall.MoveMediaItemsAfter_By(position, -(position-stopposition), trackstring)
    retval = ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+1, -(position-stopposition), false)
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
  for i=0, reaper.CountTracks(0)-1 do
    ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+1, 4, reaper.GetTrack(0,i), false)
  end

  position=position+4
  reaper.CSurf_OnRecord()
  MoveUntilStop()
  positionTOO=os.time()

  -- retval = ultraschall.EventManager_ResumeEvent(event_identifier)
end

if reaper.GetPlayState()~=0 then
  reaper.CSurf_OnStop()
end

reaper.SetExtState("ultraschall_PreviewRecording", "Dialog", "1", false) -- deaktiviere OverDub Soundcheck
firststartposition=reaper.GetCursorPosition()

main()
