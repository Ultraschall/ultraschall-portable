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

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---         Color Module          ---
-------------------------------------

function ultraschall.ConvertColor(r,g,b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer colorvalue, boolean retval = ultraschall.ConvertColor(integer r, integer g, integer b)</functioncall>
  <description>
    converts r, g, b-values to native-system-color. Works like reaper's ColorToNative, but doesn't need |0x1000000 added.

    returns color-value 0, and retval=false in case of an error
  </description>
  <retvals>
    integer colorvalue - the native-system-color; 0 to 33554431
  </retvals>
  <parameters>
    integer r - the red colorvalue
    integer g - the green colorvalue
    integer b - the blue colorvalue
  </parameters>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>helper functions, color, native, convert, red, gree, blue</tags>
</US_DocBloc>
]]
    if math.type(r)~="integer" then ultraschall.AddErrorMessage("ConvertColor","r", "only integer allowed", -1) return 0, false end
    if math.type(g)~="integer" then ultraschall.AddErrorMessage("ConvertColor","g", "only integer allowed", -2) return 0, false end
    if math.type(b)~="integer" then ultraschall.AddErrorMessage("ConvertColor","b", "only integer allowed", -3) return 0, false end
    return reaper.ColorToNative(r,g,b)|0x1000000, true
end

ultraschall.planned_marker_color=ultraschall.ConvertColor(100,255,0)

function ultraschall.ConvertColorReverse(color)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorReverse</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer r, integer g, integer b, boolean retval = ultraschall.ConvertColorReverse(integer colorvalue)</functioncall>
  <description>
    converts a native-system-color to r, g, b-values.
    
    returns 0,0,0,false in case of an error
  </description>
  <retvals>
    integer r - the red colorvalue
    integer g - the green colorvalue
    integer b - the blue colorvalue
    boolean retval - true, color-conversion was successful; false, color-conversion was unsuccessful
  </retvals>
  <parameters>
    integer colorvalue - the native-system-color; 0 to 33554431
  </parameters>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>helper functions, color, native, convert, red, gree, blue</tags>
</US_DocBloc>
]]
    if math.type(color)~="integer" then ultraschall.AddErrorMessage("ConvertColorReverse", "color", "only integer allowed", -1) return  0, 0, 0, false end
    if color<0 or color>33554431 then ultraschall.AddErrorMessage("ConvertColorReverse", "color", "must be between 0 and 33554431", -2) return  0, 0, 0, false end
    
    local a,b,c=reaper.ColorFromNative(color)
    return a,b,c, true
end


