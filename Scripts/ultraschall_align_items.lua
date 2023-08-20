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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function abort(txt)

  result = reaper.ShowMessageBox( txt, "FAILURE", 0 )

end

function check_items()

  local number_of_tracks = reaper.CountTracks(0)
  local selected_tracks = 0
  local lastcount = 0
  local success_state = true
  local txt = ""

  for i = 1, number_of_tracks do

    count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(), tostring(i), false)

    if count > 0 then -- mindestens ein Item in dem Tracks ist ausgewählt
      selected_tracks = selected_tracks + 1
    end

    if i > 1 then -- ab der zweiten Spur starten die Checks

      if count ~= lastcount and selected_tracks == 2 and count > 0 then
        txt = txt .. "The numbers of selected items don't match across the tracks: "..lastcount.."/"..count.."\nPlease inspect the location(s) where the difference occurs and fix it.\n\n"
        success_state = false
      end

    end
    lastcount = count
    -- print (count)
  end

  if selected_tracks > 2 then
    txt = txt .. "Items are selected across more than two tracks.\n\nYou need to select items on exactly two adjacent tracks,\n your local recording on top, the double-ender remote track below.\n\n"
    success_state = false 
  end

  if selected_tracks < 2 then
    txt = txt .. "You need to select items on exactly two adjacent tracks,\n your local recording on top, the double-ender remote track below.\n\n"
    success_state = false 
  end

  return success_state, txt
end

function main()

  state, txt = check_items()
  if state == true then
    countAligned = string.sub(tostring(reaper.CountSelectedMediaItems(0) / 2), 1, -3)
    commandid = reaper.NamedCommandLookup("_X-Raym_align")
    reaper.Main_OnCommand(commandid,0)         
    result = reaper.ShowMessageBox( countAligned .." items have been aligned.", "SUCCESS", 0 )
  else
    abort(txt)
  end
end

main()
