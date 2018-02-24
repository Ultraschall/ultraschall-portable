--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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

-- Ultraschall State-Inspector 1.3 [Ultraschall-Developer Tools] 12.1.2018
--
-- This Inspector monitors toggle-command-states or external-states of your choice.
-- It's good for checking, if some toggling of states or changing of external-states
-- is working as expected.
--
-- H for further help
--
-- yes, it could be visually more appealing, so: accept the challenge and make it so ;)
--
-- Meo Mespotine

version="1.3"

gfx.init("Ultraschall State Inspector "..version, 900, 520)

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

font_height=gfx.measurechar(65)+3

counter=0
states={}
row1=30
row2=40
row3=0
stop=false

start_state=1

slotnumber="-"
slotname=""
altered=""
last_entry=0
gfx.setfont(1,"Arial", 12, 0)

function ShowStates()
  gfx.set(1,1,1)
  gfx.y=5 gfx.x=10
  gfx.drawstr("Monitors Toggle-Command-States and external-states.                  ")
  
  gfx.y=30 gfx.x=460
  gfx.drawstr("   H - Help\n\n   Up/Down/PgUp/PgDn/Pos1/End - scroll through list\n\n   Esc - closes inspector\n\n")
  gfx.y=30 gfx.x=10 gfx.set(1,0,0)
  gfx.drawstr("   T - add Toggle Command \n")gfx.x=10 gfx.y=gfx.y+gfx.texth   gfx.set(1,1,0) 
  gfx.drawstr("   E - add External State \n")gfx.x=10 gfx.y=gfx.y+gfx.texth   gfx.set(0.5,0.8,0.8)
  gfx.drawstr("   U - add US-External State \n")gfx.x=10 gfx.y=gfx.y+gfx.texth  gfx.set(0.0,0.5,1)
  gfx.drawstr("   A - add Any External State\n") gfx.x=10 gfx.y=gfx.y+gfx.texth  gfx.set(1,0.6,0)
  gfx.drawstr("   P - add Project External-State\n\n")  gfx.x=10 gfx.set(0,1,0)  
  gfx.drawstr("   R - add Reaper-State\n\n")  
  gfx.y=30 gfx.x=150 gfx.set(1,1,1) 
  gfx.drawstr("   B - Highlight Entry\n   V - Remove All Highlighting \n   M - Move entry\n   D - Delete entry\n   O - Order collection\n   C - Clear Collection \n\n")
--  D - Delete entry\n   C - Clear List
  gfx.y=30 gfx.x=280
  gfx.drawstr("   S - Save State-Collection\n   L - List of State-Collection Slots\n\n   1 to 9 - Load from State-Collection-Slot\n   0 - Show All Ultraschall-States\n\n")

  gfx.y=gfx.y+font_height*2

  gfx.x=10
  
  if slotname:match("\".-\"")==nil and slotname~="" then slotname="\""..slotname.."\"" end
  gfx.drawstr("Monitored States of collection-slot: "..slotnumber.." - "..slotname.." "..altered.." - contains "..counter.." states\n")
  gfx.y=gfx.y+font_height+5
  gfx.x=35
  if start_state>1 then gfx.set(0.7,0.7,0.7) gfx.drawstr("   /\\ more states\n\n") else gfx.drawstr(" \n\n") end
  liststart_y=gfx.y
  listheight=gfx.h-liststart_y-(font_height)
  list_num_lines=listheight/(font_height)-1
  list_num_lines=tostring(list_num_lines)
  if list_num_lines:match("%.")~=nil then list_num_lines=tonumber(list_num_lines:match("(.-)%.")) else list_num_lines=tonumber(list_num_lines) end
  
  temp_height=gfx.y-5
  gfx.x=row1 
