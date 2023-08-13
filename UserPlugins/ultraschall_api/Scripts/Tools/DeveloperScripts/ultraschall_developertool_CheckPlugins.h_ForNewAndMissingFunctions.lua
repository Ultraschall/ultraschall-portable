--[[
################################################################################
# 
# Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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

reaper.Main_OnCommand(41064,0)

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper_plugin_functions.h")
B={}
C={}
D=""

D=D.."missing:".."\n"
for k in string.gmatch(A, "#if defined.-\n#endif.-\n") do
  if k:match(".-\n.-\n(.-)\n")~=nil then
    B[#B+1]=k:match(".-\n.-\n(.-)\n"):sub(4,-1)
    C[k:match(".-\n.-\n(.-)\n"):sub(4,-1)]=k:match(".-\n.-\n(.-)\n"):sub(4,-1)
  end
end

for i=1, #B do
  A={ultraschall.Docs_FindReaperApiFunction_Pattern(B[i], false, false, false)}
  A1=B[i]
  if A[1]==0 then 
    D=D.."  "..B[i].."\n"
  end
end

D=D.."deprecated:".."\n"
for i=1, #ultraschall.Docs_ReaperApiDocBlocs_Slug do
  if C[ultraschall.Docs_ReaperApiDocBlocs_Slug[i]]==nil then
    D=D.."  "..ultraschall.Docs_ReaperApiDocBlocs_Slug[i].."\n"
  end
end


--A={ultraschall.Docs_FindReaperApiFunction_Pattern("ViewPrefs", false, false, false)}
ToClip(D)
print("done")
