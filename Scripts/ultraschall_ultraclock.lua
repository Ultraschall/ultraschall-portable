--[[
################################################################################
#
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

-- Ultraschall 5.1.2 - Changelog - Meo-Ada Mespotine
-- * Retina/HiDPI support(requires Ultraschall 4.0 Theme installed or a theme with a line:
--    "layout_dpi_translate  'Ultraschall 2 TCP'    1.74  'Ultraschall 2 TCP Retina'"
--   included, so the clock automatically knows, if your device is Retina/HiDPI-ready.)
-- * Date moved to the right
-- * WriteCenteredText() renamed to WriteAlignedText() has now more options that align text to right or left as well
--    Parameters:
--       text - the text to display
--       color - the color in which to display
--       font - the font-style in which to display
--       size - the size of the font
--       y - the y-position of the text
--       offset - nil or 0, center text
--              1, aligned left
--              2, aligned right
--              3, aligned right of center
--              4, aligned left of center

-- * Show remaining ProjectLength added to context-menu
-- * Show next/previous marker/projectstart/projectend/region and (remaining) time since/til the marker
-- * Show Projectlength added
-- * Show Time-selection start/end/length added
-- * when Clock has keyboard-focus, set keyboard-context to Arrange View, so keystrokes work
--        improvement compared to earlier version, due new features in Reaper's API
-- * includes now a visible settings-button which shows the same menu, as rightclick, but gives a better clue, THAT there are settings
-- * various bugfixes
-- * highlighting ui-elements when hovering above them including changing the mouse-cursor to signal "click here"
-- * screen reader support
-- * keyboard navigation(run action "Focus ULTRASCHALL Clock(Ultraschall) to unlock this; when focusing another window, keyboard navigation will be turned off, until refocused by the action.


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
isnewvalue, filename, section, cmdid = reaper.get_action_context()

-- hole GUI Library

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

if reaper.osara_outputMessage==nil then
  function reaper.osara_outputMessage()
  end
end

Date_Length={0,0,0,0} -- initialize variable

function setColor (r,g,b)
  gfx.set(r,g,b)
end


local function roundrect(x, y, w, h, r, antialias, fill)

  local aa = antialias or 1
  fill = fill or 0

  if fill == 0 or false then
    gfx.roundrect(x, y, w, h, r, aa)
  elseif h >= 2 * r then

    -- Corners
    gfx.circle(x + r, y + r, r, 1, aa)      -- top-left
    gfx.circle(x + w - r, y + r, r, 1, aa)    -- top-right
    gfx.circle(x + w - r, y + h - r, r , 1, aa)  -- bottom-right
    gfx.circle(x + r, y + h - r, r, 1, aa)    -- bottom-left

    -- Ends
    gfx.rect(x, y + r, r, h - r * 2)
    gfx.rect(x + w - r, y + r, r + 1, h - r * 2)

    -- Body + sides
    gfx.rect(x + r, y, w - r * 2, h + 1)

  else

    r = h / 2 - 1

    -- Ends
    gfx.circle(x + r, y + r, r, 1, aa)
    gfx.circle(x + w - r, y + r, r, 1, aa)

    -- Body
    gfx.rect(x + r, y, w - r * 2, h)

  end

end


function count_all_warnings() -- zähle die Arten von Soundchecks aus
  
  event_count = ultraschall.EventManager_CountRegisteredEvents()
  EventIdentifier=ultraschall.EventManager_GetAllEventIdentifier()
  --event_count=1
  active_warning_count = 0
  paused_warning_count = 0
  passed_warning_count = 0

  --print_update("")
  for i = 1, event_count do

-- old code,can be removed, if soundcheck works fine...
--    local EventIdentifier = ""
--    EventIdentifier, EventName, CallerScriptIdentifier, CheckAllXSeconds, CheckForXSeconds, StartActionsOnceDuringTrue, EventPaused, CheckFunction, NumberOfActions, Actions = ultraschall.EventManager_EnumerateEvents(i)
--    A=reaper.GetExtState("ultraschall_eventmanager", "EventIdentifier")
--    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier)

-- new code, that shall replace the old code, as this here is much faster
    local EventPaused = ultraschall.EventManager_GetEventPausedState(i)
    
    
    last_state, last_statechange_precise_time = ultraschall.EventManager_GetLastCheckfunctionState2(EventIdentifier[i])

    if last_state == true and EventPaused ~= true then -- es ist eine Warnung und sie steht nicht auf ignored
      active_warning_count = active_warning_count +1
    elseif EventPaused == true then
      paused_warning_count = paused_warning_count + 1
    end

  end
  passed_warning_count = event_count - active_warning_count - paused_warning_count
  --]]
  
  return active_warning_count, paused_warning_count, passed_warning_count
end


function GetProjectLength()
  if reaper.GetPlayState()&4==4 and reaper.GetProjectLength()<reaper.GetPlayPosition() then
    return reaper.GetPlayPosition()
  else
    return reaper.GetProjectLength()
  end
end
-- Retina Management
-- Get DPI
retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

if dpi=="512" then
  gfx.ext_retina=1
  retina_mod = 1
else
  gfx.ext_retina=0
  retina_mod = 0.5
end


