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

if ultraschall.AnyTrackMute(true) == true then
  Retval=reaper.MB("There are muted tracks. Do you want to continue rendering?", "Warning: muted tracks!", 4)
  if Retval==7 then return end
end


menu={}
menu[#menu+1]={"Render using last used settings", ""}
menu[#menu+1]={"Render as MP3", "MP3"}
-- TODO: add linux preset
if reaper.GetOS():match("OS")~=nil then menu[#menu+1]={"Render as M4A", "m4a_Mac"}
elseif reaper.GetOS():match("Win") then menu[#menu+1]={"Render as M4A", "m4a_Windows"}
elseif reaper.GetOS():match("Other") then menu[#menu+1]={"Render as M4A", "m4a_Linux"}
end
menu[#menu+1]={"Render as Auphonic Multichannel", "Auphonic Multichannel"}

menu_entries=""

bounds_presets, bounds_names, options_format_presets, options_format_names, both_presets, both_names = ultraschall.GetRenderPreset_Names()

for i=1, #both_names do
  menu[#menu+1]={both_names[i], both_names[i]}
end

for i=1, #menu do
  if i==4 then insert=">Render using preset|" else insert="" end
  menu_entries=menu_entries..menu[i][1].."|"..insert
end


menu_entries=menu_entries:sub(1,-2)
X,Y=reaper.GetMousePosition()
_,_,X2,Y2=reaper.my_getViewport(0,0,0,0,0,0,0,0,true)
if Y>Y2-150 then Y=Y2-150 end
retval = ultraschall.ShowMenu("Render to File", menu_entries, X+15, Y)


if retval==-1 then return end
if retval==4 then reaper.Main_OnCommand(40296, 0) end

if retval>1 then
  RenderTable = ultraschall.GetRenderPreset_RenderTable(menu[retval][2], menu[retval][2])
  if RenderTable==nil then return end
  ultraschall.ApplyRenderTable_Project(RenderTable)
end

--SLEM()
reaper.Main_OnCommand(40015, 0)
