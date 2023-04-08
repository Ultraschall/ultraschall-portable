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

function ultraschall.Debug_ShowCurrentContext(show)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Debug_ShowCurrentContext</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string functionname, string sourcefilename_with_path, integer linenumber = ultraschall.GetReaperWindow_Position(integer show)</functioncall>
  <description>
    When called, this function returns, in which function, sourcefile and linenumber it was called.
    Good for debugging purposes.
  </description>
  <retvals>
    string functionname - the name of the function, in which Debug_ShowCurrentContext was called
    integer linenumber - the linenumber, in which Debug_ShowCurrentContext was called
    string sourcefilename_with_path - the filename, in which Debug_ShowCurrentContext was called
    number timestamp - precise timestamp to differentiate between two Debug_ShowCurrentContext-calls
  </retvals>
  <parameters>
    integer show - 0, don't show context; 1, show context as messagebox; 2, show context in console; 3, clear console and show context in console
  </parameters>
  <chapter_context>
    User Interface
    Reaper Main Window
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, arrange-view, position, hwnd, get</tags>
</US_DocBloc>
--]]
  local context=debug.getinfo(2)
  local timestamp=reaper.time_precise()
  if context["name"]==nil then context["name"]="" end
  if show==1 then
    print2("Called in\n\nFunction     : "..context["name"], "\nLinenumber: "..context["currentline"], "\n\nSourceFileName:\n"..context["source"]:sub(2,-1))
  elseif show==2 then
    print_alt("\n>>Called in\n   Function  : "..context["name"], "\n   Linenumber: "..context["currentline"], "\n   SourceFileName: "..context["source"]:sub(2,-1).."\n   Timestamp: "..timestamp)
  elseif show==3 then
    print_update("\n>>Called in\n   Function  : "..context["name"], "   Linenumber: "..context["currentline"], "   SourceFileName: "..context["source"]:sub(2,-1).."\n   Timestamp: "..timestamp)
  end
  return context["name"], context["currentline"], context["source"]:sub(2,-1), timestamp
end


function ultraschall.ConvertIniStringToTable(ini_string, convert_numbers_to_numbers)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertIniStringToTable</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table ini_entries = ultraschall.ConvertIniStringToTable(string ini_string, boolean convert_numbers_to_numbers)</functioncall>
  <description>
    this converts a string in ini-format into a table
    
    the table is in the format:
        ini_entries["sectionname"]["keyname"]=value
    
    returns nil in case of an error
  </description>
  <retvals>
    table ini_entries - the entries of the ini-file as a table
  </retvals>
  <parameters>
    string ini_string - the string that contains an ini-file-contents
    boolean convert_numbers_to_numbers - true, convert values who are valid numbers to numbers; false or nil, keep all values as strings
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>helperfunctions, convert, ini file, table</tags>
</US_DocBloc>
--]]
  if type(ini_string)~="string" then ultraschall.AddErrorMessage("ConvertIniStringToTable", "ini_string", "must be a string", -1) return end
  if convert_numbers_to_numbers~=nil and type(convert_numbers_to_numbers)~="boolean" then ultraschall.AddErrorMessage("ConvertIniStringToTable", "convert_numbers_to_numbers", "must be either nil or boolean", -2) return end
  local IniTable={}
  local cur_entry=""
  for k in string.gmatch(ini_string, "(.-)\n") do
    if k:sub(1,1)=="[" and k:sub(-1,-1)=="]" then
      cur_entry=k:sub(2,-2)
      IniTable[cur_entry]={}
    else
      local key, value=k:match("(.-)=(.*)")
      if key~=nil then 
        if convert_numbers_to_numbers==true and tonumber(value)~=nil then 
          IniTable[cur_entry][key]=tonumber(value)
        else 
          IniTable[cur_entry][key]=value
        end
      end
    end
  end
  return IniTable
end


