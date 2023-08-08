-- How to get a track?
-- coded by Meo-Ada Mespotine and licensed under MIT-license and can be used freely

-- get the track-object of the master-track and put it into the variable mtr
mtr=reaper.GetMasterTrack(0, 0)

-- get the volume "D_VOL" of the track in the variable tr and put it into the variable volume
volume=reaper.GetMediaTrackInfo_Value(mtr, "D_VOL")

-- show the trackname in the ReaScript console window and add a line break
reaper.ShowConsoleMsg(volume.."\n")
