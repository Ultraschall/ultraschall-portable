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
---    File Management  Module    ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "FileManagement-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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

function ultraschall.ReadFullFile(filename_with_path, binary)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadFullFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string contents, integer length_of_file, integer number_of_lines = ultraschall.ReadFullFile(string filename_with_path, boolean binary)</functioncall>
  <description>
    Return contents of filename_with_path.
    
    Returns nil in case of an error.
  </description>
  <retvals>
    string contents - the contents of the whole file.
    integer length_of_file - the number of bytes of the file
    integer number_of_lines - number of lines in file (-1 if parameter binary is set to true)
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    boolean binary - true if the file shall be read as a binary file; false if read as ASCII. Default is ASCII.
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, full file, binary, ascii</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(filename_with_path) ~= "string" then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "must be a string", -1) return nil end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "file "..filename_with_path.." does not exist ", -2) return nil end
  
  -- prepare variables
  if binary==true then binary="b" else binary="" end
  local linenumber=0
  
  -- read file
  local file=io.open(filename_with_path,"r"..binary)
  if file==nil then ultraschall.AddErrorMessage("ReadFullFile", "filename_with_path", "could not read file "..filename_with_path..", probably due another application accessing it.", -3) return nil end
  local filecontent=file:read("a")
  
  -- count lines in file, when non binary
  if binary~=true then
    for w in string.gmatch(filecontent, "\n") do
      linenumber=linenumber+1
    end
  else
    linenumber=-1
  end
  file:close()
  -- return read file, length and linenumbers
  return filecontent, filecontent:len(), linenumber
end


function ultraschall.ReadValueFromFile(filename_with_path, value)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadValueFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string contents, string linenumbers, integer numberoflines, integer number_of_foundlines = ultraschall.ReadValueFromFile(string filename_with_path, string value)</functioncall>
  <description>
    Return contents of filename_with_path. 
    
    If "value" is given, it will return all lines, containing the value in the file "filename_with_path". 
    The second line-numbers return-value is very valuable when giving a "value". "Value" is not case-sensitive.
    The value can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
  </description>
  <retvals>
    string contents - the contents of the file, or the lines that contain parameter value in it, separated by a newline
    string linenumbers - a string, that contains the linenumbers returned as a , separated csv-string
    integer numberoflines_in_file - the total number of lines in the file
    integer number_of_foundlines - the number of found lines
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    string value - the value to look in the file for. Not case-sensitive.
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, value, pattern, lines</tags>
</US_DocBloc>
]]
  -- check parameters
  if type(filename_with_path) ~= "string" then ultraschall.AddErrorMessage("ReadValueFromFile", "filename_with_path", "must be a string", -1) return nil end
  if value==nil then value="" end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ReadValueFromFile", "filename_with_path", "file "..filename_with_path.." does not exist", -2) return nil end
  if ultraschall.IsValidMatchingPattern(value)==false then ultraschall.AddErrorMessage("ReadValueFromFile", "value", "malformed pattern", -3) return nil end

  -- prepare variables
  local contents=""
  local b=0 -- temporary line-counting-variable
  local linenumbers="" -- the linenumbers of lines, where value has been found in the file, separated by a ,
  local number_of_lines=0 -- the number of lines in the file/number of lines, where value has been found
  local foundlines={} -- the found-lines throw into an array, with each entry being one line
  local countlines=0
  
  -- read file and find lines
  if value=="" then -- if no search-value is given
    for line in io.lines(filename_with_path) do 
      contents=contents..line.."\n"
      b=b+1
      linenumbers=linenumbers..tostring(b)..","
      number_of_lines=b
      countlines=countlines+1
    end
  else -- if a search-value is given
    for line in io.lines(filename_with_path) do
      local temp=line:lower()
      local valtemp=value:lower()
      b=b+1
      if temp:match(valtemp)~=nil then
        contents=contents..line.."\n"          
        linenumbers=linenumbers..tostring(b)..","
        number_of_lines=number_of_lines+1
        countlines=countlines+1
      end
      number_of_lines=b
    end
  end
  -- return found lines and values
  if return_lines_as_array==false then countlines=nil foundlines=nil end

  --string contents, string linenumbers, integer numberoflines
  return contents, linenumbers:sub(1,-2), number_of_lines, countlines
end


function ultraschall.ReadLinerangeFromFile(filename_with_path, firstlinenumber, lastlinenumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadLinerangeFromFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string contents, boolean correctnumberoflines, integer number_of_lines = ultraschall.ReadLinerangeFromFile(string filename_with_path, integer firstlinenumber, integer lastlinenumber)</functioncall>
  <description>
    Return contents of filename_with_path, from firstlinenumber to lastlinenumber. Counting of linenumbers starts with 1 for the first line.
    The returned string contains all requested lines, separated by a newline.
    
    Returns nil, if the linenumbers are invalid.
  </description>
  <retvals>
    string contents - the contents the lines of the file, that you requested
    boolean correctnumberoflines - true, if the number of lines are returned, as requested; false if fewer lines are returned
    integer number_of_lines - the number of read lines
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    integer firstlinenumber - the first linenumber to be returned. First line in the file begins with 1!
    integer lastlinenumber - the last linenumber to be returned; -1, for the whole file
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, range</tags>
</US_DocBloc>
]]
  if math.type(firstlinenumber)~="integer" then ultraschall.AddErrorMessage("ReadLinerangeFromFile","firstlinenumber", "Must be an integer!", -1) return nil end
  if math.type(lastlinenumber)~="integer" then ultraschall.AddErrorMessage("ReadLinerangeFromFile","lastlinenumber", "Must be an integer!", -2) return nil end
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadLinerangeFromFile","filename_with_path", "Must be a string!", -3) return nil end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ReadLinerangeFromFile","filename_with_path", "File "..filename_with_path.." not found!", -4) return nil end
  
  local a=""
  local b=0

  for line in io.lines(filename_with_path) do 
     b=b+1
     if b>=firstlinenumber and lastlinenumber==-1 then
        a=a..line.."\n"
     elseif b>=firstlinenumber and b<=lastlinenumber then
        a=a..line.."\n"
     end
     if b>lastlinenumber and lastlinenumber~=-1 then return a, true, b-1 end
  end
  if b<lastlinenumber and lastlinenumber~=-1 then return a, false, b end
  
  return a, true, b
