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
---     Track: Routing Module     ---
-------------------------------------

function ultraschall.GetTrackHWOut(tracknumber, idx, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackHWOut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer outputchannel, integer post_pre_fader, number volume, number pan, integer mute, integer phase, integer source, number pan_law, integer automationmode = ultraschall.GetTrackHWOut(integer tracknumber, integer idx, optional string TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1">
    Returns the settings of the HWOUT-HW-destination, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, which you can choose with idx.
    
    It's the entry HWOUT
    
    see see [MKVOL2DB](#MKVOL2DB) to convert the volume-returnvalue into a dB-value
    
    returns -1 in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose HWOut you want, 0 for Master Track
    integer idx - the id-number of the HWOut, beginning with 1 for the first HWOut-Settings
    optional string TrackStateChunk - a TrackStateChunk, whose HWOUT-entries you want to get
  </parameters>
  <retvals>
    integer outputchannel - outputchannel, with 1024+x the individual hw-outputchannels, 0,2,4,etc stereo output channels
    integer post_pre_fader - 0-post-fader(post pan), 1-preFX, 3-pre-fader(Post-FX), as set in the Destination "Controls for Track"-dialogue
    number volume - volume, as set in the Destination "Controls for Track"-dialogue
    number pan - pan, as set in the Destination "Controls for Track"-dialogue
    integer mute - mute, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer phase - Phase, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer source - source, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - None
    -                                     0 - Stereo Source 1/2
    -                                     4 - Stereo Source 5/6
    -                                    12 - New Channels On Sending Track Stereo Source Channel 13/14
    -                                    1024 - Mono Source 1
    -                                    1029 - Mono Source 6
    -                                    1030 - New Channels On Sending Track Mono Source Channel 7
    -                                    1032 - New Channels On Sending Track Mono Source Channel 9
    -                                    2048 - MultiChannel 4 Channels 1-4
    -                                    2050 - Multichannel 4 Channels 3-6
    -                                    3072 - Multichannel 6 Channels 1-6
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer automationmode - automation mode, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - Track Automation Mode
    -                                     0 - Trim/Read
    -                                     1 - Read
    -                                     2 - Touch
    -                                     3 - Write
    -                                     4 - Latch
    -                                     5 - Latch Preview
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, hwout, routing, phase, source, mute, pan, volume, post, pre, fader, channel, automation, pan-law, trackstatechunk</tags>
</US_DocBloc>
]]
-- HWOUT %d %d %.14f %.14f %d %d %d %.14f:U %d
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackHWOut", "tracknumber", "must be an integer", -1) return -1 end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackHWOut", "tracknumber", "no such track", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetTrackHWOut", "idx", "must be an integer", -3) return -1 end

  if tracknumber~=-1 then 
    local tr
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,tracknumber-1) end
    
    if reaper.GetTrackNumSends(tr, 1)<idx then ultraschall.AddErrorMessage("GetTrackHWOut", "idx", "no such index available", -5) return -1 end
    local sendidx=idx
    return math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "I_DSTCHAN")), -- D1
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "I_SENDMODE")), -- D2
           reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "D_VOL"),  -- D3
           reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "D_PAN"),  -- D4
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "B_MUTE")), -- D5
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "B_PHASE")),-- D6
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "I_SRCCHAN")), -- D7
           reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "D_PANLAW"), -- D8
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, 1, sendidx-1, "I_AUTOMODE")) -- D9
  end
  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackHWOut", "TrackStateChunk", "must be a valid TrackStateChunk", -6) return -1 end
  if ultraschall.CountTrackHWOuts(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("GetTrackHWOut", "idx", "no such entry", -7) return -1 end
  
  local count=1
  
  for k in string.gmatch(TrackStateChunk, "HWOUT.-\n") do
    if count==idx then 
      local count2, individual_values = ultraschall.CSV2IndividualLinesAsArray(k:match(" (.*)".." "), " ")
      table.remove(individual_values, count2)
      for i=1, count2-1 do
        if tonumber(individual_values[i])~=nil then individual_values[i]=tonumber(individual_values[i]) end
      end
      return table.unpack(individual_values)
    end
    count=count+1
  end
end

--L,LL = reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--A,B,C,D,E,F,G,H,I=ultraschall.GetTrackHWOut(1, 2, LL)

function ultraschall.GetTrackAUXSendReceives(tracknumber, idx, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation = ultraschall.GetTrackAUXSendReceives(integer tracknumber, integer idx, optional string TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the settings of the Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, which you can choose with idx.
    Remember, if you want to get the sends of a track, you need to check the recv_tracknumber-returnvalues of the OTHER(!) tracks, as you can only get the receives. With the receives checked, you know, which track sends.
    
    It's the entry AUXRECV
    
    see [MKVOL2DB](#MKVOL2DB) to convert returnvalue volume into a dB-value
    
    returns -1 in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose Send/Receive you want
    integer idx - the id-number of the Send/Receive, beginning with 1 for the first Send/Receive-Settings
    optional string TrackStateChunk - a TrackStateChunk, whose AUXRECV-entries you want to get
  </parameters>
  <retvals>
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                        -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, trackstatechunk, pan-law</tags>
</US_DocBloc>
]]

  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return -1 end
  if tracknumber~=-1 and (tracknumber<1 or tracknumber>reaper.CountTracks(0)) then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "tracknumber", "no such track", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "must be an integer", -3) return -1 end
  if idx<1 then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such index available", -4) return -1 end

  if tracknumber~=-1 then 
    local tr=reaper.GetTrack(0,tracknumber-1)
    if reaper.GetTrackNumSends(tr, -1)<idx then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such index available", -5) return -1 end
    local sendidx=idx
    return math.tointeger(reaper.GetMediaTrackInfo_Value(reaper.BR_GetMediaTrackSendInfo_Track(tr, -1, sendidx-1, 0), "IP_TRACKNUMBER")-1)+1, -- D1
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_SENDMODE")), -- D2
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_VOL"),  -- D3
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_PAN"),  -- D4
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_MUTE")), -- D5
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_MONO")), -- D6
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "B_PHASE")),-- D7
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_SRCCHAN")), -- D8
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_DSTCHAN")), -- D9
           reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "D_PANLAW"), -- D10
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_MIDIFLAGS")), -- D11
           math.tointeger(reaper.GetTrackSendInfo_Value(tr, -1, sendidx-1, "I_AUTOMODE")) -- D12  
  end
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -6) return -1 end
  if ultraschall.CountTrackAUXSendReceives(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("GetTrackAUXSendReceives", "idx", "no such entry", -7) return -1 end
  
  local count=1
  
  for k in string.gmatch(TrackStateChunk, "AUXRECV.-\n") do
    if count==idx then 
      local count2, individual_values = ultraschall.CSV2IndividualLinesAsArray(k:match(" (.*)".." "), " ")
      table.remove(individual_values, count2)
      for i=1, count2-1 do
        if tonumber(individual_values[i])~=nil then individual_values[i]=tonumber(individual_values[i]) end
      end
      individual_values[1]=individual_values[1]+1
      individual_values[10]=tonumber(individual_values[10]:sub(1,-3))
      return table.unpack(individual_values)
    end
    count=count+1
  end
end


function ultraschall.CountTrackHWOuts(tracknumber, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountTrackHWOuts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count_HWOuts = ultraschall.CountTrackHWOuts(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    Counts and returns the number of existing HWOUT-HW-destination, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber.
    returns -1 in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose HWOUTs you want to count. 0 for Master Track; -1, to use optional parameter TrackStateChunk instead
    optional string TrackStateChunk - the TrackStateChunk, whose hwouts you want to count; only when tracknumber=-1
  </parameters>
  <retvals>
    integer count_HWOuts - the number of HWOuts in tracknumber
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, count, hwout, routing, trackstatechunk</tags>
</US_DocBloc>
]]
  local Track, A
  if tracknumber>-1 then
    if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("CountTrackHWOuts", "tracknumber", "must be an integer", -1) return -1 end
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("CountTrackHWOuts", "tracknumber", "no such track", -2) return -1 end
    Track=reaper.GetTrack(0,tracknumber-1)
    if tracknumber==0 then Track=reaper.GetMasterTrack(0) end
--    if Track==nil then return -1 end  
--    A,TrackStateChunk=ultraschall.GetTrackStateChunk(Track,"",true)
    return reaper.GetTrackNumSends(Track, 1)
  elseif tracknumber==-1 then
    if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("CountTrackHWOuts", "TrackStateChunk", "must be a valid TrackStateChunk", -3) return -1 end
  else
    ultraschall.AddErrorMessage("CountTrackHWOuts", "tracknumber", "no such track", -4)
    return -1
  end
  local TrackStateChunkArray={}
  local count=1
  while TrackStateChunk:match("HWOUT")=="HWOUT" do
    TrackStateChunkArray[count]=TrackStateChunk:match("HWOUT.-%c")
    TrackStateChunk=TrackStateChunk:match("HWOUT.-%c(.*)")
    count=count+1
  end
  return count-1, TrackStateChunkArray
end


function ultraschall.CountTrackAUXSendReceives(tracknumber, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count_SendReceives = ultraschall.CountTrackAUXSendReceives(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    Counts and returns the number of existing Send/Receives/Routing-settings, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber.
    returns -1 in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose Send/Receive you want; -1, if you want to pass a TrackStateChunk instead
    optional string TrackStateChunk - the TrackStateChunk, whose hwouts you want to count; only when tracknumber=-1
  </parameters>
  <retvals>
    integer count_SendReceives - the number of Send/Receives-Settings in tracknumber
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, count, send, receive, routing, trackstatechunk</tags>
</US_DocBloc>
]]
  local A, Track
  if tracknumber>-1 then
    if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("CountTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return -1 end
    if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("CountTrackAUXSendReceives", "tracknumber", "no such track", -2) return -1 end
    Track=reaper.GetTrack(0,tracknumber-1)
    if Track==nil then ultraschall.AddErrorMessage("CountTrackAUXSendReceives", "tracknumber", "no such track", -3) return -1 end
    A,TrackStateChunk=ultraschall.GetTrackStateChunk(Track,"",true)
  elseif tracknumber==-1 then
    if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("CountTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -4) return -1 end
  else
    ultraschall.AddErrorMessage("CountTrackAUXSendReceives", "tracknumber", "no such track", -5)
    return -1
  end
  
  
  local TrackStateChunkArray={}
  local count=1
  while TrackStateChunk:match("AUXRECV")=="AUXRECV" do
    TrackStateChunkArray[count]=TrackStateChunk:match("AUXRECV.-%c")
    TrackStateChunk=TrackStateChunk:match("AUXRECV.-%c(.*)")
    count=count+1
  end
  return count-1, TrackStateChunkArray
end


function ultraschall.AddTrackHWOut(tracknumber, outputchannel, post_pre_fader, volume, pan, mute, phase, source, pan_law, automationmode, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddTrackHWOut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.AddTrackHWOut(integer tracknumber, integer outputchannel, integer post_pre_fader, number volume, number pan, integer mute, integer phase, integer source, number pan_law, integer automationmode, optional parameter TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a setting of the HWOUT-HW-destination, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber.
    This function does not check the parameters for plausability, so check your settings twice!
    
    see [DB2MKVOL](#DB2MKVOL) to convert parameter volume from a dB-value
    
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose HWOut you want. 0 for Master Track; -1, use parameter TrackStateChunk instead
    integer outputchannel - outputchannel, with 1024+x the individual hw-outputchannels, 0,2,4,etc stereo output channels
    integer post_pre_fader - 0-post-fader(post pan), 1-preFX, 3-pre-fader(Post-FX), as set in the Destination "Controls for Track"-dialogue
    number volume - volume, as set in the Destination "Controls for Track"-dialogue
    number pan - pan, as set in the Destination "Controls for Track"-dialogue
    integer mute - mute, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer phase - Phase, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer source - source, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - None
    -                                     0 - Stereo Source 1/2
    -                                     4 - Stereo Source 5/6
    -                                    12 - New Channels On Sending Track Stereo Source Channel 13/14
    -                                    1024 - Mono Source 1
    -                                    1029 - Mono Source 6
    -                                    1030 - New Channels On Sending Track Mono Source Channel 7
    -                                    1032 - New Channels On Sending Track Mono Source Channel 9
    -                                    2048 - MultiChannel 4 Channels 1-4
    -                                    2050 - Multichannel 4 Channels 3-6
    -                                    3072 - Multichannel 6 Channels 1-6
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer automationmode - automation mode, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - Track Automation Mode
    -                                     0 - Trim/Read
    -                                     1 - Read
    -                                     2 - Touch
    -                                     3 - Write
    -                                     4 - Latch
    -                                     5 - Latch Preview
    optional parameter TrackStateChunk - a TrackStateChunk into which to add the hwout-setting; only available, when tracknumber=-1
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    optional parameter TrackStateChunk - an altered TrackStateChunk into which you added the new hwout-setting
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, add, hwout, routing, phase, source, mute, pan, volume, post, pre, fader, channel, automation, pan-law, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("AddTrackHWOut", "tracknumber", "no such track", -2) return false end
  if math.type(outputchannel)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "outputchannel", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("AddTrackHWOut", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("AddTrackHWOut", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "mute", "must be an integer", -7) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "phase", "must be an integer", -8) return false end
  if math.type(source)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "source", "must be an integer", -9) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("AddTrackHWOut", "pan_law", "must be a number", -10) return false end
  if math.type(automationmode)~="integer" then ultraschall.AddErrorMessage("AddTrackHWOut", "automationmode", "must be an integer", -11) return false end

  if tracknumber>-1 then
    -- get track
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,tracknumber-1) end
    -- create new hwout
    local sendidx=reaper.CreateTrackSend(tr, nil)
    -- change it's settings
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "I_DSTCHAN", outputchannel) -- D2
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "I_SENDMODE", post_pre_fader) -- D2
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "D_VOL", volume)  -- D3
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "D_PAN", pan)  -- D4
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "B_MUTE", mute) -- D5
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "B_PHASE", phase)-- D6
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "I_SRCCHAN", source) -- D7
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "D_PANLAW", pan_law) -- D8
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx, "I_AUTOMODE", automationmode) -- D9
    return true
  end
  
  -- if dealing with a TrackStateChunk, then do the following
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("AddTrackHWOut", "TrackStateChunk", "must be a valid TrackStateChunk", -13) return false end
  local Startoffs=TrackStateChunk:match("MAINSEND .-\n()")
  
  TrackStateChunk=TrackStateChunk:sub(1,Startoffs-1)..
                  "HWOUT "..outputchannel.." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." "..phase.." "..source.." "..pan_law..":U "..automationmode.."\n"..
                  TrackStateChunk:sub(Startoffs,-1)
                  
  return true, TrackStateChunk
