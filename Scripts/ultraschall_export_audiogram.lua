--[[
################################################################################
#
# Copyright (c) 2014-2023 Ultraschall (http://ultraschall.fm)
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


function GetPath(str,sep)
	return str:match("(.*"..sep..")")
end

function GetFileName(url)
	return url:match("^.+/(.+)$")
end

function GetFileExtension(url)
	return url:match("^.+(%..+)$")
end

function GetProjectPath()
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
  -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
    separator = "\\"
  else
  -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
    separator = "/"
  end
  retval, project_path_name = reaper.EnumProjects(-1, "")
  
  if project_path_name ~= "" then
    dir = project_path_name:match("(.*"..separator..")")
    name = string.sub(project_path_name, string.len(dir) + 1)
    name = string.sub(name, 1, -5)
    name = name:gsub(dir, "")
  end
  return dir
end

function checkImage()

	retval, project_path_name = reaper.EnumProjects(-1, "")
	if project_path_name ~= "" then
		dir = GetPath(project_path_name, separator)
		name = string.sub(project_path_name, string.len(dir) + 1)
		name = string.sub(name, 1, -5)
		name = name:gsub(dir, "")
	end

	-- lookup existing episode image

	img_index = false
	found = false

	if dir then
		endings = {".jpg", ".jpeg", ".png"} -- prefer .png
		for key,value in pairs(endings) do
			img_adress = dir .. "cover" .. value          -- does cover.xyz exist?
			img_test = gfx.loadimg(0, img_adress)
			if img_test ~= -1 then
				img_index = img_test
				img_location = img_adress
			end
		end
	end

	endings = {".jpg", ".jpeg", ".png"} -- prefer .png
	for key,value in pairs(endings) do
		img_adress = string.gsub(project_path_name, ".RPP", value)
		img_test = gfx.loadimg(0, img_adress)
		if img_test ~= -1 then
			img_index = img_test
			img_location = img_adress
		end
	end

	if img_index then     -- there is an image
		found = true
		preview_size = 80      -- preview size in Pixel, always square
		w, h = gfx.getimgdim(img_index)
		if w > h then     -- adjust size to the longer border
			img_ratio = preview_size / w
		else
			img_ratio = preview_size / h
		end
	end

	return found, img_location, img_ratio

end


function checkTimeSelection()
  -- Get the time selection bounds
  local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  
  -- If there's no time selection, the start and end times will be the same
  if startTime == endTime then
    reaper.ShowMessageBox("Please create a time selection!", "Missing Selection", 0)
    return false
  end
  
  -- If we want to ensure it's within the project bounds, we can check:
  local projectLength = reaper.GetProjectLength(0)  -- 0 denotes the current project

  if startTime < 0 or endTime > projectLength then
    reaper.ShowMessageBox("Time selection is out of project bounds!", "Selection Error", 0)
    return false
  end

  -- If everything's fine
  return true
end

function createTrackNamedAfterID3Title(templateName)
  -- Fetch the project's ID3 Title
  local retval, ID3Title = reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TIT2", false)
  
  if not retval or ID3Title == "" then
      ID3Title = " " -- Title is optional
  end

  -- Determine the number of tracks in the project
  local numTracks = reaper.CountTracks(0)

  -- Insert a new track at the bottom
  
	-- reaper.InsertTrackAtIndex(numTracks, true)

-- Get the REAPER resource path
	local reaperResourcePath = reaper.GetResourcePath()

	-- Construct the path to the track template named "test"
	local trackTemplatePath = reaperResourcePath .. "/TrackTemplates/".. templateName

-- Check if the track template exists
	if reaper.file_exists(trackTemplatePath) then
			-- Insert the track template into the current project
			reaper.Main_openProject(trackTemplatePath)

		
		-- Get the new track
		local newTrack = reaper.GetTrack(0, numTracks)

		-- Name the new track with the ID3 Title
		reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", ID3Title, true)
	end
end


function insertImageToTimeline(img_location, track, startTime, endTime)
	if not img_location or not track or not startTime or not endTime then
			reaper.ShowMessageBox("Missing data to insert the image to timeline.", "Error", 0)
			return
	end

	-- Move edit cursor to the start of the time selection
	reaper.SetEditCurPos(startTime, false, false)

	-- Set the track to be the only selected track
	reaper.SetOnlyTrackSelected(track)

	-- Insert the media (image) at the edit cursor position on the selected track
	local retval = reaper.InsertMedia(img_location, 0) -- 0 means "Add the media to the current track"
	
	if retval and retval ~= 0 then
			local itemIndex = reaper.GetTrackNumMediaItems(track) - 1 -- zero-based index
			local mediaItem = reaper.GetTrackMediaItem(track, itemIndex)

			if mediaItem then
					-- Adjust the media item's position and length to match the time selection
					reaper.SetMediaItemInfo_Value(mediaItem, "D_POSITION", startTime)
					reaper.SetMediaItemInfo_Value(mediaItem, "D_LENGTH", endTime - startTime)
					
					-- Enable the "loop source" property for the media item
					reaper.SetMediaItemInfo_Value(mediaItem, "B_LOOPSRC", 1)
					
					-- Optional: refresh the REAPER UI
					reaper.UpdateArrange()
			else
					reaper.ShowMessageBox("Failed to retrieve the inserted image from the track.", "Error", 0)
			end
	else
			reaper.ShowMessageBox("Failed to insert the image into the timeline.", "Error", 0)
	end
end


function createAudigramTrack(trackTemplateName)

	if checkTimeSelection() then 
		local found, img_location, img_ratio = checkImage()
		if found then
				createTrackNamedAfterID3Title(trackTemplateName)
				-- Get the time selection bounds (you've done this previously in the checkTimeSelection function, so it might be more efficient to return these values from there)
				local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
				local newTrack = reaper.GetTrack(0, reaper.CountTracks(0) - 1)  -- Get the last track, which should be the newly created one
				insertImageToTimeline(img_location, newTrack, startTime-1, endTime) -- 1 second offset to prevent a dark screen at the beginning
		end
	else
		return false
	end
end


function renderAudiogramMac()

	-- 1) RenderTable für die Render Settings erzeugen
	RenderTable = ultraschall.CreateNewRenderTable()

	-- 2) RenderTable anpassen

	-- setzt bounds auf time-selection
	RenderTable["Bounds"] = 2
	RenderTable["Source"] = 0 -- Master mix; 

	-- setz Path und Filename
	RenderTable["RenderFile"] = GetProjectPath()
	RenderTable["RenderPattern"] = "Audiogram"

	-- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
	-- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
	-- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)

	vid_kbps = 1024
	aud_kbps = 128
	width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
	if width == 0 then width = 1024 end -- default width
	height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
	if height == 0 then height = 1024 end -- default height
	fps=20
	aspect_ratio = true
