  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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

-- increment version number
local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", ultraschall.Api_Path.."/IniFiles/ultraschall_api.ini")
string2=tonumber(string2)
string2=string2+1
reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, ultraschall.Api_Path.."/IniFiles/ultraschall_api.ini")


ultraschall.BringReaScriptConsoleToFront()

FileA={}
FileA[#FileA+1]="ReaGirl_Doc_Concepts_Converter_v2.lua"
FileA[#FileA+1]="ReaGirl_Doc_Functions_Converter_v2.lua"
FileA[#FileA+1]="Ultraschall_Doc_Func_Converter_v2.lua"
FileA[#FileA+1]="Ultraschall_Doc_VID_Converter_v2.lua"
FileA[#FileA+1]="Reaper_ConfigVarDocConverter_v2.lua"
FileA[#FileA+1]="Reaper_WebRCDocConverter_v2.lua"
FileA[#FileA+1]="Ultraschall_ConceptsDocConverter_VID_v2.lua"
FileA[#FileA+1]="Ultraschall_Doc_DOC_Converter_v2.lua"
FileA[#FileA+1]="Ultraschall_Doc_GFX_Converter_v2.lua"
FileA[#FileA+1]="Ultraschall_ConceptsDocConverter_GFX_v2.lua"
FileA[#FileA+1]="Ultraschall_ConceptsDocConverter_DOC_v2.lua"
FileA[#FileA+1]="Ultraschall_ApiDownloads_Generator.lua"
FileA[#FileA+1]="Ultraschall_ConceptsDocConverter_v2.lua"
FileA[#FileA+1]="Reaper_VideoProcessorDocConverter_v2.lua"
FileA[#FileA+1]="Reaper_ReaScriptConverter_v2.lua"

--FileA[#FileA+1]="Reaper_FileTypeDocConverter_v2.lua"
dofile(ultraschall.Api_Path.."/Scripts/Tools/ultraschall_ModulerLoader_Generator.lua")

Starterkit=reaper.time_precise()

dofile(ultraschall.Api_Path.."/Scripts/Tools/Docgenerator/Ultraschall_ChangelogConverterDoc.lua")

ReaperVersion=reaper.GetExtState("ultraschall_api", "ReaperVerNr")
ReaperTagline=reaper.GetExtState("ultraschall_api", "Tagline")
retval, String=reaper.GetUserInputs("Reaper Tagline", 2, "Version,Tagline,extrawidth=200,separator=\n", ReaperVersion.."\n"..ReaperTagline)
if retval==true then
  A=reaper.SetExtState("ultraschall_api", "ReaperVerNr", String:match("(.-)\n"), true)
  B=reaper.SetExtState("ultraschall_api", "Tagline", String:match("\n(.*)"), true)
else
  ultraschall.CloseReaScriptConsole()
  return
end

--if tudelu==nil then return end
ReaperVersion=reaper.GetExtState("ultraschall_api", "ReaperVerNr")
ReaperTagline=reaper.GetExtState("ultraschall_api", "Tagline")

for i=1, #FileA do
  CurrentDocs=FileA[i].."\n"
  dofile(ultraschall.Api_Path.."/Scripts/Tools/Docgenerator/"..FileA[i])
end


function main()
  COUNTERRRR=COUNTERRRR+1
  if COUNTERRRR==20 then
    dofile(ultraschall.Api_Path.."/Scripts/Tools/Docgenerator/"..FileA[14])
    COUNTERRRR=0
  end
  reaper.defer(main)
end
COUNTERRRR=0
--main()


print2(reaper.format_timestr(reaper.time_precise()-Starterkit, ""))
ultraschall.CloseReaScriptConsole()

