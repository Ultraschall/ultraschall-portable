-- TODO: 
--  Install the proper template-files for the current system
--  Check on Mac and Linux. Especially font-sizes and such.

ultraschall={}
dofile(reaper.GetResourcePath().."/Scripts/Ultraschall_Installer/UserPlugins/ultraschall_api/ultraschall_functions_engine.lua")
--dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

left, top, right, bottom = reaper.my_getViewport(0,0,0,0,0,0,0,0,false)

gfx.init("Installing Ultraschall", 600,200,0,right/4, bottom/3)
A=gfx.loadimg(2, reaper.GetResourcePath().."/Scripts/Ultraschall_Installer/Scripts/us.png")

yoffset=60

function drawfield(text)
  if text==nil then text="" end
  gfx.setfont(1, "Arial", 15, 0)
  gfx.set(0.1725490196078431)
  gfx.rect(0,0,gfx.w,gfx.h)
  gfx.set(0.7019607843137255)
  width, height = gfx.measurestr("Installing Ultraschall")
  gfx.x=20
  gfx.y=110
  gfx.drawstr("Installing Ultraschall: "..text)
  width, height = gfx.getimgdim(2)
  gfx.x=((gfx.w/2)-width/3)+8
  gfx.y=20
  gfx.blit(2,0.6,0)
end

Installerscript=""

--PathToReaper="c:/Program Files/REAPER (x64)"
InstallPath=reaper.GetResourcePath().."/Scripts/Ultraschall_Installer/"
--InstallPath=reaper.GetResourcePath()
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(InstallPath)
i=0

function restart()
  --Restart Reaper
  reaper.Main_OnCommand(40063,0)
  reaper.Main_OnCommand(40004,0)
end

function copyfiles()
  -- copy all files in resource-path to install-folder in theme-file-path
  for a=1, 100 do
    i=i+1
    if files_array[i]:sub(-4,-1)==".dll" then 
        os.rename(reaper.GetResourcePath().."/"..files_array[i]:sub(InstallPath:len()+2), reaper.GetResourcePath().."/"..files_array[i]:sub(InstallPath:len()+2).."old") 
    end
    retval=ultraschall.MakeCopyOfFile_Binary(files_array[i], reaper.GetResourcePath().."/"..files_array[i]:sub(InstallPath:len()+2))
    if retval==false then i=i-1 end
    --ultraschall.ShowLastErrorMessage()
    if i==found_files then break end
  end
  
  if i<found_files then 
    drawfield("copying files")
    gfx.x=20
    gfx.y=100+yoffset
    gfx.setfont(1, "Arial", 12, 0)
    gfx.drawstr(files_array[i])
    gfx.x=gfx.w/2-20
    gfx.y=70+yoffset
    gfx.setfont(1, "Arial", 25, 0)
  
    gfx.rect(20,70+yoffset,gfx.w-40,25,0)
    gfx.set(0.2725490196078431)
    gfx.rect(21,71+yoffset,((gfx.w-42)/found_files)*i,21,1)
    gfx.set(0.7019607843137255)
    gfx.drawstr(tostring((100/found_files*i)):match("(.-)%.+").." %")
    
    reaper.defer(copyfiles) 
  else 
    restart() 
  end
end

function createfolders()
  -- create all folders in theme-file-path
  for a=1, 100 do
    i=i+1
    reaper.RecursiveCreateDirectory(reaper.GetResourcePath().."/"..dirs_array[i]:sub(InstallPath:len()+2,-1), 0)
    if i==found_dirs then break end
  end
  
  if i<found_dirs then 
    drawfield("creating folders")
    gfx.x=20
    gfx.y=100+yoffset
    gfx.setfont(1, "Arial", 12, 0)
    gfx.drawstr(dirs_array[math.floor(i)])
    gfx.x=gfx.w/2-20
    gfx.y=70+yoffset
    gfx.setfont(1, "Arial", 25, 0)
  
    gfx.rect(20,70+yoffset,gfx.w-40,25,0)
    gfx.set(0.2725490196078431)
    gfx.rect(21,71+yoffset,((gfx.w-42)/found_dirs)*i,21,1)
    gfx.set(0.7019607843137255)
    gfx.drawstr(tostring((100/found_dirs*i)):match("(.-)%.+").." %")
      
    reaper.defer(createfolders) 
  else 
    i=0 
    reaper.defer(copyfiles) 
  end
end


createfolders()

--[[dofile(reaper.GetResourcePath().."/Scripts/Ultraschall_Installer/UserPlugins/ultraschall_api/ultraschall_functions_engine.lua")

Installerscript=""

--PathToReaper="c:/Program Files/REAPER (x64)"
InstallPath=reaper.GetResourcePath().."/Scripts/Ultraschall_Installer/"
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(InstallPath)


-- create all folders in theme-file-path
for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(reaper.GetResourcePath().."/"..dirs_array[i]:sub(InstallPath:len()+2,-1), 0)
end


-- copy all files in resource-path to install-folder in theme-file-path
for i=1, found_files do
--  reaper.RecursiveCreateDirectory(PathForThemefile.."Scripts/Ultraschall_Installer/"..dirs_array[i]:sub(PathToReaper:len()+2,-1), 0)
    ultraschall.MakeCopyOfFile_Binary(files_array[i], 
      reaper.GetResourcePath().."/"..files_array[i]:sub(InstallPath:len()+2))
end

--Restart Reaper
reaper.Main_OnCommand(40063,0)
reaper.Main_OnCommand(40004,0)--]]
