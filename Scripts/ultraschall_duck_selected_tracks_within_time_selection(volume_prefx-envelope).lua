--[[
################################################################################
#
# Copyright (c) Ultraschall (http://ultraschall.fm)
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

-- ultraschall-manual ducking - Meo-Ada Mespotine 7th of November 2022
-- lowers the volume of selected tracks within time-selection by adding envelope-points into the volume(pre fx)-envelope
-- Good for ducking underlying music under spoken words.

-- following settings in ultraschall.ini -> [ultraschall_manual_track_ducking]
-- FadeInLength -- fade-in length in seconds
-- FadeOutLength -- fade-out length in seconds
-- LowerBydB - the dB to lower by(negative values will make volume louder instead of more silent)
-- Tension - the tension of the envelope-shape(0-1 are useful values)
-- Shape - the shape of the envelope-points(0-5)
FadeInLength=tonumber(ultraschall.GetUSExternalState("ultraschall_manual_track_ducking", "FadeInLength", "ultraschall.ini"))
if FadeInLength==nil then FadeInLength=0.5 end

FadeOutLength=tonumber(ultraschall.GetUSExternalState("ultraschall_manual_track_ducking", "FadeOutLength", "ultraschall.ini"))
if FadeOutLength==nil then FadeOutLength=0.5 end

LowerBydB=tonumber(ultraschall.GetUSExternalState("ultraschall_manual_track_ducking", "LowerBydB", "ultraschall.ini"))
if LowerBydB==nil then LowerBydB=60 end

Tension=tonumber(ultraschall.GetUSExternalState("ultraschall_manual_track_ducking", "Tension", "ultraschall.ini"))
if Tension==nil then Tension=0 end

Shape=tonumber(ultraschall.GetUSExternalState("ultraschall_manual_track_ducking", "Shape", "ultraschall.ini"))
if Shape==nil then Shape=0 end

--if lol==nil then return end
start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if FadeInLength+FadeOutLength>end_time-start_time then
  print2("Time-Selection must be at least "..FadeInLength+FadeOutLength.." seconds long for the fade in+out to happen(you can change this in the settings)")
  return
end

if reaper.CountSelectedTracks(0)==0 then print2("No track selected") return end

Selected_Tracks={}
for i=0, reaper.CountSelectedTracks(0) do
  Selected_Tracks[i]=reaper.GetSelectedTrack(0, i)
end

for i=0, #Selected_Tracks do
  track_nr=reaper.GetMediaTrackInfo_Value(Selected_Tracks[i], "IP_TRACKNUMBER")
  retval = ultraschall.ActivateTrackPreFXVolumeEnv(math.tointeger(track_nr))

  local A=reaper.GetTrackEnvelopeByName(Selected_Tracks[i], "Volume (Pre-FX)")

  -- delete already existing envelope-points
  reaper.DeleteEnvelopePointRange(A, start_time, end_time+0.0000000001)
  
  -- insert start/end-envelope-points
  local _, B = reaper.Envelope_Evaluate(A, start_time, 48000, 100)
  reaper.InsertEnvelopePoint(A, start_time, B, Shape, Tension, false, true)
  local _, B2=reaper.Envelope_Evaluate(A, end_time, 48000, 10)
  reaper.InsertEnvelopePoint(A, end_time, B, 0, 0, false, true)
  
  
  -- insert fadein/out-envelope points
  local B=reaper.SLIDER2DB(B)
  local C=reaper.DB2SLIDER(B-LowerBydB)
  reaper.InsertEnvelopePoint(A, start_time+FadeInLength, C, 0, 0, false, true)
  reaper.InsertEnvelopePoint(A, end_time-FadeInLength, C, Shape, Tension, false, true)
  reaper.Envelope_SortPoints(A)
end
