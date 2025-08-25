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

-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes
tabs=reagirl.Tabs_Add(nil, nil, nil, -20, "Tabs", "Some meters.", {"Track-meters", "Hardware Inputs"}, 1, nil)
track_meters={} -- the table for all track-meters in tab 1
hardware_meters={} -- the table for all hardware-input-meters in tab 2
reagirl.Tabs_SetUIElementsForTab(tabs, 1, track_meters) -- associate ui-elements of table "tab1" with tab 1
reagirl.Tabs_SetUIElementsForTab(tabs, 2, hardware_meters) -- associate ui-elements of table "tab1" with tab 1

-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Dialog Title", "A short explanation of my dialog.", nil, 360, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
function main()
reagirl.Gui_Manage()

if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()