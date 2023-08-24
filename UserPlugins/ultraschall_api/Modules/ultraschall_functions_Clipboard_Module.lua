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
---        Clipboard Module       ---
-------------------------------------

function ultraschall.GetMediaItemsFromClipboard()  
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaItemsFromClipboard</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray = ultraschall.GetMediaItemsFromClipboard()</functioncall>
  <description>
    Returns the number of mediaitems and a MediaItemStateChunkArray of the mediaitems, as stored in the clipboard.
    
    It does it by pasting the items at the end of the project, getting them and deleting them again.
    
    Use sparsely and with care, as it uses a lot of resources!
  </description>
  <retvals>
    integer count - the number of items in the clipboard
    array MediaItemStatechunkArray - the mediaitem-statechunks of the items in the clipboard. One entry for each mediaitem-statechunk.
  </retvals>
  <chapter_context>
    Clipboard Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Clipboard_Module.lua</source_document>
  <tags>copy and paste, clipboard, mediaitems, statechunk, mediaitemstatechunk</tags>
</US_DocBloc>
]]
  local trackstring_old=ultraschall.GetAllSelectedTracks()
  local Aoldmarker=reaper.GetCursorPosition()
  local Astartpos=reaper.GetProjectLength()
  reaper.SetEditCurPos(Astartpos,false,false)
  reaper.Main_OnCommand(40058,0)
  local Aendpos=reaper.GetProjectLength()
  trackstring = ultraschall.CreateTrackString(1, reaper.CountTracks(), 1)
  local Acount, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(Astartpos-.0000000001, Aendpos, trackstring, true)
  reaper.SetEditCurPos(Aoldmarker,true,false)
  local retval = ultraschall.DeleteMediaItemsFromArray(MediaItemArray)
  reaper.UpdateArrange()
  return Acount, MediaItemStateChunkArray
end

function ultraschall.GetStringFromClipboard_SWS()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetStringFromClipboard_SWS</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.52
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>string clipboard_string = ultraschall.GetStringFromClipboard_SWS()</functioncall>
  <description>
    Returns the content of the clipboard as a string. Uses the SWS-function reaper.CF_GetClipboard, but does everything for you, that is needed for proper use of this function.
  </description>
  <retvals>
    string clipboard_string - the content of the clipboard as a string
  </retvals>
  <chapter_context>
    Clipboard Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Clipboard_Module.lua</source_document>
  <tags>copy and paste, clipboard, sws</tags>
</US_DocBloc>
]]
  return reaper.CF_GetClipboard()
end

function ultraschall.PutMediaItemsToClipboard_MediaItemArray(MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PutMediaItemsToClipboard_MediaItemArray</slug>
  <requires>
    Ultraschall=4.95
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.PutMediaItemsToClipboard_MediaItemArray(MediaItemArray MediaItemArray)</functioncall>
  <description>
    Puts the items in MediaItemArray into the clipboard.
    
    Returns false in case of an error
  </description>
  <parameters>
    MediaItemArray MediaItemArray - an array with all MediaItems, that shall be put into the clipboard
  </parameters>
  <retvals>
    boolean retval - true, if successful; false, if not
  </retvals>
  <chapter_context>
    Clipboard Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Clipboard_Module.lua</source_document>
  <tags>mediaitem, put, clipboard, set</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false then ultraschall.AddErrorMessage("PutMediaItemsToClipboard_MediaItemArray", "MediaItemArray", "must be a valid MediaItemArray", -1) return false end
  reaper.PreventUIRefresh(1)
  local count, MediaItemArray_selected = ultraschall.GetAllSelectedMediaItems() -- get old selection
  for i=0, reaper.CountMediaItems(0)-1 do    
    reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)    
  end
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray) -- select to-be-cut-MediaItems
  reaper.Main_OnCommand(40057,0) -- copy them into clipboard

  for i=1, reaper.CountMediaItems(0)-1 do
    reaper.SetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "B_UISEL", 0)
  end
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray_selected) -- select formerly selected MediaItems
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  return true
end

