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
---         Muting Module         ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Muting-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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

function ultraschall.ToggleMute(track, position, state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleMute</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.ToggleMute(integer track, number position, integer state)</functioncall>
  <description>
    Sets mute within the mute-envelope-lane, by inserting the fitting envelope-points. Can be used to program coughbuttons. 
    
    Returns -1, in case of an error
  </description>
  <retvals>
    integer retval - toggling was 0, success; -1, fail
  </retvals>
  <parameters>
    integer track - the track-number, for where you want to set the mute-envelope-lane.
    number position - position in seconds
    integer state - 0, for mute the track on this position; 1, for unmuting the track on this position
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, cough, position</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ToggleMute","track", "must be an integer.", -1) return -1 end  
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ToggleMute", "track", "no such track.", -2) return -1 end
  if type(position)~="number" or tonumber(position)<0 then ultraschall.AddErrorMessage("ToggleMute", "position", "no such position.", -3) return -1 end
  if type(state)~="number" or tonumber(state)<0 or tonumber(state)>1 then ultraschall.AddErrorMessage("ToggleMute", "state", "only 0 and 1 allowed.", -4) return -1 end
  
  -- prepare parameters
  local Track=reaper.GetTrack(0, track-1)
  if Track==nil then ultraschall.AddErrorMessage("ToggleMute", "track", "no such track.", -5) return -1 end
  local MuteEnvelopeTrack=reaper.GetTrackEnvelopeByName(Track, "Mute")
  if MuteEnvelopeTrack==nil then ultraschall.AddErrorMessage("ToggleMute", "track", "track has no activated Mute-Lane.", -6) return -1 end
  
  -- insert mute-envelope-point
  local C=reaper.InsertEnvelopePoint(MuteEnvelopeTrack, position, state, 1, 0, 0)
  reaper.UpdateArrange()
  return 0
end

function ultraschall.ToggleMute_TrackObject(trackobject, position, state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleMute_TrackObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.ToggleMute_TrackObject(MediaTrack trackobject, number position, integer state)</functioncall>
  <description>
    Sets mute within the mute-envelope-lane, by inserting the fitting envelope-points. Can be used to program coughbuttons. 
    
    Returns -1, if it fails.
    
    Works like <a href="#ToggleMute">ultraschall.ToggleMute</a> but uses a trackobject instead of the tracknumber as parameter.
  </description>
  <retvals>
    integer retval - toggling was 0, success; -1, fail
  </retvals>
  <parameters>
    MediaTrack trackobject - the track-object for the track, where you want to set the mute-envelope-lane. Refer <a href="Reaper_API_Lua.html#reaper.GetTrack">GetTrack()</a> for more details.
    number position - position in seconds
    integer state - 0, for mute the track on this position, 1, for unmuting the track on this position
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, cough, position, trackobject, mediatrack</tags>
</US_DocBloc>
--]]
  -- check parameters
  if ultraschall.type(trackobject)~="MediaTrack" then ultraschall.AddErrorMessage("ToggleMute_TrackObject", "trackobject", "no MediaTrack-object.", -1) return -1 end
  local Aretval=reaper.ValidatePtr2(0, trackobject, "MediaTrack*")
  if Aretval==false then ultraschall.AddErrorMessage("ToggleMute_TrackObject", "trackobject", "no MediaTrack-object.", -2) return -1 end
  if type(position)~="number" or tonumber(position)<0 then ultraschall.AddErrorMessage("ToggleMute_TrackObject", "position", "no such position.", -3) return -1 end
  if type(state)~="number" or tonumber(state)<0 or tonumber(state)>1 then ultraschall.AddErrorMessage("ToggleMute_TrackObject", "state", "only 0 and 1 allowed.", -4) return -1 end
  
  -- prepare variables
  local numtracks=reaper.CountTracks(0)-1
  local itworked=-1
  
  -- include envelope-points into the mute-envelope of the track
  local MuteEnvelopeTrack=reaper.GetTrackEnvelopeByName(trackobject, "Mute")
  if MuteEnvelopeTrack==nil then ultraschall.AddErrorMessage("ToggleMute_TrackObject", "track", "track has no activated Mute-Lane.", -5) return -1 end
  local C=reaper.InsertEnvelopePoint(MuteEnvelopeTrack, position, state, 1, 0, 0)

  return 0
end

