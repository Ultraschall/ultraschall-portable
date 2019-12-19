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
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end

-- deprecated stuff
  runcommand = ultraschall.RunCommand
  Msg=ultraschall.Msg

-- initialize some used variables
ultraschall.ErrorCounter=0
ultraschall.ErrorMessage={}
ultraschall.temp,ultraschall.tempfilename=reaper.get_action_context()
ultraschall.tempfilename=string.gsub(ultraschall.tempfilename,"\n","")
ultraschall.tempfilename=string.gsub(ultraschall.tempfilename,"\r","")  
ultraschall.Dump, ultraschall.ScriptFileName=reaper.get_action_context()

-- create the right separator for the current system
if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then ultraschall.Separator = "\\" else ultraschall.Separator = "/" end

-- Let's create a unique script-identifier for childscripts
ultraschall.dump=ultraschall.tempfilename:match("%-%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}")
if ultraschall.dump==nil then 
  ultraschall.dump, ultraschall.dump2 = ultraschall.tempfilename:sub(1,-5), ultraschall.tempfilename:sub(-4,-1)
  if ultraschall.dump2==nil then ultraschall.dump2="" ultraschall.dump=ultraschall.tempfilename end
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump..ultraschall.dump2
  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.dump.."-"..reaper.genGuid("")..ultraschall.dump2
else  
  ultraschall.ScriptIdentifier="ScriptIdentifier:"..ultraschall.tempfilename
end
ultraschall.ScriptIdentifier=string.gsub(ultraschall.ScriptIdentifier, "\\", "/")
ultraschall.ScriptIdentifier_Description=""
ultraschall.ScriptIdentifier_Title=ultraschall.tempfilename:match(".*"..ultraschall.Separator..("(.*)"))


-- operation HoHoHo
ultraschall.snowB=os.date("*t")
ultraschall.snowtodaysdate=ultraschall.snowB.day.."."..ultraschall.snowB.month
ultraschall.snowoldgfx=gfx.update 


-- lets initialize some API-Variables
ultraschall.StartTime=os.clock()
ultraschall.Script_Path = reaper.GetResourcePath().."/Scripts/"
local script_path = reaper.GetResourcePath().."/UserPlugins/ultraschall_api"..ultraschall.Separator
ultraschall.Api_Path=script_path
ultraschall.Api_Path=string.gsub(ultraschall.Api_Path,"\\","/")
ultraschall.Api_InstallPath=reaper.GetResourcePath().."/UserPlugins/"

function ultraschall.CountProjectTabs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountProjectTabs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_projecttabs = ultraschall.CountProjectTabs()</functioncall>
  <description>
    Counts the number of opened project tabs.
  </description>
  <retvals>
    integer number_of_projecttabs - the number of projecttabs currently opened
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, projectfiles, count, projecttab</tags>
</US_DocBloc>
]]
  local ProjCount=-1
  local Aretval="t"
  local Aprojfn=""
  while Aretval~=nil do
    Aretval, Aprojfn = reaper.EnumProjects(ProjCount+1, "")
    if Aretval~=nil then ProjCount=ProjCount+1
    else break
    end
  end
  return ProjCount+1
end


function ultraschall.GetProject_Tabs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProject_Tabs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_projecttabs, array projecttablist = ultraschall.GetProject_Tabs()</functioncall>
  <description>
    Returns the ReaProject-objects, as well as the filenames of all opened project-tabs.
  </description>
  <retvals>
    integer number_of_projecttabs - the number of projecttabs currently opened
    array projecttablist - an array, that holds all ReaProjects as well as the projectfilenames
                         - projecttablist[idx][1] = ReaProject
                         - projecttablist[idx][2] = projectfilename with path
  </retvals>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, projectfiles, count, projecttab, project, filename</tags>
</US_DocBloc>
]]
  local ProjTabList={}
  local CountProj=ultraschall.CountProjectTabs()
  for i=1, CountProj do
    ProjTabList[i]={}
    ProjTabList[i][1], ProjTabList[i][2] = reaper.EnumProjects(i-1, "")
  end  
  return CountProj, ProjTabList
end

-- Project ChangeCheck Initialisation
ultraschall.tempCount, ultraschall.tempProjects = ultraschall.GetProject_Tabs()
if ultraschall.ProjectList==nil then 
  ultraschall.ProjectList=ultraschall.tempProjects 
  ultraschall.ProjectCount=ultraschall.tempCount
end

function ultraschall.GetEnvelopeStateChunk(TrackEnvelope, str, isundo, usesws)
  return reaper.GetEnvelopeStateChunk(TrackEnvelope, "", false)
end

function ultraschall.GetApiVersion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetApiVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number versionnumber, string version, string date, string beta, string tagline = ultraschall.GetApiVersion()</functioncall>
  <description>
    returns the version, release-date and if it's a beta-version plus the currently installed hotfix
  </description>
  <retvals>
    number versionnumber - a number, that you can use for comparisons like, "if requestedversion>versionnumber then"
    string version - the current Api-version
    string date - the release date of this api-version
    string beta - if it's a beta version, this is the beta-version-number
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
  return 400.0279, "4.00","", "Beta 2.79",  "\"Yes - Owner of a lonely heart\"", ultraschall.hotfixdate
end

--A,B,C,D,E,F,G,H,I=ultraschall.GetApiVersion()

