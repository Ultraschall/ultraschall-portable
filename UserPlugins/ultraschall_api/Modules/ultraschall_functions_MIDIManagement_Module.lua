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
    <description>
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
    <description>
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
    <description>
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
    <description>
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
  <description>
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

function ultraschall.MidiEditor_SetFixOverlapState(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MidiEditor_SetFixOverlapState</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean newstate = ultraschall.MidiEditor_SetFixOverlapState(boolean state)</functioncall>
  <description>
    Sets the Automatically Correct Overlapping Notes-option, as set in the Midi-Editor -> Options-menu
    
    Note: For API-limitations, this will flash up shortly a new Midi-Editor, if none is opened yet!
    
    Returns nil in case of an error
  </description>
  <retvals>
    boolean newstate - the new state of the toggled option
  </retvals>
  <parameters>
    boolean state - true, set the option checked; false, set the option unchecked
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>midi editor, option, set, correct overlapping state</tags>
</US_DocBloc>
]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("MidiEditor_SetFixOverlapState", "state", "must be a boolean", -1) return end
  local retval, value = reaper.BR_Win32_GetPrivateProfileString("midiedit", "fixnoteoverlaps", "", reaper.get_ini_file())
  if state==nil then 
    if value=="1" then
      state=false
    else
      state=true
    end
  end
  local count, MIDIEditor, MediaItemArray
  if state==true then state=1 else state=0 end
  if tonumber(value)==state then return state==1 end
  reaper.PreventUIRefresh(1)

  local MidiEditor, count, MediaItemarray, Item, retval
  local MIDIEditor0=reaper.MIDIEditor_GetActive()
  if MIDIEditor0==nil then 
    count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(),  ultraschall.CreateTrackString_AllTracks(), true)

    for i=1, #MediaItemArray do
      reaper.SetMediaItemInfo_Value(MediaItemArray[i], "B_UISEL", 0)
    end
    Item=reaper.CreateNewMIDIItemInProj(reaper.GetTrack(0,0), reaper.GetProjectLength(), reaper.GetProjectLength()+1)
    reaper.SetMediaItemSelected(Item, true)
    reaper.Main_OnCommand(40153, 0) 
    MIDIEditor=reaper.MIDIEditor_GetActive()
    reaper.MIDIEditor_OnCommand(MIDIEditor, 40681)
  else
    MIDIEditor=reaper.MIDIEditor_GetActive() 
    reaper.MIDIEditor_OnCommand(MIDIEditor, 40681)
  end
  
  
  if MIDIEditor0==nil then 
    ultraschall.DeleteMediaItem(Item)
    for i=1, #MediaItemArray do
      reaper.SetMediaItemSelected(MediaItemArray[i], true)
    end
    reaper.JS_Window_Destroy(MIDIEditor)
  end
  reaper.UpdateArrange()

  reaper.PreventUIRefresh(-1)
  return state==1
end


function ultraschall.MidiEditor_GetFixOverlapState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MidiEditor_GetFixOverlapState</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean newstate = ultraschall.MidiEditor_GetFixOverlapState(optional boolean state)</functioncall>
  <description>
    Gets the Automatically Correct Overlapping Notes-option, as set in the Midi-Editor -> Options-menu
    
    Note: For API-limitations, this will flash up shortly a new Midi-Editor, if none is opened yet!
  </description>
  <retvals>
    boolean newstate - the new state of the toggled option
  </retvals>
  <parameters>
    optional boolean state - true, set the option checked; false, set the option unchecked; nil, toggle option
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
  <tags>midi editor, option, get, correct overlapping state</tags>
</US_DocBloc>
]]
  local retval, value = reaper.BR_Win32_GetPrivateProfileString("midiedit", "fixnoteoverlaps", "", reaper.get_ini_file())
  if value=="0" then return false else return true end
end

function ultraschall.PreviewMidiPitchInTrack(track, pitch)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>PreviewMidiPitchInTrack</slug>
    <requires>
      Ultraschall=5
      Reaper=5.965
      Lua=5.4
    </requires>
    <functioncall>ultraschall.PreviewMidiPitchInTrack(integer track, integer pitch)</functioncall>
    <description>
      Sends a MIDI-pitch to a specific track with a specific velocity.
      
      The track must be rec-armed!
      
      returns false in case of an error
    </description>
    <parameters>
      integer track - the number of the track, in which you want to preview the midi-note
      integer pitch - the pitch to be played; 0-127
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, note, preview, pitch</tags>
  </US_DocBloc>
  ]]  
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "track", "no such track", -2) return false end
  if math.type(pitch)~="integer" then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "pitch", "must be an integer", -3) return false end
  if pitch<0 or pitch>127 then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "pitch", "must be between 0 and 127", -5) return false end
  
  local old_recarm=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECARM")
  if old_recarm==0 then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "velocity", "track must be armed for this function to work", -6) return false end

  local old_input=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECINPUT")
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", 6080)
  ultraschall.MIDI_SendMidiPitch(1, pitch, velocity, 0)
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", old_input)
  return true
