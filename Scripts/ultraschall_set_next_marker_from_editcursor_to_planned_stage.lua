--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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

-- Makes the next normal marker, to the right of the edit cursor, into a green planned marker
-- The newly created planned chapter marker will be moved to be the first in line,
-- so the next planned chapter-marker to be set will be the one, we have just moved 
-- with this script.
-- Will ignore other planned-chapter markers as well as edit markers and regions.

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

AA,AA2,AA3=ultraschall.GetClosestNextNormalMarker(0)

if AA~=-1 then
  A,B=ultraschall.GetAllPlannedMarkers()
  ultraschall.MoveMarkers(B, .1, true)
  reaper.SetProjectMarkerByIndex2(0, AA-1, false, 0.1, 0, 0, AA3, ultraschall.ConvertColor(100,255,0), 0)
end
