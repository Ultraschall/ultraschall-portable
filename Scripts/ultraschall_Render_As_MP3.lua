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

-- Selects the MP3-render-preset and opens the Render to File-dialog.
-- Will keep the old directory and filename, which was set in the Render to File-dialog before.
-- Meo Mespotine 16.3.2020
-- Check for muted Tracks

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if ultraschall.AnyTrackMute(true) == true then

  Retval=reaper.MB("There are muted tracks. Do you want to continue rendering?", "Warning: muted tracks!", 4)
  if Retval==6 then
    A=false
    -- print (Retval)
  end
else
  A=false
end

if A == false then
  cmd=reaper.NamedCommandLookup("40521")  -- set playrate to 1
  reaper.Main_OnCommand(cmd,0)

  -- cmd=reaper.NamedCommandLookup("40296")  -- select all tracks
  -- reaper.Main_OnCommand(cmd,0)

  -- change render-preset to mp3 and open render-to-file-dialog

  RenderTable = ultraschall.GetRenderPreset_RenderTable("MP3", "MP3")
  retval, RenderTable["RenderPattern"] = reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", false)
  retval, RenderTable["RenderFile"] = reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", false)

  retval = ultraschall.ApplyRenderTable_Project(RenderTable, true)

  reaper.Main_OnCommand(40015, 0)

end
