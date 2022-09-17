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
---    Track Management Module    ---
-------------------------------------

function ultraschall.IsValidTrackString(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidTrackString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean valid, integer count, array individual_tracknumbers = ultraschall.IsValidTrackString(string trackstring)</functioncall>
  <description>
    checks, whether a given trackstring is a valid one. Will also return all valid numbers, from trackstring, that can be used as tracknumbers, as an array.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean valid - true, is a valid trackstring; false, is not a valid trackstring
    integer count - the number of entries found in trackstring
    array individual_tracknumbers - an array that contains all available tracknumbers
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
  <tags>trackmanagement, trackstring, check, valid</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(trackstring)~="string" then ultraschall.AddErrorMessage("IsValidTrackString","trackstring", "Must be a string!", -1) return false end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local found=true
  if individual_values==nil then ultraschall.AddErrorMessage("IsValidTrackString","trackstring", "Has no tracknumbers in it!", -1) return false end

  -- check the individual trackstring-entries and throw out all invalid-entries
  for i=count, 1, -1 do
    individual_values[i]=tonumber(individual_values[i])
    if individual_values[i]==nil then table.remove(individual_values,i) count=count-1 found=false end
  end
  
  -- sort it and return it
  table.sort(individual_values) 
  return found, count, individual_values
end


function ultraschall.IsValidTrackStateChunk(statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidTrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean valid = ultraschall.IsValidTrackStateChunk(string TrackStateChunk)</functioncall>
  <description>
    returns, if a TrackStateChunk is a valid statechunk
    
    returns false in case of an error
  </description>
  <parameters>
    string TrackStateChunk - a string to check, if it's a valid TrackStateChunk
  </parameters>
  <retvals>
    boolean valid - true, if the string is a valid statechunk; false, if not a valid statechunk
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, check, validity, track, statechunk, valid</tags>
</US_DocBloc>
--]]
  if type(statechunk)~="string" then ultraschall.AddErrorMessage("IsValidTrackStateChunk","statechunk", "must be a string", -1) return false end
  if statechunk:match("<TRACK.*>\n$")~=nil then return true end
  return false
end

function ultraschall.CreateTrackString(firstnumber, lastnumber, step)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackString(integer firstnumber, integer lastnumber, optional integer step)</functioncall>
  <description>
    returns a string with the all numbers from firstnumber to lastnumber, separated by a ,
    e.g. firstnumber=4, lastnumber=8 -> 4,5,6,7,8
    
    returns nil in case of an error
  </description>
  <parameters>
    integer firstnumber - the number, with which the string starts
    integer lastnumber - the number, with which the string ends
    integer step - how many numbers shall be skipped inbetween. Can lead to a different lastnumber, when step is not 1! nil or invalid value=1
  </parameters>
  <retvals>
    string trackstring - a string with all tracknumbers, separated by a ,
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackstring, track, create</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(firstnumber)~="integer" then ultraschall.AddErrorMessage("CreateTrackString","firstnumber", "only integer allowed", -1) return nil end
  if math.type(lastnumber)~="integer" then ultraschall.AddErrorMessage("CreateTrackString","lastnumber", "only integer allowed", -2) return nil end
  if tonumber(step)==nil then step=1 end
    
  -- prepare variables
  firstnumber=tonumber(firstnumber)
  lastnumber=tonumber(lastnumber)
  step=tonumber(step)
  local trackstring=""
  
  -- create trackstring
  for i=firstnumber, lastnumber, step do
    trackstring=trackstring..","..tostring(i)
  end
  return trackstring:sub(2,-1)
end

function ultraschall.CreateTrackString_SelectedTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackString_SelectedTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackString_SelectedTracks()</functioncall>
  <description>
    Creates a string with all numbers from selected tracks, separated by a ,
    
    Returns an empty string, if no tracks are selected.
  </description>
  <retvals>
    string trackstring - a string with the tracknumbers, separated by a string
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, datastructure</tags>
</US_DocBloc>
]]
  -- prepare variable
  local trackstring=""
  
  -- get the selected tracks and add their tracknumber to trackstring
  for i=1, reaper.CountTracks(0) do
    local MediaTrack=reaper.GetTrack(0,i-1)
    if reaper.IsTrackSelected(MediaTrack)==true then
      trackstring=trackstring..i..","
    end  
  end
  
  -- return trackstring
  return trackstring:sub(1,-2)
end

function ultraschall.InsertTrack_TrackStateChunk(trackstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertTrack_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, MediaTrack MediaTrack = ultraschall.InsertTrack_TrackStateChunk(string trackstatechunk)</functioncall>
  <description>
    Creates a new track at the end of the project and sets it's trackstate, using the parameter trackstatechunk.
    Returns true, if it succeeded and the newly created MediaTrack.
  </description>
  <parameters>
    string trackstatechunk - the rpp-xml-Trackstate-Chunk, as created by reaper.GetTrackStateChunk or <a href="#GetProject_TrackStateChunk">GetProject_TrackStateChunk</a>
  </parameters>
  <retvals>
    boolean retval - true, if creation succeeded, false if not
    MediaTrack MediaTrack - the newly created track, as MediaItem-trackobject
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackstring, track, create, trackstate, trackstatechunk, chunk, state</tags>
</US_DocBloc>
]]--
  if ultraschall.IsValidTrackStateChunk(trackstatechunk)==false then ultraschall.AddErrorMessage("InsertTrack_TrackStateChunk", "trackstatechunk", "Must be a valid TrackStateChunk", -1) return false end  
  reaper.InsertTrackAtIndex(reaper.CountTracks(0), true)
  local MediaTrack=reaper.GetTrack(0,reaper.CountTracks(0)-1)
  if MediaTrack==nil then ultraschall.AddErrorMessage("InsertTrack_TrackStateChunk", "", "Couldn't create new track.", -2) return false end
  local bool=reaper.SetTrackStateChunk(MediaTrack, trackstatechunk, true)
  if bool==false then reaper.DeleteTrack(MediaTrack) ultraschall.AddErrorMessage("InsertTrack_TrackStateChunk", "trackstatechunk", "Couldn't set TrackStateChunk", -3) return false end
  return true, MediaTrack
end

function ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveDuplicateTracksInTrackstring</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, string trackstring, array trackstringarray, integer number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(string trackstring)</functioncall>
  <description>
    Sorts tracknumbers in trackstring and throws out duplicates. It also throws out entries, that are no numbers.
    Returns the "cleared" trackstring as string and as array, as well as the number of entries. 
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    string trackstring - the cleared trackstring, -1 in case of error
    array trackstringarray - the "cleared" trackstring as an array
    integer number_of_entries - the number of entries in the trackstring
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, trackstring, sort, order</tags>
</US_DocBloc>
]]
    if type(trackstring)~="string" then ultraschall.AddErrorMessage("RemoveDuplicateTracksInTrackstring","trackstring", "must be a string", -1) return -1 end
    local _count, Trackstring_array=ultraschall.CSV2IndividualLinesAsArray(trackstring)    
    if Trackstring_array==nil then ultraschall.AddErrorMessage("RemoveDuplicateTracksInTrackstring","trackstring", "not a valid trackstring", -3) return -1 end
    table.sort(Trackstring_array)
    local count=2
    while Trackstring_array[count]~=nil do
      if Trackstring_array[count]==Trackstring_array[count-1] then table.remove(Trackstring_array,count) count=count-1 
      elseif tonumber(Trackstring_array[count])==nil then table.remove(Trackstring_array,count) count=count-1
      end
      count=count+1
    end
    count=1
    if tonumber(Trackstring_array[1])==nil then table.remove(Trackstring_array,1) end
    trackstring=""
    while Trackstring_array[count]~=nil do
      trackstring=trackstring..Trackstring_array[count]..","
      Trackstring_array[count]=tonumber(Trackstring_array[count])
      count=count+1
    end
    return 1, trackstring:sub(1,-2), Trackstring_array, count-1
