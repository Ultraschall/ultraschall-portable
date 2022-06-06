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

A=reaper.GetExePath()
A=A.."/reaper.exe"

B=ultraschall.ReadFullFile(A, true)

C={}
Ccounter=0


-- get all strings
-- must be lowercase, lettersnnumbers + a maximum a single _ and length of minimum 2
for k in string.gmatch(B, "[%w%_]+") do
  if k:lower()==k and k~="" and k:len()>2 and k:match("_*"):len()<2 and k:match("%d*"):len()<2 then
    Ccounter=Ccounter+1
    C[Ccounter]=k
  end
end
--]]



-- remove duplicates
table.sort(C)

for i=Ccounter, 2, -1 do
  if C[i]==C[i-1] then table.remove(C,i) Ccounter=Ccounter-1 end
end



-- now look for valid configvars
Ints={}
Intcounter=0
Doubles={}
Doublecounter=0
Strings={}
Stringcounter=0

for i=1, Ccounter do
  int=false
  double=false
  strings=false
  
  -- ints first
  bool=reaper.SNM_SetIntConfigVar(C[i], 1875982)
  if reaper.SNM_GetIntConfigVar(C[i], -12345)==1875982 and reaper.SNM_GetIntConfigVar(C[i], 54321)==1875982 then
    Intcounter=Intcounter+1
    Ints[Intcounter]=C[i]
    int=true
  end
  
  -- then doubles/floats
  bool=reaper.SNM_SetDoubleConfigVar(C[i], 1875982)
  if reaper.SNM_GetDoubleConfigVar(C[i], -12345)==1875982 and reaper.SNM_GetDoubleConfigVar(C[i], 54321)==1875982 then
    Doublecounter=Doublecounter+1
    Doubles[Doublecounter]=C[i]
    double=true
  end
  
  -- then strings(only available in pre-releases yet)
  if reaper.get_config_var_string~=nil and reaper.get_config_var_string(C[i])==true then
    Stringcounter=Stringcounter+1
    Strings[Stringcounter]=C[i]
    strings=true
  else
    strings="n/a"
  end
  
  if int==true or double==true then
    print("IntVariable: "..tostring(int), "DoubleVariable: "..tostring(double), "StringVariable: "..tostring(strings), "\t"..C[i])
  end
  
end

print("\nI've found: ", Intcounter.." IntConfigVars", Doublecounter.." DoubleConfigVars", Stringcounter.." StringConfigVars")

--[[

D1=ultraschall.Api_Path.."misc/reaper-config_var.USDocML"
D=ultraschall.ReadFullFile(D1)

for k in string.gmatch(D, "<slug>(.-)</slug>") do
  for i=Ccounter, 1, -1 do  
    if C[i]==k then 
      table.remove(C,i)
      Ccounter=Ccounter-1 
    end
  end
end
--]]
