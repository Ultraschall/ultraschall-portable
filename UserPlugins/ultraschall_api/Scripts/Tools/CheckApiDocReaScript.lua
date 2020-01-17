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

A=ultraschall.ReadValueFromFile("C:/Users/meo/AppData/Local/Temp/reascripthelp.html","<a name=\".-\"><hr>",false)
B=ultraschall.ReadValueFromFile("c:\\reaper-apihelp11.txt","<slug>.-</slug>",false)

c,C = ultraschall.SplitStringAtLineFeedToArray(A)
d, D = ultraschall.SplitStringAtLineFeedToArray(B)

--C[1]:match("//(.-)%c")
--D[3]:match("<slug>(.-)</slug>")

for i=c, 1, -1 do  
  C[i]=C[i]:match("\"(.-)\"")
end

Ccount=0
Dcount=0

for i=c, 1, -1 do
  if C[i]:match("%s")==" " then table.remove(C,i) Ccount=Ccount+1
  elseif C[i]=="" then table.remove(C,i) Ccount=Ccount+1 end
end

--reaper.MB(D[15]:match("slug"),"",0)

for i=d, 1, -1 do
  if D[i]:match("slug")==nil then table.remove(D,i)
    else 
      D[i]=D[i]:match("<slug>(.-)</slug>") Dcount=Dcount+1
  end
end


--for i=c-Ccount, 1, -1 do
--  C[i]=C[i]:sub(1,-1)
--  reaper.ShowConsoleMsg(C[i].."\n")
--end




Aempstring={}

tempo=false
count=1
a=1


for i=1, (c-Ccount) do
  for a=1, (d-Dcount) do
    --reaper.ShowConsoleMsg(">"..tostring(C[i]):sub(1,-2).."++"..tostring(D[a]).."<\n")
    if C[i]==D[a] then tempo=true end --reaper.ShowConsoleMsg(C[i].."---"..D[a].."\n") end 
  end
  if tempo==false then Aempstring[count]=C[i] count=count+1 reaper.ShowConsoleMsg(C[i].."---"..D[a].."\n") end
  tempo=false
end



