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

function ultraschall.Docs_ConvertPlainTextToHTML(text, nobsp, ignore_pre)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_ConvertPlainTextToHTML</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string html_text = ultraschall.Docs_ConvertPlainTextToHTML(string String, optional boolean nobsp, optional boolean ignore_pre)</functioncall>
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
    optional boolean nobsp - true, keep tabs and whitespaces as they are; false or nil, replace tabs with &nbsp;&nbsp;&nbsp;&nbsp; and two whitespaces in a row with two &nbsp;&nbsp;
    optional boolean ignore_pre - true, do not insert <br> between lines using <pre> and </pre>; false or nil; always end each line with <br>
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
  if ignore_pre~=true then
    text=string.gsub(text, "\r", "")
    text=string.gsub(text, "\n", "<br/>\n")
  else
    local text2=""
    local pre
    for k in string.gmatch(text.."\n", "(.-)\n") do
      if k:match("<pre>")~=nil then pre=true end
      if k:match("</pre>")~=nil then pre=false end
      if pre~=true then
        text2=text2..k.."<br>\n"
      else
        text2=text2..k.."\n"
      end
      --print2(k)
    end
    text=text2
  end
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
  --if type(String)~="string" and i==nil then print2(String) end
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_RemoveIndent", "String", "must be a string", -1) return nil end
  if type(indenttype)~="string" then ultraschall.AddErrorMessage("Docs_RemoveIndent", "indenttype", "must be a string", -2) return nil end
  if indenttype=="as_typed" then return String end
  if indenttype=="minus_starts_line" then return string.gsub("\n"..String, "\n.-%-", "\n"):sub(2,-1) end
  if indenttype=="preceding_spaces" then  return string.gsub("\n"..String, "\n%s*", "\n"):sub(2,-1) end
  if indenttype=="default" then 
    local Length=String:match("(%s*)")
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
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetAllUSDocBlocsFromString", "String", "must be a string ", -1) return -1 end
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
  
  --local Description=String:match("<description.->.-\n(.-)\n%s*</description>") -- old line, remove, if no problem arised
  local Description=String:match("<description.->.-\n(.-)</description>")
  if Description:match("\n") then Description=Description:match("(.*)\n") end
  
  if Description==nil then Description="" end
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
      Params[Parmcount][1]=Params[Parmcount][1]:match("(.-)%s*$")
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
      Params[Parmcount][1]=Params[Parmcount][1]:match("(.-)%s*$")
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

function ultraschall.Docs_GetUSDocBloc_Changelog(String, unindent_description, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Changelog</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer changelogscount, table changelogs = ultraschall.Docs_GetUSDocBloc_Changelog(string String, boolean unindent_description, integer index)</functioncall>
  <description>
    returns the changelog-entries of an US_DocBloc-entry
    
    this returns the version-number of the software and the changes introduced in that version inside a table.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer changelogscount - the number of changelog-entries found
    array changelogs - all changelogs found, as an array
                     -   changelogs[index][1] - software-version of the introduction of the change, like "Reaper 6.23" or "US_API 4.2.006"
                     -   changelogs[index][2] - a description of the change
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the changelog-entry from
    boolean unindent_description - true, will remove indentation as given in the changelog-tag; false, return the text as it is
    integer index - the index of the changelog-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, changelog, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Changelog", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Changelog", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Changelog", "index", "must be >0", -3) return nil end
  if type(unindent_description)~="boolean" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Changelog", "unindent_description", "must be a boolean", -4) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<changelog.->.-</changelog>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return 0 end
  
  local parms=String:match("(<changelog.->.-)</changelog>")
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
  
  if indent==nil then indent="default" end
  
  if unindent_description~=false then 
    for i=1, Parmcount do
      Params[i][2]=ultraschall.Docs_RemoveIndent(Params[i][2], indent)
    end
  end
  
  return Parmcount, Params
end

function ultraschall.Docs_GetUSDocBloc_LinkedTo(String, unindent_description, index)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_LinkedTo</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer linked_to_count, table links, string description = ultraschall.Docs_GetUSDocBloc_LinkedTo(string String, boolean unindent_description, integer index)</functioncall>
  <description>
    returns the linked_to-tags of an US_DocBloc-entry
    
    returns nil in case of an error
  </description>
  <retvals>
    integer linked_to_count - the number of linked_to-entries found
    array links - all links found, as an array
                 -   links[index]["location"] - the location of the link, either inline(for slugs inside the same document) or url(for links/urls/uris outside of it)
                 -   links[index]["link"] - the slug to the element inside the document/the url or uri linking outside of the document
                 -   links[index]["description"] - a description for this link
    string description - a description for this linked_to-tag
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the linked_to-entry from
    boolean unindent_description - true, will remove indentation as given in the changelog-tag; false, return the text as it is
    integer index - the index of the linked_to-entries, starting with 1 for the first
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, linked_to, usdocbloc</tags>
</US_DocBloc>
]]

