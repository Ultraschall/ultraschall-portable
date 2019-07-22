dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- This checks, whether any line in a string, stored in clipboard, is a valid config-var
-- after that, it will put a string into clipboard with all found strings.
-- This looks for configvars, who can be either int, double or string.
--
-- Be aware: some configvars available as 
--          ints can also be available as double
--          string can also be available as int
--     that means, duplicate config-vars between different datatypes are normal.
--
-- When running this script with Ultraschall-API installed, it will only show config-vars not already existing in the 
-- config-vars-documentation of Reaper-Internals, which is supplied together with Ultraschall-API.
--
-- Meo Mespotine 12th of July 2019


A2=ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/DocsSourcefiles/reaper-config_var.USDocML")
if A2==nil then A2="" end

orgvars={}
Acount=1

--if OLOL==nil then return end

--local ultraschall=ultraschall

while A2~=nil do
  line,offs=A2:match("<slug>(.-)</slug>()")
  if offs==nil then break end
  B=line:sub(1,1)
  if B~="" and B~=" " and B~="#" then orgvars[Acount]=line Acount=Acount+1 end
  A2=A2:sub(offs,-1)
end

local Clipboard_string = ultraschall.GetStringFromClipboard_SWS()

Clipboard_string=Clipboard_string.."\n "


ints={}
local integers=""
local doubles=""
count=1
ALABAMA=0


AAA=reaper.time_precise()
count, split_string = ultraschall.SplitStringAtLineFeedToArray(Clipboard_string)
BBB=reaper.time_precise()-AAA
table.sort(split_string)

--Integer

Int={}
Intcount=0

for i=1, count do
  local A=reaper.SNM_GetIntConfigVar(split_string[i], -103)
  local B=reaper.SNM_GetIntConfigVar(split_string[i], -101)
  if A==B then
    for a=1, Acount do
      if orgvars[a]==split_string[i]:lower() then found=true end
    end
    if found==false then 
      Intcount=Intcount+1 
      Int[Intcount]=split_string[i]:lower() 
      --reaper.ShowConsoleMsg(split_string[i].." "..tostring(C).."\n")
    end
    found=false
  end
end

table.sort(Int)

for i=Intcount, 2, -1 do
  if Int[i]==Int[i-1] then table.remove(Int, i) Intcount=Intcount-1 end
end

Intstring="Ints:\n"
for i=1, Intcount do
  Intstring=Intstring..Int[i].."\n"
end

reaper.MB(split_string[1].."OLO",reaper.time_precise()-AAA,0)

-- Double
Double={}
Doublecount=0

for i=1, count do
  local A=reaper.SNM_GetDoubleConfigVar(split_string[i], -103)
  local B=reaper.SNM_GetDoubleConfigVar(split_string[i], -101)
  if A==B then
    for a=1, Acount do
      if orgvars[a]==split_string[i]:lower() then found=true end
    end
    if found==false then 
      Doublecount=Doublecount+1 
      Double[Doublecount]=split_string[i]:lower() 
      --reaper.ShowConsoleMsg(split_string[i].." "..tostring(C).."\n")
    end
    found=false
  end
end

table.sort(Double)

for i=Doublecount, 2, -1 do
  if Double[i]==Double[i-1] then table.remove(Double, i) Doublecount=Doublecount-1 end
end

Doublestring="Doubles:\n"
for i=1, Doublecount do
  Doublestring=Doublestring..Double[i].."\n"
end


-- String
Strings={}
Stringscount=0

for i=1, count do
  local A=reaper.get_config_var_string(split_string[i])
  if A==true then
    for a=1, Acount do
      if orgvars[a]==split_string[i]:lower() then found=true end
    end
    if found==false then 
      Stringscount=Stringscount+1 
      Strings[Stringscount]=split_string[i]:lower() 
    end
    found=false
  end
end

table.sort(Strings)

for i=Stringscount, 2, -1 do
  if Strings[i]==Strings[i-1] then table.remove(Strings, i) Doublecount=Stringscount-1 end
end

Stringsstring="Strings:\n"
for i=1, Stringscount do
  Stringsstring=Stringsstring..Strings[i].."\n"
end

print3(Intstring.."\n"..Doublestring.."\n"..Stringsstring)

reaper.MB(split_string[1].."OLO",reaper.time_precise()-AAA,0)

