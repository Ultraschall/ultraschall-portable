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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if reaper.GetExtState("ultraschall_api", "dontask_developertools")~="false" then 
  print2("Please put the content of the original language-pack into the clipboard")
end

clipboard_string = ultraschall.GetStringFromClipboard_SWS()

count, split_string = ultraschall.SplitStringAtLineFeedToArray(clipboard_string)


for i=1, count do
  if split_string[i]:sub(1,1)~=";" and split_string[i]:match("%[")~=nil then
    sec=tostring(split_string[i]:match("%[.-%]"))
  end
  if sec~=nil and split_string[i]:sub(1,1)==";" then
    split_string[i]=tostring(split_string[i]:match(";(.-=)"))..sec..tostring(split_string[i]:match("=(.*)"))
  end
end

A=""
for i=1, count do
  A=A..split_string[i].."\n"
end

print3(A)
if reaper.GetExtState("ultraschall_api", "dontask_developertools")~="false" then 
  print2("Converted Langpack has been put into the clipboard.")
end
