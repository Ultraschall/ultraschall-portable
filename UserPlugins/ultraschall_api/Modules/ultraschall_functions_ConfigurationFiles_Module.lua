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
---  Configuration-Files  Module  ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "ConfFiles-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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



function ultraschall.SetIniFileExternalState(section, key, value, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetIniFileExternalState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetIniFileExternalState(string section, string key, string value, string ini_filename_with_path)</functioncall>
  <description>
    Sets an external state into ini_filename_with_path. Returns false, if it doesn't work.
  </description>
  <retvals>
    boolean retval - true, if setting the state was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    string section - section of the external state. No = allowed!
    string key - key of the external state. No = allowed!
    string value - value for the key
    string filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, set, external state, value, ini-files</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("SetIniFileExternalState", "section", "must be a string.", -1) return false end
  if type(key)~="string" then ultraschall.AddErrorMessage("SetIniFileExternalState", "key", "must be a string.", -2) return false end
  if type(value)~="string" then ultraschall.AddErrorMessage("SetIniFileExternalState", "value", "must be a string.", -3) return false end
  if type(ini_filename_with_path)~="string" then ultraschall.AddErrorMessage("SetIniFileExternalState", "ini_filename_with_path", "must be a string.", -4) return false end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("SetIniFileExternalState", "ini_filename_with_path", "file can't be accessed.", -5) return false end
  if section:match(".*%=.*") then ultraschall.AddErrorMessage("SetIniFileExternalState", "section", "= is not allowed in section", -6) return false end
  if key:match(".*%=.*") then ultraschall.AddErrorMessage("SetIniFileExternalState", "key", "= is not allowed in key.", -7) return false end

  return ultraschall.SetIniFileValue(section, key, value, ini_filename_with_path)
end

function ultraschall.GetIniFileExternalState(section, key, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetIniFileExternalState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string value = ultraschall.GetIniFileExternalState(string section, string key, string ini_filename_with_path)</functioncall>
  <description>
    Gets an external state from ini_filename_with_path. Returns -1, if the file does not exist or parameters are invalid.
  </description>
  <retvals>
    integer entrylength - the length of the returned value
    string value - the value stored in a section->key in a configuration-file
  </retvals>
  <parameters>
    string section - section of the external state
    string key - key of the external state. No = allowed!
    string filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, get, external state, value, ini-files</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("GetIniFileExternalState","section", "must be a string", -1) return -1 end
  if type(key)~="string" then ultraschall.AddErrorMessage("GetIniFileExternalState","key", "must be a string", -2) return -1 end
  if type(ini_filename_with_path)~="string" then ultraschall.AddErrorMessage("GetIniFileExternalState","ini_filename_with_path", "must be a string", -3) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("GetIniFileExternalState","ini_filename_with_path", "file does not exist", -4) return -1 end
    
  local L,LL=ultraschall.GetIniFileValue(section, key, "", ini_filename_with_path)
  if L==nil then ultraschall.AddErrorMessage("GetIniFileExternalState","key", "does not exist", -5) return -1
  else
  return L,LL
  end
end

function ultraschall.CountIniFileExternalState_sec(ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountIniFileExternalState_sec</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, count, sections, ini-files</tags>
</US_DocBloc>
]]
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountIniFileExternalState_sec", "ini_filename_with_path", "File does not exist.", -1) return -1 end
  local count=0
  
  for line in io.lines(ini_filename_with_path) do
    --local check=line:match(".*=.*")
    local check=line:match("%[.*.%]")
    if check~=nil then check="" count=count+1 end
  end
  return count
end

function ultraschall.CountIniFileExternalState_key(section, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountIniFileExternalState_key</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer keyscount = ultraschall.CountIniFileExternalState_key(string section, string ini_filename_with_path)</functioncall>
  <description>
    Count external-state-keys within a specific section, in a ini_filename_with_path.
    
    Returns -1, if file does not exist.
  </description>
  <retvals>
    integer keyscount - number of keys with section within an ini-configuration-file
  </retvals>
  <parameters>
    string section - the section within the ini-filename
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, count, keys, ini-files</tags>
</US_DocBloc>
]]
  local count=0
  local startcount=0
  if type(section)~="string" then ultraschall.AddErrorMessage("CountIniFileExternalState_key", "section", "Must be a string.", -1) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountIniFileExternalState_key", "ini_filename_with_path", "File does not exist.", -2) return -1 end
    
  for line in io.lines(ini_filename_with_path) do
   local check=line:match("%[.*.%]")
    if startcount==1 and line:match(".*=.*") then
      count=count+1
    else
      startcount=0
    if "["..section.."]" == check then startcount=1 end
    if check==nil then check="" end
    end
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
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
    local check=line:match("%[(.*).%]")
    if check~=nil then count=count+1 end
    if count==number_of_section then return line:sub(2,-2) end
  end
end

function ultraschall.EnumerateIniFileExternalState_key(section, number, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateIniFileExternalState_key</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string keyname = ultraschall.EnumerateIniFileExternalState_key(string section, integer number, string ini_filename_with_path)</functioncall>
  <description>
    Returns the numberth key within a section in an ini_filename_with_path.
    
    Returns nil, in case of an error.
  </description>
  <retvals>
    string keyname - the name of the numberth key within section in the ini-file
  </retvals>
  <parameters>
    string section - the name of the section
    integer number - the number of the key within a section within the ini-filename, with 1 for the first key in the section
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, get, key, enumerate, ini-files</tags>
</US_DocBloc>
]]
  if type(section)~="string" then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_key", "section", "Must be a string.", -1) return nil end
  if math.type(number)~="integer" then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_key", "number", "Must be an integer.", -2) return nil end

  if type(ini_filename_with_path)~="string" then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_key", "ini_filename_with_path", "Must be a string.", -3) return nil end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("EnumerateIniFileExternalState_key", "ini_filename_with_path", "File does not exist.", -4) return nil end

  local count=0
  local startcount=0
  
  for line in io.lines(ini_filename_with_path) do
    local check=line:match("%[.*.%]")
    if startcount==1 and line:match(".*=.*") then
      count=count+1
      if count==number then local temp=line:match(".*=") return temp:sub(1,-2) end
    else
      startcount=0
      if "["..section.."]" == check then startcount=1 end
      if check==nil then check="" end
    end
  end
  return nil
end

