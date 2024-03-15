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
---      Ultraschall Module       ---
-------------------------------------

function ultraschall.pause_follow_one_cycle()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>pause_follow_one_cycle</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>ultraschall.pause_follow_one_cycle()</functioncall>
  <description>
    Skips auto-follow-off-checking-script for one cycle.
    FollowMode in Ultraschall turns on Autoscrolling in a useable way. In addition, under certain circumstances, followmode will be turned off automatically. 
    If you experience this but want to avoid the follow-off-functionality, use this function.
    
    This function is only relevant, if you want to develop scripts that work perfectly within the Ultraschall.fm-extension.
  </description>
  <chapter_context>
    Ultraschall Specific
    Followmode
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, userinterface, follow, off, followmode, turn off one cycle</tags>
</US_DocBloc>
--]]
  local follow_actionnumber = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
  if reaper.GetToggleCommandState(follow_actionnumber)==1 then
    reaper.SetExtState("follow", "skip", "true", false)
  end
end 


function ultraschall.IsTrackSoundboard(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsTrackSoundboard</slug>
  <requires>
    Ultraschall=4.1
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
    Ultraschall=4.1
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
    Ultraschall=4.1
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
      reaper.TrackFX_GetByName(track, "StudioLinkOnAir (ITSR)", false)~=-1 or
      reaper.TrackFX_GetByName(track, "StudioLinkOnAir", false)~=-1 then
      return true
    else
      return false
    end
  end
end


function ultraschall.GetTypeOfTrack(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTypeOfTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string type, boolean multiple = ultraschall.GetTypeOfTrack(integer tracknumber)</functioncall>
  <description>
    Returns the tracktype of a specific track. Will return the type of the first valid SoundBoard, StudioLink, StudioLinkOnAir-plugin in the track-fx-chain.
    If there are multiple valid plugins and therefore types, the second retval multiple will be set to true, else to false.
    
    Only relevant in Ultraschall-installations
    
    returns "", false in case of an error
  </description>
  <retvals>
    string type - Either "StudioLink", "StudioLinkOnAir", "SoundBoard" or "Other". "", in case of an error
    boolean multiple - true, the track has other valid plugins as well; false, it is a "pure typed" track
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
  <tags>ultraschall, get, type, soundboard, studiolink, studiolinkonair, track</tags>
</US_DocBloc>
--]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "must be an integer", -1) return "", false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return "", false end
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  local A,A1=ultraschall.IsTrackStudioLink(tracknumber)
  local B,B1=ultraschall.IsTrackStudioLinkOnAir(tracknumber)
  local C,C1=ultraschall.IsTrackSoundboard(tracknumber)
  
  -- hacky, find a better way
  if A1==nil then A1=99999999999 end 
  if B1==nil then B1=99999999999 end
  if C1==nil then C1=99999999999 end
  
  if A==true and B==false and C==false then return "StudioLink", false
  elseif A==false and B==true and C==false then return "StudioLinkOnAir", false
  elseif A==false and B==false and C==true then return "SoundBoard", false
  elseif A==true and B==true and C==false then 
    if A1<B1 then return "StudioLink", true else return "StudioLinkOnAir", true end
  elseif A==false and B==true and C==true then 
    if B1<C1 then return "StudioLinkOnAir", true else return "SoundBoard", true end
  elseif A==true and B==false and C==true then 
    if A1<C1 then return "StudioLink", true else return "SoundBoard", true end
  elseif A==true and B==true and C==true then
    if A1<B1 and A1<C1 then return "StudioLink", true
    elseif B1<A1 and B1<C1 then return "StudioLinkOnAir", true
    elseif C1<A1 and C1<B1 then return "SoundBoard", true
    end
  else
    return "Other", false
  end
end


--DABBA,DBABBA=ultraschall.GetTypeOfTrack(1)


