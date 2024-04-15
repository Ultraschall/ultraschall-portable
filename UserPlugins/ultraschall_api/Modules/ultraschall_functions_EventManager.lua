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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---      EventManager Module      ---
-------------------------------------

function ultraschall.EventManager_EnumerateStartupEvents(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_EnumerateStartupEvents</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string EventIdentifier, string Eventname, string CallerScriptIdentifier, number CheckAllXSeconds, number CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean Paused, function CheckFunction, number NumberOfActions, table Actions = ultraschall.EventManager_EnumerateStartupEvents(integer index)</functioncall>
  <description>
    Enumerates already existing startupevents, that shall be automatically run at startup of the Ultraschall Event Manager.
    
    That means, if you start the EventManager, it will be started automatically to the EventManager-checking-queue, without the need of registering it by hand.
    
    returns nil in case of an error
  </description>
  <parameters>
    integer index - the index of the StartUp-event, whose attributes you want to get; 1 for the first, etc
  </parameters>
  <retvals>
    string EventIdentifier - the EventIdentifier of the startup-event
    string EventName - a name for the startupevent
    string CallerScriptIdentifier - the ScriptIdentifier of the script, which added this event to the StartUpEvents
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
    boolean Paused - true, the event shall be started as paused; false, the event shall be run immediately
    function CheckFunction - the function, which shall check if the event occurred
    integer NumberOfActions - the number of actions currently registered with this event
    table Actions - a table which holds all actions and their accompanying sections, who are run when the event occurred
                  - each entry of the table is of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, enumerate, startup, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  --if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "", "Eventmanager not started yet", -1) return end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("EventManager_EnumerateStartupEvents", "index", "must be an integer", -1) return end
  if index<=0 then ultraschall.AddErrorMessage("EventManager_EnumerateStartupEvents", "index", "must be higher than 0", -2) return end
  
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then return end
  local EventsIniFile=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  
  
  local Entries={}
  local EntriesCount=0
  local replace

  for k in string.gmatch(EventsIniFile, "Eventname: .-EndEvent") do    
    EntriesCount=EntriesCount+1
    if EntriesCount==index then 
      local actions={}
      local actionlist=k:match("CountOfActions.-\n(.-\n)EndEvent")
      local actioncounter=0
      for l in string.gmatch(actionlist, "(Action:.-\nSection:.-)\n") do
        actioncounter=actioncounter+1
        actions[actioncounter]=l:match("Action: (.-)\n")..","..l:match("\nSection: (.*)")
      end
      return k:match("EventIdentifier: (.-)\n"),
             k:match("Eventname: (.-)\n"),
             k:match("SourceScriptIdentifier: (.-)\n"),
             tonumber(k:match("CheckAllXSeconds: (.-)\n")),
             tonumber(k:match("CheckForXSeconds: (.-)\n")),
             toboolean(k:match("StartActionsOnceDuringTrue: (.-)\n")),
             toboolean(k:match("Paused: (.-)\n")),
             ultraschall.ConvertFunction_FromHexString(k:match("Function: (.-)\n")),
             tonumber(k:match("CountOfActions: (.-)\n")),
             actions
    end
  end
end

function ultraschall.EventManager_EnumerateStartupEvents2(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_EnumerateStartupEvents2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer index, string EventIdentifier, string Eventname, string CallerScriptIdentifier, number CheckAllXSeconds, number CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean Paused, function CheckFunction, number NumberOfActions, table Actions = ultraschall.EventManager_EnumerateStartupEvents2(string EventIdentifier)</functioncall>
  <description>
    Enumerates already existing startupevents by an EventIdentifier. 
    
    StartupEvents are events, that shall be automatically run at startup of the Ultraschall Event Manager.
    That means, if you start the EventManager, it will be started automatically to the EventManager-checking-queue, without the need of registering it by hand.
    
    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the identifier of the StartupEvent, that you want to enumerate
  </parameters>
  <retvals>
    integer index - the index of the StartupEvent within all StartUpEvents
    string EventIdentifier - the EventIdentifier of the startup-event
    string EventName - a name for the startupevent
    string CallerScriptIdentifier - the ScriptIdentifier of the script, which added this event to the StartUpEvents
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
    boolean Paused - true, the event shall be started as paused; false, the event shall be run immediately
    function CheckFunction - the function, which shall check if the event occurred
    integer NumberOfActions - the number of actions currently registered with this event
    table Actions - a table which holds all actions and their accompanying sections, who are run when the event occurred
                  - each entry of the table is of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, enumerate, startup, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  --if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "", "Eventmanager not started yet", -1) return end
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_EnumerateStartupEvents2", "string", "must be a string", -1) return end
  if EventIdentifier:match("Ultraschall_Eventidentifier: %{........%-....%-....%-....%-............%}")==nil then ultraschall.AddErrorMessage("EventIdentifier", "EventIdentifier", "must be a valid Event Identifier", -2) return false, false end
  
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then return end
  local EventsIniFile=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  
  local Entries={}
  local EntriesCount=0
  local replace
  EventIdentifier=string.gsub(EventIdentifier, "-", "%%-")
  
  for k in string.gmatch(EventsIniFile, "Eventname: .-EndEvent") do 
    EntriesCount=EntriesCount+1
    if k:match(EventIdentifier)~=nil then 
      local actions={}
      local actionlist=k:match("CountOfActions.-\n(.-\n)EndEvent")
      local actioncounter=0
      for l in string.gmatch(actionlist, "(Action:.-\nSection:.-)\n") do
        actioncounter=actioncounter+1
        actions[actioncounter]=l:match("Action: (.-)\n")..","..l:match("\nSection: (.*)")
      end
      return EntriesCount, 
             k:match("EventIdentifier: (.-)\n"),
             k:match("Eventname: (.-)\n"),
             k:match("SourceScriptIdentifier: (.-)\n"),
             tonumber(k:match("CheckAllXSeconds: (.-)\n")),
             tonumber(k:match("CheckForXSeconds: (.-)\n")),
             toboolean(k:match("StartActionsOnceDuringTrue: (.-)\n")),
             toboolean(k:match("Paused: (.-)\n")),
             ultraschall.ConvertFunction_FromHexString(k:match("Function: (.-)\n")),
             tonumber(k:match("CountOfActions: (.-)\n")),
             actions
    end
  end
