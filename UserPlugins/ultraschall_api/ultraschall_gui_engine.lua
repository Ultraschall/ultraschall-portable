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

-- graphics and gui-functions

if type(ultraschall)~="table" then ultraschall={} end
--[[
ultraschall.ConfiguredFontList={}
ultraschall.ConfiguredFontCounter=0
ultraschall.ConfiguredFontCurrent=0
ultraschall.VirtualFrameBuffer={}


function ultraschall.AddToVirtualFramebuffer(virtframebuffer_idx, framebuffer_idx, x, y, w, h, destx, desty)
  -- creates one virtual from one or several destinations
  -- that can be blit using ultraschall.blit()
  -- that way, we can circumvent the framebuffer-limitation of 2048x2048 pixels
  if type(ultraschall.VirtualFrameBuffer[virtframebuffer_idx])~="table" then 
    -- if virtualframebuffer does not exist yet, create it
    ultraschall.VirtualFrameBuffer[virtframebuffer_idx]={}
    ultraschall.VirtualFrameBuffer[virtframebuffer_idx]["idx"]=1
    idx=1
    ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]={}
  else
    -- if virtualframebuffer exists already, count one higher
    idx=ultraschall.VirtualFrameBuffer[virtframebuffer_idx]["idx"]
    idx=idx+1
    ultraschall.VirtualFrameBuffer[virtframebuffer_idx]["idx"]=idx
    ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]={}
  end
  
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["framebuffer_idx"]=framebuffer_idx -- the original-framebuffer, from which to blit
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["x"]=x -- x position of the original-framebuffer-rectangle, that shall be blit
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["y"]=y -- y position of the original-framebuffer-rectangle, that shall be blit
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["w"]=w -- w position of the original-framebuffer-rectangle, that shall be blit
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["h"]=h -- h position of the original-framebuffer-rectangle, that shall be blit
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["destx"]=destx -- x position within the virtual framebuffer
  ultraschall.VirtualFrameBuffer[virtframebuffer_idx][idx]["desty"]=desty -- y position within the virtual framebuffer
end

ultraschall.AddToVirtualFramebuffer(1, 12, 10, 20, 90, 100, 90,70)
ultraschall.AddToVirtualFramebuffer(1, 2, 10, 20, 90, 100,100,80)
ultraschall.AddToVirtualFramebuffer(1, 2, 10, 20, 90, 100,80,90)
ultraschall.AddToVirtualFramebuffer(2, 2, 10, 20, 90, 100,80,90)

function ultraschall.BlitVirtualFramebuffer(virtframebuffer_idx, idx)
  -- blit the ultraschall.VirtualFrameBuffer[virtframebuffer_idx]-framebuffer-elements
  -- ultraschall.VirtualFrameBuffer[virtframebuffer_idx]["idx"] gives you the numbers of 
  
end


function ultraschall.SetFont(idx, fontface, size, flags)
-- To Do Check Parameters überarbeiten
  if type(idx)~="number" then return false end
  if idx>0 and fontface~=nil then ultraschall.ConfiguredFontList[idx]={} end
  if idx>0 and fontface~=nil then ultraschall.ConfiguredFontList[idx]["fontface"]=fontface end
  if idx>0 and size~=nil then 
    if ultraschall.ConfiguredFontList[idx]["size"]==nil then return false else ultraschall.ConfiguredFontList[idx]["size"]=size end
  end
  if idx>0 and flags~=nil then   
    if ultraschall.ConfiguredFontList[idx]["flags"]==nil then return false else ultraschall.ConfiguredFontList[idx]["flags"]=flags end
  end
  if idx>0 and type(ultraschall.ConfiguredFontList[idx])=="table" then gfx.setfont(1, ultraschall.ConfiguredFontList[idx]["fontface"], ultraschall.ConfiguredFontList[idx]["size"], ultraschall.ConfiguredFontList[idx]["flags"]) 
  else 
  gfx.setfont(0)
  end
  if idx>ultraschall.ConfiguredFontCounter then ultraschall.ConfiguredFontCounter=idx end
  ultraschall.ConfiguredFontCurrent=idx
  return true
end


function ultraschall.GetFont(idx)
  if idx==-1 then idx=ConfiguredFontCurrent end
  if type(ultraschall.ConfiguredFontList[idx])~="table" then return end
  return ultraschall.ConfiguredFontList[idx]["fontface"], ultraschall.ConfiguredFontList[idx]["size"], ultraschall.ConfiguredFontList[idx]["flags"]
end

