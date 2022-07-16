--[[
################################################################################
# 
# Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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



function ultraschall.GetProject_RenderOutputPath(projectfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderOutputPath</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string render_output_directory = ultraschall.GetProject_RenderOutputPath(string projectfilename_with_path)</functioncall>
  <description>
    returns the output-directory for rendered files of a project.

    Doesn't return the correct output-directory for queued-projects!
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfilename with path, whose renderoutput-directories you want to know
  </parameters>
  <retvals>
    string render_output_directory - the output-directory for projects
  </retvals>
  <chapter_context>
    Project-Files
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render management, get, project, render, outputpath</tags>
</US_DocBloc>
]]
  if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderOutputPath", "projectfilename_with_path", "must be a string", -1) return nil end
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("GetProject_RenderOutputPath", "projectfilename_with_path", "file does not exist", -2) return nil end
  local ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path)
  local QueueRendername=ProjectStateChunk:match("(QUEUED_RENDER_OUTFILE.-)\n")
  local QueueRenderProjectName=ProjectStateChunk:match("(QUEUED_RENDER_ORIGINAL_FILENAME.-)\n")
  local OutputRender, RenderPattern, RenderFile
  
  if QueueRendername~=nil then
    QueueRendername=QueueRendername:match(" \"(.-)\" ")
    QueueRendername=ultraschall.GetPath(QueueRendername)
  end
  
  if QueueRenderProjectName~=nil then
    QueueRenderProjectName=QueueRenderProjectName:match(" (.*)")
    QueueRenderProjectName=ultraschall.GetPath(QueueRenderProjectName)
  end


  RenderFile=ProjectStateChunk:match("(RENDER_FILE.-)\n")
  if RenderFile~=nil then
    RenderFile=RenderFile:match("RENDER_FILE (.*)")
    RenderFile=string.gsub(RenderFile,"\"","")
  end
  
  RenderPattern=ProjectStateChunk:match("(RENDER_PATTERN.-)\n")
  if RenderPattern~=nil then
    RenderPattern=RenderPattern:match("RENDER_PATTERN (.*)")
    if RenderPattern~=nil then
      RenderPattern=string.gsub(RenderPattern,"\"","")
    end
  end

  -- get the normal render-output-directory
  if RenderPattern~=nil and RenderFile~=nil then
    if ultraschall.DirectoryExists2(RenderFile)==true then
      OutputRender=RenderFile
    else
      OutputRender=ultraschall.GetPath(projectfilename_with_path)..ultraschall.Separator..RenderFile
    end
  elseif RenderFile~=nil then
    OutputRender=ultraschall.GetPath(RenderFile)    
  else
    OutputRender=ultraschall.GetPath(projectfilename_with_path)
  end


  -- get the potential RenderQueue-renderoutput-path
  -- not done yet...todo
  -- that way, I may be able to add the currently opened projects as well...
--[[
  if RenderPattern==nil and (RenderFile==nil or RenderFile=="") and
     QueueRenderProjectName==nil and QueueRendername==nil then
    QueueOutputRender=ultraschall.GetPath(projectfilename_with_path)
  elseif RenderPattern~=nil and RenderFile~=nil then
    if ultraschall.DirectoryExists2(RenderFile)==true then
      QueueOutputRender=RenderFile
    end
  end
  --]]
  
  OutputRender=string.gsub(OutputRender,"\\\\", "\\")
  
  return OutputRender, QueueOutputRender
end

--A="c:\\Users\\meo\\Desktop\\trss\\20Januar2019\\rec\\rec3.RPP"

--B,C=ultraschall.GetProject_RenderOutputPath()


ultraschall.ShowLastErrorMessage()



function ultraschall.GetProjectReWireClient(projectfilename_with_path)
--To Do
-- ProjectSettings->Advanced->Rewire Client Settings
end




function ultraschall.get_action_context_MediaItemDiff(exlude_mousecursorsize, x, y)
-- TODO:: nice to have feature: when mouse is above crossfades between two adjacent items, return this state as well as a boolean
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>get_action_context_MediaItemDiff</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>MediaItem MediaItem, MediaItem_Take MediaItem_Take, MediaItem MediaItem_unlocked, boolean Item_moved, number StartDiffTime, number EndDiffTime, number LengthDiffTime, number OffsetDiffTime = ultraschall.get_action_context_MediaItemDiff(optional boolean exlude_mousecursorsize, optional integer x, optional integer y)</functioncall>
  <description>
    Returns the currently clicked MediaItem, Take as well as the difference of position, end, length and startoffset since last time calling this function.
    Good for implementing ripple-drag/editing-functions, whose position depends on changes in the currently clicked MediaItem.
    Repeatedly call this (e.g. in a defer-cycle) to get all changes made, during dragging position, length or offset of the MediaItem underneath mousecursor.
    
    This function takes into account the size of the start/end-drag-mousecursor, that means: if mouse-position is within 3 pixels before start/after end of the item, it will get the correct MediaItem. 
    This is a workaround, as the mouse-cursor changes to dragging and can still affect the MediaItem, even though the mouse at this position isn't above a MediaItem anymore.
    To be more strict, set exlude_mousecursorsize to true. That means, it will only detect MediaItems directly beneath the mousecursor. If the mouse isn't above a MediaItem, this function will ignore it, even if the mouse could still affect the MediaItem.
    If you don't understand, what that means: simply omit exlude_mousecursorsize, which should work in almost all use-cases. If it doesn't work as you want, try setting it to true and see, whether it works now.    
    
    returns nil in case of an error
  </description>
  <retvals>
    MediaItem MediaItem - the MediaItem at the current mouse-position; nil if not found
    MediaItem_Take MediaItem_Take - the MediaItem_Take underneath the mouse-cursor
    MediaItem MediaItem_unlocked - if the MediaItem isn't locked, you'll get a MediaItem here. If it is locked, this retval is nil
    boolean Item_moved - true, the item was moved; false, only a part(either start or end or offset) of the item was moved
    number StartDiffTime - if the start of the item changed, this is the difference;
                         -   positive, the start of the item has been changed towards the end of the project
                         -   negative, the start of the item has been changed towards the start of the project
                         -   0, no changes to the itemstart-position at all
    number EndDiffTime - if the end of the item changed, this is the difference;
                         -   positive, the end of the item has been changed towards the end of the project
                         -   negative, the end of the item has been changed towards the start of the project
                         -   0, no changes to the itemend-position at all
    number LengthDiffTime - if the length of the item changed, this is the difference;
                         -   positive, the length is longer
                         -   negative, the length is shorter
                         -   0, no changes to the length of the item
    number OffsetDiffTime - if the offset of the item-take has changed, this is the difference;
                         -   positive, the offset has been changed towards the start of the project
                         -   negative, the offset has been changed towards the end of the project
                         -   0, no changes to the offset of the item-take
                         - Note: this is the offset of the take underneath the mousecursor, which might not be the same size, as the MediaItem itself!
                         - So changes to the offset maybe changes within the MediaItem or the start of the MediaItem!
                         - This could be important, if you want to affect other items with rippling.
  </retvals>
  <parameters>
    optional boolean exlude_mousecursorsize - false or nil, get the item underneath, when it can be affected by the mouse-cursor(dragging etc): when in doubt, use this
                                            - true, get the item underneath the mousecursor only, when mouse is strictly above the item,
                                            -       which means: this ignores the item when mouse is not above it, even if the mouse could affect the item
    optional integer x - nil, use the current x-mouseposition; otherwise the x-position in pixels
    optional integer y - nil, use the current y-mouseposition; otherwise the y-position in pixels
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, action, context, difftime, item, mediaitem, offset, length, end, start, locked, unlocked</tags>
</US_DocBloc>
--]]
  if x~=nil and math.type(x)~="integer" then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "x", "must be either nil or an integer", -1) return nil end
  if y~=nil and math.type(y)~="integer" then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "y", "must be either nil or an integer", -2) return nil end
  if (x~=nil and y==nil) or (y~=nil and x==nil) then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "x or y", "must be either both nil or both an integer!", -3) return nil end
  local MediaItem, MediaItem_Take, MediaItem_unlocked
  local StartDiffTime, EndDiffTime, Item_moved, LengthDiffTime, OffsetDiffTime
  if x==nil and y==nil then x,y=reaper.GetMousePosition() end
  MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x, y, true)
  MediaItem_unlocked = reaper.GetItemFromPoint(x, y, false)
  if MediaItem==nil and exlude_mousecursorsize~=true then
    MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x+3, y, true)
    MediaItem_unlocked = reaper.GetItemFromPoint(x+3, y, false)
  end
  if MediaItem==nil and exlude_mousecursorsize~=true then
    MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x-3, y, true)
    MediaItem_unlocked = reaper.GetItemFromPoint(x-3, y, false)
  end
  
  -- crossfade-stuff
  -- example-values for crossfade-parts
  -- Item left: 811 -> 817 , Item right: 818 -> 825
  --               6           7
  -- first:  get, if the next and previous items are at each other/crossing; if nothing -> no crossfade
  -- second: get, if within the aforementioned pixel-ranges, there's another item
  --              6 pixels for the one before the current item
  --              7 pixels for the next item
  -- third: if yes: crossfade-area, else: no crossfade area
  --[[
  -- buggy: need to know the length of the crossfade, as the aforementioned attempt would work only
  --        if the items are adjacent but not if they overlap
  --        also need to take into account, what if zoomed out heavily, where items might be only
  --        a few pixels wide
  
  if MediaItem~=nil then
    ItemNumber = reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
    ItemTrack  = reaper.GetMediaItemInfo_Value(MediaItem, "P_TRACK")
    ItemBefore = reaper.GetTrackMediaItem(ItemTrack, ItemNumber-1)
    ItemAfter = reaper.GetTrackMediaItem(ItemTrack, ItemNumber+1)
    if ItemBefore~=nil then
      ItemBefore_crossfade=reaper.GetMediaItemInfo_Value(ItemBefore, "D_POSITION")+reaper.GetMediaItemInfo_Value(ItemBefore, "D_LENGTH")>=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    end
  end
  --]]
  
  if ultraschall.get_action_context_MediaItem_old~=MediaItem then
    StartDiffTime=0
    EndDiffTime=0
    LengthDiffTime=0
    OffsetDiffTime=0
    if MediaItem~=nil then
      ultraschall.get_action_context_MediaItem_Start=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_End=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")+reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_Length=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
      ultraschall.get_action_context_MediaItem_Offset=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS")
    end
  else
    if MediaItem~=nil then      
      StartDiffTime=ultraschall.get_action_context_MediaItem_Start
      EndDiffTime=ultraschall.get_action_context_MediaItem_End
      LengthDiffTime=ultraschall.get_action_context_MediaItem_Length
      OffsetDiffTime=ultraschall.get_action_context_MediaItem_Offset
      
      ultraschall.get_action_context_MediaItem_Start=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_End=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")+reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_Length=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
      ultraschall.get_action_context_MediaItem_Offset=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS")
      
      Item_moved=(ultraschall.get_action_context_MediaItem_Start~=StartDiffTime
              and ultraschall.get_action_context_MediaItem_End~=EndDiffTime)
              
      StartDiffTime=ultraschall.get_action_context_MediaItem_Start-StartDiffTime
      EndDiffTime=ultraschall.get_action_context_MediaItem_End-EndDiffTime
      LengthDiffTime=ultraschall.get_action_context_MediaItem_Length-LengthDiffTime
      OffsetDiffTime=ultraschall.get_action_context_MediaItem_Offset-OffsetDiffTime
      
    end    
  end
  ultraschall.get_action_context_MediaItem_old=MediaItem

  return MediaItem, MediaItem_Take, MediaItem_unlocked, Item_moved, StartDiffTime, EndDiffTime, LengthDiffTime, OffsetDiffTime
end

--a,b,c,d,e,f,g,h,i=ultraschall.get_action_context_MediaItemDiff(exlude_mousecursorsize, x, y)



function ultraschall.TracksToColorPattern(colorpattern, startingcolor, direction)
end


function ultraschall.GetTrackEnvelope_ClickStates()
-- how to get the connection to clicked envelopepoint, when mouse moves away from the item while retaining click(moving underneath the item for dragging)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackEnvelope_ClickState</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.981
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean clickstate, number position, MediaTrack track, TrackEnvelope envelope, integer EnvelopePointIDX = ultraschall.GetTrackEnvelope_ClickState()</functioncall>
  <description>
    Returns the currently clicked Envelopepoint and TrackEnvelope, as well as the current timeposition.
    
    Works only, if the mouse is above the EnvelopePoint while having it clicked!
    
    Returns false, if no envelope is clicked at
  </description>
  <retvals>
    boolean clickstate - true, an envelopepoint has been clicked; false, no envelopepoint has been clicked
    number position - the position, at which the mouse has clicked
    MediaTrack track - the track, from which the envelope and it's corresponding point is taken from
    TrackEnvelope envelope - the TrackEnvelope, in which the clicked envelope-point lies
    integer EnvelopePointIDX - the id of the clicked EnvelopePoint
  </retvals>
  <chapter_context>
    Envelope Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>envelope management, get, clicked, envelope, envelopepoint</tags>
</US_DocBloc>
--]]
  -- TODO: Has an issue, if the mousecursor drags the item, but moves above or underneath the item(if item is in first or last track).
  --       Even though the item is still clicked, it isn't returned as such.
  --       The ConfigVar uiscale supports dragging information, but the information which item has been clicked gets lost somehow
  --local B, Track, Info, TrackEnvelope, TakeEnvelope, X, Y
  
  B=reaper.SNM_GetDoubleConfigVar("uiscale", -999)
  if tostring(B)=="-1.#QNAN" then
    ultraschall.EnvelopeClickState_OldTrack=nil
    ultraschall.EnvelopeClickState_OldInfo=nil
    ultraschall.EnvelopeClickState_OldTrackEnvelope=nil
    ultraschall.EnvelopeClickState_OldTakeEnvelope=nil
    return 1
  else
    Track=ultraschall.EnvelopeClickState_OldTrack
    Info=ultraschall.EnvelopeClickState_OldInfo
    TrackEnvelope=ultraschall.EnvelopeClickState_OldTrackEnvelope
    TakeEnvelope=ultraschall.EnvelopeClickState_OldTakeEnvelope
  end
  
  if Track==nil then
    X,Y=reaper.GetMousePosition()
    Track, Info = reaper.GetTrackFromPoint(X,Y)
    ultraschall.EnvelopeClickState_OldTrack=Track
    ultraschall.EnvelopeClickState_OldInfo=Info
  end
  
  -- BUggy, til the end
  -- Ich will hier mir den alten Take auch noch merken, und danach herausfinden, welcher EnvPoint im Envelope existiert, der
  --   a) an der Zeit existiert und
  --   b) selektiert ist
  -- damit könnte ich eventuell es schaffen, die Info zurückzugeben, welcher Envelopepoint gerade beklickt wird.
  if TrackEnvelope==nil then
    reaper.BR_GetMouseCursorContext()
    TrackEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
    ultraschall.EnvelopeClickState_OldTrackEnvelope=TrackEnvelope
  end
  
  if TakeEnvelope==nil then
    reaper.BR_GetMouseCursorContext()
    TakeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
    ultraschall.EnvelopeClickState_OldTakeEnvelope=TakeEnvelope
  end
  --[[
  
  
  
  reaper.BR_GetMouseCursorContext()
  local TrackEnvelope, TakeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
  
  if Track==nil then Track=ultraschall.EnvelopeClickState_OldTrack end
  if Track~=nil then ultraschall.EnvelopeClickState_OldTrack=Track end
  if TrackEnvelope~=nil then ultraschall.EnvelopeClickState_OldTrackEnvelope=TrackEnvelope end
  if TrackEnvelope==nil then TrackEnvelope=ultraschall.EnvelopeClickState_OldTrackEnvelope end
  if TakeEnvelope~=nil then ultraschall.EnvelopeClickState_OldTakeEnvelope=TakeEnvelope end
  if TakeEnvelope==nil then TakeEnvelope=ultraschall.EnvelopeClickState_OldTakeEnvelope end
  
  --]]
  --[[
  if TakeEnvelope==true or TrackEnvelope==nil then return false end
  local TimePosition=ultraschall.GetTimeByMouseXPosition(reaper.GetMousePosition())
  local EnvelopePoint=
  return true, TimePosition, Track, TrackEnvelope, EnvelopePoint
  --]]
  if TrackEnvelope==nil then TrackEnvelope=TakeEnvelope end
  return true, ultraschall.GetTimeByMouseXPosition(reaper.GetMousePosition()), Track, TrackEnvelope--, reaper.GetEnvelopePointByTime(TrackEnvelope, TimePosition)
end


function ultraschall.SetLiceCapExe(PathToLiceCapExecutable)
-- works on Mac too?
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetLiceCapExe</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetLiceCapExe(string PathToLiceCapExecutable)</functioncall>
  <description>
    Sets the path and filename of the LiceCap-executable

    Note: Doesn't work on Linux, as there isn't a Linux-port of LiceCap yet.
    
    Returns false in case of error.
  </description>
  <parameters>
    string SetLiceCapExe - the LiceCap-executable with path
  </parameters>
  <retvals>
    boolean retval - false in case of error; true in case of success
  </retvals>
  <chapter_context>
    API-Helper functions
    LiceCap
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, set, licecap, executable</tags>
</US_DocBloc>
]]  
  if type(PathToLiceCapExecutable)~="string" then ultraschall.AddErrorMessage("SetLiceCapExe", "PathToLiceCapExecutable", "Must be a string", -1) return false end
  if reaper.file_exists(PathToLiceCapExecutable)==false then ultraschall.AddErrorMessage("SetLiceCapExe", "PathToLiceCapExecutable", "file not found", -2) return false end
  local A,B=reaper.BR_Win32_WritePrivateProfileString("REAPER", "licecap_path", PathToLiceCapExecutable, reaper.get_ini_file())
  return A
end

--O=ultraschall.SetLiceCapExe("c:\\Program Files (x86)\\LICEcap\\LiceCap.exe")