end

--EventManager
function ultraschall.EventManager_AddEvent(EventName, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, Actions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_AddEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string event_identifier = ultraschall.EventManager_AddEvent(string EventName, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, table Actions)</functioncall>
  <description>
    Adds a new event to the Ultraschall Event Manager-checking-queue.
    
    returns nil in case of an error
  </description>
  <parameters>
    string EventName - a name for the event, which you can choose freely; duplicated eventnames are allowed
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
    boolean EventPaused - false, register the event and check for it immediately; true, register the event but don't check for it yet
    function CheckFunction - the function, which shall check if the event occurred
                           - this function must return true if the event occurred and false, if not
                           - No global variables allowed! Instead, the eventmanager will pass to it as first parameter a table which can be used for storing information
    table Actions - a table which holds all actions and their accompanying sections, who shall be run when the event occurred
                  - each entry of the table must be of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
                  -
                  - You can have as many actions as you like, but be aware, that running too many actions may delay further eventchecking!
  </parameters>
  <retvals>
    string event_identifier - the unique identifier for this registered event, which can be used later for setting, deleting, etc
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, add, new, event, function, actions, section, action</tags>
</US_DocBloc>
--]]

  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddEvent", "", "Eventmanager not started yet", -1) return end
  if type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_AddEvent", "EventName", "must be a string", -2) return end
  if math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_AddEvent", "CheckAllXSeconds", "must be an integer; 0 for constant checking", -3) return end
  if math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_AddEvent", "CheckForXSeconds", "must be an integer; 0 for infinite checking", -4) return end
  if type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_AddEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return end
  if type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_AddEvent", "EventPaused", "must be a boolean", -6) return end
  if type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_AddEvent", "CheckFunction", "must be a function", -7) return end
  if type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_AddEvent", "Actions", "must be a table", -8) return end

  local EventStateChunk=""  
  local EventIdentifier="Ultraschall_Eventidentifier: "..reaper.genGuid()
  
  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[

Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..ultraschall.ScriptIdentifier..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.ConvertAscii2Hex(string.dump(CheckFunction))..[[

CountOfActions: ]]..ActionsCount.."\n"

  for i=1, ActionsCount do
    if type(Actions[i])~="string" then ultraschall.AddErrorMessage("EventManager_AddEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -10) return nil end
    local Action, Section=Actions[i]:match("(.-),(.*)")
    if math.type(tonumber(Section))~="integer" or 
       (Action:sub(1,1)~="_" and math.type(tonumber(Action))~="integer") then
       ultraschall.AddErrorMessage("EventManager_AddEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -10) return nil
    else
      EventStateChunk2=EventStateChunk2.."Action: "..Action.."\nSection: "..Section.."\n"
    end
  end

  EventStateChunk2=EventStateChunk2.."EndEvent\n"
  
  local StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventregister")
  reaper.SetExtState("ultraschall_eventmanager", "eventregister", StateRegister..EventStateChunk2, false)
  
  return EventIdentifier
end

function ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_IsValidEventIdentifier</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean valid, boolean valid_inuse = ultraschall.EventManager_IsValidEventIdentifier(string event_identifier)</functioncall>
  <description>
    Checks, if a string is a valid EventIdentifier (valid) and currently registered with an event(valid_inuse) in the Ultraschall-EventManager-checking-queue.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the registered event, that you want to check
  </parameters>
  <retvals>
    boolean valid - true, valid EventIdentifier; false, no valid EventIdentifier
    boolean valid_inuse - true, valid EventIdentifier, which is currently registered and in use by the EventManager; false, no currently registered EventIdentifier
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, check, eventidentifier</tags>
</US_DocBloc>
--]]
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_IsValidEventIdentifier", "EventIdentifier", "must be a string", -1) return false, false end
  if EventIdentifier:match("Ultraschall_Eventidentifier: %{........%-....%-....%-....%-............%}")==nil then ultraschall.AddErrorMessage("EventIdentifier", "EventIdentifier", "must be a valid Event Identifier", -2) return false, false end
  local retval1=true
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  if States~="" then
    for k in string.gmatch(States, "EventIdentifier: (.-)\n") do
        if k==EventIdentifier then return true, true end
    end
  else
    return true, false
  end
  return retval1, false
end

function ultraschall.EventManager_RemoveEvent(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_RemoveEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_RemoveEvent(string event_identifier)</functioncall>
  <description>
    Removes a new event to the Ultraschall Event Manager-checking-queue.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the registered event, which you want to remove from the EventManager
  </parameters>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, remove, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_RemoveEvent", "", "Eventmanager not started yet", -1) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_RemoveEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -2) return false end
  local OldRemoves=reaper.GetExtState("ultraschall_eventmanager", "eventremove")
  reaper.SetExtState("ultraschall_eventmanager", "eventremove", OldRemoves..EventIdentifier.."\n", false)
  return true
end

function ultraschall.EventManager_RemoveAllEvents_Script(ScriptIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_RemoveAllEvents_Script</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_RemoveAllEvents_Script(string ScriptIdentifier)</functioncall>
  <description>
    Removes all registered events from a script with a certain ScriptIdentifier in the Ultraschall Event Manager-checking-queue.
    
    returns false in case of an error
  </description>
  <parameters>
    string ScriptIdentifier - the unique identifier of the registered event, which you want to remove from the EventManager
  </parameters>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, remove, all events, scriptidentifier, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_RemoveAllEvents_Script", "", "Eventmanager not started yet", -1) return false end
  if ScriptIdentifier~=nil and type(ScriptIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_RemoveAllEvents_Script", "ScriptIdentifier", "must be a string", -2) return false end
  if ScriptIdentifier==nil then ScriptIdentifier=ultraschall.ScriptIdentifier end
  if ScriptIdentifier:match("ScriptIdentifier:.-%-%{........%-....%-....%-....%-............%}%..*")==nil then ultraschall.AddErrorMessage("EventManager_RemoveAllEvents_Script", "ScriptIdentifier", "must be a valid ScriptIdentifier", -3) return false end
  local OldRemoves=reaper.GetExtState("ultraschall_eventmanager", "eventremove")
  reaper.SetExtState("ultraschall_eventmanager", "eventremove_scriptidentifier", OldRemoves..ScriptIdentifier.."\n", false)
  return true
end

function ultraschall.EventManager_SetEvent(EventIdentifier, EventName, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, Actions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_SetEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_SetEvent(string EventIdentifier, optional string EventName, optional integer CheckAllXSeconds, optional integer CheckForXSeconds, optional boolean StartActionsOnceDuringTrue, optional boolean EventPaused, optional function CheckFunction, optional table Actions)</functioncall>
  <description>
    Sets the attributes of an already added event in the Ultraschall Event Manager-checking-queue.
    
    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the EventIdentifier of the registered event, which you want to set
    optional string EventName - a name for the event, which you can choose freely; duplicated eventnames are allowed; nil, keep the old name
    optional integer CheckAllXSeconds - only check all x seconds; 0, for constant checking; nil, keep the old value
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    optional integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed; nil, keep the old value
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    optional boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
                                       -    nil, keep the old value
    optional boolean EventPaused - false, register the event and check for it immediately; true, register the event but don't check for it yet; nil, keep the old value
    optional function CheckFunction - the function, which shall check if the event occurred; nil, keep the old function
                           - this function must return true if the event occurred and false, if not
                           - No global variables allowed! Instead, the eventmanager will pass to the function as first parameter a table which can be used for storing information
    optional table Actions - a table which holds all actions and their accompanying sections, who shall be run when the event occurred; nil, keep the old actionlist
                  - each entry of the table must be of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
                  -
                  - You can have as many actions as you like, but be aware, that running too many actions may delay further eventchecking!
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, setting wasn't successful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, add, new, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_SetEvent", "", "Eventmanager not started yet", -1) return false end
  if EventName~=nil and type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventName", "must be a string", -2) return false end
  if CheckAllXSeconds~=nil and math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckAllXSeconds", "must be an integer; -1 for constant checking", -3) return false end
  if CheckForXSeconds~=nil and math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckForXSeconds", "must be an integer; -1 for infinite checking", -4) return false end
  if StartActionsOnceDuringTrue~=nil and type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return false end
  if EventPaused~=nil and type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventPaused", "must be a boolean", -6) return false end
  if CheckFunction~=nil and type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckFunction", "must be a function", -7) return false end
  if Actions~=nil and type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_SetEvent", "Actions", "must be a table", -8) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -9) return false end
  
  local EventIdentifier2, EventName2, CallerScriptIdentifier2, CheckAllXSeconds2, CheckForXSeconds2, 
  StartActionsOnceDuringTrue2, EventPaused2, CheckFunction2, NumberOfActions2, Actions2 
                                            = ultraschall.EventManager_EnumerateEvents2(EventIdentifier)
                                            
  if EventName==nil then EventName=EventName2 end
  if CheckAllXSeconds==nil then CheckAllXSeconds=CheckAllXSeconds2 end
  if CheckForXSeconds==nil then CheckForXSeconds=CheckForXSeconds2 end
  if StartActionsOnceDuringTrue==nil then StartActionsOnceDuringTrue=StartActionsOnceDuringTrue2 end
  if EventPaused==nil then EventPaused=EventPaused2 end
  if CheckFunction==nil then CheckFunction=CheckFunction2 end
  if Actions==nil then Actions=Actions2 end
  
  
  
  local EventStateChunk=""  
  
  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[

Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..CallerScriptIdentifier2..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.ConvertAscii2Hex(string.dump(CheckFunction))..[[

CountOfActions: ]]..ActionsCount.."\n"

  for i=1, ActionsCount do
    local Action, Section=Actions[i]:match("(.-),(.*)")
    if math.type(tonumber(Section))~="integer" or 
       (Action:sub(1,1)~="_" and math.type(tonumber(Action))~="integer") then
       ultraschall.AddErrorMessage("EventManager_AddEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -10) return nil
    else
      EventStateChunk2=EventStateChunk2.."Action: "..Action.."\nSection: "..Section.."\n"
    end
  end

  EventStateChunk2=EventStateChunk2.."EndEvent\n"
  
  local StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventset")
  reaper.SetExtState("ultraschall_eventmanager", "eventset", StateRegister..EventStateChunk2, false)
  return true
end

function ultraschall.EventManager_EnumerateEvents(id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_EnumerateEvents</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string EventIdentifier, string EventName, string CallerScriptIdentifier, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, integer NumberOfActions, table Actions = ultraschall.EventManager_EnumerateEvents(integer id)</functioncall>
  <description>
    Gets the attributes of an already added event in the Ultraschall Event Manager-checking-queue.
    
    returns nil in case of an error
  </description>
  <parameters>
    integer id - the id of the currently registered event, of which you want to have the attributes; starting with 1 for the first
  </parameters>
  <retvals>
    string EventIdentifier - the EventIdentifier of the registered event
    string EventName - the name of the event
    string CallerScriptIdentifier - the ScriptIdentifier of the script, who registered the event
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once
                                       -    false, run until the CheckFunction returns false again
    boolean EventPaused - true, eventcheck is currently paused; false, eventcheck is currently running
    function CheckFunction - the function, which shall check if the event occurred
    integer NumberOfActions - the number of actions currently registered with this event
    table Actions - a table which holds all actions and their accompanying sections, who are run when the event occurred
                  - each entry of the table is of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, event, attributes</tags>
</US_DocBloc>
--]]
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_EnumerateEvents", "id", "must be an integer", -1) return nil end
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  local count=0
  local actioncounter=0
  local actions={}
  for k in string.gmatch(States, "(Event #.-EndEvent)") do
    count=count+1
    if count==id then
      local actionlist=k:match("Number of Actions.-\n(.-\n)EndEvent")
      for l in string.gmatch(actionlist, "(.-)\n") do
        actioncounter=actioncounter+1
        actions[actioncounter]=l:match(".-action: (.*)")..","..l:match(".- section: (.-) ")
      end
      
      return k:match("EventIdentifier: (.-)\n"),
             k:match("EventName: (.-)\n"),
             k:match("StartedByScript: (.-)\n"),
             tonumber(k:match("CheckAllXSeconds: (.-)\n")),
             tonumber(k:match("CheckForXSeconds: (.-)\n")),
             toboolean(k:match("StartActionsOnlyOnceDuringTrue: (.-)\n")),
             toboolean(k:match("EventPaused: (.-)\n")),
             ultraschall.ConvertFunction_FromHexString(k:match("Function: (.-)\n")),
             tonumber(k:match("Number of Actions: (.-)\n")),
             actions
    end
  end
end

function ultraschall.EventManager_EnumerateEvents2(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_EnumerateEvents2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string EventIdentifier, string EventName, string CallerScriptIdentifier, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, integer NumberOfActions, table Actions = ultraschall.EventManager_EnumerateEvents2(string EventIdentifier)</functioncall>
  <description>
    Gets the attributes of an already added event in the Ultraschall Event Manager-checking-queue.
    
    returns nil in case of an error
  </description>
  <parameters>
    string Eventidentifier - the EventIdentifier of the currently registered event, of which you want to have the attributes
  </parameters>
  <retvals>
    string EventIdentifier - the EventIdentifier of the registered event
    string EventName - the name of the event
    string CallerScriptIdentifier - the ScriptIdentifier of the script, who registered the event
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once
                                       -    false, run until the CheckFunction returns false again
    boolean EventPaused - true, eventcheck is currently paused; false, eventcheck is currently running
    function CheckFunction - the function, which shall check if the event occurred
    integer NumberOfActions - the number of actions currently registered with this event
    table Actions - a table which holds all actions and their accompanying sections, who are run when the event occurred
                  - each entry of the table is of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, event, attributes</tags>
</US_DocBloc>
--]]
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_EnumerateEvents2", "EventIdentifier", "must be a string", -1) return nil end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_EnumerateEvents2", "EventIdentifier", "must be a valid and used EventIdentifier", -2) return false end
  
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  local actioncounter=0
  local actions={}
  for k in string.gmatch(States, "(Event #.-EndEvent)") do
    if EventIdentifier==k:match("EventIdentifier: (.-)\n") then
      local actionlist=k:match("Number of Actions.-\n(.-\n)EndEvent")
      for l in string.gmatch(actionlist, "(.-)\n") do
        actioncounter=actioncounter+1
        actions[actioncounter]=l:match(".-action: (.*)")..","..l:match(".- section: (.-) ")
      end
      
      return k:match("EventIdentifier: (.-)\n"),
             k:match("EventName: (.-)\n"),
             k:match("StartedByScript: (.-)\n"),
             tonumber(k:match("CheckAllXSeconds: (.-)\n")),
             tonumber(k:match("CheckForXSeconds: (.-)\n")),
             toboolean(k:match("StartActionsOnlyOnceDuringTrue: (.-)\n")),
             toboolean(k:match("EventPaused: (.-)\n")),
             ultraschall.ConvertFunction_FromHexString(k:match("Function: (.-)\n")),
             tonumber(k:match("Number of Actions: (.-)\n")),
             actions
    end
  end
end

function ultraschall.EventManager_CountRegisteredEvents()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_CountRegisteredEvents</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer count_of_registered_events = ultraschall.EventManager_CountRegisteredEvents()</functioncall>
  <description>
    Returns the number of currently registered events in the EventManager-checking-queue
  </description>
  <retvals>
    integer count_of_registered_events - the number of currently registered events
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, count, events</tags>
</US_DocBloc>
--]]
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  local count=0
  for k in string.gmatch(States, "Event #.-\n") do
    count=count+1
  end
  return count
end

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
  <description>
    Returns the last time, the eventlist in the EventManager had been updated in any way.
  </description>
  <retvals>
    string datetime - the date and time of the last update, as returned by os.date()
    number precise_time - the last update time as number, as returned by reaper.time_precise()
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, last update, time, date, time_precise, events</tags>
</US_DocBloc>
--]]
  local States=reaper.GetExtState("ultraschall_eventmanager", "state")
  local A,B=States:match("Last update: (.-) %- (.-)\n")
  return A, tonumber(B)
