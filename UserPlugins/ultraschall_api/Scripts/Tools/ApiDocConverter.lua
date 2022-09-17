if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

local Found_usdocblocs, All_found_usdocblocs
local DocsEntries=""
USDocBlocs={}
local DocsFiles={}
DocsFiles[1]=ultraschall.Api_Path.."DocsSourcefiles/reaper-apidocs.USDocML"

DocsFilecount=1

function ReadDocsFile()
  DocsContent=ultraschall.ReadFullFile(DocsFiles[DocsFilecount])
  Found_usdocblocs, All_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(DocsContent)  
  for i=1, Found_usdocblocs do
    USDocBlocs[i]={}
    USDocBlocs[i]["slug"]=ultraschall.Docs_GetUSDocBloc_Slug(All_found_usdocblocs[i])
    USDocBlocs[i]["title"], USDocBlocs[i]["title_language"] = ultraschall.Docs_GetUSDocBloc_Title(All_found_usdocblocs[i], 1)
    USDocBlocs[i]["description"], USDocBlocs[i]["description_markup_type"], USDocBlocs[i]["description_markup_version"], USDocBlocs[i]["indent"] = ultraschall.Docs_GetUSDocBloc_Description(All_found_usdocblocs[i], true, 1)
    USDocBlocs[i]["target_document"] = ultraschall.Docs_GetUSDocBloc_TargetDocument(All_found_usdocblocs[i])
    USDocBlocs[i]["source_document"] = ultraschall.Docs_GetUSDocBloc_SourceDocument(All_found_usdocblocs[i])    
    USDocBlocs[i]["chapters_count"], USDocBlocs[i]["chapters"] = ultraschall.Docs_GetUSDocBloc_ChapterContext(All_found_usdocblocs[i], 1)
    USDocBlocs[i]["tags_count"], USDocBlocs[i]["tags"] = ultraschall.Docs_GetUSDocBloc_Tags(All_found_usdocblocs[i], 1)
    USDocBlocs[i]["params_count"], USDocBlocs[i]["params"], USDocBlocs[i]["params_markuptype"], USDocBlocs[i]["params_markupversion"] = ultraschall.Docs_GetUSDocBloc_Params(All_found_usdocblocs[i], true, 1)
    USDocBlocs[i]["retvals_count"], USDocBlocs[i]["retvals"], USDocBlocs[i]["retvals_markuptype"], USDocBlocs[i]["retvals_markupversion"] = ultraschall.Docs_GetUSDocBloc_Retvals(All_found_usdocblocs[i], true, 1)
    USDocBlocs[i]["functioncall1"], USDocBlocs[i]["functioncall_proglang1"] = ultraschall.Docs_GetUSDocBloc_Functioncall(All_found_usdocblocs[i], 1)
    USDocBlocs[i]["functioncall2"], USDocBlocs[i]["functioncall_proglang2"] = ultraschall.Docs_GetUSDocBloc_Functioncall(All_found_usdocblocs[i], 2)
    USDocBlocs[i]["functioncall3"], USDocBlocs[i]["functioncall_proglang3"] = ultraschall.Docs_GetUSDocBloc_Functioncall(All_found_usdocblocs[i], 3)
    USDocBlocs[i]["functioncall4"], USDocBlocs[i]["functioncall_proglang4"] = ultraschall.Docs_GetUSDocBloc_Functioncall(All_found_usdocblocs[i], 4)
    USDocBlocs[i]["requires_count"], USDocBlocs[i]["requires"], USDocBlocs[i]["requires_alt"] = ultraschall.Docs_GetUSDocBloc_Requires(All_found_usdocblocs[i])    
  end
end

function ConvertDescriptions()
  -- convert descriptions, who need markdown
  Descriptions_Strings_Markdown=""
  for i=1, Found_usdocblocs do
    if USDocBlocs[i]["description_markup_type"]=="markdown" then
      Descriptions_Strings_Markdown=Descriptions_Strings_Markdown.."\n\nSeparatorTextBlablablaBubbelbubbelbubbelNumber"..i.."\n\n"..USDocBlocs[i]["description"]
    elseif USDocBlocs[i]["description_markup_type"]=="plaintext" then
      USDocBlocs[i]["description"]=ultraschall.Docs_ConvertPlainTextToHTML(USDocBlocs[i]["description"])
    end
  end

  ultraschall.WriteValueToFile(ultraschall.API_TempPath.."/temporary.md", Descriptions_Strings_Markdown)
  Pandoc=string.gsub("c:\\Program Files\\Pandoc\\pandoc.exe -f markdown_strict -t html "..ultraschall.Api_Path.."/temp/temporary.md -o "..ultraschall.Api_Path.."/temp/temporary.html", "/", "\\")
  
  L=reaper.ExecProcess(Pandoc, 0)
  Descriptions_Strings_Markdown=ultraschall.ReadFullFile(ultraschall.Api_Path.."/temp/temporary.html")

  for k in string.gmatch(Descriptions_Strings_Markdown, "(.-)<p>SeparatorTextBlablablaBubbelbubbelbubbelNumber") do
    A,B=k:match("(.-)</p>\n(.*)")
    if B~=nil then
      USDocBlocs[tonumber(A)]["description"]=B
      -- if A=="30" then print2(B) end  -- debugline
    end
  end
end
    
-- convert params, who need markdown
function ConvertParams()

end
  
-- convert retvals, who need markdown
function ConvertRetvals()

end  