end

function ultraschall.MakeCopyOfFile(input_filename_with_path, output_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MakeCopyOfFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MakeCopyOfFile(string input_filename_with_path, string output_filename_with_path)</functioncall>
  <description>
    Copies input_filename_with_path to output_filename_with_path. 
    Only textfiles! For binary-files use MakeCopyOfFile_Binary() instead!
    
    Returns true, if it worked, false if it didn't.
  </description>
  <retvals>
    boolean retval - true, if copy worked, false if it didn't.
  </retvals>
  <parameters>
    string input_filename_with_path - filename of the file to copy
    string output_filename_with_path - filename of the copied file to be created.
  </parameters>
  <chapter_context>
    File Management
    Manipulate Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>read file, value</tags>
  <tags>filemanagement, copy, file management</tags>
</US_DocBloc>
]]
  if type(input_filename_with_path)~="string" then ultraschall.AddErrorMessage("MakeCopyOfFile", "input_filename_with_path", "must be a string", -1) return false end
  if type(output_filename_with_path)~="string" then ultraschall.AddErrorMessage("MakeCopyOfFile", "output_filename_with_path", "must be a string", -2) return false end
  if reaper.file_exists(input_filename_with_path)==true then
    local file=io.open(output_filename_with_path,"w")
    if file==nil then ultraschall.AddErrorMessage("MakeCopyOfFile", "output_filename_with_path", "can't create file "..output_filename_with_path, -3) return false end
    for line in io.lines(input_filename_with_path) do
      file:write(line.."\n")
    end
    file:close()
  else ultraschall.AddErrorMessage("MakeCopyOfFile", "input_filename_with_path", "file does not exist "..input_filename_with_path, -4) return false
  end
  return true
end

function ultraschall.MakeCopyOfFile_Binary(input_filename_with_path, output_filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MakeCopyOfFile_Binary</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MakeCopyOfFile_Binary(string input_filename_with_path, string output_filename_with_path)</functioncall>
  <description>
    Copies input_filename_with_path to output_filename_with_path as binary-file.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - returns true, if copy worked; false if it didn't
  </retvals>
  <parameters>
    string input_filename_with_path - filename of the file to copy
    string output_filename_with_path - filename of the copied file, that shall be created
  </parameters>
  <chapter_context>
    File Management
    Manipulate Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, binary</tags>
</US_DocBloc>
]]
  if type(input_filename_with_path)~="string" then ultraschall.AddErrorMessage("MakeCopyOfFile_Binary", "input_filename_with_path", "must be a string", -1) return false end
  if type(output_filename_with_path)~="string" then ultraschall.AddErrorMessage("MakeCopyOfFile_Binary", "output_filename_with_path", "must be a string", -2) return false end
  
  if reaper.file_exists(input_filename_with_path)==true then
    local fileread=io.open(input_filename_with_path,"rb")
    if fileread==nil then ultraschall.AddErrorMessage("MakeCopyOfFile_Binary", "input_filename_with_path", "could not read file "..input_filename_with_path..", probably due another application accessing it.", -5) return false end
    local file=io.open(output_filename_with_path,"wb")
    if file==nil then ultraschall.AddErrorMessage("MakeCopyOfFile_Binary", "output_filename_with_path", "can't create file "..output_filename_with_path, -3) return false end
    file:write(fileread:read("*a"))
    fileread:close()
    file:close()
  else ultraschall.AddErrorMessage("MakeCopyOfFile_Binary", "input_filename_with_path", "file does not exist "..input_filename_with_path, -4) return false
  end
  return true
end

function ultraschall.ReadBinaryFileUntilPattern(input_filename_with_path, pattern)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadBinaryFileUntilPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length, string content = ultraschall.ReadBinaryFileUntilPattern(string input_filename_with_path, string pattern)</functioncall>
  <description>
    Returns a binary file, up until a pattern. The pattern is not case-sensitive.
    
    Pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    returns false in case of an error
  </description>
  <retvals>
    integer length - the length of the returned data
    string content - the content of the file, that has been read until pattern
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    string pattern - a pattern to search for. Case-sensitive.
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, pattern, binary</tags>
</US_DocBloc>
]]
  local temp=""
  local temp2
  if type(input_filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "input_filename_with_path", "must be a string", -1) return false end
  if type(pattern)~="string" then ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "pattern", "must be a string", -2) return false end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "pattern", "malformed pattern", -3) return false end
  
  if reaper.file_exists(input_filename_with_path)==true then
    local fileread=io.open(input_filename_with_path,"rb")
    if fileread==nil then ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "input_filename_with_path", "could not read file "..input_filename_with_path..", probably due another application accessing it.", -6) return false end
    temp=fileread:read("*a")
    temp2=temp:match("(.-"..pattern..")")
    if temp2==nil then fileread:close() ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "pattern", "pattern not found in file", -4) return false end
    fileread:close()
  else
    ultraschall.AddErrorMessage("ReadBinaryFileUntilPattern", "input_filename_with_path", "file "..input_filename_with_path.." does not exist", -5) return false
  end
  return temp2:len(), temp2