end

function ultraschall.EventManager_PauseEvent(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_PauseEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_PauseEvent(string event_identifier)</functioncall>
  <description>
    Pauses a registered event in the Ultraschall Event Manager-checking-queue.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the registered event, which you want to pause in the EventManager
  </parameters>
  <retvals>
    boolean retval - true, pausing was successful; false, pausing was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, pause, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_PauseEvent", "", "Eventmanager not started yet", -1) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_PauseEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -2) return false end

  local OldPauses=reaper.GetExtState("ultraschall_eventmanager", "eventpause")
  reaper.SetExtState("ultraschall_eventmanager", "eventpause", OldPauses..EventIdentifier.."\n", false)
  return true
end

function ultraschall.EventManager_ResumeEvent(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_ResumeEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_ResumeEvent(string event_identifier)</functioncall>
  <description>
    Resumes a registered and paused event in the Ultraschall Event Manager-checking-queue.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the registered event, which you want to resume in the EventManager
  </parameters>
  <retvals>
    boolean retval - true, resuming was successful; false, resuming was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, resume, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_ResumeEvent", "", "Eventmanager not started yet", -1) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_ResumeEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -2) return false end
  
  local OldResumes=reaper.GetExtState("ultraschall_eventmanager", "eventresume")
  reaper.SetExtState("ultraschall_eventmanager", "eventresume", OldResumes..EventIdentifier.."\n", false)
  return true
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
  <functioncall>boolean retval = ultraschall.EventManager_Start()</functioncall>
  <description>
    Starts the Ultraschall-EventManager, if it has not been started yet.
  </description>
  <retvals>
    boolean retval - true, EventManager has been started successfully; false, EventManager couldn't be started
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, start</tags>
</US_DocBloc>
--]]
  if reaper.HasExtState("ultraschall_eventmanager", "running")==false then
    if reaper.file_exists(ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua")==false then
        ultraschall.AddErrorMessage("EventManager_Start", "", "Critical Error: Couldn't find "..ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua\n\nPlease contact Ultraschall-API-developers!", -1) 
        return false
    end
    local P=reaper.AddRemoveReaScript(true, 0, ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua", true)
    reaper.Main_OnCommand(P,0)
    local P=reaper.AddRemoveReaScript(false, 0, ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua", true)
  end
  local Registered=reaper.GetExtState("ultraschall_eventmanager", "registered_scripts")
  if Registered:match(ultraschall.ScriptIdentifier)==nil then
    Registered=Registered..ultraschall.ScriptIdentifier.."\n"
  end
  reaper.SetExtState("ultraschall_eventmanager", "registered_scripts", Registered, false)
  return true
end

--ultraschall.ScriptIdentifier=reaper.CF_GetClipboard("")

function ultraschall.EventManager_Stop(force, ScriptIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_Stop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>ultraschall.EventManager_Stop(optional boolean force, optional string ScriptIdentifier)</functioncall>
  <description>
    Unregisters the current script; will stop the EventManager if no scripts are registered anymore to the EventManager.
    
    You can use the parameter force to force stopping of the EventManager immediately.
  </description>
  <parameters>
    optional boolean force - true, stops the EventManager, even if other scripts have registered events to it; false or nil, don't force stop
    optional string ScriptIdentifier - if you want to unregister events from a different script, pass here the ScriptIdentifier of this script; nil, use the ScriptIdentifier of the current script
  </parameters>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, stop, ScriptIdentifier</tags>
</US_DocBloc>
--]]
  if ScriptIdentifier==nil then ScriptIdentifier=ultraschall.ScriptIdentifier end
  if force==true then 
    reaper.DeleteExtState("ultraschall_eventmanager", "running", false)
  else
    local Registered=reaper.GetExtState("ultraschall_eventmanager", "eventstop_scriptidentifier")
    reaper.SetExtState("ultraschall_eventmanager", "eventstop_scriptidentifier", Registered..ScriptIdentifier.."\n", false)
  end
end

function ultraschall.EventManager_AddStartupEvent(EventName, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, Actions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_AddStartupEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string event_identifier = ultraschall.EventManager_AddStartupEvent(string EventName, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, table Actions)</functioncall>
  <description>
    Adds a new event, that shall be automatically registered at startup of the Ultraschall Event Manager.
    
    That means, if you start the EventManager, it will be added automatically to the EventManager-checking-queue, without the need of registering it by hand.
    
    returns nil in case of an error
  </description>
  <parameters>
    string EventName - a name for the event, which you can choose freely; duplicated eventnames are allowed
    integer CheckAllXSeconds - only check all x seconds; 0, for constant checking
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
    boolean EventPaused - false, register the event and check for it immediately; true, register the event but don't check for it yet
    function CheckFunction - the function, which shall check if the event occurred
                           - this function must return true if the event occurred and false, if not
                           - No global variables allowed! Instead, the eventmanager will pass to the function as first parameter a table which can be used for storing information
    table Actions - a table which holds all actions and their accompanying sections, who shall be run when the event occurred
                  - each entry of the table must be of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
                  -
                  - You can have as many actions as you like, but be aware, that running too many actions may delay further eventchecking!
  </parameters>
  <retvals>
    string event_identifier - the unique identifier for this registered event, which can be used later for setting, deleting, etc
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, add, startup, new, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  --if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "", "Eventmanager not started yet", -1) return end
  if type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "EventName", "must be a string", -2) return end
  if math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "CheckAllXSeconds", "must be an integer; -1 for constant checking", -3) return end
  if math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "CheckForXSeconds", "must be an integer; -1 for infinite checking", -4) return end
  if type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return end
  if type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "EventPaused", "must be a boolean", -6) return end
  if type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "CheckFunction", "must be a function", -7) return end
  if type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "Actions", "must be a table", -8) return end
  

  local EventStateChunk=""  
  local EventIdentifier="Ultraschall_Eventidentifier: "..reaper.genGuid()
  
  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[
Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..ultraschall.ScriptIdentifier..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.ConvertAscii2Hex(string.dump(CheckFunction))..[[

CountOfActions: ]]..ActionsCount.."\n"
  for i=1, ActionsCount do
    if type(Actions[i])~="string" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -10) return nil end
    --Actions[i]=tostring(Actions[i])
    local Action, Section=Actions[i]:match("(.-),(.*)")
    
    if math.type(tonumber(Section))~="integer" or 
       (Action:sub(1,1)~="_" and math.type(tonumber(Action))~="integer") then
       ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -11) return nil
    else
      EventStateChunk2=EventStateChunk2.."Action: "..Action.."\nSection: "..Section.."\n"
    end
  end

  EventStateChunk2=EventStateChunk2.."EndEvent\n"
  
  
  local OldEvents=""
  
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==true then ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini") end
  
  ultraschall.WriteValueToFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini", OldEvents.."\n"..EventStateChunk2)
