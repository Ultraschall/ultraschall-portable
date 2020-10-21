  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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
  --]]
  
  
-- Ultraschall-API demoscript by Meo Mespotine 12.09.2020
--
-- a simple filemanager-demoscript, which showcases background copying and filemanagement in general

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


O=ultraschall.CopyFile_SetBufferSize(10000)

CurrentFolderL=string.gsub(reaper.GetResourcePath(), "\\", "/")
OldFolderL=string.gsub(reaper.GetResourcePath(), "\\", "/")
StartoffsetL=0
CurrentDirL=0
found_stuffL, found_stuff_arrayL, found_stuff_typeL, selected_files = 0, {}, {}, {}

CurrentFolderR=string.gsub("c:\\", "\\", "/")
OldFolderR=string.gsub(reaper.GetResourcePath(), "\\", "/")
StartoffsetR=0
CurrentDirR=0
found_stuffR, found_stuff_arrayR, found_stuff_typeR = 0, {}, {}

Maxfiles=15
current_copyqueue_position=0
Folder="left"

function DrawEmbossedSquare(inverse, x, y, w, h, rbg, gbg, bbg, r, g, b)
  -- draw embossed squares, too lazy to ipmlement inverse-parameter but I don't want to add buttons anyway ;)
  local offsetx=1
  local offsety=1
  
  if r==nil then r=0.8 end
  if g==nil then g=0.8 end
  if b==nil then b=0.8 end

  if rbg==nil then rbg=0.4 end
  if gbg==nil then gbg=0.4 end
  if bbg==nil then bbg=0.4 end
  
  -- background
  gfx.set(rbg,gbg,bbg)
  gfx.rect(x+1,y+1,w,h,1)
  
  -- darker-edges
  gfx.set(0.5*r, 0.5*g, 0.5*b)
  gfx.line(x+offsetx  , y+offsety,   x+w+offsetx, y+offsety  )
  gfx.line(x+w+offsetx, y+offsety,   x+w+offsetx, y+h+offsety)
  gfx.line(x+w+offsetx, y+h+offsety, x+offsetx  , y+h+offsety)
  gfx.line(x+offsetx  , y+h+offsety, x+offsetx  , y+offsety  )

  -- brighter-edges
  gfx.set(r, g, b)
  gfx.line(x,   y,   x+w, y  )
  gfx.line(x+w, y,   x+w, y+h)
  gfx.line(x+w, y+h, x  , y+h)
  gfx.line(x  , y+h, x  , y  )
end

function DrawStr(text, r,g,b, x,y, font, w, h)
  gfx.x=x
  gfx.y=y
  if r~=nil and g~=nil and b~=nil then
    gfx.set(r,g,b)
  end
  gfx.setfont(font)
  if w~=nil and h~=nil then
    gfx.drawstr(text, 0, w, h)
  else
    gfx.drawstr(text)
  end
  gfx.x=x

  gfx.y=gfx.y+gfx.texth
end

