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
  --]]

--reaper.DeleteExtState("us", "mousecount", true) reaper.DeleteExtState("us", "mousestart", true) tudelu=""
if tudelu==nil then 
  kbps=tonumber(reaper.GetExtState("us","mousecount"))
  if kbps==nil then reaper.SetExtState("us", "mousecount", 1, false) reaper.SetExtState("us", "mousestart", reaper.time_precise(), true) end
  
  Count=reaper.GetExtState("us", "mousecount")
  StartTimer=reaper.GetExtState("us", "mousestart")
  DiffTimer=reaper.time_precise()-StartTimer
  OneTimer=DiffTimer/Count
  
  RemainingTimer=OneTimer*(1024-Count)
--  EndTimer=StartTimer-OneTimer*(1024-Count)
--  EndTimer2=(EndTimer-OneTimer*Count)
  
  
--[[  Timer2=reaper.time_precise()
  Timer3=Timer2-Timer1
  
  OneTime=Timer3/Count
  EndTime=Timer1+(Timer3*(1024-Count))
  --]]
  
--  Buf = reaper.format_timestr(EndTime-Timer1, "")
  
  
  
  reaper.ClearConsole()
  reaper.ShowConsoleMsg("\n Durchgang: "..Count.." - Remaining time: ".. reaper.format_timestr(RemainingTimer, "").."\n\n")
  reaper.SetExtState("us", "mousecount", Count+1, false)
end
