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
-- That way, you can help making it more stable without being dependent on me, while I'm busy working on new features.
--
-- If you have new functions to contribute, you can use this file as well. Keep in mind, that I will probably change them to work
-- with the error-messaging-system as well as adding information for the API-documentation.
ultraschall.hotfixdate="14th_August_2019"

--ultraschall.ShowLastErrorMessage()

function ultraschall.GetUserInputs(title, caption_names, default_retvals, values_length, caption_length, x_pos, y_pos)
--TODO: when there are newlines in captions, count them and resize these captions automatically, as well as move down the following captions and inputfields, so they
--      match the captionheights, without interfering into each other.
--      will need resizing of the window as well and moving OK and Cancel-buttons
--      if a caption ends with a newline, it will get the full width of the window, with the input-field moving one down, getting full length as well

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUserInputs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.980
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer number_of_inputfields, table returnvalues = ultraschall.GetUserInputs(string title, table caption_names, table default_retvals, optional integer values_length, optional integer caption_length, optional integer x_pos, optional integer y_pos)</functioncall>
  <description>
    Gets inputs from the user.
    
    The captions and the default-returnvalues must be passed as an integer-index table.
    e.g.
      caption_names[1]="first caption name"
      caption_names[2]="second caption name"
      caption_names[1]="*third caption name, which creates an inputfield for passwords, due the * at the beginning"
      
   The number of entries in the tables "caption_names" and "default_retvals" decide, how many inputfields are shown. Maximum is 16 inputfields.
   You can safely pass "" as entry for a name, if you don't want to set it.
      
      The following example shows an input-dialog with three fields, where the first two the have default-values:
      
        retval, number_of_inputfields, returnvalues = ultraschall.GetUserInputs("I am the title", {"first", "second", "third"}, {1,"two"})   
     
   Note: Don't use this function within defer-scripts or scripts that are started by defer-scripts, as this produces errors.
         This is due limitations in Reaper, sorry.

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
                        - it can be up to 16 fields
                        - This dialog only allows limited caption-field-length, about 19-30 characters, depending on the size of the used characters.
                        - Don't enter nil as captionname, as this will be seen as end of the table by this function, omitting possible following captionnames!
    table default_retvals - a table with all default retvals. All non-string-entries will be converted to string-entries.
                          - it can be up to 16 fields
                          - Only enter nil as default-retval, if no further default-retvals are existing, otherwise use "" for empty retvals.
    optional integer values_length - the extralength of the values-inputfield. With that, you can enhance the length of the inputfields. 
                            - 1-500
    optional integer caption_length - the length of the caption in pixels; inputfields and OK, Cancel-buttons will be moved accordingly.
    optional integer x_pos - the x-position of the GetUserInputs-dialog; nil, to keep default position
    optional integer y_pos - the y-position of the GetUserInputs-dialog; nil, to keep default position
                           - keep in mind: on Mac, the y-position starts with 0 at the bottom, while on Windows and Linux, 0 starts at the top of the screen!
                           -               this is the standard-behavior of the operating-systems themselves.
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
  local count33, autolength
  if type(title)~="string" then ultraschall.AddErrorMessage("GetUserInputs", "title", "must be a string", -1) return false end
  if type(caption_names)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be a table", -2) return false end
  if type(default_retvals)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be a table", -3) return false end
  if values_length~=nil and math.type(values_length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be an integer", -4) return false end
  if values_length==nil then values_length=10 end
  if (values_length>500 or values_length<1) and values_length~=-1 then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be between 1 and 500, or -1 for autolength", -5) return false end
  if values_length==-1 then values_length=1 autolength=true end
  local count = ultraschall.CountEntriesInTable_Main(caption_names)
  local count2 = ultraschall.CountEntriesInTable_Main(default_retvals)
  if count>16 then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be no more than 16 caption-names!", -5) return false end
  if count2>16 then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be no more than 16 default-retvals!", -6) return false end
  if count2>count then count33=count2 else count33=count end
  values_length=(values_length*2)+18
 
  if x_pos~=nil and math.type(x_pos)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "x_pos", "must be an integer or nil!", -7) return false end
  if y_pos~=nil and math.type(y_pos)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "y_pos", "must be an integer or nil!", -8) return false end
  if x_pos==nil then x_pos="keep" end
  if y_pos==nil then y_pos="keep" end
  
  if caption_length~=nil and math.type(caption_length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "caption_length", "must be an integer or nil!", -9) return false end
  if caption_length==nil then caption_length="keep" end
  
  local captions=""
  local retvals=""  
  
  for i=1, count2 do
    if default_retvals[i]==nil then default_retvals[i]="" end
    retvals=retvals..tostring(default_retvals[i])..","
    if autolength==true and values_length<tostring(default_retvals[i]):len() then values_length=(tostring(default_retvals[i]):len()*6.6)+18 end
  end
  retvals=retvals:sub(1,-2)  
  
  for i=1, count do
    if caption_names[i]==nil then caption_names[i]="" end
    captions=captions..tostring(caption_names[i])..","
    --if autolength==true and length<tostring(caption_names[i]):len()+length then length=(tostring(caption_names[i]):len()*16.6)+18+length end
  end
  captions=captions:sub(1,-2)
  if count<count2 then
    for i=count, count2 do
      captions=captions..","
    end
  end
  captions=captions..",extrawidth="..values_length
  
  --print2(captions)
  -- fill up empty caption-names, so the passed parameters are 16 in count
  for i=1, 16 do
    if caption_names[i]==nil then
      caption_names[i]=""
    end
  end
  caption_names[17]=nil

  -- fill up empty default-values, so the passed parameters are 16 in count  
  local default_retvals2={}
  for i=1, 16 do
    if default_retvals[i]==nil then
      default_retvals2[i]=""
    else
      default_retvals2[i]=default_retvals[i]
    end
  end
  default_retvals2[17]=nil

  local numentries, concatenated_table = ultraschall.ConcatIntegerIndexedTables(caption_names, default_retvals2)
  
  local temptitle="Tudelu"..reaper.genGuid()
  
  ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/GetUserInputValues_Helper_Script.lua", temptitle, title, 3, x_pos, y_pos, caption_length, "Tudelu", table.unpack(concatenated_table))

  local retval, retvalcsv = reaper.GetUserInputs(temptitle, count33, captions, "")
  if retval==false then reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false) return false end
  local Values=reaper.GetExtState(ultraschall.ScriptIdentifier, "values")
  --print2(Values)
  reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false)
  local count2,Values=ultraschall.CSV2IndividualLinesAsArray(Values ,"\n")
  for i=count+1, 17 do
    Values[i]=nil
  end
  return retval, count33, Values
