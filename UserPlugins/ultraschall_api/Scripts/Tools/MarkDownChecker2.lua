if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

-- checks for possibly unusual italic-tags in docs-files

A=ultraschall.ReadFullFile(ultraschall.Api_Path.."/Documentation/US_Api_Introduction_and_Concepts.html")

i=0
B=""

for k in string.gmatch(A, ".............<i>.-</i>..............") do
  if k:match("<i> %- </i>")==nil 
    and k:match("style=\"color:#0000ff;\">")==nil 
    and k:match("</i></td>")==nil 
  then
    i=i+1
    B=B.."\n"..k
  end
end

print3(B)
