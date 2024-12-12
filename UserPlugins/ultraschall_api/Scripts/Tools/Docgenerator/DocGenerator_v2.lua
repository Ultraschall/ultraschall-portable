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
  --]]

-- some variables that can be set in the source-script to control stuff:

-- DontSort=true -- if DontSort==true, then the index and the functions/entries will not be sorted
-- Index=4 -- set the number of columns of the index (1-4)
-- USDocMLLink="" -- which document to replace usdocml:// with?



local FunctionList=FunctionList


-- some functions needed

PanDoc=reaper.GetExtState("Ultraschall", "PanDoc_Path", "\"c:\\Program Files\\Pandoc\\pandoc.exe\"")
if PanDoc=="" then PanDoc="\"c:\\Program Files\\Pandoc\\pandoc.exe\"" end

if CurrentDocs==nil then CurrentDocs="" end

function ultraschall.SplitUSDocBlocs(String)
  local Table={}
  local Counter=0

  local USDocBlockCounter, USDocBlocTable = ultraschall.Docs_GetAllUSDocBlocsFromString(String)
  for i=1, USDocBlockCounter do
    Table[i]={}
    Table[i][2]=USDocBlocTable[i]
    Table[i][1]=Table[i][2]:match("<slug>\n*%s*\t*(.-)\n*%s*\t*</slug>")               -- the Slug
    Table[i][3]=Table[i][2]:match("<US_DocBloc.-version=\"(.-)\".->")   -- version
    Table[i][4]=Table[i][2]:match("<US_DocBloc.-spok_lang=\"(.-)\".->") -- spok-language
    Table[i][5]=Table[i][2]:match("<US_DocBloc.-prog_lang=\"(.-)\".->") -- prog-language
  end
  
  return USDocBlockCounter, Table
end

function ultraschall.ParseChapterContext(String)
  local Chapter={}
  local counter=0
  local chapterstring=""
  local temp
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


function ColorateFunctionnames(String)
  local offset1, offset2
  String=" "..String
  if String:match("extension_api") and String:match("\"")~=nil then
    offset1, offset2 = String:match("%(\"().-()\"")
  elseif
    String:match("%)%(")~=nil then
    offset1, offset2 = String:match("()%(.-%)()%(")
  else
    offset1, offset2 = String:match(".* ().-()%(")
  end
  if offset1==nil or offset2==nil then
    --print2(String)
  end
  if offset1==nil or offset2==nil then 
    return "<em>"..String.."</em>"
  else
    return String:sub(1,offset1-1).."<em>"..String:sub(offset1, offset2-1).."</em>"..String:sub(offset2, -1)
  end
end

function ultraschall.ColorateDatatypes(String)
  if String==nil then String=" " end
  String=" "..String.." "
  String=string.gsub(String, "%(", "( ")
  String=string.gsub(String, "%[", "[ ")
  String=string.gsub(String, " boolean ", " <i>boolean</i> ")
  String=string.gsub(String, " Boolean ", " <i>Boolean</i> ")
  String=string.gsub(String, " bool ", " <i>bool</i> ")
  String=string.gsub(String, " bool%* ", " <i>bool*</i> ")