end

function ultraschall.ReadBinaryFileFromPattern(input_filename_with_path, pattern)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadBinaryFileFromPattern</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length, string content = ultraschall.ReadBinaryFileFromPattern(string input_filename_with_path, string pattern)</functioncall>
  <description>
    Returns a binary file, from pattern onwards. The pattern is not case-sensitive.
    
    The pattern can also contain patterns for pattern matching. Refer the LUA-docs for pattern matching.
    i.e. characters like ^$()%.[]*+-? must be escaped with a %, means: %[%]%(%) etc
    
    returns false in case of an error
  </description>
  <retvals>
    integer length - the length of the returned data
    string content - the content of the file, that has been read from pattern to the end
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    string pattern - a pattern to search for. Case-sensitive.
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, pattern, binary</tags>
</US_DocBloc>
]]
  local temp=""
  local temp2
  if type(input_filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "input_filename_with_path", "must be a string", -1) return false end
  if type(pattern)~="string" then ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "pattern", "must be a string", -2) return false end
  if ultraschall.IsValidMatchingPattern(pattern)==false then ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "pattern", "malformed pattern", -3) return false end
  
  if reaper.file_exists(input_filename_with_path)==true then
    local fileread=io.open(input_filename_with_path,"rb")
    if fileread==nil then ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "input_filename_with_path", "could not read file "..input_filename_with_path..", probably due another application accessing it.", -6) return false end
    temp=fileread:read("*a")
    temp2=temp:match("("..pattern..".*)")
    if temp2==nil then fileread:close() ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "pattern", "pattern not found in file", -4) return false end
    fileread:close()
  else
    ultraschall.AddErrorMessage("ReadBinaryFileFromPattern", "input_filename_with_path", "file "..input_filename_with_path.." does not exist", -5) return false
  end
  return temp2:len(), temp2
end

function ultraschall.CountLinesInFile(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountLinesInFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer linesinfile = ultraschall.CountLinesInFile(string filename_with_path)</functioncall>
  <description>
    Counts lines in a textfile. In binary files, the number of lines may be weird and unexpected!
    Returns -1, if no such file exists.
  </description>
  <retvals>
    integer linesinfile - number of lines in a textfile; -1 in case of error
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
  </parameters>
  <chapter_context>
    File Management
    File Analysis
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, count</tags>
</US_DocBloc>
]]
  -- check parameters  
  if type(filename_with_path) ~= "string" then ultraschall.AddErrorMessage("CountLinesInFile", "filename_with_path", "must be a string", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("CountLinesInFile", "filename_with_path", "no such file "..filename_with_path, -2) return -1 end

  -- prepare variable
  local b=0
  
  -- count the lines
  for line in io.lines(filename_with_path) do 
      b=b+1
  end
  
  return b
end


function ultraschall.ReadFileAsLines_Array(filename_with_path, firstlinenumber, lastlinenumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadFileAsLines_Array</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>array contents, boolean correctnumberoflines, integer number_of_lines = ultraschall.ReadFileAsLines_Array(string filename_with_path, integer firstlinenumber, integer lastlinenumber)</functioncall>
  <description>
    Return contents of filename_with_path, from firstlinenumber to lastlinenumber as an array. Counting of linenumbers starts with 1 for the first line.
    The returned array contains all requested lines, which each entry holding one returned line.
    
    Returns nil, if the linenumbers are invalid.
  </description>
  <retvals>
    array contents - the contents the lines of the file, that you requested as an array, in which each entry hold one line of the file
    boolean correctnumberoflines - true, if the number of lines are returned, as you requested; false if fewer lines are returned
    integer number_of_lines - the number of lines returned
  </retvals>
  <parameters>
    string filename_with_path - filename of the file to be read
    integer firstlinenumber - the first linenumber to be returned. First line in the file begins with 1!
    integer lastlinenumber - the last linenumber to be returned; -1, read all lines in the file
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, range, array</tags>
</US_DocBloc>
]]  
  if math.type(firstlinenumber)~="integer" then ultraschall.AddErrorMessage("ReadFileAsLines_Array","firstlinenumber", "Must be an integer!", -1) return nil end
  if math.type(lastlinenumber)~="integer" then ultraschall.AddErrorMessage("ReadFileAsLines_Array","lastlinenumber", "Must be an integer!", -2) return nil end
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadFileAsLines_Array","filename_with_path", "Must be a string!", -3) return nil end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("ReadFileAsLines_Array","filename_with_path", "File not found! "..filename_with_path, -4) return nil end
  
  local LineArray={}

  local b=0

  for line in io.lines(filename_with_path) do 
     b=b+1
     if b>=firstlinenumber and lastlinenumber==-1 then
        LineArray[b]=line
     elseif b>=firstlinenumber and b<=lastlinenumber then
        LineArray[b]=line
     end
     if b>lastlinenumber and lastlinenumber~=-1 then return LineArray, true, b-1 end
  end
  if b<lastlinenumber and lastlinenumber~=-1 then return LineArray, false, b end
  
  return LineArray, true, b
end

--A,B,C,D = ultraschall.ReadFileAsLines_Array("c:\\render-queue-test.txt", 1, "")