function ultraschall.GetAllAUXSendReceives2()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllAUXSendReceives2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table AllAUXSendReceives, integer number_of_tracks = ultraschall.GetAllAUXSendReceives2()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all AUX-SendReceive-settings of all tracks, excluding master-track
    
    like [GetAllAUXSendReceives](#GetAllAUXSendReceives), but returns the type of a track as well
    
    returned table is of structure:
      table["AllAUXSendReceive"]=true                               - signals, this is an AllAUXSendReceive-table. Don't alter!  
      table["number\_of_tracks"]                                     - the number of tracks in this table, from track 1 to track n  
      table[tracknumber]["type"]                                    - type of the track, SoundBoard, StudioLink, StudioLinkOnAir or Other  
      table[tracknumber]["AUXSendReceives_count"]                   - the number of AUXSendReceives of tracknumber, beginning with 1  
      table[tracknumber][AUXSendReceivesIndex]["recv\_tracknumber"] - the track, from which to receive audio in this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["post\_pre_fader"]   - the setting of post-pre-fader of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["volume"]            - the volume of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan"]               - the panning of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mute"]              - the mute-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["mono\_stereo"]      - the mono/stereo-button-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["phase"]             - the phase-setting of this AUXSendReceivesIndex  of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["chan\_src"]         - the audiochannel-source of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["snd\_src"]          - the send-to-channel-target of this AUXSendReceivesIndex of tracknumber  
      table[tracknumber][AUXSendReceivesIndex]["pan\_law"]           - pan-law, default is -1  
      table[tracknumber][AUXSendReceivesIndex]["midichanflag"]      - the Midi-channel of this AUXSendReceivesIndex of tracknumber, leave it 0  
      table[tracknumber][AUXSendReceivesIndex]["automation"]        - the automation-mode of this AUXSendReceivesIndex  of tracknumber  
        
      See [GetTrackAUXSendReceives](#GetTrackAUXSendReceives) for more details on the individual settings, stored in the entries.  
  </description>
  <retvals>
    table AllAUXSendReceives - a table with all SendReceive-entries of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>routing, trackmanagement, track, get, all, send, receive, aux, routing</tags>
</US_DocBloc>
]]

  local AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives()
  for i=1, number_of_tracks do
    AllAUXSendReceives[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllAUXSendReceives, number_of_tracks
end

--A,B=ultraschall.GetAllAUXSendReceives2()

function ultraschall.GetAllHWOuts2()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllHWOuts2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table AllHWOuts, integer number_of_tracks = ultraschall.GetAllHWOuts2()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all HWOut-settings of all tracks, including master-track(track index: 0)
    
    like [GetAllHWOuts](#GetAllHWOuts) but includes the type of a track as well
    
    returned table is of structure:
      table["HWOuts"]=true                              - signals, this is a HWOuts-table; don't change that!  
      table["number\_of_tracks"]                         - the number of tracks in this table, from track 0(master) to track n  
      table[tracknumber]["type"]                        - type of the track, SoundBoard, StudioLink, StudioLinkOnAir or Other  
      table[tracknumber]["HWOut_count"]                 - the number of HWOuts of tracknumber, beginning with 1  
      table[tracknumber][HWOutIndex]["outputchannel"]   - the number of outputchannels of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["post\_pre_fader"] - the setting of post-pre-fader of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["volume"]          - the volume of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan"]             - the panning of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["mute"]            - the mute-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["phase"]           - the phase-setting of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["source"]          - the source/input of this HWOutIndex of tracknumber  
      table[tracknumber][HWOutIndex]["pan\law"]         - pan-law, default is -1  
      table[tracknumber][HWOutIndex]["automationmode"]  - the automation-mode of this HWOutIndex of tracknumber    
      
      See [GetTrackHWOut](#GetTrackHWOut) for more details on the individual settings, stored in the entries.
  </description>
  <retvals>
    table AllHWOuts - a table with all HWOuts of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, trackmanagement, track, get, all, hwouts, hardware outputs, routing</tags>
</US_DocBloc>
]]

  local AllHWOuts, number_of_tracks = ultraschall.GetAllHWOuts()
  for i=0, number_of_tracks do
    AllHWOuts[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllHWOuts, number_of_tracks
end

--A=ultraschall.GetAllHWOuts2()

function ultraschall.GetAllMainSendStates2()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMainSendStates2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table AllMainSends, integer number_of_tracks  = ultraschall.GetAllMainSendStates2()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all MainSend-settings of all tracks, excluding master-track.
    
    like [GetAllMainSendStates](#GetAllMainSendStates), but includes the type of the track as well.
    
    The MainSend-settings are the settings, if a certain track sends it's signal to the Master Track
    
    returned table is of structure:
      Table["number\_of_tracks"]            - The number of tracks in this table, from track 1 to track n  
      Table[tracknumber]["type"]           - type of the track, SoundBoard, StudioLink, StudioLinkOnAir or Other  
      Table[tracknumber]["MainSend"]       - Send to Master on(1) or off(1)  
      Table[tracknumber]["ParentChannels"] - the parent channels of this track  
      
      See [GetTrackMainSendState](#GetTrackMainSendState) for more details on the individual settings, stored in the entries.
  </description>
  <retvals>
    table AllMainSends - a table with all AllMainSends-entries of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Routing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, trackmanagement, track, get, all, send, main send, master send, routing</tags>
</US_DocBloc>
]]

  local AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates()
  for i=1, number_of_tracks do
    AllMainSends[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllMainSends, number_of_tracks
end

--A,B=ultraschall.GetAllMainSendStates2()


function ultraschall.SetUSExternalState(section, key, value, filename)
-- stores value into ultraschall.ini
-- returns true if successful, false if unsuccessful
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetUSExternalState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetUSExternalState(string section, string key, string value, optional string filename)</functioncall>
  <description>
    stores values into ultraschall.ini. Returns true if successful, false if unsuccessful.
    
    unlike other Ultraschall-API-functions, this converts the values, that you pass as parameters, into strings, regardless of their type
  </description>
  <retvals>
    boolean retval - true, if successful, false if unsuccessful.
  </retvals>
  <parameters>
    string section - section within the ini-file
    string key - key within the section
    string value - the value itself
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, value, insert, store</tags>
</US_DocBloc>
--]]
  -- check parameters
  section=tostring(section)
  key=tostring(key)
  value=tostring(value)  
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("SetUSExternalState","filename", "must be either a string or nil(for ultraschall.ini)", -3) return false end
  if filename==nil then filename="ultraschall.ini" end
  if section:match(".*(%=).*")=="=" then ultraschall.AddErrorMessage("SetUSExternalState","section", "no = allowed in section", -4) return false end

  -- set value
  return ultraschall.SetIniFileValue(section, key, value, reaper.GetResourcePath().."/"..filename)
end

function ultraschall.GetUSExternalState(section, key, filename)
-- gets a value from ultraschall.ini
-- returns length of entry(integer) and the entry itself(string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUSExternalState</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string value = ultraschall.GetUSExternalState(string section, string key, optional string filename)</functioncall>
  <description>
    gets a value from ultraschall.ini. 
    
    returns an empty string in case of an error
  </description>
  <retvals>
    string value  - the value itself; empty string in case of an error or no such extstate
  </retvals>
  <parameters>
    string section - the section of the ultraschall.ini.
    string key - the key of which you want it's value.
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, value, get</tags>
</US_DocBloc>
--]]
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("GetUSExternalState","filename", "must be either a string or nil(for ultraschall.ini)", -3) return false end
  if filename==nil then filename="ultraschall.ini" end
  
  -- check parameters
  if type(section)~="string" then ultraschall.AddErrorMessage("GetUSExternalState","section", "only string allowed", -1) return "" end
  if type(key)~="string" then ultraschall.AddErrorMessage("GetUSExternalState","key", "only string allowed", -2) return "" end
  
  -- get value
  local A, B = ultraschall.GetIniFileValue(section, key, "", reaper.GetResourcePath().."/"..filename)
  if A==-1 then B="" end
  return B
