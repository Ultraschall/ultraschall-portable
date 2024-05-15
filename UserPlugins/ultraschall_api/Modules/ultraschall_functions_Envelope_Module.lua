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
---        Envelope Module        ---
-------------------------------------

function ultraschall.IsValidEnvStateChunk(statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidEnvStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean valid = ultraschall.IsValidEnvStateChunk(string EnvelopeStateChunk)</functioncall>
  <description>
    returns, if a EnvelopeStateChunk is a valid statechunk
    
    returns false, in case of an error
  </description>
  <parameters>
    string EnvelopeStateChunk - a string to check, if it's a valid EnvelopeStateChunk
  </parameters>
  <retvals>
    boolean valid - true, if the string is a valid statechunk; false, if not a valid statechunk
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, check, validity, envelope, statechunk, valid</tags>
</US_DocBloc>
--]]
  if type(statechunk)~="string" then ultraschall.AddErrorMessage("IsValidEnvStateChunk","statechunk", "must be a string", -1) return false end
  if statechunk:match("<.-ENV.-\n.*>\n$")~=nil then return true end
  return false
end

function ultraschall.MoveTrackEnvelopePointsBy(startposition, endposition, moveby, MediaTrack, cut_at_border)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveTrackEnvelopePointsBy</slug>
  <requires>
    Ultraschall=4.9
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MoveTrackEnvelopePointsBy(number startposition, number endposition, number moveby, MediaTrack MediaTrack, boolean cut_at_border)</functioncall>
  <description>
    Moves the envelopepoints between startposition and endposition by moveby in MediaTrack. 
    It moves all trackenvelope-points for all track-envelopes available.
    
    Does NOT move item-envelopepoints!
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    number moveby - in seconds, negative values: move toward beginning of project, positive values: move toward the end of project
    MediaTrack MediaTrack - the MediaTrack object of the track, where the EnvelopsPoints shall be moved
    boolean cut_at_border - true, cut envelope-points, that would move outside section between startposition and endposition
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, move, moveby</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveTrackEnvelopePointsBy", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveTrackEnvelopePointsBy", "endposition", "must be a number", -2) return -1 end
  if type(moveby)~="number" then ultraschall.AddErrorMessage("MoveTrackEnvelopePointsBy", "moveby", "must be a number", -3) return -1 end
  if reaper.ValidatePtr2(0, MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("MoveTrackEnvelopePointsBy", "MediaTrack", "must be a valid MediaTrack", -4) return -1 end
  if type(cut_at_border)~="boolean" then ultraschall.AddErrorMessage("MoveTrackEnvelopePointsBy", "cut_at_border", "must be a boolean", -5) return -1 end

  if moveby==0 then return -1 end
  local EnvTrackCount=reaper.CountTrackEnvelopes(MediaTrack)

  for a=0, EnvTrackCount-1 do
    local TrackEnvelope=reaper.GetTrackEnvelope(MediaTrack, a)
    local EnvCount=reaper.CountEnvelopePoints(TrackEnvelope)
  
    if moveby<0 then
      --for i=0, EnvCount do
      local i=-1
      while i<=EnvCount do
        i=i+1
        local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, i)
        if time>=startposition and time<=endposition then
          --if time+moveby>=tonumber(startposition) and time+moveby<=tonumber(endposition) then
          if cut_at_border==true and time+moveby<tonumber(startposition) then
            local boolean=reaper.DeleteEnvelopePointRange(TrackEnvelope, time, time+0.0000000000001)
            i=i-1
          else
            reaper.SetEnvelopePoint(TrackEnvelope, i, time+moveby,nil,nil,nil,nil,true)
          end
        end
      end
    elseif moveby>0 then
      for i=EnvCount, 0, -1 do
        local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, i)
        if time>=startposition and time<=endposition then
          --if time+moveby>=tonumber(startposition) and time+moveby<=tonumber(endposition) then
          if cut_at_border==true and (time+moveby>tonumber(endposition)) then
            local boolean=reaper.DeleteEnvelopePointRange(TrackEnvelope, time, time+0.0000000000001)
          else
            reaper.SetEnvelopePoint(TrackEnvelope, i, time+moveby,nil,nil,nil,nil,true)
          end
        end
      end
    end
    reaper.Envelope_SortPoints(TrackEnvelope)
  end
  return 0
end


function ultraschall.GetEnvelopePoint(Tracknumber, EnvelopeName, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopePoint</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number time, number value, integer shape, number tension, boolean selected, number dBVal, array EnvelopePointObject = ultraschall.GetEnvelopePoint(integer Tracknumber, string EnvelopeName, integer idx)</functioncall>
  <description>
    Returns the values for the idxth envelope point in Tracknumber->EnvelopeName.
    
    returns -1 in case of error
  </description>
  <parameters>
    integer Tracknumber - the number of the track, beginning with 1. Use 0 for Master Track.
    string EnvelopeName - the name of the envelope-lane
    integer idx - the number of the envelope-point, beginning with 0
  </parameters>
  <retvals>
    number time - the time of the envelope point
    number value - the raw-value of the envelope point
    integer shape - the shape of this envelope
    -0 - Linear
    -1 - Square
    -2 - Slow start/end
    -3 - Fast start
    -4 - Fast end
    -5 - Bezier
    number tension - the intensity of the tension of the shape
    boolean selected - true, if this point is selected; false if not
    number dBVal - the envelopevalue converted to dB
    array EnvelopePointObject - an array with all elements of an envelopepoint
    -[1] - TrackEnvelope-object
    -[2] - Envelope-idx, beginning with 0 for the first one
    -[3] - time
    -[4] - value
    -[5] - shape
    -[6] - tension
    -[7] - selected
    -[8] - dBValue converted from value
  </retvals>
  <chapter_context>
    Envelope Management
    Get Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, get, db, time, value, envelopepointobject</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("GetEnvelopePoint", "track", "must be an integer", -1) return -1 end
  if type(EnvelopeName)~="string" then ultraschall.AddErrorMessage("GetEnvelopePoint", "EnvelopeName", "must be a string", -6) return -1 end
  local MediaTrack
  local EnvelopePointObject={}
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetEnvelopePoint","idx", "must be an integer", -2) return -1 end
  if Tracknumber<0 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetEnvelopePoint", "track", "no such track", -3) return -1 end
  if Tracknumber==0 then 
    MediaTrack=reaper.GetMasterTrack(0)
  else
    MediaTrack=reaper.GetTrack(0,Tracknumber-1)
  end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, EnvelopeName)
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetEnvelopePoint","EnvelopeName", "no such envelope", -4) return -1 end
  local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, idx)
  if retval==false then ultraschall.AddErrorMessage("GetEnvelopePoint","idx", "no such envelopepoint", -5) return -1 end
  local dBVal=reaper.SLIDER2DB(value)
  EnvelopePointObject[1]=TrackEnvelope
  EnvelopePointObject[2]=idx
  EnvelopePointObject[3]=time
  EnvelopePointObject[4]=value
  EnvelopePointObject[5]=shape
  EnvelopePointObject[6]=tension
  EnvelopePointObject[7]=selected
  EnvelopePointObject[8]=dBVal
  return time, value, shape, tension, selected, dBVal, EnvelopePointObject
end

--ultraschall.GetEnvelopePoint(1, "Mute", 1)

function ultraschall.GetClosestEnvelopePointIDX_ByTime(Tracknumber, EnvelopeName, CheckTime)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestEnvelopePointIDX_ByTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer idxpre, array EnvelopePointObjectPre, integer idxpost, array EnvelopePointObjectPost = ultraschall.GetClosestEnvelopePointIDX_ByTime(integer Tracknumber, string EnvelopeName, number CheckTime)</functioncall>
  <description>
    Returns the idxs and EnvelopePointObject of the envelope-points closest to timeposition CheckTime
    returns -1 in case of error
  </description>
  <parameters>
    integer Tracknumber - the number of the track, beginning with 1. Use 0 for Master Track.
    string EnvelopeName - the name of the envelope-lane
    number CheckTime - the time in seconds to check for the closest envelope-points
  </parameters>
  <retvals>
    integer idxpre - the idx of the closest envelopepoint at or before CheckTime
    array EnvelopePointObjectPre - an EnvelopePointObject of idxpre
    integer idxpost - the idx of the closest envelopepoint after CheckTime
    array EnvelopePointObjectPost - an EnvelopePointObject of idxpost
  </retvals>
  <chapter_context>
    Envelope Management
    Get Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, get, idx, closest, previous, following, envelopepointobject</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime", "Tracknumber", "must be an integer", -1) return -1 end
  if type(EnvelopeName)~="string" then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime", "EnvelopeName", "must be a string", -6) return -1 end
  if type(CheckTime)~="number" then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime", "CheckTime", "must be a number", -7) return -1 end

  local MediaTrack, IDXpre, IDXpost, ding, EnvelopePointObjectPre, EnvelopePointObjectPost, value, shape, tension, selected, dBVal, time
  
  if CheckTime<0 then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime","CheckTime", "time must be 0 or higher", -3) return -1 end
  if Tracknumber<0 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime","Tracknumber", "no such track", -4) return -1 end
  if Tracknumber==0 then 
    MediaTrack=reaper.GetMasterTrack(0)
  else
    MediaTrack=reaper.GetTrack(0,Tracknumber-1)
  end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, EnvelopeName)
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetClosestEnvelopePointIDX_ByTime","EnvelopeName", "no such envelope", -5) return -1 end

  for i=0, reaper.CountEnvelopePoints(TrackEnvelope) do
    local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, i)
    IDXpre=i-1 IDXpost=i
    if time>CheckTime and ding~=true then break end
  end

  time, value, shape, tension, selected, dBVal, EnvelopePointObjectPre = ultraschall.GetEnvelopePoint(Tracknumber, EnvelopeName, IDXpre)
  if time==-1 then ultraschall.DeleteLastErrorMessage() end
  time, value, shape, tension, selected, dBVal, EnvelopePointObjectPost = ultraschall.GetEnvelopePoint(Tracknumber, EnvelopeName, IDXpost)
  if time==-1 then ultraschall.DeleteLastErrorMessage() end
  
  return IDXpre, EnvelopePointObjectPre, IDXpost, EnvelopePointObjectPost
end

--ultraschall.GetClosestEnvelopePointIDX_ByTime(1, "", 1)

