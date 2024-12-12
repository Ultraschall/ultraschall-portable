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
---  MediaItem: Management Module ---
-------------------------------------

function ultraschall.IsValidMediaItemStateChunk(itemstatechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidMediaItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidMediaItemStateChunk(string MediaItemStateChunk)</functioncall>
  <description>
    Checks, whether MediaItemStateChunk is a valide MediaItemStateChunk.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, MediaItemStateChunk is valid; false, MediaItemStateChunk isn't a valid statechunk
  </retvals>
  <parameters>
    string MediaItemStateChunk - the string to check, if it's a valid MediaItemStateChunk
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, check, mediaitemstatechunk, valid</tags>
</US_DocBloc>
]]
  if type(itemstatechunk)~="string" then ultraschall.AddErrorMessage("IsValidMediaItemStateChunk", "itemstatechunk", "Must be a string.", -1) return false end  
  itemstatechunk=itemstatechunk:match("<ITEM.*%c>\n")
  if itemstatechunk==nil then return false end
  local count1=ultraschall.CountCharacterInString(itemstatechunk, "<")
  local count2=ultraschall.CountCharacterInString(itemstatechunk, ">")
  if count1~=count2 then return false end
  return true
end

function ultraschall.CheckMediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, array retMediaItemArray = ultraschall.CheckMediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Checks, whether MediaItemArray is valid.
    It throws out all entries, that are not MediaItems and returns the altered array as result.
    
    returns false in case of error or if it is not a valid MediaItemArray
  </description>
  <parameters>
    array MediaItemArray - a MediaItemArray that shall be checked for validity
  </parameters>
  <retvals>
    boolean retval - returns true if MediaItemArray is valid, false if not
    integer count - the number of entries in the returned retMediaItemArray
    array retMediaItemArray - the, possibly, altered MediaItemArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, check</tags>
</US_DocBloc>
]]
  if type(MediaItemArray)~="table" then ultraschall.AddErrorMessage("CheckMediaItemArray", "MediaItemArray", "Only array with MediaItemObjects as entries is allowed.", -1) return false end
  local count=1
  while MediaItemArray[count]~=nil do
    if reaper.ValidatePtr(MediaItemArray[count],"MediaItem*")==false then table.remove(MediaItemArray,count)
    else
      count=count+1
    end
  end
  if count==1 then return false, count-1, MediaItemArray
  else return true, count-1, MediaItemArray
  end
end

function ultraschall.IsValidMediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, array retMediaItemArray = ultraschall.IsValidMediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Checks, whether MediaItemArray is valid.
    It throws out all entries, that are not MediaItems and returns the altered array as result.
    
    returns false in case of an error or if it is not a valid MediaItemArray
  </description>
  <parameters>
    array MediaItemArray - a MediaItemArray that shall be checked for validity
  </parameters>
  <retvals>
    boolean retval - returns true if MediaItemArray is valid, false if not
    integer count - the number of entries in the returned retMediaItemArray
    array retMediaItemArray - the, possibly, altered MediaItemArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, check</tags>
</US_DocBloc>
]]
  if type(MediaItemArray)~="table" then ultraschall.AddErrorMessage("IsValidMediaItemArray", "MediaItemArray", "Only array with MediaItemObjects as entries is allowed.", -1) return false end
  local count=1
  while MediaItemArray[count]~=nil do
    if reaper.ValidatePtr(MediaItemArray[count],"MediaItem*")==false then table.remove(MediaItemArray,count)
    else
      count=count+1
    end
  end
  if count==1 then return false, count-1, MediaItemArray
  else return true, count-1, MediaItemArray
  end
end

function ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckMediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, array retMediaItemStateChunkArray = ultraschall.CheckMediaItemStateChunkArray(array MediaItemStateChunkArray)</functioncall>
  <description>
    Checks, whether MediaItemStateChunkArray is valid.
    It throws out all entries, that are not MediaItemStateChunks and returns the altered array as result.
    
    returns false in case of an error or if it is not a valid MediaItemStateChunkArray
  </description>
  <parameters>
    array MediaItemStateChunkArray - a MediaItemStateChunkArray that shall be checked for validity
  </parameters>
  <retvals>
    boolean retval - returns true if MediaItemStateChunkArray is valid, false if not
    integer count - the number of entries in the returned retMediaItemStateChunkArray
    array retMediaItemStateChunkArray - the, possibly, altered MediaItemStateChunkArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, chunk, check</tags>
</US_DocBloc>
]]
--checks, if MediaItemStateChunkArray is a valid array.
-- throws out all invalid table-entries
  if type(MediaItemStateChunkArray)~="table" then ultraschall.AddErrorMessage("CheckMediaItemStateChunkArray", "MediaItemStateChunkArray", "Only array with MediaItemStateChunks as entries allowed.", -1) return false end
  local count=1
  while MediaItemStateChunkArray[count]~=nil do
    if type(MediaItemStateChunkArray[count])~="string" or MediaItemStateChunkArray[count]:match("<ITEM.*>")==nil then table.remove(MediaItemStateChunkArray,count)
    else
      count=count+1
    end
  end
  if count==1 then return false
  else return true, count-1, MediaItemStateChunkArray
  end
end

function ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidMediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, array retMediaItemStateChunkArray = ultraschall.IsValidMediaItemStateChunkArray(array MediaItemStateChunkArray)</functioncall>
  <description>
    Checks, whether MediaItemStateChunkArray is valid.
    It throws out all entries, that are not MediaItemStateChunks and returns the altered array as result.
    
    returns false in case of an error or if it is not a valid MediaItemStateChunkArray
  </description>
  <parameters>
    array MediaItemStateChunkArray - a MediaItemStateChunkArray that shall be checked for validity
  </parameters>
  <retvals>
    boolean retval - returns true if MediaItemStateChunkArray is valid, false if not
    integer count - the number of entries in the returned retMediaItemStateChunkArray
    array retMediaItemStateChunkArray - the, possibly, altered MediaItemStateChunkArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, chunk, check</tags>
</US_DocBloc>
]]
  ultraschall.SuppressErrorMessages(true)
  local retval, count, retMediaItemStateChunkArray = ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)
  ultraschall.SuppressErrorMessages(false)
  return retval, count, retMediaItemStateChunkArray
end


function ultraschall.GetMediaItemsAtPosition(position, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemsAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetMediaItemsAtPosition(number position, string trackstring)</functioncall>
  <description>
    Gets all Mediaitems at position, from the tracks given by trackstring.
    Returns a MediaItemArray with the found MediaItems
    
    returns -1 in case of error
  </description>
  <parameters>
    number position - position in seconds
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    integer number_of_items - the number of items at position
    array MediaItemArray - an array, that contains all MediaItems at position from the tracks given by trackstring.
    array MediaItemStateChunkArray - an array, that contains all Mediaitem's MediaItemStatechunks at position from the tracks given by trackstring.
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selection, statechunk</tags>
</US_DocBloc>
]]

  if type(position)~="number" then ultraschall.AddErrorMessage("GetMediaItemsAtPosition","position", "must be a number", -1) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetMediaItemsAtPosition","trackstring", "must be a valid trackstring", -2) return -1 end
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  
  local MediaItemArray={}
  local MediaItemStateChunkArray={}
  local count=0
  local Numbers, LineArray=ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local Anumber=reaper.CountMediaItems(0)
  local temp
  for i=0,Anumber-1 do
    local MediaItem=reaper.GetMediaItem(0, i)
    local Astart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    local Alength=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItem)
    local MediaTrackNumber=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
    local Aend=Astart+Alength
    if position>=Astart and position<=Aend then
       for a=1, Numbers do
--       reaper.MB(MediaTrackNumber,LineArray[a],0)
        if tonumber(LineArray[a])==nil then ultraschall.AddErrorMessage("GetMediaItemsAtPosition","trackstring", "must be a valid trackstring", -2) return -1 end
        if MediaTrackNumber==tonumber(LineArray[a]) then
          count=count+1 
          MediaItemArray[count]=MediaItem
          temp, MediaItemStateChunkArray[count]=reaper.GetItemStateChunk(MediaItemArray[count], "", true)
--          reaper.MB(MediaTrackNumber,LineArray[a],0)
        end
       end
    end
  end
  return count, MediaItemArray, MediaItemStateChunkArray
end


function ultraschall.OnlyMediaItemsOfTracksInTrackstring(MediaItemArray, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyMediaItemsOfTracksInTrackstring</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, array MediaItemArray = ultraschall.OnlyMediaItemsOfTracksInTrackstring(array MediaItemArray, string trackstring)</functioncall>
  <description>
    Throws all MediaItems out of the MediaItemArray, that are not within the tracks, as given with trackstring.
    Returns the "cleared" MediaItemArray
    
    returns -1 in case of error
  </description>
  <parameters>
    array MediaItemArray - an array with MediaItems; no nil-entries allowed, will be seen as the end of the array
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    array MediaItemArray - the "cleared" array, that contains only Items in tracks, as given by trackstring, -1 in case of error
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selection</tags>
</US_DocBloc>
]]
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring","MediaItemArray", "must be a MediaItemArray", -1) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring","trackstring", "must be a valid trackstring", -2) return -1 end
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  
  local count=1
  local count2=1
  local i=1
  local _count, trackstring_array = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local MediaItemArray2={}
  
  while MediaItemArray[count]~=nil do
    if MediaItemArray[count]==nil then break end
    i=1
    while trackstring_array[i]~=nil do
      if tonumber(trackstring_array[i])==nil then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring","MediaItemArray", "must be a valid MediaItemArray", -1) return -1 end
        if reaper.GetTrack(0,trackstring_array[i]-1)==reaper.GetMediaItem_Track(MediaItemArray[count]) then
          MediaItemArray2[count2]=MediaItemArray[count]
          count2=count2+1
        end
        i=i+1
    end
    count=count+1
  end
  return 1, MediaItemArray2
end


function ultraschall.SplitMediaItems_Position(position, trackstring, crossfade)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitMediaItems_Position</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemArray = ultraschall.SplitMediaItems_Position(number position, string trackstring, boolean crossfade)</functioncall>
  <description>
    Splits items at position, in the tracks given by trackstring.
    If auto-crossfade is set in the Reaper-preferences, crossfade turns it on(true) or off(false).
    
    Returns false, in case of error.
  </description>
  <parameters>
    number position - the position in seconds
    string trackstring - the numbers for the tracks, where split shall be applied to; numbers separated by a comma
    boolean crossfade - true or nil, automatic crossfade(if enabled) will be applied; false, automatic crossfade is off
  </parameters>
  <retvals>
    boolean retval - true - success, false - error
    array MediaItemArray - an array with the items on the right side of the split
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, split, edit, crossfade</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("SplitMediaItems_Position","position", "must be a number", -1) return false end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("SplitMediaItems_Position","trackstring", "must be valid trackstring", -2) return false end

  local A,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("SplitMediaItems_Position","trackstring", "must be valid trackstring", -2) return false end

  local FadeOut, MediaItem, oldfade, oldlength
  local ReturnMediaItemArray={}
  local count=0
  local Numbers, LineArray=ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local Anumber=reaper.CountMediaItems(0)

  if crossfade~=nil and type(crossfade)~="boolean" then ultraschall.AddErrorMessage("SplitMediaItems_Position","crossfade", "must be boolean", -3) return false end
  for i=Anumber-1,0,-1 do
    MediaItem=reaper.GetMediaItem(0, i)
    local Astart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    local Alength=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
    FadeOut=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEOUTLEN")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItem)
    local MediaTrackNumber=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
    local Aend=(Astart+Alength)
    if position>=Astart and position<=Aend then
       for a=1, Numbers do
        if tonumber(LineArray[a])==nil then ultraschall.AddErrorMessage("SplitMediaItems_Position","trackstring", "must be valid trackstring", -2) return false end
        if MediaTrackNumber==tonumber(LineArray[a]) then
          count=count+1 
          ReturnMediaItemArray[count]=reaper.SplitMediaItem(MediaItem, position)
          if crossfade==false then 
              oldfade=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEOUTLEN_AUTO")
            oldlength=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
            reaper.SetMediaItemInfo_Value(MediaItem, "D_LENGTH", oldlength-oldfade)
          end
        end
       end
    end
  end
  return true, ReturnMediaItemArray
end

function ultraschall.SplitItemsAtPositionFromArray(position, MediaItemArray, crossfade)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitItemsAtPositionFromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemArray = ultraschall.SplitItemsAtPositionFromArray(number position, array MediaItemArray, boolean crossfade)</functioncall>
  <description>
    Splits items in MediaItemArray at position, in the tracks given by trackstring.
    If auto-crossfade is set in the Reaper-preferences, crossfade turns it on(true) or off(false).
    
    Returns false, in case of error.
  </description>
  <parameters>
    number position - the position in seconds
    array MediaItemArray - an array with the items, where split shall be applied to. No nil-entries allowed!
    boolean crossfade - true - automatic crossfade(if enabled) will be applied; false - automatic crossfade is off
  </parameters>
  <retvals>
    boolean retval - true - success, false - error
    array MediaItemArray - an array with the items on the right side of the split
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, split, edit, crossfade, mediaitemarray</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("SplitItemsAtPositionFromArray", "position", "Must be a number", -1) return false end
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("SplitItemsAtPositionFromArray", "MediaItemArray", "Must be a valid MediaItemArray", -2) return false end
  if type(crossfade)~="boolean" then ultraschall.AddErrorMessage("SplitItemsAtPositionFromArray", "crossfade", "Must be a boolean", -3) return false end

  local ReturnMediaItemArray={}
  local count=1
  while MediaItemArray[count]~=nil do
    ReturnMediaItemArray[count]=reaper.SplitMediaItem(MediaItemArray[count], position)
    if crossfade==false then 
      oldfade=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_FADEOUTLEN_AUTO")
      oldlength=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH")
      reaper.SetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH", oldlength-oldfade)
    end
    count=count+1
  end
  return true, ReturnMediaItemArray
end



function ultraschall.DeleteMediaItem(MediaItemObject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMediaItem</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string MediaItemStateChunk = ultraschall.DeleteMediaItem(MediaItem MediaItem)</functioncall>
  <description>
    deletes a MediaItem. Returns true, in case of success, false in case of error.
    
    returns the MediaItemStateChunk of the deleted MediaItem as well, so you can do additional processing with a deleted item.
  
    returns false in case of an error
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem to be deleted
  </parameters>
  <retvals>
    boolean retval - true, delete was successful; false was unsuccessful
    string MediaItemStateChunk - the StateChunk of the deleted MediaItem
                               - the statechunk contains an additional entry "ULTRASCHALL_TRACKNUMBER" which holds the tracknumber, in which the deleted MediaItem was located
  </retvals>
  <chapter_context>
    MediaItem Management
    Delete
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, delete</tags>
</US_DocBloc>
]]
    if reaper.ValidatePtr2(0, MediaItemObject, "MediaItem*")==false then ultraschall.AddErrorMessage("DeleteMediaItem","MediaItem", "must be a MediaItem", -1) return false end
    local MediaTrack=reaper.GetMediaItemTrack(MediaItemObject)
    local _temp, StateChunk=reaper.GetItemStateChunk(MediaItemObject, "", false)
    StateChunk = ultraschall.SetItemUSTrackNumber_StateChunk(StateChunk, math.floor(reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")))
    return reaper.DeleteTrackMediaItem(MediaTrack, MediaItemObject), StateChunk
end


function ultraschall.DeleteMediaItemsFromArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMediaItemsFromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemArray = ultraschall.DeleteMediaItemsFromArray(array MediaItemArray)</functioncall>
  <description>
    deletes the MediaItems from MediaItemArray. Returns true, in case of success, false in case of error.
    In addition, it returns a MediaItemStateChunkArray, that contains the statechunks of all deleted MediaItems
    
    returns false in case of an error
  </description>
  <parameters>
    array MediaItemArray - a array with MediaItem-objects to delete; no nil entries allowed
  </parameters>
  <retvals>
    boolean retval - true, delete was successful; false was unsuccessful
    array MediaItemStateChunkArray - and array with all statechunks of all deleted MediaItems; 
                                   - each statechunk contains an additional entry "ULTRASCHALL_TRACKNUMBER" which holds the tracknumber, in which the deleted MediaItem was located
  </retvals>
  <chapter_context>
    MediaItem Management
    Delete
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, delete</tags>
</US_DocBloc>
]]  
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("DeleteMediaItemsFromArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return false end
  local count=1
  local MediaItemStateChunkArray={}
  local hula
  while MediaItemArray[count]~=nil do
    hula, MediaItemStateChunkArray[count]=ultraschall.DeleteMediaItem(MediaItemArray[count])
    count=count+1
  end
  return true, MediaItemStateChunkArray
end


function ultraschall.DeleteMediaItems_Position(position, trackstring)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMediaItems_Position</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemStateChunkArray = ultraschall.DeleteMediaItems_Position(number position, string trackstring)</functioncall>
  <description>
    Delete the MediaItems at given position, from the tracks as given by trackstring.
    returns, if deleting was successful and an array with all statechunks of all deleted MediaItems
    
    returns false in case of an error
  </description>
  <parameters>
    number position - the position in seconds
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    boolean retval - true, delete was successful; false was unsuccessful
    array MediaItemStateChunkArray - and array with all statechunks of all deleted MediaItems; 
                                   - each statechunk contains an additional entry "ULTRASCHALL_TRACKNUMBER" which holds the tracknumber, in which the deleted MediaItem was located
  </retvals>
  <chapter_context>
    MediaItem Management
    Delete
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, delete</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("DeleteMediaItems_Position", "position", "must be a number", -1) return false end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("DeleteMediaItems_Position", "trackstring", "must be a valid trackstring", -2) return false end
  
  local count=0
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("DeleteMediaItems_Position", "trackstring", "must be a valid trackstring", -3) return false end
  local Numbers, LineArray=ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local Anumber=reaper.CountMediaItems(0)
  local MediaItemStateChunkArray={}
  local _temp
  
  for i=Anumber-1, 0, -1 do
    local MediaItem=reaper.GetMediaItem(0, i)
    local Astart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    local Alength=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItem)
    local MediaTrackNumber=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
    local Aend=Astart+Alength
    if position>=Astart and position<=Aend then
       for a=1, Numbers do
        if tonumber(LineArray[a])==nil then return false end
        if MediaTrackNumber==tonumber(LineArray[a]) then
          count=count+1 
          _temp, MediaItemStateChunkArray[a] = ultraschall.DeleteMediaItem(MediaItem)
        end
       end
    end
  end
  return true, MediaItemStateChunkArray
end

function ultraschall.GetAllMediaItemsBetween(startposition, endposition, trackstring, inside)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemsBetween</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(number startposition, number endposition, string trackstring, boolean inside)</functioncall>
  <description>
    Gets all MediaItems between startposition and endposition from the tracks as given by trackstring. 
    Set inside to true to get only items, that are fully within the start and endposition, set it to false, if you also want items, that are just partially inside(end or just the beginning of the item).
    
    Returns the number of items, an array with all the MediaItems and an array with all the MediaItemStateChunks of the items, as used by functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    The statechunks include a new element "ULTRASCHALL_TRACKNUMBER", which contains the tracknumber of where the item originally was in; important, if you delete the items as you'll otherwise loose this information!
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - startposition in seconds
    number endposition - endposition in seconds
    string trackstring - the tracknumbers, separated by a comma
    boolean inside - true, only items that are completely within selection; false, include items that are partially within selection
  </parameters>
  <retvals>
    integer count - the number of found items
    array MediaItemArray - an array with all the found MediaItems
    array MediaItemStateChunkArray - an array with the MediaItemStateChunks, that can be used to create new items with <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selection, position, statechunk, rppxml</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("GetAllMediaItemsBetween", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("GetAllMediaItemsBetween", "endposition", "must be a number", -2) return -1 end
  
  if startposition>endposition then ultraschall.AddErrorMessage("GetAllMediaItemsBetween", "endposition", "must be bigger than startposition", -3) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetAllMediaItemsBetween", "trackstring", "must be a valid trackstring", -4) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("GetAllMediaItemsBetween", "inside", "must be a boolean", -5) return -1 end
    
  local MediaItemArray={}
  local MediaItemStateChunkArray={}
  local count=0
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  local Numbers, LineArray=ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local Anumber=reaper.CountMediaItems(0)
  local temp
  for i=0,Anumber-1 do
    local MediaItem=reaper.GetMediaItem(0, i)
    local Astart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    local Alength=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItem)
    local MediaTrackNumber=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
    local Aend=Astart+Alength
    if inside==true and Astart>=startposition and 
        Astart<=endposition  and
        Aend>=startposition and
        Aend<=endposition then
        for a=1, Numbers do
          if tonumber(LineArray[a])==nil then return -1 end
          if MediaTrackNumber==tonumber(LineArray[a]) then
            count=count+1 
            MediaItemArray[count]=MediaItem
            temp,MediaItemStateChunkArray[count] = reaper.GetItemStateChunk(MediaItem, "", true)
            local tempMediaTrack=reaper.GetMediaItemTrack(MediaItem)
            local Tnumber=reaper.GetMediaTrackInfo_Value(tempMediaTrack, "IP_TRACKNUMBER")
            if MediaItemStateChunkArray[count]~=nil then MediaItemStateChunkArray[count]="<ITEM\nULTRASCHALL_TRACKNUMBER "..math.floor(Tnumber).."\n"..MediaItemStateChunkArray[count]:match("<ITEM(.*)") end
          end
       end
    elseif inside==false then
      if (Astart>=startposition and Astart<=endposition) or
          (Aend>=startposition and Aend<=endposition) or
          (Astart<=startposition and Aend>=endposition) then
        for a=1, Numbers do
          if tonumber(LineArray[a])==nil then return -1 end
          if MediaTrackNumber==tonumber(LineArray[a]) then
            count=count+1 
            MediaItemArray[count]=MediaItem
            temp,MediaItemStateChunkArray[count]= reaper.GetItemStateChunk(MediaItem, "", true)
            local tempMediaTrack=reaper.GetMediaItemTrack(MediaItem)
            local Tnumber=reaper.GetMediaTrackInfo_Value(tempMediaTrack, "IP_TRACKNUMBER")
            MediaItemStateChunkArray[count]="<ITEM\nULTRASCHALL_TRACKNUMBER "..Tnumber..MediaItemStateChunkArray[count]:match("<ITEM(.*)")
          end
       end
      end 
    end
  end
  return count, MediaItemArray, MediaItemStateChunkArray

end


function ultraschall.MoveMediaItemsAfter_By(oldposition, changepositionby, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveMediaItemsAfter_By</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MoveMediaItemsAfter_By(number old_position, number change_position_by, string trackstring)</functioncall>
  <description>
    Moves all items after old_position by change_position_by-seconds. Affects only items, that begin after oldposition, so items that start before and end after old_position do not move.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    number oldposition - the position, from where the movement shall be applied to, in seconds
    number change_position_by - the change of the position in seconds; positive - toward the end of the project, negative - toward the beginning.
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, move, position</tags>
</US_DocBloc>
]]
  
  if type(oldposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsAfter_By", "old_position", "must be a number", -1) return false end
  if type(changepositionby)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsAfter_By", "changepositionby", "must be a number", -2) return false end
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("MoveMediaItemsAfter_By", "trackstring", "must be a valid trackstring", -3) return false end
  local A,MediaItem=ultraschall.GetAllMediaItemsBetween(oldposition,reaper.GetProjectLength(),trackstring,true)
  for i=1, A do
    local ItemStart=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_POSITION")
    local ItemEnd=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_LENGTH")
    local Takes=reaper.CountTakes(MediaItem[i])
    if ItemStart+changepositionby>=0 then reaper.SetMediaItemInfo_Value(MediaItem[i], "D_POSITION", ItemStart+changepositionby)
    elseif ItemStart+changepositionby<=0 then 
      if ItemEnd+changepositionby<0 then reaper.DeleteTrackMediaItem(reaper.GetMediaItem_Track(MediaItem[i]),MediaItem[i]) --reaper.MB("","",0)
      else 
        for k=0, Takes-1 do
          local Offset=reaper.GetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS")
          reaper.SetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS", Offset-changepositionby)
        end
        reaper.SetMediaItemInfo_Value(MediaItem[i], "D_LENGTH", ItemEnd+changepositionby)
      end
    end
  end
  return true
end

--A=ultraschall.MoveMediaItemsAfter_By(reaper.GetCursorPosition(),-1,"1")

function ultraschall.MoveMediaItemsBefore_By(oldposition, changepositionby, trackstring)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveMediaItemsBefore_By</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MoveMediaItemsBefore_By(number old_position, number change_position_by, string trackstring)</functioncall>
  <description>
    Moves all items before old_position by change_position_by-seconds. Affects only items, that end before oldposition, so items that start before and end after old_position do not move.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    number oldposition - the position, from where the movement shall be applied to, in seconds
    number change_position_by - the change of the position in seconds; positive - toward the end of the project, negative - toward the beginning.
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, move, position</tags>
</US_DocBloc>
]]
  
  if type(oldposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsBefore_By", "old_position", "Must be a number.", -1) return false end
  if type(changepositionby)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsBefore_By", "change_position_by", "Must be a number.", -2) return false end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("MoveMediaItemsBefore_By", "trackstring", "Must be a valid trackstring.", -3) return false end
  
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then ultraschall.AddErrorMessage("MoveMediaItemsBefore_By", "trackstring", "Must be a valid trackstring.", -3) return false end
  local A,MediaItem=ultraschall.GetAllMediaItemsBetween(0,oldposition,trackstring,true)
  for i=1, A do
    local ItemStart=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_POSITION")
    local ItemEnd=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_LENGTH")
    local Takes=reaper.CountTakes(MediaItem[i])
    if ItemStart+changepositionby>=0 then reaper.SetMediaItemInfo_Value(MediaItem[i], "D_POSITION", ItemStart+changepositionby)
    elseif ItemStart+changepositionby<=0 then 
      if ItemEnd+changepositionby<0 then reaper.DeleteTrackMediaItem(reaper.GetMediaItem_Track(MediaItem[i]),MediaItem[i]) --reaper.MB("","",0)
      else 
        for k=0, Takes-1 do
          local Offset=reaper.GetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS")
          reaper.SetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS", Offset-changepositionby)
        end
        reaper.SetMediaItemInfo_Value(MediaItem[i], "D_LENGTH", ItemEnd+changepositionby)
      end
    end
  end
  return true
end

--A=ultraschall.MoveMediaItemsBefore_By(1,1,"1")

function ultraschall.MoveMediaItemsBetween_To(startposition, endposition, newposition, trackstring, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveMediaItemsBetween_To</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MoveMediaItemsBetween_To(number startposition, number endposition, number newposition, string trackstring, boolean inside)</functioncall>
  <description>
    Moves the items between sectionstart and sectionend to newposition, within the tracks given by trackstring.
    If inside is set to true, only items completely within the section are moved; if set to false, also items are affected, that are just partially within the section.
    
    Items, that start after sectionstart, and therefore have an offset, will be moved to newposition+their offset. Keep that in mind.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    number startposition - begin of the item-selection in seconds
    number endposition - end of the item-selection in seconds
    number newposition - new position in seconds
    string trackstring - the tracknumbers, separated by a ,
    boolean inside - true, only items completely within the section; false, also items partially within the section
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, move, position</tags>
</US_DocBloc>
]]
-- sectionstart, sectionend, newposition, trackstring, inside
  
  if type(startposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "sectionstart", "Must be a number.", -1) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "sectionend", "Must be a number.", -2) return false end
  if type(newposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "newposition", "Must be a number.", -3) return false end
  if sectionend<sectionstart then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "sectionend", "Must be bigger than sectionstart.", -4) return false end
  if ultraschall.IsValidTrackString(trackstring) then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "trackstring", "Must be a valid trackstring.", -5) return false end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("MoveMediaItemsBetween_To", "inside", "Must be a boolean.", -6) return false end  

  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return false end
  local A,MediaItem=ultraschall.GetAllMediaItemsBetween(sectionstart,sectionend,trackstring,inside)
  for i=1, A do
    local ItemStart=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_POSITION")
    local ItemEnd=reaper.GetMediaItemInfo_Value(MediaItem[i], "D_LENGTH")
    local Takes=reaper.CountTakes(MediaItem[i])
    if ItemStart+newposition>=0 then reaper.SetMediaItemInfo_Value(MediaItem[i], "D_POSITION", ItemStart+newposition)
    elseif ItemStart+newposition<=0 then 
      if ItemEnd+newposition<0 then reaper.DeleteTrackMediaItem(reaper.GetMediaItem_Track(MediaItem[i]),MediaItem[i]) --reaper.MB("","",0)
      else 
        for k=0, Takes-1 do
          local Offset=reaper.GetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS")
          reaper.SetMediaItemTakeInfo_Value(reaper.GetMediaItemTake(MediaItem[i], k), "D_STARTOFFS", Offset-newposition)
        end
        reaper.SetMediaItemInfo_Value(MediaItem[i], "D_LENGTH", ItemEnd+newposition)
      end
    end
  end
  return true
end

--A=ultraschall.MoveMediaItemsBetween_To(1, 3, 100, "Ã¶", false)



function ultraschall.ChangeLengthOfMediaItems_FromArray(MediaItemArray, newlength)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeLengthOfMediaItems_FromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ChangeLengthOfMediaItems_FromArray(array MediaItemArray, number newlength)</functioncall>
  <description>
    Changes the length of the MediaItems in MediaItemArray to newlength.
    They will all be set to the new length, regardless of their old length. If you want to change the length of the items not >to< newlength, but >by< newlength, use <a href"#ChangeDeltaLengthOfMediaItems_FromArray">ChangeDeltaLengthOfMediaItems_FromArray</a> instead.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    array MediaItemArray - an array with items to be changed. No nil entries allowed!
    number newlength - the new length of the items in seconds
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, length</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ChangeLengthOfMediaItems_FromArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return false end
  if type(newlength)~="number" then ultraschall.AddErrorMessage("ChangeLengthOfMediaItems_FromArray", "newlength", "must be a number", -2) return false end
  
  local count=1
  while MediaItemArray[count]~=nil do
    reaper.SetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH", newlength)
    count=count+1
  end
  return true
end


function ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(MediaItemArray, deltalength)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeDeltaLengthOfMediaItems_FromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(array MediaItemArray, number deltalength)</functioncall>
  <description>
    Changes the length of the MediaItems in MediaItemArray by deltalength.
    If you want to change the length of the items not >by< deltalength, but >to< deltalength, use <a href"#ChangeLengthOfMediaItems_FromArray">ChangeLengthOfMediaItems_FromArray</a> instead.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    array MediaItemArray - an array with items to be changed. No nil entries allowed!
    number deltalength - the change of the length of the items in seconds, positive value - longer, negative value - shorter
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, length</tags>
</US_DocBloc>
]]

  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ChangeDeltaLengthOfMediaItems_FromArray", "MediaItemArray", "Only array with MediaItemObjects as entries is allowed.", -1) return false end
  if type(deltalength)~="number" then ultraschall.AddErrorMessage("ChangeDeltaLengthOfMediaItems_FromArray", "deltalength", "Must be a number in seconds.", -2) return false end
  local count=1
  local ItemLength
  while MediaItemArray[count]~=nil do
    ItemLength=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH")
    reaper.SetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH", ItemLength+deltalength)
    count=count+1
  end    
  return true
end

function ultraschall.ChangeOffsetOfMediaItems_FromArray(MediaItemArray, newoffset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeOffsetOfMediaItems_FromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ChangeOffsetOfMediaItems_FromArray(array MediaItemArray, number newoffset)</functioncall>
  <description>
    Changes the audio-offset of the MediaItems in MediaItemArray to newoffset.
    It affects all(!) takes that the MediaItems has.
    If you want to change the offset of the items not >to< newoffset, but >by< newoffset, use <a href"#ChangeDeltaOffsetOfMediaItems_FromArray">ChangeDeltaOffsetOfMediaItems_FromArray</a> instead.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    array MediaItemArray - an array with items to be changed. No nil entries allowed!
    number newoffset - the new offset of the items in seconds
  </parameters>
  <retvals>
    boolean retval - true, in case of success; false, in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, offset</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ChangeOffsetOfMediaItems_FromArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return false end
  if type(newoffset)~="number" then ultraschall.AddErrorMessage("ChangeOffsetOfMediaItems_FromArray", "newoffset", "must be a number", -2) return false end
  
  local count=1
  local ItemLength
  local MediaItem_Take
  while MediaItemArray[count]~=nil do
    ItemLength=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_SNAPOFFSET")
    for i=0, reaper.CountTakes(MediaItemArray[count])-1 do
      MediaItem_Take=reaper.GetMediaItemTake(MediaItemArray[count], i)
      reaper.SetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS", newoffset)
    end
    count=count+1
  end    
  return true
end

function ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(MediaItemArray, deltaoffset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeDeltaOffsetOfMediaItems_FromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ChangeDeltaOffsetOfMediaItems_FromArray(array MediaItemArray, number deltaoffset)</functioncall>
  <description>
    Changes the audio-offset of the MediaItems in MediaItemArray by deltaoffset.
    It affects all(!) takes of the MediaItems have.
    If you want to change the offset of the items not >by< deltaoffset, but >to< deltaoffset, use <a href"#ChangeOffsetOfMediaItems_FromArray">ChangeOffsetOfMediaItems_FromArray</a> instead.
    
    Returns false in case of failure, true in case of success.
  </description>
  <parameters>
    array MediaItemArray - an array with items to be changed. No nil entries allowed!
    number newoffset - the new offset of the items in seconds
  </parameters>
  <retvals>
    boolean retval - true in case of success; false in case of failure
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, offset</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ChangeDeltaOffsetOfMediaItems_FromArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return false end
  if type(delta)~="number" then ultraschall.AddErrorMessage("ChangeDeltaOffsetOfMediaItems_FromArray", "delta", "must be a number", -2) return false end
  
  local count=1
  local ItemLength, MediaItem_Take, ItemTakeOffset
  while MediaItemArray[count]~=nil do
    ItemLength=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_SNAPOFFSET")
    for i=0, reaper.CountTakes(MediaItemArray[count])-1 do
      MediaItem_Take=reaper.GetMediaItemTake(MediaItem[count], i)
      ItemTakeOffset=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS")
      reaper.SetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS", ItemTakeOffset+deltaoffset)
    end
    count=count+1
  end
  return true    
end


function ultraschall.SectionCut(startposition, endposition, trackstring, add_to_clipboard)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SectionCut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items, array MediaItemArray_StateChunk = ultraschall.SectionCut(number startposition, number endposition, string trackstring, boolean add_to_clipboard)</functioncall>
  <description>
    Cuts out all items between startposition and endposition in the tracks given by trackstring.
    
    Returns number of cut items as well as an array with the mediaitem-statechunks, which can be used with functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - the startposition of the section in seconds
    number endposition - the endposition of the section in seconds
    string trackstring - the tracknumbers, separated by ,
    boolean add_to_clipboard - true, puts the cut items into the clipboard; false, don't put into the clipboard
  </parameters>
  <retvals>
    integer number_items - the number of cut items
    array MediaItemArray_StateChunk - an array with the mediaitem-states of the cut items.
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, edit, section, cut, clipboard</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("SectionCut", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("SectionCut", "endposition", "must be a number", -2) return -1 end
  if endposition<startposition then ultraschall.AddErrorMessage("SectionCut", "endposition", "must be bigger than startposition", -3)  return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("SectionCut", "trackstring", "must be a valid trackstring", -4)  return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("SectionCut", "add_to_clipboard", "must be a boolean", -5) return -1 end  

  -- manage duplicates in trackstring
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)

  -- do the splitting, selecting and deleting of the items inbetween start and endposition
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring, false)
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring,false)
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(startposition,endposition,trackstring,true)

  -- put the items into the clipboard  
  if add_to_clipboard==true then ultraschall.PutMediaItemsToClipboard_MediaItemArray(CC) end

  local D=ultraschall.DeleteMediaItemsFromArray(CC)
  return C, CCC
