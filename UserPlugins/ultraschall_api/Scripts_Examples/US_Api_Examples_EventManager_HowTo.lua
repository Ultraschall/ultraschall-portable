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
  
  
-- How to use the Ultraschall-API EventManager
--
-- Meo Mespotine - 1st of October 2019

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- First: Write a check-function, which must return either true(condition has been met) or false(condition hasn't been met)
--        If you need to store information for the next time the checkfunction is called, use the userspace-table, which is 
--        passed as first parameter.

function TransitionPlayToPlaypause(userspace)
  -- get the current playstate
  local current_playstate=reaper.GetPlayState()
  
  -- if the current playstate==2(playpause) and the old playstate==1(play) then 
  -- update old_playstate in the userspace and return true
  -- in any other case, only update old_playstate in the userspace and return false
  if current_playstate==2 and userspace["old_playstate"]==1 then
    userspace["old_playstate"]=current_playstate
    return true
  else
    userspace["old_playstate"]=current_playstate
    return false
  end
end

-- Second: start the EventManager
ultraschall.EventManager_Start()

-- Third: add a new event to the EventManager
--        this event adds a marker at playposition every time, you change from play to playpause
EventIdentifier = ultraschall.EventManager_AddEvent(
    "Insert Marker When Play -> PlayPause", -- a descriptive name for the event
            0,                                      -- how often to check in seconds; 0, means as often as possible 
            0,                                      -- how long to check for it in seconds; 0, means forever
            true,                                   -- shall the actions be run as long as the eventcheck-function 
                                                    --       returns true(false) or not(true)
            false,                                  -- shall the event be paused(true) or checked for right away(true)
            TransitionPlayToPlaypause,              -- the eventcheck-functionname, 
            {"40157, 0",                            -- a table, which hold all actions and their corresponding sections
             "40171, 0"}                            --       in this case action 40157 from section 0 and 40171 from section 0
                                                    --       note: both must be written as string "40157, 0"
                                                    --             if you want to add numerous actions, you can write them like
                                                    --             {  "40157, 0", "40171,0"}, which would add a marker and open 
                                                    --                                        the input-markername-dialog
                                                    --             
                                                    --       ActionCommandIDs with an underscore at the beginning are allowed.
                                                    --       like: _SWS_AWSELGROUPIFGROUP or _RS1234567890, etc
                              )