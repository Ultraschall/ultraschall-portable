-- Ultraschall-API demoscript by Meo Mespotine 11.12.2018
-- 
-- store new ExtStates for the first selected MediaTrack

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get the first selected MediaTrack and it's name
track=reaper.GetSelectedTrack(0,0)
if track==nil then return end
retval, name = reaper.GetTrackName(track,"")

-- get the extstates stored with this MediaTrack
storedextstates=""
for i=1, 5 do
  temp, temp2 = ultraschall.GetTrackExtState(track, tostring(i))
  if temp2==nil then temp2="" end
  storedextstates=storedextstates..tostring(temp2)..","
end

-- show the inputdialog, with the already stored extstates as default
retval, retvals_csv = reaper.GetUserInputs("Set TrackExtStates "..name, 5, "01,02,03,04,05,extrawidth=300", tostring(storedextstates))
if retval==false then return end

-- separate the returned inputfields into an array
count, vals = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, ",")

-- set the new ExtStates to the MediaTrack
for i=1, 5 do
  retval = ultraschall.SetTrackExtState(track, tostring(i), vals[i],true)
end
 
