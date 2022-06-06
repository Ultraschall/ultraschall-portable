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
]]

-------------------------------------
--- ULTRASCHALL - API - FUNCTIONS ---
-------------------------------------
---         Defer  Module         ---
-------------------------------------

function ultraschall.GetDeferIdentifier(deferinstance, scriptidentifier)
  if math.type(deferinstance)~="integer" then ultraschall.AddErrorMessage("GetDeferIdentifier", "deferinstance", "must be an integer", -1) return nil end
  if deferinstance<1 or deferinstance>20 then ultraschall.AddErrorMessage("GetDeferIdentifier", "deferinstance", "must be between 1 and 20", -2) return nil end
  if scriptidentifier~=nil and type(scriptidentifier)~="string" then
    ultraschall.AddErrorMessage("GetDeferIdentifier", "scriptidentifier", "must be a string", -3) 
    return nil
  end
  if scriptidentifier~=nil and scriptidentifier:match("ScriptIdentifier:.-%-%{........%-....%-....%-....%-............%}%....")==nil then 
    ultraschall.AddErrorMessage("GetDeferIdentifier", "scriptidentifier", "must be a valid Scriptidentifier", -4) 
    return nil 
  end
  if deferinstance<10 then zero="0" else zero="" end
  if scriptidentifier~=nil then 
    return scriptidentifier..".defer_script"..zero..deferinstance
  else
    return ultraschall.GetScriptIdentifier()..".defer_script"..zero..deferinstance
  end
end


--A=ultraschall.GetDeferIdentifier(2)

--reaper.CF_SetClipboard(A)

function ultraschall.GetDeferRunState(deferinstance, identifier)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetDeferRunState</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.GetDeferRunState(integer deferinstance, optional string scriptidentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the run-state of a Ultraschall-defer-loop in a specific scriptinstance
      
      You can either request the runstate of a [Defer](#Defer)-deferred-function(set parameter deferinstance to 0).
      
      returns nil in case of an error.
    </description>
    <retvals>
      boolean retval - true, defer-instance is running; false, defer-instance isn't running
    </retvals>
    <parameters>
      integer deferinstance - 0, to use the parameter identifier
      optional string identifier - when deferinstance=0 (when using the Defer-function): the identifier of the defer-cycle, you've started with Defer
    </parameters>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_DeferManagement_Module.lua</source_document>
    <tags>defermanagement, get, defer, runstate, defer_identifier</tags>
  </US_DocBloc>
  ]]
  if math.type(deferinstance)~="integer" then ultraschall.AddErrorMessage("GetDeferRunState", "deferinstance", "must be an integer", -1) return nil end
  if deferinstance<0 or deferinstance>20 then ultraschall.AddErrorMessage("GetDeferRunState", "deferinstance", "must be between 1 and 20", -2) return nil end
  
  if deferinstance==0 then 
    if type(identifier)~="string" then ultraschall.AddErrorMessage("GetDeferRunState", "identifier", "must be a string", 5) return nil end
    if reaper.GetExtState("ultraschall-defer", identifier)=="running" then return true else return false end
  end
  
  if identifier~=nil and type(identifier)~="string" then
    ultraschall.AddErrorMessage("GetDeferRunState", "identifier", "must be a string", -3) 
    return nil
  end
  if identifier~=nil and identifier:match("ScriptIdentifier:.-%-%{........%-....%-....%-....%-............%}%....")==nil then 
    ultraschall.AddErrorMessage("GetDeferRunState", "identifier", "must be a valid Scriptidentifier when deferinstance>0", -4) 
    return nil 
  end
  if deferinstance<10 then zero="0" else zero="" end
  if identifier~=nil then 
    if reaper.GetExtState("ultraschall-defer", identifier..".defer_script"..zero..deferinstance) == "running" then
      return true
    else
      return false
    end
  else
    if reaper.GetExtState("ultraschall-defer", ultraschall.GetScriptIdentifier()..".defer_script"..zero..deferinstance) == "running" then
      return true
    else
      return false
    end
  end
end