function ultraschall.SetupLiceCap(output_filename, title, titlems, x, y, right, bottom, fps, gifloopcount, stopafter, prefs)
-- works on Mac too?
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetupLiceCap</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetupLiceCap(string output_filename, string title, integer titlems, integer x, integer y, integer right, integer bottom, integer fps, integer gifloopcount, integer stopafter, integer prefs)</functioncall>
  <description>
    Sets up an installed LiceCap-instance.
    
    To choose the right LiceCap-version, run the action 41298 - Run LICEcap (animated screen capture utility)
    
    Note: Doesn't work on Linux, as there isn't a Linux-port of LiceCap yet.
    
    Returns false in case of error.
  </description>
  <parameters>
    string output_filename - the output-file; you can choose whether it shall be a gif or an lcf by giving it the accompanying extension "mylice.gif" or "milice.lcf"; nil, keep the current outputfile
    string title - the title, which shall be shown at the beginning of the licecap; newlines will be exchanged by spaces, as LiceCap doesn't really support newlines; nil, keep the current title
    integer titlems - how long shall the title be shown, in milliseconds; nil, keep the current setting
    integer x - the x-position of the LiceCap-window in pixels; nil, keep the current setting
    integer y - the y-position of the LiceCap-window in pixels; nil, keep the current setting
    integer right - the right side-position of the LiceCap-window in pixels; nil, keep the current setting
    integer bottom - the bottom-position of the LiceCap-window in pixels; nil, keep the current setting
    integer fps - the maximum frames per seconds, the LiceCap shall have; nil, keep the current setting
    integer gifloopcount - how often shall the gif be looped?; 0, infinite looping; nil, keep the current setting
    integer stopafter - stop recording after xxx milliseconds; nil, keep the current setting
    integer prefs - the preferences-settings of LiceCap, which is a bitfield; nil, keep the current settings
                  - &1 - display in animation: title frame - checkbox
                  - &2 - Big font - checkbox
                  - &4 - display in animation: mouse button press - checkbox
                  - &8 - display in animation: elapsed time - checkbox
                  - &16 - Ctrl+Alt+P pauses recording - checkbox
                  - &32 - Use .GIF transparency for smaller files - checkbox
                  - &64 - Automatically stop after xx seconds - checkbox           
  </parameters>
  <retvals>
    boolean retval - false in case of error; true in case of success
  </retvals>
  <chapter_context>
    API-Helper functions
    LiceCap
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, licecap, setup</tags>
</US_DocBloc>
]]  
  if output_filename~=nil and type(output_filename)~="string" then ultraschall.AddErrorMessage("SetupLiceCap", "output_filename", "Must be a string", -2) return false end
  if title~=nil and type(title)~="string" then ultraschall.AddErrorMessage("SetupLiceCap", "title", "Must be a string", -3) return false end
  if titlems~=nil and math.type(titlems)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "titlems", "Must be an integer", -4) return false end
  if x~=nil and math.type(x)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "x", "Must be an integer", -5) return false end
  if y~=nil and math.type(y)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "y", "Must be an integer", -6) return false end
  if right~=nil and math.type(right)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "right", "Must be an integer", -7) return false end
  if bottom~=nil and math.type(bottom)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "bottom", "Must be an integer", -8) return false end
  if fps~=nil and math.type(fps)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "fps", "Must be an integer", -9) return false end
  if gifloopcount~=nil and math.type(gifloopcount)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "gifloopcount", "Must be an integer", -10) return false end
  if stopafter~=nil and math.type(stopafter)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "stopafter", "Must be an integer", -11) return false end
  if prefs~=nil and math.type(prefs)~="integer" then ultraschall.AddErrorMessage("SetupLiceCap", "prefs", "Must be an integer", -12) return false end
  
  local CC
  local A,B=reaper.BR_Win32_GetPrivateProfileString("REAPER", "licecap_path", -1, reaper.get_ini_file())
  if B=="-1" or reaper.file_exists(B)==false then ultraschall.AddErrorMessage("SetupLiceCap", "", "LiceCap not installed, please run action \"Run LICEcap (animated screen capture utility)\" to set up LiceCap", -1) return false end
  local Path, File=ultraschall.GetPath(B)
  if reaper.file_exists(Path.."/".."licecap.ini")==false then ultraschall.AddErrorMessage("SetupLiceCap", "", "Couldn't find licecap.ini in LiceCap-path. Is LiceCap really installed?", -13) return false end
  if output_filename~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "lastfn", output_filename, Path.."/".."licecap.ini") end
  if title~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "title", string.gsub(title,"\n"," "), Path.."/".."licecap.ini") end
  if titlems~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "titlems", titlems, Path.."/".."licecap.ini") end
  
  local retval, oldwnd_r=reaper.BR_Win32_GetPrivateProfileString("licecap", "wnd_r", -1, Path.."/".."licecap.ini")  
  if x==nil then x=oldwnd_r:match("(.-) ") end
  if y==nil then y=oldwnd_r:match(".- (.-) ") end
  if right==nil then right=oldwnd_r:match(".- .- (.-) ") end
  if bottom==nil then bottom=oldwnd_r:match(".- .- .- (.*)") end
  
  CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "wnd_r", x.." "..y.." "..right.." "..bottom, Path.."/".."licecap.ini")
  if fps~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "maxfps", fps, Path.."/".."licecap.ini") end
  if gifloopcount~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "gifloopcnt", gifloopcount, Path.."/".."licecap.ini") end
  if stopafter~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "stopafter", stopafter, Path.."/".."licecap.ini") end
  if prefs~=nil then CC=reaper.BR_Win32_WritePrivateProfileString("licecap", "prefs", prefs, Path.."/".."licecap.ini") end
  
  return true
end


function ultraschall.StartLiceCap(autorun)
-- doesn't work, as I can't click the run and save-buttons
-- maybe I need to add that to the LiceCap-codebase myself...somehow
  reaper.Main_OnCommand(41298, 0)  
  O=0
  while reaper.JS_Window_Find("LICEcap v", false)==nil do
    O=O+1
    if O==1000000 then break end
  end
  local HWND=reaper.JS_Window_Find("LICEcap v", false)
  reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(HWND, 1001), "WM_LBUTTONDOWN", 1,0,0,0)
  reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(HWND, 1001), "WM_LBUTTONUP", 1,0,0,0)

  HWNDA0=reaper.JS_Window_Find("Choose file for recording", false)

--[[    
  O=0
  while reaper.JS_Window_Find("Choose file for recording", false)==nil do
    O=O+1
    if O==100 then break end
  end

  HWNDA=reaper.JS_Window_Find("Choose file for recording", false)
  TIT=reaper.JS_Window_GetTitle(HWNDA)
  
  for i=-1000, 10000 do
    if reaper.JS_Window_FindChildByID(HWNDA, i)~=nil then
      print_alt(i, reaper.JS_Window_GetTitle(reaper.JS_Window_FindChildByID(HWNDA, i)))
    end
  end

  print(reaper.JS_Window_GetTitle(reaper.JS_Window_FindChildByID(HWNDA, 1)))

  for i=0, 100000 do
    AA=reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(HWNDA, 1), "WM_LBUTTONDOWN", 1,0,0,0)
    BB=reaper.JS_WindowMessage_Post(reaper.JS_Window_FindChildByID(HWNDA, 1), "WM_LBUTTONUP", 1,0,0,0)
  end
  
  return HWND
  --]]
  
  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/LiceCapSave.lua", [[
    dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
    P=0
    
    function main3()
      LiceCapWinPreRoll=reaper.JS_Window_Find(" [stopped]", false)
      LiceCapWinPreRoll2=reaper.JS_Window_Find("LICEcap", false)
      
      if LiceCapWinPreRoll~=nil and LiceCapWinPreRoll2~=nil and LiceCapWinPreRoll2==LiceCapWinPreRoll then
        reaper.JS_Window_Destroy(LiceCapWinPreRoll)
        print("HuiTja", reaper.JS_Window_GetTitle(LiceCapWinPreRoll))
      else
        reaper.defer(main3)
      end
    end
    
    function main2()
      print("HUI:", P)
      A=reaper.JS_Window_Find("Choose file for recording", false)
      if A~=nil and P<20 then  
        P=P+1
        print_alt(reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(A, 1), "WM_LBUTTONDOWN", 1,1,1,1))
        print_alt(reaper.JS_WindowMessage_Send(reaper.JS_Window_FindChildByID(A, 1), "WM_LBUTTONUP", 1,1,1,1))
        reaper.defer(main2)
      elseif P~=0 and A==nil then
        reaper.defer(main3)
      else
        reaper.defer(main2)
      end
    end
    
    
    main2()
    ]])
    local retval, script_identifier = ultraschall.Main_OnCommandByFilename(ultraschall.API_TempPath.."/LiceCapSave.lua")
end



function ultraschall.TransientDetection_Set(Sensitivity, Threshold, ZeroCrossings)
  -- needs to take care of faulty parametervalues AND of correct value-entering into an already opened
  -- 41208 - Transient detection sensitivity/threshold: Adjust... - dialog
  reaper.SNM_SetDoubleConfigVar("transientsensitivity", Sensitivity) -- 0.0 to 1.0
  reaper.SNM_SetDoubleConfigVar("transientthreshold", Threshold) -- -60 to 0
  local val=reaper.SNM_GetIntConfigVar("tabtotransflag", -999)
  if val&2==2 and ZeroCrossings==false then
    reaper.SNM_SetIntConfigVar("tabtotransflag", val-2)
  elseif val&2==0 and ZeroCrossings==true then
    reaper.SNM_SetIntConfigVar("tabtotransflag", val+2)
  end
end

--ultraschall.TransientDetection_Set(0.1, -9, false)



function ultraschall.ReadSubtitles_VTT(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadSubtitles_VTT</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string Kind, string Language, integer Captions_Counter, table Captions = ultraschall.ReadSubtitles_VTT(string filename_with_path)</functioncall>
  <description>
    parses a webvtt-subtitle-file and returns its contents as table
    
    returns nil in case of an error
  </description>
  <retvals>
    string Kind - the type of the webvtt-file, like: captions
    string Language - the language of the webvtt-file
    integer Captions_Counter - the number of captions in the file
    table Captions - the Captions as a table of the format:
                   -    Captions[index]["start"]= the starttime of this caption in seconds
                   -    Captions[index]["end"]= the endtime of this caption in seconds
                   -    Captions[index]["caption"]= the caption itself
  </retvals>
  <parameters>
    string filename_with_path - the filename with path of the webvtt-file
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement, read, file, webvtt, subtitle, import</tags>
</US_DocBloc>
--]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadSubtitles_VTT", "filename_with_path", "must be a string", -1) return end
  if reaper.file_exists(filename_with_path)=="false" then ultraschall.AddErrorMessage("ReadSubtitles_VTT", "filename_with_path", "must be a string", -2) return end
  local A, Type, Offset, Kind, Language, Subs, Subs_Counter, i
  Subs={}
  Subs_Counter=0
  A=ultraschall.ReadFullFile(filename_with_path)
  Type, Offset=A:match("(.-)\n()")
  if Type~="WEBVTT" then ultraschall.AddErrorMessage("ReadSubtitles_VTT", "filename_with_path", "not a webvtt-file", -3) return end
  A=A:sub(Offset,-1)
  Kind, Offset=A:match(".-: (.-)\n()")
  A=A:sub(Offset,-1)
  Language, Offset=A:match(".-: (.-)\n()")
  A=A:sub(Offset,-1)
  
  i=0
  for k in string.gmatch(A, "(.-)\n") do
    i=i+1
    if i==2 then 
      Subs_Counter=Subs_Counter+1
      Subs[Subs_Counter]={} 
      Subs[Subs_Counter]["start"], Subs[Subs_Counter]["end"] = k:match("(.-) --> (.*)")
      if Subs[Subs_Counter]["start"]==nil or Subs[Subs_Counter]["end"]==nil then ultraschall.AddErrorMessage("ReadSubtitles_VTT", "filename_with_path", "can't parse the file; probably invalid", -3) return end
      Subs[Subs_Counter]["start"]=reaper.parse_timestr(Subs[Subs_Counter]["start"])
      Subs[Subs_Counter]["end"]=reaper.parse_timestr(Subs[Subs_Counter]["end"])
    elseif i==3 then 
      Subs[Subs_Counter]["caption"]=k
      if Subs[Subs_Counter]["caption"]==nil then ultraschall.AddErrorMessage("ReadSubtitles_VTT", "filename_with_path", "can't parse the file; probably invalid", -4) return end
    end
    if i==3 then i=0 end
  end
  
  
  return Kind, Language, Subs_Counter, Subs
end


--A,B,C,D,E=ultraschall.ReadSubtitles_VTT("c:\\test.vtt")


function ultraschall.GetTakeEnvelopeUnderMouseCursor()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetTakeEnvelopeUnderMouseCursor</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>TakeEnvelope env, MediaItem_Take take, number projectposition = ultraschall.GetTakeEnvelopeUnderMouseCursor()</functioncall>
    <description>
      returns the take-envelope underneath the mouse
    </description>
    <retvals>
      TakeEnvelope env - the take-envelope found unterneath the mouse; nil, if none has been found
      MediaItem_Take take - the take from which the take-envelope is
      number projectposition - the project-position
    </retvals>
    <chapter_context>
      Envelope Management
      Envelopes
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Envelope_Module.lua</source_document>
    <tags>envelope management, get, take, envelope, mouse position</tags>
  </US_DocBloc>
  --]]
  -- todo: retval for position within the take
  
  local Awindow, Asegment, Adetails = reaper.BR_GetMouseCursorContext()
  local retval, takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
  if takeEnvelope==true then 
    return retval, reaper.BR_GetMouseCursorContext_Position(), reaper.BR_GetMouseCursorContext_Item()
  else
    return nil, reaper.BR_GetMouseCursorContext_Position()
  end
end


function ultraschall.VideoProcessor_SetText(text, font, fontsize, x, y, r, g, b, a)
  -- needs modules/additionals/VideoProcessor-Presets.RPL to be imported somehow
  local OldName=ultraschall.Gmem_GetCurrentAttachedName()
  local fontnameoffset=50
  local textoffset=font:len()+20
  reaper.gmem_attach("Ultraschall_VideoProcessor_Settings")
  reaper.gmem_write(0, 0)           -- type: 0, Text
  reaper.gmem_write(1, text:len())  -- length of text
  reaper.gmem_write(2, textoffset)  -- at which gmem-index does the text start
  reaper.gmem_write(3, font:len())  -- the length of the fontname
  reaper.gmem_write(4, fontnameoffset) -- at which gmem-index does the fontname start
  reaper.gmem_write(5, fontsize)    -- the size of the font 0-1
  reaper.gmem_write(6, 0)           -- is the update-signal; 0, update text and fontname; 1, already updated
  reaper.gmem_write(7, x)           -- x-position of the text
  reaper.gmem_write(8, y)           -- y-position of the text
  reaper.gmem_write(9,  r)          -- red color of the text
  reaper.gmem_write(10, g)          -- green color of the text
  reaper.gmem_write(11, b)          -- blue color of the text
  reaper.gmem_write(12, a)          -- alpha of the text
  for i=1, text:len() do
    Byte=string.byte(text:sub(i,i))
    reaper.gmem_write(i+textoffset, Byte)
  end
  
  for i=1, font:len() do
    Byte=string.byte(font:sub(i,i))
    reaper.gmem_write(i+fontnameoffset, Byte)
  end
  
  if OldName~=nil then
    reaper.gmem_attach(OldName)
  end
end

function ultraschall.VideoProcessor_SetTextPosition(x,y)
-- needs modules/additionals/VideoProcessor-Presets.RPL to be imported somehow
  local OldName=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("Ultraschall_VideoProcessor_Settings")
  reaper.gmem_write(7, x)
  reaper.gmem_write(8, y)
  if OldName~=nil then
    reaper.gmem_attach(OldName)
  end
end

function ultraschall.VideoProcessor_SetFontColor(r,g,b,a)
-- needs modules/additionals/VideoProcessor-Presets.RPL to be imported somehow
  local OldName=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("Ultraschall_VideoProcessor_Settings")
  
  reaper.gmem_write(9,  r)
  reaper.gmem_write(10, g)  
  reaper.gmem_write(11, b)
  reaper.gmem_write(12, a)
  if OldName~=nil then
    reaper.gmem_attach(OldName)
  end  
end

function ultraschall.VideoProcessor_SetFontSize(fontsize)
-- needs modules/additionals/VideoProcessor-Presets.RPL to be imported somehow
  local OldName=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("Ultraschall_VideoProcessor_Settings")
  reaper.gmem_write(5, fontsize)
  
  if OldName~=nil then
    reaper.gmem_attach(OldName)
  end
end

function ultraschall.InputFX_GetInstrument()
  -- undone, no idea how to do it. Maybe parsing reaper-hwoutfx.ini or checking fx-names from InputFX_GetFXName against being instruments?
end


function ultraschall.InputFX_SetNamedConfigParm(fxindex, parmname, value)
  -- dunno, if this function works at all with monitoring fx...
  return reaper.TrackFX_SetNamedConfigParm(reaper.GetMasterTrack(0), 0x1000000+fxindex-1, parmname, value)
end


-- These seem to work working:
function ultraschall.DeleteParmLearn2_FXStateChunk(FXStateChunk, fxid, parmidx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteParmLearn2_FXStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string alteredFXStateChunk = ultraschall.DeleteParmLearn2_FXStateChunk(string FXStateChunk, integer fxid, integer parmidx)</functioncall>
  <description>
    Deletes a ParmLearn-entry from an FXStateChunk, by parameter index.
    
    Unlike [DeleteParmLearn\_FXStateChunk](#DeleteParmLearn_FXStateChunk), this indexes the parameters not the already existing parmlearns.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if deletion was successful; false, if the function couldn't delete anything
    string alteredFXStateChunk - the altered FXStateChunk
  </retvals>
  <parameters>
    string FXStateChunk - the FXStateChunk, which you want to delete a ParmLearn from
    integer fxid - the id of the fx, which holds the to-delete-ParmLearn-entry; beginning with 1
    integer parmidx - the index of the parameter, whose parmlearn you want to delete; beginning with 1
  </parameters>
  <chapter_context>
    FX-Management
    Parameter Mapping Learn
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>fx management, parm, learn, delete, parm, learn, midi, osc, binding</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidFXStateChunk(FXStateChunk)==false then ultraschall.AddErrorMessage("DeleteParmLearn2_FXStateChunk", "FXStateChunk", "no valid FXStateChunk", -1) return false end
  if math.type(fxid)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn2_FXStateChunk", "fxid", "must be an integer", -2) return false end
  if math.type(parmidx)~="integer" then ultraschall.AddErrorMessage("DeleteParmLearn2_FXStateChunk", "parmidx", "must be an integer", -3) return false end
    
  local UseFX, startoffset, endoffset = ultraschall.GetFXFromFXStateChunk(FXStateChunk, fxid)
  if UseFX==nil then ultraschall.AddErrorMessage("DeleteParmLearn2_FXStateChunk", "fxid", "no such fx", -4) return false end
  
  local ParmLearnEntry=UseFX:match("%s-PARMLEARN "..(parmidx-1).."[:]*%a* .-\n")
  if ParmLearnEntry==nil then ultraschall.AddErrorMessage("DeleteParmLearn2_FXStateChunk", "parmidx", "no such parameter", -5) return false end
    
  local UseFX2=string.gsub(UseFX, ParmLearnEntry, "\n")

  return true, FXStateChunk:sub(1, startoffset)..UseFX2:sub(2,-2)..FXStateChunk:sub(endoffset-1, -1)
end

-- Ultraschall 4.2.002




function ultraschall.OpenReaperFunctionDoc(functionname)
  if type(functionname)~="string" then ultraschall.AddErrorMessage("OpenReaperFunctionDoc", "functionname", "must be a string", -1) return false end
  if reaper[functionname]==nil then ultraschall.AddErrorMessage("OpenReaperFunctionDoc", "functionname", "no such function", -2) return false end
  local A=[[
  <!DOCTYPE html>
  <html>
    <head>
      <meta http-equiv="refresh" content="0; url=]]..ultraschall.Api_Path.."/Documentation/Reaper_Api_Documentation.html#"..functionname..[[">
    </head>
    <body>
    </body>
  </html>
  ]]
  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/start.html", A)
  ultraschall.OpenURL(ultraschall.API_TempPath.."/start.html")
  return true
end


--ultraschall.OpenReaperFunctionDoc("MB")

function ultraschall.OpenUltraschallFunctionDoc(functionname)
  if type(functionname)~="string" then ultraschall.AddErrorMessage("OpenUltraschallFunctionDoc", "functionname", "must be a string", -1) return false end
  if ultraschall[functionname]==nil then ultraschall.AddErrorMessage("OpenUltraschallFunctionDoc", "functionname", "no such function", -2) return false end
  local A=[[
  <!DOCTYPE html>
  <html>
    <head>
      <meta http-equiv="refresh" content="0; url=]]..ultraschall.Api_Path.."/Documentation/US_Api_Functions.html#"..functionname..[[">
    </head>
    <body>
    </body>
  </html>
  ]]
  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/start.html", A)
  ultraschall.OpenURL(ultraschall.API_TempPath.."/start.html")
  return true
end

--ultraschall.OpenUltraschallFunctionDoc("RenderProject")




function ultraschall.CalculateLoudness(mode, timeselection, trackstring)
-- TODO!!
-- multiple tracks, items can be returned by GetSetProjectInfo_String, when items/tracks are selected
-- function currently only supports one, the first one. Please boost it up a little....
--
-- Check trackstring-management.
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CalculateLoudness</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.30
    Lua=5.3
  </requires>
  <functioncall>string filename, string peak, string clip, string rms, string lrange, string lufs_i = ultraschall.CalculateLoudness(integer mode, boolean timeselection)</functioncall>
  <description>
    Calculates the loudness of items and tracks or returns the loudness of last render/dry-render.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string filename - the filename, that would be rendered
    string peak - the peak of the rendered element
    string clip - the clipping of the rendered element
    string rms - the rms of the rendered element
    string lrange - the lrange of the rendered element
    string lufs_i - the lufs-i of the rendered element
  </retvals>
  <parameters>
    integer mode - -1, return loudness-stats of the last render/dry render
                 - 0, calculate loudness-stats of selected media items
                 - 1, calculate loudness-stats of master track
                 - 2, calculate loudness-stats of selected tracks
    boolean timeselection - shall loudness calculation only be within time-selection?
                          - only with mode 1 and 2; if no time-selection is given, use entire track
                          - false, calculate loudness within the entire tracks;
                          - true, calculate loudness-stats within time-selection
  </parameters>
  <chapter_context>
    Rendering Projects
    Loudness Calculation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>projectfiles, compare, rendertable</tags>
</US_DocBloc>
]]
  -- FILE-management can be improved for dry-rendering, probably...
  if math.type(mode)~="integer" then ultraschall.AddErrorMessage("CalculateLoudness", "mode", "must be an integer", -1) return end
  if type(timeselection)~="boolean" then ultraschall.AddErrorMessage("CalculateLoudness", "timeselection", "must be a boolean", -2) return end
  
  if     mode==-1 then mode=""
  elseif mode==0 then mode=42437
  elseif mode==1 and timeselection==false then mode=42440
  elseif mode==1 and timeselection==true  then mode=42441
  elseif mode==2 and timeselection==false then mode=42438
  elseif mode==2 and timeselection==true  then mode=42439
  end  
  
  local oldtrackstring  
  if mode==2 then
    oldtrackstring = ultraschall.CreateTrackString_SelectedTracks()
    ultraschall.SetTracksSelected(trackstring, true)
  end
  local retval, RenderStats=reaper.GetSetProjectInfo_String(0, "RENDER_STATS", mode, false)
  RenderStats=RenderStats..";"

  local FILE, PEAK, CLIP, RMSI, LRA, LUFSI
  FILE=RenderStats:match("FILE:(.-);")
  PEAK=RenderStats:match("PEAK:(.-);")
  if PEAK==nil then PEAK="-inf" end
  CLIP=RenderStats:match("CLIP:(.-);")
  if CLIP==nil then CLIP="0" end
  RMSI=RenderStats:match("RMSI:(.-);")
  if RMSI==nil then RMSI="-inf" end
  LRA=RenderStats:match("LRA:(.-);")
  if LRA==nil then LRA="-inf" end
  LUFSI=RenderStats:match("LUFSI:(.-);")
  if LUFSI==nil then LUFSI="-inf" end

  if mode==2 then
    ultraschall.SetTracksSelected(oldtrackstring, true)
  end

  return FILE, PEAK, CLIP, RMSI, LRA, LUFSI