function ultraschall.ReadBinaryFile_Offset(input_filename_with_path, startoffset, numberofbytes)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadBinaryFile_Offset</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer length, string content = ultraschall.ReadBinaryFile_Offset(string input_filename_with_path, integer startoffset, integer numberofbytes)</functioncall>
  <description>
    Returns the contents of a binary file from startoffset until startoffset+numberofbytes.
    
    When setting startoffset to a negative value, it will read from the end of the file, means: 
    -100 will start -100 characters before the end of the file and numberofbytes will read from that point on    
    
    Returns false, if file can not be opened.
  </description>
  <retvals>
    integer length - the length of the returned part of the file, might be shorter than requested, if file ends before
    string content - the content of the file, that has been read
  </retvals>
  <parameters>
    string input_filename_with_path - filename of the file to be read
    integer startoffset - the offset, at where to begin the fileread. 0 for the beginning of the file; negative values set offset from the end of the file
    integer numberofbytes - the number of bytes to read. -1 for until the end of the file. If there are fewer bytes than requested, the returned string will be shorter.
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read file, binary, offset</tags>
</US_DocBloc>
]]

  local temp=""
  local length, eof
  local temp2
  if input_filename_with_path==nil then ultraschall.AddErrorMessage("ReadBinaryFile_Offset", "filename_with_path", "nil not allowed as filename", -1) return false end
  if math.type(startoffset)~="integer" then ultraschall.AddErrorMessage("ReadBinaryFile_Offset", "startoffset", "no valid startoffset. Only integer allowed.", -2) return false end
  if math.type(numberofbytes)~="integer" then ultraschall.AddErrorMessage("ReadBinaryFile_Offset", "numberofbytes", "no valid value. Only integer allowed.", -3) return false end
  if numberofbytes<-1 then ultraschall.AddErrorMessage("ReadBinaryFile_Offset", "numberofbytes", "must be positive value (0 to n) or -1 for until end of file.", -4) return false end
  
  if reaper.file_exists(input_filename_with_path)==true then
    local fileread=io.open(input_filename_with_path,"rb")
    if numberofbytes==-1 then numberofbytes=fileread:seek ("end" , 0)-startoffset end
    if startoffset>=0 then fileread:seek ("set" , startoffset) else eof=fileread:seek ("end") fileread:seek ("set" , eof-1-(startoffset*-1)) end
    temp=fileread:read(numberofbytes)
    fileread:close()
    return temp:len(), temp
  else
    ultraschall.AddErrorMessage("ReadBinaryFile_Offset", "filename_with_path", "file does not exist."..input_filename_with_path, -6)
    return false
  end
end


function ultraschall.GetLengthOfFile(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetLengthOfFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer lengthoffile = ultraschall.GetLengthOfFile(string filename_with_path)</functioncall>
  <description>
    Returns the length of the file filename_with_path in bytes.
    Will return -1, if no such file exists.
  </description>
  <parameters>
    string filename_with_path - filename to write the value to
  </parameters>
  <retvals>
    integer lengthoffile - the length of the file in bytes. -1 in case of error
  </retvals>
  <chapter_context>
    File Management
    File Analysis
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,file,length,bytes,count</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("GetLengthOfFile", "filename_with_path", "nil not allowed as filename", -1) return -1 end
  local numberofbytes
  if reaper.file_exists(filename_with_path)==true then
    local fileread=io.open(filename_with_path,"rb")
    numberofbytes=fileread:seek ("end" , 0)
    fileread:close()
  else
    ultraschall.AddErrorMessage("GetLengthOfFile", "filename_with_path", "file does not exist: ".. filename_with_path, -2)
    return -1
  end
  return numberofbytes  
end

--A=ultraschall.GetLengthOfFile("hui")


function ultraschall.CountDirectoriesAndFilesInPath(path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CountDirectoriesAndFilesInPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer filecount, integer dircount = ultraschall.CountDirectoriesAndFilesInPath(string path)</functioncall>
  <description>
    returns the number of files and directories in path
    
    returns -1, in case of error
  </description>
  <parameters>
    string path - the path to count the files and directories from
  </parameters>
  <retvals>
    integer filecount - the number of files found in path
    integer dircount - the number of directories found in path
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, count, directory, file, path</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(path)~="string" then ultraschall.AddErrorMessage("CountDirectoriesAndFilesInPath", "path", "must be a string", -1) return -1 end
  
  -- prepare variables
  local string=""
  local filecount=0
  local dircount=0
  
  -- count files
  while string~=nil do
    string=reaper.EnumerateFiles(path, filecount)
    if string~=nil then filecount=filecount+1 end
  end
  local string=""
  
  -- count directories
  while string~=nil do
    string=reaper.EnumerateSubdirectories(path, dircount)
    if string~=nil then dircount=dircount+1 end
  end
  
  -- return counts
  return filecount, dircount
end

--L,LL=ultraschall.CountPathAndFilesInDirectory("c:\\")

function ultraschall.GetAllFilenamesInPath(path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllFilenamesInPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer filecount, array files = ultraschall.GetAllFilenamesInPath(string path)</functioncall>
  <description>
    returns the number of files and the filenames in path
    
    returns -1, in case of error
  </description>
  <parameters>
    string path - the path to get the filenames from
  </parameters>
  <retvals>
    integer filecount - the number of files found in path
    array files - the filenames found in path
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, get, filenames, file, path</tags>
</US_DocBloc>
--]]

  -- check parameters
  if type(path)~="string" then ultraschall.AddErrorMessage("GetAllFilenamesInPath", "path", "must be a string", -1) return -1 end

  -- prepare variables
  local Files={}
  local count=1
  local String=""
  
  if path:sub(-1,-1)~="/" or path:sub(-1,-1)~="\\" then path=path.."/" end
  
  -- get all filenames in path
  while String~=nil do
    String=reaper.EnumerateFiles(path, count-1)
    if String~=nil then Files[count]=path..String end
    if Files[count]~=nil then
        Files[count]=string.gsub(Files[count], "//", "/")
        Files[count]=string.gsub(Files[count], "\\", "/")
     end
     count=count+1
  end
  -- return results
  return count-2, Files
end

function ultraschall.GetAllDirectoriesInPath(path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllDirectoriesInPath</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer filecount, array directories = ultraschall.GetAllDirectoriesInPath(string path)</functioncall>
  <description>
    returns the number of directories and the directorynames in path
    
    returns -1, in case of error
  </description>
  <parameters>
    string path - the path to get the directories from
  </parameters>
  <retvals>
    integer filecount - the number of directories found in path
    array files - the directories found in path
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, get, directory, file, path</tags>
</US_DocBloc>
--]]

  -- check parameters
  if type(path)~="string" then ultraschall.AddErrorMessage("GetAllDirectoriesInPath", "path", "must be a string", -1) return -1 end
  
  -- check variables
  local Dirs={}
  local count=1
  local string=""
  
  -- get directorynames
  while string~=nil do
    string=reaper.EnumerateSubdirectories(path, count-1)
    if string~=nil then Dirs[count]=path..string end
    count=count+1
  end
  
  -- return results
  return count-2, Dirs
