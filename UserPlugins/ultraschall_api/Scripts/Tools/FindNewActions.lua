ultraschall={}
function ultraschall.ReadFullFile(filename_with_path, binary)
  -- Returns the whole file filename_with_path or nil in case of error
  
  -- check parameters
  if filename_with_path == nil then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "must be a string", -1) return nil end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "file does not exist", -2) return nil end
  
  -- prepare variables
  if binary==true then binary="b" else binary="" end
  local linenumber=0
  
  -- read file
  local file=io.open(filename_with_path,"r"..binary)
  local filecontent=file:read("a")
  
  -- count lines in file, when non binary
  if binary~=true then
    for w in string.gmatch(filecontent, "\n") do
      linenumber=linenumber+1
    end
  else
    linenumber=-1
  end
  file:close()
  -- return read file, length and linenumbers
  return filecontent, filecontent:len(), linenumber
end

IniFile=reaper.GetExePath().."/Reaper-ActionList_v5_80.ini" -- the path to the ini-file
ActionsList=reaper.GetExePath().."/ActionList.txt"          -- the path to the actionlist

A=ultraschall.ReadFullFile(ActionsList)
A=A.."\n"
SectTemp=""
while A~=nil do
  Line, Offs=A:match("(.-)\n()")
--  reaper.MB(Line, "",0)
  Sect=Line:match("(.-)%s")
  if Sect==nil then break end
  if SectTemp~=Sect then reaper.ShowConsoleMsg(Sect.."\n") SectTemp=Sect end
  Action=Line:match("%s(.-)%s")
  Text=Line:match("%s.-%s(.*)")
  
  -- The following line crashes Lua for this script, until Reaper is restarted:
  if tonumber(Action)~=nil then
    retval, String = reaper.BR_Win32_GetPrivateProfileString(Sect, tonumber(Action), "UltraschallNups", IniFile)
  end

  if String=="UltraschallNups" then 
    reaper.ShowConsoleMsg(Sect.." "..Action.." "..Text.."\n") 
    reaper.BR_Win32_WritePrivateProfileString(Sect, tonumber(Action), Text, IniFile)
  end

  
  if Offs==nil then break end
  A=A:sub(Offs,-1)
end
reaper.MB("Done","",0)



