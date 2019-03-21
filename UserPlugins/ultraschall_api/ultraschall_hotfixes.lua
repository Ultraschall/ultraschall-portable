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
-- That way, you can help making it more stable without being dependend on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="19_Mar_2019"

function ultraschall.GetAllMainSendStates()
  -- returns table, of the structure:
  -- Table[tracknumber]["MainSend"]      - Send to Master on(1) or off(1)
  -- Table[tracknumber]["ParentChannels"] - the parent channels of this track

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllMainSendStates</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table AllMainSends, integer number_of_tracks  = ultraschall.GetAllMainSendStates()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns a table with all MainSend-settings of all tracks, excluding master-track.
    
    The MainSend-settings are the settings, if a certain track sends it's signal to the Master Track
    
    returned table is of structure:
      Table["number\_of_tracks"]           - The number of tracks in this table, from track 1 to track n
      Table["MainSend"]=true               - signals, this is an AllMainSends-table
      Table[tracknumber]["MainSend"]       - Send to Master on(1) or off(1)
      Table[tracknumber]["ParentChannels"] - the parent channels of this track
      
      See [GetTrackMainSendState](#GetTrackMainSendState) for more details on the individual settings, stored in the entries.
  </description>
  <retvals>
    table AllMainSends - a table with all AllMainSends-entries of the current project.
    integer number_of_tracks - the number of tracks in the AllMainSends-table
  </retvals>
  <chapter_context>
    Track Management
    Send/Receive-Routing
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, track, get, all, send, main send, master send, routing</tags>
</US_DocBloc>
]]
  
  local MainSend={}
  MainSend["number_of_tracks"]=reaper.CountTracks()
  MainSend["MainSend"]=true
  for i=1, reaper.CountTracks() do
    MainSend[i]={}
    MainSend[i]["MainSendOn"], MainSend[i]["ParentChannels"] = ultraschall.GetTrackMainSendState(i)
  end
  return MainSend, reaper.CountTracks()
end

function ultraschall.IsTrackSoundboard(tracknumber)
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackSoundboard", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackSoundboard", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    local count=0
    while reaper.TrackFX_GetFXName(track, count, "")~="" do
      local retval, buf = reaper.TrackFX_GetFXName(track, count, "")
      if buf=="AUi: Ultraschall: Soundboard" then return true, count end -- Mac-check
      if buf=="VSTi: Soundboard (Ultraschall)" then return true, count end -- Windows-check
      if buf=="" then return false end
      count=count+1
    end
  end
  return false
end

--A=ultraschall.IsTrackSoundboard(33)

function ultraschall.IsTrackStudioLink(tracknumber)
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLink", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLink", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    local count=0
    while reaper.TrackFX_GetFXName(track, count, "")~="" do
      local retval, buf = reaper.TrackFX_GetFXName(track, count, "")
      if buf=="AU: ITSR: StudioLink" then return true, count end -- Mac-check
      if buf=="VST: StudioLink (IT-Service Sebastian Reimers)" then return true, count end -- Windows-check
      if buf=="" then return false end
      count=count+1
    end
  end
  return false
end

--A=ultraschall.IsTrackStudioLink(3)


function ultraschall.IsTrackStudioLinkOnAir(tracknumber)
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
  if tracknumber==0 then track=reaper.GetMasterTrack(0) else track=reaper.GetTrack(0,tracknumber-1) end
  if track~=nil then
    local count=0
    while reaper.TrackFX_GetFXName(track, count, "")~="" do
      local retval, buf = reaper.TrackFX_GetFXName(track, count, "")
      if buf=="ITSR: StudioLinkOnAir" then return true, count end -- Mac-check
      if buf=="VST: StudioLinkOnAir (IT-Service Sebastian Reimers)" then return true, count end -- Windows-check
      if buf=="" then return false end
      count=count+1
    end
  end
  return false
end


