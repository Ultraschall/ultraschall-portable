--[[
################################################################################
#
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
-- Toggles Tims Play Ping when Playcursor hits a chapter marker-feature
-- If toggled on, it will start ultraschall_play_sound_when_playcursor_hits_chaptermarker_during_play.lua
-- If toggled off, it will stop the script ultraschall_play_sound_when_playcursor_hits_chaptermarker_during_play.lua

-- 6th of December 2019

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if reaper.HasExtState("ultraschall_tims_chapterping", "togglestate")==true then
  reaper.DeleteExtState("ultraschall_tims_chapterping", "togglestate", false)
  ultraschall.SetUSExternalState("ultraschall_tims_chapterping", "togglestate", "off")
--  reaper.MB("Tims Ping Off", "Follow Mode", 0)
else
  commandid=reaper.NamedCommandLookup("_Ultraschall_Tims_Ping_Feature")
  reaper.Main_OnCommand(commandid,0)
  ultraschall.SetUSExternalState("ultraschall_tims_chapterping", "togglestate", "on")
--  reaper.MB("Tims Ping On", "Follow Mode", 0)
end