--  gfx.y=temp_height+font_height
  for i=start_state, counter do
    gfx.x=row1
    temp_height=temp_height+font_height
    gfx.y=temp_height
    if temp_height+(font_height*3)>gfx.h and i<counter then last_entry=i gfx.y=gfx.y+font_height gfx.x=35 gfx.set(0.7,0.7,0.7) gfx.drawstr("   \\/ - more states") stop=false break else stop=true end
    gfx.set(0.3,0.7,1)
    if states[i][0]==true then gfx.x=row1-10 gfx.drawstr(">") gfx.x=row1 gfx.setfont(1,"Arial", 12, 86) end
    if states[i][1]=="toggle" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.x=row2
      gfx.set(1,0,0)
      gfx.drawstr(" | Toggle Command: ")
      gfx.drawstr(states[i][2].." ")
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.set(1,1,1)
      gfx.drawstr(reaper.GetToggleCommandState(reaper.NamedCommandLookup(states[i][2])).."\n")
    elseif states[i][1]=="extstate" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(1,1,0)
      gfx.x=row2
      gfx.drawstr(" | ExtState ["..states[i][2].."] -> "..states[i][3]..": ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetProjExtState(0,states[i][2],states[i][3]).."\n")
    elseif states[i][1]=="projextstate" then
--      B=reaper.SetProjExtState(0, "tudel", "loo", "test")
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(1,0.6,0)
      gfx.x=row2
      gfx.drawstr(" | Project-ExtState ["..states[i][2].."] -> "..states[i][3]..": ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      t, value=reaper.GetProjExtState(0, states[i][2], states[i][3])
      gfx.drawstr(value.."\n")
    elseif states[i][1]=="usextstate" then
      t, value=ultraschall.GetUSExternalState(states[i][2], states[i][3])
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0.5,0.8,0.8)
      gfx.x=row2
      gfx.drawstr(" | USExtState ["..states[i][2].."] -> "..states[i][3]..": ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(value.."\n")
    elseif states[i][1]=="anyextstate" then
      t, value=reaper.BR_Win32_GetPrivateProfileString(states[i][2], states[i][3], -1, states[i][4])
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,0.5,1)
      gfx.x=row2
      filename=states[i][4]:match(".*"..ultraschall.Separator.."(.*)$")
      if filename==nil then filename=states[i][4] end
      gfx.drawstr(" | AnyExtState "..filename.." ["..states[i][2].."] -> "..states[i][3]..": ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(value.."\n")

    elseif states[i][1]=="hzoom" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Horizontal Zoom Factor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetHZoomLevel().."\n")
    elseif states[i][1]=="playrate" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Playrate: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.Master_GetPlayRate(0).."\n")
    elseif states[i][1]=="playpos" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Playposition: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetPlayPosition().."\n")
    elseif states[i][1]=="editpos" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Editposition: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetCursorPosition().."\n")      
    elseif states[i][1]=="lastfocfx" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Last Focused FX: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      retval, tracknumber, itemnumber, fxnumber = reaper.GetFocusedFX()
      if retval==1 then retval="track fx window: focused" end
      if retval==2 then retval="item fx window: focused" end
      if retval==0 then retval="no fx window focused" end
      if tracknumber=="0" then tracknumber="Master" end
      gfx.drawstr(retval.." | track: "..tracknumber.." | item: "..itemnumber.." | fx#: "..fxnumber.."\n")
    elseif states[i][1]=="freediscprim" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Free Disk Space(primary recording path): ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetFreeDiskSpaceForRecordPath(0,0).."\n")      
    elseif states[i][1]=="freediscalt" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Free Disk Space(alternative recording path): ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      gfx.drawstr(reaper.GetFreeDiskSpaceForRecordPath(0,1).."\n")
    elseif states[i][1]=="globautmoverride" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Global Automation Override: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      integer=reaper.GetGlobalAutomationOverride()
      if integer=="-1" then integer="no override" end
      if integer=="0" then integer="trim/read" end
      if integer=="1" then integer="read" end
      if integer=="2" then integer="touch" end
      if integer=="3" then integer="write" end
      if integer=="4" then integer="latch" end
      if integer=="5" then integer="bypass" end
      gfx.drawstr(integer.."\n")
    elseif states[i][1]=="inoutlatency" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Input/Output Latency: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      inputlatency, outputLatency = reaper.GetInputOutputLatency()
      gfx.drawstr("Input-Latency: "..inputlatency.." | Output-Latency: "..outputLatency.."\n")
    elseif states[i][1]=="lastcolortheme" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Last Color Theme-File: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetLastColorThemeFile()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="lasttouchedtrack" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Last Touched-Track: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      track=reaper.GetLastTouchedTrack()
      gfx.drawstr(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER").."\n")
    elseif states[i][1]=="seltrackenv" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Selected Track Envelope: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      TrackEnvelope=reaper.GetSelectedEnvelope(0)
      tracknumber=-1
      name=""
      if TrackEnvelope~=nil then
        track=reaper.Envelope_GetParentTrack(TrackEnvelope)
        retval, name= reaper.GetEnvelopeName(TrackEnvelope,"")
        tracknumber=reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
      end
      gfx.drawstr("Track: "..tracknumber.." | Envelope Name: "..name.."\n")
    elseif states[i][1]=="projname" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Projectname: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetProjectName(0,"")
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="projname" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Projectname: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetProjectName(0,"")
      if name==nil then name="" end
      gfx.drawstr(name.."\n")      
    elseif states[i][1]=="projpath" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Projectpath: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetProjectPath("")
      if name==nil then name="" end
      gfx.drawstr(name.."\n")      
    elseif states[i][1]=="respath" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Reaper's Resource Path: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetResourcePath()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")      
    elseif states[i][1]=="apppath" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Reaper's Application Path: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetExePath()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="projlength" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Project Length in seconds: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetProjectLength(0)
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="projstatechange" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | ProjectStateChangeCount: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetProjectStateChangeCount(0)
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="audioisprebuffer" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Audio is in Prebuffer: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.Audio_IsPreBuffer()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="audioisrunning" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Audio is running: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.Audio_IsRunning()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="reapergetinifile" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Reaper-Ini-file with path: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.get_ini_file()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="appversion" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Reaper App Version: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetAppVersion()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="cursorcontext" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Mousecursor-Context: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetCursorContext()
      if name==nil then name=""
      elseif name==0 then name="track panels"
      elseif name==1 then name="items"
      elseif name==2 then name="envelopes"
      else name="unknown"
      end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="mastertrackvis" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Mastertrack visibility: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetMasterTrackVisibility()
      tcpshow=""
      mcpshow=""
      if name&1==1 then tcpshow="visible" else tcpshow="invisible" end
      if name&2==0 then mcpshow="visible" else mcpshow="invisible" end
      if name==nil then name="" end
      gfx.drawstr("MCP: "..mcpshow.." - TCP:"..tcpshow.."\n")                  
    elseif states[i][1]=="maxmidiinputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Max Midi Inputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetMaxMidiInputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="maxmidioutputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Max Midi Outputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetMaxMidiOutputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="getmixerscroll" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Leftmost Track in Mixer: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetMixerScroll()
      name=reaper.GetMediaTrackInfo_Value(name, "IP_TRACKNUMBER")
      if name==nil then name="" end
      gfx.drawstr(name.."\n")      
    elseif states[i][1]=="mouseposition" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Mouseposition: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      x,y=reaper.GetMousePosition()
      if name==nil then name="" end
      gfx.drawstr("X-Position: "..x.." - Y-Position: "..y.."\n")
    elseif states[i][1]=="numaudioinputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Num Audio Inputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetNumAudioInputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")      
    elseif states[i][1]=="numaudiooutputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Num Audio Outputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetNumAudioOutputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="nummidiinputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Num Midi Inputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetNumMIDIInputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="nummidioutputs" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Num Midi Outputs: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetNumMIDIOutputs()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="numtracks" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Number of Tracks: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetNumTracks()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")  
    elseif states[i][1]=="getos" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Operating System: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetOS()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")  
    elseif states[i][1]=="playstate" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Playstate: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.GetPlayState()
      state=""
      if name==0 then state="Stopped" end
      if name&1==1 then state="Play" end
      if name&4==4 then state="Rec" end
      if name&2==2 then state=state.." (Paused)" end
      if name==nil then name="" end
      gfx.drawstr(state.."\n")  
    elseif states[i][1]=="mastertempo" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Mastertempo: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.Master_GetTempo()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")  
    elseif states[i][1]=="timeprecise" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Reaper's Time Precise: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name=reaper.time_precise()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")  
    elseif states[i][1]=="mousecursorcontx" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Mouse Cursor Context: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      if name==nil then name="" end
      gfx.drawstr("Window: "..window.." - Segment: "..segment.." - Details: "..details.."\n")  
    elseif states[i][1]=="mousecursorenv" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Envelope at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      name=""
      tracknum=""
      fx_num=""
      param_num=""
      name=reaper.BR_GetMouseCursorContext_Envelope()
      if name~=nil then 
        MediaTrack, fx_num, param_num = reaper.Envelope_GetParentTrack(name)
        tracknum=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
        retval, name = reaper.GetEnvelopeName(name, "")
      end
      if name==nil then name="" end
      gfx.drawstr("EnvName: "..name.." - Tracknumber: "..tracknum.." - FX-idx: "..fx_num.." - Param-idx:"..param_num.."\n")
    elseif states[i][1]=="mousecursoritem" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Item at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      tracknum=""
      itemnr=""
      position=""
      MediaItem, position = reaper.BR_ItemAtMouseCursor()
      if MediaItem~=nil then
        MediaTrack=reaper.GetMediaItem_Track(MediaItem)
        tracknum=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
        itemnr=reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
      end
      if name==nil then name="" end
      gfx.drawstr("Track: "..tracknum.." - Item in Track: "..itemnr.." - Position: "..position.."\n")  
    elseif states[i][1]=="mousecursortake" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Take at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      tracknum=""
      itemnr=""
      takenr=""
      position=""
      MediaItem_Take, position = reaper.BR_TakeAtMouseCursor()
      if MediaItem_Take~=nil then
        MediaTrack=reaper.GetMediaItemTake_Track(MediaItem_Take)
        MediaItem=reaper.GetMediaItemTake_Item(MediaItem_Take)
        tracknum=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
        takenr=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "IP_TAKENUMBER")
        itemnr=reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
      end
      if name==nil then name="" end
      gfx.drawstr("Track: "..tracknum.." - Item in Track: "..itemnr.." - TakeNr: "..takenr.." - pos: "..position.."\n")  
    elseif states[i][1]=="mousecursortrack" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Track at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      tracknum=""
      MediaTrack, context, position = reaper.BR_TrackAtMouseCursor()
      if MediaTrack~=nil then
        tracknum=reaper.GetMediaTrackInfo_Value(MediaTrack, "IP_TRACKNUMBER")
      end
      if name==nil then name="" end
      gfx.drawstr("Track: "..tracknum.."\n")
    elseif states[i][1]=="mousecursorpos" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Position at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      name = reaper.BR_GetMouseCursorContext_Position()

      if name==nil then name="" end
      gfx.drawstr(name.."\n")
    elseif states[i][1]=="mousecursor_strmarker" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Timestretch-marker at Mousecursor: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      window, segment, details = reaper.BR_GetMouseCursorContext()
      name = reaper.BR_GetMouseCursorContext_StretchMarker()
      if name==nil then name="" end
      gfx.drawstr(name.."\n")  
    elseif states[i][1]=="clipboard" then
      gfx.drawstr(i)
      gfx.set(0.3,0.3,0.3)
      gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
      gfx.set(0,1,0)
      gfx.x=row2
      gfx.drawstr(" | Clipboard: ")
      gfx.set(1,1,1)
      if gfx.x>row3 then row3=gfx.x+50 end
      gfx.x=row3
      name = reaper.CF_GetClipboard("")
      if name==nil then name="" end
      name=string.gsub (name, "\n", "\\n")
      gfx.drawstr(name.."\n")    
    end
    gfx.x=10
    gfx.set(1,1,1)
    gfx.setfont(1,"Arial", 12, 0)
  end
  if stop~=false then last_entry=counter end