function ultraschall.IntToDouble(integer, selector)
  if selector==nil then
    for c in io.lines(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/double_to_int.ini") do
      if c:match(integer)~=nil then return tonumber(c:match("(.-)=")) end
    end
  else
    for c in io.lines(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/double_to_int_24bit.ini") do
      if c:match(integer)~=nil then return tonumber(c:match("(.-)=")) end
    end  
  end
end

--A=ultraschall.IntToDouble(4595772,1)

function ultraschall.DoubleToInt(float, selector)
  float=float+0.0
  float=ultraschall.LimitFractionOfFloat(float, 2, true)
  float=tostring(float)
  local String, retval
  if selector == nil then 
    if (float:match("%.(.*)")):len()==1 then 
      float=float.."0" 
    end
    retval, String = reaper.BR_Win32_GetPrivateProfileString("FloatsInt", float, "-1", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/double_to_int.ini")
  else
    retval, String = reaper.BR_Win32_GetPrivateProfileString("OpusFloatsInt", float, "-1", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/double_to_int_24bit.ini")
  end
  return tonumber(String)
end

function ultraschall.SuppressErrorMessages(flag)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SuppressErrorMessages</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SuppressErrorMessages(boolean flag)</functioncall>
  <description>
    Allows you to suppress error-messages.
    If you pass true, all error messages will be suppressed, until you run the function again passing false.
    
    Note: You should supress error-messages only temprarily and "unsuppress" them again, after your critical stuff is finished.
    Otherwise, someone using your functions will have no error-messages to debug with.
    
    Returns false, if parameter isn't boolean. Unlike most other function, this will never create an error-message!
  </description>
  <parameters>
    boolean flag - true, suppress error-messages; false, don't suppress error-messages
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, you didn't pass a boolean as parameter
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, suppress, unsuppress, message</tags>
</US_DocBloc>
]]
  if flag==true then
    ultraschall.SuppressErrorMessagesFlag=true
    return true
  elseif flag==false then
    ultraschall.SuppressErrorMessagesFlag=false
    return true
  end
  return false
end


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
    integer errorcount - the number of the errormessage within the Ultraschall-Api-Error-messagesystem; nil, if errormessages are suppressed currently
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
  if ultraschall.SuppressErrorMessagesFlag~=true then
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
  else
    return false
  end
end


function ultraschall.GetTrackStateChunk(MediaTrack, str, isundo, usesws)
  return reaper.GetTrackStateChunk(MediaTrack, "", false)
end



--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StartTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.StartTime</functioncall>
  <description>
    Contains the correct starting time of the current instance of the Ultraschall-Framework, which probably means your script, that embeds the framework.
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, starttime</tags>
</US_DocBloc>
]]

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>API_TempPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.API_TempPath</functioncall>
  <description>
    Contains the path to the temp-folder of the Ultraschall-API.
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, temppath</tags>
</US_DocBloc>
]]

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Euro</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Euro</functioncall>
  <description>
    Holds the Euro-currency-symbol, which is hard to type in Reaper's own IDE.
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, euro, currency, symbol</tags>
</US_DocBloc>
]]


-- Note for myself: the function ApiTest isn't defined in here, but rather in UserPlugins/ultraschall_api.lua
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApiTest</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.ApiTest()</functioncall>
  <description>
    Displays a message to show, which parts of the Ultraschall-API are turned on and which are turned off.
  </description>
  <chapter_context>
    Developer
    Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>help,api,test, developer</tags>
</US_DocBloc>
--]]





function ultraschall.IsValidItemStateChunk(itemstatechunk)
  if type(itemstatechunk)~="string" then ultraschall.AddErrorMessage("IsValidItemStateChunk", "itemstatechunk", "Must be a string.", -1) return false end  
  itemstatechunk=itemstatechunk:match("<ITEM.*%c>\n")
  if itemstatechunk==nil then return false end
  local count1=ultraschall.CountCharacterInString(itemstatechunk, "<")
  local count2=ultraschall.CountCharacterInString(itemstatechunk, ">")
  if count1~=count2 then return false end
  return true
end

function ultraschall.ToggleIDE_Errormessages(togglevalue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleIDE_Errormessages</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ToggleIDE_Errormessages(optional boolean togglevalue)</functioncall>
  <description>
    Toggles or sets, if the error-messaging system shall output it's errors to Reaper's IDE(true) or not(false).
    When set true, it will show the errormessages at the bottom of the IDE, as you are used by Reaper's own functions.
  </description>
  <parameters>
    optional boolean togglevalue - true, if errormessages shall be shown at the bottom of the IDE, false if not. If omitted, it toggles what was set before.
  </parameters>
  <retvals>
    boolean retval - true, if errors will be shown at the bottom of the IDE; false, if not
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, toggle, message, ide</tags>
</US_DocBloc>
]]
  -- sets ultraschall.IDEerror to true or false(dependend on parameter togglevalue)  
  if togglevalue==true or togglevalue==false then ultraschall.IDEerror=togglevalue
  else
    if ultraschall.IDEerror==true then ultraschall.IDEerror=false
    else ultraschall.IDEerror=true
    end
  end
  -- return new ultraschall.IDEerror-setting
  return ultraschall.IDEerror
end

function ultraschall.ReadErrorMessage(errornumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errcode, string functionname, string parmname, string errormessage, string lastreadtime, string err_creation_date, string err_creation_timestamp = ultraschall.ReadErrorMessage(integer errornumber)</functioncall>
  <description>
    Reads an error-message within the Ultraschall-ErrorMessagesystem.
    Returns a boolean value, the functionname, the errormessage, the "you've already read this message"-status, the date and a timestamp of the creation of the errormessage.
    returns false in case of failure
  </description>
  <parameters>
    integer errornumber - the number of the error, beginning with 1. Use <a href="#CountErrorMessages">CountErrorMessages</a> to get the current number of error-messages.
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    integer errcode - the errorcode of this message, as set by the function that created this errormessage; -1 is default value
    string functionname - the name of the function, where the problem happened
    string parmname - the parameter, that was used wrong by the programmer; "" if no parameter was involved in this error
    string errormessage - the message of the problem with a possible hint to a solution
    string readstatus - "unread" if the message hasn't been read yet or a date_time from when the message has been read already
    string err_creation_date - the date_time of when the error-message was created
    string err_creation_timestamp - the timestamp of when the error-message was created. Usually seconds, since system got started
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, message</tags>
</US_DocBloc>
]]
  -- check parameters
  if math.type(errornumber)~="integer" then ultraschall.AddErrorMessage("ReadErrorMessage","errornumber", "not a valid value, must be an integer", -1) return false end
  if errornumber<1 or errornumber>ultraschall.ErrorCounter then ultraschall.AddErrorMessage("ReadErrorMessage","errornumber", "no such error-message. Use ultraschall.CountErrorMessages() to find out the number of messages available.", -2) return false end

  -- set readstate
  local readstate=ultraschall.ErrorMessage[errornumber]["readstate"] 
  ultraschall.ErrorMessage[errornumber]["readstate"]=os.date()
  
  --return values
  return true, ultraschall.ErrorMessage[errornumber]["errcode"],
               ultraschall.ErrorMessage[errornumber]["funcname"],
               ultraschall.ErrorMessage[errornumber]["parmname"],
               ultraschall.ErrorMessage[errornumber]["errmsg"],
               readstate,
               ultraschall.ErrorMessage[errornumber]["date"],
               ultraschall.ErrorMessage[errornumber]["time"]
