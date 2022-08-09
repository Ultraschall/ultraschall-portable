dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function Huch()
  if reaper.GetPlayState()~=0 then return true else return false end
end


--ultraschall.EventManager_Stop(true)
--ultraschall.EventManager_Start()
event_identifier = ultraschall.EventManager_AddEvent("Huch", 0, 0, true, false, Huch, {"1016,0"})


A1=ultraschall.EventManager_GetAllEventIdentifier()

id=1
A=ultraschall.EventManager_GetAllEventNames()
for i=1, 9 do
--  A[i]=reaper.GetExtState("ultraschall_eventmanager", "EventNames")
  
--  ultraschall.EventManager_ResumeEvent(A1[i])
end
