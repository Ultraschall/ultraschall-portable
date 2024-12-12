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
  
  function Slider_RunFunction(used_slider_id, current_value)
    -- this function is run, when the slider is moved
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("The current value is: "..current_value)
  end

  function Checkbox_RunFunction(checked_checkbox_id, checkstate)
    -- this function is run, when the checkstate of a checkbox is changed
    
    if checked_checkbox_id==checkbox_disableSlider_id then
      -- if the first checkbox's checkstate is changed to true
      if reagirl.Checkbox_GetCheckState(checked_checkbox_id)==true then
        reagirl.Slider_SetDisabled(slider_id, false) -- set the slider enabled
      else -- otherwise
        reagirl.Slider_SetDisabled(slider_id, true)  -- set the slider disabled
      end
      -- if the second checkbox's checkstate is changed to true
    elseif checked_checkbox_id==checkbox_disableDropDownMenu_id then
      if reagirl.Checkbox_GetCheckState(checked_checkbox_id)==true then
        reagirl.DropDownMenu_SetDisabled(dropdownmenu_id, false) -- set the drop down menu to enabled
      else -- otherwise
        reagirl.DropDownMenu_SetDisabled(dropdownmenu_id, true)  -- set the drop down menu to disabled
      end
    end
  end

  function DropDownMenu_RunFunction(used_dropdownmenu_id, selected_menuitem, selected_name)
    -- this function is run, when the user selects a menu-entry
    reaper.MB("Dropdownmenu entry #"..selected_menuitem.." - "..selected_name, "", 0)
  end

  -- create new gui
  reagirl.Gui_New()

  -- add a checkbox and a slider to the gui
  checkbox_disableSlider_id = reagirl.Checkbox_Add(30, 50, "Activated", "Check to activate slider.", true, Checkbox_RunFunction)
  slider_id = reagirl.Slider_Add(200, 50, -20, "I am a slider", nil, "A slider to set a value.", "%", 20, 200, 1, 25, 100, Slider_RunFunction)

  -- add a checkbox and a drop-down-menu to the gui
  checkbox_disableDropDownMenu_id = reagirl.Checkbox_Add(30, 72, "Activated", "Check to activate drop-down-menu.", false, Checkbox_RunFunction)
  dropdownmenu_id = reagirl.DropDownMenu_Add(200, 72, -20, "I am a dropdownmenu", nil, "A Drop Down Menu to choose from.", {"Entry 1 - The first entry", "Entry 2 - The second entry", "Entry 3 - The third entry"}, 2, DropDownMenu_RunFunction)

  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with settings for tool xyz.", 640, 120)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()