function ultraschall.Defer1(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc1)~="function" then 
    ultraschall.AddErrorMessage("Defer1", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer1==nil then 
    ultraschall.AddErrorMessage("Defer1", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer1=timer_counter end 
  if func~=nil then ultraschall.deferfunc1=func end
  if mode~=nil then 
    ultraschall.defermode1=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01", "running", false)
    if mode==2 then ultraschall.defertimer1=ultraschall.defertimer1+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode1==nil then
    ultraschall.defermode1=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01", "running", false)
  end
  
  if (ultraschall.defermode1==0 or ultraschall.defermode1==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01")=="running" then 
    return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01"
  elseif ultraschall.defermode1==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01")=="running" then
    ultraschall.defertimer1=ultraschall.defertimer1-1
    if ultraschall.defertimer1>0 then reaper.defer(ultraschall.Defer1) else return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01" end
  elseif ultraschall.defermode1==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01")=="running" then
    if ultraschall.defertimer1>reaper.time_precise() then reaper.defer(ultraschall.Defer1) else return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script01")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer1", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script01"
end

function ultraschall.StopDeferCycle(identifier)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>StopDeferCycle</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.StopDeferCycle(string defer_identifier)</functioncall>
    <description>
      Stops a running ultraschall.Defer-instance of a script-instance.
            
      returns false in case of an error
    </description>
    <parameters>
      string defer_identifier - the identifier of the defer-cycle of a script-instance
    </parameters>
    <retvals>
      boolean retval - true, stopping this defer-cycle was successful; false, it wasn't successful
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_DeferManagement_Module.lua</source_document>
    <tags>defermanagement, defer, stop</tags>
  </US_DocBloc>
  ]]
  if type(identifier)~="string" then ultraschall.AddErrorMessage("StopDeferCycle", "identifier", "must be a string", -1) return false end
  local IdentifierPattern="ScriptIdentifier:.-%-{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x}.defer_script%d%d"
  if reaper.HasExtState("ultraschall-defer", identifier)==true then
    --reaper.DeleteExtState("ultraschall-defer", identifier, false)
    reaper.SetExtState("ultraschall-defer", identifier.."_set", "1", false)
    return true
  else
    return false
  end
end

function ultraschall.Defer2(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc2)~="function" then 
    ultraschall.AddErrorMessage("Defer2", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer2==nil then 
    ultraschall.AddErrorMessage("Defer2", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer2=timer_counter end 
  if func~=nil then ultraschall.deferfunc2=func end
  if mode~=nil then 
    ultraschall.defermode2=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02", "running", false)
    if mode==2 then ultraschall.defertimer2=ultraschall.defertimer2+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode2==nil then
    ultraschall.defermode2=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02", "running", false)
  end
  
  if (ultraschall.defermode2==0 or ultraschall.defermode2==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02")=="running" then 
    return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02"
  elseif ultraschall.defermode2==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02")=="running" then
    ultraschall.defertimer2=ultraschall.defertimer2-1
    if ultraschall.defertimer2>0 then reaper.defer(ultraschall.Defer2) else return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02" end
  elseif ultraschall.defermode2==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02")=="running" then
    if ultraschall.defertimer2>reaper.time_precise() then reaper.defer(ultraschall.Defer2) else return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script02")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer2", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script02"
end


function ultraschall.Defer3(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc3)~="function" then 
    ultraschall.AddErrorMessage("Defer3", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer3==nil then 
    ultraschall.AddErrorMessage("Defer3", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer3=timer_counter end 
  if func~=nil then ultraschall.deferfunc3=func end
  if mode~=nil then 
    ultraschall.defermode3=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03", "running", false)
    if mode==2 then ultraschall.defertimer3=ultraschall.defertimer3+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode3==nil then
    ultraschall.defermode3=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03", "running", false)
  end
  
  if (ultraschall.defermode3==0 or ultraschall.defermode3==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03")=="running" then 
    return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03"
  elseif ultraschall.defermode3==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03")=="running" then
    ultraschall.defertimer3=ultraschall.defertimer3-1
    if ultraschall.defertimer3>0 then reaper.defer(ultraschall.Defer3) else return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03" end
  elseif ultraschall.defermode3==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03")=="running" then
    if ultraschall.defertimer3>reaper.time_precise() then reaper.defer(ultraschall.Defer3) else return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script03")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer3", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script03"
end


function ultraschall.Defer4(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc4)~="function" then 
    ultraschall.AddErrorMessage("Defer4", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer4==nil then 
    ultraschall.AddErrorMessage("Defer4", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer4=timer_counter end 
  if func~=nil then ultraschall.deferfunc4=func end
  if mode~=nil then 
    ultraschall.defermode4=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04", "running", false)
    if mode==2 then ultraschall.defertimer4=ultraschall.defertimer4+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode4==nil then
    ultraschall.defermode4=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04", "running", false)
  end
  
  if (ultraschall.defermode4==0 or ultraschall.defermode4==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04")=="running" then 
    return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04"
  elseif ultraschall.defermode4==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04")=="running" then
    ultraschall.defertimer4=ultraschall.defertimer4-1
    if ultraschall.defertimer4>0 then reaper.defer(ultraschall.Defer4) else return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04" end
  elseif ultraschall.defermode4==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04")=="running" then
    if ultraschall.defertimer4>reaper.time_precise() then reaper.defer(ultraschall.Defer4) else return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script04")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer4", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script04"
end


function ultraschall.Defer5(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc5)~="function" then 
    ultraschall.AddErrorMessage("Defer5", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer5==nil then 
    ultraschall.AddErrorMessage("Defer5", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer5=timer_counter end 
  if func~=nil then ultraschall.deferfunc5=func end
  if mode~=nil then 
    ultraschall.defermode5=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05", "running", false)
    if mode==2 then ultraschall.defertimer5=ultraschall.defertimer5+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode5==nil then
    ultraschall.defermode5=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05", "running", false)
  end
  
  if (ultraschall.defermode5==0 or ultraschall.defermode5==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05")=="running" then 
    return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05"
  elseif ultraschall.defermode5==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05")=="running" then
    ultraschall.defertimer5=ultraschall.defertimer5-1
    if ultraschall.defertimer5>0 then reaper.defer(ultraschall.Defer5) else return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05" end
  elseif ultraschall.defermode5==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05")=="running" then
    if ultraschall.defertimer5>reaper.time_precise() then reaper.defer(ultraschall.Defer5) else return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script05")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer5", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script05"
end


function ultraschall.Defer6(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc6)~="function" then 
    ultraschall.AddErrorMessage("Defer6", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer6==nil then 
    ultraschall.AddErrorMessage("Defer6", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer6=timer_counter end 
  if func~=nil then ultraschall.deferfunc6=func end
  if mode~=nil then 
    ultraschall.defermode6=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06", "running", false)
    if mode==2 then ultraschall.defertimer6=ultraschall.defertimer6+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode6==nil then
    ultraschall.defermode6=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06", "running", false)
  end
  
  if (ultraschall.defermode6==0 or ultraschall.defermode6==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06")=="running" then 
    return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06"
  elseif ultraschall.defermode6==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06")=="running" then
    ultraschall.defertimer6=ultraschall.defertimer6-1
    if ultraschall.defertimer6>0 then reaper.defer(ultraschall.Defer6) else return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06" end
  elseif ultraschall.defermode6==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06")=="running" then
    if ultraschall.defertimer6>reaper.time_precise() then reaper.defer(ultraschall.Defer6) else return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script06")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer6", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script06"
end


function ultraschall.Defer7(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc7)~="function" then 
    ultraschall.AddErrorMessage("Defer7", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer7==nil then 
    ultraschall.AddErrorMessage("Defer7", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer7=timer_counter end 
  if func~=nil then ultraschall.deferfunc7=func end
  if mode~=nil then 
    ultraschall.defermode7=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07", "running", false)
    if mode==2 then ultraschall.defertimer7=ultraschall.defertimer7+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode7==nil then
    ultraschall.defermode7=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07", "running", false)
  end
  
  if (ultraschall.defermode7==0 or ultraschall.defermode7==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07")=="running" then 
    return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07"
  elseif ultraschall.defermode7==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07")=="running" then
    ultraschall.defertimer7=ultraschall.defertimer7-1
    if ultraschall.defertimer7>0 then reaper.defer(ultraschall.Defer7) else return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07" end
  elseif ultraschall.defermode7==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07")=="running" then
    if ultraschall.defertimer7>reaper.time_precise() then reaper.defer(ultraschall.Defer7) else return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script07")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer7", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script07"
end


function ultraschall.Defer8(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc8)~="function" then 
    ultraschall.AddErrorMessage("Defer8", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer8==nil then 
    ultraschall.AddErrorMessage("Defer8", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer8=timer_counter end 
  if func~=nil then ultraschall.deferfunc8=func end
  if mode~=nil then 
    ultraschall.defermode8=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08", "running", false)
    if mode==2 then ultraschall.defertimer8=ultraschall.defertimer8+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode8==nil then
    ultraschall.defermode8=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08", "running", false)
  end
  
  if (ultraschall.defermode8==0 or ultraschall.defermode8==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08")=="running" then 
    return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08"
  elseif ultraschall.defermode8==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08")=="running" then
    ultraschall.defertimer8=ultraschall.defertimer8-1
    if ultraschall.defertimer8>0 then reaper.defer(ultraschall.Defer8) else return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08" end
  elseif ultraschall.defermode8==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08")=="running" then
    if ultraschall.defertimer8>reaper.time_precise() then reaper.defer(ultraschall.Defer8) else return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script08")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer8", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script08"
end


function ultraschall.Defer9(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc9)~="function" then 
    ultraschall.AddErrorMessage("Defer9", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer9==nil then 
    ultraschall.AddErrorMessage("Defer9", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer9=timer_counter end 
  if func~=nil then ultraschall.deferfunc9=func end
  if mode~=nil then 
    ultraschall.defermode9=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09", "running", false)
    if mode==2 then ultraschall.defertimer9=ultraschall.defertimer9+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode9==nil then
    ultraschall.defermode9=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09", "running", false)
  end
  
  if (ultraschall.defermode9==0 or ultraschall.defermode9==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09")=="running" then 
    return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09"
  elseif ultraschall.defermode9==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09")=="running" then
    ultraschall.defertimer9=ultraschall.defertimer9-1
    if ultraschall.defertimer9>0 then reaper.defer(ultraschall.Defer9) else return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09" end
  elseif ultraschall.defermode9==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09")=="running" then
    if ultraschall.defertimer9>reaper.time_precise() then reaper.defer(ultraschall.Defer9) else return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script09")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer9", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script09"
end


function ultraschall.Defer10(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc10)~="function" then 
    ultraschall.AddErrorMessage("Defer10", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer10==nil then 
    ultraschall.AddErrorMessage("Defer10", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer10=timer_counter end 
  if func~=nil then ultraschall.deferfunc10=func end
  if mode~=nil then 
    ultraschall.defermode10=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10", "running", false)
    if mode==2 then ultraschall.defertimer10=ultraschall.defertimer10+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode10==nil then
    ultraschall.defermode10=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10", "running", false)
  end
  
  if (ultraschall.defermode10==0 or ultraschall.defermode10==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10")=="running" then 
    return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10"
  elseif ultraschall.defermode10==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10")=="running" then
    ultraschall.defertimer10=ultraschall.defertimer10-1
    if ultraschall.defertimer10>0 then reaper.defer(ultraschall.Defer10) else return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10" end
  elseif ultraschall.defermode10==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10")=="running" then
    if ultraschall.defertimer10>reaper.time_precise() then reaper.defer(ultraschall.Defer10) else return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script10")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer10", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script10"
end


function ultraschall.Defer11(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc11)~="function" then 
    ultraschall.AddErrorMessage("Defer11", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer11==nil then 
    ultraschall.AddErrorMessage("Defer11", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer11=timer_counter end 
  if func~=nil then ultraschall.deferfunc11=func end
  if mode~=nil then 
    ultraschall.defermode11=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11", "running", false)
    if mode==2 then ultraschall.defertimer11=ultraschall.defertimer11+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode11==nil then
    ultraschall.defermode11=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11", "running", false)
  end
  
  if (ultraschall.defermode11==0 or ultraschall.defermode11==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11")=="running" then 
    return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11"
  elseif ultraschall.defermode11==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11")=="running" then
    ultraschall.defertimer11=ultraschall.defertimer11-1
    if ultraschall.defertimer11>0 then reaper.defer(ultraschall.Defer11) else return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11" end
  elseif ultraschall.defermode11==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11")=="running" then
    if ultraschall.defertimer11>reaper.time_precise() then reaper.defer(ultraschall.Defer11) else return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script11")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer11", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script11"
end


function ultraschall.Defer12(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc12)~="function" then 
    ultraschall.AddErrorMessage("Defer12", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer12==nil then 
    ultraschall.AddErrorMessage("Defer12", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer12=timer_counter end 
  if func~=nil then ultraschall.deferfunc12=func end
  if mode~=nil then 
    ultraschall.defermode12=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12", "running", false)
    if mode==2 then ultraschall.defertimer12=ultraschall.defertimer12+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode12==nil then
    ultraschall.defermode12=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12", "running", false)
  end
  
  if (ultraschall.defermode12==0 or ultraschall.defermode12==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12")=="running" then 
    return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12"
  elseif ultraschall.defermode12==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12")=="running" then
    ultraschall.defertimer12=ultraschall.defertimer12-1
    if ultraschall.defertimer12>0 then reaper.defer(ultraschall.Defer12) else return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12" end
  elseif ultraschall.defermode12==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12")=="running" then
    if ultraschall.defertimer12>reaper.time_precise() then reaper.defer(ultraschall.Defer12) else return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script12")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer12", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script12"
end


function ultraschall.Defer13(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc13)~="function" then 
    ultraschall.AddErrorMessage("Defer13", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer13==nil then 
    ultraschall.AddErrorMessage("Defer13", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer13=timer_counter end 
  if func~=nil then ultraschall.deferfunc13=func end
  if mode~=nil then 
    ultraschall.defermode13=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13", "running", false)
    if mode==2 then ultraschall.defertimer13=ultraschall.defertimer13+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode13==nil then
    ultraschall.defermode13=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13", "running", false)
  end
  
  if (ultraschall.defermode13==0 or ultraschall.defermode13==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13")=="running" then 
    return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13"
  elseif ultraschall.defermode13==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13")=="running" then
    ultraschall.defertimer13=ultraschall.defertimer13-1
    if ultraschall.defertimer13>0 then reaper.defer(ultraschall.Defer13) else return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13" end
  elseif ultraschall.defermode13==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13")=="running" then
    if ultraschall.defertimer13>reaper.time_precise() then reaper.defer(ultraschall.Defer13) else return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script13")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer13", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script13"
end


function ultraschall.Defer14(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc14)~="function" then 
    ultraschall.AddErrorMessage("Defer14", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer14==nil then 
    ultraschall.AddErrorMessage("Defer14", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer14=timer_counter end 
  if func~=nil then ultraschall.deferfunc14=func end
  if mode~=nil then 
    ultraschall.defermode14=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14", "running", false)
    if mode==2 then ultraschall.defertimer14=ultraschall.defertimer14+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode14==nil then
    ultraschall.defermode14=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14", "running", false)
  end
  
  if (ultraschall.defermode14==0 or ultraschall.defermode14==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14")=="running" then 
    return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14"
  elseif ultraschall.defermode14==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14")=="running" then
    ultraschall.defertimer14=ultraschall.defertimer14-1
    if ultraschall.defertimer14>0 then reaper.defer(ultraschall.Defer14) else return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14" end
  elseif ultraschall.defermode14==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14")=="running" then
    if ultraschall.defertimer14>reaper.time_precise() then reaper.defer(ultraschall.Defer14) else return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script14")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer14", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script14"
end


function ultraschall.Defer15(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc15)~="function" then 
    ultraschall.AddErrorMessage("Defer15", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer15==nil then 
    ultraschall.AddErrorMessage("Defer15", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer15=timer_counter end 
  if func~=nil then ultraschall.deferfunc15=func end
  if mode~=nil then 
    ultraschall.defermode15=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15", "running", false)
    if mode==2 then ultraschall.defertimer15=ultraschall.defertimer15+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode15==nil then
    ultraschall.defermode15=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15", "running", false)
  end
  
  if (ultraschall.defermode15==0 or ultraschall.defermode15==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15")=="running" then 
    return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15"
  elseif ultraschall.defermode15==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15")=="running" then
    ultraschall.defertimer15=ultraschall.defertimer15-1
    if ultraschall.defertimer15>0 then reaper.defer(ultraschall.Defer15) else return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15" end
  elseif ultraschall.defermode15==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15")=="running" then
    if ultraschall.defertimer15>reaper.time_precise() then reaper.defer(ultraschall.Defer15) else return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script15")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer15", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script15"
end


function ultraschall.Defer16(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc16)~="function" then 
    ultraschall.AddErrorMessage("Defer16", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer16==nil then 
    ultraschall.AddErrorMessage("Defer16", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer16=timer_counter end 
  if func~=nil then ultraschall.deferfunc16=func end
  if mode~=nil then 
    ultraschall.defermode16=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16", "running", false)
    if mode==2 then ultraschall.defertimer16=ultraschall.defertimer16+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode16==nil then
    ultraschall.defermode16=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16", "running", false)
  end
  
  if (ultraschall.defermode16==0 or ultraschall.defermode16==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16")=="running" then 
    return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16"
  elseif ultraschall.defermode16==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16")=="running" then
    ultraschall.defertimer16=ultraschall.defertimer16-1
    if ultraschall.defertimer16>0 then reaper.defer(ultraschall.Defer16) else return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16" end
  elseif ultraschall.defermode16==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16")=="running" then
    if ultraschall.defertimer16>reaper.time_precise() then reaper.defer(ultraschall.Defer16) else return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script16")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer16", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script16"
end


function ultraschall.Defer17(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc17)~="function" then 
    ultraschall.AddErrorMessage("Defer17", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer17==nil then 
    ultraschall.AddErrorMessage("Defer17", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer17=timer_counter end 
  if func~=nil then ultraschall.deferfunc17=func end
  if mode~=nil then 
    ultraschall.defermode17=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17", "running", false)
    if mode==2 then ultraschall.defertimer17=ultraschall.defertimer17+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode17==nil then
    ultraschall.defermode17=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17", "running", false)
  end
  
  if (ultraschall.defermode17==0 or ultraschall.defermode17==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17")=="running" then 
    return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17"
  elseif ultraschall.defermode17==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17")=="running" then
    ultraschall.defertimer17=ultraschall.defertimer17-1
    if ultraschall.defertimer17>0 then reaper.defer(ultraschall.Defer17) else return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17" end
  elseif ultraschall.defermode17==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17")=="running" then
    if ultraschall.defertimer17>reaper.time_precise() then reaper.defer(ultraschall.Defer17) else return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script17")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer17", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script17"
end


function ultraschall.Defer18(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc18)~="function" then 
    ultraschall.AddErrorMessage("Defer18", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer18==nil then 
    ultraschall.AddErrorMessage("Defer18", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer18=timer_counter end 
  if func~=nil then ultraschall.deferfunc18=func end
  if mode~=nil then 
    ultraschall.defermode18=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18", "running", false)
    if mode==2 then ultraschall.defertimer18=ultraschall.defertimer18+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode18==nil then
    ultraschall.defermode18=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18", "running", false)
  end
  
  if (ultraschall.defermode18==0 or ultraschall.defermode18==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18")=="running" then 
    return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18"
  elseif ultraschall.defermode18==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18")=="running" then
    ultraschall.defertimer18=ultraschall.defertimer18-1
    if ultraschall.defertimer18>0 then reaper.defer(ultraschall.Defer18) else return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18" end
  elseif ultraschall.defermode18==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18")=="running" then
    if ultraschall.defertimer18>reaper.time_precise() then reaper.defer(ultraschall.Defer18) else return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script18")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer18", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script18"
end


function ultraschall.Defer19(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc19)~="function" then 
    ultraschall.AddErrorMessage("Defer19", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer19==nil then 
    ultraschall.AddErrorMessage("Defer19", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer19=timer_counter end 
  if func~=nil then ultraschall.deferfunc19=func end
  if mode~=nil then 
    ultraschall.defermode19=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19", "running", false)
    if mode==2 then ultraschall.defertimer19=ultraschall.defertimer19+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode19==nil then
    ultraschall.defermode19=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19", "running", false)
  end
  
  if (ultraschall.defermode19==0 or ultraschall.defermode19==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19")=="running" then 
    return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19"
  elseif ultraschall.defermode19==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19")=="running" then
    ultraschall.defertimer19=ultraschall.defertimer19-1
    if ultraschall.defertimer19>0 then reaper.defer(ultraschall.Defer19) else return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19" end
  elseif ultraschall.defermode19==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19")=="running" then
    if ultraschall.defertimer19>reaper.time_precise() then reaper.defer(ultraschall.Defer19) else return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script19")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer19", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script19"
end


function ultraschall.Defer20(func, mode, timer_counter)
  if type(func)~="function" and type(ultraschall.deferfunc20)~="function" then 
    ultraschall.AddErrorMessage("Defer20", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil and ultraschall.defertimer20==nil then 
    ultraschall.AddErrorMessage("Defer20", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if timer_counter~=nil then ultraschall.defertimer20=timer_counter end 
  if func~=nil then ultraschall.deferfunc20=func end
  if mode~=nil then 
    ultraschall.defermode20=mode
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20", "running", false)
    if mode==2 then ultraschall.defertimer20=ultraschall.defertimer20+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode20==nil then
    ultraschall.defermode20=0
    reaper.SetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20", "running", false)
  end
  
  if (ultraschall.defermode20==0 or ultraschall.defermode20==nil) and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20")=="running" then 
    return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20"
  elseif ultraschall.defermode20==1 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20")=="running" then
    ultraschall.defertimer20=ultraschall.defertimer20-1
    if ultraschall.defertimer20>0 then reaper.defer(ultraschall.Defer20) else return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20" end
  elseif ultraschall.defermode20==2 and reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20")=="running" then
    if ultraschall.defertimer20>reaper.time_precise() then reaper.defer(ultraschall.Defer20) else return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20" end
  elseif reaper.GetExtState("ultraschall-defer", ultraschall.ScriptIdentifier..".defer_script20")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer20", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script20"
end

function ultraschall.Defer(func, deferidentifier, mode, timer_counter, protected)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer</slug>
    <requires>
      Ultraschall=4.00
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>boolean retval, optional string defer_identifier = ultraschall.Defer(function func, string deferidentifier, optional integer mode, optional number timer_counter, optional boolean protected)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this defer-cycle shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier you have given.
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle), as long as parameter protected is not set to true!
      **Important:** make the deferidentifier as unique as possible(using guids or similar stuff) to avoid naming conflicts with other defer-cycles using the same identifier.
                 Otherwise, you risk stopping multiple such defer-loops, when using [StopDeferCycle](#StopDeferCycle)!
                 
      For the old Defer1 to Defer20-behavior, try ultraschall.ScriptIdentifier..".defer_scriptXX" as defer-identifier, where XX is a number.
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      string deferidentifier - an identifier, under which you can access this defer-cycle; make it unique using guids in the name, to avoid name-conflicts!
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
      optional boolean protected - true, this defer-cycle is protected from being stopped by StopDeferCycle(); false or nil, you can stop this defer-cycle using StopDeferCycle()
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      optional string defer_identifier - if running this defer-cycle was successful, this holds the defer-identifier you've chosen
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_DeferManagement_Module.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds, defer-identifier</tags>
  </US_DocBloc>
  ]]  
  if type(deferidentifier)~="string" then ultraschall.AddErrorMessage("Defer", "deferidentifier", "must be a string", -4) return false end
  if deferidentifier:len()==0 then ultraschall.AddErrorMessage("Defer", "deferidentifier", "must be a string with at least one character", -5) return false end
  
  -- cleanup-preparation, for when the defer-function is ended
  if reaper.GetExtState("ultraschall-defer", deferidentifier)~="running" then
    function cleanupdefer()
        reaper.DeleteExtState("ultraschall-defer", deferidentifier, false)
        reaper.DeleteExtState("ultraschall-defer", deferidentifier.."-ScriptIdentifier", false)
        reaper.DeleteExtState("ultraschall-defer", deferidentifier.."-LastCallTime", false)
        reaper.DeleteExtState("ultraschall-defer", deferidentifier.."_set",false)
        reaper.DeleteExtState("ultraschall-defer", deferidentifier.."_setdefault",false)
    end
    reaper.atexit(cleanupdefer)
  end
  
  -- let's check the parameters and prepare some extstates for later communication with the outside world
  local defertimer
  if type(func)~="function" then 
    ultraschall.AddErrorMessage("Defer", "func", "must be a function", -1)
    return false 
  end
  if mode~=0 and mode~=nil and timer_counter==nil then 
    ultraschall.AddErrorMessage("Defer", "timer_counter", "must be a number, when mode is 1 or 2", -2)
    return false 
  end
  if mode~=nil then 
    reaper.SetExtState("ultraschall-defer", deferidentifier, "running", false)
    reaper.SetExtState("ultraschall-defer", deferidentifier.."-ScriptIdentifier", ultraschall.ScriptIdentifier, false)
    reaper.SetExtState("ultraschall-defer", deferidentifier.."-LastCallTime", reaper.time_precise(), false)
    if reaper.HasExtState("ultraschall-defer", deferidentifier.."_setdefault")==false then
      reaper.SetExtState("ultraschall-defer", deferidentifier.."_setdefault", "2,"..mode..","..timer_counter, false)
    end
    if mode==1 then defertimer=timer_counter end
    if mode==2 then defertimer=timer_counter+reaper.time_precise() 
  end
  elseif mode==nil then
    mode=0
    reaper.SetExtState("ultraschall-defer", deferidentifier, "running", false)
    reaper.SetExtState("ultraschall-defer", deferidentifier.."-ScriptIdentifier", reaper.time_precise()..ultraschall.ScriptIdentifier, false)
    reaper.SetExtState("ultraschall-defer", deferidentifier.."-LastCallTime", reaper.time_precise(), false)
    if reaper.HasExtState("ultraschall-defer", deferidentifier.."_setdefault")==false then
      reaper.SetExtState("ultraschall-defer", deferidentifier.."_setdefault", "2,0,0", false)
    end
  end
  local OldSetMe, SetMe2, SetMe
  
  -- now, we let the magic happening
  local function internaldefer()
    -- nested defer-function, who does the whole defer-management.
    
    -- first, let's check, if someone requested from the outside to change mode and timer_counter or even stop the defer-cycle
    SetMe2=reaper.GetExtState("ultraschall-defer", deferidentifier.."_set")
    if SetMe2~=OldSetMe then SetMe=SetMe2 end
    if SetMe:sub(1,1)=="2" then
      -- if yes, set the new mode, timer_counter and restart the counter imediately so the new
      -- settings takes immediately effect
      mode, timer_counter=SetMe:match(".-,(.-),(.*)")
      mode=tonumber(mode)
      timer_counter=tonumber(timer_counter)
      if mode==2 then defertimer=reaper.time_precise()+timer_counter elseif mode==1 then defertimer=timer_counter end
      OldSetMe=SetMe
      SetMe=""
    elseif SetMe=="1" then
      -- if stopping has been requested, follow that wish like a genie
      reaper.DeleteExtState("ultraschall-defer", deferidentifier.."_set", false) 
      if protected~=true then
        return 
      end
    end
        --print_update(mode,timer_counter,defertimer,SetMe, SetMe2,111,SetMe2~=SetMe3) -- debugmessageline
     
    -- now, we check for the different defer-mode-conditions and manage the correct downcounting/timing until the next defer-cycle
    if (mode==0 or mode==nil) and reaper.GetExtState("ultraschall-defer", deferidentifier)=="running" then 
      -- regular defer
      return reaper.defer(func), deferidentifier
    elseif mode==1 and reaper.GetExtState("ultraschall-defer", deferidentifier)=="running" then
      -- only defer every nth defer-cycle
      defertimer=defertimer-1
      if defertimer>0 then reaper.defer(internaldefer) else return reaper.defer(func) end
    elseif mode==2 and reaper.GetExtState("ultraschall-defer", deferidentifier)=="running" then
      -- only defer every nth second
      if defertimer>reaper.time_precise() then reaper.defer(internaldefer) else defertimer=reaper.time_precise()+timer_counter return reaper.defer(func) end
    else 
      -- no such mode available
      ultraschall.AddErrorMessage("Defer", "mode", "mode must be between 0 and 2 or nil", -3)
      return false
    end
  end
  return true, deferidentifier, internaldefer()
end

function ultraschall.SetDeferCycleSettings(deferidentifier, mode, timer_counter)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetDeferCycleSettings</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetDeferCycleSettings(string deferidentifier, optional integer mode, optional number timer_counter)</functioncall>
  <description>
    Sets the mode and timing settings of a running ultraschall.Defer-instance. You can set its mode and the timer/counter-values, even from a script, which does not run the defer-instance!
    
    Returns false in case of failure.
  </description>
  <parameters>
     string deferidentifier - an identifier, under which you can access this defer-cycle; make it unique using guids in the name, to avoid name-conflicts! 
     optional integer mode - the timing mode, in which the defer-cycle runs
                           - nil, reset to the default-settings of the Defer-Cycle
                           - 0, just run as regular defer-cycle
                           - 1, run the defer-cycle only every timer_counter-cycle
                           - 2, run the defer-cycle only every timer_counter-seconds 
     optional number timer_counter - the timer for the defer-cycle
                                   - mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                   -              30 cycles are approximately 1 second.
                                   - mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time. 
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <chapter_context>
    Defer-Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_DeferManagement_Module.lua</source_document>
  <tags>defermanagement, set, defer, cycle, mode, timer, counter</tags>
</US_DocBloc>
]]
  if type(deferidentifier)~="string" then ultraschall.AddErrorMessage("SetDeferCycleSettings", "deferidentifier", "must be a string", -2) return false end
  if mode==nil then reaper.DeleteExtState("ultraschall-defer", deferidentifier.."_set", false) return end
  if math.type(mode)~="integer" then ultraschall.AddErrorMessage("SetDeferCycleSettings", "mode", "must be an integer", -2) return false end
  if mode~=0 and math.type(timer_counter)~="integer" then ultraschall.AddErrorMessage("SetDeferCycleSettings", "timer_counter", "must be an integer", -3) return false end
  if mode==0 then timer_counter=0 end
  if mode<0 or mode>2 then ultraschall.AddErrorMessage("SetDeferCycleSettings", "mode", "must be between 0 and 2", -4) return false end
  reaper.SetExtState("ultraschall-defer", deferidentifier.."_set", "2,"..mode..","..timer_counter, false)
  return true
end

function ultraschall.GetDeferCycleSettings(deferidentifier)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetDeferCycleSettings</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer mode, integer timer_counter = ultraschall.GetDeferCycleSettings(string deferidentifier)</functioncall>
  <description>
    Gets a the mode and timing-settings of a currently running ultraschall.Defer()-cycle
    
    Returns nil in case of failure.
  </description>
  <parameters>
     string deferidentifier - an identifier, under which you can access this defer-cycle; make it unique using guids in the name, to avoid name-conflicts! 
  </parameters>
  <retvals>
    integer mode - the timing mode, in which the defer-cycle runs
                 - 0, just run as regular defer-cycle
                 - 1, run the defer-cycle only every timer_counter-cycle
                 - 2, run the defer-cycle only every timer_counter-seconds 
    number timer_counter - the timer for the defer-cycle
                         - mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                         -              30 cycles are approximately 1 second.
                         - mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time. 
  </retvals>
  <chapter_context>
    Defer-Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_DeferManagement_Module.lua</source_document>
  <tags>defermanagement, get, settings, defer, cycle, mode, timer, counter</tags>
</US_DocBloc>
]]
  if type(deferidentifier)~="string" then ultraschall.AddErrorMessage("GetDeferCycleSettings", "deferidentifier", "must be a string", -2) return end
  if ultraschall.GetDeferRunState(0, deferidentifier)==false then ultraschall.AddErrorMessage("GetDeferCycleSettings", "deferidentifier", "no such defer-instance running currently", -1) return end
  local Mode, TimerCounter
  if reaper.HasExtState("ultraschall-defer", deferidentifier.."_set")==true then
    Mode,TimerCounter=reaper.GetExtState("ultraschall-defer", deferidentifier.."_set"):match(".-,(.-),(.*)")
  else
    Mode,TimerCounter=reaper.GetExtState("ultraschall-defer", deferidentifier.."_setdefault"):match(".-,(.-),(.*)")
  end
  return tonumber(Mode), tonumber(TimerCounter)
end
--A,B=ultraschall.GetDeferCycleSettings("Tudelu1")