end


function ultraschall.AddTrackAUXSendReceives(tracknumber, recv_tracknumber, post_pre_fader, volume, pan, mute, mono_stereo, phase, chan_src, snd_chan, pan_law, midichanflag, automation, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.AddTrackAUXSendReceives(integer tracknumber, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation, optional string TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Adds a setting of Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one.
    Remember, if you want to set the sends of a track, you need to add it to the track, that shall receive, not the track that sends! Set recv_tracknumber in the track that receives with the tracknumber that sends, and you've set it successfully.
    
    Due to the complexity of send/receive-settings, this function does not check, whether the parameters are plausible. So check twice, whether the added sends/receives appear, as they might not appear!
    
    see [DB2MKVOL](#DB2MKVOL) to convert parameter volume from a dB-value
    
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose Send/Receive you want; -1, if you want to use the parameter TrackStateChunk
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                       -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16    
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
    optional string TrackStateChunk - the TrackStateChunk, to which you want to add a new receive-routing
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional parameter TrackStateChunk - an altered TrackStateChunk into which you added a new receive/routing; only available, when tracknumber=-1
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, add, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, pan-law, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "tracknumber", "no such track", -2) return false end
  if math.type(recv_tracknumber)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "recv_tracknumber", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "mute", "must be an integer", -7) return false end
  if math.type(mono_stereo)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "mono_stereo", "must be an integer", -8) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "phase", "must be an integer", -9) return false end
  if math.type(chan_src)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "chan_src", "must be a number", -10) return false end
  if math.type(snd_chan)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "snd_chan", "must be an integer", -11) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "pan_law", "must be a number", -12) return false end
  if math.type(midichanflag)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "midichanflag", "must be an integer", -13) return false end
  if math.type(automation)~="integer" then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "automation", "must be an integer", -14) return false end

  if tracknumber>-1 then
    -- get track
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,recv_tracknumber-1) end
    -- create new AUXRecv
    local sendidx=reaper.CreateTrackSend(tr, reaper.GetTrack(0,tracknumber-1))
    -- change it's settings
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_SENDMODE", post_pre_fader) -- D2
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_VOL", volume)  -- D3
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_PAN", pan)  -- D4
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_MUTE", mute) -- D5
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_MONO", mono_stereo) -- D6
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "B_PHASE", phase)-- D7
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_SRCCHAN", chan_src) -- D8
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_DSTCHAN", snd_chan) -- D9
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "D_PANLAW", pan_law) -- D10
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_MIDIFLAGS", midichanflag) -- D11
      reaper.SetTrackSendInfo_Value(tr, 0, sendidx, "I_AUTOMODE", automation) -- D12  
    return true
  end
  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("AddTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -16) return false end
  -- if dealing with a TrackStateChunk, then do the following
  local Startoffs=TrackStateChunk:match("PERF .-\n()")
  
  TrackStateChunk=TrackStateChunk:sub(1,Startoffs-1)..
                  "AUXRECV "..(recv_tracknumber-1).." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." "..mono_stereo.." "..
                  phase.." "..chan_src.." "..snd_chan.." "..pan_law..":U "..midichanflag.." "..automation.." ''".."\n"..
                  TrackStateChunk:sub(Startoffs,-1)
                  
  return true, TrackStateChunk
end


function ultraschall.DeleteTrackHWOut(tracknumber, idx, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteTrackHWOut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.DeleteTrackHWOut(integer tracknumber, integer idx, optional string TrackStateChunk)</functioncall>
  <description>
    Deletes the idxth HWOut-Setting of tracknumber.
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose HWOUTs you want to delete. 0 for Master Track. -1, if you want to use the parameter TrackStateChunk instead
    integer idx - the number of the HWOut-setting, that you want to delete; -1, to delete all HWOuts from this track
    optional string TrackStateChunk - the TrackStateChunk, from which you want to delete HWOut-entries
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional string TrackStateChunk - the altered TrackStateChunk, from which you deleted HWOut-entries; only available, when tracknumber=-1
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, delete, hwout, routing, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("DeleteTrackHWOut", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("DeleteTrackHWOut", "tracknumber", "no such track", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteTrackHWOut", "idx", "must be an integer", -3) return false end
  local Track, A, undo
  undo=false
  if tracknumber>-1 then
    Track=reaper.GetTrack(0,tracknumber-1)
    if tracknumber==0 then Track=reaper.GetMasterTrack(0) end
    A,TrackStateChunk=ultraschall.GetTrackStateChunk(Track,"",true)
    if idx==-1 then return reaper.SetTrackStateChunk(Track, string.gsub(TrackStateChunk, "HWOUT.-\n", ""), undo) end
  elseif ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("DeleteTrackHWOut", "TrackStateChunk", "must be a valid TrackStateChunk", -5) return false
  else
    if idx==-1 then return true, string.gsub(TrackStateChunk, "HWOUT.-\n", "") end
  end  
  local B,C=ultraschall.CountTrackHWOuts(-1, TrackStateChunk)
  local finalstring=""  
  local Begin
  local Ending
  
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(TrackStateChunk)
  local count2=0
  for i=1, count do
    if split_string[i]:match("HWOUT")==nil then
      finalstring=finalstring..split_string[i].."\n"
    else
      count2=count2+1
      if count2~=idx then 
        finalstring=finalstring..split_string[i].."\n"
      end
    end
  end
  
  if tracknumber>-1 then 
    return reaper.SetTrackStateChunk(Track, finalstring, undo)
  else
    return true, finalstring
  end
end


function ultraschall.DeleteTrackAUXSendReceives(tracknumber, idx, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteTrackAUXSendReceives(integer tracknumber, integer idx, optional string TrackStateChunk)</functioncall>
  <description>
    Deletes the idxth Send/Receive-Setting of tracknumber.
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose Send/Receive you want; -1, if you want to use the parameter TrackStateChunk
    integer idx - the number of the send/receive-setting, that you want to delete; -1, deletes all AuxReceives on this track
    optional string TrackStateChunk - a TrackStateChunk, from which you want to delete Send/Receive-entries; only available, when tracknumber=-1
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional string TrackStateChunk - an altered TrackStateChunk, from which you deleted a Send/Receive-entrie; only available, when tracknumber=-1
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, delete, send, receive, routing, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("DeleteTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("DeleteTrackAUXSendReceives", "tracknumber", "no such track", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteTrackAUXSendReceives", "idx", "must be an integer", -3) return false end
  local Track, A, undo
  undo=false
  if tracknumber>-1 then
    Track=reaper.GetTrack(0,tracknumber-1)
    if tracknumber==0 then Track=reaper.GetMasterTrack(0) end  
    A,TrackStateChunk=ultraschall.GetTrackStateChunk(Track,"",true)
    if idx==-1 then return reaper.SetTrackStateChunk(Track, string.gsub(TrackStateChunk, "AUXRECV.-\n", ""), undo) end
  elseif ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("DeleteTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -5) return false
  else
    if idx==-1 then return true, string.gsub(TrackStateChunk, "AUXRECV.-\n", "") end
  end
  local B,C=ultraschall.CountTrackAUXSendReceives(-1, TrackStateChunk)
  local finalstring=""  
  local Begin
  local Ending  
  
  if B<=0 then Begin=TrackStateChunk:match("(.-PERF.-%c)")
  else Begin=TrackStateChunk:match("(.-)AUXRECV.-%c")
  end
  if B<=0 then Ending=TrackStateChunk:match(".*PERF.-%c(.*)")
  else Ending=TrackStateChunk:match(".*AUXRECV.-%c(.*)")
  end
  
  finalstring=Begin
  for i=1,B do
    if idx~=i then 
      finalstring=finalstring..C[i] 
    end
  end
  finalstring=finalstring..Ending
  if tracknumber~=-1 then
    return reaper.SetTrackStateChunk(Track, finalstring, undo)
  else
    return true, finalstring
  end
end

function ultraschall.SetTrackHWOut(tracknumber, idx, outputchannel, post_pre_fader, volume, pan, mute, phase, source, pan_law, automationmode, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackHWOut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.SetTrackHWOut(integer tracknumber, integer idx, integer outputchannel, integer post_pre_fader, number volume, number pan, integer mute, integer phase, integer source, number pan_law, integer automationmode, optional string TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets a setting of the HWOUT-HW-destination, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, so choose the one you want to change with idx.
    To retain old-settings, use nil with the accompanying parameters.
    This function does not check the parameters for plausability, so check your settings twice, or the HWOut-setting might disappear with faulty parameters!
    
    see [DB2MKVOL](#DB2MKVOL) to convert volume from a dB-value
    
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose HWOut you want. 0 for Master Track
    integer idx - the number of the HWOut-setting, you want to change
    integer outputchannel - outputchannel, with 1024+x the individual hw-outputchannels, 0,2,4,etc stereo output channels
    integer post_pre_fader - 0-post-fader(post pan), 1-preFX, 3-pre-fader(Post-FX), as set in the Destination "Controls for Track"-dialogue
    number volume - volume, as set in the Destination "Controls for Track"-dialogue
    number pan - pan, as set in the Destination "Controls for Track"-dialogue
    integer mute - mute, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer phase - Phase, 1-on, 0-off, as set in the Destination "Controls for Track"-dialogue
    integer source - source, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - None
    -                                     0 - Stereo Source 1/2
    -                                     4 - Stereo Source 5/6
    -                                    12 - New Channels On Sending Track Stereo Source Channel 13/14
    -                                    1024 - Mono Source 1
    -                                    1029 - Mono Source 6
    -                                    1030 - New Channels On Sending Track Mono Source Channel 7
    -                                    1032 - New Channels On Sending Track Mono Source Channel 9
    -                                    2048 - MultiChannel 4 Channels 1-4
    -                                    2050 - Multichannel 4 Channels 3-6
    -                                    3072 - Multichannel 6 Channels 1-6
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer automationmode - automation mode, as set in the Destination "Controls for Track"-dialogue
    -                                    -1 - Track Automation Mode
    -                                     0 - Trim/Read
    -                                     1 - Read
    -                                     2 - Touch
    -                                     3 - Write
    -                                     4 - Latch
    -                                     5 - Latch Preview
    optional string TrackStateChunk - sets an HWOUT-entry in a TrackStateChunk
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    optional string TrackStateChunk - an altered TrackStateChunk, in which you've set a send/receive-setting; only available when track=-1
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, set, hwout, routing, phase, source, mute, pan, volume, post, pre, fader, channel, automation, pan-law, trackstatechunk</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackHWOut", "tracknumber", "no such track", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "must be an integer", -13) return false end
  if idx<1 then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "no such index", -14) return false end
  if math.type(outputchannel)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "outputchannel", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("SetTrackHWOut", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("SetTrackHWOut", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "mute", "must be an integer", -7) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "phase", "must be an integer", -8) return false end
  if math.type(source)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "source", "must be an integer", -9) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("SetTrackHWOut", "pan_law", "must be a number", -10) return false end
  if math.type(automationmode)~="integer" then ultraschall.AddErrorMessage("SetTrackHWOut", "automationmode", "must be an integer", -11) return false end
  
  if tracknumber~=-1 then
    local tr
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,tracknumber-1) end
    if idx>reaper.GetTrackNumSends(tr, 1) then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "no such index", -15) return false end
    sendidx=idx
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "I_DSTCHAN", outputchannel) -- D2
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "I_SENDMODE", post_pre_fader) -- D2
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "D_VOL", volume)  -- D3
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "D_PAN", pan)  -- D4
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "B_MUTE", mute) -- D5
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "B_PHASE", phase)-- D6
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "I_SRCCHAN", source) -- D7
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "D_PANLAW", pan_law) -- D8
    reaper.SetTrackSendInfo_Value(tr, 1, sendidx-1, "I_AUTOMODE", automationmode) -- D9
    return true
  end  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("SetTrackHWOut", "TrackStateChunk", "must be a valid TrackStateChunk", -16) return false end
  if ultraschall.CountTrackHWOuts(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "no such index", -17) return false end
  
  local Start, Offset=TrackStateChunk:match("(.-MAINSEND.-\n)()")
  local Ende = TrackStateChunk:match(".*HWOUT.-\n(.*)")
  local count=1
  local Middle="HWOUT "..outputchannel.." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." "..phase.." ".. source.." "..pan_law..":U "..automationmode.."\n"
  local Middle1=""
  local Middle2=""
  
  for k in string.gmatch(TrackStateChunk, "HWOUT.-\n") do
    if count<idx then Middle1=Middle1..k end
    if count>idx then Middle2=Middle2..k end
    count=count+1
  end
  
  TrackStateChunk=Start..Middle1..Middle..Middle2..Ende
  return true, TrackStateChunk
