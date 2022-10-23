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

-- Event Manager - 1.2
-- Meo Mespotine
--
-- Issues: Api functions don't recognize registered EventIdentifiers who weren't processed yet by the EventManager.
--         Must be fixed
--         Lua functions, who are stored as binary-chunks, are not crossplatform-compatible(really ?). Important for StartUp-Events!
--
-- ToDo: 1) Allow getting event-states and attributes within EventManager using internal functions, instead of "official" functions
--          That way, checkfunctions can be "meta-functions" who react to multiple event-check-state-combinations with better performance
--       2) Use functions instead of actions, for quick state-changes for whom using actions would be overkill
--       3) Allow using sourcecode-functions, not only binary chunks


--[[
EventStateChunk-specs:

  Eventname: Textoneliner; 
             a name for this event for better identification later on
  EventIdentifier: identifier-oneliner-guid; 
                   a unique identifier for this event
  SourceScriptIdentifier: identifier-guid; 
                          the Scriptidentifier of the script, which added the event
  CheckAllXSeconds: number; 
                    the number of seconds inbetween checks; 0, check every defercycle
  CheckForXSeconds: number; 
                    the number of seconds to check for this event; 0, until stopped
  StartActionsOnceDuringTrue: boolean;  
                              true, run the actions only once when event occured(checkfunction=true); 
                              false, run the actions again and again until eventcheck returns false
  Paused: boolean, 
          if the eventcheck is currently paused or not
  Function: Hexstring-oneliner
            the Lua-binary-function as Hex-encoded string
  CountOfActions: number; 
                  number of actions to run if event happens

The following as often as CountOfActions says
  Action: number; 
          the action command number of the action to run
  Section: number; 
           the section of the action to run

Example:

Eventname: Tudelu
EventIdentifier: {D0FB8CE2-FFFD-40CB-9AF6-8C6FE121330B}
SourceScriptIdentifier: ScriptIdentifier-{C47C1F6A-5CAC-4B48-A0DD-760A62246D6B}
CheckAllXSeconds: 1
CheckForXSeconds: 10
StartActionsOnceDuringTrue: true
Paused: false
Function: G0x1YVMAGZMNChoKBAgECAh4VgAAAAAAAAAAAAAAKHdAAXpAQzpcVWx0cmFzY2hhbGwtSGFja3ZlcnNpb25fMy4yX1VTX2JldGFfMl83N1xTY3JpcHRzXC4uXFVzZXJQbHVnaW5zXHVsdHJhc2NoYWxsX2FwaVxcU2NyaXB0c1x1bHRyYXNjaGFsbF9FdmVudE1hbmFnZXIubHVhDAAAABIAAAAAAAILAAAABgBAAAdAQAAkgIAAH4BAAB6AAIADAIAAJgAAAR5AAIADAAAAJgAAASYAgAADAAAABAdyZWFwZXIEDUdldFBsYXlTdGF0ZRMBAAAAAAAAAAEAAAAAAAAAAAALAAAADQAAAA0AAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAQAAAAEAAAABIAAAAAAAAAAQAAAAVfRU4=
CountOfActions: 2
Action: 40105
Section: 0
Action: 40105
Section: 0
--]]
deferoffset=0.130 -- the offset of delay, introduced by the defer-management of Reaper. Maybe useless?

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

EventTable={}
Event_RunState_ForDebug={}
CountOfEvents=0

function DebugDummy()
end

function DebugRun(eventnumber, run)
  UserSpaces=EventTable[eventnumber]["UserSpace"]
  local UserSpace=""
  for k,v in pairs(UserSpaces) do
    UserSpace=UserSpace.."index:"..tostring(k).."\ndatatype:"..ultraschall.type(v).."\nvalue:"..string.gsub(string.gsub(tostring(v),"\\n","\\\\n"),"\n","\\n").."\n\n"
  end
  if UserSpace~=nil then 
    reaper.SetExtState("ultraschall_eventmanager", "UserSpaces_"..eventnumber, UserSpace, false) 
  end  
end

