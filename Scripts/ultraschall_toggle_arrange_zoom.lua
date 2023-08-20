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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

zoomfactor=reaper.GetHZoomLevel() -- get current zoom-level
ZoomedInLevelDef=400              -- set this to the "zoom in"-level, you want to have
                                  -- 0.007(max zoom out) to 1000000(max zoom in) is valid,
                                  -- 400 is recommended
Zoomstate=ultraschall.GetUSExternalState("ultraschall_view","zoom_toggle_state")
ZoomedInLevel=ultraschall.GetUSExternalState("ultraschall_view","zoomin_level")
ZoomedInLevel=tonumber(ZoomedInLevel)
if ZoomedInLevel==-1 or ZoomedInLevel==nil then
  ZoomedInLevel=ZoomedInLevelDef
end

if Zoomstate=="false" or zoomfactor~=ZoomedInLevel then
   ultraschall.SetUSExternalState("ultraschall_view","zoom_toggle_state","true")
   ultraschall.SetUSExternalState("ultraschall_view","old_zoomfactor",zoomfactor)
   reaper.adjustZoom(ZoomedInLevel, 1, true, 0)
else
  ultraschall.SetUSExternalState("ultraschall_view","zoom_toggle_state","false")
  oldzoomfactor=ultraschall.GetUSExternalState("ultraschall_view","old_zoomfactor")
  reaper.adjustZoom(tonumber(oldzoomfactor), 1, true, 0)
end
