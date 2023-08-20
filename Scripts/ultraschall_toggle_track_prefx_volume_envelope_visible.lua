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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function PutActiveEnvelopesIntoLane_IfSetInPrefs()
  -- shows all visible envelopes in either the track-lane or in it's own envelope-lane, depending
  -- on the setting in preferences -> Envelope Display -> Show new envelopes in separate envelope lanes

  trackstring = ultraschall.CreateTrackString_SelectedTracks() -- ist ein track selektiert?
  if trackstring == "" then
    reaper.MB("No tracks selected", "No track-selection", 0)
    return
  end

  Envlanes=reaper.SNM_GetIntConfigVar("envlanes", "-9999")&1
  if Envlanes&1==1 then
    -- show envelopes under the tracks
    lanevisible=1
  else
    -- show envelopes within the arrange-view-tracklane
    lanevisible=0
  end

  for i=0, reaper.CountTracks(0)-1 do
    for a=0, reaper.CountTrackEnvelopes(reaper.GetTrack(0,i)) do
      TrackEnvelope = reaper.GetTrackEnvelope(reaper.GetTrack(0,i), a)
      visible, lane, unknown = ultraschall.GetEnvelopeState_Vis(TrackEnvelope)
      ultraschall.SetEnvelopeState_Vis(TrackEnvelope, visible, lanevisible, unknown)
    end
  end

end

reaper.PreventUIRefresh(1)
ultraschall.RunCommand(40408)
PutActiveEnvelopesIntoLane_IfSetInPrefs()
reaper.PreventUIRefresh(-1)
