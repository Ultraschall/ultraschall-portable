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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
ultraschall.ShowErrorMessagesInReascriptConsole(true)

NumFuncs=progresscounter()

-- set this to the folder, that you want to create a reapack of
SourceDir=reaper.GetResourcePath().."/UserPlugins/"--"c:/Ultraschall-Hackversion_3.2_alpha_Februar2019/UserPlugins/"

retval, Version = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", SourceDir.."/ultraschall_api/IniFiles/ultraschall_api.ini")

if ultraschall.US_BetaFunctions==true then
  BetaRelease="(Ultraschall-API pre-release-version: Build "..Version.." from "..os.date()..")"
else
  BetaRelease=""
end

--if lulu==nil then return end

--!!TODO
-- script has issues with urls, that contain spaces and other characters in them, that aren't url-suitable.

Docs={12,
"ultraschall_Add_ExampleScripts_To_Reaper.lua",
"ultraschall_Add_Developertools_To_Reaper.lua",
"ultraschall_Help_Reaper_Api_Documentation.lua",
"ultraschall_Help_Reaper_Api_Video_Documentation.lua",
"ultraschall_Help_Reaper_Api_Web_Documentation.lua",
"ultraschall_Help_Reaper_ConfigVars_Documentation.lua",
"ultraschall_Help_Ultraschall_Api_Functions_Reference.lua",
"ultraschall_Help_Ultraschall_Api_Introduction_and_Concepts.lua",
"ultraschall_OpenFolder_Api_Documentation.lua",
"ultraschall_OpenFolder_Api_ExampleScripts.lua",
"ultraschall_Remove_ExampleScripts_From_Reaper.lua",
"ultraschall_Remove_Developertools_From_Reaper.lua"
}


-- remove all temp-files
found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."/ultraschall_api/temp/")
for i=1, found_files do
  os.remove(files_array[i])
end

C3,C,C1,C2,C4,C5,C6,C7=ultraschall.GetApiVersion()

versionnumber, version, date, beta, tagline = ultraschall.GetApiVersion()
majorversion, subversion, bits, Os, portable = ultraschall.GetReaperAppVersion()

if beta~="" then beta="-"..beta end


SWS=reaper.CF_GetSWSVersion("")
JS= reaper.JS_ReaScriptAPI_Version()

C2vers=string.gsub(C2," ","")
C2vers=C2vers:lower()
if C2vers~="" then C2vers="_"..C2vers end


-- set this to the online-repo of the Ultraschall-API
--Url="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API4.00-beta2.71/"
Url="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API-4.00-beta2.9/"
--Url="file:///c:/Ultraschall-Api-Git-Repo/Ultraschall-Api-for-Reaper/" -- for reapindex-tests first
Url2="https://raw.githubusercontent.com/Ultraschall/ultraschall-lua-api-for-reaper/Ultraschall-API-4.00-"..C2vers.."/"

-- set this to the repository-folder of the api on your system
Target_Dir="c:\\Ultraschall-Api-Git-Repo\\Ultraschall-Api-for-Reaper\\"

found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."/ultraschall_api")

--remove unneeded files:
for i=found_files, 1, -1 do
    if files_array[i]:match("EventManager_Startup.ini") then table.remove(files_array,i) found_files=found_files-1 end
end

L=ultraschall.MakeCopyOfFile_Binary(SourceDir.."/ultraschall_api.lua", Target_Dir.."/ultraschall_api.lua")
L=ultraschall.MakeCopyOfFile_Binary(SourceDir.."/ultraschall_api_readme.txt", Target_Dir.."/ultraschall_api_readme.txt")


ReadMe_Reaper_Internals=[[
compiled by Meo Mespotine(mespotine.de) for the ultraschall.fm-project

Documentation for Reaper-Internals ]]..majorversion.."."..subversion..[[ and Ultraschall Api 4.00]]..beta..[[, SWS ]]..SWS..[[, JS-extension-plugin ]]..JS..[[ and ReaPack

Written and compiled by Meo Mespotine (mespotine.de) for the Ultraschall.FM-project.
licensed under creative-commons by-sa-nc-license

Some docs are enhanced versions of the original docs and the Reaper-logo is by the Cockos Inc.
The SWS-logo is by SWS-extension.org

You can download the full Ultraschall-API-framework at ultraschall.fm/api
]]

