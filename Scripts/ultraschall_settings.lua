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
]]
 
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

------------------------------------------------------
-- Open a URL in a browser - OS agnostic
------------------------------------------------------
function open_url(url)
  
  local OS=reaper.GetOS()
  if OS=="OSX32" or OS=="OSX64" then
    os.execute("open ".. url)
  else
    os.execute("start ".. url)
  end
end


------------------------------------------------------
--  Setting new Values to ultraschall.ini
------------------------------------------------------
function set_values()

  for i = 1, #GUI["elms"] , 2 do  -- Anzahl der Einträge ist immer doppelt so hoch durch die Info-Buttons pro Eintrag

    if GUI["elms"][i]["type"] == "Checklist" then
      newvalue = tostring(GUI["elms"][i]["retval"][1])
    elseif GUI["elms"][i]["type"] == "Sldr" then
      newvalue = tostring(GUI["elms"][i]["retval"])
    end
    
    if newvalue ~= ultraschall.GetUSExternalState(GUI["elms"][i]["sectionname"],"value") then
      -- print (newvalue)
      -- print("change")
      update = ultraschall.SetUSExternalState(GUI["elms"][i]["sectionname"], "value", newvalue , true)

      -- Ausnahme: für Slider wird auch noch die Position geschrieben (könnte man prinzipiell auch berechnen lassen)

      if GUI["elms"][i]["type"] == "Sldr" then
        update = ultraschall.SetUSExternalState(GUI["elms"][i]["sectionname"], "actualstep", tostring(GUI["elms"][i]["curstep"]) , true)
      end

    end

  end

end



------------------------------------------------------
--  Show the GUI menu item
------------------------------------------------------
function show_menu(str)
    
  gfx.x, gfx.y = GUI.mouse.x+20, GUI.mouse.y-10
  selectedMenu = gfx.showmenu(str)
  return selectedMenu

end


------------------------------------------------------
--  End of functions
------------------------------------------------------


-- Grab all of the functions and classes from our GUI library

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall Settings"
GUI.w, GUI.h = 680, 415

------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2



  -- body
  ---- GUI Elements ----
  
GUI.elms = {
  
--     name          = element type          x    y    w   h  zoom    caption                                                              ...other params...
  logo             = GUI.Pic:new(          240,  10,   0,  0,    1,   script_path.."us_small.png"),
  label            = GUI.Lbl:new(          313, 110,                  "Settings",          0),
  -- checkers         = GUI.Checklist:new(     20, 380, 240, 30,         "",                                                                   "Show this Screen on Start", 4),
  -- checkers2        = GUI.Checklist:new(    405, 380, 240, 30,         "",                                                                   "Automatically check for updates", 4),
  
  -- tutorials        = GUI.Btn:new(           30, 320, 190, 40,         "Tutorials",                                                          open_url, "http://ultraschall.fm/tutorials/"),

}



---- Put all of your own functions and whatever here ----


-----------------------------------------------------------------
-- initialise the settings - coming from the ultraschall.ini file
-----------------------------------------------------------------


section_count = ultraschall.CountUSExternalState_sec()

-- Gehe alle Sektionen der ultraschall.ini durch

for i = 1, section_count , 1 do
  
  sectionName = ultraschall.EnumerateUSExternalState_sec(i)

  -- Suche die Sections der ultraschall.ini heraus, die in der Settings-GUI angezeigt werden sollen

  if sectionName and string.find(sectionName, "ultraschall_settings", 1) then

    position = 150 + (tonumber(ultraschall.GetUSExternalState(sectionName,"position")) * 30) -- Feintuning notwendig
    key_count = ultraschall.CountUSExternalState_key(sectionName)
    settings_Type = ultraschall.GetUSExternalState(sectionName, "settingstype")
    
    if settings_Type == "checkbox" then
      id = GUI.Checklist:new(20, position, 240, 30,         "", ultraschall.GetUSExternalState(sectionName,"name"), 4, tonumber(ultraschall.GetUSExternalState(sectionName,"value")), sectionName)
      table.insert(GUI.elms, id)      
    
      -- Info-Button
      info = GUI.Btn:new(400, position, 20, 20,         " ?", show_menu, ultraschall.GetUSExternalState(sectionName,"description"))
      table.insert(GUI.elms, info)
    
    elseif settings_Type == "slider" then
      position = position+8
      id = GUI.Sldr:new(30, position, 100, ultraschall.GetUSExternalState(sectionName,"name"), ultraschall.GetUSExternalState(sectionName,"minimum"), ultraschall.GetUSExternalState(sectionName,"maximum"), ultraschall.GetUSExternalState(sectionName,"steps"), ultraschall.GetUSExternalState(sectionName,"value"), ultraschall.GetUSExternalState(sectionName,"actualstep"), sectionName)
      table.insert(GUI.elms, id)
    
      -- Info-Button
      info = GUI.Btn:new(400, position-6, 20, 20,         " ?", show_menu, ultraschall.GetUSExternalState(sectionName,"description"))
      table.insert(GUI.elms, info)

    end
  end
end

GUI.func = set_values
GUI.freq = 1 -- Aufruf jede Sekunde
   
-- Open Settings Screen, when it hasn't been opened yet
    if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
    else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

    if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time. 
                            -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc
      GUI.Init()
      GUI.Main()
    end
