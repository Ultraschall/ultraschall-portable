--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- print (reaper.GetResourcePath())

-- Grab all of the functions and classes from our GUI library

GUI = dofile(reaper.GetResourcePath() .. "/Scripts/ultraschall_gui_lib.lua")
slideshow_path = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Slideshows/"

local info2 = debug.getinfo(1,'S');
slideshow_path1, slideshow_slug = ultraschall.GetPath(info2.source)
slideshow_slug=slideshow_slug:match("(.*)%.").."_"


---- Window settings and user functions ----

function run_action(commandID)

  CommandNumber = reaper.NamedCommandLookup(commandID)
  reaper.Main_OnCommand(CommandNumber,0)

end

function file_exists(name)

  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end

end

function close_gfx()

  gfx.quit()
  return

end


function build_slideshow_table(slug)


  slideshow_table = {}

  for i = 1, 20 do

    slide_name = slideshow_path .. slug .. tostring(i) .. ".png"
    if file_exists(slide_name) then

      table.insert(slideshow_table, slide_name)
      -- print (slide_name)

    else
      return slideshow_table
    end

  end
end



GUI.name = "Ultraschall 5 - Tutorial"
GUI.w, GUI.h = 680, 700

------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2


------------------------------------------------------
--  Aufbau der nicht interkativen GUI-Elemente wie Logos etc.
------------------------------------------------------


function buildGui(slide_number)


  if slide_number == nil then slide_number = 1 end

  rebuild_gui = true

  GUI.elms = {}


  -- name          = element type          x    y    w   h  zoom    caption                                                              ...other params...

  local picture_path = slideshow_table[slide_number]



  picture = GUI.Pic:new(    0,  0,   0,  0,    1, picture_path)

  table.insert(GUI.elms, picture)


  -----------------------------------------------------------------
  -- Blätterpfeile je nach OS unterschiedlich
  -----------------------------------------------------------------

  os = reaper.GetOS()
  if string.match(os, "OS") then -- unter Windiows Klammern statt Pfeile nehmen
    arrow1 = " ⬅"
    arrow2 = " ⮕"
  else
    arrow1 = " <"
    arrow2 = " >"
  end


  -----------------------------------------------------------------
  -- Zurück-Button
  -----------------------------------------------------------------

  if slide_number ~= 1 then

    previous_slide_number = slide_number -1

    button_settings = GUI.Btn:new(555, 663, 35, 39,         arrow1, buildGui, previous_slide_number)
    table.insert(GUI.elms, button_settings)

  end

  -----------------------------------------------------------------
  -- Weiter-Button
  -----------------------------------------------------------------

  if slide_number ~= #slideshow_table then

    next_slide_number = slide_number +1
    button_settings = GUI.Btn:new(592, 663, 35, 40,         arrow2, buildGui, next_slide_number)
    table.insert(GUI.elms, button_settings)

  else

    button_settings = GUI.Btn:new(462, 663, 175, 40,         " Close", close_gfx)
    -- table.insert(GUI.elms, button_settings)

  end

  color = "txt_grey"
  label_page = GUI.Lbl:new( 637, 673,  slide_number.."/"..#slideshow_table,          0, color)
  table.insert(GUI.elms, label_page)


end

slideshow_table = build_slideshow_table(slideshow_slug)
startslide = tonumber(reaper.GetExtState("Tutorial", "start"))
if startslide == nil then startslide = 1 end


GUI.func = buildGui(startslide)   -- Dauerschleife
GUI.freq = 1          -- Aufruf jede Sekunde

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

-- print (slideshow_table[1])

if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  GUI.Init()
  GUI.Main()
end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)
