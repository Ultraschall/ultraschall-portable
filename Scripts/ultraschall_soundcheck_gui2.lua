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
--  Show the GUI menu item. Wird verwendet, um Info-Texte hinter den Buttins anzuzeigen.
------------------------------------------------------

function show_menu(str)

  gfx.x, gfx.y = GUI.mouse.x+20, GUI.mouse.y-10
  selectedMenu = gfx.showmenu(str)
  return selectedMenu

end


function run_action(commandID)

  CommandNumber = reaper.NamedCommandLookup(commandID)
  reaper.Main_OnCommand(CommandNumber,0)

end

------------------------------------------------------
--  End of functions
------------------------------------------------------


-- Grab all of the functions and classes from our GUI library

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall Soundcheck"
GUI.w, GUI.h = 800, 600   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?

------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2



  -- body
  ---- GUI Elements ----


------------------------------------------------------
--  Aufbau der nicht interkativen GUI-Elemente wie Logos etc.
------------------------------------------------------

function buildGui()

  GUI.elms = {}

  GUI.elms = {

  --     name          = element type          x    y    w   h  zoom    caption                                                              ...other params...


    label_interfaces = GUI.Lbl:new(          360, 110,                  "Soundcheck",          0),
    label_table      = GUI.Lbl:new(          20, 210,                  "Check                                                                Status                                    Actions",          0),
    line1            = GUI.Line:new(0, 231, 800, 231, "txt_muted"),
    line2            = GUI.Line:new(0, 230, 800, 230, "elm_outline"),

    -- checkers         = GUI.Checklist:new(     20, 380, 240, 30,         "",                                                                   "Show this Screen on Start", 4),
    -- checkers2        = GUI.Checklist:new(    405, 380, 240, 30,         "",                                                                   "Automatically check for updates", 4),

    -- tutorials        = GUI.Btn:new(           30, 320, 190, 40,         "Tutorials",                                                          open_url, "http://ultraschall.fm/tutorials/"),

  }


  ---- Put all of your own functions and whatever here ----


  -----------------------------------------------------------------
  -- initialise the events - coming from the EventManager
  -----------------------------------------------------------------

  event_count = ultraschall.EventManager_CountRegisteredEvents()

  ------------------------------------------------------
  -- Gehe alle Sektionen der ultraschall.ini durch und baut die normalen Settings auf.
  -- Kann perspektivisch in eine Funktion ausgelagert werden
  ------------------------------------------------------

  position = 220
  warningCount = 0

  for i = 1, event_count do

    -- Suche die Sections der ultraschall.ini heraus, die in der Settings-GUI angezeigt werden sollen

    position = position + 30 -- Feintuning notwendig

    EventIdentifier = ""
    button1 = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState(i)

    if last_state == true then
      warningCount = warningCount +1
    end
    -- Name

    EventNameDisplay = ultraschall.GetUSExternalState(EventName, "EventNameDisplay")

    id = GUI.Lbl:new(20, position, EventNameDisplay, 0)
    table.insert(GUI.elms, id)

    -- State

    if EventPaused == true then
      last_state_string = "IGNORED"
      state_color = "txt_yellow"
    elseif last_state == true then
      last_state_string = "WARNING"
      state_color = "txt_red"
    else
      last_state_string = "OK"
      state_color = "txt_green"
    end

    id = GUI.Lbl:new(320, position, last_state_string, 0, state_color)
    table.insert(GUI.elms, id)

    -- Buttons

    if EventPaused == true then
      button1 = GUI.Btn:new(450, position-5, 80, 20,         " retry", ultraschall.EventManager_ResumeEvent, EventIdentifier)
      table.insert(GUI.elms, button1)

    elseif last_state == true then
      button1 = GUI.Btn:new(450, position-5, 80, 20,         " ignore", ultraschall.EventManager_PauseEvent, EventIdentifier)
      table.insert(GUI.elms, button1)

    end




        -- Action-Button
    Button1Label = ultraschall.GetUSExternalState(EventName, "Button1Label")
    Button1Action = ultraschall.GetUSExternalState(EventName, "Button1Action")
    if Button1Label and Button1Action and last_state_string ~= "OK" then

      -- print("huhu")

      -- command_id = tostring(reaper.NamedCommandLookup(Button1Action))
      -- reaper.Main_OnCommand(start_id,0)   --Show Soundcheck Screen

      button2 = GUI.Btn:new(550, position-5, 140, 20,         Button1Label, run_action, Button1Action)
      table.insert(GUI.elms, button2)
    end



  -- print("----")
  end

  if warningCount > 0 then

    if warningCount == 1 then
      countText = "warning"
    else
      countText = "warnings"
    end

    warningtext1 = "Soundcheck found "..warningCount.." "..countText.."."
    warningtext2 = "Please check the warnings below and use the action buttons to solve the issues."
    warning1 = GUI.Lbl:new(302, 130, warningtext1, 0)
    table.insert(GUI.elms, warning1)
    warning2 = GUI.Lbl:new(148, 150, warningtext2, 0)
    table.insert(GUI.elms, warning2)


  else

    warningtext1 = "found no problems at all."
    warningtext2 = "Good job!"
    warning1 = GUI.Lbl:new(320, 130, warningtext1, 0)
    table.insert(GUI.elms, warning1)
    warning2 = GUI.Lbl:new(368, 150, warningtext2, 0)
    table.insert(GUI.elms, warning2)

  end







  if warningCount == 0 then
    logo_img = "us_small_ok.png"
  elseif warningCount > 4 then
    logo_img = "us_small_warnings_5.png"
  else
    logo_img = "us_small_warnings_"..warningCount..".png"
  end


  logo = GUI.Pic:new(          300,  10,   0,  0,    1,   script_path..logo_img)
  table.insert(GUI.elms, logo)




end


GUI.func = buildGui -- Dauerschleife
GUI.freq = 1          -- Aufruf jede Sekunde



-- Open Soundcheck Screen, when it hasn't been opened yet

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

if windowcounter<10 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  buildGui()
  GUI.Init()
  GUI.Main()
end
