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

-- This is the file for hotfixes of buggy functions.

-- If you have found buggy functions, you can submit fixes within here.
--      a) copy the function you found buggy into ultraschall_hotfixes.lua
--      b) debug the function IN HERE(!)
--      c) comment, what you've changed(this is for me to find out, what you did)
--      d) add information to the <US_DocBloc>-bloc of the function. So if the information in the
--         <US_DocBloc> isn't correct anymore after your changes, rewrite it to fit better with your fixes
--      e) add as an additional comment in the function your name and a link to something you do(the latter, if you want), 
--         so I can credit you and your contribution properly
--      f) submit the file as PullRequest via Github: https://github.com/Ultraschall/Ultraschall-Api-for-Reaper.git (preferred !)
--         or send it via lspmp3@yahoo.de(only if you can't do it otherwise!)
--
-- As soon as these functions are in here, they can be used the usual way through the API. They overwrite the older buggy-ones.
--
-- These fixes, once I merged them into the master-branch, will become part of the current version of the Ultraschall-API, 
-- until the next version will be released. The next version will has them in the proper places added.
-- That way, you can help making it more stable without being dependend on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.

ultraschall.hotfixdate="1_Mar_2019"

-- Let's create a unique script-identifier
ultraschall.dump=ultraschall.tempfilename:match("%-%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}")
--reaper.MB(tostring(ultraschall.dump),"",0)
if ultraschall.dump==nil then 
  ultraschall.dump, ultraschall.dump2 = ultraschall.tempfilename:sub(1,-5), ultraschall.tempfilename:sub(-4,-1)
  if ultraschall.dump2==nil then ultraschall.dump2="" ultraschall.dump=ultraschall.tempfilename end
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump..ultraschall.dump2
  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump.."-"..reaper.genGuid("")..ultraschall.dump2
else  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.tempfilename
end
  ultraschall.ScriptIdentifier=string.gsub(ultraschall.ScriptIdentifier, "\\", "/")

--reaper.MB(tostring(ultraschall.ScriptIdentifier),"",0)

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
  local filename2
  if filename:sub(-4,-1)==".lua" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".lua"
  elseif filename:sub(-4,-1)==".eel" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".eel" 
  elseif filename2==nil and filename:sub(-3,-1)==".py" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".py" end

  if filename2==filename then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "No valid script, must be either Lua, Python or EEL-script and end with such an extension.", -4) return false end

--reaper.MB(filename2,"",0)

  local OO=ultraschall.MakeCopyOfFile(filename, filename2)
  if OO==false then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "Couldn't create a temporary copy of the script.", -4) return false end

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
  local filename2
  if filename:sub(-4,-1)==".lua" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".lua"
  elseif filename:sub(-4,-1)==".eel" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".eel" 
  elseif filename2==nil and filename:sub(-3,-1)==".py" then filename2=filename:sub(1,-5).."-"..reaper.genGuid()..".py" end

  if filename2==filename then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "filename", "No valid script, must be either Lua, Python or EEL-script and end with such an extension.", -4) return false end

  local OO=ultraschall.MakeCopyOfFile(filename, filename2)
  if OO==false then ultraschall.AddErrorMessage("MIDI_OnCommandByFilename", "filename", "Couldn't create a temporary copy of the script.", -4) return false end
  
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