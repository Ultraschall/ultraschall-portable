--[[
################################################################################
# 
# Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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


-- deprecated stuff
  if runcommand==nil then
    runcommand = ultraschall.RunCommand
  end
  
  if Msg==nil then
    Msg=ultraschall.Msg
  end

-- initialize some used variables
ultraschall.ErrorCounter=0
ultraschall.ErrorMessage={}
ultraschall.temp,ultraschall.tempfilename=reaper.get_action_context()
ultraschall.tempfilename=string.gsub(ultraschall.tempfilename,"\n","")
ultraschall.tempfilename=string.gsub(ultraschall.tempfilename,"\r","")  
ultraschall.Dump, ultraschall.ScriptFileName=reaper.get_action_context()

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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number versionnumber, string majorversion, string date, string subversion, string tagline, string buildnumber = ultraschall.GetApiVersion()</functioncall>
  <description>
    returns the version, release-date and if it's a beta-version plus the currently installed hotfix
  </description>
  <retvals>
    number versionnumber - a number, that you can use for comparisons like, "if requestedversion>versionnumber then"
    string majorversion - the current Api-major-version
    string date - the release date of this api-version
    string subversion - a subversion-number of a major-version
    string tagline - the tagline of the current release
    string hotfix_date - the release-date of the currently installed hotfix ($ResourceFolder/ultraschall_api/ultraschall_hotfixes.lua); XX_XXX_XXXX if no hotfix is installed currently
    string buildnumber - the build-number of the current release
  </retvals>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>version,versionmanagement</tags>
</US_DocBloc>
--]]
  local retval, BuildNumber = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", ultraschall.Api_Path.."IniFiles/ultraschall_api.ini")
  return 490, "4.9","30th of June 2023", "",  "\"Depeche Mode - Everything Counts\"", "xx of xxxx xxxx", BuildNumber..".00"
end

--A,B,C,D,E,F,G,H,I=ultraschall.GetApiVersion()

function ultraschall.IntToDouble(integer, selector)
  if selector==nil then
    -- get the double-float-version of this integer-representation
    -- as the file, in which I added the float-representation only has the last
    -- 8 characters encoded, I need to strip it from anything not needed for the encoding
    
    -- subtract the redundant values, that I didn't store anyway
    if integer>1099998167 then integer=integer-100000000 end
    if integer>0 then integer=integer-1000000000 end
    
    -- now convert the 8 bytes into the 4-byte-sequence I have stored in double_to_int_2-inifile
    integer=tostring(integer)
    for i=1, 8 do
      if integer:len()<8 then -- if the value i 0 then we need to fill up with padding 0
        integer=(0)..integer
      end
    end
    
    -- create the final 4-byte-sequence, which we're looking for in the ini-file
    local A=string.char(integer:sub(1,2)+1)..string.char(integer:sub(3,4)+1)..string.char(integer:sub(5,6)+1)..string.char(integer:sub(7,8)+1)
    
    -- read ini-file
    local B=ultraschall.ReadFullFile(ultraschall.Api_Path.."/IniFiles/double_to_int_2.ini", true)
 --B=UseMe -- debug
    -- look for the byte-sequence in the ini-file. The (offset/4)/100 is the double-float-value
    local i=-1
    for k in string.gmatch(B, "....") do
      i=i+1
      if k==A then return ultraschall.LimitFractionOfFloat(i/100, 2, true)  end
    end
  else
    -- convert integer-value to 14f-float, by reading it from the double_to_int_24bit-inifile
    integer=integer-4000000 -- subtract the value I haven't stored in double_to_int_24bit-inifile as it was redundant
    -- read through the whole file to get the correct entry and return the entry
    for c in io.lines(ultraschall.Api_Path.."IniFiles/double_to_int_24bit.ini") do
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
    -- get float
    if (float:match("%.(.*)")):len()==1 then float=float.."0" end -- make float an indexable string
    
    -- prepare variables
    local found=""
    local one, two, three, four, A
    local finalcounter=string.gsub(tostring(float), "%.", "")
    finalcounter=tonumber(finalcounter)    
 
    -- read byte-sequence, that we need to convert into the integer-value
    -- from double_to_int_2.ini-file
    local length, k = ultraschall.ReadBinaryFile_Offset(ultraschall.Api_Path.."/IniFiles/double_to_int_2.ini", finalcounter*4, 4)
    
    -- convert the bytesequence into the 8-character-byte-sequence
    one = tostring(string.byte(k:sub(1,1))-1) if one:len()==1 then one="0"..one end
    two = tostring(string.byte(k:sub(2,2))-1) if two:len()==1 then two="0"..two end
    three=tostring(string.byte(k:sub(3,3))-1) if three:len()==1 then three="0"..three end
    four =tostring(string.byte(k:sub(4,4))-1) if four:len()==1 then four="0"..four end
    found=tonumber(one..two..three..four)
    
    -- add additional offsets(this is due saving space in the double_to_int_2.ini-file, as this information
    -- was redundant in the first place, so I cropped it and reinsert it here)
    if finalcounter>1808 then 
      found=found+100000000 
    end
    if found>0 then found=found+1000000000 end    
    return found --return the integer-value.
  else
    -- for 14f-floats, use this file and read it like any regular ini-file
    retval, String = reaper.BR_Win32_GetPrivateProfileString("OpusFloatsInt", math.tointeger(float), "-1", ultraschall.Api_Path.."IniFiles/double_to_int_24bit.ini")
    -- add an offset(I removed it from the ini-file, as it was redundant. So I need to readd that value again in here)
    String=tonumber(String)+4000000
  end
  return String
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
  <target_document>US_Api_Functions</target_document>
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
    Ultraschall=4.75
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
  <target_document>US_Api_Functions</target_document>
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
      local context_nr=6
      local context=debug.getinfo(context_nr)
      if context==nil then context_nr=context_nr-1 context=debug.getinfo(context_nr) end
      if context==nil then context_nr=context_nr-1 context=debug.getinfo(context_nr) end
      if context==nil then context_nr=context_nr-1 context=debug.getinfo(context_nr) end
      if context==nil then context_nr=context_nr-1 context=debug.getinfo(context_nr) end
      if context==nil then context_nr=context_nr-1 context=debug.getinfo(context_nr) end
      local ErrorMessage={}
      ErrorMessage["funcname"]=functionname
      ErrorMessage["errmsg"]=errormessage
      ErrorMessage["readstate"]="unread"
      ErrorMessage["date"]=os.date()
      ErrorMessage["time"]=os.time()
      ErrorMessage["parmname"]=parametername
      ErrorMessage["errcode"]=errorcode
      ErrorMessage["Context_Function"]=context["name"]
      ErrorMessage["Context_Sourcefile"]=context["source"]
      ErrorMessage["Context_SourceLine"]=context["currentline"]
      if ErrorMessage["Context_Function"]==nil then ErrorMessage["Context_Function"]=debug.getinfo(context_nr-1)["name"] end
      
      
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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

function ultraschall.ReadErrorMessage(errornumber, keep_unread)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadErrorMessage</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errcode, string functionname, string parmname, string errormessage, string lastreadtime, string err_creation_date, string err_creation_timestamp, string context_function, string context_sourcefile, string context_sourceline = ultraschall.ReadErrorMessage(integer errornumber, optional boolean keep_unread)</functioncall>
  <description>
    Reads an error-message within the Ultraschall-ErrorMessagesystem.
    Returns a boolean value, the functionname, the errormessage, the "you've already read this message"-status, the date and a timestamp of the creation of the errormessage.
    returns false in case of failure
  </description>
  <parameters>
    integer errornumber - the number of the error, beginning with 1. Use <a href="#CountErrorMessages">CountErrorMessages</a> to get the current number of error-messages.
    optional boolean keep_unread - true, keeps the message unread; false or nil, sets the readstate of the message
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
    string context_function - the function, in which AddErrorMessage was called
    string context_sourcefile - the sourcefile, in which AddErrorMessage was called
    string context_sourceline - the line in the sourcefile, in which AddErrorMessage was called
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, get, message</tags>
</US_DocBloc>
]]
  -- check parameters
  if math.type(errornumber)~="integer" then ultraschall.AddErrorMessage("ReadErrorMessage","errornumber", "not a valid value, must be an integer", -1) return false end
  if errornumber<1 or errornumber>ultraschall.ErrorCounter then ultraschall.AddErrorMessage("ReadErrorMessage","errornumber", "no such error-message. Use ultraschall.CountErrorMessages() to find out the number of messages available.", -2) return false end

  -- set readstate
  local readstate=ultraschall.ErrorMessage[errornumber]["readstate"] 
  if keep_unread~=true then    
    ultraschall.ErrorMessage[errornumber]["readstate"]=os.date()
  end
  
  --return values
  return true, ultraschall.ErrorMessage[errornumber]["errcode"],
               ultraschall.ErrorMessage[errornumber]["funcname"],
               ultraschall.ErrorMessage[errornumber]["parmname"],
               ultraschall.ErrorMessage[errornumber]["errmsg"],
               readstate,
               ultraschall.ErrorMessage[errornumber]["date"],
               ultraschall.ErrorMessage[errornumber]["time"],
               ultraschall.ErrorMessage[errornumber]["Context_Function"],
               ultraschall.ErrorMessage[errornumber]["Context_Sourcefile"],
               ultraschall.ErrorMessage[errornumber]["Context_SourceLine"]
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
  <target_document>US_Api_Functions</target_document>
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
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errcode, string functionname, string parmname, string errormessage, string lastreadtime, string err_creation_date, string err_creation_timestamp, integer errorcounter, string context_function, string context_sourcefile, string context_sourceline = ultraschall.GetLastErrorMessage()</functioncall>
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
    string context_function - the function, in which AddErrorMessage was called
    string context_sourcefile - the sourcefile, in which AddErrorMessage was called
    string context_sourceline - the line in the sourcefile, in which AddErrorMessage was called
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
                 ultraschall.ErrorCounter,
                 ultraschall.ErrorMessage[errornumber]["Context_Function"],
                 ultraschall.ErrorMessage[errornumber]["Context_Sourcefile"],
                 ultraschall.ErrorMessage[errornumber]["Context_SourceLine"]
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, delete, message</tags>
</US_DocBloc>
]]
  if ultraschall.ErrorCounter==0 then return false
  else
    ultraschall.ErrorCounter=0
    ultraschall.ErrorMessage={}
    return true
  end
