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

if type(ultraschall)~="table" then
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "EventManager-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000
  else
    string=tonumber(string)
    string=string+1
  end
  if string2=="" then string2=10000
  else
    string2=tonumber(string2)
    string2=string2+1
  end
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  ultraschall={}

  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end

function ultraschall.EventManager_EnumerateStartupEvents(index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EventManager_EnumerateStartupEvents</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string EventIdentifier, string Eventname, string CallerScriptIdentifier, number CheckAllXSeconds, number CheckForXSeconds, boolean StartActionsOnceDuringTrue, function CheckFunction, number NumberOfActions, table Actions = ultraschall.EventManager_EnumerateStartupEvents(integer index)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
             ultraschall.ConvertFunction_FromBase64String(k:match("Function: (.-)\n")),
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
  <functioncall>integer index, string EventIdentifier, string Eventname, string CallerScriptIdentifier, number CheckAllXSeconds, number CheckForXSeconds, boolean StartActionsOnceDuringTrue, function CheckFunction, number NumberOfActions, table Actions = ultraschall.EventManager_EnumerateStartupEvents2(string EventIdentifier)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Enumerates already existing startupevents by an EventIdentifier.

    StartupEvents are events, that shall be automatically run at startup of the Ultraschall Event Manager.
    That means, if you start the EventManager, it will be started automatically to the EventManager-checking-queue, without the need of registering it by hand.

    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the identifier of the StartupEvent, that you want to enumerate
  </parameters>
  <retvals>
    integer index - the index of the StartUp-event, whose attributes you want to get; 1 for the first, etc
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
             ultraschall.ConvertFunction_FromBase64String(k:match("Function: (.-)\n")),
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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

Function: ]]..ultraschall.Base64_Encoder(string.dump(CheckFunction))..[[

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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <slug>Eventmanager_RemoveEvent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Eventmanager_RemoveEvent(string event_identifier)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, remove, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("Eventmanager_RemoveEvent", "", "Eventmanager not started yet", -1) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("Eventmanager_RemoveEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -2) return false end
  local OldRemoves=reaper.GetExtState("ultraschall_eventmanager", "eventremove")
  reaper.SetExtState("ultraschall_eventmanager", "eventremove", OldRemoves..EventIdentifier.."\n", false)
  return true
end

function ultraschall.EventManager_RemoveAllEvents_Script(ScriptIdentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Eventmanager_RemoveAllEvents_Script</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Eventmanager_RemoveAllEvents_Script(string ScriptIdentifier)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, remove, all events, scriptidentifier, event</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("Eventmanager_RemoveAllEvents_Script", "", "Eventmanager not started yet", -1) return false end
  if ScriptIdentifier~=nil and type(ScriptIdentifier)~="string" then ultraschall.AddErrorMessage("Eventmanager_RemoveAllEvents_Script", "ScriptIdentifier", "must be a string", -2) return false end
  if ScriptIdentifier==nil then ScriptIdentifier=ultraschall.ScriptIdentifier end
  if ScriptIdentifier:match("ScriptIdentifier:.-%-%{........%-....%-....%-....%-............%}%..*")==nil then ultraschall.AddErrorMessage("Eventmanager_RemoveAllEvents_Script", "ScriptIdentifier", "must be a valid ScriptIdentifier", -3) return false end
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
  <functioncall>string event_identifier = ultraschall.EventManager_SetEvent(string EventIdentifier, string EventName, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, table Actions)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the attributes of an already added event in the Ultraschall Event Manager-checking-queue.

    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the EventIdentifier of the registered event, which you want to set
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, add, new, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_SetEvent", "", "Eventmanager not started yet", -1) return false end
  if type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventName", "must be a string", -2) return false end
  if math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckAllXSeconds", "must be an integer; -1 for constant checking", -3) return false end
  if math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckForXSeconds", "must be an integer; -1 for infinite checking", -4) return false end
  if type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return false end
  if type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventPaused", "must be a boolean", -6) return false end
  if type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_SetEvent", "CheckFunction", "must be a function", -7) return false end
  if type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_SetEvent", "Actions", "must be a table", -8) return false end
  local A,B=ultraschall.EventManager_IsValidEventIdentifier(EventIdentifier)
  if B==false then ultraschall.AddErrorMessage("EventManager_SetEvent", "EventIdentifier", "must be a valid and used EventIdentifier", -9) return false end

  local EventStateChunk=""

  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[

Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..ultraschall.ScriptIdentifier..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.Base64_Encoder(string.dump(CheckFunction))..[[

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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
    function CheckFunction - the function, which shall check if the event occurred, as Base64-encoded string
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
             ultraschall.ConvertFunction_FromBase64String(k:match("Function: (.-)\n")),
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the attributes of an already added event in the Ultraschall Event Manager-checking-queue.

    returns nil in case of an error
  </description>
  <parameters>
    string Eventidentifier - the id of the currently registered event, of which you want to have the attributes; starting with 1 for the first
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
    function CheckFunction - the function, which shall check if the event occurred, as Base64-encoded string
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
             ultraschall.ConvertFunction_FromBase64String(k:match("Function: (.-)\n")),
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the number of currently registered events in the EventManager-checking-queue
  </description>
  <retvals>
    integer count_of_registered_events - the number of currently registered events
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  end
  local Registered=reaper.GetExtState("ultraschall_eventmanager", "registered_scripts")
  if Registered:match(ultraschall.ScriptIdentifier)==nil then
    Registered=Registered..ultraschall.ScriptIdentifier.."\n"
  end
  reaper.SetExtState("ultraschall_eventmanager", "registered_scripts", Registered, false)
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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

Function: ]]..ultraschall.Base64_Encoder(string.dump(CheckFunction))..[[

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
  <functioncall>boolean retval = ultraschall.Eventmanager_RemoveEvent2(integer id)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Counts the currently available startup-events
  </description>
  <retvals>
    integer count_startup_events - the number of currently available start-up-events for the EventManager
  </retvals>
  <chapter_context>
    Event Manager
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
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
  <functioncall>string event_identifier = ultraschall.EventManager_SetStartupEvent(string EventIdentifier, string EventName, integer CheckAllXSeconds, integer CheckForXSeconds, boolean StartActionsOnceDuringTrue, boolean EventPaused, function CheckFunction, table Actions)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets an already existing startupevent, that shall be automatically run at startup of the Ultraschall Event Manager.

    That means, if you start the EventManager, it will be started automatically to the EventManager-checking-queue, without the need of registering it by hand.

    returns nil in case of an error
  </description>
  <parameters>
    string EventIdentifier - the EventIdentifier of the startup-event, which you want to set
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
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>event manager, set, startup, event, function, actions, section, action</tags>
</US_DocBloc>
--]]
  --if reaper.GetExtState("ultraschall_eventmanager", "state")=="" then ultraschall.AddErrorMessage("EventManager_AddStartupEvent", "", "Eventmanager not started yet", -1) return end
  if type(EventIdentifier)~="string" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "must be a string", -1) return end
  if type(EventName)~="string" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventName", "must be a string", -2) return end
  if math.type(CheckAllXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckAllXSeconds", "must be an integer; -1 for constant checking", -3) return end
  if math.type(CheckForXSeconds)~="integer" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckForXSeconds", "must be an integer; -1 for infinite checking", -4) return end
  if type(StartActionsOnceDuringTrue)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "StartActionsOnceDuringTrue", "must be a boolean", -5) return end
  if type(EventPaused)~="boolean" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventPaused", "must be a boolean", -6) return end
  if type(CheckFunction)~="function" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "CheckFunction", "must be a function", -7) return end
  if type(Actions)~="table" then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "Actions", "must be a table", -8) return end

  if reaper.file_exists(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")==false then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "no such event", -9) return end

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

  if replace==nil then ultraschall.AddErrorMessage("EventManager_SetStartupEvent", "EventIdentifier", "no such event", -12) return end

  local EventStateChunk=""

  local ActionsCount = ultraschall.CountEntriesInTable_Main(Actions)
  local EventStateChunk2=[[
Eventname: ]]..EventName..[[

EventIdentifier: ]]..EventIdentifier..[[

SourceScriptIdentifier: ]]..ultraschall.ScriptIdentifier..[[

CheckAllXSeconds: ]]..CheckAllXSeconds..[[

CheckForXSeconds: ]]..CheckForXSeconds..[[

StartActionsOnceDuringTrue: ]]..tostring(StartActionsOnceDuringTrue)..[[

Paused: ]]..tostring(EventPaused)..[[

Function: ]]..ultraschall.Base64_Encoder(string.dump(CheckFunction))..[[

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
