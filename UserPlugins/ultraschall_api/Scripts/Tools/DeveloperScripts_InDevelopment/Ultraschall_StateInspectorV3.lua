if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

gfx.clear=1315860
gfx.init("Ultraschall State Inspector v3", 600, 400)
gfx.setfont(1, "Tahoma", 15, 0)
gfx.setfont(2, "Tahoma", 15, 0)
gfx.setfont(3, "Tahoma", 15, 66)

MenuEntries={}
MenuEntries[1]="Load|Save|Quit"
MenuEntries[2]="Load|Quit"
MenuEntries[3]="State List|StateChunk Editor"
ContentView=0

StateListFontsize=15
ListOffset=1
MaxListLength=9
StateList={}
StateList[1]={"Ext",     "section",  "key", ""}
StateList[2]={"ProjExt", "section",  "key", ""}
StateList[3]={"IniFiles",  "filename", "section", "key"}
StateList[4]={"GMem",     "shared name",  "index",   ""}
StateList[5]={"Toggle", "section", "key", ""}
StateList[6]={"Ext", "section", "key", ""}
StateList[7]={"Ext", "section", "key", ""}
StateList[8]={"Ext", "section", "key", ""}
StateList[9]={"Ext", "section", "key", ""}


function DrawMenu(clickstate)
  local MenuSelection=0
  local Menu=0
  local Menutext_xoffset=30
  local Menutext_yoffset=2
  -- menubar
  gfx.setfont(1)
  gfx.set(0.35)
  gfx.rect(0, 0, gfx.w, gfx.texth+4)
  MenuHeight=gfx.texth
  gfx.set(1)
  gfx.x=10 gfx.y=Menutext_yoffset
  gfx.drawstr("File")
  gfx.x=10+Menutext_xoffset   gfx.y=Menutext_yoffset
  gfx.drawstr("Edit")
  gfx.x=10+Menutext_xoffset*2 gfx.y=Menutext_yoffset
  gfx.drawstr("View")
  
  -- dropdownmenu
  if clickstate>0 then
    if      gfx.mouse_x>10                    and gfx.mouse_x<10+Menutext_xoffset    then Menu=1 MenuOpenX=10                    -- File
    elseif  gfx.mouse_x>10+Menutext_xoffset   and gfx.mouse_x<10+Menutext_xoffset*2  then Menu=2 MenuOpenX=10+Menutext_xoffset   -- Edit
    elseif  gfx.mouse_x>10+Menutext_xoffset*2 and gfx.mouse_x<10+Menutext_xoffset*3  then Menu=3 MenuOpenX=10+Menutext_xoffset*2 -- View
    end
    if Menu>0 then
      gfx.x=MenuOpenX-6
      gfx.y=gfx.texth+4
      MenuSelection=gfx.showmenu(MenuEntries[Menu])
    end
  end  
  
  gfx.x=170 gfx.y=Menutext_yoffset
  gfx.drawstr(clickstate.." "..Menu)
  return Menu, MenuSelection
end

function ShowStateList(Key)
  if Key~= 0            then print3(Key) end
  if Key== 30064.0      then ListOffset=ListOffset-1 if ListOffset<1 then ListOffset=1 end end -- Up  Key
  if Key== 1685026670.0 then ListOffset=ListOffset+1 if ListOffset>MaxListLength then ListOffset=MaxListLength end end -- DownKey
  if Key== 43.0 then -- + key -> bigger fonts
    StateListFontsize=StateListFontsize+1
    if StateListFontsize>20 then StateListFontsize=20 end
    gfx.setfont(3, "Tahoma", StateListFontsize, 0) 
    gfx.setfont(2, "Tahoma", StateListFontsize, 0) 
  end
  if Key== 45.0 then -- - key -> smaller fonts
    StateListFontsize=StateListFontsize-1
    if StateListFontsize<10 then StateListFontsize=10 end
    gfx.setfont(3, "Tahoma", StateListFontsize, 0) 
    gfx.setfont(2, "Tahoma", StateListFontsize, 0) 
  end
  -- StateList  
  local function DrawList()
    local Listoffsety=80
    local Listoffsetx=30
    gfx.set(0.6)
    I2=0
    for i=0, 120 do
      gfx.line(Listoffsetx, Listoffsety+(gfx.texth+4)*i, gfx.w-Listoffsetx, Listoffsety+ (gfx.texth+4)*i)
      gfx.x=Listoffsetx+4 gfx.y=Listoffsety+(gfx.texth+4)*i
      if Listoffsety+(gfx.texth+4)*i>gfx.h-30 then break end
      if I2>MaxListLength-ListOffset then break end
      gfx.setfont(2) gfx.drawstr(ListOffset+I2)
      gfx.x=Listoffsetx+38
      if StateList[ListOffset+I2][1]:lower()=="toggle" then
        gfx.set(1,0.5,0.5)
      elseif StateList[ListOffset+I2][1]:lower()=="ext" then
        gfx.set(1,0,0)
      elseif StateList[ListOffset+I2][1]:lower()=="projext" then
        gfx.set(1,0.4,0)
      elseif StateList[ListOffset+I2][1]:lower()=="gmem" then
        gfx.set(1,1,0)
      elseif StateList[ListOffset+I2][1]:lower()=="inifiles" then
        gfx.set(0,1,0)
      end
      gfx.setfont(3) gfx.drawstr(StateList[ListOffset+I2][1]..": ", 67)
      gfx.set(0.6)
      gfx.setfont(2) gfx.drawstr(StateList[ListOffset+I2][2].." -> "..StateList[ListOffset+I2][3])
      I2=I2+1
    end
    gfx.line(Listoffsetx, Listoffsety, Listoffsetx, Listoffsety+(gfx.texth+4)*I2)             -- leftborder
    gfx.line(Listoffsetx+35, Listoffsety, Listoffsetx+35, Listoffsety+(gfx.texth+4)*I2)       -- number edge
    gfx.line(Listoffsetx+280, Listoffsety, Listoffsetx+280, Listoffsety+(gfx.texth+4)*I2)     -- state-value-border
    gfx.line(gfx.w-Listoffsetx, Listoffsety, gfx.w-Listoffsetx, Listoffsety+(gfx.texth+4)*I2) -- rightborder
  end
  
  DrawList()
end

function StateChunk_Editor()
  print_update("StateChunk Editor")
end

function QuitMe()
  gfx.quit()
end

function LoadState()
end

function SaveState()
end

function main()
  if gfx.mouse_cap&1==1 and gfx.mouse_y<MenuHeight and gfx.mouse_x>0 then MenuMode=1 end
  local Key=gfx.getchar()
  if Key==27.0 then QuitMe() end
  
  MenuSelection, Selection = DrawMenu(MenuMode)
  if MenuSelection==1 and Selection>0 then LoadState() end -- load
  if MenuSelection==1 and Selection>1 then SaveState() end -- save
  if MenuSelection==1 and Selection>2 then QuitMe()    end -- quit
  
  if MenuSelection==3 and Selection>0 then ContentView=Selection-1 end
      
  if     ContentView==0 then -- StateList
    ShowStateList(Key)
  elseif ContentView==1 then -- StateChunk Editor
    StateChunk_Editor()
  elseif ContentView==2 then 

  elseif ContentView==3 then 
  
  elseif ContentView==4 then
  
  end
  
  MenuMode=0
  
  if gfx.getchar()~=-1 then 
    L=reaper.time_precise()
    reaper.defer(main) 
  end
end

MenuMode=0
main()

