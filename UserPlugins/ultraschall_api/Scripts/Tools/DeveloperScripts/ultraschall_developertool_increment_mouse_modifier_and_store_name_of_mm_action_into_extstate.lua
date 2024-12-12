-- 1. Put reaper.ViewPrefs(466, "") into __startup.lua
-- 2. set this to the section in question:
section="MM_CTX_FIXEDLANETAB_DBLCLK"
-- 3. set the mouse-modifier of shift+win to no action
-- 4. run this script until the mouse-modifier is empty.

-- Note: In reaper-extstate.ini, you'll find the mouse-modifier names(look for the section as key in there.
-- Note: some mouse-modifier-actions might not be set. If that's the case, the mouse-modifier-action will stay the same with each round.
--       increment in the reaper-mouse.ini 1 to the mm_9-key-value of the section e.g. [MM_CTX_FIXEDLANETAB_DBLCLK]


ultraschall_override=true

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

function main()
  A,B=reaper.BR_Win32_GetPrivateProfileString(section, "mm_9","", reaper.GetResourcePath().."/reaper-mouse.ini")
  
  HWND=reaper.JS_Window_Find("List3", true)
  for i=0, 30000 do
    HWND2=reaper.JS_Window_FindChildByID(HWND, i)
    --if HWND2~=nil then print_alt(i, reaper.JS_Window_GetTitle(HWND)) end
  end
  
  --HWND2=reaper.JS_Window_FindChildByID(HWND, 0)
  --H=reaper.JS_Window_GetTitle(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(HWND)))
  
  --A,B,C=reaper.JS_ListView_GetItem(HWND
  --HWND3=reaper.JS_Window_FindChildByID(HWND2, 1071)
  
  AA = reaper.JS_ListView_GetItemText(HWND, 9, 1)
  --if lol==nil then return end
  num=B:match("(.-) m")
  num=tonumber(num)
  
  reaper.SetExtState("MouseModifiers", section.."::"..num, AA, true)


  --if lol==nil then return end
  
  num=num+1
  reaper.BR_Win32_WritePrivateProfileString(section, "mm_9", num.." m", reaper.GetResourcePath().."/reaper-mouse.ini")
  
  reaper.Main_OnCommand(40063, 0)
  reaper.Main_OnCommand(40004, 0)
  
end

reaper.defer(main)
