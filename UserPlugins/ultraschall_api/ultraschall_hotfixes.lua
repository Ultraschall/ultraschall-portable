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

-- This is the file for hotfixes of buggy functions.

-- If you have found buggy functions, you can submit fixes within here.
--      a) copy the function you found buggy into ultraschall_hotfixes.lua
--      b) debug the function IN HERE(!)
--      c) comment, what you've changed(this is for me to find out, what you did)
--      d) add information to the <US_DocBloc>-bloc of the function. So if the information in the
--         <US_DocBloc> isn't correct anymore after your changes, rewrite it to fit better with your fixes
--      e) add as an additional comment in the function your name and a link to something you do(the latter, if you want), 
--         so I can credit you and your contribution properly
--      f) submit the file as PullRequest via Github: https://github.com/Ultraschall/Ultraschall-Api-for-Reaper.git (preferred !)
--         or send it via lspmp3@yahoo.de(only if you can't do it otherwise!)
--
-- As soon as these functions are in here, they can be used the usual way through the API. They overwrite the older buggy-ones.
--
-- These fixes, once I merged them into the master-branch, will become part of the current version of the Ultraschall-API, 
-- until the next version will be released. The next version will has them in the proper places added.
-- That way, you can help making it more stable without being dependent on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="28_April_2020"

--ultraschall.ShowLastErrorMessage()


function ultraschall.ApplyRenderTable_Project(RenderTable, apply_rendercfg_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyRenderTable_Project</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyRenderTable_Project(RenderTable RenderTable, optional boolean apply_rendercfg_string)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets all stored render-settings from a RenderTable as the current project-settings.
            
    Expected table is of the following structure:
            RenderTable["AddToProj"] - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
            RenderTable["Bounds"] - 0, Custom time range; 1, Entire project; 2, Time selection; 3, Project regions; 4, Selected Media Items(in combination with Source 32); 5, Selected regions
            RenderTable["Channels"] - the number of channels in the rendered file; 1, mono; 2, stereo; higher, the number of channels
            RenderTable["CloseAfterRender"] - true, close rendering to file-dialog after render; false, don't close it
            RenderTable["Dither"] - &1, dither master mix; &2, noise shaping master mix; &4, dither stems; &8, dither noise shaping stems
            RenderTable["EmbedStretchMarkers"] - Embed stretch markers/transient guides; true, checked; false, unchecked
            RenderTable["Endposition"] - the endposition of the rendering selection in seconds
            RenderTable["MultiChannelFiles"] - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
            RenderTable["OfflineOnlineRendering"] - Offline/Online rendering-dropdownlist; 0, Full-speed Offline; 1, 1x Offline; 2, Online Render; 3, Online Render(Idle); 4, Offline Render(Idle)
            RenderTable["OnlyMonoMedia"] - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
            RenderTable["ProjectSampleRateFXProcessing"] - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
            RenderTable["RenderFile"] - the contents of the Directory-inputbox of the Render to File-dialog
            RenderTable["RenderPattern"] - the render pattern as input into the File name-inputbox of the Render to File-dialog
            RenderTable["RenderQueueDelay"] - Delay queued render to allow samples to load-checkbox; true, checked; false, unchecked
            RenderTable["RenderQueueDelaySeconds"] - the amount of seconds for the render-queue-delay
            RenderTable["RenderResample"] - Resample mode-dropdownlist; 0, Medium (64pt Sinc); 1, Low (Linear Interpolation); 2, Lowest (Point Sampling); 3, Good (192pt Sinc); 4, Better (348 pt Sinc); 5, Fast (IIR + Linear Interpolation); 6, Fast (IIRx2 + Linear Interpolation); 7, Fast (16pt Sinc); 8, HQ (512 pt); 9, Extreme HQ(768pt HQ Sinc)
            RenderTable["RenderString"] - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
            RenderTable["RenderString2"] - the render-cfg-string, that holds all settings of the currently set secondary-render-output-format as BASE64 string
            RenderTable["RenderTable"]=true - signals, this is a valid render-table
            RenderTable["SampleRate"] - the samplerate of the rendered file(s)
            RenderTable["SaveCopyOfProject"] - the "Save copy of project to outfile.wav.RPP"-checkbox; true, checked; false, unchecked
            RenderTable["SilentlyIncrementFilename"] - Silently increment filenames to avoid overwriting-checkbox; true, checked; false, unchecked
            RenderTable["Source"] - 0, Master mix; 1, Master mix + stems; 3, Stems (selected tracks); 8, Region render matrix; 16, Tracks with only Mono-Media to Mono Files; 32, Selected media items; 64, selected media items via master; 128, selected tracks via master
            RenderTable["Startposition"] - the startposition of the rendering selection in seconds
            RenderTable["TailFlag"] - in which bounds is the Tail-checkbox checked? &1, custom time bounds; &2, entire project; &4, time selection; &8, all project regions; &16, selected media items; &32, selected project regions
            RenderTable["TailMS"] - the amount of milliseconds of the tail
            
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the render-settings was successful; false, it wasn't successful
  </retvals>
  <parameters>
    RenderTable RenderTable - a RenderTable, that contains all render-dialog-settings
    optional boolean apply_rendercfg_string - true or nil, apply it as well; false, don't apply it
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, set, project, rendertable</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "RenderTable", "not a valid RenderTable", -1) return false end
  if apply_rendercfg_string~=nil and type(apply_rendercfg_string)~="boolean" then ultraschall.AddErrorMessage("ApplyRenderTable_Project", "apply_rendercfg_string", "must be boolean", -2) return false end
  local _temp, retval, hwnd, AddToProj, ProjectSampleRateFXProcessing, ReaProject, SaveCopyOfProject, retval
  if ReaProject==nil then ReaProject=0 end
  
  if RenderTable["EmbedStretchMarkers"]==true then ultraschall.SetRender_EmbedStretchMarkers(true) else ultraschall.SetRender_EmbedStretchMarkers(false) end
  if RenderTable["MultiChannelFiles"]==true then RenderTable["Source"]=RenderTable["Source"]+4 end
  if RenderTable["OnlyMonoMedia"]==false then RenderTable["Source"]=RenderTable["Source"]+16 end
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SETTINGS", RenderTable["Source"], true)

  reaper.GetSetProjectInfo(ReaProject, "RENDER_BOUNDSFLAG", RenderTable["Bounds"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_CHANNELS", RenderTable["Channels"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_SRATE", RenderTable["SampleRate"], true)
  
  reaper.GetSetProjectInfo(ReaProject, "RENDER_STARTPOS", RenderTable["Startposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_ENDPOS", RenderTable["Endposition"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILFLAG", RenderTable["TailFlag"], true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_TAILMS", RenderTable["TailMS"], true)
  
  if RenderTable["AddToProj"]==true then AddToProj=1 else AddToProj=0 end
  --print2(AddToProj)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_ADDTOPROJ", AddToProj, true)
  reaper.GetSetProjectInfo(ReaProject, "RENDER_DITHER", RenderTable["Dither"], true)
  
  ultraschall.SetRender_ProjectSampleRateForMix(RenderTable["ProjectSampleRateFXProcessing"])
  ultraschall.SetRender_AutoIncrementFilename(RenderTable["SilentlyIncrementFilename"])
  ultraschall.SetRender_QueueDelay(RenderTable["RenderQueueDelay"], RenderTable["RenderQueueDelaySeconds"])
  ultraschall.SetRender_ResampleMode(RenderTable["RenderResample"])
  ultraschall.SetRender_OfflineOnlineMode(RenderTable["OfflineOnlineRendering"])
  
  if RenderTable["RenderFile"]==nil then RenderTable["RenderFile"]="" end
  if RenderTable["RenderPattern"]==nil then 
    local path, filename = ultraschall.GetPath(RenderTable["RenderFile"])
    if filename:match(".*(%.).")~=nil then
      RenderTable["RenderPattern"]=filename:match("(.*)%.")
      RenderTable["RenderFile"]=string.gsub(path,"\\\\", "\\")
    else
      RenderTable["RenderPattern"]=filename
      RenderTable["RenderFile"]=string.gsub(path,"\\\\", "\\")
    end
  end
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FILE", RenderTable["RenderFile"], true)
  reaper.GetSetProjectInfo_String(ReaProject, "RENDER_PATTERN", RenderTable["RenderPattern"], true)
  if apply_rendercfg_string~=false then
    reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT", RenderTable["RenderString"], true)
    reaper.GetSetProjectInfo_String(ReaProject, "RENDER_FORMAT2", RenderTable["RenderString2"], true)
  end
  
  if RenderTable["SaveCopyOfProject"]==true then SaveCopyOfProject=1 else SaveCopyOfProject=0 end
  hwnd = ultraschall.GetRenderToFileHWND()
  if hwnd==nil then
    retval = reaper.BR_Win32_WritePrivateProfileString("REAPER", "autosaveonrender2", SaveCopyOfProject, reaper.get_ini_file())
  else
    reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(hwnd,1060), "BM_SETCHECK", SaveCopyOfProject,0,0,0)
  end
  
  if reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)&1==0 and RenderTable["CloseAfterRender"]==true then
    local temp = reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)+1
    reaper.SNM_SetIntConfigVar("renderclosewhendone", temp)
  elseif reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)&1==1 and RenderTable["CloseAfterRender"]==false then
    local temp = reaper.SNM_GetIntConfigVar("renderclosewhendone",-199)-1
    reaper.SNM_SetIntConfigVar("renderclosewhendone", temp)
  end
  return true
