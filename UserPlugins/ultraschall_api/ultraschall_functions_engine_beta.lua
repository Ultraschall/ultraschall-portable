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

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
end

function ultraschall.ApiBetaFunctionsTest()
    ultraschall.functions_beta_works="on"
end

-- Let's create a unique script-identifier
ultraschall.dump=ultraschall.tempfilename:match("%-%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}")
if ultraschall.dump==nil then 
  ultraschall.dump, ultraschall.dump2 = ultraschall.tempfilename:match("(.-)(%..*)")
  if ultraschall.dump2==nil then ultraschall.dump2="" ultraschall.dump=ultraschall.tempfilename end
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump..ultraschall.dump2
  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump.."-"..reaper.genGuid("")..ultraschall.dump2
else  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.tempfilename
end
  ultraschall.ScriptIdentifier=string.gsub(ultraschall.ScriptIdentifier, "\\", "/")
  

function ultraschall.AddErrorMessage(functionname, parametername, errormessage, errorcode)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errorcount = ultraschall.AddErrorMessage(string functionname, string parametername, string errormessage, integer errorcode)</functioncall>
  <description>
    Adds a new errormessage to the Ultraschall-Api-Error-messagesystem. Returns the number of the errormessage.
    Intended for your own 3rd party-functions for the API, to give the user more feedback about errors than just a cryptic errorcode.
    
    returns false in case of failure
  </description>
  <parameters>
    string functionname - the function, where the error happened
    string parametername - the parameter, that caused the problem
    string errormessage - a longer description of what cause the problem and a hint to a possible solution
    integer errorcode - a number, that represents the error-message. Will be -1 by default, if not given.
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    integer errorcount - the number of the errormessage within the Ultraschall-Api-Error-messagesystem
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, add, message</tags>
</US_DocBloc>
]]
  -- check parameters
  if functionname==nil or errormessage==nil then a=false functionname="ultraschall.AddErrorMessage" errormessage="functionname or errormessage is nil. Must contain valid value instead!" end
  ultraschall.ErrorCounter=ultraschall.ErrorCounter+1
  if parametername==nil then parametername="" end
  if type(errorcode)~="number" then errorcode=-1 end
  
  -- let's create the new errormessage
  local ErrorMessage={}
  ErrorMessage["funcname"]=functionname
  ErrorMessage["errmsg"]=errormessage
  ErrorMessage["readstate"]="unread"
  ErrorMessage["date"]=os.date()
  ErrorMessage["time"]=os.time()
  ErrorMessage["parmname"]=parametername
  ErrorMessage["errcode"]=errorcode
  
  -- add it to the error-message-system
  ultraschall.ErrorMessage[ultraschall.ErrorCounter]=ErrorMessage
  
  if ultraschall.ShowErrorInReaScriptConsole==true then print("Function: "..functionname.."\n   Parameter: "..parametername.."\n   Error: "..errorcode.." - \""..errormessage.."\"\n   Errortime: "..ErrorMessage["date"].."\n") end
  
  -- terminate script with Lua-errormessage
  if ultraschall.IDEerror==true then error(functionname..":"..errormessage,3) end
  if a==false then return false
  else return true, ultraschall.ErrorCounter
  end
end


--ultraschall.ShowErrorMessagesInReascriptConsole(true)

--ultraschall.WriteValueToFile()

--ultraschall.AddErrorMessage("func","parm","desc",2)

function ultraschall.SplitStringAtNULLBytes(splitstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitStringAtNULLBytes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    Lua=5.3
  </requires>
  <functioncall>integer count, array split_strings = ultraschall.SplitStringAtNULLBytes(string splitstring)</functioncall>
  <description>
    Splits splitstring into individual string at NULL-Bytes.
  </description>
  <retvals>
    integer count - the number of found strings
    array split_strings - the found strings put into an array
  </retvals>
  <parameters>
    string splitstring - the string with NULL-Bytes(\0) into it, that you want to split
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, split, string, nullbytes</tags>
</US_DocBloc>
]]
  if type(splitstring)~="string" then ultraschall.AddErrorMessage("SplitStringAtNULLBytes", "splitstring", "Must be a string.", -1) return -1 end
  -- add a NULL-Byte at the end, helps us finding the end of the string later
  splitstring=splitstring.."\0"
  local count=0
  local strings={}
  local temp, offset
  
  -- let's split the string
  while splitstring~=nil do
    -- find the next string-part
    temp,offset=splitstring:match("(.-)()\0")    
    if temp~=nil then 
      -- if the next found string isn't nil, then add it fo strings-array and count+1
      count=count+1 
      strings[count]=temp
      splitstring=splitstring:sub(offset+1,-1)
      --reaper.MB(splitstring:len(),"",0)
    else 
      -- if temp is nil, the string is probably finished splitting
      break 
    end
  end
  return count, strings
end

--A2,B2=ultraschall.SplitStringAtNULLBytes("splitstrin\0g\0\0\0\0")

function ultraschall.RunBackgroundHelperFeatures(switch_on)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RunBackgroundHelperFeatures</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RunBackgroundHelperFeatures(boolean switch_on)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Starts background-scripts supplied with the Ultraschall-API, like:  

      - a script for getting the last edit-cursor-position before the current one -> [GetLastCursorPosition()](#GetLastCursorPosition)
      - a script for getting the last playstate before the current one -> [GetLastPlayState()](#GetLastPlayState)
      - a script for getting the last loopstate before the current one -> [GetLastLoopState()](#GetLastLoopState)
  </description>
  <parameters>
    boolean switch_on - true, start the background-scripts/start unstarted background-helper-scripts; false, stop all background-helper-scripts
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, defer scripts, background scripts</tags>
</US_DocBloc>
]]
  local filecount, files = ultraschall.GetAllFilenamesInPath(ultraschall.Api_Path.."/Scripts/HelperDeferScripts/")
  local filename
  for i=1, filecount do
    filename=files[i]:match(".*/(.*)")
    if filename==nil then filename=files[i]:match(".*\\(.*)") end
    if filename==nil then filename=files[i] end
    if reaper.GetExtState("Ultraschall", "defer_scripts_"..filename)~="true" and switch_on~=false then
      local A=reaper.AddRemoveReaScript(true, 0, files[i], false)
      reaper.Main_OnCommand(A,0)
      local B=reaper.AddRemoveReaScript(false, 0, files[i], false)
    end
    if reaper.GetExtState("Ultraschall", "defer_scripts_"..filename)=="true" and switch_on==false then
        reaper.SetExtState("Ultraschall", "defer_scripts_"..filename, "false", false)
    end
  end
end

--ultraschall.RunBackgroundHelperFeatures()

function ultraschall.GetLastCursorPosition()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastCursorPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number last_editcursor_position, number new_editcursor_position, number statechangetime = ultraschall.GetLastCursorPosition()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last and current editcursor-position. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    number last_editcursor_position - the last cursorposition before the current one; -1, in case of an error
    number new_editcursor_position - the new cursorposition; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>navigation, last position, editcursor</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_cursorposition.lua")~="true" then return -1 end
  return tonumber(reaper.GetExtState("ultraschall", "editcursor_position_old")), tonumber(reaper.GetExtState("ultraschall", "editcursor_position_new")), tonumber(reaper.GetExtState("ultraschall", "editcursor_position_changetime"))
end

function ultraschall.GetLastPlayState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastPlayState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string last_play_state, string new_play_state, number statechangetime = ultraschall.GetLastPlayState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last and current playstate. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    possible states are STOP, PLAY, PLAYPAUSE, REC, RECPAUSE
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    string last_play_state - the last playstate before the current one; -1, in case of an error
    string new_play_state - the new playstate; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>navigation, last playstate, editcursor</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_playstate.lua")~="true" then return -1 end
  return reaper.GetExtState("ultraschall", "playstate_old"), reaper.GetExtState("ultraschall", "playstate_new"), tonumber(reaper.GetExtState("ultraschall", "playstate_changetime"))
end
--ultraschall.RunBackgroundHelperFeatures()
--A=ultraschall.GetLastPlayState()

function ultraschall.GetLastLoopState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string last_loop_state, string new_loop_state, number statechangetime = ultraschall.GetLastLoopState()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the last and current loopstate. Needs Ultraschall-API-background-scripts started first, see [RunBackgroundHelperFeatures()](#RunBackgroundHelperFeatures).
    
    Possible states are LOOPED, UNLOOPED
    
    returns -1, if Ultraschall-API-backgroundscripts weren't started yet.
  </description>
  <retvals>
    string last_loop_state - the last loopstate before the current one; -1, in case of an error
    string new_loop_state - the current loopstate; -1, in case of an error
    number statechangetime - the time, when the state has changed the last time
  </retvals>
  <chapter_context>
    Navigation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>navigation, last loopstate, editcursor</tags>
</US_DocBloc>
]]
  if reaper.GetExtState("Ultraschall", "defer_scripts_ultraschall_track_old_loopstate.lua")~="true" then return -1 end
  return reaper.GetExtState("ultraschall", "loopstate_old"), reaper.GetExtState("ultraschall", "loopstate_new"), tonumber(reaper.GetExtState("ultraschall", "loopstate_changetime"))
end


function ultraschall.Main_OnCommandByFilename(filename, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Main_OnCommandByFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string script_identifier = ultraschall.Main_OnCommandByFilename(string filename, string ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Runs a command by a filename. It internally registers the file temporarily as command, runs it and unregisters it again.
    This is especially helpful, when you want to run a command for sure without possible command-id-number-problems.
    
    It returns a unique script-identifier for this script, which can be used to communicate with this script-instance.
    The started script gets its script-identifier using [GetScriptIdentifier](#GetScriptIdentifier).
    You can use this script-identifier e.g. as extstate.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running it was successful; false, if not
    string script_identifier - a unique script-identifier, which can be used as extstate to communicate with the started scriptinstance
  </retvals>
  <parameters>
    string filename - the name and path of the scriptfile to run
    string ... - parameters that shall be passed over to the script
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, run command, filename, scriptidentifier, scriptparameters</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(filename)~="string" then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "Must be a string.", -1) return false end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "File does not exist.", -2) return false end
 
  -- create temporary copy of the scriptfile, with a guid in its name
  local filename2=filename:match("(.*)%.")
  if filename2==nil then filename2=filename.."-"..reaper.genGuid() else filename2=filename2.."-"..reaper.genGuid()..filename:match("(%..*)") end
  ultraschall.MakeCopyOfFile(filename, filename2)

  -- register, run and unregister the temporary scriptfile  
  local commandid=reaper.AddRemoveReaScript(true, 0, filename2, true)
  if commandid==0 then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "Couldn't register filename. Is it a valid ReaScript?.", -3) return false end
  ultraschall.SetScriptParameters(string.gsub("ScriptIdentifier:"..filename2, "\\", "/"), ...)
  reaper.Main_OnCommand(commandid, 0)
  local commandid2=reaper.AddRemoveReaScript(false, 0, filename2, true)
  
  -- delete the temporary scriptfile
  os.remove(filename2)
  
  -- return true and the script-identifier of the started script
  return true, string.gsub("ScriptIdentifier:"..filename2, "\\", "/")
end

--reaper.MB("Hui: "..tostring(ultraschall.tempfilename:match("%-")),ultraschall.tempfilename:sub(50,-1),0) -- %-%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}")),"",0)
--if ultraschall.tempfilename:match("%-%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}")~=nil then reaper.MB("","zusido",0) else reaper.MB("Oh", "",0) end
--ultraschall.ScriptIdentifier="HULA"

--reaper.MB(ultraschall.ScriptIdentifier,"",0)

--A=ultraschall.GetReaperScriptPath().."/testscript_that_displays_stuff.lua"
--A=ultraschall.GetReaperScriptPath().."/us.png"
--B,C=ultraschall.Main_OnCommandByFilename(A)
--reaper.CF_SetClipboard(C.." "..ultraschall.ScriptIdentifier)



function ultraschall.MIDI_OnCommandByFilename(filename, MIDIEditor_HWND, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MIDI_OnCommandByFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string script_identifier = ultraschall.MIDI_OnCommandByFilename(string filename, optional HWND Midi_EditorHWND, string ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Runs a command by a filename in the MIDI-editor-context. It internally registers the file temporarily as command, runs it and unregisters it again.
    This is especially helpful, when you want to run a command for sure without possible command-id-number-problems.
    
    It returns a unique script-identifier for this script, which can be used to communicate with this script-instance.
    The started script gets its script-identifier using [GetScriptIdentifier](#GetScriptIdentifier).
    You can use this script-identifier e.g. as extstate.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running it was successful; false, if not
    string script_identifier - a unique script-identifier, which can be used as extstate to communicate with the started scriptinstance
  </retvals>
  <parameters>
    HWND Midi_EditorHWND - the window-handler of the MIDI-editor, in which to run the script; nil, for the last active MIDI-editor
    string filename - the name plus path of the scriptfile to run
    string ... - parameters, that shall be passed over to the script
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, run command, filename, midi, midieditor, scriptidentifier, scriptparameters</tags>
</US_DocBloc>
]]
  -- check parameters and MIDI-Editor
  if type(filename)~="string" then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "filename", "Must be a string.", -1) return false end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "filename", "File does not exist.", -2) return false end
  if MIDIEditor_HWND~=nil then
    if pcall(reaper.JS_Window_GetTitle, MIDIEditor_HWND, "")==false then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "MIDIEditor_HWND", "Not a valid HWND.", -3) return false end
    if pcall(reaper.JS_Window_GetTitle(MIDIEditor_HWND, ""):match("MIDI"))==false then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "MIDIEditor_HWND", "Not a valid MIDI-Editor-HWND.", -4) return false end
  end  

  -- create temporary scriptcopy with a guid in its filename
  local filename2=filename:match("(.*)%.")
  if filename2==nil then filename2=filename.."-"..reaper.genGuid() else filename2=filename2.."-"..reaper.genGuid()..filename:match("(%..*)") end
  ultraschall.MakeCopyOfFile(filename, filename2)
  
  -- register and run the temporary-scriptfile
  local commandid =reaper.AddRemoveReaScript(true, 32060, filename2, true)
  local commandid2=reaper.AddRemoveReaScript(true, 32061, filename2, true)
  local commandid3=reaper.AddRemoveReaScript(true, 32062, filename2, true)
  if commandid==0 then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "filename", "Couldn't register filename. Is it a valid ReaScript?.", -5) return false end
  if MIDIEditor_HWND==nil then 
    ultraschall.SetScriptParameters(string.gsub("ScriptIdentifier:"..filename2, "\\", "/"), ...)
    local A2=reaper.MIDIEditor_LastFocused_OnCommand(commandid, true)
    if A2==false then A2=reaper.MIDIEditor_LastFocused_OnCommand(commandid, false) end
    if A2==false then 
      ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "MIDIEditor_HWND", "No last focused MIDI-Editor open.", -6) 
      ultraschall.GetScriptParameters(string.gsub("ScriptIdentifier:"..filename2, "\\", "/"), true)
      return false 
    end
  end
  local L=reaper.MIDIEditor_OnCommand(MIDIEditor_HWND, commandid)
  
  -- unregister the temporary-scriptfile
  local commandid_2=reaper.AddRemoveReaScript(false, 32060, filename2, true)
  local commandid_3=reaper.AddRemoveReaScript(false, 32061, filename2, true)
  local commandid_4=reaper.AddRemoveReaScript(false, 32062, filename2, true)
  
  -- delete the temporary scriptfile and return true and the script-identifier for the started script
  os.remove(filename2)
  return true, string.gsub("ScriptIdentifier:"..filename2, "\\", "/")
end

--A=ultraschall.GetReaperScriptPath().."/testscript_that_displays_stuff.lua"
--AAA=ultraschall.MIDI_OnCommandByFilename(reaper.MIDIEditor_GetActive(), A)
--AAA=ultraschall.MIDI_OnCommandByFilename(A, reaper.MIDIEditor_GetActive())
--reaper.MB("","",0)
--AAA2,AAA3=ultraschall.MIDI_OnCommandByFilename(A, reaper.MIDIEditor_GetActive())
--reaper.ShowConsoleMsg(AAA3.." - outside\n")

function ultraschall.GetScriptParameters(script_identifier, remove)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScriptParameters</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer num_params, array params, string caller_script_identifier = ultraschall.GetScriptParameters(optional string script_identifier, optional boolean remove)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the parameters stored for a specific script_identifier.
  </description>
  <retvals>
    integer num_params - the number of parameters available
    array params - the values of the parameters as an array
    string caller_script_identifier - the scriptidentifier of the script, that set the parameters
  </retvals>
  <parameters>
    optional string script_identifier - the script-identifier, whose parameters you want to retrieve; 
                             - use nil, to get the parameters stored for the current script
    optional boolean remove - true or nil, remove the stored parameter-extstates; false, keep them for later retrieval
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, script, parameters, scriptidentifier</tags>
</US_DocBloc>
]]
  if script_identifier==nil or type(script_identifier)~="string" then script_identifier=ultraschall.ScriptIdentifier end
  local counter=1
  local parms={}
  while reaper.GetExtState(script_identifier, "parm_"..counter)~="" do
    parms[counter]=reaper.GetExtState(script_identifier, "parm_"..counter)
    if remove==true then
      reaper.DeleteExtState(script_identifier, "parm_"..counter, false)
    end
    counter=counter+1
  end
  local caller_script=reaper.GetExtState(script_identifier, "parm_0")
  if remove==true or remove==nil then reaper.DeleteExtState(script_identifier, "parm_0", false) end
  return counter-1, parms, caller_script
end


function ultraschall.SetScriptParameters(script_identifier, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetScriptParameters</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string script_identifier = ultraschall.SetScriptParameters(string script_identifier, string ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the parameters stored for a specific script_identifier.
  </description>
  <retvals>
    boolean retval - true, storing was successful
    string script_identifier - the script_identifier, whose parameters have been set
  </retvals>
  <parameters>
    string script_identifier - the script-identifier, whose parameters you want to retrieve; 
                             - use nil, to set the parameters stored for the current script
    string ... - the parameters you want to set; there can be more than one, but they must be strings
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, script, parameters, scriptidentifier</tags>
</US_DocBloc>
]]
  if script_identifier==nil or type(script_identifier)~="string" then script_identifier=ultraschall.ScriptIdentifier end
  local parms={...}
  local counter=1
  reaper.SetExtState(script_identifier, "parm_0", ultraschall.ScriptIdentifier, false)
  while parms[counter]~=nil do
    reaper.SetExtState(script_identifier, "parm_"..counter, tostring(parms[counter]), false)
    counter=counter+1
  end
  return true, script_identifier
