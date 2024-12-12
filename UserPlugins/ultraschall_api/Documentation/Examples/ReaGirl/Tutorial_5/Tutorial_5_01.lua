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
  end

  -- start a new gui
  reagirl.Gui_New()

  -- add the source-image, which we will draggable
  image_source_id = reagirl.Image_Add(20, 100, 100, 100, reaper.GetResourcePath().."/Data/track_icons/bass.png", "Bass-guitar", "An image of a bass guitar.", Image_Runfunction)


  -- open gui
  reagirl.Gui_Open("My Dialog Name", false, "ReaGirl Tutorial", "Tutorial for draggable images.", 665, 310, nil, nil, nil)

  -- manage gui
  function main()
    reagirl.Gui_Manage()
    
    if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
  end

  main()