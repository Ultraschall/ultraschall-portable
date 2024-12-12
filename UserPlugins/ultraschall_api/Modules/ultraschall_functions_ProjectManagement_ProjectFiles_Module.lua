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
--- Projects: ProjectFiles Module ---
-------------------------------------


function ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, state, ProjectStateChunk, functionname, numbertoggle)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectState_NumbersOnly</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>table values = ultraschall.GetProjectState_NumbersOnly(string projectfilename_with_path, string state, optional string ProjectStateChunk, optional boolean numbertoggle)</functioncall>
  <description>
    returns a state of the project or a ProjectStateChunk.
    
    It only supports single-entry-states with numbers/integers, separated by spaces!
    All other values will be set to nil and strings with spaces will produce weird results!
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the states; nil to use ProjectStateChunk
    string state - the state, whose attributes you want to retrieve
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
    optional string functionname - if this function is used within specific getprojectstate-functions, pass here the "host"-functionname, so error-messages will reflect that
    optional boolean numbertoggle - true or nil; converts all values to numbers; false, keep them as string versions
  </parameters>
  <retvals>
    table values - all values found as numerical indexed array
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, state, projectstatechunk</tags>
</US_DocBloc>
]]
  if functionname~=nil and type(functionname)~="string" then ultraschall.AddErrorMessage(functionname,"functionname", "Must be a string or nil!", -6) return nil end
  if functionname==nil then functionname="GetProjectState_NumbersOnly" end
  if type(state)~="string" then ultraschall.AddErrorMessage(functionname,"state", "Must be a string", -7) return nil end
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage(functionname,"projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage(functionname,"ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage(functionname,"projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage(functionname, "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  ProjectStateChunk=ProjectStateChunk:match(state.." (.-)\n")
  if ProjectStateChunk==nil then return end
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(ProjectStateChunk, " ")
  if numbertoggle~=false then
    for i=1, count do
        individual_values[i]=tonumber(individual_values[i])
    end
  end
  return table.unpack(individual_values)
end



--- Get ---
function ultraschall.GetProject_ReaperVersion(projectfilename_with_path, ProjectStateChunk)
-- return Reaper-Version and TimeStamp
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_ReaperVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string reaperversion, string timestamp = ultraschall.GetProject_ReaperVersion(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the reaperversion and the timestamp from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry "&lt;REAPER_PROJECT"
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string reaperversion - the version of Reaper, with which this project had been saved
    string timestamp - a timestamp for this project
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, reaperversion, timestamp, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_ReaperVersion","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ReaperVersion","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_ReaperVersion","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ReaperVersion", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  ProjectStateChunk=ProjectStateChunk:match("(REAPER_PROJECT.-)\n").." "
  return ProjectStateChunk:match("REAPER_PROJECT%s.-%s\"(.-)\" (.-)%s")
end

function ultraschall.GetProject_RenderCFG(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    Lua=5.3
  </requires>
  <functioncall>string render_cfg, string render_cfg2 = ultraschall.GetProject_RenderCFG(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-cfg-string2, that contains all render-settings for primary and secondary render-settings of a project from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry &lt;RENDER_CFG
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string render_cfg - the renderstring, which contains all render-settings for a project/projectstatechunk
    string render_cfg2 - the renderstring, which contains all secondary-render-settings for a project/projectstatechunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, renderstring, rendercfg</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderCFG","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderCFG","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderCFG","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  local retval=ProjectStateChunk:match("<RENDER_CFG.-\n%s*(.-)\n")
  if retval==">" then ultraschall.AddErrorMessage("GetProject_RenderCFG", "projectfilename_with_path", "No Render-CFG-code available!", -5) return nil end
  retval2=ProjectStateChunk:match("<RENDER_CFG2.-\n%s*(.-)\n")
  if retval2==">" or retval2==nil then ultraschall.AddErrorMessage("GetProject_RenderCFG", "projectfilename_with_path", "No secondary Render-CFG-code available!", -6) retval2="" end
  return retval, retval2
end

function ultraschall.GetProject_RippleState(projectfilename_with_path, ProjectStateChunk)
-- Set RippleState in a projectfilename_with_path
--  0 - no Ripple, 1 - Ripple One Track, 2 - Ripple All
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RippleState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer ripplestate = ultraschall.GetProject_RippleState(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the ripple-state from an RPP-Projectfile or a ProjectStateChunk.

    It's the entry RIPPLE

    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer ripplestate - 0, no Ripple; 1, Ripple One Track; 2, Ripple All
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, ripple, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RIPPLE", ProjectStateChunk, "GetProject_RippleState")
end

function ultraschall.GetProject_GroupOverride(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GroupOverride</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer group_override1, integer group_override2, integer group_override3 = ultraschall.GetProject_GroupOverride(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the group-override-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry GROUPOVERRIDE
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer group_override1 - the group-override state
    integer track_group_enabled - the track_group_enabled-setting, as set in the context-menu of the Master-Track; 1, checked; 0, unchecked
    integer group_override3 - the group-override state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, group, override, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "GROUPOVERRIDE", ProjectStateChunk, "GetProject_GroupOverride")
end

function ultraschall.GetProject_AutoCrossFade(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_AutoCrossFade</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer autocrossfade_state = ultraschall.GetProject_AutoCrossFade(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the autocrossfade-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry AUTOXFADE
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    string ProjectStateChunk - a ProjectStateChunk to use instead if a filename
  </parameters>
  <retvals>
    integer autocrossfade_state - the autocrossfade-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, crossfade, state, auto, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "AUTOXFADE", ProjectStateChunk, "GetProject_AutoCrossFade")
end

function ultraschall.GetProject_EnvAttach(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_EnvAttach</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer env_attach = ultraschall.GetProject_EnvAttach(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the EnvAttach-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry ENVATTACH
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path of the rpp-project-file; nil, use parameter ProjectStateChunk instead
    string ProjectStateChunk - a projectstatechunk to read the value from; only used, projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer env_attach - the env-attach state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, envattach</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "ENVATTACH", ProjectStateChunk, "GetProject_EnvAttach")
end

function ultraschall.GetProject_PooledEnvAttach(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_PooledEnvAttach</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer pooled_env_attach = ultraschall.GetProject_PooledEnvAttach(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the PooledEnvAttach-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry POOLEDENVATTACH
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path of the rpp-project-file; nil, use parameter ProjectStateChunk instead
    string ProjectStateChunk - a projectstatechunk to read the value from; only used, projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer pooled_env_attach - the pooled-env-attach state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, pooledenvattach</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "POOLEDENVATTACH", ProjectStateChunk, "GetProject_PooledEnvAttach")
end

function ultraschall.GetProject_MixerUIFlags(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MixerUIFlags</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer state1, integer state2 = ultraschall.GetProject_MixerUIFlags(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the MixerUI-state-flags from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry MIXERUIFLAGS
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer state1 - folders, receives, etc 
    -0 - Show tracks in folders, Auto arrange tracks in mixer
    -1 - Show normal top level tracks
    -2 - Show Folders
    -4 - Group folders to left
    -8 - Show tracks that have receives
    -16 - Group tracks that have receives to left
    -32 - don't show tracks that are in folder
    -64 - No Autoarrange tracks in mixer
    -128 - ?
    -256 - ?
    
    integer state2 - master-track, FX, Mixer
    -0 - Master track in mixer
    -1 - Don't show multiple rows of tracks, when size permits
    -2 - Show maximum rows even when tracks would fit in less rows
    -4 - Master Show on right side of mixer
    -8 - ?
    -16 - Show FX inserts when size permits
    -32 - Show sends when size permits
    -64 - Show tracks in mixer
    -128 - Show FX parameters, when size permits
    -256 - Don't show Master track in mixer
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, mixer, ui, flags</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MIXERUIFLAGS", ProjectStateChunk, "GetProject_MixerUIFlags")
end

--A,AA=ultraschall.GetProject_MixerUIFlags("c:\\tt.rpp")

function ultraschall.GetProject_PeakGain(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_PeakGain</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number peakgain_state = ultraschall.GetProject_PeakGain(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the GetProject_PeakGain-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry PEAKGAIN
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path of the rpp-project-file
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number peakgain_state - peakgain-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, mixer, peakgain, peak, gain</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "PEAKGAIN", ProjectStateChunk, "GetProject_PeakGain")
end

--A=ultraschall.GetProject_PeakGain("c:\\tt.rpp")



function ultraschall.GetProject_Feedback(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Feedback</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer feedback_state = ultraschall.GetProject_Feedback(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the GetProject_Feedback-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry FEEDBACK
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer feedback_state - feedback-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, mixer, feedback</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "FEEDBACK", ProjectStateChunk, "GetProject_Feedback")
end

--A=ultraschall.GetProject_Feedback("c:\\tt.rpp")

function ultraschall.GetProject_PanLaw(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_PanLaw</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number panlaw_state = ultraschall.GetProject_PanLaw(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the GetProject_PanLaw-state from an RPP-Projectfile or a ProjectStateChunk, as set in the project-settings->Advanced->Pan law/mode->Pan:law(db).
    
    It's the entry PANLAW
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number panlaw_state - state of the panlaw, as set in the project-settings->Advanced->Pan law/mode->Pan:law(db). 0.5(-6.02 db) to 1(default +0.0 db)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, mixer, panlaw, pan</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "PANLAW", ProjectStateChunk, "GetProject_PanLaw")
end

--A=ultraschall.GetProject_PanLaw("c:\\tt.rpp")

function ultraschall.GetProject_ProjOffsets(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_ProjOffsets</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>number start_time, integer start_measure, integer base_ruler_marking_off_this_measure = ultraschall.GetProject_ProjOffsets(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the Project Offset-state from an RPP-Projectfile or a ProjectStateChunk, start time as well as start measure.
    as set in ProjectSettings->ProjectSettings->Project Start Time/Measure and the checkbox Base Ruler Marking Off This Measure-checkbox
    
    It's the entry PROJOFFS
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number start_time - the project-start-time in seconds
    integer start_measure - starting with 0, unlike the Settingswindow, where the 0 becomes 1 as measure
    integer base_ruler_marking_off_this_measure - 0, checkbox unchecked; 1, checkbox checked
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, project, offset, start, starttime</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "PROJOFFS", ProjectStateChunk, "GetProject_ProjOffsets")
end

--BB,B=reaper.EnumProjects(-1,"")
--A,AA,AAA=ultraschall.GetProject_ProjOffsets(B)

function ultraschall.GetProject_MaxProjectLength(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MaxProjectLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer limit_project_length, number projectlength_limit = ultraschall.GetProject_MaxProjectLength(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the maximum-project-length from an RPP-Projectfile or a ProjectStateChunk, as set in ProjectSettings->Advanced->
    as set in ProjectSettings->ProjectSettings->Project Start Time/Measure.
    
    It's the entry MAXPROJLEN
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer limit_project_length - checkbox "Limit project length, stop playback/recording at:" - 0 off, 1 on
    number projectlength_limit - projectlength-limit in seconds
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, project, end, length, limit</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MAXPROJLEN", ProjectStateChunk, "GetProject_MaxProjectLength")
end

--A,AA=ultraschall.GetProject_MaxProjectLength("c:\\tt.rpp")

function ultraschall.GetProject_Grid(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Grid</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer gridstate1, integer gridstate2, number gridstate3, integer gridstate4, number gridstate5, integer gridstate6, integer gridstate7, number gridstate8 = ultraschall.GetProject_Grid(string projectfilename_with_path)</functioncall>
  <description>
    Returns the grid-state from an RPP-Projectfile or a ProjectStateChunk.

    It's the entry GRID

    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path of the rpp-project-file
  </parameters>
  <retvals>
    integer gridstate1 - gridstate1
    integer gridstate2 - gridstate2
    number gridstate3 - gridstate3
    integer gridstate4 - gridstate4
    number gridstate5 - gridstate5
    integer gridstate6 - gridstate6
    integer gridstate7 - gridstate7
    number gridstate8 - gridstate8
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, grid</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "GRID", ProjectStateChunk, "GetProject_Grid")
end

function ultraschall.GetProject_Timemode(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Timemode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer ruler_timemode, integer timemode2, integer showntime, integer timemode4, integer timemode5, integer timemode6, integer timemode7 = ultraschall.GetProject_Timemode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the timemode-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry TIMEMODE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer ruler_timemode - ruler-timemode-state
    - -1, Use ruler time unit
    -  0, Minutes:Seconds
    -  1, Measures.Beats / Minutes:Seconds
    -  2, Measures.Beats
    -  3, Seconds
    -  4, Samples
    -  5, Hours:Minutes:Seconds:Frames
    -  8, Absolute Frames
    integer timemode2 - timemode-state
    integer showntime - Transport shown time
    -      -1 - use ruler time unit
    -       0 - minutes:seconds
    -       1 - measures:beats/minutes:seconds
    -       2 - measures:beats
    -       3 - seconds
    -       4 - samples
    -       5 - hours:minutes:seconds:frames
    -       8 - absolute frames
    integer timemode4 - timemode-state
    integer timemode5 - timemode-state
    integer timemode6 - timemode-state
    integer timemode7 - timemode-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, timemode</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "TIMEMODE", ProjectStateChunk, "GetProject_Timemode")
end

function ultraschall.GetProject_VideoConfig(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_VideoConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer preferredVidSizeX, integer preferredVidSizeY, integer settingsflags = ultraschall.GetProject_VideoConfig(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the videoconfig-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry VIDEO_CONFIG
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer preferredVidSizeX - preferred video size, x pixels
    integer preferredVidSizeY - preferred video size, y pixels
    integer settingsflags - settings
    -             0 - turned on/selected: use high quality filtering, preserve aspect ratio(letterbox) when resizing,
    -                                     Video colorspace set to Auto,
    -                                     Items in higher numbered tracks replace lower, as well as Video colorspace set to Auto
    -             1 - Video colorspace: I420/YV12
    -             2 - Video colorspace: YUV2
    -             3 - RGB
    -             256 - Items in lower numbered tracks replace higher
    -             512 - Always resize video sources to preferred video size
    -             1024 - Always resize output to preferred video size
    -             2048 - turn off "Use high quality filtering when resizing"
    -             4096 - turn off "preserve aspect ratio (letterbox) when resizing"
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, video, videoconfig</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "VIDEO_CONFIG", ProjectStateChunk, "GetProject_VideoConfig")
end

function ultraschall.GetProject_PanMode(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_PanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer panmode_state = ultraschall.GetProject_PanMode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the panmode-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry PANMODE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer panmode_state - panmode-state
    -0 reaper 3.x balance (deprecated)
    -3 Stereo balance / mono pan (default)
    -5 Stereo pan
    -6 Dual Pan
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, panmode</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "PANMODE", ProjectStateChunk, "GetProject_PanMode")
end



function ultraschall.GetProject_CursorPos(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_CursorPos</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number cursorpos = ultraschall.GetProject_CursorPos(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the cursorposition-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry CURSOR
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number cursorpos - editcursorposition in seconds
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, cursor, position, cursorposition, editcursor, edit</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "CURSOR", ProjectStateChunk, "GetProject_CursorPos")
end

--A=ultraschall.GetProject_CursorPos("c:\\tt.rpp")

function ultraschall.GetProject_HorizontalZoom(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_HorizontalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number hzoom, integer hzoomscrollpos, integer scrollbarfactor = ultraschall.GetProject_HorizontalZoom(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the horizontal-zoom-state from an RPP-Projectfile or a ProjectStateChunk.
    Keep in mind, that hzoomscrollpos and scrollbarfactor depend on each other. hzoomscrollpos is a smaller positioning-unit, while scrollbarfactor is the bigger positioning-unit.
    Experiment with it to get an idea.
    
    It's the entry ZOOM
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number hzoom - HorizontalZoomfactor, 0.007 to 1000000
    integer hzoomscrollpos - horizontalscrollbarposition - 0 - 4294967296
    integer scrollbarfactor - 0 to 500837, counts up, when maximum hzoomscrollpos overflows
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, zoom, horizontal, scrollbar, factor</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "ZOOM", ProjectStateChunk, "GetProject_HorizontalZoom")
end

--A1,AA,AAA=ultraschall.GetProject_HorizontalZoom("c:\\tt.rpp")

function ultraschall.GetProject_VerticalZoom(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_VerticalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer vzoom = ultraschall.GetProject_VerticalZoom(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the verticalzoom from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry VZOOMEX
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer vzoom - vertical zoomfactor(0-40)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, zoom, vertical, scrollbar, factor</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "VZOOMEX", ProjectStateChunk, "GetProject_VerticalZoom")
end

--A=ultraschall.GetProject_VerticalZoom("c:\\tt.rpp")

function ultraschall.GetProject_UseRecConfig(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_UseRecConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer rec_cfg = ultraschall.GetProject_UseRecConfig(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the rec-cfg-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry USE_REC_CFG
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer rec_cfg - recording-cfg-state
    - 0 - Automatic .wav (recommended)
    - 1 - Custom (use ultraschall.GetProject_ApplyFXCFG to get recording_cfg_string)
    - 2 - Recording Format
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, rec, config</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "USE_REC_CFG", ProjectStateChunk, "GetProject_UseRecConfig")
end

--A=ultraschall.GetProject_UseRecConfig("c:\\tt.rpp")

function ultraschall.GetProject_RecMode(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RecMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer rec_mode = ultraschall.GetProject_RecMode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the rec-mode-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry RECMODE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer rec_mode - recording-mode-state
    - 0 - Autopunch/Selected Items
    - 1 - normal
    - 2 - Time Selection/Auto Punch
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, rec, mode</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RECMODE", ProjectStateChunk, "GetProject_RecMode")
end

--A=ultraschall.GetProject_RecMode("c:\\tt.rpp")

function ultraschall.GetProject_SMPTESync(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_SMPTESync</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer smptesync_state1, number smptesync_fps, integer smptesync_resyncdrift, integer smptesync_skipdropframes, integer smptesync_syncseek, integer smptesync_freewheel, integer smptesync_userinput, number smptesync_offsettimecode, integer smptesync_stop_rec_drift, integer smptesync_state10, integer smptesync_stop_rec_lacktime  = ultraschall.GetProject_SMPTESync(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the smpte-sync-state from an RPP-Projectfile or a ProjectStateChunk.

    It's the entry SMPTESYNC

    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer smptesync_state1 - flag 
    -0 - external timecode synchronization disabled
    -1 - external timecode synchronization enabled
    -4 - Start playback on valid timecode when stopped
    -8 - turned off: display flashing notification window when waiting for sync for recording
    -16 - playback off
    -32 - recording off
    -256 - MTC - 24/30fps MTC is 23.976/29.97ND works only with smptesync_userinput set to 4159
    -512 - MTC - 24/30fps MTC is 24/30ND
    
    number smptesync_fps - framerate in fps
    integer smptesync_resyncdrift - "Re-synchronize if drift exceeds" in ms (0 = never)
    integer smptesync_skipdropframes - "skip/drop frames if drift exceeds" in ms(0 - never)
    integer smptesync_syncseek - "Synchronize by seeking ahead" in ms (default = 1000)
    integer smptesync_freewheel - "Freewheel on missing time code for up to" in ms(0 = forever)
    integer smptesync_userinput - User Input-flag
    -0 - LTC: Input 1
    -1 - LTC: Input 2
    -4159 - MTC - All inputs - 24/30 fps MTC 23.976ND/29.97ND if project is ND
    -4223 - SPP: All Inputs
    -8192 - ASIO Positioning Protocol
    
    number smptesync_offsettimecode - Offset incoming timecode by in seconds
    integer smptesync_stop_rec_drift - "Stop recording if drift exceeds" in ms(0 = never)
    integer smptesync_state10 - smptesync-state
    integer smptesync_stop_rec_lacktime - "stop recording on lack of timecode after" in ms(0 = never)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, smpte, sync</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "SMPTESYNC", ProjectStateChunk, "GetProject_SMPTESync")
end

--A,AA,AAA,AAAA,AAAAA,AAAAAA,AAAAAAA,AAAAAAAA,AAAAAAAAA,AL,AM=ultraschall.GetProject_SMPTESync("c:\\tt.rpp")

function ultraschall.GetProject_Loop(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Loop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer loopbutton_state = ultraschall.GetProject_Loop(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the loop-button-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry LOOP
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer loop_mode - loopbutton-state, 0 - off, 1 - on
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, loop, button</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "LOOP", ProjectStateChunk, "GetProject_Loop")
end

--A=ultraschall.GetProject_Loop("c:\\tt.rpp")

function ultraschall.GetProject_LoopGran(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_LoopGran</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer loopgran_state1, number loopgran_state2 = ultraschall.GetProject_LoopGran(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the loop_gran-state from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry LOOPGRAN
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer loopgran_state1 - loopgran_state1
    number loopgran_state2 - loopgran_state2
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, loop, gran</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "LOOPGRAN", ProjectStateChunk, "GetProject_LoopGran")
end

--A,AA=ultraschall.GetProject_LoopGran("c:\\tt.rpp")

function ultraschall.GetProject_RecPath(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RecPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string prim_recpath, string sec_recpath = ultraschall.GetProject_RecPath(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the primary and secondary recording-path from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry RECORD_PATH
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string prim_recpath - the primary recording path
    string sec_recpath - the secondary recording path
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, path, recording path, primary, secondary</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RecPath","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RecPath","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RecPath","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RecPath", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  ProjectStateChunk=ProjectStateChunk:match("<REAPER_PROJECT.-(RECORD_PATH%s\".-\")%c.-<RECORD_CFG").." "
  
  return ProjectStateChunk:match("%s\"(.-)\"%s\"(.-)\"")
end

--A,AA=ultraschall.GetProject_RecPath("c:\\tt.rpp")


function ultraschall.GetProject_RecordCFG(projectfilename_with_path, ProjectStateChunk)
--To Do: Research
-- ProjectSettings->Media->Recording
-- recording-cfg-string

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RecordCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string recording_cfg_string = ultraschall.GetProject_RecordCFG(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the recording-configuration as encoded BASE64-string from an RPP-Projectfile or a ProjectStateChunk, as set in ProjectSettings->Media->Recording.
    
    It's the entry &lt;RECORD_CFG
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string recording_cfg_string - the record-configuration as encoded string
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, configuration</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RecordCFG","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RecordCFG","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RecordCFG","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RecordCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  return ProjectStateChunk:match("<REAPER_PROJECT.-RECORD_CFG%c%s*(.-)%c.-RENDER_FILE")
end

--A=ultraschall.GetProject_RecordCFG("c:\\tt.rpp")

function ultraschall.GetProject_ApplyFXCFG(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_ApplyFXCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string applyfx_cfg_string = ultraschall.GetProject_ApplyFXCFG(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the audioformat-configuration, for fx-appliance-operation, as an encoded BASE64-string from an RPP-Projectfile or a ProjectStateChunk, as set in ProjectSettings->Media->Format for Apply FX, Glue, Freeze, etc
    
    It's the entry &lt;APPLY_CFG
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string applyfx_cfg_string - the file-format-configuration for fx-appliance as encoded string
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, fx, configuration</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_ApplyFXCFG","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ApplyFXCFG","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_ApplyFXCFG","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ApplyFXCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  
  return ProjectStateChunk:match("<REAPER_PROJECT.-APPLYFX_CFG%c%s*(.-)%c.-RENDER_FILE")
end

--A=ultraschall.GetProject_ApplyFXCFG("c:\\tt.rpp")


--A=ultraschall.GetProject_RenderFilename("C:\\Users\\meo\\Desktop\\hulaaa.RPP")

function ultraschall.GetProject_RenderPattern(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string render_pattern = ultraschall.GetProject_RenderPattern(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-pattern, that tells Reaper, how to automatically name the render-file, from an RPP-Projectfile or a ProjectStateChunk. If it contains nothing, you should check the Render_Pattern using <a href="#GetProject_RenderFilename">GetProject_RenderFilename</a>, as a render-pattern influences the rendering-filename as well.
    
    It's the entry RENDER_PATTERN
        
        Capitalizing the first character of the wildcard will capitalize the first letter of the substitution. 
        Capitalizing the first two characters of the wildcard will capitalize all letters.
        
        Directories will be created if necessary. For example if the render target 
        is "$project/track", the directory "$project" will be created.
        
        Immediately following a wildcard, character replacement statements may be specified:
          <X>  -- single character which is to be removed from the substitution. 
                      For example: $track< > removes all spaces from the track name, 
                                   $track</><\> removes all slashes.
                                   
          <abcdeX> -- multiple characters, abcde are all replaced with X. 
                      
                      For example: <_.> replaces all underscores with periods, 
                                   </\_> replaces all slashes with underscores. 
                      
                      If > is specified as a source character, it must be listed first in the list.
        
        $item    media item take name, if the input is a media item
        $itemnumber  1 for the first media item on a track, 2 for the second...
        $track    track name
        $tracknumber  1 for the first track, 2 for the second...
        $parenttrack  parent track name
        $region    region name
        $regionnumber  1 for the first region, 2 for the second...
        $project    project name
        $tempo    project tempo at the start of the render region
        $timesignature  project time signature at the start of the render region, formatted as 4-4
        $filenumber  blank (optionally 1) for the first file rendered, 1 (optionally 2) for the second...
        $filenumber[N]  N for the first file rendered, N+1 for the second...
        $note    C0 for the first file rendered,C#0 for the second...
        $note[X]    X (example: B2) for the first file rendered, X+1 (example: C3) for the second...
        $natural    C0 for the first file rendered, D0 for the second...
        $natural[X]  X (example: F2) for the first file rendered, X+1 (example: G2) for the second...
        $namecount  1 for the first item or region of the same name, 2 for the second...
        $timelineorder  1 for the first item or region on the timeline, 2 for the second...
        
        Position/Length:
        $start    start time of the media item, render region, or time selection, in M-SS.TTT
        $end    end time of the media item, render region, or time selection, in M-SS.TTT
        $length    length of the media item, render region, or time selection, in M-SS.TTT
        $startbeats  start time in measures.beats of the media item, render region, or time selection
        $endbeats  end time in measures.beats of the media item, render region, or time selection
        $lengthbeats    length in measures.beats of the media item, render region, or time selection
        $starttimecode  start time in H-MM-SS-FF format of the media item, render region, or time selection
        $endtimecode  end time in H-MM-SS-FF format of the media item, render region, or time selection
        $startframes  start time in absolute frames of the media item, render region, or time selection
        $endframes  end time in absolute frames of the media item, render region, or time selection
        $lengthframes  length in absolute frames of the media item, render region, or time selection
        $startseconds  start time in whole seconds of the media item, render region, or time selection
        $endseconds  end time in whole seconds of the media item, render region, or time selection
        $lengthseconds  length in whole seconds of the media item, render region, or time selection
        
        Output Format:
        $format    render format (example: wav)
        $samplerate  sample rate (example: 44100)
        $sampleratek  sample rate (example: 44.1)
        $bitdepth  bit depth, if available (example: 24 or 32FP)
        
        Current Date/Time:
        $year    year, currently 2019
        $year2    last 2 digits of the year,currently 19
        $month    month number,currently 04
        $monthname  month name,currently apr
        $day    day of the month, currently 28
        $hour    hour of the day in 24-hour format,currently 23
        $hour12    hour of the day in 12-hour format,currently 11
        $ampm    am if before noon,pm if after noon,currently pm
        $minute    minute of the hour,currently 30
        $second    second of the minute,currently 27
        
        Computer Information:
        $user    user name
        $computer  computer name
        
        (this description has been taken from the Render Wildcard Help within the Render-Dialog of Reaper)
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string render_pattern - the pattern, with which the rendering-filename will be automatically created. Check also <a href="#GetProject_RenderFilename">GetProject_RenderFilename</a>  
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, render pattern, filename, render</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderPattern","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderPattern","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderPattern","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderPattern", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  local temp=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_PATTERN%s(.-)%c.-<RENDER_CFG")
--  if temp:sub(1,1)=="\"" then temp=temp:sub(2,-1) end
--  if temp:sub(-1,-1)=="\"" then temp=temp:sub(1,-2) end
  return temp
end

--A=ultraschall.GetProject_RenderPattern("c:\\tt.rpp")
--A=ultraschall.GetProject_RenderPattern("c:\\tt.rpp")

function ultraschall.GetProject_RenderFreqNChans(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderFreqNChans</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer unknown, integer rendernum_chans, integer render_frequency = ultraschall.GetProject_RenderFreqNChans(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns an unknown number, the render-frequency and rendernumber of channels from an RPP-Projectfile or a ProjectStateChunk.
    It's the entry RENDER_FMT
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer unknown - unknown number
    integer rendernum_chans - Number_Channels 0-seems default-project-settings(?), 1-Mono, 2-Stereo, ... up to 64 channels
    integer render_frequency - RenderFrequency -2147483647 to 2147483647, except 0, which seems to be default-project-settings-frequency
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, frequency, num channels, channels</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_FMT", ProjectStateChunk, "GetProject_RenderFreqNChans")
end

-- A,AA,AAA=ultraschall.GetProject_RenderFreqNChans("c:\\tt.rpp")

function ultraschall.GetProject_RenderSpeed(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderSpeed</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer render_speed = ultraschall.GetProject_RenderSpeed(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the rendering-speed from an RPP-Projectfile or a ProjectStateChunk.
    It's the entry RENDER_1X
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer render_speed - render_speed 
    -0-Fullspeed Offline
    -1-1x Offline
    -2-Online Render
    -3-Offline Render (Idle)
    -4-1x Offline Render (Idle)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, speed</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_1X", ProjectStateChunk, "GetProject_RenderSpeed")
end

--A=ultraschall.GetProject_RenderSpeed("c:\\tt.rpp")

function ultraschall.GetProject_RenderRange(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderRange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer bounds, number time_start, number time_end, integer tail, integer tail_length = ultraschall.GetProject_RenderRange(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-range, render-timestart, render-timeend, render-tail and render-taillength from an RPP-Projectfile or a ProjectStateChunk. To get RENDER_STEMS, refer <a href="#GetProject_RenderStems">GetProject_RenderStems</a>
    
    It's the entry RENDER_RANGE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer bounds - the bounds of the project to be rendered
                   - 0, Custom Time Range
                   - 1, Entire Project
                   - 2, Time Selection, 
                   - 3, Project Regions
                   - 4, Selected Media Items(in combination with RENDER_STEMS 32); to get RENDER_STEMS, refer <a href="#GetProject_RenderStems">GetProject_RenderStems</a>
                   - 5, Selected regions
    number time_start - TimeStart in milliseconds -2147483647 to 2147483647
    number time_end - TimeEnd in milliseconds 2147483647 to 2147483647
    integer tail - Tail on/off-flags for individual bounds
                 - 0, tail off for all bounds
                 - 1, custom time range -> tail on
                 - 2, entire project -> tail on
                 - 4, time selection -> tail on
                 - 8, project regions -> tail on    
    integer tail_length - TailLength in milliseconds, valuerange 0 - 2147483647
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, timestart, timeend, range, tail, bounds</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_RANGE", ProjectStateChunk, "GetProject_RenderRange")
end

--A,AA,AAA,AAAA,AAAAA=ultraschall.GetProject_RenderRange("c:\\tt.rpp")

function ultraschall.GetProject_RenderResample(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderResample</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer resample_mode, integer playback_resample_mode, integer project_smplrate4mix_and_fx = ultraschall.GetProject_RenderResample(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns Resamplemode for a)Rendering and b)Playback as well as c)if both are combined from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry RENDER_RESAMPLE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer resample_mode - Resample_Mode 
    -0-medium (64pt Sinc), 
    -1-Low (Linear Interpolation), 
    -2-Lowest (Point Sampling), 
    -3-Good(192pt Sinc), 
    -4-Better(384pt Sinc), 
    -5-Fast (IIR + Linear Interpolation), 
    -6-Fast (IIRx2 + Linear Interpolation), 
    -7-Fast (16pt sinc) - Default, 
    -8-HQ (512pt Sinc), 
    -9-Extreme HQ (768pt HQ Sinc)
    integer playback_resample_mode - Playback Resample Mode (as set in the Project-Settings)
    -0-medium (64pt Sinc), 
    -1-Low (Linear Interpolation), 
    -2-Lowest (Point Sampling), 
    -3-Good(192pt Sinc), 
    -4-Better(384pt Sinc), 
    -5-Fast (IIR + Linear Interpolation), 
    -6-Fast (IIRx2 + Linear Interpolation), 
    -7-Fast (16pt sinc) - Default, 
    -8-HQ (512pt Sinc), 
    -9-Extreme HQ (768pt HQ Sinc)
    integer project_smplrate4mix_and_fx - Use project sample rate for mixing and FX/synth processing-checkbox; 1, checked; 0, unchecked
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, resample, playback, mixing, fx, synth</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_RESAMPLE", ProjectStateChunk, "GetProject_RenderResample")
end

--A,AA,AAA,AAAA,AAAAA=ultraschall.GetProject_RenderResample("c:\\tt.rpp")

function ultraschall.GetProject_AddMediaToProjectAfterRender(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_AddMediaToProjectAfterRender</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>integer state = ultraschall.GetProject_AddMediaToProjectAfterRender(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns, if rendered media shall be added to the project afterwards as well as if likely silent files shall be rendered-state, from an RPP-Projectfile or a ProjectStateChunk.
   
    It's the state of the "Add rendered items to new tracks in project"- checkbox and "Do not render files that are likely silent"-checkbox, as set in the Render to file-dialog.
   
    It's the entry RENDER_ADDTOPROJ
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer state - the state of the "Add rendered items to new tracks in project"- checkbox and "Do not render files that are likely silent"-checkbox 
                  - &1, rendered media shall be added to the project afterwards; 0, don't add
                  - &2, don't render likely silent files; 0, render anyway
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, add, media, after, project</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_ADDTOPROJ", ProjectStateChunk, "GetProject_AddMediaToProjectAfterRender")
end

--A=ultraschall.GetProject_AddMediaToProjectAfterRender("c:\\tt.rpp")

function ultraschall.GetProject_RenderStems(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderStems</slug>
  <requires>
    Ultraschall=5
    Reaper=7.16
    Lua=5.3
  </requires>
  <functioncall>integer render_stems = ultraschall.GetProject_RenderStems(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-stems-state from an rpp-project-file or a ProjectStateChunk.
    
    It's the entry RENDER_STEMS
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer render_stems - the state of Render Stems
    - 0, Source Master Mix, 
    - 1, Source Master mix + stems, 
    - 3, Source Stems, selected tracks, 
    - &4, Multichannel Tracks to Multichannel Files, 
    - 8, Source Region Render Matrix, 
    - &16, Tracks with only Mono-Media to Mono Files,  
    - 32, Selected Media Items(in combination with RENDER_RANGE->Bounds->4, refer to <a href="#GetProject_RenderRange">GetProject_RenderRange</a> to get RENDER_RANGE)
    - 64,  Selected media items via master
    - 128, Selected tracks via master    
    - &256, Embed stretch markers/transient guides-checkbox
    - &512, Embed metadata-checkbox
    - &1024, Embed Take markers
    - &2048, 2nd pass rendering
    - &8192, Render stems pre-fader
    - &16384, Only render channels that are sent to parent
    - &32768, (Preserve) Metadata-checkbox
    - &65536, (Preserve) Start offset-checkbox(only with Selected media items as source)
    - 4096, Razor edit areas
    - 4224, Razor edit areas via master
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, stems, multichannel</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_STEMS", ProjectStateChunk, "GetProject_RenderStems")
end

--A=ultraschall.GetProject_RenderStems("c:\\tt.rpp")

function ultraschall.GetProject_RenderDitherState(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderDitherState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer renderdither_state = ultraschall.GetProject_RenderDitherState(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-dither-state from an rpp-project-file or a ProjectStateChunk.

    It's the entry RENDER_DITHER
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer renderdither_state - the state of render dithering
    - &1,   Dither Master mix
    - &2,   Noise shaping Master mix
    - &4,   Dither Stems
    - &8,   Noise shaping Stems
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, render, dither, state, master, noise shaping</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_DITHER", ProjectStateChunk, "GetProject_RenderDitherState")
end

--A=ultraschall.GetProject_RenderDitherState("c:\\tt.rpp")


function ultraschall.GetProject_TimeBase(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TimeBase</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer timebase = ultraschall.GetProject_TimeBase(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the timebase-state from an rpp-project-file or a ProjectStateChunk.
    It's the entry TIMELOCKMODE x
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer timebase - the timebase for items/envelopes/markers as set in the project settings
    -0 - Time, 
    -1 - Beats (position, length, rate), 
    -2 - Beats (position only)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, timebase, time, beats, items, envelopes, markers</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "TIMELOCKMODE", ProjectStateChunk, "GetProject_TimeBase")
end

--A=ultraschall.GetProject_TimeBase("c:\\tt.rpp")

-- Mespotine Start

function ultraschall.GetProject_TempoTimeSignature(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TempoTimeSignature</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer tempotimesignature = ultraschall.GetProject_TempoTimeSignature(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the timebase for tempo/time-signature as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    It's the entry TEMPOENVLOCKMODE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer tempotimesignature - the timebase for tempo/time-signature as set in the project settings
    -0 - Time 
    -1 - Beats
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, timebase, time, beats, tempo, signature</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "TEMPOENVLOCKMODE", ProjectStateChunk, "GetProject_TempoTimeSignature")
end

--A=ultraschall.GetProject_TempoTimeSignature("c:\\tt.rpp")

function ultraschall.GetProject_ItemMixBehavior(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_ItemMixBehavior</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer item_mix_behav_state = ultraschall.GetProject_ItemMixBehavior(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the item mix behavior, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    It's the entry ITEMMIX
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer item_mix_behav_state - item mix behavior
    - 0 - Enclosed items replace enclosing items 
    - 1 - Items always mix
    - 2 - Items always replace earlier items
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, item, mix</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "ITEMMIX", ProjectStateChunk, "GetProject_ItemMixBehavior")
end

--A=ultraschall.GetProject_ItemMixBehavior("c:\\tt.rpp")

function ultraschall.GetProject_DefPitchMode(projectfilename_with_path, ProjectStateChunk)
-- returns Default Pitch Mode for project

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_DefPitchMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>integer def_pitch_mode_state, integer stretch_marker_mode = ultraschall.GetProject_DefPitchMode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the default-pitch-mode, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    
    It's the entry DEFPITCHMODE
    
    def_pitch_mode_state can be 
        
        SoundTouch:
            0 - Default settings
            1 - High Quality
            2 - Fast

        Simple windowed (fast):
            131072 - 50ms window, 25ms fade
            131073 - 50ms window, 16ms fade
            131074 - 50ms window, 10ms fade
            131075 - 50ms window, 7ms fade
            131076 - 75ms window, 37ms fade
            131077 - 75ms window, 25ms fade
            131078 - 75ms window, 15ms fade
            131079 - 75ms window, 10ms fade
            131080 - 100ms window, 50ms fade
            131081 - 100ms window, 33ms fade
            131082 - 100ms window, 20ms fade
            131083 - 100ms window, 14ms fade
            131084 - 150ms window, 75ms fade
            131085 - 150ms window, 50ms fade
            131086 - 150ms window, 30ms fade
            131087 - 150ms window, 21ms fade
            131088 - 225ms window, 112ms fade
            131089 - 225ms window, 75ms fade
            131090 - 225ms window, 45ms fade
            131091 - 225ms window, 32ms fade
            131092 - 300ms window, 150ms fade
            131093 - 300ms window, 100ms fade
            131094 - 300ms window, 60ms fade
            131095 - 300ms window, 42ms fade
            131096 - 40ms window, 20ms fade
            131097 - 40ms window, 13ms fade
            131098 - 40ms window, 8ms fade
            131099 - 40ms window, 5ms fade
            131100 - 30ms window, 15ms fade
            131101 - 30ms window, 10ms fade
            131102 - 30ms window, 6ms fade
            131103 - 30ms window, 4ms fade
            131104 - 20ms window, 10ms fade
            131105 - 20ms window, 6ms fade
            131106 - 20ms window, 4ms fade
            131107 - 20ms window, 2ms fade
            131108 - 10ms window, 5ms fade
            131109 - 10ms window, 3ms fade
            131110 - 10ms window, 2ms fade
            131111 - 10ms window, 1ms fade
            131112 - 5ms window, 2ms fade
            131113 - 5ms window, 1ms fade
            131114 - 5ms window, 1ms fade
            131115 - 5ms window, 1ms fade
            131116 - 3ms window, 1ms fade
            131117 - 3ms window, 1ms fade
            131118 - 3ms window, 1ms fade
            131119 - 3ms window, 1ms fade

        Ã©lastique 2.2.8 Pro:
            393216 - Normal
            393217 - Preserve Formants (Lowest Pitches)
            393218 - Preserve Formants (Lower Pitches)
            393219 - Preserve Formants (Low Pitches)
            393220 - Preserve Formants (Most Pitches)
            393221 - Preserve Formants (High Pitches)
            393222 - Preserve Formants (Higher Pitches)
            393223 - Preserve Formants (Highest Pitches)
            393224 - Mid/Side
            393225 - Mid/Side, Preserve Formants (Lowest Pitches)
            393226 - Mid/Side, Preserve Formants (Lower Pitches)
            393227 - Mid/Side, Preserve Formants (Low Pitches)
            393228 - Mid/Side, Preserve Formants (Most Pitches)
            393229 - Mid/Side, Preserve Formants (High Pitches)
            393230 - Mid/Side, Preserve Formants (Higher Pitches)
            393231 - Mid/Side, Preserve Formants (Highest Pitches)
            393232 - Synchronized: Normal
            393233 - Synchronized: Preserve Formants (Lowest Pitches)
            393234 - Synchronized: Preserve Formants (Lower Pitches)
            393235 - Synchronized: Preserve Formants (Low Pitches)
            393236 - Synchronized: Preserve Formants (Most Pitches)
            393237 - Synchronized: Preserve Formants (High Pitches)
            393238 - Synchronized: Preserve Formants (Higher Pitches)
            393239 - Synchronized: Preserve Formants (Highest Pitches)
            393240 - Synchronized:  Mid/Side
            393241 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            393242 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            393243 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            393244 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            393245 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            393246 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            393247 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 2.2.8 Efficient:
            458752 - Normal
            458753 - Mid/Side
            458754 - Synchronized: Normal
            458755 - Synchronized: Mid/Side

        Ã©lastique 2.2.8 Soloist:
            524288 - Monophonic
            524289 - Monophonic [Mid/Side]
            524290 - Speech
            524291 - Speech [Mid/Side]

        Ã©lastique 3.3.0 Pro:
            589824 - Normal
            589825 - Preserve Formants (Lowest Pitches)
            589826 - Preserve Formants (Lower Pitches)
            589827 - Preserve Formants (Low Pitches)
            589828 - Preserve Formants (Most Pitches)
            589829 - Preserve Formants (High Pitches)
            589830 - Preserve Formants (Higher Pitches)
            589831 - Preserve Formants (Highest Pitches)
            589832 - Mid/Side
            589833 - Mid/Side, Preserve Formants (Lowest Pitches)
            589834 - Mid/Side, Preserve Formants (Lower Pitches)
            589835 - Mid/Side, Preserve Formants (Low Pitches)
            589836 - Mid/Side, Preserve Formants (Most Pitches)
            589837 - Mid/Side, Preserve Formants (High Pitches)
            589838 - Mid/Side, Preserve Formants (Higher Pitches)
            589839 - Mid/Side, Preserve Formants (Highest Pitches)
            589840 - Synchronized: Normal
            589841 - Synchronized: Preserve Formants (Lowest Pitches)
            589842 - Synchronized: Preserve Formants (Lower Pitches)
            589843 - Synchronized: Preserve Formants (Low Pitches)
            589844 - Synchronized: Preserve Formants (Most Pitches)
            589845 - Synchronized: Preserve Formants (High Pitches)
            589846 - Synchronized: Preserve Formants (Higher Pitches)
            589847 - Synchronized: Preserve Formants (Highest Pitches)
            589848 - Synchronized:  Mid/Side
            589849 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            589850 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            589851 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            589852 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            589853 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            589854 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            589855 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 3.3.0 Efficient:
            655360 - Normal
            655361 - Mid/Side
            655362 - Synchronized: Normal
            655363 - Synchronized: Mid/Side

        Ã©lastique 3.3.0 Soloist:
            720896 - Monophonic
            720897 - Monophonic [Mid/Side]
            720898 - Speech
            720899 - Speech [Mid/Side]


        Rubber Band Library - Default
            851968 - nothing

        Rubber Band Library - Preserve Formants
            851969 - Preserve Formants

        Rubber Band Library - Mid/Side
            851970 - Mid/Side

        Rubber Band Library - Preserve Formants, Mid/Side
            851971 - Preserve Formants, Mid/Side

        Rubber Band Library - Independent Phase
            851972 - Independent Phase

        Rubber Band Library - Preserve Formants, Independent Phase
            851973 - Preserve Formants, Independent Phase

        Rubber Band Library - Mid/Side, Independent Phase
            851974 - Mid/Side, Independent Phase

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase
            851975 - Preserve Formants, Mid/Side, Independent Phase

        Rubber Band Library - Time Domain Smoothing
            851976 - Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Time Domain Smoothing
            851977 - Preserve Formants, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Time Domain Smoothing
            851978 - Mid/Side, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Time Domain Smoothing
            851979 - Preserve Formants, Mid/Side, Time Domain Smoothing

        Rubber Band Library - Independent Phase, Time Domain Smoothing
            851980 - Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Independent Phase, Time Domain Smoothing
            851981 - Preserve Formants, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Independent Phase, Time Domain Smoothing
            851982 - Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing
            851983 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed
            851984 - nothing
            851985 - Preserve Formants
            851986 - Mid/Side
            851987 - Preserve Formants, Mid/Side
            851988 - Independent Phase
            851989 - Preserve Formants, Independent Phase
            851990 - Mid/Side, Independent Phase
            851991 - Preserve Formants, Mid/Side, Independent Phase
            851992 - Time Domain Smoothing
            851993 - Preserve Formants, Time Domain Smoothing
            851994 - Mid/Side, Time Domain Smoothing
            851995 - Preserve Formants, Mid/Side, Time Domain Smoothing
            851996 - Independent Phase, Time Domain Smoothing
            851997 - Preserve Formants, Independent Phase, Time Domain Smoothing
            851998 - Mid/Side, Independent Phase, Time Domain Smoothing
            851999 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth
            852000 - nothing
            852001 - Preserve Formants
            852002 - Mid/Side
            852003 - Preserve Formants, Mid/Side
            852004 - Independent Phase
            852005 - Preserve Formants, Independent Phase
            852006 - Mid/Side, Independent Phase
            852007 - Preserve Formants, Mid/Side, Independent Phase
            852008 - Time Domain Smoothing
            852009 - Preserve Formants, Time Domain Smoothing
            852010 - Mid/Side, Time Domain Smoothing
            852011 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852012 - Independent Phase, Time Domain Smoothing
            852013 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852014 - Mid/Side, Independent Phase, Time Domain Smoothing
            852015 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive
            852016 - nothing
            852017 - Preserve Formants
            852018 - Mid/Side
            852019 - Preserve Formants, Mid/Side
            852020 - Independent Phase
            852021 - Preserve Formants, Independent Phase
            852022 - Mid/Side, Independent Phase
            852023 - Preserve Formants, Mid/Side, Independent Phase
            852024 - Time Domain Smoothing
            852025 - Preserve Formants, Time Domain Smoothing
            852026 - Mid/Side, Time Domain Smoothing
            852027 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852028 - Independent Phase, Time Domain Smoothing
            852029 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852030 - Mid/Side, Independent Phase, Time Domain Smoothing
            852031 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive
            852032 - nothing
            852033 - Preserve Formants
            852034 - Mid/Side
            852035 - Preserve Formants, Mid/Side
            852036 - Independent Phase
            852037 - Preserve Formants, Independent Phase
            852038 - Mid/Side, Independent Phase
            852039 - Preserve Formants, Mid/Side, Independent Phase
            852040 - Time Domain Smoothing
            852041 - Preserve Formants, Time Domain Smoothing
            852042 - Mid/Side, Time Domain Smoothing
            852043 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852044 - Independent Phase, Time Domain Smoothing
            852045 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852046 - Mid/Side, Independent Phase, Time Domain Smoothing
            852047 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive
            852048 - nothing
            852049 - Preserve Formants
            852050 - Mid/Side
            852051 - Preserve Formants, Mid/Side
            852052 - Independent Phase
            852053 - Preserve Formants, Independent Phase
            852054 - Mid/Side, Independent Phase
            852055 - Preserve Formants, Mid/Side, Independent Phase
            852056 - Time Domain Smoothing
            852057 - Preserve Formants, Time Domain Smoothing
            852058 - Mid/Side, Time Domain Smoothing
            852059 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852060 - Independent Phase, Time Domain Smoothing
            852061 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852062 - Mid/Side, Independent Phase, Time Domain Smoothing
            852063 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft
            852064 - nothing
            852065 - Preserve Formants
            852066 - Mid/Side
            852067 - Preserve Formants, Mid/Side
            852068 - Independent Phase
            852069 - Preserve Formants, Independent Phase
            852070 - Mid/Side, Independent Phase
            852071 - Preserve Formants, Mid/Side, Independent Phase
            852072 - Time Domain Smoothing
            852073 - Preserve Formants, Time Domain Smoothing
            852074 - Mid/Side, Time Domain Smoothing
            852075 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852076 - Independent Phase, Time Domain Smoothing
            852077 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852078 - Mid/Side, Independent Phase, Time Domain Smoothing
            852079 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft
            852080 - nothing
            852081 - Preserve Formants
            852082 - Mid/Side
            852083 - Preserve Formants, Mid/Side
            852084 - Independent Phase
            852085 - Preserve Formants, Independent Phase
            852086 - Mid/Side, Independent Phase
            852087 - Preserve Formants, Mid/Side, Independent Phase
            852088 - Time Domain Smoothing
            852089 - Preserve Formants, Time Domain Smoothing
            852090 - Mid/Side, Time Domain Smoothing
            852091 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852092 - Independent Phase, Time Domain Smoothing
            852093 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852094 - Mid/Side, Independent Phase, Time Domain Smoothing
            852095 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft
            852096 - nothing
            852097 - Preserve Formants
            852098 - Mid/Side
            852099 - Preserve Formants, Mid/Side
            852100 - Independent Phase
            852101 - Preserve Formants, Independent Phase
            852102 - Mid/Side, Independent Phase
            852103 - Preserve Formants, Mid/Side, Independent Phase
            852104 - Time Domain Smoothing
            852105 - Preserve Formants, Time Domain Smoothing
            852106 - Mid/Side, Time Domain Smoothing
            852107 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852108 - Independent Phase, Time Domain Smoothing
            852109 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852110 - Mid/Side, Independent Phase, Time Domain Smoothing
            852111 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ
            852112 - nothing
            852113 - Preserve Formants
            852114 - Mid/Side
            852115 - Preserve Formants, Mid/Side
            852116 - Independent Phase
            852117 - Preserve Formants, Independent Phase
            852118 - Mid/Side, Independent Phase
            852119 - Preserve Formants, Mid/Side, Independent Phase
            852120 - Time Domain Smoothing
            852121 - Preserve Formants, Time Domain Smoothing
            852122 - Mid/Side, Time Domain Smoothing
            852123 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852124 - Independent Phase, Time Domain Smoothing
            852125 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852126 - Mid/Side, Independent Phase, Time Domain Smoothing
            852127 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ
            852128 - nothing
            852129 - Preserve Formants
            852130 - Mid/Side
            852131 - Preserve Formants, Mid/Side
            852132 - Independent Phase
            852133 - Preserve Formants, Independent Phase
            852134 - Mid/Side, Independent Phase
            852135 - Preserve Formants, Mid/Side, Independent Phase
            852136 - Time Domain Smoothing
            852137 - Preserve Formants, Time Domain Smoothing
            852138 - Mid/Side, Time Domain Smoothing
            852139 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852140 - Independent Phase, Time Domain Smoothing
            852141 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852142 - Mid/Side, Independent Phase, Time Domain Smoothing
            852143 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ
            852144 - nothing
            852145 - Preserve Formants
            852146 - Mid/Side
            852147 - Preserve Formants, Mid/Side
            852148 - Independent Phase
            852149 - Preserve Formants, Independent Phase
            852150 - Mid/Side, Independent Phase
            852151 - Preserve Formants, Mid/Side, Independent Phase
            852152 - Time Domain Smoothing
            852153 - Preserve Formants, Time Domain Smoothing
            852154 - Mid/Side, Time Domain Smoothing
            852155 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852156 - Independent Phase, Time Domain Smoothing
            852157 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852158 - Mid/Side, Independent Phase, Time Domain Smoothing
            852159 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ
            852160 - nothing
            852161 - Preserve Formants
            852162 - Mid/Side
            852163 - Preserve Formants, Mid/Side
            852164 - Independent Phase
            852165 - Preserve Formants, Independent Phase
            852166 - Mid/Side, Independent Phase
            852167 - Preserve Formants, Mid/Side, Independent Phase
            852168 - Time Domain Smoothing
            852169 - Preserve Formants, Time Domain Smoothing
            852170 - Mid/Side, Time Domain Smoothing
            852171 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852172 - Independent Phase, Time Domain Smoothing
            852173 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852174 - Mid/Side, Independent Phase, Time Domain Smoothing
            852175 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ
            852176 - nothing
            852177 - Preserve Formants
            852178 - Mid/Side
            852179 - Preserve Formants, Mid/Side
            852180 - Independent Phase
            852181 - Preserve Formants, Independent Phase
            852182 - Mid/Side, Independent Phase
            852183 - Preserve Formants, Mid/Side, Independent Phase
            852184 - Time Domain Smoothing
            852185 - Preserve Formants, Time Domain Smoothing
            852186 - Mid/Side, Time Domain Smoothing
            852187 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852188 - Independent Phase, Time Domain Smoothing
            852189 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852190 - Mid/Side, Independent Phase, Time Domain Smoothing
            852191 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ
            852192 - nothing
            852193 - Preserve Formants
            852194 - Mid/Side
            852195 - Preserve Formants, Mid/Side
            852196 - Independent Phase
            852197 - Preserve Formants, Independent Phase
            852198 - Mid/Side, Independent Phase
            852199 - Preserve Formants, Mid/Side, Independent Phase
            852200 - Time Domain Smoothing
            852201 - Preserve Formants, Time Domain Smoothing
            852202 - Mid/Side, Time Domain Smoothing
            852203 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852204 - Independent Phase, Time Domain Smoothing
            852205 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852206 - Mid/Side, Independent Phase, Time Domain Smoothing
            852207 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ
            852208 - nothing
            852209 - Preserve Formants
            852210 - Mid/Side
            852211 - Preserve Formants, Mid/Side
            852212 - Independent Phase
            852213 - Preserve Formants, Independent Phase
            852214 - Mid/Side, Independent Phase
            852215 - Preserve Formants, Mid/Side, Independent Phase
            852216 - Time Domain Smoothing
            852217 - Preserve Formants, Time Domain Smoothing
            852218 - Mid/Side, Time Domain Smoothing
            852219 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852220 - Independent Phase, Time Domain Smoothing
            852221 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852222 - Mid/Side, Independent Phase, Time Domain Smoothing
            852223 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ
            852224 - nothing
            852225 - Preserve Formants
            852226 - Mid/Side
            852227 - Preserve Formants, Mid/Side
            852228 - Independent Phase
            852229 - Preserve Formants, Independent Phase
            852230 - Mid/Side, Independent Phase
            852231 - Preserve Formants, Mid/Side, Independent Phase
            852232 - Time Domain Smoothing
            852233 - Preserve Formants, Time Domain Smoothing
            852234 - Mid/Side, Time Domain Smoothing
            852235 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852236 - Independent Phase, Time Domain Smoothing
            852237 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852238 - Mid/Side, Independent Phase, Time Domain Smoothing
            852239 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ
            852240 - nothing
            852241 - Preserve Formants
            852242 - Mid/Side
            852243 - Preserve Formants, Mid/Side
            852244 - Independent Phase
            852245 - Preserve Formants, Independent Phase
            852246 - Mid/Side, Independent Phase
            852247 - Preserve Formants, Mid/Side, Independent Phase
            852248 - Time Domain Smoothing
            852249 - Preserve Formants, Time Domain Smoothing
            852250 - Mid/Side, Time Domain Smoothing
            852251 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852252 - Independent Phase, Time Domain Smoothing
            852253 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852254 - Mid/Side, Independent Phase, Time Domain Smoothing
            852255 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent
            852256 - nothing
            852257 - Preserve Formants
            852258 - Mid/Side
            852259 - Preserve Formants, Mid/Side
            852260 - Independent Phase
            852261 - Preserve Formants, Independent Phase
            852262 - Mid/Side, Independent Phase
            852263 - Preserve Formants, Mid/Side, Independent Phase
            852264 - Time Domain Smoothing
            852265 - Preserve Formants, Time Domain Smoothing
            852266 - Mid/Side, Time Domain Smoothing
            852267 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852268 - Independent Phase, Time Domain Smoothing
            852269 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852270 - Mid/Side, Independent Phase, Time Domain Smoothing
            852271 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent
            852272 - nothing
            852273 - Preserve Formants
            852274 - Mid/Side
            852275 - Preserve Formants, Mid/Side
            852276 - Independent Phase
            852277 - Preserve Formants, Independent Phase
            852278 - Mid/Side, Independent Phase
            852279 - Preserve Formants, Mid/Side, Independent Phase
            852280 - Time Domain Smoothing
            852281 - Preserve Formants, Time Domain Smoothing
            852282 - Mid/Side, Time Domain Smoothing
            852283 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852284 - Independent Phase, Time Domain Smoothing
            852285 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852286 - Mid/Side, Independent Phase, Time Domain Smoothing
            852287 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent
            852288 - nothing
            852289 - Preserve Formants
            852290 - Mid/Side
            852291 - Preserve Formants, Mid/Side
            852292 - Independent Phase
            852293 - Preserve Formants, Independent Phase
            852294 - Mid/Side, Independent Phase
            852295 - Preserve Formants, Mid/Side, Independent Phase
            852296 - Time Domain Smoothing
            852297 - Preserve Formants, Time Domain Smoothing
            852298 - Mid/Side, Time Domain Smoothing
            852299 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852300 - Independent Phase, Time Domain Smoothing
            852301 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852302 - Mid/Side, Independent Phase, Time Domain Smoothing
            852303 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent
            852304 - nothing
            852305 - Preserve Formants
            852306 - Mid/Side
            852307 - Preserve Formants, Mid/Side
            852308 - Independent Phase
            852309 - Preserve Formants, Independent Phase
            852310 - Mid/Side, Independent Phase
            852311 - Preserve Formants, Mid/Side, Independent Phase
            852312 - Time Domain Smoothing
            852313 - Preserve Formants, Time Domain Smoothing
            852314 - Mid/Side, Time Domain Smoothing
            852315 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852316 - Independent Phase, Time Domain Smoothing
            852317 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852318 - Mid/Side, Independent Phase, Time Domain Smoothing
            852319 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent
            852320 - nothing
            852321 - Preserve Formants
            852322 - Mid/Side
            852323 - Preserve Formants, Mid/Side
            852324 - Independent Phase
            852325 - Preserve Formants, Independent Phase
            852326 - Mid/Side, Independent Phase
            852327 - Preserve Formants, Mid/Side, Independent Phase
            852328 - Time Domain Smoothing
            852329 - Preserve Formants, Time Domain Smoothing
            852330 - Mid/Side, Time Domain Smoothing
            852331 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852332 - Independent Phase, Time Domain Smoothing
            852333 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852334 - Mid/Side, Independent Phase, Time Domain Smoothing
            852335 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent
            852336 - nothing
            852337 - Preserve Formants
            852338 - Mid/Side
            852339 - Preserve Formants, Mid/Side
            852340 - Independent Phase
            852341 - Preserve Formants, Independent Phase
            852342 - Mid/Side, Independent Phase
            852343 - Preserve Formants, Mid/Side, Independent Phase
            852344 - Time Domain Smoothing
            852345 - Preserve Formants, Time Domain Smoothing
            852346 - Mid/Side, Time Domain Smoothing
            852347 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852348 - Independent Phase, Time Domain Smoothing
            852349 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852350 - Mid/Side, Independent Phase, Time Domain Smoothing
            852351 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent
            852352 - nothing
            852353 - Preserve Formants
            852354 - Mid/Side
            852355 - Preserve Formants, Mid/Side
            852356 - Independent Phase
            852357 - Preserve Formants, Independent Phase
            852358 - Mid/Side, Independent Phase
            852359 - Preserve Formants, Mid/Side, Independent Phase
            852360 - Time Domain Smoothing
            852361 - Preserve Formants, Time Domain Smoothing
            852362 - Mid/Side, Time Domain Smoothing
            852363 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852364 - Independent Phase, Time Domain Smoothing
            852365 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852366 - Mid/Side, Independent Phase, Time Domain Smoothing
            852367 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent
            852368 - nothing
            852369 - Preserve Formants
            852370 - Mid/Side
            852371 - Preserve Formants, Mid/Side
            852372 - Independent Phase
            852373 - Preserve Formants, Independent Phase
            852374 - Mid/Side, Independent Phase
            852375 - Preserve Formants, Mid/Side, Independent Phase
            852376 - Time Domain Smoothing
            852377 - Preserve Formants, Time Domain Smoothing
            852378 - Mid/Side, Time Domain Smoothing
            852379 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852380 - Independent Phase, Time Domain Smoothing
            852381 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852382 - Mid/Side, Independent Phase, Time Domain Smoothing
            852383 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent
            852384 - nothing
            852385 - Preserve Formants
            852386 - Mid/Side
            852387 - Preserve Formants, Mid/Side
            852388 - Independent Phase
            852389 - Preserve Formants, Independent Phase
            852390 - Mid/Side, Independent Phase
            852391 - Preserve Formants, Mid/Side, Independent Phase
            852392 - Time Domain Smoothing
            852393 - Preserve Formants, Time Domain Smoothing
            852394 - Mid/Side, Time Domain Smoothing
            852395 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852396 - Independent Phase, Time Domain Smoothing
            852397 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852398 - Mid/Side, Independent Phase, Time Domain Smoothing
            852399 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Short
            852400 - nothing
            852401 - Preserve Formants
            852402 - Mid/Side
            852403 - Preserve Formants, Mid/Side
            852404 - Independent Phase
            852405 - Preserve Formants, Independent Phase
            852406 - Mid/Side, Independent Phase
            852407 - Preserve Formants, Mid/Side, Independent Phase
            852408 - Time Domain Smoothing
            852409 - Preserve Formants, Time Domain Smoothing
            852410 - Mid/Side, Time Domain Smoothing
            852411 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852412 - Independent Phase, Time Domain Smoothing
            852413 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852414 - Mid/Side, Independent Phase, Time Domain Smoothing
            852415 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Short
            852416 - nothing
            852417 - Preserve Formants
            852418 - Mid/Side
            852419 - Preserve Formants, Mid/Side
            852420 - Independent Phase
            852421 - Preserve Formants, Independent Phase
            852422 - Mid/Side, Independent Phase
            852423 - Preserve Formants, Mid/Side, Independent Phase
            852424 - Time Domain Smoothing
            852425 - Preserve Formants, Time Domain Smoothing
            852426 - Mid/Side, Time Domain Smoothing
            852427 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852428 - Independent Phase, Time Domain Smoothing
            852429 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852430 - Mid/Side, Independent Phase, Time Domain Smoothing
            852431 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Short
            852432 - nothing
            852433 - Preserve Formants
            852434 - Mid/Side
            852435 - Preserve Formants, Mid/Side
            852436 - Independent Phase
            852437 - Preserve Formants, Independent Phase
            852438 - Mid/Side, Independent Phase
            852439 - Preserve Formants, Mid/Side, Independent Phase
            852440 - Time Domain Smoothing
            852441 - Preserve Formants, Time Domain Smoothing
            852442 - Mid/Side, Time Domain Smoothing
            852443 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852444 - Independent Phase, Time Domain Smoothing
            852445 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852446 - Mid/Side, Independent Phase, Time Domain Smoothing
            852447 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Short
            852448 - nothing
            852449 - Preserve Formants
            852450 - Mid/Side
            852451 - Preserve Formants, Mid/Side
            852452 - Independent Phase
            852453 - Preserve Formants, Independent Phase
            852454 - Mid/Side, Independent Phase
            852455 - Preserve Formants, Mid/Side, Independent Phase
            852456 - Time Domain Smoothing
            852457 - Preserve Formants, Time Domain Smoothing
            852458 - Mid/Side, Time Domain Smoothing
            852459 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852460 - Independent Phase, Time Domain Smoothing
            852461 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852462 - Mid/Side, Independent Phase, Time Domain Smoothing
            852463 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Short
            852464 - nothing
            852465 - Preserve Formants
            852466 - Mid/Side
            852467 - Preserve Formants, Mid/Side
            852468 - Independent Phase
            852469 - Preserve Formants, Independent Phase
            852470 - Mid/Side, Independent Phase
            852471 - Preserve Formants, Mid/Side, Independent Phase
            852472 - Time Domain Smoothing
            852473 - Preserve Formants, Time Domain Smoothing
            852474 - Mid/Side, Time Domain Smoothing
            852475 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852476 - Independent Phase, Time Domain Smoothing
            852477 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852478 - Mid/Side, Independent Phase, Time Domain Smoothing
            852479 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Short
            852480 - nothing
            852481 - Preserve Formants
            852482 - Mid/Side
            852483 - Preserve Formants, Mid/Side
            852484 - Independent Phase
            852485 - Preserve Formants, Independent Phase
            852486 - Mid/Side, Independent Phase
            852487 - Preserve Formants, Mid/Side, Independent Phase
            852488 - Time Domain Smoothing
            852489 - Preserve Formants, Time Domain Smoothing
            852490 - Mid/Side, Time Domain Smoothing
            852491 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852492 - Independent Phase, Time Domain Smoothing
            852493 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852494 - Mid/Side, Independent Phase, Time Domain Smoothing
            852495 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Short
            852496 - nothing
            852497 - Preserve Formants
            852498 - Mid/Side
            852499 - Preserve Formants, Mid/Side
            852500 - Independent Phase
            852501 - Preserve Formants, Independent Phase
            852502 - Mid/Side, Independent Phase
            852503 - Preserve Formants, Mid/Side, Independent Phase
            852504 - Time Domain Smoothing
            852505 - Preserve Formants, Time Domain Smoothing
            852506 - Mid/Side, Time Domain Smoothing
            852507 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852508 - Independent Phase, Time Domain Smoothing
            852509 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852510 - Mid/Side, Independent Phase, Time Domain Smoothing
            852511 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Short
            852512 - nothing
            852513 - Preserve Formants
            852514 - Mid/Side
            852515 - Preserve Formants, Mid/Side
            852516 - Independent Phase
            852517 - Preserve Formants, Independent Phase
            852518 - Mid/Side, Independent Phase
            852519 - Preserve Formants, Mid/Side, Independent Phase
            852520 - Time Domain Smoothing
            852521 - Preserve Formants, Time Domain Smoothing
            852522 - Mid/Side, Time Domain Smoothing
            852523 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852524 - Independent Phase, Time Domain Smoothing
            852525 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852526 - Mid/Side, Independent Phase, Time Domain Smoothing
            852527 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Short
            852528 - nothing
            852529 - Preserve Formants
            852530 - Mid/Side
            852531 - Preserve Formants, Mid/Side
            852532 - Independent Phase
            852533 - Preserve Formants, Independent Phase
            852534 - Mid/Side, Independent Phase
            852535 - Preserve Formants, Mid/Side, Independent Phase
            852536 - Time Domain Smoothing
            852537 - Preserve Formants, Time Domain Smoothing
            852538 - Mid/Side, Time Domain Smoothing
            852539 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852540 - Independent Phase, Time Domain Smoothing
            852541 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852542 - Mid/Side, Independent Phase, Time Domain Smoothing
            852543 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Short
            852544 - nothing
            852545 - Preserve Formants
            852546 - Mid/Side
            852547 - Preserve Formants, Mid/Side
            852548 - Independent Phase
            852549 - Preserve Formants, Independent Phase
            852550 - Mid/Side, Independent Phase
            852551 - Preserve Formants, Mid/Side, Independent Phase
            852552 - Time Domain Smoothing
            852553 - Preserve Formants, Time Domain Smoothing
            852554 - Mid/Side, Time Domain Smoothing
            852555 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852556 - Independent Phase, Time Domain Smoothing
            852557 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852558 - Mid/Side, Independent Phase, Time Domain Smoothing
            852559 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Short
            852560 - nothing
            852561 - Preserve Formants
            852562 - Mid/Side
            852563 - Preserve Formants, Mid/Side
            852564 - Independent Phase
            852565 - Preserve Formants, Independent Phase
            852566 - Mid/Side, Independent Phase
            852567 - Preserve Formants, Mid/Side, Independent Phase
            852568 - Time Domain Smoothing
            852569 - Preserve Formants, Time Domain Smoothing
            852570 - Mid/Side, Time Domain Smoothing
            852571 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852572 - Independent Phase, Time Domain Smoothing
            852573 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852574 - Mid/Side, Independent Phase, Time Domain Smoothing
            852575 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Short
            852576 - nothing
            852577 - Preserve Formants
            852578 - Mid/Side
            852579 - Preserve Formants, Mid/Side
            852580 - Independent Phase
            852581 - Preserve Formants, Independent Phase
            852582 - Mid/Side, Independent Phase
            852583 - Preserve Formants, Mid/Side, Independent Phase
            852584 - Time Domain Smoothing
            852585 - Preserve Formants, Time Domain Smoothing
            852586 - Mid/Side, Time Domain Smoothing
            852587 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852588 - Independent Phase, Time Domain Smoothing
            852589 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852590 - Mid/Side, Independent Phase, Time Domain Smoothing
            852591 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852592 - nothing
            852593 - Preserve Formants
            852594 - Mid/Side
            852595 - Preserve Formants, Mid/Side
            852596 - Independent Phase
            852597 - Preserve Formants, Independent Phase
            852598 - Mid/Side, Independent Phase
            852599 - Preserve Formants, Mid/Side, Independent Phase
            852600 - Time Domain Smoothing
            852601 - Preserve Formants, Time Domain Smoothing
            852602 - Mid/Side, Time Domain Smoothing
            852603 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852604 - Independent Phase, Time Domain Smoothing
            852605 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852606 - Mid/Side, Independent Phase, Time Domain Smoothing
            852607 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852608 - nothing
            852609 - Preserve Formants
            852610 - Mid/Side
            852611 - Preserve Formants, Mid/Side
            852612 - Independent Phase
            852613 - Preserve Formants, Independent Phase
            852614 - Mid/Side, Independent Phase
            852615 - Preserve Formants, Mid/Side, Independent Phase
            852616 - Time Domain Smoothing
            852617 - Preserve Formants, Time Domain Smoothing
            852618 - Mid/Side, Time Domain Smoothing
            852619 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852620 - Independent Phase, Time Domain Smoothing
            852621 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852622 - Mid/Side, Independent Phase, Time Domain Smoothing
            852623 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852624 - nothing
            852625 - Preserve Formants
            852626 - Mid/Side
            852627 - Preserve Formants, Mid/Side
            852628 - Independent Phase
            852629 - Preserve Formants, Independent Phase
            852630 - Mid/Side, Independent Phase
            852631 - Preserve Formants, Mid/Side, Independent Phase
            852632 - Time Domain Smoothing
            852633 - Preserve Formants, Time Domain Smoothing
            852634 - Mid/Side, Time Domain Smoothing
            852635 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852636 - Independent Phase, Time Domain Smoothing
            852637 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852638 - Mid/Side, Independent Phase, Time Domain Smoothing
            852639 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Short
            852640 - nothing
            852641 - Preserve Formants
            852642 - Mid/Side
            852643 - Preserve Formants, Mid/Side
            852644 - Independent Phase
            852645 - Preserve Formants, Independent Phase
            852646 - Mid/Side, Independent Phase
            852647 - Preserve Formants, Mid/Side, Independent Phase
            852648 - Time Domain Smoothing
            852649 - Preserve Formants, Time Domain Smoothing
            852650 - Mid/Side, Time Domain Smoothing
            852651 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852652 - Independent Phase, Time Domain Smoothing
            852653 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852654 - Mid/Side, Independent Phase, Time Domain Smoothing
            852655 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852656 - nothing
            852657 - Preserve Formants
            852658 - Mid/Side
            852659 - Preserve Formants, Mid/Side
            852660 - Independent Phase
            852661 - Preserve Formants, Independent Phase
            852662 - Mid/Side, Independent Phase
            852663 - Preserve Formants, Mid/Side, Independent Phase
            852664 - Time Domain Smoothing
            852665 - Preserve Formants, Time Domain Smoothing
            852666 - Mid/Side, Time Domain Smoothing
            852667 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852668 - Independent Phase, Time Domain Smoothing
            852669 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852670 - Mid/Side, Independent Phase, Time Domain Smoothing
            852671 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852672 - nothing
            852673 - Preserve Formants
            852674 - Mid/Side
            852675 - Preserve Formants, Mid/Side
            852676 - Independent Phase
            852677 - Preserve Formants, Independent Phase
            852678 - Mid/Side, Independent Phase
            852679 - Preserve Formants, Mid/Side, Independent Phase
            852680 - Time Domain Smoothing
            852681 - Preserve Formants, Time Domain Smoothing
            852682 - Mid/Side, Time Domain Smoothing
            852683 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852684 - Independent Phase, Time Domain Smoothing
            852685 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852686 - Mid/Side, Independent Phase, Time Domain Smoothing
            852687 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Short
            852688 - nothing
            852689 - Preserve Formants
            852690 - Mid/Side
            852691 - Preserve Formants, Mid/Side
            852692 - Independent Phase
            852693 - Preserve Formants, Independent Phase
            852694 - Mid/Side, Independent Phase
            852695 - Preserve Formants, Mid/Side, Independent Phase
            852696 - Time Domain Smoothing
            852697 - Preserve Formants, Time Domain Smoothing
            852698 - Mid/Side, Time Domain Smoothing
            852699 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852700 - Independent Phase, Time Domain Smoothing
            852701 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852702 - Mid/Side, Independent Phase, Time Domain Smoothing
            852703 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Short
            852704 - nothing
            852705 - Preserve Formants
            852706 - Mid/Side
            852707 - Preserve Formants, Mid/Side
            852708 - Independent Phase
            852709 - Preserve Formants, Independent Phase
            852710 - Mid/Side, Independent Phase
            852711 - Preserve Formants, Mid/Side, Independent Phase
            852712 - Time Domain Smoothing
            852713 - Preserve Formants, Time Domain Smoothing
            852714 - Mid/Side, Time Domain Smoothing
            852715 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852716 - Independent Phase, Time Domain Smoothing
            852717 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852718 - Mid/Side, Independent Phase, Time Domain Smoothing
            852719 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Short
            852720 - nothing
            852721 - Preserve Formants
            852722 - Mid/Side
            852723 - Preserve Formants, Mid/Side
            852724 - Independent Phase
            852725 - Preserve Formants, Independent Phase
            852726 - Mid/Side, Independent Phase
            852727 - Preserve Formants, Mid/Side, Independent Phase
            852728 - Time Domain Smoothing
            852729 - Preserve Formants, Time Domain Smoothing
            852730 - Mid/Side, Time Domain Smoothing
            852731 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852732 - Independent Phase, Time Domain Smoothing
            852733 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852734 - Mid/Side, Independent Phase, Time Domain Smoothing
            852735 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852736 - nothing
            852737 - Preserve Formants
            852738 - Mid/Side
            852739 - Preserve Formants, Mid/Side
            852740 - Independent Phase
            852741 - Preserve Formants, Independent Phase
            852742 - Mid/Side, Independent Phase
            852743 - Preserve Formants, Mid/Side, Independent Phase
            852744 - Time Domain Smoothing
            852745 - Preserve Formants, Time Domain Smoothing
            852746 - Mid/Side, Time Domain Smoothing
            852747 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852748 - Independent Phase, Time Domain Smoothing
            852749 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852750 - Mid/Side, Independent Phase, Time Domain Smoothing
            852751 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852752 - nothing
            852753 - Preserve Formants
            852754 - Mid/Side
            852755 - Preserve Formants, Mid/Side
            852756 - Independent Phase
            852757 - Preserve Formants, Independent Phase
            852758 - Mid/Side, Independent Phase
            852759 - Preserve Formants, Mid/Side, Independent Phase
            852760 - Time Domain Smoothing
            852761 - Preserve Formants, Time Domain Smoothing
            852762 - Mid/Side, Time Domain Smoothing
            852763 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852764 - Independent Phase, Time Domain Smoothing
            852765 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852766 - Mid/Side, Independent Phase, Time Domain Smoothing
            852767 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852768 - nothing
            852769 - Preserve Formants
            852770 - Mid/Side
            852771 - Preserve Formants, Mid/Side
            852772 - Independent Phase
            852773 - Preserve Formants, Independent Phase
            852774 - Mid/Side, Independent Phase
            852775 - Preserve Formants, Mid/Side, Independent Phase
            852776 - Time Domain Smoothing
            852777 - Preserve Formants, Time Domain Smoothing
            852778 - Mid/Side, Time Domain Smoothing
            852779 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852780 - Independent Phase, Time Domain Smoothing
            852781 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852782 - Mid/Side, Independent Phase, Time Domain Smoothing
            852783 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Short
            852784 - nothing
            852785 - Preserve Formants
            852786 - Mid/Side
            852787 - Preserve Formants, Mid/Side
            852788 - Independent Phase
            852789 - Preserve Formants, Independent Phase
            852790 - Mid/Side, Independent Phase
            852791 - Preserve Formants, Mid/Side, Independent Phase
            852792 - Time Domain Smoothing
            852793 - Preserve Formants, Time Domain Smoothing
            852794 - Mid/Side, Time Domain Smoothing
            852795 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852796 - Independent Phase, Time Domain Smoothing
            852797 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852798 - Mid/Side, Independent Phase, Time Domain Smoothing
            852799 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852800 - nothing
            852801 - Preserve Formants
            852802 - Mid/Side
            852803 - Preserve Formants, Mid/Side
            852804 - Independent Phase
            852805 - Preserve Formants, Independent Phase
            852806 - Mid/Side, Independent Phase
            852807 - Preserve Formants, Mid/Side, Independent Phase
            852808 - Time Domain Smoothing
            852809 - Preserve Formants, Time Domain Smoothing
            852810 - Mid/Side, Time Domain Smoothing
            852811 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852812 - Independent Phase, Time Domain Smoothing
            852813 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852814 - Mid/Side, Independent Phase, Time Domain Smoothing
            852815 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852816 - nothing
            852817 - Preserve Formants
            852818 - Mid/Side
            852819 - Preserve Formants, Mid/Side
            852820 - Independent Phase
            852821 - Preserve Formants, Independent Phase
            852822 - Mid/Side, Independent Phase
            852823 - Preserve Formants, Mid/Side, Independent Phase
            852824 - Time Domain Smoothing
            852825 - Preserve Formants, Time Domain Smoothing
            852826 - Mid/Side, Time Domain Smoothing
            852827 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852828 - Independent Phase, Time Domain Smoothing
            852829 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852830 - Mid/Side, Independent Phase, Time Domain Smoothing
            852831 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Long
            852832 - nothing
            852833 - Preserve Formants
            852834 - Mid/Side
            852835 - Preserve Formants, Mid/Side
            852836 - Independent Phase
            852837 - Preserve Formants, Independent Phase
            852838 - Mid/Side, Independent Phase
            852839 - Preserve Formants, Mid/Side, Independent Phase
            852840 - Time Domain Smoothing
            852841 - Preserve Formants, Time Domain Smoothing
            852842 - Mid/Side, Time Domain Smoothing
            852843 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852844 - Independent Phase, Time Domain Smoothing
            852845 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852846 - Mid/Side, Independent Phase, Time Domain Smoothing
            852847 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Long
            852848 - nothing
            852849 - Preserve Formants
            852850 - Mid/Side
            852851 - Preserve Formants, Mid/Side
            852852 - Independent Phase
            852853 - Preserve Formants, Independent Phase
            852854 - Mid/Side, Independent Phase
            852855 - Preserve Formants, Mid/Side, Independent Phase
            852856 - Time Domain Smoothing
            852857 - Preserve Formants, Time Domain Smoothing
            852858 - Mid/Side, Time Domain Smoothing
            852859 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852860 - Independent Phase, Time Domain Smoothing
            852861 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852862 - Mid/Side, Independent Phase, Time Domain Smoothing
            852863 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Long
            852864 - nothing
            852865 - Preserve Formants
            852866 - Mid/Side
            852867 - Preserve Formants, Mid/Side
            852868 - Independent Phase
            852869 - Preserve Formants, Independent Phase
            852870 - Mid/Side, Independent Phase
            852871 - Preserve Formants, Mid/Side, Independent Phase
            852872 - Time Domain Smoothing
            852873 - Preserve Formants, Time Domain Smoothing
            852874 - Mid/Side, Time Domain Smoothing
            852875 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852876 - Independent Phase, Time Domain Smoothing
            852877 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852878 - Mid/Side, Independent Phase, Time Domain Smoothing
            852879 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Long
            852880 - nothing
            852881 - Preserve Formants
            852882 - Mid/Side
            852883 - Preserve Formants, Mid/Side
            852884 - Independent Phase
            852885 - Preserve Formants, Independent Phase
            852886 - Mid/Side, Independent Phase
            852887 - Preserve Formants, Mid/Side, Independent Phase
            852888 - Time Domain Smoothing
            852889 - Preserve Formants, Time Domain Smoothing
            852890 - Mid/Side, Time Domain Smoothing
            852891 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852892 - Independent Phase, Time Domain Smoothing
            852893 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852894 - Mid/Side, Independent Phase, Time Domain Smoothing
            852895 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Long
            852896 - nothing
            852897 - Preserve Formants
            852898 - Mid/Side
            852899 - Preserve Formants, Mid/Side
            852900 - Independent Phase
            852901 - Preserve Formants, Independent Phase
            852902 - Mid/Side, Independent Phase
            852903 - Preserve Formants, Mid/Side, Independent Phase
            852904 - Time Domain Smoothing
            852905 - Preserve Formants, Time Domain Smoothing
            852906 - Mid/Side, Time Domain Smoothing
            852907 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852908 - Independent Phase, Time Domain Smoothing
            852909 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852910 - Mid/Side, Independent Phase, Time Domain Smoothing
            852911 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Long
            852912 - nothing
            852913 - Preserve Formants
            852914 - Mid/Side
            852915 - Preserve Formants, Mid/Side
            852916 - Independent Phase
            852917 - Preserve Formants, Independent Phase
            852918 - Mid/Side, Independent Phase
            852919 - Preserve Formants, Mid/Side, Independent Phase
            852920 - Time Domain Smoothing
            852921 - Preserve Formants, Time Domain Smoothing
            852922 - Mid/Side, Time Domain Smoothing
            852923 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852924 - Independent Phase, Time Domain Smoothing
            852925 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852926 - Mid/Side, Independent Phase, Time Domain Smoothing
            852927 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Long
            852928 - nothing
            852929 - Preserve Formants
            852930 - Mid/Side
            852931 - Preserve Formants, Mid/Side
            852932 - Independent Phase
            852933 - Preserve Formants, Independent Phase
            852934 - Mid/Side, Independent Phase
            852935 - Preserve Formants, Mid/Side, Independent Phase
            852936 - Time Domain Smoothing
            852937 - Preserve Formants, Time Domain Smoothing
            852938 - Mid/Side, Time Domain Smoothing
            852939 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852940 - Independent Phase, Time Domain Smoothing
            852941 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852942 - Mid/Side, Independent Phase, Time Domain Smoothing
            852943 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Long
            852944 - nothing
            852945 - Preserve Formants
            852946 - Mid/Side
            852947 - Preserve Formants, Mid/Side
            852948 - Independent Phase
            852949 - Preserve Formants, Independent Phase
            852950 - Mid/Side, Independent Phase
            852951 - Preserve Formants, Mid/Side, Independent Phase
            852952 - Time Domain Smoothing
            852953 - Preserve Formants, Time Domain Smoothing
            852954 - Mid/Side, Time Domain Smoothing
            852955 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852956 - Independent Phase, Time Domain Smoothing
            852957 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852958 - Mid/Side, Independent Phase, Time Domain Smoothing
            852959 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Long
            852960 - nothing
            852961 - Preserve Formants
            852962 - Mid/Side
            852963 - Preserve Formants, Mid/Side
            852964 - Independent Phase
            852965 - Preserve Formants, Independent Phase
            852966 - Mid/Side, Independent Phase
            852967 - Preserve Formants, Mid/Side, Independent Phase
            852968 - Time Domain Smoothing
            852969 - Preserve Formants, Time Domain Smoothing
            852970 - Mid/Side, Time Domain Smoothing
            852971 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852972 - Independent Phase, Time Domain Smoothing
            852973 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852974 - Mid/Side, Independent Phase, Time Domain Smoothing
            852975 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Long
            852976 - nothing
            852977 - Preserve Formants
            852978 - Mid/Side
            852979 - Preserve Formants, Mid/Side
            852980 - Independent Phase
            852981 - Preserve Formants, Independent Phase
            852982 - Mid/Side, Independent Phase
            852983 - Preserve Formants, Mid/Side, Independent Phase
            852984 - Time Domain Smoothing
            852985 - Preserve Formants, Time Domain Smoothing
            852986 - Mid/Side, Time Domain Smoothing
            852987 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852988 - Independent Phase, Time Domain Smoothing
            852989 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852990 - Mid/Side, Independent Phase, Time Domain Smoothing
            852991 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Long
            852992 - nothing
            852993 - Preserve Formants
            852994 - Mid/Side
            852995 - Preserve Formants, Mid/Side
            852996 - Independent Phase
            852997 - Preserve Formants, Independent Phase
            852998 - Mid/Side, Independent Phase
            852999 - Preserve Formants, Mid/Side, Independent Phase
            853000 - Time Domain Smoothing
            853001 - Preserve Formants, Time Domain Smoothing
            853002 - Mid/Side, Time Domain Smoothing
            853003 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853004 - Independent Phase, Time Domain Smoothing
            853005 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853006 - Mid/Side, Independent Phase, Time Domain Smoothing
            853007 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Long
            853008 - nothing
            853009 - Preserve Formants
            853010 - Mid/Side
            853011 - Preserve Formants, Mid/Side
            853012 - Independent Phase
            853013 - Preserve Formants, Independent Phase
            853014 - Mid/Side, Independent Phase
            853015 - Preserve Formants, Mid/Side, Independent Phase
            853016 - Time Domain Smoothing
            853017 - Preserve Formants, Time Domain Smoothing
            853018 - Mid/Side, Time Domain Smoothing
            853019 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853020 - Independent Phase, Time Domain Smoothing
            853021 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853022 - Mid/Side, Independent Phase, Time Domain Smoothing
            853023 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853024 - nothing
            853025 - Preserve Formants
            853026 - Mid/Side
            853027 - Preserve Formants, Mid/Side
            853028 - Independent Phase
            853029 - Preserve Formants, Independent Phase
            853030 - Mid/Side, Independent Phase
            853031 - Preserve Formants, Mid/Side, Independent Phase
            853032 - Time Domain Smoothing
            853033 - Preserve Formants, Time Domain Smoothing
            853034 - Mid/Side, Time Domain Smoothing
            853035 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853036 - Independent Phase, Time Domain Smoothing
            853037 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853038 - Mid/Side, Independent Phase, Time Domain Smoothing
            853039 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853040 - nothing
            853041 - Preserve Formants
            853042 - Mid/Side
            853043 - Preserve Formants, Mid/Side
            853044 - Independent Phase
            853045 - Preserve Formants, Independent Phase
            853046 - Mid/Side, Independent Phase
            853047 - Preserve Formants, Mid/Side, Independent Phase
            853048 - Time Domain Smoothing
            853049 - Preserve Formants, Time Domain Smoothing
            853050 - Mid/Side, Time Domain Smoothing
            853051 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853052 - Independent Phase, Time Domain Smoothing
            853053 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853054 - Mid/Side, Independent Phase, Time Domain Smoothing
            853055 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853056 - nothing
            853057 - Preserve Formants
            853058 - Mid/Side
            853059 - Preserve Formants, Mid/Side
            853060 - Independent Phase
            853061 - Preserve Formants, Independent Phase
            853062 - Mid/Side, Independent Phase
            853063 - Preserve Formants, Mid/Side, Independent Phase
            853064 - Time Domain Smoothing
            853065 - Preserve Formants, Time Domain Smoothing
            853066 - Mid/Side, Time Domain Smoothing
            853067 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853068 - Independent Phase, Time Domain Smoothing
            853069 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853070 - Mid/Side, Independent Phase, Time Domain Smoothing
            853071 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Long
            853072 - nothing
            853073 - Preserve Formants
            853074 - Mid/Side
            853075 - Preserve Formants, Mid/Side
            853076 - Independent Phase
            853077 - Preserve Formants, Independent Phase
            853078 - Mid/Side, Independent Phase
            853079 - Preserve Formants, Mid/Side, Independent Phase
            853080 - Time Domain Smoothing
            853081 - Preserve Formants, Time Domain Smoothing
            853082 - Mid/Side, Time Domain Smoothing
            853083 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853084 - Independent Phase, Time Domain Smoothing
            853085 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853086 - Mid/Side, Independent Phase, Time Domain Smoothing
            853087 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853088 - nothing
            853089 - Preserve Formants
            853090 - Mid/Side
            853091 - Preserve Formants, Mid/Side
            853092 - Independent Phase
            853093 - Preserve Formants, Independent Phase
            853094 - Mid/Side, Independent Phase
            853095 - Preserve Formants, Mid/Side, Independent Phase
            853096 - Time Domain Smoothing
            853097 - Preserve Formants, Time Domain Smoothing
            853098 - Mid/Side, Time Domain Smoothing
            853099 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853100 - Independent Phase, Time Domain Smoothing
            853101 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853102 - Mid/Side, Independent Phase, Time Domain Smoothing
            853103 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853104 - nothing
            853105 - Preserve Formants
            853106 - Mid/Side
            853107 - Preserve Formants, Mid/Side
            853108 - Independent Phase
            853109 - Preserve Formants, Independent Phase
            853110 - Mid/Side, Independent Phase
            853111 - Preserve Formants, Mid/Side, Independent Phase
            853112 - Time Domain Smoothing
            853113 - Preserve Formants, Time Domain Smoothing
            853114 - Mid/Side, Time Domain Smoothing
            853115 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853116 - Independent Phase, Time Domain Smoothing
            853117 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853118 - Mid/Side, Independent Phase, Time Domain Smoothing
            853119 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Long
            853120 - nothing
            853121 - Preserve Formants
            853122 - Mid/Side
            853123 - Preserve Formants, Mid/Side
            853124 - Independent Phase
            853125 - Preserve Formants, Independent Phase
            853126 - Mid/Side, Independent Phase
            853127 - Preserve Formants, Mid/Side, Independent Phase
            853128 - Time Domain Smoothing
            853129 - Preserve Formants, Time Domain Smoothing
            853130 - Mid/Side, Time Domain Smoothing
            853131 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853132 - Independent Phase, Time Domain Smoothing
            853133 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853134 - Mid/Side, Independent Phase, Time Domain Smoothing
            853135 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Long
            853136 - nothing
            853137 - Preserve Formants
            853138 - Mid/Side
            853139 - Preserve Formants, Mid/Side
            853140 - Independent Phase
            853141 - Preserve Formants, Independent Phase
            853142 - Mid/Side, Independent Phase
            853143 - Preserve Formants, Mid/Side, Independent Phase
            853144 - Time Domain Smoothing
            853145 - Preserve Formants, Time Domain Smoothing
            853146 - Mid/Side, Time Domain Smoothing
            853147 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853148 - Independent Phase, Time Domain Smoothing
            853149 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853150 - Mid/Side, Independent Phase, Time Domain Smoothing
            853151 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Long
            853152 - nothing
            853153 - Preserve Formants
            853154 - Mid/Side
            853155 - Preserve Formants, Mid/Side
            853156 - Independent Phase
            853157 - Preserve Formants, Independent Phase
            853158 - Mid/Side, Independent Phase
            853159 - Preserve Formants, Mid/Side, Independent Phase
            853160 - Time Domain Smoothing
            853161 - Preserve Formants, Time Domain Smoothing
            853162 - Mid/Side, Time Domain Smoothing
            853163 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853164 - Independent Phase, Time Domain Smoothing
            853165 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853166 - Mid/Side, Independent Phase, Time Domain Smoothing
            853167 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853168 - nothing
            853169 - Preserve Formants
            853170 - Mid/Side
            853171 - Preserve Formants, Mid/Side
            853172 - Independent Phase
            853173 - Preserve Formants, Independent Phase
            853174 - Mid/Side, Independent Phase
            853175 - Preserve Formants, Mid/Side, Independent Phase
            853176 - Time Domain Smoothing
            853177 - Preserve Formants, Time Domain Smoothing
            853178 - Mid/Side, Time Domain Smoothing
            853179 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853180 - Independent Phase, Time Domain Smoothing
            853181 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853182 - Mid/Side, Independent Phase, Time Domain Smoothing
            853183 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853184 - nothing
            853185 - Preserve Formants
            853186 - Mid/Side
            853187 - Preserve Formants, Mid/Side
            853188 - Independent Phase
            853189 - Preserve Formants, Independent Phase
            853190 - Mid/Side, Independent Phase
            853191 - Preserve Formants, Mid/Side, Independent Phase
            853192 - Time Domain Smoothing
            853193 - Preserve Formants, Time Domain Smoothing
            853194 - Mid/Side, Time Domain Smoothing
            853195 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853196 - Independent Phase, Time Domain Smoothing
            853197 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853198 - Mid/Side, Independent Phase, Time Domain Smoothing
            853199 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853200 - nothing
            853201 - Preserve Formants
            853202 - Mid/Side
            853203 - Preserve Formants, Mid/Side
            853204 - Independent Phase
            853205 - Preserve Formants, Independent Phase
            853206 - Mid/Side, Independent Phase
            853207 - Preserve Formants, Mid/Side, Independent Phase
            853208 - Time Domain Smoothing
            853209 - Preserve Formants, Time Domain Smoothing
            853210 - Mid/Side, Time Domain Smoothing
            853211 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853212 - Independent Phase, Time Domain Smoothing
            853213 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853214 - Mid/Side, Independent Phase, Time Domain Smoothing
            853215 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Long
            853216 - nothing
            853217 - Preserve Formants
            853218 - Mid/Side
            853219 - Preserve Formants, Mid/Side
            853220 - Independent Phase
            853221 - Preserve Formants, Independent Phase
            853222 - Mid/Side, Independent Phase
            853223 - Preserve Formants, Mid/Side, Independent Phase
            853224 - Time Domain Smoothing
            853225 - Preserve Formants, Time Domain Smoothing
            853226 - Mid/Side, Time Domain Smoothing
            853227 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853228 - Independent Phase, Time Domain Smoothing
            853229 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853230 - Mid/Side, Independent Phase, Time Domain Smoothing
            853231 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853232 - nothing
            853233 - Preserve Formants
            853234 - Mid/Side
            853235 - Preserve Formants, Mid/Side
            853236 - Independent Phase
            853237 - Preserve Formants, Independent Phase
            853238 - Mid/Side, Independent Phase
            853239 - Preserve Formants, Mid/Side, Independent Phase
            853240 - Time Domain Smoothing
            853241 - Preserve Formants, Time Domain Smoothing
            853242 - Mid/Side, Time Domain Smoothing
            853243 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853244 - Independent Phase, Time Domain Smoothing
            853245 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853246 - Mid/Side, Independent Phase, Time Domain Smoothing
            853247 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853248 - nothing
            853249 - Preserve Formants
            853250 - Mid/Side
            853251 - Preserve Formants, Mid/Side
            853252 - Independent Phase
            853253 - Preserve Formants, Independent Phase
            853254 - Mid/Side, Independent Phase
            853255 - Preserve Formants, Mid/Side, Independent Phase
            853256 - Time Domain Smoothing
            853257 - Preserve Formants, Time Domain Smoothing
            853258 - Mid/Side, Time Domain Smoothing
            853259 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853260 - Independent Phase, Time Domain Smoothing
            853261 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853262 - Mid/Side, Independent Phase, Time Domain Smoothing
            853263 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer def_pitch_mode_state - the default pitch mode    
    integer stretch_marker_mode - the stretch marker mode
                                - 0, Balanced
                                - 1, Tonal-optimized
                                - 2, Transient-optimized
                                - 3, No pre-echo reduction
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, default, pitch mode, pitch, stretch marker mode</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "DEFPITCHMODE", ProjectStateChunk, "GetProject_DefPitchMode")
end

--A,B=ultraschall.GetProject_DefPitchMode("c:\\pitchshifter.rpp")

function ultraschall.GetProject_TakeLane(projectfilename_with_path, ProjectStateChunk)
-- returns TakeLane state
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TakeLane</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer take_lane_state = ultraschall.GetProject_TakeLane(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the take-lane-state from an rpp-project-file or a ProjectStateChunk.
    
    It's the entry TAKELANE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer take_lane_state - take-lane-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, take, lane</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "TAKELANE", ProjectStateChunk, "GetProject_TakeLane")
end

--A=ultraschall.GetProject_TakeLane("c:\\tt.rpp")

function ultraschall.GetProject_SampleRate(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_SampleRate</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer sample_rate, integer project_sample_rate, integer force_tempo_time_sig = ultraschall.GetProject_SampleRate(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the take-lane-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    
    It's the entry SAMPLERATE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer sample_rate - Project Sample Rate in Hz
    integer project_sample_rate - Checkbox: Project Sample Rate
    integer force_tempo_time_sig - Checkbox: Force Project Tempo/Time Signature changes to occur on whole samples 
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, sample, rate, samplerate, tempo, time, signature</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "SAMPLERATE", ProjectStateChunk, "GetProject_SampleRate")
end

--A,AA,AAA=ultraschall.GetProject_SampleRate("c:\\tt.rpp")

function ultraschall.GetProject_TrackMixingDepth(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TrackMixingDepth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer track_mixing_depth = ultraschall.GetProject_TrackMixingDepth(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the track-mixing-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    It's the entry INTMIXMODE
    
    Returns -1 in case of error, nil if it's set to 64bit(default)!
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer track_mixing_depth - track mixing depth
    -nil - 64bit float (default)
    -1 - 32 bit float
    -2 - 39 bit integer
    -3 - 24 bit integer
    -4 - 16 bit integer
    -5 - 12 bit integer
    -6 - 8 bit integer
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, track, mixing, depth</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "INTMIXMODE", ProjectStateChunk, "GetProject_TrackMixingDepth")
end

--A=ultraschall.GetProject_TrackMixingDepth("c:\\tt.rpp")

function ultraschall.GetProject_TrackStateChunk(projectfilename_with_path, idx, deletetrackid, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string trackstatechunk = ultraschall.GetProject_TrackStateChunk(string projectfilename_with_path, integer idx, boolean deletetrackid, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns an RPPXML-trackstatechunk from an rpp-project-file or a ProjectStateChunk, with tracknumber idx. IDX is 1 for the first track in the project-file, 2 for the second, etc
    Returns -1 in case of error.
    
    Use <a href="#GetProject_NumberOfTracks">GetProject_NumberOfTracks</a> to get the number of tracks within an rpp-file.
    
    The returned trackstatechunk can be inserted into the current project with <a href="#InsertTrack_TrackStateChunk">InsertTrack_TrackStateChunk</a>.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    integer idx - the tracknumber you want to have
    boolean deletetrackid - deletes the trackID in the trackstate-chunk, to avoid possible conflicts within a project, where it shall be imported to
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string trackstatechunk - an RPP-XML-Trackstate-chunk, that can be used by functions like reaper.SetTrackStateChunk()
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, track, chunk, rppxml, trackstate, trackstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_TrackStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_TrackStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_TrackStateChunk","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_TrackStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end
  -- get the values and return them
  local trackstate
  -- count til you found the right track
  for i=1,idx do
    trackstate=ProjectStateChunk:match("<TRACK.-%c%s%s>%c")
    if trackstate==nil then break end
    ProjectStateChunk=ProjectStateChunk:match("<TRACK.-%c%s%s%s%s>%c(.*)")
  end
  -- delete trackid, if requested
  if deletetrackid==true and trackstate~=nil then trackstate="<TRACK\n"..trackstate:match("%c(.*)")
    if trackstate:match("TRACKID")~=nil then trackstate=trackstate:match("(.-%c)%s-TRACKID")..trackstate:match("TRACKID.-%c(.*)") end
  end
  if trackstate==nil then ultraschall.AddErrorMessage("GetProject_TrackStateChunk","idx", "No such track exists!", -5) return -1 end
  return trackstate
end

--A=ultraschall.GetProject_TrackStateChunk("c:\\tt.rpp",2,true)

function ultraschall.GetProject_NumberOfTracks(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_NumberOfTracks</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer number_of_tracks = ultraschall.GetProject_NumberOfTracks(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the number of tracks within an rpp-project-file or a GetProject_NumberOfTracks.
    Returns -1 in case of error.
    
    Note: Huge projectfiles with thousands of items may take some seconds to load.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer number_of_tracks - the number of tracks within an projectfile
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, track, count</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_NumberOfTracks","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_NumberOfTracks","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_NumberOfTracks","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_NumberOfTracks", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end
  
  -- count tracks and return the number
  local count=0
  for w in string.gmatch(ProjectStateChunk, "<TRACK.-%c") do
      count=count+1
  end
  return count
end

--A=ultraschall.GetProject_NumberOfTracks("C:\\testomania.rpp", GetProject_NumberOfTracks)



function ultraschall.GetProject_Selection(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Selection</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number start_selection, number end_selection, number start_selection2, number end_selection2 = ultraschall.GetProject_Selection(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the selection-range from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the entry SELECTION
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    number start_selection - start of the time-selection
    number end_selection - end of the time-selection
    number start_selection2 - start of the time-selection
    number end_selection2 - end of the time-selection
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, selection, projectstatechunk</tags>
</US_DocBloc>
]]
  local A,B=ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "SELECTION", ProjectStateChunk, "GetProject_Selection")
  local C,D=ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "SELECTION2", ProjectStateChunk, "GetProject_Selection")
  return A,B,C,D
end

function ultraschall.GetProject_RenderQueueDelay(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderQueueDelay</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean qdelay_checkstate, integer qdelay_seconds = ultraschall.GetProject_Selection(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the state of the checkbox Delay queued render to allow samples to load-checkbox and the length of the delay.
    
    It's the entry RENDER_QDELAY
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    boolean qdelay_checkstate - true, the checkbox is checked; false, it is unchecked
    integer qdelay_seconds - the length of the queued-render-delay in seconds
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, queue, delay, seconds, checkbox, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderQueueDelay","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderQueueDelay","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderQueueDelay","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderQueueDelay", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  local Delay=ProjectStateChunk:match("RENDER_QDELAY (.-)%c")
  if Delay==nil then 
    return false, 0
  else
    return true, tonumber(Delay)
  end
end

--A,B,C=ultraschall.GetProject_RenderQueueDelay("c:\\Ultraschall-Hackversion_3.2_US_beta_2_75\\QueuedRenders\\qrender_190426_010705_unkn.rpp", ProjectStateChunk)

function ultraschall.GetProject_QRenderOriginalProject(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_QRenderOriginalProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string qrender_originalproject_file = ultraschall.GetProject_QRenderOriginalProject(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the original-filename of a queue-render-projectfile. Will return empty string, if the queued-render-project hadn't been saved before it was added to the render-queue.
    
    It's the entry QUEUED_RENDER_ORIGINAL_FILENAME
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string qrender_originalproject_file - the original-projectfilename of the queue-render-project
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, queue, original projectfilename, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_QRenderOriginalProject","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_QRenderOriginalProject","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_QRenderOriginalProject","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_QRenderOriginalProject", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  local OriginalFilename=ProjectStateChunk:match("QUEUED_RENDER_ORIGINAL_FILENAME (.-)%c")
  if OriginalFilename==nil then 
    return ""
  else
    return OriginalFilename
  end
end

--A,B,C=ultraschall.GetProject_QRenderOriginalProject("c:\\Ultraschall-Hackversion_3.2_US_beta_2_75\\QueuedRenders\\qrender_190426_010153_internal project.RPP", ProjectStateChunk)

function ultraschall.GetProject_QRenderOutFiles(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_QRenderOutFiles</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer count_outfiles, table QRenderOutFilesList, table QRenderOutFilesListGuid, boolean AutoCloseWhenFinished, boolean AutoIncrementFilename, boolean SaveCopyToOutfile = ultraschall.GetProject_QRenderOutFiles(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the outfiles of the rendered files, stored in a queue-render-projectfile. This includes the path and files of the files, that will be rendered.
    
    It's the entry QUEUED_RENDER_OUTFILE
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer count_outfiles - the number of render-outfiles
    table QRenderOutFilesList - an array with all filenames-with-paths that the rendered files will have; 
                              - if the filename contains "-001" or higher, this represents a file for a rendered stem, otherwise it is the one for the master.
    table QRenderOutFilesListGuid - the guids of the rendered outfiles
    boolean AutoCloseWhenFinished - true, the render-dialog will be closed after render is finished; false, the render-dialog keeps open
    boolean AutoIncrementFilename - true, autoincrement filename if the file already exists; false, don't autoincrement filename
    boolean SaveCopyToOutfile - true, save a copy of the project as e.g. "outfile.wav.RPP"; false, don't save a copy of the project
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, queue, queuerender outfiles, auto close when finished, auto increment filename, save copy of outfile</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_QRenderOutFiles","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_QRenderOutFiles","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_QRenderOutFiles","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_QRenderOutFiles", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
--  print2(ProjectStateChunk)
  local QRenderOutFiles=ProjectStateChunk:match("(QUEUED_RENDER_OUTFILE .-)RIPPLE ")
  if QRenderOutFiles==nil then ultraschall.AddErrorMessage("GetProject_QRenderOutFiles", "projectfilename_with_path", "No entries found!", -5) return nil end
  local QRenderOutfiles=string.gsub(QRenderOutFiles, "QUEUED_RENDER_ORIGINAL_FILENAME.-\n", "")
  local count, QRenderOutfiles = ultraschall.CSV2IndividualLinesAsArray(QRenderOutfiles, "\n")
  local QRenderOutFilesList={}
  local QRenderOutFilesListGuid={}
  local AutoCloseWhenFinished, AutoIncrementFilename, SaveCopyToOutfile, checkboxes
  for i=1, count-1 do
    if i==1 then 
      QRenderOutFilesList[i], checkboxes, QRenderOutFilesListGuid[i] = QRenderOutfiles[i]:match(" \"(.-)\" (.-) (.-})")
    else
      QRenderOutFilesList[i], QRenderOutFilesListGuid[i] = QRenderOutfiles[i]:match(" \"(.-)\".-({.-})")
    end
  end
  if checkboxes&1~=0 then AutoCloseWhenFinished=true  else AutoCloseWhenFinished=false end
  if checkboxes&16~=0 then AutoIncrementFilename=true else AutoIncrementFilename=false end
  if checkboxes&65537~=0 then SaveCopyToOutfile=true  else SaveCopyToOutfile=false     end
  return count-1, QRenderOutFilesList, QRenderOutFilesListGuid, AutoCloseWhenFinished, AutoIncrementFilename, SaveCopyToOutfile
end

function ultraschall.GetProject_MetaDataStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MetaDataStateChunk</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>string MetaDataStateChunk = ultraschall.GetProject_MetaDataStateChunk(string ProjectStateChunk, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Metadata-StateChunk, that holds all Metadata-entries.

    It's the entry &lt;RENDER_METADATA ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the projectbay-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MetaDataStateChunk - the statechunk of the metadata
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, metadatastatechunk, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MetaDataStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MetaDataStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MetaDataStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MetaDataStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<RENDER_METADATA.-\n  >")
end



--- Set ---

function ultraschall.SetProject_RippleState(projectfilename_with_path, ripple_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RippleState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RippleState(string projectfilename_with_path, integer ripple_state, optional string ProjectStatechunk)</functioncall>
  <description>
    Sets the ripple-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer ripple_state - 0, no Ripple; 1, Ripple One Track; 2, Ripple All
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, ripple, all, one</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RippleState", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RippleState", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RippleState", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(ripple_state)~="integer" then ultraschall.AddErrorMessage("SetProject_RippleState", "ripple_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RippleState", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RIPPLE%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RIPPLE%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..ripple_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end


function ultraschall.SetProject_RenderQueueDelay(projectfilename_with_path, renderqdelay, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderQueueDelay</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderQueueDelay(string projectfilename_with_path, integer renderqdelay, optional string ProjectStatechunk)</functioncall>
  <description>
    Sets the render-queue-delay-time in an rpp-project-file or a ProjectStateChunk.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer renderqdelay - 0 and higher, sets the checkbox "Delay queued render to allow samples to load and the amount of time to wait in seconds
                         - nil, if you want to turn off render-queue-delay in the project/ProjectStateChunk
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render queue delay</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderQueueDelay", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderQueueDelay", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderQueueDelay", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if renderqdelay~=nil and math.type(renderqdelay)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderQueueDelay", "renderqdelay", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderQueueDelay", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart, FileEnd = ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_ADDTOPROJ.-%c).-(  RENDER_STEMS.*)")
  if renderqdelay==nil then 
    renderqdelay="" 
  else
    renderqdelay="  RENDER_QDELAY "..renderqdelay.."\n"
  end
  ProjectStateChunk=FileStart..renderqdelay..FileEnd

  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

--A=ultraschall.SetProject_RenderQueueDelay("c:\\Render-Queue-Documentation.RPP", nil, ProjectStateChunk)

function ultraschall.SetProject_Selection(projectfilename_with_path, starttime, endtime, starttime2, endtime2, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Selection</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_Selection(string projectfilename_with_path, number starttime, number endtime, number starttime2, number endtime2, optional string ProjectStatechunk)</functioncall>
  <description>
    Sets the ripple-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number starttime - start of the selection in seconds
    number endtime - end of the selection in seconds
    number starttime2 - start of the second selection in seconds
    number endtime2 - end of the second selection in seconds
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, ripple, all, one</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Selection", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Selection", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Selection", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(starttime)~="number" then ultraschall.AddErrorMessage("SetProject_Selection", "starttime", "Must be an integer", -4) return -1 end
  if type(endtime)~="number" then ultraschall.AddErrorMessage("SetProject_Selection", "endtime", "Must be an integer", -5) return -1 end
  if type(starttime2)~="number" then ultraschall.AddErrorMessage("SetProject_Selection", "starttime", "Must be an integer", -6) return -1 end
  if type(endtime2)~="number" then ultraschall.AddErrorMessage("SetProject_Selection", "endtime", "Must be an integer", -7) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Selection", "projectfilename_with_path", "No valid RPP-Projectfile!", -8) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-SELECTION%s).-%c")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-SELECTION2%s.-%c(.*)")
  
  ProjectStateChunk=FileStart..starttime.." "..endtime.."\n  SELECTION2 "..starttime2.." "..endtime2.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end


function ultraschall.SetProject_GroupOverride(projectfilename_with_path, group_override1, group_override2, group_override3, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_GroupOverride</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_GroupOverride(string projectfilename_with_path, integer group_override1, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the group-override-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer group_override1 - the group-override state
    integer group_override2 - the group-override state
    integer group_override3 - the group-override state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Files
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, group, override</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GroupOverride", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_GroupOverride", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GroupOverride", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(group_override1)~="integer" then ultraschall.AddErrorMessage("SetProject_GroupOverride", "group_override1", "Must be an integer", -4) return -1 end
  if math.type(group_override2)~="integer" then ultraschall.AddErrorMessage("SetProject_GroupOverride", "group_override2", "Must be an integer", -5) return -1 end
  if math.type(group_override3)~="integer" then ultraschall.AddErrorMessage("SetProject_GroupOverride", "group_override3", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GroupOverride", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-GROUPOVERRIDE%s).-%s.-%s.-%s.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-GROUPOVERRIDE%s.-%s.-%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..group_override1.." "..group_override2.." "..group_override3.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_AutoCrossFade(projectfilename_with_path, autocrossfade_state, ProjectStateChunk)
-- sets AutoCrossFade in a projectfilename_with_path
-- integer state
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_AutoCrossFade</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_AutoCrossFade(string projectfilename_with_path, integer autocrossfade_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the autocrossfade-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer autocrossfade_state - autocrossfade-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, autocrossfade, crossfade</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AutoCrossFade", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_AutoCrossFade", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AutoCrossFade", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(autocrossfade_state)~="integer" then ultraschall.AddErrorMessage("SetProject_AutoCrossFade", "autocrossfade_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AutoCrossFade", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-AUTOXFADE%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-AUTOXFADE%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..autocrossfade_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_EnvAttach(projectfilename_with_path, env_attach, ProjectStateChunk)
-- sets Enc Attach
-- integer state - 
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_EnvAttach</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_EnvAttach(string projectfilename_with_path, integer env_attach, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the env_attach-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer env_attach - env_attach-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, env, attach, envattach</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_EnvAttach", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_EnvAttach", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_EnvAttach", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(env_attach)~="integer" then ultraschall.AddErrorMessage("SetProject_EnvAttach", "env_attach", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_EnvAttach", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-ENVATTACH%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-ENVATTACH%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..env_attach.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end    
end

function ultraschall.SetProject_MixerUIFlags(projectfilename_with_path, state_bitfield1, state_bitfield2, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MixerUIFlags</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_MixerUIFlags(string projectfilename_with_path, integer state_bitfield1, integer state_bitfield2, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the Mixer-UI-state-flags in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer state_bitfield1 - folders, receives, etc 
    -             0 - Show tracks in folders, Auto arrange tracks in mixer
    -             1 - Show normal top level tracks
    -             2 - Show Folders
    -             4 - Group folders to left
    -             8 - Show tracks that have receives
    -             16 - Group tracks that have receives to left
    -             32 - don't show tracks that are in folder
    -             64 - No Autoarrange tracks in mixer
    -             128 - ?
    -             256 - ?
    
    integer state_bitfield2 - master-track, FX, Mixer
    -             0 - Master track in mixer
    -             1 - Don't show multiple rows of tracks, when size permits
    -             2 - Show maximum rows even when tracks would fit in less rows
    -             4 - Master Show on right side of mixer
    -             8 - ?
    -             16 - Show FX inserts when size permits
    -             32 - Show sends when size permits
    -             64 - Show tracks in mixer
    -             128 - Show FX parameters, when size permits
    -             256 - Don't show Master track in mixer
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, mixer, ui, flags, folders, tracks, master, fx, groups</tags>
</US_DocBloc>
]]         
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(state_bitfield1)~="integer" then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "state_bitfield1", "Must be an integer", -4) return -1 end
  if math.type(state_bitfield2)~="integer" then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "state_bitfield2", "Must be an integer", -5) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MixerUIFlags", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-MIXERUIFLAGS%s).-%s.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-MIXERUIFLAGS%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..tonumber(state_bitfield1).." "..tonumber(state_bitfield2).."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_PeakGain(projectfilename_with_path, peakgain_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_PeakGain</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_PeakGain(string projectfilename_with_path, number peakgain_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the peak-gain-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number peakgain_state - peak-gain-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, peak, gain, peakgain</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PeakGain", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_PeakGain", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PeakGain", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(peakgain_state)~="number" then ultraschall.AddErrorMessage("SetProject_PeakGain", "peakgain_state", "Must be a number", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PeakGain", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-PEAKGAIN%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-PEAKGAIN%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..peakgain_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_Feedback(projectfilename_with_path, feedback_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Feedback</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_Feedback(string projectfilename_with_path, integer feedback_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the feedback-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer feedback_state - feedback-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, feedback</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Feedback", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Feedback", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Feedback", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(feedback_state)~="integer" then ultraschall.AddErrorMessage("SetProject_Feedback", "feedback_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Feedback", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-FEEDBACK%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-FEEDBACK%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..feedback_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_PanLaw(projectfilename_with_path, panlaw_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_PanLaw</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_PanLaw(string projectfilename_with_path, number panlaw_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the panlaw-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number panlaw_state - state of the panlaw, as set in the project-settings->Advanced->Pan law/mode->Pan:law(db). 0.5(-6.02 db) to 1(default +0.0 db)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, pan, law, pan law</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanLaw", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_PanLaw", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanLaw", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(panlaw_state)~="number" then ultraschall.AddErrorMessage("SetProject_PanLaw", "state", "Must be a number", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanLaw", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-PANLAW%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-PANLAW%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..panlaw_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_ProjOffsets(projectfilename_with_path, start_time, start_measure, base_ruler_marking_off_this_measure, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_ProjOffsets</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_ProjOffsets(string projectfilename_with_path, number start_time, integer start_measure, integer base_ruler_marking_off_this_measure, optional ProjectStateChunk)</functioncall>
  <description>
    Sets the project-offset-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    
    The project-offset, as set in the ProjectSettings -> Project Time Start, Project start measure and Base Ruler Marking Off This Measure-checkbox
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number start_time - the project-start-time in seconds
    integer start_measure - the start-measure; starting with 0, unlike in the Project-Settings-window, where the 0 becomes 1 as startmeasure
    integer base_ruler_marking_off_this_measure - 0, checkbox unchecked; 1, checkbox checked
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, project, offset, start, starttime, measure</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(start_time)~="number" then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "start_time", "Must be a number", -4) return -1 end
  if math.type(start_measure)~="integer" then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "start_measure", "Must be an integer", -5) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ProjOffsets", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-PROJOFFS%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-PROJOFFS%s.-%c(.-<RECORD_CFG.*)")
  ProjectStateChunk=FileStart..start_time.." "..start_measure.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_MaxProjectLength(projectfilename_with_path, limit_project_length, projectlength_limit, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MaxProjectLength</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_MaxProjectLength(string projectfilename_with_path, integer limit_project_length, number projectlength_limit, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the max-project-length-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer limit_project_length - checkbox "Limit project length, stop playback/recording at:" - 0 off, 1 on
    number projectlength_limit - projectlength-limit in seconds
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, project, end, length, limit</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(limit_project_length)~="integer" then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "limit_project_length", "Must be an integer", -4) return -1 end
  if type(projectlength_limit)~="number" then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "projectlength_limit", "Must be a number", -5) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MaxProjectLength", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-MAXPROJLEN%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-MAXPROJLEN%s.-%c(.-<RECORD_CFG.*)")
  ProjectStateChunk=FileStart..limit_project_length.." "..projectlength_limit.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_Grid(projectfilename_with_path, gridstate1, gridstate2, gridstate3, gridstate4, gridstate5, gridstate6, gridstate7, gridstate8, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Grid</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_Grid(string projectfilename_with_path, integer gridstate1, integer gridstate2, number gridstate3, integer gridstate4, number gridstate5, integer gridstate6, integer gridstate7, number gridstate8, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the setproject-grid-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer gridstate1 - gridstate1
    integer gridstate2 - gridstate2
    number gridstate3 - gridstate3
    integer gridstate4 - gridstate4
    number gridstate5 - gridstate5
    integer gridstate6 - gridstate6
    integer gridstate7 - gridstate7
    number gridstate8 - gridstate8
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, grid</tags>
</US_DocBloc>
]]

  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Grid", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Grid", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Grid", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(gridstate1)~="integer" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate1", "Must be an integer", -4) return -1 end
  if math.type(gridstate2)~="integer" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate2", "Must be an integer", -5) return -1 end
  if type(gridstate3)~="number" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate3", "Must be an integer", -6) return -1 end  
  if math.type(gridstate4)~="integer" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate4", "Must be an integer", -7) return -1 end
  if type(gridstate5)~="number" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate5", "Must be an integer", -8) return -1 end  
  if math.type(gridstate6)~="integer" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate6", "Must be an integer", -9) return -1 end
  if math.type(gridstate7)~="integer" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate7", "Must be an integer", -10) return -1 end
  if type(gridstate8)~="number" then ultraschall.AddErrorMessage("SetProject_Grid", "gridstate8", "Must be an integer", -11) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Grid", "projectfilename_with_path", "No valid RPP-Projectfile!", -12) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-GRID%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-GRID%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..gridstate1.." "..gridstate2.." "..gridstate3.." "..gridstate4.." "..gridstate5.." "..gridstate6.." "..gridstate7.." "..gridstate8.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end



function ultraschall.SetProject_Timemode(projectfilename_with_path, timemode1, timemode2, showntime, timemode4, timemode5, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Timemode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_Timemode(string projectfilename_with_path, integer timemode1, integer timemode2, integer showntime, integer timemode4, integer timemode5, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the timemode-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer ruler_timemode - ruler-timemode-state
      - -1, Use ruler time unit
      -  0, Minutes:Seconds
      -  1, Measures.Beats / Minutes:Seconds
      -  2, Measures.Beats
      -  3, Seconds
      -  4, Samples
      -  5, Hours:Minutes:Seconds:Frames
      -  8, Absolute Frames
    integer timemode2 - timemode-state
    integer showntime - Transport shown time
    -              -1 - use ruler time unit
    -              0 - minutes:seconds
    -              1 - measures:beats/minutes:seconds
    -              2 - measures:beats
    -              3 - seconds
    -              4 - samples
    -              5 - hours:minutes:seconds:frames
    -              8 - absolute frames
    integer timemode4 - timemode-state
    integer timemode5 - timemode-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, timemode</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Timemode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Timemode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Timemode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(timemode1)~="integer" then ultraschall.AddErrorMessage("SetProject_Timemode", "timemode1", "Must be an integer", -4) return -1 end
  if math.type(timemode2)~="integer" then ultraschall.AddErrorMessage("SetProject_Timemode", "timemode2", "Must be an integer", -5) return -1 end
  if math.type(showntime)~="integer" then ultraschall.AddErrorMessage("SetProject_Timemode", "showntime", "Must be an integer", -6) return -1 end
  if math.type(timemode4)~="integer" then ultraschall.AddErrorMessage("SetProject_Timemode", "timemode4", "Must be an integer", -7) return -1 end
  if math.type(timemode5)~="integer" then ultraschall.AddErrorMessage("SetProject_Timemode", "timemode5", "Must be an integer", -8) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Timemode", "projectfilename_with_path", "No valid RPP-Projectfile!", -9) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-TIMEMODE%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-TIMEMODE%s.-%c(.-<RECORD_CFG.*)")
  ProjectStateChunk=FileStart..timemode1.." "..timemode2.." "..showntime.." "..timemode4.." "..timemode5.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end


function ultraschall.SetProject_VideoConfig(projectfilename_with_path, preferredVidSizeX, preferredVidSizeY, settingsBitfield, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_VideoConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_VideoConfig(string projectfilename_with_path, integer preferredVidSizeX, integer preferredVidSizeY, integer settingsBitfield, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the video-config-settings, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer preferredVidSizeX - preferred video size, x pixels
    integer preferredVidSizeY - preferred video size, y pixels
    integer settingsBitfield - settings
    -             0 - turned on/selected: use high quality filtering, preserve aspect ratio(letterbox) when resizing,
    -                                     Video colorspace set to Auto,
    -                                     Items in higher numbered tracks replace lower, as well as Video colorspace set to Auto
    -             1 - Video colorspace: I420/YV12
    -             2 - Video colorspace: YUV2
    -             3 - RGB
    -             256 - Items in lower numbered tracks replace higher
    -             512 - Always resize video sources to preferred video size
    -             1024 - Always resize output to preferred video size
    -             2048 - turn off "Use high quality filtering when resizing"
    -             4096 - turn off "preserve aspect ratio (letterbox) when resizing"
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, video, videoconfig</tags>
</US_DocBloc>
]]         
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VideoConfig", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_VideoConfig", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VideoConfig", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(preferredVidSizeX)~="integer" then ultraschall.AddErrorMessage("SetProject_VideoConfig", "preferredVidSizeX", "Must be an integer", -4) return -1 end
  if math.type(preferredVidSizeY)~="integer" then ultraschall.AddErrorMessage("SetProject_VideoConfig", "preferredVidSizeY", "Must be an integer", -5) return -1 end
  if math.type(settingsBitfield)~="integer"  then ultraschall.AddErrorMessage("SetProject_VideoConfig", "settingsBitfield", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VideoConfig", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-VIDEO_CONFIG%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-VIDEO_CONFIG%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..preferredVidSizeX.." "..preferredVidSizeY.." "..settingsBitfield.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end


function ultraschall.SetProject_PanMode(projectfilename_with_path, panmode_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_PanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_PanMode(string projectfilename_with_path, integer panmode_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the panmode-settings, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer panmode_state - panmode-state - ProjectSettings->Advanced->Pan law/mode->Pan mode
    -             0 reaper 3.x balance (deprecated)
    -             3 Stereo balance / mono pan (default)
    -             5 Stereo pan
    -             6 Dual Pan
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, panmode</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanMode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_PanMode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanMode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(panmode_state)~="integer" then ultraschall.AddErrorMessage("SetProject_PanMode", "panmode_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_PanMode", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-PANMODE%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-PANMODE%s.-%c(.-<RECORD_CFG.*)")
  if FileStart==nil or FileEnd==nil then 
    FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-)CURSOR.-<RECORD_CFG.*")
    FileEnd="  "..ProjectStateChunk:match("<REAPER_PROJECT.-(CURSOR.-<RECORD_CFG.*)")
    panmode_state="PANMODE "..panmode_state
  end
  
  ProjectStateChunk=FileStart..panmode_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_CursorPos(projectfilename_with_path, cursorpos, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_CursorPos</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_CursorPos(string projectfilename_with_path, number cursorpos, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the cursor-position in an rpp-project-file or a ProjectStateChunk
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number cursorpos - editcursorposition in seconds
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, cursor, position, cursorposition, editcursor, edit</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_CursorPos", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_CursorPos", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_CursorPos", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(cursorpos)~="integer" then ultraschall.AddErrorMessage("SetProject_CursorPos", "cursorpos", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_CursorPos", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-CURSOR%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-CURSOR%s.-%c(.-<RECORD_CFG.*)")
  ProjectStateChunk=FileStart..cursorpos.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_HorizontalZoom(projectfilename_with_path, hzoom, hzoomscrollpos, scrollbarfactor, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_HorizontalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_HorizontalZoom(string projectfilename_with_path, number hzoom, integer hzoomscrollpos, integer scrollbarfactor, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the horizontal-zoom in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number hzoom - HorizontalZoomfactor, 0.007 to 1000000
    integer hzoomscrollpos - horizontalscrollbarposition - 0 - 4294967296
    integer scrollbarfactor - 0 to 500837, counts up, when maximum hzoomscrollpos overflows
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, zoom, horizontal, scrollbar, factor</tags>
</US_DocBloc>
]]         
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(hzoom)~="number" then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "hzoom", "Must be a number", -4) return -1 end
  if math.type(hzoomscrollpos)~="integer" then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "hzoomscrollpos", "Must be an integer", -5) return -1 end
  if math.type(scrollbarfactor)~="integer" then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "scrollbarfactor", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_HorizontalZoom", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-ZOOM%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-ZOOM%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..hzoom.." "..hzoomscrollpos.." "..scrollbarfactor.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_VerticalZoom(projectfilename_with_path, vzoom, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_VerticalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_VerticalZoom(string projectfilename_with_path, integer vzoom, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the vertical-zoom from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer vzoom - vertical zoomfactor(0-40)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, zoom, vertical, scrollbar, factor</tags>
</US_DocBloc>
]]         
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VerticalZoom", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_VerticalZoom", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VerticalZoom", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(vzoom)~="integer" then ultraschall.AddErrorMessage("SetProject_VerticalZoom", "vzoom", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_VerticalZoom", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-VZOOMEX%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-VZOOMEX%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..vzoom.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_UseRecConfig(projectfilename_with_path, rec_cfg, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_UseRecConfig</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_UseRecConfig(string projectfilename_with_path, integer rec_cfg, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the UseRec-Config in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer rec_cfg - recording-cfg-state
    -              0 - Automatic .wav (recommended)
    -              1 - Custom (use ultraschall.GetProject_ApplyFXCFG to get recording_cfg_string)
    -              2 - Recording Format
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, rec, config</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_UseRecConfig", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_UseRecConfig", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_UseRecConfig", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(rec_cfg)~="integer" then ultraschall.AddErrorMessage("SetProject_UseRecConfig", "rec_cfg", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_UseRecConfig", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-USE_REC_CFG%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-USE_REC_CFG%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart..rec_cfg.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_RecMode(projectfilename_with_path, rec_mode, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RecMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RecMode(string projectfilename_with_path, integer rec_mode, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the recording-mode-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer rec_mode - recording mode
                    - 0, Autopunch/Selected Items
                    - 1, normal
                    - 2, Time Selection/Auto Punch
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, rec, mode</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecMode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RecMode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecMode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(rec_mode)~="integer" then ultraschall.AddErrorMessage("SetProject_RecMode", "rec_mode", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecMode", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RECMODE%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RECMODE%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..rec_mode.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_SMPTESync(projectfilename_with_path, smptesync_state1, smptesync_fps, smptesync_resyncdrift, smptesync_skipdropframes, smptesync_syncseek, smptesync_freewheel, smptesync_userinput, smptesync_offsettimecode, smptesync_stop_rec_drift, smptesync_state10, smptesync_stop_rec_lacktime, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_SMPTESync</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_SMPTESync(string projectfilename_with_path, integer smptesync_state1, number smptesync_fps, integer smptesync_resyncdrift, integer smptesync_skipdropframes, integer smptesync_syncseek, integer smptesync_freewheel, integer smptesync_userinput, number smptesync_offsettimecode, integer smptesync_stop_rec_drift, integer smptesync_state10, integer smptesync_stop_rec_lacktime, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the TimeCodeSyncronization-SMPTE-Config in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer smptesync_state1 - flag 
    -             0 - external timecode synchronization disabled
    -             1 - external timecode synchronization enabled
    -             4 - Start playback on valid timecode when stopped
    -             8 - turned off: display flashing notification window when waiting for sync for recording
    -             16 - playback off
    -             32 - recording off
    -             256 - MTC - 24/30fps MTC is 23.976/29.97ND works only with smptesync_userinput set to 4159
    -             512 - MTC - 24/30fps MTC is 24/30ND
    
    number smptesync_fps - framerate in fps
    integer smptesync_resyncdrift - "Re-synchronize if drift exceeds" in ms (0 = never)
    integer smptesync_skipdropframes - "skip/drop frames if drift exceeds" in ms(0 - never)
    integer smptesync_syncseek - "Synchronize by seeking ahead" in ms (default = 1000)
    integer smptesync_freewheel - "Freewheel on missing time code for up to" in ms(0 = forever)
    integer smptesync_userinput - User Input-flag
    -             0 - LTC: Input 1
    -             1 - LTC: Input 2
    -             4159 - MTC - All inputs - 24/30 fps MTC 23.976ND/29.97ND if project is ND
    -             4223 - SPP: All Inputs
    -             8192 - ASIO Positioning Protocol
    
    number smptesync_offsettimecode - Offset incoming timecode by in seconds
    integer smptesync_stop_rec_drift - "Stop recording if drift exceeds" in ms(0 = never)
    integer smptesync_state10 - smptesync-state
    integer smptesync_stop_rec_lacktime - "stop recording on lack of timecode after" in ms(0 = never)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, smpte, sync</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SMPTESync", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_SMPTESync", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SMPTESync", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(smptesync_state1)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_state1", "Must be an integer", -4) return -1 end
  if type(smptesync_fps)~="number" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_fps", "Must be an integer", -5) return -1 end
  if math.type(smptesync_resyncdrift)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_resyncdrift", "Must be an integer", -6) return -1 end
  if math.type(smptesync_skipdropframes)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_skipdropframes", "Must be an integer", -7) return -1 end
  if math.type(smptesync_syncseek)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_syncseek", "Must be an integer", -8) return -1 end
  if math.type(smptesync_freewheel)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_freewheel", "Must be an integer", -9) return -1 end
  if math.type(smptesync_userinput)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_userinput", "Must be an integer", -10) return -1 end
  if type(smptesync_offsettimecode)~="number" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_offsettimecode", "Must be an integer", -11) return -1 end
  if math.type(smptesync_stop_rec_drift)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_stop_rec_drift", "Must be an integer", -12) return -1 end
  if math.type(smptesync_state10)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_state10", "Must be an integer", -13) return -1 end
  if math.type(smptesync_stop_rec_lacktime)~="integer" then ultraschall.AddErrorMessage("SetProject_SMPTESync", "smptesync_stop_rec_lacktime", "Must be an integer", -14) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SMPTESync", "projectfilename_with_path", "No valid RPP-Projectfile!", -15) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-SMPTESYNC%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-SMPTESYNC%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart.." "..smptesync_state1.." "..smptesync_fps.." "..smptesync_resyncdrift.." "..smptesync_skipdropframes.." "..smptesync_syncseek.." "..smptesync_freewheel.." "..smptesync_userinput.." "..smptesync_offsettimecode.." "..smptesync_stop_rec_drift.." "..smptesync_state10.." "..smptesync_stop_rec_lacktime.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_Loop(projectfilename_with_path, loopbutton_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Loop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_Loop(string projectfilename_with_path, integer loopbutton_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the UseRec-Config in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer loop_mode - loopbutton-state, 0, off; 1, on
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, loop, button</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Loop", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Loop", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Loop", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(loopbutton_state)~="integer" then ultraschall.AddErrorMessage("SetProject_Loop", "loopbutton_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Loop", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-LOOP%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-LOOP%s.-%c(.-<RECORD_CFG.*)")

  ProjectStateChunk=FileStart..loopbutton_state.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_LoopGran(projectfilename_with_path, loopgran_state1, loopgran_state2, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_LoopGran</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_LoopGran(string projectfilename_with_path, integer loopgran_state1, number loopgran_state2, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the Loop-Gran-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer loopgran_state1 - loopgran_state1
    number loopgran_state2 - loopgran_state2
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, loop, gran</tags>
</US_DocBloc>
]]         
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_LoopGran", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_LoopGran", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_LoopGran", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(loopgran_state1)~="integer" then ultraschall.AddErrorMessage("SetProject_LoopGran", "loopgran_state1", "Must be an integer", -4) return -1 end
  if type(loopgran_state2)~="number" then ultraschall.AddErrorMessage("SetProject_LoopGran", "loopgran_state2", "Must be an integer", -5) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_LoopGran", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-LOOPGRAN%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-LOOPGRAN%s.-%c(.-<RECORD_CFG.*)")
  ProjectStateChunk=FileStart..loopgran_state1.." "..loopgran_state2.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_RecPath(projectfilename_with_path, prim_recpath, sec_recpath, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RecPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RecPath(string projectfilename_with_path, string prim_recpath, string sec_recpath, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the primary and secondary recording-paths in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    string prim_recpath - primary recording path
    string sec_recpath - secondary recording path
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, path, primary, secondary</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecPath", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RecPath", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecPath", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(prim_recpath)~="string" then ultraschall.AddErrorMessage("SetProject_RecPath", "prim_recpath", "Must be a string", -4) return -1 end
  if type(sec_recpath)~="string" then ultraschall.AddErrorMessage("SetProject_RecPath", "sec_recpath", "Must be a string", -5) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecPath", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RECORD_PATH%s).-%c.-<RECORD_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RECORD_PATH%s.-%c(.-<RECORD_CFG.*)")
  
  ProjectStateChunk=FileStart.."\""..prim_recpath.."\" \""..sec_recpath.."\"\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_RecordCFG(projectfilename_with_path, recording_cfg_string, ProjectStateChunk)
--To Do: Research
-- ProjectSettings->Media->Recording
-- recording-cfg-string

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RecordCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RecordCFG(string projectfilename_with_path, string recording_cfg_string, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the recording-configuration as encoded string in an RPP-Projectfile or a ProjectStateChunk, as set in ProjectSettings->Media->Recording.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    recording_cfg_string - the record-configuration as encoded string
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, configuration</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecordCFG", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RecordCFG", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecordCFG", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(recording_cfg_string)~="string" then ultraschall.AddErrorMessage("SetProject_RecordCFG", "recording_cfg_string", "Must be a string", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RecordCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RECORD_CFG%c%s*).-%c.-RENDER_FILE.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RECORD_CFG%c%s*.-(%c.-RENDER_FILE.*)")
  
  ProjectStateChunk=FileStart..recording_cfg_string..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end



function ultraschall.SetProject_RenderCFG(projectfilename_with_path, rendercfg_string, rendercfg_string2, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.04
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderCFG(string projectfilename_with_path, string rendercfg_string, string rendercfg_string2, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the primary and secondary render-configuration as encoded string in an RPP-Projectfile or a ProjectStateChunk, as set in Render-Settings
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    rendercfg_string - the render-configuration as encoded string
    rendercfg_string2 - the secondary render-configuration as encoded string; use "" or nil to not set it
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, configuration</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidProjectStateChunk(rendercfg_string2)==true then ProjectStateChunk=rendercfg_string2 rendercfg_string2="" end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderCFG", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderCFG", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderCFG", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(rendercfg_string)~="string" then ultraschall.AddErrorMessage("SetProject_RenderCFG", "rendercfg_string", "Must be an string", -4) return -1 end
  if rendercfg_string2~=nil and type(rendercfg_string2)~="string" then ultraschall.AddErrorMessage("SetProject_RenderCFG", "rendercfg_string2", "Must be an string", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  if rendercfg_string2==nil or rendercfg_string2=="" then rendercfg_string2="" else rendercfg_string2="    "..rendercfg_string2.."\n" end
  if rendercfg_string=="" then else rendercfg_string="    "..rendercfg_string.."\n" end
  
  local FileStart, FileEnd=ProjectStateChunk:match("(.-\n)  <RENDER_CFG.-\n(  LOCK.*)")
  local NewString=[[
  <RENDER_CFG
]]..rendercfg_string..[[
  >
  <RENDER_CFG2
]]..rendercfg_string2..[[
  >
]]
  
  ProjectStateChunk=FileStart..NewString..FileEnd
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
    else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_ApplyFXCFG(projectfilename_with_path, applyfx_cfg_string, ProjectStateChunk)
--To Do: Research
-- ProjectSettings->Media->Format for Apply FX, Glue, Freeze, etc
-- recording_cfg-string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_ApplyFXCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_ApplyFXCFG(string projectfilename_with_path, string applyfx_cfg_string, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the audioformat-configuration, for fx-appliance-operation, as an encoded string in an RPP-Projectfile or a ProjectStateChunk, as set in ProjectSettings->Media->Format for Apply FX, Glue, Freeze, etc
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    string applyfx_cfg_string - the file-format-configuration for fx-appliance as encoded string
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, fx, configuration</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ApplyFXCFG", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_ApplyFXCFG", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ApplyFXCFG", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(applyfx_cfg_string)~="string" then ultraschall.AddErrorMessage("SetProject_ApplyFXCFG", "applyfx_cfg_string", "Must be a string", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ApplyFXCFG", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-APPLYFX_CFG%c%s*).-%c.-RENDER_FILE.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-APPLYFX_CFG%c%s*.-(%c.-RENDER_FILE.*)")
  
  ProjectStateChunk=FileStart..applyfx_cfg_string..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_RenderFilename(projectfilename_with_path, renderfilename, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderFilename(string projectfilename_with_path, string renderfilename, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-filename in an rpp-projectfile or a ProjectStateChunk. Set to "", if you want to set a render-pattern with <a href="#SetProject_RenderPattern">SetProject_RenderPattern</a>.
    
    The rendername is influenced by the settings in the RENDER_PATTERN-entry in the RPP-file, see <a href="#SetProject_RenderPattern">SetProject_RenderPattern</a> to influence or remove the RENDER_PATTERN-entry(Removing RENDER_PATTERN may help when Reaper rendering it to the name given in parameter render_filename.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk insteadO
    string render_filename - the filename for rendering, check also <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, path, render filename, filename, render</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderFilename", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderFilename", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderFilename", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if type(renderfilename)~="string" then ultraschall.AddErrorMessage("SetProject_RenderFilename", "renderfilename", "Must be a string", -4) return -1 end

  local FileStart, FileEnd
  if ProjectStateChunk:match("\n  RENDER_FILE ")==nil then
    FileStart, FileEnd = ProjectStateChunk:match("(.-)(RENDER_1X.*)")
    ProjectStateChunk=FileStart.."RENDER_FILE \""..renderfilename.."\"\n  "..FileEnd
  else
    ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  RENDER_FILE.-%c", "\n  RENDER_FILE \""..renderfilename.."\"\n")
  end
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end


function ultraschall.SetProject_RenderFreqNChans(projectfilename_with_path, unknown, rendernum_chans, render_frequency, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderFreqNChans</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderFreqNChans(string projectfilename_with_path, integer unknown, integer rendernum_chans, integer render_frequency, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns an unknown number, the render-frequency and rendernumber of channels from an RPP-Projectfile or a ProjectStateChunk. 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer unknown - unknown number
    integer rendernum_chans - Number_Channels 0-seems default-project-settings(?), 1-Mono, 2-Stereo, ... up to 64 channels
    integer render_frequency - RenderFrequency -2147483647 to 2147483647, except 0, which seems to be default-project-settings-frequency
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, frequency, num channels, channels</tags>
</US_DocBloc>
]]           
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(unknown)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "unknown", "Must be an integer", -4) return -1 end
  if math.type(rendernum_chans)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "rendernum_chans", "Must be an integer", -5) return -1 end
  if math.type(render_frequency)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "render_frequency", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderFreqNChans", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_FMT%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_FMT%s.-%c(.-<RENDER_CFG.*)")
  ProjectStateChunk=FileStart..unknown.." "..rendernum_chans.." "..render_frequency.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_RenderSpeed(projectfilename_with_path, render_speed, ProjectStateChunk)
--    Rendering_Speed 0-Fullspeed Offline, 1-1x Offline, 
--                    2-Online Render, 3-Offline Render (Idle), 
--                    4-1x Offline Render (Idle)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderSpeed</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderSpeed(string projectfilename_with_path, integer render_speed, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets a rendering-speed in an RPP-Projectfile or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer render_speed - render_speed 
    -             0-Fullspeed Offline
    -             1-1x Offline
    -             2-Online Render
    -             3-Offline Render (Idle)
    -            4-1x Offline Render (Idle)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, speed</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderSpeed", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderSpeed", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderSpeed", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(render_speed)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderSpeed", "render_speed", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderSpeed", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_1X%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_1X%s.-%c(.-<RENDER_CFG.*)")
  ProjectStateChunk=FileStart..render_speed.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A=ultraschall.SetProject_RenderSpeed("c:\\tt.rpp",199)
--A=ultraschall.GetProject_RenderSpeed("c:\\tt.rpp",0)

function ultraschall.SetProject_RenderRange(projectfilename_with_path, bounds, time_start, time_end, tail, tail_length, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderRange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderRange(string projectfilename_with_path, integer bounds, number time_start, number time_end, integer tail, integer tail_length, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-range, render-timestart, render-timeend, render-tail and render-taillength in an RPP-Projectfile or a ProjectStateChunk. 
    To get RENDER_STEMS, refer <a href="#GetProject_RenderStems">GetProject_RenderStems</a>
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer bounds - the bounds of the project to be rendered
    -             0, Custom Time Range
    -             1, Entire Project
    -             2, Time Selection, 
    -             3, Project Regions
    -             4, Selected Media Items(in combination with RENDER_STEMS 32); to get RENDER_STEMS, refer GetProject_RenderStems
    -             5, Selected regions
    number time_start - TimeStart in milliseconds -2147483647 to 2147483647
    number time_end - TimeEnd in milliseconds 2147483647 to 2147483647
    integer tail - Tail on/off-flags for individual bounds
    -             0, tail off for all bounds
    -             1, custom time range -> tail on
    -             2, entire project -> tail on
    -             4, time selection -> tail on
    -             8, project regions -> tail on
    
    integer tail_length - TailLength in milliseconds, valuerange 0 - 2147483647
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, timestart, timeend, range, tail, bounds</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderRange", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderRange", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderRange", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(bounds)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderRange", "bounds", "Must be an integer", -4) return -1 end
  if type(time_start)~="number" then ultraschall.AddErrorMessage("SetProject_RenderRange", "time_start", "Must be a number", -5) return -1 end
  if type(time_end)~="number" then ultraschall.AddErrorMessage("SetProject_RenderRange", "time_end", "Must be a number", -6) return -1 end
  if math.type(tail)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderRange", "tail", "Must be an integer", -7) return -1 end
  if math.type(tail_length)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderRange", "tail_length", "Must be an integer", -8) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderRange", "projectfilename_with_path", "No valid RPP-Projectfile!", -9) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_RANGE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_RANGE%s.-%c(.-<RENDER_CFG.*)")
  ProjectStateChunk=FileStart..bounds.." "..time_start.." "..time_end.." "..tail.." "..tail_length.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.SetProject_RenderResample(projectfilename_with_path, resample_mode, playback_resample_mode, project_smplrate4mix_and_fx, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderResample</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderResample(string projectfilename_with_path, integer resample_mode, integer playback_resample_mode, integer project_smplrate4mix_and_fx, optional string ProjectStateChunk)</functioncall>
  <description>
    Resamplemode for a)Rendering and b)Playback as well as c)if both are combined from an RPP-Projectfile or a ProjectStateChunk. 
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer resample_mode - Resample_Mode 
    -             0-medium (64pt Sinc), 
    -             1-Low (Linear Interpolation), 
    -             2-Lowest (Point Sampling), 
    -             3-Good(192pt Sinc), 
    -             4-Better(384pt Sinc), 
    -             5-Fast (IIR + Linear Interpolation), 
    -             6-Fast (IIRx2 + Linear Interpolation), 
    -             7-Fast (16pt sinc) - Default, 
    -             8-HQ (512pt Sinc), 
    -             9-Extreme HQ (768pt HQ Sinc)
    integer playback_resample_mode - Playback Resample Mode (as set in the Project-Settings)
    -           0-medium (64pt Sinc), 
    -           1-Low (Linear Interpolation), 
    -           2-Lowest (Point Sampling), 
    -           3-Good(192pt Sinc), 
    -           4-Better(384pt Sinc), 
    -           5-Fast (IIR + Linear Interpolation), 
    -           6-Fast (IIRx2 + Linear Interpolation), 
    -           7-Fast (16pt sinc) - Default, 
    -           8-HQ (512pt Sinc), 
    -           9-Extreme HQ (768pt HQ Sinc)    
    integer project_smplrate4mix_and_fx - Use project sample rate for mixing and FX/synth processing-checkbox; 1, checked; 0, unchecked
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, resample, playback, mixing, fx, synth</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderResample", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderResample", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderResample", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(resample_mode)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderResample", "resample_mode", "Must be an integer", -4) return -1 end
  if math.type(playback_resample_mode)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderResample", "playback_resample_mode", "Must be an integer", -5) return -1 end
  if math.type(project_smplrate4mix_and_fx)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderResample", "project_smplrate4mix_and_fx", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderResample", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_RESAMPLE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_RESAMPLE%s.-%c(.-<RENDER_CFG.*)")
  ProjectStateChunk=FileStart..resample_mode.." "..playback_resample_mode.." "..project_smplrate4mix_and_fx.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_AddMediaToProjectAfterRender(projectfilename_with_path, addmedia_after_render_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_AddMediaToProjectAfterRender</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_AddMediaToProjectAfterRender(string projectfilename_with_path, integer state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets, if rendered media shall be added to the project afterwards as well as if likely silent files shall be rendered-state, from an RPP-Projectfile or a ProjectStateChunk.
    
    It's the state of the "Add rendered items to new tracks in project"- checkbox and "Do not render files that are likely silent"-checkbox, as set in the Render to file-dialog.
    
    It's the entry RENDER_ADDTOPROJ
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer state - the state of the "Add rendered items to new tracks in project"- checkbox and "Do not render files that are likely silent"-checkbox 
                  - &1, rendered media shall be added to the project afterwards; 0, don't add
                  - &2, don't render likely silent files; 0, render anyway
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, add, media, after, project</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AddMediaToProjectAfterRender", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_AddMediaToProjectAfterRender", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AddMediaToProjectAfterRender", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(addmedia_after_render_state)~="integer" then ultraschall.AddErrorMessage("SetProject_AddMediaToProjectAfterRender", "addmedia_after_render_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_AddMediaToProjectAfterRender", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_ADDTOPROJ%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_ADDTOPROJ%s.-%c(.-<RENDER_CFG.*)")
  
  ProjectStateChunk=FileStart..addmedia_after_render_state.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A=ultraschall.SetProject_AddMediaToProjectAfterRender("c:\\tt.rpp",9)
--A=ultraschall.GetProject_AddMediaToProjectAfterRender("c:\\tt.rpp",1)

function ultraschall.SetProject_RenderStems(projectfilename_with_path, render_stems, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderStems</slug>
  <requires>
    Ultraschall=5
    Reaper=7.16
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderStems(string projectfilename_with_path, integer render_stems, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-stems-state from an RPP-Projectfile or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer render_stems - the state of Render Stems
    - 0, Source Master Mix, 
    - 1, Source Master mix + stems, 
    - 3, Source Stems, selected tracks, 
    - &4, Multichannel Tracks to Multichannel Files, 
    - 8, Source Region Render Matrix, 
    - &16, Tracks with only Mono-Media to Mono Files,  
    - 32, Selected Media Items(in combination with RENDER_RANGE->Bounds->4, refer to <a href="#GetProject_RenderRange">GetProject_RenderRange</a> to get RENDER_RANGE)
    - 64, Selected media items via master
    - 128, Selected tracks via master
    - &256, Embed stretch markers/transient guides-checkbox 
    - &512, Embed metadata-checkbox
    - &1024, Embed Take markers
    - &2048, 2nd pass rendering
    - &8192, Render stems pre-fader
    - &16384, Only render channels that are sent to parent
    - &32768, (Preserve) Metadata-checkbox
    - &65536, (Preserve) Start offset-checkbox(only with Selected media items as source)
    - 4096, Razor edit areas
    - 4224, Razor edit areas via master
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, stems, multichannel</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderStems", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderStems", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderStems", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(render_stems)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderStems", "render_stems", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderStems", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_STEMS%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_STEMS%s.-%c(.-<RENDER_CFG.*)")

  ProjectStateChunk=FileStart..tonumber(render_stems).." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_RenderDitherState(projectfilename_with_path, renderdither_state, ProjectStateChunk)
-- returns the state of dithering of rendering
-- 0 - Dither Master Mix, 1 - Don't Dither Master Mix, 2 - Noise-shaping On Master Mix, 
-- 3 - Dither And Noiseshape Master Mix

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderDitherState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_RenderDitherState(string projectfilename_with_path, integer renderdither_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-dither-state from an RPP-Projectfile or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer renderdither_state - the state of render dithering
    - &1,   Dither Master mix
    - &2,   Noise shaping Master mix
    - &4,   Dither Stems
    - &8,   Noise shaping Stems
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, dither, state, master, noise shaping</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderDitherState", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderDitherState", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderDitherState", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(renderdither_state)~="integer" then ultraschall.AddErrorMessage("SetProject_RenderDitherState", "renderdither_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderDitherState", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_DITHER%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_DITHER%s.-%c(.-<RENDER_CFG.*)")
  
  ProjectStateChunk=FileStart..tonumber(renderdither_state).." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A=ultraschall.SetProject_RenderDitherState("c:\\tt.rpp",1)
--A=ultraschall.GetProject_RenderDitherState("c:\\tt.rpp",1)


function ultraschall.SetProject_TimeBase(projectfilename_with_path, timebase, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_TimeBase</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_TimeBase(string projectfilename_with_path, integer timebase, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the timebase, as set in the project-settings, in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer timebase - the timebase for items/envelopes/markers as set in the project settings
    -             0 - Time, 
    -             1 - Beats (position, length, rate), 
    -             2 - Beats (position only)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, timebase, time, beats, items, envelopes, markers</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TimeBase", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_TimeBase", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TimeBase", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(timebase)~="integer" then ultraschall.AddErrorMessage("SetProject_TimeBase", "timebase", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TimeBase", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-TIMELOCKMODE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-TIMELOCKMODE%s.-%c(.-<RENDER_CFG.*)")

  ProjectStateChunk=FileStart..timebase.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A=ultraschall.SetProject_TimeBase("c:\\tt.rpp", 9)
--A=ultraschall.GetProject_TimeBase("c:\\tt.rpp")

function ultraschall.SetProject_TempoTimeSignature(projectfilename_with_path, tempotimesignature, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_TempoTimeSignature</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_TempoTimeSignature(string projectfilename_with_path, integer tempotimesignature, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the timebase, as set in the project-settings, in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer tempotimesignature - the timebase for tempo/time-signature as set in the project settings
    -             0 - Time 
    -             1 - Beats
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, timebase, time, beats, tempo, signature</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TempoTimeSignature", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_TempoTimeSignature", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TempoTimeSignature", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(tempotimesignature)~="integer" then ultraschall.AddErrorMessage("SetProject_TempoTimeSignature", "tempotimesignature", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TempoTimeSignature", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-TEMPOENVLOCKMODE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-TEMPOENVLOCKMODE%s.-%c(.-<RENDER_CFG.*)")
  
  ProjectStateChunk=FileStart..tempotimesignature.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_ItemMixBehavior(projectfilename_with_path, item_mix_behav_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_ItemMixBehavior</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_ItemMixBehavior(string projectfilename_with_path, integer item_mix_behav_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the item mix behavior, as set in the project-settings, from an rpp-project-file.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path of the rpp-project-file
    integer item_mix_behav_state - item mix behavior
    -              0 - Enclosed items replace enclosing items 
    -              1 - Items always mix
    -              2 - Items always replace earlier items
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, item, mix</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ItemMixBehavior", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_ItemMixBehavior", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ItemMixBehavior", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(item_mix_behav_state)~="integer" then ultraschall.AddErrorMessage("SetProject_ItemMixBehavior", "item_mix_behav_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_ItemMixBehavior", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-ITEMMIX%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-ITEMMIX%s.-%c(.-<RENDER_CFG.*)")
  
  ProjectStateChunk=FileStart..item_mix_behav_state.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

    

function ultraschall.SetProject_DefPitchMode(projectfilename_with_path, def_pitch_mode_state, stretch_marker_mode, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_DefPitchMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_DefPitchMode(string projectfilename_with_path, integer def_pitch_mode_state, integer stretch_marker_mode, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the default-pitch-mode, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    
    def_pitch_mode_state can be 
    
        SoundTouch:
            0 - Default settings
            1 - High Quality
            2 - Fast

        Simple windowed (fast):
            131072 - 50ms window, 25ms fade
            131073 - 50ms window, 16ms fade
            131074 - 50ms window, 10ms fade
            131075 - 50ms window, 7ms fade
            131076 - 75ms window, 37ms fade
            131077 - 75ms window, 25ms fade
            131078 - 75ms window, 15ms fade
            131079 - 75ms window, 10ms fade
            131080 - 100ms window, 50ms fade
            131081 - 100ms window, 33ms fade
            131082 - 100ms window, 20ms fade
            131083 - 100ms window, 14ms fade
            131084 - 150ms window, 75ms fade
            131085 - 150ms window, 50ms fade
            131086 - 150ms window, 30ms fade
            131087 - 150ms window, 21ms fade
            131088 - 225ms window, 112ms fade
            131089 - 225ms window, 75ms fade
            131090 - 225ms window, 45ms fade
            131091 - 225ms window, 32ms fade
            131092 - 300ms window, 150ms fade
            131093 - 300ms window, 100ms fade
            131094 - 300ms window, 60ms fade
            131095 - 300ms window, 42ms fade
            131096 - 40ms window, 20ms fade
            131097 - 40ms window, 13ms fade
            131098 - 40ms window, 8ms fade
            131099 - 40ms window, 5ms fade
            131100 - 30ms window, 15ms fade
            131101 - 30ms window, 10ms fade
            131102 - 30ms window, 6ms fade
            131103 - 30ms window, 4ms fade
            131104 - 20ms window, 10ms fade
            131105 - 20ms window, 6ms fade
            131106 - 20ms window, 4ms fade
            131107 - 20ms window, 2ms fade
            131108 - 10ms window, 5ms fade
            131109 - 10ms window, 3ms fade
            131110 - 10ms window, 2ms fade
            131111 - 10ms window, 1ms fade
            131112 - 5ms window, 2ms fade
            131113 - 5ms window, 1ms fade
            131114 - 5ms window, 1ms fade
            131115 - 5ms window, 1ms fade
            131116 - 3ms window, 1ms fade
            131117 - 3ms window, 1ms fade
            131118 - 3ms window, 1ms fade
            131119 - 3ms window, 1ms fade

        Ã©lastique 2.2.8 Pro:
            393216 - Normal
            393217 - Preserve Formants (Lowest Pitches)
            393218 - Preserve Formants (Lower Pitches)
            393219 - Preserve Formants (Low Pitches)
            393220 - Preserve Formants (Most Pitches)
            393221 - Preserve Formants (High Pitches)
            393222 - Preserve Formants (Higher Pitches)
            393223 - Preserve Formants (Highest Pitches)
            393224 - Mid/Side
            393225 - Mid/Side, Preserve Formants (Lowest Pitches)
            393226 - Mid/Side, Preserve Formants (Lower Pitches)
            393227 - Mid/Side, Preserve Formants (Low Pitches)
            393228 - Mid/Side, Preserve Formants (Most Pitches)
            393229 - Mid/Side, Preserve Formants (High Pitches)
            393230 - Mid/Side, Preserve Formants (Higher Pitches)
            393231 - Mid/Side, Preserve Formants (Highest Pitches)
            393232 - Synchronized: Normal
            393233 - Synchronized: Preserve Formants (Lowest Pitches)
            393234 - Synchronized: Preserve Formants (Lower Pitches)
            393235 - Synchronized: Preserve Formants (Low Pitches)
            393236 - Synchronized: Preserve Formants (Most Pitches)
            393237 - Synchronized: Preserve Formants (High Pitches)
            393238 - Synchronized: Preserve Formants (Higher Pitches)
            393239 - Synchronized: Preserve Formants (Highest Pitches)
            393240 - Synchronized:  Mid/Side
            393241 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            393242 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            393243 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            393244 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            393245 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            393246 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            393247 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 2.2.8 Efficient:
            458752 - Normal
            458753 - Mid/Side
            458754 - Synchronized: Normal
            458755 - Synchronized: Mid/Side

        Ã©lastique 2.2.8 Soloist:
            524288 - Monophonic
            524289 - Monophonic [Mid/Side]
            524290 - Speech
            524291 - Speech [Mid/Side]

        Ã©lastique 3.3.0 Pro:
            589824 - Normal
            589825 - Preserve Formants (Lowest Pitches)
            589826 - Preserve Formants (Lower Pitches)
            589827 - Preserve Formants (Low Pitches)
            589828 - Preserve Formants (Most Pitches)
            589829 - Preserve Formants (High Pitches)
            589830 - Preserve Formants (Higher Pitches)
            589831 - Preserve Formants (Highest Pitches)
            589832 - Mid/Side
            589833 - Mid/Side, Preserve Formants (Lowest Pitches)
            589834 - Mid/Side, Preserve Formants (Lower Pitches)
            589835 - Mid/Side, Preserve Formants (Low Pitches)
            589836 - Mid/Side, Preserve Formants (Most Pitches)
            589837 - Mid/Side, Preserve Formants (High Pitches)
            589838 - Mid/Side, Preserve Formants (Higher Pitches)
            589839 - Mid/Side, Preserve Formants (Highest Pitches)
            589840 - Synchronized: Normal
            589841 - Synchronized: Preserve Formants (Lowest Pitches)
            589842 - Synchronized: Preserve Formants (Lower Pitches)
            589843 - Synchronized: Preserve Formants (Low Pitches)
            589844 - Synchronized: Preserve Formants (Most Pitches)
            589845 - Synchronized: Preserve Formants (High Pitches)
            589846 - Synchronized: Preserve Formants (Higher Pitches)
            589847 - Synchronized: Preserve Formants (Highest Pitches)
            589848 - Synchronized:  Mid/Side
            589849 - Synchronized:  Mid/Side, Preserve Formants (Lowest Pitches)
            589850 - Synchronized:  Mid/Side, Preserve Formants (Lower Pitches)
            589851 - Synchronized:  Mid/Side, Preserve Formants (Low Pitches)
            589852 - Synchronized:  Mid/Side, Preserve Formants (Most Pitches)
            589853 - Synchronized:  Mid/Side, Preserve Formants (High Pitches)
            589854 - Synchronized:  Mid/Side, Preserve Formants (Higher Pitches)
            589855 - Synchronized:  Mid/Side, Preserve Formants (Highest Pitches)

        Ã©lastique 3.3.0 Efficient:
            655360 - Normal
            655361 - Mid/Side
            655362 - Synchronized: Normal
            655363 - Synchronized: Mid/Side

        Ã©lastique 3.3.0 Soloist:
            720896 - Monophonic
            720897 - Monophonic [Mid/Side]
            720898 - Speech
            720899 - Speech [Mid/Side]


        Rubber Band Library - Default
            851968 - nothing

        Rubber Band Library - Preserve Formants
            851969 - Preserve Formants

        Rubber Band Library - Mid/Side
            851970 - Mid/Side

        Rubber Band Library - Preserve Formants, Mid/Side
            851971 - Preserve Formants, Mid/Side

        Rubber Band Library - Independent Phase
            851972 - Independent Phase

        Rubber Band Library - Preserve Formants, Independent Phase
            851973 - Preserve Formants, Independent Phase

        Rubber Band Library - Mid/Side, Independent Phase
            851974 - Mid/Side, Independent Phase

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase
            851975 - Preserve Formants, Mid/Side, Independent Phase

        Rubber Band Library - Time Domain Smoothing
            851976 - Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Time Domain Smoothing
            851977 - Preserve Formants, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Time Domain Smoothing
            851978 - Mid/Side, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Time Domain Smoothing
            851979 - Preserve Formants, Mid/Side, Time Domain Smoothing

        Rubber Band Library - Independent Phase, Time Domain Smoothing
            851980 - Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Independent Phase, Time Domain Smoothing
            851981 - Preserve Formants, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Mid/Side, Independent Phase, Time Domain Smoothing
            851982 - Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing
            851983 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed
            851984 - nothing
            851985 - Preserve Formants
            851986 - Mid/Side
            851987 - Preserve Formants, Mid/Side
            851988 - Independent Phase
            851989 - Preserve Formants, Independent Phase
            851990 - Mid/Side, Independent Phase
            851991 - Preserve Formants, Mid/Side, Independent Phase
            851992 - Time Domain Smoothing
            851993 - Preserve Formants, Time Domain Smoothing
            851994 - Mid/Side, Time Domain Smoothing
            851995 - Preserve Formants, Mid/Side, Time Domain Smoothing
            851996 - Independent Phase, Time Domain Smoothing
            851997 - Preserve Formants, Independent Phase, Time Domain Smoothing
            851998 - Mid/Side, Independent Phase, Time Domain Smoothing
            851999 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth
            852000 - nothing
            852001 - Preserve Formants
            852002 - Mid/Side
            852003 - Preserve Formants, Mid/Side
            852004 - Independent Phase
            852005 - Preserve Formants, Independent Phase
            852006 - Mid/Side, Independent Phase
            852007 - Preserve Formants, Mid/Side, Independent Phase
            852008 - Time Domain Smoothing
            852009 - Preserve Formants, Time Domain Smoothing
            852010 - Mid/Side, Time Domain Smoothing
            852011 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852012 - Independent Phase, Time Domain Smoothing
            852013 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852014 - Mid/Side, Independent Phase, Time Domain Smoothing
            852015 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive
            852016 - nothing
            852017 - Preserve Formants
            852018 - Mid/Side
            852019 - Preserve Formants, Mid/Side
            852020 - Independent Phase
            852021 - Preserve Formants, Independent Phase
            852022 - Mid/Side, Independent Phase
            852023 - Preserve Formants, Mid/Side, Independent Phase
            852024 - Time Domain Smoothing
            852025 - Preserve Formants, Time Domain Smoothing
            852026 - Mid/Side, Time Domain Smoothing
            852027 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852028 - Independent Phase, Time Domain Smoothing
            852029 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852030 - Mid/Side, Independent Phase, Time Domain Smoothing
            852031 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive
            852032 - nothing
            852033 - Preserve Formants
            852034 - Mid/Side
            852035 - Preserve Formants, Mid/Side
            852036 - Independent Phase
            852037 - Preserve Formants, Independent Phase
            852038 - Mid/Side, Independent Phase
            852039 - Preserve Formants, Mid/Side, Independent Phase
            852040 - Time Domain Smoothing
            852041 - Preserve Formants, Time Domain Smoothing
            852042 - Mid/Side, Time Domain Smoothing
            852043 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852044 - Independent Phase, Time Domain Smoothing
            852045 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852046 - Mid/Side, Independent Phase, Time Domain Smoothing
            852047 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive
            852048 - nothing
            852049 - Preserve Formants
            852050 - Mid/Side
            852051 - Preserve Formants, Mid/Side
            852052 - Independent Phase
            852053 - Preserve Formants, Independent Phase
            852054 - Mid/Side, Independent Phase
            852055 - Preserve Formants, Mid/Side, Independent Phase
            852056 - Time Domain Smoothing
            852057 - Preserve Formants, Time Domain Smoothing
            852058 - Mid/Side, Time Domain Smoothing
            852059 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852060 - Independent Phase, Time Domain Smoothing
            852061 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852062 - Mid/Side, Independent Phase, Time Domain Smoothing
            852063 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft
            852064 - nothing
            852065 - Preserve Formants
            852066 - Mid/Side
            852067 - Preserve Formants, Mid/Side
            852068 - Independent Phase
            852069 - Preserve Formants, Independent Phase
            852070 - Mid/Side, Independent Phase
            852071 - Preserve Formants, Mid/Side, Independent Phase
            852072 - Time Domain Smoothing
            852073 - Preserve Formants, Time Domain Smoothing
            852074 - Mid/Side, Time Domain Smoothing
            852075 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852076 - Independent Phase, Time Domain Smoothing
            852077 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852078 - Mid/Side, Independent Phase, Time Domain Smoothing
            852079 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft
            852080 - nothing
            852081 - Preserve Formants
            852082 - Mid/Side
            852083 - Preserve Formants, Mid/Side
            852084 - Independent Phase
            852085 - Preserve Formants, Independent Phase
            852086 - Mid/Side, Independent Phase
            852087 - Preserve Formants, Mid/Side, Independent Phase
            852088 - Time Domain Smoothing
            852089 - Preserve Formants, Time Domain Smoothing
            852090 - Mid/Side, Time Domain Smoothing
            852091 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852092 - Independent Phase, Time Domain Smoothing
            852093 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852094 - Mid/Side, Independent Phase, Time Domain Smoothing
            852095 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft
            852096 - nothing
            852097 - Preserve Formants
            852098 - Mid/Side
            852099 - Preserve Formants, Mid/Side
            852100 - Independent Phase
            852101 - Preserve Formants, Independent Phase
            852102 - Mid/Side, Independent Phase
            852103 - Preserve Formants, Mid/Side, Independent Phase
            852104 - Time Domain Smoothing
            852105 - Preserve Formants, Time Domain Smoothing
            852106 - Mid/Side, Time Domain Smoothing
            852107 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852108 - Independent Phase, Time Domain Smoothing
            852109 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852110 - Mid/Side, Independent Phase, Time Domain Smoothing
            852111 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ
            852112 - nothing
            852113 - Preserve Formants
            852114 - Mid/Side
            852115 - Preserve Formants, Mid/Side
            852116 - Independent Phase
            852117 - Preserve Formants, Independent Phase
            852118 - Mid/Side, Independent Phase
            852119 - Preserve Formants, Mid/Side, Independent Phase
            852120 - Time Domain Smoothing
            852121 - Preserve Formants, Time Domain Smoothing
            852122 - Mid/Side, Time Domain Smoothing
            852123 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852124 - Independent Phase, Time Domain Smoothing
            852125 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852126 - Mid/Side, Independent Phase, Time Domain Smoothing
            852127 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ
            852128 - nothing
            852129 - Preserve Formants
            852130 - Mid/Side
            852131 - Preserve Formants, Mid/Side
            852132 - Independent Phase
            852133 - Preserve Formants, Independent Phase
            852134 - Mid/Side, Independent Phase
            852135 - Preserve Formants, Mid/Side, Independent Phase
            852136 - Time Domain Smoothing
            852137 - Preserve Formants, Time Domain Smoothing
            852138 - Mid/Side, Time Domain Smoothing
            852139 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852140 - Independent Phase, Time Domain Smoothing
            852141 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852142 - Mid/Side, Independent Phase, Time Domain Smoothing
            852143 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ
            852144 - nothing
            852145 - Preserve Formants
            852146 - Mid/Side
            852147 - Preserve Formants, Mid/Side
            852148 - Independent Phase
            852149 - Preserve Formants, Independent Phase
            852150 - Mid/Side, Independent Phase
            852151 - Preserve Formants, Mid/Side, Independent Phase
            852152 - Time Domain Smoothing
            852153 - Preserve Formants, Time Domain Smoothing
            852154 - Mid/Side, Time Domain Smoothing
            852155 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852156 - Independent Phase, Time Domain Smoothing
            852157 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852158 - Mid/Side, Independent Phase, Time Domain Smoothing
            852159 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ
            852160 - nothing
            852161 - Preserve Formants
            852162 - Mid/Side
            852163 - Preserve Formants, Mid/Side
            852164 - Independent Phase
            852165 - Preserve Formants, Independent Phase
            852166 - Mid/Side, Independent Phase
            852167 - Preserve Formants, Mid/Side, Independent Phase
            852168 - Time Domain Smoothing
            852169 - Preserve Formants, Time Domain Smoothing
            852170 - Mid/Side, Time Domain Smoothing
            852171 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852172 - Independent Phase, Time Domain Smoothing
            852173 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852174 - Mid/Side, Independent Phase, Time Domain Smoothing
            852175 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ
            852176 - nothing
            852177 - Preserve Formants
            852178 - Mid/Side
            852179 - Preserve Formants, Mid/Side
            852180 - Independent Phase
            852181 - Preserve Formants, Independent Phase
            852182 - Mid/Side, Independent Phase
            852183 - Preserve Formants, Mid/Side, Independent Phase
            852184 - Time Domain Smoothing
            852185 - Preserve Formants, Time Domain Smoothing
            852186 - Mid/Side, Time Domain Smoothing
            852187 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852188 - Independent Phase, Time Domain Smoothing
            852189 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852190 - Mid/Side, Independent Phase, Time Domain Smoothing
            852191 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ
            852192 - nothing
            852193 - Preserve Formants
            852194 - Mid/Side
            852195 - Preserve Formants, Mid/Side
            852196 - Independent Phase
            852197 - Preserve Formants, Independent Phase
            852198 - Mid/Side, Independent Phase
            852199 - Preserve Formants, Mid/Side, Independent Phase
            852200 - Time Domain Smoothing
            852201 - Preserve Formants, Time Domain Smoothing
            852202 - Mid/Side, Time Domain Smoothing
            852203 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852204 - Independent Phase, Time Domain Smoothing
            852205 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852206 - Mid/Side, Independent Phase, Time Domain Smoothing
            852207 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ
            852208 - nothing
            852209 - Preserve Formants
            852210 - Mid/Side
            852211 - Preserve Formants, Mid/Side
            852212 - Independent Phase
            852213 - Preserve Formants, Independent Phase
            852214 - Mid/Side, Independent Phase
            852215 - Preserve Formants, Mid/Side, Independent Phase
            852216 - Time Domain Smoothing
            852217 - Preserve Formants, Time Domain Smoothing
            852218 - Mid/Side, Time Domain Smoothing
            852219 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852220 - Independent Phase, Time Domain Smoothing
            852221 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852222 - Mid/Side, Independent Phase, Time Domain Smoothing
            852223 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ
            852224 - nothing
            852225 - Preserve Formants
            852226 - Mid/Side
            852227 - Preserve Formants, Mid/Side
            852228 - Independent Phase
            852229 - Preserve Formants, Independent Phase
            852230 - Mid/Side, Independent Phase
            852231 - Preserve Formants, Mid/Side, Independent Phase
            852232 - Time Domain Smoothing
            852233 - Preserve Formants, Time Domain Smoothing
            852234 - Mid/Side, Time Domain Smoothing
            852235 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852236 - Independent Phase, Time Domain Smoothing
            852237 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852238 - Mid/Side, Independent Phase, Time Domain Smoothing
            852239 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ
            852240 - nothing
            852241 - Preserve Formants
            852242 - Mid/Side
            852243 - Preserve Formants, Mid/Side
            852244 - Independent Phase
            852245 - Preserve Formants, Independent Phase
            852246 - Mid/Side, Independent Phase
            852247 - Preserve Formants, Mid/Side, Independent Phase
            852248 - Time Domain Smoothing
            852249 - Preserve Formants, Time Domain Smoothing
            852250 - Mid/Side, Time Domain Smoothing
            852251 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852252 - Independent Phase, Time Domain Smoothing
            852253 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852254 - Mid/Side, Independent Phase, Time Domain Smoothing
            852255 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent
            852256 - nothing
            852257 - Preserve Formants
            852258 - Mid/Side
            852259 - Preserve Formants, Mid/Side
            852260 - Independent Phase
            852261 - Preserve Formants, Independent Phase
            852262 - Mid/Side, Independent Phase
            852263 - Preserve Formants, Mid/Side, Independent Phase
            852264 - Time Domain Smoothing
            852265 - Preserve Formants, Time Domain Smoothing
            852266 - Mid/Side, Time Domain Smoothing
            852267 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852268 - Independent Phase, Time Domain Smoothing
            852269 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852270 - Mid/Side, Independent Phase, Time Domain Smoothing
            852271 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent
            852272 - nothing
            852273 - Preserve Formants
            852274 - Mid/Side
            852275 - Preserve Formants, Mid/Side
            852276 - Independent Phase
            852277 - Preserve Formants, Independent Phase
            852278 - Mid/Side, Independent Phase
            852279 - Preserve Formants, Mid/Side, Independent Phase
            852280 - Time Domain Smoothing
            852281 - Preserve Formants, Time Domain Smoothing
            852282 - Mid/Side, Time Domain Smoothing
            852283 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852284 - Independent Phase, Time Domain Smoothing
            852285 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852286 - Mid/Side, Independent Phase, Time Domain Smoothing
            852287 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent
            852288 - nothing
            852289 - Preserve Formants
            852290 - Mid/Side
            852291 - Preserve Formants, Mid/Side
            852292 - Independent Phase
            852293 - Preserve Formants, Independent Phase
            852294 - Mid/Side, Independent Phase
            852295 - Preserve Formants, Mid/Side, Independent Phase
            852296 - Time Domain Smoothing
            852297 - Preserve Formants, Time Domain Smoothing
            852298 - Mid/Side, Time Domain Smoothing
            852299 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852300 - Independent Phase, Time Domain Smoothing
            852301 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852302 - Mid/Side, Independent Phase, Time Domain Smoothing
            852303 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent
            852304 - nothing
            852305 - Preserve Formants
            852306 - Mid/Side
            852307 - Preserve Formants, Mid/Side
            852308 - Independent Phase
            852309 - Preserve Formants, Independent Phase
            852310 - Mid/Side, Independent Phase
            852311 - Preserve Formants, Mid/Side, Independent Phase
            852312 - Time Domain Smoothing
            852313 - Preserve Formants, Time Domain Smoothing
            852314 - Mid/Side, Time Domain Smoothing
            852315 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852316 - Independent Phase, Time Domain Smoothing
            852317 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852318 - Mid/Side, Independent Phase, Time Domain Smoothing
            852319 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent
            852320 - nothing
            852321 - Preserve Formants
            852322 - Mid/Side
            852323 - Preserve Formants, Mid/Side
            852324 - Independent Phase
            852325 - Preserve Formants, Independent Phase
            852326 - Mid/Side, Independent Phase
            852327 - Preserve Formants, Mid/Side, Independent Phase
            852328 - Time Domain Smoothing
            852329 - Preserve Formants, Time Domain Smoothing
            852330 - Mid/Side, Time Domain Smoothing
            852331 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852332 - Independent Phase, Time Domain Smoothing
            852333 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852334 - Mid/Side, Independent Phase, Time Domain Smoothing
            852335 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent
            852336 - nothing
            852337 - Preserve Formants
            852338 - Mid/Side
            852339 - Preserve Formants, Mid/Side
            852340 - Independent Phase
            852341 - Preserve Formants, Independent Phase
            852342 - Mid/Side, Independent Phase
            852343 - Preserve Formants, Mid/Side, Independent Phase
            852344 - Time Domain Smoothing
            852345 - Preserve Formants, Time Domain Smoothing
            852346 - Mid/Side, Time Domain Smoothing
            852347 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852348 - Independent Phase, Time Domain Smoothing
            852349 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852350 - Mid/Side, Independent Phase, Time Domain Smoothing
            852351 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent
            852352 - nothing
            852353 - Preserve Formants
            852354 - Mid/Side
            852355 - Preserve Formants, Mid/Side
            852356 - Independent Phase
            852357 - Preserve Formants, Independent Phase
            852358 - Mid/Side, Independent Phase
            852359 - Preserve Formants, Mid/Side, Independent Phase
            852360 - Time Domain Smoothing
            852361 - Preserve Formants, Time Domain Smoothing
            852362 - Mid/Side, Time Domain Smoothing
            852363 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852364 - Independent Phase, Time Domain Smoothing
            852365 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852366 - Mid/Side, Independent Phase, Time Domain Smoothing
            852367 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent
            852368 - nothing
            852369 - Preserve Formants
            852370 - Mid/Side
            852371 - Preserve Formants, Mid/Side
            852372 - Independent Phase
            852373 - Preserve Formants, Independent Phase
            852374 - Mid/Side, Independent Phase
            852375 - Preserve Formants, Mid/Side, Independent Phase
            852376 - Time Domain Smoothing
            852377 - Preserve Formants, Time Domain Smoothing
            852378 - Mid/Side, Time Domain Smoothing
            852379 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852380 - Independent Phase, Time Domain Smoothing
            852381 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852382 - Mid/Side, Independent Phase, Time Domain Smoothing
            852383 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent
            852384 - nothing
            852385 - Preserve Formants
            852386 - Mid/Side
            852387 - Preserve Formants, Mid/Side
            852388 - Independent Phase
            852389 - Preserve Formants, Independent Phase
            852390 - Mid/Side, Independent Phase
            852391 - Preserve Formants, Mid/Side, Independent Phase
            852392 - Time Domain Smoothing
            852393 - Preserve Formants, Time Domain Smoothing
            852394 - Mid/Side, Time Domain Smoothing
            852395 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852396 - Independent Phase, Time Domain Smoothing
            852397 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852398 - Mid/Side, Independent Phase, Time Domain Smoothing
            852399 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Short
            852400 - nothing
            852401 - Preserve Formants
            852402 - Mid/Side
            852403 - Preserve Formants, Mid/Side
            852404 - Independent Phase
            852405 - Preserve Formants, Independent Phase
            852406 - Mid/Side, Independent Phase
            852407 - Preserve Formants, Mid/Side, Independent Phase
            852408 - Time Domain Smoothing
            852409 - Preserve Formants, Time Domain Smoothing
            852410 - Mid/Side, Time Domain Smoothing
            852411 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852412 - Independent Phase, Time Domain Smoothing
            852413 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852414 - Mid/Side, Independent Phase, Time Domain Smoothing
            852415 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Short
            852416 - nothing
            852417 - Preserve Formants
            852418 - Mid/Side
            852419 - Preserve Formants, Mid/Side
            852420 - Independent Phase
            852421 - Preserve Formants, Independent Phase
            852422 - Mid/Side, Independent Phase
            852423 - Preserve Formants, Mid/Side, Independent Phase
            852424 - Time Domain Smoothing
            852425 - Preserve Formants, Time Domain Smoothing
            852426 - Mid/Side, Time Domain Smoothing
            852427 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852428 - Independent Phase, Time Domain Smoothing
            852429 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852430 - Mid/Side, Independent Phase, Time Domain Smoothing
            852431 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Short
            852432 - nothing
            852433 - Preserve Formants
            852434 - Mid/Side
            852435 - Preserve Formants, Mid/Side
            852436 - Independent Phase
            852437 - Preserve Formants, Independent Phase
            852438 - Mid/Side, Independent Phase
            852439 - Preserve Formants, Mid/Side, Independent Phase
            852440 - Time Domain Smoothing
            852441 - Preserve Formants, Time Domain Smoothing
            852442 - Mid/Side, Time Domain Smoothing
            852443 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852444 - Independent Phase, Time Domain Smoothing
            852445 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852446 - Mid/Side, Independent Phase, Time Domain Smoothing
            852447 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Short
            852448 - nothing
            852449 - Preserve Formants
            852450 - Mid/Side
            852451 - Preserve Formants, Mid/Side
            852452 - Independent Phase
            852453 - Preserve Formants, Independent Phase
            852454 - Mid/Side, Independent Phase
            852455 - Preserve Formants, Mid/Side, Independent Phase
            852456 - Time Domain Smoothing
            852457 - Preserve Formants, Time Domain Smoothing
            852458 - Mid/Side, Time Domain Smoothing
            852459 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852460 - Independent Phase, Time Domain Smoothing
            852461 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852462 - Mid/Side, Independent Phase, Time Domain Smoothing
            852463 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Short
            852464 - nothing
            852465 - Preserve Formants
            852466 - Mid/Side
            852467 - Preserve Formants, Mid/Side
            852468 - Independent Phase
            852469 - Preserve Formants, Independent Phase
            852470 - Mid/Side, Independent Phase
            852471 - Preserve Formants, Mid/Side, Independent Phase
            852472 - Time Domain Smoothing
            852473 - Preserve Formants, Time Domain Smoothing
            852474 - Mid/Side, Time Domain Smoothing
            852475 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852476 - Independent Phase, Time Domain Smoothing
            852477 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852478 - Mid/Side, Independent Phase, Time Domain Smoothing
            852479 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Short
            852480 - nothing
            852481 - Preserve Formants
            852482 - Mid/Side
            852483 - Preserve Formants, Mid/Side
            852484 - Independent Phase
            852485 - Preserve Formants, Independent Phase
            852486 - Mid/Side, Independent Phase
            852487 - Preserve Formants, Mid/Side, Independent Phase
            852488 - Time Domain Smoothing
            852489 - Preserve Formants, Time Domain Smoothing
            852490 - Mid/Side, Time Domain Smoothing
            852491 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852492 - Independent Phase, Time Domain Smoothing
            852493 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852494 - Mid/Side, Independent Phase, Time Domain Smoothing
            852495 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Short
            852496 - nothing
            852497 - Preserve Formants
            852498 - Mid/Side
            852499 - Preserve Formants, Mid/Side
            852500 - Independent Phase
            852501 - Preserve Formants, Independent Phase
            852502 - Mid/Side, Independent Phase
            852503 - Preserve Formants, Mid/Side, Independent Phase
            852504 - Time Domain Smoothing
            852505 - Preserve Formants, Time Domain Smoothing
            852506 - Mid/Side, Time Domain Smoothing
            852507 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852508 - Independent Phase, Time Domain Smoothing
            852509 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852510 - Mid/Side, Independent Phase, Time Domain Smoothing
            852511 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Short
            852512 - nothing
            852513 - Preserve Formants
            852514 - Mid/Side
            852515 - Preserve Formants, Mid/Side
            852516 - Independent Phase
            852517 - Preserve Formants, Independent Phase
            852518 - Mid/Side, Independent Phase
            852519 - Preserve Formants, Mid/Side, Independent Phase
            852520 - Time Domain Smoothing
            852521 - Preserve Formants, Time Domain Smoothing
            852522 - Mid/Side, Time Domain Smoothing
            852523 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852524 - Independent Phase, Time Domain Smoothing
            852525 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852526 - Mid/Side, Independent Phase, Time Domain Smoothing
            852527 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Short
            852528 - nothing
            852529 - Preserve Formants
            852530 - Mid/Side
            852531 - Preserve Formants, Mid/Side
            852532 - Independent Phase
            852533 - Preserve Formants, Independent Phase
            852534 - Mid/Side, Independent Phase
            852535 - Preserve Formants, Mid/Side, Independent Phase
            852536 - Time Domain Smoothing
            852537 - Preserve Formants, Time Domain Smoothing
            852538 - Mid/Side, Time Domain Smoothing
            852539 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852540 - Independent Phase, Time Domain Smoothing
            852541 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852542 - Mid/Side, Independent Phase, Time Domain Smoothing
            852543 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Short
            852544 - nothing
            852545 - Preserve Formants
            852546 - Mid/Side
            852547 - Preserve Formants, Mid/Side
            852548 - Independent Phase
            852549 - Preserve Formants, Independent Phase
            852550 - Mid/Side, Independent Phase
            852551 - Preserve Formants, Mid/Side, Independent Phase
            852552 - Time Domain Smoothing
            852553 - Preserve Formants, Time Domain Smoothing
            852554 - Mid/Side, Time Domain Smoothing
            852555 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852556 - Independent Phase, Time Domain Smoothing
            852557 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852558 - Mid/Side, Independent Phase, Time Domain Smoothing
            852559 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Short
            852560 - nothing
            852561 - Preserve Formants
            852562 - Mid/Side
            852563 - Preserve Formants, Mid/Side
            852564 - Independent Phase
            852565 - Preserve Formants, Independent Phase
            852566 - Mid/Side, Independent Phase
            852567 - Preserve Formants, Mid/Side, Independent Phase
            852568 - Time Domain Smoothing
            852569 - Preserve Formants, Time Domain Smoothing
            852570 - Mid/Side, Time Domain Smoothing
            852571 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852572 - Independent Phase, Time Domain Smoothing
            852573 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852574 - Mid/Side, Independent Phase, Time Domain Smoothing
            852575 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Short
            852576 - nothing
            852577 - Preserve Formants
            852578 - Mid/Side
            852579 - Preserve Formants, Mid/Side
            852580 - Independent Phase
            852581 - Preserve Formants, Independent Phase
            852582 - Mid/Side, Independent Phase
            852583 - Preserve Formants, Mid/Side, Independent Phase
            852584 - Time Domain Smoothing
            852585 - Preserve Formants, Time Domain Smoothing
            852586 - Mid/Side, Time Domain Smoothing
            852587 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852588 - Independent Phase, Time Domain Smoothing
            852589 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852590 - Mid/Side, Independent Phase, Time Domain Smoothing
            852591 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852592 - nothing
            852593 - Preserve Formants
            852594 - Mid/Side
            852595 - Preserve Formants, Mid/Side
            852596 - Independent Phase
            852597 - Preserve Formants, Independent Phase
            852598 - Mid/Side, Independent Phase
            852599 - Preserve Formants, Mid/Side, Independent Phase
            852600 - Time Domain Smoothing
            852601 - Preserve Formants, Time Domain Smoothing
            852602 - Mid/Side, Time Domain Smoothing
            852603 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852604 - Independent Phase, Time Domain Smoothing
            852605 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852606 - Mid/Side, Independent Phase, Time Domain Smoothing
            852607 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852608 - nothing
            852609 - Preserve Formants
            852610 - Mid/Side
            852611 - Preserve Formants, Mid/Side
            852612 - Independent Phase
            852613 - Preserve Formants, Independent Phase
            852614 - Mid/Side, Independent Phase
            852615 - Preserve Formants, Mid/Side, Independent Phase
            852616 - Time Domain Smoothing
            852617 - Preserve Formants, Time Domain Smoothing
            852618 - Mid/Side, Time Domain Smoothing
            852619 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852620 - Independent Phase, Time Domain Smoothing
            852621 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852622 - Mid/Side, Independent Phase, Time Domain Smoothing
            852623 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Short
            852624 - nothing
            852625 - Preserve Formants
            852626 - Mid/Side
            852627 - Preserve Formants, Mid/Side
            852628 - Independent Phase
            852629 - Preserve Formants, Independent Phase
            852630 - Mid/Side, Independent Phase
            852631 - Preserve Formants, Mid/Side, Independent Phase
            852632 - Time Domain Smoothing
            852633 - Preserve Formants, Time Domain Smoothing
            852634 - Mid/Side, Time Domain Smoothing
            852635 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852636 - Independent Phase, Time Domain Smoothing
            852637 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852638 - Mid/Side, Independent Phase, Time Domain Smoothing
            852639 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Short
            852640 - nothing
            852641 - Preserve Formants
            852642 - Mid/Side
            852643 - Preserve Formants, Mid/Side
            852644 - Independent Phase
            852645 - Preserve Formants, Independent Phase
            852646 - Mid/Side, Independent Phase
            852647 - Preserve Formants, Mid/Side, Independent Phase
            852648 - Time Domain Smoothing
            852649 - Preserve Formants, Time Domain Smoothing
            852650 - Mid/Side, Time Domain Smoothing
            852651 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852652 - Independent Phase, Time Domain Smoothing
            852653 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852654 - Mid/Side, Independent Phase, Time Domain Smoothing
            852655 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852656 - nothing
            852657 - Preserve Formants
            852658 - Mid/Side
            852659 - Preserve Formants, Mid/Side
            852660 - Independent Phase
            852661 - Preserve Formants, Independent Phase
            852662 - Mid/Side, Independent Phase
            852663 - Preserve Formants, Mid/Side, Independent Phase
            852664 - Time Domain Smoothing
            852665 - Preserve Formants, Time Domain Smoothing
            852666 - Mid/Side, Time Domain Smoothing
            852667 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852668 - Independent Phase, Time Domain Smoothing
            852669 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852670 - Mid/Side, Independent Phase, Time Domain Smoothing
            852671 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Short
            852672 - nothing
            852673 - Preserve Formants
            852674 - Mid/Side
            852675 - Preserve Formants, Mid/Side
            852676 - Independent Phase
            852677 - Preserve Formants, Independent Phase
            852678 - Mid/Side, Independent Phase
            852679 - Preserve Formants, Mid/Side, Independent Phase
            852680 - Time Domain Smoothing
            852681 - Preserve Formants, Time Domain Smoothing
            852682 - Mid/Side, Time Domain Smoothing
            852683 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852684 - Independent Phase, Time Domain Smoothing
            852685 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852686 - Mid/Side, Independent Phase, Time Domain Smoothing
            852687 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Short
            852688 - nothing
            852689 - Preserve Formants
            852690 - Mid/Side
            852691 - Preserve Formants, Mid/Side
            852692 - Independent Phase
            852693 - Preserve Formants, Independent Phase
            852694 - Mid/Side, Independent Phase
            852695 - Preserve Formants, Mid/Side, Independent Phase
            852696 - Time Domain Smoothing
            852697 - Preserve Formants, Time Domain Smoothing
            852698 - Mid/Side, Time Domain Smoothing
            852699 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852700 - Independent Phase, Time Domain Smoothing
            852701 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852702 - Mid/Side, Independent Phase, Time Domain Smoothing
            852703 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Short
            852704 - nothing
            852705 - Preserve Formants
            852706 - Mid/Side
            852707 - Preserve Formants, Mid/Side
            852708 - Independent Phase
            852709 - Preserve Formants, Independent Phase
            852710 - Mid/Side, Independent Phase
            852711 - Preserve Formants, Mid/Side, Independent Phase
            852712 - Time Domain Smoothing
            852713 - Preserve Formants, Time Domain Smoothing
            852714 - Mid/Side, Time Domain Smoothing
            852715 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852716 - Independent Phase, Time Domain Smoothing
            852717 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852718 - Mid/Side, Independent Phase, Time Domain Smoothing
            852719 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Short
            852720 - nothing
            852721 - Preserve Formants
            852722 - Mid/Side
            852723 - Preserve Formants, Mid/Side
            852724 - Independent Phase
            852725 - Preserve Formants, Independent Phase
            852726 - Mid/Side, Independent Phase
            852727 - Preserve Formants, Mid/Side, Independent Phase
            852728 - Time Domain Smoothing
            852729 - Preserve Formants, Time Domain Smoothing
            852730 - Mid/Side, Time Domain Smoothing
            852731 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852732 - Independent Phase, Time Domain Smoothing
            852733 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852734 - Mid/Side, Independent Phase, Time Domain Smoothing
            852735 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852736 - nothing
            852737 - Preserve Formants
            852738 - Mid/Side
            852739 - Preserve Formants, Mid/Side
            852740 - Independent Phase
            852741 - Preserve Formants, Independent Phase
            852742 - Mid/Side, Independent Phase
            852743 - Preserve Formants, Mid/Side, Independent Phase
            852744 - Time Domain Smoothing
            852745 - Preserve Formants, Time Domain Smoothing
            852746 - Mid/Side, Time Domain Smoothing
            852747 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852748 - Independent Phase, Time Domain Smoothing
            852749 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852750 - Mid/Side, Independent Phase, Time Domain Smoothing
            852751 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852752 - nothing
            852753 - Preserve Formants
            852754 - Mid/Side
            852755 - Preserve Formants, Mid/Side
            852756 - Independent Phase
            852757 - Preserve Formants, Independent Phase
            852758 - Mid/Side, Independent Phase
            852759 - Preserve Formants, Mid/Side, Independent Phase
            852760 - Time Domain Smoothing
            852761 - Preserve Formants, Time Domain Smoothing
            852762 - Mid/Side, Time Domain Smoothing
            852763 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852764 - Independent Phase, Time Domain Smoothing
            852765 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852766 - Mid/Side, Independent Phase, Time Domain Smoothing
            852767 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Short
            852768 - nothing
            852769 - Preserve Formants
            852770 - Mid/Side
            852771 - Preserve Formants, Mid/Side
            852772 - Independent Phase
            852773 - Preserve Formants, Independent Phase
            852774 - Mid/Side, Independent Phase
            852775 - Preserve Formants, Mid/Side, Independent Phase
            852776 - Time Domain Smoothing
            852777 - Preserve Formants, Time Domain Smoothing
            852778 - Mid/Side, Time Domain Smoothing
            852779 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852780 - Independent Phase, Time Domain Smoothing
            852781 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852782 - Mid/Side, Independent Phase, Time Domain Smoothing
            852783 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Short
            852784 - nothing
            852785 - Preserve Formants
            852786 - Mid/Side
            852787 - Preserve Formants, Mid/Side
            852788 - Independent Phase
            852789 - Preserve Formants, Independent Phase
            852790 - Mid/Side, Independent Phase
            852791 - Preserve Formants, Mid/Side, Independent Phase
            852792 - Time Domain Smoothing
            852793 - Preserve Formants, Time Domain Smoothing
            852794 - Mid/Side, Time Domain Smoothing
            852795 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852796 - Independent Phase, Time Domain Smoothing
            852797 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852798 - Mid/Side, Independent Phase, Time Domain Smoothing
            852799 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852800 - nothing
            852801 - Preserve Formants
            852802 - Mid/Side
            852803 - Preserve Formants, Mid/Side
            852804 - Independent Phase
            852805 - Preserve Formants, Independent Phase
            852806 - Mid/Side, Independent Phase
            852807 - Preserve Formants, Mid/Side, Independent Phase
            852808 - Time Domain Smoothing
            852809 - Preserve Formants, Time Domain Smoothing
            852810 - Mid/Side, Time Domain Smoothing
            852811 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852812 - Independent Phase, Time Domain Smoothing
            852813 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852814 - Mid/Side, Independent Phase, Time Domain Smoothing
            852815 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Short
            852816 - nothing
            852817 - Preserve Formants
            852818 - Mid/Side
            852819 - Preserve Formants, Mid/Side
            852820 - Independent Phase
            852821 - Preserve Formants, Independent Phase
            852822 - Mid/Side, Independent Phase
            852823 - Preserve Formants, Mid/Side, Independent Phase
            852824 - Time Domain Smoothing
            852825 - Preserve Formants, Time Domain Smoothing
            852826 - Mid/Side, Time Domain Smoothing
            852827 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852828 - Independent Phase, Time Domain Smoothing
            852829 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852830 - Mid/Side, Independent Phase, Time Domain Smoothing
            852831 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Window: Long
            852832 - nothing
            852833 - Preserve Formants
            852834 - Mid/Side
            852835 - Preserve Formants, Mid/Side
            852836 - Independent Phase
            852837 - Preserve Formants, Independent Phase
            852838 - Mid/Side, Independent Phase
            852839 - Preserve Formants, Mid/Side, Independent Phase
            852840 - Time Domain Smoothing
            852841 - Preserve Formants, Time Domain Smoothing
            852842 - Mid/Side, Time Domain Smoothing
            852843 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852844 - Independent Phase, Time Domain Smoothing
            852845 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852846 - Mid/Side, Independent Phase, Time Domain Smoothing
            852847 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Window: Long
            852848 - nothing
            852849 - Preserve Formants
            852850 - Mid/Side
            852851 - Preserve Formants, Mid/Side
            852852 - Independent Phase
            852853 - Preserve Formants, Independent Phase
            852854 - Mid/Side, Independent Phase
            852855 - Preserve Formants, Mid/Side, Independent Phase
            852856 - Time Domain Smoothing
            852857 - Preserve Formants, Time Domain Smoothing
            852858 - Mid/Side, Time Domain Smoothing
            852859 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852860 - Independent Phase, Time Domain Smoothing
            852861 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852862 - Mid/Side, Independent Phase, Time Domain Smoothing
            852863 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Window: Long
            852864 - nothing
            852865 - Preserve Formants
            852866 - Mid/Side
            852867 - Preserve Formants, Mid/Side
            852868 - Independent Phase
            852869 - Preserve Formants, Independent Phase
            852870 - Mid/Side, Independent Phase
            852871 - Preserve Formants, Mid/Side, Independent Phase
            852872 - Time Domain Smoothing
            852873 - Preserve Formants, Time Domain Smoothing
            852874 - Mid/Side, Time Domain Smoothing
            852875 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852876 - Independent Phase, Time Domain Smoothing
            852877 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852878 - Mid/Side, Independent Phase, Time Domain Smoothing
            852879 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Window: Long
            852880 - nothing
            852881 - Preserve Formants
            852882 - Mid/Side
            852883 - Preserve Formants, Mid/Side
            852884 - Independent Phase
            852885 - Preserve Formants, Independent Phase
            852886 - Mid/Side, Independent Phase
            852887 - Preserve Formants, Mid/Side, Independent Phase
            852888 - Time Domain Smoothing
            852889 - Preserve Formants, Time Domain Smoothing
            852890 - Mid/Side, Time Domain Smoothing
            852891 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852892 - Independent Phase, Time Domain Smoothing
            852893 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852894 - Mid/Side, Independent Phase, Time Domain Smoothing
            852895 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Window: Long
            852896 - nothing
            852897 - Preserve Formants
            852898 - Mid/Side
            852899 - Preserve Formants, Mid/Side
            852900 - Independent Phase
            852901 - Preserve Formants, Independent Phase
            852902 - Mid/Side, Independent Phase
            852903 - Preserve Formants, Mid/Side, Independent Phase
            852904 - Time Domain Smoothing
            852905 - Preserve Formants, Time Domain Smoothing
            852906 - Mid/Side, Time Domain Smoothing
            852907 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852908 - Independent Phase, Time Domain Smoothing
            852909 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852910 - Mid/Side, Independent Phase, Time Domain Smoothing
            852911 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Window: Long
            852912 - nothing
            852913 - Preserve Formants
            852914 - Mid/Side
            852915 - Preserve Formants, Mid/Side
            852916 - Independent Phase
            852917 - Preserve Formants, Independent Phase
            852918 - Mid/Side, Independent Phase
            852919 - Preserve Formants, Mid/Side, Independent Phase
            852920 - Time Domain Smoothing
            852921 - Preserve Formants, Time Domain Smoothing
            852922 - Mid/Side, Time Domain Smoothing
            852923 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852924 - Independent Phase, Time Domain Smoothing
            852925 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852926 - Mid/Side, Independent Phase, Time Domain Smoothing
            852927 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Window: Long
            852928 - nothing
            852929 - Preserve Formants
            852930 - Mid/Side
            852931 - Preserve Formants, Mid/Side
            852932 - Independent Phase
            852933 - Preserve Formants, Independent Phase
            852934 - Mid/Side, Independent Phase
            852935 - Preserve Formants, Mid/Side, Independent Phase
            852936 - Time Domain Smoothing
            852937 - Preserve Formants, Time Domain Smoothing
            852938 - Mid/Side, Time Domain Smoothing
            852939 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852940 - Independent Phase, Time Domain Smoothing
            852941 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852942 - Mid/Side, Independent Phase, Time Domain Smoothing
            852943 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Window: Long
            852944 - nothing
            852945 - Preserve Formants
            852946 - Mid/Side
            852947 - Preserve Formants, Mid/Side
            852948 - Independent Phase
            852949 - Preserve Formants, Independent Phase
            852950 - Mid/Side, Independent Phase
            852951 - Preserve Formants, Mid/Side, Independent Phase
            852952 - Time Domain Smoothing
            852953 - Preserve Formants, Time Domain Smoothing
            852954 - Mid/Side, Time Domain Smoothing
            852955 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852956 - Independent Phase, Time Domain Smoothing
            852957 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852958 - Mid/Side, Independent Phase, Time Domain Smoothing
            852959 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Window: Long
            852960 - nothing
            852961 - Preserve Formants
            852962 - Mid/Side
            852963 - Preserve Formants, Mid/Side
            852964 - Independent Phase
            852965 - Preserve Formants, Independent Phase
            852966 - Mid/Side, Independent Phase
            852967 - Preserve Formants, Mid/Side, Independent Phase
            852968 - Time Domain Smoothing
            852969 - Preserve Formants, Time Domain Smoothing
            852970 - Mid/Side, Time Domain Smoothing
            852971 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852972 - Independent Phase, Time Domain Smoothing
            852973 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852974 - Mid/Side, Independent Phase, Time Domain Smoothing
            852975 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: HighQ, Window: Long
            852976 - nothing
            852977 - Preserve Formants
            852978 - Mid/Side
            852979 - Preserve Formants, Mid/Side
            852980 - Independent Phase
            852981 - Preserve Formants, Independent Phase
            852982 - Mid/Side, Independent Phase
            852983 - Preserve Formants, Mid/Side, Independent Phase
            852984 - Time Domain Smoothing
            852985 - Preserve Formants, Time Domain Smoothing
            852986 - Mid/Side, Time Domain Smoothing
            852987 - Preserve Formants, Mid/Side, Time Domain Smoothing
            852988 - Independent Phase, Time Domain Smoothing
            852989 - Preserve Formants, Independent Phase, Time Domain Smoothing
            852990 - Mid/Side, Independent Phase, Time Domain Smoothing
            852991 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: HighQ, Window: Long
            852992 - nothing
            852993 - Preserve Formants
            852994 - Mid/Side
            852995 - Preserve Formants, Mid/Side
            852996 - Independent Phase
            852997 - Preserve Formants, Independent Phase
            852998 - Mid/Side, Independent Phase
            852999 - Preserve Formants, Mid/Side, Independent Phase
            853000 - Time Domain Smoothing
            853001 - Preserve Formants, Time Domain Smoothing
            853002 - Mid/Side, Time Domain Smoothing
            853003 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853004 - Independent Phase, Time Domain Smoothing
            853005 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853006 - Mid/Side, Independent Phase, Time Domain Smoothing
            853007 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: HighQ, Window: Long
            853008 - nothing
            853009 - Preserve Formants
            853010 - Mid/Side
            853011 - Preserve Formants, Mid/Side
            853012 - Independent Phase
            853013 - Preserve Formants, Independent Phase
            853014 - Mid/Side, Independent Phase
            853015 - Preserve Formants, Mid/Side, Independent Phase
            853016 - Time Domain Smoothing
            853017 - Preserve Formants, Time Domain Smoothing
            853018 - Mid/Side, Time Domain Smoothing
            853019 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853020 - Independent Phase, Time Domain Smoothing
            853021 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853022 - Mid/Side, Independent Phase, Time Domain Smoothing
            853023 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853024 - nothing
            853025 - Preserve Formants
            853026 - Mid/Side
            853027 - Preserve Formants, Mid/Side
            853028 - Independent Phase
            853029 - Preserve Formants, Independent Phase
            853030 - Mid/Side, Independent Phase
            853031 - Preserve Formants, Mid/Side, Independent Phase
            853032 - Time Domain Smoothing
            853033 - Preserve Formants, Time Domain Smoothing
            853034 - Mid/Side, Time Domain Smoothing
            853035 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853036 - Independent Phase, Time Domain Smoothing
            853037 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853038 - Mid/Side, Independent Phase, Time Domain Smoothing
            853039 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853040 - nothing
            853041 - Preserve Formants
            853042 - Mid/Side
            853043 - Preserve Formants, Mid/Side
            853044 - Independent Phase
            853045 - Preserve Formants, Independent Phase
            853046 - Mid/Side, Independent Phase
            853047 - Preserve Formants, Mid/Side, Independent Phase
            853048 - Time Domain Smoothing
            853049 - Preserve Formants, Time Domain Smoothing
            853050 - Mid/Side, Time Domain Smoothing
            853051 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853052 - Independent Phase, Time Domain Smoothing
            853053 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853054 - Mid/Side, Independent Phase, Time Domain Smoothing
            853055 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: HighQ, Window: Long
            853056 - nothing
            853057 - Preserve Formants
            853058 - Mid/Side
            853059 - Preserve Formants, Mid/Side
            853060 - Independent Phase
            853061 - Preserve Formants, Independent Phase
            853062 - Mid/Side, Independent Phase
            853063 - Preserve Formants, Mid/Side, Independent Phase
            853064 - Time Domain Smoothing
            853065 - Preserve Formants, Time Domain Smoothing
            853066 - Mid/Side, Time Domain Smoothing
            853067 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853068 - Independent Phase, Time Domain Smoothing
            853069 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853070 - Mid/Side, Independent Phase, Time Domain Smoothing
            853071 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: HighQ, Window: Long
            853072 - nothing
            853073 - Preserve Formants
            853074 - Mid/Side
            853075 - Preserve Formants, Mid/Side
            853076 - Independent Phase
            853077 - Preserve Formants, Independent Phase
            853078 - Mid/Side, Independent Phase
            853079 - Preserve Formants, Mid/Side, Independent Phase
            853080 - Time Domain Smoothing
            853081 - Preserve Formants, Time Domain Smoothing
            853082 - Mid/Side, Time Domain Smoothing
            853083 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853084 - Independent Phase, Time Domain Smoothing
            853085 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853086 - Mid/Side, Independent Phase, Time Domain Smoothing
            853087 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853088 - nothing
            853089 - Preserve Formants
            853090 - Mid/Side
            853091 - Preserve Formants, Mid/Side
            853092 - Independent Phase
            853093 - Preserve Formants, Independent Phase
            853094 - Mid/Side, Independent Phase
            853095 - Preserve Formants, Mid/Side, Independent Phase
            853096 - Time Domain Smoothing
            853097 - Preserve Formants, Time Domain Smoothing
            853098 - Mid/Side, Time Domain Smoothing
            853099 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853100 - Independent Phase, Time Domain Smoothing
            853101 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853102 - Mid/Side, Independent Phase, Time Domain Smoothing
            853103 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: HighQ, Window: Long
            853104 - nothing
            853105 - Preserve Formants
            853106 - Mid/Side
            853107 - Preserve Formants, Mid/Side
            853108 - Independent Phase
            853109 - Preserve Formants, Independent Phase
            853110 - Mid/Side, Independent Phase
            853111 - Preserve Formants, Mid/Side, Independent Phase
            853112 - Time Domain Smoothing
            853113 - Preserve Formants, Time Domain Smoothing
            853114 - Mid/Side, Time Domain Smoothing
            853115 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853116 - Independent Phase, Time Domain Smoothing
            853117 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853118 - Mid/Side, Independent Phase, Time Domain Smoothing
            853119 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Pitch Mode: Consistent, Window: Long
            853120 - nothing
            853121 - Preserve Formants
            853122 - Mid/Side
            853123 - Preserve Formants, Mid/Side
            853124 - Independent Phase
            853125 - Preserve Formants, Independent Phase
            853126 - Mid/Side, Independent Phase
            853127 - Preserve Formants, Mid/Side, Independent Phase
            853128 - Time Domain Smoothing
            853129 - Preserve Formants, Time Domain Smoothing
            853130 - Mid/Side, Time Domain Smoothing
            853131 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853132 - Independent Phase, Time Domain Smoothing
            853133 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853134 - Mid/Side, Independent Phase, Time Domain Smoothing
            853135 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Pitch Mode: Consistent, Window: Long
            853136 - nothing
            853137 - Preserve Formants
            853138 - Mid/Side
            853139 - Preserve Formants, Mid/Side
            853140 - Independent Phase
            853141 - Preserve Formants, Independent Phase
            853142 - Mid/Side, Independent Phase
            853143 - Preserve Formants, Mid/Side, Independent Phase
            853144 - Time Domain Smoothing
            853145 - Preserve Formants, Time Domain Smoothing
            853146 - Mid/Side, Time Domain Smoothing
            853147 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853148 - Independent Phase, Time Domain Smoothing
            853149 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853150 - Mid/Side, Independent Phase, Time Domain Smoothing
            853151 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Pitch Mode: Consistent, Window: Long
            853152 - nothing
            853153 - Preserve Formants
            853154 - Mid/Side
            853155 - Preserve Formants, Mid/Side
            853156 - Independent Phase
            853157 - Preserve Formants, Independent Phase
            853158 - Mid/Side, Independent Phase
            853159 - Preserve Formants, Mid/Side, Independent Phase
            853160 - Time Domain Smoothing
            853161 - Preserve Formants, Time Domain Smoothing
            853162 - Mid/Side, Time Domain Smoothing
            853163 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853164 - Independent Phase, Time Domain Smoothing
            853165 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853166 - Mid/Side, Independent Phase, Time Domain Smoothing
            853167 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853168 - nothing
            853169 - Preserve Formants
            853170 - Mid/Side
            853171 - Preserve Formants, Mid/Side
            853172 - Independent Phase
            853173 - Preserve Formants, Independent Phase
            853174 - Mid/Side, Independent Phase
            853175 - Preserve Formants, Mid/Side, Independent Phase
            853176 - Time Domain Smoothing
            853177 - Preserve Formants, Time Domain Smoothing
            853178 - Mid/Side, Time Domain Smoothing
            853179 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853180 - Independent Phase, Time Domain Smoothing
            853181 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853182 - Mid/Side, Independent Phase, Time Domain Smoothing
            853183 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853184 - nothing
            853185 - Preserve Formants
            853186 - Mid/Side
            853187 - Preserve Formants, Mid/Side
            853188 - Independent Phase
            853189 - Preserve Formants, Independent Phase
            853190 - Mid/Side, Independent Phase
            853191 - Preserve Formants, Mid/Side, Independent Phase
            853192 - Time Domain Smoothing
            853193 - Preserve Formants, Time Domain Smoothing
            853194 - Mid/Side, Time Domain Smoothing
            853195 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853196 - Independent Phase, Time Domain Smoothing
            853197 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853198 - Mid/Side, Independent Phase, Time Domain Smoothing
            853199 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Percussive, Pitch Mode: Consistent, Window: Long
            853200 - nothing
            853201 - Preserve Formants
            853202 - Mid/Side
            853203 - Preserve Formants, Mid/Side
            853204 - Independent Phase
            853205 - Preserve Formants, Independent Phase
            853206 - Mid/Side, Independent Phase
            853207 - Preserve Formants, Mid/Side, Independent Phase
            853208 - Time Domain Smoothing
            853209 - Preserve Formants, Time Domain Smoothing
            853210 - Mid/Side, Time Domain Smoothing
            853211 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853212 - Independent Phase, Time Domain Smoothing
            853213 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853214 - Mid/Side, Independent Phase, Time Domain Smoothing
            853215 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Detector: Soft, Pitch Mode: Consistent, Window: Long
            853216 - nothing
            853217 - Preserve Formants
            853218 - Mid/Side
            853219 - Preserve Formants, Mid/Side
            853220 - Independent Phase
            853221 - Preserve Formants, Independent Phase
            853222 - Mid/Side, Independent Phase
            853223 - Preserve Formants, Mid/Side, Independent Phase
            853224 - Time Domain Smoothing
            853225 - Preserve Formants, Time Domain Smoothing
            853226 - Mid/Side, Time Domain Smoothing
            853227 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853228 - Independent Phase, Time Domain Smoothing
            853229 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853230 - Mid/Side, Independent Phase, Time Domain Smoothing
            853231 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Mixed, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853232 - nothing
            853233 - Preserve Formants
            853234 - Mid/Side
            853235 - Preserve Formants, Mid/Side
            853236 - Independent Phase
            853237 - Preserve Formants, Independent Phase
            853238 - Mid/Side, Independent Phase
            853239 - Preserve Formants, Mid/Side, Independent Phase
            853240 - Time Domain Smoothing
            853241 - Preserve Formants, Time Domain Smoothing
            853242 - Mid/Side, Time Domain Smoothing
            853243 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853244 - Independent Phase, Time Domain Smoothing
            853245 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853246 - Mid/Side, Independent Phase, Time Domain Smoothing
            853247 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing

        Rubber Band Library - Transients: Smooth, Detector: Soft, Pitch Mode: Consistent, Window: Long
            853248 - nothing
            853249 - Preserve Formants
            853250 - Mid/Side
            853251 - Preserve Formants, Mid/Side
            853252 - Independent Phase
            853253 - Preserve Formants, Independent Phase
            853254 - Mid/Side, Independent Phase
            853255 - Preserve Formants, Mid/Side, Independent Phase
            853256 - Time Domain Smoothing
            853257 - Preserve Formants, Time Domain Smoothing
            853258 - Mid/Side, Time Domain Smoothing
            853259 - Preserve Formants, Mid/Side, Time Domain Smoothing
            853260 - Independent Phase, Time Domain Smoothing
            853261 - Preserve Formants, Independent Phase, Time Domain Smoothing
            853262 - Mid/Side, Independent Phase, Time Domain Smoothing
            853263 - Preserve Formants, Mid/Side, Independent Phase, Time Domain Smoothing
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer def_pitch_mode_state - the default pitch mode
    integer stretch_marker_mode - the stretch marker mode
                                - 0, Balanced
                                - 1, Tonal-optimized
                                - 2, Transient-optimized
                                - 3, No pre-echo reduction
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, default, pitch mode, pitch</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_DefPitchMode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_DefPitchMode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_DefPitchMode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(def_pitch_mode_state)~="integer" then ultraschall.AddErrorMessage("SetProject_DefPitchMode", "def_pitch_mode_state", "Must be an integer", -4) return -1 end
  if type(stretch_marker_mode)=="string" then ProjectStateChunk=stretch_marker_mode stretch_marker_mode=0 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_DefPitchMode", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-DEFPITCHMODE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-DEFPITCHMODE%s.-%c(.-<RENDER_CFG.*)")

  ProjectStateChunk=FileStart..def_pitch_mode_state.." "..stretch_marker_mode.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

--A1=ultraschall.SetProject_DefPitchMode("c:\\pitchshifter.rpp", 7865,1)
--A,B=ultraschall.GetProject_DefPitchMode("c:\\pitchshifter.rpp", 1987)

function ultraschall.SetProject_TakeLane(projectfilename_with_path, take_lane_state, ProjectStateChunk)
-- returns TakeLane state
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_TakeLane</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_TakeLane(string projectfilename_with_path, integer take_lane_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the take-lane-state in an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer take_lane_state - take-lane-state
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, take, lane</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TakeLane", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_TakeLane", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TakeLane", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(take_lane_state)~="integer" then ultraschall.AddErrorMessage("SetProject_TakeLane", "take_lane_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TakeLane", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-TAKELANE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-TAKELANE%s.-%c(.-<RENDER_CFG.*)")

  ProjectStateChunk=FileStart..take_lane_state.." \n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A=ultraschall.SetProject_TakeLane("c:\\tt.rpp",76)
--A=ultraschall.GetProject_TakeLane("c:\\tt.rpp",1)

function ultraschall.SetProject_SampleRate(projectfilename_with_path, sample_rate, project_sample_rate, force_tempo_time_sig, ProjectStateChunk)
-- returns Project Settings Samplerate
--        a - Project Sample Rate
--        b - Checkbox: Project Sample Rate
--        c - Checkbox: Force Project Tempo/Time Signature changes to occur on whole samples 

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_SampleRate</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_SampleRate(string projectfilename_with_path, integer sample_rate, integer project_sample_rate, integer force_tempo_time_sig, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the project-samplerate-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer sample_rate - Project Sample Rate in Hz
    integer project_sample_rate - Checkbox: Project Sample Rate
    integer force_tempo_time_sig - Checkbox: Force Project Tempo/Time Signature changes to occur on whole samples 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, sample, rate, samplerate, tempo, time, signature</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SampleRate", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_SampleRate", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SampleRate", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(sample_rate)~="integer" then ultraschall.AddErrorMessage("SetProject_SampleRate", "sample_rate", "Must be an integer", -4) return -1 end
  if math.type(project_sample_rate)~="integer" then ultraschall.AddErrorMessage("SetProject_SampleRate", "project_sample_rate", "Must be an integer", -5) return -1 end
  if math.type(force_tempo_time_sig)~="integer" then ultraschall.AddErrorMessage("SetProject_SampleRate", "force_tempo_time_sig", "Must be an integer", -6) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_SampleRate", "projectfilename_with_path", "No valid RPP-Projectfile!", -7) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-SAMPLERATE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-SAMPLERATE%s.-%c(.-<RENDER_CFG.*)")

  ProjectStateChunk=FileStart..sample_rate.." "..project_sample_rate.." "..force_tempo_time_sig.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

--A,AA,AAA=ultraschall.SetProject_SampleRate("c:\\tt.rpp",9,8,7)
--A,AA,AAA=ultraschall.GetProject_SampleRate("c:\\tt.rpp",8000,2,0)

function ultraschall.SetProject_TrackMixingDepth(projectfilename_with_path, mixingdepth, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_TrackMixingDepth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_TrackMixingDepth(string projectfilename_with_path, integer mixingdepth, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the project-samplerate-state, as set in the project-settings, from an rpp-project-file or a ProjectStateChunk.
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer mixingdepth - the track mixing depth
                        -   1 - 32 bit float
                        -   2 - 39 bit integer
                        -   3 - 24 bit integer
                        -   4 - 16 bit integer
                        -   5 - 12 bit integer
                        -   6 - 8 bit integer
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, sample, rate, samplerate, tempo, time, signature</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TrackMixingDepth", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_TrackMixingDepth", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TrackMixingDepth", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(mixingdepth)~="integer" then ultraschall.AddErrorMessage("SetProject_TrackMixingDepth", "mixingdepth", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_TrackMixingDepth", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-INTMIXMODE%s).-%c.-<RENDER_CFG.*")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-INTMIXMODE%s.-%c(.-<RENDER_CFG.*)")

  if FileStart==nil or FileEnd==nil then 
    FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-)<RENDER_CFG.*")
    FileEnd="  "..ProjectStateChunk:match("<REAPER_PROJECT.-(<RENDER_CFG.*)")
    mixingdepth="INTMIXMODE "..mixingdepth
  end

  ProjectStateChunk=FileStart..mixingdepth.."\n"..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.GetProject_CountMarkersAndRegions(projectfilenamewithpath)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_CountMarkersAndRegions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_markers_and_regions, integer number_of_regions_only, integer number_of_markers_only = ultraschall.GetProject_CountMarkersAndRegions(string projectfilename_with_path)</functioncall>
  <description>
    returns the number of all markers, the number of regions and the number of markers(that are not regions) in the project.
    
    It's the entry MARKER
    
    returns -1 in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfilename in which to count the markers
  </parameters>
  <retvals>
    integer number_of_markers_and_regions - the number of all markers and regions
    integer number_of_regions_only - the number of regions
    integer number_of_markers_only - the number of markers only
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, count, marker, regions</tags>
</US_DocBloc>
]]
  if type(projectfilenamewithpath)~="string" then ultraschall.AddErrorMessage("GetProject_CountMarkersAndRegions", "projectfilename_with_path", "Must be a string", -2)  return -1 end
  if reaper.file_exists(projectfilenamewithpath)==false then ultraschall.AddErrorMessage("GetProject_CountMarkersAndRegions", "projectfilename_with_path", "Projectfile does not exist", -1)  return -1 end
  local A=ultraschall.ReadValueFromFile(projectfilenamewithpath,"MARKER", false)
  local L,LL=ultraschall.SplitStringAtLineFeedToArray(A)
  
  local regions=0
  local marker=0
  for i=1,L do
    if LL[i]:match("MARKER .* (.) .- 1 .")=="1" then regions=regions+1  end
    if LL[i]:match("MARKER .* (.) .- 1 .")=="0" then marker=marker+1 end
  end
  
  return L,tonumber(regions)/2, tonumber(marker)
end

--ultraschall.GetProject_CountMarkersAndRegions(projectfilenamewithpath)

function ultraschall.GetProject_GetMarker(projectfilenamewithpath, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GetMarker</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shownnumber, number markerposition, string markertitle, integer markercolor = ultraschall.GetProject_GetMarker(string projectfilename_with_path, integer idx)</functioncall>
  <description>
    returns the information of the marker idx in a projectfile.
    
    It's the entry MARKER
    
    returns false in case of error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfilename from where to get the marker
    integer idx - the number of the marker, you want to have the information of
  </parameters>
  <retvals>
    boolean retval - true, in case of success; false in case of failure
    integer shownnumber - the number that is shown with the marker in the arrange-view
    number markerposition - the position of the marker in seconds
    string markertitle - the name of the marker. "" if no name is given.
    integer markercolor - the colorvalue of the marker
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, marker, shown number, name, color, position</tags>
</US_DocBloc>
]]
  if projectfilenamewithpath==nil or reaper.file_exists(projectfilenamewithpath)==false then ultraschall.AddErrorMessage("GetProject_GetMarker", "projectfilenamewithpath", "Projectfile does not exist", -1)  return false end
  idx=tonumber(idx)
  if idx==nil then ultraschall.AddErrorMessage("GetProject_GetMarker", "idx", "No valid value given. Only integer numbers are allowed.", -2)  return false end
  local A,B,C=ultraschall.GetProject_CountMarkersAndRegions(projectfilenamewithpath)
  if tonumber(idx)>C then ultraschall.AddErrorMessage("GetProject_GetMarker", "idx", "Only "..C.." markers available.", -3)  return false end
  if tonumber(idx)<1 then ultraschall.AddErrorMessage("GetProject_GetMarker", "idx", "Only positive values allowed.", -4)  return false end
  local A=ultraschall.ReadValueFromFile(projectfilenamewithpath,"MARKER", false)
  local L,LL=ultraschall.SplitStringAtLineFeedToArray(A)
  
  local regions=0
  local marker=0
  for i=L,1,-1 do
    if LL[i]:match("MARKER .* (.) .- 1 .")=="1" then table.remove(LL,i) end
  end
    
  local markname
  local markid=LL[idx]:match("MARKER (.-) ")
  local markpos=LL[idx]:match("MARKER .- (.-) ")
  local marktemp=LL[idx]:match("MARKER .- .- (.*)")
  if marktemp:sub(1,1)=="\"" then markname=marktemp:match("\"(.-)\"") marktemp=marktemp:match("\".-\" (.*)")
  else markname=marktemp:match("(.-) ") marktemp=marktemp:match(".- (.*)")
  end
  local markcolor=marktemp:match(".- (.-) ")

  return true, markid, markpos, markname, markcolor
end

--A,B,C=ultraschall.GetProject_GetMarker("c:\\audiocd-codes-part1.ini",1)

function ultraschall.GetProject_GetRegion(projectfilenamewithpath, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GetRegion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer shownnumber, number start_of_region, number end_of_region, string regionname, integer regioncolor = ultraschall.GetProject_GetRegion(string projectfilename_with_path, integer idx)</functioncall>
  <description>
    returns the information of the region idx in a projectfile.
    
    It's the entry MARKER
    
    returns false in case of error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfilename from where to get the region
    integer idx - the number of the marker, you want to have the information of
  </parameters>
  <retvals>
    boolean retval - true, in case of success; false in case of failure
    integer shownnumber - the number that is shown with the region in the arrange-view
    number start_of_region - the startposition of the region in seconds
    number end_of_region - the endposition of the region in seconds
    string regionname - the name of the region. "" if no name is given.
    integer regioncolor - the colorvalue of the region
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, region, shown number, name, color, position</tags>
</US_DocBloc>
]]
  if projectfilenamewithpath==nil or type(projectfilenamewithpath)~="string" then ultraschall.AddErrorMessage("GetProject_GetRegion", "projectfilename_with_path", "Must be a string", -5)  return false end
  if reaper.file_exists(projectfilenamewithpath)==false then ultraschall.AddErrorMessage("GetProject_GetRegion", "projectfilenamewithpath", "Projectfile does not exist", -1)  return false end
  idx=tonumber(idx)
  if idx==nil then ultraschall.AddErrorMessage("GetProject_GetRegion", "idx", "No valid value given. Only integer numbers are allowed.", -2)  return false end
  local A,B,C=ultraschall.GetProject_CountMarkersAndRegions(projectfilenamewithpath)
  if tonumber(idx)>B then ultraschall.AddErrorMessage("GetProject_GetRegion", "idx", "Only "..B.." regions available.", -3)  return false end
  if tonumber(idx)<1 then ultraschall.AddErrorMessage("GetProject_GetRegion", "idx", "Only positive values allowed.", -4)  return false end
  local A=ultraschall.ReadValueFromFile(projectfilenamewithpath,"MARKER", false)
  local L,LL=ultraschall.SplitStringAtLineFeedToArray(A)
  
  local regions=0
  local marker=0
  local marktemp, marktemp2
  local count=0
  for i=L,1,-1 do
    if LL[i]:match("MARKER .* (.) .- 1 .")=="0" then table.remove(LL,i) end
  end
  
  for i=1,B*2,2 do
    count=count+1
    if count==idx then
      marktemp=LL[i]
      marktemp2=LL[i+1]
    end
  end
    
  local markname
  local markid=marktemp:match("MARKER (.-) ")
  local markpos=marktemp:match("MARKER .- (.-) ")
  local markendpos=marktemp2:match("MARKER .- (.-) ")
  local marktemp=marktemp:match("MARKER .- .- (.*)")
  if marktemp:sub(1,1)=="\"" then markname=marktemp:match("\"(.-)\"") marktemp=marktemp:match("\".-\" (.*)")
  else markname=marktemp:match("(.-) ") marktemp=marktemp:match(".- (.*)")
  end
  local markcolor=marktemp:match(".- (.-) ")

  return true, markid, markpos, markendpos, markname, markcolor
end




function ultraschall.GetProject_MarkersAndRegions(projectfilename_with_path, ProjectStateChunk)
-- return Reaper-Version and TimeStamp
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MarkersAndRegions</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    Lua=5.3
  </requires>
  <functioncall>integer markerregioncount, integer NumMarker, integer Numregions, array Markertable = ultraschall.GetProject_MarkersAndRegions(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the markers and regions from an RPP-Projectfile or a ProjectStateChunk.
    Doe not return TimeSignature-markers(!)
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    integer markerregioncount - the number of markers and regions in the projectfile/ProjectStateChunk
    array markertable - an array with all elements of markers/regions
                      - markertable has the following entries:
                      - markertable[id][1] = boolean isrgn - true, marker is a region; false, marker is a normal marker
                      - markertable[id][2] = number pos    - the startposition of the marker/region
                      - markertable[id][3] = number rgnend - the endposition of a region; 0, if it's a marker
                      - markertable[id][4] = string name   - the name of the marker/region
                      - markertable[id][5] = integer markrgnindexnumber - the shown number of the region/marker
                      - markertable[id][6] = integer color - the color-value of the marker
                      - markertable[id][7] = string guid - the guid of the marker
                      - markertable[id][8] = if a region: true, region is selected; false, region is not selected
                      - markertable[id][9] = if a region: true, region-render-matrix Master mix is selected; false, region-render-matrix Master mix is unselected
                      - markertable[id][10]= if a region: true, region-render-matrix All tracks is selected; false, region-render-matrix All tracks is unselected

                      MarkerArray[MarkerCount][8]=tonumber(isrgn)&8==8  -- is region selected?
                      MarkerArray[MarkerCount][9]=tonumber(isrgn)&4==4  -- is region-matrix-mastermix selected?
                      MarkerArray[MarkerCount][10]=tonumber(isrgn)&2==2 -- is region-matrix-All tracks selected?
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, marker, regions, guid</tags>
</US_DocBloc>
]]

  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MarkersAndRegions","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MarkersAndRegions","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MarkersAndRegions","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MarkersAndRegions", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  local MarkerArray={}
  local MarkerCount=0
  local NumMarker=0
  local NumRegions=0
  local Markerlist=ProjectStateChunk:match("MARKER.*%<PROJBAY.-\n")
  local endposition=0
  local Offset
  if Markerlist~=nil then Markerlist=Markerlist.."  MARKER" end
  
  while Markerlist~=nil do
    Marker, Offset=Markerlist:match("(MARKER.-\n)()")
    if Offset~=nil then Markerlist=Markerlist:sub(Offset,-1) end
    if Marker==nil then break end
    Marker=Marker:sub(1,-2).." "
    MarkerCount=MarkerCount+1

    local shownnumber, position, name, isrgn, color, unknown, unknown2, guid = Marker:match("MARKER (.-) (.-) \"(.-)\" (.-) (.-) (.-) (.-) (.-) ")
    if name==nil then shownnumber, position, name, isrgn, color, unknown, unknown2, guid = Marker:match("MARKER (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-) ") end
    if tonumber(isrgn)&1==1 then 
      endposition, Markerlist=Markerlist:match("MARKER .- (.-) .-(MARKER.*)") 
    else 
      endposition=0.0 
    end
    
    MarkerArray[MarkerCount]={}
    if tonumber(isrgn)&1==1 then 
      MarkerArray[MarkerCount][1]=true 
      NumRegions=NumRegions+1 
    else 
      MarkerArray[MarkerCount][1]=false 
      NumMarker=NumMarker+1 
    end

    MarkerArray[MarkerCount][2]=tonumber(position)
    MarkerArray[MarkerCount][3]=tonumber(endposition)
    MarkerArray[MarkerCount][4]=name
    MarkerArray[MarkerCount][5]=tonumber(shownnumber)
    MarkerArray[MarkerCount][6]=tonumber(color)
    MarkerArray[MarkerCount][7]=guid
    MarkerArray[MarkerCount][8]=tonumber(isrgn)&8==8  -- is region selected?
    MarkerArray[MarkerCount][9]=tonumber(isrgn)&4==4  -- is region-matrix-mastermix selected?
    MarkerArray[MarkerCount][10]=tonumber(isrgn)&2==2 -- is region-matrix-All tracks selected?
  end
  return MarkerCount, NumMarker, NumRegions, MarkerArray
end



function ultraschall.NewProjectTab(switch_to_new_tab)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>NewProjectTab</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>ReaProject newproject = ultraschall.NewProjectTab(boolean switch_to_new_tab)</functioncall>
  <description>
    Opens a new projecttab and optionally switches to it. Returns the newly created ReaProject.
    
    returns nil in case of an error
  </description>
  <retvals>
    ReaProject newproject - the newly created project-object of the projecttab
  </retvals>
  <parameters>
    boolean switch_to_new_tab - true, switch to the newly created project-tab; false, stay in the "old" project-tab
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, new, project, tab, switch, select</tags>
</US_DocBloc>
--]]
  if type(switch_to_new_tab)~="boolean" then ultraschall.AddErrorMessage("NewProjectTab", "switch_to_new_tab", "Must be a boolean", -1) return end
  reaper.PreventUIRefresh(1)
  local currentProj=reaper.EnumProjects(-1,"")
  reaper.Main_OnCommand(40859,0)
  local newProj=reaper.EnumProjects(-1,"")
  if switch_to_new_tab==false then reaper.SelectProjectInstance(currentProj) end
  reaper.PreventUIRefresh(-1)
  return newProj
end

--L=ultraschall.OpenNewProjectTab(false)


function ultraschall.GetCurrentTimeLengthOfFrame(ReaProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCurrentTimeLengthOfFrame</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>number length = ultraschall.GetCurrentTimeLengthOfFrame(ReaProject ReaProject)</functioncall>
  <description>
    Returns a project's length of a frame in seconds. Depends on the fps set in the Project's settings of ReaProject.
    
    Returns -1 in case of an error
  </description>
  <retvals>
    number length - the current length of a frame of ReaProject in seconds
  </retvals>
  <parameters>
    ReaProject ReaProject - the project to check for; use nil or 0 for the current project
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, new, project, tab, switch, select</tags>
</US_DocBloc>
--]]
  if ReaProject~=nil and ReaProject~=0 and ultraschall.IsValidReaProject(ReaProject)==false then ultraschall.AddErrorMessage("GetCurrentTimeLengthOfFrame", "ReaProject", "Must be valid ReaProject", -1) return -1 end  
  if ReaProject==nil then ReaProject=0 end
  
  return 1/reaper.TimeMap_curFrameRate(ReaProject)
end

--A=ultraschall.GetCurrentTimeLengthOfFrame(reaper.EnumProjects(2,""))

function ultraschall.GetLengthOfFrames(frames, ReaProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLengthOfFrames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>number length = ultraschall.GetLengthOfFrames(integer frames, ReaProject ReaProject)</functioncall>
  <description>
    Returns the length of a number of frames of a ReaProject. Depends on the fps set in the Project's settings of ReaProject.
    
    Returns -1 in case of an error
  </description>
  <retvals>
    number length - the current length of frames of ReaProject in seconds
  </retvals>
  <parameters>
    integer frames - the number of frames, whose length you would love to know
    ReaProject ReaProject - the project to check for; use nil or 0 for the current project
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, new, project, tab, switch, select</tags>
</US_DocBloc>
--]]
  if math.type(frames)~="integer" then ultraschall.AddErrorMessage("GetLengthOfFrames", "frames", "Must be an integer", -2) return -1 end  
  if ReaProject~=nil and ReaProject~=0 and ultraschall.IsValidReaProject(ReaProject)==false then ultraschall.AddErrorMessage("GetLengthOfFrames", "ReaProject", "Must be valid ReaProject", -1) return -1 end
  if ReaProject==nil then ReaProject=0 end
  
  return frames*(1/reaper.TimeMap_curFrameRate(ReaProject))
end

--A=ultraschall.GetLengthOfFrames(200, 0)


function ultraschall.ConvertOldProjectToCurrentReaperVersion(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertOldProjectToCurrentReaperVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ConvertOldProjectToCurrentReaperVersion(string filename_with_path)</functioncall>
  <description>
    Convert an old Reaper-project to the current Reaper-version.
    It creates a backup-copy of the old version of the project.rpp to project.rpp~0
    After that, it will open the project and save it again, so it is saved with the newest version of Reaper.
    
    Maybe helpful, when you want to use the Ultraschall-API Get/SetProject-State-functions on older projects, where some states were saved differently.
    Just create a "new" version of it and use the aforementioned functions on the new project-version.
    
    Returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, conversion was successfull; false, conversion wasn't successful(file doesn't exist or a copy can't be created)
  </retvals>
  <parameters>
    string filename_with_path - the filename with path of the rpp-projectfile to be converted.
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, convert, old, project, rpp, current, reaper version</tags>
</US_DocBloc>
--]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ConvertOldProjectToCurrentReaperVersion", "filename_with_path", "Must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ConvertOldProjectToCurrentReaperVersion", "filename_with_path", "File does not exist", -2)  return false end
  local tempname = ultraschall.CreateValidTempFile(filename_with_path, true, "", false)
  local A = ultraschall.MakeCopyOfFile(filename_with_path, tempname)
  if A==false then ultraschall.AddErrorMessage("ConvertOldProjectToCurrentReaperVersion", "filename_with_path", "Can't create backup-copy", -3)  return false end
  ultraschall.NewProjectTab(true)
  reaper.Main_openProject(filename_with_path)
  reaper.Main_SaveProject(0,false)
  reaper.Main_OnCommand(40860,0)  
end

--AA=ultraschall.ConvertOldProjectToCurrentReaperVersion("c:\\Users\\meo\\Desktop\\TRSS\\ChristmasInJuly\\SquarryShow-Rec1\\SquarryShow-Rec1.RPP")



function ultraschall.GetProject_ProjectBay(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_ProjectBay</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string ProjectBayStateChunk = ultraschall.GetProject_ProjectBay(string ProjectStateChunk, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the ProjectBay-StateChunk, that holds MediaItems, that shall be retained in the "background" of the project, even if they are deleted from the project.
    These MediaItems can be seen and set to retain from within the ProjectBay-window.

    It's the entry &lt;PROJBAY ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the projectbay-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string ProjectBayStateChunk - the statechunk of the ProjectBay
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, projectbay, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_ProjectBay","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ProjectBay","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_ProjectBay","projectfilename_with_path", "File does not exist!", -3) return nil
    end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_ProjectBay", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<PROJBAY.-\n  >")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B=ultraschall.GetProject_ProjectBay("c:\\automitem\\automitem.rpp")



function ultraschall.GetProject_Metronome(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Metronome</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MetronomeStateChunk = ultraschall.GetProject_Metronome(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Metronome-StateChunk, that holds metronome-settings.
    
    It's the entry &lt;METRONOME ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the metronome-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MetronomeStateChunk - the statechunk of the Metronome
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, metronome, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Metronome","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Metronome","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Metronome","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Metronome", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<METRONOME.-  >")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B=ultraschall.GetProject_Metronome("c:\\automitem\\automitem.rpp",A)

--reaper.MB(B,"",0)

function ultraschall.GetProject_MasterPlayspeed(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterPlayspeed</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterPlayspeedStateChunk = ultraschall.GetProject_MasterPlayspeed(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-Playspeed-StateChunk, that holds Playspeed-settings of the master.
    
    It's the entry &lt;MASTERPLAYSPEEDENV ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-playspeed-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterPlayspeedStateChunk - the statechunk of the MasterPlaySpeed
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master playspeed, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterPlayspeed","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterPlayspeed","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterPlayspeed","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterPlayspeed", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERPLAYSPEEDENV.-  >")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B=ultraschall.GetProjectMasterPlaysp_ProjectStateChunk(nil, A)

--reaper.MB(B,"",0)

function ultraschall.GetProject_TempoEnvEx(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TempoEnvEx</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string TempoStateChunk = ultraschall.GetProject_TempoEnvEx(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Tempo-StateChunk, that holds tempo-settings of the master.
    
    It's the entry &lt;TEMPOENVEX ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the tempo-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string TempoStateChunk - the statechunk of the Tempo
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, tempo, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Tempo","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Tempo","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Tempo","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Tempo", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<TEMPOENVEX.-  >")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B=ultraschall.GetProject_Tempo("c:\\automitem\\automitem.rpp",A)

--reaper.MB("TUDELU"..B.."TUDELU","",0)

function ultraschall.GetProject_Extensions(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Extensions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string ExtensionsStateChunk = ultraschall.GetProject_Extensions(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Extensions-settings-StateChunk, that holds tempo-settings of the master.
    
    It's the entry &lt;EXTENSIONS ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the extension-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string ExtensionsStateChunk - the statechunk of the Extensions-settings
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, extensions, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Extensions","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Extensions","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Extensions","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Extensions", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<EXTENSIONS.-\n  >")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B=ultraschall.GetProject_Extensions("c:\\automitem\\automitem.rpp",A)

function ultraschall.GetProject_Lock(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Lock</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer lock_state = ultraschall.GetProject_Lock(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the individual lock-settings of the project, as set in menu Options -> Locking -> Locking Settings
    
    It's the entry LOCK 
    It is the one before(!) any <TRACK-tags !
    
    It is a bitfield, containing numerous settings.
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the lock-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer lock_state - the lock-state, which is a bitfield
                      - &1     - Time selection
                      - &2     - Items (full)
                      - &4     - Track envelopes
                      - &8     - Markers
                      - &16    - Regions
                      - &32    - Time signature markers
                      - &64    - Items (prevent left/right movement)
                      - &128   - Items (prevent up/down movement)
                      - &256   - Item edges
                      - &512   - Item fade/volume handles
                      - &1024  - Loop points locked
                      - &2048  - Item envelopes
                      - &4096  - Item stretch markers
                      - &16384 - Enable locking
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, lock, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "\n  LOCK", ProjectStateChunk, "GetProject_Lock")
end

--reaper.MB(B,"",0)

function ultraschall.GetProject_GlobalAuto(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GlobalAuto</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer globalauto_state = ultraschall.GetProject_GlobalAuto(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the global-automation-settings of the project.
    
    It's the entry GLOBAL_AUTO
    
    returns nil in case of an error or if the setting isn't existing
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the global-automation-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer globalauto_state  - the global automation override state, this sets the same automation mode to all tracks!
                              - -1, No global automation override, automation-mode will be set by track
                              - 0, trim/read mode
                              - 1, read mode
                              - 2, touch mode
                              - 3, write mode
                              - 4, latch mode
                              - 5, latch preview mode
                              - 6, bypass all automation
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, global automation, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "GLOBAL_AUTO", ProjectStateChunk, "GetProject_GlobalAuto")
end


function ultraschall.GetProject_Tempo(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Tempo</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number bpm, integer beat, integer denominator = ultraschall.GetProject_Tempo(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the tempo-settings of the project, as set in the Project Settings -> Project Settings-tab
    
    It's the entry TEMPO
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the tempo-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    number bpm - the tempo of the project in bpm
    integer beat - the beat of the project
    integer denominator - the denominator for the beat
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, beat, tempo, denominator, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "TEMPO", ProjectStateChunk, "GetProject_Tempo")
end



function ultraschall.GetProject_Playrate(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Playrate</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number playrate, integer preserve_pitch, number min_playrate, number max_playrate = ultraschall.GetProject_Playrate(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the tempo-settings of the project, as set in the Project Settings -> Project Settings-tab
    
    It's the entry PLAYRATE
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the playrate-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    number playrate - the currently set playrate; 0.01 to 10
    integer preserve_pitch - 0, don't preserve pitch, when changing playrate; 1, preserve pitch, when changing playrate
    number min_playrate - the minimum playrate possible in the project; 0.01 to 10
    number max_playrate - the maximum playrate possible in the project; 0.01 to 10
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, playrate, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "PLAYRATE", ProjectStateChunk, "GetProject_Playrate")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_Playrate("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_MasterAutomode(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterAutomode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer automode = ultraschall.GetProject_MasterAutomode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the automation-mode of the master-track of the project, as set in the "Envelopes for Master Track"-dialog or the context-menu for the Master Track -> Set track automation mode -> ...
    
    It's the entry MASTERAUTOMODE
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-automation-mode; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer automode - the automation-mode, as set in the Envelopes for Master Track
                     - 0, Trim/Read
                     - 1, Read
                     - 2, Touch
                     - 3, Write
                     - 4, Latch
                     - 5, Latch Preview
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, automation mode, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTERAUTOMODE", ProjectStateChunk, "GetProject_MasterAutomode")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterAutomode("c:\\automitem\\automitem.RPP",A)


function ultraschall.GetProject_MasterSel(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterSel</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer selection = ultraschall.GetProject_MasterSel(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-track-selection-state of the master-track of the project.
    
    It's the entry MASTER_SEL
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-selection; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer selection - the selection-state; 0, master-track unselected; 1, master-track selected
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, selected, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_SEL", ProjectStateChunk, "GetProject_MasterSel")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterSel("c:\\automitem\\automitem.RPP",A)


function ultraschall.GetProject_MasterFXByp(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterFXByp</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer fx_byp_state = ultraschall.GetProject_MasterFXByp(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the fx-bypass-state of the master-track of the project.
    
    It's the entry MASTER_FX
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-fx-bypass-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer fx_byp_state - the fx-bypass-state; 0, master-track-fx bypassed; 1, master-track-fx normal
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, fx, bypass, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_FX", ProjectStateChunk, "GetProject_MasterFXByp")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterFXByp("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_MasterMuteSolo(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterMuteSolo</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer mute_solo_state = ultraschall.GetProject_MasterMuteSolo(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the mute-solo-state of the master-track of the project.
    Has no exclusive-solo/mute-settings!
    
    It's the entry MASTERMUTESOLO
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-mute-solo-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer mute_solo_state - the mute-solo-state; it is a bitfield
                            - 0, no mute, no solo, Mono mode L+R
                            - &1, master-track muted
                            - &2, master-track soloed
                            - &4, master-track mono-button
                            - &8, Mono mode:L
                            - &16, Mono mode:R
                            - add 24 for Mono mode L-R
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, mute, solo, mono, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTERMUTESOLO", ProjectStateChunk, "GetProject_MasterMuteSolo")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterMuteSolo("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_MasterNChans(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterNChans</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer number_of_channels, integer peak_metering = ultraschall.GetProject_MasterNChans(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the number of output channels-settings and the vu-peak-metering-settings of the master-track of the project.

    It's the entry MASTER_NCH
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-nchans; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer number_of_channels - the number of output-channels, as set in the "Outputs for the Master Channel -> Track Channels"-dialog
    integer peak_metering - 2, Multichannel peak metering-setting, as set in the "Master VU settings"-dialog
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, number of channels, master track, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_NCH", ProjectStateChunk, "GetProject_MasterNChans")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterNChans("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_MasterTrackHeight(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterTrackHeight</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer height_state, integer height_lock = ultraschall.GetProject_MasterTrackHeight(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-trackheight-states of the master-track of the project.
    
    It's the entry MASTERTRACKHEIGHT
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the mastertrackheight-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer height_state - the current-height of the master-track, from 24 to 260
    integer height_lock - 0, height-lock is off; 1, height-lock is on
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, trackheight, trackheightlock, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTERTRACKHEIGHT", ProjectStateChunk, "GetProject_MasterTrackHeight")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterTrackHeight("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_MasterTrackColor(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterTrackColor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer color = ultraschall.GetProject_MasterTrackColor(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-color of the master-track of the project.
    
    It's the entry MASTERPEAKCOL
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the mastertrack-color; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer color - the color for the master-track
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, color, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTERPEAKCOL", ProjectStateChunk, "GetProject_MasterTrackColor")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4=ultraschall.GetProject_MasterTrackColor("c:\\automitem\\automitem.RPP",A)


function ultraschall.GetProject_MasterTrackView(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterTrackView</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>integer tcp_visibility, number state2, number state3, number state4, integer state5, integer state6, integer state7, integer state8, integer state9, integer state10, integer state11, integer state12, number state13 = ultraschall.GetProject_MasterTrackView(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-view-state of the master-track of the project or a ProjectStateChunk.
    
    It's the entry MASTERTRACKVIEW
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the trackview-states; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer tcp_visibility - 0, Master-track is invisible in MCP; 1, Master-track is visible in MCP
    number state2 - unknown
    number state3 - unknown
    number state4 - unknown
    integer state5 - unknown
    integer state6 - unknown
    integer state7 - unknown
    integer state8 - unknown
    integer state9 - unknown
    integer state10 - unknown
    integer state11 - unknown
    integer state12 - unknown
    integer state13 - unknown
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, view, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTERTRACKVIEW", ProjectStateChunk, "GetProject_MasterTrackView")
end

 
--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_MasterTrackView("c:\\automitem\\automitem.RPP",A)

function ultraschall.GetProject_CountMasterHWOuts(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_CountMasterHWOuts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer count_of_hwouts = ultraschall.GetProject_CountMasterHWOuts(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the number of available hwouts in an rpp-project or ProjectStateChunk
    
    It's the entry MASTERHWOUT
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to count the master-hwouts; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer count_of_hwouts - the number of available hwouts in an rpp-project or ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, count, hwout, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_CountMasterHWOuts","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_CountMasterHWOuts","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_CountMasterHWOuts","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_CountMasterHWOuts", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  local offset=""
  local count=0
  while offset~=nil do
    offset,ProjectStateChunk=ProjectStateChunk:match("MASTERHWOUT .-\n()(.*)")
    if offset~=nil then count=count+1 end
  end

  return count
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--Count,L,LL,LLL=ultraschall.GetProject_CountMasterHWOuts(nil,A)

function ultraschall.GetProject_MasterHWOut(projectfilename_with_path, idx, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterHWOut</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer state1, integer state2, number volume, number pan, integer mute, integer phase, integer output_channels, number state8 = ultraschall.GetProject_MasterHWOut(string projectfilename_with_path, integer idx, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the HWOut of the master-track of the project, as set in the "Outputs for Master Track"-dialog
    There can be multiple HWOuts for the Master-Track.
    
    It's the entry MASTERHWOUT
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-hwout-states; nil to use ProjectStateChunk
    integer idx - the number of the requested HWOut-setting; 1 for the first, etc.
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer state1 - unknown
    integer state2 - unknown
    number volume - volume of the HWOut; 
    number pan - the panning; -1(left), 1(right), 0(center)
    integer mute - mute-state; 0, unmuted; 1, muted
    integer phase - phase-inversion; 0, normal phase; 1, inversed phase
    integer output_channels -        -1 - None
                                     0 - Stereo Source 1/2
                                     4 - Stereo Source 5/6
                                    12 - New Channels On Sending Track Stereo Source Channel 13/14
                                    1024 - Mono Source 1
                                    1029 - Mono Source 6
                                    1030 - New Channels On Sending Track Mono Source Channel 7
                                    1032 - New Channels On Sending Track Mono Source Channel 9
                                    2048 - MultiChannel 4 Channels 1-4
                                    2050 - Multichannel 4 Channels 3-6
                                    3072 - Multichannel 6 Channels 1-6 
    number state8 - unknown
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, hwout, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterHWOut","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterHWOut","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterHWOut","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterHWOut", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetProject_MasterHWOut","idx", "must be an integer!", -4) return nil end
  local count=ultraschall.GetProject_CountMasterHWOuts(nil, ProjectStateChunk)
  
  if idx<1 or idx>count then ultraschall.AddErrorMessage("GetProject_MasterHWOut","idx", "no such hwout!", -5) return nil end
  local offset
  for i=1, idx-1 do
    offset,ProjectStateChunk=ProjectStateChunk:match("MASTERHWOUT .-\n()(.*)")
  end
  local a,b,c,d,e,f,g,h=ProjectStateChunk:match("MASTERHWOUT (.-) (.-) (.-) (.-) (.-) (.-) (.-) (.-)\n")
  return tonumber(a), tonumber(b), tonumber(c), tonumber(d), tonumber(e), tonumber(f), tonumber(g), tonumber(h)
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_MasterHWOut("c:\\automitem\\automitem.RPP", 1, A)

function ultraschall.GetProject_MasterVolume(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterVolume</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number volume, number pan, number pan_law, number state4, number pan_knob3 = ultraschall.GetProject_MasterVolume(string projectfilename_with_path, integer idx, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-volume-state of the master-track of the project.
    
    It's the entry MASTER_VOLUME
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-volume-states; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    number volume - Volume; 0(-inf dB) to 3.981071705535(+12dB);1 for 0dB
    number pan - Panning; -1(left), 1(right), 0(center)
    number pan_law - Pan_Law, as set in the "Pan Law: Master Track"-dialog; 1(0dB); 0.5(-6.02dB)
    number state4 - unknown
    number pan_knob3 - the second pan_knob for pan-mode "Dual Pan" 
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, mastervolume, pan, volume, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_VOLUME", ProjectStateChunk, "GetProject_MasterVolume")
end

--A=ultraschall.ReadFullFile("c:\\automitem\\automitem.rpp")
--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_MasterVolume("c:\\automitem\\automitem.RPP", A)

function ultraschall.GetProject_MasterPanMode(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterPanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer panmode = ultraschall.GetProject_MasterPanMode(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-panmode of the master-track of the project.
    
    It's the entry MASTER_PANMODE
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-panmode; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer panmode - the panmode for the master-track; 
                    -  -1, Project default (Stereo balance)
                    -   3, Stereo balance  / mono pan(default)
                    -   5, Stereo Pan
                    -   6, Dual Pan
                    -   nil, REAPER 3.x balance(deprecated)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, panmode, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_PANMODE", ProjectStateChunk, "GetProject_MasterPanMode")
end

--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_MasterPanMode("c:\\automitem\\automitem.RPP", A)


function ultraschall.GetProject_MasterWidth(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number pan_knob_two = ultraschall.GetProject_MasterWidth(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-width for the second pan-knob in stereo pan-modes, of the master-track of the project.
    
    It's the entry MASTER_WIDTH
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the masterwidth-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    number pan_knob_two - -1(left), 1(right), 0(center)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, pan knob two, projectstatechunk</tags>
</US_DocBloc>
]]
  local A=ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "MASTER_WIDTH", ProjectStateChunk, "GetProject_MasterWidth")
  if A==nil then return 1 else return A end
end

--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_MasterWidth("c:\\automitem\\automitem.RPP", A)

function ultraschall.GetProject_MasterGroupFlagsState(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterGroupFlagsState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer GroupState_as_Flags, array IndividualGroupState_Flags = ultraschall.GetProject_MasterGroupFlagsState(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the state of the group-flags for the Master-Track, as set in the menu Track Grouping Parameters; from an rpp-projectfile or a ProjectStateChunk. 
    
    Returns a 23bit flagvalue as well as an array with 32 individual 23bit-flagvalues. You must use bitoperations to get the individual values.
    
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table contains up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to get Volume Master(table entry 1) to check if it's set in Group 1(2^0=1) and 3(2^2=4):
      group1=groups_bitfield_table[1]&1
      group2=groups_bitfield_table[1]&4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Slave
                           3 - Pan Master
                           4 - Pan Slave
                           5 - Mute Master
                           6 - Mute Slave
                           7 - Solo Master
                           8 - Solo Slave
                           9 - Record Arm Master
                           10 - Record Arm Slave
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Slave
                           13 - Automation Mode Master
                           14 - Automation Mode Slave
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Slave
                           21 - VCA Master
                           22 - VCA Slave
                           23 - VCA pre-FX slave
    
    The GroupState_as_Flags-bitfield is a hint, if a certain flag is set in any of the groups. So, if you want to know, if VCA Master is set in any group, check if flag &1048576 (2^20) is set to 1048576.
    
    This function will work only for Groups 1 to 32. To get Groups 33 to 64, use <a href="#GetTrackGroupFlags_HighState">GetTrackGroupFlags_HighState</a> instead!
    
    It's the entry MASTER_GROUP_FLAGS
    
    returns -1 in case of failure
  </description>
  <retvals>
    integer GroupState_as_Flags - returns a flagvalue with 23 bits, that tells you, which grouping-flag is set in at least one of the 32 groups available.
    -returns -1 in case of failure
    -
    -the following flags are available:
    -2^0 - Volume Master
    -2^1 - Volume Slave
    -2^2 - Pan Master
    -2^3 - Pan Slave
    -2^4 - Mute Master
    -2^5 - Mute Slave
    -2^6 - Solo Master
    -2^7 - Solo Slave
    -2^8 - Record Arm Master
    -2^9 - Record Arm Slave
    -2^10 - Polarity/Phase Master
    -2^11 - Polarity/Phase Slave
    -2^12 - Automation Mode Master
    -2^13 - Automation Mode Slave
    -2^14 - Reverse Volume
    -2^15 - Reverse Pan
    -2^16 - Do not master when slaving
    -2^17 - Reverse Width
    -2^18 - Width Master
    -2^19 - Width Slave
    -2^20 - VCA Master
    -2^21 - VCA Slave
    -2^22 - VCA pre-FX slave
    
     array IndividualGroupState_Flags  - returns an array with 23 entries. Every entry represents one of the GroupState_as_Flags, but it's value is a flag, that describes, in which of the 32 Groups a certain flag is set.
    -e.g. If Volume Master is set only in Group 1, entry 1 in the array will be set to 1. If Volume Master is set on Group 2 and Group 4, the first entry in the array will be set to 10.
    -refer to the upper GroupState_as_Flags list to see, which entry in the array is for which set flag, e.g. array[22] is VCA pre-F slave, array[16] is Do not master when slaving, etc
    -As said before, the values in each entry is a flag, that tells you, which of the groups is set with a certain flag. The following flags determine, in which group a certain flag is set:
    -2^0 - Group 1
    -2^1 - Group 2
    -2^2 - Group 3
    -2^3 - Group 4
    -...
    -2^30 - Group 31
    -2^31 - Group 32
  </retvals>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the groups-state-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, groupflags, projectstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsState","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsState","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsState","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsState", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end

  local Project_TrackGroupFlags=ProjectStateChunk:match("MASTER_GROUP_FLAGS.-%c") 
  if Project_TrackGroupFlags==nil then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsState", "", "no trackgroupflags available", -5) return -1 end
  
  
  -- get groupflags-state
  local retval=0  
  local GroupflagString = Project_TrackGroupFlags:match("MASTER_GROUP_FLAGS (.-)%c")
  local count, Tracktable=ultraschall.CSV2IndividualLinesAsArray(GroupflagString, " ")

  for i=1,23 do
    Tracktable[i]=tonumber(Tracktable[i])
    if Tracktable[i]~=nil and Tracktable[i]>=1 then retval=retval+2^(i-1) end
  end
  
  return retval, Tracktable
end

--A,A1=ultraschall.GetProject_MasterGroupFlagsState("c:\\automitem\\automitem.RPP", A)


function ultraschall.GetProject_MasterGroupFlagsHighState(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterGroupFlagsHighState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer GroupState_as_Flags, array IndividualGroupState_Flags = ultraschall.GetProject_MasterGroupFlagsHighState(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the state of the group-high-flags for the Master-Track, as set in the menu Track Grouping Parameters; from an rpp-projectfile or a ProjectStateChunk. 
    
    Returns a 23bit flagvalue as well as an array with 32 individual 23bit-flagvalues. You must use bitoperations to get the individual values.
    
    You can reach the Group-Flag-Settings in the context-menu of a track.
    
    The groups_bitfield_table contains up to 23 entries. Every entry represents one of the checkboxes in the Track grouping parameters-dialog
    
    Each entry is a bitfield, that represents the groups, in which this flag is set to checked or unchecked.
    
    So if you want to get Volume Master(table entry 1) to check if it's set in Group 1(2^0=1) and 3(2^2=4):
      group1=groups_bitfield_table[1]&1
      group2=groups_bitfield_table[1]&4
    
    The following flags(and their accompanying array-entry-index) are available:
                           1 - Volume Master
                           2 - Volume Slave
                           3 - Pan Master
                           4 - Pan Slave
                           5 - Mute Master
                           6 - Mute Slave
                           7 - Solo Master
                           8 - Solo Slave
                           9 - Record Arm Master
                           10 - Record Arm Slave
                           11 - Polarity/Phase Master
                           12 - Polarity/Phase Slave
                           13 - Automation Mode Master
                           14 - Automation Mode Slave
                           15 - Reverse Volume
                           16 - Reverse Pan
                           17 - Do not master when slaving
                           18 - Reverse Width
                           19 - Width Master
                           20 - Width Slave
                           21 - VCA Master
                           22 - VCA Slave
                           23 - VCA pre-FX slave
    
    The GroupState_as_Flags-bitfield is a hint, if a certain flag is set in any of the groups. So, if you want to know, if VCA Master is set in any group, check if flag &1048576 (2^20) is set to 1048576.
    
    This function will work only for Groups 1 to 32. To get Groups 33 to 64, use <a href="#GetTrackGroupFlags_HighState">GetTrackGroupFlags_HighState</a> instead!
    
    It's the entry MASTER_GROUP_FLAGS_HIGH
    
    returns -1 in case of failure
  </description>
  <retvals>
    integer GroupState_as_Flags - returns a flagvalue with 23 bits, that tells you, which grouping-flag is set in at least one of the 32 groups available.
    -returns -1 in case of failure
    -
    -the following flags are available:
    -2^0 - Volume Master
    -2^1 - Volume Slave
    -2^2 - Pan Master
    -2^3 - Pan Slave
    -2^4 - Mute Master
    -2^5 - Mute Slave
    -2^6 - Solo Master
    -2^7 - Solo Slave
    -2^8 - Record Arm Master
    -2^9 - Record Arm Slave
    -2^10 - Polarity/Phase Master
    -2^11 - Polarity/Phase Slave
    -2^12 - Automation Mode Master
    -2^13 - Automation Mode Slave
    -2^14 - Reverse Volume
    -2^15 - Reverse Pan
    -2^16 - Do not master when slaving
    -2^17 - Reverse Width
    -2^18 - Width Master
    -2^19 - Width Slave
    -2^20 - VCA Master
    -2^21 - VCA Slave
    -2^22 - VCA pre-FX slave
    
     array IndividualGroupState_Flags  - returns an array with 23 entries. Every entry represents one of the GroupState_as_Flags, but it's value is a flag, that describes, in which of the 32 Groups a certain flag is set.
    -e.g. If Volume Master is set only in Group 1, entry 1 in the array will be set to 1. If Volume Master is set on Group 2 and Group 4, the first entry in the array will be set to 10.
    -refer to the upper GroupState_as_Flags list to see, which entry in the array is for which set flag, e.g. array[22] is VCA pre-F slave, array[16] is Do not master when slaving, etc
    -As said before, the values in each entry is a flag, that tells you, which of the groups is set with a certain flag. The following flags determine, in which group a certain flag is set:
    -2^0 - Group 1
    -2^1 - Group 2
    -2^2 - Group 3
    -2^3 - Group 4
    -...
    -2^30 - Group 31
    -2^31 - Group 32
  </retvals>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the groupshigh-state-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, groupflags, projectstatechunk</tags>
</US_DocBloc>
--]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsHighState","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsHighState","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsHighState","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsHighState", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end

  local Project_TrackGroupFlags=ProjectStateChunk:match("MASTER_GROUP_FLAGS_HIGH.-%c") 
  if Project_TrackGroupFlags==nil then ultraschall.AddErrorMessage("GetProject_MasterGroupFlagsHighState", "", "no trackgroupflags available", -5) return -1 end
  
  
  -- get groupflags-state
  local retval=0  
  local GroupflagString = Project_TrackGroupFlags:match("MASTER_GROUP_FLAGS_HIGH (.-)%c")
  local count, Tracktable=ultraschall.CSV2IndividualLinesAsArray(GroupflagString, " ")

  for i=1,23 do
    Tracktable[i]=tonumber(Tracktable[i])
    if Tracktable[i]~=nil and Tracktable[i]>=1 then retval=retval+2^(i-1) end
  end
  
  return retval, Tracktable
end

--A,A1=ultraschall.GetProject_MasterGroupFlagsHighState("c:\\automitem\\automitem.RPP", A)


function ultraschall.GetProject_GroupDisabled(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GroupDisabled</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer disabled1, integer disabled2 = ultraschall.GetProject_GroupDisabled(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the group-disabled-stated, of the master-track of the project.
    
    It's the entry GROUPS_DISABLED
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the groups-disabled-state; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer disabled1 - the disabled groups; it is a bitfield, with &1 for group 1; &32 for group 32; if it's set, the accompanying group is disabled
    integer disabled2 - the disabled groups_high; it is a bitfield, with &1 for group 33; &32 for group 64; if it's set, the accompanying group is disabled
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, group, disabled, projectstatechunk</tags>
</US_DocBloc>
]]
  local A,B=ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "GROUPS_DISABLED", ProjectStateChunk, "GetProject_GroupDisabled")
  if A==nil then A=0 end
  if B==nil then B=0 end
  return A,B
end

--B,B2,B3,B4,B5,B6,B7,B8=ultraschall.GetProject_GroupDisabled("c:\\automitem\\automitem.RPP", A)

function ultraschall.GetProject_MasterHWVolEnvStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterHWVolEnvStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterHWVolEnvStateChunk = ultraschall.GetProject_MasterHWVolEnvStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-HWVolEnv-StateChunk, that holds MasterHWVolEnv-settings of the master.
    
    It's the entry &lt;MASTERHWVOLENV ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-hwvolenv-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterHWVolEnvStateChunk - the statechunk of the HWVolEnv
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master hwvolend, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterHWVolEnvStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterHWVolEnvStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterHWVolEnvStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterHWVolEnvStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERHWVOLENV.->")
end

--MasterHWVolEnvStateChunk = ultraschall.GetProject_MasterHWVolEnvStateChunk("c:\\automitem\\automitem.RPP", "")

function ultraschall.GetProject_MasterFXListStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterFXListStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterFXListStateChunk = ultraschall.GetProject_MasterFXListStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-FX_List-StateChunk, that holds Master-FX-settings for the window as well as the FX themselves, of the master.
    
    It's the entry &lt;MASTERFXLIST ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-fxlist-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterFXListStateChunk - the statechunk of the Master-FX-list
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master fxlist, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterFXListStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterFXListStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterFXListStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterFXListStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERFXLIST.->")
end

--A = ultraschall.GetProject_MasterFXListStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterDualPanEnvStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterDualPanEnvStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterDualPanEnvStateChunk = ultraschall.GetProject_MasterDualPanEnvStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-DualPanEnv-StateChunk, that holds MasterDualPanEnv-settings of the master.
    
    It's the entry &lt;MASTERDUALPANENV ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-dualpan-env-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterDualPanEnvStateChunk - the statechunk of the Master-DualPan-Env-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master dualpanenv, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERDUALPANENV\n.->")
end

--A = ultraschall.GetProject_MasterDualPanEnvStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterDualPanEnv2StateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterDualPanEnv2StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterDualPanEnv2StateChunk = ultraschall.GetProject_MasterDualPanEnv2StateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-DualPanEnv2-StateChunk, that holds master-DualPanEnv2-settings of the master.
    
    It's the entry &lt;MASTERDUALPANENV2 ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-dualpan-env2-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterDualPanEnvStateChunk - the statechunk of the Master-DualPan-Env-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master dualpanenv2, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnv2StateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnv2StateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterDualPanEnv2StateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnv2StateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERDUALPANENV2\n.->")
end

--A = ultraschall.GetProject_MasterDualPanEnvStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterDualPanEnvLStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterDualPanEnvLStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterDualPanEnvLStateChunk = ultraschall.GetProject_MasterDualPanEnvLStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-DualPan-EnvL-StateChunk, that holds Master-DualPan-EnvL-settings of the master.
    
    It's the entry &lt;MASTERDUALPANENVL ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-dualpan-envL-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterDualPanEnvLStateChunk - the statechunk of the Master-DualPan-EnvL-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master dualpanenvl, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvLStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvLStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvLStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvLStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERDUALPANENVL\n.->")
end

--A = ultraschall.GetProject_MasterDualPanEnvLStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterDualPanEnvL2StateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterDualPanEnvL2StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterDualPanEnvL2StateChunk = ultraschall.GetProject_MasterDualPanEnvL2StateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-Dual-Pan-EnvL2-StateChunk, that holds Master-FX-Dual-Pan-EnvL2-settings of the master.
    
    It's the entry &lt;MASTERDUALPANENVL2 ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-dualpan-envL2-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterDualPanEnvL2StateChunk - the statechunk of the Master-DualPan-EnvL2-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master dualpanenvl2, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvL2StateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvL2StateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvL2StateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterDualPanEnvL2StateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERDUALPANENVL2\n.->")
end

--A = ultraschall.GetProject_MasterDualPanEnvL2StateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterVolEnvStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterVolEnvStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterVolEnvStateChunk = ultraschall.GetProject_MasterVolEnvStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-Vol-Env-StateChunk, that holds Master-Vol-Env-settings of the master.
    
    It's the entry &lt;MASTERVOLENV ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-volenv-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterVolEnvStateChunk - the statechunk of the Master-volenv-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master volenv, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterVolEnvStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnvStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterVolEnvStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnvStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERVOLENV\n.->")
end

--A = ultraschall.GetProject_MasterVolEnvStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)


function ultraschall.GetProject_MasterVolEnv2StateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterVolEnv2StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterVolEnv2StateChunk = ultraschall.GetProject_MasterVolEnv2StateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-Vol-Env2-StateChunk, that holds Master-Vol-Env2-settings of the master.
    
    It's the entry &lt;MASTERVOLENV2 ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-volenv2-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterVolEnv2StateChunk - the statechunk of the Master-volenv2-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master volenv2, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterVolEnv2StateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv2StateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterVolEnv2StateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv2StateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERVOLENV2\n.->")
end

--A = ultraschall.GetProject_MasterVolEnvStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterVolEnv3StateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterVolEnv3StateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterVolEnv3StateChunk = ultraschall.GetProject_MasterVolEnv3StateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-Vol-Env3-StateChunk, that holds Master-Vol-Env3-settings of the master.
    
    It's the entry &lt;MASTERVOLENV3 ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-volenv3-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterVolEnv3StateChunk - the statechunk of the Master-volenv3-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master volenv3, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERVOLENV3\n.->")
end

--A = ultraschall.GetProject_MasterVolEnv2StateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterHWPanEnvStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterHWPanEnvStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterHWPanEnvStateChunk = ultraschall.GetProject_MasterHWPanEnvStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-HW-pan-env-StateChunk, that holds Master-pan-env-settings of the master.
    
    It's the entry &lt;MASTERHWPANENV ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-HW-pan-env-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterHWPanEnvStateChunk - the statechunk of the Master-volenv3-state
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master pan env, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterVolEnv3StateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<MASTERHWPANENV\n.->")
end

--A = ultraschall.GetProject_MasterVolEnv2StateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)

function ultraschall.GetProject_MasterPanMode_Ex(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_MasterPanMode_Ex</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string MasterHWPanModeEx_StateChunk = ultraschall.GetProject_MasterPanMode_Ex(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the Master-HW-pan-mode-ex-StateChunk, that holds Master-pan-mode-ex-settings of the master.
    
    It's the entry &lt;MASTER_PANMODE_EX ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the master-HW-pan-env-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string MasterHWPanModeEx_StateChunk - the statechunk of the Master-pan-mode-ex
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, master pan mode ex, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_MasterPanMode_Ex","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterPanMode_Ex","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_MasterPanMode_Ex","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_MasterPanMode_Ex", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  local a,b=ProjectStateChunk:match("MASTER_PANMODE_EX (.-) (.-)\n")
  return tonumber(a), tonumber(b)
end

--A = ultraschall.GetProject_MasterPanMode_Ex("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)


function ultraschall.GetProject_TempoEnv_ExStateChunk(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_TempoEnv_ExStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string TempoEnv_ExStateChunk = ultraschall.GetProject_TempoEnv_ExStateChunk(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the TempoEnv_ExStateChunk, that holds TempoEnv_Ex-settings of an rpp-project or ProjectStateChunk.
    
    It's the entry &lt;TEMPOENVEX ... &gt;
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the tempo-env-ex-statechunk; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    string TempoEnv_ExStateChunk - the statechunk of the Tempo-Env-Ex
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, tempo env ex, statechunk, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_TempoEnv_ExStateChunk","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_TempoEnv_ExStateChunk","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_TempoEnv_ExStateChunk","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_TempoEnv_ExStateChunk", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  return ProjectStateChunk:match("<TEMPOENVEX\n.->")
end

--A = ultraschall.GetProject_TempoEnv_ExStateChunk("c:\\automitem\\automitem.RPP", "")
--reaper.MB(A,"",0)


function ultraschall.GetProject_Length(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Length</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number length, number last_itemedge, number last_marker_reg_edge, number last_timesig_marker = ultraschall.GetProject_Length(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the projectlength of an rpp-project-file.
    
    It's returning the position of the overall length, as well as the position of the last itemedge/regionedge/marker/time-signature-marker of the project.
    
    It will not take the effect of stretch-markers and time-signature-markers and change of playrate into account!
    
    To do the same for currently opened projects, use: [GetProjectLength](#GetProjectLength)
    
    Returns -1 in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the project, that you want to know it's length of; nil, to use Parameter ProjectStateChunk instead
    optional string ProjectStateChunk - a ProjectStateChunk to count the length of; only available when projectfilename_with_path=nil
  </parameters>
  <retvals>
    number length - the length of the project
    number last_itemedge - the postion of the last itemedge in the project
    number last_marker_reg_edge - the position of the last marker/regionedge in the project
    number last_timesig_marker - the position of the last time-signature-marker in the project
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>project management, get, length of project, marker, region, timesignature, length, item, edge</tags>
</US_DocBloc>
]]

  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end

  local B, C, ProjectLength, Len, Pos, Offs

  -- search for the last item-edge in the project
  B=ProjectStateChunk
  B=B:match("(%<ITEM.*)<EXTENS").."\n<ITEM"
  ProjectLength=0
  local Item_Length=0
  local Marker_Length=0
  local TempoMarker_Length=0
  
  -- let's take a huge project-string apart to make patternmatching much faster
  local K={}
  local counter=0
--  reaper.MB(B:sub(-1000,-1),"",0)
  while B:len()>1000 do     
    K[counter]=B:sub(0, 100000)
    B=B:sub(100001,-1)
    counter=counter+1
  end
  
  local counter2=1
  local B=K[0]
  
  local Itemscount=0
  
--  reaper.MB(B:sub(1,200),"",0)
  
  while B~=nil and B:sub(1,5)=="<ITEM" do
    if B:len()<10000 and counter2<counter then B=B..K[counter2] counter2=counter2+1 end
    Offs=B:match(".()<ITEM")

    local sc=B:sub(1,200)
    if sc==nil then break end

    Pos = sc:match("POSITION (.-)\n")
    Len = sc:match("LENGTH (.-)\n")

    if Pos==nil or Len==nil or Offs==nil then break end
    if ProjectLength<tonumber(Pos)+tonumber(Len) then ProjectLength=tonumber(Pos)+tonumber(Len) end
    B=B:sub(Offs,-1)  
    Itemscount=Itemscount+1
  end
  Item_Length=ProjectLength

  -- search for the last marker/regionedge in the project
  local markerregioncount, NumMarker, Numregions, Markertable = ultraschall.GetProject_MarkersAndRegions(nil, ProjectStateChunk)
  
  for i=1, markerregioncount do
    if ProjectLength<Markertable[i][2]+Markertable[i][3] then ProjectLength=Markertable[i][2]+Markertable[i][3] end
    if Marker_Length<Markertable[i][2]+Markertable[i][3] then Marker_Length=Markertable[i][2]+Markertable[i][3] end
  end
  
  -- search for the last tempo-envx-marker in the project
  B=ultraschall.GetProject_TempoEnv_ExStateChunk(nil, ProjectStateChunk)  
  C=B:match(".*PT (.-) ")
  if C~=nil and ProjectLength<tonumber(C) then ProjectLength=tonumber(C) end
  if C~=nil and TempoMarker_Length<tonumber(C) then TempoMarker_Length=tonumber(C) end
  
  return ProjectLength, Item_Length, Marker_Length, TempoMarker_Length
end

--L=ultraschall.GetProject_Length("c:/temp/testproject/testproject.RPP")

--L=ultraschall.RenderProject_RenderCFG("c:\\rendercode-project-dupl.RPP", "c:\\Reaper-Internal-Docs.mp3", 0, 0, false, true, true, A)


function ultraschall.CreateTemporaryFileOfProjectfile(projectfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTemporaryFileOfProjectfile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string tempfile = ultraschall.CreateTemporaryFileOfProjectfile(string projectfilename_with_path)</functioncall>
  <description>
    Creates a temporary copy of an rpp-projectfile, which can be altered and rendered again.
    
    Must be deleted by hand using os.remove(tempfile) after you're finished.
    
    returns nil in case of an error
  </description>
  <retvals>
    string tempfile - the temporary-file, that is a valid copy of the projectfilename_with_path
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project(needs to be saved first)
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, create, tempfile, temporary, render, output, file</tags>
</US_DocBloc>
]]
  local temp
  if projectfilename_with_path==nil then 
    if reaper.IsProjectDirty(0)~=1 then
      temp, projectfilename_with_path=reaper.EnumProjects(-1, "") 
    else
      ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "", "current project must be saved first", -1) return nil
    end
  end
  if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "must be a string", -2) return nil end
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "no such file", -3) return nil end
  local A=ultraschall.ReadFullFile(projectfilename_with_path)
  if A==nil then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "Can't read projectfile", -4) return nil end
  if ultraschall.IsValidProjectStateChunk(A)==false then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "no valid project-file", -5) return nil end
  local tempfilename=ultraschall.CreateValidTempFile(projectfilename_with_path, true, "", true)
  if tempfilename==nil then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "", "Can't create tempfile", -6) return nil end
  local B=ultraschall.WriteValueToFile(tempfilename, A)
  if B==-1 then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "Can't create tempfile", -7) return nil else return tempfilename end
end

--length, numchannels, Samplerate, Filetype = ultraschall.GetMediafileAttributes("c:\\Users\\meo\\Desktop\\tudelu\\tudelu.RPP")
--A,B,C,D,E = ultraschall.CreateTemporaryFileOfProjectfile("c:\\Users\\meo\\Desktop\\tudelu\\tudelu.RPP")
--A,B,C,D,E = ultraschall.CreateTemporaryFileOfProjectfile()

function ultraschall.GetProject_Length(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Length</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number length, number last_itemedge, number last_marker_reg_edge, number last_timesig_marker = ultraschall.GetProject_Length(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the projectlength of an rpp-project-file.
    
    It's eturning the position of the overall length, as well as the position of the last itemedge/regionedge/marker/time-signature-marker of the project.
    
    Returns -1 in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the project, that you want to know it's length of; nil, to use Parameter ProjectStateChunk instead
    optional string ProjectStateChunk - a ProjectStateChunk to count the length of; only available when projectfilename_with_path=nil
  </parameters>
  <retvals>
    number length - the length of the project
    number last_itemedge - the postion of the last itemedge in the project
    number last_marker_reg_edge - the position of the last marker/regionedge in the project
    number last_timesig_marker - the position of the last time-signature-marker in the project
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>project management, get, length of project, marker, region, timesignature, lengt, item, edge</tags>
</US_DocBloc>
]]

  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end

  local B, C, ProjectLength, Len, Pos, Offs

  -- search for the last item-edge in the project
  B=ProjectStateChunk
  B=B:match("(%<ITEM.*)<EXTENS").."\n<ITEM"
  ProjectLength=0
  local Item_Length=0
  local Marker_Length=0
  local TempoMarker_Length=0
  
  -- let's take a huge project-string apart to make patternmatching much faster
  local K={}
  local counter=0
  while B:len()>1000 do     
    K[counter]=B:sub(0, 100000)
    B=B:sub(100001,-1)
    counter=counter+1    
  end
  if counter==0 then K[0]=B end
  
  local counter2=1
  local B=K[0]
  
  local Itemscount=0
  
  
  while B~=nil and B:sub(1,5)=="<ITEM" do  
    if B:len()<10000 and counter2<counter then B=B..K[counter2] counter2=counter2+1 end
    Offs=B:match(".()<ITEM")

    local sc=B:sub(1,200)
    if sc==nil then break end

    Pos = sc:match("POSITION (.-)\n")
    Len = sc:match("LENGTH (.-)\n")

    if Pos==nil or Len==nil or Offs==nil then break end
    if ProjectLength<tonumber(Pos)+tonumber(Len) then ProjectLength=tonumber(Pos)+tonumber(Len) end
    B=B:sub(Offs,-1)  
    Itemscount=Itemscount+1
  end
  Item_Length=ProjectLength

  -- search for the last marker/regionedge in the project
  local markerregioncount, NumMarker, Numregions, Markertable = ultraschall.GetProject_MarkersAndRegions(nil, ProjectStateChunk)
  
  for i=1, markerregioncount do
    if ProjectLength<Markertable[i][2]+Markertable[i][3] then ProjectLength=Markertable[i][2]+Markertable[i][3] end
    if Marker_Length<Markertable[i][2]+Markertable[i][3] then Marker_Length=Markertable[i][2]+Markertable[i][3] end
  end
  
  -- search for the last tempo-envx-marker in the project
  B=ultraschall.GetProject_TempoEnv_ExStateChunk(nil, ProjectStateChunk)  
  C=B:match(".*PT (.-) ")
  if C~=nil and ProjectLength<tonumber(C) then ProjectLength=tonumber(C) end
  if C~=nil and TempoMarker_Length<tonumber(C) then TempoMarker_Length=tonumber(C) end
  
  return ProjectLength, Item_Length, Marker_Length, TempoMarker_Length
end

function ultraschall.SetProject_RenderPattern(projectfilename_with_path, render_pattern, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_RenderPattern(string projectfilename_with_path, string render_pattern, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-filename in an rpp-projectfile or a ProjectStateChunk. Set it to "", if you want to set the render-filename with <a href="#SetProject_RenderFilename">SetProject_RenderFilename</a>.
    
    Capitalizing the first character of the wildcard will capitalize the first letter of the substitution. 
        Capitalizing the first two characters of the wildcard will capitalize all letters.
        
        Directories will be created if necessary. For example if the render target 
        is "$project/track", the directory "$project" will be created.
        
        Immediately following a wildcard, character replacement statements may be specified:
          <X>  -- single character which is to be removed from the substitution. 
                      For example: $track< > removes all spaces from the track name, 
                                   $track</><\> removes all slashes.
                                   
          <abcdeX> -- multiple characters, abcde are all replaced with X. 
                      
                      For example: <_.> replaces all underscores with periods, 
                                   </\_> replaces all slashes with underscores. 
                      
                      If > is specified as a source character, it must be listed first in the list.
        
        $item    media item take name, if the input is a media item
        $itemnumber  1 for the first media item on a track, 2 for the second...
        $track    track name
        $tracknumber  1 for the first track, 2 for the second...
        $parenttrack  parent track name
        $region    region name
        $regionnumber  1 for the first region, 2 for the second...
        $project    project name
        $tempo    project tempo at the start of the render region
        $timesignature  project time signature at the start of the render region, formatted as 4-4
        $filenumber  blank (optionally 1) for the first file rendered, 1 (optionally 2) for the second...
        $filenumber[N]  N for the first file rendered, N+1 for the second...
        $note    C0 for the first file rendered,C#0 for the second...
        $note[X]    X (example: B2) for the first file rendered, X+1 (example: C3) for the second...
        $natural    C0 for the first file rendered, D0 for the second...
        $natural[X]  X (example: F2) for the first file rendered, X+1 (example: G2) for the second...
        $namecount  1 for the first item or region of the same name, 2 for the second...
        $timelineorder  1 for the first item or region on the timeline, 2 for the second...
        
        Position/Length:
        $start    start time of the media item, render region, or time selection, in M-SS.TTT
        $end    end time of the media item, render region, or time selection, in M-SS.TTT
        $length    length of the media item, render region, or time selection, in M-SS.TTT
        $startbeats  start time in measures.beats of the media item, render region, or time selection
        $endbeats  end time in measures.beats of the media item, render region, or time selection
        $lengthbeats    length in measures.beats of the media item, render region, or time selection
        $starttimecode  start time in H-MM-SS-FF format of the media item, render region, or time selection
        $endtimecode  end time in H-MM-SS-FF format of the media item, render region, or time selection
        $startframes  start time in absolute frames of the media item, render region, or time selection
        $endframes  end time in absolute frames of the media item, render region, or time selection
        $lengthframes  length in absolute frames of the media item, render region, or time selection
        $startseconds  start time in whole seconds of the media item, render region, or time selection
        $endseconds  end time in whole seconds of the media item, render region, or time selection
        $lengthseconds  length in whole seconds of the media item, render region, or time selection
        
        Output Format:
        $format    render format (example: wav)
        $samplerate  sample rate (example: 44100)
        $sampleratek  sample rate (example: 44.1)
        $bitdepth  bit depth, if available (example: 24 or 32FP)
        
        Current Date/Time:
        $year    year, currently 2019
        $year2    last 2 digits of the year,currently 19
        $month    month number,currently 04
        $monthname  month name,currently apr
        $day    day of the month, currently 28
        $hour    hour of the day in 24-hour format,currently 23
        $hour12    hour of the day in 12-hour format,currently 11
        $ampm    am if before noon,pm if after noon,currently pm
        $minute    minute of the hour,currently 30
        $second    second of the minute,currently 27
        
        Computer Information:
        $user    user name
        $computer  computer name
        
        (this description has been taken from the Render Wildcard Help within the Render-Dialog of Reaper)
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    string render_pattern - the pattern, with which the rendering-filename will be automatically created. Check also <a href="#GetProject_RenderFilename">GetProject_RenderFilename</a>
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, render pattern, filename, render</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if render_pattern~=nil and type(render_pattern)~="string" then ultraschall.AddErrorMessage("SetProject_RenderPattern", "render_pattern", "Must be a string", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  local quots

--  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_FILE.-%c)")
--  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-(RENDER_FMT.*)")

  local RenderPattern
  if render_pattern==nil then RenderPattern="" else 
    if render_pattern:match("%s")~=nil then quots="\"" else quots="" end
    RenderPattern="  RENDER_PATTERN "..quots..render_pattern..quots.."\n" 
  end
  
  local FileStart, FileEnd
  if ProjectStateChunk:match("\n  RENDER_PATTERN ")==nil then
    FileStart, FileEnd = ProjectStateChunk:match("(.-)(  RENDER_1X.*)")
    ProjectStateChunk=FileStart..RenderPattern..FileEnd
  else
    ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  RENDER_PATTERN.-%c", "\n"..RenderPattern)
  end
  
  
--  ProjectStateChunk=FileStart..RenderPattern.."  "..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.GetProject_RenderFilename(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string render_filename = ultraschall.GetProject_RenderFilename(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-filename from an RPP-Projectfile or a ProjectStateChunk. If it contains only a path or nothing, you should check the Render_Pattern using <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>, as a render-pattern influences the rendering-filename as well.
    
    It's the entry RENDER_FILE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string render_filename - the filename for rendering, check also <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, path, render filename, filename, render</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  local temp=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_FILE%s(.-)%c.-<RENDER_CFG")
  if temp==nil then temp="" end
  if temp:sub(1,1)=="\"" then temp=temp:sub(2,-1) end
  if temp:sub(-1,-1)=="\"" then temp=temp:sub(1,-2) end
  return temp
end


function ultraschall.GetProject_GroupName(projectfilename_with_path, idx, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_GroupName</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string groupname = ultraschall.GetProject_GroupName(string projectfilename_with_path, integer idx, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the name associated to a specific group of items. There can be more than one!
    
    It is the GROUP-entry in the root of the ProjectStateChunk.
    
    Returns nil in case of error or if no such entry exists.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    integer idx - the index of the item-group, whose name you want to know
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string groupname - the associated groupname of the itemgroup; nil, no such group or no name is given(default Group idx)
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, get, group, name, projectstatechunk</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_GroupName","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetProject_GroupName", "idx", "must be an integer", -5) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_GroupName","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_GroupName","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_GroupName", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the values and return them
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(ProjectStateChunk)
  local counter2=0
  for i=1, count do
    if split_string[i]:match("GROUP %d .*")~=nil then 
      counter2=counter2+1
      if idx==counter2 then 
        local temp=split_string[i]:match("GROUP %d (.*)")
        if temp:sub(1,1)=="\"" and temp:sub(-1,-1)=="\"" then temp=temp:sub(2,-2) end
        return temp
      end
    end
  end
end


function ultraschall.SetProject_Lock(projectfilename_with_path, lock_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Lock</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_Lock(string projectfilename_with_path, integer lock_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the Locked-state of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry LOCK 
    It is the one before(!) any <TRACK-tags !
    
    It is a bitfield, containing numerous settings.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer lock_state - the lock-state, which is a bitfield
                      - &1     - Time selection
                      - &2     - Items (full)
                      - &4     - Track envelopes
                      - &8     - Markers
                      - &16    - Regions
                      - &32    - Time signature markers
                      - &64    - Items (prevent left/right movement)
                      - &128   - Items (prevent up/down movement)
                      - &256   - Item edges
                      - &512   - Item fade/volume handles
                      - &1024  - Loop points locked
                      - &2048  - Item envelopes
                      - &4096  - Item stretch markers
                      - &16384 - Enable locking
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, lock state</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Lock", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Lock", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Lock", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(lock_state)~="integer" then ultraschall.AddErrorMessage("SetProject_Lock", "lock_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Lock", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local ProjectEntry="  LOCK "..lock_state.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  LOCK .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_GlobalAuto(projectfilename_with_path, global_auto_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_GlobalAuto</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_GlobalAuto(string projectfilename_with_path, integer global_auto_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the global-auto-override-state of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry GLOBAL_AUTO 
    
    This sets the same automation mode to all tracks!
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer global_auto_state - the global automation override state, this sets the same automation mode to all tracks!
                              - -1, No global automation override, automation-mode will be set by track
                              - 0, trim/read mode
                              - 1, read mode
                              - 2, touch mode
                              - 3, write mode
                              - 4, latch mode
                              - 5, latch preview mode
                              - 6, bypass all automation
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, global automation override state</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GlobalAuto", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_GlobalAuto", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GlobalAuto", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(global_auto_state)~="integer" then ultraschall.AddErrorMessage("SetProject_GlobalAuto", "global_auto_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_GlobalAuto", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local ProjectEntry="  GLOBAL_AUTO "..global_auto_state.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  GLOBAL_AUTO .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_Tempo(projectfilename_with_path, bpm, beat, denominator, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Tempo</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_Tempo(string projectfilename_with_path, integer bpm, integer beat, integer denominator, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the tempo, bpm, beat, denominator-state of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry TEMPO 
    
    They are set in the Project Settings -> "Project BPM" and "Time signature"
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer bpm - the tempo of the project in bpm
    integer beat - the beat of the project 
    integer denominator - the denominator for the beat 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, tempo, bpm, beat, denominator</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Tempo", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Tempo", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Tempo", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Tempo", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  if math.type(bpm)~="integer" then ultraschall.AddErrorMessage("SetProject_Tempo", "bpm", "Must be an integer", -6) return -1 end
  if math.type(beat)~="integer" then ultraschall.AddErrorMessage("SetProject_Tempo", "beat", "Must be an integer", -7) return -1 end
  if math.type(denominator)~="integer" then ultraschall.AddErrorMessage("SetProject_Tempo", "denominator", "Must be an integer", -8) return -1 end
  
  local ProjectEntry="  TEMPO "..bpm.." "..beat.." "..denominator.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  TEMPO .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_Playrate(projectfilename_with_path, playrate, preserve_pitch, min_playrate, max_playrate, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Playrate</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_Playrate(string projectfilename_with_path, number playrate, integer preserve_pitch, number min_playrate, number max_playrate, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the playrate of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry PLAYRATE 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    number playrate - the currently set playrate; 0.01 to 10
    integer preserve_pitch - 0, don't preserve pitch, when changing playrate; 1, preserve pitch, when chaning playrate 
    number min_playrate - the minimum playrate possible in the project; 0.01 to 10
    number max_playrate - the maximum playrate possible in the project; 0.01 to 10
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, playrate</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Playrate", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Playrate", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Playrate", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Playrate", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  if type(playrate)~="number" then ultraschall.AddErrorMessage("SetProject_Playrate", "playrate", "Must be a number", -6) return -1 end
  if math.type(preserve_pitch)~="integer" then ultraschall.AddErrorMessage("SetProject_Playrate", "preserve_pitch", "Must be an integer", -7) return -1 end
  if type(min_playrate)~="number" then ultraschall.AddErrorMessage("SetProject_Playrate", "min_playrate", "Must be a number", -8) return -1 end
  if type(max_playrate)~="number" then ultraschall.AddErrorMessage("SetProject_Playrate", "max_playrate", "Must be a number", -9) return -1 end
  if preserve_pitch~=0 and preserve_pitch~=1 then ultraschall.AddErrorMessage("SetProject_Playrate", "preserve_pitch", "Must be either 0(don't preserve) or 1(preserve)", -10) return -1 end
  
  local ProjectEntry="  PLAYRATE "..playrate.." "..preserve_pitch.." "..min_playrate.." "..max_playrate.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  PLAYRATE .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterAutomode(projectfilename_with_path, automode, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterAutomode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterAutomode(string projectfilename_with_path, integer automode, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the automation-mode for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTERAUTOMODE 
    
    This sets the same automation mode to all tracks!
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer automode - the automation mode for the master-track
                              - 0, trim/read mode
                              - 1, read mode
                              - 2, touch mode
                              - 3, write mode
                              - 4, latch mode
                              - 5, latch preview mode
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, automation, mode</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterAutomode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterAutomode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterAutomode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(automode)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterAutomode", "automode", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterAutomode", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local ProjectEntry="  MASTERAUTOMODE "..automode.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTERAUTOMODE .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterSel(projectfilename_with_path, selection_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterSel</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterSel(string projectfilename_with_path, integer selection_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the selection-state for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTER_SEL 
    
    This sets the same automation mode to all tracks!
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer selection_state - the selection-state of the MasterTrack; 0, unselected; 1, selected
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, selection</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterSel", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterSel", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterSel", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(selection_state)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterSel", "selection_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterSel", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  if selection_state<0 or selection_state>1 then ultraschall.AddErrorMessage("SetProject_MasterSel", "selection_state", "Must be either 1(selected) or 0(unselected)", -6) return -1 end
  
  local ProjectEntry="  MASTER_SEL "..selection_state.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTER_SEL .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterMuteSolo(projectfilename_with_path, mute_solo_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterMuteSolo</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterMuteSolo(string projectfilename_with_path, integer mute_solo_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the mute/solo-state for the master-track of an rpp-projectfile or a ProjectStateChunk.
    Has no exclusive-solo/mute-settings!
    
    It's the entry MASTERMUTESOLO 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer mute_solo_state - the mute-solo-state; it is a bitfield
                            -   0, no mute, no solo, Mono mode L+R
                            -   &1, master-track muted
                            -   &2, master-track soloed
                            -   &4, master-track mono-button
                            -   &8, Mono mode:L
                            -   &16, Mono mode:R
                            -   add 24 for Mono mode L-R 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, mute, solo</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterMuteSolo", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterMuteSolo", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterMuteSolo", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(mute_solo_state)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterMuteSolo", "mute_solo_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterMuteSolo", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  
  local ProjectEntry="  MASTERMUTESOLO "..mute_solo_state.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTERMUTESOLO .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterFXByp(projectfilename_with_path, fx_byp_state, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterFXByp</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterFXByp(string projectfilename_with_path, integer fx_byp_state, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the fx-bypass-state for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTER_FX 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer fx_byp_state - the fx-bypass-state; 0, master-track-fx bypassed; 1, master-track-fx normal 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, fx bypass</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterFXByp", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterFXByp", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterFXByp", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(fx_byp_state)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterFXByp", "fx_byp_state", "Must be an integer", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterFXByp", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  
  local ProjectEntry="  MASTER_FX "..fx_byp_state .."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTER_FX .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterNChans(projectfilename_with_path, number_of_channels, peak_metering, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterNChans</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterNChans(string projectfilename_with_path, integer number_of_channels, integer peak_metering, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the number of channels and vu-meter-settings for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTER_NCH 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer number_of_channels - the number of output-channels, as set in the "Outputs for the Master Channel -> Track Channels"-dialog 
    integer peak_metering - 2, Multichannel peak metering-setting, as set in the "Master VU settings"-dialog 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, number of channels, peak metering</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterNChans", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterNChans", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterNChans", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(number_of_channels)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterNChans", "number_of_channels", "Must be an integer", -4) return -1 end
  if math.type(peak_metering)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterNChans", "peak_metering", "Must be an integer", -5) return -1 end
  
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterNChans", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end
  
  local ProjectEntry="  MASTER_NCH "..number_of_channels.." "..peak_metering.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTER_NCH .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterTrackHeight(projectfilename_with_path, height_state, height_lock, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterTrackHeight</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterTrackHeight(string projectfilename_with_path, integer height_state, integer height_lock, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the trackheight for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTERTRACKHEIGHT 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer height_state - the current-height of the master-track, from 24 to 260 
    integer height_lock - 0, height-lock is off; 1, height-lock is on 
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, trackheight</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(height_state)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "height_state", "Must be an integer", -4) return -1 end
  if math.type(height_lock)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "height_lock", "Must be an integer", -5) return -1 end
  
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end
  
  local ProjectEntry="  MASTERTRACKHEIGHT "..height_state.." "..height_lock.."\n" 

  ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTERTRACKHEIGHT .-%c", "\n"..ProjectEntry)
  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterTrackColor(projectfilename_with_path, color, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterTrackColor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterTrackColor(string projectfilename_with_path, integer color, optional string ProjectStateChunk)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the color for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    To generate the correct color-value, use [ConvertColor](#ConvertColor).
    Note: This color reverses red and blue component on Mac, so it looks different on Mac compared to Windows and Linux!
    
    It's the entry MASTERPEAKCOL 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer color - the color-value of the MasterTrack
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, color</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackColor", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackColor", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackColor", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if math.type(color)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackColor", "color", "Must be an integer", -4) return -1 end
  
  
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackHeight", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end
  
  local ProjectEntry="  MASTERPEAKCOL "..color.."\n" 

  local ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTERPEAKCOL .-%c", "\n"..ProjectEntry)

  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.SetProject_MasterPanMode(projectfilename_with_path, panmode, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterPanMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_MasterPanMode(string projectfilename_with_path, integer panmode, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the panmode for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry MASTER_PANMODE 
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer panmode - the panmode for the master-track;
                    -  -1, Project default (Stereo balance)
                    -   3, Stereo balance  / mono pan(default)
                    -   5, Stereo Pan
                    -   6, Dual Pan
                    -   nil, REAPER 3.x balance(deprecated)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, master track, panmode</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterPanMode", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterPanMode", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterPanMode", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if panmode~=nil and math.type(panmode)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterPanMode", "panmode", "Must be an integer or nil(for Reaper 3.x-behavior)", -4) return -1 end

  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterPanMode", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end
  
  local ProjectEntry=""
  if panmode~=nil then
    ProjectEntry="  MASTER_PANMODE "..panmode.."\n" 
  end

  if ProjectStateChunk:match("MASTER_PANMODE")~=nil then
    ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  MASTER_PANMODE .-%c", "\n"..ProjectEntry)
  else
    ProjectStateChunk=ProjectStateChunk:match("(.*)  MASTER_FX")..ProjectEntry..ProjectStateChunk:match("(  MASTER_FX.*)")
  end

  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end


function ultraschall.SetProject_MasterTrackView(projectfilename_with_path, tcp_visibility, state2, state3, state4, state5, state6, state7, state8, state9, state10, state11, state12, state13, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_MasterTrackView</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.32
    Lua=5.3
  </requires>
  <functioncall>integer retval, optional string ProjectStateChunk = ultraschall.SetProject_MasterTrackView(string projectfilename_with_path, integer tcp_visibility, number state2, number state3, number state4, integer state5, integer state6, integer state7, integer state8, integer state9, integer state10, integer state11, integer state12, number state13, optional string ProjectStatechunk)</functioncall>
  <description>
    Sets the master-view-state of the master-track of the project or a ProjectStateChunk.
    
    It is the entry: MASTERTRACKVIEW
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer tcp_visibility - 0, Master-track is invisible in MCP; 1, Master-track is visible in MCP
    number state2 - unknown
    number state3 - unknown
    number state4 - unknown
    integer state5 - unknown
    integer state6 - unknown
    integer state7 - unknown
    integer state8 - unknown
    integer state9 - unknown
    integer state10 - unknown
    integer state11 - unknown
    integer state12 - unknown
    number state13 - unknown    
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
    optional string ProjectStateChunk - the altered ProjectStateChunk
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, ripple, all, one</tags>
</US_DocBloc>
]]
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
--tcp_visibility, state2, state3, state4, state5, state6, state7
  if math.type(tcp_visibility)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "tcp_visibility", "Must be an integer", -4) return -1 end
  if type(state2)~="number" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state2", "Must be a number", -5) return -1 end
  if type(state3)~="number" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state3", "Must be a number", -6) return -1 end
  if type(state4)~="number" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state4", "Must be a number", -7) return -1 end
  if math.type(state5)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state5", "Must be an integer", -8) return -1 end
  if math.type(state6)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state6", "Must be an integer", -9) return -1 end
  if math.type(state7)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state7", "Must be an integer", -10) return -1 end
  if math.type(state8)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state8", "Must be an integer", -11) return -1 end
  if math.type(state9)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state9", "Must be an integer", -12) return -1 end
  if math.type(state10)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state10", "Must be an integer", -13) return -1 end
  if math.type(state11)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state11", "Must be an integer", -14) return -1 end
  if math.type(state12)~="integer" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state12", "Must be an integer", -15) return -1 end
  if type(state13)~="number" then ultraschall.AddErrorMessage("SetProject_MasterTrackView", "state13", "Must be a number", -16) return -1 end
  
  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-MASTERTRACKVIEW%s).-%c")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-MASTERTRACKVIEW%s.-%c(.*)")
  
  ProjectStateChunk=FileStart..tcp_visibility.." "..state2.." "..state3.." "..state4.." "..state5.." "
                    ..state6.." "..state7.." "..state8.." "..state9.." "
                    ..state10.." "..state11.." "
                    ..state12.." "
                    ..state13.."\n"
                    ..FileEnd  
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end
end

function ultraschall.GetProject_Render_Normalize(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Render_Normalize</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.65
    Lua=5.3
  </requires>
  <functioncall>integer render_normalize_mode, number normalize_target, optional number brickwall_target, optional number fadein_length, optional number fadeout_length, optional integer fadein_shape, optional integer fadeout_shape = ultraschall.GetProject_Render_Normalize(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    returns the master-view-state of the master-track of the project or a ProjectStateChunk.
    
    It's the entry RENDER_NORMALIZE
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfile+path, from which to get the trackview-states; nil to use ProjectStateChunk
    optional string ProjectStateChunk - a statechunk of a project, usually the contents of a rpp-project-file
  </parameters>
  <retvals>
    integer render_normalize_method - the normalize-method
                                    - &1, Enable normalizing
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - 0, LUFS-I
                                    - 2 , RMS-I
                                    - 4, Peak
                                    - 6, True Peak
                                    - 8, LUFS-M max
                                    - 10, LUFS-S max
                                    - &32, Normalize stems to master target-checkbox
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - &64, Brickwall-enabled-checkbox
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - &128, Brickwall-mode
                                    -     0, Peak
                                    -     1, True Peak
                                    - &256, only normalize files that are too loud
                                    -     0, disabled
                                    -     1, enabled
    number normalize_target - the normalize-target as amp-volume. Use ultraschall.MKVOL2DB to convert it to dB.
    optional number brickwall_target - the brickwall-target as amp-volume. Use ultraschall.MKVOL2DB to convert it to dB.    
    optional number fadein_length - the length of the fade-in in seconds(use fractions for milliseconds)
    optional number fadeout_length - the length of the fade-out in seconds(use fractions for milliseconds)
    optional integer fadein_shape - the shape of the fade-in-curve
                            - 0, linear fade-in
                            - 1, inverted quadratic fade-in
                            - 2, quadratic fade-in
                            - 3, inverted quartic fade-in
                            - 4, quartic fade-in
                            - 5, Cosine S-curve fade-in
                            - 6, Quartic S-curve fade-in
    optional integer fadeout_shape - the shape of the fade-out-curve
                             - 0, linear fade-out
                             - 1, inverted quadratic fade-out
                             - 2, quadratic fade-out
                             - 3, inverted quartic fade-out
                             - 4, quartic fade-out
                             - 5, Cosine S-curve fade-out
                             - 6, Quartic S-curve fade-out
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectmanagement, get, view, fade in, fade out, projectstatechunk</tags>
</US_DocBloc>
]]
  return ultraschall.GetProjectState_NumbersOnly(projectfilename_with_path, "RENDER_NORMALIZE", ProjectStateChunk, "GetProject_Render_Normalize")
end

function ultraschall.SetProject_Render_Normalize(projectfilename_with_path, render_normalize_method, normalize_target, ProjectStateChunk, brickwall_target, fadein_length, fadeout_length, fadein_shape, fadeout_shape)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_Render_Normalize</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.65
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_Render_Normalize(string projectfilename_with_path, integer render_normalize_method, number normalize_target, optional string ProjectStateChunk, optional number brickwall_target, optional number fadein_length, optional number fadeout_length, optional integer fadein_shape, optional integer fadeout_shape)</functioncall>
  <description>
    Sets the panmode for the master-track of an rpp-projectfile or a ProjectStateChunk.
    
    It's the entry RENDER_NORMALIZE
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil, to use Parameter ProjectStateChunk instead
    integer render_normalize_method - the normalize-method
                                    - &1, Enable normalizing
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - 0, LUFS-I
                                    - 2 , RMS-I
                                    - 4, Peak
                                    - 6, True Peak
                                    - 8, LUFS-M max
                                    - 10, LUFS-S max
                                    - &32, Normalize stems to master target-checkbox
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - &64, Brickwall-enabled-checkbox
                                    -     0, unchecked(off)
                                    -     1, checked(on)
                                    - &128, Brickwall-mode
                                    -     0, Peak
                                    -     1, True Peak
                                    - &256, only normalize files that are too loud
                                    -     0, disabled
                                    -     1, enabled
    number normalize_target - the normalize-target as amp-volume. Use ultraschall.DB2MKVOL to convert it from dB.
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
    optional number brickwall_target - the brickwall-normalizatin-target as amp-volume. Use ultraschall.DB2MKVOL to convert it from dB.
    optional number fadein_length - the length of the fade-in in seconds(use fractions for milliseconds)
    optional number fadeout_length - the length of the fade-out in seconds(use fractions for milliseconds)
    optional integer fadein_shape - the shape of the fade-in-curve
                             - 0, linear fade-in
                             - 1, inverted quadratic fade-in
                             - 2, quadratic fade-in
                             - 3, inverted quartic fade-in
                             - 4, quartic fade-in
                             - 5, Cosine S-curve fade-in
                             - 6, Quartic S-curve fade-in
    optional integer fadeout_shape - the shape of the fade-out-curve
                              - 0, linear fade-out
                              - 1, inverted quadratic fade-out
                              - 2, quadratic fade-out
                              - 3, inverted quartic fade-out
                              - 4, quartic fade-out
                              - 5, Cosine S-curve fade-out
                              - 6, Quartic S-curve fade-out
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Management
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua</source_document>
  <tags>projectfiles, rpp, state, set, render, normalize, brickwall, fade in, fade out</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end

  if math.type(render_normalize_method)~="integer" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "render_normalize_method", "Must be an integer", -4) return -1 end
  if type(normalize_target)~="number" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "normalize_target", "Must be a number", -5) return -1 end
  if brickwall_target~=nil and type(brickwall_target)~="number" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "brickwall_target", "Must be a number", -7) return -1 end
  
  if brickwall_target~=nil and type(brickwall_target)~="number" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "brickwall_target", "Must be a number", -8) return -1 end
  if fadein_length~=nil and type(fadein_length)~="number" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "fadein_length", "Must be a number", -9) return -1 end
  if fadeout_length~=nil and type(fadeout_length)~="number" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "fadeout_length", "Must be a number", -10) return -1 end
  if fadein_shape~=nil and math.type(fadein_shape)~="integer" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "fadein_shape", "Must be an integer", -11) return -1 end
  if fadeout_shape~=nil and math.type(fadeout_shape)~="integer" then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "fadeout_shape", "Must be an integer", -12) return -1 end
  
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_Render_Normalize", "projectfilename_with_path", "No valid RPP-Projectfile!", -6) return -1 end
  if brickwall_target==nil then brickwall_target="" else brickwall_target=" "..brickwall_target end
  if fadein_length==nil then fadein_length="" else fadein_length=" "..fadein_length end
  if fadeout_length==nil then fadeout_length="" else fadeout_length=" "..fadeout_length end
  if fadein_shape==nil then fadein_shape="" else fadein_shape=" "..fadein_shape end
  if fadeout_shape==nil then fadeout_shape="" else fadeout_shape=" "..fadeout_shape end
  
  local ProjectEntry=""
  
  ProjectEntry="  RENDER_NORMALIZE "..render_normalize_method.." "..normalize_target..brickwall_target..fadein_length..fadeout_length..fadein_shape..fadeout_shape.."\n" 
  
  if ProjectStateChunk:match("RENDER_NORMALIZE")~=nil then
    ProjectStateChunk=string.gsub(ProjectStateChunk, "\n  RENDER_NORMALIZE .-%c", "\n"..ProjectEntry)
  else
    ProjectStateChunk=ProjectStateChunk:match("(.*)  TIMELOCKMODE")..ProjectEntry..ProjectStateChunk:match("(  TIMELOCKMODE.*)")
  end

  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end