function string.has_control(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_control</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_control(string value)</functioncall>
  <description>
    returns, if a string has control-characters
  </description>
  <parameters>
    string value - the value to check for control-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, control</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_control' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%c")~=nil
end

function string.has_alphanumeric(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_alphanumeric</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_alphanumeric(string value)</functioncall>
  <description>
    returns, if a string has alphanumeric-characters
  </description>
  <parameters>
    string value - the value to check for alphanumeric-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, alphanumeric</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_alphanumeric' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%w")~=nil
end

function string.has_letter(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_letter</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_letter(string value)</functioncall>
  <description>
    returns, if a string has letter-characters
  </description>
  <parameters>
    string value - the value to check for letter-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, letter</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_letter' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%a")~=nil
end

function string.has_digits(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_digits</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_digits(string value)</functioncall>
  <description>
    returns, if a string has digit-characters
  </description>
  <parameters>
    string value - the value to check for digit-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, digit</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_digits' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%d")~=nil
end

function string.has_printables(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_printables</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_printables(string value)</functioncall>
  <description>
    returns, if a string has printable-characters
  </description>
  <parameters>
    string value - the value to check for printable-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, printable</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_printables' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%g")~=nil
end

function string.has_uppercase(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_uppercase</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_uppercase(string value)</functioncall>
  <description>
    returns, if a string has uppercase-characters
  </description>
  <parameters>
    string value - the value to check for uppercase-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, uppercase</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_uppercase' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%u")~=nil
end

function string.has_lowercase(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_lowercase</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_lowercase(string value)</functioncall>
  <description>
    returns, if a string has lowercase-characters
  </description>
  <parameters>
    string value - the value to check for lowercase-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, lowercase</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_lowercase' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%l")~=nil
end

function string.has_space(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_space</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_space(string value)</functioncall>
  <description>
    returns, if a string has space-characters, like tab or space
  </description>
  <parameters>
    string value - the value to check for space-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, space, tab</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_space' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%s")~=nil
end

function string.has_hex(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_hex</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_hex(string value)</functioncall>
  <description>
    returns, if a string has hex-characters
  </description>
  <parameters>
    string value - the value to check for hex-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, hex</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_hex' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%x")~=nil
end

function string.utf8_sub(source_string, startoffset, endoffset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>utf8_sub</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string ret_string = string.utf8_sub(string source_string, integer startoffset, integer endoffset)</functioncall>
  <description>
    returns a subset of a utf8-encoded-string.
    
    if startoffset and/or endoffset are negative, it is counted from the end of the string.
    
    Works basically like string.sub()
  </description>
  <parameters>
    string value - the value to get the utf8-substring from
    integer startoffset - the startoffset, from which to return the substring; negative offset counts from the end of the string
    integer endoffset - the endoffset, to which to return the substring; negative offset counts from the end of the string
  </parameters>
  <retvals>
    string ret_string - the returned string
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, sub, utf8</tags>
</US_DocBloc>
--]]
  -- written by CFillion for his Interactive ReaScript-Tool, available in the ReaTeam-repository(install via ReaPack)
  -- thanks for allowing me to use it :)
  if type(source_string)~="string" then error("bad argument #1, to 'source_string' (string expected, got "..type(source_string)..")", 2) end
  if math.type(startoffset)~="integer" then error("bad argument #2, to 'startoffset' (integer expected, got "..type(source_string)..")", 2) end
  if math.type(endoffset)~="integer" then error("bad argument #3, to 'endoffset' (integer expected, got "..type(source_string)..")", 2) end
  startoffset = utf8.offset(source_string, startoffset)
  if not startoffset then return '' end -- i is out of bounds

  if endoffset and (endoffset > 0 or endoffset < -1) then
    endoffset = utf8.offset(source_string, endoffset + 1)
    if endoffset then endoffset = endoffset - 1 end
  end

  return string.sub(source_string, startoffset, endoffset)
end

function string.utf8_len(source_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>utf8_len</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length = string.utf8_len(string source_string)</functioncall>
  <description>
    returns the length of an utf8-encoded string

    Works basically like string.len()
  </description>
  <parameters>
    string value - the value to get the length of the utf8-encoded-string
  </parameters>
  <retvals>
    integer length - the length of the utf8-encoded string
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, length, utf8</tags>
</US_DocBloc>
--]]
  if type(source_string)~="string" then error("bad argument #1, to 'utf8_len' (string expected, got "..type(source_string)..")", 2) end
  return utf8.len(source_string)
end

function ultraschall.StoreRenderTable_ProjExtState(proj, section, RenderTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreRenderTable_ProjExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StoreRenderTable_ProjExtState(ReaProject proj, string section, table RenderTable)</functioncall>
  <description>
    Stores the render-settings of a RenderTable into a project-extstate.
  </description>
  <parameters>
    ReaProject proj - the project, into which you want to store the render-settings
    string section - the section-name, into which you want to store the render-settings
    table RenderTable - the RenderTable which holds all render-settings
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, store, render table, projextstate</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "proj", "must be a valid ReaProject", -1) return end
  if type(section)~="string" then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "section", "must be a string", -2) return end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("StoreRenderTable_ProjExtState", "RenderTable", "must be a valid RenderTable", -3) return end
  
  for k, v in pairs(RenderTable) do
    reaper.SetProjExtState(proj, section, k, tostring(v))
  end
end

--ultraschall.StoreRenderTable_ProjExtState(0, "test", A)

function ultraschall.GetRenderTable_ProjExtState(proj, section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ProjExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ProjExtState(ReaProject proj, string section)</functioncall>
  <description>
    Gets the render-settings of a RenderTable from a project-extstate, stored by SetRenderTable_ProjExtState.
  </description>
  <retvals>
    table RenderTable - the stored render-settings as a RenderTable
  </retvals>
  <parameters>
    ReaProject proj - the project, in which you stored the render-settings
    string section - the section-name, in which you stored the render-settings
  </parameters>  
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, get, render table, projextstate</tags>
</US_DocBloc>
--]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("GetRenderTable_ProjExtState", "proj", "must be a valid ReaProject", -1) return end
  if type(section)~="string" then ultraschall.AddErrorMessage("GetRenderTable_ProjExtState", "section", "must be a string", -2) return end
  
  local RenderTable=ultraschall.CreateNewRenderTable()
  for k, v in pairs(RenderTable) do
    local retval, val = reaper.GetProjExtState(proj, section, k)
    if type(v)=="number" then val=tonumber(val)
    elseif type(v)=="boolean" then val=toboolean(val)
    elseif val=="" then val=v
    end
    RenderTable[k]=val
  end
  return RenderTable
end

--B=ultraschall.GetRenderTable_ProjExtState(0, "test")

function ultraschall.StoreRenderTable_ExtState(section, RenderTable, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreRenderTable_ExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StoreRenderTable_ExtState(string section, table RenderTable, boolean persist)</functioncall>
  <description>
    Stores the render-settings of a RenderTable into an extstate.
  </description>
  <parameters>
    string section - the section-name, into which you want to store the render-settings
    table RenderTable - the RenderTable which holds all render-settings
    boolean persist - true, the settings shall be stored long-term; false, the settings shall be stored until Reaper exits
  </parameters>
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, store, render table, extstate</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "section", "must be a string", -1) return end
  if ultraschall.IsValidRenderTable(RenderTable)==false then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "RenderTable", "must be a valid RenderTable", -2) return end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("StoreRenderTable_ExtState", "persist", "must be a boolean", -3) return end
  
  for k, v in pairs(RenderTable) do
    reaper.SetExtState(section, k, tostring(v), persist)
  end
end

--ultraschall.StoreRenderTable_ExtState("test", A, false)

function ultraschall.GetRenderTable_ExtState(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderTable_ExtState</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table RenderTable = ultraschall.GetRenderTable_ExtState(string section)</functioncall>
  <description>
    Gets the render-settings of a RenderTable from an extstate, stored by SetRenderTable_ExtState.
  </description>
  <retvals>
    table RenderTable - the stored render-settings as a RenderTable
  </retvals>
  <parameters>
    string section - the section-name, in which you stored the render-settings
  </parameters>  
  <chapter_context>
    Rendering Projects
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render functions, get, render table, extstate</tags>
</US_DocBloc>
--]]
  if type(section)~="string" then ultraschall.AddErrorMessage("GetRenderTable_ExtState", "section", "must be a string", -1) return end
  
  local RenderTable=ultraschall.CreateNewRenderTable()
  for k, v in pairs(RenderTable) do
    local val = reaper.GetExtState(section, k)
    if type(v)=="number" then val=tonumber(val)
    elseif type(v)=="boolean" then val=toboolean(val)
    elseif val=="" then val=v
    end
    RenderTable[k]=val
  end
  return RenderTable
end

--B=ultraschall.GetRenderTable_ExtState("test")
--ultraschall.IsValidRenderTable(B)


-- Need to be documented, but are finished



function ultraschall.Docs_GetReaperApiFunction_Description(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string description = ultraschall.Docs_GetReaperApiFunction_Description(string functionname)</functioncall>
  <description>
    returns the description of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string description - the description of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, description, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
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
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Call</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string functioncall = ultraschall.Docs_GetReaperApiFunction_Call(string functionname, integer proglang)</functioncall>
  <description>
    returns the functioncall of a function from the documentation    
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
    integer proglang - the programming-language for which you want to get the function-call
                     - 1, C
                     - 2, EEL2
                     - 3, Lua
                     - 4, Python
  </parameters>
  <retvals>
    string functioncall - the functioncall of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, functioncall, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "must be a string", -1) return nil end
  if math.type(proglang)~="integer" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "must be an integer", -2) return nil end
  if proglang<1 or proglang>4 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "no such programming language available", -3) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  
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
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_GetReaperApiFunction_Description()</functioncall>
  <description>
    (re-)loads the api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, reaper</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
  ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
  ultraschall.Docs_ReaperApiDocBlocs_Slug={}
  ultraschall.Docs_ReaperApiDocBlocs_Titles={}
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
    ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    ultraschall.Docs_ReaperApiDocBlocs_Slug[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
  end
end

function ultraschall.Docs_FindReaperApiFunction_Pattern(pattern, case_sensitive, include_descriptions, include_tags, include_retvalnames, include_paramnames)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindReaperApiFunction_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_functions_count, table found_functions, table found_functions_desc = ultraschall.Docs_FindReaperApiFunction_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for functionnames in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned tables found_functions is of the format:
      found_functions_desc[function_index]["functionname"] - the name of the function
      found_functions_desc[function_index]["description"] - the entire description
      found_functions_desc[function_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_functions_desc[function_index]["desc_startoffset"] - the startoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["desc_endoffset"] - the endoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["extension"] - the extension used, like Reaper, SWS, JS, ReaImGui, Osara, etc
      found_functions_desc[function_index]["extension_version"] - the version of the extension
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_functions_count - the number of found functions that follow the search-pattern
    table found_functions - a table with all found functions that follow the search pattern
    table found_functions_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a function
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, api, function, extensions, description, pattern, tags, reaper</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_tags", "must be a string", -4) return -1 end
  if include_retval~=nil and type(include_retval)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_retval", "must be a string", -5) return -1 end
  if include_paramnames~=nil and type(include_paramnames)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_paramnames", "must be a string", -6) return -1 end
  
  -- include_retvalnames, include_paramnames not yet implemented
  -- probably needs RetVal/Param-function that returns datatypes and name independently from each other
  -- which also means: all functions must return values with a proper, descriptive name(or at least retval)
  --                   or this breaks -> Doc-CleanUp-Work...Yeah!!! (looking forward to it, actually)
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
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
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
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
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}        
        FoundInformation[Found_count+1]["functionname"]=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["functionname"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      local A,B,C,D,E=ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
      if B[2]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[2]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      elseif B[1]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[1]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      else
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]="", -1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

--A,B,C=ultraschall.Docs_FindReaperApiFunction_Pattern("tudel", false, false, 10, 14, nil, nil, true)

function ultraschall.Docs_GetReaperApiFunction_Retvals(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Retvals</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retvalscount, table retvals = ultraschall.Docs_GetReaperApiFunction_Retvals(string functionname)</functioncall>
  <description>
    returns the returnvalues of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    Table retvals is of the following structure:
      retvals[retvalindex]["datatype"] - the datatype of this retval
      retvals[retvalindex]["name"] - the name of this retval
      retvals[retvalindex]["description"] - the description for this retval
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose retvals you want to get
  </parameters>
  <retvals>
    integer retvalscount - the number of found returnvalues
    table retvals - a table with all return-values
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, retvals, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Retvals", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
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
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Retvals", "functionname", "function not found", -2) return -1 end

  local retvalscount, retvals, markuptype, markupversion, prog_lang, spok_lang, indent = 
          ultraschall.Docs_GetUSDocBloc_Retvals(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  local retvals2={}
  for i=1, retvalscount do
    retvals2[i]={}
    retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.-) (.*)")
    if retvals2[i]["name"]==nil then retvals2[i]["name"]="retval" end
    if retvals2[i]["datatype"]==nil then retvals2[i]["datatype"]=retvals[i][1] end
    retvals2[i]["description"]=retvals[i][2]
    
  end
  
  return retvalscount, retvals2
end

--A={ultraschall.Docs_GetReaperApiFunction_Retvals("ImGui_ButtonFlags_MouseButtonLeft")}

function ultraschall.Docs_GetReaperApiFunction_Params(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Params</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer paramscount, table params = ultraschall.Docs_GetReaperApiFunction_Params(string functionname)</functioncall>
  <description>
    returns the parameters of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    Table params is of the following structure:
      params[paramsindex]["datatype"] - the datatype of this parameter
      params[paramsindex]["name"] - the name of this parameter
      params[paramsindex]["description"] - the description for this parameter
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose parameter you want to get
  </parameters>
  <retvals>
    integer paramscount - the number of found parameters
    table params - a table with all parameters
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, params, parameters, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Params", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
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
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Params", "functionname", "function not found", -2) return -1 end

  local parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = 
      ultraschall.Docs_GetUSDocBloc_Params(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  local Params2={}
  for i=1, parmcount do
    Params2[i]={}
    Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.-) (.*)")
    if Params2[i]["name"]==nil then Params2[i]["name"]="retval" end
    if Params2[i]["datatype"]==nil then Params2[i]["datatype"]=Params[i][1] end
    Params2[i]["description"]=Params[i][2]
  end
  
  return parmcount, Params2
end

--A={ultraschall.Docs_GetReaperApiFunction_Params("gfx.getchar")}

function ultraschall.Docs_GetReaperApiFunction_Tags(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Tags</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer tags_count, table tags = ultraschall.Docs_GetReaperApiFunction_Tags(string functionname)</functioncall>
  <description>
    returns the tags of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose tags you want to get
  </parameters>
  <retvals>
    integer tags_count - the number of tags for this function
    table tags - the tags of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, tags, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Tags", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
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
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Tags", "functionname", "function not found", -2) return -1 end
  
  local count, tags, spok_lang = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperApiDocBlocs[found], 1)
  
  return count, tags
end

--A={ultraschall.Docs_GetReaperApiFunction_Tags("CF_GetClipboard")}


function ultraschall.Docs_GetReaperApiFunction_Requires(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Requires</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer requires_count, table requires, table requires_alt = ultraschall.Docs_GetReaperApiFunction_Requires(string functionname)</functioncall>
  <description>
    returns the requires of a function from the documentation
    
    The requires usually mean dependencies of extensions with a specific version or specific Reaper-versions
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose requires you want to get
  </parameters>
  <retvals>
    integer requires_count - the number of requires for this function
    table requires - the requires of this function
    table requires_alt - like requires but has the require name as index, like Reaper or SWS
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, requires, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Requires", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
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
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Requires", "functionname", "function not found", -2) return -1 end
  
  local count, requires, requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_ReaperApiDocBlocs[found], 1)
  
  return count, requires, requires_alt
end

function ultraschall.Docs_GetAllReaperApiFunctionnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Docs_GetAllReaperApiFunctionnames</slug>
    <requires>
      Ultraschall=4.8
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>table slugs, table titles = ultraschall.Docs_GetAllReaperApiFunctionnames()</functioncall>
    <description>
      returns tables with all slugs and all titles of all Reaper-API-functions(usually the functionnames)
    </description>
    <retval>
      table slugs - all slugs(usually the functionnames) of all Reaper API-functions
      table titles - all titles(usually the functionnames) of all Reaper API-functions
    </retval>
    <chapter_context>
      Reaper Docs
    </chapter_context>
    <target_document>US_Api_DOC</target_document>
    <source_document>Modules/ultraschall_doc_engine.lua</source_document>
    <tags>documentation, get, slugs, docs, description, reaper</tags>
  </US_DocBloc>
  ]]
  if ultraschall.Docs_ReaperApiDocBlocs==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end

  return ultraschall.Docs_ReaperApiDocBlocs_Slug, ultraschall.Docs_ReaperApiDocBlocs_Titles
end

function ultraschall.Docs_LoadReaperConfigVarsDocBlocs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_LoadReaperConfigVarsDocBlocs</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_LoadReaperConfigVarsDocBlocs()</functioncall>
  <description>
    (re-)loads the config-var api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, config variables, config vars, configvars</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperConfigVarsDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Config_Variables.USDocML")
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Count, ultraschall.Docs_ReaperConfigVarsDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperConfigVarsDocBlocs)
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug={}
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Titles={}
  for i=1, ultraschall.Docs_ReaperConfigVarsDocBlocs_Count do 
    ultraschall.Docs_ReaperConfigVarsDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)
    ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)
  end
