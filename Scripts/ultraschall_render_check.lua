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

-- checks, whether any track is muted and warns in that case before rendering
-- user can abort before rendering in that case as well


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


--A=reaper.GetMasterMuteSoloFlags()
--if lol==nil then return end

if ultraschall.AnyTrackMute(true) == true then
  if reaper.GetMasterMuteSoloFlags()&1==1 then text="(including Master track)" else text="" end
  Retval=reaper.MB("There are muted tracks"..text..". Do you want to continue rendering?", "Warning: muted tracks!", 4)
else
  Retval=6
end

if Retval == 6 then
  cmd=reaper.NamedCommandLookup("40521")  -- set playrate to 1
  reaper.Main_OnCommand(cmd,0)

  -- cmd=reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Editing")  -- set routing matrix to editing
  -- reaper.Main_OnCommand(cmd,0)

  cmd=reaper.NamedCommandLookup("40296")  -- select all tracks
  reaper.Main_OnCommand(cmd,0)

  cmd=reaper.NamedCommandLookup("40015")  -- open render interface
  reaper.Main_OnCommand(cmd,0)
end
