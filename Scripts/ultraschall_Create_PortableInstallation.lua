dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

majorversion, subversion, bits, operating_system, portable, betaversion = ultraschall.GetReaperAppVersion()

target_dir="c:\\temp\\ultraschall_portable_test"

retval, target_dir = reaper.JS_Dialog_BrowseForFolder("Select target folder. A new folder called Ultraschall_portable will be created there.", reaper.GetExePath())

if retval==1 then target_dir=target_dir.."/Ultraschall_portable"
else
return
end

found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath())
found_dirs2, dirs_array2, found_files2, files_array2 = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetExePath())

-- Resource-folder first

A=reaper.RecursiveCreateDirectory(target_dir, 0)
--if A==0 then print2("Folder already exists") return end

-- create folder structure - Resourcefolder
for i=1, found_dirs do
  temp1=string.gsub(reaper.GetResourcePath(), "\\", "/")
  temp2=string.gsub(dirs_array[i], "\\", "/")
  temp3=target_dir..temp2:sub(temp1:len()+1,-1)
  reaper.RecursiveCreateDirectory(temp3, 0)
end

-- create folder structure - Exefolder, if not portable installation already
if portable==false then
  for i=1, found_dirs2 do
    temp1=string.gsub(reaper.GetExePath(), "\\", "/")
    temp2=string.gsub(dirs_array2[i], "\\", "/")
    temp3=target_dir..temp2:sub(temp1:len()+1,-1)
    reaper.RecursiveCreateDirectory(temp3, 0)
  end
end


function copy_files2()
  o=i
  -- copy files from the exefolder, if not already copy due being a portable installation
  if portable==false then
    for a=1, 150 do
      retval = ultraschall.PrintProgressBar(true, 50, found_files2, i, true, 5, "Copying Exefolder:", 
                                          "File: "..
                                          target_dir..temp3..
                                          "\n -> \n"..
                                          files_array2[i])
      temp1=string.gsub(reaper.GetExePath(), "\\", "/")
      temp2=string.gsub(files_array2[i], "\\", "/")
      temp3=temp2:sub(temp1:len()+1,-1)
      
      retval = ultraschall.MakeCopyOfFile_Binary(files_array2[i], target_dir..temp3)
      i=i+1
      if i>found_files2 then break end
    end
      if i<=found_files2 then reaper.defer(copy_files2) else ultraschall.CloseReaScriptConsole() end
  else
    ultraschall.CloseReaScriptConsole()
    reaper.CF_LocateInExplorer(target_dir)
  end
end

function copy_files()
  -- copy files from the resourcefolder
  for a=1, 150 do
    retval = ultraschall.PrintProgressBar(true, 50, found_files, i, true, 5, "Copying Resourcefolder:", "File: "..target_dir..temp3.."\n -> \n"..files_array[i])
    temp1=string.gsub(reaper.GetResourcePath(), "\\", "/")
    temp2=string.gsub(files_array[i], "\\", "/")
    temp3=temp2:sub(temp1:len()+1,-1)
    
    retval = ultraschall.MakeCopyOfFile_Binary(files_array[i], target_dir..temp3)
    i=i+1
    if i>found_files then break end
  end
    if i<=found_files then 
      reaper.defer(copy_files)
    else
      i=1
      temp3=""
      copy_files2()
    end
end

i=1
copy_files()



