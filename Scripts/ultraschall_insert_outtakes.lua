--[[
################################################################################
#
# Copyright (c)  Ultraschall (http://ultraschall.fm)
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

retval, old_max_items=reaper.GetProjExtState(0, "ultraschall_outtakes", "max_items")
old_max_items=tonumber(old_max_items)

retval, old_max_position=reaper.GetProjExtState(0, "ultraschall_outtakes", "max_position")
old_max_position=tonumber(old_max_position)

if old_max_items==nil or old_max_position==nil then reaper.MB("No outtakes available", "Sorry", 0) return end

MediaItemStateChunkArray={}
for i=1, old_max_items do
  retval, MediaItemStateChunkArray[i] = reaper.GetProjExtState(0, "ultraschall_outtakes", "item_nr_"..i)
end

max_tracknumber=0
for i=1, #MediaItemStateChunkArray do
  tracknumber = ultraschall.GetItemUSTrackNumber_StateChunk(MediaItemStateChunkArray[i])
  if tracknumber>max_tracknumber then max_tracknumber=tracknumber end
end

trackstring = ultraschall.CreateTrackString(1, max_tracknumber)

reaper.Main_OnCommand(40859, 0)
for i=1, max_tracknumber do
--  reaper.Main_OnCommand(40001, 0)
end
number_of_items, MediaItemArray = ultraschall.InsertMediaItemStateChunkArray(0, MediaItemStateChunkArray, trackstring, true)

SLEM()