--[[
    linked_to tags work as follows:
    <linked_to desc="a description for the links in this linked_to-tag">
        inline: slug
              description
              optional second line of description
              optional third line of description
              etc
        url: actual-url.com
              description
              optional second line of description
              optional third line of description
              etc
    </linked_to>
    
    There can be multiple link-tags inside a usdocml-tag!
--]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_LinkedTo", "String", "must be a string", -1) return nil end
  if math.type(index)~="integer" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_LinkedTo", "index", "must be an integer", -2) return nil end
  if index<1 then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_LinkedTo", "index", "must be >0", -3) return nil end
  if type(unindent_description)~="boolean" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_LinkedTo", "unindent_description", "must be a boolean", -4) return nil end
  
  local counter=0
  local title, spok_lang, found
  for k in string.gmatch(String, "(<linked_to.->.-</linked_to>)") do
    counter=counter+1
    if counter==index then String=k found=true end
  end  
  
  if found~=true then return 0 end
  
  local parms=String:match("(<linked_to.->.-)</linked_to>")
  local desc=parms:match("<linked_to.-desc=\"(.-)\">")
  if desc==nil then desc="" end
  local count, split_string = ultraschall.SplitStringAtLineFeedToArray(parms)
  local Linkedcount=0
  local LinkedTo={}
  
  for i=1, count do
    split_string[i]=split_string[i]:match("%s*(.*)")
  end

  for i=2, count-1 do
    if split_string[i]:match(":") then 
      Linkedcount=Linkedcount+1
      LinkedTo[Linkedcount]={}
      LinkedTo[Linkedcount]["location"], LinkedTo[Linkedcount]["link"] = split_string[i]:match("(.-):(.*)")
    else
      if LinkedTo[Linkedcount]["description"]==nil then LinkedTo[Linkedcount]["description"]="" end
      LinkedTo[Linkedcount]["description"]=LinkedTo[Linkedcount]["description"]..split_string[i].."\n"
    end
  end
  
  if unindent_description~=false then 
    for i=1, Linkedcount do
      LinkedTo[i]["description"]=ultraschall.Docs_RemoveIndent(LinkedTo[i]["description"]:sub(1,-2), "default")
    end
  end
  
  return Linkedcount, LinkedTo, desc
end

function ultraschall.Docs_GetUSDocBloc_Deprecated(US_DocBloc)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Deprecated</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>string what, string when, string alternative = ultraschall.Docs_GetUSDocBloc_Deprecated(string US_DocBloc)</functioncall>
  <description>
    returns the deprecated-tag of an US-DocBloc, which holds the information about, is a function is deprecated and what to use alternatively.
    
    returns nil in case of an error or if no such deprecated-tag exists for this US_DocBloc
  </description>
  <retvals>
    string what - which software deprecated the function "Reaper" or "SWS" or "JS", etc
    string when - since which version is this function deprecated
    string alternative - what is a possible alternative to this function, if existing
    string removed - function got removed
  </retvals>
  <parameters>
    string US_DocBloc - a string which hold a US_DocBloc to retrieve the deprecated-tag-attributes from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, deprecated, usdocbloc</tags>
</US_DocBloc>
]]  
  if type(US_DocBloc)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Deprecated", "US_DocBloc", "must be a string", -1) return end
  local Deprecated=US_DocBloc:match("<deprecated .*/>")
  if Deprecated == nil then return end
  local DepreWhat, Depr_SinceWhen=Deprecated:match("since_when=\"(.-) (.-)\"")
  local Depr_Alternative=Deprecated:match("alternative=\"(.-)\"")
  local Depr_Removed=Deprecated:match("removed=\"(.-)\"")
  --print2(Depr_Removed)
  return DepreWhat, Depr_SinceWhen, Depr_Alternative, Depr_Removed~=nil
end

function ultraschall.Docs_GetReaperApiFunction_Description(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string description = ultraschall.Docs_GetReaperApiFunction_Description(string functionname)</functioncall>
  <description>
    returns the description of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string description - the description of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, description, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "function not found", -2) return end

  local Description, markup_type, markup_version

  Description, markup_type, markup_version  = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  if Description==nil then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Description", "functionname", "no description existing", -3) return end

  Description = string.gsub(Description, "&lt;", "<")
  Description = string.gsub(Description, "&gt;", ">")
  Description = string.gsub(Description, "&amp;", "&")
  return Description, markup_type, markup_version
end



function ultraschall.Docs_GetReaperApiFunction_Call(functionname, proglang)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Call</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string functioncall = ultraschall.Docs_GetReaperApiFunction_Call(string functionname, integer proglang)</functioncall>
  <description>
    returns the functioncall of a function from the documentation    
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
    integer proglang - the programming-language for which you want to get the function-call
                     - 1, C
                     - 2, EEL2
                     - 3, Lua
                     - 4, Python
  </parameters>
  <retvals>
    string functioncall - the functioncall of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, functioncall, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "must be a string", -1) return nil end
  if math.type(proglang)~="integer" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "must be an integer", -2) return nil end
  if proglang<1 or proglang>4 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "proglang", "no such programming language available", -3) return nil end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "function not found", -4) return end

  local Call, prog_lang
  Call, prog_lang  = ultraschall.Docs_GetUSDocBloc_Functioncall(ultraschall.Docs_ReaperApiDocBlocs[found], proglang)
  if Call==nil then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Call", "functionname", "no such programming language available", -5) return end
  Call = string.gsub(Call, "&lt;", "<")
  Call = string.gsub(Call, "&gt;", ">")
  Call = string.gsub(Call, "&amp;", "&")
  return Call, prog_lang
end

