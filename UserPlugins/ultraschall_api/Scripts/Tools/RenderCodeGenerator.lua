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

--reaper.SetExtState("us","devcount","-1",true) L=""
if L==nil then 
  iterator=1
  kbps=tonumber(reaper.GetExtState("us","devcount"))
  reaper.CF_SetClipboard(kbps)
  reaper.Main_SaveProject(0,false)
  
  renderproject="c:\\rendercode-project.rpp"
  renderstring=""
  rendercodeini="c:\\audiocd-codes.ini"
  
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
  
  
  ProjectFile=ultraschall.ReadFullFile(renderproject, false)
  
  renderstring=ProjectFile:match("<RENDER_CFG\n%s*%t*(.-)\n")
  reaper.ShowConsoleMsg(kbps..": "..renderstring.."  "..renderstring:sub(6,10).." - "..renderstring:sub(11,16).."\n")
  
  reaper.BR_Win32_WritePrivateProfileString("AUDIOCD", "DISCLEADIN_"..kbps-2+iterator, renderstring:sub(6,10), rendercodeini)
  reaper.BR_Win32_WritePrivateProfileString("AUDIOCD", "TRACKLEADIN_"..kbps-2+iterator, renderstring:sub(11,16), rendercodeini)
  --reaper.BR_Win32_WritePrivateProfileString("VIDEO", "HEIGHT_"..kbps-iterator, renderstring:sub(38,40), rendercodeini)
  --reaper.BR_Win32_WritePrivateProfileString("VIDEO", "WEBM_VID_KBPS_"..kbps-iterator, renderstring:sub(17,19), rendercodeini)
  --reaper.BR_Win32_WritePrivateProfileString("VIDEO", "WEBM_AUDKBPS_"..kbps-iterator, renderstring:sub(27,30), rendercodeini)
  
  --reaper.BR_Win32_WritePrivateProfileString("VIDEO", "MJPEG_"..kbps-iterator, renderstring:sub(54,55), "c:\\rendercodes_2018.ini")
  
  reaper.SetExtState("us","devcount",kbps+iterator,true)
  reaper.Main_OnCommand(40015,0)
  --ultraschall.ShowLastErrorMessage()
end
