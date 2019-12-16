--[[
################################################################################
#
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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


defer_identifier = "hallo"

local function triggermagicrouting()

	-- prüft, ob eine Aktualisierung der Matrix notwendig ist. Dies ist der Fall wenn entweder
	-- A) Der MagicRouting Button gerade frisch gedrückt wurde (einmaliger Check) oder sich
	-- B) die Anzahl an Tracks im Projekt geändert hat

	local needsTrigger = false

	local currentCountTracks = reaper.CountTracks(0)
	local retval, lastCountTracks = reaper.GetProjExtState(0, "ultraschall_magicrouting", "lastCountTracks")
	local retval, override = reaper.GetProjExtState(0, "ultraschall_magicrouting", "override")

	-- local retval, deviceInfo = reaper.GetAudioDeviceInfo("IDENT_IN", "")
	-- print (deviceInfo)

	if override == "on" then  -- automatic was just started by pressing button
		needsTrigger = true
		reaper.SetProjExtState(0, "ultraschall_magicrouting", "override", "off") -- einmal Neuaufbau der Matrix reicht
		return needsTrigger

	elseif currentCountTracks == 0 then -- es gibt keine Tracks also kein Bedarf
		reaper.SetProjExtState(0, "ultraschall_magicrouting", "lastCountTracks", "0")
		return needsTrigger

	elseif currentCountTracks ~= tonumber(lastCountTracks) then -- es gibt mindestens eine neue Spur oder Spuren 	wurden gelöscht
		needsTrigger = true
		reaper.SetProjExtState(0, "ultraschall_magicrouting", "lastCountTracks", currentCountTracks)
		return needsTrigger

	else
		return needsTrigger

	end

end


local function checkrouting()

	if triggermagicrouting() then -- wird ein Update der Matrix wirklich benötigt?

		local retval, step = reaper.GetProjExtState(0, "ultraschall_magicrouting", "step")

		if step == "preshow" then
			commandid = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Preshow")
		elseif step == "editing" then -- editing
			commandid = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Editing")
		else -- recording
			commandid = reaper.NamedCommandLookup("_Ultraschall_set_Matrix_Recording")

		end
		-- print ("step: "..step)
		reaper.Main_OnCommand(commandid,0)         -- update Matrix

	end

  retval, defer_identifier = ultraschall.Defer1(checkrouting, 2, 1)
	return defer_identifier

end


is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)
-- print ("Buttonstate: "..state)

if state ~= 1 then
	-- Magicrouting on
	reaper.SetToggleCommandState(sec, cmd, 1)
	ultraschall.SetUSExternalState("ultraschall_magicrouting", "state", 1)


	reaper.SetProjExtState(0, "ultraschall_magicrouting", "override", "on")	-- automation was started so trigger at least one magicrouting

  defer_identifier = checkrouting()
  reaper.SetProjExtState(0, "ultraschall_magicrouting", "defer_identifier", defer_identifier)


else
	-- Magicrouting off
	reaper.SetToggleCommandState(sec, cmd, 0)
	ultraschall.SetUSExternalState("ultraschall_magicrouting", "state", 0)
	-- reaper.ShowConsoleMsg("Stop".."\n")

	retval, stop_defer_identifier = reaper.GetProjExtState(0, "ultraschall_magicrouting", "defer_identifier")
	retval = ultraschall.StopDeferCycle(stop_defer_identifier)
end