end

DAEM=ultraschall.DeleteAllErrorMessages
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DAEM</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = DAEM()</functioncall>
  <description>
    Deletes all error-messages and returns a boolean value.
    
    this is like ultraschall.DeleteAllErrorMessages(), just shorter
    
    returns false in case of failure
  </description>
  <retvals>
    boolean retval - true, if it worked; false if it didn't
  </retvals>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, delete, message</tags>
</US_DocBloc>
]]

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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, count, message</tags>
</US_DocBloc>
]]
  return ultraschall.ErrorCounter
end

function ultraschall.ShowLastErrorMessage(dunk, target, message_type)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowLastErrorMessage</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>requested_error_message = ultraschall.ShowLastErrorMessage(optional integer dunk, optional integer target, optional integer message_type)</functioncall>
  <description>
    Displays the last error message in a messagebox, the ReaScript-Console, the clipboard, if error is existing and unread.
  </description>
  <retvals>
    requested_error_message - the errormessage requested; 
  </retvals>
  <parameters>
    optional integer dunk - allows to index the last x'ish message to be returned; nil or 0, the last one; 1, the one before the last one, etc.
    optional integer target - the target, where the error-message shall be output to
                            - 0 or nil, target is a message box
                            - 1, target is the ReaScript-Console
                            - 2, target is the clipboard
                            - 3, target is a returned string
    optional integer message_type - if target is set to 3, you can set, which part of the error-messageshall be returned as returnvalue
                                  - nil or 1, returns true, if error has happened, false, if error didn't happen
                                  - 2, returns the errcode
                                  - 3, returns the functionname which caused the error
                                  - 4, returns the parmname which caused the error
                                  - 5, returns the errormessage
                                  - 6, returns the lastreadtime
                                  - 7, returns the err_creation_date
                                  - 8, returns the err_creation_timestamp      
  </parameters>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, error, show, message</tags>
</US_DocBloc>
--]]
  local three
  if dunk=="dunk" then three="Three points" end
  dunk=math.tointeger(dunk)
  if dunk==nil then dunk=0 end
 
  if target==nil then 
    target=tonumber(reaper.GetExtState("ultraschall_api", "ShowLastErrorMessage_Target"))
  end
  
  local CountErrMessage=ultraschall.CountErrorMessages()
  if CountErrMessage<=0 then return end
  if dunk<0 then dunk=CountErrMessage+dunk else dunk=CountErrMessage-dunk end
  -- get the error-information
  --local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage()
    local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, context_function, context_sourcefile, context_sourceline = ultraschall.ReadErrorMessage(dunk, true)
    --AAA=retval
  -- if errormessage exists and message is unread
  if retval==true and lastreadtime=="unread" then 
    if target==nil or target==0 then
      if parmname~="" then 
        -- if error-causing-parameter was given, display this message
        parmname="param: "..parmname 
        if context_function==nil then context_function="" end
        if context_sourceline==nil then context_sourceline=-1 end
        if context_sourcefile==nil then context_sourcefile="" end
        reaper.MB(functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1) , "Ultraschall Api Error Message",0) 
      else
        -- if no error-causing-parameter was given, display that message
        reaper.MB(functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode,"Ultraschall Api Error Message",0) 
      end
    elseif target==1 then
      if parmname~="" then 
        -- if error-causing-parameter was given, display this message
        parmname="param: "..parmname 
        reaper.ShowConsoleMsg("\n\nErrortime: "..os.date().."\n"..functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
      else
        -- if no error-causing-parameter was given, display that message
        reaper.ShowConsoleMsg("\n\nErrortime: "..os.date().."\n"..functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
      end
    elseif target==2 then
      if parmname~="" then 
        -- if error-causing-parameter was given, display this message
        parmname="param: "..parmname 
        print3(functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
      else
        -- if no error-causing-parameter was given, display that message
        print3(functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
      end  
    elseif target==3 then
      if      message_type==nil or message_type==1 then return retval
      elseif  message_type==2 then return errcode
      elseif  message_type==3 then return functionname
      elseif  message_type==4 then return parmname
      elseif  message_type==5 then return errormessage
      elseif  message_type==6 then return lastreadtime
      elseif  message_type==7 then return err_creation_date
      elseif  message_type==8 then return err_creation_timestamp     
      end
    end
  end
  local retval
  if parmname~="" then 
    -- if error-causing-parameter was given, display this message
    retval=functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)
  else
    -- if no error-causing-parameter was given, display that message
    retval=functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)
  end  
  return retval, three
end

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SLEM</slug>
  <requires>
    Ultraschall=4.75
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>requested_error_message = SLEM(optional integer dunk, optional integer target, optional integer message_type)</functioncall>
  <description>
    Displays the last error message in a messagebox, the ReaScript-Console, the clipboard, if error is existing and unread.
    
    Like ultraschall.ShowLastErrorMessage() but this is easier to type.
    Note: written without ultraschall. in the beginning!
  </description>
  <retvals>
    requested_error_message - the errormessage requested; 
  </retvals>
  <parameters>
    optional integer dunk - allows to index the last x'ish message to be returned; nil or 0, the last one; 1, the one before the last one, etc.
    optional integer target - the target, where the error-message shall be output to
                            - 0 or nil, target is a message box
                            - 1, target is the ReaScript-Console
                            - 2, target is the clipboard
                            - 3, target is a returned string
    optional integer message_type - if target is set to 3, you can set, which part of the error-messageshall be returned as returnvalue
                                  - nil or 1, returns true, if error has happened, false, if error didn't happen
                                  - 2, returns the errcode
                                  - 3, returns the functionname which caused the error
                                  - 4, returns the parmname which caused the error
                                  - 5, returns the errormessage
                                  - 6, returns the lastreadtime
                                  - 7, returns the err_creation_date
                                  - 8, returns the err_creation_timestamp      
  </parameters>
  <chapter_context>
    Developer
    Error Handling
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_video_engine.lua")
  
  local filecount, files = ultraschall.GetAllFilenamesInPath(ultraschall.Api_Path.."/Modules/")
  for i=1, filecount do
    A=A..ultraschall.ReadFullFile(files[i]).."\n"
  end

if ultraschall.US_BetaFunctions==true then
  A=A..ultraschall.ReadFullFile(ultraschall.Api_Path.."/ultraschall_functions_engine_beta.lua")
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, error, show, message, reascript, console</tags>
  </US_DocBloc>
  ]]
  if setting==true then ultraschall.ShowErrorInReaScriptConsole=true else ultraschall.ShowErrorInReaScriptConsole=false end
end


-- HoHoHo
function ultraschall.OperationHoHoHo()  
--[[
    if ultraschall.tempfilename:match("")==nil and 
      (ultraschall.snowtodaysdate~="24.12" or 
       ultraschall.snowtodaysdate~="25.12" or 
       ultraschall.snowtodaysdate~="26.12") then
    if ultraschall.snowheight==nil then ultraschall.SnowInit() end
    ultraschall.snowoldgfx=gfx.update
    function gfx.update()
      if ultraschall.US_snowmain~=nil then ultraschall.US_snowmain() end
      ultraschall.snowoldgfx()
    end      
  end
  --]]
end
--if GUI==nil then GUI={} end