end


function ultraschall.SetTrackAUXSendReceives(tracknumber, idx, recv_tracknumber, post_pre_fader, volume, pan, mute, mono_stereo, phase, chan_src, snd_chan, pan_law, midichanflag, automation, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.SetTrackAUXSendReceives(integer tracknumber, integer idx, integer recv_tracknumber, integer post_pre_fader, number volume, number pan, integer mute, integer mono_stereo, integer phase, integer chan_src, integer snd_chan, number pan_law, integer midichanflag, integer automation, optional string TrackStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Alters a setting of Send/Receive, as set in the routing-matrix, as well as in the Destination "Controls for Track"-dialogue, of tracknumber. There can be more than one, so choose the right one with idx.
    You can keep the old-setting by using nil as a parametervalue.
    Remember, if you want to set the sends of a track, you need to add it to the track, that shall receive, not the track that sends! Set recv_tracknumber in the track that receives with the tracknumber that sends, and you've set it successfully.
    
    Due to the complexity of send/receive-settings, this function does not check, whether the parameters are plausible. So check twice, whether the change sends/receives still appear, as they might disappear with faulty settings!
    
    see [DB2MKVOL](#DB2MKVOL) to convert parameter volume from a dB-value
    
    returns false in case of failure
  </description>
  <parameters>
    integer tracknumber - the number of the track, whose Send/Receive you want
    integer idx - the send/receive-setting, you want to set
    integer recv_tracknumber - Tracknumber, from where to receive the audio from
    integer post_pre_fader - 0-PostFader, 1-PreFX, 3-Pre-Fader
    number volume - Volume 
    number pan - pan, as set in the Destination "Controls for Track"-dialogue; negative=left, positive=right, 0=center
    integer mute - Mute this send(1) or not(0)
    integer mono_stereo - Mono(1), Stereo(0)
    integer phase - Phase of this send on(1) or off(0)
    integer chan_src - Audio-Channel Source
    -                                        -1 - None
    -                                        0 - Stereo Source 1/2
    -                                        1 - Stereo Source 2/3
    -                                        2 - Stereo Source 3/4
    -                                        1024 - Mono Source 1
    -                                        1025 - Mono Source 2
    -                                        2048 - Multichannel Source 4 Channels 1-4
    integer snd_chan - send to channel
    -                                        0 - Stereo 1/2
    -                                        1 - Stereo 2/3
    -                                        2 - Stereo 3/4
    -                                        ...
    -                                        1024 - Mono Channel 1
    -                                        1025 - Mono Channel 2
    number pan_law - pan-law, as set in the dialog that opens, when you right-click on the pan-slider in the routing-settings-dialog; default is -1 for +0.0dB
    integer midichanflag -0 - All Midi Tracks
    -                                        1 to 16 - Midi Channel 1 to 16
    -                                        32 - send to Midi Channel 1
    -                                        64 - send to MIDI Channel 2
    -                                        96 - send to MIDI Channel 3
    -                                        ...
    -                                        512 - send to MIDI Channel 16
    -                                        4194304 - send to MIDI-Bus B1
    -                                        send to MIDI-Bus B1 + send to MIDI Channel nr = MIDIBus B1 1/nr:
    -                                        16384 - BusB1
    -                                        BusB1+1 to 16 - BusB1-Channel 1 to 16
    -                                        32768 - BusB2
    -                                        BusB2+1 to 16 - BusB2-Channel 1 to 16
    -                                        49152 - BusB3
    -                                        ...
    -                                        BusB3+1 to 16 - BusB3-Channel 1 to 16
    -                                        262144 - BusB16
    -                                        BusB16+1 to 16 - BusB16-Channel 1 to 16
    -
    -                                        1024 - Add that value to switch MIDI On
    -                                        4177951 - MIDI - None
    integer automation - Automation Mode
    -                                       -1 - Track Automation Mode
    -                                        0 - Trim/Read
    -                                        1 - Read
    -                                        2 - Touch
    -                                        3 - Write
    -                                        4 - Latch
    -                                        5 - Latch Preview
    optional string TrackStateChunk - a TrackStateChunk, whose AUXRECV-entries you want to set
  </parameters>
  <retvals>
    boolean retval - true if it worked, false if it didn't.
    optional string TrackStateChunk - an altered TrackStateChunk, whose AUXRECV-entries you've altered
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, set, send, receive, phase, source, mute, pan, volume, post, pre, fader, channel, automation, midi, trackstatechunk, pan-law</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "tracknumber", "must be an integer", -1) return false end
  if tracknumber~=-1 and (tracknumber<1 or tracknumber>reaper.CountTracks(0)) then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "tracknumber", "no such track", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "must be an integer", -16) return false end
  if idx<1 then ultraschall.AddErrorMessage("SetTrackHWOut", "idx", "no such index", -20) return false end
  if math.type(recv_tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "recv_tracknumber", "must be an integer", -3) return false end
  if math.type(post_pre_fader)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "post_pre_fader", "must be an integer", -4) return false end
  if type(volume)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "volume", "must be a number", -5) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "pan", "must be a number", -6) return false end
  if math.type(mute)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "mute", "must be an integer", -7) return false end
  if math.type(mono_stereo)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "mono_stereo", "must be an integer", -8) return false end
  if math.type(phase)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "phase", "must be an integer", -9) return false end
  if math.type(chan_src)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "chan_src", "must be a number", -10) return false end
  if math.type(snd_chan)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "snd_chan", "must be an integer", -11) return false end
  if type(pan_law)~="number" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "pan_law", "must be a number", -12) return false end
  if math.type(midichanflag)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "midichanflag", "must be an integer", -13) return false end
  if math.type(automation)~="integer" then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "automation", "must be an integer", -14) return false end
  
  local tr, temp, Track
  if tracknumber~=-1 then
    if tracknumber==0 then tr=reaper.GetMasterTrack(0)
    else tr=reaper.GetTrack(0,tracknumber-1) end
    if idx>reaper.GetTrackNumSends(tr, -1) then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "no such index", -17) return false end
    temp, TrackStateChunk=reaper.GetTrackStateChunk(tr, "", false)
  end  
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "TrackStateChunk", "must be a valid TrackStateChunk", -18) return false end
  if ultraschall.CountTrackAUXSendReceives(-1, TrackStateChunk)<idx then ultraschall.AddErrorMessage("SetTrackAUXSendReceives", "idx", "no such index", -19) return false end
  
  local Start, Offset=TrackStateChunk:match("(.-PERF.-\n)()")
  local Ende = TrackStateChunk:match(".*AUXRECV.-\n(.*)")
  local count=1
  local Middle="AUXRECV "..(recv_tracknumber-1).." "..post_pre_fader.." "..volume.." "..pan.." "..mute.." ".. mono_stereo.." "..phase.." "..chan_src.." "..snd_chan.." "..pan_law..":U "..midichanflag.." "..automation.." ''\n"
  local Middle1=""
  local Middle2=""
  
  for k in string.gmatch(TrackStateChunk, "AUXRECV.-\n") do
    if count<idx then Middle1=Middle1..k end
    if count>idx then Middle2=Middle2..k end
    count=count+1
  end
  
  TrackStateChunk=Start..Middle1..Middle..Middle2..Ende
  if tracknumber==-1 then
    return true, TrackStateChunk
  else
    reaper.SetTrackStateChunk(tr, TrackStateChunk, false)
  end
