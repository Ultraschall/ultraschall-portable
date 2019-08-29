Ultraschall_Event_Section="LoopState"
Ultraschall_Event_Section_Description="returns the current and previous loopstate"
Ultraschall_Events_Num=2
Ultraschall_Event={}
Ultraschall_Event[1]="LOOPED"
Ultraschall_Event[2]="UNLOOPED"

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


function StateConverter(state)
  if state==0 then return "UNLOOPED" else return "LOOPED" end
end

--ultraschall.ResetEvent(Ultraschall_Event_Section)


--ultraschall.RegisterEvent(Ultraschall_Event_Section, "LOOPED")
--ultraschall.RegisterEvent(Ultraschall_Event_Section, "UNLOOPED")

OldState=ultraschall.GetLoopState()
ultraschall.SetEventState(Ultraschall_Event_Section, StateConverter(OldState), StateConverter(OldState))


function main()
  NewState=ultraschall.GetLoopState()
  
  if OldState~=NewState then 
    ultraschall.SetEventState(Ultraschall_Event_Section, StateConverter(OldState), StateConverter(NewState))
  end
  OldState=NewState
  
  ultraschall.Defer1(main)
end

--reaper.atexit(ultraschall.ResetEvent)
main()

