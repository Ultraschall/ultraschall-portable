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
  --]]

-- Ultraschall-API demoscript by Meo Mespotine 20.03.2019
-- 
-- a simple drawing tool, that demonstrates the GFX_GetMouseCap-function
--
-- how to use it:
--      clicks draw circles
--      doubleclicks draw circles and colored squares
--      drags draw circles at starting point and line to endpoint
--      drags+ctrl/cmd draw circles and rectangles

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
gfx.init()

function main()
  -- get current mouse-states
  ClickState,ClickState2,MouseCap,StartX,StartY,EndX,EndY,MouseWheel,MouseHWheel=
  ultraschall.GFX_GetMouseCap(100,100)

  -- draw shapes while clicked, that will not be kept, until mouse isn't clicked,
  -- especially for dragging
  -- will be drawn into framebuffer -1
  if ClickState2=="DRAG" and MouseCap==1 then 
    -- draw temporary line
    gfx.set(1,1,1,1,0,-1)
    gfx.line(StartX,StartY,EndX,EndY, 1)
    draw=true
  elseif ClickState2=="DRAG" and MouseCap==5 then 
    -- draw temporary rectangle (when cmd/ctrl is pressed as well)
    gfx.set(1,1,1,1,0,-1)
    gfx.rect(StartX,StartY,EndX-StartX,EndY-StartY, 0)
    draw=true
    square=true
    
  -- draw shapes after mousebutton is lifted again, that will remain
  -- will be drawn into framebuffer 1
  elseif ClickState2=="DBLCLK" then
    -- draw doubleclick
    gfx.set(math.random(),math.random(),1,1,0,1)
    gfx.rect(StartX,StartY,10,10,1)
  elseif ClickState=="CLK" then
    -- draw click
    gfx.set(1,1,1,1,0,1)
    gfx.circle(StartX,StartY,2,1,1)
  elseif ClickState=="" and draw==true and square~=true then
    -- draw line
    gfx.set(1,1,1,1,0,1)
    gfx.line(StartXold,StartYold,EndXold,EndYold, 1)
    draw=false
    square=false
  elseif ClickState=="" and draw==true and square==true then
    -- draw rectangle
    gfx.set(1,1,1,1,0,1)
    gfx.rect(StartXold,StartYold,EndXold-StartXold,EndYold-StartYold, 0)
    draw=false
    square=false
  end  
  -- blit the current drawn stuff
  gfx.set(1,1,1,1,0,-1)
  gfx.blit(1,1,0)
  
  if ClickState2=="DRAG" then StartXold,StartYold,EndXold,EndYold=StartX,StartY,EndX,EndY end
  gfx.update()
  
  -- show mousestates
  String="Monitoring Mousestates\n\n"..
  "ClickState  : "..ClickState.."\n"..
  "ClickState2: "..ClickState2.."\n"..
  "MouseCap  : "..MouseCap.."\n"..
  "StartX         : "..StartX.."\n"..
  "StartY         : "..StartY.."\n"..
  "EndX          : "..EndX.."\n"..
  "EndY          : "..EndY.."\n"..
  "Wheel         : "..MouseWheel.."\n"..
  "HWheel      : "..MouseHWheel.."\n"
  
  if String~=OldString then
    print_update(String)
  end
  
  OldString=String
  
  reaper.defer(main)
end

gfx.setimgdim(1,1024,1024)
main()

