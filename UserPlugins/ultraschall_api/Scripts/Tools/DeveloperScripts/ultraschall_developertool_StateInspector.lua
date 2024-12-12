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

-- Ultraschall State-Inspector 2.3.1 [Ultraschall-Developer Tools] 1.05.2021
--
-- This Inspector monitors toggle-command-states or external-states of your choice.
-- It's good for checking, if some toggling of states or changing of external-states
-- is working as expected.
--
-- H for further help
--
-- yes, it could be visually more appealing, so: accept the challenge and make it so ;)
--
-- Meo-Ada Mespotine

Aa,Ab,Ac,Ad,Ae=reaper.get_action_context()
Path=Ab:match("(.*\\)")
if Path==nil then Path=Ab:match("(.*/)") end

version="2.3.1 - 1. 5. 2021"

gfx.init("Ultraschall State Inspector "..version, 560, 520)

-- load configvars
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

if reaper.file_exists(Path.."/Ultraschall_StateInspector/Ultraschall-Inspector.ini")==false then
  os.rename(Path.."/Ultraschall_StateInspector/Ultraschall-Inspector.inidef", Path.."/Ultraschall_StateInspector/Ultraschall-Inspector.ini")
end

A=ultraschall.ReadFullFile(ultraschall.Api_Path.."/DocsSourceFiles/Reaper_Config_Variables.USDocML")
found_usdocblocs, all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(A)
table.remove(all_found_usdocblocs, 1)

ConfigVars={}
for i=1, found_usdocblocs-1 do
  local vartype
  local slug = ultraschall.Docs_GetUSDocBloc_Slug(all_found_usdocblocs[i])
  local description = ultraschall.Docs_GetUSDocBloc_Description(all_found_usdocblocs[i], false, 1)
  if description:match("is an integer") then vartype="integer"
  elseif description:match("is a double float") then vartype="float"
  elseif description:match("is a string") then vartype="string"
  end
  ConfigVars[slug]=vartype
end

function StateChunkLayouter(sc)
  local num_tabs=0
  local newsc=""
  for k in string.gmatch(sc, "(.-\n)") do
    if k:sub(1,1)==">" then num_tabs=num_tabs-1 end
    for i=0, num_tabs-1 do
      newsc=newsc.."  "
    end
    if k:sub(1,1)=="<" then num_tabs=num_tabs+1 end
    newsc=newsc..k
  end
  return newsc
end

--A,B=reaper.GetTrackStateChunk(reaper.GetTrack(0,1),"",false)
--C=StateChunkLayouter(B)
--reaper.MB(C,"",0)
--reaper.CF_SetClipboard(C)

--if l==nil then return end



KeyCodeIni_File=Path.."/Ultraschall_StateInspector/Ultraschall_Inspector_Gfx_GetKey_Codes.ini"
InspectorIni_File=Path.."/Ultraschall_StateInspector/Ultraschall-Inspector.ini"

timer=0
refresh=3
timerrefresh=reaper.time_precise()+refresh
sidestep=1

function ultraschall.ReadFullFile(filename_with_path, binary)
  -- Returns the whole file filename_with_path or nil in case of error

  if filename_with_path == nil then return nil end
  if value==nil then value="" end
  if reaper.file_exists(filename_with_path)==false then return nil end
  if binary==true then binary="b" else binary="" end
  local file=io.open(filename_with_path,"r"..binary)
  filecontent=file:read("a")
  file:close()
  return filecontent, filecontent:len()
end 



if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    -- user_folder = buf --"C:\\Users\\[username]" -- need to be test
    ultraschall.Separator = "\\"
else
    -- user_folder = "/USERS/[username]" -- Mac OS. Not tested on Linux.
    ultraschall.Separator = "/"
end

function runcommand(cmd)     -- run a command by its name
  start_id = reaper.NamedCommandLookup(cmd)
  reaper.Main_OnCommand(start_id,0) 

end