end

function ultraschall.EventManager_RemoveStartupEvent2(id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_RemoveStartupEvent2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_RemoveStartupEvent2(integer id)</functioncall>
  <description>
    Removes a startup-event from the config-file of the Ultraschall Event Manager.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the startup event, which you want to remove from the EventManager-startup-procedure
  </parameters>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, remove, startup, event</tags>
</US_DocBloc>
--]]
   if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent2", "id", "must be an integer", -1) return false end
   
   if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then return false end
   
   local OldEvents=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
   if OldEvents==nil then OldEvents="" end
   local count=0
   local NewEvents=""
   for k in string.gmatch(OldEvents, "(.-EndEvent)") do
     count=count+1
     if count~=id then
       NewEvents=NewEvents..k
     end
   end
   if NewEvents==OldEvents then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent2", "EventIdentifier", "so such Event", -2) return false end
   ultraschall.WriteValueToFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini", NewEvents)
end

function ultraschall.EventManager_RemoveStartupEvent(EventIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_RemoveStartupEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.EventManager_RemoveStartupEvent(string event_identifier)</functioncall>
  <description>
    Removes a startup-event from the config-file of the Ultraschall Event Manager.
    
    returns false in case of an error
  </description>
  <parameters>
    string event_identifier - the unique identifier of the startup event, which you want to remove from the EventManager-startup-procedure
  </parameters>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, startup, remove, event</tags>
</US_DocBloc>
--]]
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent", "EventIdentifier", "must be a string", -1) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if A==false then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent", "EventIdentifier", "must be a valid EventIdentifier", -3) return false end
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent2", "EventIdentifier", "so such Event", -2) return false end
  
  local OldEvents=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  local count=0
  local NewEvents=""
  for k in string.gmatch(OldEvents, "(.-EndEvent)") do
    
    if k:match("EventIdentifier: (.-)\n")~=EventIdentifier then
      NewEvents=NewEvents..k
    end
  end
  
  if NewEvents==OldEvents then ultraschall.AddErrorMessage("EventManager_RemoveStartupEvent", "EventIdentifier", "so such Event", -4) return false end
  ultraschall.WriteValueToFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini", NewEvents)
  return true
