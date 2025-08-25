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

-- Shows three labels with context-menu. They are positioned, so you need to scroll to them.

-- add ReaGirl to script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

-- add a run-function for this script
function test()
  reaper.MB("Menu entry selected", "", 0)
end

-- start new gui
reagirl.Gui_New()

-- add ui-elements to gui
label1 = reagirl.Label_Add(10,10,"Test test", "A test label.",false,nil)
reagirl.UI_Element_GetSet_ContextMenu(label1, true, "The first context menu.", test)
label2 = reagirl.Label_Add(1000,10,"Test test 2", "A second test label.",false,nil)
reagirl.UI_Element_GetSet_ContextMenu(label2, true, "The second context menu.", test)
label3 = reagirl.Label_Add(10,1000,"Test test 3", "A third test label.",false,nil)
reagirl.UI_Element_GetSet_ContextMenu(label3, true, "The third context menu.", test)

-- open gui
reagirl.Gui_Open("Test dialog", false, "A test dialog", "Testing how scrolling affects accessibility.", 100, 100)

-- manage gui
function main()
  reagirl.Gui_Manage()
  reaper.defer(main)
end

main()
