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
Pandoc="c:\\Program Files\\pandoc\\pandoc -f markdown_strict -t html \""..Tempfile..ChangeLogFile.."\" -o \""..ultraschall.Api_Path.."/Documentation/ChangeLog.html\""

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

<link href="style.css" rel="stylesheet">

  </head>
    <body>    
        <a class="anchor" id="This-is-the-TopOfTheWorld"></a>
        <div style="position: sticky; top:0; padding-left:4%; z-index:100;">
            <div style="background-color:#282828; width:95%; font-family:tahoma; font-size:16;">
                <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button_un.png" alt="Ultraschall Internals Documentation"></a>  
                <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button_Un.png" alt="Reaper Internals Documentation"></a>
                <img alt="" style="width:6.9%; position: absolute; left:23.9%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:30.8%;" src="gfx/linedance.png">
                <img alt="" style="width:6.9%; position: absolute; left:36.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:42.8%;" src="gfx/linedance.png">
                <img alt="" style="width:6.9%; position: absolute; left:48.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:54.8%;" src="gfx/linedance.png">
                <img alt="" style="width:6.9%; position: absolute; left:60.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:66.8%;" src="gfx/linedance.png">
                <img alt="" style="width:6.9%; position: absolute; left:68.8%;" src="gfx/linedance.png">
                <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
                <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
                <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
                <div style="padding-top:2.5%">
                    <table border="0" style="color:#aaaaaa; width:101%;">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                    </table><hr color="#444444">
                    <div style="position:absolute; right:6%; top:60%;"><a style="color:#CCCCCC;" href="#This-is-the-TopOfTheWorld">Jump to Top</a></div>
                </div>
            </div>
        </div>
      
          <div class="ch"><p></p>
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