function ultraschall.RGB2Grayscale(red,green,blue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RGB2Grayscale</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer graycolor = ultraschall.RGB2Grayscale(integer red, integer green, integer blue)</functioncall>
  <description>
    converts rgb to a grayscale value. Works native on Mac as well on Windows, no color conversion needed.
    
    returns nil in case of an error
  </description>
  <parameters>
    integer red - red-value between 0 and 255.
    integer green - red-value between 0 and 255.
    integer blue - red-value between 0 and 255.
  </parameters>
  <retvals>
    integer graycolor  - the gray color-value, generated from red,blue and green.
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>colorvalues,rgb,gray,grayscale,grey,greyscale</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(red)~="integer" then ultraschall.AddErrorMessage("RGB2Grayscale","red".."only integer is allowed", -1) return nil end
  if math.type(green)~="integer" then ultraschall.AddErrorMessage("RGB2Grayscale","green".."only integer is allowed", -2) return nil end
  if math.type(blue)~="integer" then ultraschall.AddErrorMessage("RGB2Grayscale","blue".."only integer is allowed", -3) return nil end

  if red<0 or red>255 then ultraschall.AddErrorMessage("RGB2Grayscale","red", "must be between 0 and 255", -4) return nil end
  if green<0 or green>255 then ultraschall.AddErrorMessage("RGB2Grayscale","green", "must be between 0 and 255", -5) return nil end
  if blue<0 or blue>255 then ultraschall.AddErrorMessage("RGB2Grayscale","blue", "must be between 0 and 255", -6) return nil end

  -- do the legend of the grayscale and return it's resulting colorvalue
  local gray=red+green+blue
  gray=ultraschall.RoundNumber(gray/3)
  local gray_color=reaper.ColorToNative(gray,gray,gray)
  return ultraschall.RoundNumber(gray_color)
end


function ultraschall.ConvertColorToGFX(r,g,b,a)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorToGFX</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number r, number g, number b, number a = ultraschall.ConvertColorToGFX(integer r, integer g, integer b, integer a)</functioncall>
  <description>
    converts red,green,blue,alpha-values from 0-255 range to 0-1 range, so these values can be used by Reaper-Lua's gfx.functions().
    
    supports negative-values up from -255 to +255, so you can use the function as well for subtraction of colorvalues.
    
    returns nil in case of error
  </description>
  <parameters>
    integer r - the red-color-value between -255 and +255
    integer g - the green-color-value between -255 and +255
    integer b - the blue-color-value between -255 and +255
    integer a - the alpha-color-value between -255 and +255
  </parameters>
  <retvals>
    number r - the converted red-value between -1 and +1; nil in case of error
    number g - the converted green-value between -1 and +1
    number b - the converted blue-value between -1 and +1
    number a - the converted alpha-value between -1 and +1
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>helper functions, convert, red, green, blue, alpha, color, gfx</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(r)~="integer" then ultraschall.AddErrorMessage("ConvertColorToGFX","r", "must be an integer", -1)  return end
  if math.type(g)~="integer" then ultraschall.AddErrorMessage("ConvertColorToGFX","g", "must be an integer", -2)  return end
  if math.type(b)~="integer" then ultraschall.AddErrorMessage("ConvertColorToGFX","b", "must be an integer", -3)  return end
  if math.type(a)~="integer" then ultraschall.AddErrorMessage("ConvertColorToGFX","a", "must be an integer", -4)  return end
  if r<-255 or r>255 then ultraschall.AddErrorMessage("ConvertColorToGFX","r", "must be between -255 and 255", -5)  return end
  if g<-255 or g>255 then ultraschall.AddErrorMessage("ConvertColorToGFX","g", "must be between -255 and 255", -6)  return end
  if b<-255 or b>255 then ultraschall.AddErrorMessage("ConvertColorToGFX","b", "must be between -255 and 255", -7)  return end
  if a<-255 or a>255 then ultraschall.AddErrorMessage("ConvertColorToGFX","a", "must be between -255 and 255", -8)  return end
  
  -- do the conversion
  local factor=1/255
  return ((r+1)*factor)-1/255, ((g+1)*factor)-1/255, ((b+1)*factor)-1/255, ((a+1)*factor)-1/255
end

--A,B,C,D,E=ultraschall.ConvertColorToGFX(255,255,255,-255)

function ultraschall.ConvertGFXToColor(r,g,b,a)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertGFXToColor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer r, integer g, integer b, integer a = ultraschall.ConvertGFXToColor(number r, number g, number b, number a)</functioncall>
  <description>
    converts red,green,blue,alpha-values from 0-1 range to 0-255 range, so these values can be used by Reaper's normal color-value-functions.
    
    supports negative-values up from -1 to +1, so you can use the function as well for subtraction of colorvalues.
    
    returns nil in case of error
  </description>
  <parameters>
    number r - the converted red-value between -1 and +1; nil in case of error
    number g - the converted green-value between -1 and +1
    number b - the converted blue-value between -1 and +1
    number a - the converted alpha-value between -1 and +1
  </parameters>
  <retvals>
    integer r - the red-color-value between -255 and +255
    integer g - the green-color-value between -255 and +255
    integer b - the blue-color-value between -255 and +255
    integer a - the alpha-color-value between -255 and +255
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>helper functions, convert, red, green, blue, alpha, color, gfx</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(r)~="number" then ultraschall.AddErrorMessage("ConvertGFXToColor","r", "must be a number", -1)  return nil end
  if type(g)~="number" then ultraschall.AddErrorMessage("ConvertGFXToColor","g", "must be a number", -2)  return nil end
  if type(b)~="number" then ultraschall.AddErrorMessage("ConvertGFXToColor","b", "must be a number", -3)  return nil end
  if type(a)~="number" then ultraschall.AddErrorMessage("ConvertGFXToColor","a", "must be a number", -4)  return nil end
  if r<-1 or r>1 then ultraschall.AddErrorMessage("ConvertGFXToColor","r", "must be between -1 and 1", -5)  return nil end
  if g<-1 or g>1 then ultraschall.AddErrorMessage("ConvertGFXToColor","g", "must be between -1 and 1", -6)  return nil end
  if b<-1 or b>1 then ultraschall.AddErrorMessage("ConvertGFXToColor","b", "must be between -1 and 1", -7)  return nil end
  if a<-1 or a>1 then ultraschall.AddErrorMessage("ConvertGFXToColor","a", "must be between -1 and 1", -8)  return nil end
  
  -- do the conversion
  local factor=255
  return r*factor, g*factor, b*factor, a*factor
end

--A,B,C,D=ultraschall.ConvertGFXToColor(1,1,1,0)



function ultraschall.CreateColorTable(startr, startg, startb, endr, endg, endb, number_of_steps)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateColorTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>array ColorTable = ultraschall.CreateColorTable(integer startr, integer startg, integer startb, integer endr, integer endg, integer endb, integer number_of_steps)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a colortable to be used by color-graphics-functions.
    
    The colorvalue for start and end can be 0 to 255 or the other way round 255 to 0
    
    Can be used by [ApplyColorTableToTrackColors](#ApplyColorTableToTrackColors)
    
    returns nil in case of an error
  </description>
  <parameters>
    integer startr - start redvalue, between 0 and 255
    integer startg - start greenvalue, between 0 and 255 
    integer startb - start bluevalue, between 0 and 255
    integer endr - end redvalue, between 0 and 255
    integer endg - end greenvalue, between 0 and 255
    integer endb - end bluevalue, between 0 and 255
    integer number_of_steps - the number of steps from the lowest to the highest r,g,b-color start/end-values
  </parameters>
  <retvals>
    array ColorTable - a colortable for the colors with the number of steps of your choice; 
                     - each indexentry holds entries "r"(0-255), "g"(0-255), "b"(0-255), "nativecolor" and "gfxr"(0-1), "gfxg"(0-1), "gfxb"(0-1).
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, create, colortable</tags>
</US_DocBloc>
]]
  if ultraschall.type(number_of_steps)~="number: integer" or number_of_steps==0 then ultraschall.AddErrorMessage("CreateColorTable", "number_of_steps", "must be a positive or negative integer, no 0 allowed", -1) return nil end
  if ultraschall.type(startr)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "startr", "must be an integer", -2) return nil end
  if ultraschall.type(startg)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "startg", "must be an integer", -3) return nil end
  if ultraschall.type(startb)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "startb", "must be an integer", -4) return nil end
  if ultraschall.type(endr)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "endr", "must be an integer", -5) return nil end
  if ultraschall.type(endg)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "endg", "must be an integer", -6) return nil end
  if ultraschall.type(endb)~="number: integer" then ultraschall.AddErrorMessage("CreateColorTable", "endb", "must be an integer", -7) return nil end

  if startr<0 or startr>255 then ultraschall.AddErrorMessage("CreateColorTable", "startr", "must be between 0 and 255", -8) return nil end
  if startg<0 or startg>255 then ultraschall.AddErrorMessage("CreateColorTable", "startg", "must be between 0 and 255", -9) return nil end
  if startb<0 or startb>255 then ultraschall.AddErrorMessage("CreateColorTable", "startb", "must be between 0 and 255", -10) return nil end
  
  if endr<0 or endr>255 then ultraschall.AddErrorMessage("CreateColorTable", "endr", "must be between 0 and 255", -11) return nil end
  if endg<0 or endg>255 then ultraschall.AddErrorMessage("CreateColorTable", "endg", "must be between 0 and 255", -12) return nil end
  if endb<0 or endb>255 then ultraschall.AddErrorMessage("CreateColorTable", "endb", "must be between 0 and 255", -13) return nil end
  
  local start, stepr, stepg, stepb, steps, stop
  local colortable={}
  if number_of_steps>0 then start=1 stop=number_of_steps steps=1 else start=number_of_steps*-1 stop=1 steps=-1 end
  
  if startr<endr then stepr=(endr-startr)/number_of_steps else stepr=((startr-endr)/number_of_steps)*-1 end
  if startg<endg then stepg=(endg-startg)/number_of_steps else stepg=((startg-endg)/number_of_steps)*-1 end
  if startb<endb then stepb=(endb-startb)/number_of_steps else stepb=((startb-endb)/number_of_steps)*-1 end
  
  if number_of_steps>0 then
    for i=1, number_of_steps do
      colortable[i]={}
      -- standard colors
      colortable[i]["r"]=math.ceil(startr+(i*stepr))
      colortable[i]["g"]=math.ceil(startg+(i*stepg))
      colortable[i]["b"]=math.ceil(startb+(i*stepb))
      
      -- gfx-color-settings
      colortable[i]["gfxr"]=math.ceil(startr+(i*stepr))/255
      colortable[i]["gfxg"]=math.ceil(startg+(i*stepg))/255
      colortable[i]["gfxb"]=math.ceil(startb+(i*stepb))/255
      
      -- native color
      colortable[i]["nativecolor"]=ultraschall.ConvertColor(colortable[i]["r"], colortable[i]["g"], colortable[i]["b"])
    end
  end
  return colortable