function ultraschall.SetUSExternalState(section, key, value)
-- stores value into ultraschall.ini
-- returns true if sucessful, false if unsucessful

  if section:match(".*(%=).*")=="=" then return false end
  return reaper.BR_Win32_WritePrivateProfileString(section, key, value, reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")
end

function ultraschall.GetUSExternalState(section, key)
-- gets a value from ultraschall.ini
-- returns length of entry(integer) and the entry itself(string)

  return reaper.BR_Win32_GetPrivateProfileString(section, key, -1, reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")
end  

function ultraschall.GetStringFromClipboard_SWS()
  -- returns contents of clipboard
  return reaper.CF_GetClipboard(buf)
end

font_height=gfx.measurechar(65)+3
clicked=false
retval = gfx.loadimg(1,Path.."Ultraschall_StateInspector/us.png")
counter=0
states={}
row1=30
row2=55
row3=348
stop=false
shortcuts="on"
start_state=1
start_state2=1

slotnumber="-"
slotname=""
altered=""
last_entry=0
FileMenu=0
AddStatesMenu=0
EditListMenu=0
ViewMenu=1
HelpMenu=0
Mousewheel=0
MousewheelH=0
gfx.setfont(1,"Arial", 12, 0)
yoffset=0
xoffset=0
maxwidth=8
horizontalspeed=20
function Inverse_Rectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse)
  if inverse==true then gfx.set(r2,g2,b2) else gfx.set(r1,g1,b1) end
  gfx.line(x,y,x+w,y)
  gfx.line(x,y,x,y+h)
  if inverse==true then gfx.set(r1,g1,b1) else gfx.set(r2,g2,b2) end
  gfx.line(x+w,y,x+w,y+h)
  gfx.line(x,y+h,x+w,y+h)
end

function GetLine(ypos)
  position=ypos-(yoffset+8)
  line=position/font_height
  line=line+math.floor(start_state)
  line=tostring(line)
  if line:match("%.")~=nil then line=line:match("(.-)%.") end
  return tonumber(line)
end

function CreateReaperMenu(offset)
  if tonumber(offset)==nil then offset=0 end
  menu={}
  i=1 a=0+offset
  menu[i]=">View Management"
  i=i+1 a=a+1
  menu[i]="Horizontal Zoom Factor, hzoom,"..a
  i=i+1 a=a+1
  menu[i]="Cursor Context, cursorcontext,"..a
  i=i+1 a=a+1
  menu[i]="Leftmost Track in Mixer, getmixerscroll,"..a
  i=i+1 a=a+1
  menu[i]="Shown Timerange in Arrangeview, arrangeviewtime,"..a
  i=i+1
  menu[i]="<"
  
  i=i+1
  menu[i]=">Transport Management"
  i=i+1 a=a+1
  menu[i]="PlayPosition, playpos,"..a
  i=i+1 a=a+1
  menu[i]="Edit Cursor Position, editpos,"..a
  i=i+1 a=a+1
  menu[i]="Playrate, playrate,"..a
  i=i+1 a=a+1
  menu[i]="Playstate, playstate,"..a
  i=i+1 a=a+1
  menu[i]="Master tempo, mastertemp,"..a
  i=i+1 a=a+1
  menu[i]="Time/Loop-Selection, timesel,"..a
  
  i=i+1
  menu[i]="<"
  i=i+1
  menu[i]=">Mouse Management"
  i=i+1 a=a+1
  menu[i]="Mouseposition, mouseposition,"..a
  i=i+1 a=a+1
  menu[i]="Mousecursor Context, mousecursorcontx,"..a
  i=i+1 a=a+1
  menu[i]="Envelope at Mousecursor, mousecursorenv,"..a
  i=i+1 a=a+1
  menu[i]="Item at Mousecursor, mousecursoritem,"..a
  i=i+1 a=a+1
  menu[i]="Take at Mousecursor, mousecursortake,"..a
  i=i+1 a=a+1
  menu[i]="Track at Mousecursor, mousecursortrack,"..a
  i=i+1 a=a+1
  menu[i]="Position at Mousecursor, mousecursorpos,"..a
  i=i+1 a=a+1
  menu[i]="Stretchmarker at Mousecursor, mousecursor_strmarker,"..a
  i=i+1
  menu[i]="<"
  i=i+1
  menu[i]=">FX Management"
  i=i+1 a=a+1
  menu[i]="Last Focused FX, lastfocfx,"..a
  i=i+1
  menu[i]="<"
 
  i=i+1
  menu[i]=">Marker Management"
  i=i+1 a=a+1
  menu[i]="Number of Marker and Regions, numallmarker,"..a
  i=i+1 a=a+1
  menu[i]="Number of Marker, nummarker,"..a
  i=i+1 a=a+1
  menu[i]="Number of Regions, numregions,"..a
  i=i+1 a=a+1
  menu[i]="Number of Timesignature-Marker, numtimesigmarker,"..a
  i=i+1
  menu[i]="<"
 
 
       
  i=i+1
  menu[i]=">Track Management"
  i=i+1 a=a+1
  menu[i]="Last Touched Track, lasttouchedtrack,"..a
  i=i+1 a=a+1
  menu[i]="Selected Track Envelope, seltrackenv,"..a
  i=i+1 a=a+1
  menu[i]="Mastertrack Visibility, mastertrackvis,"..a
  i=i+1 a=a+1
  menu[i]="Number of Tracks, numtracks,"..a
  i=i+1
  menu[i]="<"
  i=i+1
  menu[i]=">Envelope Management"
  i=i+1 a=a+1
  menu[i]="Global Automation Override, globautmoverride,"..a
  i=i+1
  menu[i]="<"
  i=i+1
  menu[i]=">Project Management"
  i=i+1 a=a+1
  menu[i]="Projectlength, projlength,"..a
  i=i+1 a=a+1
  menu[i]="Project Statechange, projstatechange,"..a
  i=i+1 a=a+1
  menu[i]="Projectname, projname,"..a
  i=i+1 a=a+1
  menu[i]="Projectpath, projpath,"..a
  i=i+1 a=a+1
  menu[i]="Count of Mediaitems, countmediaitems,"..a
  i=i+1
  menu[i]="<"
  
  i=i+1
  menu[i]=">Reaper Management"
  i=i+1 a=a+1
  menu[i]="Free Discspace Primary, freediscprim,"..a
  i=i+1 a=a+1
  menu[i]="Free Discspace Secondary, freediscalt,"..a
  i=i+1 a=a+1
  menu[i]="Last Color Theme, lastcolortheme,"..a
  i=i+1 a=a+1
  menu[i]="Resourcepath, respath,"..a
  i=i+1 a=a+1
  menu[i]="Reaper's Apppath, apppath,"..a
  i=i+1 a=a+1
  menu[i]="Reaper's Ini-file+path, reapergetinifile,"..a
  i=i+1 a=a+1
  menu[i]="Reaper's Appversion, appversion,"..a
  i=i+1 a=a+1
  menu[i]="Operating System, getos,"..a
  i=i+1
  menu[i]="<"
  
  i=i+1
  menu[i]=">Hardware Management"
  i=i+1 a=a+1
  menu[i]="Input/Output Latency, inoutlatency,"..a
  i=i+1 a=a+1
  menu[i]="Audio is Prebuffer, audioisprebuffer,"..a
  i=i+1 a=a+1
  menu[i]="Audio is Running, audioisrunning,"..a
  i=i+1 a=a+1
  menu[i]="Max Midi Inputs, maxmidiinputs,"..a
  i=i+1 a=a+1
  menu[i]="Max Midi Outputs, maxmidioutputs,"..a
  i=i+1 a=a+1
  menu[i]="Num Audio Inputs, numaudioinputs,"..a
  i=i+1 a=a+1
  menu[i]="Num Audio Outputs, numaudiooutputs,"..a
  i=i+1 a=a+1
  menu[i]="Num Midi Inputs, nummidiinputs,"..a
  i=i+1 a=a+1
  menu[i]="Num Midi Outputs, nummidioutputs,"..a
  i=i+1
  menu[i]="<"
    
  i=i+1
  menu[i]=">Miscellaneous"
  i=i+1 a=a+1
  menu[i]="Time Precise, timeprecise,"..a
  i=i+1 a=a+1
  menu[i]="Stringcontent of Clipboard, clipboard,"..a
  i=i+1 a=a+1
  menu[i]="Current Time, time,"..a
  i=i+1 a=a+1
  menu[i]="Get Current Character, getchar,"..a
  i=i+1 a=a+1
  menu[i]="Get Current Character and put charcode to clipboard, getchar_clip,"..a
  i=i+1
  menu[i]="<"
  return menu
end



function ReturnReaperMenuEntry(number, ReaperMenu)
  k=1
  returnvalue=""
  while ReaperMenu[k]~=nil do
    L=ReaperMenu[k]:match(".*,(.*)")
    if tonumber(L)==number then returnvalue=ReaperMenu[k]:match(",.(.-),") end
    k=k+1
  end
  return returnvalue
end

--B=ReturnReaperMenuEntry(44, ReaperMenu)

function ReturnReaperMenuString(ReaperMenu)
  k=1
  returnvalue=""
  while ReaperMenu[k]~=nil do
    L=ReaperMenu[k]:match(".*,(.*)")
    if ReaperMenu[k]:match("(.-),")~=nil then
      returnvalue=returnvalue..ReaperMenu[k]:match("(.-),")
    else
      returnvalue=returnvalue..ReaperMenu[k]
    end
    returnvalue=returnvalue.."|"
    k=k+1
  end
  return returnvalue
end

ReaperMenu=CreateReaperMenu(6)
ReaperMenuString=ReturnReaperMenuString(ReaperMenu)

function DrawMenu()
  gfx.x=9 gfx.y=4
  gfx.set(0.8,0.8,0.8)
  gfx.rect(0,0,gfx.w,20)
  gfx.set(0.3,0.3,0.3)
  gfx.drawstr("File     Add States     Edit List             View      Developer Tools")
  gfx.x=gfx.w-40
  gfx.drawstr("Help")
end


function ShowStates()
  gfx.y=5 gfx.x=10
  gfx.set(1,1,1)
  gfx.x=10 gfx.y=30
  gfx.blit(1,0.50,0)
  gfx.x=107 gfx.y=82
  gfx.setfont(1,"arial", 14, 98)
  gfx.drawstr(".fm -  State-Inspector v"..version)
  gfx.y=110 gfx.x=10--gfx.w-300
  gfx.setfont(1,"arial", 12, 0)
  gfx.drawstr("   Up/Down/PgUp/PgDn/Pos1/End - scroll through list\n   Esc - closes inspector\n\n")
  gfx.set(0.4,0.4,0.4)
  gfx.line(10,27,gfx.w-30,27)
  gfx.line(10,105,gfx.w-30,105)
  gfx.line(10,138,gfx.w-30,138)
  gfx.set(1,1,1)
  
  if counter==0 then 
      tempx=gfx.x
      tempy=gfx.y
      gfx.x=100
      gfx.y=200
      gfx.set(1,1,0)
      gfx.drawstr("Start adding the states you want to monitor, from the Add States-Menu.\n\nFile-menu for loading and saving state-lists.\n\nEdit List-menu is for altering a state-list\n\nView Help for more info.")
      gfx.set(1,1,1)
      gfx.x=tempx
      gfx.y=tempy
  end


  gfx.y=gfx.y+font_height*2

  gfx.x=10
  
  if slotname:match("\".-\"")==nil and slotname~="" then slotname="\""..slotname.."\"" end
  gfx.setfont(1,"arial", 12, 117)
  gfx.drawstr("Monitored States of Statelist-slot: "..slotnumber.." - "..slotname.." "..altered.." - contains "..counter.." states\n")
  gfx.setfont(1,"arial", 12, 0)
  gfx.y=gfx.y+font_height
  gfx.x=35
  if math.floor(start_state)>1 then gfx.set(0.7,0.7,0.7) gfx.drawstr("   /\\ more states\n\n") else gfx.drawstr(" \n\n") end
  liststart_y=gfx.y
  listheight=gfx.h-liststart_y-(font_height)
  list_num_lines=listheight/(font_height)-1
  list_num_lines=tostring(list_num_lines)
  if list_num_lines:match("%.")~=nil then list_num_lines=tonumber(list_num_lines:match("(.-)%.")) else list_num_lines=tonumber(list_num_lines) end
  
  temp_height=gfx.y-5
  gfx.x=row1 
  yoffset=gfx.y
  xoffset=row1
--  if reaper.time_precise()>timerrefresh then
    for i=math.floor(start_state), counter do
      gfx.x=row1
      temp_height=temp_height+font_height
      gfx.y=temp_height
      if temp_height+(font_height*3)>gfx.h and gfx.h>yoffset+font_height and i<counter then last_entry=i gfx.y=gfx.h-font_height-3 --[[gfx.y+font_height --]] gfx.x=35 gfx.set(0.7,0.7,0.7) gfx.drawstr("   \\/ - more states") stop=false break else stop=true end
      gfx.set(0.3,0.7,1)
      if states[i][0]==true then gfx.x=row1-10 gfx.drawstr(">") gfx.x=row1 gfx.setfont(1,"Arial", 12, 86) end
      if states[i][1]=="toggle" then
        if states[i][3]=="0" then
          actionname = reaper.CF_GetCommandText(0, reaper.NamedCommandLookup(states[i][2]))
        else
          actionname = reaper.CF_GetCommandText(1, reaper.NamedCommandLookup(states[i][2]))
        end
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.x=row2
        gfx.set(1,0,0)
        gfx.drawstr(" | Toggle: ")
        gfx.drawstr(states[i][2].." "..actionname)
        if states[i][3]==32060 then gfx.drawstr(" - [MIDI Editor] ") else gfx.drawstr(" - [Main] ") end
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        gfx.set(1,1,1)
        gfx.drawstr(reaper.GetToggleCommandStateEx(states[i][3],reaper.NamedCommandLookup(states[i][2])).."\n")
        states[i][5]=tostring(reaper.GetToggleCommandStateEx(states[i][3],reaper.NamedCommandLookup(states[i][2])))
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
        gfx.drawstr(reaper.GetExtState(states[i][2],states[i][3]).."\n")
        states[i][5]=tostring(reaper.GetExtState(states[i][2],states[i][3]))
      elseif states[i][1]=="gmem" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.8)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(1,1,0)
        gfx.x=row2
        gfx.drawstr(" | GMEM ["..states[i][2].."] -> index:"..states[i][3]..": ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        reaper.gmem_attach(states[i][2])
        gfx.drawstr(reaper.gmem_read(states[i][3]))
      elseif states[i][1]=="projextstate" then
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
        states[i][5]=tostring(value)
    elseif states[i][1]=="configvar" then
      --mespotine
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(1,0.6,1)
        gfx.x=row2
        local val=""
        if ConfigVars[states[i][2]]=="integer" then val=reaper.SNM_GetIntConfigVar(states[i][2], -100000000)
        elseif ConfigVars[states[i][2]]=="float" then val=reaper.SNM_GetDoubleConfigVar(states[i][2], -100000000)
        elseif ConfigVars[states[i][2]]=="string" then valretval, val=reaper.get_config_var_string(states[i][2]) end
        gfx.drawstr(" | ConfigVar [\""..states[i][2].."\"] ("..ConfigVars[states[i][2]].."): ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        gfx.drawstr(val.."\n")
        states[i][5]=tostring(val)      
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
        states[i][5]=tostring(value)
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
        states[i][5]=tostring(value)
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
        states[i][5]=tostring(reaper.GetHZoomLevel())
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
        states[i][5]=tostring(reaper.Master_GetPlayRate(0))
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
        buf = reaper.format_timestr_pos(reaper.GetPlayPosition(), "", 5)
        gfx.drawstr(reaper.GetPlayPosition().." - "..buf.."\n")
        states[i][5]=tostring(reaper.GetPlayPosition().." - "..buf)
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
        buf = reaper.format_timestr_pos(reaper.GetCursorPosition(), "", 5)
        gfx.drawstr(reaper.GetCursorPosition().." - "..buf.."\n")
        states[i][5]=tostring(reaper.GetCursorPosition().." - "..buf.."\n")
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
        retval, tracknumber, itemnumber, fxnumber = reaper.GetFocusedFX2()
        if retval==1 then retval="track fx window: focused" end
        if retval==2 then retval="item fx window: focused" end
        if retval==0 then retval="no fx window focused" end
        if tracknumber=="0" then tracknumber="Master" end
        gfx.drawstr(retval.." | track: "..tracknumber.." | item: "..itemnumber.." | fx#: "..fxnumber.."\n")
        states[i][5]=tostring(retval.." | track: "..tracknumber.." | item: "..itemnumber.." | fx#: "..fxnumber)
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
        states[i][5]=tostring(reaper.GetFreeDiskSpaceForRecordPath(0,0))
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
        states[i][5]=tostring(reaper.GetFreeDiskSpaceForRecordPath(0,1))
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
        states[i][5]=tostring(integer)
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
        states[i][5]=tostring("Input-Latency: "..inputlatency.." | Output-Latency: "..outputLatency)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER"))
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
        states[i][5]=tostring("Track: "..tracknumber.." | Envelope Name: "..name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)
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
        buf = reaper.format_timestr_pos(name, "", 5)
        if name==nil then name="" end
        gfx.drawstr("seconds: "..name.." - timestring: "..buf.."\n")
        states[i][5]=tostring("seconds: "..name.." - timestring: "..buf)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring("MCP: "..mcpshow.." - TCP:"..tcpshow)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring("X-Position: "..x.." - Y-Position: "..y)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(state)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring(name)  
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
        states[i][5]=tostring("Window: "..window.." - Segment: "..segment.." - Details: "..details)  
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
        states[i][5]=tostring("EnvName: "..name.." - Tracknumber: "..tracknum.." - FX-idx: "..fx_num.." - Param-idx:"..param_num)  
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
        states[i][5]=tostring("Track: "..tracknum.." - Item in Track: "..itemnr.." - Position: "..position)  
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
        states[i][5]=tostring("Track: "..tracknum.." - Item in Track: "..itemnr.." - TakeNr: "..takenr.." - pos: "..position)
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
        states[i][5]=tostring("Track: "..tracknum)
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
        states[i][5]=tostring(name)
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
        states[i][5]=tostring(name)
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
        name = ultraschall.GetStringFromClipboard_SWS()
        if name==nil then name="" end
        name=string.gsub (name, "\n", "\\n")
        gfx.drawstr(name.."\n")    
        states[i][5]=tostring(name)
      elseif states[i][1]=="time" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Current Time: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        name = os.date()
        if name==nil then name="" end
        name=string.gsub (name, "\n", "\\n")
        gfx.drawstr(name.."\n")    
        states[i][5]=tostring(name)
      elseif states[i][1]=="getchar" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Get Character: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        X,Y= reaper.BR_Win32_GetPrivateProfileString("codes", A, "", KeyCodeIni_File)
        gfx.drawstr(A.." | "..Y.."\n")
        states[i][5]=tostring(A)
      elseif states[i][1]=="getchar_clip" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Get Character and put charcode to clipboard, if not 0: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        X,Y= reaper.BR_Win32_GetPrivateProfileString("codes", A, "", KeyCodeIni_File)
        gfx.drawstr(A.." | "..Y.."\n")
        if A~=0 then 
          reaper.CF_SetClipboard(A)
        end
        states[i][5]=tostring(A)
      elseif states[i][1]=="numallmarker" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Number of Markers/Regions in Project: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        T=reaper.CountProjectMarkers(0)
        gfx.drawstr(T.."\n")
        states[i][5]=tostring(T)
      elseif states[i][1]=="nummarker" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Number of Markers: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        t,T=reaper.CountProjectMarkers(0)
        gfx.drawstr(T.."\n")
        states[i][5]=tostring(T)
      elseif states[i][1]=="numregions" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Number of Regions: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        t,t,T=reaper.CountProjectMarkers(0)
        gfx.drawstr(T.."\n")
        states[i][5]=tostring(T)
      elseif states[i][1]=="numtimesigmarker" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Number of TimeSignature-Markers: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        T=reaper.CountTempoTimeSigMarkers(0)
        gfx.drawstr(T.."\n")
        states[i][5]=tostring(T)
      elseif states[i][1]=="countmediaitems" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Number of MediaItems: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        T=reaper.CountMediaItems(0)
        gfx.drawstr(T.."\n")
        states[i][5]=tostring(T)
      elseif states[i][1]=="timesel" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Time/Loop-Selection: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        T,T2 = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        T3=reaper.format_timestr(T2-T,"")
        gfx.drawstr(T.." - "..T2.." length:"..T3.."\n")
        states[i][5]=tostring(T)..","..tostring(T2)
      elseif states[i][1]=="arrangeviewtime" then
        gfx.drawstr(i)
        gfx.set(0.3,0.3,0.3)
        gfx.line(gfx.x,gfx.y+font_height,row3,gfx.y+font_height)
        gfx.set(0,1,0)
        gfx.x=row2
        gfx.drawstr(" | Shown Timerange in Arrange-View: ")
        gfx.set(1,1,1)
        if gfx.x>row3 then row3=gfx.x+50 end
        gfx.x=row3
        T,T2 = reaper.GetSet_ArrangeView2(0, false, 0, 0)
        gfx.drawstr(T.." - "..T2.."\n")
        states[i][5]=tostring(T)..","..tostring(T2)          
      end
      gfx.x=10
      gfx.set(1,1,1)
      gfx.setfont(1,"Arial", 12, 0)
    end
  --  timerrefresh=reaper.time_precise()+refresh
--  end
  for i=1, counter do
    width, height = gfx.measurestr(states[i][5])
    if width>maxwidth then maxwidth=width end
  end
  if stop~=false then last_entry=counter end
  if last_entry>0 and gfx.h>yoffset+18 then
    gfx.set(0.5,0.5,0.5)
--    gfx.rect(xoffset-4,yoffset+4,maxwidth+row3-xoffset+4,gfx.h-yoffset-17,0)
--    Inverse_Rectangle(xoffset-4,yoffset+4,maxwidth+row3-xoffset+4,gfx.h-yoffset-17, 0.5, 0.5, 0.5, 0.2, 0.2, 0.2, true)
    Inverse_Rectangle(xoffset-4,yoffset+4,gfx.w-57,gfx.h-yoffset-17, 0.5, 0.5, 0.5, 0.2, 0.2, 0.2, true)
    gfx.line(row2,yoffset+4,row2,gfx.h-15)
    gfx.line(row3-5,yoffset+4,row3-5,gfx.h-15)
    
    gfx.set(0.04,0.04,0.04)
    gfx.rect(gfx.w-30,yoffset+4,gfx.w,gfx.h)
    gfx.set(1,1,1)
  end

end

function ShowSelectedEnvelopeState()
 if oldstatechange2==nil then oldstatechange2=-1 end
 statechange=reaper.GetProjectStateChangeCount(0)
-- if statechange~=oldstatechange2 then 
    str=""
    Env=reaper.GetSelectedTrackEnvelope(0)
    if Env~=nil then _h,str=reaper.GetEnvelopeStateChunk(Env,"",true) end
    gfx.set(0.01,0.01,0.01,1,0,10)
    gfx.setimgdim(10,2048,2048)
    gfx.rect(0,0,2048,2048,true)
    gfx.set(0, 0.7, 1)
    gfx.x=10
    gfx.y=10
    gfx.drawstr("Shortcuts: Ctrl/Cmd+C: copy Statechunk to clipboard - Crlt/Cmd+V: paste statechunk from clipboard")
    gfx.set(1,1,1,1,0,10)
    gfx.x=10
    gfx.y=30
    str=StateChunkLayouter(str)
    gfx.drawstr(str)
    oldstatechange=statechange
--  end  
  if A==3 then print3(str) end
  if A==22 then reaper.SetEnvelopeStateChunk(Env, FromClip(), false) end
  gfx.x=0
  gfx.y=20
  gfx.set(1,1,1,1,0,-1)
  gfx.blit(10,1,0,0+(sidestep*font_height),0+(font_height*math.floor(start_state2)),1024,1024)

end


function ShowSelectedItemState()
 if oldstatechange==nil then oldstatechange=-1 end
 statechange=reaper.GetProjectStateChangeCount(0)
-- if statechange~=oldstatechange then 
   str=""
   MediaItem=reaper.GetSelectedMediaItem(0,0)
   if MediaItem~=nil then _h, str = reaper.GetItemStateChunk(MediaItem,"",false) end
    gfx.set(0.01,0.01,0.01,1,0,10)
    gfx.setimgdim(10,2048,2048)
    gfx.rect(0,0,2048,2048,true)
    gfx.set(0, 0.7, 1)
    gfx.x=10
    gfx.y=10
    gfx.drawstr("Shortcuts: Ctrl/Cmd+C: copy Statechunk to clipboard - Crlt/Cmd+V: paste statechunk from clipboard")
    gfx.set(1,1,1,1,0,10)
    gfx.x=10
    gfx.y=30
    str=StateChunkLayouter(str)
    gfx.drawstr(str)
    oldstatechange=statechange
    --gfx.set(0.1,0.1,0.1,1,0,-1)
    --gfx.rect(0,20,gfx.w,gfx.h,true)
--  end  
  if A==3 then print3(str) end
  if A==22 then reaper.SetItemStateChunk(MediaItem, FromClip(), false) end
  gfx.x=0
  gfx.y=20
  gfx.set(1,1,1,1,0,-1)
  gfx.blit(10,1,0,0+(sidestep*font_height),0+(font_height*math.floor(start_state2)),1024,1024)
end

function ShowSelectedTrackState()
 if oldstatechange==nil then oldstatechange=-1 end
 statechange=reaper.GetProjectStateChangeCount(0)
-- statechange=statechange+1
-- if statechange~=oldstatechange then 
   str=""
   MediaTrack=reaper.GetLastTouchedTrack()--reaper.GetSelectedTrack(0,0)
--   if MediaTrack==nil then MediaTrack=reaper.GetMasterTrack
   if MediaTrack~=nil then _h, str = reaper.GetTrackStateChunk(MediaTrack,"",false) end
    gfx.set(0.01,0.01,0.01,1,0,10)
    gfx.setimgdim(10,2048,2048)
    gfx.rect(0,0,2048,2048,true)
    gfx.set(0, 0.7, 1)
    gfx.x=10
    gfx.y=10
    gfx.drawstr("Shortcuts: Ctrl/Cmd+C: copy Statechunk to clipboard - Crlt/Cmd+V: paste statechunk from clipboard")
    gfx.set(1,1,1,1,0,10)
    gfx.x=10
    gfx.y=30
    str=StateChunkLayouter(str)
    gfx.drawstr(str)
    oldstatechange=statechange
    --gfx.set(0.1,0.1,0.1,1,0,-1)
    --gfx.rect(0,20,gfx.w,gfx.h,true)
--  end  
  if A==3 then print3(str) end
  if A==22 then reaper.SetTrackStateChunk(MediaTrack, FromClip(), false) end
  gfx.x=0
  gfx.y=20
  gfx.set(1,1,1,1,0,-1)
  gfx.blit(10,1,0,0+(sidestep*font_height),0+(font_height*math.floor(start_state2)),1024,1024)
end

function Show(integer)
  gfx.set(0.04,0.04,0.04)
  gfx.rect(0,0,gfx.w,gfx.h)
  DrawMenu()
  if integer==1 then ShowStates() end
  if integer==2 then 
      T=reaper.MB("Put these Projectnotes into Clipboard?\n\n\""..reaper.GetSetProjectNotes(0, false, "").."\"","Show Projectnotes",4) 
      if T==6 then reaper.CF_SetClipboard(reaper.GetSetProjectNotes(0, false, "")) end 
      ViewMenu=oldmenu 
  end
  if integer==3 then ShowSelectedTrackState() end
  if integer==4 then ShowSelectedItemState() end
  if integer==5 then ShowSelectedEnvelopeState() end
end

function AddAllStatesFromIniFile()
  retval,T=reaper.GetUserFileNameForRead("","Select Ini-File", "")
  if retval==true then
    File=ultraschall.ReadFullFile(T,false)
    section=""
    while File~=nil do
      line=File:match(".-\n")
      if line~=nil then
        temp=line:match("%[(.-)%]")
        key=line:match("(.-)=")
      end
      if temp~=nil then section=temp end
      if key~=nil then    
        counter=counter+1
        states[counter]={}
        states[counter][0]=false
        states[counter][1]="anyextstate"
        states[counter][2]=section
        states[counter][3]=key
        states[counter][4]=T
      end
      File=File:match("\n(.*)")
    end
    altered="(altered)"
  end
end

function AddToggleCommand()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New Toggle Command", 2, "ActionCommandID:,Section(0 - Main; 1 - MidiEditor)", "")
  if retval==false then return end
  if retvals_csv:sub(1,1)~="_" and tonumber(retvals_csv:match("(.-),"))==nil then retvals_csv="_"..retvals_csv end
  if retvals_csv:match(",(.*)")=="" then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="toggle"
  states[counter][2]=retvals_csv:match("(.-),")
  section=tonumber(retvals_csv:match(",(.*)"))
  if section==1 then states[counter][3]=32060 else states[counter][3]=0 end
  altered="(altered)"
end

function AddGMEMState()
  retval, retvals_csv = reaper.GetUserInputs("Give Me New GMEM State", 2, "GMEM-shared name:,index,separator=\n", "")
  if retval==false then return end
--  if retvals_csv:sub(1,1)~="_" and tonumber(retvals_csv:match("(.-),"))==nil then retvals_csv="_"..retvals_csv end
  if retvals_csv:match("\n(.*)")=="" then return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="gmem"
  states[counter][2]=retvals_csv:match("(.-)\n")
  states[counter][3]=tonumber(retvals_csv:match("\n(.*)"))
  --Pudel=tonumber(retvals_csv:match("\n(.*)"))
  altered="(altered)"
end

function AddConfigVarState()
--mespotine
  retval, retvals_csv = reaper.GetUserInputs("Give Me New ConfigVar", 1, "Configvar Name", "")
  if retval==false then return end
  if ConfigVars[retvals_csv]==nil then print2("Sorry, no such configvariable...") return end
  counter=counter+1
  states[counter]={}
  states[counter][1]="configvar"
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
Ultraschall State Inspector - ultraschall.fm
  
This Inspector shows the current states of Toggle-Commands as well as External States and some of Reaper's states. 
You can follow as many states as you want.

Use the menu or one of the command-letters to open a dialog, where you can enter the state, that you want to follow.

"T"    - adds a Toggle Command, that you want to follow. Give the 
           Action Command ID and it will show in the list. 
           The state of -1 shows, that this Action has no 
           ToggleCommand-State or doesn't exist.
"E","U" - adds external states/ultraschall-external states. 
              They will be loaded from reaper.extstate.ini or 
              ultraschall.ini respectively.
"P"   - will add Project-external-states.
"A"   - will add an external state from any ini-file you desire. 
          You must enter the full path and filename to the ini-file 
          in the add-dialog. Use $res$ for the resource-folder of 
          Reaper or leave empty to open a open-file-dialog after 
          hitting OK.
"G"   - will add a gmem-state
"V"   - adds a config-variable
"Shift+A" - adds all key-value-stores from a chosen ini-file at once(e.g reaper.ini)
In the Menu - you can also add Reaper's own states, ordered by category

CursorUp, CursorDn, PgUp, PgDn, Pos1, End, Mousewheel to scroll the list.
CursorLeft/CursorRight, HorizontalMousewheel - scroll list horizontally.

"D" - deletes an entry of your choice.
"B" - toggles highlighting on/off of an entry of your choice
"Cmd+Up/Cmd+Dn" - Go to previous/next highlighted entry
"V" - removes all highlighting
"O" - orders your statelist
"S" - saves a statelist into one of the slots. After that, you can 
        use "1" to "9" to quick-reload the state-list. 
"L" - shows you a list of your state-lists, you've saved. 
        Saved slots will be stored in Ultraschall-Inspector.ini in 
        the resources-folder of Reaper.
"Ctrl+L" - import a state-list from a file
"Ctrl+S" - export state-list to a file

"M" - Move entry to other position

"0" (zero) - for a list of all Ultraschall-States

"Cmd+F/Ctrl+F" - Search for a value
"F3/Alt+F3" - Search forward/backward

"H" - shows this Help-dialog

You can also change states, when right-clicking on them and 
highlight them by left-clicking.

To end the inspector, hit Esc or just close the window.]]
  reaper.MB(helpmessage, "Ultraschall Inspector "..version.." - Help",0)