end

--H=reaper.GetCursorPosition()
--reaper.UpdateArrange()

function ultraschall.SectionCut_Inverse(startposition, endposition, trackstring, add_to_clipboard)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SectionCut_Inverse</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items_beforestart, array MediaItemArray_StateChunk_beforestart, integer number_items_afterend, array MediaItemArray_StateChunk_afterend = ultraschall.SectionCut_Inverse(number startposition, number endposition, string trackstring, boolean add_to_clipboard)</functioncall>
  <description>
    Cuts out all items before(!) startposition and after(!) endposition in the tracks given by trackstring; it keeps all items inbetween startposition and endposition.
    
    Returns number of cut items as well as an array with the mediaitem-statechunks, which can be used with functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.

    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - the startposition of the section in seconds
    number endposition - the endposition of the section in seconds
    string trackstring - the tracknumbers, separated by ,
    boolean add_to_clipboard - true, puts the cut items into the clipboard; false, don't put into the clipboard
  </parameters>
  <retvals>
    integer number_items_beforestart - the number of cut items before startposition
    array MediaItemArray_StateChunk_beforestart - an array with the mediaitem-states of the cut items before startposition
    integer number_items_afterend - the number of cut items after endposition
    array MediaItemArray_StateChunk_afterend - an array with the mediaitem-states of the cut items after endposition
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, edit, section, inverse, cut</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("SectionCut_Inverse", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("SectionCut_Inverse", "endposition", "must be a number", -2) return -1 end
  if endposition<startposition then ultraschall.AddErrorMessage("SectionCut_Inverse", "endposition", "must be bigger than startposition", -3)  return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("SectionCut_Inverse", "trackstring", "must be a valid trackstring", -4)  return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("SectionCut_Inverse", "add_to_clipboard", "must be a boolean", -5) return -1 end  
  
  -- remove duplicate tracks from trackstring
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  
  -- do the splitting, selection of all mediaitems before first and after last split and delete them
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring, false)
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring, false) -- Buggy: needs to take care of autocrossfade!!
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(0,startposition,trackstring, true)
  local C2,CC2,CCC2=ultraschall.GetAllMediaItemsBetween(endposition,reaper.GetProjectLength(),trackstring, true)
  
  -- put the items into the clipboard  
  
  if add_to_clipboard==true then 
    local COMBIC, COMBIC2=ultraschall.ConcatIntegerIndexedTables(CC, CC2)
    ultraschall.PutMediaItemsToClipboard_MediaItemArray(COMBIC2) 
  end
  
  local D=ultraschall.DeleteMediaItemsFromArray(CC)
  local D2=ultraschall.DeleteMediaItemsFromArray(CC2)
  
  -- return removed items
  return C,CCC,C2,CCC2
end


function ultraschall.RippleCut(startposition, endposition, trackstring, moveenvelopepoints, add_to_clipboard, movemarkers)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut</slug>
  <requires>
    Ultraschall=5.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items, array MediaItemArray_StateChunk, array altered_markers, array altered_regions = ultraschall.RippleCut(number startposition, number endposition, string trackstring, boolean moveenvelopepoints, boolean add_to_clipboard, boolean movemarkers)</functioncall>
  <description>
    Cuts out all items between startposition and endposition in the tracks given by trackstring. After cut, it moves the remaining items after(!) endposition toward projectstart, by the difference between start and endposition.
    
    Returns number of cut items as well as an array with the mediaitem-statechunks, which can be used with functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
  
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - the startposition of the section in seconds
    number endposition - the endposition of the section in seconds
    string trackstring - the tracknumbers, separated by ,
    boolean moveenvelopepoints - moves envelopepoints, if existing, as well
    boolean add_to_clipboard - true, puts the cut items into the clipboard; false, don't put into the clipboard
    boolean movemarkers - true or nil, move markers; false, don't move markers
  </parameters>
  <retvals>
    integer number_items - the number of cut items
    array MediaItemArray_StateChunk - an array with the mediaitem-states of the cut items
    array altered_markers - an array with all moved and deleted markers
                           - affected_markers[1]="deleted" or "moved"
                           - affected_markers[2]=index
                           - affected_markers[3]=old_position
                           - affected_markers[4]=name
                           - affected_markers[5]=shownmarker
                           - affected_markers[6]=color
    array altered_regions - the regions that were altered:
                          -   altered_regions_array[index_of_region][0] - old startposition
                          -   altered_regions_array[index_of_region][1] - old endposition
                          -   altered_regions_array[index_of_region][2] - name
                          -   altered_regions_array[index_of_region][3] - old indexnumber of the region within all markers in the project
                          -   altered_regions_array[index_of_region][4] - the shown index-number
                          -   altered_regions_array[index_of_region][5] - the color of the region
                          -   altered_regions_array[index_of_region][6] - the change that was applied to this region
                          -   altered_regions_array[index_of_region][7] - the new startposition
                          -   altered_regions_array[index_of_region][8] - the new endposition
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, edit, ripple, clipboard</tags>
</US_DocBloc>
]]
  --trackstring=ultraschall.CreateTrackString(1,reaper.CountTracks(),1)
  --returns the number of deleted items as well as a table with the ItemStateChunks of all deleted Items  

  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut", "endposition", "must be a number", -2) return -1 end
  if trackstring~="" and ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleCut", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "add_to_clipboard", "must be a boolean", -4) return -1 end  
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "moveenvelopepoints", "must be a boolean", -5) return -1 end
  if movemarkers~=nil and type(movemarkers)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "movemarkers", "must be a boolean", -7) return -1 end
  if movemarkers==nil then movemarkers=true end
  local L,trackstring,A2,A3=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  local count, individual_tracks = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("RippleCut", "trackstring", "must be a valid trackstring", -6) return -1 end

  local delta=endposition-startposition
  local crossfade_value=reaper.SNM_GetIntConfigVar("splitautoxfade", -99)
  
  if crossfade_value&1==1 then
    --print2(crossfade_value&1)
    --print2(reaper.SNM_SetIntConfigVar("splitautoxfade", crossfade_value-1))
    reaper.SNM_SetIntConfigVar("splitautoxfade", crossfade_value-1)
  end
  local oldvalcrossfade=reaper.SNM_GetDoubleConfigVar("defsplitxfadelen", -100000)
  local deffadelen=reaper.SNM_GetDoubleConfigVar("defsplitxfadelen", -100000)
  
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", 0)
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", 0.1)
  
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring, false)
  
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring, false)  
  
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", oldvalcrossfade)
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", deffadelen)

  --print2(startposition, endposition)
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(startposition, endposition, trackstring,true)

  -- put the items into the clipboard  
  if #CC>0 then
    if add_to_clipboard==true then ultraschall.PutMediaItemsToClipboard_MediaItemArray(CC) end  
    ultraschall.DeleteMediaItemsFromArray(CC)  
  end
  
  if moveenvelopepoints==true then
    for i=1, #individual_tracks do
      local MediaTrack=reaper.GetTrack(0,individual_tracks[i]-1)
      ultraschall.DeleteTrackEnvelopePointsBetween(startposition, endposition, MediaTrack)
      ultraschall.MoveTrackEnvelopePointsBy(endposition, reaper.GetProjectLength(), -delta, MediaTrack, false) 
    end
  end
  local markers={}
  local regions={}
  
  if movemarkers==true then
    -- move markers
    for i=reaper.CountProjectMarkers(0)-1, 0, -1 do
      local retval, isrgn, pos, rgnend, name, shownmarker, color = reaper.EnumProjectMarkers3(0, i)
      if pos>=startposition and pos<endposition and isrgn==false then 
        reaper.DeleteProjectMarkerByIndex(0, i) 
        markers[#markers+1]={"deleted", retval, pos, name, shownmarker, color}
      end
    end
    for i=0, reaper.CountProjectMarkers(0) do
      local retval, isrgn, pos, rgnend, name, shownmarker, color = reaper.EnumProjectMarkers3(0, i)
      if pos>endposition then
        if isrgn==false then
          reaper.SetProjectMarkerByIndex2(0, i, isrgn, pos-delta, rgnend, shownmarker, name, color, 0)
          markers[#markers+1]={"moved", retval, pos, name, shownmarker, color}
        end
      end
    end
    -- move regions
    local were_regions_altered, number_of_altered_regions, altered_regions = ultraschall.RippleCut_Regions(startposition, endposition)
    regions=altered_regions
  end
  
  ultraschall.MoveMediaItemsAfter_By(endposition-0.00000000001, -delta, trackstring)

  --if crossfade_value&1==1 then
  reaper.SNM_SetIntConfigVar("splitautoxfade", crossfade_value)
  --end
  return C,CCC, markers, regions
end

--A,B=ultraschall.RippleCut(1,2,"1,2,3",true,true)


function ultraschall.RippleCut_Reverse(startposition, endposition, trackstring, moveenvelopepoints, add_to_clipboard, movemarkers)
  --trackstring=ultraschall.CreateTrackString(1,reaper.CountTracks(),1)
  --returns the number of deleted items as well as a table with the ItemStateChunks of all deleted Items  
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut_Reverse</slug>
  <requires>
    Ultraschall=5.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items, array MediaItemArray_StateChunk, array altered_markers, array altered_regions = ultraschall.RippleCut_Reverse(number startposition, number endposition, string trackstring, boolean moveenvelopepoints, boolean add_to_clipboard, optional boolean movemarkers)</functioncall>
  <description>
    Cuts out all items between startposition and endposition in the tracks given by trackstring. 
    After cut, it moves the remaining items before(!) startposition toward projectend, by the difference between start and endposition.
    
    Returns number of cut items as well as an array with the mediaitem-statechunks, which can be used with functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - the startposition of the section in seconds
    number endposition - the endposition of the section in seconds
    string trackstring - the tracknumbers, separated by ,
    boolean moveenvelopepoints - moves envelopepoints, if existing, as well
    boolean add_to_clipboard - true, puts the cut items into the clipboard; false, don't put into the clipboard
    optional boolean movemarkers - true or nil, moves markers from before start-position towards end-position; false, don't move markers
  </parameters>
  <retvals>
    integer number_items - the number of cut items
    array MediaItemArray_StateChunk - an array with the mediaitem-states of the cut items
    array altered_markers - an array with all moved and deleted markers
                           - affected_markers[1]="deleted" or "moved"
                           - affected_markers[2]=index
                           - affected_markers[3]=old_position
                           - affected_markers[4]=name
                           - affected_markers[5]=shownmarker
                           - affected_markers[6]=color
    array altered_regions - the regions that were altered:
                          -   altered_regions_array[index_of_region][0] - old startposition
                          -   altered_regions_array[index_of_region][1] - old endposition
                          -   altered_regions_array[index_of_region][2] - name
                          -   altered_regions_array[index_of_region][3] - old indexnumber of the region within all markers in the project
                          -   altered_regions_array[index_of_region][4] - the shown index-number
                          -   altered_regions_array[index_of_region][5] - the color of the region
                          -   altered_regions_array[index_of_region][6] - the change that was applied to this region
                          -   altered_regions_array[index_of_region][7] - the new startposition
                          -   altered_regions_array[index_of_region][8] - the new endposition
  </retvals>
  <chapter_context>
    MediaItem Management
    Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, edit, ripple, reverse, clipboard</tags>
</US_DocBloc>
]]
-- might be buggy with markers
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Reverse", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Reverse", "endposition", "must be a number", -2) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleCut_Reverse", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("RippleCut_Reverse", "add_to_clipboard", "must be a boolean", -4) return -1 end
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleCut_Reverse", "moveenvelopepoints", "must be a boolean", -5) return -1 end
  if movemarkers~=nil and type(movemarkers)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "movemarkers", "must be a boolean", -7) return -1 end
  if movemarkers==nil then movemarkers=true end
  
  local L,trackstring,A2,A3=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  local count, individual_tracks = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  local delta=endposition-startposition
  
  local crossfade_value=reaper.SNM_GetIntConfigVar("splitautoxfade", -99)
  
  if crossfade_value&1==1 then
    --print2(crossfade_value&1)
    --print2(reaper.SNM_SetIntConfigVar("splitautoxfade", crossfade_value-1))
    reaper.SNM_SetIntConfigVar("splitautoxfade", crossfade_value-1)
  end
  local oldvalcrossfade=reaper.SNM_GetDoubleConfigVar("defsplitxfadelen", -100000)
  local deffadelen=reaper.SNM_GetDoubleConfigVar("defsplitxfadelen", -100000)
  
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", 0)
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", 0.1)
  
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring, false)
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring, false)
  
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", oldvalcrossfade)
  reaper.SNM_SetDoubleConfigVar("defsplitxfadelen", deffadelen)  
  
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(startposition,endposition,trackstring,true)

  -- put the items into the clipboard  
  if add_to_clipboard==true then ultraschall.PutMediaItemsToClipboard_MediaItemArray(CC) end

  local D=ultraschall.DeleteMediaItemsFromArray(CC) 
  if moveenvelopepoints==true then
    for i=1, #individual_tracks do
      local MediaTrack=reaper.GetTrack(0,individual_tracks[i]-1)
      ultraschall.DeleteTrackEnvelopePointsBetween(startposition, endposition, MediaTrack)
      ultraschall.MoveTrackEnvelopePointsBy(0, startposition, delta, MediaTrack, false) 
    end
  end
  
  --[[
  if movemarkers==true then
    ultraschall.MoveMarkersBy(0, endposition, delta, true)
  end
  --]]
  local markers={}
  local regions={}
  if movemarkers==true then    
    -- move markers
    for i=reaper.CountProjectMarkers(0)-1, 0, -1 do
      local retval, isrgn, pos, rgnend, name, shownmarker, color = reaper.EnumProjectMarkers3(0, i)
      if pos>=startposition and pos<endposition and isrgn==false then 
        reaper.DeleteProjectMarkerByIndex(0, i) 
        markers[#markers+1]={"deleted", retval, pos, name, shownmarker, color}
      end
    end
    for i=0, reaper.CountProjectMarkers(0) do
      local retval, isrgn, pos, rgnend, name, shownmarker, color = reaper.EnumProjectMarkers3(0, i)
      if pos<startposition then
        if isrgn==false then
          reaper.SetProjectMarkerByIndex2(0, i, isrgn, pos+delta, rgnend, shownmarker, name, color, 0)
          markers[#markers+1]={"moved", retval, pos, name, shownmarker, color}
        end
      end
    end
    -- move regions
    local were_regions_altered, number_of_altered_regions, altered_regions = ultraschall.RippleCut_Regions_Reverse(startposition, endposition)
    regions=altered_regions
  end

  ultraschall.MoveMediaItemsBefore_By(endposition+0.00000000001, delta, trackstring)  
  return C,CCC, markers, regions
end


function ultraschall.InsertMediaItem_MediaItem(position, MediaItem, MediaTrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItem_MediaItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, MediaItem MediaItem, number startposition, number endposition, number length = ultraschall.InsertMediaItem_MediaItem(number position, MediaItem MediaItem, MediaTrack MediaTrack)</functioncall>
  <description>
    Inserts MediaItem in MediaTrack at position. Returns the newly created(or better: inserted) MediaItem as well as startposition, endposition and length of the inserted item.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    MediaItem MediaItem - the MediaItem that shall be inserted into a track
    MediaTrack MediaTrack - the track, where the item shall be inserted to
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    MediaItem MediaItem - the newly created MediaItem
    number startposition - the startposition of the inserted MediaItem in seconds
    number endposition - the endposition of the inserted MediaItem in seconds
    number length - the length of the inserted MediaItem in seconds
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItem_MediaItem","position", "must be a number", -1) return -1 end
  if reaper.GetItemStateChunk(MediaItem, "", false)==false then ultraschall.AddErrorMessage("InsertMediaItem_MediaItem","MediaItem", "must be a MediaItem", -2) return -1 end
  if reaper.GetTrackStateChunk(MediaTrack, "", false)==false then ultraschall.AddErrorMessage("InsertMediaItem_MediaItem","MediaTrack", "must be a MediaTrack", -3) return -1 end
  local MediaItemNew=reaper.AddMediaItemToTrack(MediaTrack)
  local Aretval, Astr = reaper.GetItemStateChunk(MediaItem, "", true)
  Astr=Astr:match(".-POSITION ")..position..Astr:match(".-POSITION.-(%c.*)")
  local Aboolean = reaper.SetItemStateChunk(MediaItemNew, Astr, true)
  local start_position=reaper.GetMediaItemInfo_Value(MediaItemNew, "D_POSITION")
  local length=reaper.GetMediaItemInfo_Value(MediaItemNew, "D_LENGTH")
  
  return 1,MediaItemNew, start_position, start_position+length, length
end

--C,CC=ultraschall.GetAllMediaItemsBetween(0,5,"1,2,3,4,5",false)
--MT=reaper.GetTrack(0,0)
--A0,A,AA,AAA,AAAA=ultraschall.InsertMediaItem_MediaItem(42,CC[1],MT)

function ultraschall.InsertMediaItem_MediaItemStateChunk(position, MediaItemStateChunk, MediaTrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItem_MediaItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, MediaItem MediaItem, number startposition, number endposition, number length = ultraschall.InsertMediaItem_MediaItemStateChunk(number position, string MediaItemStateChunk, MediaTrack MediaTrack)</functioncall>
  <description>
    Inserts a new MediaItem in MediaTrack at position. Uses a mediaitem-state-chunk as created by functions like <a href="#GetAllMediaItemsBetween">GetAllMediaItemsBetween</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.. Returns the newly created MediaItem.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    string MediaItemStatechunk - the Statechunk for the MediaItem, that shall be inserted into a track
    MediaTrack MediaTrack - the track, where the item shall be inserted to; nil, use the statechunk-entry ULTRASCHALL_TRACKNUMBER for the track instead.
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    MediaItem MediaItem - the newly created MediaItem
    number startposition - the startposition of the inserted MediaItem in seconds
    number endposition - the endposition of the inserted MediaItem in seconds
    number length - the length of the inserted MediaItem in seconds
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItem_MediaItemStateChunk","position", "must be a number", -1) return -1 end
  if ultraschall.IsValidMediaItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("InsertMediaItem_MediaItemStateChunk","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -2) return -1 end
  if MediaTrack~=nil and reaper.GetTrackStateChunk(MediaTrack, "", false)==false then ultraschall.AddErrorMessage("InsertMediaItem_MediaItem","MediaTrack", "must be a MediaTrack", -3) return -1 end
  if MediaTrack==nil and ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunk)==-1 then ultraschall.AddErrorMessage("InsertMediaItem_MediaItemStateChunk","MediaItemStateChunk", "contains no ULTRASCHALL_TRACKNUMBER entry, so I can't determine the original track", -4) return -1 end
  if MediaTrack==nil then MediaTrack=reaper.GetTrack(0,ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunk)-1) end

  local MediaItemNew=reaper.AddMediaItemToTrack(MediaTrack)
  local MediaItemStateChunk=MediaItemStateChunk:match(".-POSITION ")..position..MediaItemStateChunk:match(".-POSITION.-(%c.*)")
  local Aboolean = reaper.SetItemStateChunk(MediaItemNew, MediaItemStateChunk, true)
  local start_position=reaper.GetMediaItemInfo_Value(MediaItemNew, "D_POSITION")
  local length=reaper.GetMediaItemInfo_Value(MediaItemNew, "D_LENGTH")
    
  return 1, MediaItemNew, start_position, start_position+length, length
end


function ultraschall.InsertMediaItemArray(position, MediaItemArray, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray = ultraschall.InsertMediaItemArray(number position, array MediaItemArray, string trackstring)</functioncall>
  <description>
    Inserts the MediaItems from MediaItemArray at position into the tracks, as given by trackstring. 
    
    Returns the number of newly created items, as well as an array with the newly create MediaItems.
    Returns -1 in case of failure.
    
    Note: this inserts the items only in the tracks, where the original items came from. Items from track 1 will be included into track 1. Trackstring only helps to include or exclude the items from inclusion into certain tracks.
    If you have a MediaItemArray with items from track 1,2,3,4,5 and you give trackstring only the tracknumber for track 3 and 4 -> 3,4, then only the items, that were in tracks 3 and 4 originally, will be included, all the others will be ignored.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    array MediaItemArray - an array with the MediaItems to be inserted
    string trackstring - the numbers of the tracks, separated by a ,
  </parameters>
  <retvals>
    integer number_of_items - the number of MediaItems created
    array MediaItemArray - an array with the newly created MediaItems
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert</tags>
</US_DocBloc>
]]    
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItemArray","position", "must be a number", -1) return -1 end
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("InsertMediaItemArray","MediaItemArray", "must be a valid MediaItemArray", -2) return -1 end
  --if reaper.ValidatePtr(MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("InsertMediaItemArray","MediaTrack", "must be a valid MediaTrack-object", -3) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("InsertMediaItemArray","trackstring", "must be a valid trackstring", -3) return -1 end
  
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  local count=1
  local i,LL
  
  
  
  local NewMediaItemArray={}
  local _count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring) 
  local ItemStart=reaper.GetProjectLength()+1
  while MediaItemArray[count]~=nil do
    local ItemStart_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    if ItemStart>ItemStart_temp then ItemStart=ItemStart_temp end
    count=count+1
  end
  count=1
  while MediaItemArray[count]~=nil do
    local ItemStart_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItemArray[count])
    --nur einfÃ¼gen, wenn mediaitem aus nem Track stammt, der in trackstring vorkommt
    i=1
    while individual_values[i]~=nil do
      if reaper.GetTrack(0,individual_values[i]-1)==reaper.GetMediaItem_Track(MediaItemArray[count]) then 
        LL, NewMediaItemArray[count]=ultraschall.InsertMediaItem_MediaItem(position+(ItemStart_temp-ItemStart),MediaItemArray[count],MediaTrack)
      end
      i=i+1
    end
    count=count+1
  end  

  return count, NewMediaItemArray
end



function ultraschall.GetMediaItemStateChunksFromItems(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemStateChunksFromItems</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray_StateChunks = ultraschall.GetMediaItemStateChunksFromItems(array MediaItemArray)</functioncall>
  <description>
    Returns the MediaItem-StateChunks for all MediaItems in MediaItemArray. It returns the number of items as well as an array, with each entry one MediaItemStateChunk.
    
    StateChunks are used by the reaper-functions reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    array MediaItemArray - an array with the MediaItems you want the statechunks of
  </parameters>
  <retvals>
    integer number_of_items - the number of trackstatechunks, usually the same as MediaItems in MediaItemArray
    array MediaItemArray_StateChunks - an array with the StateChunks of the MediaItems in MediaItemArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, chunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("GetMediaItemStateChunksFromItems", "MediaItemArray", "must be a valid MediaItemArray", -1) return -1 end
  local count=1
  local L
  local MediaItemArray_StateChunk={}
  while MediaItemArray[count]~=nil do
    L, MediaItemArray_StateChunk[count]=reaper.GetItemStateChunk(MediaItemArray[count], "", true)
    count=count+1
  end
  return count-1, MediaItemArray_StateChunk
end


function ultraschall.RippleInsert(position, MediaItemArray, trackstring, moveenvelopepoints)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleInsert</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray, number endpos_inserted_items = ultraschall.RippleInsert(number position, array MediaItemArray, string trackstring, boolean moveenvelopepoints, boolean movemarkers)</functioncall>
  <description>
    It inserts the MediaItems from MediaItemArray at position into the tracks, as given by trackstring. It moves the items, that were there before, accordingly toward the end of the project.
    
    Returns the number of newly created items, as well as an array with the newly created MediaItems and the endposition of the last(projectposition) inserted item into the project.
    Returns -1 in case of failure.
    
    Note: this inserts the items only in the tracks, where the original items came from. Items from track 1 will be included into track 1. Trackstring only helps to include or exclude the items from inclusion into certain tracks.
    If you have a MediaItemArray with items from track 1,2,3,4,5 and you give trackstring only the tracknumber for track 3 and 4 -> 3,4, then only the items, that were in tracks 3 and 4 originally, will be included, all the others will be ignored.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    array MediaItemArray - an array with the MediaItems to be inserted
    string trackstring - the numbers of the tracks, separated by a ,
    boolean moveenvelopepoints - true, move the envelopepoints as well; false, keep the envelopepoints where they are
    boolean movemarkers - true, move markers as well; false, keep markers where they are
  </parameters>
  <retvals>
    integer number_of_items - the number of newly created items
    array MediaItemArray - an array with the newly created MediaItems
    number endpos_inserted_items - the endposition of the last newly inserted MediaItem
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert, ripple</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("RippleInsert", "startposition", "must be a number", -1) return -1 end
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("RippleInsert", "MediaItemArray", "must be a valid MediaItemArray", -2) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleInsert", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleInsert", "moveenvelopepoints", "must be a boolean", -4) return -1 end
  
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  --reaper.MB(trackstring,"",0)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("RippleInsert", "trackstring", "must be a valid trackstring", -6) return -1 end

-- local NumberOfItems
  local NewMediaItemArray={}
  local count=1
  local ItemStart=reaper.GetProjectLength()+1
  local ItemEnd=0
  local i
  local _count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  while MediaItemArray[count]~=nil do
    local ItemStart_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    local ItemEnd_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH")
    i=1
    while individual_values[i]~=nil do
      if reaper.GetTrack(0,individual_values[i]-1)==reaper.GetMediaItem_Track(MediaItemArray[count]) then 
        if ItemStart>ItemStart_temp then ItemStart=ItemStart_temp end
        if ItemEnd<ItemEnd_temp+ItemStart_temp then ItemEnd=ItemEnd_temp+ItemStart_temp end
      end
      i=i+1
    end
    count=count+1
  end
  
  --Create copy of the track-state-chunks
  local nums, MediaItemArray_Chunk=ultraschall.GetMediaItemStateChunksFromItems(MediaItemArray)
    
  local A,A2=ultraschall.SplitMediaItems_Position(position,trackstring,false)
--  reaper.MB(tostring(AA),"",0)

  if moveenvelopepoints==true then
    local CountTracks=reaper.CountTracks()
    for i=0, CountTracks-1 do
      for a=1,AAA do
        if tonumber(AA[a])==i+1 then
          local MediaTrack=reaper.GetTrack(0,i)
          retval = ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+(ItemEnd-ItemStart), ItemEnd-ItemStart, MediaTrack, true) 
        end
      end
    end
  end
  
  if movemarkers==true then
    ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+(ItemEnd-ItemStart), ItemEnd-ItemStart, true)
  end
  ultraschall.MoveMediaItemsAfter_By(position-0.000001, ItemEnd-ItemStart, trackstring)
  L,MediaItemArray=ultraschall.OnlyMediaItemsOfTracksInTrackstring(MediaItemArray, trackstring)
  count=1
  while MediaItemArray[count]~=nil do
    local Anumber=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    count=count+1
  end
    NumberOfItems, NewMediaItemArray=ultraschall.InsertMediaItemArray(position, MediaItemArray, trackstring)
  count=1
  while MediaItemArray[count]~=nil do
    local length=MediaItemArray_Chunk[count]:match("LENGTH (.-)%c")
    reaper.SetMediaItemInfo_Value(NewMediaItemArray[count], "D_LENGTH", length)
    count=count+1
  end
  return NumberOfItems, NewMediaItemArray, position+ItemEnd
end



function ultraschall.MoveMediaItems_FromArray(MediaItemArray, newposition)
-- changes position of all MediaItems in MediaItemArray to position
-- if there are more than one mediaitems, it retains the relative-position to each 
-- other, putting the earliest item as position and the rest later, in relation to the earliest item
--
-- MediaItemArray - array with all MediaItems that shall be affected. Must not 
--                    include nil-entries, as they'll be interpreted as end of array.
-- number newposition - new position of Items
--reaper.MB(type(MediaItemArray),"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveMediaItems_FromArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, number earliest_itemtime, number latest_itemtime = ultraschall.MoveMediaItems_FromArray(array MediaItemArray, number newposition)</functioncall>
  <description>
    It changes the position of the MediaItems from MediaItemArray. It keeps the related position to each other, putting the earliest item at newposition, putting the others later, relative to their offset.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    array MediaItemArray - an array with the MediaItems to be inserted
    number newposition - the new position in seconds
  </parameters>
  <retvals>
    integer retval - -1 in case of error, else returns 1
    number earliest_itemtime - the new earliest starttime of all MediaItems moved
    number latest_itemtime - the new latest endtime of all MediaItems moved
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert, ripple</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("MoveMediaItems_FromArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return -1 end
  if type(newposition)~="number" then ultraschall.AddErrorMessage("MoveMediaItems_FromArray", "newposition", "must be a number", -2) return -1 end

  local count=1
  local Earliest_time=reaper.GetProjectLength()+1
  local Latest_time=0
  local ItemStart, ItemEnd
  while MediaItemArray[count]~=nil do
    ItemStart=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    ItemEnd=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH")+ItemStart
    if ItemStart<Earliest_time then Earliest_time=ItemStart end
    if ItemEnd>Latest_time then Latest_time=ItemEnd end
    count=count+1
  end    

  count=1
  while MediaItemArray[count]~=nil do
    ItemStart=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    reaper.SetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION", (ItemStart-Earliest_time)+newposition)
    count=count+1
  end    
  return 1, Earliest_time, Latest_time
end



function ultraschall.InsertMediaItemStateChunkArray(position, MediaItemStateChunkArray, trackstring, add_needed_tracks)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray = ultraschall.InsertMediaItemStateChunkArray(number position, array MediaItemStateChunkArray, string trackstring, optional boolean add_needed_tracks)</functioncall>
  <description>
    Inserts the MediaItems from MediaItemStateChunkArray at position into the tracks, as given by trackstring.
    Note:Needs ULTRASCHALL_TRACKNUMBER within the statechunks, which includes the tracknumber for each mediaitem to be included. Else it will return -1. That entry will be included automatically into the MediaItemStateChunkArray as provided by <a href="#GetAllMediaItemsBetween">GetAllMediaItemsBetween</a>. If you need to manually insert that entry into a statechunk, use <a href="#SetItemUSTRackNumber_StateChunk">SetItemUSTRackNumber_StateChunk</a>.
    
    Returns the number of newly created items, as well as an array with the newly create MediaItems.
    Returns -1 in case of failure.
    
    Note: this inserts the items only in the tracks, where the original items came from(or the tracks set with the entry ULTRASCHALL_TRACKNUMBER). Items from track 1 will be included into track 1. Trackstring only helps to include or exclude the items from inclusion into certain tracks.
    If you have a MediaItemStateChunkArray with items from track 1,2,3,4,5 and you give trackstring only the tracknumber for track 3 and 4 -> 3,4, then only the items, that were in tracks 3 and 4 originally, will be included, all the others will be ignored.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    array MediaItemStateChunkArray - an array with the statechunks of the MediaItems to be inserted
    string trackstring - the numbers of the tracks, separated by a ,
    optional boolean add_needed_tracks - true, adds tracks to the project, if needed; nil or false, will only insert into existing tracks
  </parameters>
  <retvals>
    integer number_of_items - the number of MediaItems created
    array MediaItemArray - an array with the newly created MediaItems
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert, statechunk</tags>
</US_DocBloc>
]]    
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItemStateChunkArray", "position", "Must be a number.", -1) return -1 end
  if ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)==false then ultraschall.AddErrorMessage("InsertMediaItemStateChunkArray", "MediaItemStateChunkArray", "Must be a valid MediaItemStateChunkArray.", -2) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("InsertMediaItemStateChunkArray", "trackstring", "Must be a valid trackstring.", -3) return -1 end

  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  local count=1
  local i,LL
  local NewMediaItemArray={}
  local LL
  local _count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring) 
  local ItemStart=reaper.GetProjectLength()+1
  
  if add_needed_tracks==true then 
    
    local max_tracknumber=0
    for i=1, #MediaItemStateChunkArray do
      local tracknumber = ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[i])
      if tracknumber>max_tracknumber then max_tracknumber=tracknumber end
    end
    --print2(max_tracknumber,reaper.CountTracks(0))
    if max_tracknumber>reaper.CountTracks(0) then
    --print2(max_tracknumber < reaper.CountTracks(0))
      for i=reaper.CountTracks(0), max_tracknumber-1 do
        --print2("")
        reaper.Main_OnCommand(40001, 0)
      end
    end
  end
  
  while MediaItemStateChunkArray[count]~=nil do
    local ItemStart_temp=ultraschall.GetItemPosition(nil,MediaItemStateChunkArray[count])
    if ItemStart>ItemStart_temp then ItemStart=ItemStart_temp end
    count=count+1
  end
  count=1
  while MediaItemStateChunkArray[count]~=nil do
    local ItemStart_temp=ultraschall.GetItemPosition(nil,MediaItemStateChunkArray[count])
    local tempo,MediaTrack=ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[count])
    if tempo==nil then return -1 end
    i=1
    while individual_values[i]~=nil do
      local tempo,tempoMediaTrack=ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[count])
      if tempoMediaTrack==nil then return -1 end
      if reaper.GetTrack(0,individual_values[i]-1)==tempoMediaTrack then
        LL, NewMediaItemArray[count]=ultraschall.InsertMediaItem_MediaItemStateChunk(position+(ItemStart_temp-ItemStart), MediaItemStateChunkArray[count], MediaTrack)
      end
      i=i+1
    end
    count=count+1
  end  

  return count, NewMediaItemArray
end

--ultraschall.InsertMediaItemStateChunkArray(1,,3)

function ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(MediaItemStateChunkArray, trackstring)
--Throws out all items, that are not in the tracks, as given by trackstring
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyMediaItemsOfTracksInTrackstring_StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, array MediaItemStateChunkArray = ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(array MediaItemStateChunkArray, string trackstring)</functioncall>
  <description>
    Throws all MediaItems out of the MediaItemStateChunkArray, that are not within the tracks, as given with trackstring.
    Returns the "cleared" MediaItemArray; returns -1 in case of error
  </description>
  <parameters>
    array MediaItemStateChunkArray - an array with MediaItems; no nil-entries allowed, will be seen as the end of the array
    string trackstring - the tracknumbers, separated by a comma
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    array MediaItemStateChunkarray - the "cleared" array, that contains only the statechunks of MediaItems in tracks, as given by trackstring, -1 in case of error
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selection, statechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)==false then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring_StateChunk", "MediaItemStateChunkArray", "Must be a valid MediaItemStateChunkArray.", -1) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring_StateChunk", "trackstring", "Must be a valid trackstring.", -2) return -1 end

  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("OnlyMediaItemsOfTracksInTrackstring_StateChunk", "trackstring", "Must be a valid trackstring.", -3) return -1 end
  
  local count=1
  local count2=1
  local i=1
  local _count, trackstring_array= ultraschall.CSV2IndividualLinesAsArray(trackstring)
  local MediaItemArray2={}
  
  while MediaItemStateChunkArray[count]~=nil do
    if MediaItemStateChunkArray[count]==nil then break end
    i=1
    while trackstring_array[i]~=nil do
      if tonumber(trackstring_array[i])==nil then return -1 end
        local Atracknumber, Atrack = ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[count])
        if reaper.GetTrack(0,trackstring_array[i]-1)==Atrack then
          MediaItemArray2[count2]=MediaItemStateChunkArray[count]
          count2=count2+1
        end
        i=i+1
    end
    count=count+1
  end
  return 1, MediaItemArray2
end


function ultraschall.RippleInsert_MediaItemStateChunks(position, MediaItemStateChunkArray, trackstring, moveenvelopepoints, movemarkers)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleInsert_MediaItemStateChunks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemStateChunkArray, number endpos_inserted_items = ultraschall.RippleInsert_MediaItemStateChunks(number position, array MediaItemStateChunkArray, string trackstring, boolean moveenvelopepoints, boolean movemarkers)</functioncall>
  <description>
    It inserts the MediaItems from MediaItemStateChunkArray at position into the tracks, as given by trackstring. It moves the items, that were there before, accordingly toward the end of the project.
    
    Returns the number of newly created items, as well as an array with the newly created MediaItems as statechunks and the endposition of the last(projectposition) inserted item into the project.
    Returns -1 in case of failure.
    
    Note: this inserts the items only in the tracks, where the original items came from. Items from track 1 will be included into track 1. Trackstring only helps to include or exclude the items from inclusion into certain tracks.
    If you have a MediaItemStateChunkArray with items from track 1,2,3,4,5 and you give trackstring only the tracknumber for track 3 and 4 -> 3,4, then only the items, that were in tracks 3 and 4 originally, will be included, all the others will be ignored.
  </description>
  <parameters>
    number position - the position of the newly created mediaitem
    array MediaItemStateChunkArray - an array with the statechunks of MediaItems to be inserted
    string trackstring - the numbers of the tracks, separated by a ,
    boolean moveenvelopepoints - true, move the envelopepoints as well; false, keep the envelopepoints where they are
    boolean movemarkers - true, move markers as well; false, keep markers where they are
  </parameters>
  <retvals>
    integer number_of_items - the number of newly created items
    array MediaItemStateChunkArray - an array with the newly created MediaItems as StateChunkArray
    number endpos_inserted_items - the endposition of the last newly inserted MediaItem
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, insert, ripple</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "position", "must be a number", -1) return -1 end
  if ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)==false then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "MediaItemStateChunkArray", "must be a valid MediaItemStateChunkArray", -2) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "moveenvelopepoints", "must be a boolean", -4) return -1 end    
  if type(movemarkers)~="boolean" then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "movemarkers", "must be a boolean", -5) return -1 end
      
  local L,trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("RippleInsert_MediaItemStateChunks", "trackstring", "must be a valid trackstring", -6) return -1 end

  local NumberOfItems
  local NewMediaItemArray={}
  local count=1
  local ItemStart=reaper.GetProjectLength()+1
  local ItemEnd=0
  local i
  local _count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring)
  while MediaItemStateChunkArray[count]~=nil do
    local ItemStart_temp=ultraschall.GetItemPosition(nil,MediaItemStateChunkArray[count]) --reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION") --Buggy
    local ItemEnd_temp=ultraschall.GetItemLength(nil, MediaItemStateChunkArray[count]) --reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_LENGTH") --Buggy
    i=1
    while individual_values[i]~=nil do
      local Atracknumber, Atrack = ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[count])
      if reaper.GetTrack(0,individual_values[i]-1)==Atrack then
        if ItemStart>ItemStart_temp then ItemStart=ItemStart_temp end
        if ItemEnd<ItemEnd_temp+ItemStart_temp then ItemEnd=ItemEnd_temp+ItemStart_temp end
      end
      i=i+1
    end
    count=count+1
  end

  
  --Create copy of the track-state-chunks
  local nums, MediaItemArray_Chunk=ultraschall.GetMediaItemStateChunksFromItems(MediaItemArray)
    
  local A,A2=ultraschall.SplitMediaItems_Position(position,trackstring,false)

  if moveenvelopepoints==true then
    local CountTracks=reaper.CountTracks()
    for i=0, CountTracks-1 do
      for a=1,AAA do
        if tonumber(AA[a])==i+1 then
          local MediaTrack=reaper.GetTrack(0,i)
          local retval = ultraschall.MoveTrackEnvelopePointsBy(position, reaper.GetProjectLength()+(ItemEnd-ItemStart), ItemEnd-ItemStart, MediaTrack, true) 
        end
      end
    end
  end
  
  if movemarkers==true then
    ultraschall.MoveMarkersBy(position, reaper.GetProjectLength()+(ItemEnd-ItemStart), ItemEnd-ItemStart, true)
  end
  ultraschall.MoveMediaItemsAfter_By(position-0.000001, ItemEnd-ItemStart, trackstring)

  local L,MediaItemArray=ultraschall.OnlyMediaItemsOfTracksInTrackstring_StateChunk(MediaItemStateChunkArray, trackstring) --BUGGY?
  count=1
  while MediaItemStateChunkArray[count]~=nil do
    local Anumber=ultraschall.GetItemPosition(nil, MediaItemStateChunkArray[count])
    count=count+1
  end
    local NumberOfItems, NewMediaItemArray=ultraschall.InsertMediaItemStateChunkArray(position, MediaItemStateChunkArray, trackstring)
  count=1
  
  while MediaItemStateChunkArray[count]~=nil do
    local length=MediaItemStateChunkArray[count]:match("LENGTH (.-)%c")
--    reaper.MB(length,"",0)
    NewMediaItemArray[count]=ultraschall.SetItemLength(NewMediaItemArray[count], tonumber(length))
    count=count+1
  end
  return NumberOfItems, NewMediaItemArray, position+ItemEnd
end

--A,B,C,D,E=ultraschall.GetAllMediaItemsBetween(1,20,"1,2,3",false)
--ultraschall.RippleInsert_MediaItemStateChunks(l,C,"1,2,3",true, true)




function ultraschall.GetAllMediaItemsFromTrack(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemsFromTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer itemcount, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetAllMediaItemsFromTrack(integer tracknumber)</functioncall>
  <description>
    returns the number of items of tracknumber, as well as an array with all MediaItems and an array with all MediaItemStateChunks
    returns -1 in case of error
  </description>
  <parameters>
    integer tracknumber - the tracknumber, from where you want to get the item
  </parameters>
  <retvals>
    integer itemcount - the number of items in that track
    array MediaItemArray - an array with all MediaItems from this track
    array MediaItemStateChunkArray - an array with all MediaItemStateCunks from this track
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, get, item, mediaitem, statechunk, state, chunk</tags>
</US_DocBloc>
]]
--  tracknumber=tonumber(tracknumber) 
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("GetAllMediaItemsFromTrack","tracknumber", "must be an integer", -1) return -1 end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("GetAllMediaItemsFromTrack","tracknumber", "no such track", -2) return -1 end
  
  local count=1
  local MediaTrack=reaper.GetTrack(0,tracknumber-1)
  local MediaItemArray={}
  local MediaItemArrayStateChunk={}
  local MediaItem=""
  local temp
  local retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "", true)
  str=str:match("<ITEM.*")
  if str==nil then return 0, MediaItemArray, MediaItemArrayStateChunk end

  while str:match(".-%cIGUID.-")~= nil do
    local GUID=str:match(".-%cIGUID ({.-})%c")
    MediaItemArray[count]=reaper.BR_GetMediaItemByGUID(0, GUID)
    temp, MediaItemArrayStateChunk[count]=reaper.GetItemStateChunk(MediaItemArray[count],"",true)
    str=str:match(".-%cIGUID.-%c(.*)")
    if count==idx then MediaItem=reaper.BR_GetMediaItemByGUID(0, GUID) end
      count=count+1
    end
  return count-1, MediaItemArray, MediaItemArrayStateChunk
end

--A,B,C=ultraschall.GetAllMediaItemsFromTrack("")

function ultraschall.SetItemsLockState(MediaItemArray, lockstate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemsLockState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetItemsLockState(array MediaItemArray, boolean lockstate)</functioncall>
  <description>
    Sets the lockstate of the items in MediaItemArray. Set lockstate=true to set the items locked; false to set them unlocked.
    
    returns true in case of success, false in case of error
  </description>
  <parameters>
    array MediaItemArray - an array with the MediaItems to be processed
    boolean lockstate - true, to set the MediaItems to locked, false to set them to unlocked
  </parameters>
  <retvals>
    boolean retval - true in case of success, false in case of error
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, lock</tags>
</US_DocBloc>
]]
  if type(lockstate)~="boolean" then ultraschall.AddErrorMessage("SetItemsLockState", "lockstate", "Must be a boolean.", -1) return false end
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("SetItemsLockState", "MediaItemArray", "No valid MediaItemArray.", -2) return false end
  count=1
  while MediaItemArray[count]~=nil do
      if lockstate==true then reaper.SetMediaItemInfo_Value(MediaItemArray[count], "C_LOCK", 1)
      elseif lockstate==false then reaper.SetMediaItemInfo_Value(MediaItemArray[count], "C_LOCK", 0)
      end
      count=count+1
  end
  return true
end


function ultraschall.AddLockStateToMediaItemStateChunk(MediaItemStateChunk, lockstate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddLockStateToMediaItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string changedMediaItemStateChunk = ultraschall.AddLockStateToMediaItemStateChunk(string MediaItemStateChunk, boolean lockstate)</functioncall>
  <description>
    Sets the lockstate in a MediaItemStateChunk. Set lockstate=true to set the chunk locked; false to set it unlocked.
    
    Does not apply the changes to the MediaItem itself. To do that, use reaper.GetItemStateChunk or <a href="#ApplyStateChunkToItems">ApplyStateChunkToItems</a>!
    
    returns the changed MediaItemStateChunk
    
    returns -1 in case of failure
  </description>
  <parameters>
    string MediaItemStateChunk - the statechunk of the item to be processed, as returned by functions like reaper.GetItemStateChunk
    boolean lockstate - true, to set the MediaItemStateChunk to locked, false to set it to unlocked
  </parameters>
  <retvals>
    string changedMediaItemStateChunk - the lockstate-modified MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, statechunk, state, chunk, lock</tags>
</US_DocBloc>
]]
  if type(lockstate)~="boolean" then ultraschall.AddErrorMessage("AddLockStateToMediaItemStateChunk", "lockstate", "Must be a boolean.", -1) return -1 end
  if ultraschall.IsValidMediaItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("AddLockStateToMediaItemStateChunk", "MediaItemStateChunk", "Must be a valid MediaItemStateChunk.", -2) return -1 end
  local Begin=MediaItemStateChunk:match("<ITEM.-MUTE.-%c")
  local End=MediaItemStateChunk:match("<ITEM.-(%cSEL.*)")
  if lockstate==true then return Begin.."LOCK 1"..End
  elseif lockstate==false then return Begin..End end
end

function ultraschall.AddLockStateTo_MediaItemStateChunkArray(MediaItemStateChunkArray, lockstate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddLockStateTo_MediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array changedMediaItemStateChunkArray = ultraschall.AddLockStateTo_MediaItemStateChunkArray(array MediaItemStateChunkArray, boolean lockstate)</functioncall>
  <description>
    Sets the lockstates in a MediaItemStateChunkArray. Set lockstate=true to set the chunks locked; false to set them unlocked.
    
    Does not apply the changes to the MediaItem itself. To do that, use reaper.GetItemStateChunk or <a href="#ApplyStateChunkToItems">ApplyStateChunkToItems</a>!
    
    returns the number of entries and the altered MediaItemStateChunkArray; -1 in case of failure
  </description>
  <parameters>
    array MediaItemStateChunkArray - the statechunkarray of the items to be processed, as returned by functions like reaper.GetItemStateChunk
    boolean lockstate - true, to set the MediaItemStateChunk to locked, false to set it to unlocked
  </parameters>
  <retvals>
    integer count - the number of entries in the changed MediaItemStateChunkArray
    array changedMediaItemStateChunkArray - the lockstate-modified MediaItemStateChunkArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, statechunk, state, chunk, lock</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)==false then ultraschall.AddErrorMessage("AddLockStateTo_MediaItemStateChunkArray", "MediaItemStateChunkArray", "must be a valid MediaItemStateChunkArray", -1) return -1 end
  if type(lockstate)~="boolean" then ultraschall.AddErrorMessage("AddLockStateTo_MediaItemStateChunkArray", "lockstate", "must be a boolean", -2) return -1 end
  local count=1
  while MediaItemStateChunkArray[count]~=nil do
      if lockstate==true then 
        MediaItemStateChunkArray[count]=ultraschall.AddLockStateToMediaItemStateChunk(MediaItemStateChunkArray[count], true)
      elseif lockstate==false then 
        MediaItemStateChunkArray[count]=ultraschall.AddLockStateToMediaItemStateChunk(MediaItemStateChunkArray[count], false)
      end
      count=count+1
  end
  return count-1, MediaItemStateChunkArray
end

--A,B,C=ultraschall.GetAllMediaItemsBetween(1,20,"1",false)
--ultraschall.AddLockStateTo_MediaItemStateChunkArray(C,1)

function ultraschall.ApplyStateChunkToItems(MediaItemStateChunkArray, undostate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyStateChunkToItems</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer skippeditemscount, array skipped_MediaItemStateChunkArray = ultraschall.ApplyStateChunkToItems(array MediaItemStateChunkArray, boolean undostate)</functioncall>
  <description>
    Applies changed StateChunks to the respective items. Skips deleted items, as they can't be set.
    
    It will look into the IGUID-entry of the statechunks, to find the right corresponding MediaItem to apply the statechunk to.
    
    returns the number of entries and the altered MediaItemStateChunkArray; -1 in case of failure
  </description>
  <parameters>
    array MediaItemStateChunkArray - the statechunkarray of the items to be applied, as returned by functions like reaper.GetItemStateChunk
    boolean undostate - true, sets the changed undo-possible, false undo-impossible
  </parameters>
  <retvals>
    boolean retval - true it worked, false it didn't
    integer skippeditemscount - the number of entries that couldn't be applied
    array skipped_MediaItemStateChunkArray - the StateChunks, that couldn't be aplied
  </retvals>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, statechunk, state, chunk, apply</tags>
</US_DocBloc>
]]
  if ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)==false then ultraschall.AddErrorMessage("ApplyStateChunkToItems","MediaItemStateChunkArray", "must be a valid MediaItemStateChunkArray", -1) return false end
  if type(undostate)~="boolean" then ultraschall.AddErrorMessage("ApplyStateChunkToItems","undostate", "must be a boolean", -2) return false end
  local count=1
  local count_two=1
  local MediaItemStateChunkArray2={}
  while MediaItemStateChunkArray[count]~=nil do
    local IGUID = ultraschall.GetItemIGUID_StateChunk(MediaItemStateChunkArray[count])
    local MediaItem=reaper.BR_GetMediaItemByGUID(0, IGUID)
    if MediaItem~=nil then local Boolean=reaper.SetItemStateChunk(MediaItem, MediaItemStateChunkArray[count], undostate) 
      --reaper.MB("hula","",0)
    else
      MediaItemStateChunkArray2[count_two]=MediaItemStateChunkArray[count]
      count_two=count_two+1
    end
    count=count+1
  end
  return true, count_two-1, MediaItemStateChunkArray2
end

--ultraschall.ApplyStateChunkToItems("", "")

function ultraschall.GetAllLockedItemsFromMediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllLockedItemsFromMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer countlock, array locked_MediaItemArray, integer countunlock, array unlocked_MediaItemArray = ultraschall.GetAllLockedItemsFromMediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Returns the number and the items that are locked, as well as the number and the items that are NOT locked.
    The items are returned as MediaItemArrays
    returns -1 in case of failure
  </description>
  <parameters>
    array MediaItemArray - the statechunkarray of the items to be checked.
  </parameters>
  <retvals>
    integer countlock - the number of locked items. -1 in case of failure
    array locked_MediaItemArray - the locked items in a mediaitemarray
    integer countunlock - the number of un(!)locked items
    array unlocked_MediaItemArray - the un(!)locked items in a mediaitemarray
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, selection, lock, lockstate, locked state, unlock, unlocked state</tags>
</US_DocBloc>
]]
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("GetAllLockedItemsFromMediaItemArray", "MediaItemArray", "Only array with MediaItemObjects as entries is allowed.", -1) return -1 end
  local MediaItemArray_locked={}
  local MediaItemArray_unlocked={}
  local count=1
  local countlock=1
  local countunlock=1
  while MediaItemArray[count]~=nil do
    local number=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "C_LOCK")
    if number==0 then MediaItemArray_unlocked[countunlock]=MediaItemArray[count] countunlock=countunlock+1
    elseif number==1 then MediaItemArray_locked[countlock]=MediaItemArray[count] countlock=countlock+1 
    end
    count=count+1
  end
  return countlock-1, MediaItemArray_locked, countunlock-1, MediaItemArray_unlocked
end

function ultraschall.GetMediaItemStateChunksFromMediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemStateChunksFromMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray = ultraschall.GetMediaItemStateChunksFromMediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Returns the number of items and statechunks of the Items in MediaItemArray. It skips items in MediaItemArray, that are deleted.
    returns -1 in case of failure
  </description>
  <parameters>
    array MediaItemArray - the statechunkarray of the items to be checked.
  </parameters>
  <retvals>
    integer count - the number of statechunks returned. -1 in case of failure
    array MediaItemStateChunkArray - the statechunks of the items in mediaitemarray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, set, item, mediaitem, selection, chunk, statechunk, state chunk, state</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("GetMediaItemStateChunksFromMediaItemArray", "MediaItemArray", "No valid MediaItemArray", -1) return -1 end
  local MediaItemStateChunkArray={}
  local count=1
  local count2=1
  local retval
  while MediaItemArray[count]~=nil do
    if reaper.ValidatePtr(MediaItemArray[count],"MediaItem*")==true then
      retval, MediaItemStateChunkArray[count2] = reaper.GetItemStateChunk(MediaItemArray[count], "", true)
      count2=count2+1
    end
    count=count+1
  end
  return count2-1, MediaItemStateChunkArray
end

function ultraschall.GetSelectedMediaItemsAtPosition(position, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSelectedMediaItemsAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetSelectedMediaItemsAtPosition(number position, string trackstring)</functioncall>
  <description>
    Returns all selected items at position in the tracks as given by trackstring, as MediaItemArray. Empty MediaItemAray if none is found.
    
    returns -1 in case of error
  </description>
  <parameters>
    number position - position in seconds
    string trackstring - the tracknumbers, separated by commas
  </parameters>
  <retvals>
    integer count - the number of entries in the returned MediaItemArray
    array MediaItemArray - the found MediaItems returned as an array
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, get, selected, selection</tags>
</US_DocBloc>
]]
  if type(position)~="number" then ultraschall.AddErrorMessage("GetSelectedMediaItemsAtPosition","position", "must be a number", -1) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetSelectedMediaItemsAtPosition","trackstring", "must be a valid trackstring", -2) return -1 end
  local A,B,C=ultraschall.GetMediaItemsAtPosition(position, trackstring)
  for i=A, 1, -1 do
    if reaper.IsMediaItemSelected(B[i])==false then
      table.remove(B,i)
      table.remove(C,i)
      A=A-1
    end
  end
  return A,B,C
end

function ultraschall.GetSelectedMediaItemsBetween(startposition, endposition, trackstring, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSelectedMediaItemsBetween</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray = ultraschall.GetSelectedMediaItemsBetween(number startposition, number endposition, string trackstring, boolean inside)</functioncall>
  <description>
    Returns all selected items between startposition and endposition in the tracks as given by trackstring, as MediaItemArray. Empty MediaItemAray if none is found.
    
    returns -1 in case of error
  </description>
  <parameters>
    number startposition - startposition in seconds
    number endposition - endposition in seconds
    string trackstring - the tracknumbers, separated by commas
    boolean inside - true, only items completely within start/endposition; false, also items, that are partially within start/endposition
  </parameters>
  <retvals>
    integer count - the number of entries in the returned MediaItemArray
    array MediaItemArray - the found MediaItems returned as an array
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, get, selected, selection, startposition, endposition</tags>
</US_DocBloc>
]]
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("GetSelectedMediaItemsBetween", "inside", "must be either true or false", -1) return -1 end
  if type(startposition)~="number" then ultraschall.AddErrorMessage("GetSelectedMediaItemsBetween", "startposition", "must be a number", -2) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("GetSelectedMediaItemsBetween", "endposition", "must be a number", -3) return -1 end
  local retval, trackstring, trackstringarray, number_of_entries = ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if retval==-1 then ultraschall.AddErrorMessage("GetSelectedMediaItemsBetween", "trackstring", "not a valid value. Must be a string with numbers,separated by commas, e.g. \"1,2,4,6,8\"", -4) return -1 end
  local Number_of_items, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(startposition, endposition, trackstring, inside)
  if Number_of_items==-1 then ultraschall.AddErrorMessage("GetSelectedMediaItemsBetween", "trackstring", "not a valid value. Must be a string with numbers,separated by commas, e.g. \"1,2,4,6,8\"", -5) return -1 end
  local SelectedMediaItemArray={}
  local count=0
  for i=1,Number_of_items do
    if reaper.GetMediaItemInfo_Value(MediaItemArray[i], "B_UISEL")==1 then 
      count=count+1 
      SelectedMediaItemArray[count]=MediaItemArray[i] 
    end
  end
  return count, SelectedMediaItemArray
end


function ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeselectMediaItems_MediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeselectMediaItems_MediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Deselects all MediaItems, that are in MediaItemArray.
    
    returns -1 in case of error
  </description>
  <parameters>
    array MediaItemArray - an array with all the MediaItemObjects, that shall be deselected
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selected, selection, deselect, unselect</tags>
</US_DocBloc>
]]
  if type(MediaItemArray)~="table" then ultraschall.AddErrorMessage("DeselectMediaItems_MediaItemArray", "MediaItemArray", "must be an array with MediaItem-objects", -1) return -1 end
  local count=1
  while MediaItemArray[count]~=nil do
    if reaper.ValidatePtr(MediaItemArray[count], "MediaItem*")==true then 
      reaper.SetMediaItemInfo_Value(MediaItemArray[count], "B_UISEL", 0)
    end
    count=count+1
  end
  return 1
end

function ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SelectMediaItems_MediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SelectMediaItems_MediaItemArray(array MediaItemArray)</functioncall>
  <description>
    Selects all MediaItems, that are in MediaItemArray.
    
    It retains any current selection.
    
    returns -1 in case of error
  </description>
  <parameters>
    array MediaItemArray - an array with all the MediaItemObjects, that shall be selected
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, selected, selection, select</tags>
</US_DocBloc>
]]
  if type(MediaItemArray)~="table" then ultraschall.AddErrorMessage("SelectMediaItems_MediaItemArray", "MediaItemArray", "must be an array with MediaItem-objects", -1) return -1 end
  local count=1
  while MediaItemArray[count]~=nil do
    if reaper.ValidatePtr(MediaItemArray[count], "MediaItem*")==true then 
      reaper.SetMediaItemInfo_Value(MediaItemArray[count], "B_UISEL", 1)
    end
    count=count+1
  end
  
  reaper.UpdateArrange()
  return 1
end


function ultraschall.EnumerateMediaItemsInTrack(tracknumber, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateMediaItemsInTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>MediaItem item, integer itemcount, array MediaItemArray = ultraschall.EnumerateMediaItemsInTrack(integer tracknumber, integer itemnumber)</functioncall>
  <description>
    returns the itemnumberth MediaItemobject in track, the number of items in tracknumber and an array with all MediaItems from this track.
    returns -1 in case of error
  </description>
  <parameters>
    integer tracknumber - the tracknumber, from where you want to get the item
    integer itemnumber - the itemnumber within that track. 1 for the first, 2 for the second, etc
  </parameters>
  <retvals>
    MediaItem item - the Mediaitem, as requested by parameter itemnumber
    integer itemcount - the number of items in that track
    array MediaItemArray - an array with all MediaItems from this track
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, get, item, mediaitem</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("EnumerateMediaItemsInTrack","tracknumber", "must be an integer", -1) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("EnumerateMediaItemsInTrack","idx", "must be an integer", -2) return -1 end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("EnumerateMediaItemsInTrack","tracknumber", "no such tracknumber", -3) return -1 end
  if idx<0 then ultraschall.AddErrorMessage("EnumerateMediaItemsInTrack","idx", "must be bigger than or equal 0", -4) return -1 end
  local count=1
  local MediaTrack=reaper.GetTrack(0,tracknumber-1)
  local MediaItemArray={}
  local MediaItem=""
  local retval, str = ultraschall.GetTrackStateChunk(MediaTrack, "", true)
  str=str:match("<ITEM.*")
  
  if str==nil then ultraschall.AddErrorMessage("EnumerateMediaItemsInTrack","tracknumber", "No item in track", -5) return -1 end 
  
  while str:match(".-%cIGUID.-")~= nil do
    local GUID=str:match(".-%cIGUID ({.-})%c")
    MediaItemArray[count]=reaper.BR_GetMediaItemByGUID(0, GUID)
    str=str:match(".-%cIGUID.-%c(.*)")
    if count==idx then MediaItem=reaper.BR_GetMediaItemByGUID(0, GUID) end
      count=count+1
    end
  return MediaItem, count-1, MediaItemArray
end

--A,B,C,D,E=ultraschall.EnumerateMediaItemsInTrack(1, 1000)


function ultraschall.GetMediaItemArrayLength(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemArrayLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer start, integer end, integer length = ultraschall.GetMediaItemArrayLength(array MediaItemArray)</functioncall>
  <description>
    Returns the beginning of the first item, the end of the last item as well as the length between start and end of all items within the MediaItemArray.
    Will return -1, in case of error
  </description>
  <parameters>
    array MediaItemArray - an array with MediaItems, as returned by functions like <a href="#GetAllMediaItemsBetween">GetAllMediaItemsBetween</a> or <a href="#GetMediaItemsAtPosition">GetMediaItemsAtPosition</a> or similar.
  </parameters>
  <retvals>
    integer start - the beginning of the earliest item in the MediaItemArray in seconds
    integer end - the end of the latest item in the MediaItemArray, timewise, in seconds
    integer length - the length of the MediaItemArray in seconds
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>itemmanagement,count,length,items,end,mediaitem,item</tags>
</US_DocBloc>
]]
  local retval, count, retMediaItemArray = ultraschall.CheckMediaItemArray(MediaItemArray)
  if retval==false then ultraschall.AddErrorMessage("GetMediaItemArrayLength", "MediaItemArray", "no valid MediaItemArray", -1) return -1 end  
  local start=reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_POSITION")
  local endof=reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_POSITION")+reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_LENGTH")
  local delta=0
  for i=1, count do
    local tempstart=reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_POSITION")
    local tempendof=reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_POSITION")+reaper.GetMediaItemInfo_Value(retMediaItemArray[1], "D_LENGTH")
    if tempstart<start then start=tempstart end
    if tempendof>endof then endof=tempendof end
  end
  delta=endof-start
  return start, endof, delta
end


function ultraschall.GetMediaItemStateChunkArrayLength(MediaItemStateChunkArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemStateChunkArrayLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer start, integer end, integer length = ultraschall.GetMediaItemStateChunkArrayLength(array MediaItemStateChunkArray)</functioncall>
  <description>
    Returns the beginning of the first item, the end of the last item as well as the length between start and end of all items within the MediaItemStateChunkArray.
    Will return -1, in case of error
  </description>
  <parameters>
    array MediaItemStateChunkArray - an array with MediaItemStateChunks, as returned by functions like <a href="#GetAllMediaItemsBetween">GetAllMediaItemsBetween</a> or <a href="#GetMediaItemsAtPosition">GetMediaItemsAtPosition</a> or similar.
  </parameters>
  <retvals>
    integer start - the beginning of the earliest item in the MediaItemArray in seconds
    integer end - the end of the latest item in the MediaItemArray, timewise, in seconds
    integer length - the length of the MediaItemArray in seconds
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>itemmanagement,count,length,items,end, mediaitem, statechunk,item</tags>
</US_DocBloc>
]]
  local retval, count, retMediaItemArray = ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)
  if retval==false then ultraschall.AddErrorMessage("GetMediaItemStateChunkArrayLength", "MediaItemStateChunkArray", "no valid MediaItemStateChunkArray", -1) return -1 end
  start=retMediaItemArray[1]:match("POSITION (.-)%c")
  endof=retMediaItemArray[1]:match("POSITION (.-)%c")+retMediaItemArray[1]:match("LENGTH (.-)%c")
  local delta=0
  for i=1, count do
    local tempstart=retMediaItemArray[1]:match("POSITION (.-)%c")
    local tempendof=retMediaItemArray[1]:match("POSITION (.-)%c")+retMediaItemArray[1]:match("LENGTH (.-)%c")
    if tempstart<start then start=tempstart end
    if tempendof>endof then endof=tempendof end
  end
  delta=endof-start
  return tonumber(start), tonumber(endof), tonumber(delta)
  --]]
end


function ultraschall.GetAllMediaItemGUIDs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemGUIDs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table GUID_Array, integer count_of_GUID = ultraschall.GetAllMediaItemGUIDs()</functioncall>
  <description>
    Returns an array with all MediaItem-GUIDs in order of the MediaItems-count(1 for first MediaItem, etc).
    
    Returns nil in case of an error
  </description>
  <parameters>
    table GUID_Array - an array with all GUIDs of all MediaItems
    integer count_of_GUID - the number of GUIDs(from MediaItems) in the GUID_Array
  </parameters>
  <retvals>
    table diff_array - an array with all entries from CompareArray2, that are not in Array
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, guid, mediaitem, item</tags>
</US_DocBloc>
--]]
  local GUID_Array={}
  for i=0, reaper.CountMediaItems(0)-1 do
    local item=reaper.GetMediaItem(0,i)
    GUID_Array[i+1] = reaper.BR_GetMediaItemGUID(item)
  end
  return GUID_Array, reaper.CountMediaItems(0)
end

--C1,C2=ultraschall.GetAllMediaItemGUIDs()


