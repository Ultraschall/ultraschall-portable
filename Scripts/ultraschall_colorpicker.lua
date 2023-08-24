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
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")
gfx_path=script_path.."/Ultraschall_Gfx/ColorPicker/"

-- All functions in the GUI library are now contained in the GUI table,
-- so they can be accessed via:          GUI.function(params)

  ---- Window settings and user functions ----


GUI.name = "Ultraschall Color Picker"
GUI.x, GUI.y, GUI.w, GUI.h = 100, 200, 235, 175


-----------------------
-- Step 1 : get started
-----------------------

max_color = 20  -- Number of colors to cycle
curtheme = reaper.GetLastColorThemeFile()
os = reaper.GetOS()

---------------------------------------------------------
-- Step 2 : build table with color values from theme file
---------------------------------------------------------

t = {}   -- initiate table
file = io.open(curtheme, "r");

for line in file:lines() do
  index = string.match(line, "group_(%d+)")  -- use "Group" section
  index = tonumber(index)
    if index then
      if index < max_color then
      color_int = string.match(line, "=(%d+)")  -- get the color value
        if string.match(os, "OS") then
          r, g, b = reaper.ColorFromNative(color_int)
          color_int = reaper.ColorToNative(b, g, r) -- swap r and b for Mac
        end
      t[index] = tonumber(color_int)  -- put color into table
    end
  end
end
-- for key,value in pairs(t) do Msg(value) end

function gentle_rainboom(url)

  local id = reaper.NamedCommandLookup("_Ultraschall_Set_Colors_To_Sonic_Rainboom")
    reaper.Main_OnCommand(id,0)

end

function spread_rainboom(url)

  local id = reaper.NamedCommandLookup("_Ultraschall_Set_Colors_To_Sonic_Rainboom_Spread")
    reaper.Main_OnCommand(id,0)

end



function debug()
  gfx.set(1, 0.5, 0.5, 1)
  gfx.circle(10, 10, 20, 1)
end

  -- body
  ---- GUI Elements ----

GUI.elms = {

--     name          = element type          x      y    w    h     caption               ...other params...
  colors      = GUI.ColorPic:new(    4, 4, 170, 170, t),
  col1      = GUI.Pic:new(      190,4, 42, 83, 1, gfx_path.."us_col1.png", gentle_rainboom, ""),
  col2      = GUI.Pic:new(      190,88, 42, 83, 1, gfx_path.."us_col2.png", spread_rainboom, ""),
--  label           = GUI.Lbl:new(          0,  160,               "Ultraschall was sucsessfully installed.", 0),
--  label2           = GUI.Lbl:new(          135,  200,               "Visit the Podcast menu to explore the user interface and features.", 0),
--  label3           = GUI.Lbl:new(          210,  220,               "Use Project templates for a quick setup.", 0),

--  label4           = GUI.Lbl:new(          265,  290,               "If you need assistance:", 0),
--  label3           = GUI.Lbl:new(          455,  290,               "Visit our support forum:", 0),

  -- pan_sldr      = GUI.Sldr:new(          360, 280, 128,           "Pan:", -100, 100, 200, 4),
--  pan_knb      = GUI.Knob:new(          530, 100, 48,            "Awesomeness", 0, 9, 11, 5, 1),
--  label2           = GUI.Lbl:new(          508,  42,               "Awesomeness", 0),
  -- options      = GUI.OptLst:new(     50,  100, 150, 150, "Color notes by:", "Channel,Pitch,Velocity,Penis Size", 4),
  -- blah           = GUI.OptLst:new(     50,  260, 250, 200, "I have a crush on:", "Justin F,schwa,X-Raym,Jason Brian Merrill,pipelineaudio,Xenakios", 2, 0),
  -- newlist      = GUI.ChkLst:new(     210, 100, 120, 150, "I like to eat:", "Fruit,Veggies,Meat,Dairy", 4),
--  checkers      = GUI.Checklist:new(     20, 380, 240, 30,      "", "Show this Screen on Start", 4),
--  tutorials        = GUI.Btn:new(          30, 320, 190, 40,      "Tutorials", open_url, "http://ultraschall.fm/tutorials/"),
--  twitter        = GUI.Btn:new(          242, 320, 190, 40,      "Twitter", open_url, "https://twitter.com/ultraschall_fm"),
--  forum          = GUI.Btn:new(          455, 320, 190, 40,      "Userforum", open_url, "https://sendegate.de/c/ultraschall"),
  -- label4          = GUI.Lbl:new(          300,  400,               "Have fun!", 0),

   --testbtn2      = GUI.Btn:new(          450, 100, 100, 50,      "CLICK", userfunc, "This|#Is|A|!Menu"),
  -- newtext      = GUI.TxtBox:new(     340, 210, 200, 30,      "Favorite music player:", 4),

}


  ---- Put all of your own functions and whatever here ----

--Msg("hallo")


--GUI.func = drawcolors(t)
-- GUI.func = debug()
-- GUI.freq = 0



  ---- Main loop ----

--[[

  If you want to run a function during the update loop, use the variable GUI.func prior to
  starting GUI.Main() loop:

  GUI.func = my_function
  GUI.freq = 5     <-- How often in seconds to run the function, so we can avoid clogging up the CPU.
            - Will run once a second if no value is given.
            - Integers only, 0 will run every time.

  GUI.Init()
  GUI.Main()

]]--

-- local startscreen = GUI.val("checkers")
-- local startscreen = GUI.elms.checkers[GUI.Val()]

-- Open Colorpicker, when it hasn't been opened yet
    if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).
                                                                                      -- If yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
    else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

    if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                            -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc
      GUI.Init()
      GUI.Main()
    end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)