end

function SaveStateCollection(state)
  retval, retvals_csv=""
  if state==nil then
    retval, retvals_csv = reaper.GetUserInputs("Save Your Statelist", 2, "Statelist-Slot-Nr(1-20),Title of Statelist,Filename", "")
  else
    retval, Savefilename = reaper.GetUserInputs("Save-filename, leave empty to select an existing file", 1, "Filename", "")
    if Savefilename==nil or Savefilename=="" then
      retval, Savefilename = reaper.GetUserFileNameForRead("", "Select a file to save to. Must exist!", "")      
    end
    retvals_csv="1,"
  end
  if retval==false then return false end
  if Savefilename==nil then Savefilename=InspectorIni_File end
  if tonumber(retvals_csv:match("(.-),"))==nil or tonumber(retvals_csv:match("(.-),"))<0 or tonumber(retvals_csv:match("(.-),"))>20 then reaper.MB("No valid slotnumber. Only 1 to 20 allowed!","Oops",0) return end
  slotnumber=tonumber(retvals_csv:match("(.-),"))
  slotname=retvals_csv:match(",(.*)")
  boolean=reaper.BR_Win32_WritePrivateProfileString("collection"..tonumber(retvals_csv:match("(.-),")), "Name", retvals_csv:match(",(.*)"), Savefilename)
  boolean=reaper.BR_Win32_WritePrivateProfileString("collection"..tonumber(retvals_csv:match("(.-),")), "numentries", counter, Savefilename)
  for i=1, counter do
    if states[i][1]=="toggle" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) 
      else reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "false", Savefilename) 
      end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
    elseif states[i][1]=="extstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
    elseif states[i][1]=="projextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
    elseif states[i][1]=="usextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
    elseif states[i][1]=="anyextstate" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      LL=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      LL2=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      LL3=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
      LL4=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..4, states[i][4], Savefilename)
    elseif states[i][1]=="gmem" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      LL=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      LL2=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
      LL3=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..3, states[i][3], Savefilename)
    elseif states[i][1]=="configvar" then
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      LL=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
      LL=reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..2, states[i][2], Savefilename)
    else
      temp= states[i][0]
      if temp==true then reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..0, "true", Savefilename) end
      reaper.BR_Win32_WritePrivateProfileString("collection"..slotnumber, "entry"..i.."_"..1, states[i][1], Savefilename)
    end
  end
  altered=""