Debug=DebugDummy

function atexit()
  -- reset EventManager-extstates, when EventManager is stopped
  reaper.DeleteExtState("ultraschall_eventmanager", "running", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "eventregister", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "eventremove", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "eventset", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "eventpause", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "eventresume", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "state", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "registered_scripts", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "Execution Time", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "EventNames", false)
  reaper.DeleteExtState("ultraschall_eventmanager", "EventIdentifier", false)
  for i=1, CountOfEvents do
    reaper.DeleteExtState("ultraschall_eventmanager", "checkfunction_returnstate"..i, false)
    reaper.DeleteExtState("ultraschall_eventmanager", "Event_Pause"..i, false)
  end
end

reaper.atexit(atexit)

OPO = reaper.SetExtState("ultraschall_eventmanager", "running", "true", false)

function GetIDFromEventIdentifier(EventIdentifier)
  -- get the ID in the EventTable, from an EventIdentifier
  for i=1, CountOfEvents do
    if EventTable[i]["EventIdentifier"]==EventIdentifier then
      return i
    end
  end
  return -1
end

function PauseEvent(id)
  -- pauses an event by ID of a EventTable
  EventTable[id]["Paused"]=true
  reaper.SetExtState("ultraschall_eventmanager", "Event_Pause"..id, "true", false)
  UpdateEventList_ExtState()
end

function ResumeEvent(id)
  -- resumes an event by ID of a EventTable
  EventTable[id]["Paused"]=false
  reaper.SetExtState("ultraschall_eventmanager", "Event_Pause"..id, "false", false)
  UpdateEventList_ExtState()
end

function CheckAndSetRetvalOfCheckFunction(id, state)
 -- store the current eventcheck-function-returnstate in extstate, if it changes
 -- also stores the EventIdentifier
  if EventTable[id]["eventstate"]~=state then
    EventTable[id]["eventstate"]=state
    reaper.SetExtState("ultraschall_eventmanager", "checkfunction_returnstate"..id, tostring(state).."\n"..reaper.time_precise().."\n"..EventTable[id]["EventIdentifier"], false)
  end
end

function ClearAllCheckfunctionRetvals()
  -- resets all checkstates, so the checkstates in the extstate "ultraschall_eventmanager", "checkfunction_returnstate"..id 
  -- are updated properly
  for i=1, CountOfEvents do
    EventTable[i]["eventstate"]=nil
  end
end

function RemoveEvent_ScriptIdentifier2(ScriptIdentifier)
  -- removes all events, started by a specific Script with a specific ScriptIdentifier
  -- if number of available events is 0 then this stops the EventManager as well.
  for i=CountOfEvents, 1, -1 do
    if ScriptIdentifier==EventTable[i]["ScriptIdentifier"] then
      --print(ScriptIdentifier,EventTable[i]["ScriptIdentifier"])
      table.remove(EventTable, i)
      CountOfEvents=CountOfEvents-1
    end
  end
  if CountOfEvents==0 then reaper.DeleteExtState("ultraschall_eventmanager", "running", false) end
  ClearAllCheckfunctionRetvals()
  UpdateEventList_ExtState()
end

function RemoveEvent_ScriptIdentifier(script_identifier)
  -- removes all events, started by a specific Script with a specific ScriptIdentifier
  for i=CountOfEvents, 1, -1 do
    if EventTable[i]["ScriptIdentifier"]==script_identifier then
      table.remove(EventTable,i)
      CountOfEvents=CountOfEvents-1
    end
  end
  ClearAllCheckfunctionRetvals()
  UpdateEventList_ExtState()
end

function PauseEvent_Identifier(identifier)
-- pause event by EventIdentifier
  for i=1, CountOfEvents do
    if EventTable[i]["EventIdentifier"]==identifier then
      PauseEvent(i)
      break
    end
  end
end

function ResumeEvent_Identifier(identifier)
-- remove event by EventIdentifier
  for i=1, CountOfEvents do
    if EventTable[i]["EventIdentifier"]==identifier then
      ResumeEvent(i)
      break
    end
  end
