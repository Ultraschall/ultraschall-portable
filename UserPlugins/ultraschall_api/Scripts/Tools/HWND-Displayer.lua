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

-- written by Meo Mespotine mespotine.de February 2019
-- for the ultraschall.fm-project
-- MIT-licensed

-- opens an overlay-window, which displays and draws the position of child-HWNDs of the currently focused window
--      use up/down to browse through them
--      left makes the overlay-window small; right makes it fullscreen
--      use p to prevent the forcing of the focus onto the windowlayer; c to continue the force-focus
--      +/- adjust the alpha-channel of the transparency of the overlay-window
-- good for analysing the HWND-structure of Reaper

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

pause=false
scleft, sctop, scright, scbottom = reaper.my_getViewport(0,0,0,0,0,0,0,0,true)

HWND={}
HWND[0]=reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())
HWND[1]=reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())

retvak, OwnHWND=ultraschall.GFX_Init("Tudelu", 1270, 770,0,0,0)

Maxcount=1

alpha=0.7

function updatelist()
  Cretval, Clist = reaper.JS_Window_ListAllChild(reaper.JS_Window_GetFocus())
  

  retval2, list = reaper.JS_Window_ListAllChild(HWND[1])
  HWND[0]=reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())
  HWND[1]=reaper.JS_Window_GetParent(reaper.JS_Window_GetFocus())

TITLE=reaper.JS_Window_GetTitle(HWND[1])

Maxcount=1
retval, list = reaper.JS_Window_ListAllChild(HWND[1])

count, count_individual_values = ultraschall.CSV2IndividualLinesAsArray(list)

for i=1, count do
  if count_individual_values[i]~="" then
    HWND[i+1]=reaper.JS_Window_HandleFromAddress(count_individual_values[i])
    Maxcount=Maxcount+1
  else
    break
  end
end
  retval, left, top, right, bottom = reaper.JS_Window_GetRect(HWND[1])

--  if reaper.GetOS():match("Win")~=nil then 
--    reaper.JS_Window_SetOpacity(OwnHWND, "COLOR", 0x000000)
--  else
    reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha)
--  end
  if pause==false then
    reaper.JS_Window_SetForeground(OwnHWND)
  end
  counter=1
end

counter=1

updatelist()

function main()
  -- has the focused window changed?
  HWND[0]=reaper.JS_Window_GetFocus()
  if HWND[0]~=HWND[1] and HWND[0]~=OwnHWND then B="updated" updatelist() else B="unupdated" end

  -- change the selected hwnd by up and down-keys
  A=gfx.getchar()
  if A>0 then reaper.CF_SetClipboard(A) end
  if A==30064.0 then counter=counter-1 if counter<1 then counter=1 end end
  if A==1685026670.0 then counter=counter+1 if counter>Maxcount then counter=Maxcount end end
  if A==1818584692.0 then reaper.JS_Window_SetPosition(OwnHWND, 1,1,343,220) end
  if A==1919379572.0 then reaper.JS_Window_SetPosition(OwnHWND, scleft, sctop, scright, scbottom) end
  if A==112 then pause=true end
  if A==99  then pause=false end
  if A==43 then alpha=alpha+0.1 reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha) end
  if A==45  then alpha=alpha-0.1 reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha) end
  
  -- get hwnd-properties to draw them on top of the screen
  retval, left, top, right, bottom = reaper.JS_Window_GetRect(HWND[counter])
  title=reaper.JS_Window_GetTitle(HWND[counter])
  CLASS=reaper.JS_Window_GetClassName(HWND[1], "")
  
  -- draw boundary boxes
  gfx.set(1,0,1,0.9)
  gfx.rect(left-1-5, top-20-1, right-left, bottom-top,0)
  gfx.set(1,1,1,0.3)
  gfx.rect(left-5, top-20, right-left, bottom-top,0)
  gfx.set(1,1,1,0.1)
  gfx.rect(left+1-5, top-20+1, right-left, bottom-top,0)
  gfx.set(1,1,0,1)
  gfx.line(left-5, top-20, right, bottom-20, aa)
  gfx.set(1,0,0,1)
  gfx.line(left+1-5, top+1-20, right, bottom-20, aa)

  -- draw hwnd-title
  gfx.x=0
  gfx.y=0
--  xxx,yyy=gfx.measurestr("Parent HWND: "..TITLE.."\nChild HWND: "..title.."("..counter.."/"..Maxcount..")\n\nUp/Down - switch Child HWND\nLeft - make this overlaywindow small\nRight - make overlaywindow big\n\np - pauses focusing on this display-window\nc - continues focusing on this display window\n\n- and + - alter the alpha of the window")
  gfx.set(0.1,0.1,0.1,0.8)
--  gfx.rect(0,0,xxx,yyy,1)
  gfx.set(1)
  gfx.setfont(1,"Times",15,66)
  gfx.drawstr("Focused HWND: "..TITLE.."\nChild HWND: "..title.."("..counter.."/"..Maxcount..")\nClass: "..CLASS.."\n\n    Up/Down - switch Child HWND\n    Left - make this overlaywindow small\n    Right - make this overlaywindow big\n\n    p - pauses force-focus on this overlay-window\n    c - continue force-focus on this overlay-window\n\n    - and + - alter the alpha of the window")

  gfx.update()
  
  -- if ESC hasn't been used, continue, else quit
  if A~=27.0 and A~=-1 then reaper.defer(main) else gfx.quit() end
end

main()
