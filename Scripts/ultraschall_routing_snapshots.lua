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


function Msg(val)
	reaper.ShowConsoleMsg(tostring(val).."\n")
end

function runcommand(cmd)	-- run a command by its name

	start_id = reaper.NamedCommandLookup(cmd)
	reaper.Main_OnCommand(start_id,0) 

end

function GetPath(str,sep)
 
    return str:match("(.*"..sep..")")

end

function saveSnapshot(slot)

	Msg("save")
	retval = reaper.SetProjExtState(0, "snapshots", slot, "testing")
	buildTable()

end

function clearSnapshot(slot)

	Msg("del")
	retval = reaper.SetProjExtState(0, "snapshots", slot, "")
	buildTable()

end

function recallSnapshot(slot)

	Msg("recall")

end


function buildTable()
	-- body

	GUI.elms = {
	

--     name          = element type          x      y    w    h     caption               ...other params...
	--logo			= GUI.Pic:new(			484,280, 80, 80, img_ratio, img_adress, runcommand, "_Ultraschall_Open_Project_Folder"),
	label           = GUI.Lbl:new(          120,  50+y_offset,  "Use routing snapshots to manage different recording situations.", 0),
	label2 			= GUI.Lbl:new(			110,  70+y_offset,	"These snapshots save and recall all information of the routing matrix:", 0),
	label3          = GUI.Lbl:new(          60,  130+y_offset,  "Preshow\n\n\n\nRecording\n\n\n\nAftershow\n\n\n\nEditing", 0),
	--label4          = GUI.Lbl:new(          30,  70+y_offset,               "Follow these simple steps:", 0),

	--chapters      	= GUI.Btn:new(          430, 185+y_offset, 190, 40,      "View Chapters", runcommand, "_SWSMARKERLIST1"),
	--metadata      	= GUI.Btn:new(          430, 250+y_offset, 190, 40,      "Edit ID3V2 Metadata", runcommand, "_Ultraschall_Edit_ID3_Tags"),
	-- image      		= GUI.Btn:new(          430, 315+y_offset, 190, 40,      "Open Project Folder", runcommand, "_Ultraschall_Open_Project_Folder"),
	--finalize      	= GUI.Btn:new(          430, 412+y_offset, 190, 40,      "Finalize MP3!", runcommand, "_ULTRASCHALL_INSERT_MP3_CHAPTER_MARKERS"),
}



	for i = 1,4 do

		if reaper.GetProjExtState(0, "snapshots", i) == 0 then
			GUI.elms[i+5]       = GUI.Lbl:new(          200, 36+(i*64),  			" free", 0)
			GUI.elms[i+10]      = GUI.Btn:new(          310, 29+(i*64), 130, 30,    " Save (Shift+F"..i..")", saveSnapshot, i)
		else
			GUI.elms[i+5]      	= GUI.Btn:new(          160, 29+(i*64), 130, 30,    " Recall (F"..i..")", recallSnapshot, i)
			GUI.elms[i+10]      = GUI.Btn:new(          310, 29+(i*64), 130, 30,    " Update (Shift+F"..i..")", saveSnapshot, i)
			GUI.elms[i+15]      = GUI.Btn:new(          460, 29+(i*64), 130, 30,    " Clear", clearSnapshot, i)
		end

	end





-- table.insert (GUI.elms, label)


end


-- initiate values

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

GUI.name = "Ultraschall Routing Snapshots"
GUI.w, GUI.h = 660, 440

-- position always in the centre of the screen

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2

y_offset = -30  -- move all content up/down





-- Msg(w .. "-" .. h)

	-- body
	---- GUI Elements ----


buildTable()



	---- Put all of your own functions and whatever here ----

--Msg("hallo")



	---- Main loop ----

--[[
	
	If you want to run a function during the update loop, use the variable GUI.func prior to
	starting GUI.Main() loop:
	
	GUI.func = my_function
	GUI.freq = 5     <-- How often in seconds to run the function, so we can avoid clogging up the CPU.
						- Will run once a second if no value is given.
						- Integers only, 0 will run every time.
	
	GUI.Init()
	GUI.Main()
	
]]--

-- local startscreen = GUI.val("checkers")
-- local startscreen = GUI.elms.checkers[GUI.Val()]

GUI.Init()
GUI.Main()