ultraschall.WriteValueToFile(SourceDir.."/ultraschall_api/Reaper-Internals-readme.txt", ReadMe_Reaper_Internals)

Batter=[[
cd ]]..SourceDir..[[

del c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\ultraschall_api4.00]]..C2vers..[[.zip
zip.exe -r c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\ultraschall_api4.00]]..C2vers..[[.zip *.lua *.txt ultraschall_api

del c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\Reaper-Internals-Ultraschall-Api-Docs.zip
cd ultraschall_api

..\zip.exe -r c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\Reaper-Internals-Ultraschall-Api-Docs.zip Documentation\* Reaper-Internals-readme.txt c:\Reaper-Internal-Docs-Miscellaneous_Maybe_Helpful_Files
del Reaper-Internals-readme.txt
del Scripts\Tools\batter.bat
]]


ultraschall.WriteValueToFile(SourceDir.."/ultraschall_api/Scripts/Tools/batter.bat", Batter)
--if l==nil then return end

--Version=(tonumber(C)*100)+(tonumber(C2:match(" (.*)"))/10).."04"
retval, Version = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", SourceDir.."/ultraschall_api/IniFiles/ultraschall_api.ini")
--Version=Version+1
D=os.date()
Date=string.gsub(D:match("(.-) "),"%.","-").."T"..D:match(" (.*)").."Z"
Hotfix="00"

Markdown2RTF="c:\\Program Files (x86)\\Pandoc\\pandoc -f markdown -w plain -s -o c:\\temp\\tempfile.rtf c:\\temp\\tempfile"

ChangeLog=ultraschall.ReadFullFile(SourceDir.."/ultraschall_api/Changelog-Api.txt")
ChangeLog=string.gsub(ChangeLog, "<TODO>.-</TODO>", "")
--reaper.CF_SetClipboard(ChangeLog)
ultraschall.WriteValueToFile("c:\\temp\\tempfile", ChangeLog)

reaper.ExecProcess(Markdown2RTF,0)
ChangeLog=ultraschall.ReadFullFile("c:\\temp\\tempfile.rtf")


XML_start=
[[<?xml version="1.0" encoding="utf-8"?>
<index version="1" name="Ultraschall-API">
  <category name="Ultraschall-API-category">
    <reapack name="Ultraschall API package" type="extension">
      <version name="]]..Version.."."..Hotfix..[[" author="Meo Mespotine">
]]