end


function ultraschall.CreateSonicRainboomColorTable()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateSonicRainboomColorTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>array ColorTable = ultraschall.CreateSonicRainboomColorTable()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns a colortable in Ultraschall's standard-trackcolor-setting "Sonic Rainboom"-style.
    
    Can be used by [ApplyColorTableToTrackColors](#ApplyColorTableToTrackColors)
  </description>
  <retvals>
    array ColorTable - a colortable with all values for Ultraschall's track-color "Sonic Rainboom"
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, create, colortable, sonic rainboom</tags>
</US_DocBloc>
]]
  local group={}
  group[0]=16753246
  group[1]=15774556
  group[2]=15451994
  group[3]=15129178
  group[4]=14016600
  group[5]=12245846
  group[6]=9098835
  group[7]=6082898
  group[8]=4837750
  group[9]=2806183
  group[10]=4120575
  group[11]=4100351
  group[12]=5073919
  group[13]=4803058
  group[14]=7555570
  group[15]=11225586
  group[16]=15878614
  group[17]=16741328
  group[18]=16741270
  group[19]=16747136
  group[20]=12615680
  group[21]=32960
  group[22]=12583040
  local group2={}
  for i=1, 20 do
    group2[i]={}
    group2[i]["nativecolor"]=group[i-1]
    group2[i]["r"], group2[i]["g"], group2[i]["b"] = ultraschall.ConvertColorReverse(group2[i]["nativecolor"])
    -- gfx-color-settings
    group2[i]["gfxr"]=group2[i]["r"]/255
    group2[i]["gfxg"]=group2[i]["g"]/255
    group2[i]["gfxb"]=group2[i]["b"]/255
  end
  return group2
end

--L=ultraschall.CreateSonicRainboomColorTable()