end

function ultraschall.EventManager_CountStartupEvents()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_CountStartupEvents</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer count_startup_events = ultraschall.EventManager_CountStartupEvents()</functioncall>
  <description>
    Counts the currently available startup-events
  </description>
  <retvals>
    integer count_startup_events - the number of currently available start-up-events for the EventManager
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, startup, count, event</tags>
</US_DocBloc>
--]]
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then return 0 end
  local EventsIniFile=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  local count=0
  for k in string.gmatch(EventsIniFile, "Eventname%:(.-)EndEvent") do
    count=count+1
  end
  
  return count
end

function ultraschall.EventManager_SetStartupEvent(EventIdentifier, EventName, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, Actions)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_SetStartupEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string event_identifier = ultraschall.EventManager_SetStartupEvent(string EventIdentifier, optional string EventName, optional integer CheckAllXSeconds, optional integer CheckForXSeconds, optional boolean StartActionsOnceDuringTrue, optional boolean EventPaused, optional function CheckFunction, optional table Actions)</functioncall>
  <description>
    Sets an already existing startupevent, that shall be automatically run at startup of the Ultraschall Event Manager.
    
    That means, if you start the EventManager, it will be started automatically to the EventManager-checking-queue, without the need of registering it by hand.
    
    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the EventIdentifier of the startup-event, which you want to set
    optional string EventName - a name for the event, which you can choose freely; duplicated eventnames are allowed; nil, to keep current name
    optional integer CheckAllXSeconds - only check all x seconds; 0, for constant checking; nil, to keep current value
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    optional integer CheckForXSeconds - only check for x seconds; 0, check until the event is removed; nil, to keep current value
                             - this value will be used as approximate time, not necessarily exact. That means, 2 seconds given may be 2.5 in some cases!
                             - This is due general limitations with backgroundscripts.
    optional boolean StartActionsOnceDuringTrue - if the event occurred: 
                                       -    true, run the actions only once; 
                                       -    false, run until the CheckFunction returns false again
                                       -    nil, to keep current value
    optional boolean EventPaused - false, register the event and check for it immediately; true, register the event but don't check for it yet; nil, to keep current value
    optional function CheckFunction - the function, which shall check if the event occurred; nil, to keep current function
                           - this function must return true if the event occurred and false, if not
                           - No global variables allowed! Instead, the eventmanager will pass to the function as first parameter a table which can be used for storing information
    optional table Actions - a table which holds all actions and their accompanying sections, who shall be run when the event occurred; nil, to keep current actionlist
                  - each entry of the table must be of the format "actioncommandid,section", e.g.:
                  - 
                  - Actions[1]="1007,0"
                  - Actions[2]="1012,0"
                  -
                  - You can have as many actions as you like, but be aware, that running too many actions may delay further eventchecking!
  </parameters>
  <retvals>
    string event_identifier - the unique identifier for this registered event, which can be used later for setting, deleting, etc
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, set, startup, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  --if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "", "Eventmanager not started yet", -1) return end
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "must be a string", -1) return end
  if EventName~=nil and type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventName", "must be a string", -2) return end
  if CheckAllXSeconds~=nil and math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckAllXSeconds", "must be an integer; -1 for constant checking", -3) return end
  if CheckForXSeconds~=nil and math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckForXSeconds", "must be an integer; -1 for infinite checking", -4) return end
  if StartActionsOnceDuringTrue~=nil and type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return end
  if EventPaused~=nil and type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventPaused", "must be a boolean", -6) return end
  if CheckFunction~=nil and type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckFunction", "must be a function", -7) return end
  if Actions~=nil and type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "Actions", "must be a table", -8) return end
  
  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "no such event", -9) return end
  
  --local EventIdentifier2, EventName2, CallerScriptIdentifier2, CheckAllXSeconds2, CheckForXSeconds2, 
  --StartActionsOnceDuringTrue2, EventPaused2, CheckFunction2, NumberOfActions2, Actions2 
  local index2, EventIdentifier2, EventName2, CallerScriptIdentifier2, CheckAllXSeconds2, CheckForXSeconds2, 
  StartActionsOnceDuringTrue2, EventPaused2, CheckFunction2, NumberOfActions2, Actions2
                                            = ultraschall.EventManager_EnumerateStartupEvents2(EventIdentifier)  
    LOL=type(CheckFunction2)
  
  if EventName==nil then EventName=EventName2 end
  if CheckAllXSeconds==nil then CheckAllXSeconds=CheckAllXSeconds2 end
  if CheckForXSeconds==nil then CheckForXSeconds=CheckForXSeconds2 end
  if StartActionsOnceDuringTrue==nil then StartActionsOnceDuringTrue=StartActionsOnceDuringTrue2 end
  if EventPaused==nil then EventPaused=EventPaused2 end
  if CheckFunction==nil then CheckFunction=CheckFunction2 end
  if Actions==nil then Actions=Actions2 end
  
  
  
  local EventsIniFile=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  
  local Entries={}
  local EntriesCount=0
  local replace
  local NewEventIdentifier=string.gsub(EventIdentifier, "-", "%%-")
  for k in string.gmatch(EventsIniFile, "Eventname: .-EndEvent") do
    EntriesCount=EntriesCount+1
    Entries[EntriesCount]=k
    
    if k:match(NewEventIdentifier)~=nil then replace=EntriesCount end
  end
  
  ActionsCount=EntriesCount
  
  if replace==nil then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "no such event", -12) return end

  local EventStateChunk=""  
  
  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[
Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..CallerScriptIdentifier2..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.ConvertAscii2Hex(string.dump(CheckFunction))..[[

CountOfActions: ]]..ActionsCount.."\n"
  for i=1, ActionsCount do
    if type(Actions[i])~="string" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -10) return nil end
    local Action, Section=Actions[i]:match("(.-),(.*)")
    
    if math.type(tonumber(Section))~="integer" or 
       (Action:sub(1,1)~="_" and math.type(tonumber(Action))~="integer") then
       ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "Actions", "Entry number "..i.." must be contain valid _ActionCommandID-string/CommandID-integer,integer section for \"action,section\" (e.g. \"1007,0\" or \"_BR_PREV_ITEM_CURSOR,0\").", -11) return nil
    else
      EventStateChunk2=EventStateChunk2.."Action: "..Action.."\nSection: "..Section.."\n"
    end
  end

  EventStateChunk2=EventStateChunk2.."EndEvent\n"
  
  local OldEvents=""
  
  for i=1, EntriesCount do
    if i~=replace then OldEvents=OldEvents..Entries[i].."\n\n"
    else 
        OldEvents=OldEvents..EventStateChunk2.."\n"
    end
  end

  ultraschall.WriteValueToFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini", OldEvents)
  return EventIdentifier
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
    <description>
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
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
    <description>
      returns, if a certain event, currently registered in the EventManager, is paused(true) or not(false)
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
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

