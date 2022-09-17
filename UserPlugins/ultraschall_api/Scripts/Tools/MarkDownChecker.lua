if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

-- select mode:
--  mode 1: check all linknames for _ and escape them
--  mode 2: count unescaped _ for unevenness

mode=1

A=ultraschall.ReadFullFile(ultraschall.Api_Path.."/DocsSourcefiles/Reaper_API_Video_Documentation.USDocML")

if mode==1 then 
  -- check all linknames for _ and escape them
  
  reaper.ClearConsole()
  i=0
  B=A:reverse()
  
  FoundTable={}
  
  for start, val, ende in string.gmatch(B, "()(%(%].-%[)()") do
    if val:match("_")~=nil and val:match("_\\")==nil then
      i=i+1
      FoundTable[i]={}
      FoundTable[i]["start"]=start
      FoundTable[i]["ende"]=ende
      FoundTable[i]["val"]=string.gsub(val, "_", "_\\")
      print(FoundTable[i]["val"]:reverse())
    end
  end
  
  
  C1=B:len()
  for a=i, 1, -1 do
    B=B:sub(1, FoundTable[a]["start"]-1)..FoundTable[a]["val"]..B:sub(FoundTable[a]["ende"], -1)
  end
  C2=B:len()
  C3=C2-C1
  
  print3(B:reverse())

elseif mode==2 then
  Count1=0
  Count2=0
  
  for k in string.gmatch(A, "_") do
    Count1=Count1+1
  end

  for k in string.gmatch(A:reverse(), "_\\") do
    Count2=Count2+1
  end
  
  print2(Count1, Count2, Count1-Count2, (Count1-Count2)%2)
end
