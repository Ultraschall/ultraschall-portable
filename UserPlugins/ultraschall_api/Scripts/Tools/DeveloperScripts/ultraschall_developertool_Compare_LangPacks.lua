  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

-- Meo-Ada Mespotine 28th of June 2020
-- allows you to select two different ReaperLangPack-files and will look for missing and changed entries
--
-- will put the found entries into the clipboard after that

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

reaper.ClearConsole()
path=reaper.GetExtState("ultraschall", "LangPack_Compare_Path")

retval, filename_1 = reaper.GetUserFileNameForRead(path, "Choose Langpack one", "")
if retval==false then return end
retval, filename_2 = reaper.GetUserFileNameForRead(ultraschall.GetPath(filename_1), "Choose Langpack one", "")
if retval==false then return end

reaper.SetExtState("ultraschall", "LangPack_Compare_Path", ultraschall.GetPath(filename_2), false)

File1=ultraschall.ReadFullFile(filename_1).."\n[".."\n"
File1=File1:match("\n%[.*")
File2=ultraschall.ReadFullFile(filename_2).."\n[".."\n"
File2=File2:match("\n%[.*")


function lastlines()
  local f=found:match(".*\n(.-\n.-\n.-\n.-\n.-\n.-\n.*)")
  if f==nil then return found else return f end
end

sect=""
key=""
cur=0

O=1

A,B=ultraschall.GetPath(filename_1)
found=B.."\n"

line=0

-- filename 1
for k in string.gmatch(File1, "(.-)\n") do
  line=line+1
  if k:match("^%[.*%]") then 
    sect=k:match("%[(.-)%]")-- print(sect) 
    print_update("Checking \""..B.."\"\n"..cur.." / "..File1:len().." - "..tostring(50/File1:len()*cur):match("(.-)%.").."% - Section:" ..sect.."\n\nMissing in: "..B.."\n"..lastlines())
    key=File2:match("\n%["..sect.."].-\n.-\n%[")
  elseif k:match("=")~=nil and key~=nil and key:match(ultraschall.EscapeMagicCharacters_String(k))==nil then
    found=found.."  "..(line+10)..": ["..sect.."]"..": "..k.."\n"
  end
  cur=cur+k:len()
  O=O+1
end

sect=""
key=""
cur=0

O=1

A,B=ultraschall.GetPath(filename_2)
found=found.."\n"..B.."\n"

line=0

-- filename 2
for k in string.gmatch(File2, "(.-)\n") do
  line=line+1
  if k:match("^%[.*%]") then 
    sect=k:match("%[(.-)%]")-- print(sect) 
    print_update("Checking \""..B.."\"\n"..cur.." / "..File2:len().." - "..tostring((50/File2:len()*cur)+50):match("(.-)%.").."% - Section:" ..sect.."\n\nMissing in "..B.."\n"..lastlines())
    key=File1:match("\n%["..sect.."].-\n.-\n%[")
  elseif k:match("=")~=nil and key~=nil and key:match(ultraschall.EscapeMagicCharacters_String(k))==nil then
    found=found.."  "..(line+10)..": ["..sect.."]"..": "..k.."\n"
  end
  cur=cur+k:len()
  O=O+1
end

print_update("Checking \""..A.."\"\n"..File2:len().." / "..File2:len().." - ".."100% - Section:" ..sect.."\n\nMissing in "..B.."\n"..lastlines())

print3(found)
print("\nResults put into Clipboard.")

