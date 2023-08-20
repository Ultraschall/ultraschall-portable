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
# s
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

function ultraschall.Scrubbing_GetToggleState()
  if reaper.SNM_GetIntConfigVar("scrubmode", -9)&1==0 then return false else return true end
end

function ultraschall.Scrubbing_Toggle(toggle)
  if type(toggle)~="boolean" then ultraschall.AddErrorMessage("Scrubbing_Toggle", "toggle", "must be boolean", -1) return false end
  return ultraschall.GetSetIntConfigVar("scrubmode", true, toggle)
end

function get_position()
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if (playstate & 1 ==1) or (playstate & 4==4) then
        return reaper.GetPlayPosition()
    else
        return reaper.GetCursorPosition()
    end
end

function playing_reverse_state()
    _ ,value=reaper.GetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle")  --check if reverse playing
    -- 1 = rev play is active
    -- 2 = rev play pressed again -> increase speed
    -- 3 = fwd shutle play was pressed (fwd script) -> exit rev-background script and press play
    if not tonumber(value) then value="0" end

    -- only allow "1","2", and "3" else return 0
    if value=="1" then return 1
    elseif value=="2" then return 2
    elseif value=="3" then return 3
    else return 0
    end
end

function check_position() --check if cursor is past the last edit, if so goto to lastedit -0.1 sec.
    start_position=get_position() --get cursor position
    end_position=reaper.GetProjectLength(0)
    if start_position>=end_position then
        start_position=math.max(0,end_position-0.1)
    end
    reaper.MoveEditCursor(start_position-get_position(),0)
end

function init()
    scrubstate=ultraschall.Scrubbing_GetToggleState()
    if (reaper.GetPlayState() & 4)==4 then return end --stop if recording!!
    A,B=ultraschall.Scrubbing_Toggle(true)
    ignoreonexit=false
    speed_list = {1,2,3,5,8,20,40,100}
    max_speed=#speed_list
    speed=1
    reaper.Main_OnCommand(40521, 0) -- set play speed to 1
    reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 1) -- store state in datastore
    starttime=reaper.time_precise() --get actual time
    check_position() -- move cursor if necessary
    reaper.Main_OnCommand(1016,0) --stop
    reaper.Main_OnCommand(1008,0) --pause    
end

function onexit()
    A,B=ultraschall.Scrubbing_Toggle(scrubstate)
    if ignoreonexit==false then
        reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 0) -- store state in datastore
        if (reaper.GetPlayState() & 4)==4 then return end --exit if recording!!
        reaper.Main_OnCommand(40521, 0) -- set play speed to 1
        reaper.Main_OnCommand(1016,0) --stop
    end
    if (reaper.GetPlayState() & 4)==4 then return end --exit if recording!!
    --remove all undopoints created by shuttle scripts
    while reaper.Undo_CanUndo2(0)=="Ultraschall Shuttle FWD" or reaper.Undo_CanUndo2(0)=="Playrate change" or reaper.Undo_CanUndo2(0)=="Set project playspeed"do
      reaper.Undo_DoUndo2(0)
    end
    
end

function runloop() --BACKGROUND Loop
    if (reaper.GetPlayState() & 4)==4 then return end --exit if recording!!
    if playing_reverse_state()==2 then --increase speed
        speed=math.min(speed+1, max_speed)
        starttime=reaper.time_precise() --get actual time after speedchange!
        reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 1) -- store state in datastore
        start_position=get_position()
    end

    if playing_reverse_state()==1 and ( (reaper.GetPlayState() & 1==1) or (reaper.GetPlayState() & 2==2) ) and reaper.GetCursorPosition()>0 then --reverse playing -> move cursor
        time_passed=(reaper.time_precise()-starttime) * speed_list[speed]
        reaper.MoveEditCursor(start_position-time_passed-reaper.GetCursorPosition(), 0)
        reaper.CSurf_OnPlayRateChange(1.0+speed_list[speed]/10000.0+0.00005) -- encode speed in Playratevalue 1x -> 1.0001, 100x -> 1.0100
        reaper.defer(runloop) -- restart loop
    end

    if playing_reverse_state()==3 then --fwd shuttle play was pressed: stop reverse playing and play forward
        reaper.Main_OnCommand(40521, 0) -- set play speed to 1
        reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 0) -- store state in datastore    
        reaper.Main_OnCommand(1016,0) --stop
        reaper.OnPlayButton() --play
        ignoreonexit=true
    end
end

init()
reaper.atexit(onexit)
reaper.defer(runloop)
