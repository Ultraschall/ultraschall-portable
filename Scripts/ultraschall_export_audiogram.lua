--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

-- Initialize Ultraschall-API
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
length=endTime-startTime
if length==0 then reaper.MB("Please make a time-selection first!", "No time selection", 0) return end

-- Quality presets
local qualities = {
    {label = "Low (Mastodon)", suffix = "-low", vid_kbps = 1024, aud_kbps = 128, fps = 20, mult = 1.0318},
    {label = "Medium (TikTok/Instagram)", suffix = "-med", vid_kbps = 2048, aud_kbps = 192, fps = 30, mult = 0.98},
    {label = "High (Youtube Shorts)", suffix = "-high", vid_kbps = 3500, aud_kbps = 192, fps = 30, mult = 0.97},
    {label = "Super high (Youtube HQ)", suffix = "-super_high", vid_kbps = 5500, aud_kbps = 360, fps = 60, mult = 1.068}
}

-- Calculate MB for each quality
for _, quality in ipairs(qualities) do
    local total_kbps = quality.vid_kbps + quality.aud_kbps
    quality.mb = tostring((((length * total_kbps) / 1024 / 8) * quality.mult) + 0.00001):match("(.*%...)")
end

-- Show menu and get user selection
local xx, yy = reaper.GetMousePosition()
local menu = ""
for i, quality in ipairs(qualities) do
    menu = menu .. quality.label .. " - ca." .. quality.mb .. "MB|"
end
local retval = ultraschall.ShowMenu("Choose quality", menu, xx, yy - 50)
if retval == -1 or retval < 1 or retval > #qualities then return end

-- Set selected quality
local selected_quality = qualities[retval]
local vidkbps = selected_quality.vid_kbps
local audkbps = selected_quality.aud_kbps
local fps_def = selected_quality.fps
local quality = selected_quality.suffix
local width_def = 1024
local height_def = 1024

--if lol==nil then return end

function GetPath(str,sep)
  return str:match("(.*"..sep..")")
end

function ResizeAndBlurPNG(filename_with_path, outputfilename_with_path, aspectratio, width, height, blurradius, blurstepsize, blurdirection)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResizeAndBlurPNG</slug>
  <requires>
    Ultraschall=5.1
    Reaper=7.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ResizeAndBlurPNG(string filename_with_path, string outputfilename_with_path, boolean aspectratio, integer width, integer height, integer blurradius)</functioncall>
  <description>
    resizes a png-file and optionally blurs it. It will stretch/shrink the picture by that. That means you can't crop or enhance pngs with this function.
    
    If you set aspectratio=true, then the image will be resized with correct aspect-ratio. However, it will use the value from parameter width as maximum size for each side of the picture.
    So if the height of the png is bigger than the width, the height will get the size and width will be shrinked accordingly.
    
    When making pngs bigger, pixelation will occur. No pixel-filtering within this function!
    
    The blurring will happen after a resize!
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the png-file, that you want to resize
    string outputfilename_with_path - the output-file, where to store the resized png
    boolean aspectratio - true, keep aspect-ratio(use size of param width as base); false, don't keep aspect-ratio
    integer width - the width of the newly created png in pixels
    integer height - the height of the newly created png in pixels
    integer blurradius - the radius of the blur(1-100); keep in mind that higher values take longer to process and block Reaper!
    integer blurdirection - 0, side plus up; 1, sideways; 2, upwards; 3, upwards, downwards, left and right
  </parameters>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, resize, png, image, graphics, blur</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "filename_with_path", "file can not be opened", -3) return false end
  if type(aspectratio)~="boolean" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "aspectratio", "must be a boolean", -4) return false end
  if width~=nil and math.type(width)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "width", "must be an integer", -5) return false end
  if height==nil or (aspectratio==false and math.type(height)~="integer") then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "height", "must be an integer, when aspectratio==false", -6) return false end
  if math.type(blurradius)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "blurradius", "must be an integer", -7) return false end
  if blurradius<0 or blurradius>10000 then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "blurradius", "must be between 1 and 100", -8) return false end
  if math.type(blurstepsize)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "blurstepsize", "must be an integer", -9) return false end
  if math.type(blurdirection)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurPNG", "blurdirection", "must be an integer", -10) return false end
  if blurstepsize==nil then blurstepsize=1 end

  local Identifier, Identifier2, squaresize, NewWidth, NewHeight, Height, Width, Retval
  Identifier=reaper.JS_LICE_LoadPNG(filename_with_path)
  Width=reaper.JS_LICE_GetWidth(Identifier)
  Height=reaper.JS_LICE_GetHeight(Identifier)
  if aspectratio==true then
    squaresize=width
    if Width>Height then 
      NewWidth=squaresize
      NewHeight=((100/Width)*Height)
      NewHeight=NewHeight/100
      NewHeight=math.floor(squaresize*NewHeight)
    else
      NewHeight=squaresize
      NewWidth=((100/Height)*Width)
      NewWidth=NewWidth/100
      NewWidth=math.floor(squaresize*NewWidth)
    end
  else
    NewHeight=height
    NewWidth=width
  end
  
  local BlurIdentifier3=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
  local alpha1=0.5/((blurradius))
  local alpha=0.5
  local y=0
  local offset=math.floor(blurradius)

  if blurdirection==1 then
    for x=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x-offset, y, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  elseif blurdirection==2 then
    local x=10
    local alpha=0.5
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x, y-offset, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  elseif blurdirection==3 then
    local x=10
    local alpha=0.5
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x, y-offset, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x, -y-offset, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  elseif blurdirection==0 then 
    for i=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, i-offset, i-offset, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  end

  local Retval=reaper.JS_LICE_WritePNG(outputfilename_with_path, BlurIdentifier3, true)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(BlurIdentifier3)
  if Retval==false then ultraschall.AddErrorMessage("ResizePNG", "outputfilename_with_path", "Can't write outputfile", -7) return false end