-- Choose the right graphics and scaling and position of the settings-button
if gfx.ext_retina==1 then
  zahnradbutton_unclicked=gfx.loadimg(1000, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Ultraclock/Settings_Retina.png") -- the zahnradbutton itself
  zahnradbutton_clicked=gfx.loadimg(1001, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Ultraclock/Settings_active_Retina.png") -- the zahnradbutton itself
else
  zahnradbutton_unclicked=gfx.loadimg(1000, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Ultraclock/Settings.png") -- the zahnradbutton itself
  zahnradbutton_clicked=gfx.loadimg(1001, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Ultraclock/Settings_active.png") -- the zahnradbutton itself
end

zahnradbutton_x, zahnradbutton_y=gfx.getimgdim(1000) -- get the dimensions of the zahnradbutton
zahnradscale=.7       -- drawing-scale of the zahnradbutton
zahnradbutton_posx=10 -- x-position of the zahnradbutton
zahnradbutton_posy=1  -- y-position of the zahnradbutton


function copy(obj, seen)
  --copy an array
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function Init()
  -- Initializes the UltraClock

  width,height=400,400 -- size of the window
  refresh= 0.5 --in seconds

  --STD Settings
  -- The settings for the 5 lines of displayed messages
  -- add one to the for-loop and a
  --   txt_line[idx]={ ... } - line to add another line of text
  -- the parameters are: y = the relative y-position of the line.
  --                     size = the relative font-size
  -- these parameters will be fitted to the current size of the UltraClock automatically
  --
  -- Important: y-position>1 might be displayed outside of the window!
  txt_line={}
  for i=1,7 do txt_line[i]={} end -- create 2d array for 4 lines of text
  txt_line[2]={y=0.05, size=0.25}    -- current date
  txt_line[1]={y=0.05 , size=0.25}   -- current time
  txt_line[3]={y=0.11, size=0.16}  -- current playstate
  txt_line[4]={y=0.17, size=0.9}  -- current position

  txt_line[7]={y=0.485, size=0.16}     -- time-selection-text
  txt_line[8]={y=0.55, size=0.25}  -- time-selection

  txt_line[9]={y=0.69, size=0.16}  -- project-length-text
  txt_line[10]={y=0.5, size=0.16} -- project-length

  txt_line[5]={y=0.79, size=0.16}  -- markernames
  txt_line[6]={y=0.86, size=0.25}   -- marker positions

  if reaper.GetOS()=="Win64" or reaper.GetOS()=="Win32" then
    txt_line[11]={y=0.99, size=22 * retina_mod}   -- Soundcheck
  else
    txt_line[11]={y=0.99, size=21 * retina_mod}   -- Soundcheck
  end

  txt_line_preset={} for i=1,7 do txt_line_preset[i]=copy(txt_line) end --copy STD Setting to all presets

  --edit needed settings in presets
  -- RTC - RealTimeClock
  -- TC - TimeCode
  -- date - the current date
  txt_line_preset[1][1].y=-100000 --only RTC, center

  txt_line_preset[2][3].y=0.3  --Status and TC only
  txt_line_preset[2][4].y=0.41

  txt_line_preset[4][2].y=-100000 --date only
  txt_line_preset[4][2].size=0.8

  txt_line_preset[5][1].y=-100000 --date + RTC
  txt_line_preset[5][2].y=0.26 --date only

  txt_line_preset[6][2].y=0.2 --date and TC
  txt_line_preset[6][3].y=0.45
  txt_line_preset[6][4].y=0.56
  txt_line_preset[6][2].size=0.8

  --set font depending on os

  operationSystem = reaper.GetOS()

  if string.match(operationSystem, "OS") then -- es ist ein Mac System
    clockfont="Helvetica" clockfont_bold="Helvetica"
    font_divisor=3.2 --window height / font_divisor = fontsize
  elseif string.match(operationSystem, "Win") then
    clockfont="Arial" clockfont_bold="Arial"
    font_divisor=2.8 --window height / font_divisor = fontsize
  elseif string.match(operationSystem, "Other") then
    clockfont="LiberationSans" clockfont_bold="LiberationSans"
    font_divisor=3.2
  end

  -- get the last docked-state and selected preset from the ultraschall.ini
  preset = ultraschall.GetUSExternalState("ultraschall_clock", "preset")
  docked = ultraschall.GetUSExternalState("ultraschall_clock", "docked")

  if type(preset)~="string" or preset==nil then preset=3 else preset=tonumber(preset) end
  if docked=="false" then docked=false else docked=true end


  --INIT Menu Items
  uc_menu={} for i=1,10 do uc_menu[i]={} end --create 2d array for 6 menu entries

  uc_menu[1]={text="Show LUFS (Master)"    , checked= (preset&1==1)}
  uc_menu[2]={text="Show Realtime", checked= (preset&2==2)}
  uc_menu[3]={text="Show Timecode", checked= (preset&4==4)}

  uc_menu[4]={text="Show Remaining Project Time"    , checked= (preset&8==8)}
  uc_menu[5]={text="Show Time-Selection"    , checked= (preset&16==16)}
  uc_menu[6]={text="Show Project Length"    , checked= (preset&32==32)}
  uc_menu[7]={text="Show Remaining Time until next Marker/Region/Projectend", checked= (preset&64==64)}

  uc_menu[8]={text="", checked=false} -- separator
  uc_menu[9]={text="Dock Dashboard window to Docker", checked=docked}
  uc_menu[10]={text="Close Window",checked=false}
end

function InitGFX()
  gfx.clear=0x333333 --background color
  reaper.SetToggleCommandState(section, cmdid, 1)
  local retval, hwnd = ultraschall.GFX_Init("Dashboard", width, height)
  gfx.init("Dashboard",width,height,false) --create window
  if docked then d=1 else d=0 end

-- Ralf: Das könnte das Problem sein, dass er versucht in Dock4 zu docken.
--       Stattdessen dockt er
--          im Setup-View in den rechten Docker, wo die ProjectBay im Storyboard Modus ist.
--          im Edit-View im TopDocker über der Maintoolbar
--          im Storyboardmodus im gleichen Docker, wie die ProjectBay
--       Der ist vielleicht im Screenset nicht vorgesehen?

  if ultraschall.GetUSExternalState("ultraschall_gui", "view") == "record" then
    dock_id = 4
  else
    dock_id = 5
  end

  gfx.dock( d + 256 * dock_id) -- dock it do docker 4 (&1=docked)
  gfx.update()
  reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work
  return hwnd
end

function showmenu(trigger)
  local menu_string=""
  local i=1
  for i=1,#uc_menu do
    if uc_menu[i].checked==true then menu_string=menu_string.."!" end
    menu_string=menu_string..uc_menu[i].text.."|"
  end
  if trigger==nil then gfx.x, gfx.y= gfx.mouse_x, gfx.mouse_y else gfx.x=zahnradbutton_posx+10 gfx.y=zahnradbutton_posx+10 end
  local ret=gfx.showmenu(menu_string)
  local ret2=ret

  if ret>0 then -- a line was clicked
    if ret>7 then ret2=ret+1 end -- separator does not have an id ...
    if uc_menu[ret2].checked~=nil then
      uc_menu[ret2].checked=not uc_menu[ret2].checked
      preset=0
      for i=1,7 do
        if uc_menu[i].checked then preset=preset+2^(i-1) -- build preset from menu
        end
      end
    end
  end

  return ret
end

function WriteAlignedText(text, color, font, size, y, offset, fixed, x_offset, style1, style2, style3, highlight, focused) -- if y<0 then center horizontally
  -- text - the text to display
  -- color - the color in which to display
  -- font - the font-style in which to display
  -- size - the size of the font
  -- y - the y-position of the text

  -- offset - nil or 0, center text
  --          1, aligned left
  --          2, aligned right
  --          3, aligned right of center
  --          4, aligned left of center
  -- style1, style2 and style3:         
  -- 0, no style
  -- 1, bold
  -- 2, italic
  -- 3, non anti-alias
  -- 4, outline
  -- 5, drop-shadow
  -- 6, underline
  -- 7, negative
  -- 8, 90Â° counter-clockwise
  -- 9, 90Â° clockwise
  --
  -- highlight - the value to add to the color, when highlighting the text(negative is allowed) -1.0 to 1.0
  -- focus - true, draws a focus-rectangle around the text
  fontsize_fixed = fixed or 0
  if type(offset)~="number" then offset=0 end
  
  if x_offset==nil then x_offset=0 end
  if style1==nil then style1=0 end
  if style2==nil then style2=0 end
  if style3==nil then style3=0 end
  local styles={66,73,77,79,83,85,86,89,90}
  styles[0]=98
  
  local style=styles[style1]<<8
  style=style+styles[style2]<<8
  style=style+styles[style3]<<8
  
  gfx.setfont(1, font, size, style) -- it's all bold, anyway
  
  local w, h=gfx.measurestr(text)
  if y<0 then y=(gfx.h-h)/2 end -- center if y<0
  if offset==nil or offset==0 then gfx.x=(gfx.w-w)/2+offset
  elseif offset==1 then gfx.x=0
  elseif offset==2 then gfx.x=gfx.w-gfx.measurestr(text)
  elseif offset==3 then gfx.x=gfx.w/2
  elseif offset==4 then gfx.x=(gfx.w/2)-gfx.measurestr(text)
  end
  local x=gfx.x
  
  gfx.x=gfx.x+x_offset*gfx.measurechar(32)
  gfx.y=y
  local tw, th=gfx.measurestr(text)
  gfx.set(0.4)
  if focused==true then
    gfx.rect(gfx.x, gfx.y, tw, th, 0)
  end
  local r,g,b=reaper.ColorFromNative(color)
  gfx.r=r/255--(color & 0xff0000) / 0xffffff
  gfx.g=g/255--(color & 0x00ff00) / 0xffff
  gfx.b=b/255--(color & 0x0000ff) / 0xff
  if highlight~=nil then
    gfx.r=gfx.r+highlight
    gfx.g=gfx.g+highlight
    gfx.b=gfx.b+highlight
  end
  gfx.drawstr(text)

  return x, y, w, h
end

function get_position(integer)
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if playstate & 1==1 and (integer==nil or integer==0) then return reaper.GetPlayPosition()
    elseif (playstate & 1==1 or playstate &2==2) and integer==1 then return (reaper.GetProjectLength()-reaper.GetPlayPosition())*(-1)
    elseif (playstate==0) and integer==1 then return (reaper.GetProjectLength()-reaper.GetCursorPosition())*(-1)
    elseif (playstate & 1==1 or playstate &2==2) and integer==2 then
      elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next= ultraschall.GetClosestGoToPoints("1", reaper.GetPlayPosition(), false, true, true)
      return elementposition_prev-reaper.GetPlayPosition(), elementtype_prev, elementposition_next-reaper.GetPlayPosition(), elementtype_next
    elseif playstate==0 and integer==2 then
      elementposition_prev, elementtype_prev, number_prev, elementposition_next, elementtype_next, number_next= ultraschall.GetClosestGoToPoints("1", reaper.GetCursorPosition(), false, true, true)
      return elementposition_prev-reaper.GetCursorPosition(), elementtype_prev, elementposition_next-reaper.GetCursorPosition(), elementtype_next
    else return reaper.GetCursorPosition() end
end

function formattimestr(pos)
  if pos==nil then return end
  if pos<0 then pos=pos*-1
    pos=reaper.format_timestr_len(pos, "", 0, 5)
    pos="-"..pos
  else
    pos=reaper.format_timestr_len(pos, "", 0, 5)
  end
  return pos:match("(.*)%:")
end

function openWindowLUFS()

  local mastertrack = reaper.GetMasterTrack(0)
  local lufs_count = 0

  for i = 0, reaper.TrackFX_GetCount(mastertrack) do
    retval, fxName = reaper.TrackFX_GetFXName(mastertrack, i, "")
    if fxName:match("LUFS.*Loudness.*Meter.*") then
      lufs_count = lufs_count +1
    end
  end

  if lufs_count == 0 then -- es gibt noch keinen LUFS-Effekt auf dem Master, also hinzufügen. 
    added = ultraschall.LUFS_Metering_AddEffect(true)

  end

  ultraschall.LUFS_Metering_ShowEffect() -- zeige den Effekt
  local tr = reaper.GetMasterTrack(0)
  local index=-1
  for i=0, reaper.TrackFX_GetCount(tr)-1 do
    local retval, fx=reaper.TrackFX_GetFXName(tr, i)
    if fx:match("LUFS.*Loudness.*Meter.*") then
      index=i
    end
  end
  if index~=-1 then
    --local retval = reaper.TrackFX_GetEnabled(tr, index)
    reaper.TrackFX_SetEnabled(tr, index, true)
  end
    
end


function drawClock()
  if drawn_already_in_this_loop==true then return end
  drawn_already_in_this_loop=true
  gfx.x=zahnradbutton_posx
  gfx.y=zahnradbutton_posy
  zahnrad_w, zahnrad_h=gfx.getimgdim(zahnradbutton_unclicked)
  if focused==1 then
    gfx.set(0.4)
    gfx.rect(gfx.x, gfx.y, (zahnrad_w*(zahnradscale)), (zahnrad_h*(zahnradscale)), 0)
  end
  gfx.blit(zahnradbutton_unclicked, zahnradscale, 0)
  if add_color2~=0 then
    gfx.mode=1
    gfx.a=0.2
    gfx.blit(zahnradbutton_unclicked, zahnradscale, 0)
    gfx.a=1
    gfx.mode=0
  end
  if uc_menu[3].checked then -- get Timecode/Status
    playstate=reaper.GetPlayState()
    if reaper.GetSetRepeat(-1)==1 then repeat_txt=" (REPEAT)" else repeat_txt="" end
    if playstate == 1 then
      if repeat_txt~="" then txt_color=0x15729d else txt_color=0x2092c7 end
      status="PLAYING"..repeat_txt --play
      elseif playstate == 5 then txt_color=0xf24949 status="RECORDING" --record
      elseif playstate == 2 then
        if repeat_txt~="" then txt_color=0xa86010 else txt_color=0xd17814 end
        status="PAUSED"..repeat_txt --play/pause
      elseif playstate == 6 then txt_color=0xff6b4d status="REC/PAUSED" --record/pause
      elseif playstate == 0 then txt_color=0xeeeeee status="STOPPED" --record/pause
      else txt_color=0xb3b3b3 status=""
    end
    --A=uc_menu[5].checked
    if uc_menu[4].checked==true then 
      pos=get_position(1)//1
      projectpos_msg3="-"
    else
      pos=get_position()//1
      projectpos_msg3=""
    end

    pos=formattimestr(pos)
  end


  -- calculate fontsize and textpositions depending on aspect ratio of window
  if gfx.w/gfx.h < 4/3 then -- if narrower than 4:3 add empty space on top and bottom
     fsize=gfx.w/4*3/font_divisor
     border=(gfx.h-gfx.w/4*3)/2 + (15 * retina_mod)
     height=gfx.w/4*3 - (65 * retina_mod)
   else
    fsize=gfx.h/font_divisor
    border=40 * retina_mod
    height=gfx.h -(120 * retina_mod)
   end

  preset=0
  for i=1, 8 do
    if uc_menu[i].checked then
      preset=preset+2^(i-1)
    end
  end
  if preset~=oldpreset then
    AAA=ultraschall.SetUSExternalState("ultraschall_clock", "preset", preset)     --save state preset
  end

  oldpreset=preset

  if preset==0 or preset==8.0 then
    WriteAlignedText("All displays are turned off :-(",0xbbbbbb, clockfont_bold, fsize/4,-1)
  end

  --write text
  -- Date
  if uc_menu[1].checked then

    LUFS_integral, target, dB_Gain, FX_active = ultraschall.LUFS_Metering_GetValues()

    if LUFS_integral > target-1 and LUFS_integral <= target+1 then -- Grün
      date_color = 0x15ee15
    elseif LUFS_integral > target+1 and LUFS_integral <= target+2 then -- Gelb
      date_color = 0xeeee15
    elseif LUFS_integral > target+2 then -- Rot
      date_color = 0xee5599
    else
      date_color = 0x2092c7 -- Blau
    end
  
    -- roundrect(17*retina_mod, txt_line[2].y*height+border-2, 14*retina_mod, 30*retina_mod, 5*retina_mod, 5, 1)
    -- if retina_mod == 0.5 then
    --   roundrect(19*retina_mod, txt_line[2].y*height+border-2, 10*retina_mod, 26*retina_mod, 0, 0, 1)
    -- end
    
    
    Date = tostring(LUFS_integral).." LUFS"
    LUFS_msg=""
    --print_update(Date, FX_active, LUFS_integral, ultraschall.LUFS_Metering_GetValues())
    local tr = reaper.GetMasterTrack(0)
    local index=-1
    for i=0, reaper.TrackFX_GetCount(tr)-1 do
      local retval, fx=reaper.TrackFX_GetFXName(tr, i)
      if fx:match("LUFS.*Loudness.*Meter.*") then
        index=i
      end
    end
    if index==-1 or reaper.TrackFX_GetEnabled(tr, index)==false then 
      Date = "Analyze LUFS" 
      date_color = 0x777777
    else
      LUFS_msg=tostring(LUFS_integral).." LUFS."
    end
  else
    Date=""
  end
  
  
  --Date_Length=gfx.measurestr(Date)
  
  -- RealTime
  if uc_menu[2].checked then
    time=os.date("%H:%M:%S")
  else
    time=""
  end

  if Date~="" then
    local style=0
    local offset=" "
    local y_offset=0
    local x_offset=0
    local resizer=0
    if Date:match("Analyze")~=nil then style=6 offset="" date_color=reaper.ColorToNative(31, 145, 199) x_offset=1 resizer=1 y_offset=0 end
    date_position_y = txt_line[2].y*height+border-y_offset
    gfx.setfont(1, "Arial", txt_line[2].size,0)
    Date_Length={WriteAlignedText(offset..Date, date_color, clockfont_bold, txt_line[2].size * fsize-resizer, date_position_y,1,0, x_offset, style, nil, nil, add_color3, focused==2)} -- print realtime hh:mm:ss
    end
  if time~="" then
    Time_Length={WriteAlignedText(time.." ",0xb3b3b3, clockfont_bold, txt_line[1].size * fsize,txt_line[1].y*height+border,2, nil, nil, nil, nil, nil, nil, focused==3)} -- print realtime hh:mm:ss
    time_msg=format_time_for_tts(time, true)
  else
    Time_Length={0,0,0,0}
    time_msg=""
  end


  -- Soundcheck


  soundcheck_y_offset = 70 * retina_mod

  -- gfx.roundrect(50, 50, 100, 50, 10, 1)
  
  if focused==8 then
    gfx.set(0.4)
    gfx.rect(9*retina_mod, gfx.h-(soundcheck_y_offset - 5*retina_mod), (gfx.w - 14*retina_mod), 48*retina_mod, 0)
  end
  setColor(0.27+add_color,0.27+add_color,0.27+add_color)
  roundrect(10*retina_mod, gfx.h -(soundcheck_y_offset - 6*retina_mod), (gfx.w - 20*retina_mod), 41*retina_mod, 10*retina_mod, 1, 1)

  active_warning_count, paused_warning_count, passed_warning_count = count_all_warnings()

  WriteAlignedText("   Soundcheck",0x777777, clockfont_bold, txt_line[11].size , gfx.h -(soundcheck_y_offset + 24*retina_mod),1) -- print

  -----------
  -- passed
  -----------

  if passed_warning_count > 0 then
    setColor(0.15,0.95,0.15)
  else
    setColor(0.5,0.5,0.5)
  end

    roundrect(17*retina_mod, gfx.h -(soundcheck_y_offset - 12*retina_mod), 14*retina_mod, 30*retina_mod, 5*retina_mod, 5, 1)
    if retina_mod == 0.5 then
      roundrect(19*retina_mod, gfx.h -(soundcheck_y_offset - 14*retina_mod), 10*retina_mod, 26*retina_mod, 0, 0, 1)
    end

    -- print (gfx.w)

    if gfx.w > 480 * retina_mod then
      WriteAlignedText("       PASSED: "..passed_warning_count.."",0xcccccc, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),1,1)
    else
      WriteAlignedText("        "..passed_warning_count.."",0xcccccc, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),1,1)
    end

  ------------------
  -- PAUSED
  ------------------

  if paused_warning_count > 0 then
    setColor(0.95,0.95,0.15)
    sc_txt_color = 0xcccccc
  else
    setColor(0.5,0.5,0.5)
    sc_txt_color = 0x888888
  end

  if gfx.w > 480 * retina_mod then
    roundrect(gfx.w/2-79* retina_mod, gfx.h -(soundcheck_y_offset - 12*retina_mod), 14*retina_mod, 30*retina_mod, 5*retina_mod, 1, 1)

    if retina_mod == 0.5 then
      roundrect(gfx.w/2-79* retina_mod , gfx.h -(soundcheck_y_offset - 14*retina_mod), 10*retina_mod, 26*retina_mod, 0, 1, 1)
    end

    WriteAlignedText("    IGNORED: "..paused_warning_count.."  ",sc_txt_color, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),0)
  else
    roundrect(gfx.w/2-15* retina_mod, gfx.h -(soundcheck_y_offset - 12*retina_mod), 14*retina_mod, 30*retina_mod, 5*retina_mod, 1, 1)
    if retina_mod == 0.5 then
      roundrect(gfx.w/2-16* retina_mod , gfx.h -(soundcheck_y_offset - 14*retina_mod), 10*retina_mod, 26*retina_mod, 0, 0, 1)
    end
    WriteAlignedText("       "..paused_warning_count.."",sc_txt_color, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),0)
  end
  -- if active_warning_count > 0 then

  -------------
  -- WARNING
  -------------


  if active_warning_count > 0 then
    setColor(0.95,0.15,0.15)
    sc_txt_color = 0xcccccc
  else
    setColor(0.5,0.5,0.5)
    sc_txt_color = 0x888888
  end


  if gfx.w > 480 * retina_mod then
    roundrect(gfx.w - 166 * retina_mod , gfx.h -(soundcheck_y_offset - 12*retina_mod), 14*retina_mod, 30*retina_mod, 5*retina_mod, 1, 1)
    if retina_mod == 0.5 then
      roundrect(gfx.w - 164 * retina_mod , gfx.h -(soundcheck_y_offset - 14*retina_mod), 12*retina_mod, 26*retina_mod, 0, 0, 1)
    end
    WriteAlignedText("WARNING: "..active_warning_count.."   ",sc_txt_color, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),2)
  else
    roundrect(gfx.w - 59 * retina_mod , gfx.h -(soundcheck_y_offset - 12*retina_mod), 14*retina_mod, 30*retina_mod, 5*retina_mod, 1, 1)
    if retina_mod == 0.5 then
      roundrect(gfx.w - 57 * retina_mod , gfx.h -(soundcheck_y_offset - 14*retina_mod), 12*retina_mod, 26*retina_mod, 0, 0, 1)
    end
    WriteAlignedText(" "..active_warning_count.."   ",sc_txt_color, clockfont_bold, txt_line[11].size, gfx.h -(soundcheck_y_offset - 18*retina_mod),2)
  end

  -- end --


  -- Projecttime and Play/RecState
  if uc_menu[3].checked then
    if uc_menu[4].checked==true and reaper.GetProjectLength()<get_position() then plus="+" else plus="" end
    checkpos=pos:match("(.-):")
    if checkpos:len()==1 then addzero="0" else addzero="" end
    WriteAlignedText(status,txt_color, clockfont_bold, txt_line[3].size * fsize ,txt_line[3].y*height+border, nil, nil, nil, nil, nil, nil, add_color4) -- print Status (Pause/Play...)
    time_x, time_y, time_w, time_h = WriteAlignedText(plus..addzero..pos, txt_color, clockfont_bold, txt_line[4].size * fsize,txt_line[4].y*height+border, nil, nil, nil, nil, nil, nil, add_color4, focused==4) --print timecode in h:mm:ss format
    
    projectpos_msg2=plus..addzero..format_time_for_tts(pos)
    projectpos_msg=plus..addzero..format_time_for_tts(pos)
    if pos:sub(1,1)=="-" then plus="-" end
  else
    time_x, time_y, time_w, time_h=0,0,0,0
    projectpos_msg2=""
    projectpos_msg=""
  end

  -- Time Selection
  if uc_menu[5].checked then
    start, end_loop = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    length=end_loop-start
    if length > 0 then
      Time_Sel0={WriteAlignedText("Time Selection",0xffbb00, clockfont_bold, txt_line[7].size * fsize, txt_line[7].y*height+border,0)} -- print date
      start=reaper.format_timestr_len(start, "", 0, 5):match("(.*):")
      end_loop=reaper.format_timestr_len(end_loop, "", 0, 5):match("(.*):")
      length=reaper.format_timestr_len(length, "", 0, 5):match("(.*):")
      Time_Sel={WriteAlignedText(start.."     [".. length.."]     "..end_loop,0xffbb00, clockfont_bold, txt_line[8].size * fsize, txt_line[8].y*height+border,0)} -- print date
      timesel_start=format_time_for_tts(start)
      timesel_length=format_time_for_tts(length)
      timesel_end=format_time_for_tts(end_loop)
      if focused==5 then
        gfx.set(0.4)
        gfx.rect(0, Time_Sel0[2], gfx.w, Time_Sel0[4]+Time_Sel[4],0)
      end
    else
      -- WriteAlignedText("Time Selection",0xaaaa00, clockfont_bold, txt_line[7].size * fsize, txt_line[7].y*height+border,0) -- print date
      -- WriteAlignedText("-:--:-- < (".. "0:00:00"..") > -:--:--",0xaaaa44, clockfont_bold, txt_line[8].size * fsize, txt_line[8].y*height+border,0) -- print date
      Time_Sel={0,0,0,0} -- print date
      timesel_start=start
      timesel_length=length
      timesel_end=end_loop
    end
  else
    Time_Sel={0,0,0,0} -- print date
    timesel_start=start
    timesel_length=length
    timesel_end=end_loop
  end

  -- Project Length
  if uc_menu[6].checked then
    Project_Duration={WriteAlignedText("Project Duration: "..reaper.format_timestr_len(GetProjectLength(),"", 0,5):match("(.*):"),0xb6b6bb, clockfont_bold, txt_line[9].size * fsize, txt_line[9].y*height+border,0, nil, nil, nil, nil, nil, nil, focused==6)} -- print date
    project_dur_msg=format_time_for_tts(reaper.format_timestr_len(GetProjectLength(),"", 0,5):match("(.*):"))
    -- WriteAlignedText(reaper.format_timestr_len(GetProjectLength(),"", 0,5):match("(.*):"),0xb6b6bb, clockfont_bold, txt_line[10].size * fsize, txt_line[10].y*height+border,0) -- print date
  else
    Project_Duration={0,0,0,0}
    project_dur_msg=""
  end

  -- Next/Previous Marker/Region
  if uc_menu[7].checked then
    prevtime, prevelm, nexttime, nextelm = get_position(2)
    prevelm1=prevelm
    nextelm1=nextelm
    prevelm=string.gsub(prevelm,"Marker:","M:")
    nextelm=string.gsub(nextelm,"Marker:","M:")
    prevelm=string.gsub(prevelm,"Region_.-:","R:")
    nextelm=string.gsub(nextelm,"Region_.-:","R:")

    _,marker_y, _, marker_h = WriteAlignedText("  "..prevelm:sub(1,22),0xb6b6bb, clockfont_bold, txt_line[5].size * fsize ,txt_line[5].y*height+border,1) -- print previous marker/region/projectstart/end
    WriteAlignedText(nextelm:sub(1,20).."  ",0xb6b6bb, clockfont_bold, txt_line[5].size * fsize ,txt_line[5].y*height+border,2) -- print next marker/region/projectstart/end

    prevtime=formattimestr(prevtime*(-1))
    nexttime=formattimestr(nexttime*(-1))
    string.gsub(prevelm,"Region_beg:","Reg: ")
    string.gsub(prevelm,"Region_end:","Reg: ")
    _,marker_y2,_,marker_h2 = WriteAlignedText(" "..prevtime,0xb6b6bb, clockfont_bold, txt_line[6].size * fsize ,txt_line[6].y*height+border,1) -- print date
    WriteAlignedText("[Marker]",0xb6b6bb, clockfont_bold, txt_line[6].size * fsize ,txt_line[6].y*height+border,0) -- print date
    WriteAlignedText(nexttime.." ",0xb6b6bb, clockfont_bold, txt_line[6].size * fsize ,txt_line[6].y*height+border,2) -- print date
    
    marker_h=marker_h+marker_h2
    marker_prev=prevelm1.." "..format_time_for_tts(prevtime)
    marker_next=nextelm1.." "..format_time_for_tts(nexttime)
    if focused==7 then
      gfx.set(0.4)
      gfx.rect(0,marker_y, gfx.w, marker_h, 0)
    end
  else
    marker_y=0
    marker_h=0
    marker_prev=""
    marker_next=""
  end
  gfx.update()
  lasttime=reaper.time_precise()
  gfx.set(0.4,0.4,0.4,0.8)
  gfx.set(1)
