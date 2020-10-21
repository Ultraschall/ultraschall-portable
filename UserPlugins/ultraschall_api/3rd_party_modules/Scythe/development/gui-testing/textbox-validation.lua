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

local window = GUI.createWindow({
  name = "Textbox Validation",
  x = 0,
  y = 0,
  w = 288,
  h = 132,
  anchor = "mouse",
  corner = "C",
})

local layers = table.pack( GUI.createLayers(
  {name = "Layer1", z = 1}
))

window:addLayers(table.unpack(layers))

layers[1]:addElements( GUI.createElements(
  {
    name = "txt1",
    type = "Textbox",
    x = 160,
    y = 16,
    w = 96,
    h = 20,
    caption = "Only letters (on leave)",
    validator = function(text) return text:match("^[a-zA-Z]+$") end,
  },
  {
    name = "txt2",
    type = "Textbox",
    x = 160,
    y = 38,
    w = 96,
    h = 20,
    caption = "Only digits (on leave)",
    validator = function(text) return text:match("^%d+$") end,
  },
  {
    name = "txt3",
    type = "Textbox",
    x = 160,
    y = 60,
    w = 96,
    h = 20,
    caption = "Only letters (on type)",
    validator = function(text) return text:match("^[a-zA-Z]+$") end,
    validateOnType = true,
  },
  {
    name = "txt4",
    type = "Textbox",
    x = 160,
    y = 82,
    w = 96,
    h = 20,
    caption = "Only digits (on type)",
    validator = function(text) return text:match("^%d+$") end,
    validateOnType = true,
  }
))


-- Open the script window and initialize a few things
window:open()

-- Start the main loop
GUI.Main()
