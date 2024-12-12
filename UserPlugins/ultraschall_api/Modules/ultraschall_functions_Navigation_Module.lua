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
---       Navigation Module       ---
-------------------------------------

function ultraschall.ToggleScrollingDuringPlayback(scrolling_switch, move_editcursor, goto_playcursor)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleScrollingDuringPlayback</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.ToggleScrollingDuringPlayback(integer scrolling_switch, boolean move_editcursor, boolean goto_playcursor)</functioncall>
  <description>
    Toggles scrolling during playback and recording. Let's you choose to put the edit-marker at the playposition, where you toggled scrolling.
    You can also move the view to the playcursor-position.
    
    It changes, if necessary, the state of the actions 41817, 40036 and 40262 to scroll or not to scroll; keep that in mind, if you use these actions otherwise as well!
    
    returns -1 in case of error
  </description>
  <retvals>
    integer retval - -1, in case of an error
  </retvals>
  <parameters>
    integer scrolling_switch - 1, on; 0, off
    boolean move_editcursor - when scrolling stops, shall the editcursor be moved to current position of the playcursor(true) or not(false)
    boolean goto_playcursor - true, move view to playcursor; false, don't move
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, scrolling, toggle, edit cursor, play cursor</tags>
</US_DocBloc>
--]]
    if math.type(scrolling_switch)~="integer" then ultraschall.AddErrorMessage("ToggleScrollingDuringPlayback", "scrolling_switch", "must be an integer", -1) return -1 end
    if scrolling_switch<0 or scrolling_switch>1 then ultraschall.AddErrorMessage("ToggleScrollingDuringPlayback", "scrolling_switch", "0, turn scrolling off; 1, turn scrolling on", -2) return -1 end
    if type(move_editcursor)~="boolean" then ultraschall.AddErrorMessage("ToggleScrollingDuringPlayback", "move_editcursor", "must be a boolean", -3) return -1 end
    if type(goto_playcursor)~="boolean" then ultraschall.AddErrorMessage("ToggleScrollingDuringPlayback", "goto_playcursor", "must be a boolean", -4) return -1 end
    
    -- get current toggle-states
    local scroll_continuous=reaper.GetToggleCommandState(41817)
    local scroll_auto_play=reaper.GetToggleCommandState(40036)
    local scroll_auto_rec=reaper.GetToggleCommandState(40262)
  
    -- move editcursor, if move_editcursor is set to true
    if move_editcursor==true then
      reaper.SetEditCurPos(reaper.GetPlayPosition(), true, false)
    else
      reaper.SetEditCurPos(reaper.GetCursorPosition(), false, false)
    end
  
    -- set auto-scrolling-states
    if scrolling_switch~=scroll_continuous then
      reaper.Main_OnCommand(41817,0) -- continuous scroll
    end
  
    if scrolling_switch~=scroll_auto_play then
      reaper.Main_OnCommand(40036,0) -- autoscroll during play
    end
  
    if scrolling_switch~=scroll_auto_rec then
      reaper.Main_OnCommand(40262,0) -- autoscroll during rec
    end
  
    -- go to playcursor
    if goto_playcursor~=false then
      reaper.Main_OnCommand(40150,0) -- go to playcursor
    end  
  end

function ultraschall.SetPlayCursor_WhenPlaying(position)--, move_view)--, length_of_view)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPlayCursor_WhenPlaying</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.SetPlayCursor_WhenPlaying(number position)</functioncall>
  <description>
    Changes position of the play-cursor, when playing. Changes view to new playposition. 
    
    Has no effect during recording, when paused or stop and returns -1 in these cases!
  </description>
  <parameters>
    number position - in seconds
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, play cursor, set</tags>
</US_DocBloc>
--]]
  -- check parameters
  if reaper.GetPlayState()~=1 then ultraschall.AddErrorMessage("SetPlayCursor_WhenPlaying", "", "Works only, when it's playing.", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("SetPlayCursor_WhenPlaying", "position", "position must be a number", -2) return -1 end
  
  -- prepare variables
  if move_view==true then move_view=false
  elseif move_view==false then move_viev=true end

  -- set playcursor
  reaper.SetEditCurPos(position, true, true) 
  if reaper.GetPlayState()==2 then -- during pause
    reaper.Main_OnCommand(1007,0)
    reaper.SetEditCurPos(reaper.GetCursorPosition(), false, false)  
    reaper.Main_OnCommand(1008,0)
   else
     reaper.SetEditCurPos(reaper.GetCursorPosition(), false, false)  -- during play
   end
end

function ultraschall.SetPlayAndEditCursor_WhenPlaying(position)--, move_view)--, length_of_view)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPlayAndEditCursor_WhenPlaying</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.SetPlayAndEditCursor_WhenPlaying(number position)</functioncall>
  <description>
    Changes position of the play and edit-cursor, when playing. Changes view to new playposition. 
    
    Has no effect during recording, when paused or stop and returns -1 in these cases!
  </description>
  <parameters>
    number position - in seconds
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, set, play cursor, edit cursor</tags>
</US_DocBloc>
--]]
  -- check parameters
  if reaper.GetPlayState()==0 then ultraschall.AddErrorMessage("SetPlayAndEditCursor_WhenPlaying", "", "Works only, when it's not stopped.", -1) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("SetPlayAndEditCursor_WhenPlaying", "position", "position must be a number", -2) return -1 end

  -- prepare variables
  if move_view==true then move_view=false
  elseif move_view==false then move_viev=true end
  
  -- set play and edit-cursor
  reaper.SetEditCurPos(position, true, true)   
end

