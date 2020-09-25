--[[
  Scythe example

  - Demonstration of the Listbox, Menubar, and TextEditor classes

]]--

-- The core library must be loaded prior to anything else

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")

require("public.string")

local function preventDefault(self, state) state.preventDefault = true end




------------------------------------
-------- Menu contents -------------
------------------------------------


local noop = function() end

local menus1 = {
  {title = "prevents", options = {
    {caption = "This should not come up",   func = noop},
  }},
  {title = "MouseUp and", options = {
    {caption = "This should not come up",   func = noop},
  }},
  {title = "MouseOver", options = {
    {caption = "This should not come up",   func = noop},
  }},
}

local menus2 = {
  {title = "prevents", options = {
    {caption = "Hi there!",   func = noop},
  }},
  {title = "MouseDown", options = {
    {caption = "Hi there!",   func = noop},
  }},
}




------------------------------------
-------- Listbox contents ----------
------------------------------------


local titles1 = ("prevents MouseDown -- and -- MouseUp -- events"):split(" ")
local titles2 = ("prevents Wheel -- and -- Drag -- events"):split(" ")




------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "PreventDefault testing",
  x = 0,
  y = 0,
  w = 512,
  h = 320,
  anchor = "mouse",
  corner = "C",
})


window:addLayers(
  GUI.createLayer({name = "Layer1", z = 1})
    :addElements(
      GUI.createElements(
        {
          name = "mnu1",
          type = "Menubar",
          x = 0,
          y = 0,
          w = 288,
          fullWidth = false,
          menus = menus1,
          beforeMouseUp = preventDefault,
          beforeMouseOver = preventDefault,
        },
        {
          name = "mnu2",
          type = "Menubar",
          x = 300,
          y = 0,
          w = 280,
          fullWidth = false,
          menus = menus2,
          beforeMouseDown = preventDefault,
        },
        {
          name = "lst1",
          type = "Listbox",
          x = 16,
          y = 40,
          w = 192,
          h = 80,
          caption = "",
          multi = true,
          list = titles1,
          afterDoubleClick = function(self) GUI.Val("txted_text", "DoubleClicked the first Listbox at " .. reaper.time_precise()) end,
          beforeMouseDown = preventDefault,
          beforeMouseUp = preventDefault,
        },
        {
          name = "lst2",
          type = "Listbox",
          x = 16,
          y = 128,
          w = 192,
          h = 80,
          caption = "",
          multi = true,
          list = titles2,
          beforeWheel = preventDefault,
          beforeDrag = preventDefault,
        },
        {
          name = "txted1",
          type = "TextEditor",
          x = 216,
          y = 40,
          w = 256,
          h = 80,
          retval = "This TextEditor prevents MouseDown events!",
          beforeMouseDown = preventDefault,
        },
        {
          name = "txted2",
          type = "TextEditor",
          x = 216,
          y = 128,
          w = 256,
          h = 80,
          retval = "This TextEditor\nprevents\nWheel\nand\nDrag\nevents!",
          beforeWheel = preventDefault,
          beforeDrag = preventDefault,
        },
        {
          name = "txted3",
          type = "TextEditor",
          x = 216,
          y = 216,
          w = 256,
          h = 80,
          retval = "This TextEditor prevents\nDoubleClick and Type events!",
          beforeDoubleClick = preventDefault,
          beforeType = preventDefault,
        }
      )
    )
)


window:open()
GUI.Main()
