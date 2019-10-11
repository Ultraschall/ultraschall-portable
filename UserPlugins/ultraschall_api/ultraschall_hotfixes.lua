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

-- This is the file for hotfixes of buggy functions.

-- If you have found buggy functions, you can submit fixes within here.
--      a) copy the function you found buggy into ultraschall_hotfixes.lua
--      b) debug the function IN HERE(!)
--      c) comment, what you've changed(this is for me to find out, what you did)
--      d) add information to the <US_DocBloc>-bloc of the function. So if the information in the
--         <US_DocBloc> isn't correct anymore after your changes, rewrite it to fit better with your fixes
--      e) add as an additional comment in the function your name and a link to something you do(the latter, if you want), 
--         so I can credit you and your contribution properly
--      f) submit the file as PullRequest via Github: https://github.com/Ultraschall/Ultraschall-Api-for-Reaper.git (preferred !)
--         or send it via lspmp3@yahoo.de(only if you can't do it otherwise!)
--
-- As soon as these functions are in here, they can be used the usual way through the API. They overwrite the older buggy-ones.
--
-- These fixes, once I merged them into the master-branch, will become part of the current version of the Ultraschall-API, 
-- until the next version will be released. The next version will has them in the proper places added.
-- That way, you can help making it more stable without being dependent on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="10_October_2019"

--ultraschall.ShowLastErrorMessage()

function ultraschall.EventManager_GetLastUpdateTime()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_GetLastUpdateTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string datetime, number precise_time = ultraschall.EventManager_GetLastUpdateTime()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last time, the eventlist in the EventManager had been updated in any way.
  </description>
  <retvals>
    string datetime - the date and time of the last update, as returned by os.date()
    number precise_time - the last update time as number, as returned by reaper.time_precise()
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, get, last update, time, date, time_precise, events</tags>
</US_DocBloc>
--]]
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  local A,B=States:match("Last update: (.-) %- (.-)\n")
  return A, tonumber(B)
end

function ultraschall.EventManager_DebugMode(toggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_DebugMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>ultraschall.EventManager_DebugMode(boolean toggle)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Starts Debugmode of the EventManager, which returns additional internal states.
    
    Allows you to get the last checkfunction-states, see [EventManager\_DebugMode\_LastCheckFunctionStates](#EventManager_DebugMode_LastCheckFunctionStates).
    
    Note: Debugmode is not for productive usecases, as it costs resources. Please turn it off again, after you've finished debugging.
  </description>
  <parameters>
    boolean toggle - true, turn debugmode on; false, turn debugmode off
  </parameters>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, toggle, debug, debugmode</tags>
</US_DocBloc>
--]]
  if toggle==true then toggle="doit" else toggle="stopit" end
  reaper.SetExtState("ultraschall_eventmanager", "debugmode", toggle, false)
end

function ultraschall.EventManager_DebugMode_LastCheckFunctionStates()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_DebugMode_LastCheckFunctionStates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer count_of_events, table checkstates = ultraschall.EventManager_DebugMode_LastCheckFunctionStates()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last checkstates of all checkfunctions currently registered with the EventManager.
    Needs Debugmode turned on. See [EventManager\_DebugMode](#EventManager_DebugMode).
    
    returns -1, if debugmode is off
  </description>
  <retvals>
    integer count_of_events - the number of events currently available
    table checkstates - a table with all true/false-checkstates of the last defer-cycle; if it contains anything else than true/false, then the checkfunction returns the wrong returnvalue -> Go fix it!
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, get, eventcheckfunction, checkstate, debug, debugmode</tags>
</US_DocBloc>
--]]
  local A=reaper.GetExtState("ultraschall_eventmanager", "checkstates")
  local Table={}
  local count=0
  for k in string.gmatch(A, "(.-)\n") do
    --print(A)
    count=count+1
    local a=k:match(".-: (.*)")
    Table[count]={toboolean(b)}
  end
  return count, Table
end

function ultraschall.EventManager_Start()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_Start</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>ultraschall.EventManager_Start()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Starts the Ultraschall-EventManager, if it has not been started yet.
  </description>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, start</tags>