function ultraschall.GetItemSpectralConfig(itemidx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer item_spectral_config = ultraschall.GetItemSpectralConfig(integer itemidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    returns the item-spectral-config, which is the fft-size of the spectral view for this item.
    set itemidx to -1 to use the optional parameter MediaItemStateChunk to alter a MediaItemStateChunk instead of an item directly.
    
    returns -1 in case of error or nil if no spectral-config exists(e.g. when no spectral-edit is applied to this item)
  </description>
  <parameters>
    integer itemidx - the number of the item, with 1 for the first item, 2 for the second, etc.; -1, to use the parameter MediaItemStateChunk
    optional string MediaItemStateChunk - you can give a MediaItemStateChunk to process, if itemidx is set to -1
  </parameters>
  <retvals>
    integer item_spectral_config - the fft-size in points for the spectral-view; 16, 32, 64, 128, 256, 512, 1024(default), 2048, 4096, 8192; -1, if not existing
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, spectral edit, fft, size</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralConfig","itemidx", "only integer allowed", -1) return -1 end
  if itemidx~=-1 and itemidx<1 or itemidx>reaper.CountMediaItems(0) then ultraschall.AddErrorMessage("GetItemSpectralConfig","itemidx", "no such item exists", -2) return -1 end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("GetItemSpectralConfig","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -5) return -1 end

  -- get statechunk, if necessary(itemidx~=-1)
  local _retval
  if itemidx~=-1 then 
    local MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  -- get the value of SPECTRAL_CONFIG and return it
  local retval=MediaItemStateChunk:match("SPECTRAL_CONFIG (.-)%c")
  if retval==nil then ultraschall.AddErrorMessage("GetItemSpectralConfig","", "no spectral-edit-config available", -3) return nil end
  return tonumber(retval)
end



function ultraschall.SetItemSpectralConfig(itemidx, item_spectral_config, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemSpectralConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string MediaItemStateChunk = ultraschall.SetItemSpectralConfig(integer itemidx, integer item_spectral_config, optional string MediaItemStateChunk)</functioncall>
  <description>
    sets the item-spectral-config, which is the fft-size of the spectral view for this item. 
    
    returns false in case of error or if no spectral-config exists(e.g. when no spectral-edit is applied to this item)
  </description>
  <parameters>
    integer itemidx - the number of the item, with 1 for the first item, 2 for the second, etc.; -1, if you want to use the optional parameter MediaItemStateChunk
    integer item_spectral_config - the fft-size in points for the spectral-view; 16, 32, 64, 128, 256, 512, 1024(default), 2048, 4096, 8192; nil, to remove it
                                 - nil will only remove it, when SPECTRAL_EDIT is removed from item first; returned statechunk will have it removed still
    optional string MediaItemStateChunk - a MediaItemStateChunk you want to have altered; works only, if itemdidx is set to -1, otherwise it will be ignored
  </parameters>
  <retvals>
    boolean retval - true, if setting spectral-config worked; false, if not
    string MediaItemStateChunk - the altered MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, set, item, spectral edit, fft, size</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralConfig","itemidx", "only integer allowed", -1) return false end
  if itemidx~=-1 and (itemidx<1 or itemidx>reaper.CountMediaItems(0)) then ultraschall.AddErrorMessage("SetItemSpectralConfig","itemidx", "no such item exists", -2) return false end
  if math.type(item_spectral_config)~="integer" and item_spectral_config~=nil then ultraschall.AddErrorMessage("SetItemSpectralConfig","item_spectral_config", "only integer or nil allowed", -3) return false end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("SetItemSpectralConfig","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -5) return false end
  -- check for valid values, but seems not neccessary with Reaper...
  --  if item_spectral_config~=16 and item_spectral_config~=32 and item_spectral_config~=64 and item_spectral_config~=128 and item_spectral_config~=256 and 
  --     item_spectral_config~=512 and item_spectral_config~=1024 and item_spectral_config~=2048 and item_spectral_config~=4096 and item_spectral_config~=8192 and 
  --     item_spectral_config~=-1 then ultraschall.AddErrorMessage("SetItemSpectralConfig","item_spectral_config", "no valid value", -4) return -1 end
  
  -- get statechunk, if necessary(itemidx isn't set to -1)
  local MediaItem, _retval
  if itemidx~=-1 then 
    MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  -- check, if SPECTRAL_CONFIG exists at all
  local retval=MediaItemStateChunk:match("SPECTRAL_CONFIG (.-)%c")
  if retval==nil then ultraschall.AddErrorMessage("SetItemSpectralConfig","itemidx", "can't set, no spectral-config available.", -6)  return false end

  -- add or delete the Spectral-Config-setting
  if item_spectral_config~=nil then MediaItemStateChunk=MediaItemStateChunk:match("(.-)SPECTRAL_CONFIG").."SPECTRAL_CONFIG "..item_spectral_config..MediaItemStateChunk:match("SPECTRAL_CONFIG.-(%c.*)") end
  if item_spectral_config==nil then MediaItemStateChunk=MediaItemStateChunk:match("(.-)SPECTRAL_CONFIG")..MediaItemStateChunk:match("SPECTRAL_CONFIG.-%c(.*)") end
  
  -- set to item, if itemidx~=-1 and return values afterwards
  if itemidx~=-1 then reaper.SetItemStateChunk(MediaItem, MediaItemStateChunk, false) end
  return true, MediaItemStateChunk
end


function ultraschall.CountItemSpectralEdits(itemidx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountItemSpectralEdits</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.CountItemSpectralEdits(integer itemidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    counts the number of SPECTRAL_EDITs in a given MediaItem/MediaItemStateChunk.
    The SPECTRAL_EDITs are the individual edit-boundary-boxes in the spectral-view.
    If itemidx is set to -1, you can give the function a MediaItemStateChunk to look in, instead.
    
    returns -1 in case of error
  </description>
  <parameters>
    integer itemidx - the MediaItem to look in for the spectral-edit; -1, to use the parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - if itemidx is -1, this can be a MediaItemStateChunk to use, otherwise this will be ignored
  </parameters>
  <retvals>
    integer count - the number of spectral-edits available in a given MediaItem/MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, count, item, spectral edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("CountItemSpectralEdits","itemidx", "only integer allowed", -1) return -1 end
  if itemidx~=-1 and itemidx<1 or itemidx>reaper.CountMediaItems(0) then ultraschall.AddErrorMessage("CountItemSpectralEdits","itemidx", "no such item exists", -2) return -1 end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("CountItemSpectralEdits","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -5) return -1 end

  -- get statechunk, if necessary(itemidx~=-1)
  local _retval, MediaItem
  if itemidx~=-1 then 
    MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  local offset=0
  local counter=0
  local match=""
  while MediaItemStateChunk:match("SPECTRAL_EDIT", offset)~= nil do
    match, offset=MediaItemStateChunk:match("(SPECTRAL_EDIT)()", offset+1)
    if match~=nil then counter=counter+1 end
  end
  return counter
end



function ultraschall.GetItemSpectralEdit(itemidx, spectralidx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralEdit</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>number start_pos, number length, number gain, number fade, number freq_fade, number freq_range_bottom, number freq_range_top, integer h, integer byp_solo, number gate_thres, number gate_floor, number comp_thresh, number comp_exp_ratio, number n, number o, number fade2, number freq_fade2 = ultraschall.GetItemSpectralEdit(integer itemidx, integer spectralidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    returns the settings of a specific SPECTRAL_EDIT in a given MediaItem/MediaItemStateChunk.
    The SPECTRAL_EDITs are the individual edit-boundary-boxes in the spectral-view.
    If itemidx is set to -1, you can give the function a MediaItemStateChunk to look in, instead.
    
    returns -1 in case of error
  </description>
  <parameters>
    integer itemidx - the MediaItem to look in for the spectral-edit; -1, to use the parameter MediaItemStateChunk instead
    integer spectralidx - the number of the spectral-edit to return; 1 for the first, 2 for the second, etc
    optional string MediaItemStateChunk - if itemidx is -1, this can be a MediaItemStateChunk to use, otherwise this will be ignored
  </parameters>
  <retvals>
    number start_pos - the startposition of the spectral-edit-region in seconds
    number length - the length of the spectral-edit-region in seconds
    number gain - the gain as slider-value; 0(-224dB) to 98350.1875(99.68dB); 1 for 0dB
    number fade - 0(0%)-0.5(100%); adjusting this affects also parameter fade2!
    number freq_fade - 0(0%)-0.5(100%); adjusting this affects also parameter freq_fade2!
    number freq_range_bottom - the bottom of the edit-region, but can be moved to be top as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    number freq_range_top - the top of the edit-region, but can be moved to be bottom as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    integer h - unknown
    integer byp_solo - sets the solo and bypass-state. 0, no solo, no bypass; 1, bypass only; 2, solo only; 3, bypass and solo
    number gate_thres - sets the threshold of the gate; 0(-224dB)-98786.226563(99.89dB)
    number gate_floor - sets the floor of the gate; 0(-224dB)-99802.171875(99.98dB)
    number comp_thresh - sets the threshold for the compressor; 0(-224dB)-98842.484375(99.90dB); 1(0dB)is default
    number comp_exp_ratio - sets the ratio of the compressor/expander; 0.1(1:10.0)-100(100:1.0); 1(1.0:1) is default
    number n - unknown
    number o - unknown
    number fade2 - negative with fade_in set; positive with fadeout-set
    number freq_fade2 - negative with low frequency-fade, positive with high-frequency-fade
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, spectral edit</tags>
</US_DocBloc>
--]]

  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralEdit","itemidx", "only integer allowed", -1) return -1 end
  if itemidx~=-1 and itemidx<1 or itemidx>reaper.CountMediaItems(0) then ultraschall.AddErrorMessage("GetItemSpectralEdit","itemidx", "no such item exists", -2) return -1 end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("GetItemSpectralEdit","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -3) return -1 end

  if math.type(spectralidx)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralEdit","spectralidx", "only integer allowed", -4) return -1 end
  if spectralidx<1 or spectralidx>ultraschall.CountItemSpectralEdits(itemidx, MediaItemStateChunk) then ultraschall.AddErrorMessage("GetItemSpectralEdit","spectralidx", "no such spectral-edit available, must be between 1 and maximum count of spectral-edits.", -5) return -1 end

  -- get statechunk, if necessary(itemidx~=-1)
  local _retval, MediaItem
  if itemidx~=-1 then 
    MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  -- prepare variables
  local offset=0
  local counter=-1
  local found=""
  local match=""
  
  -- look for the spectralidx-th entry
  while MediaItemStateChunk:match("SPECTRAL_EDIT", offset+1)~= nil do
    offset, match=MediaItemStateChunk:match("()(SPECTRAL_EDIT)", offset+1)
    if match~=nil then counter=counter+1 end
    if counter==spectralidx-1 then found=MediaItemStateChunk:match("(SPECTRAL_EDIT.-%c)", offset) end
  end
  
  -- convert to numbers and return
  local L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17 = found:match("SPECTRAL_EDIT (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-)%c")
  return tonumber(L1), tonumber(L2), tonumber(L3), tonumber(L4), tonumber(L5), tonumber(L6), tonumber(L7), tonumber(L8), tonumber(L9), tonumber(L10), 
         tonumber(L11), tonumber(L12), tonumber(L13), tonumber(L14), tonumber(L15), tonumber(L16), tonumber(L17)
end

--L,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17=ultraschall.GetItemSpectralEdit(1, 4, MediaItemStateChunk)



function ultraschall.DeleteItemSpectralEdit(itemidx, spectralidx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteItemSpectralEdit</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string MediaItemStateChunk = ultraschall.DeleteItemSpectralEdit(integer itemidx, integer spectralidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    deletes a specific SPECTRAL_EDIT in a given MediaItem/MediaItemStateChunk.
    The SPECTRAL_EDITs are the individual edit-boundary-boxes in the spectral-view.
    If itemidx is set to -1, you can give the function a MediaItemStateChunk to look in, instead.
    
    returns false in case of error
  </description>
  <parameters>
    integer itemidx - the MediaItem to look in for the spectral-edit; -1, to use the parameter MediaItemStateChunk instead
    integer spectralidx - the number of the spectral-edit to delete; 1 for the first, 2 for the second, etc
    optional string MediaItemStateChunk - if itemidx is -1, this can be a MediaItemStateChunk to use, otherwise this will be ignored
  </parameters>
  <retvals>
    boolean retval - true, if deleting an spectral-edit-entry was successful; false, if it was unsuccessful
    string MediaItemStateChunk - the altered MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, delete, item, spectral edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("DeleteItemSpectralEdit","itemidx", "only integer allowed", -1) return false end
  if itemidx~=-1 and itemidx<1 or itemidx>reaper.CountMediaItems(0) then ultraschall.AddErrorMessage("DeleteItemSpectralEdit","itemidx", "no such item exists", -2) return false end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("DeleteItemSpectralEdit","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -3) return false end

  if math.type(spectralidx)~="integer" then ultraschall.AddErrorMessage("DeleteItemSpectralEdit","spectralidx", "only integer allowed", -4) return false end
  if spectralidx<1 or spectralidx>ultraschall.CountItemSpectralEdits(itemidx, MediaItemStateChunk) then ultraschall.AddErrorMessage("DeleteItemSpectralEdit","spectralidx", "no such spectral-edit available, must be between 1 and maximum count of spectral-edits.", -5) return false end

  -- get statechunk, if necessary(itemidx~=-1)
  local _retval, MediaItem
  if itemidx~=-1 then 
    MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  -- prepare variables
  local offset=0
  local counter=-1
  local found=""
  local match=""
  local offset2=0
  
  -- look for the spectralidx-th entry
  while MediaItemStateChunk:match("SPECTRAL_EDIT", offset+1)~= nil do
    offset, match, offset2 = MediaItemStateChunk:match("()(SPECTRAL_EDIT.-)%c()", offset+1)
--    reaper.MB(match, offset.." "..offset2,0)
    if match~=nil then counter=counter+1 end
    if counter==spectralidx-1 then found=MediaItemStateChunk:sub(1,offset-1)..MediaItemStateChunk:match("SPECTRAL_EDIT.-%c(.*)", offset) end
  end
  
  -- set to MediaItem(if itemidx==-1) and after that return the altered statechunk
  if itemidx~=-1 then reaper.SetItemStateChunk(MediaItem, found, false) end
  return true, found
end

--L,LL=ultraschall.DeleteItemSpectralEdit(1, 1, "")
--reaper.MB(LL,"",0)

function ultraschall.SetItemSpectralVisibilityState(item, state, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemSpectralVisibilityState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemSpectralVisibilityState(integer itemidx, integer state, optional string MediaItemStateChunk)</functioncall>
  <description>
    Sets SPECTROGRAM-state in a MediaItem or MediaItemStateChunk.
    Setting it shows the spectrogram, in which you can do spectral-editing, as selected in the MediaItem-menu "Spectral-editing -> Toggle show spectrogram for selected items"
    
    It returns the modified MediaItemStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    integer itemidx - the number of the item in the project; use -1 to use MediaItemStateChunk instead
    integer state - the state of the SPECTROGRAM; 0, to hide SpectralEdit; 1, to set SpectralEdit visible
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk; only read, when itemidx=-1
  </parameters>
  <retvals>
    string MediaItemStateChunk - the altered rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, rppxml, state, chunk, spectrogram, set</tags>
</US_DocBloc>
]]
  if math.type(item)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "item", "Must be an integer; -1, to use trackstatechunk.", -1) return -1 end
  if item~=-1 and reaper.ValidatePtr2(0, reaper.GetMediaItem(0,item-1), "MediaItem*")==false then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "item", "Must be a valid MediaItem-idx or -1, when using ItemStateChunk).", -2) return -1 end
  if type(statechunk)~="string" and item==-1 then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "statechunk", "Must be a string", -3) return -1 end
  if item==-1 and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "statechunk", "Must be a valid MediaItemStateChunk", -4) return -1 end
  local _bool, bool
  if item~=-1 then item=reaper.GetMediaItem(0,item-1) _bool, statechunk=reaper.GetItemStateChunk(item,"",false) end
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "state", "Must be an integer", -5) return -1 end
  if state~=0 and state~=1 then ultraschall.AddErrorMessage("SetItemSpectralVisibilityState", "state", "Must be 1 or 0", -6) return -1 end
  
  if statechunk:match("SPECTROGRAM")~=nil and state==0 then 
    statechunk,temp=statechunk:match("(.-)SPECTROGRAM .-%c(.*)")
    statechunk=statechunk..temp
  elseif statechunk:match("SPECTROGRAM")==nil and state==1 then 
    statechunk, temp=statechunk:match("(.-IID.-%c).-(NAME.*)")
    statechunk=statechunk.."SPECTROGRAM 1\n"..temp
  end
  if item~=-1 then reaper.SetItemStateChunk(item,statechunk,true) end
  return statechunk
end


function ultraschall.SetItemSpectralEdit(itemidx, spectralidx, start_pos, length, gain, fade, freq_fade, freq_range_bottom, freq_range_top, h, byp_solo, gate_thres, gate_floor, comp_thresh, comp_exp_ratio, n, o, fade2, freq_fade2, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemSpectralEdit</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemSpectralEdit(integer itemidx, integer spectralidx, number start_pos, number length, number gain, number fade, number freq_fade, number freq_range_bottom, number freq_range_top, integer h, integer byp_solo, number gate_thres, number gate_floor, number comp_thresh, number comp_exp_ratio, number n, number o, number fade2, number freq_fade2, optional string MediaItemStateChunk)</functioncall>
  <description>
    Sets a spectral-edit-instance in a MediaItem or MediaItemStateChunk.
    
    After committing the changed MediaItemStateChunk to a MediaItem, Reaper may change the order of the spectral-edits! Keep that in mind, when changing numerous Spectral-Edits or use MediaItemStateChunks for the setting before committing them to a MediaItem using Reaper's function reaper.SetItemStateChunk().
    
    It returns the modified MediaItemStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    integer itemidx - the number of the item in the project; use -1 to use MediaItemStateChunk instead
    integer spectralidx - the number of the spectral-edit-instance, that you want to set
    number start_pos - the startposition of the spectral-edit-region in seconds
    number length - the length of the spectral-edit-region in seconds
    number gain - the gain as slider-value; 0(-224dB) to 98350.1875(99.68dB); 1 for 0dB
    number fade - 0(0%)-0.5(100%); adjusting this affects also parameter fade2!
    number freq_fade - 0(0%)-0.5(100%); adjusting this affects also parameter freq_fade2!
    number freq_range_bottom - the bottom of the edit-region, but can be moved to be top as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    number freq_range_top - the top of the edit-region, but can be moved to be bottom as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    integer h - unknown
    integer byp_solo - sets the solo and bypass-state. 0, no solo, no bypass; 1, bypass only; 2, solo only; 3, bypass and solo
    number gate_thres - sets the threshold of the gate; 0(-224dB)-98786.226563(99.89dB)
    number gate_floor - sets the floor of the gate; 0(-224dB)-99802.171875(99.98dB)
    number comp_thresh - sets the threshold for the compressor; 0(-224dB)-98842.484375(99.90dB); 1(0dB)is default
    number comp_exp_ratio - sets the ratio of the compressor/expander; 0.1(1:10.0)-100(100:1.0); 1(1.0:1) is default
    number n - unknown
    number o - unknown
    number fade2 - negative with fade_in set; positive with fadeout-set
    number freq_fade2 - negative with low frequency-fade, positive with high-frequency-fade
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, rppxml, state, chunk, spectraledit, edit, set</tags>
</US_DocBloc>
]]
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "itemidx", "Must be an integer; -1, to use trackstatechunk.", -1) return -1 end
  if itemidx~=-1 and reaper.ValidatePtr2(0, reaper.GetMediaItem(0,itemidx-1), "MediaItem*")==false then ultraschall.AddErrorMessage("SetItemSpectralEdit", "itemidx", "Must be a valid MediaItem-idx or -1, when using ItemStateChunk).", -2) return -1 end
  if type(statechunk)~="string" and itemidx==-1 then ultraschall.AddErrorMessage("SetItemSpectralEdit", "statechunk", "Must be a string", -3) return -1 end

  local _bool, item2, count
  item2=itemidx
  if itemidx~=-1 then itemidx=reaper.GetMediaItem(0,itemidx-1) _bool, statechunk=reaper.GetItemStateChunk(itemidx,"",false) end
  if math.type(spectralidx)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "spectralidx", "Must be an integer", -7) return -1 end
  if type(start_pos)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "start_pos", "Must be a number", -8) return -1 end
  if type(length)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "length", "Must be a number", -9) return -1 end
  if type(gain)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "gain", "Must be a number", -10) return -1 end
  if type(fade)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "fade", "Must be a number", -11) return -1 end
  if type(freq_fade)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "freq_fade", "Must be a number", -12) return -1 end
  if type(freq_range_bottom)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "freq_range_bottom", "Must be a number", -13) return -1 end
  if type(freq_range_top)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "freq_range_top", "Must be a number", -14) return -1 end
  if math.type(h)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "h", "Must be an integer", -15) return -1 end
  if math.type(byp_solo)~="integer" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "byp_solo", "Must be an integer", -16) return -1 end
  if type(gate_thres)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "gate_thres", "Must be a number", -17) return -1 end
  if type(gate_floor)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "gate_floor", "Must be a number", -18) return -1 end
  if type(comp_thresh)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "comp_thresh", "Must be a number", -19) return -1 end
  if type(comp_exp_ratio)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "comp_exp_ratio", "Must be a number", -20) return -1 end
  if type(n)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "n", "Must be a number", -21) return -1 end
  if type(o)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "o", "Must be a number", -22) return -1 end
  if type(fade2)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "fade2", "Must be a number", -23) return -1 end
  if type(freq_fade2)~="number" then ultraschall.AddErrorMessage("SetItemSpectralEdit", "freq_fade2", "Must be a number", -24) return -1 end

  count = ultraschall.CountItemSpectralEdits(item2, statechunk)
  if spectralidx>count then ultraschall.AddErrorMessage("SetItemSpectralEdit", "spectralidx", "No such spectral edit available", -25) return -1 end
  
  local new_entry="SPECTRAL_EDIT "..start_pos.." "..length.." "..gain.." "..fade.." "..freq_fade.." "..freq_range_bottom.." "..freq_range_top.." "..h.." "..byp_solo.." "..gate_thres.." "..gate_floor.." "..comp_thresh.." "..comp_exp_ratio.." "..n.." "..o.." "..fade2.." "..freq_fade2
  local part1, part2=statechunk:match("(.-)(SPECTRAL_EDIT.*)")
  
  for i=1, spectralidx-1 do
    part1=part1..part2:match("(SPECTRAL_EDIT.-%c)")
    part2=part2:match("SPECTRAL_EDIT.-%c(.*)")
  end

  statechunk=part1..new_entry.."\n"..part2:match("SPECTRAL_EDIT.-%c(.*)")
  
  if itemidx~=-1 then reaper.SetItemStateChunk(itemidx,statechunk,true) end
  return statechunk
end

function ultraschall.GetItemSourceFile_Take(MediaItem, take_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSourceFile_Take</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string source_filename, PCM_source source, MediaItem_Take take = ultraschall.GetItemSourceFile_Take(MediaItem MediaItem, integer take_nr)</functioncall>
  <description>
    returns filename, the PCM_Source-object and the MediaItem_Take-object of a specific take. Use take_nr=0 for active take.
    
    returns nil in case of error
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem-object, in which the requested take lies
    integer take_nr - the number of the requested take; use 0 for the active take
  </parameters>
  <retvals>
    string source_filename - the filename of the requested take
    PCM_source source - the PCM_source-object of the requested take
    MediaItem_Take take - the Media-Item_Take-object of the requested take
  </retvals>
  <chapter_context>
    MediaItem Management
    MediaItem-Takes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, track, get, item, mediaitem, take, pcmsource, filename</tags>
</US_DocBloc>
--]]
  -- check parameters
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")~=true then ultraschall.AddErrorMessage("GetItemSourceFile_Take", "MediaItem", "must be a MediaItem-object", -1) return nil end
  if math.type(take_nr)~="integer" then ultraschall.AddErrorMessage("GetItemSourceFile_Take", "take_nr", "must be an integer; 0 for active take", -2) return nil end
  
  -- get correct MediaItem_Take-object
  local MediaItem_Take
  if take_nr>0 then MediaItem_Take = reaper.GetMediaItemTake(MediaItem, take_nr-1)
  elseif take_nr==0 then MediaItem_Take=reaper.GetActiveTake(MediaItem)
  end
  if MediaItem_Take==nil then ultraschall.AddErrorMessage("GetItemSourceFile_Take", "take_nr", "no such take", -3) return nil end  

  -- get the pcm-source, the source-filename and return it with the MediaItem_Take-object
  local PCM_source=reaper.GetMediaItemTake_Source(MediaItem_Take)
  local filenamebuf = reaper.GetMediaSourceFileName(PCM_source, "")
  
  return filenamebuf, PCM_source, MediaItem_Take
end

--MediaItem=reaper.GetMediaItem(0,1)
--A,A2,A3 = ultraschall.GetItemSourceFile_Take(MediaItem, -1)

function ultraschall.AddItemSpectralEdit(itemidx, start_pos, length, gain, fade, freq_fade, freq_range_bottom, freq_range_top, h, byp_solo, gate_thres, gate_floor, comp_thresh, comp_exp_ratio, n, o, fade2, freq_fade2, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddItemSpectralEdit</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval, MediaItemStateChunk statechunk = ultraschall.AddItemSpectralEdit(integer itemidx, number start_pos, number length, number gain, number fade, number freq_fade, number freq_range_bottom, number freq_range_top, integer h, integer byp_solo, number gate_thres, number gate_floor, number comp_thresh, number comp_exp_ratio, number n, number o, number fade2, number freq_fade2, optional string MediaItemStateChunk)</functioncall>
  <description>
    Adds a new SPECTRAL_EDIT-entry in a given MediaItem/MediaItemStateChunk.
    The SPECTRAL_EDITs are the individual edit-boundary-boxes in the spectral-view.
    If itemidx is set to -1, you can give the function a MediaItemStateChunk to look in, instead.
    
    returns false in case of error
  </description>
  <parameters>
    integer itemidx - the MediaItem to add to another spectral-edit-entry; -1, to use the parameter MediaItemStateChunk instead
    number start_pos - the startposition of the spectral-edit-region in seconds
    number length - the length of the spectral-edit-region in seconds
    number gain - the gain as slider-value; 0(-224dB) to 98350.1875(99.68dB); 1 for 0dB
    number fade - 0(0%)-0.5(100%); adjusting this affects also parameter fade2!
    number freq_fade - 0(0%)-0.5(100%); adjusting this affects also parameter freq_fade2!
    number freq_range_bottom - the bottom of the edit-region, but can be moved to be top as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    number freq_range_top - the top of the edit-region, but can be moved to be bottom as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    integer h - unknown
    integer byp_solo - sets the solo and bypass-state. 0, no solo, no bypass; 1, bypass only; 2, solo only; 3, bypass and solo
    number gate_thres - sets the threshold of the gate; 0(-224dB)-98786.226563(99.89dB)
    number gate_floor - sets the floor of the gate; 0(-224dB)-99802.171875(99.98dB)
    number comp_thresh - sets the threshold for the compressor; 0(-224dB)-98842.484375(99.90dB); 1(0dB)is default
    number comp_exp_ratio - sets the ratio of the compressor/expander; 0.1(1:10.0)-100(100:1.0); 1(1.0:1) is default
    number n - unknown
    number o - unknown
    number fade2 - negative with fade_in set; positive with fadeout-set
    number freq_fade2 - negative with low frequency-fade, positive with high-frequency-fade
    string MediaItemStateChunk - if itemidx is -1, this can be a MediaItemStateChunk to use, otherwise this will be ignored
  </parameters>
  <retvals>
    boolean retval - true, if adding was successful; false, if adding wasn't successful
    optional MediaItemStateChunk statechunk - the altered MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, add, item, spectral edit</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "itemidx", "must be an integer", -18) return false end
  if type(start_pos)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "start_pos", "must be a number", -1) return false end
  if type(length)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "length", "must be a number", -2) return false end
  if type(gain)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "gain", "must be a number", -3) return false end
  if type(fade)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "fade", "must be a number", -4) return false end
  if type(freq_fade)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "freq_fade", "must be a number", -5) return false end
  if type(freq_range_bottom)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "freq_range_bottom", "must be a number", -6) return false end
  if type(freq_range_top)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "freq_range_top", "must be a number", -7) return false end
  if math.type(h)~="integer" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "h", "must be an integer", -8) return false end
  if math.type(byp_solo)~="integer" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "byp_solo", "must be an integer", -9) return false end
  if type(gate_thres)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "gate_thres", "must be a number", -10) return false end
  if type(gate_floor)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "gate_floor", "must be a number", -11) return false end
  if type(comp_thresh)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "comp_thresh", "must be a number", -12) return false end
  if type(comp_exp_ratio)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "comp_exp_ratio", "must be a number", -13) return false end
  if type(n)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "n", "must be a number", -14) return false end
  if type(o)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "o", "must be a number", -15) return false end
  if type(fade2)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "fade2", "must be a number", -16) return false end
  if type(freq_fade2)~="number" then ultraschall.AddErrorMessage("AddItemSpectralEdit", "freq_fade2", "must be a number", -17) return false end
  if itemidx==-1 and (type(MediaItemStateChunk)~="string" or MediaItemStateChunk:match("<ITEM.*>")==nil) then ultraschall.AddErrorMessage("AddItemSpectralEdit", "MediaItemStateChunk", "must be a MediaItemStateChunk", -19) return false end

  -- prepare variables
  local MediaItem, _l

  -- get MediaItemStateChunk, if necessary
  if itemidx~=-1 then 
    MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _l, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem, "", false)
  end

  -- add new Spectral-Edit-entry
  MediaItemStateChunk=MediaItemStateChunk:match("(.*)>")..
                       "SPECTRAL_EDIT "..start_pos.." "..length.." "..gain.." "..fade.." "..freq_fade.." "..freq_range_bottom.." "..freq_range_top.." "..h.." "..
                       byp_solo.." "..gate_thres.." "..gate_floor.." "..comp_thresh.." "..comp_exp_ratio.." "..n.." "..o.." "..fade2.." "..freq_fade2.."\n>"
                       
  -- add changed statechunk to the item, if necessary
  if itemidx~=-1 then reaper.SetItemStateChunk(MediaItem, MediaItemStateChunk, false) end
  return true, MediaItemStateChunk
end


--LL=ultraschall.AddItemSpectralEdit(1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9, "<ITEM>")

function ultraschall.GetItemSpectralVisibilityState(itemidx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralVisibilityState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer spectrogram_state = ultraschall.GetItemSpectralVisibilityState(integer itemidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    returns, if spectral-editing is shown in the arrange-view of item itemidx
    set itemidx to -1 to use the optional parameter MediaItemStateChunk to alter a MediaItemStateChunk instead of an item directly.
    
    returns -1 in case of error
  </description>
  <parameters>
    integer itemidx - the number of the item, with 1 for the first item, 2 for the second, etc.; -1, to use the parameter MediaItemStateChunk
    optional string MediaItemStateChunk - you can give a MediaItemStateChunk to process, if itemidx is set to -1
  </parameters>
  <retvals>
    integer item_spectral_config - 0, if spectral-config isn't shown in arrange-view; 1, if spectral-config is shown in arrange-view
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, spectral edit, spectogram, show</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(itemidx)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralVisibilityState","itemidx", "only integer allowed", -1) return -1 end
  if itemidx~=-1 and itemidx<1 or itemidx>reaper.CountMediaItems(0) then ultraschall.AddErrorMessage("GetItemSpectralVisibilityState","itemidx", "no such item exists", -2) return -1 end
  if itemidx==-1 and tostring(MediaItemStateChunk):match("<ITEM.*>")==nil then ultraschall.AddErrorMessage("GetItemSpectralVisibilityState","MediaItemStateChunk", "must be a valid MediaItemStateChunk", -5) return -1 end

  -- get statechunk, if necessary(itemidx~=-1)
  local _retval
  if itemidx~=-1 then 
    local MediaItem=reaper.GetMediaItem(0,itemidx-1)
    _retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem,"",false)
  end
  
  -- get the value of SPECTROGRAM and return it
  local retval=MediaItemStateChunk:match("SPECTROGRAM (.-)%c")
  if retval==nil then retval=0 end
  return tonumber(retval)
end

--L=ultraschall.GetItemSpectralVisibilityState(-1, "<ITEM\nSPECTROGRAM 1\n>")

--L,LL,LLL=ultraschall.GetAllEntriesFromTable(ultraschall)



function ultraschall.InsertImageFile(filename_with_path, track, position, length, looped)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertImageFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval, MediaItem item = ultraschall.InsertImageFile(string filename_with_path, integer track, number position, number length, boolean looped)</functioncall>
  <description>
    Inserts a supported image-file into your project.
    Due API-limitations, it creates two undo-points(one for inserting the MediaItem and one for changing the length).
    
    Returns false in case of an error
  </description>
  <parameters>
    string filename_with_path - the file to check for it's image-fileformat
    integer track - the track, in which the image shall be inserted
    number position - the position of the inserted image in seconds
    number length - the length of the image-item in seconds; 1, for the default length of 1 second
    boolean looped - true, loop the inserted image-file; false, don't loop the inserted image-file
  </parameters>
  <retvals>
    boolean retval - true, if inserting was successful; false, if inserting was unsuccessful
    MediaItem item - the MediaItem of the newly inserted image
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>markermanagement, insert, mediaitem, position, mediafile, image, loop</tags>
</US_DocBloc>
--]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("InsertImageFile","filename_with_path", "Must be a string!", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("InsertImageFile","filename_with_path", "File does not exist!", -2) return false end
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("InsertImageFile","track", "Must be an integer!", -3) return false end
  if track<1 then ultraschall.AddErrorMessage("InsertImageFile","track", "Must be bigger than 0!", -4) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertImageFile","position", "Must be a number!", -5) return false end
  if position<0 then ultraschall.AddErrorMessage("InsertImageFile","position", "Must be bigger than/equal 0!", -6) return false end
  if type(length)~="number" then ultraschall.AddErrorMessage("InsertImageFile","length", "Must be a number!", -7) return false end
  if length<0 then ultraschall.AddErrorMessage("InsertImageFile","length", "Must be bigger than/equal 0!", -8) return false end
  if type(looped)~="boolean" then ultraschall.AddErrorMessage("InsertImageFile","looped", "Must be boolean!", -9) return false end
  
  local fileext, supported, filetype = ultraschall.CheckForValidFileFormats(filename_with_path)  
  if filetype~="Image" then ultraschall.AddErrorMessage("InsertImageFile","filename_with_path", "Not a supported image-file!", -10) return false end
  local retval, item, ollength, numchannels, Samplerate, Filetype = ultraschall.InsertMediaItemFromFile(filename_with_path, track, position, length, 0)
  
--  reaper.SetMediaItemInfo_Value(item, "D_LENGTH", length)
  if looped==true then reaper.SetMediaItemInfo_Value(item, "B_LOOPSRC", 1) end
  return true, item
end

--ultraschall.InsertImageFile("c:\\us.png", 3, 20, 100, false)


function ultraschall.GetAllSelectedMediaItems()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllSelectedMediaItems</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetAllSelectedMediaItems()</functioncall>
  <description>
    Returns all selected items in the project as MediaItemArray. Empty MediaItemAray if none is found.
  </description>
  <retvals>
    integer count - the number of entries in the returned MediaItemArray
    array MediaItemArray - all selected MediaItems returned as an array
    array MediaItemStateChunkArray - the statechunks of all found MediaItems as an array
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, get, all, selected, selection, statechunk</tags>
</US_DocBloc>
]]
  -- prepare variables
  local selitemcount=reaper.CountSelectedMediaItems(0)
  local selitemarray={}
  local selitemarraystatechunk={}
  local temp
  
  -- get all selected mediaitems and put them into the array
  for i=0, selitemcount-1 do
    selitemarray[i+1]=reaper.GetSelectedMediaItem(0, i)
    temp, selitemarraystatechunk[i+1]=reaper.GetItemStateChunk(selitemarray[i+1],"",false)
    selitemarraystatechunk[i+1] = ultraschall.SetItemUSTrackNumber_StateChunk(selitemarraystatechunk[i+1], ultraschall.GetParentTrack_MediaItem(selitemarray[i+1]))
  end
  return selitemcount, selitemarray, selitemarraystatechunk
end

--A,B=ultraschall.GetAllSelectedMediaItems()

function ultraschall.SetMediaItemsSelected_TimeSelection(inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetMediaItemsSelected_TimeSelection</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.SetMediaItemsSelected_TimeSelection(optional boolean inside)</functioncall>
  <description>
    Sets all MediaItems selected, that are within the time-selection.
  </description>
  <parameters>
    optional boolean inside - true, select only items completely inside the time-selection; false or nil, include also items, that are partially inside the time-selection
  </parameters>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, set, selected, item, mediaitem, timeselection</tags>
</US_DocBloc>
]]  
  --reaper.Main_OnCommand(40717,0)
  local startpos, endpos = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  for i=0, reaper.CountMediaItems(0)-1 do
    local pos=reaper.GetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "D_POSITION")
    local len=reaper.GetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "D_LENGTH")
    if pos>=startpos and pos+len<=endpos then
      reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 1)
    elseif inside==false and pos+len>=startpos and pos+len<=endpos then
      reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 1)
    elseif inside==false and pos>=startpos and pos<=endpos then
      reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 1)
    end
  end
  reaper.UpdateArrange()
end

