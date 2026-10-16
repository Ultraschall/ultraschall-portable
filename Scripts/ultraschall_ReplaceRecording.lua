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

-- settings to influence replace recording

-- 1=play a preview of the time-selection to be recorded; 0/"", record straight away
preview_first=tonumber(ultraschall.GetUSExternalState("ultraschall_settings_replace_recording_preview", "Value", "ultraschall-settings.ini"))
if preview_first==nil then preview_first=1 end

-- how long in seconds shall the wait be between preview and actual recording
rec_wait=tonumber(ultraschall.GetUSExternalState("ultraschall_settings_replace_recording-rec_wait", "Value", "ultraschall-settings.ini"))
if rec_wait==nil then rec_wait=99 else rec_wait=rec_wait*33 end

-- how much "trail" shall the playback of the actual recording have to be able to determine, whether recording was successful(in seconds)?
playback_at_end=tonumber(ultraschall.GetUSExternalState("ultraschall_settings_replace_recording-playback_at_end", "Value", "ultraschall-settings.ini"))
if playback_at_end==nil then playback_at_end=2 end

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

-- skips "Prepare all tracks for editing" and "Record only at the end"-soundchecks
reaper.SetExtState("Soundcheck_PrepareAllTracksForEditing", "skip", "1", false)
reaper.SetExtState("SoundCheck_EndOfRecording", "skip", "true", false)


-- check(and set) tape mode and punch in recording
cursorpos=reaper.GetCursorPosition()
oldval=reaper.SNM_GetIntConfigVar("autoxfade", -1) 
oldval2=reaper.SNM_GetIntConfigVar("projrecmode", -1) 
if oldval&4==0 then reaper.Main_OnCommand(41186, 0) end
if reaper.GetToggleCommandState(40076)==0 then reaper.Main_OnCommand(40076, 1) end


function main4()
  -- record, until end of time-selection and playback x-seconds after end of time-selection(determined by settings)
  if reaper.GetPlayState()&4==4 and reaper.GetPlayPosition()<=l_end+playback_at_end then reaper.defer(main4) else reaper.CSurf_OnStop() end
end

function atexit()
  -- reset stuff after recording finished
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+cursorpos, false)
  reaper.SNM_SetIntConfigVar("autoxfade", oldval)
  reaper.SNM_SetIntConfigVar("projrecmode", oldval2)
  reaper.ThemeLayout_RefreshAll()
  if turn_off_magicrouting==true then
    reaper.Main_OnCommand(cmdid, 0)
  end

  -- restarts "Prepare all tracks for editing" and "Record only at the end"-soundchecks, if active
  reaper.SetExtState("Soundcheck_PrepareAllTracksForEditing", "skip", "", false)
  reaper.SetExtState("SoundCheck_EndOfRecording", "skip", "", false)
end

function main3()
  -- start recording
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+cursorpos, false)
  reaper.CSurf_OnRecord()
  main4()
end

function WaitCounter()
  -- wait for x-seconds(determined by settings) until recording starts
  Counter=Counter-1
  local x,y=reaper.GetMousePosition()
  reaper.TrackCtl_SetToolTip("Recording start in "..(math.floor(Counter/33)+1).."s", x+10, y+10, true)
  if Counter>0 then reaper.defer(WaitCounter) else reaper.TrackCtl_SetToolTip("", x+10, y+10, true) main3() end
end

function main2()
  -- wait, until playback reaches end of time-selection, then go on further with waiting
  if reaper.GetPlayPosition()<l_end then if reaper.GetPlayState()~=0 then reaper.defer(main2) else return end else reaper.CSurf_OnStop() Counter=rec_wait WaitCounter() end
end

function main()
  -- start preview-playback
  reaper.CSurf_OnPlay()
  main2()
end

-- temporarily deactivate magic routing
cmdid=reaper.NamedCommandLookup("_Ultraschall_Toggle_Magicrouting")
if reaper.GetToggleCommandState(cmdid)==1 then
  reaper.Main_OnCommand(cmdid, 0)
  turn_off_magicrouting=true
end

if preview_first==1 then
  -- do preview before recording
  main()
else
  -- record straight away
  main3()
end
reaper.atexit(atexit)