function ultraschall.GetEnvelopePointIDX_Between(Tracknumber, EnvelopeName, startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopePointIDX_Between</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string EnvelopeString, array EnvelopePointArray = ultraschall.GetEnvelopePointIDX_Between(integer Tracknumber, string EnvelopeName, number startposition, number endposition)</functioncall>
  <description>
    Returns a string and an EnvelopePointArray with all idx/EnvelopePointObjects of all envelopepoints between startposition and endposition in the EnvelopeName-lane.
    returns -1 in case of error
  </description>
  <parameters>
    integer Tracknumber - the number of the track. 1 for track 1, 2 for track 2, etc. 0 for Master-track.
    string EnvelopeName - the name of the envelope-lane, where you want to have the envelope-points of.
    number startposition - the startposition of the selection in seconds. Must be bigger than or equal 0.
    number endposition - the endposition of the selection in seconds. Must be bigger than startposition.
  </parameters>
  <retvals>
    string EnvelopeString - a string with all envelope-point-idx in the selection, separated by commas.
    array EnvelopePointArray - an array with all EnvelopePointObjects of all envelope-points in selection.
  </retvals>
  <chapter_context>
    Envelope Management
    Get Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, get, idx, selection, envelopepointobject, envelopepointarray</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between", "Tracknumber", "must be an integer", -1) return -1 end
  if type(EnvelopeName)~="string" then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between", "EnvelopeName", "must be a string", -8) return -1 end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between", "startposition", "must be a number", -9) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between", "endposition", "must be a number", -10) return -1 end

  local MediaTrack
  local EnvelopePointObjectArray={}
  local EnvelopeString=""
  local count=1

  if startposition<0 then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between","startposition", "time must be 0 or higher", -4) return -1 end
  if endposition<=startposition then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between","endposition", "time must be equal or higher than startposition", -5) return -1 end
  if Tracknumber<0 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between","Tracknumber", "no such track", -6) return -1 end
  if Tracknumber==0 then 
    MediaTrack=reaper.GetMasterTrack(0)
  else
    MediaTrack=reaper.GetTrack(0,Tracknumber-1)
  end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, EnvelopeName)
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("GetEnvelopePointIDX_Between","EnvelopeName", "no such envelope", -7) return -1 end

  for i=0, reaper.CountEnvelopePoints(TrackEnvelope) do
    local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, i)
    if time>=startposition and time<=endposition then 
      EnvelopePointObjectArray[count]={}
      EnvelopePointObjectArray[count][1]=TrackEnvelope
      EnvelopePointObjectArray[count][2]=i
      EnvelopePointObjectArray[count][3]=time
      EnvelopePointObjectArray[count][4]=value
      EnvelopePointObjectArray[count][5]=shape
      EnvelopePointObjectArray[count][6]=tension
      EnvelopePointObjectArray[count][7]=selected
      EnvelopePointObjectArray[count][8]=reaper.SLIDER2DB(value)
      count=count+1 
      EnvelopeString=EnvelopeString..i.."," 
    end
  end
  return EnvelopeString:sub(1,-2), EnvelopePointObjectArray
end

--ultraschall.GetEnvelopePointIDX_Between(1,"",1,1)


function ultraschall.CheckEnvelopePointObject(EnvelopePointObject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckEnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CheckEnvelopePointObject(array EnvelopePointObject)</functioncall>
  <description>
    Checks, if EnvelopePointObject is valid or not.
    
    returns false in case of an error
  </description>
  <parameters>
    array EnvelopePointObject - an array with all information of an envelope point
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, check, envelopepointobject</tags>
</US_DocBloc>
]]

  if EnvelopePointObject==nil then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject", "no nil allowed", -1) return false end
  if type(EnvelopePointObject)~="table" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject", "no EnvelopePointObject", -2) return false end
  if reaper.ValidatePtr(EnvelopePointObject[1], "TrackEnvelope*")==false then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[1]", "contains no TrackEnvelope-object", -3) return false end
  if type(EnvelopePointObject[2])~="number" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[2]", "invalid idx-number", -4) return false end
  if type(EnvelopePointObject[3])~="number" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[3]", "invalid time", -5) return false end
  if type(EnvelopePointObject[4])~="number" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[4]", "invalid value", -6) return false end
  if type(EnvelopePointObject[5])~="number" or (EnvelopePointObject[5]<0 or EnvelopePointObject[5]>5) then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[5]", "invalid shape-value, 0-5 is allowed", -7) return false end
  if type(EnvelopePointObject[6])~="number" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[6]", "invalid tension-value, must be a number.", -8) return false end
  if type(EnvelopePointObject[7])~="boolean" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[7]", "invalid selection-value, must be boolean.", -9) return false end
  if type(EnvelopePointObject[8])~="number" then ultraschall.AddErrorMessage("CheckEnvelopePointObject","EnvelopePointObject[6]", "invalid dBvalue, must be a number.", -10) return false end
  return true
end

function ultraschall.IsValidEnvelopePointObject(EnvelopePointObject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidEnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidEnvelopePointObject(array EnvelopePointObject)</functioncall>
  <description>
    Checks, if EnvelopePointObject is valid or not.
    
    returns false in case of an error
  </description>
  <parameters>
    array EnvelopePointObject - an array with all information of an envelope point
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, check, envelopepointobject</tags>
</US_DocBloc>
]]
  local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter0 = ultraschall.GetLastErrorMessage()
  local A=ultraschall.CheckEnvelopePointObject(EnvelopePointObject)
  local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage() 
  if errorcounter0~=errorcounter and functionname=="CheckEnvelopePointObject" then ultraschall.AddErrorMessage("IsValidEnvelopePointObject",parmname, errormessage, errcode) return false end
  return A
end
--A=ultraschall.IsValidEnvelopePointObject("")


function ultraschall.SetEnvelopePoints_EnvelopePointObject(EnvelopePointObject, sort_in)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopePoints_EnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetEnvelopePoints_EnvelopePointObject(array EnvelopePointObject, boolean sort_in)</functioncall>
  <description>
    Sets an envelope-point, as defined in EnvelopePointObject.
    
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointObject - an array with all information of an envelope point
    boolean sort_in - set true, if setting multiple points at once and call Envelope_SortPoints when done.
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, set, envelopepointobject</tags>
</US_DocBloc>
]]
  if type(sort_in)~="boolean" then ultraschall.AddErrorMessage("SetEnvelopePoints_EnvelopePointObject","sort_in", "only boolean allowed", -1) return false end
  if ultraschall.CheckEnvelopePointObject(EnvelopePointObject)==false then ultraschall.AddErrorMessage("SetEnvelopePoints_EnvelopePointObject","EnvelopePointObject", "not a valid EnvelopePointObject", -2) return false end
  return reaper.SetEnvelopePoint(EnvelopePointObject[1], EnvelopePointObject[2], EnvelopePointObject[3], EnvelopePointObject[4], EnvelopePointObject[5], EnvelopePointObject[6], EnvelopePointObject[7], sort_in)
end


function ultraschall.SetEnvelopePoints_EnvelopePointArray(EnvelopePointArray, sort_in)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopePoints_EnvelopePointArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetEnvelopePoints_EnvelopePointArray(array EnvelopePointArray, boolean sort_in)</functioncall>
  <description>
    Sets envelope-points, as defined in the EnvelopePointObjects, in the EnvelopePointArray.
    
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointArray - an array with all EnvelopePointObjects you want to insert
    boolean sort_in - set true, if setting multiple points at once and call Envelope_SortPoints when done.
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, set, envelopepointobject, envelopepointarray</tags>
</US_DocBloc>
]]
  if type(sort_in)~="boolean" then ultraschall.AddErrorMessage("SetEnvelopePoints_EnvelopePointArray","sort_in", "only boolean allowed", -1) return false end
  if type(EnvelopePointArray)~="table" then ultraschall.AddErrorMessage("SetEnvelopePoints_EnvelopePointArray","EnvelopePointArray", "not an EnvelopePointArray", -2) return false end
  local count=1
  local falseification=true
  while EnvelopePointArray[count]~=nil do
    if ultraschall.CheckEnvelopePointObject(EnvelopePointArray[count])==false then ultraschall.AddErrorMessage("SetEnvelopePoints_EnvelopePointArray","EnvelopePointArray["..count.."]", "not an EnvelopePointObject", -3) falseification=false
    else
      reaper.SetEnvelopePoint(EnvelopePointArray[count][1], EnvelopePointArray[count][2], EnvelopePointArray[count][3], EnvelopePointArray[count][4], EnvelopePointArray[count][5], EnvelopePointArray[count][6], EnvelopePointArray[count][7], sort_in)
    end
    count=count+1
  end
  return falseification
end

function ultraschall.DeleteEnvelopePoints_EnvelopePointObject(EnvelopePointObject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteEnvelopePoints_EnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteEnvelopePoints_EnvelopePointObject(array EnvelopePointObject)</functioncall>
  <description>
    Deletes an envelope-point, as defined in EnvelopePointObject.
    
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointObject - an array with all information of an envelope point
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, delete, envelopepointobject</tags>
</US_DocBloc>
]]
  if ultraschall.CheckEnvelopePointObject(EnvelopePointObject)==false then ultraschall.AddErrorMessage("DeleteEnvelopePoints_EnvelopePointObject","EnvelopePointObject", "not a valid EnvelopePointObject", -1) return false end
  BR_Envelope=reaper.BR_EnvAlloc(EnvelopePointObject[1], true)
  reaper.BR_EnvDeletePoint(BR_Envelope, EnvelopePointObject[2])
  return reaper.BR_EnvFree(BR_Envelope, true)
end


function ultraschall.DeleteEnvelopePoints_EnvelopePointArray(EnvelopePointArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteEnvelopePoints_EnvelopePointArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteEnvelopePoints_EnvelopePointArray(array EnvelopePointArray)</functioncall>
  <description>
    Deletes the envelope-points, as defined in the EnvelopePointObjects, in the EnvelopePointArray.
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointArray - an array with all EnvelopePointObjects you want to insert
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, delete, envelopepointobject, envelopepointarray</tags>
</US_DocBloc>
]]
  if type(EnvelopePointArray)~="table" then ultraschall.AddErrorMessage("DeleteEnvelopePoints_EnvelopePointArray","EnvelopePointArray", "not an EnvelopePointArray", -1) return false end
  local count=1
  local falseification=true
  while EnvelopePointArray[count]~=nil do
    count=count+1
  end
  for i=count-1,1, -1 do
    if ultraschall.CheckEnvelopePointObject(EnvelopePointArray[i])==false then ultraschall.AddErrorMessage("DeleteEnvelopePoints_EnvelopePointArray","EnvelopePointArray["..i.."]", "not a valid EnvelopePointObject", -2) falseification=false
    else
      BR_Envelope=reaper.BR_EnvAlloc(EnvelopePointArray[i][1], true)
      retval1=reaper.BR_EnvDeletePoint(BR_Envelope, EnvelopePointArray[i][2])
      retval2=reaper.BR_EnvFree(BR_Envelope, true)
    end
  end
  return falseification
end


function ultraschall.AddEnvelopePoints_EnvelopePointObject(EnvelopePointObject, sort_in)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddEnvelopePoints_EnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AddEnvelopePoints_EnvelopePointObject(array EnvelopePointObject, boolean sort_in)</functioncall>
  <description>
    Adds an envelope-point, as defined in EnvelopePointObject.
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointObject - an array with all information of an envelope point
    boolean sort_in - set true, if setting multiple points at once and call Envelope_SortPoints when done.
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, add, envelopepointobject</tags>
</US_DocBloc>
]]
  if type(sort_in)~="boolean" then ultraschall.AddErrorMessage("AddEnvelopePoints_EnvelopePointObject","sort_in", "only boolean allowed", -1) return false end
  if ultraschall.CheckEnvelopePointObject(EnvelopePointObject)==false then ultraschall.AddErrorMessage("AddEnvelopePoints_EnvelopePointObject","EnvelopePointObject", "not a valid EnvelopePointObject", -2) return false end
  return reaper.InsertEnvelopePoint(EnvelopePointObject[1], EnvelopePointObject[3], EnvelopePointObject[4], EnvelopePointObject[5], EnvelopePointObject[6], EnvelopePointObject[7], sort_in)
end

function ultraschall.AddEnvelopePoints_EnvelopePointArray(EnvelopePointObjectArray, sort_in)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddEnvelopePoints_EnvelopePointArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AddEnvelopePoints_EnvelopePointArray(array EnvelopePointArray, boolean sort_in)</functioncall>
  <description>
    Adds the envelope-points, as defined in the EnvelopePointObjects, in the EnvelopePointArray.
    returns true in case of success, false in case of failure.
  </description>
  <parameters>
    array EnvelopePointArray - an array with all EnvelopePointObjects you want to insert
    boolean sort_in - set true, if setting multiple points at once and call Envelope_SortPoints when done.
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid EnvelopePointObject; false if not
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, add, envelopepointobject, envelopepointarray</tags>
</US_DocBloc>
]]
  if type(sort_in)~="boolean" then ultraschall.AddErrorMessage("AddEnvelopePoints_EnvelopePointArray","sort_in", "only boolean allowed", -1) return false end
  count=1
  while EnvelopePointObjectArray[count]~=nil do
    if ultraschall.CheckEnvelopePointObject(EnvelopePointObjectArray)==false then 
      reaper.InsertEnvelopePoint(EnvelopePointObjectArray[count][1], EnvelopePointObjectArray[count][3], EnvelopePointObjectArray[count][4], EnvelopePointObjectArray[count][5], EnvelopePointObjectArray[count][6], EnvelopePointObjectArray[count][7], sort_in)
    end
    count=count+1
  end
