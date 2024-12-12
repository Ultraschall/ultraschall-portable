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
---    Helper functions Module    ---
-------------------------------------

function ultraschall.SplitStringAtLineFeedToArray(unsplitstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitStringAtLineFeedToArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array split_string = ultraschall.SplitStringAtLineFeedToArray(string unsplitstring)</functioncall>
  <description>
    Splits the string unsplitstring at linefeed/tabs/control characters and puts each of these splitpieces into an array, each splitpiece one array-entry.
    The linefeeds will not(!) be returned in the array's entries.
    Returns the number of entries in the array, as well as the array itself
    If there are no control characters or linefeeds in the string, the array will have only one entry with unsplitstring in it.
  
  returns -1 in case of failure
  </description>
  <parameters>
    string unsplitstring - the string, that shall be split at LineFeed/Tabs/Control Characters. Nil is not allowed.
  </parameters>
  <retvals>
    integer count - number of entries in the split_string-array
    array split_string - an array with all the individual "postsplit"-pieces of the string
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>string, split, linefeed, tabs, control characters, array</tags>
</US_DocBloc>
]]
  local array={}
  if unsplitstring==nil then ultraschall.AddErrorMessage("SplitStringAtLineFeedToArray", "unsplitstring", "nil is not allowed as value", -1) return -1 end
  unsplitstring=string.gsub (unsplitstring, "\r", "")
  unsplitstring=unsplitstring.."\n"
  local count=0
  for k in string.gmatch(unsplitstring, "(.-)\n") do
    count=count+1
    array[count]=k
  end
  if count==0 then return 1, {unsplitstring} end
  return count, array
end


function ultraschall.CountCharacterInString(checkstring, character)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountCharacterInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array positions = ultraschall.CountCharacterInString(string checkstring, string character)</functioncall>
  <description>
    Counts, how often character appears in checkstring and returns the count, as well as a array an with the position-numbers.
    
    returns -1 in case of error
  </description>
  <parameters>
    string checkstring - the string to check search through
    string character - the character to search for. Only single characters are allowed. Controlcodes like \n \t count as single character. Case sensitive.
  </parameters>
  <retvals>
    integer count - the number of occurences of character in checkstring
    array positions - the positionnumbers of the character in checkstring
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, string, character, check, find, count, position, numbers</tags>
</US_DocBloc>
]]
  if type(checkstring)~="string" then ultraschall.AddErrorMessage("CountCharacterInString", "checkstring", "only strings allowed as parameter", -1) return -1 end
  if type(character)~="string" or character:len()>1 then ultraschall.AddErrorMessage("CountCharacterInString", "character", "only a string with one(!) character allowed", -2) return -1 end
  local count=0
  local countarray={}
  for i=1,checkstring:len() do
    if checkstring:sub(0+i,0+i)==character then count=count+1 countarray[count]=i end
  end
  return count, countarray
end

function ultraschall.IsValidMatchingPattern(patstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidMatchingPattern</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidMatchingPattern(string patstring)</functioncall>
  <description>
    Returns, if patstring is a valid pattern-matching-string
  </description>
  <retvals>
    boolean retval - true, patstring is a valid pattern-matching-string; false, patstring isn't a valid pattern-matching-string
  </retvals>
  <parameters>
    string patstring - the string to check for, if it's a valid pattern-matching-string
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, pattern, string, check, valid, matching</tags>
</US_DocBloc>
]]
  local Q="Jam."
  local A=pcall(string.match, Q, patstring)
  return A
end


function ultraschall.CSV2IndividualLinesAsArray(csv_line,separator)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CSV2IndividualLinesAsArray</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, array individual_values = ultraschall.CSV2IndividualLinesAsArray(string csv_line, optional string separator)</functioncall>
  <description>
    convert a csv-string to an array of the individual values. If separator cannot be found, it'll return the original string
    
    returns nil in case of error
  </description>
  <retvals>
    integer count - the number of entries
    array individual_values  - all values, each in an individual array-position
  </retvals>
  <parameters>
    string csv_line - a string as a csv, with all values included and separated by parameter separator
    string separator - the separator, that separates the individual entries; use nil for commas; separators will be removed from the final strings!
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>notes,csv,converter,string,array</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(csv_line)~="string" then ultraschall.AddErrorMessage("CSV2IndividualLinesAsArray","csv_line", "only string is allowed", -1) return -1 end
  if separator==nil then separator="," end

  -- set variables
  local count=1
  local line_array={}

  -- small workaround
  csv_line=csv_line..separator

  -- do the patternmatching-magic
  for line in csv_line:gmatch("(.-)"..separator) do
    line_array[count]=line
    count=count+1
  end

  return count-1, line_array
end


function ultraschall.RoundNumber(num)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RoundNumber</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.RoundNumber(number num)</functioncall>
  <description>
    returns a rounded value of the parameter number. %.5 and higher rounds up, lower than %.5 round down.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer retval  - the rounded number
  </retvals>
  <parameters>
    number num - the floatingpoint number, you'd like to have rounded.
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>number, rounding</tags>
</US_DocBloc>
--]]
    -- check parameters  
    if type(num)~="number" then ultraschall.AddErrorMessage("RoundNumber","number", "only a number allowed", -1) return nil end
    
    -- do the math
    return num % 1 >= 0.5 and math.ceil(num) or math.floor(num)
end

function ultraschall.GetPartialString(str,sep1,sep2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPartialString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string partial_string = ultraschall.GetPartialString(string str, string sep1, string sep2)</functioncall>
  <description>
    returns the part of a filename-string between sep1 and sep2
    
    returns nil if it doesn't work, no sep1 or sep2 exist 
  </description>
  <retvals>
    string partial_string  - the partial string between sep1 and sep2
  </retvals>
  <parameters>
    string str - string to be processed
    string sep1 - separator on the "left" side of the partial string
    string sep2 - separator on the "right" side of the partial string
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>string,separator</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(str)~="string" then ultraschall.AddErrorMessage("GetPartialString","str", "only a string allowed", -1) return nil end
  if type(sep1)~="string" then ultraschall.AddErrorMessage("GetPartialString","sep1", "only a string allowed", -2) return nil end
  if type(sep2)~="string" then ultraschall.AddErrorMessage("GetPartialString","sep2", "only a string allowed", -3) return nil end

  -- escape some characters
  if sep1=="%" then sep1="%%" end
  if sep2=="%" then sep2="%%" end
  if sep1=="." then sep1="%." end
  if sep2=="." then sep2="%." end
  
  -- do the pattern matching  
  local result=str:match(sep1.."(.*)"..sep2)
    
  if result==nil then ultraschall.AddErrorMessage("GetPartialString","", "separator not found", -4) return nil end
  return result
end
  


function ultraschall.Notes2CSV()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Notes2CSV</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string csv_retval = ultraschall.Notes2CSV()</functioncall>
  <description>
    Gets the project's notes and returns it as a CSV.
  </description>
  <retvals>
    string csv_retval  - the project notes, returned as a csv-string; entries separated by a comma
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>notes,csv,converter,string</tags>
</US_DocBloc>
--]]
  local csv = ""
  local linenumber=1
  local notes = reaper.GetSetProjectNotes(0, false, "")
  for line in notes:gmatch"[^\n]*" do
    csv = csv .. "," .. line --escapeCSV(line)
  end
    
  local retval= string.sub(csv, 2) -- remove first ","
  return retval
end


function ultraschall.CSV2Line(csv_line)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CSV2Line</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string values = ultraschall.CSV2Line(string csv_line)</functioncall>
  <description>
    converts a string of csv-values into a string with all values and without the ,-separators
    
    returns nil in case of error
  </description>
  <retvals>
    string values  - all values in one string
  </retvals>
string csv_line - the csv-line, values separated by commas
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>notes,csv,converter,string</tags>
</US_DocBloc>
--]]
  -- check parameter
  if type(csv_line)~="string" then ultraschall.AddErrorMessage("CSV2Line","csv_line", "only string is allowed", -1) return nil end
  
  -- do the magic
  if tonumber(csv_line)~=nil then return tostring(csv_line) end
  return string.gsub(csv_line, ",", "")
end


function ultraschall.IsItemInTrack(tracknumber, itemIDX)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsItemInTrack</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsItemInTrack(integer tracknumber, integer itemIDX)</functioncall>
  <description>
    checks, whether a given item is part of the track tracknumber
    
    returns true, if the itemIDX is part of track tracknumber, false if not, nil if no such itemIDX or Tracknumber available
  </description>
  <retvals>
    boolean retval - true, if item is in track, false if item isn't in track
  </retvals>
  <parameters>
    integer itemIDX - the number of the item to check of
    integer tracknumber - the number of the track to check in, with 1 for track 1, 2 for track 2, etc.
  </parameters>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>itemmanagement,item,track,existence</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("IsItemInTrack","tracknumber", "only integer is allowed", -1) return nil end
  if math.type(itemIDX)~="integer" then ultraschall.AddErrorMessage("IsItemInTrack","itemIDX", "only integer is allowed", -2) return nil end
  
  if tracknumber>reaper.CountTracks(0) or tracknumber<0 then ultraschall.AddErrorMessage("IsItemInTrack","tracknumber", "no such track in this project", -3) return nil end
  if itemIDX>reaper.CountMediaItems(0)-1 or itemIDX<0 then ultraschall.AddErrorMessage("IsItemInTrack","itemIDX", "no such item in this project", -4) return nil end
  
  -- Get the tracks and items
  local MediaTrack=reaper.GetTrack(0, tracknumber-1) 
  local MediaItem=reaper.GetMediaItem(0, itemIDX)
  local MediaTrack2=reaper.GetMediaItem_Track(MediaItem)
  
  -- check and return
  if MediaTrack==MediaTrack2 then return true 
  else return false
  end  
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
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>command, commandid, actioncommandid, check, validity</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(aid)~="integer" and type(aid)~="string" then ultraschall.AddErrorMessage("CheckActionCommandIDFormat", "action_command_id", "must be an integer or a string", -1) return false end
  
  if math.type(tonumber(aid))=="integer" and 
     tonumber(aid)==math.floor(tonumber(aid)) and 
     tonumber(aid)<=65535 and 
     tonumber(aid)>=0 then 
     
     return true -- is it a valid number?
  elseif type(aid)=="string" and aid:sub(1,1)=="_" and aid:len()>1 then return true -- is it a valid string, formatted right=
  else return false -- if neither, return false
  end
end

function ultraschall.CheckActionCommandIDFormat2(aid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckActionCommandIDFormat2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CheckActionCommandIDFormat2(action_command_id)</functioncall>
  <description>
    Checks, whether an action command id is a valid commandid(which is a number) or a valid _action_command_id (which is a string with an _underscore in the beginning).
    
    Unlike CheckActionCommandIDFormat, this checks whether an action-command-id-string is an actual registered one(case sensitive!).
    
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
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>command, commandid, actioncommandid, check, validity</tags>
</US_DocBloc>
--]]
  -- check parameter
  if math.type(aid)~="integer" and type(aid)~="string" then ultraschall.AddErrorMessage("CheckActionCommandIDFormat2", "action_command_id", "must be an integer or a string", -1) return false end
  
  if type(aid)=="number" and tonumber(aid)==math.floor(tonumber(aid)) and tonumber(aid)<=65535 and tonumber(aid)>=0 then return true -- is it a valid number?
  elseif type(aid)=="string" and aid:sub(1,1)=="_" and aid:len()>1 and reaper.NamedCommandLookup(tostring(aid))~=0 then return true -- is it a valid string, formatted right=
  else return false -- if neither, return false
  end
end


function ultraschall.ToggleStateAction(section, actioncommand_id, state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleStateAction</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.ToggleStateAction(integer section, string actioncommand_id, integer state)</functioncall>
  <description>
    Toggles state of an action using the actioncommand_id(instead of the CommandID-number)
    
    returns current state of the action after toggling or -1 in case of error.
  </description>
  <retvals>
    integer retval  - state if the action, after it has been toggled
  </retvals>
  <parameters>
    integer section - the section of the action(see ShowActionlist-dialog)
                            -0 - Main
                            -100 - Main (alt recording)
                            -32060 - MIDI Editor
                            -32061 - MIDI Event List Editor
                            -32062 - MIDI Inline Editor
                            -32063 - Media Explorer
    string actioncommand_id - the ActionCommandID of the action to toggle
    integer state - toggle-state 
                    -0, off
                    -&1, on/checked in menus
                    -&2, on/grayed out in menus
                    -&16, on/bullet in front of the entry in menus
                    --1, NA because the action does not have on/off states.
  </parameters>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>command,commandid,actioncommandid,action,run,state,section</tags>
</US_DocBloc>
--]]
  -- check parameters
  if actioncommand_id==nil then ultraschall.AddErrorMessage("ToggleStateAction", "action_command_id", "must be a number or a string", -1) return -1 end
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("ToggleStateAction", "state", "must be an integer", -2) return -1 end
  if math.type(section)~="integer" then ultraschall.AddErrorMessage("ToggleStateAction", "section", "must be an integer", -3) return -1 end
  
  -- do the toggling
  local command_id = reaper.NamedCommandLookup(actioncommand_id)
  reaper.SetToggleCommandState(section, command_id, state)
  return reaper.GetToggleCommandState(command_id)
end


function ultraschall.RefreshToolbar_Action(section, actioncommand_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RefreshToolbar_Action</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.RefreshToolbar_Action(integer section, string actioncommand_id)</functioncall>
  <description>
    Refreshes a toolbarbutton with an ActionCommandID(instead of the CommandID-number)
    
    returns -1 in case of error
  </description>
  <parameters>
    integer section - section
                            -0 - Main
                            -100 - Main (alt recording)
                            -32060 - MIDI Editor
                            -32061 - MIDI Event List Editor
                            -32062 - MIDI Inline Editor
                            -32063 - Media Explorer
    string actioncommand_id - ActionCommandID of the action, associated with the toolbarbutton 
  </parameters>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>command,commandid,actioncommandid,action,run,toolbar,refresh</tags>
</US_DocBloc>
--]]
  -- check parameters
  if actioncommand_id==nil then ultraschall.AddErrorMessage("RefreshToolbar_Action", "action_command_id", "must be a number or a string", -1) return -1 end
  if math.type(section)~="integer" then ultraschall.AddErrorMessage("RefreshToolbar_Action", "section", "must be an integer", -2) return -1 end
  
  -- do the refreshing
  local command_id = reaper.NamedCommandLookup(actioncommand_id)
  reaper.RefreshToolbar2(0, command_id)
  return 0
end

function ultraschall.ToggleStateButton(section, actioncommand_id, state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ToggleStateButton</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ToggleStateButton(integer section, string actioncommand_id, integer state)</functioncall>
  <description>
    Toggles state and refreshes the button of an actioncommand_id
    
    returns false in case of error
  </description>
  <retvals>
    boolean retval  - true, toggling worked; false, toggling didn't work
  </retvals>
  <parameters>
    integer section - the section of the action(see ShowActionlist-dialog)
                            -0 - Main
                            -100 - Main (alt recording)
                            -32060 - MIDI Editor
                            -32061 - MIDI Event List Editor
                            -32062 - MIDI Inline Editor
                            -32063 - Media Explorer
    string actioncommand_id - the ActionCommandID of the action to toggle
    integer state - 1 or 0
  </parameters>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>command,commandid,actioncommandid,action,run,toolbar,toggle,button</tags>
</US_DocBloc>
--]]
  if actioncommand_id==nil then ultraschall.AddErrorMessage("ToggleStateButton", "action_command_id", "must be a string or a number", -1) return false end
  if math.type(state)~="integer" then ultraschall.AddErrorMessage("ToggleStateButton", "state", "must be an integer", -2) return false end
  if math.type(section)~="integer" then ultraschall.AddErrorMessage("ToggleStateButton", "section", "must be an integer", -3) return false end

  local command_id = reaper.NamedCommandLookup(actioncommand_id)
  local stater=reaper.SetToggleCommandState(section, command_id, state)
  reaper.RefreshToolbar(command_id)
  if stater==false then ultraschall.AddErrorMessage("ToggleStateButton", "action_command_id", "doesn't exist", -4) return false end
  return stater
end

function ultraschall.SecondsToTime(pos)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SecondsToTime</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string time_string = ultraschall.SecondsToTime(number pos)</functioncall>
  <description>
    converts timeposition in seconds(pos) to a timestring (h)hh:mm:ss.mss
    
    returns nil in case of error
  </description>
  <retvals>
    string time_string  - timestring in (h)hh:mm:ss.mss
  </retvals>
  <parameters>
    number pos - timeposition in seconds
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>timestring, converter, seconds, string</tags>
</US_DocBloc>
--]]
  -- check parameter
  if type(pos)~="number" then ultraschall.AddErrorMessage("SecondsToTime","pos", "only numbers allowed", -1) return nil end
  if pos>359999999999998175 then ultraschall.AddErrorMessage("SecondsToTime","pos", "out of range, maximum value is 359999999999998175", -2) return nil end
  
  -- prepare variables
  local hours=0
  local minutes=0
  local seconds=0
  local milliseconds=0
  local temp=0
  local tempo=0
  local tempo2=0
  local trailinghour=""
  local trailingminute=""
  local trailingsecond="" 
  local trailingmilli=""
  
  -- create time-string
  if pos>=3600 then temp=tostring(pos/3600) hours=tonumber(temp:match("%d*")) pos=pos-(3600*hours) end -- get hours
  if pos>=60 then temp=tostring(pos/60) minutes=tonumber(temp:match("(%d*)")) pos=pos-(60*minutes) end -- get minutes
  
  -- seconds
  temp=tostring(pos)
  seconds=pos
  
  -- milliseconds
  tempo=tostring(seconds)
  tempo2=tempo:match("%.%d*")
  if tempo2==nil then tempo2=".0" end
  milliseconds=tempo2:sub(2,4)
  if milliseconds:len()==2 then milliseconds=milliseconds.."0" end
  if milliseconds:len()==1 then milliseconds=milliseconds.."00" end
  if seconds==nil then seconds=0.0 end
  
  -- get trailing hours/minutes/seconds
  if hours<10 then trailinghour="0" else trailinghour="" end
  if minutes<10 then trailingminute="0" else trailingminute="" end
  if seconds<10 then trailingsecond="0" else trailingsecond="" end
  seconds=tostring(seconds)
  seconds=seconds:match("%d*.")
  if seconds:sub(-1,-1)=="." then seconds=seconds:sub(1,-2) end
  
  -- return created time-string
  return trailinghour..hours..":"..trailingminute..minutes..":"..trailingsecond..seconds.."."..milliseconds
end

function ultraschall.TimeToSeconds(timestring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TimeToSeconds</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>number position = ultraschall.TimeToSeconds(string timestring)</functioncall>
  <description>
    converts a timestring days:hours:minutes:seconds.milliseconds to timeposition in seconds
    it is ok, to have only some of the last ones given, so i.e. excluding days and hours is ok. Though excluding values inbetween does not work!
     
    A single integer in timestring will be seen as seconds.
    To only specifiy milliseconds in particular, start the number with a .
    all other values are separated by :
    
    returns -1 in case of error, timestring is a nil or if you try to add an additional value, added before days
    
    does not check for valid timeranges, so 61 minutes is possible to give, even if hours are present in the string
  </description>
  <retvals>
    number position  - the converted position
  </retvals>
  <parameters>
    string timestring - a string like: days:hours:minutes:seconds.milliseconds , i.e. 1:16:27:50.098
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>timestring, converter, seconds, string</tags>
</US_DocBloc>
--]]
  -- check parameter
  if type(timestring)~="string" then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "only string is allowed", -1) return -1 end

  -- prepare variables
  local hour=0
  local milliseconds=0
  local minute=0
  local seconds=0
  local time=0
  local day=0

  -- get milliseconds
  milliseconds=timestring:match("%..*")
  if tonumber(milliseconds)==nil and milliseconds~=nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring" ,"invalid milliseconds", -2) return -1 end
  if milliseconds==nil then milliseconds=0 end
  if milliseconds=="" then milliseconds=".0 " end
  if milliseconds=="0" then milliseconds=".0 " end
  if milliseconds==0 then milliseconds=".0 " end
  if milliseconds=="." then milliseconds=0 end
    
  -- get seconds  
  if timestring:match("%.%d*")~=nil then timestring=timestring:match("(.*)%.") end
  if tonumber(timestring)~=nil then seconds=tonumber(timestring)
  elseif timestring==nil then seconds=0
  else
    seconds=tonumber(timestring:match(".*:(.*)"))
  end
  if seconds==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid seconds", -3) return -1 end

  -- getminutes
  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then minute=tonumber(timestring)
  elseif timestring==nil then minute=0
  else
    minute=tonumber(timestring:match(".*:(.*)"))
  end
  if minute==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid minute", -4) return -1 end

  -- get hours
  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then hour=tonumber(timestring)
  elseif timestring==nil then hour=0
  else
    hour=tonumber(timestring:match(".*:(.*)"))
  end
  if hour==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid hour", -5) return -1 end

  -- get days
  if timestring~=nil then timestring=timestring:match("(.*):") end
  if tonumber(timestring)~=nil then day=tonumber(timestring)
  elseif timestring==nil then day=0
  else
    day=tonumber(timestring:match(".*:(.*)"))
  end
  if day==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid day", -6) return -1 end
  
  if timestring~=nil then timestring=timestring:match("(.*):") end
    
  if timestring~=nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid timestring, must be of format: \"days:hours:minutes:seconds.milliseconds\". You can omit the first ones, but never the last one!", -7) return -1 end

  -- check, if the found values are numbers
  if day~=nil and tonumber(day)==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid day", -8) return -1 end
  if hour~=nil and tonumber(hour)==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid hour", -9) return -1 end
  if minute~=nil and tonumber(minute)==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid minute", -10) return -1 end
  if seconds~=nil and tonumber(seconds)==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring", "invalid seconds", -11) return -1 end
  if milliseconds~=nil and tonumber(milliseconds)==nil then ultraschall.AddErrorMessage("TimeToSeconds","timestring" ,"invalid milliseconds", -12) return -1 end

  -- if certain values weren't found, set them to 0
  if day==nil then day=0 end
  if hour==nil then hour=0 end
  if minute==nil then minute=0 end
  if seconds==nil then seconds=0 end
  if milliseconds==nil then milliseconds=0 end
    
  -- return time
  return (day*86400)+(hour*3600)+(minute*60)+seconds+milliseconds
end


function ultraschall.SecondsToTimeString_hh_mm_ss_mss(time)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SecondsToTimeString_hh_mm_ss_mss</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string timestring = ultraschall.SecondsToTimeString_hh_mm_ss_mss(number time)</functioncall>
  <description>
    Converts the parameter time into a timestring of the format hh:mm:ss.mss
    Valid timeranges are from 0 to 359999.99 seconds(about 99 hours).
    
    returns -1 in case of error
  </description>
  <parameters>
    number time - the time in seconds to be converted into the timestring
  </parameters>
  <retvals>
    string timestring - the converted timestring. It will always follow the format hh:mm:ss.mss and fill up digits with zeros, if necessary.
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>timestring, converter, seconds, string</tags>
</US_DocBloc>
]]
  if type(time)~="number" then ultraschall.AddErrorMessage("SecondsToTimeString_hh_mm_ss_mss","time", "must be a string", -1) return -1 end
  if time<0 then ultraschall.AddErrorMessage("SecondsToTimeString_hh_mm_ss_mss","time", "must be bigger or equal 0", -2) return -1 end
  local Buf2 = reaper.format_timestr_len(time, "", 0, 5)
  local Hour=Buf2:match("(.-):")
  local Ms=tostring(time):match("%.(.*)")
  if Ms==nil then Ms="0" end
  Ms=Ms.."00000"
  Ms=Ms:sub(1,3)
  local Len=string.len(Hour)
  if Len==1 then Buf2="0"..Buf2 end
  if Len>2 then ultraschall.AddErrorMessage("SecondsToTimeString_hh_mm_ss_mss","time", "must be smaller than 359999.99 seconds(about 99 hours)", -3) return -1 end --Buf2=Buf2:sub(Len-1,-1) end
  return Buf2:match("(.*):").."."..Ms
end

--A=ultraschall.SecondsToTimeString_hh_mm_ss_mss(999999)

