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

-- actual_device_name = "zoom H3"

if string.find(actual_device_name, "H6", 1) or string.find(actual_device_name, "H5", 1) or string.find(actual_device_name, "H4", 1) then
  offset = 2
else
  offset = 0
end


function mapAllInputs ()

  local usedChannels = {}

  for i=0, numtracks-1 do
    track_object = reaper.GetTrack(0, i)
    input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
    -- print("Track: "..(i+1).." Input: "..input)

    if input >= 0 and input < 1024 then
        -- input = input + offset
        usedChannels[input] = true
    end
  end

  return usedChannels

end


function findFirstFreeInput ()

  numAudioIns = reaper.GetNumAudioInputs()

  for i = 0 + offset, numAudioIns-1 do

    if usedChannels[i] ~= true then
      return i
    end
  end

  return false

end

usedChannels = mapAllInputs()
inputChannels = {}
message = ""

for i=0, numtracks-1 do
  track_object = reaper.GetTrack(0, i)
  input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
  -- print("Track: "..(i+1).." Input: "..input)

  if input >= 0 and input < 1024 then

    -- input = input + offset
    if inputChannels[input] == true or (offset == 2 and input < 2) then -- der Input Kanal ist schon einmal belegt, oder es ist ein Zoom Gerät und Kanal 1/2 ist belegt

      newInput = findFirstFreeInput() -- suche den ersten noch freien Input-Kanal (bei Zoom H4/5/&: > Kanal 2)

      if newInput ~= false then
        reaper.SetMediaTrackInfo_Value(track_object, "I_RECINPUT", newInput)
        inputChannels[newInput] = true
        usedChannels[newInput] = true

        txtInput = tostring(tonumber(newInput)+1)

        message = message .. "Track "..tostring(i+1).." was assigned to Input: "..txtInput.."\n"

      else

        Message = "!;Audio Device;".."The number of tracks exceeds the number ob inputs of your audio interface."
        reaper.SetExtState("ultraschall_messages", "message_0", Message, false)
        reaper.SetExtState("ultraschall_messages", "message_count", "1", false)

        -- print ("all Inputs in use")

      end

    else

      inputChannels[input] = true

    end

  end

end

if message ~= "" then

  message = "The following tracks were assigned to new inputs:\n\n" .. message
  title = "Auto-Assigning Inputs Succesfull"
  result = reaper.ShowMessageBox( message, title, 0 )

end


-- track_object = reaper.GetTrack(0, 0)
-- input = reaper.GetMediaTrackInfo_Value(track_object, "I_RECINPUT")
-- reaper.SetMediaTrackInfo_Value(track_object, "I_RECINPUT", 1)




-----------------------------

reaper.Undo_EndBlock("Autoassign inputs to tracks", -1) -- End of the undo block. Leave it at the bottom of your main function.