end



function ultraschall.CreateEnvelopePointObject(TrackEnvelope, idx, time, value, shape, tension, selected)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateEnvelopePointObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array EnvelopePointObject = ultraschall.CreateEnvelopePointObject(TrackEnvelope TrackEnvelope, integer idx, number time, number value, integer shape, number tension, boolean selected)</functioncall>
  <description>
    Creates a new EnvelopePointObject, that can be used by other ultraschall-api-envelope-functions
    
    returns false in case of error
  </description>
  <parameters>
    TrackEnvelope env - the track-envelope, in which this EnvelopePointObject shall be
    integer idx - the number of the envelope-point, beginning with 0
    number time - the time of the envelope point in seconds
    number value - the raw-value of the envelope point
    integer shape - the shape of this envelope
                  -0 - Linear
                  -1 - Square
                  -2 - Slow start/end
                  -3 - Fast start
                  -4 - Fast end
                  -5 - Bezier
    number tension - the intensity of the tension of the shape
    boolean selected - true, if this point is selected; false if not
  </parameters>
  <retvals>
    boolean retval - false in case of error, true in case of success.
    array EnvelopePointObject - an array with all elements of the envelopepoint
    -[1] - TrackEnvelope-object
    -[2] - Envelope-idx, beginning with 0 for the first one
    -[3] - time
    -[4] - value
    -[5] - shape
    -[6] - tension
    -[7] - selected
    -[8] - dBValue converted from value
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, create, db, time, value, envelopepointobject</tags>
</US_DocBloc>
]]

  if reaper.ValidatePtr(TrackEnvelope, "TrackEnvelope*")==false then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "TrackEnvelope", "not a valid Trackenvelope.", -1) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "idx", "not a valid idx. Only integer values allowed.", -2) return false end
  if type(time)~="number" or tonumber(time)<0 then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "time", "not a valid time. Must be a number bigger or equal 0", -3) return false end
  if type(value)~="number" then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "value", "not a valid value. Must be a number.", -4) return false end
  if math.type(shape)~="integer" or (tonumber(shape)<0 or tonumber(shape)>5) then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "shape", "not a valid shape. Must be an integer between 0 and 5", -5) return false end
  if type(tension)~="number" then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "tension", "not a valid tensionvalue. Must be a number.", -6) return false end
  if type(selected)~="boolean" then ultraschall.AddErrorMessage("CreateEnvelopePointObject", "selected", "not a valid selectedvalue. Must be a boolean.", -7) return false end
  local EnvelopePointObject={}
  EnvelopePointObject[1]=TrackEnvelope  
  EnvelopePointObject[2]=idx
  EnvelopePointObject[3]=time
  EnvelopePointObject[4]=value
  EnvelopePointObject[5]=shape
  EnvelopePointObject[6]=tension
  EnvelopePointObject[7]=selected
  EnvelopePointObject[8]=reaper.SLIDER2DB(value)
  return true, EnvelopePointObject
end


function ultraschall.CountEnvelopePoints(Tracknumber, EnvelopeName)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountEnvelopePoints</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer envpoint_count = ultraschall.CountEnvelopePoints(integer Tracknumber, string EnvelopeName)</functioncall>
  <description>
    Counts and returns the number of envelope-points in track Tracknumber, envelopelane EnvelopeName.
    
    returns -1 in case of error
  </description>
  <parameters>
    integer Tracknumber - the number of the track, beginning with 1. Use 0 for Master Track.
    string EnvelopeName - the name of the envelope-lane
  </parameters>
  <retvals>
    integer envpoint_count - the number of envelope-points in requested track+envelope-lane
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, count</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("CountEnvelopePoints", "track", "must be an integer", -1) return -1 end
  if type(EnvelopeName)~="string" then ultraschall.AddErrorMessage("CountEnvelopePoints", "EnvelopeName", "must be a string", -4) return -1 end
  local MediaTrack
  local EnvelopePointObject={}
  if Tracknumber<0 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("CountEnvelopePoints", "track", "no such track", -2) return -1 end
  if Tracknumber==0 then 
    MediaTrack=reaper.GetMasterTrack(0)
  else
    MediaTrack=reaper.GetTrack(0,Tracknumber-1)
  end
  local TrackEnvelope=reaper.GetTrackEnvelopeByName(MediaTrack, EnvelopeName)
  if TrackEnvelope==nil then ultraschall.AddErrorMessage("CountEnvelopePoints","EnvelopeName", "no such envelope", -3) return -1 end
  
  return reaper.CountEnvelopePoints(TrackEnvelope)
end

--A=ultraschall.CountEnvelopePoints(1, "Mute")


function ultraschall.SetEnvelopeHeight(Height, Compacted, TrackEnvelope, TrackEnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopeHeight</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string TrackEnvelopeStateChunk = ultraschall.SetEnvelopeHeight(integer Height, boolean Compacted, TrackEnvelope TrackEnvelope, string TrackEnvelopeStateChunk)</functioncall>
  <description>
    Changes the Envelope-lane-height and compactible state of TrackEnvelope or TrackEnvelopeStateChunk.
    
    returns false in case of an error
  </description>
  <parameters>
    integer Height - the height of the envelopelane in pixels when not compacted. Reaper accepts 24-443 currently. Nil keeps old value.
    boolean Compacted - shall the envelopelane be compacted(true) or not(false). Nil keeps old value.
    TrackEnvelope TrackEnvelope - the TrackEnvelope to alter, or nil to use the TrackEnvelopeStateChunk instead
    optional string TrackEnvelopeStateChunk - the TrackEnvelopeStateChunk you want to alter. Will be used only, if TrackEnvelope is set to nil
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of error
    string TrackEnvelopeStateChunk - the altered TrackEnvelopeStateChunk
  </retvals>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>trackmanagement, trackenvelopestatechunk, set, height, compactible</tags>
</US_DocBloc>
]]
  local str, retval, newstr
  if type(Compacted)~="boolean" and Compacted~=nil then ultraschall.AddErrorMessage("SetEnvelopeHeight","Compacted", "only true, false or nil allowed", -1) return false end
  if math.type(Height)~="integer" and Height~=nil then ultraschall.AddErrorMessage("SetEnvelopeHeight","Height", "only integer(24-443) or nil allowed", -2) return false end
  if TrackEnvelope~=nil then 
    if reaper.ValidatePtr2(0, TrackEnvelope, "TrackEnvelope*")==false then ultraschall.AddErrorMessage("SetEnvelopeHeight", "TrackEnvelope", "not a valid TrackEnvelope", -3) return false end
    retval, str = ultraschall.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  else 
    if type(TrackEnvelopeStateChunk)~="string" then ultraschall.AddErrorMessage("SetEnvelopeHeight","TrackEnvelopeStateChunk", "not a valid TrackEnvelopeStateChunk", -4) return false end
    str=TrackEnvelopeStateChunk
  end
  
  local part1=str:match("(.-)LANE")
  local height=str:match("LANEHEIGHT (.-) .-%c")
  local compacted=str:match("LANEHEIGHT .- (.-)%c")
  local part2=str:match("LANEHEIGHT.-%c(.*)")
  
  if Height~=nil then height=Height end
  if Compacted==true then compacted="1"
  elseif Compacted==false then compacted="0"
  end

  newstr=part1.."LANEHEIGHT "..height.." "..compacted.."\n"..part2
  if TrackEnvelope~=nil then 
    retval, str2 = reaper.SetEnvelopeStateChunk(TrackEnvelope, newstr, false) 
  end
  return true, newstr
end


function ultraschall.IsValidEnvelopePointArray(EnvelopePointArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidEnvelopePointArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidEnvelopePointArray(EnvelopePointArray EnvelopePointArray)</functioncall>
  <description>
    Checks, if an EnvelopePointArray is a valid one.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, EnvelopePointArray is a valid one; false, EnvelopePointArray isn't valid
  </retvals>
  <parameters>
    EnvelopePointArray EnvelopePointArray - the EnvelopePointArray to check for it's validity
  </parameters>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, check, envelopepointarray</tags>
</US_DocBloc>
--]]
  if type(EnvelopePointArray)~="table" then ultraschall.AddErrorMessage("IsValidEnvelopePointArray", "EnvelopePointArray", "Must be a table", -1) return false end
  local counter=1
  while EnvelopePointArray[counter]~=nil do
    if ultraschall.IsValidEnvelopePointObject(EnvelopePointArray[counter])==false then return false end
    counter=counter+1
  end
  return true
end

function ultraschall.GetLastEnvelopePoint_TrackEnvelope(Envelope)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastEnvelopePoint_TrackEnvelope</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional integer envpointidx, optional number time, optional number value, optional integer shape, optional number tension, optional boolean selected =  ultraschall.GetLastEnvelopePoint_TrackEnvelope(TrackEnvelope Envelope)</functioncall>
  <description>
    Gets the values of the last envelope-point in TrackEnvelope/MediaItemEnvelope.
    
    Note: there's a "hidden" last envelopepoint in every Envelope, which will be ignored by this function. It will return the last visible envelope-point instead!
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, getting the envelopepoint was successful; false, in case of an error
    optional integer envpointidx - the idx of the found envelope-point; with 0 for the first one on the Envelope
    optional number time - the time of the envelope-point in seconds
    optional number value - the value of the envelope-point
    optional integer shape - the shape of the envelope-point
                            -0 - Linear
                            -1 - Square
                            -2 - Slow start/end
                            -3 - Fast start
                            -4 - Fast end
                            -5 - Bezier
    optional number tension - the intensity of the tension of the shape
    optional boolean selected - true, envelope-point is selected; false, it is not selected
  </retvals>
  <parameters>
    TrackEnvelope Envelope - the Trackenvelope/MediaItemenvelope, whose last point you want
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, get, db, time, value</tags>
</US_DocBloc>
]]
  if ultraschall.type(Envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetLastEnvelopePoint_TrackEnvelope", "Envelope", "must be a valid Envelope-object", -1) return false end
  local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(Envelope, reaper.CountEnvelopePoints(Envelope)-1)
  if retval==true and reaper.CountEnvelopePoints(Envelope)>1 then
    return retval, reaper.CountEnvelopePoints(Envelope), time, value, shape, tension, selected
  else
    return false
  end
end


function ultraschall.GetArmState_Envelope(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetArmState_Envelope</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetArmState_Envelope(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current armed-state of a TrackEnvelope-object.
    
    It is the entry ARM
    
    returns nil in case of error
  </description>
  <retvals>
    integer retval - 0, unarmed; 1, armed
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose armed-state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, arm, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetArmState_Envelope", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetArmState_Envelope", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  return ultraschall.GetEnvelopeState_NumbersOnly("ARM", str, "GetArmState_Envelope")
end


--TrackEnvelope=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,0),"Mute")
--A,EnvStCh=reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
--A=ultraschall.type(TrackEnvelope)
--B=ultraschall.GetArmState_Envelope(TrackEnveope, EnvStCh)
--]]