end


function MainLoop()
  if reaper.GetExtState("UltraClock", "FocusMe")=="true" then
    reaper.JS_Window_SetFocus(clock_hwnd)
    focus_window=true
    reaper.osara_outputMessage("Ultraclock focused. Tab and Shift Tab to go through ui-elements, space to click them. Escape to return to arrangeview.")
    reaper.SetExtState("UltraClock", "FocusMe", "", false)
  end
  focus_me()
  local retval, msg=checkhover()
  if msg~=oldmsg then
    reaper.osara_outputMessage(msg)
  end
  oldmsg=msg
  if retval==true then gfx.setcursor(0x7f89, "") else gfx.setcursor(0, "") end
  if reaper.time_precise() > lasttime+refresh or gfx.w~=lastw or gfx.h~=lasth then drawClock()  end

  if Triggered==true then
    local ret=showmenu(menuposition)
    menuposition=nil

    if ret==8 then -- /undock
      dock_state=gfx.dock(-1)
      if  dock_state & 1 == 1 then gfx.dock(dock_state -1) else gfx.dock(dock_state+1) end
    elseif ret==9 then exit_clock()
    end

    if gfx.dock(-1)&1==1 then is_docked="true" else is_docked="false" end

    AAA2=ultraschall.SetUSExternalState("ultraschall_clock", "docked", is_docked)  --save state docked
    --ultraschall.ShowErrorMessagesInReascriptConsole()
  end
  
  if Triggered==nil then
    if gfx.mouse_cap & 2 == 2 then -- right mousecklick
      Triggered=true
    elseif (gfx.mouse_cap & 1 ==1) and gfx.mouse_x>=zahnradbutton_posx and gfx.mouse_x<=zahnradbutton_posx+(zahnradbutton_x*zahnradscale) and gfx.mouse_y>=zahnradbutton_posy and gfx.mouse_y<zahnradbutton_posy+(zahnradbutton_y*zahnradscale) then --left mouseclick
      Triggered=true
      menuposition=1
      gfx.x=zahnradbutton_posx
      gfx.y=zahnradbutton_posy
      gfx.blit(zahnradbutton_clicked, zahnradscale, 0)
    elseif (gfx.mouse_cap & 1 ==1) and gfx.mouse_y>gfx.h-(80*retina_mod) then -- Linksklick auf Soundcheck-Footer
      id = reaper.NamedCommandLookup("_Ultraschall_Soundcheck_Startgui")
      reaper.Main_OnCommand(id,0)
    elseif (gfx.mouse_cap &1 ==1) and gfx.mouse_y>time_y and gfx.mouse_y<time_y+time_h and Triggered2==nil then
      Triggered2=true
      if uc_menu[4].checked==true then uc_menu[4].checked=false else uc_menu[4].checked=true end
      gfx.update()
      
      drawClock()
    elseif uc_menu[1].checked then  -- Das LUFS-Meter ist aktiviert
      lufs_pos_y=Date_Length[2]
      lufs_pos_h=Date_Length[4]
      if (gfx.mouse_cap & 1 ==1) and gfx.mouse_y < date_position_y+30 * retina_mod and gfx.mouse_y > date_position_y-10*retina_mod and gfx.mouse_x<(Date_Length[3]) then -- Linksklick auf LUFS-Bereich
        openWindowLUFS()
      end
    end
  else
    Triggered=nil
  end
  if gfx.mouse_cap==0 then
    Triggered2=nil
  end