end


function ultraschall.DeleteErrorMessage(errornumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteErrorMessage(integer errornumber)</functioncall>
  <description>
    Deletes an error-message within the Ultraschall-ErrorMessagesystem.

    returns false in case of failure
  </description>
  <parameters>
    integer errornumber - the number of the error to delete, beginning with 1. Use <a href="#CountErrorMessages">CountErrorMessages</a> to get the current number of error-messages.
  </parameters>
  <retvals>
    boolean retval - true, if such an error exists; false if it didn't
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, delete, message</tags>
</US_DocBloc>
]]
  if math.type(errornumber)~="integer" then ultraschall.AddErrorMessage("DeleteErrorMessage","errornumber", "not a valid value, must be an integer", -1) return false end
  if errornumber<1 or errornumber>ultraschall.ErrorCounter then ultraschall.AddErrorMessage("DeleteErrorMessage","errornumber", "no such error-message. Use ultraschall.CountErrorMessages() to find out the number of messages available.", -2) return false end
  ultraschall.ErrorMessage[errornumber]=nil
  ultraschall.ErrorCounter=ultraschall.ErrorCounter-1
  return true
end

function ultraschall.GetLastErrorMessage()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errcode, string functionname, string parmname, string errormessage, string lastreadtime, string err_creation_date, string err_creation_timestamp, integer errorcounter = ultraschall.GetLastErrorMessage()</functioncall>
  <description>
    Reads the last error-message stored in the Ultraschall-ErrorMessagesystem.
    Returns a boolean value, the functionname, the errormessage, the date and a timestamp of the creation of the errormessage, the unread-status as well as the error-message-number.
    returns false in case of failure
  </description>
  <parameters>
    integer errornumber - the number of the error, beginning with 1. Use <a href="#CountErrorMessages">CountErrorMessages</a> to get the current number of error-messages.
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    integer errcode - the errorcode of this message, as set by the function that created this errormessage; -1 is default value
    string functionname - the name of the function, where the problem happened
    string parmname - the parameter, that was used wrong by the programmer; "" if no parameter was involved in this error
    string errormessage - the message of the problem with a possible hint to a solution
    string readstatus - "unread" if the message hasn't been read yet or a date_time from when the message has been read already
    string err_creation_date - the date_time of when the error-message was created
    string err_creation_timestamp - the timestamp of when the error-message was created. Usually seconds, since system got started
    integer errorcounter - the error-message-number within the Ultraschall-Error-Message-System
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, message</tags>
</US_DocBloc>
]]
  if ultraschall.ErrorCounter==0 then return false end --ultraschall.AddErrorMessage("GetLastErrorMessage","","No Error Message available!",-1) return false end
  local errornumber=ultraschall.ErrorCounter
  local readstate=ultraschall.ErrorMessage[errornumber]["readstate"]
  ultraschall.ErrorMessage[ultraschall.ErrorCounter]["readstate"]=os.date()
  
  return true, ultraschall.ErrorMessage[errornumber]["errcode"],
                 ultraschall.ErrorMessage[errornumber]["funcname"],
                 ultraschall.ErrorMessage[errornumber]["parmname"],
                 ultraschall.ErrorMessage[errornumber]["errmsg"],
                 readstate,
                 ultraschall.ErrorMessage[errornumber]["date"],
                 ultraschall.ErrorMessage[errornumber]["time"],
                 ultraschall.ErrorCounter
end

function ultraschall.DeleteLastErrorMessage()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteLastErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteLastErrorMessage()</functioncall>
  <description>
    Deletes the last error-message and returns a boolean value.
    returns false in case of failure
  </description>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, delete, message</tags>
</US_DocBloc>
]]
  if ultraschall.ErrorCounter==0 then ultraschall.AddErrorMessage("DeleteLastErrorMessage","","No Error Message available!",-1) return false
  else
    ultraschall.ErrorMessage[ultraschall.ErrorCounter]=nil
    ultraschall.ErrorCounter=ultraschall.ErrorCounter-1
    return true
  end
end

function ultraschall.DeleteAllErrorMessages()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteAllErrorMessages</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteAllErrorMessages()</functioncall>
  <description>
    Deletes all error-messages and returns a boolean value.
    returns false in case of failure
  </description>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, delete, message</tags>
</US_DocBloc>
]]
  if ultraschall.ErrorCounter==0 then ultraschall.AddErrorMessage("DeleteAllErrorMessages","","No Error Message available!",-1) return false
  else
    ultraschall.ErrorCounter=0
    ultraschall.ErrorMessage={}
    return true
  end
end

