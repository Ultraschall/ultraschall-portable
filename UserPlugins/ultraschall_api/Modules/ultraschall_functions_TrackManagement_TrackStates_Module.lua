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
---     Track: States Module     ---
-------------------------------------

function ultraschall.GetTrackStateChunk_Tracknumber(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackStateChunk_Tracknumber</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string trackstatechunk = ultraschall.GetTrackStateChunk_Tracknumber(integer tracknumber)</functioncall>
  <description>
    returns the trackstatechunk for track tracknumber
    
    returns false in case of an error
  </description>
  <parameters>
    integer tracknumber - the tracknumber, 0 for master track, 1 for track 1, 2 for track 2, etc.    
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of error
    string trackstatechunk - the trackstatechunk for track tracknumber
  </retvals>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstatechunk, get</tags>
</US_DocBloc>
]]
  -- prepare variables
  local Track, A, AA, Overflow
  
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackStateChunk_Tracknumber","tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackStateChunk_Tracknumber","tracknumber", "only tracknumbers allowed between 0(master), 1(track1) and "..reaper.CountTracks(0).."(last track in this project)", -2) return false end
  
  -- Get Mastertrack, if tracknumber=0
  if tracknumber==0 then Track=reaper.GetMasterTrack(0)
  else Track=reaper.GetTrack(0,tracknumber-1)
  end

  return reaper.GetTrackStateChunk(Track, "", false)
end

function ultraschall.GetTrackState_NumbersOnly(state, TrackStateChunk, functionname, numbertoggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackState_NumbersOnly</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table values = ultraschall.GetTrackState_NumbersOnly(string state, optional string TrackStateChunk, optional string functionname, optional boolean numbertoggle)</functioncall>
  <description>
    returns a state of a TrackStateChunk.
    
    It only supports single-entry-states with numbers/integers, separated by spaces!
    All other values will be set to nil and strings with spaces will produce weird results!
    
    returns nil in case of an error
  </description>
  <parameters>
    string state - the state, whose attributes you want to retrieve
    string TrackStateChunk - a statechunk of a track
    optional string functionname - if this function is used within specific gettrackstate-functions, pass here the "host"-functionname, so error-messages will reflect that
    optional boolean numbertoggle - true or nil; converts all values to numbers; false, keep them as string versions
  </parameters>
  <retvals>
    table values - all values found as numerical indexed array
  </retvals>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, get, state, trackstatechunk</tags>
</US_DocBloc>
]]
  if functionname~=nil and type(functionname)~="string" then ultraschall.AddErrorMessage(functionname,"functionname", "Must be a string or nil!", -6) return nil end
  if functionname==nil then functionname="GetTrackState_NumbersOnly" end
  if type(state)~="string" then ultraschall.AddErrorMessage(functionname, "state", "Must be a string", -7) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage(functionname,"TrackStateChunk", "No valid TrackStateChunk!", -2) return nil end
  
  TrackStateChunk=TrackStateChunk:match(state.." (.-)\n")
  if TrackStateChunk==nil then return end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(TrackStateChunk, " ")
  if numbertoggle~=false then
    for i=1, count do
      individual_values[i]=tonumber(individual_values[i])
    end
  end
  return table.unpack(individual_values)
end

--------------------------
---- Get Track States ----
--------------------------

