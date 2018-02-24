function run()
  is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
  if is_new then
    reaper.ShowConsoleMsg(name .. "\nrel: " .. rel .. "\nres: " .. res .. "\nval = " .. val .. "\n")
    if val == 1 then
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newstart = startOut + 0.1
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, newstart, endOut, true)
    else
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newstart = startOut - 0.1
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, newstart, endOut, true)
    end
  end
  -- reaper.defer(run)

end

function onexit()
  reaper.ShowConsoleMsg("<-----\n")
end

reaper.defer(run)
-- reaper.atexit(onexit)
