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

function set_slem_val()
    local num =  GUI.Val("ShowLastErrorMessage")
    reaper.SetExtState("ultraschall_api", "ShowLastErrorMessage_Target", num-1, true)
end

function set_ask_val()
    local num1 =  GUI.Val("DontAsk")
    if num1==2 then num1="true" else num1="false" end
    reaper.SetExtState("ultraschall_api", "dontask_developertools", num1, true)
end

function SwitchBeta()
  if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/beta.txt")==true then
    os.remove(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/beta.txt", "")  
    beta=false
    GUI.elms.Target3.caption="Beta Functions: "..tostring(beta)
  else
    ultraschall.WriteValueToFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/beta.txt", "")
    beta=true
    GUI.elms.Target3.caption="Beta Functions: "..tostring(beta)
  end
end


GUI.name = "Ultraschall API - settings"
GUI.x, GUI.y = 128, 128
GUI.w, GUI.h = 384, 396

-- target of show last error message
slem_target=tonumber(reaper.GetExtState("ultraschall_api", "ShowLastErrorMessage_Target"))
if slem_target==nil then slem_target=1 else slem_target=slem_target+1 end
GUI.New("ShowLastErrorMessage",   "Radio",     5, 20, 26, 160, 160, "   Show Last Error Message \n     default-output-target:", "Messagebox,ReaScript Console,Clipboard,Return-value-string", "v", 4)
GUI.New("Target", "Button",  1, 100,  150, 64, 24, "Set target", set_slem_val)
GUI.Val("ShowLastErrorMessage", slem_target)

-- don't show messages in some developer-tools
dontask=reaper.GetExtState("ultraschall_api", "dontask_developertools")
if dontask=="false" then dontask=0 else dontask=1 end
GUI.New("DontAsk",   "Radio",     6, 200,  26, 160, 95, "   Ask in Devtools?\n", "don't ask, ask", "v", 4)
GUI.Val("DontAsk", dontask+1)
GUI.New("Target2", "Button",  1, 280,  85, 64, 24, "Confirm", set_ask_val)

-- Allow Beta functions?
beta=reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/beta.txt")
if dontask==false then dontask=0 else dontask=1 end
GUI.New("Target3", "Button",  1, 220,  158, 140, 24, "Beta Functions: "..tostring(beta), SwitchBeta)

GUI.Init()
GUI.Main()