end

--L,LL=ultraschall.GetAllDirectoriesInPath("C:\\")


function ultraschall.CheckForValidFileFormats(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CheckForValidFileFormats</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>string fileformat, boolean supported_by_reaper, string mediatype = ultraschall.CheckForValidFileFormats(string filename_with_path)</functioncall>
  <description>
    Returns the fileformat of a Reaper-supported-file, images, audios(opus and m4a missing, though!), and video(mp4-video missing, though!).
    Note: Checks the file itself and does not check for correct file-extension. Reaper needs the correct file-extension or it can't read an otherwise valid imagefile.
          For example: if you want to import a GIF, renamed to filename.JPG, Reaper will not be able to read it. Only when the extension is the same as the file itself(filename.GIF).
    
    Returns nil in case of an error
  </description>
  <parameters>
    string filename_with_path - the file to check for it's image-fileformat
  </parameters>
  <retvals>
    string fileformat - the format of the file; JPG, PNG, GIF, LCF, ICO, WAV, AIFF, ASF/WMA/WMV, MP3, MP3 -ID3TAG, FLAC, MKV/MKA/MKS/MK3D/WEBM, AVI, RPP_PROJECT, unknown
    boolean supported_by_reaper - true, if importing of the fileformat is supported by Reaper; false, if not
    string mediatype - the type of the media; Image, Audio, Audio/Video, Video, Reaper
  </retvals>
  <chapter_context>
    File Management
    File Analysis
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>helper functions, image, video, audio, fileformat, check</tags>
</US_DocBloc>
--]]

  -- check parameters
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("CheckForValidFileFormats","filename_with_path", "Must be a string!", -1) return nil end
  if reaper.file_exists(filename_with_path)~=true then ultraschall.AddErrorMessage("CheckForValidFileFormats","filename_with_path", "File does not exist!", -2) return nil end
  
  -- prepare variables
  local length, content = ultraschall.ReadBinaryFile_Offset(filename_with_path, 0, 100)
  
  --print2(content:sub(13,14))
  -- check for a specific imagefile supported by Reaper
  if     content:match("JFIF")~=nil then return "JPG", true, "Image"
  elseif content:sub(1,3)=="ÿØÿ" then return "JPG", true, "Image"
  elseif content:sub(2,4)=="PNG" then return "PNG", true, "Image"
  elseif content:sub(1,2)=="BM" then return "BMP", true, "Image"
  elseif content:sub(1,3)=="GIF" then return "GIF", true, "Image"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x1,0xB0,0xCE)==true then 
        local file=ultraschall.ReadFullFile(filename_with_path,true)
        local frameheader=string.char(1, 176, 206)
        local framecount=0
        while file~=nil do
          framecount=framecount+1
          file=file:match(frameheader.."(.*)")
        end
        return "LCF", true, "Image", framecount-1
  elseif ultraschall.CompareStringWithAsciiValues(content, 0,0,1,1)==true then return "ICO", true, "Image"
  
  -- audio formats
  elseif content:sub(1,4)=="OggS" then return "OGG", true, "Audio"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x52, 0x49, 0x46, 0x46, -1, -1, -1, -1, 0x57, 0x41, 0x56, 0x45)==true then return "WAV", true, "Audio"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x46, 0x4F, 0x52, 0x4D, -1, -1, -1, -1, 0x41, 0x49, 0x46, 0x46)==true then return "AIFF", true, "Audio"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9, 0x00, 0xAA, 0x00, 0x62, 0xCE, 0x6C)==true then return "ASF/WMA/WMV", true, "Audio/Video"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0xFF, 0xFB)==true then return "MP3", true, "Audio"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x49, 0x44, 0x33)==true then return "MP3 - ID3TAG", true, "Audio"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x66, 0x4C, 0x61, 0x43)==true then return "FLAC", true, "Audio"
  elseif content:sub(1,4)=="MThd" then return "MID", true, "Audio"
  
  -- video formats
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x1A, 0x45, 0xDF, 0xA3)==true then return "MKV/MKA/MKS/MK3D/WEBM", true, "Video"
  elseif ultraschall.CompareStringWithAsciiValues(content, 0x52, 0x49, 0x46, 0x46, -1, -1, -1, -1, 0x41, 0x56, 0x49, 0x20)==true then return "AVI", true, "Video"
  else -- Reaper's own projectfiles
    local A,B=ultraschall.ReadBinaryFile_Offset(filename_with_path, 0, 100)
    local C,D=ultraschall.ReadBinaryFile_Offset(filename_with_path, -20, 21)
    if ultraschall.IsValidProjectStateChunk(B..D)==true then return "RPP_PROJECT", true, "Reaper" end
      
  -- other formats
  return "unknown", false, "unknown"
  end
