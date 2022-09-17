--[[
################################################################################
# 
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---       Imagefile  Module       ---
-------------------------------------


function ultraschall.ResizePNG(filename_with_path, outputfilename_with_path, aspectratio, width, height)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResizePNG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ResizePNG(string filename_with_path, string outputfilename_with_path, boolean aspectratio, integer width, integer height)</functioncall>
  <description>
    resizes a png-file. It will stretch/shrink the picture by that. That means you can't crop or enhance pngs with this function.
    
    If you set aspectratio=true, then the image will be resized with correct aspect-ratio. However, it will use the value from parameter width as maximum size for each side of the picture.
    So if the height of the png is bigger than the width, the height will get the size and width will be shrinked accordingly.
    
    When making pngs bigger, pixelation will occur. No pixel-filtering within this function!
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the png-file, that you want to resize
    string outputfilename_with_path - the output-file, where to store the resized png
    boolean aspectratio - true, keep aspect-ratio(use size of param width as base); false, don't keep aspect-ratio
    integer width - the width of the newly created png in pixels
    integer height - the height of the newly created png in pixels
  </parameters>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, resize, png, image, graphics</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ResizePNG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ResizePNG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ResizePNG", "filename_with_path", "file can not be opened", -3) return false end
  if type(aspectratio)~="boolean" then ultraschall.AddErrorMessage("ResizePNG", "aspectratio", "must be a boolean", -4) return false end
  if math.type(width)~="integer" then ultraschall.AddErrorMessage("ResizePNG", "width", "must be an integer", -5) return false end
  if aspectratio==false and math.type(height)~="integer" then ultraschall.AddErrorMessage("ResizePNG", "height", "must be an integer, when aspectratio==false", -6) return false end
  
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
  
  Identifier2=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
  reaper.JS_LICE_ScaledBlit(Identifier2, 0, 0, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, 1, "COPY")
  Retval=reaper.JS_LICE_WritePNG(outputfilename_with_path, Identifier2, true)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(Identifier2)
  if Retval==false then ultraschall.AddErrorMessage("ResizePNG", "outputfilename_with_path", "Can't write outputfile", -7) return false end
end

function ultraschall.CaptureScreenAreaAsPNG(filename_with_path, x, y, w, h)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CaptureScreenAreaAsPNG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CaptureScreenAreaAsPNG(string filename_with_path, integer x, integer y, integer w, integer h)</functioncall>
  <description>
    captures an area of the screen and writes it as png-file.
    
    Note for Mac-users: it doesn't seem to work under certain circumstances, which are still under investigation.
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the filename with path of the png-file to write
    integer x - the x-position of the area to capture
    integer y - the y-position of the area to capture
    integer w - the width of the area to capture
    integer h - the height of the area to capture
  </parameters>
  <retvals>
    boolean retval - true, capturing was successful; false, capturing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, capturing, capture, screen, png, image, graphics</tags>
</US_DocBloc>
]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "y", "must be an integer", -2) return false end
  if math.type(w)~="integer" then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "w", "must be an integer", -3) return false end
  if math.type(h)~="integer" then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "h", "must be an integer", -4) return false end
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "filename_with_path", "must be a string", -5) return false end
  -- written by Edgemeal. Big thanks for that!
  local sourceHDC = reaper.JS_GDI_GetScreenDC()
  local destBmp = reaper.JS_LICE_CreateBitmap(true,w,h)
  local destDC = reaper.JS_LICE_GetDC(destBmp)
  reaper.JS_GDI_Blit(destDC, 0, 0, sourceHDC, x, y, w, h)
  local writeable=reaper.JS_LICE_WritePNG(filename_with_path, destBmp, false)
  reaper.JS_LICE_DestroyBitmap(destBmp)
  reaper.JS_GDI_ReleaseDC(sourceHDC, sourceHDC)
  if writeable==false then ultraschall.AddErrorMessage("CaptureScreenAreaAsPNG", "filename_with_path", "can not write png-file", -6) return false end
  return writeable
end