function ultraschall.Docs_LoadReaperApiDocBlocs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_GetReaperApiFunction_Description()</functioncall>
  <description>
    (re-)loads the api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, reaper</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
  ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
  ultraschall.Docs_ReaperApiDocBlocs_Slug={}
  ultraschall.Docs_ReaperApiDocBlocs_Titles={}
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
    ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    ultraschall.Docs_ReaperApiDocBlocs_Slug[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
  end
end

function ultraschall.Docs_FindReaperApiFunction_Pattern(pattern, case_sensitive, include_descriptions, include_tags, include_retvalnames, include_paramnames)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindReaperApiFunction_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_functions_count, table found_functions, table found_functions_desc = ultraschall.Docs_FindReaperApiFunction_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for functionnames in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned tables found_functions is of the format:
      found_functions_desc[function_index]["functionname"] - the name of the function
      found_functions_desc[function_index]["description"] - the entire description
      found_functions_desc[function_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_functions_desc[function_index]["desc_startoffset"] - the startoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["desc_endoffset"] - the endoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["extension"] - the extension used, like Reaper, SWS, JS, ReaImGui, Osara, etc
      found_functions_desc[function_index]["extension_version"] - the version of the extension
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_functions_count - the number of found functions that follow the search-pattern
    table found_functions - a table with all found functions that follow the search pattern
    table found_functions_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a function
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, api, function, extensions, description, pattern, tags, reaper</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_tags", "must be a string", -4) return -1 end
  if include_retval~=nil and type(include_retval)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_retval", "must be a string", -5) return -1 end
  if include_paramnames~=nil and type(include_paramnames)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_paramnames", "must be a string", -6) return -1 end
  
  -- include_retvalnames, include_paramnames not yet implemented
  -- probably needs RetVal/Param-function that returns datatypes and name independently from each other
  -- which also means: all functions must return values with a proper, descriptive name(or at least retval)
  --                   or this breaks -> Doc-CleanUp-Work...Yeah!!! (looking forward to it, actually)
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  local found_this_time=false
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperApiDocBlocs[i], 1)      
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperApiDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}        
        FoundInformation[Found_count+1]["functionname"]=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_ReaperApiDocBlocs_Titles[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["functionname"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      local A,B,C,D,E=ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
      if B[2]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[2]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      elseif B[1]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[1]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      else
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]="", -1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

--A,B,C=ultraschall.Docs_FindReaperApiFunction_Pattern("tudel", false, false, 10, 14, nil, nil, true)

function ultraschall.Docs_GetReaperApiFunction_Retvals(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Retvals</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retvalscount, table retvals = ultraschall.Docs_GetReaperApiFunction_Retvals(string functionname)</functioncall>
  <description>
    returns the returnvalues of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    Table retvals is of the following structure:
      retvals[retvalindex]["datatype"] - the datatype of this retval
      retvals[retvalindex]["name"] - the name of this retval
      retvals[retvalindex]["description"] - the description for this retval
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose retvals you want to get
  </parameters>
  <retvals>
    integer retvalscount - the number of found returnvalues
    table retvals - a table with all return-values
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, retvals, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Retvals", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Retvals", "functionname", "function not found", -2) return -1 end

  local retvalscount, retvals, markuptype, markupversion, prog_lang, spok_lang, indent = 
          ultraschall.Docs_GetUSDocBloc_Retvals(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  local retvals2={}
  for i=1, retvalscount do
    retvals2[i]={}
    if retvals[i][1]:match("optional")~=nil then 
      retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.- .-) (.*)")
    else
      retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.-) (.*)")
    end
    if retvals2[i]["name"]==nil then retvals2[i]["name"]="retval" end
    if retvals2[i]["datatype"]==nil then retvals2[i]["datatype"]=retvals[i][1] end
    retvals2[i]["description"]=retvals[i][2]
    
  end
  
  return retvalscount, retvals2
end

--A={ultraschall.Docs_GetReaperApiFunction_Retvals("ImGui_ButtonFlags_MouseButtonLeft")}

function ultraschall.Docs_GetReaperApiFunction_Params(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Params</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer paramscount, table params = ultraschall.Docs_GetReaperApiFunction_Params(string functionname)</functioncall>
  <description>
    returns the parameters of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    Table params is of the following structure:
      params[paramsindex]["datatype"] - the datatype of this parameter
      params[paramsindex]["name"] - the name of this parameter
      params[paramsindex]["description"] - the description for this parameter
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose parameter you want to get
  </parameters>
  <retvals>
    integer paramscount - the number of found parameters
    table params - a table with all parameters
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, params, parameters, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Params", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Params", "functionname", "function not found", -2) return -1 end

  local parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = 
      ultraschall.Docs_GetUSDocBloc_Params(ultraschall.Docs_ReaperApiDocBlocs[found], true, 1)
  local Params2={}
  for i=1, parmcount do
    Params2[i]={}
    if Params[i][1]:match("optional")~=nil then 
      Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.- .-) (.*)")
    else
      Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.-) (.*)")
    end
    if Params2[i]["name"]==nil then Params2[i]["name"]="retval" end
    if Params2[i]["datatype"]==nil then Params2[i]["datatype"]=Params[i][1] end
    Params2[i]["description"]=Params[i][2]
  end
  
  return parmcount, Params2
end

--A={ultraschall.Docs_GetReaperApiFunction_Params("gfx.getchar")}

function ultraschall.Docs_GetReaperApiFunction_Tags(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Tags</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer tags_count, table tags = ultraschall.Docs_GetReaperApiFunction_Tags(string functionname)</functioncall>
  <description>
    returns the tags of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose tags you want to get
  </parameters>
  <retvals>
    integer tags_count - the number of tags for this function
    table tags - the tags of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, tags, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Tags", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Tags", "functionname", "function not found", -2) return -1 end
  
  local count, tags, spok_lang = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperApiDocBlocs[found], 1)
  
  return count, tags
