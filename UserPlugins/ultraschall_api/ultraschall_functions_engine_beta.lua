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







function ultraschall.EscapeCharactersForXMLText(String)
  -- control characters to numeric character references are still missing
  -- check these site:
  --  https://stackoverflow.com/a/46637835
  --  https://www.w3.org/International/questions/qa-controls  -- control characters
  --  https://www.w3.org/TR/xml11/#dt-charref -- control characters
  
  String=string.gsub(String, "&", "&amp;")
  String=string.gsub(String, "<", "&lt;")
  String=string.gsub(String, ">", "&gt;")
  String=string.gsub(String, "\"", "&quot;")
  String=string.gsub(String, "\'", "&apos;")
  return String
end

--A=ultraschall.EscapeCharactersForXMLText("HULA&HO\"HooP\"Oh now that you 'mention' it OP&amp;")

function ultraschall.GetPodcastAttributesAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPodcastAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string podcastmetadata_json = ultraschall.GetPodcastAttributesAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for podcast as JSON according to PodcastMetaDataV1_Standard.
  </description>
  <retvals>
    string podcastmetadata_json - the podcast-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, metadata, json, podcast metadata v1</tags>
</US_DocBloc>
]]
  local JSON="\"podc\":{\n"
  for i=1, #ultraschall.PodcastAttributes do
    local retval, content = ultraschall.GetSetPodcast_Attributes(false, ultraschall.PodcastAttributes[i], "")
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      --[[
      if ultraschall.PodcastAttributes[i]=="epsd_cover" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
      end
      --]]
      JSON=JSON.."\t\""..ultraschall.PodcastAttributes[i].."\":\""..content.."\",\n"
    end
  end
  JSON=JSON.."}\n"
  return JSON
end

--print3(ultraschall.PodcastMetadata_GetPodcastAttributesAsJSON())
--if lol==nil then return end

function ultraschall.GetEpisodeAttributesAsJSON()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetEpisodeAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string episodemetadata_json = ultraschall.GetEpisodeAttributesAsJSON()</functioncall>
  <description>
    Returns the MetaDataEntry for the podcast's episode as JSON according to PodcastMetaDataV1_Standard.
  </description>
  <retvals>
    string episodemetadata_json - the podcast's episode-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, episode, metadata, json, podcast metadata v1</tags>
</US_DocBloc>
]]
  local JSON="\"epsd\":{\n"
  for i=1, #ultraschall.EpisodeAttributes do
    local retval, content = ultraschall.GetSetPodcastEpisode_Attributes(false, ultraschall.EpisodeAttributes[i], "")
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if ultraschall.EpisodeAttributes[i]=="epsd_cover" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
      end
      JSON=JSON.."\t\""..ultraschall.EpisodeAttributes[i].."\":\""..content.."\",\n"
    end
  end
  JSON=JSON.."}\n"
  return JSON
end

--print3(ultraschall.PodcastMetadata_GetEpisodeAttributesAsJSON())
--if lol==nil then return end

