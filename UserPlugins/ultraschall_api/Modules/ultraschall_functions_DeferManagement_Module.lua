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

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Defer-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  if string=="" then string=10000 
  else 
    string=tonumber(string) 
    string=string+1
  end
  if string2=="" then string2=10000 
  else 
    string2=tonumber(string2)
    string2=string2+1
  end 
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end

function ultraschall.GetDeferIdentifier(deferinstance, scriptidentifier)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetDeferIdentifier</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string defer_identifier = ultraschall.GetDeferIdentifier(integer deferinstance, optional string scriptidentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the identifier for a specific ultraschall-defer-function.
      
      This defer-indentifier can be used to stop this defer-loop from the in- and outside of the script.
      Be aware: This returns the defer-identifier even if the defer-loop in question isn't running currently!
      
      returns nil in case of an error.
    </description>
    <retvals>
      string defer_identifier - a specific and unique defer-identifier for this script-instance, of the format:
                               - ScriptIdentifier: scriptfilename-guid.ext.deferXX
                               - where XX is the defer-function-number. XX is between 1 and 20
    </retvals>
    <parameters>
      integer deferinstance - the defer-instance, whose identifier you want; 1 to 20
      optional string scriptidentifier - you can pass a script-identifier for a specific scriptinstance to get the defer-identifiers of that script-instance; nil, to get the defer-identifiers of the current scriptinstance
    </parameter>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, get, defer_identifier</tags>
  </US_DocBloc>
  ]]
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

function ultraschall.GetDeferRunState(deferinstance, scriptidentifier)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetDeferRunState</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string defer_identifier = ultraschall.GetDeferRunState(integer deferinstance, optional string scriptidentifier)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the run-state of a Ultraschall-defer-loop in a specific scriptinstance
      
      returns nil in case of an error.
    </description>
    <retvals>
      string defer_identifier - a specific and unique defer-identifier for this script-instance, of the format:
                               - ScriptIdentifier: scriptfilename-guid.ext.deferXX
                               - where XX is the defer-function-number. XX is between 1 and 20
    </retvals>
    <parameters>
      integer deferinstance - the defer-instance, whose identifier you want; 1 to 20
      optional string scriptidentifier - a script-identifier of a specific script-instance; nil, for the current script-instance
    </parameter>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, get, defer, runstate, defer_identifier</tags>
  </US_DocBloc>
  ]]
  if math.type(deferinstance)~="integer" then ultraschall.AddErrorMessage("GetDeferRunState", "deferinstance", "must be an integer", -1) return nil end
  if deferinstance<1 or deferinstance>20 then ultraschall.AddErrorMessage("GetDeferRunState", "deferinstance", "must be between 1 and 20", -2) return nil end
  if scriptidentifier~=nil and type(scriptidentifier)~="string" then
    ultraschall.AddErrorMessage("GetDeferRunState", "scriptidentifier", "must be a string", -3) 
    return nil
  end
  if scriptidentifier~=nil and scriptidentifier:match("ScriptIdentifier:.-%-%{........%-....%-....%-....%-............%}%....")==nil then 
    ultraschall.AddErrorMessage("GetDeferRunState", "scriptidentifier", "must be a valid Scriptidentifier", -4) 
    return nil 
  end
  if deferinstance<10 then zero="0" else zero="" end
  if scriptidentifier~=nil then 
    if reaper.GetExtState("ultraschall", scriptidentifier..".defer_script"..zero..deferinstance) == "running" then
      return true
    else
      return false
    end
  else
    if reaper.GetExtState("ultraschall", ultraschall.GetScriptIdentifier()..".defer_script"..zero..deferinstance) == "running" then
      return true
    else
      return false
    end
  end
end