--  view = ultraschall.GetUSExternalState("ultraschall_gui", "view") -- get the actual view

  --loop if GUI is NOT closed and VIEW is Recording
  KeyVegas=gfx.getchar()
  if KeyVegas~=-1 then
    lastw, lasth=gfx.w, gfx.h
    clock_focus_state=gfx.getchar(65536)&2
    if clock_focus_state~=0 then
      if focus_window==false then
        focussss=reaper.time_precise()
        reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work
      end
    else
      focused=0
      focus_window=false
    end
    --
    gfx.update()
    --ALABAMASONG=GetProjectLength()
    drawn_already_in_this_loop=false
    reaper.defer(MainLoop)
  end
end

function exit_clock()
  gfx.quit()
  reaper.SetToggleCommandState(section, cmdid, 0)
end

function checkhover()
--gfx.rect(Date_Length[1], Date_Length[2], Date_Length[3], Date_Length[4], 1)
--gfx.rect(0,marker_y, gfx.w, marker_h,1)
  if gfx.mouse_x>=Project_Duration[1] and 
     gfx.mouse_y>Project_Duration[2] and 
     gfx.mouse_x<=Project_Duration[1]+Project_Duration[3] and 
     gfx.mouse_y<=Project_Duration[2]+Project_Duration[4] then
    return false, "Project Duration. "..project_dur_msg
  end

  if gfx.mouse_x>=0 and 
     gfx.mouse_y>marker_y and 
     gfx.mouse_x<=gfx.w and 
     gfx.mouse_y<=marker_y+marker_h then
    return false, "Markers. Previous "..marker_prev..". Next "..marker_next.."."
  end
  
  if gfx.mouse_x>=Time_Sel[1] and 
     gfx.mouse_y>Time_Sel[2] and 
     gfx.mouse_x<=Time_Sel[1]+Time_Sel[3] and 
     gfx.mouse_y<=Time_Sel[2]+Time_Sel[4] then
    return false, "Time_selection. Start "..timesel_start..". End "..timesel_end..". Length "..timesel_length
  end
  
  if gfx.mouse_x>=Time_Length[1] and 
     gfx.mouse_y>Time_Length[2] and 
     gfx.mouse_x<=Time_Length[1]+Time_Length[3] and 
     gfx.mouse_y<=Time_Length[2]+Time_Length[4] then
    return false, "Current time. "..time_msg.."." 
  end
  
  local soundcheck_y_offset = 70 * retina_mod
  if gfx.mouse_x>10*retina_mod and gfx.mouse_y>=gfx.h-(soundcheck_y_offset - 6*retina_mod) and
    gfx.mouse_x<gfx.w-20*retina_mod and gfx.mouse_y<gfx.h-(soundcheck_y_offset - 6*retina_mod)+41*retina_mod then
    -- soundcheck highlighter
     add_color=0.05
     gfx.setcursor(0x7f89, "")
     refresh_me()
     return true, "Soundcheck."
  end
  
  local tw, th=gfx.getimgdim(zahnradbutton_clicked)
  if gfx.mouse_x>zahnradbutton_posx and gfx.mouse_y>=zahnradbutton_posy and
    gfx.mouse_x<zahnradbutton_posx+tw*zahnradscale and gfx.mouse_y<zahnradbutton_posy+th*zahnradscale then
    -- zahnrad highlighter
     add_color2=0.1
     refresh_me()
     return true, "Ultraclock Settings."
  end
  
  if gfx.mouse_x>0 and gfx.mouse_x<gfx.w and gfx.mouse_y>time_y and gfx.mouse_y<time_y+time_h then
    -- projecttime-toggle
    if reaper.GetPlayState()~=0 then add_color4=0.05 else add_color4=-0.2 end
    refresh_me()
    local remaining=" currently"
    if projectpos_msg3=="-" then 
      remaining=" remaining"
    end
    return true, "Project position "..projectpos_msg:sub(1,-2)..remaining.."."
  end
  
  if gfx.mouse_y > lufs_pos_y and 
     gfx.mouse_y < lufs_pos_y+lufs_pos_h and 
     gfx.mouse_x<(Date_Length[3]) then -- Linksklick auf LUFS-Bereich
    add_color3=0.1
    refresh_me()
    return true, "Analyze LUFS. "..LUFS_msg
  end
  
  add_color=0
  add_color2=0
  add_color3=0
  add_color4=0
  refresh_me()
  return false, ""