end

function ultraschall.CountNormalMarkers_NumGap()
-- returns number of normal markers in the project
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountNormalMarkers_NumGap</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer number_normal_markers = ultraschall.CountNormalMarkers_NumGap()</functioncall>
  <description>
    Returns the first "gap" in shown marker-numbers. If you have markers with numbers "1, 2, 4" it will return 3, as this is the first number missing.
    
    Normal markers are all markers, that don't include "_Shownote:" or "_Edit" in the beginning of their name, as well as markers with the color 100,255,0(planned chapter).
  </description>
  <retvals>
    integer gap_number - the number of the first "gap" in the numbering of the shown marker-numbers
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, marker, count, gap, position</tags>
</US_DocBloc>
]]
  local nix=""
  local a,nummarkers,b=reaper.CountProjectMarkers(0)
  local count=0
  for b=1, nummarkers do
    for i=0, a do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color= reaper.EnumProjectMarkers3(0, i)
        if markrgnindexnumber==b then 
            count=b 
            nix="hui" 
            break
        end
    end
    if nix=="" then break end
    nix=""
  end

  return count+1
end  

function ultraschall.IsValidMediaItemStateChunkArray(MediaItemStateChunkArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidMediaItemStateChunkArray</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer count, array retMediaItemStateChunkArray = ultraschall.IsValidMediaItemStateChunkArray(array MediaItemStateChunkArray)</functioncall>
  <description>
    Checks, whether MediaItemStateChunkArray is valid.
    It throws out all entries, that are not MediaItemStateChunks and returns the altered array as result.
    
    returns false in case of an error or if it is not a valid MediaItemStateChunkArray
  </description>
  <parameters>
    array MediaItemStateChunkArray - a MediaItemStateChunkArray that shall be checked for validity
  </parameters>
  <retvals>
    boolean retval - returns true if MediaItemStateChunkArray is valid, false if not
    integer count - the number of entries in the returned retMediaItemStateChunkArray
    array retMediaItemStateChunkArray - the, possibly, altered MediaItemStateChunkArray
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitemmanagement, tracks, media, item, statechunk, chunk, check</tags>
</US_DocBloc>
]]
  ultraschall.SuppressErrorMessages(true)
  local retval, count, retMediaItemStateChunkArray = ultraschall.CheckMediaItemStateChunkArray(MediaItemStateChunkArray)
  ultraschall.SuppressErrorMessages(false)
  return retval, count, retMediaItemStateChunkArray