end


--A={ultraschall.CalculateLoudness(0, true)}

function ultraschall.BubbleSortDocBlocTable_Slug(Table)
  local count=1
  while Table[count]~=nil and Table[count+1]~=nil do
    if Table[count][1]>Table[count+1][1] then
      temp=Table[count]
      Table[count]=Table[count+1]
      Table[count+1]=temp
    end
    count=count+1
  end
end

-- Need to be documented, but are finished



function ultraschall.Docs_GetReaperApiFunction_Description(functionname)
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "function not found", -2) return end

  local Description, markup_type, markup_version

  Description, markup_type, markup_version  = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  if Description==nil then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "no description existing", -3) return end

  Description = string.gsub(Description, "&lt;", "<")
  Description = string.gsub(Description, "&gt;", ">")
  Description = string.gsub(Description, "&amp;", "&")
  return Description, markup_type, markup_version
end



function ultraschall.Docs_GetReaperApiFunction_Call(functionname, proglang)
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "must be a string", -1) return nil end
  if math.type(proglang)~="integer" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "must be an integer", -2) return nil end
  if proglang<1 or proglang>4 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "no such programming language available", -3) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "function not found", -4) return end

  local Call, prog_lang
  Call, prog_lang  = ultraschall.Docs_GetUSDocBloc_Functioncall(ultraschall.Docs_ReaperApiDocBlocs[found], proglang)
  if Call==nil then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "no such programming language available", -5) return end
  Call = string.gsub(Call, "&lt;", "<")
  Call = string.gsub(Call, "&gt;", ">")
  Call = string.gsub(Call, "&amp;", "&")
  return Call, prog_lang
end

function ultraschall.Docs_LoadReaperApiDocBlocs()
  ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
  ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
  ultraschall.Docs_ReaperApiDocBlocs_Titles={}
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
    ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
  end
end

function ultraschall.Docs_FindReaperApiFunction_Pattern(pattern, case_sensitive, include_descriptions, include_retvalnames, include_paramnames, include_tags)
  -- unfinished:
  -- include_retvalnames, include_paramnames not yet implemented
  -- probably needs RetVal/Param-function that returns datatypes and name independently from each other
  -- which also means: all functions must return values with a proper, descriptive name(or at least retval)
  --                   or this breaks -> Doc-CleanUp-Work...Yeah!!! (looking forward to it, actually)
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  if include_descriptions==false then FoundInformation=nil end
  local found_this_time=false
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
      for i=1, count do
        if case_sensitive==false then tags[i]=tags[i]:lower() end
        if tags[i]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperApiDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1-desc_startoffset end
        FoundInformation[Found_count+1]={}
        FoundInformation[Found_count+1][1]=Description:sub(Offset1, Offset2+desc_endoffset-1)
        FoundInformation[Found_count+1][2]=Offset1 -- startoffset of found pattern, so this part can be highlighted
                                                   -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

--A,B,C=ultraschall.Docs_FindReaperApiFunction_Pattern("tudel", false, false, 10, 14, nil, nil, true)



ultraschall.ShowNoteAttributes = {"shwn_language",           -- check for validity ISO639
              "shwn_description",
              "shwn_location_gps",       -- check for validity
              "shwn_location_google_maps",-- check for validity
              "shwn_location_open_street_map",-- check for validity
              "shwn_location_apple_maps",-- check for validity
              "shwn_date",       -- check for validity
              "shwn_time",       -- check for validity
              "shwn_timezone",   -- check for validity
              "shwn_event_date_start",   -- check for validity
              "shwn_event_date_end",     -- check for validity
              "shwn_event_time_start",   -- check for validity
              "shwn_event_time_end",     -- check for validity
              "shwn_event_timezone",     -- check for validity
              "shwn_event_name",
              "shwn_event_description",
              "shwn_event_url", 
              "shwn_event_location_gps",       -- check for validity
              "shwn_event_location_google_maps",-- check for validity
              "shwn_event_location_open_street_map",-- check for validity
              "shwn_event_location_apple_maps",-- check for validity
              "shwn_event_ics_data",
              "shwn_quote_cite_source", 
              "shwn_quote", 
              --"image_uri",
              --"image_content",      -- check for validity
              --"image_description",
              --"image_source",
              --"image_license",
              "shwn_url", 
              "shwn_url_description",
              "shwn_url_retrieval_date",
              "shwn_url_retrieval_time",
              "shwn_url_retrieval_timezone_utc",
              "shwn_url_archived_copy_of_original_url",
              "shwn_wikidata_uri",
              "shwn_descriptive_tags",
              "shwn_is_advertisement"
              }

function ultraschall.GetSetShownoteMarker_Attributes(is_set, idx, attributename, content)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetShownoteMarker_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetShownoteMarker_Attributes(boolean is_set, integer idx, string attributename, string content)</functioncall>
  <description>
    Will get/set additional attributes of a shownote-marker.
    
    A shownote-marker has the naming-scheme 
        
        _Shownote: name for this marker
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer idx - the index of the shownote-marker, whose attribute you want to get; 1-based
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "shwn_description" - a more detailed description for this shownote
                         - "shwn_descriptive_tags" - some tags, that describe the content of the shownote, must separated by newlines
                         - "shwn_url" - the url you want to set
                         - "shwn_url_description" - a short description of the url
                         - "shwn_url_retrieval_date" - the date, at which you retrieved the url; yyyy-mm-dd
                         - "shwn_url_retrieval_time" - the time, at which you retrieved the url; hh:mm:ss
                         - "shwn_url_retrieval_timezone_utc" - the timezone of the retrieval time as utc
                         - "shwn_url_archived_copy_of_original_url" - if you have an archived copy of the url(from archive.org, etc), you can place the link here
                         - "shwn_is_advertisement" - yes, if the shownote is an ad; "", to unset it
                         - "shwn_language" - the language of the content; Languagecode according to ISO639
                         - "shwn_location_gps" - the gps-coordinates of the location
                         - "shwn_location_google_maps" - the coordinates as used in Google Maps
                         - "shwn_location_open_street_map" - the coordinates as used in Open Street Maps
                         - "shwn_location_apple_maps" - the coordinates as used in Apple Maps                         
                         - "shwn_date" - the date of the content of the shownote(when talking about events, etc); yyyy-mm-dd; use XX or XXXX, for when day/month/year is unknown or irrelevant
                         - "shwn_time" - the time of the content of the shownote(when talking about events, etc); hh:mm:ss; use XX for when hour/minute/second is unknown or irrelevant
                         - "shwn_timezone" - the timezone of the content of the shownote(when talking about events, etc); UTC-format
                         - "shwn_event_date_start" - the startdate of an event associated with the show; yyyy-mm-dd
                         - "shwn_event_date_end" - the enddate of an event associated with the show; yyyy-mm-dd
                         - "shwn_event_time_start" - the starttime of an event associated with the show; hh:mm:ss
                         - "shwn_event_time_end" - the endtime of an event associated with the show; hh:mm:ss
                         - "shwn_event_timezone" - the timezone of the event assocated with the show; UTC-format
                         - "shwn_event_name" - a name for the event
                         - "shwn_event_description" - a description for the event
                         - "shwn_event_url" - an url of the event(for ticket sale or the general url for the event)
                         - "shwn_event_location_gps" - the gps-coordinates of the event-location
                         - "shwn_event_location_google_maps" - the google-maps-coordinates of the event-location
                         - "shwn_event_location_open_street_map" - the open-streetmap-coordinates of the event-location
                         - "shwn_event_location_apple_maps" - the apple-maps-coordinates of the event-location
                         - "shwn_event_ics_data" - the event as ics-data-format; will NOT set other event-attributes; will not be checked for validity!
                         - "shwn_quote_cite_source" - a specific place you want to cite, like bookname + page + paragraph + line or something via webcite
                         - "shwn_quote" - a quote from the cite_source
                         - "shwn_wikidata_uri" - the uri to an entry to wikidata
    string content - the new contents to set the attribute with
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
  </retvals>
  <chapter_context>
    Markers
    ShowNote Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, set, attribute, shownote, image, png, jpg, citation</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "is_set", "must be a boolean", -1) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "idx", "must be an integer", -2) return false end    
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "attributename", "must be a string", -3) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "must be a string", -4) return false end  
  
  
  -- WARNING!! CHANGES HERE MUST REFLECT CHANGES IN THE CODE OF CommitShownote_ReaperMetadata() !!!
  local tags=ultraschall.ShowNoteAttributes
              
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  if found==false then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "attributename", "attributename "..tostring(attributename).." not supported", -7) return false end
  
  local A,B,Retval
  A={ultraschall.EnumerateShownoteMarkers(idx)}
  if A[1]==false then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "idx", "no such shownote-marker", -5) return false end
  
  if is_set==true then
    local content2
    if attributename=="image_content" and content:sub(1,6)~="ÿØÿ" and content:sub(2,4)~="PNG" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "image_content: only png and jpg are supported", -6) return false end    
    if attributename=="shwn_event_ics_data" then content2=ultraschall.Base64_Encoder(content) end
    Retval = ultraschall.SetMarkerExtState(A[2]+1, attributename, content2)
    if Retval==-1 then Retval=false else Retval=true end
    B=content    
  else
    B=ultraschall.GetMarkerExtState(A[2]+1, attributename, content)
    if attributename=="shwn_event_ics_data" then B=ultraschall.Base64_Decoder(B) end
    if B==nil then Retval=false B="" else Retval=true end
  end
  return Retval, B
end



ultraschall.PodcastAttributes={"podc_title", 
              "podc_description", 
              --"podc_feed",
              "podc_website", 
              "podc_twitter",
              "podc_facebook",
              "podc_youtube",
              "podc_instagram",
              "podc_tiktok",
              "podc_mastodon",
              --"podc_donate", 
              "podc_contact_email",
              "podc_descriptive_tags"
              }

function ultraschall.GetSetPodcast_Attributes(is_set, attributename, additional_attribute, content, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcast_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content, optional string presetcontent = ultraschall.GetSetPodcast_Attributes(boolean is_set, string attributename, string content, optional integer preset_slot)</functioncall>
  <description>
    Will get/set metadata-attributes for a podcast.
    
    This is about the podcast globally, NOT the individual episodes.
    
         "podc_title" - the title of the podcast
         "podc_description" - a description for your podcast
         "podc_website" - either one url or a list of website-urls of the podcast,separated by newlines
         "podc_contact_email" - an email-address that can be used to contact the podcasters
         "podc_twitter" - twitter-profile of the podcast
         "podc_facebook" - facebook-page of the podcast
         "podc_youtube" - youtube-channel of the podcast
         "podc_instagram" - instagram-channel of the podcast
         "podc_tiktok" - tiktok-channel of the podcast
         "podc_mastodon" - mastodon-channel of the podcast
         "podc_descriptive_tags" - some tags, who describe the podcast, must separated by newlines
    
    For episode's-metadata, use [GetSetPodcastEpisode\_Attributes](#GetSetPodcastEpisode_Attributes)
    
    preset-values will be stored into ressourcepath/ultraschall\_podcast\_presets.ini
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
    string additional_attribute - some attributes allow additional attributes to be set; in all other cases set to ""
                                - when attribute="podcast_website", set this to a number, 1 and higher, which will index possibly multiple websites you have for your podcast
                                - use 1 for the main-website
    string content - the new contents to set the attribute
    optional integer preset_slot - the slot in the podcast-presets to get/set the value from/to; nil, no preset used
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
    optional string presetcontent - the content of the preset's value in the preset_slot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, podcast, attributes</tags>
</US_DocBloc>
]]
  -- check for errors in parameter-values
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "is_set", "must be a boolean", -1) return false end  
  if preset~=nil and math.type(preset)~="integer" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "preset", "must be either nil or an integer", -2) return false end    
  if preset~=nil and preset<=0 then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "preset", "must be higher than 0", -3) return false end 
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "attributename", "must be a string", -4) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "content", "must be a string", -5) return false end  
  if type(additional_attribute)~="string" then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "must be a string", -6) return false end
  
  -- check, if passed attributes are supported
  local tags=ultraschall.PodcastAttributes
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local retval
  
  -- management additional additional attributes for some attributes
  if attributename=="podcast_feed" then
    if additional_attribute:lower()~="mp3" and
       additional_attribute:lower()~="aac" and
       additional_attribute:lower()~="opus" and
       additional_attribute:lower()~="ogg" and
       additional_attribute:lower()~="flac"
      then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_feed\" needs content_attibute being set to the audioformat(mp3, ogg, opus, aac, flac)", -10) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_website" then
    --print(attributename.." "..tostring(math.tointeger(additional_attribute)).." "..additional_attribute)
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_website\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -11) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_donate" then
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "additional_attribute", "attributename \"podcast_donate\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -12) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  else
    additional_attribute=""
  end
  
  if found==false then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "attributename", "attributename not supported", -7) return false end
  local presetcontent, _
  --if attributename=="image_content" and content:sub(1,6)~="ÿØÿ" and content:sub(2,4)~="PNG" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "image_content: only png and jpg are supported", -6) return false end
  
  if is_set==true then
    -- set state
    if preset_slot~=nil then
      content=string.gsub(content, "\r", "")
      retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, attributename..additional_attribute, string.gsub(content, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
    else
      presetcontent=nil      
    end
    reaper.SetProjExtState(0, "PodcastMetaData", attributename, content)
  else
    -- get state
    if preset_slot~=nil then
      local old_errorcounter = ultraschall.CountErrorMessages()
      presetcontent=ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, attributename, "ultraschall_podcast_presets.ini")
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetPodcast_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      presetcontent=string.gsub(presetcontent, "\\n", "\n")
    end
    _, content=reaper.GetProjExtState(0, "PodcastMetaData", attributename)
  end
  return true, content, presetcontent
end

ultraschall.EpisodeAttributes={"epsd_title", 
              "epsd_sponsor",
              "epsd_sponsor_url",
              "epsd_number",
              "epsd_season", 
              "epsd_release_date",
              "epsd_release_time",
              "epsd_release_timezone",
              "epsd_tagline",
              "epsd_description",
              "epsd_cover",
              "epsd_language", 
              "epsd_explicit",
              "epsd_descriptive_tags",
              "epsd_content_notification_tags",
              "epsd_url",
              }