function ultraschall.JumpForwardBy(seconds, seekplay)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>JumpForwardBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.JumpForwardBy(number seconds, boolean seekplay)</functioncall>
  <description>
    Jumps editcursor forward by <i>seconds</i> seconds. 
    
    Returns -1 if parameter is negative. During Recording: only the playcursor will be moved, the current recording-position is still at it's "old" position! If you want to move the current recording position as well, use <a href="#JumpForwardBy_Recording">ultraschall.JumpForwardBy_Recording</a> instead.
  </description>
  <parameters>
    number seconds - jump forward by seconds
    boolean seekplay - true, move playcursor as well; false, don't move playcursor
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, set, forward, jump</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(seconds)~="number" then ultraschall.AddErrorMessage("JumpForwardBy","seconds", "must be a number", -1) return -1 end
  if type(seekplay)~="boolean" then ultraschall.AddErrorMessage("JumpForwardBy","seekplay", "must be boolean", -2) return -1 end

  if seconds<0 then ultraschall.AddErrorMessage("JumpForwardBy","seconds", "must be bigger or equal 0", -3) return -1 end
    
  -- jump forward edit-cursor
  if reaper.GetPlayState()==0 then -- during stop
    reaper.SetEditCurPos(reaper.GetCursorPosition()+seconds, true, true) 
  else -- every other play/rec-state
    reaper.SetEditCurPos(reaper.GetCursorPosition()+seconds, true, seekplay)
  end
end

function ultraschall.JumpBackwardBy(seconds, seekplay)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>JumpBackwardBy</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.JumpBackwardBy(number seconds, boolean seekplay)</functioncall>
  <description>
    Jumps editcursor backward by <i>seconds</i> seconds. 
    
    Returns -1 if parameter is negative. During Recording: only the playcursor will be moved, the current recording-position is still at it's "old" position! If you want to move the current recording position as well, use <a href="#JumpBackwardBy_Recording">ultraschall.JumpBackwardBy_Recording</a> instead.
  </description>
  <parameters>
    number seconds - jump backwards by seconds
    boolean seekplay - true, move playcursor as well; false, leave playcursor at it's old position
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, set, backward, jump</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(seconds)~="number" then ultraschall.AddErrorMessage("JumpBackwardBy","seconds", "must be a number", -1) return -1 end

  if type(seekplay)~="boolean" then ultraschall.AddErrorMessage("JumpBackwardBy","seekplay", "must be boolean", -2) return -1 end
  if seconds<0 then ultraschall.AddErrorMessage("JumpBackwardBy","seconds", "must be bigger or equal 0", -3) return -1 end
  
  -- jump backwards edit-cursor
  if reaper.GetPlayState()==0 then -- when stopped
    reaper.SetEditCurPos(reaper.GetCursorPosition()-seconds, true, true) 
  else -- every other play/rec-state
    reaper.SetEditCurPos(reaper.GetCursorPosition()-seconds, true, seekplay)
  end
end

function ultraschall.JumpForwardBy_Recording(seconds)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>JumpForwardBy_Recording</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.JumpForwardBy_Recording(number seconds)</functioncall>
  <description>
    Stops recording, jumps forward by <i>seconds</i> seconds and restarts recording. Will keep paused-recording, if recording was paused. Has no effect during play,play/pause and stop.
    
    returns -1 in case of an error
  </description>
  <parameters>
    number seconds - restart recording forwards by seconds
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, set, forward, recording</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(seconds)~="number" then ultraschall.AddErrorMessage("JumpForwardBy_Recording","seconds", "must be a number", -1) return -1 end

  if seconds<0 then ultraschall.AddErrorMessage("JumpForwardBy_Recording","seconds", "must be bigger or equal 0", -2) return -1 end
  
  -- stop recording, jump forward and restart recording
  if reaper.GetPlayState()==5 then -- during recording
    reaper.Main_OnCommand(1016,0)
    reaper.SetEditCurPos(reaper.GetPlayPosition()+seconds, true, true) 
    reaper.Main_OnCommand(1013,0)
  elseif reaper.GetPlayState()==6 then -- during paused-recording
    reaper.Main_OnCommand(1016,0)
    reaper.SetEditCurPos(reaper.GetPlayPosition()+seconds, true, true) 
    reaper.Main_OnCommand(1013,0)
    reaper.Main_OnCommand(1008,0)    
  else -- when recording hasn't started
    ultraschall.AddErrorMessage("JumpForwardBy_Recording", "", "Only while recording or pause recording possible.", -3)
    return -1
  end
end

function ultraschall.JumpBackwardBy_Recording(seconds)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>JumpBackwardBy_Recording</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.JumpBackwardBy_Recording(number seconds)</functioncall>
  <description>
    Stops recording, jumps backward by <i>seconds</i> seconds and restarts recording. Will keep paused-recording, if recording was paused. Has no effect during play,play/pause and stop.
    
    returns -1 in case of an error
  </description>
  <parameters>
    number seconds - restart recording backwards by seconds
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, jump, forward, recording</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(seconds)~="number" then ultraschall.AddErrorMessage("JumpBackwardBy_Recording","seconds", "must be a number", -1) return -1 end
  
  if seconds<0 then ultraschall.AddErrorMessage("JumpBackwardBy_Recording","seconds", "must be bigger or equal 0", -2) return -1 end
  
  -- stop recording, jump backward and restart recording
  if reaper.GetPlayState()==5 then -- during recording
    reaper.Main_OnCommand(1016,0)
    reaper.SetEditCurPos(reaper.GetPlayPosition()-seconds, true, true) 
    reaper.Main_OnCommand(1013,0)
  elseif reaper.GetPlayState()==6 then -- during pause-recording
    reaper.Main_OnCommand(1016,0)
    reaper.SetEditCurPos(reaper.GetPlayPosition()-seconds, true, true) 
    reaper.Main_OnCommand(1013,0)
    reaper.Main_OnCommand(1008,0)
  else -- every other play-state
    ultraschall.AddErrorMessage("JumpBackwardBy_Recording", "", "Only while recording or paused recording possible.", -3)
    return -1
  end
end

