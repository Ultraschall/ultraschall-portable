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


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

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

local function splitWords(Lines, limit)
  while #Lines[#Lines] > limit do
          Lines[#Lines+1] = Lines[#Lines]:sub(limit+1)
          Lines[#Lines-1] = Lines[#Lines-1]:sub(1,limit)
  end
end


local function wrap(str, limit)
  local Lines, here, limit, found = {}, 1, limit or 72, str:find("(%s+)()(%S+)()")

  if found then
          Lines[1] = string.sub(str,1,found-1)  -- Put the first word of the string in the first index of the table.
  else Lines[1] = str end

  str:gsub("(%s+)()(%S+)()",
          function(sp, st, word, fi)  -- Function gets called once for every space found.
                  splitWords(Lines, limit)

                  if fi-here > limit then
                          here = st
                          Lines[#Lines+1] = word                                                                                   -- If at the end of a line, start a new table index...
                  else Lines[#Lines] = Lines[#Lines].." "..word end  -- ... otherwise add to the current table index.
          end)

  splitWords(Lines, limit)

  return Lines
end


function buildExportStep()

	local infotable = wrap(StepDescription,60) -- Zeilenumbruch 80 Zeichen für Warnungsbeschreibung



	local light = GUI.Area:new(48,position-5,10,21,3,1,1,state_color)
	table.insert(GUI.elms, light)

	local statusbutton = GUI.Btn:new(65, position-4, 0, 20,         status_txt, "")
	table.insert(GUI.elms, statusbutton)



	local block = GUI.Area:new(210,position-10,752, areaHeight,5,1,1,"section_bg")
	table.insert(GUI.elms, block)

	local heading = GUI.Lbl:new(220, position-2, StepNameDisplay, 0, "txt", 2)
	table.insert(GUI.elms, heading)

	for k, warningtextline in pairs(infotable) do

		local infotext = GUI.Lbl:new(220, warnings_position, warningtextline, 0, "txt_grey")
		table.insert(GUI.elms, infotext)
		warnings_position = warnings_position +20

		-- print(k, v)
	end

	local ButtonPosition = position + (areaHeight*0.5) - 83

	local button_offset = 25
	local button1 = GUI.Btn:new(790, ButtonPosition+40+button_offset, 144, 20,  button_txt, runcommand, button_action)
	table.insert(GUI.elms, button1)

end



-- initiate values

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")
gfx_path = script_path.."/Ultraschall_Gfx/Soundcheck/"
header_path = script_path.."/Ultraschall_Gfx/Headers/"



GUI.name = "Ultraschall Export Assistant"
GUI.w, GUI.h = 1000, 700

-- position always in the centre of the screen

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2

y_offset = -30  -- move all content up/down

-- OS BASED SEPARATOR

if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then     separator = "\\" else separator = "/" end

-- Check if project has been saved

function buildGUI()


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



		---- GUI Elements ----


	-- if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then

	--      if img_index then     -- there is an episode-image

	GUI.elms = {}


	y_offset = 50  -- move all content up/down
	spacing = 10

	------------------
  ------- Header
	------------------

  header = GUI.Area:new(0,0,1000,90,0,1,1,"header_bg")
  table.insert(GUI.elms, header)

  logo = GUI.Pic:new(          45,  25,   0,  0,    1,   header_path.."export_logo.png")
  table.insert(GUI.elms, logo)

  headertxt = GUI.Pic:new(          115,  36,   0,  0,    0.8,   header_path.."headertxt_export.png")
  table.insert(GUI.elms, headertxt)




	-- Heading

--	label3 = GUI.Lbl:new(30,  70+y_offset,"Follow these simple steps:", 0)
--	table.insert (GUI.elms, label3)

	-- 1. Export MP3


	filecount, files = ultraschall.GetAllFilenamesInPath(dir)

	state_color = "txt_red"
	status_txt = " no MP3 found"

	for i=1, filecount do
		if ( string.sub( files[i], -3 ) ) == "mp3" then
			state_color = "txt_yellow"
			status_txt = " unknown MP3 found"

		end
	end

	areaHeight = 80
	position = 90 + y_offset
	StepNameDisplay = "1. Export MP3"
	StepDescription = "Render your Podcast to a MP3 File. Make use of our prests in the top right corner of the render-dialog."
	warnings_position = position+30
	button_txt = "Export MP3"
	button_action = "_Ultraschall_Render_Check"

	buildExportStep()


	-- 2. Chapter Markers


	areaHeight = 90
	position = 190 + y_offset
	StepNameDisplay = "2. Chapter Markers"
	state_color = "txt_green"
	StepDescription = "You may take a final look at your chapter markers, and add URLs or images to them."
	warnings_position = position+30
	button_txt = "Edit Chapters"
	button_action = "_Ultraschall_Marker_Dashboard"
	status_txt = " OK"

	buildExportStep()


	-- 3. ID3 Metadata

	areaHeight = 70
	position = 300 + y_offset
	StepNameDisplay = "3. ID3 Metadata"
	state_color = "txt_yellow"
	status_txt = " Missing Metadata"
	StepDescription = "Use the ID3 Editor to add metadata to your podcast."
	warnings_position = position+30
	button_txt = "Edit MP3 Metadata"
	button_action = "_Ultraschall_Edit_ID3_Tags"

	buildExportStep()


	-- 4. - Image


	changed, num_dropped_files, dropped_files, drop_mouseposition_x, drop_mouseposition_y = ultraschall.GFX_GetDropFile()
	if num_dropped_files > 0 then
		-- print ("da: "..dropped_files[1])
	else
		-- print ("nix"..tostring(changed))
	end



	areaHeight = 100
	position = 390 + y_offset
	StepNameDisplay = "4. Podcast Episode Image"
	state_color = "txt_green"
	status_txt = " Found"
	StepDescription = "Just put a square .jpg, .jpeg or .png image with the name 'cover.xyz' OR with the same name as your project file (.RPP) in the project folder."
	warnings_position = position+30
	button_txt = "Drag Image here"
	button_action = ""

	buildExportStep()

	-- 5. Finalize

	areaHeight = 100
	position = 510 + y_offset
	StepNameDisplay = "5. Finalize MP3"
	state_color = "txt_yellow"
	status_txt = " Ready to finalize"
	StepDescription = "Hit the button and select your MP3 to finalize it with metadata, chapters and episode image!"
	warnings_position = position+30
	button_txt = "Finalize MP3!"
	button_action = "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES"

	buildExportStep()

--[[





	label2 = GUI.Lbl:new(30,  412+y_offset,"5.", 0)
	table.insert (GUI.elms, label2)
	label = GUI.Lbl:new(50,  412+y_offset,"Finalize MP3\nHit the button and select your MP3 to finalize it\nwith metadata, chapters and episode image!", 0)
	table.insert (GUI.elms, label)
	finalize = GUI.Btn:new(430, 412+y_offset, 190, 40,      "Finalize MP3!", runcommand, "_ULTRASCHALL_INSERT_MEDIA_PROPERTIES")
	table.insert (GUI.elms, finalize)

  ]]


end



-- Open Export Assistant, when it hasn't been opened yet

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).
																-- If yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
					   -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

	GUI.func = buildGUI
	GUI.freq = 2     -- How often in seconds to run the function, so we can avoid clogging up the CPU.

	 buildGUI()
	 GUI.Init()
	 GUI.Main()
end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)