end

--A,AA=ultraschall.GetUSExternalState("ultraschall_clock","docked")

function ultraschall.CountUSExternalState_sec(filename)
--count number of sections in the ultraschall.ini
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountUSExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer section_count = ultraschall.CountUSExternalState_sec(optional filename)</functioncall>
  <description>
    returns the number of [sections] in the ultraschall.ini
  </description>
  <retvals>
    integer section_count  - the number of section in the ultraschall.ini
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, count, section</tags>
</US_DocBloc>
--]]

  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("CountUSExternalState_sec","filename", "must be either a string or nil(for ultraschall.ini)", -3) return false end
  if filename==nil then filename="ultraschall.ini" end
  
  -- check existence of ultraschall.ini/ini-filename
  if reaper.file_exists(reaper.GetResourcePath().."/"..filename)==false then ultraschall.AddErrorMessage("CountUSExternalState_sec","", filename.." does not exist", -1) return -1 end
  
  -- count external-states
  local count=0
  for line in io.lines(reaper.GetResourcePath().."/"..filename) do
    --local check=line:match(".*=.*")
    local check=line:match("%[.*.%]")
    if check~=nil then check="" count=count+1 end
  end
  return count
end

--A=ultraschall.CountUSExternalState_sec()

function ultraschall.CountUSExternalState_key(section, filename)
--count number of keys in the section in ultraschall.ini
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountUSExternalState_key</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer key_count = ultraschall.CountUSExternalState_key(string section, optional string filename)</functioncall>
  <description>
    returns the number of keys in the given [section] in ultraschall.ini
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer key_count  - the number of keys within an ultraschall.ini-section
  </retvals>
  <parameters>
    string section - the section of the ultraschall.ini, of which you want the number of keys.
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, count, key</tags>
</US_DocBloc>
--]]
  -- check parameter and existence of ultraschall.ini
  if type(section)~="string" then ultraschall.AddErrorMessage("CountUSExternalState_key","section", "only string allowed", -1) return -1 end
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("CountUSExternalState_key","filename", "must be either a string or nil(for ultraschall.ini)", -3) return false end
  if filename==nil then filename="ultraschall.ini" end
  
  -- check existence of ultraschall.ini/ini-filename
  if reaper.file_exists(reaper.GetResourcePath().."/"..filename)==false then ultraschall.AddErrorMessage("CountUSExternalState_key","", filename.." does not exist", -1) return -1 end

  -- prepare variables
  local count=0
  local startcount=0
  
  -- count keys
  for line in io.lines(reaper.GetResourcePath().."/"..filename) do
   local check=line:match("%[.*.%]")
    if startcount==1 and line:match(".*=.*") then
      count=count+1
    else
      startcount=0
    if "["..section.."]" == check then startcount=1 end
    if check==nil then check="" end
    end
  end
  
  return count