end

function ultraschall.IsTrackObjectTracknumber(MediaTrack, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTrackObjectTracknumber</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer tracknumber = ultraschall.IsTrackObjectTracknumber(MediaTrack track, integer tracknumber)</functioncall>
  <description>
    returns true, if MediaTrack has the tracknumber "tracknumber"; false if not.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaTrack track - the MediaTrack of which you want to check it's number
    integer tracknumber - the tracknumber you want to check for
  </parameters>
  <retvals>
    boolean retval - true if track is tracknumber, false if not
    integer tracknumber - the number of track, so in case of false, you know it's number
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, check, tracknumber, mediatrack, object</tags>
</US_DocBloc>
]]
--returns true, if MediaTrack=tracknumber, false if not; as well as the tracknumber of MediaTrack
--returns nil in case of error
    tracknumber=tonumber(tracknumber)
    if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackObjectTracknumber","tracknumber", "must be an integer", -1) return nil end

    if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackObjectTracknumber","tracknumber", "no such track", -2) return nil end
    if reaper.ValidatePtr(MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("IsTrackObjectTracknumber","track", "no valid MediaTrack-object", -3) return nil end
    local number=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
    if number==tracknumber then return true, number
    else return false, number
    end
end

--A=ultraschall.IsTrackObjectTracknumber(reaper.GetTrack(0,0),1)

function ultraschall.InverseTrackstring(trackstring, limit)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InverseTrackstring</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string inv_trackstring = ultraschall.InverseTrackstring(string trackstring, integer limit)</functioncall>
  <description>
    returns a newtrackstring with numbers, that are NOT in trackstring, in the range between 0 and limit
    
    returns -1 in case of error
  </description>
  <parameters>
    string trackstring - the tracknumbers, separated with a ,
    integer limit - the maximum tracknumber to include. Use reaper.CountTracks(0) function to use the maximum tracks in current project
  </parameters>
  <retvals>
    string inv_trackstring - the tracknumbers, that are NOT in the parameter trackstring, from 0 to limit
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, trackstring, inverse, tracknumber, tracknumbers, limit</tags>
</US_DocBloc>
]]
--returns a newtrackstring with numbers, that are NOT in trackstring, from 0 to limit
  local retval, trackstring, trackstringarray, number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(trackstring) 
  if math.type(limit)~="integer" then ultraschall.AddErrorMessage("InverseTrackstring","limit", "must be an integer", -1) return -1 end
  limit=tonumber(limit)
  local newtrackstring=""
  local dingo
  if retval==-1 then ultraschall.AddErrorMessage("InverseTrackstring","trackstring", "not a valid trackstring", -2) return -1 end
  for i=1,limit do
    dingo=true
    for a=0,number_of_entries do
      if trackstringarray[a]==i then dingo=false break end
    end
    if dingo==true then newtrackstring=newtrackstring..i.."," end
  end
  return newtrackstring:sub(1,-2)
end


function ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountItemsInTrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer countitems = ultraschall.CountItemsInTrackStateChunk(string trackstatechunk)</functioncall>
  <description>
    returns the number of items in a trackstatechunk
    
    returns -1 in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
  </parameters>
  <retvals>
    integer countitems - number of items in the trackstatechunk
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, get</tags>
</US_DocBloc>
]]

  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("CountItemsInTrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -1) return -1 end
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("CountItemsInTrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -2) return -1 end
  local count=0

  while trackstatechunk:match("<ITEM")~=nil do
    count=count+1
    trackstatechunk=trackstatechunk:match("<ITEM.-(<ITEM.*)")
    if trackstatechunk==nil then break end 
  end
  return count
end


function ultraschall.GetItemStateChunkFromTrackStateChunk(trackstatechunk, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemStateChunkFromTrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string mediaitemstatechunk = ultraschall.GetItemStateChunkFromTrackStateChunk(string trackstatechunk, integer idx)</functioncall>
  <description>
    Returns a mediaitemstatechunk of the idx'th item in trackstatechunk.
    
    returns false in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    integer idx - the number of the item you want to have returned as mediaitemstatechunk
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
    string mediaitemstatechunk - number of items in the trackstatechunk
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, get</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("GetItemStateChunkFromTrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -1) return false end
  local nums=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  if nums==-1 then ultraschall.AddErrorMessage("GetItemStateChunkFromTrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -2) return false end
  if nums<idx then ultraschall.AddErrorMessage("GetItemStateChunkFromTrackStateChunk", "idx", "only "..nums.." items in trackstatechunk", -3) return false end
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("GetItemStateChunkFromTrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -4) return false end
  local count=0
  local temptrackstatechunk=""
  while trackstatechunk:match("<ITEM")~=nil do
    count=count+1
    if count==idx then
      temptrackstatechunk=trackstatechunk:match("(<ITEM.-)<ITEM")
      if temptrackstatechunk==nil then temptrackstatechunk=trackstatechunk:match("(<ITEM.*)") end
    end
    
    trackstatechunk=trackstatechunk:match("<ITEM.-(<ITEM.*)")
    if trackstatechunk==nil then break end 
  end
  return true, temptrackstatechunk  
end




function ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(trackstatechunk, mediaitemstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddMediaItemStateChunk_To_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackstatechunk = ultraschall.AddMediaItemStateChunk_To_TrackStateChunk(string trackstatechunk, string mediaitemstatechunk)</functioncall>
  <description>
    Adds the item mediaitemstatechunk into trackstatechunk and returns this altered trackstatechunk.
    
    returns nil in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    string mediaitemstatechunk - a mediaitemstatechunk, as returned by reaper's api function reaper.GetItemStateChunk
  </parameters>
  <retvals>
    string trackstatechunk - the new trackstatechunk with mediaitemstatechunk added
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, add</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("AddMediaItemStateChunk_To_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed, not "..type(trackstatechunk), -1) return nil end
  if type(mediaitemstatechunk)~="string" then ultraschall.AddErrorMessage("AddMediaItemStateChunk_To_TrackStateChunk", "mediaitemstatechunk", "only mediaitemstatechunk is allowed, not "..type(mediaitemstatechunk), -2) return nil end
  if trackstatechunk:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("AddMediaItemStateChunk_To_TrackStateChunk", "trackstatechunk", "not a valid trackstatechunk", -3) return nil end
  if mediaitemstatechunk:match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("AddMediaItemStateChunk_To_TrackStateChunk", "mediaitemstatechunk", "not a valid mediaitemstatechunk", -4) return nil end
  return trackstatechunk:match("(.*)>")..mediaitemstatechunk..">"
end



function ultraschall.RemoveMediaItem_TrackStateChunk(trackstatechunk, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveMediaItem_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string trackstatechunk = ultraschall.RemoveMediaItem_TrackStateChunk(string trackstatechunk, integer idx)</functioncall>
  <description>
    Deletes the idx'th item from trackstatechunk and returns this altered trackstatechunk.
    
    returns false in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    integer idx - the number of the item you want to delete
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
    string trackstatechunk - the new trackstatechunk with the idx'th item deleted
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, delete</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("RemoveMediaItem_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -1) return false end
  local nums=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  if nums==-1 then ultraschall.AddErrorMessage("RemoveMediaItem_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -2) return false end
  if nums<idx then ultraschall.AddErrorMessage("RemoveMediaItem_TrackStateChunk", "idx", "only "..nums.." items in trackstatechunk", -3) return false end
  if idx<1 then ultraschall.AddErrorMessage("RemoveMediaItem_TrackStateChunk", "idx", "only positive values allowed, beginning with 1", -4) return false end
  local begin=trackstatechunk:match("(.-)<ITEM.*")
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("RemoveMediaItem_TrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -5) return false end
  local count=0
  local temptrackstatechunk=""
  while trackstatechunk:match("<ITEM")~=nil do
    count=count+1
    if count~=idx then
      local temptrackstatechunk2=trackstatechunk:match("(<ITEM.-)<ITEM")
      if temptrackstatechunk2==nil then temptrackstatechunk2=trackstatechunk:match("(<ITEM.*)") end
      temptrackstatechunk=temptrackstatechunk..temptrackstatechunk2
    end
    trackstatechunk=trackstatechunk:match("<ITEM.-(<ITEM.*)")
    if trackstatechunk==nil then break end 
  end
  return true, begin..temptrackstatechunk
end


function ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(trackstatechunk, IGUID)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveMediaItemByIGUID_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string trackstatechunk = ultraschall.RemoveMediaItemByIGUID_TrackStateChunk(string trackstatechunk, string IGUID)</functioncall>
  <description>
    Deletes the item with the iguid IGUID from trackstatechunk and returns this altered trackstatechunk.
    
    returns false in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    string IGUID - the IGUID of the item you want to delete
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
    string trackstatechunk - the new trackstatechunk with the IGUID-item deleted
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, delete, iguid</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("RemoveMediaItemByIGUID_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -1) return false end
  if trackstatechunk:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("RemoveMediaItemByIGUID_TrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -2) return false end
  local nums=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  local begin=trackstatechunk:match("(.-)<ITEM.*")
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("RemoveMediaItemByIGUID_TrackStateChunk", "trackstatechunk", "no items in trackstatechunk", -3) return false end
  local count=0
  local temptrackstatechunk=""
  local dada
  for i=1,nums do
    local L,M=ultraschall.GetItemStateChunkFromTrackStateChunk(trackstatechunk, i)
    if ultraschall.GetItemIGUID(M)~=IGUID then temptrackstatechunk=temptrackstatechunk..M end
  end
  local lt=ultraschall.CountCharacterInString(begin..temptrackstatechunk,"<")
  local gt=ultraschall.CountCharacterInString(begin..temptrackstatechunk,">")
  if gt<lt then dada=">\n" else dada="" end
  return true, begin..temptrackstatechunk..dada
end

function ultraschall.RemoveMediaItemByGUID_TrackStateChunk(trackstatechunk, GUID)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveMediaItemByGUID_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string trackstatechunk = ultraschall.RemoveMediaItemByGUID_TrackStateChunk(string trackstatechunk, string GUID)</functioncall>
  <description>
    Deletes the item with the guid GUID from trackstatechunk and returns this altered trackstatechunk.
    
    returns false in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    string GUID - the GUID of the item you want to delete
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
    string trackstatechunk - the new trackstatechunk with the GUID-item deleted
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, media, item, statechunk, chunk, delete, guid</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("RemoveMediaItemByGUID_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -1) return false end
  if trackstatechunk:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("RemoveMediaItemByGUID_TrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -2) return false end
  local nums=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  local begin=trackstatechunk:match("(.-)<ITEM.*")
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("RemoveMediaItemByGUID_TrackStateChunk", "trackstatechunk", "no items in trackstatechunk", -3) return false end
  local count=0
  local temptrackstatechunk=""
  local dada
  for i=1,nums do
    local L,M=ultraschall.GetItemStateChunkFromTrackStateChunk(trackstatechunk, i)
    if ultraschall.GetItemGUID(M)~=GUID then temptrackstatechunk=temptrackstatechunk..M 
    else 
    end
  end
  local lt=ultraschall.CountCharacterInString(begin..temptrackstatechunk,"<")
  local gt=ultraschall.CountCharacterInString(begin..temptrackstatechunk,">")
  if gt<lt then dada=">\n" else dada="" end
  return true, begin..temptrackstatechunk..dada
end

function ultraschall.OnlyTracksInBothTrackstrings(trackstring1, trackstring2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyTracksInBothTrackstrings</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, string trackstring, array trackstringarray, integer number_of_entries = ultraschall.OnlyTracksInBothTrackstrings(string trackstring1, string trackstring2)</functioncall>
  <description>
    returns a new trackstring, that contains only the tracknumbers, that are in trackstring1 and trackstring2.
    
    returns -1 in case of error
  </description>
  <parameters>
    string trackstring1 - a string with the tracknumbers, separated by commas
    string trackstring2 - a string with the tracknumbers, separated by commas
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    string trackstring - the cleared trackstring, -1 in case of error
    array trackstringarray - the "cleared" trackstring as an array
    integer number_of_entries - the number of entries in the trackstring
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, trackstring, sort, order</tags>
</US_DocBloc>
]]
  if type(trackstring1)~="string" then ultraschall.AddErrorMessage("OnlyTracksInBothTrackstrings", "trackstring1", "not a valid trackstring", -1) return -1 end
  if type(trackstring2)~="string" then ultraschall.AddErrorMessage("OnlyTracksInBothTrackstrings", "trackstring2", "not a valid trackstring", -2)return -1 end
  local A,A2,A3,A4=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring1)
  local B,B2,B3,B4=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring2)
  local newtrackstring=""
  for i=1, A4 do
    for a=1, B4 do
      if A3[i]==B3[a] then newtrackstring=newtrackstring..A3[i].."," end
    end
  end
  return ultraschall.RemoveDuplicateTracksInTrackstring(newtrackstring)
end

function ultraschall.OnlyTracksInOneTrackstring(trackstring1, trackstring2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyTracksInOneTrackstring</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, string trackstring, array trackstringarray, integer number_of_entries = ultraschall.OnlyTracksInOneTrackstring(string trackstring1, string trackstring2)</functioncall>
  <description>
    returns a new trackstring, that contains only the tracknumbers, that are in either trackstring1 or trackstring2, NOT in both!
    
    returns -1 in case of error
  </description>
  <parameters>
    string trackstring1 - a string with the tracknumbers, separated by commas
    string trackstring2 - a string with the tracknumbers, separated by commas
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    string trackstring - the cleared trackstring, -1 in case of error
    array trackstringarray - the "cleared" trackstring as an array
    integer number_of_entries - the number of entries in the trackstring
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, trackstring, sort, order</tags>
</US_DocBloc>
]]
  if type(trackstring1)~="string" then ultraschall.AddErrorMessage("OnlyTracksInOneTrackstring", "trackstring1", "not a valid trackstring", -1) return -1 end
  if type(trackstring2)~="string" then ultraschall.AddErrorMessage("OnlyTracksInOneTrackstring", "trackstring2", "not a valid trackstring", -2) return -1 end
  local A,A2,A3,A4=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring1)
  local B,B2,B3,B4=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring2)
  local newtrackstring=""
  local count=0
  for i=A4, 1, -1 do
    for a=B4, 1, -1 do
      if A3[i]==B3[a] then table.remove(A3,i) table.remove(B3,a) count=count+1 end
    end
  end

  for i=1,A4-count do
      newtrackstring=newtrackstring..A3[i]..","
  end

  for i=1,B4-count do
      newtrackstring=newtrackstring..B3[i]..","
  end
    
  return ultraschall.RemoveDuplicateTracksInTrackstring(newtrackstring)
end


function ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(trackstatechunk, idx, mediaitemstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetMediaItemStateChunk_in_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string trackstatechunk = ultraschall.SetMediaItemStateChunk_in_TrackStateChunk(string trackstatechunk, integer idx, string mediaitemstatechunk)</functioncall>
  <description>
    Overwrites the idx'th item from trackstatechunk with mediaitemstatechunk and returns this altered trackstatechunk.
    
    returns false in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by reaper's api function reaper.GetTrackStateChunk
    integer idx - the number of the item you want to delete
    string mediaitemstatechunk - a mediaitemstatechunk, as returned by reaper's api function reaper.GetItemStateChunk
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
    string trackstatechunk - the new trackstatechunk with the idx'th item replaced
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, chunk, set</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed, not "..type(trackstatechunk), -1) return false end
  if type(mediaitemstatechunk)~="string" then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "mediaitemstatechunk", "only mediaitemstatechunk is allowed, not "..type(mediaitemstatechunk), -2) return false end
  local nums=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  if nums==-1 then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "trackstatechunk", "only trackstatechunk is allowed", -3) return false end
  if nums<idx then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "idx", "only "..nums.." items in trackstatechunk", -4) return false end
  if idx<1 then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "idx", "only positive values allowed, beginning with 1", -5) return false end
  if mediaitemstatechunk:match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "mediaitemstatechunk", "not a valid mediaitemstatechunk", -6) return false end
  local begin=trackstatechunk:match("(.-)<ITEM.*")
  trackstatechunk=trackstatechunk:match("<ITEM.*")
  if trackstatechunk==nil then ultraschall.AddErrorMessage("SetMediaItemStateChunk_in_TrackStateChunk", "trackstatechunk", "no valid trackstatechunk", -7) return false end
  local count=0
  local add
  local temptrackstatechunk=""
  while trackstatechunk:match("<ITEM")~=nil do
    count=count+1
    if count~=idx then
      local temptrackstatechunk2=trackstatechunk:match("(<ITEM.-)<ITEM")
      if temptrackstatechunk2==nil then temptrackstatechunk2=trackstatechunk:match("(<ITEM.*)") end
      temptrackstatechunk=temptrackstatechunk..temptrackstatechunk2
    else
      temptrackstatechunk=temptrackstatechunk..mediaitemstatechunk
    end
    trackstatechunk=trackstatechunk:match("<ITEM.-(<ITEM.*)")
    if trackstatechunk==nil then break end 
  end
  if idx==nums then add=">" 
  else add=""
  end
  return true, begin..temptrackstatechunk..add
end

function ultraschall.GetAllMediaItemsFromTrackStateChunk(trackstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemsFromTrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray = ultraschall.GetAllMediaItemsFromTrackStateChunk(string trackstatechunk)</functioncall>
  <description>
    Returns a MediaItemStateChunkArray with all items in trackstatechunk.
    
    returns -1 in case of error
  </description>
  <parameters>
    string trackstatechunk - a trackstatechunk, as returned by functions like reaper.GetTrackStateChunk
  </parameters>
  <retvals>
    integer count - number of MediaItemStateChunks in the returned array. -1 in case of error
    array MediaItemStateChunkArray - an array with all MediaItemStateChunks from trackstatechunk
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, get, trackstatechunk, mediaitemstatechunk, mediaitemstatechunkarray</tags>
</US_DocBloc>
]]
  if type(trackstatechunk)~="string" or trackstatechunk:match("<TRACK.*>")==nil then ultraschall.AddErrorMessage("GetAllMediaItemsFromTrackStateChunk", "trackstatechunk", "not a valid trackstatechunk", -1) return -1 end
  local A=trackstatechunk:match("<ITEM.*>")
  if A==nil then ultraschall.AddErrorMessage("GetAllMediaItemsFromTrackStateChunk", "trackstatechunk", "no MediaItems in trackstatechunk", -2) return -1 end
  local MediaItemStateChunkArray={}
  local retval
  local count=ultraschall.CountItemsInTrackStateChunk(trackstatechunk)
  for i=1, count do
    retval, MediaItemStateChunkArray[i] = ultraschall.GetItemStateChunkFromTrackStateChunk(trackstatechunk, i) 
  end
  return count, MediaItemStateChunkArray
end

function ultraschall.CreateTrackString_AllTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackString_AllTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackString_AllTracks()</functioncall>
  <description>
    Returns a trackstring with all tracknumbers from the current project.
    
    Returns an empty string, if no track is available.
  </description>
  <retvals>
    string trackstring - a string with all tracknumbers, separated by commas.
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, tracks, trackstring</tags>
</US_DocBloc>
]]

  local trackstring=""
  for i=1, reaper.CountTracks(0) do
    trackstring=trackstring..i..","
  end
  return trackstring:sub(1,-2)
end

function ultraschall.GetTrackLength(Tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length = ultraschall.GetTrackLength(integer Tracknumber)</functioncall>
  <description>
    Returns the length of a track, that means, the end of the last item in track Tracknumber.
    Will return -1, in case of error
  </description>
  <parameters>
    integer Tracknumber - the tracknumber, whose length you want to know
  </parameters>
  <retvals>
    integer length - the length of the track in seconds
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement,count,length,items,end</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("GetTrackLength", "Tracknumber", "must be an integer", -1) return -1 end

  local MediaTrack, MediaItem, num_items, Itemcount, MediaItemArray, POS, LEN
  if Tracknumber<0 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetTrackLength", "Tracknumber", "no such track", -2) return -1 end
  if Tracknumber==0 then 
    MediaTrack=reaper.GetMasterTrack(0)
  else
    MediaTrack=reaper.GetTrack(0,Tracknumber-1)
  end
  num_items=reaper.CountTrackMediaItems(MediaTrack)
  MediaItem, Itemcount, MediaItemArray = ultraschall.EnumerateMediaItemsInTrack(Tracknumber, num_items)
  if MediaItem==-1 then ultraschall.AddErrorMessage("GetTrackLength", "Tracknumber", "no items in this track", -3) return -1 end
  POS=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
  LEN=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
  return POS+LEN
end

--A=ultraschall.GetTrackLength(2)
function ultraschall.GetLengthOfAllMediaItems_Track(Tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLengthOfAllMediaItems_Track</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length = ultraschall.GetLengthOfAllMediaItems_Track(integer Tracknumber)</functioncall>
  <description>
    Returns the length of all MediaItems in track, combined.
    Will return -1, in case of error
  </description>
  <parameters>
    integer Tracknumber - the tracknumber, whose length you want to know; 1, track 1; 2, track 2, etc
  </parameters>
  <retvals>
    integer length - the length of all MediaItems in the track combined, in seconds
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, count, length, all items, track, end</tags>
</US_DocBloc>
]]
  if math.type(Tracknumber)~="integer" then ultraschall.AddErrorMessage("GetLengthOfAllMediaItems_Track", "Tracknumber", "must be an integer", -1) return -1 end

  local MediaTrack, MediaItem, num_items, Itemcount, MediaItemArray, POS, LEN
  if Tracknumber<1 or Tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetLengthOfAllMediaItems_Track", "Tracknumber", "no such track", -2) return -1 end
  
  LEN=0
  MediaTrack=reaper.GetTrack(0,Tracknumber-1)

  num_items=reaper.CountTrackMediaItems(MediaTrack)
  for i=1, num_items do
    MediaItem, Itemcount, MediaItemArray = ultraschall.EnumerateMediaItemsInTrack(Tracknumber, i)
    LEN=LEN+reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
  end
  return LEN
end

--A=ultraschall.GetLengthOfAllMediaItems_Track(2)

function ultraschall.ApplyActionToTrack(trackstring, actioncommandid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyActionToTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToTrack(string trackstring, string/number actioncommandid)</functioncall>
  <description>
    Applies action to the tracks, given by trackstring
    The action given must support applying itself to selected tracks.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, running action was successful; false, running the action was unsuccessful
  </retvals>
  <parameters>
    string trackstring - a string with all tracknumbers, separated by a comma; 1 for the first track, 2 for the second
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, run, command, track</tags>
</US_DocBloc>
]]
  -- check parameters
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("ApplyActionToTrack","trackstring", "Must be a valid trackstring!", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("ApplyActionToTrack","actioncommandid", "No valid actioncommandid!", -2) return false end
  
  -- store current track-selection, make new track-selection, run the action and restore old track-selection
  reaper.PreventUIRefresh(1)
  local selTrackstring=ultraschall.CreateTrackString_SelectedTracks() 
  ultraschall.SetTracksSelected(trackstring, true)
  ultraschall.RunCommand(actioncommandid)
  ultraschall.SetTracksSelected(selTrackstring, true)
  reaper.PreventUIRefresh(-1)
  return true
end

--ultraschall.ApplyActionToTrack("2,3,5", 6)

function ultraschall.InsertTrackAtIndex(index, number_of_tracks, wantdefaults)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertTrackAtIndex</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string trackarray, integer new_track_count, array trackarray_newtracks = ultraschall.InsertTrackAtIndex(integer index, integer number_of_tracks, boolean wantdefaults)</functioncall>
  <description>
    Inserts one or more tracks at index.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string trackstring - a trackstring with all newly created tracknumbers
    integer new_track_count - the number of newly created tracks
    array trackarray_newtracks - an array with the MediaTrack-objects of all newly created tracks
  </retvals>
  <parameters>
    integer index - the index, at which to include the new tracks; 0, for including before the first track
    integer number_of_tracks - the number of tracks that you want to create; 0 for including before track 1; number of tracks+1, include new tracks after last track
    boolean wantdefaults - true, set the tracks with default settings/fx/etc; false, create new track without any defaults
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, insert, new, track</tags>
</US_DocBloc>
]]
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("InsertTrackAtIndex", "index", "Must be an integer.", -1) return end
  if math.type(number_of_tracks)~="integer" then ultraschall.AddErrorMessage("InsertTrackAtIndex", "number_of_tracks", "Must be an integer.", -2) return end
  if type(wantdefaults)~="boolean" then ultraschall.AddErrorMessage("InsertTrackAtIndex", "wantdefaults", "Must be a boolean.", -3) return end
  if index<0 or index>reaper.CountTracks(0) then ultraschall.AddErrorMessage("InsertTrackAtIndex", "index", "No such index. Must be 0 to tracknumber+1", -4) return end
  if number_of_tracks<0 then ultraschall.AddErrorMessage("InsertTrackAtIndex", "number_of_tracks", "Must be bigger than 0", -5) return end
  local TrackArray={}
  local count=reaper.CountTracks(0)-1
  local found
  for i=0, reaper.CountTracks(0)-1 do
    TrackArray[i+1]={}
    TrackArray[i+1][1]=reaper.GetTrack(0,i)
    TrackArray[i+1][2]=reaper.IsTrackSelected(TrackArray[i+1][1])
  end
  ultraschall.SetTracksSelected(tostring(index), true)
  for i=1, number_of_tracks do
    reaper.InsertTrackAtIndex(index, wantdefaults)
  end
  ultraschall.SetAllTracksSelected(false) 

  for i=1, count do
    reaper.SetTrackSelected(TrackArray[i+1][1], TrackArray[i+1][2])
  end
  
  local trackstring2=""
  local Trackarray2={}
  local newcount=0
  for i=0, reaper.CountTracks(0)-1 do
    for a=1, count do
      if reaper.GetTrack(0,i)==TrackArray[a+1][1] then found=true end
    end
    if found==false then trackstring2=trackstring2..i.."," newcount=newcount+1 Trackarray2[newcount]=reaper.GetTrack(0,i) end
    found=false
  end
  return trackstring2:sub(1,-2), newcount, Trackarray2