function ultraschall.GetLastErrorMessage2(count,setread)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastErrorMessage2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, array ErrorMessages = ultraschall.GetLastErrorMessage2(integer count, boolean setread)</functioncall>
  <description>
    Returns an array with the last "count" errormessages. 1 for the last, 2 for the last 2, etc.
    Set setread to false, if you want to retain the unread status of the error-messages.
    returns false in case of failure
  </description>
  <parameters>
    integer count - the number of the last few errors, you want to get returned. Use <a href="#CountErrorMessages">CountErrorMessages</a> to get the current number of error-messages.
  </parameters>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
    array ErrorMessages - an array, that contains all values for the chosen number of errormessages.
    -The fields are ErrorMessages[errornumber][x], where x stands for
    -"errcode" - the errorcode of this function, default is -1 
    -"funcname" - functionname
    -"parmname" - name of the parameter, that caused the error
    -"errmsg" - errormessage
    -"readstate" - readstatus
    -"date" - errorcreation date_time
    -"time" - errorcreation timestamp in seconds, usually seconds since computer has been started
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, message</tags>
</US_DocBloc>
]]
  -- check parameters
  if math.type(count)~="integer" then ultraschall.AddErrorMessage("GetLastErrorMessage2","count", "not a valid value, must be an integer", -1) return false end
  if count<1 or count>ultraschall.ErrorCounter then ultraschall.AddErrorMessage("GetLastErrorMessage2","count", "higher than available errormessages or lower than 1. Use ultraschall.CountErrorMessages() to find out the number of messages available.", -2) return false end
  if setread~=true and setread~=false then ultraschall.AddErrorMessage("GetLastErrorMessage2","setread", "only true or false allowed", -3) return false end
  
  -- create table atable
  local atable={}
  
  -- get all requested errormessages and put them into the table atable
  for i=1, count do
    local ErrorMessage={}
    ErrorMessage["errcode"]=ultraschall.ErrorMessage[i]["errcode"]
    ErrorMessage["funcname"]=ultraschall.ErrorMessage[i]["funcname"]
    ErrorMessage["parmname"]=ultraschall.ErrorMessage[i]["parmname"]
    ErrorMessage["errmsg"]=ultraschall.ErrorMessage[i]["errmsg"]
    ErrorMessage["readstate"]=ultraschall.ErrorMessage[i]["readstate"]
    ErrorMessage["date"]=ultraschall.ErrorMessage[i]["date"]
    ErrorMessage["time"]=ultraschall.ErrorMessage[i]["time"]
    
    -- if setread is set to true, set the readstate to the readdate
    if setread==true then ultraschall.ErrorMessage[i]["readstate"]=os.date() end
    atable[i]=ErrorMessage
  end
  
  -- return the result
  return true, atable
end

function ultraschall.CountErrorMessages()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountErrorMessages</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer errorcounter = ultraschall.CountErrorMessages()</functioncall>
  <description>
    Returns the current count of errormessages in the system available.
  </description>
  <retvals>
    integer errorcounter - the number of errormessages currently available in the error-message-system. Includes read and unread ones.
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, count, message</tags>
</US_DocBloc>
]]
  return ultraschall.ErrorCounter
end

function ultraschall.ShowLastErrorMessage()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowLastErrorMessage</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.ShowLastErrorMessage()</functioncall>
  <description>
    Displays the last error message in a messagebox, if existing and unread.
  </description>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, show, message</tags>
</US_DocBloc>
--]]
  -- get the error-information
  local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage()
  
  -- if errormessage exists and message is unread
  if retval==true and lastreadtime=="unread" then 
    if parmname~="" then 
      -- if error-causing-parameter was given, display this message
      parmname="param: "..parmname 
      reaper.MB(functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode,"Ultraschall Api Error Message",0) 
    else
      -- if no error-causing-parameter was given, display that message
      reaper.MB(functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode,"Ultraschall Api Error Message",0) 
    end
  end
end

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SLEM</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>SLEM()</functioncall>
  <description>
    Displays the last error message in a messagebox, if existing and unread.
    
    Like ultraschall.ShowLastErrorMessage() but this is easier to type.
    Note: written without ultraschall. in the beginning!
  </description>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, show, message</tags>
</US_DocBloc>
--]]
SLEM=ultraschall.ShowLastErrorMessage

function ultraschall.ApiFunctionTest()
  ultraschall.functions_works="on"
end






--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Separator</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Separator</functioncall>
  <description>
    Contains the correct separator for your system. / on Mac, \ on Windows. Use them, if you want to create windows and mac-compliant scripts that have file operations.
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, separator</tags>
</US_DocBloc>
--]]


--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Api_Path</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Api_Path</functioncall>
  <description>
    Contains the current path of the Ultraschall-Api-folder ResourcePath/UserPlugins/ultraschall_api/
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, path, folder</tags>
</US_DocBloc>
--]]

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Api_InstallPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Api_InstallPath</functioncall>
  <description>
    Contains the current path to the installation folder of the Ultraschall-Api(usually Resourcesfolder/UserPlugins)
  </description>
  <chapter_context>
    API-Variables
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>api, variable, install, path, folder</tags>
</US_DocBloc>
--]]




function ultraschall.Dummy()
  -- just a dummy function, if needed
end




function progresscounter(state)
  local A=ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_functions_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_doc_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_gfx_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_gui_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_gui_engine_server.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_network_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_sound_engine.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_video_engine.lua")
  
  local filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Modules/")
  for i=1, filecount do
    A=A..ultraschall.ReadFullFile(files[i]).."\n"
  end

if ultraschall.US_BetaFunctions=="ON" then
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_functions_engine_beta.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_gfx_engine_beta.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_gui_engine_beta.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_network_engine_beta.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_sound_engine_beta.lua")
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_video_engine_beta.lua")
end
  A=A.."function ultraschall."
  A=A:match("function ultraschall%..*")

  local funcs=0
  local vars=0
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(A, "\n")
  for i=1, count do
    if individual_values[i]:match("^%s-</US_DocBloc>")~=nil then funcs=funcs+1 end
  end
  
  for i=1, count do
    if individual_values[i]:match("    API%-Variables")~=nil then vars=vars+1 end
  end
  
  --print2(funcs, vars)
  
  return funcs-vars, vars
end
--L,LL=progresscounter(false)



ultraschall.Euro="€"


