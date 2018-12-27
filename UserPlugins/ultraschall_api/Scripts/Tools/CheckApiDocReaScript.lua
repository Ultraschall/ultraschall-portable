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



