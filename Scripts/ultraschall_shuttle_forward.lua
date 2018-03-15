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

function incr_pbrate(n) -- increase rate ~6% n times
    n=math.min(n,200) -- limit n to 200
    for i=1, n, 1 do
      reaper.Main_OnCommand(40522, 0) -- incr playrate by ~6%
    end  
end

function is_playing_reverse()
    retval,value=reaper.GetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle")  --check if reverse playing
    if not tonumber(value) then value="0" end
    if value=="1" then
        return 1
    elseif value=="2" then
        return 2
    else
        return 0
    end
end

function stop_reverse_loop()
    reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 3) -- store state in datastore, no reverse play
end

function init_function()
    reaper.Undo_BeginBlock()
    if is_playing_reverse()>0 then stop_reverse_loop() return 5 end
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits

    if playstate==1 then -- reaper is playing
        playrate=reaper.Master_GetPlayRate(0) -- read playrate
        if playrate<1 then reaper.CSurf_OnPlayRateChange(1.0) end --  if rate<1 set playrate=1
        if math.floor(playrate+0.5)==1 then reaper.CSurf_OnPlayRateChange(2.0) end --  if rate is 1x incr to 2x
        if math.floor(playrate+0.5)==2 then reaper.CSurf_OnPlayRateChange(3.0)  end --  if rate is 2x incr. to ~3x
        if math.floor(playrate+0.5)==3 then reaper.CSurf_OnPlayRateChange(3.9685) reaper.defer(incr_pbrate(4)) end --  if rate is 3x incr. to ~5x
        if math.floor(playrate+0.5)==5 then reaper.CSurf_OnPlayRateChange(4.0) reaper.defer(incr_pbrate(120)) end --  if rate is 5x incr. to ~8x
    elseif playstate==0 or playstate==2 then -- reaper ist paused or stopped
        reaper.CSurf_OnPlayRateChange(1.0)
        reaper.Main_OnCommand(1007,0) -- play
    end
    reaper.Undo_EndBlock("Ultraschall Shuttle FWD", -1)
    return 1
end

function runloop()
    playstate=reaper.GetPlayState()
    
    if playstate & 1==1 then -- if playing restart loop
        reaper.defer(runloop)
    end
    
    if playstate==0 or playstate & 2 ==2 then -- STOP/PAUSE -> change playrate to 1 and reset all undo points
        if reaper.GetPlayPosition()+0.3 >=reaper.GetProjectLength(0) then
            reaper.Main_OnCommand(40043,0) -- Transport: Go to end of project
        end 
        reaper.CSurf_OnPlayRateChange(1)
        undo_done=0
        while reaper.Undo_CanUndo2(0)=="Ultraschall Shuttle FWD" or reaper.Undo_CanUndo2(0)=="Playrate Change" do
            reaper.Undo_DoUndo2(0)
        end
    end
end

if init_function()==1 then --if rev=1 run loop, else just leave (ending loop)
    reaper.defer(runloop) -- run without generating an undo point
end