end


--A=ultraschall.Docs_LoadReaperConfigVarsDocBlocs()

--B={ultraschall.Docs_GetReaperApiFunction_Call(A[10], 3)}

function ultraschall.Docs_FindReaperConfigVar_Pattern(pattern, case_sensitive, include_descriptions, include_tags)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindReaperConfigVar_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_configvar_count, table found_configvars, table found_config_vars_desc = ultraschall.Docs_FindReaperConfigVar_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for configvariables in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned table found_config_vars_desc is of the format: 
      found_config_vars_desc[configvar_index]["configvar"] - the name of the found config variable
      found_config_vars_desc[configvar_index]["description"] - the entire description
      found_config_vars_desc[configvar_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_config_vars_desc[configvar_index]["desc_startoffset"] - the startoffset of the found pattern; -1, if pattern not found in description
      found_config_vars_desc[configvar_index]["desc_endoffset"] - the endoffset of the found pattern; -1, if pattern not found in description
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_configvar_count - the number of found config variables that follow the search-pattern
    table found_configvars - a table with all found config variables that follow the search pattern
    table found_config_vars_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
                               - table will be nil if include_descriptions=false
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a config variable
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, description, pattern, tags, config variables, config vars, configvars</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "include_tags", "must be a string", -4) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug==nil then ultraschall.Docs_LoadReaperConfigVarsDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  local found_this_time=false
  for i=1, ultraschall.Docs_ReaperConfigVarsDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)      
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}
        FoundInformation[Found_count+1]["configvar"]=Title
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      else
        FoundInformation[Found_count+1]={}
        FoundInformation[Found_count+1]["configvar"]=Title
        FoundInformation[Found_count+1]["description_snippet"]=""
        FoundInformation[Found_count+1]["description"]=""
        FoundInformation[Found_count+1]["desc_startoffset"]=-1 -- startoffset of found pattern, so this part can be highlighted
                                                               -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=-1   -- startoffset of found pattern, so this part can be highlighted
                                                               -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["configvar"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

function ultraschall.Docs_LoadUltraschallAPIDocBlocs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_LoadUltraschallAPIDocBlocs</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_LoadUltraschallAPIDocBlocs()</functioncall>
  <description>
    (re-)loads the Ultraschall-API-api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, ultraschall api</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperConfigVarsDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Config_Variables.USDocML")
  ultraschall.Docs_US_Functions=""
  for k in io.lines(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/misc/Ultraschall_Api_List_Of_USDocML-Containing_Files.txt") do
    ultraschall.Docs_US_Functions=ultraschall.Docs_US_Functions.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/"..k)
  end
  ultraschall.Docs_US_Functions_USDocBlocs_Count, ultraschall.Docs_US_Functions_USDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_US_Functions)
  ultraschall.Docs_US_Functions_USDocBlocs_Slug={}
  ultraschall.Docs_US_Functions_USDocBlocs_Titles={}
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do 
    ultraschall.Docs_US_Functions_USDocBlocs_Slug[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
    ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
  end
end

--ultraschall.Docs_LoadUltraschallAPIDocBlocs()

function ultraschall.Docs_GetUltraschallApiFunction_Call(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Call</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string functioncall = ultraschall.Docs_GetUltraschallApiFunction_Call(string functionname)</functioncall>
  <description>
    returns the functioncall of an Ultraschall-API-function from the documentation    
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string functioncall - the functioncall of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, functioncall, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "function not found", -4) return end
  
  local Call, prog_lang
  Call, prog_lang  = ultraschall.Docs_GetUSDocBloc_Functioncall(ultraschall.Docs_US_Functions_USDocBlocs[found],1)
  
  if Call==nil then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "no such programming language available", -5) return end
  Call = string.gsub(Call, "&lt;", "<")
  Call = string.gsub(Call, "&gt;", ">")
  Call = string.gsub(Call, "&amp;", "&")
  return Call
end

--A,B=ultraschall.Docs_GetUltraschallApiFunction_Call("ReadFullFile")

function ultraschall.Docs_GetUltraschallApiFunction_Description(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string description = ultraschall.Docs_GetUltraschallApiFunction_Description(string functionname)</functioncall>
  <description>
    returns the description of an Ultraschall-API function from the documentation
  
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string description - the description of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, description, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "function not found", -4) return end
  
  local Description, markup_type, markup_version
  
  Description, markup_type, markup_version  = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  if Description==nil then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "no description existing", -3) return end

  Description = string.gsub(Description, "&lt;", "<")
  Description = string.gsub(Description, "&gt;", ">")
  Description = string.gsub(Description, "&amp;", "&")
  return Description, markup_type, markup_version
