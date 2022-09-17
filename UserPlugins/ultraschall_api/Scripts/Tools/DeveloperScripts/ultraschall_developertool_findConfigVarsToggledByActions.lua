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

-- Meo-Ada Mespotine v1.1 (19th of January 2022)
--
-- displays all altered configvars, that are triggered by actions in main section
-- it also writes an output-file, with all the actions and triggered configvars

-- when running it: only close windows that are modal(block the script) and leave the rest as it is. Otherwise, you'll get false-positives!

-- comment January 2022 - sorry for this crappy code. It gets its job done but, holy crap...

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

Answer=reaper.MB("Warning: Running this WILL DESTROY your config, as it will run ALL actions.\n\nAre you sure, that you want to continue?", "WARNING!", 4)

if Answer==7 then return end

Answer=reaper.MB("Warning: I mean it: Running this WILL DESTROY your config, as it will run ALL actions.\n\nDo you want me to better stop?", "WARNING!", 4)

if Answer==6 then return end


Outputfile="c:\\ShowVars_Toggle.txt"
os.remove(Outputfile)

ultraschall.WriteValueToFile(Outputfile, "#ConfigVars triggered by Reaper's actions in the Main-Section.\n#\n#Groups of three are toggle actions and therefore you can see, which is the dif between three toggles.\n#The dif between second and third should be usually the dif-value you are looking for.\n#\n#Groups of only one are actions, who only set a config-var once, but do not toggle it.\n#Some actions do not have a name but still trigger config-vars. It is unknown, why.\n#\n#This list is probably not comprehensive, keep this in mind.\n", false, true) 

 
  function Docs_GetAllConfigVars()
    local A2=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourcefiles/Reaper_Config_Variables.USDocML")
    if A2==nil then A2="" end
    
    local Acount=0
    local orgvars={}
    
    while A2~=nil do
      local line,offs=A2:match("<slug>(.-)</slug>()")
      if offs==nil then break end
      local B=line:sub(1,1)
      if B~="" and B~=" " and B~="#" then 
        orgvars[Acount]=line 
        Acount=Acount+1 
      end
      A2=A2:sub(offs,-1)
    end
    
    table.remove(orgvars, 1)
    return orgvars
  end
  
  
  vars={} -- variable-values
  vars2=Docs_GetAllConfigVars() -- variable-names
  counter=0
  i=1 -- number of variables(for later use)

  for i=1, #vars2 do
    reaper.SNM_SetIntConfigVar(vars2[i],reaper.SNM_GetIntConfigVar(vars2[i],-8)+2)
    vars[vars2[i]]=reaper.SNM_GetIntConfigVar(vars2[i],-8)    
  end
  
i=#vars2
I=0
K=0
a=0 --a=2
AnzahlToggleActions=0
CommandName=""
O=0
Lotto=0
count=1
OldA=""
-- Options: Add edge points when ripple editing or inserting time

function checkchanges(SECTION, AID)
    AID_SEC="SECTION: "..SECTION.." AID:"..AID
    for a=1, i do
      line=vars2[a]
      P=reaper.time_precise()
      -- go through all variables and see, if their values have changed since last defer-run
      -- if they've changed, display them and update the value stored in the table vars
      if reaper.SNM_GetIntConfigVar(line,-8)==vars[line] then--and reaper.SNM_GetDoubleConfigVar(line,-7)==vars[line] then
      elseif line~=nil then
        local oldint=vars[line]
        local olddouble=varsB
        vars[line]=reaper.SNM_GetIntConfigVar(line,-8) -- update value
        varsB=reaper.SNM_GetDoubleConfigVar(line,-8)
        if oldint~=nil then difint=oldint-vars[line] if difint<0 then difint=-difint end else difint="" end
        if olddouble~=nil then difdouble=olddouble-varsB if difdouble<0 then difdouble=-difdouble end else difdouble="" end
        
        
        
        A=reaper.GetExtState("hack","count")
        --CommandName=tostring(reaper.ReverseNamedCommandLookup(AID))
        CommandName=reaper.CF_GetCommandText(SECTION, AID)
        if CommandName==nil or CommandName=="" then CommandName="unknown command name?" end
        --print(CommandName, reaper.ReverseNamedCommandLookup(AID), AID)
        
        if A~=OldA then space="\n"..CommandName.."\n" else space="" end
        ultraschall.WriteValueToFile(Outputfile, space..A.."="..line.." \t\t - INT: "..(vars[line]-2).."(DIF: "..difint..")\t  - DOUBLE: "..(varsB-2).."(DIF: "..difdouble..")\n", false, true) 
        OldA=A
        
        SLEM()

      end
    end
  count=count+1
  if count~=3 then count=2 end  
end



function main()
if Lotto==1 then Lotto=-1 end
Lotto=Lotto+1
if Lotto==1 then
--  I=I+1
  if K==0 then 
    for i=0, 10000 do
      I=I+1
      T=reaper.GetToggleCommandState(I)
      CommandName=tostring(reaper.ReverseNamedCommandLookup(I))
      if T~=-1 and CommandName=="nil" then O=O+1 break end
    end
  end
    if a==0 then Section=32063
    elseif a==1 then Section=100
    elseif a==2 then Section=32060
    elseif a==3 then Section=32061
    elseif a==4 then Section=32062
    elseif a==5 then Section=32063
    end
    if I>65536 then a=a+1 I=0 end
    L=reaper.ReverseNamedCommandLookup(I)                      
    reaper.SetExtState("hack","count","Sec:"..tostring(Section).."_AID:"..tostring(I),true)
    if K>0 then 
      reaper.Main_OnCommand(I,0) 
      --ultraschall.MediaExplorer_OnCommand(I)
      checkchanges(Section, I) 
      K=K+1 end --else I=I+1 end
    if K==0 and T~=-1 then 
      reaper.Main_OnCommand(I,0)
      --ultraschall.MediaExplorer_OnCommand(I)
      checkchanges(Section, I)
      K=K+1 
      AnzahlToggleActions=AnzahlToggleActions+1 
    end
  
    T2=reaper.GetToggleCommandState(I)
    if a<=0 then reaper.defer(main) end
    if K==3 then K=0 end
  else
    reaper.defer(main)
  end
end

for i=0, 50 do
  main()
end



SLEM()
