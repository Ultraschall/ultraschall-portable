dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Installs Hotfixes for Ultraschall

-- let's check first, if there's something to install
if reaper.file_exists(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")==false then
return 
end

-- second, remove the indicator file, which will be there only, if an update-ReaperConfigZip-file has been added
  os.remove(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")

-- third, get all files in ResourcePath/Scripts/Ultraschall_Installfiles
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath().."/Scripts/Ultraschall_Installfiles")

for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(string.gsub(dirs_array[i], "/Scripts/Ultraschall_Installfiles", ""), 0)
end


for i=1, found_files do
  tempfilename=string.gsub(files_array[i], "/Scripts/Ultraschall_Installfiles", "")
  if files_array[i]:sub(-4,-1)==".dll" then    
    os.rename(tempfilename, tempfilename.."old")
  end
  ultraschall.MakeCopyOfFile_Binary(files_array[i], tempfilename)
end


for i=1, found_files do
  os.remove(files_array[i])
end

print2("Hotfix Properly Installed, will restart now.")

reaper.Main_OnCommand(40063,0)
reaper.Main_OnCommand(40004,0)