end

function ultraschall.ClearRoutingMatrix(ClearHWOuts, ClearAuxRecvs, ClearTrackMasterSends, ClearMasterTrack, undo)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ClearRoutingMatrix</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ClearRoutingMatrix(boolean ClearHWOuts, boolean ClearAuxRecvs, boolean ClearTrackMasterSends, boolean ClearMasterTrack, boolean undo)</functioncall>
  <description>
    Clears all routing-matrix-settings or optionally part of them
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, clearing was successful; false, clearing was unsuccessful
  </retvals>
  <parameters>
    boolean ClearHWOuts - nil or true, clear all HWOuts; false, keep the HWOuts intact
    boolean ClearAuxRecvs - nil or true, clear all Send/Receive-settings; false, keep the Send/Receive-settings intact
    boolean ClearTrackMasterSends - nil or true, clear all send to master-checkboxes; false, keep them intact
    boolean ClearMasterTrack - nil or true, include the Mastertrack as well; false, don't include it
    boolean undo - true, set undo point; false or nil, don't set undo point
  </parameters>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>routing, trackmanagement, routing matrix, clear, tracksend, mainsend, receive, send, hwout, mastertrack</tags>
</US_DocBloc>
--]]
  if ClearHWOuts~=nil and type(ClearHWOuts)~="boolean" then ultraschall.AddErrorMessage("ClearRoutingMatrix", "ClearHWOuts", "must be either nil or boolean", -1) return false end
  if ClearAuxRecvs~=nil and type(ClearAuxRecvs)~="boolean" then ultraschall.AddErrorMessage("ClearRoutingMatrix", "ClearAuxRecvs", "must be either nil or boolean", -2) return false end
  if ClearTrackMasterSends~=nil and type(ClearTrackMasterSends)~="boolean" then ultraschall.AddErrorMessage("ClearRoutingMatrix", "ClearTrackMasterSends", "must be either nil or boolean", -3) return false end
  if ClearMasterTrack~=nil and type(ClearMasterTrack)~="boolean" then ultraschall.AddErrorMessage("ClearRoutingMatrix", "ClearMasterTrack", "must be either nil or boolean", -4) return false end
  if undo~=nil and type(undo)~="boolean" then ultraschall.AddErrorMessage("ClearRoutingMatrix", "undo", "must be either nil or boolean", -5) return false end
  if undo==nil then undo=false end
  if ClearMasterTrack==false then minimumTrack=1 else minimumTrack=0 end
  
  local track, A
  for i=minimumTrack, reaper.CountTracks(0) do
    if i==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,i-1) end
    if ClearHWOuts~=false then 
      ultraschall.DeleteTrackHWOut(i,-1,undo) 
    end
    if ClearAuxRecvs~=false then 
        --print2(i, -1, undo)
      ultraschall.DeleteTrackAUXSendReceives(i,-1) 
    end
    if ClearTrackMasterSends~=false then 
      local MainSendOn, ParentChannels = ultraschall.GetTrackMainSendState(i)
      ultraschall.SetTrackMainSendState(i, 0, ParentChannels)
    end
  end
  return true
