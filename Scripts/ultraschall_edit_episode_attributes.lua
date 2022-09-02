dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


-- TODO:
--  Retina-Support missing

-- [[ Some Custom Settings ]]

-- Default Window position and size:
--    X and Y will be used the first time the preferences are opened
--    when closing the prefs, the prefs remember the position of the window for next time
WindowX     = 30 -- x-position
WindowY     = 30 -- y-position
WindowWidth = 477 -- width of the window
WindowHeight= 527 -- height of the window
WindowTitle = "Edit Episode Attributes"

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
  refresh=NewMarkerInTown()
  
  Y=Y+11 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "General Episode Attributes", 85, "Edit the attributes of an episode")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Title", 0, "The title of this episode")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_title", "Enter title of this episode", "Episode Title")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Description", 0, "A description for this episode.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_description", "Description for this episode", "Episode description")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Authors", 0, "The authors of this episode")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_author", "The authors of this episode", "Episode author")
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Tagline", 0, "A tagline for this episode.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_tagline", "A short tagline this episode", "Episode tagline")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Descriptive Tags", 0, "Some tags that describe this episode.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_descriptive_tags", "Descriptive tags for this episode", "Episode descriptive tags")

  Y=Y+25
  DrawText (Indentation1,  Y, "General Podcast Attributes", 85, "Edit the attributes of the podcast")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Title", 0, "The title of the podcast.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "podc_title", "The title of the podcast itself", "Podcast title")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Website", 0, "The website of the podcast.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "podc_website", "The website of the podcast itself", "Podcast website")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "eMail", 0, "A contact-email for the podcast.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "podc_contact_email", "A contact-email of the podcast itself", "Podcast contact email")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Category", 0, "The category of the podcast.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "podc_category", "The category of the podcast itself", "Podcast category")



  Y=Y+25
  DrawText (Indentation1,  Y, "Release Time/Date", 85, "The release time/date for this episode")
  DrawText (gfx.w-94,  Y, "Episode cover", 85, "The cover of this episode")  
  Y=Y+22
  DisplayImage(math.tointeger(gfx.w-164), Y, 152, 152, 4, UpdateImage, {}, ImageContextMenu, {4})
  UpdateImage(4, true)

  Y=Y-2
  DrawText (Indentation1+Indentation2,  Y, "Date(yyyy-mm-dd)", 0, "The episode's relase date")
  InputText(100+XOffset, Y, 80, "epsd_release_date", "The releasedate of this episode", "Episode release date", false)

  Y=Y+20
  DrawText (Indentation1+Indentation2,  Y, "Time(hh:mm:ss)", 0, "The episode's release-time")
  InputText(100+XOffset, Y, 80, "epsd_release_time", "The time of release for this episode", "Episode release time", false)

  Y=Y+20
  DrawText (Indentation1+Indentation2,  Y, "Timezone(UTC)", 0, "The timezone of the release")
  DropDownList(100+XOffset , Y, 80, "epsd_release_timezone", "The timezone of the release of this episode", "Episode release timezone(UTC)", {{"-12:00", "-12:00"},{"-11:00", "-11:00"},{"-10:00", "-10:00"},{"-09:30", "-09:30"},{"-09:00", "-09:00"},{"-08:00", "-08:00"},{"-07:00", "-07:00"},{"-06:00", "-06:00"},{"-05:00", "-05:00"},{"-04:00", "-04:00"},{"-03:30", "-03:30"},{"-03:00", "-03:00"},{"-02:00", "-02:00"},{"-01:00", "-01:00"},{"+00:00", "+00:00"},{"+01:00", "+01:00"},{"+02:00", "+02:00"},{"+03:00", "+03:00"},{"+03:30", "+03:30"},{"+04:00", "+04:00"},{"+04:30", "+04:30"},{"+05:00", "+05:00"},{"+05:30", "+05:30"},{"+05:45", "+05:45"},{"+06:00", "+06:00"},{"+06:30", "+06:30"},{"+07:00", "+07:00"},{"+08:00", "+08:00"},{"+08:30", "+08:30"},{"+08:45", "+08:45"},{"+09:00", "+09:00"},{"+09:30", "+09:30"},{"+10:00", "+10:00"},{"+10:30", "+10:30"},{"+11:00", "+11:00"},{"+12:00", "+12:00"},{"+12:45", "+12:45"},{"+13:00", "+13:00"},{"+14:00", "+14:00"}})

  Y=Y+35 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "Additional Attributes", 85, "Some additional attributes for this episode")

  Y=Y+23
  DrawText (Indentation1+Indentation2,  Y, "Episode number", 0, "The episode number")
  InputText(100+XOffset , Y, 40, "epsd_number", "The number of this episode", "Episode number", true)
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Podcast season", 0, "The season of the podcast the episode is in")
  InputText(100+XOffset, Y, 40, "epsd_season", "The number of the season this episode appears in", "Episode season", true)

  Y=Y+20
  DrawText (Indentation1+Indentation2,  Y, "Episode language", 0, "The episode's language")
  DropDownList(100+XOffset , Y, 60, "epsd_language", "The language of this episode", "Episode language", {{"Spanish", "SPA"},{"German", "GER"},{"English", "ENG"},{"French", "FRA"}})

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText      (Indentation1+Indentation2,   Y, "Explicit content", 0, "Check, if this chapter contains explicit language.")
  ManageCheckBox(100+XOffset, Y+1,   "epsd_explicit", "Check to signal this episode is explicit.")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Content Notification Tags", 0, "Some tags that warn of certain content in this episode.")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "epsd_content_notification_tags", "Tags that warn of certain content for this episode", "Episode descriptive tags")
  
  Y=Y+25
  DrawText (Indentation1,  Y, "Sponsor", 85, "The sponsor for this episode")
  
  Y=Y+20
  DrawText (Indentation1+Indentation2,  Y, "Name", 0, "The sponsor's name")
  InputText(100+XOffset, Y, gfx.w-110-XOffset, "epsd_sponsor", "The name of the sponsor", "Spnsor's name", false)

  Y=Y+20
  DrawText (Indentation1+Indentation2,  Y, "Url", 0, "The sponsor's url")
  InputText(100+XOffset, Y, gfx.w-110-XOffset, "epsd_sponsor_url", "The url of the sponsor", "Spnsor's url", false)
  
  -- Check Settings and Done-buttons
  --  these are linked to gfx.w(right side of the window) so they are always aligned to the right-side of the window
  Y=Y+11 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageButton(gfx.w-66, Y+20, "Close", QuitMe)
  
  
  
  -- make some mouse-management, run refresh the window again, until the window is closed, otherwise end script
  -- leave it untouched
  if Key~=-1 then 
    local Width
    OldCap2=gfx.mouse_cap&1 
    if gfx.w<445 then Width=445 else Width=gfx.w end
    if gfx.h<Y+50 or gfx.h>Y+50 or gfx.w<445 then
      gfx.init("", Width, Y+50)
    end
    reaper.defer(RefreshWindow) 
  end
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

  marker_id, guid = ultraschall.GetTemporaryMarker()
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

  index=index2 
  updatereload=true 
  ultraschall.StoreTemporaryMarker(-1) 
  return true 