function ultraschall.GetNextMuteState(track, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextMuteState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer envIDX, number envVal, number envPosition = ultraschall.GetNextMuteState(integer track, number position)</functioncall>
  <description>
    Returns the next mute-envelope-point-ID, it's value(0 or 1) and it's time. Envelope-Points numbering starts with 0! 
    
    Returns -1 if not existing.
  </description>
  <retvals>
    integer envIDX - number of the muteenvelope-point
     number envVal - value of the muteenvelope-point (0 or 1)
     number envPosition  - position of the muteenvelope-point in seconds
  </retvals>
  <parameters>
    integer track - the track-number, for where you want to set the mute-envelope-lane, beginning with 1.
    number position - position in seconds, from where to look for the next mute-envelope-point
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, position, envelope, state, value</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("GetNextMuteState", "track", "must be an integer.", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("GetNextMuteState", "position", "must be a number.", -2) return -1 end
  
  -- prepare variables
  local retval, time, value, shape, tension, selected 
  local MediaTrack=reaper.GetTrack(0, track-1)
  if MediaTrack==nil then ultraschall.AddErrorMessage("GetNextMuteState", "track", "no such track.", -3) return -1 end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetNextMuteState", "track", "track has no activated mute-lane.", -4) return -1 end
  
  -- get the next envelope-point from position
  local Ainteger=reaper.GetEnvelopePointByTime(TrackEnvelope, position) -- get the "prior" marker
  if Ainteger==-1 then retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, 0) Ainteger=-1
  else retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, Ainteger+1) -- get the marker "prior+1"
  end
  if Ainteger+1>reaper.CountEnvelopePoints(TrackEnvelope)-1 then ultraschall.AddErrorMessage("GetNextMuteState", "", "no next mute-envelope-point available", -5) return -1 end
  return Ainteger+1, value, time
end


function ultraschall.GetPreviousMuteState(track, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousMuteState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer envIDX, number envVal, number envPosition = ultraschall.GetPreviousMuteState(integer track, number position)</functioncall>
  <description>
    Returns the previous mute-envelope-point-ID, it's value(0 or 1) and it's time. Envelope-Points numbering starts with 0! 
    
    Returns -1 if not existing.
  </description>
  <retvals>
    integer envIDX - number of the muteenvelope-point
     number envVal - value of the muteenvelope-point (0 or 1)
     number envPosition  - position of the muteenvelope-point in seconds
  </retvals>
  <parameters>
    integer track - the track-number, for where you want to set the mute-envelope-lane, beginning with 1.
    number position - position in seconds, from where to look for the previous mute-envelope-point
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, position, envelope, state, value</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("GetPreviousMuteState", "track", "must be an integer", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("GetPreviousMuteState", "track", "must be a number", -2) return -1 end
  
  -- prepare variables
  local MediaTrack=reaper.GetTrack(0, track-1)
  if MediaTrack==nil then ultraschall.AddErrorMessage("GetPreviousMuteState", "track", "no such track", -3) return -1 end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetPreviousMuteState", "track", "no activated mute-envelope", -4) return -1 end
  
  -- find previous mute-state
  local Ainteger=reaper.GetEnvelopePointByTime(TrackEnvelope, position)
  if Ainteger==-1 then ultraschall.AddErrorMessage("GetPreviousMuteState", "", "no previous mute-state available", -5) return -1 end
  local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, Ainteger)
  return Ainteger, value, time
end

function ultraschall.GetNextMuteState_TrackObject(MediaTrack, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextMuteState_TrackObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer envIDX, number envVal, number envPosition = ultraschall.GetNextMuteState_TrackObject(MediaTrack track, number position)</functioncall>
  <description>
    Returns the next mute-envelope-point-ID, it's value(0 or 1) and it's time. Envelope-Points numbering starts with 0! 
    
    Returns -1 if not existing.
  </description>
  <retvals>
    integer envIDX - number of the muteenvelope-point
     number envVal - value of the muteenvelope-point (0 or 1)
     number envPosition  - position of the muteenvelope-point in seconds
  </retvals>
  <parameters>
    MediaTrack track - the MediaTrack-object, for the track, where you want to set the mute-envelope-lane.
    number position - position in seconds, from where to look for the next mute-envelope-point
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, position, envelope, state, value</tags>
</US_DocBloc>
--]]  
  -- check parameters
  if reaper.ValidatePtr2(0, MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("GetNextMuteState_TrackObject", "track", "not a MediaTrack-object", -1) return -1 end
  local retval, time, value, shape, tension, selected
  if type(position)~="number" then ultraschall.AddErrorMessage("GetNextMuteState_TrackObject", "position", "only a number allowed", -2) return -1 end
  position=tonumber(position)
  if position<0 then ultraschall.AddErrorMessage("GetNextMuteState_TrackObject", "position", "must be a positive value", -3) return -1 end

  -- get Trackenvelope
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetNextMuteState_TrackObject", "", "no mute-envelope active", -4) return -1 end
  
  -- get and check envelope-point
  local envPoint=reaper.GetEnvelopePointByTime(TrackEnvelope, position) -- get mute-state at or prior position
  if envPoint==-1 then -- if there's no envelope-point at or prior position, get first envelope-point in mute-envelope
    retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, 0) envPoint=-1
  else -- if there's an envelope-point at or prior position, return the next one(which is the first one after position)
    retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, envPoint+1) 
  end
  if envPoint+1>reaper.CountEnvelopePoints(TrackEnvelope)-1 then ultraschall.AddErrorMessage("GetNextMuteState_TrackObject", "", "no next mute-state", -5) return -1 end
  return envPoint+1, value, time
