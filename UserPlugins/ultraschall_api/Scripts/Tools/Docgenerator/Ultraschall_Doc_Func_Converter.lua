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
  --]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

Tempfile=ultraschall.Api_Path.."/temp/temporary"
--ConversionToolMD2HTML="c:\\Program Files (x86)\\Pandoc\\pandoc.exe -f markdown -t html "..ultraschall.Api_Path.."/temp/temporary.md -o "..ultraschall.Api_Path.."/temp/temporary.html"
ConversionToolMD2HTML="chcp 65001\n\r \"c:\\Program Files (x86)\\Pandoc\\pandoc.exe\" -f markdown_strict -t html "..ultraschall.Api_Path.."/temp/temporary.md -o "..ultraschall.Api_Path.."/temp/temporary.html"

Infilename=ultraschall.Api_Path.."/ultraschall_functions_engine.lua"
Infilename_render=ultraschall.Api_Path.."/Modules/ultraschall_functions_Render_Module.lua"
Infilename2=ultraschall.Api_Path.."/ultraschall_functions_engine_beta.lua"
Outfile=ultraschall.Api_Path.."/Documentation/US_Api_Functions.html"

retval, scriptfilename=reaper.get_action_context()
_temp,scriptfilename=ultraschall.GetPath(scriptfilename)

--Infilename=ultraschall.Api_Path.."/misc/US_Api-Manual.USDocML"
--Outfile=ultraschall.Api_Path.."/Documentation/US_Api_Documentation2.html"

func_done_count, vars_done_count=progresscounter(false)

--print2(func_done_count)

--if L==nil then return end


local String=ultraschall.ReadFullFile(Infilename, false)

