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

-- written by Meo Mespotine mespotine.de 2nd of June 2019
-- for the ultraschall.fm-project
-- MIT-licensed

-- opens an overlay-window, which displays and draws the position of child-HWNDs of the currently focused window
--      use up/down to browse through them
--      left makes the overlay-window small; right makes it fullscreen
--      f - switches to the currently focused window
--      a - autofocuses on the currently focused window
--      p - pinpoints the window underneath the mousecursor
--      h - toggles help
--      PgUp/PgDn - browse through childHWNDs in steps of 10
--      Home/End - first or last childHWND
--      Backspace - go to parent hwnd
--      Enter - switch to current childHWND as mainHWND, whose childHWNDs you want to browse through
--      Ctrl+C - copies hwnd-information into clipboard
--      +/- adjust the alpha-channel of the transparency of the overlay-window
--      Esc - escapes this app
-- good for analysing the HWND-structure of Reaper

ultraschall_override=true

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

pause=false
autofocus=false
pinpoint=false
help=true
scleft, sctop, scright, scbottom = reaper.my_getViewport(0,0,0,0,0,0,0,0,true)
Parent=""
HWND={}
hwnd=reaper.JS_Window_GetFocus()
if reaper.JS_Window_GetParent(hwnd)~=nil then hwnd=reaper.JS_Window_GetParent(hwnd) end
Focus=hwnd
OldFocus=hwnd

retval, OwnHWND=ultraschall.GFX_Init("Tudelu", scright-10, scbottom-30,0,0,0)
gfx.setfont(1, "Arial", 20, 0)

Maxcount=0
alpha=0.7
Counter=1
reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha)
Oretval, Oleft, Otop, Oright, Obottom = reaper.JS_Window_GetRect(OwnHWND)
Oretval2, Oleft2, Otop2, Oright2, Obottom2 = reaper.JS_Window_GetClientRect(OwnHWND)
--Offset=Obottom2-Obottom
Offset=Otop2-Otop
Offsetx=Oleft2-Oleft
if Offset<0 then Offset=Offset*-1 end



function updatelist(hwnd)
--  if reaper.JS_Window_GetParent(hwnd)==nil then return end
  if hwnd==nil or reaper.JS_Window_ListAllChild(hwnd)==nil then return end
  HWND={}
  HWND["Parent"]=reaper.JS_Window_GetParent(hwnd)
  HWND[0]=hwnd
  Counter=0
  Maxcount=0
  if reaper.JS_Window_ListAllChild(hwnd)<1 then return end
  Cretval, Clist = reaper.JS_Window_ListAllChild(hwnd)
  Clist=Clist..","
  local counter=0
  for k in string.gmatch(Clist, "(.-),") do
    counter=counter+1
    HWND[counter]=reaper.JS_Window_HandleFromAddress(k)
  end
  Maxcount=counter
  Counter=1
end

updatelist(hwnd)
--gfx.quit()

function main()
  if ultraschall.IsValidHWND(hwnd)==false then hwnd=reaper.GetMainHwnd() end
  Focus=reaper.JS_Window_GetFocus()
  if Focus==OwnHWND or Focus==nil then
    Focus=OldFocus
  end
  if OldFocus~=Focus then
    if autofocus==true then 
      hwnd=Focus
      updatelist(Focus)
    end
  end  
  OldFocus=Focus
  if pinpoint==true then
    newhwnd=reaper.JS_Window_FromPoint(reaper.GetMousePosition())
    if newhwnd~=nil then
      hwnd=newhwnd
      updatelist(hwnd)
    end
  end
  
  
  Key=gfx.getchar()
  if Key==8 then hwnd2=reaper.JS_Window_GetParent(hwnd) if hwnd2~=nil then hwnd=hwnd2 updatelist(hwnd) end end
  --if Key~=0 then print3(Key) end
  if Maxcount>0 and Key==1685026670.0 then Counter=Counter+1 if Counter>Maxcount then Counter=Maxcount end end
  if Maxcount>0 and Key==30064.0 then Counter=Counter-1 if Counter<0 then Counter=0 end end
  if Key==13 then hwnd=HWND[Counter] updatelist(HWND[Counter]) end
  if Key==102.0 and ultraschall.IsValidHWND(reaper.JS_Window_GetParent(Focus))==true then hwnd=reaper.JS_Window_GetParent(Focus) updatelist(reaper.JS_Window_GetParent(Focus)) end
  if Counter==0 then Parent="(Parent)" else Parent="" end
  if Key==43.0 then alpha=alpha+0.02 if alpha>1 then alpha=1 end reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha) end
  if Key==45.0 then alpha=alpha-0.02 if alpha<0 then alpha=0 end reaper.JS_Window_SetOpacity(OwnHWND, "ALPHA", alpha) end
  if Key==27.0 then quitit=true gfx.quit() end
  if Key==1818584692.0 then reaper.JS_Window_Resize(OwnHWND, 300, 500) end
  if Key==1919379572.0 then reaper.JS_Window_SetPosition(OwnHWND, 0,0,scright, scbottom) end
  if Key==6647396.0 then Counter=Maxcount end
  if Key==1752132965.0 then Counter=0 end
  if Key==1885824110.0 then Counter=Counter+10 if Counter>Maxcount then Counter=Maxcount end end
  if Key==1885828464.0 then Counter=Counter-10 if Counter<0 then Counter=0 end end
  if Key==104.0 then if help~=true then help=true else help=false end end
  if Key==97.0 then if autofocus~=true then autofocus=true pinpoint=false else autofocus=false end end
  if Key==112.0 then if pinpoint~=true then pinpoint=true autofocus=false else pinpoint=false end end
  
  
  
