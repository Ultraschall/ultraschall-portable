dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get filename and source
retval, filename = reaper.GetUserFileNameForRead(reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path"), "Choose file MP3-file to import chapters from...", "*.mp3")
if retval==false then return end
filename=string.gsub(filename, "\\", "/")
src=reaper.PCM_Source_CreateFromFile(filename)

-- store path to be used the next time this action is run as default path
path=filename:match("(.*/)")
if path~=reaper.GetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path") then
  reaper.SetExtState("Ultraschall_Import_Chapter_Markers", "MP3_Path", path, true)
end


-- read all chapters available from file 
local i=0 -- count variable
local retval
Chaps={} -- table to get all chapternames, and their positions
for i=0, 65500 do
  Chaps[i]={reaper.CF_EnumMediaSourceCues(src,  i)}
  if Chaps[i][4]==false then Chaps[i]=nil break end
end

-- when no chapters, show error-message
if #Chaps==0 then reaper.MB("No Chapter markers available.", "No chapter markers", 0) return end

-- insert chapters and renumerate the marker-numbers
for i=0, #Chaps do
  marker_number, guid, normal_marker_idx = ultraschall.AddNormalMarker(Chaps[i][3], 0, Chaps[i][5])
end
ultraschall.RenumerateNormalMarkers()

reaper.UpdateArrange()
