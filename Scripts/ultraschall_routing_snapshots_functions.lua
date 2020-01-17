--[[
################################################################################
#
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
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


function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

function runcommand(cmd)  -- run a command by its name

  start_id = reaper.NamedCommandLookup(cmd)
  reaper.Main_OnCommand(start_id,0)

end

function GetPath(str,sep)

    return str:match("(.*"..sep..")")

end

function saveSnapshot(slot)

  RoutingInfo=getRoutingInfo()
  retval = reaper.SetProjExtState(0, "snapshots", slot, RoutingInfo)
  buildTable()

end

function saveSnapshotPure(slot)

  RoutingInfo=getRoutingInfo()
  retval = reaper.SetProjExtState(0, "snapshots", slot, RoutingInfo)

end

function clearSnapshot(slot)

  retval = reaper.SetProjExtState(0, "snapshots", slot, "")
  ButtonID = {}
  ButtonID[1] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_1") -- Preshow
  ButtonID[2] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_2") -- Recording
  ButtonID[3] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_3") -- Aftershow
  ButtonID[4] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_4") -- Editing

reaper.SetToggleCommandState(0, ButtonID[slot], 0)
 reaper.RefreshToolbar2(0, ButtonID[slot])

  buildTable()

end

function switchButtons(slot)

  ButtonID = {}
  ButtonID[1] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_1") -- Preshow
  ButtonID[2] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_2") -- Recording
  ButtonID[3] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_3") -- Aftershow
  ButtonID[4] = reaper.NamedCommandLookup("_Ultraschall_Snapshot_4") -- Editing

  reaper.SetToggleCommandState(0, ButtonID[1], 0)    -- erase all buttons states
  reaper.SetToggleCommandState(0, ButtonID[2], 0)
  reaper.SetToggleCommandState(0, ButtonID[3], 0)
  reaper.SetToggleCommandState(0, ButtonID[4], 0)
  reaper.SetToggleCommandState(0, ButtonID[slot], 1)  -- yes, this feels clumsy. Any beter ideas?

end


function recallSnapshot(slot)

  retval, valOutNeedBig=reaper.GetProjExtState(0, "snapshots", slot)
    setRoutingInfo(valOutNeedBig)
  buildTable()
  switchButtons(slot)

end


function buildTable()
  -- body

  img_adress = reaper.GetResourcePath().."/ColorThemes/Ultraschall_2/routing_snapshots.png"

  Label = {"Preshow","Recording","Aftershow","Editing"}


  GUI.elms = {

--     name          = element type          x      y    w    h     caption               ...other params...
  label           = GUI.Lbl:new(          23,  50+y_offset,  "Use routing snapshots to manage different recording situations.", 0),
  label2       = GUI.Lbl:new(      23,  75+y_offset,  "These snapshots save and recall all information of the", 0),
  routingbutton   = GUI.Btn:new(          375, 41, 130, 22,    " Routing Matrix", runcommand, 40251),

}

  for i = 1,4 do

    GUI.elms[i+1]      = GUI.Lbl:new(          55, 36+(i*64),        Label[i], 0)


    if reaper.GetProjExtState(0, "snapshots", i) == 0 then
      GUI.elms[i+5]    = GUI.Subpic:new(    20,  30+(i*64), 25, 25, 1, img_adress, 2, 3+((i-1)*30))
      GUI.elms[i+10]      = GUI.Lbl:new(          200, 36+(i*64),        " free", 0)
      GUI.elms[i+15]      = GUI.Btn:new(          305, 29+(i*64), 130, 30,    " Save (Shift+F"..i..")", saveSnapshot, i)
    else
      retval, valOutNeedBig=reaper.GetProjExtState(0, "snapshots", i)
      if getRoutingInfo() == valOutNeedBig then
        GUI.elms[i+5]    = GUI.Subpic:new(    20,  30+(i*64), 25, 25, 1, img_adress, 62, 3+((i-1)*30))
      else
        GUI.elms[i+5]    = GUI.Subpic:new(    20,  30+(i*64), 25, 25, 1, img_adress, 2, 3+((i-1)*30))
      end

      GUI.elms[i+10]      = GUI.Btn:new(          155, 29+(i*64), 130, 30,    " Recall (F"..i..")", recallSnapshot, i)
      GUI.elms[i+15]      = GUI.Btn:new(          305, 29+(i*64), 130, 30,    " Update (Shift+F"..i..")", saveSnapshot, i)
      GUI.elms[i+20]      = GUI.Btn:new(          455, 29+(i*64), 50, 30,    " Clear", clearSnapshot, i)
    end

    GUI.elms[i+25]      = GUI.Line:new(      0,11+(i*64),620,11+(i*64))

  end


-- table.insert (GUI.elms, label)

end


-- initiate values

function Main(slot)

  retval, valOutNeedBig=reaper.GetProjExtState(0, "snapshots", slot)
  if retval == 1 then  -- there is already a routing snapshot, so just recall

    setRoutingInfo(valOutNeedBig)
    switchButtons(slot)

  else        -- there is no snapshot, so open the interface

    local info = debug.getinfo(1,'S');
    script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
    GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

    GUI.name = "Ultraschall Routing Snapshots"
    GUI.w, GUI.h = 525, 332

    -- position always in the centre of the screen

    l, t, r, b = 0, 0, GUI.w, GUI.h
    __, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
    GUI.x, GUI.y = 83, (screen_h - GUI.h) / 2

    y_offset = -30  -- move all content up/down

    buildTable()

      ---- Put all of your own functions and whatever here ----

    --Msg("hallo")

      ---- Main loop ----

    --[[

      If you want to run a function during the update loop, use the variable GUI.func prior to
      starting GUI.Main() loop:

      GUI.func = my_function
      GUI.freq = 5     <-- How often in seconds to run the function, so we can avoid clogging up the CPU.
                - Will run once a second if no value is given.
                - Integers only, 0 will run every time.

      GUI.Init()
      GUI.Main()

    ]]--


  -- Open Snapshot-Editor-window only, when it hasn't been opened yet
  if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).
                                                                                    -- If yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
  else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows

  if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                          -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc
    GUI.Init()
    GUI.Main()
  end

  end

end


function dbg(text)
    if debug then reaper.ShowConsoleMsg(tostring(text).."\n") end
end
function dbg2(text,text2)
    if debug then reaper.ShowConsoleMsg(tostring(text)..tostring(text2).."\n") end
end

function GetTrackReceives(track) -- returns all lines starting with AUXRECV of TrackStateChunk in <track>
  local TrackStateChunk=""
  local TrackReceives=""
  local child=""
  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,8)=="AUXRECV " and child =="TRACK" then
      if TrackReceives=="" then
        TrackReceives=line
      else
        TrackReceives=TrackReceives.."\n"..line
      end
    end
  end
  return TrackReceives