function ultraschall.GetLastErrorMessage_Funcname(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLastErrorMessage_Funcname</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer errorindex, string parametername, string errormessage, integer errorcode = ultraschall.GetLastErrorMessage_Funcname(string functionname)</functioncall>
  <description>
    Returns the last errormessage, a certain function added to the Error-Messaging-System.
    Sets read-state of the error-message to the date-time of accessing it.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer errorindex - the index of the error within the Error-Messaging-System
    string parametername - the parameter that produced the problem, or "" if no parameter was involved
    string errormessage - the errormessage
    integer errorcode - the errorcode the error has
  </retvals>
  <parameters>
    string functionname - the name of the function, whose last error message you want to retrieve
  </parameters>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, last error message, function</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("GetLastErrorMessage_Funcname", "functionname", "must be a string", -1) return -1 end
  for i=ultraschall.ErrorCounter, 1, -1 do
    if functionname==ultraschall.ErrorMessage[i]["funcname"] then
      ultraschall.ErrorMessage[i]["readstate"]=os.date()
      return i, ultraschall.ErrorMessage[i]["parmname"],
                ultraschall.ErrorMessage[i]["errmsg"],
                ultraschall.ErrorMessage[i]["errcode"]
    end
  end
  return -1
end

--ultraschall.ShowMenu(9,9)
--L=ultraschall.ErrorMessage

--reaper.MB(ultraschall.ErrorMessage[1]["readstate"],"",0)
--for i=0, 10000 do
--end
--ultraschall.GetLastErrorMessage_Funcname("ShowMenu")

function ultraschall.CountErrorMessage_Funcname(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountErrorMessage_Funcname</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer number_of_errormessages = ultraschall.CountErrorMessage_Funcname(string functionname)</functioncall>
  <description>
    Returns the number of available errormessages for functionname, existing in the Error-Messaging-System.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer number_of_errormessages - the number of errormessages functionname has left in the Error-Messaging-System
  </retvals>
  <parameters>
    string functionname - the name of the function, whose error messages you want to count
  </parameters>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, count, error messages, function</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("CountErrorMessage_Funcname", "functionname", "must be a string", -1) return -1 end
  local count=0
  for i=ultraschall.ErrorCounter, 1, -1 do
    if functionname==ultraschall.ErrorMessage[i]["funcname"] then
      count=count+1
    end
  end
  return count
end

function ultraschall.GetErrorMessage_Funcname(functionname, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetErrorMessage_Funcname</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer errorindex, string parametername, string errormessage, integer errorcode = ultraschall.GetErrorMessage_Funcname(string functionname, integer index)</functioncall>
  <description>
    Returns a specific errormessage specified by index, functionname added to the Error-Messaging-System.
    Sets read-state of the error-message to the date-time of accessing it.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer errorindex - the index of the error within the Error-Messaging-System
    string parametername - the parameter that produced the problem, or "" if no parameter was involved
    string errormessage - the errormessage
    integer errorcode - the errorcode the error has
  </retvals>
  <parameters>
    string functionname - the name of the function, whose last error message you want to retrieve
    integer index - the index of the error-message for functionname
  </parameters>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, index, error message, function</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("GetErrorMessage_Funcname", "functionname", "must be a string", -1) return -1 end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("GetErrorMessage_Funcname", "index", "must be an integer", -3) return -1 end
  if index<1 then ultraschall.AddErrorMessage("GetErrorMessage_Funcname", "index", "must be higher than 0", -4) return -1 end
  local count=0
  for i=ultraschall.ErrorCounter, 1, -1 do
    if functionname==ultraschall.ErrorMessage[i]["funcname"] then
      count=count+1      
      if count==index then 
        ultraschall.ErrorMessage[i]["readstate"]=os.date()
        return i, ultraschall.ErrorMessage[i]["parmname"],
                  ultraschall.ErrorMessage[i]["errmsg"],
                  ultraschall.ErrorMessage[i]["errcode"]
      end
    end
  end
  return count
end

--A,B,C,D,E=ultraschall.GetErrorMessage_Funcname("GetAllMediaItemsBetween", -1)


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


-- HoHoHo
function ultraschall.OperationHoHoHo()  
  if ultraschall.tempfilename:match("ultraschall_startscreen.lua")~=nil and 
      (ultraschall.snowtodaysdate=="24.12" or 
       ultraschall.snowtodaysdate=="25.12" or 
       ultraschall.snowtodaysdate=="26.12") then
    if ultraschall.snowheight==nil then ultraschall.SnowInit() end
    ultraschall.snowoldgfx=gfx.update
    function gfx.update()
      if ultraschall.US_snowmain~=nil then ultraschall.US_snowmain() end
      ultraschall.snowoldgfx()
    end      
  end
end
--if GUI==nil then GUI={} end

function ultraschall.SnowInit()
  --gfx.init()
  
  -- initial values
  ultraschall.snowspeed=1.3       -- the falling speed of the snowflakes
  ultraschall.snowsnowfactor=5000 -- the number of snowflakes
  ultraschall.snowwindfactor=3    -- the amount the wind influences the snow; wind has an effect sideways and on the falling-speed. 
                                  -- Don't set too high(>100), will look ugly otherwise. Rather experimental, than a real wind simulation...
  
  -- let's create some basic shapes to blit as snowflakes for:
  -- close snowflakes
  gfx.setimgdim(200,1,1)
  gfx.dest=200
  gfx.set(0.5,0.5,0.5)
  gfx.rect(0,0,1,1)
  -- medium snowflakes
  gfx.setimgdim(400,1,1)
  gfx.dest=400
  gfx.set(0.3,0.3,0.3)
  gfx.rect(0,0,1,1)
  -- small and far snowflakes
  gfx.setimgdim(401,1,1)
  gfx.dest=401
  gfx.set(0.2,0.2,0.2)
  gfx.rect(0,0,1,1)
  
  
  -- set framebuffer to the shown one
  gfx.dest=-1
  
  -- Let's create an initial set of snowflakes
  ultraschall.snowSnowflakes={}
  for a=1, ultraschall.snowsnowfactor do
    -- random x-position
    -- random y-position
    -- speed(which I also use as size-factor) and
    -- another speed-factor(useful? Don't know...)
    if gfx.w==0 then ultraschall.snowwidth=1000 else ultraschall.snowwidth=gfx.w end
    if gfx.h==0 then ultraschall.snowheight=500 else ultraschall.snowheight=gfx.h end
    ultraschall.snowSnowflakes[a]={math.random(1,ultraschall.snowwidth),math.random(-1500,0),math.random()*2,(math.random()/4)*math.random(-1,1)}
    if ultraschall.snowSnowflakes[a][3]<0.4 then ultraschall.snowSnowflakes[a][3]=ultraschall.snowSnowflakes[a][3]*2 end
  end
    
  
  -- Let's create a table, that is meant to influence the fall of the snowflakes, as wind would do.
  -- For laziness, I simply choose a sinus-wave to create it
  -- this could be improved much much more...
    ultraschall.snowwind=-3.6  
    ultraschall.snowWindtable={}
    for windcounter=0, ultraschall.snowsnowfactor do
     ultraschall.snowwind=(ultraschall.snowwind+ultraschall.snowwindfactor*.001)--/(speed*2)
     if ultraschall.snowwind>3.6 then ultraschall.snowwind=-3.6 end
     ultraschall.snowWindtable[windcounter]=math.sin(windcounter)-(math.random()/2)*ultraschall.snowwindfactor
    end
  
  ultraschall.snowwindoffset=1
  gfx.x=0
  gfx.y=0
  gfx.r=1
  gfx.g=1
  gfx.b=1
end
function ultraschall.US_snowmain()

  -- set sky to gray  
  gfx.clear=0--reaper.ColorToNative(15,15,15)
  local RUN=0
  local RUN_STOP=0
  
  for i=1, ultraschall.snowsnowfactor do  
    -- let's do the calculation of the falling of the snow
    gfx.x=ultraschall.snowSnowflakes[i][1]
    gfx.y=ultraschall.snowSnowflakes[i][2]+1

    -- if a snowflake hasn't left the bottom of the window, do
    if ultraschall.snowSnowflakes[i][2]<gfx.h then
      local RUN=RUN+1
      ultraschall.snowwindoffset=ultraschall.snowwindoffset+1
      if ultraschall.snowwindoffset>ultraschall.snowsnowfactor then ultraschall.snowwindoffset=1 end
      
      -- calculate the movement toward the bottom, influenced by speed and wind
      ultraschall.snowTemp=ultraschall.snowSnowflakes[i][2]+(ultraschall.snowSnowflakes[i][3]*ultraschall.snowspeed)-(ultraschall.snowWindtable[ultraschall.snowwindoffset]/4*ultraschall.snowSnowflakes[i][4])
      if ultraschall.snowTemp>=ultraschall.snowSnowflakes[i][2] then ultraschall.snowSnowflakes[i][2]=ultraschall.snowTemp end -- prevent backwards flying snow
      -- calculate the movement toward left/right, influenced by wind
      ultraschall.snowSnowflakes[i][1]=ultraschall.snowSnowflakes[i][1]+(ultraschall.snowSnowflakes[i][4]+ultraschall.snowWindtable[ultraschall.snowwindoffset]/4*ultraschall.snowSnowflakes[i][4])
      
      
      -- let's blit the snowflakes with their different sizes and colors
      
      if ultraschall.snowSnowflakes[i][3]>0.4 then 
        -- big snowflakes, close and bright
        gfx.blit(200,1.1*ultraschall.snowSnowflakes[i][3],0)      
      elseif ultraschall.snowSnowflakes[i][3]<0.3 and ultraschall.snowSnowflakes[i][3]>0.1 then
        -- medium snowflakes, normal and darker
        gfx.blit(401,1.1,0)      
      else
        -- small snowflakes, dark
        gfx.blit(400,0.7,0)
      end

    elseif gfx.h~=0 then
      local RUN_STOP=RUN_STOP+1 -- just a debug-variable to see, how many are newly created

      -- When Snowflake has left the bottom of the window, create a new one
      -- this is like the initial creation of snowflakes, but unlike there, we make the y-position 0 here
      if gfx.w==0 then ultraschall.snowwidth=1000 else ultraschall.snowwidth=gfx.w end
      if gfx.h==0 then ultraschall.snowheight=3000 else ultraschall.snowheight=gfx.h end
      ultraschall.snowSnowflakes[i]={math.random(1,ultraschall.snowwidth),0,math.random()*2,(math.random()/2)*math.random(-1,1)}
    end
  end

end



function ultraschall.tempgfxupdate_snowflakes()
    if ultraschall.US_snowmain~=nil then ultraschall.US_snowmain() end
    ultraschall.snowoldgfx()
end

function ultraschall.WinterlySnowflakes(toggle, falling_speed, number_snowflakes)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WinterlySnowflakes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.WinterlySnowflakes(boolean toggle, number falling_speed, integer number_snowflakes)</functioncall>
  <description>
    Exchanges the gfx.update()-function with a variant, that displays falling snowflakes everytime it is called.
    
    returns -1 in case of error
  </description>
  <retvals>
    integer retval - returns -1 in case of a'JS_Window_ListFind' n error; 1, in case of success
  </retvals>
  <parameters>
    boolean toggle - true, toggles falling snow on; false, toggles falling snow off
    number falling_speed - the falling speed of the snowflakes, 1.3 is recommended
    integer number_snowflakes - the number of falling snowflakes at the same time on screen; 2000 is recommended
  </parameters>
  <chapter_context>
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, miscellaneous, winterly snowflakes</tags>
</US_DocBloc>
]]  
  if type(falling_speed)~="number" then ultraschall.AddErrorMessage("WinterlySnowflakes", "falling_speed", "must be a number", -1) return -1 end
  if math.type(number_snowflakes)~="integer" then ultraschall.AddErrorMessage("WinterlySnowflakes", "number_snowflakes", "must be an integer", -2) return -1 end
  if ultraschall.snowheight==nil then ultraschall.SnowInit() end
  ultraschall.snowspeed=falling_speed           -- the falling speed of the snowflakes
  ultraschall.snowsnowfactor=number_snowflakes  -- the number of snowflakes
  if toggle==true then
    gfx.update=ultraschall.tempgfxupdate_snowflakes
  else
    gfx.update=ultraschall.snowoldgfx
  end
  return 1
end

--Envelope=reaper.GetTrackEnvelope(reaper.GetTrack(0,0),2)
--A,B,C,D,E,F,G,H=ultraschall.GetLastEnvelopePoint(Envelope)

ultraschall.OperationHoHoHo()

function PingMe(message, outputtarget)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PingMe</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string pingmessage = PingMe(optional string message, integer outputtarget)</functioncall>
  <description>
    Shows the current script and line of script-execution, optionally with a message.
    
    This is for debugging-purposes. For instance, if you want to know, if an if-statement is working as you expect it, just add
    PingMe() into that if-statement.
    It will show a message including linenumbers, when the if-statement is going through.
    
    You can also choose, whether to output the message into ReaConsole, Messagebox or clipboard(including culminating options)
  </description>
  <retvals>
    string pingmessage - returns the pingmessage
  </retvals>
  <parameters>
    optional string message - an optional message shown
    optional integer outputtarget - 0, don't show a message
                                  - 1, output the pingme-message into ReaScript-console
                                  - 2 or nil, show a messagebox
                                  - 3, output it into the clipboard
                                  - 4, add it to the end of the contents of the clipboard
                                  - 5, add it to the beginning of the contents of the clipboard
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, debug, display message, traceback, linenumber, ping</tags>
</US_DocBloc>
]] 
  if message==nil then message="" end
  if type(message)~="string" and type(message)~="boolean" and type(message)~="number" then message=ultraschall.type(message)..": "..tostring(message) end
  message=tostring(message)
  local A,B
  A=debug.traceback()
  B=A
  B=string.gsub(B, "(\n%s*)", "\n\nScript: ")
  B=string.gsub(B, "(.*PingMe%'\n)", "")
  B=string.gsub(B, "%.lua:", "\nlinenumber: ")
    
  if outputtarget==0 then
  elseif outputtarget==1 then
    print(message.."\n"..B)
  elseif outputtarget==3 then
    print3(message.."\n"..B)
  elseif outputtarget==4 then
    local clipboard_string = ultraschall.GetStringFromClipboard_SWS()
    print3(clipboard_string.."\n"..message.."\n"..B)
  elseif outputtarget==5 then
    local clipboard_string = ultraschall.GetStringFromClipboard_SWS()
    print3(message.."\n"..B.."\n"..clipboard_string)
  else
    print2(message.."\n"..B)
  end
  return message.."\n"..B
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
    replaces Lua's own print-function. 
    
    Converts all parametes given into string using tostring() and displays them as a MessageBox, separated by two spaces.
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
  while temp[count]~=nil or temp[count+1]~=nil do
   string=string.."  "..tostring(temp[count])
    count=count+1
  end
  reaper.MB(string:sub(3,-1),"Print",0)
