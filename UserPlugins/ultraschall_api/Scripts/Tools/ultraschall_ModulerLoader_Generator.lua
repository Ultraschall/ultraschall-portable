if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

Path=ultraschall.Api_Path.."Modules"

A1=type(Path)

print_update("Creating Moduleloader\nGet All Files")
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(Path)

SLEM()
AAA=collectgarbage("count")
AAA2=collectgarbage("collect")
AAA3=collectgarbage("count")

--if kuddel==nil then return end

print_update("Creating Moduleloader\nParse Modules")
ModulesList=""
for i=1, found_files do
  ModulesList=ModulesList.."\""..files_array[i]:match(".*/(.*)").."\",\n"
end

print_update("Creating Moduleloader\nModule Number")
function GetModuleNumber(name)
  for i=1, found_files do
    if files_array[i]:match(name) then return i end
  end
end

ModulesList=ModulesList:sub(1,-3)

Files_Contents=""
OutPutFile=[[
--[]]..[[[
################################################################################
# 
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
]]..
 "]]\n-- This makes the incredible and magical automatic loading of functions-when-needed-feature possible\n"..[[

function ultraschall.LM(name)
  dofile(ultraschall.Api_Path.."/Modules/"..ultraschall.Modules_List[name])
end

ultraschall.Modules_List={]]..ModulesList..[[}

if ultraschall.US_BetaFunctions==true then
  -- if beta-functions are available, load all functions from all modules
  local found_files=0
  local files_array2={}
  local filecount=0
  local file=""
  while file~=nil do
    local file=reaper.EnumerateFiles(ultraschall.Api_Path.."/Modules/",filecount)
    if file==nil then break end
    file=ultraschall.Api_Path.."/Modules/"..file
    found_files=filecount+1
    files_array2[filecount+1]=file
    filecount=filecount+1
  end
  for i=1, found_files do
    dofile(files_array2[i])
  end
else
  -- if beta-functions aren't available, load temporary functions, who load their accompanying module, when needed
]]


print_update("Creating Moduleloader\nCreate Moduleloader")

for i=1, found_files do
  Files_Contents=ultraschall.ReadFullFile(files_array[i])
  for k in string.gmatch(Files_Contents, "<slug>(.-)</slug>") do
    k=string.gsub(k, "\n", "")
    k=string.gsub(k, "\r", "")
    OutPutFile=OutPutFile..[[
  function ultraschall.]]..k..[[(...)
    ultraschall.LM(]]..GetModuleNumber(files_array[i]:match(".*/(.*)"))..[[)
    return ultraschall.]]..k..[[(table.unpack({...}))
  end
]]
  end
end


OutPutFile=OutPutFile.."end\ncollectgarbage(\"collect\")"

print_update("Creating Moduleloader\nWrite Moduleloader")

ultraschall.WriteValueToFile(ultraschall.Api_Path.."/ultraschall_ModulatorLoad3000.lua", OutPutFile)


-- this code would convert ultraschall_ModulatorLoad3000 into binary chunk, which loads even faster. 
-- Unfortunately, this breaks when Ultraschall-API is stored in paths with Umlauts, so loadfile doesn't 
-- find the other Ultraschall-API-files anymore.
-- So, until this is resolved by the devs of Reaper, I have to deactivate it :(

--ultraschall={}

--A,B,C,D=loadfile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_ModulatorLoad3000.lua-")
--A()
--B=string.dump(A)

--dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
--ultraschall.WriteValueToFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_ModulatorLoad3000.lua", B)
--]]