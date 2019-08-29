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


function Msg(val)
	reaper.ShowConsoleMsg(tostring(val).."\n")
end

function runcommand(cmd)     -- run a command by its name

	start_id = reaper.NamedCommandLookup(cmd)
	reaper.Main_OnCommand(start_id,0) 

end

function GetPath(str,sep)
 
    return str:match("(.*"..sep..")")

end

-- initiate values

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

GUI.name = "Ultraschall Export Assistant"
GUI.w, GUI.h = 660, 440

-- position always in the centre of the screen

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2

y_offset = -30  -- move all content up/down

-- OS BASED SEPARATOR

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then     separator = "\\" else separator = "/" end

-- Check if project has been saved

retval, project_path_name = reaper.EnumProjects(-1, "")
if project_path_name ~= "" then
	dir = GetPath(project_path_name, separator)
	name = string.sub(project_path_name, string.len(dir) + 1)
	name = string.sub(name, 1, -5)
	name = name:gsub(dir, "")
end

-- lookup existing episode image

img_index = false

if dir then
	endings = {".jpg", ".jpeg", ".png"} -- prefer .png
	for key,value in pairs(endings) do 
		img_adress = dir .. "cover" .. value          -- does cover.xyz exist?
		img_test = gfx.loadimg(0, img_adress)
		if img_test ~= -1 then
			img_index = img_test
		end
	end
end

endings = {".jpg", ".jpeg", ".png"} -- prefer .png
for key,value in pairs(endings) do 
	img_adress = string.gsub(project_path_name, ".RPP", value)
	img_test = gfx.loadimg(0, img_adress)
	if img_test ~= -1 then
		img_index = img_test
	end
end

if img_index then     -- there is an image
	preview_size = 80      -- preview size in Pixel, always square
	w, h = gfx.getimgdim(img_index)
	if w > h then     -- adjust size to the longer border
		img_ratio = preview_size / w        
	else
		img_ratio = preview_size / h
	end
end

-- Msg(w .. "-" .. h)

	-- body
	---- GUI Elements ----
	

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then

	if img_index then     -- there is an episode-image

		GUI.elms = {
		
	--     name          = element type          x      y    w    h     caption               ...other params...
		logo               = GUI.Pic:new(               484,280, 80, 80, img_ratio, img_adress, runcommand, "_Ultraschall_Open_Project_Folder"),
		label           = GUI.Lbl:new(          50,  120+y_offset,               "Export MP3\nRender your Podcast to a MP3 File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image:\nFound.\n\n\n\n\nFinalize MP3\nHit the button and select your MP3 to finalize it\nwith metadata, chapters and episode image!", 0),
		label2          = GUI.Lbl:new(          30,  120+y_offset,               "1.\n\n\n\n2.\n\n\n\n3.\n\n\n\n4.\n\n\n\n\n\n5.", 0),
		label3          = GUI.Lbl:new(          30,  70+y_offset,               "Follow these simple steps:", 0),
		export           = GUI.Btn:new(          430, 120+y_offset, 190, 40,      "Export MP3", runcommand, "_Ultraschall_MP3_Render"),
		chapters           = GUI.Btn:new(          430, 185+y_offset, 190, 40,      "View Chapters", runcommand, "_SWSMARKERLIST1"),
		metadata           = GUI.Btn:new(          430, 250+y_offset, 190, 40,      "Edit ID3V2 Metadata", runcommand, "_Ultraschall_Edit_ID3_Tags"),
		-- image                = GUI.Btn:new(          430, 315+y_offset, 190, 40,      "Open Project Folder", runcommand, "_Ultraschall_Open_Project_Folder"),
		finalize           = GUI.Btn:new(          430, 412+y_offset, 190, 40,      "Finalize MP3!", runcommand, "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES"),
	}

	else

		GUI.elms = {
		
	--     name          = element type          x      y    w    h     caption               ...other params...
		-- logo               = GUI.Pic:new(               374,178, 0, 0, img_ratio, img_adress),
		label           = GUI.Lbl:new(          50,  120+y_offset,               "Export MP3\nRender your Podcast to a MP3 File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image\nJust put a square .jpg, .jpeg or .png image with the\nname 'cover.xyz' OR with the same name as your\nproject file (.RPP) in the project folder.\n\n\nFinalize MP3\nHit the button and select your MP3 to finalize it\nwith metadata, chapters and episode image!", 0),
		label2          = GUI.Lbl:new(          30,  120+y_offset,               "1.\n\n\n\n2.\n\n\n\n3.\n\n\n\n4.\n\n\n\n\n\n5.", 0),
		label3          = GUI.Lbl:new(          30,  70+y_offset,               "Follow these simple steps:", 0),
		export           = GUI.Btn:new(          430, 120+y_offset, 190, 40,      "Export MP3", runcommand, "_Ultraschall_MP3_Render"),
		chapters           = GUI.Btn:new(          430, 185+y_offset, 190, 40,      "View Chapters", runcommand, "_SWSMARKERLIST1"),
		metadata           = GUI.Btn:new(          430, 250+y_offset, 190, 40,      "Edit ID3V2 Metadata", runcommand, "_Ultraschall_Edit_ID3_Tags"),
		image                = GUI.Btn:new(          430, 315+y_offset, 190, 40,      "Open Project Folder", runcommand, "_Ultraschall_Open_Project_Folder"),
		finalize           = GUI.Btn:new(          430, 412+y_offset, 190, 40,      "Finalize MP3!", runcommand, "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES"),
	}

	end