function ultraschall.TimeStringToSeconds_hh_mm_ss_mss(timestring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TimeStringToSeconds_hh_mm_ss_mss</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>number time = ultraschall.TimeStringToSeconds_hh_mm_ss_mss(string timestring)</functioncall>
  <description>
    Converts the parameter timestring of the format hh:mm:ss.mss into seconds
    The timestring must follow strictly this format, or the function returns -1 as result.
    
    returns -1 in case of error
  </description>
  <parameters>
    string timestring - the converted timestring. It must always follow the format hh:mm:ss.mss. Fill up digits with zeros, if necessary.
  </parameters>
  <retvals>
    number time - the time in seconds to be converted into the timestring, -1 in case of an error
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>timestring, converter, seconds, string</tags>
</US_DocBloc>
]]
  if type(timestring)~="string" then ultraschall.AddErrorMessage("TimeStringToSeconds_hh_mm_ss_mss","timestring", "must be a string", -1) return -1 end
  local Hour=timestring:match("(%d-):")
  if Hour==nil or string.len(Hour)~=2 then ultraschall.AddErrorMessage("TimeStringToSeconds_hh_mm_ss_mss","timestring", "no valid timestring", -2) return -1 end
  local Minute=timestring:match("%d%d:(%d-):")
  if Minute==nil or string.len(Minute)~=2 then ultraschall.AddErrorMessage("TimeStringToSeconds_hh_mm_ss_mss","timestring", "no valid timestring", -2) return -1 end
  local Second=timestring:match("%d%d:%d%d:(%d-)%.")
  if Second==nil or string.len(Second)~=2 then ultraschall.AddErrorMessage("TimeStringToSeconds_hh_mm_ss_mss","timestring", "no valid timestring", -2) return -1 end
  local MilliSeconds=timestring:match("%d%d:%d%d:%d%d(%.%d*)")
  if MilliSeconds==nil or string.len(MilliSeconds)~=4 then ultraschall.AddErrorMessage("TimeStringToSeconds_hh_mm_ss_mss","timestring", "no valid timestring", -2) return -1 end
  return (Hour*3600)+(Minute*60)+Second+tonumber(MilliSeconds)
end

--A=ultraschall.TimeStringToSeconds_hh_mm_ss_mss("Hula")

function ultraschall.CountPatternInString(sourcestring, searchstring, non_case_sensitive)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountPatternInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.52
    Lua=5.3
  </requires>
  <functioncall>integer count, array positions = ultraschall.CountPatternInString(string sourcestring, string searchstring, boolean non_case_sensitive)</functioncall>
  <description>
    returns the count and an array with all positions of searchstring in sourcestring.
  </description>
  <retvals>
    integer count - the number of appearances of searchstring in sourcestring
    array positions - an array with count-entries, where every entry contains the position of searchstring in sourcestring
  </retvals>
  <parameters>
    string sourcestring - the string, you want to search through
    string searchstring - the string, you want to search for in sourcestring
    boolean non_case_sensitive - true, the search does not care about case-sensitivity; false, case of searchstring will be kept
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, string, character, check, find, count, position, numbers</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(sourcestring)~="string" then ultraschall.AddErrorMessage("CountPatternInString", "sourcestring", "must be a string", -1) return -1 end
  if type(searchstring)~="string" then ultraschall.AddErrorMessage("CountPatternInString", "searchstring", "must be a string", -2) return -1 end
  if type(non_case_sensitive)~="boolean" then ultraschall.AddErrorMessage("CountPatternInString", "non_case_sensitive", "must be a boolean", -3) return -1 end
  
  -- prepare variables
  local Position={}
  local count=1  
  
  -- if case-sensitivity doesn't matter, make the strings lowercase
  if non_case_sensitive==true then 
    sourcestring=sourcestring:lower() 
    searchstring=searchstring:lower() 
  end
    
  -- now do the searching and create a table with all appearance-positions
  while sourcestring:match(searchstring)~=nil do
    Position[count]=sourcestring:match(".*()"..searchstring)
    sourcestring=sourcestring:sub(1,Position[count]-1)
    count=count+1  
  end
  -- sort it
  table.sort(Position)
  
  -- return number of appearances and the position-table
  return count-1, Position
end

--A,AA=ultraschall.CountPatternInString("HulaLLHulaLHulaHula,HULA,HuLahUlA", "Hula", false)


function ultraschall.OpenURL(url)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OpenURL</slug>
  <requires>
    Ultraschall=4.7
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.OpenURL(string url)</functioncall>
  <description>
    Opens the URI with the standard-browser installed in your system.
    
    returns -1 in case of an error
  </description>
  <retval>
      integer retval - -1 in case of error; 1, in case of success
  </retval>
  <parameters>
    string url - the url to be opened in the browser; will check for :// in it for validity!
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, string, url, open, browser</tags>
</US_DocBloc>
--]]
  if type(url)~="string" then ultraschall.AddErrorMessage("OpenURL","url", "Must be a string.", -1) return -1 end
  local OS=reaper.GetOS()
  url="\""..url.."\""
  if OS=="OSX32" or OS=="OSX64" or OS=="macOS-arm64" then
    os.execute("open ".. url)
  elseif OS=="Other" then
    os.execute("xdg-open "..url)
  else
    --reaper.BR_Win32_ShellExecute("open", url, "", "", 0)
    --ACHWAS,ACHWAS2 = reaper.ExecProcess("%WINDIR\\SysWow64\\cmd.exe \"Ultraschall-URL\" /B ".. url, 0)
    os.execute("start \"Ultraschall-URL\" /B ".. url)
  end
  return 1
end

function ultraschall.CountEntriesInTable_Main(the_table)
-- counts only the entries in the main table; subtables are not count but returned as retval2, with the number of entries in retval
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountEntriesInTable_Main</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer count, table subtables, integer count_of_subtables = ultraschall.CountEntriesInTable_Main(table the_table)</functioncall>
  <description>
    Counts the number of entries in an indexed table.
    Will only count the entries from the main-table, not it's subtables. If you want to know the number of subtables, this function returns a table that includes all subtables found in the main-table,
    as well as the number of found subtables.
    
    Returns -1 if table isn't a valid table
  </description>
  <parameters>
    table table - the table, whose entries you want to count
  </parameters>
  <retvals>
    integer count - the number of entries in the table
    table subtables - if an entry of table has a table as value, that table-value will be included in this subtables-table(for recursive counting-usecases)
    integer count_of_subtables - the number of entries in the subtables-table
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, count, entries, table, array, maintable</tags>
</US_DocBloc>
--]]
  if type(the_table)~="table" then ultraschall.AddErrorMessage("CountEntriesInTable_Main","table", "Must be a table!", -1) return -1 end
  local count=1
  local SubTables={}
  local SubTablesCount=1
  while the_table[count]~=nil do
--    reaper.MB(tostring(the_table[count]),"",0)
    if type(the_table[count])=="table" then SubTables[SubTablesCount]=v SubTablesCount=SubTablesCount+1 end
    count=count+1
  end
  return count-1, SubTables, SubTablesCount-1
end



function ultraschall.CompareArrays(Array, CompareArray2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CompareArrays</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table diff_array = ultraschall.CompareArrays(table Array, table CompareArray2)</functioncall>
  <description>
    Compares Array using parameter CompareArray2 and returns an array with all entries in CompareArray2, that are not in Array.
    The comparable arrays must be indexed by integer-numbers.
    
    Returns nil in case of an error
  </description>
  <parameters>
    table Array - the reference-array
    table CompareArray2 - the array you want to check against Array; all entries in CompareArray2 that are not in Array will be returned
  </parameters>
  <retvals>
    table diff_array - an array with all entries from CompareArray2, that are not in Array
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, compare, table, array, indexed</tags>
</US_DocBloc>
--]]

  if type(Array)~="table" then ultraschall.AddErrorMessage("CompareArrays","Array", "Must be a table!", -1) return nil end
  if type(CompareArray2)~="table" then ultraschall.AddErrorMessage("CompareArrays","CompareArray2", "Must be a table!", -2) return nil end
  local count, subtables, count_of_subtables = ultraschall.CountEntriesInTable_Main(Array)
  local count2, subtables2, count_of_subtables2 = ultraschall.CountEntriesInTable_Main(CompareArray2)
  local Array3={}
  local x,y,count3,check
  check=false
  count3=1
  for a=1, count2 do
    check=false
    for i=1, count do
      x=Array[i]
      y=CompareArray2[a]
      if x==y then check=true end
    end
    if check==false then Array3[count3]=y count3=count3+1 end 
  end

  return Array3, count3-1
end


function ultraschall.GetOS()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetOS</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.17
    Lua=5.3
  </requires>
  <functioncall>string operating_system, integer bits = ultraschall.GetOS()</functioncall>
  <description>
    Returns operating system and if it's a 64bit/32bit-operating system.
  </description>
  <retvals>
    string operating_system - the operating system used; usually "Win", "Mac" or "Other"(e.g. when Linux is used)
    integer bits - the number of bits of the operating-system. Either 32 or 64 bit.
  </retvals>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, operating system, os, mac, win, osx, linux, other, bits</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local retval=reaper.GetOS()
  local Os, bits
  
  -- check for os and bits and return it
  if retval:match("Win")~=nil then Os="Win" end
  if retval:match("OSX")~=nil then Os="Mac" end
  if retval:match("macOS-arm64")~=nil then OS="Mac" end
  if retval:match("Other")~=nil then Os="Other" end
  if retval:match("32")~=nil then bits=32 end
  if retval:match("64")~=nil then bits=64 end
  return Os, bits
end

function ultraschall.IsOS_Windows()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsOS_Windows</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean is_windows, integer number_of_bits = ultraschall.IsOS_Windows()</functioncall>
  <description>
    returns, if the current operating system is windows
  </description>
  <retvals>
    boolean is_windows - true, if the operating-system is windows; false if not
    integer bits - the number of bits of the operating-system. Either 32 or 64 bit; nil if is_win==false
  </retvals>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, operating system, os, check, win, bits</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local retval=reaper.GetOS()
  local Os, bits
  
  -- check for os and bits
  if retval:match("Win")~=nil then Os=true 
  else
    Os=false
  end
  if Os==true and retval:match("32")~=nil then bits=32 end
  if Os==true and retval:match("64")~=nil then bits=64 end
  return Os, bits
end

--L,LL=ultraschall.IsOS_Windows()

ultraschall.IsOS_Win=ultraschall.IsOS_Windows

function ultraschall.IsOS_Mac()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsOS_Mac</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.19
    Lua=5.3
  </requires>
  <functioncall>boolean is_mac, integer number_of_bits = ultraschall.IsOS_Mac()</functioncall>
  <description>
    returns, if the current operating system is mac-osx
  </description>
  <retvals>
    boolean is_mac - true, if the operating-system is mac-osx; false if not
    integer bits - the number of bits of the operating-system. Either 32 or 64 bit.; nil if is_mac=false
  </retvals>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, operating system, os, mac, osx, bits</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local retval=reaper.GetOS()
  local Os, bits
  
  -- check for os and bits
  if retval:match("OSX")~=nil or retval:match("macOS%-arm64")~=nil then Os=true 
  else
    Os=false
  end
  if Os==true and retval:match("32")~=nil then bits=32 end
  if Os==true and retval:match("64")~=nil then bits=64 end
  return Os, bits
end


function ultraschall.IsOS_Other()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsOS_Other</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean is_other, integer number_of_bits = ultraschall.IsOS_Other()</functioncall>
  <description>
    returns, if the current operating system is neither mac or win
  </description>
  <retvals>
    boolean is_other - true, if the operating-system is neither mac or win; false if not
    integer bits - the number of bits of the operating-system. Either 32 or 64 bit.; nil if is_other=false
  </retvals>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, operating system, os, other, linux, bits</tags>
</US_DocBloc>
--]]
  -- prepare variables
  local retval=reaper.GetOS()
  local Os, bits
  
  -- check for os and bits
  if retval:match("Other")~=nil then Os=true 
  else
    Os=false
  end
  if Os==true and retval:match("32")~=nil then bits=32 end
  if Os==true and retval:match("64")~=nil then bits=64 end
  return Os, bits
end

function ultraschall.GetReaperAppVersion()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperAppVersion</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer majorversion, integer subversion, string bits, string operating_system, boolean portable, optional string betaversion = ultraschall.GetReaperAppVersion()</functioncall>
  <description>
    Returns operating system and if it's a 64bit/32bit-operating system.
  </description>
  <retvals>
    integer majorversion - the majorversion of Reaper. Can be used for comparisions like "if version<5 then ... end".
    integer subversion - the subversion of Reaper. Can be used for comparisions like "if subversion<96 then ... end".
    string bits - the number of bits of the reaper-app
    string operating_system - the operating system, either "Win", "OSX" or "Other"
    boolean portable - true, if it's a portable installation; false, if it isn't a portable installation
    optional string betaversion - if you use a pre-release of Reaper, this contains the beta-version, like "rc9" or "+dev0423" or "pre6"
  </retvals>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, appversion, reaper, version, bits, majorversion, subversion, operating system</tags>
</US_DocBloc>
--]]
  -- if exe-path and resource-path are the same, it is an portable-installation
  local portable
  if reaper.GetExePath()==reaper.GetResourcePath() then portable=true else portable=false end
  -- separate the returned value from GetAppVersion
  local majvers=tonumber(reaper.GetAppVersion():match("(.-)%..-/"))
  local subvers=tonumber(reaper.GetAppVersion():match("%.(%d*)"))
  local bits=reaper.GetAppVersion():match("/(.*)")
  local OS=reaper.GetOS():match("(.-)%d")
  local beta=reaper.GetAppVersion():match("%.%d*(.-)/")
  return majvers, subvers, bits, OS, portable, beta
end


function ultraschall.unused_GetReaperAppVersion()
--[[
<\US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperAppVersion</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>integer majorversion, integer subversion, integer bits, string operating_system, boolean portable, string betaversion, boolean arm_cpu, string additional_architecture_info = ultraschall.GetReaperAppVersion()</functioncall>
  <description>
    Returns operating system and if it's a 64bit/32bit-operating system.
  </description>
  <retvals>
    integer majorversion - the majorversion of Reaper. Can be used for comparisions like "if version<5 then ... end".
    integer subversion - the subversion of Reaper. Can be used for comparisions like "if subversion<96 then ... end".
    integer bits - the number of bits of the reaper-app
    string operating_system - the operating system, either "Win", "OSX", "Linux" or "Other"(the latter on Reaper<6.16)
    boolean portable - true, if it's a portable installation; false, if it isn't a portable installation
    string betaversion - if you use a pre-release of Reaper, this contains the beta-version, like "rc9" or "+dev0423" or "pre6"
    boolean arm_cpu - true, you use an ARM-cpu-version of Reaper; false, you don't use an ARM-cpu-version of Reaper
    string additional_architecture_info - additional information about the architecture; currently "icc", "arm", "x86_64", "i686", "armv7l", "aarch64" or ""
  </retvals>
  <chapter_context>
    API-Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, appversion, reaper, version, bits, majorversion, subversion, operating system</tags>
<\/US_DocBloc>
--]]
  -- if exe-path and resource-path are the same, it is an portable-installation
  local portable
  if reaper.GetExePath()==reaper.GetResourcePath() then portable=true else portable=false end
  
  local version=reaper.GetAppVersion()  

  --version=  "6.16/OSX64-icc"
  --version="6.16/OSX32"
  --version="6.16/OSX64-arm"
  --version="6.16/linux-x86_64"
  --version="6.16/linux-i686"
  --version="6.16/linux-armv7l"
  --version="6.16/linux-aarch64"
  --version="6.16/win64"
  --version="6.16/win32"
  
  -- separate the returned value from GetAppVersion
  local majvers=tonumber(version:match("(.-)%..-/"))
  local subvers=tonumber(version:match("%.(%d*)"))
  local bits=version:match("/.-(64)")
  if bits==nil then bits=version:match("/.-(32)") end
  if bits==nil then if version:match("/.-i686")~=nil then bits=32 end end
  if bits==nil then if version:match("/.-armv7l")~=nil then bits=32 end end
  
  --local OS=reaper.GetOS():match("(.-)%d")
  local OS=(version.." "):match(".-/(%a*)")
  if OS:len()<3 then OS=reaper.GetOS():match("%a*") end
  local beta=version:match("%.%d*(.-)/")
  local arm=version:match("arm") or version:match("aarch")
  local additional_information=(version.."-"):match(".-/.-%-(.*)%-")
  if additional_information==nil then additional_information="" end
  return majvers, subvers, tonumber(bits), OS:sub(1,1):upper()..OS:sub(2,-1), portable, beta, arm~=nil, additional_information
end
 

--A,B,C,D,E,F=ultraschall.GetReaperAppVersion()
--A,B,C,D,E,F,G=ultraschall.GetReaperAppVersion()

function ultraschall.LimitFractionOfFloat(number, length_of_fraction)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LimitFractionOfFloat</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.16
    Lua=5.3
  </requires>
  <functioncall>number altered_number = ultraschall.LimitFractionOfFloat(number number, integer length_of_fraction)</functioncall>
  <description>
    limits the fraction of a float-number to a specific length of fraction(digits). You can also choose to round the value or not.
    
    returns nil in case of error
  </description>
  <parameters>
    number number - the number, whose fraction shall be limited
    integer length_of_fraction - the number of digits in the fraction
  </parameters>
  <retvals>
    number altered_number - the altered number with the new fraction-length. Will be equal to parameter number, if number was integer or fraction less digits than length_of_fraction
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, limit, fraction, round, number</tags>
</US_DocBloc>
--]]
  if type(number)~="number" then ultraschall.AddErrorMessage("LimitFractionOfFloat", "number", "must be a number", -1) return end
  if math.type(length_of_fraction)~="integer" then ultraschall.AddErrorMessage("LimitFractionOfFloat", "length_of_fraction", "must be an integer", -2) return end 
  if math.floor(number)==number then return number end
  --[[
  local adder, fraction, fraction2, int
  number=number+0.0
  int, fraction=tostring(number):match("(.-)%.(.*)")

  adder=0
  if fraction:len()>length_of_fraction then 
    fraction2=fraction:sub(1,length_of_fraction)
    if roundit==true and tonumber(fraction:sub(length_of_fraction+1, length_of_fraction+1))>5 then adder=1 end
    adder=adder/(10^(length_of_fraction))
  else 
    fraction2=fraction
  end
  --]]
  
  --return int.."."..(fraction2+adder)
  return tonumber(tostring(tonumber(string.format("%."..length_of_fraction.."f", number))))
end

--AA=ultraschall.LimitFractionOfFloat(19999.12345, 4.1, true)

--B=ultraschall.DoubleToInt(10256.099,1)

function ultraschall.GetAllEntriesFromTable(table)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllEntriesFromTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer count, table foundtypes, table returned_table = ultraschall.GetAllEntriesFromTable(table table)</functioncall>
  <description>
    Gets an iterable version of table. Good for analysing unknown tables.
    
    Returns the number of entries, a table(array) with the datatypes of each entry and the table with all it's entries in the same order as in the foundtypes-table.
    
    This doesn't treat table recursivley, means: each "Subtable" within the table is treated as one entry of the type "table". That means, that these tables must be analysed themselves in an extra step!
    A[1]=1
    A[2][1]=2
    A[2][2]=3.4
    will return two(!) entries, the first being of type "integer", the second being of type "table". Next step would be to run use this function to analyse A[2] as well, which would result in two entries: the first being of type "integer" and the second of type "float", etc.
    
    returns -1 in case of error
  </description>
  <parameters>
    table table - the table to get the individual entries from
  </parameters>
  <retvals>
    integer count - the number of table-entries found
    table foundtypes - a table, with count-entries, each entry having the type of each entry in the returned_table as string.
                     - The types can be "nil", "integer", "float", "string", "boolean", "table", "function", "thread", "userdata"
    table returned_table - an iterable version of table. The type of each entry can be found in the accompanying entry of foundtypes
                         - the format is returned_table[indexnr][1] - indexname/number of the original table-entry
                         -               returned_table[indexnr][2] - the value of the original table-entry
                         - the indexnr is 1 to count, while [indexnr][1] is the indexnr of the original-table-entry, which might be a string, functionname or something else as well
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, table, iterable, all entries, get</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(table)~="table" then ultraschall.AddErrorMessage("GetAllEntriesFromTable", "table", "must be a table", -1) return -1 end
  
  -- prepare variables
  local table2={}
  local table3={}
  local count=1
  
  -- get all table-entries(parts of the code from the Lua5.3-Reference-Manual)
  for i,v in pairs(table) do 
    table2[count]={}
    table2[count][1]=i
    table2[count][2]=v
    if type(v)~="number" then table3[count]=type(v)
    else table3[count]=math.type(v)
    end
    count=count+1
  end
  
  -- return found entries
  return count-1, table3, table2
end




function ultraschall.APIExists(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>APIExists</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.APIExists(string functionname)</functioncall>
  <description>
    returns true, if a certain function/variable exists in ultraschall.
    
    returns false if nothing has been found
  </description>
  <parameters>
    string functionname - the name of the function to check for; only the functionname without ultraschall. !
  </parameters>
  <retvals>
    boolean retval - true, if element exists; false if it doesn't exist
  </retvals>
  <chapter_context>
    Developer
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, api, exists, function, variable, developer</tags>
</US_DocBloc>
--]]
  if ultraschall[functionname]~=nil then return true end
  return false
end


function ultraschall.IsValidGuid(guid, strict)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidGuid</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidGuid(string guid, boolean strict)</functioncall>
  <description>
    Checks, if guid is a valid guid. Can also be used for strings, that contain a guid somewhere in them(strict=false)
    
    A valid guid is a string that follows the following pattern:
    {........-....-....-....-............}
    where . is a hexadecimal value(0-F)
    
    Returns false in case of error
  </description>
  <parameters>
    string guid - the guid to check for validity
    boolean strict - true, guid must only be the valid guid; false, guid must contain a valid guid somewhere in it(means, can contain trailing or preceding characters)
  </parameters>
  <retvals>
    boolean retval - true, guid is/contains a valid guid; false, guid isn't/does not contain a valid guid
  </retvals>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, guid, check</tags>
</US_DocBloc>
--]]
  if type(guid)~="string" then ultraschall.AddErrorMessage("IsValidGuid","guid", "must be a string", -1) return false end
  if type(strict)~="boolean" then ultraschall.AddErrorMessage("IsValidGuid","strict", "must be a boolean", -2) return false end
  if strict==true and guid:match("^{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}$")~=nil then return true
  elseif strict==false and guid:match(".-{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}.*")~=nil then return true
  else return false
  end
end


function ultraschall.SetBitfield(integer_bitfield, set_to, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetBitfield</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer new_integer_bitfield = ultraschall.SetBitfield(integer integer_bitfield, boolean set_to, integer bit_1, integer bit_2, ... integer bit_n)</functioncall>
  <description>
    Alters an integer-bitfield.
    
    Returns nil in case of error, like invalid bit-values
  </description>
  <parameters>
    integer integer_bitfield - the old integer-bitfield that you want to alter
    boolean set_to - true, set the bits to 1; false, set the bits to 0; nil, toggle the bits
    integer bit1..n - one or more parameters, that include the bitvalues toset/unset/toggle with 1 for the first bit; 2 for the second, 4 for the third, 8 for the fourth, etc
  </parameters>
  <retvals>
    integer new_integer_bitfield - the newly altered bitfield
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, bitfield, set, unset, toggle</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(integer_bitfield)~="integer" then ultraschall.AddErrorMessage("SetBitfield","integer_bitfield", "Must be an integer!", -1) return nil end
  if set_to~=nil and type(set_to)~="boolean" then ultraschall.AddErrorMessage("SetBitfield","set_to", "Must be a boolean!", -2) return nil end
  local Parameters={...}
  local count=1
  while Parameters[count]~=nil do
    -- check the bit-parameters
    if math.log(Parameters[count],2)~=math.floor(math.log(Parameters[count],2)) then ultraschall.AddErrorMessage("SetBitfield","bit", "Bit_"..count.."="..Parameters[count].." isn't a valid bitvalue!", -3) return nil end
    count=count+1
  end
  
  -- Now let's set or unset the bitvalues
  count=1
  while Parameters[count]~=nil do
    if set_to==true and integer_bitfield&Parameters[count]==0 then 
      -- setting the bits
      integer_bitfield=integer_bitfield+Parameters[count] 
    elseif set_to==false and integer_bitfield&Parameters[count]~=0 then 
      -- unsetting the bits
      integer_bitfield=integer_bitfield-Parameters[count]
    elseif set_to==nil then
      -- toggling the bits
      if integer_bitfield&Parameters[count]==0 then 
        integer_bitfield=integer_bitfield+Parameters[count] 
      elseif integer_bitfield&Parameters[count]~=0 then 
        integer_bitfield=integer_bitfield-Parameters[count] 
      end
    end
    count=count+1
  end
  return integer_bitfield
end

--A=ultraschall.SetBitfield(2, true, 2,4,16,8,8,8)

function ultraschall.PreventCreatingUndoPoint()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PreventCreatingUndoPoint</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>ultraschall.PreventCreatingUndoPoint()</functioncall>
  <description>
    Prevents creation of an Undo-point. Only useful in non-defer-scripts.
  </description>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, undo, prevent, creation, undopoint</tags>
</US_DocBloc>
--]]
  reaper.defer(ultraschall.Dummy)
