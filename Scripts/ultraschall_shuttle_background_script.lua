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

function get_position()
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if playstate & 1 ==1 or playstate & 4==4 then
        return reaper.GetPlayPosition()
    else
        return reaper.GetCursorPosition()
    end
end

function is_playing_reverse()
    retval,value=reaper.GetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle")  --check if reverse playing
    if not tonumber(value) then value="0" end
    if value=="1" then
        return 1
    elseif value=="2" then
        return 2
    elseif value=="3" then
        return 3
    else
        return 0
    end
end

function check_position() --check if cursor is past the last edit, if so goto to lastedit -0.1 sec.
    start_position=get_position() --get cursor position
    if start_position>=reaper.GetProjectLength(0) then
        start_position=math.max(0,end_position-0.1)
    end
    reaper.MoveEditCursor(start_position-get_position(),0)
end

function init()
    ignoreonexit=0
    speed_list = {1,2,3,5,8,20,40,100}
    max_speed=#speed_list
    speed=1
    reaper.Main_OnCommand(40521, 0) -- set play speed to 1
    reaper.SetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle", 1) -- store state in datastore
    starttime=reaper.time_precise() --get actual time
    check_position()
    reaper.OnPlayButton()
end

function onexit()
    if ignoreonexit==0 then
        reaper.SetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle", 0) -- store state in datastore
        reaper.Main_OnCommand(40521, 0) -- set play speed to 1
        reaper.Main_OnCommand(1007,0) --play
        reaper.Main_OnCommand(1008,0) --pause
        reaper.Main_OnCommand(1016,0) --stop
    end
    
    while reaper.Undo_CanUndo2(0)=="Ultraschall Shuttle FWD" or reaper.Undo_CanUndo2(0)=="Playrate Change" or reaper.Undo_CanUndo2(0)=="Set project playspeed"do
      reaper.Undo_DoUndo2(0)
    end
    
end

function runloop() --BACKGROUND Loop
    playstate= reaper.GetPlayState()==1 or reaper.GetPlayState()==2
    if is_playing_reverse()==2 then --increase speed
        speed=math.min(speed+1, max_speed)
        starttime=reaper.time_precise() --get actual time after speedchange!
        reaper.SetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle", 1) -- store state in datastore
        start_position=get_position()
        reaper.Main_OnCommand(1008,0) --pause
    end

    if is_playing_reverse()==1 and playstate and reaper.GetCursorPosition()>0 then --reverse playing -> move cursor
        time_passed=(reaper.time_precise()-starttime) * speed_list[speed]
        reaper.MoveEditCursor(start_position-time_passed-reaper.GetCursorPosition(), 0)
        reaper.OnPlayButton()
        reaper.CSurf_OnPlayRateChange(1.0+speed_list[speed]/10000.0+0.00005)
        reaper.defer(runloop) -- restart loop
    end

    if is_playing_reverse()==3 then --play was pressed: stop reverse playing and play forward
        reaper.Main_OnCommand(40521, 0) -- set play speed to 1
        reaper.SetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle", 0) -- store state in datastore    
        reaper.Main_OnCommand(1008,0) --pause
        reaper.Main_OnCommand(1016,0) --stop
        reaper.OnPlayButton() --play
        ignoreonexit=1
    end
end

init()
reaper.atexit(onexit)
reaper.defer(runloop)


