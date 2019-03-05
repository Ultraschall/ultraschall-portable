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

-- renumerates chapter-markers if they change
-- leaves planned chapter-markers, regions and editmarkers untouched

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

oldmarker_update_counter = ultraschall.GetMarkerUpdateCounter()


if reaper.GetExtState("ultraschall", "renumerate_chaptermarkers_bgdaemon")~="" then return end

reaper.SetExtState("ultraschall", "renumerate_chaptermarkers_bgdaemon", "running", false)


function exit()
  reaper.DeleteExtState("ultraschall", "renumerate_chaptermarkers_bgdaemon",false)
end

reaper.atexit(exit)

function main()
  marker_update_counter = ultraschall.GetMarkerUpdateCounter()
  if marker_update_counter~=oldmarker_update_counter then
    retval = ultraschall.RenumerateMarkers(0, 1)
  end
  oldmarker_update_counter = ultraschall.GetMarkerUpdateCounter()
  ultraschall.Defer1(main,1,15)
end

main()


