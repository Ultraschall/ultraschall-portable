dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

ProjectPath=reaper.GetProjectPath():match("(.*)Recordings.*")
A, B=reaper.JS_Dialog_BrowseForSaveFile("Where to store the Metadata-file?", ProjectPath, "", "")
if A~=0 then podcast_metadata = ultraschall.WritePodcastMetaData(0, reaper.GetProjectLength(0), 0, B) end
