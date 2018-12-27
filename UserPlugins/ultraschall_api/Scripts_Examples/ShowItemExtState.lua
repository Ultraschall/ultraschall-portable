-- Ultraschall-API demoscript by Meo Mespotine 11.12.2018
-- 
-- retrieve and display ExtStates for the first selected MediaItem
-- will be displayed in the ReaScript-Console

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- prepare some variables
oldoutput=""
olditem=""

function main()
  -- get the first selected MediaItem and it's name
  item=reaper.GetSelectedMediaItem(0,0)  
  if item~=nil then
    name = ultraschall.GetItemName(item)
    if name==nil then name="" end
  
    -- Get the ExtStates store with the selected MediaItem
    output=""  
    for i=1, 5 do
      temp, temp2 = ultraschall.GetItemExtState(item, tostring(i))
      if temp2==nil then temp2="" end
      output=output.."    "..i..": "..temp2.."\n"
    end
    -- if extstates have been changed or the selected MediaItem has changed, display the
    -- extstates into the ReaConsole-window
    if oldoutput~=output or olditem~=item then reaper.ClearConsole() reaper.ShowConsoleMsg("Showing ExtState for Item: "..name.."\n\n"..output) end
    oldoutput=output
    olditem=item
  end
  -- repeat the whole thing
  reaper.defer(main)
end

-- let's boogie
main()