end

function ultraschall.IsTrackSoundboard(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTrackSoundboard</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsTrackSoundboard(integer tracknumber)</functioncall>
  <description>
    Returns, if this track is a soundboard-track, means, contains an Ultraschall-Soundboard-plugin.
    
    Only relevant in Ultraschall-installations
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, it is an Ultraschall-Soundboard-track; false, it is not
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber to check for; 0, for master-track; 1, for track 1; n for track n
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Track Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, isvalid, soundboard, track</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackSoundboard", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackSoundboard", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  local track
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    if reaper.TrackFX_GetByName(track, "Ultraschall: Soundboard", false)~=-1 or
      reaper.TrackFX_GetByName(track, "Soundboard (Ultraschall)", false)~=-1 then
      return true
    else
      return false
    end
  end
end

--A=ultraschall.IsTrackSoundboard(33)

function ultraschall.IsTrackStudioLink(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTrackStudioLink</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsTrackStudioLink(integer tracknumber)</functioncall>
  <description>
    Returns, if this track is a StudioLink-track, means, contains a StudioLink-Plugin
    
    Only relevant in Ultraschall-installations
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, it is a StudioLink-track; false, it is not
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber to check for; 0, for master-track; 1, for track 1; n for track n
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Track Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, isvalid, studiolink, track</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLink", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLink", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  local track
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    if reaper.TrackFX_GetByName(track, "StudioLink (IT-Service Sebastian Reimers)", false)~=-1 or
      reaper.TrackFX_GetByName(track, "ITSR: StudioLink", false)~=-1 then
      return true
    else
      return false
    end
  end
end

--A=ultraschall.IsTrackStudioLink(3)


function ultraschall.IsTrackStudioLinkOnAir(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTrackStudioLinkOnAir</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsTrackStudioLinkOnAir(integer tracknumber)</functioncall>
  <description>
    Returns, if this track is a StudioLinkOnAir-track, means, contains a StudioLinkOnAir-Plugin
    
    Only relevant in Ultraschall-installations
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, it is a StudioLinkOnAir-track; false, it is not
  </retvals>
  <parameters>
    integer tracknumber - the tracknumber to check for; 0, for master-track; 1, for track 1; n for track n
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Track Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, isvalid, studiolinkonair, track</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  local track
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    if reaper.TrackFX_GetByName(track, "StudioLinkOnAir (IT-Service Sebastian Reimers)", false)~=-1 or
      reaper.TrackFX_GetByName(track, "StudioLinkOnAir (ITSR)", false)~=-1 then
      return true
    else
      return false
    end
  end
end


function ultraschall.DeleteTracks_TrackString(trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteTracks_TrackString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteTracks_TrackString(string trackstring)</functioncall>
  <description>
    deletes all tracks in trackstring
    
    Returns false in case of an error
  </description>
  <parameters>
    string trackstring - a string with all tracknumbers, separated by commas
  </parameters>
  <retvals>
    boolean retval - true, setting it was successful; false, setting it was unsuccessful
  </retvals>
  <chapter_context>
    Track Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_TrackManagement_Module.lua</source_document>
  <tags>trackmanagement, delete, track, trackstring</tags>
</US_DocBloc>
]]
  local valid, count, individual_tracknumbers = ultraschall.IsValidTrackString(trackstring)
  if valid==false then ultraschall.AddErrorMessage("DeleteTracks_TrackString", "trackstring", "must be a valid trackstring", -1) return false end
  for i=count, 1, -1 do
    reaper.DeleteTrack(reaper.GetTrack(0,individual_tracknumbers[i]-1))
  end
  return true
end
