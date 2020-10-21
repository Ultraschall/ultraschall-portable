--[[
  Scythe example

  - General demonstration
  - Tabs and layer sets
  - Accessing elements' parameters

]]--

-- The core library must be loaded prior to anything else
local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")
-- local Table = require("public.table")[1]




------------------------------------
-------- Functions -----------------
------------------------------------


local function btnClick()
  reaper.ShowMessageBox("This should not have popped up. :(", "Whoops!", 0)
end

local function preventDefault(self, state) state.preventDefault = true end



------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "PreventDefault testing",
  x = 0,
  y = 0,
  w = 500,
  h = 640,
  anchor = "mouse",
  corner = "C",
})

local layers = table.pack( GUI.createLayers(
  {name = "Layer1", z = 1},
  {name = "Layer2", z = 2},
  {name = "Layer3", z = 3},
  {name = "Layer4", z = 4},
  {name = "Layer5", z = 5},
  {name = "Layer6", z = 6}
))

window:addLayers(table.unpack(layers))




------------------------------------
-------- Global elements -----------
------------------------------------


layers[1]:addElements( GUI.createElements(
  {
    name = "tabs",
    type = "Tabs",
    x = 0,
    y = 0,
    w = 64,
    h = 20,
    tabs = {
      {
        label = "Stuff",
        layers = {layers[3]}
      },
      {
        label = "Sliders",
        layers = {layers[4]}
      },
      {
        label = "Options",
        layers = {layers[5]}
      },
      {
        label = "Tabs",
        layers = {layers[6]}
      },
    },
    pad = 16
  },
  {
    name = "my_btn",
    type = "Button",
    x = 168,
    y = 28,
    w = 128,
    h = 20,
    caption = "prevents MouseUp",
    func = btnClick,
    beforeMouseUp = preventDefault,
  },
  {
    name = "btn_frm",
    type = "Frame",
    x = 0,
    y = 56,
    w = window.w,
    h = 1,
  }
))

layers[2]:addElements( GUI.createElement(
  {
    name = "tab_bg",
    type = "Frame",
    x = 0,
    y = 0,
    w = 448,
    h = 20,
  }
))



------------------------------------
-------- Tab 1 Elements ------------
------------------------------------

layers[3]:addElements( GUI.createElements(
  {
    name = "my_knob",
    type = "Knob",
    x = 48,
    y = 112,
    w = 48,
    caption = "prevents Wheel",
    vals = false,
    beforeWheel = preventDefault,
  },
  {
    name = "my_mnu",
    type = "Menubox",
    x = 272,
    y = 176,
    w = 128,
    h = 20,
    caption = "prevents MouseUp",
    options = {"Shouldn't pop up"},
    beforeMouseUp = preventDefault,
  },
  {
    name = "my_txt1",
    type = "Textbox",
    x = 160,
    y = 224,
    w = 80,
    h = 20,
    caption = "prevents MouseDown:",
    beforeMouseDown = preventDefault,
  },
  {
    name = "my_txt2",
    type = "Textbox",
    x = 160,
    y = 248,
    w = 80,
    h = 20,
    caption = "prevents Drag, DoubleClick:",
    beforeDrag = preventDefault,
    beforeDoubleClick = preventDefault,
    retval = "Hi there!"
  },
  {
    name = "my_txt3",
    type = "Textbox",
    x = 160,
    y = 272,
    w = 80,
    h = 20,
    caption = "prevents Typing:",
    beforeType = preventDefault,
    retval = "Hi there!"
  },
  {
    name = "my_other_knob",
    type = "Knob",
    x = 64,
    y = 352,
    w = 48,
    caption = "prevents DoubleClick, Drag",
    vals = false,
    beforeDoubleClick = preventDefault,
    beforeDrag = preventDefault,
  },
  {
    name = "my_picker",
    type = "ColorPicker",
    x = 320,
    y = 312,
    w = 24,
    h = 24,
    caption = "prevents MouseUp",
    beforeMouseUp = preventDefault
  }
))




