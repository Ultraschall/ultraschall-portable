--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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
# s
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

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

zoomfactor=reaper.GetHZoomLevel() -- get current zoom-level
ZoomedInLevelDef=400              -- set this to the "zoom in"-level, you want to have
                                  -- 0.007(max zoom out) to 1000000(max zoom in) is valid, 
                                  -- 400 is recommended
A,Zoomstate=ultraschall.GetUSExternalState("view","zoom_toggle_state")
A,ZoomedInLevel=ultraschall.GetUSExternalState("view","zoomin_level")
ZoomedInLevel=tonumber(ZoomedInLevel)
if ZoomedInLevel==-1 or ZoomedInLevel==nil then
  ZoomedInLevel=ZoomedInLevelDef
end

if Zoomstate=="false" or zoomfactor~=ZoomedInLevel then
   ultraschall.SetUSExternalState("view","zoom_toggle_state","true",false)
   ultraschall.SetUSExternalState("view","old_zoomfactor",zoomfactor,false)
   reaper.adjustZoom(ZoomedInLevel, 1, true, 0)
else
  ultraschall.SetUSExternalState("view","zoom_toggle_state","false",false)
  A,oldzoomfactor=ultraschall.GetUSExternalState("view","old_zoomfactor")
  reaper.adjustZoom(tonumber(oldzoomfactor), 1, true, 0)
end
