--[[
################################################################################
# 
# Copyright (c) 2014-2023 Ultraschall (http://ultraschall.fm)
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

-- monitors the theme-parameter-values of the current theme and allows manipulating them
-- hit h for help
--
-- Meo-Ada Mespotine 1.0 27th of June 2020
--                   1.1 26th of August 2024

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

fontsize=12
gfx.setfont(2, "arial", fontsize)
gfx.setfont(3, "arial", fontsize, 73)
_, HWND = ultraschall.GFX_Init("Ultraschall Theme Parameters-Monitor")
--gfx.setimgdim(2, 2048, 2048)
A=""

index, ThemeLayoutParameters = ultraschall.GetAllThemeLayoutParameters()
ThemeLayoutParameters_updated={}
ThemeLayoutParameters_updated2={}
for i=1, index do
  ThemeLayoutParameters_updated[i]=0
end
for i=1, index do
  ThemeLayoutParameters_updated2[i]=0
end

function UpdateThemeParameters()
  path, theme_filename = ultraschall.GetPath(reaper.GetLastColorThemeFile())
  if old_filename~=theme_filename then
    old_filename=theme_filename
    upd=0
    refreshcounter=0
  end
  Newindex, NewThemeLayoutParameters = ultraschall.GetAllThemeLayoutParameters()
  local updated2
  if Newindex~=index then
    index=Newindex
    for i=1, index do
      ThemeLayoutParameters_updated[i]=0
      ThemeLayoutParameters_updated2[i]=0
      ThemeLayoutParameters=nil
    end
  else
    for i=1, index do
      if ThemeLayoutParameters[i]["value"]~=NewThemeLayoutParameters[i]["value"] then
        ThemeLayoutParameters_updated2[i]=1
        updated=1
        updated2=1
      end
    end
    if updated==1 then
      ThemeLayoutParameters_updated=ThemeLayoutParameters_updated2
    end
    updated=0
    ThemeLayoutParameters_updated2={}
    for i=1, index do
      ThemeLayoutParameters_updated2[i]=0
    end
  end
  ThemeLayoutParameters=NewThemeLayoutParameters
  return updated2
end


current_slot=1
function ShowParameters()
  AA=os.time()
  gfx.dest=-1
  gfx.setfont(3, "arial", fontsize, 73)
  gfx.set(0)
  gfx.rect(0,0,2048,2048,1)
  gfx.x=0
  gfx.y=3
  gfx.set(1)
  gfx.drawstr("Ultraschall Theme-Parameters Monitor v1.1 - Meo-Ada Mespotine -> H for Help")
  gfx.x=8
  gfx.y=gfx.texth+4
  path, filename = ultraschall.GetPath(reaper.GetLastColorThemeFile())
  gfx.drawstr("Loaded Theme: "..filename)
  gfx.x=0
  gfx.y=gfx.texth+gfx.texth+5
  if index==-1 then tindex=0 else tindex=index end
  gfx.drawstr("There are "..(tindex).." Parameters available.")
  if index>=0 then
    gfx.x=0+hwheel
    local yoffset=30
    gfx.y=gfx.texth+gfx.texth+yoffset
    local xoffset=0
    local xoffset2=230
    for i=1, index do
      if i==current_slot then mark=">" else mark="  " end
      gfx.set(0.5,0.5,0.5,0.04)
      gfx.line(0, gfx.y+(gfx.texth/2), 1000000, gfx.y+(gfx.texth/2))
      gfx.set(0.7)
      
      gfx.drawstr(mark..i..": ")
      if ThemeLayoutParameters_updated[i]==1 then gfx.set(0,0.7,1) else gfx.set(1) end
      gfx.drawstr(ThemeLayoutParameters[i]["name"]..": \"")
      gfx.setfont(3)
      local desc=ThemeLayoutParameters[i]["description"]:sub(1,50-ThemeLayoutParameters[i]["name"]:len())
      if desc:len()<ThemeLayoutParameters[i]["description"]:len() then desc=desc.."..." end
      gfx.drawstr(desc)
      if ThemeLayoutParameters_updated[i]==1 then gfx.set(0,0.7,1,1) else gfx.set(1) end
      gfx.drawstr("\"")
      gfx.set(0.5,0.7,0.5)
      gfx.setfont(2)
      gfx.x=0+xoffset2+xoffset+40+hwheel
      gfx.drawstr(" ("..ThemeLayoutParameters[i]["value min"].." - "..ThemeLayoutParameters[i]["value max"])
      gfx.x=0+xoffset2+xoffset+88+hwheel
      gfx.drawstr("Def:"..ThemeLayoutParameters[i]["value default"]..")")
      gfx.x=0+xoffset2+xoffset+132+hwheel
      gfx.drawstr(ThemeLayoutParameters[i]["value"])
      if gfx.y+gfx.texth+gfx.texth+2>gfx.h then gfx.y=gfx.texth+yoffset-2 xoffset=xoffset+395 end
      gfx.y=gfx.y+gfx.texth+2
      gfx.x=0+xoffset+hwheel
    end
  end
  gfx.dest=-1
end

hwheel=0
refreshcounter=0

function main()
  Key=gfx.getchar()
  if Key~=0 then refreshcounter=0 end
  if Key==1685026670.0 then current_slot=current_slot+1 end -- next slot
  if Key==30064.0 then current_slot=current_slot-1 end      -- previous slot
  if current_slot<1 then current_slot=1 end
  if current_slot>=index then current_slot=index end
  
  -- stepsize 1
  if Key==1919379572.0 and gfx.mouse_cap==0 then -- add val
    A=reaper.ThemeLayout_SetParameter(current_slot, ThemeLayoutParameters[current_slot]["value"]+1, false) 
    reaper.ThemeLayout_RefreshAll()
  end
  if Key==1818584692.0 and gfx.mouse_cap==0 then -- dec val
    reaper.ThemeLayout_SetParameter(current_slot, ThemeLayoutParameters[current_slot]["value"]-1, false)
    reaper.ThemeLayout_RefreshAll()
  end
  -- stepsize 10
  if Key==1919379572.0 and gfx.mouse_cap==4 then -- add val
    A=reaper.ThemeLayout_SetParameter(current_slot, ThemeLayoutParameters[current_slot]["value"]+10, false) 
    reaper.ThemeLayout_RefreshAll()
  end
  if Key==1818584692.0 and gfx.mouse_cap==4 then -- dec val
    reaper.ThemeLayout_SetParameter(current_slot, ThemeLayoutParameters[current_slot]["value"]-10, false)
    reaper.ThemeLayout_RefreshAll()
  end
  
  --if Key==43.0 then fontsize=fontsize+1 gfx.setfont(2, "arial", fontsize) gfx.setfont(3, "arial", fontsize, 73) end -- bigger font
  --if Key==45.0 then fontsize=fontsize-1 gfx.setfont(2, "arial", fontsize) gfx.setfont(3, "arial", fontsize, 73) end -- smaller font
  --if fontsize<12 then fontsize=12 end
  --if fontsize>15 then fontsize=15 end
  
  if Key==13.0 then -- enter new value
    local retval, value = reaper.GetUserInputs("Enter value for "..ThemeLayoutParameters[current_slot]["description"], 1, "New Value", ThemeLayoutParameters[current_slot]["value"]) 
    if retval==true and math.type(tonumber(value))~="integer" then reaper.MB("You must input an integer-number!", "Ooops", 0) 
    else reaper.ThemeLayout_SetParameter(current_slot, tonumber(value), false)
    end
    reaper.ThemeLayout_RefreshAll()
    reaper.JS_Window_SetFocus(HWND)
  end
  if Key==27.0 then gfx.quit() return end -- quit script
  if gfx.mouse_cap==0 and Key==8.0 then reaper.ThemeLayout_SetParameter(current_slot, ThemeLayoutParameters[current_slot]["value default"], false) reaper.ThemeLayout_RefreshAll() end -- reset to default
  if gfx.mouse_cap&4==4 and Key==8.0 then -- reset all to defaults
    retval=reaper.MB("This resets all values to their default ones. Shall I continue?", "Really reset all?", 4)
    if retval==6 then
      for i=1, index do
        reaper.ThemeLayout_SetParameter(i, ThemeLayoutParameters[i]["value default"], false) 
      end
    end
    reaper.ThemeLayout_RefreshAll()
    reaper.JS_Window_SetFocus(HWND)
  end
  if unused==true and Key==99.0 then -- commits current values to theme
    retval=reaper.MB("This will commit all current values permanently to the theme. Shall I continue?", "Really commit them all?", 4)
    if retval==6 then
      for i=1, index do
        reaper.ThemeLayout_SetParameter(i, ThemeLayoutParameters[i]["value"], true) 
      end
    end
    reaper.ThemeLayout_RefreshAll()
    reaper.JS_Window_SetFocus(HWND)
  end
  if Key==104.0 then -- help 
  reaper.MB([[
Ultraschall Theme-Parameters Monitor v1.1 (26th of August 2023) - Help

This allows you to monitor the theme parameters the current theme has.

The list has

  indexnumber: paramtitle: "description"   (min - max Def:default)   current

If one or more are changed, they will be highlighted in blue.

If the list doesn't fit the whole window, use mousewheel to scroll left and right.

You can also set the parameter-values yourself:
  up/down - select the parameter
  left/right - decrease/increase the value by 1
  Ctrl+left/Ctrl+right - decrease/increase the value by 10
  
  Enter - allows you to enter a new value
  
  Backspace - resets parameter-value to its default one
  Ctrl+Backspace - resets ALL parameter-values to their default ones

Esc - closes and quits this script

H - shows this help

    ]],"Help", 0) 
  reaper.JS_Window_SetFocus(HWND)
  end
    
--  if Key~=0 then print3(Key) end
  -- mousewheel scrolls list left/right
  
  

  -- update list and show it
  
  
  upd=UpdateThemeParameters()
  gfx.x=0
  gfx.y=0
  hwheel=hwheel-gfx.mouse_hwheel/40
  hwheel=hwheel+gfx.mouse_wheel/40
  --if hwheel<-1400 then hwheel=-1400 end
  if hwheel>0 then hwheel=0 end
  if gfx.mouse_wheel~=0 or gfx.mouse_hwheel~=0 then upd=1 end
  gfx.mouse_hwheel=0
  gfx.mouse_wheel=0
  
  if upd==1 or refreshcounter==0 then ShowParameters() shown=true end
  --if upd==1 then AAA=upd end
  AAA=upd
  refreshcounter=1
--  if refreshcounter>30 then refreshcounter=0 end
  -- show list
  --gfx.blit(2,1,0)
  gfx.update()
  if Key~=-1 then reaper.defer(main) end
end

main()
