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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---  Projects: Management Module  ---
-------------------------------------

function ultraschall.GetProjectFilename(proj)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string projectfilename_with_path = ultraschall.GetProjectFilename(ReaProject proj)</functioncall>
  <description>
    Returns the filename of a currently opened project(-tab)
    
    returns nil in case of an error
  </description>
  <retvals>
    string projectfilename_with_path - the filename of the project; "", project hasn't been saved yet; nil, in case of an error
  </retvals>
  <parameters>
    ReaProject proj - a currently opened project, whose filename you want to know
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>helperfunctions, projectfiles, get, projecttab, filename</tags>
</US_DocBloc>
]]
  if ultraschall.type(proj)~="ReaProject" then ultraschall.AddErrorMessage("GetProjectFilename", "proj", "must be a valid ReaProject-object", -1) return end
  local number_of_projecttabs, projecttablist = ultraschall.GetProject_Tabs()
  for i=1, number_of_projecttabs do
    if proj==projecttablist[i][1] then
      return projecttablist[i][2]
    end
  end
end

function ultraschall.CheckForChangedProjectTabs(update)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckForChangedProjectTabs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer countReorderedProj, array reorderedProj, integer countNewProj, array newProj, integer countClosedProj, array closedProj, integer countRenamedProjects, array RenamesProjects = ultraschall.CheckForChangedProjectTabs(boolean update)</functioncall>
  <description>
    Returns if projecttabs have been changed due reordering, new projects or closed projects, since last calling this function.
    Set update=true to update Ultraschall's internal project-monitoring-list or it will only return the changes since starting the API in this script or since the last time you used this function with parameter update set to true!
    
    Returns false, -1 in case of error.
  </description>
  <retvals>
    boolean retval - false, no changes in the projecttabs at all; true, either order, newprojects or closed project-changes
    integer countReorderedProj - the number of reordered projects
    array reorderedProj - ReaProjects, who got reordered within the tabs
    integer countNewProj - the number of new projects
    array newProj - the new projects as ReaProjects
    integer countClosedProj - the number of closed projects
    array closedProj - the closed projects as ReaProjects
    integer countRenamedProjects - the number of projects, who got renamed by either saving under a new filename or loading of another project
    array RenamesProjects - the renamed projects, by loading a new project or saving the project under another filename
  </retvals>
  <parameters>
    boolean update - true, update Ultraschall's internal projecttab-monitoring-list to the current state of all tabs
                   - false, don't update the internal projecttab-monitoring-list, so it will keep the "old" project-tab-state as checking-reference
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>helperfunctions, projectfiles, check, projecttab, change, order, new, closed, close</tags>
</US_DocBloc>
]]
  if type(update)~="boolean" then ultraschall.AddErrorMessage("CheckForChangedProjectTabs", "update", "Must be a boolean!", -1) return false, -1 end
  local Count, Projects = ultraschall.GetProject_Tabs()

  if ultraschall.ProjectList==nil then 
    if update==true then ultraschall.ProjectList=Projects ultraschall.ProjectCount=Count end
    return false
  end
  
  -- check the order
  local OrderRetValProj={}
  local ordercount=0
  local tempproj
  local tempproj2
  
  for a=1, ultraschall.ProjectCount do
    tempproj=ultraschall.ProjectList[a][1]
    if Projects[a]==nil then break end
    tempproj2=Projects[a][1]
    if tempproj~=tempproj2 then 
        ordercount=ordercount+1
        OrderRetValProj[ordercount]=tempproj2
    end
  end
  
  -- check for new projects
  local NewRetValProj={}
  local newprojcount=0
  local found=false
  
  for i=1, Count do
    for a=1, ultraschall.ProjectCount do
      if ultraschall.ProjectList[a][1]==Projects[i][1] then 
        found=true
        break
      end
    end
    if found==false then 
      newprojcount=newprojcount+1
      NewRetValProj[newprojcount]=Projects[i][1]
    end
    found=false
  end

  -- check for closed projects
  local ClosedRetValProj={}
  local closedprojcount=0
  local found=false
  
  for i=1, ultraschall.ProjectCount do
    for a=1, Count do
      if ultraschall.ProjectList[i][1]==Projects[a][1] then 
        found=true
        break
      end
    end
    if found==false then 
      closedprojcount=closedprojcount+1
      ClosedRetValProj[closedprojcount]=ultraschall.ProjectList[i][1]
    end
    found=false
  end
  
  -- check for changed projectnames(due saving, loading, etc)
  local ProjectNames={}
  local Projectnames_count=0
  local found=false
  
  for i=1, ultraschall.ProjectCount do
    if ultraschall.IsValidReaProject(ultraschall.ProjectList[i][1])==true and ultraschall.ProjectList[i][2]~=ultraschall.GetProjectFilename(ultraschall.ProjectList[i][1]) then
      Projectnames_count=Projectnames_count+1
      ProjectNames[Projectnames_count]=ultraschall.ProjectList[i][1]
    end
  end
  
  if update==true then ultraschall.ProjectList=Projects ultraschall.ProjectCount=Count end
  if ordercount>0 or newprojcount>0 or closedprojcount>0 or Projectnames_count>0 then
    return true, ordercount, OrderRetValProj, newprojcount, NewRetValProj, closedprojcount, ClosedRetValProj, Projectnames_count, ProjectNames
  end
  return false