end


function ultraschall.SetIntConfigVar_Bitfield(configvar, set_to, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetIntConfigVar_Bitfield</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer new_integer_bitfield = ultraschall.SetIntConfigVar_Bitfield(string configvar, boolean set_to, integer bit_1, integer bit_2, ... integer bit_n)</functioncall>
  <description>
    Alters an integer-bitfield stored by a ConfigVariable.
    
    Returns false in case of error, like invalid bit-values, etc
  </description>
  <parameters>
    string configvar - the config-variable, that is stored as an integer-bitfield, that you want to alter.
    boolean set_to - true, set the bits to 1; false, set the bits to 0; nil, toggle the bits
    integer bit1..n - one or more parameters, that include the bitvalues toset/unset/toggle with 1 for the first bit; 2 for the second, 4 for the third, 8 for the fourth, etc
  </parameters>
  <retvals>
    boolean retval - true, if altering was successful; false, if not successful
    integer new_integer_bitfield - the newly altered bitfield
  </retvals>
  <chapter_context>
    API-Helper functions
    Config Vars
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, bitfield, set, unset, toggle, configvar</tags>
</US_DocBloc>
--]]
  local integer_bitfield=reaper.SNM_GetIntConfigVar(configvar, -22)
  local integer_bitfield2=reaper.SNM_GetIntConfigVar(configvar, -23)
  if type(configvar)~="string" then ultraschall.AddErrorMessage("SetIntConfigVar_Bitfield","configvar", "Must be a string!", -1) return false end
  if integer_bitfield==-22 and integer_bitfield2==-23 then ultraschall.AddErrorMessage("SetIntConfigVar_Bitfield","configvar", "No valid config-variable!", -2) return false end
  
  -- check parameters
  if set_to~=nil and type(set_to)~="boolean" then ultraschall.AddErrorMessage("SetIntConfigVar_Bitfield","set_to", "Must be a boolean!", -3) return false end
  local Parameters={...}
  local count=1
  while Parameters[count]~=nil do
    -- check the bit-parameters
    if math.log(Parameters[count],2)~=math.floor(math.log(Parameters[count],2)) then ultraschall.AddErrorMessage("SetIntConfigVar_Bitfield","bit", "Bit_"..count.."="..Parameters[count].." isn't a valid bitvalue!", -4) return false end
    count=count+1
  end
  
  -- Now let's set or unset the bitvalues
  count=1
  while Parameters[count]~=nil do
    if set_to==true and integer_bitfield&Parameters[count]==0 then 
      -- setting the bits
      integer_bitfield=integer_bitfield+Parameters[count] 
    elseif set_to==false and integer_bitfield&Parameters[count]~=0 then 
      -- unsetting the bits
      integer_bitfield=integer_bitfield-Parameters[count]
    elseif set_to==nil then
      -- toggling the bits
      if integer_bitfield&Parameters[count]==0 then 
        integer_bitfield=integer_bitfield+Parameters[count] 
      elseif integer_bitfield&Parameters[count]~=0 then 
        integer_bitfield=integer_bitfield-Parameters[count] 
      end
    end
    count=count+1
  end
  return reaper.SNM_SetIntConfigVar(configvar, integer_bitfield), integer_bitfield
end


function ultraschall.MakeCopyOfTable(table, seen, recursive) --copy an array
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MakeCopyOfTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table table_copy = ultraschall.MakeCopyOfTable(table table)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Creates a true copy of a table(not only references).
    
    adapted from Tyler Neylon's function, found at [Stack Overflow](https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value/26367080#26367080)
    
    Returns nil if table isn't a valid table
  </description>
  <parameters>
    table table - the table to create a copy from.
  </parameters>
  <retvals>
    table table_copy - the true copy of the table; nil in case of error
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, table, copy, true copy</tags>
</US_DocBloc>
--]]
  if type(table)~="table" and recursive==true then return table elseif type(table)~="table" then ultraschall.AddErrorMessage("MakeCopyOfTable","table", "Must be a table!", -1)  return nil end
  if seen and seen[table] then return seen[table] end
  local seen_temp = seen or {}
  local res = setmetatable({}, getmetatable(table))
  seen_temp[table] = res
  for key, value in pairs(table) do 
    res[ultraschall.MakeCopyOfTable(key, seen_temp, true)] = ultraschall.MakeCopyOfTable(value, seen_temp, true) 
  end
  return res
end

function ultraschall.ConvertStringToAscii_Array(string)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertStringToAscii_Array</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length, table byte_array = ultraschall.ConvertStringToAscii_Array(string string)</functioncall>
  <description>
    Converts a string into it's individual characters and numerical-representation as a table and after that returns its number of table-entries and the table.
    
    Returns -1 if string isn't a valid string
  </description>
  <parameters>
    string string - the string to be converted
  </parameters>
  <retvals>
    integer length - the number of characters in the string/entries in the returned table byte_array
    table byte_array - the ByteArray as a table, with the format
                     -     ByteArray[idx][1]="A" -- the byte itself
                     -     ByteArray[idx][2]=65  -- the numerical representation of the byte
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, string, bytevalue, numerical representation</tags>
</US_DocBloc>
--]]
  if type(string)~="string" then ultraschall.AddErrorMessage("ConvertStringToAscii_Array","string", "Must be a string!", -1) return -1 end
  local Table={}
  for i=1, string:len() do
    Table[i]={}
    Table[i][1]=string:sub(i,i)
    Table[i][2]=string.byte(string:sub(i,i))
  end
  return string:len(), Table
end

--A,B=ultraschall.ConvertStringToAscii_Array("LULA")


function ultraschall.CompareStringWithAsciiValues(string,...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CompareStringWithAsciiValues</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer errorposition = ultraschall.CompareStringWithAsciiValues(string string, integer bytevalue_1, integer bytevalue_2, ... integer bytevalue_n)</functioncall>
  <description>
    Compares a string with a number of byte-values(like ASCII-values).
    Bytevalues can be either decimal and hexadecimal.
    -1, if you want to skip checking of a specific position in string.
    
    Returns false in case of error
  </description>
  <parameters>
    string string - the string to check against the bytevalues
    integer bytevalue_1..n - one or more parameters, that include the bytevalues to check against the accompanying byte in string; -1, if you want to skip check for that position
  </parameters>
  <retvals>
    boolean retval - true, if check was successful; false, if not successful
    integer errorposition - if retval is false, this will contain the position in string, where the checking failed; nil, if retval is true
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, compare, string, byte, bytevalues</tags>
</US_DocBloc>
--]]
  if type(string)~="string" then ultraschall.AddErrorMessage("CompareStringWithAsciiValues","string", "Must be a string!", -1) return false end  
  local length, Table=ultraschall.ConvertStringToAscii_Array(string)
  local AsciiValues={...}
  local NumEntries=ultraschall.CountEntriesInTable_Main(AsciiValues)
  local count=1  
  local retval=true
  while AsciiValues[count]~=nil do
    if AsciiValues[count]==-1 then 
    elseif Table[count][2]~=AsciiValues[count] then retval=false break end
    count=count+1
  end
  if count-1==NumEntries then count=nil end
  return retval, count
end

--LLCOOLJ,LLCOOL2=ultraschall.CompareStringWithAsciivalues("ACCDENLIGHTENE",65,-1,-1,-1,-1)



function ultraschall.ReturnsMinusOneInCaseOfError_Arzala()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReturnsMinusOneInCaseOfError_Arzala</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.ReturnsMinusOneInCaseOfError_Arzala()</functioncall>
  <description>
    Returns -1 in case of an error
  </description>
  <retvals>
    integer retval - returns -1 in case of error
  </retvals>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>returns, -1, in, case, of, error, arzala</tags>
</US_DocBloc>
--]]
  return 1
end

function ultraschall.CountLinesInString(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountLinesInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer number_of_lines = ultraschall.CountLinesInString(string String)</functioncall>
  <description>
    Counts the lines in a string. It counts them by counting \n-newlines(not carriage returns!)
    
    Returns -1 in case of an error
  </description>
  <parameters>
    string String - the string to count the lines of
  </parameters>
  <retvals>
    integer number_of_lines - number of lines of the string
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, count, lines, string</tags>
</US_DocBloc>
--]]
  if type(String)~="string" then ultraschall.AddErrorMessage("CountLinesInString","String", "Must be a string!", -1) return -1 end
  local Count=1
  for w in string.gmatch(String, "\n") do
    Count=Count+1
  end
  return Count
end


function ultraschall.ReturnTypeOfReaperObject(object)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReturnTypeOfReaperObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string objecttype = ultraschall.ReturnTypeOfReaperObject(Reaperobject object)</functioncall>
  <description>
    returns the type of a Reaper-object.
  </description>
  <retvals>
    string objecttype - the type of the parameter of object
                      - the following types can be returned: 
                      - ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source, None
  </retvals>
  <parameters>
    Reaperobject object - a Reaper-object of the following types:
                        - ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source
                        - returns None if the object isn't a valid Reaper-object
  </parameters>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, check, type, reaper, object, project, track, item, take, envelope, pcmsource</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, object, "ReaProject*")==true then return "ReaProject" end
  if reaper.ValidatePtr2(0, object, "MediaTrack*")==true then return "MediaTrack" end
  if reaper.ValidatePtr2(0, object, "MediaItem*")==true then return "MediaItem" end
  if reaper.ValidatePtr2(0, object, "MediaItem_Take*")==true then return "MediaItem_Take" end
  if reaper.ValidatePtr2(0, object, "TrackEnvelope*")==true then return "TrackEnvelope" end
  if reaper.ValidatePtr2(0, object, "PCM_source*")==true then return "PCM_source" end
  return "None"
end

function ultraschall.IsObjectValidReaperObject(object)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsObjectValidReaperObject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string objecttype = ultraschall.IsObjectValidReaperObject(Reaperobject object)</functioncall>
  <description>
    checks, if object is a valid Reaper-object. It also returns the type of that Reaper-object.
  </description>
  <retvals>
    boolean retval - true, if it's a valid Reaper-object; false, if not
    string objecttype - the type of the parameter of object
                      - the following types can be returned: 
                      - ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source, None
  </retvals>
  <parameters>
    Reaperobject object - a Reaper-object of the following types:
                        - ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source
                        - returns None if the object isn't a valid Reaper-object
  </parameters>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, check, type, reaper, object, project, track, item, take, envelope, pcmsource</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, object, "ReaProject*")==true then return true, "ReaProject" end
  if reaper.ValidatePtr2(0, object, "MediaTrack*")==true then return true, "MediaTrack" end
  if reaper.ValidatePtr2(0, object, "MediaItem*")==true then return true, "MediaItem" end
  if reaper.ValidatePtr2(0, object, "MediaItem_Take*")==true then return true, "MediaItem_Take" end
  if reaper.ValidatePtr2(0, object, "TrackEnvelope*")==true then return true, "TrackEnvelope" end
  if reaper.ValidatePtr2(0, object, "PCM_source*")==true then return true, "PCM_source" end
  return false, "None"
end

--A,B=ultraschall.IsObjectValidReaperObject(reaper.GetMediaItem(0,0))


function ultraschall.KeepTableEntriesOfType(worktable, keeptype)
-- supports
-- boolean, integer, float, number, string, ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>KeepTableEntriesOfType</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table alteredtable = ultraschall.KeepTableEntriesOfType(table worktable, string keeptype)</functioncall>
  <description>
    Removes all entries from worktable, that are not of the datatype as given by keeptype.
    
    returns nil in case of error
  </description>
  <retvals>
    table alteredtable - the table, that contains only the entries of the type as given by parameter keeptype
  </retvals>
  <parameters>
    table worktable - the unaltered source-table for processing
    string keeptype - the type that shall remain in table
                    - allowed are boolean, integer, float, number, table, string, userdata, thread, ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, keep, alter, table, types</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(worktable)~="table" then ultraschall.AddErrorMessage("KeepTableEntriesOfType","worktable", "Must be a table!", -1) return end
  if type(keeptype)~="string" then ultraschall.AddErrorMessage("KeepTableEntriesOfType","keeptype", "Must be a string!", -2) return end
  
  -- prepare variable
  local NewTable={}
  
  -- throw out all entries, that are not of type keeptype
  for k,v in pairs(worktable) do 
    if type(v)==keeptype or math.type(v)==keeptype then
      NewTable[k]=v
    elseif ultraschall.ReturnTypeOfReaperObject(v)~=ultraschall.ReturnTypeOfReaperObject(keeptype) then
      NewTable[k]=v
    end
  end
  return NewTable
end


function ultraschall.RemoveTableEntriesOfType(worktable, removetype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RemoveTableEntriesOfType</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table alteredtable = ultraschall.RemoveTableEntriesOfType(table worktable, string removetype)</functioncall>
  <description>
    Removes all entries from worktable, that are of the datatype as given by removetype.
    
    returns nil in case of error
  </description>
  <retvals>
    table alteredtable - the table, that contains only the entries that are nt of the type as given by parameter removetype
  </retvals>
  <parameters>
    table worktable - the unaltered source-table for processing
    string removetype - the type that shall be removed from table
                    - allowed are boolean, integer, float, number, table, string, userdata, ReaProject, MediaTrack, MediaItem, MediaItem_Take, TrackEnvelope, PCM_source
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, remove, alter, table, types</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(worktable)~="table" then ultraschall.AddErrorMessage("RemoveTableEntriesOfType","worktable", "Must be a table!", -1) return end
  if type(removetype)~="string" then ultraschall.AddErrorMessage("RemoveTableEntriesOfType","removetype", "Must be a string!", -2) return end
  
  -- prepare variables
  local NewTable={}
  
  -- remove table-entries, that are of type removetype
  for k,v in pairs(worktable) do 
    if type(v)==removetype or math.type(v)==removetype or ultraschall.ReturnTypeOfReaperObject(v)==ultraschall.ReturnTypeOfReaperObject(removetype) then
      NewTable[k]=v
    end
  end
  return NewTable
end

function ultraschall.IsItemInTrack3(MediaItem, trackstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsItemInTrack3</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsItemInTrack3(MediaItem MediaItem, string trackstring)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Checks, whether a MediaItem is in any of the tracks, given by trackstring.
    
    see [IsItemInTrack](#IsItemInTrack) to use itemidx instead of the MediaItem-object.
    see [IsItemInTrack2](#IsItemInTrack2) to check against only one track.
    
    returns nil in case of error
  </description>
  <retvals>
    boolean retval - true, if item is in track; false, if not
    string trackstring - a string with all tracknumbers, separated by commas; 1 for track 1, 2 for track 2, etc
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem, of which you want to know the track is is placed in
    string trackstring - a string with all tracknumbers, separated by commas; 1 for track 1, 2 for track 2, etc
  </parameters>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, check, item, track, trackstring</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(trackstring)~="string" then ultraschall.AddErrorMessage("IsItemInTrack3","trackstring", "Must be a string!", -1) return end
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("IsItemInTrack3","MediaItem", "Must be a MediaItem!", -2) return end
  local retval, count, individual_values=ultraschall.IsValidTrackString(trackstring)
  
  -- check, if item is in any of the tracks in trackstring
  for i=1, count do
    if individual_values[i]==ultraschall.GetParentTrack_MediaItem(MediaItem) then return true end
  end
  return false
end

--L=ultraschall.IsItemInTrack3(reaper.GetMediaItem(0,0), "1,2,3")


function ultraschall.AddIntToChar(character, int)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>AddIntToChar</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string new_character = ultraschall.AddIntToChar(string character, integer int)</functioncall>
  <description>
    Adds/subtracts int to/from the numeric representation of character. It will return the new character.
    It will not(!) include "overflows" into the adding/subtraction. That said, if you want to add a value resulting in a character above ASCII-code 255, it will fail!
    
    Returns nil in case of an error
  </description>
  <retvals>
    string new_character - the new character, after parameter int has been added/subtracted from/to character
  </retvals>
  <parameters>
    string character - the character, onto which you want to add/subtract parameter int; only single character allowed
    integer int - the value, that you want to add to the numerical representation of parameter character
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, add, character, value</tags>
</US_DocBloc>
]]
  if type(character)~="string" then ultraschall.AddErrorMessage("AddIntToChar", "character", "must be a string with one character" , -1) return nil end
  if character:len()~=1 then ultraschall.AddErrorMessage("AddIntToChar", "character", "must be a string with one character" , -2) return nil end
  if math.type(int)~="integer" then ultraschall.AddErrorMessage("AddIntToChar", "int", "must be an integer" , -3) return nil end
  if string.byte(character)+int>255 or string.byte(character)+int<0 then ultraschall.AddErrorMessage("AddIntToChar", "char + int", "calculated value is out of range of ASCII" , -4) return nil end
  local charcode=string.byte(character)
  local newchar=string.char(charcode+int)
  return newchar
end

--A,B=ultraschall.AddIntToChar("A", 191)



function ultraschall.MakeFunctionUndoable(Func, UndoMessage, Flag, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MakeFunctionUndoable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string current_UndoMessage, retvals_1, ..., retvals_2 = ultraschall.MakeFunctionUndoable(function Func, string UndoMessage, integer Flag, Func_parameters_1,  ... Func_parameters_n)</functioncall>
  <description>
    Run the function Func and create an undopoint for this function. You can also give an UndoMessage and a flag for Reaper to use.
    All parameters needed by Func follow after parameter Flag, as if it would be the normal parameters.
    This should make creating undo-points much much easier...
    
    Note: Reaper will use the undo-point only for functions, who do "undo"-able things. If you don't have something of that kind(no creating a track or something), Reaper will not create an undo-point.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, undoing was successful; false, undoing wasn't successful
    string current_UndoMessage - the current UndoMessage for the last action done by Reaper. Use this so see, if getting an undo-point was successful
    retvals_1 ... retvals_2 - the returnvalues, as returned by function Func
  </retvals>
  <parameters>
    function Func - the function, that you want to create an undo-point for
    string UndoMessage - the undo-message to be displayed by Reaper in the Undo-history
    integer Flag - you can set a flag, if you want, for this undo-point
    Func_parameters_1,  ... Func_parameters_n - the parameters, as needed by the function Func; will be given to Func as provided by you
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, undo, create, undopoint, function</tags>
</US_DocBloc>
]]
  if type(Func)~="function" then ultraschall.AddErrorMessage("MakeFunctionUndoable", "Func", "Must be a function.", -1) return false end
  if type(UndoMessage)~="string" then ultraschall.AddErrorMessage("MakeFunctionUndoable", "UndoMessage", "Must be a string.", -2) return false end
  if math.type(Flag)~="integer" then ultraschall.AddErrorMessage("MakeFunctionUndoable", "Func", "Must be an integer.", -3) return false end
  reaper.Undo_BeginBlock()
  local O={Func(...)}
  reaper.Undo_EndBlock(UndoMessage, Flag)
  local B=reaper.Undo_CanUndo2(0)
  if B~=UndoMessage then UndoMessage=B end
  return true, UndoMessage, table.unpack(O)
end




function ultraschall.ReturnTableAsIndividualValues(Table)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReturnTableAsIndividualValues</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    Lua=5.3
  </requires>
  <functioncall>retval1, retval2, retval3, ... , retval64 = ultraschall.ReturnTableAsIndividualValues(table Table)</functioncall>
  <description>
    Returns the first 64 entries of an numerical-indexed table as returnvalues
  </description>
  <retvals>
    retval1 ... retval64 - the values from Table returned
  </retvals>
  <parameters>
    table Table - the table, whose values you want to return. It will only return values with index 1...64!
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, table, return, values, indexed</tags>
</US_DocBloc>
]]  
  
  if type(Table)~="table" then Table={} end
  return Table[1], Table[2], Table[3], Table[4], Table[5], Table[6], Table[7], Table[8], Table[9], Table[10],
         Table[11], Table[12], Table[13], Table[14], Table[15], Table[16], Table[17], Table[18], Table[19], Table[20],
         Table[21], Table[22], Table[23], Table[24], Table[25], Table[26], Table[27], Table[28], Table[29], Table[30],
         Table[31], Table[32], Table[33], Table[34], Table[35], Table[36], Table[37], Table[38], Table[39], Table[40],
         Table[41], Table[42], Table[43], Table[44], Table[45], Table[46], Table[47], Table[48], Table[49], Table[50],
         Table[51], Table[52], Table[53], Table[54], Table[55], Table[56], Table[57], Table[58], Table[59], Table[60],
         Table[61], Table[62], Table[63], Table[64]
end

--L,M,N,O,P=ultraschall.ReturnTableAsIndividualValues(nil)


function ultraschall.type(object)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>type</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>string type_of_object, optional boolean isnumber = ultraschall.type(identifier object)</functioncall>
  <description>
    Returns the type of the object.
    Supported types are Lua's own datatypes as well as Reaper's own datatypes.
    
    Due API-limitations, SWS-specific datatypes are not supported in this function!
  </description>
  <retvals>
    string type_of_object - the type of the object; the following are valid:
                          - nil, number: integer, number: float, boolean, string, function, table, thread, userdata, 
                          - ReaProject, MediaItem, MediaItem_Take, MediaTrack, TrackEnvelope, AudioAccessor, joystick_device, PCM_source
                          - userdata will be shown, if object isn't of any known type
    optional boolean isnumber - true, if object is a number(either integer or number)
  </retvals>
  <parameters>
    identifier object - the object, whose type you want to know
  </parameters>
  <chapter_context>
    API-Helper functions
    Datatype-related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, datatype, reaper-objects, lua, return</tags>
</US_DocBloc>
]]
  if     object==nil then return "nil"
  elseif math.type(object)=="integer" then return "number: integer", true
  elseif math.type(object)=="float" then return "number: float", true
  elseif type(object)=="boolean" then return "boolean"
  elseif type(object)=="string" then return "string"
  elseif type(object)=="function" then return "function"
  elseif type(object)=="table" then return "table"
  elseif type(object)=="thread" then return "thread"
  elseif ultraschall.IsValidReaProject(object)==true then return "ReaProject"
  elseif pcall(reaper.CreateTakeAudioAccessor,object)==true then return "MediaItem_Take"
  elseif pcall(reaper.CountTrackMediaItems,object)==true then return "MediaTrack"
  elseif pcall(reaper.CountTakes,object)==true then return "MediaItem"
  elseif reaper.ValidatePtr(object, "TrackEnvelope*")==true then return "TrackEnvelope"
  elseif pcall(reaper.AudioAccessorValidateState, object)==true then return "AudioAccessor"
  elseif pcall(reaper.joystick_getaxis,object, 0)==true then return "joystick_device"
  elseif pcall(reaper.GetMediaSourceFileName,object, "")==true then return "PCM_source"
  
-- SWS-related types: need more research, as they seem to be identical to MediaTrack and maybe other types
-- probably should get their own type-function
--  elseif pcall(reaper.FNG_CountMidiNotes,object)==true then return "RprMidiTake"
--  elseif pcall(reaper.FNG_GetMidiNoteIntProperty,object,"")==true then return "RprMidiNote"
--  elseif pcall(reaper.BR_EnvCountPoints, object)==true then return "BR_Envelope"
--  

  elseif type(object)=="userdata" then return "userdata"
  end
end

function ultraschall.ConcatIntegerIndexedTables(table1, table2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConcatIntegerIndexedTables</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer numentries, array concatenated_table = ultraschall.ConcatIntegerIndexedTables(array table1, array table2)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Concatenates the entries of two tables into one table. The entries of each table must be indexed by integers
    
    The new table still has the same references as the old table, means: if you remove the old tables/entries in the old tables, the concatenated table/accompanying entries will loose elements.
    To get a "true"-concatenated copy, you should first create new copies of the tables, using [MakeCopyOfTable](#MakeCopyOfTable).
  </description>
  <parameters>
    array table1 - the first table to be concatenated; the entries must be indexed by integer-numbers!
    array table2 - the second table to be concatenated; the entries must be indexed by integer-numbers!
  </parameters>
  <retvals>
    integer numentries - the number of entries in the new table
    array concatenated_table - the new concatenated table
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, concatenate, concat, table, tables</tags>
</US_DocBloc>
]]
  local Count1 = ultraschall.CountEntriesInTable_Main(table1)
  local Count2 = ultraschall.CountEntriesInTable_Main(table2)
  local NewTable={}
  local TableCount=1
  for i=1, Count1 do
    NewTable[TableCount]=table1[i]
    TableCount=TableCount+1
  end
  for i=1, Count2 do
    NewTable[TableCount]=table2[i]
    TableCount=TableCount+1
  end
  return Count1+Count2, NewTable
end

--C,A0=ultraschall.ConcatIntegerIndexedTables(B, A)


