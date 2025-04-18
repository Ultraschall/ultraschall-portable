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

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)

ID_1 = reaper.NamedCommandLookup("_Ultraschall_Set_View_Setup") -- Setup Button
ID_2 = reaper.NamedCommandLookup("_Ultraschall_Set_View_Record") -- Record Button
ID_3 = reaper.NamedCommandLookup("_Ultraschall_Set_View_Edit") -- Edit Button
ID_4 = reaper.NamedCommandLookup("_Ultraschall_Set_View_Story") -- Story Button

if state <= 0 then
	reaper.SetToggleCommandState(sec, cmd, 1)
end


ultraschall.SetUSExternalState("ultraschall_gui", "views", cmd)
ultraschall.SetUSExternalState("ultraschall_gui", "sec", sec)
ultraschall.SetUSExternalState("ultraschall_gui", "view", "setup")

reaper.SetToggleCommandState(sec, ID_2, 0)
reaper.SetToggleCommandState(sec, ID_3, 0)
reaper.SetToggleCommandState(sec, ID_4, 0)

reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_Set_View_Setup", 1)
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_Set_View_Record", 0)
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_Set_View_Edit", 0)
reaper.SetProjExtState(0, "gui_statemanager", "_Ultraschall_Set_View_Story", 0)


--reaper.RefreshToolbar2(sec, ID_1)
-- reaper.RefreshToolbar2(sec, ID_2)
-- reaper.RefreshToolbar2(sec, ID_3)
--reaper.RefreshToolbar2(sec, ID_4)

reaper.Main_OnCommand(40454,0)      --(re)load Screenset
runcommand("_Ultraschall_Clock")
runcommand("_Ultraschall_Clock")

-- Msg(cmd)
-- Msg(ID_2)

-- state = reaper.GetToggleCommandStateEx(sec, cmd)
-- SetToggleCommandState(sec, cmd, state<=0?1:0);