function ChangeFolder(update)
  -- changes the folder is one hits enter in the fileboxes. If it's a file, it will start the file with the standard-application
  -- of the os
  if Folder=="left" or update==true then
  -- treatment for left folderbox
    -- new folder
    if update~=true then
      if found_stuff_arrayL[CurrentDirL]==".." then
        local CurrentFolder2=CurrentFolderL:match("(.*)/.*")
        if CurrentFolder2~=nil then CurrentFolderL=CurrentFolder2 end
        CurrentDirL=0
        StartoffsetL=0
      elseif found_stuff_typeL[CurrentDirL]=="dir" then 
        CurrentFolderL=found_stuff_arrayL[CurrentDirL]
        CurrentDirL=0
        StartoffsetL=0
      else
        reaper.CF_ShellExecute(found_stuff_arrayL[CurrentDirL])
      end
    end
    -- load folders and exchange \\ with /
    local found_dirs, dirs_array = ultraschall.GetAllDirectoriesInPath(CurrentFolderL)
    dirs_array[0]=".."
    for i=1, found_dirs do dirs_array[i]=string.gsub(dirs_array[i], "\\", "/") end
    
    -- load files and exchange \\ with /
    local found_files, files_array = ultraschall.GetAllFilenamesInPath(CurrentFolderL)
    for i=1, found_files do files_array[i]=string.gsub(files_array[i], "\\", "/") selected_files[i]=false end
    
    -- put them into array for dirs and folders
    for i=0, found_dirs do found_stuff_arrayL[i], found_stuff_typeL[i] = dirs_array[i], "dir" end
    for i=1, found_files do found_stuff_arrayL[i+found_dirs], found_stuff_typeL[i+found_dirs]  = files_array[i], "file" end
    found_stuffL=found_dirs+found_files
  end
  
  if Folder=="right" or update==true then
  -- treatment for left folderbox
    -- new folder
    if update~=true then
      if found_stuff_arrayR[CurrentDirR]==".." then
        local CurrentFolder2=CurrentFolderR:match("(.*)/.*")
        if CurrentFolder2~=nil then CurrentFolderR=CurrentFolder2 end
        CurrentDirR=0
        StartoffsetR=0
      elseif found_stuff_typeR[CurrentDirR]=="dir" then 
        CurrentFolderR=found_stuff_arrayR[CurrentDirR]
        CurrentDirR=0
        StartoffsetR=0
      end
    end
    -- load folders and exchange \\ with /
    local found_dirs, dirs_array = ultraschall.GetAllDirectoriesInPath(CurrentFolderR)
    dirs_array[0]=".."
    for i=1, found_dirs do dirs_array[i]=string.gsub(dirs_array[i], "\\", "/") end

    -- load files and exchange \\ with /
    local found_files, files_array = ultraschall.GetAllFilenamesInPath(CurrentFolderR)
    for i=1, found_files do files_array[i]=string.gsub(files_array[i], "\\", "/") end
    
    -- put them into array for dirs and folders
    for i=0, found_dirs do found_stuffR, found_stuff_arrayR[i], found_stuff_typeR[i] = i, dirs_array[i], "dir" end
    for i=1, found_files do found_stuffR, found_stuff_arrayR[i+found_dirs], found_stuff_typeR[i+found_dirs]  = i, files_array[i], "file" end
    found_stuffR=found_dirs+found_files
  end
end

function ShowCopyProgress()
  -- Show the status-messages for copying
  local text="-"
  local paused=""
  local count=1
  local number_of_remaining_files, filename, remaining_bytes_to_copy, percentage = ultraschall.CopyFile_GetCurrentlyCopiedFile()
  count=count+1

  -- get the paused state
  if ultraschall.CopyFile_GetPausedState()==true then paused="(copying paused)" end
  if tostring(tonumber(percentage))==nil then percentage=0 end
  if filename~=nil then text=filename.." - "..percentage.."%" end
  
  -- get the remaining files-queue and prepare
  local show=0
  local remaining="Remaining Files in Queue: "..ultraschall.CopyFile_GetRemainingFilesToCopy().."\n"
  local remaining2=""
  for i=1, current_copyqueue_position do
    local filename, already_processed, error_message, error_code = ultraschall.CopyFile_GetCopiedStatus(i)
    if already_processed==false then show=show+1 end
    if already_processed==false and show>0 and show<=5 then
      remaining2=remaining2.."    "..i..": "..filename.." "..tostring(already_processed).." "..error_message.."\n"
    end
  end


  -- draw boxes and display texts
  DrawEmbossedSquare(true, 10, 300+gfx.texth*3, 810, gfx.texth*8+2, 0.2, 0.2, 0.2, r, g, b) -- surrounding box
  DrawEmbossedSquare(true, 10, 300+gfx.texth*2, 810, gfx.texth,     0.2, 0.2, 0.2, r, g, b) -- currently copying box
  DrawStr("Currently copying "..paused..": \n", 0.7,0.7,0.7, 15, 300+gfx.texth*2, 1)        -- text currently copying-header
  DrawStr("    "..text, 0.7,0.7,0.7, 20, 305+gfx.texth*3, 1)                                -- text currently copying filename
  
  DrawEmbossedSquare(true, 10, 294+gfx.texth*5, 810, gfx.texth+3, 0.2, 0.2, 0.2, r, g, b)   -- currently copying file-box
  DrawStr(remaining,  0.7,0.7,0.7, 15, 296+gfx.texth*5, 1)   -- text remaining number of files
  DrawStr(remaining2, 0.7,0.7,0.7, 20, 315+gfx.texth*5, 1)   -- text remaining files