end


function ultraschall.DirectoryExists(path, directory)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DirectoryExists</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DirectoryExists(string path, string directory)</functioncall>
  <description>
    Checks, if a directory exists in path.
    
    On Linux: path and directory are case-sensitive!
    
    Returns false in case of error.
  </description>
  <retvals>
    boolean retval - true, directory exists; false, directory does not exist
  </retvals>
  <parameters>
    string path - the path, in which to look for the existence of parameter directory
    string directory - the name of the directory to check for in path
  </parameters>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, directory, check, exists</tags>
</US_DocBloc>
]]
  if type(path)~="string" then ultraschall.AddErrorMessage("DirectoryExists", "path", "Must be a string", -1) return false end
  if type(directory)~="string" then ultraschall.AddErrorMessage("DirectoryExists", "directory", "Must be a string", -2) return false end
  local index=0
  local found=false
  if ultraschall.IsOS_Other()==false then path=path:lower() directory=directory:lower() end
  while reaper.EnumerateSubdirectories(path,index)~=nil do
--  reaper.ShowConsoleMsg(reaper.EnumerateSubdirectories(path, index).."\n")
    if reaper.EnumerateSubdirectories(path, index):lower()==directory then found=true break end
    index=index+1
  end
  return found
end


function ultraschall.OnlyFilesOfCertainType(filearray, filetype)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OnlyFilesOfCertainType</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer foundfilecount, array foundfilearray = ultraschall.OnlyFilesOfCertainType(array filearray, string filetype)</functioncall>
  <description>
    Returns the filenames_with_path from a filearray, that are of a certain filetype
    
    returns -1 in case of an error
  </description>
  <parameters>
    array filearray - an array with files to check for; index is 1-based
    string fileformat - the format of the file; JPG, PNG, GIF, LCF, ICO, WAV, AIFF, ASF/WMA/WMV, MP3, MP3 -ID3TAG, FLAC, MKV/MKA/MKS/MK3D/WEBM, AVI, RPP_PROJECT, unknown
  </parameters>
  <retvals>
    integer foundfilecount - the number of files that contain the right filetype
    array foundfilearray - an array with all the files that contain the right filetype
  </retvals>
  <chapter_context>
    File Management
    File Analysis
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, get, filetype</tags>
</US_DocBloc>
]]
  if type(filearray)~="table" then ultraschall.AddErrorMessage("OnlyFilesOfCertainType", "filearray", "must be a table", -1) return -1 end
  if type(filetype)~="string" then ultraschall.AddErrorMessage("OnlyFilesOfCertainType", "filetype", "must be a string", -2) return -1 end
  local foundfiles={}
  local count=1
  local foundcount=0
  while filearray[count]~=nil do
    local foundfiletype=ultraschall.CheckForValidFileFormats(filearray[count])
    if foundfiletype==filetype then foundcount=foundcount+1 foundfiles[foundcount]=filearray[count] end
    count=count+1
  end
  return foundcount, foundfiles
end



function ultraschall.GetReaperWorkDir()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperWorkDir</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>string current_workdir = ultraschall.GetReaperWorkDir()</functioncall>
  <description>
    returns the current workdir, which is the directory. If you create a file without giving a path, this file will be created in this work-dir.
  </description>
  <retvals>
    string current_workdir - the current workdir of Reaper
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, get, current workdir of reaper</tags>
</US_DocBloc>
]]
  local temp, dir = ultraschall.GetIniFileValue("REAPER", "lastcwd", "", reaper.get_ini_file())
  return dir
end

--A,B=ultraschall.GetCurrentReaperWorkDir()

function ultraschall.DirectoryExists2(Path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DirectoryExists2</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.DirectoryExists2(string Path)</functioncall>
  <description>
    returns, if Path is an existing path.

    returns false in case of an error
  </description>
  <parameters>
    string Path - the path to check for
  </parameters>
  <retvals>
    boolean retval - true, if path exists; false, if not
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, check, directory, existence</tags>
</US_DocBloc>
]]
  if ultraschall.type(Path)~="string" then ultraschall.AddErrorMessage("DirectoryExists2", "path", "must be a string", -1) return false end
  if Path:len()==0 then return false end
  if Path:sub(-1,-1)=="\\" or Path:sub(-1,-1)=="/" then Path=Path:sub(1,-2) end

  local Path0=string.gsub(Path,"\\","/")
  Path=string.gsub(Path,"/","\\")
  local Path1, Path2 = Path0:match("(.*)/(.*)")

  if ultraschall.IsOS_Windows()==true then 
    local LL2=tonumber(reaper.ExecProcess("cmd.exe /Q /C cd "..Path, 1000):match("(.-)\n"))
    if LL2==1 then return false else return true end
  else
    return ultraschall.DirectoryExists(Path1, Path2)
  end
end



