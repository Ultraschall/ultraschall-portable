--Ultraschall Developer-Tool
-- reaper-kb.ini sorting-tool 1.0 - 14.03.2018
--
-- Sorts the entries in the file reaper-kb.ini in the resources-folder of the current installation.
-- It will create a backup-copy of the file first as reaper-kb.inibak.
--
-- The resulting files will be written as written by Reaper, with correct "line-termination" using CRLF.
--
-- If for some reason this script omits or forgets lines, it will terminate with a message, without modifying
-- the reaper-kb.ini at all. That means, a verification is in place to protect us from having missing entries
-- after sorting.


--helper functions

ultraschall={}

function ultraschall.CSV2IndividualLinesAsArray(csv_line,separator)
-- converts a csv to an array with all individual values
-- the number of entries in the array(beginning with 1)
  if type(csv_line)~="string" then ultraschall.AddErrorMessage("CSV2IndividualLinesAsArray","csv_line: only string is allowed") return nil end
  if separator==nil then separator="," end
  if type(separator)~="string" or string.len(separator)>1 then ultraschall.AddErrorMessage("CSV2IndividualLinesAsArray","separator: only a character is allowed") return nil end

  local result=tostring(csv_line)
  local temp=""
  local count=1
  local comma_pos=0
  local line_array={}
  local pos_array={}

  for i=1, result:len() do
    if result:sub(i,i)~=separator then 
      if result:sub(i,i)~=nil then temp=temp..result:sub(i,i) 
      else line_array[count]=""
      end
    else line_array[count]=temp count=count+1 comma_pos=i temp=""
    end
  end
  line_array[count]=result:sub(comma_pos+1,-1)

  return line_array, count
end

function ultraschall.WriteValueToFile(filename_with_path, value, binarymode, append)
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path: invalid filename") return -1 end
  if type(value)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","value: must be string; convert with tostring(value), if necessary.") return -1 end
  local binary, appendix, file
  if binarymode==nil or binarymode==true then binary="b" else binary="" end
  if append==nil or append==false then appendix="w" else appendix="a" end
  file=io.open(filename_with_path,appendix..binary)
  if file==nil then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path: can't create file") return -1 end
  file:write(value)
  file:close()
  return 1
end

function ultraschall.ReadFullFile(filename_with_path, binary)
  if filename_with_path == nil then return nil end
  if value==nil then value="" end
  if reaper.file_exists(filename_with_path)==false then return nil end
  if binary==true then binary="b" else binary="" end
  local linenumber=0
  local file=io.open(filename_with_path,"r"..binary)
  local filecontent=file:read("a")
  if binary~=true then
    for w in string.gmatch(filecontent, "\n") do
      linenumber=linenumber+1
    end
  else
    linenumber=-1
  end
  file:close()
  return filecontent, filecontent:len(), linenumber
end


-- Let's have fun sorting, Kids!

-- datastructures

ACT={} -- table for Actione
SCR={} -- table for Scripts
KEY={} -- table for Keyboard-bindings

act=1 -- counter for Actions
scr=1 -- counter for Scripts
key=1 -- counter for Keyboard-Bindings

-- Read kb.ini
A,A2,A3=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-kb.ini", false)
temp=string.gsub(A,"\n","\r\n")
A=A.."\n"

--create backup-copy of the original kb.ini-file as reaper-kb.inibak
ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-kb.inibak",temp)


-- create individualised copy for later use
temp=string.gsub(A,"\r","")
B,B2=ultraschall.CSV2IndividualLinesAsArray(temp,"\n")


-- Separate the lines into categories ACT,SCR and KEY
for i=1, A3 do
  temp=A:match("(.-)%c")
  if temp:sub(1,3)=="ACT" then ACT[act]=temp act=act+1 end
  if temp:sub(1,3)=="SCR" then SCR[scr]=temp scr=scr+1 end
  if temp:sub(1,3)=="KEY" then KEY[key]=temp key=key+1 end
  A=A:match("%c(.*)")
end

-- Sort like Cinderella
table.sort(ACT)
table.sort(SCR)
table.sort(KEY)


-- Create final file. Contains CRLF (Carriage Return+LineFeed) for every line, as Reaper would create it
filecontent=""

for i=1, act-1 do -- ACT
  filecontent=filecontent..ACT[i].."\r\n"
end

for i=1, scr-1 do -- SCR
  filecontent=filecontent..SCR[i].."\r\n"
end

for i=1, key-1 do -- KEY
  filecontent=filecontent..KEY[i].."\r\n"
end

-- create individualised copy of the new file for comparisement
temp=string.gsub(filecontent,"\r","")
C,C2=ultraschall.CSV2IndividualLinesAsArray(temp,"\n")

-- Now let's check, if everything went right, and no line went forgotten, fellows

--reaper.MB("","",0)

bingo=false
reaper.ClearConsole()
for i=1, B2+1 do
  reaper.ShowConsoleMsg(tostring(B[i]).." ")
    for a=1, C2+1 do
      if B[i]==C[a] then bingo=true reaper.ShowConsoleMsg(" -> Bingo\n")
      else
      end
    end
  
  if bingo==false then reaper.MB("OOOHHH!! Missing line! That means, this script is buggy!\n\nProblematic line:"..i.." "..B[i].."\n\nI quit now and leave the kb.ini untouched...","Ooops...",0) return end
  bingo=false
end


-- save the new kb.ini-file
 ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-kb.ini",filecontent)