end

--ultraschall.PreviewMidiPitchInTrack(1, 12, 1)

function ultraschall.PreviewMidiPCInTrack(track, pc, velocity)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>PreviewMidiPCInTrack</slug>
    <requires>
      Ultraschall=5
      Reaper=5.965
      Lua=5.4
    </requires>
    <functioncall>ultraschall.PreviewMidiPCInTrack(integer track, integer pc, integer Velocity)</functioncall>
    <description>
      Sends a MIDI-pc to a specific track with a specific velocity.
      
      The track must be rec-armed!
      
      returns false in case of an error
    </description>
    <parameters>
      integer track - the number of the track, in which you want to preview the midi-note
      integer pc - the pc to be played; 0-127
      integer velocity - the velocity of the note; 0-255
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, note, preview, pc</tags>
  </US_DocBloc>
  ]]  
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "track", "no such track", -2) return false end
  if math.type(pc)~="integer" then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "pc", "must be an integer", -3) return false end
  if math.type(velocity)~="integer" then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "velocity", "must be an integer", -4) return false end
  if pc<0 or pc>127 then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "pc", "must be between 0 and 127", -5) return false end
  if velocity<0 or velocity>255 then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "velocity", "must be between 0 and 255", -6) return false end
  
  local old_recarm=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECARM")
  if old_recarm==0 then ultraschall.AddErrorMessage("PreviewMidiPCInTrack", "velocity", "track must be armed for this function to work", -6) return false end

  local old_input=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECINPUT")
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", 6080)
  ultraschall.MIDI_SendMidiPC(1, pc, velocity, 0)
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", old_input)
  return true
end

--ultraschall.PreviewMidiPCInTrack(1, 12, 1)

function ultraschall.PreviewMidiCCInTrack(track, cc, velocity)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>PreviewMidiCCInTrack</slug>
    <requires>
      Ultraschall=5
      Reaper=5.965
      Lua=5.4
    </requires>
    <functioncall>ultraschall.PreviewMidiCCInTrack(integer track, integer cc, integer Velocity)</functioncall>
    <description>
      Sends a MIDI-cc to a specific track with a specific velocity.
      
      The track must be rec-armed!
      
      returns false in case of an error
    </description>
    <parameters>
      integer track - the number of the track, in which you want to preview the midi-note
      integer cc - the cc to be played; 0-127
      integer velocity - the velocity of the note; 0-255
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, note, preview, cc</tags>
  </US_DocBloc>
  ]]  
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "track", "no such track", -2) return false end
  if math.type(cc)~="integer" then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "cc", "must be an integer", -3) return false end
  if math.type(velocity)~="integer" then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "velocity", "must be an integer", -4) return false end
  if cc<0 or cc>127 then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "cc", "must be between 0 and 127", -5) return false end
  if velocity<0 or velocity>255 then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "velocity", "must be between 0 and 255", -6) return false end
  
  local old_recarm=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECARM")
  if old_recarm==0 then ultraschall.AddErrorMessage("PreviewMidiCCInTrack", "velocity", "track must be armed for this function to work", -6) return false end

  local old_input=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECINPUT")
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", 6080)
  ultraschall.MIDI_SendMidiCC(1, cc, velocity, 0)
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", old_input)
  return true
end

--ultraschall.PreviewMidiCCInTrack(1, 12, 1)

function ultraschall.PreviewMidiNoteInTrack(track, note, velocity)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>PreviewMidiNoteInTrack</slug>
    <requires>
      Ultraschall=5
      Reaper=5.965
      Lua=5.4
    </requires>
    <functioncall>ultraschall.PreviewMidiNoteInTrack(integer track, integer note, integer Velocity)</functioncall>
    <description>
      Sends a MIDI-note to a specific track with a specific velocity.
      
      The track must be rec-armed!
      
      returns false in case of an error
    </description>
    <parameters>
      integer track - the number of the track, in which you want to preview the midi-note
      integer note - the note to be played; 0-127
      integer velocity - the velocity of the note; 0-255
    </parameters>
    <chapter_context>
      MIDI Management
      Notes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MIDIManagement_Module.lua</source_document>
    <tags>midi management, send, note, preview</tags>
  </US_DocBloc>
  ]]  
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "track", "no such track", -2) return false end
  if math.type(note)~="integer" then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "note", "must be an integer", -3) return false end
  if math.type(velocity)~="integer" then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "velocity", "must be an integer", -4) return false end
  if note<0 or note>127 then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "note", "must be between 0 and 127", -5) return false end
  if velocity<0 or velocity>255 then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "velocity", "must be between 0 and 255", -6) return false end
  
  local old_recarm=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECARM")
  if old_recarm==0 then ultraschall.AddErrorMessage("PreviewMidiNoteInTrack", "velocity", "track must be armed for this function to work", -6) return false end

  local old_input=reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, track-1), "I_RECINPUT")
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", 6080)
  ultraschall.MIDI_SendMidiNote(1, note, velocity, 0)
  reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0), "I_RECINPUT", old_input)
  return true
end