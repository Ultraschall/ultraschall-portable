dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
--[[
reaper.gmem_attach("lufs")
A={}
for i=0, 100 do
  A[i]=reaper.gmem_read(i)
end

function ultraschall.LUFS_Metering_Reset()
  reaper.gmem_write(4,1)
end
--]]
function ultraschall.LUFS_Metering_MatchGain()
  local old_attached_name=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("lufs")
  reaper.gmem_write(5,1)
  reaper.gmem_attach(old_attached_name)
end

--ultraschall.LUFS_Metering_MatchGain()
--]]

function ultraschall.LUFS_Metering_Reset()
  local old_attached_name=ultraschall.Gmem_GetCurrentAttachedName()
  reaper.gmem_attach("lufs")
  reaper.gmem_write(4,1)
  reaper.gmem_attach(old_attached_name)
end

--ultraschall.LUFS_Metering_Reset()

--A1=reaper.gmem_attach("sdjosd")
--A=reaper.gmem_attach("lufs")
--A3=ultraschall.Gmem_GetCurrentAttachedName()

function main()
  A1=reaper.gmem_read(1)
  A2=reaper.gmem_read(2)
  A3=reaper.gmem_read(3)
  A6=reaper.gmem_read(6)
  A={ultraschall.LUFS_Metering_GetValues()}
  reaper.defer(main)
end

--main()

function ultraschall.LUFS_Metering_SetValues(LUFS_target, Gain)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LUFS_Metering_GetValues</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>ultraschall.LUFS_Metering_GetValues(optional integer LUFS_target, optional number dB_Gain)</functioncall>
  <description>
    Returns current LUFS-values of Ultraschall's LUFS Loudness Meter, when running(only available in Ultraschall-installations).
  </description>
  <retvals>
    optional integer LUFS_target - the LUFS-target
                                 - 0, -14 LUFS (Spotify)
                                 - 1, -16 LUFS (Podcast)
                                 - 2, -18 LUFS
                                 - 3, -20 LUFS
                                 - 4, -23 LUFS (EBU R128)
    optional number dB_Gain - the gain of the effect in dB
  </retvals>
  <chapter_context>
    Ultraschall Specific
    LUFS Loudness Meter
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Ultraschall_Module.lua</source_document>
  <tags>ultraschall, set, lufs, loudness meter, get, values, target, gain</tags>
</US_DocBloc>
--]]
  local old_attached_name=reaper.gmem_attach("lufs")
  if LUFS_target~=nil then reaper.gmem_write(8, LUFS_target) end
  if Gain~=nil then reaper.gmem_write(7, Gain) end
  reaper.gmem_attach(old_attached_name)

end

--ultraschall.LUFS_Metering_SetValues(4, 2)


function ultraschall.LUFS_Metering_AddEffect(enabled)
  if enabled==nil then enabled=false end
  local tr = reaper.GetMasterTrack(0)
  local index=-1
  for i=0, reaper.TrackFX_GetCount(tr)-1 do
    local retval, fx=reaper.TrackFX_GetFXName(tr, i)
    if fx:match("LUFS Loudness Metering") then
      index=i
    end
  end
  if index==-1 then
    local A=reaper.TrackFX_AddByName(tr, "dynamics/LUFS_Loudness_Meter", false, -1)
    local A=reaper.TrackFX_SetEnabled(tr, reaper.TrackFX_GetCount(tr)-1, enabled)
    return true
  else
    local A=reaper.TrackFX_SetEnabled(tr, index, enabled)
    return false
  end
end

--A=ultraschall.LUFS_Metering_AddEffect(true)

function ultraschall.LUFS_Metering_ShowEffect()
  local tr = reaper.GetMasterTrack(0)
  local index=-1
  for i=0, reaper.TrackFX_GetCount(tr)-1 do
    local retval, fx=reaper.TrackFX_GetFXName(tr, i)
    if fx:match("LUFS Loudness Metering") then
      index=i
    end
  end
  if index~=-1 then
    reaper.TrackFX_SetOpen(tr, index, true)
  end
end

--ultraschall.LUFS_Metering_ShowEffect()