end

--A={ultraschall.Docs_GetReaperApiFunction_Tags("CF_GetClipboard")}


function ultraschall.Docs_GetReaperApiFunction_Requires(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Requires</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer requires_count, table requires, table requires_alt = ultraschall.Docs_GetReaperApiFunction_Requires(string functionname)</functioncall>
  <description>
    returns the requires of a function from the documentation
    
    The requires usually mean dependencies of extensions with a specific version or specific Reaper-versions
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose requires you want to get
  </parameters>
  <retvals>
    integer requires_count - the number of requires for this function
    table requires - the requires of this function
    table requires_alt - like requires but has the require name as index, like Reaper or SWS
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, requires, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Requires", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Requires", "functionname", "function not found", -2) return -1 end
  
  local count, requires, requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_ReaperApiDocBlocs[found], 1)
  
  return count, requires, requires_alt
end

function ultraschall.Docs_GetAllReaperApiFunctionnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Docs_GetAllReaperApiFunctionnames</slug>
    <requires>
      Ultraschall=4.8
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>table slugs, table titles = ultraschall.Docs_GetAllReaperApiFunctionnames()</functioncall>
    <description>
      returns tables with all slugs and all titles of all Reaper-API-functions(usually the functionnames)
    </description>
    <retval>
      table slugs - all slugs(usually the functionnames) of all Reaper API-functions
      table titles - all titles(usually the functionnames) of all Reaper API-functions
    </retval>
    <chapter_context>
      Reaper Docs
    </chapter_context>
    <target_document>US_Api_DOC</target_document>
    <source_document>Modules/ultraschall_doc_engine.lua</source_document>
    <tags>documentation, get, slugs, docs, description, reaper</tags>
  </US_DocBloc>
  ]]
  if ultraschall.Docs_ReaperApiDocBlocs==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end

  return ultraschall.Docs_ReaperApiDocBlocs_Slug, ultraschall.Docs_ReaperApiDocBlocs_Titles
end

function ultraschall.Docs_LoadReaperConfigVarsDocBlocs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_LoadReaperConfigVarsDocBlocs</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_LoadReaperConfigVarsDocBlocs()</functioncall>
  <description>
    (re-)loads the config-var api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, config variables, config vars, configvars</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperConfigVarsDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Config_Variables.USDocML")
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Count, ultraschall.Docs_ReaperConfigVarsDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperConfigVarsDocBlocs)
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug={}
  ultraschall.Docs_ReaperConfigVarsDocBlocs_Titles={}
  for i=1, ultraschall.Docs_ReaperConfigVarsDocBlocs_Count do 
    ultraschall.Docs_ReaperConfigVarsDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)
    ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)
  end
end


--A=ultraschall.Docs_LoadReaperConfigVarsDocBlocs()

--B={ultraschall.Docs_GetReaperApiFunction_Call(A[10], 3)}

