--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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

function dbg(text)
    debug=true
    if debug then reaper.ShowConsoleMsg(tostring(text).."\n") end
end

function get_last_timecode()
    -- get last timecode of whole project (is there an easier way???)
    last_tc=0
    for t=1, reaper.GetNumTracks(),1 do
        Track= reaper.GetTrack(0,t-1) --get track
        if reaper.GetTrackNumMediaItems(Track)>0 then
            mediaitem=reaper.GetTrackMediaItem(Track, reaper.GetTrackNumMediaItems(Track)-1) -- get last item
            in_point=reaper.GetMediaItemInfo_Value(mediaitem, "D_POSITION")
            out_point=in_point + reaper.GetMediaItemInfo_Value(mediaitem, "D_LENGTH")
            if out_point>last_tc then last_tc=out_point end
        end
    end
    return last_tc
end

function runloop()
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context() --get MIDI Value

  if val<0 then stop=true end -- script was not started with a midi command
  if math.abs(val-64)<5 then stop=true end -- middle position
  in_pos, out_pos = reaper.GetSet_LoopTimeRange(0,0,0,0,0) --get start and end point
  if in_pos==0 and val<64 then stop=true end -- start of timeline
  last_tc=get_last_timecode()
  if val>68 then if in_pos>=last_tc then stop=true end end -- end of timeline

  -- calculate offset
  exp=2.4
  if val<64 then absval=math.abs(val-64) else absval=val-63 end
  in_offset=(absval^exp)/(64^exp)
  if val<64 then in_offset=in_offset*-1 end

  --set new in point
  in_pos=in_pos+in_offset
  if in_pos<=0 then in_pos=0 end
  if in_pos>=last_tc then in_pos=last_tc end
  retval, retval2 = reaper.GetSet_LoopTimeRange(1,0,in_pos,out_pos,0)
  if stop~=true then reaper.defer(runloop) end
end

function onexit()
  --cleanup
end

reaper.atexit(onexit)
reaper.defer(runloop)
