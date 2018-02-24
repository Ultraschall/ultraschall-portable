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
 
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "ultraschall_helper_functions.lua")

--Ultraschall ultraclock alpha 0.9

function copy(obj, seen) --copy an array
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function Init()
  width,height=400,300
  refresh= 0.5 --in seconds
  
  --STD Settings
  txt_line={} for i=1,4 do txt_line[i]={} end -- create 2d array for 4 lines of text
  txt_line[1]={y=0.1 , size=1.0}
  txt_line[2]={y=0.0, size=0.3}
  txt_line[3]={y=0.51, size=0.3}
  txt_line[4]={y=0.62, size=1.0}

  txt_line_preset={} for i=1,7 do txt_line_preset[i]=copy(txt_line) end --copy STD Setting to all presets

  --edit needed settings in presets
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
  if reaper.GetOS()=="OSX64" or reaper.GetOS()=="OSX32" then
    clockfont="Helvetica" clockfont_bold="Helvetica Bold"
    font_divisor=3.2 --window height / font_divisor = fontsize
  elseif reaper.GetOS()=="Win64" or reaper.GetOS()=="Win32" then
    clockfont="Arial" clockfont_bold="Arial"
    font_divisor=2.8 --window height / font_divisor = fontsize
  else clockfont="Arial" clockfont_bold="Arial"
  end
  
  len, preset = ultraschall.GetUSExternalState("ultraschall_clock", "preset")
  len, docked = ultraschall.GetUSExternalState("ultraschall_clock", "docked")

  if type(preset)~="string" or preset==NIL then preset=3 else preset=tonumber(preset) end
  if docked=="false" then docked=false else docked=true end
  
  
  --INIT Menu Items
  uc_menu={} for i=1,6 do uc_menu[i]={} end --create 2d array for 6 menu entries
--reaper.ShowMessageBox("lalala",tostring(preset),0)

  uc_menu[1]={text="Show Realtime", checked= (preset&1==1)}
  uc_menu[2]={text="Show Timecode", checked= (preset&2==2)}
  uc_menu[3]={text="Show Date"    , checked= (preset&4==4)}
  uc_menu[4]={text="", checked=false} -- separator
  uc_menu[5]={text="Dock Ultraclock window to Docker", checked=docked}
  uc_menu[6]={text="Close Window",checked=false}
end

function InitGFX()
  gfx.clear=0x333333 --background color
  gfx.init("Ultraclock",width,height,false) --create window
  if docked then d=1 else d=0 end
  gfx.dock( d + 256*4) -- dock it do docker 4 (&1=docked)
  gfx.update()
  reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work
end

function showmenu()
  local menu_string=""
  local i=1
  for i=1,#uc_menu do
    if uc_menu[i].checked==true then menu_string=menu_string.."!" end
    menu_string=menu_string..uc_menu[i].text.."|"
  end
  
  gfx.x, gfx.y= gfx.mouse_x, gfx.mouse_y
  local ret=gfx.showmenu(menu_string)
  local ret2=ret
  
  if ret>0 then -- a line was clicked
    if ret>3 then ret2=ret+1 end -- seperator does not have an id ...
    if uc_menu[ret2].checked~=NIL then 
      uc_menu[ret2].checked=not uc_menu[ret2].checked 
      preset=0
      for i=1,3 do 
        if uc_menu[i].checked then preset=preset+2^(i-1) -- build preset from menu
        end
      end
    end
  end
  
  return ret
end

function WriteCenteredText(text, color, font, size, y) -- if y<0 then center horizontaly
  gfx.r=(color & 0xff0000) / 0xffffff
  gfx.g=(color & 0x00ff00) / 0xffff
  gfx.b=(color & 0x0000ff) / 0xff  
  gfx.setfont(1, font, size)
  local w, h=gfx.measurestr(text)
  if y<0 then y=(gfx.h-h)/2 end -- center if y<0
  gfx.x=(gfx.w-w)/2
  gfx.y=y 
  gfx.drawstr(text)
end

function get_position()
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if playstate & 1==1 then return reaper.GetPlayPosition()
    else return reaper.GetCursorPosition() end
end

