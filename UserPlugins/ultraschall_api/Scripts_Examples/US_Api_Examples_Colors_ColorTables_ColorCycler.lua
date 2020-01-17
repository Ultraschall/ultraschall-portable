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
  
-- Meo Mespotine - 30. November 2018
-- Cycles colors of MediaItems and MediaTracks. It's using a ColorTable with SonicRainboomColorStyle

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

ColorTable=ultraschall.CreateSonicRainboomColorTable()           -- create ColorTable SonicRainboom-style
NumMediaItems,MediaItemArray=ultraschall.GetAllMediaItems() -- get all MediaItems in the current project as MediaItemArray

function main()
  -- Let's cycle the colors
  counter=counter-1 
  CycledColorTable=ultraschall.CycleTable(ColorTable,math.floor(counter))  -- cycle the colors in the ColorTable
  retval = ultraschall.ApplyColorTableToTrackColors(CycledColorTable, 1) -- apply the cycled ColorTable to MediaTrack-colors
  ultraschall.ApplyColorTableToItemColors(CycledColorTable, 1, MediaItemArray) -- apply the cycled ColorTable to MediaItem-colors
  reaper.defer(main)
end

counter=0 -- a simple counter for the offset of the cycling
main() -- Let's start to boogie