function ultraschall.IsValidColorTable(ColorTable)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidColorTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidColorTable(array ColorTable)</functioncall>
  <description>
    Checks for valid color-tables.
    
    returns false in case of an error
  </description>
  <parameters>
    array ColorTable - a table to check for being a valid ColorTable
  </parameters>
  <retvals>
    boolean retval - true, if it's a valid ColorTable; false, if it's not a valid ColorTable
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, check, colortable</tags>
</US_DocBloc>
]]
  if type(ColorTable)~="table" then ultraschall.AddErrorMessage("CreateColorTable", "ColorTable", "must be a table", -1) return false end
  local Count1 = ultraschall.CountEntriesInTable_Main(ColorTable)
  if Count1==-1 then return false end
  if ColorTable[1]~=nil and
     (ultraschall.type(ColorTable[1]["r"])~="number: integer" or 
     ultraschall.type(ColorTable[1]["g"])~="number: integer" or 
     ultraschall.type(ColorTable[1]["b"])~="number: integer" or 
     ultraschall.type(ColorTable[1]["nativecolor"])~="number: integer") then
     return false
  end
  for i=2, Count1 do
    if ColorTable[1]~=nil and
      (ultraschall.type(ColorTable[i]["r"])~="number: integer" or 
       ultraschall.type(ColorTable[i]["g"])~="number: integer" or 
       ultraschall.type(ColorTable[i]["b"])~="number: integer" or 
       ultraschall.type(ColorTable[i]["nativecolor"])~="number: integer") then
       return false
    end
  end
  return true
end



function ultraschall.ApplyColorTableToTrackColors(ColorTable, Spread, StartTrack, EndTrack)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyColorTableToTrackColors</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyColorTableToTrackColors(array ColorTable, integer Spread, integer StartTrack, integer EndTrack)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Apply a ColorTable to Tracks, to colorize MediaTracks
    
    ColorTables can be created by [CreateColorTable](#CreateColorTable)
    
    returns false in case of an error
  </description>
  <parameters>
    array ColorTable - the ColorTable to apply to the MediaTrackColors
    integer Spread - 0, apply ColorTable once; will return false, if fewer colors are in ColorTable available than tracks in the project
                   - nil or 1, repeat the colors from the ColorTable over and over again over the tracks; means: if you have 10 tracks and 5 colors, the colors will fill track 1 to 5 and then again track 6 to 10
                   - 2, spread the colors from the ColorTable over all tracks equally
    integer StartTrack - the first track to colorize; nil, to use the first track in project
    integer EndTrack - the last track to colorize; nil, to use the last track in project
  </parameters>
  <retvals>
    boolean retval - true, adjusting track-colors was successful; false, adjusting track-colors was unsuccessful
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, apply, colortable, colorize, mediatracks</tags>
</US_DocBloc>
]]
  local Count1 = ultraschall.CountEntriesInTable_Main(ColorTable)
  local Count2 = 1
  local step=1
  if ultraschall.IsValidColorTable(ColorTable)==false or Count1<Count2 then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "Colortable", "Must be a valid ColorTable with at least on entry", -1) return false end
  if Spread==nil then Spread=1 end
  if Spread~=nil and math.type(Spread)~="integer" then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "Spread", "must be an integer", -2) return false end
  if Spread<0 or Spread>2 then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "Spread", "must be between 0 and 2", -3) return false end
  if Spread==0 and Count1<reaper.CountTracks(0) then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "ColorTable", "Not enough colors in Colortable for the current number of tracks", -4) return false end
  if Spread==1 then step=1 end
  if Spread==2 then step=Count1/reaper.CountTracks(0) end
  if math.type(StartTrack)==nil and reaper.CountTracks(0)>0 then StartTrack=1 end
  if math.type(EndTrack)==nil and reaper.CountTracks(0)>0 then EndTrack=reaper.CountTracks(0) end
  if math.type(StartTrack)~="integer" then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "StartTrack", "Must be an integer", -5) return false end
  if math.type(EndTrack)~="integer" then ultraschall.AddErrorMessage("ApplyColorTableToTrackColors", "EndTrack", "Must be an integer", -6) return false end

  for i=StartTrack, EndTrack do
--  reaper.MB(Count2.." "..math.floor(Count2),StartTrack.." "..EndTrack,0)
    local MediaTrack=reaper.GetTrack(0,i-1)
    if Count2>Count1 then Count2=1 end
    reaper.SetTrackColor(MediaTrack, ColorTable[math.ceil(Count2)]["nativecolor"])
    Count2=Count2+step
  end
  return true
end


--ultraschall.ApplyColorTableToTrackColors(L, 2, 2, 6)