function ultraschall.CountSectionsByPattern(pattern, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountSectionsByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_sections, string sectionnames = ultraschall.CountSectionsByPattern(string pattern, string ini_filename_with_path)</functioncall>
  <description>
    Counts the number of sections within an ini-file, that fit a specific pattern.
    
    Uses "pattern"-string to determine, how often a section with a certain pattern exists. Good for sections, that have a number in them, like [section1], [section2], [section3].
    Returns the number of sections, that include that pattern as well as a string, that includes the names of all such sections, separated by a comma.
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns -1, in case of an error.
  </description>
  <retvals>
    integer number_of_sections - the number of sections, that fit the pattern
    string sectionnames - a string, like: [section1],[section8],[section99]
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, count, sections, pattern, get, ini-files</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("CountSectionsByPattern", "pattern", "must be a string", -1) return -1 end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("CountSectionsByPattern", "ini_filename_with_path", "must be a string", -2) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountSectionsByPattern", "ini_filename_with_path", "file does not exist", -3) return -1 end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("CountSectionsByPattern", "pattern", "malformed pattern", -4) return -1 end
  
  local count=0
  local sections=""
  for line in io.lines(ini_filename_with_path) do
    if line:match("%[.*"..pattern..".*%]") then count=count+1 sections=sections..line:match("(%[.*"..pattern..".*%])").."," end
  end
  return count, sections:sub(1,-2)
end


function ultraschall.CountKeysByPattern(pattern, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountKeysByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_keys, string sections_and_keys = ultraschall.CountKeysByPattern(string pattern, string ini_filename_with_path)</functioncall>
  <description>
    Counts the number of keys within an ini-file, that fit a specific pattern.
    
    Uses "pattern"-string to determine, how often a key with a certain pattern exists. Good for keys, that have a number in them, like key1, key2, key3.
    Returns the number of keys, that include the pattern, as well as a string with all [sections] that contain keys= with a pattern, separated by a , i.e. [section1],key1=,key2=,key3=,[section2],key1=,key4=
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns -1, in case of an error.
  </description>
  <retvals>
    integer number_of_keys - the number of keys, that fit the pattern
    string sections_and_keys - a string, like: [section1],Key1=,Key2=,Key3=[section2],Key7=
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, count, keys, pattern, get, ini-files</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("CountKeysByPattern", "pattern", "must be a string", -1) return -1 end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("CountKeysByPattern", "ini_filename_with_path", "must be a string", -2) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountKeysByPattern", "ini_filename_with_path", "file does not exist", -3) return -1 end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("CountKeysByPattern", "pattern", "malformed pattern", -4) return -1 end
  
  local retpattern=""
  local count=0
  local tiff=0
  local temppattern=nil
  for line in io.lines(ini_filename_with_path) do
    if line:match("%[.*%]") then temppattern=line tiff=1 end--:match("%[(.*)%]") tiff=1 end-- reaper.MB(temppattern,"",0) end
    if line:match("%[.*%]")==nil and line:match(pattern..".*=") then count=count+1 
        if tiff==1 then retpattern=retpattern..temppattern.."," end 
        retpattern=retpattern..line:match(".*"..pattern..".*=")..","
        tiff=0 
    end
  end
  return count, retpattern:sub(1,-2)
end

--A,AA=ultraschall.CountKeysByPattern("","c:\\test.ini")


function ultraschall.CountValuesByPattern(pattern, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountValuesByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer number_of_values, string sections_and_keys = ultraschall.CountValuesByPattern(string pattern, string ini_filename_with_path)</functioncall>
  <description>
    Counts the number of values within an ini-file, that fit a specific pattern.
    
    Uses "pattern"-string to determine, how often a value with a certain pattern exists. Good for values, that have a number in them, like value1, value2, value3
    Returns the number of values, that include that pattern as well as a string, that contains the [sections] and the keys= and values , the latter that contain the pattern, separated by a comma
     e.g. [section1], key1=, value, key4=, value, [section4], key2=, value
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns -1, in case of an error.
  </description>
  <retvals>
    integer number_of_values - the number of values, that fit the pattern
    string sections_keys_values - a string, like: [section1],key1=,value,key4=,value,[section4],key2=,value
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, count, values, pattern, get, ini-files</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("CountValuesByPattern", "pattern", "must be a string", -1) return -1 end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("CountValuesByPattern", "ini_filename_with_path", "must be a string", -2) return -1 end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("CountValuesByPattern", "ini_filename_with_path", "file does not exist", -3) return -1 end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("CountValuesByPattern", "pattern", "malformed pattern", -4) return -1 end
  
  local retpattern=""
  local count=0
  local tiff=0
  local temppattern=nil
  for line in io.lines(ini_filename_with_path) do
    if line:match("%[.-%]")~=nil then temppattern=line end
    if line:match(".-=")~=nil then
        local A,B=line:match("(.-)=(.*)")
        if B:match(pattern)~=nil then
            count=count+1
            retpattern=retpattern..","..temppattern..","..A.."=,"..B
        end
    end
  end

  return count, retpattern:sub(2,-1)
end

function ultraschall.EnumerateSectionsByPattern(pattern, id, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateSectionsByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string sectionname = ultraschall.EnumerateSectionsByPattern(string pattern, integer id, string ini_filename_with_path)</functioncall>
  <description>
    Returns the numberth section within an ini-file, that fits the pattern, e.g. the third section containing "hawaii" in it.
    
    Uses "pattern"-string to determine if a section contains a certain pattern. Good for sections, that have a number in them, like section1, section2, section3
    Returns the section that includes that pattern as a string, numbered by id.
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns nil, in case of an error.
  </description>
  <retvals>
    string sectionname - a string, that contains the sectionname
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    integer id - the number of section, that contains pattern
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, enumerate, section, pattern, get, ini-files</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("EnumerateSectionsByPattern", "pattern", "must be a string", -1) return end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("EnumerateSectionsByPattern", "ini_filename_with_path", "must be a string", -2) return end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("EnumerateSectionsByPattern", "ini_filename_with_path", "file does not exist", -3) return end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EnumerateSectionsByPattern", "id", "must be an integer", -4) return end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("EnumerateSectionsByPattern", "pattern", "malformed pattern", -5) return end
  
  local count=0
  for line in io.lines(ini_filename_with_path) do
    if line:match("%[.*"..pattern..".*%]") then count=count+1 end
    if count==id then return line:match("%[(.*"..pattern..".*)%]") end
  end
  return nil
end

--A,AA=ultraschall.EnumerateSectionsByPattern("hu",2,"c:\\test.ini")

function ultraschall.EnumerateKeysByPattern(pattern, section, id, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateKeysByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string keyname = ultraschall.EnumerateKeysByPattern(string pattern, string section, integer id, string ini_filename_with_path)</functioncall>
  <description>
    Returns the numberth key within a section in an ini-file, that fits the pattern, e.g. the third key containing "hawaii" in it.
    
    Uses "pattern"-string to determine if a key contains a certain pattern. Good for keys, that have a number in them, like key1=, key2=, key3=
    Returns the key that includes that pattern as a string, numbered by id.
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns nil, in case of an error.
  </description>
  <retvals>
    string keyname - a string, that contains the keyname
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string section - the section, in which to look for the key
    integer id - the number of key, that contains pattern
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, ini-files, enumerate, section, key, pattern, get</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("EnumerateKeysByPattern", "pattern", "must be a string", -1) return end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("EnumerateKeysByPattern", "ini_filename_with_path", "must be a string", -2) return end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("EnumerateKeysByPattern", "ini_filename_with_path", "file does not exist", -3) return end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EnumerateKeysByPattern", "id", "must be an integer", -4) return end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("EnumerateKeysByPattern", "pattern", "malformed pattern", -5) return end
  
  local count=0
  local tiff=0
  local temppattern=nil
  for line in io.lines(ini_filename_with_path) do
    if tiff==1 and line:match("%[.*%]")~=nil then return nil end
    if line:match(section) then temppattern=line tiff=1 end
    if tiff==1 and line:match(pattern..".*=") then count=count+1 
        if count==id then return line:match("(.*"..pattern..".*)=") end
    end
  end
end

--A=ultraschall.EnumerateKeysByPattern("l","hula",3,"c:\\test.ini")

function ultraschall.EnumerateValuesByPattern(pattern, section, id, ini_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>EnumerateValuesByPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>string value, string keyname = ultraschall.EnumerateValuesByPattern(string pattern, string section, string id, string ini_filename_with_path)</functioncall>
  <description>
    Returns the numberth value(and it's accompanying key) within a section in an ini-file, that fits the pattern, e.g. the third value containing "hawaii" in it.
    
    Uses "pattern"-string to determine if a value contains a certain pattern. Good for values, that have a number in them, like value1, value2, value3
    Returns the value that includes that pattern as a string, numbered by id, as well as it's accompanying key.
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    Returns nil, in case of an error.
  </description>
  <retvals>
    string value - the value that contains the pattern
    string keyname - a string, that contains the keyname
  </retvals>
  <parameters>
    string pattern - the pattern itself. Case sensitive.
    string section - the section, in which to look for the key
    integer id - the number of key, that contains pattern
    string ini_filename_with_path - filename of the ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Ini-Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, ini-files, enumerate, section, key, value, pattern, get</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("EnumerateValuesByPattern", "pattern", "must be a string", -1) return end
  if ini_filename_with_path==nil then ultraschall.AddErrorMessage("EnumerateValuesByPattern", "ini_filename_with_path", "must be a string", -2) return end
  if reaper.file_exists(ini_filename_with_path)==false then ultraschall.AddErrorMessage("EnumerateValuesByPattern", "ini_filename_with_path", "file does not exist", -3) return end
  if math.type(id)~="integer" then ultraschall.AddErrorMessage("EnumerateValuesByPattern", "id", "must be an integer", -4) return end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("EnumerateValuesByPattern", "pattern", "malformed pattern", -5) return end
  
  local count=0
  local tiff=0
  local temppattern=nil
  for line in io.lines(ini_filename_with_path) do
    if tiff==1 and line:match("%[.*%]")~=nil then return nil end
    if line:match(section) then temppattern=line tiff=1 end
    if tiff==1 and line:match("=.*"..pattern..".*") then count=count+1 
        if count==id then return line:match("=(.*"..pattern..".*)"), line:match("(.*)=.*"..pattern..".*") end
    end
  end
end



function ultraschall.GetKBIniFilepath()
  -- returns file with path to the reaper-kb.ini-file

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniFilepath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string kb_ini_path = ultraschall.GetKBIniFilepath()</functioncall>
  <description>
    Returns the path and filename of the Reaper-kb.ini-file.
  </description>
  <retvals>
    string kb_ini_path - path and filename of the reaper-kb.ini
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get</tags>
</US_DocBloc>
]]  
  return reaper.GetResourcePath()..ultraschall.Separator.."reaper-kb.ini"
end

function ultraschall.CountKBIniActions(filename_with_path)

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountKBIniActions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer actions = ultraschall.CountKBIniActions(string filename_with_path)</functioncall>
  <description>
    Count the number of "ACT"-Actions of the Reaper-kb.ini-file.
    Returns -1, if no such file exists.
  </description>
<parameter>
string filename_with_path - path and filename of the reaper-kb.ini
</parameter>
  <retvals>
    integer actions - number of actions in the reaper-kb.ini
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, count, actions, action</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CountKBIniActions", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("CountKBIniActions", "filename_with_path", "file does not exist", -2) return -1 end
  local count=0
    for line in io.lines(filename_with_path) do 
      if line:sub(1,3)=="ACT" then 
        count=count+1
      end
    end
  if count>0 then return count
  else return -1
  end
end

function ultraschall.CountKBIniScripts(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountKBIniScripts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer scripts = ultraschall.CountKBIniScripts(string filename_with_path)</functioncall>
  <description>
    Count the number of "SCR"-Scripts of the Reaper-kb.ini-file.
    Returns -1, if no such file exists.
  </description>
<parameter>
string filename_with_path - path and filename of the reaper-kb.ini
</parameter>
  <retvals>
    integer scripts - number of scripts in the reaper-kb.ini
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, count, scripts, script</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CountKBIniScripts", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("CountKBIniScripts", "filename_with_path", "file does not exist", -2) return -1 end
  local count=0
    for line in io.lines(filename_with_path) do 
      if line:sub(1,3)=="SCR" then 
        count=count+1
      end
    end
  if count>0 then return count
  else return -1
  end
end

function ultraschall.CountKBIniKeys(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountKBIniKeys</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer keys = ultraschall.CountKBIniKeys(string filename_with_path)</functioncall>
  <description>
    Count the number of "KEY"-Keybindings of the Reaper-kb.ini-file.
    Returns -1, if no such file exists.
  </description>
<parameter>
string filename_with_path - path and filename of the reaper-kb.ini
</parameter>
  <retvals>
    integer keys - number of keys in the reaper-kb.ini
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, count, keys, key</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CountKBIniKeys", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("CountKBIniKeys", "filename_with_path", "file does not exist", -2) return -1 end
  local count=0
    for line in io.lines(filename_with_path) do 
      if line:sub(1,3)=="KEY" then 
        count=count+1
      end
    end
  if count>0 then return count
  else return -1
  end
end

function ultraschall.GetKBIniActions(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniActions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer consolidate, integer section, string ActionCommandID, string description, string ActionsToBeExecuted = ultraschall.GetKBIniActions(string filename_with_path, integer idx)</functioncall>
  <description>
    Get the states of "ACT"-Action number idx. Returns consolidate, section, ActionCommandID, description, ActionsToBeExecuted.
    Returns -1, if no such entry or file exists.
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    integer idx - the number of the action to get, beginning with 1 for the first one
  </parameters>
  <retvals>
    integer consolidate - consolidate-state
    -1 consolidate undo points, 
    -2 show in Actions-Menu, 
    -3 consolidate undo points AND show in Actions Menu; 
    -maybe 4 and higher?
    
    integer section - the section, in which this action is executed
    -0 - Main
    -1 - action stays invisible but is kept, if Reaper rewrites the reaper-kb.ini. Menu-buttons with this action associated appear but don't work.
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
    
    string ActionCommandID - the ActionCommandID given to this Action
    string description - the description of this action
    string ActionsToBeExecuted - the actions that are run, the ActionCommandIDs beginning with _, multiple ActionCommandIDs are separated by whitespaces
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, actions, action</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniActions", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniActions", "filename_with_path", "file does not exist", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetKBIniActions", "idx", "must be an integer", -3) return -1 end

  local count=0
  for line in io.lines(filename_with_path) do 
    if line:sub(1,3)=="ACT" then count=count+1 
      if count==idx then 
        return tonumber(line:match("%s(.-)%s")), -- consolidate
           tonumber(line:match("%s.-%s(.-)%s")), -- section
           line:match("%s.-%s.-%s(.-)%s"), -- ActionCommandID
           line:match("%s.-%s.-%s.-%s\"(.-)\"%s"), -- Description
           line:match("%s.-%s.-%s.-%s\".-\"%s(.*)") -- Actions
      end
    end
  end
  return -1
end

--A,AA,AAA,AAAA,AAAAA=ultraschall.GetKBIniActions("c:\\test.txt",35)

function ultraschall.GetKBIniScripts(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniScripts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer terminateinstance, integer section, string ActionCommandID, string description, string scriptfile = ultraschall.GetKBIniScripts(string filename_with_path, integer idx)</functioncall>
  <description>
    Get the states of "SCR"-Scripts number idx. Returns terminateinstance, section, ActionCommandID, description, scriptfile.
    Returns -1, if no such entry or file exists.
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    integer idx - the number of the action to get, beginning with 1 for the first one
  </parameters>
  <retvals>
    integer terminateinstance - the state of terminating instances
    -4 - Dialogwindow appears(Terminate, New Instance, Abort), if another instance of a given script is started, that's already running
    -260 - always Terminate Instances, when an instance of the script is already running
    -516 - always start a New Instance of the script already running
    
    integer section - the section, in which this action is executed
    -0 - Main
    -1 - action stays invisible but is kept, if Reaper rewrites the reaper-kb.ini. Menu-buttons with this action associated appear but don't work.
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
    
    string ActionCommandID - the ActionCommandID given to this Action
    string description - the description of this action
    string scriptfile - the filename of the script that shall be run
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, scripts, script</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniScripts", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniScripts", "filename_with_path", "file does not exist", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetKBIniScripts", "idx", "must be an integer", -3) return -1 end
  
  local count=0
  for line in io.lines(filename_with_path) do 
    if line:sub(1,3)=="SCR" then count=count+1 
      if count==idx then 
        return tonumber(line:match("%s(.-)%s")), 
               tonumber(line:match("%s.-%s(.-)%s")),
               line:match("%s.-%s.-%s(.-)%s"), -- ActionCommandID
               line:match("%s.-%s.-%s.-%s\"(.-)\"%s"),
               line:match("%s.-%s.-%s.-%s\".-\"%s(.*)")
      end
    end
  end
  return -1
end

--A,AA,AAA,AAAA,AAAAA=ultraschall.GetKBIniScripts(ultraschall.GetKBIniFilepath(),165)

function ultraschall.GetKBIniKeys(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniKeys</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer keytype_modifier_midichan, integer key_midinote, string ActionCommandID, integer section = ultraschall.GetKBIniKeys(string filename_with_path, integer idx)</functioncall>
  <description>
    Get the states of "KEY"-Keybinding-number idx, for MIDI/Key-bindings. Returns keytype_modifier_midichan, key_midinote, ActionCommandID, section.
    
    For a detailed description in how KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    
    Returns -1, if no such entry or file exists.
    Does not return OSC-keybindings, as they are stored in OSC/reaper-osc-actions.ini !
    returns -1 in case of an error
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    integer idx - the number of the action to get, beginning with 1 for the first one
  </parameters>
  <retvals>
    integer keytype_modifier_midichan - Type of Keytype, modifier or midichannel
                                      - For a detailed description in how keytype/modifier in KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    integer key_midinote - the key(like ASCII-Codes) or midinote. 
                                      - For a detailed description in how key/midinotes in KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    
    string ActionCommandID - the ActionCommandID associated with this shortcut.
    integer section - the section, in which this shortcut is used
    -0 - Main
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, keys, key</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniKeys", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniKeys", "filename_with_path", "file does not exist", -2) return -1 end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("GetKBIniKeys", "idx", "must be an integer", -3) return -1 end
  
  local count=0
  for line in io.lines(filename_with_path) do 
    if line:sub(1,3)=="KEY" then count=count+1 
      if count==idx then 
        return tonumber(line:match("%s(.-)%s")), 
               tonumber(line:match("%s.-%s(.-)%s")),
               line:match("%s.-%s.-%s(.-)%s"),
               tonumber(line:match("%s.-%s.-%s.-%s(.*)"))
      end
    end
  end
  return -1
end

--A,AA,AAA,AAAA,AAAAA=ultraschall.GetKBIniKeys(ultraschall.GetKBIniFilepath(),103)

function ultraschall.GetKBIniActionsID_ByActionCommandID(filename_with_path, ActionCommandID)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniActionsID_ByActionCommandID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string retval = ultraschall.GetKBIniActionsID_ByActionCommandID(filename_with_path, ActionCommandID)</functioncall>
  <description>
    Returns the indexnumber(s) of actions by ActionCommandIDs within a reaper-kb.ini.
    Returns -1, if no such entry or file exists.
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    string ActionCommandID - the ActionCommandID
  </parameters>
  <retvals>
    string retval - the ids of actions with ActionCommandID, separated by a ,
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, actions, action</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniActionsID_ByActionCommandID", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniActionsID_ByActionCommandID", "filename_with_path", "file does not exist", -2) return -1 end
  if ultraschall.CheckActionCommandIDFormat(ActionCommandID)==false then ultraschall.AddErrorMessage("GetKBIniActionsID_ByActionCommandID", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return -1 end
  
  local idx_string=""
  local consolidate, section, AID, Description, ActionsToBeExecuted
  for i=1, ultraschall.CountKBIniActions(filename_with_path)-1 do
    consolidate, section, AID, Description, ActionsToBeExecuted=ultraschall.GetKBIniActions(filename_with_path,i)
    if AID:sub(1,1)=="\"" then AID=AID:sub(2,-1) end
    if AID:sub(-1,-1)=="\"" then AID=AID:sub(1,-2) end
    if ActionCommandID==AID then idx_string=idx_string..i.."," end
  end
  return idx_string:sub(1,-2)
end

--A=ultraschall.GetKBIniActionsID_ByActionCommandID("c:\\test.txt","_Ultraschall_ZoomToSelection")

function ultraschall.GetKBIniScripts_ByActionCommandID(filename_with_path, ActionCommandID)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniScripts_ByActionCommandID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string retval = ultraschall.GetKBIniScripts_ByActionCommandID(filename_with_path, ActionCommandID)</functioncall>
  <description>
    Returns the indexnumber(s) of scripts by ActionCommandIDs within a reaper-kb.ini.
    Returns nil, if no such entry or file exists.
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    string ActionCommandID - the ActionCommandID
  </parameters>
  <retvals>
    string retval - the ids of scripts with ActionCommandID, separated by a ,
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, scripts, script</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniScripts_ByActionCommandID", "filename_with_path", "must be a string", -1) return end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniScripts_ByActionCommandID", "filename_with_path", "file does not exist", -2) return end
  if ultraschall.CheckActionCommandIDFormat(ActionCommandID)==false then ultraschall.AddErrorMessage("GetKBIniScripts_ByActionCommandID", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return end
  
  local idx_string=""
  local consolidate, section, AID, Description, ScriptFile
  for i=1, ultraschall.CountKBIniScripts(filename_with_path)-1 do
    consolidate, section, AID, Description, ScriptFile=ultraschall.GetKBIniScripts(filename_with_path,i)
    if AID:sub(1,1)=="\"" then AID=AID:sub(2,-1) end
    if AID:sub(-1,-1)=="\"" then AID=AID:sub(1,-2) end
    if ActionCommandID==AID then idx_string=idx_string..i.."," end
  end
  return idx_string:sub(1,-2)
end

--A=ultraschall.GetKBIniScripts_ByActionCommandID("c:\\test.txt", "Haselnuss") --

function ultraschall.GetKBIniKeys_ByActionCommandID(filename_with_path, ActionCommandID)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetKBIniKeys_ByActionCommandID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string retval = ultraschall.GetKBIniKeys_ByActionCommandID(filename_with_path, ActionCommandID)</functioncall>
  <description>
    Returns the indexnumber(s) of keys by ActionCommandIDs within a reaper-kb.ini.
    Returns nil, if no such entry or file exists.
  </description>
  <parameters>
    string filename_with_path - path and filename of the reaper-kb.ini
    string ActionCommandID - the ActionCommandID
  </parameters>
  <retvals>
    string retval - the ids of keys with ActionCommandID, separated by a ,
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, get, keys, key</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("GetKBIniKeys_ByActionCommandID", "filename_with_path", "must be a string", -1) return end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("GetKBIniKeys_ByActionCommandID", "filename_with_path", "file does not exist", -2) return end
  if ultraschall.CheckActionCommandIDFormat(ActionCommandID)==false then ultraschall.AddErrorMessage("GetKBIniKeys_ByActionCommandID", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return end
  
  local idx_string=""
  local Keytype, KeyNote, AID, section
  for i=1, ultraschall.CountKBIniKeys(filename_with_path)-1 do
    Keytype, KeyNote, AID, section=ultraschall.GetKBIniKeys(filename_with_path,i)
    if AID:sub(1,1)=="\"" then AID=AID:sub(2,-1) end
    if AID:sub(-1,-1)=="\"" then AID=AID:sub(1,-2) end
    if ActionCommandID==AID then idx_string=idx_string..i.."," end
  end
  return idx_string:sub(1,-2)
end

--A=ultraschall.GetKBIniKeys_ByActionCommandID("c:\\test.txt","40626")



function ultraschall.SetKBIniActions(filename_with_path, consolidate, section, ActionCommandID, Description, ActionCommandIDs, replace)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetKBIniActions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer actionnumber = ultraschall.SetKBIniActions(string filename_with_path, integer consolidate, integer section, string ActionCommandID, string Description, string ActionCommandIDs, boolean replace)</functioncall>
  <description>
    Adds or sets(if it already exists) an "ACT"-action of a reaper-kb.ini.
    Returns true/false when adding or setting worked/didn't work, as well as the action-number within the reaper-kb.ini
    
    Needs a restart of Reaper for this change to take effect!
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer consolidate - consolidation state of this action
    -1 consolidate undo points, 
    -2 show in Actions-Menu, 
    -3 consolidate undo points AND show in Actions Menu; 
    -maybe 4 and higher?
    
    integer section - section, in which this action is started
    -0 - Main
    -1 - action stays invisible but is kept, if Reaper rewrites the reaper-kb.ini. Menu-buttons with this action associated appear but don't work.
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
    
    string ActionCommandID - the ActionCommandID of this action
    string Description - a description for this action
    string ActionCommandIDs - the ActionCommandIDs for the actions, that are triggered by this action; unlike CommandID-numbers, every ActionCommandID must begin with _ ; will not be checked vor valid ones!
    boolean replace - true if an already existing entry shall be replaced, false if not
  </parameters>
  <retvals>
    boolean retval - true, if adding/setting worked, false if it didn't
    integer actionnumber - the entrynumber within the reaper-kb.ini of this action
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, add, set, replace, action, actions</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("SetKBIniActions", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("SetKBIniActions", "filename_with_path", "file does not exist", -2) return false end
  if type(ActionCommandID)~="string" then ultraschall.AddErrorMessage("SetKBIniActions", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return false end
  
  if math.type(consolidate)~="integer" then ultraschall.AddErrorMessage("SetKBIniActions", "consolidate", "must be an integer", -4) return false end 
  if math.type(section)~="integer" then ultraschall.AddErrorMessage("SetKBIniActions", "section", "must be an integer", -5) return false end 

  if type(Description)~="string" then ultraschall.AddErrorMessage("SetKBIniActions", "Description", "must be a string", -6) return false end 
  if type(ActionCommandIDs)~="string" then ultraschall.AddErrorMessage("SetKBIniActions", "ActionCommandIDs", "must be a string", -7) return false end 
  
  if type(replace)~="boolean" then ultraschall.AddErrorMessage("SetKBIniActions", "replace", "must be a boolean", -8) return false end 

  local contents, correctnumberoflines, number_of_lines = ultraschall.ReadFileAsLines_Array(filename_with_path, 1, -1) 
  local checkstring="ACT "..section.." \""..ActionCommandID.."\""
--  checkstring_len=checkstring:len()

  local found=0
  
  -- find the entrynumber of the action, if it's already existing
  for i=1, number_of_lines do
    local temp, temp2, temp3=contents[i]:match("(ACT) .- (.-) (.-) ")
    if temp~=nil then
      temp=temp.." "..temp2.." "..temp3
      if temp==checkstring then found=i break 
    end
    end    
  end
  
  -- if already existing and replace=true then replace it, otherwise return
  -- if it doesn't exist, add the entry before all other entries
  local newcontent=""
  if found~=0 and replace==true then
    contents[found]="ACT "..consolidate.." "..section.." \""..ActionCommandID.."\" \""..Description.."\" "..ActionCommandIDs
  elseif found~=0 and replace==false then ultraschall.AddErrorMessage("SetKBIniActions", "ActionCommandID", "ActionCommandID already exists; set replace=true to replace it", -9) return false
  else
    newcontent="ACT "..consolidate.." "..section.." \""..ActionCommandID.."\" \""..Description.."\" "..ActionCommandIDs.."\r\n"
  end

  -- Create string with all entries and write them to file
  for i=1, number_of_lines do
    newcontent=newcontent..contents[i].."\r\n"
  end
  ultraschall.WriteValueToFile(filename_with_path, newcontent)
  if found==0 then found=1 end
  
  return true, found
end

function ultraschall.SetKBIniScripts(filename_with_path, terminate_state, section, ActionCommandID, Description, Scriptname, replace)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetKBIniScripts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer scriptnumber = ultraschall.SetKBIniScripts(string filename_with_path, integer terminate, integer section, string ActionCommandID, string Description, string Scriptname, boolean replace)</functioncall>
  <description>
    Adds or sets(if it already exists) an "SCR"-script of a reaper-kb.ini.
    Returns true/false when adding or setting worked/didn't work, as well as the script-number within the reaper-kb.ini
    
    Needs a restart of Reaper for this change to take effect!
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer terminate_state - state of handling mulitple running scripts
    -4 - Dialogwindow appears(Terminate, New Instance, Abort), if another instance of a given script is started, that's already running
    -260 - always Terminate Instances, when an instance of the script is already running
    -516 - always start a New Instance of the script already running
    
    integer section - section, in which this script is started
    -0 - Main
    -1 - action stays invisible but is kept, if Reaper rewrites the reaper-kb.ini. Menu-buttons with this action associated appear but don't work.
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
    
    string ActionCommandID - the ActionCommandID of this action
    string Description - a description for this script
    string Scriptname - the name of the ReaScript, like .lua or .eel or .py
    boolean replace - true if an already existing entry shall be replaced, false if not
  </parameters>
  <retvals>
    boolean retval - true, if adding/setting worked, false if it didn't
    integer scriptnumber - the entrynumber within the reaper-kb.ini of this script
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, add, set, script, scripts, replace</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("SetKBIniScripts", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("SetKBIniScripts", "filename_with_path", "file does not exist", -2) return false end
  if type(ActionCommandID)~="string" then ultraschall.AddErrorMessage("SetKBIniScripts", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return false end
  
  if math.type(terminate_state)~="integer" then ultraschall.AddErrorMessage("SetKBIniScripts", "terminate_state", "must be an integer", -4) return false end 
  if math.type(section)~="integer" then ultraschall.AddErrorMessage("SetKBIniScripts", "section", "must be an integer", -5) return false end 

  if type(Description)~="string" then ultraschall.AddErrorMessage("SetKBIniScripts", "Description", "must be a string", -6) return false end 
  if type(Scriptname)~="string" then ultraschall.AddErrorMessage("SetKBIniScripts", "Scriptname", "must be a string", -7) return false end 
  
  if type(replace)~="boolean" then ultraschall.AddErrorMessage("SetKBIniScripts", "replace", "must be a boolean", -8) return false end 

  local contents, correctnumberoflines, number_of_lines = ultraschall.ReadFileAsLines_Array(filename_with_path, 1, -1) 
  local checkstring="SCR "..section.." "..ActionCommandID
--  checkstring_len=checkstring:len()

  local found=0
  
  -- find the entrynumber of the action, if it's already existing
  for i=1, number_of_lines do
    local temp, temp2, temp3=contents[i]:match("(SCR) .- (.-) (.-) ")
    if temp~=nil then
      temp=temp.." "..temp2.." "..temp3
      if temp==checkstring then found=i break 
    end
    end    
  end
  
  -- if already existing and replace=true then replace it, otherwise return
  -- if it doesn't exist, add the entry before all other entries
  local newcontent=""
  if found~=0 and replace==true then
    contents[found]="SCR "..terminate_state.." "..section.." "..ActionCommandID.." \""..Description.."\" "..Scriptname
  elseif found~=0 and replace==false then ultraschall.AddErrorMessage("SetKBIniScripts", "ActionCommandID", "ActionCommandID already exists; set replace=true to replace it", -9) return false
  else
    newcontent="SCR "..terminate_state.." "..section.." "..ActionCommandID.." \""..Description.."\" "..Scriptname.."\r\n"
  end

  -- Create string with all entries and write them to file
  for i=1, number_of_lines do
    newcontent=newcontent..contents[i].."\r\n"
  end
  ultraschall.WriteValueToFile(filename_with_path, newcontent)
  if found==0 then found=1 end
  
  return true, found
end

function ultraschall.SetKBIniKeys(filename_with_path, KeyType, KeyNote, ActionCommandID, section, replace)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetKBIniKeys</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer keynumber = ultraschall.SetKBIniKeys(string filename_with_path, integer keytype_modifier_midichan, integer key_midinote, string ActionCommandID, integer section, boolean replace)</functioncall>
  <description>
    Adds or sets(if it already exists) a "KEY"-key of a reaper-kb.ini.
    Returns true/false when adding or setting worked/didn't work, as well as the keybinding-number within the reaper-kb.ini.
    Additional keybindings cannot share the same keytype_modifier_midichan, key_midinote and section at the same time, as every such keybind must be unique.
    
    For a detailed description in how KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    
    Does not support OSC-keybindings, as they are stored in OSC/reaper-osc-actions.ini !
    
    Needs a restart of Reaper for this change to take effect!
    
    returns false in case of an error
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer keytype_modifier_midichan - Type of Keytype, modifier or midichannel
                                      - For a detailed description in how keytype/modifier in KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    integer key_midinote - the key(like ASCII-Codes) or midinote. 
                                      - For a detailed description in how key/midinotes in KEY-entries work, refer to <a href="Reaper-Filetype-Descriptions.html#Reaper-kb.ini">Reaper-Filetype-Descriptions.html#Reaper-kb.ini</a>.
    string ActionCommandID - the ActionCommandID associated with this shortcut.
    integer section - the section, in which this shortcut is used
    -0 - Main
    -100 - Main (alt recording)
    -32060 - MIDI Editor
    -32061 - MIDI Event List Editor
    -32062 - MIDI Inline Editor
    -32063 - Media Explorer
    
    boolean replace - true if an already existing entry shall be replaced, false if not
  </parameters>
  <retvals>
    boolean retval - true, if adding/setting worked, false if it didn't
    integer scriptnumber - the entrynumber within the reaper-kb.ini of this script
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, add, set, key, keys, replace</tags>
</US_DocBloc>
]]  

-- filename_with_path, KeyType, KeyNote, ActionCommandID, section, replace

  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("SetKBIniKeys", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("SetKBIniKeys", "filename_with_path", "file does not exist", -2) return false end
  if ultraschall.CheckActionCommandIDFormat(ActionCommandID)==false then ultraschall.AddErrorMessage("SetKBIniKeys", "ActionCommandID", "must be a valid ActionCommandID or CommandID", -3) return false end
  
  if math.type(KeyType)~="integer" then ultraschall.AddErrorMessage("SetKBIniKeys", "KeyType", "must be an integer", -4) return false end 
  if math.type(KeyNote)~="integer" then ultraschall.AddErrorMessage("SetKBIniKeys", "KeyNote", "must be an integer", -5) return false end 

  if math.type(section)~="integer" then ultraschall.AddErrorMessage("SetKBIniKeys", "section", "must be a string", -6) return false end 
  
  if type(replace)~="boolean" then ultraschall.AddErrorMessage("SetKBIniKeys", "replace", "must be a boolean", -7) return false end 

  local contents, correctnumberoflines, number_of_lines = ultraschall.ReadFileAsLines_Array(filename_with_path, 1, -1) 
  local checkstring="KEY "..KeyType.." "..KeyNote.." "..section

  local found=0
  
  -- find the entrynumber of the action, if it's already existing
  for i=1, number_of_lines do
    local temp, temp2, temp3, temp4 =contents[i]:match("(KEY) (.-) (.-) .- (.*)")
    if temp~=nil then
      temp=temp.." "..temp2.." "..temp3.." "..temp4
      if temp==checkstring then found=i break 
    end
    end    
  end
  
  -- if already existing and replace=true then replace it, otherwise return
  -- if it doesn't exist, add the entry before all other entries
  local newcontent=""
  local tempcontent=""
  if found~=0 and replace==true then
    contents[found]="KEY "..KeyType.." "..KeyNote.." "..ActionCommandID.." "..section
  elseif found~=0 and replace==false then ultraschall.AddErrorMessage("SetKBIniKeys", "KeyType, KeyNote and section", "entry already exists; set replace=true to replace it", -8) return false
  else
    tempcontent="KEY "..KeyType.." "..KeyNote.." "..ActionCommandID.." "..section.."\r\n"
  end

  -- Create string with all entries and write them to file
  for i=1, number_of_lines do
    newcontent=newcontent..contents[i].."\r\n"
  end
  ultraschall.WriteValueToFile(filename_with_path, newcontent..tempcontent)
  if found==0 then found=1 end
  
  return true, found
end


function ultraschall.DeleteKBIniActions(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteKBIniActions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteKBIniActions(string filename_with_path, integer idx)</functioncall>
  <description>
    Deletes an "ACT"-action of a reaper-kb.ini.
    Returns true/false when deleting worked/didn't work.
    
    Needs a restart of Reaper for this change to take effect!
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer idx - indexnumber of the action within the reaper-kb.ini
  </parameters>
  <retvals>
    boolean retval - true, if deleting worked, false if it didn't
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, delete, action, actions</tags>
</US_DocBloc>
]]  
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("DeleteKBIniActions", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("DeleteKBIniActions", "filename_with_path", "file does not exist", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteKBIniActions", "idx", "must be an integer", -3) return false end
  
  local count=0
  local linecount=0
  local finallinecount=-1
  if reaper.file_exists(filename_with_path)==false then return false end
  for line in io.lines(filename_with_path) do 
    linecount=linecount+1
    if line:sub(1,3)=="ACT" then 
      count=count+1
      if count==idx then finallinecount=linecount end
    end
  end
  if finallinecount>-1 then 
    local FirstPart=ultraschall.ReadLinerangeFromFile(filename_with_path, 1, finallinecount-1)
    local LastPart=ultraschall.ReadLinerangeFromFile(filename_with_path, finallinecount+1,  ultraschall.CountLinesInFile(filename_with_path))
    ultraschall.WriteValueToFile(filename_with_path,FirstPart..LastPart)
    return true
  else 
    return false
  end
end

--A=ultraschall.DeleteKBIniActions("c:\\test.txt",1)

function ultraschall.DeleteKBIniScripts(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteKBIniScripts</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteKBIniScripts(string filename_with_path, integer idx)</functioncall>
  <description>
    Deletes an "SCR"-script of a reaper-kb.ini.
    Returns true/false when deleting worked/didn't work.
    
    Needs a restart of Reaper for this change to take effect!
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer idx - indexnumber of the script within the reaper-kb.ini
  </parameters>
  <retvals>
    boolean retval - true, if deleting worked, false if it didn't
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, delete, script, scripts</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("DeleteKBIniScripts", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("DeleteKBIniScripts", "filename_with_path", "file does not exist", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteKBIniScripts", "idx", "must be an integer", -3) return false end
  
  local count=0
  local linecount=0
  local finallinecount=-1
  if reaper.file_exists(filename_with_path)==false then return false end
  for line in io.lines(filename_with_path) do 
  linecount=linecount+1
    if line:sub(1,3)=="SCR" then 
      count=count+1
      if count==idx then finallinecount=linecount end
    end
  end
  if finallinecount>-1 then 
    local FirstPart=ultraschall.ReadLinerangeFromFile(filename_with_path, 1, finallinecount-1)
    local LastPart=ultraschall.ReadLinerangeFromFile(filename_with_path, finallinecount+1,  ultraschall.CountLinesInFile(filename_with_path))
    ultraschall.WriteValueToFile(filename_with_path,FirstPart..LastPart)
    return true
  else 
    return false
  end
end

--A=ultraschall.DeleteKBIniScripts("c:\\test.txt",1)

function ultraschall.DeleteKBIniKeys(filename_with_path, idx)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteKBIniKeys</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DeleteKBIniKeys(string filename_with_path, integer idx)</functioncall>
  <description>
    Deletes a "KEY"-keybinding of a reaper-kb.ini.
    Returns true/false when deleting worked/didn't work.
    
    Needs a restart of Reaper for this change to take effect!
  </description>
  <parameters>
    string filename_with_path - filename with path for the reaper-kb.ini
    integer idx - indexnumber of the keybinding within the reaper-kb.ini
  </parameters>
  <retvals>
    boolean retval - true, if deleting worked, false if it didn't
  </retvals>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurationmanagement, reaper-kb.ini, kb.ini, keybindings, delete, key, keys, keybind</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("DeleteKBIniKeys", "filename_with_path", "must be a string", -1) return false end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("DeleteKBIniKeys", "filename_with_path", "file does not exist", -2) return false end
  if math.type(idx)~="integer" then ultraschall.AddErrorMessage("DeleteKBIniKeys", "idx", "must be an integer", -3) return false end
  
  local count=0
  local linecount=0
  local finallinecount=-1
  if reaper.file_exists(filename_with_path)==false then return false end
  for line in io.lines(filename_with_path) do 
  linecount=linecount+1
    if line:sub(1,3)=="KEY" then 
    count=count+1
      if count==idx then finallinecount=linecount end
    end
  end
  if finallinecount>-1 then 
    local FirstPart=ultraschall.ReadLinerangeFromFile(filename_with_path, 1, finallinecount-1)
    local LastPart=ultraschall.ReadLinerangeFromFile(filename_with_path, finallinecount+1,  ultraschall.CountLinesInFile(filename_with_path))
    ultraschall.WriteValueToFile(filename_with_path,FirstPart..LastPart)
    return true
  else 
    return false
  end
end

--A=ultraschall.DeleteKBIniKeys("c:\\test.txt",1)


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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>inifilemanagement, get, key, value, section</tags>
</US_DocBloc>
--]]
  if type(inifile)~="string" then ultraschall.AddErrorMessage("GetIniFileValue", "inifile", "must be a string", -1) return -1 end
  if section==nil then ultraschall.AddErrorMessage("GetIniFileValue", "section", "must be a string", -2) return -1 end
  if key==nil then ultraschall.AddErrorMessage("GetIniFileValue", "key", "must be a string", -3) return -1 end
  if reaper.file_exists(inifile)==false then ultraschall.AddErrorMessage("GetIniFileValue","inifile", "file does not exist", -4) return -1 end
  if errval==nil then errval="" end
  section=tostring(section)
  key=tostring(key)

  return reaper.BR_Win32_GetPrivateProfileString(section, key, errval, inifile)
end

--AAA,BBB=ultraschall.GetIniFileValue("REAPER", "automute", "LULATSCH", reaper.get_ini_file())

function ultraschall.SetIniFileValue(section, key, value, inifile)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetIniFileValue</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    SWS=2.10.0.1
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
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

  return reaper.BR_Win32_WritePrivateProfileString(section, key, value, inifile)
end

--A1=ultraschall.SetIniFileValue(file:match("(.-)REAPER.ini").."lula.ini", "ultrascshall_update", "D", "1")

function ultraschall.QueryKeyboardShortcutByKeyID(modifier, key)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>QueryKeyboardShortcutByKeyID</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>string Shortcutname = ultraschall.QueryKeyboardShortcutByKeyID(integer modifier, integer key)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the name of the shortcut of the modifier-key-values, as stored in the KEY-entries within the reaper-kb.ini
    
    That way, you can take a KEY-entry from the reaper-kb.ini, like
     
          KEY 1 65 _Ultraschall_Play_From_Editcursor_Position 0
          
    Extract the modifier and key-values(1 and 65 in the example) and pass them to this function.
    You will get returned "A" as 1 and 65 is the keyboard-shortcut-code for the A-key.
    
    Only necessary for those, who try to read keyboard-shortcuts directly from the reaper-kb.ini to display them in some way.
    
    returns nil in case of an error
  </description>
  <retvals>
    string Shortcutname - the actual name of the shortcut, like "A" or "F1" or "Ctrl+Alt+Shift+Win+PgUp".
  </retvals>
  <parameters>
    integer modifier - the modifier value, which is the first one after KEY in a KEY-entry in the reaper-kb.ini-file
    integer key - the key value, which is the second one after KEY in a KEY-entry in the reaper-kb.ini-file
  </parameters>
  <chapter_context>
    Configuration-Files Management
    Reaper-kb.ini
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationFiles_Module.lua</source_document>
  <tags>configurations management, key, shortcut, name, query, get</tags>
</US_DocBloc>
]]
  if math.type(modifier)~="integer" then ultraschall.AddErrorMessage("QueryKeyboardShortcutByKeyID", "modifier", "must be an integer", -1) return nil end
  if math.type(key)~="integer" then ultraschall.AddErrorMessage("QueryKeyboardShortcutByKeyID", "key", "must be an integer", -2) return nil end
  local length_of_value, value = ultraschall.GetIniFileValue("Code", modifier.."_"..key, -999, ultraschall.Api_Path.."/IniFiles/Reaper-KEY-Codes_for_reaper-kb_ini.ini")
  return value
end