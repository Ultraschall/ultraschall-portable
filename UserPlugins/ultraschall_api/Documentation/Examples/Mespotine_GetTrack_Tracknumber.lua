-- How to get a track?
-- coded by Meo-Ada Mespotine and licensed under MIT-license and can be used freely

-- get the track-object of the first track and put it into the variable tr
local tr=reaper.GetTrack(0, 0)

-- get the name "P_NAME" of the track in the variable tr and put it into variable name
-- the variable retval is an indicator, if an attribute like "P_NAME" is a valid one and can be ignored here,
-- though it must be written in here as well!
local retval, name=reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)

-- show the trackname in the ReaScript console window and add a line break
reaper.ShowConsoleMsg(name.."\n")