function ultraschall.GetTrackName(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackname = ultraschall.GetTrackName(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns name of the track.
    
    It's the entry NAME
    
    returns nil in case of an error
  </description>
  <retvals>
    string trackname  - the name of the track
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, name, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackName", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackName", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  
  -- get trackname
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackName", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
  local Track_Name=str:match("NAME (.-)%c")
  return Track_Name
end

function ultraschall.GetTrackPeakColorState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackPeakColorState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer PeakColorState = ultraschall.GetTrackPeakColorState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns state of the PeakColor-number, which is the trackcolor. Will be returned as string, to avoid losing trailing or preceding zeros.
    
    It's the entry PEAKCOL
    
    returns nil in case of an error
  </description>
  <retvals>
    string PeakColorState  - the color of the track
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackcolor, color, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("PEAKCOL", str, "GetTrackPeakColorState", true)
end

--A=ultraschall.GetTrackPeakColorState(2)

function ultraschall.GetTrackBeatState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackBeatState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number BeatState = ultraschall.GetTrackBeatState(integer tracknumber,optional string TrackStateChunk)</functioncall>
  <description>
    returns Track-BeatState. 

    It's the entry BEAT
    
    returns nil in case of an error
  </description>
  <retvals>
    number BeatState  - -1 - Project time base; 0 - Time; 1 - Beats position, length, rate; 2 - Beats position only
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, beat, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("BEAT", str, "GetTrackBeatState", true)
end

--A=ultraschall.GetTrackBeatState(1)

function ultraschall.GetTrackAutoRecArmState(tracknumber, str)
-- returns nil, if it's unset
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackAutoRecArmState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer AutoRecArmState = ultraschall.GetTrackAutoRecArmState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns if the track is in AutoRecArm, when selected. Returns nil if not.

    It's the entry AUTO_RECARM
    
    returns nil in case of an error
  </description>
  <retvals>
    integer AutoRecArmState  - state of autorecarm; 1 for set; nil, if unset
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, autorecarm, rec, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("AUTO_RECARM", str, "GetTrackAutoRecArmState", true)
end

--A=ultraschall.GetTrackAutoRecArmState(1)
  
function ultraschall.GetTrackMuteSoloState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMuteSoloState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer Mute, integer Solo, integer SoloDefeat = ultraschall.GetTrackMuteSoloState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns states of Mute and Solo-Buttons.
    
    It's the entry MUTESOLO
    
    returns nil in case of an error
  </description>
  <retvals>
    integer Mute - Mute set to 0 - Mute off, 1 - Mute On
    integer Solo - Solo set to 0 - Solo off, 1 - Solo ignore routing, 2 - Solo on
    integer SoloDefeat  - SoloDefeat set to 0 - off, 1 - on
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, mute, solo, solodefeat, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("MUTESOLO", str, "GetTrackMuteSoloState", true)
end

--A1,A2,A3 = ultraschall.GetTrackMuteSoloState(1)
  
function ultraschall.GetTrackIPhaseState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackIPhaseState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number IPhase = ultraschall.GetTrackIPhaseState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns state of the IPhase. If the Phase-button is pressed, it will return 1, else it will return 0.
    
    It's the entry IPHASE
    
    returns nil in case of an error
  </description>
  <retvals>
    number IPhase  - state of the phase-button; 0, normal phase; 1, inverted phase(180°)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, iphase, phase, button, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("IPHASE", str, "GetTrackIPhaseState", true)
end
--A=ultraschall.GetTrackIPhaseState(1)

function ultraschall.GetTrackIsBusState(tracknumber, str)
-- for folder-management
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackIsBusState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer busstate1, integer busstate2 = ultraschall.GetTrackIsBusState(integer tracknumber, optional string trackstatechunk)</functioncall>
  <description>
    returns busstate of the track, means: if it's a folder track
    
    It's the entry ISBUS
    
    busstate1=0, busstate2=0 - track is no folder
    - or
    busstate1=1, busstate2=1 - track is a folder
    - or
    busstate1=1, busstate2=2 - track is a folder but view of all subtracks not compactible
    - or
    busstate1=2, busstate2=-1 - track is last track in folder(no tracks of subfolders follow)
    
    returns nil in case of an error
  </description>
  <retvals>
    integer busstate1 - refer to description for details
    integer busstate2 - refer to description for details
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, busstate, folder, subfolders, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("ISBUS", str, "GetTrackIsBusState", true)
end


function ultraschall.GetTrackBusCompState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackBusCompState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>number BusCompState1, number BusCompState2, number BusCompState3, number BusCompState4, number BusCompState5 = ultraschall.GetTrackBusCompState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns BusCompState, if the tracks in a folder are compacted or not.
    
    It's the entry BUSCOMP
    
    returns nil in case of an error
  </description>
  <retvals>
    number BusCompState1 - 0 - no compacting, 1 - compacted tracks, 2 - minimized tracks
    number BusCompState2 - 0 - unknown,1 - unknown
    number BusCompState3 - 0 - unknown,1 - unknown
    number BusCompState4 - 0 - unknown,1 - unknown
    number BusCompState5 - 0 - unknown,1 - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, busstate, folder, subfolders, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("BUSCOMP", str, "GetTrackBusCompState", true)
end

--A,A2=ultraschall.GetTrackBusCompState(1)

function ultraschall.GetTrackShowInMixState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackShowInMixState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer MCPvisible, number MCP_FX_visible, number MCPTrackSendsVisible, integer TCPvisible, number ShowInMix5, number ShowInMix6, number ShowInMix7, number ShowInMix8 = ultraschall.GetTrackShowInMixState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Show in Mix-state.
    
    It's the entry SHOWINMIX
    
    returns nil in case of an error
  </description>
  <retvals>
     integer MCPvisible - 0 invisible, 1 visible
     number MCP_FX_visible - 0 visible, 1 FX-Parameters visible, 2 invisible
     number MCPTrackSendsVisible - 0 & 1.1 and higher TrackSends in MCP visible, every other number makes them invisible
     integer TCPvisible - 0 track is invisible in TCP, 1 track is visible in TCP
     number ShowInMix5 - unknown
     number ShowInMix6 - unknown
     number ShowInMix7 - unknown
     number ShowInMix8  - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, mixer, show, mcp, tcp, fx, visible, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("SHOWINMIX", str, "GetTrackShowInMixState", true)
end
--A1,A2,A3,A4,A5,A6,A7,A8=ultraschall.GetTrackShowInMixState(2)

function ultraschall.GetTrackFreeModeState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackFreeModeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer FreeModeState = ultraschall.GetTrackFreeModeState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns if the track has track free item positioning enabled(1) or not(0).
    
    It's the entry FREEMODE
    
    returns nil in case of an error
  </description>
  <retvals>
    integer FreeModeState  - 1 - enabled, 0 - not enabled
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackfreemode, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("FREEMODE", str, "GetTrackFreeModeState", true)
end

--A=ultraschall.GetTrackFreeModeState(2)

function ultraschall.GetTrackRecState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackRecState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer ArmState, integer InputChannel, integer MonitorInput, integer RecInput, integer MonitorWhileRec, integer presPDCdelay, integer RecordingPath = ultraschall.GetTrackRecState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Track Rec State.
    
    It's the entry REC
    
    returns nil in case of an error
  </description>
  <retvals>
    integer ArmState - returns 1(armed) or 0(unarmed)    
     integer InputChannel - returns the InputChannel
    --1 - No Input
    -1-16(more?) - Mono Input Channel
    -1024 - Stereo Channel 1 and 2
    -1026 - Stereo Channel 3 and 4
    -1028 - Stereo Channel 5 and 6
    -...
    -5056 - Virtual MIDI Keyboard all Channels
    -5057 - Virtual MIDI Keyboard Channel 1
    -...
    -5072 - Virtual MIDI Keyboard Channel 16
    -5088 - All MIDI Inputs - All Channels
    -5089 - All MIDI Inputs - Channel 1
    -...
    -5104 - All MIDI Inputs - Channel 16    
     integer MonitorInput - 0 monitor off, 1 monitor on, 2 monitor on tape audio style     
     integer RecInput - returns rec-input type
    -0 input(Audio or Midi)
    -1 Record Output Stereo
    -2 Disabled, Input Monitoring Only
    -3 Record Output Stereo, Latency Compensated
    -4 Record Output MIDI
    -5 Record Output Mono
    -6 Record Output Mono, Latency Compensated
    -7 MIDI overdub
    -8 MIDI replace
    -9 MIDI touch replace
    -10 Record Output Multichannel
    -11 Record Output Multichannel, Latency Compensated 
    -12 Record Input Force Mono
    -13 Record Input Force Stereo
    -14 Record Input Force Multichannel
    -15 Record Input Force MIDI
    -16 MIDI latch replace
     integer MonitorWhileRec - Monitor Trackmedia when recording, 0 is off, 1 is on
     integer presPDCdelay - preserve PDC delayed monitoring in media items
     integer RecordingPath  - recording path used 
    -0 - Primary Recording-Path only
    -1 - Secondary Recording-Path only
    -2 - Primary Recording Path and Secondary Recording Path(for invisible backup)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, midi, recordingpath, path, input, recinput, pdc, monitor, arm, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("REC", str, "GetTrackRecState", true)
end

function ultraschall.GetTrackVUState(tracknumber, str)
-- returns 0 if MultiChannelMetering is off
-- returns 2 if MultichannelMetering is on
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackVUState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer VUState = ultraschall.GetTrackVUState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns VUState. 
    
    It's the entry VU
    
    returns nil in case of an error
  </description>
  <retvals>
    integer VUState  - nil if MultiChannelMetering is off, 2 if MultichannelMetering is on, 3 Metering is off
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, vu, metering, meter, multichannel, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("VU", str, "GetTrackVUState", true)
end

function ultraschall.GetTrackHeightState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackHeightState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>integer height, integer heightstate2, integer unknown = ultraschall.GetTrackHeightState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns height of the track.
    
    It's the entry TRACKHEIGHT
    
    returns nil in case of an error
  </description>
  <retvals>
    integer height - 24 up to 443
    integer heightstate2 - 0 - use height, 1 - compact the track and ignore the height
    integer lock_trackheight - 0, don't lock the trackheight; 1, lock the trackheight
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, height, compact, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("TRACKHEIGHT", str, "GetTrackHeightState", true)
end
    
--A,B,C=ultraschall.GetTrackHeightState(1)
    
function ultraschall.GetTrackINQState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackINQState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer quantMIDI, integer quantPOS, integer quantNoteOffs, number quantToFractBeat, integer quantStrength, integer swingStrength, integer quantRangeMin, integer quantRangeMax =  ultraschall.GetTrackINQState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    Gets INQ-state, mostly the quantize-settings for MIDI, as set in the "Track: View track recording settings (MIDI quantize, file format/path) for last touched track"-dialog (action 40604)
    
    It's the entry INQ
    
    returns nil in case of an error
  </description>
  <retvals>
    integer quantMIDI -  quantize MIDI; 0 or 1
    integer quantPOS -  quantize to position; -1,prev; 0, nearest; 1, next
    integer quantNoteOffs -  quantize note-offs; 0 or 1
    number quantToFractBeat -  quantize to (fraction of beat)
    integer quantStrength -  quantize strength; -128 to 127
    integer swingStrength -  swing strength; -128 to 127
    integer quantRangeMin -  quantize range minimum; -128 to 127
    integer quantRangeMax -  quantize range maximum; -128 to 127
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, inq, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("INQ", str, "GetTrackINQState", true)
end

function ultraschall.GetTrackNChansState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackNChansState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer channelnumber = ultraschall.GetTrackNChansState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the number of channels for this track, as set in the routing.
    
    It's the entry NCHAN
    
    returns nil in case of an error
  </description>
  <retvals>
    integer channelnumber  - number of channels for this track
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, channels, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("NCHAN", str, "GetTrackNChansState", true)
end


function ultraschall.GetTrackBypFXState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackBypFXState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer FXState = ultraschall.GetTrackBypFXState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the off/bypass(0) or nobypass(1) state of the FX-Chain
    
    It's the entry FX
    
    returns nil in case of an error
  </description>
  <retvals>
    integer FXState - off/bypass(0) or nobypass(1)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, bypass, fx, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("FX", str, "GetTrackBypFXState", true)
end



function ultraschall.GetTrackPerfState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackPerfState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer TrackPerfState = ultraschall.GetTrackPerfState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns TrackPerformance-state
    
    It's the entry PERF
    
    returns nil in case of an error
  </description>
  <retvals>
    integer TrackPerfState  - TrackPerformance-state
    -0 - allow anticipative FX + allow media buffering
    -1 - allow anticipative FX + prevent media buffering 
    -2 - prevent anticipative FX + allow media buffering
    -3 - prevent anticipative FX + prevent media buffering
    -settings seem to repeat with higher numbers (e.g. 4(like 0) - allow anticipative FX + allow media buffering)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, trackperformance, fx, buffering, media, anticipative, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("PERF", str, "GetTrackPerfState", true)
end

function ultraschall.GetTrackMIDIOutState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMIDIOutState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer MidiOutState = ultraschall.GetTrackMIDIOutState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns MIDI_Out-State, as set in the Routing-Settings
    
    It's the entry MIDIOUT
    
    returns nil in case of an error
  </description>
  <retvals>
    integer MidiOutState  - MIDI_Out-State, as set in the Routing-Settings
    --1 no output
    -416 - microsoft GS wavetable synth - send to original channels
    -417-432 - microsoft GS wavetable synth - send to channel state minus 416
    --31 - no Output, send to original channel 1
    --16 - no Output, send to original channel 16
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, midi, outstate, routing, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("MIDIOUT", str, "GetTrackMIDIOutState", true)
end

function ultraschall.GetTrackMainSendState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMainSendState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer MainSendOn, integer ParentChannels = ultraschall.GetTrackMainSendState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns, if Main-Send is on(1) or off(0) and the ParentChannels(0-63), as set in the Routing-Settings.
    
    It's the entry MAINSEND
    
    returns nil in case of an error
  </description>
  <retvals>
    integer MainSendOn - Main-Send is on(1) or off(0)
    integer ParentChannels - ParentChannels(0-63)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, parent, channel, send, main, routing, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("MAINSEND", str, "GetTrackMainSendState", true)
end

--A,AA= ultraschall.GetTrackMainSendState(-1,"")

function ultraschall.GetTrackGroupFlagsState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackGroupFlagsState</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    Lua=5.3
  </requires>
  <functioncall>integer GroupState_as_Flags, array IndividualGroupState_Flags = ultraschall.GetTrackGroupFlagsState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the state of the group-flags, as set in the menu Track Grouping Parameters. Returns a 23bit flagvalue as well as an array with 32 individual 23bit-flagvalues. You must use bitoperations to get the individual values.
    
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table contains up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to get Volume Master(table entry 1) to check if it's set in Group 1(2^0=1) and 3(2^2=4):
      group1=groups_bitfield_table[1]&1
      group2=groups_bitfield_table[1]&4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Follow
                           3 - Pan Master
                           4 - Pan Follow
                           5 - Mute Master
                           6 - Mute Follow
                           7 - Solo Master
                           8 - Solo Follow
                           9 - Record Arm Master
                           10 - Record Arm Follow
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Follow
                           13 - Automation Mode Master
                           14 - Automation Mode Follow
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Follow
                           21 - VCA Master
                           22 - VCA Follow
                           23 - VCA pre-FX Follow
                           24 - Media/Razor Edit Lead
                           25 - Media/Razor Edit Lead
    
    The GroupState_as_Flags-bitfield is a hint, if a certain flag is set in any of the groups. So, if you want to know, if VCA Master is set in any group, check if flag &1048576 (2^20) is set to 1048576.
    
    This function will work only for Groups 1 to 32. To get Groups 33 to 64, use <a href="#GetTrackGroupFlags_HighState">GetTrackGroupFlags_HighState</a> instead!
    
    It's the entry GROUP_FLAGS
    
    returns -1 in case of failure
  </description>
  <retvals>
    integer GroupState_as_Flags - returns a flagvalue with 23 bits, that tells you, which grouping-flag is set in at least one of the 32 groups available.
    -returns -1 in case of failure
    -
    -the following flags are available:
    -&1 - Volume Master
    -&2 - Volume Follow
    -&4 - Pan Master
    -&8 - Pan Follow
    -&16 - Mute Master
    -&32 - Mute Follow
    -&64 - Solo Master
    -&128 - Solo Follow
    -&256 - Record Arm Master
    -&512 - Record Arm Follow
    -&1024 - Polarity/Phase Master
    -&2048 - Polarity/Phase Follow
    -&4096 - Automation Mode Master
    -&8192 - Automation Mode Follow
    -&16384 - Reverse Volume
    -&32768 - Reverse Pan
    -&65536 - Do not master when slaving
    -&131072 - Reverse Width
    -&262144 - Width Master
    -&524288 - Width Follow
    -&1048576 - VCA Master
    -&2097152 - VCA Follow
    -&4194304 - VCA pre-FX Follow
    -&8388608 - Media/Razor Edit Lead
    -&16777216 - Media/Razor Edit Follow
     array IndividualGroupState_Flags  - returns an array with 23 entries. Every entry represents one of the GroupState_as_Flags, but it's value is a flag, that describes, in which of the 32 Groups a certain flag is set.
    -e.g. If Volume Master is set only in Group 1, entry 1 in the array will be set to 1. If Volume Master is set on Group 2 and Group 4, the first entry in the array will be set to 10.
    -refer to the upper GroupState_as_Flags list to see, which entry in the array is for which set flag, e.g. array[22] is VCA pre-F Follow, array[16] is Do not master when slaving, etc
    -As said before, the values in each entry is a flag, that tells you, which of the groups is set with a certain flag. The following flags determine, in which group a certain flag is set:
    -&1 - Group 1
    -&2 - Group 2
    -&4 - Group 3
    -&8 - Group 4
    -etc...
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, group, groupstate, individual, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackGroupFlagsState", "tracknumber", "must be an integer", -1) return -1 end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackGroupFlagsState", "tracknumber", "no such track", -2) return -1 end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if ultraschall.IsValidTrackStateChunk(str)==false then ultraschall.AddErrorMessage("GetTrackGroupFlagsState", "TrackStateChunk", "no valid TrackStateChunk", -3) return -1 end    
  local retval=0

  local Track_TrackGroupFlags=str:match("GROUP_FLAGS.-%c") 
  if Track_TrackGroupFlags==nil then ultraschall.AddErrorMessage("GetTrackGroupFlagsState", "", "no trackgroupflags available", -4) return -1 end
  
  -- get groupflags-state  
  local GroupflagString = Track_TrackGroupFlags:match("GROUP_FLAGS (.-)%c")
  local count, Tracktable=ultraschall.CSV2IndividualLinesAsArray(GroupflagString, " ")

  for i=1,32 do
    Tracktable[i]=tonumber(Tracktable[i])
    if Tracktable[i]==nil then Tracktable[i]=0 end
    if Tracktable[i]~=nil and Tracktable[i]>=1 then retval=retval+2^(i-1) end
  end
  
  return retval, Tracktable
end

function ultraschall.GetTrackGroupFlags_HighState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackGroupFlags_HighState</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    Lua=5.3
  </requires>
  <functioncall>integer GroupState_as_Flags, array IndividualGroupState_Flags = ultraschall.GetTrackGroupFlags_HighState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the state of the group-flags, as set in the menu Track Grouping Parameters. Returns a 23bit flagvalue as well as an array with 32 individual 23bit-flagvalues. You must use bitoperations to get the individual values.
    
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table contains up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to get Volume Master(table entry 1) to check if it's set in Group 33(2^0=1) and 35(2^2=4):
      group1=groups_bitfield_table[1]&1
      group2=groups_bitfield_table[1]&4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Follow
                           3 - Pan Master
                           4 - Pan Follow
                           5 - Mute Master
                           6 - Mute Follow
                           7 - Solo Master
                           8 - Solo Follow
                           9 - Record Arm Master
                           10 - Record Arm Follow
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Follow
                           13 - Automation Mode Master
                           14 - Automation Mode Follow
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Follow
                           21 - VCA Master
                           22 - VCA Follow
                           23 - VCA pre-FX Follow
                           24 - Media/Razor Edit Lead
                           25 - Media/Razor Edit Lead    
    The GroupState_as_Flags-bitfield is a hint, if a certain flag is set in any of the groups. So, if you want to know, if VCA Master is set in any group, check if flag &1048576 (2^20) is set to 1048576.
    
    This function will work only for Groups 33(2^0) to 64(2^31). To get Groups 1 to 32, use <a href="#GetTrackGroupFlagsState">GetTrackGroupFlagsState</a> instead!
    
    It's the entry GROUP_FLAGS_HIGH
    
    returns -1 in case of failure
  </description>
  <retvals>
    integer GroupState_as_Flags - returns a flagvalue with 23 bits, that tells you, which grouping-flag is set in at least one of the 32 groups available.
    -returns -1 in case of failure
    -
    -the following flags are available:
    -&1 - Volume Master
    -&2 - Volume Follow
    -&4 - Pan Master
    -&8 - Pan Follow
    -&16 - Mute Master
    -&32 - Mute Follow
    -&64 - Solo Master
    -&128 - Solo Follow
    -&256 - Record Arm Master
    -&512 - Record Arm Follow
    -&1024 - Polarity/Phase Master
    -&2048 - Polarity/Phase Follow
    -&4096 - Automation Mode Master
    -&8192 - Automation Mode Follow
    -&16384 - Reverse Volume
    -&32768 - Reverse Pan
    -&65536 - Do not master when slaving
    -&131072 - Reverse Width
    -&262144 - Width Master
    -&524288 - Width Follow
    -&1048576 - VCA Master
    -&2097152 - VCA Follow
    -&4194304 - VCA pre-FX Follow
    -&8388608 - Media/Razor Edit Lead
    -&16777216 - Media/Razor Edit Follow
     array IndividualGroupState_Flags  - returns an array with 23 entries. Every entry represents one of the GroupState_as_Flags, but it's value is a flag, that describes, in which of the 32 Groups a certain flag is set.
    -e.g. If Volume Master is set only in Group 33, entry 1 in the array will be set to 1. If Volume Master is set on Group 34 and Group 36, the first entry in the array will be set to 10.
    -refer to the upper GroupState_as_Flags list to see, which entry in the array is for which set flag, e.g. array[22] is VCA pre-F Follow, array[16] is Do not master when slaving, etc
    -As said before, the values in each entry is a flag, that tells you, which of the groups is set with a certain flag. The following flags determine, in which group a certain flag is set:
    -&1 - Group 33
    -&2 - Group 34
    -&4 - Group 35
    -&8 - Group 36
    -etc...
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, group, groupstate, individual, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackGroupFlags_HighState", "tracknumber", "must be an integer", -1) return -1 end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackGroupFlags_HighState", "tracknumber", "no such track", -2) return -1 end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if ultraschall.IsValidTrackStateChunk(str)==false then ultraschall.AddErrorMessage("GetTrackGroupFlags_HighState", "TrackStateChunk", "no valid TrackStateChunk", -3) return -1 end
    
  local retval=0
  local Track_TrackGroupFlags=str:match("GROUP_FLAGS_HIGH.-%c") 
  if Track_TrackGroupFlags==nil then ultraschall.AddErrorMessage("GetTrackGroupFlags_HighState", "", "no trackgroupflags available", -4) return -1 end
  
  -- get groupflags-state  
  local GroupflagString= Track_TrackGroupFlags:match("GROUP_FLAGS_HIGH (.-)%c")
  local count, Tracktable=ultraschall.CSV2IndividualLinesAsArray(GroupflagString, " ")

  for i=1,32 do
    Tracktable[i]=tonumber(Tracktable[i])
    if Tracktable[i]==nil then Tracktable[i]=0 end
    if Tracktable[i]~=nil and Tracktable[i]>=1 then retval=retval+2^(i-1) end
  end
  
  return retval, Tracktable
