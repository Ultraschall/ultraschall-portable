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

ultraschall_override=true
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

ultraschall.ShowErrorMessagesInReascriptConsole(true)

NumFuncs=progresscounter()

--os.remove(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/ultraschall_ModulatorLoad3000.lua-")
os.remove(ultraschall.Api_Path.."ultraschall_api/Documentation/Reaper_StateChunk_Docs.html")

-- set this to the folder, that you want to create a reapack of
SourceDir=ultraschall.Api_InstallPath--reaper.GetResourcePath().."/UserPlugins/"--"c:/Ultraschall-Hackversion_3.2_alpha_Februar2019/UserPlugins/"

retval, Version = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", SourceDir.."/ultraschall_api/IniFiles/ultraschall_api.ini")

if ultraschall.US_BetaFunctions==true then
  BetaRelease="(Ultraschall-API pre-release-version: Build "..Version.." from "..os.date()..")"
else
  BetaRelease=""
end

--if lulu==nil then return end

--!!TODO
-- script has issues with urls, that contain spaces and other characters in them, that aren't url-suitable.

Docs={
"ultraschall_Add_ExampleScripts_To_Reaper.lua",
"ultraschall_Add_Developertools_To_Reaper.lua",
"ultraschall_Help_Reaper_Api_Documentation.lua",
"ultraschall_Help_Reaper_Api_Video_Documentation.lua",
"ultraschall_Help_Reaper_Api_Web_Documentation.lua",
"ultraschall_Help_Reaper_ConfigVars_Documentation.lua",
"ultraschall_Help_Ultraschall_Api_Functions_Reference.lua",
"ultraschall_Help_Ultraschall_Api_Introduction_and_Concepts.lua",
"ultraschall_Help_Lua_Reference_Manual.lua",
"ultraschall_OpenFolder_Api_Documentation.lua",
"ultraschall_OpenFolder_Api_ExampleScripts.lua",
"ultraschall_Remove_ExampleScripts_From_Reaper.lua",
"ultraschall_Remove_Developertools_From_Reaper.lua",
"Ultraschall_API_Settings.lua",
"ReaGirl_OpenFolder_ExampleScripts.lua",
"ReaGirl_Help_Functions_Documentation.lua",
"ReaGirl_Help_Introduction_Concepts_Tutorials_Documentation.lua"
}

Devtools={
"/Tools/DeveloperScripts/ultraschall_developertool_ActionlistToIni-Converter.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Check_scripts_in_folder_for_deprecated_functions.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_CheckForNewConfigVars.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Compare_LangPacks.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Copy_Descriptions_and_IDs_from_Listview_of_opened_MetaData-Dialog.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Create_New_Script_With_Dialog.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Display-Altered-ConfigFile-Entries.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Display-Altered-Config-Vars.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Env_State_Diffs_Monitor.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_EnvelopeStateChunk_from_Clipboard_envelope_to_under_mouse.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_EnvelopeStateChunk_from_Clipboard_to_selected_envelope.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_EnvelopeStateChunk_to_Clipboard_envelope_under_mouse.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_EnvelopeStateChunk_to_Clipboard_selected_envelope.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Find_Duplicated_Lines_In_Clipboard.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_GetPitchShiftModes.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_gfx_deltablit_displayer.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_HWND-Displayer.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Item_State_Diffs_Monitor.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_ItemStateChunk_from_Clipboard_to_first_selected_item.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_ItemStateChunk_from_Clipboard_to_item_mouse.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_ItemStateChunk_to_Clipboard_first_selected_item.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_ItemStateChunk_to_Clipboard_item_under_mouse.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_LangPack2Developer_langpack_converter.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_MonitorParmModulation.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Project_State_Diffs_Monitor.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_SortLinesInClipboardText.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_StateInspector.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Theme_Parameter_Monitor.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Toggle_Logging_SetExtState_SetProjExtState_access.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_Track_State_Diffs_Monitor.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_TrackStateChunk_from_Clipboard_to_first_selected_track.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_TrackStateChunk_from_Clipboard_to_track_under_mouse.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_TrackStateChunk_to_Clipboard_first_selected_track.lua",
"/Tools/DeveloperScripts/ultraschall_developertool_TrackStateChunk_to_Clipboard_track_under_mouse.lua"}

IgnoreFiles={
"/ultraschall_api/Scripts/Tools/DeveloperScripts/Ultraschall_StateInspector/Ultraschall-Inspector.ini"
}

_,_,_, Devtools = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."/ultraschall_api/Scripts/Tools/DeveloperScripts/")
SourceDir=string.gsub(SourceDir,"\\", "/")
for i=#Devtools, 1, -1 do
  Devtools[i]=Devtools[i]:match("(/Tools/DeveloperScripts/.*)")
  if Devtools[i]:match("%.lua")==nil then table.remove(Devtools, i) end
