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
]]

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---     MIDI Management Module    ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "MIDIManagement-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end 
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end


function ultraschall.ZoomVertical_MidiEditor(zoomamt, HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ZoomVertical_MidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ZoomVertical_MidiEditor(integer zoomamt, optional HWND midieditor_hwnd)</functioncall>
  <description>
    Zooms within the Midi-Editor vertically.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if zooming was successful; false, if not
  </retvals>
  <parameters>
    integer zoomamt - the zoom-factor; positive values, zoom in; negative values, zoom out
    optional HWND midieditor_hwnd - the HWND of the MIDI-Editor, in which you want to zoom; nil, uses active MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>midimanagement, zoom, midieditor, vertically</tags>
</US_DocBloc>
]]
  -- check parameters and prepare correct zoom-actioncommandid
  if HWND==nil then HWND=reaper.MIDIEditor_GetActive() end
  if math.type(zoomamt)~="integer" then ultraschall.AddErrorMessage("ZoomVertical_MidiEditor","zoomamt", "Must be an integer!", -1) return false end
  if zoomamt>0 then actioncommandid=40111 -- zoom in
  elseif zoomamt<0 then actioncommandid=40112 -- zoom out
  else actioncommandid=65535 -- do nothing, when 0 is given as zoom-value
  end
  
  -- Now, do the zooming
  if zoomamt<0 then zoomamt=zoomamt*-1 end
  for i=1, zoomamt do
    reaper.MIDIEditor_OnCommand(HWND, actioncommandid)
  end
end

--ultraschall.ZoomVertical_MidiEditor(HWND, 5)

function ultraschall.ZoomHorizontal_MidiEditor(zoomamt, HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ZoomHorizontal_MidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ZoomHorizontal_MidiEditor(integer zoomamt, optional HWND midieditor_hwnd)</functioncall>
  <description>
    Zooms within the Midi-Editor horizontally.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if zooming was successful; false, if not
  </retvals>
  <parameters>
    integer zoomamt - the zoom-factor; positive values, zoom in; negative values, zoom out
    optional HWND midieditor_hwnd - the HWND of the MIDI-Editor, in which you want to zoom; nil, uses active MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>midimanagement, zoom, midieditor, horizontally</tags>
</US_DocBloc>
]]
  -- check parameters and prepare correct zoom-actioncommandid
  if HWND==nil then HWND=reaper.MIDIEditor_GetActive() end
  if math.type(zoomamt)~="integer" then ultraschall.AddErrorMessage("ZoomHorizontal_MidiEditor","zoomamt", "Must be an integer!", -1) return false end
  if zoomamt>0 then actioncommandid=1012 -- zoomin
  elseif zoomamt<0 then actioncommandid=1011 -- zoomout
  else actioncommandid=65535 -- nothing, when 0 is given
  end
  
  -- do the zooming
  if zoomamt<0 then zoomamt=zoomamt*-1 end -- 
  for i=1, zoomamt do
    reaper.MIDIEditor_OnCommand(HWND, actioncommandid)
  end
  return true
end

--ultraschall.ZoomHorizontal_MidiEditor(HWND, 5)