end

function ShowSlots(returnit)
  retval, slot1 = reaper.BR_Win32_GetPrivateProfileString("collection1", "Name", "", InspectorIni_File)
  retval, slot2 = reaper.BR_Win32_GetPrivateProfileString("collection2", "Name", "", InspectorIni_File)
  retval, slot3 = reaper.BR_Win32_GetPrivateProfileString("collection3", "Name", "", InspectorIni_File)
  retval, slot4 = reaper.BR_Win32_GetPrivateProfileString("collection4", "Name", "", InspectorIni_File)
  retval, slot5 = reaper.BR_Win32_GetPrivateProfileString("collection5", "Name", "", InspectorIni_File)
  retval, slot6 = reaper.BR_Win32_GetPrivateProfileString("collection6", "Name", "", InspectorIni_File)
  retval, slot7 = reaper.BR_Win32_GetPrivateProfileString("collection7", "Name", "", InspectorIni_File)
  retval, slot8 = reaper.BR_Win32_GetPrivateProfileString("collection8", "Name", "", InspectorIni_File)
  retval, slot9 = reaper.BR_Win32_GetPrivateProfileString("collection9", "Name", "", InspectorIni_File)
  retval, slot10 = reaper.BR_Win32_GetPrivateProfileString("collection10", "Name", "", InspectorIni_File)
  retval, slot11 = reaper.BR_Win32_GetPrivateProfileString("collection11", "Name", "", InspectorIni_File)
  retval, slot12 = reaper.BR_Win32_GetPrivateProfileString("collection12", "Name", "", InspectorIni_File)
  retval, slot13 = reaper.BR_Win32_GetPrivateProfileString("collection13", "Name", "", InspectorIni_File)
  retval, slot14 = reaper.BR_Win32_GetPrivateProfileString("collection14", "Name", "", InspectorIni_File)
  retval, slot15 = reaper.BR_Win32_GetPrivateProfileString("collection15", "Name", "", InspectorIni_File)
  retval, slot16 = reaper.BR_Win32_GetPrivateProfileString("collection16", "Name", "", InspectorIni_File)
  retval, slot17 = reaper.BR_Win32_GetPrivateProfileString("collection17", "Name", "", InspectorIni_File)
  retval, slot18 = reaper.BR_Win32_GetPrivateProfileString("collection18", "Name", "", InspectorIni_File)
  retval, slot19 = reaper.BR_Win32_GetPrivateProfileString("collection19", "Name", "", InspectorIni_File)
  retval, slot20 = reaper.BR_Win32_GetPrivateProfileString("collection20", "Name", "", InspectorIni_File)
  if returnit~=true then
    reaper.MB("Your state-list slots:\n\n 1 - "..slot1.."\n 2 - "..slot2.."\n 3 - "..slot3.."\n 4 - "..slot4.."\n 5 - "..slot5.."\n 6 - "..slot6.."\n 7 - "..slot7.."\n 8 - "..slot8.."\n 9 - "..slot9,"State-list Slots",0)
  else
    return slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13, slot14, slot15, slot16, slot17, slot18, slot19, slot20
  end