function ultraschall.SnowInit()
  gfx.init()
  
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
      ultraschall.snowTemp=
        ultraschall.snowSnowflakes[i][2]+
        (ultraschall.snowSnowflakes[i][3]*ultraschall.snowspeed)-
        (ultraschall.snowWindtable[ultraschall.snowwindoffset]/4*
        ultraschall.snowSnowflakes[i][4])
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
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, miscellaneous, winterly snowflakes</tags>
</US_DocBloc>
]]  
  if type(falling_speed)~="number" then ultraschall.AddErrorMessage("WinterlySnowflakes", "falling_speed", "must be a number", -1) return -1 end
  if math.type(number_snowflakes)~="integer" then ultraschall.AddErrorMessage("WinterlySnowflakes", "number_snowflakes", "must be an integer", -2) return -1 end
  if number_snowflakes<1 or number_snowflakes>5000 then ultraschall.AddErrorMessage("WinterlySnowflakes", "number_snowflakes", "must be between 1 and 5000", -3) return -1 end
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
  <functioncall>string pingmessage = PingMe(optional string message, optional integer outputtarget)</functioncall>
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
    Debug
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
    
    shows \0-characters as .
    
    Converts all parametes given into string using tostring() and displays them as a MessageBox, separated by two spaces.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
    String Output
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, messagebox</tags>
</US_DocBloc>
]]

  local stringer=""
  local count=1
  local temp={...}
  while temp[count]~=nil or temp[count+1]~=nil do
   stringer=stringer.."  "..tostring(temp[count])
    count=count+1
  end
  stringer=string.gsub(stringer, "\0", "\\0")
  reaper.MB(stringer:sub(3,-1),"Print",0)
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
    
    shows \0-characters as .
    
    like [print](#print), but separates the entries by a two spaced, not a newline
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
    String Output
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, console</tags>
</US_DocBloc>
]]
  if ultraschall.Print_ToTheFront==true then 
    ultraschall.BringReaScriptConsoleToFront()
  end
  local stringer=""
  local count=1
  local temp={...}
  while temp[count]~=nil do
    stringer=stringer.."  "..tostring(temp[count])
    count=count+1
  end
  if stringer:sub(-1,-1)=="\n" then stringer=stringer:sub(1,-2) end
  stringer=string.gsub(stringer, "\0", ".")
  reaper.ShowConsoleMsg(stringer:sub(3,-1).."\n","Print",0)
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
    
    displays \0-characters as .
    
    Converts all parametes given into string using tostring() and displays them in the ReaScript-console, separated by a newline and ending with a newline.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
    String Output
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, console</tags>
</US_DocBloc>
]]
  if ultraschall.Print_ToTheFront==true then 
    ultraschall.BringReaScriptConsoleToFront()
  end
  local stringer=""
  local count=1
  local temp={...}
  while temp[count]~=nil do
    stringer=stringer.."\n"..tostring(temp[count])
    count=count+1
  end
  if stringer:sub(-1,-1)=="\n" then stringer=stringer:sub(1,-2) end
  stringer=string.gsub(stringer, "\0", ".")
  reaper.ShowConsoleMsg(stringer:sub(2,-1).."\n")
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
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
    
    Note: \0-characters will be seen as string-termination, so strings may be truncated. Please replace \0 with string.gsub, if you need to have the full string with all nil-values included.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have put into the clipboard
  </parameters>
  <chapter_context>
    API-Helper functions
    String Output
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
    
    Shows \0-characters as .
    
    This is like [print](#print), but clears console everytime before displaying the values. Good for status-display, that shall not scroll.
  </description>
  <parameters>
    parameter_1 to parameter_n - the parameters, that you want to have printed out
  </parameters>
  <chapter_context>
    API-Helper functions
    String Output
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunctions, print, clear, update, console</tags>
</US_DocBloc>
]]
  if ultraschall.Print_ToTheFront==true then 
    ultraschall.BringReaScriptConsoleToFront()
  end
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
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval  - true, valid action_command_id; false, not a valid action_command_id
  </retvals>
  <parameters>
    actioncommand_id - the ActionCommandID you want to check; either a number or an action_command_id with an underscore at the beginning
  </parameters>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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
  <target_document>US_Api_Functions</target_document>
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

function ultraschall.deprecated(functionname)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>deprecated</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.deprecated(string functionname)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      If you have a 3rd-party function added to Ultraschall-API, which you want to deprecate, use this 
      function to show a warning message, if that function is used.
      
      It will be shown once when running the script, after (re-)start of Reaper.
      
      That way, you can tell scripters, whether they need to update their scripts using newer/better functions.
      This is probably shown first to the user, who knows that way a potential problem and can tell the scripter about that.
      
      If there is a line "Author: authorname" in the file(as usual for ReaPack-compatible scripts), it will show the scripter's name in the dialog.
      
    </description>
    <retvals>
      boolean retval - true, defer-instance is running; false, defer-instance isn't running
    </retvals>
    <parameters>
      integer deferinstance - 0, to use the parameter identifier
      optional string identifier - when deferinstance>0 (for Defer1 through Defer20-defer-cycles):a script-identifier of a specific script-instance; nil, for the current script-instance
                                 - when deferinstance=0 (when using the Defer-function): the identifier of the defer-cycle, you've started with Defer
    </parameter>
    <chapter_context>
      API-Helper functions
      Debug
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>helperfunctions, deprecated, show, status</tags>
  </US_DocBloc>
  ]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("deprecated", "functionname", "must be a string", -1) return end 
  local A,B,C,D,E,F,G=reaper.get_action_context()
  local B1,B2=ultraschall.GetPath(B)
  if reaper.HasExtState("ultraschall_"..B2, functionname)==false then
    local Script=ultraschall.ReadFullFile(B)
    local Author=Script:match("%*.-Author%:(.-)%c")
    if Author==nil then Author="author of this script" end
    reaper.MB("The script \n\n    "..B2.." \n\nuses Ultraschall-API deprecated function \n\n    "..functionname..". \n\nPlease contact "..Author.." to fix this. Otherwise, this script will stop working in the future.", "Ultraschall-API: Issue with this script!", 0)
    reaper.SetExtState("ultraschall_"..B2, functionname, "Ping", false)
  end
end


function ultraschall.FloatCompare(a,b,precision)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>FloatCompare</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, number diff = ultraschall.FloatCompare(number a, number b, number precision)</functioncall>
  <description>
    Compares two floatvalues and allows to set the precision to copmare against.
    
    So, if you want to compare 5.1 and 5.2, using precision=0.2 returns true(is equal), precision=0.1 returns false(isn't equal).
    
    Returns nil in case of failure.
  </description>
  <parameters>
    number a - the first float-number to compare
    number b - the second float-number to compare
    number precision - the precision of the fraction, like 0.1 or 0.0063
  </parameters>
  <retvals>
    boolean retval - true, numbers are equal; false, numbers aren't equal
    number diff - the difference between numbers a and b
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunction, compare, precision, float</tags>
</US_DocBloc>
]]
  if type(a)~="number" then ultraschall.AddErrorMessage("FloatCompare", "a", "Must be a number", -1) return nil end
  if type(b)~="number" then ultraschall.AddErrorMessage("FloatCompare", "b", "Must be a number", -2) return nil end
  if type(precision)~="number" then ultraschall.AddErrorMessage("FloatCompare", "precision", "Must be a number", -3) return nil end
  return math.abs(a-b)<precision, math.abs(a-b)
end

function ToClip(toclipstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToClip</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>ToClip(string toclipstring)</functioncall>
  <description>
    Puts a string into clipboard.
    
    \0-characters will be seen as string-termination, so if you want to put strings into clipboard containing them, you need to replace them first or your string might be truncated
  </description>
  <parameters>
    string toclipstring - the string, which you want to put into the clipboard
  </parameters>
  <chapter_context>
    Clipboard Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunction, set, string, to clipboard</tags>
</US_DocBloc>
]]
  reaper.CF_SetClipboard(toclipstring)
end

function FromClip()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>FromClip</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string clipboard_string = FromClip()</functioncall>
  <description>
    Gets a string from clipboard.
  </description>
  <retvals>
    string clipboard_string - the string-content from the clipboard
  </retvals>
  <chapter_context>
    Clipboard Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helperfunction, get, string, from clipboard</tags>
</US_DocBloc>
]]
  return ultraschall.GetStringFromClipboard_SWS()
end

function ultraschall.EscapeMagicCharacters_String(sourcestring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EscapeMagicCharacters_String</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
    Lua=5.3
  </requires>
  <functioncall>string escaped_string = ultraschall.EscapeMagicCharacters_String(string sourcestring)</functioncall>
  <description>
    Escapes the magic characters(needed for pattern matching), so the string can be fed as is into string.match-functions.
	That way, characters like . or - or * etc do not trigger pattern-matching behavior but are used as regular . or - or * etc.
    
    returns nil in case of an error
  </description>
  <retvals>
    string escaped_string - the string with all magic characters escaped
  </retvals>
  <parameters>
	string sourcestring - the string, whose magic characters you want to escape for future use
  </parameters>
  <chapter_context>
    API-Helper functions
	Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, escape, magic characters</tags>
</US_DocBloc>
--]]  
   if type(sourcestring)~="string" then ultraschall.AddErrorMessage("EscapeMagicCharacters_String", "sourcestring", "must be a string", -1) return nil end
   return (sourcestring:gsub('%%', '%%%%')
            :gsub('^%^', '%%^')
            :gsub('%$$', '%%$')
            :gsub('%(', '%%(')
            :gsub('%)', '%%)')
            :gsub('%.', '%%.')
            :gsub('%[', '%%[')
            :gsub('%]', '%%]')
            :gsub('%*', '%%*')
            :gsub('%+', '%%+')
            :gsub('%-', '%%-')
            :gsub('%?', '%%?'))
end

function ultraschall.ActionsList_GetSelectedActions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ActionsList_GetSelectedActions</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
	SWS=2.10.0.1
	JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer num_found_actions, integer sectionID, string sectionName, table selected_actions, table CmdIDs, table ToggleStates, table shortcuts = ultraschall.ActionsList_GetSelectedActions()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
	returns the selected entries from the actionlist, when opened.
	
	The order of the tables of found actions, ActionCommandIDs and ToggleStates is the same in all of the three tables.
	They also reflect the order of userselection in the ActionList itself from top to bottom of the ActionList.
	
	returns -1 in case of an error
  </description>
  <retvals>
	integer num_found_actions - the number of selected actions; -1, if not opened
	integer sectionID - the id of the section, from which the selected actions are from
	string sectionName - the name of the selected section
	table selected_actions - the texts of the found actions as a handy table
	table CmdIDs - the ActionCommandIDs of the found actions as a handy table; all of them are strings, even the numbers, but can be converted using Reaper's own function reaper.NamedCommandLookup
	table ToggleStates - the current toggle-states of the selected actions; 1, on; 0, off; -1, no such toggle state available
    table shortcuts - the shortcuts of the action as a handy table; separated by ", "
  </retvals>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, action, actionlist, sections, selected, toggle states, commandids, actioncommandid, shortcuts</tags>