function ultraschall.ApplyColorTableToItemColors(ColorTable, Spread, MediaItemArray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyColorTableToItemColors</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyColorTableToItemColors(array ColorTable, integer Spread, MediaItemArray MediaItemArray)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Apply a ColorTable to MediaItems in a MediaItemArray, to colorize MediaItems
    
    ColorTables can be created by [CreateColorTable](#CreateColorTable)
    
    returns false in case of an error
  </description>
  <parameters>
    array ColorTable - the ColorTable to apply to the MediaItemColors
    integer Spread - 0, apply ColorTable once; will return false, if fewer colors are in ColorTable available than items in the MediaItemArray
                   - nil or 1, repeat the colors from the ColorTable over and over again over the item; means: if you have 10 items and 5 colors, the colors will fill items 1 to 5 and then again items 6 to 10
                   - 2, spread the colors from the ColorTable over all items equally
    MediaItemArray MediaItemArray - an array with all the MediaItems to colorize
  </parameters>
  <retvals>
    boolean retval - true, adjusting item-colors was successful; false, adjusting item-colors was unsuccessful
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, apply, colortable, mediaitems, colorize</tags>
</US_DocBloc>
]]
  local Count1 = ultraschall.CountEntriesInTable_Main(ColorTable)
  local Count3 = ultraschall.CountEntriesInTable_Main(MediaItemArray)
  local Count2 = 1
  local step=1
  if ultraschall.IsValidColorTable(ColorTable)==false or Count1<Count2 then ultraschall.AddErrorMessage("ApplyColorTableToItemColors", "Colortable", "Must be a valid ColorTable with at least on entry", -1) return false end
  if ultraschall.IsValidMediaItemArray(MediaItemArray)==false or Count1<Count2 then ultraschall.AddErrorMessage("ApplyColorTableToItemColors", "MediaItemArray", "Must be a valid MediaItemArray", -2) return false end
  if Spread==nil then Spread=1 end
  if Spread~=nil and math.type(Spread)~="integer" then ultraschall.AddErrorMessage("ApplyColorTableToItemColors", "Spread", "must be an integer", -3) return false end
  if Spread<0 or Spread>2 then ultraschall.AddErrorMessage("ApplyColorTableToItemColors", "Spread", "must be between 0 and 2", -4) return false end
  if Spread==0 and Count1<Count3 then ultraschall.AddErrorMessage("ApplyColorTableToItemColors", "ColorTable", "Not enough colors in Colortable for the number of Items in MediaItemArray", -5) return false end
  if Spread==1 then step=1 end
  if Spread==2 then step=(Count1-1)/(Count3-1) end

  for i=1, Count3-1 do
    local col=ColorTable[math.ceil(Count2)]["nativecolor"]
    local retval = reaper.SetMediaItemInfo_Value(MediaItemArray[i],"I_CUSTOMCOLOR", -col|0x100000)
    Count2=Count2+step
    if Count2>Count1 then Count2=1 end
  end
  return true
end

function ultraschall.ChangeColorBrightness(r, g, b, bright_r, bright_g, bright_b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeColorBrightness</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer red, integer green, integer blue, boolean retval = ultraschall.ChangeColorBrightness(integer r, integer g, integer b, integer bright_r, optional integer bright_g, optional integer bright_b)</functioncall>
  <description>
    Changes brightness of a colorvalue. If you only set bright_r without setting bright_g and bright_b, then the value for bright_r will affect g and b as well.
    
    If a color-value becomes >255 or <0, it will be set to 255 or 0 respectively.
    
    returns color-value 0,0,0 and retval=false in case of an error
  </description>
  <parameters>
    integer r - the red-value to be changed
    integer g - the green-value to be changed
    integer b - the blue-value to be changed
    integer bright_r - the change in brightness for the red-color; positive, brighter; negative, darker
    optional integer bright_g - the change in brightness for the green-color; positive, brighter; negative, darker; if nil, value in bright_r will be used
    optional integer bright_b - the change in brightness for the blue-color; positive, brighter; negative, darker; if nil, value in bright_r will be used
  </parameters>
  <retvals>
    integer red - the new red-value
    integer green - the new green-value
    integer blue - the new blue-value
    boolean retval - true, color-calculation was successful; false, color-calculation was unsuccessful
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, change, color, brightness</tags>
</US_DocBloc>
]]
  if math.type(r)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "r", "must be an integer", -1) return 0, 0, 0, false end
  if r<0 or r>255 then  ultraschall.AddErrorMessage("ChangeColorBrightness", "r", "must be between 0 and 255", -2) return 0, 0, 0, false end
  if math.type(g)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "g", "must be an integer", -3) return 0, 0, 0, false end
  if g<0 or g>255 then  ultraschall.AddErrorMessage("ChangeColorBrightness", "g", "must be between 0 and 255", -4) return 0, 0, 0, false end
  if math.type(b)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "b", "must be an integer", -5) return 0, 0, 0, false end
  if b<0 or b>255 then  ultraschall.AddErrorMessage("ChangeColorBrightness", "b", "must be between 0 and 255", -6) return 0, 0, 0, false end

  if math.type(bright_r)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_r", "must be an integer", -7) return 0, 0, 0, false end
  if bright_r~=nil and (bright_r<-256 or bright_r>255) then  ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_r", "must be between 0 and 255", -8) return 0, 0, 0, false end
  if bright_g~=nil and math.type(bright_g)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_g", "must be either nil or an integer", -9) return 0, 0, 0, false end
  if bright_g~=nil and (bright_g<-256 or bright_g>255) then ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_g", "must be between 0 and 255", -10) return 0, 0, 0, false end  
  if bright_b~=nil and math.type(bright_b)~="integer" then ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_b", "must be either nil or an integer", -11) return 0, 0, 0, false end
  if bright_b~=nil and (bright_b<-256 or bright_b>255) then ultraschall.AddErrorMessage("ChangeColorBrightness", "bright_b", "must be between 0 and 255", -12) return 0, 0, 0, false end  
  
  if bright_g==nil then bright_g=bright_r end
  if bright_b==nil then bright_b=bright_r end
  
  r=r+bright_r
  g=g+bright_g
  b=b+bright_b

  if r>255 then r=255 end
  if g>255 then g=255 end
  if b>255 then b=255 end
  if r<0 then r=0 end
  if g<0 then g=0 end
  if b<0 then b=0 end
  return r,g,b, true
