Snap=1
timeout=0
Debug=true
count=0
i=1
a=0
Keyboard_Focus=-1
anyelement=false
anyelement_gui_id=-1
leftclick=0
Draw=true
Drag=0
DragElement=-1
Grid=""
slotnumber=500 -- slotnumber for images, slots 500-700 are reserved for that
ExportFilename=""

--DebugStuff - example-entries
Title="Ultraschall GUI-Engine-Prototype"
EditDragX=-1
EditDragY=-1
WinW=490
WinH=400
Dockstate=0
WinX=10
WinY=20
GUID=""
count=4
BGR=0.15
BGG=0.15
BGB=0.15
GridLinesX=10
GridLinesY=10
GridGapX=10
GridGapY=10
GridOffsetX=0
GridOffsetY=0
GridR=0.4
GridG=0.4
GridB=0.4
GridA=0.03
GridPlusMinus=10
gui_elements={}
gui_elements[1]={}
gui_elements[1]["visibility"]=true
gui_elements[1]["element_type"]="button"
gui_elements[1]["title"]="testbutton1"
gui_elements[1]["x"]=292
gui_elements[1]["y"]=321
gui_elements[1]["w"]=192
gui_elements[1]["h"]=40
gui_elements[1]["caption"]="Tutorials"
gui_elements[1]["fontface"]="arial"
gui_elements[1]["fontsize"]=16
gui_elements[1]["style"]="ultraschall"
gui_elements[1]["leftclickstate"]="unpressed"
gui_elements[1]["rightclickstate"]="unpressed"
gui_elements[1]["middleclickstate"]="unpressed"
gui_elements[1]["hover"]="hover"
gui_elements[1]["opacity"]=1
gui_elements[1]["mode_additive"]=0
gui_elements[1]["mode_sourcealpha"]=0
gui_elements[1]["mode_filtering"]=0
gui_elements[2]={}
gui_elements[2]["visibility"]=true
gui_elements[2]["element_type"]="button"
gui_elements[2]["title"]="testbutton2"
gui_elements[2]["x"]=100
gui_elements[2]["y"]=100
gui_elements[2]["w"]=100
gui_elements[2]["h"]=50
gui_elements[2]["caption"]="anotherdayinparadise"
gui_elements[2]["fontface"]="arial"
gui_elements[2]["fontsize"]=12
gui_elements[2]["style"]="normal"
gui_elements[2]["leftclickstate"]="unpressed"
gui_elements[2]["rightclickstate"]="unpressed"
gui_elements[2]["middleclickstate"]="unpressed"
gui_elements[2]["hover"]="hover"
gui_elements[2]["opacity"]=1
gui_elements[2]["mode_additive"]=0
gui_elements[2]["mode_sourcealpha"]=0
gui_elements[2]["mode_filtering"]=0
gui_elements[3]={}
gui_elements[3]["visibility"]=true
gui_elements[3]["element_type"]="checkbox"
gui_elements[3]["title"]="Checkbox1"
gui_elements[3]["x"]=50
gui_elements[3]["y"]=50
gui_elements[3]["w"]=20
gui_elements[3]["h"]=20
gui_elements[3]["caption"]="Ch_ch_ch_checkitou"
gui_elements[3]["fontface"]="arial"
gui_elements[3]["fontsize"]=12
gui_elements[3]["checked"]=false
gui_elements[3]["style"]="normal"
gui_elements[3]["leftclickstate"]="unpressed"
gui_elements[3]["rightclickstate"]="unpressed"
gui_elements[3]["middleclickstate"]="unpressed"
gui_elements[3]["hover"]="hover"
gui_elements[3]["opacity"]=1
gui_elements[3]["mode_additive"]=0
gui_elements[3]["mode_sourcealpha"]=0
gui_elements[3]["mode_filtering"]=0
gui_elements[4]={}
gui_elements[4]["visibility"]=true
gui_elements[4]["element_type"]="image"
gui_elements[4]["title"]="image"
gui_elements[4]["x"]=50
gui_elements[4]["y"]=50
gui_elements[4]["w"]=20
gui_elements[4]["h"]=20
gui_elements[4]["caption"]="Ultraschall.Graphics"
gui_elements[4]["filename"]="c:\\REAPER5_70_Follow3\\Scripts\\us.png"
gui_elements[4]["slot"]=500
gui_elements[4]["fontface"]="arial"
gui_elements[4]["fontsize"]=12
gui_elements[4]["style"]="normal"
gui_elements[4]["leftclickstate"]="unpressed"
gui_elements[4]["rightclickstate"]="unpressed"
gui_elements[4]["middleclickstate"]="unpressed"
gui_elements[4]["hover"]="hover"
gui_elements[4]["opacity"]=0.4
gui_elements[4]["mode_additive"]=0
gui_elements[4]["mode_sourcealpha"]=0
gui_elements[4]["mode_filtering"]=0
fontsize=12

--reset external states
       reaper.SetExtState("GuiEngine"..GUID, "GuiElement", "", false)
       reaper.SetExtState("GuiEngine"..GUID, "LeftClick", "", false)
       reaper.SetExtState("GuiEngine"..GUID, "RightClick", "", false)
       reaper.SetExtState("GuiEngine"..GUID, "MiddleClick", "", false)
       reaper.SetExtState("GuiEngine"..GUID, "KeyboardFocus", "", false)
--end of debugstuff

gfx.init(Title,WinW,WinH,Dockstate,WinX,WinY)


function LoadGUIFromFile()
  Retval, ExportFilename=reaper.GetUserFileNameForRead(ExportFilename, "Select the Gui-File For Import", "")
  filehandle=io.open(ExportFilename, "r")
  t=1
  if filehandle==nil then reaper.MB("File does not exist","Ooops",0) return end
  gui_elements={}
  for c in filehandle:lines() do
--      reaper.MB(c,"",0)
     if c:match("count=")~=nil then count=tonumber(c:match("=(.*)"))
     elseif c:match("Global")~=nil then
     elseif c:match("GuiElement")~=nil then t=tonumber(c:match("%_(.-)%]")) gui_elements[t]={}
     elseif c:match("visibility=")~=nil then 
        if c:match("=(.*)")=="true" then gui_elements[t]["visibility"]=true else gui_elements[t]["visibility"]=false end
     elseif c:match("checked=")~=nil then 
        if c:match("=(.*)")=="true" then gui_elements[t]["checked"]=true else gui_elements[t]["checked"]=false end
     elseif c:match("=")~=nil then 
        if tonumber(c:match("=(.*)"))~=nil then
          gui_elements[t][c:match("(.-)=")]=tonumber(c:match("=(.*)"))
        else
          gui_elements[t][c:match("(.-)=")]=c:match("=(.*)")
        end
     end
  end
  InitializeElements()