--       VideoCodec = 1 -- VP8
--       AudioCodec = 1 -- Vorbis

	RenderTable["RenderString"] = ultraschall.CreateRenderCFG_MP4MAC_Video(true, vid_kbps, aud_kbps, width, height, fps, aspect_ratio)

	-- 3) Render the File


	count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, true)

	-- print (count)

end

function renderAudiogramPC()

	-- 1) RenderTable für die Render Settings erzeugen
	RenderTable=ultraschall.CreateNewRenderTable()

	-- 2) RenderTable anpassen

	-- setz bounds auf time-selection
	RenderTable["Bounds"]=2

	-- setz Path und Filename
	RenderTable["RenderFile"] = GetProjectPath()
	RenderTable["RenderPattern"] = "Audiogram"
	-- print (RenderTable["FadeOut_Shape"])

	-- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
	-- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
	-- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)
	vid_kbps=1024
	aud_kbps=128
	width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
	if width==0 then width=1920 end -- default width
	height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
	if height==0 then height=1080 end -- default height
	fps=20.00
	aspect_ratio=true
	VideoCodec=0 -- MP4
	AudioCodec=0 -- AAC
 
	RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WMF (0, 0, vid_kbps, 0, aud_kbps, width, height, fps, aspect_ratio)
	-- RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WMF(vid_kbps, aud_kbps, width, height, 60, aspect_ratio, VideoCodec, AudioCodec)
	--RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WebM_Video(vid_kbps, aud_kbps, width, height, fps, true, 1, 1, "crf=23", "")

	-- 3) Render the File
	
	count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, false)
end