end

--A,B=ultraschall.Docs_GetUltraschallApiFunction_Description("ReadFullFile")

function ultraschall.Docs_FindUltraschallApiFunction_Pattern(pattern, case_sensitive, include_descriptions, include_tags, include_retvalnames, include_paramnames)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindUltraschallApiFunction_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_functions_count, table found_functions, table found_functions_desc = ultraschall.Docs_FindUltraschallApiFunction_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for Ultraschall-API functionnames in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned tables found_functions is of the format:
      found_functions_desc[function_index]["functionname"] - the name of the function
      found_functions_desc[function_index]["description"] - the entire description
      found_functions_desc[function_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_functions_desc[function_index]["desc_startoffset"] - the startoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["desc_endoffset"] - the endoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["extension"] - the extension used, like Reaper, SWS, JS, ReaImGui, Osara, etc
      found_functions_desc[function_index]["extension_version"] - the version of the extension
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_functions_count - the number of found functions that follow the search-pattern
    table found_functions - a table with all found functions that follow the search pattern
    table found_functions_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a function
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, api, function, extensions, description, pattern, tags, ultraschall api</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_tags", "must be a string", -4) return -1 end
  if include_retval~=nil and type(include_retval)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_retval", "must be a string", -5) return -1 end
  if include_paramnames~=nil and type(include_paramnames)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_paramnames", "must be a string", -6) return -1 end
  
  -- include_retvalnames, include_paramnames not yet implemented
  -- probably needs RetVal/Param-function that returns datatypes and name independently from each other
  -- which also means: all functions must return values with a proper, descriptive name(or at least retval)
  --                   or this breaks -> Doc-CleanUp-Work...Yeah!!! (looking forward to it, actually)
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  local found_this_time=false
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)      
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_US_Functions_USDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}        
        FoundInformation[Found_count+1]["functionname"]=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["functionname"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      local A,B,C,D,E=ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
      if B[2]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[2]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      elseif B[1]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[1]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      else
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]="", -1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