end

function UpdateImage(image, dropfile)
  local x1, y1, filename,project_path_name
  local focusstate=gfx.getchar(65536)
  if (focusstate&2==2 and OldWindowFocusState~=2) or updatereload==true then reload = true updatereload=reaper.time_precise() end
  OldWindowFocusState=focusstate&2
  local retval, project_path_name = reaper.EnumProjects(-1, "")
  local dir = ultraschall.GetPath(project_path_name, separator)
  if reload==true then
    retval, filename = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_cover", "", "")
    if reaper.file_exists(dir.."/"..filename)==false then
      if reaper.file_exists(dir.."/cover.png")==true then  retval, filename = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_cover", "", "cover.png") end
      if reaper.file_exists(dir.."/cover.jpg")==true then  retval, filename = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_cover", "", "cover.jpg") end
    end

    if filename~=nil then
      gfx.loadimg(image, dir.."/"..filename)
    end
    x1,y1=gfx.getimgdim(image)
    reload=false
  end
  
  local lastselectedimage=reaper.GetExtState("ultraschall", "Episode_LastSelectedImage")
  
  if dropfile==true then
    retval, filename = gfx.getdropfile(0)
    gfx.getdropfile(-1)
    retval=retval==1
  else
    retval, filename = reaper.GetUserFileNameForRead(lastselectedimage, "Select new file", "*.jpg;*.png;*.jpeg")
  end
  if retval==true then
    gfx.loadimg(image, filename)
    x1,y1=gfx.getimgdim(image)
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
      --retval=reaper.RecursiveCreateDirectory(dir.."/chapter_images/", 0)
      --if retval==1 then reaper.MB("Can't create chapter-image-folder in projectfolder to store image. Is the folder write protected?", "Error", 0) return end
    
      -- copy image-file and store path to it within the project-folder
      new_filename="cover"..filename:sub(-4,-1)
      new_filename=string.gsub(new_filename, "\\", "/")
      ultraschall.WriteValueToFile(dir..new_filename, file, true, false)
      --A2,A3=ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_path", new_filename, planned)
      local retval, image = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_cover", "", new_filename)
      --print2(A3)
      reaper.SetExtState("ultraschall", "Episode_LastSelectedImage", filename, true)
    end
  end