--reaper.MB("LULA:"..String,"",0)
  String=string.gsub(String, " void ", " <i>void</i> ")
  String=string.gsub(String, " void%* ", " <i>void*</i> ")
  String=string.gsub(String, " integer ", " <i>integer</i> ")
  String=string.gsub(String, " int ", " <i>int</i> ")
  String=string.gsub(String, " int%* ", " <i>int*</i> ")
  String=string.gsub(String, " Int ", " <i>Int</i> ")
  String=string.gsub(String, " const ", " <i>const</i> ")
  String=string.gsub(String, " char ", " <i>char</i> ")
  String=string.gsub(String, " char%* ", " <i>char*</i> ")
  String=string.gsub(String, " string ", " <i>string</i> ")
  String=string.gsub(String, " number ", " <i>number</i> ")
  String=string.gsub(String, " double ", " <i>double</i> ")
  String=string.gsub(String, " double%* ", " <i>double*</i> ")
  String=string.gsub(String, " float ", " <i>float</i> ")
  String=string.gsub(String, " float%* ", " <i>float*</i> ")
  String=string.gsub(String, " Float ", " <i>Float</i> ")
  String=string.gsub(String, " ReaProject%* ", " <i>ReaProject*</i> ")
  String=string.gsub(String, " ReaProject ", " <i>ReaProject</i> ")
  String=string.gsub(String, " String ", " <i>String</i> ")
  String=string.gsub(String, " MediaItem%*", " <i>MediaItem*</i> ")
  String=string.gsub(String, " MediaItem ", " <i>MediaItem</i> ")
  String=string.gsub(String, " MediaTrack ", " <i>MediaTrack</i> ")
  String=string.gsub(String, " MediaTrack%*", " <i>MediaTrack*</i> ")
  
  
  String=string.gsub(String, " AudioAccessor ", " <i>AudioAccessor</i> ")
  String=string.gsub(String, " AudioAccessor%* ", " <i>AudioAccessor*</i> ")
  String=string.gsub(String, " BR_Envelope ", " <i>BR_Envelope</i> ")
  String=string.gsub(String, " HWND ", " <i>HWND</i> ")
  String=string.gsub(String, " ImGui_Context ", " <i>ImGui_Context</i> ")
  String=string.gsub(String, " ImGui_DrawList ", " <i>ImGui_DrawList</i> ")
  
  String=string.gsub(String, " identifier ", " <i>identifier</i> ")
  String=string.gsub(String, " reaper.array ", " <i>reaper.array</i> ")
  String=string.gsub(String, " PackageEntry ", " <i>PackageEntry</i> ")  
  String=string.gsub(String, " IReaperControlSurface ", " <i>IReaperControlSurface</i> ")
  
  String=string.gsub(String, " joystick_device ", " <i>joystick_device</i> ")
  String=string.gsub(String, " KbdSectionInfo ", " <i>KbdSectionInfo</i> ")
  String=string.gsub(String, " KbdSectionInfo%* ", " <i>KbdSectionInfo*</i> ")
  String=string.gsub(String, " PCM_source ", " <i>PCM_source</i> ")
  String=string.gsub(String, " PCM_source%* ", " <i>PCM_source*</i> ")
  String=string.gsub(String, " RprMidiTake ", " <i>RprMidiTake</i> ")
  String=string.gsub(String, " MediaItem_Take ", " <i>MediaItem_Take</i> ")
  String=string.gsub(String, " MediaItem_Take%* ", " <i>MediaItem_Take*</i> ")
  String=string.gsub(String, " TrackEnvelope%* ", " <i>TrackEnvelope*</i> ")
  String=string.gsub(String, " TrackEnvelope ", " <i>TrackEnvelope</i> ")
  String=string.gsub(String, " WDL_FastString ", " <i>WDL_FastString</i> ")
  
  String=string.gsub(String, " LICE_IBitmap%* ", " <i>LICE_IBitmap*</i> ")  
  String=string.gsub(String, " WDL_VirtualWnd_BGCfg%* ", " <i>WDL_VirtualWnd_BGCfg*</i> ")  
  String=string.gsub(String, " preview_register_t%* ", " <i>preview_register_t*</i> ")  
  String=string.gsub(String, " screensetNewCallbackFunc ", " <i>screensetNewCallbackFunc</i> ")  
  String=string.gsub(String, " ISimpleMediaDecoder%* ", " <i>ISimpleMediaDecoder*</i> ")  
  String=string.gsub(String, " LICE_pixel ", " <i>LICE_pixel</i> ")  
  String=string.gsub(String, " HINSTANCE ", " <i>HINSTANCE</i> ")  
  String=string.gsub(String, " LICE_IFont%* ", " <i>LICE_IFont*</i> ")  
  String=string.gsub(String, " HFONT ", " <i>HFONT</i> ")  
  String=string.gsub(String, " RECT%* ", " <i>RECT*</i> ")  
  String=string.gsub(String, " UINT ", " <i>UINT</i> ")  
  String=string.gsub(String, " unsigned ", " <i>unsigned</i> ")  
  String=string.gsub(String, " MSG%* ", " <i>MSG*</i> ")  
  String=string.gsub(String, " HMENU ", " <i>HMENU</i> ")  
  String=string.gsub(String, " MIDI_event_t%* ", " <i>MIDI_event_t*</i> ")  
  String=string.gsub(String, " MIDI_eventlist%* ", " <i>MIDI_eventlist*</i> ")  
  String=string.gsub(String, " DWORD ", " <i>DWORD</i> ")  
  String=string.gsub(String, " ACCEL%* ", " <i>ACCEL*</i> ")  
  String=string.gsub(String, " PCM_source_peaktransfer_t%* ", " <i>PCM_source_peaktransfer_t*</i> ")  
  String=string.gsub(String, " PCM_source_transfer_t%* ", " <i>PCM_source_transfer_t*</i> ")  
  String=string.gsub(String, " audio_hook_register_t%* ", " <i>audio_hook_register_t*</i> ")  
  String=string.gsub(String, " size_t ", " <i>size_t</i> ")  
  String=string.gsub(String, " function ", " <i>function</i> ")  
  String=string.gsub(String, " ReaperArray ", " <i>ReaperArray</i> ")  
  String=string.gsub(String, " optional ", " <i>optional</i> ")  
  String=string.gsub(String, " table ", " <i>table</i> ")  
  String=string.gsub(String, " array ", " <i>array</i> ")  
  String=string.gsub(String, " FxChain", " <i>FxChain</i> ")
  
  String=string.gsub(String, "%( ", "(")
  String=string.gsub(String, "%[ ", "[")
  return String:sub(2,-2)