function ultraschall.GetSetPodcastEpisode_Attributes(is_set, attributename, additional_attribute, content, preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcastEpisode_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content, optional string presetcontent = ultraschall.GetSetPodcastEpisode_Attributes(boolean is_set, string attributename, string content, optional integer preset_slot)</functioncall>
  <description>
    Will get/set metadata-attributes for a podcast-episode.
    
    This is about the individual podcast-episode, NOT the global podcast itself..
    
    For podcast's-metadata, use [GetSetPodcast\_Attributes](#GetSetPodcast_Attributes)
    
    preset-values will be stored into ressourcepath/ultraschall\_podcast\_presets.ini
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "epsd_title" - the title of the episode
                         - "epsd_number" - the number of the episode
                         - "epsd_season" - the season of the episode
                         - "epsd_release_date" - releasedate of the episode; yyyy-mm-dd
                         - "epsd_release_time" - releasedate of the episode; hh:mm:ss
                         - "epsd_release_timezone" - the time's timezone in UTC of the release-time
                         - "epsd_tagline" - the tagline of the episode
                         - "epsd_description" - the descriptionof the episode
                         - "epsd_cover" - the cover-image of the episode(path+filename)
                         - "epsd_language" - the language of the episode; Languagecode according to ISO639
                         - "epsd_explicit" - yes, if explicit; no, if not explicit
                         - "epsd_descriptive_tags" - some tags, that describe the content of the episode, must separated by newlines
                         - "epsd_sponsor" - the name of the sponsor of this episode
                         - "epsd_sponsor_url" - a link to the sponsor's website
                         - "epsd_content_notification_tags" - some tags, that warn of specific content; must be separated by newlines!
    string additional_attribute - some attributes allow additional attributes to be set; in all other cases set to ""
    string content - the new contents to set the attribute
    optional integer preset_slot - the slot in the podcast-presets to get/set the value from/to; nil, no preset used
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
    optional string presetcontent - the content of the preset's value in the preset_slot
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, podcast, episode, attributes</tags>
</US_DocBloc>
]]
  -- check for errors in parameter-values
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "is_set", "must be a boolean", -1) return false end  
  if preset~=nil and math.type(preset)~="integer" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "preset", "must be either nil or an integer", -2) return false end    
  if preset~=nil and preset<=0 then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "preset", "must be higher than 0", -3) return false end 
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "attributename", "must be a string", -4) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "content", "must be a string", -5) return false end  
  if type(additional_attribute)~="string" then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "additional_attribute", "must be a string", -6) return false end
  
  -- check, if passed attributes are supported
  local tags=ultraschall.EpisodeAttributes
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local retval
  
  -- management additional additional attributes for some attributes(currently not used, so I keep some defaults in here)
  --[[
  if attributename=="podcast_feed" then
    if additional_attribute:lower()~="mp3" and
       additional_attribute:lower()~="aac" and
       additional_attribute:lower()~="opus" and
       additional_attribute:lower()~="ogg" and
       additional_attribute:lower()~="flac"
       then
      ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "additional_attribute", "attributename \"podcast_feed\" needs content_attibute being set to the audioformat(mp3, ogg, opus, aac, flac)", -10) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_website" then
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "additional_attribute", "attributename \"podcast_website\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -11) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  elseif attributename=="podcast_donate" then
    if math.tointeger(additional_attribute)==nil or math.tointeger(additional_attribute)<1 then
      ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "additional_attribute", "attributename \"podcast_donate\" needs content_attibute being set to an integer >=1(as counter for potentially multiple websites of the podcast)", -11) 
      return false 
    elseif additional_attribute~="" then
      additional_attribute="_"..additional_attribute
    end
  else
    additional_attribute=""
  end
  --]]
  
  if found==false then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "attributename", "attributename not supported", -7) return false end
  local presetcontent, _
  --if attributename=="image_content" and content:sub(1,6)~="ÿØÿ" and content:sub(2,4)~="PNG" then ultraschall.AddErrorMessage("GetSetShownoteMarker_Attributes", "content", "image_content: only png and jpg are supported", -6) return false end
  
  if is_set==true then
    -- set state
    if preset_slot~=nil then
      content=string.gsub(content, "\r", "")
      retval = ultraschall.SetUSExternalState("EpisodeMetaData_"..preset_slot, attributename..additional_attribute, string.gsub(content, "\n", "\\n"), "ultraschall_podcast_presets.ini")
      if retval==false then ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "", "can not write to ultraschall_podcast_presets.ini", -8) return false end
      presetcontent=content
    else
      presetcontent=nil      
    end
    reaper.SetProjExtState(0, "EpisodeMetaData", attributename, content)
  else
    -- get state
    if preset_slot~=nil then
      local old_errorcounter = ultraschall.CountErrorMessages()
      presetcontent=ultraschall.GetUSExternalState("EpisodeMetaData_"..preset_slot, attributename, "ultraschall_podcast_presets.ini")
      if old_errorcounter~=ultraschall.CountErrorMessages() then
        ultraschall.AddErrorMessage("GetSetPodcastEpisode_Attributes", "", "can not retrieve value from ultraschall_podcast_presets.ini", -9)
        return false
      end
      presetcontent=string.gsub(presetcontent, "\\n", "\n")
    end
    _, content=reaper.GetProjExtState(0, "EpisodeMetaData", attributename)
  end
  return true, content, presetcontent
end


function ultraschall.GetPodcastShownote_MetaDataEntry(shownote_idx, shownote_index_in_metadata, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastShownote_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string shownote_entry = ultraschall.GetPodcastShownote_MetaDataEntry(integer shownote_idx, integer shownote_index_in_metadata, number offset)</functioncall>
  <description>
    returns the metadata-entry of a shownote
    
    The offset allows to offset the starttimes of a shownote-marker. 
    For instance, for files that aren't rendered from projectstart but from position 33.44, this position should be passed as offset
    so the shownote isn't at the wrong position.
    
    Also helpful for podcasts rendered using region-rendering.    

    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, shownote returned; false, shownote not returned
    string shownote_entry - the created shownote-entry for this shownote, according to PODCAST_METADATA:"v1"-standard
  </retvals>
  <parameters>
    integer shownote_idx - the index of the shownote to return
    integer shownote_index_in_metadata - the index, that shall be inserted into the metadata
                                       - this is for cases, where shownote #4 would be the first shownote in the file(region-rendering),
                                       - so you would want it indexed as shownote 1 NOT shownote 4.
                                       - in that case, set this parameter to 1, wheras shownote_idx would be 4
                                       - 
                                       - If you render out the project before the first shownote and after the last one(entire project), 
                                       - simply make shownote_idx=shownote_index_in_metadata
    number offset - the offset in seconds to subtract from the shownote-position(see description for details); set to 0 for no offset; must be 0 or higher
  </parameters>  
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, get, shownote, reaper metadata</tags>
</US_DocBloc>
]]
  if math.type(shownote_idx)~="integer" then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "shownote_idx", "must be an integer", -1) return false end
  if shownote_idx<0 then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "shownote_idx", "must be bigger than 0", -2) return false end
  if math.type(shownote_index_in_metadata)~="integer" then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "shownote_index_in_metadata", "must be an integer", -3) return false end
  if shownote_index_in_metadata<0 then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "shownote_index_in_metadata", "must be bigger than 0", -4) return false end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "offset", "must be a number", -5) return false end
  if offset<0 then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "offset", "must be bigger than 0", -6) return false end
  local retval, marker_index, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(shownote_idx)
  if retval==false then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "shownote_idx", "no such shownote", -7) return false end
  
  -- WARNING!! CHANGES HERE MUST REFLECT CHANGES IN GetSetShownoteMarker_Attributes() !!!
  local Tags=ultraschall.ShowNoteAttributes
  
  pos=pos-offset
  if pos<0 then ultraschall.AddErrorMessage("GetPodcastShownote_MetaDataEntry", "offset", "shownote-position minus offset is smaller than 0", -8) return false end
  name=string.gsub(name, "\\", "\\\\")
  name=string.gsub(name, "\"", "\\\"")
  --name=string.gsub(name, "\n", "\\n")

  local Shownote_String="  pos:\""..pos.."\" \n  title:\""..name.."\" "
  local temp, retval, gap

  for i=1, #Tags do    
    retval, temp = ultraschall.GetSetShownoteMarker_Attributes(false, shownote_idx, Tags[i], "")
    local gap=""
    for a=0, Tags[i]:len() do
     gap=gap.." "
    end
    if temp=="" or retval==false then 
      temp="" 
    else 
      temp=string.gsub(temp, "\r", "")
      temp=string.gsub(temp, "\"", "\\\"")
      temp=string.gsub(temp, "\n", "\"\n  "..gap.."\"")
      
      temp="\n  "..Tags[i]..":\""..temp.."\"" 
      temp=temp.." "
    end
      
    Shownote_String=Shownote_String..temp
  end


  Shownote_String="PODCAST_SHOWNOTE:\"BEG\"\n  idx:\""..shownote_index_in_metadata.."\"\n"..Shownote_String.."\nPODCAST_SHOWNOTE:\"END\""
  --print2(Shownote_String)
  
  return true, Shownote_String
end
 
ultraschall.ChapterAttributes={
              "chap_description",
              "chap_url",
              "chap_url_description",              
              "chap_descriptive_tags",
              "chap_is_advertisement",
              "chap_content_notification_tags",
              "chap_spoiler_alert",
              "chap_next_chapter_numbers",
              "chap_previous_chapter_numbers",
              "chap_image",
              "chap_image_description",
              "chap_image_license",
              "chap_image_origin",
              "chap_image_url"
              }


function ultraschall.GetSetChapterMarker_Attributes(is_set, idx, attributename, content, planned)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetChapterMarker_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetChapterMarker_Attributes(boolean is_set, integer idx, string attributename, string content, optional boolean planned)</functioncall>
  <description>
    Will get/set additional attributes of a chapter-marker.
        
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer idx - the index of the chapter-marker, whose attribute you want to get; 1-based
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "chap_url" - the url for this chapter(check first, if a shownote is not suited better for the task!)
                         - "chap_url_description" - a description for this url
                         - "chap_description" - a description of the content of this chapter
                         - "chap_is_advertisement" - yes, if this chapter is an ad; "", to unset it
                         - "chap_image" - the content of the chapter-image, either png or jpg
                         - "chap_image_description" - a description for the chapter-image
                         - "chap_image_license" - the license of the chapter-image
                         - "chap_image_origin" - the origin of the chapterimage, like an institution or similar 
                         - "chap_image_url" - the url that links to the chapter-image
                         - "chap_descriptive_tags" - some tags, that describe the chapter-content, must separated by newlines
                         - "chap_content_notification_tags" - some tags, that warn of specific content; must be separated by newlines!
                         - "chap_spoiler_alert" - "yes", if spoiler; "", if no spoiler
                         - "chap_next_chapter_numbers" - decide, which chapter could be the next after this one; 
                                                       - format is: "chap_number:description\nchap_number:description\n"
                                                       - chap_number is the number of the chapter in timeline-order
                                                       - it's possible to set multiple chapters as the next chapters; chap_number is 0-based
                                                       - this can be used for non-linear podcasts, like "choose your own adventure"
                         - "chap_previous_chapter_numbers" - decide, which chapter could be the previous before this one
                                                       - format is: "chap_number:description\nchap_number:description\n"
                                                       - chap_number is the number of the chapter in timeline-order
                                                       - it's possible to set multiple chapters as the previous chapters; chap_number is 0-based
                                                       - this can be used for non-linear podcasts, like "choose your own adventure"
    string content - the new contents to set the attribute with
    optional boolean planned - true, get/set this attribute with planned marker; false or nil, get/set this attribute with normal marker(chapter marker)
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
  </retvals>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, set, attribute, chapter, url</tags>
</US_DocBloc>
]]
-- TODO: check for chapter-image-content, if it's png or jpg!!
--       is the code still existing in shownote images so I can copy it?
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "is_set", "must be a boolean", -1) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "idx", "must be an integer", -2) return false end  
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "attributename", "must be a string", -3) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "content", "must be a string", -4) return false end  
  
  local tags=ultraschall.ChapterAttributes
  local retval
  
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  if attributename=="chap_url" then attributename="url" end
  
  if found==false then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "attributename", "attributename not supported", -7) return false end
  if planned~=true then
    idx=ultraschall.EnumerateNormalMarkers(idx)
  else
    retval, idx=ultraschall.EnumerateCustomMarkers("Planned", idx-1)
    idx=idx+1
  end
    
  if idx<1 then ultraschall.AddErrorMessage("GetSetChapterMarker_Attributes", "idx", "no such chapter-marker", -8) return false end
  local content2
  if is_set==false then    
    local B=ultraschall.GetMarkerExtState(idx, attributename)
    if B==nil then B="" end
    --if attributename=="chap_image" then
--      B=ultraschall.Base64_Decoder(B)
    --end
    return true, B
  elseif is_set==true then
    if attributename=="chap_image" then
      --content2=ultraschall.Base64_Encoder(content)
    else
      --content2=content
    end
    print2(content:sub(1,1000))
    return ultraschall.SetMarkerExtState(idx, attributename, content)~=-1, content
  end
end




function ultraschall.GetSetPodcastExport_Attributes_String(is_set, attribute, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcastExport_Attributes_String</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetPodcastExport_Attributes_String(boolean is_set, string attributename, string content)</functioncall>
  <description>
    Will get/set attributes for podcast-export.
    
    Unset-values will be returned as "" when is_set=false
    
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "output_mp3" - the renderstring of mp3
                         - "output_opus" - the renderstring of opus
                         - "output_ogg" - the renderstring of ogg
                         - "output_wav" - the renderstring of wav
                         - "output_wav_multitrack" - the renderstring of wav-multitrack
                         - "output_flac" - the renderstring of flac
                         - "output_flac_multitrack" - the renderstring of flac-multitrack
                         - "path" - the render-output-path
                         - "filename" - the filename of the rendered file
    string content - the new contents to set the attribute with
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
  </retvals>
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, set, attribute, export, string</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "is_set", "must be a boolean", -1) return false end  
  if type(attribute)~="string" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "attributename", "must be a string", -2) return false end  
  if is_set==true and type(value)~="string" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "must be a string", -3) return false end  
  
  local tags={"output_mp3",
              "output_opus",
              "output_ogg",
              "output_wav",
              "output_wav_multitrack",
              "output_flac",
              "output_flac_multitrack",
              "path",
              "filename"
                          }
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local _retval
  
  if is_set==false then
    _retval, value=reaper.GetProjExtState(0, "Ultraschall_Podcast_Render_Attributes", attribute)
  elseif is_set==true then
    -- validation checks
    if attribute=="path" and ultraschall.DirectoryExists2(value)==false then
      ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "path: not a valid path", -4)
    else
      if value:sub(-1,-1)~=ultraschall.Separator then
        value=value..ultraschall.Separator
      end
    end
    if attribute=="output_mp3" and ultraschall.GetRenderCFG_Settings_MP3(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_mp3: not a valid mp3-renderstring", -20) return false end  
    if attribute=="output_opus" and ultraschall.GetRenderCFG_Settings_OPUS(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_opus: not a valid opus-renderstring", -21) return false end  
    if attribute=="output_ogg" and ultraschall.GetRenderCFG_Settings_OGG(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_ogg: not a valid ogg-renderstring", -22) return false end  
    if attribute=="output_wav" and ultraschall.GetRenderCFG_Settings_WAV(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_wav: not a valid wav-renderstring", -23) return false end  
    if attribute=="output_wav_multitrack" and ultraschall.GetRenderCFG_Settings_WAV(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_wav_multitrack: not a valid wav-renderstring", -23) return false end  
    if attribute=="output_flac" and ultraschall.GetRenderCFG_Settings_FLAC(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_flac: not a valid flac-renderstring", -24) return false end  
    if attribute=="output_flac_multitrack" and ultraschall.GetRenderCFG_Settings_FLAC(value)==-1 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_String", "value", "output_flac_multitrack: not a valid flac-renderstring", -24) return false end  
    _retval=reaper.SetProjExtState(0, "Ultraschall_Podcast_Render_Attributes", attribute, value)
  end
  
  return true, value
end

function ultraschall.GetSetPodcastExport_Attributes_Value(is_set, attribute, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetPodcastExport_Attributes_Value</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>boolean retval, number content = ultraschall.GetSetPodcastExport_Attributes_Value(boolean is_set, string attributename, number content)</functioncall>
  <description>
    Will get/set attributes for podcast-export.
    
    Unset-values will be returned as -1 when is_set=false
    
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "mono_stereo" - 0, export as mono-file; 1, export as stereo-file
                         - "add_rendered_files_to_tracks" - 0, don't add rendered files to project; 1, add rendered files to project
                         - "start_time" - the start-time of the area to render
                         - "end_time" - the end-time of the area to render
    number content - the new contents to set the attribute with
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    number content - the content of a specific attribute
  </retvals>
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>render management, get, set, attribute, export, value</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "is_set", "must be a boolean", -1) return false end  
  if type(attribute)~="string" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "attributename", "must be a string", -2) return false end  
  if is_set==true and type(value)~="number" then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "must be a number", -3) return false end  
  
  local tags={"mono_stereo",
              "add_rendered_files_to_tracks",
              "start_time",
              "end_time"
                          }
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  local _retval
  
  if is_set==false then
    _retval, value=reaper.GetProjExtState(0, "Ultraschall_Podcast_Render_Attributes", attribute)
    value=tonumber(value)
    if value==nil then value=-1 end
  elseif is_set==true then
    -- validation checks
    if attribute=="mono_stereo" and math.tointeger(value)==nil then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "mono_stereo: must be an integer", -4) return false end  
    if attribute=="mono_stereo" and (value<0 or value>1) then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "mono_stereo: must be between 0 and 1", -5) return false end  
    if attribute=="add_rendered_files_to_tracks" and math.tointeger(value)==nil then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "add_rendered_files_to_tracks: must be an integer", -6) return false end  
    if attribute=="add_rendered_files_to_tracks" and (value<0 or value>1) then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "add_rendered_files_to_tracks: must be between 0 and 1", -7) return false end  
    if attribute=="start_time" and value<0 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "value", "start_time: must be bigger than 0", -8) return false end  

    if attribute=="end_time" and value<0 then ultraschall.AddErrorMessage("GetSetPodcastExport_Attributes_Value", "end_time: value", "must be bigger than 0 and start_time", -9) return false end  
    
    _retval=reaper.SetProjExtState(0, "Ultraschall_Podcast_Render_Attributes", attribute, value)    
  end
  
  return true, value
end

function ultraschall.GetAllShownotes_MetaDataEntry(start_time, end_time, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllShownotes_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>integer number_of_shownotes, array shownote_entries = ultraschall.GetAllShownotes_MetaDataEntry(number start_time, number end_time, number offset)</functioncall>
  <description>
    gets the metadata-entries of all shownotes
    
    The offset allows to offset the starttimes of a shownote-marker. 
    For instance, for files that aren't rendered from projectstart but from position 33.44, this position should be passed as offset
    so the shownote isn't at the wrong position.
    
    Also helpful for podcasts rendered using region-rendering.
    
    returns false in case of an error
  </description>
  <retvals>
    integer number_of_shownotes - the number of added shownotes
    array shownote_entries - the individual shownote-entries
  </retvals>
  <parameters>
    number start_time - the start-time of the range, from which to get the shownotes
    number end_time - the end-time of the range, from which to get the shownotes
    number offset - the offset in seconds to subtract from the shownote-positions(see description for details); set to 0 for no offset; must be 0 or higher
  </parameters>  
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, get, all, shownote, reaper metadata</tags>
</US_DocBloc>
]]

  if type(start_time)~="number" then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "start_time", "must be a number", -1) return -1 end
  if start_time<0 then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "start_time", "must be bigger than 0", -2) return -1 end
  if type(end_time)~="number" then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "end_time", "must be a number", -3) return -1 end
  if start_time>end_time then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "end_time", "must be bigger than 0", -4) return -1 end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "offset", "must be a number", -5) return -1 end
  if offset<0 then ultraschall.AddErrorMessage("GetAllShownotes_MetaDataEntry", "offset", "must be bigger than 0", -6) return -1 end
  
  local A={}
  local counter=0
  for i=1, ultraschall.CountShownoteMarkers()-1 do
    local A1, A2, pos = ultraschall.EnumerateShownoteMarkers(i)
    if pos>=start_time and pos<=end_time then
      counter=counter+1
      retval, A[#A+1]=ultraschall.GetPodcastShownote_MetaDataEntry(i, counter, offset)
    end
  end
  return #A, A
end

--A,B=ultraschall.Commit4AllShownotes_ReaperMetadata(4, 7.1, 0, true, true, true, true)


--ultraschall.RemoveAllShownotes_ReaperMetaData(true, true, true, true)


function ultraschall.GetPodcastChapter_MetaDataEntry(chapter_idx, chapter_index_in_metadata, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastShownote_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string chapter_entry = ultraschall.GetPodcastChapter_MetaDataEntry(integer chapter_idx, integer chapter_index_in_metadata, number offset)</functioncall>
  <description>
    returns the metadata-entry of a chapter
    
    The offset allows to offset the starttimes of a chapter-marker. 
    For instance, for files that aren't rendered from projectstart but from position 33.44, this position should be passed as offset
    so the chapter isn't at the wrong position.
    
    Also helpful for podcasts rendered using region-rendering.

    Note: this will include the metadata of "normal markers", that are used as chapter-markers in Ultraschall!

    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, chapter committed; false, chapter not committed
    string chapter_entry - the created chapter-entry for this chapter, according to PODCAST_METADATA:"v1"-standard
  </retvals>
  <parameters>
    integer chapter_idx - the index of the chapter to commit
    integer chapter_index_in_metadata - the index, that shall be inserted into the metadata
                                       - this is for cases, where chapter #4 would be the first chapter in the file(region-rendering),
                                       - so you would want it indexed as chapter 1 NOT chapter 4.
                                       - in that case, set this parameter to 1, wheras chapter_idx would be 4
                                       - 
                                       - If you render out the project before the first chapter and after the last one(entire project), 
                                       - simply make chapter_idx=chapter_index_in_metadata
    number offset - the offset in seconds to subtract from the chapter-position(see description for details); set to 0 for no offset; must be 0 or higher
  </parameters>  
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, get, chapter, reaper metadata</tags>
</US_DocBloc>
]]
  if math.type(chapter_idx)~="integer" then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "chapter_idx", "must be an integer", -1) return false end
  if chapter_idx<0 then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "chapter_idx", "must be bigger than 0", -2) return false end
  if math.type(chapter_index_in_metadata)~="integer" then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "chapter_index_in_metadata", "must be an integer", -3) return false end
  if chapter_index_in_metadata<0 then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "chapter_index_in_metadata", "must be bigger than 0", -4) return false end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "offset", "must be a number", -5) return false end
  if offset<0 then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "offset", "must be bigger than 0", -6) return false end
  local retval, marker_index, pos, name, shown_number, color, guid = ultraschall.EnumerateNormalMarkers(chapter_idx)
  if retval==false then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "chapter_idx", "no such chapter", -7) return false end
  
  -- WARNING!! CHANGES HERE MUST REFLECT CHANGES IN GetSetChapterMarker_Attributes() !!!
  local Tags=ultraschall.ChapterAttributes
  
  pos=pos-offset
  if pos<0 then ultraschall.AddErrorMessage("GetPodcastChapter_MetaDataEntry", "offset", "chapter-position minus offset is smaller than 0", -8) return false end
  name=string.gsub(name, "\\", "\\\\")
  name=string.gsub(name, "\"", "\\\"")

  local Chapter_String="  pos:\""..pos.."\" \n  title:\""..name.."\" "
  local temp, retval, gap

  for i=1, #Tags do
    local retval, temp = ultraschall.GetSetChapterMarker_Attributes(false, chapter_idx, Tags[i], "")
    local gap=""
    for a=0, Tags[i]:len() do
     gap=gap.." "
    end
    if temp=="" then 
      temp="" 
    else 
      temp=string.gsub(temp, "\r", "")
      temp=string.gsub(temp, "\"", "\\\"")
      temp=string.gsub(temp, "\n", "\"\n  "..gap.."\"")

      temp="\n  "..Tags[i]..":\""..temp.."\"" 
      temp=temp.." "
    end
    
    Chapter_String=Chapter_String..temp
  end
  
  Chapter_String="PODCAST_CHAPTER:\"BEG\"\n  idx:\""..chapter_index_in_metadata.."\"\n"..Chapter_String.."\nPODCAST_CHAPTER:\"END\""
  
  return true, Chapter_String