function ultraschall.GetParentTrack_MediaItem(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetParentTrack_MediaItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer tracknumber, MediaTrack mediatrack = ultraschall.GetParentTrack_MediaItem(MediaItem MediaItem)</functioncall>
  <description>
    Returns the tracknumber and the MediaTrack-object of the track in which the MediaItem is placed.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer tracknumber - the tracknumber of the track, in which the MediaItem is placed; 1 for track 1, 2 for track 2, etc
    MediaTrack mediatrack - the MediaTrack-object of the track, in which the MediaItem is placed
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, of which you want to know the track is is placed in
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, parent, track, item, mediaitem, mediatrack</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("GetParentTrack_MediaItem","MediaItem", "Must be a MediaItem!", -1) return -1 end
  
  local MediaTrack = reaper.GetMediaItemTake_Track(reaper.GetMediaItemTake(MediaItem,0))
  
  return math.tointeger(reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")), MediaTrack
end

--A,B=ultraschall.GetParentTrack_MediaItem(reaper.GetMediaItem(0,1))

function ultraschall.IsItemInTrack2(MediaItem, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsItemInTrack2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer tracknumber = ultraschall.IsItemInTrack2(MediaItem MediaItem, integer tracknumber)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Checks, whether a MediaItem is in track with tracknumber.
    
    see [IsItemInTrack](#IsItemInTrack) to use itemidx instead of the MediaItem-object.
    see [IsItemInTrack3](#IsItemInTrack3) to check against multiple tracks at once using a trackstring.
    
    returns nil in case of error
  </description>
  <retvals>
    boolean retval - true, if item is in track; false, if not
    integer tracknumber - the tracknumber of the track, in which the item lies
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, of which you want to know the track is is placed in
    integer tracknumber - the tracknumber to check the parent track of the MediaItem against, with 1 for track 1, etc
  </parameters>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>helperfunctions, check, item, track</tags>
</US_DocBloc>
]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsItemInTrack2","tracknumber", "Must be an integer!", -1) return end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsItemInTrack2","tracknumber", "No such track!", -2) return end
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("IsItemInTrack2","MediaItem", "Must be a MediaItem!", -3) return end
  
  -- prepare vaiable
  local itemtracknumber=ultraschall.GetParentTrack_MediaItem(MediaItem)
  
  -- check if item is in track
  if tracknumber==itemtracknumber then return true, itemtracknumber
  else return false, itemtracknumber
  end
end

--A,B=ultraschall.IsItemInTrack2(reaper.GetMediaItem(0,0),1)

function ultraschall.IsItemInTimerange(MediaItem, startposition, endposition, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsItemInTimerange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsItemInTimerange(MediaItem MediaItem, number startposition, number endposition, boolean inside)</functioncall>
  <description>
    checks, whether a given MediaItem is within startposition and endposition and returns the result.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, item is in timerange; false, item isn't in timerange
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem to check for, if it's within the timerange
    number startposition - the starttime of the timerange, in which the MediaItem must be, in seconds
    number endposition - the endtime of the timerange, in which the MediaItem must be, in seconds
    boolean inside - true, MediaItem must be fully within timerange; false, MediaItem can be partially inside timerange
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, check, timerange, tracks, mediaitems</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("IsItemInTimerange","startposition", "Must be a number!", -1) return end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("IsItemInTimerange","endposition", "Must be a number!", -2) return end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("IsItemInTimerange","inside", "Must be a boolean!", -3) return end
  if startposition>endposition then ultraschall.AddErrorMessage("IsItemInTimerange","startposition", "Must be smaller or equal endposition!", -4) return end
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("IsItemInTimerange","MediaItem", "Must be a MediaItem!", -5) return end  
  
  -- prepare variables
  local itemstartposition=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
  local itemendposition=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")+itemstartposition
  
  -- check, if the item is in tiumerange
  if inside==true then -- if fully within timerange
    if itemstartposition>=startposition and itemendposition<=endposition then return true else return false end
  else -- if also partially within timerange
    if itemstartposition>endposition or itemendposition<startposition then return false
    else return true
    end
  end
end


function ultraschall.OnlyItemsInTracksAndTimerange(MediaItemArray, trackstring, starttime, endtime, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyItemsInTracksAndTimerange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, MediaItemArray MediaItemArray = ultraschall.OnlyItemsInTracksAndTimerange(MediaItemArray MediaItemArray, string trackstring, number starttime, number endtime, boolean inside)</functioncall>
  <description>
    Removes all items from MediaItemArray, that aren't in tracks, as given by trackstring and are outside the timerange(starttime to endtime).
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of items that fit the requested tracks and timerange
    MediaItemArray MediaItemArray - the altered MediaItemArray, that has only the MediaItems from tracks as requested by trackstring and from within timerange
  </retvals>
  <parameters>
    MediaItemArray MediaItemArray - an array with all MediaItems, that shall be checked for trackexistence and timerange
    string trackstring - a string with all requested tracknumbers in which the MediaItem must be, separated by commas; 1 for track 1, 2 for track 2, etc
    number starttime - the starttime of the timerange, in which the MediaItem must be, in seconds
    number endtime - the endtime of the timerange, in which the MediaItem must be, in seconds
    boolean inside - true, only MediaItems are returned, that are fully within starttime and endtime; false, return also MediaItems partially in timerange
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, check, alter, timerange, tracks, mediaitem, mediaitemarray</tags>
</US_DocBloc>
]]
  -- check parameters
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("OnlyItemsInTracksAndTimerange","MediaItemArray", "No valid MediaItemArray!", -1) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("OnlyItemsInTracksAndTimerange","trackstring", "No valid trackstring!", -2) return -1 end
  if type(starttime)~="number" then ultraschall.AddErrorMessage("OnlyItemsInTracksAndTimerange","starttime", "Must be a number!", -3) return -1 end
  if type(endtime)~="number" then ultraschall.AddErrorMessage("OnlyItemsInTracksAndTimerange","endtime", "Must be a number!", -4) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("OnlyItemsInTracksAndTimerange","inside", "Must be a boolean!", -5) return -1 end
  
  -- prepare variables
  local count=1
  local count2=0
  local NewMediaItemArray={}
  
  -- check if the MediaItems are within tracks and timerange and put the "valid" ones into NewMediaItemArray
  while MediaItemArray[count]~=nil do
    if ultraschall.IsItemInTrack3(MediaItemArray[count], trackstring)==true 
      and ultraschall.IsItemInTimerange(MediaItemArray[count], starttime, endtime, inside)==true 
      then 
      count2=count2+1
      NewMediaItemArray[count2]=MediaItemArray[count]    
    end
    count=count+1
  end
  return count2, NewMediaItemArray
end



function ultraschall.ApplyActionToMediaItem(MediaItem, actioncommandid, repeat_action, midi, MIDI_hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyActionToMediaItem</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToMediaItem(MediaItem MediaItem, string actioncommandid, integer repeat_action, boolean midi, optional HWND MIDI_hwnd)</functioncall>
  <description>
    Applies an action to a MediaItem, in either main or MIDI-Editor section-context.
    The action given must support applying itself to selected items.    
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running the action was successful; false, if not or an error occured
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, to whom the action shall be applied to
    string actioncommandid - the commandid-number or ActionCommandID, that shall be run.
    integer repeat_action - the number of times this action shall be applied to each item; minimum value is 1
    boolean midi - true, run an action from MIDI-Editor-section-context; false, run an action from the main section
    optional HWND MIDI_hwnd - the HWND-handle of the MIDI-Editor, to which a MIDI-action shall be applied to; nil, to use the currently selected one
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, run, action, midi, main, midieditor, item, mediaitem</tags>
</US_DocBloc>
]]
  -- check parameters
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("ApplyActionToMediaItem","MediaItem", "Must be a MediaItem!", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItem","actioncommandid", "No such action registered!", -2) return false end
  if type(midi)~="boolean" then ultraschall.AddErrorMessage("ApplyActionToMediaItem","midi", "Must be boolean!", -3) return false end
  if math.type(repeat_action)~="integer" then ultraschall.AddErrorMessage("ApplyActionToMediaItem","repeat_action", "Must be an integer!", -4) return false end
  if repeat_action<1 then ultraschall.AddErrorMessage("ApplyActionToMediaItem","repeat_action", "Must be bigger than 0!", -5) return false end

  -- get old item-selection, delete item selection, select MediaItem
  reaper.PreventUIRefresh(1)
  local oldcount, oldselection = ultraschall.GetAllSelectedMediaItems()
  for i=1, #oldselection do
    reaper.SetMediaItemInfo_Value(oldselection[i], "B_UISEL", 0)
  end
  reaper.SetMediaItemSelected(MediaItem, true)
  if type(actioncommandid)=="string" then actioncommandid=reaper.NamedCommandLookup(actioncommandid) end -- get command-id-number from named actioncommandid

  -- run the action for repeat_action-times
  for i=1, repeat_action do
    if midi==true then 
      reaper.MIDIEditor_OnCommand(MIDI_hwnd, actioncommandid)
    else
      reaper.Main_OnCommand(actioncommandid, 0)
    end
  end
  -- restore old item-selection
  for i=1, reaper.CountMediaItems(0)-1 do
    reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)
  end
  ultraschall.SelectMediaItems_MediaItemArray(oldselection)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  return true
end

--MediaItem=reaper.GetMediaItem(0,0)
--ultraschall.ApplyActionToMediaItem(MediaItem, "_XENAKIOS_MOVEITEMSLEFTBYLEN", 2, false, reaper.MIDIEditor_GetActive())


function ultraschall.ApplyActionToMediaItemArray(MediaItemArray, actioncommandid, repeat_action, midi, MIDI_hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyActionToMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToMediaItemArray(MediaItemArray MediaItemArray, string actioncommandid, integer repeat_action, boolean midi, optional HWND MIDI_hwnd)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Applies an action to the MediaItems in MediaItemArray, in either main or MIDI-Editor section-context
    The action given must support applying itself to selected items.
    
    This function applies the action to each MediaItem individually. To apply the action to all MediaItems in MediaItemArray at once, see <a href="#ApplyActionToMediaItemArray2">ApplyActionToMediaItemArray2</a>.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running the action was successful; false, if not or an error occured
  </retvals>
  <parameters>
    MediaItemArray MediaItemArray - an array with all MediaItems, to whom the action shall be applied to
    string actioncommandid - the commandid-number or ActionCommandID, that shall be run.
    integer repeat_action - the number of times this action shall be applied to each item; minimum value is 1
    boolean midi - true, run an action from MIDI-Editor-section-context; false, run an action from the main section
    optional HWND MIDI_hwnd - the HWND-handle of the MIDI-Editor, to which a MIDI-action shall be applied to; nil, to use the currently selected one
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, run, action, midi, main, midieditor, item, mediaitemarray</tags>
</US_DocBloc>
]]
  -- check parameters
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray","MediaItemArray", "No valid MediaItemArray!", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray","actioncommandid", "No such action registered!", -2) return false end
  if type(midi)~="boolean" then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray","midi", "Must be boolean!", -3) return false end
  if math.type(repeat_action)~="integer" then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray","repeat_action", "Must be an integer!", -4) return false end
  if repeat_action<1 then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray","repeat_action", "Must be bigger than 0!", -5) return false end
  
  -- prepare variable
  local count=1
  
  -- apply action to every MediaItem in MediaItemAray repeat_action times
  while MediaItemArray[count]~=nil do
    for i=1, repeat_action do
      ultraschall.ApplyActionToMediaItem(MediaItemArray[count], actioncommandid, repeat_action, midi, MIDI_hwnd)
    end
    count=count+1
  end
  return true
end


--A,B=ultraschall.GetAllMediaItemsBetween(1,40000,"1,2",true)
--ultraschall.ApplyActionToMediaItemArray(B, 40123, 10, false, MIDI_hwnd)




function ultraschall.GetAllMediaItemsInTimeSelection(trackstring, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemsInTimeSelection</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray = ultraschall.GetAllMediaItemsInTimeSelection(string trackstring, boolean inside)</functioncall>
  <description>
    Gets all MediaItems from within a time-selection
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer count - the number of items found in time-selection
    array MediaItemArray - an array with all MediaItems found within time-selection
  </retvals>
  <parameters>
    string trackstring - a string with all tracknumbers, separated by a comma; 1 for the first track, 2 for the second
  </parameters>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, items, time, selection</tags>
</US_DocBloc>
]]
  -- check parameters
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetAllMediaItemsInTimeSelection","trackstring", "Must be a valid trackstring!", -1) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("GetAllMediaItemsInTimeSelection","inside", "Must be boolean!", -2) return -1 end
  
  -- prepare variables
  local oldcount, oldselection = ultraschall.GetAllSelectedMediaItems()
  local starttime, endtime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  
  -- Do the selection
reaper.PreventUIRefresh(1)

  local oldcount, oldselection = ultraschall.GetAllSelectedMediaItems()
  for i=1, #oldselection do
    reaper.SetMediaItemInfo_Value(oldselection[i], "B_UISEL", 0)
  end
  
  ultraschall.SetMediaItemsSelected_TimeSelection(inside) -- select only within time-selection

  local count, MediaItemArray=ultraschall.GetAllSelectedMediaItems() -- get all selected items
  
  if MediaItemArray[1]==nil then 
  else   
    -- check, whether the item is in a track, as demanded by trackstring
    for i=count, 1, -1 do
      if ultraschall.IsItemInTrack3(MediaItemArray[i], trackstring)==false then 
        table.remove(MediaItemArray, i) 
        count=count-1 
      end
    end
  end
    
  -- reset old selection, redraw arrange and return what has been found
  for i=1, reaper.CountMediaItems(0)-1 do
    reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)
  end
  ultraschall.SelectMediaItems_MediaItemArray(oldselection)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  
  return #MediaItemArray, MediaItemArray
end

--A,B=ultraschall.GetAllMediaItemsInTimeSelection("2", false)


function ultraschall.NormalizeItems(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>NormalizeItems</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.NormalizeItems(array MediaItemArray)</functioncall>
  <description>
    Normalizes all items in MediaItemArray.
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of an error
  </retvals>
  <parameters>
    array MediaItemArray - an array with all MediaItems, that shall be normalized
  </parameters>
  <chapter_context>
    MediaItem Management
    Manipulate
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, normalize, items</tags>
</US_DocBloc>
]]
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("NormalizeItems","MediaItemArray", "No valid MediaItemArray!", -1) return -1 end
  ultraschall.ApplyActionToMediaItemArray(MediaItemArray, 40108, 1, false)
end

--A,B=ultraschall.GetAllMediaItemsInTimeSelection("1,2", false)
--ultraschall.NormalizeItems(B)


function ultraschall.ChangePathInSource(PCM_source, NewPath)
  local Filenamebuf = reaper.GetMediaSourceFileName(PCM_source, "")
  local filename=Filenamebuf:match(".*/(.*)")
  if filename==nil then filename=Filenamebuf:match(".*\\(.*)") end
  filename=NewPath.."/"..filename
  return reaper.PCM_Source_CreateFromFile(filename)
end

--NewSource=ultraschall.ChangePathInSource(reaper.GetMediaItemTake_Source(reaper.GetMediaItemTake(reaper.GetMediaItem(0,0),0)), "c:\\temp")

function ultraschall.GetAllMediaItems()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItems</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer itemcount, MediaItemArray MediaItemArray = ultraschall.GetAllMediaItems()</functioncall>
  <description>
    Returns a MediaItemArray with all MediaItems in the current project
  </description>
  <retvals>
    integer itemcount - the number of items in the MediaItemArray
    MediaItemArray MediaItemArray - an array with all MediaItems from the current project
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, all, mediaitems, mediaitemarray</tags>
</US_DocBloc>
--]]
  local MediaItemArray={}
  for i=0, reaper.CountMediaItems(0) do
    MediaItemArray[i+1]=reaper.GetMediaItem(0,i)
  end
  return reaper.CountMediaItems(0), MediaItemArray
end


--A,B=ultraschall.GetAllMediaItems()


function ultraschall.PreviewMediaItem(MediaItem, Previewtype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PreviewMediaItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    SWS=2.9.8
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.PreviewMediaItem(MediaItem MediaItem, integer Previewtype)</functioncall>
  <description>
    Will play a preview a given MediaItem.
    You can just play one preview at a time, except when previewing additionally through the MediaExplorer.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - false, in case of error; true, in case of success
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, of which you want to play a preview
    integer Previewtype - the type of the preview
                        - 0, Preview the MediaItem in the Media Explorer
                        - 1, Preview the MediaItem
                        - 2, Preview the MediaItem at track fader volume of the track, in which it lies
                        - 3, Preview the MediaItem through the track, in which it lies(including FX-settings)
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, preview, audio, mediaitem, track, mediaexplorer</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0,MediaItem,"MediaItem*")==false then ultraschall.AddErrorMessage("PreviewMediaItem", "MediaItem", "Must be a valid MediaItem.", -1) return false end
  if math.type(Previewtype)~="integer" then ultraschall.AddErrorMessage("PreviewMediaItem", "Previewtype", "Must be an integer.", -2) return false end
  if Previewtype<0 or Previewtype>3 then ultraschall.AddErrorMessage("PreviewMediaItem", "Previewtype", "Must be between 0 and 3.", -3) return false end
  if Previewtype==0 then Previewtype=41623 -- Media explorer: Preview media item source media
  elseif Previewtype==1 then Previewtype="_XENAKIOS_ITEMASPCM1" -- Xenakios/SWS: Preview selected media item
  elseif Previewtype==2 then Previewtype="_SWS_PREVIEWFADER" -- Xenakios/SWS: Preview selected media item at track fader volume
  elseif Previewtype==3 then Previewtype="_SWS_PREVIEWTRACK" -- Xenakios/SWS: Preview selected media item through track
  end
  
  return ultraschall.ApplyActionToMediaItem(MediaItem, Previewtype, 1, false) 
end

--MediaItem1=reaper.GetMediaItem(0,0)
--ultraschall.PreviewMediaItem(MediaItem1, 0)

function ultraschall.StopAnyPreview()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StopAnyPreview</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StopAnyPreview()</functioncall>
  <description>
    Stops any playing preview of a MediaItem.
  </description>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, stop, preview, audio, mediaitem, track, mediaexplorer</tags>
</US_DocBloc>
]]
--  ultraschall.RunCommand("_SWS_STOPPREVIEW") -- Xenakios/SWS: Stop current media item/take preview
--  ultraschall.PreviewMediaFile(ultraschall.Api_Path.."/misc/silence.flac")
  --ultraschall.StopAnyPreview()
  reaper.Xen_StopSourcePreview(-1)
end




function ultraschall.PreviewMediaFile(filename_with_path, gain, loop, outputChannel)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PreviewMediaFile</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.PreviewMediaFile(string filename_with_path, optional number gain, optional boolean loop, optional outputChannel)</functioncall>
  <description>
    Plays a preview of a media-file. You can only play one file at a time.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, starting preview was successful; false, starting preview wasn't successful
  </retvals>
  <parameters>
    string filename_with_path - the filename with path of the media-file to play
    optional number gain - the gain of the volume; nil, defaults to 1
    optional boolean loop - true, loop the previewed file; false or nil, don't loop the file
    optional integer outputChannel - the outputChannel; for multichannel files, this is the first hardware-output-channel for e.g. left channel of a stereo file; default, 0
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, preview, play, audio, file, output channel</tags>
</US_DocBloc>
]]

  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("PreviewMediaItem", "filename_with_path", "Must be a string.", -1) return false end
  if reaper.file_exists(filename_with_path)== false then ultraschall.AddErrorMessage("PreviewMediaItem", "filename_with_path", "File does not exist.", -2) return false end

  if type(loop)~="boolean" then loop=false end
  if type(gain)~="number" then gain=1 end
  if outputChannel~=nil and math.type(outputChannel)~="integer" then ultraschall.AddErrorMessage("PreviewMediaItem", "outputChannel", "Must be nil or an integer.", -3) return false end
  if outputChannel==nil then outputChannel=1 end
  --ultraschall.StopAnyPreview()
  reaper.Xen_StopSourcePreview(-1)
  --if ultraschall.PreviewPCMSource~=nil then reaper.PCM_Source_Destroy(ultraschall.PreviewPCMSource) end
  ultraschall.PreviewPCMSource=reaper.PCM_Source_CreateFromFile(filename_with_path)
  
  local retval=reaper.Xen_StartSourcePreview(ultraschall.PreviewPCMSource, gain, loop, outputChannel)
  return retval
end

--ultraschall.StopAnyPreview()
--O=ultraschall.PreviewMediaFile("c:\\Derek And The Dominos - Layla.mp3", 1, false)
--O2=ultraschall.PreviewMediaFile("c:\\Derek And The Dominos - Layla.mp3", 1, false)
--ultraschall.PreviewMediaFile("c:\\Derek And The Dominos - Layla.mp3", 1, false)
--ultraschall.PreviewMediaFile("c:\\Derek And The Dominos - Layla.mp3", 1, false)

function ultraschall.GetMediaItemTake(MediaItem, TakeNr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemTake</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>MediaItem_Take Take, integer TakeCount = ultraschall.GetMediaItemTake(MediaItem MediaItem, integer TakeNr)</functioncall>
  <description>
    Returns the requested MediaItem-Take of MediaItem. Use TakeNr=0 for the active take(!)
    
    Returns nil in case of an error
  </description>
  <retvals>
    MediaItem_Take Take - the requested take of a MediaItem
    integer TakeCount - the number of takes available within this Mediaitem
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, of whom you want to request a certain take.
    integer TakeNr - the take that you want to request; 1 for the first; 2 for the second, etc; 0, for the current active take
  </parameters>
  <chapter_context>
    MediaItem Management
    MediaItem-Takes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, take, get, take, active</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("GetMediaItemTake", "MediaItem", "must be a valid MediaItem-object", -1) return nil end
  if math.type(TakeNr)~="integer" then ultraschall.AddErrorMessage("GetMediaItemTake", "TakeNr", "must be an integer", -2) return nil end
  if TakeNr<0 or TakeNr>reaper.CountTakes(MediaItem) then ultraschall.AddErrorMessage("GetMediaItemTake", "TakeNr", "No such take in MediaItem", -3) return nil end
  
  if TakeNr==0 then return reaper.GetActiveTake(MediaItem), reaper.CountTakes(MediaItem)
  else return reaper.GetMediaItemTake(MediaItem, TakeNr-1), reaper.CountTakes(MediaItem) end
end


function ultraschall.ApplyFunctionToMediaItemArray(MediaItemArray, functionname, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyFunctionToMediaItemArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>table returnvalues  = ultraschall.ApplyFunctionToMediaItemArray(MediaItemArray MediaItemArray, function functionname, functionparameters1, ..., functionparametersn)</functioncall>
  <description>
    Applies function "functionname" on all items in MediaItemArray. Parameter ... is all parameters used for function "functionname", where you should use nil in place of the parameter that shall hold a MediaItem.
    
    Returns a table with a boolean(did the function run without an error) and all returnvalues returned by function "functionname".
    
    Returns nil in case of an error. Will NOT(!) stop execution, if function "functionname" produces an error(see table returnvalues for more details)
  </description>
  <retvals>
    table returnvalues - a table with all returnvalues of the following structure:
                       -    returnvalues[1]=boolean - true, running the function succeeded; false, running the function did not succeed
                       -    returnvalues[2]=optional(!) string - the errormessage, if returnvalues[1]=false; will be omitted if returnvalues[1]=true
                       - all other tableentries contain the returnvalues, as returned by function "functionname"
  </retvals>
  <parameters>
    MediaItemArray MediaItemArray - an array with all MediaItems, who you want to apply functionname to.
    function functionname - the name of the function to apply to every MediaItem in MediaItemArray
    functionparameters1...n - the parameters needed for function "functionname". Important: the function-parameter that is intended for the MediaItem, must be nil. 
                            - This nil-parameter will be filled with the appropriate MediaItem by ApplyFunctionToMediaItemArray automatically
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, apply, function, mediaitem, mediaitemarray</tags>
</US_DocBloc>
]]  
  if type(functionname)~="function" then ultraschall.AddErrorMessage("ApplyFunctionToMediaItemArray", "functionname", "Must be a function.", -1) return nil end
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ApplyFunctionToMediaItemArray", "functionname", "Must be a function.", -1) return nil end
  local L={...}
  local RetValTable={}
  local index=-1
  local max, i
  for i=1, 255 do 
    v=L[i]
    if v==nil and index==-1 then index=i
    elseif v==nil and index~=-1 then max=i break end
  end
  i=1
  while MediaItemArray[i]~=nil do
    L[index]=MediaItemArray[i]
    A={pcall(functionname, ultraschall.ReturnTableAsIndividualValues(L))}
    RetValTable[i]=A    
    i=i+1
  end
  return i, RetValTable
end





function ultraschall.GetGapsBetweenItems(MediaTrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGapsBetweenItems</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer number_of_gaps, array gaptable = ultraschall.GetGapsBetweenItems(MediaTrack MediaTrack)</functioncall>
  <description>
    Returns a table with all gaps between items in MediaTrack.
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_gaps - the number of gaps found between items; -1, in case of error
    array gaptable - an array with all gappositions found
                   - gaptable[idx][1]=startposition of gap
                   - gaptable[idx][2]=endposition of gap
  </retvals>
  <parameters>
    MediaTrack MediaTrack - the track, of which you want to have the gaps between items
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, gaps, between, items, item, mediaitem</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, MediaTrack, "MediaTrack*")==false then ultraschall.AddErrorMessage("GetGapsBetweenItems", "MediaTrack", "Must be a valid MediaTrack-object", -1) return -1 end
  if reaper.GetTrackMediaItem(MediaTrack, 0)==nil then ultraschall.AddErrorMessage("GetGapsBetweenItems", "MediaTrack", "No MediaItem in track", -2) return -1 end
  local GapTable={}
  local counter2=0
  local MediaItemArray={}
  local counter=0
  local Iterator, pos1, pos2, end1, end2
  
  -- create MediaItemArray with all items in track
  MediaItemArray[counter]=0
  while MediaItemArray[counter]~=nil do
    counter=counter+1
    MediaItemArray[counter]=reaper.GetTrackMediaItem(MediaTrack, counter-1)
  end
  counter=counter-1
  
  -- throw out all items, that are within/underneath other items
  for i=counter, 2, -1 do
    pos1=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")
    end1=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")+pos1
    pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i-1], "D_POSITION")
    end2=reaper.GetMediaItemInfo_Value(MediaItemArray[i-1], "D_LENGTH")+pos2
    if pos1>pos2 and end1<end2 then 
      table.remove(MediaItemArray,i) 
      counter=counter-1 
    end
  end
  
  -- see, if there's a gap between projectstart and first item, if yes, add it to GapTable
  if reaper.GetMediaItemInfo_Value(MediaItemArray[1], "D_POSITION")>0 then 
    Iterator=1
    GapTable[1]={}
    GapTable[1][1]=0
    GapTable[1][2]=reaper.GetMediaItemInfo_Value(MediaItemArray[1], "D_POSITION")
  else
    Iterator=0
  end
  
  -- create a table with all Gaps between items  
  for i=1, counter-1 do
    GapTable[i+Iterator]={}
    GapTable[i+Iterator][1]=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")
    GapTable[i+Iterator][2]=reaper.GetMediaItemInfo_Value(MediaItemArray[i+1], "D_POSITION")
    counter2=counter2+1
  end

  -- remove all gaps, that are gaps of length 0 or "gaps" of overlapping items(which aren't gaps because of that)
  for i=counter2+Iterator, 1, -1 do
    if GapTable[i][1]>=GapTable[i][2] then 
      table.remove(GapTable,i) 
      counter2=counter2-1
    end
  end
  
  return counter2+Iterator, GapTable
end


--A,B=ultraschall.GetGapsBetweenItems(reaper.GetTrack(0,0))


function ultraschall.DeleteMediaItemsBetween(startposition, endposition,  trackstring, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteMediaItemsBetween</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemStateChunkArray = ultraschall.DeleteMediaItemsBetween(number startposition, number endposition, string trackstring, boolean inside)</functioncall>
  <description>
    Delete the MediaItems between start- and endposition, from the tracks as given by trackstring.
    Returns also a MediaItemStateChunkArray, that contains the statechunks of all deleted MediaItem
    
    returns false in case of an error
  </description>
  <parameters>
    number startposition - the startposition in seconds
    number endposition - the endposition in seconds
    string trackstring - the tracknumbers, separated by a comma
    boolean inside - true, delete only MediaItems that are completely within start and endposition; false, also include MediaItems partially within start and endposition
  </parameters>
  <retvals>
    boolean retval - true, delete was successful; false was unsuccessful
    array MediaItemStateChunkArray - and array with all statechunks of all deleted MediaItems; 
                                   - each statechunk contains an additional entry "ULTRASCHALL_TRACKNUMBER" which holds the tracknumber, in which the deleted MediaItem was located
  </retvals>
  <chapter_context>
    MediaItem Management
    Delete
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, delete, between</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("DeleteMediaItemsBetween", "startposition", "must be a number", -1) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("DeleteMediaItemsBetween", "endposition", "must be a number", -2) return false end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("DeleteMediaItemsBetween", "inside", "must be a boolean", -3) return false end
  if startposition>endposition then ultraschall.AddErrorMessage("DeleteMediaItemsBetween", "endposition", "must be bigger than startposition", -4) return false end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("DeleteMediaItemsBetween", "trackstring", "must be a valid trackstring", -5) return false end
  
  local count=0
  local MediaItemArray
  count, MediaItemArray = ultraschall.GetAllMediaItemsBetween(startposition, endposition, trackstring, inside)
  return ultraschall.DeleteMediaItemsFromArray(MediaItemArray)
end

--A,AA,AAA=ultraschall.DeleteMediaItemsBetween(1000, 250, "1,2,3", false)


function ultraschall.ApplyActionToMediaItemArray2(MediaItemArray, actioncommandid, repeat_action, midi, MIDI_hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyActionToMediaItemArray2</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToMediaItemArray2(MediaItemArray MediaItemArray, string actioncommandid, integer repeat_action, boolean midi, optional HWND MIDI_hwnd)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Applies an action to the MediaItems in MediaItemArray, in either main or MIDI-Editor section-context
    The action given must support applying itself to selected items.
    
    This function applies the action to all MediaItems at once. To apply the action to each MediaItem in MediaItemArray individually, see <a href="#ApplyActionToMediaItemArray">ApplyActionToMediaItemArray</a>
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running the action was successful; false, if not or an error occured
  </retvals>
  <parameters>
    MediaItemArray MediaItemArray - an array with all MediaItems, to whom the action shall be applied to
    string actioncommandid - the commandid-number or ActionCommandID, that shall be run.
    integer repeat_action - the number of times this action shall be applied to each item; minimum value is 1
    boolean midi - true, run an action from MIDI-Editor-section-context; false, run an action from the main section
    optional HWND MIDI_hwnd - the HWND-handle of the MIDI-Editor, to which a MIDI-action shall be applied to; nil, to use the currently selected one
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, run, action, midi, main, midieditor, item, mediaitemarray</tags>
</US_DocBloc>
]]
  -- check parameters
  if ultraschall.CheckMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray2","MediaItemArray", "No valid MediaItemArray!", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray2","actioncommandid", "No such action registered!", -2) return false end
  if type(midi)~="boolean" then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray2","midi", "Must be boolean!", -3) return false end
  if math.type(repeat_action)~="integer" then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray2","repeat_action", "Must be an integer!", -4) return false end
  if repeat_action<1 then ultraschall.AddErrorMessage("ApplyActionToMediaItemArray2","repeat_action", "Must be bigger than 0!", -5) return false end
  
  reaper.PreventUIRefresh(1)
  local count, MediaItemArray_selected = ultraschall.GetAllSelectedMediaItems() -- get old selection
  for i=1, #MediaItemArray_selected do
    reaper.SetMediaItemInfo_Value(MediaItemArray_selected[i], "B_UISEL", 0)
  end
  
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray) -- select to-be-processed-MediaItems
  for i=1, repeat_action do
    ultraschall.RunCommand(actioncommandid,0) -- apply the action
  end

  for i=1, reaper.CountMediaItems(0)-1 do
    reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)
  end
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray_selected) -- select the MediaItems formerly selected
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  return true
end

-- count, MediaItemArray_selected = ultraschall.GetAllSelectedMediaItems()

-- ultraschall.ApplyActionToMediaItemArray2(MediaItemArray_selected, 41925, 100, false)

function ultraschall.GetMediafileAttributes(filename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediafileAttributes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number length, integer numchannels, integer Samplerate, string Filetype = ultraschall.GetMediafileAttributes(string filename)</functioncall>
  <description>
    returns the attributes of a mediafile
    
    if the mediafile is an rpp-project, this function creates a proxy-file called filename.RPP-PROX, which is a wave-file of the length of the project.
    This file can be deleted safely after that, but would be created again the next time this function is called.    
    
    returns -1 in case of an error
  </description>
  <parameters>
    string filename - the file whose attributes you want to have
  </parameters>
  <retvals>
    number length - the length of the mediafile in seconds
    integer numchannels - the number of channels of the mediafile
    integer Samplerate - the samplerate of the mediafile in hertz
    string Filetype - the type of the mediafile, like MP3, WAV, MIDI, FLAC, RPP_PROJECT etc
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>markermanagement, get, position, length, num, channels, samplerate, filetype</tags>
</US_DocBloc>
--]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("GetMediafileAttributes","filename", "must be a string", -1) return -1 end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("GetMediafileAttributes","filename", "file does not exist", -2) return -1 end
  local PCM_source=reaper.PCM_Source_CreateFromFile(filename)
  local Length, lengthIsQN = reaper.GetMediaSourceLength(PCM_source)
  local Numchannels=reaper.GetMediaSourceNumChannels(PCM_source)
  local Samplerate=reaper.GetMediaSourceSampleRate(PCM_source)
  local Filetype=reaper.GetMediaSourceType(PCM_source, "")  
  reaper.PCM_Source_Destroy(PCM_source)
--  if Filetype=="RPP_PROJECT" then os.remove(filename.."-PROX") end
  return Length, Numchannels, Samplerate, Filetype
end


--ultraschall.RenderProject_Regions(nil, "c:\\testofon.lol", 1,true, true, true, true, nil)