end

function ResizeAndBlurJPG(filename_with_path, outputfilename_with_path, aspectratio, width, height, blurradius, blurstepsize, blurdirection)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResizeAndBlurJPG</slug>
  <requires>
    Ultraschall=5.1
    Reaper=7.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ResizeAndBlurJPG(string filename_with_path, string outputfilename_with_path, boolean aspectratio, integer width, integer height, integer blurradius)</functioncall>
  <description>
    resizes a jpg-file and optionally blurs it. It will stretch/shrink the picture by that. That means you can't crop or enhance jpgs with this function.
    
    If you set aspectratio=true, then the image will be resized with correct aspect-ratio. However, it will use the value from parameter width as maximum size for each side of the picture.
    So if the height of the jpg is bigger than the width, the height will get the size and width will be shrinked accordingly.
    
    When making jpgs bigger, pixelation will occur. No pixel-filtering within this function!
    
    The blurring will happen after a resize!
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the jpg-file, that you want to resize
    string outputfilename_with_path - the output-file, where to store the resized jpg
    boolean aspectratio - true, keep aspect-ratio(use size of param width as base); false, don't keep aspect-ratio
    integer width - the width of the newly created jpg in pixels
    integer height - the height of the newly created jpg in pixels
    integer blurradius - the radius of the blur(1-100); keep in mind that higher values take longer to process and block Reaper!
    integer blurdirection - 0, side and up; 1, sideways; 2, upwards
  </parameters>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, resize, jpg, image, graphics, blur</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "filename_with_path", "file can not be opened", -3) return false end
  if type(aspectratio)~="boolean" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "aspectratio", "must be a boolean", -4) return false end
  if math.type(width)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "width", "must be an integer", -5) return false end
  if aspectratio==false and math.type(height)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "height", "must be an integer, when aspectratio==false", -6) return false end
  if math.type(blurradius)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "blurradius", "must be an integer", -7) return false end
  if blurradius<0 or blurradius>10000 then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "blurradius", "must be between 1 and 100", -8) return false end
  if math.type(blurstepsize)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "blurstepsize", "must be an integer", -9) return false end
  if math.type(blurdirection)~="integer" then ultraschall.AddErrorMessage("ResizeAndBlurJPG", "blurdirection", "must be an integer", -10) return false end
  if blurstepsize==nil then blurstepsize=1 end
  local Identifier, Identifier2, squaresize, NewWidth, NewHeight, Height, Width, Retval
  Identifier=reaper.JS_LICE_LoadJPG(filename_with_path)
  Width=reaper.JS_LICE_GetWidth(Identifier)
  Height=reaper.JS_LICE_GetHeight(Identifier)
  if aspectratio==true then
    squaresize=width
    if Width>Height then 
      NewWidth=squaresize
      NewHeight=((100/Width)*Height)
      NewHeight=NewHeight/100
      NewHeight=math.floor(squaresize*NewHeight)
    else
      NewHeight=squaresize
      NewWidth=((100/Height)*Width)
      NewWidth=NewWidth/100
      NewWidth=math.floor(squaresize*NewWidth)
    end
  else
    NewHeight=height
    NewWidth=width
  end

  local BlurIdentifier3=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)

  local alpha1=0.5/((blurradius))
  local alpha=0.5
  local y=0
  local offset=math.floor(blurradius)
  
  if blurdirection==1 then
    for x=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x-blurradius, y, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  elseif blurdirection==2 then
    local x=10
    local alpha=0.5
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, x, y-blurradius, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  elseif blurdirection==3 then
    local BlurIdentifier1=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
    local BlurIdentifier2=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
    local x=10
    local alpha=0.5
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier1, 0, y-math.floor(offset/2), NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
    local alpha=0.5
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier2, y-math.floor(offset/2), 0, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
    reaper.JS_LICE_ScaledBlit(BlurIdentifier3, 0, -1000, NewWidth, NewHeight, BlurIdentifier1, 0, 0, NewWidth, NewHeight, 0.5, "ADD")
    reaper.JS_LICE_ScaledBlit(BlurIdentifier3, -30, 0, NewWidth, NewHeight, BlurIdentifier2, 0, 0, NewWidth, NewHeight, 0.5, "ADD")
  elseif blurdirection==0 then 
    for y=0, blurradius, blurstepsize do
      reaper.JS_LICE_ScaledBlit(BlurIdentifier3, y-blurradius, y-blurradius, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, alpha, "BLUR")
      alpha=alpha-alpha1
    end
  end
   reaper.JS_LICE_FillRect(BlurIdentifier3, 0, 0, NewWidth, NewHeight, 0, 0.5, "COPY")
  local Retval=reaper.JS_LICE_WriteJPG(outputfilename_with_path, BlurIdentifier3, 100)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(BlurIdentifier3)
  if Retval==false then ultraschall.AddErrorMessage("ResizePNG", "outputfilename_with_path", "Can't write outputfile", -7) return false end