end

--A=ultraschall.ClearRoutingMatrix(nil,nil,nil,nil,nil)
--O=ultraschall.ClearRoutingMatrix(false, true, false, true, false)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ClearRoutingMatrix</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ClearRoutingMatrix(boolean ClearHWOuts, boolean ClearAuxRecvs, boolean ClearTrackMasterSends, boolean ClearMasterTrack, boolean undo)</functioncall>
  <description>
    Clears all routing-matrix-settings or optionally part of them
  </description>
  <retvals>
    boolean retval - true, clearing was successful; false, clearing was unsuccessful
  </retvals>
  <parameters>
    boolean ClearHWOuts - nil or true, clear all HWOuts; false, keep the HWOuts intact
    boolean ClearAuxRecvs - nil or true, clear all Send/Receive-settings; false, keep the Send/Receive-settings intact
    boolean ClearTrackMasterSends - nil or true, clear all send to master-checkboxes; false, keep them intact
    boolean ClearMasterTrack - nil or true, include the Mastertrack as well; false, don't include it
    boolean undo - true, set undo point; false or nil, don't set undo point
  </parameters>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>routing, trackmanagement, routing matrix, clear, tracksend, mainsend, receive, send, hwout, mastertrack</tags>
</US_DocBloc>
--]]

function ultraschall.GetAllHWOuts()
  -- returned table is of structure:
  --    table[tracknumber]["HWOut_count"]                 - the number of HWOuts of tracknumber, beginning with 1
  --    table[tracknumber][HWOutIndex]["outputchannel"]   - the number of outputchannels of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["post_pre_fader"]  - the setting of post-pre-fader of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["volume"]          - the volume of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["pan"]             - the panning of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["mute"]            - the mute-setting of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["phase"]           - the phase-setting of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["source"]          - the source/input of this HWOutIndex of tracknumber
  --    table[tracknumber][HWOutIndex]["unknown"]         - unknown, leave it -1
  --    table[tracknumber][HWOutIndex]["automationmode"]  - the automation-mode of this HWOutIndex of tracknumber
  --
  -- tracknumber 0 is the Master-Track

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllHWOuts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>table AllHWOuts, integer number_of_tracks = ultraschall.GetAllHWOuts()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all HWOut-settings of all tracks, including master-track(track index: 0)
    
    returned table is of structure:
      table["HWOuts"]=true                              - signals, this is a HWOuts-table; don't change that!  
      table["number\_of_tracks"]                         - the number of tracks in this table, from track 0(master) to track n  
      table[tracknumber]["HWOut_count"]                 - the number of HWOuts of tracknumber, beginning with 1  
      table[tracknumber]["TrackID"]                     - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      table[tracknumber][HWOutIndex]["outputchannel"]   - the number of outputchannels of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["post\_pre_fader"] - the setting of post-pre-fader of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["volume"]          - the volume of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan"]             - the panning of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["mute"]            - the mute-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["phase"]           - the phase-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["source"]          - the source/input of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan\_law"]         - pan-law, default is -1  
      table[tracknumber][HWOutIndex]["automationmode"]  - the automation-mode of this HWOutIndex of tracknumber    
      
      See [GetTrackHWOut](#GetTrackHWOut) for more details on the individual settings, stored in the entries.  
  </description>
  <retvals>
    table AllHWOuts - a table with all HWOuts of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, all, hwouts, hardware outputs, routing</tags>
</US_DocBloc>
]]

  local HWOuts={}
  HWOuts["number_of_tracks"]=reaper.CountTracks()
  HWOuts["HWOuts"]=true

  for i=0, reaper.CountTracks() do
    HWOuts[i]={}
    local count_HWOuts = ultraschall.CountTrackHWOuts(i)
    HWOuts[i]["HWOut_count"]=count_HWOuts
    if i>0 then 
      HWOuts[i]["TrackID"]=reaper.BR_GetMediaTrackGUID(reaper.GetTrack(0,i-1))
    else
      HWOuts[i]["TrackID"]=reaper.BR_GetMediaTrackGUID(reaper.GetMasterTrack(0))
    end
    for a=1, count_HWOuts do
      HWOuts[i][a]={}
      HWOuts[i][a]["outputchannel"],
      HWOuts[i][a]["post_pre_fader"],
      HWOuts[i][a]["volume"], 
      HWOuts[i][a]["pan"], 
      HWOuts[i][a]["mute"], 
      HWOuts[i][a]["phase"], 
      HWOuts[i][a]["source"], 
      HWOuts[i][a]["pan_law"], 
      HWOuts[i][a]["automationmode"] = ultraschall.GetTrackHWOut(i, a)
    end
  end
  return HWOuts, reaper.CountTracks()
end

--A=ultraschall.GetAllHWOuts()