function ultraschall.GetChapterAttributesAsJSON(chaptermarker_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetChapterAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string chaptermetadata_json = ultraschall.GetChapterAttributesAsJSON(integer chaptermarker_id)</functioncall>
  <description>
    Returns the MetaDataEntry for a chapter as JSON according to PodcastMetaDataV1_Standard.
    
    Returns nil in case of an error
  </description>
  <parameters>
    integer chaptermarker_id - the index of the chapter-marker, whose metadata-entry you want to get as JSON; 1-based
  </parameters>
  <retvals>
    string chaptermetadata_json - the chapter-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, chapter, metadata, json, podcast metadata v1</tags>
</US_DocBloc>
]]
  if math.type(chaptermarker_id)~="integer" then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "chaptermarker_id", "must be an integer", -1) return end
  if chaptermarker_id<1 or chaptermarker_id>ultraschall.CountNormalMarkers() then ultraschall.AddErrorMessage("GetChapterAttributesAsJSON", "chaptermarker_id", "no such chapter-marker", -2) return end
  local JSON="\"chap_"..chaptermarker_id.."\":{\n"
  local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateNormalMarkers(chaptermarker_id)
  JSON=JSON.."\t\"chap_name\":\""..markertitle.."\",\n"
  JSON=JSON.."\t\"chap_position\":\""..position.."\",\n"
  local retval, content = ultraschall.GetSetChapterMarker_Attributes(true, chaptermarker_id, "chap_guid", "")
  
  for i=1, #ultraschall.ChapterAttributes do
    local attribute=ultraschall.ChapterAttributes[i]     
    local retval, content = ultraschall.GetSetChapterMarker_Attributes(false, chaptermarker_id, attribute, "")
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if attribute=="chap_image" then
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      elseif attribute=="chap_image_path" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
        attribute="chap_image"
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      else
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      end
      
    end
  end  
  JSON=JSON.."}\n"
  return JSON
end

--print3(ultraschall.PodcastMetadata_GetChapterAttributesAsJSON(1))
--SLEM()
--if lol==nil then return end

function ultraschall.GetShownoteAttributesAsJSON(shownotemarker_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetShownoteAttributesAsJSON</slug>
  <requires>
    Ultraschall=4.75
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string shownotemetadata_json = ultraschall.GetShownoteAttributesAsJSON(integer shownotemarker_id)</functioncall>
  <description>
    Returns the MetaDataEntry for a shownote as JSON according to PodcastMetaDataV1_Standard.
    
    Returns nil in case of an error
  </description>
  <parameters>
    integer chaptermarker_id - the index of the shownote-marker, whose metadata-entry you want to get as JSON; 1-based
  </parameters>
  <retvals>
    string shownotemetadata_json - the chapter-metadata as json
  </retvals>
  <chapter_context>
    Metadata Management
    Podcast Metadata
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Markers_Module.lua</source_document>
  <tags>metadata, get, podcast, shownote, metadata, json, podcast metadata v1</tags>
</US_DocBloc>
]]
  if math.type(shownotemarker_id)~="integer" then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "shownotemarker_id", "must be an integer", -1) return end
  if shownotemarker_id<1 or shownotemarker_id>ultraschall.CountShownoteMarkers() then ultraschall.AddErrorMessage("GetShownoteAttributesAsJSON", "marker_id", "no such shownote-marker", -2) return end
  local JSON="\"shwn_"..shownotemarker_id.."\":{\n"
  local retnumber, shown_number, position, markertitle, guid = ultraschall.EnumerateShownoteMarkers(shownotemarker_id)
  JSON=JSON.."\t\"shwn_name\":\""..markertitle.."\",\n"
  JSON=JSON.."\t\"shwn_position\":\""..position.."\",\n"
  
  local retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownotemarker_id, "shwn_guid", "")

  for i=1, #ultraschall.ShowNoteAttributes do
    local attribute=ultraschall.ShowNoteAttributes[i]
    local retval, content = ultraschall.GetSetShownoteMarker_Attributes(false, shownotemarker_id, attribute, "")
    --SLEM()
    --print2(attribute)
    if retval==true and content~="" then
      content=string.gsub(content, "\"", "\\\"")
      content=string.gsub(content, "\\n", "\\\\n")
      content=string.gsub(content, "\n", "\\n")
      if attribute=="chap_image" then
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      elseif attribute=="chap_image_path" then
        local prj, path=reaper.EnumProjects(-1)
        path=string.gsub(path, "\\", "/")
        path=path:match("(.*)/")
        --content=ultraschall.Base64_Encoder(ultraschall.ReadFullFile(path.."/"..content, true))
        attribute="chap_image"
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      else
        JSON=JSON.."\t\""..tostring(attribute).."\":\""..tostring(content).."\",\n"
      end
      
    end
  end  
  JSON=JSON.."}\n"
  return JSON
end

