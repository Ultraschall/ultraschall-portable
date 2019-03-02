Ultraschall_Event_Section="PlayState"
Ultraschall_Event_Section_Description="returns the current and previous playstate"
Ultraschall_Events_Num=5
Ultraschall_Event={}
Ultraschall_Event[1]="STOP"
Ultraschall_Event[2]="PLAY"
Ultraschall_Event[3]="PLAYPAUSE"
Ultraschall_Event[4]="REC"
Ultraschall_Event[5]="RECPAUSE"

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function StateConverter(state)
  if state==0 then return "STOP"
  elseif state==1 then return "PLAY"
  elseif state==2 then return "PLAYPAUSE"
  elseif state==5 then return "REC"
  elseif state==6 then return "RECPAUSE"
  end
end


--ultraschall.ResetEvent(Ultraschall_Event_Section)

--ultraschall.RegisterEvent(Ultraschall_Event_Section, "STOP")
--ultraschall.RegisterEvent(Ultraschall_Event_Section, "PLAY")
--ultraschall.RegisterEvent(Ultraschall_Event_Section, "PLAYPAUSE")
--ultraschall.RegisterEvent(Ultraschall_Event_Section, "REC")
--ultraschall.RegisterEvent(Ultraschall_Event_Section, "RECPAUSE")

OldState=reaper.GetPlayState()
ultraschall.SetEventState(Ultraschall_Event_Section, StateConverter(OldState), StateConverter(OldState))

function main()
  NewState=reaper.GetPlayState()
  
  if OldState~=NewState then 
    ultraschall.SetEventState(Ultraschall_Event_Section, StateConverter(OldState), StateConverter(NewState))
  end
  OldState=NewState
  
  ultraschall.Defer1(main)
end

--reaper.atexit(ultraschall.ResetEvent)

main()

