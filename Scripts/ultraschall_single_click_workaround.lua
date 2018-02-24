follow_id=reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
  if reaper.GetToggleCommandState(follow_id)==1 then
    reaper.SetExtState("follow", "temp", reaper.time_precise(), false)
  end

--reaper.DeleteExtState("follow", "temp", false)