function ultraschall.SetArmState_Envelope(TrackEnvelope, state, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetArmState_Envelope</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional string EnvelopeStateChunk = ultraschall.SetArmState_Envelope(TrackEnvelope TrackEnvelope, integer state, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Sets the new armed-state of a TrackEnvelope-object.
    
    returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    optional string EnvelopeStateChunk - the altered EnvelopeStateChunk, when parameter TrackEnvelope is set to nil
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose armed-state you want to change
    integer state - 0, unarmed; 1, armed
    optional string EnvelopeStateChunk - if parameter TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameters and change its arm-state
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, set, arm, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("SetArmState_Envelope", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return false end
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("SetArmState_Envelope", "state", "Must be an integer, either 1 or 0", -2) return false end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("SetArmState_Envelope", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -3) return false end
  if TrackEnvelope~=nil then
    local retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
    return reaper.SetEnvelopeStateChunk(TrackEnvelope, string.gsub(str, "ARM %d*%c", "ARM "..state.."\n"), false)
  else
    return true, string.gsub(EnvelopeStateChunk, "ARM %d*%c", "ARM "..state.."\n")
  end
end


function ultraschall.GetTrackEnvelope_ClickState(mouse_button)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackEnvelope_ClickState</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean clickstate, number position, MediaTrack track, TrackEnvelope envelope, integer EnvelopePointIDX = ultraschall.GetTrackEnvelope_ClickState(integer mouse_button)</functioncall>
  <description>
    Returns the currently clicked Envelopepoint and TrackEnvelope, as well as the current timeposition.
    
    Works only, if the mouse is above the EnvelopePoint while having it clicked!
    
    Returns false, if no envelope is clicked at
  </description>
  <retvals>
    boolean clickstate - true, an envelopepoint has been clicked; false, no envelopepoint has been clicked
    number position - the position, at which the mouse has clicked
    MediaTrack track - the track, from which the envelope and it's corresponding point is taken from
    TrackEnvelope envelope - the TrackEnvelope, in which the clicked envelope-point lies
    integer EnvelopePointIDX - the id of the clicked EnvelopePoint
  </retvals>
  <parameters>
    integer mouse_button - the mousebutton, that shall be clicked at the envelope; you can combine them as flags
                       - -1, get all states
                       - &1, only left mouse button
                       - &2, only right mouse button
                       - &4, Ctrl/Cmd-key
                       - &8, Shift-key
                       - &16, Alt key
                       - &32, Windows key
                       - &64, Middle mouse button
  </parameters>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope management, get, clicked, envelope, envelopepoint</tags>
</US_DocBloc>
--]]
  -- TODO: Has an issue, if the mousecursor drags the item, but moves above or underneath the item(if item is in first or last track).
  --       Even though the item is still clicked, it isn't returned as such.

  if math.type(mouse_button)~="integer" then ultraschall.AddErrorMessage("GetTrackEnvelope_ClickState", "mouse_button", "must be an integer", -1) return false end

  local X,Y=reaper.GetMousePosition()
  local Track, Info = reaper.GetTrackFromPoint(X,Y)
  local A=reaper.JS_Mouse_GetState(mouse_button)
  if A==0 or Info==0 then
    return false
  end
  reaper.BR_GetMouseCursorContext()
  local TrackEnvelope, TakeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
  if TakeEnvelope==true or TrackEnvelope==nil then return false end
  local TimePosition=ultraschall.GetTimeByMouseXPosition(reaper.GetMousePosition())
  local EnvelopePoint=reaper.GetEnvelopePointByTime(TrackEnvelope, TimePosition)
  return true, TimePosition, Track, TrackEnvelope, EnvelopePoint
end

function ultraschall.GetEnvelopeState_NumbersOnly(state, EnvelopeStateChunk, functionname, numbertoggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_NumbersOnly</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table values = ultraschall.GetEnvelopeState_NumbersOnly(string state, optional string EnvelopeStateChunk, optional string functionname, optional boolean numbertoggle)</functioncall>
  <description>
    returns a state from an EnvelopeStateChunk.
    
    It only supports single-entry-states with numbers/integers, separated by spaces!
    All other values will be set to nil and strings with spaces will produce weird results!
    
    returns nil in case of an error
  </description>
  <parameters>
    string state - the state, whose attributes you want to retrieve
    string TrackStateChunk - a statechunk of an envelope
    optional string functionname - if this function is used within specific gettrackstate-functions, pass here the "host"-functionname, so error-messages will reflect that
    optional boolean numbertoggle - true or nil; converts all values to numbers; false, keep them as string versions
  </parameters>
  <retvals>
    table values - all values found as numerical indexed array
  </retvals>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, get, state, envelopestatechunk, envelope</tags>
</US_DocBloc>
]]
  if functionname~=nil and type(functionname)~="string" then ultraschall.AddErrorMessage(functionname,"functionname", "Must be a string or nil!", -6) return nil end
  if functionname==nil then functionname="GetEnvelopeState_NumbersOnly" end
  if type(state)~="string" then ultraschall.AddErrorMessage(functionname, "state", "Must be a string", -7) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage(functionname,"TrackStateChunk", "No valid TrackStateChunk!", -2) return nil end
  
  EnvelopeStateChunk=EnvelopeStateChunk:match(state.." (.-)\n")
  if EnvelopeStateChunk==nil then return end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(EnvelopeStateChunk, " ")
  if numbertoggle~=false then
    for i=1, count do
      individual_values[i]=tonumber(individual_values[i])
    end
  end
  return table.unpack(individual_values)
end