end

function GetTrackReceivesGUID(track) -- returns all lines starting with AUXRECV of TrackStateChunk, track# is replaced with trackGUID
  local new_TrackReceives=""
  local parameter=""
  local last_parameter=""
  local new_line=""
  local GUID=""
  local TrackReceives=GetTrackReceives(track)

  for line in TrackReceives:gmatch("[^\r\n]+") do
    last=""
    new_line=""
    for parameter in line:gmatch("[^ ]+") do
      if parameter~="AUXRECV" then parameter=" "..parameter end
      if last_parameter=="AUXRECV" then
        GUID=reaper.GetTrackGUID(reaper.GetTrack(0,parameter))
        parameter=" "..GUID
      end
      last_parameter=parameter
      new_line=new_line..parameter
    end
    if new_TrackReceives=="" then
      new_TrackReceives=new_line
    else
      if new_line~="" then new_TrackReceives=new_TrackReceives.."\n"..new_line end
    end
  end
  return new_TrackReceives
end

function SetTrackReceives(track, auxrecv_list) -- write AUXRECV lines to track's StateChunk, replacing the old ones.
  local retval=0
  local TrackStateChunk=""
  local new_TrackStateChunk=""
  local line=""
  local insert=""
  local child=""
  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    insert=""
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,5)=="PERF " then insert="\n"..auxrecv_list end --insert AUXREF here
    if string.sub(line,1,8)=="AUXRECV " and child =="TRACK" then
      -- do nothing (do not copy old AUXRECVs)
      else
      new_TrackStateChunk=new_TrackStateChunk.."\n"..line..insert
    end
  end
  return reaper.SetTrackStateChunk(track, new_TrackStateChunk)
end