function ultraschall.ApplyAllHWOuts(AllHWOuts, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyAllHWOuts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyAllHWOuts(table AllHWOuts, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Takes a table, as returned by [GetAllHWOuts](#GetAllHWOuts) with all HWOut-settings of all tracks and applies it to all tracks.

    When you set option to 2, the individual entries will be applied to the tracks, that have the guids stored in table
    table[tracknumber]["TrackID"], otherwise, this function will apply it to track0 to trackn, which is the same as table["number\_of_tracks"].
    That way, you can create RoutingSnapshots, that will stay in the right tracks, even if they are ordered differently or when tracks have been added/deleted.

    This influences the MasterTrack as well!
    
    expected table is of structure:
      
      table["HWOuts"]=true                              - signals, this is a HWOuts-table; don't change that!  
      table["number\_of_tracks"]                         - the number of tracks in this table, from track 0(master) to track n  
      table[tracknumber]["HWOut_count"]                 - the number of HWOuts of tracknumber, beginning with 1  
      table[tracknumber]["TrackID"]                     - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      table[tracknumber][HWOutIndex]["outputchannel"]   - the number of outputchannels of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["post\_pre_fader"] - the setting of post-pre-fader of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["volume"]          - the volume of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan"]             - the panning of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["mute"]            - the mute-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["phase"]           - the phase-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["source"]          - the source/input of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan\_law"]         - pan-law, default is -1  
      table[tracknumber][HWOutIndex]["automationmode"]  - the automation-mode of this HWOutIndex of tracknumber   
          
      See [GetTrackHWOut](#GetTrackHWOut) for more details on the individual settings, stored in the entries.
      
      returns false in case of an error
  </description>
  <parameters>
    table AllHWOuts - a table with all AllHWOut-entries of the current project
    optional integer option - nil or 1, HWOuts will be applied to Track 0(MasterTrack) to table["number_of_tracks"]; 2, HWOuts will be applied to the tracks with the guid TrackID
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, set, all, hwout, routing</tags>
</US_DocBloc>
]]
  if type(AllHWOuts)~="table" then ultraschall.AddErrorMessage("ApplyAllHWOuts", "AllHWOuts", "Must be a table.", -1) return false end
  if AllHWOuts["number_of_tracks"]==nil or AllHWOuts["HWOuts"]~=true then ultraschall.AddErrorMessage("ApplyAllHWOuts", "AllHWOuts", "Must be a valid AllAUXSendReceives, as returned by GetAllAUXSendReceive. Get it from there, alter that and pass it into here.", -2) return false end 
  local trackstatechunk, retval, aa
  for i=0, AllHWOuts["number_of_tracks"] do
    if option==2 then aa=ultraschall.GetTracknumberByGuid(AllHWOuts[i]["TrackID"]) else aa=i end
    retval, trackstatechunk = ultraschall.GetTrackStateChunk_Tracknumber(aa)
    for a=1, AllHWOuts[i]["HWOut_count"] do
      retval, trackstatechunk = ultraschall.SetTrackHWOut(-1, a, 
                                   AllHWOuts[i][a]["outputchannel"],
                                   AllHWOuts[i][a]["post_pre_fader"],
                                   AllHWOuts[i][a]["volume"], 
                                   AllHWOuts[i][a]["pan"], 
                                   AllHWOuts[i][a]["mute"], 
                                   AllHWOuts[i][a]["phase"], 
                                   AllHWOuts[i][a]["source"], 
                                   AllHWOuts[i][a]["pan_law"], 
                                   AllHWOuts[i][a]["automationmode"],
                                   trackstatechunk)
      end
    
      ultraschall.SetTrackStateChunk_Tracknumber(aa, trackstatechunk, false)
--      reaper.MB(tostring(trackstatechunk),"",0)
  end
  return true
end

function ultraschall.GetAllAUXSendReceives()
  -- returned table is of structure:
  --    table[tracknumber]["AUXSendReceives_count"]                   - the number of AUXSendReceives of tracknumber, beginning with 1
  --    table[tracknumber][AUXSendReceivesIndex]["recv_tracknumber"]  - the track, from which to receive audio in this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["post_pre_fader"]    - the setting of post-pre-fader of this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["volume"]            - the volume of this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["pan"]               - the panning of this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["mute"]              - the mute-setting of this AUXSendReceivesIndex  of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["mono_stereo"]       - the mono/stereo-button-setting of this AUXSendReceivesIndex  of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["phase"]             - the phase-setting of this AUXSendReceivesIndex  of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["chan_src"]          - the audiochannel-source of this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["snd_src"]           - the send-to-channel-target of this AUXSendReceivesIndex of tracknumber
  --    table[tracknumber][AUXSendReceivesIndex]["unknown"]           - unknown, leave it -1
  --    table[tracknumber][AUXSendReceivesIndex]["midichanflag"]      - the Midi-channel of this AUXSendReceivesIndex of tracknumber, leave it 0
  --    table[tracknumber][AUXSendReceivesIndex]["automation"]        - the automation-mode of this AUXSendReceivesIndex  of tracknumber

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>table AllAUXSendReceives, integer number_of_tracks = ultraschall.GetAllAUXSendReceives()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all AUX-SendReceive-settings of all tracks, excluding master-track
    
    returned table is of structure:
      table["AllAUXSendReceive"]=true                               - signals, this is an AllAUXSendReceive-table. Don't alter!  
      table["number\_of_tracks"]                                     - the number of tracks in this table, from track 1 to track n  
      table[tracknumber]["AUXSendReceives_count"]                   - the number of AUXSendReceives of tracknumber, beginning with 1  
      table[tracknumber]["TrackID"]                                 - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      table[tracknumber][AUXSendReceivesIndex]["recv\_tracknumber"] - the track, from which to receive audio in this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["recv\_track\_guid"] - the guid of the receive-track; with that, you can be sure to get the right receive-track, even if trackorder changes  
      table[tracknumber][AUXSendReceivesIndex]["post\_pre_fader"]   - the setting of post-pre-fader of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["volume"]            - the volume of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan"]               - the panning of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mute"]              - the mute-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mono\_stereo"]      - the mono/stereo-button-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["phase"]             - the phase-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["chan\_src"]         - the audiochannel-source of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["snd\_src"]          - the send-to-channel-target of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan\_law"]           - pan-law, default is -1  
      table[tracknumber][AUXSendReceivesIndex]["midichanflag"]      - the Midi-channel of this AUXSendReceivesIndex of tracknumber, leave it 0  
      table[tracknumber][AUXSendReceivesIndex]["automation"]        - the automation-mode of this AUXSendReceivesIndex  of tracknumber  
      
      See [GetTrackAUXSendReceives](#GetTrackAUXSendReceives) for more details on the individual settings, stored in the entries.
  </description>
  <retvals>
    table AllAUXSendReceives - a table with all SendReceive-entries of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, all, send, receive, aux, routing</tags>
</US_DocBloc>
]]

  local AUXSendReceives={}
  AUXSendReceives["number_of_tracks"]=reaper.CountTracks()
  AUXSendReceives["AllAUXSendReceives"]=true 
  
  for i=1, reaper.CountTracks() do
    AUXSendReceives[i]={}
    local count_AUXSendReceives = ultraschall.CountTrackAUXSendReceives(i)
    AUXSendReceives[i]["AUXSendReceives_count"]=count_AUXSendReceives
    AUXSendReceives[i]["TrackID"]=reaper.GetTrackGUID(reaper.GetTrack(0,i-1))

    for a=1, count_AUXSendReceives do
      AUXSendReceives[i][a]={}
      AUXSendReceives[i][a]["recv_tracknumber"],
      AUXSendReceives[i][a]["post_pre_fader"],
      AUXSendReceives[i][a]["volume"], 
      AUXSendReceives[i][a]["pan"], 
      AUXSendReceives[i][a]["mute"], 
      AUXSendReceives[i][a]["mono_stereo"], 
      AUXSendReceives[i][a]["phase"], 
      AUXSendReceives[i][a]["chan_src"], 
      AUXSendReceives[i][a]["snd_src"], 
      AUXSendReceives[i][a]["pan_law"], 
      AUXSendReceives[i][a]["midichanflag"], 
      AUXSendReceives[i][a]["automation"] = ultraschall.GetTrackAUXSendReceives(i, a)
      AUXSendReceives[i][a]["recv_track_guid"]=reaper.GetTrackGUID(reaper.GetTrack(0,AUXSendReceives[i][a]["recv_tracknumber"]-1))
      
      --]]
    end
  end
  return AUXSendReceives, reaper.CountTracks()
end

--A,B,C=ultraschall.GetAllAUXSendReceives()

