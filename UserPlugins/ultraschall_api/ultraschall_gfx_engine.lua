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

--------------------------------------
--- ULTRASCHALL - API - GFX-Engine ---
--------------------------------------


if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "GFX-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "GFX-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
  gfx.init()
end

function ultraschall.GFX_DrawThickRoundRect(x,y,w,h,thickness)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_DrawThickRoundRect</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_DrawThickRoundRect(integer x, integer y, integer w, integer h, number thickness)</functioncall>
  <description>
    draws a round-rectangle with a custom thickness.
    
    You shouldn't redraw with it too often, as it eats many ressources
    
    returns false in case of an error
  </description>
  <parameters>
    integer x - the x position of the rectangle
    integer y - the y position of the rectangle
    integer w - the width of the rectangle
    integer h - the height of the rectangle
    number thickness - the angle of the rectangle's corners
  </parameters>
  <retvals>
    boolean retval - true, drawing was successful; false, drawing wasn't successful
  </retvals>
  <chapter_context>
    Basic Shapes
  </chapter_context>
  <target_document>USApiGfxReference</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, draw, thickness, round rectangle</tags>
</US_DocBloc>
]]
  if gfx.getchar()==-1 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "", "no gfx-window opened", -1) return false end
  if ultraschall.type(x)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "x", "must be an integer", -2) return false end
  if ultraschall.type(y)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "y", "must be an integer", -3) return false end
  if ultraschall.type(w)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "w", "must be an integer", -4) return false end
  if ultraschall.type(h)~="number: integer" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "h", "must be an integer", -5) return false end
  if type(thickness)~="number" then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "thickness", "must be a number", -6) return false end
  if x<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "x", "must be bigger than 0", -7) return false end
  if y<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "y", "must be bigger than 0", -8) return false end
  if w<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "w", "must be bigger than 0", -9) return false end
  if h<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "h", "must be bigger than 0", -10) return false end
  if thickness<0 then ultraschall.AddErrorMessage("GFX_DrawThickRoundRect", "thickness", "must be bigger than 0", -11) return false end
  for i=1, thickness, 0.5 do
    gfx.roundrect(x+i,y+1+i,w-1-(i*2),h-(i*2),round)
    if thickness>1 then
      gfx.roundrect(x+1+i,y+i,w-1-(i*2),h-(i*2),round)
      gfx.roundrect(x+i,y+i,w+1-(i*2),h-(i*2),round)
      gfx.roundrect(x+i,y+i,w+1-(i*2),h-1-(i*2),round)
    end
  end
  return true
end

--A=ultraschall.GFX_DrawThickRoundRect(1,2,30,40,10)

function ultraschall.GFX_BlitFramebuffer(framebufferidx, showidx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GFX_BlitFramebuffer</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GFX_BlitFramebuffer(integer framebufferidx, optional boolean showidx)</functioncall>
  <description>
    blits a framebuffer at position 0,0. If the gfx-window is smaller than the contents of the framebuffer, it will resize it before blitting to window size, retaining the correct aspect-ratio.
    
    Mostly intended for debugging-purposes, when you want to track, if a certain framebuffer contains, what you expect it to contain.
    
    returns false in case of an error
  </description>
  <parameters>
    integer framebufferidx - the indexnumber of the framebuffer to blit; 0 to 1023; -1 is the displaying framebuffer
    optional boolean showidx - true, displays the id-number of the framebuffer in the top-left corner; false, does not display framebuffer-idx
  </parameters>
  <retvals>
    boolean retval - true, drawing was successful; false, drawing wasn't successful
  </retvals>
  <chapter_context>
    Blitting
  </chapter_context>
  <target_document>USApiGfxReference</target_document>
  <source_document>ultraschall_gfx_engine.lua</source_document>
  <tags>gfx, functions, gfx, blit, framebuffer</tags>
</US_DocBloc>
]]
  if math.type(framebufferidx)~="integer" then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "framebufferidx", "must be an integer", -1) return false end
  if framebufferidx<-1 or framebufferidx>1023 then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "framebufferidx", "must be between -1 and 1023", -1) return false end
  if showidx~=nil and type(showidx)~="boolean" then ultraschall.AddErrorMessage("GFX_BlitFramebuffer", "showidx", "must be a boolean", -3) return false end
  local x,y=gfx.getimgdim(framebufferidx)
  local ratiox=((100/x)*gfx.w)/100
  local ratioy=((100/y)*gfx.h)/100
  if ratiox<ratioy then ratio=ratiox else ratio=ratioy end
  if x<gfx.w and y<gfx.h then ratio=1 end
  local oldx=gfx.x
  local oldy=gfx.y
  gfx.x=0
  gfx.y=0
  A1,B,C,D,E=gfx.blit(framebufferidx,ratio,0)
  if showidx==true then 
    gfx.x=-1
    gfx.y=0
    gfx.set(0)
    gfx.drawstr(framebufferidx) 
    gfx.x=1
    gfx.y=1
    gfx.set(0)
    gfx.drawstr(framebufferidx) 
    gfx.x=0
    gfx.y=0
    gfx.set(1)
    gfx.drawstr(framebufferidx) 
  end    
  gfx.x=oldx
  gfx.y=oldy
  return true
end

function ultraschall.AddVirtualFramebuffer(framebufferobj, fromframebuffer, from_x, from_y, from_w, from_h, to_x,to_y,to_w,to_h, repeat_x, repeat_y)
  local table2
  if type(framebufferobj)~="table" then table2={} table2["count"]=0 else table2=framebufferobj end
  table2["count"]=table2["count"]+1
  table2[table2["count"]]={}
  table2[table2["count"]]["framebuffer"]=fromframebuffer
  table2[table2["count"]]["fromx"]=from_x
  table2[table2["count"]]["fromy"]=from_y
  table2[table2["count"]]["fromw"]=from_w
  table2[table2["count"]]["fromh"]=from_h

  -- target position
  table2[table2["count"]]["tox"]=to_x
  table2[table2["count"]]["toy"]=to_y
  table2[table2["count"]]["tow"]=to_w
  table2[table2["count"]]["toh"]=to_h
  return table2
end

--gfx.loadimg(1, "c:\\us.png")
--A=ultraschall.AddVirtualFramebuffer(framebufferobj, 1, 20,20,100,100,190,190)
--A=ultraschall.AddVirtualFramebuffer(A, 1, 0,20,140,140)


function ultraschall.BlitFullVirtualFramebuffer(framebufferobj)
-- missing:   scaling
--            rotation
--            start drawing from gfx.x and gfx.y or from a parameter? And how to calculate the offsets?
--            blitting only partial virtualframebuffer
  for i=1, framebufferobj["count"] do
      if framebufferobj[i]["tox"]==nil then tox=gfx.x else tox=framebufferobj[i]["tox"] end
      if framebufferobj[i]["toy"]==nil then toy=gfx.y else toy=framebufferobj[i]["toy"] end
      framebuffer=framebufferobj[i]["framebuffer"]
      fromx=framebufferobj[i]["fromx"]
      fromy=framebufferobj[i]["fromy"]
      fromw=framebufferobj[i]["fromw"]
      fromh=framebufferobj[i]["fromh"]

    gfx.blit(framebuffer,1,0,fromx,fromy,fromw,fromh,tox,toy)
  end
end

--gfx.x=80
--gfx.y=80
--ultraschall.BlitFullVirtualFramebuffer(A)
--gfx.blit(1,1,0)
--gfx.update()

--ultraschall.ShowLastErrorMessage()