function ultraschall.OpenItemInMidiEditor(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OpenItemInMidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.OpenItemInMidiEditor(MediaItem MediaItem)</functioncall>
  <description>
    opens a given MediaItem in the MIDI-Editor
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if opening was successful; false, if not
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem to be opened in the MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>midimanagement, open, item, midieditor</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("OpenItemInMidiEditor","MediaItem", "Must be a MediaItem!", -1) return false end
  ultraschall.ApplyActionToMediaItem(MediaItem, 40153, 1, false)
  return true
end

--MediaItem=reaper.GetMediaItem(0,0)
--ultraschall.OpenItemInMidiEditor(MediaItem)

function ultraschall.MIDI_SendMidiNote(Channel, Note, Velocity, Mode)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>MIDI_SendMidiNote</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.MIDI_SendMidiNote(integer Channel, integer Note, integer Velocity, optional integer Mode)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Sends a MIDI-note to a specific channel with a specific velocity.
    </description>
    <parameters>
      integer Channel - the channel, to which the Midi-note shall be sent; 1-16
      integer Note - the note to be played; 0-127
      integer Velocity - the velocity of the note; 0-255
      optional integer Mode - 0 for VKB
                            - 1 for control (actions map etc)
                            - 2 for VKB-on-current-channel
                            - 16 for external MIDI device 0, 17 for external MIDI device 1, etc
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, note</tags>
  </US_DocBloc>
  ]]  
  if math.type(Channel)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Channel", "must be an integer", -1) return nil end
  if Channel>16 or Channel<1 then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Channel", "must be between 1 and 16", -2) return  end
  
  if math.type(Note)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Note", "must be an integer", -3) return nil end
  if Note>127 or Note<0 then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Note", "must be between 0 and 127", -4) return  end
  
  if math.type(Velocity)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Velocity", "must be an integer", -5) return nil end
  if Velocity>255 or Velocity<0 then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Velocity", "must be between 0 and 255", -6) return  end
  
  if Mode~=nil and math.type(Mode)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiNote", "Mode", "must be an integer", -7) return nil end  
  
  local MIDIModifier=144+Channel-1
  if Mode==nil then Mode=0 end
  
  reaper.StuffMIDIMessage(Mode, MIDIModifier, Note, Velocity)
end

function ultraschall.MIDI_SendMidiCC(Channel, Note, Velocity, Mode)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>MIDI_SendMidiCC</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.MIDI_SendMidiCC(integer Channel, integer Note, integer Velocity, optional integer Mode)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Sends a MIDI-CC-message to a specific channel with a specific velocity.
    </description>
    <parameters>
      integer Channel - the channel, to which the Midi-note shall be sent; 1-16
      integer Note - the note to be played; 0-127
      integer Velocity - the velocity of the note; 0-255
      optional integer Mode - 0 for VKB
                            - 1 for control (actions map etc)
                            - 2 for VKB-on-current-channel
                            - 16 for external MIDI device 0, 17 for external MIDI device 1, etc
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, cc</tags>
  </US_DocBloc>
  ]]  
  if math.type(Channel)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Channel", "must be an integer", -1) return nil end
  if Channel>16 or Channel<1 then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Channel", "must be between 1 and 16", -2) return  end
  
  if math.type(Note)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Note", "must be an integer", -3) return nil end
  if Note>127 or Note<0 then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Note", "must be between 0 and 127", -4) return  end
  
  if math.type(Velocity)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Velocity", "must be an integer", -5) return nil end
  if Velocity>255 or Velocity<0 then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Velocity", "must be between 0 and 255", -6) return  end
  
  if Mode~=nil and math.type(Mode)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiCC", "Mode", "must be an integer", -7) return nil end  
  
  local MIDIModifier=176+Channel-1
  if Mode==nil then Mode=0 end
  
  reaper.StuffMIDIMessage(Mode, MIDIModifier, Note, Velocity)
end

function ultraschall.MIDI_SendMidiPC(Channel, Note, Velocity, Mode)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>MIDI_SendMidiPC</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.MIDI_SendMidiPC(integer Channel, integer Note, integer Velocity, optional integer Mode)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Sends a MIDI-PC-message to a specific channel with a specific velocity.
    </description>
    <parameters>
      integer Channel - the channel, to which the Midi-note shall be sent; 1-16
      integer Note - the note to be played; 0-127
      integer Velocity - the velocity of the note; 0-255
      optional integer Mode - 0 for VKB
                            - 1 for control (actions map etc)
                            - 2 for VKB-on-current-channel
                            - 16 for external MIDI device 0, 17 for external MIDI device 1, etc
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, pc</tags>
  </US_DocBloc>
  ]]  
  if math.type(Channel)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Channel", "must be an integer", -1) return nil end
  if Channel>16 or Channel<1 then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Channel", "must be between 1 and 16", -2) return  end
  
  if math.type(Note)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Note", "must be an integer", -3) return nil end
  if Note>127 or Note<0 then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Note", "must be between 0 and 127", -4) return  end
  
  if math.type(Velocity)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Velocity", "must be an integer", -5) return nil end
  if Velocity>255 or Velocity<0 then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Velocity", "must be between 0 and 255", -6) return  end
  
  if Mode~=nil and math.type(Mode)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Mode", "must be an integer", -7) return nil end  
  
  local MIDIModifier=192+Channel-1
  if Mode==nil then Mode=0 end
  
  reaper.StuffMIDIMessage(Mode, MIDIModifier, Note, Velocity)
