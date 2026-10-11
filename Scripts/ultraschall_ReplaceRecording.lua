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

-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


-- skips "Prepare all tracks for editing" and "Record only at the end"-soundchecks
reaper.SetExtState("Soundcheck_PrepareAllTracksForEditing", "skip", "1", false)
reaper.SetExtState("SoundCheck_EndOfRecording", "skip", "true", false)

--[[
soundcheck_recatend_id = ultraschall.GetUSExternalState("ultraschall_soundcheck_overdub", "EventIdentifier", "ultraschall-settings.ini")
soundcheck_prepare_all_tracks_id = ultraschall.GetUSExternalState("ultraschall_soundcheck_prepare_for_editing", "EventIdentifier", "ultraschall-settings.ini")
EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents2(soundcheck_recatend_id)
EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused2, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents2(soundcheck_prepare_all_tracks_id)
--ultraschall.EventManager_PauseEvent(soundcheck_recatend_id)
--]]

preview_first=toboolean(ultraschall.GetUSExternalState("", "", "ultraschall-settings.ini"))
if preview_first==nil then preview_first=true end

l_start, l_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if l_start==l_end then 
  reaper.MB("No time-selection!", "Problem...", 0)
  return 
end
if reaper.GetCursorPosition()>l_start+0.000000001 then
  reaper.MB("Editcursor must be placed before or at start of time-selection!", "Problem...", 0)
  return
end
if ultraschall.AnyTrackRecarmed()==false then
  reaper.MB("No track armed for recording!", "Problem...", 0)
  return
end
cursorpos=reaper.GetCursorPosition()

oldval=reaper.SNM_GetIntConfigVar("autoxfade", -1) 
oldval2=reaper.SNM_GetIntConfigVar("projrecmode", -1) 

if oldval&4==0 then reaper.Main_OnCommand(41186, 0) end
if reaper.GetToggleCommandState(40076)==0 then reaper.Main_OnCommand(40076, 1) end

--reaper.CSurf_OnRecord()

function main4()
  if reaper.GetPlayState()&4==4 and reaper.GetPlayPosition()<=l_end+2 then reaper.defer(main4) else reaper.CSurf_OnStop() end
end

function atexit()
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+cursorpos, false)
  reaper.SNM_SetIntConfigVar("autoxfade", oldval)
  reaper.SNM_SetIntConfigVar("projrecmode", oldval2)
  reaper.ThemeLayout_RefreshAll()
  if turn_off_magicrouting==true then
    reaper.Main_OnCommand(cmdid, 0)
  end
  if EventPaused==false then
    --ultraschall.EventManager_ResumeEvent(soundcheck_recatend_id)
  end
  if EventPaused2==false then
    --ultraschall.EventManager_ResumeEvent(soundcheck_prepare_all_tracks_id)
  end
  -- reignites "Prepare all tracks for editing" and "Record only at the end"-soundchecks
  reaper.SetExtState("Soundcheck_PrepareAllTracksForEditing", "skip", "", false)
  reaper.SetExtState("SoundCheck_EndOfRecording", "skip", "", false)
end

function main3()
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+cursorpos, false)
  reaper.CSurf_OnRecord()
  main4()
end

function WaitCounter()
  Counter=Counter-1
  local x,y=reaper.GetMousePosition()
  reaper.TrackCtl_SetToolTip("Recording start in "..(math.floor(Counter/33)+1).."s", x+10, y+10, true)
  if Counter>0 then reaper.defer(WaitCounter) else reaper.TrackCtl_SetToolTip("", x+10, y+10, true) main3() end
end

function main2()
  if reaper.GetPlayPosition()<l_end then if reaper.GetPlayState()~=0 then reaper.defer(main2) else return end else reaper.CSurf_OnStop() Counter=99 WaitCounter() end
end

function main()
  reaper.CSurf_OnPlay()
  main2()
end

cmdid=reaper.NamedCommandLookup("_Ultraschall_Toggle_Magicrouting")
if reaper.GetToggleCommandState(cmdid)==1 then
  reaper.Main_OnCommand(cmdid, 0)
  turn_off_magicrouting=true
end

if preview_first==true then
  main()
else
  main3()
end
reaper.atexit(atexit)
