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
  if pressed_button_id==button_ok_id then
    reaper.MB("OK Button is pressed", "OK Button", 0)
  elseif pressed_button_id==button_cancel_id then
    reaper.MB("Cancel Button is pressed", "Cancel Button", 0)
  end
end

function Checkbox_RunFunction(checked_checkbox_id, checkstate)
  -- this function is run, when the checkstate of a checkbox is changed
  if checked_checkbox_id==checkbox_remember then
    reaper.MB("Checkbox \"Remember\" is "..tostring(checkstate), "Checkbox-State changed", 0)
  elseif checked_checkbox_id==checkbox_mysetting then
    reaper.MB("Checkbox \"my Setting\" is "..tostring(checkstate), "Checkbox-State changed", 0)
  end
end

-- create new gui
reagirl.Gui_New()

-- add two checkboxes to the gui
checkbox_mysetting = reagirl.Checkbox_Add(30, 150, "My setting", "How shall my setting be set?", true, Checkbox_RunFunction)
checkbox_remember = reagirl.Checkbox_Add(30, 170, "Remember chosen setting", "Shall this setting be used as future default?", true, Checkbox_RunFunction)

-- add an ok-button and a cancel button to the gui
button_ok_id = reagirl.Button_Add(30, 200, 0, 0, "OK", "Apply changes and close dialog.", Button_RunFunction)
button_cancel_id = reagirl.Button_Add(70, 200, 0, 0, "Cancel", "Discard changes and close dialog.", Button_RunFunction)

-- open the new gui
reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with settings for tool xyz.", 640, 250)

function main()
  -- a function that runs the gui-manage function in the background, so the gui is updated correctly
  reagirl.Gui_Manage()
  
  -- if the gui-window hasn't been closed, keep the script alive.
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end

main()