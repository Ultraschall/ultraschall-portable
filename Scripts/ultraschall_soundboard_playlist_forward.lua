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

-- starts playing of the sounds in the SoundBoard index by index forwards
-- track, which holds Soundboard, must be recarmed and recinput must be set to MIDI or VirtualMidiKeyboard

  MIDIModifier=144

  -- read default-midi-input-channel from the ultraschall.ini
  -- and add, if necessary
  retval, midi_channel = reaper.BR_Win32_GetPrivateProfileString("Ultraschall_Soundboard", "Default_Midi_Listen_Channel", "0", reaper.GetResourcePath().."/ultraschall.ini")
  midi_channel=tonumber(midi_channel)-1
  if midi_channel<0 or midi_channel>15 then midi_channel=0 end
  MIDIModifier=MIDIModifier+midi_channel
  
  retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
  if Position=="" then Position=-1 end
  if tonumber(Position)>22 then
    reaper.StuffMIDIMessage(0, MIDIModifier,72+23,0)
    reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", 24)
    return 
  end



  reaper.StuffMIDIMessage(0, MIDIModifier,72+Position,0)
  reaper.StuffMIDIMessage(0, MIDIModifier,72+Position+1,0)
  reaper.StuffMIDIMessage(0, MIDIModifier,72+Position+1,1)

  if tonumber(Position)+1>22 then Position=22 end
  reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", Position+1)
