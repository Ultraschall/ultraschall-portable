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

ultraschall.RunCommand("_Ultraschall_Turn_Off_Followmode")

length=reaper.GetProjectLength(0)
markerindex, position, markertitle, markerindex_shownnumber = ultraschall.GetClosestNextMarker(0)
markerindex, position2, markertitle, edge_type, markerindex_shownnumber = ultraschall.GetClosestNextRegionEdge(0)
--SLEM()
if position==-1 then position=position2 end
if position2~=-1 and position2<position then position=position2 end

if position~=-1 then
  ultraschall.StoreTemporaryMarker(-2)
  if reaper.GetPlayState()&1==1 then
    reaper.SetEditCurPos(position, true, true)
  else
    reaper.MoveEditCursor(-reaper.GetCursorPosition()+position, false)
  end
elseif position==-1 and reaper.GetProjectLength(0)>=reaper.GetCursorPosition() then 
  reaper.MoveEditCursor(-reaper.GetCursorPosition()+reaper.GetProjectLength(0), false)
end
