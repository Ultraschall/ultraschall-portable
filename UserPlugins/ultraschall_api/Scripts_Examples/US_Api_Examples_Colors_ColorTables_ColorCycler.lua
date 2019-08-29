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