end


function AddEvent(EventStateChunk)
  -- Adds a new event to the EventTable from an EventStateChunk
  
  -- parse EventStateChunk
  local EventName=EventStateChunk:match("Eventname: (.-)\n")
  local EventIdentifier=EventStateChunk:match("EventIdentifier: (.-)\n")
  local SourceScriptIdentifier=EventStateChunk:match("SourceScriptIdentifier: (.-)\n")
  local CheckAllXSeconds=tonumber(EventStateChunk:match("CheckAllXSeconds: (.-)\n"))
  local CheckForXSeconds=tonumber(EventStateChunk:match("CheckForXSeconds: (.-)\n"))
  local StartActionsOnceDuringTrue=toboolean(EventStateChunk:match("StartActionsOnceDuringTrue: (.-)\n"))
  local Function=EventStateChunk:match("Function: (.-)\n")
  local Paused=toboolean(EventStateChunk:match("Paused: (.-)\n()"))
  --print(Paused)
  local CountOfActions,offset=EventStateChunk:match("CountOfActions: (.-)\n()")  
  local CountOfActions=tonumber(CountOfActions)
  
  -- if EventStateChunk is missing stuff, throw an error and don't try to add the event further
  if EventName==nil or
     EventIdentifier==nil or
     SourceScriptIdentifier==nil or
     CheckAllXSeconds==nil or
     CheckForXSeconds==nil or
     StartActionsOnceDuringTrue==nil or
     Function==nil or
     CountOfActions==nil then
      print("An error happened, while adding the event to the eventmanager. Please report this as a bug to me: \n\n\t\tultraschall.fm/api \n\nPlease include the following lines in your bugreport(screenshot is sufficient): \n\n"..EventStateChunk)
      return
  end
  local actions=EventStateChunk:sub(offset,-1)
  
  -- parse actionlist from the EventStateChunk
  -- if there's an invalid entry, throw an error and don't try to add the event further
  local ActionsTable={}
  for i=1, CountOfActions do
    ActionsTable[i]={}
    ActionsTable[i]["action"], ActionsTable[i]["section"], offset=actions:match("Action: (.-)\nSection: (.-)\n()")
    if ActionsTable[i]["action"]:sub(1,1)=="_" then
      temp=reaper.NamedCommandLookup(ActionsTable[i]["action"])      
      if temp==0 then 
        print("This action is not registered currently in Reaper:"..ActionsTable[i]["section"].." - "..ActionsTable[i]["action"].."\nEvent not added.\n")
        return
      else
        ActionsTable[i]["action"]=temp
      end
    end
    ActionsTable[i]["action"]=tonumber(ActionsTable[i]["action"])
    ActionsTable[i]["section"]=tonumber(ActionsTable[i]["section"])
    --print2(ActionsTable[i]["action"].." hiu")
    if ActionsTable[i]["section"]==nil or ActionsTable[i]["action"]==nil then
      print(ActionsTable[i]["section"], ActionsTable[i]["action"])
      print("An error happened, while adding the event to the eventmanager. Please report this as a bug to me: \n\n\t\tultraschall.fm/api \n\nPlease include the following lines in your bugreport(screenshot is sufficient): \n\n"..EventStateChunk)
      return
    end
    actions=actions:sub(offset,-1)
  end
  
  
  -- add the event to the EventManager-table
  CountOfEvents=CountOfEvents+1
  EventTable[CountOfEvents]={}
  -- Attributes
  EventTable[CountOfEvents]["EventName"]=EventName                                  -- the name of the event, can happen multiple times
  EventTable[CountOfEvents]["Function"]=load(ultraschall.ConvertHex2Ascii(Function))-- the checking function
  EventTable[CountOfEvents]["FunctionOrg"]=Function                                 -- the Hex-encoded version of the checking-function
  EventTable[CountOfEvents]["CheckAllXSeconds"]=CheckAllXSeconds                    -- check all X seconds; 0 for constant checking; only approximate time due API restrictions
  EventTable[CountOfEvents]["CheckAllXSeconds_current"]=nil                         -- current checking time(internal value), to check agains if CheckAllXSeconds has been reached
  EventTable[CountOfEvents]["CheckForXSeconds"]=CheckForXSeconds                    -- check for X seconds; 0 for unlimited checking; only approximate time due API restrictions
  EventTable[CountOfEvents]["CheckForXSeconds_current"]=nil                         -- current stop-timeout-time(internal value), to check agains if CheckForXSeconds has been reached
  EventTable[CountOfEvents]["StartActionsOnceDuringTrue"]=StartActionsOnceDuringTrue-- shall the actions run only once(true) or constantly while checkfunction returns true(false)
  EventTable[CountOfEvents]["StartActionsOnceDuringTrue_laststate"]=false           -- StartActionsOnceDuringTrue laststate(internal value); for state-transitions
  EventTable[CountOfEvents]["ScriptIdentifier"]=SourceScriptIdentifier              -- ScriptIdentifier of the script, which added the Event; to stop all events of a specific script if needed
  EventTable[CountOfEvents]["EventIdentifier"]=EventIdentifier                      -- unique identifier for this event
  EventTable[CountOfEvents]["CountOfActions"]=CountOfActions                        -- number of actions that shall be run by this event
  EventTable[CountOfEvents]["Paused"]=Paused                                        -- paused-state; true, event is not checked currently; false, event is checked currently
  EventTable[CountOfEvents]["UserSpace"]={}                                         -- the userspace for the checking-function, into which the checking-function can add temporary information
  
  reaper.SetExtState("ultraschall_eventmanager", "Event_Pause"..CountOfEvents, tostring(Paused), false)
  
  -- add the actions and sections
  for i=1, CountOfActions do
    EventTable[CountOfEvents][i]=ActionsTable[i]["action"]
    EventTable[CountOfEvents]["sec"..i]=ActionsTable[i]["section"]
  end
  CheckAndSetRetvalOfCheckFunction(CountOfEvents, false)
  UpdateEventList_ExtState() -- update the EventList-extstate, which is used by Enumerate-functions of the EventManager-API-functions
