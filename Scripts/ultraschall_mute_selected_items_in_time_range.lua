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
 

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

-- Ultraschall mute time selection
--
-- add envelope points to mute envelope in time range
-- if items are selected only mute them
-- if no items are selected mute items on selected tracks
-- if no items nor tracks are selected mute all items in time range

function muteselectedItems()
  --create table of selected tracks
  num_of_tracks=reaper.CountSelectedTracks(0)
  track_list={}
  
  for i=0, num_of_tracks-1 do
    track_list[i]=reaper.GetSelectedTrack(0, i)
  end
  
  reaper.Main_OnCommand(40297,0) --deselect all tracks
  
  if number_of_selected_items>0 then
    number_of_items=number_of_selected_items
  end
  
  --for item_id=0, number_of_items-1 do
  for item_id=number_of_items-1,0,-1 do
    if number_of_selected_items>0 then
      item=reaper.GetSelectedMediaItem(0, item_id)
    else
      item=reaper.GetMediaItem(0, item_id)
    end
    
    track_of_item=reaper.GetMediaItemTrack(item)
    item_start=reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    item_end=item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    
    
    -- if item is (partial) in range set envelope points + make envelope visible
    if (item_start<time_selection_end) and (item_end>time_selection_start) then
      -- show mute envelope
      MuteTrackEnvelope=reaper.GetTrackEnvelopeByName(track_of_item, "Mute")
      
      --activate if needed
      if MuteTrackEnvelope==NIL then
        reaper.SetTrackSelected(track_of_item, true)
        reaper.Main_OnCommand(40866,0)
        reaper.SetTrackSelected(track_of_item, false)
        MuteTrackEnvelope=reaper.GetTrackEnvelopeByName(track_of_item, "Mute")
      end
      
      retval, Env_XML= reaper.GetEnvelopeStateChunk(MuteTrackEnvelope, "", false)
      Env_XML = Env_XML:gsub("VIS 0 1 1", "VIS 1 1 1")
      reaper.SetEnvelopeStateChunk(MuteTrackEnvelope, Env_XML, false)
      
      -- get start, end and old values at the start and end
      mute_start=math.max(time_selection_start, item_start)
      mute_end=math.min(time_selection_end, item_end)
      ret,value_at_in_point =reaper.Envelope_Evaluate(MuteTrackEnvelope, mute_start, 0, 0)
      ret,value_at_out_point=reaper.Envelope_Evaluate(MuteTrackEnvelope, mute_end, 0, 0)
      
      -- delete points between in/out and set new ones
      reaper.DeleteEnvelopePointRange(MuteTrackEnvelope, mute_start, mute_end)
      
      -- check if there’s a point at the beginning, if not set one to unmute
      point_at_zero=reaper.GetEnvelopePointByTime(MuteTrackEnvelope, 0.0)
      if point_at_zero<0 then
        reaper.InsertEnvelopePoint(MuteTrackEnvelope, 0.0, 1 , 1, 0, false)
      end

      --set START Point
      --reaper.InsertEnvelopePoint(MuteTrackEnvelope, mute_start, 1, 1, 0, false, false)
      reaper.InsertEnvelopePoint(MuteTrackEnvelope, mute_start, 0, 1, 0, false, false)
      
      --set END Point if needed
      if value_at_out_point>0.5 then
        reaper.InsertEnvelopePoint(MuteTrackEnvelope,  mute_end  , 1, 1, 0, false, false)
      end
      
      --sort points (do we need it?)
      reaper.Envelope_SortPoints(MuteTrackEnvelope)
    end
  end
  
  --reselct tracks
  for i=0, num_of_tracks-1 do
    reaper.SetTrackSelected(track_list[i], true)
  end  
end

function muteselectedTracks()
  --create table of selected tracks
  num_of_tracks=reaper.CountSelectedTracks(0)
  track_list={}
  
  for i=0, num_of_tracks-1 do
    track_list[i]=reaper.GetSelectedTrack(0, i)
  end
  
  reaper.Main_OnCommand(40297,0) --deselect all tracks
  
  for i=0,num_of_tracks-1 do
    MuteTrackEnvelope=reaper.GetTrackEnvelopeByName(track_list[i], "Mute")
    
    --activate if needed
    if MuteTrackEnvelope==NIL then
      reaper.SetTrackSelected(track_list[i], true)
      reaper.Main_OnCommand(40866,0)
      reaper.SetTrackSelected(track_list[i], false)
      MuteTrackEnvelope=reaper.GetTrackEnvelopeByName(track_list[i], "Mute")
    end
    
    retval, Env_XML= reaper.GetEnvelopeStateChunk(MuteTrackEnvelope, "", false)
    Env_XML = Env_XML:gsub("VIS 0 1 1", "VIS 1 1 1")
    reaper.SetEnvelopeStateChunk(MuteTrackEnvelope, Env_XML, false)
    ret,value_at_out_point=reaper.Envelope_Evaluate(MuteTrackEnvelope, time_selection_end, 0, 0)
    
    -- delete points between in/out
    reaper.DeleteEnvelopePointRange(MuteTrackEnvelope, time_selection_start, time_selection_end)
    
    -- check if there’s a point at the beginning, if not set one to unmute
    point_at_zero=reaper.GetEnvelopePointByTime(MuteTrackEnvelope, 0.0)
    if point_at_zero<0 then
      reaper.InsertEnvelopePoint(MuteTrackEnvelope, 0.0, 1 , 1, 0, false)
    end

    --set START Point
    reaper.InsertEnvelopePoint(MuteTrackEnvelope, time_selection_start, 0, 1, 0, false, false)
    
    --set END Point if needed
    if value_at_out_point>0.5 then
      reaper.InsertEnvelopePoint(MuteTrackEnvelope,  time_selection_end  , 1, 1, 0, false, false)
    end
  end
  
  --reselct tracks
  for i=0, num_of_tracks-1 do
    reaper.SetTrackSelected(track_list[i], true)
  end   
end


reaper.Undo_BeginBlock()

-- get info about the number of selected things
number_of_selected_items=reaper.CountSelectedMediaItems(0)
number_of_items=reaper.CountMediaItems(0)
number_of_selected_tracks=reaper.CountSelectedTracks(0)

--get range start and end
time_selection_start, time_selection_end = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

--if there is a selection mute stuff
if time_selection_end-time_selection_start>0 then
  if number_of_selected_items>0 then
    muteselectedItems()
  else
    if number_of_selected_tracks==0 then reaper.Main_OnCommand(40296,0) end --select all tracks
    muteselectedTracks()
    if number_of_selected_tracks==0 then reaper.Main_OnCommand(40297,0) end --deselect all tracks
  end
  runcommand("_Ultraschall_Unselect_All")
end

reaper.Undo_EndBlock("Ultraschall: mute (selected) Items in all (selected) tracks in time selection", 0)