function ultraschall.GetNextClosestItemEdge(tracksstring, cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextClosestItemEdge</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>number position, integer item_number, string edgetype, MediaItem found_item  = ultraschall.GetNextClosestItemEdge(string trackstring, integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the position of the next closest item in seconds. It will return the position of the beginning or the end of that item, depending on what is closer.
    
    returns -1 in case of an error
  </description>
  <retvals>
    number position  - the position of the next closest item-edge in tracks in trackstring
    integer item_number - the itemnumber in the project
    string edgetype - "beg" for beginning of the item, "end" for the end of the item
    MediaItem found_item - the next closest found MediaItem 
  </retvals>
  <parameters>
    string trackstring - a string with the numbers of tracks to check for closest items, separated by a comma (e.g. "0,1,6")
    integer cursor_type - next closest item related to the current position of 0 - Edit Cursor, 1 - Play Cursor, 2 - Mouse Cursor, 3 - Timeposition
    optional number time_position - only, when cursor_type=3, a time position in seconds, from where to check for the next closest item. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, next item, position, edge</tags>
</US_DocBloc>
--]]
  local cursortime=0
  
  -- check parameters
  local tracks=tracksstring
  if ultraschall.IsValidTrackString(tracks)==false then ultraschall.AddErrorMessage("GetNextClosestItemEdge", "tracks", "must be a valid trackstring", -5) return -1 end
  
  -- check cursor_type-parameter and do the proper cursor-type-position
  if cursor_type==nil then ultraschall.AddErrorMessage("GetNextClosestItemEdge","cursor_type", "must be an integer", -1) return -1 end
  if cursor_type==0 then cursortime=reaper.GetCursorPosition() end
  if cursor_type==1 then cursortime=reaper.GetPlayPosition() end
  if cursor_type==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetNextClosestItemEdge", "", "Mouse is not in arrange-view.", -2) return -1 end
  end
  if cursor_type==3 then
      if type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemEdge","time_position", "must be a number.", -3) return -1 end
      cursortime=time_position
  end
  if cursor_type>3 or cursor_type<0 then ultraschall.AddErrorMessage("GetNextClosestItemEdge","cursor_type", "no such cursor_type existing", -4) return -1 end  
  if time_position~=nil and type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemEdge", "time_position", "must be either nil or a number", -6) return -1 end  

  -- prepare variables
  if time_position==nil and reaper.GetPlayState()==0 then
    time_position=reaper.GetCursorPosition()
  elseif time_position==nil and reaper.GetPlayState~=0 then
    time_position=reaper.GetPlayPosition()
  end
  
  local closest_item=reaper.GetProjectLength(0)
  local found_item=nil
  local another_item=-1
  local another_item_nr=-1
  local position=""
  local item_number=-1  
  local _count
  
  
  -- get tracksnumbers from trackstring
  local _count, TrackArray = ultraschall.CSV2IndividualLinesAsArray(tracks)  
  local TrackArray2={}
  
  for k=0, reaper.CountTracks()+1 do
    if TrackArray[k]~=nil then TrackArray2[tonumber(TrackArray[k])]=TrackArray[k]end
  end
  
  
  -- find the closest item and it's closest edge
  for i=0, reaper.CountMediaItems(0)-1 do
    for j=0, reaper.CountTracks(0) do
       if TrackArray2[j]~=nil and tracks~=-1 then  
          if ultraschall.IsItemInTrack(j,i)==true then
             -- when item is in track, check beginning and endings of the item
             local MediaItem=reaper.GetMediaItem(0, i)
             local ItemStart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
             local ItemEnd=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
             if ItemStart>cursortime and ItemStart<closest_item then -- check if it's beginning of the item
                closest_item=ItemStart
                found_item=MediaItem
                position="beg"
                item_number=i
             end
             if ItemEnd>cursortime and ItemEnd<=closest_item then -- check if it's end of the item
                closest_item=ItemEnd
                position="end"
                found_item=MediaItem
                if MediaItem~=nil then another_item=found_item another_item_nr=i end
                item_number=i
             end
          end
       end
    end
  end

  -- return found item
  if found_item~=nil then return closest_item, item_number, position, found_item
  else ultraschall.AddErrorMessage("GetNextClosestItemEdge", "", "no item found", -6) return -1
  end
end

function ultraschall.GetPreviousClosestItemEdge(tracksstring, cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousClosestItemEdge</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>number position, number position, integer item_number, string edgetype, MediaItem found_item = ultraschall.GetPreviousClosestItemEdge(string tracks, integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the position of the previous closest item-edge in seconds. It will return the position of the beginning or the end of that item, depending on what is closer.
    
    returns -1 in case of an error
  </description>
  <retvals>
    number position  - the position of the previous closest item edge in tracks in trackstring
    integer item_number - the itemnumber in the project
    string edgetype - "beg" for beginning of the item, "end" for the end of the item
    MediaItem found_item - the next closest found MediaItem 
  </retvals>
  <parameters>
    string tracks - a string with the numbers of tracks to check for closest items, separated by a comma (e.g. "0,1,6")
    integer cursor_type - previous closest item related to the current position of 0 - Edit Cursor, 1 - Play Cursor, 2 - Mouse Cursor, 3 - Timeposition
    optional time_position - only, when cursor_type=3, a time position in seconds, from where to check for the previous closest item. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, previous item, position, edge</tags>
</US_DocBloc>
--]]
  local cursortime=0
  local _count
  
  -- check parameters
  local tracks=tracksstring
  if ultraschall.IsValidTrackString(tracks)==false then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge","tracks", "must be a string", -5) return -1 end
  if time_position~=nil and type(time_position)~="number" then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge","time_position", "must be either nil or a number", -6) return -1 end
  
  -- check cursor_type-parameter and do the proper cursor-type-position
  if math.type(cursor_type)~="integer" then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge","cursor_type", "must be an integer", -1) return -1 end
  if cursor_type==0 then cursortime=reaper.GetCursorPosition() end
  if cursor_type==1 then cursortime=reaper.GetPlayPosition() end
  if cursor_type==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge", "", "mouse not in arrange-view", -2) return -1 end
  end
  if cursor_type==3 then
      if time_position==nil then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge","time_position", "no nil allowed", -3) return -1 end
      cursortime=time_position
  end
  if cursor_type>3 or cursor_type<0 then ultraschall.AddErrorMessage("GetPreviousClosestItemEdge","cursor_type", "no such cursortype existing", -4) return -1 end  
  

  -- prepare variables
  local _count, TrackArray = ultraschall.CSV2IndividualLinesAsArray(tracks)
  if time_position==nil and reaper.GetPlayState()==0 then
    time_position=reaper.GetCursorPosition()
  elseif time_position==nil and reaper.GetPlayState~=0 then
    time_position=reaper.GetPlayPosition()
  end
  local TrackArray2={}
  for k=0, reaper.CountTracks()+1 do
    if TrackArray[k]~=nil then TrackArray2[tonumber(TrackArray[k])]=TrackArray[k] end
  end
  
  local closest_item=-1
  local found_item=nil
  local position=""
  local item_number=-1


  -- find previous closest item and it's edge
  for i=0, reaper.CountMediaItems(0)-1 do
    for j=0, reaper.CountTracks(0) do 
      if TrackArray2[j]~=nil and tonumber(tracks)~=-1 then  
        if ultraschall.IsItemInTrack(j,i)==true then
          -- if item is in track, find the closest edge
          local MediaItem=reaper.GetMediaItem(0, i)
          local Aretval, Astr = reaper.GetItemStateChunk(MediaItem,"<ITEMPOSITION",false)
          local ItemStart=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
          local ItemEnd=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
          if ItemEnd<cursortime and ItemEnd>closest_item then -- if it's item-end
              closest_item=ItemEnd
              position="end"
              found_item=MediaItem
              item_number=i
          elseif ItemStart<cursortime and ItemStart>closest_item then -- if it's item-beginning
              closest_item=ItemStart
              found_item=MediaItem
              position="beg"
              item_number=i
          end
        end
      end
    end
  end
  
  -- return found item
  if found_item~=nil then return closest_item, item_number, position, found_item
  else ultraschall.AddErrorMessage("GetPreviousClosestItemEdge", "", "no item found", -6) return -1
  end