end

--C=ultraschall.SetScriptParameters(script_identifier, 1,2,3,4,5,6,5,4,3,2,1)

--A,B=ultraschall.GetScriptParameters(script_identifier, true)


function ultraschall.GetScriptReturnvalues(script_identifier, remove)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScriptReturnvalues</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer num_params, array retvals, string caller_script_identifier = ultraschall.GetScriptReturnvalues(optional string script_identifier, optional boolean remove)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the return-values stored by a specific script_identifier for the current script.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer num_retvals - the number of return-values available
    array params - the values of the return-values as an array
    string caller_script_identifier - the scriptidentifier of the script, that set the return-values
  </retvals>
  <parameters>
    optional string script_identifier - the script-identifier, whose return-values you want to retrieve; 
    optional boolean remove - true or nil, remove the stored retval-extstates; false, keep them for later retrieval
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, script, returnvalues, scriptidentifier</tags>
</US_DocBloc>
]]
  if type(script_identifier)~="string" then ultraschall.AddErrorMessage("GetScriptReturnvalues", "must be a string", -1) return -1 end
  local counter=1
  local retvals={}
  while reaper.GetExtState(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter)~="" do
    retvals[counter]=reaper.GetExtState(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter)
    if remove==true or remove==nil then
      reaper.DeleteExtState(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter, false)
      local retval_identifier = reaper.GetExtState(script_identifier, "retval_sender_identifier")
      retval_identifier = string.gsub(retval_identifier, script_identifier.."\n", "")      
      if retval_identifier:match(ultraschall.ScriptIdentifier)==nil then
        reaper.SetExtState(script_identifier, "retval_sender_identifier", retval_identifier, false)
      end
    end
    counter=counter+1
  end
  return counter-1, retvals
end


function ultraschall.SetScriptReturnvalues(script_identifier, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetScriptReturnvalues</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetScriptReturnvalues(string script_identifier, string ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Send return-values back to the script, that has a specific script_identifier.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, storing was successful; false, there was an error
  </retvals>
  <parameters>
    string script_identifier - the script-identifier of the script-instance, to where you want to send the returnvalues 
    string ... - the returnvalues you want to set; there can be more than one, but they must be strings
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, script, returnvalues, scriptidentifier</tags>
</US_DocBloc>
]]
  if type(script_identifier)~="string" then ultraschall.AddErrorMessage("SetScriptReturnvalues", "must be a string", -1) return false end
  local retvals={...}
  local counter=1
  local retval_identifier = reaper.GetExtState(script_identifier, "retval_sender_identifier")
  if retval_identifier:match(ultraschall.ScriptIdentifier)==nil then
    reaper.SetExtState(script_identifier, "retval_sender_identifier", retval_identifier..ultraschall.ScriptIdentifier.."\n", false)
  end
  while retvals[counter]~=nil do
    reaper.SetExtState(script_identifier, ultraschall.ScriptIdentifier.."_retval_"..counter, tostring(retvals[counter]), false)
    counter=counter+1
  end
  return true
end

--ultraschall.SetScriptReturnvalues("Empfänger", 9,222,3,4,5,6,7,8,9,10)
--A,B,C,D,E=ultraschall.GetScriptReturnvalues("Empfänger", true)

--ultraschall.ScriptIdentifier="HalloWelt5"
--ultraschall.SetScriptReturnvalues("HalloWelt5", 9,222,3,4,5,6,7,8,9,10)

function ultraschall.GetScriptReturnvalues_Sender()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScriptReturnvalues_Sender</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer count, array retval_sender = ultraschall.GetScriptReturnvalues_Sender()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Retrieves, which scripts send returnvalues to the current script.
  </description>
  <retvals>
    integer count - the number of scripts, who have left returnvalues for the current script
    array retval_sender - the ScriptIdentifier of the scripts, who returned values
  </retvals>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, script, returnvalues, scriptidentifier, child scripts</tags>
</US_DocBloc>
]]
  local val=reaper.GetExtState(ultraschall.ScriptIdentifier, "retval_sender_identifier"):match("(.*)\n")
  if val==nil then return 0 end
  local count, array = ultraschall.SplitStringAtLineFeedToArray(val)
  return count, array
end

--A,B=ultraschall.GetScriptReturnvalues_Sender()

--C,D,E=ultraschall.GetScriptReturnvalues("HalloWelt5")

--A1,B1=ultraschall.GetScriptReturnvalues_Sender()



function ultraschall.IsValidHWND(HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidHWND(HWND hwnd)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Checks, if a HWND-handler is a valid one.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running it was successful; false, if not
  </retvals>
  <parameters>
    HWND hwnd - the HWND-handler to check for
  </parameters>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, hwnd, is valid, check</tags>
</US_DocBloc>
]]
  if pcall(reaper.JS_Window_GetTitle, HWND, "")==false then ultraschall.AddErrorMessage("IsValidHWND", "HWND", "Not a valid HWND.", -1) return false end
  return true
end

--AAA=ultraschall.IsValidHWND(reaper.Splash_GetWnd("tudelu",nil))

--AAAAA=reaper.MIDIEditor_LastFocused_OnCommand(1)

function ultraschall.GetPath(str,sep)
-- return the path of a filename-string
-- -1 if it doesn't work
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string path, string filename = ultraschall.GetPath(string str, optional string sep)</functioncall>
  <description>
    returns the path of a filename-string
    
    returns "", "" in case of error 
  </description>
  <retvals>
    string path  - the path as a string
    string filename - the filename, without the path
  </retvals>
  <parameters>
    string str - the path with filename you want to process
    string sep - a separator, with which the function knows, how to separate filename from path; nil to use the last useful separator in the string, which is either / or \\
  </parameters>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,path,separator</tags>
</US_DocBloc>
--]]

  -- check parameters
  if type(str)~="string" then ultraschall.AddErrorMessage("GetPath","str", "only a string allowed", -1) return "", "" end
  if sep~=nil and type(sep)~="string" then ultraschall.AddErrorMessage("GetPath","sep", "only a string allowed", -2) return "", "" end
  
  -- do the patternmatching
  local result, file

--  if result==nil then ultraschall.AddErrorMessage("GetPath","", "separator not found", -3) return "", "" end
--  if file==nil then file="" end
  if sep~=nil then 
    result=str:match("(.*"..sep..")")
    file=str:match(".*"..sep.."(.*)")
    if result==nil then ultraschall.AddErrorMessage("GetPath","", "separator not found", -3) return "", "" end
  else
    result=str:match("(.*".."[\\/]"..")")
    file=str:match(".*".."[\\/]".."(.*)")
  end
  return result, file
end

--B1,B2=ultraschall.GetPath("c:\\nillimul/\\test.kl", "\\")


function ultraschall.BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>BrowseForOpenFiles</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>string path, integer number_of_files, array filearray = ultraschall.BrowseForOpenFiles(string windowTitle, string initialFolder, string initialFile, string extensionList, boolean allowMultiple)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Opens a filechooser-dialog which optionally allows selection of multiple files.
    Unlike Reaper's own GetUserFileNameForRead, this dialog allows giving non-existant files as well(for saving operations).
    
    Returns nil in case of an error
  </description>
  <retvals>
    string path - the path, in which the selected file(s) lie; nil, in case of an error; "" if no file was selected
    integer number_of_files - the number of files selected; 0, if no file was selected
    array filearray - an array with all the selected files
  </retvals>
  <parameters>
    string windowTitle - the title shown in the filechooser-dialog
    string initialFolder - the initial-folder opened in the filechooser-dialog
    string initialFile - the initial-file selected in the filechooser-dialog, good for giving default filenames
    string extensionList - a list of extensions that can be selected in the selection-list.
                         - the list has the following structure(separate the entries with a \0): 
                         -       "description of type1\0type1\0description of type 2\0type2\0"
                         - the description of type can be anything that describes the type(s), 
                         - to define one type, write: *.ext 
                         - to define multiple types, write: *.ext;*.ext2;*.ext3
                         - the extensionList must end with a \0
    boolean allowMultiple - true, allows selection of multiple files; false, only allows selection of single files
  </parameters>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, dialog, file, chooser, multiple</tags>
</US_DocBloc>
]]
  if type(windowTitle)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "windowTitle",   "Must be a string.",  -1) return nil end  
  if type(initialFolder)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "initialFolder", "Must be a string.",  -2) return nil end  
  if type(initialFile)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "initialFile",   "Must be a string.",  -3) return nil end  
  if type(extensionList)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "extensionList", "Must be a string.",  -4) return nil end  
  if type(allowMultiple)~="boolean" then ultraschall.AddErrorMessage("BrowseForOpenFiles", "allowMultiple", "Must be a boolean.", -5) return nil end  
  
  local retval, fileNames = reaper.JS_Dialog_BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple)
  local path, filenames, count
  if allowMultiple==true then
    count, filenames = ultraschall.SplitStringAtNULLBytes(fileNames)
    path = filenames[1]
    table.remove(filenames,1)
  else
    filenames={}
    path, filenames[1]=ultraschall.GetPath(fileNames)
    count=2
  end
  if retval==0 then path="" count=1 filenames={} end
  return path, count-1, filenames
end

--A,B,C=ultraschall.BrowseForOpenFiles("Tudelu", "c:\\", "", "", true)

--A,B,C=reaper.JS_Dialog_BrowseForOpenFiles("Tudelu", "", "", "", false)

function ultraschall.CloseReaConsole()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CloseReaConsole</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CloseReaConsole()</functioncall>
  <description>
    Closes the ReaConsole-window, if opened.
    
    Note for Mac-users: does not work currently on MacOS.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if there is a mute-point; false, if there isn't one
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, reaconsole, close</tags>
</US_DocBloc>
]]
  local retval,Adr=reaper.JS_Window_ListFind("ReaScript console output", true)

  if retval>1 then ultraschall.AddErrorMessage("CloseReaConsole", "", "Multiple windows are open, that are named \"ReaScript console output\". Can't find the right one, sorry.", -1) return false end
  if retval==0 then ultraschall.AddErrorMessage("CloseReaConsole", "", "ReaConsole-window not opened", -2) return false end
  local B=reaper.JS_Window_HandleFromAddress(Adr)
  reaper.JS_Window_Destroy(B)
  return true
end

--reaper.ShowConsoleMsg("Tudelu")
--LL,LL=ultraschall.CloseReaConsole()

function ultraschall.GetApiVersion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetApiVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string version, string date, string beta, number versionnumber, string tagline = ultraschall.GetApiVersion()</functioncall>
  <description>
    returns the version, release-date and if it's a beta-version plus the currently installed hotfix
  </description>
  <retvals>
    string version - the current Api-version
    string date - the release date of this api-version
    string beta - if it's a beta version, this is the beta-version-number
    number versionnumber - a number, that you can use for comparisons like, "if requestedversion>versionnumber then"
    string tagline - the tagline of the current release
    string hotfix_date - the release-date of the currently installed hotfix ($ResourceFolder/ultraschall_api/ultraschall_hotfixes.lua)
  </retvals>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>version,versionmanagement</tags>
</US_DocBloc>
--]]
  return "4.00","14th of February 2019", "Beta 2.71", 400.0271,  "\"Blue Oyster Cult - Don't fear the Reaper\"", ultraschall.hotfixdate
end

--A,B,C,D,E,F,G,H,I=ultraschall.GetApiVersion()

function ultraschall.Base64_Encoder(source_string, base64_type, remove_newlines, remove_tabs)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Base64_Encoder</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string encoded_string = ultraschall.Base64_Encoder(string source_string, optional integer base64_type, optional integer remove_newlines, optional integer remove_tabs)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts a string into a Base64-Encoded string. 
    Currently, only standard Base64-encoding is supported.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string encoded_string - the encoded string
  </retvals>
  <parameters>
    string source_string - the string that you want to convert into Base64
    optional integer base64_type - the Base64-decoding-style
                                 - nil or 0, for standard default Base64-encoding
    optional integer remove_newlines - 1, removes \n-newlines(including \r-carriage return) from the string
                                     - 2, replaces \n-newlines(including \r-carriage return) from the string with a single space
    optional integer remove_tabs     - 1, removes \t-tabs from the string
                                     - 2, replaces \t-tabs from the string with a single space
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, encode, base64, string</tags>
</US_DocBloc>
]]
  -- Not to myself:
  -- When you do the decoder, you need to take care, that the bitorder must be changed first, before creating the final-decoded characters
  -- that means: reverse the process of the "tear apart the source-string into bits"-code-passage
  
  -- check parameters and prepare variables
  if type(source_string)~="string" then ultraschall.AddErrorMessage("Base64_Encoder", "source_string", "must be a string", -1) return nil end
  if remove_newlines~=nil and math.type(remove_newlines)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "remove_newlines", "must be an integer", -2) return nil end
  if remove_tabs~=nil and math.type(remove_tabs)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "remove_tabs", "must be an integer", -3) return nil end
  if base64_type~=nil and math.type(base64_type)~="integer" then ultraschall.AddErrorMessage("Base64_Encoder", "base64_type", "must be an integer", -4) return nil end
  
  local tempstring={}
  local a=1
  local temp
  
  -- this is probably the future space for more base64-encoding-schemes
  local base64_string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    
  -- if source_string is multiline, get rid of \r and replace \t and \n with a single whitespace
  if remove_newlines==1 then
    source_string=string.gsub(source_string, "\n", "")
    source_string=string.gsub(source_string, "\r", "")
  elseif remove_newlines==2 then
    source_string=string.gsub(source_string, "\n", " ")
    source_string=string.gsub(source_string, "\r", "")  
  end

  if remove_tabs==1 then
    source_string=string.gsub(source_string, "\t", "")
  elseif remove_tabs==2 then 
    source_string=string.gsub(source_string, "\t", " ")
  end
  
  
  -- tear apart the source-string into bits
  -- bitorder of bytes will be reversed for the later parts of the conversion!
  for i=1, source_string:len() do
    temp=string.byte(source_string:sub(i,i))
    temp=temp
    if temp&1==0 then tempstring[a+7]=0 else tempstring[a+7]=1 end
    if temp&2==0 then tempstring[a+6]=0 else tempstring[a+6]=1 end
    if temp&4==0 then tempstring[a+5]=0 else tempstring[a+5]=1 end
    if temp&8==0 then tempstring[a+4]=0 else tempstring[a+4]=1 end
    if temp&16==0 then tempstring[a+3]=0 else tempstring[a+3]=1 end
    if temp&32==0 then tempstring[a+2]=0 else tempstring[a+2]=1 end
    if temp&64==0 then tempstring[a+1]=0 else tempstring[a+1]=1 end
    if temp&128==0 then tempstring[a]=0 else tempstring[a]=1 end
    a=a+8
  end
  
  -- now do the encoding
  local encoded_string=""
  local temp2=0
  
  -- take six bits and make a single integer-value off of it
  -- after that, use this integer to know, which place in the base64_string must
  -- be read and included into the final string "encoded_string"
  for i=0, a-2, 6 do
    temp2=0
    if tempstring[i+1]==1 then temp2=temp2+32 end
    if tempstring[i+2]==1 then temp2=temp2+16 end
    if tempstring[i+3]==1 then temp2=temp2+8 end
    if tempstring[i+4]==1 then temp2=temp2+4 end
    if tempstring[i+5]==1 then temp2=temp2+2 end
    if tempstring[i+6]==1 then temp2=temp2+1 end
    encoded_string=encoded_string..base64_string:sub(temp2+1,temp2+1)
  end

  -- if the number of characters in the encoded_string isn't exactly divideable 
  -- by 3, add = to fill up missing bytes
  if encoded_string:len()%3==1 then encoded_string=encoded_string.."=="
  elseif encoded_string:len()%3==2 then encoded_string=encoded_string.."="
  end
  
  return encoded_string
end


--A=ultraschall.Base64_Encoder("Man is", 9, 9, 9)

function ultraschall.Base64_Decoder(source_string, base64_type)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Base64_Decoder</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string decoded_string = ultraschall.Base64_Decoder(string source_string, optional integer base64_type)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts a Base64-encoded string into a normal string. 
    Currently, only standard Base64-encoding is supported.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string decoded_string - the decoded string
  </retvals>
  <parameters>
    string source_string - the Base64-encoded string
    optional integer base64_type - the Base64-decoding-style
                                 - nil or 0, for standard default Base64-encoding
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, decode, base64, string</tags>
</US_DocBloc>
]]
  if type(source_string)~="string" then ultraschall.AddErrorMessage("Base64_Decoder", "source_string", "must be a string", -1) return nil end
  if base64_type~=nil and math.type(base64_type)~="integer" then ultraschall.AddErrorMessage("Base64_Decoder", "base64_type", "must be an integer", -2) return nil end
  
  -- this is probably the place for other types of base64-decoding-stuff  
  local base64_string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  
  
  -- remove =
  source_string=string.gsub(source_string,"=","")

  local L=source_string:match("[^"..base64_string.."]")
  if L~=nil then ultraschall.AddErrorMessage("Base64_Decoder", "source_string", "no valid Base64-string: invalid characters", -3) return nil end
  
  -- split the string into bits
  local bitarray={}
  local count=1
  local temp
  for i=1, source_string:len() do
    temp=base64_string:match(source_string:sub(i,i).."()")-2
    if temp&32~=0 then bitarray[count]=1 else bitarray[count]=0 end
    if temp&16~=0 then bitarray[count+1]=1 else bitarray[count+1]=0 end
    if temp&8~=0 then bitarray[count+2]=1 else bitarray[count+2]=0 end
    if temp&4~=0 then bitarray[count+3]=1 else bitarray[count+3]=0 end
    if temp&2~=0 then bitarray[count+4]=1 else bitarray[count+4]=0 end
    if temp&1~=0 then bitarray[count+5]=1 else bitarray[count+5]=0 end
    count=count+6
  end
  
  -- combine the bits into the original bytes and put them into decoded_string
  local decoded_string=""
  local temp2=0
  for i=0, count-1, 8 do
    temp2=0
    if bitarray[i+1]==1 then temp2=temp2+128 end
    if bitarray[i+2]==1 then temp2=temp2+64 end
    if bitarray[i+3]==1 then temp2=temp2+32 end
    if bitarray[i+4]==1 then temp2=temp2+16 end
    if bitarray[i+5]==1 then temp2=temp2+8 end
    if bitarray[i+6]==1 then temp2=temp2+4 end
    if bitarray[i+7]==1 then temp2=temp2+2 end
    if bitarray[i+8]==1 then temp2=temp2+1 end
    decoded_string=decoded_string..string.char(temp2)
  end
  return decoded_string