function ultraschall.InsertMediaItemFromFile(filename, track, position, length, editcursorpos, offset, looped, locked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemFromFile</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval, MediaItem item, number endposition, integer numchannels, integer Samplerate, string Filetype, number editcursorposition, MediaTrack track = ultraschall.InsertMediaItemFromFile(string filename, integer track, number position, number length, integer editcursorpos, optional number offset, optional boolean looped, optional boolean locked)</functioncall>
  <description>
    Inserts the mediafile filename into the project at position in track
    When giving an rpp-projectfile, it will be rendered by Reaper and inserted as subproject!
    
    Due API-limitations, it creates two undo-points: one for inserting the MediaItem and one for changing the length(when length isn't -1).
    
    Returns -1 in case of failure
  </description>
  <parameters>
    string filename - the path+filename of the mediafile to be inserted into the project
    integer track - the track, in which the file shall be inserted
                  -  0, insert the file into a newly inserted track after the last track
                  - -1, insert the file into a newly inserted track before the first track
                  - -2, insert into the last touched track
    number position - the position of the newly inserted item
    number length - the length of the newly created mediaitem; -1, use the length of the sourcefile
    integer editcursorpos - the position of the editcursor after insertion of the mediafile
          - 0, the old editcursorposition
          - 1, the position, at which the item was inserted
          - 2, the end of the newly inserted item
    optional number offset - an offset, to delay the insertion of the item, to overcome possible "too late"-starting of playback of item during recording
    optional boolean looped - true, loop source; false or nil, don't loop source
    optional boolean locked - true, lock MediaItem; false or nil, don't lock MediaItem
  </parameters>
  <retvals>
    integer retval - 0, if insertion worked; -1, if it failed
    MediaItem item - the newly created MediaItem
    number endposition - the endposition of the newly created MediaItem in seconds
    integer numchannels - the number of channels of the mediafile
    integer Samplerate - the samplerate of the mediafile in hertz
    string Filetype - the type of the mediafile, like MP3, WAV, MIDI, FLAC, etc
    number editcursorposition - the (new) editcursorposition
    MediaTrack track - returns the MediaTrack, in which the item is included
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>markermanagement, insert, mediaitem, position, mediafile, track</tags>
</US_DocBloc>
--]]
-- TODO: Test, if it really works(seems like it does...)
  if type(filename)~="string" then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "filename", "must be a string", -7) return -1 end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "filename", "file does not exist", -1) return -1 end
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "must be an integer", -2) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","position", "must be a number", -3) return -1 end
  if type(length)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","length", "must be a number", -4) return -1 end
  if length<-1 then ultraschall.AddErrorMessage("InsertMediaItemFromFile","length", "must be bigger/equal 0; or -1 for sourcefilelength", -5) return -1 end
  if math.type(editcursorpos)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "editcursorpos", "must be an integer between 0 and 2", -6) return -1 end
  if track<-2 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "no such track available", -7) return -1 end  
  if offset~=nil and type(offset)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","offset", "must be either nil or a number", -8) return -1 end  
  if offset==nil then offset=0 end
  if looped~=nil and type(looped)~="boolean" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","looped", "must be either nil or a boolean", -9) return -1 end  
  if locked~=nil and type(locked)~="boolean" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","locked", "must be either nil or a boolean", -10) return -1 end  
  -- where to insert and where to have the editcursor after insert
  reaper.PreventUIRefresh(1)
  local startTime, endTime = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0) -- get current arrange-view-range
  local editcursor, mode
  if editcursorpos==0 then editcursor=reaper.GetCursorPosition()
  elseif editcursorpos==1 then editcursor=position
  elseif editcursorpos==2 then editcursor=position+ultraschall.GetMediafileAttributes(filename)
  else ultraschall.AddErrorMessage("InsertMediaItemFromFile","editcursorpos", "must be an integer between 0 and 2", -6) return -1
  end
  
  -- if last touched track is requested, set track to last touched track
  if track==-2 then
    local temptrack=reaper.GetLastTouchedTrack()
    if temptrack==nil then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "track", "no last touched track available", -8) return -1 end
    track=math.tointeger(reaper.GetMediaTrackInfo_Value(temptrack, "IP_TRACKNUMBER"))
  end

  -- store old selection and set all tracks deselected(needed to restore the correct trackselection after insertion)
  local SelectedTracks=ultraschall.CreateTrackString_SelectedTracks() -- get old track-selection   
  ultraschall.SetTracksSelected(tostring(track), true) -- set track selected, where we want to insert the item

  -- insert item into a new track at the bottom of the project
  local TrackIndex=reaper.CountTracks(0)
  TrackIndex=TrackIndex<<16
  reaper.InsertMedia(filename, 0+512+TrackIndex)
 
  -- set MediaItem to correct track and to correct position/length
  local MediaItem=reaper.GetMediaItem(0,reaper.CountMediaItems(0)-1)
  local MediaTrack=reaper.GetTrack(0, track-1)
  reaper.SetMediaItemInfo_Value(MediaItem, "D_POSITION", position)
  reaper.SetMediaItemInfo_Value(MediaItem, "D_LENGTH", length)
  if looped==true then
    reaper.SetMediaItemInfo_Value(MediaItem, "B_LOOPSRC", 1)
  end
  if locked==true then
    local temp_value=reaper.GetMediaItemInfo_Value(MediaItem, "C_LOCK")
    if temp_value&1==0 then
      reaper.SetMediaItemInfo_Value(MediaItem, "C_LOCK", temp_value+1)
    end
  end
  
  -- with special insertion modes, set by track<=0
  if track>0 then
    -- regular track: move item to the track and remove temporary track at the bottom
    reaper.MoveMediaItemToTrack(MediaItem, MediaTrack)
    reaper.DeleteTrack(reaper.GetTrack(0, reaper.CountTracks(0)-1))
  elseif track==-1 then
    -- insert item into new track at the top: move the temporary track from the bottom to the top
    local retval = ultraschall.MoveTracks(tostring(reaper.CountTracks(0)), 0, 0)
  end

  -- reset cursorposition to the one chosen
  if editcursorpos==0 then
    reaper.SetEditCurPos(editcursor, false, false)  -- set editcursor to old position
  elseif editcursorpos==1 then
    reaper.SetEditCurPos(position+offset, false, false)  -- set editcursor to old position
  elseif editcursorpos==2 then
    reaper.SetEditCurPos(position+length+offset, false, false)  -- set editcursor to old position
  end
  
  -- reset trackselection
  ultraschall.SetAllTracksSelected(false)
  if track==-1 and SelectedTracks~="" then
    local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(SelectedTracks)
    if count>0 then
      SelectedTracks=""
      for i=1, count do
        SelectedTracks=SelectedTracks..(tonumber(individual_values[i])+1)..","
      end
    end
  end
  ultraschall.SetTracksSelected(SelectedTracks, true) -- set track selected, where we want to insert the item
  
  reaper.PreventUIRefresh(-1)
  
  -- return values and exit
  local Length, Numchannels, Samplerate, Filetype = ultraschall.GetMediafileAttributes(filename) -- mediaattributes, like length
  return 0, MediaItem, Length, Numchannels, Samplerate, Filetype, editcursor, reaper.GetMediaItem_Track(MediaItem)
end

--A,B,C,D,E,F,G,H,I,J=ultraschall.InsertMediaItemFromFile(ultraschall.Api_Path.."/misc/silence.flac", 0, 0, -1, 0)


function ultraschall.CopyMediaItemToDestinationTrack(MediaItem, MediaTrack_destination, position)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>CopyMediaItemToDestinationTrack</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>MediaItem newMediaItem, MediaItemStateChunk statechunk = ultraschall.CopyMediaItemToDestinationTrack(MediaItem MediaItem, MediaTrack MediaTrack_destination, number position)</functioncall>
    <description>
      Copies MediaItem to MediaTrack_destination at position.
      
      Returns nil in case of an error
    </description>
    <retvals>
      MediaItem newMediaItem - the newly created MediaItem; nil, if no item could be created
      MediaItemStateChunk statechunk - the statechunk of the newly created MediaItem
    </retvals>
    <parameters>
      MediaItem MediaItem - the MediaItem, that you want to create a copy from
      MediaTrack MediaTrack_destination - the track, into which you want to copy the MediaItem
      number position - the position of the copy of the MediaItem; negative, to keep the position of the source-MediaItem
    </parameters>
    <chapter_context>
      MediaItem Management
      Assistance functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitem management, copy, mediaitem, track, mediatrack, position</tags>
  </US_DocBloc>
  ]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("CopyMediaItemToDestinationTrack", "MediaItem", "must be a valid MediaItem", -1) return end
  if ultraschall.type(MediaTrack_destination)~="MediaTrack" then ultraschall.AddErrorMessage("CopyMediaItemToDestinationTrack", "MediaTrack_destination", "must be a valid MediaTrack-object", -2) return end
  if type(position)~="number" then ultraschall.AddErrorMessage("CopyMediaItemToDestinationTrack", "position", "must be a number", -3) return end
--  if position<0 then ultraschall.AddErrorMessage("CopyMediaItemToDestinationTrack", "position", "must be bigger than 0", -4) return end
  
  local original_position =  reaper.GetMediaItemInfo_Value( MediaItem, "D_POSITION" )
  reaper.SetMediaItemInfo_Value( MediaItem, "D_POSITION" , position )
  local retval, chunk = reaper.GetItemStateChunk(MediaItem, "", false)
  
  local temp_item = reaper.CreateNewMIDIItemInProj(MediaTrack_destination, 3, 0.1, false )
  if ultraschall.type(temp_item)~="MediaItem" then ultraschall.AddErrorMessage("CopyMediaItemToDestinationTrack", "", "could not create the new copy of the MediaItem", -5) return end
  reaper.SetMediaItemInfo_Value(MediaItem, "D_POSITION" , original_position)
  
  chunk=string.gsub(chunk, "\nIGUID.-\n", "\nIGUID "..reaper.genGuid().."\n")
  chunk=string.gsub(chunk, "\nGUID.-\n", "\nGUID "..reaper.genGuid().."\n")
  reaper.SetItemStateChunk(temp_item, chunk, false)
  return temp_item, chunk
end


--ultraschall.CopyMediaItemToDestinationTrack(reaper.GetMediaItem(0,0), reaper.GetTrack(0,2), -10)


function ultraschall.IsSplitAtPosition(trackstring, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsSplitAtPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsSplitAtPosition(string trackstring, number position)</functioncall>
  <description>
    returns, if theres at least one split, MediaItemend or MediaItemstart at position within the tracks given in trackstring.
     
    returns false in case of an error
  </description>
  <parameters>
    string trackstring - the tracknumbers, within to search for, as comma separated string. Starting 1 for the first track.
    number position - the position, at which to check for.
  </parameters>
  <retvals>
    boolean retval - true, there's a split/mediaitemend/mediaitemstart at position; false, it isn't
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, split, at position, seconds, mediaitem, mediaitemstart, mediaitemend</tags>
</US_DocBloc>
--]]
  if type(trackstring)~="string" then ultraschall.AddErrorMessage("IsSplitAtPosition", "trackstring", "must be a valid trackstring", -1) return false end
  if type(position)~="number" then ultraschall.AddErrorMessage("IsSplitAtPosition", "number", "must be a number", -2) return false end
  local valid, count, individual_tracknumbers = ultraschall.IsValidTrackString(trackstring)
            
  if valid==false then ultraschall.AddErrorMessage("IsSplitAtPosition", "trackstring", "no valid trackstring", -3) return false end
  local count2, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(position-1, position+1, trackstring, false)
  position=ultraschall.LimitFractionOfFloat(position, 9, true)
  for i=1, count2 do
    local pos=ultraschall.LimitFractionOfFloat(reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION"), 9, true)
    local len=ultraschall.LimitFractionOfFloat(reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH"), 9, true)
    if pos==position then return true end
  end
  return false
end

function ultraschall.GetItem_Number(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItem_Number</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer itemidx = ultraschall.GetItem_Number(MediaItem MediaItem)</functioncall>
  <description>
    returns the indexnumber of a MediaItem-object
    
    Can be helpful with Reaper's own API-functions, like reaper.GetMediaItem(ReaProject proj, integer itemidx)
    
    returns -1 in case of an error
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose itemidx you want to have
  </parameters>
  <retvals>
    integer itemidx - the indexnumber of the MediaItem, zero based. 
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, itemindex, itemidx</tags>
</US_DocBloc>
--]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetItem_Number", "MediaItem", "must be a valid MediaItem-object", -1) return -1 end
  local MediaTrack = reaper.GetMediaItem_Track(MediaItem)
  local ItemNr = reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
  local TrackNumber=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
  local Count=0
  for i=1, TrackNumber-1 do
    Count=Count+reaper.GetTrackNumMediaItems(reaper.GetTrack(0,i-1))
  end
  Count=Count+ItemNr
  return math.tointeger(Count)
end

function ultraschall.GetItem_HighestRecCounter()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItem_HighestRecCounter</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer highest_item_reccount, integer found = ultraschall.GetItem_HighestRecCounter()</functioncall>
  <description>
    Takes the RECPASS-counters of all items and takes and returns the highest one, which usually means, the number of items, who have been recorded since the project has been created.
    
    Note: a RECPASS-entry can also be part of a copy of a recorded item, so multiple items/takes can share the same RECPASS-entries with the same counter.
    Means: the highest number can be of multiple items
     
    returns -1 if no recorded item/take has been found.
  </description>
  <retvals>
    integer highest_item_reccount - the highest reccount of all MediaItems, which usually means, that so many Items have been recorded in this project
    integer found - the number of MediaItems, who have a recpass-entry in their StateChunk, means, who have been recorded.    
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, count, all, mediaitem, take, recpass, counter</tags>
</US_DocBloc>
--]]
  local String=""
  local recpass=-1
  local found=0
  for i=0, reaper.CountTracks()-1 do
    local retval, str = reaper.GetTrackStateChunk(reaper.GetTrack(0,i), "", false)
    String=String.."\n"..str
  end
  for k in string.gmatch(String, "RECPASS (.-)\n") do
    found=found+1
    if recpass<tonumber(k) then 
      recpass=tonumber(k)
    end
 end
 return recpass, found
end

function ultraschall.GetItem_ClickState(mouse_button)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItem_ClickState</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean clickstate, number position, MediaItem item, MediaItem_Take take = ultraschall.GetItem_ClickState(integer mouse_button)</functioncall>
  <description>
    Returns the currently clicked item and take, as well as the current timeposition.
    
    Mostly useful in defer-scripts.
    
    Returns false, if no item is clicked at
  </description>
  <retvals>
    boolean clickstate - true, item is clicked on; false, item isn't clicked on
    number position - the position, at which the item is currently clicked at
    MediaItem item - the Item, which is currently clicked at
    MediaItem_Take take - the take found at clickposition
  </retvals>
  <parameters>
    integer mouse_button - the mousebutton, that shall be clicked at the item; you can combine them as flags
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
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, clicked, item</tags>
</US_DocBloc>
--]]
  if math.type(mouse_button)~="integer" then ultraschall.AddErrorMessage("GetItem_ClickState", "mouse_button", "must be an integer", -1) return false end
  local X,Y=reaper.GetMousePosition()
  local Item, ItemTake = reaper.GetItemFromPoint(X,Y, true)
  if Item==nil then Item=ultraschall.ItemClickState_OldItem end
  if Item~=nil then ultraschall.ItemClickState_OldItem=Item end
  if ItemTake==nil then ItemTake=ultraschall.ItemClickState_OldTake end
  if ItemTake~=nil then ultraschall.ItemClickState_OldTake=ItemTake end
  local A=reaper.JS_Mouse_GetState(mouse_button)
  if A==0 or Item==nil then
    O=reaper.time_precise()
    ultraschall.ItemClickState_OldTake=nil
    ultraschall.ItemClickState_OldItem=nil
    return false
  end
  return true, ultraschall.GetTimeByMouseXPosition(reaper.GetMousePosition()), Item, ItemTake
end

function ultraschall.GetEndOfItem(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEndOfItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number end_of_item_position = ultraschall.GetEndOfItem(MediaItem MediaItem)</functioncall>
  <description>
    Returns the endposition of MediaItem
    
    returns nil in case of an error
  </description>
  <retvals>
    number end_of_item_position - the position of the ending edge of the MediaItem
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose ending-position you want to know
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, end of mediaitem, position</tags>
</US_DocBloc>
--]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetEndOfItem", "MediaItem", "must be a valid MediaItem", -1) return end
  return reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")-reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
end

function ultraschall.GetAllMediaItemAttributes_Table(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItemAttributes_Table</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table AttributeTable = ultraschall.GetAllMediaItemAttributes_Table(MediaItem MediaItem)</functioncall>
  <description>
    Returns all attributes of MediaItem as a handy table.
    
    The returned table is of the following scheme:
        AttributeTable["B_MUTE"] - bool * : muted
        AttributeTable["B_LOOPSRC"] - bool * : loop source
        AttributeTable["B_ALLTAKESPLAY"] - bool * : all takes play
        AttributeTable["B_UISEL"] - bool * : selected in arrange view
        AttributeTable["C_BEATATTACHMODE"] - char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1
        AttributeTable["C_AUTOSTRETCH:"] - char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
        AttributeTable["C_LOCK"] - char * : locked, &1=locked
        AttributeTable["D_VOL"] - double * : item volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
        AttributeTable["D_POSITION"] - double * : item position in seconds
        AttributeTable["D_LENGTH"] - double * : item length in seconds
        AttributeTable["D_SNAPOFFSET"] - double * : item snap offset in seconds
        AttributeTable["D_FADEINLEN"] - double * : item manual fadein length in seconds
        AttributeTable["D_FADEOUTLEN"] - double * : item manual fadeout length in seconds
        AttributeTable["D_FADEINDIR"] - double * : item fadein curvature, -1..1
        AttributeTable["D_FADEOUTDIR"] - double * : item fadeout curvature, -1..1
        AttributeTable["D_FADEINLEN_AUTO"] - double * : item auto-fadein length in seconds, -1=no auto-fadein
        AttributeTable["D_FADEOUTLEN_AUTO"] - double * : item auto-fadeout length in seconds, -1=no auto-fadeout
        AttributeTable["C_FADEINSHAPE"] - int * : fadein shape, 0..6, 0=linear
        AttributeTable["C_FADEOUTSHAPE"] - int * : fadeout shape, 0..6, 0=linear
        AttributeTable["I_GROUPID"] - int * : group ID, 0=no group
        AttributeTable["I_LASTY"] - int * : Y-position of track in pixels (read-only)
        AttributeTable["I_LASTH"] - int * : height in track in pixels (read-only)
        AttributeTable["I_CUSTOMCOLOR"] - int * : custom color, OS dependent color|0x100000 (i.e. ColorToNative(r,g,b)|0x100000). If you do not |0x100000, then it will not be used, but will store the color anyway)
        AttributeTable["I_CURTAKE"] - int * : active take number
        AttributeTable["IP_ITEMNUMBER"] - int, item number on this track (read-only, returns the item number directly)
        AttributeTable["F_FREEMODE_Y"] - float * : free item positioning Y-position, 0=top of track, 1=bottom of track (will never be 1)
        AttributeTable["F_FREEMODE_H"] - float * : free item positioning height, 0=no height, 1=full height of track (will never be 0)
        AttributeTable["P_TRACK"] - MediaTrack * (read-only)
    
    returns nil in case of an error
  </description>
  <retvals>
    table AttributeTable - a table with all attributes of a MediaItem
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose attributes you want to retrieve
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, all, attributes of mediaitem</tags>
</US_DocBloc>
--]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetAllMediaItemAttributes_Table", "MediaItem", "must be a valid MediaItem", -1) return end
  local Attributes={}
  Attributes["B_MUTE"]=reaper.GetMediaItemInfo_Value(MediaItem, "B_MUTE")
  Attributes["B_LOOPSRC"]=reaper.GetMediaItemInfo_Value(MediaItem, "B_LOOPSRC")
  Attributes["B_ALLTAKESPLAY"]=reaper.GetMediaItemInfo_Value(MediaItem, "B_ALLTAKESPLAY")
  Attributes["B_UISEL"]=reaper.GetMediaItemInfo_Value(MediaItem, "B_UISEL")
  Attributes["C_BEATATTACHMODE"]=reaper.GetMediaItemInfo_Value(MediaItem, "C_BEATATTACHMODE")
  Attributes["C_AUTOSTRETCH"]=reaper.GetMediaItemInfo_Value(MediaItem, "C_AUTOSTRETCH")
  Attributes["C_LOCK"]=reaper.GetMediaItemInfo_Value(MediaItem, "C_LOCK")
  Attributes["D_VOL"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_VOL")
  Attributes["D_POSITION"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
  Attributes["D_LENGTH"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
  Attributes["D_SNAPOFFSET"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_SNAPOFFSET")
  Attributes["D_FADEINLEN"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEINLEN")
  Attributes["D_FADEOUTLEN"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEOUTLEN")
  Attributes["D_FADEINDIR"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEINDIR")
  Attributes["D_FADEOUTDIR"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEOUTDIR")
  Attributes["D_FADEINLEN_AUTO"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEINLEN_AUTO")
  Attributes["D_FADEOUTLEN_AUTO"]=reaper.GetMediaItemInfo_Value(MediaItem, "D_FADEOUTLEN_AUTO")
  Attributes["C_FADEINSHAPE"]=reaper.GetMediaItemInfo_Value(MediaItem, "C_FADEINSHAPE")
  Attributes["C_FADEOUTSHAPE"]=reaper.GetMediaItemInfo_Value(MediaItem, "C_FADEOUTSHAPE")
  Attributes["I_GROUPID"]=reaper.GetMediaItemInfo_Value(MediaItem, "I_GROUPID")
  Attributes["I_LASTY"]=reaper.GetMediaItemInfo_Value(MediaItem, "I_LASTY")
  Attributes["I_LASTH"]=reaper.GetMediaItemInfo_Value(MediaItem, "I_LASTH")
  Attributes["I_CUSTOMCOLOR"]=reaper.GetMediaItemInfo_Value(MediaItem, "I_CUSTOMCOLOR")
  Attributes["I_CURTAKE"]=reaper.GetMediaItemInfo_Value(MediaItem, "I_CURTAKE")
  Attributes["IP_ITEMNUMBER"]=reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
  Attributes["F_FREEMODE_Y"]=reaper.GetMediaItemInfo_Value(MediaItem, "F_FREEMODE_Y")
  Attributes["F_FREEMODE_H"]=reaper.GetMediaItemInfo_Value(MediaItem, "F_FREEMODE_H")
  Attributes["P_TRACK"]=reaper.GetMediaItemInfo_Value(MediaItem, "P_TRACK")
  return Attributes
end

function ultraschall.SetAllMediaItemAttributes_Table(MediaItem, AttributeTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetAllMediaItemAttributes_Table</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetAllMediaItemAttributes_Table(MediaItem MediaItem, table AttributeTable)</functioncall>
  <description>
    Sets all attributes of MediaItem using a AttributeTable, which holds all the new settings for the MediaItem.
    
    The expected table is of the following scheme:
        AttributeTable["B_MUTE"] - bool * : muted
        AttributeTable["B_LOOPSRC"] - bool * : loop source
        AttributeTable["B_ALLTAKESPLAY"] - bool * : all takes play
        AttributeTable["B_UISEL"] - bool * : selected in arrange view
        AttributeTable["C_BEATATTACHMODE"] - char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1
        AttributeTable["C_AUTOSTRETCH:"] - char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
        AttributeTable["C_LOCK"] - char * : locked, &1=locked
        AttributeTable["D_VOL"] - double * : item volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
        AttributeTable["D_POSITION"] - double * : item position in seconds
        AttributeTable["D_LENGTH"] - double * : item length in seconds
        AttributeTable["D_SNAPOFFSET"] - double * : item snap offset in seconds
        AttributeTable["D_FADEINLEN"] - double * : item manual fadein length in seconds
        AttributeTable["D_FADEOUTLEN"] - double * : item manual fadeout length in seconds
        AttributeTable["D_FADEINDIR"] - double * : item fadein curvature, -1..1
        AttributeTable["D_FADEOUTDIR"] - double * : item fadeout curvature, -1..1
        AttributeTable["D_FADEINLEN_AUTO"] - double * : item auto-fadein length in seconds, -1=no auto-fadein
        AttributeTable["D_FADEOUTLEN_AUTO"] - double * : item auto-fadeout length in seconds, -1=no auto-fadeout
        AttributeTable["C_FADEINSHAPE"] - int * : fadein shape, 0..6, 0=linear
        AttributeTable["C_FADEOUTSHAPE"] - int * : fadeout shape, 0..6, 0=linear
        AttributeTable["I_GROUPID"] - int * : group ID, 0=no group
        AttributeTable["I_LASTY"] - int * : Y-position of track in pixels (read-only)
        AttributeTable["I_LASTH"] - int * : height in track in pixels (read-only)
        AttributeTable["I_CUSTOMCOLOR"] - int * : custom color, OS dependent color|0x100000 (i.e. ColorToNative(r,g,b)|0x100000). If you do not |0x100000, then it will not be used, but will store the color anyway)
        AttributeTable["I_CURTAKE"] - int * : active take number
        AttributeTable["IP_ITEMNUMBER"] - int, item number on this track (read-only, returns the item number directly)
        AttributeTable["F_FREEMODE_Y"] - float * : free item positioning Y-position, 0=top of track, 1=bottom of track (will never be 1)
        AttributeTable["F_FREEMODE_H"] - float * : free item positioning height, 0=no height, 1=full height of track (will never be 0)
        AttributeTable["P_TRACK"] - MediaTrack * (read-only)
    
    returns false in case of an error or if some of the attributes could not be set.
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting attributes failed
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose attributes you want to set
    table AttributeTable - a table which holds all settings, that you want to set
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, set, all, attributes of mediaitem</tags>
</US_DocBloc>
--]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("SetAllMediaItemAttributes_Table", "MediaItem", "must be a MediaItem", -1) return false end
  if type(AttributeTable)~="table" then ultraschall.AddErrorMessage("SetAllMediaItemAttributes_Table", "AttributeTable", "must be a table", -2) return false end
  local FailedAttributes=""
  for i,v in pairs(AttributeTable) do
    if i~="P_TRACK" and type(v)=="number" then
      if (reaper.SetMediaItemInfo_Value(MediaItem, i, v))==false then
        FailedAttributes=FailedAttributes..i.."\n"
      end
    elseif i~="P_TRACK" then
        FailedAttributes=FailedAttributes..i.."\n"
    end
  end
  if FailedAttributes~="" then ultraschall.AddErrorMessage("SetAllMediaItemAttributes_Table", "AttributeTable", "Could not set the following attributes: \n"..FailedAttributes:sub(1,-2), -3) return false end
  reaper.UpdateArrange()
  return true
end

function ultraschall.GetAllSelectedMediaItemsBetween(startposition, endposition, trackstring, inside)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllSelectedMediaItemsBetween</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray, array MediaItemStateChunkArray = ultraschall.GetAllSelectedMediaItemsBetween(number startposition, number endposition, string trackstring, boolean inside)</functioncall>
  <description>
    Gets all selected MediaItems between startposition and endposition from the tracks as given by trackstring. 
    Set inside to true to get only items, that are fully within the start and endposition, set it to false, if you also want items, that are just partially inside(end or just the beginning of the item).
    
    Returns the number of selected items, an array with all the selected MediaItems and an array with all the MediaItemStateChunks of the selected items, as used by functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    The statechunks include a new element "ULTRASCHALL_TRACKNUMBER", which contains the tracknumber of where the item originally was in; important, if you delete the items as you'll otherwise loose this information!
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - startposition in seconds
    number endposition - endposition in seconds
    string trackstring - the tracknumbers, separated by a comma
    boolean inside - true, only items that are completely within selection; false, include items that are partially within selection
  </parameters>
  <retvals>
    integer count - the number of selected items
    array MediaItemArray - an array with all the found and selected MediaItems
    array MediaItemStateChunkArray - an array with the MediaItemStateChunks, that can be used to create new items with <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, selected, media, item, selection, position, statechunk, rppxml</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("GetAllSelectedMediaItemsBetween", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("GetAllSelectedMediaItemsBetween", "endposition", "must be a number", -2) return -1 end
  if startposition>endposition then ultraschall.AddErrorMessage("GetAllSelectedMediaItemsBetween", "endposition", "must be bigger than startposition", -3) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetAllSelectedMediaItemsBetween", "trackstring", "must be a valid trackstring", -4) return -1 end
  if type(inside)~="boolean" then ultraschall.AddErrorMessage("GetAllSelectedMediaItemsBetween", "inside", "must be a boolean", -5) return -1 end
   
  local A,B,C=ultraschall.GetAllMediaItemsBetween(startposition, endposition, trackstring, inside)
  for i=A, 1, -1 do
    if reaper.IsMediaItemSelected(B[i])==false then
      table.remove(B,i)
      table.remove(C,i)
      A=A-1
    end
  end
  return A,B,C
end

function ultraschall.MediaItems_Outtakes_AddSelectedItems(TargetProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaItems_Outtakes_AddSelectedItems</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items = ultraschall.MediaItems_Outtakes_AddSelectedItems(ReaProject TargetProject)</functioncall>
  <description>
    Adds selected MediaItems to the outtakes-vault of a given project.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_items - the number of items, added to the outtakes-vault
  </retvals>
  <parameters>
    ReaProject TargetProject - the project, into whose outtakes-vault the selected items shall be added to; 0 or nil, for the current project
  </parameters>
  <chapter_context>
    MediaItem Management
    Outtakes Vault
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem, add, selected, items, outtakes, vault</tags>
</US_DocBloc>
]]  
  if TargetProject~=0 and TargetProject~=nil and ultraschall.type(TargetProject)~="ReaProject" then ultraschall.AddErrorMessage("MediaItems_Outtakes_AddSelectedItems", "TargetProject", "The target-project must be a valid ReaProject or 0/nil for current project", -1) return -1 end
  if TargetProject==nil then TargetProject=0 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllSelectedMediaItems()
  local temp, Value = reaper.GetProjExtState(TargetProject, "Ultraschall_Outtakes", "Count")
  if math.tointeger(Value)==nil then Value=0 else Value=math.tointeger(Value) end
  for i=1, count do
    Value=Value+1
    reaper.SetProjExtState(TargetProject, "Ultraschall_Outtakes", "Outtake_"..Value, MediaItemStateChunkArray[i])
  end
  reaper.SetProjExtState(TargetProject, "Ultraschall_Outtakes", "Count", Value)
  return Value
end

--A=ultraschall.MediaItems_Outtakes_AddSelectedItems(0)

function ultraschall.MediaItems_Outtakes_GetAllItems(TargetProject, EachItemsAfterAnother)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaItems_Outtakes_GetAllItems</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemStateChunkArray = ultraschall.MediaItems_Outtakes_GetAllItems(ReaProject TargetProject, optional boolean EachItemsAfterAnother)</functioncall>
  <description>
    Returns all MediaItems stored in the outtakes-vault of a given project.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_items - the number of items, added to the outtakes-vault
    array MediaItemStateChunkArray - all the MediaItemStateChunks of the stored MediaItems in the outtakes vault
  </retvals>
  <parameters>
    ReaProject TargetProject - the project, into whose outtakes-vault the selected items shall be added to; 0 or nil, for the current project
    optional boolean EachItemsAfterAnother - position the MediaItems one after the next, so if you import them, they would be stored one after another
                                           - true, position the startposition of the MediaItems one after another
                                           - false, keep old startpositions
  </parameters>
  <chapter_context>
    MediaItem Management
    Outtakes Vault
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem, get, all, items, outtakes, vault</tags>
</US_DocBloc>
]]  
  if TargetProject~=0 and TargetProject~=nil and ultraschall.type(TargetProject)~="ReaProject" then ultraschall.AddErrorMessage("MediaItems_Outtakes_GetAllItems", "TargetProject", "The target-project must be a valid ReaProject or 0/nil for current project", -1) return -1 end
  if TargetProject==nil then TargetProject=0 end
  local temp, Value = reaper.GetProjExtState(TargetProject, "Ultraschall_Outtakes", "Count")
  if math.tointeger(Value)==nil then Value=0 else Value=math.tointeger(Value) end
  local temp
  local MediaItemStateChunkArray={}
  local TempPosition=0
  local Length=0
  for i=1, Value do
    temp, MediaItemStateChunkArray[i]=reaper.GetProjExtState(TargetProject, "Ultraschall_Outtakes", "Outtake_"..i)
    if EachItemsAfterAnother==true then
      Length   = ultraschall.GetItemLength(nil, MediaItemStateChunkArray[i])
      MediaItemStateChunkArray[i] = ultraschall.SetItemPosition(nil, TempPosition, MediaItemStateChunkArray[i])
      TempPosition=TempPosition+Length
    end
  end
  return Value, MediaItemStateChunkArray
end

--B,C=ultraschall.MediaItems_Outtakes_GetAllItems(TargetProject, false)


function ultraschall.MediaItems_Outtakes_InsertAllItems(TargetProject, tracknumber, Startposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaItems_Outtakes_InsertAllItems</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer number_of_items, array MediaItemArray = ultraschall.MediaItems_Outtakes_InsertAllItems(ReaProject TargetProject, integer tracknumber, number Startposition)</functioncall>
  <description>
    Inserts all MediaItems from the outtakes-vault into a certain track, with one item after the other, back to back.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding was successful; false, adding was unsuccessful
    integer number_of_items - the number of added items
    array MediaItemArray - all the inserted MediaItems
  </retvals>
  <parameters>
    ReaProject TargetProject - the project, into whose outtakes-vault the selected items shall be added to; 0 or nil, for the current project
    integer tracknumber - the tracknumber, into which to insert all items from the outtakes-vault
    number Startposition - the position, at which to insert the first MediaItem; nil, startposition=0
  </parameters>
  <chapter_context>
    MediaItem Management
    Outtakes Vault
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem, insert, all, items, outtakes, vault</tags>
</US_DocBloc>
]]  
  if TargetProject~=0 and TargetProject~=nil and ultraschall.type(TargetProject)~="ReaProject" then ultraschall.AddErrorMessage("MediaItems_Outtakes_InsertAllItems", "TargetProject", "The target-project must be a valid ReaProject or 0/nil for current project", -1) return false end
  if TargetProject==nil then TargetProject=0 end
    
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("MediaItems_Outtakes_InsertAllItems", "tracknumber", "must be an integer", -2) return false end
  if tracknumber<0 or reaper.CountTracks(0)<tracknumber then ultraschall.AddErrorMessage("MediaItems_Outtakes_InsertAllItems", "tracknumber", "no such track", -3) return false end

  if Startposition~=nil and type(Startposition)~="number" then ultraschall.AddErrorMessage("MediaItems_Outtakes_InsertAllItems", "Startposition", "must be a number or nil for default-startposition 0", -4) return false end
  if Startposition==nil then Startposition=0 end
  
  local Count, MediaItemStateChunk = ultraschall.MediaItems_Outtakes_GetAllItems(TargetProject, true)
  local MediaItems={}
  local Position=Startposition
  local retval, startposition, endposition
  for i=1, Count do
    retval, MediaItems[i], startposition, endposition = ultraschall.InsertMediaItem_MediaItemStateChunk(Position, MediaItemStateChunk[i], reaper.GetTrack(0,tracknumber-1))
    Position=endposition
  end  
  return true, Count, MediaItems
end


function ultraschall.GetTake_ReverseState(MediaItem, takenumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTake_ReverseState</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetTake_ReverseState(MediaItem item, integer takenumber)</functioncall>
  <description>
    returns, if the chosen take of the MediaItem is reversed
  
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, take is reversed; false, take is not reversed
  </retvals>
  <parameters>
    MediaItem item - the MediaItem, of whose take you want to get the reverse-state
    integer takenumber - the take, whose reverse-state you want to know; 1, for the first take, etc
  </parameters>
  <chapter_context>
    MediaItem Management
    MediaItem-Takes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>take management, get, reverse, state</tags>
</US_DocBloc>
--]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetTake_ReverseState", "MediaItem", "must be a MediaItem", -1) return false end
  if math.type(takenumber)~="integer" then ultraschall.AddErrorMessage("GetTake_ReverseState", "takenumber", "must be an integer", -2) return false end
  if takenumber<1 then ultraschall.AddErrorMessage("GetTake_ReverseState", "takenumber", "must be bigger than 0", -3) return false end
  local Count=reaper.CountTakes(Item)
  
  local retval, StateChunk = reaper.GetItemStateChunk(Item, "", false)
  local StateChunk = ultraschall.StateChunkLayouter(StateChunk)
  local i=0
  for k in string.gmatch(StateChunk, "\n(  <SOURCE.-\n  >)") do
    i=i+1
    if i==takenumber then
      local Mode=k:match("MODE (%d*).")
      if Mode==nil then Mode=false else Mode=tonumber(Mode)&2==2 end
      return Mode
    end
  end
end


function ultraschall.IsItemVisible(item, completely_visible)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>IsItemVisible</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>boolean visible, boolean parent_track_visible, boolean within_start_and_endtime  = ultraschall.IsItemVisible(MediaItem item, boolean completely_visible)</functioncall>
    <description>
      returns if n item is currently visible in arrangeview

      Note: Items who start above and end below the visible arrangeview will be treated as not completely visible!
      
      parent_track_visible and within_start_and_endtime will allow you to determine, if the item could be visible if scrolled in only x or y direction.
        
      returns nil in case of error
    </description>
    <retvals>
      boolean visible - true, the item is visible; false, the item is not visible
      boolean parent_track_visible - true, its parent-track is visible; false, its parent track is not visible
      boolean within_start_and_endtime - true, the item is within start and endtime of the arrangeview; false, it is not
    </retvals>
    <parameters>
      MediaTrack track - the track, whose visibility you want to query
      boolean completely_visible - false, all tracks including partially visible ones; true, only fully visible tracks
    </parameters>
    <chapter_context>
      MediaItem Management
      Assistance functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>track management, get, visible, item, arrangeview</tags>
  </US_DocBloc>
  --]]
  if ultraschall.type(item)~="MediaTrack" then ultraschall.AddErrorMessage("IsItemVisible", "item", "must be a MediaItem", -1) return end
  if type(completely_visible)~="boolean" then ultraschall.AddErrorMessage("IsItemVisible", "completely_visible", "must be a boolean", -2) return end
  local MediaTrack=reaper.GetMediaItemInfo_Value(item, "P_TRACK")
  local trackstring, tracktable_count, tracktable = ultraschall.GetAllVisibleTracks_Arrange(false, completely_visible)
  local found=false
  for i=1, tracktable_count do
    if tracktable[i]==MediaTrack then found=true end
  end
  local start_item=reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local end_item=reaper.GetMediaItemInfo_Value(item, "D_LENGTH")+start_item
  local start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  local yeah=false
  
  if completely_visible==true then
    if start_item>=start_time and end_item<=end_time then yeah=true else yeah=false end
  else
    if start_item>=start_time and end_item<=end_time then yeah=true end
    if start_item<=end_time and end_item>=start_time then yeah=true end
  end
  return yeah==found, found, yeah
end


--A={ultraschall.IsItemVisible(reaper.GetMediaItem(0,0), false)}

function ultraschall.ApplyActionToMediaItemTake(MediaItemTake, actioncommandid, repeat_action)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyActionToMediaItemTake</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.77
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToMediaItemTake(MediaItem MediaItem, integer takeid, string actioncommandid, integer repeat_action)</functioncall>
  <description>
    Applies an action to a MediaItemTake, in the main section-context.
    The action given must support applying itself to selected item-takes, other actions might do weird things.    
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running the action was successful; false, if not or an error occured
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, that holds the take
    integer takeid - the id of the take, at which the actions shall be applied to; 1-based; 0, use currently active take
    string actioncommandid - the commandid-number or ActionCommandID, that shall be run.
    integer repeat_action - the number of times this action shall be applied to each take; minimum value is 1
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, run, action, main, item, mediaitem, take, mediaitemtake</tags>
</US_DocBloc>
]]
  -- check parameters
  if reaper.ValidatePtr2(0, MediaItemTake, "MediaItemTake*")==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","MediaItem", "Must be a MediaItemTake!", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","actioncommandid", "No such action registered!", -3) return false end
  if math.type(repeat_action)~="integer" then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","repeat_action", "Must be an integer!", -5) return false end
  if repeat_action<1 then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","repeat_action", "Must be bigger than 0!", -6) return false end
  --  if type(midi)~="boolean" then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","midi", "Must be boolean!", -4) return false end
  --  if midi==true and ultraschall.IsValidHWND(MIDI_hwnd)==false then ultraschall.AddErrorMessage("ApplyActionToMediaItemTake","MIDI_hwnd", "must be a valid hwnd of a Midi-Editor", -7) return false end
  midi=false

  -- get current active take of MediaItem in question, so we can reset the active take, if needed
  local MediaItem=reaper.GetMediaItemTake_Item(MediaItemTake)
  local TakeOld=reaper.GetMediaItemTake(MediaItem, -1)
  local CompareTakes=Take==TakeOld
  
  reaper.PreventUIRefresh(1)
  reaper.SetActiveTake(MediaItemTake)
  for i=1, repeat_action do
    if midi==true then 
      -- is this necessary? Is there take-access in the midi-editor possible?
      reaper.MIDIEditor_OnCommand(MIDI_hwnd, actioncommandid)
    else
      reaper.Main_OnCommand(actioncommandid, 0)
    end
  end
  if CompareTakes==false then
    reaper.SetActiveTake(TakeOld)
  end
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  return true
end