end

function ultraschall.IsValidProjectStateChunk(ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidProjectStateChunk</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidProjectStateChunk(string ProjectStateChunk)</functioncall>
  <description>
    Checks, whether ProjectStateChunk is a valid ProjectStateChunk
  </description>
  <parameters>
    string ProjectStateChunk - the string to check, if it's a valid ProjectStateChunk
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid ProjectStateChunk; false, if not
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectfiles, rpp, projectstatechunk, statechunk, check, valid</tags>
</US_DocBloc>
]]  
  if type(ProjectStateChunk)=="string" and 
    ProjectStateChunk:sub(1,15)=="<REAPER_PROJECT" and 
    ProjectStateChunk:sub(-10,-1):match("\n>")~=nil 
    then return true else return false end--]]
    
    --[[if type(ProjectStateChunk)=="string" and 
    ProjectStateChunk:match("^<REAPER_PROJECT.*\n>")~=nil 
    then return true else return false end--]]
end


ultraschall.LastProjectStateChunk_Time=reaper.time_precise()

function ultraschall.GetProjectStateChunk(projectfilename_with_path, keepqrender, temp, temp, temp, temp, temp, waittime)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetProjectStateChunk</slug>
    <requires>
      Ultraschall=4.7
      Reaper=6.20
      SWS=2.10.0.1
      JS=0.972
      Lua=5.3
    </requires>
    <functioncall>string ProjectStateChunk = ultraschall.GetProjectStateChunk(optional string projectfilename_with_path, optional boolean keepqrender)</functioncall>
    <description>
      Gets the ProjectStateChunk of the current active project or a projectfile.
      
      Important: when calling it too often in a row, this might fail and result in a timeout-error. 
      I tried to circumvent this, but best practice is to wait 2-3 seconds inbetween calling this function.
      
      Note: This function eats up a lot of resources, so be sparse with it in general!
      
      Works reliably from Reaper 6.20 onwards.
      
      returns nil if getting the ProjectStateChunk took too long
    </description>
    <retvals>
      string ProjectStateChunk - the ProjectStateChunk of the current project; nil, if getting the ProjectStateChunk took too long
    </retvals>
    <parameters>
      optional string projectfilename_with_path - the filename of an rpp-projectfile, that you want to load as ProjectStateChunk; nil, to get the ProjectStateChunk from the currently active project
      optional boolean keepqrender - true, keeps the QUEUED_RENDER_OUTFILE and QUEUED_RENDER_ORIGINAL_FILENAME entries in the ProjectStateChunk, if existing; false or nil, remove them
    </parameters>
    <chapter_context>
      Project-Files
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
    <tags>projectmanagement, get, projectstatechunk</tags>
  </US_DocBloc>
  ]]  
    
  -- This function puts the current project into the render-queue and reads it from there.
  -- For that, 
  --    1) it gets all files in the render-queue
  --    2) it adds the current project to the renderqueue
  --    3) it waits, until Reaper has added the file to the renderqueue, reads it and deletes the file afterwards
  -- It also deals with edge-case-stuff to avoid render-dialogs/warnings popping up.



  -- if a filename is given, read the file and check, whether it's a valid ProjectStateChunk. 
  -- If yes, return it. Otherwise error.
  local ProjectStateChunk
  if projectfilename_with_path~=nil then 
    ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path)
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProjectStateChunk", "projectfilename_with_path", "must be a valid ReaProject or nil", -1) return nil end
    return ProjectStateChunk
  end
  
  -- get the currently focused hwnd; will be restored after function is done
  -- this is due Reaper changing the focused hwnd, when adding projects to the render-queue
  local oldfocushwnd = reaper.JS_Window_GetFocus()
      
  -- turn off renderqdelay temporarily, as otherwise this could display a render-queue-delay dialog
  -- old setting will be restored later
  local qretval, qlength = ultraschall.GetRender_QueueDelay()
  local retval = ultraschall.SetRender_QueueDelay(false, qlength)
      
  -- turn on auto-increment filename temporarily, to avoid the "filename already exists"-dialog popping up
  -- old setting will be restored later
  local old_autoincrement = ultraschall.GetRender_AutoIncrementFilename()
  ultraschall.SetRender_AutoIncrementFilename(true)  
  
  -- get all filenames currently in the render-queue
  local oldbounds, oldstartpos, oldendpos, prep_changes, files, files2, filecount, filecount2    
  filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/QueuedRenders")
      
  -- if Projectlength=0 or CountofTracks==0, set render-settings for empty projects(workaround for that edgecase)
  -- old settings will be restored later
  local oldsource2   = reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", 1, false)  
  local oldsource
  if reaper.CountTracks()==0 or reaper.GetProjectLength()==0 or oldsource2&4096~=0 or oldsource2==1 or oldsource2==3 then
  --  print2("Tudel")
    -- get old settings
    oldbounds   =reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, false)
    oldstartpos =reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", 0, false)
    oldendpos   =reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", 1, false)  
    oldsource   =reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", 1, false)  
       
    -- set useful defaults that'll make adding the project to the render-queue possible always
    if oldsource&4096~=0 or oldsource==3 then
      reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", 0, true)
    end
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", 1, true)
    
    -- set prep_changes to true, so we know, we need to reset these settings, later
    prep_changes=true
  end
  
  reaper.EnumerateFiles(reaper.GetResourcePath(), 1)
  reaper.EnumerateFiles(reaper.GetResourcePath().."/Scripts", 1)
  reaper.EnumerateFiles(reaper.GetResourcePath().."/ColorThemes", 1)
  filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/QueuedRenders")
  filecount2, files2 = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/QueuedRenders")

  -- add current project to render-queue
  reaper.Main_OnCommand(41823,0)    
  -- reset old hwnd-focus-state 
  reaper.JS_Window_SetFocus(oldfocushwnd)
  
  -- wait, until 
  local timer=reaper.time_precise()  
  while filecount2==filecount do
    --print(os.date())
    if timer+2<reaper.time_precise() then ultraschall.AddErrorMessage("GetProjectStateChunk", "", "timeout: Getting the ProjectStateChunk didn't work within 20 seconds for some reasons, please report this as bug to me and include the projectfile with which this happened!", -2) return end --end
    reaper.EnumerateFiles(reaper.GetResourcePath().."/QueuedRenders", -1)
    filecount2, files2 = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/QueuedRenders")
  end
  
  --print(filecount2, filecount)
  
  local duplicate_count, duplicate_array, originalscount_array1, originals_array1, originalscount_array2, originals_array2 = ultraschall.GetDuplicatesFromArrays(files, files2)
    
   -- read found render-queued-project and delete it
  local ProjectStateChunk=ultraschall.ReadFullFile(originals_array2[1])
  os.remove(originals_array2[1])
  
  -- reset temporarily changed settings in the current project, as well as in the ProjectStateChunk itself
  if prep_changes==true then
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", oldbounds, true)
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", oldstartpos, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", oldendpos, true)
    reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", oldsource, true)  
    retval, ProjectStateChunk = ultraschall.SetProject_RenderRange(nil, math.floor(oldbounds), math.floor(oldstartpos), math.floor(oldendpos), math.floor(reaper.GetSetProjectInfo(0, "RENDER_TAILFLAG", 0, false)), math.floor(reaper.GetSetProjectInfo(0, "RENDER_TAILMS", 0, false)), ProjectStateChunk)
    retval, ProjectStateChunk = ultraschall.SetProject_RenderStems(nil, math.floor(oldsource), ProjectStateChunk)
  end
     
  -- remove QUEUED_RENDER_ORIGINAL_FILENAME and QUEUED_RENDER_OUTFILE-entries, if keepqrender==true
  if keepqrender~=true then
    ProjectStateChunk=string.gsub(ProjectStateChunk, "  QUEUED_RENDER_OUTFILE .-%c", "")
    ProjectStateChunk=string.gsub(ProjectStateChunk, "  QUEUED_RENDER_ORIGINAL_FILENAME .-%c", "")
  end
      
  -- reset old auto-increment-checkbox-state
  ultraschall.SetRender_AutoIncrementFilename(old_autoincrement)
        
  -- restore old render-qdelay-setting
  retval = ultraschall.SetRender_QueueDelay(qretval, qlength)
  
  -- return the final ProjectStateChunk
  return ProjectStateChunk
