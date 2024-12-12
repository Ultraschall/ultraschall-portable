  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2023 Ultraschall (http://ultraschall.fm)
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

-- written by Meo-Ada Mespotine mespotine.de 5th of May 2023
-- for the ultraschall.fm-project

-- This script shows altered integer and double-float-settings for all config-variables available in Reaper, that can be used by
-- the SWS-functions SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar() and SNM_SetDoubleConfigVar() and get_config_var_string
-- where you pass the variable-name as parameter "varname".
-- This script also shows bitwise-representation of the variable's-value, so you can work easily with bitfields.

-- Change settings in the preferences/project-settings/render-dialog-window to see, which variable 
-- contains which value for which setting. There are also some other Reaper-settings, that can be accessed
-- that way. Just experiment and see, what you can change. The names of the variables are a hint to, what can be
-- accessed.

-- Feel free to document the variable-settings(some seem to be identically named, as settings in reaper.ini) ;)
-- Keep in mind, some of the variables are bitmask-variables and contain the values for several 
-- checkboxes(e.g. in the preferences-dialog).

--TODO: uncomment gfx.init("Show Config Vars",900,187) and finish other features

ultraschall_override=true

A=reaper.GetAppVersion()
B=tonumber(A:match("(.-)/"))
if B==nil then
  B=tonumber(A:match("(.-)+"))
end
if B==nil then
  B=tonumber(A:match("(.-%.%d*)"))
end


if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

A,B,C,D=ultraschall.ReadFullFile(ultraschall.Api_Path.."/DocsSourcefiles/Reaper_Config_Variables.USDocML")

ConfigVars={}
ConfigVars_Counter=0
MaxEntries=100000
ConsoleToggle=true
ShowString=""
OldShowString=""
Filtermode=true


ConfigVarsInt={}
ConfigVarsDouble={}

reaper.ClearConsole() 
reaper.ShowConsoleMsg("Reaper-Config-Variable-Inspector by Meo Mespotine(mespotine.de) 28th of March 2022 for Ultraschall.fm\n\n  This shows all altered Config-Variables and their bitwise-representation as well as the value in the reaper.ini,\n  that can be accessed at runtime through LUA using the SWS-functions: \n     SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar(), SNM_SetDoubleConfigVar() \n     and Reaper's get_config_var_string(). \n\n  These variables cover the preferences window, project-settings, render-dialog, settings in the context-menu of \n  transportarea and numerous other things.\n\n  Just change some settings in the preferences and click apply to see, which variable is changed to which value, \n  shown in this Reascript-Console.\n\n  Keep in mind: certain variables use bit-wise-values, which means, that one variable may contain the settings for \n  numerous checkboxes; stored using a bitmask, which will be shown in here as well.\n\n") 
reaper.ShowConsoleMsg("  Mismatch between int/double-values the currently set reaper.ini-value(as well as only int/double changing) is\n  a hint that the value is not stored into reaper.ini(e.g. only stored, when you set the current project's settings \n  as default settings).\n\n")
reaper.ShowConsoleMsg("  Keep in mind, that some values can't be set, unless they were set in the dialogs first, lika afxcfg. So if they \n  don't appear after setting them through script, this isn't necessarily a bug!\n\n")
reaper.ShowConsoleMsg("  Diffs to old double-values might be wrong, when the current or former value was NaN.")
--gfx.init("Show Config Vars",900,187)
gfx.setfont(1, "Arial", 15, 0)
gfx.setfont(2, "Arial", 15, 16981)
gfx.setimgdim(2,2048,2048)
gfx.dest=2
start=0
stop=MaxEntries

Pudel=""

-- get currently documented Config-Vars and put them into datastructures to
-- get the difs from them
-- also get their current int, double and string values
for w in string.gmatch(A, "<slug>(.-)</slug>") do
  if (reaper.SNM_GetIntConfigVar(w, -9987)~=-9987 or
     reaper.SNM_GetIntConfigVar(w, -9988)~=-9988) ==true
     or 
     (reaper.SNM_GetDoubleConfigVar(w, -9987)~=-9987 or
     reaper.SNM_GetDoubleConfigVar(w, -9988)~=-9988)==true
     or
     reaper.get_config_var_string(w)==true
     then
    ConfigVars[ConfigVars_Counter]={}
    ConfigVars[ConfigVars_Counter]["configvar"]=w
    ConfigVars[ConfigVars_Counter]["int"]=reaper.SNM_GetIntConfigVar(w, -9987)
    ConfigVars[ConfigVars_Counter]["double"]=tostring(reaper.SNM_GetDoubleConfigVar(w, -9987))
    ConfigVarsInt[ConfigVars_Counter]=reaper.SNM_GetIntConfigVar(w, -9987)
    ConfigVarsDouble[ConfigVars_Counter]=tostring(reaper.SNM_GetDoubleConfigVar(w, -9987))
    retval, ConfigVars[ConfigVars_Counter]["string"]=reaper.get_config_var_string(w)
    ConfigVars_Counter=ConfigVars_Counter+1
  end