end

--O=ultraschall.Base64_Decoder("VHV0YXNzc0z=")

function ultraschall.MB(msg,title,mbtype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MB</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MB(string msg, optional string title, optional integer type)</functioncall>
  <description>
    Shows Messagebox with user-clickable buttons. Works like reaper.MB() but unlike reaper.MB, this function accepts omitting some parameters for quicker use.
    
    Returns -1 in case of an error
  </description>
  <parameters>
    string msg - the message, that shall be shown in messagebox
    optional string title - the title of the messagebox
    optional integer type - which buttons shall be shown in the messagebox
                            - 0, OK
                            - 1, OK CANCEL
                            - 2, ABORT RETRY IGNORE
                            - 3, YES NO CANCEL
                            - 4, YES NO
                            - 5, RETRY CANCEL
                            - nil, defaults to OK
  </parameters>
  <retvals>
    integer - the button pressed by the user
                           - -1, error while executing this function
                           - 1, OK
                           - 2, CANCEL
                           - 3, ABORT
                           - 4, RETRY
                           - 5, IGNORE
                           - 6, YES
                           - 7, NO
  </retvals>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, user, interface, input, dialog, messagebox</tags>
</US_DocBloc>
--]]
--  if type(msg)~="string" then ultraschall.AddErrorMessage("MB","msg", "Must be a string!", -1) return -1 end
  msg=tostring(msg)
  if type(title)~="string" then title="" end
  if math.type(mbtype)~="integer" then mbtype=0 end
  if mbtype<0 or mbtype>5 then ultraschall.AddErrorMessage("MB","mbtype", "Must be between 0 and 5!", -2) return -1 end
  reaper.MB(msg, title, mbtype)
end
--ultraschall.MB(reaper.GetTrack(0,0))

function ultraschall.CreateValidTempFile(filename_with_path, create, suffix, retainextension)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateValidTempFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string tempfilename = ultraschall.CreateValidTempFile(string filename_with_path, boolean create, string suffix, boolean retainextension)</functioncall>
  <description>
    Tries to determine a valid temporary filename. Will check filename_with_path with an included number between 0 and 16384 to create such a filename.
    You can also add your own suffix to the filename.
    
    The pattern is: filename_with_path$Suffix~$number.ext (when retainextension is set to true!)
    
    If you wish, you can also create this temporary-file as an empty file.
    
    The path of the tempfile is always the same as the original file.
    
    Returns nil in case of failure.
  </description>
  <retvals>
    string tempfilename - the valid temporary filename found
  </retvals>
  <parameters>
    string filename_with_path - the original filename
    boolean create - true, if you want to create that temporary file as an empty file; false, just return the filename
    string suffix - if you want to alter the temporary filename with an additional suffix, use this parameter
    boolean retainextension - true, keep the extension(if existing) at the end of the tempfile; false, just add the suffix~number at the end.
  </parameters>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement, create, temporary, file, filename</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CreateValidTempFile","filename_with_path", "Must be a string!", -2) return nil end
  if type(create)~="boolean" then ultraschall.AddErrorMessage("CreateValidTempFile","create", "Must be boolean!", -3) return nil end
  if type(suffix)~="string" then ultraschall.AddErrorMessage("CreateValidTempFile","suffix", "Must be a string!", -4) return nil end
  if type(retainextension)~="boolean" then ultraschall.AddErrorMessage("CreateValidTempFile","retainextension", "Must be boolean!", -5) return nil end
  local extension, tempfilename, A
  if retainextension==true then extension=filename_with_path:match(".*(%..*)") end
  if extension==nil then extension="" end
  for i=0, 16384 do
    tempfilename=filename_with_path..suffix.."~"..i..extension
    if reaper.file_exists(tempfilename)==false then
      if create==true then 
        A=ultraschall.WriteValueToFile(tempfilename,"")
        if A==1 then return tempfilename end
      elseif create==false then 
        return tempfilename
      end
    end
  end
  ultraschall.AddErrorMessage("CreateValidTempFile","filename_with_path", "Couldn't create a valid temp-file!", -1)
  return nil
end


function ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, startposition, endposition, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProject_RenderCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProject_RenderCFG(string projectfilename_with_path, string renderfilename_with_path, number startposition, number endposition, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, optional string rendercfg)</functioncall>
  <description>
    Renders a project, using a specific render-cfg-string.
    To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>
    
    Returns -1 in case of an error
    Returns -2 if currently opened project must be saved first(if you want to render the currently opened project).
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success; -2, if you try to render the currently opened project without saving it first
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project(needs to be saved first)
    string renderfilename_with_path - the filename of the output-file. If you give the wrong extension, Reaper will exchange it by the correct one.
                                    - nil, will use the render-filename/render-pattern already set in the project as renderfilename
    number startposition - the startposition of the render-area in seconds; 
                         - -1, to use the startposition set in the projectfile itself; 
                         - -2, to use the start of the time-selection
    number endposition - the endposition of the render-area in seconds; 
                       - 0, to use projectlength of the currently opened and active project(not supported with "external" projectfiles, yet)
                       - -1, to use the endposition set in the projectfile itself
                       - -2, to use the end of the time-selection
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    optional string rendercfg - the rendercfg-string, that contains all render-settings for an output-format
                              - To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                              - omit it or set to nil, if you want to use the render-string already set in the project
  </parameters>
  <chapter_context>
    Rendering of Project
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file</tags>
</US_DocBloc>
]]
  local retval
  local curProj=reaper.EnumProjects(-1,"")
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "startposition", "Must be a number in seconds.", -1) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "endposition", "Must be a number in seconds.", -2) return -1 end
  if startposition>=0 and endposition>0 and endposition<=startposition then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "endposition", "Must be bigger than startposition.", -3) return -1 end
  if endposition<-2 then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "endposition", "Must be bigger than 0 or -1(to retain project-file's endposition).", -4) return -1 end
  if startposition<-2 then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "startposition", "Must be bigger than 0 or -1(to retain project-file's startposition).", -5) return -1 end
  if projectfilename_with_path==nil and reaper.IsProjectDirty(0)==1 then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "renderfilename_with_path", "To render current project, it must be saved first!", -8) return -2 end
  if endposition==0 and projectfilename_with_path==nil then endposition=reaper.GetProjectLength(0) end
  if projectfilename_with_path==nil then 
    -- reaper.Main_SaveProject(0, false)
    retval, projectfilename_with_path = reaper.EnumProjects(-1,"")
  end  
  
  if type(projectfilename_with_path)~="string" or reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "projectfilename_with_path", "File does not exist.", -6) return -1 end
  if renderfilename_with_path~=nil and type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "renderfilename_with_path", "Must be a string.", -7) return -1 end  
  if rendercfg~=nil and ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "rendercfg", "No valid render_cfg-string.", -9) return -1 end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "overwrite_without_asking", "Must be boolean", -10) return -1 end

  -- Read Projectfile
  local FileContent=ultraschall.ReadFullFile(projectfilename_with_path, false)
  if ultraschall.CheckForValidFileFormats(projectfilename_with_path)~="RPP_PROJECT" then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "projectfilename_with_path", "Must be a valid Reaper-Project", -14) return -1 end
  local oldrendercfg=ultraschall.GetProject_RenderCFG(nil, FileContent)
  if rendercfg==nil then rendercfg=oldrendercfg end
    
  -- create temporary-project-filename
  local tempfile = ultraschall.CreateValidTempFile(projectfilename_with_path, true, "ultraschall-temp", true) 
  
  -- Write temporary projectfile
  ultraschall.WriteValueToFile(tempfile, FileContent)
  
  -- Add the render-filename to the project 
  if renderfilename_with_path~=nil then
    ultraschall.SetProject_RenderFilename(tempfile, renderfilename_with_path)
    ultraschall.SetProject_RenderPattern(tempfile, nil)
  end
  
  -- Add render-format-settings as well as adding media to project after rendering
  ultraschall.SetProject_RenderCFG(tempfile, rendercfg)
  ultraschall.SetProject_AddMediaToProjectAfterRender(tempfile, 1)
  
  -- Add the rendertime to the temporary project-file, when 
  local bounds, time_start, time_end, tail, tail_length = ultraschall.GetProject_RenderRange(tempfile)
--  if time_end==0 then time_end = ultraschall.GetProject_Length(tempfile) end
  local timesel1_start, timesel1_end = ultraschall.GetProject_Selection(tempfile)
  --   if startposition and/or endposition are -1, retain the start/endposition from the project-file

  if startposition==-1 then startposition=time_start end
  if endposition==-1 or endposition==0 then if time_end==0 then endposition=ultraschall.GetProject_Length(tempfile) else endposition=time_end end end
  if startposition==-2 then startposition=timesel1_start end
  if endposition==-2 then endposition=timesel1_end end

  if endposition==0 and startposition==0 then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "startposition or endposition in RPP-Project", "Can't render a project of length 0 seconds.", -13) os.remove (tempfile) return -1 end
  if endposition<=startposition and endposition~=0 then ultraschall.AddErrorMessage("RenderProject_RenderCFG", "startposition or endposition in RPP-Project", "Must be bigger than startposition.", -11) os.remove (tempfile) return -1 end
  local Bretval = ultraschall.SetProject_RenderRange(tempfile, 0, startposition, endposition, 0, 0)
  if Bretval==-1 then 
    os.remove (tempfile) 
    ultraschall.AddErrorMessage("RenderProject_RenderCFG", "projectfilename_with_path", "Can't set the timerange in the temporary-project "..tempfile, -12)
    return -1 
  end
  

  -- Get currently opened project
  local _temp, oldprojectname=ultraschall.EnumProjects(0)
  
  --Now the magic happens:
  
  -- delete renderfile, if already existing and overwrite_without_asking==true
  if overwrite_without_asking==true then
    if renderfilename_with_path~=nil and reaper.file_exists(renderfilename_with_path)==true then
      os.remove(renderfilename_with_path) 
    end
  end 
  
  
  reaper.Main_OnCommand(40859,0)    -- create new temporary tab
  reaper.Main_openProject(tempfile) -- load the temporary projectfile
  
  -- manage automatically closing of the render-window and filename-increasing
  local val=reaper.SNM_GetIntConfigVar("renderclosewhendone", -99)
  local oldval=val
  if renderclosewhendone==true then 
    if val&1==0 then val=val+1 end
    if val==-99 then val=1 end
  elseif renderclosewhendone==false then 
    if val&1==1 then val=val-1 end
    if val==-99 then val=0 end
  end
  
  if filenameincrease==true then 
    if val&16==0 then val=val+16 end
    if val==-99 then val=16 end
  elseif filenameincrease==false then 
    if val&16==16 then val=val-16 end
    if val==-99 then val=0 end
  end
  reaper.SNM_SetIntConfigVar("renderclosewhendone", val)
  
  -- temporarily disable building peak-caches
  local peakval=reaper.SNM_GetIntConfigVar("peakcachegenmode", -99)
  reaper.SNM_SetIntConfigVar("peakcachegenmode", 0)
  
  local AllTracks=ultraschall.CreateTrackString_AllTracks() -- get number of tracks after rendering and adding of rendered files
  
  reaper.Main_OnCommand(41824,0)    -- render using it with the last rendersettings(those, we inserted included)
  reaper.Main_SaveProject(0, false) -- save it(no use, but otherwise, Reaper would open a Save-Dialog, that we don't want and need)
  local AllTracks2=ultraschall.CreateTrackString_AllTracks() -- get number of tracks after rendering and adding of rendered files
  local retval, Trackstring = ultraschall.OnlyTracksInOneTrackstring(AllTracks, AllTracks2) -- only get the newly added tracks as trackstring
  local count, MediaItemArray, MediaItemStateChunkArray
  if Trackstring~="" then 
    count, MediaItemArray, MediaItemStateChunkArray = ultraschall.GetAllMediaItemsBetween(0, reaper.GetProjectLength(0), Trackstring, false) -- get the new MediaItems created after adding the rendered files
  else
    count=0
  end
  reaper.Main_OnCommand(40860,0)    -- close the temporary-tab again

  local Filearray={}
  for i=1, count do
    Filearray[i]=MediaItemStateChunkArray[i]:match("%<SOURCE.-FILE \"(.-)\"")
  end

  -- reset old renderclose/overwrite/Peak-cache-settings
  reaper.SNM_SetIntConfigVar("renderclosewhendone", oldval)
  reaper.SNM_SetIntConfigVar("peakcachegenmode", peakval)

  --remove the temp-file and we are done.
  os.remove (tempfile)
  os.remove (tempfile.."-bak")
  reaper.SelectProjectInstance(curProj)
  return 0, count, MediaItemStateChunkArray, Filearray
end

--A,B,C,D=ultraschall.RenderProject_RenderCFG(nil, nil, 0, 100, true, true, true)

function ultraschall.GetMediafileAttributes(filename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediafileAttributes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number length, integer numchannels, integer Samplerate, string Filetype = ultraschall.GetMediafileAttributes(string filename)</functioncall>
  <description>
    returns the attributes of a mediafile
    
    if the mediafile is an rpp-project, this function creates a proxy-file called filename.RPP-PROX, which is a wave-file of the length of the project.
    This file can be deleted safely after that, but would be created again the next time this function is called.    
  </description>
  <parameters>
    string filename - the file whose attributes you want to have
  </parameters>
  <retvals>
    number length - the length of the mediafile in seconds
    integer numchannels - the number of channels of the mediafile
    integer Samplerate - the samplerate of the mediafile in hertz
    string Filetype - the type of the mediafile, like MP3, WAV, MIDI, FLAC, RPP_PROJECT etc
  </retvals>
  <chapter_context>
    MediaItem Management
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>markermanagement, get, position, length, num, channels, samplerate, filetype</tags>
</US_DocBloc>
--]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("GetMediafileAttributes","filename", "must be a string", -1) return -1 end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("GetMediafileAttributes","filename", "file does not exist", -2) return -1 end
  local PCM_source=reaper.PCM_Source_CreateFromFile(filename)
  local Length, lengthIsQN = reaper.GetMediaSourceLength(PCM_source)
  local Numchannels=reaper.GetMediaSourceNumChannels(PCM_source)
  local Samplerate=reaper.GetMediaSourceSampleRate(PCM_source)
  local Filetype=reaper.GetMediaSourceType(PCM_source, "")  
  reaper.PCM_Source_Destroy(PCM_source)
--  if Filetype=="RPP_PROJECT" then os.remove(filename.."-PROX") end
  return Length, Numchannels, Samplerate, Filetype
end

function ultraschall.RenderProjectRegions_RenderCFG(projectfilename_with_path, renderfilename_with_path, region, addregionname, overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RenderProjectRegions_RenderCFG</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval, integer renderfilecount, array MediaItemStateChunkArray, array Filearray = ultraschall.RenderProjectRegions_RenderCFG(string projectfilename_with_path, string renderfilename_with_path, integer region, boolean addregionname, boolean overwrite_without_asking, boolean renderclosewhendone, boolean filenameincrease, optional string rendercfg)</functioncall>
  <description>
    Renders a region of a project, using a specific render-cfg-string.
    To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>
    
    Returns -1 in case of an error
    Returns -2 if currently opened project must be saved first(if you want to render the currently opened project).
  </description>
  <retvals>
    integer retval - -1, in case of error; 0, in case of success; -2, if you try to render the currently opened project without saving it first
    integer renderfilecount - the number of rendered files
    array MediaItemStateChunkArray - the MediaItemStateChunks of all rendered files, with the one in entry 1 being the rendered master-track(when rendering stems)
    array Filearray - the filenames of the rendered files, including their paths. The filename in entry 1 is the one of the mastered track(when rendering stems)
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project(needs to be saved first)
    string renderfilename_with_path - the filename of the output-file. 
                                    - Don't add a file-extension, when using addregionname=true!
                                    - Give a path only, when you want to use only the regionname as render-filename(set addregionname=true !)
                                    - nil, use the filename/render-pattern already set in the project for the renderfilename
    integer region - the number of the region in the Projectfile to render
    boolean addregionname - add the name of the region to the renderfilename; only works, when you don't add a file-extension to renderfilename_with_path
    boolean overwrite_without_asking - true, overwrite an existing renderfile; false, don't overwrite an existing renderfile
    boolean renderclosewhendone - true, automatically close the render-window after rendering; false, keep rendering window open after rendering; nil, use current settings
    boolean filenameincrease - true, silently increase filename, if it already exists; false, ask before overwriting an already existing outputfile; nil, use current settings
    optional string rendercfg - the rendercfg-string, that contains all render-settings for an output-format
                              - To get render-cfg-strings, see <a href="#CreateRenderCFG_AIFF">CreateRenderCFG_AIFF</a>, <a href="#CreateRenderCFG_DDP">CreateRenderCFG_DDP</a>, <a href="#CreateRenderCFG_FLAC">CreateRenderCFG_FLAC</a>, <a href="#CreateRenderCFG_OGG">CreateRenderCFG_OGG</a>, <a href="#CreateRenderCFG_Opus">CreateRenderCFG_Opus</a>, <a href="#CreateRenderCFG_WAVPACK">CreateRenderCFG_WAVPACK</a>, <a href="#CreateRenderCFG_WebMVideo">CreateRenderCFG_WebMVideo</a>
                              - omit it or set to nil, if you want to use the render-string already set in the project
  </parameters>
  <chapter_context>
    Rendering of Project
    Rendering any Outputformat
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, render, output, file</tags>
</US_DocBloc>
]]
  local retval
  local curProj=reaper.EnumProjects(-1,"")
  if math.type(region)~="integer" then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "region", "Must be an integer.", -1) return -1 end
  if projectfilename_with_path==nil and reaper.IsProjectDirty(0)==1 then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "renderfilename_with_path", "To render current project, it must be saved first!", -2) return -2 end
  if type(projectfilename_with_path)~="string" then 
    -- reaper.Main_SaveProject(0, false)
    retval, projectfilename_with_path = reaper.EnumProjects(-1,"")
  end
  
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "projectfilename_with_path", "File does not exist.", -3) return -1 end
  if renderfilename_with_path~=nil and type(renderfilename_with_path)~="string" then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "renderfilename_with_path", "Must be a string.", -4) return -1 end  
  if rendercfg~=nil and ultraschall.GetOutputFormat_RenderCfg(rendercfg)==nil then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "rendercfg", "No valid render_cfg-string.", -5) return -1 end
  if type(overwrite_without_asking)~="boolean" then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "overwrite_without_asking", "Must be boolean", -6) return -1 end

  local countmarkers, nummarkers, numregions, markertable = ultraschall.GetProject_MarkersAndRegions(projectfilename_with_path)
  if region>numregions then ultraschall.AddErrorMessage("RenderProjectRegions_RenderCFG", "region", "No such region in the project.", -7) return -1 end
  local regioncount=0
  for i=1, countmarkers do
    if markertable[i][1]==true then 
      regioncount=regioncount+1
      if regioncount==region then region=i break end
    end
  end
  if addregionname==true then renderfilename_with_path=renderfilename_with_path..markertable[region][4] end

  return ultraschall.RenderProject_RenderCFG(projectfilename_with_path, renderfilename_with_path, tonumber(markertable[region][2]), tonumber(markertable[region][3]), overwrite_without_asking, renderclosewhendone, filenameincrease, rendercfg)
