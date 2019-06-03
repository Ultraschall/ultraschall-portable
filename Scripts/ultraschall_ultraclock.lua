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
 
-- Ultraschall 3.2 - Changelog - Meo Mespotine 
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
-- * various bugfixes
 

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--Ultraschall ultraclock alpha 0.9

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
  
  width,height=400,300 -- size of the window
  refresh= 0.5 --in seconds
  
  --STD Settings
  -- The settings for the 5 lines of displayed messages
  -- add one to the for-loop and a 
  --   txt_line[idx]={ ... } - line to add another line of text
  -- the parameters are: y = the relative y-position of the line.
  --                     size = the relative font-size
  -- these parameters will be fitted to the current size of the UltraClock automatically
  txt_line={} 
  for i=1,7 do txt_line[i]={} end -- create 2d array for 4 lines of text
  txt_line[2]={y=0.0, size=0.3}    -- current date
  txt_line[1]={y=0.075 , size=0.8}   -- current time
  txt_line[3]={y=0.33, size=0.27}  -- current playstate
  txt_line[4]={y=0.4, size=0.6}  -- current position
  
 txt_line[7]={y=0.62, size=0.15}     -- time-selection-text
 txt_line[8]={y=0.67, size=0.22}  -- time-selection
 
 txt_line[9]={y=0.76, size=0.15}  -- project-length-text
 txt_line[10]={y=0.81, size=0.2} -- project-length
 
 txt_line[5]={y=0.88, size=0.15}  -- markernames
 txt_line[6]={y=0.93, size=0.2}   -- marker positions  
 
 
 --[[
  0.62 0.67 
  0.76 0.81
  0.90 0.95
  
  txt_line[7]={y=0.76, size=0.15}     -- time-selection-text
  txt_line[8]={y=0.81, size=0.22}  -- time-selection
  
  txt_line[9]={y=0.90, size=0.15}  -- project-length-text
  txt_line[10]={y=0.95, size=0.22} -- project-length
  
  txt_line[5]={y=0.62, size=0.15}  -- markernames
  txt_line[6]={y=0.67, size=0.2}   -- marker positions  
  --]]
  

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
  end
  
  -- get the last docked-state and selected preset from the ultraschall.ini
  preset = ultraschall.GetUSExternalState("ultraschall_clock", "preset")
  docked = ultraschall.GetUSExternalState("ultraschall_clock", "docked")

  if type(preset)~="string" or preset==nil then preset=3 else preset=tonumber(preset) end
  if docked=="false" then docked=false else docked=true end
  
  
  --INIT Menu Items
  uc_menu={} for i=1,10 do uc_menu[i]={} end --create 2d array for 6 menu entries
--reaper.ShowMessageBox("lalala",tostring(preset),0)

  uc_menu[1]={text="Show Realtime", checked= (preset&1==1)}
  uc_menu[2]={text="Show Timecode", checked= (preset&2==2)}
  uc_menu[3]={text="Show Date"    , checked= (preset&4==4)}
  uc_menu[4]={text="Show Remaining Projecttime"    , checked= (preset&8==8)}
  uc_menu[5]={text="Show Remaining Time until next Marker/Region/Projectend", checked= (preset&16==16)}
  uc_menu[6]={text="Show Time-Selection"    , checked= (preset&32==32)}
  uc_menu[7]={text="Show Project Length"    , checked= (preset&64==64)}
  uc_menu[8]={text="", checked=false} -- separator
  uc_menu[9]={text="Dock Ultraclock window to Docker", checked=docked}
  uc_menu[10]={text="Close Window",checked=false}
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
    --print_alt(i,uc_menu[i].text,uc_menu[i].checked)
  end
  gfx.x, gfx.y= gfx.mouse_x, gfx.mouse_y
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
      elseif playstate == 0 then txt_color=0xeeeeee status="STOP" --record/pause  
      else txt_color=0xb3b3b3 status=""
    end
    A=uc_menu[5].checked
    if uc_menu[4].checked==true then pos=get_position(1)//1 
--      uc_menu[2].checked=false
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
--    reaper.ClearConsole()
  for i=1, 8 do 
    if uc_menu[i].checked then 
      preset=preset+2^(i-1) 
    end 
--    reaper.ShowConsoleMsg(i..": "..preset.." "..tostring(uc_menu[i].checked).."\n")
  end
  if preset~=oldpreset then
    AAA=ultraschall.SetUSExternalState("ultraschall_clock", "preset", preset)     --save state preset
  end
  
  oldpreset=preset
  
  
  if preset==0 or preset==8.0 then
    --print_update(preset)
    WriteAlignedText("all displays are turned off :-(",0xbbbbbb, clockfont_bold, fsize/4,-1)
  end