end

function ultraschall.GetClosestNextMarker(cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestNextMarker</slug>
  <requires>
    Ultraschall=5
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer markerindex, number position, string markertitle, integer markerindex_shownnumber = ultraschall.GetClosestNextMarker(integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the shown markerindex, the position in seconds, the name and the index within all markers of the next closest marker.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer markerindex - the next closest marker-index within all(!) markers and regions
    number position - the position of the next closest marker
    string markertitle - the name of the next closest marker
    integer markerindex_shownnumber - the next closest shown markerindex     
  </retvals>
  <parameters>
    integer cursor_type - previous closest marker related to the current position of 0 - Edit Cursor, 1 - Play Cursor, 2 - Mouse Cursor, 3 - Timeposition
    optional number time_position - only, when cursor_type=3, a time position in seconds, from where to check for the next closest marker. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, next marker, position, marker </tags>
</US_DocBloc>
--]]
  local cursortime=0
  if math.type(cursor_type)~="integer" then ultraschall.AddErrorMessage("GetClosestNextMarker", "cursor_type", "must be an integer", -1) return -1 end
  if time_position~=nil and type(time_position)~="number" then ultraschall.AddErrorMessage("GetClosestNextMarker", "time_position", "must be either nil or a number", -5) return -1 end
  if time_position==nil and cursor_type>2 then ultraschall.AddErrorMessage("GetClosestNextMarker", "time_position", "must be a number when cursortype=3", -6) return -1 end

  -- check parameters  
  if time_position==nil and reaper.GetPlayState()==0 and cursor_type~=3 then
    time_position=reaper.GetCursorPosition()
  elseif time_position==nil and reaper.GetPlayState~=0 and cursor_type~=3 then
    time_position=reaper.GetPlayPosition()
  elseif time_position==nil and cursor_type~=3 then
    time_position=time_position
  end
  
  --  check cursor_type parameter and do the proper cursor-type-position
  if cursor_type==0 then cursortime=reaper.GetCursorPosition() end
  if cursor_type==1 then cursortime=reaper.GetPlayPosition() end
  if cursor_type==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetClosestNextMarker", "", "mouse not in arrange-view", -2) return -1 end
  end
  if cursor_type==3 then
      cursortime=time_position
  end
  if cursor_type>3 or cursor_type<0 then ultraschall.AddErrorMessage("GetClosestNextMarker","cursor_type", "no such cursor_type existing", -4) return -1 end

  -- prepare variables
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local retposition=reaper.GetProjectLength(0)+1--*200000000 --Working Hack, but isn't elegant....
  local retindexnumber=-1
  local retmarkername=""
  
  -- find next closest marker
  for i=0, retval do
    local retval2, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if pos>cursortime and pos<retposition then
        --print2(i)
        retposition=pos
        retindexnumber=markrgnindexnumber
        retmarkername=name
        retindex=i
        --print2(i, name)
        break
      end
    end
  end
  -- return found marker
  if retindexnumber==-1 then retposition=-1 end
  return retindexnumber, retposition, retmarkername, retindexnumber
end

function ultraschall.GetClosestPreviousMarker(cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestPreviousMarker</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer markerindex, number position, string markertitle, integer markerindex_shownnumber = ultraschall.GetClosestPreviousMarker(integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the markerindex, the position in seconds, the name and the index(counted from all markers) of the previous closest marker.
  </description>
  <retvals>
    integer markerindex - the previous closest marker-index within all(!) markers and regions
    number position - the position of the previous closest marker
    string markertitle - the name of the previous closest marker
    integer markerindex_shownnumber - the previous closest shown number of the found marker
  </retvals>
  <parameters>
    integer cursor_type - previous closest marker related to the current position of 0 - Edit Cursor, 1 - Play Cursor, 2 - Mouse Cursor, 3 - Timeposition
    optional number time_position - only, when cursor_type=3, a time position in seconds, from where to check for the previous closest marker. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, previous marker, position, marker</tags>
</US_DocBloc>
--]]
  local cursortime=0

  if math.type(cursor_type)~="integer" then ultraschall.AddErrorMessage("GetClosestPreviousMarker", "cursor_type", "must be an integer", -1) return -1 end
  if time_position~=nil and type(time_position)~="number" then ultraschall.AddErrorMessage("GetClosestPreviousMarker", "time_position", "must be either nil or a number", -5) return -1 end
  if time_position==nil and cursor_type>2 then ultraschall.AddErrorMessage("GetClosestPreviousMarker", "time_position", "must be a number when cursortype=3", -6) return -1 end
    
  -- check parameters
  if time_position==nil and reaper.GetPlayState()==0 and cursor_type~=3 then
    time_position=reaper.GetCursorPosition()
  elseif time_position==nil and reaper.GetPlayState~=0 and cursor_type~=3 then
    time_position=reaper.GetPlayPosition()
  elseif time_position==nil and cursor_type~=3 then
    time_position=time_position
  end
  -- check parameter cursor_type and do the cursor-type-position
  if cursor_type==0 then cursortime=reaper.GetCursorPosition() end
  if cursor_type==1 then cursortime=reaper.GetPlayPosition() end
  if cursor_type==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetClosestPreviousMarker", "", "mouse not in arrange-view", -2) return -1 end
  end
  if cursor_type==3 then
      cursortime=time_position
  end
  if cursor_type>3 or cursor_type<0 then ultraschall.AddErrorMessage("GetClosestPreviousMarker","cursor_type", "no such cursor-type existing", -4) return -1 end
  
  -- prepare variables
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local found=false
  local retposition=-1
  local retindexnumber=-1
  local retmarkername=""
  
  -- find previous closest marker
  for i=0,retval-1 do
    local retval2, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==false then
      if pos<cursortime and pos>retposition then
        retposition=pos
        retindexnumber=markrgnindexnumber
        retmarkername=name
        retindex=i
        found=true
        --print2(i, name)
      end
    end
  end
  -- return found marker
  if found==false then retposition=-1 retindexnumber=-1 end
  return retindex, retposition, retmarkername, retindexnumber