end

function ultraschall.GetPreviousMuteState_TrackObject(MediaTrack, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousMuteState_TrackObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer envIDX, number envVal, number envPosition = ultraschall.GetPreviousMuteState_TrackObject(MediaTrack track, number position)</functioncall>
  <description>
    Returns the previous mute-envelope-point-ID, it's value(0 or 1) and it's time. Envelope-Points numbering starts with 0! 
    
    Returns -1 if not existing.
  </description>
  <retvals>
    integer envIDX - number of the muteenvelope-point
     number envVal - value of the muteenvelope-point (0 or 1)
     number envPosition  - position of the muteenvelope-point in seconds
  </retvals>
  <parameters>
    MediaTrack track - the MediaTrack-object, for the track, where you want to set the mute-envelope-lane.
    number position - position in seconds, from where to look for the previous mute-envelope-point
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, position, envelope, state, value</tags>
</US_DocBloc>
--]]
  -- check parameters
  if reaper.ValidatePtr2(0, MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("GetPreviousMuteState_TrackObject", "track", "must be a MediaTrack", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("GetPreviousMuteState_TrackObject", "position", "must be a number", -2) return -1 end
  position=tonumber(position)
  if position<0 then ultraschall.AddErrorMessage("GetPreviousMuteState_TrackObject", "position", "must be a positive value", -3) return -1 end
  
  -- get mute-envelope
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetPreviousMuteState_TrackObject", "position", "no mute-envelope active", -4) return -1 end
  
  -- get mute-envelope-point
  local envPoint=reaper.GetEnvelopePointByTime(TrackEnvelope, position)
  local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, envPoint)
  return Ainteger, value, time
end
  
function ultraschall.CountMuteEnvelopePoints(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountMuteEnvelopePoints</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.CountMuteEnvelopePoints(integer track)</functioncall>
  <description>
    Returns the number of the envelope-points in the Mute-lane of track "track". 
    
    Returns -1, if it fails.
  </description>
  <retvals>
    integer retval  - number of mute-envelope-points
  </retvals>
  <parameters>
    integer track - the track-number, for which you want to count the mute-envelope-points, beginning with 1.
  </parameters>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, mute, envelope, state</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("CountMuteEnvelopePoints", "track", "must be an integer", -1) return -1 end

  if track<1 then ultraschall.AddErrorMessage("CountMuteEnvelopePoints", "track", "track must be 1 and higher", -2) return -1 end
  
  -- get track and mute-envelope
  local MediaTrack=reaper.GetTrack(0, track-1)
  if MediaTrack==nil then ultraschall.AddErrorMessage("CountMuteEnvelopePoints", "track", "no such track", -3) return -1 end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("CountMuteEnvelopePoints", "track", "no mute-envelope active in track", -4) return -1 end

  -- return envelope-points
  return reaper.CountEnvelopePoints(TrackEnvelope)
end


function ultraschall.DeleteMuteState(tracknumber, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMuteState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteMuteState(integer tracknumber, number position)</functioncall>
  <description>
    Deletes a mute-point in track tracknumber at position.
    
    Returns false in case of an error
  </description>
  <parameters>
    integer tracknumber - the track in which to delete the mute-point; is 1-based, means 1 for track 1
    number position - the position of the mute-point to delete
  </parameters>
  <retvals>
    boolean retval - true, deleting was successful; false, deleting wasn't successful.
  </retvals>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, delete, mute, cough, position, tracknumber</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("DeleteMuteState", "tracknumber", "Must be an integer.", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("DeleteMuteState", "position", "Must be a number.", -2) return false end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("DeleteMuteState", "tracknumber", "No such track.", -3) return false end
  if position<0 then ultraschall.AddErrorMessage("DeleteMuteState", "position", "Must be bigger or equal 0.", -4) return false end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,tracknumber-1), "Mute")
  local A=reaper.DeleteEnvelopePointRange(TrackEnvelope, position, position+.000000000000001)
  if A==false then ultraschall.AddErrorMessage("DeleteMuteState", "position", "No mute-envelope-point at position", -5) return false end
  reaper.Envelope_SortPoints(TrackEnvelope)
  --reaper.UpdateArrange()
  return A
end

--L=ultraschall.DeleteMuteState("2", 10)

function ultraschall.DeleteMuteState_TrackObject(MediaTrack, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMuteState_TrackObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteMuteState_TrackObject(MediaTrack MediaTrack, number position)</functioncall>
  <description>
    Deletes a mute-point in a MediaTrack-object at position.
    
    Returns false in case of an error
  </description>
  <parameters>
    MediaTrack MediaTrack - the track in which to delete the mute-point
    number position - the position of the mute-point to delete
  </parameters>
  <retvals>
    boolean retval - true, deleting was successful; false, deleting wasn't successful.
  </retvals>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, delete, mute, cough, position, mediatrack</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("DeleteMuteState_TrackObject", "MediaTrack", "Must be a valid MediaTrack-object.", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("DeleteMuteState_TrackObject", "position", "Must be a number.", -2) return false end
  if position<0 then ultraschall.AddErrorMessage("DeleteMuteState_TrackObject", "position", "Must be bigger or equal 0.", -3) return false end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, "Mute")
  local A=reaper.DeleteEnvelopePointRange(TrackEnvelope, position, position+.000000000000001)
  if A==false then ultraschall.AddErrorMessage("DeleteMuteState_TrackObject", "position", "No mute-envelope-point at position", -4) return false end
  reaper.Envelope_SortPoints(TrackEnvelope)
  -- reaper.UpdateArrange()
  return A
end

--ultraschall.DeleteMuteState_TrackObject(reaper.GetTrack(0,1), 1)

function ultraschall.IsMuteAtPosition(tracknumber, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMuteAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional integer envIDX, optional number envVal = ultraschall.IsMuteAtPosition(integer tracknumber, number position)</functioncall>
  <description>
    Returns true, if a mute-point exists in track tracknumber at position position.
    
    Returns false in case of an error
  </description>
  <parameters>
    integer tracknumber - the track in which to check for a mute-point; is 1-based, means 1 for track 1
    number position - the position to check for a mute-point
  </parameters>
  <retvals>
    boolean retval - true, if there is a mute-point; false, if there isn't one
    optional integer envIDX - if a mute-point is at position, this holds the index of the envelope-point
    optional number envVal - the current set value of the mute-point
  </retvals>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, check, mute, cough, position, tracknumber</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsMuteAtPosition", "tracknumber", "Must be an integer.", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("IsMuteAtPosition", "position", "Must be a number.", -2) return false end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsMuteAtPosition", "tracknumber", "No such track.", -3) return false end
  if position<0 then ultraschall.AddErrorMessage("IsMuteAtPosition", "position", "Must be bigger or equal 0.", -4) return false end
  local envIDX, envVal, envPosition = ultraschall.GetNextMuteState(tracknumber, position-.000000000000001)
  if envPosition==position then return true, envIDX, envVal else return false end
end

--ALABAMA,A,B=ultraschall.IsMuteAtPosition(2, 1)

function ultraschall.IsMuteAtPosition_TrackObject(MediaTrack, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsMuteAtPosition_TrackObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional integer envIDX, optional number envVal = ultraschall.IsMuteAtPosition_TrackObject(MediaTrack MediaTrack, number position)</functioncall>
  <description>
    Returns true, if a mute-point exists in MediaTrack-object at position position.
    
    Returns false in case of an error
  </description>
  <parameters>
    MediaTrack MediaTrack - the track in which to check for a mute-point
    number position - the position to check for a mute-point
  </parameters>
  <retvals>
    boolean retval - true, if there is a mute-point; false, if there isn't one
    optional integer envIDX - if a mute-point is at position, this holds the index of the envelope-point
    optional number envVal - the current set value of the mute-point
  </retvals>
  <chapter_context>
    Mute Management
    Muting tracks within envelope-lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>cough button, check, mute, cough, position, mediatrack</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("IsMuteAtPosition_TrackObject", "MediaTrack", "Must be a valid MediaTrack-object.", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("IsMuteAtPosition_TrackObject", "position", "Must be a number.", -2) return false end
  if position<0 then ultraschall.AddErrorMessage("IsMuteAtPosition_TrackObject", "position", "Must be bigger or equal 0.", -4) return false end
  local envIDX, envVal, envPosition = ultraschall.GetNextMuteState_TrackObject(MediaTrack, position-.000000000000001)
  if envPosition==position then return true, envIDX, envVal else return false end
end

--A,B,C=ultraschall.IsMuteAtPosition_TrackObject(reaper.GetTrack(0,1), 1)