end

function ShowFolders()
-- this function displays the two folder-boxes
  DrawStr("Ultraschall FileManager 0.2 - Meo-Ada Mespotine(MIT license)", 0.7, 0.7, 0.7, 10, 4, 3)
  gfx.setfont(1)

  -- left-folderbox
  
  -- first, let's draw the box display the folders of them
  -- highlight the currently active box(which is the left one in this case)
  offsetx=10
  offsety=50
  if Folder=="left" then 
    DrawEmbossedSquare(true,offsetx,offsety,400,(Maxfiles+2)*gfx.texth+5, 0.2, 0.2, 0.2, 0.7, 0.7, 0.7)
    gfx.set(0.7) 
  else 
    DrawEmbossedSquare(true,offsetx,offsety,400,(Maxfiles+2)*gfx.texth+5, 0.2, 0.2, 0.2, 0.4, 0.4, 0.4)
    gfx.set(0.4) 
  end
  DrawStr("Source: "..CurrentFolderL, nil, nil, nil, offsetx, offsety-15, 1)

  -- show the actual folder/filenames and colorize them accordingly  
  gfx.x=offsetx+10
  gfx.y=offsety
  gfx.set(1,0,0)
  local draw=0

  for i=0+StartoffsetL, found_stuffL do
    if found_stuff_typeL[i]=="dir" then gfx.set(0,0.5,1) else gfx.set(1,1,0) end
    if found_stuff_typeL[i]=="file" and selected_files[i]==true then gfx.set(1, 0, 0.5) end
    if found_stuff_arrayL[i]==".." then showfolderfile=".." else showfolderfile=found_stuff_arrayL[i]:match(".*/(.*)") end

    gfx.drawstr(showfolderfile,0,400, 400)
    gfx.x=10+offsetx
    if CurrentDirL==i then gfx.x=offsetx gfx.drawstr(">") gfx.x=10+offsetx end
    gfx.set(0.3)
    gfx.line(offsetx+2, gfx.y+1, offsetx+398, gfx.y+1)
    gfx.y=gfx.y+gfx.texth
    draw=draw+1
    if i-StartoffsetL>Maxfiles then break end
  end

  -- right-folderbox
  
  -- first, let's draw the box display the folders of them
  -- highlight the currently active box(which is the right one in this case)
  offsetx=420
  offsety=50
  if Folder=="right" then 
    DrawEmbossedSquare(true,offsetx,offsety,400,(Maxfiles+2)*gfx.texth+5, 0.2, 0.2, 0.2, 0.7, 0.7, 0.7)
    gfx.set(0.7) 
  else 
    DrawEmbossedSquare(true,offsetx,offsety,400,(Maxfiles+2)*gfx.texth+5, 0.2, 0.2, 0.2, 0.4, 0.4, 0.4)
    gfx.set(0.4) 
  end
  DrawStr("Target: "..CurrentFolderR, nil, nil, nil, offsetx, offsety-15, 1)

  -- show the actual folder/filenames and colorize them accordingly
  gfx.x=offsetx+10
  gfx.y=offsety
  gfx.set(1,0,0)
  local draw=0
  
  for i=0+StartoffsetR, found_stuffR do
    if found_stuff_typeR[i]=="dir" then gfx.set(0,0.5,1) else gfx.set(1,1,0) end
    if found_stuff_arrayR[i]==".." then showfolderfile=".." else showfolderfile=found_stuff_arrayR[i]:match(".*/(.*)") end
    gfx.drawstr(showfolderfile,0, 800, 400)
    gfx.x=10+offsetx
    if CurrentDirR==i then gfx.x=0+offsetx gfx.drawstr(">") gfx.x=10+offsetx end
    gfx.set(0.3)
    gfx.line(offsetx+2, gfx.y+1, offsetx+398, gfx.y+1)
    gfx.y=gfx.y+gfx.texth
    draw=draw+1
    if i-StartoffsetR>Maxfiles then break end
  end