function renderAudiogramLinux()

	-- 1) RenderTable für die Render Settings erzeugen
	RenderTable=ultraschall.CreateNewRenderTable()

	-- 2) RenderTable anpassen

	-- setz bounds auf time-selection
	RenderTable["Bounds"]=2

	-- setz Path und Filename
	RenderTable["RenderFile"] = GetProjectPath()
	RenderTable["RenderPattern"] = "Audiogram"
	-- print (RenderTable["FadeOut_Shape"])

	-- setz video-format-settings für webm-video(all platforms) und erstelle renderformat-string
	-- (für Windows mp4 gibts auch noch CreateRenderCFG_WMF() )
	-- (für Mac mp4 gibts auch noch CreateRenderCFG_MP4MAC_Video)
	vid_kbps=1024
	aud_kbps=128
	width=math.tointeger(reaper.SNM_GetIntConfigVar("projvidw", -1))
	if width==0 then width=1920 end -- default width
	height=math.tointeger(reaper.SNM_GetIntConfigVar("projvidh", -1))
	if height==0 then height=1080 end -- default height
	fps=20.00
	aspect_ratio=true
	VideoCodec=0 -- MP4
	AudioCodec=0 -- 

	
	--RenderTable["RenderString"] = ultraschall.CreateRenderCFG_WebM_Video(vid_kbps, aud_kbps, width, height, fps, true, 1, 1, "crf=23", "")
	RenderTable["RenderString"] = ultraschall.CreateRenderCFG_QTMOVMP4_Video(2, 100, 5, width, height, fps, aspect_ratio, vid_kbps, aud_kpbs, "crf=23", "")

	-- 3) Render the File       
	count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(nil, RenderTable, false, true, false)
	
end

function setVideoFXonMaster()
	-- get the FXStateChunk
	retval, TrackStateChunk = ultraschall.GetTrackStateChunk_Tracknumber(0)
	if retval==false then 
			print2("An error has happened: No track available") 
			return 
	end
	FXStateChunk = ultraschall.GetFXStateChunk(TrackStateChunk)
	FXStateChunkChain = ultraschall.LoadFXStateChunkFromRFXChainFile("Ultraschall_Audiogram_Master.RfxChain", 0)
	
	retval, alteredStateChunk = ultraschall.SetFXStateChunk(TrackStateChunk, FXStateChunkChain)
	
	print (alteredStateChunk)
	
	retval = ultraschall.SetTrackStateChunk_Tracknumber(0, alteredStateChunk, true)

end


function setAudiogramFX()

	VideoCode1=[[//Ultraschall Audiogram Waveform
//@gmem=jsfx_to_video
//@param 1:mode "mode" 0 0 2 0 1
//@param 2:dotcount "point count" 2390 10 5000 400 10
//@param 3:dotsize "point size" 5 2 40 20 1
//@param 4:gain_db "gain (dB)" -34 -80 12 -12 1
//@param 5:zoom_amt "blitter zoom" -.01 -.5 1 .1 0.01
//@param 6:fadespeed "blitter persist" .81 0 1 .1 0.01
//@param 7:filter "blitter filter" 0 0 1 0 1
//@param 8:fg_r "foreground R" 1 0 1 .5 .02
//@param 9:fg_g "foreground G" 1 0 1 .5 .02
//@param 10:fg_b "foreground B" 1 0 1 .5 .02
//@param 11:bg_r "background R" 0 0 1 .5 .02
//@param 12:bg_g "background G" 0 0 1 .5 .02
//@param 13:bg_b "background B" 0 0 1 .5 .02
//@param 14:cx "center X" .5 0 1 .5 .01
//@param 15:cy "center Y" .89 0 1 .5 .01

last_frame && fadespeed > 0 ? (
  xo = project_w*zoom_amt*.25;
  yo = project_h*zoom_amt*.25;
  gfx_mode=filter>0?0x100:0;
  xo < 0 ? gfx_blit(last_frame,0);
  gfx_blit(last_frame,0,0,0,project_w,project_h,xo,yo,project_w-xo*2,project_h-yo*2);
);
gfx_set(bg_r,bg_g,bg_b,last_frame ? (1-fadespeed) : 1);
gfx_a>.001 ? gfx_fillrect(0,0,project_w,project_h);

bufplaypos = gmem[0];
bufwritecursor = gmem[1];
bufsrate = gmem[2];
bufstart = gmem[3];
bufend = gmem[4];
nch = gmem[5];
gain = 10^(gain_db*(1/20));

dt=max(bufplaypos - project_time,0);
dt*bufsrate < dotcount ? underrun_cnt+=1;
rdpos = bufwritecursor - ((dt*bufsrate - dotcount)|0)*nch;
rdpos < bufstart ? rdpos += bufend-bufstart;

gfx_set(fg_r,fg_g,fg_b,1);

function getpt()
(
  l = gmem[rdpos]; r = gmem[rdpos+1];
  (rdpos += nch)>=bufend ? rdpos=bufstart;
);
i=0;

mode==2 ? (
  loop(dotcount,
    getpt();
    ang = atan2(l,r); dist = sqrt(sqr(l)+sqr(r));
    xp = cx*project_w + ((cos(ang)*dist*gain)*project_h-dotsize)*.5;
    yp = ((cy*2+sin(ang)*dist*gain)*project_h-dotsize)*.5;
    gfx_fillrect(xp,yp, dotsize,dotsize);
  );
) : mode == 1 ? (
  loop(dotcount,
    getpt();
    yp = project_h * (cy - .5 + i / dotcount);
    xp = project_w * (cx + (l+r)*.25*gain);
    gfx_fillrect(xp-dotsize*.5,yp-dotsize*.5, dotsize,dotsize);
    i+=1;
  );

) : (
  loop(dotcount,
    getpt();
    xp = project_w * (cx - 0.5 + i / dotcount);
    yp = project_h * (cy + (l+r)*.25*gain);
    gfx_fillrect(xp-dotsize*.5,yp-r*200-dotsize*.5, dotsize, r*400+dotsize*0.5);
    i+=1;
  );
);

gfx_img_free(last_frame);
last_frame=gfx_img_hold(-1);]]

