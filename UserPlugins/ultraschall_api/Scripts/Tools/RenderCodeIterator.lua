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
