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

-- Step 0: initialize ReaGirl
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

-- Step 1: write the run-functions
function Button_RunFunction(pressed_button_id)
  -- this function is run, when a button is pressed
  reaper.MB("Button has been pressed", "Pressed", 0)
end

-- Step 2: create new gui
reagirl.Gui_New()

-- Step 3: add the ui-elements to the gui
-- add an ok-button to the gui at x-position 30 and y-position 200 with the run-function Button_RunFunction
-- The meaningOfUI_Element-parameter "Apply changes and close dialog" will be shown as tooltip 
-- and sent to a screen reader for blind people.
button_ok_id = reagirl.Button_Add(30, 200,  -- x and y-position
                                  0, 0,     -- a margin around the caption
                                  "OK",     -- the caption
                                  "Apply changes and close dialog.", -- hint for blind users and tooltip
                                  Button_RunFunction) -- the run-function used by this button

-- Step 4: open the new gui with size 640x250 pixels, titled "The dialog". 
-- In addition to the title, blind people will also get "This is a demo dialog with settings for tool xyz." 
-- sent to their screen readers.
reagirl.Gui_Open("My Dialog Name", -- a name for this gui
                 false, 
                 "The dialog", -- the title of the window
                 "This is a demo dialog with settings for tool xyz.", -- accessibility-hint for blind users
                 640, 250) -- width and height

-- Step 5: Write and run a defer-function, in which you call reagirl.Gui_Manage()
function main()
  -- a function that runs the gui-manage function in the background, so the gui is updated correctly
  reagirl.Gui_Manage()
  
  -- if the gui-window hasn't been closed, keep the script alive.
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end

main()