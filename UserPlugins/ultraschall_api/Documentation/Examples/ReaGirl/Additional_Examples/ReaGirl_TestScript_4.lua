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

-- Meo-Ada Mespotine 27th of March 2025 - licenced under MIT-license
-- This demo-dialog shows all ui-elements available. They have no functionality, since I set all run-function-parameters to nil.
-- Most ui-elements use nil as first and/or second parameter to use auto-positioning, but not all of them.
-- Means, you can place ui-elements automatically with either x-position or y-position with the other one a fixed coordinate.
-- So you can combine them.

  dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

  -- create new gui
  reagirl.Gui_New()
  tabs=reagirl.Tabs_Add(nil, nil, nil, nil, "Tabs", "Demo-Tabs most elements in first tab only.", {"Basic UI Elements", "More UI Elements"}, 1, nil)
  
  tab1={} -- the table for all ui-elements of tab 1
  tab2={} -- the table for all ui-elements of tab 2
  tab3={} -- the table for all ui-elements of tab 3
  reagirl.Tabs_SetUIElementsForTab(tabs, 1, tab1) -- associate ui-elements of table "tab1" with tab 1
  reagirl.Tabs_SetUIElementsForTab(tabs, 2, tab2) -- associate ui-elements of table "tab1" with tab 1
  reagirl.Tabs_SetUIElementsForTab(tabs, 3, tab3) -- associate ui-elements of table "tab1" with tab 1
  
  -- now let's add all ui-elements of the first tab to table tab1

 function clickable_label()
  reaper.MB("Label clicked", "Click", 0)
 end
 
  -- Labels
  tab1.label_header=reagirl.Label_Add(nil, nil, "Labels", "Possible labels with ReaGirl.", false, nil)
 
  reagirl.NextLine()
  tab1.label_regular=reagirl.Label_Add(nil, nil, "Example label", "A regular label.", false, nil)
  tab1.label_clickable=reagirl.Label_Add(nil, nil, "Clickable label", "A clickable label.", true, clickable_label, "JIMBO")
  
  tab1.label_styled=reagirl.Label_Add(nil, nil, "Styled label", "A styled label.", false, nil)
  reagirl.Label_SetStyle(tab1.label_styled, 7, 2, 0) -- set to inverted and italic

  reagirl.NextLine()
  tab1.label_small=reagirl.Label_Add(nil, nil, "different", "Label with small font-size.", false, nil)
  reagirl.Label_SetFontSize(tab1.label_small, 10) -- set to small font-size
  
  tab1.label_medium=reagirl.Label_Add(nil, nil, "font", "Label with medium font-size.", false, nil)
  reagirl.Label_SetFontSize(tab1.label_medium, 30) -- set to medium font-size
  
  tab1.label_large=reagirl.Label_Add(nil, nil, "size", "Label with large font-size.", false, nil)
  reagirl.Label_SetFontSize(tab1.label_large, 50) -- set to large font-size

  tab1.label_medium_and_style=reagirl.Label_Add(nil, nil, "and style", "Label with medium font-size and some styles.", false, nil)
  reagirl.Label_SetFontSize(tab1.label_medium_and_style, 30) -- set to medium font-size
  reagirl.Label_SetStyle(tab1.label_medium_and_style, 2, 0, 0) -- set to italic
  
  reagirl.Label_AutoBackdrop(tab1.label_header, tab1.label_large) -- set backdrop drawn by tab1.label_header
                                                                  -- let it end underneath tab1.label_large - the largest label

  -- Burgermenus and Color-Rectangles
  reagirl.NextLine(10)
  tab1.label_header6=reagirl.Label_Add(nil, nil, "Burgermenu and Color-Rectangle", "A burgermenu and some color-rectangles.", false, nil)
  
  reagirl.NextLine()
  tab1.burgermenu = reagirl.Burgermenu_Add(nil, nil, "A Burgermenu", 1, "A demo-burger-menu with some options.", "Setting 1|Setting 2|>Subfolder|Setting 3|Setting 4|<|Setting 5", nil)
  tab1.colorrectangle1 = reagirl.ColorRectangle_Add(nil,nil,16,16,255,0,0,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle2 = reagirl.ColorRectangle_Add(nil,nil,16,16,0,255,0,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle3 = reagirl.ColorRectangle_Add(nil,nil,16,16,0,0,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle4 = reagirl.ColorRectangle_Add(nil,nil,16,16,0,0,0,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle5 = reagirl.ColorRectangle_Add(nil,nil,16,16,255,255,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle6 = reagirl.ColorRectangle_Add(nil,nil,16,16,0,255,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle7 = reagirl.ColorRectangle_Add(nil,nil,16,16,255,0,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle8 = reagirl.ColorRectangle_Add(nil,nil,16,16,255,255,0,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle9 = reagirl.ColorRectangle_Add(nil,nil,16,16,128,255,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  tab1.colorrectangle10 = reagirl.ColorRectangle_Add(nil,nil,16,16,255,128,255,"A Color Rectangle", "A color rectangle with a color. Click it to select a different color.", true, nil)
  
  reagirl.Label_AutoBackdrop(tab1.label_header6, tab1.colorrectangle10) -- set backdrop drawn by tab1.label_header5
  
  -- Toolbar Buttons and Burgermenu at large
  reagirl.NextLine(10)
  tab1.label_header7=reagirl.Label_Add(nil, nil, "Burgermenu and Toolbar Buttons", "A burgermenu and some toobar-buttons.", false, nil)
  reagirl.NextLine()
  tab1.burgermenu2 = reagirl.Burgermenu_Add(nil, nil, "Another Burgermenu", 2, "A demo-burger-menu with some options.", "Setting 1|Setting 2|>Subfolder|Setting 3|Setting 4|<|Setting 5", nil)
  tab1.toolbar=reagirl.ToolbarButton_Add(71, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_misc_walk_forward.png",3, 2, {"TOO", "DEL", "LOO"}, 1, "Tudel1", "loo.", contextmenu)
  reagirl.ToolbarButton_SetRadius(tab1.toolbar, 14)
  reagirl.ToolbarButton_SetEdgeStyle(tab1.toolbar, true, true, true, true)
  reagirl.ToolbarButton_SetColor(tab1.toolbar, 128, 0, 0)
  tab1.toolbar2=reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_path_secondary_disk.png", 3, 2, {"One", "Two", "Three"}, 1+128, "Tudel2", "loo.", run_function)
  reagirl.ToolbarButton_SetDropShadow(tab1.toolbar2, true)
  reagirl.ToolbarButton_SetEdgeStyle(tab1.toolbar2, true, true, true, true)
  tab1.toolbar3=reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_misc_walk_forward.png",3, 2, {"A", "B", "C"}, 3+128, "TextIcon", "loo.", run_function)
  reagirl.ToolbarButton_SetDropShadow(tab1.toolbar3, true)
  reagirl.ToolbarButton_SetEdgeStyle(tab1.toolbar3, true, false, true, false)
  tab1.toolbar4=reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_misc_walk_forward.png",3, 2, {"Uno", "Dos", "Tres"}, 4, "Text Icon", "loo.", run_function)
  reagirl.ToolbarButton_SetRadius(tab1.toolbar4, 14)
  tab1.toolbar5=reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_misc_brush_broom_clean.png", 2, 1, {"TOO", "DEL", "LOO"}, 5+256, "Simple Icon", "loo.", run_function)
  reagirl.ToolbarButton_SetDropShadow(tab1.toolbar5, true)
  tab1.toolbar6=reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_eighth_quaver_grid.png", 3, 1, {"TOO", "DEL", "LOO"}, 2+256, "Borderless", "loo.", run_function)
  reagirl.ToolbarButton_SetDropShadow(tab1.toolbar6, true)
  
  reagirl.Label_AutoBackdrop(tab1.label_header7, tab1.toolbar6) -- set backdrop drawn by tab1.label_header5
  
  -- Inputboxes
  reagirl.NextLine(10)
  tab1.label_header2=reagirl.Label_Add(nil, nil, "Inputboxes", "Some demo-inputboxes.", false, nil)
  
  reagirl.NextLine()
  tab1.inputbox_name_of_setting = reagirl.Inputbox_Add(nil, nil, 284, "Name:", 90, "Type in here the name of the setting.", "No title", nil, nil)
  reagirl.Inputbox_SetTextSuggestions(tab1.inputbox_name_of_setting, {"AA","BB","CC","DD"})
  
  reagirl.NextLine()
  tab1.inputbox_description_of_setting = reagirl.Inputbox_Add(nil, nil, 284, "Description:", 90, "Type in here a description of the setting.", "No DescriptionNo DescriptionNo DescriptionNo DescriptionNo DescriptionNo DescriptionNo DescriptionNo Description", nil, nil)
  
  reagirl.NextLine()
  tab1.button_choose_file_id = reagirl.Button_Add(248, nil, 0, 0, "Choose file", "Choose a file.", nil) -- a button

  reagirl.Label_AutoBackdrop(tab1.label_header2, tab1.button_choose_file_id) -- set backdrop drawn by tab1.label_header2
                                                                             -- let it end underneath tab1.button_choose_file_id
  
  -- Checkboxes
  reagirl.NextLine(10)
  tab1.label_header3=reagirl.Label_Add(nil, nil, "And some checkboxes", "Some checkboxes in ReaGirl.", false, nil)

  reagirl.NextLine() -- first line of checkboxes
  tab1.checkbox_mysetting = reagirl.Checkbox_Add(nil, nil, "My setting", "The first checkbox.", true, nil)
  reagirl.Checkbox_SetWidth(tab1.checkbox_mysetting, 85) -- set the position of the next checkbox to a specific position to align it
                                                         -- with the next line of checkboxes
  tab1.checkbox_another_setting = reagirl.Checkbox_Add(nil, nil, "Another setting", "The second checkbox.", true, nil)
  
  reagirl.NextLine() -- second line of checkboxes
  tab1.checkbox_extra_setting = reagirl.Checkbox_Add(nil, nil, "Extra", "A third checkbox?", true, nil)
  reagirl.Checkbox_SetWidth(tab1.checkbox_extra_setting, 85) -- set the position of the next checkbox to a specific position to align it
                                                             -- with the previous line of checkboxes
  tab1.checkbox_remember = reagirl.Checkbox_Add(nil, nil, "Remember chosen setting", "Shall this setting be used as future default?", true, CheckMate)
  
  reagirl.Label_AutoBackdrop(tab1.label_header3, tab1.checkbox_remember) -- set backdrop drawn by tab1.label_header3
                                                                         -- let it end underneath tab1.checkbox_remember
  
  -- Images
  reagirl.NextLine(10) 
  tab1.label_header4=reagirl.Label_Add(nil, nil, "Or Images", "Set the settings, as you wish.", false, nil)

  -- local some images from Reaper
  reagirl.NextLine()
  tab1.image1 = reagirl.Image_Add(nil, nil, 50, 50, reaper.GetResourcePath().."/Data/track_icons/idea.png", "An idea-cloud", "An image of an idea-thought-cloud.", nil)
  reagirl.Image_SetDropShadow(tab1.image1, true)
  tab1.image2 = reagirl.Image_Add(nil, nil, 50, 50, reaper.GetResourcePath().."/Data/track_icons/envelope.png", "An envelope", "An image of an envelope.", nil)
  reagirl.Image_SetDropShadow(tab1.image2, true)
  tab1.image3 = reagirl.Image_Add(nil, nil, 50, 50, reaper.GetResourcePath().."/Data/track_icons/ff.png", "ff notation symbol", "An image of a ff-notation-symbol.", nil)
  reagirl.Image_SetDropShadow(tab1.image3, true)
  tab1.image4 = reagirl.Image_Add(nil, nil, 50, 50, reaper.GetResourcePath().."/Data/track_icons/folder_up.png", "A folder up", "An image of a folder with an arrow pointing up.", nil)
  reagirl.Image_SetDropShadow(tab1.image4, true)
  tab1.image5 = reagirl.Image_Add(nil, nil, 50, 50, reaper.GetResourcePath().."/Data/track_icons/bass_clef.png", "A bass clef", "An image of a bass clef.", nil)
  reagirl.Image_SetDropShadow(tab1.image5, true)
  
  reagirl.Label_AutoBackdrop(tab1.label_header4, tab1.image5) -- set backdrop drawn by tab1.label_header4
                                                              -- let it end underneath tab1.image5
  
  
  -- Sliders and DropDownMenus
  reagirl.NextLine(10)
  tab1.label_header5=reagirl.Label_Add(nil, nil, "Sliders and DropDownMenus", "Some sliders and drop down menus.", false, nil)
  
  reagirl.NextLine()
  tab1.slider_test = reagirl.Slider_Add(nil, nil, 284, "Length in", 100, "Set the length in seconds.", "seconds", 1, 30, 0.1, 10, 1, nil)
  
  reagirl.NextLine()
  tab1.options=reagirl.DropDownMenu_Add(nil, nil, 284, "Options:", 100, "Choose one of the options that set your settings.", {"Menu1", "Menu2", "Menu3"}, 1, nil)

  reagirl.NextLine()
  tab1.more_options=reagirl.DropDownMenu_Add(nil, nil, 284, "More Options:", 100, "Choose additional settings in the options.", {"Option1", "Option2", "Option3"}, 2, nil)
  
  reagirl.Label_AutoBackdrop(tab1.label_header5, tab1.more_options) -- set backdrop drawn by tab1.label_header5
                                                                    -- let it end underneath tab1.more_options
                                                                    -- let it end underneath tab1.more_options

  --Meters:
  reagirl.AutoPosition_SetNextUIElementRelativeTo(tabs)
  
  tab2.label_meters2 = reagirl.Label_Add(nil, nil, "Meters for main track and track 1", "Some examples for track meters.", false, nil)
  reagirl.NextLine()
  tab2.meters1_id = reagirl.Meter_Add(nil, nil, 100, 100, 1, "Main Track", "The Levels for the Main-Track.")
  reagirl.Meter_LinkToTrack(tab2.meters1_id, 0)
  tab2.meters2_id = reagirl.Meter_Add(nil, nil, -50, 100, 2, "Track 1", "The Levels of track 1.")
  reagirl.Meter_LinkToTrack(tab2.meters2_id, 1)
  reagirl.NextLine()
  tab2.label_meters3 = reagirl.Label_Add(nil, nil, "Meters for Hardware Inputs", "An example for hardware-input-meters.", false, nil)
  reagirl.NextLine()
  tab2.meters3_id = reagirl.Meter_Add(nil, nil, -200, 100, 3, "Hardware Input 1", "The Levels for Hardware Input 1.")
  reagirl.Meter_LinkToHWInput(tab2.meters3_id, 1)
  tab2.meters4_id = reagirl.Meter_Add(-190, nil, -50, 100, 3, "Hardware Input 1", "The Levels for Hardware Input 2.")
  reagirl.Meter_LinkToHWInput(tab2.meters4_id, 2)

  -- Buttons
  reagirl.AutoPosition_SetNextUIElementRelativeTo(tab1.more_options)
  reagirl.NextLine()
  button_ok_id = reagirl.Button_Add(-133, nil, 0, 0, "OK", "Apply changes and close dialog.", nil)
  button_cancel_id = reagirl.Button_Add(-95, nil, 0, 0, "Cancel", "Discard changes and close dialog.", nil)


  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "The dialog", "This is a demo dialog with settings for tool xyz.", nil, nil, 0, nil, nil)
  
  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    --AAA=reaper.GetInputActivityLevel(0)
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()