end




function ultraschall.CreateTemporaryFileOfProjectfile(projectfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateTemporaryFileOfProjectfile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string tempfile = ultraschall.CreateTemporaryFileOfProjectfile(string projectfilename_with_path)</functioncall>
  <description>
    Creates a temporary copy of an rpp-projectfile, which can be altered and rendered again.
    
    Must be deleted by hand using os.remove(tempfile) after you're finished.
    
    returns nil in case of an error
  </description>
  <retvals>
    string tempfile - the temporary-file, that is a valid copy of the projectfilename_with_path
  </retvals>
  <parameters>
    string projectfilename_with_path - the project to render; nil, for the currently opened project(needs to be saved first)
  </parameters>
  <chapter_context>
    Rendering of Project
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, tempfile, temporary, render, output, file</tags>
</US_DocBloc>
]]
  local temp
  if projectfilename_with_path==nil then 
    if reaper.IsProjectDirty(0)~=1 then
      temp, projectfilename_with_path=reaper.EnumProjects(-1, "") 
    else
      ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "", "current project must be saved first", -1) return nil
    end
  end
  if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "must be a string", -2) return nil end
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "no such file", -3) return nil end
  local A=ultraschall.ReadFullFile(projectfilename_with_path)
  if A==nil then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "Can't read projectfile", -4) return nil end
  if ultraschall.IsValidProjectStateChunk(A)==false then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "no valid project-file", -5) return nil end
  local tempfilename=ultraschall.CreateValidTempFile(projectfilename_with_path, true, "", true)
  if tempfilename==nil then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "", "Can't create tempfile", -6) return nil end
  local B=ultraschall.WriteValueToFile(tempfilename, A)
  if B==-1 then ultraschall.AddErrorMessage("CreateTemporaryFileOfProjectfile", "projectfilename_with_path", "Can't create tempfile", -7) return nil else return tempfilename end
end

--length, numchannels, Samplerate, Filetype = ultraschall.GetMediafileAttributes("c:\\Users\\meo\\Desktop\\tudelu\\tudelu.RPP")
--A,B,C,D,E = ultraschall.CreateTemporaryFileOfProjectfile("c:\\Users\\meo\\Desktop\\tudelu\\tudelu.RPP")
--A,B,C,D,E = ultraschall.CreateTemporaryFileOfProjectfile()

function ultraschall.GetProject_Length(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Length</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>number length, number last_itemedge, number last_marker_reg_edge, number last_timesig_marker = ultraschall.GetProject_Length(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the projectlength of an rpp-project-file.
    
    It's eturning the position of the overall length, as well as the position of the last itemedge/regionedge/marker/time-signature-marker of the project.
    
    Returns -1 in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the project, that you want to know it's length of; nil to use parameter ProjectStateChunk instead
    optional string ProjectStateChunk - a ProjectStateChunk to count the length of; only available when projectfilename_with_path=nil
  </parameters>
  <retvals>
    number length - the length of the project
    number last_itemedge - the postion of the last itemedge in the project
    number last_marker_reg_edge - the position of the last marker/regionedge in the project
    number last_timesig_marker - the position of the last time-signature-marker in the project
  </retvals>
  <chapter_context>
    Project-Files
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>project management, get, length of project, marker, region, timesignature, lengt, item, edge</tags>
</US_DocBloc>
]]

  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return -1 end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return -1 end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_Length","projectfilename_with_path", "File does not exist!", -3) return -1
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_Length", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return -1 end
  end

  local B, C, ProjectLength, Len, Pos, Offs

  -- search for the last item-edge in the project
  B=ProjectStateChunk
  B=B:match("(%<ITEM.*)<EXTENS").."\n<ITEM"
  ProjectLength=0
  local Item_Length=0
  local Marker_Length=0
  local TempoMarker_Length=0
  
  -- let's take a huge project-string apart to make patternmatching much faster
  local K={}
  local counter=0
  while B:len()>1000 do     
    K[counter]=B:sub(0, 100000)
    B=B:sub(100001,-1)
    counter=counter+1    
  end
  if counter==0 then K[0]=B end
  
  local counter2=1
  local B=K[0]
  
  local Itemscount=0
  
  
  while B~=nil and B:sub(1,5)=="<ITEM" do  
    if B:len()<10000 and counter2<counter then B=B..K[counter2] counter2=counter2+1 end
    Offs=B:match(".()<ITEM")

    local sc=B:sub(1,200)
    if sc==nil then break end

    Pos = sc:match("POSITION (.-)\n")
    Len = sc:match("LENGTH (.-)\n")

    if Pos==nil or Len==nil or Offs==nil then break end
    if ProjectLength<tonumber(Pos)+tonumber(Len) then ProjectLength=tonumber(Pos)+tonumber(Len) end
    B=B:sub(Offs,-1)  
    Itemscount=Itemscount+1
  end
  Item_Length=ProjectLength

  -- search for the last marker/regionedge in the project
  local markerregioncount, NumMarker, Numregions, Markertable = ultraschall.GetProject_MarkersAndRegions(nil, ProjectStateChunk)
  
  for i=1, markerregioncount do
    if ProjectLength<Markertable[i][2]+Markertable[i][3] then ProjectLength=Markertable[i][2]+Markertable[i][3] end
    if Marker_Length<Markertable[i][2]+Markertable[i][3] then Marker_Length=Markertable[i][2]+Markertable[i][3] end
  end
  
  -- search for the last tempo-envx-marker in the project
  B=ultraschall.GetProject_TempoEnv_ExStateChunk(nil, ProjectStateChunk)  
  C=B:match(".*PT (.-) ")
  if C~=nil and ProjectLength<tonumber(C) then ProjectLength=tonumber(C) end
  if C~=nil and TempoMarker_Length<tonumber(C) then TempoMarker_Length=tonumber(C) end
  
  return ProjectLength, Item_Length, Marker_Length, TempoMarker_Length
end

function ultraschall.SetProject_RenderPattern(projectfilename_with_path, render_pattern, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetProject_RenderPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetProject_RenderPattern(string projectfilename_with_path, string render_pattern, optional string ProjectStateChunk)</functioncall>
  <description>
    Sets the render-filename in an rpp-projectfile or a ProjectStateChunk. Set it to "", if you want to set the render-filename with <a href="#SetProject_RenderFilename">SetProject_RenderFilename</a>.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - the filename of the projectfile; nil to use Parameter ProjectStateChunk instead
    string render_pattern - the pattern, with which the rendering-filename will be automatically created. Check also <a href="#GetProject_RenderFilename">GetProject_RenderFilename</a>
    -Capitalizing the first character of the wildcard will capitalize the first letter of the substitution. 
    -Capitalizing the first two characters of the wildcard will capitalize all letters.
    -
    -Directories will be created if necessary. For example if the render target is "$project/track", the directory "$project" will be created.
    -
    -$item    media item take name, if the input is a media item
    -$itemnumber  1 for the first media item on a track, 2 for the second...
    -$track    track name
    -$tracknumber  1 for the first track, 2 for the second...
    -$parenttrack  parent track name
    -$region    region name
    -$regionnumber  1 for the first region, 2 for the second...
    -$namecount  1 for the first item or region of the same name, 2 for the second...
    -$start    start time of the media item, render region, or time selection
    -$end    end time of the media item, render region, or time selection
    -$startbeats  start time in beats of the media item, render region, or time selection
    -$endbeats  end time in beats of the media item, render region, or time selection
    -$timelineorder  1 for the first item or region on the timeline, 2 for the second...
    -$project    project name
    -$tempo    project tempo at the start of the render region
    -$timesignature  project time signature at the start of the render region, formatted as 4-4
    -$filenumber  blank (optionally 1) for the first file rendered, 1 (optionally 2) for the second...
    -$filenumber[N]  N for the first file rendered, N+1 for the second...
    -$note    C0 for the first file rendered,C#0 for the second...
    -$note[X]    X (example: B2) for the first file rendered, X+1 (example: C3) for the second...
    -$natural    C0 for the first file rendered, D0 for the second...
    -$natural[X]  X (example: F2) for the first file rendered, X+1 (example: G2) for the second...
    -$format    render format (example: wav)
    -$samplerate  sample rate (example: 44100)
    -$sampleratek  sample rate (example: 44.1)
    -$year    year
    -$year2    last 2 digits of the year
    -$month    month number
    -$monthname  month name
    -$day    day of the month
    -$hour    hour of the day in 24-hour format
    -$hour12    hour of the day in 12-hour format
    -$ampm    am if before noon,pm if after noon
    -$minute    minute of the hour
    -$second    second of the minute
    -$user    user name
    -$computer  computer name
    -
    -(this description has been taken from the Render Wildcard Help within the Render-Dialog of Reaper)
    optional string ProjectStateChunk - a projectstatechunk, that you want to be changed
  </parameters>
  <retvals>
    integer retval - -1 in case of error, 1 in case of success
  </retvals>
  <chapter_context>
    Project-Files
    RPP-Files Set
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, rpp, state, set, recording, render pattern, filename, render</tags>
</US_DocBloc>
]]  
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "ProjectStateChunk", "Must be a valid ProjectStateChunk", -1) return -1 end
  if projectfilename_with_path~=nil and reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "File does not exist", -2) return -1 end
  if projectfilename_with_path~=nil then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path) end
  if projectfilename_with_path~=nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "File is no valid RPP-Projectfile", -3) return -1 end
  if render_pattern~=nil and type(render_pattern)~="string" then ultraschall.AddErrorMessage("SetProject_RenderPattern", "render_pattern", "Must be a string", -4) return -1 end
  if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("SetProject_RenderPattern", "projectfilename_with_path", "No valid RPP-Projectfile!", -5) return -1 end
  local quots

  local FileStart=ProjectStateChunk:match("(<REAPER_PROJECT.-RENDER_FILE.-%c)")
  local FileEnd=ProjectStateChunk:match("<REAPER_PROJECT.-(RENDER_FMT.*)")
  local RenderPattern
  if render_pattern:match("%s")~=nil then quots="\"" else quots="" end
  if render_pattern==nil then RenderPattern="" else RenderPattern="  RENDER_PATTERN "..quots..render_pattern..quots.."\n" end
  
  ProjectStateChunk=FileStart..RenderPattern.."  "..FileEnd
  if projectfilename_with_path~=nil then return ultraschall.WriteValueToFile(projectfilename_with_path, ProjectStateChunk), ProjectStateChunk
  else return 1, ProjectStateChunk
  end  
end

function ultraschall.InsertMediaItemFromFile(filename, track, position, endposition, editcursorpos, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>InsertMediaItemFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval, MediaItem item, number endposition, integer numchannels, integer Samplerate, string Filetype, number editcursorposition, MediaTrack track = ultraschall.InsertMediaItemFromFile(string filename, integer track, number position, number endposition, integer editcursorpos, optional number offset)</functioncall>
  <description>
    Inserts the mediafile filename into the project at position in track
    When giving an rpp-projectfile, it will be rendered by Reaper and inserted as subproject!
    
    Due API-limitations, it creates two undo-points: one for inserting the MediaItem and one for changing the length(when endposition isn't -1).    
    
    Returns -1 in case of failure
  </description>
  <parameters>
    string filename - the path+filename of the mediafile to be inserted into the project
    integer track - the track, in which the file shall be inserted
                  -  0, insert the file into a newly inserted track after the last track
                  - -1, insert the file into a newly inserted track before the first track
    number position - the position of the newly inserted item
    number endposition - the length of the newly created mediaitem; -1, use the length of the sourcefile
    integer editcursorpos - the position of the editcursor after insertion of the mediafile
          - 0 - the old editcursorposition
          - 1 - the position, at which the item was inserted
          - 2 - the end of the newly inserted item
    optional number offset - an offset, to delay the insertion of the item, to overcome possible "too late"-starting of playback of item during recording
  </parameters>
  <retvals>
    integer retval - 0, if insertion worked; -1, if it failed
    MediaItem item - the newly created MediaItem
    number endposition - the endposition of the newly created MediaItem in seconds
    integer numchannels - the number of channels of the mediafile
    integer Samplerate - the samplerate of the mediafile in hertz
    string Filetype - the type of the mediafile, like MP3, WAV, MIDI, FLAC, etc
    number editcursorposition - the (new) editcursorposition
    MediaTrack track - returns the MediaTrack, in which the item is included
  </retvals>
  <chapter_context>
    MediaItem Management
    Insert
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>markermanagement, insert, mediaitem, position, mediafile, track</tags>
</US_DocBloc>
--]]

  -- check parameters
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "filename", "file does not exist", -1) return -1 end
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "must be an integer", -2) return -1 end
  if type(position)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","position", "must be a number", -3) return -1 end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","endposition", "must be a number", -4) return -1 end
  if endposition<-1 then ultraschall.AddErrorMessage("InsertMediaItemFromFile","endposition", "must be bigger/equal 0; or -1 for sourcefilelength", -5) return -1 end
  if math.type(editcursorpos)~="integer" then ultraschall.AddErrorMessage("InsertMediaItemFromFile", "editcursorpos", "must be an integer between 0 and 2", -6) return -1 end
  if track<-1 or track>reaper.CountTracks(0) then ultraschall.AddErrorMessage("InsertMediaItemFromFile","track", "no such track available", -7) return -1 end  
  if offset~=nil and type(offset)~="number" then ultraschall.AddErrorMessage("InsertMediaItemFromFile","offset", "must be either nil or a number", -8) return -1 end  
  if offset==nil then offset=0 end
    
  -- where to insert and where to have the editcursor after insert
  local editcursor, mode
  if editcursorpos==0 then editcursor=reaper.GetCursorPosition()
  elseif editcursorpos==1 then editcursor=position
  elseif editcursorpos==2 then editcursor=position+ultraschall.GetMediafileAttributes(filename)
  else ultraschall.AddErrorMessage("InsertMediaItemFromFile","editcursorpos", "must be an integer between 0 and 2", -6) return -1
  end
  
  -- insert file
  local Length, Numchannels, Samplerate, Filetype = ultraschall.GetMediafileAttributes(filename) -- mediaattributes, like length
  local startTime, endTime = reaper.BR_GetArrangeView(0) -- get current arrange-view-range
  local mode=0
  if track>=0 and track<reaper.CountTracks(0) then
    mode=0
  elseif track==0 then
    mode=0
    track=reaper.CountTracks(0)
  elseif track==-1 then
    mode=0
    track=1
    reaper.InsertTrackAtIndex(0,false)
  end
  local SelectedTracks=ultraschall.CreateTrackString_SelectedTracks() -- get old track-selection
  ultraschall.SetTracksSelected(tostring(track), true) -- set track selected, where we want to insert the item
  reaper.SetEditCurPos(position+offset, false, false) -- change editcursorposition to where we want to insert the item
  local CountMediaItems=reaper.CountMediaItems(0) -- the number of items available; the new one will be number of items + 1
  local LLL=ultraschall.GetAllMediaItemGUIDs()
  if LLL[1]==nil then LLL[1]="tudelu" end
  local integer=reaper.InsertMedia(filename, mode)  -- insert item with file
  local LLL2=ultraschall.GetAllMediaItemGUIDs()
  local A,B=ultraschall.CompareArrays(LLL, LLL2)
  local item=reaper.BR_GetMediaItemByGUID(0, A[1])
  if endposition~=-1 then reaper.SetMediaItemInfo_Value(item, "D_LENGTH", endposition) end
  
  reaper.SetEditCurPos(editcursor, false, false)  -- set editcursor to new position
  reaper.BR_SetArrangeView(0, startTime, endTime) -- reset to old arrange-view-range
  if SelectedTracks~="" then ultraschall.SetTracksSelected(SelectedTracks, true) end -- reset old trackselection
  return 0, item, Length, Numchannels, Samplerate, Filetype, editcursor, reaper.GetMediaItem_Track(item)
end

--A,B,C,D,E,F,G,H,I,J=ultraschall.InsertMediaItemFromFile(ultraschall.Api_Path.."/misc/silence.flac", 0, 0, -1, 0)