end

function SetEvent(EventStateChunk)
  -- sets attributes of an already existing event by an EventStateChunk
  
  -- parse the EventStateChunk
  local EventName=EventStateChunk:match("Eventname: (.-)\n")
  local EventIdentifier=EventStateChunk:match("EventIdentifier: (.-)\n")
  local SourceScriptIdentifier=EventStateChunk:match("SourceScriptIdentifier: (.-)\n")
  local CheckAllXSeconds=tonumber(EventStateChunk:match("CheckAllXSeconds: (.-)\n"))
  local CheckForXSeconds=tonumber(EventStateChunk:match("CheckForXSeconds: (.-)\n"))
  local StartActionsOnceDuringTrue=toboolean(EventStateChunk:match("StartActionsOnceDuringTrue: (.-)\n"))
  local Function=EventStateChunk:match("Function: (.-)\n")
  local Paused=toboolean(EventStateChunk:match("Paused: (.-)\n()"))
  local CountOfActions,offset=EventStateChunk:match("CountOfActions: (.-)\n()")  
  local CountOfActions=tonumber(CountOfActions)
  
  -- if any attribute is missing, throw an error and stop setting this event
  if EventName==nil or
     EventIdentifier==nil or
     SourceScriptIdentifier==nil or
     CheckAllXSeconds==nil or
     CheckForXSeconds==nil or
     StartActionsOnceDuringTrue==nil or
     Function==nil or
     CountOfActions==nil then
      print("An error happened, while setting the event in the eventmanager. Please report this as a bug to me: \n\n\t\tultraschall.fm/api \n\nPlease include the following lines in your bugreport(screenshot is sufficient): \n\n"..EventStateChunk)
      return
  end
  local actions=EventStateChunk:sub(offset,-1)

  -- parse actions and accompanying sections for this event from the EventStateChunk 
  -- if any action is invalid, throw an error and stop setting this event
  local ActionsTable={}
  for i=1, CountOfActions do
    ActionsTable[i]={}
    ActionsTable[i]["action"], ActionsTable[i]["section"], offset=actions:match("Action: (.-)\nSection: (.-)\n()")
    if ActionsTable[i]["action"]:sub(1,1)=="_" then
      temp=reaper.NamedCommandLookup(ActionsTable[i]["action"])      
      if temp==0 then 
        print("This action is not registered currently in Reaper:"..ActionsTable[i]["section"].." - "..ActionsTable[i]["action"].."\nEvent not added.\n")
        return
      else
        ActionsTable[i]["action"]=temp
      end
    end
    ActionsTable[i]["action"]=tonumber(ActionsTable[i]["action"])
    ActionsTable[i]["section"]=tonumber(ActionsTable[i]["section"])
    if ActionsTable[i]["section"]==nil or ActionsTable[i]["action"]==nil then
      print(ActionsTable[i]["section"], ActionsTable[i]["action"])
      print("An error happened, while setting the event in the eventmanager. Please report this as a bug to me: \n\n\t\tultraschall.fm/api \n\nPlease include the following lines in your bugreport(screenshot is sufficient): \n\n"..EventStateChunk)
      return
    end
    actions=actions:sub(offset,-1)
  end

  
  EventID=GetIDFromEventIdentifier(EventIdentifier)
  if EventID==-1 then return end
  -- Attributes
  EventTable[EventID]["EventName"]=EventName                                    -- the name of the event, can happen multiple times
  EventTable[EventID]["Function"]=load(ultraschall.ConvertHex2Ascii(Function))  -- the checking function
  EventTable[EventID]["FunctionOrg"]=Function                                   -- the Hex-encoded version of the checking-function
  EventTable[EventID]["CheckAllXSeconds"]=CheckAllXSeconds                      -- check all X seconds; 0 for constant checking; only approximate time due API restrictions
  EventTable[EventID]["CheckAllXSeconds_current"]=nil                           -- current checking time(internal value), to check agains if CheckAllXSeconds has been reached
  EventTable[EventID]["CheckForXSeconds"]=CheckForXSeconds                      -- check for X seconds; 0 for unlimited checking; only approximate time due API restrictions        
  EventTable[EventID]["CheckForXSeconds_current"]=nil                           -- current stop-timeout-time(internal value), to check agains if CheckForXSeconds has been reached
  EventTable[EventID]["StartActionsOnceDuringTrue"]=StartActionsOnceDuringTrue  -- shall the actions run only once(true) or constantly while checkfunction returns true(false) 
  EventTable[EventID]["StartActionsOnceDuringTrue_laststate"]=false             -- StartActionsOnceDuringTrue laststate(internal value); for state-transitions
  EventTable[EventID]["ScriptIdentifier"]=SourceScriptIdentifier                -- ScriptIdentifier of the script, which added the Event; to stop all events of a specific script if needed
  EventTable[EventID]["CountOfActions"]=CountOfActions                          -- number of actions that shall be run by this event
  EventTable[EventID]["Paused"]=Paused                                          -- paused-state; true, event is not checked currently; false, event is checked currently
  EventTable[EventID]["UserSpace"]={}                                           -- the userspace for the checking-function, into which the checking-function can add temporary information
  
  -- add the actions and sections  
  for i=1, CountOfActions do
    EventTable[EventID][i]=ActionsTable[i]["action"]
    EventTable[EventID]["sec"..i]=ActionsTable[i]["section"]
  end
  UpdateEventList_ExtState() -- update the EventList-extstate, which is used by Enumerate-functions of the EventManager-API-functions
