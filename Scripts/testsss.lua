dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

reaper.gmem_attach("lufs")
A={}
for i=0, 100 do
  A[i]=reaper.gmem_read(i)
end

function ultraschall.LUFS_Metering_Reset()
  reaper.gmem_write(4,1)
end

function ultraschall.LUFS_Metering_MatchGain()
  reaper.gmem_write(5,1)
end

ultraschall.LUFS_Metering_MatchGain()