end

--A,B,C=ultraschall.InsertTrackAtIndex(1, 1, false)

function ultraschall.MoveTracks(trackstring, targetindex, makepreviousfolder)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MoveTracks(string trackstring, integer targetindex, integer makepreviousfolder)</functioncall>
  <description>
    Moves tracks in trackstring to position targetindex. You can also set, if the tracks shall become folders.
    Multiple tracks in trackstring will be put together, so track 2, 4, 6 would become 1, 2, 3, when moved above the first track!
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, moving was successful; false, moving wasn't successful
  </retvals>
  <parameters>
    string trackstring - a string with all tracknumbers of the tracks you want to move, separated by commas
    integer targetindex - the index, to which to move the tracks; 0, move tracks before track 1; number of tracks+1, move after the last track
    integer makepreviousfolder - make tracks a folder or not
                               - 0, for normal, 
                               - 1, as child of track preceding track specified by makepreviousfolder
                               - 2, if track preceding track specified by makepreviousfolder is last track in folder, extend folder
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, move, track, tracks, folder</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("MoveTracks", "trackstring", "Must be a valid trackstring.", -1) return false end
  if math.type(targetindex)~="integer" then ultraschall.AddErrorMessage("MoveTracks", "targetindex", "Must be an integer.", -2) return false end
  if math.type(makepreviousfolder)~="integer" then ultraschall.AddErrorMessage("MoveTracks", "makepreviousfolder", "Must be an integer.", -3) return false end
  if targetindex<0 or targetindex>reaper.CountTracks(0)+1 then ultraschall.AddErrorMessage("MoveTracks", "targetindex", "No such track.", -4) return false end
  if makepreviousfolder<0 or makepreviousfolder>2 then ultraschall.AddErrorMessage("MoveTracks", "makepreviousfolder", "Must be between 0 and 2.", -5) return false end
  reaper.PreventUIRefresh(1)
  local TrackArray={}
  
  for i=0, reaper.CountTracks(0)-1 do
    TrackArray[i+1]={}
    TrackArray[i+1][1]=reaper.GetTrack(0,i)
    TrackArray[i+1][2]=reaper.IsTrackSelected(TrackArray[i+1][1])
  end
  ultraschall.SetTracksSelected(trackstring, true)
  
  local retval=reaper.ReorderSelectedTracks(targetindex, makepreviousfolder)
  
  for i=0, reaper.CountTracks(0)-1 do
    reaper.SetTrackSelected(TrackArray[i+1][1], TrackArray[i+1][2])
  end
  reaper.PreventUIRefresh(-1)
  return retval
