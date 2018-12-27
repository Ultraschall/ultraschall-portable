--[[
################################################################################
# 
# Copyright (c) 2014-2018 Ultraschall (http://ultraschall.fm)
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
--- ULTRASCHALL - API - GFX-Engine ---
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
  return String:match("<slug>.-\n*%s*\t*(.-)\n*%s*\t*</slug>")
end



function ultraschall.ParseTitle(String)
  return String:match("<title>.-\n*%s*\t*(.-)\n*%s*\t*</title>")
end

function ultraschall.ParseFunctionCall(String)
  local FoundFuncArray={}
  local count, positions = ultraschall.CountPatternInString(String, "<functioncall", true) 
  local temp, func, prog_lang
  for i=1, count do
    temp=String:sub(positions[i], String:match("</functioncall>\n()", positions[i]))
    func=temp:match("<functioncall.->.-\n*(.-)\n*</functioncall>")
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
  local TempChapCont=String:match("<chapter_context>.-\n*(.-)\n*</chapter_context>")
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
  local description=String:match("<description.->.-\n(.-)</description>")
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
  return String:match("Reaper=(.-)\n"), String:match("SWS=(.-)\n"), String:match("Lua=(.-)\n")
end

function ultraschall.ParseChapterContext(String)
  local Chapter={}
  local counter=0
  local chapterstring=""
--  reaper.MB(String,"",0)
  String=String:match("<chapter_context>.-\n*(.*)\n*</chapter_context>")
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
  String=String:match("<tags>.-\n*%s*%t*(.-)\n*%s*%t*</tags>")
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
  local MarkupType=String:match("markup_type=\"(.-)\"")
  local MarkupVers=String:match("markup_version=\"(.-)\"")
  String=String:match("<parameters.->.-\n*(.*)\n*</parameters>")
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
      Params[counter][2]=Params[counter][2].."\n"..tempdesc
    end
  end
  if MarkupType==nil then MarkupType="plain_text" end
  if MarkupVers==nil then MarkupVers="-" end
  return counter, Params, MarkupType, MarkupVers
end

function ultraschall.ParseRetvals(String)
--reaper.MB(String,"",0)
  MarkupType=String:match("markup_type=\"(.-)\"")
  MarkupVers=String:match("markup_version=\"(.-)\"")
  ASLUG=String:match("slug>\n*(.-)\n*</slug")
  String=String:match("<retvals.->.-\n*(.*)\n*</retvals>")
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
  return String:match("<target_document>.-\n*(.-)\n*</target_document>")
end

function ultraschall.ParseSourceDocument(String)
  return String:match("<source_document>.-\n*(.-)\n*</source_document>")
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
  text=string.gsub(text, "\r", "")
  text=string.gsub(text, "\n", "<br>")
  text=string.gsub(text, "  ", "&nbsp;&nbsp;")
  text=string.gsub(text, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
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