end



-- Let's begin:

-- Step 1: read the docs-source-file(s)
String=""
if type(Infilename)=="table" then
  for i=1, #Infilename do
    String=String..ultraschall.ReadFullFile(Infilename[i], false)
  end
else
    String=ultraschall.ReadFullFile(Infilename, false)
end

-- split into individual USDocBlocs
Ccount, AllUSDocBloc_Header=ultraschall.SplitUSDocBlocs(String)
AllUSDocBloc_Header_Slugs={}

for i=1, Ccount do
  AllUSDocBloc_Header_Slugs[AllUSDocBloc_Header[i][1]]=AllUSDocBloc_Header[i]
end

-- get some API-version-information
local usD,usversion,usdate,usbeta,usTagline,usF,usG=ultraschall.GetApiVersion()


-- Step 2: create the index
index=1
b=0

function contentindex()
  print_update(CurrentDocs..": Create Index\n")
  HeaderList={}
  local count=1
  local count2=0
  
  -- get the chapter-contexts
  -- every entry in HeaderList is "chaptercontext1, chaptercontext2,"
  while AllUSDocBloc_Header[count]~=nil do
    local A, AA, AAA = ultraschall.ParseChapterContext(AllUSDocBloc_Header[count][2])        
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
  
  if DontSort==nil then
    table.sort(HeaderList)
  end
  
  -- add to the chapter-contexts the accompanying slugs, using newlines
  -- "chaptercontext1, chaptercontext2,\nslug1\nslug2\nslug3\n" etc
  count=1
  while AllUSDocBloc_Header[count]~=nil do    
    local A1, AA1, AAA1 = ultraschall.ParseChapterContext(AllUSDocBloc_Header[count][2])
    local Slug=AllUSDocBloc_Header[count][1]
    local temp=AAA1.."\n"
       
    for i=1, count2 do
      if HeaderList[i]:match("(.-\n)")==temp then 
            HeaderList[i]=HeaderList[i]..Slug.."\n"
            --print2(HeaderList[i])
            break 
      end
    end    
    count=count+1
  end
    
  if DontSort==nil then
    table.sort(HeaderList)
  end
  
  -- now we sort the slugs
  for i=1, count2 do
    local chapter=HeaderList[i]:match("(.-\n)")
    local slugs=HeaderList[i]:match("\n(.*)\n")

    local A2, AA2, AAA2 = ultraschall.SplitStringAtLineFeedToArray(slugs)
    if DontSort==nil then
      table.sort(AA2)      
    end
    slugs=""
    for i=1, A2 do
      slugs=slugs..AA2[i].."\n"      
    end
    HeaderList[i]=chapter..slugs
  end
  