end

function ultraschall.EnumProjects(idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumProjects</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ReaProject retval, string projfn = ultraschall.EnumProjects(integer idx)</functioncall>
  <description>
    returns, ReaProject-object and projectname of a requested, opened project.
    
    Returns nil in case of an error.
  </description>
  <parameters>
    integer idx - the project to request; 1(first project-tab) to n(last project-tab), 0 for current project; -1 for currently-rendering project
  </parameters>
  <retvals>
    ReaProject retval - a ReaProject-object of the project you requested; nil, if not existing
    string projfn - the path+filename.rpp of the project. returns "" if no filename exists
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>helperfunctions, projectfiles, get, filename, project, reaproject, rendering, opened</tags>
</US_DocBloc>
--]]
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("EnumProjects","idx", "must be an integer", -1) return nil end
  if idx==0 then idx=-1
  elseif idx==-1 then idx=0x40000000
  else idx=idx-1
  end
  return reaper.EnumProjects(idx,"")
end


function ultraschall.GetProjectLength(items, markers_regions, timesig_markers, include_rec)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectLength</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number project_length, number last_itemedge, number last_regionedgepos, number last_markerpos, number last_timesigmarker = ultraschall.GetProjectLength(optional boolean return_last_itemedge, optional boolean return_last_markerpos, optional boolean return_lat_timesigmarkerpos, optional boolean include_rec)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the position of the last itemedge, regionend, marker, time-signature-marker in the project.
    
    It will return -1, if no such elements are found, means: last\_markerpos=-1 if no marker has been found
    Exception when no items are found, it will return nil for last\_itemedge
    
    You can optimise the speed of the function, by setting the appropriate parameters to false.
    So if you don't need the last itemedge, setting return\_last\_itemedge=false speeds up execution massively.
    
    If you want to have the full projectlength during recording, means, including items currently recorded, set include_rec=true
    
    To do the same for projectfiles, use: [GetProject\_Length](#GetProject_Length)
  </description>
  <retvals>
    number length_of_project - the overall length of the project, including markers, regions, itemedges and time-signature-markers
    number last_itemedge - the position of the last itemedge in the project; nil, if not found
    number last_regionedgepos - the position of the last regionend in the project; -1, if not found
    number last_markerpos - the position of the last marker in the project; -1, if not found 
    number last_timesigmarker - the position of the last timesignature-marker in the project; -1, if not found
  </retvals>
  <parameters>
    optional boolean return_last_itemedge - true or nil, return the last itemedge; false, don't return it
    optional boolean return_last_markerpos - true or nil, return the last marker/regionend-position; false, don't return it 
    optional boolean return_lat_timesigmarkerpos - true or nil, return the last timesignature-marker-position; false, don't return it
    optional boolean include_rec - true, takes into account the projectlength during recording; nil or false, only the projectlength exluding currently recorded MediaItems
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>project management, get, last, position, length of project, marker, regionend, itemend, timesignaturemarker</tags>
</US_DocBloc>
--]]
  local Longest=-10000000000 -- this is a hack for MediaItems, who are stuck before ProjectStart; I hate it
  if items~=false then
    local Position, Length
    for i=0, reaper.CountMediaItems(0)-1 do
      Position=reaper.GetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "D_POSITION")
      Length=reaper.GetMediaItemInfo_Value(reaper.GetMediaItem(0,i), "D_LENGTH")
      if Position+Length>Longest then Longest=Position+Length end
    end
  end
  if Longest==-10000000000 then Longest=nil end -- same hack for MediaItems, who are stuck before ProjectStart; I hate it...
  local Regionend=-1
  local Markerend=-1
  if markers_regions~=false then
    for i=0, reaper.CountProjectMarkers(0)-1 do
      local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
      if isrgn==true then
        if rgnend>Regionend then Regionend=rgnend end
      else
        if pos>Markerend then Markerend=pos end
      end
    end
  end
  local TimeSigEnd=-1
  if timesig_markers~=false then
    for i=0, reaper.CountTempoTimeSigMarkers(0)-1 do
      local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper.GetTempoTimeSigMarker(0, i)
      if timepos>TimeSigEnd then TimeSigEnd=timepos end
    end
  end
  if include_rec==true and reaper.GetPlayState()&4~=0 and ultraschall.AnyTrackRecarmed()==true and reaper.GetPlayPosition()>reaper.GetProjectLength() then 
    return reaper.GetPlayPosition(), Longest, Regionend, Markerend, TimeSigEnd
  end
  return reaper.GetProjectLength(), Longest, Regionend, Markerend, TimeSigEnd
