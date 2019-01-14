dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

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