end

function ultraschall.GetTrackLockState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLockState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer lockedstate = ultraschall.GetTrackLockState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns, if the track-controls of this track are locked(1) or not(nil).
    
    It's the entry LOCK
    Only the LOCK within TrackStateChunks, but not MediaItemStateChunks
    
    returns nil in case of an error
  </description>
  <retvals>
    integer lockedstate  - locked(1) or not(nil)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, lockstate, locked, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end  
  --str=str:match("(.-)<ITEM")..">"
  return ultraschall.GetTrackState_NumbersOnly("LOCK", str, "GetTrackLockState", true)
end

function ultraschall.GetTrackLayoutNames(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLayoutNames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string TCP_Layoutname, string MCP_Layoutname = ultraschall.GetTrackLayoutNames(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the current selected layouts for TrackControlPanel and MixerControlPanel for this track as strings. Returns nil, if default is set.
    
    It's the entry LAYOUTS
    
    returns nil in case of an error
  </description>
  <retvals>
    string TCP_Layoutname - name of the TCP-Layoutname
    string MCP_Layoutname  - name of the MCP-Layoutname
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, theme, layout, name, mcp, tcp, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackLayoutNames", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackLayoutNames", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackLayoutNames", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end

  -- get layout-names
  local Track_LayoutTCP
  local Track_LayoutMCP
  
  str=str:match("(LAYOUTS%s.-)%c")
  if str==nil then return "","" end
  str=str.." "
  local L=str
  if str~=nil then str=str.." " else return nil end
  Track_LayoutTCP, offset1 = str:match("%s\"(.-)\"%s()")
  if Track_LayoutTCP==nil then Track_LayoutTCP, offset = str:match("%s(.-)%s()") str=str:sub(offset, -1) else str=str:sub(offset1, -1) end
  Track_LayoutMCP = str:match("\"(.-)\"%s")
  if Track_LayoutMCP==nil then Track_LayoutMCP = str:match("(.-)%s") end  

  return Track_LayoutTCP, Track_LayoutMCP
end


function ultraschall.GetTrackAutomodeState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackAutomodeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer automodestate = ultraschall.GetTrackAutomodeState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns, if the automation-mode for envelopes of this track
    
    It's the entry AUTOMODE
    
    returns nil in case of an error
  </description>
  <retvals>
    integer automodestate  - is set to 0 - trim/read, 1 - read, 2 - touch, 3 - write, 4 - latch.
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, automode, envelopes, automation, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("AUTOMODE", str, "GetTrackAutomodeState", true)
end

function ultraschall.GetTrackIcon_Filename(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackIcon_Filename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string filename_with_path = ultraschall.GetTrackIcon_Filename(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the filename with path for the track-icon of the current track. Returns nil, if no trackicon has been set.
    
    It's the entry TRACKIMGFN
    
    returns nil in case of an error
  </description>
  <retvals>
    string filename_with_path  - filename with path for the current track-icon.
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, graphics, image, icon, trackicon, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackIcon_Filename", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackIcon_Filename", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackIcon_Filename", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
    
  -- get trackicon-filename
  local Track_Image=str:match("TRACKIMGFN.-%c")
  if Track_Image~=nil then Track_Image=Track_Image:sub(13,-3)
  end
  return Track_Image
end

function ultraschall.GetTrackRecCFG(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackRecCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string reccfg = ultraschall.GetTrackRecCFG(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the Rec-configuration-string, with which recordings are made. Returns nil, if no reccfg exists.
    
    It's the entry <RECCFG
    
    returns nil in case of an error
  </description>
  <retvals>
    string reccfg - the string, that encodes the recording configuration of the track.
    integer reccfgnr - the number of the recording-configuration of the track; 
                     - 0, use default project rec-setting
                     - 1, use track-customized rec-setting, as set in the "Track: View track recording settings (MIDI quantize, file format/path) for last touched track"-dialog (action 40604)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, reccfg, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackRecCFG", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackRecCFG", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackRecCFG", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end

  -- get reccfg
  local RECCFGNR=str:match("<RECCFG (.-)%c")
  if RECCFGNR==nil then return nil end
  local RECCFG=str:match("<RECCFG.-%c(.-)%c")
  
  return RECCFG, tonumber(RECCFGNR)
end

function ultraschall.GetTrackMidiInputChanMap(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMidiInputChanMap</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer MidiInputChanMap_state = ultraschall.GetTrackMidiInputChanMap(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns the state of the MIDIInputChanMap for the current track, as set in the Input-MIDI->Map Input to Channel menu. 0 for channel 1, 2 for channel 2, etc. Nil, if not existing.
    
    It's the entry MIDI_INPUT_CHANMAP
    
    returns nil in case of an error
  </description>
  <retvals>
    integer MidiInputChanMap_state  - 0 for channel 1, 1 for channel 2, ... 15 for channel 16; nil, source channel.
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, midi, input, chanmap, channelmap, channel, mapping, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("MIDI_INPUT_CHANMAP", str, "GetTrackMidiInputChanMap", true)
end

function ultraschall.GetTrackMidiCTL(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMidiCTL</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer LinkedToMidiChannel, integer unknown = ultraschall.GetTrackMidiCTL(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns linked to Midi channel and an unknown value. Nil if not existing.
    
    It's the entry MIDICTL
    
    returns nil in case of an error
  </description>
  <retvals>
    integer LinkedToMidiChannel - linked to midichannel
    integer unknown  - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, midi, channel, linked, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("MIDICTL", str, "GetTrackMidiCTL", true)
end

function ultraschall.GetTrackWidth(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number width = ultraschall.GetTrackWidth(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns width of the track. 1 if set to +100%. 
    
    Note for TrackStateChunk-enthusiasts: When set to +100%, it is not stored in the TrackStateChunk
    
    It's the entry WIDTH
    
    returns nil in case of an error
  </description>
  <retvals>
    number width - width of the track, from -1(-100%) to 1(+100%)
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, width, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  retval=ultraschall.GetTrackState_NumbersOnly("WIDTH", str, "GetTrackWidth", true)
  if retval==nil then return 1 else return retval end
end

function ultraschall.GetTrackPanMode(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackPanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer PanMode = ultraschall.GetTrackPanMode(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Panmode of the track.
    
    It's the entry PANMODE
    
    returns nil in case of an error
  </description>
  <retvals>
    integer PanMode - the Panmode of the track
    - nil - Project Default
    - 0 - Reaper 3.x balance (deprecated)
    - 3 - Stereo Balance/ Mono Pan(Default)
    - 5 - Stereo Balance
    - 6 - Dual Pan
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, panmode, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("PANMODE", str, "GetTrackPanMode", true)
end

function ultraschall.GetTrackMidiColorMapFn(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMidiColorMapFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MidiColorMapFn = ultraschall.GetTrackMidiColorMapFn(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns MidiColorMap-Filename of the track. Nil if not existing.
    
    It's the entry MIDICOLORMAPFN
    
    returns nil in case of an error
  </description>
  <retvals>
    string MidiColorMapFn - the MidiColorMap-Filename; nil if not existing
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, midicolormap, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackMidiColorMapFn", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackMidiColorMapFn", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackMidiColorMapFn", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
    
  -- get midicolormap-filename
  local Track_MIDICOLORMAPFN=str:match("MIDICOLORMAPFN (.-)%c")
  return Track_MIDICOLORMAPFN
end

function ultraschall.GetTrackMidiBankProgFn(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMidiBankProgFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MidiBankProgFn = ultraschall.GetTrackMidiBankProgFn(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns MidiBankProg-Filename of the track. Nil if not existing.
    
    It's the entry MIDIBANKPROGFN
    
    returns nil in case of an error
  </description>
  <retvals>
    string MidiBankProgFn - the MidiBankProg-Filename; nil if not existing
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, midibankprog, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackMidiBankProgFn", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackMidiBankProgFn", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackMidiBankProgFn", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
    
  -- get midibank-prog-filename
  local Track_MIDIBANKPROGFN=str:match("MIDIBANKPROGFN (.-)%c")
  return Track_MIDIBANKPROGFN
end



function ultraschall.GetTrackMidiTextStrFn(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackMidiTextStrFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MidiTextStrFn = ultraschall.GetTrackMidiTextStrFn(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns MidiTextStrFn-Filename of the track. Nil if not existing.
    
    It's the entry MIDIEXTSTRFN
    
    returns nil in case of an error
  </description>
  <retvals>
    string MidiTextStrFn - the MidiTextStrFn-Filename; nil if not existing
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, MidiTextStrFn, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackMidiTextStrFn", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackMidiTextStrFn", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackMidiTextStrFn", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
    
  -- get midi-text-str-filename
  local Track_MIDITEXTSTRFN=str:match("MIDITEXTSTRFN (.-)%c")
  return Track_MIDITEXTSTRFN
end


function ultraschall.GetTrackID(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string TrackID = ultraschall.GetTrackID(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns TrackID of the track.
    
    It's the entry TRACKID
    
    returns nil in case of an error
  </description>
  <retvals>
    string TrackID - the TrackID as GUID
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, trackid, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackID", "tracknumber", "must be an integer", -1) return nil end
  if tracknumber~=-1 then
  
    -- get trackstatechunk
    local retval, MediaTrack
    if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackID", "tracknumber", "no such track", -2) return nil end
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "test", false)
  else
  end
  if str==nil or str:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetTrackID", "TrackStateChunk", "no valid TrackStateChunk", -3) return nil end
    
  --get track-id
  local Track_TRACKID=str:match("TRACKID (.-)%c")
  return Track_TRACKID
end

function ultraschall.GetTrackScore(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackScore</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer Score1, integer Score2, number Score3, number Score4  = ultraschall.GetTrackScore(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Score of the track.
    
    It's the entry SCORE
    
    returns nil in case of an error
  </description>
  <retvals>
    integer Score1 - unknown 
    integer Score2 - unknown
    number Score3 - unknown
    number Score4 - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, get, score, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("SCORE", str, "GetTrackScore", true)
end

function ultraschall.GetTrackVolPan(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackVolPan</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number Vol, number Pan, number OverridePanLaw, number unknown, number unknown2 = ultraschall.GetTrackVolPan(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Vol and Pan-states of the track.
    
    It's the entry VOLPAN
    
    returns nil in case of an error
  </description>
  <retvals>
    number Vol - Volume Settings
    - -Inf dB(0) to +12dB (3.98107170553497)
    number Pan - Pan Settings
    - -1(-100%); 0(center); 1(100% R)
    number OverridePanLaw - Override Default Pan Track Law
    - 0dB(1) to -144dB(0.00000006309573)
    number unknown - unknown
    number unknown2 - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, get, vol, pan, override, panlaw, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  --str=str:match("(.-)<ITEM")
  return ultraschall.GetTrackState_NumbersOnly("VOLPAN", str, "GetTrackVolPan", true)
end

--------------------------
---- Set Track States ----
--------------------------

function ultraschall.SetTrackName(tracknumber, name, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackName(integer tracknumber, string name, optional string TrackStateChunk)</functioncall>
  <description>
    Set the name of a track or a trackstatechunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string name - new name of the track
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, name, set, state, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackName", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackName", "tracknumber", "no such track in the project", -2) return false end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetTrackName", "name", "must be a string", -3) return false end
  
  -- create state-entry
  local str="NAME \""..name.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackName", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)NAME")
  local B3=AA:match("NAME.-%c(.*)")

  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackPeakColorState(tracknumber, colorvalue, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackPeakColorState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackPeakColorState(integer tracknumber, integer colorvalue, optional string TrackStateChunk)</functioncall>
  <description>
    Set the color of the track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer colorvalue - the color for the track
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, color, state, set, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackPeakColorState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackPeakColorState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(colorvalue)~="integer" then ultraschall.AddErrorMessage("SetTrackPeakColorState", "colorvalue", "must be an integer", -3) return false end
  
  if colorvalue<0 then ultraschall.AddErrorMessage("SetTrackPeakColorState", "colorvalue", "must be positive value", -4) return false end
  
  -- create state-entry
  local str="PEAKCOL "..colorvalue
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackPeakColorState", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end      
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)PEAKCOL")
  local B3=AA:match("PEAKCOL.-%c(.*)")
  
  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    local B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackBeatState(tracknumber, beatstate, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackBeatState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackBeatState(integer tracknumber, integer beatstate, optional string TrackStateChunk)</functioncall>
  <description>
    Set the timebase for a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer beatstate - tracktimebase for this track; -1 - Project time base, 0 - Time, 1 - Beats position, length, rate, 2 - Beats position only
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, beat, state, set, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackBeatState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackBeatState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(beatstate)~="integer" then ultraschall.AddErrorMessage("SetTrackBeatState", "beatstate", "must be an integer", -3) return false end
  
  -- create state-entry
  local str="BEAT "..beatstate
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackBeatState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)BEAT")
  local B3=AA:match("BEAT.-%c(.*)")
  
  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackAutoRecArmState(tracknumber, autorecarmstate, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackAutoRecArmState</slug>
  <requires>
    Ultraschall=4.5
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackAutoRecArmState(integer tracknumber, integer autorecarmstate, optional string TrackStateChunk)</functioncall>
  <description>
    Set the AutoRecArmState for a track or a TrackStateChunk.
    
    It's the entry AUTO_RECARM
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer autorecarmstate - the autorecarmstate; 1, autorecarm on; 0, autorecarm off
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, autorecarm, rec, arm, track, set, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAutoRecArmState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackAutoRecArmState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(autorecarmstate)~="integer" then ultraschall.AddErrorMessage("SetTrackAutoRecArmState", "autorecarmstate", "must be an integer", -3) return false end
  
  -- create state-entry; remove if recarmstate==1
  if autorecarmstate~=1 then autorecarmstate=0 end
  
  -- get trackstatechunk
  local Mediatrack, StateChunk, A
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0) else Mediatrack=reaper.GetTrack(0,tracknumber-1) end
    A, StateChunk=ultraschall.GetTrackStateChunk(Mediatrack, "" ,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "TrackStateChunk", "must be a string", -5) return false end
    StateChunk=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  StateChunk = ultraschall.Statechunk_ReplaceEntry(StateChunk, "AUTO_RECARM", "REC", nil, {autorecarmstate}, {0})
  
  -- set-trackstatechunk, if requested
  if tracknumber~=-1 then
    reaper.SetTrackStateChunk(Mediatrack, StateChunk, false)
  end  
  
  return true, StateChunk
end

function ultraschall.SetTrackMuteSoloState(tracknumber, Mute, Solo, SoloDefeat, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMuteSoloState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMuteSoloState(integer tracknumber, integer Mute, integer Solo, integer SoloDefeat, optional string TrackStateChunk)</functioncall>
  <description>
    Set the Track Mute/Solo/Solodefeat for a track or a TrackStateChunk.
    Has no real effect on master track.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer Mute - Mute set to 0 - Mute off, 1 - Mute On
    integer Solo - Solo set to 0 - Solo off, 1 - Solo ignore routing, 2 - Solo on
    integer SoloDefeat - SoloDefeat set to 0 - off, 1 - on
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, mute, solo, solo defeat, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(Mute)~="integer" then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "Mute", "must be an integer", -3) return false end
  if math.type(Solo)~="integer" then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "Solo", "must be an integer", -4) return false end
  if math.type(SoloDefeat)~="integer" then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "SoloDefeat", "must be an integer", -5) return false end
  
  -- create state-entry
  local str="MUTESOLO "..Mute.." "..Solo.." "..SoloDefeat
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMuteSoloState", "TrackStateChunk", "must be a string", -6) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)MUTESOLO")
  local B3=AA:match("MUTESOLO.-%c(.*)")
  
  -- set trackstatechunk and include new-state
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackIPhaseState(tracknumber, iphasestate, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackIPhaseState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackIPhaseState(integer tracknumber, integer iphasestate, optional string TrackStateChunk)</functioncall>
  <description>
    Sets IPhase, the Phase-Buttonstate of the track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer iphasestate - 0-off, &lt;&gt; than 0-on
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, set, track, state, iphase, phase, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackIPhaseState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackIPhaseState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(iphasestate)~="integer" then ultraschall.AddErrorMessage("SetTrackIPhaseState", "iphasestate", "must be an integer", -3) return false end

  -- create state-entry
  local str="IPHASE "..iphasestate
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackIPhaseState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)IPHASE")
  local B3=AA:match("IPHASE.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackIsBusState(tracknumber, busstate1, busstate2, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackIsBusState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackIsBusState(integer tracknumber, integer busstate1, integer busstate2, optional string TrackStateChunk)</functioncall>
  <description>
    Sets ISBUS-state of the track or a TrackStateChunk; if it's a folder track.
    
    busstate1=0, busstate2=0 - track is no folder
    busstate1=1, busstate2=1 - track is a folder
    busstate1=1, busstate2=2 - track is a folder but view of all subtracks not compactible
    busstate1=2, busstate2=-1 - track is last track in folder(no tracks of subfolders follow)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    integer busstate1 - refer to description for details
    integer busstate2 - refer to description for details
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, busstate, folder, subfolder, compactible, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackIsBusState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber==0 or tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackIsBusState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(busstate1)~="integer" then ultraschall.AddErrorMessage("SetTrackIsBusState", "busstate1", "must be an integer", -3) return false end
  if math.type(busstate2)~="integer" then ultraschall.AddErrorMessage("SetTrackIsBusState", "busstate2", "must be an integer", -4) return false end
  
  -- create state-entry
  local str="ISBUS "..busstate1.." "..busstate2

  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    Mediatrack=reaper.GetTrack(0,tracknumber-1)
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackIsBusState", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end  

  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)ISBUS")
  local B3=AA:match("ISBUS.-%c(.*)")
  
  -- set trackstatechunk and include new-state
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackBusCompState(tracknumber, buscompstate1, buscompstate2, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackBusCompState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackBusCompState(integer tracknumber, integer buscompstate1, integer buscompstate2, optional string TrackStateChunk)</functioncall>
  <description>
    Sets BUSCOMP-state of the track or a TrackStateChunk; This is the state, if tracks in a folder are compacted or not.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    integer - buscompstate1 - 0 - no compacting, 1 - compacted tracks, 2 - minimized tracks
    integer - buscompstate2 - 0 - unknown, 1 - unknown
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, compacting, busstate, folder, minimize, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackBusCompState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber==0 or tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackBusCompState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(buscompstate1)~="integer" then ultraschall.AddErrorMessage("SetTrackBusCompState", "buscompstate1", "must be an integer", -3) return false end
  if math.type(buscompstate2)~="integer" then ultraschall.AddErrorMessage("SetTrackBusCompState", "buscompstate2", "must be an integer", -4) return false end
  
  -- create state-entry
  local str="BUSCOMP "..buscompstate1.." "..buscompstate2
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    Mediatrack=reaper.GetTrack(0,tracknumber-1)
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackBusCompState", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end

  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)BUSCOMP")
  local B3=AA:match("BUSCOMP.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackShowInMixState(tracknumber, MCPvisible, MCP_FX_visible, MCP_TrackSendsVisible, TCPvisible, ShowInMix5, ShowInMix6, ShowInMix7, ShowInMix8, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackShowInMixState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackShowInMixState(integer tracknumber, integer MCPvisible, number MCP_FX_visible, number MCP_TrackSendsVisible, integer TCPvisible, number ShowInMix5, integer ShowInMix6, integer ShowInMix7, integer ShowInMix8, optional string TrackStateChunk)</functioncall>
  <description>
    Sets SHOWINMIX, that sets visibility of track or TrackStateChunk in MCP and TCP.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer MCPvisible - 0 invisible, 1 visible
    number MCP_FX_visible - 0 visible, 1 FX-Parameters visible, 2 invisible
    number MCPTrackSendsVisible - 0 & 1.1 and higher TrackSends in MCP visible, every other number makes them invisible
    integer TCPvisible - 0 track is invisible in TCP, 1 track is visible in TCP
                       - with Master-Track, 1 shows all active envelopes, 0 hides all active envelopes
    number ShowInMix5 - unknown
    integer ShowInMix6 - unknown
    integer ShowInMix7 - unknown
    integer ShowInMix8 - unknown
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, state, set, show in mix, mcp, fx, tcp, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackShowInMixState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(MCPvisible)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "MCPvisible", "must be an integer", -3) return false end
  if type(MCP_FX_visible)~="number" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "MCP_FX_visible", "must be a number", -4) return false end
  if type(MCP_TrackSendsVisible)~="number" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "MCP_TrackSendsVisible", "must be a number", -5) return false end
  if math.type(TCPvisible)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "TCPvisible", "must be an integer", -6) return false end
  if type(ShowInMix5)~="number" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "ShowInMix5", "must be a number", -7) return false end
  if math.type(ShowInMix6)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "ShowInMix6", "must be an integer", -8) return false end
  if math.type(ShowInMix7)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "ShowInMix7", "must be an integer", -9) return false end
  if math.type(ShowInMix8)~="integer" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "ShowInMix8", "must be an integer", -10) return false end
  
  -- create state-entry
  local str="SHOWINMIX "..MCP_FX_visible.." "..MCP_FX_visible.." "..MCP_TrackSendsVisible.." "..TCPvisible.." "..ShowInMix5.." "..ShowInMix6.." "..ShowInMix7.." "..ShowInMix8

  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackShowInMixState", "TrackStateChunk", "must be a string", -11) return false end
    AA=TrackStateChunk
  end

  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)SHOWINMIX")
  local B3=AA:match("SHOWINMIX.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  
  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackFreeModeState(tracknumber, freemodestate, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackFreeModeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackFreeModeState(integer tracknumber, integer freemodestate, optional string TrackStateChunk)</functioncall>
  <description>
    Sets FREEMODE-state of a track or a TrackStateChunk; enables Track-Free Item Positioning.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    integer freemodestate - 0 - off, 1 - on
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, trackfree, item, positioning, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackFreeModeState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackFreeModeState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(freemodestate)~="integer" then ultraschall.AddErrorMessage("SetTrackFreeModeState", "freemodestate", "must be an integer", -3) return false end

  -- create state-entry
  local str="FREEMODE "..freemodestate

  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackFreeModeState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)FREEMODE")
  local B3=AA:match("FREEMODE.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- set trackstatechunk and include new-state
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackRecState(tracknumber, ArmState, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackRecState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackRecState(integer tracknumber, integer ArmState, integer InputChannel, integer MonitorInput, integer RecInput, integer MonitorWhileRec, integer presPDCdelay, integer RecordingPath, optional string TrackStateChunk)</functioncall>
  <description>
    Sets REC, that sets the Recording-state of the track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer ArmState - set to 1(armed) or 0(unarmed)    
    integer InputChannel - the InputChannel
        --1 - No Input
        -1-16(more?) - Mono Input Channel
        -1024 - Stereo Channel 1 and 2
        -1026 - Stereo Channel 3 and 4
        -1028 - Stereo Channel 5 and 6
        -...
        -5056 - Virtual MIDI Keyboard all Channels
        -5057 - Virtual MIDI Keyboard Channel 1
        -...
        -5072 - Virtual MIDI Keyboard Channel 16
        -5088 - All MIDI Inputs - All Channels
        -5089 - All MIDI Inputs - Channel 1
        -...
        -5104 - All MIDI Inputs - Channel 16
    integer Monitor Input - 0 monitor off, 1 monitor on, 2 monitor on tape audio style    
    integer RecInput - the rec-input type
        -0 input(Audio or Midi)
        -1 Record Output Stereo
        -2 Disabled, Input Monitoring Only
        -3 Record Output Stereo, Latency Compensated
        -4 Record Output MIDI
        -5 Record Output Mono
        -6 Record Output Mono, Latency Compensated
        -7 MIDI overdub
        -8 MIDI replace
        -9 MIDI touch replace
        -10 Record Output Multichannel
        -11 Record Output Multichannel, Latency Compensated 
        -12 Record Input Force Mono
        -13 Record Input Force Stereo
        -14 Record Input Force Multichannel
        -15 Record Input Force MIDI
        -16 MIDI latch replace
    integer MonitorWhileRec - Monitor Trackmedia when recording, 0 is off, 1 is on
    integer presPDCdelay - preserve PDC delayed monitoring in media items
    integer RecordingPath - 0 Primary Recording-Path only, 1 Secondary Recording-Path only, 2 Primary Recording Path and Secondary Recording Path(for invisible backup)
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, armstate, inputchannel, monitorinput, recinput, monitorwhilerec, pdc, recordingpath, midi, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackRecState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(ArmState)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "ArmState", "must be an integer", -3) return false end
  if math.type(InputChannel)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "InputChannel", "must be an integer", -4) return false end
  if math.type(MonitorInput)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "MonitorInput", "must be an integer", -5) return false end
  if math.type(RecInput)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "RecInput", "must be an integer", -6) return false end
  if math.type(MonitorWhileRec)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "MonitorWhileRec", "must be an integer", -7) return false end
  if math.type(presPDCdelay)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "presPDCdelay", "must be an integer", -8) return false end
  if math.type(RecordingPath)~="integer" then ultraschall.AddErrorMessage("SetTrackRecState", "RecordingPath", "must be an integer", -9) return false end
  
  -- create state-entry
  local str="REC "..ArmState.." "..InputChannel.." "..MonitorInput.." "..RecInput.." "..MonitorWhileRec.." "..presPDCdelay.." "..RecordingPath
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackRecState", "TrackStateChunk", "must be a string", -10) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1=AA:match("(.-)REC")
  local B3=AA:match("REC.-%c(.*)")
  
  -- set trackstatechunk and include new-state
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackVUState(tracknumber, VUState, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackVUState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackVUState(integer tracknumber, integer VUState, optional string TrackStateChunk)</functioncall>
  <description>
    Sets VU-state of a track or a TrackStateChunk; the way metering shows.
    
    Has no real effect on master track.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer VUState -  0 MultiChannelMetering is off, 2 MultichannelMetering is on, 3 Metering is off;seems to have no effect on MasterTrack
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, armstate, vu, metering, multichannel, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackVUState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackVUState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(VUState)~="integer" then ultraschall.AddErrorMessage("SetTrackVUState", "VUState", "must be an integer", -3) return false end

  -- create state-entry
  local str="VU "..VUState
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then 
      Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackVUState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry
  local B1=AA:match("(.-)VU")
  local B3=AA:match("VU.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  
  -- insert new state into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackHeightState(tracknumber, heightstate1, heightstate2, heightstate3, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackHeightState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackHeightState(integer tracknumber, integer height, integer heightstate2, integer lockedtrackheight, optional string TrackStateChunk)</functioncall>
  <description>
    Sets TRACKHEIGHT-state; the height and compacted state of the track or a TrackStateChunk.
    
    Has no visible effect on the master-track.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer height -  24 up to 443 pixels
    integer lockedtrackheight - 0, trackheight is not locked; 1, trackheight is locked
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, trackheight, height, compact, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackHeightState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackHeightState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(heightstate1)~="integer" then ultraschall.AddErrorMessage("SetTrackHeightState", "height", "must be an integer, between 24 and 443", -3) return false end
  if math.type(heightstate2)~="integer" then ultraschall.AddErrorMessage("SetTrackHeightState", "heightstate2", "must be an integer", -4) return false end
  if type(heightstate3)=="string" then 
    TrackStateChunk=heightstate3
    heightstate=""
  elseif math.type(heightstate3)~="integer" then ultraschall.AddErrorMessage("SetTrackHeightState", "lockedtrackheight", "must be an integer", -4) return false 
  end
  
  -- create state-entry
  local str="TRACKHEIGHT "..heightstate1.." "..heightstate2.." "..heightstate3
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackHeightState", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)TRACKHEIGHT")
  local B3=AA:match("TRACKHEIGHT.-%c(.*)")
  
  -- insert new state-entry into trackstatechunk
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

--A,AA=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--A00,A01=ultraschall.SetTrackHeightState(-1, 100, 1, AA)
--A,AA=reaper.GetTrackStateChunk(reaper.GetTrack(0,0),"",false)
--A1,B1,C1=ultraschall.GetTrackHeightState(-1, A01)
--print2(A01)

function ultraschall.SetTrackINQState(tracknumber, INQ1, INQ2, INQ3, INQ4, INQ5, INQ6, INQ7, INQ8, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackINQState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackINQState(integer tracknumber, integer quantMIDI, integer quantPOS, integer quantNoteOffs, number quantToFractBeat, integer quantStrength, integer swingStrength, integer quantRangeMin, integer quantRangeMax, optional string TrackStateChunk)</functioncall>
  <description>
    Sets INQ-state, mostly the quantize-settings for MIDI, of a track or a TrackStateChunk, as set in the "Track: View track recording settings (MIDI quantize, file format/path) for last touched track"-dialog (action 40604)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer quantMIDI -  quantize MIDI; 0 or 1
    integer quantPOS -  quantize to position; -1,prev; 0, nearest; 1, next
    integer quantNoteOffs -  quantize note-offs; 0 or 1
    number quantToFractBeat -  quantize to (fraction of beat)
    integer quantStrength -  quantize strength; -128 to 127
    integer swingStrength -  swing strength; -128 to 127
    integer quantRangeMin -  quantize range minimum; -128 to 127
    integer quantRangeMax -  quantize range maximum; -128 to 127
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, inq, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackINQState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(INQ1)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ1", "must be an integer", -3) return false end
  if math.type(INQ2)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ2", "must be an integer", -4) return false end
  if math.type(INQ3)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ3", "must be an integer", -5) return false end
  if type(INQ4)~="number" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ4", "must be a number", -6) return false end
  if math.type(INQ5)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ5", "must be an integer", -7) return false end
  if math.type(INQ6)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ6", "must be an integer", -8) return false end
  if math.type(INQ7)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ7", "must be an integer", -9) return false end
  if math.type(INQ8)~="integer" then ultraschall.AddErrorMessage("SetTrackINQState", "INQ8", "must be an integer", -10) return false end
  
  -- create state-entry
  local str="INQ "..INQ1.." "..INQ2.." "..INQ3.." "..INQ4.." "..INQ5.." "..INQ6.." "..INQ7.." "..INQ8
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackINQState", "TrackStateChunk", "must be a string", -11) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry
  local B1=AA:match("(.-)INQ")
  local B3=AA:match("INQ.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackNChansState(tracknumber, NChans, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackNChansState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackNChansState(integer tracknumber, integer NChans, optional string TrackStateChunk)</functioncall>
  <description>
    Sets NCHAN-state; the number of channels in this track or a TrackStateChunk, as set in the routing.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer NChans - 2 to 64, counted every second channel (2,4,6,8,etc) with stereo-tracks. Unknown, if Multichannel and Mono-tracks count differently.
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, channels, number, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackNChansState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackNChansState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(NChans)~="integer" then ultraschall.AddErrorMessage("SetTrackNChansState", "NChans", "must be an integer", -3) return false end
  
  -- create new state-entry
  local str="NCHAN "..NChans
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackNChansState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)NCHAN")
  local B3=AA:match("NCHAN.-%c(.*)")
  
  -- insert new state-entry into trackstatechunk
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackBypFXState(tracknumber, FXBypassState, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackBypFXState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackBypFXState(integer tracknumber, integer FXBypassState, optional string TrackStateChunk)</functioncall>
  <description>
    Sets FX, FX-Bypass-state of the track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer FXBypassState  - 0 bypass, 1 activate fx; has only effect, if FX or instruments are added to this track
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, track, set, fx, bypass, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackBypFXState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackBypFXState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(FXBypassState)~="integer" then ultraschall.AddErrorMessage("SetTrackBypFXState", "FXBypassState", "must be an integer", -3) return false end
  
  -- create new state-entry
  local str="FX "..FXBypassState
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackBypFXState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)FX")
  local B3=AA:match("FX.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackPerfState(tracknumber, Perf, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackPerfState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackPerfState(integer tracknumber, integer Perf, optional string TrackStateChunk)</functioncall>
  <description>
    Sets PERF, the TrackPerformance-State of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    integer Perf  - performance-state
        - 0 - allow anticipative FX + allow media buffering
        - 1 - allow anticipative FX + prevent media buffering
        - 2 - prevent anticipative FX + allow media buffering
        - 3 - prevent anticipative FX + prevent media buffering
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, state, set, fx, performance, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackPerfState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackPerfState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(Perf)~="integer" then ultraschall.AddErrorMessage("SetTrackPerfState", "FXBypassState", "must be an integer", -3) return false end
  
  -- create new state-entry
  local str="PERF "..Perf
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackPerfState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)PERF")
  local B3=AA:match("PERF.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1..""..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1..""..str.."\n"..B3
end


function ultraschall.SetTrackMIDIOutState(tracknumber, MIDIOutState, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMIDIOutState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMIDIOutState(integer tracknumber, integer MIDIOutState, optional string TrackStateChunk)</functioncall>
  <description>
    Sets MIDIOUT, the state of MIDI out for this track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer MIDIOutState - 
    - %-1 no output
    - 416 %- microsoft GS wavetable synth-send to original channels
    - 417-432 %- microsoft GS wavetable synth-send to channel state minus 416
    - -31 %- no Output, send to original channel 1
    - -16 %- no Output, send to original channel 16
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, state, set, midi, midiout, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMIDIOutState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMIDIOutState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(MIDIOutState)~="integer" then ultraschall.AddErrorMessage("SetTrackMIDIOutState", "MIDIOutState", "must be an integer", -3) return false end

  -- create new state-entry
  local str="MIDIOUT "..MIDIOutState
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMIDIOutState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry into the trackstatechunk
  local B1=AA:match("(.-)MIDIOUT")
  local B3=AA:match("MIDIOUT.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into the trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackMainSendState(tracknumber, MainSendOn, ParentChannels, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMainSendState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
  </requires>
  <functioncall>boolean retval, optional string TrackStateChunk = ultraschall.SetTrackMainSendState(integer tracknumber, integer MainSendOn, integer ParentChannels, optional string TrackStateChunk)</functioncall>
  <description>
    Sets MAINSEND, as set in the routing-settings, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    optional string TrackStateChunk - the altered TrackStateChunk, if tracknumber=-1
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer MainSendOn - on(1) or off(0)
    integer ParentChannels  - the ParentChannels(0-64), interpreted as beginning with ParentChannels to ParentChannels+NCHAN
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, state, set, mainsend, parent channels, parent, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMainSendState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMainSendState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(MainSendOn)~="integer" then ultraschall.AddErrorMessage("SetTrackMainSendState", "MainSendOn", "must be an integer", -3) return false end
  if math.type(ParentChannels)~="integer" then ultraschall.AddErrorMessage("SetTrackMainSendState", "ParentChannels", "must be an integer", -4) return false end

  -- create new state-entry
  local str="MAINSEND "..MainSendOn.." "..ParentChannels
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    --A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
    reaper.SetMediaTrackInfo_Value(Mediatrack, "B_MAINSEND", MainSendOn)
    reaper.SetMediaTrackInfo_Value(Mediatrack, "C_MAINSEND_OFFS", ParentChannels)
    return true
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMainSendState", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MAINSEND")
  local B3=AA:match("MAINSEND.-%c(.*)")
  
  -- insert new state-entry into trackstatechunk
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackLockState(tracknumber, LockedState, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackLockState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackLockState(integer tracknumber, integer LockedState, optional string TrackStateChunk)</functioncall>
  <description>
    Sets LOCK-State, as set by the menu entry Lock Track Controls, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    integer LockedState  - 1 - locked, 0 - unlocked
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, lock, state, set, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackLockState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackLockState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(LockedState)~="integer" then ultraschall.AddErrorMessage("SetTrackLockState", "LockedState", "must be an integer", -3) return false end

  -- create new state-entry
  local str="LOCK "..LockedState
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B, B1, B3
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackLockState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry and insert new state-entry into trackstatechunk
  if AA:match("LOCK")=="LOCK" then
    B1=AA:match("(.-)LOCK")
    B3=AA:match("LOCK.-%c(.*)")
  else 
    B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackLayoutNames(tracknumber, TCP_Layoutname, MCP_Layoutname, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackLayoutNames</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackLayoutNames(integer tracknumber, string TCP_Layoutname, string MCP_Layoutname, optional string TrackStateChunk)</functioncall>
  <description>
    Sets LAYOUTS, the MCP and TCP-layout by name of the layout as defined in the theme, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string TCP_Layoutname  - name of the TrackControlPanel-Layout from the theme to use
    string MCP_Layoutname  - name of the MixerControlPanel-Layout from the theme to use
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, state, set, mcp, tcp, layout, mixer, trackcontrol, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackLayoutNames", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackLayoutNames", "tracknumber", "no such track in the project", -2) return false end
  if type(TCP_Layoutname)~="string" then ultraschall.AddErrorMessage("SetTrackLayoutNames", "TCP_Layoutname", "must be a string", -3) return false end
  if type(MCP_Layoutname)~="string" then ultraschall.AddErrorMessage("SetTrackLayoutNames", "MCP_Layoutname", "must be a string", -4) return false end
  
  -- create new state-entry
  local str="LAYOUTS \""..TCP_Layoutname.."\" \""..MCP_Layoutname.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackLayoutNames", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)LAYOUTS")
  local B3=AA:match("LAYOUTS.-%c(.*)")
  if B1==nil then B1=AA:match("(.-PERF.-\n)") B3=AA:match(".-PERF.-\n(.*)") end

  -- insert new state-entry into statechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1..""..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackAutomodeState(tracknumber, automodestate, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackAutomodeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackAutomodeState(integer tracknumber, integer automodestate, optional string TrackStateChunk)</functioncall>
  <description>
    Sets AUTOMODE-State, as set by the menu entry Set Track Automation Mode, for a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer automodestate - 0 - trim/read, 1 - read, 2 - touch, 3 - write, 4 - latch
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, automode, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackAutomodeState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackAutomodeState", "tracknumber", "no such track in the project", -2) return false end
  if math.type(automodestate)~="integer" then ultraschall.AddErrorMessage("SetTrackAutomodeState", "automodestate", "must be an integer", -3) return false end

  -- create new state-entry
  local str="AUTOMODE "..automodestate
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackAutomodeState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)AUTOMODE")
  local B3=AA:match("AUTOMODE.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1..""..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1..""..str.."\n"..B3
end

function ultraschall.SetTrackIcon_Filename(tracknumber, Iconfilename_with_path, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackIcon_Filename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackIcon_Filename(integer tracknumber, string Iconfilename_with_path, optional string TrackStateChunk)</functioncall>
  <description>
    Sets TRACKIMGFN, the trackicon-filename with path, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; -1 if you want to use parameter TrackStateChunk
    string Iconfilename_with_path - filename+path of the imagefile to use as the trackicon; "", to remove track-icon
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, state, track, set, trackicon, image, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackIcon_Filename", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackIcon_Filename", "tracknumber", "no such track in the project", -2) return false end
  if type(Iconfilename_with_path)~="string" then ultraschall.AddErrorMessage("SetTrackIcon_Filename", "Iconfilename_with_path", "must be a string", -3) return false end

  -- create new state-entry
  local str="TRACKIMGFN \""..Iconfilename_with_path.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackIcon_Filename", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)TRACKIMGFN")
  local B3=AA:match("TRACKIMGFN.-%c(.*)")
  
  -- insert new state-entry into trackstatechunk
  if B1==nil then B1=AA:match("(.-)FX") B3=AA:match(".-(FX.*)") end
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1..""..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackMidiInputChanMap(tracknumber, InputChanMap, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMidiInputChanMap</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMidiInputChanMap(integer tracknumber, integer InputChanMap, optional string TrackStateChunk)</functioncall>
  <description>
    Sets MIDI_INPUT_CHANMAP, as set in the Input-MIDI->Map Input to Channel menu, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer InputChanMap - 0 for channel 1, 2 for channel 2, etc. -1 if not existing; nil, to remove MidiInputChanMap
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, input, chanmap, channelmap, midi, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiInputChanMap", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMidiInputChanMap", "tracknumber", "no such track in the project", -2) return false end
  if math.type(InputChanMap)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiInputChanMap", "InputChanMap", "must be an integer", -3) return false end

  -- create new state-entry
  local str="MIDI_INPUT_CHANMAP "..InputChanMap
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMidiInputChanMap", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end

  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MIDI_INPUT_CHANMAP")
  local B3=AA:match("MIDI_INPUT_CHANMAP.-%c(.*)")
  if B1==nil then B1=AA:match("(.-REC.-\n)") B3=AA:match(".-TRACK.-\n(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1..""..str.."\n"..B3,false)
  else
    B=true
  end

  return B, B1..""..str.."\n"..B3
end

function ultraschall.SetTrackMidiCTL(tracknumber, LinkedToMidiChannel, unknown, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMidiCTL</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMidiCTL(integer tracknumber, integer LinkedToMidiChannel, integer unknown, optional string TrackStateChunk)</functioncall>
  <description>
    sets MIDICTL-state, the linkage to Midi-Channels of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer LinkedToMidiChannel - unknown; nil, to remove this setting completely
    integer unknown - unknown
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, linked, midi, midichannel, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiCTL", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMidiCTL", "tracknumber", "no such track in the project", -2) return false end
  if math.type(LinkedToMidiChannel)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiCTL", "LinkedToMidiChannel", "must be an integer", -3) return false end
  if math.type(unknown)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiCTL", "unknown", "must be an integer", -4) return false end

  -- create new state-entry
  local str="MIDICTL "..LinkedToMidiChannel.." "..unknown
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMidiCTL", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MIDICTL")
  local B3=AA:match("MIDICTL.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackID(tracknumber, TrackID, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackID(integer tracknumber, string guid, optional string TrackStateChunk)</functioncall>
  <description>
    sets the track-id, which must be a valid GUID, of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string guid - a valid GUID. Can be generated with the native Reaper-function reaper.genGuid()
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, guid, trackid, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackID", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackID", "tracknumber", "no such track in the project", -2) return false end
  if type(TrackID)~="string" then ultraschall.AddErrorMessage("SetTrackID", "TrackID", "must be a string", -3) return false end


  -- create new state-entry
  local str="TRACKID "..TrackID
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackID", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)TRACKID")
  local B3=AA:match("TRACKID.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

--ATA,ATA2=ultraschall.SetTrackID(nil, "{12345678-1111-1111-1111-123456789012}", L3)

function ultraschall.SetTrackMidiColorMapFn(tracknumber, MIDI_ColorMapFN, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMidiColorMapFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMidiColorMapFn(integer tracknumber, string MIDI_ColorMapFN, optional string TrackStateChunk)</functioncall>
  <description>
    sets the filename+path to the MIDI-ColorMap-graphicsfile of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string MIDI_ColorMapFN - filename+path to the MIDI-ColorMap-file; "", to remove it
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, midi, colormap, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiColorMapFn", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMidiColorMapFn", "tracknumber", "no such track in the project", -2) return false end
  if type(MIDI_ColorMapFN)~="string" then ultraschall.AddErrorMessage("SetTrackMidiColorMapFn", "MIDI_ColorMapFN", "must be a string", -3) return false end

  -- create new state-entry
  local str="MIDICOLORMAPFN \""..MIDI_ColorMapFN.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMidiColorMapFn", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MIDICOLORMAPFN")
  local B3=AA:match("MIDICOLORMAPFN.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

--ATA,ATA2=ultraschall.SetTrackMidiColorMapFn(1, "", L3)

function ultraschall.SetTrackMidiBankProgFn(tracknumber, MIDIBankProgFn, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMidiBankProgFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMidiBankProgFn(integer tracknumber, string MIDIBankProgFn, optional string TrackStateChunk)</functioncall>
  <description>
    sets the filename+path to the MIDI-Bank-Prog-file of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string MIDIBankProgFn - filename+path to the MIDI-Bank-Prog-file; "", to remove it
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, midi, bank, prog, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiBankProgFn", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMidiBankProgFn", "tracknumber", "no such track in the project", -2) return false end
  if type(MIDIBankProgFn)~="string" then ultraschall.AddErrorMessage("SetTrackMidiBankProgFn", "MIDIBankProgFn", "must be a string", -3) return false end

  -- create new state-entry
  local str="MIDIBANKPROGFN \""..MIDIBankProgFn.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMidiBankProgFn", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MIDIBANKPROGFN")
  local B3=AA:match("MIDIBANKPROGFN.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackMidiTextStrFn(tracknumber, MIDITextStrFn, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackMidiTextStrFn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackMidiTextStrFn(integer tracknumber, string MIDITextStrFn, optional string TrackStateChunk)</functioncall>
  <description>
    sets the filename+path to the MIDI-Text-Str-file of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string MIDITextStrFn - filename+path to the MIDI-Text-Str-file; "", to remove it
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, midi, text, str, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackMidiTextStrFn", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackMidiTextStrFn", "tracknumber", "no such track in the project", -2) return false end
  if type(MIDITextStrFn)~="string" then ultraschall.AddErrorMessage("SetTrackMidiTextStrFn", "MIDITextStrFn", "must be a string", -3) return false end

  -- create new state-entry
  local str="MIDITEXTSTRFN \""..MIDITextStrFn.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackMidiTextStrFn", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)MIDITEXTSTRFN")
  local B3=AA:match("MIDITEXTSTRFN.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

--ATA,ATA2=ultraschall.SetTrackMidiTextStrFn(nil, "", L3)

function ultraschall.SetTrackPanMode(tracknumber, panmode, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackPanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackPanMode(integer tracknumber, integer panmode, optional string TrackStateChunk)</functioncall>
  <description>
    sets the panmode for a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer panmode - the Panmode of the track
                            -nil - Project Default
                            -0 - Reaper 3.x balance (deprecated)
                            -3 - Stereo Balance/ Mono Pan(Default)
                            -5 - Stereo Balance
                            -6 - Dual Pan
                            -7 - unknown mode
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, panmode, pan, balance, dual pan, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackPanMode", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackPanMode", "tracknumber", "no such track in the project", -2) return false end
  if math.type(panmode)~="integer" then ultraschall.AddErrorMessage("SetTrackPanMode", "panmode", "must be an integer", -3) return false end

  -- create new state-entry
  local str="PANMODE \""..panmode.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackPanMode", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)PANMODE")
  local B3=AA:match("PANMODE.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.SetTrackWidth(tracknumber, width, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackWidth(integer tracknumber, number width, optional string TrackStateChunk)</functioncall>
  <description>
    sets the width of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    number width - width of the track, from -1(-100%) to 1(+100%)
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, width, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackWidth", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackWidth", "tracknumber", "no such track in the project", -2) return false end
  if type(width)~="number" then ultraschall.AddErrorMessage("SetTrackWidth", "width", "must be a number", -3) return false end

  -- create new state-entry
  local str="WIDTH \""..width.."\""
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackWidth", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)WIDTH")
  local B3=AA:match("WIDTH.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackScore(tracknumber, unknown1, unknown2, unknown3, unknown4, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackScore</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackScore(integer tracknumber, integer unknown1, integer unknown2, number unknown3, number unknown4, optional string TrackStateChunk)</functioncall>
  <description>
    sets the SCORE of a track or a TrackStateChunk.
    
    set unknown1 to unknown4 to 0 to remove the entry from the TrackStateChunk
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    integer unknown1 - unknown
    integer unknown2 - unknown
    number unknown3 - unknown
    number unknown4 - unknown
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, score, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackScore", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackScore", "tracknumber", "no such track in the project", -2) return false end
  if math.type(unknown1)~="integer" then ultraschall.AddErrorMessage("SetTrackScore", "unknown1", "must be an integer", -3) return false end
  if math.type(unknown2)~="integer" then ultraschall.AddErrorMessage("SetTrackScore", "unknown2", "must be an integer", -4) return false end
  if type(unknown3)~="number" then ultraschall.AddErrorMessage("SetTrackScore", "unknown3", "must be a number", -5) return false end
  if type(unknown4)~="number" then ultraschall.AddErrorMessage("SetTrackScore", "unknown4", "must be a number", -6) return false end

  -- create new state-entry
  local str="SCORE "..unknown1.." "..unknown2.." "..unknown3.." "..unknown4
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackScore", "TrackStateChunk", "must be a string", -7) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)SCORE")
  local B3=AA:match("SCORE.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackVolPan(tracknumber, vol, pan, overridepanlaw, unknown, unknown2, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackVolPan</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackVolPan(integer tracknumber, number Vol, number Pan, number OverridePanLaw, number unknown, number unknown2, optional string TrackStateChunk)</functioncall>
  <description>
    sets the VOLPAN-state of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1, if you want to use parameter TrackStateChunk
    number Vol - Volume Settings; -Inf dB(0) to +12dB (3.98107170553497)
    number Pan - Pan Settings; -1(-100%); 0(center); 1(100% R)
    number OverridePanLaw - Override Default Pan Track Law; 0dB(1) to -144dB(0.00000006309573)
    number unknown - unknown
    number unknown2 - unknown
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, vol, pan, override, panlaw, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackVolPan", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackVolPan", "tracknumber", "no such track in the project", -2) return false end
  if type(vol)~="number" then ultraschall.AddErrorMessage("SetTrackVolPan", "vol", "must be a number", -3) return false end
  if type(pan)~="number" then ultraschall.AddErrorMessage("SetTrackVolPan", "pan", "must be a number", -4) return false end
  if type(overridepanlaw)~="number" then ultraschall.AddErrorMessage("SetTrackVolPan", "overridepanlaw", "must be a number", -5) return false end
  if type(unknown)~="number" then ultraschall.AddErrorMessage("SetTrackVolPan", "unknown", "must be a number", -6) return false end
  if type(unknown2)~="number" then ultraschall.AddErrorMessage("SetTrackVolPan", "unknown1", "must be a number", -7) return false end

  -- create new state-entry
  local str="VOLPAN "..vol.." "..pan.." "..overridepanlaw.." "..unknown.." "..unknown2
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackVolPan", "TrackStateChunk", "must be a string", -8) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)VOLPAN")
  local B3=AA:match("VOLPAN.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.SetTrackRecCFG(tracknumber, reccfg_string, reccfg_nr, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackRecCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackRecCFG(integer tracknumber, string reccfg_string, integer reccfg_nr, optional string TrackStateChunk)</functioncall>
  <description>
    sets the RECCFG of a track or a TrackStateChunk.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    string reccfg_string -  the string, that encodes the recording configuration of the track
    integer reccfgnr - the number of the recording-configuration of the track; 
                     - -1, removes the reccfg-setting
                     - 0, use default project rec-setting
                     - 1, use track-customized rec-setting, as set in the "Track: View track recording settings (MIDI quantize, file format/path) for last touched track"-dialog (action 40604)
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, track, set, state, reccfg, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackRecCFG", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackRecCFG", "tracknumber", "no such track in the project", -2) return false end
  if math.type(reccfg_nr)~="integer" then ultraschall.AddErrorMessage("SetTrackRecCFG", "reccfg_nr", "must be an integer", -3) return false end
  if type(reccfg_string)~="string" then ultraschall.AddErrorMessage("SetTrackRecCFG", "reccfg_string", "must be a string", -4) return false end

  -- create new state-entry
  local str="<RECCFG "..reccfg_nr.."\n"..reccfg_string.."\n>"
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackRecCFG", "TrackStateChunk", "must be a string", -5) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state-entry from trackstatechunk
  local B1=AA:match("(.-)<RECCFG")
  local B3=AA:match("RECCFG.->%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end

  -- insert new state-entry into trackstatechunk
  if tracknumber~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end  

  return B, B1.."\n"..str.."\n"..B3
end

function ultraschall.GetAllLockedTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllLockedTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string locked_trackstring, string unlocked_trackstring = ultraschall.GetAllLockedTracks()</functioncall>
  <description>
    returns a trackstring with all tracknumbers of tracks, that are locked, as well as one with all tracknumbers of tracks, that are unlocked.
    
    returns an empty locked_trackstring, if none is locked, returns an empty unlocked_trackstring if all are locked.
  </description>
  <retvals>
    string locked_trackstring - the tracknumbers of all tracks, that are locked; empty string if none is locked
    string unlocked_trackstring - the tracknumbers of all tracks, that are NOT locked; empty string if all are locked
  </retvals>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstring, lock, lockstate, lockedstate, locked, get</tags>
</US_DocBloc>
]]
--returns a trackstring with all locked tracks; empty string if none is locked
  local trackstring=""
  for i=1, reaper.CountTracks() do
    local lockedstate = ultraschall.GetTrackLockState(i)
    if lockedstate==1 then trackstring=trackstring..i.."," end
  end
  return trackstring:sub(1,-2), ultraschall.InverseTrackstring(trackstring, reaper.CountTracks(0))
end


function ultraschall.GetAllSelectedTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllSelectedTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string selected_trackstring, string unselected_trackstring = ultraschall.GetAllSelectedTracks()</functioncall>
  <description>
    returns a trackstring with all tracknumbers of tracks, that are selected, as well as one with all tracknumbers of tracks, that are unselected.
    returns an empty selected_trackstring, if none is selected, returns an empty unselected_trackstring if all are selected.
  </description>
  <retvals>
    string selected_trackstring - the tracknumbers of all tracks, that are selected; empty string if none is selected
    string unselected_trackstring - the tracknumbers of all tracks, that are NOT selected; empty string if all are selected
  </retvals>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstring, selection, unselect, select, get</tags>
</US_DocBloc>
]]
  local trackstring=""
  for i=1, reaper.CountTracks() do
    MediaTrack=reaper.GetTrack(0,i-1)
    local selected = reaper.IsTrackSelected(MediaTrack)
    if selected==true then trackstring=trackstring..i.."," end
  end
  return trackstring:sub(1,-2), ultraschall.InverseTrackstring(trackstring, reaper.CountTracks(0))
end


--A,AA=ultraschall.GetAllSelectedTracks()


function ultraschall.GetTrackSelection_TrackStateChunk(TrackStateChunk)
-- returns the trackname as a string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackSelection_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer selection_state = ultraschall.GetTrackSelection_TrackStateChunk(string TrackStateChunk)</functioncall>
  <description>
    returns selection of the track.    
    
    It's the entry SEL.
    
    Works only with statechunks stored in ProjectStateChunks, due API-limitations!
    
    returns nil in case of an error
  </description>
  <retvals>
    integer selection_state - 0, track is unselected; 1, track is selected
  </retvals>
  <parameters>    
    string TrackStateChunk - a TrackStateChunk whose selection-state you want to retrieve; works only with TrackStateChunks from ProjectStateChunks!
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, selection, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackSelection", "TrackStateChunk", "no valid TrackStateChunk", -1) return nil end
  
  -- get selection
  local Track_Name=str:match(".-SEL (.-)%c.-REC")
  return tonumber(Track_Name)
end

function ultraschall.SetTrackSelection_TrackStateChunk(selection_state, TrackStateChunk)
-- returns the trackname as a string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackSelection_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string alteredTrackStateChunk = ultraschall.SetTrackSelection_TrackStateChunk(integer selection_state, string TrackStateChunk)</functioncall>
  <description>
    set selection of the track in a TrackStateChunk.    
    
    It's the entry SEL.
    
    Works only with statechunks stored in ProjectStateChunks, due API-limitations!
    
    returns nil in case of an error
  </description>
  <retvals>
    string alteredTrackStateChunk - the altered TrackStateChunk with the new selection
  </retvals>
  <parameters>    
    integer selection_state - 0, track is unselected; 1, track is selected
    string TrackStateChunk - a TrackStateChunk whose selection-state you want to set; works only with TrackStateChunks from ProjectStateChunks!
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, selection, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackSelection", "TrackStateChunk", "no valid TrackStateChunk", -1) return nil end
  if math.type(selection_state)~="integer" then ultraschall.AddErrorMessage("GetTrackSelection", "selection_state", "must be an integer", -2) return nil end
  if selection_state<0 or selection_state>1 then ultraschall.AddErrorMessage("GetTrackSelection", "selection_state", "must be either 0 or 1", -3) return nil end
  
  -- set selection
  local Start=TrackStateChunk:match(".-FREEMODE.-\n")
  local End=TrackStateChunk:match("REC.*")
  return Start.."    SEL "..selection_state.."\n    "..End
end


function ultraschall.SetAllTracksSelected(selected)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetAllTracksSelected</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetAllTracksSelected(boolean selected)</functioncall>
  <description>
    Sets all tracks selected(if selected is true) of unselected(if selected is false)
    
    returns -1 in case of error
  </description>
  <retvals>
    integer retval - returns -1 in case of error
  </retvals>
  <parameters>
    boolean selected - true, if all tracks shall be selected, false if all shall be deselected
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, tracks, get, selected</tags>
</US_DocBloc>
]]
  if type(selected)~="boolean" then ultraschall.AddErrorMessage("SetAllTracksSelected","selected", "must be a boolean", -1) return -1 end
  for i=0, reaper.CountTracks(0)-1 do
    local MediaTrack=reaper.GetTrack(0,i)
    reaper.SetTrackSelected(MediaTrack, selected)
  end
end

--L=ultraschall.SetAllTracksSelected(false)


function ultraschall.SetTracksSelected(trackstring, reset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTracksSelected</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetTracksSelected(string trackstring, boolean reset)</functioncall>
  <description>
    Sets tracks in trackstring selected. If reset is set to true, then the previous selection will be discarded.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer retval - returns -1 in case of error
  </retvals>
  <parameters>
    string trackstring - a string with the tracknumbers, separated by a comma; nil or "", deselects all
    boolean reset - true, any previous selection will be discarded; false, it will be kept
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, tracks, get, selected</tags>
</US_DocBloc>
]]
  if type(reset)~="boolean" then ultraschall.AddErrorMessage("SetTracksSelected", "reset", "must be boolean", -1) return -1 end
  if trackstring==nil or trackstring=="" then ultraschall.SetAllTracksSelected(false) return end
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("SetTracksSelected", "trackstring", "must be a valid trackstring", -2) return -1 end
  local count, Aindividual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  if reset==true then ultraschall.SetAllTracksSelected(false) end
  for i=1,count do
     if Aindividual_values[i]-1<reaper.CountTracks(0) and Aindividual_values[i]-1>=0 then
       local MediaTrack=reaper.GetTrack(0,Aindividual_values[i]-1)
       reaper.SetTrackSelected(MediaTrack, true)
     end
  end
end

--L=ultraschall.SetTracksSelected(nil, true)

function ultraschall.SetTracksToLocked(trackstring, reset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTracksToLocked</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTracksToLocked(string trackstring, boolean reset)</functioncall>
  <description>
    sets tracks in trackstring locked. 
    returns false in case or error, true in case of success
  </description>
  <parameters>
    string trackstring - the tracknumbers, separated with a ,
    boolean reset - reset lockedstate of other tracks
    -true - resets the locked-state of all tracks not included in trackstring
    -false - the lockedstate of tracks not in trackstring is retained
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
  </retvals>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstring, lock, lockstate, lockedstate, locked, set</tags>
</US_DocBloc>
]]
  local retval, trackstring, trackstringarray, number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if retval==-1 then ultraschall.AddErrorMessage("SetTracksToLocked","trackstring", "must be a valid trackstring", -1) return false end
  if type(reset)~="boolean" then ultraschall.AddErrorMessage("SetTracksToLocked","trackstring", "must be a boolean", -2) return false end
  for i=1,number_of_entries do
    local Aretval = ultraschall.SetTrackLockState(trackstringarray[i], 1)
  end
  if reset==true then 
    local newtrackstring=ultraschall.InverseTrackstring(trackstring,reaper.CountTracks(0))
    local retval, trackstring, trackstringarray, number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(newtrackstring)
    for i=1,number_of_entries do
      local Aretval = ultraschall.SetTrackLockState(trackstringarray[i], 0)
    end
  end
  return true
end

--ultraschall.SetTracksToLocked("1,2,3,4", true)

function ultraschall.SetTracksToUnlocked(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTracksToUnlocked</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTracksToUnlocked(string trackstring)</functioncall>
  <description>
    sets tracks in trackstring unlocked. 
    returns false in case or error, true in case of success
  </description>
  <parameters>
    string trackstring - the tracknumbers, separated with a ,
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
  </retvals>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstring, lock, lockstate, lockedstate, locked, set, unlock, unlocked</tags>
</US_DocBloc>
]]
--sets tracks in trackstring unlocked.
--returns false in case or error, true in case of success
  local retval, trackstring, trackstringarray, number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if retval==-1 then ultraschall.AddErrorMessage("SetTracksToUnlocked","trackstring", "must be a valid trackstring", -1) return false end
  for i=1,number_of_entries do
    local Aretval = ultraschall.SetTrackLockState(trackstringarray[i], 0)
  end
  return true
end


function ultraschall.SetTrackStateChunk_Tracknumber(tracknumber, trackstatechunk, undo)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackStateChunk_Tracknumber</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTrackStateChunk_Tracknumber(integer tracknumber, string trackstatechunk, boolean undo)</functioncall>
  <description>
    Sets the trackstatechunk for track tracknumber. Undo flag is a performance/caching hint.
    
    returns false in case of an error
  </description>
  <parameters>
    integer tracknumber - the tracknumber, 0 for master track, 1 for track 1, 2 for track 2, etc.
    string trackstatechunk - the trackstatechunk, you want to set this track with
    boolean undo - Undo flag is a performance/caching hint.
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of error
  </retvals>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, trackstatechunk, set</tags>
</US_DocBloc>
]]

  tracknumber=tonumber(tracknumber)
  local Track
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("SetTrackStateChunk_Tracknumber","trackstatechunk", "not a valid trackstatechunk", -1) return false end
  if undo==nil then undo=true end
  if type(undo)~="boolean" then ultraschall.AddErrorMessage("SetTrackStateChunk_Tracknumber","undo", "only true or false are allowed", -2) return false end
  if tracknumber==nil then ultraschall.AddErrorMessage("SetTrackStateChunk_Tracknumber","tracknumber", "not a valid tracknumber, only integer allowed", -3) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackStateChunk_Tracknumber","tracknumber", "only tracknumbers allowed between 0(master), 1(track1) and "..reaper.CountTracks(0).."(last track in this project)", -4) return false end
  if tracknumber==0 then Track=reaper.GetMasterTrack(0)
  else Track=reaper.GetTrack(0,tracknumber-1)
  end
  local A=reaper.SetTrackStateChunk(Track, trackstatechunk, undo)
  return A