XML_end=[[<changelog><![CDATA[]]..ChangeLog.."]]>\n</changelog>\n"..[[
      </version>
      <metadata>
        <link rel="website">http://ultraschall.fm/api/</link>
        <link rel="donation" href="http://ultraschall.fm/danke">Label</link>
        <description><![CDATA[{\rtf1\ansi\deff0\adeflang1025
{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\froman\fprq2\fcharset2 Symbol;}{\f2\fswiss\fprq2\fcharset0 Arial;}{\f3\fswiss\fprq2\fcharset128 Arial;}{\f4\fnil\fprq0\fcharset0 Times New Roman;}{\f5\fnil\fprq0\fcharset128 OpenSymbol{\*\falt Arial Unicode MS};}{\f6\fnil\fprq2\fcharset0 Microsoft YaHei;}{\f7\fnil\fprq2\fcharset0 Mangal;}{\f8\fnil\fprq0\fcharset128 Mangal;}}
{\colortbl;\red0\green0\blue0;\red0\green0\blue128;\red128\green128\blue128;}
{\stylesheet{\s0\snext0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031 Standard;}
{\*\cs15\snext15\hich\af5\dbch\af5\loch\f5 Aufz?hlungszeichen;}
{\*\cs16\snext16\cf2\ul\ulc0\langfe255\lang255\lang255 Internetlink;}
{\s17\sbasedon0\snext18\sb240\sa120\keepn\hich\af6\dbch\af7\afs28\loch\f2\fs28 Überschrift;}
{\s18\sbasedon0\snext18\sb0\sa120 Textkörper;}
{\s19\sbasedon18\snext19\sb0\sa120\dbch\af8 Liste;}
{\s20\sbasedon0\snext20\sb120\sa120\noline\i\dbch\af8\afs24\ai\fs24 Beschriftung;}
{\s21\sbasedon0\snext21\noline\dbch\af8 Verzeichnis;}
}{\info{\creatim\yr2019\mo1\dy29\hr3\min55}{\revtim\yr0\mo0\dy0\hr0\min0}{\printim\yr0\mo0\dy0\hr0\min0}{\comment OpenOffice}{\vern4130}}\deftab709

{\*\pgdsctbl
{\pgdsc0\pgdscuse195\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\pgdscnxt0 Standard;}}
\formshade\paperh16838\paperw11906\margl1134\margr1134\margt1134\margb1134\sectd\sbknone\sectunlocked1\pgndec\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\ftnbj\ftnstart1\ftnrstcont\ftnnar\aenddoc\aftnrstcont\aftnstart1\aftnnrlc
\pgndec\pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b\afs40\ab\rtlch \ltrch\loch\fs40\loch\f3
Ultraschall API}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b\ab\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
a ]]..NumFuncs..[[ Lua-functions library for Reaper]]..BetaRelease..[[.}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
The Ultraschall-Extension is intended to be an extension for the DAW Reaper, that enhances it with podcast functionalities. Most DAWs are intended to be used by musicians, for music, but podcasters have their own needs to be fulfilled. In fact, in some places their needs differ from the needs of a musician heavily. Ultraschall is intended to optimise the Reaper's workflows, by reworking them with functionalities for the special needs of podcasters.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
The Ultraschall-Framework itself is intended to include a set of Lua-functions, that help creating such functionalities. By giving programmers helper functions to get access to each and every corner of Reaper. That way, extending Ultraschall and Reaper is more comfortable to do.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
This API was to be used within Ultraschall only, but quickly evolved into a huge ]]..NumFuncs..[[ function-library, that many 3rd-party programmers and scripters may find use in, with many useful features, like:}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Rendering - you can render your projects without having to use the render-dialog. You can customize the rendering-workflow in every way you want. Just create a renderstring and pass it over to RenderProject or RenderProjectRegions}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Navigation, Follow and Arrangeview-Manipulation - get/set cursors, zoom, autoscroll-management, scroll, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ArrangeView-Snapshots - you can save, retrieve snapshots of the arrangeview, including position, zoomstates to quickly jump through parts of your project}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Trackstates - you can access and set all(!) track-states available}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Mediaitem-states - you can access and set many mediaitem-states (more will follow)}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ItemExtStates/TrackExtStates - you can save additional metadata easily for specific tracks and items using ItemExtStates and TrackExtStates}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- File access - many helperfunctions for reading, writing, copying files. No more hassle writing it yourself! e.g ReadFullFile, WriteValueToFile, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Cough-Mute-management - you can write your own cough-buttons, that set the state of the mute-envelope of a track easily}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Marker - extensive set of marker functions, get, set, export, import, enumerate, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Spectrogram - you can program the spectrogram-view}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Routing - you can set Sends/Receives and HWOuts more straightforward than with Reaper's own Routing-functions. Includes mastertrack as well.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Get MediaItems - you can get all media-items within a time-range AND within the tracks you prefer; a 2D-approach e.g. GetAllMediaItemsBetween and GetMediaItemsAtPosition, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Gaps between items - you can get the gaps between items in a track, using GetGapsBetweenItems}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Edit item(s) - Split, Cut, Copy, Paste, Move, RippleCut, RippleInsert, SectionCut by tracks AND time/start to endposition e.g. RippleCut, RippleInsert, SectionCut, SplitMediaItems_Position, MoveMediaItemsBefore_By, MoveMediaItemsSectionTo and many more}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Previewing MediaItems and files - you can preview MediaItems and files without having to start playback of a project}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- KB-Ini-Management - manipulate the reaper-kb.ini-file with custom-settings}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Checking for Datatypes - check all datatypes introduced with Ultraschall-API and all Lua/Reaper-datatypes}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- UndoManagement - functions for easily making undoing of functions as well as preventing creating an undo-point}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Run an Action for Items/Tracks - apply actions to specific items/tracks}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Checking for changed projecttabs - check, if projecttabs have been added/removed}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ExtState-Management - an extensive set of functions for working with extstates as well as ini-files}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Data Manipulation - manipulate a lot of your data, including bitwise-integers, tables, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Clipboard-Management - get items from clipboard, put them to clipboard, even multiple ones}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Error Messaging System - all functions create useful error-messages that can be shown using, eg: ShowLastErrorMessage, for easier debugging}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- tons of other helper-functions}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- my Reaper-Internals Documentation AND}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
it's documented with this documentation. :D}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
Happy coding and let's see, what you can do with it :D}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
Meo Mespotine (mespotine.de) (ultraschall.fm/api)}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
For more information about Ultraschall itself, see ultraschall.fm and if you want to support us, see ultraschall.fm/danke for donating to us.}
\par }]].."]]></description>"..[[
      </metadata>
    </reapack>
  </category>
  <metadata>
    <link rel="website">http://ultraschall.fm/api/</link>
    <link rel="donation" href="http://ultraschall.fm/danke">Label</link>
    <description><![CDATA[{\rtf1\ansi\deff0\adeflang1025
{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\froman\fprq2\fcharset2 Symbol;}{\f2\fswiss\fprq2\fcharset0 Arial;}{\f3\fswiss\fprq2\fcharset128 Arial;}{\f4\fnil\fprq0\fcharset0 Times New Roman;}{\f5\fnil\fprq0\fcharset128 OpenSymbol{\*\falt Arial Unicode MS};}{\f6\fnil\fprq2\fcharset0 Microsoft YaHei;}{\f7\fnil\fprq2\fcharset0 Mangal;}{\f8\fnil\fprq0\fcharset128 Mangal;}}
{\colortbl;\red0\green0\blue0;\red0\green0\blue128;\red128\green128\blue128;}
{\stylesheet{\s0\snext0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031 Standard;}
{\*\cs15\snext15\hich\af5\dbch\af5\loch\f5 Aufz?hlungszeichen;}
{\*\cs16\snext16\cf2\ul\ulc0\langfe255\lang255\lang255 Internetlink;}
{\s17\sbasedon0\snext18\sb240\sa120\keepn\hich\af6\dbch\af7\afs28\loch\f2\fs28 Überschrift;}
{\s18\sbasedon0\snext18\sb0\sa120 Textkörper;}
{\s19\sbasedon18\snext19\sb0\sa120\dbch\af8 Liste;}
{\s20\sbasedon0\snext20\sb120\sa120\noline\i\dbch\af8\afs24\ai\fs24 Beschriftung;}
{\s21\sbasedon0\snext21\noline\dbch\af8 Verzeichnis;}
}{\info{\creatim\yr2019\mo1\dy29\hr3\min55}{\revtim\yr0\mo0\dy0\hr0\min0}{\printim\yr0\mo0\dy0\hr0\min0}{\comment OpenOffice}{\vern4130}}\deftab709

{\*\pgdsctbl
{\pgdsc0\pgdscuse195\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\pgdscnxt0 Standard;}}
\formshade\paperh16838\paperw11906\margl1134\margr1134\margt1134\margb1134\sectd\sbknone\sectunlocked1\pgndec\pgwsxn11906\pghsxn16838\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\ftnbj\ftnstart1\ftnrstcont\ftnnar\aenddoc\aftnrstcont\aftnstart1\aftnnrlc
\pgndec\pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b\afs30\ab\rtlch \ltrch\loch\fs30\loch\f3
Ultraschall API}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b\ab\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
a ]]..NumFuncs..[[ Lua-functions library for Reaper]]..BetaRelease..[[.}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s0\nowidctlpar{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\cf0\kerning1\hich\af9\langfe2052\dbch\af7\afs24\lang1081\loch\f0\fs24\lang1031{\b0\ab0\rtlch \ltrch\loch\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
The Ultraschall-Extension is intended to be an extension for the DAW Reaper, that enhances it with podcast functionalities. Most DAWs are intended to be used by musicians, for music, but podcasters have their own needs to be fulfilled. In fact, in some places their needs differ from the needs of a musician heavily. Ultraschall is intended to optimise the Reaper's workflows, by reworking them with functionalities for the special needs of podcasters.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
The Ultraschall-Framework itself is intended to include a set of Lua-functions, that help creating such functionalities. By giving programmers helper functions to get access to each and every corner of Reaper. That way, extending Ultraschall and Reaper is more comfortable to do.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
This API was to be used within Ultraschall only, but quickly evolved into a huge ]]..NumFuncs..[[ function-library, that many 3rd-party programmers and scripters may find use in, with many useful features, like:}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Rendering - you can render your projects without having to use the render-dialog. You can customize the rendering-workflow in every way you want. Just create a renderstring and pass it over to RenderProject or RenderProjectRegions}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Navigation, Follow and Arrangeview-Manipulation - get/set cursors, zoom, autoscroll-management, scroll, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ArrangeView-Snapshots - you can save, retrieve snapshots of the arrangeview, including position, zoomstates to quickly jump through parts of your project}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Trackstates - you can access and set all(!) track-states available}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Mediaitem-states - you can access and set many mediaitem-states (more will follow)}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ItemExtStates/TrackExtStates - you can save additional metadata easily for specific tracks and items using ItemExtStates and TrackExtStates}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- File access - many helperfunctions for reading, writing, copying files. No more hassle writing it yourself! e.g ReadFullFile, WriteValueToFile, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Cough-Mute-management - you can write your own cough-buttons, that set the state of the mute-envelope of a track easily}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Marker - extensive set of marker functions, get, set, export, import, enumerate, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Spectrogram - you can program the spectrogram-view}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Routing - you can set Sends/Receives and HWOuts more straightforward than with Reaper's own Routing-functions. Includes mastertrack as well.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Get MediaItems - you can get all media-items within a time-range AND within the tracks you prefer; a 2D-approach e.g. GetAllMediaItemsBetween and GetMediaItemsAtPosition, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Gaps between items - you can get the gaps between items in a track, using GetGapsBetweenItems}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Edit item(s) - Split, Cut, Copy, Paste, Move, RippleCut, RippleInsert, SectionCut by tracks AND time/start to endposition e.g. RippleCut, RippleInsert, SectionCut, SplitMediaItems_Position, MoveMediaItemsBefore_By, MoveMediaItemsSectionTo and many more}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Previewing MediaItems and files - you can preview MediaItems and files without having to start playback of a project}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- KB-Ini-Management - manipulate the reaper-kb.ini-file with custom-settings}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Checking for Datatypes - check all datatypes introduced with Ultraschall-API and all Lua/Reaper-datatypes}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- UndoManagement - functions for easily making undoing of functions as well as preventing creating an undo-point}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Run an Action for Items/Tracks - apply actions to specific items/tracks}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Checking for changed projecttabs - check, if projecttabs have been added/removed}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- ExtState-Management - an extensive set of functions for working with extstates as well as ini-files}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Data Manipulation - manipulate a lot of your data, including bitwise-integers, tables, etc}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Clipboard-Management - get items from clipboard, put them to clipboard, even multiple ones}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Child-scripts - start scripts numerous times and be able to pass parameters and returnvalues back and forth; adds uniqe scriptidentifier to do that}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Defer-function-alternative - run defer-cycles only every nth cycle/seconds and be able to stop a defer loop from inside and outside of a script instance}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- Error Messaging System - all functions create useful error-messages that can be shown using, eg: ShowLastErrorMessage, for easier debugging}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- tons of other helper-functions}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\fs24\loch\f3
    }{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
- my Reaper-Internals Documentation AND}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
it's documented with this documentation. :D}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
Happy coding and let's see, what you can do with it :D}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
Meo Mespotine (mespotine.de) (ultraschall.fm/api)}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
For more information about Ultraschall itself, see ultraschall.fm and if you want to support us, see ultraschall.fm/danke for donating to us.}
\par \pard\plain \s18\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
}
\par \pard\plain \s18\sb0\sa120\sb0\sa120{\b0\afs24\ab0\rtlch \ltrch\loch\fs24\loch\f3
PS: In this documentation, I assume you have some basic knowledge in Lua and in using Reaper's own API-functions. Explaining both of these is beyond the scope of this doc.}
\par }]].."]]></description>"..[[
  </metadata>
</index>]]


