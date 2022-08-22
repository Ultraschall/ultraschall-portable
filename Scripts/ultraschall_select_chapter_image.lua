dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- initial window-positioning variables
x,y,r,b=reaper.my_getViewport(0,0,0,0,0,0,0,0,false)
windowwidth=150 -- bitte noch skalieren (scale from dpi)
windowheight=150 -- bitte noch skalieren (scale from dpi)
windowposx=math.floor(r/2)-250 -- bitte noch centern im Screen (myviewport)
windowposy=math.floor(b/2)-windowheight -- bitte noch centern im Screen (myviewport)(wird schwierig, weil, wie breit ist der Dialog?)

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
    return project_saved
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

-- position the GetUserInputs-dialog properly, so it will not hide the image-display-window
old = ultraschall.GetUSExternalState("modal_pos", "DLG436", "reaper-wndpos.ini")
retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", windowposx.." "..windowposy, "reaper-wndpos.ini")

-- Debug!!
--ultraschall.StoreTemporaryMarker(0)

-- now, let's get the correct marker and check, whether its chapter or planned marker
marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)

if marker_id==-1 then 
  marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
  retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
end

index = ultraschall.GetNormalMarkerIDFromGuid(guid)

-- if no normal(chapter) marker, check, if the marker in question is a planned marker
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

-- if there's no normal marker, exit script
if retval==false then return end

-- let's check, if the project is saved, before we continue
if IsProjectSaved()==false then return end


-- display the current stored image, so the user sees, if they want to overwrite it
retval, hwnd = ultraschall.GFX_Init("", windowwidth, windowheight, 0, windowposx-windowwidth-20, windowposy)
gfx.x=0
gfx.y=0
gfx.dest=-1

retval, chap_img_filename = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_path", "", planned)

-- display, if an old image is already existing
if retval==true then
  local oldimage=string.gsub(dir..""..chap_img_filename,"\\", "/")
  A1=gfx.loadimg(1, oldimage)
  gfx.x=0
  gfx.y=0
  gfx.dest=-1
  width, height=gfx.getimgdim(1)
  size=width
  if width>windowwidth then size=width end
  if height>windowheight and height>size then size=height end
  scale=windowheight/size
  retval = ultraschall.GFX_BlitImageCentered(1, math.floor(gfx.w/2), math.floor(gfx.h/2), scale, 0)
end

function Start()
  -- we need to do some defer-stuff to display the images correctly
  reaper.defer(LoadImage)
end

function LoadImage()
  -- select and load the new image
  lastselectedimage=reaper.GetExtState("ultraschall", "Chapter_LastSelectedImage")

  retval, filename = reaper.GetUserFileNameForRead(lastselectedimage, "Select Image", "*.jpg;*.png;*.jpeg")
  if retval==false then return end 
  
  retval, project_path_name = reaper.EnumProjects(-1, "")
  filename=string.gsub(filename, "\\", "/")
  retval=gfx.loadimg(1, filename)
  if retval==-1 then print2("Can't load file") return end
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
    reaper.SetExtState("ultraschall", "Chapter_LastSelectedImage", filename, true)
  end
  
  -- display newly selected image, scaled and centered
  gfx.x=0
  gfx.y=0
  gfx.dest=-1
  width, height=gfx.getimgdim(1)
  size=width
  if width>windowwidth then size=width end
  if height>windowheight and height>size then size=height end
  scale=windowheight/size

  retval = ultraschall.GFX_BlitImageCentered(1, math.floor(gfx.w/2), math.floor(gfx.h/2), scale, 0)
  reaper.defer(EnterMetadata)
end

function EnterMetadata()
  -- Now let's enter the Metadata for this image
  retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_description", "")
  retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_license", "")
  retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_origin", "")
  retval, chap_image_url = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_url", "")
  
  retval, retvals_csv = reaper.GetUserInputs("Image Attributes", 4, "Image Description,License of the Image,Origin of the Image,URL of the Image,separator=\b,extrawidth=240", chap_image_description.."\b"..chap_image_license.."\b"..chap_image_origin.."\b"..chap_image_url)
  count, entries = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

  retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_description", entries[1])
  retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_license", entries[2])
  retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_origin", entries[3])
  retval, chap_image_url = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_url", entries[4])
end


function atexit()
  -- close image window and reset position of the GetUserInputs-dialog to its old one, when script exits
  gfx.quit()
  retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", old, "reaper-wndpos.ini")
end

reaper.atexit(atexit)

Start()