function ultraschall.EventManager_GetEventIdentifier(id)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetEventIdentifier</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string event_identifier = ultraschall.EventManager_GetEventIdentifier(integer id)</functioncall>
    <description>
      returns the EventIdentifier of a registered event, by id
      event is requested by number-id, with 1 for the first event, 2 for the second, etc.
      
      returns nil in case of an error
    </description>
    <retval>
      string event_identifier - the EventIdentifier of the requested event
    </retval>
    <parameters>
      integer id - the id of the event, whose EventIdenrifier you want to retrieve; 1, the first event; 2, the second event, etc
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
    <tags>eventmanager, get, eventidentifier, id, count</tags>
  </US_DocBloc>
  ]]  
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be an integer", -1) return end
  if id<1 then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be greater than 0", -2) return end
  if id>ultraschall.EventManager_CountRegisteredEvents() then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "no such event registered", -3) return end
  local A=reaper.GetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id)
  local A1=A:match(".*\n(.*)")
  if A1==nil then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "", "EventCheckFunction returned invalid returnvalue: "..A:match("(.-)\n").."\nMust be either true or false!", -4) end
  return A1, A2
end

function ultraschall.EventManager_GetLastCheckfunctionState(id)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>EventManager_GetLastCheckfunctionState</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean check_state, number last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState(integer id)</functioncall>
    <description>
      returns the last state the eventcheck-function returned the last time it was called; of a certain registered event in the EventManager.
      State is requested by number-id, with 1 for the first event, 2 for the second, etc.
      
      returns nil in case of an error; nil and time, if the EventCheck-function didn't return a boolean
    </description>
    <retval>
      boolean check_state - true, eventcheck-function returned true; false, eventcheck-function returned false; nil, an error occured
      number last_statechange_precise_time - the last time the state had been changed from true to false or false to true; the time is like the one returned by reaper.time_precise()
    </retval>
    <parameters>
      integer id - the id of the event, whose eventcheckfunction-retval you want to retrieve; 1, the first event; 2, the second event, etc
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
    <tags>eventmanager, get, eventcheck function, state, id, count</tags>
  </US_DocBloc>
  ]]  
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be an integer", -1) return end
  if id<1 then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "must be greater than 0", -2) return end
  if id>ultraschall.EventManager_CountRegisteredEvents() then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState", "id", "no such event registered", -3) return end
  local A=reaper.GetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id)
  local A1=toboolean(A:match("(.-)\n"))
  A2=tonumber(A:match(".-\n(.-)\n"))
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
    <description>
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
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
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
      Ultraschall=4.7
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean check_state, number last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(string EventIdentifier)</functioncall>
    <description>
      returns the last state the eventcheck-function returned the last time it was called; of a certain registered event in the EventManager.
      State is requested by EventIdentifier
      
      returns nil in case of an error; nil and time, if the EventCheck-function didn't return a boolean
    </description>
    <retval>
      boolean check_state - true, eventcheck-function returned true; false, eventcheck-function returned false; nil, an error occured
      number last_statechange_precise_time - the last time the state had been changed from true to false or false to true; the time is like the one returned by reaper.time_precise()
    </retval>
    <parameters>
      string EventIdentifier - the EventIdentifier of the event, whose last checkfunction-state you want to retrieve
    </parameters>
    <chapter_context>
      Event Manager
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
    <tags>eventmanager, get, eventcheck function, state, eventidentifier</tags>
  </US_DocBloc>
  ]]  
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "must be a string", -1) return end
  --local isvalid, inuse = ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if isvalid==false then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "not a valid EventIdentifier", -2) return end
  if inuse==false then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "EventIdentifier", "not a registered EventIdentifier", -3) return end
  --EventIdentifier=string.gsub(EventIdentifier, "%-", "%%-")
  --local id=tonumber(reaper.GetExtState("ultraschall_eventmanager", "state")
          --:match(".*Event #:(.-)\n.-EventIdentifier: "..EventIdentifier.."\n.-EndEvent"))
  --id=1
  
  local count=0
  for k in string.gmatch(reaper.GetExtState("ultraschall_eventmanager", "EventIdentifier"), "(.-)\n") do
    count=count+1  
    if k==EventIdentifier then id=count break end
  end

  local A=reaper.GetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id)
  local A1=toboolean(A:match("(.-)\n"))
  local A2=tonumber(A:match(".-\n(.-)\n"))  
  if A1==nil then ultraschall.AddErrorMessage("EventManager_GetLastCheckfunctionState2", "", "EventCheckFunction returned invalid returnvalue: "..A:match("(.-)\n").."\nMust be either true or false!", -4) end
  
  return A1, A2