function ultraschall.CountMediaItemTake_StateChunk(MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountMediaItemTake_StateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer number_of_takes = ultraschall.CountMediaItemTake_StateChunk(string MediaItemStateChunk)</functioncall>
  <description>
    Counts the number of available takes in a MediaItemStateChunk.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_takes - the number of takes in this MediaItemStateChunk    
  </retvals>
  <parameters>
    string MediaItemStateChunk - the statechunk of the mediaitem, whose takes you want to count
  </parameters>
  <chapter_context>
    MediaItem Management
    MediaItem-Takes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem, take, count, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("CountMediaItemTake_StateChunk", "MediaItemStateChunk", "must be a valid MediaItemStateChunk", -1) return -1 end
  local count=0
  if MediaItemStateChunk:match("\n  NAME")==nil then return 0 end
  MediaItemStateChunk="TAKE\n"..MediaItemStateChunk:sub(6,-4).."\nTAKE\n"
  for k in string.gmatch(MediaItemStateChunk, "(\nTAKE[%s%c])") do
    count=count+1
  end
  return count 
end

function ultraschall.GetMediaItemTake_StateChunk(MediaItemStateChunk, takeid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemTake_StateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>string TakeStateChunk = ultraschall.GetMediaItemTake_StateChunk(string MediaItemStateChunk, integer takeid)</functioncall>
  <description>
    Returns the statechunk-entries of takes from a MediaItemStateChunk.
    
    Note: takeid>0 will never return statechunk-entries as selected, even if they are.
    
    returns nil in case of an error
  </description>
  <retvals>
    string TakeStateChunk - the statechunk-entries of the requested take
  </retvals>
  <parameters>
    string MediaItemStateChunk - the statechunk of the mediaitem, whose take you want to get
    integer takeid - the number of the take, whose statechunk-entries you want; 0, get selected take
  </parameters>
  <chapter_context>
    MediaItem Management
    MediaItem-Takes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem, take, get, takestatechunk, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("GetMediaItemTake_StateChunk", "MediaItemStateChunk", "must be a valid MediaItemStateChunk", -1) return end
  if math.type(takeid)~="integer" then ultraschall.AddErrorMessage("GetMediaItemTake_StateChunk", "MediaItemStateChunk", "must be an integer", -2) return end
  if takeid<0 then ultraschall.AddErrorMessage("GetMediaItemTake_StateChunk", "takeid", "must be bigger than 0", -3) return end
  local count=0
  -- layout statechunk, if needed
  if MediaItemStateChunk:sub(1,8)~="<ITEM\n  " then
    MediaItemStateChunk=ultraschall.StateChunkLayouter(MediaItemStateChunk)
  end
  -- set first take as selected, if no other take is selected
  local TakeSel
  if MediaItemStateChunk:match("  TAKE SEL\n")==nil then
    TakeSel="\n  TAKE SEL"
  else
    TakeSel="\n  TAKE"
  end
  if MediaItemStateChunk:match("\n  NAME")==nil then ultraschall.AddErrorMessage("GetMediaItemTake_StateChunk", "takeid", "no take available", -5) return end
  -- prepare statechunk to be easily parseable
  MediaItemStateChunk=TakeSel..MediaItemStateChunk:match("(\n  NAME.*)>").."\n  TAKE\n"
  
  -- return selected take, if takeid==0
  if takeid==0 then
    return MediaItemStateChunk:match("\n(  TAKE SEL\n.-)\n  TAKE\n")
  end
  
  -- return take with takeid
  
  -- first, set all takes unselected, 
  local MISC=string.gsub(MediaItemStateChunk, "  TAKE SEL\n", "  TAKE\n")
  local k=""
  local offset
  
  -- second, go through all takes, until we found the right one and return it
  -- otherwise leave loop and return nil
  while k~=nil do
    k, offset=MISC:match("(  TAKE\n.-)\n()  TAKE\n")
    if k==nil then break end
    count=count+1
    if count==takeid then return k end
    MISC=MISC:sub(offset, -1)
  end
  ultraschall.AddErrorMessage("GetMediaItemTake_StateChunk", "takeid", "no such take", -4)
end

function ultraschall.GetItemSpectralConfig2(Item, take_id, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralConfig2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.22
    Lua=5.3
  </requires>
  <functioncall>integer item_spectral_config = ultraschall.GetItemSpectralConfig(MediaItem Item, integer take_id, optional string MediaItemStateChunk)</functioncall>
  <description>
    returns the item-spectral-config, which is the fft-size of the spectral view for this item.
    
    It's the entry SPECTRAL_CONFIG
    
    set itemidx to -1 to use the optional parameter MediaItemStateChunk to alter a MediaItemStateChunk instead of an item directly.
    
    use take_id==0 for the active take
    
    returns -2 in case of an error 
  </description>
  <parameters>
    MediaItem Item - the item, whose spectral-config-attribute you want to get; nil, to use the parameter MediaItemStateChunk
    integer take_id - the id of the take; 1-based; 0, for active take
    optional string MediaItemStateChunk - you can give a MediaItemStateChunk to process, if itemidx is set to -1
  </parameters>
  <retvals>
    integer item_spectral_config - the fft-size in points for the spectral-view; 16, 32, 64, 128, 256, 512, 1024(default), 2048, 4096, 8192; -1, if not existing
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, take, spectral edit, fft, size</tags>
</US_DocBloc>
--]]
  if Item~=nil and ultraschall.type(Item)~="MediaItem" then ultraschall.AddErrorMessage("GetItemSpectralConfig2", "Item", "must be a MediaItem", -1) return -2 end
  if math.type(take_id)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralConfig2", "take_id", "must be an integer", -2) return -2 end
  if take_id<0 then ultraschall.AddErrorMessage("GetItemSpectralConfig2", "take_id", "must be bigger or equal 0", -3) return -2 end
  if Item==nil and ultraschall.IsValidItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("GetItemSpectralConfig2", "MediaItemStateChunk", "must be a string", -4) return -2 end
  
  local retval
  if Item~=nil then
    retval, MediaItemStateChunk = reaper.GetItemStateChunk(Item, "", false)
  end
  local Spectral_Config=ultraschall.GetMediaItemTake_StateChunk(MediaItemStateChunk, take_id)
  if Spectral_Config==nil then ultraschall.AddErrorMessage("GetItemSpectralConfig2", "take_id", "no such take", 5) return -2 end
  Spectral_Config=Spectral_Config.."\n"
  Spectral_Config=Spectral_Config:match("SPECTRAL_CONFIG (.-)\n")
  
  if Spectral_Config==nil then Spectral_Config=-1 end
  
  return tonumber(Spectral_Config)
end

function ultraschall.GetItemSpectralEdit2(Item, take_id, spectral_idx, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralEdit2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.22
    Lua=5.3
  </requires>
  <functioncall>boolean retval, number start_pos, number length, number gain, number fade, number freq_fade, number freq_range_bottom, number freq_range_top, integer h, integer byp_solo, number gate_thres, number gate_floor, number comp_thresh, number comp_exp_ratio, number n, number o, number fade2, number freq_fade2 = ultraschall.GetItemSpectralEdit2(MediaItem Item, integer take_id, integer spectralidx, optional string MediaItemStateChunk)</functioncall>
  <description>
    returns the settings of a specific SPECTRAL_EDIT in a given MediaItem/MediaItemStateChunk.
    The SPECTRAL_EDITs are the individual edit-boundary-boxes in the spectral-view.
    If itemidx is set to nil, you can give the function a MediaItemStateChunk to look in, instead.
    
    returns -1 in case of error
  </description>
  <parameters>
    MediaItem Item - the MediaItem to look in for the spectral-edit; nil, to use the parameter MediaItemStateChunk instead
    integer take_id - the index of the take, whose spectral-edit-information you want to retrieve; 1-based; 0, active take
    integer spectralidx - the number of the spectral-edit to return; 1 for the first, 2 for the second, etc
    optional string MediaItemStateChunk - if itemidx is -1, this can be a MediaItemStateChunk to use, otherwise this will be ignored
  </parameters>
  <retvals>
    boolean retval - true, getting states was successful; false, getting states was unsuccessful
    number start_pos - the startposition of the spectral-edit-region in seconds
    number length - the length of the spectral-edit-region in seconds
    number gain - the gain as slider-value; 0(-224dB) to 98350.1875(99.68dB); 1 for 0dB
    number fade - 0(0%)-0.5(100%); adjusting this affects also parameter fade2!
    number freq_fade - 0(0%)-0.5(100%); adjusting this affects also parameter freq_fade2!
    number freq_range_bottom - the bottom of the edit-region, but can be moved to be top as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    number freq_range_top - the top of the edit-region, but can be moved to be bottom as well! 0 to device-samplerate/2 (e.g 96000 for 192kHz)
    integer h - unknown
    integer byp_solo - sets the solo and bypass-state. 0, no solo, no bypass; 1, bypass only; 2, solo only; 3, bypass and solo
    number gate_thres - sets the threshold of the gate; 0(-224dB)-98786.226563(99.89dB)
    number gate_floor - sets the floor of the gate; 0(-224dB)-99802.171875(99.98dB)
    number comp_thresh - sets the threshold for the compressor; 0(-224dB)-98842.484375(99.90dB); 1(0dB)is default
    number comp_exp_ratio - sets the ratio of the compressor/expander; 0.1(1:10.0)-100(100:1.0); 1(1.0:1) is default
    number n - unknown
    number o - unknown
    number fade2 - negative with fade_in set; positive with fadeout-set
    number freq_fade2 - negative with low frequency-fade, positive with high-frequency-fade
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, take, spectral edit</tags>
</US_DocBloc>
--]]

  if Item~=nil and ultraschall.type(Item)~="MediaItem" then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "Item", "must be a MediaItem", -1) return false end
  if math.type(take_id)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "take_id", "must be an integer", -2) return false end
  if math.type(spectral_idx)~="integer" then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "spectral_idx", "must be an integer", -3) return false end
  if take_id<0 then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "take_id", "must be bigger or equal 0", -5) return false end
  if spectral_idx<1 then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "spectral_idx", "must be bigger than 0", -6) return false end
  if Item==nil and ultraschall.IsValidItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "MediaItemStateChunk", "must be a string", -4) return false end
  local retval
  if Item~=nil then
    retval, MediaItemStateChunk = reaper.GetItemStateChunk(Item, "", false)
  end
  local TSC=ultraschall.GetMediaItemTake_StateChunk(MediaItemStateChunk, take_id)
  if TSC==nil then ultraschall.AddErrorMessage("GetItemSpectralEdit2", "take_id", "no such take", 7) return false end
  
  local count=0
  local k=""
  local retval=false
  local found, count2
  for k in string.gmatch(TSC, "SPECTRAL_EDIT (.-)\n") do
    count=count+1
    if count==spectral_idx then 
      found=k
      count2, found = ultraschall.CSV2IndividualLinesAsArray(k, " ")
      for i=1, count2 do
        found[i]=tonumber(found[i])
      end
      retval=true
    end
  end
  
  return retval, table.unpack(found)
end

function ultraschall.CountItemSpectralEdit2(Item, take_id, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSpectralConfig2</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.22
    Lua=5.3
  </requires>
  <functioncall>integer item_spectral_config = ultraschall.CountItemSpectralEdit2(MediaItem Item, integer take_id, optional string MediaItemStateChunk)</functioncall>
  <description>
    counts the number of spectral-edit-entries in a take, which is the fft-size of the spectral view for this item.
    
    It's the entry SPECTRAL_EDIT
    
    use take_id==0 for the active take
    
    returns -2 in case of an error 
  </description>
  <parameters>
    MediaItem Item - the item, whose spectral-edits you want to count; nil, to use the parameter MediaItemStateChunk
    integer take_id - the id of the take; 1-based; 0, for active take
    optional string MediaItemStateChunk - you can give a MediaItemStateChunk to process, if itemidx is set to -1
  </parameters>
  <retvals>
    integer item_spectral_config - the fft-size in points for the spectral-view; 16, 32, 64, 128, 256, 512, 1024(default), 2048, 4096, 8192; -1, if not existing
  </retvals>
  <chapter_context>
    MediaItem Management
    Spectral Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, get, item, take, spectral edit, fft, size</tags>
</US_DocBloc>
--]]
  if Item~=nil and ultraschall.type(Item)~="MediaItem" then ultraschall.AddErrorMessage("CountItemSpectralEdit2", "Item", "must be a MediaItem", -1) return -1 end
  if math.type(take_id)~="integer" then ultraschall.AddErrorMessage("CountItemSpectralEdit2", "take_id", "must be an integer", -2) return -1 end
  if take_id<0 then ultraschall.AddErrorMessage("CountItemSpectralEdit2", "take_id", "must be bigger or equal 0", -3) return -1 end
  if Item==nil and ultraschall.IsValidItemStateChunk(MediaItemStateChunk)==false then ultraschall.AddErrorMessage("CountItemSpectralEdit2", "MediaItemStateChunk", "must be a string", -4) return -1 end
  local retval
  if Item~=nil then
    retval, MediaItemStateChunk = reaper.GetItemStateChunk(Item, "", false)
  end
  local TSC=ultraschall.GetMediaItemTake_StateChunk(MediaItemStateChunk, take_id)
  if TSC==nil then ultraschall.AddErrorMessage("CountItemSpectralEdit2", "take_id", "no such take", 5) return -1 end
  
  local count=0
  local k=""
  local retval=false
  local found, count2
  for k in string.gmatch(TSC, "SPECTRAL_EDIT (.-)\n") do
    count=count+1
  end
  
  return count
end


function ultraschall.SpectralPeak_GetMinColor()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_GetMinColor</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>number min_color = ultraschall.SpectralPeak_GetMinColor()</functioncall>
    <description>
      returns the minimum value of the spectral peak-view in Media Items, which is the lowest-frequency-color.
      
      The color is encoded, so that:
        0 = red
        1 = green
        2 = blue
        3 = red again
    </description>
    <retvals>
      number min_color - the minimum color of the spectral peak
    </retvals>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, get, min color, spectral peak view</tags>
  </US_DocBloc>
  --]]
  return reaper.SNM_GetDoubleConfigVar("specpeak_huel", -11111)*3
end

--A=ultraschall.SpectralPeak_GetMinColor()

function ultraschall.SpectralPeak_SetMinColor(color, update_arrange)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_SetMinColor</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SpectralPeak_SetMinColor(number min_color, optional boolean update_arrange)</functioncall>
    <description>
      sets the minimum value of the spectral peak-view in Media Items, which is the lowest-frequency-color.
      
      The color is encoded, so that:
        0 = red
        1 = green
        2 = blue
        3 = red again, etc
        
      return false in case of an error
    </description>
    <retvals>
      boolean retval - true, setting was successful; false, setting was unsuccessful
    </retvals>
    <parameters>
      number min_color - the minimum color of the spectral peak
      optional boolean update_arrange - true, update arrange; false or nil, don't update arrange
    </parameters>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, set, min color, spectral peak view</tags>
  </US_DocBloc>
  --]]
  if type(color)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetMinColor", "color", "must be a number", -1) return false end
  color=color/3
  reaper.SNM_SetDoubleConfigVar("specpeak_huel", color)
  if update_arrange==true then
    reaper.UpdateArrange()
  end
  return true
end

--ultraschall.SpectralPeak_SetMinColor(0, true)

function ultraschall.SpectralPeak_GetMaxColor()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_GetMaxColor</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>number max_color = ultraschall.SpectralPeak_GetMaxColor()</functioncall>
    <description>
      returns the maximum value of the spectral peak-view in Media Items, which is the highest-frequency-color.
      
      The color is encoded, so that:
        0 = red
        1 = green
        2 = blue
        3 = red again
        
      Max-color should be higher than min-color.
    </description>
    <retvals>
      number max_color - the maximum color of the spectral peak
    </retvals>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, get, max color, spectral peak view</tags>
  </US_DocBloc>
  --]]
  return reaper.SNM_GetDoubleConfigVar("specpeak_hueh", -1111)*3
end

--A=ultraschall.SpectralPeak_GetMaxColor()

function ultraschall.SpectralPeak_SetMaxColor(color, update_arrange)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_SetMaxColor</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SpectralPeak_SetMaxColor(number color, optional boolean update_arrange)</functioncall>
    <description>
      sets the maximum value of the spectral peak-view in Media Items.
      
      The color is encoded, so that:
        0 = red
        1 = green
        2 = blue
        3 = red again, etc

        Max-color should be higher than min-color.
        
      return false in case of an error
    </description>
    <retvals>
      boolean retval - true, setting was successful; false, setting was unsuccessful
    </retvals>
    <parameters>
      number color - the maximum color of the spectral peak
      optional boolean update_arrange - true, update arrange; false or nil, don't update arrange
    </parameters>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, set, max color, spectral peak view</tags>
  </US_DocBloc>
  --]]
  if type(color)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetMaxColor", "color", "must be a number", -1) return false end
  color=(color/3)+1
  reaper.SNM_SetDoubleConfigVar("specpeak_hueh", color)
  if update_arrange==true then
    reaper.UpdateArrange()
  end
end

function ultraschall.SpectralPeak_SetMaxColor_Relative(color, update_arrange)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_SetMaxColor_Relative</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SpectralPeak_SetMaxColor_Relative(number color, optional boolean update_arrange)</functioncall>
    <description>
      sets the maximum value of the spectral peak-view in Media Items relative to the minimum color.
      
      This will set the shown spectrum relative to the minimum-color set.
      
      To set it to the whole spectrum, pass 3 as color.
      To set it to a third of the spectrum, pass 1 as color.
      To set it to two times the spectrum, set color to 6.
        
      return false in case of an error
    </description>
    <retvals>
      boolean retval - true, setting was successful; false, setting was unsuccessful
    </retvals>
    <parameters>
      number color - the maximum spectrum of the spectral peak relative to the minimum color
      optional boolean update_arrange - true, update arrange; false or nil, don't update arrange
    </parameters>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, set, max color, relative, spectral peak view</tags>
  </US_DocBloc>
  --]]
  if type(color)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetMaxColor_Relative", "color", "must be a number", -1) return false end
  color=(color/3)+reaper.SNM_GetDoubleConfigVar("specpeak_huel", color)
  reaper.SNM_SetDoubleConfigVar("specpeak_hueh", color)
  if update_arrange==true then
    reaper.UpdateArrange()
  end
  return true
end

--ultraschall.SpectralPeak_SetMaxColor_Relative(6, true)

function ultraschall.SpectralPeak_SetColorAttributes(noise_threshold, variance, opacity)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_SetColorAttributes</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SpectralPeak_SetColorAttributes(optional number noise_threshold, optional number variance, optional number opacity)</functioncall>
    <description>
      sets the noise_threshold, variance and opacity of the spectral peak-view in Media Items.

      return false in case of an error
    </description>
    <retvals>
      boolean retval - true, setting was successful; false, setting was unsuccessful
    </retvals>
    <parameters>
      optional number noise_threshold - the noise threshold, between 0.25 and 8.00
      optional number variance - the variance of the spectrum, between 0 and 1
      optional number opacity - the opacity of the spectrum, between 0 and 1.33; 1, for default
    </parameters>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, set, noise threshold, variance, alpha, opacity, spectral peak view</tags>
  </US_DocBloc>
  --]]
  if noise_threshold~=nil and type(noise_threshold)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "noise_threshold", "must be a number", -1) return false end
  if variance~=nil and type(variance)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "variance", "must be a number between 0 and 1", -2) return false end
  if opacity~=nil and type(opacity)~="number" then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "opacity", "must be a number between 0 and 1", -3) return false end
  
  
  if noise_threshold~=nil then
    if noise_threshold<0.25 or noise_threshold>8.00 then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "noise_threshold", "must be a number between 0 and 1", -4) return false end
    local LookUpTable={} -- ugly workaround...please fiddle out the math behind this...
    LookUpTable[25]=16
    LookUpTable[26]=15.548989744238
    LookUpTable[27]=14.96735650067
    LookUpTable[28]=14.545454545455
    LookUpTable[29]=14.001360038635
    LookUpTable[30]=13.349772995397
    LookUpTable[31]=13.097709199531
    LookUpTable[32]=12.488175726571
    LookUpTable[33]=12.252380183218
    LookUpTable[34]=11.90700836321
    LookUpTable[35]=11.571371932756
    LookUpTable[36]=11.245196469324
    LookUpTable[37]=10.928215285841
    LookUpTable[38]=10.620169212648
    LookUpTable[39]=10.320806385595
    LookUpTable[40]=10.125934035717
    LookUpTable[41]=9.8405027795123
    LookUpTable[42]=9.5631172997986
    LookUpTable[43]=9.3825512596322
    LookUpTable[44]=9.1180745819253
    LookUpTable[45]=8.9459116177384
    LookUpTable[46]=8.7769993492957
    LookUpTable[47]=8.5295920542111
    LookUpTable[48]=8.3685405253863
    LookUpTable[49]=8.2105298916913
    LookUpTable[50]=8.0555027364517
    LookUpTable[51]=7.9034027271063
    LookUpTable[52]=7.7541745947374
    LookUpTable[53]=7.6077641139876
    LookUpTable[54]=7.4641180833557
    LookUpTable[55]=7.3231843058652
    LookUpTable[56]=7.1849115700966
    LookUpTable[57]=7.0492496315794
    LookUpTable[58]=6.9161491945341
    LookUpTable[59]=6.7855618939597
    LookUpTable[60]=6.7211958059643
    LookUpTable[61]=6.5942895186293
    LookUpTable[62]=6.4697794129011
    LookUpTable[63]=6.3476202452663
    LookUpTable[64]=6.2874083586674
    LookUpTable[65]=6.1686926308725
    LookUpTable[66]=6.0522184345993
    LookUpTable[67]=5.9948086532994
    LookUpTable[68]=5.8816176480919
    LookUpTable[69]=5.770563859333
    LookUpTable[70]=5.7158257806067
    LookUpTable[71]=5.6616069331611
    LookUpTable[72]=5.5547072776564
    LookUpTable[73]=5.5020167587267
    LookUpTable[74]=5.3981304057826
    LookUpTable[75]=5.346925134629
    LookUpTable[76]=5.2962055834556
    LookUpTable[77]=5.196205255097
    LookUpTable[78]=5.1469153937828
    LookUpTable[79]=5.0497338887786
    LookUpTable[80]=5.0018334170242
    LookUpTable[81]=4.9543873167764
    LookUpTable[82]=4.9073912779842
    LookUpTable[83]=4.814732348596
    LookUpTable[84]=4.769061040771
    LookUpTable[85]=4.7238229591791
    LookUpTable[86]=4.634630075787
    LookUpTable[87]=4.5906671716169
    LookUpTable[88]=4.5471212882038
    LookUpTable[89]=4.5039884697967
    LookUpTable[90]=4.4612647981674
    LookUpTable[91]=4.4189463922554
    LookUpTable[92]=4.3355100370646
    LookUpTable[93]=4.2943845083446
    LookUpTable[94]=4.2536490857709
    LookUpTable[95]=4.2133000688973
    LookUpTable[96]=4.173333792379
    LookUpTable[97]=4.1337466256399
    LookUpTable[98]=4.0945349725424
    LookUpTable[99]=4.0556952710613
    LookUpTable[100]=4.0172239929594
    LookUpTable[101]=3.9554078605272
    LookUpTable[102]=3.917887882906
    LookUpTable[103]=3.8807238101043
    LookUpTable[104]=3.8439122661009
    LookUpTable[105]=3.8074499068986
    LookUpTable[106]=3.7713334202207
    LookUpTable[107]=3.7355595252095
    LookUpTable[108]=3.7001249721291
    LookUpTable[109]=3.6650265420695
    LookUpTable[110]=3.6302610466545
    LookUpTable[111]=3.595825327752
    LookUpTable[112]=3.5617162571873
    LookUpTable[113]=3.5279307364585
    LookUpTable[114]=3.4944656964554
    LookUpTable[116]=3.4613180971806
    LookUpTable[117]=3.4284849274733
    LookUpTable[118]=3.3959632047359
    LookUpTable[119]=3.3637499746628
    LookUpTable[120]=3.3318423109722
    LookUpTable[121]=3.3002373151404
    LookUpTable[122]=3.2689321161382
    LookUpTable[124]=3.2379238701703
    LookUpTable[125]=3.2072097604168
    LookUpTable[126]=3.1767869967776  
    LookUpTable[127]=3.1466528156187  
    LookUpTable[128]=3.1168044795212
    LookUpTable[130]=3.0872392770326
    LookUpTable[131]=3.0579545224207
    LookUpTable[132]=3.0289475554293  
    LookUpTable[133]=3.0002157410367
    LookUpTable[135]=2.9717564692165
    LookUpTable[136]=2.9435671547002  
    LookUpTable[137]=2.9156452367425
    LookUpTable[139]=2.8879881788887
    LookUpTable[140]=2.8605934687443
    LookUpTable[141]=2.8334586177465
    LookUpTable[143]=2.8065811609388
    LookUpTable[144]=2.7799586567461
    LookUpTable[145]=2.7535886867539
    LookUpTable[147]=2.727468855488
    LookUpTable[148]=2.7015967901969
    LookUpTable[149]=2.6759701406366
    LookUpTable[151]=2.6505865788568  
    LookUpTable[152]=2.6254437989898
    LookUpTable[154]=2.6005395170403
    LookUpTable[155]=2.5758714706787
    LookUpTable[157]=2.5514374190352
    LookUpTable[158]=2.5272351424965
    LookUpTable[160]=2.5032624425036
    LookUpTable[161]=2.4795171413527
    LookUpTable[163]=2.4559970819971
    LookUpTable[164]=2.4327001278514
    LookUpTable[166]=2.4096241625971
    LookUpTable[168]=2.3867670899907
    LookUpTable[169]=2.364126833673
    LookUpTable[171]=2.3417013369806
    LookUpTable[172]=2.3194885627593
    LookUpTable[174]=2.2974864931786
    LookUpTable[176]=2.2756931295487
    LookUpTable[177]=2.2541064921388
    LookUpTable[179]=2.2327246199974
    LookUpTable[181]=2.211545570774
    LookUpTable[183]=2.1905674205429
    LookUpTable[184]=2.1697882636279
    LookUpTable[186]=2.14920621243
    LookUpTable[188]=2.1288193972551
    LookUpTable[190]=2.1086259661448
    LookUpTable[192]=2.0886240847078
    LookUpTable[193]=2.0688119359534
    LookUpTable[195]=2.0491877201262
    LookUpTable[197]=2.0297496545431
    LookUpTable[199]=2.0104959734309
    LookUpTable[201]=1.9914249277662
    LookUpTable[203]=1.9725347851163
    LookUpTable[205]=1.9538238294818
    LookUpTable[207]=1.935290361141
    LookUpTable[209]=1.9169326964953
    LookUpTable[211]=1.8987491679162
    LookUpTable[213]=1.880738123594
    LookUpTable[215]=1.8628979273874
    LookUpTable[217]=1.8452269586755
    LookUpTable[219]=1.8277236122099
    LookUpTable[221]=1.8103862979693
    LookUpTable[223]=1.7932134410148
    LookUpTable[225]=1.7762034813471
    LookUpTable[227]=1.7593548737646
    LookUpTable[230]=1.742666087723
    LookUpTable[232]=1.7261356071965
    LookUpTable[234]=1.70976193054  
    LookUpTable[236]=1.6935435703522
    LookUpTable[238]=1.6774790533414
    LookUpTable[241]=1.6615669201909
    LookUpTable[243]=1.6458057254266
    LookUpTable[245]=1.6301940372862
    LookUpTable[248]=1.6147304375883
    LookUpTable[250]=1.5994135216041
    LookUpTable[252]=1.58424189793
    LookUpTable[255]=1.5692141883605
    LookUpTable[257]=1.5543290277636
    LookUpTable[260]=1.5395850639566
    LookUpTable[262]=1.5249809575831
    LookUpTable[265]=1.5105153819917
    LookUpTable[267]=1.4961870231151
    LookUpTable[270]=1.4819945793511
    LookUpTable[272]=1.4679367614439
    LookUpTable[275]=1.4540122923674  
    LookUpTable[278]=1.4402199072091
    LookUpTable[280]=1.426558353055
    LookUpTable[283]=1.413026388876
    LookUpTable[286]=1.3996227854151
    LookUpTable[289]=1.3863463250755
    LookUpTable[291]=1.3731958018106
    LookUpTable[294]=1.3601700210137
    LookUpTable[297]=1.3472677994101
    LookUpTable[300]=1.334487964949
    LookUpTable[303]=1.3218293566976
    LookUpTable[306]=1.3092908247355
    LookUpTable[308]=1.29687123005
    LookUpTable[311]=1.2845694444327
    LookUpTable[314]=1.2723843503773
    LookUpTable[317]=1.2603148409778
    LookUpTable[320]=1.2483598198278
    LookUpTable[323]=1.2365182009216
    LookUpTable[327]=1.2247889085546
    LookUpTable[330]=1.2131708772263
    LookUpTable[333]=1.2016630515433
    LookUpTable[336]=1.1902643861232
    LookUpTable[339]=1.1789738455
    LookUpTable[343]=1.1677904040298
    LookUpTable[346]=1.1567130457976
    LookUpTable[349]=1.1457407645252
    LookUpTable[352]=1.1348725634799
    LookUpTable[356]=1.1241074553833
    LookUpTable[359]=1.1134444623224
    LookUpTable[363]=1.1028826156603
    LookUpTable[366]=1.0924209559485
    LookUpTable[370]=1.0820585328393
    LookUpTable[373]=1.071794405
    LookUpTable[377]=1.061627640027
    LookUpTable[380]=1.0515573143614
    LookUpTable[384]=1.0415825132048
    LookUpTable[388]=1.0317023304362
    LookUpTable[391]=1.0219158685302
    LookUpTable[395]=1.0122222384749
    LookUpTable[399]=1.0026205596912
    LookUpTable[403]=0.99310995995314
    LookUpTable[407]=0.98368957530844
    LookUpTable[411]=0.97435855
    LookUpTable[414]=0.96511603638822
    LookUpTable[418]=0.95596119487402
    LookUpTable[422]=0.94689319382251
    LookUpTable[426]=0.93791120948748
    LookUpTable[431]=0.92901442593658
    LookUpTable[435]=0.92020203497716
    LookUpTable[439]=0.9114732360829
    LookUpTable[443]=0.90282723632104
    LookUpTable[447]=0.8942632502804
    LookUpTable[452]=0.8857805
    LookUpTable[456]=0.87737821489839
    LookUpTable[460]=0.86905563170366
    LookUpTable[465]=0.8608119943841
    LookUpTable[469]=0.85264655407953
    LookUpTable[474]=0.84455856903325
    LookUpTable[478]=0.83654730452469
    LookUpTable[483]=0.82861203280263
    LookUpTable[487]=0.82075203301913
    LookUpTable[492]=0.812966591164
    LookUpTable[497]=0.805255
    LookUpTable[501]=0.79761655899853
    LookUpTable[506]=0.79005057427605
    LookUpTable[511]=0.782556358531
    LookUpTable[516]=0.77513323098139
    LookUpTable[521]=0.76778051730296
    LookUpTable[526]=0.7604975495679
    LookUpTable[531]=0.75328366618421
    LookUpTable[536]=0.74613821183557
    LookUpTable[541]=0.73906053742182
    LookUpTable[546]=0.73205
    LookUpTable[552]=0.72510596272594
    LookUpTable[557]=0.71822779479641
    LookUpTable[562]=0.71141487139182
    LookUpTable[568]=0.70466657361945
    LookUpTable[573]=0.69798228845723
    LookUpTable[579]=0.69136140869809
    LookUpTable[584]=0.68480333289474
    LookUpTable[590]=0.67830746530506
    LookUpTable[595]=0.67187321583802
    LookUpTable[601]=0.6655
    LookUpTable[607]=0.65918723884176
    LookUpTable[613]=0.65293435890583
    LookUpTable[618]=0.64674079217438
    LookUpTable[624]=0.64060597601768
    LookUpTable[630]=0.63452935314294
    LookUpTable[636]=0.62851037154372
    LookUpTable[643]=0.62254848444976
    LookUpTable[649]=0.61664315027733
    LookUpTable[655]=0.61079383258002
    LookUpTable[661]=0.605
    LookUpTable[667]=0.59926112621978
    LookUpTable[674]=0.59357668991439
    LookUpTable[680]=0.58794617470398
    LookUpTable[687]=0.58236906910698
    LookUpTable[693]=0.57684486649358
    LookUpTable[700]=0.57137306503975
    LookUpTable[707]=0.5659531676816
    LookUpTable[714]=0.5605846820703
    LookUpTable[720]=0.55526712052729
    LookUpTable[727]=0.55
    LookUpTable[734]=0.54478284201799
    LookUpTable[741]=0.53961517264944
    LookUpTable[748]=0.53449652245817
    LookUpTable[756]=0.52942642646089
    LookUpTable[763]=0.52440442408507
    LookUpTable[770]=0.51943005912704
    LookUpTable[777]=0.51450287971055
    LookUpTable[785]=0.50962243824573
    LookUpTable[792]=0.50478829138844
    LookUpTable[800]=0.5
    local temp=16
    for i=25, 800 do
      if LookUpTable[i]~=nil then
        temp=LookUpTable[i]
      else
        LookUpTable[i]=temp
      end
    end
    noise_threshold = ultraschall.LimitFractionOfFloat(noise_threshold, 2)
    reaper.SNM_SetDoubleConfigVar("specpeak_na", LookUpTable[noise_threshold*100])
  end
  
  if variance~=nil then
    if variance<0 or variance>1 then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "variance", "must be a number between 0 and 1", -5) return false end
    reaper.SNM_SetIntConfigVar("specpeak_bv", math.floor(variance*255))
  end

  if opacity~=nil then
    if opacity<0 or opacity>1.33 then ultraschall.AddErrorMessage("SpectralPeak_SetColorAttributes", "opacity", "must be a number between 0 and 1", -6) return false end
    reaper.SNM_SetIntConfigVar("specpeak_alpha", math.floor((opacity*255)/1.328125))
  end
  return true