end

--A=ultraschall.CountUSExternalState_key("view")

function ultraschall.EnumerateUSExternalState_sec(number, filename)
-- returns name of the numberth section in ultraschall.ini or nil, if invalid
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateUSExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string section_name = ultraschall.EnumerateUSExternalState_sec(integer number, optional string filename)</functioncall>
  <description>
    returns name of the numberth section in ultraschall.ini or nil if invalid
  </description>
  <retvals>
    string section_name  - the name of the numberth section within ultraschall.ini
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </retvals>
  <parameters>
    integer number - the number of section, whose name you want to know
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, enumerate, section</tags>
</US_DocBloc>
--]]
  -- check parameter and existence of ultraschall.ini
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec", "number", "only integer allowed", -1) return false end
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","filename", "must be either a string or nil(for ultraschall.ini)", -5) return false end
  if filename==nil then filename="ultraschall.ini" end
  if reaper.file_exists(reaper.GetResourcePath().."/"..filename)==false then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec", "", filename.." does not exist", -2) return -1 end

  if number<=0 then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","number", "no negative number allowed", -3) return nil end
  if number>ultraschall.CountUSExternalState_sec(filename) then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","number", "only "..ultraschall.CountUSExternalState_sec(filename).." sections available", -4) return nil end

  -- look for and return the requested line
  local count=0
  for line in io.lines(reaper.GetResourcePath().."/"..filename) do
    local check=line:match("%[(.-)%]")
    if check~=nil then count=count+1 end
    if count==number then return check end
  end
end 
--A=ultraschall.EnumerateUSExternalState_sec(10)

function ultraschall.EnumerateUSExternalState_key(section, number, filename)
-- returns name of a numberth key within a section in ultraschall.ini or nil if invalid or not existing
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateUSExternalState_key</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string key_name = ultraschall.EnumerateUSExternalState_key(string section, integer number, optional string filename)</functioncall>
  <description>
    returns name of a numberth key within a section in ultraschall.ini or nil if invalid or not existing
  </description>
  <retvals>
    string key_name  - the name ob the numberth key in ultraschall.ini.
  </retvals>
  <parameters>
    string section - the section within ultraschall.ini, where the key is stored.
    integer number - the number of the key, whose name you want to know; 1 for the first one
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </parameters>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, enumerate, key</tags>
</US_DocBloc>
--]]
  -- check parameter
  if type(section)~="string" then ultraschall.AddErrorMessage("EnumerateUSExternalState_key", "section", "only string allowed", -1) return nil end
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateUSExternalState_key", "number", "only integer allowed", -2) return nil end
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","filename", "must be either a string or nil(for ultraschall.ini)", -3) return false end
  if filename==nil then filename="ultraschall.ini" end
  if reaper.file_exists(reaper.GetResourcePath().."/"..filename)==false then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec", "", filename.." does not exist", -4) return -1 end
  
  -- prepare variables
  local count=0
  local startcount=0
  
  -- find and return the proper line
  for line in io.lines(reaper.GetResourcePath().."/"..filename) do
    local check=line:match("%[.*.%]")
    if startcount==1 and line:match(".*=.*") then
      count=count+1
      if count==number then local temp=line:match(".*=") return temp:sub(1,-2) end
    else
      startcount=0
      if "["..section.."]" == check then startcount=1 end
      if check==nil then check="" end
    end
  end
  return nil
