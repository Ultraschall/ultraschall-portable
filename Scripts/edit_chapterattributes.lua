dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--reaper.SetExtState("Ultraschall_Chapters", "running", "", false)
if reaper.GetExtState("Ultraschall_Chapters", "running")~="" then return end -- deactivated for now, til NewMarkerInTown works
reaper.SetExtState("Ultraschall_Chapters", "running", "true", false)

-- TODO:
--  Retina-Support missing

-- [[ Some Custom Settings ]]

-- Default Window position and size:
--    X and Y will be used the first time the preferences are opened
--    when closing the prefs, the prefs remember the position of the window for next time
WindowX     = 30 -- x-position
WindowY     = 30 -- y-position
WindowWidth = 440 -- width of the window
WindowHeight= 415 -- height of the window
WindowTitle = "Edit Chapter Attributes"

ToolTipWaitTime=30 -- the waittime-until tooltips are shown when hovering above them; 30~1 second

YDefault=50          -- The Y-position of the first GUI-Element. So if you want to move all of them lower, raise this value
XOffset=103          -- X-offset of the second element in the gui(usually text inputfields), so you can move the inputfields to the right together
                     -- if an explanation-text becomes too long to be drawn
Indentation1=17      -- The indentation of the attributes
Indentation2=15      -- The indentation of the attributes

-- [[ The following functions can be customized by you ]]

function main()
  -- This function manages all the drawing and positioning of the gui-elements.
  -- If you need more gui-elements, simply add them into here.
  -- All Gui-element-functions like DrawText(), InputText(), ManageCheckBox(), ManageButton() have
  -- a description of their parameters included. Just go to the function-definitions and read their comments.
  
  -- Now, let's add the individual UI-elements
  -- Header
--  Y=Y+10 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
--  DrawText(10, Y, "Edit Shownote Attributes", 85, "", 20) 
  
  refresh=NewMarkerInTown()
  
  Y=Y+11 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "General Attributes", 85, "Edit the attributes of a chapter")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Title", 0, "The title of this Chapter")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "title", "Enter title of this shownote", "Chapter Title")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Description", 0, "A description for this chapter.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_description", "Describe this chapter", "Chapter Description")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Tags", 0, "Descriptive Tags for this chapter.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_descriptive_tags", "Descriptive Tags for this chapter", "ChapterDescription-Tags")

  -- Is Chapter Spoiler Alert
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageCheckBox(100+XOffset-1, Y+1,   "chap_spoiler_alert", "Check to signal a spoiler warning for this chapter.")
  DrawText      (Indentation1+Indentation2,   Y, "Spoiler warning", 0, "Check, if this chapter contains spoilers.")

  -- Is Chapter Spoiler Alert
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageCheckBox(100+XOffset-1, Y+1,   "chap_is_advertisement", "Check to signal that this chapter is an ad.")
  DrawText      (Indentation1+Indentation2,   Y, "Chapter is advertisement", 0, "Check, if this chapter is an advertisement.")
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Content notification tags", 0, "Tags for content notification for this chapter")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_content_notification_tags", "A list of comma separated tags that warn of specific content", "Chapter content notification tags")

  Y=Y+25 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "Url attributes", 85, "The url of this chapter")
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Url", 0, "The url of this chapter")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_url", "The url of this chapter", "Chapter url")
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Url description", 0, "A description of the url of this chapter")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_url_description", "A description of the url of this chapter", "Chapter url")
  

  Y=Y+25 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "Chapter image", 85, "The image of this chapter")
  --Y=Y+19 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  --DrawText (Indentation1+Indentation2,  Y, "Path plus filename", 0, "The Filename of this chapter image")
  --InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_image_path", "The path+filename of this chapterimage", "Chapter image path+filename")
  
  Y=Y+23
  DisplayImage(Indentation1+Indentation2,Y,80,80,4,UpdateChapterImage,{},ChapterImageContextMenu,{})
  UpdateChapterImage(4, true)
  
  --Y=Y+119 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (95+Indentation1+Indentation2,  Y, "Description", 0, "A description for this image")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_image_description", "A description of this chapterimage", "Chapter image description")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (95+Indentation1+Indentation2,  Y, "License", 0, "The license for this image")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_image_license", "The license of this chapterimage", "Chapter image license")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (95+Indentation1+Indentation2,  Y, "Origin", 0, "The origin for this image")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_image_origin", "The origin of this chapterimage", "Chapter image origin")
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (95+Indentation1+Indentation2,  Y, "Origin url", 0, "The url of the origin of this image")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "chap_image_url", "The url of the origin of this chapterimage", "Chapter image origin url")
  
  
  
  -- Check Settings and Done-buttons
  --  these are linked to gfx.w(right side of the window) so they are always aligned to the right-side of the window
  Y=Y+29 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageButton(gfx.w-66, Y, "Close", QuitMe)
  
  
  
  -- make some mouse-management, run refresh the window again, until the window is closed, otherwise end script
  -- leave it untouched
  --if gfx.w~=WindowWidth and gfx.h~=WindowHeight then gfx.init("", WindowWidth, WindowHeight) end
  if Key~=-1 then OldCap2=gfx.mouse_cap&1 reaper.defer(RefreshWindow) end