--  FunctionList=""
  
  -- now we create the index
  FunctionsLister={}
  FunctionsLister_Count=0
  
  for i=1, count2 do
    -- Header for each category
    local Top=HeaderList[i]:match("(.-),")
    local Second=HeaderList[i]:match(".-,(.-),")
    if Second~=nil and Second:sub(1,1)==" " then Second=Second:sub(2,-1) end
    local Third=HeaderList[i]:match(".-,.-,(.-),")
    if Third~=nil and Third:sub(1,1)==" " then Second=Second:sub(2,-1) end
    
    local Counts, Slugs=ultraschall.SplitStringAtLineFeedToArray(HeaderList[i]:match(".-\n(.*)\n"))
    slugs=""
    if Top==nil then One="" else One=Top end
    if Second==nil then Two="" else Two=Second end
    if Third==nil then Three="" else Three=Third end
    FunctionsLister_Count=FunctionsLister_Count+1
    FunctionsLister[FunctionsLister_Count]="HEADER:"..tostring(One).." "..tostring(Two).." "..tostring(Three).."\n"
    
    if Top==nil then Top="" else Top="<br><a class=\"inpad\" id=\""..Top.."\"><a href=\"#"..Top.."\">^</a></a><strong> <u>"..Top.."</u></strong><br><br>\n" end
    if i>1 and Top:match("u%>(.-)%</u")==HeaderList[i-1]:match("(.-),") then Top="" end
    if Second==nil then Second="" else Second="<b style=\"font-size:small;\"><br><a class=\"inpad\" id=\""..Second.."\"><a href=\"#"..Second.."\">^</a></a> "..Second.."</b>\n" end
    if i>1 and Second:match("%>(.-)%<")==HeaderList[i-1]:match("(.-),") then Second="" end
    if Third==nil then Third="" else Third=Third.."\n" end
    if i>1 and Third:match("%>(.-)%<")==HeaderList[i-1]:match("(.-),") then Third="" end
  
    -- Chapters for each category
    if Index==nil then Index=4 end
    linebreaker=1
    for a=1, Counts do
      if linebreaker==1 then slugs=slugs.."<tr>" end
      --if linebreaker==5 then slugs=slugs.."</tr>" linebreaker=1 end
      if linebreaker==Index+1 then slugs=slugs.."</tr>" linebreaker=1 end
      Title=ultraschall.Docs_GetUSDocBloc_Title(AllUSDocBloc_Header_Slugs[Slugs[a]][2], 1)
      --Title=Slugs[a]
      if Title==nil then Title=Slugs[a] end --Title="Nope" end
      slugs=slugs.."<td class=\"tdsm\"><a href=\"#"..Slugs[a].."\">"..Title.."</a></td>"      
      FunctionsLister_Count=FunctionsLister_Count+1
      FunctionsLister[FunctionsLister_Count]=Slugs[a]
      linebreaker=linebreaker+1
    end 
    if linebreaker==1 then slugs=slugs.."<td class=\"inds\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==2 and Index>1 then slugs=slugs.."<td class=\"inds\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==3 and Index>2 then slugs=slugs.."<td class=\"inds\">&nbsp;</td>" linebreaker=linebreaker+1 end
    if linebreaker==4 and Index>3 then slugs=slugs.."<td class=\"inds\">&nbsp;</td>" linebreaker=linebreaker+1 end
    slugs=slugs.."</tr>"
    
    FunctionList=FunctionList.."<table class=\"indexpad\" border=\"0\"><tr><td>"..Top..Second..Third.."</td></tr>"..slugs.."</table>"
  end

    FunctionList=FunctionList.."<br></div>"
    
    for i=1, FunctionsLister_Count do
      if FunctionsLister[i]:sub(1,4)~="HEAD" then
        for a=1, Ccount do
          if AllUSDocBloc_Header[a][1]==FunctionsLister[i] then
            FunctionsLister[i]=a
          end
        end
      end
    end