end

function GetProjectPath()
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
  -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
    separator = "\\"
  else
  -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
    separator = "/"
  end
  retval, project_path_name = reaper.EnumProjects(-1, "")
  
  if project_path_name ~= "" then
    dir = project_path_name:match("(.*"..separator..")")
    name = string.sub(project_path_name, string.len(dir) + 1)
    name = string.sub(name, 1, -5)
    name = name:gsub(dir, "")
  end
  return dir
end

function checkImage()
  -- check image if it exists and if it's the correct filetype
  -- returns true if found, its path+filename and its image-ratio
  local separator
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then separator = "\\" else separator = "/" end
  retval, project_path_name = reaper.EnumProjects(-1, "")
  if project_path_name ~= "" then
    dir = GetPath(project_path_name, separator)
    name = string.sub(project_path_name, string.len(dir) + 1)
    name = string.sub(name, 1, -5)
    name = name:gsub(dir, "")
  end

  -- lookup existing episode image

  img_index = false
  found = false

  if dir then
    endings = {".jpg", ".jpeg", ".png"} -- prefer .png
    for key,value in pairs(endings) do
      img_adress = dir .. "cover" .. value          -- does cover.xyz exist?
      img_test = gfx.loadimg(0, img_adress)
      if img_test ~= -1 then
        img_index = img_test
        img_location = img_adress
      end
    end
  end

  endings = {".jpg", ".jpeg", ".png"} -- prefer .png
  for key,value in pairs(endings) do
    img_adress = string.gsub(project_path_name, ".RPP", value)
    img_test = gfx.loadimg(0, img_adress)
    if img_test ~= -1 then
      img_index = img_test
      img_location = img_adress
    end
  end

  if img_index then     -- there is an image
    found = true
    preview_size = 80      -- preview size in Pixel, always square
    w, h = gfx.getimgdim(img_index)
    if w > h then     -- adjust size to the longer border
      img_ratio = preview_size / w
    else
      img_ratio = preview_size / h
    end
  end

  return found, img_location, img_ratio, w, h
end

function checkTimeSelection()
  -- Get the time selection bounds
  local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  
  -- If there's no time selection, the start and end times will be the same
  if startTime == endTime then
    reaper.ShowMessageBox("Please create a time selection!", "Missing Selection", 0)
    return false
  end
  
  -- If we want to ensure it's within the project bounds, we can check:
  local projectLength = reaper.GetProjectLength(0)  -- 0 denotes the current project

  if startTime < 0 or endTime > projectLength then
    reaper.ShowMessageBox("Time selection is out of project bounds!", "Selection Error", 0)
    return false
  end

  -- If everything's fine
  return true, startTime, endTime
end


function insertImageToTimeline(track, startTime, endTime, cover)
  if not cover or not track or not startTime or not endTime then
      reaper.ShowMessageBox("Missing data to insert the image to timeline.", "Error", 0)
      return
  end

  -- Move edit cursor to the start of the time selection
  reaper.SetEditCurPos(startTime, false, false)

  -- Set the track to be the only selected track
  reaper.SetOnlyTrackSelected(track)

  -- Insert the media (image) at the edit cursor position on the selected track
  local retval = reaper.InsertMedia(cover, 0) -- 0 means "Add the media to the current track"
  
  if retval and retval ~= 0 then
      local itemIndex = reaper.GetTrackNumMediaItems(track) - 1 -- zero-based index
      local mediaItem = reaper.GetTrackMediaItem(track, itemIndex)

      if mediaItem then
          -- Adjust the media item's position and length to match the time selection
          reaper.SetMediaItemInfo_Value(mediaItem, "D_POSITION", startTime)
          reaper.SetMediaItemInfo_Value(mediaItem, "D_LENGTH", endTime - startTime)
          
          -- Enable the "loop source" property for the media item
          reaper.SetMediaItemInfo_Value(mediaItem, "B_LOOPSRC", 1)
          
          -- Optional: refresh the REAPER UI
          reaper.UpdateArrange()
      else
          reaper.ShowMessageBox("Failed to retrieve the inserted image from the track.", "Error", 0)
      end
  else
      reaper.ShowMessageBox("Failed to insert the image into the timeline.", "Error", 0)
  end
