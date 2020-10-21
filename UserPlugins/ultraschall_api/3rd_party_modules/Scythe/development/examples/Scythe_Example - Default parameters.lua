--[[
  The bare minimum required to display a window and some elements. In Scythe v3,
  elements have defaults defined for most/all of their parameters in case you
  forget to include them or are happy with the defaults
]]--

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")


------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "Default Parameters",
  w = 400,
  h = 200,
})


------------------------------------
-------- GUI Elements --------------
------------------------------------


local layer = GUI.createLayer({name = "Layer1"})

layer:addElements( GUI.createElements(
  {
    name = "mnu_mode",
    type = "Menubox",
    x = 64,
  },
  {
    name = "chk_opts",
    type = "Checklist",
    x = 192,
    y = 16,
  },
  {
    name = "sldr_thresh",
    type = "Slider",
    x = 32,
    y = 96,
  },
  {
    name = "btn_go",
    type = "Button",
    x = 168,
    y = 152,
  }
))

window:addLayers(layer)
window:open()

GUI.Main()