function ultraschall.Docs_FindReaperConfigVar_Pattern(pattern, case_sensitive, include_descriptions, include_tags)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindReaperConfigVar_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_configvar_count, table found_configvars, table found_config_vars_desc = ultraschall.Docs_FindReaperConfigVar_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for configvariables in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned table found_config_vars_desc is of the format: 
      found_config_vars_desc[configvar_index]["configvar"] - the name of the found config variable
      found_config_vars_desc[configvar_index]["description"] - the entire description
      found_config_vars_desc[configvar_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_config_vars_desc[configvar_index]["desc_startoffset"] - the startoffset of the found pattern; -1, if pattern not found in description
      found_config_vars_desc[configvar_index]["desc_endoffset"] - the endoffset of the found pattern; -1, if pattern not found in description
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_configvar_count - the number of found config variables that follow the search-pattern
    table found_configvars - a table with all found config variables that follow the search pattern
    table found_config_vars_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
                               - table will be nil if include_descriptions=false
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a config variable
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, description, pattern, tags, config variables, config vars, configvars</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "include_tags", "must be a string", -4) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperConfigVar_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug==nil then ultraschall.Docs_LoadReaperConfigVarsDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  local found_this_time=false
  for i=1, ultraschall.Docs_ReaperConfigVarsDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], 1)      
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_ReaperConfigVarsDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}
        FoundInformation[Found_count+1]["configvar"]=Title
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      else
        FoundInformation[Found_count+1]={}
        FoundInformation[Found_count+1]["configvar"]=Title
        FoundInformation[Found_count+1]["description_snippet"]=""
        FoundInformation[Found_count+1]["description"]=""
        FoundInformation[Found_count+1]["desc_startoffset"]=-1 -- startoffset of found pattern, so this part can be highlighted
                                                               -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=-1   -- startoffset of found pattern, so this part can be highlighted
                                                               -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_ReaperConfigVarsDocBlocs_Slug[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["configvar"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

function ultraschall.Docs_LoadUltraschallAPIDocBlocs()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_LoadUltraschallAPIDocBlocs</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>ultraschall.Docs_LoadUltraschallAPIDocBlocs()</functioncall>
  <description>
    (re-)loads the Ultraschall-API-api-docblocs from the documentation, used by all Docs_GetReaperApi-functions
  </description>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, load, docs, description, ultraschall api</tags>
</US_DocBloc>
]]
  ultraschall.Docs_ReaperConfigVarsDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Config_Variables.USDocML")
  ultraschall.Docs_US_Functions=""
  for k in io.lines(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/misc/Ultraschall_Api_List_Of_USDocML-Containing_Files.txt") do
    ultraschall.Docs_US_Functions=ultraschall.Docs_US_Functions.."\n"..ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/"..k)
  end
  ultraschall.Docs_US_Functions_USDocBlocs_Count, ultraschall.Docs_US_Functions_USDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_US_Functions)
  ultraschall.Docs_US_Functions_USDocBlocs_Slug={}
  ultraschall.Docs_US_Functions_USDocBlocs_Titles={}
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do 
    ultraschall.Docs_US_Functions_USDocBlocs_Slug[i] = ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
    ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Slug(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
  end
end

--ultraschall.Docs_LoadUltraschallAPIDocBlocs()

function ultraschall.Docs_GetUltraschallApiFunction_Call(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Call</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string functioncall = ultraschall.Docs_GetUltraschallApiFunction_Call(string functionname)</functioncall>
  <description>
    returns the functioncall of an Ultraschall-API-function from the documentation    
    
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string functioncall - the functioncall of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, functioncall, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "function not found", -4) return end
  
  local Call, prog_lang
  Call, prog_lang  = ultraschall.Docs_GetUSDocBloc_Functioncall(ultraschall.Docs_US_Functions_USDocBlocs[found],1)
  
  if Call==nil then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Call", "functionname", "no such programming language available", -5) return end
  Call = string.gsub(Call, "&lt;", "<")
  Call = string.gsub(Call, "&gt;", ">")
  Call = string.gsub(Call, "&amp;", "&")
  return Call
end

--A,B=ultraschall.Docs_GetUltraschallApiFunction_Call("ReadFullFile")

function ultraschall.Docs_GetUltraschallApiFunction_Description(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Description</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>string description = ultraschall.Docs_GetUltraschallApiFunction_Description(string functionname)</functioncall>
  <description>
    returns the description of an Ultraschall-API function from the documentation
  
    returns nil in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose description you want to get
  </parameters>
  <retvals>
    string description - the description of the function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, description, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "function not found", -4) return end
  
  local Description, markup_type, markup_version
  
  Description, markup_type, markup_version  = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  if Description==nil then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Description", "functionname", "no description existing", -3) return end

  Description = string.gsub(Description, "&lt;", "<")
  Description = string.gsub(Description, "&gt;", ">")
  Description = string.gsub(Description, "&amp;", "&")
  return Description, markup_type, markup_version
end

--A,B=ultraschall.Docs_GetUltraschallApiFunction_Description("ReadFullFile")

function ultraschall.Docs_FindUltraschallApiFunction_Pattern(pattern, case_sensitive, include_descriptions, include_tags, include_retvalnames, include_paramnames)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_FindUltraschallApiFunction_Pattern</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer found_functions_count, table found_functions, table found_functions_desc = ultraschall.Docs_FindUltraschallApiFunction_Pattern(string pattern, boolean case_sensitive, optional boolean include_descriptions, optional boolean include_tags)</functioncall>
  <description>
    searches for Ultraschall-API functionnames in the docs, that follow a certain searchpattern(supports Lua patternmatching).
    
    You can also check for case-sensitivity and if you want to search descriptions and tags as well.
    
    the returned tables found_functions is of the format:
      found_functions_desc[function_index]["functionname"] - the name of the function
      found_functions_desc[function_index]["description"] - the entire description
      found_functions_desc[function_index]["description_snippet"] - a snippet of the description that features the found pattern with 10 characters before and after it
      found_functions_desc[function_index]["desc_startoffset"] - the startoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["desc_endoffset"] - the endoffset of the found pattern; -1 if pattern not found in description
      found_functions_desc[function_index]["extension"] - the extension used, like Reaper, SWS, JS, ReaImGui, Osara, etc
      found_functions_desc[function_index]["extension_version"] - the version of the extension
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer found_functions_count - the number of found functions that follow the search-pattern
    table found_functions - a table with all found functions that follow the search pattern
    table found_functions_desc - a table with all found matches within descriptions, including offset. 
                               - Index follows the index of found_functions
  </retvals>
  <parameters>
    string pattern - the search-pattern to look for a function
    boolean case_sensitive - true, search pattern is case-sensitive; false, search-pattern is case-insensitive
    optional boolean include_descriptions - true, search in descriptions; false, don't search in descriptions
    optional boolean include_tags - true, search in tags; false, don't search in tags
  </parameters>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, find, search, docs, api, function, extensions, description, pattern, tags, ultraschall api</tags>
</US_DocBloc>
]]
  if type(pattern)~="string" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "pattern", "must be a string", -1) return -1 end
  if type(case_sensitive)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "case_sensitive", "must be a string", -2) return -1 end
  
  if include_descriptions~=nil and type(include_descriptions)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_descriptions", "must be a string", -3) return -1 end
  if include_tags~=nil and type(include_tags)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_tags", "must be a string", -4) return -1 end
  if include_retval~=nil and type(include_retval)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_retval", "must be a string", -5) return -1 end
  if include_paramnames~=nil and type(include_paramnames)~="boolean" then ultraschall.AddErrorMessage("Docs_FindReaperApiFunction_Pattern", "include_paramnames", "must be a string", -6) return -1 end
  
  -- include_retvalnames, include_paramnames not yet implemented
  -- probably needs RetVal/Param-function that returns datatypes and name independently from each other
  -- which also means: all functions must return values with a proper, descriptive name(or at least retval)
  --                   or this breaks -> Doc-CleanUp-Work...Yeah!!! (looking forward to it, actually)
  local desc_endoffset, desc_startoffset
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end
  if desc_startoffset==nil then desc_startoffset=-10 end
  if desc_endoffset==nil then desc_endoffset=-10 end
  if case_sensitive==false then pattern=pattern:lower() end
  local Found_count=0
  local Found={}
  local FoundInformation={}
  local found_this_time=false
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    -- search for titles
    local Title=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
    if case_sensitive==false then Title=Title:lower() end
    if Title:match(pattern) then
      found_this_time=true
    end
    
    -- search within tags
    if found_this_time==false and include_tags==true then
      local count, tags = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)      
      for a=1, count do
        if case_sensitive==false then tags[a]=tags[a]:lower() end
        if tags[a]:match(pattern) then found_this_time=true break end
      end
    end
    
    -- search within descriptions
    local _temp, Offset1, Offset2
    if found_this_time==false and include_descriptions==true then
      local Description, markup_type = ultraschall.Docs_GetUSDocBloc_Description(ultraschall.Docs_US_Functions_USDocBlocs[i], true, 1)
      Description = string.gsub(Description, "&lt;", "<")
      Description = string.gsub(Description, "&gt;", ">")
      Description = string.gsub(Description, "&amp;", "&")
      if case_sensitive==false then Description=Description:lower() end
      if Description:match(pattern) then
        found_this_time=true
      end
      Offset1, _temp, Offset2=Description:match("()("..pattern..")()")
      if Offset1~=nil then
        if Offset1-desc_startoffset<0 then Offset1=0 else Offset1=Offset1+desc_startoffset end
        FoundInformation[Found_count+1]={}        
        FoundInformation[Found_count+1]["functionname"]=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
        FoundInformation[Found_count+1]["description_snippet"]=Description:sub(Offset1, Offset2-desc_endoffset-1)
        FoundInformation[Found_count+1]["description"]=Description
        FoundInformation[Found_count+1]["desc_startoffset"]=Offset1-desc_startoffset -- startoffset of found pattern, so this part can be highlighted
                                                                                     -- when displaying somewhere later
        FoundInformation[Found_count+1]["desc_endoffset"]=Offset2-1 -- startoffset of found pattern, so this part can be highlighted
                                                                    -- when displaying somewhere later
      end
    end
    
    if found_this_time==true then
      Found_count=Found_count+1
      Found[Found_count]=ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]
      if FoundInformation[Found_count]==nil then
        FoundInformation[Found_count]={}
        FoundInformation[Found_count]["functionname"]=Title
        FoundInformation[Found_count]["description"]=""
        FoundInformation[Found_count]["description_snippet"]=""
        FoundInformation[Found_count]["desc_startoffset"]=-1
        FoundInformation[Found_count]["desc_endoffset"]=-1
      end
      local A,B,C,D,E=ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_US_Functions_USDocBlocs[i], 1)
      if B[2]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[2]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      elseif B[1]~=nil then
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]=B[1]:match("(.-)=(.*)")
        FoundInformation[Found_count]["extension_version"]=tonumber(FoundInformation[Found_count]["extension_version"])
      else
        FoundInformation[Found_count]["extension"], FoundInformation[Found_count]["extension_version"]="", -1
      end
      
    end
    
    found_this_time=false
  end
  return Found_count, Found, FoundInformation