function ultraschall.Defer1(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer1</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer1(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01", "running", false)
    if mode==2 then ultraschall.defertimer1=ultraschall.defertimer1+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode1==nil then
    ultraschall.defermode1=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01", "running", false)
  end
  
  if (ultraschall.defermode1==0 or ultraschall.defermode1==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01")=="running" then 
    return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01"
  elseif ultraschall.defermode1==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01")=="running" then
    ultraschall.defertimer1=ultraschall.defertimer1-1
    if ultraschall.defertimer1>0 then reaper.defer(ultraschall.Defer1) else return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01" end
  elseif ultraschall.defermode1==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01")=="running" then
    if ultraschall.defertimer1>reaper.time_precise() then reaper.defer(ultraschall.Defer1) else return reaper.defer(ultraschall.deferfunc1), ultraschall.ScriptIdentifier..".defer_script01" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script01")~="running" then
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
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
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
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, stop</tags>
  </US_DocBloc>
  ]]
  if type(identifier)~="string" then ultraschall.AddErrorMessage("StopDeferCycle", "identifier", "must be a string", -1) return false end
  local IdentifierPattern="ScriptIdentifier:.-%-{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x}.defer_script%d%d"
--  if identifier:match(IdentifierPattern)==nil then ultraschall.AddErrorMessage("StopDeferCycle", "identifier", "no valid defer-identifier", -2) return false end  
  if reaper.HasExtState("ultraschall", identifier)==true then
    reaper.DeleteExtState("ultraschall", identifier, false)
    return true
  else
    return false
  end
end

function ultraschall.Defer2(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer2</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer2(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02", "running", false)
    if mode==2 then ultraschall.defertimer2=ultraschall.defertimer2+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode2==nil then
    ultraschall.defermode2=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02", "running", false)
  end
  
  if (ultraschall.defermode2==0 or ultraschall.defermode2==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02")=="running" then 
    return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02"
  elseif ultraschall.defermode2==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02")=="running" then
    ultraschall.defertimer2=ultraschall.defertimer2-1
    if ultraschall.defertimer2>0 then reaper.defer(ultraschall.Defer2) else return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02" end
  elseif ultraschall.defermode2==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02")=="running" then
    if ultraschall.defertimer2>reaper.time_precise() then reaper.defer(ultraschall.Defer2) else return reaper.defer(ultraschall.deferfunc2), ultraschall.ScriptIdentifier..".defer_script02" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script02")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer2", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script02"
end


function ultraschall.Defer3(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer3</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer3(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03", "running", false)
    if mode==2 then ultraschall.defertimer3=ultraschall.defertimer3+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode3==nil then
    ultraschall.defermode3=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03", "running", false)
  end
  
  if (ultraschall.defermode3==0 or ultraschall.defermode3==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03")=="running" then 
    return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03"
  elseif ultraschall.defermode3==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03")=="running" then
    ultraschall.defertimer3=ultraschall.defertimer3-1
    if ultraschall.defertimer3>0 then reaper.defer(ultraschall.Defer3) else return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03" end
  elseif ultraschall.defermode3==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03")=="running" then
    if ultraschall.defertimer3>reaper.time_precise() then reaper.defer(ultraschall.Defer3) else return reaper.defer(ultraschall.deferfunc3), ultraschall.ScriptIdentifier..".defer_script03" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script03")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer3", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script03"
end


function ultraschall.Defer4(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer4</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer4(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04", "running", false)
    if mode==2 then ultraschall.defertimer4=ultraschall.defertimer4+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode4==nil then
    ultraschall.defermode4=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04", "running", false)
  end
  
  if (ultraschall.defermode4==0 or ultraschall.defermode4==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04")=="running" then 
    return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04"
  elseif ultraschall.defermode4==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04")=="running" then
    ultraschall.defertimer4=ultraschall.defertimer4-1
    if ultraschall.defertimer4>0 then reaper.defer(ultraschall.Defer4) else return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04" end
  elseif ultraschall.defermode4==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04")=="running" then
    if ultraschall.defertimer4>reaper.time_precise() then reaper.defer(ultraschall.Defer4) else return reaper.defer(ultraschall.deferfunc4), ultraschall.ScriptIdentifier..".defer_script04" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script04")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer4", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script04"
end


function ultraschall.Defer5(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer5</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer5(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05", "running", false)
    if mode==2 then ultraschall.defertimer5=ultraschall.defertimer5+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode5==nil then
    ultraschall.defermode5=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05", "running", false)
  end
  
  if (ultraschall.defermode5==0 or ultraschall.defermode5==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05")=="running" then 
    return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05"
  elseif ultraschall.defermode5==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05")=="running" then
    ultraschall.defertimer5=ultraschall.defertimer5-1
    if ultraschall.defertimer5>0 then reaper.defer(ultraschall.Defer5) else return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05" end
  elseif ultraschall.defermode5==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05")=="running" then
    if ultraschall.defertimer5>reaper.time_precise() then reaper.defer(ultraschall.Defer5) else return reaper.defer(ultraschall.deferfunc5), ultraschall.ScriptIdentifier..".defer_script05" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script05")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer5", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script05"
end


function ultraschall.Defer6(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer6</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer6(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06", "running", false)
    if mode==2 then ultraschall.defertimer6=ultraschall.defertimer6+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode6==nil then
    ultraschall.defermode6=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06", "running", false)
  end
  
  if (ultraschall.defermode6==0 or ultraschall.defermode6==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06")=="running" then 
    return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06"
  elseif ultraschall.defermode6==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06")=="running" then
    ultraschall.defertimer6=ultraschall.defertimer6-1
    if ultraschall.defertimer6>0 then reaper.defer(ultraschall.Defer6) else return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06" end
  elseif ultraschall.defermode6==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06")=="running" then
    if ultraschall.defertimer6>reaper.time_precise() then reaper.defer(ultraschall.Defer6) else return reaper.defer(ultraschall.deferfunc6), ultraschall.ScriptIdentifier..".defer_script06" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script06")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer6", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script06"
end


function ultraschall.Defer7(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer7</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer7(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07", "running", false)
    if mode==2 then ultraschall.defertimer7=ultraschall.defertimer7+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode7==nil then
    ultraschall.defermode7=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07", "running", false)
  end
  
  if (ultraschall.defermode7==0 or ultraschall.defermode7==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07")=="running" then 
    return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07"
  elseif ultraschall.defermode7==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07")=="running" then
    ultraschall.defertimer7=ultraschall.defertimer7-1
    if ultraschall.defertimer7>0 then reaper.defer(ultraschall.Defer7) else return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07" end
  elseif ultraschall.defermode7==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07")=="running" then
    if ultraschall.defertimer7>reaper.time_precise() then reaper.defer(ultraschall.Defer7) else return reaper.defer(ultraschall.deferfunc7), ultraschall.ScriptIdentifier..".defer_script07" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script07")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer7", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script07"
end


function ultraschall.Defer8(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer8</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer8(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08", "running", false)
    if mode==2 then ultraschall.defertimer8=ultraschall.defertimer8+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode8==nil then
    ultraschall.defermode8=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08", "running", false)
  end
  
  if (ultraschall.defermode8==0 or ultraschall.defermode8==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08")=="running" then 
    return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08"
  elseif ultraschall.defermode8==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08")=="running" then
    ultraschall.defertimer8=ultraschall.defertimer8-1
    if ultraschall.defertimer8>0 then reaper.defer(ultraschall.Defer8) else return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08" end
  elseif ultraschall.defermode8==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08")=="running" then
    if ultraschall.defertimer8>reaper.time_precise() then reaper.defer(ultraschall.Defer8) else return reaper.defer(ultraschall.deferfunc8), ultraschall.ScriptIdentifier..".defer_script08" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script08")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer8", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script08"
end


function ultraschall.Defer9(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer9</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer9(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09", "running", false)
    if mode==2 then ultraschall.defertimer9=ultraschall.defertimer9+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode9==nil then
    ultraschall.defermode9=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09", "running", false)
  end
  
  if (ultraschall.defermode9==0 or ultraschall.defermode9==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09")=="running" then 
    return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09"
  elseif ultraschall.defermode9==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09")=="running" then
    ultraschall.defertimer9=ultraschall.defertimer9-1
    if ultraschall.defertimer9>0 then reaper.defer(ultraschall.Defer9) else return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09" end
  elseif ultraschall.defermode9==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09")=="running" then
    if ultraschall.defertimer9>reaper.time_precise() then reaper.defer(ultraschall.Defer9) else return reaper.defer(ultraschall.deferfunc9), ultraschall.ScriptIdentifier..".defer_script09" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script09")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer9", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script09"
end


function ultraschall.Defer10(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer10</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer10(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10", "running", false)
    if mode==2 then ultraschall.defertimer10=ultraschall.defertimer10+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode10==nil then
    ultraschall.defermode10=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10", "running", false)
  end
  
  if (ultraschall.defermode10==0 or ultraschall.defermode10==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10")=="running" then 
    return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10"
  elseif ultraschall.defermode10==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10")=="running" then
    ultraschall.defertimer10=ultraschall.defertimer10-1
    if ultraschall.defertimer10>0 then reaper.defer(ultraschall.Defer10) else return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10" end
  elseif ultraschall.defermode10==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10")=="running" then
    if ultraschall.defertimer10>reaper.time_precise() then reaper.defer(ultraschall.Defer10) else return reaper.defer(ultraschall.deferfunc10), ultraschall.ScriptIdentifier..".defer_script10" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script10")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer10", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script10"
end


function ultraschall.Defer11(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer11</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer11(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11", "running", false)
    if mode==2 then ultraschall.defertimer11=ultraschall.defertimer11+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode11==nil then
    ultraschall.defermode11=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11", "running", false)
  end
  
  if (ultraschall.defermode11==0 or ultraschall.defermode11==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11")=="running" then 
    return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11"
  elseif ultraschall.defermode11==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11")=="running" then
    ultraschall.defertimer11=ultraschall.defertimer11-1
    if ultraschall.defertimer11>0 then reaper.defer(ultraschall.Defer11) else return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11" end
  elseif ultraschall.defermode11==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11")=="running" then
    if ultraschall.defertimer11>reaper.time_precise() then reaper.defer(ultraschall.Defer11) else return reaper.defer(ultraschall.deferfunc11), ultraschall.ScriptIdentifier..".defer_script11" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script11")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer11", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script11"
end


function ultraschall.Defer12(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer12</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer12(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12", "running", false)
    if mode==2 then ultraschall.defertimer12=ultraschall.defertimer12+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode12==nil then
    ultraschall.defermode12=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12", "running", false)
  end
  
  if (ultraschall.defermode12==0 or ultraschall.defermode12==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12")=="running" then 
    return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12"
  elseif ultraschall.defermode12==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12")=="running" then
    ultraschall.defertimer12=ultraschall.defertimer12-1
    if ultraschall.defertimer12>0 then reaper.defer(ultraschall.Defer12) else return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12" end
  elseif ultraschall.defermode12==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12")=="running" then
    if ultraschall.defertimer12>reaper.time_precise() then reaper.defer(ultraschall.Defer12) else return reaper.defer(ultraschall.deferfunc12), ultraschall.ScriptIdentifier..".defer_script12" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script12")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer12", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script12"
end


function ultraschall.Defer13(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer13</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer13(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13", "running", false)
    if mode==2 then ultraschall.defertimer13=ultraschall.defertimer13+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode13==nil then
    ultraschall.defermode13=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13", "running", false)
  end
  
  if (ultraschall.defermode13==0 or ultraschall.defermode13==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13")=="running" then 
    return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13"
  elseif ultraschall.defermode13==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13")=="running" then
    ultraschall.defertimer13=ultraschall.defertimer13-1
    if ultraschall.defertimer13>0 then reaper.defer(ultraschall.Defer13) else return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13" end
  elseif ultraschall.defermode13==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13")=="running" then
    if ultraschall.defertimer13>reaper.time_precise() then reaper.defer(ultraschall.Defer13) else return reaper.defer(ultraschall.deferfunc13), ultraschall.ScriptIdentifier..".defer_script13" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script13")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer13", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script13"
end


function ultraschall.Defer14(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer14</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer14(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14", "running", false)
    if mode==2 then ultraschall.defertimer14=ultraschall.defertimer14+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode14==nil then
    ultraschall.defermode14=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14", "running", false)
  end
  
  if (ultraschall.defermode14==0 or ultraschall.defermode14==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14")=="running" then 
    return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14"
  elseif ultraschall.defermode14==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14")=="running" then
    ultraschall.defertimer14=ultraschall.defertimer14-1
    if ultraschall.defertimer14>0 then reaper.defer(ultraschall.Defer14) else return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14" end
  elseif ultraschall.defermode14==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14")=="running" then
    if ultraschall.defertimer14>reaper.time_precise() then reaper.defer(ultraschall.Defer14) else return reaper.defer(ultraschall.deferfunc14), ultraschall.ScriptIdentifier..".defer_script14" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script14")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer14", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script14"
end


function ultraschall.Defer15(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer15</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer15(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15", "running", false)
    if mode==2 then ultraschall.defertimer15=ultraschall.defertimer15+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode15==nil then
    ultraschall.defermode15=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15", "running", false)
  end
  
  if (ultraschall.defermode15==0 or ultraschall.defermode15==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15")=="running" then 
    return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15"
  elseif ultraschall.defermode15==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15")=="running" then
    ultraschall.defertimer15=ultraschall.defertimer15-1
    if ultraschall.defertimer15>0 then reaper.defer(ultraschall.Defer15) else return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15" end
  elseif ultraschall.defermode15==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15")=="running" then
    if ultraschall.defertimer15>reaper.time_precise() then reaper.defer(ultraschall.Defer15) else return reaper.defer(ultraschall.deferfunc15), ultraschall.ScriptIdentifier..".defer_script15" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script15")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer15", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script15"
end


function ultraschall.Defer16(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer16</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer16(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16", "running", false)
    if mode==2 then ultraschall.defertimer16=ultraschall.defertimer16+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode16==nil then
    ultraschall.defermode16=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16", "running", false)
  end
  
  if (ultraschall.defermode16==0 or ultraschall.defermode16==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16")=="running" then 
    return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16"
  elseif ultraschall.defermode16==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16")=="running" then
    ultraschall.defertimer16=ultraschall.defertimer16-1
    if ultraschall.defertimer16>0 then reaper.defer(ultraschall.Defer16) else return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16" end
  elseif ultraschall.defermode16==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16")=="running" then
    if ultraschall.defertimer16>reaper.time_precise() then reaper.defer(ultraschall.Defer16) else return reaper.defer(ultraschall.deferfunc16), ultraschall.ScriptIdentifier..".defer_script16" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script16")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer16", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script16"
end


function ultraschall.Defer17(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer17</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer17(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17", "running", false)
    if mode==2 then ultraschall.defertimer17=ultraschall.defertimer17+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode17==nil then
    ultraschall.defermode17=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17", "running", false)
  end
  
  if (ultraschall.defermode17==0 or ultraschall.defermode17==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17")=="running" then 
    return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17"
  elseif ultraschall.defermode17==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17")=="running" then
    ultraschall.defertimer17=ultraschall.defertimer17-1
    if ultraschall.defertimer17>0 then reaper.defer(ultraschall.Defer17) else return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17" end
  elseif ultraschall.defermode17==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17")=="running" then
    if ultraschall.defertimer17>reaper.time_precise() then reaper.defer(ultraschall.Defer17) else return reaper.defer(ultraschall.deferfunc17), ultraschall.ScriptIdentifier..".defer_script17" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script17")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer17", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script17"
end


function ultraschall.Defer18(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer18</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer18(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18", "running", false)
    if mode==2 then ultraschall.defertimer18=ultraschall.defertimer18+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode18==nil then
    ultraschall.defermode18=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18", "running", false)
  end
  
  if (ultraschall.defermode18==0 or ultraschall.defermode18==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18")=="running" then 
    return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18"
  elseif ultraschall.defermode18==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18")=="running" then
    ultraschall.defertimer18=ultraschall.defertimer18-1
    if ultraschall.defertimer18>0 then reaper.defer(ultraschall.Defer18) else return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18" end
  elseif ultraschall.defermode18==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18")=="running" then
    if ultraschall.defertimer18>reaper.time_precise() then reaper.defer(ultraschall.Defer18) else return reaper.defer(ultraschall.deferfunc18), ultraschall.ScriptIdentifier..".defer_script18" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script18")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer18", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script18"
end


function ultraschall.Defer19(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer19</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer19(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19", "running", false)
    if mode==2 then ultraschall.defertimer19=ultraschall.defertimer19+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode19==nil then
    ultraschall.defermode19=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19", "running", false)
  end
  
  if (ultraschall.defermode19==0 or ultraschall.defermode19==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19")=="running" then 
    return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19"
  elseif ultraschall.defermode19==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19")=="running" then
    ultraschall.defertimer19=ultraschall.defertimer19-1
    if ultraschall.defertimer19>0 then reaper.defer(ultraschall.Defer19) else return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19" end
  elseif ultraschall.defermode19==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19")=="running" then
    if ultraschall.defertimer19>reaper.time_precise() then reaper.defer(ultraschall.Defer19) else return reaper.defer(ultraschall.deferfunc19), ultraschall.ScriptIdentifier..".defer_script19" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script19")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer19", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script19"
end


function ultraschall.Defer20(func, mode, timer_counter)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Defer20</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string defer_identifier = ultraschall.Defer20(function func, optional integer mode, optional number timer_counter)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      runs a custom-defer-cycle, which can be individualized.
      
      You can set, how often this script shall be run(every x defer-cycle or every x seconds) and even stop the defer-cycle from in- and outside of the script, using the defer\_identifier.
      
      Don't run this twice in your script. It you need more than one such defer-cycle, use 

        [Defer1](#Defer1), [Defer2](#Defer2), [Defer3](#Defer3), [Defer4](#Defer4), [Defer5](#Defer5), [Defer6](#Defer6), [Defer7](#Defer7), [Defer8](#Defer8), [Defer9](#Defer9), [Defer10](#Defer10),
        [Defer11](#Defer11), [Defer12](#Defer12), [Defer13](#Defer13), [Defer14](#Defer14), [Defer15](#Defer15), [Defer16](#Defer16), [Defer17](#Defer17), [Defer18](#Defer18), [Defer19](#Defer19), [Defer20](#Defer20)

      where every such defer-instance can be controlled individually, including stopping it.      
      It will return, if the defer-cycle could be started and a defer-identifier, which can be used to stop it from the in/outside of the script-instance.
      
      When this defer-instance is stopped, it will return true, nil, otherwise it will return true, defer\_identifier
      
      To stop such a defer-cycle, use [StopDeferCycle](#StopDeferCycle)
      
      returns false in case of an error (e.g. already 1024 defer-cycles are running in the current script-instance)
    </description>
    <parameters>
      function func - the function, you would love to defer to
      optional integer mode - 0 or nil, just run as regular defer-cycle
                            - 1, run the defer-cycle only every timer_counter-cycle
                            - 2, run the defer-cycle only every timer_counter-seconds
      optional number timer_counter - the timer for the defer-cycle
                                    -   mode=1: 1 and higher, the next defer-cycle that shall be used by function func. Use 1 for every cycle, 2 for every second cycle.
                                    -               30 cycles are approximately 1 second.
                                    -   mode=2: 0 and higher, the amount of seconds to wait, until the function func is run the next time.
    </parameters>
    <retvals>
      boolean retval - true, running this defer-cycle was successful; false, it wasn't successful
      string defer_identifier - an identifier-string, that can be used to stop the defer-cycle
    </retvals>
    <chapter_context>
      Defer-Management
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>defermanagement, defer, timer, defer-cycles, wait, seconds</tags>
  </US_DocBloc>
  ]]  
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
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20", "running", false)
    if mode==2 then ultraschall.defertimer20=ultraschall.defertimer20+reaper.time_precise() end
  elseif mode==nil and ultraschall.defermode20==nil then
    ultraschall.defermode20=0
    reaper.SetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20", "running", false)
  end
  
  if (ultraschall.defermode20==0 or ultraschall.defermode20==nil) and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20")=="running" then 
    return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20"
  elseif ultraschall.defermode20==1 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20")=="running" then
    ultraschall.defertimer20=ultraschall.defertimer20-1
    if ultraschall.defertimer20>0 then reaper.defer(ultraschall.Defer20) else return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20" end
  elseif ultraschall.defermode20==2 and reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20")=="running" then
    if ultraschall.defertimer20>reaper.time_precise() then reaper.defer(ultraschall.Defer20) else return reaper.defer(ultraschall.deferfunc20), ultraschall.ScriptIdentifier..".defer_script20" end
  elseif reaper.GetExtState("ultraschall", ultraschall.ScriptIdentifier..".defer_script20")~="running" then
    return true
  else 
    ultraschall.AddErrorMessage("Defer20", "mode", "no such mode, must be between 0 and 2 or nil", -3)
    return false
  end
  return true, ultraschall.ScriptIdentifier..".defer_script20"
end
