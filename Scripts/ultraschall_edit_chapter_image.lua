dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

print2("Buggy...")
--[[
retval, filename = reaper.GetUserFileNameForRead("", "Select Image", "*.jpg;*.png;*.jpeg")
file=ultraschall.ReadFullFile(filename, true)
convertfile=ultraschall.ConvertAscii2Hex(file)
--convertfile2=ultraschall.ConvertAscii2Hex2(file)

--A=file:len()
--B=convertfile:len()
C=file==convertfile
--[[

retval, filename = reaper.GetUserFileNameForRead("", "Select Image", "*.jpg;*.png;*.jpeg")
index=4
if ultraschall.CheckForValidFileFormats(filename)=="JPG" or ultraschall.CheckForValidFileFormats(filename)=="PNG" then
  file=ultraschall.ReadFullFile(filename, true)
  reaper.SetProjExtState(0, "MarkerExtState_{489AD835-EC0E-47BA-82AE-5636EF24129C}", "chap_image", file)
--  if file==nil then print2("Can't read file") return end
--  retval, content = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image", file, planned)
  --print2(file:len())
end

AA, Final=reaper.GetProjExtState(0, "MarkerExtState_{489AD835-EC0E-47BA-82AE-5636EF24129C}", "chap_image")
File_Len=file:len()
Final_Len=Final:len()
B1=string.byte(file:sub(6,6))
--retval, content2 = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image", file, planned)
C1=ultraschall.ConvertAscii2Hex(file)

--C=content:len()
--D=content2:len()
--[[
reaper.SetProjExtState(0, "test", "test", file)
C,C1=reaper.GetProjExtState(0, "test", "test")
A=file:len()
A1=content:len()
--]]

--A,B,C=ultraschall.GetMarkerExtState(7, "chap_image"):len()


SLEM()

if LOL==nil then return end
gfx.init()
retval, content = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image", file, planned)
C=content:len()
ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/tempfile.ng", content, true)
B=reaper.file_exists(ultraschall.API_TempPath.."/tempfile.png")
SLEM()
A=gfx.loadimg(1, ultraschall.API_TempPath.."/tempfile.png")
gfx.x=0
gfx.y=0
gfx.dest=-1
gfx.blit(1, 1, 0)

if LOL==nil then return end


marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)
if marker_id==-1 then return end

index = ultraschall.GetNormalMarkerIDFromGuid(guid)
if index==-1 then
  index, markertype = ultraschall.GetCustomMarkerIDFromGuid(guid)
  if markertype~="Planned" then return else planned=true end
  index=index+1 -- needs to be added, so I don't need to add 1 to all GetSetChapterMarker_Attributes-functions when dealing with planned markers
end

if planned==nil then 
  retnumber, shown_number, pos, name, guid = ultraschall.EnumerateNormalMarkers(index) 
else
  retval, marker_index, pos, name, shown_number, color, guid = ultraschall.EnumerateCustomMarkers("Planned", index-1)
end

retval, content = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image", file, planned)
ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/tempfile.jpg")
gfx.init()

function main()
  if gfx.getchar()~=-1 then reaper.defer(main) end
end

main()

gfx.loadimg(1, ultraschall.API_TempPath.."/tempfile.jpg")
gfx.x=0
gfx.y=0
gfx.dest=-1
gfx.blit(1, 1, 0)

retval, filename = reaper.GetUserFileNameForRead("", "Select Image", "*.jpg;*.png;*.jpeg")

if ultraschall.CheckForValidFileFormats(filename)=="JPG" or ultraschall.CheckForValidFileFormats(filename)=="PNG" then
  file=ultraschall.ReadFullFile(filename, true)
  if file==nil then print2("Can't read file") return end
  retval, content = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image", file, planned)
end

retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_description", "")
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_license", "")
retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_origin", "")
retval, chap_image_url = ultraschall.GetSetChapterMarker_Attributes(false, index, "chap_image_url", "")

retval, retvals_csv = reaper.GetUserInputs("Image Attributes", 4, "Image Description,License of the Image,Origin of the Image,URL of the Image,separator=\b,extrawidth=240", chap_image_description.."\b"..chap_image_license.."\b"..chap_image_origin.."\b"..chap_image_url)
count, entries = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, "\b")

retval, chap_image_description = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_description", entries[1])
retval, chap_image_license = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_license", entries[2])
retval, chap_image_origin = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_origin", entries[3])
retval, chap_image_url = ultraschall.GetSetChapterMarker_Attributes(true, index, "chap_image_url", entries[4])
--]]