end

function InsertForegroundTrack(startTime, endTime, cover, trackname)
  -- inserts the foreground-cover-image track, including all of its fx
  if cover:sub(-4,-1)==".png" then
    ultraschall.ResizePNG(cover, cover.."-audiogram.png", true, width_def, height_def, 100, 1, 1)
    cover=cover.."-audiogram.png"
  else
    ultraschall.ResizeJPG(cover, cover.."-audiogram.jpg", true, width_def, height_def, 100, 1, 1)
    cover=cover.."-audiogram.jpg"
  end
  COVER1=cover
  VideoCode1=[[//Image overlay
//@param1:opacity 'opacity' 1
//@param2:zoom 'zoom' -1.35 -15 15 0
//@param3:xoffs 'X offset' 0 -1 1 0
//@param4:yoffs 'Y offset' 0 -1 1 0
//@param6:filter 'filter' 0 0 1 0.5 1
//@param7:use_srca 'alpha channel' 1 0 1 0.5 1

img1=input_track(0);
img2=0;
use_srca && img2 != img1 ? colorspace='RGBA';
input_info(img1,img1w,img1h) && project_wh_valid===0 ?  ( project_w = img1w; project_h = img1h; );

a = opacity < 0.01 ? 0 : opacity > 0.99 ? 1 : opacity;

img2 != img1 && input_info(img2,sw,sh) ? (
  gfx_blit(img1,0);
  a>0?(
    gfx_a=a;
    gfx_mode = (filter>0.5 ? 256 : 0)|(use_srca?0x10000:0);
    z = 10^(zoom/10);
    dw = (sw*z)|0;
    dh = (sh*z)|0;
    x = (project_w - dw + (project_w + dw)*xoffs)*.5;
    y = (project_h - dh + (project_h + dh)*yoffs)*.5;
    gfx_blit(img2,0, x|0,y|0,dw,dh);
  );
);]]

