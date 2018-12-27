filename_ini="c:/Users/meo/Desktop/Reaper-ActionList_v7_80.ini"
count=0
A={}
for i=40000, 42054 do--65535 do
  K,L=reaper.BR_Win32_GetPrivateProfileString("Main", tostring(i), "", filename_ini)
  if L=="" then count=count+1 A[count]=i end
end