end


function print_alt(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>print_alt</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>print_alt(parameter_1 to parameter_n)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    replaces Lua's own print-function, that is quite useless in Reaper.
    
    like [print](#print), but separates the entries by a two spaced, not a newline
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
  if string:sub(-1,-1)=="\n" then string=string:sub(1,-2) end
  reaper.ShowConsoleMsg(string:sub(3,-1).."\n","Print",0)
end


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
    replaces Lua's own print-function, that is quite useless in Reaper.
    
    Converts all parametes given into string using tostring() and displays them in the ReaScript-console, separated by a newline and ending with a newline.
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
    string=string.."\n"..tostring(temp[count])
    count=count+1
  end
  if string:sub(-1,-1)=="\n" then string=string:sub(1,-2) end
  reaper.ShowConsoleMsg(string:sub(2,-1).."\n","Print",0)
end


function toboolean(value)
    -- converts a value to boolean, or returns nil, if not convertible
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>toboolean</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = toboolean(string value)</functioncall>
  <description>
    Converts the string "value" to a boolean, if applicable; means: if it contains either true or false in it.
    If it contains both or other characters(except spaces or tabs), it will not convert.
    Works basially like Lua's own tostring() or tonumber()-functions.
    
    Returns nil, if conversion isn't possible.
    
    Note: Unlike other ultraschall-api-functions, toboolean() has no ultraschall. in it's functionname!
  </description>
  <parameters>
    string value - the value to be converted to a boolean. True and false can be upper-, lower and camelcase.
  </parameters>
  <retvals>
    boolean retval - true or false, depending on the input variable value
  </retvals>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, convert, boolean</tags>
</US_DocBloc>
--]]
    if type(value)=="boolean" then return value end
    if value==nil then ultraschall.AddErrorMessage("toboolean","value", "must contain either true or false, nothing else. Spaces and tabs are allowed.", -1) return end
    local value=value:lower()
    local truth=value:match("^\t*%s*()true\t*%s*$")
    local falseness=value:match("^\t*%s*()false\t*%s*$")
    
    if tonumber(truth)==nil and tonumber(falseness)~=nil then
      return false
    elseif tonumber(truth)~=nil and tonumber(falseness)==nil then
      return true
    end
