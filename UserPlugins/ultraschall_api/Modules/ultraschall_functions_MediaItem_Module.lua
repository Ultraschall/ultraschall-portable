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

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "MediaItem-Management-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
    Ultraschall=4.00
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
  local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter0 = ultraschall.GetLastErrorMessage()
  local retval, count, retMediaItemStateChunkArray = ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)
  local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage() 
  if errorcounter0~=errorcounter and functionname=="CheckMediaItemStateChunkArray" then ultraschall.AddErrorMessage("IsValidMediaItemStateChunkArray",parmname, errormessage, errcode) return false end
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
    Ultraschall=4.00
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
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring,false) -- Buggy: needs to take care of autocrossfade!!
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(0,startposition,trackstring,true)
  local C2,CC2,CCC2=ultraschall.GetAllMediaItemsBetween(endposition,reaper.GetProjectLength(),trackstring,true)
  
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


function ultraschall.RippleCut(startposition, endposition, trackstring, moveenvelopepoints, add_to_clipboard)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items, array MediaItemArray_StateChunk = ultraschall.RippleCut(number startposition, number endposition, string trackstring, boolean moveenvelopepoints, boolean add_to_clipboard)</functioncall>
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
  </parameters>
  <retvals>
    integer number_items - the number of cut items
    array MediaItemArray_StateChunk - an array with the mediaitem-states of the cut items
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
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleCut", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "add_to_clipboard", "must be a boolean", -4) return -1 end  
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleCut", "moveenvelopepoints", "must be a boolean", -5) return -1 end

  local L,trackstring,A2,A3=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring=="" then ultraschall.AddErrorMessage("RippleCut", "trackstring", "must be a valid trackstring", -6) return -1 end
  local delta=endposition-startposition
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring,false)
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring,false)
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(startposition,endposition,trackstring,true)
    
  -- put the items into the clipboard  
  if add_to_clipboard==true then ultraschall.PutMediaItemsToClipboard_MediaItemArray(CC) end
  
  local D=ultraschall.DeleteMediaItemsFromArray(CC) 
  if moveenvelopepoints==true then
    local CountTracks=reaper.CountTracks()
    for i=0, CountTracks-1 do
      for a=1,A3 do
        if tonumber(A2[a])==i+1 then
          local MediaTrack=reaper.GetTrack(0,i)
          retval = ultraschall.MoveTrackEnvelopePointsBy(endposition, reaper.GetProjectLength(), -delta, MediaTrack, true) 
        end
      end
    end
  end
  
  if movemarkers==true then
    ultraschall.MoveMarkersBy(endposition, reaper.GetProjectLength(), -delta, true)
  end
  ultraschall.MoveMediaItemsAfter_By(endposition, -delta, trackstring)
  return C,CCC
end

--A,B=ultraschall.RippleCut(1,2,"1,2,3",true,true)


