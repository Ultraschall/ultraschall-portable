--[[
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
]]

-- Some Basic Unit Tests
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- are all functions still available, when with the modules-approach
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Modules/")

A=""

for i=1, found_files do
  A=A.."\n"..ultraschall.ReadFullFile(files_array[i])
end

A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_datastructures_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_doc_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_functions_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_gfx_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_gui_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_network_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_sound_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_tag_engine.lua")
A=A.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_video_engine.lua")

B=""

for k in string.gmatch(A, "<slug>(.-)</slug>") do
  B=B..string.gsub(k,"\n","").."\n"
end

--print3(B)
Found=""
for k in string.gmatch(B, "(.-)\n") do
  if ultraschall[k]==nil then print(k) Found=Found.."\n"..k end
end