</US_DocBloc>
--]]
  local hWnd_action = ultraschall.GetActionsHWND()
  if hWnd_action==nil then ultraschall.AddErrorMessage("ActionsList_GetSelectedActions", "", "Action-List-Dialog not opened", -1) return -1 end
  local hWnd_LV = reaper.JS_Window_FindChildByID(hWnd_action, 1323)
  local combo = reaper.JS_Window_FindChildByID(hWnd_action, 1317)
  local sectionName = reaper.JS_Window_GetTitle(combo,"") -- save item text to table
  local sectionID =  reaper.JS_WindowMessage_Send( combo, "CB_GETCURSEL", 0, 0, 0, 0 )

  -- get selected count & selected indexes
  local sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(hWnd_LV)

  -- get the selected action-texts
  local selected_actions = {}
  local selected_shortcuts = {}
  local i = 0
  for index in string.gmatch(sel_indexes, '[^,]+') do
    i = i + 1
    local desc = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 1)--:gsub(".+: ", "", 1)
    local shortcut = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 0)--:gsub(".+: ", "", 1)
    selected_actions[i] = desc    
    selected_shortcuts[i] = shortcut
  end
  
  -- find the cmd-ids
  local temptable={}
  for a=1, i do
    temptable[selected_actions[a]]=selected_actions[a]
  end
  
  -- get command-ids of the found texts
  for aaa=0, 66000 do
    local Retval, Name = reaper.CF_EnumerateActions(sectionID, aaa, "")
    if temptable[Name]~=nil then    
      temptable[Name]=Retval
    end
    if Retval==0 then break end    
  end

  -- get ActionCommandIDs and toggle-states of the found actions
  local CmdIDs={}
  local ToggleStates={}
  for a=1, i do
    CmdIDs[a]=reaper.ReverseNamedCommandLookup(temptable[selected_actions[a]])
    if CmdIDs[a]==nil then CmdIDs[a]=tostring(temptable[selected_actions[a]]) end
    ToggleStates[a]=reaper.GetToggleCommandStateEx(sectionID, temptable[selected_actions[a]])
  end

  return i, sectionID, sectionName, selected_actions, CmdIDs, ToggleStates, selected_shortcuts
end

--A,B,C,D,E,F,G = ultraschall.ActionsList_GetSelectedActions()

--GMEM-related-functions

--ultraschall.reaper_gmem_attach=reaper.gmem_attach

--function reaper.gmem_attach(GMem_Name)
--  ultraschall.reaper_gmem_attach_curname=GMem_Name
--  local A=ultraschall.reaper_gmem_attach(GMem_Name)
--  return A
--end

function ultraschall.Gmem_GetCurrentAttachedName()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Gmem_GetCurrentAttachedName</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string current_gmem_attachname = ultraschall.Gmem_GetCurrentAttachedName()</functioncall>
  <description>
    returns nil if no gmem had been attached since addition of Ultraschall-API to the current script
  </description>
  <retvals>
    string current_gmem_attachname - the name of the currently attached gmem
  </retvals>
  <chapter_context>
    API-Helper functions
    Gmem/Shared Memory
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FXManagement_Module.lua</source_document>
  <tags>helperfunctions, get, current, gmem, attached name</tags>
</US_DocBloc>
--]]
  local A=reaper.gmem_attach("")
  reaper.gmem_attach(A)
  return A
end


function ultraschall.ActionsList_GetAllActions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ActionsList_GetAllActions</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.05
	SWS=2.10.0.1
	JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer num_found_actions, integer sectionID, string sectionName, table actions, table CmdIDs, table ToggleStates, table shortcuts = ultraschall.ActionsList_GetAllActions()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
	returns the all actions from the actionlist, when opened.
	
	The order of the tables of found actions, ActionCommandIDs and ToggleStates is the same in all of the three tables.
	They also reflect the order of userselection in the ActionList itself from top to bottom of the ActionList.
	
	returns -1 in case of an error
  </description>
  <retvals>
	integer num_found_actions - the number of found actions; -1, if not opened
	integer sectionID - the id of the section, from which the found actions are from
	string sectionName - the name of the found section
	table actions - the texts of the found actions as a handy table
	table CmdIDs - the ActionCommandIDs of the found actions as a handy table; all of them are strings, even the numbers, but can be converted using Reaper's own function reaper.NamedCommandLookup
	table ToggleStates - the current toggle-states of the found actions; 1, on; 0, off; -1, no such toggle state available
    table shortcuts - the shortcuts of the action as a handy table; separated by ", "
  </retvals>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, get, action, actionlist, sections, toggle states, commandids, actioncommandid, shortcuts</tags>
</US_DocBloc>
--]]
  local hWnd_action = ultraschall.GetActionsHWND()
  if hWnd_action==nil then ultraschall.AddErrorMessage("ActionsList_GetAllActions", "", "Action-List-Dialog not opened", -1) return -1 end
  local hWnd_LV = reaper.JS_Window_FindChildByID(hWnd_action, 1323)
  local combo = reaper.JS_Window_FindChildByID(hWnd_action, 1317)
  local sectionName = reaper.JS_Window_GetTitle(combo,"") -- save item text to table
  local sectionID =  reaper.JS_WindowMessage_Send( combo, "CB_GETCURSEL", 0, 0, 0, 0 )

  -- get the action-texts
  local actions = {}
  local shortcuts = {}
  local i = 0
    --for index in string.gmatch(sel_indexes, '[^,]+') do
  for index=0, 65535 do    
    i = i + 1
    local desc = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 1)--:gsub(".+: ", "", 1)
    local shortcut = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 0)--:gsub(".+: ", "", 1)
    --ToClip(FromClip()..tostring(desc).."\n")
    if desc=="" then break end    
    actions[i] = desc    
    shortcuts[i] = shortcut
  end
  i=i-1 
  -- find the cmd-ids
  local temptable={}
  for a=1, i do
    if actions[a]==nil then break end
    selectA=a
    selectI=i
    temptable[actions[a]]=actions[a]
  end
  
  -- get command-ids of the found texts
  for aaa=0, 65535 do
    local Retval, Name = reaper.CF_EnumerateActions(sectionID, aaa, "")
    if temptable[Name]~=nil then    
      temptable[Name]=Retval
    end
    if Retval==0 then break end    
  end

  -- get ActionCommandIDs and toggle-states of the found actions
  local CmdIDs={}
  local ToggleStates={}
  for a=1, i do
    CmdIDs[a]=reaper.ReverseNamedCommandLookup(temptable[actions[a]])
    if CmdIDs[a]==nil then CmdIDs[a]=tostring(temptable[actions[a]]) end
    ToggleStates[a]=reaper.GetToggleCommandStateEx(sectionID, temptable[actions[a]])
  end

  return i, sectionID, sectionName, actions, CmdIDs, ToggleStates, shortcuts
end

function ultraschall.BringReaScriptConsoleToFront()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>BringReaScriptConsoleToFront</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.BringReaScriptConsoleToFront()</functioncall>
  <description>
    Brings Reaper's ReaScriptConsole-window to the front, when it's opened.
  </description>
  <chapter_context>
    API-Helper functions
    ReaScript Console
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, activate, front, reascript console, window</tags>
</US_DocBloc>
]]
  local OldHWND=reaper.JS_Window_GetForeground()
  local HWND=ultraschall.GetReaScriptConsoleWindow()
  if HWND~=nil and OldHWND~=HWND then 
    reaper.JS_Window_SetForeground(HWND)
  end
end

