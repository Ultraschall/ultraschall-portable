dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

menu={}
menu[#menu+1]={"Render using last used settings", ""}
menu[#menu+1]={"Render as MP3", "MP3"}
if reaper.GetOS():match("OS")~=nil then menu[#menu+1]={"Render as M4A", "m4a_Mac"}
elseif reaper.GetOS():match("Win") then menu[#menu+1]={"Render as M4A", "m4a_Windows"}
end
menu[#menu+1]={"Render as Auphonic Multichannel", "Auphonic Multichannel"}

menu_entries=""

bounds_presets, bounds_names, options_format_presets, options_format_names, both_presets, both_names = ultraschall.GetRenderPreset_Names()

for i=1, #both_names do
  menu[#menu+1]={both_names[i], both_names[i]}
end

for i=1, #menu do
  if i==4 then insert=">Render using preset|" else insert="" end
  menu_entries=menu_entries..menu[i][1].."|"..insert
end


menu_entries=menu_entries:sub(1,-2)
X,Y=reaper.GetMousePosition()
_,_,X2,Y2=reaper.my_getViewport(0,0,0,0,0,0,0,0,true)
if Y>Y2-150 then Y=Y2-150 end
retval = ultraschall.ShowMenu("Render to File", menu_entries, X+15, Y)


if retval==-1 then return end

if retval>1 then
  RenderTable = ultraschall.GetRenderPreset_RenderTable(menu[retval][2], menu[retval][2])
  if RenderTable==nil then return end
  ultraschall.ApplyRenderTable_Project(RenderTable)
end

--SLEM()
reaper.Main_OnCommand(40015, 0)
