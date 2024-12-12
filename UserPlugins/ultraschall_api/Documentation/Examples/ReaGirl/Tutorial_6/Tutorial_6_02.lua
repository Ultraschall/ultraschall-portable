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
  
  function Button_RunFunction()
    -- this function will be run when the button is pressed
    
    -- It stores the setting and keeps the dialog open
    reaper.SetExtState("My_Setting", "My_Key", reagirl.Slider_GetValue(slider_percentage), true)
  end
  
  function AtExit_RunFunction()
    -- this function is run when the window is closed by either esc-key or the x-button of the window
    
    -- it will show an aborted dialog
    reaper.MB("Aborted setting the percentage.\n\nPercentage is not stored.", "Abort", 0)
  end

  -- create new gui
  reagirl.Gui_New()

  -- Add a slider and a button to the gui.
  -- First: get old stored value of the slider
  old_slider_value=reaper.GetExtState("My_Setting", "My_Key") 
  -- Second: if there isn't a slider-value stored yet, use a default of 0
  if old_slider_value=="" then old_slider_value=0 else old_slider_value=tonumber(old_slider_value) end 
  -- add the slider with the slider-value stored in old_slider_value
  slider_percentage = reagirl.Slider_Add(4, 4, 250, "Percentage", 140, "Set the percentage.", nil, 0, 8, 1, old_slider_value, 0, nil)
  -- add a store button
  button = reagirl.Button_Add(260, 4, 0, 0, "Store", "Store percentage setting.", Button_RunFunction)

  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with settings for tool xyz.", 325, 40)

  reagirl.Gui_AtExit(AtExit_RunFunction)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()