end



-- remove all temp-files
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."/ultraschall_api/temp/")
for i=1, found_files do
  os.remove(files_array[i])
end





C3,C,C1,C2,C4,C5,C6,C7=ultraschall.GetApiVersion()

versionnumber, version, date, beta, tagline = ultraschall.GetApiVersion()
majorversion, subversion, bits, Os, portable = ultraschall.GetReaperAppVersion()

--if lol==nil then return end
--if beta~="" then beta="."..beta end


SWS=reaper.CF_GetSWSVersion("")
JS= reaper.JS_ReaScriptAPI_Version()

C2vers=string.gsub(C2," ","")
C2vers=C2vers:lower()
if C2vers~="" then C2vers="_"..C2vers end

--if lol==nil then return end
-- set this to the online-repo of the Ultraschall-API
--Url="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API4.00-beta2.71/"
Url="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API-"..C.."/"..""
--Url="file:///c:/Ultraschall-Api-Git-Repo/Ultraschall-Api-for-Reaper/" -- for reapindex-tests first
Url2="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API-"..C.."/"..""

-- set this to the repository-folder of the api on your system
--_Dir="c:\\Ultraschall-Api-Git-Repo\\Ultraschall-Api-for-Reaper\\"
Target_Dir="c:\\Users\\Meo\\Documents\\GitHub\\ultraschall-lua-api-for-reaper\\"

found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."/ultraschall_api")

-- create folders, if not existing
for i=1, found_dirs do
  dirs=dirs_array[i]:match("UserPlugins/(.*)")
  --print(Target_Dir..dirs)
  reaper.RecursiveCreateDirectory(Target_Dir.."/"..dirs,0)
end

--remove unneeded files:
for i=found_files, 1, -1 do
    if files_array[i]:match("EventManager_Startup.ini") then table.remove(files_array,i) found_files=found_files-1 end
    if files_array[i]:match("Ultraschall-Inspector.ini") then table.remove(files_array,i) found_files=found_files-1 end
end


L=ultraschall.MakeCopyOfFile_Binary(SourceDir.."/ultraschall_api.lua", Target_Dir.."/ultraschall_api.lua")
L=ultraschall.MakeCopyOfFile_Binary(SourceDir.."/ultraschall_api_readme.txt", Target_Dir.."/ultraschall_api_readme.txt")
L=ultraschall.MakeCopyOfFile_Binary(SourceDir.."/reagirl.lua", Target_Dir.."/reagirl.lua")


ReadMe_Reaper_Internals=[[
compiled by Meo Mespotine(mespotine.de) for the ultraschall.fm-project

Documentation for Reaper-Internals ]]..majorversion.."."..subversion..[[ and Ultraschall Api ]]..C.." "..beta..[[, SWS ]]..SWS..[[, JS-extension-plugin ]]..JS..[[ and ReaPack

Written and compiled by Meo-Ada Mespotine (mespotine.de) for the Ultraschall.FM-project.
licensed under creative-commons by-sa-nc-license

Some docs are enhanced versions of the original docs and the Reaper-logo is by the Cockos Inc.
The SWS-logo is by SWS-extension.org

You can download the full Ultraschall-API-framework at ultraschall.fm/api
]]

ultraschall.WriteValueToFile(SourceDir.."/ultraschall_api/Reaper-Internals-readme.txt", ReadMe_Reaper_Internals)

Batter=[[
cd ]]..SourceDir..[[

del ]]..Target_Dir..[[\ultraschall_api]]..C..C2vers..[[.zip
zip.exe -r ]]..Target_Dir..[[\ultraschall_api]]..C..C2vers..[[.zip *.lua *.txt ultraschall_api

del ultraschall_api\Reaper-Internals-readme.txt
del ultraschall_api\Scripts\Tools\batter.bat
pause
]]


ultraschall.WriteValueToFile(SourceDir.."/ultraschall_api/Scripts/Tools/batter.bat", Batter)
--if l==nil then return end

--Version=(tonumber(C)*100)+(tonumber(C2:match(" (.*)"))/10).."04"
retval, Version = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", SourceDir.."/ultraschall_api/IniFiles/ultraschall_api.ini")
--Version=Version+1
D=os.date()
Date=string.gsub(D:match("(.-) "),"%.","-").."T"..D:match(" (.*)").."Z"
Hotfix="00"

Markdown2RTF="c:\\Program Files\\Pandoc\\pandoc -f markdown -w plain -s -o c:\\temp\\tempfile.rtf c:\\temp\\tempfile"