end



-- [[ Custom Button functions ]]
--
-- here are some custom-functions used by the buttons.
-- If you want to add additional buttons, add their accompanying functions in this section

function NewMarkerInTown()
  -- shall be used to have:
  --    1 Dialog open, that refreshes, if the dialog shall open for another marker.
  --    that way, you can use the edit-chapter-action without having thousands of edit-chapter-attributes-windows open
  --    easier that way
  --    can I add left-clicking to the menu for this too?
  -- deactivated for now
--  if lol==nil then return end
  marker_id, guid = ultraschall.GetTemporaryMarker()
  --print_update(marker_id)
  if marker_id==-1 then return end
  
  index2 = ultraschall.GetNormalMarkerIDFromGuid(guid)
  if index2==-1 then
    index2, markertype = ultraschall.GetCustomMarkerIDFromGuid(guid)
    if markertype~="Planned" then return else planned=true end
    index2=index2+1 -- needs to be added, so I don't need to add 1 to all GetSetChapterMarker_Attributes-functions when dealing with planned markers
  end
  
  if planned==nil then 
    retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(index2)
  else
    retval, marker_index, pos, name, shown_number, color, guid = ultraschall.EnumerateCustomMarkers("Planned", index2-1)
  end
  --print_update(index2)
  --print(retval, index2)
  index=index2 
  updatereload=true 
  ultraschall.StoreTemporaryMarker(-1) 
  return true 
end

function UpdateChapterImage(image, dropfile)
  focusstate=gfx.getchar(65536)
  if (focusstate&2==2 and OldWindowFocusState~=2) or updatereload==true then reload = true updatereload=reaper.time_precise() end
  OldWindowFocusState=focusstate&2
  retval, project_path_name = reaper.EnumProjects(-1, "")
  dir = ultraschall.GetPath(project_path_name, separator)
  if reload==true then
    --print_update(reaper.time_precise())
    retval, filename=ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_path", new_filename, planned)
    gfx.loadimg(image, dir.."/"..filename)
    x1,y1=gfx.getimgdim(4)
    reload=false
  end
  
  lastselectedimage=reaper.GetExtState("ultraschall", "Chapter_LastSelectedImage")
  
  if dropfile==true then
    retval, filename = gfx.getdropfile(0)
    gfx.getdropfile(-1)
    retval=retval==1
  else
    retval, filename = reaper.GetUserFileNameForRead(lastselectedimage, "Select new file", "*.jpg;*.png;*.jpeg")
  end
  if retval==true then
    gfx.loadimg(image, filename)
    x1,y1=gfx.getimgdim(4)
    if x1~=y1 then
      reaper.MB("The Image is not in rectangular format.\nYou can continue, but this might lead to warped images in podcast clients!", "Image Format Warning!", 0)
    end
    retval, project_path_name = reaper.EnumProjects(-1, "")
    dir = ultraschall.GetPath(project_path_name, separator)
    filename=string.gsub(filename, "\\", "/")
    if ultraschall.CheckForValidFileFormats(filename)=="JPG" or ultraschall.CheckForValidFileFormats(filename)=="PNG" then
      -- load image and create chapter-images-folder, if not yet existing
      file=ultraschall.ReadFullFile(filename, true)
      if file==nil then print2("Can't read file") return end
      retval=reaper.RecursiveCreateDirectory(dir.."/chapter_images/", 0)
      if retval==1 then reaper.MB("Can't create chapter-image-folder in projectfolder to store image. Is the folder write protected?", "Error", 0) return end
    
      -- copy image-file and store path to it within the project-folder
      new_filename="/chapter_images/"..filename:match(".*/(.*)%....").."-"..reaper.genGuid("")..filename:match(".*(%....)")
      new_filename=string.gsub(new_filename, "\\", "/")
      ultraschall.WriteValueToFile(dir..new_filename, file, true, false)
      A2,A3=ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_path", new_filename, planned)
      --print2(A3)
      reaper.SetExtState("ultraschall", "Chapter_LastSelectedImage", filename, true)
    end
  end
