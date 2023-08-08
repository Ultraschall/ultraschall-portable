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
---       Razor Edit Module       ---
-------------------------------------

function ultraschall.RazorEdit_ProjectHasRazorEdit()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_ProjectHasRazorEdit</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_ProjectHasRazorEdit()</functioncall>
  <description>
    Returns, if the project has any razor-edits available.
  </description>
  <retvals>
    boolean retval - true, project has razor-edits; false, project has no razor-edits
  </retvals>
  <chapter_context>
    Razor Edit
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, is, any</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    local track=reaper.GetTrack(0,i)
    local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
    if B~="" then return true end
  end
  
  return false
end


--A=ultraschall.RazorEdit_ProjectHasRazorEdit()

function ultraschall.RazorEdit_GetAllRazorEdits(exclude_envelope, exclude_track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetAllRazorEdits</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer number_razor_edits, table RazorEditTable = ultraschall.RazorEdit_GetAllRazorEdits(optional boolean exclude_envelope, optional boolean exclude_track)</functioncall>
  <description>
    Returns the number of Razor Edits available and all its entries as a handy table.
    
    The table is of the following format(index is the index of all available razor-edits):        
    
        RazorEditTable[index]["Start"] - the startposition of the RazorEdit in seconds
        RazorEditTable[index]["End"] - the endposition of the RazorEdit in seconds
        RazorEditTable[index]["IsTrack"] - true, it's a track-RazorEdit; false, it's RazorEdit for an envelope
        RazorEditTable[index]["Tracknumber"] - the number of the track, in which the RazorEdit happens
        RazorEditTable[index]["Track"] - the trackobject of the track, in which the RazorEdit happens
        RazorEditTable[index]["Envelope_guid"] - the guid of the envelope, in which the RazorEdit happens; "" if it's for the entire track
        
    The following are optional entries:
        RazorEdit[index]["Envelope"] - the TrackEnvelope-object, when RazorEdit is for an envelope; nil, otherwise
        RazorEdit[index]["Envelope_name"] - the name of the envelope, when RazorEdit is for an envelope; nil, otherwise    
  </description>
  <retvals>
    integer number_razor_edits - the number of razor_edits available in the current project; 0, if none
    table RazorEditTable - a table with all attributes of all Razor-Edits available
  </retvals>
  <parameters>
    optional boolean exclude_envelope - true, exclude the envelope-razor-edit-areas from the list; false or nil, include envelope-razor-edit-areas
    optional boolean exclude_track - true, exclude the track-razor-edit-areas from the list; false or nil, include track-razor-edit-areas
  </parameters>
  <chapter_context>
    Razor Edit
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, all, attributes</tags>
</US_DocBloc>
]]
  local RazorEdit={}
  local RazorEdit_count=0
  for a=0, reaper.CountTracks(0)-1 do
    local retval
    local track=reaper.GetTrack(0,a)
    local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
    local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(B, " ")
    if count>1 then
      for i=1, count, 3 do
        RazorEdit_count=RazorEdit_count+1
        RazorEdit[RazorEdit_count]={}
        if individual_values[i+2]=="\"\"" then 
          RazorEdit[RazorEdit_count]["IsTrack"]=true
          
        elseif individual_values[i+2]:len()>4 then
          RazorEdit[RazorEdit_count]["IsTrack"]=false
          RazorEdit[RazorEdit_count]["Envelope"]=reaper.GetMediaTrackInfo_Value(track, "P_ENV:"..individual_values[i+2]:sub(2,-2))
          retval, RazorEdit[RazorEdit_count]["Envelope_name"] = reaper.GetEnvelopeName(RazorEdit[RazorEdit_count]["Envelope"])
        end
        RazorEdit[RazorEdit_count]["Tracknumber"]=a+1
        RazorEdit[RazorEdit_count]["Track"]=track
        RazorEdit[RazorEdit_count]["Start"]=tonumber(individual_values[i])
        RazorEdit[RazorEdit_count]["End"]=tonumber(individual_values[i+1])
        RazorEdit[RazorEdit_count]["Envelope_guid"]=individual_values[i+2]:sub(2,-2)
      end
    end
  end
  
    if exclude_envelope==true then
    for i=#RazorEdit, 1, -1 do
      if RazorEdit[i]["IsTrack"]==false then 
        table.remove(RazorEdit, i)
      end
    end
  end
  
  if exclude_track==true then
    for i=#RazorEdit, 1, -1 do
      if RazorEdit[i]["IsTrack"]==true then 
        table.remove(RazorEdit, i)
      end
    end
  end
  
  return RazorEdit_count, RazorEdit
end