function ultraschall.RippleCut_Reverse(startposition, endposition, trackstring, moveenvelopepoints, add_to_clipboard)
  --trackstring=ultraschall.CreateTrackString(1,reaper.CountTracks(),1)
  --returns the number of deleted items as well as a table with the ItemStateChunks of all deleted Items  
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut_Reverse</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_items, array MediaItemArray_StateChunk = ultraschall.RippleCut_Reverse(number startposition, number endposition, string trackstring, boolean moveenvelopepoints, boolean add_to_clipboard)</functioncall>
  <description>
    Cuts out all items between startposition and endposition in the tracks given by trackstring. After cut, it moves the remaining items before(!) startposition toward projectend, by the difference between start and endposition.
    
    Returns number of cut items as well as an array with the mediaitem-statechunks, which can be used with functions as <a href="#InsertMediaItem_MediaItemStateChunk">InsertMediaItem_MediaItemStateChunk</a>, reaper.GetItemStateChunk and reaper.SetItemStateChunk.
    
    Returns -1 in case of failure.
  </description>
  <parameters>
    number startposition - the startposition of the section in seconds
    number endposition - the endposition of the section in seconds
    string trackstring - the tracknumbers, separated by ,
    boolean moveenvelopepoints - moves envelopepoints, if existing, as well
    boolean add_to_clipboard - true, puts the cut items into the clipboard; false, don't put into the clipboard
  </parameters>
  <retvals>
    integer number_items - the number of cut items
    array MediaItemArray_StateChunk - an array with the mediaitem-states of the cut items
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

  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Reverse", "startposition", "must be a number", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Reverse", "endposition", "must be a number", -2) return -1 end
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("RippleCut_Reverse", "trackstring", "must be a valid trackstring", -3) return -1 end
  if type(add_to_clipboard)~="boolean" then ultraschall.AddErrorMessage("RippleCut_Reverse", "add_to_clipboard", "must be a boolean", -4) return -1 end
  if type(moveenvelopepoints)~="boolean" then ultraschall.AddErrorMessage("RippleCut_Reverse", "moveenvelopepoints", "must be a boolean", -5) return -1 end
  
  local L,trackstring,A2,A3=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 or trackstring==""  then return -1 end
  local delta=endposition-startposition
  local A,AA=ultraschall.SplitMediaItems_Position(startposition,trackstring,false)
  local B,BB=ultraschall.SplitMediaItems_Position(endposition,trackstring,false)
  local C,CC,CCC=ultraschall.GetAllMediaItemsBetween(startposition,endposition,trackstring,true)

  -- put the items into the clipboard  
  if add_to_clipboard==true then ultraschall.PutMediaItemsToClipboard_MediaItemArray(CC) end

  local D=ultraschall.DeleteMediaItemsFromArray(CC) 
  if moveenvelopepoints==true then
    local CountTracks=reaper.CountTracks()
    for i=0, CountTracks-1 do
      for a=1,A3 do
        if tonumber(A2[a])==i+1 then
          local MediaTrack=reaper.GetTrack(0,i)
          retval = ultraschall.MoveTrackEnvelopePointsBy(0, startposition, delta, MediaTrack, true) 
        end
      end
    end
  end
  
  if movemarkers==true then
    ultraschall.MoveMarkersBy(0, startposition, delta, true)
  end

  ultraschall.MoveMediaItemsBefore_By(endposition, delta, trackstring)  
  return C,CCC
end


--A,AA=ultraschall.RippleCut_Reverse(15,21,"1,2,3", true, true)


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



function ultraschall.InsertMediaItemStateChunkArray(position, MediaItemStateChunkArray, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_items, array MediaItemArray = ultraschall.InsertMediaItemStateChunkArray(number position, array MediaItemStateChunkArray, string trackstring)</functioncall>
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
    Get MediaItem-Takes
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
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemArray = ultraschall.GetAllSelectedMediaItems()</functioncall>
  <description>
    Returns all selected items in the project as MediaItemArray. Empty MediaItemAray if none is found.
  </description>
  <retvals>
    integer count - the number of entries in the returned MediaItemArray
    array MediaItemArray - all selected MediaItems returned as an array
  </retvals>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, get, all, selected, selection</tags>
</US_DocBloc>
]]
  -- prepare variables
  local selitemcount=reaper.CountSelectedMediaItems(0)
  local selitemarray={}
  
  -- get all selected mediaitems and put them into the array
  for i=0, selitemcount-1 do
    selitemarray[i+1]=reaper.GetSelectedMediaItem(0, i)
  end
  return selitemcount, selitemarray
end

--A,B=ultraschall.GetAllSelectedMediaItems()