end

function RemoveChapterImage()
  ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_path", "", planned)
  gfx.setimgdim(4,0,0)
end

function OpenImageInStandardApp()
  local retval, project_path_name = reaper.EnumProjects(-1, "")
  local dir = ultraschall.GetPath(project_path_name, separator)
  local retval, image = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_path", "", planned)
  if image~="" then
    local retval = reaper.CF_ShellExecute(dir.."/"..image)
  end
end

function ChapterImageContextMenu()
  gfx.x, gfx.y=gfx.mouse_x, gfx.mouse_y
  selection=gfx.showmenu("Remove Chapter Image|Open in default application")
  if     selection==1 then RemoveChapterImage() 
  elseif selection==2 then OpenImageInStandardApp() end
end

function GetChapterAttributes()
  marker_id, guid = ultraschall.GetTemporaryMarker()
  ultraschall.StoreTemporaryMarker(-1)
  if marker_id==-1 then 
    marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
    retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
  end
  
  index = ultraschall.GetNormalMarkerIDFromGuid(guid)
  if index==-1 then
    index, markertype = ultraschall.GetCustomMarkerIDFromGuid(guid)
    if markertype~="Planned" then return else planned=true end
    index=index+1 -- needs to be added, so I don't need to add 1 to all GetSetChapterMarker_Attributes-functions when dealing with planned markers
  end
  
  if planned==nil then 
    retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(index) 
  else
    retval, marker_index, pos, name, shown_number, color, guid = ultraschall.EnumerateCustomMarkers("Planned", index-1)
  end
  
  if index==-1 then return end
 
  retval, chap_image_path = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_path", "", planned)
  retval, project_path_name = reaper.EnumProjects(-1, "")
  dir = ultraschall.GetPath(project_path_name, separator)
    
  LoadImage(dir.."/"..chap_image_path, 4)
  
  InitWindow()
  RefreshWindow() -- start the magic
end


function QuitMe() 
  -- this function quits the script
  local dockstate, x,y,w,h=gfx.dock(-1,0,0,0,0)
  --reaper.MB(x.." "..y.."\n"..x2.." "..y2, "",0)
  reaper.SetExtState("Ultraschall_Chapters", "Edit_Chapters_x", x, true)
  reaper.SetExtState("Ultraschall_Chapters", "Edit_Chapters_y", y, true)
  reaper.SetExtState("Ultraschall_Chapters", "running", "", false)
  gfx.quit()
end



-- [[ GUI-element-functions ]]

-- here come the GUI-element functions. If you want to add another GUI-element into the preferences, just use one of these
-- functions to do it.
-- For those elements who can store stuff, you can set a section and key, into which the settings will be stored.
-- They are then stored as ExtStates using SetExtState. To retrieve these settings, use GetExtState in your script.
-- As "section" I used "LeaFac_OBS", and as key the name of the setting.
-- Set some of the values and have a look into reaper-extstate.ini to see, how this looks like. You quickly get the idea.
--
-- Important: it will NOT store them, when nothing has been clicked. So you need to have default-values in your
--            script, in case the user hasn't set any settings yet(in that case, GetExtState returns ""
--            The values returned by GetExtState are always strings, so integers and such must be converted
--            using integervalue=tonumber(value)

-- Now, all functions and an explanation, what they do, how and where they store the settings.
-- Also an explanation of the parameters.

function ManageCheckBox(x, y, attributename, tooltip)
  -- This adds a checkbox. If that checkbox is clicked it will store a 1 into the extstate.
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string section - the section, in which it's statechanges shall be stored(for instance LeaFac_OBS)
  --            string key - an explanatory name for the key, in which the value will be stored.
  --            boolean default - if no value is set until now, you can set this to a default in the checkbox to true(checked) or false(unchecked)
  
  --local value=tonumber(reaper.GetExtState(section, key))
  local retval, value = ultraschall.GetSetChapterMarker_Attributes(false, index, attributename, "", planned)
  AAA=value
  if clickstate==true and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+20 and 
    gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if value:lower()=="yes" then
      retval, value = ultraschall.GetSetChapterMarker_Attributes(true, index, attributename, "", planned)
    else
      retval, value = ultraschall.GetSetChapterMarker_Attributes(true, index, attributename, "yes", planned)
    end
  end
  --if default==false then default=0 else default=1 end
  if value==nil then value=tonumber(default)  end
  AAA1=value
  
  gfx.set(0.8)
  gfx.rect(x,y,18,18,0)
  gfx.set(1,1,0)
  if value=="yes" then gfx.rect(x+4, y+4, 10, 10, 1) end
  
  if tooltip~=nil and ShowToolTip==true and ToolTipShown==false and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+gfx.measurestr(text) and
    gfx.mouse_y>=y and gfx.mouse_y<=y+gfx.texth then
    local X,Y=reaper.GetMousePosition()
    reaper.TrackCtl_SetToolTip(tooltip, X+15, Y, true) 
    ToolTipShown=true
  end