function ultraschall.RazorEdit_GetRazorEdits_Track(track, exclude_envelope, exclude_track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetRazorEdits_Track</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer number_razor_edits, table RazorEditTable = ultraschall.RazorEdit_GetRazorEdits_Track(MediaTrack track, optional boolean exclude_envelope, optional boolean exclude_track)</functioncall>
  <description>
    Returns the number of Razor Edits of a track and all its entries as a handy table.
    
    The table is of the following format(index is the index of all available razor-edits):        
    
        RazorEditTable[index]["Start"] - the startposition of the RazorEdit in seconds
        RazorEditTable[index]["End"] - the endposition of the RazorEdit in seconds
        RazorEditTable[index]["IsTrack"] - true, it's a track-RazorEdit; false, it's RazorEdit for an envelope
        RazorEditTable[index]["Tracknumber"] - the number of the track, in which the RazorEdit happens
        RazorEditTable[index]["Track"] - the trackobject of the track, in which the RazorEdit happens
        RazorEditTable[index]["Envelope_guid"] - the guid of the envelope, in which the RazorEdit happens; "" if it's for the entire track
        
    The following are optional entries:
        RazorEdit[index]["Envelope"] - the TrackEnvelope-object, when RazorEdit is for an envelope; nil, otherwise
        RazorEdit[index]["Envelope_name"] - the name of the envelope, when RazorEdit is for an envelope; nil, otherwise    
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_razor_edits - the number of razor_edits available in the track; 0, if none
    table RazorEditTable - a table with all attributes of all track-Razor-Edits available
  </retvals>
  <parameters>
    optional boolean exclude_envelope - true, exclude the envelope-razor-edit-areas from the list; false or nil, include envelope-razor-edit-areas
    optional boolean exclude_track - true, exclude the track-razor-edit-areas from the list; false or nil, include track-razor-edit-areas
  </parameters>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, track, envelope, attributes</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_GetRazorEdits_Track", "track", "must be a valid MediaTrack", -1) return -1 end
  local RazorEdit={}
  local RazorEdit_count=0
  local retval
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(B, " ")
  if count>1 then
    for i=1, count, 3 do
      RazorEdit_count=RazorEdit_count+1
      RazorEdit[RazorEdit_count]={}
      if individual_values[i+2]=="\"\"" then 
        RazorEdit[RazorEdit_count]["IsTrack"]=true
        
      elseif individual_values[i+2]:len()>4 then
        RazorEdit[RazorEdit_count]["IsTrack"]=false
        RazorEdit[RazorEdit_count]["Envelope"]=reaper.GetMediaTrackInfo_Value(track, "P_ENV:"..individual_values[i+2]:sub(2,-2))
        retval, RazorEdit[RazorEdit_count]["Envelope_name"] = reaper.GetEnvelopeName(RazorEdit[RazorEdit_count]["Envelope"])
      end
      RazorEdit[RazorEdit_count]["Tracknumber"]=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
      RazorEdit[RazorEdit_count]["Track"]=track
      RazorEdit[RazorEdit_count]["Start"]=tonumber(individual_values[i])
      RazorEdit[RazorEdit_count]["End"]=tonumber(individual_values[i+1])
      RazorEdit[RazorEdit_count]["Envelope_guid"]=individual_values[i+2]:sub(2,-2)
    end
  end

  if exclude_envelope==true then
    for i=#RazorEdit, 1, -1 do
      if RazorEdit[i]["IsTrack"]==false then 
        table.remove(RazorEdit, i)
      end
    end
  end
  
  if exclude_track==true then
    for i=#RazorEdit, 1, -1 do
      if RazorEdit[i]["IsTrack"]==true then 
        table.remove(RazorEdit, i)
      end
    end
  end
  
  return RazorEdit_count, RazorEdit
end

function ultraschall.RazorEdit_Nudge_Track(track, nudge_delta, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Nudge_Track</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Nudge_Track(MediaTrack track, number nudge_delta, optional integer index)</functioncall>
  <description>
    Nudges razor-edits of a track, leaving the envelopes untouched.
    
    To nudge razor-edit-areas of a specific TrackEnvelope, use RazorEdit_Nudge_Envelope instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, nudging was successful; false, nudging was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to nudge
    number nudge_delta - the amount to nudge the razor-edit-areas, negative, left; positive, right
    optional integer index - allows to nudge only the n-th razor-edit-area in the track; nil, to nudge all in the track(except envelope)
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Nudge_Envelope
             nudges the razor-edit areas of a specific TrackEnvelope only
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, nudge, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Track", "track", "must be a valid MediaTrack", -1) return false end
  if type(nudge_delta)~="number" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Track", "nudge_delta", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Track", "index", "must be nil or an integer", -3) return false end
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  local exclude_envelope=true
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\"\"" and exclude_track~=true then
      count=count+1
      if index~=nil and count==index then
        a=a+nudge_delta
        b=b+nudge_delta
      elseif index==nil then
        a=a+nudge_delta
        b=b+nudge_delta
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  
  return true
end

--ultraschall.RazorEdit_Nudge(reaper.GetTrack(0,0), 10, nil)

function ultraschall.RazorEdit_Nudge_Envelope(TrackEnvelope, nudge_delta, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Nudge_Envelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Nudge_Envelope(TrackEnvelope TrackEnvelope, number nudge_delta, optional integer index)</functioncall>
  <description>
    Nudges razor-edits of a specific TrackEnvelope
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, nudging was successful; false, nudging was unsuccessful
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, whose razor-edit-areas you want to nudge
    number nudge_delta - the amount to nudge the razor-edit-areas, negative, left; positive, right
    optional integer index - allows to nudge only the n-th razor-edit-area in the envelope; nil, to nudge all in the envelope
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Nudge_Track
             nudges the razor-edit areas of a specific Track only
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, nudge, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Envelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return false end
  if type(nudge_delta)~="number" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Envelope", "nudge_delta", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Nudge_Envelope", "index", "must be nil or an integer", -5) return false end
  
  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\""..Guid.."\"" then
      count=count+1
      if index~=nil and count==index then
        a=a+nudge_delta
        b=b+nudge_delta
      elseif index==nil then
        a=a+nudge_delta
        b=b+nudge_delta
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  return true
end

function ultraschall.RazorEdit_RemoveAllFromTrack(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_RemoveAllFromTrack</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_RemoveAllFromTrack(MediaTrack track)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    removes all Razor Edits from a MediaTrack(leaves razor-edit-areas of envelopes untouched!)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to remove
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveAllFromEnvelope
             removes the razor-edit areas of a specific TrackEnvelope
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_RemoveAllFromTrack", "track", "must be a valid MediaTrack", -1) return false end
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    C=c
    if c=="\"\"" then
    else
      newstring=newstring..a.." "..b.." "..c.." "
    end
  end
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  
  return true
end

--ultraschall.RazorEdit_RemoveAllFromTrack(reaper.GetTrack(0,0))

function ultraschall.RazorEdit_RemoveAllFromEnvelope(TrackEnvelope)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_RemoveAllFromEnvelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_RemoveAllFromEnvelope(TrackEnvelope TrackEnvelope)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    removes all Razor Edits from a TrackEnvelope
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, whose razor-edits you want to remove
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveFromTrack
             removes the razor-edit areas of a specific track only(envelopes stay untouched)
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_RemoveAllFromEnvelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return false end

  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    C=c
    if c=="\""..Guid.."\"" then
    else
      newstring=newstring..a.." "..b.." "..c.." "
    end
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  
  return true
end

function ultraschall.RazorEdit_RemoveAllFromTrackAndEnvelope(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_RemoveAllFromTrackAndEnvelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_RemoveAllFromTrackAndEnvelope(MediaTrack track)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    removes all Razor Edits from a MediaTrack including its envelopes.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to remove(including its envelopes)
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveAllFromTrack
             removes the razor-edit areas of a track
      inline:RazorEdit_RemoveAllFromEnvelope
             removes the razor-edit areas of a specific TrackEnvelope
  </linked_to>
  <chapter_context>
    Razor Edit
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, track, envelopes</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_RemoveAllFromTrackAndEnvelope", "track", "must be a valid MediaTrack", -1) return false end
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", true)  
end

function ultraschall.RazorEdit_Add_Track(track, start_position, end_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Add_Track</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_Add_Track(MediaTrack track, number start_position, number end_position)</functioncall>
  <description>
    adds razor-edit-areas to a track(leaves all of its envelopes untouched)
    
    added razor-edit-areas might be combined into other ones, so this function returns the changed razor-edit-string for later reference
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>  
  <parameters>
    MediaTrack track - the track, to which you want to add razor-edits
    number start_position - the start-position, from which to add the razor-edit
    number end_position - the end-position, to which to add the razor-edit
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Add_Envelope
             adds razor-edit areas to a specific TrackEnvelope
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, add, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Add_Track", "track", "must be a MediaTrack", -1) return end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Add_Track", "start_position", "must be a number", -2) return end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Add_Track", "end_position", "must be a number", -3) return end
  local A,B
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", B.." "..start_position.." "..end_position.." \"\"", true)
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end
  
--ultraschall.RazorEdit_AddArea(reaper.GetTrack(0,0), 20, 130)

function ultraschall.RazorEdit_Add_Envelope(envelope, start_position, end_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Add_Envelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_Add_Envelope(TrackEnvelope envelope, number start_position, number end_position)</functioncall>
  <description>
    adds razor-edit-areas to a TrackEnvelope only
    
    added razor-edit-areas might be combined into other ones, so this function returns the changed razor-edit-string for later reference
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>
  <parameters>
    TrackEnvelope envelope - the envelope, to which you want to add razor-edits
    number start_position - the start-position, from which to add the razor-edit
    number end_position - the end-position, to which to add the razor-edit
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Add_Track
             adds razor-edit areas to a specific track
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, add, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_Add_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Add_Envelope", "start_position", "must be a number", -2) return end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Add_Envelope", "end_position", "must be a number", -3) return end
  
  local track=reaper.Envelope_GetParentTrack(envelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
  local A,B
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", B.." "..start_position.." "..end_position.." \""..Guid.."\"", true)
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end

--print3(ultraschall.RazorEdit_Add_Envelope(reaper.GetSelectedEnvelope(0), 5, 15))

function ultraschall.RazorEdit_Remove_Track(track, start_position, end_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Remove_Track</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_Remove_Track(MediaTrack track, number start_position, number end_position)</functioncall>
  <description>
    removes razor-edit-areas from a track(leaves all of its envelopes untouched)
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>
  <parameters>
    MediaTrack track - the track, from which you want to remove razor-edit-areas
    number start_position - the start-position, from which to remove razor-edit-areas
    number end_position - the end-position, to which to which to remove the razor-edit-areas
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Remove_Envelope
             removes razor-edit areas from a specific TrackEnvelope
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Remove_Track", "track", "must be a MediaTrack", -1) return end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Remove_Track", "start_position", "must be a number", -2) return end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Remove_Track", "end_position", "must be a number", -3) return end
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  local newstring=""
  for a, b, c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\"\"" then
      a=tonumber(a)
      b=tonumber(b)
      if a>end_position and b>end_position then -- after selection
        --print2("A")
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a<start_position and b<start_position then -- before selection
        --print2("B")
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a<=start_position and b>=start_position and b<=end_position then -- reaching in from the left -> shorten
        --print2("1")
        b=start_position
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a>=start_position and b>=end_position then -- reaching out to the right -> shorten
        --print2("2")
        a=end_position
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a>start_position and b<end_position then -- completely enclosed by selection -> remove
        --print2("3")
      elseif a<start_position and b>end_position then -- selection is within -> split into two
        --print2("4")
        newstring=newstring..a.." "..start_position.." "..c.." "
        newstring=newstring..end_position.." "..b.." "..c.." "
      end
    else -- keep the rest
      --print2("5")
      newstring=newstring..a.." "..b.." "..c.." "
    end

    
  end
      reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end
--A,B=reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0,0), "P_RAZOREDITS", "30.000000 174.000000 \"\"", true)

