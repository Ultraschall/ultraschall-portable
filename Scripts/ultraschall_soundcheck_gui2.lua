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

local function splitWords(Lines, limit)
  while #Lines[#Lines] > limit do
          Lines[#Lines+1] = Lines[#Lines]:sub(limit+1)
          Lines[#Lines-1] = Lines[#Lines-1]:sub(1,limit)
  end
end


local function wrap(str, limit)
  local Lines, here, limit, found = {}, 1, limit or 72, str:find("(%s+)()(%S+)()")

  if found then
          Lines[1] = string.sub(str,1,found-1)  -- Put the first word of the string in the first index of the table.
  else Lines[1] = str end

  str:gsub("(%s+)()(%S+)()",
          function(sp, st, word, fi)  -- Function gets called once for every space found.
                  splitWords(Lines, limit)

                  if fi-here > limit then
                          here = st
                          Lines[#Lines+1] = word                                                                                   -- If at the end of a line, start a new table index...
                  else Lines[#Lines] = Lines[#Lines].." "..word end  -- ... otherwise add to the current table index.
          end)

  splitWords(Lines, limit)

  return Lines
end


function run_action(commandID)

  local CommandNumber = reaper.NamedCommandLookup(commandID)
  reaper.Main_OnCommand(CommandNumber,0)

end

function count_warnings(event_count)

-- count the number of warnings

  local warning_count = 0
  for i = 1, event_count do

    local EventIdentifier = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

    if last_state == true then
      warning_count = warning_count +1
    end
  end
  return warning_count
end



function count_all_warnings(event_count)

  local active_warning_count = 0
  local paused_warning_count = 0
  local description_lines = 0
  for i = 1, event_count do

    local EventIdentifier = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

    if last_state == true and EventPaused ~= true then -- es ist eine Warnung und sie steht nicht auf ignored
      DescriptionWarning = ultraschall.GetUSExternalState(EventName, "DescriptionWarning","ultraschall-settings.ini")
      DescriptionWarning = string.gsub(DescriptionWarning, "|", " ")
      local infotable = wrap(DescriptionWarning,80)

      description_lines = description_lines + #infotable
      active_warning_count = active_warning_count +1
    elseif EventPaused == true then

      paused_warning_count = paused_warning_count + 1

    end
  end
  return active_warning_count, paused_warning_count, description_lines
end



function ignore_all_warnings()

  -- count the number of warnings

  local event_count = ultraschall.EventManager_CountRegisteredEvents()
  local warning_count = 0
    for i = 1, event_count do

      local EventIdentifier = ""

      EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

      last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

      if last_state == true then
        ultraschall.EventManager_PauseEvent(EventIdentifier)
      end
    end
    return warning_count
  end


function count_paused(event_count)

  -- count the number of warnings

  local paused_count = 0
  for i = 1, event_count do

    local EventIdentifier = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    if EventPaused == true then
      paused_count = paused_count +1
    end
  end
  return paused_count
end


function toggle_more()

  show_info = true
  ultraschall.SetUSExternalState("ultraschall_gui", "showinfo", "true")
  refresh_gui = true



end

function toggle_less()

  show_info = false
  ultraschall.SetUSExternalState("ultraschall_gui", "showinfo", "false")
  refresh_gui = true

end

function ignore(EventIdentifier)

  ultraschall.EventManager_PauseEvent(EventIdentifier)
  local event_count = ultraschall.EventManager_CountRegisteredEvents()
  -- print(count_warnings(event_count).."-"..count_paused(event_count))
  if count_warnings(event_count) == count_paused(event_count)+1 then
    -- v
    all_ignored = reaper.time_precise()
  end

end


function string.split(str, delimiter)

  if (delimiter=='') then return false end
  local pos,array = 0, {}
  -- for each divider found
  for st,sp in function() return string.find(str, delimiter, pos, true) end do
      table.insert(array, string.sub(str, pos, st - 1))
      pos = sp + 1
  end
  table.insert(array, string.sub(str, pos))
  return array

end






------------------------------------------------------
--  End of functions
------------------------------------------------------


------------------------------------------------------
--  Setze Variablen
------------------------------------------------------

event_count = ultraschall.EventManager_CountRegisteredEvents()
active_warning_count, paused_warning_count, description_lines = count_all_warnings(event_count)

WindowHeight = 150 + (paused_warning_count*30) + (active_warning_count*30) + description_lines*30


-- Grab all of the functions and classes from our GUI library

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")
gfx_path = script_path.."/Ultraschall_Gfx/Soundcheck/"
header_path = script_path.."/Ultraschall_Gfx/Headers/"
all_ignored = false

---- Window settings and user functions ----

GUI.name = "Ultraschall Soundcheck"
-- GUI.w, GUI.h = 800, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?
GUI.w, GUI.h = 1000, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?


------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2
refresh_gui = true

show_info = toboolean(ultraschall.GetUSExternalState("ultraschall_gui", "showinfo"))

  -- body
  ---- GUI Elements ----


------------------------------------------------------
--  Aufbau der nicht interkativen GUI-Elemente wie Logos etc.
------------------------------------------------------

function buildGuiWarnings()

  if all_ignored and reaper.time_precise() - all_ignored > 3 then
    gfx.quit()
  end


  local event_count = ultraschall.EventManager_CountRegisteredEvents()
  active_warning_count, paused_warning_count, description_lines = count_all_warnings(event_count)

  ignored_position = 140 + (active_warning_count*43) + description_lines*24
  warnings_position = 140
  position = 140


  if active_warning_count ~= lastWarningCount or paused_warning_count ~= lastPausedCount or active_warning_count + paused_warning_count == 0 then
    refresh_gui = true
  end

  lastWarningCount = active_warning_count
  lastPausedCount = paused_warning_count


  if refresh_gui == true then

    WindowHeight = 120 + (paused_warning_count*60) + (active_warning_count*30) + description_lines*30
    if active_warning_count + paused_warning_count == 0 then WindowHeight = 500 end
    -- GUI.y = (screen_h - WindowHeight + 210 - warningCount*30) / 2
    GUI.y = (screen_h - WindowHeight) - 150
    -- GUI.y = 300
    gfx.init("", 1000, WindowHeight, 0, GUI.x, GUI.y)
    refresh_gui = false

  end

  if active_warning_count == 5 and eastereggShown == nil then

    easteregg = "The project just scored five warnings.\nIt can only be attributable to human error.\n\nI can see you're really upset about this. I honestly think you ought to sit down calmly, take a stress pill, and think things over. I've still got the greatest enthusiasm and confidence in your podcast. And I want to help you.\n\nmaybe a round of moonlander would do you good?"

    result = reaper.ShowMessageBox( easteregg, "Soundcheck - Deep Trouble Alert", 0 )  -- Info window
    eastereggShown = true
    run_action("_Ultraschall_Moonlander")

  end



  GUI.elms = {}


  ------- Header


  header = GUI.Area:new(0,0,1000,90,0,1,1,"header_bg")
  table.insert(GUI.elms, header)

  logo = GUI.Pic:new(          45,  25,   0,  0,    1,   header_path.."soundcheck_logo.png")
  table.insert(GUI.elms, logo)

  headertxt = GUI.Pic:new(          115,  36,   0,  0,    0.8,   header_path.."headertxt_soundcheck.png")
  table.insert(GUI.elms, headertxt)


  -----------------------------------------------------------------
  -- Settings-Buttons
  -----------------------------------------------------------------

  button_settings = GUI.Btn:new(870, 38, 85, 20,         " Settings...", run_action, "_Ultraschall_Settings")
  table.insert(GUI.elms, button_settings)

  -- button_all = GUI.Btn:new(770, 50, 85, 20,         " All Checks", run_action, "_Ultraschall_Settings")
  -- table.insert(GUI.elms, button_all)



  if active_warning_count + paused_warning_count == 0 then

    block0 = GUI.Area:new(305,230,50, 110,15,1,1,"txt_green")
    table.insert(GUI.elms, block0)

    block2 = GUI.Area:new(375,230,348, 110,15,1,1,"section_bg")
    table.insert(GUI.elms, block2)

    well_txt = GUI.Pic:new(          427,  268,   0,  0,    0.9,   header_path.."all_is_well.png")
    table.insert(GUI.elms, well_txt)

  end


  lastcount = reaper.time_precise()

  for i = 1, event_count do

    -- print (reaper.time_precise()-lastcount)
    -- lastcount = reaper.time_precise()


    -- Suche die Sections der ultraschall.ini heraus, die in der Settings-GUI angezeigt werden sollen

    EventIdentifier = ""
    button1 = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)
    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

    Button1Label = ultraschall.GetUSExternalState(EventName, "Button1Label","ultraschall-settings.ini")
    Button1Action = ultraschall.GetUSExternalState(EventName, "Button1Action","ultraschall-settings.ini")
    Button2Label = ultraschall.GetUSExternalState(EventName, "Button2Label","ultraschall-settings.ini")
    Button2Action = ultraschall.GetUSExternalState(EventName, "Button2Action","ultraschall-settings.ini")
    DescriptionWarning = ultraschall.GetUSExternalState(EventName, "DescriptionWarning","ultraschall-settings.ini")
    Description = ultraschall.GetUSExternalState(EventName, "Description","ultraschall-settings.ini")
    EventNameDisplay = ultraschall.GetUSExternalState(EventName, "EventNameDisplay","ultraschall-settings.ini")

    -- Name



    if EventPaused == true or last_state == true then

      -- State

      if EventPaused == true then
        state_color = "txt_yellow"
        button1 = GUI.Btn:new(65, ignored_position-4, 80, 20,         " Re-Check", ultraschall.EventManager_ResumeEvent, EventIdentifier)
        table.insert(GUI.elms, button1)
      elseif last_state == true then
        state_color = "txt_red"
        button1 = GUI.Btn:new(65, warnings_position-4, 60, 20,         " Ignore", ignore, EventIdentifier)
        table.insert(GUI.elms, button1)
      else
        state_color = "txt_green"
      end


      DescriptionWarning = string.gsub(DescriptionWarning, "|", " ")

      local infotable = wrap(DescriptionWarning,80) -- Zeilenumbruch 80 Zeichen für Warnungsbeschreibung

      if EventPaused ~= true then
        areaHeight = 38 + (20*#infotable)
        position = warnings_position
      else
        areaHeight = 33
        position = ignored_position
      end

      block = GUI.Area:new(170,position-10,782, areaHeight,5,1,1,"section_bg")
      table.insert(GUI.elms, block)


      id = GUI.Lbl:new(180, position-2, EventNameDisplay, 0, "txt", 2)
      table.insert(GUI.elms, id)

      light = GUI.Area:new(48,position-5,10,21,3,1,1,state_color)
      table.insert(GUI.elms, light)




      if EventPaused ~= true then -- Erklärtexte und Action Buttons nur bei warnings, nicht bei ignore


        warnings_position = warnings_position + 25

        -- Action Buttons

        button_offset = 0
        ButtonPosition = warnings_position + (areaHeight*0.5) - 83

        if Button2Label ~= "" and Button2Action and last_state_string ~= "OK" then -- es gibt Probleme

          button_offset = 15
          button3 = GUI.Btn:new(790, ButtonPosition+40+button_offset, 144, 20,         Button2Label, run_action, Button2Action)
          table.insert(GUI.elms, button3)

        end

        if Button1Label and Button1Action and last_state_string ~= "OK" then -- es gibt Probleme

          button2 = GUI.Btn:new(790, ButtonPosition+40-button_offset, 144, 20,         Button1Label, run_action, Button1Action)
          table.insert(GUI.elms, button2)
        end

        -- Erklärtexte

        for k, warningtextline in pairs(infotable) do

          infotext = GUI.Lbl:new(180, warnings_position, warningtextline, 0, "txt_grey")
          table.insert(GUI.elms, infotext)
          warnings_position = warnings_position +20

          -- print(k, v)
        end

        warnings_position = warnings_position + 30

      else

        ignored_position = ignored_position + 50

      end


    end

  end

end



function buildGui()

  local event_count = ultraschall.EventManager_CountRegisteredEvents()

  GUI.elms = {}

  GUI.elms = {

  --     name          = element type          x    y    w   h  zoom    caption                                                              ...other params...

    label_interfaces = GUI.Lbl:new(          360, 110,                  "Soundcheck",          0),
    label_table      = GUI.Lbl:new(          20, 250,                  "Check                                                         Status                        Actions",          0),
    line1            = GUI.Line:new(0, 271, 800, 271, "txt_muted"),
    line2            = GUI.Line:new(0, 270, 800, 270, "elm_outline"),

    -- checkers         = GUI.Checklist:new(     20, 380, 240, 30,         "",                                                                   "Show this Screen on Start", 4),
    -- checkers2        = GUI.Checklist:new(    405, 380, 240, 30,         "",                                                                   "Automatically check for updates", 4),

    -- tutorials        = GUI.Btn:new(           30, 320, 190, 40,         "Tutorials",                                                          open_url, "http://ultraschall.fm/tutorials/"),

  }



  -----------------------------------------------------------------
  -- Settings-Button
  -----------------------------------------------------------------

  button_settings = GUI.Btn:new(700, 245, 85, 20,         " Settings...", run_action, "_Ultraschall_Settings")
  table.insert(GUI.elms, button_settings)

  -----------------------------------------------------------------
  -- initialise the events - coming from the EventManager
  -----------------------------------------------------------------


  ------------------------------------------------------
  -- Gehe alle Sektionen der ultraschall.ini durch und baut die normalen Settings auf.
  -- Kann perspektivisch in eine Funktion ausgelagert werden
  ------------------------------------------------------



  warningCount = count_warnings(event_count)
  if warningCount ~= lastWarningCount then
    refresh_gui = true
  end
  lastWarningCount = warningCount

  if warningCount == 0 and show_info == false then
    GUI.elms = {

      label_interfaces = GUI.Lbl:new(          360, 110,                  "Soundcheck",          0),

    }
  end

  position_warnings = 290                              -- Warnings immer oben
  position_info = 290 + (warningCount * 30)   -- ab hier nur Infoeinträge





  if show_info == true then
    WindowHeight = 260 + (event_count*30) +80
    button_more = GUI.Btn:new(365, WindowHeight-19, 70, 20,         " ▲", toggle_less)
    table.insert(GUI.elms, button_more)
    GUI.y = (screen_h - WindowHeight) / 2

  elseif warningCount == 0 then
    WindowHeight = 220
    button_more = GUI.Btn:new(365, WindowHeight-19, 70, 20,         " ▼", toggle_more)
    table.insert(GUI.elms, button_more)
    GUI.y = (screen_h - WindowHeight + 330 - warningCount*30) / 2

  else
    WindowHeight = 260 + (warningCount*30) +80
    button_more = GUI.Btn:new(365, WindowHeight-19, 70, 20,         " ▼", toggle_more)
    table.insert(GUI.elms, button_more)
    GUI.y = (screen_h - WindowHeight + 210 - warningCount*30) / 2
  end

  if refresh_gui == true then

    gfx.init("", 800, WindowHeight, 0, GUI.x, GUI.y)
    refresh_gui = false

  end

  for i = 1, event_count do

    -- Suche die Sections der ultraschall.ini heraus, die in der Settings-GUI angezeigt werden sollen

    EventIdentifier = ""
    button1 = ""

    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)

    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

    if show_info == true or last_state == true then


      if last_state == true then
        position = position_warnings
        position_warnings = position_warnings +30
      else
        position = position_info
        position_info = position_info +30
      end

      -- print(i.."-"..EventName.."-"..EventIdentifier.."-"..tostring(last_state))

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
        button1 = GUI.Btn:new(401, position-4, 80, 20,         " Ignore", ignore, EventIdentifier)
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

        if show_info == true then -- ausgeklappt also ?

          info_button = GUI.Btn:new(365, position-4, 20, 20,         " ?", show_menu, DescriptionWarning)
          table.insert(GUI.elms, info_button)

        else -- nur Fehler also direkt schreiben
          infotable = string.split(DescriptionWarning, "|")

          for k, warningtextline in pairs(infotable) do

            infotext = GUI.Lbl:new(20, position_warnings, warningtextline, 0)
            table.insert(GUI.elms, infotext)
            position_warnings = position_warnings +20

            -- print(k, v)
          end
          position_warnings = position_warnings +40
        end
      else -- normaler Info-Text
        info_button = GUI.Btn:new(365, position-4, 20, 20,         " ?", show_menu, Description)
        table.insert(GUI.elms, info_button)
      end
    end
  end



  if warningCount > 0 then

    if warningCount == 1 then
      countText = "warning"
    else
      countText = "warnings"
    end

    warningtext1 = "found "..warningCount.." "..countText.."."
    warningtext2 = "Please check the warnings below. Use the ?-button to get some advice."
    warningtext3 = "You may ignore a warning for this session or use the action buttons to solve the issues."
    warningtext4 = "Visit the settings to disable warnings permanently."

    warning1 = GUI.Lbl:new(347, 128, warningtext1, 0)
    table.insert(GUI.elms, warning1)
    warning2 = GUI.Lbl:new(158, 168, warningtext2, 0)
    table.insert(GUI.elms, warning2)
    warning3 = GUI.Lbl:new(106, 188, warningtext3, 0)
    table.insert(GUI.elms, warning3)
    warning4 = GUI.Lbl:new(236, 208, warningtext4, 0)
    table.insert(GUI.elms, warning4)


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


  logo = GUI.Pic:new(          300,  10,   0,  0,    1,   gfx_path..logo_img)
  table.insert(GUI.elms, logo)

  if warningCount == 5 and eastereggShown == nil then
    easteregg = "The project just scored five warnings.\nIt can only be attributable to human error.\n\nI can see you're really upset about this. I honestly think you ought to sit down calmly, take a stress pill, and think things over. I've still got the greatest enthusiasm and confidence in your podcast. And I want to help you.\n\nmaybe a round of moonlander would do you good?"

    result = reaper.ShowMessageBox( easteregg, "Soundcheck - Deep Trouble Alert", 0 )  -- Info window
    eastereggShown = true
    run_action("_Ultraschall_Moonlander")

  end


end


GUI.func = buildGuiWarnings -- Dauerschleife
GUI.freq = 1          -- Aufruf jede Sekunde



-- Open Soundcheck Screen, when it hasn't been opened yet

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows


if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  -- buildGui()
  buildGuiWarnings()
  GUI.Init()

  GUI.Main()
end

function atexit()
  if ultraschall.GetUSExternalState("ultraschall_settings_graceful_soundcheck", "Value","ultraschall-settings.ini") == "1" then
    ignore_all_warnings()
  end
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)

end

reaper.atexit(atexit)