end

function AddToggleCommand()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New Toggle Command", 1, "ActionCommandID:", "")
  if retval==false then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="toggle"
  states[counter][2]=retvals_csv
  altered="(altered)"
end

function AddExternalState()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New ExternalState", 2, "Section:,Key:", "", "")
  if retval==false then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="extstate"
  states[counter][2]=retvals_csv:match("(.-),")
  states[counter][3]=retvals_csv:match(",(.*)")
  altered="(altered)"
end

function AddProjExternalState()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New Project ExternalState", 2, "Section:,Key:", "", "")
  if retval==false then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="projextstate"
  states[counter][2]=retvals_csv:match("(.-),")
  states[counter][3]=retvals_csv:match(",(.*)")
  altered="(altered)"
end

function AddUSExternalState()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New Ultraschall ExternalState", 2, "Section:,Key:", "", "")
  if retval==false then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="usextstate"
  states[counter][2]=retvals_csv:match("(.-),")
  states[counter][3]=retvals_csv:match(",(.*)")
  altered="(altered)"
end

function AddAnyExternalState()
  retval, retvals_csv = reaper.GetUserInputs("Any ExtState; $res$ for resourcefolder", 3, "Section:,Key:,Ini-Filename(empty for filedialog)", "", "")
  if retval==false then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="anyextstate"
  states[counter][2]=retvals_csv:match("(.-),")
  states[counter][3]=retvals_csv:match(",(.-),")
  temp=retvals_csv:match(".-,.-,(.*)")
  if temp=="" then retval, temp = reaper.GetUserFileNameForRead("", "Open Ini-File", "") end
  states[counter][4]=string.gsub (temp, "%$res%$", reaper.GetResourcePath())
  altered="(altered)"
