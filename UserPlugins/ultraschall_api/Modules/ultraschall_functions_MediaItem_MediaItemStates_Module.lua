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
---   MediaItem:  States Module   ---
-------------------------------------


function ultraschall.GetItemPosition(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position = ultraschall.GetItemPosition(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the POSITION-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose position you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number position - the position in seconds, as set in the statechunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, position</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemPosition","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemPosition","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("POSITION( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" (.-) (.-) "))
end

--lol, sc=reaper.GetItemStateChunk(reaper.GetMediaItem(0,0),"",false)
--A,B=ultraschall.GetItemPosition(reaper.GetMediaItem(0,0), sc)


function ultraschall.GetItemLength(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number length = ultraschall.GetItemLength(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the LENGTH-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose length you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number length - the length in seconds, as set in the statechunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, length</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemLength","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemLength","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("LENGTH( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" (.-) (.-) "))
end

--A=ultraschall.GetItemLength(reaper.GetMediaItem(0,0))

function ultraschall.GetItemSnapOffset(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSnapOffset</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number snapoffset = ultraschall.GetItemSnapOffset(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the SNAPOFFS-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose snapoffset you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number snapoffset - the snapoffset in seconds, as set in the statechunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, snap, offset</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemSnapOffset","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemSnapOffset","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("SNAPOFFS( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" (.-) (.-) "))
end


--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A=ultraschall.GetItemSnapOffset(reaper.GetMediaItem(0,0))


function ultraschall.GetItemLoop(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemLoop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer loopstate = ultraschall.GetItemLoop(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the LOOP-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer loopstate - the loopstate, as set in the statechunk; 1, loop source; 0, don't loop source
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, loop</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemLoop","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemLoop","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("LOOP( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" (.-) (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A=ultraschall.GetItemLoop(reaper.GetMediaItem(0,0))

function ultraschall.GetItemAllTakes(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemAllTakes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer alltakes = ultraschall.GetItemAllTakes(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the ALLTAKES-entry of a MediaItem or MediaItemStateChunk.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose all-takes-playstate you want to know; nil, use parameter MediaItemStatechunk instead
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer alltakes - Play all takes(1) or don't play all takes(0)
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, alltakes, all, takes</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemAllTakes","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemAllTakes","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("ALLTAKES( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" (.-) (.-) "))
end

--A=ultraschall.GetItemAllTakes(reaper.GetMediaItem(0,0))

function ultraschall.GetItemFadeIn(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemFadeIn</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>number curvetype1, number fadein_length, number fadein_length2, number curvetype2, integer fadestate5, number curve, number fadestate7 = ultraschall.GetItemFadeIn(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the FADEIN-entry of a MediaItem or MediaItemStateChunk.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose fadein-state you want to know; nil, use parameter MediaItemStatechunk instead
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number curvetype1 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype2
    number fadein_length - fadein in seconds
    number fadein_length2 - the fadein-length in seconds; overrides fadein_length and will be moved to fadein_length when fadein-length changes(e.g. mouse-drag); might be autocrossfade-length
    number curvetype2 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype1
    integer fadestate5 - unknown, either 0 or 1; fadeinstate entry as set in the rppxml-mediaitem-statechunk
    number curve - curve -1 to 1
    number fadestate7 - unknown
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, fade in</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemFadeIn","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemFadeIn","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("FADEIN( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1",false)
--A1,A2,A3,A4,A5,A6=ultraschall.GetItemFadeIn(reaper.GetMediaItem(0,0))

function ultraschall.GetItemFadeOut(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemFadeOut</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>number curvetype1, number fadeout_length, number fadeout_length2, number curvetype2, integer fadestate5, number curve, number fadestate7 = ultraschall.GetItemFadeOut(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the values of the FADEOUT-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose fadeout-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number curvetype1 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype2
    number fadeout_length - the current fadeout-length in seconds
    number fadeout_length2 - the fadeout-length in seconds; overrides fadeout_length and will be moved to fadeout_length when fadeout-length changes(e.g. mouse-drag); might be autocrossfade-length
    number curvetype2 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype1
    integer fadestate5 - unknown, either 0 or 1; fadeinstate entry as set in the rppxml-mediaitem-statechunk
    number curve - curvation of the fadeout, -1 to 1
    number fadestate7 - unknown
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, fade out</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemFadeOut","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemFadeOut","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("FADEOUT( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A,B,C,D,E,F,G,H,I=ultraschall.GetItemFadeOut(reaper.GetMediaItem(0,0))

function ultraschall.GetItemMute(MediaItem, statechunk)
--  reaper.MB(statechunk,"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemMute</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>integer mutestate1, integer mutestate2 = ultraschall.GetItemMute(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns mutestate-entry of a MediaItem or MediaItemStateChunk.
    
    It's the MUTE-entry.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose mute-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer mutestate1 - actual mutestate, item solo overrides; 0, item is muted; 1, item is unmuted
    integer mutestate2 - mutestate, ignores solo; 0, item is muted; 1, item is unmuted
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, fade out</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemMute","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemMute","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("MUTE( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A=reaper.GetMediaItem(0,0)
--Amutestate = ultraschall.GetItemMute(reaper.GetMediaItem(0,0))

function ultraschall.GetItemFadeFlag(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemFadeFlag</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer autofade_state = ultraschall.GetItemFadeFlag(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns autofade-entry of a MediaItem or MediaItemStateChunk.
    It's the FADEFLAG-entry.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose fadeflag-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer autofade_state - the autofade-state; 1, autofade is off; nil, autofade is on
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, autofade</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemFadeFlag","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemFadeFlag","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("FADEFLAG( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--AL=ultraschall.GetItemFadeFlag(reaper.GetMediaItem(0,0))

function ultraschall.GetItemLock(MediaItem, statechunk)
--  reaper.MB(statechunk,"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemLock</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer lock_state = ultraschall.GetItemLock(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns itemlock-entry of a MediaItem or MediaItemStateChunk.
    
    It's the LOCK-entry.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose itemlock-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer lock_state - the lock-state; 1, item is locked; nil, item is not locked
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, lock</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemLock","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemLock","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("LOCK( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--AL=ultraschall.GetItemLock(reaper.GetMediaItem(0,0))

function ultraschall.GetItemSelected(MediaItem, statechunk)
--  reaper.MB(statechunk,"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSelected</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer selected_state = ultraschall.GetItemSelected(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns item-selected-state-entry of a MediaItem or MediaItemStateChunk.
    
    It's the SEL-entry.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose selection-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer selected_state - the item-selected-state; 1 - item is selected; 0 - item is not selected
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, selected</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemSelected","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemSelected","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("SEL( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--AL=ultraschall.GetItemSelected(reaper.GetMediaItem(0,0))

function ultraschall.GetItemGroup(MediaItem, statechunk)
--  reaper.MB(statechunk,"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemGroup</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer item_group = ultraschall.GetItemGroup(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns group of a MediaItem or MediaItemStateChunk, where the item belongs to.
    
    It's the GROUP-entry
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose ItemGroup-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer item_group - the group the item belongs to; nil, if item doesn't belong to any group
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, group</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemGroup","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemGroup","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("GROUP( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A,B,C=ultraschall.GetItemGroup(reaper.GetMediaItem(0,0))


function ultraschall.GetItemIGUID(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemIGUID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string IGUID = ultraschall.GetItemIGUID(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the IGUID-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose IGUID-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string IGUID - the IGUID of the item
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, guid, iguid</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemIGUID","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemIGUID","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("IGUID( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return statechunk:match(" (.-) "), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A=ultraschall.GetItemIGUID(reaper.GetMediaItem(0,0))

function ultraschall.GetItemIID(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemIID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer IID = ultraschall.GetItemIID(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the IID-entry of a MediaItem or MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose ItemIID-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer IID - the IID of the item; the item-id, which is basically a counter of all items created within this project. May change, so use it only as a counter. If you want to identify a specific item, use GUID and IGUID instead.
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, iid</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemIID","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemIID","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("IID( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A=ultraschall.GetItemIID(reaper.GetMediaItem(0,0))

function ultraschall.GetItemName(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string name = ultraschall.GetItemName(MediaItem MediaItem, string MediaItemStateChunk)</functioncall>
  <description>
    Returns the name-entry of a MediaItem or MediaItemStateChunk.
    
    It's the NAME-entry.
    
    It is the name of the first take in the MediaItem!

    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose itemname-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string name - the name of the item
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, name</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemName","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemName","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("NAME (.-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
  local name=statechunk:match("\"(.-)\"")
  if name==nil then name=statechunk:match("(.-) ") end
  
  return name
end


--A=ultraschall.GetItemName(reaper.GetMediaItem(0,0))

--MESPOTINE

function ultraschall.GetItemVolPan(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemVolPan</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number volpan1, number pan, number volume, number volpan4 = ultraschall.GetItemVolPan(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the vol/pan-entries of a MediaItem or MediaItemStateChunk.
    
    It's the VOLPAN-entry.
    
    Use ultraschall.MKVOL2DB() to convert retval volume to dB.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose volpan-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number volpan1 - unknown; 0, seems to mute the item without using mute; 1, seems to keep the item unmuted
    number pan - from -1(100%L) to 1(100%R), 0 is center
    number volume - from 0(-inf) to 3.981072(+12db), 1 is 0db; higher numbers are allowed; negative means phase inverted
    number volpan4 - unknown
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, volume, pan</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemVolPan","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemVolPan","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("VOLPAN( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A1,A2,A3,A4,A5=ultraschall.GetItemVolPan(reaper.GetMediaItem(0,0))

function ultraschall.GetItemSampleOffset(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemSampleOffset</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>number sampleoffset, optional number sampleoffset2 = ultraschall.GetItemSampleOffset(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the sampleoffset-entry of a MediaItem or MediaItemStateChunk.
    
    It's the SOFFS-entry.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose sample-offset-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number sampleoffset - sampleoffset in seconds
    optional number sampleoffset2 - unknown
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, sample, offset</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemSampleOffset","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemSampleOffset","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("SOFFS( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A1,A2,A3,A4,A5=ultraschall.GetItemSampleOffset(reaper.GetMediaItem(0,0))

function ultraschall.GetItemPlayRate(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemPlayRate</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>number playbackrate, integer preserve_pitch, number pitch_adjust, integer takepitch_timestretch_mode, integer optimize_tonal_content, number stretch_marker_fadesize = ultraschall.GetItemPlayRate(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the playback-rate-entries of a MediaItem or MediaItemStateChunk.
    
    It's the PLAYRATE-entry.
  
    takepitch_timestretch_mode can be 
    
            SoundTouch:
            0 - Default settings
            1 - High Quality
            2 - Fast

        Simple windowed (fast):
            131072 - 50ms window, 25ms fade
            131073 - 50ms window, 16ms fade
            131074 - 50ms window, 10ms fade
            131075 - 50ms window, 7ms fade
            131076 - 75ms window, 37ms fade
            131077 - 75ms window, 25ms fade
            131078 - 75ms window, 15ms fade
            131079 - 75ms window, 10ms fade
            131080 - 100ms window, 50ms fade
            131081 - 100ms window, 33ms fade
            131082 - 100ms window, 20ms fade
            131083 - 100ms window, 14ms fade
            131084 - 150ms window, 75ms fade
            131085 - 150ms window, 50ms fade
            131086 - 150ms window, 30ms fade
            131087 - 150ms window, 21ms fade
            131088 - 225ms window, 112ms fade
            131089 - 225ms window, 75ms fade
            131090 - 225ms window, 45ms fade
            131091 - 225ms window, 32ms fade
            131092 - 300ms window, 150ms fade
            131093 - 300ms window, 100ms fade
            131094 - 300ms window, 60ms fade
            131095 - 300ms window, 42ms fade
            131096 - 40ms window, 20ms fade
            131097 - 40ms window, 13ms fade
            131098 - 40ms window, 8ms fade
            131099 - 40ms window, 5ms fade
            131100 - 30ms window, 15ms fade
            131101 - 30ms window, 10ms fade
            131102 - 30ms window, 6ms fade
            131103 - 30ms window, 4ms fade
            131104 - 20ms window, 10ms fade
            131105 - 20ms window, 6ms fade
            131106 - 20ms window, 4ms fade
            131107 - 20ms window, 2ms fade
            131108 - 10ms window, 5ms fade
            131109 - 10ms window, 3ms fade
            131110 - 10ms window, 2ms fade
            131111 - 10ms window, 1ms fade
            131112 - 5ms window, 2ms fade
            131113 - 5ms window, 1ms fade
            131114 - 5ms window, 1ms fade
            131115 - 5ms window, 1ms fade
            131116 - 3ms window, 1ms fade
            131117 - 3ms window, 1ms fade
            131118 - 3ms window, 1ms fade
            131119 - 3ms window, 1ms fade

        Ã©lastique 2.2.8 Pro:
            393216 - Normal
            393217 - Preserve Formants (Lowest Pitches)
            393218 - Preserve Formants (Lower Pitches)
            393219 - Preserve Formants (Low Pitches)
            393220 - Preserve Formants (Most Pitches)
            393221 - Preserve Formants (High Pitches)
            393222 - Preserve Formants (Higher Pitches)
            393223 - Preserve Formants (Highest Pitches)
            393224 - Mid/Side
            393225 - Mid/Side, Preserve Formants (Lowest Pitches)
            393226 - Mid/Side, Preserve Formants (Lower Pitches)
            393227 - Mid/Side, Preserve Formants (Low Pitches)
            393228 - Mid/Side, Preserve Formants (Most Pitches)
            393229 - Mid/Side, Preserve Formants (High Pitches)
            393230 - Mid/Side, Preserve Formants (Higher Pitches)
            393231 - Mid/Side, Preserve Formants (Highest Pitches)
            393232 - Synchronized: Normal
            393233 - Synchronized: Preserve Formants (Lowest Pitches)
            393234 - Synchronized: Preserve Formants (Lower Pitches)
            393235 - Synchronized: Preserve Formants (Low Pitches)
            393236 - Synchronized: Preserve Formants (Most Pitches)
            393237 - Synchronized: Preserve Formants (High Pitches)
            393238 - Synchronized: Preserve Formants (Higher Pitches)
            393239 - Synchronized: Preserve Formants (Highest Pitches)
            393240 - Synchronized:  Mid/Side
            393241 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            393242 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            393243 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            393244 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            393245 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            393246 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            393247 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 2.2.8 Efficient:
            458752 - Normal
            458753 - Mid/Side
            458754 - Synchronized: Normal
            458755 - Synchronized: Mid/Side

        Ã©lastique 2.2.8 Soloist:
            524288 - Monophonic
            524289 - Monophonic [Mid/Side]
            524290 - Speech
            524291 - Speech [Mid/Side]

        Ã©lastique 3.3.0 Pro:
            589824 - Normal
            589825 - Preserve Formants (Lowest Pitches)
            589826 - Preserve Formants (Lower Pitches)
            589827 - Preserve Formants (Low Pitches)
            589828 - Preserve Formants (Most Pitches)
            589829 - Preserve Formants (High Pitches)
            589830 - Preserve Formants (Higher Pitches)
            589831 - Preserve Formants (Highest Pitches)
            589832 - Mid/Side
            589833 - Mid/Side, Preserve Formants (Lowest Pitches)
            589834 - Mid/Side, Preserve Formants (Lower Pitches)
            589835 - Mid/Side, Preserve Formants (Low Pitches)
            589836 - Mid/Side, Preserve Formants (Most Pitches)
            589837 - Mid/Side, Preserve Formants (High Pitches)
            589838 - Mid/Side, Preserve Formants (Higher Pitches)
            589839 - Mid/Side, Preserve Formants (Highest Pitches)
            589840 - Synchronized: Normal
            589841 - Synchronized: Preserve Formants (Lowest Pitches)
            589842 - Synchronized: Preserve Formants (Lower Pitches)
            589843 - Synchronized: Preserve Formants (Low Pitches)
            589844 - Synchronized: Preserve Formants (Most Pitches)
            589845 - Synchronized: Preserve Formants (High Pitches)
            589846 - Synchronized: Preserve Formants (Higher Pitches)
            589847 - Synchronized: Preserve Formants (Highest Pitches)
            589848 - Synchronized:  Mid/Side
            589849 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            589850 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            589851 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            589852 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            589853 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            589854 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            589855 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 3.3.0 Efficient:
            655360 - Normal
            655361 - Mid/Side
            655362 - Synchronized: Normal
            655363 - Synchronized: Mid/Side

        Ã©lastique 3.3.0 Soloist:
            720896 - Monophonic
            720897 - Monophonic [Mid/Side]
            720898 - Speech
            720899 - Speech [Mid/Side]


        Rubber Band Library - Default
            851968 - nothing

        Rubber Band Library - Preserve Formants
            851969 - Preserve Formants

        Rubber Band Library - Mid/Side
            851970 - Mid/Side

        Rubber Band Library - Preserve Formants, Mid/Side
            851971 - Preserve Formants, Mid/Side

        Rubber Band Library - Independent Phase
            851972 - Independent Phase

        Rubber Band Library - Preserve Formants, Independent Phase
            851973 - Preserve Formants, Independent Phase

        Rubber Band Library - Mid/Side, Independent Phase
            851974 - Mid/Side, Independent Phase

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase
            851975 - Preserve Formants, Mid/Side, Independent Phase

        Rubber Band Library - Time Domain Smoothing
            851976 - Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Time Domain Smoothing
            851977 - Preserve Formants, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Time Domain Smoothing
            851978 - Mid/Side, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Time Domain Smoothing
            851979 - Preserve Formants, Mid/Side, Time Domain Smoothing

        Rubber Band Library - Independent Phase, Time Domain Smoothing
            851980 - Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Independent Phase, Time Domain Smoothing
            851981 - Preserve Formants, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Independent Phase, Time Domain Smoothing
            851982 - Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing
            851983 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed
            851984 - nothing
            851985 - Preserve Formants
            851986 - Mid/Side
            851987 - Preserve Formants, Mid/Side
            851988 - Independent Phase
            851989 - Preserve Formants, Independent Phase
            851990 - Mid/Side, Independent Phase
            851991 - Preserve Formants, Mid/Side, Independent Phase
            851992 - Time Domain Smoothing
            851993 - Preserve Formants, Time Domain Smoothing
            851994 - Mid/Side, Time Domain Smoothing
            851995 - Preserve Formants, Mid/Side, Time Domain Smoothing
            851996 - Independent Phase, Time Domain Smoothing
            851997 - Preserve Formants, Independent Phase, Time Domain Smoothing
            851998 - Mid/Side, Independent Phase, Time Domain Smoothing
            851999 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth
            852000 - nothing
            852001 - Preserve Formants
            852002 - Mid/Side
            852003 - Preserve Formants, Mid/Side
            852004 - Independent Phase
            852005 - Preserve Formants, Independent Phase
            852006 - Mid/Side, Independent Phase
            852007 - Preserve Formants, Mid/Side, Independent Phase
            852008 - Time Domain Smoothing
            852009 - Preserve Formants, Time Domain Smoothing
            852010 - Mid/Side, Time Domain Smoothing
            852011 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852012 - Independent Phase, Time Domain Smoothing
            852013 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852014 - Mid/Side, Independent Phase, Time Domain Smoothing
            852015 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive
            852016 - nothing
            852017 - Preserve Formants
            852018 - Mid/Side
            852019 - Preserve Formants, Mid/Side
            852020 - Independent Phase
            852021 - Preserve Formants, Independent Phase
            852022 - Mid/Side, Independent Phase
            852023 - Preserve Formants, Mid/Side, Independent Phase
            852024 - Time Domain Smoothing
            852025 - Preserve Formants, Time Domain Smoothing
            852026 - Mid/Side, Time Domain Smoothing
            852027 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852028 - Independent Phase, Time Domain Smoothing
            852029 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852030 - Mid/Side, Independent Phase, Time Domain Smoothing
            852031 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive
            852032 - nothing
            852033 - Preserve Formants
            852034 - Mid/Side
            852035 - Preserve Formants, Mid/Side
            852036 - Independent Phase
            852037 - Preserve Formants, Independent Phase
            852038 - Mid/Side, Independent Phase
            852039 - Preserve Formants, Mid/Side, Independent Phase
            852040 - Time Domain Smoothing
            852041 - Preserve Formants, Time Domain Smoothing
            852042 - Mid/Side, Time Domain Smoothing
            852043 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852044 - Independent Phase, Time Domain Smoothing
            852045 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852046 - Mid/Side, Independent Phase, Time Domain Smoothing
            852047 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive
            852048 - nothing
            852049 - Preserve Formants
            852050 - Mid/Side
            852051 - Preserve Formants, Mid/Side
            852052 - Independent Phase
            852053 - Preserve Formants, Independent Phase
            852054 - Mid/Side, Independent Phase
            852055 - Preserve Formants, Mid/Side, Independent Phase
            852056 - Time Domain Smoothing
            852057 - Preserve Formants, Time Domain Smoothing
            852058 - Mid/Side, Time Domain Smoothing
            852059 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852060 - Independent Phase, Time Domain Smoothing
            852061 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852062 - Mid/Side, Independent Phase, Time Domain Smoothing
            852063 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft
            852064 - nothing
            852065 - Preserve Formants
            852066 - Mid/Side
            852067 - Preserve Formants, Mid/Side
            852068 - Independent Phase
            852069 - Preserve Formants, Independent Phase
            852070 - Mid/Side, Independent Phase
            852071 - Preserve Formants, Mid/Side, Independent Phase
            852072 - Time Domain Smoothing
            852073 - Preserve Formants, Time Domain Smoothing
            852074 - Mid/Side, Time Domain Smoothing
            852075 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852076 - Independent Phase, Time Domain Smoothing
            852077 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852078 - Mid/Side, Independent Phase, Time Domain Smoothing
            852079 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft
            852080 - nothing
            852081 - Preserve Formants
            852082 - Mid/Side
            852083 - Preserve Formants, Mid/Side
            852084 - Independent Phase
            852085 - Preserve Formants, Independent Phase
            852086 - Mid/Side, Independent Phase
            852087 - Preserve Formants, Mid/Side, Independent Phase
            852088 - Time Domain Smoothing
            852089 - Preserve Formants, Time Domain Smoothing
            852090 - Mid/Side, Time Domain Smoothing
            852091 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852092 - Independent Phase, Time Domain Smoothing
            852093 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852094 - Mid/Side, Independent Phase, Time Domain Smoothing
            852095 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft
            852096 - nothing
            852097 - Preserve Formants
            852098 - Mid/Side
            852099 - Preserve Formants, Mid/Side
            852100 - Independent Phase
            852101 - Preserve Formants, Independent Phase
            852102 - Mid/Side, Independent Phase
            852103 - Preserve Formants, Mid/Side, Independent Phase
            852104 - Time Domain Smoothing
            852105 - Preserve Formants, Time Domain Smoothing
            852106 - Mid/Side, Time Domain Smoothing
            852107 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852108 - Independent Phase, Time Domain Smoothing
            852109 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852110 - Mid/Side, Independent Phase, Time Domain Smoothing
            852111 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ
            852112 - nothing
            852113 - Preserve Formants
            852114 - Mid/Side
            852115 - Preserve Formants, Mid/Side
            852116 - Independent Phase
            852117 - Preserve Formants, Independent Phase
            852118 - Mid/Side, Independent Phase
            852119 - Preserve Formants, Mid/Side, Independent Phase
            852120 - Time Domain Smoothing
            852121 - Preserve Formants, Time Domain Smoothing
            852122 - Mid/Side, Time Domain Smoothing
            852123 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852124 - Independent Phase, Time Domain Smoothing
            852125 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852126 - Mid/Side, Independent Phase, Time Domain Smoothing
            852127 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ
            852128 - nothing
            852129 - Preserve Formants
            852130 - Mid/Side
            852131 - Preserve Formants, Mid/Side
            852132 - Independent Phase
            852133 - Preserve Formants, Independent Phase
            852134 - Mid/Side, Independent Phase
            852135 - Preserve Formants, Mid/Side, Independent Phase
            852136 - Time Domain Smoothing
            852137 - Preserve Formants, Time Domain Smoothing
            852138 - Mid/Side, Time Domain Smoothing
            852139 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852140 - Independent Phase, Time Domain Smoothing
            852141 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852142 - Mid/Side, Independent Phase, Time Domain Smoothing
            852143 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ
            852144 - nothing
            852145 - Preserve Formants
            852146 - Mid/Side
            852147 - Preserve Formants, Mid/Side
            852148 - Independent Phase
            852149 - Preserve Formants, Independent Phase
            852150 - Mid/Side, Independent Phase
            852151 - Preserve Formants, Mid/Side, Independent Phase
            852152 - Time Domain Smoothing
            852153 - Preserve Formants, Time Domain Smoothing
            852154 - Mid/Side, Time Domain Smoothing
            852155 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852156 - Independent Phase, Time Domain Smoothing
            852157 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852158 - Mid/Side, Independent Phase, Time Domain Smoothing
            852159 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ
            852160 - nothing
            852161 - Preserve Formants
            852162 - Mid/Side
            852163 - Preserve Formants, Mid/Side
            852164 - Independent Phase
            852165 - Preserve Formants, Independent Phase
            852166 - Mid/Side, Independent Phase
            852167 - Preserve Formants, Mid/Side, Independent Phase
            852168 - Time Domain Smoothing
            852169 - Preserve Formants, Time Domain Smoothing
            852170 - Mid/Side, Time Domain Smoothing
            852171 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852172 - Independent Phase, Time Domain Smoothing
            852173 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852174 - Mid/Side, Independent Phase, Time Domain Smoothing
            852175 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ
            852176 - nothing
            852177 - Preserve Formants
            852178 - Mid/Side
            852179 - Preserve Formants, Mid/Side
            852180 - Independent Phase
            852181 - Preserve Formants, Independent Phase
            852182 - Mid/Side, Independent Phase
            852183 - Preserve Formants, Mid/Side, Independent Phase
            852184 - Time Domain Smoothing
            852185 - Preserve Formants, Time Domain Smoothing
            852186 - Mid/Side, Time Domain Smoothing
            852187 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852188 - Independent Phase, Time Domain Smoothing
            852189 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852190 - Mid/Side, Independent Phase, Time Domain Smoothing
            852191 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ
            852192 - nothing
            852193 - Preserve Formants
            852194 - Mid/Side
            852195 - Preserve Formants, Mid/Side
            852196 - Independent Phase
            852197 - Preserve Formants, Independent Phase
            852198 - Mid/Side, Independent Phase
            852199 - Preserve Formants, Mid/Side, Independent Phase
            852200 - Time Domain Smoothing
            852201 - Preserve Formants, Time Domain Smoothing
            852202 - Mid/Side, Time Domain Smoothing
            852203 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852204 - Independent Phase, Time Domain Smoothing
            852205 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852206 - Mid/Side, Independent Phase, Time Domain Smoothing
            852207 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ
            852208 - nothing
            852209 - Preserve Formants
            852210 - Mid/Side
            852211 - Preserve Formants, Mid/Side
            852212 - Independent Phase
            852213 - Preserve Formants, Independent Phase
            852214 - Mid/Side, Independent Phase
            852215 - Preserve Formants, Mid/Side, Independent Phase
            852216 - Time Domain Smoothing
            852217 - Preserve Formants, Time Domain Smoothing
            852218 - Mid/Side, Time Domain Smoothing
            852219 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852220 - Independent Phase, Time Domain Smoothing
            852221 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852222 - Mid/Side, Independent Phase, Time Domain Smoothing
            852223 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ
            852224 - nothing
            852225 - Preserve Formants
            852226 - Mid/Side
            852227 - Preserve Formants, Mid/Side
            852228 - Independent Phase
            852229 - Preserve Formants, Independent Phase
            852230 - Mid/Side, Independent Phase
            852231 - Preserve Formants, Mid/Side, Independent Phase
            852232 - Time Domain Smoothing
            852233 - Preserve Formants, Time Domain Smoothing
            852234 - Mid/Side, Time Domain Smoothing
            852235 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852236 - Independent Phase, Time Domain Smoothing
            852237 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852238 - Mid/Side, Independent Phase, Time Domain Smoothing
            852239 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ
            852240 - nothing
            852241 - Preserve Formants
            852242 - Mid/Side
            852243 - Preserve Formants, Mid/Side
            852244 - Independent Phase
            852245 - Preserve Formants, Independent Phase
            852246 - Mid/Side, Independent Phase
            852247 - Preserve Formants, Mid/Side, Independent Phase
            852248 - Time Domain Smoothing
            852249 - Preserve Formants, Time Domain Smoothing
            852250 - Mid/Side, Time Domain Smoothing
            852251 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852252 - Independent Phase, Time Domain Smoothing
            852253 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852254 - Mid/Side, Independent Phase, Time Domain Smoothing
            852255 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent
            852256 - nothing
            852257 - Preserve Formants
            852258 - Mid/Side
            852259 - Preserve Formants, Mid/Side
            852260 - Independent Phase
            852261 - Preserve Formants, Independent Phase
            852262 - Mid/Side, Independent Phase
            852263 - Preserve Formants, Mid/Side, Independent Phase
            852264 - Time Domain Smoothing
            852265 - Preserve Formants, Time Domain Smoothing
            852266 - Mid/Side, Time Domain Smoothing
            852267 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852268 - Independent Phase, Time Domain Smoothing
            852269 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852270 - Mid/Side, Independent Phase, Time Domain Smoothing
            852271 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent
            852272 - nothing
            852273 - Preserve Formants
            852274 - Mid/Side
            852275 - Preserve Formants, Mid/Side
            852276 - Independent Phase
            852277 - Preserve Formants, Independent Phase
            852278 - Mid/Side, Independent Phase
            852279 - Preserve Formants, Mid/Side, Independent Phase
            852280 - Time Domain Smoothing
            852281 - Preserve Formants, Time Domain Smoothing
            852282 - Mid/Side, Time Domain Smoothing
            852283 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852284 - Independent Phase, Time Domain Smoothing
            852285 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852286 - Mid/Side, Independent Phase, Time Domain Smoothing
            852287 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent
            852288 - nothing
            852289 - Preserve Formants
            852290 - Mid/Side
            852291 - Preserve Formants, Mid/Side
            852292 - Independent Phase
            852293 - Preserve Formants, Independent Phase
            852294 - Mid/Side, Independent Phase
            852295 - Preserve Formants, Mid/Side, Independent Phase
            852296 - Time Domain Smoothing
            852297 - Preserve Formants, Time Domain Smoothing
            852298 - Mid/Side, Time Domain Smoothing
            852299 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852300 - Independent Phase, Time Domain Smoothing
            852301 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852302 - Mid/Side, Independent Phase, Time Domain Smoothing
            852303 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent
            852304 - nothing
            852305 - Preserve Formants
            852306 - Mid/Side
            852307 - Preserve Formants, Mid/Side
            852308 - Independent Phase
            852309 - Preserve Formants, Independent Phase
            852310 - Mid/Side, Independent Phase
            852311 - Preserve Formants, Mid/Side, Independent Phase
            852312 - Time Domain Smoothing
            852313 - Preserve Formants, Time Domain Smoothing
            852314 - Mid/Side, Time Domain Smoothing
            852315 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852316 - Independent Phase, Time Domain Smoothing
            852317 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852318 - Mid/Side, Independent Phase, Time Domain Smoothing
            852319 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent
            852320 - nothing
            852321 - Preserve Formants
            852322 - Mid/Side
            852323 - Preserve Formants, Mid/Side
            852324 - Independent Phase
            852325 - Preserve Formants, Independent Phase
            852326 - Mid/Side, Independent Phase
            852327 - Preserve Formants, Mid/Side, Independent Phase
            852328 - Time Domain Smoothing
            852329 - Preserve Formants, Time Domain Smoothing
            852330 - Mid/Side, Time Domain Smoothing
            852331 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852332 - Independent Phase, Time Domain Smoothing
            852333 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852334 - Mid/Side, Independent Phase, Time Domain Smoothing
            852335 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent
            852336 - nothing
            852337 - Preserve Formants
            852338 - Mid/Side
            852339 - Preserve Formants, Mid/Side
            852340 - Independent Phase
            852341 - Preserve Formants, Independent Phase
            852342 - Mid/Side, Independent Phase
            852343 - Preserve Formants, Mid/Side, Independent Phase
            852344 - Time Domain Smoothing
            852345 - Preserve Formants, Time Domain Smoothing
            852346 - Mid/Side, Time Domain Smoothing
            852347 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852348 - Independent Phase, Time Domain Smoothing
            852349 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852350 - Mid/Side, Independent Phase, Time Domain Smoothing
            852351 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent
            852352 - nothing
            852353 - Preserve Formants
            852354 - Mid/Side
            852355 - Preserve Formants, Mid/Side
            852356 - Independent Phase
            852357 - Preserve Formants, Independent Phase
            852358 - Mid/Side, Independent Phase
            852359 - Preserve Formants, Mid/Side, Independent Phase
            852360 - Time Domain Smoothing
            852361 - Preserve Formants, Time Domain Smoothing
            852362 - Mid/Side, Time Domain Smoothing
            852363 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852364 - Independent Phase, Time Domain Smoothing
            852365 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852366 - Mid/Side, Independent Phase, Time Domain Smoothing
            852367 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent
            852368 - nothing
            852369 - Preserve Formants
            852370 - Mid/Side
            852371 - Preserve Formants, Mid/Side
            852372 - Independent Phase
            852373 - Preserve Formants, Independent Phase
            852374 - Mid/Side, Independent Phase
            852375 - Preserve Formants, Mid/Side, Independent Phase
            852376 - Time Domain Smoothing
            852377 - Preserve Formants, Time Domain Smoothing
            852378 - Mid/Side, Time Domain Smoothing
            852379 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852380 - Independent Phase, Time Domain Smoothing
            852381 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852382 - Mid/Side, Independent Phase, Time Domain Smoothing
            852383 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent
            852384 - nothing
            852385 - Preserve Formants
            852386 - Mid/Side
            852387 - Preserve Formants, Mid/Side
            852388 - Independent Phase
            852389 - Preserve Formants, Independent Phase
            852390 - Mid/Side, Independent Phase
            852391 - Preserve Formants, Mid/Side, Independent Phase
            852392 - Time Domain Smoothing
            852393 - Preserve Formants, Time Domain Smoothing
            852394 - Mid/Side, Time Domain Smoothing
            852395 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852396 - Independent Phase, Time Domain Smoothing
            852397 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852398 - Mid/Side, Independent Phase, Time Domain Smoothing
            852399 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Short
            852400 - nothing
            852401 - Preserve Formants
            852402 - Mid/Side
            852403 - Preserve Formants, Mid/Side
            852404 - Independent Phase
            852405 - Preserve Formants, Independent Phase
            852406 - Mid/Side, Independent Phase
            852407 - Preserve Formants, Mid/Side, Independent Phase
            852408 - Time Domain Smoothing
            852409 - Preserve Formants, Time Domain Smoothing
            852410 - Mid/Side, Time Domain Smoothing
            852411 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852412 - Independent Phase, Time Domain Smoothing
            852413 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852414 - Mid/Side, Independent Phase, Time Domain Smoothing
            852415 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Short
            852416 - nothing
            852417 - Preserve Formants
            852418 - Mid/Side
            852419 - Preserve Formants, Mid/Side
            852420 - Independent Phase
            852421 - Preserve Formants, Independent Phase
            852422 - Mid/Side, Independent Phase
            852423 - Preserve Formants, Mid/Side, Independent Phase
            852424 - Time Domain Smoothing
            852425 - Preserve Formants, Time Domain Smoothing
            852426 - Mid/Side, Time Domain Smoothing
            852427 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852428 - Independent Phase, Time Domain Smoothing
            852429 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852430 - Mid/Side, Independent Phase, Time Domain Smoothing
            852431 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Short
            852432 - nothing
            852433 - Preserve Formants
            852434 - Mid/Side
            852435 - Preserve Formants, Mid/Side
            852436 - Independent Phase
            852437 - Preserve Formants, Independent Phase
            852438 - Mid/Side, Independent Phase
            852439 - Preserve Formants, Mid/Side, Independent Phase
            852440 - Time Domain Smoothing
            852441 - Preserve Formants, Time Domain Smoothing
            852442 - Mid/Side, Time Domain Smoothing
            852443 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852444 - Independent Phase, Time Domain Smoothing
            852445 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852446 - Mid/Side, Independent Phase, Time Domain Smoothing
            852447 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Short
            852448 - nothing
            852449 - Preserve Formants
            852450 - Mid/Side
            852451 - Preserve Formants, Mid/Side
            852452 - Independent Phase
            852453 - Preserve Formants, Independent Phase
            852454 - Mid/Side, Independent Phase
            852455 - Preserve Formants, Mid/Side, Independent Phase
            852456 - Time Domain Smoothing
            852457 - Preserve Formants, Time Domain Smoothing
            852458 - Mid/Side, Time Domain Smoothing
            852459 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852460 - Independent Phase, Time Domain Smoothing
            852461 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852462 - Mid/Side, Independent Phase, Time Domain Smoothing
            852463 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Short
            852464 - nothing
            852465 - Preserve Formants
            852466 - Mid/Side
            852467 - Preserve Formants, Mid/Side
            852468 - Independent Phase
            852469 - Preserve Formants, Independent Phase
            852470 - Mid/Side, Independent Phase
            852471 - Preserve Formants, Mid/Side, Independent Phase
            852472 - Time Domain Smoothing
            852473 - Preserve Formants, Time Domain Smoothing
            852474 - Mid/Side, Time Domain Smoothing
            852475 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852476 - Independent Phase, Time Domain Smoothing
            852477 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852478 - Mid/Side, Independent Phase, Time Domain Smoothing
            852479 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Short
            852480 - nothing
            852481 - Preserve Formants
            852482 - Mid/Side
            852483 - Preserve Formants, Mid/Side
            852484 - Independent Phase
            852485 - Preserve Formants, Independent Phase
            852486 - Mid/Side, Independent Phase
            852487 - Preserve Formants, Mid/Side, Independent Phase
            852488 - Time Domain Smoothing
            852489 - Preserve Formants, Time Domain Smoothing
            852490 - Mid/Side, Time Domain Smoothing
            852491 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852492 - Independent Phase, Time Domain Smoothing
            852493 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852494 - Mid/Side, Independent Phase, Time Domain Smoothing
            852495 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Short
            852496 - nothing
            852497 - Preserve Formants
            852498 - Mid/Side
            852499 - Preserve Formants, Mid/Side
            852500 - Independent Phase
            852501 - Preserve Formants, Independent Phase
            852502 - Mid/Side, Independent Phase
            852503 - Preserve Formants, Mid/Side, Independent Phase
            852504 - Time Domain Smoothing
            852505 - Preserve Formants, Time Domain Smoothing
            852506 - Mid/Side, Time Domain Smoothing
            852507 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852508 - Independent Phase, Time Domain Smoothing
            852509 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852510 - Mid/Side, Independent Phase, Time Domain Smoothing
            852511 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Short
            852512 - nothing
            852513 - Preserve Formants
            852514 - Mid/Side
            852515 - Preserve Formants, Mid/Side
            852516 - Independent Phase
            852517 - Preserve Formants, Independent Phase
            852518 - Mid/Side, Independent Phase
            852519 - Preserve Formants, Mid/Side, Independent Phase
            852520 - Time Domain Smoothing
            852521 - Preserve Formants, Time Domain Smoothing
            852522 - Mid/Side, Time Domain Smoothing
            852523 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852524 - Independent Phase, Time Domain Smoothing
            852525 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852526 - Mid/Side, Independent Phase, Time Domain Smoothing
            852527 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Short
            852528 - nothing
            852529 - Preserve Formants
            852530 - Mid/Side
            852531 - Preserve Formants, Mid/Side
            852532 - Independent Phase
            852533 - Preserve Formants, Independent Phase
            852534 - Mid/Side, Independent Phase
            852535 - Preserve Formants, Mid/Side, Independent Phase
            852536 - Time Domain Smoothing
            852537 - Preserve Formants, Time Domain Smoothing
            852538 - Mid/Side, Time Domain Smoothing
            852539 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852540 - Independent Phase, Time Domain Smoothing
            852541 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852542 - Mid/Side, Independent Phase, Time Domain Smoothing
            852543 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Short
            852544 - nothing
            852545 - Preserve Formants
            852546 - Mid/Side
            852547 - Preserve Formants, Mid/Side
            852548 - Independent Phase
            852549 - Preserve Formants, Independent Phase
            852550 - Mid/Side, Independent Phase
            852551 - Preserve Formants, Mid/Side, Independent Phase
            852552 - Time Domain Smoothing
            852553 - Preserve Formants, Time Domain Smoothing
            852554 - Mid/Side, Time Domain Smoothing
            852555 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852556 - Independent Phase, Time Domain Smoothing
            852557 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852558 - Mid/Side, Independent Phase, Time Domain Smoothing
            852559 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Short
            852560 - nothing
            852561 - Preserve Formants
            852562 - Mid/Side
            852563 - Preserve Formants, Mid/Side
            852564 - Independent Phase
            852565 - Preserve Formants, Independent Phase
            852566 - Mid/Side, Independent Phase
            852567 - Preserve Formants, Mid/Side, Independent Phase
            852568 - Time Domain Smoothing
            852569 - Preserve Formants, Time Domain Smoothing
            852570 - Mid/Side, Time Domain Smoothing
            852571 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852572 - Independent Phase, Time Domain Smoothing
            852573 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852574 - Mid/Side, Independent Phase, Time Domain Smoothing
            852575 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Short
            852576 - nothing
            852577 - Preserve Formants
            852578 - Mid/Side
            852579 - Preserve Formants, Mid/Side
            852580 - Independent Phase
            852581 - Preserve Formants, Independent Phase
            852582 - Mid/Side, Independent Phase
            852583 - Preserve Formants, Mid/Side, Independent Phase
            852584 - Time Domain Smoothing
            852585 - Preserve Formants, Time Domain Smoothing
            852586 - Mid/Side, Time Domain Smoothing
            852587 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852588 - Independent Phase, Time Domain Smoothing
            852589 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852590 - Mid/Side, Independent Phase, Time Domain Smoothing
            852591 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852592 - nothing
            852593 - Preserve Formants
            852594 - Mid/Side
            852595 - Preserve Formants, Mid/Side
            852596 - Independent Phase
            852597 - Preserve Formants, Independent Phase
            852598 - Mid/Side, Independent Phase
            852599 - Preserve Formants, Mid/Side, Independent Phase
            852600 - Time Domain Smoothing
            852601 - Preserve Formants, Time Domain Smoothing
            852602 - Mid/Side, Time Domain Smoothing
            852603 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852604 - Independent Phase, Time Domain Smoothing
            852605 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852606 - Mid/Side, Independent Phase, Time Domain Smoothing
            852607 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852608 - nothing
            852609 - Preserve Formants
            852610 - Mid/Side
            852611 - Preserve Formants, Mid/Side
            852612 - Independent Phase
            852613 - Preserve Formants, Independent Phase
            852614 - Mid/Side, Independent Phase
            852615 - Preserve Formants, Mid/Side, Independent Phase
            852616 - Time Domain Smoothing
            852617 - Preserve Formants, Time Domain Smoothing
            852618 - Mid/Side, Time Domain Smoothing
            852619 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852620 - Independent Phase, Time Domain Smoothing
            852621 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852622 - Mid/Side, Independent Phase, Time Domain Smoothing
            852623 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852624 - nothing
            852625 - Preserve Formants
            852626 - Mid/Side
            852627 - Preserve Formants, Mid/Side
            852628 - Independent Phase
            852629 - Preserve Formants, Independent Phase
            852630 - Mid/Side, Independent Phase
            852631 - Preserve Formants, Mid/Side, Independent Phase
            852632 - Time Domain Smoothing
            852633 - Preserve Formants, Time Domain Smoothing
            852634 - Mid/Side, Time Domain Smoothing
            852635 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852636 - Independent Phase, Time Domain Smoothing
            852637 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852638 - Mid/Side, Independent Phase, Time Domain Smoothing
            852639 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Short
            852640 - nothing
            852641 - Preserve Formants
            852642 - Mid/Side
            852643 - Preserve Formants, Mid/Side
            852644 - Independent Phase
            852645 - Preserve Formants, Independent Phase
            852646 - Mid/Side, Independent Phase
            852647 - Preserve Formants, Mid/Side, Independent Phase
            852648 - Time Domain Smoothing
            852649 - Preserve Formants, Time Domain Smoothing
            852650 - Mid/Side, Time Domain Smoothing
            852651 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852652 - Independent Phase, Time Domain Smoothing
            852653 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852654 - Mid/Side, Independent Phase, Time Domain Smoothing
            852655 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852656 - nothing
            852657 - Preserve Formants
            852658 - Mid/Side
            852659 - Preserve Formants, Mid/Side
            852660 - Independent Phase
            852661 - Preserve Formants, Independent Phase
            852662 - Mid/Side, Independent Phase
            852663 - Preserve Formants, Mid/Side, Independent Phase
            852664 - Time Domain Smoothing
            852665 - Preserve Formants, Time Domain Smoothing
            852666 - Mid/Side, Time Domain Smoothing
            852667 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852668 - Independent Phase, Time Domain Smoothing
            852669 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852670 - Mid/Side, Independent Phase, Time Domain Smoothing
            852671 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852672 - nothing
            852673 - Preserve Formants
            852674 - Mid/Side
            852675 - Preserve Formants, Mid/Side
            852676 - Independent Phase
            852677 - Preserve Formants, Independent Phase
            852678 - Mid/Side, Independent Phase
            852679 - Preserve Formants, Mid/Side, Independent Phase
            852680 - Time Domain Smoothing
            852681 - Preserve Formants, Time Domain Smoothing
            852682 - Mid/Side, Time Domain Smoothing
            852683 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852684 - Independent Phase, Time Domain Smoothing
            852685 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852686 - Mid/Side, Independent Phase, Time Domain Smoothing
            852687 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Short
            852688 - nothing
            852689 - Preserve Formants
            852690 - Mid/Side
            852691 - Preserve Formants, Mid/Side
            852692 - Independent Phase
            852693 - Preserve Formants, Independent Phase
            852694 - Mid/Side, Independent Phase
            852695 - Preserve Formants, Mid/Side, Independent Phase
            852696 - Time Domain Smoothing
            852697 - Preserve Formants, Time Domain Smoothing
            852698 - Mid/Side, Time Domain Smoothing
            852699 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852700 - Independent Phase, Time Domain Smoothing
            852701 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852702 - Mid/Side, Independent Phase, Time Domain Smoothing
            852703 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Short
            852704 - nothing
            852705 - Preserve Formants
            852706 - Mid/Side
            852707 - Preserve Formants, Mid/Side
            852708 - Independent Phase
            852709 - Preserve Formants, Independent Phase
            852710 - Mid/Side, Independent Phase
            852711 - Preserve Formants, Mid/Side, Independent Phase
            852712 - Time Domain Smoothing
            852713 - Preserve Formants, Time Domain Smoothing
            852714 - Mid/Side, Time Domain Smoothing
            852715 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852716 - Independent Phase, Time Domain Smoothing
            852717 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852718 - Mid/Side, Independent Phase, Time Domain Smoothing
            852719 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Short
            852720 - nothing
            852721 - Preserve Formants
            852722 - Mid/Side
            852723 - Preserve Formants, Mid/Side
            852724 - Independent Phase
            852725 - Preserve Formants, Independent Phase
            852726 - Mid/Side, Independent Phase
            852727 - Preserve Formants, Mid/Side, Independent Phase
            852728 - Time Domain Smoothing
            852729 - Preserve Formants, Time Domain Smoothing
            852730 - Mid/Side, Time Domain Smoothing
            852731 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852732 - Independent Phase, Time Domain Smoothing
            852733 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852734 - Mid/Side, Independent Phase, Time Domain Smoothing
            852735 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852736 - nothing
            852737 - Preserve Formants
            852738 - Mid/Side
            852739 - Preserve Formants, Mid/Side
            852740 - Independent Phase
            852741 - Preserve Formants, Independent Phase
            852742 - Mid/Side, Independent Phase
            852743 - Preserve Formants, Mid/Side, Independent Phase
            852744 - Time Domain Smoothing
            852745 - Preserve Formants, Time Domain Smoothing
            852746 - Mid/Side, Time Domain Smoothing
            852747 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852748 - Independent Phase, Time Domain Smoothing
            852749 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852750 - Mid/Side, Independent Phase, Time Domain Smoothing
            852751 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852752 - nothing
            852753 - Preserve Formants
            852754 - Mid/Side
            852755 - Preserve Formants, Mid/Side
            852756 - Independent Phase
            852757 - Preserve Formants, Independent Phase
            852758 - Mid/Side, Independent Phase
            852759 - Preserve Formants, Mid/Side, Independent Phase
            852760 - Time Domain Smoothing
            852761 - Preserve Formants, Time Domain Smoothing
            852762 - Mid/Side, Time Domain Smoothing
            852763 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852764 - Independent Phase, Time Domain Smoothing
            852765 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852766 - Mid/Side, Independent Phase, Time Domain Smoothing
            852767 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852768 - nothing
            852769 - Preserve Formants
            852770 - Mid/Side
            852771 - Preserve Formants, Mid/Side
            852772 - Independent Phase
            852773 - Preserve Formants, Independent Phase
            852774 - Mid/Side, Independent Phase
            852775 - Preserve Formants, Mid/Side, Independent Phase
            852776 - Time Domain Smoothing
            852777 - Preserve Formants, Time Domain Smoothing
            852778 - Mid/Side, Time Domain Smoothing
            852779 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852780 - Independent Phase, Time Domain Smoothing
            852781 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852782 - Mid/Side, Independent Phase, Time Domain Smoothing
            852783 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Short
            852784 - nothing
            852785 - Preserve Formants
            852786 - Mid/Side
            852787 - Preserve Formants, Mid/Side
            852788 - Independent Phase
            852789 - Preserve Formants, Independent Phase
            852790 - Mid/Side, Independent Phase
            852791 - Preserve Formants, Mid/Side, Independent Phase
            852792 - Time Domain Smoothing
            852793 - Preserve Formants, Time Domain Smoothing
            852794 - Mid/Side, Time Domain Smoothing
            852795 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852796 - Independent Phase, Time Domain Smoothing
            852797 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852798 - Mid/Side, Independent Phase, Time Domain Smoothing
            852799 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852800 - nothing
            852801 - Preserve Formants
            852802 - Mid/Side
            852803 - Preserve Formants, Mid/Side
            852804 - Independent Phase
            852805 - Preserve Formants, Independent Phase
            852806 - Mid/Side, Independent Phase
            852807 - Preserve Formants, Mid/Side, Independent Phase
            852808 - Time Domain Smoothing
            852809 - Preserve Formants, Time Domain Smoothing
            852810 - Mid/Side, Time Domain Smoothing
            852811 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852812 - Independent Phase, Time Domain Smoothing
            852813 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852814 - Mid/Side, Independent Phase, Time Domain Smoothing
            852815 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852816 - nothing
            852817 - Preserve Formants
            852818 - Mid/Side
            852819 - Preserve Formants, Mid/Side
            852820 - Independent Phase
            852821 - Preserve Formants, Independent Phase
            852822 - Mid/Side, Independent Phase
            852823 - Preserve Formants, Mid/Side, Independent Phase
            852824 - Time Domain Smoothing
            852825 - Preserve Formants, Time Domain Smoothing
            852826 - Mid/Side, Time Domain Smoothing
            852827 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852828 - Independent Phase, Time Domain Smoothing
            852829 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852830 - Mid/Side, Independent Phase, Time Domain Smoothing
            852831 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Long
            852832 - nothing
            852833 - Preserve Formants
            852834 - Mid/Side
            852835 - Preserve Formants, Mid/Side
            852836 - Independent Phase
            852837 - Preserve Formants, Independent Phase
            852838 - Mid/Side, Independent Phase
            852839 - Preserve Formants, Mid/Side, Independent Phase
            852840 - Time Domain Smoothing
            852841 - Preserve Formants, Time Domain Smoothing
            852842 - Mid/Side, Time Domain Smoothing
            852843 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852844 - Independent Phase, Time Domain Smoothing
            852845 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852846 - Mid/Side, Independent Phase, Time Domain Smoothing
            852847 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Long
            852848 - nothing
            852849 - Preserve Formants
            852850 - Mid/Side
            852851 - Preserve Formants, Mid/Side
            852852 - Independent Phase
            852853 - Preserve Formants, Independent Phase
            852854 - Mid/Side, Independent Phase
            852855 - Preserve Formants, Mid/Side, Independent Phase
            852856 - Time Domain Smoothing
            852857 - Preserve Formants, Time Domain Smoothing
            852858 - Mid/Side, Time Domain Smoothing
            852859 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852860 - Independent Phase, Time Domain Smoothing
            852861 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852862 - Mid/Side, Independent Phase, Time Domain Smoothing
            852863 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Long
            852864 - nothing
            852865 - Preserve Formants
            852866 - Mid/Side
            852867 - Preserve Formants, Mid/Side
            852868 - Independent Phase
            852869 - Preserve Formants, Independent Phase
            852870 - Mid/Side, Independent Phase
            852871 - Preserve Formants, Mid/Side, Independent Phase
            852872 - Time Domain Smoothing
            852873 - Preserve Formants, Time Domain Smoothing
            852874 - Mid/Side, Time Domain Smoothing
            852875 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852876 - Independent Phase, Time Domain Smoothing
            852877 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852878 - Mid/Side, Independent Phase, Time Domain Smoothing
            852879 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Long
            852880 - nothing
            852881 - Preserve Formants
            852882 - Mid/Side
            852883 - Preserve Formants, Mid/Side
            852884 - Independent Phase
            852885 - Preserve Formants, Independent Phase
            852886 - Mid/Side, Independent Phase
            852887 - Preserve Formants, Mid/Side, Independent Phase
            852888 - Time Domain Smoothing
            852889 - Preserve Formants, Time Domain Smoothing
            852890 - Mid/Side, Time Domain Smoothing
            852891 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852892 - Independent Phase, Time Domain Smoothing
            852893 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852894 - Mid/Side, Independent Phase, Time Domain Smoothing
            852895 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Long
            852896 - nothing
            852897 - Preserve Formants
            852898 - Mid/Side
            852899 - Preserve Formants, Mid/Side
            852900 - Independent Phase
            852901 - Preserve Formants, Independent Phase
            852902 - Mid/Side, Independent Phase
            852903 - Preserve Formants, Mid/Side, Independent Phase
            852904 - Time Domain Smoothing
            852905 - Preserve Formants, Time Domain Smoothing
            852906 - Mid/Side, Time Domain Smoothing
            852907 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852908 - Independent Phase, Time Domain Smoothing
            852909 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852910 - Mid/Side, Independent Phase, Time Domain Smoothing
            852911 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Long
            852912 - nothing
            852913 - Preserve Formants
            852914 - Mid/Side
            852915 - Preserve Formants, Mid/Side
            852916 - Independent Phase
            852917 - Preserve Formants, Independent Phase
            852918 - Mid/Side, Independent Phase
            852919 - Preserve Formants, Mid/Side, Independent Phase
            852920 - Time Domain Smoothing
            852921 - Preserve Formants, Time Domain Smoothing
            852922 - Mid/Side, Time Domain Smoothing
            852923 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852924 - Independent Phase, Time Domain Smoothing
            852925 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852926 - Mid/Side, Independent Phase, Time Domain Smoothing
            852927 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Long
            852928 - nothing
            852929 - Preserve Formants
            852930 - Mid/Side
            852931 - Preserve Formants, Mid/Side
            852932 - Independent Phase
            852933 - Preserve Formants, Independent Phase
            852934 - Mid/Side, Independent Phase
            852935 - Preserve Formants, Mid/Side, Independent Phase
            852936 - Time Domain Smoothing
            852937 - Preserve Formants, Time Domain Smoothing
            852938 - Mid/Side, Time Domain Smoothing
            852939 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852940 - Independent Phase, Time Domain Smoothing
            852941 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852942 - Mid/Side, Independent Phase, Time Domain Smoothing
            852943 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Long
            852944 - nothing
            852945 - Preserve Formants
            852946 - Mid/Side
            852947 - Preserve Formants, Mid/Side
            852948 - Independent Phase
            852949 - Preserve Formants, Independent Phase
            852950 - Mid/Side, Independent Phase
            852951 - Preserve Formants, Mid/Side, Independent Phase
            852952 - Time Domain Smoothing
            852953 - Preserve Formants, Time Domain Smoothing
            852954 - Mid/Side, Time Domain Smoothing
            852955 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852956 - Independent Phase, Time Domain Smoothing
            852957 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852958 - Mid/Side, Independent Phase, Time Domain Smoothing
            852959 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Long
            852960 - nothing
            852961 - Preserve Formants
            852962 - Mid/Side
            852963 - Preserve Formants, Mid/Side
            852964 - Independent Phase
            852965 - Preserve Formants, Independent Phase
            852966 - Mid/Side, Independent Phase
            852967 - Preserve Formants, Mid/Side, Independent Phase
            852968 - Time Domain Smoothing
            852969 - Preserve Formants, Time Domain Smoothing
            852970 - Mid/Side, Time Domain Smoothing
            852971 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852972 - Independent Phase, Time Domain Smoothing
            852973 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852974 - Mid/Side, Independent Phase, Time Domain Smoothing
            852975 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Long
            852976 - nothing
            852977 - Preserve Formants
            852978 - Mid/Side
            852979 - Preserve Formants, Mid/Side
            852980 - Independent Phase
            852981 - Preserve Formants, Independent Phase
            852982 - Mid/Side, Independent Phase
            852983 - Preserve Formants, Mid/Side, Independent Phase
            852984 - Time Domain Smoothing
            852985 - Preserve Formants, Time Domain Smoothing
            852986 - Mid/Side, Time Domain Smoothing
            852987 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852988 - Independent Phase, Time Domain Smoothing
            852989 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852990 - Mid/Side, Independent Phase, Time Domain Smoothing
            852991 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Long
            852992 - nothing
            852993 - Preserve Formants
            852994 - Mid/Side
            852995 - Preserve Formants, Mid/Side
            852996 - Independent Phase
            852997 - Preserve Formants, Independent Phase
            852998 - Mid/Side, Independent Phase
            852999 - Preserve Formants, Mid/Side, Independent Phase
            853000 - Time Domain Smoothing
            853001 - Preserve Formants, Time Domain Smoothing
            853002 - Mid/Side, Time Domain Smoothing
            853003 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853004 - Independent Phase, Time Domain Smoothing
            853005 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853006 - Mid/Side, Independent Phase, Time Domain Smoothing
            853007 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Long
            853008 - nothing
            853009 - Preserve Formants
            853010 - Mid/Side
            853011 - Preserve Formants, Mid/Side
            853012 - Independent Phase
            853013 - Preserve Formants, Independent Phase
            853014 - Mid/Side, Independent Phase
            853015 - Preserve Formants, Mid/Side, Independent Phase
            853016 - Time Domain Smoothing
            853017 - Preserve Formants, Time Domain Smoothing
            853018 - Mid/Side, Time Domain Smoothing
            853019 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853020 - Independent Phase, Time Domain Smoothing
            853021 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853022 - Mid/Side, Independent Phase, Time Domain Smoothing
            853023 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853024 - nothing
            853025 - Preserve Formants
            853026 - Mid/Side
            853027 - Preserve Formants, Mid/Side
            853028 - Independent Phase
            853029 - Preserve Formants, Independent Phase
            853030 - Mid/Side, Independent Phase
            853031 - Preserve Formants, Mid/Side, Independent Phase
            853032 - Time Domain Smoothing
            853033 - Preserve Formants, Time Domain Smoothing
            853034 - Mid/Side, Time Domain Smoothing
            853035 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853036 - Independent Phase, Time Domain Smoothing
            853037 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853038 - Mid/Side, Independent Phase, Time Domain Smoothing
            853039 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853040 - nothing
            853041 - Preserve Formants
            853042 - Mid/Side
            853043 - Preserve Formants, Mid/Side
            853044 - Independent Phase
            853045 - Preserve Formants, Independent Phase
            853046 - Mid/Side, Independent Phase
            853047 - Preserve Formants, Mid/Side, Independent Phase
            853048 - Time Domain Smoothing
            853049 - Preserve Formants, Time Domain Smoothing
            853050 - Mid/Side, Time Domain Smoothing
            853051 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853052 - Independent Phase, Time Domain Smoothing
            853053 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853054 - Mid/Side, Independent Phase, Time Domain Smoothing
            853055 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853056 - nothing
            853057 - Preserve Formants
            853058 - Mid/Side
            853059 - Preserve Formants, Mid/Side
            853060 - Independent Phase
            853061 - Preserve Formants, Independent Phase
            853062 - Mid/Side, Independent Phase
            853063 - Preserve Formants, Mid/Side, Independent Phase
            853064 - Time Domain Smoothing
            853065 - Preserve Formants, Time Domain Smoothing
            853066 - Mid/Side, Time Domain Smoothing
            853067 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853068 - Independent Phase, Time Domain Smoothing
            853069 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853070 - Mid/Side, Independent Phase, Time Domain Smoothing
            853071 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Long
            853072 - nothing
            853073 - Preserve Formants
            853074 - Mid/Side
            853075 - Preserve Formants, Mid/Side
            853076 - Independent Phase
            853077 - Preserve Formants, Independent Phase
            853078 - Mid/Side, Independent Phase
            853079 - Preserve Formants, Mid/Side, Independent Phase
            853080 - Time Domain Smoothing
            853081 - Preserve Formants, Time Domain Smoothing
            853082 - Mid/Side, Time Domain Smoothing
            853083 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853084 - Independent Phase, Time Domain Smoothing
            853085 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853086 - Mid/Side, Independent Phase, Time Domain Smoothing
            853087 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853088 - nothing
            853089 - Preserve Formants
            853090 - Mid/Side
            853091 - Preserve Formants, Mid/Side
            853092 - Independent Phase
            853093 - Preserve Formants, Independent Phase
            853094 - Mid/Side, Independent Phase
            853095 - Preserve Formants, Mid/Side, Independent Phase
            853096 - Time Domain Smoothing
            853097 - Preserve Formants, Time Domain Smoothing
            853098 - Mid/Side, Time Domain Smoothing
            853099 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853100 - Independent Phase, Time Domain Smoothing
            853101 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853102 - Mid/Side, Independent Phase, Time Domain Smoothing
            853103 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853104 - nothing
            853105 - Preserve Formants
            853106 - Mid/Side
            853107 - Preserve Formants, Mid/Side
            853108 - Independent Phase
            853109 - Preserve Formants, Independent Phase
            853110 - Mid/Side, Independent Phase
            853111 - Preserve Formants, Mid/Side, Independent Phase
            853112 - Time Domain Smoothing
            853113 - Preserve Formants, Time Domain Smoothing
            853114 - Mid/Side, Time Domain Smoothing
            853115 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853116 - Independent Phase, Time Domain Smoothing
            853117 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853118 - Mid/Side, Independent Phase, Time Domain Smoothing
            853119 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Long
            853120 - nothing
            853121 - Preserve Formants
            853122 - Mid/Side
            853123 - Preserve Formants, Mid/Side
            853124 - Independent Phase
            853125 - Preserve Formants, Independent Phase
            853126 - Mid/Side, Independent Phase
            853127 - Preserve Formants, Mid/Side, Independent Phase
            853128 - Time Domain Smoothing
            853129 - Preserve Formants, Time Domain Smoothing
            853130 - Mid/Side, Time Domain Smoothing
            853131 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853132 - Independent Phase, Time Domain Smoothing
            853133 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853134 - Mid/Side, Independent Phase, Time Domain Smoothing
            853135 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Long
            853136 - nothing
            853137 - Preserve Formants
            853138 - Mid/Side
            853139 - Preserve Formants, Mid/Side
            853140 - Independent Phase
            853141 - Preserve Formants, Independent Phase
            853142 - Mid/Side, Independent Phase
            853143 - Preserve Formants, Mid/Side, Independent Phase
            853144 - Time Domain Smoothing
            853145 - Preserve Formants, Time Domain Smoothing
            853146 - Mid/Side, Time Domain Smoothing
            853147 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853148 - Independent Phase, Time Domain Smoothing
            853149 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853150 - Mid/Side, Independent Phase, Time Domain Smoothing
            853151 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Long
            853152 - nothing
            853153 - Preserve Formants
            853154 - Mid/Side
            853155 - Preserve Formants, Mid/Side
            853156 - Independent Phase
            853157 - Preserve Formants, Independent Phase
            853158 - Mid/Side, Independent Phase
            853159 - Preserve Formants, Mid/Side, Independent Phase
            853160 - Time Domain Smoothing
            853161 - Preserve Formants, Time Domain Smoothing
            853162 - Mid/Side, Time Domain Smoothing
            853163 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853164 - Independent Phase, Time Domain Smoothing
            853165 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853166 - Mid/Side, Independent Phase, Time Domain Smoothing
            853167 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853168 - nothing
            853169 - Preserve Formants
            853170 - Mid/Side
            853171 - Preserve Formants, Mid/Side
            853172 - Independent Phase
            853173 - Preserve Formants, Independent Phase
            853174 - Mid/Side, Independent Phase
            853175 - Preserve Formants, Mid/Side, Independent Phase
            853176 - Time Domain Smoothing
            853177 - Preserve Formants, Time Domain Smoothing
            853178 - Mid/Side, Time Domain Smoothing
            853179 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853180 - Independent Phase, Time Domain Smoothing
            853181 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853182 - Mid/Side, Independent Phase, Time Domain Smoothing
            853183 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853184 - nothing
            853185 - Preserve Formants
            853186 - Mid/Side
            853187 - Preserve Formants, Mid/Side
            853188 - Independent Phase
            853189 - Preserve Formants, Independent Phase
            853190 - Mid/Side, Independent Phase
            853191 - Preserve Formants, Mid/Side, Independent Phase
            853192 - Time Domain Smoothing
            853193 - Preserve Formants, Time Domain Smoothing
            853194 - Mid/Side, Time Domain Smoothing
            853195 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853196 - Independent Phase, Time Domain Smoothing
            853197 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853198 - Mid/Side, Independent Phase, Time Domain Smoothing
            853199 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853200 - nothing
            853201 - Preserve Formants
            853202 - Mid/Side
            853203 - Preserve Formants, Mid/Side
            853204 - Independent Phase
            853205 - Preserve Formants, Independent Phase
            853206 - Mid/Side, Independent Phase
            853207 - Preserve Formants, Mid/Side, Independent Phase
            853208 - Time Domain Smoothing
            853209 - Preserve Formants, Time Domain Smoothing
            853210 - Mid/Side, Time Domain Smoothing
            853211 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853212 - Independent Phase, Time Domain Smoothing
            853213 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853214 - Mid/Side, Independent Phase, Time Domain Smoothing
            853215 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Long
            853216 - nothing
            853217 - Preserve Formants
            853218 - Mid/Side
            853219 - Preserve Formants, Mid/Side
            853220 - Independent Phase
            853221 - Preserve Formants, Independent Phase
            853222 - Mid/Side, Independent Phase
            853223 - Preserve Formants, Mid/Side, Independent Phase
            853224 - Time Domain Smoothing
            853225 - Preserve Formants, Time Domain Smoothing
            853226 - Mid/Side, Time Domain Smoothing
            853227 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853228 - Independent Phase, Time Domain Smoothing
            853229 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853230 - Mid/Side, Independent Phase, Time Domain Smoothing
            853231 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853232 - nothing
            853233 - Preserve Formants
            853234 - Mid/Side
            853235 - Preserve Formants, Mid/Side
            853236 - Independent Phase
            853237 - Preserve Formants, Independent Phase
            853238 - Mid/Side, Independent Phase
            853239 - Preserve Formants, Mid/Side, Independent Phase
            853240 - Time Domain Smoothing
            853241 - Preserve Formants, Time Domain Smoothing
            853242 - Mid/Side, Time Domain Smoothing
            853243 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853244 - Independent Phase, Time Domain Smoothing
            853245 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853246 - Mid/Side, Independent Phase, Time Domain Smoothing
            853247 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853248 - nothing
            853249 - Preserve Formants
            853250 - Mid/Side
            853251 - Preserve Formants, Mid/Side
            853252 - Independent Phase
            853253 - Preserve Formants, Independent Phase
            853254 - Mid/Side, Independent Phase
            853255 - Preserve Formants, Mid/Side, Independent Phase
            853256 - Time Domain Smoothing
            853257 - Preserve Formants, Time Domain Smoothing
            853258 - Mid/Side, Time Domain Smoothing
            853259 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853260 - Independent Phase, Time Domain Smoothing
            853261 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853262 - Mid/Side, Independent Phase, Time Domain Smoothing
            853263 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose playback-rate-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number playbackrate - 1 is 1x, 2 is 2x, 1.8 is 1.8x,etc
    integer preserve_pitch - preserve pitch; 1, preserve; 0, don't preserve
    number pitch_adjust - pitch_adjust(semitones); negative values allowed; 1.1=1.1 semitones higher, -0.3=0.3 semitones lower,etc
    integer takepitch_timestretch_mode - the item's pitchmode - 65536 for project-default
    integer optimize_tonal_content - 2, checkbox for optimize-tonal-content is set on; 0, checkbox for optimize-tonal-content is set off
    number stretch_marker_fadesize - in milliseconds; negative values are allowed
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, playrate, pitch</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemPlayRate","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemPlayRate","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("PLAYRATE( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A1,A2,A3,A4,A5,A6=ultraschall.GetItemPlayRate(reaper.GetMediaItem(0,0))

function ultraschall.GetItemChanMode(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemChanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer channelmode = ultraschall.GetItemChanMode(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the channelmode-entry of a MediaItem or MediaItemStateChunk.
    
    It's the CHANMODE-entry
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose channelmode-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer channelmode - channelmode of the MediaItem
                        - 0 - normal
                        - 1 - reverse stereo
                        - 2 - Mono (Mix L+R)
                        - 3 - Mono Left
                        - 4 - Mono Right
                        - 5 - Mono 3
                        - ...
                        - 66 - Mono 64
                        - 67 - Stereo 1/2
                        - ...
                        - 129 - Stereo 63/64
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, channel, mode</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemChanMode","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemChanMode","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("CHANMODE( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,2,3",false)
--A1,A2,A3,A4,A5=ultraschall.GetItemChanMode(reaper.GetMediaItem(0,0))

function ultraschall.GetItemGUID(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemGUID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string GUID = ultraschall.GetItemGUID(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the GUID-entry of a MediaItem or MediaItemStateChunk.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose GUID-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string GUID - the GUID of the item
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, guid</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemGUID","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemGUID","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  return statechunk:match("%cGUID (.-)%c")
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,3",false)
--AL,AL2,AL3,AL4,AL5,AL6=ultraschall.GetItemGUID(reaper.GetMediaItem(0,0))

function ultraschall.GetItemRecPass(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemRecPass</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer recpass_state = ultraschall.GetItemRecPass(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the recpass-entry of a MediaItem or MediaItemStateChunk.
    It's the counter of the recorded item-takes within a project, ordered by the order of recording. Only displayed with recorded item-takes, not imported ones.
    
    It's the RECPASS-entry.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose recpass-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer recpass_state - the number of recorded mediaitem; every recorded item gets it's counting-number.
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, recpass</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemRecPass","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemRecPass","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("RECPASS( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A=ultraschall.GetItemRecPass(reaper.GetMediaItem(0,0))

function ultraschall.GetItemBeat(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemBeat</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer beatstate = ultraschall.GetItemBeat(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the beatstate/timebase-entry of a MediaItem or MediaItemStateChunk.
    
    It's the BEAT-entry.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose beatstate/timebase-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer beatstate - the item-timebase state
    - nil - Track/project default timebase
    - 0 - Time
    - 1 - Beats (posiiton, length, rate)
    - 2 - Beats (position only)
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, beat, timebase</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemBeat","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemBeat","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return -1
  end
  -- get value and return it
  statechunk=statechunk:match("BEAT( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--C,CC,CCC=ultraschall.GetAllMediaItemsBetween(1,60,"1,3",false)
--AL,AL2,AL3,AL4,AL5,AL6=ultraschall.GetItemBeat(reaper.GetMediaItem(0,0))

function ultraschall.GetItemMixFlag(MediaItem, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemMixFlag</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer itemmix_state = ultraschall.GetItemMixFlag(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns the item-mix-behavior-entry of a MediaItemStateChunk.
    
    It's the MIXFLAG-entry.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose item-mix-behavior-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer itemmix_state - the item-mix-behavior
    - nil - Project Default item mix behavior
    - 0 - Enclosed items replace enclosing items
    - 1 - Items always mix
    - 2 - Items always replace earlier items
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, itemmix behavior</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemMixFlag","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemMixFlag","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return -1
  end
  -- get value and return it
  statechunk=statechunk:match("MIXFLAG( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "
  local O=statechunk
    
  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- (.-) ")),
         tonumber(statechunk:match(" .- .- .- .- .- .- .- (.-) "))
end

--A=ultraschall.GetItemMixFlag(reaper.GetMediaItem(0,0))

function ultraschall.GetItemUSTrackNumber_StateChunk(statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemUSTrackNumber_StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer tracknumber, MediaTrack track = ultraschall.GetItemUSTrackNumber_StateChunk(string MediaItemStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the tracknumber as well as the mediatrack-object from where the mediaitem was from, as given by a MediaItemStateChunk.
    This works only, if the StateChunk contains the entry "ULTRASCHALL_TRACKNUMBER", which holds the original tracknumber of the MediaItem.

    This entry will only be added by functions from the Ultraschall-API, like [GetAllMediaItemsBetween](#GetAllMediaItemsBetween)  
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    integer tracknumber - the tracknumber, where this item came from; starts with 1 for the first track!
    MediaTrack track - the accompanying track as MediaTrack-object
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, tracks, media, item, statechunk, rppxml, state, chunk, track, tracknumber</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemUSTrackNumber_StateChunk","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return -1 end
  -- get value and return it
  tracknumber=statechunk:match("ULTRASCHALL_TRACKNUMBER (.-)%c")
  if tracknumber==nil then ultraschall.AddErrorMessage("GetItemUSTrackNumber_StateChunk","MediaItemStateChunk", "no ULTRASCHALL_TRACKNUMBER-entry found in the statechunk.", -2) return -1 end
  
  return tonumber(statechunk:match("ULTRASCHALL_TRACKNUMBER (.-)%c")), reaper.GetTrack(0,tonumber(statechunk:match("ULTRASCHALL_TRACKNUMBER (.-)%c"))-1)
end


function ultraschall.SetItemUSTrackNumber_StateChunk(statechunk, tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemUSTrackNumber_StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemUSTrackNumber_StateChunk(string MediaItemStateChunk, integer tracknumber)</functioncall>
  <description>
    Adds/Replaces the entry "ULTRASCHALL_TRACKNUMBER" in a MediaItemStateChunk, that tells other Ultraschall-Apifunctions, from which track this item originated from.
    It returns the modified MediaItemStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer tracknumber - the tracknumber you want to set, with 1 for track 1, 2 for track 2
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, tracks, media, item, statechunk, rppxml, state, chunk, track, tracknumber</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemUSTrackNumber_StateChunk","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return -1 end
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("SetItemUSTrackNumber_StateChunk","tracknumber", "must be an integer.", -2) return -1 end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("SetItemUSTrackNumber_StateChunk","tracknumber", "no such track.", -3) return -1 end
  if statechunk:match("ULTRASCHALL_TRACKNUMBER") then 
    statechunk="<ITEM\n"..statechunk:match(".-ULTRASCHALL_TRACKNUMBER.-%c(.*)")
  end
  
  statechunk="<ITEM\nULTRASCHALL_TRACKNUMBER "..tracknumber.."\n"..statechunk:match("<ITEM(.*)")
  return statechunk
end

function ultraschall.SetItemPosition(MediaItem, position, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemPosition(MediaItem MediaItem, integer position, optional string MediaItemStateChunk)</functioncall>
  <description>
    Sets position in a MediaItem or MediaItemStateChunk in seconds.
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    integer position - position in seconds
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, position</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemPosition", "statechunk", "Must be a valid statechunk.", -1) return 
  end
  if type(position)~="number" then ultraschall.AddErrorMessage("SetItemPosition", "position", "Must be a number.", -2) return end  
  if position<0 then ultraschall.AddErrorMessage("SetItemPosition", "position", "Must bigger than or equal 0.", -3) return end
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)POSITION").."POSITION "..position.."\n"..statechunk:match("POSITION.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end


function ultraschall.SetItemLength(MediaItem, length, statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemLength(MediaItem MediaItem, integer length, string MediaItemStateChunk)</functioncall>
  <description>
    Sets length in a MediaItem and MediaItemStateChunk in seconds.
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    integer length - length in seconds
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, length</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemLength", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
--  reaper.MB(type(length),length,0)
  if type(length)~="number" then ultraschall.AddErrorMessage("SetItemLength", "length", "Must be a number.", -2) return nil end  
  if length<0 then ultraschall.AddErrorMessage("SetItemLength", "length", "Must bigger than or equal 0.", -3) return nil end
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)LENGTH").."LENGTH "..length.."\n"..statechunk:match("LENGTH.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end


function ultraschall.GetItemStateChunk(MediaItem, AddTracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string MediaItemStateChunk = ultraschall.GetItemStateChunk(MediaItem MediaItem, boolean AddTracknumber)</functioncall>
  <description>
    Returns the statechunk of MediaItem. Parameter AddTracknumber allows you to set, whether the tracknumber of the MediaItem shall be inserted to the statechunk as well, by the new entry "ULTRASCHALL_TRACKNUMBER".
    
    returns false in case of an error
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose statechunk you want to have
    boolean AddTracknumber - nil or true; add the tracknumber, where the MediaItem lies, as additional entry entry "ULTRASCHALL_TRACKNUMBER" to the statechunk; false, just return the original statechunk.
  </parameters>
  <retvals>
    boolean retval - true, if getting the statechunk was successful; false, if not
    string MediaItemStateChunk - the statechunk of the MediaItem
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, statechunk, tracknumber</tags>
</US_DocBloc>
]]
  if ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetItemStateChunk","MediaItem", "must be a MediaItem", -1) return false end
  if AddTracknumber~=nil and ultraschall.type(AddTracknumber)~="boolean" then ultraschall.AddErrorMessage("GetItemStateChunk","AddTracknumber", "must be a boolean", -1) return false end
  _temp, statechunk=reaper.GetItemStateChunk(MediaItem, "", false)
  if AddTracknumber~=false then statechunk=ultraschall.SetItemUSTrackNumber_StateChunk(statechunk, math.floor(reaper.GetMediaItemInfo_Value(MediaItem, "P_TRACK"))+1) end
  return true, statechunk
end

function ultraschall.GetItem_Video_IgnoreAudio(Item, take_index, StateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItem_Video_IgnoreAudio</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>boolean checked_state = ultraschall.GetItem_Video_IgnoreAudio(MediaItem Item, integer take_index, optional string StateChunk)</functioncall>
  <description>
    Gets the "Ignore audio"-checkbox of a video-item-source in a specific MediaItem-take.
    
    It's the AUDIO-entry in the <SOURCE-statechunk of the take
    
    Returns nil in case of an error(no video source in take)
  </description>
  <retvals>
    boolean checked_state - true, checkbox is checked; false, checkbox is unchecked
  </retvals>
  <parameters>
    MediaItem Item - the MediaItem, of whose video-sources in its takes, you want to get the ignore audio-checkbox state; nil, to use parameter StateChunk
    integer take_index - the take, of whose video-source you want to get the ignore audio-checkbox state; 0, for the active take; 1 and higher for take 1 and higher
    optional string StateChunk - if Item==nil, this must be a MediaItem-statechunk.
  </parameter>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitem management, item, take, get, ignore audio checkbox, state</tags>
</US_DocBloc>
]]
  if Item~=nil and ultraschall.type(Item)~="MediaItem" then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "Item", "must be a MediaItem", -1) return end
  if ultraschall.type(take_index)~="number: integer" then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "take_index", "must be an integer", -2) return end
  if take_index<0 then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "take_index", "must be 0(for active take) or 1 and higher for take 1 and higher", -3) return end
  if Item==nil and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "StateChunk", "must be a string", -4) return end
  
  local VideoSection, retval, restSC, index, Take
  if Item==nil then
    restSC=StateChunk
  else
    retval, restSC=reaper.GetItemStateChunk(A, "", false)
  end
  restSC=ultraschall.StateChunkLayouter(restSC)
  restSC=restSC:match("GUID.-\n(.*)")
  restSC="  TAKE\n"..string.gsub(restSC, "TAKE\n", "TAKE_END_3000\nTAKE\n").."  TAKE_END_3000\n"
  
  if take_index==0 then 
    Take=restSC:match("(TAKE SEL.-TAKE_END_3000)")
    if Take==nil then
      Take=restSC:match("(TAKE.-TAKE_END_3000)")
    end
    VideoSection=Take:match("\n  <SOURCE VIDEO.-\n  >")
    if VideoSection==nil then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "Item", "no video-source available in active take", -5) 
    else
      if VideoSection:match("    AUDIO %d")==nil then return false else return true end      
    end
  end
  restSC="  TAKE\n"..string.gsub(restSC, "TAKE SEL\n", "TAKE_END_3000\nTAKE\n").."  TAKE_END_3000\n"

  index=0
  for Take in string.gmatch(restSC, "(TAKE\n.-)TAKE_END_3000") do
    index=index+1
    if take_index==index then
      VideoSection=Take:match("\n  <SOURCE VIDEO.-\n  >")
      if VideoSection==nil then ultraschall.AddErrorMessage("GetItem_Video_IgnoreAudio", "Item", "no video-source available", -6) return 
      else 
        if VideoSection:match("    AUDIO %d")==nil then return false else return true end
      end 
    end
  end
end

--AAAA=reaper.GetMediaItem(0,0)
--retval, AAAA2=reaper.GetItemStateChunk(AAAA, "", false)

--A=ultraschall.GetItem_Video_IgnoreAudio(nil, 0, AAAA2)

function ultraschall.SetItem_Video_IgnoreAudio(Item, take_index, checkbox_state, StateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItem_Video_IgnoreAudio</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>string statechunk = ultraschall.SetItem_Video_IgnoreAudio(MediaItem Item, integer take_index, boolean checkbox_state, optional string StateChunk)</functioncall>
  <description>
    Sets the "Ignore audio"-checkbox of a video-item-source in a specific MediaItem-take.
    
    Returns nil in case of an error(no video source in take)
  </description>
  <retvals>
    string statechunk - the altered statechunk
  </retvals>
  <parameters>
    MediaItem Item - the MediaItem, of whose video-sources in its takes, you want to set the ignore audio-checkbox state; nil, to use parameter StateChunk
    integer take_index - the take, of whose video-source you want to set the ignore audio-checkbox state; 0, for the active take; 1 and higher for take 1 and higher
    boolean checkbox_state - true, checkbox is checked(ignores audio), false, checkbox is unchecked(audio is retained)
    optional string StateChunk - if Item==nil, this must be a MediaItem-statechunk.
  </parameter>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitem management, item, take, set, ignore audio checkbox, state</tags>
</US_DocBloc>
]]
  if Item~=nil and ultraschall.type(Item)~="MediaItem" then ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "Item", "must be a MediaItem", -1) return end
  if ultraschall.type(take_index)~="number: integer" then ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "take_index", "must be an integer", -2) return end
  if take_index<0 then ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "take_index", "must be 0(for selected take) or 1 and higher for take 1 and higher", -3) return end
  if Item==nil and ultraschall.IsValidMediaItemStateChunk(StateChunk)==false then ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "StateChunk", "must be a string", -4) return end
  if ultraschall.type(checkbox_state)~="boolean" then ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "checkbox_state", "must be a boolean", -5) return end  
  
  local retval, SC, NEWTAKES, take, SC3
  if Item==nil then
    SC=StateChunk
  else
    retval, SC=reaper.GetItemStateChunk(A, "", false)
  end
  SC=ultraschall.StateChunkLayouter(SC)
  
  if SC:match("TAKE SEL\n")==nil then
    take_index=1
  end

  NEWTAKES=""
  take=0
  for k in string.gmatch(SC, "TAKE.-\n  >") do
    take=take+1
    if (take_index~=0 and take==take_index) or
        (take_index==0 and k:match("TAKE SEL\n")~=nil) then
      if k:match("<SOURCE VIDEO")==nil then
        ultraschall.AddErrorMessage("SetItem_Video_IgnoreAudio", "Item", "no video-source available", -6) return 
      else
        if k:match("    AUDIO 0")~=nil and checkbox_state==false then
          k=string.gsub(k, "  AUDIO 0\n", "")
        elseif k:match("    AUDIO 0")==nil and checkbox_state==true then
          k=string.gsub(k, "<SOURCE VIDEO\n", "<SOURCE VIDEO\n    AUDIO 0\n")
        end
      end
    end
    NEWTAKES=NEWTAKES..k.."\n"
  end
  NEWTAKES=SC:match("(.-ALL)TAKE")..NEWTAKES
  SC3=""
  for k in string.gmatch(NEWTAKES, "(.-)\n") do
    SC3=SC3..k:match("%s*(.*)").."\n"
  end
  SC3=SC3.."\n"..SC:match(".*TAKE.-\n  >\n(.*)")
  if Item~=nil then
    reaper.SetItemStateChunk(Item, SC3, false)
  end
  return SC3
end


function ultraschall.GetItemImage(MediaItem, MediaItemStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemImage</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>string filename = ultraschall.GetItemImage(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns filename of an imagefile of an MediaItem or MediaItemStateChunk, as set in the item-notes-dialog.
    
    It is the entry RESOURCEFN
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose itemimage you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    string filename - the filename of the item-image; "", if not image is associated with this item
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, image, file</tags>
</US_DocBloc>
]]
  if MediaItem~=nil and ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("GetItemImage", "MediaItem", "must be a valid MediaItem or nil(when using MediaItemStateChunk instead)", -1) return nil end
  if MediaItem==nil and type(MediaItemStateChunk)~="string" then ultraschall.AddErrorMessage("GetItemImage", "MediaItemStateChunk", "Must be a string, when working with MediaItemStateChunks", -2) return nil end
  local retval, Filename, Resflags, count, individual_values, ResFlags
  if MediaItem~=nil then retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem, "", false) end

  Filename=MediaItemStateChunk:match("RESOURCEFN \"+(.-)\"+\n")
  if Filename==nil then Filename="" end
  return Filename
end


function ultraschall.SetItemImage(MediaItem, MediaItemStateChunk, imagefilename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemImage</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemImage(MediaItem MediaItem, optional string MediaItemStateChunk, string imagefilename)</functioncall>
  <description>
    Sets the filename of an imagefile of an MediaItem or MediaItemStateChunk, as set in the item-notes-dialog.
    
    It is the entry RESOURCEFN
    
    Note: This function will not check, if the filename exists.
    
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose itemimage you want to set; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk; set to nil, if not needed
    string filename - the filename of the item-image; "", if not image is associated with this item
  </parameters>
  <retvals>
    string MediaItemStateChunk - the altered MediaItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, set, image, file</tags>
</US_DocBloc>
]]
  if MediaItem~=nil and ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("SetItemImage", "MediaItem", "must be a valid MediaItem or nil(when using MediaItemStateChunk instead)", -1) return nil end
  if MediaItem==nil and type(MediaItemStateChunk)~="string" then ultraschall.AddErrorMessage("SetItemImage", "MediaItemStateChunk", "Must be a string, when working with MediaItemStateChunks", -2) return nil end
  if type(imagefilename)~="string" then ultraschall.AddErrorMessage("SetItemImage", "MediaItemStateChunk", "Must be a string, when working with MediaItemStateChunks", -2) return nil end

  
  local retval
  if MediaItem~=nil then retval, MediaItemStateChunk=reaper.GetItemStateChunk(MediaItem, "", false) end
  MediaItemStateChunk=ultraschall.StateChunkLayouter(MediaItemStateChunk)

  MediaItemStateChunk=string.gsub(MediaItemStateChunk, "\n  RESOURCEFN .-\n", "")
  local Insert="\n  RESOURCEFN \""..imagefilename.."\"\n"
  local offset, imgrflags=MediaItemStateChunk:match("()  (IMGRESOURCEFLAGS)")
  if imgrflags==nil then
    Insert=Insert.."  IMGRESOURCEFLAGS 0"
    offset=MediaItemStateChunk:len()-3
  else
    Insert=Insert.." "
  end
  MediaItemStateChunk=MediaItemStateChunk:sub(1,offset)..Insert..MediaItemStateChunk:sub(offset+1, -1)
  if MediaItem~=nil then 
    reaper.SetItemStateChunk(MediaItem, MediaItemStateChunk, false)
  end
  return MediaItemStateChunk
end

function ultraschall.SetItemAllTakes(MediaItem, statechunk, all_takes)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemAllTakes</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemAllTakes(MediaItem MediaItem, optional string MediaItemStateChunk, integer all_takes)</functioncall>
  <description>
    Sets position in a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer all_takes - play all takes-setting; 0, don't play all takes; 1, play all takes
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, play all takes</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemAllTakes", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(all_takes)~="integer" then ultraschall.AddErrorMessage("SetItemAllTakes", "all_takes", "Must be an integer.", -2) return nil end  
  if all_takes~=0 and all_takes~=1 then ultraschall.AddErrorMessage("SetItemAllTakes", "all_takes", "Must be either 0 or 1.", -3) return nil end
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)ALLTAKES").."ALLTAKES "..all_takes.."\n"..statechunk:match("ALLTAKES.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemChanMode(MediaItem, statechunk, chanmode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemChanMode</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemChanMode(MediaItem MediaItem, optional string MediaItemStateChunk, integer chanmode)</functioncall>
  <description>
    Sets channelmode in a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer chanmode - the channel-mode of the item; 0 and higher
                     - 0, normal
                     - 1, Mono (Mix L+R)
                     - 2, Mono (Left)
                     - 3, Mono (Right)
                     - 4, Mono 3
                     - ...
                     - 66, Mono 64
                     - 67, Stereo 1/2
                     - 67, Stereo 2/3
                     - ...
                     - 129, Stereo 63/64
                     - higher, (unknown)
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, chan mode</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemChanMode", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(chanmode)~="integer" then ultraschall.AddErrorMessage("SetItemChanMode", "chanmode", "Must be an integer.", -2) return nil end  
  if chanmode<0 then ultraschall.AddErrorMessage("SetItemChanMode", "chanmode", "Must be 0 and higher", -3) return nil end
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)CHANMODE").."CHANMODE "..chanmode.."\n"..statechunk:match("CHANMODE.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemLoop(MediaItem, statechunk, loop)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemLoop</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemLoop(MediaItem MediaItem, optional string MediaItemStateChunk, integer loop)</functioncall>
  <description>
    Sets loop-source-setting in a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer loop - the loopstate of the item/item-statechunk; 0, loop is off; 1, loop is on
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, loop</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemLoop", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(loop)~="integer" then ultraschall.AddErrorMessage("SetItemLoop", "loop", "Must be an integer.", -2) return nil end  
  if loop~=0 and loop~=1 then ultraschall.AddErrorMessage("SetItemLoop", "loop", "Must be 0 or 1", -3) return nil end
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)LOOP").."LOOP "..loop.."\n"..statechunk:match("LOOP.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemName(MediaItem, statechunk, name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemName</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemName(MediaItem MediaItem, optional string MediaItemStateChunk, string name)</functioncall>
  <description>
    Sets name of a MediaItem or MediaItemStateChunk.
    
    It is the name of the first take in the MediaItem!
    
    Note: No '-quotes in the name are allowed. This is due Reaper's complicated management of quotes in strings in statechunks.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of an error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    string name - the new name of the first take in the item
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, name, first take</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemName", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(name)~="string" then ultraschall.AddErrorMessage("SetItemName", "name", "Must be a string", -2) return nil end  
  if name:match("\"")~=nil then ultraschall.AddErrorMessage("SetItemName", "name", "No \" are allowed!", -3) return nil end  

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)NAME").."NAME \""..name.."\"\n"..statechunk:match("NAME.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemSelected(MediaItem, statechunk, selected)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemSelected</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemSelected(MediaItem MediaItem, optional string MediaItemStateChunk, integer selected)</functioncall>
  <description>
    Sets selection of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer selected - the selected state; 0, item is unselected; 1, item is selected
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, selected</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemSelected", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(selected)~="integer" then ultraschall.AddErrorMessage("SetItemSelected", "selected", "Must be an integer", -2) return nil end  
  if selected~=0 and selected~=1 then ultraschall.AddErrorMessage("SetItemSelected", "selected", "Must be 0 or 1", -3) return nil end

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)SEL").."SEL "..selected.."\n"..statechunk:match("SEL.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end


function ultraschall.SetItemGUID(MediaItem, statechunk, guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemGUID</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemGUID(MediaItem MediaItem, optional string MediaItemStateChunk, string guid)</functioncall>
  <description>
    Sets guid of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    string guid - the new guid of the item
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, guid</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemGUID", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(guid)~="string" then ultraschall.AddErrorMessage("SetItemGUID", "guid", "Must be a string", -2) return nil end  
  if ultraschall.IsValidGuid(guid, true)==false then ultraschall.AddErrorMessage("SetItemGUID", "guid", "Must be a valid guid", -3) return end

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)\nGUID").."\nGUID \""..guid.."\"\n"..statechunk:match("\nGUID.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemIGUID(MediaItem, statechunk, iguid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemGUID</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemIGUID(MediaItem MediaItem, optional string MediaItemStateChunk, string iguid)</functioncall>
  <description>
    Sets iguid of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    string iguid - the new iguid of the item
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, iguid</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemIGUID", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(iguid)~="string" then ultraschall.AddErrorMessage("SetItemIGUID", "iguid", "Must be a string", -2) return nil end  
  if ultraschall.IsValidGuid(iguid, true)==false then ultraschall.AddErrorMessage("SetItemIGUID", "iguid", "Must be a valid guid", -3) return end

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)\nIGUID").."\nIGUID \""..iguid.."\"\n"..statechunk:match("\nIGUID.-%c(.*)")
  
  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end



function ultraschall.SetItemIID(MediaItem, statechunk, iid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemIID</slug>
  <requires>
    Ultraschall=4.3
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemIID(MediaItem MediaItem, optional string MediaItemStateChunk, integer iid)</functioncall>
  <description>
    Sets itemid-number of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer iid - the new item-id; 1 and higher; function will not check, whether the iid is already in use!
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, iid</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemIID", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(iid)~="integer" then ultraschall.AddErrorMessage("SetItemIID", "iid", "Must be an integer", -2) return nil end  
  if iid<1 then ultraschall.AddErrorMessage("SetItemIID", "iid", "Must be 0 or higher", -3) return nil end

  
  -- do the magic
  local A1=statechunk:match("(<ITEM.-)IID")
  local B1
  if A1==nil then 
    A1=statechunk:match("(<ITEM.-)NAME") 
    B1=statechunk:match("(NAME.-%c.*)") 
  else 
    B1=statechunk:match("IID.-%c(.*)") 
  end

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, A1.."IID "..iid.."\n"..B1, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemMute(MediaItem, statechunk, mutestate1, mutestate2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemMute</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemMute(MediaItem MediaItem, optional string MediaItemStateChunk, integer mutestate1, integer mutestate2)</functioncall>
  <description>
    Sets mutestate of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    integer mutestate1 - actual mutestate, item solo overrides; 0, item is muted; 1, item is unmuted
    integer mutestate2 - mutestate, ignores solo; 0, item is muted; 1, item is unmuted
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, mute</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemMute", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if math.type(mutestate1)~="integer" then ultraschall.AddErrorMessage("SetItemMute", "mutestate1", "Must be an integer", -2) return nil end  
  if math.type(mutestate2)~="integer" then ultraschall.AddErrorMessage("SetItemMute", "mutestate2", "Must be an integer", -3) return nil end  
  if mutestate1<0 or mutestate1>1 then ultraschall.AddErrorMessage("SetItemMute", "mutestate1", "Must be either 0 or 1", -4) return nil end  
  if mutestate2<0 or mutestate2>1 then ultraschall.AddErrorMessage("SetItemMute", "mutestate2", "Must be either 0 or 1", -5) return nil end  
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)MUTE").."MUTE "..mutestate1.." "..mutestate2.."\n"..statechunk:match("MUTE.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemSampleOffset(MediaItem, statechunk, soffs1, soffs2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemSampleOffset</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemSampleOffset(MediaItem MediaItem, optional string MediaItemStateChunk, number soffs1, number soffs2)</functioncall>
  <description>
    Sets sample-offset of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    number soffs1 - the offset in seconds
    optional number soffs2 - unknown, probably something with QN(?); seems to be set by Reaper automatically, when committing to a MediaItem
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, sample offset</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemSampleOffset", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(soffs1)~="number" then ultraschall.AddErrorMessage("SetItemSampleOffset", "soffs1", "Must be a number", -2) return nil end  
  if soffs2~=nil and type(soffs2)~="number" then ultraschall.AddErrorMessage("SetItemSampleOffset", "soffs2", "Must be a number", -3) return nil end  
  if soffs2==nil then soffs2="" end

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)SOFFS").."SOFFS "..soffs1.." "..soffs2.."\n"..statechunk:match("SOFFS.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemVolPan(MediaItem, statechunk, volpan1, pan, volume, volpan4)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemVolPan</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemVolPan(MediaItem MediaItem, optional string MediaItemStateChunk, number volpan1, number pan, number volume, number volpan4)</functioncall>
  <description>
    Sets volume-pan-settings of a MediaItem or MediaItemStateChunk.
    
    Use ultraschall.DB2MKVOL() to convert dB to a value accepted by parameter volume.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    number volpan1 - unknown; 0, seems to mute the item without using mute; 1, seems to keep the item unmuted
    number pan - from -1(100%L) to 1(100%R), 0 is center
    number volume - from 0(-inf) to 3.981072(+12db), 1 is 0db; higher numbers are allowed; negative means phase inverted
    number volpan4 - unknown
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, volume, pan</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemVolPan", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(volpan1)~="number" then ultraschall.AddErrorMessage("SetItemVolPan", "volpan1", "Must be a number", -2) return nil end  
  if type(pan)~="number" then ultraschall.AddErrorMessage("SetItemVolPan", "pan", "Must be a number", -3) return nil end  
  if type(volume)~="number" then ultraschall.AddErrorMessage("SetItemVolPan", "volume", "Must be a number", -4) return nil end  
  if type(volpan4)~="number" then ultraschall.AddErrorMessage("SetItemVolPan", "volpan4", "Must be a number", -5) return nil end  
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)VOLPAN").."VOLPAN "..volpan1.." "..pan.." "..volume.." "..volpan4.."\n"..statechunk:match("VOLPAN.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end



function ultraschall.SetItemFadeIn(MediaItem, statechunk, curvetype1, fadein_length, fadein_length2, curvetype2, fadestate5, curve, fadestate7)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemFadeIn</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemFadeIn(MediaItem MediaItem, optional string MediaItemStateChunk, number curvetype1, number fadein_length, number fadein_length2, number curvetype2, integer fadestate5, number curve, number fadestate7)</functioncall>
  <description>
    Sets fade-in-settings of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    number curvetype1 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype2
    number fadein_length - the current fadein-length in seconds; minimum 0
    number fadein_length2 - the fadein-length in seconds; overrides fadein_length and will be moved to fadein_length when fadein-length changes(e.g. mouse-drag); might be autocrossfade-length; minimum 0
    number curvetype2 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype1
    integer fadestate5 - unknown, either 0 or 1; fadeinstate entry as set in the rppxml-mediaitem-statechunk
    number curve - curve -1 to 1
    number fadestate7 - unknown
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, fadein, curve</tags>
</US_DocBloc>
]]
  -- check parameters
  
  -- number curvetype1, number fadein_length, number fadein_length, number curvetype2, integer fadestate5, number curve
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemFadeIn", "statechunk", "Must be a valid statechunk.", -1) return nil
  end
  if type(curvetype1)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "curvetype1", "Must be a number", -2) return nil end  
  if type(fadein_length)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "fadein_length", "Must be a number", -3) return nil end  
  if type(fadein_length2)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "fadein_length2", "Must be a number", -4) return nil end  
  if type(curvetype2)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "curvetype2", "Must be a number", -5) return nil end  
  if math.type(fadestate5)~="integer" then ultraschall.AddErrorMessage("SetItemFadeIn", "fadestate5", "Must be an integer", -6) return nil end  
  if type(curve)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "curve", "Must be a number", -7) return nil end  
  if type(fadestate7)~="number" then ultraschall.AddErrorMessage("SetItemFadeIn", "fadestate7", "Must be a number", -8) return nil end  
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)FADEIN").."FADEIN "..curvetype1.." "..fadein_length.." "..fadein_length2.." "..curvetype2.." "..fadestate5.." "..curve.." "..fadestate7.."\n"..statechunk:match("FADEIN.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemFadeOut(MediaItem, statechunk, curvetype1, fadeout_length, fadeout_length2, curvetype2, fadestate5, curve, fadestate7)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemFadeOut</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemFadeOut(MediaItem MediaItem, optional string MediaItemStateChunk, number curvetype1, number fadeout_length, number fadeout_length2, number curvetype2, integer fadestate5, number curve, number fadestate7)</functioncall>
  <description>
    Sets fade-out-settings of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    number curvetype1 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype2
    number fadeout_length - the current fadeout-length in seconds; minimum 0
    number fadeout_length2 - the fadeout-length in seconds; overrides fadeout_length and will be moved to fadeout_length when fadeout-length changes(e.g. mouse-drag); might be autocrossfade-length; minimum 0
    number curvetype2 - the type of the curve: 0, 1, 2, 3, 4, 5, 5.1; must be set like curvetype1
    integer fadestate5 - unknown, either 0 or 1; fadeoutstate entry as set in the rppxml-mediaitem-statechunk
    number curve - curve -1 to 1
    number fadestate7 - unknown
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, fadeout, curve</tags>
</US_DocBloc>
]]
  -- check parameters
  
  -- number curvetype1, number fadein_length, number fadein_length, number curvetype2, integer fadestate5, number curve
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemFadeOut", "statechunk", "Must be a valid statechunk.", -1) return nil
  end

  if type(curvetype1)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "curvetype1", "Must be a number", -2) return nil end  
  if type(fadeout_length)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "fadeout_length", "Must be a number", -3) return nil end  
  if type(fadeout_length2)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "fadeout_length2", "Must be a number", -4) return nil end  
  if type(curvetype2)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "curvetype2", "Must be a number", -5) return nil end  
  if math.type(fadestate5)~="integer" then ultraschall.AddErrorMessage("SetItemFadeOut", "fadestate5", "Must be an integer", -6) return nil end  
  if type(curve)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "curve", "Must be a number", -7) return nil end  
  if type(fadestate7)~="number" then ultraschall.AddErrorMessage("SetItemFadeOut", "fadestate7", "Must be a number", -8) return nil end  
  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)FADEOUT").."FADEOUT "..curvetype1.." "..fadeout_length.." "..fadeout_length2.." "..curvetype2.." "..fadestate5.." "..curve.." "..fadestate7.."\n"..statechunk:match("FADEOUT.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end

function ultraschall.SetItemPlayRate(MediaItem, statechunk, playbackrate, preserve_pitch, pitch_adjust, takepitch_timestretch_mode, optimize_tonal_content, stretch_marker_fadesize)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemPlayRate</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string MediaItemStateChunk = ultraschall.SetItemPlayRate(MediaItem MediaItem, optional string MediaItemStateChunk, number playbackrate, integer preserve_pitch, number pitch_adjust, integer takepitch_timestretch_mode, integer optimize_tonal_content, number stretch_marker_fadesize)</functioncall>
  <description>
    Sets playrate-settings of a MediaItem or MediaItemStateChunk.
    
    It returns the modified MediaItemStateChunk.
    Returns nil in case of error.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose state you want to change; nil, use parameter MediaItemStateChunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
    number playbackrate - 1 is 1x, 2 is 2x, 1.8 is 1.8x,etc
    integer preserve_pitch - preserve pitch; 1, preserve; 0, don't preserve
    number pitch_adjust - pitch_adjust(semitones); negative values allowed; 1.1=1.1 semitones higher, -0.3=0.3 semitones lower,etc
    integer takepitch_timestretch_mode - the item's pitchmode - 65536 for project-default
    integer optimize_tonal_content - 2, checkbox for optimize-tonal-content is set on; 0, checkbox for optimize-tonal-content is set off
    number stretch_marker_fadesize - in milliseconds; negative values are allowed
  </parameters>
  <retvals>
    string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </retvals>
  <chapter_context>
    MediaItem Management
    Set MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, set, media, item, statechunk, rppxml, state, chunk, playrate, preserve pitch, pitch adjust, stretchmarker</tags>
</US_DocBloc>
]]
  -- check parameters
  local _tudelu
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then _tudelu, statechunk=reaper.GetItemStateChunk(MediaItem, "", false) 
  elseif ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("SetItemPlayRate", "statechunk", "Must be a valid statechunk.", -1) return nil
  end

  if type(playbackrate)~="number" then ultraschall.AddErrorMessage("SetItemPlayRate", "playbackrate", "Must be an integer", -2) return nil end  
  if math.type(preserve_pitch)~="integer" then ultraschall.AddErrorMessage("SetItemPlayRate", "preserve_pitch", "Must be an integer", -3) return nil end  
  if type(pitch_adjust)~="number" then ultraschall.AddErrorMessage("SetItemPlayRate", "pitch_adjust", "Must be a number", -4) return nil end  
  if math.type(takepitch_timestretch_mode)~="integer" then ultraschall.AddErrorMessage("SetItemPlayRate", "takepitch_timestretch_mode", "Must be an integer", -5) return nil end  
  if math.type(optimize_tonal_content)~="integer" then ultraschall.AddErrorMessage("SetItemPlayRate", "optimize_tonal_content", "Must be an integer", -6) return nil end  
  if type(stretch_marker_fadesize)~="number" then ultraschall.AddErrorMessage("SetItemPlayRate", "stretch_marker_fadesize", "Must be a number", -7) return nil end  

  
  -- do the magic
  statechunk=statechunk:match("(<ITEM.-)PLAYRATE").."PLAYRATE "..playbackrate.." "..preserve_pitch.." "..pitch_adjust.." "..takepitch_timestretch_mode.." "..optimize_tonal_content.." "..stretch_marker_fadesize.."\n"..statechunk:match("PLAYRATE.-%c(.*)")

  -- set statechunk, if MediaItem is provided, otherwise don't set it
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then reaper.SetItemStateChunk(MediaItem, statechunk, false) end
  
  -- return
  return statechunk
end


function ultraschall.GetItemYPos(MediaItem, statechunk)
--  reaper.MB(statechunk,"",0)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemYPos</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>number y_position, number y_height, integer lane_or_fipm = ultraschall.GetItemYPos(MediaItem MediaItem, optional string MediaItemStateChunk)</functioncall>
  <description>
    Returns position and height of the MediaItem in a fixed item lane/free item positioning.
    
    It's the YPOS-entry
    
    Note when in item-lanes: You can use the y_height-retval to calculate, how many item-lanes the track contains, that has this MediaItem.
    Use 1/y_height to calculate this the number of lanes. You can then calculate, on which lane the item lies: (1/y_height)*y_position.
    
    Returns nil in case of error or if the item is not placed in track lane/free item positioning.
  </description>
  <parameters>
    MediaItem MediaItem - the MediaItem, whose yposition-state you want to know; nil, use parameter MediaItemStatechunk instead
    optional string MediaItemStateChunk - an rpp-xml-statechunk, as created by reaper-api-functions like GetItemStateChunk
  </parameters>
  <retvals>
    number y_position - the y-position of the MediaItem in fipm/within all track-lanes, calculate the used item-lane(see description for details)
    number y_height - the height of the item in fipm/within the track-lanes, calculate the used item-lane(see description for details)
    integer lane_or_fipm - 1, item is in free item positioning; 2, item is in an item-lane
  </retvals>
  <chapter_context>
    MediaItem Management
    Get MediaItem States
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua</source_document>
  <tags>mediaitemmanagement, get, media, item, statechunk, rppxml, state, chunk, item lane, y-posiiton, height</tags>
</US_DocBloc>
]]
  -- check parameters and prepare statechunk-variable
  local retval
  if MediaItem~=nil then
    if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==true then retval, statechunk=reaper.GetItemStateChunk(MediaItem,"",false) 
    else ultraschall.AddErrorMessage("GetItemYPos","MediaItem", "must be a MediaItem.", -2) return end
  elseif MediaItem==nil and ultraschall.IsValidItemStateChunk(statechunk)==false then ultraschall.AddErrorMessage("GetItemYPos","MediaItemStateChunk", "must be a valid MediaItemStateChunk.", -1) return
  end
  -- get value and return it
  statechunk=statechunk:match("YPOS( .-)%c")
  if statechunk==nil then return nil end
  statechunk=statechunk.." "

  return tonumber(statechunk:match(" (.-) ")), 
         tonumber(statechunk:match(" .- (.-) ")),
         tonumber(statechunk:match(" .- .- (.-) "))
end