end

--A={ultraschall.Docs_FindUltraschallApiFunction_Pattern("RenderTable", false, true, false, false, false)}

function ultraschall.Docs_GetUltraschallApiFunction_Retvals(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Retvals</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer retvalscount, table retvals = ultraschall.Docs_GetUltraschallApiFunction_Retvals(string functionname)</functioncall>
  <description>
    returns the returnvalues of an Ultraschall API function from the documentation
    
    Table retvals is of the following structure:
      retvals[retvalindex]["datatype"] - the datatype of this retval
      retvals[retvalindex]["name"] - the name of this retval
      retvals[retvalindex]["description"] - the description for this retval
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose retvals you want to get
  </parameters>
  <retvals>
    integer retvalscount - the number of found returnvalues
    table retvals - a table with all return-values
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, retvals, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Retvals", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Retvals", "functionname", "function not found", -4) return end
  
  local retvalscount, retvals, markuptype, markupversion, prog_lang, spok_lang, indent = 
  
  ultraschall.Docs_GetUSDocBloc_Retvals(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  local retvals2={}
  for i=1, retvalscount do
    retvals2[i]={}
    if retvals[i][1]:match("optional")~=nil then 
      retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.- .-) (.*)")
    else
      retvals2[i]["datatype"], retvals2[i]["name"] = retvals[i][1]:match("(.-) (.*)")
    end
    if retvals2[i]["name"]==nil then retvals2[i]["name"]="retval" end
    if retvals2[i]["datatype"]==nil then retvals2[i]["datatype"]=retvals[i][1] end
    retvals2[i]["description"]=retvals[i][2]
    
  end
  
  return retvalscount, retvals2
end