--A={ultraschall.Docs_FindUltraschallApiFunction_Pattern("RenderTable", false, true, false, false, false)}

function ultraschall.Docs_GetUltraschallApiFunction_Retvals(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Retvals</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retvalscount, table retvals = ultraschall.Docs_GetUltraschallApiFunction_Retvals(string functionname)</functioncall>
  <description>
    returns the returnvalues of an Ultraschall API function from the documentation
    
    Table retvals is of the following structure:
      retvals[retvalindex]["datatype"] - the datatype of this retval
      retvals[retvalindex]["name"] - the name of this retval
      retvals[retvalindex]["description"] - the description for this retval
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose retvals you want to get
  </parameters>
  <retvals>
    integer retvalscount - the number of found returnvalues
    table retvals - a table with all return-values
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, retvals, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Retvals", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Retvals", "functionname", "function not found", -4) return end
  
  local retvalscount, retvals, markuptype, markupversion, prog_lang, spok_lang, indent = 
  
  ultraschall.Docs_GetUSDocBloc_Retvals(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  local retvals2={}
  for i=1, retvalscount do
    retvals2[i]={}
    retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.-) (.*)")
    if retvals2[i]["name"]==nil then retvals2[i]["name"]="retval" end
    if retvals2[i]["datatype"]==nil then retvals2[i]["datatype"]=retvals[i][1] end
    retvals2[i]["description"]=retvals[i][2]
    
  end
  
  return retvalscount, retvals2