end

function main()
  -- let's run the stuff
  -- Get the key
  Key=gfx.getchar()
  
  -- Upkey
  if Key==1685026670.0 then 
    if Folder=="left"  and CurrentDirL<found_stuffL then CurrentDirL=CurrentDirL+1     if CurrentDirL>10 then StartoffsetL=StartoffsetL+1 end end
    if Folder=="right" and CurrentDirR<found_stuffR then CurrentDirR=CurrentDirR+1     if CurrentDirR>10 then StartoffsetR=StartoffsetR+1 end end
  end 
  
  -- DownKey
  if Key==30064.0      then 
    if Folder=="left" then
      if StartoffsetL-CurrentDirL<=0 and StartoffsetL>0 then StartoffsetL=StartoffsetL-1 end
      if CurrentDirL>0 then CurrentDirL=CurrentDirL-1 end
    elseif Folder=="right" then
      if StartoffsetR-CurrentDirR<=0 and StartoffsetR>0 then StartoffsetR=StartoffsetR-1 end
      if CurrentDirR>0 then CurrentDirR=CurrentDirR-1 end    
    end
  end
  
  -- Enter folder or start file in default-application
  if Key==13 then ChangeFolder() end 
  -- Backspace for higher folder
  if Key==8 then if Folder=="left" then CurrentDirL=0 else CurrentDirR=0 end ChangeFolder() end
  -- Home
  if Key==1752132965.0 then if Folder=="left" then StartoffsetL=0 CurrentDirL=0 else StartoffsetR=0 CurrentDirR=0 end redraw=true end
  -- F1 for help
  if Key==26161.0 then
    print2([[
    Simple Filemanager by Meo-Ada Mespotine
    
    demonstrates background-copying.
    
    You can select multiple files and copy them in the background, while the 
    filemanager is still useable for other file-selections.
    
    The left filebox is for selecting the sourcefiles, the right one for 
    selecting the targetfolder.
    
    Folders are blue, Files are yellow, selected files are red.
    
    Up/Down   - arrow up and down
    Enter         - enter a directory or start file in standard application
    Backspace - go one folder higher
    Ins/Space  - select a file for copying(only files supported)
    
    F5              - copy file
    F8/Del        - delete file
    Tab            - switch between both folder-boxes
    
    Esc - close window
    ]]) 
    reaper.JS_Window_SetFocus(FMHWND)
  end
  
  -- Space, sets a file as selected in the left filebox
  if Key==32 then
    if found_stuff_typeL[CurrentDirL]=="file" then 
      if selected_files[CurrentDirL]==true then selected_files[CurrentDirL]=false else selected_files[CurrentDirL]=true end
    end 
  end
  -- insert, sets a file as selected and goes one down
  if Key==6909555.0 then 
    if found_stuff_typeL[CurrentDirL]=="file" then 
      if selected_files[CurrentDirL]==true then selected_files[CurrentDirL]=false else selected_files[CurrentDirL]=true end
    end 
    if Folder=="left"  and CurrentDirL<found_stuffL then CurrentDirL=CurrentDirL+1     if CurrentDirL>10 then StartoffsetL=StartoffsetL+1 end end
  end
  -- Esc quits
  if Key==27.0 then gfx.quit() end 
  -- Tab switches fileboxes
  if Key==9.0 and Folder=="left" then Folder="right" elseif Key==9.0 then Folder="left" end
  -- S stops copying
  if Key==115.0 then ultraschall.CopyFile_StopCopying() end
  -- P pauses copying
  if Key==112.0 and ultraschall.CopyFile_GetPausedState()==true then ultraschall.CopyFile_Pause(false) elseif Key==112.0 then ultraschall.CopyFile_Pause(true) end 
  -- Del or F8 to delete files
  if (Key==6579564.0 or Key==26168.0) and Folder=="left" then 
    local retval=reaper.MB("Are you sure, that you want to delete these files?", "Delete", 4)
    if retval==6 then 
      for i=1, found_stuffL do
        if selected_files[i]==true then 
          os.remove(found_stuff_arrayL[i])
        end
      end
      for i=0, found_stuffL do
        selected_files[i]=false
      end
      ChangeFolder(true)
      ShowFolders()
      reaper.JS_Window_SetFocus(FMHWND)
    end
  end
  -- F7 create a new folder in source-folder
  if Key==26167.0 then 
    retval, foldername = reaper.GetUserInputs("Create new folder", 1, "Foldername:, extrawidth=400", CurrentFolderL)
    if retval==true then reaper.RecursiveCreateDirectory(foldername, 0) ChangeFolder(true) ShowFolders() ShowCopyProgress() end
    reaper.JS_Window_SetFocus(FMHWND)
  end
  -- C or F5 to copy the selected files
  if Key==99.0 or Key==26165.0 then 
    copy=true
    folder=CurrentFolderR
    if ultraschall.CopyFile_IsCurrentlyCopying()==false then
      ultraschall.CopyFile_FlushCopiedFiles()
    end
    for i=1, found_stuffL do
      if selected_files[i]==true then
        path, filename=ultraschall.GetPath(found_stuff_arrayL[i])
        current_copyqueue_position = ultraschall.CopyFile_AddFileToQueue(found_stuff_arrayL[i], CurrentFolderR.."/"..filename, false)
        selected_files[i]=false
      end
      ultraschall.CopyFile_StartCopying()
    end
  end
  
  -- Redraw everything if a key is pressed, windows is resized or redraw==true
  if Key>1 or gfx.w~=oldw or gfx.h~=oldh or redraw==true then
    gfx.set(0.07)
    gfx.rect(0,0,gfx.w,gfx.h,1)
    ShowFolders()
    ShowCopyProgress()
    --redraw=false
    DrawEmbossedSquare(false, 10, gfx.h-gfx.texth-6, 810, gfx.texth+3, 0.3, 0.3, 0.3, r, g, b)
    DrawStr("F1 Help             F5 - Copy             F7 - New Folder             F8 - Delete             Enter - Start file/enter folder             Tab - Switch filebox            Esc - Close", 
            0.7, 0.7, 0.7, 21, gfx.h-gfx.texth-5, 1)
  end
  
  if copy==true and ultraschall.CopyFile_IsCurrentlyCopying()==false then ChangeFolder(true) ShowFolders() ShowCopyProgress() copy=false end
  if Key~=-1 then oldw=gfx.w oldh=gfx.h reaper.defer(main) 
  else 
    if ultraschall.CopyFile_IsCurrentlyCopying()==true then
      ultraschall.CopyFile_FlushCopiedFiles()
      reaper.MB("Stopped current copying. Copied files may be incomplete", "Aborted copying", 0)
    end
  end
end

-- do some prep and start the magic
retval, FMHWND=ultraschall.GFX_Init("Simple Filemanager for copyingfiles - F1 for help",830,500)
gfx.setfont(3,"Arial",20,66)
gfx.setfont(2,"Arial",15,0)
gfx.setfont(1,"Arial",15,0)
ChangeFolder(true)
redraw=true
main()