function ultraschall.GetTypeOfTrack(tracknumber)
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "must be an integer", -1) return false end
  if tracknumber<0 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("IsTrackStudioLinkOnAir", "tracknumber", "no such track; must be between 1 and "..reaper.CountTracks(0).." for the current project. 0, for master-track.", -2) return false end
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
  local AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives()
  for i=1, number_of_tracks do
    AllAUXSendReceives[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllAUXSendReceives, number_of_tracks
end

--A,B=ultraschall.GetAllAUXSendReceives2()

function ultraschall.GetAllHWOuts2()
  local AllHWOuts, number_of_tracks = ultraschall.GetAllHWOuts()
  for i=0, number_of_tracks do
    AllHWOuts[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllHWOuts, number_of_tracks
end

--A=ultraschall.GetAllHWOuts2()

function ultraschall.GetAllMainSendStates2()
  local AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates()
  for i=1, number_of_tracks do
    AllMainSends[i]["type"]=ultraschall.GetTypeOfTrack(i)
  end
  return AllMainSends, number_of_tracks
end

--A=ultraschall.GetAllHWOuts2()

--A,B=ultraschall.GetAllMainSendStates2()

--AllHWOuts, number_of_tracks = ultraschall.GetAllHWOuts2()
--AllHWOuts2, number_of_tracks = ultraschall.GetAllHWOuts2()

function ultraschall.AreHWOutsTablesEqual(Table1, Table2)
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["HWOuts"]~=true or Table2["HWOuts"]~=true then return false end
  if Table1["HWOuts"]~=Table2["HWOuts"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=0, Table1["number_of_tracks"] do
    if Table1[i]["HWOut_count"]~=Table2[i]["HWOut_count"] then return false end
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    for a=1, Table1[i]["HWOut_count"] do
      if Table1[i][a]["automationmode"]~=Table2[i][a]["automationmode"] then return false end
      if Table1[i][a]["mute"]~=Table2[i][a]["mute"] then return false end
      if Table1[i][a]["outputchannel"]~=Table2[i][a]["outputchannel"] then return false end
      if Table1[i][a]["pan"]~=Table2[i][a]["pan"] then return false end
      if Table1[i][a]["phase"]~=Table2[i][a]["phase"] then return false end
      if Table1[i][a]["post_pre_fader"]~=Table2[i][a]["post_pre_fader"] then return false end
      if Table1[i][a]["source"]~=Table2[i][a]["source"] then return false end
      if Table1[i][a]["unknown"]~=Table2[i][a]["unknown"] then return false end
      if Table1[i][a]["volume"]~=Table2[i][a]["volume"] then return false end
    end
  end
  return true
end

--AllHWOuts2[0]["type"]=3
--AAAA=ultraschall.AreHWOutsTablesEqual(AllHWOuts, AllHWOuts2)



--AllMainSends, number_of_tracks = ultraschall.GetAllMainSendStates2() 
--AllMainSends2, number_of_tracks = ultraschall.GetAllMainSendStates2() 

function ultraschall.AreMainSendsTablesEqual(Table1, Table2)
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["MainSend"]~=true or Table2["MainSend"]~=true then return false end
  if Table1["MainSend"]~=Table2["MainSend"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=1, Table1["number_of_tracks"] do
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    if Table1[i]["MainSendOn"]~=Table2[i]["MainSendOn"] then return false end
    if Table1[i]["ParentChannels"]~=Table2[i]["ParentChannels"] then return false end
  end
  return true
end

--AllMainSends["MainSend"]=0
--AA=ultraschall.AreMainSendsTablesEqual(AllMainSends, AllMainSends2)



--AllAUXSendReceives, number_of_tracks = ultraschall.GetAllAUXSendReceives2()
--AllAUXSendReceives2, number_of_tracks = ultraschall.GetAllAUXSendReceives2()

function ultraschall.AreAUXSendReceivesTablesEqual(Table1, Table2)
  if type(Table1)~="table" then return false end
  if type(Table2)~="table" then return false end
  if Table1["AllAUXSendReceives"]~=true or Table2["AllAUXSendReceives"]~=true then return false end
  if Table1["AllAUXSendReceives"]~=Table2["AllAUXSendReceives"] then return false end
  if Table1["number_of_tracks"]~=Table2["number_of_tracks"] then return false end
  for i=1, Table1["number_of_tracks"] do
    if Table1[i]["AUXSendReceives_count"]~=Table2[i]["AUXSendReceives_count"] then return false end
    if Table1[i]["type"]~=nil and Table2[i]["type"]~=nil and Table1[i]["type"]~=Table2[i]["type"] then return false end
    for a=1, Table1[i]["AUXSendReceives_count"] do
      if Table1[i][a]["automation"]~=Table2[i][a]["automation"] then return false end
      if Table1[i][a]["chan_src"]~=Table2[i][a]["chan_src"] then return false end
      if Table1[i][a]["midichanflag"]~=Table2[i][a]["midichanflag"] then return false end
      if Table1[i][a]["mono_stereo"]~=Table2[i][a]["mono_stereo"] then return false end
      if Table1[i][a]["mute"]~=Table2[i][a]["mute"] then return false end
      if Table1[i][a]["pan"]~=Table2[i][a]["pan"] then return false end
      if Table1[i][a]["phase"]~=Table2[i][a]["phase"] then return false end
      if Table1[i][a]["post_pre_fader"]~=Table2[i][a]["post_pre_fader"] then return false end
      if Table1[i][a]["recv_tracknumber"]~=Table2[i][a]["recv_tracknumber"] then return false end
      if Table1[i][a]["snd_src"]~=Table2[i][a]["snd_src"] then return false end
      if Table1[i][a]["unknown"]~=Table2[i][a]["unknown"] then return false end
      if Table1[i][a]["volume"]~=Table2[i][a]["volume"] then return false end
    end
  end
  return true
end

--AllAUXSendReceives["AllAUXSendReceives"]=1
--A=ultraschall.AreAUXSendReceivesTablesEqual(AllAUXSendReceives, AllAUXSendReceives2)


--ultraschall.ShowLastErrorMessage()