end

--L=ultraschall.MoveTracks("2,3,5", 8, 1)

function ultraschall.CreateTrackString_ArmedTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackString_ArmedTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackString_ArmedTracks()</functioncall>
  <description>
    Gets a trackstring with tracknumbers of all armed tracks in it.
    
    Returns "" if no track is armed.
  </description>
  <retvals>
    string trackstring - a trackstring with the tracknumbers of all armed tracks as comma separated csv-string, eg: "1,3,4,7"
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, tracks, armed, trackstring</tags>
</US_DocBloc>
--]]
  local trackstring=""
  for i=0, reaper.CountTracks(0)-1 do
    local MediaTrack=reaper.GetTrack(0,i)
    if reaper.GetMediaTrackInfo_Value(MediaTrack, "I_RECARM")==1 then trackstring=trackstring..(i+1).."," end
  end
  return trackstring:sub(1,-2)
end

function ultraschall.CreateTrackString_UnarmedTracks()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackString_UnarmedTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackString_UnarmedTracks()</functioncall>
  <description>
    Gets a trackstring with tracknumbers of all unarmed tracks in it.
    
    Returns "" if all tracks are armed.
  </description>
  <retvals>
    string trackstring - a trackstring with the tracknumbers of all unarmed tracks as comma separated csv-string, eg: "1,3,4,7"
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, tracks, unarmed, trackstring</tags>
</US_DocBloc>
--]]
  local trackstring=""
  for i=0, reaper.CountTracks(0)-1 do
    local MediaTrack=reaper.GetTrack(0,i)
    if reaper.GetMediaTrackInfo_Value(MediaTrack, "I_RECARM")==0 then trackstring=trackstring..(i+1).."," end
  end
  return trackstring:sub(1,-2)
