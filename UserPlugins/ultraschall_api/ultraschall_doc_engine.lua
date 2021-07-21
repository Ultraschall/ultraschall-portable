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

--------------------------------------
--- ULTRASCHALL - API - Doc-Engine ---
--------------------------------------


if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "DOC-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "DOC-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
end

function ultraschall.Docs_ConvertPlainTextToHTML(text, nobsp)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_ConvertPlainTextToHTML</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string html_text = ultraschall.Docs_ConvertPlainTextToHTML(string String)</functioncall>
  <description>
    Converts a plaintext into HTML.
    
    Converts newlines to <br>, Double Spaces to &nbsp;&nbsp; and Tabs to &nbsp;&nbsp;&nbsp;&nbsp;
    returns nil in case of an error
  </description>
  <retvals>
    string html_text - the html-version of the text
  </retvals>
  <parameters>
    string text - the text, which shall be converted to html
  </parameters>
  <chapter_context>
    Helper functions
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, convert, text, html, usdocbloc</tags>
</US_DocBloc>
]]
  if type(text)~="string" then ultraschall.AddErrorMessage("Docs_ConvertPlainTextToHTML", "text", "must be a string", -1) return nil end
  text=string.gsub(text, "\r", "")
  text=string.gsub(text, "\n", "<br/>\n")
  if nobsp~=true then
    text=string.gsub(text, "  ", "&nbsp;&nbsp;")
    text=string.gsub(text, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
  end
  return text
end

--print2(ultraschall.ConvertPlainTextToHTML("Lalaleilelo\tlalel\n\nlululeilelalila  lala la"))

function ultraschall.ConvertTextToXMLCompatibility(text)
    --text=string.gsub(text, "%-", "%%-")
    text=string.gsub(text, "%&", "&amp;")
    text=string.gsub(text, "\"", "&quot;")
    text=string.gsub(text, "<", "&lt;")
    text=string.gsub(text, ">", "&gt;")
  return text
end

function ultraschall.ConvertMarkdownToHTML(text, version)
  text=string.gsub(text, "usdocml://", "US_Api_Functions.html#") -- this line is a hack, just supporting functions-reference!
  ultraschall.WriteValueToFile(Tempfile..".md", text)
  L=reaper.ExecProcess(ConversionToolMD2HTML, 0)
  L3=text
  L3=ultraschall.ReadFullFile(Tempfile..".html")
--  L3=string.gsub(L3, "\r", "")
--  L3=string.gsub(L3, "\n", "<br>\n")
--  if L3:sub(-4,-1)=="<br>" then L3=L3:sub(1,-5) end

--  L3=string.gsub(L3,"<p>","")
--  L3=string.gsub(L3,"</p>","")
--  L3=string.gsub(L3, "  ", "&nbsp;&nbsp;")
--  L3=string.gsub(L3, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
--  reaper.MB(L3,"",0)
  reaper.CF_SetClipboard(L3)
  return L3
end


function ultraschall.Docs_RemoveIndent(String, indenttype, i)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_RemoveIndent</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string unindented_text = ultraschall.Docs_RemoveIndent(string String, string indenttype)</functioncall>
  <description>
    unindents an indented text from a US_DocBloc.
    
    There are different styles of unindentation:
      as_typed - keeps the text, as it is
      minus_starts_line - will throw away everything from start of the line until(and including) the firt - in it
      preceding_spaces - will remove all spaces/tabs in the beginning of each line
      default - will take the indentation of the first line and apply it to each of the following lines
                that means, indentation relative to the first line is kept
    
    returns nil in case of an error
  </description>
  <retvals>
    string unindented_text - the string, from which the indentation was removed
  </retvals>
  <parameters>
    string String - the string, which shall be unindented
    string indenttype - the type of indentation you want to remove
                      -   as_typed - keeps the text, as it is
                      -   minus_starts_line - will throw away everything from start of the line until(and including) the first - in it
                      -   preceding_spaces - will remove all spaces/tabs in the beginning of each line
                      -   default - will take the indentation of the first line and apply it to each of the following lines
                      - That means, indentation relative to the first line is kept.
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, indent, unindent, text, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_RemoveIndent", "String", "must be a string"..i, -1) return nil end
  if type(indenttype)~="string" then ultraschall.AddErrorMessage("Docs_RemoveIndent", "indenttype", "must be a string", -2) return nil end
  if indenttype=="as_typed" then return String end
  if indenttype=="minus_starts_line" then return string.gsub("\n"..String, "\n.-%-", "\n"):sub(2,-1) end
  if indenttype=="preceding_spaces" then  return string.gsub("\n"..String, "\n%s*", "\n"):sub(2,-1) end
  if indenttype=="default" then 
    Length=String:match("(%s*)")
    if Length==nil then Length="" end
    return string.gsub("\n"..String, "\n"..Length, "\n"):sub(2,-1)
  end
  
  return String
end



function ultraschall.Docs_GetAllUSDocBlocsFromString(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetAllUSDocBlocsFromString</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer found_usdocblocs, array all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(string String)</functioncall>
  <description>
    returns all US_DocBloc-elements from a string.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer found_usdocblocs - the number of found US_DocBlocs in the string
    array all_found_usdocblocs - the individual US_DocBlocs found in the string
  </retvals>
  <parameters>
    string String - a string, from which to retrieve the US_DocBlocs
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, all, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetAllUSDocBlocsFromString", "String", "must be a string ", -1) return nil end
  local Array={}
  local count=0
  for k in string.gmatch(String, "<(US_DocBloc.-</US_DocBloc>)") do
    count=count+1
    Array[count]="<"..k
  end
  return count, Array
end

function ultraschall.Docs_GetUSDocBloc_Slug(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Slug</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string slug = ultraschall.Docs_GetUSDocBloc_Slug(string String)</functioncall>
  <description>
    returns the slug from an US_DocBloc-element
    
    returns nil in case of an error
  </description>
  <retvals>
    string slug - the slug, as stored in the USDocBloc
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the slug from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, slug, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Slug", "String", "must be a string", -1) return nil end
  return String:match("<slug>(.-)</slug>")
end

function ultraschall.Docs_GetUSDocBloc_Title(String, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Title</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string title, string spok_lang = ultraschall.Docs_GetUSDocBloc_Title(string String, integer index)</functioncall>
  <description>
    returns the title from an US_DocBloc-element.
    There can be multiple titles, e.g. in multiple languages
    
    returns nil in case of an error
  </description>
  <retvals>
    string title - the title, as stored in the USDocBloc
    string spok_lang - the language, in which the title is stored
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the title from
    integer index - the index of the title to get, starting with 1 for the first title
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, title, languages, spoken, spok_lang, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Title", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Title", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Title", "index", "must be >0", -3) return nil end
  local counter=0
  local title, spok_lang
  for k in string.gmatch(String, "(<title.->.-)</title>") do
    counter=counter+1
    if counter==index then title=k:match("<title.->(.*)") spok_lang=k:match("spok_lang=\"(.-)\".->") if spok_lang==nil then spok_lang="" end return title, spok_lang end
  end
end


function ultraschall.Docs_GetUSDocBloc_Description(String, unindent_description, index, i)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Description</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string description, string markup_type, string markup_version, string indent, optional string language, optional string prog_lang = ultraschall.Docs_GetUSDocBloc_Description(string String, boolean unindent_description, integer index)</functioncall>
  <description>
    returns the description-text from an US_DocBloc-element.
    There can be multiple descriptions, e.g. in multiple languages
    
    It will remove automatically indentation(as requested by the description-tag of the US_DocBloc), if unindent_description==true.
    If no indentation is requested by the description-tag, it will assume default(the indentation of the first line will be applied to all other lines).
    
    returns nil in case of an error
  </description>
  <retvals>
    string description - the description-text found in the USDocBloc in the string
    string markup_type - the markup-type the description is written in
    string markup_version - the version of the markup-language, in which the description is written in
    string indent - the indentation of the text; can be either
                  -   as_typed - keeps the text, as it is
                  -   minus_starts_line - will throw away everything from start of the line until(and including) the first - in it
                  -   preceding_spaces - will remove all spaces/tabs in the beginning of each line
                  -   default - will take the indentation of the first line and apply it to each of the following lines
    string language - the language, in which the description is written in; "", if not set
    string prog_lang - the programming-language, in which the description is written in; ", if not set
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the description from
    boolean unindent_description - true, will remove indentation as given in the description-tag; false, return the text as it is
    integer index - the index of the description to get, starting with 1 for the first description
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, description, languages, spoken, spok_lang, indentation, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Description", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Description", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Description", "index", "must be >0", -3) return nil end
  if type(unindent_description)~="boolean" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Description", "unindent_description", "must be a boolean", -4) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<description.->.-</description>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end
  
  if found~=true then return end
  
  local Description=String:match("<description.->.-\n(.-)\n%s*</description>")
  local markup_type=String:match("markup_type=\"(.-)\"")
  local markup_version=String:match("markup_version=\"(.-)\"")
  local indent=String:match("indent=\"(.-)\"")
  local language=String:match("spok_lang=\"(.-)\"")
  local prog_language=String:match("prog_lang=\"(.-)\"")
  if language==nil then language="" end
  if indent==nil then indent="default" end
  if prog_language==nil then prog_language="" end
  if markup_type==nil then markup_type="plaintext" end
  if markup_version==nil then markup_version="" end
  if unindent_description~=false then 
    --if i=="GetSetTrackSendInfo_String" then print2(Description) end
    Description=ultraschall.Docs_RemoveIndent(Description, indent, i)
  end
  return Description, markup_type, markup_version, indent, language, prog_language
end

function ultraschall.Docs_GetUSDocBloc_TargetDocument(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_TargetDocument</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string target_document = ultraschall.Docs_GetUSDocBloc_TargetDocument(string String)</functioncall>
  <description>
    returns the target-document from an US_DocBloc-element.
    The target-document is the document, into which the converted DocBloc shall be stored into.
    
    returns nil in case of an error
  </description>
  <retvals>
    string target_document - the target-document, into which the converted US_DocBloc shall be stored into
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the target-document-entry from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, target-document, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_TargetDocument", "String", "must be a string", -1) return nil end
  return String:match("<target_document>(.-)</target_document>")
end

function ultraschall.Docs_GetUSDocBloc_SourceDocument(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_SourceDocument</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string source_document = ultraschall.Docs_GetUSDocBloc_SourceDocument(string String)</functioncall>
  <description>
    returns the source-document from an US_DocBloc-element.
    The source-document is the document, into which the converted DocBloc shall be stored into.
    
    returns nil in case of an error
  </description>
  <retvals>
    string source_document - the source-document, into which the converted US_DocBloc shall be stored into
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the source-document-entry from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, source-document, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_SourceDocument", "String", "must be a string", -1) return nil end
  return String:match("<source_document>(.-)</source_document>")
end

function ultraschall.Docs_GetUSDocBloc_ChapterContext(String, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_ChapterContext</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer count, array chapters, string spok_lang = ultraschall.Docs_GetUSDocBloc_ChapterContext(string String, integer index)</functioncall>
  <description>
    returns the chapters and subchapters, in which the US_DocBloc shall be stored into
    A US_DocBloc can have multiple chapter-entries, e.g. for multiple languages.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer count - the number of chapters found
    array chapters - the chapternames as an array
    string spok_lang - the language of the chapters; "", if no language is given
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the source-document-entry from
    integer index - the index of the chapter-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, chapters, spoken languages, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_ChapterContext", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_ChapterContext", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_ChapterContext", "index", "must be >0", -3) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<chapter_context.->.-</chapter_context>)") do
  
    counter=counter+1
    if counter==index then String=k found=true end
  end
  
  if found~=true then return 0 end
    
  local language=String:match("spok_lang=\"(.-)\"")
  if language==nil then language="" end
  
  local Chapters=String:match("<chapter_context.->.-\n(.*)\n.-</chapter_context>")
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(Chapters)
  for i=1, count do
    split_string[i]=split_string[i]:match("%s*(.*)")    
  end
  return count, split_string, language
end


-- add numerous of these elements, so you can have multiple spok_langs
function ultraschall.Docs_GetUSDocBloc_Tags(String, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Tags</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer count, array tags, string spok_lang = ultraschall.Docs_GetUSDocBloc_Tags(string String, integer index)</functioncall>
  <description>
    returns the tags of an US_DocBloc-entry
    A US_DocBloc can have multiple tag-entries, e.g. for multiple languages.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer count - the number of tags found
    array tags - the tags as an array
    string spok_lang - the language of the tags; "" if no language is given
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the tags-entry from
    integer index - the index of the tags-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, tags, spoken languages, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Tags", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Tags", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Tags", "index", "must be >0", -3) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<tags.->.-</tags>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return 0 end
    
  local language=String:match("spok_lang=\"(.-)\"")
  if language==nil then language="" end
  
  local Tags=String:match("<tags.->(.-)</tags>")
  local count, split_string = ultraschall.CSV2IndividualLinesAsArray(Tags)
  for i=1, count do
    split_string[i]=split_string[i]:match("%s*(.*)")
  end
  
  return count, split_string, language
end

function ultraschall.Docs_GetUSDocBloc_Params(String, unindent_description, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Params</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer parmcount, table Params, string markuptype, string markupversion, string prog_lang, string spok_lang, string indent = ultraschall.Docs_GetUSDocBloc_Params(string String, boolean unindent_description, integer index)</functioncall>
  <description>
    returns the parameters of an US_DocBloc-entry
    A US_DocBloc can have multiple parameter-entries, e.g. for multiple languages.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer parmcount - the number of parameters found
    table Params - all parameters found, as an array
                 -   Params[index][1] - parametername
                 -   Params[index][2] - parameterdescription
    string markuptype - the markuptype found; if no markuptype is given, it returns "plaintext"
    string markupversion - the version of the markuptype found; "", if not given
    string prog_lang - the programming-language used in these parameters; "", if not given
    string spok_lang - the spoken-language used in these parameters; "", if not given
    string indent - the type of indentation you want to remove
                  -   as_typed - keeps the text, as it is
                  -   minus_starts_line - will throw away everything from start of the line until(and including) the first - in it
                  -   preceding_spaces - will remove all spaces/tabs in the beginning of each line
                  -   default - will take the indentation of the first line and apply it to each of the following lines
                  - That means, indentation relative to the first line is kept.
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the parameter-entry from
    boolean unindent_description - true, will remove indentation as given in the parameter-tag; false, return the text as it is
    integer index - the index of the parameter-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, parameters, spoken languages, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Params", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Params", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Params", "index", "must be >0", -3) return nil end
  if type(unindent_description)~="boolean" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Params", "unindent_description", "must be a boolean", -4) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<parameters.->.-</parameters>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return 0 end
  
  local parms=String:match("(<parameters.->.-)</parameters>")
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(parms)
  local Parmcount=0
  local Params={}
  for i=1, count do
    split_string[i]=split_string[i]:match("%s*(.*)")
  end
  for i=2, count do
    if split_string[i]:match("%-")==nil then
    elseif split_string[i]:sub(1,1)~="-" then
      Parmcount=Parmcount+1
      Params[Parmcount]={}
      Params[Parmcount][1], Params[Parmcount][2]=split_string[i]:match("(.-)%-(.*)")
      Params[Parmcount][1]=Params[Parmcount][1].."\0"
      Params[Parmcount][1]=Params[Parmcount][1]:match("(.*) %s*\0")
    else
      Params[Parmcount][2]=Params[Parmcount][2].."\n"..split_string[i]:sub(2,-1)
    end
  end
  local markuptype=split_string[1]:match("markup_type=\"(.-)\"")
  if markuptype==nil then markuptype="plaintext" end
  local markupversion=split_string[1]:match("markup_version=\"(.-)\"")
  if markupversion==nil then markupversion="" end
  local prog_lang=split_string[1]:match("prog_lang=\"(.-)\"")
  if prog_lang==nil then prog_lang="*" end
  local spok_lang=split_string[1]:match("spok_lang=\"(.-)\"")
  if spok_lang==nil then spok_lang="" end
  local indent=split_string[1]:match("indent=\"(.-)\"")
  if indent==nil then indent="default" end
  
  if unindent_description~=false then 
    for i=1, Parmcount do
      Params[i][2]=ultraschall.Docs_RemoveIndent(Params[i][2], indent)
    end
  end
  
  return Parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent
end

function ultraschall.Docs_GetUSDocBloc_Retvals(String, unindent_description, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Retvals</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer retvalscount, table retvals, string markuptype, string markupversion, string prog_lang, string spok_lang, string indent = ultraschall.Docs_GetUSDocBloc_Retvals(string String, boolean unindent_description, integer index)</functioncall>
  <description>
    returns the retvals of an US_DocBloc-entry
    A US_DocBloc can have multiple retvals-entries, e.g. for multiple languages.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer retvalscount - the number of retvals found
    array retvals - all retvals found, as an array
                 -   retvals[index][1] - retvalsname
                 -   retvals[index][2] - retvalsdescription
    string markuptype - the markuptype found; if no markuptype is given, it returns "plaintext"
    string markupversion - the version of the markuptype found; "", if not given
    string prog_lang - the programming-language used in these retvals; "", if not given
    string spok_lang - the spoken-language used in these retvals; "", if not given
    string indent - the type of indentation you want to remove
                  -   as_typed - keeps the text, as it is
                  -   minus_starts_line - will throw away everything from start of the line until(and including) the first - in it
                  -   preceding_spaces - will remove all spaces/tabs in the beginning of each line
                  -   default - will take the indentation of the first line and apply it to each of the following lines
                  - That means, indentation relative to the first line is kept.
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the retvals-entry from
    boolean unindent_description - true, will remove indentation as given in the retvals-tag; false, return the text as it is
    integer index - the index of the retvals-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, retvals, spoken languages, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Retvals", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Retvals", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Retvals", "index", "must be >0", -3) return nil end
  if type(unindent_description)~="boolean" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Retvals", "unindent_description", "must be a boolean", -4) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<retvals.->.-</retvals>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return 0 end
  
  local parms=String:match("(<retvals.->.-)</retvals>")
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(parms)
  local Parmcount=0
  local Params={}
  
  for i=1, count do
    split_string[i]=split_string[i]:match("%s*(.*)")
  end

  for i=2, count do
    if split_string[i]:match("%-")==nil then
    elseif split_string[i]:sub(1,1)~="-" then
      Parmcount=Parmcount+1
      Params[Parmcount]={}
      Params[Parmcount][1], Params[Parmcount][2]=split_string[i]:match("(.-)%-(.*)")
      Params[Parmcount][1]=Params[Parmcount][1].."\0"
      Params[Parmcount][1]=Params[Parmcount][1]:match("(.*) %s*\0")
    else
      Params[Parmcount][2]=Params[Parmcount][2].."\n"..split_string[i]:sub(2,-1)
    end
  end
  local markuptype=split_string[1]:match("markup_type=\"(.-)\"")
  if markuptype==nil then markuptype="plaintext" end
  local markupversion=split_string[1]:match("markup_version=\"(.-)\"")
  if markupversion==nil then markupversion="" end
  local prog_lang=split_string[1]:match("prog_lang=\"(.-)\"")
  if prog_lang==nil then prog_lang="*" end
  local spok_lang=split_string[1]:match("spok_lang=\"(.-)\"")
  if spok_lang==nil then spok_lang="" end
  local indent=split_string[1]:match("indent=\"(.-)\"")
  if indent==nil then indent="default" end
  
  if unindent_description~=false then 
    for i=1, Parmcount do
      Params[i][2]=ultraschall.Docs_RemoveIndent(Params[i][2], indent)
    end
  end
  
  return Parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent
end

function ultraschall.Docs_GetUSDocBloc_Functioncall(String, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Functioncall</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string functioncall, string prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(string String, integer index)</functioncall>
  <description>
    returns the functioncall-entries from an US_DocBloc-element
    
    There can be multiple functioncall-entries, e.g. for multiple programming-languages
    
    returns nil in case of an error
  </description>
  <retvals>
    string functioncall - the functioncall, as stored in the USDocBloc
    string prog_lang - the used programming language
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the functioncall-entry from
    integer index - the index of the functioncall, if there are multiple ones; beginning with 1
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, functioncall, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Functioncall", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Functioncall", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Functioncall", "index", "must be >0", -3) return nil end

  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<functioncall.->.-</functioncall>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return end
  
  return String:match("<functioncall.->(.-)</functioncall>"), String:match("prog_lang=\"(.-)\"")
end

function ultraschall.Docs_GetUSDocBloc_Requires(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Requires</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer count, array requires, array requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(string String)</functioncall>
  <description>
    returns the requires-entries from an US_DocBloc-element
    
    returns nil in case of an error
  </description>
  <retvals>
    integer count - the number of required elements found in the require-tag
    array requires - the requires found; of the format element=versionnumber, e.g. "Reaper=5.978"
    array requires_alt - like requires, but the index is the required element, while the value is the versionnumber, e.g requires_alt["Reaper"]="5.978"
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the requires-entry from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, requires, require, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Requires", "String", "must be a string", -1) return nil end
  local requires=String:match("<requires>.-\n(.*)</requires>")
  if requires==nil then return 0, {}, {} end
  requires=string.gsub("\n"..requires, "\n%s*", "\n"):sub(2,-1)
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(requires)
  local split_string2={}
  for i=count, 1, -1 do
    if split_string[i]:match("(.-)=")~=nil then
      split_string2[split_string[i]:match("(.-)=")]=split_string[i]:match("=(.*)")
    else
      table.remove(split_string, i)
      count=count-1
    end
  end
  return count, split_string, split_string2
end

function ultraschall.Docs_GetUSDocBloc_PreviousChapter(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_PreviousChapter</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string previous_chapter = ultraschall.Docs_GetUSDocBloc_PreviousChapter(string String)</functioncall>
  <description>
    returns the slug of the previous chapter of an US_DocBloc-element
    
    returns nil in case of an error
  </description>
  <retvals>
    string previous_chapter - the slug of the previous-chapter, as stored in the USDocBloc
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the slug of the previous chapter from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, previous chapter, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_PreviousChapter", "String", "must be a string", -1) return nil end
  return String:match("<previous_chapter>(.-)</previous_chapter>")
end


function ultraschall.Docs_GetUSDocBloc_NextChapter(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_NextChapter</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string next_chapter = ultraschall.Docs_GetUSDocBloc_NextChapter(string String)</functioncall>
  <description>
    returns the slug of the next chapter of an US_DocBloc-element
    
    returns nil in case of an error
  </description>
  <retvals>
    string next_chapter - the slug of the next-chapter, as stored in the USDocBloc
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the slug of the next chapter from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, next chapter, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_NextChapter", "String", "must be a string", -1) return nil end
  return String:match("<next_chapter>(.-)</next_chapter>")
end

--A_1=ultraschall.GetStringFromClipboard_SWS("")
--A0,CCC=ultraschall.Docs_GetAllUSDocBlocsFromString(A_1)
--B=ultraschall.Docs_GetUSDocBloc_Slug(CCC[1])
--A1, A2, A3, A4, A5, A6, A7=ultraschall.Docs_GetUSDocBloc_NextChapter(CCC[1], 1)
--print2(A1)

--AAA=ultraschall.Docs_RemoveIndent(ultraschall.GetStringFromClipboard_SWS(""), "preceding_spaces")
--print2(AAA)