function ultraschall.CaptureWindowAsPNG(windowTitle, filename_with_path, x, y, w, h, win10)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CaptureWindowAsPNG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CaptureWindowAsPNG(identifier window_or_windowtitle, string filename_with_path, integer x, integer y, integer w, integer h, boolean win10)</functioncall>
  <description>
    captures a window and stores it as png-file.
    
    Note for Windows-users with no Windows 10:
    Keep in mind, that even if you choose a dedicated window, if it's located behind other windows, these might be captured as well.
    
    Note for Mac-users: it doesn't seem to work under certain circumstances, which are still under investigation.
    
    returns false in case of an error 
  </description>
  <parameters>
    identifier window_or_windowtitle - either a hwnd or the exact windowtitle of the window, which you want to capture
    string filename_with_path - the filename with path of the output-file
    integer x - the x-position within the window to capture; nil, to use the left side of the window
    integer y - the y-position within the window to capture; nil, to use the top side of the window
    integer w - the width of the capture-area; nil, to use the width of the window
    integer h - the height of the capture-area; nil, to use the height of the window
    boolean win10 - true, use the workaround for invisible window-borders on windows 10; false, just capture the window
  </parameters>
  <retvals>
    boolean retval - true, capturing was successful; false, capturing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, capturing, capture, window, png, image, graphics</tags>
</US_DocBloc>
]]
  -- written by Edgemeal. Big thanks for that!
  local window
  ultraschall.SuppressErrorMessages(true)
  if ultraschall.IsValidHWND(windowTitle)==true then 
    ultraschall.SuppressErrorMessages(false)
    window=windowTitle
  else
    window = reaper.JS_Window_FindTop(windowTitle, true)
    if ultraschall.IsValidHWND(window)==false then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "windowTitle", "can not find such a window", -1) return 1 end
  end
  
  ultraschall.SuppressErrorMessages(false)

  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "filename_with_path", "must be a string", -2) return 2 end
  if x~=nil and math.type(x)~="integer" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "x", "must be an integer", -3) return 3 end
  if y~=nil and math.type(y)~="integer" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "y", "must be an integer", -4) return 4 end
  if w~=nil and math.type(w)~="integer" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "w", "must be an integer", -5) return 5 end
  if h~=nil and math.type(h)~="integer" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "h", "must be an integer", -6) return 6 end
  if type(win10) ~="boolean" then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "win10", "must be a boolean", -7) return 7 end
  
  local sourceHDC = reaper.JS_GDI_GetWindowDC(window)
  
  local _, Aleft, Atop, Aright, Abottom = reaper.JS_Window_GetRect(window)
  Aright=Aright-Aleft
  Abottom=Abottom-Atop
  if x==nil then x=0 end
  if y==nil then y=0 end
  if w==nil then w=Aright end
  if h==nil then h=Abottom end
  
  if win10 then srcx=7 w=w-14 h=h-7 end -- workaround for invisible Win10 borders.
  local dest_bmp = reaper.JS_LICE_CreateBitmap(true,w,h)
  local destDC = reaper.JS_LICE_GetDC(dest_bmp)
  -- copy source to dest & write PNG
  reaper.JS_GDI_Blit(destDC, 0, 0, sourceHDC, x, y, w, h)
  local writeable = reaper.JS_LICE_WritePNG(filename_with_path, dest_bmp, false)
  -- clean up resources
  reaper.JS_GDI_ReleaseDC(window, sourceHDC)
  reaper.JS_LICE_DestroyBitmap(dest_bmp)
  if writeable==false then ultraschall.AddErrorMessage("CaptureWindowAsPNG", "filename_with_path", "can not write png-file", -8) return 8 end
  return writeable
end

