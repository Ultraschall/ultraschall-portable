-- Meo Mespotine
-- Ultraschall-API-demoscript 29th of march 2019
--
-- shows a simple progressbar in the ReaScript-console, that iterates over all 
-- filenames in ResourcePath/Effects

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- get all files and folders in resource-path/Effects
found_dirs, dirs_array, found_files, files_array = 
      ultraschall.GetAllRecursiveFilesAndSubdirectories(reaper.GetResourcePath().."/Effects")

--counter-variable for the current entry
i=1

function main()
  -- Iterate through all files and display their names.
  -- Show the progression, using a progressbar
  --    length     : length of the progressbar shall be 100 characters 
  --    max entries: found_files, the number of files I found in Resourcepath/Effects
  --    cur entry  : i
  --    show percentage: true, show a percentage in the middle of the progressbar
  --    offset     : indent progressbar by 10 characters
  --    toptext    : "Simple progressbar demo...", shown above the progressbar
  --    bottomtext : the currently shown filename, shown below the progressbar
  --    remaining_time: show "remaining time until completetion: x:xx"
  AA=ultraschall.PrintProgressBar(true, 100, found_files, i, true, 10, 
                    "Simple progressbar demo, that shows all files in ressource-path/Effects.\n\nShowing the file "..i.."/"..found_files..":\n", 
                    "\n"..files_array[i], "remaining time until completion: ")
  i=i+1
  if i<found_files then reaper.defer(main) end
end


main()