end

function RemoveEntry()
  retval, retvals_csv = reaper.GetUserInputs("Which entry to remove?", 1, "Entrynumber", "")  
  if retval==false then return end
  if tonumber(retvals_csv)~=nil and counter>0 and tonumber(retvals_csv)<=counter then
    table.remove(states, tonumber(retvals_csv))
    counter=counter-1
  end
  altered="(altered)"
end

function ShowHelp()
  helpmessage=[[
This Inspector shows the current states of Toggle-Commands as well as External States. You can follow as many states as you want.

Use one of the command-letters to open a dialog, where you can enter the state, that you want to follow.

"T"    - adds a Toggle Command, that you want to follow. Give the 
           Action Command ID and it will show in the list. 
           The state of -1 shows, that this Action has no 
           ToggleCommand-State or doesn't exist.
"E","U" - show you external states/ultraschall-external states. 
              They will be loaded from reaper.extstate.ini or 
              ultraschall.ini respectively.
"A"   - will show an external state from any ini-file you desire. 
          You must enter the full path and filename to the ini-file 
          in the add-dialog. Use $res$ for the resource-folder of 
          Reaper or leave empty to open a open-file-dialog after 
          hitting OK.
"P"   - will show Project-external-states.
"R"   - will add Reaper's own states. Type "y" in the dialogboxes 
          of the states you want.

CursorUp, CursorDn, PgUp, PgDn, Pos1, End to scroll the list.

"D" - deletes an entry of your choice.
"B" - toggles highlighting on/off of an entry of your choice
"V" - removes all highlighting
"O" - orders your collection
"S" - saves a collection into one of the slots. After that, you can 
        use "1" to "9" to quick-reload the state-collection. 
"L" - shows you a list of your state-collections, you've saved. 
        Saved slots will be stored in Ultraschall-Inspector.ini in 
        the resources-folder of Reaper.
"M" - Move entry to other position

"0" (zero) - for a list of all Ultraschall-States

"H" - shows this Help-dialog

To end the inspector, hit Esc or just close the window.]]
  reaper.MB(helpmessage, "Ultraschall Inspector "..version.." - Help",0)