------------------------------------
-------- Tab 2 Elements ------------
------------------------------------

layers[4]:addElements( GUI.createElements(
  {
    name = "my_rng",
    type = "Slider",
    x = 32,
    y = 128,
    w = 256,
    caption = "Prevents Wheel, DoubleClick",
    min = 0,
    max = 30,
    defaults = {5, 10, 15, 20, 25},
    beforeWheel = preventDefault,
    beforeDoubleClick = preventDefault,
  },
  {
    name = "my_pan",
    type = "Slider",
    x = 32,
    y = 192,
    w = 256,
    caption = "prevents MouseDown, Drag",
    min = -100,
    max = 100,
    defaults = 0,
    -- Using a function to change the value label depending on the value
    output = function(val)
      val = tonumber(val)

      return (val == 0)
        and "0"
        or  (math.abs(val) .. (val < 0 and "L" or "R"))
    end,
    beforeMouseDown = preventDefault,
    beforeDrag = preventDefault,
  }
))



------------------------------------
-------- Tab 3 Elements ------------
------------------------------------


layers[5]:addElements( GUI.createElements(
  {
    name = "my_chk",
    type = "Checklist",
    x = 32,
    y = 96,
    w = 160,
    h = 160,
    caption = "prevents MouseUp",
    options = {"Alice","Bob","Charlie","Denise","Edward","Francine"},
    dir = "v",
    beforeMouseUp = preventDefault,
  },
  {
    name = "my_opt",
    type = "Radio",
    x = 216,
    y = 96,
    w = 160,
    h = 160,
    caption = "prevents MouseUp + Down",
    options = {"Apples","Bananas","_","Donuts","Eggplant"},
    dir = "v",
    swap = true,
    tooltip = "Well hey there!",
    beforeMouseUp = preventDefault,
    beforeMouseDown = preventDefault,
  },
  {
    name = "my_opt2",
    type = "Radio",
    x = 32,
    y = 364,
    w = 384,
    h = 64,
    caption = "prevents Drag and Wheel",
    options = {"A","A#","B","C","C#","D","D#","E","F","F#","G","G#"},
    horizontal = true,
    beforeDrag = preventDefault,
    beforeWheel = preventDefault,
  }
))

layers[6]:addElements( GUI.createElements(
  {
    name = "tabs1",
    type = "Tabs",
    x = 64,
    y = 250,
    w = 64,
    h = 20,
    tabs = {
      {
        label = "Prevents",
        layers = {}
      },
      {
        label = "Mouse",
        layers = {}
      },
      {
        label = "Wheel",
        layers = {}
      }
    },
    pad = 16,
    beforeWheel = preventDefault,
    fullWidth = false,
  },
  {
    name = "tabs2",
    type = "Tabs",
    x = 64,
    y = 278,
    w = 64,
    h = 20,
    tabs = {
      {
        label = "Prevents",
        layers = {}
      },
      {
        label = "MouseDown",
        layers = {}
      },
      {
        label = "and Drag",
        layers = {}
      }
    },
    pad = 16,
    tabW = 96,
    beforeMouseDown = preventDefault,
    beforeDrag = preventDefault,
    fullWidth = false,
  }
))



------------------------------------
-------- Main functions ------------
------------------------------------


-- This will be run on every update loop of the GUI script; anything you would put
-- inside a reaper.defer() loop should go here. (The function name doesn't matter)
local function Main()

  -- Prevent the user from resizing the window
  if window.state.resized then
    -- If the window's size has been changed, reopen it
    -- at the current position with the size we specified
    window:reopen({w = window.w, h = window.h})
  end

end

-- Open the script window and initialize a few things
window:open()

-- Tell the GUI library to run Main on each update loop
-- Individual elements are updated first, then GUI.func is run, then the GUI is redrawn
GUI.func = Main

-- How often (in seconds) to run GUI.func. 0 = every loop.
GUI.funcTime = 0

-- Start the main loop
GUI.Main()