end

function ultraschall.DeleteUSExternalState(section, key, filename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteUSExternalState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteUSExternalState(string section, string key, optional string filename)</functioncall>
  <description>
    Deletes an external state from the ultraschall.ini
    
    Returns false in case of error.
  </description>
  <parameters>
    string section - the section, in which the to be deleted-key is located
    string key - the key to delete
    optional string filename - set this to a filename, if you don't want to use ultraschall.ini; it will be stored into the resource-path of Reaper, so no path needed
                             - nil, uses ultraschall.ini
  </parameters>
  <retvals>
    boolean retval - false in case of error; true in case of success
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>configurationmanagement, delete, section, key</tags>
</US_DocBloc>
]]  
  if type(section)~="string" then ultraschall.AddErrorMessage("DeleteUSExternalState", "section", "must be a string", -1) return false end
  if type(key)~="string" then ultraschall.AddErrorMessage("DeleteUSExternalState", "key", "must be a string", -2) return false end
  
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("DeleteUSExternalState","filename", "must be either a string or nil(for ultraschall.ini)", -7) return false end
  if filename==nil then filename="ultraschall.ini" end
  if reaper.file_exists(reaper.GetResourcePath().."/"..filename)==false then ultraschall.AddErrorMessage("DeleteUSExternalState", "", filename.." does not exist", -8) return -1 end
  
  local A,B,C=ultraschall.ReadFullFile(reaper.GetResourcePath().."/"..filename)
  if A==nil then ultraschall.AddErrorMessage("DeleteUSExternalState", "", "no "..filename.." present", -3) return false end
  A="\n"..A.."\n["
  local Start, Part, EndOf = A:match("()\n(%["..section.."%]\n.-)()\n%[")
  if Part==nil then ultraschall.AddErrorMessage("DeleteUSExternalState", "section", "no such section "..section.." in "..filename, -4) return false end
  local Part=Part.."\n"
  local Part2=string.gsub(Part, key.."=.-\n", "")
  if Part2==Part then ultraschall.AddErrorMessage("DeleteUSExternalState", "key", "no such key in section "..section.." in "..filename, -5) return false end
  local A2=A:sub(2,Start)..Part2:sub(1,-2)..A:sub(EndOf, -2)
  if A2~=A then
    local O=ultraschall.WriteValueToFile(reaper.GetResourcePath().."/"..filename, A2)
    if O==-1 then ultraschall.AddErrorMessage("DeleteUSExternalState", "", "nothing deleted", -6) return false end
  else
    return false
  end
end
--A1=ultraschall.DeleteUSExternalState("hulubuluberg","3")

function ultraschall.Soundboard_StopAllSounds()
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_StopAllSounds</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_StopAllSounds()</functioncall>
    <description>
      Stops all sounds currently playing in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, stop all sounds</tags>
  </US_DocBloc>
  ]]  
  for i=0, 23 do
    reaper.StuffMIDIMessage(0, 144,72+i,0)
  end
end

function ultraschall.Soundboard_TogglePlayPause(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_TogglePlayPause</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_TogglePlayPause(integer playerindex)</functioncall>
    <description>
      Toggles between Play and Pause of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, play, pause, toggle</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_TogglePlayPause", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_TogglePlayPause", "playerindex", "must be between 1 and 24", -2) return false end
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=24+playerindex-1
  local Velocity=1  
      
  reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end

--ultraschall.Soundboard_TogglePlayPause(1)

function ultraschall.Soundboard_TogglePlayStop(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_TogglePlayStop</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_TogglePlayStop(integer playerindex)</functioncall>
    <description>
      Toggles between Play and Stop of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, play, stop, toggle</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_TogglePlayStop", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_TogglePlayStop", "playerindex", "must be between 1 and 24", -2) return false end
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=playerindex-1
  local Velocity=1  
    
    reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end

--ultraschall.Soundboard_TogglePlayStop(1)

function ultraschall.Soundboard_Play(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_Play</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_Play(integer playerindex)</functioncall>
    <description>
      Starts playing of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, play</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_Play", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_Play", "playerindex", "must be between 1 and 24", -2) return false end    
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=72+playerindex-1
  local Velocity=1  
    
  reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end

