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

-- checks, whether any track is muted and warns in that case before rendering
-- user can abort before rendering in that case as well
--
-- ultraschall.ini supports turing off that feature:
-- turn on:
-- [ultraschall_render]
-- warn_when_muted_tracks=true
--
-- turn off:
-- [ultraschall_render]
-- warn_when_muted_tracks=false

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.AnyTrackMute(master)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AnyTrackMute</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.979
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.AnyTrackMute()</functioncall>
  <description>
    returns true, if any track is muted, otherwise returns false.
  </description>
  <parameters>
    boolean master - true, include the master-track as well; false, don't include master-track
  </parameters>
  <retvals>
    boolean retval - true, if any track is muted; false, if not
  </retvals>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, is, track, master, mute</tags>
</US_DocBloc>
]]
  local retval, mute
  
  if master==true then
    retval, mute = reaper.GetTrackUIMute(reaper.GetMasterTrack(0))
    if mute==true then return true end
  end
  
  for i=0, reaper.CountTracks(0)-1 do
    retval, mute = reaper.GetTrackUIMute(reaper.GetTrack(0,i))
    if mute==true then return true end
  end
  return false
end

A=ultraschall.AnyTrackMute(true)
CurState=ultraschall.GetUSExternalState("ultraschall_render", "warn_when_muted_tracks")
if CurState=="" then CurState="true" end

if A==true and CurState=="true" then
  Retval=reaper.MB("There are muted tracks. Do you want to continue rendering?", "Warning: muted tracks!", 4)
  if Retval==6 then A=false end
else
  A=false
end


if A==false then
  cmd=reaper.NamedCommandLookup("_Ultraschall_ResetPlaybackRate_and_RenderProject")
  reaper.Main_OnCommand(cmd,0)
end