end

--L=ultraschall.CreateTrackString_UnarmedTracks()

function ultraschall.CreateTrackStringByGUID(guid_csv_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackStringByGUID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackStringByGUID(string guid_csv_string)</functioncall>
  <description>
    returns a trackstring with all tracks, as given by the GUIDs in the comma-separated-csv-string guid_csv_string.
    
    returns "" in case of an error, like no track available or an invalid string
  </description>
  <retvals>
    string trackstring - a string with all the tracknumbers of the tracks given as GUIDs in guid_csv_string
  </retvals>
  <parameters>
    string guid_csv_string - a comma-separated csv-string, that includes all GUIDs of all track to be included in the trackstring.
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackstring, track, create, guid</tags>
</US_DocBloc>
--]]
  if type(guid_csv_string)~="string" then ultraschall.AddErrorMessage("CreateTrackStringByGUID", "guid_csv_string", "Must be a string", -1) return "" end
  local Trackstring=""
  local A,B=ultraschall.CSV2IndividualLinesAsArray(guid_csv_string)
  for i=1, A do
    local Track=reaper.BR_GetMediaTrackByGUID(0, B[i])
    if Track~=nil then Trackstring=Trackstring..","..math.ceil(reaper.GetMediaTrackInfo_Value(Track, "IP_TRACKNUMBER")) end
  end
  local retval, Trackstring = ultraschall.RemoveDuplicateTracksInTrackstring(Trackstring)
  return Trackstring
end



function ultraschall.CreateTrackStringByTracknames(tracknames_csv_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackStringByTracknames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackStringByTracknames(string tracknames_csv_string)</functioncall>
  <description>
    returns a trackstring with all tracks, as given by the tracknames in the newline(!)-separated-csv-string guid_csv_string.
    
    returns "" in case of an error, like no track available or an invalid string
  </description>
  <retvals>
    string trackstring - a string with all the tracknumbers of the tracks given as tracknames in tracknames_csv_string
  </retvals>
  <parameters>
    string tracknames_csv_string - a newline(!)-separated csv-string, that includes all tracknames of all track to be included in the trackstring. Tracknames are case sensitive!
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackstring, track, create, tracknames</tags>
</US_DocBloc>
--]]
  if type(tracknames_csv_string)~="string" then ultraschall.AddErrorMessage("CreateTrackStringByTracknames", "tracknames_csv_string", "Must be a string", -1) return "" end
  local Trackstring=""
  local A,B=ultraschall.CSV2IndividualLinesAsArray(tracknames_csv_string, "\n")
  for a=0, reaper.CountTracks(0)-1 do    
    local Track=reaper.GetTrack(0,a)
    for i=1,A do
      local retval, Name=reaper.GetTrackName(Track,"")
      if Name==B[i] then Trackstring=Trackstring..","..(a+1) break end
    end
  end
  local retval, Trackstring = ultraschall.RemoveDuplicateTracksInTrackstring(Trackstring)
  return Trackstring
end



function ultraschall.CreateTrackStringByMediaTracks(MediaTrackArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTrackStringByMediaTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string trackstring = ultraschall.CreateTrackStringByMediaTracks(array MediaTrackArray)</functioncall>
  <description>
    returns a trackstring with all tracks, as given in the array MediaTrackArray
    
    returns "" in case of an error, like no track available or an invalid string
  </description>
  <retvals>
    string trackstring - a string with all the tracknumbers of the MediaTrack-objects given in parameter MediaTrackArray
  </retvals>
  <parameters>
    array MediaTrackArray - an array, that includes all MediaTrack-objects to be included in the trackstring; a nil-entry is seen as the end of the array
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackstring, track, create, mediatrack, mediatracks</tags>
</US_DocBloc>
--]]
  if type(MediaTrackArray)~="table" then ultraschall.AddErrorMessage("CreateTrackStringByMediaTracks", "MediaTrackArray", "Must be an array", -1) return "" end
  local Trackstring=""

  local count=1
  while MediaTrackArray[count]~=nil do
    if ultraschall.type(MediaTrackArray[count])=="MediaTrack" then
      Trackstring=Trackstring..","..math.ceil(reaper.GetMediaTrackInfo_Value(MediaTrackArray[count], "IP_TRACKNUMBER"))
    end
    count=count+1
  end
  local retval, Trackstring = ultraschall.RemoveDuplicateTracksInTrackstring(Trackstring)
  return Trackstring
end



function ultraschall.GetTracknumberByGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTracknumberByGuid</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer tracknumber, MediaTrack tr = ultraschall.GetTracknumberByGuid(string guid)</functioncall>
  <description>
    returns the tracknumber and track of a guid. The track must be in the currently active project!
    
    Supports the returned guids by reaper.BR_GetMediaTrackGUID and reaper.GetTrackGUID.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer tracknumber - the number of the track; 0, for master track; 1, for track 1; 2, for track 2, etc. -1, in case of an error
    MediaTrack tr - the MediaTrack-object of the requested track; nil, if no track is found
  </retvals>
  <parameters>
    string gui - the guid of the track, that you want to request
  </parameters>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>track management, get, track, guid, tracknumber</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidGuid(guid, true)==false then ultraschall.AddErrorMessage("GetTracknumberByGuid", "guid", "no valid guid", -1) return -1 end
  if reaper.GetTrackGUID(reaper.GetMasterTrack(0))==guid then return 0, reaper.GetMasterTrack(0) end
  if guid=="{00000000-0000-0000-0000-000000000000}" then 
    return 0, reaper.GetMasterTrack(0)
  else 
    local MediaTrack = reaper.BR_GetMediaTrackByGUID(0, guid)
    if MediaTrack==nil then ultraschall.AddErrorMessage("GetTracknumberByGuid", "guid", "no track with that guid available", -2) return -1 end
    return math.floor(reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER") ), MediaTrack 
  end
end


function ultraschall.DeleteTracks_TrackString(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteTracks_TrackString</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteTracks_TrackString(string trackstring)</functioncall>
  <description>
    deletes all tracks in trackstring
    
    Returns false in case of an error
  </description>
  <parameters>
    string trackstring - a string with all tracknumbers, separated by commas
  </parameters>
  <retvals>
    boolean retval - true, setting it was successful; false, setting it was unsuccessful
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, delete, track, trackstring</tags>
</US_DocBloc>
]]
  local valid, count, individual_tracknumbers = ultraschall.IsValidTrackString(trackstring)
  if valid==false then ultraschall.AddErrorMessage("DeleteTracks_TrackString", "trackstring", "must be a valid trackstring", -1) return false end
  for i=count, 1, -1 do
    reaper.DeleteTrack(reaper.GetTrack(0,individual_tracknumbers[i]-1))
  end
  return true
end


function ultraschall.AnyTrackMute(master)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackMute</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackMute(optional boolean master)</functioncall>
  <description>
    returns true, if any track is muted, otherwise returns false.
  </description>
  <parameters>
    optional boolean master - true, include the master-track as well; false, don't include master-track
  </parameters>
  <retvals>
    boolean retval - true, if any track is muted; false, if not
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, is, track, master, mute</tags>
</US_DocBloc>
]]
  local retval, mute
  
  if master==true then
    retval, mute = reaper.GetTrackUIMute(reaper.GetMasterTrack(0))
    if mute==true then return true end
  end
  
  for i=0, reaper.CountTracks(0)-1 do
    retval, mute = reaper.GetTrackUIMute(reaper.GetTrack(0,i))
    if mute==true then return true end
  end
  return false
end

--A=ultraschall.AnyTrackMute()

