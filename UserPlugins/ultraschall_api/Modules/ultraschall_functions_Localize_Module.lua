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
---        Localize  Module       ---
-------------------------------------


function ultraschall.Localize_UseFile(filename, section, language)
-- TODO: getting the currently installed language for the case, that language = set to nil
--       I think, filename as place for the language is better: XRaym_de.USLangPack, XRaym_us.USLangPack, XRaym_fr.USLangPack or something
--       
--       Maybe I should force to use the extension USLangPack...
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Localize_UseFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Localize_UseFile(string filename, string section, string language)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Sets the localize-file and the section to use in the localize-file.
    If file cannot be found, the function will also look into resource-path/LangPack/ as well to find it.
    
    The file is of the format:
    ;comment
    ;another comment
    [section]
    original text=translated text
    More Text with\nNewlines and %s - substitution=Translated Text with\nNewlines and %s - substitution
    A third\=example with escaped equal\=in it = translated text with escaped\=equaltext
    
    see [specs for more information](../misc/ultraschall_translation_file_format.USLangPack).
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, translation-file has been found and set successfully; false, translation-file hasn't been found
  </retvals>
  <parameters>
    string filename - the filename with path to the translationfile; if no path is given, it will look in resource-folder/LangPack for the translation-file
    string section - the section of the translation-file, from which to read the translated strings
    string language - the language, which will be put after filename and before extension, like mylangpack_de.USLangPack; 
                    - us, usenglish
                    - es, spanish
                    - fr, french
                    - de, german
                    - jp, japanese
                    - etc
  </parameters>
  <chapter_context>
    Localization
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Localize_Module.lua</source_document>
  <tags>localization, use, set, translationfile, section, filename</tags>
</US_DocBloc>
--]]
  if type(filename)~="string" then ultraschall.AddErrorMessage("Localize_UseFile", "filename", "must be a string", -1) return false end
  if type(section)~="string" then ultraschall.AddErrorMessage("Localize_UseFile", "section", "must be a string", -2) return false end
  local filenamestart, filenamsendof=ultraschall.GetPath(filename)
  local filenamext=filenamsendof:match(".*(%..*)")
  if language==nil then language="" end
  local filename2=filename
  if filenamext==nil or filenamsendof==nil then 
    filename=filename.."_"..language
  else
    filename=filenamestart..filenamsendof:sub(1, -filenamext:len()-1).."_"..language..filenamext
  end
  
  if reaper.file_exists(filename)==false then
    if reaper.file_exists(reaper.GetResourcePath().."/LangPack/"..filename)==false then
      ultraschall.AddErrorMessage("Localize_UseFile", "filename", "file does not exist", -3) return false
    else
      ultraschall.Localize_Filename=reaper.GetResourcePath().."/LangPack/"..filename2
      ultraschall.Localize_Section=section
      ultraschall.Localize_Language=language
    end
  else
    ultraschall.Localize_Filename=filename2
    ultraschall.Localize_Section=section
    ultraschall.Localize_Language=language
  end
  ultraschall.Localize_File=ultraschall.ReadFullFile(filename).."\n["
  ultraschall.Localize_File=ultraschall.Localize_File:match(section.."%]\n(.-)%[")
  ultraschall.Localize_File_Content={}
  for k in string.gmatch(ultraschall.Localize_File, "(.-)\n") do
    k=string.gsub(k, "\\n", "\n")
    k=string.gsub(k, "=", "\0")
    k=string.gsub(k, "\\\0", "=")
    local left, right=k:match("(.-)\0(.*)")
    --print2(left, "======", right)
    ultraschall.Localize_File_Content[left]=right
  end
  
  
--  ultraschall.Localize_File2=string.gsub(ultraschall.Localize_File, "\n;.-\n", "\n")
  
  while ultraschall.Localize_File~=ultraschall.Localize_File2 do
    ultraschall.Localize_File2=ultraschall.Localize_File
    ultraschall.Localize_File=string.gsub(ultraschall.Localize_File2, "\n;.-\n", "\n")
  end
  
  ultraschall.Localize_File=string.gsub(ultraschall.Localize_File, "\n\n", "\n")
  
  --print2("9"..ultraschall.Localize_File)
  --print3(ultraschall.Localize_File)
  
  return true