function ultraschall.GetEnvelopeState_Act(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_Act</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer act, integer automation_settings = ultraschall.GetEnvelopeState_Act(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current act-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry ACT
    
    returns nil in case of error
  </description>
  <retvals>
    integer act - 0, bypass on
                - 1, no bypass
    integer automation_settings - automation item-options for this envelope
                                - -1, project default behavior, outside of automation items
                                - 0, automation items do not attach underlying envelope
                                - 1, automation items attach to the underlying envelope on the right side
                                - 2, automation items attach to the underlying envelope on both sides
                                - 3, no automation item-options for this envelope
                                - 4, bypass underlying envelope outside of automation items
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, act, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_Act", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_Act", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  return ultraschall.GetEnvelopeState_NumbersOnly("ACT", str, "GetEnvelopeState_Act")
end

function ultraschall.GetEnvelopeState_Vis(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_Vis</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer visible, integer lane, integer unknown = ultraschall.GetEnvelopeState_Vis(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current visibility-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry VIS
    
    returns nil in case of error
  </description>
  <retvals>
    integer visible - 1, envelope is visible
                    - 0, envelope is not visible
    integer lane - 1, envelope is in it's own lane 
                 - 0, envelope is in media-lane
    integer unknown - unknown; default=1
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, vis, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_Vis", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_Vis", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  return ultraschall.GetEnvelopeState_NumbersOnly("VIS", str, "GetEnvelopeState_Vis")
end

function ultraschall.GetEnvelopeState_LaneHeight(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_LaneHeight</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer height, integer compacted = ultraschall.GetEnvelopeState_LaneHeight(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current laneheight-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry LANEHEIGHT
    
    returns nil in case of error
  </description>
  <retvals>
    integer height - the height of this envelope in pixels; 24 - 263 pixels
    integer compacted - 1, envelope-lane is compacted("normal" height is not shown but still stored in height); 
                      - 0, envelope-lane is "normal" height
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, laneheight, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_LaneHeight", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_LaneHeight", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  return ultraschall.GetEnvelopeState_NumbersOnly("LANEHEIGHT", str, "GetEnvelopeState_LaneHeight")
end

function ultraschall.GetEnvelopeState_DefShape(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_DefShape</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer shape, integer pitch_custom_envelope_range_takes, integer pitch_snap_values = ultraschall.GetEnvelopeState_DefShape(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current default-shape-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry DEFSHAPE
    
    returns nil in case of error
  </description>
  <retvals>
    integer shape - 0, linear
                 - 1, square
                 - 2, slow start/end
                 - 3, fast start
                 - 4, fast end
                 - 5, bezier
       integer pitch_custom_envelope_range_takes - the custom envelope range as set in the Pitch Envelope Settings; only available in take-fx-envelope "Pitch"
                                              - -1, if unset or for non pitch-envelopes
                                              - 0, Custom envelope range-checkbox unchecked
                                              - 1-2147483647, the actual semitones
    integer pitch_snap_values - the snap values-dropdownlist as set in the Pitch Envelope Settings-dialog; only available in take-fx-envelope "Pitch"
                     -  -1, unset/Follow global default
                     -  0, Off
                     -  1, 1 Semitone
                     -  2, 50 cent
                     -  3, 25 cent
                     -  4, 10 cent
                     -  5, 5 cent
                     -  6, 1 cent
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, defshape, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_DefShape", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_DefShape", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  return ultraschall.GetEnvelopeState_NumbersOnly("DEFSHAPE", str, "GetEnvelopeState_DefShape")
end

function ultraschall.GetEnvelopeState_Voltype(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_Voltype</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer voltype = ultraschall.GetEnvelopeState_Voltype(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current voltype-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry VOLTYPE
    
    returns nil in case of error
  </description>
  <retvals>
   integer voltype - 1, default volume-type is fader-scaling; if VOLTYPE-entry is not existing, default volume-type is amplitude-scaling
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, voltype, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_Voltype", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_Voltype", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  local A={ultraschall.GetEnvelopeState_NumbersOnly("VOLTYPE", str, "GetEnvelopeState_Voltype")}
  if A[1]==nil then return 0 else return table.unpack(A) end
end

function ultraschall.GetEnvelopeState_PooledEnvInstance(index, TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_PooledEnvInstance</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer id, number position, number length, number start_offset, number playrate, integer selected, number baseline, integer loopsource, integer i, number j, integer pool_id, integer mute = ultraschall.GetEnvelopeState_PooledEnvInstance(integer index, TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current state of a certain automation-item within a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry POOLEDENVINST
    
    returns nil in case of error
  </description>
  <retvals>
    integer id - counter of automation-items; 1-based
    number position - position in seconds
    number length - length in seconds
    number start_offset - offset in seconds
    number playrate - playrate; minimum value is 0.001; default is 1.000
    integer selected - 1, automation item is selected; 0, automation item isn't selected
    number baseline - 0(-100) to 1(+100); default 0.5(0)
    number amplitude - -2(-200) to 2(+200); default 1 (100)
    integer loopsource - Loop Source; 0 and 1 are allowed settings; 1 is default
    integer i - unknown; 0 is default
    number j - unknown; 0 is default
    integer pool_id - counts the automation-item-instances in this project, including deleted ones; 1-based
    integer mute - 1, mute automation-item; 0, unmute automation-item
  </retvals>
  <parameters>
    integer index - the index-number of the automation-item, whose states you want to have
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, pooled env instance, automation items, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_PooledEnvInstance", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_PooledEnvInstance", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetEnvelopeState_PooledEnvInstance", "index", "Must be an integer", -3) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  
  local count, individual_values, found
  count=0
  found=false
  
  for k in string.gmatch(str, "(POOLEDENVINST.-)\n") do
    count=count+1
    if index==count then
      k=k.." "
      count, individual_values = ultraschall.CSV2IndividualLinesAsArray(k, " ")
      found=true
      break
    end
  end
  
  if found==false then 
    ultraschall.AddErrorMessage("GetEnvelopeState_PooledEnvInstance", "index", "no such automation-item available", -4)
    return 
  else 
    for i=1, count do
      individual_values[i]=tonumber(individual_values[i])
    end
    return table.unpack(individual_values)
  end
end

function ultraschall.GetEnvelopeState_PT(index, TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_PT</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>number position, integer volume, integer point_shape_1, integer point_shape_2, integer selected, number bezier_tens1, number bezier_tens2 = ultraschall.GetEnvelopeState_PT(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current state of a certain envelope-point within a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the state entry PT
    
    returns nil in case of error
  </description>
  <retvals>
    number position - position of the point in seconds
    integer volume - volume as fader-value
    integer point_shape - may disappear with certain shapes, when point is unselected
                        - the values for point_shape_1 and point_shape_2 are:
                        - 0 0, linear
                        - 1 0, square
                        - 2 0, slow start/end
                        - 3 0, fast start
                        - 4 0, fast end
                        - 5 1, bezier
    integer selected - 1, selected; disappearing, unselected
    number unknown - disappears, if no bezier is set
    number bezier_tens2 - disappears, if no bezier is set; -1 to 1 
                        - 0, for no bezier tension
                        - -0.5, for fast-start-beziertension
                        - 0.5, for fast-end-beziertension
                        - 1, for square-tension
  </retvals>
  <parameters>
    integer index - the index-number of the envelope-point, whose states you want to have
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, pt, envelope point, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_PT", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_PT", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetEnvelopeState_PT", "index", "Must be an integer", -3) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  
  local count, individual_values, found
  count=0
  found=false
  
  for k in string.gmatch(str, "(PT .-)\n") do
    count=count+1
    if index==count then
      k=k.." "
      count, individual_values = ultraschall.CSV2IndividualLinesAsArray(k, " ")
      found=true
      break
    end
  end
  
  if found==false then 
    ultraschall.AddErrorMessage("GetEnvelopeState_PT", "index", "no such automation-item available", -4)
    return 
  else 
    for i=1, count do
      individual_values[i]=tonumber(individual_values[i])
    end
    return table.unpack(individual_values)
  end
end

function ultraschall.GetEnvelopeState_EnvName(TrackEnvelope, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEnvelopeState_EnvName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string envelopename, optional integer fx_env_id, optional string wet_byp, optional number minimum_range, optional number maximum_range, optional number unknown = ultraschall.GetEnvelopeState_EnvName(TrackEnvelope TrackEnvelope, optional string EnvelopeStateChunk)</functioncall>
  <description>
    Returns the current envelope-name-state of a TrackEnvelope-object or EnvelopeStateChunk.
    
    It is the opening <-tag of the EnvelopeStateChunk
    
    returns nil in case of error
  </description>
  <retvals>
    string envelopename - the name of the envelope, usually:
                        -   VOLENV2 - for Volume-envelope
                        -   PANENV2 - for Pan-envelope
                        -   WIDTHENV2 - for Width-envelope
                        -   VOLEN - for Pre-FX-Volume-envelope
                        -   PANENV - for Pre-FX-Pan-envelope
                        -   WIDTHENV - for Pre-FX-Width-envelope
                        -   MUTEENV - for Mute-envelope
                        -   VOLENV3 - for Trim-Volume-envelope
                        -   PARMENV - an envelope for an FX-plugin
    optional integer fx_env_id - fx_env is the id of the envelope, as provided by this fx; beginning with 1 for the first
    optional string wet_byp - wet_byp is either "" if not existing, wet or bypass
    optional number minimum_range - the minimum value, accepted by this envelope; 6 digits-precision
    optional number maximum_range - the maximum-value, accepted by this envelope; 6 digits-precision
    optional number unknown - unknown
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the TrackEnvelope, whose state you want to know; nil, to use parameter EnvelopeStateChunk instead
    optional string EnvelopeStateChunk - if TrackEnvelope is set to nil, you can pass an EnvelopeStateChunk into this parameter, to get that armed state
  </parameters>
  <chapter_context>
    Envelope Management
    Get Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope states, get, envelopename, name, minimum, maximum, range, wet, bypass, envelopestatechunk</tags>
</US_DocBloc>
]]  
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("GetEnvelopeState_EnvName", "TrackEnvelope", "Must be a valid TrackEnvelope-object", -1) return end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("GetEnvelopeState_EnvName", "EnvelopeStateChunk", "Must be a valid EnvelopeStateChunk", -2) return end
  local retval, str
  if TrackEnvelope==nil then 
    str=EnvelopeStateChunk
  else
    retval, str = reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  
  local Line=str:match("<(.-)\n")
  local Count, Individual_values = ultraschall.CSV2IndividualLinesAsArray(Line, " ")
  for i=3,Count do
    Individual_values[i]=tonumber(Individual_values[i])
  end
  if Count>1 then
    if tonumber(Individual_values[2])~=nil then
      table.insert(Individual_values, 3, "")
      Individual_values[2]=tonumber(Individual_values[2])
    else
      table.insert(Individual_values, 3, Individual_values[2]:match(":(.*)"))
      Individual_values[2]=tonumber(Individual_values[2]:match("(.-):"))
    end
  end
  return table.unpack(Individual_values)
end

function ultraschall.GetAllTrackEnvelopes(include_mastertrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllTrackEnvelopes</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer number_of_trackenvelopes, table TrackEnvelopes_Table = ultraschall.GetAllTrackEnvelopes()</functioncall>
  <description>
    Returns all TrackEnvelopes of all tracks from the current project as a handy table
    
    The format of the table is as follows:
        TrackEnvelopes[trackenvelope_idx]["Track"] - the idx of the track; 0, for mastertrack, 1, for first track, etc
        TrackEnvelopes[trackenvelope_idx]["EnvelopeObject"] - the TrackEnvelope-object
        TrackEnvelopes[trackenvelope_idx]["EnvelopeName"] - the name of of TrackEnvelopeObject
  </description>
  <retvals>
    integer number_of_trackenvelopes - the number of TrackEnvelopes found in the current project
    table TrackEnvelopes_Table - all found TrackEnvelopes as a handy table(see description for details)
  </retvals>
  <chapter_context>
    Envelope Management
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope management, get all, track envelopes</tags>
</US_DocBloc>
--]]
  local TrackEnvelopesTable={}
  local TrackEnvelopes_Count=0
  local _temp
  
  if include_mastertrack==true then
    local Track=reaper.GetMasterTrack(0)
    for a=0, reaper.CountTrackEnvelopes(Track)-1 do
      TrackEnvelopes_Count=TrackEnvelopes_Count+1
      TrackEnvelopesTable[TrackEnvelopes_Count]={}
      TrackEnvelopesTable[TrackEnvelopes_Count]["Track"]=0
      TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeObject"]=reaper.GetTrackEnvelope(Track, a)
      _temp, TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeName"]=reaper.GetEnvelopeName(TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeObject"])
    end
  end
  
  for i=0, reaper.CountTracks(0)-1 do
    local Track=reaper.GetTrack(0, i)
    for a=0, reaper.CountTrackEnvelopes(Track)-1 do
      TrackEnvelopes_Count=TrackEnvelopes_Count+1
      TrackEnvelopesTable[TrackEnvelopes_Count]={}
      TrackEnvelopesTable[TrackEnvelopes_Count]["Track"]=i+1
      TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeObject"]=reaper.GetTrackEnvelope(Track, a)
      _temp, TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeName"]=reaper.GetEnvelopeName(TrackEnvelopesTable[TrackEnvelopes_Count]["EnvelopeObject"])
    end    
  end
  return TrackEnvelopes_Count, TrackEnvelopesTable
end

--A,B=ultraschall.GetAllTrackEnvelopes(true)

function ultraschall.GetAllTakeEnvelopes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllTakeEnvelopes</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer number_of_takeenvelopes, table TakeEnvelopes_Table = ultraschall.GetAllTakeEnvelopes()</functioncall>
  <description>
    Returns all TakeEnvelopes of all MediaItems from the current project as a handy table
    
    The format of the table is as follows:
        TakeEnvelopes[takeenvelope_idx]["MediaItem"] - the idx of the MediaItem
        TakeEnvelopes[takeenvelope_idx]["MediaItem_Take"] - the idx of the trake of the MediaItem
        TakeEnvelopes[takeenvelope_idx]["MediaItem_Take_Name"] - the name of the MediaItek_Take
        TakeEnvelopes[takeenvelope_idx]["EnvelopeObject"] - the TakeEnvelopeObject in question
        TakeEnvelopes[takeenvelope_idx]["EnvelopeName"] - the name of of TakeEnvelopeObject
  </description>
  <retvals>
    integer number_of_takeenvelopes - the number of TakeEnvelopes found in the current project
    table TakeEnvelopes_Table - all found TakeEnvelopes as a handy table(see description for details)
  </retvals>
  <chapter_context>
    Envelope Management
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope management, get all, take envelopes</tags>
</US_DocBloc>
--]]
  local ItemEnvelopesTable={}
  local ItemEnvelopes_Count=0
  local _temp
    
  for i=0, reaper.CountMediaItems(0)-1 do
    local MediaItem=reaper.GetMediaItem(0, i)
    for x=0, reaper.CountTakes(MediaItem)-1 do
      local MediaItem_Take=reaper.GetMediaItemTake(MediaItem, x)
      for a=0, reaper.CountTakeEnvelopes(MediaItem_Take)-1 do
        ItemEnvelopes_Count=ItemEnvelopes_Count+1
        ItemEnvelopesTable[ItemEnvelopes_Count]={}
        ItemEnvelopesTable[ItemEnvelopes_Count]["MediaItem"]=i+1
        ItemEnvelopesTable[ItemEnvelopes_Count]["MediaItemTake"]=i+1
        ItemEnvelopesTable[ItemEnvelopes_Count]["MediaItemTake_Name"]=reaper.GetTakeName(MediaItem_Take)
        ItemEnvelopesTable[ItemEnvelopes_Count]["EnvelopeObject"]=reaper.GetTakeEnvelope(MediaItem_Take, a)
        _temp, ItemEnvelopesTable[ItemEnvelopes_Count]["EnvelopeName"]=reaper.GetEnvelopeName(ItemEnvelopesTable[ItemEnvelopes_Count]["EnvelopeObject"])
      end    
    end
  end
  return ItemEnvelopes_Count, ItemEnvelopesTable
end

--A,B=ultraschall.GetAllItemEnvelopes()

function ultraschall.SetEnvelopeState_Vis(TrackEnvelope, visibility, lane, unknown, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopeState_Vis</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string EnvelopeStateChunk = ultraschall.SetEnvelopeState_Vis(TrackEnvelope env, integer visibility, integer lane, integer unknown, optional string EnvelopeStateChunk)</functioncall>
  <description>
      sets the current visibility-state of a TrackEnvelope-object or EnvelopeStateChunk.
      
      It is the state entry VIS
      
      returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    string EnvelopeStateChunk - the altered EnvelopeStateChunk
  </retvals>
  <parameters>
    TrackEnvelope env - the envelope, in whose envelope you want set the visibility states; nil, to us parameter EnvelopeStateChunk instead
    integer visibility - the visibility of the envelope; 0, invisible; 1, visible
    integer lane - the position of the envelope in the lane; 0, envelope is in media-lane; 1, envelope is in it's own lane
    integer unknown - unknown; default=1 
    optional string EnvelopeStateChunk - an EnvelopeStateChunk, in which you want to set these settings
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>envelope management, set, envelope, envelope statechunk, lane, visibility</tags>
</US_DocBloc>
--]]
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("SetEnvelopeState_Vis", "TrackEnvelope", "must be a TrackEnvelope", -1) return false end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("SetEnvelopeState_Vis", "EnvelopeStateChunk", "must be a valid EnvelopeStateChunk", -2) return false end
  if math.type(visibility)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_Vis", "visibility", "must be an integer", -3) return false end
  if math.type(lane)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_Vis", "lane", "must be an integer", -4) return false end
  if math.type(unknown)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_Vis", "unknown", "must be an integer", -5) return false end
  local A
  if TrackEnvelope~=nil then
    A,EnvelopeStateChunk=reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  EnvelopeStateChunk=string.gsub(EnvelopeStateChunk, "VIS .-\n", "VIS "..visibility.." "..lane.." "..unknown.."\n")
  if TrackEnvelope~=nil then
    reaper.SetEnvelopeStateChunk(TrackEnvelope, EnvelopeStateChunk, false)
  end
  return true, EnvelopeStateChunk
end


function ultraschall.SetEnvelopeState_Act(TrackEnvelope, act, automation_settings, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopeState_Act</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetEnvelopeState_Act(TrackEnvelope env, integer act, integer automation_settings, optional string EnvelopeStateChunk)</functioncall>
  <description>
      sets the current bypass and automation-items-settings-state of a TrackEnvelope-object or EnvelopeStateChunk.
      
      It is the state entry ACT
      
      returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    string EnvelopeStateChunk - the altered EnvelopeStateChunk
  </retvals>
  <parameters>
    TrackEnvelope env - the envelope, in whose envelope you want set the bypass and automation-item-states; nil, to use parameter EnvelopeStateChunk instead
    integer act - bypass-setting; 
                -   0, bypass on
                -   1, no bypass 
    integer automation_settings - automation item-options for this envelope
                                - -1, project default behavior, outside of automation items
                                - 0, automation items do not attach underlying envelope
                                - 1, automation items attach to the underlying envelope on the right side
                                - 2, automation items attach to the underlying envelope on both sides
                                - 3, no automation item-options for this envelope
                                - 4, bypass underlying envelope outside of automation items 
    optional string EnvelopeStateChunk - an EnvelopeStateChunk, in which you want to set these settings
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>envelope management, set, envelope, envelope statechunk, automation options, automation items, bypass, visibility</tags>
</US_DocBloc>
--]]
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("SetEnvelopeState_Act", "TrackEnvelope", "must be a TrackEnvelope", -1) return false end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("SetEnvelopeState_Act", "EnvelopeStateChunk", "must be a valid EnvelopeStateChunk", -2) return false end
  if math.type(act)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_Act", "act", "must be an integer", -3) return false end
  if math.type(automation_settings)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_Act", "automation_settings", "must be an integer", -4) return false end
  local A
  if TrackEnvelope~=nil then
    A,EnvelopeStateChunk=reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  
  EnvelopeStateChunk=string.gsub(EnvelopeStateChunk, "ACT .-\n", "ACT "..act.." "..automation_settings.."\n")
  if TrackEnvelope~=nil then
    reaper.SetEnvelopeStateChunk(TrackEnvelope, EnvelopeStateChunk, false)
  end
  return true, EnvelopeStateChunk
end

function ultraschall.SetEnvelopeState_DefShape(TrackEnvelope, shape, pitch_custom_envelope_range_takes, pitch_snap_values, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopeState_DefShape</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string EnvelopeStateChunk = ultraschall.SetEnvelopeState_DefShape(TrackEnvelope env, integer shape, integer pitch_custom_envelope_range, integer pitch_snap_values, optional string EnvelopeStateChunk)</functioncall>
  <description>
      sets the current default-shape-states and pitch-snap-settings of a TrackEnvelope-object or EnvelopeStateChunk.
      
      It is the state entry DEFSHAPE
      
      returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    string EnvelopeStateChunk - the altered EnvelopeStateChunk
  </retvals>
  <parameters>
    TrackEnvelope env - the envelope, in whose envelope you want set the default shape and pitch-snap states; nil, to use parameter EnvelopeStateChunk instead
    integer shape - the default shape of envelope-points
                    - 0, linear
                    - 1, square
                    - 2, slow start/end
                    - 3, fast start
                    - 4, fast end
                    - 5, bezier 
    integer pitch_custom_envelope_range_takes - the custom envelope range as set in the Pitch Envelope Settings; only available in take-fx-envelope "Pitch"
                                              - -1, if unset or for non pitch-envelopes
                                              - 0, Custom envelope range-checkbox unchecked
                                              - 1-2147483647, the actual semitones
    integer pitch_snap_values - the snap values-dropdownlist as set in the Pitch Envelope Settings-dialog; only available in take-fx-envelope "Pitch"
                     -  -1, unset/Follow global default
                     -  0, Off
                     -  1, 1 Semitone
                     -  2, 50 cent
                     -  3, 25 cent
                     -  4, 10 cent
                     -  5, 5 cent
                     -  6, 1 cent
    optional string EnvelopeStateChunk - an EnvelopeStateChunk, in which you want to set these settings
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>envelope management, set, envelope, envelope statechunk, shape, pitch snap, visibility</tags>
</US_DocBloc>
--]]
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("SetEnvelopeState_DefShape", "TrackEnvelope", "must be a TrackEnvelope", -1) return false end
  if TrackEnvelope==nil and ultraschall.IsValidEnvStateChunk(EnvelopeStateChunk)==false then ultraschall.AddErrorMessage("SetEnvelopeState_DefShape", "EnvelopeStateChunk", "must be a valid EnvelopeStateChunk", -2) return false end
  if math.type(shape)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_DefShape", "shape", "must be an integer", -3) return false end
  if math.type(pitch_custom_envelope_range_takes)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_DefShape", "pitch_custom_envelope_range_takes", "must be an integer", -4) return false end
  if math.type(pitch_snap_values)~="integer" then ultraschall.AddErrorMessage("SetEnvelopeState_DefShape", "pitch_snap_values", "must be an integer", -5) return false end
  local A
  if TrackEnvelope~=nil then
    A,EnvelopeStateChunk=reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
  end
  EnvelopeStateChunk=string.gsub(EnvelopeStateChunk, "DEFSHAPE .-\n", "DEFSHAPE "..shape.." "..pitch_custom_envelope_range_takes.." "..pitch_snap_values.."\n")
  if TrackEnvelope~=nil then
    reaper.SetEnvelopeStateChunk(TrackEnvelope, EnvelopeStateChunk, false)
  end
  return true, EnvelopeStateChunk
end

function ultraschall.SetEnvelopeState_LaneHeight(TrackEnvelope, height, compacted, EnvelopeStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetEnvelopeState_LaneHeight</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string EnvelopeStateChunk = ultraschall.SetEnvelopeState_LaneHeight(TrackEnvelope env, integer height, integer compacted, optional string EnvelopeStateChunk)</functioncall>
  <description>
      sets the current height-states and compacted-settings of a TrackEnvelope-object or EnvelopeStateChunk.
      
      It is the state entry LANEHEIGHT
      
      returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
    string EnvelopeStateChunk - the altered EnvelopeStateChunk
  </retvals>
  <parameters>
    TrackEnvelope env - the envelope, whose envelope you want set the height and compacted-states; nil, to us parameter EnvelopeStateChunk instead
    integer height - the height of the laneheight; the height of this envelope in pixels; 24 - 263 pixels
    integer compacted - 1, envelope-lane is compacted("normal" height is not shown but still stored in height);
                      - 0, envelope-lane is "normal" height 
    optional string EnvelopeStateChunk - an EnvelopeStateChunk, in which you want to set these settings
    </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>envelope management, set, envelope, envelope statechunk, height, compacted, visibility</tags>
</US_DocBloc>
--]]
    return ultraschall.SetEnvelopeHeight(height, compacted==1, TrackEnvelope, EnvelopeStateChunk)
end


function ultraschall.ActivateEnvelope(Envelope, visible, bypass)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ActivateEnvelope</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.981
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ActivateEnvelope(TrackEnvelope env, optional boolean visible, optional boolean bypass)</functioncall>
  <description>
    Activates an envelope, so it can be displayed in the arrange-view.
    
    Will add an envelope-point at position 0 in the envelope, if no point is in the envelope yet
    
    returns false in case of an error
  </description>
  <retvals>
   boolean retval - true, activating was successful; false, activating was unsuccessful
  </retvals>
  <parameters>
   TrackEnvelope Envelope - the envelope, which you want to activate
   optional boolean visible - true or nil, show envelope; false, don't show envelope
   optional boolean bypass  - true or nil, don't bypass envelope; false, bypass envelope
  </parameters>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelope management, activate, envelope</tags>
</US_DocBloc>
--]]
  -- Meo-Ada Mespotine
  -- activates an envelope
  -- thanks to Sexan for giving the hint to make this work
  --
  -- parameters:
  --    TrackEnvelope Envelope - the envelope, which you want to activate
  --    optional boolean visible - true or nil, show envelope; false, don't show envelope
  --    optional boolean bypass  - true or nil, don't bypass envelope; false, bypass envelope
  if ultraschall.type(Envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("ActivateEnvelope", "Envelope", "must be a trackenvelope-object", -1) return false end
  if visible~=nil and ultraschall.type(visible)~="boolean" then ultraschall.AddErrorMessage("ActivateEnvelope", "visible", "must be either nil or a boolean", -2) return false end
  if bypass~=nil and ultraschall.type(bypass)~="boolean" then ultraschall.AddErrorMessage("ActivateEnvelope", "bypass", "must be either nil or a boolean", -3) return false end
  local _, EnvelopeStateChunk = reaper.GetEnvelopeStateChunk(send_env_vol, "", false)
  if EnvelopeStateChunk:match("PT ")==nil then
   EnvelopeStateChunk = EnvelopeStateChunk:match("(.*)>").."PT 0 1 0\n>"
  end
  if bypass~=false then
    EnvelopeStateChunk = string.gsub(EnvelopeStateChunk, "ACT . ", "ACT 1 ")
  end
  if visible~=false then
    EnvelopeStateChunk = string.gsub(EnvelopeStateChunk, "VIS . ", "VIS 1 ")
  end
  return reaper.SetEnvelopeStateChunk(Envelope, EnvelopeStateChunk, false)
end

function ultraschall.ActivateTrackVolumeEnv(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackVolumeEnv</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackVolumeEnv(integer track)</functioncall>
    <description>
      activates a volume-envelope of a track
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      integer track - the track, whose volume-envelope you want to activate; 1, for the first track
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, volume, activate</tags>
  </US_DocBloc>
  --]]
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ActivateTrackVolumeEnv", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ActivateTrackVolumeEnv", "track", "no such track", -2) return false end
  local env=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,track-1), "Volume")
  local retval
  ultraschall.PreventUIRefresh()
  if env==nil then
    retval = ultraschall.ApplyActionToTrack(tostring(track), 40406)
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackVolumeEnv", "", "already activated", -3)
  end
  ultraschall.RestoreUIRefresh()
  return retval