function ultraschall.ApplyAllAUXSendReceives(AllAUXSendReceives, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyAllAUXSendReceives</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyAllAUXSendReceives(table AllAUXSendReceives, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    takes a table, as returned by [GetAllAUXSendReceive](#GetAllAUXSendReceive) with all AUXSendReceive-settings of all tracks and applies it to all tracks.

    When you set option to 2, the individual entries will be applied to the tracks, that have the guids stored in table
    table[tracknumber]["TrackID"], otherwise, this function will apply it to track1 to trackn, which is the same as table["number\_of_tracks"].
    That way, you can create RoutingSnapshots, that will stay in the right tracks, even if they are ordered differently or when tracks have been added/deleted.

    
    expected table is of structure:
      table["AllAUXSendReceive"]=true                               - signals, this is an AllAUXSendReceive-table. Don't alter!  
      table["number\_of_tracks"]                                     - the number of tracks in this table, from track 1 to track n  
      table[tracknumber]["AUXSendReceives_count"]                   - the number of AUXSendReceives of tracknumber, beginning with 1  
      table[tracknumber]["TrackID"]                                 - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      table[tracknumber][AUXSendReceivesIndex]["recv\_tracknumber"] - the track, from which to receive audio in this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["recv\_track\_guid"] - the guid of the receive-track; with that, you can be sure to get the right receive-track, even if trackorder changes  
      table[tracknumber][AUXSendReceivesIndex]["post\_pre_fader"]   - the setting of post-pre-fader of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["volume"]            - the volume of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan"]               - the panning of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mute"]              - the mute-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mono\_stereo"]      - the mono/stereo-button-setting of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["phase"]             - the phase-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["chan\_src"]         - the audiochannel-source of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["snd\_src"]          - the send-to-channel-target of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan\_law"]           - pan-law, default is -1  
      table[tracknumber][AUXSendReceivesIndex]["midichanflag"]      - the Midi-channel of this AUXSendReceivesIndex of tracknumber, leave it 0  
      table[tracknumber][AUXSendReceivesIndex]["automation"]        - the automation-mode of this AUXSendReceivesIndex  of tracknumber  
      
      See [GetTrackAUXSendReceives](#GetTrackAUXSendReceives) for more details on the individual settings, stored in the entries.
      
      returns false in case of an error
  </description>
  <parameters>
    table AllAUXSendReceives - a table with all AllAUXSendReceive-entries of the current project
    optional integer option - nil or 1, AUXRecvs will be applied to Track 1 to table["number_of_tracks"]; 2, AUXRecvs will be applied to the tracks with the guid TrackID
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, set, all, send, receive, aux, routing</tags>
</US_DocBloc>
]]
  if type(AllAUXSendReceives)~="table" then ultraschall.AddErrorMessage("GetAllAUXSendReceives", "AllAUXSendReceives", "Must be a table.", -1) return false end
  if AllAUXSendReceives["number_of_tracks"]==nil or AllAUXSendReceives["AllAUXSendReceives"]~=true then ultraschall.AddErrorMessage("GetAllAUXSendReceives", "AllAUXSendReceives", "Must be a valid AllAUXSendReceives, as returned by GetAllAUXSendReceive. Get it from there, alter that and pass it into here.", -2) return false end 

  local trackstatechunk, retval, b
  
  for i=1, AllAUXSendReceives["number_of_tracks"] do
    if option~=2 then b=i
    else b=ultraschall.GetTracknumberByGuid(AllAUXSendReceives[i]["TrackID"]) 
    end
    retval, trackstatechunk = ultraschall.GetTrackStateChunk_Tracknumber(b)
--    print_alt(b,i, ultraschall.IsValidTrackStateChunk(trackstatechunk),"\n")
    
    for a=1, AllAUXSendReceives[i]["AUXSendReceives_count"] do
      if option~=2 then
        retval, trackstatechunk=ultraschall.SetTrackAUXSendReceives(-1, a, 
             AllAUXSendReceives[i][a]["recv_tracknumber"],
             AllAUXSendReceives[i][a]["post_pre_fader"],
             AllAUXSendReceives[i][a]["volume"], 
             AllAUXSendReceives[i][a]["pan"], 
             AllAUXSendReceives[i][a]["mute"], 
             AllAUXSendReceives[i][a]["mono_stereo"], 
             AllAUXSendReceives[i][a]["phase"], 
             AllAUXSendReceives[i][a]["chan_src"], 
             AllAUXSendReceives[i][a]["snd_src"], 
             AllAUXSendReceives[i][a]["pan_law"], 
             AllAUXSendReceives[i][a]["midichanflag"], 
             AllAUXSendReceives[i][a]["automation"],
             trackstatechunk)--]]
      else
           retval, trackstatechunk=ultraschall.SetTrackAUXSendReceives(-1, a, 
                ultraschall.GetTracknumberByGuid(AllAUXSendReceives[i][a]["recv_track_guid"])-1,
                AllAUXSendReceives[i][a]["post_pre_fader"],
                AllAUXSendReceives[i][a]["volume"], 
                AllAUXSendReceives[i][a]["pan"], 
                AllAUXSendReceives[i][a]["mute"], 
                AllAUXSendReceives[i][a]["mono_stereo"], 
                AllAUXSendReceives[i][a]["phase"], 
                AllAUXSendReceives[i][a]["chan_src"], 
                AllAUXSendReceives[i][a]["snd_src"], 
                AllAUXSendReceives[i][a]["pan_law"], 
                AllAUXSendReceives[i][a]["midichanflag"], 
                AllAUXSendReceives[i][a]["automation"],
                trackstatechunk)--]]
      end
    end
      ultraschall.SetTrackStateChunk_Tracknumber(b, trackstatechunk, false)
      --print(P)
  end
  return true
end


function ultraschall.GetAllMainSendStates()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMainSendStates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>table AllMainSends, integer number_of_tracks  = ultraschall.GetAllMainSendStates()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all MainSend-settings of all tracks, excluding master-track.
    
    The MainSend-settings are the settings, if a certain track sends it's signal to the Master Track
    
    returned table is of structure:
      Table["number\_of_tracks"]            - The number of tracks in this table, from track 1 to track n  
      Table["MainSend"]=true               - signals, this is an AllMainSends-table  
      table[tracknumber]["TrackID"]        - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      Table[tracknumber]["MainSendOn"]     - Send to Master on(1) or off(1)  
      Table[tracknumber]["ParentChannels"] - the parent channels of this track  
      
      See [GetTrackMainSendState](#GetTrackMainSendState) for more details on the individual settings, stored in the entries.
  </description>
  <retvals>
    table AllMainSends - a table with all AllMainSends-entries of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, get, all, send, main send, master send, routing</tags>
</US_DocBloc>
]]
  
  local MainSend={}
  MainSend["number_of_tracks"]=reaper.CountTracks()
  MainSend["MainSend"]=true
  for i=1, reaper.CountTracks() do
    MainSend[i]={}
    MainSend[i]["TrackID"]=reaper.BR_GetMediaTrackGUID(reaper.GetTrack(0,i-1))
    MainSend[i]["MainSendOn"], MainSend[i]["ParentChannels"] = ultraschall.GetTrackMainSendState(i)
  end
  return MainSend, reaper.CountTracks()
end

--A,B=ultraschall.GetAllMainSendStates()