filecount, files = ultraschall.GetAllFilenamesInPath(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/Modules/")
for i=1, filecount do
  String=String..ultraschall.ReadFullFile(files[i], false).."\n"
end

if ultraschall.US_BetaFunctions=="ON" then
    String=String.."\n"..ultraschall.ReadFullFile(Infilename2, false)
end

local FunctionList2=""

temp, build=reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", ultraschall.Api_Path.."/IniFiles/ultraschall_api.ini")

D,version,date,beta,Tagline,F,G=ultraschall.GetApiVersion()

function ultraschall.SplitUSDocBlocs(String)
  local Table={}
  local Counter=0
  TUT=""
  while String:match("<US_DocBloc")~=nil do
    Counter=Counter+1
    Table[Counter]={}
    Table[Counter][2], Offset=String:match("(<US_DocBloc.-</US_DocBloc>)()")        -- USDocBloc
    Table[Counter][1]=Table[Counter][2]:match("<slug>\n*%s*\t*(.-)\n*%s*\t*</slug>")               -- the Slug
    TUT=TUT.."\n"..Table[Counter][1]
    Table[Counter][3]=Table[Counter][2]:match("<US_DocBloc.-version=\"(.-)\".->")   -- version
    Table[Counter][4]=Table[Counter][2]:match("<US_DocBloc.-spok_lang=\"(.-)\".->") -- spok-language
    Table[Counter][5]=Table[Counter][2]:match("<US_DocBloc.-prog_lang=\"(.-)\".->") -- prog-language
    
    String=String:sub(Offset,-1)
  end
  --reaper.CF_SetClipboard(TUT)
  return Counter+1, Table
end


function ultraschall.ParseSlug(String)
  return String:match("<slug>\n*%s*\t*(.-)\n*%s*\t*</slug>")
end



function ultraschall.ParseTitle(String)
  return String:match("<title>\n*%s*\t*(.-)\n*%s*\t*</title>")
end

function ultraschall.ParseFunctionCall(String)
  local FoundFuncArray={}
  local count, positions = ultraschall.CountPatternInString(String, "<functioncall", true) 
  local temp, func, prog_lang
  for i=1, count do
    temp=String:sub(positions[i], String:match("</functioncall>\n()", positions[i]))
    func=temp:match("<functioncall.->\n*(.-)\n*</functioncall>")
    prog_lang=temp:match("prog_lang=\"(.-)\"")
    if prog_lang==nil then prog_lang="*" end
    FoundFuncArray[i]={}
    FoundFuncArray[i][1]=func
    FoundFuncArray[i][2]=prog_lang
  end
  return count, FoundFuncArray
end

--LLLL=ultraschall.CountLinesInString(0)

function ultraschall.ParseChapterContext(String)
  local ChapContext={}
  local Count=0
  local TempChapCont=String:match("<chapter_context>\n*(.-)\n*</chapter_context>")
  for i=1, ultraschall.CountLinesInString(TempChapCont) do
--    reaper.MB(Count,"",0)
    ChapContext[Count],offset=TempChapCont:match("%s*t*(.-)\n()")
    if offset~=nil then TempChapCont=TempChapCont:sub(offset,-1) Count=Count+1 end
  end
  return ChapContext, Count
end

function ultraschall.ParseDescription(String)
-- TODO: What if there are numerous descriptions, for other languages/prog_langs?
--       Still missing...
  local description=String:match("<description.->\n(.-)</description>")
  local markup_type=String:match("<description.-markup_type=\"(.-)\".-</description>")
  local markup_version=String:match("<description.-markup_version=\"(.-)\".-</description>")
  local lang=String:match("<description.-lang=\"(.-)\"")
  local lang=String:match("<description.-prog_lang=\"(.-)\"")
  local indent=String:match("<description.-indent=\"(.-)\"")
  local newdesc=""
  
  if markup_type==nil then markup_type="plain_text" end
  if markup_version==nil then markup_version="-" end
  if lang==nil then lang="*" end
  if prog_lang==nil then prog_lang="*" end
  if description==nil then return newdesc, markup_type, markup_version, lang, prog_lang end
  
  if indent==nil then indent="default" end
  if indent=="default" then
    -- the default indent-behavior: read the tabs/spaces from the first line and subtract them from
    -- every other line    
    local L=description:match("^%s*%t*()")
    local description=description.."\n"
    while description:len()>0 do
      local line, offset=description:match("(.-\n)()")
      local L2=line:match("^%s*%t*()")
      if L<L2 then line=line:sub(L,-1) else line=line:sub(L2, -1) end
      if line:len()==0 then line="\n" end
      description=description:sub(offset,-1)
      newdesc=newdesc..line
    end
  elseif indent=="minus_starts_line" then
    -- remove all spaces and tabs, until the first -
-- Still missing: what if a line has no - at the beginning? (Leave it that way, probably.)
    newdesc=string.gsub(description, "\n%s*%t*-", "\n")
  end
  return newdesc, markup_type, markup_version, lang, prog_lang
end

function ultraschall.ParseRequires(String)
  return String:match("Reaper=(.-)\n"), String:match("SWS=(.-)\n"), String:match("Lua=(.-)\n"), String:match("JS=(.-)\n")
end

function ultraschall.ParseChapterContext(String)
  local Chapter={}
  local counter=0
  local chapterstring=""
--  reaper.MB(String,"",0)
  String=String:match("<chapter_context>\n*(.*)\n*</chapter_context>")
  if String==nil then String="" end
  String=String.."\n"
  while String~=nil do
    temp, pos=String:match("(.-)\n()")
    if pos==nil then break end
    temp=temp:match("^%s*%t*(.*)")
    counter=counter+1
    Chapter[counter]=temp
--    reaper.MB(String,"",0)
    String=String:sub(pos)
--    reaper.MB(String,"",0)
  end
  for i=1, counter do
    chapterstring=chapterstring..Chapter[i]..", "
  end
  return counter, Chapter, chapterstring:sub(1,-3)
end

function ultraschall.ParseTags(String)
  String=String:match("<tags>\n*%s*%t*(.-)\n*%s*%t*</tags>")
  String=string.gsub(String, " ,", "\n")
  String=string.gsub(String, ", ", "\n")
  String=string.gsub(String, ",", "\n")
  local count, splitarray= ultraschall.CSV2IndividualLinesAsArray(String, "\n")
  for i=count, 1, -1 do
    if splitarray[i]=="" then table.remove(splitarray, i) count=count-1
    elseif splitarray[i]:match("%a")==nil then table.remove(splitarray, i) count=count-1 
    end
  end
  return splitarray, count
end


--A,B=ultraschall.ParseTags("<tags>a,b ,c ,,,,,,k,                   \n\t  , ,</tags>")

function ultraschall.ParseParameters(String)
  String=String:match("<parameters.->\n*(.*)\n*</parameters>")
  if String~=nil then
    local MarkupType=String:match("markup_type=\"(.-)\"")
    local MarkupVers=String:match("markup_version=\"(.-)\"")
  end
  local Params={}
  local counter=0
  local Count, Splitarray = ultraschall.CSV2IndividualLinesAsArray(String, "\n")
  if Count==-1 then return -1 end
  for i=1, Count do
    local temppar, tempdesc=Splitarray[i]:match("(.-)%s-%-(.*)")
    if temppar==nil then break end -- Hack, make it better plz
    if temppar:match("%a")~=nil then 
      counter=counter+1
      Params[counter]={}
      Params[counter][1]=temppar:match("^%t*%s*(.*)")
      Params[counter][2]=tempdesc
    else
      --reaper.ShowConsoleMsg(String.."\n")
      Params[counter][2]=Params[counter][2].."\n"..tempdesc
    end
  end
  if MarkupType==nil then MarkupType="plain_text" end
  if MarkupVers==nil then MarkupVers="-" end
  
  --if String:match("extensionList")~=nil then reaper.MB(String,MarkupType,0) end
  
  return counter, Params, MarkupType, MarkupVers
end

function ultraschall.ParseRetvals(String)
--reaper.MB(String,"",0)
  --ASLUG=String:match("slug>\n*(.-)\n*</slug")
  String=String:match("<retvals.->\n*(.*)\n*</retvals>")
  if String~=nil then
    MarkupType=String:match("markup_type=\"(.-)\"")
    MarkupVers=String:match("markup_version=\"(.-)\"")
  end  
  
  Retvals={}
  counter=0
  Count, Splitarray = ultraschall.CSV2IndividualLinesAsArray(String, "\n")
  if Count==-1 then return -1 end
  for i=1, Count do
    tempretv, tempdesc=Splitarray[i]:match("(.-)%s-%-(.*)")
--    reaper.MB(Splitarray[i],"",0)
    if tempretv==nil then break end -- Hack, make it better plz
    if tempretv:match("%a")~=nil then 
      counter=counter+1
      Retvals[counter]={}
      Retvals[counter][1]=tempretv:match("^%t*%s*(.*)")
      Retvals[counter][2]=tempdesc
    else
      if Retvals[counter]==nil then Retvals[counter]={} Retvals[counter][2]="" end
      Retvals[counter][2]=Retvals[counter][2].."\n"..tempdesc
    end
  end
  if MarkupType==nil then MarkupType="plain_text" end
  if MarkupVers==nil then MarkupVers="-" end
  return counter, Retvals, MarkupType, MarkupVers
end

function ultraschall.GetIndexNumberFromSlug(Table,Slug)
  local i=1
  while Table[i]~=nil do
    if string.lower(Table[i][1])==string.lower(Slug) then return i end
    i=i+1
  end
end

function ultraschall.ParseTargetDocument(String)
  return String:match("<target_document>\n*(.-)\n*</target_document>")
end

function ultraschall.ParseSourceDocument(String)
  return String:match("<source_document>\n*(.-)\n*</source_document>")
end

function ultraschall.BubbleSortDocBlocTable_Slug(Table)
  local count=1
  while Table[count]~=nil and Table[count+1]~=nil do
    if Table[count][1]>Table[count+1][1] then
      temp=Table[count]
      Table[count]=Table[count+1]
      Table[count+1]=temp
    end
    count=count+1
  end
end

function ultraschall.GetAllSlugs(Table)
-- returns a table with the slugnames as index and the index-numbers of Table as value
  local counter=1
  local SlugTable={}
  while Table[counter]~=nil do
    SlugTable[Table[counter][1]]=counter
    counter=counter+1
  end
  return counter-1, SlugTable
end

function ultraschall.ConvertSplitDocBlocTableIndex_Slug(Table)
  local counter=1
  local TableSlug={}
  while Table[counter]~=nil do
    TableSlug[Table[counter][1]]=Table[counter]
    counter=counter+1    
  end
  return TableSlug
end

function ultraschall.GetAllChapterContexts(Table)
  local counter=1
  local count=0
  local ChapterTable={}
  
  local tempstring=""
  
  local found=false
  local i=0
  while Table[counter]~=nil do
    local temp_count,table2=ultraschall.ParseChapterContext(Table[counter][2])
    if temp_count>count then count=temp_count end
    for a=1, temp_count do
      tempstring=tempstring..table2[a]..", "
    end
    tempstring=tempstring:sub(1,-3)
    for a=1, i do
      if ChapterTable[a]==tempstring then found=true break else found=false end
    end
    if found==false then i=i+1 ChapterTable[i]=tempstring end
    tempstring=""

    counter=counter+1
  end
  table.sort(ChapterTable)
  
  return count, ChapterTable, counter-1
end

function ultraschall.ConvertPlainTextToHTML(text)
  text=text:match("%s*\t*(.*)")
  text=string.gsub(text, "\r", "")
  text=string.gsub(text, "\n", "<br>")
  text=string.gsub(text, "  ", "&nbsp;&nbsp;")
  text=string.gsub(text, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")  
  
  return text
end

--A=ultraschall.ConvertPlainTextToHTML(" true, update Ultraschall's internal projecttab-monitoring-list to the current state of all tabs\nfalse, don't update the internal projecttab-monitoring-list, so it will keep the \"old\" project-tab-state as checking-reference")

--reaper.MB(A,"",0)

--if L==nil then return end
MDCOUNT=0

function ultraschall.ConvertMarkdownToHTML(text, version)
  text=string.gsub(text, "\r", "")
  text=string.gsub(text, "\n", "<br>\n")
  if text:sub(-4,-1)=="<br>" then text=text:sub(1,-5) end
  ultraschall.WriteValueToFile(Tempfile..".md", text)
  ultraschall.WriteValueToFile(Tempfile:match("(.*/).*").."Temp.bat", ConversionToolMD2HTML)
  local L=reaper.ExecProcess(Tempfile:match("(.*/).*").."Temp.bat", 0)
--  local L=reaper.ExecProcess(ConversionToolMD2HTML, 0)
  L3=text
  local L2=ultraschall.ReadFullFile(Tempfile..".html", false)
  L3=string.gsub(L2,"<p>","")
  L3=string.gsub(L3,"</p>","")
  L3=string.gsub(L3, "  ", "&nbsp;&nbsp;")
  L3=string.gsub(L3, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
--  L3=string.gsub(L3, "’", "'")
--  L3=string.gsub(L3, "“", "\"")
--  L3=string.gsub(L3, "”", "\"")
--  L3=string.gsub(L3, "phase%(180..", "phase(180")
--  L3=string.gsub(L3, "ier e%.g%..", "ier e.g.")
--  L3=string.gsub(L3, "â‚¬", "€")
  
  
--  if L3:match("ier e%.g%.")~=nil then reaper.MB(L3:match("ier e%.g%.."),"",0) end

  return L3
end

  
function ultraschall.ColorateDatatypes(String)
  if String==nil then String=" " end
  String=" "..String.." "
  String=string.gsub(String, "%(", "( ")
  String=string.gsub(String, "%[", "[ ")
  String=string.gsub(String, " boolean ", " <i style=\"color:#0000ff;\">boolean</i> ")
  String=string.gsub(String, " Boolean ", " <i style=\"color:#0000ff;\">Boolean</i> ")
  String=string.gsub(String, " bool ", " <i style=\"color:#0000ff;\">bool</i> ")
  String=string.gsub(String, " bool%* ", " <i style=\"color:#0000ff;\">bool*</i> ")
--reaper.MB("LULA:"..String,"",0)
  String=string.gsub(String, " %.%.%. ", " <i style=\"color:#0000ff;\">...</i> ")
  String=string.gsub(String, " void ", " <i style=\"color:#0000ff;\">void</i> ")
  String=string.gsub(String, " void%* ", " <i style=\"color:#0000ff;\">void*</i> ")
  String=string.gsub(String, " integer ", " <i style=\"color:#0000ff;\">integer</i> ")
  String=string.gsub(String, " int ", " <i style=\"color:#0000ff;\">int</i> ")
  String=string.gsub(String, " int%* ", " <i style=\"color:#0000ff;\">int*</i> ")
  String=string.gsub(String, " Int ", " <i style=\"color:#0000ff;\">Int</i> ")
  String=string.gsub(String, " const ", " <i style=\"color:#0000ff;\">const</i> ")
  String=string.gsub(String, " char ", " <i style=\"color:#0000ff;\">char</i> ")
  String=string.gsub(String, " char%* ", " <i style=\"color:#0000ff;\">char*</i> ")
  String=string.gsub(String, " string ", " <i style=\"color:#0000ff;\">string</i> ")
  String=string.gsub(String, " String ", " <i style=\"color:#0000ff;\">String</i> ")
  String=string.gsub(String, " number ", " <i style=\"color:#0000ff;\">number</i> ")
  String=string.gsub(String, " double ", " <i style=\"color:#0000ff;\">double</i> ")
  String=string.gsub(String, " double%* ", " <i style=\"color:#0000ff;\">double*</i> ")
  String=string.gsub(String, " float ", " <i style=\"color:#0000ff;\">float</i> ")
  String=string.gsub(String, " float%* ", " <i style=\"color:#0000ff;\">float*</i> ")
  String=string.gsub(String, " Float ", " <i style=\"color:#0000ff;\">Float</i> ")
  String=string.gsub(String, " ReaProject%* ", " <i style=\"color:#0000ff;\">ReaProject*</i> ")
  String=string.gsub(String, " ReaProject ", " <i style=\"color:#0000ff;\">ReaProject</i> ")
  String=string.gsub(String, " MediaItem%*", " <i style=\"color:#0000ff;\">MediaItem*</i> ")
  String=string.gsub(String, " MediaItem ", " <i style=\"color:#0000ff;\">MediaItem</i> ")
  String=string.gsub(String, " MediaTrack ", " <i style=\"color:#0000ff;\">MediaTrack</i> ")
  String=string.gsub(String, " MediaTrack%*", " <i style=\"color:#0000ff;\">MediaTrack*</i> ")
  String=string.gsub(String, " AudioAccessor ", " <i style=\"color:#0000ff;\">AudioAccessor</i> ")
  String=string.gsub(String, " AudioAccessor%* ", " <i style=\"color:#0000ff;\">AudioAccessor*</i> ")
  String=string.gsub(String, " BR_Envelope ", " <i style=\"color:#0000ff;\">BR_Envelope</i> ")
  String=string.gsub(String, " HWND ", " <i style=\"color:#0000ff;\">HWND</i> ")
  String=string.gsub(String, " IReaperControlSurface ", " <i style=\"color:#0000ff;\">IReaperControlSurface</i> ")
  
  String=string.gsub(String, " joystick_device ", " <i style=\"color:#0000ff;\">joystick_device</i> ")
  String=string.gsub(String, " KbdSectionInfo ", " <i style=\"color:#0000ff;\">KbdSectionInfo</i> ")
  String=string.gsub(String, " KbdSectionInfo%* ", " <i style=\"color:#0000ff;\">KbdSectionInfo*</i> ")
  String=string.gsub(String, " PCM_source ", " <i style=\"color:#0000ff;\">PCM_source</i> ")
  String=string.gsub(String, " PCM_source%* ", " <i style=\"color:#0000ff;\">PCM_source*</i> ")
  String=string.gsub(String, " RprMidiTake ", " <i style=\"color:#0000ff;\">RprMidiTake</i> ")
  String=string.gsub(String, " MediaItem_Take ", " <i style=\"color:#0000ff;\">MediaItem_Take</i> ")
  String=string.gsub(String, " MediaItem_Take%* ", " <i style=\"color:#0000ff;\">MediaItem_Take*</i> ")
  String=string.gsub(String, " TrackEnvelope%* ", " <i style=\"color:#0000ff;\">TrackEnvelope*</i> ")
  String=string.gsub(String, " TrackEnvelope ", " <i style=\"color:#0000ff;\">TrackEnvelope</i> ")
  String=string.gsub(String, " WDL_FastString ", " <i style=\"color:#0000ff;\">WDL_FastString</i> ")
  
  String=string.gsub(String, " LICE_IBitmap%* ", " <i style=\"color:#0000ff;\">LICE_IBitmap*</i> ")  
  String=string.gsub(String, " WDL_VirtualWnd_BGCfg%* ", " <i style=\"color:#0000ff;\">WDL_VirtualWnd_BGCfg*</i> ")  
  String=string.gsub(String, " preview_register_t%* ", " <i style=\"color:#0000ff;\">preview_register_t*</i> ")  
  String=string.gsub(String, " screensetNewCallbackFunc ", " <i style=\"color:#0000ff;\">screensetNewCallbackFunc</i> ")  
  String=string.gsub(String, " ISimpleMediaDecoder%* ", " <i style=\"color:#0000ff;\">ISimpleMediaDecoder*</i> ")  
  String=string.gsub(String, " LICE_pixel ", " <i style=\"color:#0000ff;\">LICE_pixel</i> ")  
  String=string.gsub(String, " HINSTANCE ", " <i style=\"color:#0000ff;\">HINSTANCE</i> ")  
  String=string.gsub(String, " LICE_IFont%* ", " <i style=\"color:#0000ff;\">LICE_IFont*</i> ")  
  String=string.gsub(String, " HFONT ", " <i style=\"color:#0000ff;\">HFONT</i> ")  
  String=string.gsub(String, " RECT%* ", " <i style=\"color:#0000ff;\">RECT*</i> ")  
  String=string.gsub(String, " UINT ", " <i style=\"color:#0000ff;\">UINT</i> ")  
  String=string.gsub(String, " unsigned ", " <i style=\"color:#0000ff;\">unsigned</i> ")  
  String=string.gsub(String, " MSG%* ", " <i style=\"color:#0000ff;\">MSG*</i> ")  
  String=string.gsub(String, " HMENU ", " <i style=\"color:#0000ff;\">HMENU</i> ")  
  String=string.gsub(String, " MIDI_event_t%* ", " <i style=\"color:#0000ff;\">MIDI_event_t*</i> ")  
  String=string.gsub(String, " MIDI_eventlist%* ", " <i style=\"color:#0000ff;\">MIDI_eventlist*</i> ")  
  String=string.gsub(String, " DWORD ", " <i style=\"color:#0000ff;\">DWORD</i> ")  
  String=string.gsub(String, " ACCEL%* ", " <i style=\"color:#0000ff;\">ACCEL*</i> ")  
  String=string.gsub(String, " PCM_source_peaktransfer_t%* ", " <i style=\"color:#0000ff;\">PCM_source_peaktransfer_t*</i> ")  
  String=string.gsub(String, " PCM_source_transfer_t%* ", " <i style=\"color:#0000ff;\">PCM_source_transfer_t*</i> ")  
  String=string.gsub(String, " audio_hook_register_t%* ", " <i style=\"color:#0000ff;\">audio_hook_register_t*</i> ")  
  String=string.gsub(String, " size_t ", " <i style=\"color:#0000ff;\">size_t</i> ")  
  String=string.gsub(String, " function ", " <i style=\"color:#0000ff;\">function</i> ")  
  String=string.gsub(String, " ReaperArray ", " <i style=\"color:#0000ff;\">ReaperArray</i> ")  
  String=string.gsub(String, " RenderTable ", " <i style=\"color:#0000ff;\">RenderTable</i> ")  
  String=string.gsub(String, " optional ", " <i style=\"color:#0000ff;\">optional</i> ")  
  
--  String=string.gsub(String, " trackstring ", " <i style=\"color:#0000ff;\">trackstring</i> ")  
  String=string.gsub(String, " MediaItemArray ", " <i style=\"color:#0000ff;\">MediaItemArray</i> ")  
  String=string.gsub(String, " MediaItemStateChunkArray ", " <i style=\"color:#0000ff;\">MediaItemStateChunkArray</i> ")  
  String=string.gsub(String, " table ", " <i style=\"color:#0000ff;\">table</i> ")  
  String=string.gsub(String, " array ", " <i style=\"color:#0000ff;\">array</i> ")  
  String=string.gsub(String, " identifier ", " <i style=\"color:#0000ff;\">identifier</i> ")  
  String=string.gsub(String, " EnvelopePointArray ", " <i style=\"color:#0000ff;\">EnvelopePointArray</i> ")  
  
  String=string.gsub(String, "%( ", "(")
  String=string.gsub(String, "%[ ", "[")
  return String:sub(2,-2)
end


Ccount, C=ultraschall.SplitUSDocBlocs(String)

--A,B=ultraschall.GetAllChapterContexts(C)
--A=ultraschall.BubbleSortDocBlocTable_Slug(C)
--A=ultraschall.ConvertSplitDocBlocTableIndex_Slug(C)
--A,B,BB,BBB,BBBB=ultraschall.ParseDescription(C[199][2])
--B=ultraschall.ParseSlug(C[199][2])
--C=ultraschall.ParseShortname(A[100])
--D,E,F=ultraschall.ParseDescription(A[1][1])
--G, H,I=ultraschall.ParseChapterContext(C[1][2])

--A,B=ultraschall.ParseFunctionCall(C[100][2])
--A,B,BB=ultraschall.ParseRequires(C[700][2])
--A,B=ultraschall.ParseChapterContext(C[700][2])
--A,B=ultraschall.ParseTags(C[100][2])
--reaper.MB(C[700][2],"",0)
--A,B,BB,BBB=ultraschall.ParseRetvals(C[100][2])
--L=ultraschall.GetIndexNumberFromSlug(C,"SNM_GetIntConfigVar")
--A,AA=ultraschall.GetAllSlugs(C)
--A=ultraschall.ParseSourceDocument(C[199][2])
--table.sort(C[1])

-- Let's create the functionlist
  index=1
  b=0
FunctionList=[[
<html><head><title>
Ultraschall API functions
</title>

</head><body>
    <div style=" position: absolute; padding-left:4%; ">
        <div style="background-color:#282828;width:95%; font-family:tahoma; font-size:16;">


           <a href="US_Api_Functions.html"><img style="position: absolute; left:4.2%; width:11%;" src="gfx/US_Button.png" alt="Ultraschall Internals Documentation"></a>  
           <a href="Reaper_Api_Documentation.html"><img style="position: absolute; left:15.2%; width:8.7%;" src="gfx/Reaper_Button_Un.png" alt="Reaper Internals Documentation"></a>
         <img alt="" style="width:6.9%; position: absolute; left:23.9%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:30.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:36.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:42.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:48.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:54.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:60.8%;" src="gfx/linedance.png"><img alt="" style="width:6.9%; position: absolute; left:66.8%;" src="gfx/linedance.png">
         <img alt="" style="width:6.9%; position: absolute; left:68.8%;" src="gfx/linedance.png">
           <a href="Downloads.html"><img style="position:absolute; left:74.4%; width:6.9%;" src="gfx/Downloads_Un.png" alt="Downloads"></a>
           <a href="ChangeLog.html"><img style="position:absolute; left:81.3%; width:6.9%;" src="gfx/Changelog_Un.png" alt="Changelog of documentation"></a>
           <a href="Impressum.html"><img style="position:absolute; left:88.2%; width:6.9%;" src="gfx/Impressum_Un.png" alt="Impressum and Contact"></a>
           <div style="padding-top:2.5%">
           <table border="0" style="color:#aaaaaa; width:100%;">
                <tr>
                    <td style="width:10%;">
                        <a href="http://www.ultraschall.fm"><img style="width:120%;" src="gfx/US-header.png" alt="Ultraschall-logo"></a>
                    </td>
                    <td width="1%;"><u>Functions Engine</u></td>
                    <td width="1%;"><u>GFX Engine</u></td>
                    <td width="1%;"><u>GUI Engine</u></td>
                    <td width="1%;"><u>Video Engine</u></td>
                    <td width="1%;"><u>Audio Engine</u></td>
                    <td width="1%;"><u>Doc Engine</u></td>
                    <td width="1%;">&nbsp;<u></u></td>
                </tr>
                <tr>
                    <td></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Introduction_and_Concepts.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;Introduction/Concepts</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_GFX.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_GUI.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_VID.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_AUD.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Concepts_DOC.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Concepts</a></td>
                </tr>
                <tr>
                    <td></td>
                    <td style="background-color:#777777; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_Functions.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_GFX.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_GUI.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_VID.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_AUD.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                    <td style="background-color:#555555; color:#BBBBBB; border: 1px solid #333333; border-radius:5%/5%;"><a href="US_Api_DOC.html" style="color:#BBBBBB; text-decoration: none; justify-content: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Functions&nbsp;</a></td>
                </tr>
                <tr><td></td><tr>
                </table>
           </div>
        </div>
    </div>
    <div style="position:absolute; top:17%; padding-left:5%; width:90%;">
]]


function header()
-- 
--<a href="Reaper_SWS_Introduction.html"><img width="40" src="gfx/header/SWS_Button_Un.png" alt="SWS Internals Documentation"></a> 
--<a href="Downloads.html"><img style="position:absolute; left:72.5%; width:6.9%;" src="gfx/header/Downloads.png" alt="Downloads"></a><a href="Changelog.html"><img style="position:absolute; left:79.5%; width:6.9%;" src="gfx/header/changelog.png" alt="Changelog of documentation"></a><a href="Impressum.html"><img style="position:absolute; left:86.5%; width:6.9%;" src="gfx/header/impressum.png" alt="Impressum and Contact"></a>
  FunctionList=FunctionList..[[<div style="background-color:#282828;">
<img alt="" width="100%" height="32" src="gfx/header/linedance.png">
<a href="Reaper_Introduction.html"><img style="position:absolute; top:0%; right:10%;" width="10%" src="gfx/header/US.png" alt="Ultraschall-API Documentation"></a>


        </div><p> ]]
end

function contentindex()
  FunctionList=FunctionList.."<br><br><img src=\"gfx/us.png\"><div style=\"padding-left:0%;\"><br>"..version..beta.." - "..Tagline.." - "..date.." - Build: "..build..[[</div><h3>The Functions Reference</h3>
      To add the API to your script, just add<p>
      
      <pre><code>
        dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
      </pre></code>
  
      as first line into your script.<p>
      
      For more details, read the docs in the <a href="US_Api_Introduction_and_Concepts">Introduction and Concepts</a>-area of this page.
  <table style=\"font-size:10pt; width:100%;\" >
  ]]
  reaper.ClearConsole()
  reaper.ShowConsoleMsg(scriptfilename..": Create Index\n")
  HeaderList={}
  count=1
  count2=0
  
  -- get the chapter-contexts
  -- every entry in HeaderList is "chaptercontext1, chaptercontext2,"
  while C[count]~=nil do
    
    A, AA, AAA = ultraschall.ParseChapterContext(C[count][2])
      reaper.ClearConsole()
      reaper.ShowConsoleMsg("Create Index: "..AAA)
      temp=AAA.."\n"
      for i=1, count2 do
        if HeaderList[i]==temp then found=true end
      end
      if found~=true then
        count2=count2+1
        HeaderList[count2]=temp
      end
      found=false
    
    count=count+1
  end

  table.sort(HeaderList)
  
  -- add to the chapter-contexts the accompanying slugs, using newlines
  -- "chaptercontext1, chaptercontext2,\nslug1\nslug2\nslug3\n" etc
  count=1
  while C[count]~=nil do    
    A1, AA1, AAA1 = ultraschall.ParseChapterContext(C[count][2])
    Slug=C[count][1]
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("Create Index: "..AAA)
    temp=AAA1.."\n"
       
    for i=1, count2 do
      if HeaderList[i]:match("(.-\n)")==temp then 
  
            HeaderList[i]=HeaderList[i]..Slug.."\n"
            break 
      end
    end    
    count=count+1
  end
  
  table.sort(HeaderList)
  
  -- now we sort the slugs
  for i=1, count2 do
    chapter=HeaderList[i]:match("(.-\n)")
    slugs=HeaderList[i]:match("\n(.*)\n")
    A2, AA2, AAA2 = ultraschall.SplitStringAtLineFeedToArray(slugs)
    table.sort(AA2)
    slugs=""
    for i=1, A2 do
      slugs=slugs..AA2[i].."\n"
    end
    HeaderList[i]=chapter..slugs
--    print2(HeaderList[i])
  end
  
--  FunctionList=""
  
  -- now we create the index
  for i=1, count2 do
    Top=HeaderList[i]:match("(.-),")
    Second=HeaderList[i]:match(".-,(.-),")
    Third=HeaderList[i]:match(".-,.-,(.-),")
--    print2(HeaderList[i]:match(".-\n(.*)\n"))
    Counts, Slugs=ultraschall.SplitStringAtLineFeedToArray(HeaderList[i]:match(".-\n(.*)"))
--    if i==2 then print2(Counts) return end
    slugs=""    
    if Top==nil then Top="" else Top="<br><strong><u>"..Top.."</u></strong><br><br>\n" end
    if i>1 and Top:match("u%>(.-)%</u")==HeaderList[i-1]:match("(.-),") then Top="" end
    if Second==nil then Second="" else Second="<b style=\"font-size:small;\">"..Second.."</b>\n" end
    if i>1 and Second:match("%>(.-)%<")==HeaderList[i-1]:match("(.-),") then Second="" end
    if Third==nil then Third="" else Third=Third.."\n" end
    if i>1 and Third:match("%>(.-)%<")==HeaderList[i-1]:match("(.-),") then Third="" end
    
    linebreaker=1
    for a=1, Counts do
      if linebreaker==1 then slugs=slugs.."<tr>" end
      if linebreaker==5 then slugs=slugs.."</tr>" linebreaker=1 end
      slugs=slugs.."<td style=\"width:25%; font-size:small;\"><a href=\"#"..Slugs[a].."\">"..Slugs[a].."</a></td>"
      linebreaker=linebreaker+1
    end
    if linebreaker==1 then slugs=slugs.."<td style=\"width:25%;\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==2 then slugs=slugs.."<td style=\"width:25%;\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==3 then slugs=slugs.."<td style=\"width:25%;\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==4 then slugs=slugs.."<td style=\"width:25%;\">&nbsp;</td>" linebreaker=linebreaker+1 end
    slugs=slugs.."</tr>"

    
    FunctionList=FunctionList.."<table style=\"width:100%;\" border=\"0\"><tr><td>"..Top..Second..Third.."</td></tr>"..slugs.."</table>"

  end

    FunctionList=FunctionList.."<br>"
    entries()
--    writefile()
end


function contentindex2()
  -- let's prepare all data-structures
  reaper.ClearConsole()
  reaper.ShowConsoleMsg("Create Index\n")
  HeaderList={}
  local A,B=ultraschall.GetAllChapterContexts(C)
  local count=1
  while B[count]~=nil do
    HeaderList[B[count]]={}
    count=count+1
  end
  count=1
  local count2=1
  while C[count]~=nil do
    -- associate slugs to chapters
    A1,B1,B2=ultraschall.ParseChapterContext(C[count][2])
    while HeaderList[B2][count2]~=nil do      
      count2=count2+1
    end    
    Title=ultraschall.ParseTitle(C[count][2])
    if Title==nil then Title=C[count][1] end
    HeaderList[B2][count2]=C[count][1].."\n"..Title
    count2=1
    count=count+1    
  end
  count=1
  while B[count]~=nil do
    -- sort slugs within chapters
    table.sort(HeaderList[B[count]])
    HeaderList[B[count]][0]=""
    count=count+1
  end
  
  -- now we create the actual index
  count=1
  FunctionList=FunctionList.."<br><br><img src=\"gfx/us.png\"><div style=\"padding-left:0%;\"><br>"..beta.." \"John Cage - 4\'33\" - "..date.." - Build: "..build.."</div><h3>The Functions Reference</h3><table style=\"font-size:10pt; width:100%;\" >"
  while B[count]~=nil do
    count2=1
    local tud=1
    HeaderList[B[count]][0]="<tr><td>&nbsp;</td></tr><tr><td><b>"..B[count]:sub(1,-3).."</b></td></tr><tr>"
    while HeaderList[B[count]][count2]~=nil do      
      IDX=HeaderList[B[count][count2]]
    
      HeaderList[B[count]][0]=HeaderList[B[count]][0].."<td><a href=\"#"..HeaderList[B[count]][count2]:match("(.-)\n").."\">"..HeaderList[B[count]][count2]:match("\n(.*)").."</a></td>\n"
      if tud==4 and B[count]~="API-Documentation" then HeaderList[B[count]][0]=HeaderList[B[count]][0].."</tr><tr>" tud=0 end
      if B[count]=="API-Documentation" then HeaderList[B[count]][0]=HeaderList[B[count]][0].."</tr><tr>" end
      tud=tud+1
      count2=count2+1
    end
    HeaderList[B[count]][0]=HeaderList[B[count]][0].."</tr><p>"
    FunctionList=FunctionList..HeaderList[B[count]][0]
--    reaper.ShowConsoleMsg(B[count]..": \n"..HeaderList[B[count]][0].."\n\n")
--    reaper.ShowConsoleMsg(IndexString.."\n")
--    reaper.MB("","",0)
    count=count+1
  end
  FunctionList=FunctionList.."</table>"

--  entries()
  writefile()
end

function writefile()
--reaper.MB(FunctionList2:match(".....180."), "", 0)
      FunctionList=FunctionList.."<br><hr><table width=\"100%\"><td style=\"position:absolute; right:0;\">Automatically generated by Ultraschall-API "..version.." "..beta.." - "..func_done_count.." functions and "..vars_done_count.." Api-variables available</td></table><br><hr></div></body></html>"
      reaper.ShowConsoleMsg("\nSave File\n")
      
  --    FunctionArray[FunctionArrayCounter]=FunctionList
  --    FunctionArrayCounter=FunctionArrayCounter+1
  --    FunctionList2=""
   --   for i=1, FunctionArrayCounter-1 do
   --     FunctionList2=FunctionList2..FunctionArray[i]
   --   end
      
      
      KLONGEL=ultraschall.WriteValueToFile(Outfile, FunctionList2..FunctionList, false)
--      reaper.MB(FunctionList2:sub(-2000,-1),"",0)
      if KLONGEL==-1 then ultraschall.ShowLastErrorMessage() end
  
      reaper.ShowConsoleMsg("Done\n")
      Time2=reaper.time_precise()    
      Time3=reaper.format_timestr(Time2-Time1, "")
      --reaper.MB(Time3,"",0)
      kuddel=1
      reaper.SetExtState("ultraschall", "doc", "function-engine", false)
end

function entries()
if sortentries~=true then 
--  table.sort(C[)
  sortentries=true
end
for lolo=1, 60 do
-- Slug as HTML-Anchor
  FunctionList=FunctionList.."<hr><a id=\""..C[index][1].."\"></a>"
  FunctionList=FunctionList.."\n"

-- Requirement-images + Functionname

  A,A2,A3,A4=ultraschall.ParseRequires(C[index][2])
  
  Temp=nil
  if A~=nil then Temp="<img width=\"3%\" src=\"gfx/reaper"..A..".png\" alt=\"Reaper version "..A.."\">" end
  if A2~=nil then Temp=Temp.."<img width=\"3%\" src=\"gfx/sws"..A2..".png\" alt=\"SWS version "..A2.."\">" end
  if A4~=nil then Temp=Temp.."<img width=\"3%\" src=\"gfx/JS_"..A4..".png\" alt=\"Julian Sader's plugin version "..A4.."\">" end
  if A3~=nil then Temp=Temp.."<img width=\"3%\" src=\"gfx/lua"..A3..".png\" alt=\"Lua version "..A3.."\">" end
  --if Temp==nil then reaper.MB(ultraschall.ParseTitle(C[index][2]),"",0) end
  if A~=nil or A2~=nil or A3~=nil then     
    Insert=""
  else
    Temp=""
    Insert="" --Insert=" style=\"padding-left:4%;\" "
  end
  if Temp==nil then Temp="" end
  if Insert==nil then Insert="" end
  
  FunctionList=FunctionList.."  <a href=\"#"..C[index][1].."\"> ^</a> "
  ..Temp.." <b "..
  Insert.." ><u>"..
  ultraschall.ParseSlug(C[index][2]).."</u></b>"--" <b>"..C[index][1].."</b>"--.." - "..C[index][2]:match("<tags>(.-)</tags>") 
  

--[[
  A,A2,A3,A4=ultraschall.ParseRequires(C[index][2])
--  FunctionList=FunctionList..
  if A~=nil then FunctionList=FunctionList.."<img width=\"3%\" src=\"gfx/reaper"..A..".png\" alt=\"Reaper version "..A.."\">" end
  if A2~=nil then FunctionList=FunctionList.."<img width=\"3%\" src=\"gfx/sws"..A2..".png\" alt=\"SWS version "..A2.."\">" end
  if A4~=nil then FunctionList=FunctionList.."<img width=\"3%\" src=\"gfx/JS_"..A4..".png\" alt=\"Julian Sader's plugin version "..A4.."\">" end
  if A3~=nil then FunctionList=FunctionList.."<img width=\"3%\" src=\"gfx/lua"..A3..".png\" alt=\"Lua version "..A3.."\">" end
  if A~=nil or A2~=nil or A3~=nil then 
    Title=ultraschall.ParseTitle(C[index][2])
    if Title==nil then Title=C[index][1] end
    FunctionList=FunctionList.." <a href=\"#"..C[index][1].."\"><b>"..Title.."</b></a>"--" <b>"..C[index][1].."</b>"--.." - "..C[index][2]:match("<tags>(.-)</tags>") 
  end
--  FunctionList=FunctionList

--]]

-- Functioncalls
  A,B=ultraschall.ParseFunctionCall(C[index][2])
  lua=nil
  for i=1, A do
    B[i][1]=ultraschall.ColorateDatatypes(B[i][1])
    temp=B[i][1]:match("(ultraschall.-%()")
    if temp==nil then 
      one=B[i][1]:match("(.-)%(")
      two=B[i][1]:match("%(.*")
      if one==nil then one=B[i][1] end
      if two==nil then two="" end
      lua="<b>"..one.."</b>"..two 
    end --B[i][1] end
    if temp~=nil then B[i][1]=string.gsub(B[i][1],temp:sub(1,-2).."%(","<b>"..temp.."</b>") lua=B[i][1] end
--    if B[i][2]=="cpp" then cpp="<div class=\"c_func\"><span class='all_view'>C: </span><code>"..B[i][1]:sub(1,-2).."<b>)</b></code><br><br></div>" end
--    if B[i][2]=="eel" then eel="<div class=\"e_func\"><span class='all_view'>EEL: </span><code>"..B[i][1]:sub(1,-2).."<b>)</b></code><br><br></div>" end
    if B[i][2]=="lua" and lua==nil then lua="<div class=\"l_func\"><span class='all_view'></span><code>"..temp.."<b>)</b></code><br><br></div>" end
--    if B[i][2]=="python" then python="<div class=\"p_func\"><span class='all_view'>Python: </span><code>"..B[i][1]:sub(1,-2).."<b>)</b></code><br><br></div>" end
  end
  if cpp==nil then cpp="" end
  if eel==nil then eel="" end
  if lua==nil then lua="" end
  if python==nil then python="" end  
  
  
  if C[index][2]:match("<chapter_context>.-API%-Documentation.-</chapter_context>")==nil then FunctionList=FunctionList.."<p style=\"padding-left:0.3%;\"><u>Functioncall:</u>" end
  FunctionList=FunctionList.."<div style=\"padding-left:4%;font-size:100%\">"..lua.."</div><p>"
  cpp=""
  eel=""
  lua=""
  python=""

-- Description
  newdesc, markup_type, markup_version, lang, prog_lang=ultraschall.ParseDescription(C[index][2])
  if markup_type=="plain_text" then newdesc=ultraschall.ConvertPlainTextToHTML(newdesc)
  elseif markup_type=="markdown" then newdesc=ultraschall.ConvertMarkdownToHTML(newdesc, markup_version)
  end
  if C[index][2]:match("<chapter_context>.-API%-Documentation.-</chapter_context>")==nil then FunctionList=FunctionList.."<table style=\"width:100%;\"><tr><td><u>Description:</u></td></tr>" end
  FunctionList=FunctionList.."<tr><td style=\"vertical-align:top; padding-left:4%;\">"..newdesc.."</td></tr></table>"
  if C[index][2]:match("<chapter_context>.-API%-Documentation.-</chapter_context>")==nil then FunctionList=FunctionList.."</divl>" end  
  

-- Retvals
  counter, retvals, markup_type, markup_version = ultraschall.ParseRetvals(C[index][2])
  for a=1, counter do
    retvals[a][1]=ultraschall.ColorateDatatypes(retvals[a][1])
    if markup_type=="plain_text" then retvals[a][2]=ultraschall.ConvertPlainTextToHTML(retvals[a][2])
    elseif markup_type=="markdown" then retvals[a][2]=ultraschall.ConvertMarkdownToHTML(retvals[a][2], markup_version)
    end
  end


  if counter>0 then
    FunctionList=FunctionList.."<tr><td style=\"\"><u>Returnvalues:</u></td><td> </td><td> </td></tr><table style=\"padding-left:4%;\"border=\"0\">"
    for a=1, counter do
      FunctionList=FunctionList.."<tr style=\"background:#EEEEEE;\"><td style=\"vertical-align:top; white-space:pre;\">&nbsp;<i>"..retvals[a][1].."</i>&nbsp;</td><td style=\"vertical-align:top; \">"..retvals[a][2].."&nbsp;</td></tr>"
    end   
  end
  
-- Parameters

  counter, params, markup_type, markup_version= ultraschall.ParseParameters(C[index][2])
  for a=1, counter do
    params[a][1]=ultraschall.ColorateDatatypes(params[a][1])
    if markup_type=="plain_text" then params[a][2]=ultraschall.ConvertPlainTextToHTML(params[a][2])
    elseif markup_type=="markdown" then params[a][2]=ultraschall.ConvertMarkdownToHTML(params[a][2], markup_version)
    end
  end
  FunctionList=FunctionList.."</table><br>"
  if counter>0 then    
    FunctionList=FunctionList.."<tr><td style=\"\"><u>Parameters:</u></td><td> </td><td> </td></tr><table style=\"padding-left:4%;\"border=\"0\">"
    for a=1, counter do
      FunctionList=FunctionList.."<tr style=\"background:#EEEEEE;\"><td style=\"vertical-align:top; white-space:pre;\">&nbsp;<i>"..params[a][1].."</i>&nbsp;</td><td style=\"vertical-align:top;\">"..params[a][2].."&nbsp;</td></tr>"
    end   
  end

  
  FunctionList=FunctionList.."</table><br>"
  --]]
-- FunctionList=FunctionList.."</table><br>"
  --Debug-Code  
--  FunctionArray[FunctionArrayCounter]=FunctionList
--  FunctionArrayCounter=FunctionArrayCounter+1
  FunctionList2=FunctionList2..FunctionList
  FunctionList=""
  --Debug-Code Ende
  progressbar=30
  if index<Ccount then 
    index=index+1
    b=b+1
    if b>=120 then 
      reaper.ClearConsole() 
      reaper.ShowConsoleMsg("Creating Ultraschall Api-Functions Reference-Docs\n")
      reaper.ShowConsoleMsg((math.floor(100/Ccount*index)+1).."% : ")
      for iii=1, math.floor(progressbar/Ccount*index) do reaper.ShowConsoleMsg("#") end
      for iii=math.floor(progressbar/Ccount), math.floor(progressbar/Ccount*(Ccount-index))-1 do reaper.ShowConsoleMsg("~") end
      if C[index]~=nil then tudelu=C[index][1]
      else tudelu=""
      end
      reaper.ShowConsoleMsg("\nProcessing entry:"..tostring(index).." of "..tostring(Ccount).." - "..tostring(tudelu))
      b=0
    else 
      b=b+1
    end

    end  
    if index>=Ccount then break end
end
    if index<Ccount then reaper.defer(entries) else   writefile() reaper.SetExtState("ultraschall", "doc", reaper.time_precise(), false) end
end

--header()
Time1=reaper.time_precise()
contentindex()


--    ultraschall.WriteValueToFile("c:\\Reaper-Help-Redone.html", FunctionList)


--L=ultraschall.ParseSlug("<slug>Tudelu</slug>")
--reaper.MB("OL"..L.."OL","",0)
