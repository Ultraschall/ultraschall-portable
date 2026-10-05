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
--]]

--[[
Set the following extstates with WebRC and run the action _Ultraschall_StreamDeckHelperAction

sec:"StreamDeck AudioPlay", key:"filename"    - the filename of the file to play
sec:"StreamDeck AudioPlay", key:"volumedB"    - the dB of the audio, -144 (silence) to 0(regular volume) and higher(boost volume)
sec:"StreamDeck AudioPlay", key:"markertitle" - this adds a chaptermarker, set it to a markertitle; ""=no marker

--]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

filename=reaper.GetExtState("StreamDeck AudioPlay", "filename")
if reaper.file_exists(filename)==false then reaper.MB("Audiofile does not exist", "Ooops...", 0) return end
volumedB=tonumber(reaper.GetExtState("StreamDeck AudioPlay", "volumedB"))
if volumedB==nil then volumedB=0 end
markertitle=reaper.GetExtState("StreamDeck AudioPlay", "markertitle")

for i=0, reaper.CountTracks(0) do
  if ultraschall.IsTrackSoundboard(i)==true then soundboard_track=i-1 break end
end
if soundboard_track==nil then reaper.MB("No Soudboard Track", "No Soundboard track", 0) return end

list=reaper.GetExtState("StreamDeck AudioPlay", "filenamePlayingList")
if list:match(ultraschall.EscapeMagicCharacters_String(filename))~=nil then
  return
else
  reaper.SetExtState("StreamDeck AudioPlay", "filenamePlayingList", list..filename.."\n", false)
end

--print2("A")

reaper.SetExtState("StreamDeck AudioPlay", "filename", "", false)
reaper.SetExtState("StreamDeck AudioPlay", "volumedB", "", false)
reaper.SetExtState("StreamDeck AudioPlay", "markertitle", "", false)

-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
--reaper.set_action_options(1)


if markertitle~="" then
  if reaper.GetPlayState()~=0 then
    position=reaper.GetPlayPosition()
  else
    position=reaper.GetCursorPosition()
  end
  marker_number, guid, normal_marker_idx = ultraschall.AddNormalMarker(position, -1, markertitle)
end

PCM_source=reaper.PCM_Source_CreateFromFile(filename)
CF_Preview=reaper.CF_CreatePreview(PCM_source)
reaper.CF_Preview_SetOutputTrack(CF_Preview, 0, reaper.GetTrack(0, soundboard_track))
retval, new_value = reaper.CF_Preview_SetValue(CF_Preview, "D_VOLUME", ultraschall.DB2MKVOL(volumedB))
reaper.CF_Preview_Play(CF_Preview)


function atexit()
  reaper.CF_Preview_Stop(CF_Preview) 
  reaper.PCM_Source_Destroy(PCM_source)
  reaper.SetExtState("StreamDeck AudioPlay", "filename", "", false)
  reaper.SetExtState("StreamDeck AudioPlay", "volumedB", "", false)
  reaper.SetExtState("StreamDeck AudioPlay", "markertitle", "", false)
  list=reaper.GetExtState("StreamDeck AudioPlay", "filenamePlayingList")
  list=string.gsub(list, ultraschall.EscapeMagicCharacters_String(filename), "")
  reaper.SetExtState("StreamDeck AudioPlay", "filenamePlayingList", list, false)
end
reaper.atexit(atexit)


function main()
  retval, pos = reaper.CF_Preview_GetValue(CF_Preview, "D_POSITION")
  retval, len = reaper.CF_Preview_GetValue(CF_Preview, "D_LENGTH")
  filename2=reaper.GetExtState("StreamDeck AudioPlay", "filename")
  if pos<=len and filename2~=filename then
    reaper.defer(main)
  end
end
main()