end


function ultraschall.SetTrackGroupFlagsState(tracknumber, groups_bitfield_table, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackGroupFlagsState</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackGroupFlagsState(integer tracknumber, array groups_bitfield_table, optional string TrackStateChunk)</functioncall>
  <description>
    Set the GroupFlags-state of a track or trackstatechunk.
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table can contain up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to set Volume Master(table entry 1) to checked in Group 1(2^0=1) and 3(2^2=4):
      groups_bitfield_table[1]=groups_bitfield_table[1]+1+4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Follow
                           3 - Pan Master
                           4 - Pan Follow
                           5 - Mute Master
                           6 - Mute Follow
                           7 - Solo Master
                           8 - Solo Follow
                           9 - Record Arm Master
                           10 - Record Arm Follow
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Follow
                           13 - Automation Mode Master
                           14 - Automation Mode Follow
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Follow
                           21 - VCA Master
                           22 - VCA Follow
                           23 - VCA pre-FX Follow
                           24 - Media/Razor Edit Lead
                           25 - Media/Razor Edit Lead
    
    This function will work only for Groups 1 to 32. To set Groups 33 to 64, use <a href="#SetTrackGroupFlags_HighState">SetTrackGroupFlags_HighState</a> instead!
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    array groups_bitfield_table - an array with all bitfields with all groupflag-settings
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, groupflag, group, set, state, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "tracknumber", "no such track in the project", -2) return false end
  if type(groups_bitfield_table)~="table" then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "groups_bitfield_table", "must be a table", -3) return false end
  local str="GROUP_FLAGS"
  for i=1, 32 do
    if groups_bitfield_table[i]==nil then break end
    if math.type(groups_bitfield_table[i])~="integer" then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "groups_bitfield_table", "every entry must be an integer", -5) return false end
    str=str.." "..groups_bitfield_table[i]
  end
  tracknumber=tonumber(tracknumber)
  
  -- create state-entry