end

function RemoveChapterImage()
  ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_cover", "", "")
  gfx.setimgdim(image,0,0)
end

function OpenImageInStandardApp()
  local retval, project_path_name = reaper.EnumProjects(-1, "")
  local dir = ultraschall.GetPath(project_path_name, separator)
  local retval, image = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_cover", "", "")
  if image~="" then
    local retval = reaper.CF_ShellExecute(dir.."/"..image)
  end
end

function ImageContextMenu(image)
  gfx.x, gfx.y=gfx.mouse_x, gfx.mouse_y
  selection=gfx.showmenu("Remove Episode Image|Open in default application")
  if     selection==1 then RemoveChapterImage() 
  elseif selection==2 then OpenImageInStandardApp(image) end
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

function DropDownList(x, y, width, attributename, ToolTip, Title, list)
  local retval, value = ultraschall.GetSetPodcastEpisode_Attributes(false, attributename, "", "")
  local showvalue=""
  for i=1, #list do 
    if value:lower()==list[i][2]:lower() then
      showvalue=list[i][1]    
    end
  end
  if value==nil then value="" end
  if gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if clickstate==true then
      local menuentry="#"..Title.."|"
      for i=1, #list do
        if value:lower()~=list[i][2]:lower() then
          menuentry=menuentry.."|"..list[i][1]
        else
          menuentry=menuentry.."|!"..list[i][1]
        end
      end
      chosen=gfx.showmenu(menuentry)-1
      if chosen~=-1 then
        ultraschall.GetSetPodcastEpisode_Attributes(true, attributename, "", list[chosen][2])
      end
    else
      if ShowToolTip==true and ToolTipShown==false then
        local X,Y = reaper.GetMousePosition()
        reaper.TrackCtl_SetToolTip(ToolTip, X+10, Y, true)
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
  gfx.drawstr(showvalue, 0, width+x-3, y+gfx.texth+1)
end