end

--A,B,C,D=ultraschall.GetUserInputs("I got you", {"ShalalalaOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOHAH"}, {"HHHAAAAHHHHHHHHHHHHHHHHHHHHHHHHAHHHHHHHA"}, -1)

function ultraschall.CountUSExternalState_sec()
--count number of sections in the ultraschall.ini
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountUSExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer section_count = ultraschall.CountUSExternalState_sec()</functioncall>
  <description>
    returns the number of [sections] in the ultraschall.ini
  </description>
  <retvals>
    integer section_count  - the number of section in the ultraschall.ini
  </retvals>
  <chapter_context>
    Ultraschall Specific
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>configurationmanagement, count, section</tags>
</US_DocBloc>

--]]
  -- check existence of ultraschall.ini
  if reaper.file_exists(reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")==false then ultraschall.AddErrorMessage("CountUSExternalState_sec","", "ultraschall.ini does not exist", -1) return -1 end
  
  -- count external-states
  local count=0
  for line in io.lines(reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini") do
    --local check=line:match(".*=.*")
    check=line:match("%[.*.%]")
    if check~=nil then check="" count=count+1 end
  end
  return count
end

function ultraschall.CountIniFileExternalState_sec(ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountIniFileExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer sectioncount = ultraschall.CountIniFileExternalState_sec(string ini_filename_with_path)</functioncall>
  <description>
    Count external-state-[sections] from an ini-configurationsfile.
    
    Returns -1, if the file does not exist.
  </description>
  <retvals>
    integer sectioncount - number of sections within an ini-configuration-file
  </retvals>
  <parameters>
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>configurationmanagement, count, sections, ini-files</tags>
</US_DocBloc>
]]
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountIniFileExternalState_sec", "ini_filename_with_path", "File does not exist.", -1) return -1 end
  local count=0
  
  for line in io.lines(ini_filename_with_path) do
    --local check=line:match(".*=.*")
    check=line:match("%[.*.%]")
    if check~=nil then check="" count=count+1 end
  end
  return count
end

function ultraschall.EnumerateIniFileExternalState_sec(number_of_section, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateIniFileExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string sectionname = ultraschall.EnumerateIniFileExternalState_sec(integer number_of_section, string ini_filename_with_path)</functioncall>
  <description>
    Returns the numberth section in an ini_filename_with_path.
    
    Returns nil, in case of an error.
  </description>
  <retvals>
    string sectionname - the name of the numberth section in the ini-file
  </retvals>
  <parameters>
    integer number_of_section - the section within the ini-filename; 1, for the first section
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>configurationmanagement, get, section, enumerate, ini-files</tags>
</US_DocBloc>
]]
  if math.type(number_of_section)~="integer" then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_sec", "number_of_section", "Must be an integer.", -1) return nil end
  if type(ini_filename_with_path)~="string" then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_sec", "ini_filename_with_path", "Must be a string.", -2) return nil end

  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_sec", "ini_filename_with_path", "File does not exist.", -3) return nil end
  
  if number_of_section<=0 then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_sec", "ini_filename_with_path", "No such section.", -4) return nil end
  if number_of_section>ultraschall.CountIniFileExternalState_sec(ini_filename_with_path) then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_sec", "ini_filename_with_path", "No such section.", -5) return nil end
  
  local count=0
  for line in io.lines(ini_filename_with_path) do
    --local check=line:match(".*=.*")
    check=line:match("%[.*.%]")
    if check==nil then count=count+1 end
    if count==number_of_section then return line:sub(2,-2) end
  end
