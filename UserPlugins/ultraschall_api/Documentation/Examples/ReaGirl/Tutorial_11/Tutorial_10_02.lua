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

-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the checkbox, that shall display the toggle-state of the loop-action
checkbox_id = reagirl.Checkbox_Add(10, 10, "Loop-State", "Shows the state of the loop-button.\nGets immediately updated when the loop-button is clicked/the loop-action is run.", true, checkbox_run_function)
reagirl.Checkbox_LinkToToggleState(checkbox_id, 0, 1068, true)

-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Dialog Title", "A short explanation of my dialog.", nil, nil, nil, nil, nil)

-- 5. start the gui with the manage-function, whose parameter is set to true
reagirl.Gui_Manage(true)