end

function print3(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>print3</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>print(parameter_1 to parameter_n)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    like [print](#print), but puts the parameters into the clipboard.
    
    Converts all parametes given into string using tostring() and puts them into the clipboard, with each parameter separated by two spaces.
    Unlike print and print2, this does NOT end with a newline!
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have put into the clipboard
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, clipboard</tags>
</US_DocBloc>
]]
  local Table={...}
  local Stringer=""
  local count=1
  while Table[count]~=nil do
    Stringer=Stringer..tostring(Table[count]).." "
    count=count+1
  end
  reaper.CF_SetClipboard(Stringer:sub(1,-2))
end

--print3()

function print_update(...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>print_update</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>print_update(parameter_1 to parameter_n)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    replaces Lua's own print-function, that is quite useless in Reaper.
    
    Converts all parametes given into string using tostring() and displays them in the ReaScript-console, separated by two spaces, ending with a newline.
    
    This is like [print](#print), but clears console everytime before displaying the values. Good for status-display, that shall not scroll.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, clear, update, console</tags>
</US_DocBloc>
]]

  reaper.ClearConsole()
  print(...)
end

function ultraschall.CheckActionCommandIDFormat(aid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckActionCommandIDFormat</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CheckActionCommandIDFormat(action_command_id)</functioncall>
  <description>
    Checks, whether an action command id is a valid commandid(which is a number) or a valid _action_command_id (which is a string with an _underscore in the beginning).
    
    Does not check, whether this action_command_id is a useable one, only if it's "syntax" is correct!
    
    returns falsein case of an error
  </description>
  <retvals>
    boolean retval  - true, valid action_command_id; false, not a valid action_command_id
  </retvals>
  <parameters>
    actioncommand_id - the ActionCommandID you want to check; either a number or an action_command_id with an underscore at the beginning
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>command, commandid, actioncommandid, check, validity</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(aid)~="integer" and type(aid)~="string" then ultraschall.AddErrorMessage("CheckActionCommandIDFormat", "action_command_id", "must be an integer or a string", -1) return false end
  
  if type(aid)=="number" and tonumber(aid)==math.floor(tonumber(aid)) and tonumber(aid)<=65535 and tonumber(aid)>=0 then return true -- is it a valid number?
  elseif type(aid)=="string" and aid:sub(1,1)=="_" and aid:len()>1 then return true -- is it a valid string, formatted right=
  else return false -- if neither, return false
  end
end


function ultraschall.RunCommand(actioncommand_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RunCommand</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.RunCommand(string actioncommand_id)  </functioncall>
  <description>
    runs a command by its ActionCommandID(instead of the CommandID-number)
    
    returns -1 in case of error
  </description>
  <retvals>
    integer retval - -1, in case of error
  </retvals>
  <parameters>
    string actioncommand_id - the ActionCommandID of the Command/Script/Action you want to run; must be either a number or the ActionCommandID beginning with an underscore _
  </parameters>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>command,commandid,actioncommandid,action,run</tags>
</US_DocBloc>
--]]
--reaper.MB("Hui","",0)
  -- check parameter
  if ultraschall.CheckActionCommandIDFormat(actioncommand_id)==false then ultraschall.AddErrorMessage("RunCommand", "actioncommand_id", "must be a command-number or start with an _underscore", -1) return -1 end