function ultraschall.EditReaScript(filename, add_ultraschall_api, add_to_actionlist_section, x_pos, y_pos, width, height, showstate, watchlist_size, watchlist_size_row1, watchlist_size_row2, default_script_content)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EditReaScript</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>boolean retval, optional command_id, boolean created_new_script = ultraschall.EditReaScript(optional string filename, optional boolean add_ultraschall_api, optional integer add_to_actionlist_section, optional integer x_pos, optional integer y_pos, optional integer width, optional integer height, optional integer showstate, optional integer watchlist_size, optional integer watchlist_size_row1, optional integer watchlist_size_row2, optional string default_script_content)</functioncall>
  <description>
    Opens a script in Reaper's ReaScript-IDE.
    
    If the file does not exist yet, it will try to create it. If parameter filename doesn't contain a valid directory, it will try to create the script in the Scripts-folder of Reaper.
    
    Setting filename=nil will open the last one edited using this function.
    
    returns false in case of an error
  </description>
  <parameters>
    optional string filename - the filename of the new reascript-file to create(add .lua or .py or .eel to select the language).
                             - nil, opens the last ReaScript-file you opened with this function
    optional boolean add_ultraschall_api - true, add Ultraschall-API-call into the script(only in newly created ones!); false or nil, just open a blank script
    optional integer add_to_actionlist_section - the section, into which you want to add the script
                                               - nil, don't add, only open the script in IDE
                                               - 0, Main
                                               - 100, Main (alt recording) Note: If you already added to main(section 0), this function automatically adds the script to Main(alt) as well.
                                               - 32060, MIDI Editor
                                               - 32061, MIDI Event List Editor
                                               - 32062, MIDI Inline Editor
                                               - 32063, Media Explorer
    optional integer x_pos - x-position of the ide-window in pixels; nil, use the last one used
    optional integer y_pos - y-position of the ide-window in pixels; nil, use the last one used
    optional integer width - width of the ide-window in pixels; nil, use the last one used
    optional integer height - height of the ide-window in pixels; nil, use the last one used
    optional boolean showstate - nil, use last used settings
                               - 0, show regularly
                               - 1, dock the window
    optional integer watchlist_size - sets the size of the watchlist, from 80 to screenwidth-80
    optional integer watchlist_size_row1 - sets the size of the Name-row in the watchlist
    optional integer watchlist_size_row2 - sets the size of the Value-row in the watchlist
    optional string default_script_content - a string that shall be added to the beginning of the new script, when a script is newly created
  </parameters>
  <retvals>
    boolean retval - true, opening was successful; false, opening was unsuccessful
    optional integer command_id - the command-id of the script, when it gets newly created; nil, if script wasn't added
    boolean created_new_script - true, a new script had been created; false, the script already existed
  </retvals>
  <chapter_context>
    Developer
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>developer, edit, reascript, ide</tags>
</US_DocBloc>
]]
  if filename~=nil and type(filename)~="string" then ultraschall.AddErrorMessage("EditReaScript", "filename", "must be a string", -1) return false end
  if x_pos~=nil and math.type(x_pos)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "x_pos", "must be nil or an integer", -2) return false end
  if y_pos~=nil and math.type(y_pos)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "y_pos", "must be nil or an integer", -3) return false end
  if width~=nil and math.type(width)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "width", "must be nil or an integer", -4) return false end
  if height~=nil and math.type(height)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "height", "must be nil or an integer", -5) return false end
  if showstate~=nil and math.type(showstate)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "showstate", "must be nil or an integer", -6) return false end
  if watchlist_size~=nil and math.type(watchlist_size)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "watchlist_size", "must be nil or an integer", -7) return false end
  if watchlist_size_row1~=nil and math.type(watchlist_size_row1)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "watchlist_size_row1", "must be nil or an integer", -8) return false end  
  if watchlist_size_row2~=nil and math.type(watchlist_size_row2)~="integer" then ultraschall.AddErrorMessage("EditReaScript", "watchlist_size_row2", "must be nil or an integer", -9) return false end
  if default_script_content~=nil and type(default_script_content)~="string" then ultraschall.AddErrorMessage("EditReaScript", "watchlist_size_row2", "must be nil or an integer", -10) return false end
  if default_script_content==nil then default_script_content="" end
  
  if filename==nil then 
    -- when user has not set a filename, use the last edited on(with this function) or 
    -- the last created one(using the action-list-dialog), checked in that order
    --filename=reaper.GetExtState("ultraschall_api", "last_edited_script") 
    --if filename=="" then 
      filename=ultraschall.GetUSExternalState("REAPER", "lastscript", "reaper.ini")
    --end
  end
  
  local command_id
  local created_new_script=false
  
  if reaper.file_exists(filename)==false and ultraschall.DirectoryExists2(ultraschall.GetPath(filename))==false then
    -- if path does not exist, create filename in the scripts-folder
    local Path, Filename=ultraschall.GetPath(filename)
    filename=reaper.GetResourcePath().."/Scripts/"..Filename
  end
  if reaper.file_exists(filename)==false then
    -- create new file if not yet existing
    local content=default_script_content
    if content~="" then content=content.."\n" end
    if add_ultraschall_api==true then 
      content=content.."dofile(reaper.GetResourcePath()..\"/UserPlugins/ultraschall_api.lua\")\n\n"
    else
      content=content
    end
    created_new_script=reaper.file_exists(filename)
    ultraschall.WriteValueToFile(filename, content)
  end
  
  if add_to_actionlist_section~=nil then
  if add_to_actionlist_section~=0 and
     add_to_actionlist_section~=100 and
     add_to_actionlist_section~=32060 and
     add_to_actionlist_section~=32061 and
     add_to_actionlist_section~=32062 and
     add_to_actionlist_section~=32063 then
     add_to_actionlist_section=0
  end

  command_id = reaper.AddRemoveReaScript(true, add_to_actionlist_section, filename, true)
end
  
  -- set script that shall be opened and run the action to Edit last edited script
  local A, B, C, oldX, oldY, oldWidth, oldHeight, olddocked, retval, oldfullscreen, oldwatchdiv, oldwatch_c1, oldwatch_c2
  
  A=ultraschall.GetUSExternalState("REAPER", "lastscript", "reaper.ini")
  B=ultraschall.SetUSExternalState("REAPER", "lastscript", filename, "reaper.ini")
  
  -- set IDE-window position within reaper.ini
  if x_pos~=nil then
    retval, oldX = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_lx", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lx", x_pos, reaper.get_ini_file())
  end
  
  if y_pos~=nil then
    retval, oldY = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_ly", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_ly", y_pos, reaper.get_ini_file())
  end

  if width~=nil then
    retval, oldWidth = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_lw", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lw", width, reaper.get_ini_file())
  end

  if height~=nil then
    retval, oldHeight = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_lh", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lh", height, reaper.get_ini_file())
  end
  
  -- set window behavior
  if showstate~=nil then
    retval, olddocked = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_docked", "", reaper.get_ini_file())
    retval, oldfullscreen = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_lmax", "", reaper.get_ini_file())
    if showstate==0 then
      -- normal
      reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_docked", 0, reaper.get_ini_file())
      reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lmax",   0, reaper.get_ini_file())
    elseif showstate==1 then
      -- docked
      reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_docked", 1, reaper.get_ini_file())
      reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lmax",   0, reaper.get_ini_file())
    elseif showstate==2 then
      -- fullscreen, not yet working
      -- reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_docked", 0, reaper.get_ini_file())
      -- reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lmax",   1, reaper.get_ini_file())
    end
  end
  
  -- set watchlist behavior
  if watchlist_size~=nil then
    retval, oldwatchdiv = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_divpos", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_divpos",   watchlist_size, reaper.get_ini_file())
  end
  
  if watchlist_size_row1~=nil then
    retval, oldwatch_c1 = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_c1", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_c1",   watchlist_size_row1, reaper.get_ini_file())
  end
  
  if watchlist_size_row2~=nil then
    retval, oldwatch_c2 = reaper.BR_Win32_GetPrivateProfileString("reascriptedit", "watch_c2", "", reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_c2",   watchlist_size_row2, reaper.get_ini_file())
  end
        
  reaper.Main_OnCommand(41931,0)

  -- reset old edited script in reaper.ini
  --C=ultraschall.SetUSExternalState("REAPER", "lastscript", A, "reaper.ini")
  
  -- reset old IDE-window-position in reaper.ini
  if x_pos~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lx", oldX, reaper.get_ini_file())
  end
  if y_pos~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_ly", oldY, reaper.get_ini_file())
  end
  if width~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lw", oldWidth, reaper.get_ini_file())
  end  
  if height~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lh", oldHeight, reaper.get_ini_file())
  end  
  
  -- reset showstate of window
  if showstate~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_docked", olddocked, reaper.get_ini_file())
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_lmax",   oldfullscreen, reaper.get_ini_file())
  end
  
  -- reset old watchlist-behavior
  if watchlist_size~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_divpos", oldwatchdiv, reaper.get_ini_file())
  end
  
  if watchlist_size_row1~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_c1", oldwatch_c1, reaper.get_ini_file())
  end
  
  if watchlist_size_row2~=nil then
    reaper.BR_Win32_WritePrivateProfileString("reascriptedit", "watch_c2", oldwatch_c2, reaper.get_ini_file())
  end
  
  -- store last created/edited file using this function, so it can be opened with filename=nil
  reaper.SetExtState("ultraschall_api", "last_edited_script", filename, true)

  return true, command_id, created_new_script
end

function SFEM(dunk, target, message_type)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SFEM</slug>
    <requires>
      Ultraschall=4.75
      Reaper=5.40
      Lua=5.3
    </requires>
    <functioncall>requested_error_message = SFEM(optional integer dunk, optional integer target, optional integer message_type)</functioncall>
    <description>
      Displays the first error message in a messagebox, the ReaScript-Console, the clipboard, if error is existing and unread.
    </description>
    <retvals>
      requested_error_message - the errormessage requested; 
    </retvals>
    <parameters>
      optional integer dunk - allows to index the last x'ish message to be returned; nil or 0, the last one; 1, the one before the last one, etc.
      optional integer target - the target, where the error-message shall be output to
                              - 0 or nil, target is a message box
                              - 1, target is the ReaScript-Console
                              - 2, target is the clipboard
                              - 3, target is a returned string
      optional integer message_type - if target is set to 3, you can set, which part of the error-messageshall be returned as returnvalue
                                    - nil or 1, returns true, if error has happened, false, if error didn't happen
                                    - 2, returns the errcode
                                    - 3, returns the functionname which caused the error
                                    - 4, returns the parmname which caused the error
                                    - 5, returns the errormessage
                                    - 6, returns the lastreadtime
                                    - 7, returns the err_creation_date
                                    - 8, returns the err_creation_timestamp      
    </parameters>
    <chapter_context>
      Developer
      Error Handling
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, error, show, message</tags>
  </US_DocBloc>
  --]]
    local three
    if dunk=="dunk" then three="Three points" end
    dunk=math.tointeger(dunk)
    if dunk==nil then dunk=ultraschall.ErrorCounter-1 end
   
    if target==nil then 
      target=tonumber(reaper.GetExtState("ultraschall_api", "ShowLastErrorMessage_Target"))
    end
    
    local CountErrMessage=ultraschall.CountErrorMessages()
    if CountErrMessage<=0 then return end
    if dunk<0 then dunk=CountErrMessage+dunk else dunk=CountErrMessage-dunk end
    -- get the error-information
    --local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, errorcounter = ultraschall.GetLastErrorMessage()
      local retval, errcode, functionname, parmname, errormessage, lastreadtime, err_creation_date, err_creation_timestamp, context_function, context_sourcefile, context_sourceline = ultraschall.ReadErrorMessage(dunk, true)
      
      --AAA=retval
    -- if errormessage exists and message is unread
    if retval==true and lastreadtime=="unread" then 
      if target==nil or target==0 then
        if parmname~="" then 
          -- if error-causing-parameter was given, display this message
          parmname="param: "..parmname 
          if context_function==nil then context_function="" end
          reaper.MB(functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1),"Ultraschall Api Error Message", 0) 
        else
          -- if no error-causing-parameter was given, display that message
          reaper.MB(functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1),"Ultraschall Api Error Message",0) 
        end
      elseif target==1 then
        if parmname~="" then 
          -- if error-causing-parameter was given, display this message
          parmname="param: "..parmname 
          reaper.ShowConsoleMsg("\n\nErrortime: "..os.date().."\n"..functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
        else
          -- if no error-causing-parameter was given, display that message
          reaper.ShowConsoleMsg("\n\nErrortime: "..os.date().."\n"..functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
        end
      elseif target==2 then
        if parmname~="" then 
          -- if error-causing-parameter was given, display this message
          parmname="param: "..parmname 
          print3(functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
        else
          -- if no error-causing-parameter was given, display that message
          print3(functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)) 
        end  
      elseif target==3 then
        if      message_type==nil or message_type==1 then return retval
        elseif  message_type==2 then return errcode
        elseif  message_type==3 then return functionname
        elseif  message_type==4 then return parmname
        elseif  message_type==5 then return errormessage
        elseif  message_type==6 then return lastreadtime
        elseif  message_type==7 then return err_creation_date
        elseif  message_type==8 then return err_creation_timestamp     
        end
      end
    end
    local retval
    if parmname~="" then 
      -- if error-causing-parameter was given, display this message
      retval=functionname.."\n\n"..parmname.."\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)
    else
      -- if no error-causing-parameter was given, display that message
      retval=functionname.."\n\nerror  : "..errormessage.."\n\nerrcode: "..errcode.."\n\nFunction context: "..context_function.."\nFunction line_number: "..context_sourceline.."\n\nFunction source-file: "..context_sourcefile:sub(2,-1)
    end  
    return retval, three
end

function RFR(length, ...)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>RFR</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.40
      Lua=5.3
    </requires>
    <functioncall>... = RFR(integer length, ...)</functioncall>
    <description>
      returns only the first x return-values, as given by length.
      
      You can put the return-values of another function and just get the first x ones. So if the function returns 10 returnvalues, 
      but you only need the first two, set length=2 and add the function(with the 10 returnvalues) after it as second parameter.
        
      For example:
      
      integer r, integer g, integer b = reaper.ColorFromNative(integer col)
      
      returns three colorvalues. If you only want the first one(r), use it this way:
      
      r=RFR(1, reaper.ColorFromNative(12739))
      
      returns nil in case of an error
    </description>
    <retvals>
      various ... - the requested first-n returnvalues
    </retvals>
    <parameters>
      integer length - the number of the first return-values to return
      various ... - further parameters, which can be multiple values or just the return-values of another function.
    </parameters>
    <chapter_context>
      Developer
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, return values, retval, only first</tags>
  </US_DocBloc>
  --]]
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("RFR", "length", "must be an integer", -1) return end
  if length<1 then ultraschall.AddErrorMessage("RFR", "length", "must be bigger than 0", -2) return end
  local Table={...}
  if length>=#Table then return table.unpack(Table) end
  local Table2={}
  for i=1, length do
    if Table[i]==nil then return table.unpack(Table2) end
    Table2[i]=Table[i]
  end
  return table.unpack(Table2)
