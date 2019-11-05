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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
gfx.clear=ultraschall.ConvertColor(50,50,50)
gfx.init("Soundboard", 650, 800, 0, ultraschall.GetScreenWidth()-655, 0)
gfx.setfont(1,"tahoma",15,0)

AA=gfx.loadimg(2, "C:\\Users\\meo\\Desktop\\31732491_2101912709838735_2939449864758493184_n.jpg")
  

last_button=0
track="music"
button=0
buttoncounter=34
xoffset=20
yoffset=20

for i=0, reaper.CountTracks(0)-1 do
  retval, buf = reaper.GetTrackName(reaper.GetTrack(0,i), "")
  if buf==track then track=i+1 break end
end

buttonarray={}

if buttoncounter>34 then buttoncounter=34 end
if buttoncounter>17 then buttoncounter2=17 else buttoncounter2=buttoncounter end

for i=1, buttoncounter2 do
  buttonarray[i]={}
    buttonarray[i]["x"]=20+20
    buttonarray[i]["y"]=40+((i-1)*40)
    buttonarray[i]["w"]=200
    buttonarray[i]["h"]=30
    buttonarray[i]["mousestate"]="none"
    buttonarray[i]["caption"]=" - none - "
    buttonarray[i]["slug"]="OK-Button_"..i
    buttonarray[i]["filename"]=""
    buttonarray[i]["type"]="button"
    buttonarray[i]["length"]=0
end

for i=1, buttoncounter-buttoncounter2 do
  buttonarray[i+buttoncounter2]={}
    buttonarray[i+buttoncounter2]["x"]=330+20
    buttonarray[i+buttoncounter2]["y"]=40+((i-1)*40)
    buttonarray[i+buttoncounter2]["w"]=200
    buttonarray[i+buttoncounter2]["h"]=30
    buttonarray[i+buttoncounter2]["mousestate"]="none"
    buttonarray[i+buttoncounter2]["caption"]=" - none - "
    buttonarray[i+buttoncounter2]["slug"]="OK-Button_"..(i+buttoncounter2)
    buttonarray[i+buttoncounter2]["filename"]=""
    buttonarray[i+buttoncounter2]["type"]="button"
    buttonarray[i+buttoncounter2]["length"]=0
end

  buttonarray[buttoncounter+1]={}
    buttonarray[buttoncounter+1]["x"]=0
    buttonarray[buttoncounter+1]["y"]=0
    buttonarray[buttoncounter+1]["w"]=230
    buttonarray[buttoncounter+1]["h"]=30
    buttonarray[buttoncounter+1]["mousestate"]="none"
    buttonarray[buttoncounter+1]["caption"]="Import Filenames From Clipboard"
    buttonarray[buttoncounter+1]["slug"]="Function_ImportClipboard"
    buttonarray[buttoncounter+1]["type"]="button"
          
  buttoncounter=buttoncounter+1

  buttonarray[buttoncounter+1]={}
    buttonarray[buttoncounter+1]["x"]=240
    buttonarray[buttoncounter+1]["y"]=0
    buttonarray[buttoncounter+1]["w"]=180
    buttonarray[buttoncounter+1]["h"]=30
    buttonarray[buttoncounter+1]["mousestate"]="none"
    buttonarray[buttoncounter+1]["caption"]="Stop Current File In Track"
    buttonarray[buttoncounter+1]["slug"]="Function_StopPlayback"
    buttonarray[buttoncounter+1]["type"]="button"
          
  buttoncounter=buttoncounter+1

  buttonarray[buttoncounter+1]={}
    buttonarray[buttoncounter+1]["x"]=430
    buttonarray[buttoncounter+1]["y"]=0
    buttonarray[buttoncounter+1]["w"]=180
    buttonarray[buttoncounter+1]["h"]=30
    buttonarray[buttoncounter+1]["mousestate"]="none"
    buttonarray[buttoncounter+1]["caption"]="Stop All Files In Track Until End"
    buttonarray[buttoncounter+1]["slug"]="Function_StopPlaybackAllFiles"
    buttonarray[buttoncounter+1]["type"]="button"
      
  buttoncounter=buttoncounter+1
  
  buttonarray[1]["filename"]="c:\\Users\\meo\\Desktop\\Focus - Hocus Pocus.mp3"