--  local str="GROUP_FLAGS "..groups_bitfield
  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "tracknumber", "must be an integer", -6) return false end
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackGroupFlagsState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1, B3
  B1=AA:match("(.-)%cGROUP_FLAGS")
  B3=AA:match("GROUP_FLAGS.-%c(.*)")
  if B1==nil then 
    B1=AA:match("(.*)%c.-TRACKHEIGHT")
    B3=AA:match("(TRACKHEIGHT.*)")
  end

  -- set trackstatechunk and include new-state
  if tonumber(tracknumber)~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3

end

--A=ultraschall.SetTrackGroupFlagsState(-1, {1,2,3,4,5}, TrackStateChunk)

function ultraschall.SetTrackGroupFlags_HighState(tracknumber, groups_bitfield_table, TrackStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackGroupFlags_HighState</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.72
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackGroupFlags_HighState(integer tracknumber, array groups_bitfield_table, optional string TrackStateChunk)</functioncall>
  <description>
    Set the GroupFlags-state of a track or trackstatechunk.
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table can contain up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to set Volume Master(table entry 1) to checked in Group 33(2^0=1) and 35(2^2=4):
      groups_bitfield_table[1]=groups_bitfield_table[1]+1+4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Follow
                           3 - Pan Master
                           4 - Pan Follow
                           5 - Mute Master
                           6 - Mute Follow
                           7 - Solo Master
                           8 - Solo Follow
                           9 - Record Arm Master
                           10 - Record Arm Follow
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Follow
                           13 - Automation Mode Master
                           14 - Automation Mode Follow
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Follow
                           21 - VCA Master
                           22 - VCA Follow
                           23 - VCA pre-FX Follow
                           24 - Media/Razor Edit Lead
                           25 - Media/Razor Edit Lead
    
    This function will work only for Groups 33(2^0) to 64(2^31). To set Groups 1 to 32, use <a href="#SetTrackGroupFlagsState">SetTrackGroupFlagsState</a> instead!
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    array groups_bitfield_table - an array with all bitfields with all groupflag-settings
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, groupflag, group, set, state, track, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackGroupFlags_HighState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackGroupFlags_HighState", "tracknumber", "no such track in the project", -2) return false end
  if type(groups_bitfield_table)~="table" then ultraschall.AddErrorMessage("SetTrackGroupFlags_HighState", "groups_bitfield_table", "must be a table", -3) return false end
  local str="GROUP_FLAGS_HIGH "
  for i=1, 23 do
    if groups_bitfield_table[i]==nil then break end
    if math.type(groups_bitfield_table[i])~="integer" then ultraschall.AddErrorMessage("SetTrackGroupFlags_HighState", "groups_bitfield_table", "every entry must be an integer", -5) return false end
    str=str.." "..groups_bitfield_table[i]
  end
  tracknumber=tonumber(tracknumber)

  
  -- get trackstatechunk
  local Mediatrack, A, AA, B
  if tonumber(tracknumber)~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=ultraschall.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackGroupFlags_HighState", "TrackStateChunk", "must be a string", -4) return false end
    AA=TrackStateChunk
  end
  
  -- remove old state from trackstatechunk
  local B1, B3
  B1=AA:match("(.-)%cGROUP_FLAGS_HIGH ")
  B3=AA:match("GROUP_FLAGS_HIGH .-%c(.*)")
  if B1==nil then 
    B1=AA:match("(.*)%c.-TRACKHEIGHT")
    B3=AA:match("(TRACKHEIGHT.*)")
  end

  -- set trackstatechunk and include new-state
  if tonumber(tracknumber)~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end


function ultraschall.ConvertTrackstringToArray(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertTrackstringToArray</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array individual_tracknumbers = ultraschall.ConvertTrackstringToArray(string trackstring)</functioncall>
  <description>
    returns all tracknumbers from trackstring, that can be used as tracknumbers, as an array.
    
    returns false in case of an error
  </description>
  <retvals>
    integer count - number of tracks in trackstring
    array individual_tracknumbers - an array that contains all tracknumbers in trackstring
  </retvals>
  <parameters>
    string trackstring - the trackstring to check, if it's a valid one
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, trackstring, get, count, tracks</tags>
</US_DocBloc>
]]
  local retval, count, individual_tracknumbers = ultraschall.IsValidTrackString(trackstring )
  if retval==false then ultraschall.AddErrorMessage("ConvertTrackstringToArray", "trackstring", "not a valid trackstring", -1) return end

  return count, individual_tracknumbers
