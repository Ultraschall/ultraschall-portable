dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ConvertFile(filename, text)
  local PNG=reaper.JS_LICE_LoadPNG(filename)

  local R=math.floor(math.random()*10)
  local G=math.floor(math.random()*10)
  local B=math.floor(math.random()*10)
  reaper.JS_LICE_FillRect(PNG, 0, 0, 10000, 10000, R*100+G*100*100+B*100*100*100, 1, "")
  
  for i=3, 30, 3 do
    reaper.JS_LICE_Line(PNG, 3, i, 3000, i, 0xFFFFFF, 1, "", false)
  end
  
  local Retval=reaper.JS_LICE_WritePNG(filename, PNG, false)
  reaper.JS_LICE_DestroyFont(LICEFont)
  reaper.JS_LICE_DestroyBitmap(PNG)
end

path="c:\\Ultraschall-US_API_4.1.001\\ColorThemes\\Default_6.0_unpacked"
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(path)

for i=1, found_files do
  ConvertFile(files_array[i], files_array[i]:sub(path:len()+1, -1))
end

cmd=reaper.NamedCommandLookup("_02b0a023f15ad14bab012b692e80a882")
reaper.Main_OnCommand(cmd, 0)
