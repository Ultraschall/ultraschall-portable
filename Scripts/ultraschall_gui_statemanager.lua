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

-- little helpers
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")


function checkGuiStates()

  for i = 1, #GUIServices do

    commandid = reaper.NamedCommandLookup(GUIServices[i])
    gui_state = reaper.GetToggleCommandStateEx(0, commandid) -- aktueller Status des jeweiligen Buttons
    retval, project_state = reaper.GetProjExtState(0, "gui_statemanager", GUIServices[i]) -- lade den gespeicherten State aus der Projektdatei

    -- print(gui_state.."-gui:file-"..project_state)

    if project_state == "" then -- es wurde noch kein GUI-Status für dieses Elelemnt in die Projektdatei gespeichert
      reaper.SetProjExtState(0, "gui_statemanager", GUIServices[i], tostring(gui_state)) -- speichere den aktuellen GUI-Status in die Projektdatei
    elseif project_state ~= tostring(gui_state) then -- die states unterscheiden sich

      reaper.Main_OnCommand(commandid,0) -- stelle den GUI-State um so dass die Werte wieder stimmen

    end -- alles ok, states sind gleich also nichts zu tun

  end

 -------------------------------------------------
 -- Defer-Schleife
 -------------------------------------------------

  ultraschall.Defer(checkGuiStates, "Check GUI Defer", 2, 2) -- alle 2 Sekunden
	return "Check GUI Defer"

end

-- Settings

GUIServices = {
  "_Ultraschall_Toggle_Follow",
  "_Ultraschall_Toggle_Mouse_Selection"

}

checkGuiStates()

-- 	retval = ultraschall.StopDeferCycle("Check GUI Defer")