end


function ultraschall.GetClosestNextRegionEdge(cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestNextRegionEdge</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer markerindex, number position, string markertitle, string edge_type, integer markerindex_shownnumber = ultraschall.GetClosestNextRegionEdge(integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the regionindex(counted from all markers and regions), the position and the name of the next closest regionstart/end(depending on which is closer to time_position) in seconds.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer markerindex - the next closest markerindex (of all(!) markers)
    number position - the position of the next closest region
    string markertitle - the name of the next closest region
    string edge_type - the type of the edge of the region, either "beg" or "end"
    integer markerindex_shownnumber - the next closest shown number of the found region
  </retvals>
  <parameters>
    integer cursor_type - previous closest regionstart/end related to the current position of 
                        - 0, Edit Cursor, 
                        - 1, Play Cursor, 
                        - 2, Mouse Cursor, 
                        - 3, Timeposition
    only number time_position - only, when cursor_type=3, a time position in seconds, from where to check for the next closest regionstart/end. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, next region, region, position</tags>
</US_DocBloc>
--]]
  local cursortime=0
  
  -- check parameters
  if tonumber(time_position)==nil and reaper.GetPlayState()==0 and tonumber(cursor_type)~=3 then
    time_position=reaper.GetCursorPosition()
  elseif tonumber(time_position)==nil and reaper.GetPlayState~=0 and tonumber(cursor_type)~=3 then
    time_position=reaper.GetPlayPosition()
  elseif tonumber(time_position)==nil and tonumber(cursor_type)~=3 then
    time_position=tonumber(time_position)
  end
  -- check parameter cursor_type and do the cursor-type-position
  if math.type(cursor_type)~="integer" then ultraschall.AddErrorMessage("GetClosestNextRegionEdge", "cursor_type", "must be an integer", -1) return -1 end
  if tonumber(cursor_type)==0 then cursortime=reaper.GetCursorPosition() end
  if tonumber(cursor_type)==1 then cursortime=reaper.GetPlayPosition() end
  if tonumber(cursor_type)==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetClosestNextRegionEdge", "", "mouse not in arrange view", -2) return -1 end
  end
  if tonumber(cursor_type)==3 then
      if tonumber(time_position)==nil then ultraschall.AddErrorMessage("GetClosestNextRegionEdge","time_position", "no nil allowed when cursor_type=3", -3) return -1 end
      cursortime=tonumber(time_position)
  end
  if tonumber(cursor_type)>3 or tonumber(cursor_type)<0 then ultraschall.AddErrorMessage("GetClosestNextRegionEdge","cursor_type", "no such cursor_type existing", -4) return -1 end
  
  -- prepare variables
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local retposition=reaper.GetProjectLength()+1--*200000000 --Working Hack, but isn't elegant....
  local retindexnumber=-1
  local retmarkername=""
  local retbegin=""
    
  -- find next region and it's closest edge
  for i=0,retval do
    local retval2, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==true then
      if pos>cursortime and pos<retposition then -- beginning of the region
        retposition=pos
        retindexnumber=i
        retshownnumber=markrgnindexnumber
        retmarkername=name
        retbegin="beg"
      end

      if rgnend>cursortime and rgnend<retposition then -- ending of the region
        retposition=rgnend
        retindexnumber=i
        retshownnumber=markrgnindexnumber
        retmarkername=name
        retbegin="end"
      end
    end
  end
  -- return found region
  if retindexnumber==-1 then retposition=-1 end
  return retindexnumber,retposition, retmarkername, retbegin, retshownnumber
end