-- create Index
function CreateDocsIndex()
  
end

-- create DocsEntries
function CreateDocsEntries()
    for ol=1, 20 do
      i=Acount2
      DocsEntries=DocsEntries.."<p>"
      DocsEntries=DocsEntries.."<a id=\""..USDocBlocs[i]["slug"].."\">"           -- html anchor
      DocsEntries=DocsEntries.."<a href=\"#"..USDocBlocs[i]["slug"].."\">^</a>"   -- link
      if USDocBlocs[i]["requires_alt"]["Reaper"]~=nil then DocsEntries=DocsEntries.."<img src=\"gfx/reaper"..USDocBlocs[i]["requires_alt"]["Reaper"]..".png\">" end
      if USDocBlocs[i]["requires_alt"]["Lua"]~=nil then DocsEntries=DocsEntries.."<img src=\"gfx/lua"..USDocBlocs[i]["requires_alt"]["Lua"]..".png\">" end
      if USDocBlocs[i]["requires_alt"]["SWS"]~=nil then DocsEntries=DocsEntries.."<img src=\"gfx/sws"..USDocBlocs[i]["requires_alt"]["SWS"]..".png\">" end
      if USDocBlocs[i]["requires_alt"]["JS"]~=nil then DocsEntries=DocsEntries.."<img src=\"gfx/JS_"..USDocBlocs[i]["requires_alt"]["JS"]..".png\">" end
      if USDocBlocs[i]["requires_alt"]["ReaPack"]~=nil then DocsEntries=DocsEntries.."<img src=\"gfx/ReaPack"..USDocBlocs[i]["requires_alt"]["ReaPack"]..".png\">" end
      DocsEntries=DocsEntries.."<u><b>"..USDocBlocs[i]["slug"].."</b></u><br>\n"  -- slug/functionname
  
      if USDocBlocs[i]["functioncall1"]~=nil or 
         USDocBlocs[i]["functioncall2"]~=nil or 
         USDocBlocs[i]["functioncall3"]~=nil or 
         USDocBlocs[i]["functioncall4"]~=nil then    
        DocsEntries=DocsEntries.."<p><u>Functioncall:</u><p>\n"
        if USDocBlocs[i]["functioncall1"]~=nil then DocsEntries=DocsEntries.."<b>C:</b> "     ..USDocBlocs[i]["functioncall1"].."<br>" end
        if USDocBlocs[i]["functioncall2"]~=nil then DocsEntries=DocsEntries.."<b>EEL:</b> "   ..USDocBlocs[i]["functioncall2"].."<br>" end
        if USDocBlocs[i]["functioncall3"]~=nil then DocsEntries=DocsEntries.."<b>Lua:</b> "   ..USDocBlocs[i]["functioncall3"].."<br>" end
        if USDocBlocs[i]["functioncall4"]~=nil then DocsEntries=DocsEntries.."<b>Python:</b> "..USDocBlocs[i]["functioncall4"].."<br>" end
        DocsEntries=DocsEntries.."<p><u>Description:</u><p>\n"
      end
      
      DocsEntries=DocsEntries..USDocBlocs[i]["description"]
      
      if USDocBlocs[i]["retvals_count"]~=nil then    
        DocsEntries=DocsEntries.."<p><u>Retvals:</u><p>\n"
        DocsEntries=DocsEntries.."<table>"
        for a=1, USDocBlocs[i]["retvals_count"] do
          DocsEntries=DocsEntries.."<tr><td>"..USDocBlocs[i]["retvals"][a][1].."</td><td> - <td>"
          DocsEntries=DocsEntries.."<td>"..USDocBlocs[i]["retvals"][a][2].."</td></tr>"
        end
        DocsEntries=DocsEntries.."</table>"
      end
      
      if USDocBlocs[i]["params_count"]~=nil then    
        DocsEntries=DocsEntries.."<p><u>Parameters:</u><p>\n"
        DocsEntries=DocsEntries.."<table>"
        for a=1, USDocBlocs[i]["params_count"] do
          DocsEntries=DocsEntries.."<tr><td>"..USDocBlocs[i]["params"][a][1].."</td><td> - <td>"
          DocsEntries=DocsEntries.."<td>"..USDocBlocs[i]["params"][a][2].."</td></tr>"
        end
        DocsEntries=DocsEntries.."</table>"
      end
      if USDocBlocs[i]["tags_count"]~=nil then
        DocsEntries=DocsEntries.."<p><u>Tags:</u></br>"
        for a=1, USDocBlocs[i]["tags_count"]-1 do
          DocsEntries=DocsEntries..USDocBlocs[i]["tags"][a]..", "
        end
        DocsEntries=DocsEntries..USDocBlocs[i]["tags"][USDocBlocs[i]["tags_count"]]
      end
      DocsEntries=DocsEntries.."<hr>"
      
    Acount2=Acount2+1 if Acount2>Found_usdocblocs then break end
  end
  if Acount2<=Found_usdocblocs then reaper.defer(CreateDocsEntries) else print3(DocsEntries) end
end


Acount=0
Acount2=1
function main()
  Acount=Acount+1
  if Acount==1 then ReadDocsFile() end
  if Acount==2 then ConvertDescriptions() end
  if Acount==3 then ConvertParams() end
  if Acount==4 then ConvertRetvals() end
  if Acount==8 then CreateDocsIndex() end
  if Acount==9 then CreateDocsEntries() end
  if Acount<9 then reaper.defer(main) end
end

main()