end

function ultraschall.Docs_GetUltraschallApiFunction_Params(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Params</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer paramscount, table params = ultraschall.Docs_GetUltraschallApiFunction_Params(string functionname)</functioncall>
  <description>
    returns the parameters of an Ultraschall-API function from the documentation

    Table params is of the following structure:
      params[paramsindex]["datatype"] - the datatype of this parameter
      params[paramsindex]["name"] - the name of this parameter
      params[paramsindex]["description"] - the description for this parameter
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose parameter you want to get
  </parameters>
  <retvals>
    integer paramscount - the number of found parameters
    table params - a table with all parameters
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, params, parameters, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Params", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Params", "functionname", "function not found", -4) return end
  
  local parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = 
  
  ultraschall.Docs_GetUSDocBloc_Params(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  local Params2={}
  for i=1, parmcount do
    Params2[i]={}
    Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.-) (.*)")
    if Params2[i]["name"]==nil then Params2[i]["name"]="retval" end
    if Params2[i]["datatype"]==nil then Params2[i]["datatype"]=Params[i][1] end
    Params2[i]["description"]=Params[i][2]
  end
  
  return parmcount, Params2
end

--SLEM()
--A={ultraschall.Docs_GetUltraschallApiFunction_Params("ReadFullFile")}

function ultraschall.Docs_GetUltraschallApiFunction_Tags(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Tags</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer tags_count, table tags = ultraschall.Docs_GetUltraschallApiFunction_Tags(string functionname)</functioncall>
  <description>
    returns the tags of an Ultraschall-API function from the documentation

    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose tags you want to get
  </parameters>
  <retvals>
    integer tags_count - the number of tags for this function
    table tags - the tags of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, tags, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Tags", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Tags", "functionname", "function not found", -4) return end
  
  local count, tags, spok_lang = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_US_Functions_USDocBlocs[found], 1)
  
  return count, tags
