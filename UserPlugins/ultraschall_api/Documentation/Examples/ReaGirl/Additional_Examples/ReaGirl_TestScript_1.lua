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

-- add ReaGirl
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

-- add run-functions
function InputBox(A,B,C)
  --reaper.ClearConsole()
  --reaper.ShowConsoleMsg(C)
end 

function button(element_id)
  if butt1==element_id then
    reaper.MB("First button pressed", "Button pressed", 0)
  elseif butt2==element_id then
    reaper.MB("Second button pressed", "Button pressed", 0)
  end
end

function Image(element_id, filename, dragged_element_id)
  if dragged_element_id==image_dest then
    reaper.MB("Successfully dragged to image 2", "", 0)
  elseif dragged_element_id==image_middle then
    reaper.MB("Successfully dragged to image 1", "", 0)
  end
end

function label(element_id, dragged_element_id)
  if dragged_element_id==image_dest then
    reaper.MB("Successfully dragged to image 2", "", 0)
  elseif dragged_element_id==image_middle then
    reaper.MB("Successfully dragged to image 1", "", 0)
  elseif dragged_element_id==image_source then
    reaper.MB("Successfully dragged to source-image ", "", 0)
  elseif element_id==label2 then
    reaper.MB("Clickable label clicked", "", 0)
  end
end

-- start new gui
reagirl.Gui_New()

-- add ui-elements
label1=reagirl.Label_Add(nil, nil, "A label with some text", "Labels are there to describe things in the gui.", false, label)
label2=reagirl.Label_Add(nil, nil, "A clickable label", "Clickable linktext.", true, label)
reagirl.UI_Element_GetSet_ContextMenu(label1, true, "A|Context|Menu", button)
reagirl.NextLine()

reagirl.Checkbox_Add(nil, nil, "Checkbox #1", "The first checkbox.", true, nil)
reagirl.Checkbox_Add(nil, nil, "Checkbox #2", "The second checkbox.", true, nil)
reagirl.NextLine()
reagirl.Checkbox_Add(nil, nil, "Checkbox #3", "The third checkbox.", true, nil)

reagirl.NextLine()

reagirl.Slider_Add(nil, nil, -20, "A Slider-ui-element", nil, "A test slider in this gui.", "tests", 1, 200, 0.1, 10, 20, nil)
reagirl.NextLine()
reagirl.DropDownMenu_Add(nil,nil, -20,"Drop Down Menu", 100, "A test Drop Down Menu or Combo Box as it's probably known.", {"First menu entry", "The second menu entry", "A third menu entry"}, 1, nil)
reagirl.NextLine()
reagirl.Inputbox_Add(nil, nil, -20, "An input box:", 100, "Input some text in here.", "", InputBox, InputBox)
reagirl.NextLine()
  image_source=reagirl.Image_Add(50,nil,50,50,reaper.GetResourcePath().."/Data/track_icons/double_bass.png", "The source-image, an image of a double bass.", "Drag this double bass to one of the two images.", Image)
  image_middle=reagirl.Image_Add(160,nil,25,25,reaper.GetResourcePath().."/Data/track_icons/folder_right.png", "The first destination image.", "Image of a folder with an arrow pointing right.",nil)
  image_dest=reagirl.Image_Add(250,nil,50,50,reaper.GetResourcePath().."/Data/track_icons/mic_dynamic_1.png", "The second destination image.", "Image of a microphone.",nil)
  reagirl.Image_SetDraggable(image_source, true, {image_middle, image_dest})

reagirl.Label_SetDraggable(label1, true, {image_source, image_middle, image_dest})
reagirl.NextLine(5)
butt1=reagirl.Button_Add(nil, nil, 0, 0, "Button #1", "The first button.", button)
butt2=reagirl.Button_Add(nil, nil, 0, 0, "Button #2", "The second button.", button)

-- set background
reagirl.Background_GetSetColor(true, 55, 55, 55)

-- open gui
reagirl.Gui_Open("ReaGirl Testdialog #1", false, "ReaGirl Testdialog #1", "a test dialog that features all available ui-elements.", 355, 225, nil, nil, nil)

-- manage gui
function main()
  reagirl.Gui_Manage()

  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()