end

--O=ultraschall.Localize_UseFile(reaper.GetResourcePath().."/LangPack/ultraschall.USLangPack", "Export Assistant", "de")


--O={1,2,3}
--P=#O

function ultraschall.Localize(text, ...)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Localize</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>string translated_string, boolean retval = ultraschall.Localize(string original_string, ...)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Translates the string original_string into its translated version, as stored in a translation-file.
    
    To set a translationfile, see [Localize_UseFile](#Localize_UseFile).

    If the string contains %s, the optional parameters "..." will replace them. The order of the parameters is the order of the replacement of the %s in the string.
        
    If no translation is available, it returns the original string. In that case, %s in the string could be replaced by optional parameters ...
    
    This function can be used with or without ultraschall. at the beginning, for your convenience.

    see [specs for more information](../misc/ultraschall_translation_file_format.USLangPack).
    
    returns nil in case of an error
  </description>
  <retvals>
    string translated_string - the translated string; will be the original_string(with optional substitution), if translation is not possible
    boolean retval - true, translation-was successful; false, translation wasn't successful
  </retvals>
  <parameters>
    string original_string - the original string, that you want to translate
    ... - optional parameters, who will be used to substitute %s in the returned string; order of the optional parameters reflects order of %s in the string
  </parameters>
  <chapter_context>
    Localization
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Localize_Module.lua</source_document>
  <tags>localization, translate, string, translationfile</tags>
</US_DocBloc>
--]]
  local retval=true
  if type(text)~="string" then ultraschall.AddErrorMessage("Localize", "text", "must be a string", -1) return nil, retval end
  local Tab={...}
  if ultraschall.Localize_File_Content==nil then return text, false end
  local retvaltext=ultraschall.Localize_File_Content[text]
  if retvaltext==nil then retvaltext=text retval=false end
  retvaltext=string.gsub(retvaltext, "\\n", "\n")
  for i=1, #Tab do
    retvaltext=string.gsub(retvaltext, "%%s"..i.." ", tostring(Tab[i]))
  end
  retvaltext=string.gsub(retvaltext, "\\=", "=")
  return retvaltext, retval
end


Localize=ultraschall.Localize


--A=Localize("Export MP3\nEcht", " Eins ", " Zwo ", " Drei ")
--A=Localize("Hud=el%s=", -22,2,3,4,5,6,7,8,9, "ZEHN")
--print2(A)
--A=ultraschall.Localize("Export MP3\nRender your Podcast to a MP3 File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image:\nFound.\n\n\n\n\nFinalize MP3\nHit the button and select your MP3 to finalize it\nwith metadata, chapters and episode image!")
--AAA,AAA2=ultraschall.Localize("Export MP3\nRender your Podcast to a MP3 File.\n\n\nChapter Markers\nYou may take a final look at your chapter markers.\n\n\nID3 Metadata\nUse the ID3 Editor to add metadata to your podcast.\n\n\nPodcast Episode Image:\nFound.\n\n\n\n\nFinalize MP3\nHit the button and select your MP3 to finalize it\nwith metadata, chapters and episode image!", "ALABASTERHEINRICH")
--AA=reaper.file_exists(ultraschall.Localize_Filename)

function ultraschall.Localize_RefreshFile()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Localize_RefreshFile</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Localize_RefreshFile()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Reloads the translation-file, that has been set using [Localize_UseFile](#Localize_UseFile).
    
    see [specs for more information](../misc/ultraschall_translation_file_format.USLangPack).
    
  </description>
  <retvals>
    boolean retval - true, translation-file has been found and set successfully; false, translation-file hasn't been found
  </retvals>
  <chapter_context>
    Localization
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Localize_Module.lua</source_document>
  <tags>localization, reload, refresh, translationfile</tags>
</US_DocBloc>
--]]
  if ultraschall.Localize_Filename~=nil then
    return ultraschall.Localize_UseFile(ultraschall.Localize_Filename, ultraschall.Localize_Section, ultraschall.Localize_Language)
  else
    ultraschall.AddErrorMessage("Localize_RefreshFile", "", "no translation-file loaded", -1)
    return false
  end
end

--OOO=ultraschall.Localize_RefreshFile()

--print2(ultraschall.Localize_File)
