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
-- This script shows an image. You can drag n drop a new image-file onto the image to load it.
-- The image also has a context-menu that allows you to clear the image or load one with a file-requester.

  
  -- add ReaGirl to script
  dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
  
  -- add some run-functions
  function Image_RunFunction(clicked_image_id)
    -- this function is run, when the image is clicked
    
    -- get the filename of the currently loaded image-file
    filename = reagirl.Image_GetImageFilename(clicked_image_id)
  end
  
  function Image_DropZone_RunFunction(element_id, dropped_filenames_table)
    -- this function will be called everytime a file is dropped onto the image
    
    -- load the first file dropped as new image and show it
    reagirl.Image_Load(element_id, dropped_filenames_table[1])
  end
  
  function Image_ContextMenu_RunFunction(element_id, menu_entry_selection)
    -- this function will be called when the user opens up 
    -- the context-menu of the image and makes a choice
    if menu_entry_selection==1 then
      -- if user chose the first menu-entry, clear the image to black
      reagirl.Image_ClearToColor(element_id, 0, 0, 0)
    elseif menu_entry_selection==2 then
      -- if user chose the second menu-entry, allow to load an image using a file requester
      retval, filename = 
              reaper.GetUserFileNameForRead(reaper.GetResourcePath().."/Data/track_icons/", 
                                            "Choose an image to load", 
                                            "*.png;*.jpg")
      if retval==true then
        reagirl.Image_Load(element_id, filename)  
      end
    end
  end
  
  -- create new gui
  reagirl.Gui_New()
  
  -- add the image of a bass guitar to this gui
  image_id = reagirl.Image_Add(10, 10, 100, 100, reaper.GetResourcePath().."/Data/track_icons/bass.png", "An image", "A user selectable image.", Image_RunFunction)
  -- add a dropzone for dropped files for this image
  reagirl.UI_Element_GetSet_DropZoneFunction(image_id, true, Image_DropZone_RunFunction)
  -- add a context-menu to this image
  reagirl.UI_Element_GetSet_ContextMenu(image_id, true, "Clear Image|Select a file", Image_ContextMenu_RunFunction)
  -- keep the aspect ratio of the image properly
  reagirl.Image_KeepAspectRatio(image_id, true)
  
  -- open the new gui
  reagirl.Gui_Open("My Dialog Name", false, "Image Viewer", "This is a demo image viewer.", 120, 120)

  -- make the background grey
  reagirl.Background_GetSetColor(true, 55, 55, 55)

  function main()
    -- a function that runs the gui-manage function in the background, so the gui is updated correctly
    reagirl.Gui_Manage()
    
    -- if the gui-window hasn't been closed, keep the script alive.
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()
