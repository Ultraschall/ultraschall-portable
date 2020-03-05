--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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


reaper.Undo_BeginBlock()

for i=0, reaper.CountTracks(0)-1 do

  if ultraschall.IsTrackSoundboard(i+1) then
    tr = reaper.GetTrack(0, i)
    runcommand(40297)                   -- deselect all tracks
    reaper.SetTrackSelected(tr, true)   -- selektiere Soundboard
    runcommand("_S&M_SHOWFXCHAIN1")     -- zeige FX des Soundboards Slot 1
    return                              -- nur das des ersten wird angezeigt
  end
end

---------------------------------------------
-- Es ist noch kein Soundboard geladen:
---------------------------------------------

if tr == nil then -- oben wurde kein Soundboard gefunden

  Retval=reaper.MB("Do you want to create one?", "There is no Soundboard track in your project.", 4) -- No/Yes Dialog
  -- print (Retval)

  if Retval==6 then -- Yes ausgewählt
    soundboard_path = reaper.GetResourcePath().."/TrackTemplates/Insert Ultraschall-Soundboard track.RTrackTemplate"
    reaper.Main_openProject(soundboard_path)    -- erstellt einen Sondboard-Track am Ende des Projektes

  end
end

reaper.Undo_EndBlock("Ultraschall lower Soundboard volume", -1)