end

function ultraschall.GetTrackPlayOffsState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackPlayOffsState</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>number offset, integer media_playback_flags = ultraschall.GetTrackPlayOffsState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns state of Media playback offset
    
    It's the entry PLAYOFFS
    
    returns nil in case of an error
  </description>
  <retvals>
    number offset - common values settable via UI are: -0.5(-500ms) to 0.5(500ms) or -8192 to 8192(samples) 
    integer media_playback_flags - flags for Media playback offset-settings
                                 - &1=0, Media playback offset-checkbox is on; &1=1, Media playback offset-checkbox is off
                                 - &2=0, value is in milliseconds; &2=2, value is in samples
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, media playback offset, milliseconds, samples, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  local A,B=ultraschall.GetTrackState_NumbersOnly("PLAYOFFS", str, "GetTrackMuteSoloState", true)
  --if PLAYOFFS doesn't exist as value in statechunk, return defaults (offset=0 and media_playback_flags=0)
  if A==nil then A=0 B=0 end
  return A,B
end


function ultraschall.SetTrackPlayOffsState(tracknumber, TrackStateChunk, offset, media_playback_flags)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackPlayOffsState</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackStateChunk = ultraschall.SetTrackPlayOffsState(integer tracknumber, optional string TrackStateChunk, number offset, integer media_playback_flags)</functioncall>
  <description>
    Set the AutoRecArmState for a track or a TrackStateChunk.
    
    It's the entry PLAYOFFS
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, if successful, false if unsuccessful
    string TrackStateChunk - the altered TrackStateChunk
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master-track; -1 if you want to use parameter TrackStateChunk
    optional string TrackStateChunk - use a trackstatechunk instead of a track; only used when tracknumber is -1
    number offset - common values settable via UI are: -0.5(-500ms) to 0.5(500ms) or -8192 to 8192(samples) 
    integer media_playback_flags - flags for Media playback offset-settings
                                 - &1=0, Media playback offset-checkbox is on; &1=1, Media playback offset-checkbox is off
                                 - &2=0, value is in milliseconds; &2=2, value is in samples
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, media playback offset, track, set, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<-1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "tracknumber", "no such track in the project", -2) return false end
  if type(offset)~="number" then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "offset", "must be a number", -3) return false end
  if math.type(media_playback_flags)~="integer" then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "media_playback_flags", "must be an integer", -4) return false end
  
  -- get trackstatechunk
  local Mediatrack, StateChunk, A
  if tracknumber~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A, StateChunk=ultraschall.GetTrackStateChunk(Mediatrack, str ,false)
  else
    if type(TrackStateChunk)~="string" then ultraschall.AddErrorMessage("SetTrackPlayOffsState", "TrackStateChunk", "must be a string", -5) return false end
    StateChunk=TrackStateChunk
  end
  
  -- replace Statechunk-entry with undocumented helper function(can be found in functions-engine.lua)
  StateChunk = ultraschall.Statechunk_ReplaceEntry(StateChunk, "PLAYOFFS", "IPHASE", nil, {offset, media_playback_flags})
  
  -- set-trackstatechunk, if requested
  if tracknumber~=-1 then
    reaper.SetTrackStateChunk(Mediatrack, StateChunk, false)
  end  
  
  -- remove entry, with default values, as Reaper needs the PLAYOFFS-entry added into the statechunk for
  -- it to be removed with default values
  -- So we need to remove them from the statechunk right now, or it's inconsistent.
  if offset==0 and media_playback_flags==0 then
    return true, string.gsub(StateChunk, "PLAYOFFS.-\n", "")
  else
    return true, StateChunk
  end