function ultraschall.Docs_GetUltraschallApiFunction_Params(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Params</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer paramscount, table params = ultraschall.Docs_GetUltraschallApiFunction_Params(string functionname)</functioncall>
  <description>
    returns the parameters of an Ultraschall-API function from the documentation

    Table params is of the following structure:
      params[paramsindex]["datatype"] - the datatype of this parameter
      params[paramsindex]["name"] - the name of this parameter
      params[paramsindex]["description"] - the description for this parameter
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose parameter you want to get
  </parameters>
  <retvals>
    integer paramscount - the number of found parameters
    table params - a table with all parameters
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, params, parameters, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Params", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Params", "functionname", "function not found", -4) return end
  
  local parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = 
  
  ultraschall.Docs_GetUSDocBloc_Params(ultraschall.Docs_US_Functions_USDocBlocs[found], true, 1)
  local Params2={}
  for i=1, parmcount do
    Params2[i]={}
    if Params[i][1]:match("optional")~=nil then
      Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.- .-) (.*)")
    else
      Params2[i]["datatype"], Params2[i]["name"] = Params[i][1]:match("(.-) (.*)")
    end
    if Params2[i]["name"]==nil then Params2[i]["name"]="retval" end
    if Params2[i]["datatype"]==nil then Params2[i]["datatype"]=Params[i][1] end
    Params2[i]["description"]=Params[i][2]
  end
  
  return parmcount, Params2
end

--SLEM()
--A={ultraschall.Docs_GetUltraschallApiFunction_Params("ReadFullFile")}

function ultraschall.Docs_GetUltraschallApiFunction_Tags(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Tags</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer tags_count, table tags = ultraschall.Docs_GetUltraschallApiFunction_Tags(string functionname)</functioncall>
  <description>
    returns the tags of an Ultraschall-API function from the documentation

    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose tags you want to get
  </parameters>
  <retvals>
    integer tags_count - the number of tags for this function
    table tags - the tags of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, tags, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Tags", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Tags", "functionname", "function not found", -4) return end
  
  local count, tags, spok_lang = ultraschall.Docs_GetUSDocBloc_Tags(ultraschall.Docs_US_Functions_USDocBlocs[found], 1)
  
  return count, tags
end

--A={ultraschall.Docs_GetUltraschallApiFunction_Tags("ReadFullFile")}


function ultraschall.Docs_GetUltraschallApiFunction_Requires(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Requires</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer requires_count, table requires, table requires_alt = ultraschall.Docs_GetUltraschallApiFunction_Requires(string functionname)</functioncall>
  <description>
    returns the requires of an Ultraschall-API function from the documentation
    
    The requires usually mean dependencies of extensions with a specific version or specific Reaper-versions
  
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose requires you want to get
  </parameters>
  <retvals>
    integer requires_count - the number of requires for this function
    table requires - the requires of this function
    table requires_alt - like requires but has the require name as index, like Reaper or SWS
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, requires, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Requires", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Requires", "functionname", "function not found", -4) return end
  
  local count, requires, requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(ultraschall.Docs_US_Functions_USDocBlocs[found], 1)
  
  return count, requires, requires_alt
end

--A={ultraschall.Docs_GetUltraschallApiFunction_Requires("RenderProject")}


function ultraschall.Docs_GetAllUltraschallApiFunctionnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>Docs_GetAllUltraschallApiFunctionnames</slug>
    <requires>
      Ultraschall=4.8
      Reaper=6.02
      Lua=5.3
    </requires>
    <functioncall>table slugs = ultraschall.Docs_GetAllUltraschallApiFunctionnames()</functioncall>
    <description>
      returns tables with all slugs of all Ultraschall-API-functions and variables
    </description>
    <retval>
      table slugs - all slugs(usually the functionnames) of all Reaper API-functions
      table titles - all titles(usually the functionnames) of all Reaper API-functions
    </retval>
    <chapter_context>
      Reaper Docs
    </chapter_context>
    <target_document>US_Api_DOC</target_document>
    <source_document>Modules/ultraschall_doc_engine.lua</source_document>
    <tags>documentation, get, slugs, docs, description, ultraschall api</tags>
  </US_DocBloc>
  ]]
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  return ultraschall.Docs_US_Functions_USDocBlocs_Slug
end

function ultraschall.Docs_GetReaperApiFunction_Categories(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetReaperApiFunction_Categories</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer categories_count, table categories = ultraschall.Docs_GetReaperApiFunction_Categories(string functionname)</functioncall>
  <description>
    returns the categories of a function from the documentation
    
    Note: for gfx-functions, add gfx. before the functionname
    
    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose categories you want to get
  </parameters>
  <retvals>
    integer categories_count - the number of categories for this function
    table categories - the categories of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, category, reaper</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Categories", "functionname", "must be a string", -1) return -1 end
  if ultraschall.Docs_ReaperApiDocBlocs_Titles==nil then ultraschall.Docs_LoadReaperApiDocBlocs() end
  if ultraschall.Docs_ReaperApiDocBlocs==nil then
    ultraschall.Docs_ReaperApiDocBlocs=ultraschall.ReadFullFile(ultraschall.Api_Path.."DocsSourceFiles/Reaper_Api_Documentation.USDocML")
    ultraschall.Docs_ReaperApiDocBlocs_Count, ultraschall.Docs_ReaperApiDocBlocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.Docs_ReaperApiDocBlocs)
    ultraschall.Docs_ReaperApiDocBlocs_Titles={}
    for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do 
      ultraschall.Docs_ReaperApiDocBlocs_Titles[i]= ultraschall.Docs_GetUSDocBloc_Title(ultraschall.Docs_ReaperApiDocBlocs[i], 1)
    end
  end

  local found=-1
  for i=1, ultraschall.Docs_ReaperApiDocBlocs_Count do
    if ultraschall.Docs_ReaperApiDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetReaperApiFunction_Categories", "functionname", "function not found", -2) return -1 end
  
  local count, categories, spok_lang = ultraschall.Docs_GetUSDocBloc_ChapterContext(ultraschall.Docs_ReaperApiDocBlocs[found], 1)
  
  return count, categories