end

function ultraschall.GetAllChapters_MetaDataEntry(start_time, end_time, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllChapters_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>integer number_of_chapters, array chapter_entries = ultraschall.GetAllChapters_MetaDataEntry(number start_time, number end_time, number offset)</functioncall>
  <description>
    gets all the metadata-entries of all chapters
    
    The offset allows to offset the starttimes of a chapter-marker. 
    For instance, for files that aren't rendered from projectstart but from position 33.44, this position should be passed as offset
    so the chapter isn't at the wrong position.
    
    Also helpful for podcasts rendered using region-rendering.
    
    Note: uses metadata stored with "normal markers", as they are used by Ultraschall for chapter-markers
    
    returns false in case of an error
  </description>
  <retvals>
    integer number_of_chapters - the number of added chapters
    array chapter_entries - the individual chapter-entries
  </retvals>
  <parameters>
    number start_time - the start-time of the range, from which to commit the chapters
    number end_time - the end-time of the range, from which to commit the chapters
    number offset - the offset in seconds to subtract from the chapter-positions(see description for details); set to 0 for no offset; must be 0 or higher
  </parameters>  
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, get, all, chapter, reaper metadata</tags>
</US_DocBloc>
]]

  if type(start_time)~="number" then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "start_time", "must be a number", -1) return -1 end
  if start_time<0 then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "start_time", "must be bigger than 0", -2) return -1 end
  if type(end_time)~="number" then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "end_time", "must be a number", -3) return -1 end
  if start_time>end_time then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "end_time", "must be bigger than 0", -4) return -1 end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "offset", "must be a number", -5) return -1 end
  if offset<0 then ultraschall.AddErrorMessage("GetAllChapters_MetaDataEntry", "offset", "must be bigger than 0", -6) return -1 end
  
  local A={}
  local counter=0
  for i=1, ultraschall.CountNormalMarkers() do
    local A1, A2, pos = ultraschall.EnumerateNormalMarkers(i)
    if pos>=start_time and pos<=end_time then
      counter=counter+1
      retval, A[#A+1]=ultraschall.GetPodcastChapter_MetaDataEntry(i, counter, offset)
    end
  end
  return #A, A
end

--A,B=ultraschall.GetAllChapters_MetaDataEntry(0, 1000, 0, true, true, true, true)
--B=ultraschall.CountNormalMarkers()








function ultraschall.SetPodcastAttributesPreset_Name(preset_slot, preset_name)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPodcastAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetPodcastAttributesPreset_Name(integer preset_slot, string preset_name)</functioncall>
  <description>
    Sets the name of a podcast-metadata-preset
        
    Note, this sets only the presetname for the podcast-metadata-preset. To set the name of the podcast-episode-metadata-preset, see: [SetPodcastEpisodeAttributesPreset\_Name](#SetPodcastEpisodeAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to set
    string preset_name - the new name of the preset
  </parameters>
  <retvals>
    boolean retval - true, if setting the name was successful; false, if setting the name was unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, set, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  if type(preset_name)~="string" then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_name", "must be a string", -3) return false end
  
  local retval = ultraschall.SetUSExternalState("PodcastMetaData_"..preset_slot, "Preset_Name", preset_name, "ultraschall_podcast_presets.ini")
  if retval==false then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "", "couldn't store presetname in ultraschall_podcast_presets.ini; is it accessible?", -3) return false end
end
  

--ultraschall.SetPodcastAttributesPreset_Name(1, "Atuch")

function ultraschall.GetPodcastAttributesPreset_Name(preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string preset_name = ultraschall.GetPodcastAttributesPreset_Name(integer preset_slot)</functioncall>
  <description>
    Gets the name of a podcast-metadata-preset
        
    Note, this gets only the presetname for the podcast-metadata-preset. To get the name of the podcast-episode-metadata-preset, see: [GetPodcastEpisodeAttributesPreset\_Name](#GetPodcastEpisodeAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to get
  </parameters>
  <retvals>
    string preset_name - the name of the podcast-metadata-preset
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("SetPodcastAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  
  return ultraschall.GetUSExternalState("PodcastMetaData_"..preset_slot, "Preset_Name", "ultraschall_podcast_presets.ini")
end

--A,B=ultraschall.GetPodcastAttributesPreset_Name(1)

function ultraschall.SetPodcastEpisodeAttributesPreset_Name(preset_slot, presetname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPodcastEpisodeAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetPodcastEpisodeAttributesPreset_Name(integer preset_slot, string preset_name)</functioncall>
  <description>
    Sets the name of a podcast-episode-metadata-preset
    
    Note, this sets only the presetname for the episode-metadata-preset. To set the name of the podcast-metadata-preset, see: [SetPodcastAttributesPreset\_Name](#SetPodcastAttributesPreset_Name)
    
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to set
    string preset_name - the new name of the preset
  </parameters>
  <retvals>
    boolean retval - true, if setting the name was successful; false, if setting the name was unsuccessful
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, set, podcast, metadata, preset, name, episode</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  if type(presetname)~="string" then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "preset_name", "must be a string", -3) return false end
  
  local retval = ultraschall.SetUSExternalState("Episode_"..preset_slot, "Preset_Name", presetname, "ultraschall_podcast_presets.ini")
  if retval==false then ultraschall.AddErrorMessage("SetPodcastEpisodeAttributesPreset_Name", "", "couldn't store presetname in ultraschall_podcast_presets.ini; is it accessible?", -3) return false end
  return true
end
  

--A=ultraschall.SetPodcastEpisodeAttributesPreset_Name(1, "AKullerauge sei wachsam")

function ultraschall.GetPodcastEpisodeAttributesPreset_Name(preset_slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastEpisodeAttributesPreset_Name</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string preset_name = ultraschall.GetPodcastEpisodeAttributesPreset_Name(integer preset_slot)</functioncall>
  <description>
    Gets the name of a podcast-metadata-preset
        
    Note, this gets only the presetname for the episode-metadata-preset. To get the name of the podcast-metadata-preset, see: [GetPodcastAttributesPreset\_Name](#GetPodcastAttributesPreset_Name)
        
    returns false in case of an error
  </description>
  <parameters>
    integer preset_slot - the preset-slot, whose name you want to get
  </parameters>
  <retvals>
    string preset_name - the name of the podcast-metadata-preset
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, preset, name</tags>
</US_DocBloc>
]]
  if math.type(preset_slot)~="integer" then ultraschall.AddErrorMessage("GetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be an integer", -1) return false end
  if preset_slot<1 then ultraschall.AddErrorMessage("GetPodcastEpisodeAttributesPreset_Name", "preset_slot", "must be bigger or equal 1", -2) return false end
  
  return ultraschall.GetUSExternalState("Episode_"..preset_slot, "Preset_Name", "ultraschall_podcast_presets.ini")
end

--A,B=ultraschall.GetPodcastEpisodeAttributesPreset_Name(1)

function ultraschall.GetPodcastEpisode_MetaDataEntry()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastEpisode_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string episode_entry = ultraschall.GetPodcastEpisode_MetaDataEntry()</functioncall>
  <description>
    Returns the podcast-metadata-standard-entry of an episode
  </description>
  <retvals>
    string episode_entry - the created podcast-episode-entry for this project, according to PODCAST_METADATA:"v1"-standard
  </retvals>
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, episode, podcast, reaper metadata</tags>
</US_DocBloc>
]]
  local Tags=ultraschall.EpisodeAttributes

  local Episode_String=""
  local temp

  for i=1, #Tags do
    local retval, temp = ultraschall.GetSetPodcastEpisode_Attributes(false, Tags[i], "", "")
    local gap=""
    for a=0, Tags[i]:len() do
     gap=gap.." "
    end
    if temp=="" then 
      temp="" 
    else 
      temp=string.gsub(temp, "\r", "")
      temp=string.gsub(temp, "\"", "\\\"")
      temp=string.gsub(temp, "\n", "\"\n  "..gap.."\"")

      temp="\n  "..Tags[i]..":\""..temp.."\"" 
      temp=temp.." "
    end
      
    Episode_String=Episode_String..temp
  end


  Episode_String="PODCAST_EPISODE:\"BEG\" "..Episode_String.."\nPODCAST_EPISODE:\"END\""

  return Episode_String
end

function ultraschall.GetPodcast_MetaDataEntry()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcast_MetaDataEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>string podcast_entry = ultraschall.GetPodcast_MetaDataEntry()</functioncall>
  <description>
    Returns the podcast-metadata-standard-entry with the general podcast-attributes
  </description>
  <retvals>
    string podcast_entry - the created podcast-entry for this project, according to PODCAST_METADATA:"v1"-standard
  </retvals>
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, podcast, reaper metadata</tags>
</US_DocBloc>
]]
  local Tags=ultraschall.PodcastAttributes

  local Podcast_String=""
  local temp

  for i=1, #Tags do
    local retval, temp = ultraschall.GetSetPodcast_Attributes(false, Tags[i], "", "")
    local gap=""
    for a=0, Tags[i]:len() do
     gap=gap.." "
    end
    if temp=="" then 
      temp="" 
    else 
      temp=string.gsub(temp, "\r", "")
      temp=string.gsub(temp, "\"", "\\\"")
      temp=string.gsub(temp, "\n", "\"\n  "..gap.."\"")

      temp="\n  "..Tags[i]..":\""..temp.."\"" 
      temp=temp.." "
    end
    
    Podcast_String=Podcast_String..temp
  end


  Podcast_String="PODCAST_GENERAL:\"BEG\" "..Podcast_String.."\nPODCAST_GENERAL:\"END\""

  return Podcast_String
end


function ultraschall.WritePodcastMetaData(start_time, end_time, offset, filename, do_id3, do_vorbis, do_ape_deactivated, do_ixml_deactivated)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WritePodcastMetaData</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.47
    Lua=5.3
  </requires>
  <functioncall>string podcast_metadata = ultraschall.WritePodcastMetaData(number start_time, number end_time, number offset, optional string filename, optional boolean do_id3, optional boolean do_vorbis)</functioncall>
  <description>
    Creates and returns the metadata-file-entries according to PODCAST_METADATA:"v1"-standard and optionally stores it into a file and/or the accompanying metadata-schemes available.
    
    Includes shownotes and chapters as well as episode and podcast-general-metadata
    
    Note: needs Reaper 6.47 to work properly, as otherwise the metadata gets truncated to 1k!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string podcast_metadata - the created podcast-metadata, according to PODCAST_METADATA:"v1"-standard
  </retvals>
  <parameters>
    number start_time - the start-time of the project, from which to include chapters/shownotes
    number end_time - the end-time of the project, up to which to include chapters/shownotes
    number offset - the offset to subtract from the chapter/shownote-positions(for time-selection/region rendering)
    optional string filename - the filename, to which to write the metadata-data as PODCAST_METADATA:"v1"-standard
    optional boolean do_id3 - add the metadata to id3(mp3)-tag-metadata scheme in Reaper's metadata-storage
    optional boolean do_vorbis - add the metadata to the vorbis(Mp3, Flac, Ogg, Opus)-metadata scheme in Reaper's metadata-storage
  </parameters>
  <chapter_context>
     Rendering Projects
     Ultraschall
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
  <tags>marker management, write, podcast, reaper metadata, shownotes, chapters, id3, ape, vorbis, ixml</tags>
</US_DocBloc>
]]
  if type(start_time)~="number" then ultraschall.AddErrorMessage("WritePodcastMetaData", "start_time", "must be a number", -1) return end
  if start_time<0 then ultraschall.AddErrorMessage("WritePodcastMetaData", "start_time", "must be bigger than 0", -2) return end
  if type(end_time)~="number" then ultraschall.AddErrorMessage("WritePodcastMetaData", "end_time", "must be a number", -3) return end
  if start_time>end_time then ultraschall.AddErrorMessage("WritePodcastMetaData", "end_time", "must be bigger than 0", -4) return end
  
  if type(offset)~="number" then ultraschall.AddErrorMessage("WritePodcastMetaData", "offset", "must be a number", -5) return end
  if offset<0 then ultraschall.AddErrorMessage("WritePodcastMetaData", "offset", "must be bigger than 0", -6) return end
  
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("WritePodcastMetaData", "filename", "must be nil or a string", -7) return end
  
  local retval
  local PodcastGeneralMetadata=ultraschall.GetPodcast_MetaDataEntry()
  local PodcastEpisodeMetadata=ultraschall.GetPodcastEpisode_MetaDataEntry()
  local Chapter_Count,  Chapters = ultraschall.GetAllChapters_MetaDataEntry(start_time, end_time, offset)
  local Shownote_Count, Shownotes = ultraschall.GetAllShownotes_MetaDataEntry(start_time, end_time, offset)
  
  local PodcastMetadata="  "..PodcastGeneralMetadata.."\n\n"..PodcastEpisodeMetadata.."\n"
  
  for i=1, Chapter_Count do
    PodcastMetadata=PodcastMetadata.."\n"..Chapters[i].."\n"
  end
  
  for i=1, Shownote_Count do
    PodcastMetadata=PodcastMetadata.."\n"..Shownotes[i].."\n"
  end
  --"PODCAST_METADATA:\"v1\""
  
  PodcastMetadata="PODCAST_METADATA:\"v1\"\n"..string.gsub(PodcastMetadata, "\n", "\n  "):sub(1,-3).."\nPODCAST_METADATA:\"end\""
  
  if filename~=nil then 
    local errorindex = ultraschall.GetErrorMessage_Funcname("WriteValueToFile", 1)
    retval=ultraschall.WriteValueToFile(filename, PodcastMetadata)
    
    if retval==-1 then 
      local errorindex2, parmname, errormessage = ultraschall.GetErrorMessage_Funcname("WriteValueToFile", 1)
      ultraschall.AddErrorMessage("WritePodcastMetaData", "filename", errormessage, -8) 
      return 
    end
  end
  
  if do_id3==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "ID3:TXXX:Podcast_Metadata|"..PodcastMetadata, true)
  end
  
  if do_vorbis==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "VORBIS:USER:Podcast_Metadata|"..PodcastMetadata, true)
  end
  
  if do_ape==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "APE:User Defined:Podcast_Metadata|"..PodcastMetadata, true)
  end
  
  if do_ixml==true then
    reaper.GetSetProjectInfo_String(0, "RENDER_METADATA", "IXML:USER:Podcast_Metadata|"..PodcastMetadata, true)
  end
  
  return PodcastMetadata
end







function ultraschall.GFX_BlitBBCodeAsText(text)
  -- example code, that parses and shows BBCode, with [b][i] and [u], even combined.
  
  -- missing: img, url, size, color
  --      maybe: indent(?), lists(bullet only)
  
  -- blit-image-destinations
  
  -- return coordinates of blitted urls and images, so they can be checked for clickable-state/tooltips
  -- by GFX_ManageBlitBBCodeElements
  
  gfx.set(1)
  local ParsedStrings={}
  local Link_Coordinates={} -- the coordinates of links currently shown
                            -- so making them "clickable" is possible
                            -- not yet filled, so this must be coded as well
  
  local step=0
  local Temp, Offset
  
  while TestString~=nil do
    step=step+1
    Temp=TestString:match("(.-)%[")
    if Temp==nil then break end
    ParsedStrings[step]={}
    ParsedStrings[step]["text"]=Temp
    TestString=TestString:sub(Temp:len(), -1)
    
    Temp, Offset = TestString:match("%[(.-)%]()")
  
    ParsedStrings[step]["layout_element"]=Temp
    TestString=TestString:sub(Offset, -1)

  end
  
  Temp=TestString:match("(.*)")
  ParsedStrings[step]={}
  ParsedStrings[step]["text"]=Temp
  ParsedStrings[step]["layout_element"]=""
  
  
  ParsedStrings[1]["bold"]=false
  ParsedStrings[1]["italic"]=false
  ParsedStrings[1]["underlined"]=false
  
  for i=1, #ParsedStrings do
    if ParsedStrings[i]["layout_element"]=="b" then
      ParsedStrings[i+1]["bold"]=true
      ParsedStrings[i+1]["italic"]=ParsedStrings[i]["italic"]
      ParsedStrings[i+1]["underlined"]=ParsedStrings[i]["underlined"]
    elseif ParsedStrings[i]["layout_element"]=="/b" then
      ParsedStrings[i+1]["bold"]=false
      ParsedStrings[i+1]["italic"]=ParsedStrings[i]["italic"]
      ParsedStrings[i+1]["underlined"]=ParsedStrings[i]["underlined"]
    elseif ParsedStrings[i]["layout_element"]=="i" then
      ParsedStrings[i+1]["italic"]=true
      ParsedStrings[i+1]["bold"]=ParsedStrings[i]["bold"]
      ParsedStrings[i+1]["underlined"]=ParsedStrings[i]["underlined"]
    elseif ParsedStrings[i]["layout_element"]=="/i" then
      ParsedStrings[i+1]["italic"]=false
      ParsedStrings[i+1]["bold"]=ParsedStrings[i]["bold"]
      ParsedStrings[i+1]["underlined"]=ParsedStrings[i]["underlined"]
    elseif ParsedStrings[i]["layout_element"]=="u" then
      ParsedStrings[i+1]["underlined"]=true
      ParsedStrings[i+1]["bold"]=ParsedStrings[i]["bold"]
      ParsedStrings[i+1]["italic"]=ParsedStrings[i]["italic"]
    elseif ParsedStrings[i]["layout_element"]=="/u" then
      ParsedStrings[i+1]["underlined"]=false
      ParsedStrings[i+1]["bold"]=ParsedStrings[i]["bold"]
      ParsedStrings[i+1]["italic"]=ParsedStrings[i]["italic"]
    end
    ParsedStrings[i]["layout_element"]=""
  end
  
  
  for i=1, #ParsedStrings do
    local layout=ultraschall.GFX_GetTextLayout(ParsedStrings[i]["bold"], ParsedStrings[i]["italic"], ParsedStrings[i]["underlined"], outline, nonaliased, inverse, rotate, rotate2)
    gfx.setfont(1, "Tahoma", 40, layout)
    if ParsedStrings[i]["text"]:match("\n")~=nil then
      local A=ParsedStrings[i]["text"].."\n"
      gfx.drawstr(A:match("(.-)\n"))
      gfx.x=0
      gfx.y=gfx.y+gfx.texth+2
      gfx.drawstr(A:match("\n(.*)"))
    else
      gfx.drawstr(ParsedStrings[i]["text"])
    end
  end
  --gfx.update()

  return Link_Coordinates