end



function DrawText(x, y, text, mode, tooltip, size)
  -- This displays a text and optionally allows showing a tooltip
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string text - the text, that shall be shown
  --            integer mode - refer gfx.mode for this value
  --            string tooltip - when mouse hovers over text, show this as a tooltip
  --            integer size - the font-size of the text; omit it to use the default one
  --                         - remember, that fontsize on Mac is not the same on Windows.
  --                         - which means, these must be set for both systems individually.
 if size==nil then 
  size=16
  if not string.match( reaper.GetOS(), "Win") then
     size = math.floor(size * 0.8)
   end
 end
 if mode==nil then mode=0 end
  gfx.set(0.8)
  gfx.x=x
  gfx.y=y+1
  gfx.setfont(1, "Arial", size, mode)
  gfx.drawstr(text)
  gfx.setfont(1, "Arial", size, 0)
  
  if tooltip~=nil and ShowToolTip==true and ToolTipShown==false and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+gfx.measurestr(text) and
    gfx.mouse_y>=y and gfx.mouse_y<=y+gfx.texth then
    ALLAAAA=os.date()
    local X,Y=reaper.GetMousePosition()
    reaper.TrackCtl_SetToolTip(tooltip, X+15, Y, true) 
    ToolTipShown=true
  end
  mode=oldmode
end

function IsProjectSaved()
  -- code in this function by XRaym - license GPL v3
  -- check, if project is saved and prompt save-dialog, if not
  
  -- OS BASED SEPARATOR
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then separator = "\\" else separator = "/" end

  retval, project_path_name = reaper.EnumProjects(-1, "")
  if project_path_name ~= "" then
  
    dir = ultraschall.GetPath(project_path_name, separator)
    name = string.sub(project_path_name, string.len(dir) + 1)
    name = string.sub(name, 1, -5)
    name = name:gsub(dir, "")

    project_saved = true
    return project_saved, dir
  else
    display = reaper.ShowMessageBox("You need to save the project to add chapter images.", "Add Chapter Image", 1)
    if display == 1 then
      reaper.Main_OnCommand(40022, 0) -- SAVE AS PROJECT
      return IsProjectSaved()
    else
      return false
    end
  end
end


function DisplayImage(x,y,imgwidth,imgheight,image,left_functioncall,left_functionparams,right_functioncall,right_functionparams)
  -- display newly selected image, scaled and centered

  gfx.dest=-1
  local width, height=gfx.getimgdim(image)
  local size=width
  if width>imgwidth then size=width end
  if height>imgheight and height>size then size=height end
  local scale=imgheight/size
  gfx.rect(x-1,y-1,imgwidth+2,imgheight+2,0)
  gfx.set(0)
  x1, y1=gfx.getimgdim(image)
  if x1~=0 and y1~=0 then
    gfx.rect(x,y,imgwidth,imgheight,1)
  else
    gfx.set(1)
    gfx.x=x+14
    gfx.y=y+10
    gfx.drawstr("no image\nselected")
  end

  local retval = ultraschall.GFX_BlitImageCentered(image, x+math.floor(imgwidth/2), y+math.floor(imgheight/2), scale, 0)
  if gfx.mouse_cap&1==1 and gfx.mouse_x>=x and gfx.mouse_x<=x+imgwidth and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+imgheight
    then
    left_functioncall(image)
  elseif gfx.mouse_cap&2==2 and gfx.mouse_x>=x and gfx.mouse_x<=x+imgwidth and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+imgheight
    then
    right_functioncall(image)
  end
end

function LoadImage(filename, image)
  gfx.loadimg(image, filename)
end


