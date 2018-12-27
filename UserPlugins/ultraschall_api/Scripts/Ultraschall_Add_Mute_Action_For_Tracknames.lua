dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

------------------------------------------------------------
---- created Mute Button-Actions:                       ----
---- you give a name and these Mute Button Actions will ----
---- toggle the Mute-envelope-lane of a track that is   ----
---- named like that you've given                       ----
---- these mute-actions are instantly available in the  ----
---- Action->ShowActionList Dialog.                     ----
------------------------------------------------------------

MuteFile1=ultraschall.Script_Path.."UltraschallTemplates"..ultraschall.Separator.."Ultraschall_NameMute_template.lua"
MuteFile2=ultraschall.Script_Path.."UltraschallTemplates"..ultraschall.Separator.."Ultraschall_NameMuteToggle_template.lua"
MuteFile3=ultraschall.Script_Path.."UltraschallTemplates"..ultraschall.Separator.."Ultraschall_NameUnMute_template.lua"

L,LL=reaper.GetUserInputs("Create New MuteButton For A Trackname", 1, "Trackname for new MuteButton","")

if LL=="" then reaper.MB("Mute Button Not Created!\nNo Name Given.","Failure",0) return -1 end 
tempLL=string.gsub(LL, "\\", "")
tempLL=string.gsub(tempLL, "/", "")
tempLL=string.gsub(tempLL, ":", "")
if tempLL=="" then reaper.MB("Mute Button Not Created!\nName must contain at least on letter or number!","Failure",0) return -1 end 

LuaLL=string.format('%q', LL)
LuaLL=LuaLL:sub(2,-2)

--[[if reaper.file_exists(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_Mute.lua")==true 
  or reaper.file_exists(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_UnMute.lua")==true 
  or reaper.file_exists(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_ToggleMute.lua")==true then 
      reaper.MB("Name already exists! Please choose another one.", "Failure", 0) return -1 
end
--]]
contents, linenumbers, numberoflines = ultraschall.ReadValueFromFile(MuteFile1, "Trackname=")
contents, correctnumberoflines = ultraschall.ReadLinerangeFromFile(MuteFile1, 1, linenumbers-1) 
contents2, correctnumberoflines2 = ultraschall.ReadLinerangeFromFile(MuteFile1, linenumbers+1, ultraschall.CountLinesInFile(MuteFile1)+1) 
contents3=contents.."\nTrackname=\""..LuaLL.."\"\n"..contents2
--reaper.ShowConsoleMsg(contents3)
retval = ultraschall.WriteValueToFile(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_Mute.lua", contents3, false)


contents, linenumbers, numberoflines = ultraschall.ReadValueFromFile(MuteFile2, "Trackname=")
contents, correctnumberoflines = ultraschall.ReadLinerangeFromFile(MuteFile2, 1, linenumbers-1) 
contents2, correctnumberoflines2 = ultraschall.ReadLinerangeFromFile(MuteFile2, linenumbers+1, ultraschall.CountLinesInFile(MuteFile2)+1)
contents3=contents.."\nTrackname=\""..LuaLL.."\"\n"..contents2
--reaper.ShowConsoleMsg(contents2)
retval = ultraschall.WriteValueToFile(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_ToggleMute.lua", contents3, false)

--reaper.MB("","",0)

contents, linenumbers, numberoflines = ultraschall.ReadValueFromFile(MuteFile3, "Trackname=")
contents, correctnumberoflines = ultraschall.ReadLinerangeFromFile(MuteFile3, 1, linenumbers-1) 
contents2, correctnumberoflines2 = ultraschall.ReadLinerangeFromFile(MuteFile3, linenumbers+1, ultraschall.CountLinesInFile(MuteFile3)+1) 
contents3=contents.."\nTrackname=\""..LuaLL.."\"\n"..contents2
--reaper.ShowConsoleMsg(contents3)
retval = ultraschall.WriteValueToFile(ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_UnMute.lua", contents3, false)

integer=reaper.AddRemoveReaScript(true, 0, ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_Mute.lua", false)
integer=reaper.AddRemoveReaScript(true, 0, ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_UnMute.lua", false)
integer=reaper.AddRemoveReaScript(true, 0, ultraschall.Script_Path.."ultraschall_Trackname_"..tempLL.."_ToggleMute.lua", true)
--]]