function ultraschall.SetDestination(idx,w,h,clear,topleft)
  if idx>=-1 and idx<1024 then
    gfx.set(gfx.r,gfx.g,gfx.b,gfx.a,gfx.mode,idx) -- set destination
    if type(w)=="number" and type(h)=="number" and w<=2048 and w>0 and h<=2048 and h>0 then
      gfx.setimgdim(idx,w,h) -- set dimensions of destination
      if clear==true then -- make destination black
        r=gfx.r
        g=gfx.g
        b=gfx.b
        a=gfx.a
        mode=gfx.mode
        gfx.set(0)
        gfx.rect(0,0,w,h,true)
        gfx.set(r,g,b,a,mode)
      end
    end
    if topleft==true then -- move x,y to topleft-corner
      gfx.x=1
      gfx.y=1
    end
    return true
  else
    return false
  end
end


function ultraschall.Inverse_Rectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse, fillr, fillg, fillb, thickness)
  if tonumber(thickness)==nil then thickness=1 end
  if fillr~=nil and fillg~=nil and fillb~=nil then
    gfx.set(fillr, fillg, fillb)
    for i=0, thickness do
      gfx.rect(x+i,y+i,w-i,h-i,1)
    end
  end
  if inverse==true then gfx.set(r2,g2,b2) else gfx.set(r1,g1,b1) end
  for i=0, thickness do
    gfx.line(x+i,y+i,x+w-i,y+i)
    gfx.line(x+i,y+i,x+i,y+h-i)
  end
  if inverse==true then gfx.set(r1,g1,b1) else gfx.set(r2,g2,b2) end
  for i=0, thickness do
    gfx.line(x+w-i,y+i,x+w-i,y+h-i)
    gfx.line(x+i,y+h-i,x+w-i,y+h-i)
  end
end

function ultraschall.ButtonCaption(x,y,w,h, r1, g1, b1, a, pressed, caption, offset, fontface, fontsize, flags)
  if type(flags)~="number" then flags=5 end
    r=gfx.r
    g=gfx.g
    b=gfx.b
    gfx.set(r1,g1,b1)
    fontindex, fontface_old = gfx.getfont() -- old fontdimensions; but no fontsize(?)
    fontsize_old=gfx.texth
    gfx.setfont(1, fontface, fontsize,0)
    if pressed=="pressed" then 
      gfx.x=x+offset--+(w/2)
      gfx.y=y+offset--+(h/2)
    else
      gfx.x=x--+(w/2)
      gfx.y=y--+(h/2)
    end
    gfx.drawstr(caption,flags,x+w,y+h)
    gfx.set(r,g,b)
    gfx.setfont(1, fontface_old, fontsize_old,0)
end


function ultraschall.DrawCaption(caption, x,y,w,h, r, g, b, a, fontface, fontsize, flags)
  if type(x)=="number" then gfx.x=x else x=gfx.x end
  if type(y)=="number" then gfx.y=y else y=gfx.y end
  if type(w)~="number" then w=gfx.w end
  if type(h)~="number" then h=gfx.h end
  
  if type(r)~="number" then r=gfx.r end
  if type(g)~="number" then g=gfx.g end
  if type(b)~="number" then b=gfx.b end
  if type(a)~="number" then a=gfx.a end

  gfx.set(r,g,b,a)
  if fontface~=nil then -- if font is given
    fontindex, fontface_old = gfx.getfont()
    fontsize_old=gfx.texth
    gfx.setfont(1, fontface, fontsize,0)
  end

  gfx.drawstr(caption,flags,x+w,y+h)

  if fontface~=nil then -- if font was given, restore old font
    gfx.setfont(1, fontface_old, fontsize_old,0)
  end
end



function ultraschall.Inverse_RoundRectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse, fillr, fillg, fillb)
  if fillr~=nil and fillg~=nil and fillb~=nil then --and llll=="1" then
    if inverse==false then x=x+2 y=y+2 gfx.set(r2,1,b2) else gfx.set(r1,1,b1) end
            
    gfx.set(fillr, fillg, fillb)
    gfx.rect(x+0.5,y+6.5,w+.5,h-13,1)
    gfx.rect(x+8,y+1.5,w-16,h,1)
    gfx.circle(x+7,y+8,7,1)
    gfx.circle(x+w-8,y+8,7,1)
    gfx.circle(x+w-8,y+h-7,7,1)
    gfx.circle(x+7,y+h-7,7,1)
  end
end


