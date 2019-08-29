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

-- Meo Mespotine, 12th February 2018

-- stores the last loopstate into the non-persistant extstate
-- "Ultraschall" -> "loopstate_old" - the old loopstate
-- "Ultraschall" -> "loopstate_new" - the new loopstate
-- "Ultraschall" -> "loopstate_changetime" - the time the last change has happened
--
-- If you want to have event-based scripts, that trigger at certain changes from-to loopstates.
-- That way, you can react to, e.g. loopbutton-changes

loopstate=reaper.GetToggleCommandState(1068)

is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
filename2=filename:match(".*/(.*)")
if filename2==nil then filename2=filename:match(".*\\(.*)") end
if filename2==nil then filename2=filename end

function StateConverter(state)
  if state==0 then return "UNLOOPED" else return "LOOPED" end
end

reaper.SetExtState("ultraschall", "loopstate_old", StateConverter(loopstate), false)
reaper.SetExtState("ultraschall", "loopstate_new", StateConverter(loopstate), false)
reaper.SetExtState("ultraschall", "loopstate_changetime", -1, false)
reaper.SetExtState("ultraschall", "defer_scripts_"..filename2, "true", false)




function main()
  if reaper.GetToggleCommandState(1068)~=loopstate then
    reaper.SetExtState("ultraschall", "loopstate_old", StateConverter(loopstate), false)
    reaper.SetExtState("ultraschall", "loopstate_new", StateConverter(reaper.GetToggleCommandState(1068)), false)
    reaper.SetExtState("ultraschall", "loopstate_changetime", reaper.time_precise(), false)
    loopstate=reaper.GetToggleCommandState(1068)
  end
  if reaper.GetExtState("ultraschall", "defer_scripts_"..filename2)~="false" then reaper.defer(main) end
end

function exit()
  reaper.DeleteExtState("ultraschall", "loopstate_old", false)
  reaper.DeleteExtState("ultraschall", "loopstate_new", false)
  reaper.DeleteExtState("ultraschall", "loopstate_changetime", false)
  reaper.DeleteExtState("ultraschall", "defer_scripts_"..filename2, false)
end

reaper.atexit(exit)
main()