end

--ultraschall.SpectralPeak_SetColorAttributes(0.25, nil, 1.33)
--SLEM()

function ultraschall.SpectralPeak_GetColorAttributes()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SpectralPeak_GetColorAttributes</slug>
    <requires>
      Ultraschall=4.4
      Reaper=6.22
      SWS=2.8.8
      Lua=5.3
    </requires>
    <functioncall>number noise_threshold, number variance, number opacity = ultraschall.SpectralPeak_GetColorAttributes()</functioncall>
    <description>
      returns the noise_threshold, variance and opacity of the spectral peak-view in Media Items.
    </description>
    <retvals>
      number noise_threshold - the noise threshold, between 0.25 and 8.00
      number variance - the variance of the spectrum, between 0 and 1
      number opacity - the opacity of the spectrum, between 0 and 1.33; 1, for default
    </retvals>
    <chapter_context>
      MediaItem Management
      Spectral Peak
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
    <tags>mediaitemmanagement, get, noise threshold, variance, alpha, opacity, spectral peak view</tags>
  </US_DocBloc>
  --]]
  local LookUpTable={} -- ugly workaround...please fiddle out the math behind this...
  LookUpTable[25]=16
  LookUpTable[26]=15.548989744238
  LookUpTable[27]=14.96735650067
  LookUpTable[28]=14.545454545455
  LookUpTable[29]=14.001360038635
  LookUpTable[30]=13.349772995397
  LookUpTable[31]=13.097709199531
  LookUpTable[32]=12.488175726571
  LookUpTable[33]=12.252380183218
  LookUpTable[34]=11.90700836321
  LookUpTable[35]=11.571371932756
  LookUpTable[36]=11.245196469324
  LookUpTable[37]=10.928215285841
  LookUpTable[38]=10.620169212648
  LookUpTable[39]=10.320806385595
  LookUpTable[40]=10.125934035717
  LookUpTable[41]=9.8405027795123
  LookUpTable[42]=9.5631172997986
  LookUpTable[43]=9.3825512596322
  LookUpTable[44]=9.1180745819253
  LookUpTable[45]=8.9459116177384
  LookUpTable[46]=8.7769993492957
  LookUpTable[47]=8.5295920542111
  LookUpTable[48]=8.3685405253863
  LookUpTable[49]=8.2105298916913
  LookUpTable[50]=8.0555027364517
  LookUpTable[51]=7.9034027271063
  LookUpTable[52]=7.7541745947374
  LookUpTable[53]=7.6077641139876
  LookUpTable[54]=7.4641180833557
  LookUpTable[55]=7.3231843058652
  LookUpTable[56]=7.1849115700966
  LookUpTable[57]=7.0492496315794
  LookUpTable[58]=6.9161491945341
  LookUpTable[59]=6.7855618939597
  LookUpTable[60]=6.7211958059643
  LookUpTable[61]=6.5942895186293
  LookUpTable[62]=6.4697794129011
  LookUpTable[63]=6.3476202452663
  LookUpTable[64]=6.2874083586674
  LookUpTable[65]=6.1686926308725
  LookUpTable[66]=6.0522184345993
  LookUpTable[67]=5.9948086532994
  LookUpTable[68]=5.8816176480919
  LookUpTable[69]=5.770563859333
  LookUpTable[70]=5.7158257806067
  LookUpTable[71]=5.6616069331611
  LookUpTable[72]=5.5547072776564
  LookUpTable[73]=5.5020167587267
  LookUpTable[74]=5.3981304057826
  LookUpTable[75]=5.346925134629
  LookUpTable[76]=5.2962055834556
  LookUpTable[77]=5.196205255097
  LookUpTable[78]=5.1469153937828
  LookUpTable[79]=5.0497338887786
  LookUpTable[80]=5.0018334170242
  LookUpTable[81]=4.9543873167764
  LookUpTable[82]=4.9073912779842
  LookUpTable[83]=4.814732348596
  LookUpTable[84]=4.769061040771
  LookUpTable[85]=4.7238229591791
  LookUpTable[86]=4.634630075787
  LookUpTable[87]=4.5906671716169
  LookUpTable[88]=4.5471212882038
  LookUpTable[89]=4.5039884697967
  LookUpTable[90]=4.4612647981674
  LookUpTable[91]=4.4189463922554
  LookUpTable[92]=4.3355100370646
  LookUpTable[93]=4.2943845083446
  LookUpTable[94]=4.2536490857709
  LookUpTable[95]=4.2133000688973
  LookUpTable[96]=4.173333792379
  LookUpTable[97]=4.1337466256399
  LookUpTable[98]=4.0945349725424
  LookUpTable[99]=4.0556952710613
  LookUpTable[100]=4.0172239929594
  LookUpTable[101]=3.9554078605272
  LookUpTable[102]=3.917887882906
  LookUpTable[103]=3.8807238101043
  LookUpTable[104]=3.8439122661009
  LookUpTable[105]=3.8074499068986
  LookUpTable[106]=3.7713334202207
  LookUpTable[107]=3.7355595252095
  LookUpTable[108]=3.7001249721291
  LookUpTable[109]=3.6650265420695
  LookUpTable[110]=3.6302610466545
  LookUpTable[111]=3.595825327752
  LookUpTable[112]=3.5617162571873
  LookUpTable[113]=3.5279307364585
  LookUpTable[114]=3.4944656964554
  LookUpTable[116]=3.4613180971806
  LookUpTable[117]=3.4284849274733
  LookUpTable[118]=3.3959632047359
  LookUpTable[119]=3.3637499746628
  LookUpTable[120]=3.3318423109722
  LookUpTable[121]=3.3002373151404
  LookUpTable[122]=3.2689321161382
  LookUpTable[124]=3.2379238701703
  LookUpTable[125]=3.2072097604168
  LookUpTable[126]=3.1767869967776  
  LookUpTable[127]=3.1466528156187  
  LookUpTable[128]=3.1168044795212
  LookUpTable[130]=3.0872392770326
  LookUpTable[131]=3.0579545224207
  LookUpTable[132]=3.0289475554293  
  LookUpTable[133]=3.0002157410367
  LookUpTable[135]=2.9717564692165
  LookUpTable[136]=2.9435671547002  
  LookUpTable[137]=2.9156452367425
  LookUpTable[139]=2.8879881788887
  LookUpTable[140]=2.8605934687443
  LookUpTable[141]=2.8334586177465
  LookUpTable[143]=2.8065811609388
  LookUpTable[144]=2.7799586567461
  LookUpTable[145]=2.7535886867539
  LookUpTable[147]=2.727468855488
  LookUpTable[148]=2.7015967901969
  LookUpTable[149]=2.6759701406366
  LookUpTable[151]=2.6505865788568  
  LookUpTable[152]=2.6254437989898
  LookUpTable[154]=2.6005395170403
  LookUpTable[155]=2.5758714706787
  LookUpTable[157]=2.5514374190352
  LookUpTable[158]=2.5272351424965
  LookUpTable[160]=2.5032624425036
  LookUpTable[161]=2.4795171413527
  LookUpTable[163]=2.4559970819971
  LookUpTable[164]=2.4327001278514
  LookUpTable[166]=2.4096241625971
  LookUpTable[168]=2.3867670899907
  LookUpTable[169]=2.364126833673
  LookUpTable[171]=2.3417013369806
  LookUpTable[172]=2.3194885627593
  LookUpTable[174]=2.2974864931786
  LookUpTable[176]=2.2756931295487
  LookUpTable[177]=2.2541064921388
  LookUpTable[179]=2.2327246199974
  LookUpTable[181]=2.211545570774
  LookUpTable[183]=2.1905674205429
  LookUpTable[184]=2.1697882636279
  LookUpTable[186]=2.14920621243
  LookUpTable[188]=2.1288193972551
  LookUpTable[190]=2.1086259661448
  LookUpTable[192]=2.0886240847078
  LookUpTable[193]=2.0688119359534
  LookUpTable[195]=2.0491877201262
  LookUpTable[197]=2.0297496545431
  LookUpTable[199]=2.0104959734309
  LookUpTable[201]=1.9914249277662
  LookUpTable[203]=1.9725347851163
  LookUpTable[205]=1.9538238294818
  LookUpTable[207]=1.935290361141
  LookUpTable[209]=1.9169326964953
  LookUpTable[211]=1.8987491679162
  LookUpTable[213]=1.880738123594
  LookUpTable[215]=1.8628979273874
  LookUpTable[217]=1.8452269586755
  LookUpTable[219]=1.8277236122099
  LookUpTable[221]=1.8103862979693
  LookUpTable[223]=1.7932134410148
  LookUpTable[225]=1.7762034813471
  LookUpTable[227]=1.7593548737646
  LookUpTable[230]=1.742666087723
  LookUpTable[232]=1.7261356071965
  LookUpTable[234]=1.70976193054  
  LookUpTable[236]=1.6935435703522
  LookUpTable[238]=1.6774790533414
  LookUpTable[241]=1.6615669201909
  LookUpTable[243]=1.6458057254266
  LookUpTable[245]=1.6301940372862
  LookUpTable[248]=1.6147304375883
  LookUpTable[250]=1.5994135216041
  LookUpTable[252]=1.58424189793
  LookUpTable[255]=1.5692141883605
  LookUpTable[257]=1.5543290277636
  LookUpTable[260]=1.5395850639566
  LookUpTable[262]=1.5249809575831
  LookUpTable[265]=1.5105153819917
  LookUpTable[267]=1.4961870231151
  LookUpTable[270]=1.4819945793511
  LookUpTable[272]=1.4679367614439
  LookUpTable[275]=1.4540122923674  
  LookUpTable[278]=1.4402199072091
  LookUpTable[280]=1.426558353055
  LookUpTable[283]=1.413026388876
  LookUpTable[286]=1.3996227854151
  LookUpTable[289]=1.3863463250755
  LookUpTable[291]=1.3731958018106
  LookUpTable[294]=1.3601700210137
  LookUpTable[297]=1.3472677994101
  LookUpTable[300]=1.334487964949
  LookUpTable[303]=1.3218293566976
  LookUpTable[306]=1.3092908247355
  LookUpTable[308]=1.29687123005
  LookUpTable[311]=1.2845694444327
  LookUpTable[314]=1.2723843503773
  LookUpTable[317]=1.2603148409778
  LookUpTable[320]=1.2483598198278
  LookUpTable[323]=1.2365182009216
  LookUpTable[327]=1.2247889085546
  LookUpTable[330]=1.2131708772263
  LookUpTable[333]=1.2016630515433
  LookUpTable[336]=1.1902643861232
  LookUpTable[339]=1.1789738455
  LookUpTable[343]=1.1677904040298
  LookUpTable[346]=1.1567130457976
  LookUpTable[349]=1.1457407645252
  LookUpTable[352]=1.1348725634799
  LookUpTable[356]=1.1241074553833
  LookUpTable[359]=1.1134444623224
  LookUpTable[363]=1.1028826156603
  LookUpTable[366]=1.0924209559485
  LookUpTable[370]=1.0820585328393
  LookUpTable[373]=1.071794405
  LookUpTable[377]=1.061627640027
  LookUpTable[380]=1.0515573143614
  LookUpTable[384]=1.0415825132048
  LookUpTable[388]=1.0317023304362
  LookUpTable[391]=1.0219158685302
  LookUpTable[395]=1.0122222384749
  LookUpTable[399]=1.0026205596912
  LookUpTable[403]=0.99310995995314
  LookUpTable[407]=0.98368957530844
  LookUpTable[411]=0.97435855
  LookUpTable[414]=0.96511603638822
  LookUpTable[418]=0.95596119487402
  LookUpTable[422]=0.94689319382251
  LookUpTable[426]=0.93791120948748
  LookUpTable[431]=0.92901442593658
  LookUpTable[435]=0.92020203497716
  LookUpTable[439]=0.9114732360829
  LookUpTable[443]=0.90282723632104
  LookUpTable[447]=0.8942632502804
  LookUpTable[452]=0.8857805
  LookUpTable[456]=0.87737821489839
  LookUpTable[460]=0.86905563170366
  LookUpTable[465]=0.8608119943841
  LookUpTable[469]=0.85264655407953
  LookUpTable[474]=0.84455856903325
  LookUpTable[478]=0.83654730452469
  LookUpTable[483]=0.82861203280263
  LookUpTable[487]=0.82075203301913
  LookUpTable[492]=0.812966591164
  LookUpTable[497]=0.805255
  LookUpTable[501]=0.79761655899853
  LookUpTable[506]=0.79005057427605
  LookUpTable[511]=0.782556358531
  LookUpTable[516]=0.77513323098139
  LookUpTable[521]=0.76778051730296
  LookUpTable[526]=0.7604975495679
  LookUpTable[531]=0.75328366618421
  LookUpTable[536]=0.74613821183557
  LookUpTable[541]=0.73906053742182
  LookUpTable[546]=0.73205
  LookUpTable[552]=0.72510596272594
  LookUpTable[557]=0.71822779479641
  LookUpTable[562]=0.71141487139182
  LookUpTable[568]=0.70466657361945
  LookUpTable[573]=0.69798228845723
  LookUpTable[579]=0.69136140869809
  LookUpTable[584]=0.68480333289474
  LookUpTable[590]=0.67830746530506
  LookUpTable[595]=0.67187321583802
  LookUpTable[601]=0.6655
  LookUpTable[607]=0.65918723884176
  LookUpTable[613]=0.65293435890583
  LookUpTable[618]=0.64674079217438
  LookUpTable[624]=0.64060597601768
  LookUpTable[630]=0.63452935314294
  LookUpTable[636]=0.62851037154372
  LookUpTable[643]=0.62254848444976
  LookUpTable[649]=0.61664315027733
  LookUpTable[655]=0.61079383258002
  LookUpTable[661]=0.605
  LookUpTable[667]=0.59926112621978
  LookUpTable[674]=0.59357668991439
  LookUpTable[680]=0.58794617470398
  LookUpTable[687]=0.58236906910698
  LookUpTable[693]=0.57684486649358
  LookUpTable[700]=0.57137306503975
  LookUpTable[707]=0.5659531676816
  LookUpTable[714]=0.5605846820703
  LookUpTable[720]=0.55526712052729
  LookUpTable[727]=0.55
  LookUpTable[734]=0.54478284201799
  LookUpTable[741]=0.53961517264944
  LookUpTable[748]=0.53449652245817
  LookUpTable[756]=0.52942642646089
  LookUpTable[763]=0.52440442408507
  LookUpTable[770]=0.51943005912704
  LookUpTable[777]=0.51450287971055
  LookUpTable[785]=0.50962243824573
  LookUpTable[792]=0.50478829138844
  LookUpTable[800]=0.5
  local temp=16
  for i=25, 800 do
    if LookUpTable[i]~=nil then
      temp=LookUpTable[i]
    else
      LookUpTable[i]=nil
    end
  end
  local curval=reaper.SNM_GetDoubleConfigVar("specpeak_na", -99999)
  local curval = ultraschall.LimitFractionOfFloat(curval, 2)
  local found=0
  for i=25, 800 do
    if LookUpTable[i]~=nil and LookUpTable[i]>=curval then
      found=i
    end
  end
  
  local variance=reaper.SNM_GetIntConfigVar("specpeak_bv", -9999)/255
  variance = ultraschall.LimitFractionOfFloat(variance, 2)

  local alpha=(reaper.SNM_GetIntConfigVar("specpeak_alpha", -9999)/255)*1.328125
  alpha = ultraschall.LimitFractionOfFloat(alpha, 2)
  
  return found/100, variance, alpha
end


function ultraschall.ToggleCrossfadeStateForSplits(toggle)
  --[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleCrossfadeStateForSplits</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, boolean curstate = ultraschall.ToggleCrossfadeStateForSplits(optional boolean toggle)</functioncall>
  <description>
    Sets the state of crossfade for splitting items to either on/off or toggling it.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting state was successful; false, setting state was unsuccessful
    boolean curstate - true, crossfade split is turned on; false, crossfade split is turned off
  </retvals>
  <parameters>
    optional boolean toggle - nil, toggle setting of crossfade-splitstate; true, set crossfade split on; false, set crossfade split off
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, toggle, set, crossfade, split, items, mediaitems</tags>
</US_DocBloc>
]]
  if toggle~=nil and type(toggle)~="boolean" then ultraschall.AddErrorMessage("ToggleCrossfadeStateForSplits", "toggle", "must be either nil(for toggle) or boolean", -1) return false end
  local retval=reaper.SNM_GetIntConfigVar("splitautoxfade", -1)
  local retval2
  if toggle==true and retval&1==0 then
    retval=retval+1
    reaper.SNM_SetIntConfigVar("splitautoxfade", retval)
    retval2=true
  elseif toggle==false and retval&1==1 then
    retval=retval-1
    reaper.SNM_SetIntConfigVar("splitautoxfade", retval)
    retval2=false
  elseif toggle==nil then
    if retval&1==0 then
      retval=retval+1
      reaper.SNM_SetIntConfigVar("splitautoxfade", retval)
    elseif retval&1==1 then
      retval=retval-1
      reaper.SNM_SetIntConfigVar("splitautoxfade", retval)
    end
    retval2=retval&1==1
  else
    retval2=retval&1==1
  end
  return true, retval2
end


function ultraschall.GetTakeSourcePosByProjectPos(project_pos, take)
-- check with Reaper 7
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTakeSourcePosByProjectPos</slug>
  <requires>
    Ultraschall=5
    Reaper=7.03
    Lua=5.3
  </requires>
  <functioncall>number source_pos = ultraschall.GetTakeSourcePosByProjectPos(number project_pos, MediaItem_Take take)</functioncall>
  <description>
    returns the source-position of a take at a certain project-position. Will obey time-stretch-markers, offsets, etc, as well.
    
    Note: works only within item-start and item-end.
    
    Also note: when the active take of the parent-item is a different one than the one you've passed, this will temporarily switch the active take to the one you've passed.
    That could potentially cause audio-glitches!
    
    This function is expensive, so don't use it permanently!
    
    Returns nil in case of an error
  </description>
  <retvals>
    number source_pos - the position within the source of the take in seconds
  </retvals>
  <parameters>
    number project_pos - the project-position, from which you want to get the take's source-position
    MediaItem_Take take - the take, whose source-position you want to retrieve
  </parameters>
  <linked_to desc="see:">
    inline:GetProjectPosByTakeSourcePos
           gets the project-position by of a take-source-position
  </linked_to>
  <chapter_context>
    Mediaitem Take Management
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem takes, get, source position, project position</tags>
</US_DocBloc>
]]
-- TODO:
-- Rename AND Move(!) Take markers by a huge number of seconds instead of deleting them. 
-- Then add new temporary take-marker, get its position and then remove it again.
-- After that, move them back. That way, you could retain potential future guids in take-markers.
-- Needed workaround, as Reaper, also here, doesn't allow adding a take-marker using an action, when a marker already exists at the position...for whatever reason...

  -- check parameters
  if type(project_pos)~="number" then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "project_pos", "must be a number", -1) return end
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "take", "must be a valid MediaItem_Take", -2) return end
  local item = reaper.GetMediaItemTakeInfo_Value(take, "P_ITEM")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_pos_end = item_pos+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  if project_pos<item_pos or project_pos>item_pos_end then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "project_pos", "must be within itemstart and itemend", -3) return end
  
  reaper.PreventUIRefresh(1)
  
  -- store item-selection and deselect all
  local count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(0),  ultraschall.CreateTrackString_AllTracks(), false)
  local retval = ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
  
  -- get current take-markers and rename them with TUDELU at the beginning
  local takemarkers={}
  for i=reaper.GetNumTakeMarkers(take)-1, 0, -1 do
    takemarkers[i+1]={reaper.GetTakeMarker(take, i)}
    --reaper.SetTakeMarker(take, i, "TUDELU"..takemarkers[i+1][2])
    reaper.DeleteTakeMarker(take, i)
  end
  
  -- add a new take-marker
  local oldpos=reaper.GetCursorPosition()
  reaper.SetEditCurPos(project_pos, false, false)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1)
  local active_take=reaper.GetActiveTake(item)
  reaper.SetActiveTake(take)
  reaper.Main_OnCommand(42390, 0)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
  reaper.SetActiveTake(active_take)
  reaper.SetEditCurPos(oldpos, false, false)
  
  -- get the position and therefore source-position of the added take-marker, then remove it again
  local found=nil
  for i=0, reaper.GetNumTakeMarkers(take) do
    local takemarker_pos, take_marker_name=reaper.GetTakeMarker(take, i)
    if take_marker_name=="" and takemarker_pos~=-1 then    
      reaper.DeleteTakeMarker(take, i)
      found=takemarker_pos
      break
    end
  end
  
  -- rename take-markers back to their old name
  for i=1, #takemarkers do
    reaper.SetTakeMarker(take, i-1, takemarkers[i][2], takemarkers[i][1], takemarkers[i][3])
    --)
  end
  
  -- reselect old item-selection
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  
  reaper.PreventUIRefresh(-1)
  return found
end


function ultraschall.GetProjectPosByTakeSourcePos(source_pos, take)
-- check with Reaper 7
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectPosByTakeSourcePos</slug>
  <requires>
    Ultraschall=5
    Reaper=7.03
    Lua=5.3
  </requires>
  <functioncall>number project_pos = ultraschall.GetProjectPosByTakeSourcePos(number source_pos, MediaItem_Take take)</functioncall>
  <description>
    returns the project-position-representation of the source-position of a take. 
    Will obey time-stretch-markers, offsets, etc, as well.
    
    Note: due API-limitations, you can only get the project position of take-source-positions 0 and higher, so no negative position is allowed.
    
    Also note: when the active take of the parent-item is a different one than the one you've passed, this will temporarily switch the active take to the one you've passed.
    That could potentially cause audio-glitches!
    
    This function is expensive, so don't use it permanently!
    
    Returns nil in case of an error
  </description>
  <linked_to desc="see:">
    inline:GetTakeSourcePosByProjectPos
           gets the take-source-position by project position
  </linked_to>
  <retvals>
    number project_pos - the project-position, converted from the take's source-position
  </retvals>
  <parameters>
    number source_pos - the position within the source of the take in seconds
    MediaItem_Take take - the take, whose source-position you want to retrieve
  </parameters>
  <chapter_context>
    Mediaitem Take Management
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem takes, get, source position, project position</tags>
</US_DocBloc>
]]
-- TODO:
-- Rename AND Move(!) Take markers by a huge number of seconds instead of deleting them. 
-- Then add new temporary take-marker, get its position and then remove it again.
-- After that, move them back. That way, you could retain potential future guids in take-markers.
-- Needed workaround, as Reaper, also here, doesn't allow adding a take-marker using an action, when a marker already exists at the position...for whatever reason...

  -- check parameters
  if type(source_pos)~="number" then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "source_pos", "must be a number", -1) return end
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "take", "must be a valid MediaItem_Take", -2) return end
  if source_pos<0 then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "source_pos", "must be 0 or higher", -3) return end
  local item = reaper.GetMediaItemTakeInfo_Value(take, "P_ITEM")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_pos_end = item_pos+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  reaper.PreventUIRefresh(1)
  
  -- store item-selection and deselect all
  local count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(0),  ultraschall.CreateTrackString_AllTracks(), false)
  local retval = ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
  
  -- get current take-markers and remove them
  takemarkers={}
  for i=reaper.GetNumTakeMarkers(take)-1, 0, -1 do
    takemarkers[i+1]={reaper.GetTakeMarker(take, i)}
    --reaper.SetTakeMarker(take, i, "TUDELU"..takemarkers[i+1][2])
    reaper.DeleteTakeMarker(take, i)
  end
  
  -- set take-marker at source-position of take, select the take and use "next take marker"-action to go to it
  -- then get the cursor position to get the project-position
  -- and finally, delete the take marker reset the view and cursor-position
  local starttime, endtime = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  reaper.SetTakeMarker(take, -1, "", source_pos)
  local oldpos=reaper.GetCursorPosition()
  reaper.SetEditCurPos(-20, false, false)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1)
  local active_take=reaper.GetActiveTake(item)
  reaper.SetActiveTake(take)
  reaper.Main_OnCommand(42394, 0)
  local projectpos=reaper.GetCursorPosition()
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
  reaper.SetActiveTake(active_take)
  reaper.DeleteTakeMarker(take, 0)
  reaper.SetEditCurPos(oldpos, false, false)
  reaper.GetSet_ArrangeView2(0, true, 0, 0, starttime, endtime)

  -- rename take-markers back to their old name
  for i=1, #takemarkers do
    reaper.SetTakeMarker(take, i-1, takemarkers[i][2], takemarkers[i][1], takemarkers[i][3])
  end
  
  -- reselect old item-selection
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  
  reaper.PreventUIRefresh(-1)
  if projectpos<item_pos then 
    return -1
  else
    return projectpos
  end
end

function ultraschall.MediaItem_GetAllVisibleTransients_ActiveTake(item)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaItem_GetAllVisibleTransients_ActiveTake</slug>
  <requires>
    Ultraschall=5
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count_of_transients, table transient_positions = ultraschall.MediaItem_GetAllVisibleTransients_ActiveTake(MediaItem item)</functioncall>
  <description>
    returns the number and positions of visible transients of the active take of a MediaItem.

    returns -1 in case of an error
  </description>
  <parameters>
    MediaItem item - the item, whose visible active-take transients you want to get
  </parameters>
  <retvals>
    integer count_of_transients - the number of found transients
    table transient_positions - a table with all project positions of the transients
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>misc/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, transients, active take, project position</tags>
</US_DocBloc>
]]  
  if ultraschall.type(item)~="MediaItem" then ultraschall.AddErrorMessage("MediaItem_GetAllVisibleTransients", "item", "must be a MediaItem", -1) return -1 end
  reaper.PreventUIRefresh(1)
  local editcursor=reaper.GetCursorPosition()
  local Transients={}
  start=reaper.GetMediaItemInfo_Value(item, "D_POSITION")  
  reaper.SetEditCurPos(start-0.00001, false, false)
  local lastpos=start
  local newpos
  while lastpos~=newpos do
    lastpos=newpos
    reaper.Main_OnCommand(40375, 0)
    newpos=reaper.GetCursorPosition()
    Transients[#Transients+1]=newpos
  end
  table.remove(Transients, #Transients)
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+Transients[1], false)
  firstpos=reaper.GetCursorPosition()
  reaper.Main_OnCommand(40376, 0)
  secondpos=reaper.GetCursorPosition()
  if secondpos~=firstpos then
    table.insert(Transients, 1, secondpos)
  end
  --reaper.MoveEditCursor(-reaper.GetCursorPosition()+editcursor, false)
  reaper.SetEditCurPos(editcursor, false, false)
  reaper.PreventUIRefresh(-1)
  return #Transients, Transients
end

function ultraschall.ItemLane_Count(track)
-- CHECK THIS FIRST, if the bug in Reaper is fixed, that might show a regular track as containing 2 lanes instead of 1!!

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ItemLane_Count</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>integer count_of_lanes = ultraschall.ItemLane_Count(MediaTrack track)</functioncall>
  <description>
    returns the number of item-lanes in a track

    returns -1 in case of an error
  </description>
  <parameters>
    MediaTrack track - the track, whose number of lanes you want to know
  </parameters>
  <retvals>
    integer count_of_lanes - the number of item-lanes
  </retvals>
  <chapter_context>
    Track Management
    Item Lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>misc/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>track management, count, item lanes, fixed lanes</tags>
</US_DocBloc>
]] 
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ItemLane_Count", "track", "must be a MediaTrack", -1) return -1 end
  local val=reaper.GetMediaTrackInfo_Value(track, "I_FREEMODE")
  if val==2 then
    return math.tointeger(reaper.GetMediaTrackInfo_Value(track, "I_NUMFIXEDLANES"))
  else
    return 0
  end
end
--A=ultraschall.ItemLane_Count(reaper.GetTrack(0,0))


function ultraschall.ItemLane_GetFromPoint(x, y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ItemLane_GetFromPoint</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>MediaTrack track, integer item_lane_index = ultraschall.ItemLane_GetFromPoint(integer x, integer y)</functioncall>
  <description>
    returns the MediaTrack and the item-lane at a screen-coordinate

    returns -1 in case of an error
  </description>
  <retvals>
    integer item_lane_index - the index of the item-lane at coordinate; 0, if no lane is existing at coordinates
    MediaTrack track - the track, whose lane is at coordinate
  </retvals>
  <parameters>
    integer x - the x-position of where you want to check for item-lane
    integer y - the y-position of where you want to check for item-lane
  </parameters>
  <chapter_context>
    Track Management
    Item Lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>misc/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>track management, from point, get, lane at position, item lanes, fixed lanes</tags>
</US_DocBloc>
]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ItemLane_GetFromPoint", "x", "must be an integer", -1) return -1 end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ItemLane_GetFromPoint", "y", "must be an integer", -2) return -1 end
  local AAA,BBB = reaper.GetTrackFromPoint(x, y)
  if AAA==nil then return 0, nil end
  return (BBB>>8)+1, AAA
end
--AAAAA=ultraschall.ItemLane_GetFromPoint()

function ultraschall.ItemLane_GetPositionAndHeight(track, lane_index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ItemLane_GetPositionAndHeight</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>number y_position, number height = ultraschall.ItemLane_GetPositionAndHeight(MediaTrack track, integer lane_index)</functioncall>
  <description>
    returns the position and height of an item-lanes in a track

    returns -1 in case of an error
  </description>
  <parameters>
    MediaTrack track - the track, whose lanes-height you want to know
    integer lane_index - the lane, whose y-position and height you want to know
  </parameters>
  <retvals>
    number y_position - the y-position of the lane in the fixed lanes
    number height - the height of the lane in the fixed lanes
  </retvals>
  <chapter_context>
    Track Management
    Item Lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>misc/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>track management, get, item lanes, fixed lanes, height, position</tags>
</US_DocBloc>
]] 
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ItemLane_GetPositionAndHeight", "track", "must be a MediaTrack", -1) return -1 end  
  if math.type(lane_index)~="integer" then ultraschall.AddErrorMessage("ItemLane_GetPositionAndHeight", "lane_index", "must be an integer", -2) return -1 end  
  local val=reaper.GetMediaTrackInfo_Value(track, "I_FREEMODE")
  if val==2 then
    return (1/ultraschall.ItemLane_Count(track))*(lane_index-1), (1/ultraschall.ItemLane_Count(track))
  else
    return -1
  end
end

function ultraschall.ItemLane_GetAllMediaItems(track, lane_idx, start_position, end_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ItemLane_GetAllMediaItems</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>integer count_MediaItems, table MediaItems = ultraschall.ItemLane_GetAllMediaItems(MediaTrack track, integer lane_index, optional number start_position, optional number end_position)</functioncall>
  <description>
    returns the MediaItems from an item-lanes in a track between start_position and end_position

    returns -1 in case of an error
  </description>
  <parameters>
    MediaTrack track - the track, whose MediaItems you want to get
    integer lane_index - the lane, whose MediaItems you want to get
    optional number start_position - the earliest position a MediaItem in a tracklane must have
    optional number end_position - the latest position a MediaItem in a tracklane must have
  </parameters>
  <retvals>
    integer count_MediaItems - the number of items in a lane
    table MediaItems - the found items from a lane
  </retvals>
  <chapter_context>
    Track Management
    Item Lanes
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>misc/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>track management, get, item lanes, mediaitems, startposition, endposition</tags>
</US_DocBloc>
]] 
  if start_position==nil then start_position=0 end
  if end_position==nil then end_position=reaper.GetProjectLength(0) end
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("ItemLane_GetAllMediaItems", "track", "must be a MediaTrack", -1) return -1 end
  if math.type(lane_idx)~="integer" then ultraschall.AddErrorMessage("ItemLane_GetAllMediaItems", "lane_idx", "must be an integer", -2) return -1 end
  if type(start_position)~="number" then ultraschall.AddErrorMessage("ItemLane_GetAllMediaItems", "start_position", "must be either nil or a number", -3) return -1 end
  if type(end_position)~="number" then ultraschall.AddErrorMessage("ItemLane_GetAllMediaItems", "end_position", "must be either nil or a number", -4) return -1 end
  lane_idx=lane_idx-1
  local MediaItemArray={}
  for i=0, reaper.CountTrackMediaItems(track)-1 do
    local item=reaper.GetTrackMediaItem(track, i)
    local lane=reaper.GetMediaItemInfo_Value(item, "I_FIXEDLANE")
    if lane==lane_idx then
      local start=reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      local stop=start+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      if start>=start_position and stop<=end_position then
        MediaItemArray[#MediaItemArray+1]=item
      end
    end
  end
  return #MediaItemArray, MediaItemArray
end

