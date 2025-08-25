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

-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
-- check for required version; alter the version-number if necessary
if reagirl.GetVersion()<1.3 then reaper.MB("Needs ReaGirl v"..(1.3).." to run", "Too old version", 2) return false end

-- 1. add the run-functions for the ui-elements
function run_function(element_id, A, B, C)
  local name = reagirl.UI_Element_GetSetCaption(element_id, false, "")
  reaper.MB(B, name, 0)
end

-- 2. start a new gui
reagirl.Gui_New()

toolbarbutton_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_audio_waveform.png", 2, 1,{"One", "Two"}, 5, "First Toolbar Button", "A first example toolbar button.", run_function, "Toolbarbutton #1")
toolbarbutton2_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_color_item.png", 2, 1,{"Uno", "Dos"}, 5, "Second Toolbar Button", "A second example toolbar button.", run_function, "Toolbarbutton #2")
toolbarbutton3_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_delete.png", 2, 1,{"Eins", "Zwei"}, 5, "Third Toolbar Button", "A third example toolbar button.", run_function, "Toolbarbutton #3")
toolbarbutton4_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_glue.png", 2, 1,{"Primo", "Segundo"}, 5, "Fourth Toolbar Button", "A fourth example toolbar button.", run_function, "Toolbarbutton #4")
toolbarbutton5_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_item_properties.png", 3, 1,{"Un", "Deux", "Trois"}, 2, "Fifth Toolbar Button", "A fifth example toolbar button.", run_function, "Toolbarbutton #5")
toolbarbutton6_guid = reagirl.ToolbarButton_Add(nil, nil, reaper.GetResourcePath().."/Data/toolbar_icons/toolbar_item_properties.png", 4, 1,{"A", "B", "C", "D"}, 3, "Sixth", "A fifth example toolbar button.", run_function, "Toolbarbutton #5")

-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Dialog Title", "A short explanation of my dialog.", nil, nil, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
function main()
  reagirl.Gui_Manage()
  
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()