end

function SaveGUIToFile()
  ExportFile=""
  Retval, ExportFilename=reaper.GetUserInputs("Path and Filename for Gui-ExportFile", 1, "Filename with Path", ExportFilename)
  if Retval==true then
    if ExportFilename=="" then Retval, ExportFilename=reaper.GetUserFileNameForRead(ExportFilename, "Select the Gui-File For Export", "") end
    if Retval==false then return end
    ExportFile="[Global]\ncount="..count.."\n\n"
    for i=1, count do
      --all together
      A=i
      ExportFile=ExportFile.."[GuiElement_"..i.."]\n"
      ExportFile=ExportFile.."visibility="..tostring(gui_elements[i]["visibility"]).."\n"
      ExportFile=ExportFile.."element_type="..gui_elements[i]["element_type"].."\n"
      ExportFile=ExportFile.."title="..gui_elements[i]["title"].."\n"
      ExportFile=ExportFile.."x="..gui_elements[i]["x"].."\n"
      ExportFile=ExportFile.."y="..gui_elements[i]["y"].."\n"
      ExportFile=ExportFile.."w="..gui_elements[i]["w"].."\n"
      ExportFile=ExportFile.."h="..gui_elements[i]["h"].."\n"
      ExportFile=ExportFile.."caption="..gui_elements[i]["caption"].."\n"
      ExportFile=ExportFile.."fontface="..gui_elements[i]["fontface"].."\n"
      ExportFile=ExportFile.."fontsize="..gui_elements[i]["fontsize"].."\n"
      ExportFile=ExportFile.."style="..gui_elements[i]["style"].."\n"
      ExportFile=ExportFile.."leftclickstate="..gui_elements[i]["leftclickstate"].."\n"
      ExportFile=ExportFile.."rightclickstate="..gui_elements[i]["rightclickstate"].."\n"
      ExportFile=ExportFile.."middleclickstate="..gui_elements[i]["middleclickstate"].."\n"
      ExportFile=ExportFile.."hover="..gui_elements[i]["hover"].."\n"
      ExportFile=ExportFile.."opacity="..gui_elements[i]["opacity"].."\n"
      ExportFile=ExportFile.."mode_additive="..gui_elements[i]["mode_additive"].."\n"
      ExportFile=ExportFile.."mode_sourcealpha="..gui_elements[i]["mode_sourcealpha"].."\n"
      ExportFile=ExportFile.."mode_filtering="..gui_elements[i]["mode_filtering"].."\n"
    
      --custom made elements
      if gui_elements[i]["checked"]~=nil then ExportFile=ExportFile.."checked="..tostring(gui_elements[i]["checked"]).."\n" end
      if gui_elements[i]["filename"]~=nil then ExportFile=ExportFile.."filename="..gui_elements[i]["filename"].."\n" end
      ExportFile=ExportFile.."\n"
    end
    filehandle=io.open(ExportFilename,"w")
    if filehandle~=nil then filehandle:write(ExportFile) filehandle:close() else reaper.MB("File does not exist.", "Ooops",0) end
  end
end



function GetGFXMode(gui_id)
  return gui_elements[gui_id]["mode_additive"]+gui_elements[gui_id]["mode_sourcealpha"]+gui_elements[gui_id]["mode_filtering"]
end

gfx.setfont(1,"arial", fontsize, 98) 
inverse=true
pressed=false

function InitializeElements()
  for i=1, count do
    if gui_elements[i]["element_type"]=="image" and slotnumber<700 then 
      gui_elements[i]["slot"]=gfx.loadimg(slotnumber, gui_elements[i]["filename"])
      w,h=gfx.getimgdim(gui_elements[i]["slot"])
      gui_elements[i]["w"]=w
      gui_elements[i]["h"]=h
      slotnumber=slotnumber+1 
    end
  end
end

function OpenWindow()
  gfx.init(Title,WinW,WinH,0,WinX,WinY)
end

function Inverse_Rectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse, fillr, fillg, fillb, thickness)
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

function Inverse_RoundRectangle(x,y,w,h, r1, g1, b1, r2, g2, b2, inverse, fillr, fillg, fillb)
  if fillr~=nil and fillg~=nil and fillb~=nil then --and llll=="1" then
    if inverse==false then x=x+2 y=y+2 gfx.set(r2,1,b2) else gfx.set(r1,1,b1) end
--    gfx.set(r2,g2,b2)
--    gfx.rect(x+10,y,w-20,h,1)
--    gfx.circle(x+10,y+10,9.5,1)
--    gfx.circle(x+w-10,y+10,9.5,1) 
            
    gfx.set(fillr, fillg, fillb)
    gfx.rect(x+0.5,y+6.5,w+.5,h-13,1)
    gfx.rect(x+8,y+1.5,w-16,h,1)
    gfx.circle(x+7,y+8,7,1)
    gfx.circle(x+w-8,y+8,7,1)
    gfx.circle(x+w-8,y+h-7,7,1)
    gfx.circle(x+7,y+h-7,7,1)
end

end

function ButtonCaption(x,y,w,h, r1, g1, b1, pressed, string, offset, gui_id)
-- TO DO: Flags!
  gfx.set(r1,g1,b1)
  gfx.setfont(1, gui_elements[gui_id]["fontface"], gui_elements[gui_id]["fontsize"],0)
  if pressed==true then 
    gfx.x=x+offset--+(w/2)
    gfx.y=y+offset--+(h/2)
  else
    gfx.x=x--+(w/2)
    gfx.y=y--+(h/2)
  end
  gfx.drawstr(string,5,x+w,y+h)
end

function DrawGrid_Absolute(gapx, gapy, offsetx, offsety, r,g,b,a)
  gfx.set(0,1,0,0.2,0)
  gfx.line(gfx.w/2,0,gfx.w/2,gfx.h)
  gfx.line(0,gfx.h/2,gfx.w,gfx.h/2)
  gfx.set(r,g,b,a,0)
  gfx.setfont(2,"arial",12,0)
  for x=1+offsetx, gfx.w, gapx do
    for y=1+offsety, gfx.h, gapy do
      gfx.x=x+4
      gfx.y=y
      if y==1+offsety then gfx.set(r,g,b,a*16,0) gfx.drawstr(x) gfx.set(r,g,b,a,0) end
      if x==1+offsetx and y>1+offsety then gfx.set(r,g,b,a*16,0) gfx.drawstr(y) gfx.set(r,g,b,a,0) end
      gfx.line(x,0,x,gfx.h)
      gfx.line(0,y,gfx.w,y)
    end
  end
