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

versionnumber, version, date, beta, tagline = ultraschall.GetApiVersion()
majorversion, subversion, bits, Os, portable = ultraschall.GetReaperAppVersion()

SWS=reaper.CF_GetSWSVersion("")
JS= reaper.JS_ReaScriptAPI_Version()

--A,B,C=reaper.GetAppVersion()

beta=beta:lower()
beta=string.gsub(beta," ","")

String=[[
<html><head><title>
Ultraschall API Impressum
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
           <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads.png" alt="Downloads"></a>
           <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
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
    <h3>Download Ultraschall Package</h3>
    <a href="https://github.com/Ultraschall/ultraschall-lua-api-for-reaper/raw/master/ultraschall_api4.2_]]..beta..[[.zip">ultraschall_api4.2_]]..beta..[[.zip</a> - the downloadpackage of the ultraschall-api<p>
    <a href="https://github.com/Ultraschall/ultraschall-lua-api-for-reaper/raw/master/ultraschall_api_index.xml">ReaPack-installable</a>-index-file. See <a href="https://reapack.com/">ReaPack-Website</a> for more details on the ReaPack-package-manager.
    <h3>Download Reaper-Internals and Ultraschall-API-docs</h3>
    <a href="https://github.com/Ultraschall/ultraschall-lua-api-for-reaper/raw/master/Reaper-Internals-Ultraschall-Api-Docs.zip">Reaper-Internals-Ultraschall-Api-Docs.zip</a> - Docs: Reaper-Internals ]]..majorversion.."."..subversion..[[, SWS ]]..SWS..[[, JS-extension ]]..JS..[[, ReaPack and Ultraschall-Api 4.00-]]..beta..[[<p>
    <a href="https://github.com/Ultraschall/ultraschall-lua-api-for-reaper/raw/master/Reaper-Developer-Tools_by_Mespotine.zip">Reaper-Developer-Tools_by_Mespotine.zip</a> - My Developer-Tools for Reaper<p>
    
    </div>
</html>
]]

ultraschall.WriteValueToFile(ultraschall.Api_Path.."Documentation/Downloads.html", String)

reaper.SetExtState("ultraschall", "doc", reaper.time_precise(), false)