function InputText(x, y, width, attributename, InputTitle, InputText, onlynumbers)
  -- This adds a textbox, which, when clicked, opens an input-dialog, into which one can enter the new value.
  -- This value will then be stored as extstate.
  -- If the text exceeds the size of the inputbox, it will be truncated visually. To show the entire text,
  -- just hover above the inputbox and it will show it via tooltip.
  
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            integer width - the shown width of the text-box; shown text might be t
  --            string attributename - the attributename to set for this shownote-attribute
  --            string InputTitle - this will influence the title of the input-dialog
  --            string InputText - this will influence the text, next to the input-box in the input-dialog
  --            boolean onlynumbers - true, allows only entering numbers; false or nil, any text can be entered

  --local value=--reaper.GetExtState(section, key)
  local retval, value
  if attributename=="title" then
    if planned==nil then 
      retnumber, shown_number, pos, value, guid = ultraschall.EnumerateNormalMarkers(index) 
    else
      retval, marker_index, pos, value, shown_number, color, guid = ultraschall.EnumerateCustomMarkers("Planned", index-1)
    end
  else
    retval, value = ultraschall.GetSetChapterMarker_Attributes(false, index, attributename, "", planned)
  end

  if gfx.mouse_x>=x and gfx.mouse_x<=gfx.w-10 and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if clickstate==true then
      retval, enteredtext = reaper.GetUserInputs(InputTitle, 1, InputText..",separator=\b,extrawidth=1150", value)
      if retval==true then
        if onlynumbers==true and tonumber(enteredtext)==nil then
          reaper.MB("Only numbers can be entered in this field!", "Only numbers", 0)
          enteredtext=value
        else
          
          if attributename=="title" then
            local retval = ultraschall.SetNormalMarker(index, pos, shown_number, enteredtext)
          else
            local retval, value = ultraschall.GetSetChapterMarker_Attributes(true, index, attributename, enteredtext, planned)
          end
        end
        value=enteredtext
      end
    else
      if ShowToolTip==true and ToolTipShown==false then
        local X,Y = reaper.GetMousePosition()
        reaper.TrackCtl_SetToolTip(InputTitle, X+10, Y, true)
        ToolTipShown=true
      end
    end
  end
  gfx.x=x+2
  gfx.y=y+1
  gfx.set(0.17)
  gfx.rect(x-2,y,width,gfx.texth+1,1)
  gfx.set(0.3)
  gfx.rect(x,y+2,width,gfx.texth+1,0)
  gfx.set(0.8)
  gfx.rect(x-1,y+1,width,gfx.texth+1,0)
  gfx.drawstr(value, 0, width+x, y+gfx.texth+1)
end