</US_DocBloc>
--]]
  if reaper.HasExtState("ultraschall_eventmanager", "running")==false then
    local P=reaper.AddRemoveReaScript(true, 0, ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua", true)
    reaper.Main_OnCommand(P,0)
    local P=reaper.AddRemoveReaScript(false, 0, ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua", true)
  end
  local Registered=reaper.GetExtState("ultraschall_eventmanager", "registered_scripts")
  if Registered:match(ultraschall.ScriptIdentifier)==nil then
    Registered=Registered..ultraschall.ScriptIdentifier.."\n"
  end
  reaper.SetExtState("ultraschall_eventmanager", "registered_scripts", Registered, false)
end


function ultraschall.EventManager_GetPausedState2(EventIdentifier)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetPausedState2</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean paused_state = ultraschall.EventManager_GetPausedState2(string EventIdentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns, if a certain event, currently registered in the EventManager, is paused(true) or not(false).
      State is requested by EventIdentifier.
      
      returns nil in case of an error
    </description>
    <retval>
      boolean paused_state - true, event is currently paused; false, event isn't paused currently; nil, an error occured
    </retval>
    <parameters>
      string EventIdentifier - the identifier of the registered event, whose pause state you want to retrieve
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>eventmanager, get, paused, state, eventidentifier</tags>
  </US_DocBloc>
  ]]  
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_GetPausedState2", "EventIdentifier", "must be a string", -1) return end
  local isvalid, inuse = ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if isvalid==false then ultraschall.AddErrorMessage("EventManager_GetPausedState2", "EventIdentifier", "not a valid EventIdentifier", -2) return end
  if inuse==false then ultraschall.AddErrorMessage("EventManager_GetPausedState2", "EventIdentifier", "not a registered EventIdentifier", -3) return end
  EventIdentifier=string.gsub(EventIdentifier, "%-", "%%-")
  local A=reaper.GetExtState("ultraschall_eventmanager", "state")
  local B=A:match("Event #:.-EventIdentifier: "..EventIdentifier.."\n.-EventPaused: (.-)\n.-EndEvent")
  if B==nil then ultraschall.AddErrorMessage("EventManager_GetPausedState2", "EventIdentifier", "not a registered EventIdentifier", -4) return end
  return toboolean(B)
end


--OLOL=ultraschall.EventManager_GetPausedState2("Ultraschall_Eventidentifier: {7C1D6F4A-A745-4DBF-9428-B67DB3BDB953}")

function ultraschall.EventManager_GetPausedState(id)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetPausedState</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean paused_state = ultraschall.EventManager_GetPausedState(integer id)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns, is a certain event, currently registered in the EventManager, is paused(true) or not(false)
      State is requested by number-id, with 1 for the first event, 2 for the second, etc.
      
      returns nil in case of an error
    </description>
    <retval>
      boolean paused_state - true, event is currently paused; false, event isn't paused currently; nil, an error occured
    </retval>
    <parameters>
      integer id - the id of the event, whose paused-state you want to retrieve; 1, the first event; 2, the second event, etc
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>eventmanager, get, paused, state, id, count</tags>
  </US_DocBloc>
  ]]  
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_GetPausedState", "id", "must be an integer", -1) return end
  if id<1 then ultraschall.AddErrorMessage("EventManager_GetPausedState", "id", "must be greater than 0", -2) return end
  local A=reaper.GetExtState("ultraschall_eventmanager", "state")
  local count=0
  for k in string.gmatch(A, "Event #:.-EventPaused: (.-)\n.-EndEvent") do
    count=count+1
    if count==id then return toboolean(k) end
  end
  ultraschall.AddErrorMessage("EventManager_GetPausedState", "id", "no such event registered", -3)
end

--AA=ultraschall.EventManager_GetPausedState(5)

