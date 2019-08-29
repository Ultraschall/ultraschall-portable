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

-- Meo Mespotine, 27th December 2018

-- stores the last playstate into the non-persistant extstate
-- "Ultraschall" -> "playstate_old" - the old playstate
-- "Ultraschall" -> "playstate_new" - the new playstate
-- "Ultraschall" -> "playstate_changetime" - the time the last change has happened
--
-- If you want to have event-based scripts, that trigger at certain changes from-to playstates.
-- That way, you can react to, e.g. Rec changes to Stop and such

playstate=reaper.GetPlayState()

is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
filename2=filename:match(".*/(.*)")
if filename2==nil then filename2=filename:match(".*\\(.*)") end
if filename2==nil then filename2=filename end

function StateConverter(state)
  if state==0 then return "STOP"
  elseif state==1 then return "PLAY"
  elseif state==2 then return "PLAYPAUSE"
  elseif state==5 then return "REC"
  elseif state==6 then return "RECPAUSE"
  end
end


reaper.SetExtState("ultraschall", "playstate_old", StateConverter(playstate), false)
reaper.SetExtState("ultraschall", "playstate_new", StateConverter(playstate), false)
reaper.SetExtState("ultraschall", "playstate_changetime", -1, false)
reaper.SetExtState("ultraschall", "defer_scripts_"..filename2, "true", false)

function main()
  if reaper.GetPlayState()~=playstate then
    reaper.SetExtState("ultraschall", "playstate_old", StateConverter(playstate), false)
    reaper.SetExtState("ultraschall", "playstate_new", StateConverter(reaper.GetPlayState()), false)
    reaper.SetExtState("ultraschall", "playstate_changetime", reaper.time_precise(), false)
    playstate=reaper.GetPlayState()
  end
  if reaper.GetExtState("ultraschall", "defer_scripts_"..filename2)~="false" then reaper.defer(main) end
end

function exit()
  reaper.DeleteExtState("ultraschall", "playstate_old", false)
  reaper.DeleteExtState("ultraschall", "playstate_new", false)
  reaper.DeleteExtState("ultraschall", "playstate_changetime", false)
  reaper.DeleteExtState("ultraschall", "defer_scripts_"..filename2, false)
end

reaper.atexit(exit)
main()