end

function ultraschall.GetRecentProjects()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRecentProjects</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer count_of_RecentProjects, array RecentProjectsFilenamesWithPath = ultraschall.GetRecentProjects()</functioncall>
  <description>
    returns all available recent projects, as listed in the File -> Recent projects-menu
  </description>
  <retvals>
    integer count_of_RecentProjects - the number of available recent projects
    array RecentProjectsFilenamesWithPath - the filenames of the recent projects
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, get, all, recent, projects, filenames, rpp</tags>
</US_DocBloc>
]]
  local Length_of_value, Count = ultraschall.GetIniFileValue("REAPER", "numrecent", -100, reaper.get_ini_file())
  local Count=tonumber(Count)
  local RecentProjects={}
  for i=1, Count do
    if i<10 then zero="0" else zero="" end
    Length_of_value, RecentProjects[i] = ultraschall.GetIniFileValue("Recent", "recent"..zero..i, -100, reaper.get_ini_file())  
  end
  
  return Count, RecentProjects
end

function ultraschall.IsValidProjectBayStateChunk(ProjectBayStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidProjectBayStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidProjectBayStateChunk(string ProjectBayStateChunk)</functioncall>
  <description>
    checks, if ProjectBayStateChunk is a valid ProjectBayStateChunk
    
    returns false in case of an error
  </description>
  <parameters>
    string ProjectBayStateChunk - a string, that you want to check for being a valid ProjectBayStateChunk
  </parameters>
  <retvals>
    boolean retval - true, valid ProjectBayStateChunk; false, not a valid ProjectBayStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    ProjectBay
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>project management, check, projectbaystatechunk, is valid</tags>
</US_DocBloc>
]]
  if type(ProjectBayStateChunk)~="string" then ultraschall.AddErrorMessage("IsValidProjectBayStateChunk", "ProjectBayStateChunk", "must be a string", -1) return false end
  if ProjectBayStateChunk:match("<PROJBAY.-\n  >")==nil then return false else return true end
