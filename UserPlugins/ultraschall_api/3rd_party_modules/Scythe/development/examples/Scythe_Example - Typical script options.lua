--[[
  An example UI for a typical real-world use case - getting user input before
  running an action rather than having to use GetUserInputs or put
  user-configurable settings in the script file.
]]--

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")


local window


------------------------------------
-------- Functions  ----------------
------------------------------------


local function btn_click()

  -- Grab all of the user's settings into local variables,
  -- just to make it less awkward to work with
  local mode, thresh = GUI.Val("mnu_mode"), GUI.Val("sldr_thresh")
  local opts = GUI.Val("chk_opts")
  local time_sel, sel_track, glue = opts[1], opts[2], opts[3]

  local menu = window:findElementByName("mnu_mode")

  -- Be nice, give the user an Undo point
  reaper.Undo_BeginBlock()

  reaper.ShowMessageBox(
    "This is where we pretend to perform some sort of fancy operation with the user's settings.\n\n"
    .."Working in "..tostring(menu.options[mode]).." mode with a threshold of "..tostring(thresh).."db.\n\n"
    .."Apply only to time selection: "..tostring(time_sel).."\n"
    .."Apply only to selected track: "..tostring(sel_track).."\n"
    .."Glue the processed items together afterward: "..tostring(glue)
  , "Yay!", 0)

  reaper.Undo_EndBlock("Typical script options", 0)

  -- Exit the script on the next update
  Scythe.quit = true

end


------------------------------------
-------- Window settings -----------
------------------------------------


window = GUI.createWindow({
  name = "Typical Script Options",
  x = 0,
  y = 0,
  w = 400,
  h = 200,
  anchor = "mouse",
  corner = "C",
})


------------------------------------
-------- GUI Elements --------------
------------------------------------


local layer = GUI.createLayer({name = "Layer1"})

layer:addElements( GUI.createElements(
  {
    name = "mnu_mode",
    type =  "Menubox",
    x = 64,
    y = 32,
    w = 72,
    h = 20,
    caption = "Mode:",
    options = {"Auto","Punch","Step"}
  },
  {
    name = "chk_opts",
    type =  "Checklist",
    x = 192,
    y = 32,
    w = 192,
    h = 96,
    caption = "Options",
    options = {"Only in time selection", "Only on selected track", "Glue items when finished"},
    dir = "v",
    pad = 4
  },
  {
    name = "sldr_thresh",
    type = "Slider",
    x = 32,
    y = 96,
    w = 128,
    caption = "Threshold",
    min = -60,
    max = 0,
    defaults = 48,
    inc = nil,
    dir = "h"
  },
  {
    name = "btn_go",
    type = "Button",
    x = 168,
    y = 152,
    w = 64,
    h = 24,
    caption = "Go!",
    func = btn_click
  }
))

window:addLayers(layer)
window:open()

GUI.Main()