end

--print(reaper.GetExtState("ultraschall_eventmanager", "state"))

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
    
    Allows you to get the contents of the UserSpace of a certain checkfunction of a registered event, see [EventManager\_DebugMode\_UserSpace](#EventManager_DebugMode_UserSpace).
    
    Note: Debugmode is not for productive usecases, as it costs resources. Please turn it off again, after you've finished debugging.
  </description>
  <parameters>
    boolean toggle - true, turn debugmode on; false, turn debugmode off
  </parameters>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, toggle, debug, debugmode</tags>
</US_DocBloc>
--]]
  if toggle==true then toggle="doit" else toggle="stopit" end
  reaper.SetExtState("ultraschall_eventmanager", "debugmode", toggle, false)
end

function ultraschall.EventManager_DebugMode_UserSpace(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_DebugMode_UserSpace</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>integer userspace_count, table userspace = ultraschall.EventManager_DebugMode_UserSpace(integer index)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the current contents of the UserSpace, as stored by the checkfunction of a registered event in the EventManager.
    
    The table is of the format:
        
            userspace[index]["index"]    - the name of the index
            userspace[index]["datatype"] - the datatype of the value in this userspace-index
            userspace[index]["value"]    - the value in this userspace-index
    
    Note: Debugmode is not for productive usecases, as it costs resources. Please turn it off again, after you've finished debugging.
    See [EventManager\_DebugMode](#EventManager_DebugMode) for more details on stopping DebugMode.
    
    returns nil in case of an error
  </description>
  <parameters>
    integer index - the index of the event, whose UserSpace you want to retrieve
  </parameters>
  <retvals>
    integer userspace_count - the number of values within the userspace
    table userspace - the contents of the userspace as a handy table
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, toggle, debug, debugmode, userspace</tags>
</US_DocBloc>
--]]
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("EventManager_DebugMode_UserSpace", "index", "must be an integer", -1) return end
  local Value=reaper.GetExtState("ultraschall_eventmanager", "UserSpaces_"..index)
  local count=0
  local count2=1
  local Values={}
  local V
  Values[count2]={}
  for k in string.gmatch(Value, "(.-)\n") do
    count=count+1
    if count==1 then
      Values[count2]["index"]=k:match("index:(.*)")
    end
    if count==2 then
      Values[count2]["datatype"]=k:match("datatype:(.*)")
    end
    if count==3 then
      V=string.gsub(k, "\\\\n", "\0")
      V=string.gsub(V, "\\n", "\n")
      V=string.gsub(V, "\0", "\\n")
      Values[count2]["value"]=V:match("value:(.*)")
    end
    if count==4 then count=0 count2=count2+1 Values[count2]={} end
  end
  Values[count2]=nil
  if count2==1 then Values=nil end
  return count2-1, Values
