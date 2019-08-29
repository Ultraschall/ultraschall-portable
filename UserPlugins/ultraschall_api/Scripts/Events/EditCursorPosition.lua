Ultraschall_Event_Section="EditCursorPosition"
Ultraschall_Event_Section_Description="shows the current editcursor-position plus the one before."
Ultraschall_Events_Num=1
Ultraschall_Event={}
Ultraschall_Event[1]="number"

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function cleanup()
  ultraschall.ResetEvent(Ultraschall_Event_Section)
end

ultraschall.ResetEvent(Ultraschall_Event_Section)


ultraschall.RegisterEvent(Ultraschall_Event_Section, "number")


OldState=reaper.GetCursorPosition()
ultraschall.SetEventState(Ultraschall_Event_Section, OldState, OldState)


function main()
  NewState=reaper.GetCursorPosition()
  
  if OldState~=NewState then 
    ultraschall.SetEventState(Ultraschall_Event_Section, OldState, NewState)
  end
  OldState=NewState
  
  A,AA=ultraschall.Defer1(main)
end

reaper.atexit(ultraschall.ResetEvent)

main()