end

--ultraschall.ActivateTrackVolumeEnv(1)

function ultraschall.ActivateTrackVolumeEnv_TrackObject(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackVolumeEnv_TrackObject</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackVolumeEnv_TrackObject(MediaTrack track)</functioncall>
    <description>
      activates a volume-envelope of a MediaTrack-object
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the track, whose volume-envelope you want to activate
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, volume, activate</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ActivateTrackVolumeEnv_TrackObject", "track", "must be a MediaTrack", -1) return false end
  local env=reaper.GetTrackEnvelopeByName(track, "Volume")
  local retval
  if env==nil then
    ultraschall.PreventUIRefresh()
    local tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    retval = ultraschall.ApplyActionToTrack(tostring(tracknumber), 40406)
    ultraschall.RestoreUIRefresh()
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackVolumeEnv_TrackObject", "", "already activated", -3)
  end
  return retval
end

function ultraschall.ActivateTrackPanEnv(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPanEnv</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPanEnv(integer track)</functioncall>
    <description>
      activates a pan-envelope of a track
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      integer track - the track, whose pan-envelope you want to activate; 1, for the first track
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, pan, activate</tags>
  </US_DocBloc>
  --]]
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ActivateTrackPanEnv", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ActivateTrackPanEnv", "track", "no such track", -2) return false end
  local env=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,track-1), "Pan")
  local retval
  ultraschall.PreventUIRefresh()
  if env==nil then
    retval = ultraschall.ApplyActionToTrack(tostring(track), 40407)
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPanEnv", "", "already activated", -3)
  end
  ultraschall.RestoreUIRefresh()
  return retval