function ultraschall.ReverseTable(the_table)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReverseTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>table reversed_table, integer entry_count = ultraschall.ReverseTable(table the_table)</functioncall>
  <description>
    reversed the order of the entries of a table, means, the last entry will become the first, the first become the last, etc.
    The table must be indexed by integers.
    
    Returns nil if table isn't a valid table
  </description>
  <parameters>
    table table - the table, whose entries you want to reverse
  </parameters>
  <retvals>
    table reversed_table - the resulting table with the reversed order of all entries
    integer entry_count - the number of entries in the reversed_table
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, reverse, entries, table, array, maintable</tags>
</US_DocBloc>
--]]
  if type(the_table)~="table" then ultraschall.AddErrorMessage("ReverseTable", "the_table", "Must be a table.", -1) return nil end
  local count=ultraschall.CountEntriesInTable_Main(the_table)
  local table2={}
  local count2=1
  for i=count, 1, -1 do
    table2[count2]=the_table[i]
    count2=count2+1
  end
  return table2, count2-1
end

-- DDD={1,2,3,4,5,6,7,8,9,10}
--A,B=ultraschall.ReverseTable(DDD)


function ultraschall.GetDuplicatesFromArrays(array1, array2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetDuplicatesFromArrays</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer duplicate_count, array duplicate_array, integer originalscount_array1, array originals_array1, integer originalscount_array2, array originals_array2  = ultraschall.GetDuplicatesFromArrays(array array1, array array2)</functioncall>
  <description>
    Returns the duplicates and the originals(entries only in one of the arrays) of two arrays. It will also return the number of entries.
    
    This works only on arrays with integer-indexed entries; index must start with index 1!
    
    returns -1 in case of an error
  </description>
  <parameters>
    array array1 - the first array to check for duplicates and "original"-entries
    array array2 - the second array to check for duplicates and "original"-entries
  </parameters>
  <retvals>
    integer duplicate_count - the number of entries in both arrays
    array duplicate_array - the entries in both arrays
    integer originalscount_array1 - the number of entries only in array1
    array originals_array1 - the entries that are only existing in array1
    integer originalscount_array2 - the number of entries only in array2
    array originals_array2 - the entries that are only existing in array2
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, get, duplicates, originals, arrays</tags>
</US_DocBloc>
]]
  if type(array1)~="table" then ultraschall.AddErrorMessage("GetDuplicatesFromArrays", "array1", "must be a table", -1) return -1 end
  if type(array2)~="table" then ultraschall.AddErrorMessage("GetDuplicatesFromArrays", "array2", "must be a table", -2) return -1 end
  local count1 = ultraschall.CountEntriesInTable_Main(array1)
  local count2 = ultraschall.CountEntriesInTable_Main(array2)
  local duplicates={}
  local originals1={}
  local originals2={}
  local dupcount=0
  local orgcount1=0
  local orgcount2=0
  local found=false
  
  for i=1, count2 do
    for a=1, count1 do
      if array2[i]==array1[a] then 
        dupcount=dupcount+1
        duplicates[dupcount]=array2[i]
        found=true
      end
    end
    if found==false then orgcount2=orgcount2+1 originals2[orgcount2]=array2[i] end
    found=false
  end

  for i=1, count1 do
    for a=1, count2 do
      if array1[i]==array2[a] then 
        found=true
      end
    end
    if found==false then orgcount1=orgcount1+1 originals1[orgcount1]=array1[i] end
    found=false
  end
  
  return dupcount, duplicates, orgcount1, originals1, orgcount2, originals2
end



function ultraschall.GetScriptFilenameFromActionCommandID(action_command_id)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScriptFilenameFromActionCommandID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>string scriptfilename_with_path = ultraschall.GetScriptFilenameFromActionCommandID(string action_command_id)</functioncall>
  <description>
    returns the filename with path of a script, associated to a ReaScript.
    Command-ID-numbers do not work!
                            
    returns false in case of an error
  </description>
  <parameters>
    string Path - the path to set as new current working directory
  </parameters>
  <retvals>
    string scriptfilename_with_path - the scriptfilename with path associated with this ActionCommandID
  </retvals>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>filemanagement, get, scriptfilename, actioncommandid</tags>
</US_DocBloc>
]]
  if ultraschall.type(action_command_id)~="string" then ultraschall.AddErrorMessage("GetScriptFilenameFromActionCommandID", "action_command_id", "must be a string", -1) return false end
  if ultraschall.CheckActionCommandIDFormat2(action_command_id)==false then ultraschall.AddErrorMessage("GetScriptFilenameFromActionCommandID", "action_command_id", "no such action-command-id", -2) return false end
  local kb_ini_path = ultraschall.GetKBIniFilepath()
  local kb_ini_file = ultraschall.ReadFullFile(kb_ini_path)
  if action_command_id:sub(1,1)=="_" then action_command_id=action_command_id:sub(2,-1) end
  local L=kb_ini_file:match("( "..action_command_id..".-)\n")
  if L==nil then ultraschall.AddErrorMessage("GetScriptFilenameFromActionCommandID", "action_command_id", "no such action_command_id associated to a script", -1) return false end
  L=L:match(".*%s(.*)")
  if L:sub(1,2)==".." then return reaper.GetResourcePath().."/"..L end
  return L
end



function ultraschall.CombineBytesToInteger(bitoffset, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CombineBytesToInteger</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.CombineBytesToInteger(integer bitoffset, integer Byte_1, optional Byte_2, ..., optional Byte_n)</functioncall>
  <description>
    Combines the Byte-values Byte_1 to Byte_n into one integer.
    That means, if you give 4 values, it will return a 32bit-integer(4*8Bits).
    
    Negative values will use the maximum possible value of that byte minus the bits. 
    In Byte_1, -2 will be 255-1=254, in Byte 2, -2 will be 65280-256=65024.
    
    Use bitoffset to define, from which bit on you want to combine the values.
    
    Returns -1 in case of an error
  </description>
  <parameters>
    integer bitoffset - if you want to start combining the values from a certain bitoffset-onwards, set the offset here; use 0 to start with the first bit.
    integer Byte_1 - a bytevalue that you want to combine into one
    optional integer Byte_2 - a bytevalue that you want to combine into one
    ...
    optional integer Byte_n - a bytevalue that you want to combine into one
  </parameters>
  <retvals>
    integer retval - the combined integer
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, combine, bytes, integer</tags>
</US_DocBloc>
]]
  if math.type(bitoffset)~="integer" then ultraschall.AddErrorMessage("AddBytesToInteger", "bitoffset", "Must be an integer", -1) return -1 end
  if bitoffset<0 then ultraschall.AddErrorMessage("AddBytesToInteger", "bitoffset", "Must be bigger or equal 0", -2) return -1 end
  local F={...}
  local c=0
  local count=1
  local bitcount=0+bitoffset
  while F[count]~=nil do
    if math.type(F[count])~="integer" then ultraschall.AddErrorMessage("AddBytesToInteger", "Byte_"..count, "Must be an integer", -3) return -1 end
    if F[count]>255 or F[count]<-256 then ultraschall.AddErrorMessage("AddBytesToInteger", "Byte_"..count, "Must be between -256 and 255", -4) return -1 end
    if F[count]&1~=0 then c=c+(2^bitcount) end
    if F[count]&2~=0 then c=c+(2^(bitcount+1)) end
    if F[count]&4~=0 then c=c+(2^(bitcount+2)) end
    if F[count]&8~=0 then c=c+(2^(bitcount+3)) end
    
    if F[count]&16~=0 then c=c+(2^(bitcount+4)) end
    if F[count]&32~=0 then c=c+(2^(bitcount+5)) end
    if F[count]&64~=0 then c=c+(2^(bitcount+6)) end
    if F[count]&128~=0 then c=c+(2^(bitcount+7)) end
    count=count+1
    bitcount=bitcount+8
  end
  return math.floor(c)
end

--L=ultraschall.CombineBytesToInteger(1,255)

function ultraschall.SplitIntegerIntoBytes(integervalue)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitIntegerIntoBytes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer Byte1, integer Byte2, integer Byte3, integer Byte4 = ultraschall.SplitIntegerIntoBytes(integer integervalue)</functioncall>
  <description>
    Splits a 32-bit-integer-value into four bytes.
    
    Returns -1 in case of an error
  </description>
  <parameters>
    integer integeroffset - the integer-value that you want to split into individual bytes
  </parameters>
  <retvals>
    integer Byte1 - the first eight bits of the integer-value as a Byte
    integer Byte2 - the second eight bits of the integer-value as a Byte
    integer Byte3 - the third eight bits of the integer-value as a Byte
    integer Byte4 - the fourth eight bits of the integer-value as a Byte
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, split, bytes, integer</tags>
</US_DocBloc>
]]
  if math.type(integervalue)~="integer" then ultraschall.AddErrorMessage("SplitIntegerIntoBytes", "integervalue", "Must be an integer", -1) return -1 end
  if integervalue<-4294967296 or integervalue>4294967295 then ultraschall.AddErrorMessage("SplitIntegerIntoBytes", "integervalue", "Must be between -4294967296 and 4294967295", -2) return -1 end
  local vars={}
  vars[1]=0
  vars[2]=0
  vars[3]=0
  vars[4]=0
  local entry=1
  local bitcount=0
  local count=0
  for bitcount=0, 31 do
    count=count+1
    if count==9 then count=1 entry=entry+1 end -- vars[entry]=0 end
    if integervalue&(math.floor(2^bitcount))~=0 then       
      vars[entry]=math.floor(vars[entry]+(2^(count-1)))
    end
  end
  return table.unpack(vars)
end

function ultraschall.GetReaperScriptPath()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperScriptPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string reaper_script_path = ultraschall.GetReaperScriptPath()</functioncall>
  <description>
    Returns path to Reaper's script-folder
  </description>
  <retvals>
    string reaper_script_path - the path of the scripts-folder of Reaper
  </retvals>
  <chapter_context>
    API-Helper functions
    Reaper Paths
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, reaper, get, scriptpath</tags>
</US_DocBloc>
]]
  if ultraschall.DirectoryExists(reaper.GetResourcePath(), "Scripts")==true then 
  return reaper.GetResourcePath()..ultraschall.Separator.."Scripts"
  else return "" end
end

--A=ultraschall.GetReaperScriptPath()


function ultraschall.GetReaperColorThemesPath()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperColorThemesPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string reaper_colorthemes_path = ultraschall.GetReaperColorThemesPath()</functioncall>
  <description>
    Returns path to Reaper's color-theme-folder
  </description>
  <retvals>
    string reaper_colorthemes_path - the path of the color-theme-folder of Reaper
  </retvals>
  <chapter_context>
    API-Helper functions
    Reaper Paths
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, reaper, get, colorthemepath</tags>
</US_DocBloc>
]]
  if ultraschall.DirectoryExists(reaper.GetResourcePath(), "ColorThemes")==true then 
  return reaper.GetResourcePath()..ultraschall.Separator.."ColorThemes"
  else return "" end
end

--A=ultraschall.GetReaperColorThemesPath()

function ultraschall.GetReaperJSFXPath()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperJSFXPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string reaper_jsfx_path = ultraschall.GetReaperJSFXPath()</functioncall>
  <description>
    Returns path to Reaper's JSFX-plugin-folder
  </description>
  <retvals>
    string reaper_jsfx_path - the path of the JSFX-plugin-folder of Reaper
  </retvals>
  <chapter_context>
    API-Helper functions
    Reaper Paths
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, reaper, get, jsfxpath</tags>
</US_DocBloc>
]]
  if ultraschall.DirectoryExists(reaper.GetResourcePath(), "Effects")==true then 
  return reaper.GetResourcePath()..ultraschall.Separator.."Effects"
  else return "" end
end

--A=ultraschall.GetReaperJSFXPath()


function ultraschall.GetReaperWebRCPath()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperWebRCPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string reaper_webrc_path, string user_webrc_path = ultraschall.GetReaperWebRCPath()</functioncall>
  <description>
    Returns path to the Web-RC-folder for Reaper as well as for the user-webrc-pages.
  </description>
  <retvals>
    string reaper_script_path - the path of the JSFX-plugin-folder of Reaper
  </retvals>
  <chapter_context>
    API-Helper functions
    Reaper Paths
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, reaper, get, webrcpath</tags>
</US_DocBloc>
]]
  local user_dir=""
  local reaper_dir=""
  if ultraschall.DirectoryExists(reaper.GetResourcePath(), "reaper_www_root")==true then user_dir=reaper.GetResourcePath()..ultraschall.Separator.."reaper_www_root" end
  if ultraschall.DirectoryExists(reaper.GetExePath()..ultraschall.Separator.."Plugins", "reaper_www_root")==true then reaper_dir=reaper.GetResourcePath()..ultraschall.Separator.."reaper_www_root" end
  return reaper_dir, user_dir
end

function ultraschall.CycleTable(the_table, offset)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CycleTable</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>table new_table = ultraschall.CycleTable(table the_table, integer offset)</functioncall>
  <description>
    Cycles the entries by offset. Offset can be positive(cycle forward) or negative(cycle negative). The number also tells the function, by how many entries the table shall be cycled, with 1 for one entry, 2 for 2 entries, etc.
    Entries "falling out" of one side(top or bottom) of the table will be readded on the other side.
    
    returns nil in case of error
  </description>
  <retvals>
    table new_table - the altered table
  </retvals>
  <parameters>
    table the_table - the table to cycle through
    integer offset - the offset, by which to cycle the entries through; positive, cycle entries forward; negative, cycle entries backward
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, cycle, table</tags>
</US_DocBloc>
]]
  if type(the_table)~="table" then ultraschall.AddErrorMessage("CycleTable", "the_table", "must be a table", -1) return end
  if math.type(offset)~="integer" then ultraschall.AddErrorMessage("CycleTable", "offset", "must be an integer", -2) return end

  local count, subtables, count_of_subtables = ultraschall.CountEntriesInTable_Main(the_table)
  local the_new_table={}

  local temp=math.floor(offset/count)
  local counter=offset-(temp*count)+1

  for i=1, count do
    the_new_table[counter]=the_table[i]
    counter=counter+1
    if counter>count then counter=1 end
  end
  return the_new_table
end

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
    
    returns -1 in case of an error
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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
    Deprecated
    
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
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, defer scripts, background scripts</tags>
</US_DocBloc>
]]
  ultraschall.deprecated("RunBackgroundHelperFeatures")

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

function ultraschall.Main_OnCommandByFilename(filename, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Main_OnCommandByFilename</slug>
  <requires>
    Ultraschall=4.4
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, run command, filename, scriptidentifier, scriptparameters</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(filename)~="string" then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "Must be a string.", -1) return false end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("Main_OnCommandByFilename", "filename", "File does not exist.", -2) return false end
  
  if ultraschall.IsOS_Win()==true then    
    filename=string.gsub(filename, "/", "\\")
    --print2("", filename)
  else
    filename=string.gsub(filename, "\\", "/")
  end
  
  if ultraschall.Main_OnCommand_NoParameters==nil then
      local commandid=reaper.AddRemoveReaScript(true, 0, filename, true)
      reaper.Main_OnCommand(commandid, 0)
      commandid=reaper.AddRemoveReaScript(false, 0, filename, true)
      return true
  end
  
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
--  ultraschall.SetScriptParameters("Hula",...)

  reaper.Main_OnCommand(commandid, 0)
  local commandid2=reaper.AddRemoveReaScript(false, 0, filename2, true)
  
  -- delete the temporary scriptfile  
  os.remove(filename2)
  
  -- return true and the script-identifier of the started script
  --print2(string.gsub("ScriptIdentifier:"..filename2, "\\", "/"))
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
    Ultraschall=4.4
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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

  if ultraschall.IsOS_Win()==true then    
    filename=string.gsub(filename, "/", "\\")
    --print2("", filename)
  else
    filename=string.gsub(filename, "\\", "/")
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
      reaper.AddRemoveReaScript(false, 32060, filename2, true)
      reaper.AddRemoveReaScript(false, 32061, filename2, true)
      reaper.AddRemoveReaScript(false, 32062, filename2, true)
      os.remove(filename2)
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
  <description>
    Gets the parameters stored for a specific script_identifier.
    
    returns -1 in case of an error
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, script, parameters, scriptidentifier</tags>
</US_DocBloc>
]]
  if script_identifier==nil or type(script_identifier)~="string" then script_identifier=ultraschall.ScriptIdentifier end
  
  if reaper.GetExtState(script_identifier, "parm_count")=="" then ultraschall.AddErrorMessage("GetScriptParameters", "", "no parameters found", -1) return -1 end
  local counter=1
  local parms={}
  --while reaper.GetExtState(script_identifier, "parm_"..counter)~="" do
  for i=1, tonumber(reaper.GetExtState(script_identifier, "parm_count")) do
    parms[counter]=reaper.GetExtState(script_identifier, "parm_"..counter)
    if remove==true then
      reaper.DeleteExtState(script_identifier, "parm_"..counter, false)
    end
    counter=counter+1
  end
  local caller_script=reaper.GetExtState(script_identifier, "parm_0")
  --print2(caller_script)
  
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
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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
  reaper.SetExtState(script_identifier, "parm_count", counter, false)
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
  <functioncall>integer num_params, array retvals = ultraschall.GetScriptReturnvalues(string sender_script_identifier, optional boolean remove)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Gets the return-values which a specific sender\_script\_identifier sent to the current script.
    
    If you have started numerous child-scripts and want to know, which child-script sent you return-values, see [GetScriptReturnvalues_Sender](#GetScriptReturnvalues_Sender)
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer num_retvals - the number of return-values available
    array params - the values of the return-values as an array
  </retvals>
  <parameters>
    string sender_script_identifier - the script-identifier, that sent the return-values to your script
    optional boolean remove - true or nil, remove the stored retval-extstates; false, keep them for later retrieval
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, script, returnvalues, scriptidentifier</tags>
</US_DocBloc>
]]
  if type(script_identifier)~="string" then ultraschall.AddErrorMessage("GetScriptReturnvalues", "script_identifier", "must be a string", -1) return -1 end
  local counter=1
  local retvals={}
  --print2("Häh?")
  if tonumber(reaper.GetExtState(ultraschall.ScriptIdentifier, script_identifier.."_retvalcount"))==nil then ultraschall.AddErrorMessage("GetScriptReturnvalues", "", "no retvals found", -2) return -1 end

  for i=1, tonumber(reaper.GetExtState(ultraschall.ScriptIdentifier, script_identifier.."_retvalcount")) do
    retvals[counter]=reaper.GetExtState(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter)
    if remove==true or remove==nil then
      reaper.DeleteExtState(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter, false)
      local retval_identifier = reaper.GetExtState(script_identifier, "retval_sender_identifier")
      retval_identifier = string.gsub(retval_identifier, script_identifier.."\n", "")      
      if retval_identifier:match(ultraschall.ScriptIdentifier)==nil then
        reaper.SetExtState(script_identifier, "retval_sender_identifier", retval_identifier, false)
      end
    end
    if remove==true or remove==nil then
      reaper.DeleteExtState(ultraschall.ScriptIdentifier, script_identifier.."_retvalcount", false)
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
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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
    --print2(ultraschall.ScriptIdentifier, script_identifier.."_retval_"..counter, tostring(retvals[counter]), false)
    counter=counter+1
  end
  reaper.SetExtState(script_identifier, ultraschall.ScriptIdentifier.."_retvalcount", counter, false)
  return true
end

--ultraschall.SetScriptReturnvalues("EmpfÃ¤nger", 9,222,3,4,5,6,7,8,9,10)
--A,B,C,D,E=ultraschall.GetScriptReturnvalues("EmpfÃ¤nger", true)

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
  <description>
    Retrieves, which scripts sent returnvalues to the current script.
  </description>
  <retvals>
    integer count - the number of scripts, who have left returnvalues for the current script
    array retval_sender - the ScriptIdentifier of the scripts, who returned values
  </retvals>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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




function ultraschall.Base64_Encoder(source_string, base64_type, remove_newlines, remove_tabs)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Base64_Encoder</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string encoded_string = ultraschall.Base64_Encoder(string source_string, optional integer base64_type, optional integer remove_newlines, optional integer remove_tabs)</functioncall>
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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
  
  --print2(0)
  -- tear apart the source-string into bits
  -- bitorder of bytes will be reversed for the later parts of the conversion!
  for i=1, source_string:len() do
    temp=string.byte(source_string:sub(i,i))
    --temp=temp
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
  local Entries={}
  local Entries_Count=1
  Entries[Entries_Count]=""
  local Count=0
    
  --print2("1")
  for i=0, a-2, 6 do
    temp2=0
    if tempstring[i+1]==1 then temp2=temp2+32 end
    if tempstring[i+2]==1 then temp2=temp2+16 end
    if tempstring[i+3]==1 then temp2=temp2+8 end
    if tempstring[i+4]==1 then temp2=temp2+4 end
    if tempstring[i+5]==1 then temp2=temp2+2 end
    if tempstring[i+6]==1 then temp2=temp2+1 end
    
    if Count>810 then
      Entries_Count=Entries_Count+1
      Entries[Entries_Count]=""
      Count=0
    end
    Count=Count+1
    Entries[Entries_Count]=Entries[Entries_Count]..base64_string:sub(temp2+1,temp2+1)
  end
  --print2("2")
  
  local Count=0
  local encoded_string2=""
  local encoded_string=""
  for i=1, Entries_Count do
    Count=Count+1
    encoded_string2=encoded_string2..Entries[i]
    if Count==6 then
      encoded_string=encoded_string..encoded_string2
      encoded_string2=""
      Count=0
    end
  end
  encoded_string=encoded_string..encoded_string2
  --]]
  --print2("3")
  -- if the number of characters in the encoded_string isn't exactly divideable 
  -- by 3, add = to fill up missing bytes
  --  OOO=encoded_string:len()%4
  if encoded_string:len()%4==2 then encoded_string=encoded_string.."=="
  elseif encoded_string:len()%2==1 then encoded_string=encoded_string.."="
  end
  
  return encoded_string
end

--A=ultraschall.Base64_Encoder("Man is", 9, 9, 9)

function ultraschall.Base64_Decoder(source_string, base64_type)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Base64_Decoder</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string decoded_string = ultraschall.Base64_Decoder(string source_string, optional integer base64_type)</functioncall>
  <description>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, decode, base64, string</tags>
</US_DocBloc>
]]
  if type(source_string)~="string" then ultraschall.AddErrorMessage("Base64_Decoder", "source_string", "must be a string", -1) return nil end
  if base64_type~=nil and math.type(base64_type)~="integer" then ultraschall.AddErrorMessage("Base64_Decoder", "base64_type", "must be an integer", -2) return nil end
  
  -- this is probably the place for other types of base64-decoding-stuff  
  local base64_string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  
  local Table={}
  local count=0
  for i=65, 90 do  count=count+1 Table[string.char(i)]=count end
  for i=97, 122 do count=count+1 Table[string.char(i)]=count end
  for i=48, 57 do  count=count+1 Table[string.char(i)]=count end
  count=count+1 Table[string.char(43)]=count
  count=count+1 Table[string.char(47)]=count
  
  -- remove =
  source_string=string.gsub(source_string,"=","")
  
  -- split the string into bits
  local bitarray={}
  local count=1
  local temp

  for i=1, source_string:len() do
    local temp=Table[source_string:sub(i,i)]
    --temp=base64_string:match(source_string:sub(i,i).."()")    
    if temp==nil then ultraschall.AddErrorMessage("Base64_Decoder", "source_string", "no valid Base64-string: invalid character found - "..source_string:sub(i,i).." at position "..i, -3) return nil end
    temp=temp-1
    if temp&32~=0 then bitarray[count]=1 else bitarray[count]=0 end
    if temp&16~=0 then bitarray[count+1]=1 else bitarray[count+1]=0 end
    if temp&8~=0 then bitarray[count+2]=1 else bitarray[count+2]=0 end
    if temp&4~=0 then bitarray[count+3]=1 else bitarray[count+3]=0 end
    if temp&2~=0 then bitarray[count+4]=1 else bitarray[count+4]=0 end
    if temp&1~=0 then bitarray[count+5]=1 else bitarray[count+5]=0 end
    count=count+6
  end

  -- combine the bits into the original bytes and put them into decoded_string
  local Entries={}
  local Entries_Count=1
  Entries[Entries_Count]=""
  local Count=0

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
    
    if Count>780 then
      Entries_Count=Entries_Count+1
      Entries[Entries_Count]=""
      Count=0
    end
    Count=Count+1
    Entries[Entries_Count]=Entries[Entries_Count]..string.char(temp2)
  end

  local Count=0
  local decoded_string2=""
  local decoded_string=""
  for i=1, Entries_Count do
    Count=Count+1
    decoded_string2=decoded_string2..Entries[i]
    if Count==6 then
      decoded_string=decoded_string..decoded_string2
      decoded_string2=""
      Count=0
    end
  end
  decoded_string=decoded_string..decoded_string2

  if decoded_string:sub(-1,-1)=="\0" then decoded_string=decoded_string:sub(1,-2) end
  return decoded_string