function ultraschall.AnyTrackRecarmed()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackRecarmed</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackRecarmed()</functioncall>
  <description>
    Returns true, if any track is recarmed.
  </description>
  <retvals>
    boolean retval - true, at least one track is recarmed; false, no track is recarmed
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, any track, recarmed</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "I_RECARM")~=0 then return true end
  end
  return false
end

function ultraschall.AnyTrackPhased()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackPhased</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackPhased()</functioncall>
  <description>
    Returns true, if any track has phase-invert activated.
  </description>
  <retvals>
    boolean retval - true, at least one track has an activated phase-invert; false, no track is phase-inverted
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, phase</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "B_PHASE")~=0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackPhased()

function ultraschall.AnyTrackRecMonitored()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackRecMonitored</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackRecMonitored()</functioncall>
  <description>
    Returns true, if any track has monitoring of recinput activated.
  </description>
  <retvals>
    boolean retval - true, at least one track has an activated rec-monitoring; false, no track is rec-monitored
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, recmonitor</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "I_RECMON")~=0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackRecMonitored()

function ultraschall.AnyTrackHiddenTCP(master)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackHiddenTCP</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackHiddenTCP(optional boolean master)</functioncall>
  <description>
    Returns true, if any track is hidden in Track Control Panel.
  </description>
  <parameters>
    optional boolean master - true, include the master-track; false, don't include the master-track
  </parameters>
  <retvals>
    boolean retval - true, at least one track is hidden in TCP; false, no track is hidden
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, hidden, tcp, master</tags>
</US_DocBloc>
]]
  if master==true then
    if reaper.SNM_GetIntConfigVar("showmaintrack", -99)==0 then return true end
  end
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "B_SHOWINTCP")==0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackHiddenTCP()

function ultraschall.AnyTrackHiddenMCP(master)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackHiddenMCP</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackHiddenMCP(optional boolean master)</functioncall>
  <description>
    Returns true, if any track is hidden in Mixer Control Panel.
  </description>
  <parameters>
    optional boolean master - true, include the master-track; false, don't include the master-track
  </parameters>
  <retvals>
    boolean retval - true, at least one track is hidden in MCP; false, no track is hidden
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, hidden, mcp, master</tags>
</US_DocBloc>
]]
  if master==true then
    if reaper.SNM_GetIntConfigVar("mixrowflags", -99)&256==256 then return true end
  end
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "B_SHOWINMIXER")==0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackHiddenMCP(true)

function ultraschall.AnyTrackFreeItemPositioningMode()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackFreeItemPositioningMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackFreeItemPositioningMode()</functioncall>
  <description>
    Returns true, if any track has free item positioning mode(freemode) activated.
  </description>
  <retvals>
    boolean retval - true, at least one track has freemode activated; false, no track has freemode-activated
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, freemode, free item positioning mode</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "B_FREEMODE")~=0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackFreeItemPositioningMode()

function ultraschall.AnyTrackFXBypass(master)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackFXBypass</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackFXBypass(optional boolean master)</functioncall>
  <description>
    Returns true, if any track has fx-bypass activated.
  </description>
  <parameters>
    optional boolean master - true, include the master-track; false, don't include the master-track
  </parameters>
  <retvals>
    boolean retval - true, at least one track has fx bypass activated; false, no track has fx-bypass activated
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>helper functions, get, anytrack, fx bypass</tags>
</US_DocBloc>
]]
  if master==true then
    if reaper.GetMediaTrackInfo_Value(reaper.GetMasterTrack(0), "I_FXEN")==0 then return true end
  end
  for i=0, reaper.CountTracks(0)-1 do
    if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0,i), "I_FXEN")==0 then return true end
  end
  return false
end

--A=ultraschall.AnyTrackFXBypass(true)

