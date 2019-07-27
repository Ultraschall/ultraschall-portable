dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

Installerscript=""

--PathToReaper="c:/Program Files/REAPER (x64)"
PathToReaper=reaper.GetResourcePath()
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(PathToReaper)

PathForThemefile="c:\\ThemeTest\\"
found_dirs2, dirs_array2, found_files2, files_array2 = ultraschall.GetAllRecursiveFilesAndSubdirectories(PathForThemefile)

O=dirs_array[5]:match("/InstallData")

-- get all dirs and files from the resource-path
for i=found_dirs, 1, -1 do
  if dirs_array[i]:match("/Plugins")~=nil
  or dirs_array[i]:match("/InstallData")~=nil
  then
    table.remove(dirs_array, i)
    found_dirs=found_dirs-1
  end
end

for i=found_files, 1, -1 do
  if files_array[i]:match("/Plugins")~=nil 
  or files_array[i]:match("/InstallData")~=nil   
  then
    table.remove(files_array, i)
    found_files=found_files-1
  end
end

for i=found_files, 1, -1 do
  temp=files_array[i]:sub(PathToReaper:len()+2,-1)
  if temp:match("/")==nil and temp:sub(-4,-1)~=".ini" then
    table.remove(files_array, i)
    found_files=found_files-1
  end
end

-- delete all files in the theme-path
for i=1, found_files2 do
  os.remove(files_array2[i])
end

-- create all folders in theme-file-path
for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(PathForThemefile.."Scripts/Ultraschall_Installer/"..dirs_array[i]:sub(PathToReaper:len()+2,-1), 0)
end

-- copy all files in resource-path to install-folder in theme-file-path
for i=1, found_files do
--  reaper.RecursiveCreateDirectory(PathForThemefile.."Scripts/Ultraschall_Installer/"..dirs_array[i]:sub(PathToReaper:len()+2,-1), 0)
    ultraschall.MakeCopyOfFile_Binary(files_array[i], PathForThemefile.."Scripts/Ultraschall_Installer/"..files_array[i]:sub(PathToReaper:len()+2,-1))
end

-- create index-file of theme-file
reaper_configzip_info="FLAGS reascript "
ultraschall.WriteValueToFile(PathForThemefile.."reaper-configzip-info", reaper_configzip_info)

-- copy installer-script as __startup.lua into theme-file-path
ultraschall.MakeCopyOfFile_Binary(reaper.GetResourcePath().."/Scripts/Ultraschall_Installer_Script.lua", PathForThemefile.."/Scripts/__startup.lua")



Batter=[[
cd ]]..PathForThemefile..[[

del Ultraschall_Theme.ReaperConfigZip
]]..reaper.GetResourcePath()..[[\Scripts/zip.exe Ultraschall_Theme.ReaperConfigZip * -r -D

adel ]]..PathForThemefile..[[batter.bat

pause
]]

ultraschall.WriteValueToFile(PathForThemefile.."/batter.bat", Batter)
os.execute(PathForThemefile.."/batter.bat")

ultraschall.ShowLastErrorMessage()