end

--reaper.CF_SetClipboard(ultraschall.Base64_Encoder("Debugger"))

--[[
L="RW5saWdodG1lbnRDcm9zc2VyRGVsdXhlRmlkZWxkdWJlbGRvbw=="

O=ultraschall.Base64_Decoder(L)
A=ultraschall.Base64_Encoder(O)

if A~=L then print2(A,L) end
--]]


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
    ....FILE "C:\Users\IncredibleSupergirl\Desktop\X_audiofile.flac"
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, layout, statechunk</tags>
</US_DocBloc>
]]

  if type(statechunk)~="string" then ultraschall.AddErrorMessage("StateChunkLayouter","statechunk", "must be a string", -1) return nil end    
  local num_tabs=0
  local newsc=""
  for k in string.gmatch(statechunk.."\n", "(.-\n)") do
    if k:sub(1,1)==">" then num_tabs=num_tabs-1 end
    for i=0, num_tabs-1 do
      newsc=newsc.."  "      
    end
    if k:sub(1,1)=="<" then num_tabs=num_tabs+1 end
    newsc=newsc..k    
  end
  return newsc:sub(1,-2)
end


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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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


function ultraschall.ConvertIntegerIntoString(integervalue)
--[[
</US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, integer, string</tags>
</US_DocBloc>
--]]
  if math.type(integervalue)~="integer" then ultraschall.AddErrorMessage("ConvertIntegerIntoString", "integervalue", "must be an integer", -1) return end
  local Byte1, Byte2, Byte3, Byte4 = ultraschall.SplitIntegerIntoBytes(integervalue)
  local String=string.char(Byte1)..string.char(Byte2)..string.char(Byte3)..string.char(Byte4)
  return String
end

--A=ultraschall.ConvertIntegerIntoString(65)
--]]

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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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

function ultraschall.ConvertBitsToInteger(bitvalues)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertBitsToInteger</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer integervalue = ultraschall.ConvertBitsToInteger(table bitvalues)</functioncall>
  <description>
    converts a table with all bitvalues into it's integer-representation.
    each table-entry holds either a 1 or a 0; 
      with index 1 being the first (for 1), 
      index 2 for the second (for 2),
      index 3 for the third (for 4),
      index 4 for the fourth(for 8), etc
    
    returns nil in case of an error
  </description>
  <parameters>
    table bitvalues - a table, where each entry contains the bit-value of integer; first entry for bit 1, 64th entry for bit 64, etc
  </parameters>
  <retvals>
    integer integer - the integer-number converted from the integer-entries
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, bitfield, integer</tags>
</US_DocBloc>
]]
  if type(bitvalues)~="table" then ultraschall.AddErrorMessage("ConvertBitsToInteger", "bitvalues", "must be a table", -1) return nil end
  local count = ultraschall.CountEntriesInTable_Main(bitvalues)
  local integer=0
  for i=0, count-1 do
    if bitvalues[i+1]~=0 and bitvalues[i+1]~=1 then ultraschall.AddErrorMessage("ConvertBitsToInteger", "bitvalues["..(i+1).."]", "must be either 0 or 1", -2) return nil end
    if bitvalues[i+1]==1 then integer=integer+2^i end
--    integer=integer<<1
  end
  return math.tointeger(integer)
end

--B=ultraschall.ConvertIntegerToBits(3)

--A=ultraschall.ConvertBitsToInteger({1,1,0,0,0,1})

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
      Config Vars
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
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
    <description>
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      The identifier is of the format "ScriptIdentifier:scriptfilename-{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}.ext", where the {}-part is a guid and ext either .lua .py or .eel
    </description>
    <retvals>
      string script_identifier - a unique script-identifier for this script-instance, of the format:
                               - ScriptIdentifier: scriptfilename-guid
    </retvals>
    <chapter_context>
      API-Helper functions
      Child Scripts
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, get, script_identifier</tags>
  </US_DocBloc>
  ]]

  return ultraschall.ScriptIdentifier
end

--O=ultraschall.GetScriptIdentifier()


function ultraschall.ReplacePartOfString(originalstring, insertstring, offset, length)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReplacePartOfString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string replaced_string = ultraschall.ReplacePartOfString(string originalstring, string insertstring, integer offset, optional integer length)</functioncall>
  <description>
    replaces a part of a string with a second string
    
    Returns nil in case of an error
  </description>
  <retvals>
    string replaced_string - the altered string
  </retvals>
  <parameters>
    string originalstring - the originalstring, in which you want to insert the string
    string insertstring - the string that shall be inserted
    integer offset - the position, at which to insert the string; it is the position BEFORE the position at which to insert, so if you want to replace the 25th character, offset is 24!
    optional integer length - the length of the part of the originalstring that shall be replaced, counted from offset. 0 or nil for simple insertion.
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, replace, string, offset, length, insert</tags>
</US_DocBloc>
]]

  if type(originalstring)~="string" then ultraschall.AddErrorMessage("ReplacePartOfString", "originalstring", "must be a string", -1) return nil end
  if type(insertstring)~="string" then ultraschall.AddErrorMessage("ReplacePartOfString", "insertstring", "must be a string", -2) return nil end
  if math.type(offset)~="integer" then ultraschall.AddErrorMessage("ReplacePartOfString", "offset", "must be an integer", -3) return nil end
  if length==nil then length=0 end
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("ReplacePartOfString", "length", "must be an integer", -4) return nil end
  
  local start=originalstring:sub(1,offset)
  local endof=originalstring:sub(offset+length+1,-1)
  
--  num_integers, individual_integers = ultraschall.ConvertStringToIntegers(originalstring,1)
--  num_integers, individual_integers2 = ultraschall.ConvertStringToIntegers(start..insertstring..endof,1)
  
  return start..insertstring..endof
end




function ultraschall.SearchStringInString(fullstring, searchstring, searchnested)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SearchStringInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer count, array posarray = ultraschall.SearchStringInString(string fullstring, string searchstring)</functioncall>
  <description>
    Searches for the string searchstring in fullstring. 
    
    Keep in mind: Umlauts may produce multibyte-values. Therefore, the returned offsets might be confusing.
    
    returns -1 in case of error, 0 if string wasn't found
  </description>
  <parameters>
    string fullstring - the string to be searched through
    string searchstring - the string to search for within fullstring
  </parameters>
  <retvals>
    integer count - the number of found occurences of searchstring in fullstring
    array posarray - an array that contains the positions, where searchstring was found within fullstring
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, search, string</tags>
</US_DocBloc>
--]]

  -- check parameters
  if type(fullstring)~="string" then ultraschall.AddErrorMessage("SearchStringInString", "fullstring", "must be a string", -1) return -1 end
  if type(searchstring)~="string" then ultraschall.AddErrorMessage("SearchStringInString", "searchstring", "must be a string", -2) return -1 end

  -- prepare variables
  local count=0
  local count2=0
  local posstring={}

  local temp, TEMPO2, temp3
  
  while fullstring~=nil do
    temp,TEMPO2,temp3=fullstring:match(".*()("..searchstring..")()")
    if temp==nil then break end
    fullstring=fullstring:sub(1,temp-1)
    count=count+1
    posstring[count]=temp-1
  end

  -- return result
  table.sort(posstring)
  return count, posstring
end

--L2,LL2=ultraschall.SearchStringInString("ABCmABCABCmABC", "Cm")




function ultraschall.MKVOL2DB(mkvol_value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MKVOL2DB</slug>
  <requires>
    Ultraschall=4.5
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>number db_value = ultraschall.MKVOL2DB(number mkvol_value)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts an MKVOL-value into a dB-value.
    
    MKVOL-values are used by the routing-functions for HWOut/AUXSendReceive, specifically for their volume-value as these can't be converted using Reaper's own DB2SLIDER or SLIDER2DB, so this function should help you.
    
    This function is an adapted one from the function provided in Plugins/reaper\_www\_root/main.js
    
    See [DB2MKVOL](#DB2MKVOL) to convert a dB-value into it's MKVOL-representation
    
    returns nil in case of an error
  </description>
  <retvals>
    number db_value - the dB-value, converted from the MKVOL-value; minimum -144dB
  </retvals>
  <parameters>
    number mkvol_value - the mkvol_value, that you want to convert into dB
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, mkvol, db</tags>
</US_DocBloc>
--]]
  if type(mkvol_value)~="number" then ultraschall.AddErrorMessage("MKVOL2DB", "mkvol_value", "must be a number" ,-1) return nil end
  if mkvol_value < 0.00000002980232 then return -144 end
  mkvol_value = math.log(mkvol_value)*8.68588963806
  return mkvol_value
end


function ultraschall.DB2MKVOL(db_value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DB2MKVOL</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>number mkvol_value = ultraschall.DB2MKVOL(number db_value)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts an dB-value into a MKVOL-value.
    
    MKVOL-values are used by the routing-functions for HWOut/AUXSendReceive, specifically for their volume-value as these can't be converted using Reaper's own DB2SLIDER or SLIDER2DB, so this function should help you.
    
    See [MKVOL2DB](#MKVOL2DB) to convert a MKVOL-value into it's dB-representation
    
    returns nil in case of an error
  </description>
  <retvals>
    number mkvol_value - the mkvol-value, converted from the dB-value
  </retvals>
  <parameters>
    number db_value - the dB-value, that you want to convert into the MKVOL-value; minimum is -144dB
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, mkvol, db</tags>
</US_DocBloc>
--]]
  if type(db_value)~="number" then ultraschall.AddErrorMessage("DB2MKVOL", "db_value", "must be a number" ,-1) return nil end
  return math.exp(db_value/8.68588963806)
end

function ultraschall.ConvertIntegerIntoString2(Size, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertIntegerIntoString2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>string converted_value = ultraschall.ConvertIntegerIntoString2(integer Size, integer integervalue_1, ..., integer integervalue_n)</functioncall>
  <description>
    Splits numerous integers into its individual bytes and converts them into a string-representation.
    Maximum 32bit-integers are supported.
    
    Returns nil in case of an error.
  </description>
  <parameters>
    integer Size - the maximum size of the integer to convert, 1(8 bit) to 4(32 bit)
    integer integervalue_1 - the first integer value to convert from
    ... - 
    integer integervalue_n - the last integer value to convert from
  </parameters>
  <retvals>
    string converted_value - the string-representation of the integer
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, integer, string</tags>
</US_DocBloc>
]]
  if math.type(Size)~="integer" then ultraschall.AddErrorMessage("ConvertIntegerIntoString2", "Size", "must be an integer", -1) return nil end
  if Size<1 or Size>4 then ultraschall.AddErrorMessage("ConvertIntegerIntoString2", "Size", "must be between 1(for 8 bit) and 4(for 32 bit)", -2) return nil end
  local Table={...}
  local String=""
  local count=1
  while Table[count]~=nil do
    if math.type(Table[count])~="integer" then ultraschall.AddErrorMessage("ConvertIntegerIntoString2", "parameter "..count, "must be an integer", -3) return end
    if Table[count]>2^32 then ultraschall.AddErrorMessage("ConvertIntegerIntoString2", "parameter "..count, "must be between 0 and 2^32", -4) return end
    local Byte1, Byte2, Byte3, Byte4 = ultraschall.SplitIntegerIntoBytes(Table[count])
    String=String..string.char(Byte1)
    if Size>1 then String=String..string.char(Byte2) end
    if Size>2 then String=String..string.char(Byte3) end
    if Size>3 then String=String..string.char(Byte4) end
    count=count+1
  end
  return String
end

--A=ultraschall.ConvertIntegerIntoString(3, 1752132965,65)
--B=A:len()

function ultraschall.ConvertStringToIntegers(String, Size)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertStringToIntegers</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer num_integers, array individual_integers = ultraschall.ConvertStringToIntegers(string String, integer Size)</functioncall>
  <description>
    Converts a string into its integer-representation. Allows you to set the size of the integers between 1 Byte and 8 Bytes(64 bits).
    
    Returns -1 in case of an error.
  </description>
  <parameters>
    string String - the string to convert into its integer representation
    integer Size - the size of the integers. 1 for 8 bits, 2 for 16 bits, ..., 8 for 64 bits
  </parameters>
  <retvals>
    integer num_integers - the number of integers converted from this string
    array individual_integers - the individual integers, as converted from the original string
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, string, integer, size</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("ConvertStringToIntegers", "String", "must be a string", -1) return -1 end
  if math.type(Size)~="integer" then ultraschall.AddErrorMessage("ConvertStringToIntegers", "Size", "must be an integer", -2) return -1 end
  if Size<1 or Size>8 then ultraschall.AddErrorMessage("ConvertStringToIntegers", "Size", "must be between 1(for 8 bit) and 8(for 64 bit)", -3) return -1 end
  local Table={}
  for i=1, String:len(), Size do
    if Size==1 then 
      Table[i]=string.byte(String:sub(i,i))
    elseif Size==2 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)))
    elseif Size==3 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)))
    elseif Size==4 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)),
                                                 string.byte(String:sub(i+3,i+3)))
    elseif Size==5 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)),
                                                 string.byte(String:sub(i+3,i+3)),
                                                 string.byte(String:sub(i+4,i+4)))
    elseif Size==6 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)),
                                                 string.byte(String:sub(i+3,i+3)),
                                                 string.byte(String:sub(i+4,i+4)),
                                                 string.byte(String:sub(i+5,i+5)))
    elseif Size==7 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)),
                                                 string.byte(String:sub(i+3,i+3)),
                                                 string.byte(String:sub(i+4,i+4)),
                                                 string.byte(String:sub(i+5,i+5)),
                                                 string.byte(String:sub(i+6,i+6))
                                                 )
    elseif Size==8 then
      Table[i]=ultraschall.CombineBytesToInteger(0,string.byte(String:sub(i,i)), 
                                                 string.byte(String:sub(i+1,i+1)),
                                                 string.byte(String:sub(i+2,i+2)),
                                                 string.byte(String:sub(i+3,i+3)),
                                                 string.byte(String:sub(i+4,i+4)),
                                                 string.byte(String:sub(i+5,i+5)),
                                                 string.byte(String:sub(i+6,i+6)),
                                                 string.byte(String:sub(i+7,i+7)))

    end
  end
  
  return String:len(), Table
end

function ultraschall.SetScriptIdentifier_Description(description)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SetScriptIdentifier_Description</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>integer retval = ultraschall.SetScriptIdentifier_Description(string description)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      With this function, you can set its description, that is less cryptic than the ScriptIdentifier itself.
      
      You can get it using [GetScriptIdentifier_Description](#GetScriptIdentifier_Description).
      
      returns -1 in case of an error
    </description>
    <retvals>
      integer retval - -1 in case of an error
    </retvals>
    <parameters>
      string description - the new description of your script
    </parameters>
    <chapter_context>
      API-Helper functions
      Child Scripts
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, set, script_identifier, description</tags>
  </US_DocBloc>
  ]]
  if type(description)~="string" then ultraschall.AddErrorMessage("SetScriptIdentifier_Description", "description", "must be a string", -1) return -1 end
  ultraschall.ScriptIdentifier_Description=description
end

function ultraschall.GetScriptIdentifier_Description()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetScriptIdentifier_Description</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string script_identifier_description = ultraschall.GetScriptIdentifier_Description()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      With this function, you can get its description, that is less cryptic than the ScriptIdentifier itself.
      
      You can set it using [SetScriptIdentifier_Description](#SetScriptIdentifier_Description).
    </description>
    <retvals>
      string script_identifier_description - the description of your script
    </retvals>
    <chapter_context>
      API-Helper functions
      Child Scripts
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, get, script_identifier, description</tags>
  </US_DocBloc>
  ]]
  return ultraschall.ScriptIdentifier_Description
end

function ultraschall.SetScriptIdentifier_Title(title)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SetScriptIdentifier_Title</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>integer retval = ultraschall.SetScriptIdentifier_Title(string title)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      With this function, you can set its title, that is less cryptic than the ScriptIdentifier itself.
      No \n-newlines, \r-carriage returns or \0-nullbytes are allowed and will be removed
      
      You can get it using [GetScriptIdentifier\_Title](#GetScriptIdentifier_Title).
      
      returns -1 in case of an error
    </description>
    <retvals>
      integer retval - -1 in case of an error
    </retvals>
    <parameters>
      string title - the new title of your script
    </parameters>
    <chapter_context>
      API-Helper functions
      Child Scripts
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, set, script_identifier, title</tags>
  </US_DocBloc>
  ]]
  if type(title)~="string" then ultraschall.AddErrorMessage("SetScriptIdentifier_Title", "title", "must be a string", -1) return -1 end
  title=string.gsub(title, "\0", "")
  title=string.gsub(title, "\n", "")
  title=string.gsub(title, "\r", "")
  
  ultraschall.ScriptIdentifier_Title=title
end

function ultraschall.GetScriptIdentifier_Title()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetScriptIdentifier_Title</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>string script_identifier_title = ultraschall.GetScriptIdentifier_Title()</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      The Ultraschall-API gives any script, that uses the API, a unique identifier generated when the script is run.
      This identifier can be used to communicate with this script. If you start numerous instances of a script, it will create for each instance
      its own script-identifier, so you can be sure, that you communicate with the right instance.
      
      With this function, you can get its description, that is less cryptic than the ScriptIdentifier itself.
      
      Default is the script's filename.
      
      You can set it using [SetScriptIdentifier\_Title](#SetScriptIdentifier_Title).
    </description>
    <retvals>
      string script_identifier_title - the title of your script; default is the filename of the script
    </retvals>
    <chapter_context>
      API-Helper functions
      Child Scripts
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, get, script_identifier, title</tags>
  </US_DocBloc>
  ]]
  return ultraschall.ScriptIdentifier_Title
end

--ultraschall.SetScriptIdentifier_Title("1\n2\r3\0 4")
--print_update(ultraschall.GetScriptIdentifier_Title())

function ultraschall.ResetProgressBar()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>ResetProgressBar</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>ultraschall.ResetProgressBar()</functioncall>
    <description>
      Resets the initial-values of the progressbar. Should be called, if you want to start a new progressbar after you filled up the former one, or you may have update-issues.
    </description>
    <chapter_context>
      API-Helper functions
      ProgressBar
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, reset, progressbar</tags>
  </US_DocBloc>
  ]]
    ultraschall.progressbar_lastupdate=-1
    ultraschall.lasttoptext=nil
    ultraschall.progressbar_lastbottomtext=nil
    ultraschall.progressbar_starttime=nil
    ultraschall.cur_time=nil
end

function ultraschall.PrintProgressBar(show, length, maximumvalue, currentvalue, percentage, offset, toptext, bottomtext, remaining_time)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>PrintProgressBar</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval, string ProgressString, integer percentage, integer progress_position = ultraschall.PrintProgressBar(boolean show, integer length, integer maximumvalue, integer currentvalue, boolean percentage, integer offset, optional string toptext, optional string bottomtext)</functioncall>
    <description markup_type="markdown" markup_version="1.0.1" indent="default">
      Calculate a simple progressbar, which can be optionally displayed in the ReaScript console; Will clear the console before displaying the next updated progressbar.

      Will update it only, if the current-value of last time this function got called is different from the current one or toptext or bottomtext changed.
      
      You can also use the returnvalues to draw your own progressbar, e.g. in a gfx.init-window

      If you need to calculate a new progressbar, after the former got to 100%, it is wise to call [ResetProgressBar](#ResetProgressBar), or it might not update the first time you call this function.
      
      Returns false in case of an error
    </description>
    <retvals>
      boolean retval - true, displaying was successful; false, displaying wasn't successful
      string ProgressString - the progressbar including its full statuses and layout
      integer percentage - the progression of the progressbar in percent
      integer progress_position - the current progress-position, relative to length and maximumvalue
    </retvals>
    <parameters>
      boolean show - true, show progressbar in the ReaScript-console; false, don't show it there
      integer length - the length of the progressbar in characters. Minimum is 10.
      integer maximumvalue - the maximum integer-value, to which to count; minimum 1
      integer currentvalue - the current integer-value, at which we are with counting, minimum 0
      boolean percentage - true, show percentage in progressbar; false, show only progressbar
      integer offset - an offset to be added before the progressbar, so you can indent it
      optional string toptext - an optional string, that shall be displayed above the progressbar
      optional string bottomtext - an optional string, that shall be displayed below the progressbar
    </parameters>
    <chapter_context>
      API-Helper functions
      ProgressBar
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, calculate, progressbar, show, display, percentage</tags>
  </US_DocBloc>
  ]]
  if type(show)~="boolean" then ultraschall.AddErrorMessage("PrintProgressBar", "show", "must be a boolean", -12) return false end
  if math.type(length)~="integer" then ultraschall.AddErrorMessage("PrintProgressBar", "length", "must be an integer", -1) return false end
  if length<10 then ultraschall.AddErrorMessage("PrintProgressBar", "length", "must be 10 at least", -2) return false end
  if math.type(maximumvalue)~="integer" then ultraschall.AddErrorMessage("PrintProgressBar", "maximumvalue", "must be an integer", -3) return false end
  if maximumvalue<1 then ultraschall.AddErrorMessage("PrintProgressBar", "maximumvalue", "must be 1 at least", -11) return false end
  if math.type(currentvalue)~="integer" then ultraschall.AddErrorMessage("PrintProgressBar", "currentvalue", "must be an integer", -4) return false end
  if currentvalue<0 then ultraschall.AddErrorMessage("PrintProgressBar", "currentvalue", "must be 0 at least", -11) return false end
  if currentvalue>maximumvalue then ultraschall.AddErrorMessage("PrintProgressBar", "currentvalue", "must be smaller or equal than maximumvalue", -5) return false end
  if type(percentage)~="boolean" then ultraschall.AddErrorMessage("PrintProgressBar", "percentage", "must be a boolean", -6) return false end  
  if math.type(offset)~="integer" then ultraschall.AddErrorMessage("PrintProgressBar", "offset", "must be an integer", -7) return false end  
  if offset<0 then ultraschall.AddErrorMessage("PrintProgressBar", "offset", "must be 0 or bigger", -8) return false end
  if toptext~=nil and type(toptext)~="string" then ultraschall.AddErrorMessage("PrintProgressBar", "toptext", "must be a string", -9) return false end  
  if bottomtext~=nil and type(bottomtext)~="string" then ultraschall.AddErrorMessage("PrintProgressBar", "bottomtext", "must be a string", -10) return false end  
  if remaining_time~=nil and type(remaining_time)~="string" then ultraschall.AddErrorMessage("PrintProgressBar", "remaining_time", "must be a string", -11) return false end  

  local ProgressString, status, String_offset, String_progress, String_unprogress, Percentage
    -- remaining time-calculator
  if remaining_time~=nil then
    if ultraschall.progressbar_starttime==nil then
      ultraschall.progressbar_starttime=reaper.time_precise()
    end
    if ultraschall.progressbar_startcurvalue==nil then
      ultraschall.progressbar_startcurvalue=currentvalue
    end
    ultraschall.progressbar_cur_time=reaper.time_precise()
    
    local temptime=ultraschall.progressbar_cur_time-ultraschall.progressbar_starttime
    local tempmaxtime=(temptime/(currentvalue))*maximumvalue
    local tempremainingtime=tempmaxtime-temptime
    tempremainingtime=reaper.format_timestr(tempremainingtime, ""):match("(.-)%.")
    remaining_time=remaining_time..tempremainingtime
  end  
  if ultraschall.progressbar_lastupdate~=math.ceil(currentvalue) or 
    ultraschall.lasttoptext~=progressbar_toptext or
    ultraschall.progressbar_lastbottomtext~=bottomtext then
    reaper.ClearConsole()
    String_progress=""
    String_unprogress=""
    String_offset=""
    for i=1, length do
      String_progress=String_progress.."+"
      String_unprogress=String_unprogress.."_"
    end
    for i=1, offset do
      String_offset=String_offset.." "
      if remaining_time~=nil then
        remaining_time=" "..remaining_time
      end
    end
    status=math.ceil((length/maximumvalue)*currentvalue)
    
    ProgressString=String_progress:sub(0,status)..String_unprogress:sub(status+1,-1)
    if percentage==true then
      Percentage=tostring(math.ceil((100/maximumvalue)*currentvalue)).." %"
      if Percentage:len()==4 then Percentage=" "..Percentage end
      if Percentage:len()==3 then Percentage="  "..Percentage end
      Percentage=tonumber(Percentage:sub(1,-2))
      if Percentage>100 then Percentage=100 end
      if math.ceil((100/maximumvalue)*currentvalue)<100 then
        ProgressString=String_offset..ProgressString:sub(1,math.ceil(ProgressString:len()/2-3))..Percentage..ProgressString:sub(math.ceil(ProgressString:len()/2+3),-1)
      else
        ProgressString=String_progress:sub(0,status)
        ProgressString=String_offset..ProgressString:sub(1,math.ceil(ProgressString:len()/2-3))..Percentage..ProgressString:sub(math.ceil(ProgressString:len()/2+2),-1)
      end
    else
      Percentage=nil
    end
    if remaining_time~=nil then ProgressString=ProgressString.."\n"..remaining_time end
    if toptext~=nil then ProgressString=toptext.."\n"..ProgressString end
    if bottomtext~=nil then ProgressString=ProgressString.."\n"..bottomtext end
    if show==true then
      print(ProgressString)
    end
    ultraschall.progressbar_lastupdate=math.ceil(currentvalue)
    ultraschall.lasttoptext=toptext
    ultraschall.progressbar_lastbottomtext=bottomtext
  else
    ultraschall.progressbar_lastupdate=math.ceil(currentvalue)
    ultraschall.lasttoptext=toptext
    ultraschall.progressbar_lastbottomtext=bottomtext
  end
  return true, ProgressString, Percentage, status
