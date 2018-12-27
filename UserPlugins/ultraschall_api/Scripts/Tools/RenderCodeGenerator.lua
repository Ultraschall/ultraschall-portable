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