end


function DrawGrid_Relative(numlinesx, numlinesy, offsetx, offsety, r,g,b,a)
  gapx=gfx.w/numlinesx
  gapy=gfx.h/numlinesy
  DrawGrid_Absolute(gapx,gapy,offsetx,offsety,r,g,b,a)
end

function GetGrid(getx,gety,plusminus)
  retx=-1
  rety=-1
  retval=false
  if Grid=="absolute" then 
    gridgapx=GridGapX
    gridgapy=GridGapY
  elseif Grid=="relative" then
    gridgapx=gfx.w/GridLinesX
    gridgapy=gfx.h/GridLinesY
  else
    return false, -1, -1
  end
  
  for x=1+GridOffsetX, gfx.w, gridgapx do
      for y=1+GridOffsetY, gfx.h, gridgapy do
        if getx>=x-plusminus*Snap and getx<=x+plusminus*Snap then retx=x end
        if gety>=y-plusminus*Snap and gety<=y+plusminus*Snap then rety=y end
      end
  end
  if retx~=-1 and rety~=-1 then
    return true, retx, rety
  else
    if retx==-1 then retx=getx end
    if rety==-1 then rety=gety end
    return false, retx, rety
  end
end


function Convert24BitToColorRGB(integer)
  local r=0
  local g=0
  local b=0
  if integer&1==1 then r=r+1 end
  if integer&2==2 then r=r+2 end
  if integer&4==4 then r=r+4 end
  if integer&8==8 then r=r+8 end
  if integer&16==16 then r=r+16 end
  if integer&32==32 then r=r+32 end
  if integer&64==64 then r=r+64 end
  if integer&128==128 then r=r+128 end
  
  if integer&256==256 then g=g+1 end
  if integer&512==512 then g=g+2 end
  if integer&1024==1024 then g=g+4 end
  if integer&2048==2048 then g=g+8 end
  if integer&4096==4096 then g=g+16 end
  if integer&8192==8192 then g=g+32 end
  if integer&16384==16384 then g=g+64 end
  if integer&32768==32768 then g=g+128 end

  if integer&65536==65536 then b=b+1 end  
  if integer&131072==131072 then b=b+2 end
  if integer&262144==262144 then b=b+4 end
  if integer&524288==524288 then b=b+8 end
  if integer&1048576==1048576 then b=b+16 end
  if integer&2097152==2097152 then b=b+32 end
  if integer&4194304==4194304 then b=b+64 end
  if integer&8388608==8388608 then b=b+128 end
  quot=1/255
  return r,g,b, quot*r, quot*g, quot*b
end


function ConvertColorTo255(r,g,b)
  if tonumber(r)==nil and tonumber(g)==nil and tonumber(b)==nil then return end
  r=r*255
  g=g*255
  b=b*255
  return r,g,b,r+(g*255)+(b*255*255)
end



function ConvertColorFrom255(r,g,b)
  if tonumber(r)==nil and tonumber(g)==nil and tonumber(b)==nil then return end
  return r/255, g/255, b/255
end


function GetTopGuiElementfromSortbuffer()
  gfx.set(1,1,1,1,0,1)
  oldx=gfx.x
  oldy=gfx.y
  gfx.x=gfx.mouse_x
  gfx.y=gfx.mouse_y
--  reaper.ShowConsoleMsg(gfx.getpixel().."\n")
  r,g,b=gfx.getpixel()
  gfx.set(1,1,1,1,0,-1)
  G,H,I,Igui_id=ConvertColorTo255(r,g,b)
--  reaper.ShowConsoleMsg(gui_id.."\n")
  gfx.x=oldx
  gfx.y=oldy
--  gfx.blit(1,1.2,0)
  return Igui_id
end