--ultraschall.Soundboard_Play(1)

function ultraschall.Soundboard_Stop(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_Stop</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_Stop(integer playerindex)</functioncall>
    <description>
      Stops playing of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, stop</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_Stop", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_Stop", "playerindex", "must be between 1 and 24", -2) return false end    
  local mode=0            -- set to virtual keyboard of Reaper
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=72+playerindex-1
  local Velocity=0
    
  reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end

--ultraschall.Soundboard_Stop(1)

function ultraschall.Soundboard_TogglePlay_FadeOutStop(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_TogglePlay_FadeOutStop</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_TogglePlay_FadeOutStop(integer playerindex)</functioncall>
    <description>
      Toggles between Play and FadeOut with Stop of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, fadeout, play, stop</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_TogglePlay_FadeOutStop", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_TogglePlay_FadeOutStop", "playerindex", "must be between 1 and 24", -2) return false end    
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=48+playerindex-1
  local Velocity=1
    
  reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end

--ultraschall.Soundboard_Play_FadeOutStop(1)

function ultraschall.Soundboard_PlayList_CurrentIndex()
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_PlayList_CurrentIndex</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>integer current_playlist_position = ultraschall.Soundboard_PlayList_CurrentIndex()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Returns the position within the playlist of the Ultraschall Soundboard.
      
      Playlist means, the player within all players of the Ultraschall-Soundboard.
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
      
      For other playlist-related functions, see also [SoundBoard\_PlayList\_SetIndex](#SoundBoard_PlayList_SetIndex), [SoundBoard\_PlayList\_Next](#SoundBoard_PlayList_Next) and [SoundBoard\_PlayList\_Previous](#SoundBoard_PlayList_Previous)      
    </description>
    <retvals>
      integer current_playlist_position - the position in the playlist
    </retvals>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, playlist, current position</tags>
  </US_DocBloc>
  ]]  
  local retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
  if tonumber(Position)==-1 then Position=0 end
  return tonumber(math.tointeger(Position))
end

--A=ultraschall.Soundboard_PlayList_CurrentIndex()

function ultraschall.Soundboard_PlayList_SetIndex(playerindex, play, stop_all_others)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_PlayList_SetIndex</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_PlayList_SetIndex(integer playerindex, optional boolean play, optional boolean stop_all_others)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      sets a new playerindex within the playlist of the Ultraschall-Soundboard.
      
      You can optionally start the player and stop all others currently playing.
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
      
      For other playlist-related functions, see also [Soundboard\_PlayList\_CurrentIndex](#Soundboard_PlayList_CurrentIndex), [SoundBoard\_PlayList\_Next](#SoundBoard_PlayList_Next) and [SoundBoard\_PlayList\_Previous](#SoundBoard_PlayList_Previous) 
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
      optional boolean play - true, start playing of this player immediately; nil or false, don't start playing
      optional boolean stop_all_others - true, stop all other players currently playing; nil or false, don't stop anything
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, playlist, set, playerindex, play, stop all others</tags>
  </US_DocBloc>
  ]]  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("SoundBoard_PlayList_SetIndex", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("SoundBoard_PlayList_SetIndex", "playerindex", "must be between 1 and 24", -2) return false end
  local retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
  local retval = reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", playerindex-1)
  if tonumber(Position)==-1 then Position=0 end
  if stop_all_others==true then
    ultraschall.Soundboard_StopAllSounds()
  end
  if play==true then 
    ultraschall.Soundboard_Play(playerindex)
  end
  return tonumber(math.tointeger(Position))
end

--A=ultraschall.Soundboard_PlayList_SetIndex(9, true, true)
--A1=ultraschall.Soundboard_PlayList_CurrentIndex()

function ultraschall.Soundboard_PlayList_Next()
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_PlayList_Next</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_PlayList_Next()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Stops current player and starts the next player within the playlist of the Ultraschall-Soundboard.
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    
      For other playlist-related functions, see also [Soundboard\_PlayList\_CurrentIndex](#Soundboard_PlayList_CurrentIndex), [SoundBoard\_PlayList\_SetIndex](#SoundBoard_PlayList_SetIndex) and [SoundBoard\_PlayList\_Previous](#SoundBoard_PlayList_Previous)      
    </description>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, playlist, next, playerindex, play</tags>
  </US_DocBloc>
  ]]  
  local retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
  if tonumber(Position)>24 then P=1 return end
  
  reaper.StuffMIDIMessage(0, 144,72+Position,0)
  reaper.StuffMIDIMessage(0, 144,72+Position+1,1)
  
  if tonumber(Position)+1>24 then Position=24 end
  reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", Position+1)
