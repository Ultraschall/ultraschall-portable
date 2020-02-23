dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- Diese Funktionen kannst Du nutzen, um den Thumbnail-Creator aufzurufen


function RunThumbnailCreator(output_folder, filenames_separated_by_newlines, squaresize_in_pixels)
  -- Startet den thumbnail-creator. Erzeugt die Thumbnails im Output-Ordner nummeriert, sprich 0001.png, 0002.png, etc
  -- Die Reihenfolge entspriche exakt der Dateien-Reihenfolge, die Du mit filenames_separated_by_newlines übergibst.
  
  -- Parameter:
  -- output_folder - der Ordner, wo die Thumbnails hinsollen. Am Besten wohl der Projektordner.
  -- filenames_separated_by_newlines - die Dateinamen mit Pfad der Dateien, die konvertiert werden sollen. Mit Newlines voneinander getrennt.
  -- squaresize_in_pixels - die Größe der Thumbnails. Zwischen 1 und 500.
  if math.type(squaresize_in_pixels)~="integer" then ultraschall.AddErrorMessage("RunThumbnailCreator", "squaresize_in_pixels", "must be an integer", -1) return end
  if type(output_folder)~="string" then ultraschall.AddErrorMessage("RunThumbnailCreator", "output_folder", "must be a string", -2) return end
  if type(filenames_separated_by_newlines)~="string" then ultraschall.AddErrorMessage("RunThumbnailCreator", "filenames_separated_by_newlines", "must be a string", -3) return end
  if squaresize_in_pixels>500 or squaresize_in_pixels<1 then ultraschall.AddErrorMessage("RunThumbnailCreator", "squaresize_in_pixels", "must be between 1 and 500", -4) return end
  local retval
  retval, ultraschall["Thumbnail_Script_Identifier"] = 
  ultraschall.Main_OnCommandByFilename(reaper.GetResourcePath().."/Scripts/ultraschall_create_thumbnails.lua", 
  output_folder, filenames_separated_by_newlines, squaresize_in_pixels)
end

function IsThumbnailCreationDone()
  -- Liefert true zurück, wenn der Thumbnail-Creator fertig ist mit konvertieren, sonst false.
  if ultraschall["Thumbnail_Script_Identifier"]==nil then return false end
  local num_params, retvals = ultraschall.GetScriptReturnvalues(ultraschall["Thumbnail_Script_Identifier"])
  if num_params~=-1 then return true else return false end
end




-- DemoCode:

-- Die Liste an Dateien, die konvertiert werden sollen
DemoFileList=
reaper.GetResourcePath().."/Data/track_icons/amp_combo.png\n"..
reaper.GetResourcePath().."/Data/track_icons/folder.png\n"..
reaper.GetResourcePath().."/Data/track_icons/hihat.png\n"..
reaper.GetResourcePath().."/Data/track_icons/meter.png\n"..
reaper.GetResourcePath().."/Data/track_icons/ac_guitar.png\n"..
reaper.GetResourcePath().."/Data/track_icons/ac_guitar_full.png\n"..
reaper.GetResourcePath().."/Data/track_icons/amp.png\n"..
reaper.GetResourcePath().."/Data/track_icons/idea.png\n"..
reaper.GetResourcePath().."/Data/track_icons/kick.png\n"..
reaper.GetResourcePath().."/Data/track_icons/male.png\n"..
reaper.GetResourcePath().."/Data/track_icons/male_head.png\n"..
reaper.GetResourcePath().."/Data/track_icons/maracas.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic_condenser_1.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic_condenser_2.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic_dynamic_1.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic_dynamic_2.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mic_shotgun.png\n"..
reaper.GetResourcePath().."/Data/track_icons/midi.png\n"..
reaper.GetResourcePath().."/Data/track_icons/mixer.png\n"..
reaper.GetResourcePath().."/Data/track_icons/organ.png\n"..
reaper.GetResourcePath().."/Data/track_icons/overheads.png\n"..
reaper.GetResourcePath().."/Data/track_icons/pads.png\n"..
reaper.GetResourcePath().."/Data/track_icons/pedal.png\n"..
reaper.GetResourcePath().."/Data/track_icons/phones.png\n"..
reaper.GetResourcePath().."/Data/track_icons/piano.png\n"..
reaper.GetResourcePath().."/Data/track_icons/pp.png\n"..
reaper.GetResourcePath().."/Data/track_icons/reverb.png\n"..
reaper.GetResourcePath().."/Data/track_icons/ride_bell.png\n"..
reaper.GetResourcePath().."/Data/track_icons/ride_rim.png\n"..
reaper.GetResourcePath().."/Data/track_icons/room_large.png\n"..
reaper.GetResourcePath().."/Data/track_icons/room_medium.png\n"..
reaper.GetResourcePath().."/Data/track_icons/room_small.png\n"..
reaper.GetResourcePath().."/Data/track_icons/sax.png\n"..
reaper.GetResourcePath().."/Data/track_icons/snare_bottom.png\n"..
reaper.GetResourcePath().."/Data/track_icons/snare_top.png\n"..
reaper.GetResourcePath().."/Data/track_icons/speech.png\n"..
reaper.GetResourcePath().."/Data/track_icons/synth.png\n"..
reaper.GetResourcePath().."/Data/track_icons/synth2.png\n"..
reaper.GetResourcePath().."/Data/track_icons/synthbass.png\n"..
reaper.GetResourcePath().."/Data/track_icons/system.png\n"..
reaper.GetResourcePath().."/Data/track_icons/tamborine.png\n"..
reaper.GetResourcePath().."/Data/track_icons/tape.png\n"..
reaper.GetResourcePath().."/Data/track_icons/tom.png\n"..
reaper.GetResourcePath().."/Data/track_icons/treble_clef.png\n"..
reaper.GetResourcePath().."/Data/track_icons/trombone.png\n"..
reaper.GetResourcePath().."/Data/track_icons/trumpet.png\n"..
reaper.GetResourcePath().."/Data/track_icons/violin.png\n"..
reaper.GetResourcePath().."/Data/track_icons/xylophone.png\n"..
reaper.GetResourcePath().."/Data/track_icons/yeah_you_guys_are_great.png"

-- Der Ausgabepfad für die konvertierten Dateien. Notfalls mit 
--    integer reaper.RecursiveCreateDirectory(string path, integer ignored)
-- einen Ordner für die Thumbnails dort erstellen.
OutputPath="c:/temp/A2"

-- Die Größe der Thumbnails in Pixeln. Diese werden "quadratiert". Um Verzerrungen zu vermeiden werden nicht 
-- quadratische Bilder zentriert und fehlende Teile mit schwarzem Hintergrund versehen.
-- Und es gibt nen weißen Rahmen, den ich noch entfernen kann, so Dir der nicht gefällt.
Thumbnail_Squaresize=48


-- erzeuge die Thumbnails
RunThumbnailCreator(OutputPath, DemoFileList, Thumbnail_Squaresize)


-- checke, wann der Thumbnail-Creator fertig ist und gib ein "Done! Hooray!" aus.
-- Öffnet im Anschluß den Zielordner
function main()
  A,B,C=IsThumbnailCreationDone()
  if A==false then reaper.defer(main) else print2("Done! Hooray!") ultraschall.OpenURL(OutputPath) end
end
main()