end

--ultraschall.ActivateTrackPanEnv(1)

function ultraschall.ActivateTrackPanEnv_TrackObject(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPanEnv_TrackObject</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPanEnv_TrackObject(MediaTrack track)</functioncall>
    <description>
      activates a pan-envelope of a MediaTrack-object
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the track, whose pan-envelope you want to activate
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, pan, activate</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ActivateTrackPanEnv_TrackObject", "track", "must be a MediaTrack", -1) return false end
  local env=reaper.GetTrackEnvelopeByName(track, "Pan")
  local retval
  if env==nil then
    ultraschall.PreventUIRefresh()
    local tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    retval = ultraschall.ApplyActionToTrack(tostring(tracknumber), 40407)
    ultraschall.RestoreUIRefresh()
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPanEnv_TrackObject", "", "already activated", -3)
  end
  return retval
end

function ultraschall.ActivateTrackPreFXPanEnv(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPreFXPanEnv</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPreFXPanEnv(integer track)</functioncall>
    <description>
      activates a preFX-pan-envelope of a track
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      integer track - the track, whose preFX-pan-envelope you want to activate; 1, for the first track
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, prefx-pan, activate</tags>
  </US_DocBloc>
  --]]
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ActivateTrackPreFXPanEnv", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ActivateTrackPreFXPanEnv", "track", "no such track", -2) return false end
  local env=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,track-1), "Pan (Pre-FX)")
  local retval
  ultraschall.PreventUIRefresh()
  if env==nil then
    retval = ultraschall.ApplyActionToTrack(tostring(track), 40409)
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPreFXPanEnv", "", "already activated", -3)
  end
  ultraschall.RestoreUIRefresh()
  return retval
end

--ultraschall.ActivateTrackPreFXPanEnv(1)

function ultraschall.ActivateTrackPreFXPanEnv_TrackObject(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPreFXPanEnv_TrackObject</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPreFXPanEnv_TrackObject(MediaTrack track)</functioncall>
    <description>
      activates a preFX-pan-envelope of a MediaTrack-object
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the track, whose prefx-pan-envelope you want to activate
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, prefx-pan, activate</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ActivateTrackPreFXPanEnv_TrackObject", "track", "must be a MediaTrack", -1) return false end
  local env=reaper.GetTrackEnvelopeByName(track, "Pan (Pre-FX)")
  local retval
  if env==nil then
    ultraschall.PreventUIRefresh()
    local tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    retval = ultraschall.ApplyActionToTrack(tostring(tracknumber), 40409)
    ultraschall.RestoreUIRefresh()
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPreFXPanEnv_TrackObject", "", "already activated", -3)
  end
  return retval
end

function ultraschall.ActivateTrackPreFXVolumeEnv(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPreFXVolumeEnv</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPreFXVolumeEnv(integer track)</functioncall>
    <description>
      activates a preFX-volume-envelope of a track
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      integer track - the track, whose preFX-volume-envelope you want to activate; 1, for the first track
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, prefx-volume, activate</tags>
  </US_DocBloc>
  --]]
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ActivateTrackPreFXVolumeEnv", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ActivateTrackPreFXVolumeEnv", "track", "no such track", -2) return false end
  local env=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,track-1), "Volume (Pre-FX)")
  local retval
  ultraschall.PreventUIRefresh()
  if env==nil then
    retval = ultraschall.ApplyActionToTrack(tostring(track), 40408)
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPreFXVolumeEnv", "", "already activated", -3)
  end
  ultraschall.RestoreUIRefresh()
  return retval
end

--ultraschall.ActivateTrackPreFXVolumeEnv(1)

function ultraschall.ActivateTrackPreFXVolumeEnv_TrackObject(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackPreFXVolumeEnv_TrackObject</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackPreFXVolumeEnv_TrackObject(MediaTrack track)</functioncall>
    <description>
      activates a preFX-volume-envelope of a MediaTrack-object
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the track, whose prefx-volume-envelope you want to activate
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, prefx-volume, activate</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ActivateTrackPreFXVolumeEnv_TrackObject", "track", "must be a MediaTrack", -1) return false end
  local env=reaper.GetTrackEnvelopeByName(track, "Volume (Pre-FX)")
  local retval
  if env==nil then
    ultraschall.PreventUIRefresh()
    local tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    retval = ultraschall.ApplyActionToTrack(tostring(tracknumber), 40408)
    ultraschall.RestoreUIRefresh()
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackPreFXVolumeEnv_TrackObject", "", "already activated", -3)
  end
  return retval
end

function ultraschall.ActivateTrackTrimVolumeEnv(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackTrimVolumeEnv</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackTrimVolumeEnv(integer track)</functioncall>
    <description>
      activates a trim-volume-envelope of a track
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      integer track - the track, whose trim-volume-envelope you want to activate; 1, for the first track
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, trim-volume, activate</tags>
  </US_DocBloc>
  --]]
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("ActivateTrackTrimVolumeEnv", "track", "must be an integer", -1) return false end
  if track<1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("ActivateTrackTrimVolumeEnv", "track", "no such track", -2) return false end
  local env=reaper.GetTrackEnvelopeByName(reaper.GetTrack(0,track-1), "Trim Volume")
  local retval
  ultraschall.PreventUIRefresh()
  if env==nil then
    retval = ultraschall.ApplyActionToTrack(tostring(track), 42020)
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackTrimVolumeEnv", "", "already activated", -3)
  end
  ultraschall.RestoreUIRefresh()
  return retval
end

--ultraschall.ActivateTrackTrimVolumeEnv(3)

function ultraschall.ActivateTrackTrimVolumeEnv_TrackObject(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ActivateTrackTrimVolumeEnv_TrackObject</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.ActivateTrackTrimVolumeEnv_TrackObject(MediaTrack track)</functioncall>
    <description>
      activates a trim-volume-envelope of a MediaTrack-object
        
      returns false in case of error
    </description>
    <retvals>
      boolean retval - true, activating was successful; false, activating was unsuccessful
    </retvals>
    <parameters>
      MediaTrack track - the track, whose trim-volume-envelope you want to activate
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, trim-volume, activate</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ActivateTrackTrimVolumeEnv_TrackObject", "track", "must be a MediaTrack", -1) return false end
  local env=reaper.GetTrackEnvelopeByName(track, "Trim Volume")
  local retval
  if env==nil then
    ultraschall.PreventUIRefresh()
    local tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    retval = ultraschall.ApplyActionToTrack(tostring(tracknumber), 42020)
    ultraschall.RestoreUIRefresh()
  else 
    retval=false ultraschall.AddErrorMessage("ActivateTrackTrimVolumeEnv_TrackObject", "", "already activated", -3)
  end
  return retval
end


function ultraschall.GetTakeEnvelopeUnderMouseCursor()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetTakeEnvelopeUnderMouseCursor</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>TakeEnvelope env, MediaItem_Take take, number projectposition = ultraschall.GetTakeEnvelopeUnderMouseCursor()</functioncall>
    <description>
      returns the take-envelope underneath the mouse
    </description>
    <retvals>
      TakeEnvelope env - the take-envelope found unterneath the mouse; nil, if none has been found
      MediaItem_Take take - the take from which the take-envelope is
      number projectposition - the project-position
    </retvals>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, take, envelope, mouse position</tags>
  </US_DocBloc>
  --]]
  -- todo: retval for position within the take
  
  local Awindow, Asegment, Adetails = reaper.BR_GetMouseCursorContext()
  local retval, takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
  if takeEnvelope==true then 
    return retval, reaper.BR_GetMouseCursorContext_Position(), reaper.BR_GetMouseCursorContext_Item()
  else
    return nil, reaper.BR_GetMouseCursorContext_Position()
  end
end


function ultraschall.IsAnyNamedEnvelopeVisible(name)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsAnyMuteEnvelopeVisible</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.IsAnyMuteEnvelopeVisible(string name)</functioncall>
    <description>
      returns, if any mute-envelopes are currently set to visible in the current project
      
      Visible=true does include mute-envelopes, who are scrolled outside of the arrangeview
    </description>
    <retvals>
      boolean retval - true, there are visible mute-envelopes in the project; false, no mute-envelope visible
    </retvals>
    <parameters>
      string name - the name of the envelope; case-sensitive, just take the one displayed in the envelope-lane
                  - Standard-Envelopes are: 
                  -      "Volume (Pre-FX)", "Pan (Pre-FX)", "Width (Pre-FX)", "Volume", "Pan", "Width", "Trim Volume", "Mute"
                  - Plugin's envelopes can also be checked against, like
                  -      "Freq-Band 1 / ReaEQ"
    </parameters>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, any mute envelope, envelope, visible</tags>
  </US_DocBloc>
  --]] 
  -- todo: 
  --   visible in viewable arrangeview only, but this is difficult, as I need to know first, how high the arrangeview is.
  for i=0, reaper.CountTracks()-1 do
    local Track=reaper.GetTrack(0,i)
    local TrackEnvelope = reaper.GetTrackEnvelopeByName(Track, name)
    if TrackEnvelope~=nil then
      local Aretval2 = reaper.GetEnvelopeInfo_Value(TrackEnvelope, "I_TCPH_USED")
      if Aretval2>0 then return true end
    end
  end
  return false
end

function ultraschall.IsEnvelope_Track(TrackEnvelope)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsEnvelope_Track</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.IsEnvelope_Track(TrackEnvelope env)</functioncall>
    <description>
      returns, if the envelope is a track envelope(true) or a take-envelope(false)
      
      returns nil in case of an error
    </description>
    <retvals>
      boolean retval - true, the envelope is a TrackEnvelope; false, the envelope is a TakeEnvelope
    </retvals>
    <parameters>
      TrackEnvelope env - the envelope to check
    </parameters>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, check, track envelope, take envelope</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("IsEnvelope_Track", "TrackEnvelope", "must be an envelope-object", -1) return end
  if reaper.GetEnvelopeInfo_Value(Mute, "P_TRACK")==0 then return false else return true end
end

function ultraschall.IsTrackEnvelopeVisible_ArrangeView(TrackEnvelope)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsTrackEnvelopeVisible_ArrangeView</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.IsTrackEnvelopeVisible_ArrangeView(TrackEnvelope env)</functioncall>
    <description>
      returns, if the envelope is currently visible within arrange-view
      
      returns nil in case of an error
    </description>
    <retvals>
      boolean retval - true, the envelope is a TrackEnvelope; false, the envelope is a TakeEnvelope
    </retvals>
    <parameters>
      TrackEnvelope env - the envelope to check for visibility
    </parameters>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, check, track envelope, take envelope, visible, arrangeview</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.IsEnvelope_Track(TrackEnvelope)==false then ultraschall.AddErrorMessage("IsTrackEnvelopeVisible_ArrangeView", "TrackEnvelope", "must be a track-envelope-object", -1) return false end
  if reaper.GetEnvelopeInfo_Value(TrackEnvelope, "I_TCPH_USED")==0 then return false end
  local arrange_view = ultraschall.GetHWND_ArrangeViewAndTimeLine()
  local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(arrange_view)
  
  local Item = reaper.GetMediaTrackInfo_Value(reaper.GetEnvelopeInfo_Value(Mute, "P_TRACK"), "P_ITEM")
  local HeightTrackY = reaper.GetMediaTrackInfo_Value(reaper.GetEnvelopeInfo_Value(Mute, "P_TRACK"), "I_TCPY")
  local HeightTrack = reaper.GetMediaTrackInfo_Value(reaper.GetEnvelopeInfo_Value(Mute, "P_TRACK"), "I_TCPH")
  local HeightEnv = reaper.GetEnvelopeInfo_Value(Mute, "I_TCPH")
  local A=HeightTrack+HeightTrackY+HeightEnv>0
  local B=HeightTrackY+HeightEnv+top<bottom
  return A==B
