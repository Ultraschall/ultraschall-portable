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
  --]]

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

--ultraschall.ApiTest()

Infilename="c:\\Ultraschall_3_2_alpha2_Hackversion\\UserPlugins\\ultraschall_api\\misc\\reaper-apihelp14.txt"

--reaper.MB(Infilename:sub(30,-1), tostring(reaper.file_exists(Infilename)),0)
A=ultraschall.ReadValueFromFile("c:\\REAPER5_95_final\\reaper_plugin_functions.h","if defined%(REAPERAPI%_WANT%_",false)
B=ultraschall.ReadValueFromFile(Infilename,"<slug>.-</slug>",false)

c,C = ultraschall.SplitStringAtLineFeedToArray(A)
--reaper.MB(A:sub(1,1000),"",0)

d, D = ultraschall.SplitStringAtLineFeedToArray(B)

slugs=0
plugin=0

for i=1, d do
  slugs=slugs+1
  D[i]=D[i]:match("<slug>(.-)</slug>")
end

for i=1, c do
  plugin=plugin+1
  C[i]=C[i]:match("%(REAPERAPI_WANT_(.-)%)")
  if C[i]==nil then C[i]="" end
end

for i=plugin, 1, -1 do
  for a=slugs, 1, -1 do
    if C[i]==D[a] then found=true end
  end
  if found~=true then reaper.ShowConsoleMsg(C[i].."\n") end
  found=false
end