end

function LoadSlot(slot, quest, filename)
  local B
  if altered=="(altered)" then
    B=reaper.MB("Do you want to save the current state-list?","Save state-list?", 3)
    --reaper.MB(B,"",0)
  end
  if B==6 then SaveStateCollection() end
  if B==2 then return end
  if filename==nil then filename=InspectorIni_File else slot=1 end
  retval, count = reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "numentries", "", filename)
  if count=="" then reaper.MB("This slot contains no collection yet.", "Oops", 0) return end
  slotnumber=slot
  retval, slotname = reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "Name", "", filename)
  counter=tonumber(count)
  states={}
  for i=1, counter do
    states[i]={}
    retval, temp=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_0", "", filename)
    if temp=="true" then states[i][0]=true else states[i][0]=false end
    retval, states[i][1]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_1", "", filename)
    retval, states[i][2]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_2", "", filename)
    if states[i][1]=="toggle" or states[i][1]=="extstate" or states[i][1]=="usextstate" or states[i][1]=="projextstate" then
      retval, states[i][3]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_3", "", filename)
    end
    if states[i][1]=="anyextstate" then
      retval, states[i][3]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_3", "", filename)
      retval, states[i][4]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_4", "", filename)
    end
    if states[i][1]=="gmem" then
      retval, states[i][3]=reaper.BR_Win32_GetPrivateProfileString("collection"..slot, "entry"..i.."_3", "", filename)
    end  
  end
  altered=""
  last_entry=0
  start_state=1

end

function ClearList(state)
  local B, C
  if state==true and altered=="(altered)"  then
    B=reaper.MB("Do you want to save the current state-list before clearing it?","Save state-list?", 3)
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

function ToggleHighlight()
  D, D2 =reaper.GetUserInputs("Toggle Which State-Entry Bold/Unbold?", 1, "StateEntry #:", "")
  if tonumber(D2)==nil or tonumber(D2)<1 or tonumber(D2)>counter then reaper.MB("No such state-entry...", "Ooopps...", 0) return end
  if states[tonumber(D2)][0]~=true then states[tonumber(D2)][0]=true else states[tonumber(D2)][0]=false end
end

function AddReaperStates(entry)
  counter=counter+1 states[counter]={} states[counter][1]=entry altered="(altered)"

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


function SearchForward()
  for i=math.floor(start_state)+1, counter do

--    if states[i][1]:match(SearchValue)~=nil then start_state=i return end
--    if states[i][2]:match(SearchValue)~=nil then start_state=i return end
--    if states[i][3]:match(SearchValue)~=nil then start_state=i return end
--    if states[i][4]~=nil and states[i][4]:match(SearchValue)~=nil then start_state=i return end
    if states[i][1]~=nil then temp=states[i][1]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][2]~=nil then temp=states[i][2]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][3]~=nil then temp=states[i][3]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end    
    if states[i][4]~=nil then temp=states[i][4]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][5]~=nil then temp=states[i][5]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
  end
  reaper.MB("Searchstring not found...", "Ooops", 0)
end

function SearchBackward()
  for i=math.floor(start_state)-1, 1, -1 do
    --[[if states[i][1]:match(SearchValue)~=nil then start_state=i return end
    if states[i][2]:match(SearchValue)~=nil then start_state=i return end
    if states[i][3]:match(SearchValue)~=nil then start_state=i return end
    if states[i][4]~=nil and states[i][4]:match(SearchValue)~=nil then start_state=i return end
    if states[i][5]~=nil and states[i][5]:match(SearchValue)~=nil then start_state=i return end    --]]

    if states[i][1]~=nil then temp=states[i][1]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][2]~=nil then temp=states[i][2]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][3]~=nil then temp=states[i][3]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end    
    if states[i][4]~=nil then temp=states[i][4]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
    if states[i][5]~=nil then temp=states[i][5]:lower() if temp:match(SearchValue)~=nil then start_state=i return end end
  end
  reaper.MB("Searchstring not found...", "Ooops", 0)
end

function SearchWindow()
  retval,T=reaper.GetUserInputs("Search for:", 1, "", "")
  if retval==true then SearchValue=T:lower() SearchForward() end
end

