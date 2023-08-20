--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
    ok, vol, pan = reaper.GetTrackUIVolPan(tr, 0, 0)
    -- print(vol)
    if vol < 0.005 then vol = 0.005 end
    if vol < 3 then
      reaper.SetMediaTrackInfo_Value(tr, "D_VOL", vol*1.2)
    end
    -- print("Soundboard: "..i)
  -- else
    -- print("track: "..i)
  end
end


reaper.Undo_EndBlock("Ultraschall lower Soundboard volume", -1)
