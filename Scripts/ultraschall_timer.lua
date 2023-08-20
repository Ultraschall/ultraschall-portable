--[[
################################################################################
# 
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
]]

-- Grab all of the functions and classes from our GUI library
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib_timer.lua")

-- All functions in the GUI library are now contained in the GUI table,
-- so they can be accessed via:          GUI.function(params)

  ---- Window settings and user functions ----
GUI.name = "Ultraschall Timer"
GUI.x, GUI.y, GUI.w, GUI.h = 100, 200, 184, 120


-----------------------
-- Step 1 : get started
-----------------------

os = reaper.GetOS()

minutes=15
seconds=0
endtime=0
running=false
update=false
blinking=false --activate blinking
blink=false    --blink status on or off

function press_start()
  if blinking then
    GUI.elms.start_button.caption="Start"
    blinking,blink=false,false
    seconds, minutes=0
    return 0
  end
  if running==false then
    if minutes+seconds<1 then return 0 end 
    endtime=minutes*60+seconds+math.floor(reaper.time_precise())
    running=true
    blinking, blink, update=false,false,false
    GUI.elms.start_button.caption="Stop"
    --TODO: abfragen, ob Aufnahme überhaupt läuft
    cursor_position = reaper.GetPlayPosition() -- Position of play-cursor
    reaper.AddProjectMarker2(0, false, cursor_position, 0 , "TimerStart", -1, 0xFF8800|0x1000000) -- Set start pointer of marker
    reaper.AddProjectMarker2(0, false, cursor_position+minutes*60+seconds, 0 , "TimerEnd", -1, 0xFFFF00|0x1000000) -- Set end point of marker
  else
    update=true
    blinking, blink, running=false,false,false
    seconds=secondstogo
    minutes=minutestogo
    GUI.elms.start_button.caption="Start"
    
    reaper.AddProjectMarker2(0, false, cursor_position+minutes*60+seconds, 0 , "TimerRealEnd", -1, 0x00FF00|0x1000000) -- Set realpointer of marker
  end
end

function press_reset(resetto)
  minutes=resetto
  seconds=0
  update=true
  blinking,blink,running=false,false,false
  zoom=1
  GUI.elms.sec_1.zoom=zoom
  GUI.elms.sec_2.zoom=zoom
  GUI.elms.min_1.zoom=zoom
  GUI.elms.min_2.zoom=zoom
  GUI.elms.seperator.zoom=zoom
end

function chgmin(offset)
  minutes=minutes + offset
  if minutes < 0 then minutes = 99 end
  if minutes > 99 then minutes = 0 end
  update=true
end

function chgsec(offset)
  seconds=seconds + offset
  if seconds < 0 then seconds = 59 end
  if seconds > 59 then seconds = 0 end
  update=true
end

function updateteatime()
  refresh=false
  if update then
    secondstogo=minutes*60+seconds
    refresh=true
    setstartmarker = false
  elseif running then
    refresh=true
    update=false
    secondstogo=endtime-math.floor(reaper.time_precise()) 
    if secondstogo<10 then 
      blinking=true
    end
    if secondstogo<1 then
      running=false
      secondstogo=0
    end
  end
  
  if refresh then
    minutestogo=math.floor(secondstogo/60)
    secondstogo=secondstogo-minutestogo*60

    min2=math.floor(minutestogo % 10)
    min1=math.floor((minutestogo-min2)/10)
    sec2=math.floor(secondstogo % 10)
    sec1=math.floor((secondstogo-sec2)/10)

    GUI.elms.sec_1.source=script_path..sec1..".png"
    GUI.elms.sec_2.source=script_path..sec2..".png"
    GUI.elms.min_1.source=script_path..min1..".png"
    GUI.elms.min_2.source=script_path..min2..".png"
  end

  if blinking then
    if blink then zoom=1 else zoom=0.99
    end
    blink=not blink
    GUI.elms.sec_1.zoom=zoom
    GUI.elms.sec_2.zoom=zoom
    GUI.elms.min_1.zoom=zoom
    GUI.elms.min_2.zoom=zoom
    GUI.elms.seperator.zoom=zoom
  end
end

function donothing()
end

---- GUI Elements ----
GUI.elms = {
  start_button = GUI.Btn:new(4+6*18, 4, 2*34, 52,      "Start", press_start),
  reset_button = GUI.Btn:new(4+6*18, 4+2*29, 2*34, 23,   "15 Min.", press_reset,15),
  reset2_button= GUI.Btn:new(4+6*18, 16+2*38, 2*34, 23, "01 Min." , press_reset,1),
  minup_button = GUI.Btn:new(4, 4, 34, 16,      " +", chgmin, 1),
  mindo_button = GUI.Btn:new(4, 23+2*38, 34, 16, " -", chgmin, -1),
  secup_button = GUI.Btn:new(4+3*18, 4, 34, 16,      " +", chgsec, 1),
  secdo_button = GUI.Btn:new(4+3*18, 23+2*38, 34, 16,      " -", chgsec, -1),
  min_1        = GUI.Pic:new(4,44, 18, 26, 1, script_path.."1.png", donothing , ""),
  min_2        = GUI.Pic:new(4+18,44, 18, 26, 1, script_path.."5.png", donothing, ""),
  seperator    = GUI.Pic:new(4+2*18,42, 18, 26, 1, script_path.."_.png", donothing, ""),
  sec_1        = GUI.Pic:new(4+3*18,44, 18, 26, 1, script_path.."0.png", donothing , ""),
  sec_2        = GUI.Pic:new(4+4*18,44, 18, 26, 1, script_path.."0.png", donothing, ""),
}


---- Main loop ----
--If you want to run a function during the update loop, use the variable GUI.func prior to
--starting GUI.Main() loop:

GUI.func = updateteatime
GUI.freq = 0.5    -- <-- How often in seconds to run the function, so we can avoid clogging up the CPU.
          -- Will run once a second if no value is given.
          -- Integers only, 0 will run every time.

GUI.Init()
GUI.Main()