end

function ultraschall.GetAllMediaItems_FromProjectBayStateChunk(ProjectBayStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMediaItems_FromProjectBayStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer count, array MediaItemStateChunkArray = ultraschall.GetAllMediaItems_FromProjectBayStateChunk(string ProjectBayStateChunk)</functioncall>
  <description>
    returns all items from a ProjectBayStateChunk as MediaItemStateChunkArray
    
    returns -1 in case of an error
  </description>
  <parameters>
    string ProjectBayStateChunk - a string, that you want to check for being a valid ProjectBayStateChunk
  </parameters>
  <retvals>
    integer count - the number of items found in the ProjectBayStateChunk
    array MediaitemStateChunkArray - all items as ItemStateChunks in a handy array
  </retvals>
  <chapter_context>
    Project-Management
    ProjectBay
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>project management, get, projectbaystatechunk, all items, mediaitemstatechunkarray</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidProjectBayStateChunk(ProjectBayStateChunk)==false then ultraschall.AddErrorMessage("GetAllMediaItems_FromProjectBayStateChunk", "ProjectBayStateChunk", "must be a valid ProjectBayStateChunk", -1) return -1 end
  local MediaItemStateChunkArray={}
  local count=0
  for k in string.gmatch(ProjectBayStateChunk, "    <DATA.-\n    >") do
    count=count+1
    MediaItemStateChunkArray[count]=string.gsub(string.gsub(k, "    <DATA", "<ITEM"),"\n%s*", "\n").."\n"
  end
  return count, MediaItemStateChunkArray
end

function ultraschall.IsTimeSelectionActive()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTimeSelectionActive</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional number start_of_timeselection, optional number end_of_timeselection = ultraschall.IsTimeSelectionActive(optional ReaProject Project)</functioncall>
  <description>
    Returns, if there's a time-selection and its start and endposition in a project.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, there is a time-selection; false, there isn't a time-selection
    optional number start_of_timeselection - start of the time-selection
    optional number end_of_timeselection - end of the time-selection
  </retvals>
  <parameters>
    optional ReaProject Project - the project, whose time-selection-state you want to know; 0 or nil, the current project
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, time selection, get</tags>
</US_DocBloc>
]] 
  if Project~=0 and Project~=nil and ultraschall.type(Project)~="ReaProject" then
    ultraschall.AddErrorMessage("IsTimeSelectionActive", "Project", "must be a valid ReaProject, 0 or nil(for current)", -1)
    return false
  end
  local Start, Endof = reaper.GetSet_LoopTimeRange2(Project, false, false, 0, 0, false)
  if Start==Endof then return false end
  return true, Start, Endof
