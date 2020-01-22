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
 
-- Ultraschall 4.0 - Changelog - Meo Mespotine 
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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Retina Management
-- Get DPI
retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)

if dpi=="512" then
  gfx.ext_retina=1
else
  gfx.ext_retina=0
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
zahnradscale=.9       -- drawing-scale of the zahnradbutton
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
  txt_line[2]={y=0.0, size=0.28}    -- current date
  txt_line[1]={y=0.10 , size=0.28}   -- current time
  txt_line[3]={y=0.17, size=0.27}  -- current playstate
  txt_line[4]={y=0.24, size=0.75}  -- current position
  
  txt_line[7]={y=0.515, size=0.20}     -- time-selection-text
  txt_line[8]={y=0.58, size=0.25}  -- time-selection
 
  txt_line[9]={y=0.68, size=0.20}  -- project-length-text
  txt_line[10]={y=0.745, size=0.25} -- project-length
 
  txt_line[5]={y=0.845, size=0.20}  -- markernames
  txt_line[6]={y=0.915, size=0.25}   -- marker positions  

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
  if reaper.GetOS()=="OSX64" or reaper.GetOS()=="OSX32" then
    clockfont="Helvetica" clockfont_bold="Helvetica Bold"
    font_divisor=3.2 --window height / font_divisor = fontsize
  elseif reaper.GetOS()=="Win64" or reaper.GetOS()=="Win32" then
    clockfont="Arial" clockfont_bold="Arial"
    font_divisor=2.8 --window height / font_divisor = fontsize
  else clockfont="Arial" clockfont_bold="Arial"
    font_divisor=3.2
  end
  
  -- get the last docked-state and selected preset from the ultraschall.ini
  preset = ultraschall.GetUSExternalState("ultraschall_clock", "preset")
  docked = ultraschall.GetUSExternalState("ultraschall_clock", "docked")

  if type(preset)~="string" or preset==nil then preset=3 else preset=tonumber(preset) end
  if docked=="false" then docked=false else docked=true end
  
  
  --INIT Menu Items
  uc_menu={} for i=1,10 do uc_menu[i]={} end --create 2d array for 6 menu entries

  uc_menu[1]={text="Show Date"    , checked= (preset&1==1)}
  uc_menu[2]={text="Show Realtime", checked= (preset&2==2)}
  uc_menu[3]={text="Show Timecode", checked= (preset&4==4)}
  
  uc_menu[4]={text="Show Remaining Projecttime"    , checked= (preset&8==8)}
  uc_menu[5]={text="Show Time-Selection"    , checked= (preset&16==16)}
  uc_menu[6]={text="Show Project Length"    , checked= (preset&32==32)}
  uc_menu[7]={text="Show Remaining Time until next Marker/Region/Projectend", checked= (preset&64==64)}
  
  uc_menu[8]={text="", checked=false} -- separator
  uc_menu[9]={text="Dock Ultraclock window to Docker", checked=docked}
  uc_menu[10]={text="Close Window",checked=false}
end

function InitGFX()
  gfx.clear=0x333333 --background color
  gfx.init("Ultraclock",width,height,false) --create window
  if docked then d=1 else d=0 end

-- Ralf: Das könnte das Problem sein, dass er versucht in Dock4 zu docken.
--       Stattdessen dockt er 
--          im Setup-View in den rechten Docker, wo die ProjectBay im Storyboard Modus ist.
--          im Edit-View im TopDocker über der Maintoolbar
--          im Storyboardmodus im gleichen Docker, wie die ProjectBay
--       Der ist vielleicht im Screenset nicht vorgesehen?
  gfx.dock( d + 256*4) -- dock it do docker 4 (&1=docked)
  gfx.update()
  reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work
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

function WriteAlignedText(text, color, font, size, y, offset) -- if y<0 then center horizontally
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
  
  if type(offset)~="number" then offset=0 end
  gfx.r=(color & 0xff0000) / 0xffffff
  gfx.g=(color & 0x00ff00) / 0xffff
  gfx.b=(color & 0x0000ff) / 0xff  
  gfx.setfont(1, font, size)
  local w, h=gfx.measurestr(text)
  if y<0 then y=(gfx.h-h)/2 end -- center if y<0
  if offset==nil or offset==0 then gfx.x=(gfx.w-w)/2+offset
  elseif offset==1 then gfx.x=0
  elseif offset==2 then gfx.x=gfx.w-gfx.measurestr(text)
  elseif offset==3 then gfx.x=gfx.w/2
  elseif offset==4 then gfx.x=(gfx.w/2)-gfx.measurestr(text)
  end
  gfx.y=y 
  gfx.drawstr(text)
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

