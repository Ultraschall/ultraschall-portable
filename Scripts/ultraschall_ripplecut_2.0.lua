--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


function AddMuteEnvelopePoint_IfNecessary(startsel)
  for i=1, reaper.CountTracks(0) do
    Track=reaper.GetTrack(0,i-1)
    Envelope=reaper.GetTrackEnvelopeByName(Track, "Mute")
    retval, envIDX, envVal = ultraschall.IsMuteAtPosition(i, startsel)

    if retval==false and Envelope~=nil then
      envIDX, envVal, envPosition = ultraschall.GetPreviousMuteState(i, startsel)
      if envIDX~=-1 then reaper.InsertEnvelopePoint(Envelope, startsel, envVal, 1, 0, false, false) end
    end
  end
end


--AddMuteEnvelopePoint_IfNecessary(10, 11)

--if lol==nil then return end

playstate=reaper.GetPlayState()
playpos=reaper.GetPlayPosition()
if playstate&4==4 then return end -- quit if recording
init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(false, 0, 0, 0, 0)
preroll = tonumber(ultraschall.GetUSExternalState("ultraschall_settings_preroll", "value","ultraschall-settings.ini"))
review_toggle = ultraschall.GetUSExternalState("ultraschall_settings_ripplecut", "review_edit_toggle","ultraschall-settings.ini")
obey_locked = ultraschall.GetUSExternalState("ultraschall_settings_ripplecut", "obey_locked_toggle","ultraschall-settings.ini")
obey_crossfade = ultraschall.GetUSExternalState("ultraschall_settings_ripplecut", "obey_crossfade_toggle","ultraschall-settings.ini")
if obey_crossfade~="true" then obey_crossfade=false else obey_crossfade=true end
ar_start, ar_end = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)


-------------------------------------
reaper.Undo_BeginBlock() -- Beginning of the undo block. Leave it at the top of your main function.
-------------------------------------

reaper.PreventUIRefresh(1)

if (init_end_timesel ~= init_start_timesel) then    -- there is a time selection
  if obey_locked~="true" then
    unlocked_trackstring = ultraschall.CreateTrackString_AllTracks()
  else
    locked_trackstring, unlocked_trackstring = ultraschall.GetAllLockedTracks()
  end
  -- Ripple Cut
  number_items, MediaItemStateChunkArray = ultraschall.RippleCut(init_start_timesel, 
                                                                 init_end_timesel, 
                                                                 unlocked_trackstring, 
                                                                 true, -- moveenvelopepoints, 
                                                                 true, -- add_to_clipboard, 
                                                                 true, -- movemarkers, 
                                                                 obey_crossfade)-- obey_crossfade)
  AddMuteEnvelopePoint_IfNecessary(init_start_timesel, init_end_timesel)
  -- Store Outtakes
  
  -- get old maximum outtake-items and endposition of future outtake-project
  retval, old_max_items=reaper.GetProjExtState(0, "ultraschall_outtakes", "max_items")
  old_max_items=tonumber(old_max_items)
  if old_max_items==nil then old_max_items=0 end
  
  retval, old_max_position=reaper.GetProjExtState(0, "ultraschall_outtakes", "max_position")
  old_max_position=tonumber(old_max_position)
  if old_max_position==nil then old_max_position=0 end
  
  -- get the maximum/minimum time of the outtakes
  minimum_time=reaper.GetProjectLength(0)
  maximum_time=0
  for i=1, #MediaItemStateChunkArray do
    position = ultraschall.GetItemPosition(nil, MediaItemStateChunkArray[i])
    length = ultraschall.GetItemLength(nil, MediaItemStateChunkArray[i])
    endposition=position+length
    if position<minimum_time then minimum_time=position end
    if endposition>maximum_time then maximum_time=endposition end
  end
  
  -- move position of outtakes to useful final position in future outtake-project
  for i=1, #MediaItemStateChunkArray do
    position = ultraschall.GetItemPosition(nil, MediaItemStateChunkArray[i])
    MediaItemStateChunkArray[i] = ultraschall.SetItemPosition(nil, ((position-minimum_time)+old_max_position), MediaItemStateChunkArray[i])
  end
  
  -- store the outtakes into projextstates
  reaper.SetProjExtState(0, "ultraschall_outtakes", "max_items",  old_max_items+#MediaItemStateChunkArray)
  reaper.SetProjExtState(0, "ultraschall_outtakes", "max_position", old_max_position+(maximum_time-minimum_time))
  
  for i=1, #MediaItemStateChunkArray do
    reaper.SetProjExtState(0, "ultraschall_outtakes", "item_nr_"..(old_max_items+i), MediaItemStateChunkArray[i])
  end                                                                  
  
  if (playstate==0 or playstate&2==2) then -- pause/stop -> move to start of selection
    reaper.MoveEditCursor(init_start_timesel-reaper.GetCursorPosition(), 0)
  else
    if (playpos>=init_start_timesel and playpos<init_end_timesel) then -- playpos is inside the selection -> jump to start of selection (we have o use pause/setpos/play)
      reaper.OnPauseButton() --pause
      if review_toggle~="true" then
        reaper.MoveEditCursor(init_start_timesel-reaper.GetPlayPosition(), 0)
      else
        reaper.MoveEditCursor(init_start_timesel-reaper.GetPlayPosition()-preroll, 0)
      end
      reaper.OnPlayButton() --play
      
    elseif (playpos>init_end_timesel) then -- if playpos is right from selection move cursor to the left to keep relative playpos
      reaper.OnPauseButton() --pause
      if review_toggle~="true" then
        reaper.MoveEditCursor(-(init_end_timesel-init_start_timesel), 0)
      else
        reaper.MoveEditCursor(-(reaper.GetProjectLength(0)), 0)
        reaper.MoveEditCursor(init_start_timesel-preroll, 0)
      end
      reaper.OnPlayButton() --play
    elseif (playpos<init_start_timesel) then
      if review_toggle=="true" then
        reaper.OnPauseButton() --pause
        reaper.MoveEditCursor(-(reaper.GetProjectLength(0)), 0)
        reaper.MoveEditCursor(init_start_timesel-preroll, 0)
        reaper.OnPlayButton() --play
      end
    end

    if followstate==1 then -- reactivate followmode if it was on before
      ultraschall.pause_follow_one_cycle()
      reaper.Main_OnCommand(followon_actionnumber,0)
    end 
  end
else                           -- no time selection or items selected
   result = reaper.ShowMessageBox( "You need to make a time selection to ripple-cut.", "Ultraschall Ripple Cut", 0 )  -- Info window
end
reaper.GetSet_LoopTimeRange(true, 0, 0, 0, 0)

if reaper.GetToggleCommandState(reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow"))==0 then
  reaper.GetSet_ArrangeView2(0, true, 0, 0, ar_start, ar_end)
end
reaper.PreventUIRefresh(-1)

reaper.Undo_EndBlock("Ultraschall Ripple Cut", -1) -- End of the undo block. Leave it at the bottom of your main function.

reaper.UpdateArrange()
