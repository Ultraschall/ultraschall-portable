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
--  Show the GUI menu item. Wird verwendet, um Info-Texte hinter den Buttons anzuzeigen.
------------------------------------------------------

function show_menu(str)

  gfx.x, gfx.y = GUI.mouse.x+20, GUI.mouse.y-10
  selectedMenu = gfx.showmenu(str)
  return selectedMenu

end

------------------------------------------------------
--  führe eine Funktion aus nach Namen
------------------------------------------------------

function run_action(commandID)

  local CommandNumber = reaper.NamedCommandLookup(commandID)
  reaper.Main_OnCommand(CommandNumber,0)

end

------------------------------------------------------
--  Bau den Table mit allen Einträgen der MArker und Bilder auf
------------------------------------------------------

function build_markertable()

  markertable = {}
  run_action("_Ultraschall_Consolidate_Chapterimages") -- lese alle Images aus und schreibe sie in die ProjExt
  number_of_normalmarkers, normalmarkersarray = ultraschall.GetAllNormalMarkers()
  -- print(number_of_normalmarkers)

  for i = 1, number_of_normalmarkers do

    position = tostring(normalmarkersarray[i][0])

    markertable[position] = {}
    markertable[position]["name"] = normalmarkersarray[i][1]

  end

-- Gehe die Bilder mit Kapitelmarke durch

  for i = 0, 100 do

    retval, image_position, image_adress = reaper.EnumProjExtState (0, "chapterimages", i)
    if retval then

      -- print(image_position)

      markertable[image_position]["adress"] = image_adress

    else
      break
    end
  end

  -- Gehe die Bilder ohne Marke durch

  for i = 0, 100 do

    retval, image_position, image_adress = reaper.EnumProjExtState (0, "lostimages", i)
    if retval then

      -- print(image_position)
      markertable[image_position] = {}
      markertable[image_position]["adress"] = image_adress

    else
      break
    end
  end


  return markertable

end

------------------------------------------------------
-- Sortiere einen Table nach Index in einen neuen Table
------------------------------------------------------

function makeSortedTable(orig_table)
  tablesort = {}
  for key in pairs(orig_table) do
    table.insert( tablesort, key )
  end
  table.sort(tablesort)
  return tablesort
end

------------------------------------------------------
--  End of functions
------------------------------------------------------


------------------------------------------------------
--  Setze Variablen
------------------------------------------------------


markertable = build_markertable()
tablesort = makeSortedTable(markertable)
rows = #tablesort
WindowHeight = 60 + (rows * 30) +30


-- Grab all of the functions and classes from our GUI library

info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall Marker Dashboard"
GUI.w, GUI.h = 800, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?

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

  markertable = build_markertable()
  tablesort = makeSortedTable(markertable)

  GUI.elms = {}

  GUI.elms = {

  --     name          = element type          x    y    w   h  zoom    caption                                                              ...other params...


    label_interfaces = GUI.Lbl:new(          360, 110,                  "Soundcheck",          0),
    label_table      = GUI.Lbl:new(          20, 250,                  "Check                                                         Status                        Actions",          0),
    line1            = GUI.Line:new(0, 271, 800, 271, "txt_muted"),
    line2            = GUI.Line:new(0, 270, 800, 270, "elm_outline"),



  }


  button_settings = GUI.Btn:new(700, 245, 85, 20,         " Settings...", run_action, "_Ultraschall_Settings")
  table.insert(GUI.elms, button_settings)



  position = 60
  warningCount = 0


  for _, key in ipairs(tablesort) do

    -- print("---")
    position = position + 30
    output = key
    name = markertable[key]["name"]
    if name then

      id = GUI.Lbl:new(20, position, name, 0)
      table.insert(GUI.elms, id)

    end

  end

  --[[

  for i = 1, event_count do

    -- Suche die Sections der ultraschall.ini heraus, die in der Settings-GUI angezeigt werden sollen

    position = position + 30 -- Feintuning notwendig

    EventIdentifier = ""
    button1 = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

    -- print(i.."-"..EventName.."-"..EventIdentifier.."-"..tostring(last_state))

    if last_state == true then
      warningCount = warningCount +1
    end
    -- Name

    EventNameDisplay = ultraschall.GetUSExternalState(EventName, "EventNameDisplay","ultraschall-settings.ini")

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

    status = GUI.Lbl:new(288, position, last_state_string, 0, state_color)
    table.insert(GUI.elms, status)

    -- Buttons

    if EventPaused == true then
      button1 = GUI.Btn:new(401, position-4, 80, 20,         " Re-Check", ultraschall.EventManager_ResumeEvent, EventIdentifier)
      table.insert(GUI.elms, button1)

    elseif last_state == true then
      button1 = GUI.Btn:new(401, position-4, 80, 20,         " Ignore", ultraschall.EventManager_PauseEvent, EventIdentifier)
      table.insert(GUI.elms, button1)

    end




        -- Action-Button
    Button1Label = ultraschall.GetUSExternalState(EventName, "Button1Label","ultraschall-settings.ini")
    Button1Action = ultraschall.GetUSExternalState(EventName, "Button1Action","ultraschall-settings.ini")
    DescriptionWarning = ultraschall.GetUSExternalState(EventName, "DescriptionWarning","ultraschall-settings.ini")
    Description = ultraschall.GetUSExternalState(EventName, "Description","ultraschall-settings.ini")


    if Button1Label and Button1Action and last_state_string ~= "OK" then -- es gibt Probleme


      button2 = GUI.Btn:new(490, position-4, 144, 20,         Button1Label, run_action, Button1Action)
      table.insert(GUI.elms, button2)
    end

    Button2Label = ultraschall.GetUSExternalState(EventName, "Button2Label","ultraschall-settings.ini")
    Button2Action = ultraschall.GetUSExternalState(EventName, "Button2Action","ultraschall-settings.ini")

    if Button2Label ~= "" and Button2Action and last_state_string ~= "OK" then -- es gibt Probleme

      button3 = GUI.Btn:new(643, position-4, 144, 20,         Button2Label, run_action, Button2Action)
      table.insert(GUI.elms, button3)
    end

    if last_state_string ~= "OK" then -- es gibt Probleme
      info_button = GUI.Btn:new(365, position-4, 20, 20,         " ?", show_menu, DescriptionWarning)
      table.insert(GUI.elms, info_button)
    else -- normaler Info-Text
      info_button = GUI.Btn:new(365, position-4, 20, 20,         " ?", show_menu, Description)
      table.insert(GUI.elms, info_button)
    end



  -- print("----")
  end

]]

end





GUI.func = buildGui -- Dauerschleife
GUI.freq = 1          -- Aufruf jede Sekunde



-- Open Soundcheck Screen, when it hasn't been opened yet

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows


if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  buildGui()
  GUI.Init()
  GUI.Main()
end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)







--[[

for _, key in ipairs(tablesort) do

  print("---")

  output = key
  name = markertable[key]["name"]
  if name then
    output = output .. name
    print ("Name: " .. name)
  end
  adress = markertable[key]["adress"]
  if adress then output = output .. adress end

   -- .. markertable[key]["name"] .. markertable[key]["adress"]
  print (output)

end

]]

-- print(markertable)

-- end
