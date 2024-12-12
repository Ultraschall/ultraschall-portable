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

Infilename={}
Infilename=ultraschall.Api_Path.."/DocsSourcefiles/US_Api-Concepts_VID.USDocML"


Outfile=ultraschall.Api_Path.."/Documentation/US_Api_Concepts_VID.html"

-- Reaper-version and tagline from extstate
versionnumbering=reaper.GetExtState("ultraschall_api", "ReaperVerNr")
tagline=reaper.GetExtState("ultraschall_api", "Tagline")



Index=3

-- Let's create the Header
FunctionList=[[
<html><head><title>
Ultraschall API Video-Concepts
</title>

<link href="style.css" rel="stylesheet">
<link href="custom.css" rel="stylesheet">

  </head>
    <body>    
        <a class="anch" id="This-is-the-TopOfTheWorld"></a>
        <div style="position: sticky; top:0; padding-left:4%; z-index:100;">
            <div style="background-color:#282828; width:95%; font-family:tahoma; font-size:16;">
                <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button.png" alt="Ultraschall Internals Documentation"></a>  
                <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button_Un.png" alt="Reaper Internals Documentation"></a>
                <a href="ReaGirl_Functions.html"><img style="position: absolute; left:23.95%; width:8.7%;" src="gfx/ReaGirl_Button_Un.png" alt="ReaGirl Documentation"></a>
                <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
                <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
                <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
                <div style="padding-top:2.5%">
                    <table border="0" style="color:#aaaaaa; width:101%;">
                        <tr>
                             <td style="width:27.2%; padding-top:2; ">
                                 <a href="http://www.ultraschall.fm"><img style="width:118%;" src="gfx/US-header.png" alt="Ultraschall-logo"></a>
                             </td>
                             <td style="position: absolute; padding-top:5; width:10%;"><u>Functions Engine</u></td>
                             <td style="padding-top:5; width:10%;"><u>GFX Engine</u></td>
                             <td style="padding-top:5; width:10%;"><u>Doc Engine</u></td>
                             <td style="padding-top:5; width:10%;"><u>Video Engine</u></td>
                             <td width="10%;">&nbsp;<u></u></td>
                             <td width="10%;">&nbsp;<u></u></td>
                             <td width="10%;">&nbsp;<u></u></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Introduction_and_Concepts.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;Introduction/Concepts&nbsp;&nbsp;</a></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_GFX.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_DOC.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                             <td style="background-color:#777777; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_VID.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Functions.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions</a></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_GFX.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_DOC.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                             <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_VID.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                    </table><hr color="#444444">
                    <div style="position:absolute; right:6%; top:80%;"><a style="color:#CCCCCC;" href="#This-is-the-TopOfTheWorld">Jump to Index</a></div>
                </div>
            </div>
        </div>
      
]]

dofile(ultraschall.Api_Path.."/Scripts/Tools/DocGenerator/DocGenerator_v2.lua")