end


-- Step 3: convert Markdown to HTML
function convertMarkdown(start, stop)
  if start==nil then start=1 end
  if stop==nil then stop=Ccount end
  
  print_update(CurrentDocs..": Converting Markdown")
  FunctionConverter={}
  FunctionConverter_count=0
  ultraschall.WriteValueToFile(Tempfile.."1.md", "")  
  for i=start, stop do
    local Description
    Description, AllUSDocBloc_Header[i]["markup_type"] = ultraschall.Docs_GetUSDocBloc_Description(AllUSDocBloc_Header[i][2], true, 1)
    
    -- uncomment, to check, if an entry contains no link though being markdowned, which is a
    -- hint, that the markdown was added by accident
    --if AllUSDocBloc_Header[i]["markup_type"]=="markdown" and Description:match("%]%(")==nil then
    --  print2(AllUSDocBloc_Header[i][2])
    --end

    if AllUSDocBloc_Header[i]["markup_type"]=="plaintext" then
      AllUSDocBloc_Header[i][6]=ultraschall.Docs_ConvertPlainTextToHTML(Description, false, true)
    else
      ultraschall.WriteValueToFile(Tempfile.."1.md", "\n\n    TUDELU "..i.." "..AllUSDocBloc_Header[i][1].."\n\n"..Description.."\n\n---\n\n    TUDELUS \n\n---\n\n", nil, true)

      --ultraschall.WriteValueToFile(Tempfile.."-FullIn.md", Description,nil,true)
      FunctionConverter_count=FunctionConverter_count+1
      FunctionConverter[FunctionConverter_count]=i
    end
    --]]
  end 

  ultraschall.WriteValueToFile(Tempfile.."1.md", "\n\n    TUDELU2\n\n", nil, true)


  Batch=""
  Batch=Batch..PanDoc.." -f markdown_strict -t html \""..ultraschall.Api_Path.."/temp/1.md\" -o \""..ultraschall.Api_Path.."/temp/1.html\"\n"
  
  ultraschall.WriteValueToFile(Tempfile.."/Batch.bat", Batch)

  reaper.ExecProcess(Tempfile.."/Batch.bat", 0)  

  ConvertedEntries=ultraschall.ReadFullFile(Tempfile.."1.html")
  
  k=0
  
  for i, f, e in string.gmatch(ConvertedEntries, "<code>TUDELU (.-) (.-)</code></pre>(.-)<hr />.-<pre><code>TUDELUS ") do
    -- Uncomment to check for markdown in descriptions with no content
    -- if i:match("TUDELUS")~=nil then print2(i) end
    if tonumber(i)==nil then print2(i, f) end    
    if e:match("TUDELUS") then print2(i, f) end
    AllUSDocBloc_Header[tonumber(i)][6]=e
  end

  os.remove(Tempfile.."/Batch.bat")
  os.remove(Tempfile.."/1.md")
  os.remove(Tempfile.."/1.html")
end


