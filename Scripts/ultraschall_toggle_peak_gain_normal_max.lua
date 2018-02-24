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
 

-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

reaper.Undo_BeginBlock()
  use_three_steps=1 --if you just need 2 steps set to 0
  retval,value=reaper.GetProjExtState(0, "Ultraschall", "PeakGain")  --check if peakgain is full or normal
  
  if use_three_steps==1 then
    if value=="" then
          newvalue="half"    
          for i=1,23,1 do reaper.Main_OnCommand(40155, 0) end
    end
    
    if value=="half" then
          newvalue="full"
          for i=1,22,1 do reaper.Main_OnCommand(40155, 0) end
    end
        
    if value=="full" then
      newvalue=""
      for i=1,45,1 do reaper.Main_OnCommand(40156, 0) end
    end
    
  else
    if value=="" then
      newvalue="full"    
      for i=1,45,1 do reaper.Main_OnCommand(40155, 0) end
    end
    
    if value=="full" or value=="half" then
      newvalue=""
      for i=1,45,1 do reaper.Main_OnCommand(40156, 0) end
    end
  end  
  reaper.SetProjExtState(0, "Ultraschall", "PeakGain", newvalue)
reaper.Undo_EndBlock("Toggle Peakgain", 0)