--  txt_line=copy(txt_line_preset[preset])
  
  --write text
  if uc_menu[1].checked then
    WriteAlignedText(os.date("%H:%M:%S"),0xb3b3b3, clockfont_bold, txt_line[1].size * fsize,txt_line[1].y*height+border) -- print realtime hh:mm:ss
  end
  
  if uc_menu[3].checked then
    WriteAlignedText("   "..os.date("%d.%m.%Y").."   ",0xb3b3b3, clockfont_bold, txt_line[2].size * fsize ,txt_line[2].y*height+border, 2) -- print date
  end
  
  if uc_menu[2].checked then
    if uc_menu[4].checked==true and reaper.GetProjectLength()<get_position() then plus="+" else plus="" end
    WriteAlignedText(status,txt_color, clockfont_bold, txt_line[3].size * fsize ,txt_line[3].y*height+border) -- print Status (Pause/Play...)
    WriteAlignedText(plus..pos, txt_color, clockfont_bold, txt_line[4].size * fsize,txt_line[4].y*height+border) --print timecode in h:mm:ss format
  end

  if uc_menu[5].checked then
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
    
  if uc_menu[6].checked then
    WriteAlignedText("Time Selection:",0xdddd00, clockfont_bold, txt_line[7].size * fsize, txt_line[7].y*height+border,0) -- print date
    start, end_loop = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    length=end_loop-start
    start=reaper.format_timestr_len(start, "", 0, 5):match("(.*):")
    end_loop=reaper.format_timestr_len(end_loop, "", 0, 5):match("(.*):")
    length=reaper.format_timestr_len(length, "", 0, 5):match("(.*):")
    WriteAlignedText(start.." < (".. length..") > "..end_loop,0xdddd44, clockfont_bold, txt_line[8].size * fsize, txt_line[8].y*height+border,0) -- print date
  end
  
  if uc_menu[7].checked then
    WriteAlignedText("Project Length:",0xb6b6bb, clockfont_bold, txt_line[9].size * fsize, txt_line[9].y*height+border,0) -- print date
    WriteAlignedText(reaper.format_timestr_len(reaper.GetProjectLength(),"", 0,5):match("(.*):"),0xb6b6bb, clockfont_bold, txt_line[10].size * fsize, txt_line[10].y*height+border,0) -- print date
  end
  
  gfx.update()
  lasttime=reaper.time_precise()
end


function MainLoop()
  if reaper.time_precise() > lasttime+refresh or gfx.w~=lastw or gfx.h~=lasth then drawClock()  end
  
  if gfx.mouse_cap & 2 ==2 then --right mousecklick
    local ret=showmenu()

    if ret==8 then -- /undock
      dock_state=gfx.dock(-1)
      if  dock_state & 1 == 1 then gfx.dock(dock_state -1) else gfx.dock(dock_state+1) end
    elseif ret==9 then exit_clock()
    end
  --if type(ret)=="number" then print_update(ret) end
    
    if gfx.dock(-1)&1==1 then is_docked="true" else is_docked="false" end
    --reaper.ClearConsole()

    AAA2=ultraschall.SetUSExternalState("ultraschall_clock", "docked", is_docked)  --save state docked    
    ultraschall.ShowErrorMessagesInReascriptConsole()
  end
  
  view = ultraschall.GetUSExternalState("ultraschall_gui", "view") -- get the actual view

  --loop if GUI is NOT closed and VIEW is Recording
  if gfx.getchar() ~= -1 and (view=="record" or gfx.dock(-1)&1==0) then 
    lastw, lasth=gfx.w, gfx.h
    clock_focus_state=gfx.getchar(65536)&2
    if clock_focus_state~=0 then     
      reaper.SetCursorContext(1) -- Set Cursor context to the arrange window, so keystrokes work 
    end
    gfx.update()
    
--    reaper.ShowConsoleMsg(preset.."HUH\n")
  --print_update(preset)
    reaper.defer(MainLoop)
  end
end

function exit_clock()
--   if gfx.dock(-1)&1==1 then is_docked="true" else is_docked="false" end
--   ultraschall.SetUSExternalState("ultraschall_clock", "preset", preset)     --save state preset
--   ultraschall.SetUSExternalState("ultraschall_clock", "docked", is_docked)  --save state docked
  gfx.quit()
end

reaper.atexit(exit_clock)
Init()
InitGFX()
lasttime=reaper.time_precise()-1
reaper.defer(MainLoop)
