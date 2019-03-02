dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


if reaper.GetExtState("ultraschall_event_manager", "running")=="running" then return end


function ReturnAllEventListener()
  local allevents=""
  reaper.SetExtState("ultraschall_event_manager", "allevents", "", false)
  for i=1, EventSectionsCount do
    allevents=allevents..EventSections[i][1].."\n"
  end
  reaper.SetExtState("ultraschall_event_manager", "allevents", allevents:sub(1,-2), false)
end

function StartAllEventListeners()
  for i=1, EventSectionsCount do
    StartEventListener(EventSections[i][1])
  end
  reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
end

function StopAllEventListeners()
  for i=1, EventSectionsCount do
    StopEventListener(EventSections[i][1])
  end
  reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
end

function ExitMe()
  ultraschall.StopDeferCycle(MyDeferID)
    
  StopAllEventListeners()
  
  reaper.DeleteExtState("ultraschall_event_manager", "allevents", false)
  reaper.DeleteExtState("ultraschall_event_manager", "event", false)
  reaper.DeleteExtState("ultraschall_event_manager", "eventstates", false)
  reaper.DeleteExtState("ultraschall_event_manager", "running", false)
end

function GetAllEvents()
  EventSections={}
  EventSectionsCount=0
  Events={}
  EventsCount=0
  
  filecount, files_array = ultraschall.GetAllFilenamesInPath(ultraschall.Api_Path.."/Scripts/Events/")
  for i=1, filecount do
    if files_array[i]:match(".-%.lua") or files_array[i]:match(".-%.eel") or files_array[i]:match(".-%.py") then
      A=ultraschall.ReadFullFile(files_array[i])
      EventSections[EventSectionsCount+1]={}
      EventSections[EventSectionsCount+1][1]=A:match("Ultraschall_Event_Section.-=.-\"(.-)\".-\n")
      EventSections[EventSectionsCount+1][2]=A:match("Ultraschall_Event_Description.-=.-\"(.-)\".-\n")
      if EventSections[EventSectionsCount+1]~=nil then EventSectionsCount=EventSectionsCount+1 end
      NumEvents=tonumber(A:match("Ultraschall_Events_Num=(.-)\n"))
      Events[EventSections[EventSectionsCount][1]]={}
      Events[EventSections[EventSectionsCount][1]]["script"]=files_array[i]
      Events[EventSections[EventSectionsCount][1]][0]=NumEvents
      for a=1, NumEvents do
        Events[EventSections[EventSectionsCount][1]][a]=A:match(".-Ultraschall_Event%["..a.."%]=\"(.-)\"\n")
      end
    end
  end
  ReturnAllEventListener()
end

function StartEventListener(Event)
  if Event~=nil and Events[Event]~=nil and Events[Event]["script"]~=nil and reaper.GetExtState(Event, "Old")=="" then
    retval = ultraschall.Main_OnCommandByFilename(Events[Event]["script"])
  end
end

function StopEventListener(Event)
  ScriptIdentifier=reaper.GetExtState(Event, "ScriptIdentifier")
  retval = ultraschall.StopDeferCycle(ScriptIdentifier..".defer_script01")
  reaper.DeleteExtState(Event, "Old", false)
  reaper.DeleteExtState(Event, "New", false)
  reaper.DeleteExtState(Event, "ScriptIdentifier", false)
end

function GetAllEventStates(Event)
  local eventstates=""
  B=Event
  if Event~=nil and Events[Event]~=nil and Events[Event]["script"]~=nil then
    for i=1, Events[Event][0] do
      if Events[Event][i]~=nil then eventstates=eventstates..Events[Event][i].."\n" end
    end
    reaper.SetExtState("ultraschall_event_manager", "eventstates", eventstates:sub(1,-2), false)
  else
  C1=reaper.time_precise()
    reaper.SetExtState("ultraschall_event_manager", "eventstates", "", false)
  end
end

GetAllEvents()


function main()
  -- update event-list, if new event-listener-scripts have been added
  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="update" then 
    GetAllEvents()
    reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
  end

  -- stops an event-listener to save resources  
  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="stop" then 
    StopEventListener(reaper.GetExtState("ultraschall_event_manager", "event"))    
    reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
  end
  
  -- starts an event-listener
  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="start" and
     reaper.GetExtState(reaper.GetExtState("ultraschall_event_manager", "event"), "ScriptIdentifier")=="" then
    StartEventListener(reaper.GetExtState("ultraschall_event_manager", "event"))
    reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
  elseif reaper.GetExtState("ultraschall_event_manager", "do_command")=="start" then
    -- if event does not exist in the list, don't do anything
    reaper.SetExtState("ultraschall_event_manager", "do_command", "", false)
  end

  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="startall" then
    StartAllEventListeners()
  end
  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="stopall" then
    StopAllEventListeners()
  end

  -- if the selected event has been changed, set the all-event-states-extstate for external access
  event=reaper.GetExtState("ultraschall_event_manager", "event")
  if oldevent~=event then
    GetAllEventStates(event)
  end
  oldevent=event
  
  Retval, MyDeferID = ultraschall.Defer1(main)
  
  if reaper.GetExtState("ultraschall_event_manager", "do_command")=="stop_eventlistener" then
    ultraschall.StopDeferCycle(MyDeferID)
  end
end

reaper.SetExtState("ultraschall_event_manager", "running", "running", false)
reaper.atexit(ExitMe)


main()