function ultraschall.GetProject_RenderFilename(projectfilename_with_path, ProjectStateChunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderFilename</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string render_filename = ultraschall.GetProject_RenderFilename(string projectfilename_with_path, optional string ProjectStateChunk)</functioncall>
  <description>
    Returns the render-filename from an RPP-Projectfile or a ProjectStateChunk. If it contains only a path or nothing, you should check the Render_Pattern using <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>, as a render-pattern influences the rendering-filename as well.
    
    It's the entry RENDER_FILE
    
    Returns nil in case of error.
  </description>
  <parameters>
    string projectfilename_with_path - filename with path for the rpp-projectfile; nil, if you want to use parameter ProjectStateChunk
    optional string ProjectStateChunk - a ProjectStateChunk to use instead if a filename; only used, when projectfilename_with_path is nil
  </parameters>
  <retvals>
    string render_filename - the filename for rendering, check also <a href="#GetProject_RenderPattern">GetProject_RenderPattern</a>
  </retvals>
  <chapter_context>
    Project-Files
    RPP-Files Get
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, rpp, state, get, recording, path, render filename, filename, render</tags>
</US_DocBloc>
]]
  -- check parameters and prepare variable ProjectStateChunk
  if projectfilename_with_path~=nil and type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "Must be a string or nil(the latter when using parameter ProjectStateChunk)!", -1) return nil end
  if projectfilename_with_path==nil and ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename","ProjectStateChunk", "No valid ProjectStateChunk!", -2) return nil end
  if projectfilename_with_path~=nil then
    if reaper.file_exists(projectfilename_with_path)==true then ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path, false)
    else ultraschall.AddErrorMessage("GetProject_RenderFilename","projectfilename_with_path", "File does not exist!", -3) return nil
    end
    if ultraschall.IsValidProjectStateChunk(ProjectStateChunk)==false then ultraschall.AddErrorMessage("GetProject_RenderFilename", "projectfilename_with_path", "No valid RPP-Projectfile!", -4) return nil end
  end
  -- get the value and return it
  local temp=ProjectStateChunk:match("<REAPER_PROJECT.-RENDER_FILE%s(.-)%c.-<RENDER_CFG")
  if temp:sub(1,1)=="\"" then temp=temp:sub(2,-1) end
  if temp:sub(-1,-1)=="\"" then temp=temp:sub(1,-2) end
  return temp
end

function ultraschall.WriteValueToFile(filename_with_path, value, binarymode, append)
  -- Writes value to filename_with_path
  -- Keep in mind, that you need to escape \ by writing \\, or it will not work
  -- binarymode
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WriteValueToFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WriteValueToFile(string filename_with_path, string value, optional boolean binarymode, optional boolean append)</functioncall>
  <description>
    Writes value to filename_with_path. Will replace any previous content of the file if append is set to false. Returns -1 in case of failure, 1 in case of success.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval  - -1 in case of failure, 1 in case of success
  </retvals>
  <parameters>
    string filename_with_path - the filename with it's path
    string value - the value to export, can be a long string that includes newlines and stuff. nil is not allowed!
    boolean binarymode - true or nil, it will store the value as binary-file; false, will store it as textstring
    boolean append - true, add the value to the end of the file; false or nil, write value to file and erase all previous data in the file
  </parameters>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,binary</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path", "invalid filename", -1) return -1 end
  --if type(value)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","value", "must be string; convert with tostring(value), if necessary.", -2) return -1 end
  value=tostring(value)
  
  -- prepare variables
  local binary, appendix, file
  if binarymode==nil or binarymode==true then binary="b" else binary="" end
  if append==nil or append==false then appendix="w" else appendix="a" end
  
  -- write file
  file=io.open(filename_with_path,appendix..binary)
  if file==nil then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path", "can't create file", -3) return -1 end
  file:write(value)
  file:close()
  return 1
end

function ultraschall.WriteValueToFile_Insert(filename_with_path, linenumber, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WriteValueToFile_Insert</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WriteValueToFile_Insert(string filename_with_path, integer linenumber, string value)</functioncall>
  <description>
    Inserts value into a file at linenumber. All lines, up to linenumber-1 come before value, all lines at linenumber to the end of the file will come after value.
    Will return -1, if no such line exists.
    
    Note: non-binary-files only!
  </description>
  <parameters>
    string filename_with_path - filename to write the value to
    integer linenumber - the linenumber, at where to insert the value into the file
    string value - the value to be inserted into the file
  </parameters>
  <retvals>
    integer retval - 1, in case of success, -1 in case of error
  </retvals>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,insert</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_Insert","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_Insert","filename_with_path", "file does not exist", -2) return -1 end
  --if value==nil then ultraschall.AddErrorMessage("WriteValueToFile_Insert","value", "nil not allowed", -3) return -1 end
  value=tostring(value)
  if tonumber(linenumber)==nil then ultraschall.AddErrorMessage("WriteValueToFile_Insert","linenumber", "invalid linenumber", -4) return -1 end
  local numberoflines=ultraschall.CountLinesInFile(filename_with_path)
  if tonumber(linenumber)<1 or tonumber(linenumber)>numberoflines then ultraschall.AddErrorMessage("WriteValueToFile_Insert","linenumber", "linenumber must be between 1 and "..numberoflines.." for this file", -5) return -1 end
  local contents, correctnumberoflines = ultraschall.ReadLinerangeFromFile(filename_with_path, 1, linenumber-1) 
  local contents2, correctnumberoflines = ultraschall.ReadLinerangeFromFile(filename_with_path, linenumber, numberoflines)
  return ultraschall.WriteValueToFile(filename_with_path, contents..value..contents2, false, false)
end


function ultraschall.WriteValueToFile_Replace(filename_with_path, startlinenumber, endlinenumber, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WriteValueToFile_Replace</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WriteValueToFile_Replace(string filename_with_path, integer startlinenumber, integer endlinenumber, string value)</functioncall>
  <description>
    Replaces the linenumbers startlinenumber to endlinenumber in a file with value. All lines, up to startlinenumber-1 come before value, all lines at endlinenumber+1 to the end of the file will come after value.
    Will return -1, if no such lines exists.
    
    Note: non-binary-files only!
  </description>
  <parameters>
    string filename_with_path - filename to write the value to
    integer startlinenumber - the first linenumber, to be replaced with value in the file
    integer endlinenumber - the last linenumber, to be replaced with value in the file
    string value - the value to be inserted into the file
  </parameters>
  <retvals>
    integer retval - 1, in case of success, -1 in case of error
  </retvals>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,replace</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "must be a string", -1) return -1 end
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "nil not allowed as filename", -0) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "file does not exist", -2) return -1 end
--  if value==nil then ultraschall.AddErrorMessage("WriteValueToFile_Replace","value", "nil not allowed", -3) return -1 end
  value=tostring(value)
  if tonumber(startlinenumber)==nil then ultraschall.AddErrorMessage("WriteValueToFile_Replace","startlinenumber", "invalid linenumber", -4) return -1 end
  if tonumber(endlinenumber)==nil then ultraschall.AddErrorMessage("WriteValueToFile_Replace","endlinenumber", "invalid linenumber", -5) return -1 end
  local numberoflines=ultraschall.CountLinesInFile(filename_with_path)
  if tonumber(startlinenumber)<1 or tonumber(startlinenumber)>numberoflines then ultraschall.AddErrorMessage("WriteValueToFile_Replace","startlinenumber", "linenumber must be between 1 and "..numberoflines.." for this file", -6) return -1 end
  if tonumber(endlinenumber)<tonumber(startlinenumber) or tonumber(endlinenumber)>numberoflines then ultraschall.AddErrorMessage("WriteValueToFile_Replace","endlinenumber", "linenumber must be bigger than "..startlinenumber.." for startlinenumber and max "..numberoflines.." for this file", -7) return -1 end
  local contents, correctnumberoflines = ultraschall.ReadLinerangeFromFile(filename_with_path, 1, startlinenumber-1) 
  local contents2, correctnumberoflines = ultraschall.ReadLinerangeFromFile(filename_with_path, endlinenumber+1, numberoflines)
  return ultraschall.WriteValueToFile(filename_with_path, contents..value..contents2, false, false)
end

function ultraschall.WriteValueToFile_InsertBinary(filename_with_path, byteposition, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WriteValueToFile_InsertBinary</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WriteValueToFile_InsertBinary(string filename_with_path, integer byteposition, string value)</functioncall>
  <description>
    Inserts value into a file at byteposition. All bytes, up to byteposition-1 come before value, all bytes at byteposition to the end of the file will come after value.
    Will return -1, if no such line exists.
    
    Note: good for binary files
  </description>
  <parameters>
    string filename_with_path - filename to write the value to
    integer byteposition - the byteposition, at where to insert the value into the file
    string value - the value to be inserted into the file
  </parameters>
  <retvals>
    integer retval - 1, in case of success, -1 in case of error
  </retvals>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,insert,binary</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","filename_with_path", "file does not exist", -2) return -1 end
  --if value==nil then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","value", "nil not allowed", -3) return -1 end
  value=tostring(value)
  if tonumber(byteposition)==nil then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","byteposition", "invalid value. Only integer allowed", -4) return -1 end
  local filelength=ultraschall.GetLengthOfFile(filename_with_path)
  if tonumber(byteposition)<0 or tonumber(byteposition)>filelength then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","byteposition", "must be inbetween 0 and "..filelength.." for this file", -5) return -1 end
  if byteposition==0 then byteposition=1 end
  local correctnumberofbytes, contents=ultraschall.ReadBinaryFile_Offset(filename_with_path, 0, byteposition-1)
  local correctnumberofbytes2, contents2=ultraschall.ReadBinaryFile_Offset(filename_with_path, byteposition, -1)
  return ultraschall.WriteValueToFile(filename_with_path, contents..value..contents2, true, false)
end

function ultraschall.WriteValueToFile_ReplaceBinary(filename_with_path, startbyteposition, endbyteposition, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WriteValueToFile_ReplaceBinary</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WriteValueToFile_ReplaceBinary(string filename_with_path, integer startbyteposition, integer endbyteposition, string value)</functioncall>
  <description>
    Replaces content in the file from startbyteposition to endbyteposition-1 with value. All bytes, up to startbyteposition-1 come before value, all bytes from (and including)endbyteposition to the end of the file will come after value.
    Will return -1, if no such line exists.
    
    Note: good for binary files
  </description>
  <parameters>
    string filename_with_path - filename to write the value to
    integer startbyteposition - the first byte in the file to be replaced, starting with 1, if you want to replace at the beginning of the file. Everything before startposition will be kept.
    integer endbyteposition - the first byte after the replacement. Everything from endbyteposition to the end of the file will be kept.
    string value - the value to be inserted into the file
  </parameters>
  <retvals>
    integer retval - 1, in case of success, -1 in case of error
  </retvals>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,replace,binary</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","filename_with_path", "file does not exist", -2) return -1 end
  --if value==nil then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","value", "nil not allowed", -3) return -1 end
  value=tostring(value)
  if tonumber(startbyteposition)==nil then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","startbyteposition", "invalid value. Only integer allowed", -4) return -1 end
  if tonumber(endbyteposition)==nil then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","endbyteposition", "invalid value. Only integer allowed", -5) return -1 end
  
  local filelength=ultraschall.GetLengthOfFile(filename_with_path)
  if tonumber(startbyteposition)<0 or tonumber(startbyteposition)>filelength then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","startbyteposition", "must be inbetween 0 and "..filelength.." for this file", -6) return -1 end
  if tonumber(endbyteposition)<tonumber(startbyteposition) or tonumber(endbyteposition)>filelength then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","endbyteposition", "must be inbetween "..startbyteposition.." and "..filelength.." for this file", -7) return -1 end

  if startbyteposition==0 then startbyteposition=1 end
  correctnumberofbytes, contents=ultraschall.ReadBinaryFile_Offset(filename_with_path, 0, startbyteposition-1)
  local correctnumberofbytes2, contents2=ultraschall.ReadBinaryFile_Offset(filename_with_path, endbyteposition-1, -1)
  return ultraschall.WriteValueToFile(filename_with_path, contents..value..contents2, true, false)
end

function ultraschall.StateChunkLayouter(statechunk)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StateChunkLayouter</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string layouted_statechunk = ultraschall.StateChunkLayouter(string statechunk)</functioncall>
  <description>
    Layouts StateChunks as returned by <a href="Reaper_Api_Documentation.html#GetTrackStateChunk">GetTrackStateChunk</a> or <a href="Reaper_Api_Documentation.html#GetItemStateChunk">GetItemStateChunk</a> into a format that resembles the formatting-rules of an rpp-file.
    This is very helpful, when parsing such a statechunk, as you can now use the number of spaces used for intendation as help parsing.
    Usually, every new element, that starts with &lt; will be followed by none or more lines, that have two spaces added in the beginning.
    Example of a MediaItemStateChunk(I use . to display the needed spaces in the beginning of each line):
    <pre><code>
    &lt;ITEM
    ..POSITION 6.96537864205337
    ..SNAPOFFS 0
    ..LENGTH 1745.2745
    ..LOOP 0
    ..ALLTAKES 0
    ..FADEIN 1 0.01 0 1 0 0
    ..FADEOUT 1 0.01 0 1 0 0
    ..MUTE 0
    ..SEL 1
    ..IGUID {020E6372-97E6-4066-9010-B044F67F2772}
    ..IID 1
    ..NAME myaudio.flac
    ..VOLPAN 1 0 1 -1
    ..SOFFS 0
    ..PLAYRATE 1 1 0 -1 0 0.0025
    ..CHANMODE 0
    ..GUID {79F087CE-49E8-4212-91F5-8487FBCF10B1}
    ..&lt;SOURCE FLAC
    ....FILE "C:\Users\meo\Desktop\X_Karo_Lynn-Interview.flac"
    ..&gt;
    &gt;
    </code></pre>
    
    This function will not check, if you've passed a valid statechunk!
    
    returns nil in case of an error
  </description>
  <parameters>
    string statechunk - a statechunk, that you want to layout properly
  </parameters>
  <retvals>
    string layouted_statechunk - the statechunk, that is now layouted to the rules of rpp-projectfiles
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, layout, statechunk</tags>
</US_DocBloc>
]]

  if type(statechunk)~="string" then ultraschall.AddErrorMessage("StateChunkLayouter","statechunk", "must be a string", -1) return nil end  
  local num_tabs=0
  local newsc=""
  for k in string.gmatch(statechunk, "(.-\n)") do
    if k:sub(1,1)==">" then num_tabs=num_tabs-1 end
    for i=0, num_tabs-1 do
      newsc=newsc.."  "
    end
    if k:sub(1,1)=="<" then num_tabs=num_tabs+1 end
    newsc=newsc..k
  end
  return newsc
end


function ultraschall.CountUltraschallEffectPlugins(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountUltraschallEffectPlugins</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer num_studiolink, table studiolink_bypass_state, integer num_studiolink_onair, table studiolink_onair_bypass_state, integer num_soundboard, table soundboard_bypass_state, integer num_usdynamics, table usdynamics_bypass_state = ultraschall.CountUltraschallEffectPlugins(integer track)</functioncall>
  <description>
    Counts the number of loaded StudioLink-plugins, StudioLink_OnAir-plugins, Ultraschall-Soundboards and Ultraschall_Dynamics-instances in this track.
    It also returns the bypass/offline-states of each plugin as a table, of the following format:    
      <pre><code>
        bypass_state_table[plugin_index][1]=bypass state; 1, plugin-instance is bypassed; 0, plugin-instance is normal
        bypass_state_table[plugin_index][2]=offline state; 1, plugin-instance is offline; 0, plugin-instance is online
        bypass_state_table[plugin_index][3]=unknown state(needs documentation first); 0, default setting
      </code></pre>
    Probably only helpful, if you've installed these plugins or using Ultraschall.
    
    returns -1 in case of an error
  </description>
  <parameters>
    integer track - the tracknumber, whose plugin-counts/bypass-states you want to get; 0, Master Track; 1 and higher, Track 1 an higher
  </parameters>
  <retvals>
    integer num_studiolink - the number of loaded StudioLink-plugins in this track
    table studiolink_bypass_state - the bypass-states of StudioLink in this track
    integer num_studiolink_onair - the number of loaded StudioLink_OnAir-plugins in this track
    table studiolink_onair_bypass_state - the bypass-states of StudioLink_OnAir in this track
    integer num_soundboard - the number of loaded Ultraschall Soundboard-plugins in this track
    table soundboard_bypass_state - the bypass-states of the Ultraschall Soundboard in this track
    integer num_usdynamics - the number of loaded Ultraschall_Dynamics-plugins in this track
    table usdynamics_bypass_state - the bypass-states of Ultraschall_Dynamics in this track
  </retvals>
  <chapter_context>
    FX/Plugin Management
    Ultraschall-related
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>fx_pluginmanagement, count, get, studiolink, studiolinkonair, soundboard, ultraschall_dynamics, bypass-state, offline-state</tags>
</US_DocBloc>
]]
  local MediaTrack
  if math.type(track)~="integer" then ultraschall.AddErrorMessage("CountUltraschallEffectPlugins", "track", "must be an integer", -1) return -1 end
  if track==0 then MediaTrack=reaper.GetMasterTrack(0) else MediaTrack=reaper.GetTrack(0, track-1) end
  if MediaTrack==nil then ultraschall.AddErrorMessage("CountUltraschallEffectPlugins", "track", "no such track", -2) return -1 end
  local num_sl=0
  local sl_byp={}
  local num_slonair=0
  local slonair_byp={}
  local num_soundboard=0
  local soundboard_byp={}
  local num_usdynamics=0
  local usdynamics_byp={}
  local lastbypassline=""

  local A,B=reaper.GetTrackStateChunk(MediaTrack,"",false)
  
  for k in string.gmatch(B,"(.-\n)") do
    if k:match("<.-StudioLinkOnAir ")~=nil then 
      num_slonair=num_slonair+1 
      slonair_byp[num_slonair]={lastbypassline:match(" (%d) (%d) (%d)")} 
      slonair_byp[num_slonair][1]=tonumber(slonair_byp[num_slonair][1]) 
      slonair_byp[num_slonair][2]=tonumber(slonair_byp[num_slonair][2]) 
      slonair_byp[num_slonair][3]=tonumber(slonair_byp[num_slonair][3]) 
    elseif k:match("<.-StudioLink ")~=nil then 
      num_sl=num_sl+1 
      sl_byp[num_sl]={lastbypassline:match(" (%d) (%d) (%d)")} 
      sl_byp[num_sl][1]=tonumber(sl_byp[num_sl][1]) 
      sl_byp[num_sl][2]=tonumber(sl_byp[num_sl][2]) 
      sl_byp[num_sl][3]=tonumber(sl_byp[num_sl][3])
    elseif k:match("<.-Soundboard %(Ultraschall%)")~=nil then 
      num_soundboard=num_soundboard+1
      soundboard_byp[num_soundboard]={lastbypassline:match(" (%d) (%d) (%d)")} 
      soundboard_byp[num_soundboard][1]=tonumber(soundboard_byp[num_soundboard][1]) 
      soundboard_byp[num_soundboard][2]=tonumber(soundboard_byp[num_soundboard][2]) 
      soundboard_byp[num_soundboard][3]=tonumber(soundboard_byp[num_soundboard][3]) 
    elseif k:match("<.-Ultraschall_Dynamics")~=nil then 
      num_usdynamics=num_usdynamics+1 
      usdynamics_byp[num_usdynamics]={lastbypassline:match(" (%d) (%d) (%d)")} 
      usdynamics_byp[num_usdynamics][1]=tonumber(usdynamics_byp[num_usdynamics][1]) 
      usdynamics_byp[num_usdynamics][2]=tonumber(usdynamics_byp[num_usdynamics][2]) 
      usdynamics_byp[num_usdynamics][3]=tonumber(usdynamics_byp[num_usdynamics][3]) 
    elseif k:match("BYPASS %d %d %d%c")~=nil then lastbypassline=k
    end
  end
  return num_sl, sl_byp, num_slonair, slonair_byp, num_soundboard, soundboard_byp, num_usdynamics, usdynamics_byp