end

--ultraschall.Soundboard_PlayList_Next()

function ultraschall.Soundboard_PlayList_Previous()
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SoundBoard_PlayList_Previous</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_PlayList_Previous()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Stops current player and starts the previous player within the playlist of the Ultraschall-Soundboard.
      
      When the previous would be before the first, it will not do anything.
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
      
      For other playlist-related functions, see also [Soundboard\_PlayList\_CurrentIndex](#Soundboard_PlayList_CurrentIndex), [SoundBoard\_PlayList\_SetIndex](#SoundBoard_PlayList_SetIndex) and [SoundBoard\_PlayList\_Next](#SoundBoard_PlayList_Next).
    </description>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
    <tags>ultraschall, soundboard, playlist, next, playerindex, play</tags>
  </US_DocBloc>
  ]]  
  local retval, Position=reaper.GetProjExtState(0, "ultraschall_soundboard", "playlistindex")
  if tonumber(Position)==-1 then return end
  
  reaper.StuffMIDIMessage(0, 144,72+Position,0)
  reaper.StuffMIDIMessage(0, 144,72+Position-1,1)
  
  reaper.SetProjExtState(0, "ultraschall_soundboard", "playlistindex", Position-1) 
end

--ultraschall.Soundboard_PlayList_Previous()

function ultraschall.Soundboard_PlayFadeIn(playerindex)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Soundboard_PlayFadeIn</slug>
    <requires>
      Ultraschall=4.00
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>ultraschall.Soundboard_PlayFadeIn(integer playerindex)</functioncall>
    <description>
      Starts a sound with a fade-in of a certain player in the Ultraschall-SoundBoard
      
      Needs ultraschall-Soundboard installed to be useable!
      
      Track(s) who hold the soundboard must be recarmed and recinput set to MIDI or VKB.
    </description>
    <parameters>
      integer playerindex - the player of the SoundBoard; from 1-24
    </parameters>
    <chapter_context>
      Ultraschall Specific
      Soundboard
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>ultraschall, soundboard, play, fadein</tags>
  </US_DocBloc>
  ]]  
  
  if math.type(playerindex)~="integer" then ultraschall.AddErrorMessage("Soundboard_PlayFadeIn", "playerindex", "must be an integer", -1) return false end
  if playerindex<1 or playerindex>24 then ultraschall.AddErrorMessage("Soundboard_PlayFadeIn", "playerindex", "must be between 1 and 24", -2) return false end
  local mode=0            -- set to virtual keyboard of Reaper
  local MIDIModifier=144  -- set to MIDI-Note
  local Note=96+playerindex-1
  local Velocity=1  
      
  reaper.StuffMIDIMessage(mode, MIDIModifier, Note, Velocity)
end 

function ultraschall.LUFS_Metering_MatchGain()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_MatchGain</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.LUFS_Metering_MatchGain()</functioncall>
  <description>
    Hits programmatically the "Match Gain"-Button of Ultraschall's LUFS Loudness Meter, when running(only available in Ultraschall-installations).
  </description>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, lufs, loudness meter, hit, match gain, button</tags>
</US_DocBloc>
--]]
  local old_attached_name=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("lufs")
  reaper.gmem_write(5,1)
  reaper.gmem_attach(old_attached_name)
end

--ultraschall.LUFS_Metering_MatchGain()
--]]

function ultraschall.LUFS_Metering_Reset()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_Reset</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.LUFS_Metering_Reset()</functioncall>
  <description>
    Hits programmatically the "Reset"-Button of Ultraschall's LUFS Loudness Meter, when running(only available in Ultraschall-installations).
  </description>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, lufs, loudness meter, hit, reset, button</tags>
</US_DocBloc>
--]]
  local old_attached_name=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("lufs")
  reaper.gmem_write(4,1)
  reaper.gmem_attach(old_attached_name)
end

