  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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
  
-- checks USDocML-docs for common parameter/retvals mismatches in docs and puts findings into the clipboard
-- currently only Reaper-API-docs supported, for whatever reason.

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

Found=""

Filelist={
"DocsSourcefiles/Reaper_Api_Documentation.USDocML",
"Modules/ultraschall_functions_AudioManagement_Module.lua",
"Modules/ultraschall_functions_AutomationItems_Module.lua",
"Modules/ultraschall_functions_Clipboard_Module.lua",
"Modules/ultraschall_functions_Color_Module.lua",
"Modules/ultraschall_functions_ConfigurationFiles_Module.lua",
"Modules/ultraschall_functions_ConfigurationSettings_Module.lua",
"Modules/ultraschall_functions_DeferManagement_Module.lua",
"Modules/ultraschall_functions_Envelope_Module.lua",
"Modules/ultraschall_functions_EventManager.lua",
"Modules/ultraschall_functions_FileManagement_Module.lua",
"Modules/ultraschall_functions_FXManagement_Module.lua",
"Modules/ultraschall_functions_HelperFunctions_Module.lua",
"Modules/ultraschall_functions_Imagefile_Module.lua",
"Modules/ultraschall_functions_Localize_Module.lua",
"Modules/ultraschall_functions_Markers_Module.lua",
"Modules/ultraschall_functions_MediaItem_MediaItemStates_Module.lua",
"Modules/ultraschall_functions_MediaItem_Module.lua",
"Modules/ultraschall_functions_MetaData_Module.lua",
"Modules/ultraschall_functions_MIDIManagement_Module.lua",
"Modules/ultraschall_functions_Muting_Module.lua",
"Modules/ultraschall_functions_Navigation_Module.lua",
"Modules/ultraschall_functions_ProjectManagement_Module.lua",
"Modules/ultraschall_functions_ProjectManagement_ProjectFiles_Module.lua",
"Modules/ultraschall_functions_ReaMote_Module.lua",
"Modules/ultraschall_functions_ReaperUserInterface_Module.lua",
"Modules/ultraschall_functions_Render_Module.lua",
"Modules/ultraschall_functions_Themeing_Module.lua",
"Modules/ultraschall_functions_TrackManagement_Module.lua",
"Modules/ultraschall_functions_TrackManagement_Routing_Module.lua",
"Modules/ultraschall_functions_TrackManagement_TrackStates_Module.lua",
"Modules/ultraschall_functions_TrackManager_Module.lua",
"Modules/ultraschall_functions_Ultraschall_Module.lua",
"Modules/ultraschall_functions_WebInterface_Module.lua",

"ultraschall_doc_engine.lua", 
"ultraschall_functions_engine.lua", 
"ultraschall_functions_engine_beta.lua", 
"ultraschall_gfx_engine.lua", 
"ultraschall_ModulatorLoad3000.lua", 
"ultraschall_tag_engine.lua", 
"ultraschall_video_engine.lua", 
"DocsSourcefiles/Reaper_API_Video_Documentation.USDocML"
}

for i=1, 1 do
  A=ultraschall.ReadFullFile(ultraschall.Api_Path..Filelist[i])
  
  --A=ultraschall.ReadFullFile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/DocsSourcefiles/reaper-apidocs.USDocML")
  
  Afound_usdocblocs, Aall_found_usdocblocs = ultraschall.Docs_GetAllUSDocBlocsFromString(A)
  Found=Found..Filelist[i].."\n"
  Found=Found.."\tParameters:\n\n"
  
  for i=1, Afound_usdocblocs do
    functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 1)
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 2) end
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 3) end
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 4) end
    
    if functioncall~=nil then 
      functioncall=functioncall:match("%((.*)%)")
      count, individual_values = ultraschall.CSV2IndividualLinesAsArray(functioncall)
      local parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = ultraschall.Docs_GetUSDocBloc_Params(Aall_found_usdocblocs[i], false, 1)
      foundduplicate=false
      for a=1, parmcount do
        for i=1, parmcount do
          if a~=i then
            if Params[i][1]==Params[a][1] then
              foundduplicate=true
            end
          end
        end
      end
      if foundduplicate==true or (count~=-1 and parmcount~=count and individual_values[1]~="") then 
        Found=Found.."\t\t"..tostring(parmcount).." "..tostring(count).." "..i.." "..ultraschall.Docs_GetUSDocBloc_Slug(Aall_found_usdocblocs[i]).."\n"
        --Found=Found..ultraschall.Docs_GetUSDocBloc_Slug(Aall_found_usdocblocs[i]).."\n" 
      end
    end
  end
  
  Found=Found.."\n\n\tRetVals:\n\n"
  
  for i=1, Afound_usdocblocs do
    functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 1)
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 2) end
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 3) end
    if prog_lang~="lua" then functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 4) end
    
    if functioncall~=nil then 
      functioncall2=functioncall:match("(.*)=")
      count, individual_values = ultraschall.CSV2IndividualLinesAsArray(functioncall2)
      parmcount, Params, markuptype, markupversion, prog_lang, spok_lang, indent = ultraschall.Docs_GetUSDocBloc_Retvals(Aall_found_usdocblocs[i], false, 1)
      foundduplicate=false
      for a=1, parmcount do
        for i=1, parmcount do
          if a~=i then
            if Params[i][1]==Params[a][1] then
              foundduplicate=true
            end
          end
        end
      end
      if foundduplicate==true or (count~=-1 and parmcount~=count and individual_values[1]~="") then 
        Found=Found.."\t\t"..tostring(parmcount).." "..tostring(count).." "..i.." "..ultraschall.Docs_GetUSDocBloc_Slug(Aall_found_usdocblocs[i]).."\n"
        --Found=Found..ultraschall.Docs_GetUSDocBloc_Slug(Aall_found_usdocblocs[i]).."\n" 
      end
    end
  end

end

print3(Found)

--[[
i=8
functioncall, prog_lang = ultraschall.Docs_GetUSDocBloc_Functioncall(Aall_found_usdocblocs[i], 1)
functioncall2=functioncall:match("(.*) .-reaper%..-%(")
count, individual_values = ultraschall.CSV2IndividualLinesAsArray(functioncall)
AAA={ultraschall.Docs_GetUSDocBloc_Retvals(Aall_found_usdocblocs[i], false, 1)}
--]]