end


function RLR(length, ...)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>RLR</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.40
      Lua=5.3
    </requires>
    <functioncall>... = RLR(integer length, ...)</functioncall>
    <description>
      returns only the last x return-values, as given by length.
      
      You can put the return-values of another function and just get the last x ones. So if the function returns 10 returnvalues, 
      but you only need the last two, set length=2 and add the function(with the 10 returnvalues) after it as second parameter.
      
      For example:
      
      integer r, integer g, integer b = reaper.ColorFromNative(integer col)
      
      returns three colorvalues. If you only want the last one(b), use it this way:
      
      b=RLR(1, reaper.ColorFromNative(12739))
      
      returns nil in case of an error
    </description>
    <retvals>
      various ... - the requested last-n returnvalues
    </retvals>
    <parameters>
      integer length - the number of the last return-values to return
      various ... - further parameters, which can be multiple values or just the return-values of another function.
    </parameters>
    <chapter_context>
      Developer
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, return values, retval, only last</tags>
  </US_DocBloc>
  --]]
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("RLR", "length", "must be an integer", -1) return end
  if length<1 then ultraschall.AddErrorMessage("RLR", "length", "must be bigger than 0", -2) return end
  local Table={...}
  if length>=#Table then return table.unpack(Table) end
  local Table2={}
  local a=0
  for i=#Table-length+1, #Table do
    if Table[i]~=nil then 
      a=a+1
      Table2[a]=Table[i]
    end
  end
  return table.unpack(Table2)
end

function RRR(position, length, ...)
--[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>RRR</slug>
    <requires>
      Ultraschall=4.2
      Reaper=5.40
      Lua=5.3
    </requires>
    <functioncall>... = RRR(integer position, integer length, ...)</functioncall>
    <description>
      returns only the x return-values between position and position+length.
      
      You can put the return-values of another function and just get the ones between position and position+length. So if the function returns 10 returnvalues, 
      but you only need the third through the fifth, set position=3 and length=3 and add the function(with the 10 returnvalues) after it as third parameter.
      
      For example:
      
      integer r, integer g, integer b = reaper.ColorFromNative(integer col)
      
      returns three colorvalues. If you only want the middle one(g), use it this way:
      
      g=RRR(2, 1, reaper.ColorFromNative(12739))
         
      returns nil in case of an error
    </description>
    <retvals>
      various ... - the requested n returnvalues between position and length+position
    </retvals>
    <parameters>
      integer position - the first return-value to return
      integer length - the number of return-values to return(position+length)
      various ... - further parameters, which can be multiple values or just the return-values of another function.
    </parameters>
    <chapter_context>
      Developer
      Helper functions
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>ultraschall_functions_engine.lua</source_document>
    <tags>developer, return values, retval, between</tags>
  </US_DocBloc>
  --]]
  if math.type(position)~="integer" then ultraschall.AddErrorMessage("RFR", "position", "must be an integer", -1) return end
  if position<1 then ultraschall.AddErrorMessage("RFR", "position", "must be bigger than 0", -2) return end
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("RFR", "length", "must be an integer", -3) return end
  if length<0 then ultraschall.AddErrorMessage("RFR", "length", "must be bigger or equal 0", -4) return end
  local Table={...}
  local Table2={}
  local a=0
  if length>#Table then length=#Table end
  for i=position, length do
    if Table[i]~=nil then 
      a=a+1
      Table2[a]=Table[i]
    end
  end
  return table.unpack(Table2)
end

function ultraschall.Statechunk_ReplaceEntry(StateChunk, Entry, EntryPositionAbove, EntryPositionBelow, values, nil_defaults)
  --[[
    Helperfunction for replacement of statechunk-entries
    
    Note: this is still experimental, so test all functions, who use this, intensively.
          Might have trouble with nested statechunks and with statechunks who have multiple same-named-entries.
          Tries to replace the very first entry found, which should be fairly stable...
          
          If not, add StateChunk-Layouter into this code, so you can use spaces as pattern to check, which entry
          to replace...
          
          Unchecked: what happens, with layouted statechunks?
  
    StateChunk    - TrackStateChunk
    Entry         - the entry to add/replace
    EntryPositionAbove - this entry must be above the inserted statechunk-entry; will be ignored, if Entry already exists and can be replaced
    EntryPositionBelow - this entry must be below the inserted statechunk-entry; will be ignored, if Entry already exists and can be replaced or if EntryPositionAbove is already set
    values        - the parameter-values to set the statechunk entry with; string is allowed and will be converted to "" if needed
    nil_defaults  - the values, that must be met, to remove the entry from the statechunk; keep nil to always add/replace
  --]]
  local default, Start, End, statechunk_entry
  -- check for default-values to eliminate the entry
  default=true
  if nil_defaults~=nil then
    for i=1, #values do
      if values[i]~=nil_defaults[i] then
        default=false
        break
      end
    end
  else
    default=false
  end

  -- if no defaults, create the statechunk_entry
  if default==false then
    statechunk_entry=Entry
    for i=1, #values do
      if type(values[i])=="string" then
        if values[i]:match(" ")~=nil then
          values[i]="\""..values[i].."\""
        end
      end
      statechunk_entry=statechunk_entry.." "..values[i]
    end
  else
    statechunk_entry=""
  end
  
  if statechunk_entry~="" then statechunk_entry=statechunk_entry.."\n" end
  
  -- if statechunk-entry already exists, simply replace it and return the statechunk
  if StateChunk:match(Entry)~=nil then
    StateChunk=string.gsub(StateChunk, Entry.." .-\n", statechunk_entry)
    return StateChunk
  end
  
  -- if the entry didn't exist, add it either underneath another statechunk-entry
  if EntryPositionAbove~=nil then 
    Start=StateChunk:match("(.-"..EntryPositionAbove..".-\n)")
    End=StateChunk:match(EntryPositionAbove..".-\n".."(.*)") 
    
    return Start..statechunk_entry..End
  -- or add it above another statechunk-entry
  elseif EntryPositionBelow~=nil then
    Start=StateChunk:match("(.-)"..EntryPositionBelow)
    End=StateChunk:match("("..EntryPositionBelow..".-%c.*)") 
    
    return Start..statechunk_entry..End    
  end
