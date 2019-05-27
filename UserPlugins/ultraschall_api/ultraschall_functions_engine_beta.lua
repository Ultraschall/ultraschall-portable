--[[
################################################################################
# 
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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



if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
end

function ultraschall.ApiBetaFunctionsTest()
    -- tell the api, that the beta-functions are activated
    ultraschall.functions_beta_works="on"
end

  


--ultraschall.ShowErrorMessagesInReascriptConsole(true)

--ultraschall.WriteValueToFile()

--ultraschall.AddErrorMessage("func","parm","desc",2)




function ultraschall.GetProject_RenderOutputPath(projectfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderOutputPath</slug>
  <requires>
    Ultraschall=4.00
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
  <target_document>US_Api_Documentation</target_document>
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


function ultraschall.ResolveRenderPattern(renderpattern)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ResolveRenderPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string resolved_renderpattern = ultraschall.ResolveRenderPattern(string render_pattern)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    resolves a render-pattern into its render-filename(without extension).

    returns nil in case of an error    
  </description>
  <parameters>
    string render_pattern - the render-pattern, that you want to resolve into its render-filename
  </parameters>
  <retvals>
    string resolved_renderpattern - the resolved renderpattern, that is used for a render-filename.
                                  - just add extension and path to it.
                                  - Stems will be rendered to path/resolved_renderpattern-XXX.ext
                                  -    where XXX is a number between 001(usually for master-track) and 999
  </retvals>
  <chapter_context>
    Rendering of Project
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>rendermanagement, resolve, renderpattern, filename</tags>
</US_DocBloc>
]]
  if type(renderpattern)~="string" then ultraschall.AddErrorMessage("ResolveRenderPattern", "renderpattern", "must be a string", -1) return nil end
  if renderpattern=="" then return "" end
  local TempProject=ultraschall.Api_Path.."misc/tempproject.RPP"
  local TempFolder=ultraschall.Api_Path.."misc/"
  TempFolder=string.gsub(TempFolder, "\\", ultraschall.Separator)
  TempFolder=string.gsub(TempFolder, "/", ultraschall.Separator)
  
  ultraschall.SetProject_RenderFilename(TempProject, "")
  ultraschall.SetProject_RenderPattern(TempProject, renderpattern)
  ultraschall.SetProject_RenderStems(TempProject, 0)
  
  reaper.Main_OnCommand(41929,0)
  reaper.Main_openProject(TempProject)
  
  A,B=ultraschall.GetProjectStateChunk()
  reaper.Main_SaveProject(0,false)
  reaper.Main_OnCommand(40860,0)
  if B==nil then B="" end
  
  count, split_string = ultraschall.SplitStringAtLineFeedToArray(B)

  for i=1, count do
    split_string[i]=split_string[i]:match("\"(.-)\"")
  end
  if split_string[1]==nil then split_string[1]="" end
  return string.gsub(split_string[1], TempFolder, ""):match("(.-)%.")
end

--for i=1, 10 do
--  O=ultraschall.ResolveRenderPattern("I would find a way $day")
--end




--Event Manager
function ultraschall.ResetEvent(Event_Section)
  if Event_Section==nil and Ultraschall_Event_Section~=nil then 
    Event_Section=Ultraschall_Event_Section 
  end
  if type(Event_Section)~="string" then ultraschall.AddErrorMessage("ResetEvent", "Event_Section", "must be a string", -1) return false end
  local A=reaper.GetExtState(Event_Section, "NumEvents")
  if A~="" then 
    for i=1, A do
      reaper.DeleteExtState(Event_Section, "Event"..i, false)
    end
  end
  reaper.DeleteExtState(Event_Section, "NumEvents", false)
  reaper.DeleteExtState(Event_Section, "Old", false)
  reaper.DeleteExtState(Event_Section, "New", false)
  reaper.DeleteExtState(Event_Section, "ScriptIdentifier", false)
end


function ultraschall.RegisterEvent(Event_Section, Event)
  if type(Event_Section)~="string" then ultraschall.AddErrorMessage("RegisterEvent", "Event_Section", "must be a string", -1) return false end
  if type(Event)~="string" then ultraschall.AddErrorMessage("RegisterEvent", "Event", "must be a string", -2) return false end
  local A=reaper.GetExtState(Event_Section, "NumEvents")
  if A=="" then A=0 else A=tonumber(A) end
  reaper.SetExtState(Event_Section, "ScriptIdentifier", ultraschall.ScriptIdentifier, false)
  reaper.SetExtState(Event_Section, "NumEvents", A+1, false)
  reaper.SetExtState(Event_Section, "Event"..A+1, Event, false)
end

function ultraschall.SetEventState(Event_Section, OldEvent, NewEvent)
  if type(Event_Section)~="string" then ultraschall.AddErrorMessage("RegisterEvent", "Event_Section", "must be a string", -1) return false end
  OldEvent=tostring(OldEvent)
  NewEvent=tostring(NewEvent)
  reaper.SetExtState(Event_Section, "Old", OldEvent, false)
  reaper.SetExtState(Event_Section, "New", NewEvent, false)
  reaper.SetExtState(Event_Section, "ScriptIdentifier", ultraschall.ScriptIdentifier, false)
end

function ultraschall.RegisterEventAction(eventconditions, action)
  -- eventconditions is an array of the following structure
  -- eventconditions[idx][1] - oldstate
  -- eventconditions[idx][2] - newstate
  -- eventconditions[idx][3] - comparison 
  --                                fixed events: ! for not and = for equal
  --                                unfixed events(numbers): < = >
  -- if all these conditions are met, the eventmanager will run the action, otherwise it does nothing
end

function ultraschall.GetAllAvailableEvents()
  return ultraschall.SplitStringAtLineFeedToArray(reaper.GetExtState("ultraschall_event_manager", "allevents"))
end

--A,B=ultraschall.GetAllAvailableEvents()

function ultraschall.GetAllEventStates()
  local count, array = ultraschall.SplitStringAtLineFeedToArray(reaper.GetExtState("ultraschall_event_manager", "eventstates"))
  if array[1]~="" then
    return reaper.GetExtState("ultraschall_event_manager", "event"), count, array
  else
    return "", 0, {}
  end
end

--A,B,C=ultraschall.GetAllEventStates()

function ultraschall.SetAlterableEvent(Event)
  if type(Event)~="string" then ultraschall.AddErrorMessage("SetAlterableEvent", "Event", "must be a string", -1) return end
  reaper.SetExtState("ultraschall_event_manager", "event", Event, false)
end

--ultraschall.SetAlterableEvent("LoopState")

function ultraschall.SetEvent(command)
  if type(command)~="string" then ultraschall.AddErrorMessage("SetEvent", "command", "must be a string", -1) return end
  reaper.SetExtState("ultraschall_event_manager", "do_command", command, false)
end

--ultraschall.SetEvent("start")

function ultraschall.UpdateEventList()
  reaper.SetExtState("ultraschall_event_manager", "do_command", "update", false)
end

--ultraschall.UpdateEventList()

function ultraschall.GetCurrentEventTransition()
  local event=reaper.GetExtState("ultraschall_event_manager", "event")
  return event, reaper.GetExtState(event, "Old"), reaper.GetExtState(event, "New")
end

--A,B,C=ultraschall.GetCurrentEventTransition()


function ultraschall.StartAllEventListeners()
  reaper.SetExtState("ultraschall_event_manager", "do_command", "startall", false)
end

--A,B,C=ultraschall.StartAllEventListeners()

function ultraschall.StopAllEventListeners()
  reaper.SetExtState("ultraschall_event_manager", "do_command", "stopall", false)
end

--A,B,C=ultraschall.StopAllEventListeners()

function ultraschall.StopEventManager()
  reaper.SetExtState("ultraschall_event_manager", "do_command", "stop_eventlistener", false)
end

function ultraschall.StartEventManager()
  ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/ultraschall_EventManager.lua")
end

--ultraschall.StartEventManager()
--A,B,C=ultraschall.StartAllEventListeners()



ultraschall.ShowLastErrorMessage()


function ultraschall.InsertMediaItemArray2(position, MediaItemArray, trackstring)
  
--ToDo: Die Möglichkeit die Items in andere Tracks einzufügen. Wenn trackstring 1,3,5 ist, die Items im MediaItemArray
--      in 1,2,3 sind, dann landen die Items aus track 1 in track 1, track 2 in track 3, track 3 in track 5
--
-- Beta 3 Material
  
  if type(position)~="number" then return -1 end
  local trackstring,AA,AAA=ultraschall.RemoveDuplicateTracksInTrackstring(trackstring)
  if trackstring==-1 then return -1 end
  local count=1
  local i
  if type(MediaItemArray)~="table" then return -1 end
  local NewMediaItemArray={}
  local _count, individual_values = ultraschall.CSV2IndividualLinesAsArray(trackstring) 
  local ItemStart=reaper.GetProjectLength()+1
  while MediaItemArray[count]~=nil do
    local ItemStart_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    if ItemStart>ItemStart_temp then ItemStart=ItemStart_temp end
    count=count+1
  end
  count=1
  while MediaItemArray[count]~=nil do
    local ItemStart_temp=reaper.GetMediaItemInfo_Value(MediaItemArray[count], "D_POSITION")
    local MediaTrack=reaper.GetMediaItem_Track(MediaItemArray[count])
    --nur einfügen, wenn mediaitem aus nem Track stammt, der in trackstring vorkommt
    i=1
    while individual_values[i]~=nil do
--    reaper.MB("Yup"..i,individual_values[i],0)
    if reaper.GetTrack(0,individual_values[i]-1)==reaper.GetMediaItem_Track(MediaItemArray[count]) then 
    NewMediaItemArray[count]=ultraschall.InsertMediaItem_MediaItem(position+(ItemStart_temp-ItemStart),MediaItemArray[count],MediaTrack)
    end
    i=i+1
    end
    count=count+1
  end  
--  TrackArray[count]=reaper.GetMediaItem_Track(MediaItem)
--  MediaItem reaper.AddMediaItemToTrack(MediaTrack tr)
end

--C,CC=ultraschall.GetAllMediaItemsBetween(1,60,"1,3",false)
--A,B=reaper.GetItemStateChunk(CC[1], "", true)
--reaper.ShowConsoleMsg(B)
--ultraschall.InsertMediaItemArray(82, CC, "4,5")

--tr = reaper.GetTrack(0, 1)
--MediaItem=reaper.AddMediaItemToTrack(tr)
--Aboolean=reaper.SetItemStateChunk(CC[1], PUH, true)
--PCM_source=reaper.PCM_Source_CreateFromFile("C:\\Recordings\\01-te.flac")
--boolean=reaper.SetMediaItemTake_Source(MediaItem_Take, PCM_source)
--reaper.SetMediaItemInfo_Value(MediaItem, "D_POSITION", "1")
--ultraschall.InsertMediaItemArray(0,CC)


function ultraschall.RippleDrag_Start(position, trackstring, deltalength)
  A,MediaItemArray = ultraschall.GetMediaItemsAtPosition(position, trackstring)
  ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(MediaItemArray, deltalength)
  C,CC=ultraschall.GetAllMediaItemsBetween(position, reaper.GetProjectLength(), trackstring, false)
  for i=C, 1, -1 do
    for j=A, 1, -1 do
--      reaper.MB(j,"",0)
      if MediaItemArray[j]==CC[i] then  table.remove(CC, i) end 
    end
  end
  ultraschall.ChangePositionOfMediaItems_FromArray(CC, deltalength)
end

--ultraschall.RippleDrag_Start(13,"1,2,3",-1)

function ultraschall.RippleDragSection_Start(startposition, endposition, trackstring, newoffset)
end

function ultraschall.RippleDrag_StartOffset(position, trackstring, newoffset)
--unfertig und buggy
  A,MediaItemArray = ultraschall.GetMediaItemsAtPosition(position, trackstring)
  ultraschall.ChangeOffsetOfMediaItems_FromArray(MediaItemArray, newoffset)
  ultraschall.ChangeDeltaLengthOfMediaItems_FromArray(MediaItemArray, -newoffset)
  C,CC=ultraschall.GetAllMediaItemsBetween(position, reaper.GetProjectLength(), trackstring, false)
  for i=C, 1, -1 do
    for j=A, 1, -1 do
--      reaper.MB(j,"",0)
      if MediaItemArray[j]==CC[i] then  table.remove(CC, i) end 
    end
  end
  ultraschall.ChangePositionOfMediaItems_FromArray(CC, newoffset)
end

--ultraschall.RippleDrag_StartOffset(13,"2",10)

--A=ultraschall.CreateRenderCFG_MP3CBR(1, 4, 10)
--B=ultraschall.CreateRenderCFG_MP3CBR(1, 10, 10)
--L,L2,L3,L4=ultraschall.RenderProject_RenderCFG(nil, "c:\\Reaper-Internal-Docs.mp3", 0, 10, false, true, true,A)
--L,L1,L2,L3,L4=ultraschall.RenderProjectRegions_RenderCFG(nil, "c:\\Reaper-Internal-Docs.mp3", 1, false, false, true, true,A)
--L=reaper.IsProjectDirty(0)

--outputchannel, post_pre_fader, volume, pan, mute, phase, source, unknown, automationmode = ultraschall.GetTrackHWOut(0, 1)

--count, MediaItemArray_selected = ultraschall.GetAllSelectedMediaItems() -- get old selection
--A=ultraschall.PutMediaItemsToClipboard_MediaItemArray(MediaItemArray_selected)

---------------------------
---- Routing Snapshots ----
---------------------------

function ultraschall.SetRoutingSnapshot(snapshot_nr)
end

function ultraschall.RecallRoutingSnapshot(snapshot_nr)
end

function ultraschall.ClearRoutingSnapshot(snapshot_nr)
end

-----------------------
---- Render Export ----
-----------------------


function ultraschall.RippleDragSection_StartOffset(position,trackstring)
end

function ultraschall.RippleDrag_End(position,trackstring)

end

function ultraschall.RippleDragSection_End(position,trackstring)
end



--ultraschall.ShowLastErrorMessage()

function ultraschall.GetProjectReWireSlave(projectfilename_with_path)
--To Do
-- ProjectSettings->Advanced->Rewire Slave Settings
end

function ultraschall.GetLastEnvelopePoint(Envelopeobject)
end

function ultraschall.GetAllTrackEnvelopes_EnvelopePointArray(tracknumber)
--returns all track-envelopes from tracknumber as EnvelopePointArray
end

function ultraschall.GetAllTrackEnvelopes_EnvelopePointArray2(MediaTrack)
--returns all track-envelopes from MediaTrack as EnvelopePointArray
end



function ultraschall.OnlyMediaItemsInBothMediaItemArrays()
end

function ultraschall.OnlyMediaItemsInOneMediaItemArray()
end

function ultraschall.GetMediaItemTake_StateChunk(MediaItem, idx)
--returns an rppxml-statechunk for a MediaItemTake (not existing yet in Reaper!), for the idx'th take of MediaItem

--number reaper.GetMediaItemTakeInfo_Value(MediaItem_Take take, string parmname)
--MediaItem reaper.GetMediaItemTake_Item(MediaItem_Take take)

--[[Get parent item of media item take

integer reaper.GetMediaItemTake_Peaks(MediaItem_Take take, number peakrate, number starttime, integer numchannels, integer numsamplesperchannel, integer want_extra_type, reaper.array buf)
Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.

PCM_source reaper.GetMediaItemTake_Source(MediaItem_Take take)
Get media source of media item take

MediaTrack reaper.GetMediaItemTake_Track(MediaItem_Take take)
Get parent track of media item take


MediaItem_Take reaper.GetMediaItemTakeByGUID(ReaProject project, string guidGUID)
--]]
end

function ultraschall.GetAllMediaItemTake_StateChunks(MediaItem)
--returns an array with all rppxml-statechunk for all MediaItemTakes of a MediaItem.
end


function ultraschall.AddProjectfileToRenderQueue(Projectfilename2)
-- Todo
-- add 
--  QUEUED_RENDER_OUTFILE "C:\defrenderpath\untitled.flac" 65553 {8B34A896-AAE3-4F7F-9A5E-63C19B1C9AE0}
--  QUEUED_RENDER_ORIGINAL_FILENAME C:\Render-Queue-Documentation.RPP
-- to them
-- the former being dependend on, whether some render-stems is selected

  --Projectfilename2="c:\\Render-Queue-Documentation.RPP"
  local path, projfilename = ultraschall.GetPath(Projectfilename2)
  local Projectfilename=ultraschall.API_TempPath..projfilename
  local A,B, Count, Individual_values, tempa, tempb, filename, Qfilename
  
  ultraschall.MakeCopyOfFile(Projectfilename2, Projectfilename)
  
  --k,Projectfilename = reaper.EnumProjects(-1,"")
  A=ultraschall.ReadFullFile(Projectfilename) 
  B=""
  
  Count, Individual_values = ultraschall.CSV2IndividualLinesAsArray(A, "\n")
  
  
  for i=1, Count do
    if Individual_values[i]:match("^        FILE \"")~=nil then
      filename=Individual_values[i]:match("\"(.-)\"")
      if reaper.file_exists(path..filename)==true then
        tempa, tempb=Individual_values[i]:match("(.-\").-(\".*)")
        Individual_values[i]=tempa..path..filename..tempb
      end
    end
    B=B.."\n"..Individual_values[i]
  end
  
  -- let's create a valid render-queue-filename
  local A, month, day, hour, min, sec
  A=os.date("*t")
  if tostring(A["month"]):len()==1 then month="0"..tostring(A["month"]) else month=tostring(A["month"]) end
  if tostring(A["day"]):len()==1 then day="0"..tostring(A["day"]) else day=tostring(A["day"]) end
  
  if tostring(A["hour"]):len()==1 then hour="0"..tostring(A["hour"]) else hour=tostring(A["hour"]) end
  if tostring(A["min"]):len()==1 then min="0"..tostring(A["min"]) else min=tostring(A["min"]) end
  if tostring(A["sec"]):len()==1 then sec="0"..tostring(A["sec"]) else sec=tostring(A["sec"]) end
  
  Qfilename="qrender_"..tostring(A["year"]):sub(-2,-1)..month..day.."_"..hour..min..sec.."_"..Projectfilename2:match("[\\/](.*)")

  ultraschall.WriteValueToFile("c:\\Ultraschall-Hackversion_3.2_US_beta_2_75\\QueuedRenders\\"..Qfilename, B)
end

--A=9879
--HHhwnd = ultraschall.GetRenderQueueHWND()

--ultraschall.AddProjectfileToRenderQueue("c:\\Render-Queue-Documentation.RPP")



--a,b=reaper.EnumProjects(-1,"")
--A=ultraschall.ReadFullFile(b)

ultraschall.ShowLastErrorMessage()