end

function ultraschall.MIDI_SendMidiPitch(Channel, Pitch, Mode)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>MIDI_SendMidiPitch</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.MIDI_SendMidiPitch(integer Channel, integer Pitch, optional integer Mode)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Sends a MIDI-Pitch-message to a specific channel with a specific velocity.
    </description>
    <parameters>
      integer Channel - the channel, to which the Midi-pitch shall be sent; 1-16
      integer Pitch - the pitchbend of the note; 0-127
      optional integer Mode - 0 for VKB
                            - 1 for control (actions map etc)
                            - 2 for VKB-on-current-channel
                            - 16 for external MIDI device 0, 17 for external MIDI device 1, etc
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, pitch, bend</tags>
  </US_DocBloc>
  ]]  
  if math.type(Channel)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Channel", "must be an integer", -1) return nil end
  if Channel>16 or Channel<1 then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Channel", "must be between 1 and 16", -2) return  end
  
  if math.type(Pitch)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Pitch", "must be an integer", -5) return nil end
  if Pitch>127 or Pitch<0 then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Pitch", "must be between 0 and 127", -6) return  end
  
  if Mode~=nil and math.type(Mode)~="integer" then ultraschall.AddErrorMessage("MIDI_SendMidiPC", "Mode", "must be an integer", -7) return nil end  
  
  local MIDIModifier=224+Channel-1
  if Mode==nil then Mode=0 end
  
  reaper.StuffMIDIMessage(Mode, MIDIModifier, 0, Pitch)
end

function ultraschall.QueryMIDIMessageNameByID(modifier, key)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>QueryMIDIMessageNameByID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string midimessage_name = ultraschall.QueryMIDIMessageNameByID(integer modifier, integer key)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the name of the MIDI-message, as used by Reaper's function StuffMIDIMessage.
    
    Just pass over the first and second value. The last one is always velocity, which is ~=0 for it to be accepted.
    However, some codes don't have a name associated. In that case, this function returns "-1"
    
    Only returns the names for mode 1 and english on Windows!
    
    returns nil in case of an error
  </description>
  <retvals>
    string midimessage_name - the actual name of the midi-message, like "A" or "F1" or "Ctrl+Alt+Shift+Win+PgUp".
  </retvals>
  <parameters>
    integer modifier - the modifier value, which is the second parameter of StuffMIDIMessage
    integer key - the key value, which is the third parameter of StuffMIDIMessage
  </parameters>
  <chapter_context>
    MIDI Management
    Notes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>configurations management, key, shortcut, name, query, get</tags>
</US_DocBloc>
]]
  if math.type(modifier)~="integer" then ultraschall.AddErrorMessage("QueryMIDIMessageNameByID", "modifier", "must be an integer", -1) return nil end
  if math.type(key)~="integer" then ultraschall.AddErrorMessage("QueryMIDIMessageNameByID", "key", "must be an integer", -2) return nil end
  local length_of_value, value = ultraschall.GetIniFileValue("All_StuffMIDIMessage_Messages_english_windows", modifier.."_"..key.."_1", -1, ultraschall.Api_Path.."/IniFiles/StuffMidiMessage-AllMessages_Englisch_Windows.ini")
  return value
end
