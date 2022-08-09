--[[
################################################################################
# 
# Copyright (c) 2014-2022 Ultraschall (http://ultraschall.fm)
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
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.GetAllPlannedMarkers()
  local markerlist={}
  local counter=1
  for i=0, reaper.CountProjectMarkers(0) do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
    if color==ultraschall.ConvertColor(100,255,0) then markerlist[counter]=retval counter=counter+1 end
  end
  return counter-1, markerlist
end

function ultraschall.MoveMarkers(markerarray, time, relative)
  if type(markerarray)~="table" then return false end
  if type(time)~="number" then return false end
  if type(relative)~="boolean" then return false end
  local counter=1
  while markerarray[counter]~=nil do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, markerarray[counter]-1)

    if relative==true then 
        reaper.SetProjectMarkerByIndex2(0, retval-1, isrgn, pos+time, rgnend, markrgnindexnumber, name, color, 0)
    else 
        reaper.SetProjectMarkerByIndex2(0, retval-1, isrgn, time, rgnend, markrgnindexnumber, name, color, 0)
    end
    counter=counter+1
  end
  return true
end

retindexnumber, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)

if retindexnumber==-1 then
  retindexnumber, retposition, retmarkername, retindex = ultraschall.GetClosestNextMarker(0)
else
  retval, isrgn, retposition, rgnend, retmarkername, retindex = reaper.EnumProjectMarkers(retindexnumber)
end

markertype = ultraschall.GetMarkerType(retindexnumber)
if markertype~="normal" then return end

if retindexnumber~=-1 then
  A,B=ultraschall.GetAllPlannedMarkers()
  reaper.Undo_BeginBlock()
    CCC=ultraschall.MoveMarkers(B, .1, true)
  reaper.Undo_EndBlock("Set next normal marker to planned chapter", -1)
  
  reaper.Undo_BeginBlock()
    reaper.SetProjectMarkerByIndex2(0, retindexnumber, false, 0.1, 0, 0, "_Planned:"..retmarkername, ultraschall.ConvertColor(100,255,0), 0)
  reaper.Undo_EndBlock("Set next normal marker to planned chapter", -1) -- has to be a second UNDO block! -- But why?
end
--]]