end



function Update_ConfigVars()
  ShowString=""
  for i=1, ConfigVars_Counter-1 do
    AAA=i
    local A=reaper.SNM_GetIntConfigVar(ConfigVars[i]["configvar"], -9987)
    local B=tostring(reaper.SNM_GetDoubleConfigVar(ConfigVars[i]["configvar"], -9987))
    local retval, C=reaper.get_config_var_string(ConfigVars[i]["configvar"])
    if ConfigVarsInt[i]==nil then ConfigVarsInt[i]=0 end
    if ConfigVarsDouble[i]==nil then ConfigVarsDouble[i]=0 end
    if A~=ConfigVars[i]["int"] or
       B~=ConfigVars[i]["double"] or
       C~=ConfigVars[i]["string"] then
      update=true
       if ConsoleToggle==true then
         A1=A-ConfigVarsInt[i]
         if tonumber(B)~=nil and tonumber(ConfigVarsDouble[i])~=nil then
           B1=B-ConfigVarsDouble[i]
         else
           B1="-1.#QNAN"
         end
         local INT="       int    \t: "..A..""
         -- layout dif-value correctly
         if INT:len()<20 then INT=INT.."\t\t\tDifference to old value: "..A1.."" 
         else INT=INT.."\t\t\tDifference to old value: "..A1.."" end

         -- layout dif-value correctly         
         local DOUBLE="       double\t: "..B
         if DOUBLE:len()<20 then DOUBLE=DOUBLE.."\t\t\tDifference to old value: "..B1.."" 
         elseif DOUBLE:len()<26 then DOUBLE=DOUBLE.."\t\tDifference to old value: "..B1.."" 
         else DOUBLE=DOUBLE.."\tDifference to old value: "..B1.."" end
         
         print(" ")
         print(ConfigVars[i]["configvar"])
         print(INT)
         print(DOUBLE)
         print("       string\t: \""..C.."\"")
       end
       ConfigVarsInt[i]=A
       if tonumber(B)==nil then
         ConfigVarsDouble[i]=0
       else
         ConfigVarsDouble[i]=B
       end
       Retval, String = reaper.BR_Win32_GetPrivateProfileString("REAPER", ConfigVars[i]["configvar"], "unset", reaper.get_ini_file())
       bitvals_csv, bitvalues = ultraschall.ConvertIntegerToBits(A,4)
       bitfield=""
       for i=1, 32, 8 do
         for a=0, 7 do
           bitfield=bitfield..bitvalues[a+i]
           if a==3 then bitfield=bitfield..":" else bitfield=bitfield.." " end
         end
         if i<18 then bitfield=bitfield.."- " end
       end
       if ConsoleToggle==true then
         print("       Bitfield, with &1 at start: "..bitfield)
         print("       Entry in the reaper.ini: [REAPER] -> "..ConfigVars[i]["configvar"].." - Currently set ini-value: "..String)
       end
       ShowString=ShowString.."\n \n"..ConfigVars[i]["configvar"]..":"..
                  "\n       int       : "..A.."    -    Old: "..ConfigVars[i]["int"]..
                  "\n       double: "..B.."    -    Old: "..ConfigVars[i]["double"]..
                  "\n       strings : "..C.."    -    Old: "..ConfigVars[i]["string"]..
                  "\n".."       Bitfield, with &1 at start: "..bitfield..
                  "\n       Entry in the reaper.ini: [REAPER] -> "..ConfigVars[i]["configvar"].." - Currently set ini-value: "..String
       ConfigVars[i]["int"]=A
       ConfigVars[i]["double"]=B
       ConfigVars[i]["string"]=C
    end
  end
  if update==true then print("\n--------------------------------------------------------------------------------------------------------") update=nil end
  if ShowString~=OldShowString and ShowString~="" then OldShowString=ShowString end
