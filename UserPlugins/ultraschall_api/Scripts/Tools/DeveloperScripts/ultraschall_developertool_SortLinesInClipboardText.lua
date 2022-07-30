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
  --]]
  
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

if reaper.GetExtState("ultraschall_api", "dontask_developertools")~="false" then 
  retval = reaper.MB("Put the text into clipboard, which you want to have sorted.\n\nIt will sort it by line.", "", 1)
  if retval==2 then return end
end

A=FromClip().."\n"

B={}

for k in string.gmatch(A, "(.-\n)") do
  B[#B+1]=k
end


table.sort(B)

C=""
for i=1, #B do
  C=C..B[i]
end

ToClip(C)

if reaper.GetExtState("ultraschall_api", "dontask_developertools")~="false" then 
  print2("Text is now sorted and put back into clipboard")
end