function drawClock()
  gfx.x=zahnradbutton_posx
  gfx.y=zahnradbutton_posy
  gfx.blit(zahnradbutton_unclicked, zahnradscale, 0)
  if uc_menu[3].checked then -- get Timecode/Status
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
      elseif playstate == 0 then txt_color=0xeeeeee status="STOP" --record/pause  
      else txt_color=0xb3b3b3 status=""
    end
    A=uc_menu[5].checked
    if uc_menu[4].checked==true then pos=get_position(1)//1 
    else 
      pos=get_position()//1 
    end

    pos=formattimestr(pos)
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
    WriteAlignedText("all displays are turned off :-(",0xbbbbbb, clockfont_bold, fsize/4,-1)
  end
  
  --write text
  -- Date
  if uc_menu[1].checked then
    date=os.date("%d.%m.%Y")
  else
    date=""
  end
  
  -- RealTime
  if uc_menu[2].checked then
    time=os.date("%H:%M:%S")
  else
    time=""
  end
  
  if date~="" then
    WriteAlignedText(date.."    ",0xb3b3b3, clockfont_bold, txt_line[2].size * fsize,txt_line[2].y*height+border,2) -- print realtime hh:mm:ss
  end
  if time~="" then
    WriteAlignedText(time.."    ",0xb3b3b3, clockfont_bold, txt_line[1].size * fsize,txt_line[1].y*height+border,2) -- print realtime hh:mm:ss
  end
  
  -- Projecttime and Play/RecState
  if uc_menu[3].checked then
    if uc_menu[4].checked==true and reaper.GetProjectLength()<get_position() then plus="+" else plus="" end
    checkpos=pos:match("(.-):")
    if checkpos:len()==1 then addzero="0" else addzero="" end
    WriteAlignedText(""..status,txt_color, clockfont_bold, txt_line[3].size * fsize ,txt_line[3].y*height+border) -- print Status (Pause/Play...)
    WriteAlignedText(plus..addzero..pos, txt_color, clockfont_bold, txt_line[4].size * fsize,txt_line[4].y*height+border) --print timecode in h:mm:ss format
  end

  -- Time Selection    
  if uc_menu[5].checked then
    start, end_loop = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    length=end_loop-start
    if length > 0 then
      WriteAlignedText("Time Selection",0xdddd00, clockfont_bold, txt_line[7].size * fsize, txt_line[7].y*height+border,0) -- print date
      start=reaper.format_timestr_len(start, "", 0, 5):match("(.*):")
      end_loop=reaper.format_timestr_len(end_loop, "", 0, 5):match("(.*):")
      length=reaper.format_timestr_len(length, "", 0, 5):match("(.*):")
      WriteAlignedText(start.." < (".. length..") > "..end_loop,0xdddd44, clockfont_bold, txt_line[8].size * fsize, txt_line[8].y*height+border,0) -- print date
    else
      WriteAlignedText("Time Selection",0xaaaa00, clockfont_bold, txt_line[7].size * fsize, txt_line[7].y*height+border,0) -- print date
      WriteAlignedText("-:--:-- < (".. "0:00:00"..") > -:--:--",0xaaaa44, clockfont_bold, txt_line[8].size * fsize, txt_line[8].y*height+border,0) -- print date
    end
  end
  
  -- Project Length
  if uc_menu[6].checked then
    WriteAlignedText("Project Duration",0xb6b6bb, clockfont_bold, txt_line[9].size * fsize, txt_line[9].y*height+border,0) -- print date
    WriteAlignedText(reaper.format_timestr_len(reaper.GetProjectLength(),"", 0,5):match("(.*):"),0xb6b6bb, clockfont_bold, txt_line[10].size * fsize, txt_line[10].y*height+border,0) -- print date
  end
  
  -- Next/Previous Marker/Region
  if uc_menu[7].checked then
    prevtime, prevelm, nexttime, nextelm = get_position(2)
    
    prevelm=string.gsub(prevelm,"Marker:","M:")
    nextelm=string.gsub(nextelm,"Marker:","M:")
    prevelm=string.gsub(prevelm,"Region_.-:","R:")
    nextelm=string.gsub(nextelm,"Region_.-:","R:")

    WriteAlignedText(prevelm:sub(1,22).."    ",0xb6b6bb, clockfont_bold, txt_line[5].size * fsize ,txt_line[5].y*height+border,4) -- print previous marker/region/projectstart/end
    WriteAlignedText("      "..nextelm:sub(1,20),0xb6b6bb, clockfont_bold, txt_line[5].size * fsize ,txt_line[5].y*height+border,3) -- print next marker/region/projectstart/end    
  
    prevtime=formattimestr(prevtime*(-1))
    nexttime=formattimestr(nexttime*(-1))
    string.gsub(prevelm,"Region_beg:","Reg: ")
    string.gsub(prevelm,"Region_end:","Reg: ")
    WriteAlignedText(prevtime.." < Marker > "..nexttime,0xb6b6bb, clockfont_bold, txt_line[6].size * fsize ,txt_line[6].y*height+border,0) -- print date
  end  
  gfx.update()
  lasttime=reaper.time_precise()
  gfx.set(0.4,0.4,0.4,0.8)
  gfx.set(1)
end


function MainLoop()
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
    ultraschall.ShowErrorMessagesInReascriptConsole()
  end
  
  if Triggered==nil then
    if gfx.mouse_cap & 2 == 2 then
      Triggered=true
    elseif (gfx.mouse_cap & 1 ==1) and gfx.mouse_x>=zahnradbutton_posx and gfx.mouse_x<=zahnradbutton_posx+(zahnradbutton_x*zahnradscale) and gfx.mouse_y>=zahnradbutton_posy and gfx.mouse_y<zahnradbutton_posy+(zahnradbutton_y*zahnradscale) then --right mouseclick
      Triggered=true
      menuposition=1
      gfx.x=zahnradbutton_posx
      gfx.y=zahnradbutton_posy
      gfx.blit(zahnradbutton_clicked, zahnradscale, 0)
    end
  else
    Triggered=nil
  end
  
--  view = ultraschall.GetUSExternalState("ultraschall_gui", "view") -- get the actual view

  --loop if GUI is NOT closed and VIEW is Recording
  KeyVegas=gfx.getchar()
  if KeyVegas~=-1 then 
    lastw, lasth=gfx.w, gfx.h
    clock_focus_state=gfx.getchar(65536)&2
    if clock_focus_state~=0 then     
      reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work 
    end
    gfx.update()
    reaper.defer(MainLoop)
  end
end

function exit_clock()
  gfx.quit()
end

reaper.atexit(exit_clock)
Init()
InitGFX()
lasttime=reaper.time_precise()-1
reaper.defer(MainLoop)
