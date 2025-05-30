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

function run()
  is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
  if is_new then
    -- reaper.ShowConsoleMsg(name .. "\nrel: " .. rel .. "\nres: " .. res .. "\nval = " .. val .. "\n")    debug
    if val == 1 then
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newstart = startOut + 0.05
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, newstart, endOut, true)
    else
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newstart = startOut - 0.05
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, newstart, endOut, true)
    end
  end
  -- reaper.defer(run)

end

-- debug

function onexit()
  reaper.ShowConsoleMsg("<-----\n")
end

reaper.defer(run)
-- reaper.atexit(onexit)