function ManageButton(x, y, buttontext, functioncall)
  -- This adds a button, which can be clicked on.
  -- As you might want to have additional functionality associated with that button,
  -- you can write a function that does, what you want. Then pass the name of the function
  -- as parameter functioncall and this function will run it, everytime the button was clicked
  
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string buttontext - the text of the button
  --            function functioncall - the name of the function that shall be called. Just as it is, NOT as string!
  local clickoffset=0
  local width=gfx.measurestr(buttontext)+20
  if gfx.mouse_cap&1==1 and gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    clickoffset=2
  end

  gfx.set(0.8)
  
  local h=gfx.texth+4
  local r=2
  -- draw roundrectangle(code taken from Lokasenna's Gui Lib, inspired by mwe's EEL-sample
  gfx.set(0)
  x=x+clickoffset
  y=y+clickoffset
  -- Corners
  gfx.circle(x + r,         y + r    , r, 1, aa)      -- top-left
  gfx.circle(x + width - r, y + r    , r, 1, aa)      -- top-right
  gfx.circle(x + width - r, y + h - r, r, 1, aa)      -- bottom-right
  gfx.circle(x + r,         y + h - r, r, 1, aa)      -- bottom-left
  -- Ends
  gfx.rect(x, y + r, r, h - r * 2)
  gfx.rect(x + width - r, y + r, r + 1, h - r * 2)
  -- Body + sides
  gfx.rect(x + r, y, width - r * 2, h + 1)
  
  gfx.set(0.3)
  x=x+1
  y=y+1
  -- Corners
  gfx.circle(x + r,         y + r    , r, 1, aa)      -- top-left
  gfx.circle(x + width - r, y + r    , r, 1, aa)      -- top-right
  gfx.circle(x + width - r, y + h - r, r, 1, aa)      -- bottom-right
  gfx.circle(x + r,         y + h - r, r, 1, aa)      -- bottom-left
  -- Ends
  gfx.rect(x, y + r, r, h - r * 2)
  gfx.rect(x + width - r, y + r, r + 1, h - r * 2)
  -- Body + sides
  gfx.rect(x + r, y, width - r * 2, h + 1)

  gfx.set(0.3)
  x=x-clickoffset-1
  y=y-clickoffset-1
  
  gfx.x=x+clickoffset*2
  gfx.y=y+clickoffset+2
  gfx.set(0)
  gfx.drawstr(buttontext, 1, width+x+2, y+gfx.texth+4)
  gfx.x=x+clickoffset*2
  gfx.y=y+clickoffset+3
  gfx.set(0.8)
  gfx.drawstr(buttontext, 1, width+x+3, y+gfx.texth+6)

  if gfx.mouse_cap&1==0 and OldCap2==1 and 
     gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20 then
     functioncall()
  end
end  


-- [[ Initialization of the GUI-Window and some management functions]]
-- You can mostly ignore the following functions, as they do some management here and there.
-- So best is to leave them untouched.

-- Initialize window and some global variables; leave them untouched
function InitWindow()
  Valx=tonumber(reaper.GetExtState("Ultraschall_Chapters", "Edit_Chapters_x")) if Valx~=nil then WindowX=Valx end
  Valy=tonumber(reaper.GetExtState("Ultraschall_Chapters", "Edit_Chapters_y")) if Valy~=nil then WindowY=Valy end
  
  
  --gfx.init(WindowTitle, WindowWidth, WindowHeight, 0, WindowX, WindowY)
  retval, hwnd = ultraschall.GFX_Init(WindowTitle, WindowWidth, WindowHeight, 0, WindowX, WindowY)
  --AA,AA2=reaper.JS_Window_SetStyle(hwnd, "CAPTION")
  OldCap=0
  OldCap2=0
  size=16
  if not string.match( reaper.GetOS(), "Win") then
     -- font-size-management on non-Windows-systems, so the font is properly scaled
     size = math.floor(size * 0.8)
  end
  gfx.setfont(1, "Arial", size, 0)
  ToolTipCount=0
end

function GetMouseState()
  -- This does some mouse-stuff checking and the measuring ot the waittime, until tooltips are shown.
  -- Just leave it as it is.
  if OldMouseX==gfx.mouse_x and OldMouseY==gfx.mouse_y then 
    ToolTipCount=ToolTipCount+1
    if ToolTipCount>ToolTipWaitTime then
      ShowToolTip=true
    else
      ShowToolTip=false
      ToolTipShown=false
    end
  else
    ToolTipCount=0
    reaper.TrackCtl_SetToolTip("", 1, 1, true) 
  end
  OldMouseX=gfx.mouse_x
  OldMouseY=gfx.mouse_y

  -- this returns, if the left-mousebutton has been clicked.
  -- this is used in the main-function. Just leave it there and use its returnvalue, where needed.
  if gfx.mouse_cap&1==1 and OldCap==0 then OldCap=1 return true end
  if gfx.mouse_cap&1==0 and OldCap==1 then OldCap=0 end

  return false
end

function RefreshWindow()
  -- In here, I reset the window for further drawing operations, as well as checking, whether the user hit
  -- enter or esc to close the window.
  -- Just leave it as it is.
  Y=YDefault
  gfx.set(0.1725)
  gfx.rect(0, 0, gfx.w, gfx.h)
  gfx.set(0.145)
  gfx.rect(0, 0, gfx.w, 42)
  gfx.x=0
  gfx.y=0
  gfx.blit(1,1,0)
  gfx.x=74
  gfx.y=12
  gfx.blit(2,0.8,0)
  clickstate=GetMouseState() -- get the clickstate, as needed by several functions
  Key=gfx.getchar()
  if Key==-1 or Key==13 or Key==27 then QuitMe() end
  main()
end

OldGetUserInputs=reaper.GetUserInputs

function reaper.GetUserInputs(...)
  local old = ultraschall.GetUSExternalState("modal_pos", "DLG436", "reaper-wndpos.ini")
  local windowposx, windowposy=reaper.GetMousePosition()
  local retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", windowposx.." "..windowposy, "reaper-wndpos.ini")
  local A,B=OldGetUserInputs(table.unpack({...}))
  local retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", old, "reaper-wndpos.ini")
  return A,B
end

--ultraschall.StoreTemporaryMarker(1)--debug line!!
gfx.loadimg(1, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/edit_chapters.png")
gfx.loadimg(2, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/headertxt_edit_chapters.png")


GetChapterAttributes()