end

function print2(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>print2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>print2(parameter_1 to parameter_n)</functioncall>
  <description>
    replaces Lua's own print-function. Converts all parametes given into string using tostring() and displays them as a MessageBox, separated by two spaces.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, messagebox</tags>
</US_DocBloc>
]]

  local string=""
  local count=1
  local temp={...}
  while temp[count]~=nil do
    string=string.."  "..tostring(temp[count])
    count=count+1
  end
  reaper.MB(string:sub(3,-1),"Print",0)
end

--print("Hula","Hoop",reaper.GetTrack(0,0))
--print("tudel")

function print(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>print</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>print(parameter_1 to parameter_n)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    like the [print](#print)-replacement-function, but outputs the parameters to the ReaScript-console instead. 
    
    Converts all parametes given into string using tostring() and displays them in the ReaScript-console, separated by two spaces, ending with a newline.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, console</tags>
</US_DocBloc>
]]

  local string=""
  local count=1
  local temp={...}
  while temp[count]~=nil do
    string=string.."  "..tostring(temp[count])
    count=count+1
  end
  reaper.ShowConsoleMsg(string:sub(3,-1).."\n","Print",0)
end

--print2("Hula","Hoop",reaper.GetTrack(0,0))
--print("tudel")


function ultraschall.GetTopmostHWND(hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTopmostHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>HWND topmost_hwnd, integer number_of_parent_hwnd, table all_parent_hwnds = ultraschall.GetTopmostHWND(HWND hwnd)</functioncall>
  <description>
    returns the topmost-parent hwnd of a hwnd, as sometimes, hwnds are children of a higher hwnd. It also returns the number of parent hwnds available and a list of all parent hwnds for this hwnd.
    
    A hwnd is a window-handler, which contains all attributes of a certain window.
    
    returns nil in case of an error
  </description>
  <parameters>
    HWND hwnd - the HWND, whose topmost parent-HWND you want to have
  </parameters>
  <retvals>
    HWND hwnd - the top-most parent hwnd available
    integer number_of_parent_hwnd - the number of parent hwnds, that are above the parameter hwnd
    table all_parent_hwnds - all available parent hwnds, above the parameter hwnd, including the topmost-hwnd
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, hwnd, topmost, parent hwnd, get, count</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidHWND(hwnd)==false then ultraschall.AddErrorMessage("GetTopmostHWND", "hwnd", "not a valid hwnd", -1) return nil end
  local count=1
  local other_hwnds={}
  while reaper.JS_Window_GetParent(hwnd)~=nil do  
     hwnd=reaper.JS_Window_GetParent(hwnd)
     other_hwnds[count]=hwnd
     count=count+1
  end
  return hwnd, count-1, other_hwnds
end

--A,B,C,D=ultraschall.GetTopmostHWND(reaper.JS_Window_GetFocus())

--reaper.MB(tostring(A).."\n"..tostring(B).."\n"..reaper.JS_Window_GetTitle(C[1])..                                                reaper.JS_Window_GetTitle(C[2]).."\n","",0)
--                                              ..reaper.JS_Window_GetTitle(C[3]),"",0)


function ultraschall.GetReaperWindowAttributes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperWindowAttributes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>integer left, integer top, integer right, integer bottom, boolean active, boolean visible, string title, integer number_of_childhwnds, table childhwnds = ultraschall.GetReaperWindowAttributes()</functioncall>
  <description>
    returns many attributes of the Reaper Main-window, like position, size, active, visibility, childwindows
    
    A hwnd is a window-handler, which contains all attributes of a certain window.
    
    returns nil in case of an error
  </description>
  <parameters>
    HWND hwnd - the HWND, whose topmost parent-HWND you want to have
  </parameters>
  <retvals>
    integer left - the left position of the Reaper-window in pixels
    integer top - the top position of the Reaper-window in pixels
    integer right - the right position of the Reaper-window in pixels
    integer bottom - the bottom position of the Reaper-window in pixels
    boolean active - true, if the window is active(any child-hwnd of the Reaper-window has focus currently); false, if not
    boolean visible - true, Reaper-window is visible; false, Reaper-window is not visible
    string title - the current title of the Reaper-window
    integer number_of_childhwnds - the number of available child-hwnds that the Reaper-window currently has
    table childhwnds - a table with all child-hwnds in the following format:
                     -      childhwnds[index][1]=hwnd
                     -      childhwnds[index][2]=title
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, hwnd, reaper, main window, position, active, visible, child-hwnds</tags>
</US_DocBloc>
]]
  local hwnd=reaper.GetMainHwnd()
  local title = reaper.JS_Window_GetTitle(hwnd)
  local visible=reaper.JS_Window_IsVisible(hwnd)
  local num_child_windows, child_window_list = reaper.JS_Window_ListAllChild(hwnd)
  local childwindows={}
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(child_window_list)
  for i=1, count do
    childwindows[i]={}
    childwindows[i][1]=reaper.JS_Window_HandleFromAddress(individual_values[i])
    childwindows[i][2]=reaper.JS_Window_GetTitle(childwindows[i][1])
  end
  
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)

  local hwnd_temp=ultraschall.GetTopmostHWND(reaper.JS_Window_GetFocus())
  if hwnd_temp==hwnd then active=true else active=false end
  
  return left, top, right, bottom, active, visible, title, count, childwindows
end



--retval, number position, number pageSize, number min, number max, number trackPos = reaper.JS_Window_GetScrollInfo(identifier windowHWND, string scrollbar)

--A,B,C,D,E,F,G,H,I,J=ultraschall.GetReaperWindowAttributes()
--reaper.MB(tostring(A).." "..tostring(B).." "..tostring(C).." "..tostring(D).." "..tostring(E).." "..tostring(F).." "..tostring(G).." "..tostring(H).." "..tostring(I),"",0)

function ultraschall.ReverseEndianess_Byte(byte)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReverseEndianess_Byte</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer newbyte = ultraschall.ReverseEndianess_Byte(integer byte)</functioncall>
  <description>
    reverses the endianess of a byte and returns this as value.
    The parameter byte must be between 0 and 255!
    
    returns nil in case of an error
  </description>
  <parameters>
    integer byte - the integer whose endianess you want to reverse
  </parameters>
  <retvals>
    integer newbyte - the endianess-reversed byte
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, integer, endianess</tags>
</US_DocBloc>
]]
  if math.type(byte)~="integer" then ultraschall.AddErrorMessage("ReverseEndianess_Byte", "byte", "must be an integer", -1) return end
  if byte<0 or byte>255 then ultraschall.AddErrorMessage("ReverseEndianess_Byte", "byte", "must be between 0 and 255", -2) return end
  
  local newbyte=0
  if byte&1~=0 then newbyte=newbyte+128 end
  if byte&2~=0 then newbyte=newbyte+64 end
  if byte&4~=0 then newbyte=newbyte+32 end
  if byte&8~=0 then newbyte=newbyte+16 end
  if byte&16~=0 then newbyte=newbyte+8 end
  if byte&32~=0 then newbyte=newbyte+4 end
  if byte&64~=0 then newbyte=newbyte+2 end
  if byte&128~=0 then newbyte=newbyte+1 end
  return newbyte
end


function ultraschall.Windows_Find(title, exact)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Windows_Find</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer count_hwnds, array hwnd_array, array hwnd_adresses = ultraschall.Windows_Find(string title, boolean strict)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all Reaper-window-HWND-handler, with a given title. Can be further used with the JS_Window_functions of the JS-function-plugin.
    
    Doesn't return IDE-windows! Use [GetAllReaScriptIDEWindows](#GetAllReaScriptIDEWindows) to get them.
  </description>
  <parameters>
    integer count_hwnds - the number of windows found
    array hwnd_array - the hwnd-handler of all found windows
    array hwnd_adresses - the adresses of all found windows
  </parameters>
  <retvals>
    string title - the title the window has
    boolean strict - true, if the title must be exactly as given by parameter title; false, only parts of a windowtitle must match parameter title
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, find, hwnd, windows, reaper</tags>
</US_DocBloc>
]]
  if type(title)~="string" then ultraschall.AddErrorMessage("Windows_Find", "title", "must be a string", -1) return -1 end
  if type(exact)~="boolean" then ultraschall.AddErrorMessage("Windows_Find", "exact", "must be a boolean", -2) return -1 end
  local retval, list = reaper.JS_Window_ListFind(title, exact)
  local list=list..","
  local hwnd_list={}
  local hwnd_list2={}
  local count=0
  for i=1, retval do
    local temp,offset=list:match("(.-),()")
    local temphwnd=reaper.JS_Window_HandleFromAddress(temp)
    parenthwnd=reaper.JS_Window_GetParent(temphwnd)
    while parenthwnd~=nil do
      if parenthwnd==reaper.GetMainHwnd() then
        count=count+1
        hwnd_list[count]=temphwnd
        hwnd_list2[count]=temp
      end    
      parenthwnd=reaper.JS_Window_GetParent(parenthwnd)
    end
    if Tudelu~=nil then
    end
    list=list:sub(offset,-1)
  end
  return count, hwnd_list, hwnd_list2
end

--A,B,C=ultraschall.Windows_Find("Reaper", false)

--gfx.init(" - ReaScript Development Environment")

function ultraschall.GetAllReaScriptIDEWindows()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllReaScriptIDEWindows</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer count_ide_hwnds, array ide_hwnd_array, array ide_titles = ultraschall.GetAllReaScriptIDEWindows()</functioncall>
  <description>
    Returns the hwnds and all titles of all Reaper-IDE-windows currently opened.
  </description>
  <retvals>
    integer count_ide_hwnds - the number of windows found
    array ide_hwnd_array - the hwnd-handler of all found windows
    array ide_titles - the titles of all found windows
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, get, hwnd, windows, reaper, ide</tags>
</US_DocBloc>
]]
  local retval, list = reaper.JS_Window_ListFind("ReaScript Development Environment", false)
  local list=list..","
  local IDE_Array={}
  local IDE_Array_Title={}
  local count=0
  
  local temphwnd, retval2, list2, temp
  
  for i=1, retval do
    temphwnd=reaper.JS_Window_HandleFromAddress(list:match("(.-),"))
    if reaper.JS_Window_GetTitle(temphwnd):match(" - ReaScript Development Environment")~=nil then
      retval2, list2 = reaper.JS_Window_ListAllChild(temphwnd)
      list2=list2..","
      if retval2>0 then    
        temp={}
        for i=1, retval-1 do
          temp[0]=reaper.JS_Window_HandleFromAddress(list2:match("(.-),"))
          temp[i]=reaper.JS_Window_GetTitle(temp[0])
          list2=list2:match(",(.*)")
        end
        
        count=count+1
        IDE_Array[count]=temp[0]
        IDE_Array_Title[count]=reaper.JS_Window_GetTitle(temphwnd)
      end
    end
    list=list:match(",(.*)")
  end
  return count, IDE_Array, IDE_Array_Title
end


--PP,PPP,PPPP=ultraschall.GetAllReaScriptIDEWindows()

function ultraschall.GetReaScriptConsoleWindow()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaScriptConsoleWindow</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND reascript_console_hwnd = ultraschall.GetReaScriptConsoleWindow()</functioncall>
  <description>
    Returns the hwnd of the ReaScript-Console-window, if opened.
    
    returns nil when ReaScript-console isn't opened
  </description>
  <retvals>
    HWND reascript_console_hwnd - the window-handler to the ReaScript-console, if opened
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>window, get, hwnd, windows, reaper, console</tags>
</US_DocBloc>
]]
  local A,A1=ultraschall.Windows_Find("ReaScript console output", true)
  
  for i=1, A do
    local B=reaper.JS_Window_GetParent(A1[i])

    local T0=reaper.JS_Window_GetTitle(A1[i])
    local retval, List = reaper.JS_Window_ListAllChild(A1[i])
    if retval>0 then
      if B==reaper.GetMainHwnd() then return A1[i] end
    end
  end
  return nil
end


function ultraschall.IsReaperRendering()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsReaperRendering</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional number render_position, optional number render_projectlength, optional ReaProject proj, optional boolean queue_render = ultraschall.IsReaperRendering()</functioncall>
  <description>
    Returns, if Reaper is currently rendering and the rendering position and projectlength of the rendered project
  </description>
  <retvals>
    boolean retval - true, Reaper is rendering; false, Reaper does not render
    optional number render_position - the current rendering-position of the rendering project
    optional number render_projectlength - the length of the currently rendering project
    optional ReaProject proj - the project currently rendering
    optional boolean queue_render - true, if a project from the queued-folder is currently being rendered; false, if not; a hint if queued-rendering is currently active
  </retvals>
  <chapter_context>
    Rendering of Project
    Assistance functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>rendering, get, current, renderstate, queued</tags>
</US_DocBloc>
]]
  local A,B=reaper.EnumProjects(0x40000000,"")  
  if A~=nil then 
    if B:match("^"..reaper.GetResourcePath()..ultraschall.Separator.."QueuedRenders"..ultraschall.Separator.."qrender_%d%d%d%d%d%d_%d%d%d%d%d%d")~=nil then queue=true else queue=false end
    return true, reaper.GetPlayPositionEx(A), reaper.GetProjectLength(A), A, queue
  else return false 
  end
end

--function main()
--  C,C1,C2,D,E=ultraschall.IsReaperRendering()
--  reaper.defer(main)
--end
--main()

function ultraschall.GetAllRecursiveFilesAndSubdirectories(path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllRecursiveFilesAndSubdirectories</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer found_dirs, array dirs_array, integer found_files, array files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(string path)</functioncall>
  <description>
    Returns all subdirectories and files within a given path.
    
    Might take some time with many folders/files.
    
    
    Returns -1 in case of an error.
  </description>
  <parameters>
    string path - the path from where to retrieve the files and subdirectories
  </parameters>
  <retvals>
    integer found_dirs - the number of directories found; -1, in case of an error
    array dirs_array - the full path to the found directories as an array
    integer found_files - the number of files found
    array files_array - the full path to the found files as an array
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>file management, get, all, files, directories, folder, subfolder, subdirectories, path, recursive</tags>
</US_DocBloc>
]]
  if type(path)~="string" then ultraschall.AddErrorMessage("GetAllRecursiveFilesAndSubdirectories", "path", "must be a string", -1) return -1 end
  if ultraschall.DirectoryExists2(path)==false then ultraschall.AddErrorMessage("GetAllRecursiveFilesAndSubdirectories", "path", "path is not a valid path", -2) return -1 end
  local Dirs={}
  local dirscount=1
  local dirsmaxcount=2
  
  Dirs[1]=path
  
  local Files={}
  local filescount=0
  
  while dirscount<dirsmaxcount do  
    local path=Dirs[dirscount]
    local temp=""
    local subdir=0
    while temp~=nil do
      temp=reaper.EnumerateSubdirectories(Dirs[dirscount],subdir)
      if temp~=nil then
        Dirs[dirsmaxcount]=path.."/"..temp
        dirsmaxcount=dirsmaxcount+1
      end
      subdir=subdir+1
    end
    dirscount=dirscount+1
  end
  
  local dircounter=1
  for i=1, dirsmaxcount do
    local counter=0
    while Dirs[dircounter]~=nil and reaper.EnumerateFiles(Dirs[dircounter],counter)~=nil do
      filescount=filescount+1
      Files[filescount]=Dirs[dircounter].."/"..reaper.EnumerateFiles(Dirs[dircounter],counter)
      counter=counter+1
    end
    dircounter=dircounter+1
  end
  
  return dirsmaxcount-1, Dirs, filescount, Files
end

--A,B,C,D=ultraschall.GetAllRecursiveFilesAndSubdirectories("L:\\")

