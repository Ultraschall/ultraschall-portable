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
 
-------------------------------------
-- Print Message to console (debugging)
-------------------------------------

function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

-- 3. Eine Aktion “Import Markers from Clipboard” - schaut über die neue SWS Aktion 
-- CF_GetClipboard() - Read the contents of the system clipboard
-- eventuell auch
-- CF_GetClipboardBig (Thanks cfillion!)
--
-- Dort wird nachgesehen, ob a) Einträge entsprechend unserem eigenen Format vorliegen
-- (Zeitstempel, Titel, Zeilenumbruch), also genau das was “import markers from file…”
-- schon macht, nur aus dem ClipBoard. Die Einträge werden dann an die richtige Zeit
-- geschrieben. Oder b) wenn keine Zeitstempel vorhanden sind, sich die Einträge zeilenweise
-- nimmt und der Regel aus 1) nach an den Anfang schreibt mit dem Grünen Farbwert
-- (da es auf jeden Fall noch zu positionierende Marker sein müssen).

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")




----------------------------
---- AB HIER GEHTS LOS: ----
----------------------------
reaper.Undo_BeginBlock()

--os = reaper.GetOS()
--if string.match(os, "OSX") then 
--  color = 0x00FF88|0x1000000
--else
--  color = 0x88FF00|0x1000000
--end

color=ultraschall.ConvertColor(100,255,0)

clipboard_string=ultraschall.GetStringFromClipboard_SWS() 
--clipboard_string="0:00:02.050 Test1\n   Katze1\nKatze2   \n00:04:00 Test2"

-- marker_table[1][markernummer] - die Zeit als Timestring. -1, wenn es keine Zeitangabe gibt
-- marker_table[2][markernummer] - die Zeit, konvertiert in Sekunden. -1, wenn es keine Zeitangabe gibt
-- marker_table[3][markernummer] - der Name des Markers

number_of_markerentries,marker_table=ultraschall.ParseMarkerString(clipboard_string, true)
green_marker_num=-1

for i=1, number_of_markerentries do
  if marker_table[3][i]~="" and marker_table[2][i]~=-1 then
    -- normal entry with time and text -> put a grey marker at position
    marker_table[3][i]=marker_table[3][i]:match("\t*%s*(.*)")
    reaper.AddProjectMarker2(0, false, marker_table[2][i],0, marker_table[3][i]:match("(.-)%s-$"), 1 , 0x666666|0x1000000)
  elseif marker_table[3][i]~="" and marker_table[2][i]==-1 then
    -- normal entry without time but text -> green marker
    green_marker_num=green_marker_num+1
    marker_table[3][i]=marker_table[3][i]:match("\t*%s*(.*)")
    reaper.AddProjectMarker2(0, false, green_marker_num*0.001,0, marker_table[3][i]:match("(.-)%s-$"), 0, color)
  end
end

-- renumber grey markers
ultraschall.RenumerateMarkers(0x666666|0x1000000, 1)

reaper.Undo_EndBlock("Ultraschall: Import markers from clipboard.",0)