VideoCode2=[[// Text/timecode overlay
#text=""; // set to string to override
font="Arial";

//@param1:size 'text height' 0.045 0.01 0.2 0.1 0.001
//@param2:ypos 'y position' 0.05 0 1 0.5 0.01
//@param3:xpos 'x position' 0.5 0 1 0.5 0.01
//@param4:border 'bg pad' 0.01 0 1 0.5 0.01
//@param5:fgc 'text bright' 1.0 0 1 0.5 0.01
//@param6:fga 'text alpha' 1.0 0 1 0.5 0.01
//@param7:bgc 'bg bright' 0.03 0 1 0.5 0.01
//@param8:bga 'bg alpha' 0.01 0 1 0.5 0.01
//@param9:bgfit 'fit bg to text' 0 0 1 0.5 1
//@param10:ignoreinput 'ignore input' 0 0 1 0.5 1

//@param12:tc 'show timecode' 0 0 1 0.5 1
//@param13:tcdf 'dropframe timecode' 0 0 1 0.5 1

input = ignoreinput ? -2:0;
project_wh_valid===0 ? input_info(input,project_w,project_h);
gfx_a2=0;
gfx_blit(input,1);
gfx_setfont(size*project_h,font);
tc>0.5 ? (
  t = floor((project_time + project_timeoffs) * framerate + 0.0000001);
  f = ceil(framerate);
  tcdf > 0.5 && f != framerate ? (
    period = floor(framerate * 600);
    ds = floor(framerate * 60);
    ds > 0 ? t += 18 * ((t / period)|0) + ((((t%period)-2)/ds)|0)*2;
  );
  sprintf(#text,"%02d:%02d:%02d:%02d",(t/(f*3600))|0,(t/(f*60))%60,(t/f)%60,t%f);
) : strcmp(#text,"")==0 ? input_get_name(-1,#text);
gfx_str_measure(#text,txtw,txth);
b = (border*txth)|0;
yt = ((project_h - txth - b*2)*ypos)|0;
xp = (xpos * (project_w-txtw))|0;
gfx_set(bgc,bgc,bgc,bga);
bga>0?gfx_fillrect(bgfit?xp-b:0, yt, bgfit?txtw+b*2:project_w, txth+b*2);
gfx_set(0,0,0,1);
gfx_str_draw(#text,xp+1,yt+b+1);
gfx_set(fgc,fgc,fgc,fga);
gfx_str_draw(#text,xp,yt+b);]]

  local numTracks = reaper.CountTracks(0)
  
  -- insert new track and name it after ID3Title
  reaper.InsertTrackAtIndex(0, false)
  newTrack = reaper.GetTrack(0, 0)
  reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", trackname, true)

  master_fx_count=reaper.TrackFX_GetCount(newTrack)
  reaper.TrackFX_AddByName(newTrack, "Video processor", false, -1)
  reaper.TrackFX_SetNamedConfigParm(newTrack, master_fx_count, "VIDEO_CODE", VideoCode1)

  master_fx_count=reaper.TrackFX_GetCount(newTrack)
  reaper.TrackFX_AddByName(newTrack, "Video processor", false, -1)
  reaper.TrackFX_SetNamedConfigParm(newTrack, master_fx_count, "VIDEO_CODE", VideoCode2)
  
  insertImageToTimeline(newTrack, startTime, endTime, cover)
end

function InsertBackgroundTrack(startTime, endTime, cover, trackname)
  -- inserts the background-cover-image track, including all of its fx
  if cover:sub(-4,-1)==".png" then
    ResizeAndBlurPNG(cover, cover.."-audiogram-blurred.png", true, width_def+200, height_def+200, 1000, 1, 1)
    cover=cover.."-audiogram-blurred.png"
  else
    ResizeAndBlurJPG(cover, cover.."-audiogram-blurred.jpg", true, width_def+200, height_def+200, 1000, 1, 1)
    cover=cover.."-audiogram-blurred.jpg"
  end

  COVER2=cover
  VideoCode1=[[// Blur (low quality)
  //@param1:weight_parm 'blur amount' 0 0 .99 0.5 0.001
  //@param2:weight_mod 'Y modifier' 1 .8 1.2 1.0 0.001
  //@param4:want_l 'leftward' 1 0 1 .5 1
  //@param5:want_r 'rightward' 1 0 1 .5 1
  //@param6:want_u 'upward' 1 0 1 .5 1
  //@param7:want_d 'downward' 1 0 1 .5 1
  //@param9:force_rgb 'force RGB' 0 0 1 .5 1
  force_rgb ? colorspace='RGBA';
  
  in=0;
  
  function bd(flag) (
    weight= min(weight_parm*((flag&8) ? weight_mod : 1/weight_mod),1) ^.25;
    weight2 = sqr(weight);
    rowsize = ((flag&8) ? project_h : project_w);
    rowsize -= 1 + (colorspace=='YV12' ? rowsize*.5);
    gfx_evalrect(0,0,project_w,project_h,colorspace=='RGBA' ? "
      (_1 -= 1) < 0 ? ( _1=rowsize; _2=r; _3=g; _4=b; );
      r+=weight*(_2-r); _2=r; g+=weight*(_3-g); _3=g; b+=weight*(_4-b); _4=b;
    " : "
      (_1 -= 1) < 0 ? ( _1=rowsize; _2=y1; _3=y3; _4=u; _5=v; );
      y1+=weight*(_2-y1); _2=(y2+=weight*(y1-y2));
      y3+=weight*(_3-y3); _3=(y4+=weight*(y3-y4));
      _4=(u+=weight2*(_4-u));
      _5=(v+=weight2*(_5-v));
    ",flag);
  );
  
  weight_parm>.00001 && input_info(in,project_w,project_h) ? (
    colorspace!='RGBA' ? colorspace='YV12';
    gfx_blit(in);
    want_l ? bd(4);
    want_d ? bd(8);
    want_u ? bd(4|8);
    want_r ? bd(0);
  );]]

VideoCode2=[[//Image overlay
//@param1:opacity 'opacity' 1
//@param2:zoom 'zoom' 2.4 -15 15 0
//@param3:xoffs 'X offset' 0.0816 -1 1 0
//@param4:yoffs 'Y offset' 0 -1 1 0
//@param6:filter 'filter' 0 0 1 0.5 1
//@param7:use_srca 'alpha channel' 1 0 1 0.5 1

img1=input_track(0);
img2=0;
use_srca && img2 != img1 ? colorspace='RGBA';
input_info(img1,img1w,img1h) && project_wh_valid===0 ?  ( project_w = img1w; project_h = img1h; );

a = opacity < 0.01 ? 0 : opacity > 0.99 ? 1 : opacity;

img2 != img1 && input_info(img2,sw,sh) ? (
  gfx_blit(img1,0);
  a>0?(
    gfx_a=a;
    gfx_mode = (filter>0.5 ? 256 : 0)|(use_srca?0x10000:0);
    z = 10^(zoom/10);
    dw = (sw*z)|0;
    dh = (sh*z)|0;
    x = (project_w - dw + (project_w + dw)*xoffs)*.5;
    y = (project_h - dh + (project_h + dh)*yoffs)*.5;
    gfx_blit(img2,0, x|0,y|0,dw,dh);
  );
);]]

  local numTracks = reaper.CountTracks(0)
  
  -- insert new track and name it after ID3Title
  reaper.InsertTrackAtIndex(0, false)
  newTrack = reaper.GetTrack(0, 0)
  reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", trackname, true)

  --master_fx_count=reaper.TrackFX_GetCount(newTrack)
  --reaper.TrackFX_AddByName(newTrack, "Video processor", false, -1)
  --reaper.TrackFX_SetNamedConfigParm(newTrack, master_fx_count, "VIDEO_CODE", VideoCode1)

  master_fx_count=reaper.TrackFX_GetCount(newTrack)
  reaper.TrackFX_AddByName(newTrack, "Video processor", false, -1)
  reaper.TrackFX_SetNamedConfigParm(newTrack, master_fx_count, "VIDEO_CODE", VideoCode2)
  
  insertImageToTimeline(newTrack, startTime, endTime, cover)
end

function renderAudiogramMac(Audiogram_Title)

  -- 1) RenderTable für die Render Settings erzeugen
  RenderTable = ultraschall.CreateNewRenderTable()

  -- 2) RenderTable anpassen

  -- setzt bounds auf time-selection
  RenderTable["Bounds"] = 2
  RenderTable["Source"] = 0 -- Master mix; 

  -- setz Path und Filename
  RenderTable["RenderFile"] = GetProjectPath()
  RenderTable["RenderPattern"] = Audiogram_Title..quality

  -- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
  -- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
  -- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)

  vid_kbps = vidkbps
  aud_kbps = audkbps
  width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
  if width == 0 then width = 1024 end -- default width
  height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
  if height == 0 then height = 1024 end -- default height
  
  width=width_def
  height=height_def
  fps=fps_def
  aspect_ratio = true
--       VideoCodec = 1 -- VP8
--       AudioCodec = 1 -- Vorbis

  RenderTable["RenderString"] = ultraschall.CreateRenderCFG_MP4MAC_Video(true, vid_kbps, aud_kbps, width, height, fps, aspect_ratio)

  -- 3) Render the File


  count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, true)

  -- print (count)

end

function renderAudiogramPC(Audiogram_Title)

  -- 1) RenderTable für die Render Settings erzeugen
  RenderTable=ultraschall.CreateNewRenderTable()

  -- 2) RenderTable anpassen

  -- setz bounds auf time-selection
  RenderTable["Bounds"]=2

  -- setz Path und Filename
  RenderTable["RenderFile"] = GetProjectPath()
  RenderTable["RenderPattern"] = Audiogram_Title..quality
  -- print (RenderTable["FadeOut_Shape"])

  -- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
  -- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
  -- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)
  vid_kbps=vidkbps
  aud_kbps=audkbps
  width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
  if width==0 then width=1920 end -- default width
  height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
  if height==0 then height=1080 end -- default height
  width=width_def
  height=height_def
  fps=fps_def
  aspect_ratio=true
  VideoCodec=0 -- MP4
  AudioCodec=0 -- AAC
 
  RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WMF (0, 0, vid_kbps, 0, aud_kbps, width, height, fps, aspect_ratio)
  -- RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WMF(vid_kbps, aud_kbps, width, height, 60, aspect_ratio, VideoCodec, AudioCodec)
  --RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WebM_Video(vid_kbps, aud_kbps, width, height, fps, true, 1, 1, "crf=23", "")

  -- 3) Render the File
  
  count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, false)