function ultraschall.RippleCut_Regions(startposition, endposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RippleCut_Regions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean were_regions_altered, integer number_of_altered_regions, array altered_regions  = ultraschall.RippleCut_Regions(number startposition, number endposition)</functioncall>
  <description>
    Ripplecuts regions, where applicable.
    It cuts all (parts of) regions between startposition and endposition and moves remaining parts plus all regions after endposition by endposition-startposition toward projectstart.
    
    Returns false in case of an error.
  </description>
  <parameters>
    number startposition - the startposition from where regions shall be cut from
    number endposition - the endposition to which regions shall be cut from; all regions/parts of regions after that will be moved toward projectstart
  </parameters>
  <retvals>
    boolean were_regions_altered - true, if regions were cut/altered; false, if not
    integer number_of_altered_regions - the number of regions that were altered/cut/moved
    array altered_regions - the regions that were altered:
                          -   altered_regions_array[index_of_region][0] - old startposition
                          -   altered_regions_array[index_of_region][1] - old endposition
                          -   altered_regions_array[index_of_region][2] - name
                          -   altered_regions_array[index_of_region][3] - old indexnumber of the region within all markers in the project
                          -   altered_regions_array[index_of_region][4] - the shown index-number
                          -   altered_regions_array[index_of_region][5] - the color of the region
                          -   altered_regions_array[index_of_region][6] - the change that was applied to this region
                          -   altered_regions_array[index_of_region][7] - the new startposition
                          -   altered_regions_array[index_of_region][8] - the new endposition
  </retvals>
  <chapter_context>
    Markers
    General Markers and Regions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>marker management, ripple, cut, regions</tags>
</US_DocBloc>
]]
  if type(startposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions", "startposition", "must be a number", -1) return false end
  if type(endposition)~="number" then ultraschall.AddErrorMessage("RippleCut_Regions", "endposition", "must be a number", -2) return false end
  local dif=endposition-startposition
  
  -- get all regions, that are candidates for a ripplecut
  local number_of_all_regions, allregionsarray = ultraschall.GetAllRegionsBetween(startposition, reaper.GetProjectLength(0), true)  
  if number_of_all_regions==0 then ultraschall.AddErrorMessage("RippleCut_Regions", "", "no regions found within start and endit", -3) return false, regioncount, regionfound end
  
  -- make startposition and endposition with less precision, or we can't check, if startposition=pos
  -- Reaper seems to work with greater precision for floats than shown
  local start = ultraschall.LimitFractionOfFloat(startposition, 10, true)
  local endit = ultraschall.LimitFractionOfFloat(endposition, 10, true)
  
  -- some more preparation for variables, including localizing them
  local pos, rgnend, name, retval, markrgnindexnumber, color  
  local regionfound={}
  
  -- here comes the magic
  for i=number_of_all_regions, 1, -1 do
    -- get regionattributes from the allregionsarray we got before
     pos=allregionsarray[i][0]
     rgnend=allregionsarray[i][1]
     name=allregionsarray[i][2]
     retval=allregionsarray[i][3]
     markrgnindexnumber=allregionsarray[i][4]
     color = allregionsarray[i][5]
    -- make pos and rgnend with less precision, or we can't check, if startposition=pos
    -- Reaper seems to work with greater precision for floats than shown
    local pos1 = ultraschall.LimitFractionOfFloat(pos, 10, true)
    local rgnend1 = ultraschall.LimitFractionOfFloat(rgnend, 10, true)

    regionfound[i]={}
    regionfound[i][0]=allregionsarray[i][0]
    regionfound[i][1]=allregionsarray[i][1]
    regionfound[i][2]=allregionsarray[i][2]
    regionfound[i][3]=allregionsarray[i][3]
    regionfound[i][4]=allregionsarray[i][4]
    regionfound[i][5]=allregionsarray[i][5]

    -- let's do the checking and manipulation. We also create an array with all entries manipulated
    -- and in which way manipulated
    if pos1>=start and rgnend1<=endit then
      -- if region is fully within start and endit, cut it completely
      regionfound[i][6]="CUT COMPLETELY"
      reaper.DeleteProjectMarker(0, markrgnindexnumber, true)
    elseif pos1<start and rgnend1<=endit and rgnend1>start then
      -- if regionend is within start and endit, move the end to start
      regionfound[i][6]="CUT AT THE END"
      regionfound[i][7]=pos
      regionfound[i][8]=start
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos, start, name, color, 0)
    elseif pos1>=start and pos1<=endit and rgnend1>endit then
      -- if regionstart is within start and endit, shorten the region and move it by difference of start and endit
      --    toward projectstart
      regionfound[i][6]="CUT AT THE BEGINNING"
      regionfound[i][7]=endit-dif
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, endit-dif, rgnend-dif, name, color, 0)
    elseif pos1>=endit and rgnend1>=endit then 
      -- if region is after endit, just move the region by difference of start and endit toward projectstart
      regionfound[i][6]="MOVED TOWARD PROJECTSTART"
      regionfound[i][7]=pos-dif
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos-dif, rgnend-dif, name, color, 0)
    elseif start>=pos1 and endit<=rgnend then
      -- if start and endit is fully within a region, cut at the end of the region the difference of start and endit
      regionfound[i][6]="CUT IN THE MIDDLE"
      regionfound[i][7]=pos
      regionfound[i][8]=rgnend-dif
      reaper.SetProjectMarker4(proj, markrgnindexnumber, true, pos, rgnend-dif, name, color, 0)
    end
  end
  -- sort the table of found regions
  return true, regioncount, regionfound
end

--  A,B=reaper.GetSet_LoopTimeRange(false,true,0,0,false)
--  C,D,E=ultraschall.RippleCut_Regions(A, B)

--  number_of_all_regions, allregionsarray = ultraschall.GetAllRegionsBetween(A,B, true)

function ultraschall.ShowErrorMessagesInReascriptConsole(setting)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ShowErrorMessagesInReascriptConsole</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.ShowErrorMessagesInReascriptConsole(boolean state)</functioncall>
    <description>
      Sets, if errormessages shall be shown in the ReaScript-Console immediately, when they happen.
      
      Will show functionname, parametername, errorcode plus errormessage and the time the error has happened.
    </description>
    <parameters>
      boolean state - true, show error-messages in the ReaScript-Console when they happen; false, don't show errormessages
    </parameters>
    <chapter_context>
      Developer
      Error Handling
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, error, show, message, reascript, console</tags>
  </US_DocBloc>
  ]]
  if setting==true then ultraschall.ShowErrorInReaScriptConsole=true else ultraschall.ShowErrorInReaScriptConsole=false end
end


function ultraschall.ConvertIntegerIntoString(integervalue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertIntegerIntoString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string converted_value = ultraschall.ConvertIntegerIntoString(integer integervalue)</functioncall>
  <description>
    Splits an integer into its individual bytes and converts them into a string-representation.
    Only 32bit-integers are supported.
    
    Returns nil in case of an error.
  </description>
  <parameters>
    integer integervalue - the value to convert from
  </parameters>
  <retvals>
    string converted_value - the string-representation of the integer
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, integer, string</tags>
</US_DocBloc>
]]
  if math.type(integervalue)~="integer" then ultraschall.AddErrorMessage("ConvertIntegerIntoString", "integervalue", "must be an integer", -1) return end
  local Byte1, Byte2, Byte3, Byte4 = ultraschall.SplitIntegerIntoBytes(integervalue)
  local String=string.char(Byte1)..string.char(Byte2)..string.char(Byte3)..string.char(Byte4)
  return String
end

--A=ultraschall.ConvertIntegerIntoString(65)

function ultraschall.ConvertIntegerToBits(integer)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertIntegerToBits</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string bitvals_csv, table bitvalues = ultraschall.ConvertIntegerToBits(integer integer)</functioncall>
  <description>
    converts an integer-value(up to 64 bits) into it's individual bits and returns it as comma-separated csv-string as well as a table with 64 entries.
    
    returns nil in case of an error
  </description>
  <parameters>
    integer integer - the integer-number to separated into it's individual bits
  </parameters>
  <retvals>
    string bitvals_csv - a comma-separated csv-string of all bitvalues, with bit 1 coming first and bit 32 coming last
    table bitvalues - a 64-entry table, where each entry contains the bit-value of integer; first entry for bit 1, 64th entry for bit 64
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, integer, bit, bitfield</tags>
</US_DocBloc>
]]
  if math.type(integer)~="integer" then ultraschall.AddErrorMessage("ConvertIntegerToBits", "integer", "must be an integer-value up to 32 bits", -1) return nil end
  local Table={}
  local bitvals=""
  for i=1, 64 do
    Table[i]=integer&1
    bitvals=bitvals..(integer&1)..","
    integer=integer>>1
  end
  return bitvals:sub(1,-2), Table
end

function ultraschall.GetProject_RenderOutputPath(projectfilename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_RenderOutputPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string render_output_directory = ultraschall.GetProject_RenderOutputPath(string projectfilename_with_path)</functioncall>
  <description>
    returns the output-directory for rendered files of a project.

    Doesn't return the correct output-directory for queued-projects!
    
    returns nil in case of an error
  </description>
  <parameters>
    string projectfilename_with_path - the projectfilename with path, whose renderoutput-directories you want to know
  </parameters>
  <retvals>
    string render_output_directory - the output-directory for projects
  </retvals>
  <chapter_context>
    Project-Files
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>render management, get, project, render, outputpath</tags>
</US_DocBloc>
]]
  if type(projectfilename_with_path)~="string" then ultraschall.AddErrorMessage("GetProject_RenderOutputPath", "projectfilename_with_path", "must be a string", -1) return nil end
  if reaper.file_exists(projectfilename_with_path)==false then ultraschall.AddErrorMessage("GetProject_RenderOutputPath", "projectfilename_with_path", "file does not exist", -2) return nil end
  local ProjectStateChunk=ultraschall.ReadFullFile(projectfilename_with_path)
  local QueueRendername=ProjectStateChunk:match("(QUEUED_RENDER_OUTFILE.-)\n")
  local QueueRenderProjectName=ProjectStateChunk:match("(QUEUED_RENDER_ORIGINAL_FILENAME.-)\n")
  local OutputRender, RenderPattern, RenderFile
  
  if QueueRendername~=nil then
    QueueRendername=QueueRendername:match(" \"(.-)\" ")
    QueueRendername=ultraschall.GetPath(QueueRendername)
  end
  
  if QueueRenderProjectName~=nil then
    QueueRenderProjectName=QueueRenderProjectName:match(" (.*)")
    QueueRenderProjectName=ultraschall.GetPath(QueueRenderProjectName)
  end


  RenderFile=ProjectStateChunk:match("(RENDER_FILE.-)\n")
  if RenderFile~=nil then
    RenderFile=RenderFile:match("RENDER_FILE (.*)")
    RenderFile=string.gsub(RenderFile,"\"","")
  end
  
  RenderPattern=ProjectStateChunk:match("(RENDER_PATTERN.-)\n")
  if RenderPattern~=nil then
    RenderPattern=RenderPattern:match("RENDER_PATTERN (.*)")
    if RenderPattern~=nil then
      RenderPattern=string.gsub(RenderPattern,"\"","")
    end
  end

  -- get the normal render-output-directory
  if RenderPattern~=nil and RenderFile~=nil then
    if ultraschall.DirectoryExists2(RenderFile)==true then
      OutputRender=RenderFile
    else
      OutputRender=ultraschall.GetPath(projectfilename_with_path)..ultraschall.Separator..RenderFile
    end
  elseif RenderFile~=nil then
    OutputRender=ultraschall.GetPath(RenderFile)    
  else
    OutputRender=ultraschall.GetPath(projectfilename_with_path)
  end


  -- get the potential RenderQueue-renderoutput-path
  -- not done yet...todo
  -- that way, I may be able to add the currently opened projects as well...
--[[
  if RenderPattern==nil and (RenderFile==nil or RenderFile=="") and
     QueueRenderProjectName==nil and QueueRendername==nil then
    QueueOutputRender=ultraschall.GetPath(projectfilename_with_path)
  elseif RenderPattern~=nil and RenderFile~=nil then
    if ultraschall.DirectoryExists2(RenderFile)==true then
      QueueOutputRender=RenderFile
    end
  end
  --]]
  
  OutputRender=string.gsub(OutputRender,"\\\\", "\\")
  
  return OutputRender, QueueOutputRender
end

--A="c:\\Users\\meo\\Desktop\\trss\\20Januar2019\\rec\\rec3.RPP"

--B,C=ultraschall.GetProject_RenderOutputPath()

function ultraschall.GetSetIntConfigVar(varname, set, ...)  
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetSetIntConfigVar</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      SWS=2.9.7
      Lua=5.3
    </requires>
    <functioncall>boolean retval, integer config_var_value = ultraschall.GetSetIntConfigVar(string varname, boolean set, optional boolean bit1, ..., optional boolean bit32)</functioncall>
    <description>
      Gets/Sets an integer-bitfield of an integer-configvariable.
      
      Pass to it a varname, if it shall be set or gotten from and up to 32 parameters who specify, if that bit shall be set(true) or not(false) or the currently set value shall be used(nil)
      
      See <a href="Reaper_Config_Variables.html">Reaper_Config_Variables.html</a> for more details on config-variables in Reaper.
      
      returns false in case of an error
    </description>
    <parameters>
      string varname - the name of the config-variable
      boolean set - true, set this config-var; false, don't set it
      optional boolean bit1 - true, set this bit; false, don't set this bit; nil, use the currently set value
      ...                   - true, set this bit; false, don't set this bit; nil, use the currently set value
      optional boolean bit32 - true, set this bit; false, don't set this bit; nil, use the currently set value
    </parameters>
    <retvals>
      boolean retval - true, getting/setting the config-var was successful; false, it wasn't successful
      integer config_var_value - the new/current value of the configuration-variable
    </retvals>
    <chapter_context>
      API-Helper functions
      Data Manipulation
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>helper functions, get, set, configvar, integer, bit, bitfield</tags>
  </US_DocBloc>
  ]]
  
  -- check parameters
  local oldval=reaper.SNM_GetIntConfigVar(varname,-99)
  local oldval2=reaper.SNM_GetIntConfigVar(varname,-98)
  local parms={...}
  if type(varname)~="string" then ultraschall.AddErrorMessage("GetSetIntConfigVar", "varname", "must be a string", -1) return false end
  if oldval~=oldval2 then ultraschall.AddErrorMessage("GetSetIntConfigVar", "varname", "no such config-variable", -2) return false end
  if type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetIntConfigVar", "set", "must be a boolean", -3) return false end
  local newval=0
  
  -- if setting config-variable is set to true, create that new value
  -- and set it
  if set==true then
    for i=0, 32 do
      -- if one of the parameters isn't nil or boolean, return with false, leaving the configvar untouched
      if parms[i]~=nil and parms[i]~=true and parms[i]~=false then ultraschall.AddErrorMessage("GetSetIntConfigVar", "bit"..i, "must be either a boolean or nil(to keep currently set value)", -4) return false end
    end    
    
    for i=32, 1, -1 do
      -- create the newval
      -- if parameter is set to nil, use the specifiv bit-value from the original config-var-value
      newval = newval << 1
      if parms[i]==true then newval=newval+1
      elseif parms[i]==nil and oldval&2^i~=0 then newval=newval+1 end
    end
    
    return reaper.SNM_SetIntConfigVar(varname, newval), math.floor(newval)
  else
    return true, math.floor(oldval)
  end
end


--O,O2=ultraschall.GetSetIntConfigVar("mixeruiflag", true, true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true, true,true,true,true,true,true,true,true,true,true)

--reaper.CF_SetClipboard(reaper.genGuid())


function ultraschall.GetScriptIdentifier()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetScriptIdentifier</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string script_identifier = ultraschall.GetScriptIdentifier()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      The identifier is of the format "ScriptIdentifier:scriptfilename-{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}.ext", where the {}-part is a guid and ext either .lua .py or .eel
      
      [Defer1](#Defer1) to [Defer20](#Defer20) make use of this to stop a running defer-loop from the outside of a deferred-script.
    </description>
    <retvals>
      string script_identifier - a unique script-identifier for this script-instance, of the format:
                               - ScriptIdentifier: scriptfilename-guid
    </retvals>
    <chapter_context>
      API-Helper functions
      Data Manipulation
    </chapter_context>
    <target_document>US_Api_Documentation</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>helper functions, get, script_identifier</tags>
  </US_DocBloc>
  ]]

  return ultraschall.ScriptIdentifier
end

--O=ultraschall.GetScriptIdentifier()

function ultraschall.GetDeferIdentifier(deferinstance)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetDeferIdentifier</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string defer_identifier = ultraschall.GetDeferIdentifier(integer deferinstance)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      returns the identifier for a specific ultraschall-defer-function.
      
      This can be used to stop this defer-loop from the in- and outside of the script.
      
      returns nil in case of an error.
    </description>
    <retvals>
      string defer_identifier - a specific and unique defer-identifier for this script-instance, of the format:
                               - ScriptIdentifier: scriptfilename-guid.ext.deferXX
                               - where XX is the defer-function-number. XX is between 1 and 20
    </retvals>
    <parameters>
      integer deferinstance - the defer-instance, whose identifier you want; 1 to 20
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
  if deferinstance<10 then zero="0" else zero="" end
  return ultraschall.GetScriptIdentifier()..".defer_script"..zero..deferinstance
end

--A=ultraschall.GetDeferIdentifier(2)

--reaper.CF_SetClipboard(A)

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

function main()

end

--A,B=ultraschall.Defer1(main,1,1)
--reaper.CF_SetClipboard(B)


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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc2)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc3)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc4)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc5)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc6)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc7)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc8)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc9)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc10)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc11)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc12)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc13)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc14)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc15)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc16)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc17)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc18)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc19)~="function" then 
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
  ]]  if type(func)~="function" and type(ultraschall.deferfunc20)~="function" then 
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



function ultraschall.GetTrackSelection_TrackStateChunk(TrackStateChunk)
-- returns the trackname as a string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackSelection_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer selection_state = ultraschall.GetTrackSelection_TrackStateChunk(string TrackStateChunk)</functioncall>
  <description>
    returns selection of the track.    
    
    It's the entry SEL.
    
    Works only with statechunks stored in ProjectStateChunks, due API-limitations!
  </description>
  <retvals>
    integer selection_state - 0, track is unselected; 1, track is selected
  </retvals>
  <parameters>    
    string TrackStateChunk - a TrackStateChunk whose selection-state you want to retrieve; works only with TrackStateChunks from ProjectStateChunks!
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, selection, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackSelection", "TrackStateChunk", "no valid TrackStateChunk", -1) return nil end
  
  -- get selection
  local Track_Name=str:match(".-SEL (.-)%c.-REC")
  return tonumber(Track_Name)
