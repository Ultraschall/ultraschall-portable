--[[
################################################################################
# 
# Copyright (c) 2023-present Meo-Ada Mespotine mespotine.de
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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

--[[

Deprecated functions in scripts-checker by Meo-Ada Mespotine 20th of December 2021
licensed under MIT-license

Check lua-scripts from a folder for deprecated and removed functions and logs them.
The log is put into the clipboar afterwards.

This might cause potential false-positives, as this script doesn't check, whether a
function is written inside a "string" or inside a 
-- comment

--]]


-- open folder, use last selected as default and remember the newly selected one for later
C=reaper.GetExtState("ultraschall_api", "deprecated_script_checker")
if C=="" then C=reaper.GetResourcePath().."/Scripts/" end
retval, C = reaper.JS_Dialog_BrowseForFolder("Select Folder to check scripts", C)
if retval==0 then return end
reaper.SetExtState("ultraschall_api", "deprecated_script_checker", C, true)

state=reaper.GetExtState("ultraschall_api", "deprecated_script_checker_ask")

if state=="3" then
  retval=reaper.MB("Do you want to include subfolders as well?\n\n(You can set default behavior for this in Ultraschall-API settings.)", "Subfolders?", 4)
elseif state=="1" then 
  retval=6
else
  retval=7
end

-- get all filenames that are lua-files
if retval==6 then
  _, _, Found_files, File_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(C, nil, nil, nil, false)
else
  Found_files, File_array = ultraschall.GetAllFilenamesInPath(C, nil)
end

for i=Found_files, 1, -1 do
  if File_array[i]:sub(-4,-1)~=".lua" then
    table.remove(File_array, i)
  end
end

-- get deprecated API-functions and put them into a table we use later on
local A=ultraschall.ReadFullFile(ultraschall.Api_Path.."/DocsSourceFiles/Reaper_Api_Documentation.USDocML")
local B,C = ultraschall.Docs_GetAllUSDocBlocsFromString(A)

UseMyContentsOnly={} -- all deprecated functions

for i=1, B do
  local slug=ultraschall.Docs_GetUSDocBloc_Slug(C[i])
  local X,Y,Z,Z2=ultraschall.Docs_GetUSDocBloc_Deprecated(C[i])
  if X~=nil then
    UseMyContentsOnly[#UseMyContentsOnly+1]={}
    UseMyContentsOnly[#UseMyContentsOnly]["slug"]=slug
    UseMyContentsOnly[#UseMyContentsOnly]["What"]=X
    UseMyContentsOnly[#UseMyContentsOnly]["When"]=Y
    UseMyContentsOnly[#UseMyContentsOnly]["Alt"]=Z
    UseMyContentsOnly[#UseMyContentsOnly]["removed"]=Z2
  end
end

FilesCount=0
FilesFound=0

function CheckFiles(i)
  -- this function checks a file with index i inside File_array
  if File_array[i]==nil then return end
  local Found=false
  
  -- read file, end function if file can't be read and note it into the log
  local C=ultraschall.ReadFullFile(File_array[i])
  if C==nil then 
    Log=Log.."\n\n"..File_array[i].." \n\tCan't be accessed. \n\tMaybe filename+pathnames too long?"
    return 
  end
  
  -- read all reaper.functionnames( from the curently opened script
  local D={}
  for k in string.gmatch(C, "reaper%.(.-)%(") do
    k=string.gsub(k, " ", "")
    k=string.gsub(k, "\n", "")
    k=string.gsub(k, "\r", "")
    k=string.gsub(k, "\t", "")
    D[k]=k
  end
  
  -- now check, if any of these functionnames is deprecated. If yes, put it into the log
  for a=1, #UseMyContentsOnly do
    if D[UseMyContentsOnly[a]["slug"]]~=nil then
      if Found==false then 
        -- found deprecated function
        Found=true 
        Log=Log.."\n\n"..(FilesFound+1)..": "..File_array[i].."" 
        FilesFound=FilesFound+1 
      end
      Log=Log.."\n\t\t* Deprecated function\t: "..UseMyContentsOnly[a]["slug"]..
               "\n\t\t\t\tDeprecated since: "..UseMyContentsOnly[a]["What"].." "..UseMyContentsOnly[a]["When"]..
               "\n\t\t\t\tAlternative\t\t: "..UseMyContentsOnly[a]["Alt"].."\n"
      if UseMyContentsOnly[a]["removed"]==true then 
        -- found used function, that was even removed
        Log=Log.."\n\tWarning: this function got removed, so this script doesn't work anymore!!" 
      end
    end
  end
  
  -- output check-status to reaconsole
  print_update(Log2.."\nChecking script: "..i.."/"..#File_array.." - "..File_array[i]:match(".*[\\/](.*)").."\n\nPotential problematic scripts: "..FilesFound)
end

function main()
  -- go through all files and check them using CheckFiles()
  -- put Log into clipboard, when done
  FilesCount=FilesCount+1
  CheckFiles(FilesCount)
  if FilesCount<#File_array then 
    reaper.defer(main)
  else
    if finished~=true then 
      print("\nDone. \nLog put into the clipboard.")
      finished=true
    end
    print3(Log)
  end
end

Log=[[
Deprecated functions in scripts-checker by Meo-Ada Mespotine 20th of December 2021

Check lua-scripts from a folder for deprecated and removed functions and logs them.
The log is put into the clipboard afterwards.

This might cause potential false-positives, as this script doesn't check, whether a
function is written inside a "string" or inside a 
-- comment
]]
Log2=Log
print(Log)

-- run multiple instances of the main-function, to check more files/second
for i=0, 100 do 
  main()
end