SourceDir=string.gsub(SourceDir, "/", ultraschall.Separator)
A0="c:\\windows\\system32\\cmd.exe /Q /C xcopy "..SourceDir.."\\ultraschall_api "..Target_Dir.."\\ultraschall_api\\ /T /E /Y"

--reaper.CF_SetClipboard(A0)
A,A1,A2,A3=reaper.ExecProcess(A0, 0)
  
for i=1, found_files do
  tempfile=files_array[i]:match("(ultraschall_api/.*)")
--  if tempfile==nil then tempfile=files_array[i]:match("UserPlugins(/.*)") end
  L=ultraschall.MakeCopyOfFile_Binary(files_array[i], Target_Dir..tempfile)
end


--reaper.CF_SetClipboard(A0)

-- generate ReaPack-indexfile
XML_file="\t"..[[<source file="ultraschall_api.lua" type="extension">]]..Url.."/ultraschall_api.lua</source>\n"
XML_file=XML_file.."\t"..[[<source file="ultraschall_api_readme.txt" type="extension">]]..Url.."/ultraschall_api_readme.txt</source>\n"


for i=1, found_files do
  tempfile=files_array[i]:match("(ultraschall_api/.*)")
  if tempfile==nil then tempfile=files_array[i]:match("UserPlugins(/.*)") end
  XML_file=XML_file.."\t<source file=\"/"..tempfile.."\" type=\"extension\">"..Url..tempfile.."</source>\n"