end  

  
--gfx.set(0.1)
--gfx.rect(0,0,gfx.w,gfx.h,1)
--ultraschall.GFX_BlitBBCodeAsText(TestString)



function ultraschall.GetSetTranscription_Attributes(is_set, idx, attributename, content)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetTranscription_Attributes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string content = ultraschall.GetSetTranscription_Attributes(boolean is_set, integer idx, string attributename, string content)</functioncall>
  <description>
    Will get/set additional attributes of a transcription.
    
    A podcast can have multiple transcriptions in multiple languages.
    
    Note: transcriptions are not created by Ultraschall, but can be included into the mediafile at export.
          For this, the file must be present locally.
    
    Note too: all attributes must be set; though "url" can be set to "", which means, it's stored in the same location as the media file or the podcast-metadata-exchange-file
    "transcript" is optional
    
    returns false in case of an error
  </description>
  <parameters>
    boolean is_set - true, set the attribute; false, retrieve the current content
    integer idx - the index of the transcript, whose attribute you want to get; 1-based
    string attributename - the attributename you want to get/set
                         - supported attributes are:
                         - "language" - the language of the transcription
                         - "description" - a more detailed description for this transcription
                         - "url" - the url where the webvtt/srt-file is stored; can be relative to the podcast-metadata-exchange-file/mediafile
                         - "transcript" - the actual transcript-content for inclusion into the metadata of the mediafile(only srt or webvtt!)
                         - "type" - srt or webvtt
    string content - the new contents to set the attribute with
  </parameters>
  <retvals>
    boolean retval - true, if the attribute exists/could be set; false, if not or an error occurred
    string content - the content of a specific attribute
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, set, attribute, transcription</tags>
</US_DocBloc>
]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetTranscription_Attributes", "is_set", "must be a boolean", -1) return false end  
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetSetTranscription_Attributes", "idx", "must be an integer", -2) return false end    
  if type(attributename)~="string" then ultraschall.AddErrorMessage("GetSetTranscription_Attributes", "attributename", "must be a string", -3) return false end  
  if is_set==true and type(content)~="string" then ultraschall.AddErrorMessage("GetSetTranscription_Attributes", "content", "must be a string", -4) return false end  
  
  
  -- WARNING!! CHANGES HERE MUST REFLECT CHANGES IN THE CODE OF CommitShownote_ReaperMetadata() !!!
  local tags=ultraschall.TranscriptAttributes
              
  local found=false
  for i=1, #tags do
    if attributename==tags[i] then
      found=true
      break
    end
  end
  
  if found==false then ultraschall.AddErrorMessage("GetSetTranscription_Attributes", "attributename", "attributename not supported", -7) return false end
  local Retval

  if is_set==true then
    Retval = reaper.SetProjExtState(0, "PodcastMetaData_Transcript_"..idx, attributename, content)
    return true, content
  else
    Retval, content = reaper.GetProjExtState(0, "PodcastMetaData_Transcript_"..idx, attributename, content)
    return true, content
  end
end



--A,B=ultraschall.SetTrackPlayOffsState(1, TrackStateChunk, 100, 2)


--index=1
--A=ultraschall.SetTemporaryMarker(4, index)
--B=ultraschall.GetTemporaryMarker(index)










function ultraschall.GetReaperWindow_Position()
-- TODO: CHECK ON LINUX AND MAC!!!
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperWindow_Position</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.965
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean maximized_window, integer x, integer y, integer right, integer bottom, integer height_main_toolbar, integer height_top_docker, integer width_left_docker, integer width_right_docker, integer height_bottom_docker = ultraschall.GetReaperWindow_Position()</functioncall>
  <description>
    returns the dimensions of the reaper-window and dimensions of various elements like docker.
  </description>
  <retvals>
    boolean maximized_window - true, window is maximized; false, window is not maximized
    integer x - x-position of reaper-window in pixels
    integer y - y-position of reaper-window in pixels
    integer right - right position of reaper-window in pixels
    integer bottom - bottom position of reaper-window in pixels
    integer height_main_toolbar - the height of the main-toolbar in pixels
    integer height_top_docker - the height of the top-docker in pixels
    integer width_left_docker - the width of the left-docker in pixels
    integer width_right_docker - the width of the right-docker in pixels
    integer height_bottom_docker - the height of the bottom-docker in pixels
  </retvals>
  <chapter_context>
    User Interface
    Reaper Main Window
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, arrange-view, position, hwnd, get</tags>
</US_DocBloc>
--]]
  local retval, left_dock = reaper.BR_Win32_GetPrivateProfileString("REAPER", "dockheight_l", "", reaper.get_ini_file())
  local retval, bottom_dock = reaper.BR_Win32_GetPrivateProfileString("REAPER", "dockheight", "", reaper.get_ini_file())
  local retval, top_dock = reaper.BR_Win32_GetPrivateProfileString("REAPER", "dockheight_t", "", reaper.get_ini_file())
  local retval, right_dock = reaper.BR_Win32_GetPrivateProfileString("REAPER", "dockheight_r", "", reaper.get_ini_file())
  local retval, main_toolbar = reaper.BR_Win32_GetPrivateProfileString("REAPER", "toppane", "", reaper.get_ini_file())
  local retval, tcp_width = reaper.BR_Win32_GetPrivateProfileString("REAPER", "leftpanewid", "", reaper.get_ini_file())
  local Hwnd=reaper.GetMainHwnd()
  local arrange=reaper.JS_Window_FindChildByID(Hwnd, 1000)
  local retval, x2, y2, w2, h2 = reaper.JS_Window_GetClientRect(arrange)

  local maximized
  local retval, x, y, w, h = reaper.JS_Window_GetRect(Hwnd) 
  if x==-4 and y==-4 then
    x=x+4
    y=y+4
    w=w-4
    maximized=true
  else
    maximized=false
    x=x+1
    y=y+1
    w=w-4
  end
  
  return maximized,
         x, -- x-position of Reaper
         y, -- y-position of Reaper
         w, -- x2-position of right of Reaper
         h, -- y2-position of bottom of Reaper
         
         math.tointeger(main_toolbar),-- height of the main_toolbar
         math.tointeger(top_dock),    -- height of top_docker(above Main ToolBar)
         math.tointeger(left_dock),   -- width of left docker
         math.tointeger(right_dock),  -- width of right docker
         math.tointeger(bottom_dock) -- height of the bottom docker
end

function ultraschall.GetTakeSourcePosByProjectPos(project_pos, take)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTakeSourcePosByProjectPos</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>number source_pos = ultraschall.GetTakeSourcePosByProjectPos(number project_pos, MediaItem_Take take)</functioncall>
  <description>
    returns the source-position of a take at a certain project-position. Will obey time-stretch-markers, offsets, etc, as well.
    
    Note: works only within item-start and item-end.
    
    Also note: when the active take of the parent-item is a different one than the one you've passed, this will temporarily switch the active take to the one you've passed.
    That could potentially cause audio-glitches!
    
    This function is expensive, so don't use it permanently!
    
    Returns nil in case of an error
  </description>
  <retvals>
    number source_pos - the position within the source of the take in seconds
  </retvals>
  <parameters>
    number project_pos - the project-position, from which you want to get the take's source-position
    MediaItem_Take take - the take, whose source-position you want to retrieve
  </parameters>
  <linked_to desc="see:">
    inline:GetProjectPosByTakeSourcePos
           gets the project-position by of a take-source-position
  </linked_to>
  <chapter_context>
    Mediaitem Take Management
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem takes, get, source position, project position</tags>
</US_DocBloc>
]]
-- TODO:
-- Rename AND Move(!) Take markers by a huge number of seconds instead of deleting them. 
-- Then add new temporary take-marker, get its position and then remove it again.
-- After that, move them back. That way, you could retain potential future guids in take-markers.
-- Needed workaround, as Reaper, also here, doesn't allow adding a take-marker using an action, when a marker already exists at the position...for whatever reason...

  -- check parameters
  if type(project_pos)~="number" then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "project_pos", "must be a number", -1) return end
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "take", "must be a valid MediaItem_Take", -2) return end
  local item = reaper.GetMediaItemTakeInfo_Value(take, "P_ITEM")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_pos_end = item_pos+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  if project_pos<item_pos or project_pos>item_pos_end then ultraschall.AddErrorMessage("GetTakeSourcePosByProjectPos", "project_pos", "must be within itemstart and itemend", -3) return end
  
  reaper.PreventUIRefresh(1)
  
  -- store item-selection and deselect all
  local count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(0),  ultraschall.CreateTrackString_AllTracks(), false)
  local retval = ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
  
  -- get current take-markers and rename them with TUDELU at the beginning
  local takemarkers={}
  for i=reaper.GetNumTakeMarkers(take)-1, 0, -1 do
    takemarkers[i+1]={reaper.GetTakeMarker(take, i)}
    --reaper.SetTakeMarker(take, i, "TUDELU"..takemarkers[i+1][2])
    reaper.DeleteTakeMarker(take, i)
  end
  
  -- add a new take-marker
  local oldpos=reaper.GetCursorPosition()
  reaper.SetEditCurPos(project_pos, false, false)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1)
  local active_take=reaper.GetActiveTake(item)
  reaper.SetActiveTake(take)
  reaper.Main_OnCommand(42390, 0)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
  reaper.SetActiveTake(active_take)
  reaper.SetEditCurPos(oldpos, false, false)
  
  -- get the position and therefore source-position of the added take-marker, then remove it again
  local found=nil
  for i=0, reaper.GetNumTakeMarkers(take) do
    local takemarker_pos, take_marker_name=reaper.GetTakeMarker(take, i)
    if take_marker_name=="" and takemarker_pos~=-1 then    
      reaper.DeleteTakeMarker(take, i)
      found=takemarker_pos
      break
    end
  end
  
  -- rename take-markers back to their old name
  for i=1, #takemarkers do
    reaper.SetTakeMarker(take, i-1, takemarkers[i][2], takemarkers[i][1], takemarkers[i][3])
    --)
  end
  
  -- reselect old item-selection
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  
  reaper.PreventUIRefresh(-1)
  return found
end


function ultraschall.GetProjectPosByTakeSourcePos(source_pos, take)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectPosByTakeSourcePos</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>number project_pos = ultraschall.GetProjectPosByTakeSourcePos(number source_pos, MediaItem_Take take)</functioncall>
  <description>
    returns the project-position-representation of the source-position of a take. 
    Will obey time-stretch-markers, offsets, etc, as well.
    
    Note: due API-limitations, you can only get the project position of take-source-positions 0 and higher, so no negative position is allowed.
    
    Also note: when the active take of the parent-item is a different one than the one you've passed, this will temporarily switch the active take to the one you've passed.
    That could potentially cause audio-glitches!
    
    This function is expensive, so don't use it permanently!
    
    Returns nil in case of an error
  </description>
  <linked_to desc="see:">
    inline:GetTakeSourcePosByProjectPos
           gets the take-source-position by project position
  </linked_to>
  <retvals>
    number project_pos - the project-position, converted from the take's source-position
  </retvals>
  <parameters>
    number source_pos - the position within the source of the take in seconds
    MediaItem_Take take - the take, whose source-position you want to retrieve
  </parameters>
  <chapter_context>
    Mediaitem Take Management
    Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_MediaItem_Module.lua</source_document>
  <tags>mediaitem takes, get, source position, project position</tags>
</US_DocBloc>
]]
-- TODO:
-- Rename AND Move(!) Take markers by a huge number of seconds instead of deleting them. 
-- Then add new temporary take-marker, get its position and then remove it again.
-- After that, move them back. That way, you could retain potential future guids in take-markers.
-- Needed workaround, as Reaper, also here, doesn't allow adding a take-marker using an action, when a marker already exists at the position...for whatever reason...

  -- check parameters
  if type(source_pos)~="number" then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "source_pos", "must be a number", -1) return end
  if ultraschall.type(take)~="MediaItem_Take" then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "take", "must be a valid MediaItem_Take", -2) return end
  if source_pos<0 then ultraschall.AddErrorMessage("GetProjectPosByTakeSourcePos", "source_pos", "must be 0 or higher", -3) return end
  local item = reaper.GetMediaItemTakeInfo_Value(take, "P_ITEM")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_pos_end = item_pos+reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  
  reaper.PreventUIRefresh(1)
  
  -- store item-selection and deselect all
  local count, MediaItemArray = ultraschall.GetAllSelectedMediaItemsBetween(0, reaper.GetProjectLength(0),  ultraschall.CreateTrackString_AllTracks(), false)
  local retval = ultraschall.DeselectMediaItems_MediaItemArray(MediaItemArray)
  
  -- get current take-markers and rename them with TUDELU at the beginning
  takemarkers={}
  for i=reaper.GetNumTakeMarkers(take)-1, 0, -1 do
    takemarkers[i+1]={reaper.GetTakeMarker(take, i)}
    --reaper.SetTakeMarker(take, i, "TUDELU"..takemarkers[i+1][2])
    reaper.DeleteTakeMarker(take, i)
  end
  
  -- set take-marker at source-position of take, select the take and use "next take marker"-action to go to it
  -- then get the cursor position to get the project-position
  -- and finally, delet the take marker reset the view and cursor-position
  local starttime, endtime = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  reaper.SetTakeMarker(take, -1, "", source_pos)
  local oldpos=reaper.GetCursorPosition()
  reaper.SetEditCurPos(-20, false, false)
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1)
  local active_take=reaper.GetActiveTake(item)
  reaper.SetActiveTake(take)
  reaper.Main_OnCommand(42394, 0)
  local projectpos=reaper.GetCursorPosition()
  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
  reaper.SetActiveTake(active_take)
  reaper.DeleteTakeMarker(take, 0)
  reaper.SetEditCurPos(oldpos, false, false)
  reaper.GetSet_ArrangeView2(0, true, 0, 0, starttime, endtime)

  -- rename take-markers back to their old name
  for i=1, #takemarkers do
    reaper.SetTakeMarker(take, i-1, takemarkers[i][2], takemarkers[i][1], takemarkers[i][3])
  end
  
  -- reselect old item-selection
  local retval = ultraschall.SelectMediaItems_MediaItemArray(MediaItemArray)
  
  reaper.PreventUIRefresh(-1)
  if projectpos<item_pos then 
    return -1
  else
    return projectpos
  end
end

function ultraschall.GetMarkerType(markerid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMarkerType</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string markertype = ultraschall.GetMarkerType(integer markerid)</functioncall>
  <description>
    return the type of a marker or region, either "shownote", "edit", "normal" for chapter markers, "planned", "custom_marker:custom_marker_name", "custom_region:custom_region_name" or "region".
    
    returns "no such marker or region", when markerindex is no valid markerindex
    
    returns nil in case of an error
  </description>
  <retvals>
    string markertype - see description for more details
  </retvals>
  <parameters>
    integer markerid - the markerid of all markers/regions in the project, beginning with 0 for the first marker/region
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, markertype</tags>
</US_DocBloc>
]]
  if math.type(markerid)~="integer" then ultraschall.AddErrorMessage("GetMarkerType", "markerid", "must be an integer", -1) return end
  
  MarkerAttributes={reaper.EnumProjectMarkers3(0, markerid)}
  
  if MarkerAttributes[2]==false then
    local Shownote, Shownote_idx=ultraschall.IsMarkerShownote(markerid)
    if Shownote==true then return "shownote", Shownote_idx end  
    
    local editmarkers, editmarkersarray = ultraschall.GetAllEditMarkers()
    for i=1, editmarkers do
      if editmarkersarray[i][2]==markerid+1 then 
        return "edit", i-1 
      end
    end
  
    if MarkerAttributes[7]==ultraschall.planned_marker_color then 
      planned_count=-1
      for i=0, markerid do
        local TempMarkerAttributes={reaper.EnumProjectMarkers3(0, i)}
        if TempMarkerAttributes[7]==ultraschall.planned_marker_color then
          planned_count=planned_count+1
        end
      end
      return "planned", planned_count
    end
    
    if MarkerAttributes[5]:match("_.-:")~=nil then 
      local name=MarkerAttributes[5]:match("_(.-):")
  
      for i=1, ultraschall.CountAllCustomMarkers(name) do
        local retval, marker_index, pos, name2, shown_number, color, guid = ultraschall.EnumerateCustomMarkers(name, i-1)
        if marker_index==markerid then return "custom_marker:"..name, i end
      end
    end
 
    if MarkerAttributes[5]:sub(1,1)=="!" then
      return "actionmarker"
    end 

    if ultraschall.IsMarkerNormal(markerid)==true then 
      for i=1, ultraschall.CountNormalMarkers() do
        retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
        if retnumber-1==markerid then return "normal", i-1 end
      end
    end
  end

  if MarkerAttributes[5]:match("_.-:")~=nil then 
    local name=MarkerAttributes[5]:match("_(.-):")

    for i=1, ultraschall.CountAllCustomRegions(name) do
      local retval, marker_index, pos, name2, shown_number, color, guid = ultraschall.EnumerateCustomRegions(name, i-1)
      if marker_index==markerid then return "custom_region:"..name, marker_index end
    end
  end

  if MarkerAttributes[2]==true then return "region", MarkerAttributes[1]-1 end

  return "no such marker or region"
end