end


function ultraschall.StoreFunctionInExtState(section, key, functioncall, debug)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreFunctionInExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.StoreFunctionInExtState(string section, string key, function func, boolean debug)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Stores a function into an extstate. You can store it's debug-information as well.
    
    To load the function again, use [LoadFunctionFromExtState](#LoadFunctionFromExtState)
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, it was unsuccessful
  </retvals>
  <parameters>
    string section - the sectionname of the extstate
    string key - the keyname of the extstate
    function func - the function, that you want to store
    boolean debug - true, store debug-values as well; false, don't store the debug-values as well
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, store, function, extstate</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("StoreFunctionInExtState", "section", "must be a string", -1) return false end
  if type(key)~="string" then ultraschall.AddErrorMessage("StoreFunctionInExtState", "key", "must be a string", -2) return false end
  if type(functioncall)~="function" then ultraschall.AddErrorMessage("StoreFunctionInExtState", "functioncall", "must be a function", -3) return false end
  if type(debug)~="boolean" then ultraschall.AddErrorMessage("StoreFunctionInExtState", "debug", "must be a boolean", -4) return false end
  local Dump=string.dump (functioncall, debug)
  local DumpBase64 = ultraschall.Base64_Encoder(Dump)
  reaper.SetExtState(section, key, "LuaFunc:"..DumpBase64, false)
  return true
end

function ultraschall.LoadFunctionFromExtState(section, key)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>LoadFunctionFromExtState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>function function = ultraschall.LoadFunctionFromExtState(string section, string key)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Loads a function from an extstate, if it has been stored in there before.
    The extstate must contain a valid function. If something else is stored, the loaded "function" might crash Lua!
    
    To store the function, use [StoreFunctionInExtState](#StoreFunctionInExtState)
    
    Returns false in case of an error
  </description>
  <retvals>
    function func - the stored function, that you want to (re-)load
  </retvals>
  <parameters>
    string section - the sectionname of the extstate
    string key - the keyname of the extstate
  </parameters>
  <chapter_context>
    API-Helper functions
    LoadFunctionFromExtState
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, load, function, extstate</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("LoadFunctionFromExtState", "section", "must be a string", -1) return false end
  if type(key)~="string" then ultraschall.AddErrorMessage("LoadFunctionFromExtState", "key", "must be a string", -2) return false end
  local DumpBase64 = reaper.GetExtState(section, key)
  if DumpBase64=="" or DumpBase64:match("LuaFunc:")==nil then ultraschall.AddErrorMessage("LoadFunctionFromExtState", "", "no function stored in extstate", -3) return false end
  local Dump = ultraschall.Base64_Decoder(DumpBase64:sub(9,-1))
  return load(Dump)
end

--ultraschall.StoreFunctionInExtState("test", "test", print2, true)
--KAKKALAKKA=ultraschall.LoadFunctionFromExtState("test", "test22")
--KAKKALAKKA("789".."hhi")


function ultraschall.ConvertHex2Ascii(hexstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertHex2Ascii</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>string ascii_string = ultraschall.ConvertHex2Ascii(string hexstring)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    converts a hexstring into an ascii-string.

    Will combine two hexvalues into one byte, until the whole string is converted.
    
    See [ConvertAscii2Hex](#ConvertAscii2Hex) to convert a string into its HEX-representation.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string ascii_string - the converted string
  </retvals>
  <parameters>
    string hexstring - the original string with only hexadecimal numbers 
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, convert, hex, hexadecimal, ascii</tags>
</US_DocBloc>
]]
  if type(hexstring)~="string" then ultraschall.AddErrorMessage("ConvertHex2Ascii", "hexstring", "must be a string", -1) return end
  if string.gsub(hexstring, "%x", ""):len()>0 then ultraschall.AddErrorMessage("ConvertHex2Ascii", "hexstring", "contains non-hex-characters", -2) return end
  if hexstring:len()%2==1 then ultraschall.AddErrorMessage("ConvertHex2Ascii", "hexstring", "length must be divideable by 2", -3) return end
  
  local Entries={}
  local Entries_Count=1
  Entries[Entries_Count]=""
  local Count=0
  local String=""
  local temp
  
  for i=1, hexstring:len(), 2 do
    Count=Count+1
    if Count==1000 then 
      Count=1 
      Entries_Count=Entries_Count+1
      Entries[Entries_Count]="" 
    end
    temp=string.char(tonumber("0x"..hexstring:sub(i,i+1)))
    Entries[Entries_Count]=Entries[Entries_Count]..temp
  end
  
  for i=1, Entries_Count do
    String=String..Entries[i]
  end
    
  return String
end

--A="0F000000000000000000000000000000BC020000000000000302012248656C766574696361204E65756500000000000000000000000000000000000037"
--B=ultraschall.ConvertHex2Ascii(A)

function ultraschall.ConvertAscii2Hex(orgstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertAscii2Hex</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>string hexstring = ultraschall.ConvertAscii2Hex(string ascii_string)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    converts an ascii-string into a hexstring.
    
    See [ConvertHex2Ascii](#ConvertHex2Ascii) to convert a HEX-string into its normal string-representation.
    
    Returns nil in case of an error
  </description>
  <retvals>
    string hexstring - the original string with only hexadecimal numbers 
  </retvals>
  <parameters>
    string ascii_string - the converted string
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helperfunctions, convert, hex, hexadecimal, ascii</tags>
</US_DocBloc>
]]
  if type(orgstring)~="string" then ultraschall.AddErrorMessage("ConvertAscii2Hex", "orgstring", "must be a string", -1) return end
  local String=""
  local temp
  
  local Entries={}
  local Entries_Count=1
  Entries[Entries_Count]=""
  local Count=0
  for i=1, math.floor(orgstring:len()/2) do
    Count=Count+1
    if Count==1000 then 
      Count=1 
      Entries_Count=Entries_Count+1
      Entries[Entries_Count]="" 
    end
    temp=--orgstring:sub(i,i)
         string.format('%X', string.byte(orgstring:sub(i,i))) if temp:len()==1 then temp="0"..temp end    
    Entries[Entries_Count]=Entries[Entries_Count]..temp
  end

  local Entries2={}
  local Entries_Count2=1
  Entries2[Entries_Count2]=""
  local Count=0
  for i=math.floor(orgstring:len()/2)+1, orgstring:len() do
    Count=Count+1
    if Count==1000 then 
      Count=1 
      Entries_Count2=Entries_Count2+1
      Entries2[Entries_Count2]="" 
    end
    temp=--orgstring:sub(i,i)
         string.format('%X', string.byte(orgstring:sub(i,i))) if temp:len()==1 then temp="0"..temp end    
    Entries2[Entries_Count2]=Entries2[Entries_Count2]..temp
  end

  for i=1, Entries_Count do
    String=String..Entries[i]
  end

  local String2=""
  for i=1, Entries_Count2 do
    String2=String2..Entries2[i]
  end

  return String..String2
end


function ultraschall.get_action_context_MediaItemDiff(exlude_mousecursorsize, x, y)
-- TODO:: nice to have feature: when mouse is above crossfades between two adjacent items, return this state as well as a boolean
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>get_action_context_MediaItemDiff</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>MediaItem MediaItem, MediaItem_Take MediaItem_Take, MediaItem MediaItem_unlocked, boolean Item_moved, number StartDiffTime, number EndDiffTime, number LengthDiffTime, number OffsetDiffTime = ultraschall.get_action_context_MediaItemDiff(optional boolean exlude_mousecursorsize, optional integer x, optional integer y)</functioncall>
  <description>
    Returns the currently clicked MediaItem, Take as well as the difference of position, end, length and startoffset since last time calling this function.
    Good for implementing ripple-drag/editing-functions, whose position depends on changes in the currently clicked MediaItem.
    Repeatedly call this (e.g. in a defer-cycle) to get all changes made, during dragging position, length or offset of the MediaItem underneath mousecursor.
    
    This function takes into account the size of the start/end-drag-mousecursor, that means: if mouse-position is within 3 pixels before start/after end of the item, it will get the correct MediaItem. 
    This is a workaround, as the mouse-cursor changes to dragging and can still affect the MediaItem, even though the mouse at this position isn't above a MediaItem anymore.
    To be more strict, set exlude_mousecursorsize to true. That means, it will only detect MediaItems directly beneath the mousecursor. If the mouse isn't above a MediaItem, this function will ignore it, even if the mouse could still affect the MediaItem.
    If you don't understand, what that means: simply omit exlude_mousecursorsize, which should work in almost all use-cases. If it doesn't work as you want, try setting it to true and see, whether it works now.    
  </description>
  <retvals>
    MediaItem MediaItem - the MediaItem at the current mouse-position; nil if not found
    MediaItem_Take MediaItem_Take - the MediaItem_Take underneath the mouse-cursor
    MediaItem MediaItem_unlocked - if the MediaItem isn't locked, you'll get a MediaItem here. If it is locked, this retval is nil
    boolean Item_moved - true, the item was moved; false, only a part(either start or end or offset) of the item was moved
    number StartDiffTime - if the start of the item changed, this is the difference;
                         -   positive, the start of the item has been changed towards the end of the project
                         -   negative, the start of the item has been changed towards the start of the project
                         -   0, no changes to the itemstart-position at all
    number EndDiffTime - if the end of the item changed, this is the difference;
                         -   positive, the end of the item has been changed towards the end of the project
                         -   negative, the end of the item has been changed towards the start of the project
                         -   0, no changes to the itemend-position at all
    number LengthDiffTime - if the length of the item changed, this is the difference;
                         -   positive, the length is longer
                         -   negative, the length is shorter
                         -   0, no changes to the length of the item
    number OffsetDiffTime - if the offset of the item-take has changed, this is the difference;
                         -   positive, the offset has been changed towards the start of the project
                         -   negative, the offset has been changed towards the end of the project
                         -   0, no changes to the offset of the item-take
                         - Note: this is the offset of the take underneath the mousecursor, which might not be the same size, as the MediaItem itself!
                         - So changes to the offset maybe changes within the MediaItem or the start of the MediaItem!
                         - This could be important, if you want to affect other items with rippling.
  </retvals>
  <parameters>
    optional boolean exlude_mousecursorsize - false or nil, get the item underneath, when it can be affected by the mouse-cursor(dragging etc): when in doubt, use this
                                            - true, get the item underneath the mousecursor only, when mouse is strictly above the item,
                                            -       which means: this ignores the item when mouse is not above it, even if the mouse could affect the item
    optional integer x - nil, use the current x-mouseposition; otherwise the x-position in pixels
    optional integer y - nil, use the current y-mouseposition; otherwise the y-position in pixels
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, action, context, difftime, item, mediaitem, offset, length, end, start, locked, unlocked</tags>
</US_DocBloc>
--]]
  if x~=nil and math.type(x)~="integer" then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "x", "must be either nil or an integer", -1) return nil end
  if y~=nil and math.type(y)~="integer" then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "y", "must be either nil or an integer", -2) return nil end
  if (x~=nil and y==nil) or (y~=nil and x==nil) then ultraschall.AddErrorMessage("get_action_context_MediaItemDiff", "x or y", "must be either both nil or both an integer!", -3) return nil end
  local MediaItem, MediaItem_Take, MediaItem_unlocked
  local StartDiffTime, EndDiffTime, Item_moved, LengthDiffTime, OffsetDiffTime
  if x==nil and y==nil then x,y=reaper.GetMousePosition() end
  MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x, y, true)
  MediaItem_unlocked = reaper.GetItemFromPoint(x, y, false)
  if MediaItem==nil and exlude_mousecursorsize~=true then
    MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x+3, y, true)
    MediaItem_unlocked = reaper.GetItemFromPoint(x+3, y, false)
  end
  if MediaItem==nil and exlude_mousecursorsize~=true then
    MediaItem, MediaItem_Take = reaper.GetItemFromPoint(x-3, y, true)
    MediaItem_unlocked = reaper.GetItemFromPoint(x-3, y, false)
  end
  
  -- crossfade-stuff
  -- example-values for crossfade-parts
  -- Item left: 811 -> 817 , Item right: 818 -> 825
  --               6           7
  -- first:  get, if the next and previous items are at each other/crossing; if nothing -> no crossfade
  -- second: get, if within the aforementioned pixel-ranges, there's another item
  --              6 pixels for the one before the current item
  --              7 pixels for the next item
  -- third: if yes: crossfade-area, else: no crossfade area
  --[[
  -- buggy: need to know the length of the crossfade, as the aforementioned attempt would work only
  --        if the items are adjacent but not if they overlap
  --        also need to take into account, what if zoomed out heavily, where items might be only
  --        a few pixels wide
  
  if MediaItem~=nil then
    ItemNumber = reaper.GetMediaItemInfo_Value(MediaItem, "IP_ITEMNUMBER")
    ItemTrack  = reaper.GetMediaItemInfo_Value(MediaItem, "P_TRACK")
    ItemBefore = reaper.GetTrackMediaItem(ItemTrack, ItemNumber-1)
    ItemAfter = reaper.GetTrackMediaItem(ItemTrack, ItemNumber+1)
    if ItemBefore~=nil then
      ItemBefore_crossfade=reaper.GetMediaItemInfo_Value(ItemBefore, "D_POSITION")+reaper.GetMediaItemInfo_Value(ItemBefore, "D_LENGTH")>=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
    end
  end
  --]]
  
  if ultraschall.get_action_context_MediaItem_old~=MediaItem then
    StartDiffTime=0
    EndDiffTime=0
    LengthDiffTime=0
    OffsetDiffTime=0
    if MediaItem~=nil then
      ultraschall.get_action_context_MediaItem_Start=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_End=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")+reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_Length=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
      ultraschall.get_action_context_MediaItem_Offset=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS")
    end
  else
    if MediaItem~=nil then      
      StartDiffTime=ultraschall.get_action_context_MediaItem_Start
      EndDiffTime=ultraschall.get_action_context_MediaItem_End
      LengthDiffTime=ultraschall.get_action_context_MediaItem_Length
      OffsetDiffTime=ultraschall.get_action_context_MediaItem_Offset
      
      ultraschall.get_action_context_MediaItem_Start=reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_End=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")+reaper.GetMediaItemInfo_Value(MediaItem, "D_POSITION")
      ultraschall.get_action_context_MediaItem_Length=reaper.GetMediaItemInfo_Value(MediaItem, "D_LENGTH")
      ultraschall.get_action_context_MediaItem_Offset=reaper.GetMediaItemTakeInfo_Value(MediaItem_Take, "D_STARTOFFS")
      
      Item_moved=(ultraschall.get_action_context_MediaItem_Start~=StartDiffTime
              and ultraschall.get_action_context_MediaItem_End~=EndDiffTime)
              
      StartDiffTime=ultraschall.get_action_context_MediaItem_Start-StartDiffTime
      EndDiffTime=ultraschall.get_action_context_MediaItem_End-EndDiffTime
      LengthDiffTime=ultraschall.get_action_context_MediaItem_Length-LengthDiffTime
      OffsetDiffTime=ultraschall.get_action_context_MediaItem_Offset-OffsetDiffTime
      
    end    
  end
  ultraschall.get_action_context_MediaItem_old=MediaItem

  return MediaItem, MediaItem_Take, MediaItem_unlocked, Item_moved, StartDiffTime, EndDiffTime, LengthDiffTime, OffsetDiffTime
end

--a,b,c,d,e,f,g,h,i=ultraschall.get_action_context_MediaItemDiff(exlude_mousecursorsize, x, y)


function ultraschall.GetAllActions(section)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllActions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer number_of_actions, table actiontable = ultraschall.GetAllActions(integer section)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all actions and accompanying attributes from a specific section as a handy table
    
    The table is of the following format:

            actiontable[index]["commandid"]       - the command-id-number of the action  
            actiontable[index]["actioncommandid"] - the action-command-id-string of the action, if it's a named 
                                                    command(usually scripts or extensions), otherwise empty string  
            actiontable[index]["name"]            - the name of command  
            actiontable[index]["scriptfilename"]  - the filename+path of a command, that is a ReaScript, otherwise empty string  
            actiontable[index]["termination"]     - the termination-state of the action  
                                                      -1  - not available  
                                                      4   - Dialogwindow appears(Terminate, New Instance, Abort), if another 
                                                            instance of a given script is started, that's already running  
                                                      260 - always Terminate All(!) Instances, if you try to run another 
                                                            instance of a script, that's already running. When no instance is 
                                                            running, it simply starts the script.  
                                                      516 - always start a New Instance of the script, that's already running  
            actiontable[index]["consolidate"]     - the consolidate-state of custom actions; 
                                                        1 consolidate undo points, 
                                                        2 show in Actions-Menu, 
                                                        3 consolidate undo points AND show in Actions Menu
                                                        -1, if not available  
            actiontable[index]["actiontype"]      - the type of the action; 
                                                    "native action", "extension action", 
                                                    "custom action", "script"  
     
    returns -1 in case of an error.
  </description>
  <retvals>
    integer number_of_actions - the number of actions found; -1 in case of an error
    table actiontable - a table, which holds all attributes of an action(see description for more details)
  </retvals>
  <parameters>
    integer sections - the section, whose actions you want to retrieve
                     - 0, Main=0
                     - 1, invisible actions(shown but not runnable actions)
                     - 100, Main (alt recording)
                     - 32060, MIDI Editor=32060
                     - 32061, MIDI Event List Editor
                     - 32062, MIDI Inline Editor
                     - 32063, Media Explorer=32063
  </parameters>
  <chapter_context>
    API-Helper functions
    Action Related Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, actions, get all, scriptfilename, actiontype, consolidate, termination</tags>
</US_DocBloc>
--]]
  if section~=0 and section~=1 and section~=100 and section~=32060 and section~=32061 and section~=32062 and section~=32063 then
    ultraschall.AddErrorMessage("GetAllActions", "section", "no valid section, must be a number for one of the following sections: Main=0, Main (alt recording)=100, MIDI Editor=32060, MIDI Event List Editor=32061, MIDI Inline Editor=32062, Media Explorer=32063", -1) 
    return -1 
  end

  local A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/reaper-kb.ini") -- read the kb.ini-file
  A=string.gsub(A.."\n", "KEY .-\n", "") -- remove all keyboard-shortcuts
  local ATable={}
  local Acount=0
  for k in string.gmatch(A, "(.-)\n") do
    if k:len()>0 then
      Acount=Acount+1
      ATable[Acount]={}
      ATable[Acount]["Consolidate"] = tonumber(k:match("... (%d-) "))
      ATable[Acount]["AID"] = k:match("... .- .- (.-) ")
      ATable[Acount]["AID"]=string.gsub(ATable[Acount]["AID"], "\"", "")
  
      if k:sub(1,3)=="SCR" then
        ATable[Acount]["Scriptfilename"]=k:match(".- \".-\" (.*)")
        ATable[Acount]["Scriptfilename"]=string.gsub(ATable[Acount]["Scriptfilename"], "\"", "")
      else
        ATable[Acount]["Scriptfilename"]=""
      end
    end
  end
  
  local Table={}
  local counter=0

  -- let's enumerate all actions in this section
  for i=0, 65536 do
    -- let's check, whether an action still exists; if not break the loop, if yes, add it to Table
    local retval, name = reaper.CF_EnumerateActions(section, i, "")
    if retval==0 then break end
    counter=counter+1
--    if reaper.ReverseNamedCommandLookup(retval)~=nil and name:find("SWS") then -- debugline
    
    -- add action to table
    Table[counter]={}
    Table[counter]["commandid"]=retval
    Table[counter]["name"]=name
    Table[counter]["actioncommandid"]=reaper.ReverseNamedCommandLookup(retval)
    
    if name:sub(1,8)=="Script: " then
      for i=1, Acount do
        if Table[counter]["actioncommandid"]==ATable[i]["AID"] then
          Table[counter]["scriptfilename"]=ATable[i]["Scriptfilename"]
          Table[counter]["termination"]=ATable[i]["Consolidate"]
          Table[counter]["consolidate"]=-1
          Table[counter]["actiontype"]="script"
          break
        end
      end
    elseif Table[counter]["actioncommandid"]~=nil and reaper.NamedCommandLookup("_"..Table[counter]["actioncommandid"]) then
      for i=1, Acount do
        if Table[counter]["actioncommandid"]==ATable[i]["AID"] then
          Table[counter]["scriptfilename"]=ATable[i]["Scriptfilename"]
          Table[counter]["consolidate"]=ATable[i]["Consolidate"]
          Table[counter]["termination"]=-1
          Table[counter]["actiontype"]="custom action"
          break
        end
      end
      Table[counter]["scriptfilename"]=""
      Table[counter]["consolidate"]=-1
      Table[counter]["termination"]=-1
      Table[counter]["actiontype"]="extension action"
    else
      Table[counter]["scriptfilename"]=""
      Table[counter]["consolidate"]=-1
      Table[counter]["termination"]=-1
      Table[counter]["actiontype"]="native action"
    end
    
--    end -- debugline
  end

  return counter-1, Table
end


--A,B=ultraschall.GetAllActions(0)

function ultraschall.IsWithinTimeRange(point_in_time, start, stop)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsWithinTimeRange</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsWithinTimeRange(number point_in_time, number start, number stop)</functioncall>
  <description>
    returns if time is between(including) start and stop.
     
    returns false in case of an error
  </description>
  <parameters>
    number point_in_time - the time in seconds, to check for
    number start - the starttime in seconds, within to check for
    number stop - the endtime in seconds, within to check for
  </parameters>
  <retvals>
    boolean retval - true, time is between start and stop; false, it isn't
  </retvals>
  <chapter_context>
    API-Helper functions
    Various Check Functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, check, is between, start, stop, seconds, time</tags>
</US_DocBloc>
--]]
  point_in_time=ultraschall.LimitFractionOfFloat(tonumber(point_in_time),5,true)
  start=ultraschall.LimitFractionOfFloat(tonumber(start),5,true)
  stop=ultraschall.LimitFractionOfFloat(tonumber(stop),5,true)
  if point_in_time==nil or start==nil or stop==nil then return false end
  if point_in_time>=start and point_in_time<=stop then return true else return false end
end

function ultraschall.MediaExplorer_OnCommand(actioncommandid)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_OnCommand</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_OnCommand(integer actioncommandid)</functioncall>
  <description>
    runs a Media Explorer-associated action.
    Note: Can only run Reaper's native actions currently(all actions having a number as actioncommandid), not scripts!
    
    returns false if Media Explorer is closed
  </description>
  <retvals>
    boolean retval - true, could update run the action in the Media Explorer; false, couldn't run it
  </retvals>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>user interface, window, media explorer, hwnd, oncommand, run, command</tags>
</US_DocBloc>
--]]
  if ultraschall.CheckActionCommandIDFormat2(actioncommandid)==false then ultraschall.AddErrorMessage("MediaExplorer_OnCommand", "actioncommandid", "not a valid action-command-id", -1) return false end
  local HWND=ultraschall.GetMediaExplorerHWND()
  if ultraschall.IsValidHWND(HWND)==false then ultraschall.AddErrorMessage("MediaExplorer_OnCommand", "", "Can't get MediaExplorer-HWND. Is it opened?", -2) return false end
  local Actioncommandid=reaper.NamedCommandLookup(actioncommandid)
  return reaper.JS_Window_OnCommand(HWND, tonumber(Actioncommandid))
end

