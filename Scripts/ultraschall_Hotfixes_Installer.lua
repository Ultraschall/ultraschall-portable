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
]]


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Installs Hotfixes for Ultraschall

-- let's check first, if there's something to install
Message=""
if reaper.file_exists(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")==false then
  return 
else
  Message=ultraschall.ReadFullFile(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")
end

-- second, remove the indicator file, which will be there only, if an update-ReaperConfigZip-file has been added
  os.remove(reaper.GetResourcePath().."/Scripts/Ultraschall_Install.me")

-- third, get all files in ResourcePath/Scripts/Ultraschall_Installfiles
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath().."/Scripts/Ultraschall_Installfiles")

-- fourth, create all directories, so even new directories are existing then
for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(string.gsub(dirs_array[i], "/Scripts/Ultraschall_Installfiles", ""), 0)
end


-- fifth, copy the files
-- if there's a dll to install, it will rename the currently installed version to dllname.dllold
-- as the windows-version locks access to the dll, so renaming it is the only option to install
-- the new dll in the place of the old one
for i=1, found_files do
  tempfilename=string.gsub(files_array[i], "/Scripts/Ultraschall_Installfiles", "")
  if files_array[i]:sub(-4,-1)==".dll" then    
    os.remove(tempfilename.."old")
    os.rename(tempfilename, tempfilename.."old")
  end
  ultraschall.MakeCopyOfFile_Binary(files_array[i], tempfilename)
end

-- sixth, delete all installer-files
for i=1, found_files do
  os.remove(files_array[i])
end

reaper.MB("New Ultraschall-Hotfix Properly Installed.\n\n"..Message.."\n\nWill restart now Reaper for the changes to take effect.", "Ultraschall Hotfix Installer", 0)

reaper.Main_OnCommand(40063,0)
reaper.Main_OnCommand(40004,0)
