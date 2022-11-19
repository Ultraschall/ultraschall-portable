dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--A,B = ultraschall.GetSetChapterMarker_Attributes(false, 1, "chap_image_path", "")
--A=ultraschall.GetPodcastAttributesAsJSON()
--A=ultraschall.GetChapterAttributesAsJSON(1)
--SLEM()

A,B=ultraschall.GetSetShownoteMarker_Attributes(true, 1, "shwn_position", "122.9a")
-- retval, marker_index2, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(1)
SLEM()
--retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(1)
if lol==nil then return end

retval, hwnd = ultraschall.GFX_Init("Create Podcast Metadata", 600, 100, 0)
gfx.setfont(1, "Arial", size, 0)
JSON="{\n"
--JSON="{\n\t\"PodMeta\":\"version 1.0\","
--JSON=JSON.."\n\t\"PodMetaContent\":{\n"

function WriteMessage(message)
  gfx.set(0.17)
  gfx.rect(0,0,gfx.w,gfx.h)
  gfx.set(1)
  xand,yand=gfx.measurestr("Consolidating Podcast Metadata")
  gfx.x=(gfx.w-xand)/2
  gfx.y=16
  gfx.drawstr("Consolidating Podcast Metadata")
  xand,yand=gfx.measurestr(message)
  gfx.x=(gfx.w-xand)/2
  gfx.y=37
  

  rectWidth=((gfx.w-40)/NumEntries)*NumEntries_Count
  gfx.set(0.9843137254901961, 0.8196078431372549, 0)
  gfx.rect(14,60,rectWidth-18, 20, 1)
  gfx.set(0.6901960784313725)
  gfx.rect(11,58,((gfx.w-40)/(NumEntries+1))*(NumEntries+2)+1, 22, 0)
  gfx.set(1)
  gfx.drawstr(message)
  
  local perc=tostring(math.floor(100/NumEntries*NumEntries_Count-4)).."%"
  xand,yand=gfx.measurestr(perc)
  gfx.x=(gfx.w-xand)/2  
  gfx.y=60
  gfx.set(0)
  gfx.drawstr(perc)
  gfx.x=((gfx.w-xand)/2)-1
  gfx.y=59
  gfx.set(1)
  gfx.drawstr(perc)
end


-- Podcast Metadata
  JSON = JSON.."\t\t"..string.gsub(ultraschall.GetPodcastAttributesAsJSON(), "\n", "\n\t\t"):sub(1,-4)..",\n"

-- Episode Metadata
  JSON2=ultraschall.GetEpisodeAttributesAsJSON()
  if JSON==nil then print2("Imagefile not found") return end
  JSON = JSON.."\t\t"..string.gsub(JSON2, "\n", "\n\t\t"):sub(1,-4)..",\n"

-- Chapter MetaData
  for i=1, ultraschall.CountNormalMarkers() do
    JSON2=ultraschall.GetChapterAttributesAsJSON(i)
    if JSON2==nil then print2("Imagefile not found") return end
    JSON = JSON.."\t\t"..string.gsub(JSON2, "\n", "\n\t\t"):sub(1,-4)..",\n"
  end


function WriteEntries()
  JSON=JSON:sub(1,-3).."\n}"
  reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TXXX:PodMeta|"..JSON, true)
  ultraschall.SetRender_EmbedMetaData(true)
  --print3(JSON)
  -- test for validity(testsystem only)
  if reaper.file_exists(reaper.GetResourcePath().."/jq-win64.exe")==true then
    ultraschall.WriteValueToFile(reaper.GetResourcePath().."/JSON-test.txt", JSON)
    os.execute(reaper.GetResourcePath().."/JSON-test.Bat")
  end
end




function atexit()
  gfx.quit()
end

reaper.atexit(atexit)

WriteEntries()
