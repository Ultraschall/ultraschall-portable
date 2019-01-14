dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
timer=reaper.time_precise()
Tempfile=ultraschall.Api_Path.."temp/"
ChangeLogFile="Changelog-Api.txt"
Pandoc="c:\\Program Files (x86)\\pandoc\\pandoc -f markdown -t html \""..Tempfile..ChangeLogFile.."\" -o \""..ultraschall.Api_Path.."/Documentation/ChangeLog.html\""

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
if reaper.MB("Create Reaper-Docs as well?", "Reaper-Docs", 4)==6 then p=1 end
 -- introduction-concepts
A=0
function main()
  if A==0 then ultraschall.RunCommand("_RSdd25c8bda91067981223b0efd6a4c3c07ac26a92") A=1 end
  if reaper.GetExtState("ultraschall", "doc") == "intro-concepts-engine" and A==1 then  ultraschall.RunCommand("_RSafb7013a8d8bbc8ef2b5f044da8d0fa327ac4a10") A=2 end -- functions-engine  
  if reaper.GetExtState("ultraschall", "doc") == "function-engine" and A==2 then ultraschall.RunCommand("_RS9b36c573d2290919d06f83fef31989e121f46685") A=3 end
  if reaper.GetExtState("ultraschall", "doc") == "reaper_config_var" and A==3 then if p==1 then ultraschall.RunCommand("_RS09fa5f0d2a033e344d533043b5eeb22b7be4743c") else reaper.SetExtState("ultraschall", "doc", "reaper-docs", false) end A=4 end
                                                                                                        
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
end

main()
