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

-- 1. eine Aktion “set all markers to planning stage”
-- Macht folgendes: geht alle bestehenden Marker der Zeit nach durch, und setzt sie zum einen auf
-- einen definierten Farbwert (Grün), zum anderen wird der Zeitstempel ganz auf den Anfang verschoben.
-- Die erste Marke bekommt 0:00.000, die nächste 0:00.001 und so weiter - so dass sie zwar alle “aus dem Spiel”
-- sind, aber noch editiert werden können bei Bedarf und auch noch eine Reihenfolg haben.

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

answer=reaper.ShowMessageBox("All markers will be moved to the start. And all unnamed markers will be erased. (you can UNDO this step). Proceed?", "ULTRASCHALL\nSet all markers to planning stage", 4)
if answer==6 then --yes
  reaper.Undo_BeginBlock()

  color = ultraschall.ConvertColor(100,255,0)

  markers_array={}
  marker_num=0
  
  -- get the texts of good markers and store them to an array
  for i=1, reaper.CountProjectMarkers(0)
  do
    retval, isrgnOut, posOut, rgnendOut, nameOut, markrgnindexnumberOut, colorOut = reaper.EnumProjectMarkers3(0, i-1)
    if isrgnOut==false then --ignore regions
      if nameOut=="" then nameOut="_Chapter" end
      if nameOut~="" and nameOut~="_Edit" and nameOut~="_Past" then -- ignore markers without text, "_Past" or "_Edit"-markers
        marker_num=marker_num+1
        markers_array[marker_num]=nameOut -- store Name
      end
    end
  end
  
  -- delete all markers that are not empty of "_Edit"
  for i=reaper.CountProjectMarkers(0), 0, -1
  do
    retval, isrgnOut, posOut, rgnendOut, nameOut, markrgnindexnumberOut, colorOut = reaper.EnumProjectMarkers3(0, i-1)
    if isrgnOut==false then --ignore regions
      if nameOut~="_Edit" and nameOut~="_Past" then -- ignore "_Past" or "_Edit"-markers
          L=reaper.DeleteProjectMarkerByIndex(0, i-1)
--          reaper.ShowConsoleMsg(nameOut.." "..i.." "..tostring(L).."\n")
      end
    end
  end


  
  -- create new markers
  for i=1, marker_num do
    reaper.AddProjectMarker2(0, false, (i-1)*0.001, 0, markers_array[i], 0, color)
  end
--]]
end

reaper.Undo_EndBlock("Ultraschall: Set all markers to planning stage.",0)


