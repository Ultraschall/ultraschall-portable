-- Unfertig...

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

print2("Läuft noch nicht...sorry...")

if LOL==nil then return end



local retval, project_path_name = reaper.EnumProjects(-1, "")
local dir = ultraschall.GetPath(project_path_name, separator)

filenames={}

for i=1, ultraschall.CountNormalMarkers() do
  retval, filename = ultraschall.GetSetChapterMarker_Attributes(false, i, "chap_image_path", "")
  if filename=="" then filenames[i]="" else filenames[i]=dir..""..filename end
end

if #filenames==0 then return end

reaper.Undo_BeginBlock()
local A=reaper.InsertTrackAtIndex(-1, false)
--trackstring = ultraschall.CreateTrackString_SelectedTracks()
--ultraschall.SetAllTracksSelected(false)
--ultraschall.SetTracksSelected(tostring(reaper.CountTracks(0)), true)
for i=1, #filenames do
  if filenames[i]~="" then
    NormalMarkerAttributes={ultraschall.EnumerateNormalMarkers(i)}
    position=NormalMarkerAttributes[3]
    NormalMarkerAttributes_Next={ultraschall.EnumerateNormalMarkers(i+1)}
    if NormalMarkerAttributes_Next[1]==-1 then 
      length=reaper.GetProjectLength(0)-position 
    else 
      length=NormalMarkerAttributes_Next[3]-position 
    end
    --print2(length)
    retval, item, endposition, numchannels, Samplerate, Filetype, editcursorposition, track = ultraschall.InsertMediaItemFromFile(filenames[i], reaper.CountTracks(0), position, length, 2)
  end
end

reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Ultraschall_Chapter_Images", true)
--ultraschall.SetTracksSelected(trackstring, true)


