--[[
################################################################################
#
# Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
################################################################################
]]

-- little helpers
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

---------------
-- Functions
---------------

function getFX(track, name)
  local fxSlot = nil

  for i = 0, reaper.TrackFX_GetCount(track) do
    retval, fxName = reaper.TrackFX_GetFXName(track, i, "")
    if string.find(fxName, name) then
      fxSlot = i    
    end
  end
  return fxSlot
end

-------------
-- Main
-------------

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

numberSelectedTracks = reaper.CountSelectedTracks(0)

if numberSelectedTracks > 0 then -- SELECTED TRACKS LOOP

  for i = 0, numberSelectedTracks-1 do
    track = reaper.GetSelectedTrack(0, i)
  
    Dynamics_fxSlot = getFX(track, "Dynamics")

    if Dynamics_fxSlot then -- es gibt den FX schon, also nur aktivieren
      reaper.TrackFX_SetEnabled(track, Dynamics_fxSlot, true)
    else -- FX hinzufügen
      fx_slot = reaper.TrackFX_AddByName(track, "Ultraschall_Dynamics", false, 1) 
      reaper.TrackFX_SetEnabled(track, fx_slot, true)
    end
  end
  reaper.Main_OnCommand(40297,0)         -- unselect all tracks

  mastertrack = reaper.GetMasterTrack(0)
  fx_slot = reaper.TrackFX_AddByName(mastertrack, "LUFS_Loudness_Meter", false, 1) 
	reaper.TrackFX_SetEnabled(mastertrack, fx_slot, true)

else -- kein Track ausgewählt
  result = reaper.ShowMessageBox( "You need to select at least one track. Use the number keys for quick select/unselect, 9 for all tracks.", "Ultraschall AMP", 0 )  -- Info window
end

-----------------------------

reaper.Undo_EndBlock("Ultraschall AMP", -1) -- End of the undo block. Leave it at the bottom of your main function.
