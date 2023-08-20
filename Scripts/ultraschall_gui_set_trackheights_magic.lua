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

-----------------
-- Functions
-----------------


function getAllTracksHeight ()

  local height = 0

  for i=0, numberOfTracks-1 do
    local MediaTrack = reaper.GetTrack(0, i)
    local retval = reaper.GetMediaTrackInfo_Value(MediaTrack, "I_WNDH")
    -- print ("Höhe: "..retval)
    height = height + retval
  end
  return height
end

function verticalZoom (maxheight)

  local allTracksHeight = getAllTracksHeight()
  local offset = 35
  if numberOfTracks == 1 then offset = maxheight * 0.6 end
  if numberOfTracks == 2 then offset = maxheight * 0.4 end
  -- if numberOfTracks == 3 then offset = maxheight * 0.3 end

  if allTracksHeight < maxheight - offset then -- muss Vergößert werden
    while allTracksHeight < maxheight - offset do
      reaper.CSurf_OnZoom(0, 1)
      allTracksHeight = getAllTracksHeight()
    end
  elseif allTracksHeight > maxheight - offset then -- muss Verkleinert werden
    while allTracksHeight > maxheight - offset do
      reaper.CSurf_OnZoom(0, -1)
      allTracksHeight = getAllTracksHeight()
    end
  end
end


function countAllEnvelopes ()

  local count = 0

  for i=0, numberOfTracks-1 do

    local MediaTrack = reaper.GetTrack(0, i)
    local numberOfEnvelopes = reaper.CountTrackEnvelopes(MediaTrack)

    for j = 0, numberOfEnvelopes-1 do
      TrackEnvelope = reaper.GetTrackEnvelope(MediaTrack, j)
      BR_Envelope = reaper.BR_EnvAlloc(TrackEnvelope, false)

      active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, envType, faderScaling, automationItemsOptions = reaper.BR_EnvGetProperties(BR_Envelope)

      if visible == true then
        count = count + 1
      end
    end

  end

  return count
end





-------------------
-- End of functions
-------------------


-------------------
-- Init
-------------------

numberOfTracks = reaper.CountTracks(0)
numberOfEnvelopes = countAllEnvelopes()
lastNumberOfTracks = reaper.GetExtState("ultraschall_gui", "numbertracks") or 0
lastNumberOfEnvelopes = reaper.GetExtState("ultraschall_gui", "numberenvelopes") or 0

-- print (numberOfEnvelopes.."-"..lastNumberOfEnvelopes)
-- print (numberOfTracks.."-"..lastNumberOfTracks)

if numberOfTracks > 0 and (lastNumberOfEnvelopes ~= tostring(numberOfEnvelopes) or lastNumberOfTracks ~= tostring(numberOfTracks)) then

  -- print (lastHeightOfTracks.."-"..heightOfTracks)

  local _, left, top, right, bottom = reaper.JS_Window_GetClientRect( reaper.JS_Window_FindChildByID( reaper.GetMainHwnd(), 1000) )
  ArrangeViewHeight = math.abs(bottom - top)

  -------------------
  -- Main
  -------------------

  verticalZoom (ArrangeViewHeight)
  retval = ultraschall.ApplyActionToTrack("1,0", 40913) -- verschiebe den Arrangeview hoch zum ersten Track
  reaper.SetExtState("ultraschall_gui", "numbertracks", numberOfTracks, true)
  reaper.SetExtState("ultraschall_gui", "numberenvelopes", numberOfEnvelopes, true)
  lastNumberOfTracks = numberOfTracks
  lastNumberOfEnvelopes = numberOfEnvelopes

end

--print (ArrangeViewHeight)
--print ("Summe: "..allTracksHeight)
-- retval = ultraschall.SetVerticalZoom(13) -- setze auf einen absoluten Zoom-Wert
