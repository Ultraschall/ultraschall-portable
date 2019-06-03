-- Ultraschall-XML-Reapack-generator v1.0
--
-- To Do: test on Mac
--        Linux not supported, yet

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
ultraschall.ShowErrorMessagesInReascriptConsole(true)


-- set this to the folder, that you want to create a reapack of
SourceDir="c:/Ultraschall-Api-Git-Repo/ultraschall-portable_clock/" --reaper.GetResourcePath().."/UserPlugins/"--"c:/Ultraschall-Hackversion_3.2_alpha_Februar2019/UserPlugins/"

-- set this to the online-branch of the Ultraschall-portable-folder, including /raw/branchname
Url="file:///C:/Ultraschall/ultraschall-portable/raw/webinstaller-test"


-- set this to the branch-folder of the Ultraschall-portable-folder on your system
Target_Dir="c:\\Ultraschall-Api-Git-Repo\\ultraschall-portable_clock\\"
TargetFile="index-test.xml"

GitIgnore=ultraschall.ReadValueFromFile(Target_Dir.."/.gitignore")
Count, GitIgnore = ultraschall.SplitStringAtLineFeedToArray(GitIgnore)
for i=Count, 1, -1 do
  GitIgnore[i]=string.gsub(GitIgnore[i], "%.", "%%.")
  GitIgnore[i]=string.gsub(GitIgnore[i], "%*", ".*")
  GitIgnore[i]=string.gsub(GitIgnore[i], "%-", "%%-")
  GitIgnore[i]=GitIgnore[i].."$"
  
  if GitIgnore[i]:match("^#") or GitIgnore[i]=="$" then table.remove(GitIgnore, i) Count=Count-1 end
  if GitIgnore[i]=="" then table.remove(GitIgnore, i) Count=Count-1 end
end



Target_Dir=Target_Dir..TargetFile

found_dirs, dirs_array, found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(SourceDir.."")

for i=found_files, 1, -1 do
  if files_array[i]:match("reaper64.app") then table.remove(files_array, i) end
end

C,C1,C2,C3,C4,C5,C6,C7=ultraschall.GetApiVersion()

version, date, beta, versionnumber, tagline = ultraschall.GetApiVersion()
majorversion, subversion, bits, Os, portable = ultraschall.GetReaperAppVersion()

SWS=reaper.CF_GetSWSVersion("")
JS= reaper.JS_ReaScriptAPI_Version()


--Version=(tonumber(C)*100)+(tonumber(C2:match(" (.*)"))/10).."04"
retval, Version = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", SourceDir.."/ultraschall_api/IniFiles/ultraschall_api.ini")
--Version=Version+1
D=os.date()
Date=string.gsub(D:match("(.-) "),"%.","-").."T"..D:match(" (.*)").."Z"
Hotfix="01"

Markdown2RTF="c:\\Program Files (x86)\\Pandoc\\pandoc -f markdown -w plain -s -o c:\\temp\\tempfile.rtf c:\\temp\\tempfile"

ChangeLog=""
--reaper.CF_SetClipboard(ChangeLog)
ultraschall.WriteValueToFile("c:\\temp\\tempfile", ChangeLog)

reaper.ExecProcess(Markdown2RTF,0)
ChangeLog=ultraschall.ReadFullFile("c:\\temp\\tempfile.rtf")


XML_start=
[[<?xml version="1.0" encoding="utf-8"?>
<index version="1" name="Ultraschall-WebInstaller">
  <category name="Ultraschall-WebInstaller-category">
    <reapack name="Ultraschall WebInstaller" type="extension">
      <version name="]]..Version.."."..Hotfix..[[" author="Meo Mespotine">
]]

XML_end=[[<changelog><![CDATA[]]..ChangeLog.."]]>\n</changelog>\n"..[[
      </version>
      <metadata>
        <link rel="website">http://ultraschall.fm/</link>
        <link rel="donation" href="http://ultraschall.fm/danke">Label</link>
        <description>
        </description>"..[[
      </metadata>
    </reapack>
  </category>
  <metadata>
    <link rel="website">http://ultraschall.fm/</link>
    <link rel="donation" href="http://ultraschall.fm/danke">Label</link>
    <description>
    </description>"..[[
  </metadata>
</index>]]


SourceDir=string.gsub(SourceDir, "/", ultraschall.Separator)


-- generate ReaPack-indexfile
XML_file=""

PPP=string.match("c:/Ultraschall/ultraschall-portable/raw/master/reamote.exe", "*.exe")

for i=1, found_files do
  tempfile=files_array[i]
  tempfile2=string.gsub(tempfile, "&", "%%26")
  for a=1, Count-1 do
    if tempfile:match(GitIgnore[a])~=nil then found=true end
  --  print2(tempfile, tempfile:match(GitIgnore[a]),GitIgnore[a])
  --  print3(tempfile)
  end
  if found~=true then
     if tempfile:match("%.git")==nil then XML_file=XML_file.."\t<source file=\"Ultraschall-WebInstaller"..tempfile:sub(SourceDir:len()+1,-1).."\" type=\"extension\">"..Url..tempfile2:sub(SourceDir:len()+1,-1).."</source>\n" end
  end
  found=false
end


B=ultraschall.WriteValueToFile(Target_Dir.."", XML_start..XML_file..XML_end)


ultraschall.ShowLastErrorMessage()

--os.execute("c:\\Ultraschall-Hackversion_3.2_alpha_Februar2019\\UserPlugins\\ultraschall_api\\Scripts\\Tools\\batter.bat")
reaper.MB("Done", "", 0)
