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
ultraschall.hotfixdate="10_Jul_2020"

--ultraschall.ShowLastErrorMessage()

function ultraschall.RenderProject(projectfilename_with_path, renderfilename_with_path, startposition, endposition, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg, rendercfg2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    SWS=2.10.0.1
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject(string projectfilename_with_path, string renderfilename_with_path, number startposition, number endposition, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, optional string rendercfg, optional string rendercfg2)</functioncall>
  <description>
    Renders a project, using a specific render-cfg-string.
    To get render-cfg-strings, see functions starting with CreateRenderCFG_, like <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, etc.
    
    Will use the render-settings currently set in projectfilename_with_path/the currently active project, except bound(set to Custom time range), render file and render-pattern, as they are set by this function!
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems+master)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems+master)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project
    string renderfilename_with_path - the filename with path of the output-file. If you give the wrong extension, Reaper will exchange it by the correct one.
                                    - You can use wildcards to some extend in the actual filename(not the path!)
                                    - note: parameter overwrite_without_asking only works, when you give the right extension and use no wildcards, due API-limitations!
    number startposition - the startposition of the render-area in seconds; 
                         - -1, to use the startposition set in the projectfile itself; 
                         - -2, to use the start of the time-selection
    number endposition - the endposition of the render-area in seconds; 
                       - -1, to use the endposition set in the projectfile/current project itself
                       - -2, to use the end of the time-selection
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
                                     - works only, when renderfilename_with_path has the right extension given and when not using wildcards(due API-limitations)!
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    optional string rendercfg - the rendercfg-string, that contains all render-settings for an output-format
                              - To get render-cfg-strings, see CreateRenderCFG_xxx-functions, like: <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                              - 
                              - If you want to render the current project, you can use a four-letter-version of the render-string; will use the default settings for that format. Not available with projectfiles!
                              - "evaw" for wave, "ffia" for aiff, " iso" for audio-cd, " pdd" for ddp, "calf" for flac, "l3pm" for mp3, "vggo" for ogg, "SggO" for Opus, "PMFF" for FFMpeg-video, "FVAX" for MP4Video/Audio on Mac, " FIG" for Gif, " FCL" for LCF, "kpvw" for wavepack 
    optional string rendercfg2 - just like rendercfg, but for the secondary render-format
  </parameters>
  <chapter_context>
    Rendering Projects
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, render, output, file</tags>
</US_DocBloc>
]]
  -- preparing variables
  local RenderTable
  local retval, path, filename, count, timesel1_end, timesel1_start, start_sel, end_sel, temp
  
  -- check parameters
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RenderProject", "startposition", "Must be a number in seconds.", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be a number in seconds.", -2) return -1 end
  if startposition>=0 and endposition>0 and endposition<=startposition then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than startposition.", -3) return -1 end
  if endposition<-2 then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than 0 or -1(to retain project-file's endposition).", -4) return -1 end
  if startposition<-2 then ultraschall.AddErrorMessage("RenderProject", "startposition", "Must be bigger than 0 or -1(to retain project-file's startposition).", -5) return -1 end
  
  if projectfilename_with_path~=nil then
    if type(projectfilename_with_path)~="string" or reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject", "projectfilename_with_path", "File does not exist.", -6) return -1 end
    local length, content = ultraschall.ReadBinaryFile_Offset(projectfilename_with_path, 0, 16)
    if content~="<REAPER_PROJECT " then ultraschall.AddErrorMessage("RenderProject", "projectfilename_with_path", "no rpp-projectfile", -19) return -1 end
  end
  if type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject", "renderfilename_with_path", "Must be a string.", -7) return -1 end  
  if rendercfg==nil or (ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg)=="Unknown") then ultraschall.AddErrorMessage("RenderProject", "rendercfg", "No valid render_cfg-string.", -9) return -1 end
  if rendercfg2==nil then rendercfg2=""
  elseif rendercfg2~=nil and (ultraschall.GetOutputFormat_RenderCfg(rendercfg2)==nil or ultraschall.GetOutputFormat_RenderCfg(rendercfg2)=="Unknown") then 
    ultraschall.AddErrorMessage("RenderProject", "rendercfg2", "No valid render_cfg-string.", -18) 
    return -1 
  end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "overwrite_without_asking", "Must be boolean", -10) return -1 end
  if filenameincrease~=nil and type(filenameincrease)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "filenameincrease", "Must be either nil or boolean", -13) return -1 end
  if renderclosewhendone~=nil and type(renderclosewhendone)~="boolean" then ultraschall.AddErrorMessage("RenderProject", "renderclosewhendone", "Must be either nil or a boolean", -12) return -1 end

  if RenderTable~=nil and ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("RenderProject", "RenderTable", "Must be either nil or a valid RenderTable", -15) return -1 end


  -- split renderfilename into path and filename, as we need this for render-pattern and render-file-entries
  if renderfilename_with_path~=nil then 
    path, filename = ultraschall.GetPath(renderfilename_with_path)
  end
  if path==nil then path="" end
  if filename==nil then filename="" end
  
  if projectfilename_with_path==nil then
  -- if rendering the current active project

    -- get rendercfg from current project, if not already given
    if rendercfg==nil then temp, rendercfg = reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "", false) end 
    if rendercfg2==nil then temp, rendercfg2 = reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT2", "", false) end 
    -- get rendersettings from current project
    RenderTable=ultraschall.GetRenderTable_Project()

    -- set the start and endposition according to settings (-1 for projectlength, -2 for time/loop-selection)
    start_sel, end_sel = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    if startposition==-1 then startposition=0
    elseif startposition==-2 then startposition=start_sel
    end
    if endposition==-1 then endposition=reaper.GetProjectLength(0)
    elseif endposition==-2 then endposition=end_sel
    end
  else
  -- if rendering an rpp-projectfile
    -- get rendercfg from projectfile, if not already given
    if rendercfg==nil then ultraschall.GetProject_RenderCFG(projectfilename_with_path) end
    
    -- get rendersettings from projectfile
    RenderTable=ultraschall.GetRenderTable_ProjectFile(projectfilename_with_path)
    
    -- set the start and endposition according to settings (-1 for projectlength, -2 for time/loop-selection)
    timesel1_start, timesel1_end = ultraschall.GetProject_Selection(projectfilename_with_path)    
    if timesel1_start>timesel1_end then timesel1_start, timesel1_end = timesel1_end, timesel1_start end
    if startposition==-1 then startposition=0
    elseif startposition==-2 then startposition=timesel1_start
    end
    if endposition==-1 then endposition=ultraschall.GetProject_Length(projectfilename_with_path)
    elseif endposition==-2 then endposition=timesel1_end
    end
  end    
  
  -- desired render-range invalid?
  if endposition<=startposition then ultraschall.AddErrorMessage("RenderProject", "endposition", "Must be bigger than startposition.", -11) return -1 end
  
  -- set, if the rendering to file-dialog shall be automatically closed, according to user preference or default setting
  if renderclosewhendone==nil then 
    renderclosewhendone=reaper.SNM_GetIntConfigVar("renderclosewhendone", -2222)&1
    if renderclosewhendone==1 then renderclosewhendone=true else renderclosewhendone=false end
  end
  if filenameincrease==nil then 
    filenameincrease=reaper.SNM_GetIntConfigVar("renderclosewhendone", -2222)&16
    if filenameincrease==1 then filenameincrease=true else filenameincrease=false end
  end

  -- alter the rendersetting to the default ones, I need in this function
  -- the rest stays the way it has been set in the project
  RenderTable["Bounds"]=0
  RenderTable["Startposition"]=startposition
  RenderTable["Endposition"]=endposition
  RenderTable["SilentlyIncrementFilename"]=filenameincrease    
  RenderTable["RenderFile"]=path
  RenderTable["RenderPattern"]=filename
  RenderTable["CloseAfterRender"]=renderclosewhendone
  if projectfilename_with_path~=nil and rendercfg~=nil and rendercfg:len()==4 then 
    ultraschall.AddErrorMessage("RenderProject", "rendercfg", "When rendering projectfiles, rendercfg must be a valid Base64-encoded-renderstring!", -17)
    return -1
  end
  RenderTable["RenderString"]=rendercfg
  RenderTable["RenderString2"]=rendercfg2
  