function ultraschall.SetMediaItemsSelected_TimeSelection()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetMediaItemsSelected_TimeSelection</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.SetMediaItemsSelected_TimeSelection()</functioncall>
  <description>
    Sets all MediaItems selected, that are within the time-selection.
  </description>
  <chapter_context>
    MediaItem Management
    Selected Items
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, set, selected, item, mediaitem, timeselection</tags>
</US_DocBloc>
]]
  reaper.Main_OnCommand(40717,0)
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
  
  return reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER"), MediaTrack
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
  <functioncall>boolean retval = ultraschall.IsItemInTimerange(MediaItem MediaItem, number startposiiton, number endposition, boolean inside)</functioncall>
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
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyActionToMediaItem(MediaItem MediaItem, string actioncommandid, integer repeat_action, boolean midi, optional HWND MIDI_hwnd)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  reaper.SelectAllMediaItems(0, false)
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
  reaper.SelectAllMediaItems(0, false)
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
    Ultraschall=4.00
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
  reaper.SelectAllMediaItems(0, false) -- deselect all
  ultraschall.SetMediaItemsSelected_TimeSelection() -- select only within time-selection
  local count, MediaItemArray=ultraschall.GetAllSelectedMediaItems() -- get all selected items
  local count2
  if MediaItemArray[1]== nil then count2=0 
  else   
    -- check, whether the item is in a track, as demanded by trackstring
    for i=count, 1, -1 do
      if ultraschall.IsItemInTrack3(MediaItemArray[i], trackstring)==false then table.remove(MediaItemArray, i) count=count-1 end
    end
    
    -- remove all items, that aren't properly within time-selection(like items partially in selection)
    if MediaItemArray[1]==nil then count2=0 
    else count2, MediaItemArray=ultraschall.OnlyItemsInTracksAndTimerange(MediaItemArray, trackstring, starttime, endtime, inside) 
    end
  end
    
  -- reset old selection, redraw arrange and return what has been found
  reaper.SelectAllMediaItems(0, false)
  ultraschall.SelectMediaItems_MediaItemArray(oldselection)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  return count2, MediaItemArray
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




function ultraschall.PreviewMediaFile(filename_with_path, gain, loop)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PreviewMediaFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.PreviewMediaFile(string filename_with_path, optional number gain, optional boolean loop)</functioncall>
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
  </parameters>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, preview, play, audio, file</tags>
</US_DocBloc>
]]

  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("PreviewMediaItem", "filename_with_path", "Must be a string.", -1) return false end
  if reaper.file_exists(filename_with_path)== false then ultraschall.AddErrorMessage("PreviewMediaItem", "filename_with_path", "File does not exist.", -2) return false end

  if type(loop)~="boolean" then loop=false end
  if type(gain)~="number" then gain=1 end
  --ultraschall.StopAnyPreview()
  reaper.Xen_StopSourcePreview(-1)
  --if ultraschall.PreviewPCMSource~=nil then reaper.PCM_Source_Destroy(ultraschall.PreviewPCMSource) end
  ultraschall.PreviewPCMSource=reaper.PCM_Source_CreateFromFile(filename_with_path)
  
  local retval=reaper.Xen_StartSourcePreview(ultraschall.PreviewPCMSource, gain, loop)
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
    Get MediaItem-Takes
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
  <slug>DeleteMediaItems_Position</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array MediaItemStateChunkArray = ultraschall.DeleteMediaItems_Between(number startposition, number endposition, string trackstring, boolean inside)</functioncall>
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
    Ultraschall=4.00
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
  reaper.SelectAllMediaItems(0, false) -- deselect all MediaItems
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray) -- select to-be-processed-MediaItems
  for i=1, repeat_action do
    ultraschall.RunCommand(actioncommandid,0) -- apply the action
  end
  reaper.SelectAllMediaItems(0, false) -- deselect all MediaItems
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