end

function SaveStateCollection()
  retval, retvals_csv = reaper.GetUserInputs("Save Your Collection", 2, "Collection-Slot-Nr(1-9),Title of Collection", "")
  if retval==false then return false end
  if tonumber(retvals_csv:match("(.-),"))==nil or tonumber(retvals_csv:match("(.-),"))<0 or tonumber(retvals_csv:match("(.-),"))>9 then reaper.MB("No valid slotnumber. Only 1 to 9 allowed!","Oops",0) return end
  slotnumber=tonumber(retvals_csv:match("(.-),"))
  slotname=retvals_csv:match(",(.*)")
  boolean=reaper.BR_Win32_WritePrivateProfileString("collection"..tonumber(retvals_csv:match("(.-),")), "Name", retvals_csv:match(",(.*)"), reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  boolean=reaper.BR_Win32_WritePrivateProfileString("collection"..tonumber(retvals_csv:match("(.-),")), "numentries", counter, reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  for i=1, counter do
    if states[i][1]=="toggle" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") 
      else reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "false", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") 
      end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    elseif states[i][1]=="extstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    elseif states[i][1]=="projextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    elseif states[i][1]=="usextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    elseif states[i][1]=="anyextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..4, states[i][4], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    else
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini") end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    end
  end
  altered=""
end

function ShowSlots()
  retval, slot1 = reaper.BR_Win32_GetPrivateProfileString("collection1", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot2 = reaper.BR_Win32_GetPrivateProfileString("collection2", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot3 = reaper.BR_Win32_GetPrivateProfileString("collection3", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot4 = reaper.BR_Win32_GetPrivateProfileString("collection4", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot5 = reaper.BR_Win32_GetPrivateProfileString("collection5", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot6 = reaper.BR_Win32_GetPrivateProfileString("collection6", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot7 = reaper.BR_Win32_GetPrivateProfileString("collection7", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot8 = reaper.BR_Win32_GetPrivateProfileString("collection8", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  retval, slot9 = reaper.BR_Win32_GetPrivateProfileString("collection9", "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  reaper.MB("Your state-collection slots:\n\n 1 - "..slot1.."\n 2 - "..slot2.."\n 3 - "..slot3.."\n 4 - "..slot4.."\n 5 - "..slot5.."\n 6 - "..slot6.."\n 7 - "..slot7.."\n 8 - "..slot8.."\n 9 - "..slot9,"State-Collection Slots",0)
end

function LoadSlot(slot, quest)
  local B
  if altered=="(altered)" then
    B=reaper.MB("Do you want to save the current collection?","Save Collection?", 3)
    --reaper.MB(B,"",0)
  end
  if B==6 then SaveStateCollection() end
  if B==2 then return end
  retval, count = reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "numentries", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  if count=="" then reaper.MB("This slot contains no collection yet.", "Oops", 0) return end
  slotnumber=slot
  retval, slotname = reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "Name", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
  counter=tonumber(count)
  states={}
  for i=1, counter do
    states[i]={}
    retval, temp=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_0", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    if temp=="true" then states[i][0]=true else states[i][0]=false end
    retval, states[i][1]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_1", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    retval, states[i][2]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_2", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    if states[i][1]=="extstate" or states[i][1]=="usextstate" or states[i][1]=="projextstate" then
      retval, states[i][3]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_3", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    end
    if states[i][1]=="anyextstate" then
      retval, states[i][3]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_3", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
      retval, states[i][4]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_4", "", reaper.GetResourcePath().."\\Ultraschall-Inspector.ini")
    end
  
  end
  altered=""
  last_entry=0
  start_state=1
end

function ClearList(state)
  local B, C
  if state==true and altered=="(altered)"  then
    B=reaper.MB("Do you want to save the current collection before clearing it?","Save Collection?", 3)
  end
  if B==6 then C=SaveStateCollection() end
  if C==false then return end
  if B==2 then return end
  states={}
  counter=0
  slotnumber="-"
  slotname=""
  altered=""
  row3=0
  last_entry=0
  start_state=1
end

function OrderEntries()
  temptable={}
  count=1
  for i=1, counter do
    if states[i][1]=="toggle" then temptable[count]=states[i] count=count+1 end
  end
  for i=1, counter do
    if states[i][1]=="extstate" then temptable[count]=states[i] count=count+1 end
  end  
  for i=1, counter do
    if states[i][1]=="usextstate" then temptable[count]=states[i] count=count+1 end
  end
  for i=1, counter do
    if states[i][1]=="anyextstate" then temptable[count]=states[i] count=count+1 end
  end
  for i=1, counter do
    if states[i][1]=="projextstate" then temptable[count]=states[i] count=count+1 end
  end
  for i=1, counter do
    if states[i][1]~="anyextstate" and states[i][1]~="projextstate" and states[i][1]~="usextstate" and states[i][1]~="extstate" and states[i][1]~="toggle" then temptable[count]=states[i] count=count+1 end
  end
  states=temptable
  altered="(altered)"
end

function ToggleBigger()
  D, D2 =reaper.GetUserInputs("Toggle Which State-Entry Bold/Unbold?", 1, "StateEntry #:", "")
  if tonumber(D2)==nil or tonumber(D2)<1 or tonumber(D2)>counter then reaper.MB("No such state-entry...", "Ooopps...", 0) return end
  if states[tonumber(D2)][0]~=true then states[tonumber(D2)][0]=true else states[tonumber(D2)][0]=false end
end

function AddReaperStates()
  D1, D2 =reaper.GetUserInputs("Which Reaper-States? \"Y\" to show.", 16, "HZoom:,LastFocusedFX::,Playposition:,Editposition:,Playrate:,FreeDiskSpace prim:,FreeDiskSpace alt:,GlobalAutomationOverride:,InputOutputLatency:,Last Color-Theme:,Last Touched Track:,Selected Tack Envelope:,ProjectName:,Projectpath:,Reaper Resourcepath:,Reaper's App Path:", "")
  D3, D4 =reaper.GetUserInputs("Which Reaper-States? \"Y\" to show.", 16, "ProjectLength:,ProjectStateChangeCount:,AudioPreBuffer:,Audio is runnning:,Reaper.ini-filename:,Appversion:,CursorContext:,MasterTrackVisibility:,MaxMidiInput:,MaxMidiOutput:,Left-visible track in Mixer:,MousePosition:,NumAudioInputs:,NumAudioOutputs:,NumMidiInput:,NumMidiOutput:", "")
  D5, D6 =reaper.GetUserInputs("Which Reaper-States? \"Y\" to show.", 13, "NumTracks:,GetOS:,PlayState:,Master_Tempo:,Time_Precise:,Mouse_Cursor_Context:,Envelope at Mousecursor:,Item at Mousecursor:,ItemTake at Mousecursor:,Track at Mousecursor:,Position at Mousecursor:,Stretchmarker at Mouse:,Clipboard:", "")

  if D1==false and D3==false then return end
  hzoom           =D2:match("(.-),")
  lastfocfx       =D2:match(",(.-),")
  playpos         =D2:match(",.-,(.-),")
  editpos         =D2:match(",.-,.-,(.-),")
  playrate        =D2:match(",.-,.-,.-,(.-),")
  freediscprim    =D2:match(",.-,.-,.-,.-,(.-),")
  freediscalt     =D2:match(",.-,.-,.-,.-,.-,(.-),")
  globautmoverride=D2:match(",.-,.-,.-,.-,.-,.-,(.-),")
  inoutlatency    =D2:match(",.-,.-,.-,.-,.-,.-,.-,(.-),")
  lastcolortheme  =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  lasttouchedtrack=D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  seltrackenv     =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  projname        =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  projpath        =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  respath         =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  apppath         =D2:match(",.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.*)")

  projlength      =D4:match("(.-),")
  projstatechange =D4:match(".-,(.-),")
  audioisprebuffer=D4:match(".-,.-,(.-),")     
  audioisrunning  =D4:match(".-,.-,.-,(.-),")     
  reapergetinifile=D4:match(".-,.-,.-,.-,(.-),")     
  appversion      =D4:match(".-,.-,.-,.-,.-,(.-),")
  cursorcontext   =D4:match(".-,.-,.-,.-,.-,.-,(.-),")     
  mastertrackvis  =D4:match(".-,.-,.-,.-,.-,.-,.-,(.-),")
  maxmidiinputs   =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  maxmidioutputs  =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  getmixerscroll  =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  mouseposition   =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  numaudioinputs  =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  numaudiooutputs =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  nummidiinputs   =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  nummidioutputs  =D4:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.*)")

  numtracks       =D6:match("(.-),")
  getos           =D6:match(".-,(.-),")
  playstate       =D6:match(".-,.-,(.-),")     
  mastertempo     =D6:match(".-,.-,.-,(.-),")
  timeprecise     =D6:match(".-,.-,.-,.-,(.-),")     
  mousecursorcontx=D6:match(".-,.-,.-,.-,.-,(.-),")
  mousecursorenv  =D6:match(".-,.-,.-,.-,.-,.-,(.-),")     
  mousecursoritem =D6:match(".-,.-,.-,.-,.-,.-,.-,(.-),")
  mousecursortake =D6:match(".-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  mousecursortrack=D6:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  mousecursorpos  =D6:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  mousecursor_strmarker   =D6:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
  clipboard       =D6:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,.-,(.*)")
  
  
  if hzoom:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="hzoom"  altered="(altered)" end
  if lastfocfx:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="lastfocfx"  altered="(altered)" end
  if playpos:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="playpos"  altered="(altered)" end
  if editpos:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="editpos"  altered="(altered)" end
  if playrate:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="playrate"  altered="(altered)" end
  if freediscprim:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="freediscprim"  altered="(altered)" end
  if freediscalt:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="freediscalt"  altered="(altered)" end
  if globautmoverride:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="globautmoverride"  altered="(altered)" end
  if inoutlatency:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="inoutlatency"  altered="(altered)" end
  if lastcolortheme:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="lastcolortheme"  altered="(altered)" end
  if lasttouchedtrack:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="lasttouchedtrack"  altered="(altered)" end
  if seltrackenv:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="seltrackenv"   altered="(altered)" end
  if projname:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="projname"   altered="(altered)" end
  if projpath:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="projpath"  altered="(altered)" end
  if respath:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="respath"  altered="(altered)" end
  if apppath:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="apppath"  altered="(altered)" end
  
  if projlength:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="projlength"  altered="(altered)" end
  if projstatechange:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="projstatechange"  altered="(altered)" end
  if audioisprebuffer:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="audioisprebuffer"  altered="(altered)" end
  if audioisrunning:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="audioisrunning"  altered="(altered)" end
  if reapergetinifile:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="reapergetinifile"  altered="(altered)" end
  if appversion:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="appversion"  altered="(altered)" end
  if cursorcontext:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="cursorcontext"  altered="(altered)" end
  if mastertrackvis:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mastertrackvis"  altered="(altered)" end
  if maxmidiinputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="maxmidiinputs"  altered="(altered)" end
  if maxmidioutputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="maxmidioutputs"  altered="(altered)" end
  if getmixerscroll:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="getmixerscroll"  altered="(altered)" end
  if mouseposition:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mouseposition"  altered="(altered)" end
  if numaudioinputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="numaudioinputs"  altered="(altered)" end
  if numaudiooutputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="numaudiooutputs"  altered="(altered)" end
  if nummidiinputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="nummidiinputs"  altered="(altered)" end
  if nummidioutputs:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="nummidioutputs"  altered="(altered)" end


  if numtracks:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="numtracks" altered="(altered)" end
  if getos:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="getos" altered="(altered)" end
  if playstate:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="playstate"  altered="(altered)" end
  if mastertempo:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mastertempo"  altered="(altered)" end
  if timeprecise:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="timeprecise"  altered="(altered)" end
  if mousecursorcontx:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursorcontx"  altered="(altered)" end
  if mousecursorenv:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursorenv"  altered="(altered)" end
  if mousecursoritem:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursoritem"  altered="(altered)" end
  if mousecursortake:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursortake"  altered="(altered)" end
  if mousecursortrack:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursortrack"  altered="(altered)" end
  if mousecursorpos:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursorpos"  altered="(altered)" end
  if mousecursor_strmarker:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="mousecursor_strmarker"  altered="(altered)" end
  if clipboard:lower()=="y" then counter=counter+1 states[counter]={} states[counter][1]="clipboard"  altered="(altered)" end

--[[
reaper.Audio_IsPreBuffer()
reaper.Audio_IsRunning()
string reaper.get_ini_file()
reaper.GetAppVersion()
reaper.GetCursorContext()
reaper.GetMasterTrackVisibility()
reaper.GetMaxMidiInputs()
reaper.GetMaxMidiOutputs()
reaper.GetMixerScroll()
reaper.GetMousePosition()
reaper.GetNumAudioInputs()
reaper.GetNumAudioOutputs()
integer reaper.GetNumMIDIInputs()
integer reaper.GetNumMIDIOutputs()



integer reaper.GetNumTracks()
string reaper.GetOS()
integer reaper.GetPlayState()
number reaper.Master_GetTempo()
number reaper.time_precise()
reaper.BR_GetMouseCursorContext()
reaper.BR_GetMouseCursorContext_Envelope()
MediaItem retval, number position = reaper.BR_ItemAtMouseCursor()
MediaItem_Take retval, number position = reaper.BR_TakeAtMouseCursor()
MediaTrack retval, number context, number position = reaper.BR_TrackAtMouseCursor()
number reaper.BR_GetMouseCursorContext_Position()
integer reaper.BR_GetMouseCursorContext_StretchMarker()

--]]

end

function ClearHighlighting(number)
  if tonumber(number)==nil then
    for i=1, counter do
      states[i][0]=false
    end
  else
    if states[tonumber(states)][0]~=nil then states[tonumber(number)][0]=false end
  end
end

function MoveEntry()
  temp,E=reaper.GetUserInputs("Move Entry", 2, "Which Entry (number):,Move To Entry (number):,","")
  if temp==false then return end
  a=E:match("(.-),")
  b=E:match(",(.*)")
  if tonumber(a)==nil or tonumber(b)==nil then reaper.MB("Only numbers allowed.","Ooops",0) return end
  if tonumber(a)<1 or tonumber(a)>counter then reaper.MB("No such entry to move.","Ooops",0) return end
  if tonumber(b)<1 or tonumber(b)>counter then reaper.MB("No such entry to move to.","Ooops",0) return end
  c=states[tonumber(a)]
  table.remove(states, tonumber(a))
  table.insert(states, tonumber(b), c)
end

function main()
  gfx.update()
  A=gfx.getchar()
  if gfx.getchar()~=-1 then
    if A==116.0 then AddToggleCommand() end
    if A==101.0 then AddExternalState() end
    if A==117.0 then AddUSExternalState() end
    if A==97.0 then AddAnyExternalState() end
    if A==112 then AddProjExternalState() end
    if A==109 then MoveEntry() end
    if A==100.0 then RemoveEntry() end
    if A==115.0 then SaveStateCollection() end
    if A==108.0 then ShowSlots() end
    if A==104.0 then ShowHelp() end
    if A==99.0 then ClearList(true) end
    if A==67.0 then ClearList(false) end
    if A==49 then LoadSlot(1) end
    if A==33 then LoadSlot(1, false) end
    if A==50 then LoadSlot(2) end
    if A==34 then LoadSlot(2, false) end
    if A==51 then LoadSlot(3) end
    if A==167 then LoadSlot(3, false) end
    if A==52 then LoadSlot(4) end
    if A==36 then LoadSlot(4, false) end
    if A==53 then LoadSlot(5) end
    if A==37 then LoadSlot(5, false) end
    if A==54 then LoadSlot(6) end
    if A==38 then LoadSlot(6, false) end
    if A==55 then LoadSlot(7) end
    if A==47 then LoadSlot(7, false) end
    if A==56 then LoadSlot(8) end
    if A==40 then LoadSlot(8, false) end
    if A==48 then LoadSlot(0) end
    if A==61 then LoadSlot(0, false) end
    if A==57 then LoadSlot(9) end
    if A==41 then LoadSlot(9, false) end
    if A==111 then OrderEntries() end
    if A==114 then AddReaperStates() end
    if A==118 then ClearHighlighting() end
    if A==30064 and counter>0 then start_state=start_state-1 if start_state<1 then start_state=1 end end
    if A==1685026670 and counter>0 and stop==false then start_state=start_state+1 if start_state>counter then start_state=counter end end
    if A==98 then ToggleBigger() end
    if A==27 then gfx.quit() end
    if A==1885824110 and last_entry~=counter then start_state=start_state+list_num_lines if start_state+list_num_lines-1>counter then start_state=counter-list_num_lines end end

    if A==1885828464 then start_state=start_state-(last_entry-start_state) if start_state<1 then start_state=1 end end-- start_state=(last_entry-start_state)-start_state if start_state<1 then start_state=1 end end
    if A==6647396 and last_entry~=counter then start_state=counter-(last_entry-start_state) if start_state<1 then start_state=1 end end
    if A==1752132965 then start_state=1 end    
    ShowStates()
    gfx.update()
    reaper.defer(main)
  elseif altered=="(altered)" then
    local B
    if quest~=false then
      B=reaper.MB("Do you want to save the current collection?","Inspector: Save Collection?", 3)
      Lt=gfx.getchar()
      if B==2 and Lt==-1 then gfx.init("Ultraschall State Inspector", 900, 520) reaper.defer(main) end
    end
    if B==6 then SaveStateCollection() end
  end
end

LoadSlot(0, false)
main()