function ultraschall.LUFS_Metering_GetValues()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_GetValues</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>number LUFS_integral, number LUFS_target, number dB_Gain, integer FX_active = ultraschall.LUFS_Metering_GetValues()</functioncall>
  <description>
    Returns current LUFS-values of Ultraschall's LUFS Loudness Meter, when running(only available in Ultraschall-installations).
  </description>
  <retvals>
    number LUFS_integral - the integral LUFS-value currently measured
    number LUFS_target - the LUFS-target currently set in the UI of the jsfx
    number dB_Gain - the gain currently set in the UI of the effect in dB
    integer FX_active - 0, the fx isn't active(usually when playback stopped); 1, the fx is active(during playback for instance)
  </retvals>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, lufs, loudness meter, get, values, integral, target, gain</tags>
</US_DocBloc>
--]]
  local old_attached_name=reaper.gmem_attach("lufs")
  local LUFS_integral=reaper.gmem_read(1)
  local LUFS_target=reaper.gmem_read(2)
  local FX_active=math.tointeger(reaper.gmem_read(3))
  local Gain=reaper.gmem_read(6)
  reaper.gmem_attach(old_attached_name)
  return LUFS_integral, LUFS_target, Gain, FX_active
end

function ultraschall.LUFS_Metering_SetValues(LUFS_target, Gain)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_SetValues</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.LUFS_Metering_SetValues(optional integer LUFS_target, optional number dB_Gain)</functioncall>
  <description>
    Returns current LUFS-values of Ultraschall's LUFS Loudness Meter, when running(only available in Ultraschall-installations).
  </description>
  <retvals>
    optional integer LUFS_target - the LUFS-target
                                 - 0, -14 LUFS (Spotify)
                                 - 1, -16 LUFS (Podcast)
                                 - 2, -18 LUFS
                                 - 3, -20 LUFS
                                 - 4, -23 LUFS (EBU R128)
    optional number dB_Gain - the gain of the effect in dB
  </retvals>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, set, lufs, loudness meter, values, target, gain</tags>
</US_DocBloc>
--]]
  local old_attached_name=reaper.gmem_attach("lufs")
  if LUFS_target~=nil then reaper.gmem_write(8, LUFS_target) end
  if Gain~=nil then reaper.gmem_write(7, Gain) end
  reaper.gmem_attach(old_attached_name)

end

--ultraschall.LUFS_Metering_SetValues(4, 2)

function ultraschall.LUFS_Metering_AddEffect(enabled)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_AddEffect</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>boolean added = ultraschall.LUFS_Metering_AddEffect(boolean enabled)</functioncall>
  <description>
    Adds Ultraschall's LUFS Loudness Meter into the Master Track(only available in Ultraschall-installations).
    
    Parameter enabled is always working, even if the fx has already been added.
  </description>
  <retvals>
    boolean added - true, fx has been added; false, fx hasn't been added as it was already present.
  </retvals>
  <parameters>
    boolean enabled - true, enable the fx; false, disable the fx
  </parameters>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, add, lufs, loudness meter, enabled</tags>
</US_DocBloc>
--]]
  if enabled==nil then enabled=false end
  local tr = reaper.GetMasterTrack(0)
  local index=-1
  for i=0, reaper.TrackFX_GetCount(tr)-1 do
    local retval, fx=reaper.TrackFX_GetFXName(tr, i)
    if fx:match("LUFS Loudness Metering") then
      index=i
    end
  end
  if index==-1 then
    local A=reaper.TrackFX_AddByName(tr, "dynamics/LUFS_Loudness_Meter", false, -1)
    local A=reaper.TrackFX_SetEnabled(tr, reaper.TrackFX_GetCount(tr)-1, enabled)
    return true
  else
    local A=reaper.TrackFX_SetEnabled(tr, index, enabled)
    return false
  end
end

--A=ultraschall.LUFS_Metering_AddEffect(true)

function ultraschall.LUFS_Metering_ShowEffect()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_ShowEffect</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.LUFS_Metering_ShowEffect()</functioncall>
  <description>
    Shows Ultraschall's LUFS Loudness Meter in the Master Track(only available in Ultraschall-installations).
  </description>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, show, lufs, loudness meter, enabled</tags>
</US_DocBloc>
--]]
  local tr = reaper.GetMasterTrack(0)
  local index=-1
  for i=0, reaper.TrackFX_GetCount(tr)-1 do
    local retval, fx=reaper.TrackFX_GetFXName(tr, i)
    if fx:match("LUFS Loudness Metering") then
      index=i
    end
  end
  if index~=-1 then
    reaper.TrackFX_SetOpen(tr, index, true)
  end
end

--ultraschall.LUFS_Metering_ShowEffect()