end

--A1, B1, C1, D1 = ultraschall.ChangeColorBrightness(A0, B0, C0, -10,1,9)
--reaper.SetTrackColor(reaper.GetTrack(0,0), ultraschall.ConvertColor(A1,B1,C1))

function ultraschall.ChangeColorContrast(r, g, b, Minimum_r, Maximum_r, Minimum_g, Maximum_g, Minimum_b, Maximum_b)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeColorContrast</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer red, integer green, integer blue, boolean retval = ultraschall.ChangeColorContrast(integer r, integer g, integer b, integer Minimum_r, optional integer Maximum_r, optional integer Minimum_g, optional integer Maximum_g, optional integer Minimum_b, optional integer Maximum_b)</functioncall>
  <description>
    Changes contrast of a colorvalue.
    
    Minimum will set the new minimal, Maximum will set the new maximum-brightness-level.
    If you set Minimum to 0 and Maximum to 255, contrast will not change.
    
    The lower you set Minimum/Maximum, the darker it becomes; the higher, the brighter it becomes.
    The farther away Minimum is from Maximum, the stronger the contrast becomes; the closer Minimum is to Maximum, the weaker the contrast becomes.
    
    If you only set Minimum_r and Maximum_r, then these values will be applied to g and b too.
    
    If you omit/set to nil a Maximum-value; it's default value will be 255.
    
    If a color-value becomes >255 or <0, it will be set to 255 or 0 respectively.
    
    returns color-value 0,0,0 and retval=false in case of an error
  </description>
  <parameters>
    integer r - the red-value to be changed
    integer g - the green-value to be changed
    integer b - the blue-value to be changed
    integer Minimum_r - the new minimum brightness of the contrast-range of the red-color
    optional integer Maximum_r - the new maximum brightness of the contrast-range of the red-color; if nil, it will be seen as 255
    optional integer Minimum_g - the new minimum brightness of the contrast-range of the green-color; if nil, it will use the value of Minimum_r
    optional integer Maximum_g - the new maximum brightness of the contrast-range of the green-color; if nil, it will be seen as 255
    optional integer Minimum_b - the new minimum brightness of the contrast-range of the blue-color; if nil, it will use the value of Minimum_r
    optional integer Maximum_b - the new maximum brightness of the contrast-range of the blue-color; if nil, it will be seen as 255
  </parameters>
  <retvals>
    integer red - the new red-value
    integer green - the new green-value
    integer blue - the new blue-value
    boolean retval - true, color-calculation was successful; false, color-calculation was unsuccessful
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, change, color, brightness</tags>
</US_DocBloc>
]]
  if Minimum_g==nil then Minimum_g=Minimum_r end
  if Minimum_b==nil then Minimum_b=Minimum_r end
  if Maximum_g==nil then Maximum_g=Maximum_r end
  if Maximum_b==nil then Maximum_b=Maximum_r end
  local ding

  if math.type(r)~="integer" then ultraschall.AddErrorMessage("ChangeColorContrast", "r", "must be an integer", -1) return 0, 0, 0, false end
  if r<0 or r>255 then  ultraschall.AddErrorMessage("ChangeColorContrast", "r", "must be between 0 and 255", -2) return 0, 0, 0, false end
  if math.type(g)~="integer" then ultraschall.AddErrorMessage("ChangeColorContrast", "g", "must be an integer", -3) return 0, 0, 0, false end
  if g<0 or g>255 then  ultraschall.AddErrorMessage("ChangeColorContrast", "g", "must be between 0 and 255", -4) return 0, 0, 0, false end
  if math.type(b)~="integer" then ultraschall.AddErrorMessage("ChangeColorContrast", "b", "must be an integer", -5) return 0, 0, 0, false end
  if b<0 or b>255 then  ultraschall.AddErrorMessage("ChangeColorContrast", "b", "must be between 0 and 255", -6) return 0, 0, 0, false end

  if math.type(Minimum_r)~="integer" then ultraschall.AddErrorMessage("ChangeColorContrast", "Minimum_r", "must be an integer", -7) return 0, 0, 0, false end
  if Minimum_g~=nil and math.type(Minimum_g)~="integer"then ultraschall.AddErrorMessage("ChangeColorContrast", "Minimum_g", "must be either nil or an integer", -8) return 0, 0, 0, false end
  if Minimum_b~=nil and math.type(Minimum_b)~="integer" then ultraschall.AddErrorMessage("ChangeColorContrast", "Minimum_b", "must be either nil or an integer", -9) return 0, 0, 0, false end

  if Maximum_r~=nil and math.type(Maximum_r)~="integer"then ultraschall.AddErrorMessage("ChangeColorContrast", "Maximum_r", "must be either nil or an integer", -10) return 0, 0, 0, false end
  if Maximum_g~=nil and math.type(Maximum_g)~="integer"then ultraschall.AddErrorMessage("ChangeColorContrast", "Maximum_g", "must be either nil or an integer", -11) return 0, 0, 0, false end
  if Maximum_b~=nil and math.type(Maximum_b)~="integer"then ultraschall.AddErrorMessage("ChangeColorContrast", "Maximum_b", "must be either nil or an integer", -12) return 0, 0, 0, false end

  if Maximum_r==nil then Maximum_r=255 ding=true end
  if ding==true and Minimum_r>0 then Maximum_r=Maximum_r-Minimum_r end
  local Dyn_r=Maximum_r-Minimum_r
  ding=false

  if Maximum_g==nil then Maximum_g=255 ding=true end
  if ding==true and Minimum_g>0 then Maximum_g=Maximum_g-Minimum_g end
  local Dyn_g=Maximum_g-Minimum_g
  ding=false

  if Maximum_b==nil then Maximum_b=255 ding=true end
  if ding==true and Minimum_b>0 then Maximum_b=Maximum_b-Minimum_b end
  local Dyn_b=Maximum_b-Minimum_b
  ding=false
  
  r=r/255*Dyn_r
  r=r+Minimum_r

  g=g/255*Dyn_g
  g=g+Minimum_g
  
  b=b/255*Dyn_b
  b=b+Minimum_b
  
  if r>255 then r=255 end
  if g>255 then g=255 end
  if b>255 then b=255 end
  if r<0 then r=0 end
  if g<0 then g=0 end
  if b<0 then b=0 end
  return math.floor(r), math.floor(g), math.floor(b), true
