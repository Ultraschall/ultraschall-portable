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
-- Toggles AutoFollowModeOff
-- If toggled on, it will start ultraschall_followmode_reset.lua
-- If toggled off, it will stop the script ultraschall_followmode_reset.lua; Followmode must be de/activated manually in that case.

-- 6th of December 2019

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if reaper.HasExtState("ultraschall_follow", "autofollowoff")==true then
  reaper.DeleteExtState("ultraschall_follow", "autofollowoff", false)
  ultraschall.SetUSExternalState("ultraschall_follow", "AutoFollowOff", "off")
  --reaper.MB("Follow Mode: Auto Off when clicking into arrangeview is turned off.\n\nFollow Mode must be started and stopped manually.", "Follow Mode", 0)
else
  commandid=reaper.NamedCommandLookup("_Ultraschall_Toggle_Reset")
  reaper.Main_OnCommand(commandid,0)
  ultraschall.SetUSExternalState("ultraschall_follow", "AutoFollowOff", "on")
  --reaper.MB("Follow Mode: Auto Off when clicking into arrangeview is activated.\n\nFollow Mode will stop automatically when clicking into the arrangeview.", "Follow Mode", 0)
end