function ultraschall.MarkerMenu_Start()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Start</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.9.7
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_Start()</functioncall>
  <description>
    starts a background-script, that hijacks the marker/region-context-menu when right-clicking them.
    
    You can set the menu-entries in resourcefolder/ultraschall_marker_menu.ini
    
    Important: this has issues with marker-lanes, so you might be able to open the context-menu when right-clicking above/below the marker!
    
    Markertypes, who have no menuentry set yet, will get their default-menu, instead.
    
    Scripts that shall influence the clicked marker, should use 
    
        -- get the last clicked marker
        marker_id, marker_guid=ultraschall.GetTemporaryMarker() 
        
        -- get the menuentry and additonal values from the markermenu
        markermenu_entry, markermenu_entry_additionaldata, 
        markermenu_entry_markertype, markermenu_entry_number = ultraschall.MarkerMenu_GetLastClickedMenuEntry()
        
    in them to retrieve the marker the user clicked on(plus some additional values), as Reaper has no way of finding this 
    out via API.
    It also means, that marker-actions of Reaper might NOT be able to find out, which marker to influence, so writing 
    your own scripts for that is probably unavoidable. Please keep this in mind and test this thoroughly.
    
    Note: to ensure, that the script can not be accidentally stopped by the user, you can run this function in a defer-loop to restart it, if needed.
  </description>
  <retvals>
    boolean retval - true, marker-menu has been started; false, markermenu is already running
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, start, markermenu</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("ultraschall_api", "markermenu_started")=="" then
    ultraschall.Main_OnCommand_NoParameters=nil
    ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/ultraschall_Marker_Menu.lua")
    ultraschall.Main_OnCommand_NoParameters=nil
    return true
  end
  return false
end

function ultraschall.MarkerMenu_Stop()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Stop</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.MarkerMenu_Stop()</functioncall>
  <description>
    stops the marker-menu background-script.
  </description>
  <retvals>
    boolean retval - true, marker-menu has been started; false, markermenu is already running
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, start, markermenu</tags>
</US_DocBloc>
]]
  reaper.DeleteExtState("ultraschall_api", "markermenu_started", false)
end

--SLEM()


function ultraschall.MarkerMenu_Debug(messages)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_Debug</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_Debug(integer messages)</functioncall>
  <description>
    toggles debug-messages, that shall be output with the marker-menu-backgroundscript
    
    Messages available are
      0 - no messages
      1 - output the markertype of the clicked marker in the ReaScript-Console
      2 - show marker-information as first entry in the marker-menu(type, overall marker-number, guid)
  </description>
  <retvals>
    boolean retval - true, setting debug-messages worked; false, setting debug-messages did not work
  </retvals>
  <parameters>
    integer messages - 0, show no debug messages in marker-menu-background-script
                     - 1, show the markertype of the last clicked-marker/region
                     - 2 - show marker-information as first entry in the marker-menu(type, overall marker-number, guid)
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, show, debugmessage, markermenu</tags>
</US_DocBloc>
]]
  if math.type(messages)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_Debug", "messages", "must be an integer", -1) return false end
  
  if messages&1==1 then
    reaper.SetExtState("ultraschall_api", "markermenu_debug_messages_markertype", "true", false)
  elseif messages&1==0 then
    reaper.DeleteExtState("ultraschall_api", "markermenu_debug_messages_markertype", false)
  end
  
  if messages&2==2 then
    reaper.SetExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", "true", false)
  elseif messages&2==0 then
    reaper.DeleteExtState("ultraschall_api", "markermenu_debug_messages_markerinfo_in_menu", false)
  end
  
  return true
end


function ultraschall.RenumerateNormalMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenumerateNormalMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RenumerateNormalMarkers()</functioncall>
  <description>
    renumerates the shown number of normal markers
  </description>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, renumerate, normal markers</tags>
</US_DocBloc>
]]
  for i=1, ultraschall.CountNormalMarkers() do
    local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(i)
    ultraschall.SetNormalMarker(i, position, i, markertitle)
  end
end

function ultraschall.RenumerateShownoteMarkers()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenumerateShownoteMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RenumerateShownoteMarkers()</functioncall>
  <description>
    renumerates the shown number of normal markers
  </description>
  <chapter_context>
    Markers
    Normal Markers
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, renumerate, shownote markers</tags>
</US_DocBloc>
]]
  for i=1, ultraschall.CountShownoteMarkers() do
    local retval, marker_index, pos, name, shownnumber, guid = ultraschall.EnumerateShownoteMarkers(i)
    ultraschall.SetShownoteMarker(i, pos, name, i)
  end
end

function ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string description, string action_command_id, string additional_data, integer submenu, boolean greyed, optional boolean checked = ultraschall.MarkerMenu_GetEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    gets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain custom marker/region
    
    returns nil in case of an error
  </description>
  <retvals>
    string description - the currently set description for this marker-entry; "", entry is a separator
    string action_command_id - the currently set action-command-id for this marker-entry
    string additional_data - potential additional data, stored with this menu-entry    
    integer submenu - 0, entry is no submenu(but can be within a submenu!); 1, entry is start of a submenu; 2, entry is last entry in a submenu
    boolean greyed - true, entry is greyed(submenu-entries will not be accessible!); false, entry is not greyed and therefore selectable
    optional boolean checked - true, entry has a checkmark; false, entry has no checkmark; nil, entry will show checkmark depending on toggle-state of action_command_id
  </retvals>
  <parameters>
    string marker_name - the name of the custom marker/region, whose menu-entry you want to retrieve
    boolean is_marker_region - true, it's a custom-region; false, it's a custom-marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to retrieve
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "marker_name", "must be a string", -1) return end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "is_marker_region", "must be a boolean", -2) return end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "clicktype", "must be an integer", -3) return end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "entry_nr", "must be an integer", -4) return end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry", "clicktype", "no such clicktype", -5)
    return
  end
  
  local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", "ultraschall_marker_menu.ini")
  local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", "ultraschall_marker_menu.ini")  
  local additional_data = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", "ultraschall_marker_menu.ini")
  local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", "ultraschall_marker_menu.ini")
  local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", "ultraschall_marker_menu.ini")
  local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", "ultraschall_marker_menu.ini")
  additional_data=string.gsub(additional_data, "\\n", "\n")
  
  if submenu=="start" then submenu=1 elseif submenu=="end" then submenu=2 else submenu=0 end
  greyed=greyed=="yes"
  if checked=="yes" then checked=true elseif checked=="no" then checked=false else checked=nil end
  if tonumber(aid)~=nil then aid=tonumber(aid) end
  
  return description, aid, additional_data, submenu, greyed, checked
end

--A,B=ultraschall.MarkerMenu_GetEntry("HuchTuch", true, 0, 1)
--SLEM()

function ultraschall.MarkerMenu_SetEntry(marker_name, is_marker_region, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    sets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain custom marker/region
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the name of the custom marker/region, whose menu-entry you want to set
    boolean is_marker_region - true, it's a custom-region; false, it's a custom-marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to set
    string action - the new action-command-id for this marker-entry
    string description - the new description for this marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "entry_nr", "must be an integer", -4) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "action", "must be an integer or a string beginning with _", -5) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "description", "must be a string", -6) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -7) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "greyed", "must be a boolean", -8) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "checked", "must be a boolean", -9) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "submenu", "must be an integer", -10) return false end
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry", "clicktype", "no such clicktype", -11)
    return false
  end
  additional_data=string.gsub(additional_data, "\n", "\\n")
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return retval
end


function ultraschall.MarkerMenu_GetAvailableTypes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetAvailableTypes</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>table marker_types = ultraschall.MarkerMenu_GetAvailableTypes()</functioncall>
  <description>
    gets all available markers/regions, that are added to the marker-menu, including their types.
    
    The table is of the following format:
        table[idx]["name"] - the name of the marker
        table[idx]["is_region"] - true, markertype is region; false, markertype is not a region
        table[idx]["markertype"] - either "default" or "custom"
        table[idx]["clicktype"] - the clicktype; 0, right-click
        
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  local entries={}
  local ini_file=ultraschall.ReadFullFile(reaper.GetResourcePath().."/ultraschall_marker_menu.ini")
  for k in string.gmatch(ini_file, "%[.-%]") do
    entries[#entries+1]={}
    if k:match("(%[custom_).*")==nil then
      entries[#entries]["markertype"]="default"
      entries[#entries]["name"], entries[#entries]["clicktype"]=k:match(".(.*)_(.*).")
      if entries[#entries]["name"]=="region" then entries[#entries]["is_region"]=true else entries[#entries]["is_region"]=false end
    else
      entries[#entries]["custom"]="custom"
      entries[#entries]["is_region"]=k:match("%[custom_(.-):.*")=="region"
      entries[#entries]["name"], entries[#entries]["clicktype"]=k:match(".custom_.-:(.*)_(.*).")
    end
  end
  return entries
end

--A=ultraschall.MarkerMenu_GetAvailableTypes()


function ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string description, string action_command_id, string additional_data, integer submenu, boolean greyed, optional boolean checked = ultraschall.MarkerMenu_GetEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    gets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns nil in case of an error
  </description>
  <retvals>
    string description - the new description for this marker-entry; "", entry is a separator
    string action_command_id - the new action-command-id for this marker-entry
    string additional_data - potentially stored additional data with this menuentry
    integer submenu - 0, entry is no submenu(but can be within a submenu!); 1, entry is start of a submenu; 2, entry is last entry in a submenu
    boolean greyed - true, entry is greyed(submenu-entries will not be accessible!); false, entry is not greyed and therefore selectable
    optional boolean checked - true, entry has a checkmark; false, entry has no checkmark; nil, entry will show checkmark depending on toggle-state of action_command_id
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to get
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to get
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end

  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "marker_type", "no such markertype", -4)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_GetEntry_DefaultMarkers", "clicktype", "no such clicktype", -5)
    return false
  end

  local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", "ultraschall_marker_menu.ini")
  local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", "ultraschall_marker_menu.ini")  
  local additional_data = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", "ultraschall_marker_menu.ini")
  local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", "ultraschall_marker_menu.ini")
  local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", "ultraschall_marker_menu.ini")
  local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", "ultraschall_marker_menu.ini")
  additional_data=string.gsub(additional_data, "\\n", "\n")
  
  if submenu=="start" then submenu=1 elseif submenu=="end" then submenu=2 else submenu=0 end
  greyed=greyed=="yes"
  if checked=="yes" then checked=true elseif checked=="no" then checked=false else checked=nil end
  if tonumber(aid)~=nil then aid=tonumber(aid) end
  
  return description, aid, additional_data, submenu, greyed, checked
end

--A,B=ultraschall.MarkerMenu_GetEntry_DefaultMarkers(0, 0, 1)

function ultraschall.MarkerMenu_SetEntry_DefaultMarkers(marker_type, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    sets the description and action-command-id for a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to set
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to set
    string action - the new action-command-id for this marker-entry
    string description - the new description for this marker-entry; "", entry is a separator
    string additional_data - optional additional data, that will be passed over by the marker-menu, when this menu-entry has been clicked; "", if not needed
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, description, actioncommandid, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "action", "must be an integer or a string beginning with _", -4) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -5) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "description", "must be a string", -6) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "greyed", "must be a boolean", -7) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "checked", "must be a boolean", -8) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "submenu", "must be an integer", -9) return false end
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "marker_type", "no such markertype", -10)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetEntry_DefaultMarkers", "clicktype", "no such clicktype", -11)
    return false
  end
  additional_data=string.gsub(additional_data, "\n", "\\n")
  
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 =  ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..entry_nr.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  return retval
end

function ultraschall.MarkerMenu_RemoveEntry(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a menu-entry in the marker-menu, associated with a certain default custom marker/region
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to remove
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to remove
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "entry_nr", "must be an integer", -4) return false end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry", "clicktype", "no such clicktype", -5)
    return false
  end
  
  for i=entry_nr, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval  = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", "", "ultraschall_marker_menu.ini")
      break 
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "ultraschall_marker_menu.ini")
    local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "ultraschall_marker_menu.ini")
    local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "ultraschall_marker_menu.ini")
    
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  return true
end

function ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a menu-entry in the marker-menu, associated with a certain default marker/region from Ultraschall
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing was successful; false, removing was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to remove
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "marker_type", "no such markertype", -4)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_RemoveEntry_DefaultMarkers", "clicktype", "no such clicktype", -5)
    return false
  end
  
  for i=entry_nr, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval  = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", "", "ultraschall_marker_menu.ini")
      break 
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "ultraschall_marker_menu.ini")
    local checked = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "ultraschall_marker_menu.ini")
    local submenu = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "ultraschall_marker_menu.ini")
    
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..i.."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  return true
end

function ultraschall.MarkerMenu_GetLastClickedMenuEntry()
   --[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_GetLastClickedMenuEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string markermenu_entry, string markermenu_entry_additionaldata, string markermenu_entry_markertype, string markermenu_entry_number = ultraschall.MarkerMenu_GetLastClickedMenuEntry()</functioncall>
  <description>
    gets the last clicked entry of the marker-menu
    
    the markermenu_entry_number is according to the entry-number in the ultraschall_marker_menu.ini
    
    the stored data will be deleted after one use!
  </description>
  <retvals>
    string markermenu_entry - the text of the clicked menu-entry
    string markermenu_entry_additionaldata - additional data, that is associated with this menu-entry
    string markermenu_entry_markertype - the type of the marker
    string markermenu_entry_number - the number of the marker-entry
  </retvals>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, get, menu entry, last clicked</tags>
</US_DocBloc>
]]
  MarkerMenu_Entry=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry")
  MarkerMenu_Entry_MarkerType=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType")
  MarkerMenu_EntryNumber=reaper.GetExtState("ultraschall_api", "MarkerMenu_EntryNumber")
  MarkerMenu_Entry_AdditionalData=reaper.GetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData")
  
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_MarkerType", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_EntryNumber", "", false)
  reaper.SetExtState("ultraschall_api", "MarkerMenu_Entry_AdditionalData", "", false)
  return MarkerMenu_Entry, MarkerMenu_Entry_AdditionalData, MarkerMenu_Entry_MarkerType, MarkerMenu_EntryNumber
end

function ultraschall.ResolvePresetName(bounds_name, options_and_formats_name)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>ResolvePresetName</slug>
   <requires>
     Ultraschall=4.7
     Reaper=6.48
     Lua=5.3
   </requires>
   <functioncall>string Bounds_Name, string Options_and_Format_Name = ultraschall.ResolvePresetName(string Bounds_Name, string Options_and_Format_Name)</functioncall>
   <description>
     returns the correct case-sensitive-spelling of a bound/options-renderpreset name.
     
     Just pass the name in any kind of case-style and it will find the correct case-sensitive-names.
    
     Returns nil in case of an error or if no such name was found
   </description>
   <parameters>
     string Bounds_Name - the name of the Bounds-render-preset you want to query
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset you want to query
   </parameters>
   <retvals>
     string Bounds_Name - the name of the Bounds-render-preset in correct case-sensitivity as stored
     string Options_and_Format_Name - the name of the Renderformat-options-render-preset in correct case-sensitivity as stored
   </retvals>
   <chapter_context>
      Rendering Projects
      Render Presets
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
   <tags>render management, resolve, render preset, names, format options, bounds, case sensitivity</tags>
 </US_DocBloc>
 ]]
  if bounds_name~=nil and type(bounds_name)~="string" then ultraschall.AddErrorMessage("ResolvePresetName", "bounds_name", "must be a string", -1) return end
  if options_and_formats_name~=nil and type(options_and_formats_name)~="string" then ultraschall.AddErrorMessage("ResolvePresetName", "options_and_formats_name", "must be a string", -2) return end
  local bounds_presets, bounds_names, options_format_presets, options_format_names, both_presets, both_names = ultraschall.GetRenderPreset_Names()
  local foundbounds=nil
  local found_options=nil
  
  if bounds_name~=nil then
    for i=1, #bounds_names do
      if bounds_name:lower()==bounds_names[i]:lower() then foundbounds=bounds_names[i] break end
    end
  end
  if options_and_formats_name~=nil then
    for i=1, #options_format_names do
      if options_and_formats_name:lower()==options_format_names[i]:lower() then found_options=options_format_names[i] break end
    end
  end
  return foundbounds, found_options
end

function ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_CountEntries</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer number_of_entries = ultraschall.MarkerMenu_CountEntries(string marker_name, boolean is_marker_region, integer clicktype)</functioncall>
  <description>
    counts the number of menu-entries in the marker-menu, associated with a certain default custom marker/region
    
    ends conting, when an entry is either missing an action-command-id or description or both
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_entries - the number of entries available; -1, in case of an error
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entries you want to count
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, count, entries, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "marker_name", "must be a string", -1) return -1 end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "is_marker_region", "must be a boolean", -2) return -1 end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "clicktype", "must be an integer", -3) return -1 end
  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountMenuEntries", "clicktype", "no such clicktype", -4)
    return false
  end
  
  for i=1, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")
    if aid=="" or description=="" then 
      return i-1
    end
  end
  return -1
end

--A=ultraschall.MarkerMenu_CountEntries("CustomRegion", true, 0)

function ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_CountEntries_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer number_of_entries = ultraschall.MarkerMenu_CountEntries_DefaultMarkers(integer marker_type, integer clicktype)</functioncall>
  <description>
    counts the number of menu-entries in the marker-menu, associated with a certain default markers from Ultraschall
    
    ends counting, when an entry is either missing an action-command-id or description or both
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_entries - the number of entries available; -1, in case of an error
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, count, entries, markermenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "marker_type", "no such markertype", -3)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_CountEntries_DefaultMarkers", "clicktype", "no such clicktype", -4)
    return false
  end
  
  for i=1, 65536 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")
    if aid=="" or description=="" then 
      return i-1
    end
  end
  return -1
end

function ultraschall.MarkerMenu_InsertEntry(marker_name, is_marker_region, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_InsertEntry</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_InsertEntry(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    inserts a menu-entry into the marker-menu, associated with a certain default custom marker/region and moves all others one up
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, inserting was successful; false, inserting was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to insert
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to insert
    string action - the action-command-id for this new marker-entry
    string description - the description for this new marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "entry_nr", "must be an integer", -4) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "action", "must be an integer or a string beginning with _", -5) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "description", "must be a string", -6) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "description", "must be a string", -7) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "greyed", "must be a boolean", -8) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "checked", "must be a boolean", -9) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "submenu", "must be an integer", -10) return false end

  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry", "clicktype", "no such clicktype", -11)
    return false
  end
  
  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  for i=ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype), entry_nr-1, -1 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "", "ultraschall_marker_menu.ini")
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Checked", "ultraschall_marker_menu.ini")
    local checked= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Greyed", "ultraschall_marker_menu.ini")
    local submenu= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_SubMenu", "ultraschall_marker_menu.ini")
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return true
end

--ultraschall.MarkerMenu_Start()
--ultraschall.MarkerMenu_InsertEntry("CustomRegion", true, 0, 1, 1007, "HudelDudel"..os.date(), "More Data"..reaper.time_precise())
--SLEM()


function ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(marker_type, clicktype, entry_nr, action, description, additional_data, submenu, greyed, checked)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_InsertEntry_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_InsertEntry_DefaultMarkers(string marker_name, integer clicktype, integer entry_nr, string action, string description, string additional_data, integer submenu, boolean greyed, optional boolean checked)</functioncall>
  <description>
    inserts a menu-entry into the marker-menu, associated with a certain default marker/region as in Ultraschall and moves all others one up
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, inserting was successful; false, inserting was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to insert
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that you want to insert
    string action - the action-command-id for this new marker-entry
    string description - the description for this new marker-entry; "", entry is a separator
    string additional_data - additional data, that will be sent by the marker-menu, when clicking this menuentry
    integer submenu - 0, entry is no submenu; 1, entry is start of submenu, 2, entry if last entry in the submenu
    boolean greyed - true, the entry is greyed(if it's a submenu, its entries will NOT show!); false, the entry is shown normally
    optional boolean checked - true, the entry will show a checkmark
                             - false, the entry will show no checkmark
                             - nil, the entry will show a checkmark depending on the toggle-command-state of the action for this menuentry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>entries, markermenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "action", "must be an integer or a string beginning with _", -4) return false end
  if type(description)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "description", "must be a string", -5) return false end
  if type(additional_data)~="string" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "description", "must be a string", -6) return false end
  if type(greyed)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "greyed", "must be a boolean", -7) return false end
  if type(checked)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "checked", "must be a boolean", -8) return false end
  if math.type(submenu)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "submenu", "must be an integer", -9) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "marker_type", "no such markertype", -10)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_InsertEntry_DefaultMarkers", "clicktype", "no such clicktype", -11)
    return false
  end

  if greyed==true then greyed="yes" elseif greyed==false then greyed="no" else greyed="" end
  if checked==true then checked="yes" elseif checked==false then checked="no" else checked="" end
  if submenu==1 then submenu="start" elseif submenu==2 then submenu="end" else submenu="" end
  
  for i=ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype), entry_nr-1, -1 do
    local aid = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_ActionCommandID", "ultraschall_marker_menu.ini")
    if aid=="" then 
      local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", "", "ultraschall_marker_menu.ini")
      local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", "", "ultraschall_marker_menu.ini")
      local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", "", "ultraschall_marker_menu.ini")
      local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", "", "ultraschall_marker_menu.ini")
      local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", "", "ultraschall_marker_menu.ini")
      local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", "", "ultraschall_marker_menu.ini")
    end
    local description = ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Description", "ultraschall_marker_menu.ini")  
    local additional_data= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_AdditionalData", "ultraschall_marker_menu.ini")
    local greyed= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Checked", "ultraschall_marker_menu.ini")
    local checked= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_Greyed", "ultraschall_marker_menu.ini")
    local submenu= ultraschall.GetUSExternalState(name_of_marker, "Entry_"..(i).."_SubMenu", "ultraschall_marker_menu.ini")
    local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_ActionCommandID", aid, "ultraschall_marker_menu.ini")
    local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Description", description, "ultraschall_marker_menu.ini")
    local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
    local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Greyed", greyed, "ultraschall_marker_menu.ini")
    local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_Checked", checked, "ultraschall_marker_menu.ini")
    local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(i+1).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  end
  local retval = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_ActionCommandID", action, "ultraschall_marker_menu.ini")
  local retval2 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Description", description, "ultraschall_marker_menu.ini")
  local retval3 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_AdditionalData", additional_data, "ultraschall_marker_menu.ini")
  local retval4 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Greyed", greyed, "ultraschall_marker_menu.ini")
  local retval5 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_Checked", checked, "ultraschall_marker_menu.ini")
  local retval6 = ultraschall.SetUSExternalState(name_of_marker, "Entry_"..(entry_nr).."_SubMenu", submenu, "ultraschall_marker_menu.ini")
  
  return true
end

function ultraschall.MarkerMenu_SetStartupAction(marker_name, is_marker_region, clicktype, action)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetStartupAction</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetStartupAction(string marker_name, boolean is_marker_region, integer clicktype, string action)</functioncall>
  <description>
    adds a startup-action into the marker-menu, associated with a certain default custom marker/region
    
    This startup-action will be run before the menu for this specific marker/region will be opened and can be used to populate/update the menuentries first before showing the menu(for filelists, etc)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding startup-action was successful; false, adding startup-action was unsuccessful
  </retvals>
  <parameters>
    string marker_name - the custom-marker/region name, whose menu-entry you want to add a startup-action for
    boolean is_marker_region - true, if the marker is a region; false, if not
    integer clicktype - the clicktype; 0, right-click
    string action - the action-command-id for this new marker-entry
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, set, startup action, entry, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "clicktype", "must be an integer", -3) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "action", "must be an integer or a string beginning with _", -4) return false end

  
  local name_of_marker=""
  if is_marker_region==true then
    name_of_marker="custom_region:"..marker_name
  else
    name_of_marker="custom_marker:"..marker_name
  end
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction", "clicktype", "no such clicktype", -5)
    return false
  end
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "StartUpAction", action, "ultraschall_marker_menu.ini")

  return true
end

--ultraschall.MarkerMenu_AddStartupAction("CustomRegion", true, 0, 1008)

--ultraschall.MarkerMenu_Start()
--ultraschall.MarkerMenu_InsertEntry("CustomRegion", true, 0, 1, 1007, "HudelDudel"..os.date(), "More Data"..reaper.time_precise())
--SLEM()


function ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(marker_type, clicktype, action)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_SetStartupAction_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_SetStartupAction_DefaultMarkers(integer marker_type, integer clicktype, string action)</functioncall>
  <description>
    adds a startup-action into the marker-menu, associated with a certain default marker/region as in Ultraschall and moves all others one up
    
    This startup-action will be run before the menu for this specific marker/region will be opened and can be used to populate/update the menuentries first before showing the menu(for filelists, etc)
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, adding startup-action was successful; false, adding startup-action was unsuccessful
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose menu-entry you want to add a startup-action for
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    string action - the action-command-id for this startup-action
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_GetEntry_DefaultMarkers
                  gets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>entries, set, startup action, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if type(action)~="string" and math.type(action)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "action", "must be an integer or a string beginning with _", -3) return false end
  
  local name_of_marker
  if marker_type==0 then name_of_marker="normal"
  elseif marker_type==1 then name_of_marker="planned"
  elseif marker_type==2 then name_of_marker="edit"
  elseif marker_type==3 then name_of_marker="shownote"
  elseif marker_type==4 then name_of_marker="region"
  elseif marker_type==5 then name_of_marker="actionmarker"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "marker_type", "no such markertype", -7)
    return false
  end
  
  if clicktype==0 then
    name_of_marker=name_of_marker.."_RightClck"
  else
    ultraschall.AddErrorMessage("MarkerMenu_SetStartupAction_DefaultMarkers", "clicktype", "no such clicktype", -8)
    return false
  end
  
  local retval = ultraschall.SetUSExternalState(name_of_marker, "StartUpAction", action, "ultraschall_marker_menu.ini")
  return true
end


function ultraschall.GetNextClosestItemStart(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextClosestItemStart</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetNextClosestItemStart(string trackstring, number time_position)</functioncall>
  <description>
    returns the next closest item-start in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the next closest item-start
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, next, closest, itemstart, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetNextClosestItemStart", "trackstring", "must be a valid trackstring", -1) return -1 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemStart", "time_position", "must be a number", -1) return -1 end

  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(time_position, reaper.GetProjectLength(), trackstring, true)
  if count==0 then return -1 end
  local pos=reaper.GetProjectLength(0)
  local found_item=nil
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")
    if pos2<pos and pos2>time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  if pos==reaper.GetProjectLength(0)+1 then pos=-1 end
  return pos, found_item
end

--A, B=ultraschall.GetNextClosestItemStart("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetPreviousClosestItemStart(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousClosestItemStart</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetPreviousClosestItemStart(string trackstring, number time_position)</functioncall>
  <description>
    returns the previous closest item-start in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the previous closest item-start
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, previous, closest, itemstart, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetPreviousClosestItemStart", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetPreviousClosestItemStart", "time_position", "must be a number", -1) return -2 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, time_position, trackstring, false)
  if count==0 then return -1 end
  local pos=-1
  local found_item=nil
  for i=#MediaItemArray, 1, -1 do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")
    if pos2>pos and pos2<time_position then pos=pos2 found_item=MediaItemArray[i] end
  end

  return pos, found_item
end

--A, B=ultraschall.GetPreviousClosestItemStart("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetPreviousClosestItemEnd(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreviousClosestItemEnd</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetPreviousClosestItemEnd(string trackstring, number time_position)</functioncall>
  <description>
    returns the previous closest item-end in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the previous closest item-end
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, previous, closest, itemend, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetPreviousClosestItemEnd", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetPreviousClosestItemEnd", "time_position", "must be a number", -1) return -2 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(), trackstring, true)
  if count==0 then return -1 end
  local pos=-1
  local found_item=nil
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")
    if pos2>pos and pos2<time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  return pos, found_item
end

--A=ultraschall.GetPreviousClosestItemEnd("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16", reaper.GetCursorPosition())
--reaper.MoveEditCursor(-reaper.GetCursorPosition()+A, false)

function ultraschall.GetNextClosestItemEnd(trackstring, time_position)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetNextClosestItemEnd</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number position, MediaItem item = ultraschall.GetNextClosestItemEnd(string trackstring, number time_position)</functioncall>
  <description>
    returns the next closest item-end in seconds and the corresponding item
    
    returns -1 and item==nil in case of error
  </description>
  <retvals>
    number position - the position of the item-start
    MediaItem item - the MediaItem found
  </retvals>
  <parameters>
    string trackstring - tracknumbers, separated by a comma.
    number time_position - a time position in seconds, from where to check for the next closest item-end
  </parameters>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Navigation_Module.lua</source_document>
  <tags>navigation, get, next, closest, itemend, item</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidTrackString(trackstring)==false then ultraschall.AddErrorMessage("GetNextClosestItemEnd", "trackstring", "must be a valid trackstring", -1) return -2 end
  if type(time_position)~="number" then ultraschall.AddErrorMessage("GetNextClosestItemEnd", "time_position", "must be a number", -1) return -2 end
  if time_position>reaper.GetProjectLength(0) then return -1 end
  local count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(), trackstring, false)
  if count==0 then return -1 end
  local pos=reaper.GetProjectLength(0)+1
  local found_item=nil
  for i=1, #MediaItemArray do
    local pos2=reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_POSITION")+reaper.GetMediaItemInfo_Value(MediaItemArray[i], "D_LENGTH")
    if pos2<pos and pos2>time_position then pos=pos2 found_item=MediaItemArray[i] end
  end
  if pos==reaper.GetProjectLength(0)+1 then pos=-1 end
  return pos, found_item
end


function ultraschall.MarkerMenu_RemoveSubMenu(marker_name, is_marker_region, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveSubMenu</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveSubMenu(string marker_name, boolean is_marker_region, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a submenu from the markermenu of a specific custom marker.
    
    Will also remove nested submenus. 
    If the number of starts of submenus and ends of submenus mismatch, this could cause weird behavior. So keep the starts and ends of submenu-entries consistent!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing submenu worked; false, removing of submenus didn't work
  </retvals>
  <parameters>
    string marker_name - the name of the custom-marker/region, whose sub-menu-entry you want to remove
    boolean is_marker_region - true, the custom-marker is a region; false, the custom-marker is not a region
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that is the first entry in the submenu
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, submenu, markermenu, custom marker, custom region</tags>
</US_DocBloc>
]]
  if type(marker_name)~="string" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "marker_name", "must be a string", -1) return false end
  if type(is_marker_region)~="boolean" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "is_marker_region", "must be a boolean", -2) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "clicktype", "must be an integer", -3) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "entry_nr", "must be an integer", -4) return false end
  
  local NumEntries=ultraschall.MarkerMenu_CountEntries(marker_name, is_marker_region, clicktype)
  local Entry={ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)}
  if Entry[4]~=1 then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu", "entry_nr", "is not a start of a submenu", -5) return false end

  local num_submenus=0
  for i=1, NumEntries do
    Entry={ultraschall.MarkerMenu_GetEntry(marker_name, is_marker_region, clicktype, entry_nr)}
    if Entry[4]==1 then num_submenus=num_submenus+1 end
    if Entry[4]==2 then num_submenus=num_submenus-1 end
    ultraschall.MarkerMenu_RemoveEntry(marker_name, is_marker_region, clicktype, entry_nr)
    if num_submenus==0 and Entry[4]==2 then return true end
  end
  return true
end

--A1=ultraschall.MarkerMenu_RemoveSubMenu("Time", false, 0, 3)


function ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(marker_type, clicktype, entry_nr)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MarkerMenu_RemoveSubMenu_DefaultMarkers</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MarkerMenu_RemoveSubMenu_DefaultMarkers(integer marker_type, integer clicktype, integer entry_nr)</functioncall>
  <description>
    removes a submenu from the markermenu of a specific default marker/region.
    
    Will also remove nested submenus. 
    If the number of starts of submenus and ends of submenus mismatch, this could cause weird behavior. So keep the starts and ends of submenu-entries consistent!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, removing submenu worked; false, removing of submenus didn't work
  </retvals>
  <parameters>
    integer marker_type - the marker_type, whose sub-menu-entry you want to remove
                        - 0, normal(chapter) markers
                        - 1, planned markers (Custom markers whose name is _Planned:)
                        - 2, edit (Custom markers, whose name is _Edit: or _Edit)
                        - 3, shownote
                        - 4, region
                        - 5, action marker
    integer clicktype - the clicktype; 0, right-click
    integer entry_nr - the entry-number, that is the first entry in the submenu
  </parameters>
  <linked_to desc="see:">
      Ultraschall:MarkerMenu_Start
                  starts the marker-menu-script
      Ultraschall:MarkerMenu_Stop
                  stops the marker-menu-script
      Ultraschall:MarkerMenu_Debug
                  set marker-menu-script to output debug messages
      Ultraschall:MarkerMenu_GetEntry
                  gets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry
                  removes a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_RemoveEntry_DefaultMarkers
                  removes a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_SetEntry
                  sets a menu-entry for a custom-marker/region
      Ultraschall:MarkerMenu_SetEntry_DefaultMarkers
                  sets a menu-entry for a default-marker in Ultraschall
      Ultraschall:MarkerMenu_GetAvailableTypes
                  get all currently available markers from the Marker-Menu
  </linked_to>
  <chapter_context>
    Markers
    Marker Menu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>markermanagement, remove, submenu, markermenu, shownote, edit marker, normal marker, region, planned chapter marker, action marker</tags>
</US_DocBloc>
]]
  if math.type(marker_type)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "marker_type", "must be an integer", -1) return false end
  if math.type(clicktype)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "clicktype", "must be an integer", -2) return false end
  if math.type(entry_nr)~="integer" then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "entry_nr", "must be an integer", -3) return false end
  
  local NumEntries=ultraschall.MarkerMenu_CountEntries_DefaultMarkers(marker_type, clicktype)
  local Entry={ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)}
  if Entry[4]~=1 then ultraschall.AddErrorMessage("MarkerMenu_RemoveSubMenu_DefaultMarkers", "entry_nr", "is not a start of a submenu", -4) return false end

  local num_submenus=0
  for i=1, NumEntries do
    Entry={ultraschall.MarkerMenu_GetEntry_DefaultMarkers(marker_type, clicktype, entry_nr)}
    if Entry[4]==1 then num_submenus=num_submenus+1 end
    if Entry[4]==2 then num_submenus=num_submenus-1 end
    ultraschall.MarkerMenu_RemoveEntry_DefaultMarkers(marker_type, clicktype, entry_nr)

    if num_submenus==0 and Entry[4]==2 then return true end
  end
  return true
end

function ultraschall.GetGuidFromCustomMarkerID(markername, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromCustomMarkerID</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromCustomMarkerID(string markername, integer index)</functioncall>
  <description>
    Gets the corresponding guid of a custom marker with a specific index 
    
    The index is for _custom:-markers only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the custom marker with a specific index
  </retvals>
  <parameters>
    string markername - the name of the custom-marker
    integer index - the index of the custom marker, whose guid you want to retrieve; 0-based
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromCustomMarkerID", "idx", "must be an integer", -1) return end
  if type(markername)~="string" then ultraschall.AddErrorMessage("GetGuidFromCustomMarkerID", "markername", "must be a string", -2) return end

  local retval, marker_index, pos, name, shown_number, color, guid2 = ultraschall.EnumerateCustomMarkers(markername, idx)
  return guid2
end

--A={ultraschall.GetGuidFromCustomMarkerID("Planned", 0)}

--A=ultraschall.GetGuidFromShownoteMarkerID(1)
--B={ultraschall.EnumerateShownoteMarkers(1)}
--SLEM()

function ultraschall.GetGuidFromCustomRegionID(regionname, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetGuidFromCustomRegionID</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string guid = ultraschall.GetGuidFromCustomRegionID(string regionname, integer index)</functioncall>
  <description>
    Gets the corresponding guid of a custom region with a specific index 
    
    The index is for _custom:-regions only
    
    returns nil in case of an error
  </description>
  <retvals>
    string guid - the guid of the custom region with a specific index
  </retvals>
  <parameters>
    string regionname - the name of the custom-region
    integer index - the index of the custom region, whose guid you want to retrieve; 0-based
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom region, markerid, guid</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetGuidFromCustomRegionID", "idx", "must be an integer", -1) return end
  if type(markername)~="string" then ultraschall.AddErrorMessage("GetGuidFromCustomRegionID", "regionname", "must be a string", -2) return end

  local retval, marker_index, pos, length, name, shown_number, color, guid2 = ultraschall.EnumerateCustomRegions(regionname, idx)
  return guid2
end

--A=ultraschall.GetGuidFromCustomRegionID("Time", 0)

function ultraschall.GetCustomMarkerIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCustomMarkerIDFromGuid</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, string custom_marker_name = ultraschall.GetCustomMarkerIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a custom-marker-guid
    
    The index is for all _custom:-markers only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the custom-marker, whose guid you have passed to this function; 0-based
    string custom_marker_name - the name of the custom-marker
  </retvals>
  <parameters>
    string guid - the guid of the custom-marker, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom marker, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetCustomMarkerIDFromGuid", "guid", "must be a string", -1) return -1 end  
  local marker_id = ultraschall.GetMarkerIDFromGuid(guid)
  local A,A,A,rgn_end,name=reaper.EnumProjectMarkers(marker_id-1)
  name=name:match("_(.-):")
  if name==nil or rgn_end>0 then ultraschall.AddErrorMessage("GetCustomMarkerIDFromGuid", "guid", "not a custom-marker", -2) return -1 end  

  for idx=0, ultraschall.CountAllCustomMarkers(name) do
    ultraschall.SuppressErrorMessages(true)
    local retval, marker_index, pos, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomMarkers(name, idx)
    if guid2==guid then ultraschall.SuppressErrorMessages(false) return idx, name end
  end
  ultraschall.SuppressErrorMessages(false)
  return -1
end

--B,C=ultraschall.GetCustomMarkerIDFromGuid("{E4C95832-0E52-4164-A879-9AED86D5A66C}")

function ultraschall.GetCustomRegionIDFromGuid(guid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCustomRegionIDFromGuid</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, string custom_region_name = ultraschall.GetCustomRegionIDFromGuid(string guid)</functioncall>
  <description>
    Gets the corresponding indexnumber of a custom-region-guid
    
    The index is for all _custom:-regions only.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer index - the index of the custom-region, whose guid you have passed to this function; 0-based
    string custom_region_name - the name of the region-marker
  </retvals>
  <parameters>
    string guid - the guid of the custom-region, whose index-number you want to retrieve
  </parameters>
  <chapter_context>
    Markers
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>marker management, get, custom region, markerid, guid</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("GetCustomRegionIDFromGuid", "guid", "must be a string", -1) return -1 end  
  local marker_id = ultraschall.GetMarkerIDFromGuid(guid)
  local A,A,A,rgn_end,name=reaper.EnumProjectMarkers(marker_id-1)
  name=name:match("_(.-):")
  if name==nil or rgn_end==0 then ultraschall.AddErrorMessage("GetCustomRegionIDFromGuid", "guid", "not a custom-region", -2) return -1 end  

  for idx=0, ultraschall.CountAllCustomRegions(name) do
    ultraschall.SuppressErrorMessages(true)
    local retval, marker_index, pos, length, name2, shown_number, color, guid2 = ultraschall.EnumerateCustomRegions(name, idx)
    if guid2==guid then ultraschall.SuppressErrorMessages(false) return idx, name end
  end
  ultraschall.SuppressErrorMessages(false)
  return -1
end

--B,C=ultraschall.GetCustomRegionIDFromGuid("{84144A00-96EA-4AC6-ACB2-D2B0EEEB3CEB}")