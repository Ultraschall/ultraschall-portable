function run()
  is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
  if is_new then
    -- reaper.ShowConsoleMsg(name .. "\nrel: " .. rel .. "\nres: " .. res .. "\nval = " .. val .. "\n") debug
    if val == 1 then
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newend = endOut + 0.05
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, startOut, newend, true)
    else
    	startOut, endOut = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
		newend = endOut - 0.05
		startOut, endOut = reaper.GetSet_LoopTimeRange(true, true, startOut, newend, true)
    end
  end
  -- reaper.defer(run)

end

-- debug

function onexit()
  reaper.ShowConsoleMsg("<-----\n")
end

reaper.defer(run)
-- reaper.atexit(onexit)
