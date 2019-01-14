-- Ultraschall-API demoscript by Meo Mespotine 11.12.2018
-- 
-- store new ExtStates for the first selected MediaItem

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get the first selected MediaItem and it's name
item=reaper.GetSelectedMediaItem(0,0)
if item==nil then return end
name = ultraschall.GetItemName(item)

-- get the extstates stored with this MediaItem
storedextstates=""
for i=1, 5 do
  temp, temp2 = ultraschall.GetItemExtState(item, tostring(i))
  storedextstates=storedextstates..tostring(temp2)..","
end

-- show the inputdialog, with the already stored extstates as default
retval, retvals_csv = reaper.GetUserInputs("Set ItemExtStates "..name, 5, "01,02,03,04,05,extrawidth=300", tostring(storedextstates))
if retval==false then return end

-- separate the returned inputfields into an array
count, vals = ultraschall.CSV2IndividualLinesAsArray(retvals_csv, ",")

-- set the new ExtStates to the MediaItem
for i=1, 5 do
  retval = ultraschall.SetItemExtState(item, tostring(i), vals[i],true)
end

