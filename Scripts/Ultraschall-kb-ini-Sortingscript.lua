--Ultraschall Developer-Tool
-- reaper-kb.ini sorting-tool 2.0 - 29.08.2019 - Meo Mespotine
--
-- Sorts the entries in the file reaper-kb.ini in the resources-folder of the current installation.
-- It will create a backup-copy of the file first as reaper-kb.ini-backup.
--
-- The resulting files will be written as written by Reaper.


dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- read kb.ini
A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-kb.ini")

-- remove all carriage returns
A=string.gsub(A, "\r", "")

-- prepare variables
Actions={}
Actions_count=0
Keys={}
Keys_count=0

-- split kb.ini-file into ACT+SCR and KEY-entries
for k in string.gmatch(A, "(.-)\n") do
  if k:sub(1,3)=="ACT" or k:sub(1,3)=="SCR" then Actions_count=Actions_count+1 Actions[Actions_count]=k 
  elseif k:sub(1,3)=="KEY" then Keys_count=Keys_count+1 Keys[Keys_count]=k 
  else
    print("Falscher Eintrag: "..k)
  end
end

-- sort the entries, first ACT+SCR, after that the KEY-entries
table.sort(Actions)
table.sort(Keys)

-- let's build together the now sorted kb.ini
NewA=""

for i=1, Actions_count do
  NewA=NewA..Actions[i].."\n"
end

for i=1, Keys_count do
  NewA=NewA..Keys[i].."\n"
end

-- write it to the kb.ini-file and write the old one as backup-file, just in case
ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-kb.ini", NewA)
ultraschall.WriteValueToFile(reaper.GetResourcePath().."/reaper-kb.ini-backup", A) 