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
--reaper.ShowConsoleMsg("huigl")
--ultraschall.CloseReaConsole()

--if l==nil then return end

timer=reaper.time_precise()
Tempfile=ultraschall.Api_Path.."temp/"
ChangeLogFile="Changelog-Api.txt"
Pandoc="c:\\Program Files (x86)\\pandoc\\pandoc -f markdown_strict -t html \""..Tempfile..ChangeLogFile.."\" -o \""..ultraschall.Api_Path.."/Documentation/ChangeLog.html\""

  local retval, string4 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Docs-Introduction", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string3 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Docs-FuncEngine", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  string2=tonumber(string2)
  string2=string2+1
  string3=tonumber(string3)
  string3=string3+1
  string4=tonumber(string4)
  string4=string4+1
  
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Docs-Introduction", string4, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")    
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Docs-FuncEngine", string3, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")    
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")

T=[[
<html><head><title>
Ultraschall API Changelog
</title>

</head><body>
    <div style=" position: absolute; padding-left:4%; ">
        <div style="background-color:#282828;width:95%; font-family:tahoma; font-size:16;">


           <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button_Un.png" alt="Ultraschall Internals Documentation"></a>
           <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button_Un.png" alt="Reaper Internals Documentation"></a>
         <img alt="" style="width:6.9%; position: absolute; left:23.9%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:30.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:36.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:42.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:48.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:54.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:60.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:66.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:68.8%;" src="gfx/linedance.png">
           <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
           <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog.png" alt="Changelog of documentation"></a>
           <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
           <div style="padding-top:2.5%">
           <table border="0" style="color:#aaaaaa; width:31%;">
                <tr>
                    <td style="width:30%;">
                        <a href="http://www.ultraschall.fm"><img style="width:118%;" src="gfx/US-header.png" alt="Ultraschall-logo"></a>
                    </td>
                    <td width="4%;">  </td>
                </tr>
                <tr>
                    <td> </td>
                    <td> </td>
                </tr>
                <tr>
                    <td> </td>
                    <td> </td>
                </tr>
                <tr><td></td><tr>
                </table>
           </div>
        </div>
    </div>
    <div style="position:absolute; top:17%; padding-left:5%; width:90%;">
]]

reaper.ShowConsoleMsg("Creating ChangeLog\n")

A,B,C=ultraschall.ReadFileAsLines_Array(ultraschall.Api_Path..ChangeLogFile,1,-1)

todo=nil
offset=0
string=""

for i=1, C do
    if i>C then break end
    if A[i-offset]:match("<TODO>")~=nil then todo=true end
    if A[i-offset]:match("</TODO>")~=nil then todo=false end
    
    if todo==true then 
          table.remove(A,i-offset) 
          offset=offset+1 
          C=C-1 
    elseif todo==false then
          table.remove(A,i-offset) 
          offset=offset+1 
          C=C-1
          todo=nil
    end
end

for i=1, C do
  string=string..A[i].."\n"
end
  

--os.remove(ultraschall.Api_Path.."/Documentation/ChangeLog.html")
D=ultraschall.WriteValueToFile(Tempfile..ChangeLogFile, string)
LLL,L=reaper.ExecProcess(Pandoc,0)

L=ultraschall.ReadFullFile(ultraschall.Api_Path.."/Documentation/ChangeLog.html")
--L="<html><head><title>Ultraschall API - Changelog</title></head><body><div style=\"padding-left:4%;\">"..L.."</div></body></html>"
L=T..L.."</div></body></html>"

ultraschall.WriteValueToFile(ultraschall.Api_Path.."/Documentation/ChangeLog.html", L)

reaper.ShowConsoleMsg("Creating Functions Reference\n")
--ALABAMA=ultraschall.CreateUSApiDocs_HTML(ultraschall.Api_Path.."/Documentation/US_Api_Documentation.html", ultraschall.Api_Path.."/ultraschall_functions_engine.lua")
progresscounter(false)

reaper.ShowConsoleMsg("Creating Reaper-Functions Doc\n")

os.remove(Tempfile..ChangeLogFile)