end


function ultraschall.GetAllActiveEnvelopes_Track(track)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetAllActiveEnvelopes_Track</slug>
    <requires>
      Ultraschall=4.6
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>integer number_of_active_envelopes, table found_envelopes = ultraschall.GetAllActiveEnvelopes_Track(MediaTrack track)</functioncall>
    <description>
      returns all active track-envelopes and their state of visibility and if they are on their own lane.
      
      the returned table is of the following format:
      
        found_envelopes[envelope_idx][1] - the envelope
        found_envelopes[envelope_idx][2] - the visibility of the envelope; 1, visible; 0, invisible
        found_envelopes[envelope_idx][3] - is the envelope on its own lane; 1, on it's own lane; 0, on the media-lane
        
      returns -1 in case of an error
    </description>
    <retvals>
      integer number_of_active_envelopes - the number of active envelopes; -1, in case of an error
      table found_envelopes - the found envelopes(see description for more details)
    </retvals>
    <parameters>
      MediaTrack track - the track, whose active envelopes you want to get
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, track envelope, active envelopes</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("GetAllActiveEnvelopes_Track", "track", "must be a valid MediaTrack", -1) return -1 end
  local TrackEnvelopes={}
  for i=0, reaper.CountTrackEnvelopes(track)-1 do
    local act, automation_settings = ultraschall.GetEnvelopeState_Act(reaper.GetTrackEnvelope(track, i))
    TrackEnvelopes[#TrackEnvelopes+1]={}
    TrackEnvelopes[#TrackEnvelopes][1] = reaper.GetTrackEnvelope(track, i)
    TrackEnvelopes[#TrackEnvelopes][2], TrackEnvelopes[#TrackEnvelopes][3] = ultraschall.GetEnvelopeState_Vis(reaper.GetTrackEnvelope(track, i))
  end
  return #TrackEnvelopes, TrackEnvelopes
end


--A,B=ultraschall.GetAllActiveEnvelopes(reaper.GetTrack(0,0))

function ultraschall.GetAllActiveEnvelopes_Take(take)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetAllActiveEnvelopes_Take</slug>
    <requires>
      Ultraschall=4.6
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>integer number_of_active_envelopes, table found_envelopes = ultraschall.GetAllActiveEnvelopes_Take(MediaItem_Take take)</functioncall>
    <description>
      returns all active take-envelopes and their state of visibility and if they are on their own lane.
      
      the returned table is of the following format:
      
        found_envelopes[envelope_idx][1] - the envelope
        found_envelopes[envelope_idx][2] - the visibility of the envelope; 1, visible; 0, invisible
        found_envelopes[envelope_idx][3] - is the envelope on its own lane; 1, on it's own lane; 0, on the media-lane
        
      returns -1 in case of an error
    </description>
    <retvals>
      integer number_of_active_envelopes - the number of active envelopes; -1, in case of an error
      table found_envelopes - the found envelopes(see description for more details)
    </retvals>
    <parameters>
      MediaItem_Take take - the take, whose active envelopes you want to get
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, take envelope, active envelopes</tags>
  </US_DocBloc>
  --]] 
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetAllActiveEnvelopes_Take", "take", "must be a valid MediaItem_Take", -1) return -1 end
  local TakeEnvelopes={}
  for i=0, reaper.CountTakeEnvelopes(take)-1 do
    local act, automation_settings = ultraschall.GetEnvelopeState_Act(reaper.GetTakeEnvelope(take, i))
    TakeEnvelopes[#TakeEnvelopes+1]={}
    TakeEnvelopes[#TakeEnvelopes][1] = reaper.GetTakeEnvelope(take, i)
    TakeEnvelopes[#TakeEnvelopes][2], TakeEnvelopes[#TakeEnvelopes][3] = ultraschall.GetEnvelopeState_Vis(reaper.GetTakeEnvelope(take, i))
  end
  return #TakeEnvelopes, TakeEnvelopes
end

function ultraschall.GetTrackEnvelopeFromPoint(x,y)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetTrackEnvelopeFromPoint</slug>
    <requires>
      Ultraschall=4.6
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>TrackEnvelope envelope = ultraschall.GetTrackEnvelopeFromPoint(integer x, integer y)</functioncall>
    <description>
      returns the TrackEnvelope at position x,y if existing
      
      returns nil in case of an error
    </description>
    <retvals>
      TrackEnvelope envelope - the envelope found at position x and y
    </retvals>
    <parameters>
      integer x - the x-position in pixels, at which to look for envelopes
      integer y - the y-position in pixels, at which to look for envelopes
    </parameters>
    <chapter_context>
      Envelope Management
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, track envelope, from point</tags>
  </US_DocBloc>
  --]] 
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("GetTrackEnvelopeFromPoint", "x", "must be an integer", -1) return end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("GetTrackEnvelopeFromPoint", "y", "must be an integer", -2) return end
  local track, envelope=reaper.GetThingFromPoint(x,y)
  local envid=tonumber(envelope:match("envelope (%d*)"))
  if envid==nil then
    envid=tonumber(envelope:match("envcp.- (%d*)"))
  end
  if envid~=nil then
    local found, envs = ultraschall.GetAllActiveEnvelopes_Track(track)
    return envs[envid+1][1]
  end
  ultraschall.AddErrorMessage("GetTrackEnvelopeFromPoint", "", "no envelope found at position", -3)
end

function ultraschall.GetTakeEnvelopeFromPoint(x,y)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetTakeEnvelopeFromPoint</slug>
    <requires>
      Ultraschall=4.6
      Reaper=6.10
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>TakeEnvelope env, MediaItem_Take take, number projectposition = ultraschall.GetTakeEnvelopeFromPoint(integer x, integer y)</functioncall>
    <description>
      returns the take-envelope at positon x and y in pixels, if existing
    </description>
    <retvals>
      TakeEnvelope env - the take-envelope found unterneath the mouse; nil, if none has been found
      MediaItem_Take take - the take from which the take-envelope is
      number projectposition - the project-position
    </retvals>
    <parameters>
      integer x - the x-position in pixels, at which to look for envelopes
      integer y - the y-position in pixels, at which to look for envelopes
    </parameters>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, take, envelope, from point, position</tags>
  </US_DocBloc>
  --]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("GetTakeEnvelopeFromPoint", "x", "must be an integer", -1) return end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("GetTakeEnvelopeFromPoint", "y", "must be an integer", -2) return end
  local x2,y2=reaper.GetMousePosition()
  reaper.JS_Mouse_SetPosition(x, y)
  local Awindow, Asegment, Adetails = reaper.BR_GetMouseCursorContext()
  local retval, takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
  reaper.JS_Mouse_SetPosition(x2, y2)  
  if takeEnvelope==true then 
    return retval, reaper.BR_GetMouseCursorContext_Position(), reaper.BR_GetMouseCursorContext_Item()
  else
    return nil, reaper.BR_GetMouseCursorContext_Position()
  end
end


function ultraschall.IsEnvelopeTrackEnvelope(Envelope)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsEnvelopeTrackEnvelope</slug>
    <requires>
      Ultraschall=4.6
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean is_track_envelope = ultraschall.IsEnvelopeTrackEnvelope(TrackEnvelope Envelope)</functioncall>
    <description>
      checks, whether the passed envelope is a TrackEnvelope
      
      returns nil in case of an error
    </description>
    <retvals>
      boolean is_track_envelope - true, envelope is a TrackEnvelope; false, envelope is not TakeEnvelope
    </retvals>
    <parameters>
      TrackEnvelope Envelope - the envelope to check, if it's a TrackEnvelope
    </parameters>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, check, track, envelope</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(Envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("IsEnvelopeTrackEnvelope", "Envelope", "must be a valid TrackEnvelope", -1) return end
  for i=0, reaper.CountTracks(0,0)-1 do
    for a=0, reaper.CountTrackEnvelopes(reaper.GetTrack(0,i)) do
      local env=reaper.GetTrackEnvelope(reaper.GetTrack(0,i),a)
      if env==Envelope then
        return true
      end
    end
  end
  return false
end

function ultraschall.DeleteTrackEnvelopePointsBetween(startposition, endposition, MediaTrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteTrackEnvelopePointsBetween</slug>
  <requires>
    Ultraschall=4.9
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeleteTrackEnvelopePointsBetween(number startposition, number endposition, MediaTrack MediaTrack)</functioncall>
  <description>
    Deletes all track-envelopepoints between startposition and endposition in MediaTrack. 
    
    Returns -1 in case of failure.
  </description>
  <retvals>
    integer retval - -1 in case of failure
  </retvals>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    MediaTrack MediaTrack - the MediaTrack object of the track, where the EnvelopsPoints shall be moved
  </parameters>
  <chapter_context>
    Envelope Management
    Set Envelope
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
  <tags>envelopemanagement, envelope, point, envelope point, delete, between</tags>
</US_DocBloc>
]]
-- To Do: Only insert mute envelope point, when mute would change
  if type(startposition)~="number" then ultraschall.AddErrorMessage("DeleteTrackEnvelopePointsBetween", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("DeleteTrackEnvelopePointsBetween", "endposition", "must be a number", -2) return -1 end
  if reaper.ValidatePtr2(0, MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("DeleteTrackEnvelopePointsBetween", "MediaTrack", "must be a valid MediaTrack", -4) return -1 end

  local EnvTrackCount=reaper.CountTrackEnvelopes(MediaTrack)

  for a=0, EnvTrackCount-1 do    
    local TrackEnvelope=reaper.GetTrackEnvelope(MediaTrack, a)
    --print2(reaper.GetEnvelopeName(TrackEnvelope))
    local EnvCount=reaper.CountEnvelopePoints(TrackEnvelope)
    local retval, name=reaper.GetEnvelopeName(TrackEnvelope)
  
    --for i=EnvCount-1, 0, -1 do
      --local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnvelope, i)
      --if time>=startposition and time<=endposition then
      local Aretval, value, dVdS, ddVdS, dddVdS = reaper.Envelope_Evaluate(TrackEnvelope, startposition-0.0000001, 0, 0)
      local shape=0
      --[[
      if name=="Mute" then 
        if value<1 then value=0 end
        shape=1
        --reaper.InsertEnvelopePoint(TrackEnvelope, startposition-0.0000001, value, 0, 0, false, false)
      end
      --]]
      
      local Aretval, value, dVdS, ddVdS, dddVdS = reaper.Envelope_Evaluate(TrackEnvelope, endposition+0.0000001, 0, 0)
     
      if name=="Mute" then -- and reaper.CountEnvelopePoints(TrackEnvelope)>0 then
        --[[
        local oldval=0
        for i=reaper.CountEnvelopePoints(TrackEnvelope)-1, 0, -1 do
          local retval, time, value = reaper.GetEnvelopePoint(TrackEnvelope, i)
          if time<=endposition then oldval=value break end
        end
        
        if oldvalue~=value then
        end
        --]]
        if value<1 then value=0 end
        reaper.InsertEnvelopePoint(TrackEnvelope, endposition+0.0000001, value, 1, 0, false, false)
      end
      
      local boolean=reaper.DeleteEnvelopePointRange(TrackEnvelope, startposition, endposition)
    --end
    reaper.Envelope_SortPoints(TrackEnvelope)
  end
  return 0
end