end

function ultraschall.GetProject_Author(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Author</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string projectauthor = ultraschall.GetProject_Author(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the author from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry "  AUTHOR"
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string author - the author of the project; "", if there's no author given
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, author, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Author","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Author","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Author","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Author", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  return ProjectStateChunk:match("  AUTHOR [\"]*(.-)[\"]*\n") or ""
end

function ultraschall.AutoSave_SetMinutes(minutes)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoSave_SetMinutes</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AutoSave_SetMinutes(integer minutes)</functioncall>
  <description>
    Sets the number of minutes, at which a new autosaved-project shall be saved.
    
    0 to turn it off
    
    Returns false in case of error
  </description>
  <parameters>
    integer minutes - 0, turn off autosave; 1 to 2147483647, the number of minutes at which a new autosaved-project shall be saved
  </parameters>
  <retvals>
    boolean retval - true, setting worked; false, setting didn't work
  </retvals>
  <chapter_context>
    Project-Management
    AutoSave
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, autosave, set, minutes</tags>
</US_DocBloc>
]]
  if math.type(minutes)~="integer" then ultraschall.AddErrorMessage("AutoSave_SetMinutes", "minutes", "must be an integer", -1) return false end
  if minutes<0 or minutes>2147483647 then ultraschall.AddErrorMessage("AutoSave_SetMinutes", "minutes", "must be between 0 and 2147483647", -2) return false end
  return reaper.SNM_SetIntConfigVar("autosaveint", minutes)