function ultraschall.InsertMediaItemFromFile(filename, track, position, endposition, editcursorpos, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval, MediaItem item, number endposition, integer numchannels, integer Samplerate, string Filetype, number editcursorposition, MediaTrack track = ultraschall.InsertMediaItemFromFile(string filename, integer track, number position, number endposition, integer editcursorpos, optional number offset)</functioncall>
  <description>
    Inserts the mediafile filename into the project at position in track
    When giving an rpp-projectfile, it will be rendered by Reaper and inserted as subproject!
    
    Due API-limitations, it creates two undo-points: one for inserting the MediaItem and one for changing the length(when endposition isn't -1).    
    
    Returns -1 in case of failure
  </description>
  <parameters>
    string filename - the path+filename of the mediafile to be inserted into the project
    integer track - the track, in which the file shall be inserted
                  -  0, insert the file into a newly inserted track after the last track
                  - -1, insert the file into a newly inserted track before the first track
    number position - the position of the newly inserted item
    number endposition - the length of the newly created mediaitem; -1, use the length of the sourcefile
    integer editcursorpos - the position of the editcursor after insertion of the mediafile
          - 0 - the old editcursorposition
          - 1 - the position, at which the item was inserted
          - 2 - the end of the newly inserted item
    optional number offset - an offset, to delay the insertion of the item, to overcome possible "too late"-starting of playback of item during recording
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

  -- check parameters
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "filename", "file does not exist", -1) return -1 end
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "must be an integer", -2) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","position", "must be a number", -3) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","endposition", "must be a number", -4) return -1 end
  if endposition<-1 then ultraschall.AddErrorMessage("InsertMediaItemFromFile","endposition", "must be bigger/equal 0; or -1 for sourcefilelength", -5) return -1 end
  if math.type(editcursorpos)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "editcursorpos", "must be an integer between 0 and 2", -6) return -1 end
  if track<-1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "no such track available", -7) return -1 end  
  if offset~=nil and type(offset)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","offset", "must be either nil or a number", -8) return -1 end  
  if offset==nil then offset=0 end
    
  -- where to insert and where to have the editcursor after insert
  local editcursor, mode
  if editcursorpos==0 then editcursor=reaper.GetCursorPosition()
  elseif editcursorpos==1 then editcursor=position
  elseif editcursorpos==2 then editcursor=position+ultraschall.GetMediafileAttributes(filename)
  else ultraschall.AddErrorMessage("InsertMediaItemFromFile","editcursorpos", "must be an integer between 0 and 2", -6) return -1
  end
  
  -- insert file
  local Length, Numchannels, Samplerate, Filetype = ultraschall.GetMediafileAttributes(filename) -- mediaattributes, like length
  local startTime, endTime = reaper.BR_GetArrangeView(0) -- get current arrange-view-range
  local mode=0
  if track>=0 and track<reaper.CountTracks(0) then
    mode=0
  elseif track==0 then
    mode=0
    track=reaper.CountTracks(0)
  elseif track==-1 then
    mode=0
    track=1
    reaper.InsertTrackAtIndex(0,false)
  end
  local SelectedTracks=ultraschall.CreateTrackString_SelectedTracks() -- get old track-selection
  ultraschall.SetTracksSelected(tostring(track), true) -- set track selected, where we want to insert the item
  reaper.SetEditCurPos(position+offset, false, false) -- change editcursorposition to where we want to insert the item
  local CountMediaItems=reaper.CountMediaItems(0) -- the number of items available; the new one will be number of items + 1
  local LLL=ultraschall.GetAllMediaItemGUIDs()
  if LLL[1]==nil then LLL[1]="tudelu" end
  local integer=reaper.InsertMedia(filename, mode)  -- insert item with file
  local LLL2=ultraschall.GetAllMediaItemGUIDs()
  local A,B=ultraschall.CompareArrays(LLL, LLL2)
  local item=reaper.BR_GetMediaItemByGUID(0, A[1])
  if endposition~=-1 then reaper.SetMediaItemInfo_Value(item, "D_LENGTH", endposition) end
  
  reaper.SetEditCurPos(editcursor, false, false)  -- set editcursor to new position
  reaper.BR_SetArrangeView(0, startTime, endTime) -- reset to old arrange-view-range
  if SelectedTracks~="" then ultraschall.SetTracksSelected(SelectedTracks, true) end -- reset old trackselection
  return 0, item, Length, Numchannels, Samplerate, Filetype, editcursor, reaper.GetMediaItem_Track(item)
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
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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

function ultraschall.GetItem_ClickState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItem_ClickState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean clickstate, number position, MediaItem item, MediaItem_Take take = ultraschall.GetItem_ClickState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem management, get, clicked, item</tags>
</US_DocBloc>
--]]
  local B=reaper.SNM_GetDoubleConfigVar("uiscale", -999)
  local X,Y=reaper.GetMousePosition()
  local Item, ItemTake = reaper.GetItemFromPoint(X,Y, true)
  if Item==nil then Item=ultraschall.ItemClickState_OldItem end
  if Item~=nil then ultraschall.ItemClickState_OldItem=Item end
  if ItemTake==nil then ItemTake=ultraschall.ItemClickState_OldTake end
  if ItemTake~=nil then ultraschall.ItemClickState_OldTake=ItemTake end
  if tostring(B)=="-1.#QNAN" or Item==nil then
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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