function ultraschall.DrawButton(x, y, w, h, pressed, style, mode)
    dest_old=gfx.dest
    r=gfx.r
    g=gfx.g
    b=gfx.b
    a=gfx.a
    gfx.set(gfx.r,gfx.g,gfx.b,gfx.a,mode)
    if pressed=="pressed" then
      if style==1 then
        ultraschall.Inverse_Rectangle(x,y,w,h, 0.3, 0.3, 0.3, 1, 1, 1, false, 0.7,0.7,0.7)
      elseif style==2 then
        ultraschall.Inverse_RoundRectangle(x+2,y+2,w+2,h+2, 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.4,0.4,0.4)
      end    
    elseif pressed=="unpressed" then
      if style==1 then
        ultraschall.Inverse_Rectangle(x,y,w,h, 0.3, 0.3, 0.3, 1, 1, 1, true, 0.7,0.7,0.7)
      elseif style==2 then
          for l=0, 1 do
            ultraschall.Inverse_RoundRectangle(x-1,y-l,w,h, 0.3, 0.3, 0.3, 0.7, 0.7, 0.7, inverse, 0,0,0)
            ultraschall.Inverse_RoundRectangle(x+l,y+l,w,h, 0.3, 0.3, 0.3, 0.7, 0.7, 0.7, inverse, 0,0,0)
          end
          ultraschall.Inverse_RoundRectangle(x,y-2,w+1,h, 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0,0,0)     
          ultraschall.Inverse_RoundRectangle(x,y-1,w,h, 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.4,0.4,0.4)
          ultraschall.Inverse_RoundRectangle(x,y,w,h, 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.275,0.275,0.275)
        end
      end
      gfx.set(r,g,b,a,mode)
end

function ultraschall.Gfx_DrawRoundRectangle(x,y,w,h,radius,r,g,b,a,mode,dest)
  if radius<0 or radius>w*0.4 or radius>h*0.4 then return -1 end
  gfx.set(r,0,b,a,mode,dest)
--  gfx.rect(x,y,w,h,0)
  gfx.set(r,g,b,a,mode,dest)
  gfx.circle(x+radius,y+radius,radius,1,1)
  gfx.circle(x+w-radius-1,y+radius,radius,1,1)
  gfx.circle(x+radius,y+h-radius-1,radius,1,1)
  gfx.circle(x+w-radius-1,y+h-radius-1,radius,1,1)
--  gfx.set(0,1,1)
  gfx.rect(x+radius,y,w-radius*2,h)
  gfx.rect(x,y+radius,w,h-radius*2)
end


function ultraschall.Gfx_DrawRoundRectangle_Thick(x,y,w,h,radius,thickness,r,g,b,a,mode,dest)
  if radius<0 or radius>60 then return -1 end
  gfx.set(r,0,b,a,mode,dest)
--  gfx.rect(x,y,w,h,0)
  gfx.set(r,g,b,a,mode,dest)
  i=1
  for i=0, thickness, 0.1 do
    gfx.roundrect(x+i,y+i,w-i*2,h-i*2,radius-i,1)
    gfx.roundrect(x+i+0.1,y+i+0.2,w-i*2,h-i*2,radius-i,1)
  end
end



--gfx.init()

--A2=gfx.loadimg(3,"c:\\us.png")
--for i=0, 1 do
--  A=gfx.setimgdim(i,2048,2048)
--A2=gfx.loadimg(1,"c:\\us.png")
--  gfx.setfont(1,"arial",22,0)
 -- gfx.set(1,1,1,1,0,i)
--  gfx.x=10
 -- gfx.y=10
  --gfx.drawchar(i/4)
--end
--B,C=gfx.getimgdim(1)
--l=0
--l2=0
--  ultraschall.SetFont(1,"blackchancery",l,0)
function main()
  if gfx.mouse_cap&1==1 then pressed="pressed" end
  if gfx.mouse_cap&1==0 then pressed="unpressed" end
  ultraschall.DrawButton(10,10,300,30,pressed, 1, -1, 0)
  ultraschall.ButtonCaption(10,10,300,30, 0, 0, 0, 0, pressed, "Action",3,"arial",12)
--  L=ultraschall.SetDestination(1,248,248,true)
  ultraschall.SetFont(l2)
--  gfx.drawstr("tellerwäscher")
--  L2=ultraschall.SetDestination(-1,nil,nil,nil,true)
--  gfx.x=1
--  gfx.y=1
  gfx.blit(1,1,0)
--  ultraschall.DrawCaption("Roxanne",0+l,0,100,100,1,1,1,1,"blackchancery",20,l)
  gfx.x=1
  gfx.y=1
  ultraschall.DrawCaption("Roxanne\nbiblical\nmagical")
  D=gfx.getchar()
  if D==46 then l=l+1 end
  if D==44 then l=l-1 end
  if D==107 then l2=l2+1 end
  if D==108 then l2=l2-1 end

  gfx.update()
  if D~=-1 then reaper.defer(main) end
end

--main()

--]]
