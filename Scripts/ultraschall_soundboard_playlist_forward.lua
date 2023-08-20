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

-- starts play/pause of the sounds in the SoundBoard index by index forwards
-- track, which holds Soundboard, must be recarmed and recinput must be set to MIDI or VirtualMidiKeyboard

--reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", -1)
retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
if Position=="" then Position=-1 end
if tonumber(Position)>22 then
  reaper.StuffMIDIMessage(0, 144,72+23,0)
  reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", 24)
  return 
end



reaper.StuffMIDIMessage(0, 144,72+Position,0)
reaper.StuffMIDIMessage(0, 144,72+Position+1,0)
reaper.StuffMIDIMessage(0, 144,72+Position+1,1)

if tonumber(Position)+1>22 then Position=22 end
reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", Position+1)