end

function renderAudiogramLinux(Audiogram_Title)

  -- 1) RenderTable für die Render Settings erzeugen
  RenderTable=ultraschall.CreateNewRenderTable()

  -- 2) RenderTable anpassen

  -- setz bounds auf time-selection
  RenderTable["Bounds"]=2

  -- setz Path und Filename
  RenderTable["RenderFile"] = GetProjectPath()
  RenderTable["RenderPattern"] = Audiogram_Title..quality
  -- print (RenderTable["FadeOut_Shape"])

  -- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
  -- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
  -- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)
  vid_kbps=vidkbps
  aud_kbps=audkbps
  width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
  if width==0 then width=1920 end -- default width
  height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
  if height==0 then height=1080 end -- default height
  
  width=width_def
  height=height_def
  fps=fps_def
  aspect_ratio=true
  VideoCodec=0 -- MP4
  AudioCodec=0 -- 

  
  --RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WebM_Video(vid_kbps, aud_kbps, width, height, fps, true, 1, 1, "crf=23", "")
  RenderTable["RenderString"] = ultraschall.CreateRenderCFG_QTMOVMP4_Video(2, 100, 5, width, height, fps, aspect_ratio, vid_kbps, aud_kpbs, "crf=23", "")

  -- 3) Render the File       
  count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, false)
  
