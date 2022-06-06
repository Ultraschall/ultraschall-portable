  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end


retval, path = reaper.JS_Dialog_BrowseForFolder("Choose Script Folder", "")
if retval~=1 then return end

found_dirs, dirs_array, found_files, files_array = 
ultraschall.GetAllRecursiveFilesAndSubdirectories(path)

B=""
A=0
for i=1, found_files do 
  for k in io.lines(files_array[i]) do

    if k:match("SetExtState%(") then 
      if oldfile~=files_array[i] then
        newfile=files_array[i].."\n\t"
        print_update("Checking File: "..files_array[i])
        A=A+1
      else
        newfile="\t"
      end
      temp=k:match("SetExtState%((.-),")
      if temp==nil then temp=k:match("SetExtState%((.*)") end
      
      B=B..newfile..
      temp.."\n"
      oldfile=files_array[i]
    end
  end
end
print("\nFound "..A.." files using SetExtState.\nPut results into the clipboard.")
print3(B)