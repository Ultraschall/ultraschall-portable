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

-- Ultraschall-API demoscript by Meo Mespotine 29.10.2018
-- 
-- Change length of MediaItems by a value, in selected Tracks and Time-Selection
-- MediaItems must be fully within the time-selection, at least in this demo, though you
-- can choose to use MediaItems only partially within time-selection as well
-- see functions-reference-docs for more details on GetAllMediaItemsBetween()

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

selection_start, selection_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, 0)
trackstring = ultraschall.CreateTrackString_SelectedTracks()
count, MediaItemArray = ultraschall.GetAllMediaItemsBetween(selection_start, selection_end, trackstring, true)

if count>0 then
  retval, deltalength = reaper.GetUserInputs("Alter by length(in seconds):", 1, "", "")
  if type(tonumber(deltalength))=="number" then
    retval = ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(MediaItemArray, tonumber(deltalength))
  else
    reaper.MB("Must be a number", "Number needed", 0)
  end
end