function drawClock()
  if uc_menu[2].checked then -- get Timecode/Status
    playstate=reaper.GetPlayState()
    if reaper.GetSetRepeat(-1)==1 then repeat_txt=" (REPEAT)" else repeat_txt="" end
    if playstate == 1 then
      if repeat_txt~="" then txt_color=0x15729d else txt_color=0x2092c7 end 
      status="PLAY"..repeat_txt --play
      elseif playstate == 5 then txt_color=0xf24949 status="REC" --record
      elseif playstate == 2 then 
        if repeat_txt~="" then txt_color=0xa86010 else txt_color=0xd17814 end
        status="PAUSE"..repeat_txt --play/pause
      elseif playstate == 6 then txt_color=0xff6b4d status="REC/PAUSE" --record/pause
      elseif playstate == 0 then txt_color=0xb3b3b3 status="STOP" --record/pause  
      else txt_color=0xb3b3b3 status=""
    end
    pos=get_position()//1
    pos=string.format("%02d:%02d:%02d",pos//3600,(pos %3600) // 60,pos % 60)
  end
  
 
  -- calculate fontsize and textpositions depending on aspect ratio of window
  if gfx.w/gfx.h < 4/3 then -- if narrower than 4:3 add empty space on top and bottom
    fsize=gfx.w/4*3/font_divisor
    border=(gfx.h-gfx.w/4*3)/2
    height=gfx.w/4*3
  else  
    fsize=gfx.h/font_divisor
    border=0
    height=gfx.h
  end
  
  preset=0
  for i=1,3 do if uc_menu[i].checked then preset=preset+2^(i-1) end end
  
  if preset==0 then
    WriteCenteredText("all displays are turned off :-(",0xbbbbbb, clockfont_bold, fsize/4,-1)
  end
  
  txt_line=copy(txt_line_preset[preset])
  
  --write text
  if uc_menu[1].checked then
    WriteCenteredText(os.date("%H:%M:%S"),0xb3b3b3, clockfont_bold, txt_line[1].size * fsize,txt_line[1].y*height+border) -- print realtime hh:mm:ss
  end
  
  if uc_menu[3].checked then
    WriteCenteredText(os.date("%d.%m.%Y"),0xb3b3b3, clockfont_bold, txt_line[2].size * fsize ,txt_line[2].y*height+border) -- print date
  end
  
  if uc_menu[2].checked then
    WriteCenteredText(status,txt_color, clockfont_bold, txt_line[3].size * fsize ,txt_line[3].y*height+border) -- print Status (Pause/Play...)
    WriteCenteredText(pos, txt_color, clockfont_bold, txt_line[4].size * fsize,txt_line[4].y*height+border) --print timecode in h:mm:ss format
  end
  
  gfx.update()
  lasttime=reaper.time_precise()
end


function MainLoop()
  if reaper.time_precise() > lasttime+refresh or gfx.w~=lastw or gfx.h~=lasth then drawClock()  end
  
  if gfx.mouse_cap & 2 ==2 then --right mousecklick
    local ret=showmenu()
    if ret==4 then -- dock/undock
      dock_state=gfx.dock(-1)
      if  dock_state & 1 == 1 then gfx.dock(dock_state -1) else gfx.dock(dock_state+1) end
    elseif ret==5 then exit_clock()
    end
    
    if gfx.dock(-1)&1==1 then is_docked="true" else is_docked="false" end
    ultraschall.SetUSExternalState("ultraschall_clock", "preset", preset)     --save state preset
    ultraschall.SetUSExternalState("ultraschall_clock", "docked", is_docked)  --save state docked    

    reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work
  end
  
  count, view = ultraschall.GetUSExternalState("ultraschall_gui", "view") -- get the actual view

  --loop if GUI is NOT closed and VIEW is Recording
  if gfx.getchar() ~= -1 and (view=="record" or gfx.dock(-1)&1==0) then 
    lastw, lasth=gfx.w, gfx.h
    gfx.update()
    reaper.defer(MainLoop)
  end
end

function exit_clock()
  -- if gfx.dock(-1)&1==1 then is_docked="true" else is_docked="false" end
  -- ultraschall.SetUSExternalState("ultraschall_clock", "preset", preset)     --save state preset
  -- ultraschall.SetUSExternalState("ultraschall_clock", "docked", is_docked)  --save state docked
  gfx.quit()
end

reaper.atexit(exit_clock)
Init()
InitGFX()
lasttime=reaper.time_precise()-1
reaper.defer(MainLoop)