function ultraschall.UpdateMediaExplorer()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>UpdateMediaExplorer</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.UpdateMediaExplorer()</functioncall>
  <description>
    updates the listview of the Media Explorer.
    
    returns false if Media Explorer is closed
  </description>
  <retvals>
    boolean retval - true, could update the listview of the Media Explorer; false, couldn't update the listview
  </retvals>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>user interface, window, media explorer, hwnd, update, listview</tags>
</US_DocBloc>
--]]
  local HWND=ultraschall.GetMediaExplorerHWND()
  if ultraschall.IsValidHWND(HWND)==false then ultraschall.AddErrorMessage("UpdateMediaExplorer", "", "Can't get MediaExplorer-HWND. Is it opened?", -1) return false end
  return reaper.JS_Window_OnCommand(HWND, 40018)
end

function ultraschall.FindPatternsInString(SourceString, pattern, sort_after_finding)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>FindPatternsInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>integer count_found_items, array found_items = ultraschall.FindPatternsInString(string SourceString, string pattern, boolean sort_after_finding)</functioncall>
  <description>
    Finds all occurrences of matching-patterns in a string. You can sort them optionally.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer count_found_items - the number of found items in the string; -1, in case of an error
    array found_items - all occurrences found in the string as an array
  </retvals>
  <parameters>
    string SourceString - the source-string to search for all occurences
    string pattern - the matching-pattern, with which to search for in the string
    boolean sort_after_finding - true, sorts the entries; false, doesn't sort the entries
  </parameters>
  <chapter_context>
    API-Helper functions
    Data Analysis
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, find, patterns, string</tags>
</US_DocBloc>
--]]
  if type(SourceString)~="string" then ultraschall.AddErrorMessage("FindPatternsInString", "SourceString", "must be a string", -1) return -1 end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("FindPatternsInString", "pattern", "not a valid matching-pattern", -2) return -1 end
  if type(sort_after_finding)~="boolean" then ultraschall.AddErrorMessage("FindPatternsInString", "sort_after_finding", "must be a boolean", -3) return -1 end
  local String={}
  local counter=1
  for k in string.gmatch(SourceString, pattern) do
    String[counter]=k
    counter=counter+1
  end
  
  if sort_after_finding==true then table.sort(String) end
  
  local String2=""
  for i=1, counter-1 do
    String2=String2..String[i].."\n"
  end
  return counter-1, String, String2
end

--O,P,Q = ultraschall.FindPatternsInString(A, "<>(.-)</sl>", false)

function ultraschall.RunLuaSourceCode(code)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RunLuaSourceCode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RunLuaSourceCode(string code)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    runs the Lua-code stored in the parameter code
    
    Does not check for validity and syntaxerrors in the code!
    
    You can also add new callable functions that way. Just put function-declarations in the parameter code.
    
    For instance from the following code:
    
      code=function main()
             reaper.MB("I'm only run, when my parent function main is called", "", 0)
           end
           
           reaper.MB("I'm run immediately", "", 0)"
    
    when called by 
    
        ultraschall.RunLuaSourceCode(code)
    
    only the line reaper.MB("I'm run immediately", "", 0) will be run immediately.
    If you want to run the function main as well, you need to explicitly call it with main()
    
    returns false in case of an error; nil, in case of an syntax/lua-error in the code itself
  </description>
  <parameters>
    string code - the code, that you want to execute; you can also add new functions that way
  </parameters>
  <retvals>
    boolean retval - true, code was run successfully; false, code wasn't successfully; nil, code had an error in it, probably syntax error
  </retvals>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, run, lua code, directly</tags>
</US_DocBloc>
--]]
  if type(code)~="string" then ultraschall.AddErrorMessage("RunLuaSourceCode", "code", "must be a string of Lua code", -1) return false end
  local RunMe=load(code)
  RunMe()
  return true
end



function ultraschall.Main_OnCommand_LuaCode(Code, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Main_OnCommand_LuaCode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string script_identifier = ultraschall.Main_OnCommand_LuaCode(string Code, string ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Runs LuaCode as new temporary script-instance. It internally registers the code as a file temporarily as command, runs it and unregisters it again.
    This is especially helpful, when you want to run a command for sure without possible command-id-number-problems.
    
    It returns a unique script-identifier for this script, which can be used to communicate with this script-instance.
    The started script gets its script-identifier using [GetScriptIdentifier](#GetScriptIdentifier).
    You can use this script-identifier e.g. as extstate.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running it was successful; false, if not
    string script_identifier - a unique script-identifier, which can be used as extstate to communicate with the started code
  </retvals>
  <parameters>
    string Code - the Lua-code, which shall be run; will not be checked vor validity!
    string ... - parameters that shall be passed over to the script
  </parameters>
  <chapter_context>
    API-Helper functions
    Child Scripts
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, run code, scriptidentifier, scriptparameters</tags>
</US_DocBloc>
]]
  if type(Code)~="string" then ultraschall.AddErrorMessage("Main_OnCommand_LuaCode", "Code", "must be a string", -1) return false end
  local guid=reaper.genGuid("")
  local params={...}
  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/"..guid..".lua", Code)
  local retval, script_identifier = ultraschall.Main_OnCommandByFilename(ultraschall.API_TempPath.."/"..guid..".lua", params)
  os.remove(ultraschall.API_TempPath.."/"..guid..".lua")
  return retval, script_identifier
end

--P,Q=ultraschall.Main_OnCommand_LuaCode(true, "reaper.MB(\"Juchhu\",\"\",0)",1,2,3,4,5)


function ultraschall.ReplacePatternInString(OriginalString, pattern, replacestring, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReplacePatternInString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.982
    Lua=5.3
  </requires>
  <functioncall>string altered_string, boolean replaced = ultraschall.ReplacePatternInString(string OriginalString, string pattern, string replacestring, integer index)</functioncall>
  <description>
    Replaces the index'th occurrence of pattern in OriginalString with replacepattern.
    
    Unlike string.gsub, this replaces only the selected pattern!
    
    returns nil, false in case of an error
  </description>
  <parameters>
    string OriginalString - the string, from which you want to replace a specific occurence of a matching pattern
    string pattern - the pattern to look for
    string replacestring - the string, which shall replace the found pattern
    integer index - the number of found occurence of the pattern in the string, which shall be replaced
  </parameters>
  <retvals>
    string altered_string - the altered string, where the n'th occurence of the pattern has been replaced
    boolean replaced - true, there has been a replacement; false, no replacement has happened
  </retvals>
  <chapter_context>
    API-Helper functions
    Data Manipulation
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, replace, pattern in string, index, occurrence</tags>
</US_DocBloc>
--]]
  if type(OriginalString)~="string" then ultraschall.AddErrorMessage("ReplacePatternInString", "OriginalString", "must be a string", -1) return nil, false end  
  if type(pattern)~="string" then ultraschall.AddErrorMessage("ReplacePatternInString", "pattern", "must be a string", -2) return nil, false end  
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("ReplacePatternInString", "pattern", "must be a valid Lua-matching-pattern", -3) return nil, false end
  if type(replacestring)~="string" then ultraschall.AddErrorMessage("ReplacePatternInString", "replacestring", "must be a string", -4) return nil, false end  
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("ReplacePatternInString", "index", "must be an integer", -5) return nil, false end  
  local OriginalString2=OriginalString
  local LEN=0
  for i=1, index do 
    local Offset1, Offset2=OriginalString2:match("()"..pattern.."()")
    if Offset1==nil or Offset2==nil then return OriginalString, false end
    if i<index then
      LEN=LEN+Offset2-1
      OriginalString2=OriginalString2:sub(Offset2,-1)
    else
      LEN=LEN+Offset1-1
      OriginalString2=OriginalString2:sub(Offset1,-1)
    end
  end
  
  return OriginalString:sub(1,LEN)..string.gsub(OriginalString2, pattern, replacestring, 1), true
end


function ultraschall.ConvertFunction_ToBase64String(to_convert_function, debug)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertFunction_ToBase64String</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string BASE64_functionstring = ultraschall.ConvertFunction_ToBase64String(function to_convert_function, boolean debug)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts a function into a BASE64-string.
    
    To load a function from a BASE64-string, use [ConvertFunction_FromBase64String](#ConvertFunction_FromBase64String)
    
    Returns nil in case of an error
  </description>
  <retvals>
    string BASE64_functionstring - the function, stored as BASE64-string
  </retvals>
  <parameters>
    function to_convert_function - the function, that you want to convert
    boolean debug - true, store debug-information as well; false, only store function
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, function, base64</tags>
</US_DocBloc>
]]
  if type(to_convert_function)~="function" then ultraschall.AddErrorMessage("ConvertFunction_ToBase64String", "to_convert_function", "must be a function", -1) return end
  
  local Dump=string.dump (to_convert_function, debug)
  local DumpBase64 = ultraschall.Base64_Encoder(Dump)
  
  return DumpBase64
end

function ultraschall.ConvertFunction_FromBase64String(BASE64_functionstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertFunction_FromBase64String</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>function function = ultraschall.ConvertFunction_FromBase64String(string BASE64_functionstring)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Loads a function from a BASE64-string.
    
    To convert a function into a BASE64-string, use [ConvertFunction_ToBase64String](#ConvertFunction_ToBase64String)
    
    Returns nil in case of an error
  </description>
  <retvals>
    function func - the loaded function
  </retvals>
  <parameters>
    string BASE64_functionstring - the function, stored as BASE64-string
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, load, function, base64</tags>
</US_DocBloc>
]]
  if type(BASE64_functionstring)~="string" then ultraschall.AddErrorMessage("ConvertFunction_FromBase64String", "BASE64_functionstring", "must be a string", -1) return end

  local Dump = ultraschall.Base64_Decoder(BASE64_functionstring)
  if Dump==nil then ultraschall.AddErrorMessage("ConvertFunction_FromBase64String", "BASE64_functionstring", "no valid Base64-string", -2) return false end
  local function2=load(Dump)
  if type(function2)~="function" then ultraschall.AddErrorMessage("ConvertFunction_FromBase64String", "BASE64_functionstring", "no function found", -3) return end
  return function2
end


--ultraschall.UpdateMediaExplorer()

function ultraschall.ConvertFunction_ToHexString(to_convert_function, debug)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertFunction_ToHexString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string HEX_functionstring = ultraschall.ConvertFunction_ToHexString(function to_convert_function, boolean debug)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Converts a function into a HEX-string.
    
    To load a function from a HEX-string, use [ConvertFunction_FromHexString](#ConvertFunction_FromHexString)
    
    Returns nil in case of an error
  </description>
  <retvals>
    string HEX_functionstring - the function, stored as HEX-string
  </retvals>
  <parameters>
    function to_convert_function - the function, that you want to convert
    boolean debug - true, store debug-information as well; false, only store function
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, convert, function, hexstring</tags>
</US_DocBloc>
]]
  if type(to_convert_function)~="function" then ultraschall.AddErrorMessage("ConvertFunction_ToHexString", "to_convert_function", "must be a function", -1) return end
  
  local Dump=string.dump (to_convert_function, debug)
  local HexDump = ultraschall.ConvertAscii2Hex(Dump)
  
  return HexDump,Dump
end

--A,A1=ultraschall.ConvertFunction_ToHexString(print, true)


function ultraschall.ConvertFunction_FromHexString(HEX_functionstring)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertFunction_FromHexString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>function function = ultraschall.ConvertFunction_FromHexString(string HEX_functionstring)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Loads a function from a HEX-string.
    
    To convert a function into a HEX-string, use [ConvertFunction_ToHexString](#ConvertFunction_ToHexString)
    
    Returns nil in case of an error
  </description>
  <retvals>
    function func - the loaded function
  </retvals>
  <parameters>
    string HEX_functionstring - the function, stored as HEX-string
  </parameters>
  <chapter_context>
    API-Helper functions
    Function Related
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, load, function, hexstring</tags>
</US_DocBloc>
]]
  if type(HEX_functionstring)~="string" then ultraschall.AddErrorMessage("ConvertFunction_FromHexString", "HEX_functionstring", "must be a string", -1) return end

  local Dump = ultraschall.ConvertHex2Ascii(HEX_functionstring)
  if Dump==nil then ultraschall.AddErrorMessage("ConvertFunction_FromHexString", "HEX_functionstring", "no valid HEX-string", -2) return false end
  local function2=load(Dump)
  if type(function2)~="function" then ultraschall.AddErrorMessage("ConvertFunction_FromHexString", "HEX_functionstring", "no function found", -3) return end
  return function2,Dump
end

--B,B2=ultraschall.ConvertFunction_FromHexString(A)


function ultraschall.Benchmark_GetStartTime(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Benchmark_GetStartTime</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>number starttime = ultraschall.Benchmark_GetStartTime(optional integer slot)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    This function is for benchmarking parts of your code.
    It returns the starttime of the last benchmark-start, started by [Benchmark_MeasureTime](#Benchmark_MeasureTime).
    
    returns nil, if no benchmark has been made yet.
    
    Use [Benchmark_MeasureTime](#Benchmark_MeasureTime) to start/reset a new benchmark-measureing.
  </description>
  <retvals>
    number starttime - the starttime of the currently running benchmark
  </retvals>
  <parameters>
    optional integer slot - the slot, whose starttime you want to get
  </parameters>
  <chapter_context>
    API-Helper functions
    Benchmark
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, start, benchmark, time</tags>
</US_DocBloc>
--]]
  if slot==nil then slot=0 end
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("Benchmark_GetStartTime", "slot", "must be an integer", -1) return end
  if ultraschall.Benchmark_StartTime_Time==nil then ultraschall.Benchmark_StartTime_Time={} end
  return ultraschall.Benchmark_StartTime_Time[slot]
end

function ultraschall.Benchmark_GetAllStartTimesAndSlots()
    --[[
    <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
      <slug>Benchmark_GetAllStartTimesAndSlots</slug>
      <requires>
        Ultraschall=4.1
        Reaper=5.975
        Lua=5.3
      </requires>
      <functioncall>number starttime = ultraschall.Benchmark_GetStartTime()</functioncall>
      <description markup_type="markdown" markup_version="1.0.1" indent="default">
        This function is for benchmarking parts of your code.
        It returns a table with all starttimes of all current benchmark-measurings. The index of the table reflects the slots.
        
        Use [Benchmark_MeasureTime](#Benchmark_MeasureTime) to start/reset a new benchmark-measureing.
      </description>
      <retvals>
        table starttime_slots - a table with all starttimes of all current benchmark-measurings, where the index reflects the slots
      </retvals>
      <chapter_context>
        API-Helper functions
        Benchmark
      </chapter_context>
      <target_document>US_Api_Functions</target_document>
      <source_document>ultraschall_functions_HelperFunctions_Module.lua</source_document>
      <tags>helper functions, get, all, slots, start, benchmark, time</tags>
    </US_DocBloc>
    --]]
    return ultraschall.Benchmark_StartTime_Time
end

function ultraschall.Benchmark_MeasureTime(timeformat, reset, slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Benchmark_MeasureTime</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>number elapsed_time, string elapsed_time_string, string measure_evaluation = ultraschall.Benchmark_MeasureTime(optional integer time_mode, optional boolean reset, optional integer slot)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    This function is for benchmarking parts of your code.
    It returns the passed time, since last time calling this function.
    
    Use [Benchmark_GetStartTime](#Benchmark_GetStartTime) to start the benchmark.
  </description>
  <retvals>
    number elapsed_time - the elapsed time in seconds
    string elapsed_time_string - the elapsed time, formatted by parameter time_mode
    string measure_evaluation - an evaluation of time, mostly starting with &lt; or &gt; an a number of +
                              - 0, no time passed
                              - >, for elapsed times greater than 1, the following + will show the number of integer digits; example: 12.927 -> ">++"
                              - <, for elapsed times smaller than 1, the following + will show the number of zeros+1 in the fraction, until the first non-zero-digit appears; example: 0.0063 -> "<+++"
  </retvals>
  <parameters>
    optional integer time_mode - the formatting of elapsed_time_string
                               - 0=time
                               - 1=measures.beats + time
                               - 2=measures.beats
                               - 3=seconds
                               - 4=samples
                               - 5=h:m:s:f
    optional boolean reset - true, resets the starttime(for new measuring); false, keeps current measure-starttime(for continuing measuring)
    optional integer slot - if you want to have multiple benchmark-measures at the same time, you can store them in different slots.
                          - means, you can measure in slot 1 and slot 2, where you can occasionally reset slot 1 while 
                          - having continuous measuring in slot 2.
                          - this allows you to measure the execution time of the whole script(slot 2) and certain parts of the script 
                          - on individual basis(slot 1).
                          - you can use as many slots, as you want.
                          - nil, default slot is 0
  </parameters>
  <chapter_context>
    API-Helper functions
    Benchmark
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, start, benchmark, time</tags>
</US_DocBloc>
--]]
  local passed_time=reaper.time_precise()
  if slot==nil then slot=0 end
  if ultraschall.Benchmark_StartTime_Time==nil then ultraschall.Benchmark_StartTime_Time={} end 
  if ultraschall.Benchmark_StartTime_Time[slot]==nil then ultraschall.Benchmark_StartTime_Time[slot]=passed_time end
  if timeformat~=nil and math.type(timeformat)~="integer" then ultraschall.AddErrorMessage("Benchmark_MeasureTime", "timeformat", "must be an integer", -2) return end
  if timeformat~=nil and (timeformat<0 or timeformat>7)then ultraschall.AddErrorMessage("Benchmark_MeasureTime", "timeformat", "must be between 0 and 7 or nil", -3) return end
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("Benchmark_MeasureTime", "slot", "must be an integer", -4) return end
  
  passed_time=passed_time-ultraschall.Benchmark_StartTime_Time[slot]
  if reset==true or reset==nil then ultraschall.Benchmark_StartTime_Time[slot]=reaper.time_precise() end
  local valid=""
  local passed_time_string=""
  if passed_time==0 then
  valid="0"
  elseif passed_time>1 then 
    valid=tostring(passed_time):match("(.-)%..*")
    if valid==nil then valid=tostring(passed_time) end
    valid=">"..string.gsub(valid, "%d", "+")
  elseif passed_time<0.00016333148232661 then
    valid="<++++"
  else
    valid=tostring(passed_time):match(".-%.(0*)")
    if valid==nil then valid="0" end
    valid="<"..string.gsub(valid, "0", "+").."+"
  end
  if timeformat==0 or timeformat==nil then
    passed_time_string=tostring(passed_time) 
  else
    passed_time_string=reaper.format_timestr_len(passed_time, "", 0, timeformat-1)
  end
  return passed_time, passed_time_string, valid
end

function ultraschall.TimeToMeasures(project, Time)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>TimeToMeasures</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>number measure = ultraschall.TimeToMeasures(ReaProject project, number Time)</functioncall>
    <description>
       a function which converts a time into current projects time-measures
       only useful, when there are no tempo-changes in the project
       
       returns nil in case of an error
    </description>
    <retvals>
      number measure - the measures, that parameter time needs to be reflected
    </retvals>
    <parameters>
        ReaProject project  - ReaProject to use the timesignature-settings from
        number time         - in seconds, the time to convert into a time-measurment, which can be
                            - used in config-variable "prerollmeas"
    </parameters>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, convert, time, to measures</tags>
  </US_DocBloc>
  --]]
  -- quick function that converts a time into current projects time-measures
  -- only useful, when there are no tempo-changes in the project
  --
  -- parameters:
  --  project - ReaProject to use the timesignature-settings from
  --  time    - in seconds, the time to convert into a time-measurment, which can be
  --             used in config-variable "prerollmeas"
  --
  -- retval:
  --  measure - the measures, that parameter time needs to be reflected
  --print2(ultraschall.type(Time))
  if project~=0 and ultraschall.type(project)~="ReaProject" then ultraschall.AddErrorMessage("TimeToMeasures", "project", "must be a ReaProject", -1) return end
  if ultraschall.type(Time):sub(1,7)~="number:" then ultraschall.AddErrorMessage("TimeToMeasures", "Time", "must be a number in seconds", -2) return end
  local Measures=reaper.TimeMap2_beatsToTime(project, 0, 1)
  local retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(project, 10)
  local QN=reaper.TimeMap2_timeToQN(project, 1)
  local Measures_Fin=Measures/cdenom
  local Measures_Fin2=Measures_Fin*Time
  return Measures_Fin2
end




function ultraschall.Create2DTable(maxx, maxy, defval)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Create2DTable</slug>
    <requires>
      Ultraschall=4.5
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>table Two_D_table = ultraschall.Create2DTable(integer maxx, integer maxy, optional anytype defval)</functioncall>
    <description>
       creates a 2-dimensional table with x-lines and y-rows, of which all entries are indexable right away.
       
       It also has two additional fields ["x"] and ["y"] who hold the x and y-dimensions of the table you've set for later reference.
       
       returns nil in case of an error
    </description>
    <retvals>
      table Two_D_table - the 2d-table you've created
    </retvals>
    <parameters>
        integer maxx - the number of rows in the table(x-dimension)
        integer maxy - the number of lines in the table(y-dimension)
        optional anytype defval - the default-value to set in each field, can be any type
    </parameters>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, create, 2d table</tags>
  </US_DocBloc>
  --]]
  if math.type(maxx)~="integer" then ultraschall.AddErrorMessage("Create2DTable", "maxx", "must be an integer", -1) return nil end
  if math.type(maxy)~="integer" then ultraschall.AddErrorMessage("Create2DTable", "maxy", "must be an integer", -2) return nil end
  if maxx<1 then ultraschall.AddErrorMessage("Create2DTable", "maxx", "must be 1 or higher", -4) return nil end
  if maxy<1 then ultraschall.AddErrorMessage("Create2DTable", "maxy", "must be 1 or higher", -5) return nil end
  local Table={}

  -- create table-datatypes for each entry in the 2d-table
  for x=1, maxx do
    Table[x]={}
    for y=1, maxy do
      Table[x][y]=defval
    end
  end
  
  -- store x and y dimensions for later reference
  Table["x"]=maxx
  Table["y"]=maxy
  
  return Table
end


--A=ultraschall.Create2DTable(1, 1)
--SLEM()


function ultraschall.Create3DTable(maxx, maxy, maxz, defval)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Create3DTable</slug>
    <requires>
      Ultraschall=4.5
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>table ThreeD_table = ultraschall.Create3DTable(integer maxx, integer maxy, integer maxz, optional anytype defval)</functioncall>
    <description>
       creates a 3-dimensional table with x-lines and y-rows and z-depths, of which all entries are indexable right away.
       
       It also has two additional fields ["x"], ["y"] and ["z"] who hold the x, y and z-dimensions of the table you've set for later reference.
       
       returns nil in case of an error
    </description>
    <retvals>
      table ThreeD_table - the 3d-table you've created
    </retvals>
    <parameters>
        integer maxx - the number of rows in the table(x-dimension)
        integer maxy - the number of lines in the table(y-dimension)
        integer maxz - the number of depths in the table(z-dimension)
        optional anytype defval - the default-value to set in each field, can be any type
    </parameters>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, create, 3d table</tags>
  </US_DocBloc>
  --]]
  if math.type(maxx)~="integer" then ultraschall.AddErrorMessage("Create3DTable", "maxx", "must be an integer", -1) return nil end
  if math.type(maxy)~="integer" then ultraschall.AddErrorMessage("Create3DTable", "maxy", "must be an integer", -2) return nil end
  if math.type(maxz)~="integer" then ultraschall.AddErrorMessage("Create3DTable", "maxy", "must be an integer", -3) return nil end

  if maxx<1 then ultraschall.AddErrorMessage("Create3DTable", "maxx", "must be 1 or higher", -4) return nil end
  if maxy<1 then ultraschall.AddErrorMessage("Create3DTable", "maxy", "must be 1 or higher", -5) return nil end
  if maxz<1 then ultraschall.AddErrorMessage("Create3DTable", "maxz", "must be 1 or higher", -6) return nil end
  local Table={}

  -- create table-datatypes for each entry in the 3d-table
  for x=1, maxx do
    Table[x]={}
    for y=1, maxy do
      Table[x][y]={}
      for z=1, maxz do
        Table[x][y][z]=defval
      end
    end
  end

  -- store x,y and z dimensions for later reference
  Table["x"]=maxx
  Table["y"]=maxy
  Table["z"]=maxy
  
  return Table
end

--B=ultraschall.Create3DTable(5,5,5, "trudel")


--B=ultraschall.Create3DTable(20,20,20)


