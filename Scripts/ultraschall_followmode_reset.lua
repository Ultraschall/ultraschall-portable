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


-- Resets the Followmode, when someone moves the editcursor or when the playcursor leaves
-- the arrange-view
-- If you want to signal this script to skip one check-cycle, set external state
--    "follow" -> "skip" to "true"
-- in cases, where auto-follow-off reacts without your consent.
-- You must set this external state before(!) taking the action, that triggers the
-- auto-follow-off, or this script might keep on causing you the trouble...


factor=0.5 -- how long to wait inbetween checks, in seconds.

--Initialize variables
internal_skip=false
recognized=false
waittime=reaper.time_precise()+factor 
timeframe=0.5
editcursor=reaper.GetCursorPosition()
start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
integer = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
follow_on_id = reaper.NamedCommandLookup("_Ultraschall_Turn_On_Followmode")
follow_off_id = reaper.NamedCommandLookup("_Ultraschall_Turn_Off_Followmode")
start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
old_starttime, old_endtime= reaper.GetSet_ArrangeView2(0, false, 0, 0)
rec_timeframe=0
env=reaper.GetSelectedEnvelope()
oldpoints=-1
if env==nil then oldpoints="-1"
else
  tempo, oldpoints=reaper.GetEnvelopeStateChunk(env,"",false)
end
if oldpoints==nil then oldpoints=-1 end

function main()
--  if reaper.GetExtState("follow", "recognized")=="false" then recognized=false reaper.SetExtState("follow", "recognized", "true", false) end
  start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
  timeframe2=(end_time-start_time)/8
  if timeframe2>0.5 then timeframe2=0.5 end
  if reaper.GetPlayState()&4==4 then rec_timeframe=1 else rec_timeframe=0 end
  if waittime<reaper.time_precise() and reaper.GetToggleCommandState(integer)==1 then
    --wait until waittime has been reached; after that execute the following lines
    
    if reaper.GetHZoomLevel()>1500 then
      -- with high zoom-levels, we need more recheck-cycles
      -- or changing the editcursor might not be recognized
      factor2=0.0000000001
      timeframe=0.5--20/reaper.GetHZoomLevel()
    else
      factor2=factor
      timeframe=0.5
    end
    
     --if followmode is on, play and rec 
    if reaper.GetPlayState()~=0 and 
    reaper.GetPlayState()&2~=2 and  -- comment, if you want to trigger AutoFollowOff during pause
    reaper.GetExtState("follow", "skip")~="true" then

     -- check, if editcursor has been moved    
      window, segment, details = reaper.BR_GetMouseCursorContext()
      if reaper.GetCursorPosition()~=editcursor and window~="ruler" then
        reaper.Main_OnCommand(integer,0)
        editcursor=reaper.GetCursorPosition()
      end
      
     -- check, if playcursor is outside of view
      start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0)
      if reaper.GetPlayPosition()<start_time-timeframe or reaper.GetPlayPosition()>end_time+rec_timeframe then   
        reaper.Main_OnCommand(integer,0)  
      end
      
      if end_time<=old_starttime then
      -- reaper.ShowConsoleMsg("flip links\n")
      -- reaper.Main_OnCommand(integer,0)  
      end

      -- hacky workaround for envelopes. if anything is changed in envelopes, follow will be turned off
      window, segment, details = reaper.BR_GetMouseCursorContext()
      if env~=nil then
        tempo, temppoints=reaper.GetEnvelopeStateChunk(env,"",false)
      else
        temppoints="-1"
      end
      if env~=reaper.GetSelectedEnvelope() and window=="arrange" and segment=="envelope" then
        -- if selected envelope has changed and mouse is inside the envelope-lane of arrange-view,
        -- turn off followmode
        reaper.Main_OnCommand(integer,0)
        env=reaper.GetSelectedEnvelope()
        if env~=nil then
          tempo, oldpoints=reaper.GetEnvelopeStateChunk(env,"",false) --reaper.CountEnvelopePoints(env)
        else
          oldpoints="-1"
        end
      elseif env==reaper.GetSelectedEnvelope() and oldpoints~=temppoints then --reaper.CountEnvelopePoints(env) then
        -- if anything within the envelope-lane (points, values, number of points) has changed,
        -- turn off followmode
        reaper.Main_OnCommand(integer,0)
        oldpoints=temppoints--reaper.CountEnvelopePoints(env)
        if oldpoints==nil then oldpoints=-1 end        
      end


    else
      editcursor=reaper.GetCursorPosition()
    end  
    
        
    reaper.SetExtState("follow", "skip", "false", false) --reset skip-state
    waittime=reaper.time_precise()+factor2
    editcursor=reaper.GetCursorPosition()
    if env~=nil then 
      tempo, temppoints=reaper.GetEnvelopeStateChunk(env,"",false)
      tempo, oldpoints=reaper.GetEnvelopeStateChunk(env,"",false)
    else
      temppoints="-1"
      oldpoints="-1"
    end
  end
  reaper.defer(main)
end

main()
