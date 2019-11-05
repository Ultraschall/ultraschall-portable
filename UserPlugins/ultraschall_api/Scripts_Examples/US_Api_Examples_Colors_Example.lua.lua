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

-- Ultraschall-API demoscript by Meo Mespotine 29.10.2018
-- 
-- change brightness, contrast and saturation of the trackcolors of all tracks.
-- will apply, by default, the Ultraschall-colorscheme "Sonic Rainboom"

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Colorize Tracks
ColorTable = ultraschall.CreateSonicRainboomColorTable()
ultraschall.ApplyColorTableToTrackColors(ColorTable, 2)

gfx.init("Change Track-Color's Brightness, Contrast and Saturation",300,200,0,500,400)
gfx.setfont(1,"times",16)

brightness=0
contrast=0
saturation=0

function changecolor(value, changetype)
  -- change the color, according to selected type
  for i=1, reaper.CountTracks(0) do 
    R,G,B=ultraschall.ConvertColorReverse(reaper.GetTrackColor(reaper.GetTrack(0,i-1)))
    if changetype==1 then red, green, blue = ultraschall.ChangeColorBrightness(R,G,B, value) end -- brightness
    if changetype==2 then red, green, blue = ultraschall.ChangeColorContrast(R,G,B, value, 255+value) end -- contrast
    if changetype==3 then red, green, blue = ultraschall.ChangeColorSaturation(R,G,B, value) end -- saturation
    newcol=ultraschall.ConvertColor(red,green,blue)
    reaper.SetTrackColor(reaper.GetTrack(0,i-1), newcol)
  end
end

function main()
  -- get pressed key  
  A=gfx.getchar()  
  
  -- brightness
  if A==49 then changecolor(-3, 1) brightness=brightness-3 end 
  if A==50 then changecolor(3, 1) brightness=brightness+3 end 
  -- contrast
  if A==51 then changecolor(-3, 2) contrast=contrast-3 end 
  if A==52 then changecolor(3, 2) contrast=contrast+3 end 
  -- saturation
  if A==53 then changecolor(-3, 3) saturation=saturation-3 end 
  if A==54 then changecolor(3, 3) saturation=saturation+3 end
  
  if A~=-1 then 
    gfx.x=0 gfx.y=0
    gfx.drawstr("Change\n Brightness(keys 1 and 2): "..brightness.."\n Contrast(keys 3 and 4)  : "..contrast.."\n Saturation(keys 5 and 6): "..saturation)
    gfx.update()
    reaper.defer(main) 
  end
end

A=1
main()