function DrawButton(pressed, gui_id)
  if gui_elements[gui_id]["element_type"]=="button" then
    if pressed=="pressed" then
      if gui_elements[gui_id]["style"]=="normal" then
        Inverse_Rectangle(gui_elements[gui_id]["x"]+2,gui_elements[gui_id]["y"]+2,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.7,0.7,0.7)
        ButtonCaption(gui_elements[gui_id]["x"]+2,gui_elements[gui_id]["y"]+2,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0, 0, 0, pressed, gui_elements[gui_id]["caption"],1,gui_id)
      elseif gui_elements[gui_id]["style"]=="ultraschall" then
        Inverse_RoundRectangle(gui_elements[gui_id]["x"]+2,gui_elements[gui_id]["y"]+2,gui_elements[gui_id]["w"]+2,gui_elements[gui_id]["h"]+2, 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.4,0.4,0.4)
        ButtonCaption(gui_elements[gui_id]["x"]+2,gui_elements[gui_id]["y"]+4,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.9, 0.9, 0.9, pressed, gui_elements[gui_id]["caption"],4,gui_id)
      end    
    elseif pressed=="unpressed" then
      if gui_elements[gui_id]["style"]=="normal" then
        Inverse_Rectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"],gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.7,0.7,0.7)
        ButtonCaption(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"],gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0, 0, 0, pressed, gui_elements[gui_id]["caption"],1,gui_id)
      elseif gui_elements[gui_id]["style"]=="ultraschall" then
          for l=0, 1 do
            Inverse_RoundRectangle(gui_elements[gui_id]["x"]-1,gui_elements[gui_id]["y"]-l,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 0.7, 0.7, 0.7, inverse, 0,0,0)
            Inverse_RoundRectangle(gui_elements[gui_id]["x"]+l,gui_elements[gui_id]["y"]+l,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 0.7, 0.7, 0.7, inverse, 0,0,0)
          end
          Inverse_RoundRectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"]-2,gui_elements[gui_id]["w"]+1,gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0,0,0)     
          Inverse_RoundRectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"]-1,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.4,0.4,0.4)
          Inverse_RoundRectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"],gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 1, 1, 1, inverse, 0.275,0.275,0.275)
          ButtonCaption(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"]+1,gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.8, 0.8, 0.8, pressed, gui_elements[gui_id]["caption"],4,gui_id)
        end
      end
    end
end

function DrawCheckbox(pressed, gui_id)
  x,y,w,h=GetGuiIDDimensions(gui_id)
  if pressed=="pressed" then
    if gui_elements[gui_id]["style"]=="normal" then
      Inverse_Rectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"],gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 0.7,0.7,0.7, false, 1,1,1)
      if gui_elements[gui_id]["checked"]==true then
        gui_elements[gui_id]["checked"]=false
      else
        gui_elements[gui_id]["checked"]=true
        gfx.set(0,0,0, gui_elements[gui_id]["opacity"],0)
        for i=0, 2 do
          gfx.line(x+w*0.2,y+(h/2)+i,x+(w/2)-2,y+h*0.7+i)
          gfx.line(x+(w/2)-2,y+h*0.7+i,x+w-2-w/25,y+2+h/20+i)
        end
      end
    elseif gui_elements[gui_id]["style"]=="ultraschall" then   
      gfx.set(0.3,0.3,0.3)
      gfx.rect(x,y,w,h,0)
      if gui_elements[gui_id]["checked"]==true then
        gui_elements[gui_id]["checked"]=false
      else
        gui_elements[gui_id]["checked"]=true
        gfx.set(0.8,0.5,0.2)
        ww=w/10
        hh=h/10
        gfx.rect(x+ww*2.5,y+hh*2.5,w-ww-ww-ww-ww-ww,h-hh-hh-hh-hh-hh,1)
      end

    end
  elseif pressed=="unpressed" then
    if gui_elements[gui_id]["style"]=="normal" then
      Inverse_Rectangle(gui_elements[gui_id]["x"],gui_elements[gui_id]["y"],gui_elements[gui_id]["w"],gui_elements[gui_id]["h"], 0.3, 0.3, 0.3, 0.7,0.7,0.7, false, 1,1,1)
      if gui_elements[gui_id]["checked"]==true then
        gfx.set(0,0,0)
        for i=0, 2 do
          gfx.line(x+w*0.2,y+(h/2)+i,x+(w/2)-2,y+h*0.7+i)
          gfx.line(x+(w/2)-2,y+h*0.7+i,x+w-2-w/25,y+2+h/20+i)
        end

      end
    elseif gui_elements[gui_id]["style"]=="ultraschall" then
      gfx.set(0.3,0.3,0.3)
      gfx.rect(x,y,w,h,0)
      if gui_elements[gui_id]["checked"]==true then
        gfx.set(0.8,0.5,0.2)
        ww=w/10
        hh=h/10
        gfx.rect(x+ww*2.5,y+hh*2.5,w-ww-ww-ww-ww-ww,h-hh-hh-hh-hh-hh,1)
      end
    end
  end
end


function DrawImage(gui_id)
  x=gui_elements[gui_id]["x"]
  y=gui_elements[gui_id]["y"]
  gfx.x=gui_elements[gui_id]["x"]
  gfx.y=gui_elements[gui_id]["y"]
  w,h=gfx.getimgdim(gui_elements[gui_id]["slot"])
  if Grid~="" then 
    gfx.rect(gfx.x, gfx.y, gui_elements[gui_id]["w"],gui_elements[gui_id]["h"],0)
  end
  gfx.set(1,1,1,gui_elements[gui_id]["opacity"],GetGFXMode(gui_id),-1)
--  gfx.blit(gui_elements[gui_id]["slot"],1,0)
  gfx.blit(gui_elements[gui_id]["slot"],1,0, 0, 0, w, h, x, y, gui_elements[gui_id]["w"], gui_elements[gui_id]["h"], 0, 0)
  gfx.set(1,1,1,1,0,-1)
end

function GetGuiIDDimensions(gui_id)
  if gui_elements[gui_id]==nil then return -1, -1, -1, -1  end
  return gui_elements[gui_id]["x"], gui_elements[gui_id]["y"], gui_elements[gui_id]["w"], gui_elements[gui_id]["h"]
end

function AddButton()
  temp,L=reaper.GetUserInputs("Name Of The Button", 1, "Name of the Button","")
  if temp==true then
    gui_elements[count+1]={}
    gui_elements[count+1]["visibility"]=true
    gui_elements[count+1]["element_type"]="button"
    gui_elements[count+1]["title"]="testbutton"..count+1
    gui_elements[count+1]["opacity"]=1
    gui_elements[count+1]["x"]=10
    gui_elements[count+1]["y"]=10
    gui_elements[count+1]["w"]=100
    gui_elements[count+1]["h"]=70
    gui_elements[count+1]["caption"]=L
    gui_elements[count+1]["fontface"]="arial"
    gui_elements[count+1]["fontsize"]=12
    gui_elements[count+1]["style"]="normal"
    gui_elements[count+1]["leftclickstate"]="unpressed"
    gui_elements[count+1]["rightclickstate"]="unpressed"
    gui_elements[count+1]["middleclickstate"]="unpressed"
    gui_elements[count+1]["hover"]="none"
    gui_elements[count+1]["mode_additive"]=0
    gui_elements[count+1]["mode_sourcealpha"]=0
    gui_elements[count+1]["mode_filtering"]=0
    count=count+1
  end
end

function AddCheckbox()
  temp,L=reaper.GetUserInputs("Name Of The Checkbox", 1, "Name of the Checkbox","")
  if temp==true then
    gui_elements[count+1]={}
    gui_elements[count+1]["visibility"]=true
    gui_elements[count+1]["element_type"]="checkbox"
    gui_elements[count+1]["title"]="testbutton"..count+1
    gui_elements[count+1]["x"]=10
    gui_elements[count+1]["y"]=10
    gui_elements[count+1]["w"]=20
    gui_elements[count+1]["h"]=20
    gui_elements[count+1]["opacity"]=1
    gui_elements[count+1]["caption"]=L
    gui_elements[count+1]["fontface"]="arial"
    gui_elements[count+1]["fontsize"]=12
    gui_elements[count+1]["style"]="normal"
    gui_elements[count+1]["leftclickstate"]="unpressed"
    gui_elements[count+1]["rightclickstate"]="unpressed"
    gui_elements[count+1]["middleclickstate"]="unpressed"
    gui_elements[count+1]["hover"]="none"
    gui_elements[count+1]["caption"]="Ch_ch_ch_checkitou"
    gui_elements[count+1]["checked"]=false
    gui_elements[count+1]["mode_additive"]=0
    gui_elements[count+1]["mode_sourcealpha"]=0
    gui_elements[count+1]["mode_filtering"]=0
    count=count+1
  end
end

function AddImage()
  temp,L=reaper.GetUserInputs("Name Of The Image", 1, "Name of the Image","")
  if temp==true and L=="" then fileretval, filename = reaper.GetUserFileNameForRead("", "Select Image-File", "") end
  if temp==true and fileretval==true then
    gui_elements[count+1]={}
    gui_elements[count+1]["visibility"]=true
    gui_elements[count+1]["element_type"]="image"
    gui_elements[count+1]["title"]="image"
    gui_elements[count+1]["x"]=50
    gui_elements[count+1]["y"]=50
    gui_elements[count+1]["w"]=20
    gui_elements[count+1]["h"]=20
    gui_elements[count+1]["caption"]="Ultraschall.Graphics"
    gui_elements[count+1]["filename"]=filename
    gui_elements[count+1]["fontface"]="arial"
    gui_elements[count+1]["fontsize"]=12
    gui_elements[count+1]["style"]="normal"
    gui_elements[count+1]["leftclickstate"]="unpressed"
    gui_elements[count+1]["rightclickstate"]="unpressed"
    gui_elements[count+1]["middleclickstate"]="unpressed"
    gui_elements[count+1]["hover"]="hover"
    gui_elements[count+1]["opacity"]=0.4
    gui_elements[count+1]["mode_additive"]=0
    gui_elements[count+1]["mode_sourcealpha"]=0
    gui_elements[count+1]["mode_filtering"]=0
    
    
    gui_elements[count+1]["slot"]=gfx.loadimg(slotnumber, gui_elements[count+1]["filename"])
    w,h=gfx.getimgdim(gui_elements[count+1]["slot"])
    gui_elements[count+1]["w"]=w
    gui_elements[count+1]["h"]=h
    
    slotnumber=slotnumber+1 
    
    count=count+1
  end
end



function main()
  A=gfx.getchar() 
  
  --Debug/Editor Stuff
  gfx.set(BGR,BGG,BGB)
  gfx.rect(0,0,gfx.w, gfx.h,1)

  
  if Grid=="relative" then
--    DrawGrid_Relative(GridLinesX,GridLinesY,GridOffsetX, GridOffsetY,GridR,GridG,GridB,GridA)
    stepsizex=gfx.w/GridLinesX
    stepsizey=gfx.h/GridLinesY
  elseif Grid=="absolute" then
--    DrawGrid_Absolute(GridGapX, GridGapY, GridOffsetX, GridOffsetY, GridR,GridG,GridB,GridA)
    stepsizex=GridGapX
    stepsizey=GridGapY
  else
    stepsizex=20
    stepsizey=20
  end

if Debug==true then
  if a>0 then  
  -- Move object 
  if A==30064 and gfx.mouse_cap&4==0 and gfx.mouse_cap&16==0 then if gfx.mouse_cap&8==8 then gui_elements[a]["y"]=gui_elements[a]["y"]-stepsizey Draw=true else gui_elements[a]["y"]=gui_elements[a]["y"]-1 end end
  if A==1685026670 and gfx.mouse_cap&4==0 and gfx.mouse_cap&16==0 then if gfx.mouse_cap&8==8 then gui_elements[a]["y"]=gui_elements[a]["y"]+stepsizey Draw=true else gui_elements[a]["y"]=gui_elements[a]["y"]+1 end end
  if A==1919379572 and gfx.mouse_cap&4==0 then if gfx.mouse_cap&8==8 then gui_elements[a]["x"]=gui_elements[a]["x"]+stepsizex Draw=true else gui_elements[a]["x"]=gui_elements[a]["x"]+1 end end
  if A==1818584692 and gfx.mouse_cap&4==0 then if gfx.mouse_cap&8==8 then gui_elements[a]["x"]=gui_elements[a]["x"]-stepsizex Draw=true else gui_elements[a]["x"]=gui_elements[a]["x"]-1 end end

  -- Change size of object
  if A==30064 and gfx.mouse_cap&4==4 then if gfx.mouse_cap&8==8 then gui_elements[a]["h"]=gui_elements[a]["h"]-stepsizey Draw=true else gui_elements[a]["h"]=gui_elements[a]["h"]-1 end end
  if A==1685026670 and gfx.mouse_cap&4==4 then if gfx.mouse_cap&8==8 then gui_elements[a]["h"]=gui_elements[a]["h"]+stepsizey Draw=true else gui_elements[a]["h"]=gui_elements[a]["h"]+1 end end
  if A==1919379572 and gfx.mouse_cap&4==4 then if gfx.mouse_cap&8==8 then gui_elements[a]["w"]=gui_elements[a]["w"]+stepsizex Draw=true else gui_elements[a]["w"]=gui_elements[a]["w"]+1 end end
  if A==1818584692 and gfx.mouse_cap&4==4 then if gfx.mouse_cap&8==8 then gui_elements[a]["w"]=gui_elements[a]["w"]-stepsizex Draw=true else gui_elements[a]["w"]=gui_elements[a]["w"]-1 end end
  if A==115 then 
      Retval,Rets=reaper.GetUserInputs("Change Dimensions of Object",4,"x,y,w,h",gui_elements[a]["x"]..","..gui_elements[a]["y"]..","..gui_elements[a]["w"]..","..gui_elements[a]["h"])
      if Retval==true then
        gui_elements[a]["x"]=tonumber(Rets:match("(.-),"))
        gui_elements[a]["y"]=tonumber(Rets:match(".-,(.-),"))
        gui_elements[a]["w"]=tonumber(Rets:match(".-,.-,(.-),"))
        gui_elements[a]["h"]=tonumber(Rets:match(".*,(.*)"))
      end
  end
  -- change fontsize and caption
  if A==43 then gui_elements[a]["fontsize"]=gui_elements[a]["fontsize"]+1 end -- +
  if A==45 then gui_elements[a]["fontsize"]=gui_elements[a]["fontsize"]-1 end -- -
  if A==42 then gui_elements[a]["fontsize"]=gui_elements[a]["fontsize"]+20 end -- +
  if A==95 then gui_elements[a]["fontsize"]=gui_elements[a]["fontsize"]-20 end -- -
  if A==99 then temp,L=reaper.GetUserInputs("Name Of The Button", 1, "Name of the Button","") if temp==true then gui_elements[a]["caption"]=L end end
  
  -- change the objectnr you want to edit
  if A==44 then a=a-1 if a<1 then a=1 end end
  if A==46 then a=a+1 if a>count then a=count end end 
  if A==27 then a=0 end
  
  -- change style
  if A==49 then gui_elements[a]["style"]="normal" end
  if A==50 then gui_elements[a]["style"]="ultraschall" end
  if A==111 then gui_elements[a]["opacity"]=gui_elements[a]["opacity"]+0.01 end
  if A==79 then gui_elements[a]["opacity"]=gui_elements[a]["opacity"]-0.01 end
  if A==112 then gui_elements[a]["mode_additive"]=1 elseif A==80 then gui_elements[a]["mode_additive"]=0 end
  if A==252 then gui_elements[a]["mode_sourcealpha"]=2 elseif A==220 then gui_elements[a]["mode_sourcealpha"]=0 end
  if A==43 then gui_elements[a]["mode_filtering"]=4 elseif A==42 then gui_elements[a]["mode_filtering"]=0 end
  
  -- change visibility
  if A==118 then if gui_elements[a]["visibility"]==true then gui_elements[a]["visibility"]=false else gui_elements[a]["visibility"]=true end end
  if A==102 then temp,L=reaper.GetUserInputs("Name Of The Font", 1, "Name of the Font","") if temp==true then gui_elements[a]["fontface"]=L end end
  
  -- change Keyboard Focus
  if A==100 then if Keyboard_Focus==a then Keyboard_Focus=-1 end table.remove(gui_elements,a) a=0 count=count-1 end

  
  -- change drawing order, the lower an object, the more buried and unclickable it becomes
  if A==30064.0 and gfx.mouse_cap&16==16 and reaper.time_precise()>timeout then if a>1 then temp_table=gui_elements[a] timeout=reaper.time_precise()+0.25 table.remove(gui_elements, a) table.insert(gui_elements, a-1, temp_table) a=a-1 end end
  if A==1685026670.0 and gfx.mouse_cap&16==16 and reaper.time_precise()>timeout then if a<count then temp_table=gui_elements[a] timeout=reaper.time_precise()+0.25 table.remove(gui_elements, a) table.insert(gui_elements, a+1, temp_table) a=a+1 end end
  end  


  -- Duplicate Object
-- needs a proper duplication, as Lua duplicates a reference in a table, not the values  if A==4 then table.insert(gui_elements, count+1, gui_elements[a]) count=count+1 a=count end
  
  --Grid
  if A==103 then if Grid~="relative" then Grid="relative" else Grid="" end end
  if A==327 and SnapPressed==false then SnapPressed=true if Snap==1 then Snap=0 else Snap=1 end end
  if A==0 and gfx.mouse_cap==0 then SnapPressed=false end
  if A==71 then if Grid~="absolute" then Grid="absolute" else Grid="" end end
  if A==7 then 
      Ret1,Ret2=reaper.GetUserInputs("Grid-Settings",11,"Gridcolor Red,GridColor Green,GridColor Blue,GridColor Alpha,# of linesX(relative grid),# of linesY(relative grid),Pix between linesX(absolute grid),Pix between linesY(absolute grid),Grid-OffsetX in pixels,Grid-OffsetY in pixels,Snapoffset in pixels",GridR..","..GridG..","..GridB..","..GridA..","..GridLinesX..","..GridLinesY..","..GridGapX..","..GridGapY..","..GridOffsetX..","..GridOffsetY..","..GridPlusMinus) 
      if Ret1==true then
        GridR=Ret2:match("(.-),")
        GridG=Ret2:match(".-,(.-),")
        GridB=Ret2:match(".-,.-,(.-),")
        GridA=Ret2:match(".-,.-,.-,(.-),")
        GridLinesX=Ret2:match(".-,.-,.-,.-,(.-),")
        GridLinesY=Ret2:match(".-,.-,.-,.-,.-,(.-),")
        GridGapX=Ret2:match(".-,.-,.-,.-,.-,.-,(.-),")
        GridGapY=Ret2:match(".-,.-,.-,.-,.-,.-,.-,(.-),")
        GridOffsetX=Ret2:match(".-,.-,.-,.-,.-,.-,.-,.-,(.-),")
        GridOffsetY=Ret2:match(".-,.-,.-,.-,.-,.-,.-,.-,.-,(.-),")
        GridPlusMinus=Ret2:match(".*,(.*)")
      end
  end
  
  
  
  -- Add Objects
  if A==2 then AddButton() end
  if A==3 then AddCheckbox() end
  if A==9 and gfx.mouse_cap&4==4 then AddImage() end
  
  -- Change Window Properties
  if A==119 then 
    T,TT=reaper.GetUserInputs("Window-size", 4, "X,Y,W,H",WinX..","..WinY..","..WinW..","..WinH)
    if T==true then WinX=TT:match("(.-),") WinY=TT:match(",(.-),") WinW=TT:match(",.-,(.-),") WinH=TT:match(",.-,.-,(.*)") gfx.quit() OpenWindow() end
  end

  --Save/Load
  if A==19 then SaveGUIToFile() end
  if A==12 then LoadGUIFromFile() end
  
  --Toggle Selection-Square
  if A==72 then Highlighting=false end
  if A==104 then Highlighting=true end
  --End Of Debug Stuff
  end
  
  anyelement=false  
  for i=1, count do
      L=GetTopGuiElementfromSortbuffer()
      x,y,w,h=GetGuiIDDimensions(i)
      -- Drag Object 
      if gfx.mouse_cap==5 and a>0 and Grid=="" then 
        if EditDragX==-1 then EditDragX=gfx.mouse_x-gui_elements[a]["x"] end
        if EditDragY==-1 then EditDragY=gfx.mouse_y-gui_elements[a]["y"] end
        gui_elements[a]["x"]=gfx.mouse_x-EditDragX gui_elements[a]["y"]=gfx.mouse_y-EditDragY
      -- Debug/EditStuff Drag Object With Grid Activated
      elseif gfx.mouse_cap==5 and a>0 and Grid~="" then 
        if EditDragX==-1 then EditDragX=gfx.mouse_x-gui_elements[a]["x"] end
        if EditDragY==-1 then EditDragY=gfx.mouse_y-gui_elements[a]["y"] end
        T1,T2,T3=GetGrid(gfx.mouse_x-EditDragX,gfx.mouse_y-EditDragY,GridPlusMinus)
        gui_elements[a]["x"]=T2 gui_elements[a]["y"]=T3 else tudel=false 
        EditDragX=-1 EditDragY=-1
      end
      --End of Debugstuff
      
      if gui_elements[i]["visibility"]==true then
        if gfx.mouse_x>=x and gfx.mouse_x<=x+w and gfx.mouse_y>=y and gfx.mouse_y<=y+h then
          -- Mouse-clicks
          if gfx.mouse_cap==5 then Drag=gfx.mouse_cap DragElement=i tudel=true end
          if gfx.mouse_cap&1==1 and leftclick~=2 and tudel==false and GetTopGuiElementfromSortbuffer()==i then gui_elements[i]["leftclickstate"]="pressed" Keyboard_Focus=i leftclick=1 elseif gfx.mouse_cap&1==0 then gui_elements[i]["leftclickstate"]="unpressed" leftclick=0 end
          if gfx.mouse_cap&2==2 then gui_elements[i]["rightclickstate"]="pressed" Keyboard_Focus=i elseif gfx.mouse_cap&2==0 then gui_elements[i]["rightclickstate"]="unpressed" end
          if gfx.mouse_cap&64==64 then gui_elements[i]["middleclickstate"]="pressed" Keyboard_Focus=i elseif gfx.mouse_cap&64==0 then gui_elements[i]["middleclickstate"]="unpressed" end
          -- Keyboard Modifier
          if gfx.mouse_cap&8==8 then gui_elements[i]["shiftstate"]="pressed" elseif gfx.mouse_cap&8==0 then gui_elements[i]["shiftstate"]="unpressed" end
          if gfx.mouse_cap&4==4 then gui_elements[i]["cmdstate"]="pressed" elseif gfx.mouse_cap&4==0 then gui_elements[i]["cmdstate"]="unpressed" end
          if gfx.mouse_cap&16==16 then gui_elements[i]["altstate"]="pressed" elseif gfx.mouse_cap&16==0 then gui_elements[i]["altstate"]="unpressed" end
          if gfx.mouse_cap&20==20 then gui_elements[i]["altgrstate"]="pressed" elseif gfx.mouse_cap&20==0 then gui_elements[i]["altgrstate"]="unpressed" end
          gui_elements[i]["hover"]="hover"
          anyelement=true
          anyelement_gui_id=i
        else
          -- if mouse leaves button.
          -- To Do: Don't make any other button clickable, when it hasn't been clicked yet.
          -- Still also buggy with checkbox
          
          -- Mouse-clicks
          if gfx.mouse_cap==5 then Drag=gfx.mouse_cap DragElement=i tudel=true end
          if gfx.mouse_cap&1==1 and leftclick~=2 and tudel==false then gui_elements[i]["leftclickstate"]="unpressed" end
          if gfx.mouse_cap&2==2 then gui_elements[i]["rightclickstate"]="pressed" Keyboard_Focus=i elseif gfx.mouse_cap&2==0 then gui_elements[i]["rightclickstate"]="unpressed" end
          if gfx.mouse_cap&64==64 then gui_elements[i]["middleclickstate"]="pressed" Keyboard_Focus=i elseif gfx.mouse_cap&64==0 then gui_elements[i]["middleclickstate"]="unpressed" end
          -- Keyboard Modifier
          if gfx.mouse_cap&8==8 then gui_elements[i]["shiftstate"]="pressed" elseif gfx.mouse_cap&8==0 then gui_elements[i]["shiftstate"]="unpressed" end
          if gfx.mouse_cap&4==4 then gui_elements[i]["cmdstate"]="pressed" elseif gfx.mouse_cap&4==0 then gui_elements[i]["cmdstate"]="unpressed" end
          if gfx.mouse_cap&16==16 then gui_elements[i]["altstate"]="pressed" elseif gfx.mouse_cap&16==0 then gui_elements[i]["altstate"]="unpressed" end
          if gfx.mouse_cap&20==20 then gui_elements[i]["altgrstate"]="pressed" elseif gfx.mouse_cap&20==0 then gui_elements[i]["altgrstate"]="unpressed" end                            
        end


        --debug/editor code        
--        if gfx.mouse_cap~=5 then DragElement=-1 Drag=0 end
        --end of debug code
  end
  
  --Debug/Editor Stuff
  if Draw==true then
    gfx.set(BGR,BGG,BGB)
    gfx.rect(0,0,gfx.w, gfx.h,1)
    if Debug==true then
      if a>0 then
      gfx.set(1,0,0)
      gfx.setfont(1,"arial", 13, 98)
      gfx.x=gfx.w-134 gfx.y=0
      gfx.drawstr("Number of Buttons#: "..count.."\n")
      gfx.x=gfx.w-134 gfx.y=10
      gfx.drawstr("Editing Button#: "..a.."\n")
      gfx.x=gfx.w-128 gfx.y=30
      gfx.drawstr("Visible(V): "..tostring(gui_elements[a]["visibility"]).."\n")
      gfx.x=gfx.w-128 gfx.y=40
      gfx.drawstr("Element_Type:"..gui_elements[a]["element_type"].."\n")
      gfx.x=gfx.w-128 gfx.y=50
      gfx.drawstr("X(<- ->): "..gui_elements[a]["x"].."\n")
      gfx.x=gfx.w-128 gfx.y=60
      gfx.drawstr("Y(/\\ \\/): "..gui_elements[a]["y"].."\n")
      gfx.x=gfx.w-128 gfx.y=70
      gfx.drawstr("W(Cmd+L/R): "..gui_elements[a]["w"].."\n")
      gfx.x=gfx.w-128 gfx.y=80
      gfx.drawstr("H(Cmd+UpDn): "..gui_elements[a]["h"].."\n")
      gfx.x=gfx.w-128 gfx.y=90
      gfx.drawstr("Caption(C): "..gui_elements[a]["caption"].."\n")
      gfx.x=gfx.w-128 gfx.y=100
      gfx.drawstr("Font-Face: "..gui_elements[a]["fontface"].."\n")
      gfx.x=gfx.w-128 gfx.y=110
      gfx.drawstr("Font-Size(+/-): "..gui_elements[a]["fontsize"].."\n")
      gfx.x=gfx.w-128 gfx.y=120
      gfx.drawstr("Gui-Style(1,2): "..gui_elements[a]["style"].."\n")
      gfx.x=gfx.w-128 gfx.y=130
      gfx.drawstr("Leftclick: "..gui_elements[a]["leftclickstate"].."\n")
      gfx.x=gfx.w-128 gfx.y=140
      gfx.drawstr("RightClick: "..gui_elements[a]["rightclickstate"].."\n")
      gfx.x=gfx.w-128 gfx.y=150
      gfx.drawstr("MiddleClick: "..gui_elements[a]["middleclickstate"].."\n")
      gfx.x=gfx.w-128 gfx.y=160
      gfx.drawstr("Hover: "..gui_elements[a]["hover"].."\n")
      gfx.x=gfx.w-128 gfx.y=170
      gfx.drawstr("Title :"..gui_elements[a]["title"].."\n")  
      gfx.x=gfx.w-128 gfx.y=190
      gfx.drawstr("Opacity(O/Shift-O) :"..gui_elements[a]["opacity"].."\n")  
      gfx.x=gfx.w-128 gfx.y=200
      if gui_elements[a]["mode_additive"]==0 then gfx.drawstr("Additive (P/Shift-P): Off") else gfx.drawstr("Additive (P/Shift-P): On") end
      gfx.x=gfx.w-128 gfx.y=210
      if gui_elements[a]["mode_sourcealpha"]==0 then gfx.drawstr("SourceAlpha (Ü/Shift-Ü): Off") else gfx.drawstr("SourceAlpha (Ü/Shift-Ü): On") end
      gfx.x=gfx.w-128 gfx.y=220
      if gui_elements[a]["mode_filtering"]==0 then gfx.drawstr("Filtering (+/*): On") else gfx.drawstr("Filtering (+/*): Off") end
    end    
  end
    
    if Grid=="relative" then
      DrawGrid_Relative(GridLinesX,GridLinesY,GridOffsetX, GridOffsetY,GridR,GridG,GridB,GridA)
    elseif Grid=="absolute" then
      DrawGrid_Absolute(GridGapX, GridGapY, GridOffsetX, GridOffsetY, GridR,GridG,GridB,GridA)
    end
  end
  
  for i=1, count do
--        if Draw=="tudelu" or (WinW~=gfx.w or WinH~=gfx.h) then
          -- Draw Buttons
          if gui_elements[i]["element_type"]=="button" then
            if gui_elements[i]["leftclickstate"]=="pressed" then DrawButton("pressed", i) else DrawButton("unpressed", i) end      
          end
          -- Draw Checkboxes
          if gui_elements[i]["element_type"]=="checkbox" then
            if gui_elements[i]["leftclickstate"]=="pressed" and leftclick~=2 then DrawCheckbox("pressed", i) leftclick=2 else DrawCheckbox("unpressed", i) end      
          end
          -- Draw Images
          if gui_elements[i]["element_type"]=="image" then DrawImage(i) end
          
          --sorting buffer
          gfx.set(1,1,1,1,0,1)
          local A1,A2,A3,A4,A5,A6=Convert24BitToColorRGB(i)
          gfx.set(A4,A5,A6,1,0,1)
          x,y,w,h=GetGuiIDDimensions(i)
          gfx.rect(x,y,w,h,1)
          x,y=gfx.mouse_x,gfx.mouse_y
          gfx.x=x
          gfx.y=y
          D,E,F=gfx.getpixel()
          gfx.set(1,1,1,1,0,-1)
          
          -- refreshing window-coordinates
          WinW=gfx.w
          WinH=gfx.h
          gfx.setimgdim(1,WinW,WinH)
        end    
--    end
          
    --debugstuff/editing of elements
    if gui_elements[i]["leftclickstate"]=="pressed" then a=i end -- when element has been clicked, change editing ID (a) to the current element
    --end of debug stuff
      
  end
  --debugstuff/editing of elements
    -- Show Boundary-square around selected objects 
    if a>=1 and Highlighting==true then 
      gfx.set(1,1,0,0.3,0) 
      gfx.rect(gui_elements[a]["x"]-4,gui_elements[a]["y"]-4,gui_elements[a]["w"]+8,gui_elements[a]["h"]+8,0) 
      
      gfx.rect(gui_elements[a]["x"]-6,gui_elements[a]["y"]+(gui_elements[a]["h"]/2),5,3,1)
      gfx.rect(gui_elements[a]["x"]+gui_elements[a]["w"]+1,gui_elements[a]["y"]+(gui_elements[a]["h"]/2),5,3,1)

      gfx.rect(gui_elements[a]["x"]+(gui_elements[a]["w"]/2)-2,gui_elements[a]["y"]-5,5,4,1)
      gfx.rect(gui_elements[a]["x"]+(gui_elements[a]["w"]/2)-2,gui_elements[a]["y"]+gui_elements[a]["h"]+2,6,4,1)
    end

    if anyelement==false and gfx.mouse_cap&2==2 then 
      T,TT=reaper.GetUserInputs("Background Color", 3, "R(0-1),G(0-1),B(0-1)",BGR..","..BGG..","..BGB) 
      if T==true then BGR=TT:match("(.-),") BGG=TT:match(",(.-),") BGB=TT:match(",.-,(.*)") else BGR=0.15 BGG=0.15 BGB=0.15 end
    end
    --end of debugtuff
    
      if anyelement==false then
        reaper.SetExtState("GuiEngine"..GUID, "GuiElement", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "element_type", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "LeftClick", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "RightClick", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "MiddleClick", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "AltState", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "ShiftState", "", false)
        reaper.SetExtState("GuiEngine"..GUID, "CmdState", "", false)
        if gfx.mouse_cap&1==1 then
          Keyboard_Focus=-1
          reaper.SetExtState("GuiEngine"..GUID, "KeyboardFocus", "", false)
        end
      else
        reaper.SetExtState("GuiEngine"..GUID, "GuiElement", gui_elements[anyelement_gui_id]["title"], false)
        reaper.SetExtState("GuiEngine"..GUID, "ElementType", gui_elements[anyelement_gui_id]["element_type"], false)
        reaper.SetExtState("GuiEngine"..GUID, "LeftClick", gui_elements[anyelement_gui_id]["leftclickstate"], false)
        reaper.SetExtState("GuiEngine"..GUID, "RightClick", gui_elements[anyelement_gui_id]["rightclickstate"], false)
        reaper.SetExtState("GuiEngine"..GUID, "MiddleClick", gui_elements[anyelement_gui_id]["middleclickstate"], false)
        reaper.SetExtState("GuiEngine"..GUID, "AltState", gui_elements[anyelement_gui_id]["altstate"], false)
        reaper.SetExtState("GuiEngine"..GUID, "ShiftState", gui_elements[anyelement_gui_id]["shiftstate"], false)
        reaper.SetExtState("GuiEngine"..GUID, "CmdState", gui_elements[anyelement_gui_id]["cmdstate"], false)
       
        if Keyboard_Focus~=-1 then reaper.SetExtState("GuiEngine"..GUID, "KeyboardFocus", gui_elements[Keyboard_Focus]["title"], false)
        else reaper.SetExtState("GuiEngine"..GUID, "KeyboardFocus", "", false) end     
      end
  --]]
  gfx.x=1
  gfx.y=1
    gfx.update()
  if A~=-1 then reaper.defer(main) end
end

InitializeElements()

main()
