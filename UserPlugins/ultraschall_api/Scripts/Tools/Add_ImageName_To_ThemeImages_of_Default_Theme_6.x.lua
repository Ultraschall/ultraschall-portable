dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ConvertFile(filename, text)
  local PNG=reaper.JS_LICE_LoadPNG(filename)
  
  local LICEFont=reaper.JS_LICE_CreateFont()
  --reaper.JS_LICE_FillRect(PNG, 0, 0, 10000, 10000, 0x000000, 1, "")
  local Retval=reaper.JS_LICE_DrawText(PNG, LICEFont, text, 100, 2, 2, 150, 150)
  local Retval=reaper.JS_LICE_DrawText(PNG, LICEFont, text:sub(-9, -4), 100, 2, 11, 150, 150)
  reaper.JS_LICE_SetFontColor(LICEFont, 0xFFFFFF)
  local Retval=reaper.JS_LICE_DrawText(PNG, LICEFont, text, 100, 1, 1, 150, 150)
  local Retval=reaper.JS_LICE_DrawText(PNG, LICEFont, text:sub(-9, -4), 100, 1, 10, 150, 150)
  
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