function ultraschall.GetClosestPreviousRegionEdge(cursor_type, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestPreviousRegionEdge</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer markerindex, number position, string markertitle, string edge_type, integer markerindex_shownnumber = ultraschall.GetClosestPreviousRegionEdge(integer cursor_type, optional number time_position)</functioncall>
  <description>
    returns the regionindex(counted from all markers and regions), the position and the name of the previous closest regionstart/end(depending on which is closer to time_position) in seconds.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer markerindex - the previous closest markerindex (of all(!) markers)
    number position - the position of the previous closest marker
    string markertitle - the name of the previous closest marker
    string edge_type - the type of the edge of the region, either "beg" or "end"
    integer markerindex_shownnumber - the previous closest shown number of the found region
  </retvals>
  <parameters>
    integer cursor_type - previous closest regionstart/end related to the current position of 0 - Edit Cursor, 1 - Play Cursor, 2 - Mouse Cursor, 3 - Timeposition
    optional number time_position - only, when cursor_type=3, a time position in seconds, from where to check for the previous closest regionstart/end. When omitted, it will take the current play(during play and rec) or edit-cursor-position.
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, previous region, region, position</tags>
</US_DocBloc>
--]]
  local cursortime=0
  
  -- check parameters
  if tonumber(time_position)==nil and reaper.GetPlayState()==0 and tonumber(cursor_type)~=3 then
    time_position=reaper.GetCursorPosition()
  elseif tonumber(time_position)==nil and reaper.GetPlayState~=0 and tonumber(cursor_type)~=3 then
    time_position=reaper.GetPlayPosition()
  elseif tonumber(time_position)==nil and tonumber(cursor_type)~=3 then
    time_position=tonumber(time_position)
  end
  -- check parameter cursor_type and do the cursor-type-position  
  if math.type(cursor_type)~="integer" then ultraschall.AddErrorMessage("GetClosestPreviousRegionEdge","cursor_type", "must be an integer", -1) return -1 end
  if tonumber(cursor_type)==0 then cursortime=reaper.GetCursorPosition() end
  if tonumber(cursor_type)==1 then cursortime=reaper.GetPlayPosition() end
  if tonumber(cursor_type)==2 then 
      reaper.BR_GetMouseCursorContext() 
      cursortime=reaper.BR_GetMouseCursorContext_Position() 
      if cursortime==-1 then ultraschall.AddErrorMessage("GetClosestPreviousRegionEdge", "", "mouse not in arrange-view", -2) return -1 end
  end
  if tonumber(cursor_type)==3 then
      if tonumber(time_position)==nil then ultraschall.AddErrorMessage("GetClosestPreviousRegionEdge","time_position", "no nil allowed when cursortype=3", -3) return -1 end
      cursortime=tonumber(time_position)
  end
  if tonumber(cursor_type)>3 or tonumber(cursor_type)<0 then ultraschall.AddErrorMessage("GetClosestPreviousRegionEdge","cursor_type", "no such cursortype existing", -4) return -1 end
  
  -- prepare variables
  local retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local retposition=-1
  local retindexnumber=-1
  local retmarkername=""
  local retbeg=""
  
  -- find closest previous region and it's closest edge
  for i=0,retval do
    local retval2, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
    if isrgn==true then -- beginning of the region
      if pos<cursortime and pos>retposition then
        retposition=pos
        retindexnumber=i
        retshownnumber=markrgnindexnumber
        retmarkername=name
        retbeg="beg"
      end
      if rgnend<cursortime and rgnend>retposition then  -- ending of the item
        retposition=rgnend
        retbeg="end"
      end
    end
  end
  return retindexnumber, retposition, retmarkername, retbeg, retshownnumber
end

function ultraschall.GetClosestGoToPoints(trackstring, time_position, check_itemedge, check_marker, check_region)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetClosestGoToPoints</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>number elementposition_prev, string elementtype_prev, integer number_prev, number elementposition_next, string elementtype_next, integer number_next = ultraschall.GetClosestGoToPoints(string trackstring, number time_position, optional boolean check_itemedge, optional boolean check_marker, optional boolean check_region)</functioncall>
  <description>
    returns, what are the closest markers/regions/item starts/itemends to position and within the chosen tracks.
    
    returns -1 in case of error
  </description>
  <retvals>
    number elementposition_prev - previous closest markers/regions/item starts/itemends
    string elementtype_prev - type of the previous closest markers/regions/item starts/itemends
    -the type can be either Itembeg, Itemend, Marker: name, Region_beg: name; Region_end: name, ProjectStart, ProjectEnd; "name" is the name of the marker or region
    integer number_prev - number of previous closest markers/regions/item starts/itemends
    number elementposition_next - previous closest markers/regions/item starts/itemends
    string elementtype_next - type of the previous closest markers/regions/item starts/itemends
    -the type can be either Itembeg, Itemend, Marker: name, Region_beg: name; Region_end: name, ProjectStart, ProjectEnd; "name" is the name of the marker or region
    integer number_next  - number of previous closest markers/regions/item starts/itemends
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the next/previous closest items/markers/regions.
                         - -1, for editcursorposition; -2, for playcursor-position, -3, the mouse-cursor-position in seconds(where in the project the mousecursor hovers over)
    optional boolean check_itemedge - true, look for itemedges as possible goto-points; false, do not
    optional boolean check_marker - true, look for markers as possible goto-points; false, do not
    optional boolean check_region - true, look for regions as possible goto-point; false, do not
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, previous, next, marker, region, item, edge</tags>
</US_DocBloc>
--]]

  -- check parameters
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetClosestGoToPoints", "trackstring", "must be a valid trackstring", -1) return -1 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetClosestGoToPoints", "time_position", "must be a number", -2) return -1 end
  if check_itemedge~=nil and type(check_itemedge)~="boolean" then ultraschall.AddErrorMessage("GetClosestGoToPoints", "check_itemedge", "must be a boolean", -3) return -1 end
  if check_marker~=nil and type(check_marker)~="boolean" then ultraschall.AddErrorMessage("GetClosestGoToPoints", "check_marker", "must be a boolean", -4) return -1 end
  if check_region~=nil and type(check_region)~="boolean" then ultraschall.AddErrorMessage("GetClosestGoToPoints", "check_region", "must be a boolean", -5) return -1 end
  
  if check_itemedge==nil then check_itemedge=true end
  if check_marker==nil then check_marker=true end
  if check_region==nil then check_region=true end

  if tonumber(time_position)==-1 then
    time_position=reaper.GetCursorPosition()
  elseif tonumber(time_position)==-2 then
    time_position=reaper.GetPlayPosition()
  elseif tonumber(time_position)==-3 then
    reaper.BR_GetMouseCursorContext()
    time_position=reaper.BR_GetMouseCursorContext_Position()
  else
    time_position=tonumber(time_position)
  end

  -- prepare variables
  local elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next=nil
  local elementposition_prev=-1
  local elementposition_next=reaper.GetProjectLength()+1
  
  -- get closest items, markers and regions
  local nextitempos, nextitemid, nextedgetype =ultraschall.GetNextClosestItemEdge(trackstring,3,time_position)
  local previtempos, previtemid, prevedgetype =ultraschall.GetPreviousClosestItemEdge(trackstring,3,time_position)

  local nextmarkerid,nextmarkerpos,nextmarkername=ultraschall.GetClosestNextMarker(3, time_position)
  local prevmarkerid,prevmarkerpos,prevmarkername=ultraschall.GetClosestPreviousMarker(3,time_position)

  local nextrgnID, nextregionpos,nextregionname,nextedgetype=ultraschall.GetClosestNextRegionEdge(3,time_position)
  local prevrgnID, prevregionpos,prevregionname,prevedgetype=ultraschall.GetClosestPreviousRegionEdge(3,time_position)

  -- now we find, which is the closest element
  -- Item-Edges
  if check_itemedge==true then
    if previtempos~=-1 and elementposition_prev<=previtempos then number_prev=previtemid elementposition_prev=previtempos elementtype_prev="Item"..prevedgetype end
    if nextitempos~=-1 and elementposition_next>=nextitempos then number_next=nextitemid elementposition_next=nextitempos elementtype_next="Item"..nextedgetype end
  end
  
  -- Markers
  if check_marker==true then
    if prevmarkerid~=-1 and elementposition_prev<=prevmarkerpos then number_prev=prevmarkerid elementposition_prev=prevmarkerpos elementtype_prev="Marker: "..prevmarkername end
    if nextmarkerid~=-1 and elementposition_next>=nextmarkerpos then number_next=nextmarkerid elementposition_next=nextmarkerpos elementtype_next="Marker: "..nextmarkername end
  end
  
  -- Region-Edges
  if check_region==true then
    if elementposition_prev<=prevregionpos and prevrgnID~=-1 then number_prev=prevrgnID elementposition_prev=prevregionpos elementtype_prev="Region_"..prevedgetype..": "..prevregionname end
    if elementposition_next>=nextregionpos and nextrgnID~=-1 then number_next=nextrgnID elementposition_next=nextregionpos elementtype_next="Region_"..nextedgetype..": "..nextregionname end
  end
  
  -- if none was found, use projectend/projectstart
  if elementposition_prev<0 then elementposition_prev=0 elementtype_prev="ProjectStart" end
  if elementposition_next>reaper.GetProjectLength() then elementposition_next=reaper.GetProjectLength() elementtype_next="ProjectEnd" end

  return elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next
