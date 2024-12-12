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

  dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

  function Image_Runfunction(element_id, imagepath_plus_filename, drag_destination)
    -- this function will be run when the image is clicked or dragged to a destination
    if drag_destination==label_id then
      -- if source-image is dragged to the label, set labeltext to 
      -- filename of the source-image
      
      -- get the filename of the source-image
      image_filename = reagirl.Image_GetImageFilename(element_id) 
      -- set label-text to filename of source-image
      reagirl.Label_SetLabelText(label_id, "Filename of source-image is: "..image_filename) 
      -- change meaningOfUI_Element to reflect, what the label shows now for blind users
      reagirl.UI_Element_GetSetMeaningOfUIElement(label_id, true, "An image of a bass-guitar")
    
    elseif drag_destination==image_dest1_id then
      -- if source_image is dragged to image2, change it's image to the
      -- one of the source-image
      
      -- get the filename of the source-image
      image_filename = reagirl.Image_GetImageFilename(element_id)
      -- load the filename of the source-image in the destination-image
      reagirl.Image_Load(image_dest1_id, image_filename)
      -- change meaningOfUI_Element to reflect, what the image shows now for blind users
      reagirl.UI_Element_GetSetMeaningOfUIElement(image_dest1_id, true, "An image of a bass-guitar")
      reagirl.UI_Element_GetSetCaption(image_dest1_id, true, "Image of a bass guitar")
    
    elseif drag_destination==image_dest2_id then
      -- if source_image is dragged to image2, change it's image to the
      -- one of the source-image
      
      -- get the filename of the source-image
      image_filename = reagirl.Image_GetImageFilename(element_id)
      -- load the filename of the source-image in the destination-image
      reagirl.Image_Load(image_dest2_id, image_filename)
      -- change meaningOfUI_Element to reflect, what the image shows now for blind users
      reagirl.UI_Element_GetSetMeaningOfUIElement(image_dest2_id, true, "An image of a bass-guitar.")
      reagirl.UI_Element_GetSetCaption(image_dest2_id, true, "Image of a bass guitar")
    end
  end

  -- start a new gui
  reagirl.Gui_New()

  -- add the source-image, which we will draggable
  image_source_id = reagirl.Image_Add(20, 100, 100, 100, reaper.GetResourcePath().."/Data/track_icons/bass.png", "Bass-guitar", "An image of a bass guitar.", Image_Runfunction)

  -- add some additional images and a label, that are the destinations for the dragging
  label_id = reagirl.Label_Add(240, 10, "Nothing has been dragged to this label, yet", "A destination for the source-image to drag to.", false, nil)
  image_dest1_id = reagirl.Image_Add(220, 50, 100, 100, reaper.GetResourcePath().."/Data/track_icons/amp.png", "Amplifier", "An image of an amplifier.", nil)
  image_dest2_id = reagirl.Image_Add(220, 160, 100, 100, reaper.GetResourcePath().."/Data/track_icons/congas.png", "Congas", "An image of congas.", nil)

  -- add the element_ids of image2-4_id as drag-destinations of image1_id
  reagirl.Image_SetDraggable(image_source_id, true, {label_id, image_dest1_id, image_dest2_id})

  -- open gui
  reagirl.Gui_Open("My Dialog Name", false, "ReaGirl Tutorial", "Tutorial for draggable images.", 665, 310, nil, nil, nil)

  -- manage gui
  function main()
    reagirl.Gui_Manage()
    
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end
  main()