function drawbutton_normal(x, y, w, h, caption, pressed)
  x=x+xoffset
  y=y+yoffset
  gfx.set(0.8)
  gfx.rect(x,y,w,h)
  gfx.set(0)
  width, height = gfx.measurestr(caption)

  if pressed=="none" then 
    -- caption
    gfx.x=x+((w-width)/2)
    gfx.y=y+((h-height)/2)
    gfx.drawstr(caption)
  
    -- shadows
    gfx.set(0.9)
    gfx.line(x,y,x+w,y)
    gfx.line(x,y,x,y+h)
    gfx.set(0.4)
    gfx.line(x+w,y,x+w,y+h)
    gfx.line(x,y+h,x+w,y+h)    
  elseif pressed=="leftclicked" then 
    -- caption
    gfx.x=1+x+((w-width)/2)
    gfx.y=1+y+((h-height)/2)
    gfx.drawstr(caption)
    
    -- shadows
    gfx.set(0.4)
    gfx.line(x,y,x+w,y)
    gfx.line(x,y,x,y+h)
    gfx.set(0.9)
    gfx.line(x+w,y,x+w,y+h)
    gfx.line(x,y+h,x+w,y+h)    
  end
end

function Inverse_RoundRectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse, fillr, fillg, fillb)
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

function drawbutton_ultraschall(x, y, w, h, caption, pressed, time)
  x=x+xoffset
  y=y+yoffset
--  gfx.set(0.8)

  if pressed~="none" then inverse=false else inverse=true end
  Inverse_RoundRectangle(x,y,w,h, 0.3,0.3,0.3,1,1,1, inverse, 0.3,0.3,0.3)
  gfx.set(0.9)
  width, height = gfx.measurestr(caption)

  if pressed=="none" then 
    -- caption
    X,Y=gfx.measurestr(caption)
    if X>w-20 then X=w-20 end
    gfx.x=((w)/2)+x-(X/2)
    gfx.y=y+((h-height)/2)

    gfx.drawstr(caption,0,x+w-10,y+h)
    
  elseif pressed=="leftclicked" then 
    -- caption
    X,Y=gfx.measurestr(caption)
    if X>w-20 then X=w-20 end
    gfx.x=2+((w)/2)+x-(X/2)
    gfx.y=2+y+((h-height)/2)

    gfx.drawstr(caption,0,x+w-10,y+h)
  end
end

function drawgfx()
--  gfx.clear=16777215  
  drawbuttons()
  gfx.x=0 gfx.y=0
  gfx.set(1,1,1,0.3,0)
  gfx.blit(2,0.4,0)
  X1,Y1=gfx.getimgdim(2)
  gfx.x=700 gfx.y=800
  gfx.blit(2,-0.4,0)
end

function checkupdate()
  if oldgfxw~=gfx.w or oldgfxh~=gfx.h or oldmousecap~=gfx.mouse_cap then
    oldgfxw=gfx.w
    oldgfxh=gfx.h
    oldmousecap=gfx.mouse_cap
    return true
  end
  return false
end

function drawfilename(x,y,filename, length)
--[[
  gfx.set(1)
  gfx.x=x+80
  gfx.y=y+35
  if filename:find(ultraschall.Separator)~=nil then path, filename=ultraschall.GetPath(filename, ultraschall.Separator) end
  time = reaper.format_timestr(length, "")
  gfx.drawstr(filename,0,x+40+230,gfx.y+100)
  gfx.x=x+280
  if filename~="" then gfx.drawstr("("..time:match("(.*)%.")..")",0,x+90+250,gfx.y+100) end
  ]]--
end



function drawbuttons()
  for i=1, buttoncounter do
    if buttonarray[i]["length"]==nil then temp=0 else temp=buttonarray[i]["length"] end
    drawbutton_ultraschall(buttonarray[i]["x"], buttonarray[i]["y"], buttonarray[i]["w"], buttonarray[i]["h"], buttonarray[i]["caption"], buttonarray[i]["mousestate"], reaper.format_timestr(temp, ""))
    if buttonarray[i]["slug"]:sub(1,8)~="Function" then drawfilename(buttonarray[i]["x"], buttonarray[i]["y"], buttonarray[i]["filename"], buttonarray[i]["length"]) end
  end