end

function format_time_for_tts(time, format_time)
  if format_time==true then return string.gsub(time, ":", " ") end
  
  hour, minute, seconds=time:match("(.-):(.-):(.*)")
  hour=tonumber(hour)
  minute=tonumber(minute)
  seconds=tonumber(seconds)
  if hour==0 then hour="" elseif hour==1 then hour="1 hour " else hour=hour.." hours " end
  if minute==0 and hour=="" then minute="" elseif minute==1 then minute="1 minute " else minute=minute.." minutes " end
  if seconds==1 then seconds="1 second " else seconds=seconds.. " seconds." end
  return hour..minute..seconds
end

function focus_me()
  Key=KeyVegas
  tts=false
  if gfx.mouse_cap==1 then focused=0 end
  if gfx.mouse_cap==0 and Key==9 then focused=focused+1 tts=true add=1 end
  if gfx.mouse_cap==8 and Key==9 then focused=focused-1 tts=true add=-1 end
  if focused~=0 and focused<1 then focused=8 end
  if focused==2 and uc_menu[1].checked==false then focused=focused+add end
  if focused==3 and uc_menu[2].checked==false then focused=focused+add end
  if focused==4 and uc_menu[3].checked==false then focused=focused+add end
  if focused==5 and uc_menu[5].checked==false then focused=focused+add end
  if focused==6 and uc_menu[6].checked==false then focused=focused+add end
  if focused==7 and uc_menu[7].checked==false then focused=focused+add end
  --if focused==8 and uc_menu[7].checked==false then focused=focused+1 end
  if focused>8 then focused=1 end
  if Key==27 then focus=0 reaper.SetCursorContext(1) end
  
  if Key==32 or Key==13 then
    if focused==1 then showmenu(1) 
    elseif focused==2 then
      openWindowLUFS()
      tts=true
    elseif focused==3 then
      tts=true
    elseif focused==4 then
      if uc_menu[4].checked==true then uc_menu[4].checked=false projectpos_msg3="-" else uc_menu[4].checked=true projectpos_msg3="" end
      tts=true
    elseif focused==5 then
      tts=true
    elseif focused==6 then
      tts=true
    elseif focused==7 then
      tts=true
    elseif focused==8 then 
      id = reaper.NamedCommandLookup("_Ultraschall_Soundcheck_Startgui")
      reaper.Main_OnCommand(id,0)
    end
  end
  if tts==true then
    if focused==1 then 
      reaper.osara_outputMessage("Settings-Menu. Button. Space to choose settings.")
    elseif focused==2 then
      reaper.osara_outputMessage("Analyze LUFS. Label. "..LUFS_msg.." Hit space to measure LUFS")
    elseif focused==3 then
      reaper.osara_outputMessage("Current time. Label. "..time_msg..".")
    elseif focused==4 then
      if projectpos_msg3=="-" then
        reaper.osara_outputMessage("Project position. Label. "..projectpos_msg2:sub(1,-2).." until project end. Space to toggle projecttime between current and remaining time.")
      else
        reaper.osara_outputMessage("Project position. Label. "..projectpos_msg2:sub(1,-2).." remaining until project end. Space to toggle projecttime between current and remaining time.")
      end
    elseif focused==5 then
      reaper.osara_outputMessage("Time_selection. Label. Start "..timesel_start..". End "..timesel_end..". Length "..timesel_length)
    elseif focused==6 then
      reaper.osara_outputMessage("Project Duration. Label. "..project_dur_msg)
    elseif focused==7 then
      reaper.osara_outputMessage("Markers. Label. Previous "..marker_prev..". Next "..marker_next..".")
    elseif focused==8 then
      reaper.osara_outputMessage("Soundcheck. Button. Passed warning "..passed_warning_count..". Ignored warning "..paused_warning_count..". Active Warnings "..active_warning_count..". Hit Space to open Soundcheck Window.")
    end
  end
end

focused=0

function refresh_me()
  if refresh_restart==nil then
    
  end
  lasttime=lasttime-refresh
end

reaper.atexit(exit_clock)
Init()
clock_hwnd=InitGFX()
lasttime=reaper.time_precise()-1
reaper.defer(MainLoop)
lufs_pos_y=0
lufs_pos_h=0
add_color=0
add_color4=0
time_x, time_y, time_w, time_h = 0,0,0,0
focus_window=false
Time_Length={0,0,0,0}
Time_Sel={0,0,0,0}
timesel_start=""
timesel_length=""
timesel_end=""
marker_y=0
marker_h=0
marker_prev=""
marker_next=""
LUFS_msg=""
Project_Duration={0,0,0,0} -- print date
project_dur_msg=""