end

--A=ultraschall.GetProjectStateChunk()
--B=ultraschall.GetProject_TrackStateChunk(nil, 1, false, A)


--C=ultraschall.GetTrackSelection(-1,B)

function ultraschall.SetTrackSelection_TrackStateChunk(selection_state, TrackStateChunk)
-- returns the trackname as a string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTrackSelection_TrackStateChunk</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string alteredTrackStateChunk = ultraschall.SetTrackSelection_TrackStateChunk(integer selection_state, string TrackStateChunk)</functioncall>
  <description>
    set selection of the track in a TrackStateChunk.    
    
    It's the entry SEL.
    
    Works only with statechunks stored in ProjectStateChunks, due API-limitations!
  </description>
  <retvals>
    string alteredTrackStateChunk - the altered TrackStateChunk with the new selection
  </retvals>
  <parameters>    
    integer selection_state - 0, track is unselected; 1, track is selected
    string TrackStateChunk - a TrackStateChunk whose selection-state you want to set; works only with TrackStateChunks from ProjectStateChunks!
  </parameters>
  <chapter_context>
    Track Management
    Get Track States
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>trackmanagement, selection, state, get, trackstatechunk</tags>
</US_DocBloc>
--]]

  -- check parameters
  if ultraschall.IsValidTrackStateChunk(TrackStateChunk)==false then ultraschall.AddErrorMessage("GetTrackSelection", "TrackStateChunk", "no valid TrackStateChunk", -1) return nil end
  if math.type(selection_state)~="integer" then ultraschall.AddErrorMessage("GetTrackSelection", "selection_state", "must be an integer", -2) return nil end
  if selection_state<0 or selection_state>1 then ultraschall.AddErrorMessage("GetTrackSelection", "selection_state", "must be either 0 or 1", -3) return nil end
  
  -- set selection
  local Start=TrackStateChunk:match(".-FREEMODE.-\n")
  local End=TrackStateChunk:match("REC.*")
  return Start.."    SEL "..selection_state.."\n    "..End
end

--A=ultraschall.GetProjectStateChunk()
--B=ultraschall.GetProject_TrackStateChunk(nil, 1, false, A)

--C=ultraschall.SetTrackSelection_TrackStateChunk(1, B)
--print2(C)

function ultraschall.GetIniFileValue(section, key, errval, inifile)
-- returns the trackname as a string
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetIniFileValue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer length_of_value, string value = ultraschall.GetIniFileValue(string section, string key, string errval, string inifile)</functioncall>
  <description>
    Gets a value from a key of an ini-file
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer length_of_value - the length of the value in bytes
    string value - the value from the key-value-pair
  </retvals>
  <parameters>    
    string section - the section, in which the key-value-pair is located
    string key - the key whose value you want
    string errval - an errorvalue, which will be shown, if key-value-store doesn't exist
    string inifile - the ini-file, from which you want to retrieve the key-value-store
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>inifilemanagement, get, key, value, section</tags>
</US_DocBloc>
--]]
  if type(inifile)~="string" then ultraschall.AddErrorMessage("GetIniFileValue", "inifile", "must be a string", -1) return -1 end
  if section==nil then ultraschall.AddErrorMessage("GetIniFileValue", "section", "must be a string", -2) return -1 end
  if key==nil then ultraschall.AddErrorMessage("GetIniFileValue", "key", "must be a string", -3) return -1 end
  if errval==nil then errval="" end
  section=tostring(section)
  key=tostring(key)

  local A=ultraschall.ReadFullFile(inifile).."\n["
  
  local SectionArea=A:match(section.."%](.-)\n%[").."\n"
  local KeyValue=SectionArea:match("\n"..key.."=(.-)\n")
  if KeyValue==nil then KeyValue=errval end
  return KeyValue:len(), KeyValue
end



--A=ultraschall.GetIniFileValue("section", "key", "LULATSCH", reaper.get_ini_file():match("(.-)REAPER.ini").."ultraschall.ini")


function ultraschall.SetIniFileValue(section, key, value, inifile)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetIniFileValue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetIniFileValue(string section, string key, string value, string inifile)</functioncall>
  <description>
    Sets a value of a key in an ini-file
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - -1, in case of an error; 1, in case of success
  </retvals>
  <parameters>    
    string section - the section, in which the key-value-pair is located
    string key - the key whose value you want to change
    string value - the new value for this key-value-pair
    string inifile - the ini-file, in which you want to set the key-value-store
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>inifilemanagement, set, key, value, section</tags>
</US_DocBloc>
--]]
  if type(inifile)~="string" then ultraschall.AddErrorMessage("SetIniFileValue", "inifile", "must be a string", -1) return -1 end
  if section==nil then ultraschall.AddErrorMessage("SetIniFileValue", "section", "must be a string", -2) return -1 end
  if key==nil then ultraschall.AddErrorMessage("SetIniFileValue", "key", "must be a string", -3) return -1 end
  if value==nil then ultraschall.AddErrorMessage("SetIniFileValue", "value", "must be a string", -4) return -1 end
  section=tostring(section)
  key=tostring(key)
  value=tostring(value)
  
  local Start, Middle, Ende, A, Kombi, Offset
  local A=ultraschall.ReadFullFile(inifile)
  if A==nil then A="" end
  if A:match("%["..section.."%]")~=nil then
    A=A.."\n["
    Start=A:match("(.*)%["..section)
    Middle, Offset=A:match("(%["..section.."%].-)()%[")
    Ende=A:sub(Offset,-2)
    
    if Middle:match(key)~=nil then
      Middle=string.gsub(Middle, key.."=.-\n", key.."="..value.."\n")
    else
      Middle=Middle..key.."="..value.."\n\n"
      Ende="\n"..Ende
    end
     
  else
    Start=A
    Middle="\n"
    Ende="["..section.."]\n"..key.."="..value.."\n"
  end
  Kombi=string.gsub(Start..Middle..Ende, "\n\n", "\n")
  local ustemp=ultraschall.WriteValueToFile(inifile, Kombi)
  if ustemp==1 then return true else return false end
end

--A1=ultraschall.SetIniFileValue(file:match("(.-)REAPER.ini").."lula.ini", "ultrascshall_update", "D", "1")

function ultraschall.GetLoopState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetLoopState()</functioncall>
  <description>
    Returns the current loop-state
  </description>
  <retvals>
    integer retval - 0, loop is on; 1, loop is off
  </retvals>
  <chapter_context>
    Navigation
    Transport
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>transportmanagement, get, loop</tags>
</US_DocBloc>
--]]
  return reaper.GetToggleCommandState(1068)
end

--A=ultraschall.GetLoopState()

function ultraschall.SetLoopState(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetLoopState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetLoopState(integer state)</functioncall>
  <description>
    Sets the current loop-state
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if setting was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    integer state - 0, loop is on; 1, loop is off
  </parameters>
  <chapter_context>
    Navigation
    Transport
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>transportmanagement, set, loop</tags>
</US_DocBloc>
--]]
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("SetLoopState", "state", "must be an integer", -1) return false end
  if state~=0 and state~=1 then ultraschall.AddErrorMessage("SetLoopState", "state", "must be 1(on) or 0(off)", -2) return false end
  if ultraschall.GetLoopState()~=state then
    reaper.Main_OnCommand(1068, 0)
  end
  return true
end

--A=ultraschall.SetLoopState(0)

function ultraschall.GetVerticalScroll()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetVerticalScroll</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>integer vertical_scroll_factor = ultraschall.GetVerticalScroll()</functioncall>
  <description>
    Gets the current vertical_scroll_value. The valuerange is dependent on the vertical zoom.
  </description>
  <retvals>
    integer vertical_scroll_factor - the vertical-scroll-factor
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>arrangeviewmanagement, get, vertical, scroll factor</tags>
</US_DocBloc>
--]]
  local translation = reaper.JS_Localize("trackview", "DLG_102")
  local retval, position = reaper.JS_Window_GetScrollInfo(reaper.JS_Window_Find(translation, true), "SB_VERT")
  
  return position
end

--A=ultraschall.GetVerticalScroll()

function ultraschall.SetVerticalScroll(scrollposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetVerticalScroll</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetVerticalScroll(integer scrollposition)</functioncall>
  <description>
    Sets the vertical-scroll-factor.
    
    The possible value-range depends on the vertical-zoom.
    
    returns false in case of an error or if scrolling is impossible(e.g. zoomed out fully)
  </description>
  <retvals>
    boolean retval - true, if setting was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    integer scrollposition - the vertical scrolling-position
  </parameters>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>arrangeviewmanagement, set, vertical, scroll factor</tags>
</US_DocBloc>
--]]
  if math.type(position)~="integer" then ultraschall.AddErrorMessage("SetVerticalScroll", "scrollposition", "must be an integer", -1) return false end
  local translation = reaper.JS_Localize("trackview", "DLG_102")
  
  return reaper.JS_Window_SetScrollPos(reaper.JS_Window_Find(translation, true), "SB_VERT", scrollposition)
end

--A=ultraschall.SetVerticalScroll(2000000)

function ultraschall.GetUserInputs(title, caption_names, default_retvals, length)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUserInputs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer number_of_inputfields, table returnvalues = ultraschall.GetUserInputs(string title, table caption_names, table default_retvals, integer length)</functioncall>
  <description>
    Gets inputs from the user.
    
    The captions and the default-returnvalues must be passed as an integer-index table.
    e.g.
      caption_names[1]="first caption name"
      caption_names[2]="second caption name"
      caption_names[1]="*third caption name, which creates an inputfield for passwords, due the * at the beginning"
     
    returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, the user clicked ok on the userinput-window; false, the user clicked cancel or an error occured
    integer number_of_inputfields - the number of returned values; nil, in case of an error
    table returnvalues - the returnvalues input by the user as a table; nil, in case of an error
  </retvals>
  <parameters>
    string title - the title of the inputwindow
    table caption_names - a table with all inputfield-captions. All non-string-entries will be converted to string-entries. Begin an entry with a * for password-entry-fields.
    table default_retvals - a table with all default retvals. All non-string-entries will be converted to string-entries.
    integer length - the extralength of the user-inputfield. With that, you can enhance the length of the inputfields. 1-500
  </parameters>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>userinterface, dialog, get, user input</tags>
</US_DocBloc>
--]]
  if type(title)~="string" then ultraschall.AddErrorMessage("GetUserInputs", "title", "must be a string", -1) return false end
  if type(caption_names)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be a table", -2) return false end
  if type(default_retvals)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be a table", -3) return false end
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "length", "must be an integer", -4) return false end
  if length>500 or length<1 then ultraschall.AddErrorMessage("GetUserInputs", "length", "must be between 1 and 500", -5) return false end
  local count = ultraschall.CountEntriesInTable_Main(caption_names)
  length=(length*2)+18
  
  local captions=""
  local retvals=""
  
  for i=1, count do
    if caption_names[i]==nil then caption_names[i]="" end
    captions=captions..tostring(caption_names[i])..","
  end
  captions=captions:sub(1,-2)
  captions=captions..",extrawidth="..length
  
  for i=1, count do
    if default_retvals[i]==nil then default_retvals[i]="" end
    retvals=retvals..tostring(default_retvals[i])..","
  end
  retvals=retvals:sub(1,-2)  
  
  local retval, retvalcsv = reaper.GetUserInputs(title, count, captions, retvals)
  if retval==false then return false end
  return retval, ultraschall.CSV2IndividualLinesAsArray(retvalcsv) 
end

function ultraschall.CreateRenderCFG_AIFF(bits)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AIFF</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AIFF(integer bits)</functioncall>
  <description>
    Returns the render-cfg-string for the AIFF-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AIFF-settings
  </retvals>
  <parameters>
    integer bits - the bitrate of the aiff-file; 8, 16, 24 and 32 are supported
  </parameters>
  <chapter_context>
    Rendering of Project
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, aiff</tags>
</US_DocBloc>
]]
  if math.type(bits)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "must be an integer", -1) return nil end
  local renderstring="ZmZpY..AAA=="
  if bits==8 then renderstring=string.gsub(renderstring, "%.%.", "Qg")
  elseif bits==16 then renderstring=string.gsub(renderstring, "%.%.", "RA")
  elseif bits==24 then renderstring=string.gsub(renderstring, "%.%.", "Rg")
  elseif bits==32 then renderstring=string.gsub(renderstring, "%.%.", "SA")
  else ultraschall.AddErrorMessage("CreateRenderCFG_AIFF", "bits", "only 8, 16, 24 and 32 are supported by AIFF", -2) return nil
  end
  return renderstring
end


function ultraschall.CreateRenderCFG_AudioCD(trackmode, only_markers_starting_with_hash, leadin_silence_tracks, leadin_silence_disc, burncd_image_after_render)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CreateRenderCFG_AudioCD</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string render_cfg_string = ultraschall.CreateRenderCFG_AudioCD(integer trackmode, boolean only_markers_starting_with_hash, integer leadin_silence_tracks, integer leadin_silence_disc, boolean burncd_image_after_render)</functioncall>
  <description>
    Returns the render-cfg-string for the AudioCD-format. You can use this in ProjectStateChunks, RPP-Projectfiles and reaper-render.ini
    
    You can also check, whether to burn the created cd-image after rendering.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string render_cfg_string - the render-cfg-string for the selected AudioCD-image-settings
  </retvals>
  <parameters>
    integer trackmode - Track mode-dropdownlist: 1, Markers define new track; 2, Regions define tracks (other areas ignored); 3, One Track
    boolean only_markers_starting_with_hash - Only use markers starting with #-checkbox; true, checked; false, unchecked
    integer leadin_silence_tracks - Lead-in silence for tracks-inputbox, in milliseconds; 0 to 100000 supported by Ultraschall-API
    integer leadin_silence_disc - Extra lead-in silence for disc-inputbox, in milliseconds; 0 to 100000 supported by Ultraschall-API
    boolean burncd_image_after_render - Burn CD image after render-checkbox; true, checked; false, unchecked
  </parameters>
  <chapter_context>
    Rendering of Project
    Creating Renderstrings
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>projectfiles, create, render, outputformat, audiocd, cd, image, burn cd</tags>
</US_DocBloc>
]]

  local ini_file=ultraschall.Api_Path.."IniFiles/Reaper-Render-Codes-for-AudioCD.ini"
  if reaper.file_exists(ini_file)==false then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "Ooops", "external audio-cd-render-code-ini-file does not exist. Reinstall Ultraschall-API again, please!", -1) return nil end
  if math.type(trackmode)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "trackmode", "Must be an integer between 1 and 3!", -2) return nil end
  if type(only_markers_starting_with_hash)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "only_markers_starting_with_hash", "Must be a boolean!", -3) return nil end
  if math.type(leadin_silence_tracks)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_tracks", "Must be an integer!", -4) return nil end
  if math.type(leadin_silence_disc)~="integer" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_disc", "Must be an integer!", -5) return nil end
  if type(burncd_image_after_render)~="boolean" then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "burncd_image_after_render", "Must be a boolean!", -6) return nil end
  
  if trackmode<1 or trackmode>3 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "trackmode", "Must be an integer between 1 and 3!", -7) return nil end
  if leadin_silence_tracks<0 or leadin_silence_tracks>100000 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_tracks", "Ultraschall-API supports only millisecond-values between 0 to 100000, sorry.", -8) return nil end
  if leadin_silence_disc<0 or leadin_silence_disc>100000 then ultraschall.AddErrorMessage("CreateRenderCFG_AudioCD", "leadin_silence_disc", "Ultraschall-API supports only millisecond-values between 0 to 100000, sorry.", -9) return nil end

  
  if trackmode==1 then trackmode="1"
  elseif trackmode==2 then trackmode="2"
  elseif trackmode==3 then trackmode="3"
  end
  
  if only_markers_starting_with_hash==true then only_markers_starting_with_hash="checked" else only_markers_starting_with_hash="unchecked" end
  
  if burncd_image_after_render==true then burncd_image_after_render="checked" else burncd_image_after_render="unchecked" end
  
  local _temp, renderstring=ultraschall.GetIniFileExternalState("AUDIOCD", "Renderstring", ini_file)
  local _temp, leadin_silence_disc=ultraschall.GetIniFileExternalState("AUDIOCD", "DISCLEADIN_"..leadin_silence_disc, ini_file)
  local _temp, leadin_silence_tracks=ultraschall.GetIniFileExternalState("AUDIOCD", "TRACKLEADIN_"..leadin_silence_tracks, ini_file)
  local _temp, trackmode=ultraschall.GetIniFileExternalState("AUDIOCD", "Trackmode_"..trackmode, ini_file)
  local _temp, burncd_image_after_render=ultraschall.GetIniFileExternalState("AUDIOCD", "BurnCDImage_"..burncd_image_after_render, ini_file)
  local _temp, only_markers_starting_with_hash=ultraschall.GetIniFileExternalState("AUDIOCD", "OnlyUseMarkers_"..only_markers_starting_with_hash, ini_file)


  renderstring=string.gsub(renderstring, "%[DISCLEADIN%]", leadin_silence_disc)
  renderstring=string.gsub(renderstring, "%[TRACKLEADIN%]", leadin_silence_tracks)
  renderstring=string.gsub(renderstring, "%[BurnCDImage%]", burncd_image_after_render)
  renderstring=string.gsub(renderstring, "%[Trackmode%]", trackmode)
  renderstring=string.gsub(renderstring, "%[OnlyUseMarkers%]", only_markers_starting_with_hash)

  return renderstring
end

--A=ultraschall.CreateRenderCFG_AudioCD(1,false,100000,100000,false)
--reaper.CF_SetClipboard(A)

--B="IG9zaaCGAQCghgEAAAAAAAAAAAAAAAAA"

runcommand=ultraschall.RunCommand
Msg=print
GetPath=ultraschall.GetPath

ultraschall.ShowLastErrorMessage()