end

function string.has_control(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_control</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_control(string value)</functioncall>
  <description>
    returns, if a string has control-characters
  </description>
  <parameters>
    string value - the value to check for control-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, control</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_control' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%c")~=nil
end

function string.has_alphanumeric(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_alphanumeric</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_alphanumeric(string value)</functioncall>
  <description>
    returns, if a string has alphanumeric-characters
  </description>
  <parameters>
    string value - the value to check for alphanumeric-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, alphanumeric</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_alphanumeric' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%w")~=nil
end

function string.has_letter(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_letter</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_letter(string value)</functioncall>
  <description>
    returns, if a string has letter-characters
  </description>
  <parameters>
    string value - the value to check for letter-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, letter</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_letter' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%a")~=nil
end

function string.has_digits(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_digits</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_digits(string value)</functioncall>
  <description>
    returns, if a string has digit-characters
  </description>
  <parameters>
    string value - the value to check for digit-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, digit</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_digits' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%d")~=nil
end

function string.has_printables(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_printables</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_printables(string value)</functioncall>
  <description>
    returns, if a string has printable-characters
  </description>
  <parameters>
    string value - the value to check for printable-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, printable</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_printables' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%g")~=nil
end

function string.has_uppercase(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_uppercase</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_uppercase(string value)</functioncall>
  <description>
    returns, if a string has uppercase-characters
  </description>
  <parameters>
    string value - the value to check for uppercase-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, uppercase</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_uppercase' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%u")~=nil
end

function string.has_lowercase(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_lowercase</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_lowercase(string value)</functioncall>
  <description>
    returns, if a string has lowercase-characters
  </description>
  <parameters>
    string value - the value to check for lowercase-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, lowercase</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_lowercase' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%l")~=nil
end

function string.has_space(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_space</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_space(string value)</functioncall>
  <description>
    returns, if a string has space-characters, like tab or space
  </description>
  <parameters>
    string value - the value to check for space-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, space, tab</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_space' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%s")~=nil
end

function string.has_hex(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>has_hex</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = string.has_hex(string value)</functioncall>
  <description>
    returns, if a string has hex-characters
  </description>
  <parameters>
    string value - the value to check for hex-characters
  </parameters>
  <retvals>
    boolean retval - true, if yes; false, if not
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, has, hex</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then error("bad argument #1, to 'has_hex' (string expected, got "..type(source_string)..")", 2) end
  return String:match("%x")~=nil
end

function string.utf8_sub(source_string, startoffset, endoffset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>utf8_sub</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string ret_string = string.utf8_sub(string source_string, integer startoffset, integer endoffset)</functioncall>
  <description>
    returns a subset of a utf8-encoded-string.
    
    if startoffset and/or endoffset are negative, it is counted from the end of the string.
    
    Works basically like string.sub()
  </description>
  <parameters>
    string value - the value to get the utf8-substring from
    integer startoffset - the startoffset, from which to return the substring; negative offset counts from the end of the string
    integer endoffset - the endoffset, to which to return the substring; negative offset counts from the end of the string
  </parameters>
  <retvals>
    string ret_string - the returned string
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, sub, utf8</tags>
</US_DocBloc>
--]]
  -- written by CFillion for his Interactive ReaScript-Tool, available in the ReaTeam-repository(install via ReaPack)
  -- thanks for allowing me to use it :)
  if type(source_string)~="string" then error("bad argument #1, to 'source_string' (string expected, got "..type(source_string)..")", 2) end
  if math.type(startoffset)~="integer" then error("bad argument #2, to 'startoffset' (integer expected, got "..type(source_string)..")", 2) end
  if math.type(endoffset)~="integer" then error("bad argument #3, to 'endoffset' (integer expected, got "..type(source_string)..")", 2) end
  startoffset = utf8.offset(source_string, startoffset)
  if not startoffset then return '' end -- i is out of bounds

  if endoffset and (endoffset > 0 or endoffset < -1) then
    endoffset = utf8.offset(source_string, endoffset + 1)
    if endoffset then endoffset = endoffset - 1 end
  end

  return string.sub(source_string, startoffset, endoffset)
end

function string.utf8_len(source_string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>utf8_len</slug>
  <requires>
    Ultraschall=4.8
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length = string.utf8_len(string source_string)</functioncall>
  <description>
    returns the length of an utf8-encoded string

    Works basically like string.len()
  </description>
  <parameters>
    string value - the value to get the length of the utf8-encoded-string
  </parameters>
  <retvals>
    integer length - the length of the utf8-encoded string
  </retvals>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>helper functions, string, length, utf8</tags>
</US_DocBloc>
--]]
  if type(source_string)~="string" then error("bad argument #1, to 'utf8_len' (string expected, got "..type(source_string)..")", 2) end
  return utf8.len(source_string)
end

function ultraschall.Debug_ShowCurrentContext(show)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Debug_ShowCurrentContext</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>string functionname, string sourcefilename_with_path, integer linenumber = ultraschall.GetReaperWindow_Position(integer show)</functioncall>
  <description>
    When called, this function returns, in which function, sourcefile and linenumber it was called.
    Good for debugging purposes.
  </description>
  <retvals>
    string functionname - the name of the function, in which Debug_ShowCurrentContext was called
    integer linenumber - the linenumber, in which Debug_ShowCurrentContext was called
    string sourcefilename_with_path - the filename, in which Debug_ShowCurrentContext was called
    number timestamp - precise timestamp to differentiate between two Debug_ShowCurrentContext-calls
  </retvals>
  <parameters>
    integer show - 0, don't show context; 1, show context as messagebox; 2, show context in console; 3, clear console and show context in console
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, arrange-view, position, hwnd, get</tags>
</US_DocBloc>
--]]
  local context=debug.getinfo(2)
  local timestamp=reaper.time_precise()
  if context["name"]==nil then context["name"]="" end
  if show==1 then
    print2("Called in\n\nFunction     : "..context["name"], "\nLinenumber: "..context["currentline"], "\n\nSourceFileName:\n"..context["source"]:sub(2,-1))
  elseif show==2 then
    print_alt("\n>>Called in\n   Function  : "..context["name"], "\n   Linenumber: "..context["currentline"], "\n   SourceFileName: "..context["source"]:sub(2,-1).."\n   Timestamp: "..timestamp)
  elseif show==3 then
    print_update("\n>>Called in\n   Function  : "..context["name"], "   Linenumber: "..context["currentline"], "   SourceFileName: "..context["source"]:sub(2,-1).."\n   Timestamp: "..timestamp)
  end
  return context["name"], context["currentline"], context["source"]:sub(2,-1), timestamp
end


function ultraschall.ConvertIniStringToTable(ini_string, convert_numbers_to_numbers)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertIniStringToTable</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.20
    Lua=5.3
  </requires>
  <functioncall>table ini_entries = ultraschall.ConvertIniStringToTable(string ini_string, boolean convert_numbers_to_numbers)</functioncall>
  <description>
    this converts a string in ini-format into a table
    
    the table is in the format:
        ini_entries["sectionname"]["keyname"]=value
    
    returns nil in case of an error
  </description>
  <retvals>
    table ini_entries - the entries of the ini-file as a table
  </retvals>
  <parameters>
    string ini_string - the string that contains an ini-file-contents
    boolean convert_numbers_to_numbers - true, convert values who are valid numbers to numbers; false or nil, keep all values as strings
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>helperfunctions, convert, ini file, table</tags>
</US_DocBloc>
--]]
  if type(ini_string)~="string" then ultraschall.AddErrorMessage("ConvertIniStringToTable", "ini_string", "must be a string", -1) return end
  if convert_numbers_to_numbers~=nil and type(convert_numbers_to_numbers)~="boolean" then ultraschall.AddErrorMessage("ConvertIniStringToTable", "convert_numbers_to_numbers", "must be either nil or boolean", -2) return end
  local IniTable={}
  local cur_entry=""
  for k in string.gmatch(ini_string, "(.-)\n") do
    if k:sub(1,1)=="[" and k:sub(-1,-1)=="]" then
      cur_entry=k:sub(2,-2)
      IniTable[cur_entry]={}
    else
      local key, value=k:match("(.-)=(.*)")
      if key~=nil then 
        if convert_numbers_to_numbers==true and tonumber(value)~=nil then 
          IniTable[cur_entry][key]=tonumber(value)
        else 
          IniTable[cur_entry][key]=value
        end
      end
    end
  end
  return IniTable
end




ultraschall.WalterElements={
"tcp.dragdropinfo",
"tcp.env",
"tcp.folder",
"tcp.foldercomp",
"tcp.fx",
"tcp.fxbyp",
"tcp.fxembed",
"tcp.fxembedheader.color",
"tcp.fxin",
"tcp.fxparm",
"tcp.fxparm.font",
"tcp.fxparm.margin",
"tcp.io",
"tcp.label",
"tcp.label.color",
"tcp.label.font",
"tcp.label.margin",
"tcp.margin",
"tcp.meter",
"tcp.meter.inputlabel.color",
"tcp.meter.inputlabelbox.color",
"tcp.meter.readout.color",
"tcp.meter.rmsreadout.color",
"tcp.meter.scale.color.lit.bottom",
"tcp.meter.scale.color.lit.top",
"tcp.meter.scale.color.unlit.bottom",
"tcp.meter.scale.color.unlit.top",
"tcp.meter.vu.div",
"tcp.mute",
"tcp.pan",
"tcp.pan.color",
"tcp.pan.fadermode",
"tcp.pan.label",
"tcp.pan.label.color",
"tcp.pan.label.font",
"tcp.pan.label.margin",
"tcp.phase",
"tcp.recarm",
"tcp.recinput",
"tcp.recinput.color",
"tcp.recinput.font",
"tcp.recinput.margin",
"tcp.recmode",
"tcp.recmon",
"tcp.sendlist",
"tcp.sendlist.font",
"tcp.sendlist.margin",
"tcp.size",
"tcp.solo",
"tcp.trackidx",
"tcp.trackidx.color",
"tcp.trackidx.font",
"tcp.trackidx.margin",
"tcp.volume",
"tcp.volume.color",
"tcp.volume.fadermode",
"tcp.volume.label",
"tcp.volume.label.color",
"tcp.volume.label.font",
"tcp.volume.label.margin",
"tcp.width",
"tcp.width.color",
"tcp.width.fadermode",
"tcp.width.label",
"tcp.width.label.color",
"tcp.width.label.font",
"tcp.width.label.margin",
"master.tcp.env",
"master.tcp.fx",
"master.tcp.fxbyp",
"master.tcp.fxembed",
"master.tcp.fxembedheader.color",
"master.tcp.fxparm",
"master.tcp.fxparm.font",
"master.tcp.fxparm.margin",
"master.tcp.io",
"master.tcp.label",
"master.tcp.label.color",
"master.tcp.label.font",
"master.tcp.label.margin",
"master.tcp.margin",
"master.tcp.meter",
"master.tcp.meter.readout.color",
"master.tcp.meter.rmsreadout.color",
"master.tcp.meter.scale.color.lit.bottom",
"master.tcp.meter.scale.color.lit.top",
"master.tcp.meter.scale.color.unlit.bottom",
"master.tcp.meter.scale.color.unlit.top",
"master.tcp.meter.vu.div",
"master.tcp.mono",
"master.tcp.mute",
"master.tcp.pan",
"master.tcp.pan.color",
"master.tcp.pan.fadermode",
"master.tcp.pan.label",
"master.tcp.pan.label.color",
"master.tcp.pan.label.font",
"master.tcp.pan.label.margin",
"master.tcp.sendlist",
"master.tcp.sendlist.font",
"master.tcp.sendlist.margin",
"master.tcp.size",
"master.tcp.solo",
"master.tcp.volume",
"master.tcp.volume.color",
"master.tcp.volume.fadermode",
"master.tcp.volume.label",
"master.tcp.volume.label.color",
"master.tcp.volume.label.font",
"master.tcp.volume.label.margin",
"master.tcp.width",
"master.tcp.width.color",
"master.tcp.width.fadermode",
"master.tcp.width.label",
"master.tcp.width.label.color",
"master.tcp.width.label.font",
"master.tcp.width.label.margin",
"mcp.env",
"mcp.extmixer.mode",
"mcp.extmixer.position",
"mcp.folder",
"mcp.fx",
"mcp.fxbyp",
"mcp.fxin",
"mcp.fxlist.font",
"mcp.fxlist.margin",
"mcp.fxparm.font",
"mcp.fxparm.margin",
"mcp.io",
"mcp.label",
"mcp.label.color",
"mcp.label.font",
"mcp.label.margin",
"mcp.margin",
"mcp.meter",
"mcp.meter.inputlabel.color",
"mcp.meter.inputlabelbox.color",
"mcp.meter.readout.color",
"mcp.meter.rmsreadout.color",
"mcp.meter.scale.color.lit.bottom",
"mcp.meter.scale.color.lit.top",
"mcp.meter.scale.color.unlit.bottom",
"mcp.meter.scale.color.unlit.top",
"mcp.meter.vu.div",
"mcp.mute",
"mcp.pan",
"mcp.pan.color",
"mcp.pan.fadermode",
"mcp.pan.label",
"mcp.pan.label.color",
"mcp.pan.label.font",
"mcp.pan.label.margin",
"mcp.phase",
"mcp.recarm",
"mcp.recinput",
"mcp.recinput.color",
"mcp.recinput.font",
"mcp.recinput.margin",
"mcp.recmode",
"mcp.recmon",
"mcp.sendlist.font",
"mcp.sendlist.margin",
"mcp.size",
"mcp.solo",
"mcp.trackidx",
"mcp.trackidx.color",
"mcp.trackidx.font",
"mcp.trackidx.margin",
"mcp.volume",
"mcp.volume.color",
"mcp.volume.fadermode",
"mcp.volume.label",
"mcp.volume.label.color",
"mcp.volume.label.font",
"mcp.volume.label.margin",
"mcp.width",
"mcp.width.color",
"mcp.width.fadermode",
"mcp.width.label",
"mcp.width.label.color",
"mcp.width.label.font",
"mcp.width.label.margin",
"master.mcp.env",
"master.mcp.extmixer.mode",
"master.mcp.extmixer.position",
"master.mcp.fx",
"master.mcp.fxbyp",
"master.mcp.fxlist.font",
"master.mcp.fxlist.margin",
"master.mcp.fxparm.font",
"master.mcp.fxparm.margin",
"master.mcp.io",
"master.mcp.label",
"master.mcp.label.color",
"master.mcp.label.font",
"master.mcp.label.margin",
"master.mcp.margin",
"master.mcp.menubutton",
"master.mcp.meter",
"master.mcp.meter.readout.color",
"master.mcp.meter.rmsreadout.color",
"master.mcp.meter.scale.color.lit.bottom",
"master.mcp.meter.scale.color.lit.top",
"master.mcp.meter.scale.color.unlit.bottom",
"master.mcp.meter.scale.color.unlit.top",
"master.mcp.meter.vu.div",
"master.mcp.meter.vu.rmsdiv",
"master.mcp.mono",
"master.mcp.mute",
"master.mcp.pan",
"master.mcp.pan.color",
"master.mcp.pan.fadermode",
"master.mcp.pan.label",
"master.mcp.pan.label.color",
"master.mcp.pan.label.font",
"master.mcp.pan.label.margin",
"master.mcp.sendlist.font",
"master.mcp.sendlist.margin",
"master.mcp.size",
"master.mcp.solo",
"master.mcp.volume",
"master.mcp.volume.color",
"master.mcp.volume.fadermode",
"master.mcp.volume.label",
"master.mcp.volume.label.color",
"master.mcp.volume.label.font",
"master.mcp.volume.label.margin",
"master.mcp.width",
"master.mcp.width.color",
"master.mcp.width.fadermode",
"master.mcp.width.label",
"master.mcp.width.label.color",
"master.mcp.width.label.font",
"master.mcp.width.label.margin",
"envcp.arm",
"envcp.bypass",
"envcp.fader",
"envcp.fader.color",
"envcp.fader.fadermode",
"envcp.hide",
"envcp.label",
"envcp.label.color",
"envcp.label.font",
"envcp.label.margin",
"envcp.learn",
"envcp.margin",
"envcp.mod",
"envcp.size",
"envcp.value",
"envcp.value.color",
"envcp.value.font",
"envcp.value.margin",
"trans.automode",
"trans.bpm.edit",
"trans.bpm.edit.color",
"trans.bpm.edit.font",
"trans.bpm.edit.margin",
"trans.bpm.tap",
"trans.bpm.tap.color",
"trans.bpm.tap.font",
"trans.bpm.tap.margin",
"trans.curtimesig",
"trans.curtimesig.color",
"trans.curtimesig.font",
"trans.fwd",
"trans.margin",
"trans.pause",
"trans.play",
"trans.rate",
"trans.rate.color",
"trans.rate.fader",
"trans.rate.fader.color",
"trans.rate.fader.fadermode",
"trans.rate.font",
"trans.rate.margin",
"trans.rec",
"trans.repeat",
"trans.rew",
"trans.sel",
"trans.sel.color",
"trans.sel.font",
"trans.sel.margin",
"trans.size",
"trans.size.dockedheight",
"trans.size.minmax",
"trans.status",
"trans.status.margin",
"trans.stop"}


-- Load ModulatorLoad3000

if ultraschall.US_BetaFunctions==false then
  dofile(ultraschall.Api_Path.."ultraschall_ModulatorLoad3000.lua")
else
  for i=0, 1024 do
    ultraschall.temp_file=reaper.EnumerateFiles(ultraschall.Api_Path.."/Modules/", i)
    if ultraschall.temp_file==nil then break end
    dofile(ultraschall.Api_Path.."/Modules/"..ultraschall.temp_file)
  end
end
ultraschall.ShowLastErrorMessage()
