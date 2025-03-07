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


-- 1. add the run-functions for the ui-elements
function checkbox_run_function()
end

function inputbox_run_function_enter()
end

function inputbox_run_function_type()
end


-- 2. start a new gui
reagirl.Gui_New()


-- 3. add the ui-elements and set their attributes

-- add the inputbox and background decorative rectangle to the top of the window
-- inputbox
inputbox = reagirl.Inputbox_Add(-220, 6, 200, "InputBox", 50, ".", "Test text", inputbox_run_function_enter, inputbox_run_function_type)
reagirl.UI_Element_GetSetSticky(inputbox, true, false, true) -- set the inputbox at the top to sticky

-- add the inputbox and background decorative rectangle to the bottom of the window
-- inputbox
inputbox2 = reagirl.Inputbox_Add(-220, -35, 200, "InputBox", 50, ".", "More test text", inputbox_run_function_enter, inputbox_run_function_type)
reagirl.UI_Element_GetSetSticky(inputbox2, true, false, true) -- set the inputbox at the bottom to sticky

-- add some checkboxes
checkboxes={}
-- add the first checkbox with a fixed position
checkboxes[1]=reagirl.Checkbox_Add(10, 35, "Checkbox #1", "A demo checkbox.", true, checkbox_run_function)
-- add all the other checkboxes with autopositioning
for i=2, 100 do
	reagirl.NextLine()
	checkboxes[i]=reagirl.Checkbox_Add(10, nil, "Checkbox #"..i, "A demo checkbox.", true, checkbox_run_function)
end

-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Dialog Title", "A short explanation of my dialog.", 235, 225, nil, nil, nil)


-- 5. a main-function that runs the gui-management-function
function main()
	reagirl.Gui_Manage()

	if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end

main()