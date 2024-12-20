dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

A=""

AA,filename=reaper.GetProjExtState(0, "Ultraschall_File", "filename")
A=A.."exportfilename:"..filename.."\n"

for i=1, ultraschall.CountNormalMarkers() do
  AA={ultraschall.EnumerateNormalMarkers(i)}
  url=ultraschall.GetMarkerExtState(AA[1], "url")
  if url==nil then url="" end
  imagefile=reaper.EnumerateFiles(reaper.GetResourcePath().."/Data/toolbar_icons/", i-1)
  if i==1 then imagefile="" else imagefile=reaper.GetResourcePath().."/Data/toolbar_icons/"..imagefile end
  if i==3 then imagefile="" url="" end
  A=A.."markerindex:"..i.."\n"
  A=A.."markerposition:"..AA[3].."\n"
  A=A.."markername:"..AA[4].."\n"
  A=A.."markerurl:"..url.."\n"
  A=A.."markerimage:"..imagefile.."\n"
end

reaper.SetProjExtState(0, "Ultraschall_Markerdata", "markers", A)

