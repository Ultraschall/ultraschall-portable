-- Ultraschall-API demoscript by Meo Mespotine 26.02.2019
-- 
-- a simple event-manager, that employs background-helper-scripts for listening for statechanges and
-- the Defer-functions in Ultraschall-API 4.00 beta 2.72, who allow you to control, how often the deferred code
-- shall be executed (every x seconds/every x defer-cycles).

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- the following code will stop the Background-listener-scripts when script is exited
function exit()
  ultraschall.RunBackgroundHelperFeatures(false)
end

reaper.atexit(exit)


-- start background-listener scripts
ultraschall.RunBackgroundHelperFeatures(true)

function main()
  -- get the last/current playstates
  last_play_state, new_play_state, statechangetime = ultraschall.GetLastPlayState()
  
  -- if the state has been changed in general since last time calling GetLastPlayState:
  if statechangetime~=oldstatechangetime then
    -- show the old and new playstate in the console
    print("Old Playstate: "..last_play_state.." - New Playstate: "..new_play_state)
    
    -- if the state has changed from REC or RECPAUSE to STOP then
    if (last_play_state=="RECPAUSE" or last_play_state=="REC") and new_play_state=="STOP" then
      -- show a messagebox that displays that recording has stopped
      print2("Recording or Rec+Pause has stopped!")
    end
  end  
  
  -- store the current statechangetime as the old one for comparison in the next defer-cycle
  oldstatechangetime=statechangetime
  
  -- run the function main in mode 2(every x seconds) every 1 second
  -- Defer1(functionname, mode(0, normaldefer; 1, every x cycles; 2, every x seconds), counter(number of seconds or cycles))
  ultraschall.Defer1(main,2,1)
end

-- run the fun
main()