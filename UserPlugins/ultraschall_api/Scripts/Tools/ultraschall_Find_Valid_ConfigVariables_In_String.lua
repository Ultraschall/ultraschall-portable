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

LLLL="TUTUTU"
-- Meo Mespotine (mespotine.de) 15.5.2018 for the ultraschall.fm-project

-- the following code can be used to check, which strings within Reaper are
-- valid config-variables that can be used by the SWS-functions 
--      SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar() and SNM_SetDoubleConfigVar()
-- where you pass the variable-name as parameter "varname".
-- This script expects a string with all entries to check for, each separated by a newline, with no trailing or
-- preceding spaces, as otherwise the variable might be fail-checked.

-- To get a list to check, use Microsoft Process Explorer, start Reaper, rightlick on it and click on Properties.
-- The tab "Strings" contains all strings within Reaper. Click "Memory" and "Save" to save them into a textfile.
-- Open the text-file, copy all(!) entries into clipboard and run this commented code.
-- After execution, it will put all found strings, that are valid config-variables into the clipboard.
--
-- keep in mind: some config-variables are duplicate, often in different camel-cases, some may not be found 
-- by this code (rendercfg seems to be problematic candidate)
-- but at least, it's a start.

-- Oh, and if you want to parse your own reaper.ini(whose entries seem to be a valuable source for variable-names),
-- decomment the first line in the for statement!

-- the variable int_line contains all valid variables, each separated by a \n
-- the variable rest_line contains all strings, that weren't valid variables(where the check failed),
--     each separated by a \n

ultraschall={}
function ultraschall.GetStringFromClipboard_SWS()
  -- gets a big string from clipboard, using the 
  -- CF_GetClipboardBig-function from SWS
  -- and deals with all aspects necessary, that
  -- surround using it.
  return bug
end


A=ultraschall.GetStringFromClipboard_SWS()
  
A=A.."\n"
int_line=" " -- found valid variables
maybe_line=""
rest_line="" -- strings, where the check failed
LL=0

for line in A:gmatch("(.-)%c") do
  --line=tostring(line:match("(.-)=")) --uncomment, if you want to parse a reaper.ini
--  if line~="" and line:match("[^_%l]")==nil then 
--    maybe_line=maybe_line..line.."\n" 
--    reaper.BR_Win32_WritePrivateProfileString("varname",line:lower(),line:lower(),"c:\\varnames_possible.ini")
--    LL=LL+1
--  end
  L=reaper.SNM_SetDoubleConfigVar(line, 100)
  L2=reaper.SNM_SetDoubleConfigVar(line, 200)
  if (L==true or L2==true) then if line~="nil" then
   --reaper.BR_Win32_WritePrivateProfileString("varname",line:lower(),line:lower(),"c:\\varnames_possible.ini") 
   int_line=int_line..line.."\n" LL=LL+1 end else rest_line=rest_line..line.."\n" end
end

--reaper.BR_Win32_WritePrivateProfileString("varname","number_of_variables",LL,"c:\\varnames.ini")

if int_line=="" then reaper.MB("nothing found","",0) 
else reaper.CF_SetClipboard(int_line) end

