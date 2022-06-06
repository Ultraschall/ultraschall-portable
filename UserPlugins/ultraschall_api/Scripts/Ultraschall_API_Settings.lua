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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

ultraschall.Lokasenna_LoadGuiLib_v2()

function set_slem_val()
    local num =  GUI.Val("ShowLastErrorMessage")
    reaper.SetExtState("ultraschall_api", "ShowLastErrorMessage_Target", num-1, true)
end

function set_ask_val()
    local num1 =  GUI.Val("DontAsk")
    if num1==2 then num1="true" else num1="false" end
    reaper.SetExtState("ultraschall_api", "dontask_developertools", num1, true)
end
A={ultraschall.GetApiVersion()}

function set_depr_val()
    local num1 =  GUI.Val("Deprecated")
--    print2(num1)
    reaper.SetExtState("ultraschall_api", "deprecated_script_checker_ask", num1, true)
end

GUI.name = "Ultraschall API - Settings"
GUI.x, GUI.y = 128, 128
GUI.w, GUI.h = 454, 396

-- target of show last error message
slem_target=tonumber(reaper.GetExtState("ultraschall_api", "ShowLastErrorMessage_Target"))
if slem_target==nil then slem_target=1 else slem_target=slem_target+1 end
GUI.New("ShowLastErrorMessage",   "Radio",     5, 20, 30, 160, 160, "   Show Last Error Message \n     default-output-target:", "Messagebox,ReaScript Console,Clipboard,Return-value-string", "v", 4)
GUI.New("Target", "Button",  1, 110,  156, 64, 24, "Set target", set_slem_val)
GUI.Val("ShowLastErrorMessage", slem_target)

-- don't show messages in some developer-tools
dontask=reaper.GetExtState("ultraschall_api", "dontask_developertools")
if dontask=="false" then dontask=0 else dontask=1 end
GUI.New("DontAsk",   "Radio", 6, 200,  30, 160, 95, "   Confirmdialogs\n   in Devtools?\n", "don't ask, ask", "v", 4)
GUI.Val("DontAsk", dontask+1)
GUI.New("Target2", "Button",  1, 290,  93,  64, 24, "Confirm", set_ask_val)

-- ask for subfolder-inclusion in deprecated-checker-script
deprecated_state=reaper.GetExtState("ultraschall_api", "deprecated_script_checker_ask")
deprecated_state=tonumber(deprecated_state)-1
GUI.New("Deprecated",   "Radio", 6, 20,  226, 160, 120, "Ask for Subfolder in\n Deprecated Checker?\n", "subfolder,no subfolder,ask", "v", 4)
GUI.Val("Deprecated", deprecated_state+1)
GUI.New("Target3", "Button",  1, 110,  315,  64, 24, "Set", set_depr_val)

GUI.New("Version", "Label", 1, 172, 360, "Ultraschall-API - "..A[1].." - Build: "..A[7])


GUI.Init()
GUI.Main()