function main()
  gfx.update()
  A=gfx.getchar()
  if gfx.getchar()~=-1 then
    if shortcuts=="on" then 
    
      -- NOTE: show state-chunk-functions occupy getchar=3(ctrl+C) for copying them into clipboard
      -- all other are used in here
      if A==116.0 then AddToggleCommand() end
      if A==103.0 then AddGMEMState() end
      if A==6 then SearchWindow() end
      if A==26163.0 and gfx.mouse_cap&16==0 then SearchForward() end
      if A==26163.0 and timer<reaper.time_precise() and gfx.mouse_cap&16==16 then timer=reaper.time_precise()+0.1 SearchBackward() end
      if A==101.0 then AddExternalState() end
      if A==117.0 then AddUSExternalState() end
      if A==97.0 then AddAnyExternalState() end
      if A==112 then AddProjExternalState() end
      if A==118 then AddConfigVarState() end
      if A==109 then MoveEntry() end
      if A==100.0 then RemoveEntry() end
      if A==115.0 then SaveStateCollection() end
      if A==19.0 then SaveStateCollection("testimonial") end
      if A==108.0 then ShowSlots() end
      if A==104.0 then ShowHelp() end
      if A==99.0 then ClearList(true) end
      if A==67.0 then ClearList(false) end
      if A==49 then LoadSlot(1) end
      if A==33 then LoadSlot(1, false) end
      if A==12.0 then retval, filename = reaper.GetUserFileNameForRead("", "Select Inspector-File", "") if filename~=nil then LoadSlot(1, false, filename) end end
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
      if A==65 then AddAllStatesFromIniFile() end
  --    if A==114 then AddReaperStates() end
      if A==118 then ClearHighlighting() end
      -- move list with arrowkeys
      if A==30064 and gfx.mouse_cap&4==0 and counter>0 then start_state=start_state-1 start_state2=start_state2-1 if math.floor(start_state)<1 then start_state=1 end end
      if A==1685026670 and gfx.mouse_cap&4==0 and counter>0 and stop==false then start_state=start_state+1 start_state2=start_state2+1 if math.floor(start_state)>counter then start_state=counter end end
      -- jump to next highlighted entry with ctrl+up/dn
      if A==1685026670.0 and gfx.mouse_cap&4==4 and counter>0 then for i=math.floor(start_state)+1, counter do if states[i][0]==true then start_state=i break end end end
      if A==30064 and gfx.mouse_cap&4==4 and counter>0 then for i=math.floor(start_state)-1, 1, -1 do if states[i][0]==true then start_state=i break end end end
      
      if A==98 then ToggleHighlight() end -- B
      if A==27 then gfx.quit() end -- ESC
      --left/right
      if A==1919379572 and gfx.mouse_cap&4==0 then if row3+maxwidth>gfx.w then row1=row1-horizontalspeed row2=row2-horizontalspeed row3=row3-horizontalspeed end end
      if A==1818584692 and gfx.mouse_cap&4==0 then if xoffset<30 then row1=row1+horizontalspeed row2=row2+horizontalspeed row3=row3+horizontalspeed end end
      if A==1919379572 and gfx.mouse_cap&4==4 then if row3+maxwidth>gfx.w then row1=row1-horizontalspeed*4 row2=row2-horizontalspeed*4 row3=row3-horizontalspeed*4 end end
      if A==1818584692 and gfx.mouse_cap&4==4 then if xoffset<30 then row1=row1+horizontalspeed*4 row2=row2+horizontalspeed*4 row3=row3+horizontalspeed*4 end end
      -- PgUp/PgDn
      if A==1885824110 and gfx.mouse_cap&4==0 and last_entry~=counter then start_state=start_state+list_num_lines if math.floor(start_state)+list_num_lines-1>counter then start_state=counter-list_num_lines end end
      if A==1885828464 and gfx.mouse_cap&4==0 then start_state=start_state-(last_entry-start_state) if math.floor(start_state)<1 then start_state=1 end end
      -- Cmd+PgUp/Cmd+PgDwn
      if A==1885824110 and gfx.mouse_cap&4==4 and last_entry~=counter then start_state=start_state+list_num_lines if math.floor(start_state)+list_num_lines-1>counter then start_state=counter-list_num_lines end end
      if A==1885828464 and gfx.mouse_cap&4==4 then start_state=start_state-(last_entry-start_state) if math.floor(start_state)<1 then start_state=1 end end
      if A==6647396 and last_entry~=counter then start_state=counter-(last_entry-start_state) if math.floor(start_state)<1 then start_state=1 end end
      if A==1752132965 then start_state=1 end    
      if gfx.mouse_wheel>Mousewheel and counter>0 then start_state=start_state-(gfx.mouse_wheel*0.005) start_state2=start_state2-(gfx.mouse_wheel*0.005) if start_state<1 then start_state=1 end gfx.mouse_wheel=0 end
      if gfx.mouse_wheel<Mousewheel and counter>0 and stop==false then start_state=start_state-(gfx.mouse_wheel*0.005) start_state2=start_state2-(gfx.mouse_wheel*0.005) if start_state>counter then start_state=counter end gfx.mouse_wheel=0 end
      if gfx.mouse_hwheel>MousewheelH then sidestep=sidestep+(gfx.mouse_hwheel*0.05) if row3+maxwidth>gfx.w then row1=row1-horizontalspeed row2=row2-horizontalspeed row3=row3-horizontalspeed end gfx.mouse_hwheel=0 end
      if gfx.mouse_hwheel<MousewheelH then sidestep=sidestep+(gfx.mouse_hwheel*0.05) if xoffset<30 then row1=row1+horizontalspeed row2=row2+horizontalspeed row3=row3+horizontalspeed end gfx.mouse_hwheel=0 end
    end
    Show(ViewMenu)

    
    -- File Menu
    if gfx.mouse_x>0 and gfx.mouse_x<30 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
        DrawMenu()
        Inverse_Rectangle(2,2,30,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
        gfx.update()
        gfx.x=2 gfx.y=18
        slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13, slot14, slot15, slot16, slot17, slot18, slot19, slot20 = ShowSlots(true)
        FileMenu=gfx.showmenu("New State-list N|>LoadState|Slot 0 - \"Ultraschall\"  0|Slot 1 - \""..slot1.."\"  1|Slot 2 - \""..slot2.."\"  2|Slot 3 - \""..slot3.."\"  3|Slot 4 - \""..slot4.."\"  4|Slot 5 - \""..slot5.."\"  5|Slot 6 - \""..slot6.."\"  6|Slot 7 - \""..slot7.."\"  7|Slot 8 - \""..slot8.."\"  8|Slot 9 - \""..slot9.."\"  9|Slot10 - \""..slot10.."\"   |Slot11 - \""..slot11.."\"   |Slot12 - \""..slot12.."\"   |Slot13 - \""..slot13.."\"   |Slot14 - \""..slot14.."\"   |Slot15 - \""..slot15.."\"   |Slot16 - \""..slot16.."\"   |Slot17 - \""..slot17.."\"   |Slot18 - \""..slot18.."\"   |Slot19 - \""..slot19.."\"   |Slot20 - \""..slot20.."\"   |<|SaveState   S||Load State-List from External File   Ctrl+L|Save State-List into External File   Ctrl+S||Close   Esc")
    elseif gfx.mouse_x>0 and gfx.mouse_x<30 and gfx.mouse_y>0 and gfx.mouse_y<15 then
        Inverse_Rectangle(2,2,30,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
    end
    if FileMenu==1 then ClearList(true) FileMenu=0 end
    if FileMenu==2 then LoadSlot(0, false) FileMenu=0 end
    if FileMenu==3 then LoadSlot(1, false) FileMenu=0 end
    if FileMenu==4 then LoadSlot(2, false) FileMenu=0 end
    if FileMenu==5 then LoadSlot(3, false) FileMenu=0 end
    if FileMenu==6 then LoadSlot(4, false) FileMenu=0 end
    if FileMenu==7 then LoadSlot(5, false) FileMenu=0 end
    if FileMenu==8 then LoadSlot(6, false) FileMenu=0 end
    if FileMenu==9 then LoadSlot(7, false) FileMenu=0 end
    if FileMenu==10 then LoadSlot(8, false) FileMenu=0 end
    if FileMenu==11 then LoadSlot(9, false) FileMenu=0 end
    if FileMenu==12 then LoadSlot(10, false) FileMenu=0 end
    if FileMenu==13 then LoadSlot(11, false) FileMenu=0 end
    if FileMenu==14 then LoadSlot(12, false) FileMenu=0 end
    if FileMenu==15 then LoadSlot(13, false) FileMenu=0 end
    if FileMenu==16 then LoadSlot(14, false) FileMenu=0 end
    if FileMenu==17 then LoadSlot(15, false) FileMenu=0 end
    if FileMenu==18 then LoadSlot(16, false) FileMenu=0 end
    if FileMenu==19 then LoadSlot(17, false) FileMenu=0 end
    if FileMenu==20 then LoadSlot(18, false) FileMenu=0 end
    if FileMenu==21 then LoadSlot(19, false) FileMenu=0 end
    if FileMenu==22 then LoadSlot(20, false) FileMenu=0 end
    if FileMenu==23 then SaveStateCollection() FileMenu=0 end
    if FileMenu==24 then FileMenu=0 retval, filename = reaper.GetUserFileNameForRead("", "Select Inspector-File", "") if filename~=nil then LoadSlot(1, false, filename) end end
    if FileMenu==25 then SaveStateCollection(1) FileMenu=0 end
    if FileMenu==26 then gfx.quit() FileMenu=0 end
    
    --Add States Menu
    if gfx.mouse_x>33 and gfx.mouse_x<60+33 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
        DrawMenu()
        Inverse_Rectangle(33,2,58,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
        gfx.update()
        gfx.x=33 gfx.y=18
        AddStatesMenu=gfx.showmenu("Add Action/Script|Add Toggle Command  T|Add External State   E|Add Ultraschall External State  U|Add Any External State  A|Add Project External State  P|Add All States from Ini-File  Shift+A|Add GMEM-State G|Add ConfigVar V|>Add Reaper State|"..ReaperMenuString)
    elseif gfx.mouse_x>33 and gfx.mouse_x<60+33 and gfx.mouse_y>0 and gfx.mouse_y<15 then
        Inverse_Rectangle(33,2,58,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
    end    
    if AddStatesMenu==1 then AddToggleCommand() AddStatesMenu=0 end
    if AddStatesMenu==2 then AddToggleCommand() AddStatesMenu=0 end
    if AddStatesMenu==3 then AddExternalState() AddStatesMenu=0 end
    if AddStatesMenu==4 then AddUSExternalState() AddStatesMenu=0 end
    if AddStatesMenu==5 then AddAnyExternalState() AddStatesMenu=0 end
    if AddStatesMenu==6 then AddProjExternalState() AddStatesMenu=0 end
    if AddStatesMenu==7 then AddAllStatesFromIniFile() AddStatesMenu=0 end
    if AddStatesMenu==8 then AddGMEMState() AddStatesMenu=0 end
    if AddStatesMenu==9 then AddConfigVarState() AddStatesMenu=0 end
    if AddStatesMenu>=10 then AddReaperStates(ReturnReaperMenuEntry(AddStatesMenu-3, ReaperMenu)) t,t2=ReturnReaperMenuEntry(AddStatesMenu, ReaperMenu) AddStatesMenu=0 end

    --Edit List Menu
   if gfx.mouse_x>93 and gfx.mouse_x<93+47 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
        DrawMenu()
        Inverse_Rectangle(93,2,47,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
        gfx.update()
        gfx.x=93 gfx.y=18
        EditListMenu=gfx.showmenu("Toggle Highlight Entry   B|Remove All Highlighting   V||Move Entry   M|Delete Entry   D||Order State-list   O|Clear State-list   C||Toggle Keyboard-Control - "..shortcuts)
    elseif gfx.mouse_x>93 and gfx.mouse_x<93+47 and gfx.mouse_y>0 and gfx.mouse_y<15 then
        Inverse_Rectangle(93,2,47,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
    end
    if EditListMenu==1 then  ToggleHighlight() EditListMenu=0 end
    if EditListMenu==2 then  ClearHighlighting() EditListMenu=0 end
    if EditListMenu==3 then  MoveEntry() EditListMenu=0 end
    if EditListMenu==4 then  RemoveEntry() EditListMenu=0 end
    if EditListMenu==5 then  OrderEntries() EditListMenu=0 end
    if EditListMenu==6 then  ClearList(true)  EditListMenu=0 end
    if EditListMenu==7 then if shortcuts=="off" then shortcuts="on" else shortcuts="off" end EditListMenu=0 end

    --View List Menu
   if gfx.mouse_x>168 and gfx.mouse_x<168+33 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
        DrawMenu()
        Inverse_Rectangle(168,2,30,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
        gfx.update()
        gfx.x=168 gfx.y=18
        oldmenu=ViewMenu
        ViewMenu=gfx.showmenu("General States|Project Notes|Track States|Item States(First Item Selected)|Envelope States(Selected Envelope)")
        if ViewMenu<1 then ViewMenu=1 end
    elseif gfx.mouse_x>168 and gfx.mouse_x<168+33 and gfx.mouse_y>0 and gfx.mouse_y<15 then
        Inverse_Rectangle(168,2,30,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
    end
    
   -- Developer Toolsmenu
   if gfx.mouse_x>205 and gfx.mouse_x<205+76 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
        DrawMenu()
        Inverse_Rectangle(205,2,77,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
        gfx.update()
        gfx.x=205 gfx.y=18
        DeveloperMenu=gfx.showmenu("Stop all running scripts|>Color Converter|RGB to Native|Native to RGB|RGB(0-255) to gfx.set(0-1)|<gfx.set(0-1) to RGB(0-255)|>Convert Number(s) to String|Integer|<HEX|>Convert String to|Integers|<HEX|Show Getchar-Character from Code|Put TrackStateChunk to Clipboard|Import TrackStateChunk from Clipboard to Track|Load Theme")
    elseif gfx.mouse_x>205 and gfx.mouse_x<205+76 and gfx.mouse_y>0 and gfx.mouse_y<15 then
        Inverse_Rectangle(205,2,76,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
    end
    if DeveloperMenu==1 then runcommand(41898) DeveloperMenu=0 end
    if DeveloperMenu==2 then 
        X,Y=reaper.GetUserInputs("RGB Color2Native Color("..reaper.GetOS()..")",3,"R(0-255),G(0-255),B(0-255),extrawidth=50", "") 
        if X==true then 
          R=tonumber(Y:match("(.-),"))
          G=tonumber(Y:match(",(.-),"))
          B=tonumber(Y:match(",.-,(.*)"))          
          if tonumber(R)~=nil and tonumber(G)~=nil and tonumber(B)~=nil then
            Z=reaper.MB("Put the following value into the clipboard? "..reaper.ColorToNative(R,G,B),"",4)
            if Z==6 then reaper.CF_SetClipboard(reaper.ColorToNative(R,G,B)) end
          end
        end
        DeveloperMenu=0  
    end
    if DeveloperMenu==3 then 
        X,Y=reaper.GetUserInputs("Native Color("..reaper.GetOS()..")2RGB Color",1,"Native Colorvalue,extrawidth=50", "") 
        if X==true then 
          if tonumber(Y)~=nil then 
            R,G,B=reaper.ColorFromNative(Y)
            Z=reaper.MB("Put the following values into the clipboard? "..R..", "..G..", "..B,"",4)
            if Z==6 then reaper.CF_SetClipboard(R..", "..G..", "..B) end
          end
        end
        DeveloperMenu=0  
    end
    if DeveloperMenu==4 then
        X,Y=reaper.GetUserInputs("RGB(0-255) to gfx.set(0-1)",3,"R(0-255),G(0-255),B(0-255),extrawidth=50", "") 
        if X==true then 
          R=tonumber(Y:match("(.-),"))
          G=tonumber(Y:match(",(.-),"))
          B=tonumber(Y:match(",.-,(.*)"))          
          if tonumber(R)~=nil and tonumber(G)~=nil and tonumber(B)~=nil then
            R=R/255
            G=G/255
            B=B/255
            Z=reaper.MB("Put the following values into the clipboard? "..R..", "..G..", "..B,"",4)
            if Z==6 then reaper.CF_SetClipboard(R..", "..G..", "..B) end
          end
        end
        DeveloperMenu=0  
    end
    if DeveloperMenu==5 then
        X,Y=reaper.GetUserInputs("gfx.set(0-1) to RGB(0-255)",3,"R(0-1),G(0-1),B(0-1),extrawidth=50", "") 
        if X==true then 
          R=tonumber(Y:match("(.-),"))
          G=tonumber(Y:match(",(.-),"))
          B=tonumber(Y:match(",.-,(.*)"))          
          if tonumber(R)~=nil and tonumber(G)~=nil and tonumber(B)~=nil then
            R=R*255
            G=G*255
            B=B*255
            Z=reaper.MB("Put the following values into the clipboard? "..R..", "..G..", "..B,"",4)
            if Z==6 then reaper.CF_SetClipboard(R..", "..G..", "..B) end
          end
        end
        DeveloperMenu=0  
    end
    if DeveloperMenu==6 then
        X,Y=reaper.GetUserInputs("Convert 2 Ascii",1,"Numbers to convert:,extrawidth=50", "") 
        if X==true then 
        Y=Y.." "
        NewString=""
        while Y:match("%d")~=nil do
          Z=Y:match("%d*")
          NewString=NewString..string.format("%c",tonumber(Z))
          Y=Y:sub(Z:len()+1,-1)
          len=Y:match("()%d")
          if len==nil then break end
          Y=Y:sub(len,-1)         
        end
            Z=reaper.MB("Put the following values into the clipboard? "..NewString,"",4)
            if Z==6 then reaper.CF_SetClipboard(NewString) end
        end
        DeveloperMenu=0  
    end    
    if DeveloperMenu==7 then
        X,Y=reaper.GetUserInputs("Convert 2 Hex",1,"Numbers to convert(0xnumber):,extrawidth=50", "") 
        if X==true then 
          Y=Y.." "
          NewString=""
          while Y:match("0x")~=nil do
            Z=Y:match("0x%x*")
            Z=string.format("%i",Z)
            NewString=NewString..string.format("%c",tonumber(Z))
            Y=Y:sub(Z:len()+1,-1)
            len=Y:match("()0x%x")
            if len==nil then break end
            Y=Y:sub(len,-1)         
          end
          if NewString~="" then
              Z=reaper.MB("Put the following values into the clipboard? "..NewString,"",4)
              if Z==6 then reaper.CF_SetClipboard(NewString) end
          end
        end
        DeveloperMenu=0  
    end    
    if DeveloperMenu==8 then
      X,Y=reaper.GetUserInputs("Convert to Integer",1,"String to convert:,extrawidth=50", "") 
      if X==true then
        NewString=""
        for i=1, Y:len() do
          char=Y:sub(i,i)
          NewString=NewString..string.byte(char)..","
        end
        if NewString~="" then
            Z=reaper.MB("Put the following values into the clipboard? "..NewString:sub(1,-2),"",4)
            if Z==6 then reaper.CF_SetClipboard(NewString:sub(1,-2)) end
        end
      end
      DeveloperMenu=0
    end
    if DeveloperMenu==9 then
      X,Y=reaper.GetUserInputs("Convert 2 Hex",1,"String to convert:,extrawidth=50", "") 
      if X==true then
        NewString=""
        for i=1, Y:len() do
          char=Y:sub(i,i)
          char=string.byte(char)
          Z=string.format("%x",char)
          NewString=NewString.."0x"..Z..","
        end
        if NewString~="" then
            Z=reaper.MB("Put the following values into the clipboard? "..NewString:sub(1,-2),"",4)
            if Z==6 then reaper.CF_SetClipboard(NewString:sub(1,-2)) end
        end
      end
      DeveloperMenu=0
    end
    if DeveloperMenu==10 then
      X,Y=reaper.GetUserInputs("Get Character as returned by gfx.GetChar-Code",1,"Code:,extrawidth=50", "") 
      if X==true then
        if Y:match("%.")==nil then
          Y=Y..".0"
        end
        L,NewString=reaper.BR_Win32_GetPrivateProfileString("Codes", Y, "", KeyCodeIni_File)
        if NewString~="" then
            Z=reaper.MB("Put the following value into the clipboard? "..NewString,"",4)
            if Z==6 then reaper.CF_SetClipboard(NewString:sub(1,-2)) end
        end
      end
      DeveloperMenu=0
    end    
    if DeveloperMenu==11 then
      X,Y=reaper.GetUserInputs("TrackStateChunk To Clipboard",1,"Tracknumber(0 for master):,extrawidth=50", "") 
      if X==true and tonumber(Y)~=nil and tonumber(Y)>=0 and tonumber(Y)<=reaper.CountTracks(0) then
        if tonumber(Y)==0 then Track=reaper.GetMasterTrack(0) else Track=reaper.GetTrack(0,tonumber(Y)-1) end
        retval, TSC=reaper.GetTrackStateChunk(Track,"",false)
        reaper.CF_SetClipboard(TSC)
      else
        if X==true then reaper.MB("No such track", "Oooops", 0) end
      end
      DeveloperMenu=0
    end
    if DeveloperMenu==12 then
      X,Y=reaper.GetUserInputs("TrackStateChunk From Clipboard to Track",1,"Tracknumber(0 for master):,extrawidth=50", "") 
      if X==true and tonumber(Y)~=nil and tonumber(Y)>=0 and tonumber(Y)<=reaper.CountTracks(0) then
        if tonumber(Y)==0 then Track=reaper.GetMasterTrack(0) else Track=reaper.GetTrack(0,tonumber(Y)-1) end
        TSC=ultraschall.GetStringFromClipboard_SWS()
        retval=reaper.SetTrackStateChunk(Track, TSC, true)
      else
        if X==true then reaper.MB("No such track", "Oooops", 0) end
      end
      DeveloperMenu=0
    end
    if DeveloperMenu==13 then      
      file=reaper.EnumerateFiles(reaper.GetResourcePath().."/ColorThemes", 0)
      filelist=""
      filecounter=0
      filelista={}
      while file~=nil do
        filelist=filelist..","..(filecounter+1)..":"..file
        filelista[filecounter]=file
        filecounter=filecounter+1
        file=reaper.EnumerateFiles(reaper.GetResourcePath().."/ColorThemes", filecounter)
      end
--      reaper.MB(filelist,"",0)
      ALA, BAMA= reaper.GetUserInputs("Type In Number",filecounter,filelist:sub(2,-1),"")
      if BAMA:match("^1,") then reaper.OpenColorThemeFile(filelista[0]) end
      if BAMA:match(",2,") then reaper.OpenColorThemeFile(filelista[1]) end
      if BAMA:match(",3,") then reaper.OpenColorThemeFile(filelista[2]) end
      if BAMA:match(",4,") then reaper.OpenColorThemeFile(filelista[3]) end
      if BAMA:match(",5,") then reaper.OpenColorThemeFile(filelista[4]) end
      if BAMA:match(",6,") then reaper.OpenColorThemeFile(filelista[5]) end
      if BAMA:match(",7,") then reaper.OpenColorThemeFile(filelista[6]) end
      if BAMA:match(",8,") then reaper.OpenColorThemeFile(filelista[7]) end
      if BAMA:match(",9,") then reaper.OpenColorThemeFile(filelista[8]) end
      if BAMA:match(",10,") then reaper.OpenColorThemeFile(filelista[9]) end
      if BAMA:match(",11,") then reaper.OpenColorThemeFile(filelista[10]) end
      if BAMA:match(",12,") then reaper.OpenColorThemeFile(filelista[11]) end
      if BAMA:match(",13,") then reaper.OpenColorThemeFile(filelista[12]) end
      if BAMA:match(",14,") then reaper.OpenColorThemeFile(filelista[13]) end
      if BAMA:match(",15,") then reaper.OpenColorThemeFile(filelista[14]) end
      if BAMA:match(",16,") then reaper.OpenColorThemeFile(filelista[15]) end
      
      DeveloperMenu=0
    end
        
  --Help
  if gfx.mouse_x>gfx.w-40 and gfx.mouse_x<gfx.w-5 and gfx.mouse_y>0 and gfx.mouse_y<15 and gfx.mouse_cap==1 then
       DrawMenu()
       Inverse_Rectangle(gfx.w-48,2,35,15, 1, 1, 1, 0.3, 0.3, 0.3, true)
       gfx.update()
       gfx.x=93 gfx.y=18
       ShowHelp()
   elseif gfx.mouse_x>gfx.w-48 and gfx.mouse_x<gfx.w-13 and gfx.mouse_y>0 and gfx.mouse_y<15 then
       Inverse_Rectangle(gfx.w-48,2,35,15, 1, 1, 1, 0.3, 0.3, 0.3, false)
   end
  BB=GetLine(gfx.mouse_y)
  if gfx.mouse_cap&1==1 and BB>0 and BB<=counter then
      width, height = gfx.measurestr(states[BB][5])
      if clicked==false and BB>0 and BB<last_entry+1 and BB<counter+1 and gfx.mouse_x>xoffset and gfx.mouse_x<row3+width then 
          if states[BB][0]==true then states[BB][0]=false else states[BB][0]=true end
      end
      clicked=true
  end
  if gfx.mouse_cap&2==2 and clicked==false and BB>0 and BB<last_entry+1 and BB<=counter and gfx.mouse_x>xoffset and gfx.mouse_x<row3+gfx.measurestr(states[BB][5]) then       
      clicked=true
      if states[BB][1]=="toggle" then 
        gfx.x=gfx.mouse_x
        gfx.y=gfx.mouse_y
        CCC=gfx.showmenu("#"..states[BB][2].."|Run Command|Run Command To last focused Midi-Editor|Toggle State")
        temp=reaper.NamedCommandLookup(states[BB][2]) 
        if CCC==2 then 
          reaper.Main_OnCommand(temp,0)
        elseif CCC==3 then
            reaper.MIDIEditor_LastFocused_OnCommand(temp, false)
        elseif CCC==4 then
          currentstate=reaper.GetToggleCommandState(temp)
          if currentstate==1 then currentstate=0 else currentstate=1 end
          reaper.SetToggleCommandState(0, temp, currentstate)
        end
      end
      if states[BB][1]=="extstate" then
        temp=reaper.GetExtState(states[BB][2],states[BB][3])
        temp2,CCC=reaper.GetUserInputs("New Extstate-Value", 2, "Make it persistant(y/n)?,Value,extrawidth=150", ","..temp)
        if temp2==true and CCC~=temp then if CCC:match("..")=="y," then persist=true else persist=false end  reaper.SetExtState(states[BB][2],states[BB][3],CCC:match(",(.*)"),persist) end
      end
      if states[BB][1]=="usextstate" then
        t,temp=ultraschall.GetUSExternalState(states[BB][2],states[BB][3])
        temp2,CCC=reaper.GetUserInputs("New Extstate-Value", 1, "Value,extrawidth=150", temp)
        if temp2==true and CCC~=temp then ultraschall.SetUSExternalState(states[BB][2],states[BB][3],CCC) end
      end
      if states[BB][1]=="projextstate" then
        t,temp=reaper.GetProjExtState(0,states[BB][2],states[BB][3])
        temp2,CCC=reaper.GetUserInputs("New Project-Extstate-Value", 1, "Value,extrawidth=150", ","..temp)
        if temp2==true and CCC~=temp then reaper.SetProjExtState(0,states[BB][2],states[BB][3],CCC) end
      end
      if states[BB][1]=="anyextstate" then
        t,temp=reaper.BR_Win32_GetPrivateProfileString(states[BB][2],states[BB][3],"",states[BB][4])
        temp2,CCC=reaper.GetUserInputs("New Extstate-Value", 1, "Value,extrawidth=150", temp)
        if temp2==true and CCC~=temp then reaper.BR_Win32_WritePrivateProfileString(states[BB][2],states[BB][3],CCC,states[BB][4]) end
      end      
      if states[BB][1]=="hzoom" then      
        temp2,CCC=reaper.GetUserInputs("New Zoom-Value", 3, "Zoomfactor(pos=z-in;neg=z-ut),Update trackview(true/false),Centermode(-1 to 3),extrawidth=150", temp)
        if temp2==true and tonumber(CCC:match("(.-),"))~=nil and tonumber(CCC:match(",.-,(.*)"))~=nil then
          bool=false
          if CCC:match(",(.-),")=="true" then bool=true else bool=false end
          reaper.adjustZoom(tonumber(CCC:match("(.-),")), 1, bool, tonumber(CCC:match(",.-,(.*)")))
        end
      end 
      if states[BB][1]=="clipboard" then      
        temp=ultraschall.GetStringFromClipboard_SWS()
        temp2,CCC=reaper.GetUserInputs("New Clipboard-Value", 1, "Clipboard-String,extrawidth=350", temp)
        if temp2==true then
          reaper.CF_SetClipboard(CCC)
        end
      end 
      if states[BB][1]=="editpos" then      
        temp2,CCC=reaper.GetUserInputs("New Editcursor-position", 1, "Position in seconds,extrawidth=350", temp)
        if temp2==true and tonumber(CCC)~=nil then
            reaper.SetEditCurPos(tonumber(CCC), true, false)
        end
      end 
      if states[BB][1]=="playpos" then
        temp2,CCC=reaper.GetUserInputs("New Playcursor-position(only when rec/play)", 1, "Position in seconds,extrawidth=350", temp)
        oldpos=reaper.GetCursorPosition()
        if temp2==true and tonumber(CCC)~=nil then
            reaper.SetEditCurPos(tonumber(CCC), true, true)
            reaper.SetEditCurPos(oldpos, true, false)
        end
      end 
      if states[BB][1]=="playrate" then
        temp2,CCC=reaper.GetUserInputs("New Playrate(0.25 to 4)", 1, "Playrate,extrawidth=350", temp)
        oldpos=reaper.GetCursorPosition()
        if temp2==true and tonumber(CCC)~=nil then
            reaper.CSurf_OnPlayRateChange(tonumber(CCC))
        end
      end 
      if states[BB][1]=="mastertrackvis" then
        temp2,CCC=reaper.GetUserInputs("Mastetrack visibility", 2, "Show in TCP(y/n)?,Show in MCP(y/n)?,extrawidth=350", temp)
        oldpos=reaper.GetCursorPosition()
        if temp2==true and CCC~=nil then
            flag=0
            if CCC:match(".")=="y" then flag=flag+1 end
            if CCC:match(",(.)")=="n" then flag=flag+2 end
            integer = reaper.SetMasterTrackVisibility(flag)
        end        
      end
      if states[BB][1]=="lastcolortheme" then
        retval, filename= reaper.GetUserFileNameForRead("", "Open Color Theme", "")
        if retval==true then
          reaper.OpenColorThemeFile(filename)
        end        
      end  
      if states[BB][1]=="globautmoverride" then
        temp2,CCC=reaper.GetUserInputs("Global Automation Override(  -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass)", 1, "New Mode,extrawidth=350", "")
        oldpos=reaper.GetCursorPosition()
        if temp2==true and tonumber(CCC)~=nil then
            reaper.SetGlobalAutomationOverride(tonumber(CCC))
        end        
      end
  end
  
  if gfx.mouse_cap&1==0 and gfx.mouse_cap&2==0 then clicked=false end
    gfx.update()
    reaper.defer(main)
  elseif altered=="(altered)" then
    local B
    if quest~=false then
      B=reaper.MB("Do you want to save the current state-list?","Inspector: Save state-list?", 3)
      Lt=gfx.getchar()
      if B==2 and Lt==-1 then gfx.init("Ultraschall State Inspector", 900, 520) reaper.defer(main) end
    end
    if B==6 then SaveStateCollection() end
  end
end

--old_slot=reaper.GetExtState("Ultraschall State-Inspector", "Old Slot")
retval, old_slot = reaper.BR_Win32_GetPrivateProfileString("Ultraschall State-Inspector", "Old Slot", slotnumber, InspectorIni_File)
old_slot=tonumber(old_slot)
if old_slot==nil then old_slot=0 end
LoadSlot(tonumber(old_slot), false)
main()

function atexit()
  boolean=reaper.BR_Win32_WritePrivateProfileString("Ultraschall State-Inspector", "Old Slot", slotnumber, InspectorIni_File)
  --reaper.SetExtState("Ultraschall State-Inspector", "Old Slot", slotnumber, true)
end

reaper.atexit(atexit)
