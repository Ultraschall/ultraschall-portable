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

-- notes:
--   in der reaper-kb.ini muss in der SRC Zeile für das Script statt "SRC 4" -> "SRC 520" stehen = new instance!!!!!!!
--   erreichbare Playbackspeeds:
--     mit reaper.CSurf_OnPlayRateChange(4.0) max=4 höhere Werte ändern nichts
--     mit dem mehrfachem Aufrufen von reaper.Main_OnCommand(40522, 0) kann man in ~6% erhöhen
--     CSurf_OnPlayRateChange(4.0) +  reaper.defer(incr_pbrate(12)) -> 8x

function incr_pbrate(n) -- increase rate ~6% n times
    n=math.min(n,200) -- limit n to 200
    for i=1, n, 1 do
      reaper.Main_OnCommand(40522, 0) -- incr playrate by ~6%
    end  
end

function playing_reverse_state()
    _ ,value=reaper.GetProjExtState(0, "ultraschall", "Reverse_Play_Shuttle")  --check if reverse playing
    -- 1 = rev play is active
    -- 2 = rev play pressed again -> increase speed
    -- 3 = fwd shutle play was pressed (fwd script) -> exit rev-background script and press play
    if not tonumber(value) then value="0" end

    -- only allow "1","2", and "3" else return 0
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

function stop_reverse_loop()
    reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 3) -- store state in datastore, no reverse play
end

function init_function()
    reaper.Undo_BeginBlock()
    if playing_reverse_state()>0 then stop_reverse_loop() return 0 end
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits

    if (playstate & 1) ==1 then -- reaper is playing
        playrate=reaper.Master_GetPlayRate(0) -- read playrate
        if playrate<1 then reaper.CSurf_OnPlayRateChange(1.0) --  if rate<1 set playrate=1
        elseif math.floor(playrate+0.5)==1  then reaper.CSurf_OnPlayRateChange(2.0) --  if rate is 1x incr to 2x
        elseif math.floor(playrate+0.5)==2  then reaper.CSurf_OnPlayRateChange(3.0) --  if rate is 2x incr. to ~3x
        elseif math.floor(playrate+0.5)==3  then reaper.CSurf_OnPlayRateChange(3.9685) reaper.defer(incr_pbrate(4)) --  if rate is 3x incr. to ~5x
        elseif math.floor(playrate+0.5)==5  then reaper.CSurf_OnPlayRateChange(4.0) reaper.defer(incr_pbrate(12)) --  if rate is 5x incr. to ~8x
        elseif math.floor(playrate+0.5)==8  then reaper.CSurf_OnPlayRateChange(3.9686) reaper.defer(incr_pbrate(28)) --  if rate is 8x incr. to ~20x
        elseif math.floor(playrate+0.5)==20 then reaper.CSurf_OnPlayRateChange(3.9686) reaper.defer(incr_pbrate(40)) --  if rate is 20x incr. to 40x
        elseif math.floor(playrate+0.5)==40 then reaper.CSurf_OnPlayRateChange(3.9375) reaper.defer(incr_pbrate(56)) --  if rate is 40x incr. to 100x
        end
    elseif playstate==0 or playstate & 2 ==2 then -- reaper ist paused or stopped
        reaper.CSurf_OnPlayRateChange(1.0) -- set playrate to 1
        reaper.Main_OnCommand(1007,0) -- play
    end
    reaper.Undo_EndBlock("Ultraschall Shuttle FWD", -1)
    return 1
end

function runloop()
    playstate=reaper.GetPlayState()
    if (playstate & 1)==1 then -- if playing move edit cursor and restart loop
        reaper.Main_OnCommand(40434,0) -- move edit to play cursor
        reaper.defer(runloop)
    end
    
    if playstate ==0 or (playstate & 2) ==2 then -- STOP/PAUSE -> change playrate to 1 and reset all undo points
        -- if the play cursor is near the end at high speed set it to end of project
        if (reaper.GetPlayPosition()+2 >=reaper.GetProjectLength(0) and reaper.Master_GetPlayRate(0) >=20) or (reaper.GetPlayPosition()+6 >=reaper.GetProjectLength(0) and reaper.Master_GetPlayRate(0) >=100) then
            reaper.Main_OnCommand(40043,0) -- Transport: Go to end of project
        end 
        reaper.CSurf_OnPlayRateChange(1)

        --remove all undopoints created by shuttle scripts
        while reaper.Undo_CanUndo2(0)=="Ultraschall Shuttle FWD" or reaper.Undo_CanUndo2(0)=="Playrate Change" do
            reaper.Undo_DoUndo2(0)
        end
    end
end

if init_function()==1 then --if playing run loop, else just leave (ending loop)
    reaper.defer(runloop) -- run without generating an undo point
end