end

function ultraschall.AutoSave_GetMinutes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoSave_GetMinutes</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>integer minutes = ultraschall.AutoSave_GetMinutes()</functioncall>
  <description>
    Gets the currently set amount of minutes, at which a new autosave-project shall be saved
  </description>
  <retvals>
    integer minutes - 0, autosave is turned off; 1 to 2147483647, the number of minutes at which a new autosaved-project shall be saved
  </retvals>
  <chapter_context>
    Project-Management
    AutoSave
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, autosave, get, minutes</tags>
</US_DocBloc>
]]
  return reaper.SNM_GetIntConfigVar("autosaveint", -1)
end

function ultraschall.AutoSave_SetOptions(timestamp_in_project, save_undo_history)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoSave_SetOptions</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AutoSave_SetOptions(optional boolean timestamp_in_project, optional boolean save_undo_history)</functioncall>
  <description>
    Gets the current states of the Save to timestamped file in project directory and Save undo history (RPP-UNDO)(if enabled in general prefs)-settings.    
  </description>
  <retvals>
    optional boolean timestamp_in_project - Save to timestamped file in project directory; true, set to on; false, set to off; nil, keep current setting
    optional boolean save_undo_history - Save undo history (RPP-UNDO)(if enabled in general prefs); true, set to on; false, set to off; nil, keep current setting
  </retvals>
  <chapter_context>
    Project-Management
    AutoSave
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, autosave, get, options, timestamped file, save undo history</tags>
</US_DocBloc>
--]]
  if save_undo_history~=nil and type(save_undo_history)~="boolean" then ultraschall.AddErrorMessage("AutoSave_SetOptions", "save_undo_history", "must be a boolean", -1) return false end
  if timestamp_in_project~=nil and type(timestamp_in_project)~="boolean" then ultraschall.AddErrorMessage("AutoSave_SetOptions", "timestamp_in_project", "must be a boolean", -2) return false end

  local saveopts=reaper.SNM_GetIntConfigVar("saveopts", -1)
  local saveundostatesproj=reaper.SNM_GetIntConfigVar("saveundostatesproj", -1)
  
  if timestamp_in_project==true  and saveopts&4==0 then saveopts=saveopts+4 reaper.SNM_SetIntConfigVar("saveopts", saveopts) end
  if timestamp_in_project==false and saveopts&4==4 then saveopts=saveopts-4 reaper.SNM_SetIntConfigVar("saveopts", saveopts) end
  
  if save_undo_history==true  and saveundostatesproj&2==0 then saveundostatesproj=saveundostatesproj+2 reaper.SNM_SetIntConfigVar("saveundostatesproj", saveundostatesproj) end
  if save_undo_history==false and saveundostatesproj&2==2 then saveundostatesproj=saveundostatesproj-2 reaper.SNM_SetIntConfigVar("saveundostatesproj", saveundostatesproj) end
  
  return true
end