end

function checkmouseclick(left, right, both, hover)
  button_id=0
  for i=1, buttoncounter do
    if gfx.mouse_x>buttonarray[i]["x"]+xoffset and
       gfx.mouse_x<buttonarray[i]["x"]+buttonarray[i]["w"]+xoffset and
       gfx.mouse_y>buttonarray[i]["y"]+yoffset and
       gfx.mouse_y<buttonarray[i]["y"]+buttonarray[i]["h"]+yoffset then
       if gfx.mouse_cap==3 and both==true then
         buttonarray[i]["mousestate"]="bothclicked"
         check=true
       elseif gfx.mouse_cap&1==1 and left==true then 
         buttonarray[i]["mousestate"]="leftclicked"
         check=true
       elseif gfx.mouse_cap&2==2 and right==true then
         buttonarray[i]["mousestate"]="rightclicked"
         check=true
       elseif gfx.mouse_cap==0 and hover==true then
         check=true
       end   
       if check==true then button_id=i check=false break end
    end
  end
  if button_id==nil then button_id=0 end
--  reaper.ShowConsoleMsg(button_id.."\n")
  if button_id~=0 and lastbutton==0 then lastbutton=button_id end
  return button_id
end

function setallbuttons_unclicked()
  for i=1, buttoncounter do
    buttonarray[i]["mousestate"]="none"
  end
end

function importaudio(id)
  if buttonarray[id]["filename"]~="" then 
    if reaper.GetPlayState()~=0 then position=reaper.GetPlayPosition() else position=reaper.GetCursorPosition() end
    ultraschall.pause_follow_one_cycle()
    A2, RetItem=ultraschall.InsertMediaItemFromFile(buttonarray[id]["filename"], track, position, -1, 1, 1.5)
--    retval = ultraschall.NormalizeItems({RetItem})
    if buttonarray[id]["filename"]:find(ultraschall.Separator)~=nil then 
      path, filename=ultraschall.GetPath(buttonarray[id]["filename"],ultraschall.Separator) 
      filename=filename:match("(.*)%.")
    else 
      filename=buttonarray[id]["filename"] 
    end
    reaper.SetCursorContext(1,0)
    
    ultraschall.AddNormalMarker(position, -1, filename)
  end
end

function importfilenames()
  local Clipboard=ultraschall.GetStringFromClipboard_SWS()
  count, split_string = ultraschall.SplitStringAtLineFeedToArray(Clipboard)
  if count>34 then count=34 end
  for i=1, count do
    if i<=34 then 
      buttonarray[i]["filename"]=split_string[i] 
      buttonarray[i]["length"]=ultraschall.GetMediafileAttributes(split_string[i])
      path, filename = ultraschall.GetPath(split_string[i], ultraschall.Separator)
      buttonarray[i]["caption"]=filename
    else 
      buttonarray[i]["filename"]="" 
    end
  end
  
end

function stopplayback(track)
  if reaper.GetPlayState()~=0 then position=reaper.GetPlayPosition() else position=reaper.GetCursorPosition() end
  retval, MediaItemArray = ultraschall.SplitMediaItems_Position(position, tostring(track), true)
  ultraschall.DeleteMediaItemsFromArray(MediaItemArray)
end

function stopplayback_fulltrack(track)
  if reaper.GetPlayState()~=0 then position=reaper.GetPlayPosition() else position=reaper.GetCursorPosition() end
  number_items, MediaItemArray_StateChunk = ultraschall.SectionCut(position, reaper.GetProjectLength(), tostring(track))
end

function Functions(id)
  if buttonarray[button]["slug"]=="Function_ImportClipboard" then importfilenames()
  elseif buttonarray[button]["slug"]=="Function_StopPlayback" then stopplayback(track) 
  elseif buttonarray[button]["slug"]=="Function_StopPlaybackAllFiles" then stopplayback_fulltrack(track)
  end
  reaper.UpdateArrange()
end