function ManageCheckBox(x, y, attributename, tooltip)
  x=x-1
  -- This adds a checkbox. If that checkbox is clicked it will store a 1 into the extstate.
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string section - the section, in which it's statechanges shall be stored(for instance LeaFac_OBS)
  --            string key - an explanatory name for the key, in which the value will be stored.
  --            boolean default - if no value is set until now, you can set this to a default in the checkbox to true(checked) or false(unchecked)
  
  --local value=tonumber(reaper.GetExtState(section, key))
  local retval, value = ultraschall.GetSetPodcastEpisode_Attributes(false, attributename, "", "")
  if clickstate==true and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+20 and 
    gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if value:lower()=="yes" then
      retval, value = ultraschall.GetSetPodcastEpisode_Attributes(true, attributename, "", "")
    else
      retval, value = ultraschall.GetSetPodcastEpisode_Attributes(true, attributename, "", "yes")
    end
  end
  if value==nil then value=tonumber(default)  end
  
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
 local size
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
  local x1, y1=gfx.getimgdim(image)
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
  local retval, value, enteredtext
  if attributename:sub(1,5)=="epsd_" then
    retval, value = ultraschall.GetSetPodcastEpisode_Attributes(false, attributename, "", enteredtext)
  elseif attributename:sub(1,5)=="podc_" then
    retval, value = ultraschall.GetSetPodcast_Attributes(false, attributename, "", enteredtext)
  end
  if gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if clickstate==true then
      
      retval, enteredtext = reaper.GetUserInputs(InputTitle, 1, InputText..",separator=\b,extrawidth=450", value)
      if retval==true then
        if onlynumbers==true and tonumber(enteredtext)==nil then
          reaper.MB("Only numbers can be entered in this field!", "Only numbers", 0)
          enteredtext=value
        else
          if attributename:sub(1,5)=="epsd_" then
            retval, value = ultraschall.GetSetPodcastEpisode_Attributes(true, attributename, "", enteredtext)
            SetEpisodeAttributes()
          elseif attributename:sub(1,5)=="podc_" then
            retval, value = ultraschall.GetSetPodcast_Attributes(true, attributename, "", enteredtext)
            SetEpisodeAttributes()
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
  gfx.drawstr(value, 0, width+x-3, y+gfx.texth+1)

  -- debug line to check, if the boundary box is right...
  -- if attributename=="epsd_number" then gfx.rect(x,y, width, y+20-y, 1) end
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
  local Valx=tonumber(reaper.GetExtState("Ultraschall_Chapters", "Edit_Chapters_x")) if Valx~=nil then WindowX=Valx end
  local Valy=tonumber(reaper.GetExtState("Ultraschall_Chapters", "Edit_Chapters_y")) if Valy~=nil then WindowY=Valy end

  local retval, hwnd = ultraschall.GFX_Init(WindowTitle, WindowWidth, WindowHeight, 0, WindowX, WindowY)

  OldCap=0
  OldCap2=0
  local size=16
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
  gfx.blit(2,0.7,0)
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
gfx.loadimg(1, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/edit_episode.png")
gfx.loadimg(2, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/headertxt_edit_episode.png")


function SetEpisodeAttributes()
  retval, Title = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_title", "", "")
  retval, Description = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_description", "", "")
  retval, Category = ultraschall.GetSetPodcast_Attributes(false, "podc_category", "", "")
  retval, Podcast = ultraschall.GetSetPodcast_Attributes(false, "podc_title", "", "")
  retval, Author = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_author", "", "")
  retval, Year = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_release_date", "", "")
  if Year:len()>4 then Year=Year:sub(1,4) end
  
  retval1, Title = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TIT2|"..Title, true)
  retval2, Podcast = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TALB|"..Podcast, true)
  retval3, Author = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TPE1|"..Author, true)
  retval4, Year = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TYER|"..Year, true)
  retval5, Category = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TCON|"..Category, true)
  retval6, Description = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:COMM|"..Description, true)
end

function GetEpisodeAttributes_US5_and_earlier()
  retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_title", "", "")
  if temp=="" then  
    retval1, Title = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TIT2", false)
    retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_title", "", Title)
  end
  
  retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_description", "", "")
  if temp=="" then  
    retval1, Description = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:COMM", false)
    retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_description", "", Description)
  end

  retval, temp = ultraschall.GetSetPodcast_Attributes(false, "podc_category", "", "")
  if temp=="" then  
    retval1, Category = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TCON", false)
    retval, temp = ultraschall.GetSetPodcast_Attributes(true, "podc_category", "", Category)
  end

  retval, temp = ultraschall.GetSetPodcast_Attributes(false, "podc_title", "", "")
  if temp=="" then  
    retval1, PodcastTitle = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TALB", false)
    retval, temp = ultraschall.GetSetPodcast_Attributes(true, "podc_title", "", PodcastTitle)
  end
  
  retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_author", "", "")
  if temp=="" then  
    retval1, Author = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TPE1", false)
    retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_author", "", Author)
  end

  retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(false, "epsd_release_date", "", "")
  if temp=="" then  
    retval1, Year = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TYER", false)
    retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(true, "epsd_release_date", "", Year.."-mm-dd")
  end
  
  InitWindow()
  RefreshWindow() -- start the magic
end

GetEpisodeAttributes_US5_and_earlier()