end

--A={ultraschall.Docs_GetUltraschallApiFunction_Tags("ReadFullFile")}


function ultraschall.Docs_GetUltraschallApiFunction_Requires(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Requires</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer requires_count, table requires, table requires_alt = ultraschall.Docs_GetUltraschallApiFunction_Requires(string functionname)</functioncall>
  <description>
    returns the requires of an Ultraschall-API function from the documentation
    
    The requires usually mean dependencies of extensions with a specific version or specific Reaper-versions
  
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose requires you want to get
  </parameters>
  <retvals>
    integer requires_count - the number of requires for this function
    table requires - the requires of this function
    table requires_alt - like requires but has the require name as index, like Reaper or SWS
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, requires, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Requires", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Requires", "functionname", "function not found", -4) return end
  
  local count, requires, requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_US_Functions_USDocBlocs[found], 1)
  
  return count, requires, requires_alt
end

--A={ultraschall.Docs_GetUltraschallApiFunction_Requires("RenderProject")}


function ultraschall.Docs_GetAllUltraschallApiFunctionnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Docs_GetAllUltraschallApiFunctionnames</slug>
    <requires>
      Ultraschall=4.8
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>table slugs = ultraschall.Docs_GetAllUltraschallApiFunctionnames()</functioncall>
    <description>
      returns tables with all slugs of all Ultraschall-API-functions and variables
    </description>
    <retval>
      table slugs - all slugs(usually the functionnames) of all Reaper API-functions
      table titles - all titles(usually the functionnames) of all Reaper API-functions
    </retval>
    <chapter_context>
      Reaper Docs
    </chapter_context>
    <target_document>US_Api_DOC</target_document>
    <source_document>Modules/ultraschall_doc_engine.lua</source_document>
    <tags>documentation, get, slugs, docs, description, ultraschall api</tags>
  </US_DocBloc>
  ]]
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  return ultraschall.Docs_US_Functions_USDocBlocs_Slug
end