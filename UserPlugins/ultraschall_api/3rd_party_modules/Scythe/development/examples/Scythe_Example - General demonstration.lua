--[[
  An example of how Scythe scripts work in a general sense, how to use tabs, and
  how to access elements' parameters
]]--

-- The core library must be loaded prior to anything else
local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

-- This line needs to use loadfile; anything afterward can be required
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")
local Table = require("public.table")


------------------------------------
-------- Functions -----------------
------------------------------------


local layers

local fadeElm, fadeLayer
local function toggleLabelFade()
  if fadeElm.layer then
    -- Label:fade(len, dest, curve)
    -- len = time in seconds
    -- dest = destination layer
    -- curve = sharpness of the fade; negative values will fade in instead
    fadeElm:fade(1, nil, 6)
  else
    fadeElm:fade(1, fadeLayer, -6)
  end
end


-- Returns a list of every element in the specified z-layer and
-- a second list of each element's values
local function getValuesForLayer(layerNum)
  -- The '+ 2' here is just to translate from a tab number to its' associated
  -- layer, since there are a couple of static layers we need to skip over.
  -- More complicated scripts might have to access the Tabs element's layer list
  -- and iterate over the contents directly.

  local layer = layers[layerNum + 2]

  local values = {}
  local val

  for key, elm in pairs(layer.elements) do
    if elm.val then
      val = elm:val()
    else
      val = "n/a"
    end

    if type(val) == "table" then
      val = "{\n" .. Table.stringify(val) .. "\n}"
    end

    values[#values + 1] = key .. ": " .. tostring(val)
  end

  return layer.name .. ":\n" .. table.concat(values, "\n")
end


local function btnClick()
  local tab = GUI.findElementByName("tabs"):val()

  local msg = getValuesForLayer(tab)
  reaper.ShowMessageBox(msg, "Yay!", 0)
end


------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "General Demonstration",
  x = 0,
  y = 0,
  w = 432,
  h = 500,
  anchor = "mouse",
  corner = "C",
})

layers = table.pack( GUI.createLayers(
  {name = "Layer1", z = 1},
  {name = "Layer2", z = 2},
  {name = "Layer3", z = 3},
  {name = "Layer4", z = 4},
  {name = "Layer5", z = 5}
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
      }
    },
    pad = 16
  },
  {
    name = "btnGo",
    type = "Button",
    x = 168,
    y = 28,
    w = 96,
    h = 20,
    caption = "Go!",
    func = btnClick
  },
  {
    name = "frmDivider",
    type = "Frame",
    x = 0,
    y = 56,
    w = window.w,
    h = 1,
  }
))

layers[2]:addElements( GUI.createElement(
  {
    name = "frmTabBackground",
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
    name = "label",
    type = "Label",
    x = 256,
    y = 96,
    caption = "Label!"
  },
  {
    name = "knobVolume",
    type = "Knob",
    x = 64,
    y = 112,
    w = 48,
    caption = "Volume",
    vals = false,
  },
  {
    name = "mnuOptions",
    type = "Menubox",
    x = 256,
    y = 176,
    w = 64,
    h = 20,
    caption = "Options:",
    options = {"1","2","3","4","5","6.12435213613"}
  },
  {
    name = "btnFade",
    type = "Button",
    x = 256,
    y = 256,
    w = 64,
    h = 20,
    caption = "Click me!",
    func = toggleLabelFade,
  },
  {
    name = "textbox",
    type = "Textbox",
    x = 96,
    y = 224,
    w = 96,
    h = 20,
    caption = "Text:",
  },
  {
    name = "frmText",
    type = "Frame",
    x = 16,
    y = 288,
    w = 192,
    h = 128,
    bg = "backgroundDarkest",
    text = "this is a really long string of text with no carriage returns so hopefully "..
            "it will be wrapped correctly to fit inside this frame"
  },
  {
    name = "picker",
    type = "ColorPicker",
    x = 320,
    y = 300,
    w = 24,
    h = 24,
    caption = "Click me too! ->",
  }
))

fadeElm = GUI.findElementByName("label")
fadeLayer = fadeElm.layer

-- We have too many values to be legible if we draw them all; we'll disable them
-- and have the knob's caption update itself to show the value instead.
local knobVolume = GUI.findElementByName("knobVolume")
function knobVolume:redraw()
  -- This grabs the knob's prototype - the Knob class - so we can use the original
  -- redraw method.
  getmetatable(self).redraw(self)
  self.caption = self.retval .. "dB"
end

-- Make sure it shows the value right away
knobVolume:redraw()


------------------------------------
-------- Tab 2 Elements ------------
------------------------------------


layers[4]:addElements( GUI.createElements(
  {
    name = "sldrRange",
    type = "Slider",
    x = 32,
    y = 128,
    w = 256,
    caption = "Sliders",
    min = 0,
    max = 30,
    defaults = {5, 10, 15, 20, 25}
  },
  {
    name = "sldrPan",
    type = "Slider",
    x = 32,
    y = 192,
    w = 256,
    caption = "Pan",
    min = -100,
    max = 100,
    defaults = 0,
    -- Using a function to change the value label depending on the value
    output = function(val)
      val = tonumber(val)

      return (val == 0)
        and "0"
        or  (math.abs(val) .. (val < 0 and "L" or "R"))
    end
  },
  {
    name = "sldrBoring",
    type = "Slider",
    x = 80,
    y = 256,
    w = 128,
    caption = "Slider",
    min = 0,
    max = 10,
    defaults = 5,
    inc = 0.25,
    horizontal = false,
    output = "Value: %val%",
  },
  {
    name = "sldrDecimals",
    type = "Slider",
    x = 192,
    y = 256,
    w = 128,
    caption = "Decimals",
    min = -1,
    max = 1,
    defaults = 0,
    inc = 0.01,
    horizontal = false,
  },
  {
    name = "sldrVerticalRange",
    type = "Slider",
    x = 352,
    y = 96,
    w = 256,
    caption = "Vertical?",
    min = 0,
    max = 30,
    defaults = {5, 10, 15, 20, 25},
    horizontal = false,
  }
))


------------------------------------
-------- Tab 3 Elements ------------
------------------------------------


layers[5]:addElements( GUI.createElements(
  {
    name = "chkNames",
    type = "Checklist",
    x = 32,
    y = 96,
    w = 160,
    h = 160,
    caption = "Checklist:",
    options = {"Alice","Bob","Charlie","Denise","Edward","Francine"},
    dir = "v"
  },
  {
    name = "optFoods",
    type = "Radio",
    x = 200,
    y = 96,
    w = 160,
    h = 160,
    caption = "Options:",
    options = {"Apples","Bananas","_","Donuts","Eggplant"},
    dir = "v",
    swap = true,
    tooltip = "Well hey there!"
  },
  {
    name = "chkNames2",
    type = "Checklist",
    x = 32,
    y = 280,
    w = 384,
    h = 64,
    caption = "Whoa, another Checklist",
    options = {"A","B","C","_","E","F","G","_","I","J","K"},
    horizontal = true,
    swap = true
  },
  {
    name = "optNotes",
    type = "Radio",
    x = 32,
    y = 364,
    w = 384,
    h = 64,
    caption = "Horizontal options",
    options = {"A","A#","B","C","C#","D","D#","E","F","F#","G","G#"},
    horizontal = true,
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