function SetTrackReceivesGUID(track, auxrecvGUID_list) -- write AUXRECV lines with trackGUID instead of track# to track's StateChunk. Replace the old ones.
  local GUID_table={}
  local tracknum=0
  local line=""
  local parameter=""
  local parameter_new=""
  local id=0
  local last_parameter=""
  local new_TrackReceives=""
  local first=0
  local ignore=0
  local new_line=""

  for tracknum=0,reaper.GetNumTracks()-1 do
    GUID_table[tracknum]=reaper.GetTrackGUID(reaper.GetTrack(0,tracknum))
  end

  for line in auxrecvGUID_list:gmatch("[^\r\n]+") do
    last_parameter=""
    new_line=""
    for parameter in line:gmatch("[^ ]+") do
      if last_parameter=="AUXRECV" then
        for id=0,#GUID_table,1 do
          if parameter==GUID_table[id] then
            parameter_new=tostring(id)
          end
        end
        if parameter_new~=nil then
          parameter=parameter_new
          ignore=0
        else
          parameter=""
          ignore=1
        end
      end
      if parameter~="AUXRECV" then parameter=" "..parameter end
      last_parameter=parameter
      new_line=new_line..parameter
    end
    if ignore==0 then
      if first==0 then
        new_TrackReceives=new_line
        first=1
      else
        new_TrackReceives=new_TrackReceives.."\n"..new_line
      end
    end
  end
  return SetTrackReceives(track,new_TrackReceives)
end

function getMainSends(track) -- returns all lines starting with VOLPAN and MAINSEND in the <track>
  local retval=0
  local TrackStateChunk=""
  local newTrackStateChunk=""
  local line=""
  local child=""

  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then child ="TRACK" end
    end
    if (string.sub(line,1,7)=="VOLPAN " or string.sub(line,1,9)=="MAINSEND ") and child =="TRACK" then
      if newTrackStateChunk=="" then
        newTrackStateChunk=line
      else
        newTrackStateChunk=newTrackStateChunk.."\n"..line
      end
    end
  end
  if newTrackStateChunk~="" then
    return newTrackStateChunk
  end
end

function setMainSends(track, MainSends) -- write lines with VOLPAN and MAINSEND to TrackStateChunk, replacing the old ones.
  local TrackStateChunk=""
  local new_TrackStateChunk=""
  local retval=0
  local line=""
  local insert=""
  local child=""

  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")   -- get whole chunk
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    insert=""
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,8) == "MIDIOUT " then insert="\n"..MainSends end
    if (string.sub(line,1,7)== "VOLPAN " or string.sub(line,1,9)=="MAINSEND ") and child =="TRACK" then
      -- do nothing (do not copy old entries)
      else
      new_TrackStateChunk=new_TrackStateChunk.."\n"..line..insert
    end
  end
  return reaper.SetTrackStateChunk(track, new_TrackStateChunk)
end

function getHardwareSends(track) --returns all lines with HWOUT in <track>
  local retval=0
  local TrackStateChunk=""
  local HardwareSends=""
  local line=""
  local child=""

  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then child ="TRACK" end
    end
    if string.sub(line,1,6)=="HWOUT " and child =="TRACK" then
      if HardwareSends=="" then
        HardwareSends=line
      else
        HardwareSends=HardwareSends.."\n"..line
      end
    end
  end
  if HardwareSends~="" then
    return HardwareSends
  else
    return ""
  end
end

function setHardwareSends(track, HardwareSends) -- write lines with HWOUT to TrackStateChunk, replacing the old ones.
  local retval=0
  local TrackStateChunk=""
  local new_TrackStateChunk=""
  local line=""
  local insert=""
  local child=""
  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")   -- get whole chunk
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    insert=""
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,9) == "MAINSEND " and child =="TRACK" then insert="\n"..HardwareSends end
    if string.sub(line,1,6) == "HWOUT "    and child =="TRACK" then
      -- do nothing (do not copy old entries)
      else
      new_TrackStateChunk=new_TrackStateChunk.."\n"..line..insert
    end
  end
  return reaper.SetTrackStateChunk(track, new_TrackStateChunk)
end

function getRoutingInfo() -- returns all AUXRECV, HWOUT, VOLPAN and MAINSEND lines of all tracks (including master) with track GUIDs
  local RoutingInfo=""
  local tracknum=0
  local track=0
  local GUID=""
  local MainSends=""
  local TrackReceivesGUID=""
  local HardwareSends=""
  local MasterHardwareSends=""

  for tracknum=0,reaper.GetNumTracks()-1 do
    track=reaper.GetTrack(0,tracknum)
    GUID=reaper.GetTrackGUID(track)
    if RoutingInfo=="" then
      RoutingInfo=GUID
    else
      RoutingInfo=RoutingInfo.."\n"..GUID
    end
    MainSends=getMainSends(track)
    TrackReceivesGUID=GetTrackReceivesGUID(track)
    HardwareSends=getHardwareSends(track)
    if MainSends~="" then RoutingInfo=RoutingInfo.."\n"..MainSends end
    if HardwareSends~="" then RoutingInfo=RoutingInfo.."\n"..HardwareSends end
    if TrackReceivesGUID~="" then RoutingInfo=RoutingInfo.."\n"..TrackReceivesGUID end
  end

  track=reaper.GetMasterTrack(0)
  MasterHardwareSends=getHardwareSends(track)
  if RoutingInfo=="" and MasterHardwareSends~="" then RoutingInfo="{MASTER}\n"..MasterHardwareSends end
  if RoutingInfo~="" and MasterHardwareSends~="" then
    RoutingInfo=RoutingInfo.."\n{MASTER}\n"..MasterHardwareSends
  end
  return RoutingInfo