end

--[[
function ShowConfigVars(filter)
  gfx.set(0,0,0,1,0,2)
  gfx.rect(0,0,2048,2048,1)
  
  gfx.x=gfx.w-550
  gfx.y=10
  gfx.set(1)
  gfx.setfont(2)
  gfx.drawstr("Filter: ")
  gfx.setfont(1)
  gfx.drawstr(Filter)
  if Filtermode==true then gfx.set(0.8) gfx.drawstr("|") gfx.set(1) end
  
  gfx.x=gfx.w-550
  gfx.y=30
  gfx.setfont(2)
  gfx.drawstr("Altered ConfigVars:")
  gfx.setfont(1)
  gfx.set(0.4)
  gfx.line(gfx.w-555,0,gfx.w-555,gfx.h)
  gfx.line(0,13+gfx.texth,gfx.w,13+gfx.texth)
  gfx.set(1)
  gfx.x=gfx.w-550
  gfx.y=20
  gfx.drawstr(OldShowString)
  if filter==nil then filter="" end
  y=10
  p=0
  gfx.x=12
  gfx.y=y

  gfx.setfont(2)
  gfx.drawstr("Config Vars List")
  gfx.setfont(1)
  y=y+5
  maxentries=0
  for i=1, ConfigVars_Counter-1 do
    if ConfigVars[i]["configvar"]:match(filter)~=nil then
      p=p+1
      if p>=start and p<=stop then
        if i<1000 then trailzero="0" end
        if i<100 then trailzero=trailzero.."0" end
        if i<10 then trailzero=trailzero.."0" end
        gfx.x=17 y=y+gfx.texth-2 gfx.y=y gfx.drawstr(trailzero..i..": "..ConfigVars[i]["configvar"])
        gfx.x=17 y=y+gfx.texth-2 gfx.y=y gfx.drawstr("          int: "..ConfigVars[i]["int"])
        gfx.x=17 y=y+gfx.texth-2 gfx.y=y gfx.drawstr("          double: "..ConfigVars[i]["double"])
        gfx.x=17 y=y+gfx.texth-2 gfx.y=y gfx.drawstr("          string: "..ConfigVars[i]["string"])
        y=y+5
        maxentries=maxentries+1
--        if y+100>gfx.h then MaxEntries=maxentries OO=reaper.time_precise() break end
      end
    end
  end
  gfx.set(1,1,1,1,1,-1)
end

function ToggleFilterMode()
  if Filtermode==true then Filtermode=false else Filtermode=true end
end

Filter=""
--]]
function main()
--[[
  Key=gfx.getchar()
--  if Key~=0 then print3(Key) end
  if Key==1685026670.0 then 
    start=start+1 
    stop=stop+1
    if stop>ConfigVars_Counter-1 then stop=ConfigVars_Counter-1 start=start-1 end
  end
  if Key==30064.0 then
    start=start-1 
    stop=stop-1
    if start<1 then start=0 stop=MaxEntries end
  end
  if Key==1885824110.0 then 
    start=start+MaxEntries
    stop=stop+MaxEntries
    if stop>ConfigVars_Counter-1 then stop=ConfigVars_Counter-1 start=stop-MaxEntries end
  end
  if Key==1885828464.0 then 
    start=start-MaxEntries
    stop=stop-MaxEntries
    if start<1 then start=0 stop=MaxEntries end
  end
--  if Key==13 then ToggleFilterMode() end
  if Filtermode==true and Key>31 and Key<123 then
    Filter=Filter..string.char(Key):lower()
    start=0
    stop=MaxEntries
  elseif Filtermode==true and Key==8 then
    Filter=Filter:sub(1,Filter:len()-1)
  elseif Filtermode==true and Key==27.0 then
    Filter=""
  end
  if Key==26161.0 and ConsoleToggle==true then ConsoleToggle=false
  elseif Key==26161.0 and ConsoleToggle==false then ConsoleToggle=true 
  end
  --]]
  Update_ConfigVars()
  --[[
  ShowConfigVars(Filter)
  gfx.dest=-1
  gfx.x=1
  gfx.y=1
  gfx.blit(2,1,0)
  gfx.dest=2
  --]]
  reaper.defer(main)
end

main()