function ultraschall.SetReaperWorkDir(path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetReaperWorkDir</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetReaperWorkDir(string Path)</functioncall>
  <description>
    sets a new current working directory for Reaper. This requires a restart of Reaper to take effect, due API-limitations!
                            
    returns false in case of an error
  </description>
  <parameters>
    string Path - the path to set as new current working directory
  </parameters>
  <retvals>
    boolean retval - true, if path could be set; false, if not
  </retvals>
  <chapter_context>
    File Management
    Helper functions
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, set, new workdir of reaper</tags>
</US_DocBloc>
]]
  if ultraschall.type(path)~="string" then ultraschall.AddErrorMessage("SetReaperWorkDir", "path", "must be a string", -1) return false end
  if ultraschall.DirectoryExists2(path)==false then ultraschall.AddErrorMessage("SetReaperWorkDir", "path", "no such path exists", -2) return false end
  return ultraschall.SetIniFileValue("REAPER", "lastcwd", path, reaper.get_ini_file())
end


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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
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
  if result==nil then file=str result="" end
  return result, file
end

--B1,B2=ultraschall.GetPath("c:\\nillimul/\\test.kl", "\\")




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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,binary</tags>
</US_DocBloc>
--]]
  -- check parameters
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path", "invalid filename "..tostring(filename_with_path), -1) return -1 end
  --if type(value)~="string" then ultraschall.AddErrorMessage("WriteValueToFile","value", "must be string; convert with tostring(value), if necessary.", -2) return -1 end
  value=tostring(value)
  
  -- prepare variables
  local binary, appendix, file
  if binarymode==nil or binarymode==true then binary="b" else binary="" end
  if append==nil or append==false then appendix="w" else appendix="a" end
  
  -- write file
  file=io.open(filename_with_path,appendix..binary)
  if file==nil then ultraschall.AddErrorMessage("WriteValueToFile","filename_with_path", "can't create file "..filename_with_path, -3) return -1 end
  file:write(value)
  file:close()
  return 1
end

--ultraschall.WriteValueToFile("z:\\okjsoid", 123)

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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,insert</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_Insert","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_Insert","filename_with_path", "file does not exist "..filename_with_path, -2) return -1 end
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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,replace</tags>
</US_DocBloc>
]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "must be a string", -1) return -1 end
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "nil not allowed as filename", -0) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_Replace","filename_with_path", "file does not exist "..filename_with_path, -2) return -1 end
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

--ultraschall.WriteValueToFile_Replace("z:\\okjsoid", 123)

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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,insert,binary</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_InsertBinary","filename_with_path", "file does not exist "..filename_with_path, -2) return -1 end
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

--ultraschall.WriteValueToFile_InsertBinary("z:\\okjsoid", 123)

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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement,export,write,file,textfile,replace,binary</tags>
</US_DocBloc>
]]
  if filename_with_path==nil then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","filename_with_path", "nil not allowed as filename", -1) return -1 end
  if reaper.file_exists(filename_with_path)==false then ultraschall.AddErrorMessage("WriteValueToFile_ReplaceBinary","filename_with_path", "file does not exist "..filename_with_path, -2) return -1 end
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

--ultraschall.WriteValueToFile_ReplaceBinary("z:\\okjsoid", 123)





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
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
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

function ultraschall.SaveSubtitles_SRT(subtitle_filename_with_path, subtitle_table)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SaveSubtitles_SRT</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.99
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SaveSubtitles_SRT(string subtitle_filename_with_path, table subtitle_table)</functioncall>
  <description>
    saves the subtitles from the subtitle-table.
    
    The subtitles-table is expected to be of the following format:
    
        subtitle_table[subtitle_index]["start"]   = starttime in seconds
        subtitle_table[subtitle_index]["end"]     = endtime in seconds
        subtitle_table[subtitle_index]["caption"] = the caption, which shall be shown from start to end-time
    
    returns -1 in case of an error
  </description>
  <retvals>
    string guid - the guid of the marker/region of the marker with a specific index
  </retvals>
  <parameters>
    string subtitle_filename_with_path - the filename of the subtitle-file, into which you want to store the subtitles
    table Table - the subtitle-table, which holds all captions and the start- and endtimes of displaying the caption
  </parameters>
  <chapter_context>
    File Management
    Write Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>file management, save, write, subtitles, srt, subrip, export</tags>
</US_DocBloc>
--]]
  if type(subtitle_filename_with_path)~="string" then ultraschall.AddErrorMessage("SaveSubtitles_SRT", "subtitle_filename_with_path", "must be a string", -1) return -1 end
  if type(subtitle_table)~="table" then ultraschall.AddErrorMessage("SaveSubtitles_SRT", "subtitle_table", "must be a table", -2) return -1 end
  local String=""
  local i=1
  while type(subtitle_table[i])=="table" do
    if subtitle_table[i]["start"]==nil 
    or subtitle_table[i]["end"]==nil 
    or subtitle_table[i]["caption"]==nil then
      ultraschall.AddErrorMessage("SaveSubtitles_SRT", "subtitle_table", "entry "..i.." is missing information!", -3)
      return -1
    end
    String=String..i.."\n"..
    string.gsub(ultraschall.SecondsToTimeString_hh_mm_ss_mss(subtitle_table[i]["start"]),"%.",",").." --> "..
    string.gsub(ultraschall.SecondsToTimeString_hh_mm_ss_mss(subtitle_table[i]["end"]),"%.",",").."\n"..
    subtitle_table[i]["caption"].."\n\n"
    i=i+1
  end
  if String~="" then
    return ultraschall.WriteValueToFile(subtitle_filename_with_path, String:sub(1,-3))
  else
    ultraschall.AddErrorMessage("SaveSubtitles_SRT", "subtitle_table", "no subtitles available", -4)
    return -1
  end
end