end

function setAudiogramFX()
-- sets the fx-chain in the master-track, needed for the audiogram
  VideoCode1=[[//Ultraschall Audiogram Waveform
//@gmem=jsfx_to_video
//@param 1:mode "mode" 0 0 2 0 1
//@param 2:dotcount "point count" 2390 10 5000 400 10
//@param 3:dotsize "point size" 5 2 40 20 1
//@param 4:gain_db "gain (dB)" -34 -80 12 -12 1
//@param 5:zoom_amt "blitter zoom" -.01 -.5 1 .1 0.01
//@param 6:fadespeed "blitter persist" .81 0 1 .1 0.01
//@param 7:filter "blitter filter" 0 0 1 0 1
//@param 8:fg_r "foreground R" 1 0 1 .5 .02
//@param 9:fg_g "foreground G" 1 0 1 .5 .02
//@param 10:fg_b "foreground B" 1 0 1 .5 .02
//@param 11:bg_r "background R" 0 0 1 .5 .02
//@param 12:bg_g "background G" 0 0 1 .5 .02
//@param 13:bg_b "background B" 0 0 1 .5 .02
//@param 14:cx "center X" .5 0 1 .5 .01
//@param 15:cy "center Y" .89 0 1 .5 .01

last_frame && fadespeed > 0 ? (
  xo = project_w*zoom_amt*.25;
  yo = project_h*zoom_amt*.25;
  gfx_mode=filter>0?0x100:0;
  xo < 0 ? gfx_blit(last_frame,0);
  gfx_blit(last_frame,0,0,0,project_w,project_h,xo,yo,project_w-xo*2,project_h-yo*2);
);
gfx_set(bg_r,bg_g,bg_b,last_frame ? (1-fadespeed) : 1);
gfx_a>.001 ? gfx_fillrect(0,0,project_w,project_h);

bufplaypos = gmem[0];
bufwritecursor = gmem[1];
bufsrate = gmem[2];
bufstart = gmem[3];
bufend = gmem[4];
nch = gmem[5];
gain = 10^(gain_db*(1/20));

dt=max(bufplaypos - project_time,0);
dt*bufsrate < dotcount ? underrun_cnt+=1;
rdpos = bufwritecursor - ((dt*bufsrate - dotcount)|0)*nch;
rdpos < bufstart ? rdpos += bufend-bufstart;

gfx_set(fg_r,fg_g,fg_b,1);

function getpt()
(
  l = gmem[rdpos]; r = gmem[rdpos+1];
  (rdpos += nch)>=bufend ? rdpos=bufstart;
);
i=0;

mode==2 ? (
  loop(dotcount,
    getpt();
    ang = atan2(l,r); dist = sqrt(sqr(l)+sqr(r));
    xp = cx*project_w + ((cos(ang)*dist*gain)*project_h-dotsize)*.5;
    yp = ((cy*2+sin(ang)*dist*gain)*project_h-dotsize)*.5;
    gfx_fillrect(xp,yp, dotsize,dotsize);
  );
) : mode == 1 ? (
  loop(dotcount,
    getpt();
    yp = project_h * (cy - .5 + i / dotcount);
    xp = project_w * (cx + (l+r)*.25*gain);
    gfx_fillrect(xp-dotsize*.5,yp-dotsize*.5, dotsize,dotsize);
    i+=1;
  );

) : (
  loop(dotcount,
    getpt();
    xp = project_w * (cx - 0.5 + i / dotcount);
    yp = project_h * (cy + (l+r)*.25*gain);
    gfx_fillrect(xp-dotsize*.5,yp-r*200-dotsize*.5, dotsize, r*400+dotsize*0.5);
    i+=1;
  );
);

gfx_img_free(last_frame);
last_frame=gfx_img_hold(-1);]]

VideoCode2=[[// Remove Black
// black is removed. use after inverting color
img1=0;
img2=input_track(0);
gfx_blit(img2);
gfx_mode = 1;
gfx_blit(img1,0);]]

  
  reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "video_sample_peeker", false, -1)
  
  master_fx_count=reaper.TrackFX_GetCount(reaper.GetMasterTrack(0))
  reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "Video processor", false, -1)
  reaper.TrackFX_SetNamedConfigParm(reaper.GetMasterTrack(0), master_fx_count, "VIDEO_CODE", VideoCode1)

  master_fx_count=reaper.TrackFX_GetCount(reaper.GetMasterTrack(0))
  reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "Video processor", false, -1)
  reaper.TrackFX_SetNamedConfigParm(reaper.GetMasterTrack(0), master_fx_count, "VIDEO_CODE", VideoCode2)
  

