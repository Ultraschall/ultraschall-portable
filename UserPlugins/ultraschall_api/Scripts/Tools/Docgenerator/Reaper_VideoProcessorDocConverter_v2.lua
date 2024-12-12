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

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

StartTime=reaper.time_precise()
-- increment build-version-numbering
local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", ultraschall.Api_Path.."/IniFiles/ultraschall_api.ini")

-- init variables
Tempfile=ultraschall.Api_Path.."/temp/"

Infilename=ultraschall.Api_Path.."/DocsSourcefiles/Reaper_API_Video_Documentation.USDocML"
Outfile=ultraschall.Api_Path.."/Documentation/Reaper_API_Video_Documentation.html"

-- Reaper-version and tagline from extstate
versionnumbering=reaper.GetExtState("ultraschall_api", "ReaperVerNr")
tagline=reaper.GetExtState("ultraschall_api", "Tagline")

-- Let's create the Header
FunctionList=[[
<html>
  <head>
    <title>
      Video Processor Documentation
    </title>

    <link href="style.css" rel="stylesheet">
    <link href="custom.css" rel="stylesheet">
  </head>
    <body>
        <a class="anchor" id="This-is-the-TopOfTheWorld"></a>
        <div style="position: sticky; top:0; padding-left:4%; z-index:100;">
            <div style="background-color:#282828; width:95%; font-family:tahoma; font-size:16;">
                <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button_Un.png" alt="Ultraschall Internals Documentation"></a>  
                <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button.png" alt="Reaper Internals Documentation"></a>
                <a href="ReaGirl_Functions.html"><img style="position: absolute; left:23.95%; width:8.7%;" src="gfx/ReaGirl_Button_Un.png" alt="ReaGirl Documentation"></a>
                <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
                <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
                <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
                <div style="padding-top:2.5%">                    
                    <table border="0" style="color:#aaaaaa; width:100%;">
                        <tr>
                            <td style="width:27.2%; padding-top:2; ">
                                <a href="http://www.reaper.fm"><img style="width:118%;" src="gfx/Reaper_Internals.png" alt="Reaper internals logo"></a>
                            </td>
                            <td style="position: absolute; padding-top:5; width:14%;"><u>Documentation:</u></td>
                            <td style="width:12.7%;"><u> </u></td>
                            <td style="width:12.7%;"><u> </u></td>
                            <td style="width:12%;"><u> </u></td>
                            <td style="width:12%;"><u> </u></td>
                            <td style="width:12%;"><u> </u></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper-Filetype-Descriptions.html" style="color:#BBBBBB; text-decoration: none; white-space:pre;">&nbsp;&nbsp;Filetype Descriptions&nbsp;</a></td>
                            <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper_Config_Variables.html" style="color:#BBBBBB; text-decoration: none; white-space:pre;">&nbsp;&nbsp;Config Variables&nbsp;</a></td>
                            <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper_Misc_Docs.html" style="color:#BBBBBB; text-decoration: none; white-space:pre;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Misc Docs&nbsp;</a></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper_Api_Documentation.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;ReaScript-Api-Docs&nbsp;</a></td>
                            <td style="background-color:#777777; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper_API_Video_Documentation.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;Video-Api-Docs&nbsp;</a></td>
                            <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="Reaper_API_Web_Documentation.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;WebRC-Api-Docs&nbsp;</a></td>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                    </table><hr color="#444444">
                    <div style="position:absolute; right:6%; top:80%;"><a style="color:#CCCCCC;" href="#This-is-the-TopOfTheWorld">Jump to Index</a></div>
                </div>                
            </div>            
        </div>
<!---
End of Header
--->    
]]



dofile(ultraschall.Api_Path.."/Scripts/Tools/DocGenerator/DocGenerator_v2.lua")
