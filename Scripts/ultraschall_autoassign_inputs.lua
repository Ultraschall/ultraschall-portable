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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

numAudioIns = reaper.GetNumAudioInputs()
-- print("Inputs: "..numAudioIns)

numtracks = reaper.GetNumTracks()
-- print("Tracks: "..numtracks)

retval, actual_device_name = reaper.GetAudioDeviceInfo("IDENT_IN", "") -- gerade aktives device


function mapAllInputs ()

  local usedChannels = {}

  for i=0, numtracks-1 do
    track_object = reaper.GetTrack(0, i)
    input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
    -- print("Track: "..(i+1).." Input: "..input)

    if input >= 0 and input < 1024 then
        usedChannels[input] = true
    end
  end

  return usedChannels

end


function findFirstFreeInput ()

  numAudioIns = reaper.GetNumAudioInputs()

  for i = 0, numAudioIns-1 do

    if usedChannels[i] ~= true then
      return i
    end
  end

  return false

end

usedChannels = mapAllInputs()
inputChannels = {}

for i=0, numtracks-1 do
  track_object = reaper.GetTrack(0, i)
  input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
  -- print("Track: "..(i+1).." Input: "..input)

  if input >= 0 and input < 1024 then

    if inputChannels[input] == true then

      newInput = findFirstFreeInput()

      if newInput ~= false then
        reaper.SetMediaTrackInfo_Value(track_object, "I_RECINPUT", newInput)
        inputChannels[newInput] = true
        usedChannels[newInput] = true

      else

        print ("all Inputs in use")

      end

    else

      inputChannels[input] = true

    end

  end


end

-- track_object = reaper.GetTrack(0, 0)
-- input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
-- reaper.SetMediaTrackInfo_Value(track_object, "I_RECINPUT", 1)




-----------------------------

reaper.Undo_EndBlock("Autoassign inputs to tracks", -1) -- End of the undo block. Leave it at the bottom of your main function.