end

for i=1, Docs[1] do
  XML_file=XML_file.."\t<source main=\"true\" file=\"/"..Docs[i+1].."\" type=\"script\">"..Url.."/ultraschall_api/Scripts/"..Docs[i+1].."</source>\n"
end

--print2(XML_file:sub(1,2000))
--print(XML_end)

B=ultraschall.WriteValueToFile(Target_Dir.."/ultraschall_api_index-beta_rename_when_installing_it_works.xml", XML_start..XML_file..XML_end)

-- generate ReaPack-indexfile for prerelease-alphas
XML_file="\t"..[[<source file="ultraschall_api.lua" type="extension">]]..Url2.."/ultraschall_api.lua</source>\n"
XML_file=XML_file.."\t"..[[<source file="ultraschall_api_readme.txt" type="extension">]]..Url2.."/ultraschall_api_readme.txt</source>\n"


for i=1, found_files do
  tempfile=files_array[i]:match("(ultraschall_api/.*)")
  if tempfile==nil then tempfile=files_array[i]:match("UserPlugins(/.*)") end
  XML_file=XML_file.."\t<source file=\"/"..tempfile.."\" type=\"extension\">"..Url2..tempfile.."</source>\n"
end


for i=1, Docs[1] do
  XML_file=XML_file.."\t<source main=\"true\" file=\"/"..Docs[i+1].."\" type=\"script\">"..Url2.."/ultraschall_api/Scripts/"..Docs[i+1].."</source>\n"
end

--  print2(XML_file:sub(-1000,-1))
  
--print2(XML_file:sub(1,2000))
--print(XML_end)

B=ultraschall.WriteValueToFile(Target_Dir.."/ultraschall_api_prerelease_index.xml", XML_start..XML_file..XML_end)

ultraschall.ShowLastErrorMessage()

--os.execute("c:\\Ultraschall-Hackversion_3.2_alpha_Februar2019\\UserPlugins\\ultraschall_api\\Scripts\\Tools\\batter.bat")
os.execute(SourceDir.."/ultraschall_api/Scripts/Tools/batter.bat")
reaper.MB("Done", "", 0)
