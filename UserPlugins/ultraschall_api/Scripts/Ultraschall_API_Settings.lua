--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

ultraschall.Lokasenna_LoadGuiLib_v2()

function set_track_name()

    local num =  GUI.Val("ShowLastErrorMessage")

    -- Do something with that information. Presumably renaming a track.
    reaper.SetExtState("ultraschall_api", "ShowLastErrorMessage_Target", num-1, true)
end

slem_target=tonumber(reaper.GetExtState("ultraschall_api", "ShowLastErrorMessage_Target"))+1
if slem_target==nil then slem_target=1 end

GUI.name = "Ultraschall API - settings"
GUI.x, GUI.y = 128, 128
GUI.w, GUI.h = 384, 396

GUI.New("ShowLastErrorMessage",   "Radio",     5, 20, 26, 160, 160, "   Show Last Error Message \n     default-output-target:", "Messagebox,ReaScript Console,Clipboard,Return-value-string", "v", 4)
GUI.New("my_button", "Button",  1, 100,  150, 64, 24, "Set target", set_track_name)
GUI.Val("ShowLastErrorMessage", slem_target)

GUI.Init()
GUI.Main()



