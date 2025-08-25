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
  
  -- create new gui
  reagirl.Gui_New()
  
  tab1={}
  tab2={}
  tab3={}
  tab4={}
  
  -- let's add tabs
  tabs_id = reagirl.Tabs_Add(10, 10, 620, 187, "Tabs", "Different options in this dialog.", {"Tab1", "Tab2", "Tab3", "Tab4"}, 1, Tab_RunFunction)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 1, tab1)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 2, tab2)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 3, tab3)
  reagirl.Tabs_SetUIElementsForTab(tabs_id, 4, tab4)
  --]]
  
  -- first line of checkboxes
  tab1.checkbox1 = reagirl.Checkbox_Add(nil, nil, "Checkbox 1", "This is the first checkbox.", true, nil)
  tab1.checkbox2 = reagirl.Checkbox_Add(nil, nil, "Checkbox 2", "This is the second checkbox.", true, nil)
  tab1.checkbox3 = reagirl.Checkbox_Add(nil, nil, "Checkbox 3", "This is the third checkbox.", true, nil)
  
  -- second line of checkboxes
  reagirl.NextLine() -- start a new line of ui-elements
  tab2.checkbox1 = reagirl.Checkbox_Add(nil, nil, "Checkbox 4", "This is the fourth checkbox.", true, nil)
  tab2.checkbox2 = reagirl.Checkbox_Add(nil, nil, "Checkbox 5", "This is the fifth checkbox.", true, nil)
  
  -- third line with one checkbox and one button anchored to right side of the window
  -- this line is placed 10 pixels lower to gain some distance between the lines
  reagirl.NextLine(10) -- start a new line of ui-elements, ten pixels lower than
  tab3.checkbox = reagirl.Checkbox_Add(nil, nil, "Checkbox 5", "This is the fifth checkbox.", true, nil)
  tab3.button = reagirl.Button_Add(nil, nil, 0, 0, "Store", "Store 1.", nil)
  
  -- fourth line with one checkbox and one button anchored to the left side of the window
  reagirl.NextLine()
  tab4.checkbox = reagirl.Checkbox_Add(nil, nil, "Checkbox 6", "This is the fifth checkbox.", true, nil)
  tab4.button = reagirl.Button_Add(nil, nil, 0, 0, "Store 2", "Store 2.", nil)

  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with settings for tool xyz.")--, 425, 240)

  -- make the background grey
  reagirl.Background_GetSetColor(true, 55, 55, 55)

  reagirl.Gui_AtExit(AtExit_RunFunction)
  reagirl.Gui_AtEnter(AtEnter_RunFunction)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()