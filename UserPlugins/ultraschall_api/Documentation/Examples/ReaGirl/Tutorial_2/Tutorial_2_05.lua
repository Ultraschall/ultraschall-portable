--[[
################################################################################
# 
# Copyright (c) 2023-present Meo-Ada Mespotine mespotine.de
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

  dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
  
  function Button_RunFunction(pressed_button_id)
    -- this function is run, when a button is pressed
    if pressed_button_id==tab3.button_ok_id then
      reaper.MB("OK Button is pressed", "OK Button", 0)
    elseif pressed_button_id==tab3.button_cancel_id then
      reaper.MB("Cancel Button is pressed", "Cancel Button", 0)
    end
  end

  function Checkbox_RunFunction(checked_checkbox_id, checkstate)
    -- this function is run, when the checkstate of a checkbox is changed
    if checked_checkbox_id==tab2.checkbox_remember then
      reaper.MB("Checkbox \"Remember\" is "..tostring(checkstate), "Checkbox-State changed", 0)
    elseif checked_checkbox_id==tab2.checkbox_mysetting then
      reaper.MB("Checkbox \"my Setting\" is "..tostring(checkstate), "Checkbox-State changed", 0)
    end
  end

  function InputBox_RunFunction_Type(inputbox_id, entered_text)
    -- this function is run, when the user types in text into an inputbox
    reaper.ClearConsole()
    if inputbox_id==tab1.inputbox_name_of_setting then
      reaper.ShowConsoleMsg("NAME: "..entered_text)
    elseif inputbox_id==tab1.inputbox_description_of_setting then
      reaper.ShowConsoleMsg("DESCRIPTION: "..entered_text)
    end
  end

  function InputBox_RunFunction_Enter(inputbox_id, entered_text)
    -- this function is run, when the user hits enter into an inputbox
    if inputbox_id==tab1.inputbox_name_of_setting then
      reaper.MB(entered_text, "The typed text into NAME was", 0)
    elseif inputbox_id==tab1.inputbox_description_of_setting then
      reaper.MB(entered_text, "The typed text into DESCRIPTION was", 0)
    end
  end
  
  
  function Tab_RunFunction(tab_id, tab_selected, tab_name_selected)
    -- this function is run, when tabs are switched
  end

  -- create new gui
  reagirl.Gui_New()

  -- add tables that will contain the element-ids of the ui-element
  tab1={} -- for the ui-elements in tab 1
  tab2={} -- for the ui-elements in tab 2
  tab3={} -- for the ui-elements in tab 3
  
  -- let's add tabs
  tabs_id = reagirl.Tabs_Add(10, 10, 620, 187, "Tabs", "Different options in this dialog.", {"Inputboxes", "Checkboxes", "Buttons"}, 1, Tab_RunFunction)
  
  -- add inputboxes to type in text
  tab1.inputbox_name_of_setting = reagirl.Inputbox_Add(30, 105, 300, "Name of the setting:", 150, "Type in here the name of the setting.", "No title", InputBox_RunFunction_Enter, InputBox_RunFunction_Type)
  tab1.inputbox_description_of_setting = reagirl.Inputbox_Add(30, 130, 300, "Description of the setting:", 150, "Type in here a description of the setting.", "No Description", InputBox_RunFunction_Enter, InputBox_RunFunction_Type)
  
  -- add two checkboxes to the gui
  tab2.checkbox_mysetting = reagirl.Checkbox_Add(30, 150, "My setting", "How shall my setting be set?", true, Checkbox_RunFunction)
  tab2.checkbox_remember = reagirl.Checkbox_Add(30, 170, "Remember chosen setting", "Shall this setting be used as future default?", true, Checkbox_RunFunction)

  -- add an ok-button and a cancel button to the gui
  tab3.button_ok_id = reagirl.Button_Add(30, 200, 0, 0, "OK", "Apply changes and close dialog.", Button_RunFunction)
  tab3.button_cancel_id = reagirl.Button_Add(70, 200, 0, 0, "Cancel", "Discard changes and close dialog.", Button_RunFunction)

  -- let's force window-sizes
  reagirl.Window_ForceSize_Minimum(550, 200)  -- set the minimum size of the window
  reagirl.Window_ForceSize_Maximum(1150, 400) -- set the maximum size of the window
  
  -- set ui-elements to the tabs. 
  -- Give tab 1 the ui-elements stored in tab1, give tab 2 the ui-elements stored in tab2 
  -- and give tab 3 the ones stored in tab3.
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 1, tab1)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 2, tab2)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 3, tab3)
  
  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with some options.", 640, 250)

  -- make the background grey
  reagirl.Background_GetSetColor(true, 55, 55, 55)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()