end

function ultraschall.GetTrackFixedLanesState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackFixedLanesState</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>integer collapsed_state, integer state2, integer show_only_lane = ultraschall.GetTrackFixedLanesState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Fixed Lanes-state. 

    It's the entry FIXEDLANES
    
    returns nil in case of an error or if there's no lane in the track
  </description>
  <retvals>
    integer collapsed_state - &2, unknown
                            - &8, collapsed state(set=not collapsed; unset=collapsed)
    integer state2 - unknown
    integer show_only_lane - 0, show all lanes; 1, show only one lane
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, fixed lanes, collapsed, show all lanes, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("FIXEDLANES", str, "GetTrackFixedLanesState", true)
end

function ultraschall.GetTrackLaneSoloState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLaneSoloState</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>number lane_solo_state, number state2, number state3, number state4 = ultraschall.GetTrackLaneSoloState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Lanes solo-state. 

    It's the entry LANESOLO
    
    returns nil in case of an error or if there's no lane in the track
  </description>
  <retvals>
    number lane_solo_state - the lanes that are set to play; &1=lane 1, &2=lane 2, &4=lane 3, &8=lane 4, etc
    number state2 - unknown
    number state3 - unknown
    number state4 - unknown
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, fixed lanes, lane solo, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("LANESOLO", str, "GetTrackLaneSoloState", true)
end