ChangeLog=ultraschall.ReadFullFile(SourceDir.."/ultraschall_api/Changelog-Api.txt")
ChangeLog=string.gsub(ChangeLog, "<TODO>.-</TODO>", "")
ChangeLog=ChangeLog:match("(.-)\n%-%-%-")
--print2(ChangeLog)
--if LOL==nil then return end

--reaper.CF_SetClipboard(ChangeLog)
ultraschall.WriteValueToFile("c:\\temp\\tempfile", ChangeLog)
SLEM()
reaper.ExecProcess(Markdown2RTF,0)
ChangeLog=ultraschall.ReadFullFile("c:\\temp\\tempfile.rtf")



XML_start=
[[<?xml version="1.0" encoding="utf-8"?>
<index version="1" name="Ultraschall-API and ReaGirl">
  <category name="Ultraschall-API-category">
    <reapack name="Ultraschall API and ReaGirl package" type="extension">
      <version name="]]..Version.."."..Hotfix..[[" author="Meo-Ada Mespotine">
]]

XML_end=[[<changelog><![CDATA[]]..ChangeLog.."]]>\n</changelog>\n"..[[
      </version>
      </reapack>
  </category>
      <metadata>
        <link rel="website">http://mespotine.de</link>
        <link rel="donation" href="http://ultraschall.fm/danke">Label</link>
        <description><![CDATA[{\rtf1\ansi\deff0\adeflang1025
        {\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\froman\fprq2\fcharset2 Symbol;}{\f2\fswiss\fprq2\fcharset0 Arial;}{\f3\fnil\fprq0\fcharset128 OpenSymbol{\*\falt Arial Unicode MS};}{\f4\fswiss\fprq2\fcharset128 Arial;}{\f5\fnil\fprq2\fcharset0 Microsoft YaHei;}{\f6\fnil\fprq2\fcharset0 Mangal;}{\f7\fnil\fprq0\fcharset128 Mangal;}{\f8\froman\fprq0\fcharset128 ;}}
        {\colortbl;\red0\green0\blue0;\red0\green0\blue128;\red128\green128\blue128;}
        {\stylesheet{\s0\snext0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031 Standard;}
        {\*\cs15\snext15\hich\af3\dbch\af3\loch\f3 Aufz?hlungszeichen;}
        {\*\cs16\snext16\cf2\ul\ulc0\langfe255\lang255 Internetlink;}
        {\s17\sbasedon0\snext18{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb240\sa120\keepn\cf0\kerning1\hich\af5\langfe2052\dbch\af6\afs28\loch\f2\fs28\lang1031 Überschrift;}
        {\s18\sbasedon0\snext18{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning1\hich\af6\langfe2052\dbch\af8\loch\f0\fs24\lang1031 Textkörper;}
        {\s19\sbasedon23\snext19{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af7\langfe2052\dbch\af0\loch\f0\fs24\lang1031 Liste;}
        {\s20\sbasedon0\snext20{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb120\sa120\cf0\i\kerning0\hich\af7\langfe2052\dbch\af0\ai\loch\f0\fs24\lang1031 Beschriftung;}
        {\s21\sbasedon0\snext21{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning0\hich\af7\langfe2052\dbch\af0\loch\f0\fs24\lang1031 Verzeichnis;}
        {\s22\sbasedon0\snext23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb240\sa120\keepn\cf0\kerning0\hich\af6\langfe2052\dbch\af5\loch\f2\fs28\lang1031 Ãœberschrift;}
        {\s23\sbasedon0\snext23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031 TextkÃ¶rper;}
        }{\info{\creatim\yr2019\mo1\dy29\hr3\min55}{\revtim\yr0\mo0\dy0\hr0\min0}{\printim\yr0\mo0\dy0\hr0\min0}{\comment OpenOffice}{\vern41130}}\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709\deftab709
        
        {\*\pgdsctbl
        {\pgdsc0\pgdscuse195\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\pgdscnxt0 Standard;}}
        \formshade{\*\pgdscno0}\paperh16838\paperw11906\margl1134\margr1134\margt1134\margb1134\sectd\sbknone\sectunlocked1\pgndec\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\ftnbj\ftnstart1\ftnrstcont\ftnnar\aenddoc\aftnrstcont\aftnstart1\aftnnrlc
        \pgndec\pard\plain \s0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031{\b\afs40\ab\rtlch \ltrch\loch\fs40\loch\f4
        Ultraschall API and ReaGirl}
        \par \pard\plain \s0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        a ]]..NumFuncs..[[ Lua-functions library for Reaper]]..BetaRelease..[[.}
        \par \pard\plain \s0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\nowidctlpar\cf0\kerning1\hich\af6\langfe2052\dbch\af8\afs24\lang1081\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        The Ultraschall-Extension is intended to be an extension for the DAW Reaper, that enhances it with podcast functionalities. Most DAWs are intended to be used by musicians, for music, but podcasters have their own needs to be fulfilled. In fact, in some places their needs differ from the needs of a musician heavily. Ultraschall is intended to optimise the Reaper's workflows, by reworking them with functionalities for the special needs of podcasters.}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        ReaGirl is a gui-library which is accessible for blind users of Reaper. So you can build up your own guis in your scripts and can be sure, that blind users can use it.}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        After installation, you can read the docs of Ultraschall-API and ReaGirl by searching the action list for the keywords \u8222\'1eUltraschall_Help OR ReaGirl_Help\u8220\'1c. A number of actions will appear that allow you to open the corresponding help-documentation.}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        To start, I suggest you to read the Introduction_Concepts-docs first.}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        Happy coding and let's see, what you can do with it :D}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch
        }
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031{\rtlch \ltrch\loch\loch\f4
        Meo Mespotine (mespotine.de) (ultraschall.fm/api)}
        \par \pard\plain \s23{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\sb0\sa120\cf0\kerning0\hich\af0\langfe2052\dbch\af0\loch\f0\fs24\lang1031\sb0\sa120{\rtlch \ltrch\loch\loch\f4
        }
        \par }]].."]]></description>"..[[
      </metadata>
  
</index>]]


SourceDir=string.gsub(SourceDir, "/", ultraschall.Separator)
A0="c:\\windows\\system32\\cmd.exe /Q /C xcopy "..SourceDir.."\\ultraschall_api "..Target_Dir.."\\ultraschall_api\\ /T /E /Y"

A,A1,A2,A3=reaper.ExecProcess(A0, 0)
-- create directories, if not existing
for i=1, found_dirs do
  reaper.RecursiveCreateDirectory(dirs_array[i], 0)
end


for i=1, #files_array do
  tempfile=files_array[i]:match("(ultraschall_api/.*)")
  L=ultraschall.MakeCopyOfFile_Binary(files_array[i], Target_Dir..tempfile)
  retval, errcode, functionname, parmname, errormessage = ultraschall.GetLastErrorMessage()
  if errormessage~=nil then
    ultraschall.DeleteAllErrorMessages()
  end
end


COUNTMEIN=0
for i=#files_array, 1, -1 do
  if files_array[i]:match("/Tools/DeveloperScripts/") and files_array[i]:match("%.lua") then 
    table.remove(files_array, i)
  end
end

for i=#files_array, 1, -1 do
  if files_array[i]:match("Ultraschall%-Inspector%.ini") then table.remove(files_array, i) end
end

--[[ 
-- check, if file is removed sucessfully from list
for i=#files_array, 1, -1 do
  if files_array[i]:match("Ultraschall%-Inspector%.ini") then
    print2(files_array[i])
  end
end
--]]

--if lol==nil then return end


--if lol==nil then return end
-- generate ReaPack-indexfile
XML_file="\t"..[[<source file="reagirl.lua" type="extension">]]..Url.."/reagirl.lua</source>\n"
XML_file=XML_file.."\t"..[[<source file="ultraschall_api.lua" type="extension">]]..Url.."/ultraschall_api.lua</source>\n"
XML_file=XML_file.."\t"..[[<source file="ultraschall_api_readme.txt" type="extension">]]..Url.."/ultraschall_api_readme.txt</source>\n"


for i=1, #files_array do
  tempfile=files_array[i]:match("(ultraschall_api/.*)")
  if tempfile==nil then tempfile=files_array[i]:match("UserPlugins(/.*)") end
  XML_file=XML_file.."\t<source file=\"/"..tempfile.."\" type=\"extension\">"..Url..string.gsub(tempfile," ", "%%20").."</source>\n"
end

for i=1, #Docs do
  XML_file=XML_file.."\t<source main=\"true\" file=\"/"..Docs[i].."\" type=\"script\">"..Url.."/ultraschall_api/Scripts/"..Docs[i].."</source>\n"
end

for i=1, #Devtools do
  XML_file=XML_file.."\t<source main=\"true\" file=\"/"..Devtools[i]:match(".*/(.*)").."\" type=\"script\">"..Url.."/ultraschall_api/Scripts/"..Devtools[i].."</source>\n"
end


B=ultraschall.WriteValueToFile(Target_Dir.."/ultraschall_api_index-beta_rename_when_installing_it_works.xml", XML_start..XML_file..XML_end)

ultraschall.ShowLastErrorMessage()

os.execute(SourceDir.."/ultraschall_api/Scripts/Tools/batter.bat")
reaper.MB("Done\n\n\nDeleted two files, statechunk-docs!!!", "", 0)