end


function ultraschall.CenterViewToCursor(cursortype, position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CenterViewToCursor</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>ultraschall.CenterViewToCursor(integer cursortype, optional number position)</functioncall>
  <description>
    centers the arrange-view around a given cursor
    
    returns nil in case of an error
  </description>
  <parameters>
    integer cursortype - the cursortype to center
    - 1 - change arrangeview with edit-cursor centered
    - 2 - change arrangeview with play-cursor centered
    - 3 - change arrangeview with mouse-cursor-position centered
    - 4 - change arrangeview with optional parameter position centered
    optional number position - the position to center the arrangeview to; only used, when cursortype=4
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, center, cursor, mouse, edit, play</tags>
</US_DocBloc>
]]
    if math.type(cursortype)~="integer" then ultraschall.AddErrorMessage("CenterViewToCursor","cursortype", "only integer allowed", -1) return end
    if position~=nil and type(position)~="number" then ultraschall.AddErrorMessage("CenterViewToCursor","position", "only numbers allowed", -3) return end
    local cursor_time
    if cursortype<1 or cursortype>4 then ultraschall.AddErrorMessage("CenterViewToCursor","cursortype", "no such cursortype; only 1-3 existing.", -2) return end
    if cursortype==1 then cursor_time=reaper.GetCursorPosition() end
    if cursortype==2 then cursor_time=reaper.GetPlayPosition() end
    if cursortype==3 then 
      retval, segment, details = reaper.BR_GetMouseCursorContext()
      cursor_time=reaper.BR_GetMouseCursorContext_Position()
    end
    if cursortype==4 then if position~=nil then cursor_time=position else ultraschall.AddErrorMessage("CenterViewToCursor","position", "only numbers allowed", -3) return end end
    start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    length=((end_time-start_time)/2)+(1/reaper.GetHZoomLevel())
    reaper.GetSet_ArrangeView2(0, true, 0, 0, (cursor_time-length), (cursor_time+length))
end

function ultraschall.GetLastCursorPosition()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastCursorPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number last_editcursor_position, number new_editcursor_position, number statechangetime = ultraschall.GetLastCursorPosition()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deprecated.
  
    Returns the last and current editcursor-position. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    Has an issue, when editcursor-position was changed using a modifier, like alt+click or shift+click! Because of that, you should use this only in defer-scripts.
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    number last_editcursor_position - the last cursorposition before the current one; -1, in case of an error
    number new_editcursor_position - the new cursorposition; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, last position, editcursor</tags>
</US_DocBloc>
]]
  ultraschall.deprecated("GetLastCursorPosition")
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_cursorposition.lua")~="true" then return -1 end
  return tonumber(reaper.GetExtState("ultraschall", "editcursor_position_old")), tonumber(reaper.GetExtState("ultraschall", "editcursor_position_new")), tonumber(reaper.GetExtState("ultraschall", "editcursor_position_changetime"))
end

function ultraschall.GetLastPlayState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastPlayState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string last_play_state, string new_play_state, number statechangetime = ultraschall.GetLastPlayState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deprecated
    
    Returns the last and current playstate. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    possible states are STOP, PLAY, PLAYPAUSE, REC, RECPAUSE
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    string last_play_state - the last playstate before the current one; -1, in case of an error
    string new_play_state - the new playstate; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, last playstate, editcursor</tags>
</US_DocBloc>
]]
  ultraschall.deprecated("GetLastPlayState")
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_playstate.lua")~="true" then return -1 end
  return reaper.GetExtState("ultraschall", "playstate_old"), reaper.GetExtState("ultraschall", "playstate_new"), tonumber(reaper.GetExtState("ultraschall", "playstate_changetime"))
end
--ultraschall.RunBackgroundHelperFeatures()
--A=ultraschall.GetLastPlayState()

function ultraschall.GetLastLoopState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string last_loop_state, string new_loop_state, number statechangetime = ultraschall.GetLastLoopState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Deprecated
    
    Returns the last and current loopstate. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    Possible states are LOOPED, UNLOOPED
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    string last_loop_state - the last loopstate before the current one; -1, in case of an error
    string new_loop_state - the current loopstate; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, last loopstate, editcursor</tags>
