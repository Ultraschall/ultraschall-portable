dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath().."/UserPlugins/Ultraschall-WebInstaller")
ultraschall.ShowLastErrorMessage()

for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(string.gsub(dirs_array[i], "/UserPlugins/Ultraschall-WebInstaller", ""), 0)
end

i=1

function main()
  for a=0, 100 do
    temp=string.gsub(files_array[i], "/UserPlugins/Ultraschall%-WebInstaller", "")
    if temp:sub(-3,-1)=="dll" then os.rename(temp, temp.."old") end
    ultraschall.MakeCopyOfFile_Binary(files_array[i], temp)
    i=i+1
    print_update(i, temp)
    if i>found_files then break end
  end
  if i<found_files then 
    reaper.defer(main) 
  else
    reaper.Main_OnCommand(40063,0)
    reaper.Main_OnCommand(40004,0)
  end
end

main()