--  if ultraschall.GetOutputFormat_RenderCfg(RenderTable["RenderString"])==nil or ultraschall.GetOutputFormat_RenderCfg(RenderTable["RenderString"])=="Unknown" then ultraschall.AddErrorMessage("RenderProject", "", "No valid render_cfg-string.", -16) return -1 end
  
  -- delete renderfile, if already existing and overwrite_without_asking==true
  if overwrite_without_asking==true then
    if renderfilename_with_path~=nil and reaper.file_exists(renderfilename_with_path)==true then
      os.remove(renderfilename_with_path) 
      if reaper.file_exists(renderfilename_with_path)==true then ultraschall.AddErrorMessage("RenderProject", "renderfilename_with_path", "Couldn't delete file. It's probably still in use.", -14) return -1 end
    end        
  end 

  -- render project and return the found files, if any
  local count, MediaItemStateChunkArray, Filearray = ultraschall.RenderProject_RenderTable(projectfilename_with_path, RenderTable)
  if count==-1 then retval=-1 else retval=0 end
  return retval, count, MediaItemStateChunkArray, Filearray
end

function ultraschall.CreateNewRenderTable(Source, Bounds, Startposition, Endposition, TailFlag, TailMS, RenderFile, RenderPattern,
SampleRate, Channels, OfflineOnlineRendering, ProjectSampleRateFXProcessing, RenderResample, OnlyMonoMedia, MultiChannelFiles,
Dither, RenderString, SilentlyIncrementFilename, AddToProj, SaveCopyOfProject, RenderQueueDelay, RenderQueueDelaySeconds, CloseAfterRender, 
EmbedStretchMarkers, RenderString2, EmbedTakeMarkers, SilentRender, EmbedMetadata)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateNewRenderTable</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>RenderTable RenderTable = ultraschall.CreateNewRenderTable(integer Source, integer Bounds, number Startposition, number Endposition, integer TailFlag, integer TailMS, string RenderFile, string RenderPattern, integer SampleRate, integer Channels, integer OfflineOnlineRendering, boolean ProjectSampleRateFXProcessing, integer RenderResample, boolean OnlyMonoMedia, boolean MultiChannelFiles, integer Dither, string RenderString, boolean SilentlyIncrementFilename, boolean AddToProj, boolean SaveCopyOfProject, boolean RenderQueueDelay, integer RenderQueueDelaySeconds, boolean CloseAfterRender, optional boolean EmbedStretchMarkers, optional string RenderString2, optional boolean EmbedTakeMarkers, optional boolean SilentRender, optional boolean EmbedMetadata)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Creates a new RenderTable.
    
    Returns nil in case of an error
  </description>
  <retvals>
    RenderTable RenderTable - the created RenderTable
  </retvals>
  <parameters>
    integer Source - The Source-dropdownlist; 
                   - 0, Master mix
                   - 1, Master mix + stems
                   - 3, Stems (selected tracks)
                   - 8, Region render matrix
                   - 32, Selected media items
                   - 256, Embed stretch markers/transient guides-checkbox=on; optional, as parameter EmbedStretchMarkers is meant for that
    integer Bounds - The Bounds-dropdownlist
                   - 0, Custom time range
                   - 1, Entire project
                   - 2, Time selection
                   - 3, Project regions
                   - 4, Selected Media Items(in combination with Source 32)
                   - 5, Selected regions
    number Startposition - the startposition of the render-section in seconds; only used when Bounds=0(Custom time range)
    number Endposition - the endposition of the render-section in seconds; only used when Bounds=0(Custom time range)
    integer TailFlag - in which bounds is the Tail-checkbox checked? 
                     - &1, custom time bounds
                     - &2, entire project
                     - &4, time selection
                     - &8, all project regions
                     - &16, selected media items
                     - &32, selected project regions
    integer TailMS - the amount of milliseconds of the tail
    string RenderFile - the contents of the Directory-inputbox of the Render to File-dialog
    string RenderPattern - the render pattern as input into the File name-inputbox of the Render to File-dialog; set to "" if you don't want to use it
    integer SampleRate - the samplerate of the rendered file(s)
    integer Channels - the number of channels in the rendered file; 
                     - 1, mono
                     - 2, stereo
                     - 3 and higher, the number of channels
    integer OfflineOnlineRendering - Offline/Online rendering-dropdownlist
                                   - 0, Full-speed Offline
                                   - 1, 1x Offline
                                   - 2, Online Render
                                   - 3, Online Render(Idle)
                                   - 4, Offline Render(Idle)
    boolean ProjectSampleRateFXProcessing - Use project sample rate for mixing and FX/synth processing-checkbox; true, checked; false, unchecked
    integer RenderResample - Resample mode-dropdownlist
                           - 0, Medium (64pt Sinc)
                           - 1, Low (Linear Interpolation)
                           - 2, Lowest (Point Sampling)
                           - 3, Good (192pt Sinc)
                           - 4, Better (348 pt Sinc)
                           - 5, Fast (IIR + Linear Interpolation)
                           - 6, Fast (IIRx2 + Linear Interpolation)
                           - 7, Fast (16pt Sinc)
                           - 8, HQ (512 pt)
                           - 9, Extreme HQ(768pt HQ Sinc)
    boolean OnlyMonoMedia - Tracks with only mono media to mono files-checkbox; true, checked; false, unchecked
    boolean MultiChannelFiles - Multichannel tracks to multichannel files-checkbox; true, checked; false, unchecked
    integer Dither - the Dither/Noise shaping-checkboxes: 
                   - &1, dither master mix
                   - &2, noise shaping master mix
                   - &4, dither stems
                   - &8, dither noise shaping stems
                   
    string RenderString - the render-cfg-string, that holds all settings of the currently set render-output-format as BASE64 string
    boolean SilentlyIncrementFilename - Silently increment filenames to avoid overwriting-checkbox; ignored, as this can't be stored in projectfiles
    boolean AddToProj - Add rendered items to new tracks in project-checkbox; true, checked; false, unchecked
    boolean SaveCopyOfProject - the "Save copy of project to outfile.wav.RPP"-checkbox; ignored, as this can't be stored in projectfiles
    boolean RenderQueueDelay - Delay queued render to allow samples to load-checkbox; ignored, as this can't be stored in projectfiles
    integer RenderQueueDelaySeconds - the amount of seconds for the render-queue-delay
    boolean CloseAfterRender - true, closes rendering to file-dialog after render; false, doesn't close it
    optional boolean EmbedStretchMarkers - true, Embed stretch markers/transient guides-checkbox=on; false or nil, Embed stretch markers/transient guides"-checkbox=off
    optional string RenderString2 - the render-string for the secondary rendering
	optional boolean EmbedTakeMarkers - the "Take markers"-checkbox; true, checked; false, unchecked; default=unchecked
	optional boolean SilentRender - the "Do not render files that are likely silent"-checkbox; true, checked; false, unchecked; default=unchecked
    optional boolean EmbedMetadata - the "Embed metadata"-checkbox; true, checked; false, unchecked; default=unchecked    
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render, is valid, check, rendertable</tags>
</US_DocBloc>
]]
  if math.type(Source)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Source", "#1: must be an integer", -20) return end    
  if math.type(Bounds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Bounds", "#2: must be an integer", -4) return end
  if type(Startposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Startposition", "#3: must be an integer", -21) return end
  if type(Endposition)~="number" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Endposition", "#4: must be an integer", -7) return end
  if math.type(TailFlag)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailFlag", "#5: must be an integer", -22) return end    
  if math.type(TailMS)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "TailMS", "#6: must be an integer", -23) return end    
  if type(RenderFile)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderFile", "#7: must be a string", -12) return end 
  if type(RenderPattern)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderPattern", "#8: must be a string", -13) return end 
  if math.type(SampleRate)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SampleRate", "#9: must be an integer", -17) return end
  if math.type(Channels)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Channels", "#10: must be an integer", -5) return end
  if math.type(OfflineOnlineRendering)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OfflineOnlineRendering", "#11: must be an integer", -9) return end
  if type(ProjectSampleRateFXProcessing)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "ProjectSampleRateFXProcessing", "#12: must be a boolean", -11) return end 
  if math.type(RenderResample)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderResample", "#13: must be an integer", -15) return end
  if type(OnlyMonoMedia)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "OnlyMonoMedia", "#14: must be a boolean", -10) return end 
  if type(MultiChannelFiles)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "MultiChannelFiles", "#15: must be a boolean", -8) return end
  if math.type(Dither)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "Dither", "#16: must be an integer", -6) return end
  if type(RenderString)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderString", "#17: must be a string", -16) return end 
  if type(SilentlyIncrementFilename)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SilentlyIncrementFilename", "#18: must be a boolean", -19) return end
  if type(AddToProj)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "AddToProj", "#19: must be a boolean", -3) return end
  if type(SaveCopyOfProject)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SaveCopyOfProject", "#20: must be a boolean", -18) return end
  if type(RenderQueueDelay)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelay", "#21: must be a boolean", -14) return end
  if math.type(RenderQueueDelaySeconds)~="integer" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderQueueDelaySeconds", "#22: must be an integer", -24) return end
  if type(CloseAfterRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "CloseAfterRender", "#23: must be a boolean", -25) return end
    
  if EmbedStretchMarkers~=nil and type(EmbedStretchMarkers)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "#24: EmbedStretchMarkers", "must be nil(for false) or boolean", -26) return end
  if RenderString2~=nil and type(RenderString2)~="string" then ultraschall.AddErrorMessage("CreateNewRenderTable", "RenderString2", "#25: must be nil or string", -27) return end
  if EmbedStretchMarkers==nil then EmbedStretchMarkers=false end
  if RenderString2==nil then RenderString2="" end
  
  if EmbedTakeMarkers~=nil and type(EmbedTakeMarkers)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "EmbedTakeMarkers", "#26: must be nil(for false) or boolean", -28) return end
  if SilentRender~=nil and type(SilentRender)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "SilentRender", "#27: must be nil(for false) or boolean", -29) return end
  
  if EmbedMetadata~=nil and type(EmbedMetadata)~="boolean" then ultraschall.AddErrorMessage("CreateNewRenderTable", "CloseAfterRender", "#28: must be a boolean", -30) return end
  if EmbedTakeMarkers==nil then EmbedTakeMarkers=false end  
  if SilentRender==nil then SilentRender=false end
  if EmbedMetadata==nil then EmbedMetadata=false end
  
  local RenderTable={}
  RenderTable["AddToProj"]=AddToProj
  RenderTable["Bounds"]=Bounds
  RenderTable["Channels"]=Channels
  RenderTable["Dither"]=Dither
  RenderTable["Endposition"]=Endposition
  RenderTable["MultiChannelFiles"]=MultiChannelFiles
  RenderTable["OfflineOnlineRendering"]=OfflineOnlineRendering
  RenderTable["OnlyMonoMedia"]=OnlyMonoMedia
  RenderTable["ProjectSampleRateFXProcessing"]=ProjectSampleRateFXProcessing
  RenderTable["RenderFile"]=RenderFile
  RenderTable["RenderPattern"]=RenderPattern
  RenderTable["RenderQueueDelay"]=RenderQueueDelay
  RenderTable["RenderQueueDelaySeconds"]=RenderQueueDelaySeconds
  RenderTable["RenderResample"]=RenderResample
  RenderTable["RenderString"]=RenderString
  RenderTable["RenderString2"]=RenderString2
  RenderTable["RenderTable"]=true 
  RenderTable["SampleRate"]=SampleRate
  RenderTable["SaveCopyOfProject"]=SaveCopyOfProject
  RenderTable["SilentlyIncrementFilename"]=SilentlyIncrementFilename
  RenderTable["Source"]=Source
  RenderTable["Startposition"]=Startposition
  RenderTable["TailFlag"]=TailFlag
  RenderTable["TailMS"]=TailMS
  RenderTable["CloseAfterRender"]=CloseAfterRender
  RenderTable["EmbedStretchMarkers"]=EmbedStretchMarkers
  RenderTable["EmbedTakeMarkers"]=EmbedTakeMarkers
  RenderTable["NoSilentRender"]=SilentRender
  RenderTable["EmbedMetaData"]=EmbedMetadata
  return RenderTable
end