end


function ultraschall.EnumerateUSExternalState_sec(number)
-- returns name of the numberth section in ultraschall.ini or nil, if invalid
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateUSExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string section_name = ultraschall.EnumerateUSExternalState_sec(integer number)</functioncall>
  <description>
    returns name of the numberth section in ultraschall.ini or nil if invalid
  </description>
  <retvals>
    string section_name  - the name of the numberth section within ultraschall.ini
  </retvals>
  <parameters>
    integer number - the number of section, whose name you want to know
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ultraschall.ini
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>configurationmanagement, enumerate, section</tags>
</US_DocBloc>
--]]
  -- check parameter and existence of ultraschall.ini
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec", "number", "only integer allowed", -1) return false end
  if reaper.file_exists(reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini")==false then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec", "", "ultraschall.ini does not exist", -2) return -1 end

  if number<=0 then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","number", "no negative number allowed", -3) return nil end
  if number>ultraschall.CountUSExternalState_sec() then ultraschall.AddErrorMessage("EnumerateUSExternalState_sec","number", "only "..ultraschall.CountUSExternalState_sec().." sections available", -4) return nil end

  -- look for and return the requested line
  local count=0
  for line in io.lines(reaper.GetResourcePath()..ultraschall.Separator.."ultraschall.ini") do
    local check=line:match("%[.-%]")
    if check~=nil then count=count+1 end
    if count==number then return line:sub(2,-2) end
  end
end 


