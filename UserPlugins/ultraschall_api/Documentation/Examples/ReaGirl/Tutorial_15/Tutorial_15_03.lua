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

-- enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

-- set ui-elements
reagirl.Ext_SendEventByID("ReaGirl_Settings", "Tooltip checkbox", 1, "", 0, 0, 0)        -- toggle "show tooltips"-checkbox
reagirl.Ext_SendEventByID("ReaGirl_Settings", "Drag Blink Every Slider", 5, "", 5, 0, 0) -- set "Blink every"-slider of highlight drag destinations to 5
reagirl.Ext_SendEventByID("ReaGirl_Settings", "Test Input Inputbox", 8, "New text", 0, 0, 0) -- set "Test input"-inputbox to "New text"