--ultraschall.RazorEdit_Remove_Track(reaper.GetTrack(0,0), 60, 80)

function ultraschall.RazorEdit_Remove_Envelope(envelope, start_position, end_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Remove_Envelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_Remove_Envelope(TrackEnvelope envelope, number start_position, number end_position)</functioncall>
  <description>
    removes razor-edit-areas from a TrackEnvelope only
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>
  <parameters>
    TrackEnvelope envelope - the envelope, from which you want to remove razor-edit-areas
    number start_position - the start-position, from which to remove razor-edit-areas
    number end_position - the end-position, to which to remove the razor-edit-areas
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Remove_Envelope
             removes razor-edit areas from a specific track
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_Remove_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Remove_Envelope", "start_position", "must be a number", -2) return end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_Remove_Envelope", "end_position", "must be a number", -3) return end

  local track=reaper.Envelope_GetParentTrack(envelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  local newstring=""
  for a, b, c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\""..Guid.."\"" then
      a=tonumber(a)
      b=tonumber(b)
      if a>end_position and b>end_position then -- after selection
        --print2("A")
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a<start_position and b<start_position then -- before selection
        --print2("B")
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a<=start_position and b>=start_position and b<=end_position then -- reaching in from the left -> shorten
        --print2("1")
        b=start_position
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a>=start_position and b>=end_position then -- reaching out to the right -> shorten
        --print2("2")
        a=end_position
        newstring=newstring..a.." "..b.." "..c.." "
      elseif a>start_position and b<end_position then -- completely enclosed by selection -> remove
        --print2("3")
      elseif a<start_position and b>end_position then -- selection is within -> split into two
        --print2("4")
        newstring=newstring..a.." "..start_position.." "..c.." "
        newstring=newstring..end_position.." "..b.." "..c.." "
      end
    else -- keep the rest
      --print2("5")
      newstring=newstring..a.." "..b.." "..c.." "
    end
    
  end
  reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end

function ultraschall.RazorEdit_CountAreas_Envelope(TrackEnvelope)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_CountAreas_Envelope</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer razor_edit_area_count = ultraschall.RazorEdit_CountAreas_Envelope(TrackEnvelope TrackEnvelope)</functioncall>
  <description>
    Counts razor-edit-areas of a specific TrackEnvelope
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer razor_edit_area_count - the number of razor-edit-areas in this envelope; -1, in case of an error
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, whose razor-edit-areas you want to count
  </parameters>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, count, envelope, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_CountAreas_Envelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return -1 end

  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\""..Guid.."\"" then
      count=count+1
    end
  end
  return count
end


--A=ultraschall.RazorEdit_CountAreas_Envelope(reaper.GetSelectedEnvelope(0))


function ultraschall.RazorEdit_CountAreas_Track(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_CountAreas_Track</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer razor_edit_area_count = ultraschall.RazorEdit_CountAreas_Track(MediaTrack track)</functioncall>
  <description>
    Counts razor-edit-areas of a track(excluding envelopes).
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer razor_edit_area_count - the number of razor-edit-areas in this track; -1, in case of an error
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edit-areas you want to count
  </parameters>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, count, track, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_CountAreas_Track", "track", "must be a valid MediaTrack", -1) return -1 end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\"\"" then
      count=count+1
    end
  end
  return count
end

--A=ultraschall.RazorEdit_CountAreas_Track(reaper.GetTrack(0,0))

function ultraschall.RazorEdit_Remove(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Remove</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Remove(MediaTrack track)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    removes all Razor Edits from a MediaTrack including its envelopes.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to remove(including its envelopes)
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveFromTrack
             removes the razor-edit areas of a track
      inline:RazorEdit_RemoveFromEnvelope
             removes the razor-edit areas of a specific TrackEnvelope
  </linked_to>
  <chapter_context>
    Razor Edit
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, track, envelopes</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Remove", "track", "must be a valid MediaTrack", -1) return false end
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", true)  
end


function ultraschall.RazorEdit_GetFromPoint(x,y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetFromPoint</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer razor_edit_index, number start_position, number end_position, MediaTrack track, optional TrackEnvelope envelope = ultraschall.RazorEdit_GetFromPoint(integer x, integer y)</functioncall>
  <description>
    gets a razor-edit area by coordinate in pixels
    
    returns -1 in case of an error with no additional return-values returned
  </description>
  <retvals>
    integer razor_edit_index - the index of the found razor-edit area; -1, if it's a gap within razor-edits
    number start_position - the start-position of the razor-edit-area/gap
    number end_position - the end-position of the razor-edit-area/gap
    MediaTrack track - the track, in which the razor-edit-area has been found
    optional TrackEnvelope envelope - the envelope, in which a razor-edit-area has been found; nil, if not in an envelope but rather in the track
  </retvals>
  <parameters>
    integer x - the x-position in pixels, at which to look for razor-edit-areas
    integer y - the y-position in pixels, at which to look for razor-edit-areas
  </parameters>  
  <chapter_context>
    Razor Edit
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, from point, track, razor edit area, envelope</tags>
</US_DocBloc>
]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("RazorEdit_GetFromPoint", "x", "must be an integer", -1) return -1 end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("RazorEdit_GetFromPoint", "y", "must be an integer", -2) return -1 end
  local track = reaper.GetTrackFromPoint(x,y)
  ultraschall.SuppressErrorMessages(true)
  local env=ultraschall.GetTrackEnvelopeFromPoint(x,y)
  ultraschall.SuppressErrorMessages(false)
  reaper.BR_GetMouseCursorContext()
  local pos=reaper.BR_GetMouseCursorContext_Position()
  local A, start, endpos, index
  if env~=nil then
    A, start, endpos, index=ultraschall.RazorEdit_IsAtPosition_Envelope(env, pos)
  else
    A, start, endpos, index=ultraschall.RazorEdit_IsAtPosition_Track(track, pos)
  end
  if A==true then
    return index, start, endpos, track, env
  else
    return -1, start, endpos, track, env
  end
end

function ultraschall.RazorEdit_RemoveByIndex_Track(track, razor_edit_area_index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_RemoveByIndex_Track</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_RemoveByIndex_Track(MediaTrack track, integer razor_edit_area_index)</functioncall>
  <description>
    removes razor-edit-areas from a track by its index(leaves all of its envelopes untouched)
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>
  <parameters>
    MediaTrack track - the track, from which you want to remove razor-edit-areas
    integer razor_edit_area_index - the index of the razor-edit-area that you want to remove
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveByIndex_Envelope
             removes razor-edit areas from a specific TrackEnvelope by index
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, track, by index</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_RemoveByIndex_Track", "track", "must be a MediaTrack", -1) return end
  if math.type(razor_edit_area_index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_RemoveByIndex_Track", "razor_edit_area_index", "must be an integer", -2) return end

  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  local newstring=""
  count=0
  for a, b, c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\"\"" then
      count=count+1
      if count~=razor_edit_area_index then
        newstring=newstring..a.." "..b.." "..c.." "
      end
    else
      newstring=newstring..a.." "..b.." "..c.." "
    end
  end
  reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end

function ultraschall.RazorEdit_RemoveByIndex_Envelope(envelope, razor_edit_area_index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_RemoveByIndex_Envelope</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string altered_razor_edit_string = ultraschall.RazorEdit_RemoveByIndex_Envelope(TrackEnvelope envelope, integer razor_edit_area_index)</functioncall>
  <description>
    removes razor-edit-areas from a track by its index(leaves all of its envelopes untouched)
    
    returns nil in case of an error
  </description>
  <retvals>
    string altered_razor_edit_string - the altered razor-edit-areas that are now stored in the track, as used by GetSetMediaTrackInfo_String
  </retvals>
  <parameters>
    TrackEnvelope envelope - the envelope, from which you want to remove razor-edit-areas
    integer razor_edit_area_index - the index of the razor-edit-area that you want to remove
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_RemoveByIndex_Track
             removes razor-edit areas from a specific track by index
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, remove, envelope, by index</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_RemoveByIndex_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return end
  if type(razor_edit_area_index)~="number" then ultraschall.AddErrorMessage("RazorEdit_RemoveByIndex_Envelope", "razor_edit_area_index", "must be a number", -2) return end

  local track=reaper.Envelope_GetParentTrack(envelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
    
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  local newstring=""
  count=0
  for a, b, c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    if c=="\""..Guid.."\"" then
      count=count+1
      if count~=razor_edit_area_index then
        newstring=newstring..a.." "..b.." "..c.." "
      end
    else
      newstring=newstring..a.." "..b.." "..c.." "
    end
  end
  reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  return B
end

function ultraschall.RazorEdit_IsAtPosition_Track(track, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_IsAtPosition_Track</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional number start_pos, optional number end_pos, optional integer razor_area_index = ultraschall.RazorEdit_IsAtPosition_Track(MediaTrack track, number position)</functioncall>
  <description>
    returns, if there's a razor-edit in a track at a given position or if there's a gap.
    
    It also returns the start/end-position of the razor-edit or razor-edit-gap.
    
    Gaps will be seen as either within two razor-edit-areas or from project-start to first razoredit or from last razor-edit to end of project.
    
    If the position is before 0, the function will only return false
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, there's a razor-edit at position; false, there's no razor-edit at position; nil, an error occurred
    optional number start_pos - the start of the razor-edit or razor-edit gap; nil if position is before 0 or after project-length
    optional number end_pos - the end of the razor-edit or razor-edit gap; nil if position is before 0 or after project-length
    optional integer razor_area_index - the index of the found razor-edit-area; 1-based; -1, if it's a gap
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edit-areas/gaps you want to check for
    number position - the position, at which to look for a razor-edit-area or a gap of it
  </parameters>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, is at position, gap, get, track, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_IsAtPosition_Track", "track", "must be a valid MediaTrack", -1) return end
  if type(position)~="number" then ultraschall.AddErrorMessage("RazorEdit_IsAtPosition_Track", "position", "must be a number", -2) return end
  if position<0 then return false end
  --if position>reaper.GetProjectLength(0) then return false end
  local retval, RazorEdits = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  local GUID=""
  local RazorEdits="0 0 \""..GUID.."\" "..RazorEdits.." "
  
  local found=false
  local tempstart=0
  local tempend=reaper.GetProjectLength(0)
  local count=-1

  for a,b,c in string.gmatch(RazorEdits, "(.-) (.-) (.-) ") do
    if c:sub(2,-2)==GUID then
      count=count+1
      if position>=tonumber(a) and position<=tonumber(b) then
        -- if within razor-edit-area, return this
        tempstart=tonumber(a)
        tempend=tonumber(b)
        found=true
        break
      end
      if tonumber(b)<=position and tonumber(b)>=tempstart then
        -- find razor-edit-area-gap-start
        tempstart=tonumber(b)
        found=false
      end
      if tonumber(a)>=position and tonumber(a)<=tempend then
        -- find razor-edit-area-gap-end
        tempend=tonumber(a)
        found=false
      end
    end
  end
  
  if found==false then count=-1 end

  return found, tempstart, tempend, count
end  

function ultraschall.RazorEdit_IsAtPosition_Envelope(envelope, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_IsAtPosition_Envelope</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional number start_pos, optional number end_pos, optional integer razor_area_index = ultraschall.RazorEdit_IsAtPosition_Envelope(TrackEnvelope envelope, number position)</functioncall>
  <description>
    returns, if there's a razor-edit in a TrackEnvelope at a given position or if there's a gap.
    
    It also returns the start/end-position of the razor-edit or razor-edit-gap.
    
    Gaps will be seen as either within two razor-edit-areas or from project-start to first razoredit or from last razor-edit to end of project.
    
    If the position is before 0, the function will only return false
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, there's a razor-edit at position; false, there's no razor-edit at position; nil, an error occurred
    optional number start_pos - the start of the razor-edit or razor-edit gap; nil if position is before 0
    optional number end_pos - the end of the razor-edit or razor-edit gap; nil if position is before 0
    optional integer razor_area_index - the index of the found razor-edit-area; 1-based; -1, if it's a gap
  </retvals>
  <parameters>
    TrackEnvelope envelope - the envelope, whose razor-edit-areas/gaps you want to check for
    number position - the position, at which to look for a razor-edit-area or a gap of it
  </parameters>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, is at position, gap, get, envelope, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_IsAtPosition_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return end
  if type(position)~="number" then ultraschall.AddErrorMessage("RazorEdit_IsAtPosition_Envelope", "position", "must be a number", -2) return end

  if position<0 then return false end
  local track=reaper.GetEnvelopeInfo_Value(envelope, "P_TRACK")
  local retval, RazorEdits = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)

  local retval, GUID = reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
  local RazorEdits="0 0 \""..GUID.."\" "..RazorEdits.." "
  local found=false
  local tempstart=0
  local tempend=reaper.GetProjectLength(0)
  local count=-1
  
  for a,b,c in string.gmatch(RazorEdits, "(.-) (.-) (.-) ") do
    if c:sub(2,-2)==GUID then
      count=count+1
      if position>=tonumber(a) and position<=tonumber(b) then
        -- if within razor-edit-area, return this
        tempstart=tonumber(a)
        tempend=tonumber(b)
        found=true
        break
      end
      if tonumber(b)<=position and tonumber(b)>=tempstart then
        -- find razor-edit-area-gap-start
        tempstart=tonumber(b)
        found=false
      end
      if tonumber(a)>=position and tonumber(a)<=tempend then
        -- find razor-edit-area-gap-end
        tempend=tonumber(a)
        found=false
      end
    end
  end

  if found==false then count=-1 end

  return found, tempstart, tempend, count
end


function ultraschall.RazorEdit_CheckForPossibleOverlap_Track(track, startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_CheckForPossibleOverlap_Track</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string position, number start_position, number end_position = ultraschall.RazorEdit_CheckForPossibleOverlap_Track(MediaTrack track, number startposition, number endposition)</functioncall>
  <description>
    Checks, whether an area overlaps with already existing razor-edit-areas of a MediaTrack.
    
    It returns the first razor-edit-area, that creates overlap. That means, if start-position overlaps with razor-edit-area #1 and endposition with razor-edit-area #4, it will only return razor-edit-area #1
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, there's an overlap; false, there's no overlap
    string position - "startposition", the startposition overlaps; "endposition", the endposition overlaps; "start/endposition", it overlaps with both
    number start_position - the startposition of the razor-edit-area, where it overlaps
    number end_position - the endposition of the razor-edit-area, where it overlaps
  </retvals>
  <parameters>
    MediaTrack track - the MediaTrack, where you want to check, if start-position and end-position overlap with any existing razor-edits
    number startposition - the start-position, to check, whether it overlaps
    number endposition - the end-position to check, whether it overlaps
  </parameters>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, check, overlap, startposition, endposition, track, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Track", "track", "must be a valid MediaTrack", -1) return end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Track", "startposition", "must be a number", -2) return end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Track", "endposition", "must be a number", -3) return end
  local found=false
  local A, B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  local pos
  for a,b,c in string.gmatch(B, "(.-) (.-) (.-) ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\"\"" then
      if startposition>=a and endposition<=b then
        found=true
        pos="start/endposition"
        startposition=a
        endposition=b
      elseif startposition>=a and startposition<=b then
        found=true
        pos="startposition"
        startposition=a
        endposition=b
        break
      elseif endposition>=a and endposition<=b then
        found=true
        pos="endposition"
        startposition=a
        endposition=b
        break
      end
    end
  end
  return found, pos, startposition, endposition
end

--AAA=ultraschall.RazorEdit_CheckForPossibleOverlap_Track(reaper.GetTrack(0,0), 67, 68)

function ultraschall.RazorEdit_CheckForPossibleOverlap_Envelope(envelope, startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_CheckForPossibleOverlap_Envelope</slug>
  <requires>
    Ultraschall=4.6
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string position, number start_position, number end_position = ultraschall.RazorEdit_CheckForPossibleOverlap_Envelope(TrackEnvelope envelope, number startposition, number endposition)</functioncall>
  <description>
    Checks, whether an area overlaps with already existing razor-edit-areas of an envelope
    
    It returns the first razor-edit-area, that creates overlap. That means, if start-position overlaps with razor-edit-area #1 and endposition with razor-edit-area #4, it will only return razor-edit-area #1
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, there's an overlap; false, there's no overlap
    string position - "startposition", the startposition overlaps; "endposition", the endposition overlaps; "start/endposition", it overlaps with both
    number start_position - the startposition of the razor-edit-area, where it overlaps
    number end_position - the endposition of the razor-edit-area, where it overlaps
  </retvals>
  <parameters>
    TrackEnvelope envelope - the TrackEnvelope, where you want to check, if start-position and end-position overlap with any existing razor-edits
    number startposition - the start-position, to check, whether it overlaps
    number endposition - the end-position to check, whether it overlaps
  </parameters>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, check, overlap, startposition, endposition, envelope, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Envelope", "startposition", "must be a number", -2) return end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_CheckForPossibleOverlap_Envelope", "endposition", "must be a number", -3) return end
  local found=false
  local track=reaper.GetEnvelopeInfo_Value(envelope, "P_TRACK")
  local retval, guid=reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
  local A, B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  B=B.." "
  for a,b,c in string.gmatch(B, "(.-) (.-) (.-) ") do
    a=tonumber(a)
    b=tonumber(b)
    --print2(a,b,c, guid)
    if c=="\""..guid.."\"" then
      if startposition>=a and endposition<=b then
        found=true
        pos="start/endposition"
        startposition=a
        endposition=b
      elseif startposition>=a and startposition<=b then
        found=true
        pos="startposition"
        startposition=a
        endposition=b
        break
      elseif endposition>=a and endposition<=b then
        found=true
        pos="endposition"
        startposition=a
        endposition=b
        break
      end
    end
  end
  return found,pos, startposition, endposition
end

function ultraschall.RazorEdit_Set_Track(track, index, startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Set_Track</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Set_Track(MediaTrack track, integer index, number startposition, number endposition)</functioncall>
  <description>
    Sets start and endposition of a razor-edit of a track, leaving the envelopes untouched.
    
    To set razor-edit-areas of a specific TrackEnvelope, use RazorEdit_Set_Envelope instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, in which the RazorEdit is located, that you wan to set
    integer index - the RazorEdit to set the new start/endposition of
    number startposition - the new startposition of the RazorEdit
    number endposition - the new endposition of the RazorEdit
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Set_Envelope
             sets a razor-edit area of a specific TrackEnvelope only
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, set, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Set_Track", "track", "must be a valid MediaTrack", -1) return false end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_Set_Track", "startposition", "must be a number", -2) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_Set_Track", "endposition", "must be a number", -3) return false end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Set_Track", "index", "must be an integer", -4) return false end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  local exclude_envelope=true
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\"\"" and exclude_track~=true then
      count=count+1
      if count==index then
        a=startposition
        b=endposition
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  
  return true
end

function ultraschall.RazorEdit_Set_Envelope(TrackEnvelope, index, startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Set_Envelope</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Set_Envelope(TrackEnvelope TrackEnvelope, integer index, number startpostion, number endposition)</functioncall>
  <description>
    Sets a razor-edit of a specific TrackEnvelope
    
    To set razor-edit-areas of a specific TrackEnvelope, use RazorEdit_Set_Track instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, in which you want to set an already existing razor-edit
    integer index - the razor-edit to set to a new start/endposition
    number startpostion - the new startposition of the razor-edit
    number endposition - the new endposition of the razor-edit
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Set_Track
             sets a razor-edit area of a specific Track only
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, set, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_Set_Envelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return false end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_Set_Envelope", "startposition", "must be a number", -2) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RazorEdit_Set_Envelope", "endposition", "must be a number", -3) return false end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Set_Envelope", "index", "must be an integer", -4) return false end
  
  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\""..Guid.."\"" then
      count=count+1
      if count==index then
        a=startposition
        b=endposition
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  return true
end


function ultraschall.RazorEdit_Resize_Track(track, length, edge, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Resize_Track</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Resize_Track(MediaTrack track, number length, integer edge, optional integer index)</functioncall>
  <description>
    Resizes razor-edits of a track, leaving the envelopes untouched.
    
    To resize razor-edit-areas of a specific TrackEnvelope, use RazorEdit_Resize_Envelope instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to resize
    number length - the length to resize the razor-edit-areas to
    integer edge - 1, cut at the front, 2, cut at the back
    optional integer index - allows to length only the n-th razor-edit-area in the track; nil, to length all in the track(except envelope)    
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Resize_Track
             resizes the razor-edit area of a specific TrackEnvelope only
      inline:RazorEdit_ResizeByFactor_Track
             resizes the razor-edit area of a specific TrackEnvelope by a factor
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, resize, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_Resize_Track", "track", "must be a valid MediaTrack", -1) return false end
  if type(length)~="number" then ultraschall.AddErrorMessage("RazorEdit_Resize_Track", "length", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Resize_Track", "index", "must be nil or an integer", -3) return false end
  if math.type(edge)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Resize_Track", "edge", "must be nil or an integer", -4) return false end
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  local exclude_envelope=true
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    
    a=tonumber(a)
    b=tonumber(b)
    if c=="\"\"" then
      count=count+1
      if index~=nil and count==index then
        if edge==2 then
          b=a+length
        elseif edge==1 then
          a=b-length
        end
      elseif index==nil then
        if edge==2 then
          b=a+length
        elseif edge==1 then
          a=b-length
        end
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  

  return true
end

function ultraschall.RazorEdit_Resize_Envelope(TrackEnvelope, length, edge, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_Resize_Envelope</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_Resize_Envelope(TrackEnvelope TrackEnvelope, number length, integer index, optional integer index)</functioncall>
  <description>
    Resizes razor-edits of a specific TrackEnvelope
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, whose razor-edit-areas you want to nudge
    number length - the new length of the razor-edit-areas
    integer edge - 1, cut at the front, 2, cut at the back
    optional integer index - allows to resize only the n-th razor-edit-area in the envelope; nil, to resize all in the envelope
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Resize_Track
             resizes the razor-edit areas of a specific Track only
      inline:RazorEdit_ResizeByFactor_Envelope
             resizes the razor-edit area of a specific TrackEnvelope by a factor
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, resize, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_Resize_Envelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return false end
  if type(length)~="number" then ultraschall.AddErrorMessage("RazorEdit_Resize_Envelope", "length", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Resize_Envelope", "index", "must be nil or an integer", -5) return false end
  if math.type(edge)~="integer" then ultraschall.AddErrorMessage("RazorEdit_Resize_Envelope", "edge", "must be nil or an integer", -4) return false end  
  
  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\""..Guid.."\"" then
      count=count+1
      if index~=nil and count==index then
        if edge==2 then
          b=a+length
        elseif edge==1 then
          a=b-length
        end
      elseif index==nil then
        if edge==2 then
          b=a+length
        elseif edge==1 then
          a=b-length
        end
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  return true
end

function ultraschall.RazorEdit_ResizeByFactor_Track(track, factor, edge, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_ResizeByFactor_Track</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_ResizeByFactor_Track(MediaTrack track, number length, integer edge, optional integer index)</functioncall>
  <description>
    Resizes razor-edits of a track by a factor, leaving the envelopes untouched.
    
    To resize razor-edit-areas of a specific TrackEnvelope, use RazorEdit_Resize_Envelope instead.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <parameters>
    MediaTrack track - the track, whose razor-edits you want to resize
    number factor - the factor to resize the razor-edit-areas to; 2=double the size, 0.5=half the size
    integer edge - 1, cut at the front, 2, cut at the back
    optional integer index - allows to length only the n-th razor-edit-area in the track; nil, to length all in the track(except envelope)
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Resize_Envelope
             resizes the razor-edit areas of a specific Track only
      inline:RazorEdit_ResizeByFactor_Envelope
             resizes the razor-edit areas of a specific Track only by a factor
  </linked_to>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, resize, track</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Track", "track", "must be a valid MediaTrack", -1) return false end
  if type(factor)~="number" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Track", "factor", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Track", "index", "must be nil or an integer", -3) return false end
  if math.type(edge)~="integer" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Track", "edge", "must be nil or an integer", -4) return false end  
  
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  local exclude_envelope=true
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    
    a=tonumber(a)
    b=tonumber(b)
    if c=="\"\"" then
      count=count+1
      if index~=nil and count==index then
        local length=b-a
        length=length*factor
        if edge==2 then
          b=a+length
        elseif edge==1 then          
          a=b-length
        end
      elseif index==nil then
        local length=b-a
        length=length*factor
        if edge==2 then
          b=a+length
        elseif edge==1 then          
          a=b-length
        end
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)  
  return true
end

function ultraschall.RazorEdit_ResizeByFactor_Envelope(TrackEnvelope, factor, edge, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_ResizeByFactor_Envelope</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_ResizeByFactor_Envelope(TrackEnvelope TrackEnvelope, number length, integer edge, optional integer index)</functioncall>
  <description>
    Resizes razor-edits of a specific TrackEnvelope by a factor
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <parameters>
    TrackEnvelope TrackEnvelope - the envelope, whose razor-edit-areas you want to nudge
    number factor - the factor by whicht to resize; 2=double the size, 0.5=half the size
    integer edge - 1, cut at the front, 2, cut at the back
    optional integer index - allows to resize only the n-th razor-edit-area in the envelope; nil, to resize all in the envelope
  </parameters>
  <linked_to desc="see:">
      inline:RazorEdit_Resize_Track
             resizes the razor-edit areas of a specific Track only
      inline:RazorEdit_ResizeByFactor_Track
             resizes the razor-edit areas of a specific Track only by a factor
  </linked_to>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, resize, envelope</tags>
</US_DocBloc>
]]
  if ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Envelope", "TrackEnvelope", "must be a valid TrackEnvelope", -1) return false end
  if type(factor)~="number" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Envelope", "factor", "must be a number", -2) return false end
  if index~=nil and math.type(index)~="integer" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Envelope", "index", "must be nil or an integer", -3) return false end
  if math.type(edge)~="integer" then ultraschall.AddErrorMessage("RazorEdit_ResizeByFactor_Track", "edge", "must be nil or an integer", -4) return false end  
  
  local track=reaper.Envelope_GetParentTrack(TrackEnvelope)
  local retval, Guid = reaper.GetSetEnvelopeInfo_String(TrackEnvelope, "GUID", "", false)
  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)  
  local B=B.." "
  local newstring=""
  local count=0
  for a,b,c in string.gmatch(B, "(.-) (.-) (\".-\") ") do
    a=tonumber(a)
    b=tonumber(b)
    if c=="\""..Guid.."\"" then
      count=count+1
      if index~=nil and count==index then
        local length=b-a
        length=length*factor
        if edge==2 then
          b=a+length
        elseif edge==1 then          
          a=b-length
        end
      elseif index==nil then
        local length=b-a
        length=length*factor
        if edge==2 then
          b=a+length
        elseif edge==1 then          
          a=b-length
        end
      end
    end
    newstring=newstring..a.." "..b.." "..c.." "
  end

  local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", newstring, true)
  return true
end

function ultraschall.RazorEdit_GetBetween_Envelope(envelope, start_position, end_position, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetBetween_Envelope</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer found_razor_edits, table razor_edit_index = ultraschall.RazorEdit_GetBetween_Envelope(TrackEnvelope envelope, number start_position, number end_position, boolean inside)</functioncall>
  <description>
    returns the razor-edits between start and endposition within an envelope
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_razor_edits - the number of found razor edit-areas
    table razor_edit_index - the found razor edit-areas
  </retvals>
  <parameters>
    TrackEnvelope envelope - the envelope, from which to retrieve the razor-edit-areas
    number start_position - the startposition in seconds
    number end_position - the endposition in seconds
    boolean inside - true, only razor edits that start and end within start/endposition; false, include partial razor-edits
  </parameters>
  <chapter_context>
    Razor Edit
    Envelopes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, between, envelope, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(envelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Envelope", "envelope", "must be a valid TrackEnvelope", -1) return -1 end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Envelope", "start_position", "must be a number", -2) return -1 end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Envelope", "end_position", "must be a number", -3) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Envelope", "inside", "must be a boolean", -4) return -1 end

  local track=reaper.GetEnvelopeInfo_Value(envelope, "P_TRACK")
  local retval, RazorEdits = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)

  local retval, GUID = reaper.GetSetEnvelopeInfo_String(envelope, "GUID", "", false)
  local RazorEdits="0 0 \""..GUID.."\" "..RazorEdits.." "
  local found=false
  local tempstart=0
  local tempend=reaper.GetProjectLength(0)
  local count=-1
  local found_razors={}
  
  for a,b,c in string.gmatch(RazorEdits, "(.-) (.-) (.-) ") do
    if c:sub(2,-2)==GUID then
      count=count+1
      a=tonumber(a)
      b=tonumber(b)
      if count>0 then
        if inside==true then
          if a>=start_position and b<=end_position then
            found_razors[#found_razors+1]=count
          end
        elseif inside==false then
          if (a>=start_position and a<=end_position) or (b<=end_position and b>=start_position) then
            found_razors[#found_razors+1]=count
          end
        end
      end
    end
  end

  return #found_razors, found_razors
end

function ultraschall.RazorEdit_GetBetween_Track(track, start_position, end_position, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetBetween_Track</slug>
  <requires>
    Ultraschall=4.9
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer found_razor_edits, table razor_edit_index = ultraschall.RazorEdit_GetBetween_Track(MediaTrack track, number start_position, number end_position, boolean inside)</functioncall>
  <description>
    returns the number of razor-edits between start- and end-position within a track.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_razor_edits - the number of found razor edit-areas
    table razor_edit_index - the found razor edit-areas
  </retvals>
  <parameters>
    MediaTrack track - the track, from which you want to get the razor-edits
    number start_position - the startposition in seconds
    number end_position - the endposition in seconds
    boolean inside - true, only razor edits that start and end within start/endposition; false, include partial razor-edits
  </parameters>
  <chapter_context>
    Razor Edit
    Tracks
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, between, track, razor edit areas</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Track", "track", "must be a valid MediaTrack", -1) return end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Track", "start_position", "must be a number", -2) return -1 end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Track", "end_position", "must be a number", -3) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("RazorEdit_GetBetween_Track", "inside", "must be a boolean", -4) return -1 end

  --if position>reaper.GetProjectLength(0) then return false end
  local retval, RazorEdits = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
  local GUID=""
  local RazorEdits="0 0 \""..GUID.."\" "..RazorEdits.." "
  
  local found=false
  local tempstart=0
  local tempend=reaper.GetProjectLength(0)
  local count=-1
  local found_razors={}

  for a,b,c in string.gmatch(RazorEdits, "(.-) (.-) (.-) ") do
    if c:sub(2,-2)==GUID then
      count=count+1
      a=tonumber(a)
      b=tonumber(b)
      if count>0 then
        if inside==true then
          if a>=start_position and b<=end_position then
            found_razors[#found_razors+1]=count
          end
        elseif inside==false then
          if (a>=start_position and a<=end_position) or (b<=end_position and b>=start_position) then
            found_razors[#found_razors+1]=count
          end
        end
      end
    end
  end

  return #found_razors, found_razors
end  