end

function RemoveEvent_ID(id)
-- remove event by id in the EventTable
  table.remove(EventTable, id)
  CountOfEvents=CountOfEvents-1
  ClearAllCheckfunctionRetvals()
  UpdateEventList_ExtState()
end

function RemoveEvent_Identifier(identifier)
-- remove event by EventIdentifier
  for i=1, CountOfEvents do
    if EventTable[i]["EventIdentifier"]==identifier then
      table.remove(EventTable,i)
      CountOfEvents=CountOfEvents-1
      break
    end
  end
  ClearAllCheckfunctionRetvals()
  UpdateEventList_ExtState()
end

function RemoveEvent_ScriptIdentifier(script_identifier)
-- remove event by script_identifier
  for i=CountOfEvents, 1, -1 do
    if EventTable[i]["ScriptIdentifier"]==script_identifier then
      table.remove(EventTable,i)
      CountOfEvents=CountOfEvents-1
    end
  end
  ClearAllCheckfunctionRetvals()
  UpdateEventList_ExtState()
end


function CheckCommandsForEventManager()
  -- check for commands, send to the EventManager by multiple scripts

  -- Add Events
  if reaper.GetExtState("ultraschall_eventmanager", "eventregister")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventregister")
    for k in string.gmatch(StateRegister, "(.-\n)EndEvent\n") do
      AddEvent(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventregister", "", false)
  end
  
  
  -- Delete Events
  if reaper.GetExtState("ultraschall_eventmanager", "eventremove")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventremove")
    for k in string.gmatch(StateRegister, "(.-)\n") do
      RemoveEvent_Identifier(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventremove", "", false)
  end

  -- Set Events
  if reaper.GetExtState("ultraschall_eventmanager", "eventset")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventset")
    for k in string.gmatch(StateRegister, "(.-\n)EndEvent\n") do
      SetEvent(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventset", "", false)
  end
  
  -- Pause Events
  if reaper.GetExtState("ultraschall_eventmanager", "eventpause")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventpause")
    for k in string.gmatch(StateRegister, "(.-)\n") do
      PauseEvent_Identifier(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventpause", "", false)
  end
  
  -- Resume Events
  if reaper.GetExtState("ultraschall_eventmanager", "eventresume")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventresume")
    for k in string.gmatch(StateRegister, "(.-)\n") do
      ResumeEvent_Identifier(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventresume", "", false)
  end  
  
  -- Remove all Events registered by a certain ScriptIdentifier
  if reaper.GetExtState("ultraschall_eventmanager", "eventremove_scriptidentifier")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventremove_scriptidentifier")
    for k in string.gmatch(StateRegister, "(.-)\n") do
      --print2(k)
      RemoveEvent_ScriptIdentifier(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventremove_scriptidentifier", "", false)
  end  
  
  -- Stop Eventmanager for a certain SciptIdentifier, Remove all Events registered by a certain ScriptIdentifier
  if reaper.GetExtState("ultraschall_eventmanager", "eventstop_scriptidentifier")~="" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "eventstop_scriptidentifier")
    for k in string.gmatch(StateRegister, "(.-)\n") do
      RemoveEvent_ScriptIdentifier2(k)
    end
    reaper.SetExtState("ultraschall_eventmanager", "eventstop_scriptidentifier", "", false)
  end  

-- debug-functions
  if reaper.GetExtState("ultraschall_eventmanager", "debugmode")=="doit" then
    StateRegister=reaper.GetExtState("ultraschall_eventmanager", "debugmode")
    Debug=DebugRun
    --reaper.SetExtState("ultraschall_eventmanager", "debugmode", "", false)
  elseif reaper.GetExtState("ultraschall_eventmanager", "debugmode")=="stopit" then
    reaper.SetExtState("ultraschall_eventmanager", "checkstates", "", false)
    Debug=DebugDummy
    reaper.SetExtState("ultraschall_eventmanager", "debugmode", "", false)
    reaper.SetExtState("ultraschall_eventmanager", "Execution Time", "", false)
  end  
end


exectime=0

function main()
  -- main event-checking-loop
  -- this is, were all the magix happens
  current_state=nil    
  if reaper.GetExtState("ultraschall_eventmanager", "debugmode")=="doit" then    
    reaper.SetExtState("ultraschall_eventmanager", "Execution Time Between EventCheckCycles", (reaper.time_precise()-exectime), false)
    exectime=reaper.time_precise()
  end
  
  CheckCommandsForEventManager()
 
  for i=1, CountOfEvents do
    if EventTable[i]["Paused"]==false then
    --print2(i, EventTable[i]["Paused"])
        doit=false
        -- check every x second
        if EventTable[i]["CheckAllXSeconds"]~=0 and EventTable[i]["CheckAllXSeconds_current"]==nil then
          -- set timer to the time, when the check shall be done
          EventTable[i]["CheckAllXSeconds_current"]=reaper.time_precise()+EventTable[i]["CheckAllXSeconds"]
          doit=false
        elseif EventTable[i]["CheckAllXSeconds_current"]~=nil 
              and EventTable[i]["CheckAllXSeconds"]~=0 and 
              EventTable[i]["CheckAllXSeconds_current"]<reaper.time_precise()-deferoffset then
          -- if timer is up, start the check
          EventTable[i]["CheckAllXSeconds_current"]=nil
          doit=true
        elseif EventTable[i]["CheckAllXSeconds"]==0 then
          -- if no timer is set at all for this event, run all actions
          doit=true
        end
      if doit==true then
        state_retval, current_state=pcall(EventTable[i]["Function"], EventTable[i]["UserSpace"])
        Debug(i)
        Event_RunState_ForDebug[i]=false
        CheckAndSetRetvalOfCheckFunction(i, current_state)
        if state_retval==false then 
          PauseEvent(i)
          print("Error in eventchecking-function", "Event: "..EventTable[i]["EventName"], EventTable[i]["EventIdentifier"], "Error: "..current_state, "Eventchecking for this event paused", " ")
        else     
          -- let's run the actions, if requested
          if current_state==true and doit==true then
              if EventTable[i]["StartActionsOnceDuringTrue"]==false then
                -- if actions shall be only run as long as the event happens
                for a=1, EventTable[i]["CountOfActions"] do
                  --A=reaper.time_precise()
                  if EventTable[i]["sec"..a]==0 then
                    reaper.Main_OnCommand(EventTable[i][a],0)
                    Event_RunState_ForDebug[i]=true
                  elseif EventTable[i]["sec"..a]==32063 then
                    retval = ultraschall.MediaExplorer_OnCommand(EventTable[i][a])
                    Event_RunState_ForDebug[i]=true
                  end
                end
              elseif EventTable[i]["StartActionsOnceDuringTrue"]==true and EventTable[i]["StartActionsOnceDuringTrue_laststate"]==false then
                -- if actions shall be only run once, when event-statechange happens
                for a=1, EventTable[i]["CountOfActions"] do
                  A=reaper.time_precise()
                  if EventTable[i]["sec"..a]==0 then
                    reaper.Main_OnCommand(EventTable[i][a],0)
                    Event_RunState_ForDebug[i]=true
                  elseif EventTable[i]["sec"..a]==32063 then
                    retval = ultraschall.MediaExplorer_OnCommand(EventTable[i][a])
                    Event_RunState_ForDebug[i]=true
                  end
                end
              end
              EventTable[i]["StartActionsOnceDuringTrue_laststate"]=true        
          else
            -- if no event shall be run, set laststate of StartActionsOnceDuringTrue_laststate to false
            EventTable[i]["StartActionsOnceDuringTrue_laststate"]=false
          end    
          
          -- check for x seconds, then remove the event from the list
          if EventTable[i]["CheckForXSeconds"]~=0 and EventTable[i]["CheckForXSeconds_current"]==nil then
            -- set timer, for when the checking shall be finished and the event being removed
            EventTable[i]["CheckForXSeconds_current"]=reaper.time_precise()+EventTable[i]["CheckForXSeconds"]
          elseif EventTable[i]["CheckForXSeconds_current"]~=nil and EventTable[i]["CheckForXSeconds"]~=0 and EventTable[i]["CheckForXSeconds_current"]<=reaper.time_precise()-deferoffset then
            -- if the timer for checking for this event is up, remove the event
            RemoveEvent_ID(i)
            break
          end
        end
      end
    end
  end
  
  

  if enditall~=true then 
    -- if StopEvent hasn't been called yet, keep the eventmanager going
    
    if reaper.GetExtState("ultraschall_eventmanager", "debugmode")=="doit" then
      reaper.SetExtState("ultraschall_eventmanager", "Execution Time", (reaper.time_precise()-exectime), false)
      exectime=reaper.time_precise()
      local Event_RunState_ForDebug_String=""
      for i=1, #Event_RunState_ForDebug do
        Event_RunState_ForDebug_String=Event_RunState_ForDebug_String..i..": "..tostring(Event_RunState_ForDebug[i]).."\n"
        Event_RunState_ForDebug[i]=false
      end
      reaper.SetExtState("ultraschall_eventmanager", "actions_run", Event_RunState_ForDebug_String, false)
    end
    if reaper.HasExtState("ultraschall_eventmanager", "running")==true then      
      reaper.defer(main) 
    end
    --UpdateEventList_ExtState() 
  end
end

function UpdateEventList_ExtState()
  -- puts all current events and their attributes into an extstate, which can be read from other scripts
  local String="EventManager State\nLast update: "..os.date().." - "..reaper.time_precise().."\nNumber of Events: "..CountOfEvents.."\n\n"
  local EventIdentifier=""
  local EventNames=""
  for i=1, CountOfEvents do
    EventIdentifier=EventIdentifier..EventTable[i]["EventIdentifier"].."\n"
    EventNames=EventNames..EventTable[i]["EventName"].."\n"
    String=String.."Event #:"..i..
        "\nEventName: "..EventTable[i]["EventName"]..
        "\nEventIdentifier: "..EventTable[i]["EventIdentifier"]..
        "\nStartedByScript: "..EventTable[i]["ScriptIdentifier"]..
        "\nCheckAllXSeconds: "..EventTable[i]["CheckAllXSeconds"]..
        "\nCheckForXSeconds: "..EventTable[i]["CheckForXSeconds"]..
        "\nEventPaused: "..tostring(EventTable[i]["Paused"])..
        "\nStartActionsOnlyOnceDuringTrue: "..tostring(EventTable[i]["StartActionsOnceDuringTrue"])..
        "\nFunction: ".. EventTable[CountOfEvents]["FunctionOrg"]..
        "\nNumber of Actions: "..EventTable[i]["CountOfActions"].."\n"
        for a=1, EventTable[i]["CountOfActions"] do
          String=String..
                  a..
                  " - "..
                  " section: "..
                  EventTable[i]["sec"..a]..
                  " action: "..
                  EventTable[i][a]..
                  "\n"
        end
        String=String.."EndEvent".."\n"
  end
  reaper.SetExtState("ultraschall_eventmanager", "state", String, false)
  reaper.SetExtState("ultraschall_eventmanager", "EventIdentifier", EventIdentifier, false)  
  reaper.SetExtState("ultraschall_eventmanager", "EventNames", EventNames, false)
end

function StopAction()
  -- stops the eventmanager and clears up behind it

  EventTable=""
  reaper.SetExtState("ultraschall_eventmanager", "state", "", false)
  enditall=true
end



function InitialiseStartupEvents()
  -- load events stored in the EventManager_Startup.ini, who will be started immediately at startup of the EventManager
  StartUp=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/EventManager_Startup.ini")
  if StartUp==nil then StartUp="" end
  for k in string.gmatch(StartUp, "(.-EndEvent)") do
    AddEvent(k)
  end
  
end

reaper.DeleteExtState("ultraschall_eventmanager", "eventstop_scriptidentifier", false) -- reset eventstop_scriptidentifier, 
                                                                                       -- as otherwise, if this is set at startup of the EventManager, 
                                                                                       -- it is stopped immediately again
InitialiseStartupEvents()  -- load StartUp Events
UpdateEventList_ExtState() -- update the EventList-extstate, which is used by Enumerate-functions of the EventManager-API-functions
main()                     -- start the checking