function ultraschall.CreateMultiDimTable(defval, ...)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>CreateMultiDimTable</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.10
      Lua=5.3
    </requires>
    <functioncall>table multidimtable = ultraschall.CreateMultiDimTable(optional anytype defval, optional integer dimension1, optional integer dimension2, ... , optional integer dimensionN)</functioncall>
    <description>
       creates a multidimensional table
       
       It also adds additional fields ["dimension1"] to ["dimension10"] who hold the number of available entries in this dimension for later reference.

       It supports up to 10 dimensions.
       Note: the more dimensions, the more memory you need and the longer it takes to create the table.
       
       returns nil in case of an error
    </description>
    <retvals>
      table multidimtable - the multidimensional-table you've created
    </retvals>
    <parameters>
        optional anytype defval - the default-value to set in each field, can be any type; set to nil to keep empty
        integer dimension1 - the number of entries in the first dimension of the table
        integer dimension2 - the number of entries in the second dimension of the table
        integer dimensionN - the number of entries in the n'th dimension of the table
    </parameters>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
    <tags>helper functions, create, multidimensional table</tags>
  </US_DocBloc>
  --]]
  Parms={...}

  if math.type(Parms[1])~="integer" then ultraschall.AddErrorMessage("CreateMultiDimTable", "parameter "..2, "must be an integer", -1) return nil end
  if Parms[1]<1 then ultraschall.AddErrorMessage("CreateMultiDimTable", "parameter "..2, "must be 1 or higher", -2) return nil end
  
  for i=2, #Parms do
    if math.type(Parms[i])~="integer" then ultraschall.AddErrorMessage("CreateMultiDimTable", "parameter "..i+1, "must be an integer", -1) return nil end
    if Parms[i]<1 then ultraschall.AddErrorMessage("CreateMultiDimTable", "parameter "..i+1, "must be 1 or higher", -2) return nil end
  end

  local Table={defval}
  Table={}
  for a=1, Parms[1] do
    if Parms[2]~=nil then
      Table[a]={}
      for b=1, Parms[2] do
        if Parms[3]~=nil then
          Table[a][b]={}
          for c=1, Parms[3] do
            if Parms[4]~=nil then
              Table[a][b][c]={}
              for d=1, Parms[4] do
                if Parms[5]~=nil then
                  Table[a][b][c][d]={}
                  for e=1, Parms[5] do
                    if Parms[6]~=nil then
                      Table[a][b][c][d][e]={}
                      for f=1, Parms[6] do
                        if Parms[7]~=nil then
                          Table[a][b][c][d][e][f]={}
                          for g=1, Parms[7] do
                            if Parms[8]~=nil then
                              Table[a][b][c][d][e][f][g]={}
                              for h=1, Parms[8] do
                                if Parms[9]~=nil then
                                  Table[a][b][c][d][e][f][g][h]={}
                                  for i=1, Parms[9] do
                                    if Parms[10]~=nil then
                                      Table[a][b][c][d][e][f][g][h][i]={}
                                      for j=1, Parms[10] do
                                        Table[a][b][c][d][e][f][g][h][i][j]=defval 
                                      end
                                    else 
                                      Table[a][b][c][d][e][f][g][h][i]=defval 
                                    end
                                  end
                                else 
                                  Table[a][b][c][d][e][f][g][h]=defval 
                                end
                              end
                            else 
                              Table[a][b][c][d][e][f][g]=defval 
                            end
                          end
                        else 
                          Table[a][b][c][d][e][f]=defval 
                        end              
                      end
                    else 
                      Table[a][b][c][d][e]=defval 
                    end
                  end
                else 
                  Table[a][b][c][d]=defval 
                end
              end
            else 
              Table[a][b][c]=defval 
            end
          end
        else 
          Table[a][b]=defval 
        end
      end
    else 
      Table[a]=defval 
    end
  end
  
  -- store size of each dimension for later reference
  local O=#Parms
  if O>10 then O=10 end
  
  for i=1, O do
    Table["dimension"..i]=Parms[i]
  end
  
  return Table
end

--max=1

--A=ultraschall.CreateMultiDimTable(33, max, max, max, max, max, max, max, max, max, max)

function ultraschall.GMem_Read_ValueRange(startindex, number_of_indices, use_gmem_indices_for_table, gmemname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GMem_Read_ValueRange</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>table gmem_values = ultraschall.GMem_Read_ValueRange(integer startindex, integer number_of_indices, optional boolean use_gmem_indices_for_table, optional string gmem_attachname)</functioncall>
  <description>
    Returns a table with all values of a gmem between startindex and startindex+number_of_indices.
    You can optionally set a specific gmem-attachname or leave it blank to get the values from the currently attached gmem.
    
    Set use_gmem_indices_for_table=true, so have the index of the table reflect the index of the gmems.
    
    Note: Keep in mind, that requesting tons of gmem-values will use up a lot of resources, so to to just get, what you need to avoid hanging gui.
    
    Returns nil in case of an error
  </description>
  <retvals>
    table gmem_values - the requested values.
  </retvals>
  <parameters>
    integer startindex - the first index you want to request; must be 0 or higher
    integer number_of_indices - the number of values to request, from startindex onwards
    optional boolean use_gmem_indices_for_table - true, index the table according to gmem-index; false or nil, just index from 1 onwards
    optional string gmem_attachname - the attached gmem, from which you want to get the values; nil, use the currently attached gmem
  </parameters>
  <chapter_context>
    API-Helper functions
    Gmem/Shared Memory
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, gmem, values</tags>
</US_DocBloc>
]]
  if math.type(startindex)~="integer" then ultraschall.AddErrorMessage("GMem_Read_ValueRange", "startindex", "must be an integer", -1) return nil end
  if math.type(number_of_indices)~="integer" then ultraschall.AddErrorMessage("GMem_Read_ValueRange", "number_of_indices", "must be an integer", -2) return nil end
  if use_gmem_indices_for_table~=nil and type(use_gmem_indices_for_table)~="boolean" then ultraschall.AddErrorMessage("GMem_Read_ValueRange", "use_gmem_indices_for_table", "must be a boolean or nil(for false)", -3) return nil end  
  if gmem_attachname~=nil and type(gmem_attachname)~="string" then ultraschall.AddErrorMessage("GMem_Read_ValueRange", "gmem_attachname", "must be a string or nil(for currently attached gmem)", -3) return nil end  
  
  local oldgmemname=ultraschall.Gmem_GetCurrentAttachedName()
  if gmemname~=nil then
    reaper.gmem_attach(gmemname)
  end
  local Values={}
  local a=0
  local index
  for i=startindex, startindex+number_of_indices do
    a=a+1
    if use_gmem_indices_for_table==true then index=i else index=a end
    Values[index]=reaper.gmem_read(i)
  end
  if oldgmemname==nil then oldgmemname="" end
  if gmemname~=nil then
    reaper.gmem_attach(oldgmemname)
  end
  return Values
end

function ultraschall.GMem_GetValues_VideoSamplePeeker(samplesize)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GMem_GetValues_VideoSamplePeeker</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.10
    Lua=5.3
  </requires>
  <functioncall>number play_pos, integer samplerate, integer num_channels, integer requested_samplebuffer_length, table samplebuffer = ultraschall.GMem_GetValues_VideoSamplePeeker(optional integer samplesize)</functioncall>
  <description>
    For usage together with the JSFX-fx- "Video Sample Peeker", which sends samples to a gmem, that can be used(for instance by video processor's presets "Synthesis: Decorative Oscilloscope with Blitter" and "Synthesis: Decorative Spectrum Analyzer").
    
    Ths returns all important values and the samples-values.

    You need to use the samples according to samplerate and number of channels to be able to do something with it.
    
    The overall maximum sample-buffer provided by the JSFX is 2 seconds.
    
    Returns nil in case of an error
  </description>
  <retvals>
    number play_pos - the playposition, when the sample has been re
    integer samplerate - the samplerate of the sampledata
    integer num_channels - the number of channels within the sampledata
    integer requested_samplebuffer_length - the length of the requested buffer; maximum is the number of values for about 2 seconds
    table samplebuffer - the values themselves
  </retvals>
  <parameters>
    optional integer samplesize - the samplesize you want to get; nil, return the whole 2-seconds-samplebuffer(takes a lot of resources)
  </parameters>
  <chapter_context>
    API-Helper functions
    Gmem/Shared Memory
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, gmem, values, video sample peeker, samples, sample buffer</tags>
</US_DocBloc>
]]
  if samplesize~=nil and math.type(samplesize)~="integer" then ultraschall.AddErrorMessage("GMem_GetValues_VideoSamplePeeker", "samplesize", "must be an integer or nil to get full 2-seconds-sample-buffer", -1) return nil end
  local Values=ultraschall.GMem_Read_ValueRange(0, 16, true, "jsfx_to_video")
  --                       GMem_Read_ValueRange(startindex, number_of_indices, use_gmem_indices_for_table, gmemname)
  --if Values==nil then ultraschall.AddErrorMessage("GMem_GetValues_VideoSamplePeeker", "", "video sample peeker not yet loaded", -2) return nil end
  if samplesize==nil then samplesize=Values[5] end
  local samplesize2
  
  if samplesize>Values[5]-Values[2] then
    samplesize2=Values[2]-Values[5]+samplesize
    samplesize=Values[5]
  else
    samplesize2=0
    samplesize=samplesize+Values[2]
  end
  
  local Buf={}
  local OldAttachname=ultraschall.Gmem_GetCurrentAttachedName()

  reaper.gmem_attach("jsfx_to_video")
  local a=0
--  for i=Values[2], Values[5] do
  for i=Values[2], samplesize do
    a=a+1
    Buf[a]=reaper.gmem_read(i)
  end

--  for i=16, Values[2] do
  for i=16, samplesize2 do
    P=i
    a=a+1
    Buf[a]=reaper.gmem_read(i)
  end
--]]
  reaper.gmem_attach(OldAttachname)
  
  return Values[1], -- buf play pos
         math.tointeger(Values[3]), -- buf samplerate
         math.tointeger(Values[6]), -- number of channels
         #Buf,  -- number of values of the sample-buffer
         Buf   -- the values themselves of the sample-buffer
end

function ultraschall.ReturnReaperExeFile_With_Path()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReturnReaperExeFile_With_Path</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.33
    Lua=5.3
  </requires>
  <functioncall>string exefile_with_path = ultraschall.ReturnReaperExeFile_With_Path()</functioncall>
  <description>
    returns the reaper-exe-file with file-path
  </description>
  <retvals>
    string exefile_with_path - the filename and path of the reaper-executable
  </retvals>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>helper functions, get, exe, filename, path</tags>
</US_DocBloc>
--]]
  if ultraschall.IsOS_Windows()==true then
    -- On Windows
    ExeFile=reaper.GetExePath().."\\reaper.exe"
  elseif ultraschall.IsOS_Mac()==true then
    -- On Mac
    ExeFile=reaper.GetExePath().."/Reaper64.app/Contents/MacOS/reaper"
    if reaper.file_exists(ExeFile)==false then
      ExeFile=reaper.GetExePath().."/Reaper.app/Contents/MacOS/reaper"
    end
  else
    -- On Linux
    ExeFile=reaper.GetExePath().."/reaper"
  end
  return ExeFile
end


function ultraschall.MediaExplorer_SetDeviceOutput(channel, mono)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetDeviceOutput</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetDeviceOutput(integer channel, boolean mono)</functioncall>
  <description>
    Sets the output-channel(s) of the Media Explorer
    
    When Media Explorer is opened, playback will be stopped and the Media Explorer will flicker for a short time. This is due limitations in Reaper.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer channel - the channel to set the media-explorer-output to
                    - when mono: 1-512
                    - when stereo: 1-511
                    - -1, Play through first track named "Media Explorer Preview" or first selected track
    boolean mono - true, use the mono-channel; false, use stereo-channels
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, device output, mono, stereo</tags>
</US_DocBloc>
--]]
  if math.type(channel)~="integer" then ultraschall.AddErrorMessage("MediaExplorer_SetDeviceOutput", "channel", "must be an integer", -1) return false end
  if type(mono)~="boolean" then ultraschall.AddErrorMessage("MediaExplorer_SetDeviceOutput", "mono", "must be a boolean", -2) return false end
  if channel==0 or channel>512 then ultraschall.AddErrorMessage("MediaExplorer_SetDeviceOutput", "channel", "no such channel", -3) return false end
  if mono==false and channel==512 then ultraschall.AddErrorMessage("MediaExplorer_SetDeviceOutput", "channel", "no such channel", -4) return false end
  if channel>-1 then
    channel=channel-1
    if mono==true then channel=channel+1024 end
  end
  local A=reaper.GetToggleCommandState(50124)
  if A==1 then reaper.Main_OnCommand(50124, 0) end
  reaper.BR_Win32_WritePrivateProfileString("reaper_explorer", "outputidx", channel, reaper.get_ini_file())
  if A==1 then reaper.Main_OnCommand(50124, 0) end
  return true
end

function ultraschall.MediaExplorer_SetAutoplay(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetAutoplay</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetAutoplay(boolean state)</functioncall>
  <description>
    Sets the autoplay-state of the Media Explorer
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, activate autoplay; false, deactivate autoplay
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, autoplay</tags>
</US_DocBloc>
--]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("MediaExplorer_SetAutoplay", "state", "must be a boolean", -1) return false end
  if state==true then state=1 else state=0 end
  local A=reaper.GetToggleCommandState(50124)
  if A==0 then 
    local retval, state2=reaper.BR_Win32_GetPrivateProfileString("reaper_explorer", "autoplay", -1, reaper.get_ini_file())
    state2=tonumber(state2)
    if state2~=state then
      reaper.BR_Win32_WritePrivateProfileString("reaper_explorer", "autoplay", state, reaper.get_ini_file())
    end
  else
    local retval, state2=reaper.BR_Win32_GetPrivateProfileString("reaper_explorer", "autoplay", -1, reaper.get_ini_file())
    state2=tonumber(state2)
    if state2~=state then

      local HWND=reaper.OpenMediaExplorer("", false)
      local Button=reaper.JS_Window_FindChildByID(HWND, 1011)
      reaper.JS_WindowMessage_Send(Button, "WM_LBUTTONDOWN", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Send(Button, "WM_LBUTTONUP", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Post(Button, "WM_LBUTTONDOWN", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Post(Button, "WM_LBUTTONUP", 1, 1, 1, 1)
    end
  end

  return true
end


function ultraschall.MediaExplorer_SetRate(rate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetRate</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetRate(number rate)</functioncall>
  <description>
    Sets the rate of the Media Explorer; works only with Media Explorer opened!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    number rate - the value to set the rate to
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, rate</tags>
</US_DocBloc>
--]]
  if type(rate)~="number" then ultraschall.AddErrorMessage("MediaExplorer_SetRate", "rate", "must be a boolean", -1) return false end
  local A=reaper.GetToggleCommandState(50124)
  if A~=0 then 
    local HWND=reaper.OpenMediaExplorer("", false)
    local Button=reaper.JS_Window_FindChildByID(HWND, 1454)
    reaper.JS_Window_SetTitle(Button, tostring(rate))
    return true
  else 
    ultraschall.AddErrorMessage("MediaExplorer_SetRate", "", "Media Explorer isn't open", -2) 
    return false 
  end
end

function ultraschall.MediaExplorer_SetStartOnBar(state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetStartOnBar</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetStartOnBar(boolean state)</functioncall>
  <description>
    Sets the start on bar-state of the Media Explorer
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    boolean state - true, activate start on bar; false, deactivate start on bar
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, start on bar</tags>
</US_DocBloc>
--]]
  if type(state)~="boolean" then ultraschall.AddErrorMessage("MediaExplorer_SetStartOnBar", "state", "must be a boolean", -1) return false end
  if state==true then state=1 else state=0 end
  local A=reaper.GetToggleCommandState(50124)
  if A==0 then 
    local retval, state2=reaper.BR_Win32_GetPrivateProfileString("reaper_explorer", "beatsync", -1, reaper.get_ini_file())
    state2=tonumber(state2)
    if state2~=state then
      reaper.BR_Win32_WritePrivateProfileString("reaper_explorer", "beatsync", state, reaper.get_ini_file())
    end
  else
    local retval, state2=reaper.BR_Win32_GetPrivateProfileString("reaper_explorer", "beatsync", -1, reaper.get_ini_file())
    state2=tonumber(state2)
    if state2~=state then
      local HWND=reaper.OpenMediaExplorer("", false)
      local Button=reaper.JS_Window_FindChildByID(HWND, 1012)
      reaper.JS_WindowMessage_Send(Button, "WM_LBUTTONDOWN", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Send(Button, "WM_LBUTTONUP", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Post(Button, "WM_LBUTTONDOWN", 1, 1, 1, 1)
      reaper.JS_WindowMessage_Post(Button, "WM_LBUTTONUP", 1, 1, 1, 1)
    end
  end

  return true
end

function ultraschall.MediaExplorer_SetPitch(pitch)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetPitch</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetPitch(number pitch)</functioncall>
  <description>
    Sets the pitch of the Media Explorer; works only with Media Explorer opened!
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    number rate - the value to set the pitch to
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, pitch</tags>
</US_DocBloc>
--]]
  if type(pitch)~="number" then ultraschall.AddErrorMessage("MediaExplorer_SetPitch", "pitch", "must be a number", -1) return false end
  local A=reaper.GetToggleCommandState(50124)
  if A~=0 then 
    local HWND=reaper.OpenMediaExplorer("", false)
    local Button=reaper.JS_Window_FindChildByID(HWND, 1021)
    reaper.JS_Window_SetTitle(Button, tostring(pitch))
    return true
  else 
    ultraschall.AddErrorMessage("MediaExplorer_SetPitch", "", "Media Explorer isn't open", -2) 
    return false 
  end
end


function ultraschall.MediaExplorer_SetVolume(value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MediaExplorer_SetVolume</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.02
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MediaExplorer_SetVolume(number value)</functioncall>
  <description>
    Sets the volume of the Media Explorer; works only with Media Explorer opened!
    
    The volume is close, but not necessarily exactly the requested value.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting the value was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    number value - the value to set the volume to; -127 to +12
  </parameters>
  <chapter_context>
    Media Explorer
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>media explorer, set, volume</tags>
</US_DocBloc>
--]]
  if type(value)~="number" then ultraschall.AddErrorMessage("MediaExplorer_SetVolume", "value", "must be a number", -1) return false end
  if value<-127 then value=-127 end
  if value>12 then value=12 end
  local A=reaper.GetToggleCommandState(50124)
  if A~=0 then 
    local dir=0
    local HWND=reaper.OpenMediaExplorer("", false)
    local Text=reaper.JS_Window_FindChildByID(HWND, 1047)
    local Fader=reaper.JS_Window_FindChildByID(HWND, 1045)
    if value==0 then reaper.JS_WindowMessage_Send(Fader, "WM_LBUTTONDBLCLK", 0, 0, 0, 0) return true end

    local Val=tonumber(reaper.JS_Window_GetTitle(Text):sub(1,-3))
    if tonumber(Val)==nil then Val=-140 end
    if value<Val then dir=-1 elseif value>Val then dir=1 end
    local oldmousewheelmode = reaper.SNM_GetIntConfigVar("mousewheelmode", -667)
    reaper.SNM_SetIntConfigVar("mousewheelmode", 0)
    for i=0, 3000 do
       -- apply mousewheel in the desired direction, until the shown volume is closest 
       -- to the desired value
       Val=tonumber(reaper.JS_Window_GetTitle(Text):sub(1,-3))
       if tonumber(Val)==nil then Val=-140 end
       if dir==-1 then
         --BBB=Val
         if Val<=value then 
           break 
         else
           reaper.JS_WindowMessage_Send(Fader, "WM_MOUSEWHEEL", 0, dir, 0, 0)
         end
       end
       if dir==1 then
         if Val>=value then 
           break 
         else
           reaper.JS_WindowMessage_Send(Fader, "WM_MOUSEWHEEL", 0, dir, 0, 0)
         end
       end
       -- AAA=i
    end
    reaper.SNM_SetIntConfigVar("mousewheelmode", oldmousewheelmode)
   
    return true
  else 
    ultraschall.AddErrorMessage("MediaExplorer_SetVolume", "", "Media Explorer isn't open", -2) 
    return false 
  end
end

function ultraschall.IsValidReaProject(ReaProject)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidReaProject</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidReaProject(ReaProject ReaProject)</functioncall>
  <description>
    Returns, if parameter ReaProject is a valid ReaProject(means, an existing opened project) or not.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if parameter ReaProject is a valid ReaProject; false, if parameter ReaProject isn't a valid ReaProject
  </retvals>
  <parameters>
    ReaProject ReaProject - the object that you want to check for being a valid ReaProject
  </parameters>
  <chapter_context>
    Project-Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua</source_document>
  <tags>projectmanagement, check, reaproject, project, object, valid</tags>
</US_DocBloc>
]]
  --if ReaProject==nil or type(ReaProject)~="number" then return false end
  if ReaProject==nil then return true end
  if ReaProject==0 then return true end
  local count=0
  while reaper.EnumProjects(count,"")~=nil do
    if reaper.EnumProjects(count,"")==ReaProject then return true end
    count=count+1
  end
  return false
end

--K=ultraschall.IsValidReaProject(reaper.EnumProjects(0,""))

function ultraschall.GetSetIDEAutocompleteSuggestions(is_set, value)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetSetIDEAutocompleteSuggestions</slug>
    <requires>
      Ultraschall=4.5
      Reaper=6.20
      SWS=2.10.0.1
      Lua=5.3
    </requires>
    <functioncall>integer suggestions = ultraschall.GetSetIDEAutocompleteSuggestions(boolean is_set, integer value)</functioncall>
    <description>
      gets/sets the number of shown suggestions for autocomplete in the IDE
      
      affects all IDEs immediately
      
      Returns nil in case of an error
    </description>
    <retvals>
      integer suggestions - the number of shown suggestions
    </retvals>
    <parameters>
      boolean is_set - true, set a new value; false, get the current one
      integer value - the new value, must be between 0 and 2147483647; default is 50
    </parameters>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>ide, get, set, autocomplete, suggestions</tags>
  </US_DocBloc>
  ]]
  if type(is_set)~="boolean" then ultraschall.AddErrorMessage("GetSetIDEAutocompleteSuggestions", "is_set", "must be a boolean", -1) return end
  if math.type(value)~="integer" then ultraschall.AddErrorMessage("GetSetIDEAutocompleteSuggestions", "value", "must be an integer", -2) return end
  if value<0 then value=0 end
  if value>2147483647 then value=2147483647 end
  if is_set~=true then
    return reaper.SNM_GetIntConfigVar("edit_sug", -111)
  end
  reaper.SNM_SetIntConfigVar("edit_sug", value)
  return value
end

function ultraschall.GetRandomString()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetRandomString</slug>
    <requires>
      Ultraschall=4.75
      Reaper=6.20
      Lua=5.3
    </requires>
    <functioncall>string random_string = ultraschall.GetRandomString()</functioncall>
    <description>
      creates a string with random upper and lowercase letters. Length it also random with maximum 256 characters.
    </description>
    <retvals>
      string random_string - a random string
    </retvals>
    <chapter_context>
      API-Helper functions
      Various
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Render_Module.lua</source_document>
    <tags>misc, get, random, string</tags>
  </US_DocBloc>
  ]]
  local len=math.random(math.random(256))
  local newstr=""
  for i=0, len do
    for i=0, 255 do
      local a=math.random(256)
      if (a>65 and a<91) or (a>96 and a<123) then newstr=newstr..string.char(a) break end
    end
  end
  return newstr
end

function ultraschall.SplitReaperString(ReaperString)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SplitReaperString</slug>
  <requires>
    Ultraschall=5
    Reaper=7.0
    Lua=5.4
  </requires>
  <functioncall>integer string_count, table strings = ultraschall.SplitReaperString(string ReaperString)</functioncall>
  <description>
    splits a Reaper-string into its components.
    
    Reaper strings are usually found in statechunks, where some strings are alphanumeric, while others who contain a space in them are enclosed in \"
    Example: Tudelu "My Shoe" is bigger "than yours"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer string_count - the number of strings found
    table strings - a table with all found strings
  </retvals>
  <parameters>
    string ReaperString - the string, that you want to split into its individual parts
  </parameters>
  <chapter_context>
    API-Helper functions
    Various
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_HelperFunctions_Module.lua.lua</source_document>
  <tags>api helper function, split, reaper string, statechunks</tags>
</US_DocBloc>
--]]
  if type(ReaperString)~="string" then ultraschall.AddErrorMessage("SplitReaperString", "ReaperString", "must be a string", -1) return -1 end
  local Strings={}
  local index=1
  Strings[index]=""
  for i=0, ReaperString:len() do
    if ReaperString:sub(i,i)==" " and inside~=true then
      index=index+1
      Strings[index]=""
    elseif ReaperString:sub(i,i)=="\"" and inside~=true then
      inside=true
    elseif ReaperString:sub(i,i)=="\"" and inside==true then
      inside=false
    elseif ReaperString:sub(i,i)~="\"" then
      Strings[index]=Strings[index]..ReaperString:sub(i,i)
    end
  end
  return #Strings, Strings
end