function ultraschall.AutoSave_GetOptions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AutoSave_GetOptions</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean timestamp_in_project, boolean save_undo_history = ultraschall.AutoSave_GetOptions()</functioncall>
  <description>
    Gets the current states of the Save to timestamped file in project directory and Save undo history (RPP-UNDO)(if enabled in general prefs)-settings.    
  </description>
  <retvals>
    boolean timestamp_in_project - Save to timestamped file in project directory; true, set to on; false, set to off
    boolean save_undo_history - Save undo history (RPP-UNDO)(if enabled in general prefs); true, set to on; false, set to off
  </retvals>
  <chapter_context>
    Project-Management
    AutoSave
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>projectmanagement, autosave, get, options, timestamped file, save undo history</tags>
</US_DocBloc>
]]
  return reaper.SNM_GetIntConfigVar("saveopts", -1)&4==4, reaper.SNM_GetIntConfigVar("saveundostatesproj", -1)&2==2
end

function ultraschall.Main_SaveProject(proj, filename_with_path, options, overwrite, create_backup)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Main_SaveProject</slug>
  <requires>
    Ultraschall=4.4
    Reaper=6.53
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Main_SaveProject(ReaProject proj, string filename_with_path, integer options, boolean overwrite, boolean create_backup)</functioncall>
  <description>
    Saves a project/project template as rpp-project file. Basically like Reaper's own Main_SaveProjectEx but 
    gives hint if a file was saved and has more options.
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, projectfile was saved; false, projectfile was not saved
  </retvals>
  <parameters>
    ReaProject proj - the project, that you want to save as rpp-file
    string filename_with_path - the filename with path of the project
    integer options - options to save with:
                            - &1, save selected tracks as track template
                            - &2, include media with track templates 
                            - &4, include envelopes with track template
    boolean overwrite - true, overwrite an already existing file; false, don't overwrite an already existing file
    boolean create_backup - true, make already existing project into a -bak-file; false, don't make backup file
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_Module.lua</source_document>
  <tags>helperfunctions, projectfiles, write, save, projecttab</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidReaProject(proj)==false then ultraschall.AddErrorMessage("Main_SaveProject", "proj", "must be a valid ReaProject-file", -1) return false end
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("Main_SaveProject", "filename_with_path", "must be a string", -2) return false end
  if math.type(options)~="integer" then ultraschall.AddErrorMessage("Main_SaveProject", "options", "must be an integer", -3) return false end
  if type(overwrite)~="boolean" then ultraschall.AddErrorMessage("Main_SaveProject", "overwrite", "must be a boolean", -4) return false end
  if type(create_backup)~="boolean" then ultraschall.AddErrorMessage("Main_SaveProject", "create_backup", "must be a boolean", -5) return false end
  
  
  -- needs to be playtested...but should work
  
  -- if file already exists and shall not be overwritten, simply return with false
  if reaper.file_exists(filename_with_path)==true and overwrite~=true then
    return false
  end
  
  -- if file already exists
  if reaper.file_exists(filename_with_path)==true then
    -- create temp-copy of the file
    local tempfilename = ultraschall.CreateValidTempFile(filename_with_path, false, "", true)
    reaper.Main_SaveProjectEx(proj, tempfilename, options)
    
    -- if it got created
    if reaper.file_exists(tempfilename)==true then
      -- create a backup or just overwrite the file?
      if create_backup~=false then
        os.remove(filename_with_path.."-bak")
        os.rename(filename_with_path, filename_with_path.."-bak")
      else
        os.remove(filename_with_path)
      end
      os.rename(tempfilename, filename_with_path)
      
      return true
    -- if it didn't get created
    else
      return false
    end
  -- if file doesn't exist, simply create it and check, whether it exists afterwards to return true or false
  elseif reaper.file_exists(filename_with_path)==false then
    reaper.Main_SaveProjectEx(proj, filename_with_path, options)
    if reaper.file_exists(filename_with_path)==false then 
      return false 
    else 
      return true
    end
  end
  return false
end

--A,B=ultraschall.Main_SaveProject(0, "c:\\pudel2.rpp", 0, false, true)