function movebutton(id)
  if id==nil then return end
  if id>0 then
    buttonarray[id]["x"]=gfx.mouse_x-xoffset-20
    buttonarray[id]["y"]=gfx.mouse_y-yoffset-20
  end
  drawbuttons()
end

function movebutton_step(id,x,y)
  if id==nil then return end
  if id>0 then
    if type(x)~="number" then x=0 end
    if type(y)~="number" then y=0 end
    buttonarray[id]["x"]=buttonarray[id]["x"]+x
    buttonarray[id]["y"]=buttonarray[id]["y"]+y
  end
  drawbuttons()
end


function changesize_step(id,w,h)
  if id>0 then
    if type(w)~="number" then w=0 end
    if type(h)~="number" then h=0 end
    buttonarray[id]["w"]=buttonarray[id]["w"]+w
    buttonarray[id]["h"]=buttonarray[id]["h"]+h    
  end
  drawbuttons()
end

function main()
  if updatecounter>0 then
    if gfx.mouse_cap~=0 and gfx.mouse_cap~=8  then button=checkmouseclick(true, false, false, false) else setallbuttons_unclicked() end
    if gfx.mouse_cap==4 then button=checkmouseclick(false, false, false, true) end
    if (gfx.mouse_cap==8 or gfx.mouse_cap==4) and lastbutton~=0 then button=checkmouseclick(false, false, false, true) keep=true end
    if gfx.mouse_cap==9 then movebutton(lastbutton) end
    if gfx.mouse_cap==0 and button>=1 then 
      if buttonarray[button]["slug"]:sub(1,8)=="Function" then Functions(id) else importaudio(button) end
      button=0
    end
    if gfx.mouse_cap==0 then if lastbutton~=0 then lastbutton2=lastbutton end lastbutton=0 keep=false end
    if checkupdate()==true then drawgfx() end
    Key=gfx.getchar()
--[[    if Key==1919379572.0 and gfx.mouse_cap&8~=8 then xoffset=xoffset+1 end
    if Key==1818584692.0 and gfx.mouse_cap&8~=8 then xoffset=xoffset-1 end
    if Key==1685026670.0 and gfx.mouse_cap&8~=8 then yoffset=yoffset+1 end
    if Key==30064.0 and gfx.mouse_cap&8~=8 then yoffset=yoffset-1 end
    --]]
    
    if Key==1919379572.0 and gfx.mouse_cap==8 then movebutton_step(lastbutton2,1,0) end
    if Key==1818584692.0 and gfx.mouse_cap==8 then movebutton_step(lastbutton2,-1,0) end
    if Key==1685026670.0 and gfx.mouse_cap==8 then movebutton_step(lastbutton2,0,1) end
    if Key==30064.0 and gfx.mouse_cap==8 then movebutton_step(lastbutton2,0,-1) end

    if Key==1919379572.0 and gfx.mouse_cap==4 then movebutton_step(lastbutton2,50,0) end
    if Key==1818584692.0 and gfx.mouse_cap==4 then movebutton_step(lastbutton2,-50,0) end
    if Key==1685026670.0 and gfx.mouse_cap==4 then movebutton_step(lastbutton2,0,50) end
    if Key==30064.0 and gfx.mouse_cap==4 then movebutton_step(lastbutton2,0,-50) end
    
    if Key==1919379572.0 and gfx.mouse_cap==12 then changesize_step(lastbutton2,1,0) end
    if Key==1818584692.0 and gfx.mouse_cap==12 then changesize_step(lastbutton2,-1,0) end
    if Key==1685026670.0 and gfx.mouse_cap==12 then changesize_step(lastbutton2,0,1) end
    if Key==30064.0 and gfx.mouse_cap==12 then changesize_step(lastbutton2,0,-1) end
    
--    if Key~=0 then reaper.CF_SetClipboard(Key) drawgfx() end
--    if Key~=0 and gfx.mouse_cap&1==0 and gfx.mouse_cap==8 then lastbutton=0 keep=false end    
    updatecounter=-1
  end
  updatecounter=updatecounter+1
--  P=P+1
  gfx.update()
  if Key==27 or Key==-1.0 then gfx.quit() return end
  reaper.defer(main)
end

updatecounter=-1
P=0

main()
