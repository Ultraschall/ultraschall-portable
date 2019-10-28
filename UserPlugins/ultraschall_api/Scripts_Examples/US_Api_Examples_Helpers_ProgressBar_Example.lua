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