function ultraschall.ResizeJPG(filename_with_path, outputfilename_with_path, aspectratio, width, height, quality)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResizeJPG</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=1.215
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ResizeJPG(string filename_with_path, string outputfilename_with_path, boolean aspectratio, integer width, integer height, integer quality)</functioncall>
  <description>
    resizes a jpg-file. It will stretch/shrink the picture by that. That means you can't crop or enhance jpgs with this function.
    
    If you set aspectratio=true, then the image will be resized with correct aspect-ratio. However, it will use the value from parameter width as maximum size for each side of the picture.
    So if the height of the jpgis bigger than the width, the height will get the size and width will be shrinked accordingly.
    
    When making jpg bigger, pixelation will occur. No pixel-filtering within this function!
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the jpg-file, that you want to resize
    string outputfilename_with_path - the output-file, where to store the resized jpg
    boolean aspectratio - true, keep aspect-ratio(use size of param width as base); false, don't keep aspect-ratio
    integer width - the width of the newly created jpg in pixels
    integer height - the height of the newly created jpg in pixels
    integer quality - the quality of the jpg in percent; 1 to 100
  </parameters>
  <retvals>
    boolean retval - true, resizing was successful; false, resizing was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, resize, jpg, image, graphics</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeJPG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ResizeJPG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ResizeJPG", "filename_with_path", "file can not be opened", -3) return false end
  if type(aspectratio)~="boolean" then ultraschall.AddErrorMessage("ResizeJPG", "aspectratio", "must be a boolean", -4) return false end
  if math.type(width)~="integer" then ultraschall.AddErrorMessage("ResizeJPG", "width", "must be an integer", -5) return false end
  if aspectratio==false and math.type(height)~="integer" then ultraschall.AddErrorMessage("ResizeJPG", "height", "must be an integer, when aspectratio==false", -6) return false end
  if math.type(quality)~="integer" then ultraschall.AddErrorMessage("ResizeJPG", "quality", "must be an integer", -7) return false end
  if quality<1 or quality>100 then ultraschall.AddErrorMessage("ResizeJPG", "quality", "must be between 1 and 100", -8) return false end
  
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
  
  Identifier2=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
  reaper.JS_LICE_ScaledBlit(Identifier2, 0, 0, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, 1, "COPY")
  Retval=reaper.JS_LICE_WriteJPG(outputfilename_with_path, Identifier2, quality)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(Identifier2)
  if Retval==false then ultraschall.AddErrorMessage("ResizeJPG", "outputfilename_with_path", "Can't write outputfile", -9) return false end
end

function ultraschall.ConvertPNG2JPG(filename_with_path, outputfilename_with_path, quality)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertPNG2JPG</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=1.215
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.ConvertPNG2JPG(string filename_with_path, string outputfilename_with_path, integer quality)</functioncall>
  <description>
    Converts a png to a jpg-imagefile.
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the png-file, that you want to convert into jpg
    string outputfilename_with_path - the output-file, where to store the jpg
    integer quality - the quality of the jpg in percent; 1 to 100
  </parameters>
  <retvals>
    boolean retval - true, converting was successful; false, converting was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, convert, png, to jpg, image, graphics</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ConvertPNG2JPG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ConvertPNG2JPG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ConvertPNG2JPG", "filename_with_path", "file can not be opened", -3) return false end
  if math.type(quality)~="integer" then ultraschall.AddErrorMessage("ConvertPNG2JPG", "quality", "must be an integer", -4) return false end
  if quality<1 or quality>100 then ultraschall.AddErrorMessage("ConvertPNG2JPG", "quality", "must be between 1 and 100", -5) return false end
  
  local Identifier, Retval
  Identifier=reaper.JS_LICE_LoadPNG(filename_with_path)
  
  Retval=reaper.JS_LICE_WriteJPG(outputfilename_with_path, Identifier, quality)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(Identifier2)
  if Retval==false then ultraschall.AddErrorMessage("ResizeJPG", "outputfilename_with_path", "Can't write outputfile", -9) return false end
end

function ultraschall.ConvertJPG2PNG(filename_with_path, outputfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertJPG2PNG</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    JS=1.215
    Lua=5.3
  </requires>
  <functioncall>integer count = ultraschall.ConvertJPG2PNG(string filename_with_path, string outputfilename_with_path, integer quality)</functioncall>
  <description>
    Converts a jpg to a png-imagefile.
    
    returns false in case of an error 
  </description>
  <parameters>
    string filename_with_path - the jpg-file, that you want to store as png
    string outputfilename_with_path - the output-file, where to store the png-file
  </parameters>
  <retvals>
    boolean retval - true, converting was successful; false, converting was unsuccessful
  </retvals>
  <chapter_context>
    Image File Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Imagefile_Module.lua</source_document>
  <tags>image file handling, convert, to png, jpg, image, graphics</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ConvertJPG2PNG", "filename_with_path", "must be a string", -1) return false end
  if type(outputfilename_with_path)~="string" then ultraschall.AddErrorMessage("ConvertJPG2PNG", "outputfilename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ConvertJPG2PNG", "filename_with_path", "file can not be opened", -3) return false end
  
  local Identifier, Retval
  Identifier=reaper.JS_LICE_LoadJPG(filename_with_path)
  
  Retval=reaper.JS_LICE_WritePNG(outputfilename_with_path, Identifier, false)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(Identifier2)
  if Retval==false then ultraschall.AddErrorMessage("ConvertJPG2PNG", "outputfilename_with_path", "Can't write outputfile", -4) return false end
end