end

--A1, B1, C1 = ultraschall.ChangeColorContrast(10, 100, 200, 100, 255, 100, 255, 100, 255)


function ultraschall.ChangeColorSaturation(r,g,b,delta)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ChangeColorSaturation</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer red, integer green, integer blue, number median, boolean retval = ultraschall.ChangeColorSaturation(integer r, integer g, integer b, integer delta)</functioncall>
  <description>
    Changes saturation of a colorvalue by delta.
    
    If a color-value becomes >255 or <0, it will be set to 255 or 0 respectively.
    
    returns color-value 0,0,0 and retval=false in case of an error
  </description>
  <parameters>
    integer r - the red-value to be changed
    integer g - the green-value to be changed
    integer b - the blue-value to be changed
    integer delta - the saturation/desaturation-value; negative, desaturates color; positive, saturates color
  </parameters>
  <retvals>
    integer red - the new red-value
    integer green - the new green-value
    integer blue - the new blue-value
    number median - the median-value, calculated from the the old red, green and blue, values (red+green+blue)/3, which is the basis for the brightness of the unsaturated value
    boolean retval - true, color-calculation was successful; false, color-calculation was unsuccessful
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, change, color, saturation</tags>
</US_DocBloc>
]]
  if math.type(r)~="integer" then ultraschall.AddErrorMessage("ChangeColorSaturation", "r", "must be an integer", -1) return 0, 0, 0, 0, false end
  if r<0 or r>255 then  ultraschall.AddErrorMessage("ChangeColorSaturation", "r", "must be between 0 and 255", -2) return 0, 0, 0, 0, false end
  if math.type(g)~="integer" then ultraschall.AddErrorMessage("ChangeColorSaturation", "g", "must be an integer", -3) return 0, 0, 0, 0, false end
  if g<0 or g>255 then  ultraschall.AddErrorMessage("ChangeColorSaturation", "g", "must be between 0 and 255", -4) return 0, 0, 0, 0, false end
  if math.type(b)~="integer" then ultraschall.AddErrorMessage("ChangeColorSaturation", "b", "must be an integer", -5) return 0, 0, 0, 0, false end
  if b<0 or b>255 then  ultraschall.AddErrorMessage("ChangeColorSaturation", "b", "must be between 0 and 255", -6) return 0, 0, 0, 0, false end

  if math.type(delta)~="integer" then ultraschall.AddErrorMessage("ChangeColorSaturation", "delta", "must be an integer", -7) return 0, 0, 0, 0, false end
  
  local Median=(r+g+b)/3
  delta=delta*-1
  
  if r>Median then r=r-delta if r<Median then r=Median end elseif r<Median then r=r+delta if r>Median then r=Median end end
  if g>Median then g=g-delta if g<Median then g=Median end elseif g<Median then g=g+delta if g>Median then g=Median end end
  if b>Median then b=b-delta if b<Median then b=Median end elseif b<Median then b=b+delta if b>Median then b=Median end end

  if r>255 then r=255 end
  if g>255 then g=255 end
  if b>255 then b=255 end
  if r<0 then r=0 end
  if g<0 then g=0 end
  if b<0 then b=0 end
    
  return math.floor(r),math.floor(g),math.floor(b), Median, true
end

