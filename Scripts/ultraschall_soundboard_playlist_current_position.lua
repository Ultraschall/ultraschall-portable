retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
if tonumber(Position)==-1 then Position=0 end
reaper.MB("The current sound in the playlist is position "..(tonumber(math.tointeger(Position)+1)).." of 24", "Soundboard Playlist", 0)
