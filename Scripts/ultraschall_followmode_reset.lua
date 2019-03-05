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

-- AutoFollowOff v4 - 23.02.2019
-- Meo Mespotine

wait_seconds=0.1                    -- recommended 0.1; how long to wait inbetween two checks. In seconds.
midarrangeview_followoff_offset=1   -- recommended 1; how far above the center of the arrangeview can the playcursor
                                    --                move, before follow toggles off. In percentages.
maxstrike=10                        -- recommended 10; how many cycles can the arrangeview stop, until we stop followmode
                                    --                 the bigger, the longer the stopping time. Don't choose too small
                                    --                 as this affects users scrolling by hand using the timeline!

-- prepare variables
startTime, endTime = reaper.BR_GetArrangeView(0)
oldstartTime, oldendTime = reaper.BR_GetArrangeView(0)
oldCursorPosition=reaper.GetCursorPosition()
oldplayposition=-100
strike=0

midarrangeview_followoff_offset=midarrangeview_followoff_offset/10

-- get commandids
id=reaper.NamedCommandLookup("_Ultraschall_Turn_Off_Followmode")
follow_toggle_id=reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
B=reaper.GetToggleCommandState(follow_toggle_id)

function waiter()
  -- the waiter-function, that defers in idle-time
  if current_time+wait_seconds>reaper.time_precise() then
    reaper.defer(waiter)
  else
    reaper.defer(main)
  end
end

function main()
    -- here is, where the magic happens.
    
    -- check only, when Playstate isn't stopped or paused and followmode is on
    if reaper.GetPlayState()~=0  
       and reaper.GetPlayState()&2~=2  -- comment, if you want to trigger AutoFollowOff during pause
       and reaper.GetExtState("follow", "skip")~="true" -- buggy line?
       and reaper.GetToggleCommandState(follow_toggle_id)==1
    then
      startTime, endTime = reaper.BR_GetArrangeView(0)
  
      -- check, if arrangeview is still moving and if not, wait a certain time(count strike up)  
      -- the strikercount starts, when playcursor is more than 51% of the arrangeview, which is past
      -- the time, where the autoscrolling reactivates automatically(in most cases)  
      if oldstartTime<startTime and oldendTime<endTime then
        A="yes"
        strike=0
      elseif reaper.GetPlayPosition()<((endTime-startTime)*0.5+midarrangeview_followoff_offset)+startTime then
        A="yes"
        strike=0
      elseif oldstartTime==startTime and oldendTime==endTime then
        A="no"
        strike=strike+1
      end
      
      if oldCursorPosition~=reaper.GetCursorPosition()then
        -- if editcursor moves, stop followmode
        strike=maxstrike
      end
      
      if reaper.GetPlayPosition()<startTime or reaper.GetPlayPosition()>endTime then
        -- if playcursor is out of arrangeview, stop followmode
        strike=maxstrike
      end
      
      if oldplayposition>reaper.GetPlayPosition()+2 or oldplayposition<reaper.GetPlayPosition()-2 and reaper.GetPlayPosition()==reaper.GetCursorPosition() then
      -- if playcursor moves to a position, where the editcursor is already
      -- (like clicked on markers, where the editcursor is, which starts playback and stops scrolling)
      
      -- possibly buggy but needed, if editcursor is already at a marker-position, and the user clicks on the marker again
      -- which restarts playback
      -- but this triggers also, when I try to skip the checks for one cycle...
        strike=maxstrike
      end
      
      -- store current states for comparisons in next cycle
      oldplayposition=reaper.GetPlayPosition()
      oldCursorPosition=reaper.GetCursorPosition()
      oldstartTime, oldendTime = startTime, endTime
      
      -- if the waiting-cycles for a paused arrangeviewscrolling has reached the maximum,
      -- stop followmode
      if strike<maxstrike then
      else
        reaper.Main_OnCommand(id,0)
      end
    else
      -- if nothing shall be checked, update statevariables for a possible check in the next cycle
      oldplayposition=reaper.GetPlayPosition()
      oldCursorPosition=reaper.GetCursorPosition()
      reaper.SetExtState("follow", "skip", "false", false) --reset skip-state      -- buggy line?
    end
  current_time=reaper.time_precise()
  reaper.defer(waiter)
end

main()
