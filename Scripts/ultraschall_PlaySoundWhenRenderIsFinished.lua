-- Meo-Ada Mespotine 19th of February 2024 - licensed under MIT-license
-- Plays sound when render finishes/is aborted

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

if reaper.GetExtState("ultraschall_rooster_sound", "running")=="true" then return end

function main()
  if ultraschall.IsReaperRendering()==false and oldrender==true then
    volume=ultraschall.GetUSExternalState("ultraschall_settings_tims_chapter_ping_volume", "Value", "ultraschall-settings.ini")
    play_sound=ultraschall.GetUSExternalState("ultraschall_settings_render_finished_ping", "Value", "ultraschall-settings.ini")
    if play_sound=="1" then
      ultraschall.PreviewMediaFile(reaper.GetResourcePath().."/Scripts/Ultraschall_Sounds/Render-Finished-Sound.flac", tonumber(volume), false, 0)
    end
  end
  oldrender=ultraschall.IsReaperRendering()
  reaper.defer(main)
end


main()

reaper.SetExtState("ultraschall_rooster_sound", "running", "true", false)

function atexit()
  reaper.Xen_StopSourcePreview(-1)
  reaper.SetExtState("ultraschall_rooster_sound", "running", "", false)
end

reaper.atexit(atexit)