</US_DocBloc>
]]
  ultraschall.deprecated("GetLastLoopState")
  
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_loopstate.lua")~="true" then return -1 end
  return reaper.GetExtState("ultraschall", "loopstate_old"), reaper.GetExtState("ultraschall", "loopstate_new"), tonumber(reaper.GetExtState("ultraschall", "loopstate_changetime"))
end

function ultraschall.GetLoopState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetLoopState()</functioncall>
  <description>
    Returns the current loop-state
  </description>
  <retvals>
    integer retval - 0, loop is on; 1, loop is off
  </retvals>
  <chapter_context>
    Navigation
    Transport
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>transportmanagement, get, loop</tags>
</US_DocBloc>
--]]
  return reaper.GetToggleCommandState(1068)
end

--A=ultraschall.GetLoopState()

function ultraschall.SetLoopState(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetLoopState(integer state)</functioncall>
  <description>
    Sets the current loop-state
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    integer state - 0, loop is on; 1, loop is off
  </parameters>
  <chapter_context>
    Navigation
    Transport
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>transportmanagement, set, loop</tags>
</US_DocBloc>
--]]
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("SetLoopState", "state", "must be an integer", -1) return false end
  if state~=0 and state~=1 then ultraschall.AddErrorMessage("SetLoopState", "state", "must be 1(on) or 0(off)", -2) return false end
  if ultraschall.GetLoopState()~=state then
    reaper.Main_OnCommand(1068, 0)
  end
  return true
end

--A=ultraschall.SetLoopState(0)


function ultraschall.Scrubbing_MoveCursor_GetToggleState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Scrubbing_MoveCursor_GetToggleState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean state = ultraschall.Scrubbing_MoveCursor_GetToggleState()</functioncall>
  <description>
    Returns, if scrub is toggled on/off, for when moving editcursor via action or control surface, as set in Preferences -> Playback.
  </description>
  <retvals>
    boolean retval - true, scrub is on; false, scrub is off
  </retvals>
  <chapter_context>
    Navigation
    Scrubbing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, scrub, when moving editcursor, action, surface</tags>
</US_DocBloc>
--]]
  if reaper.SNM_GetIntConfigVar("scrubmode", -9)&1==0 then return false else return true end
end

function ultraschall.Scrubbing_MoveCursor_Toggle(toggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Scrubbing_MoveCursor_Toggle</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean state, optional integer new_scrubmode = ultraschall.Scrubbing_MoveCursor_Toggle(boolean toggle)</functioncall>
  <description>
    Toggles scrub on/off, for when moving editcursor via action or control surface, as set in Preferences -> Playback.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, toggling was successful; false, toggling was unsuccessful
    optional integer new_scrubmode - this is the new value of the configvariable scrubmode, which is altered by this function
  </retvals>
  <parameters>
    boolean toggle - true, toggles scrubbing on; false, toggles scrubbing off
  </parameters>
  <chapter_context>
    Navigation
    Scrubbing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, scrub, toggle, when moving editcursor, action, surface</tags>
</US_DocBloc>
--]]
  if type(toggle)~="boolean" then ultraschall.AddErrorMessage("Scrubbing_MoveCursor_Toggle", "toggle", "must be a boolean", -1) return false end
  return ultraschall.GetSetIntConfigVar("scrubmode", true, toggle)
end

function ultraschall.GetNextClosestItemStart(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextClosestItemStart</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetNextClosestItemStart(string trackstring, number time_position)</functioncall>
  <description>
    returns the next closest item-start in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the next closest item-start
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, next, closest, itemstart, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetNextClosestItemStart", "trackstring", "must be a valid trackstring", -1) return -1 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemStart", "time_position", "must be a number", -1) return -1 end

  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(time_position, reaper.GetProjectLength(), trackstring, true)
  
  if count==0 or count==-1 then return -1 end
  local pos=reaper.GetProjectLength(0)
  local found_item=nil
  --print2(count)
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")
    if pos2<pos and pos2>time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  if pos==reaper.GetProjectLength(0)+1 then pos=-1 end
  return pos, found_item
end

--A, B=ultraschall.GetNextClosestItemStart("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetPreviousClosestItemStart(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousClosestItemStart</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetPreviousClosestItemStart(string trackstring, number time_position)</functioncall>
  <description>
    returns the previous closest item-start in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the previous closest item-start
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, previous, closest, itemstart, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetPreviousClosestItemStart", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetPreviousClosestItemStart", "time_position", "must be a number", -1) return -2 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, time_position, trackstring, false)
  if count==0 or count==-1 then return -1 end
  local pos=-1
  local found_item=nil
  for i=#MediaItemArray, 1, -1 do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")
    if pos2>pos and pos2<time_position then pos=pos2 found_item=MediaItemArray[i] end
  end

  return pos, found_item
end

--A, B=ultraschall.GetPreviousClosestItemStart("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetPreviousClosestItemEnd(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousClosestItemEnd</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetPreviousClosestItemEnd(string trackstring, number time_position)</functioncall>
  <description>
    returns the previous closest item-end in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the previous closest item-end
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, previous, closest, itemend, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetPreviousClosestItemEnd", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetPreviousClosestItemEnd", "time_position", "must be a number", -1) return -2 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(), trackstring, true)
  if count==0 or count==-1 then return -1 end
  local pos=-1
  local found_item=nil
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")
    if pos2>pos and pos2<time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  return pos, found_item
end

--A=ultraschall.GetPreviousClosestItemEnd("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetNextClosestItemEnd(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextClosestItemEnd</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetNextClosestItemEnd(string trackstring, number time_position)</functioncall>
  <description>
    returns the next closest item-end in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the next closest item-end
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, next, closest, itemend, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetNextClosestItemEnd", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemEnd", "time_position", "must be a number", -1) return -2 end
  if time_position>reaper.GetProjectLength(0) then return -1 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(), trackstring, false)
  if count==0 or count==-1 then return -1 end
  local pos=reaper.GetProjectLength(0)+1
  local found_item=nil
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")
    if pos2<pos and pos2>time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  if pos==reaper.GetProjectLength(0)+1 then pos=-1 end
  return pos, found_item
end