function ultraschall.ReadSubtitles_SRT(filename_with_path)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReadSubtitles_SRT</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer Captions_Counter, table Captions = ultraschall.ReadSubtitles_SRT(string filename_with_path)</functioncall>
  <description>
    parses an srt-subtitle-file and returns its contents as table
    
    returns nil in case of an error
  </description>
  <retvals>
    integer Captions_Counter - the number of captions in the file
    table Captions - the Captions as a table of the format:
                   -    Captions[index]["start"]= the starttime of this caption in seconds
                   -    Captions[index]["end"]= the endtime of this caption in seconds
                   -    Captions[index]["caption"]= the caption itself
  </retvals>
  <parameters>
    string filename_with_path - the filename with path of the subrip srt-file
  </parameters>
  <chapter_context>
    File Management
    Read Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, read, file, srt, subrip, subtitle, import</tags>
</US_DocBloc>
--]]
  if type(filename_with_path)~="string" then ultraschall.AddErrorMessage("ReadSubtitles_SRT", "filename_with_path", "must be a string", -1) return end
  if reaper.file_exists(filename_with_path)=="false" then ultraschall.AddErrorMessage("ReadSubtitles_SRT", "filename_with_path", "must be a string", -2) return end
  local A, Type, Offset, Kind, Language, Subs, Subs_Counter, i, line
  line=0
  
  Subs={}
  Subs_Counter=0
  A=ultraschall.ReadFullFile(filename_with_path)
  i=0
  local caption=""
  if A:match("(.-)\n"):len()>0 then A="\n"..A line=-1 else line=0 end
  A=A.."\n"
  
  for k in string.gmatch(A, "(.-)\n") do
    line=line+1

    if i==3 and k~="" then
      -- get the captions
      caption=caption..k.."\n"
    elseif i==3 and k=="" then
      -- put the captions into the Subs-table
      if caption=="" then caption="" end
      Subs[Subs_Counter]["caption"]=caption:sub(1,-2)
      caption=""
      i=0
    end
    if i==2 and k:match("%-%-%>")~=nil then 
      -- get the start and endtime
      Subs[Subs_Counter]["start"], Subs[Subs_Counter]["end"] = k:match("(.-) --> (.*)")
      if Subs[Subs_Counter]["start"]==nil or Subs[Subs_Counter]["end"]==nil then ultraschall.AddErrorMessage("ReadSubtitles_SRT", "filename_with_path", "can't parse the time in line: "..line, -3) return end
      Subs[Subs_Counter]["start"]=reaper.parse_timestr(Subs[Subs_Counter]["start"])
      Subs[Subs_Counter]["end"]=reaper.parse_timestr(Subs[Subs_Counter]["end"])
      i=3
    elseif i==2 then 
      -- if the time is not the expected start and endtime, stop with an error-message
      ultraschall.AddErrorMessage("ReadSubtitles_SRT", "filename_with_path", "can't parse the time in line: "..line, -4) 
      return
    end
    if i==1 and tonumber(k)==nil then 
      -- if the caption-index isn't there, we have a faulty srt, so stop with an error-message
      ultraschall.AddErrorMessage("ReadSubtitles_SRT", "filename_with_path", "can't parse the caption-index in line: "..line, -5) 
      return 
    elseif i==1 and tonumber(k)~=nil then
      i=2
    end
    if i==0 and k=="" then 
      -- if an empty line occurs, add a new entry to sub-table, into which we put the next caption
      i=1
      Subs_Counter=Subs_Counter+1
      Subs[Subs_Counter]={}
    end
  end
  
  Subs[Subs_Counter]["caption"]=caption:sub(1,-2)
  if Subs[Subs_Counter]["start"]==nil then Subs[Subs_Counter]=nil Subs_Counter=Subs_Counter-1 end
  return Subs_Counter, Subs
end

function ultraschall.MoveFileOrFolder(file_foldername, oldpath, newpath)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MoveFileOrFolder</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.MoveFileOrFolder(string file_foldername, string oldpath, string newpath)</functioncall>
  <description>
    Moves a file or folder from oldpath to newpath.
    
    returns false in case of an error 
  </description>
  <parameters>
    string file_foldername - the folder- or filename, which you want to move
    string oldpath - the old path, in which the file or folder is located
    string newpath - the new path, into which the file or folder shall be moved
  </parameters>
  <retvals>
    boolean retval - true, moving was successful; false, moving was unsuccessful
  </retvals>
  <chapter_context>
    Manipulate Files
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_FileManagement_Module.lua</source_document>
  <tags>filemanagement, move, folder, directory, file, sourcepath, oldpath, newpath, targetpath</tags>
</US_DocBloc>
]]
  if type(file_foldername)~="string" then ultraschall.AddErrorMessage("MoveFileOrFolder",  "file_foldername", "must be a string", -1) return false end
  if type(oldpath)~="string" then ultraschall.AddErrorMessage("MoveFileOrFolder",  "oldpath", "must be a string", -2) return false end
  if type(newpath)~="string" then ultraschall.AddErrorMessage("MoveFileOrFolder",  "newpath", "must be a string", -3) return false end
  if ultraschall.DirectoryExists(oldpath, file_foldername)==false and reaper.file_exists(oldpath.."/"..file_foldername)==false then ultraschall.AddErrorMessage("MoveFileOrFolder",  "file_foldername", "no such sourcefile or directory", -4) return false end
  if ultraschall.DirectoryExists(newpath, file_foldername)==true or reaper.file_exists(newpath.."/"..file_foldername)==true then ultraschall.AddErrorMessage("MoveFileOrFolder",  "file_foldername", "target-file or -directory already exists", -5) return false end
  return os.rename(oldpath.."/"..file_foldername, newpath.."/"..file_foldername)
end