--  if Maxcount>0 then 
    ID=reaper.JS_Window_GetLongPtr(HWND[Counter], "ID")
    if ID~=nil then ID=math.floor(reaper.JS_Window_AddressFromHandle(ID)) else ID="" end
    ChildClass=reaper.JS_Window_GetClassName(HWND[Counter], "")
    if ChildClass==nil then ChildClass="" end
      retval, left, top, right, bottom = reaper.JS_Window_GetRect(HWND[Counter])
      left, top = gfx.screentoclient(left, top+Offset)
      right, bottom = gfx.screentoclient(right, bottom+Offset)
      gfx.set(0,0,0,0.8)
      gfx.rect(1+left-Offsetx,1+top-Offset,right-left,bottom-top,0)
      gfx.set(1,1,1,0.8)
      gfx.rect(left-Offsetx,top-Offset,right-left,bottom-top,0)
      gfx.set(1,1,0,0.8)
      gfx.line(left-Offsetx,top-Offset,right-Offsetx,bottom-Offset,0)
      gfx.set(1,1,1,0.8)
      gfx.x=1
      gfx.y=1
      
      Title0=reaper.JS_Window_GetTitle(hwnd)
      Title=reaper.JS_Window_GetTitle(HWND[Counter])
      
      ParentID=reaper.JS_Window_GetLongPtr(hwnd, "ID")
      if ParentID~=nil then ParentID=math.floor(reaper.JS_Window_AddressFromHandle(ParentID)) else ParentID="" end
      if Title0:len()>100 then Title0=Title0:sub(1,256).." ... " end
      if Title:len()>100 then Title=Title:sub(1,256).." ... " end
      
      gfx.drawstr(Title0.." - ParentID: "..ParentID..
                                  " \nCounter: "..Counter.."/"..Maxcount.." - "..
                                  Title..Parent..
                                  " \nChildClass:"..ChildClass..
                                  " \nID:"..ID..
                                  " \nHas Children:"..
                                  reaper.JS_Window_ListAllChild(HWND[Counter]))
      if Key==3.0 then print3(Title0..
                                  " \nCounter: "..Counter.."/"..Maxcount.." - "..
                                  Title..Parent..
                                  " \nChildClass:"..ChildClass..
                                  " \nID:"..ID..
                                  " \nHas Children:"..
                                  reaper.JS_Window_ListAllChild(HWND[Counter])) end
      if help~=false then
        gfx.x=1
        gfx.y=150
        gfx.drawstr([[How to use it:
        h - toggle this help
        
        Up/Down - change Child-HWND
        Enter - browse childHWNDs of currently selected childHWND
        BackSpace - change to parentHWND
        
        F - browse childHWNDs of keyboard-focused window
        
        +/- - change opacity of this overlay window
        left/right - minimize/maximize this overlay window
        
        PgUp/PgDn - change up/down 10 Child-HWNDs
        Home/End - first/last ChildHwnd
        
        Ctrl+C - copies hwnd-information to clipboard
        
        a(]]..tostring(autofocus)..[[) - toggles autofocus, which automatically uses the currently focused window
        p(]]..tostring(pinpoint)..[[) - shows the window underneath the mouse-cursor
        
        Esc - quit hwnd-inspector
  ]])
     end
      
 --[[     print_update(reaper.JS_Window_GetTitle(hwnd)..
                                  " \nCounter: "..Counter.."/"..Maxcount.." - "..
                                  reaper.JS_Window_GetTitle(HWND[Counter])..Parent..
                                  " \nChildClass:"..ChildClass..
                                  " \nID:"..ID..
                                  " \nHas Children:"..
                                  reaper.JS_Window_ListAllChild(HWND[Counter])) 
                                  --]]
                                  
  --end
  gfx.update()
  if quitit~=true and Key~=-1 then reaper.defer(main) end
end

main()
--]]

--gfx.quit()