function ultraschall.EventManager_GetLastCheckfunctionState(id)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetLastCheckfunctionState</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean paused_state, number last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState(integer id)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the last state the eventcheck-function returned the last time it was called; of a certein registered event in the EventManager.
      State is requested by number-id, with 1 for the first event, 2 for the second, etc.
      
      returns nil in case of an error; nil and time, if the EventCheck-function didn't return a boolean
    </description>
    <retval>
      boolean paused_state - true, eventcheck-function returned true; false, eventcheck-function returned false; nil, an error occured
      number last_statechange_precise_time - the last time the state had been changed from true to false or false to true; the time is like the one returned by reaper.time_precise()
    </retval>
    <parameters>
      integer id - the id of the event, whose paused-state you want to retrieve; 1, the first event; 2, the second event, etc
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>eventmanager, get, eventcheck function, state, id, count</tags>
  </US_DocBloc>
  ]]  
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be an integer", -1) return end
  if id<1 then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be greater than 0", -2) return end
  if id>ultraschall.EventManager_CountRegisteredEvents() then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "no such event registered", -3) return end
  local A=reaper.GetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id)
  local A1=toboolean(A:match("(.-)\n"))
  local A2=tonumber(A:match(".-\n(.*)"))
  if A1==nil then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "", "EventCheckFunction returned invalid returnvalue: "..A:match("(.-)\n").."\nMust be either true or false!", -4) end
  return A1, A2
end

function ultraschall.EventManager_GetRegisteredEventID(EventIdentifier)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetRegisteredEventID</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>integer id = ultraschall.EventManager_GetRegisteredEventID(string EventIdentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the id of a registered event, meaning 1, if it's the first event, 2 if it's the second, etc
      
      It is the position within all events currently registered within the EventManager.
      
      returns nil in case of an error
    </description>
    <retval>
      integer id - the id of the event; 1, for the first; 2, for the second, etc
    </retval>
    <parameters>
      string EventIdentifier - the EventIdentifier of the event, whose id you want to retrieve
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>eventmanager, get, id, event, eventidentifier</tags>
  </US_DocBloc>
  ]]  
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_GetRegisteredEventID", "EventIdentifier", "must be a string", -1) return end
  local isvalid, inuse = ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if isvalid==false then ultraschall.AddErrorMessage("EventManager_GetRegisteredEventID", "EventIdentifier", "not a valid EventIdentifier", -2) return end
  if inuse==false then ultraschall.AddErrorMessage("EventManager_GetRegisteredEventID", "EventIdentifier", "not a registered EventIdentifier", -3) return end
  EventIdentifier=string.gsub(EventIdentifier, "%-", "%%-")
  return tonumber(reaper.GetExtState("ultraschall_eventmanager", "state"):match(".*Event #:(.-)\n.-EventIdentifier: "..EventIdentifier.."\n.-EndEvent"))
end

--AA=ultraschall.EventManager_GetRegisteredEventID("Ultraschall_Eventidentifier: {D0679278-6A20-4BA6-98C5-10576207BE28}")

function ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetLastCheckfunctionState2</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean paused_state, number last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(string EventIdentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the last state the eventcheck-function returned the last time it was called; of a certein registered event in the EventManager.
      State is requested by EventIdentifier
      
      returns nil in case of an error; nil and time, if the EventCheck-function didn't return a boolean
    </description>
    <retval>
      boolean paused_state - true, eventcheck-function returned true; false, eventcheck-function returned false; nil, an error occured
      number last_statechange_precise_time - the last time the state had been changed from true to false or false to true; the time is like the one returned by reaper.time_precise()
    </retval>
    <parameters>
      string EventIdentifier - the EventIdentifier of the event, whose last checkfunction-state you want to retrieve
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>eventmanager, get, eventcheck function, state, eventidentifier, count</tags>
  </US_DocBloc>
  ]]  
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "must be a string", -1) return end
  local isvalid, inuse = ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if isvalid==false then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "not a valid EventIdentifier", -2) return end
  if inuse==false then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "not a registered EventIdentifier", -3) return end
  EventIdentifier=string.gsub(EventIdentifier, "%-", "%%-")
  local id=tonumber(reaper.GetExtState("ultraschall_eventmanager", "state"):match(".*Event #:(.-)\n.-EventIdentifier: "..EventIdentifier.."\n.-EndEvent"))

  local A=reaper.GetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id)
  local A1=toboolean(A:match("(.-)\n"))
  local A2=tonumber(A:match(".-\n(.*)"))
  if A1==nil then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "", "EventCheckFunction returned invalid returnvalue: "..A:match("(.-)\n").."\nMust be either true or false!", -4) end
  
  return A1, A2
