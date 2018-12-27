-- Ultraschall-API demoscript by Meo Mespotine 11.12.2018
-- 
-- retrieve and display ExtStates for the first selected MediaTrack
-- will be displayed in the ReaScript-Console

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- prepare some variables
oldoutput=""
oldtrack=""

function main()
  -- get the first selected MediaTrack and it's name
  track=reaper.GetSelectedTrack(0,0)  
  if track~=nil then
    retval, name = reaper.GetTrackName(track, "")
  
    -- Get the ExtStates store with the first selected MediaTrack
    output=""  
    for i=1, 5 do
      temp, temp2 = ultraschall.GetTrackExtState(track, tostring(i))
      if temp2==nil then temp2="" end
      output=output.."    "..i..": "..temp2.."\n"
    end
    -- if extstates have been changed or the selected MediaTrack has changed, display the
    -- extstates into the ReaConsole-window
    if oldoutput~=output or oldtrack~=track then reaper.ClearConsole() reaper.ShowConsoleMsg("Showing ExtState for track: "..name.."\n\n"..output) end
    oldoutput=output
    oldtrack=track
  end
  -- repeat the whole thing
  reaper.defer(main)
end

-- let's boogie
main() 