end


function ultraschall.Docs_GetUltraschallApiFunction_Categories(functionname)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUltraschallApiFunction_Categories</slug>
  <requires>
    Ultraschall=4.8
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer tags_count, table tags = ultraschall.Docs_GetUltraschallApiFunction_Categories(string functionname)</functioncall>
  <description>
    returns the categories of an Ultraschall-API function from the documentation

    returns -1 in case of an error
  </description>
  <parameters>
    string functionname - the name of the function, whose categories you want to get
  </parameters>
  <retvals>
    integer categories_count - the number of categories for this function
    table categories - the categories of this function
  </retvals>
  <chapter_context>
    Reaper Docs
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>Modules/ultraschall_doc_engine.lua</source_document>
  <tags>documentation, get, docs, categories, ultraschall api</tags>
</US_DocBloc>
]]
  if type(functionname)~="string" then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Categories", "functionname", "must be a string", -1) return nil end
  if ultraschall.Docs_US_Functions_USDocBlocs_Titles==nil then ultraschall.Docs_LoadUltraschallAPIDocBlocs() end

  local found=-1
  for i=1, ultraschall.Docs_US_Functions_USDocBlocs_Count do
    if ultraschall.Docs_US_Functions_USDocBlocs_Titles[i]:lower()==functionname:lower() then
      found=i
    end
  end
  if found==-1 then ultraschall.AddErrorMessage("Docs_GetUltraschallApiFunction_Categories", "functionname", "function not found", -4) return end
  
  local count, categories, spok_lang = ultraschall.Docs_GetUSDocBloc_ChapterContext(ultraschall.Docs_US_Functions_USDocBlocs[found], 1)
  
  return count, categories
end

function ultraschall.Docs_GetUSDocBloc_Examples(String)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetUSDocBloc_Examples</slug>
  <requires>
    Ultraschall=4.9
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer num_code_examples, table code_examples = ultraschall.Docs_GetUSDocBloc_Examples(string String)</functioncall>
  <description>
    returns the code-examples from an US_DocBloc-element. The table 
    
    the returned table is of the following format:
      code_examples[code_example_index]["name"] - the name of the example
      code_examples[code_example_index]["description"] - a description of the example
      code_examples[code_example_index]["url"] - the path to the code-example-file, usually based in the Documentation/Examples-folder
      code_examples[code_example_index]["url_absolute"] - the absolute path to the code-example-file
      code_examples[code_example_index]["author"] - the author of the example
    
    returns nil in case of an error
  </description>
  <retvals>
    integer num_code_examples - the number or available code-examples
    table code_examples - a table with all the code-example-attributes; each index is a code-example
  </retvals>
  <parameters>
    string String - a string which hold a US_DocBloc to retrieve the code-example-attributes from
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, code example, usdocbloc</tags>
</US_DocBloc>
]]
  if type(String)~="string" then ultraschall.AddErrorMessage("Docs_GetUSDocBloc_Examples", "String", "must be a string", -1) return nil end
  local Examples={}
  for k in string.gmatch(String, "%<example.-%>") do
    Examples[#Examples+1]={}
    name=k:match("name=\"(.-)\"")
    if name==nil then name="" end
    description=k:match("description=\"(.-)\"")
    if description==nil then description="" end
    author=k:match("author=\"(.-)\"")
    if author==nil then author="" end
    url=k:match("url=\"(.-)\"")
    if url==nil then url="" end
    Examples[#Examples]["name"]=name
    Examples[#Examples]["url"] = url
    Examples[#Examples]["url_absolute"] = ultraschall.Api_Path.."/Documentation/"..url
    Examples[#Examples]["description"]=description
    Examples[#Examples]["author"]=author
  end
  return #Examples, Examples
end


function ultraschall.Docs_GetAllUSDocBlocsFromFile(filename)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Docs_GetAllUSDocBlocsFromFile</slug>
  <requires>
    Ultraschall=4.9
    Reaper=5.978
    Lua=5.3
  </requires>
  <functioncall>integer found_usdocblocs, array all_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(string filename)</functioncall>
  <description>
    returns all US_DocBloc-elements from a file.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer found_usdocblocs - the number of found US_DocBlocs in the file
    array all_found_usdocblocs - the individual US_DocBlocs found in the file
  </retvals>
  <parameters>
    string filename - the file, from which to get all US-docblocs
  </parameters>
  <chapter_context>
    Ultraschall DocML
  </chapter_context>
  <target_document>US_Api_DOC</target_document>
  <source_document>ultraschall_doc_engine.lua</source_document>
  <tags>doc engine, get, all, usdocbloc, from file</tags>
</US_DocBloc>
]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("Docs_GetAllUSDocBlocsFromFile", "filename", "must be a string ", -1) return nil end
  if reaper.file_exists(filename)==false then ultraschall.AddErrorMessage("Docs_GetAllUSDocBlocsFromFile", "filename", "file does not exist", -2) return nil end
  local Array={}
  local count=0
  for k in io.lines(filename) do
    if k:find("%<US%_DocBloc ") then readme=true count=count+1 Array[count]="" end
    if readme==true then
      Array[count]=Array[count]..k:match("%s*(.*)").."\n"
    end
    if k:find("%</US%_DocBloc>") then readme=false end
  end
  return count, Array
end