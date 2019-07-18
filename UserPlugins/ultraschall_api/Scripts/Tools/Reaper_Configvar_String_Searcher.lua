dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
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