end

-- check, if time-selection is existing
retval, startTime, endTime = checkTimeSelection()

if retval==false then return end

startTime_format=reaper.format_timestr(startTime, "")
startTime_format=startTime_format:match("(.*):").."m"..startTime_format:match(".*:(.*)")
if startTime_format:match("(.*):")~=nil then
  startTime_format=startTime_format:match("(.*):").."h"..startTime_format:match(".*:(.*)")
end
startTime_format=startTime_format:match("(.*)%.").."s"

endTime_format=reaper.format_timestr(endTime, "")
endTime_format=endTime_format:match("(.*):").."m"..endTime_format:match(".*:(.*)")
if endTime_format:match("(.*):")~=nil then
  endTime_format=endTime_format:match("(.*):").."h"..endTime_format:match(".*:(.*)")
end
endTime_format=endTime_format:match("(.*)%.").."s"

if retval==false then return end

-- check, if cover image exists and is a valid format
found, img_location, img_ratio, img_w, img_h = checkImage()
if found==false then reaper.MB("Please add a cover-image", "No cover image found", 0) return end

-- get old project's video-dimensions
oldvidw=reaper.SNM_GetIntConfigVar("projvidw", 1024) 
oldvidh=reaper.SNM_GetIntConfigVar("projvidh", 1024) 

-- set video-dimensions to square of 1024x1024 pixels
reaper.SNM_SetIntConfigVar("projvidw", 1024) 
reaper.SNM_SetIntConfigVar("projvidh", 1024) 

-- set correct track-order for rendering the audiogram
projvidflags=reaper.SNM_GetIntConfigVar("projvidflags", -1)
if projvidflags&256==0 then
  reaper.SNM_SetIntConfigVar("projvidflags", projvidflags+256)
end

-- Start the Undo Block
reaper.Undo_BeginBlock()

trackname="                                    "
default=""
while trackname:len()>35 do
  retval, trackname = reaper.GetUserInputs("Enter a description that is shown at the top of the Audiogram, max 35 characters. Keep empty if not needed.", 1, "Shown text(optional), extrawidth=400", default)
  if retval==false then trackname=" " end
  if trackname=="" then trackname=" " end
  if trackname:len()>35 then reaper.MB("Text can only be up to 35 characters to fit the Audiogram", "Description to long", 0) default=trackname end
end


if trackname~=" " then
  trackname_format=string.gsub(trackname, "[%/%\\]","_").."_-_"
else
  trackname_format=""
end

Audiogram_Title="Audiogram_-_"..trackname_format..startTime_format.."-"..endTime_format

-- setup tracks for cover-images shown in the audiogram
InsertBackgroundTrack(startTime, endTime, img_location, trackname)
InsertForegroundTrack(startTime, endTime, img_location, trackname)
-- setup fx on master-track needed for audiogram
setAudiogramFX()
--if lol==nil then return end
reaper.Main_SaveProjectEx(0, GetProjectPath().."/mespotine.rpp",0)

-- render audiogram
if ultraschall.IsOS_Windows()==true then
  renderAudiogramPC(Audiogram_Title)
elseif ultraschall.IsOS_Mac()==true then
  renderAudiogramMac(Audiogram_Title)
else
  renderAudiogramLinux(Audiogram_Title)
end 

-- reset video-dimensions for this project
reaper.SNM_SetIntConfigVar("projvidw", oldvidw) 
reaper.SNM_SetIntConfigVar("projvidh", oldvidh) 
reaper.SNM_SetIntConfigVar("projvidflags", projvidflags)
reaper.Undo_EndBlock("Added and configured track with episode image", -1)

-- undo everything: an easy way to reset, leaving just the rendered video:
reaper.Main_OnCommand(40029, 0)
os.remove(COVER1)
os.remove(COVER2)
-- as if the user wants to open up the folder, where the audiogram got rendered to
if count>0 then
  -- play render-finished notification sound, if toggled on by the user
  volume=ultraschall.GetUSExternalState("ultraschall_settings_tims_chapter_ping_volume", "Value", "ultraschall-settings.ini")
  play_sound=ultraschall.GetUSExternalState("ultraschall_settings_render_finished_ping", "Value", "ultraschall-settings.ini")
  if play_sound=="1" then
    ultraschall.PreviewMediaFile(reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/Render-Finished-Sound.flac", tonumber(volume), false, 0)
  end
  
  -- ask user, if the project-folder shall be opened
  state=reaper.MB("Do you want to open up the project-folder, that holds the Audiogram?", "Audiogram", 4)
  if state==6 then
      reaper.CF_LocateInExplorer(Filearray[1])
  end
end