end



function ultraschall.EventManager_Debug_GetExecutionTime()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_Debug_GetExecutionTime</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>number seconds_eventcheck_functions, number seconds_between_eventcheck_cycles = ultraschall.EventManager_Debug_GetExecutionTime()</functioncall>
  <description>
    Returns the numer of seconds it cost the last time all events were checked in the eventmanager.
    That way, you can benchmark, how much execution time the events need and optimise when needed.
    
    Needs DebugMode to be turned on.
    
    Note: Debugmode is not for productive usecases, as it costs resources. Please turn it off again, after you've finished debugging.
    
    return -1, if debugmode is off/eventmanager is not running
  </description>  
  <retvals>
    number seconds_eventcheck_functions - the number of seconds it took, for all event-check functions to check in the last event-check-cycle
    number seconds_between_eventcheck_cycles - the time between two event-check-cycles, usually when other actions are run
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, execution time, debug</tags>
</US_DocBloc>
--]]
  local exectime=tonumber(reaper.GetExtState("ultraschall_eventmanager", "Execution Time"))
  local exectime2=tonumber(reaper.GetExtState("ultraschall_eventmanager", "Execution Time Between EventCheckCycles"))  
  if exectime==nil then return -1 else return exectime, exectime2 end
end

function ultraschall.EventManager_GetAllEventIdentifier()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_GetAllEventIdentifier</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>table eventidentifier = ultraschall.EventManager_GetAllEventIdentifier()</functioncall>
  <description>
    Returns a list of all event-identifiers of all currently registered events.
  </description>
  <retvals>
    table eventidentifier - a table with all existing event-identifiers in order of registration
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, list, event identifier</tags>
</US_DocBloc>
--]]
  local EventIdent=reaper.GetExtState("ultraschall_eventmanager", "EventIdentifier")
  local EventIdentifier_Table={}
  for k in string.gmatch(EventIdent, "(.-)\n") do  
    EventIdentifier_Table[#EventIdentifier_Table+1]=k
  end
 
  return EventIdentifier_Table
end

function ultraschall.EventManager_GetAllEventNames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_GetAllEventNames</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>table eventnames = ultraschall.EventManager_GetAllEventNames()</functioncall>
  <description>
    Returns a list of all event-names of all currently registered events.
    
    The order is the same as the event-identifier returned by EventManager_GetAllEventIdentifier
  </description>
  <retvals>
    table eventidentifier - a table with all existing event-names
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, list, event names</tags>
</US_DocBloc>
--]]
  local EventNames=reaper.GetExtState("ultraschall_eventmanager", "EventNames")
  local EventEvents_Table={}
  for k in string.gmatch(EventNames, "(.-)\n") do  
    EventEvents_Table[#EventEvents_Table+1]=k
  end
 
  return EventEvents_Table
end

function ultraschall.EventManager_Debug_GetAllActionRunStates()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_Debug_GetAllActionRunStates</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>table runstates = ultraschall.EventManager_Debug_GetAllActionRunStates()</functioncall>
  <description>
    Returns a list of all events and if their actions have been run the last time the event was checked(true) or not(false).
    
    This way you can check, if the actions are properly executed.
    
    The order is the same as the event-identifier returned by EventManager_GetAllEventIdentifier
    
    Needs DebugMode to be turned on.
    
    Note: Debugmode is not for productive usecases, as it costs resources. Please turn it off again, after you've finished debugging.    
    
    return nil, if debug-mode is off
  </description>
  <retvals>
    table runstates - a table with all runstates of the actions of events, if they were run the last time(true) or not(false)
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, debug, list, event, runstates</tags>
</US_DocBloc>
--]]
  RunStates=reaper.GetExtState("ultraschall_eventmanager", "actions_run")
  if RunState=="" then return end
  local RunStates_Table={}
  for i, k in string.gmatch(RunStates, "(.-:) (.-)\n") do  
    RunStates_Table[#RunStates_Table+1]=toboolean(k)
  end
 
  return RunStates_Table
end



function ultraschall.EventManager_GetEventPausedState(id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_GetAllEventIdentifier</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean paused_state = ultraschall.EventManager_GetAllEventIdentifier()</functioncall>
  <description>
    Returns the paused-state of an registered event.
    
    Returns nil if no such event is registered.
  </description> 
  <retvals>
    boolean paused_state - true, event is paused; false, event is not paused; nil, no such event
  </retvals>  
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_EventManager.lua</source_document>
  <tags>event manager, get, paused state</tags>
</US_DocBloc>
--]]
  
  return toboolean(reaper.GetExtState("ultraschall_eventmanager", "Event_Pause"..id))
end