function ultraschall.GetTrackLaneRecState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLaneRecState</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>integer lane_rec_state, integer state2, integer state3 = ultraschall.GetTrackLaneRecState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Lanes rec-state. 

    It's the entry LANEREC
    
    returns nil in case of an error or if there's no lane in the track
  </description>
  <retvals>
    integer lane_rec_state - the lanes into which you record; 0-based
    integer state2 - unknown; usually -1
    integer state3 - unknown; usually -1
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, fixed lanes, lane rec, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end
  return ultraschall.GetTrackState_NumbersOnly("LANEREC", str, "GetTrackLaneRecState", true)
end

function ultraschall.GetTrackLaneNameState(tracknumber, str)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLaneNameState</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>string lanename1, string lanename2, string lanename3, .. = ultraschall.GetTrackLaneNameState(integer tracknumber, optional string TrackStateChunk)</functioncall>
  <description>
    returns Lanes name-state. 

    It's the entry LANENAME
    
    returns nil in case of an error or if there's no lane in the track
  </description>
  <retvals>
    integer lane_name_1 - the name of the first lane
    integer lane_name_2 - the name of the second lane
    integer lane_name_3 - the name of the third lane
    ... - ...
  </retvals>
  <parameters>
    integer tracknumber - number of the track, beginning with 1; 0 for master track; -1, if you want to use the parameter TrackStateChunk instead.
    optional string TrackStateChunk - a TrackStateChunk that you want to use, instead of a given track
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua</source_document>
  <tags>trackmanagement, fixed lanes, lane name, get, state, trackstatechunk</tags>
</US_DocBloc>
--]]
  local retval
  if tracknumber~=-1 then retval, str = ultraschall.GetTrackStateChunk_Tracknumber(tracknumber) end

  local ReaperString=str:match("LANENAME.-\n")
  local A, lane_names = ultraschall.SplitReaperString(ReaperString)
  return table.unpack(lane_names)
end

