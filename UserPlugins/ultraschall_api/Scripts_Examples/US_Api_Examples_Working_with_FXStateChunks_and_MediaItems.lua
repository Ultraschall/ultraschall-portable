dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Examplecode on how to toggle bypass with FXStateChunks in TakeFX by Meo Mespotine 23rd of January 2020
    bypasstoggle=1 -- set it to 1 to bypass, set it to 0 to unbypass FX of Takes


-- the following order is essential. If you leave out one of them or mix them up...you're out of luck

-- first, you need get the StateChunk
    MediaItem          = reaper.GetMediaItem(0, 0)
    B0, ItemStateChunk = reaper.GetItemStateChunk(MediaItem, "", false)

-- get the FXStateChunk. Before that, you cannot do anything with the FXStateChunks!
    FXStateChunk       = ultraschall.GetFXStateChunk(ItemStateChunk, 1)

-- let's manipulate it to make all FX bypassed
    FXStateChunk       = string.gsub(FXStateChunk, "BYPASS.-\n", "BYPASS "..bypasstoggle.." 0 0\n")

-- after the FXStateChunk is manipulated, you can set it back into the ItemStateChunk
    C, ItemStateChunk  = ultraschall.SetFXStateChunk(ItemStateChunk, FXStateChunk, 1)

-- now you can set the statechunk into the MediaItem again
    Result             = reaper.SetItemStateChunk(MediaItem, ItemStateChunk, false)


-- update Arrangeview, so any changes in MediaItem-takes are shown
    reaper.UpdateArrange()