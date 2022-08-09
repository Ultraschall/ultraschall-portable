--[[
################################################################################
# 
# Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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

-- this monitors the execution-times of the event-functions in the eventmanager
-- as well as the times inbetween two event-function-check-cycles(when their actions are usually run)
-- written by Meo-Ada Mespotine 9.8.2022 - licensed under MIT-license


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

watch_numseconds=5

print("")
reascript_console_hwnd = ultraschall.GetReaScriptConsoleWindow()

A=ultraschall.EventManager_DebugMode(true)
Peak1=0
Peak2=0
Average1={}
Average2={}
for i=1, 33*watch_numseconds do Average1[i]=0 end
for i=1, 33*watch_numseconds do Average2[i]=0 end

function main()

  -- reset maxpeak, when refocusing the console-window
  -- idea: can this be used to "switch" between different modes? Like
  --       monitor performance
  --       display registered events
  -- or what about "doubleclick the event-number to highlight it and I'll display the event-attributes for you"?
  --  for this, I need to check, which number has been clicked on and update the display...
  --  means, I can add a text called "next page" in the first line and if the selected text is next page, then 
  --  switch to another view.
  --  question however is: how to get the selected text of a textwindow? Is it possible using JS-extension?
  focus=reaper.JS_Window_GetFocus()
  if oldfocus~=focus then 
    if oldfocus~=reascript_console_hwnd and 
      reaper.JS_Window_GetParent(focus)==reascript_console_hwnd then
      Peak1=0
      Peak2=0
    end
  end
  oldfocus=focus
  B,C=ultraschall.EventManager_Debug_GetExecutionTime(true)
  if B==-1 then B=0 C=0 end
  if B==nil then B=0 end
  if C==nil then C=0 end
  Average1[#Average1+1]=B
  Average2[#Average2+1]=C
  table.remove(Average1, 1)
  table.remove(Average2, 1)
  if B>Peak1 then Peak1=B end
  if C>Peak2 then Peak2=C end

  Average=0
  for i=1, 33*watch_numseconds do Average=Average+Average1[i] end
  Average=Average/(33*watch_numseconds)
  
  Average_between=0
  for i=1, 33*watch_numseconds do Average_between=Average_between+Average2[i] end
  Average_between=Average_between/(33*watch_numseconds)
  
  Peak3=0
  for i=1, 33*watch_numseconds do if Peak3<Average1[i] then Peak3=Average1[i] end end
  Peak4=0
  for i=1, 33*watch_numseconds do if Peak4<Average2[i] then Peak4=Average2[i] end end  
  
  B1=string.format("%.8f", B)
  C1=string.format("%.8f", C)
  P1=string.format("%.8f", Peak1)
  P2=string.format("%.8f", Peak2)
  A1=string.format("%.8f", Average)
  A2=string.format("%.8f", Average_between)
  P3=string.format("%.8f", Peak3)
  P4=string.format("%.8f", Peak4)
  
  RunActions=ultraschall.EventManager_Debug_GetAllActionRunStates()
  
  EventIdentifier=ultraschall.EventManager_GetAllEventIdentifier()
  EventNames=ultraschall.EventManager_GetAllEventNames()
  EventPauseState={}
  for i=1, #EventNames do
    EventPauseState[i]=ultraschall.EventManager_GetEventPausedState(i)
  end
  
  ActionRun=""
  for i=1, #EventNames do
    ActionRun=ActionRun..i..": "..tostring(RunActions[i]).." \""..EventIdentifier[i].."\" "..EventNames[i].."\n"
  end
  
  print_update("Monitoring Eventmanager:",
               "To reset overall peak, (re)-focus console-window.",
               "",
               "The time the eventcheck functions need(seconds), should be below 0.03.",
               "  "..B1.." seconds for all eventchecks",
               "  "..P1.." overall peak",
               "  "..A1.." average for the last "..watch_numseconds.." seconds",
               "  "..P3.." maximum peak within last "..watch_numseconds.. " seconds",
               "",
               "Time inbetween eventcheck-cycles in seconds, usually when the event-actions are run. Should be below 0.08.",
               "  "..C1.." seconds between two runthroughs",
               "  "..P2.." overall peak in seconds",
               "  "..A2.." average for the last "..watch_numseconds.." seconds",
               "  "..P4.." maximum peak within last "..watch_numseconds.. " seconds",
               "",
               "",
               "The following event-actions were run in last check:",
               ActionRun)

  reaper.defer(main)
end

main()


function atexit()
  ultraschall.EventManager_DebugMode(false)
end

reaper.atexit(atexit)

SLEM()