VideoCode2=[[// Remove Black
// black is removed. use after inverting color
img1=0;
img2=input_track(0);
gfx_blit(img2);
gfx_mode = 1;
gfx_blit(img1,0);]]

	
	reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "video_sample_peeker", false, -1)
	
	master_fx_count=reaper.TrackFX_GetCount(reaper.GetMasterTrack(0))
	reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "Video processor", false, -1)
	reaper.TrackFX_SetNamedConfigParm(reaper.GetMasterTrack(0), master_fx_count, "VIDEO_CODE", VideoCode1)

	master_fx_count=reaper.TrackFX_GetCount(reaper.GetMasterTrack(0))
	reaper.TrackFX_AddByName(reaper.GetMasterTrack(0), "Video processor", false, -1)
	reaper.TrackFX_SetNamedConfigParm(reaper.GetMasterTrack(0), master_fx_count, "VIDEO_CODE", VideoCode2)
	

end



-- Main

-- Start the Undo Block
reaper.Undo_BeginBlock()

reaper.SNM_SetIntConfigVar("projvidh", 1024) 
reaper.SNM_SetIntConfigVar("projvidw", 1024) 
enableResize = reaper.SNM_SetIntConfigVar("projvidflags", reaper.SNM_GetIntConfigVar("projvidflags", -666) | 512)


-- width = reaper.SNM_GetIntConfigVar("projvidw",1) 
-- print (width)


-- ProjectStateChunk = ultraschall.GetProjectStateChunk()

-- set Video resolution to 1024x1024

-- local retval = ultraschall.SetProject_VideoConfig(nil, 1024, 1024, 0, ProjectStateChunk)

  -- Check the return value and notify the user
-- if retval == -1 then
--              reaper.ShowMessageBox("Failed to set the preferred video size. Please ensure you have the latest Ultraschall API installed.", "Error", 0)
-- end

-- setVideoFXonMaster()
if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then separator = "\\" else separator = "/" end

if createAudigramTrack("Insert AudiogramFG track.RTrackTemplate")==false then return end
setAudiogramFX()

createAudigramTrack("Insert AudiogramBG track.RTrackTemplate")

	
-- Duplicate the track using REAPER's action: "Track: Duplicate tracks"
-- reaper.Main_OnCommand(40062, 0)

if ultraschall.IsOS_Windows()==true then
	renderAudiogramPC()
elseif ultraschall.IsOS_Mac()==true then
	renderAudiogramMac()
else
	renderAudiogramLinux()
end 

-- End the Undo Block with a description

reaper.Undo_EndBlock("Added and configured track with episode image", -1)

if count>0 then
	state=reaper.MB("Do you want to open up the project-folder, that holds the Audiogram?", "Audiogram", 4)
	if state==6 then
	    ultraschall.RunCommand("_Ultraschall_Open_Project_Folder")
	end
end

-- undo everything: an easy way to reset, leaving just the rendered video:

reaper.Main_OnCommand(40029, 0)
-- reaper.Main_OnCommand(40029, 0)
-- SFEM() 
