--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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
-- Ultraschall Helper Functions
-------------------------------------

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-------------------------------------
-- Set of Actions to Copy Items and Ripple Cut
-------------------------------------

function RippleCut()
  reaper.Main_OnCommand(40061, 0)            -- Split all Items at time selection
  reaper.Main_OnCommand(40717, 0)            -- Select all items in time selection
  reaper.Main_OnCommand(41383, 0)            -- Copy all items within time selection to clipboard
  reaper.Main_OnCommand(40201, 0)            -- Ripple cut Selection
  reaper.Main_OnCommand(40289, 0)            -- Unselect all Items 
end

function AddMuteEnvelopePoint_IfNecessary(startsel, endsel)
  for i=1, reaper.CountTracks(0) do
    Track=reaper.GetTrack(0,i-1)
    Envelope=reaper.GetTrackEnvelopeByName(Track, "Mute")
    retval, envIDX, envVal = ultraschall.IsMuteAtPosition(i, endsel)
    
    if retval==false and Envelope~=nil then
      envIDX, envVal, envPosition = ultraschall.GetPreviousMuteState(i, endsel)
      reaper.InsertEnvelopePoint(Envelope, endsel, envVal, 1, 0, false, false)
    end
  end
end

playstate=reaper.GetPlayState()
if playstate&4==4 then return end -- quit if recording

init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)  -- get information wether or not a time selection is set
cursorpos=reaper.GetCursorPosition() --get edit cursor position
playpos=reaper.GetPlayPosition() --get play position
follow_actionnumber = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
followon_actionnumber= reaper.NamedCommandLookup("_Ultraschall_Turn_On_Followmode")
followstate=reaper.GetToggleCommandState(follow_actionnumber)

-------------------------------------
reaper.Undo_BeginBlock() -- Beginning of the undo block. Leave it at the top of your main function.
-------------------------------------

if init_end_timesel == init_start_timesel and reaper.CountSelectedMediaItems(0) == 1 then  -- exacty one item selected and no time selection
  runcommand("_SWS_SAFETIMESEL")            -- Set time selection to item borders
  init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)  -- get information wether or not a time selection is set
end

if (init_end_timesel ~= init_start_timesel) then    -- there is a time selection
  AddMuteEnvelopePoint_IfNecessary(init_start_timesel, init_end_timesel)
  RippleCut()
  if (playstate==0 or playstate&2==2) then -- pause/stop -> move to start of selection
    reaper.MoveEditCursor(init_start_timesel-reaper.GetCursorPosition(), 0)
  else
    if (playpos>=init_start_timesel and playpos <init_end_timesel) then -- playpos is inside the selection -> jump to start of selection (we have o use pause/setpos/play)
      reaper.OnPauseButton() --pause
      reaper.MoveEditCursor(init_start_timesel-reaper.GetPlayPosition(), 0)
      reaper.OnPlayButton() --play
    elseif (playpos>init_end_timesel) then -- if playpos is right from selection move cursor to the left to keep relative playpos
      reaper.OnPauseButton() --pause
      reaper.MoveEditCursor(-(init_end_timesel-init_start_timesel), 0)
      reaper.OnPlayButton() --play
    end
    
    if followstate==1 then -- reactivate followmode if it was on before
      ultraschall.pause_follow_one_cycle()
      reaper.Main_OnCommand(followon_actionnumber,0)
    end
  end
else                           -- no time selection or items selected
   result = reaper.ShowMessageBox( "You need to make a time selection or to select a single item to ripple-cut.", "Ultraschall Ripple Cut", 0 )  -- Info window
end


-------------------------------------
reaper.Undo_EndBlock("Ultraschall Ripple Cut", -1) -- End of the undo block. Leave it at the bottom of your main function.
-------------------------------------
