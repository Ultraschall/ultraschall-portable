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

-- Meo Mespotine - 24.6.2019
--
-- This tool is meant to give you an idea, how gfx.deltablit/gfx_deltablit works.
--
-- At the bottom, you have a description, what the selected parameter is supposed to do.

gfx.setfont(1, "arial", 15)
Table={0,0,0,0,0,0,241,140,1,0,0,1,0,0,0,0}
Defaults={0,0,0,0,0,0,241,140,1,0,0,1,0,0,0,0}
Table[0]="\n"
Entries={"srcs","srct","srcw","srch","destx","desty","destw","desth","dsdx","dtdx","dsdy","dtdy","dsdxdy","dtdxdy","usecliprect"}
Entries[0]=""

Helptexts={"positiondeltaX - the delta of the x-position of the image within the blitted area in pixels",
           "positiondeltaY - the delta of the y-position of the image within the blitted area in pixels",
           "unknown",
           "unknown",
           "positiondeltaX - the delta of the x-position of the blitted area in pixels",
           "positiondeltaY - the delta of the y-position of the blitted area in pixels",
           "blitsizeX - the x-size of the blitted area in pixels; the deltaimage might be cropped, \nif it exceeds this size",
           "blitsizeY - the y-size of the blitted area in pixels; the deltaimage might be cropped, \nif it exceeds this size",
           "stretchfactorX, the lower, the more stretched is the image(minimum 0; 1 for full size)",
           "deltaY: the delta of the right side of the image, related to the left side of the image;\n positive, right is moved up; negative, right is moved down; this delta is linear",
           "deltaX: the delta of the bottom side of the image, related to the top side of the image;\n positive, bottom is moved left; negative, bottom is moved right; this delta is linear",
           "stretchfactorY, the lower, the more stretched is the image(minimum 0; 1 for full size)",
           "deltacurvedY: the delta of the right side of the image, related to the left side of the image;\npositive, right is moved up; negative, right is moved down; this delta \"curves\" the \ndelta via a bezier",
           "deltacurvedX: the delta of the bottom side of the image, related to the top side of the image;\npositive, bottom is moved left; negative, bottom is moved right; this delta \"curves\" the \ndelta via a bezier",
           "can be set to 0 or 1"
           }
Index=1
scale=1

function DisplayHelp()
reaper.MB(
  [[Deltablit-Viewer by Meo Mespotine - 24. June 2019
  
This tool is meant to give you an idea, how gfx.deltablit/gfx_deltablit works.
At the bottom, you have a description, what the selected parameter is supposed to do.

Note: Some parameters should only be changed by smaller stepsizes!
  
   F1 - this help 
    
   up/down - Navigate through the parameters
   left/right - alter parameter, stepsize of 1
   Ctrl+left/Ctrl+right - alter parameter, stepsize of 0.001
   Shift+left/Shift+right - alter parameter, stepsize of 10
   Shift+Ctrl+left/Shift+Ctrl+right - alter parameter, stepsize of 100
   
   Backspace - reset parameter to default-value
    
   L - load new image
    
   Esc - quit this tool]], "Help: GFX-Deltablit-Viewer", 0)
end

function LoadImage()
  filename=""
  selected, filename = reaper.GetUserFileNameForRead(reaper.GetExtState("ultraschall", "devscript_gfx_deltablit_displayer"), "select picture", "")
  if selected==false then return -1 end
  selected=gfx.loadimg(1, filename)
  if selected==-1 then return -1 end
  Table[7], Table[8] = gfx.getimgdim(1)
  Defaults[7], Defaults[8] = gfx.getimgdim(1)
  reaper.SetExtState("ultraschall", "devscript_gfx_deltablit_displayer", filename, true)
  return selected
end

function main()
  gfx.x=20
  gfx.y=20
  A=gfx.getchar()
  --if A~=0 then reaper.CF_SetClipboard(A) end
  if A==30064.0      then Index=Index-1 if Index<1 then Index=1 end end
  if A==1685026670.0 then Index=Index+1 if Index>15 then Index=15 end end
  if A==1919379572.0 and gfx.mouse_cap==0 then Table[Index]=Table[Index]+1 end
  if A==1818584692.0 and gfx.mouse_cap==0 then Table[Index]=Table[Index]-1 end
  if A==1919379572.0 and gfx.mouse_cap==12 then Table[Index]=Table[Index]+100 end
  if A==1818584692.0 and gfx.mouse_cap==12 then Table[Index]=Table[Index]-100 end
  if A==1919379572.0 and gfx.mouse_cap==8 then Table[Index]=Table[Index]+10 end
  if A==1818584692.0 and gfx.mouse_cap==8 then Table[Index]=Table[Index]-10 end
  if A==1919379572.0 and gfx.mouse_cap==4 then Table[Index]=Table[Index]+.001 end
  if A==1818584692.0 and gfx.mouse_cap==4 then Table[Index]=Table[Index]-.001 end
  if A==8.0 then Table[Index]=Defaults[Index] end
  if A==27 then gfx.quit() end
  if A==108.0 then 
    A1=LoadImage() 
    if A1==-1 then 
      reaper.MB("Could not load image: Either no image or wrong extension", "Ooops", 0)
    end
  end
  if A==26161.0 then DisplayHelp() end
  
  --O=gfx.gradrect(table.unpack(Table))
  O=gfx.deltablit(1, table.unpack(Table))
  gfx.x=400
  gfx.y=10
  tempstring="\n"
  for i=0, 15 do
    if Index==i+1 then 
      tempstring=tempstring..Entries[i].."\n"
    else
      tempstring=tempstring..Entries[i].."\n"
    end
  end
  
  gfx.x=gfx.w-180
  gfx.y=12
  gfx.set(0)
  gfx.drawstr(tempstring)
  gfx.x=gfx.w-181
  gfx.y=10
  gfx.set(1)
  gfx.drawstr(tempstring)
  tempstring=""
  for i=0, 15 do
    if Index==i+1 then 
      tempstring=tempstring..Table[i].."\n>\t"
    else
      tempstring=tempstring..Table[i].."\n "
    end
  end
  gfx.x=gfx.w-99
  gfx.y=12
  gfx.set(0)
  gfx.drawstr(tempstring)
  gfx.x=gfx.w-100
  gfx.y=11
  gfx.set(1)
  gfx.drawstr(tempstring)
  
  gfx.update()
  gfx.set(0)
  gfx.x=20
  gfx.y=gfx.h-80
  gfx.drawstr("Press F1 for help. \n\nParameter description: \n"..Helptexts[Index])
  gfx.set(1)
  gfx.x=19
  gfx.y=gfx.h-81
  gfx.drawstr("Press F1 for help. \n\nParameter description: \n"..Helptexts[Index])

  
  if A~=-1 then 
    reaper.defer(main)
  end
end


A1=LoadImage()
if A1==-1 then 
  reaper.MB("Could not load image: Either no image or wrong extension", "Ooops", 0)
else
  gfx.init("gfx.deltablit/gfx_deltablit-Viewer")
  main()
  DisplayHelp()
end