else -- macOS

	if img_index then     -- there is an episode-image

		GUI.elms = {
		
	--     name          = element type          x      y    w    h     caption               ...other params...
		logo               = GUI.Pic:new(               484,280, 80, 80, img_ratio, img_adress, runcommand, "_Ultraschall_Open_Project_Folder"),
		label           = GUI.Lbl:new(          50,  120+y_offset,               "Export MP3/ m4a\nRender your Podcast to a MP3/ m4a File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image:\nFound.\n\n\n\n\nFinalize MP3/ m4a\nHit the button and select your MP3/ m4a to finalize it\nwith metadata, chapters and episode image!", 0),
		label2          = GUI.Lbl:new(          30,  120+y_offset,               "1.\n\n\n\n2.\n\n\n\n3.\n\n\n\n4.\n\n\n\n\n\n5.", 0),
		label3          = GUI.Lbl:new(          30,  70+y_offset,               "Follow these simple steps:", 0),
		export           = GUI.Btn:new(          430, 120+y_offset, 190, 40,      "Export MP3/ m4a", runcommand, "_Ultraschall_MP3_Render"),
		chapters           = GUI.Btn:new(          430, 185+y_offset, 190, 40,      "View Chapters", runcommand, "_SWSMARKERLIST1"),
		metadata           = GUI.Btn:new(          430, 250+y_offset, 190, 40,      "Edit ID3V2 Metadata", runcommand, "_Ultraschall_Edit_ID3_Tags"),
		-- image                = GUI.Btn:new(          430, 315+y_offset, 190, 40,      "Open Project Folder", runcommand, "_Ultraschall_Open_Project_Folder"),
		finalize           = GUI.Btn:new(          430, 412+y_offset, 190, 40,      "Finalize MP3/ m4a!", runcommand, "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES"),
	}

	else

		GUI.elms = {
		
	--     name          = element type          x      y    w    h     caption               ...other params...
		-- logo               = GUI.Pic:new(               374,178, 0, 0, img_ratio, img_adress),
		label           = GUI.Lbl:new(          50,  120+y_offset,               "Export MP3/ m4a\nRender your Podcast to a MP3/ m4a File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image\nJust put a square .jpg, .jpeg or .png image with the\nname 'cover.xyz' OR with the same name as your\nproject file (.RPP) in the project folder.\n\n\nFinalize MP3/ m4a\nHit the button and select your MP3/ m4a to finalize it\nwith metadata, chapters and episode image!", 0),
		label2          = GUI.Lbl:new(          30,  120+y_offset,               "1.\n\n\n\n2.\n\n\n\n3.\n\n\n\n4.\n\n\n\n\n\n5.", 0),
		label3          = GUI.Lbl:new(          30,  70+y_offset,               "Follow these simple steps:", 0),
		export           = GUI.Btn:new(          430, 120+y_offset, 190, 40,      "Export MP3/ m4a", runcommand, "_Ultraschall_MP3_Render"),
		chapters           = GUI.Btn:new(          430, 185+y_offset, 190, 40,      "View Chapters", runcommand, "_SWSMARKERLIST1"),
		metadata           = GUI.Btn:new(          430, 250+y_offset, 190, 40,      "Edit ID3V2 Metadata", runcommand, "_Ultraschall_Edit_ID3_Tags"),
		image                = GUI.Btn:new(          430, 315+y_offset, 190, 40,      "Open Project Folder", runcommand, "_Ultraschall_Open_Project_Folder"),
		finalize           = GUI.Btn:new(          430, 412+y_offset, 190, 40,      "Finalize MP3/ m4a!", runcommand, "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES"),
	}

	end
end

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

-- Open Export Assistant, when it hasn't been opened yet
    if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already). 
																	 -- If yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
    else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

    if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time. 
					   -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc
	 GUI.Init()
	 GUI.Main()
    end