function ultraschall.SetTrack_LastTouched(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrack_LastTouched</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTrack_LastTouched(integer track)</functioncall>
  <description>
    Sets a track to be last touched track.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was not successful
  </retvals>
  <parameters>
    integer track - the track, which you want to set as last touched track
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>track management, set, last touched track</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrack_LastTouched", "tracknumber", "must be an integer", -1) return false end
  local track = reaper.GetTrack(0,tracknumber-1)
  if track==nil then ultraschall.AddErrorMessage("SetTrack_LastTouched", "tracknumber", "no such track", -2) return false end
  local trackstring = ultraschall.CreateTrackString_SelectedTracks()
  reaper.SetOnlyTrackSelected(track)
  local retval = ultraschall.SetTracksSelected(trackstring, true)
  return true
end

function ultraschall.GetTrackByTrackName(trackname, case_sensitive, escaped_strict)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackByTrackName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>integer number_of_found_tracks, table found_tracks, table found_tracknames = ultraschall.GetTrackByTrackName(string trackname, boolean case_sensitive, integer escaped_strict)</functioncall>
  <description>
    returns all tracks with a certain name.
    
    You can set case-sensitivity, whether pattern-matchin is possible and whether the name shall be used strictly.
    For instance, if you want to look for a track named exactly "JaM.-Enlightened" you set case_sensitive=false and escaped_strict=2. That way, tracks names "JaM.*Enlightened" will be ignored.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_found_tracks - the number of found tracks
    table found_tracks - the found tracks as table
    table found_tracknames - the found tracknames
  </retvals>
  <parameters>
    string trackname - the trackname to look for
    boolean case_sensitive - true, take care of case-sensitivity; false, don't take case-sensitivity into account
    integer escaped_strict - 0, use trackname as matching-pattern, will find all tracknames following the pattern(Ja.-m -> Jam, Jam123Police, JaABBAm)
                           - 1, escape trackname off all magic characters, will find all tracknames with the escaped pattern in it (Ja.-m -> Ja.-m, Jam.-boree)
                           - 2, strict, will only find tracks with the exact trackname-string in their name(Jam -> Jam)
  </parameters>            
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>track management, set, last touched track</tags>
</US_DocBloc>
--]]
  if type(trackname)~="string" then ultraschall.AddErrorMessage("GetTrackByTrackName", "trackname", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("GetTrackByTrackName", "case_sensitive", "must be a boolean", -2) return -1 end
  if math.type(escaped_strict)~="integer" then ultraschall.AddErrorMessage("GetTrackByTrackName", "escaped_strict", "must be an integer", -3) return -1 end
  if escaped_strict<0 or escaped_strict>2 then ultraschall.AddErrorMessage("GetTrackByTrackName", "escaped_strict", "must be between 0 and 2", -4) return -1 end
  local trackcount=0
  local Tracks={}
  local TrackNames={}
  local retval, buf, found_track, track, trackname2
  if case_sensitive==false then trackname=trackname:lower() end
  if escaped_strict>0 then
    trackname2=ultraschall.EscapeMagicCharacters_String(trackname)
  else
    ultraschall.IsValidMatchingPattern(trackname)
    if ultraschall.IsValidMatchingPattern(trackname)==false then ultraschall.AddErrorMessage("GetTrackByTrackName", "trackname", "must be valid matching pattern", -5) return -1 end
    trackname2=trackname
  end

  for i=0, reaper.CountTracks()-1 do
    track=reaper.GetTrack(0,i)
    retval, buf = reaper.GetTrackName(track)
    found_track=buf:match(trackname2)

    if found_track~=nil then
      if escaped_strict==2 then
        if buf==trackname then 
          trackcount=trackcount+1 TrackNames[trackcount]=buf Tracks[trackcount]=track 
        end
      else
        trackcount=trackcount+1 TrackNames[trackcount]=buf Tracks[trackcount]=track
      end
    end
  end
  return trackcount, Tracks, TrackNames
end

function ultraschall.CollapseTrackHeight(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CollapseTrackHeight</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CollapseTrackHeight(integer track)</functioncall>
  <description>
    Collapses the height of a track to the minimum height as set by the theme
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, collapsing was successful; false, collapsing was not successful
  </retvals>
  <parameters>
    integer track - the track, which you want to collapse in height
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>track management, set, collapse, trackheight</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("CollapseTrackHeight", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 then ultraschall.AddErrorMessage("CollapseTrackHeight", "tracknumber", "must be bigger 0 for master track for 1 and higher for regular tracks", -2) return false end
  local track
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else
    track=reaper.GetTrack(0,tracknumber-1)
  end
  if track==nil then ultraschall.AddErrorMessage("CollapseTrackHeight", "tracknumber", "no such track", -5) return false end
  local lockstate = reaper.GetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", 0) -- get current lockstate
  reaper.SetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", 0) -- unlock track
  reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", 1) -- set new height
  reaper.TrackList_AdjustWindows(false) -- update TCP
  reaper.SetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", lockstate) -- restore lockstate of track
  return true
end

--A=ultraschall.CollapseTrack(1)

function ultraschall.SetTrack_Trackheight_Force(tracknumber, trackheight)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrack_Trackheight_Force</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetTrack_Trackheight_Force(integer track, integer trackheight)</functioncall>
  <description>
    Sets the trackheight of a track. Forces trackheight beyond limits set by the theme.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, collapsing was successful; false, collapsing was not successful
  </retvals>
  <parameters>
    integer track - the track, which you want to set the height of
    integer trackheigt - the trackheight in pixels, 0 and higher
  </parameters>
  <chapter_context>
    Track Management
    Set Track States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>track management, set, trackheight, force</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetTrack_Trackheight_Force", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 then ultraschall.AddErrorMessage("SetTrack_Trackheight_Force", "tracknumber", "must be bigger 0 for master track for 1 and higher for regular tracks", -2) return false end
  if math.type(trackheight)~="integer" then ultraschall.AddErrorMessage("SetTrack_Trackheight_Force", "trackheight", "must be an integer", -3) return false end
  if trackheight<0 then ultraschall.AddErrorMessage("SetTrack_Trackheight_Force", "trackheight", "must be bigger or equal 0", -4) return false end
  local track
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else
    track=reaper.GetTrack(0,tracknumber-1)
  end
  if track==nil then ultraschall.AddErrorMessage("SetTrack_Trackheight_Force", "tracknumber", "no such track", -5) return false end
  local lockstate = reaper.GetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", 0) -- get current lockstate
  reaper.SetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", 1) -- unlock track
  reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", trackheight) -- set new height
  reaper.TrackList_AdjustWindows(false) -- update TCP
  reaper.SetMediaTrackInfo_Value(track, "B_HEIGHTLOCK", lockstate) -- restore lockstate of track
  return true
end

--A=ultraschall.SetTrack_Trackheight_Force(1, 2147483586)

function ultraschall.GetAllVisibleTracks_Arrange(master_track, completely_visible)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetAllVisibleTracks_Arrange</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>string trackstring, integer tracktable_count, table tracktable = ultraschall.GetAllVisibleTracks_Arrange(optional boolean master_track, optional boolean completely_visible)</functioncall>
    <description>
      returns a trackstring with all tracks currently visible in the arrange-view.
      
      Note: Item who start above and end below the visible arrangeview will be treated as not completely visible!
      
      returns nil in case of error
    </description>
    <retvals>
      string trackstring - a string with holds all tracknumbers from all found tracks, separated by a comma; beginning with 1 for the first track
      integer tracktable_count - the number of tracks found
      table tracktable - a table which holds all MediaTrack-objects
    </retvals>
    <parameters>
      optional boolean master_track - nil or true, check for visibility of the master-track; false, don't include the master-track
      optional boolean completely_visible - nil or false, all tracks including partially visible ones; true, only fully visible tracks
    </parameters>
    <chapter_context>
      Track Management
      Assistance functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
    <tags>track management, get, all visible, tracks, arrangeview</tags>
  </US_DocBloc>
  --]]
  if completely_visible~=nil and ultraschall.type(completely_visible)~="boolean" then ultraschall.AddErrorMessage("GetAllVisibleTracks_Arrange", "completely_visible", "must be either nil(for false) or a boolean",-1) return end
  if master_track~=nil and ultraschall.type(master_track)~="boolean" then ultraschall.AddErrorMessage("GetAllVisibleTracks_Arrange", "master_track", "must be either nil(for true) or a boolean",-1) return end
  local arrange_view = ultraschall.GetHWND_ArrangeViewAndTimeLine()
  local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(arrange_view)
  
  -- find all tracks currently visible
  local trackstring=""
  local tracktable={}
  local tracktable_count=0
  if master_track~=false then
    if reaper.SNM_GetIntConfigVar("showmaintrack",-99)&1==1 then
      local track=reaper.GetMasterTrack(0)
      if completely_visible==false then
        if reaper.GetMediaTrackInfo_Value(track, "I_TCPY")<=bottom-top or reaper.GetMediaTrackInfo_Value(track, "I_TCPY")+reaper.GetMediaTrackInfo_Value(track, "I_WNDH")>=0 then
          trackstring="0,"
          tracktable_count=tracktable_count+1
          tracktable[tracktable_count]=track
        end
      else
        if reaper.GetMediaTrackInfo_Value(track, "I_TCPY")>=0 and reaper.GetMediaTrackInfo_Value(track, "I_TCPY")+reaper.GetMediaTrackInfo_Value(track, "I_WNDH")<=bottom-top then
          trackstring="0,"
          tracktable_count=tracktable_count+1
          tracktable[tracktable_count]=track
        end
      end
    end
  end
   
  for i=1, reaper.CountTracks(0) do
    local track=reaper.GetTrack(0, i-1)
    if completely_visible==true then 
      if reaper.GetMediaTrackInfo_Value(track, "I_TCPY")>=0 and reaper.GetMediaTrackInfo_Value(track, "I_TCPY")+reaper.GetMediaTrackInfo_Value(track, "I_WNDH")<=bottom-top then
        trackstring=trackstring..i.."," 
        tracktable_count=tracktable_count+1
        tracktable[tracktable_count]=track
      end
    else
      if reaper.GetMediaTrackInfo_Value(track, "I_TCPY")<=bottom-top and reaper.GetMediaTrackInfo_Value(track, "I_TCPY")+reaper.GetMediaTrackInfo_Value(track, "I_WNDH")>=0 then
        trackstring=trackstring..i..","
        tracktable_count=tracktable_count+1
        tracktable[tracktable_count]=track
      end
    end
  end
  return trackstring:sub(1,-2), tracktable_count, tracktable
end



function ultraschall.IsTrackVisible(track, completely_visible)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsTrackVisible</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.IsTrackVisible(MediaTrack track, boolean completely_visible)</functioncall>
    <description>
      returns if a track is currently visible in arrangeview
        
      returns nil in case of error
    </description>
    <retvals>
      boolean retval - true, track is visible; false, track is not visible
    </retvals>
    <parameters>
      MediaTrack track - the track, whose visibility you want to query
      boolean completely_visible - false, all tracks including partially visible ones; true, only fully visible tracks
    </parameters>
    <chapter_context>
      Track Management
      Assistance functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
    <tags>track management, get, visible, tracks, arrangeview</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("IsTrackVisible", "track", "must be a MediaTrack", -1) return end
  if type(completely_visible)~="boolean" then ultraschall.AddErrorMessage("IsTrackVisible", "completely_visible", "must be a boolean", -2) return end
  local trackstring, tracktable_count, tracktable = ultraschall.GetAllVisibleTracks_Arrange(true, completely_visible)
  local found=false
  for i=1, tracktable_count do
    if tracktable[i]==track then found=true end
  end
  return found
end