function ultraschall.ConvertColorToMac(red, green, blue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorToMac</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer mac_colorvalue, boolean retval = ultraschall.ConvertColorToMac(integer red, integer green, integer blue)</functioncall>
  <description>
    Converts a colorvalue to the correct-native-colorvalue for Mac, no matter if you're using Mac, Windows or Linux.
    
    returns 0, false in case of an error
  </description>
  <parameters>
    integer red - the red-value of the color
    integer green - the green-value of the color
    integer blue - the blue-value of the color
  </parameters>
  <retvals>
    integer mac_colorvalue - the Mac-native-colorvalue
    boolean retval - true, if conversion succeeded; false, if conversion failed
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, native, mac, convert</tags>
</US_DocBloc>
]]
  if math.type(red)~="integer" then ultraschall.AddErrorMessage("ConvertColorToMac","red","must be an integer",-1) return 0, false end
  if math.type(green)~="integer" then ultraschall.AddErrorMessage("ConvertColorToMac","green","must be an integer",-2) return 0, false end
  if math.type(blue)~="integer" then ultraschall.AddErrorMessage("ConvertColorToMac","blue","must be an integer",-3) return 0, false end
  if ultraschall.IsOS_Mac()==false then red, blue = blue,red end
  return ultraschall.ConvertColor(red, green, blue)
end

--A=ultraschall.ConvertColorToMac(255,0,127)

function ultraschall.ConvertColorToWin(red, green, blue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorToWin</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer win_linux_colorvalue, boolean retval = ultraschall.ConvertColorToWin(integer red, integer green, integer blue)</functioncall>
  <description>
    Converts a colorvalue to the correct-native-colorvalue for Windows/Linux, no matter if you're using Mac, Windows or Linux.
    
    returns 0, false in case of an error
  </description>
  <parameters>
    integer red - the red-value of the color
    integer green - the green-value of the color
    integer blue - the blue-value of the color
  </parameters>
  <retvals>
    integer win_linux_colorvalue - the Windows/Linux-native-colorvalue
    boolean retval - true, if conversion succeeded; false, if conversion failed
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, native, windows, linux, convert</tags>
</US_DocBloc>
]]
  if math.type(red)~="integer" then ultraschall.AddErrorMessage("ConvertColorToWin","red","must be an integer",-1) return 0, false end
  if math.type(green)~="integer" then ultraschall.AddErrorMessage("ConvertColorToWin","green","must be an integer",-2) return 0, false end
  if math.type(blue)~="integer" then ultraschall.AddErrorMessage("ConvertColorToWin","blue","must be an integer",-3) return 0, false end
  if ultraschall.IsOS_Mac()==true then red, blue = blue,red end
  return ultraschall.ConvertColor(red, green, blue)
end

function ultraschall.ConvertColorFromMac(mac_colorvalue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorFromMac</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer red, integer green, integer blue, boolean retval = ultraschall.ConvertColorFromMac(integer mac_colorvalue)</functioncall>
  <description>
    Converts a native-colorvalue to the correct rgb-color-values for Mac, no matter if you're using Mac, Windows or Linux.
    
    returns 0, 0, 0, false in case of an error
  </description>
  <parameters>
    integer mac_colorvalue - the Mac-native-colorvalue
  </parameters>
  <retvals>
    integer red - the red-value of the color
    integer green - the green-value of the color
    integer blue - the blue-value of the color
    boolean retval - true, if conversion succeeded; false, if conversion failed
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, native, mac, convert</tags>
</US_DocBloc>
]]
  if math.type(mac_colorvalue)~="integer" then ultraschall.AddErrorMessage("ConvertColorFromMac","mac_colorvalue","must be an integer",-1) return 0, false end
  local red, green, blue, retval=ultraschall.ConvertColorReverse(mac_colorvalue)
  if ultraschall.IsOS_Mac()==false then red, blue = blue,red end
  return red, green, blue, retval
end

--B,C,D,E=ultraschall.ConvertColorFromMac(A)

function ultraschall.ConvertColorFromWin(win_colorvalue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertColorFromWin</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer red, integer green, integer blue, boolean retval = ultraschall.ConvertColorFromWin(integer win_colorvalue)</functioncall>
  <description>
    Converts a native-colorvalue to the correct rgb-color-values for Windows/Linux, no matter if you're using Mac, Windows or Linux.
    
    returns 0, 0, 0, false in case of an error
  </description>
  <parameters>
    integer win_colorvalue - the Windows/Linux-native-colorvalue
  </parameters>
  <retvals>
    integer red - the red-value of the color
    integer green - the green-value of the color
    integer blue - the blue-value of the color
    boolean retval - true, if conversion succeeded; false, if conversion failed
  </retvals>
  <chapter_context>
    Color Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Color_Module.lua</source_document>
  <tags>color management, native, windows, linux, convert</tags>
</US_DocBloc>
]]
  if math.type(win_colorvalue)~="integer" then ultraschall.AddErrorMessage("ConvertColorFromWin","win_colorvalue","must be an integer",-1) return 0, false end
  local red, green, blue, retval=ultraschall.ConvertColorReverse(win_colorvalue)
  if ultraschall.IsOS_Mac()==true then red, blue = blue,red end
  return red, green, blue, retval
end

--B,C,D,E=ultraschall.ConvertColorFromWin(A)