--ultraschall.ShowLastErrorMessage()

--]]
reaper.SetExtState("ultraschall", "doc", "", false)
if reaper.MB("Create Ultraschall-Docs ?", "Reaper-Docs", 4)==6 then pp=1 end
if reaper.MB("Create Reaper-Docs as well?", "Reaper-Docs", 4)==6 then p=1 end
if p~=1 and pp~=1 then ultraschall.CloseReaScriptConsole() return end
 -- introduction-concepts
A=0

Docfiles={}
Docfiles[0]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ApiDownloads_Generator.lua"
Docfiles[1]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_Func_Converter.lua"
Docfiles[2]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter.lua"
Docfiles[3]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter_AUD.lua"
Docfiles[4]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter_DOC.lua"
Docfiles[5]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter_GFX.lua"
Docfiles[6]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter_GUI.lua"
Docfiles[7]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_ConceptsDocConverter_VID.lua"
Docfiles[8]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_AUD_Converter.lua"
Docfiles[9]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_DOC_Converter.lua"
Docfiles[10]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_GFX_Converter.lua"
Docfiles[11]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_GUI_Converter.lua"
Docfiles[12]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Ultraschall_Doc_VID_Converter.lua"
Docfiles[13]="tudelu"
if pp~=1 then Len=#Docfiles Docfiles={} else Len=0 end

if p==1 then
  Docfiles[13-Len]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Reaper_StateChunkDocConverter.lua"
  Docfiles[14-Len]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Reaper_ConfigVarDocConverter.lua"
  Docfiles[15-Len]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Reaper_VideoProcessorDocConverter.lua"
  Docfiles[16-Len]=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Scripts/Tools/Docgenerator/Reaper_ReaScriptConverter.lua"
  Docfiles[17-Len]="tudelu"
end

for i=0, 16-Len do
--    if reaper.file_exists(Docfiles[i])==false then reaper.MB(Docfiles[i],"missing script",0) end
end

Timer=reaper.time_precise()
reaper.SetExtState("ultraschall", "doc", Timer, false)

i=0
commandid=reaper.AddRemoveReaScript(true, 0, Docfiles[i], true)
reaper.Main_OnCommand(commandid,0)
OL=0
--OL3=reaper.file_exists(Docfiles[i])

function main()  
  -- ultraschall_docs

    if reaper.GetExtState("ultraschall", "doc")~=tostring(Timer) then 
      if Docfiles[i]==nil then endofitall=true else
      reaper.AddRemoveReaScript(false, 0, Docfiles[i], true)
      end
      i=i+1
      Timer=reaper.GetExtState("ultraschall", "doc")
      if Docfiles[i]~=nil then
        reaper.SetExtState("ultraschall", "doc", Timer, false)
        commandid=reaper.AddRemoveReaScript(true, 0, Docfiles[i], true)
        reaper.Main_OnCommand(commandid,0)
      end
    end

      
--[[
  if reaper.GetExtState("ultraschall", "doc") == "reaper-docs" then
    Time2=reaper.time_precise()    
    Time3=reaper.format_timestr(Time2-timer, "") 
    reaper.MB(Time3, "", 0) 
    os.remove(ultraschall.Api_Path.."/temp/temporary.md")
    os.remove(ultraschall.Api_Path.."/temp/temporary.html")
    ultraschall.CloseReaConsole()
  else
    M=reaper.time_precise()
    N=reaper.GetExtState("ultraschall", "doc")
    reaper.defer(main)
  end
  -]]
  OL=OL+1
  OL2=reaper.GetExtState("ultraschall","doc")
  OL3=Docfiles[i]

  if Docfiles[i]~="tudelu" then reaper.defer(main) 
  else
    Time2=reaper.time_precise()    
    Time3=reaper.format_timestr(Time2-timer, "") 
    reaper.MB(Time3, "", 0) 
    os.remove(ultraschall.Api_Path.."/temp/temporary.md")
    os.remove(ultraschall.Api_Path.."/temp/temporary.html")
    ultraschall.CloseReaScriptConsole()
  end
end

main()

--    ultraschall.CloseReaConsole()