--reaper.MB("Hui2","",0)  
  -- run the command
  local command_id = reaper.NamedCommandLookup(actioncommand_id)
  --reaper.MB("Hui3","",0)  
  reaper.Main_OnCommand(command_id,0)
  --reaper.MB("Hui4","",0)  
end

runcommand=ultraschall.RunCommand



function ultraschall.ConvertStringToBits(message)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertStringToBits</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer number_of_bits, array bitarray = ultraschall.ConvertStringToBits(string message)</functioncall>
  <description>
    converts a string into its bit-representation and returns that as a handy table
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer number_of_bits - the number of bits in the string, -1, in case of an error
    array bitarray - the individual bits as a handy table
  </retvals>
  <parameters>
    string message - the string, which you want to convert into its bit representation
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, string, to bits</tags>
</US_DocBloc>
--]]
  if type(message)~="string" then ultraschall.AddErrorMessage("ConvertStringToBits", "message", "must be a string", -1) return -1 end
  local Bitarray={}
  local Bitarray_counter=0
  for i=1, message:len() do
    local Q=string.byte(message:sub(i,i))
    for i=1, 8 do
      Bitarray_counter=Bitarray_counter+1
      Bitarray[Bitarray_counter]=Q&1
      Q=Q>>1
    end
  end
  return Bitarray_counter, Bitarray
end

function ultraschall.ConvertBitsToString(bitarray)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertBitsToString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string message = ultraschall.ConvertBitsToString(array bitarray)</functioncall>
  <description>
    converts a table of bit-representation into a string
    
    Every entry in the table must be either 0 or 1. If there are too few bits to fill up a byte, the missing bits will be seen as trailing 0-bits.
    
    returns nil in case of an error
  </description>
  <retvals>
    string message - the converted bits as string-representation
  </retvals>
  <parameters>
    array bitarray - the individual bits in a table, which will be converted into a string-representation
                   - each entry in the table must be either 0 or 1; missing bits at the end(usually nil) will be seen as 0
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, convert, to string, bits</tags>
</US_DocBloc>
--]]
  local bitcounter=0
  local Result=""
  local byte
  for i=1, #bitarray, 8 do
    byte=0
    if bitarray[bitcounter+1]==1 then byte=byte+1 elseif bitarray[bitcounter+1]==0 then elseif bitarray[bitcounter+1]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+1, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+2]==1 then byte=byte+2 elseif bitarray[bitcounter+2]==0 then elseif bitarray[bitcounter+2]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+2, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+3]==1 then byte=byte+4 elseif bitarray[bitcounter+3]==0 then elseif bitarray[bitcounter+3]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+3, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+4]==1 then byte=byte+8 elseif bitarray[bitcounter+4]==0 then elseif bitarray[bitcounter+4]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+4, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+5]==1 then byte=byte+16 elseif bitarray[bitcounter+5]==0 then elseif bitarray[bitcounter+5]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+5, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+6]==1 then byte=byte+32 elseif bitarray[bitcounter+6]==0 then elseif bitarray[bitcounter+6]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+6, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+7]==1 then byte=byte+64 elseif bitarray[bitcounter+7]==0 then elseif bitarray[bitcounter+7]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+7, "must be 1, 0 or nil(for padding zeros)", -2) return end
    if bitarray[bitcounter+8]==1 then byte=byte+128 elseif bitarray[bitcounter+8]==0 then elseif bitarray[bitcounter+8]==nil then else ultraschall.AddErrorMessage("ConvertBitsToString", "bitarray entry "..bitcounter+8, "must be 1, 0 or nil(for padding zeros)", -2) return end
    bitcounter=bitcounter+8
    Result=Result..string.char(byte)
  end
  return Result
end
















--[[
dofile(script_path .. "Modules/ultraschall_functions_AudioManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_AutomationItems_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Clipboard_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Color_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ConfigurationFiles_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ConfigurationSettings_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_DeferManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Envelope_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_EventManager.lua")
dofile(script_path .. "Modules/ultraschall_functions_FileManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_FXManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_HelperFunctions_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Localize_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Markers_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_MediaItem_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_MetaData_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_MIDIManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Muting_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Navigation_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ProjectManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ReaMote_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_ReaperUserInterface_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Render_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_TrackManagement_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_TrackManagement_Routing_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua")
dofile(script_path .. "Modules/ultraschall_functions_Ultraschall_Module.lua")
--]]



dofile(script_path.."ultraschall_ModulatorLoad3000.lua")
ultraschall.ShowLastErrorMessage()
