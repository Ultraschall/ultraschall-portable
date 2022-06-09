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

-- This checks, whether any string, stored in a selected file, is a valid and currently used regular extstate(no project extstates!)
-- If found, it will be displayed in the console.
--
-- Meo-Ada Mespotine 9th of June 2022 - licensed under MIT-license


lastfilename=reaper.GetExtState("ultraschall_api", "extstate_searcher_lastfilename")
retval, filename = reaper.GetUserFileNameForRead(lastfilename, "Select File", "")

if retval==false then return end
reaper.SetExtState("ultraschall_api", "extstate_searcher_lastfilename", filename, true)

print("reading file")
A, B, C=ultraschall.ReadFullFile(filename, true)

split_string={}
count=0

print_update("reading strings")
for pos, k in string.gmatch(A, "()([%a%_%s]*)") do
--  print_update(k)
  if k:len()>3 then -- and k:match("%s")==nil then
    count=count+1
    split_string[count]=k    
  end
end
print("found "..#split_string.." strings")
print("convert to lowercase")
for i=1, #split_string do
  split_string[i]=split_string[i]:lower()
end

table.sort(split_string)

print("throw out duplicates")
for i=#split_string-1, 1, -1 do
  if split_string[i+1]==split_string[i] then table.remove(split_string, i+1) end
end
--[[
for i=1, #split_string do
  for a=#split_string, i+1, -1 do
    if split_string[i]==split_string[a] then
      table.remove(split_string, a)
      break
    end
  end
end
--]]

print("Check for currently used extstates")
for i=1, #split_string do
  for a=1, #split_string do
    A=reaper.GetExtState(split_string[i], split_string[a])
    if A~="" then
      print("\t"..split_string[i].." -> "..split_string[a].." -> "..A)
    end
  end
end
print("done")

