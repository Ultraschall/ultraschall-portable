--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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

ultraschall={}

function ultraschall.SetTrackRecState(tracknumber, ArmState, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath, TrackStateChunk)
  if tonumber(tracknumber)==nil then return false end
  if tonumber(tracknumber)<-1 or tonumber(tracknumber)>reaper.CountTracks(0) then return false end
  if type(ArmState)~="number" then return false end
  if type(InputChannel)~="number" then return false end
  if type(MonitorInput)~="number" then return false end
  if type(RecInput)~="number" then return false end
  if type(MonitorWhileRec)~="number" then return false end
  if type(presPDCdelay)~="number" then return false end
  if type(RecordingPath)~="number" then return false end
  
  tracknumber=tonumber(tracknumber)
  local str="REC "..ArmState.." "..InputChannel.." "..MonitorInput.." "..RecInput.." "..MonitorWhileRec.." "..presPDCdelay.." "..RecordingPath
  
  local Mediatrack, A, AA, B
  if tonumber(tracknumber)~=-1 then
    if tracknumber==0 then Mediatrack=reaper.GetMasterTrack(0)
    else
      Mediatrack=reaper.GetTrack(0,tracknumber-1)
    end
    A,AA=reaper.GetTrackStateChunk(Mediatrack,str,false)
  else
    if type(TrackStateChunk)~="string" then return false end
    AA=TrackStateChunk
  end
  
  local B1=AA:match("(.-)REC")
  local B3=AA:match("REC.-%c(.*)")
  if B1==nil then B1=AA:match("(.-TRACK)") B3=AA:match(".-TRACK(.*)") end
  if tonumber(tracknumber)~=-1 then
    B=reaper.SetTrackStateChunk(Mediatrack,B1.."\n"..str.."\n"..B3,false)
  else
    B=true
  end
  return B, B1.."\n"..str.."\n"..B3
end 


function ultraschall.GetTrackRecState(tracknumber, str)
  if tonumber(tracknumber)==nil then return nil end
  if tonumber(tracknumber)~=-1 then
    local retval, MediaTrack
    if tonumber(tracknumber)<0 or tonumber(tracknumber)>reaper.CountTracks(0) then return nil end
      tracknumber=tonumber(tracknumber)
      if tracknumber==0 then MediaTrack=reaper.GetMasterTrack(0)
      else MediaTrack=reaper.GetTrack(0, tracknumber-1)
      end
      retval, str = reaper.GetTrackStateChunk(MediaTrack, "test", false)
    else
  end
  if str==nil or str:match("<TRACK.*>")==nil then return nil end
  
  local Track_Rec=str:match("REC.-%c") Track_Rec=Track_Rec:sub(4,-2)
  local Track_Rec1=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec2=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec3=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec4=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec5=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec6=Track_Rec:match("(%b  )") Track_Rec=Track_Rec:match(".(%s.*)")
  local Track_Rec7=Track_Rec
  return tonumber(Track_Rec1), tonumber(Track_Rec2), tonumber(Track_Rec3), tonumber(Track_Rec4), tonumber(Track_Rec5), tonumber(Track_Rec6), tonumber(Track_Rec7)
end 

-----------------------------------
---- toggle solo of all tracks ----
-----------------------------------


if reaper.GetPlayState()&4~=4 then
  RecArms=false
  
  for i=1, reaper.CountTracks() do
    ArmState, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath = ultraschall.GetTrackRecState(i)
    if ArmState~=0 then RecArms=true end
  end
  
  
  for i=1, reaper.CountTracks() do
    if RecArms==true then
      reaper.ClearAllRecArmed()
    else
      ArmState, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath = ultraschall.GetTrackRecState(i)
      retval = ultraschall.SetTrackRecState(i, 1, InputChannel, MonitorInput, RecInput, MonitorWhileRec, presPDCdelay, RecordingPath)
    end
  end
else
  reaper.MB("You must stop recording first, before toggling the arming state for all tracks!","Toggle recarm of all tracks",0)
end