-- Step 4: create the entries
function entries(start, stop)
  if start==nil then start=1 end
  if stop==nil then stop=FunctionsLister_Count end
  for EntryCount=start, stop do
    if type(FunctionsLister[EntryCount])=="string" then
      -- Insert a header for the next functions-category inside the functions
      -- still ugly. Uncomment it to see it for yourself...
      --FunctionList=FunctionList.."<div class=\"chapterpad\"><hr><h3><a id=\"Functions:"..FunctionsLister[EntryCount]:sub(8,-1).."\"></a><a href=\"#"..FunctionsLister[EntryCount]:sub(8,-1).."\">^</a>"..FunctionsLister[EntryCount]:sub(8,-1).."-functions</h3>"
    else
      --print_update(i)
      local title=ultraschall.Docs_GetUSDocBloc_Title(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], 1)
  
      -- get the requires
      local req_count, requires, requires_alt = ultraschall.Docs_GetUSDocBloc_Requires(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2])
  
      -- get the functioncalls
      local functioncall={}
      local f1, f2= ultraschall.Docs_GetUSDocBloc_Functioncall(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], 1)
      if f1~=nil and f2==nil then f2="lua" end
      if f2~=nil and f1~=nil then
        functioncall[f2]=f1
        f1, f2= ultraschall.Docs_GetUSDocBloc_Functioncall(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], 2)
        if f2~=nil then functioncall[f2]=f1 end
        f1, f2= ultraschall.Docs_GetUSDocBloc_Functioncall(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], 3)
        if f2~=nil then functioncall[f2]=f1 end
        f1, f2= ultraschall.Docs_GetUSDocBloc_Functioncall(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], 4)
        if f2~=nil then functioncall[f2]=f1 end
      end
      
      
      -- get the parameters
      local Parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = ultraschall.Docs_GetUSDocBloc_Params(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], true, 1)
      for i=1, Parmcount do
        Params[i][2]=ultraschall.Docs_ConvertPlainTextToHTML(Params[i][2])
      end
      -- get the return values
      local Retvalscount, Retvals, markuptype, markupversion, prog_lang, spok_lang, indent = ultraschall.Docs_GetUSDocBloc_Retvals(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], true, 1)
      for i=1, Retvalscount do
        Retvals[i][2]=ultraschall.Docs_ConvertPlainTextToHTML(Retvals[i][2])
      end
      -- slug and anchor
      FunctionList=FunctionList..[[
      
        <div class="ch">
          <hr>
          <a class="anch" id="]]..AllUSDocBloc_Header[FunctionsLister[EntryCount]][1]..[["></a>
          <a href="#]]..AllUSDocBloc_Header[FunctionsLister[EntryCount]][1]..[["> ^</a> ]]
      
      -- requires
      if requires_alt["Reaper"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/reaper"..requires_alt["Reaper"]..".png\" alt=\"requires Reaper version "..requires_alt["Reaper"].."\">"
      end
      if requires_alt["SWS"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/sws"..requires_alt["SWS"]..".png\" alt=\"requires SWS version "..requires_alt["SWS"].."\">"
      end
      if requires_alt["JS"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/js_"..requires_alt["JS"]..".png\" alt=\"requires JS version "..requires_alt["JS"].."\">"
      end
      if requires_alt["Osara"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/Osara"..requires_alt["Osara"]..".png\" alt=\"requires Osara version "..requires_alt["Osara"].."\">"
      end
      if requires_alt["ReaImGui"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/reaimgui"..requires_alt["ReaImGui"]..".png\" alt=\"requires ReaImGui version "..requires_alt["ReaImGui"].."\">"
      end
      if requires_alt["ReaBlink"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/reablink"..requires_alt["ReaBlink"]..".png\" alt=\"requires ReaBlink version "..requires_alt["ReaBlink"].."\">"
      end
      if requires_alt["ReaLlm"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/llm"..requires_alt["ReaLlm"]..".png\" alt=\"requires ReaLlm version "..requires_alt["ReaLlm"].."\">"
      end
      if requires_alt["Ultraschall"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/ultraschall"..requires_alt["Ultraschall"]..".png\" alt=\"requires Ultraschall version "..requires_alt["Ultraschall"].."\">"
      end
      
      if requires_alt["ReaGirl"]~=nil then
        FunctionList=FunctionList.."\n          <img width=\"3%\" src=\"gfx/reagirl"..requires_alt["ReaGirl"]..".png\" alt=\"requires ReaGirl version "..requires_alt["ReaGirl"].."\">"
      end
      
      -- Title
      --if title==nil then print3(AllUSDocBloc_Header[FunctionsLister[EntryCount]][1]) end
      if title==nil then title=AllUSDocBloc_Header[FunctionsLister[EntryCount]][1]end
      FunctionList=FunctionList.."<u><b>"..title.."</b></u><br>"
      if AllUSDocBloc_Header[FunctionsLister[EntryCount]][6]==nil then AllUSDocBloc_Header[FunctionsLister[EntryCount]][6]="Error #1 in docs, please report this entry to the developer!!!" end
      
      
      -- Functioncalls
      if functioncall["cpp"]~=nil or 
         functioncall["lua"]~=nil or 
         functioncall["python"]~=nil or 
         functioncall["eel"]~=nil or
         functioncall["javascript"]~=nil 
      then
        AllUSDocBloc_Header[FunctionsLister[EntryCount]]["Tohoo"]=true
        FunctionList=FunctionList.."\t\t\t<p>\n"
        FunctionList=FunctionList..[[
  
          <div class="cc">
]]
        if functioncall["cpp"]~=nil then
          FunctionList=FunctionList.."            <div class=\"c\">C: <code>"..ColorateFunctionnames(ultraschall.ColorateDatatypes(functioncall["cpp"])).."</code></div>\n"
        end
        if functioncall["eel"]~=nil then
          FunctionList=FunctionList.."            <div class=\"e\">EEL2: <code>"..ColorateFunctionnames(ultraschall.ColorateDatatypes(functioncall["eel"])).."</code></div>\n"
        end
        if functioncall["lua"]~=nil then
          FunctionList=FunctionList.."            <div class=\"l\">Lua: <code>"..ColorateFunctionnames(ultraschall.ColorateDatatypes(functioncall["lua"])).."</code></div>\n"
        end
        if functioncall["python"]~=nil then
          FunctionList=FunctionList.."            <div class=\"p\">Python: <code>"..ColorateFunctionnames(ultraschall.ColorateDatatypes(functioncall["python"])).."</code></div>\n"
        end
        if functioncall["javascript"]~=nil then
          FunctionList=FunctionList.."            <div class=\"j\">Javascript: <code>"..ColorateFunctionnames(ultraschall.ColorateDatatypes(functioncall["javascript"])).."</code></div>\n"
        end
        FunctionList=FunctionList.."\t\t  </div><p>\n"
      else
        FunctionList=FunctionList.."\t\t\t<p>\n"
      end    
      
      --Description
      FunctionList=FunctionList..[[
          <div class="ch">
  ]]..AllUSDocBloc_Header[FunctionsLister[EntryCount]][6]
                ..[[              
          </div><br>]]

      -- Retvals
      if Retvalscount>0 then
        FunctionList=FunctionList..[[
      
          <u>Returnvalues:</u>
]]
      
        for i=1, Retvalscount do
          Retvals[i][1]=ultraschall.ColorateDatatypes(Retvals[i][1])
          FunctionList=FunctionList..[[
          <table class="ch">
            <tr><td class="pr">]]..Retvals[i][1]..[[</td></tr>
            <tr><td class="ch2">]]..Retvals[i][2]..[[</td></tr>
          </table>
]]
        end 
        FunctionList=FunctionList.."          <br>\n"
      end
      
      -- Parameters
      if Parmcount>0 then
        FunctionList=FunctionList..[[
          <u>Parameters:</u>
]]
        for i=1, Parmcount do
          Params[i][1]=ultraschall.ColorateDatatypes(Params[i][1])
          FunctionList=FunctionList..[[
          <table class="ch">
            <tr><td class="pr">]]..Params[i][1]..[[</td></tr>
            <tr><td class="ch2">]]..Params[i][2]..[[</td></tr>
          </table>
]]
        end 
        FunctionList=FunctionList.."          <br>\n"
      end
      
      local count_examples, examples=ultraschall.Docs_GetUSDocBloc_Examples(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2])

      local Examples=""
      if count_examples>0 then 
        Examples="<u>Code-Examples:</u><br><table class=\"ch\">\n"
        for i=1, #examples do
          Examples=Examples.."<tr><td><a href=\""..examples[i]["url"].."\">"..examples[i]["name"].."</a> - "..examples[i]["description"].."("..examples[i]["author"]..")</td></tr>\n"
        end
        Examples=Examples.."</table><br>\n"
      end
      
      FunctionList=FunctionList..Examples.."\n"
      
      local linked_to_count, links, description = ultraschall.Docs_GetUSDocBloc_LinkedTo(AllUSDocBloc_Header[FunctionsLister[EntryCount]][2], true, 1)

      local Links=""
      if linked_to_count>0 then
        Links=Links.."<u>"..description.."</u><br><table class=\"ch\">\n"
        
        for i=1, #links do
          Links=Links.."<tr><td><li><a href=\"#"..links[i].link.."\">"..links[i].link.."</a> - "..links[i].description.."</td></tr>\n"
        end
        Links=Links.."</table><br>"
      end
      
          -- Closing Tags
        FunctionList=FunctionList..Links.."\n"
        
        FunctionList=FunctionList..[[

        </div>
    ]]
    end
    
    NewDone=""
    mode=2
    for k in string.gmatch(FunctionList, "(.-\n)") do
      if k:match("<pre><code>")~=nil then mode=1 end      
      
      if mode==1 then 
        NewDone=NewDone..k
      elseif mode==2 then
        NewDone=NewDone..k:match("%s*(.*)")
      end
      if k:match("</code></pre>")~=nil then mode=2 end
    end
    
    if USDocMLLink~=nil then 
      NewDone=string.gsub(NewDone, "usdocml://", USDocMLLink)
    end
    ultraschall.WriteValueToFile(Outfile, NewDone, nil, true)
    SLEM()
   
    
    FunctionList=""
    print_update(CurrentDocs..": "..EntryCount.."/"..Ccount, reaper.time_precise())
  end
  
  FunctionList=FunctionList..[[
      <div class="ch">
        <hr>
                     
          <table><td class="td2"> ]]
          
          if programming_language_selector==true then 
            FunctionList=FunctionList.."View: [<span class='aclick'>all</span>] [<span class='cclick'><a href=\"#c\" onClick=\"setdocview('c')\">C/C++</a></span>] [<span class='eclick'><a href=\"#e\" onClick=\"setdocview('e')\">EEL2</a></span>] [<span class='lclick'><a href=\"#l\" onClick=\"setdocview('l')\">Lua</a></span>] [<span class='pclick'><a href=\"#p\" onClick=\"setdocview('p')\">Python</a></span>]" 
          end
          
   FunctionList=FunctionList..[[&#160;</td><td>&#160;</td><td class="td3">Automatically generated by Ultraschall-API ]]..usversion..[[ ]]..usbeta..[[ - ]]..Ccount..[[ elements available <br></td></table>
        <hr>
      </div>
      <br>
      </body>
  </html>
  ]]
end

mode=2
FunctionList=FunctionList..[[<div class="ch"><p></p>
    <!-- Clipboard Button -->
    <script src="./scripts/clipboard.min.js.Download"></script>


    <!-- External Script -->
    <script src="./scripts/scripts.js.Download"></script>
]]
contentindex()
convertMarkdown()
ultraschall.WriteValueToFile(Outfile, string.gsub(FunctionList, "\n%s*", "\n"))
--ultraschall.WriteValueToFile(Outfile, FunctionList)
FunctionList=""
entries()

-- Step 5: Write the outputfile
ultraschall.WriteValueToFile(Outfile, FunctionList, nil, true)

USDocMLLink=nil
DontSort=nil
Index=nil