function ultraschall.ApplyAllMainSendStates(AllMainSendsTable, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyAllMainSendStates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyAllMainSendStates(table AllMainSendsTable, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    takes a table, as returned by [GetAllMainSendStates](#GetAllMainSendStates) with all MainSend-settings of all tracks and applies it to all tracks.
    
    The MainSend-settings are the settings, if a certain track sends it's signal to the Master Track.
    
    When you set option to 2, the individual entries will be applied to the tracks, that have the guids stored in table
    table[tracknumber]["TrackID"], otherwise, this function will apply it to track0 to trackn, which is the same as table["number\_of_tracks"].
    That way, you can create RoutingSnapshots, that will stay in the right tracks, even if they are ordered differently or when tracks have been added/deleted.
    
    This influences the MasterTrack as well!
    
    expected table is of structure:
      Table["number\_of_tracks"]            - The number of tracks in this table, from track 1 to track n  
      Table["MainSend"]=true               - signals, this is an AllMainSends-table  
      table[tracknumber]["TrackID"]        - the unique id of the track as guid; can be used to get the MediaTrack using reaper.BR_GetMediaTrackByGUID(0, guid)  
      Table[tracknumber]["MainSendOn"]     - Send to Master on(1) or off(1)  
      Table[tracknumber]["ParentChannels"] - the parent channels of this track  
      
      See [GetTrackMainSendState](#GetTrackMainSendState) for more details on the individual settings, stored in the entries.
      
      returns false in case of an error
  </description>
  <parameters>
    table AllMainSends - a table with all AllMainSends-entries of the current project
    optional integer option - nil or 1, MainSend-settings will be applied to Track 1 to table["number_of_tracks"]; 2, MasterSends will be applied to the tracks with the guid stored in table[tracknumber]["TrackID"].
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, track, set, all, send, main send, master send, routing</tags>
</US_DocBloc>
]]
  if type(AllMainSendsTable)~="table" then ultraschall.AddErrorMessage("ApplyAllMainSendStates", "AllMainSendsTable", "Must be a table.", -1) return false end
  if AllMainSendsTable["number_of_tracks"]==nil or AllMainSendsTable["MainSend"]==nil  then 
    ultraschall.AddErrorMessage("ApplyAllMainSendStates", "AllMainSendsTable", "Must be a valid AllMainSendsTable, as returned by GetAllMainSendStates. Get it from there, alter that and pass it into here.", -2) return false 
  end
  local a
  for i=1, AllMainSendsTable["number_of_tracks"] do
    if option~=2 then a=i
    else a=ultraschall.GetTracknumberByGuid(AllMainSendsTable[i]["TrackID"]) 
    end
    ultraschall.SetTrackMainSendState(a, AllMainSendsTable[i]["MainSendOn"], AllMainSendsTable[i]["ParentChannels"])
  end
  return true
end


function ultraschall.AreHWOutsTablesEqual(Table1, Table2, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AreHWOutsTablesEqual</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval  = ultraschall.AreHWOutsTablesEqual(table AllHWOuts, table AllHWOuts2, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Compares two HWOuts-tables, as returned by [GetAllHWOuts](#GetAllHWOuts) or [GetAllHWOuts2](#GetAllHWOuts)

    if option=2 then it will also compare, if the stored track-guids are the equal. Otherwise, it will only check the individual settings, even if the guids are different between the two tables.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if the two tables are equal HWOuts; false, if not
  </retvals>
  <parameters>
    table AllHWOuts - a table with all HWOut-settings of all tracks
    table AllHWOuts2 - a table with all HWOut-settings of all tracks, that you want to compare to AllHWOuts
    optional integer option - nil or 1, to compare everything, except the stored TrackGuids; 2, include comparing the stored TrackGuids as well
  </parameters>
  <chapter_context>
    Track Management
    Hardware Out
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, compare, equal, hwouttable</tags>
</US_DocBloc>
]]
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["HWOuts"]~=true or Table2["HWOuts"]~=true then return false end
  if Table1["HWOuts"]~=Table2["HWOuts"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=0, Table1["number_of_tracks"] do
    if Table1[i]["HWOut_count"]~=Table2[i]["HWOut_count"] then return false end
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    for a=1, Table1[i]["HWOut_count"] do
      if option==2 and Table1[i]["TrackID"]~=Table2[i]["TrackID"] then return false end
      if Table1[i][a]["automationmode"]~=Table2[i][a]["automationmode"] then return false end
      if Table1[i][a]["mute"]~=Table2[i][a]["mute"] then return false end
      if Table1[i][a]["outputchannel"]~=Table2[i][a]["outputchannel"] then return false end
      if Table1[i][a]["pan"]~=Table2[i][a]["pan"] then return false end
      if Table1[i][a]["phase"]~=Table2[i][a]["phase"] then return false end
      if Table1[i][a]["post_pre_fader"]~=Table2[i][a]["post_pre_fader"] then return false end
      if Table1[i][a]["source"]~=Table2[i][a]["source"] then return false end
      if Table1[i][a]["pan_law"]~=Table2[i][a]["pan_law"] then return false end
      if Table1[i][a]["volume"]~=Table2[i][a]["volume"] then return false end
    end
  end
  return true
end

--AllHWOuts=ultraschall.GetAllHWOuts2()
--AllHWOuts2=ultraschall.GetAllHWOuts2()
--AllHWOuts[0]["TrackID"]=3
--AAAA=ultraschall.AreHWOutsTablesEqual(AllHWOuts, AllHWOuts2, 1)



--AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates2() 
--AllMainSends2, number_of_tracks = ultraschall.GetAllMainSendStates2() 

function ultraschall.AreMainSendsTablesEqual(Table1, Table2, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AreMainSendsTablesEqual</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval  = ultraschall.AreMainSendsTablesEqual(table AllMainSends, table AllMainSends2, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Compares two AllMainSends-tables, as returned by [GetAllMainSendStates](#GetAllMainSendStates) or [GetAllMainSendStates2](#GetAllMainSendStates2)

    if option=2 then it will also compare, if the stored track-guids are the equal. Otherwise, it will only check the individual settings, even if the guids are different between the two tables.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if the two tables are equal AllMainSends; false, if not
  </retvals>
  <parameters>
    table AllMainSends - a table with all AllMainSends-settings of all tracks
    table AllMainSends2 - a table with all AllMainSends-settings of all tracks, that you want to compare to AllMainSends
    optional integer option - nil or 1, to compare everything, except the stored TrackGuids; 2, include comparing the stored TrackGuids as well
  </parameters>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, compare, equal, allmainsendstable</tags>
</US_DocBloc>
]]
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["MainSend"]~=true or Table2["MainSend"]~=true then return false end
  if Table1["MainSend"]~=Table2["MainSend"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=1, Table1["number_of_tracks"] do
    if option==2 and Table1[i]["TrackID"]~=Table2[i]["TrackID"] then return false end
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    if Table1[i]["MainSendOn"]~=Table2[i]["MainSendOn"] then return false end
    if Table1[i]["ParentChannels"]~=Table2[i]["ParentChannels"] then return false end
  end
  return true
end

--AllMainSends[1]["TrackID"]=0

--AA=ultraschall.AreMainSendsTablesEqual(AllMainSends, AllMainSends2,2)



--AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives2()
--AllAUXSendReceives2, number_of_tracks = ultraschall.GetAllAUXSendReceives2()

function ultraschall.AreAUXSendReceivesTablesEqual(Table1, Table2, option)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AreAUXSendReceivesTablesEqual</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval  = ultraschall.AreAUXSendReceivesTablesEqual(table AllAUXSendReceives, table AllAUXSendReceives2, optional integer option)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Compares two AllAUXSendReceives-tables, as returned by [GetAllAUXSendReceives](#GetAllAUXSendReceives) or [GetAllAUXSendReceives2](#GetAllAUXSendReceives2)
    
    if option=2 then it will also compare, if the stored track-guids are the equal. Otherwise, it will only check the individual settings, even if the guids are different between the two tables.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if the two tables are equal AllMainSends; false, if not
  </retvals>
  <parameters>
    table AllAUXSendReceives - a table with all AllAUXSendReceives-settings of all tracks
    table AllAUXSendReceives2 - a table with all AllAUXSendReceives-settings of all tracks, that you want to compare to AllAUXSendReceives
    optional integer option - nil or 1, to compare everything, except the stored TrackGuids; 2, include comparing the stored TrackGuids as well
  </parameters>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Routing_Module.lua</source_document>
  <tags>trackmanagement, compare, equal, allauxsendreceivestables</tags>
</US_DocBloc>
]]
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["AllAUXSendReceives"]~=true or Table2["AllAUXSendReceives"]~=true then return false end
  if Table1["AllAUXSendReceives"]~=Table2["AllAUXSendReceives"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=1, Table1["number_of_tracks"] do
    if Table1[i]["AUXSendReceives_count"]~=Table2[i]["AUXSendReceives_count"] then return false end
    if option==2 and Table1[i]["TrackID"]~=Table2[i]["TrackID"] then return false end
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    for a=1, Table1[i]["AUXSendReceives_count"] do
      if Table1[i][a]["automation"]~=Table2[i][a]["automation"] then return false end
      if Table1[i][a]["chan_src"]~=Table2[i][a]["chan_src"] then return false end
      if Table1[i][a]["midichanflag"]~=Table2[i][a]["midichanflag"] then return false end
      if Table1[i][a]["mono_stereo"]~=Table2[i][a]["mono_stereo"] then return false end
      if Table1[i][a]["mute"]~=Table2[i][a]["mute"] then return false end
      if Table1[i][a]["pan"]~=Table2[i][a]["pan"] then return false end
      if Table1[i][a]["phase"]~=Table2[i][a]["phase"] then return false end
      if Table1[i][a]["post_pre_fader"]~=Table2[i][a]["post_pre_fader"] then return false end
      if Table1[i][a]["recv_tracknumber"]~=Table2[i][a]["recv_tracknumber"] then return false end
      if option==2 and Table1[i][a]["recv_track_guid"]~=Table2[i][a]["recv_track_guid"] then return false end
      if Table1[i][a]["snd_src"]~=Table2[i][a]["snd_src"] then return false end
      if Table1[i][a]["pan_law"]~=Table2[i][a]["pan_law"] then return false end
      if Table1[i][a]["volume"]~=Table2[i][a]["volume"] then return false end
    end
  end
  return true
end

--AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives2()
--AllAUXSendReceives2, number_of_tracks = ultraschall.GetAllAUXSendReceives2()
--AllAUXSendReceives[1]["TrackID"]=1
--A=ultraschall.AreAUXSendReceivesTablesEqual(AllAUXSendReceives, AllAUXSendReceives2, 1)