end

function setRoutingInfo(RoutingInfo) -- write all AUXRECV, HWOUT, VOLPAN and MAINSEND lines to all tracks (including master)
  if RoutingInfo==NIL then return false end
  RoutingInfo=RoutingInfo.."\n{end}" -- add fake GUID to the end, to write the last block
  local GUID=""
  local auxrecvGUID_list=""
  local MainSends=""
  local HardwareSends=""
  local line=""

  if string.find(RoutingInfo,"{MASTER}")==nil then -- if there is no entry for MASTER then clear all master HWOUT entries
    ClearHardwareSends(reaper.GetMasterTrack())
  end
  for line in RoutingInfo:gmatch("[^\r\n]+") do
    if string.sub(line,1,1)=="{" then
      if GUID~="" and GUIDToTrack(GUID)~=false then --write last GUID
        if auxrecvGUID_list~="" then
          SetTrackReceivesGUID(GUIDToTrack(GUID), auxrecvGUID_list)
        else
          ClearTrackReceives(GUIDToTrack(GUID))
        end
        if MainSends~="" then
          setMainSends(GUIDToTrack(GUID), MainSends)
        end
        if HardwareSends~="" then
          setHardwareSends(GUIDToTrack(GUID), HardwareSends)
        else
          ClearHardwareSends(GUIDToTrack(GUID))
        end
        MainSends=""
        auxrecvGUID_list=""
        HardwareSends=""
      end
      GUID=line
    else
      if line~="" then
        if string.sub(line,1,7)=="VOLPAN " or string.sub(line,1,9)=="MAINSEND " then
          if MainSends~="" then
            MainSends=MainSends.."\n"..line
          else
            MainSends=line
          end
        elseif string.sub(line,1,6)=="HWOUT " then
          if HardwareSends~="" then
            HardwareSends=HardwareSends.."\n"..line
          else
            HardwareSends=line
          end
        elseif string.sub(line,1,8)=="AUXRECV " then
          if auxrecvGUID_list~="" then
            auxrecvGUID_list=auxrecvGUID_list.."\n"..line
          else
            auxrecvGUID_list=line
          end
        end
      end
    end
  end
end

function GUIDToTrack(GUID) -- returns the track with matching GUID, or false.
  if GUID=="{MASTER}" then return reaper.GetMasterTrack() end
  local tracknum=0
  for tracknum=0, reaper.GetNumTracks(0)-1 do
    track=reaper.GetTrack(0,tracknum)
    if GUID==reaper.GetTrackGUID(track) then return track end
  end
  return false
end

function ClearTrackReceives(track) -- remove all AUXRECV enries inside <track> of given track
  local retval=0
  local new_TrackStateChunk=""
  local TrackStateChunk=""
  local insert=""
  local child=""
  local line=""

  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    insert=""
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,8)=="AUXRECV " and child =="TRACK" then
      -- do nothing (do not copy old AUXRECVs)
      else
      new_TrackStateChunk=new_TrackStateChunk.."\n"..line..insert
    end
  end
  return reaper.SetTrackStateChunk(track, new_TrackStateChunk)
end

function ClearHardwareSends(track) -- remove all HWOUT enries inside <track> of given track
  local TrackStateChunk=""
  local new_TrackStateChunk=""
  local insert=""
  local child=""

  retval, TrackStateChunk= reaper.GetTrackStateChunk(track, "")
  for line in TrackStateChunk:gmatch("[^\r\n]+") do
    insert=""
    if string.sub(line,1,1)=="<" then
      child =""
      if string.sub(line,1,6)=="<TRACK" then
        child ="TRACK"
      end
    end
    if string.sub(line,1,6)=="HWOUT " and child =="TRACK" then
      -- do nothing (do not copy old AUXRECVs)
      else
      new_TrackStateChunk=new_TrackStateChunk.."\n"..line..insert
    end
  end
  return reaper.SetTrackStateChunk(track, new_TrackStateChunk)
end
