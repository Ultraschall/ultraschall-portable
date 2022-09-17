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
]] 

-- 1. put the ultraschall_api-folder and the accompanying file into UserPlugins in your ressources-folder. The whole folder, not just the contents!
-- 2. open a new Lua-script in Reaper
-- 3. type in 
--          dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
-- 4. have fun using the API. Test it with ultraschall.ApiTest()

-- requires at least Reaper 6.20, SWS 2.10.0.1 and JS-extension 1.215


local ReaperVersion=reaper.GetAppVersion()
ReaperVersion=tonumber(ReaperVersion:match("(%d%.%d*)"))

if ReaperVersion<6.20 then reaper.MB("Sorry, Reaper 6.20 or higher must be installed to use the API. \nGo to reaper.fm to get it.","Reaper version too old",0) return end
if reaper.CF_LocateInExplorer==nil then reaper.MB("Sorry, SWS 2.10.0.1 or higher must be installed to use the API. \nGo to sws-extension.org to get it.","SWS missing",0) return end
if reaper.JS_ReaScriptAPI_Version==nil or reaper.JS_ReaScriptAPI_Version()<1.215 then reaper.MB("Sorry, JS-extension-plugin 1.215 or higher must be installed to use the API. \nGo to https://github.com/juliansader/ReaExtensions/tree/master/js_ReaScriptAPI/ to get it.","JS-Extension plugin missing",0) return end

--if type(ultraschall)~="table" then ultraschall={} end

ultraschall={}

ultraschall.temp, ultraschall.Script_Context=reaper.get_action_context()


--[[
-- Beta-Functions On
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/beta.txt")==true then
    ultraschall.US_BetaFunctions=true
else
    ultraschall.US_BetaFunctions=false
end
--]]

-- allow debugging of functions
    
if reaper.GetExtState("ultraschall_api", "debug_extstate")=="true" then
    ultraschall.temp_GetProjExtState=reaper.GetProjExtState
    ultraschall.temp_SetProjExtState=reaper.SetProjExtState

    ultraschall.temp_GetExtState=reaper.GetExtState
    ultraschall.temp_SetExtState=reaper.SetExtState

    --[[
    function reaper.GetExtState(extname, key)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print("ExtState -> Get: \""..extname.."\" \""..key.."\"")
      end
      return ultraschall.temp_GetExtState(extname, key)
    end
    --]]
    function reaper.SetExtState(extname, key, value, persist)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print(ultraschall.Script_Context.."\n\tExtState -> Set: \""..tostring(extname).."\" \""..tostring(key).."\" \""..tostring(value).."\" "..tostring(persist))
      end
      return ultraschall.temp_SetExtState(extname, key, value, persist)
    end
    --[[
    function reaper.GetProjExtState(proj, extname, key)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print("ProjExtState -> Get: \""..extname.."\" \""..key.."\"")
      end
      return ultraschall.temp_GetProjExtState(proj, extname, key)
    end
    --]]
    function reaper.SetProjExtState(proj, extname, key, value)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print(ultraschall.Script_Context.."\n\tProjExtState -> Set: \""..tostring(extname).."\" \""..tostring(key).."\" \""..tostring(value).."\"")
      end
      return ultraschall.temp_SetProjExtState(proj, extname, key, value)
    end
    --]]
end
ultraschall.US_BetaFunctions=false


ultraschall.temp1,ultraschall.temp=reaper.get_action_context()
ultraschall.temp=string.gsub(ultraschall.temp,"\\","/")
ultraschall.temp1=reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua"
ultraschall.temp1=string.gsub(ultraschall.temp1,"\\","/")

if ultraschall.temp1 == ultraschall.temp then 
  local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  string2=tonumber(string2)
  string2=string2+1
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")    
end


if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    ultraschall.Separator = "\\"
else
    ultraschall.Separator = "/"
end

local info = debug.getinfo(1,'S');
--ultraschall.Script_Path = info.source:match[[^@?(.*[\/])[^\/]-$]]
  ultraschall.Script_Path = reaper.GetResourcePath().."/Scripts/"-- ultraschall.info.source:match[[^@?(.*[\/])[^\/]-$]]
local script_path = reaper.GetResourcePath().."/UserPlugins/ultraschall_api"..ultraschall.Separator
ultraschall.Api_Path=script_path
ultraschall.Api_Path=string.gsub(ultraschall.Api_Path,"\\","/")
ultraschall.Api_InstallPath=string.gsub(reaper.GetResourcePath().."/UserPlugins/", "\\", "/")
ultraschall.API_TempPath=string.gsub(reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/", "\\", "/")

ultraschall.Api_ScriptPath=ultraschall.Api_Path.."/Scripts"


ultraschall.ApiFunctionTest=function()
  --reaper.MB("Ultraschall Functions-Engine is OFF","Ultraschall-API",0)
  ultraschall.functions_works="off"
end

ultraschall.ApiGFXTest=function()
  --reaper.MB("Ultraschall Functions-Engine is OFF","Ultraschall-API",0)
  ultraschall.gfx_works="off"
end

ultraschall.ApiVideoTest=function()
  ultraschall.video_works="off"
  --reaper.MB("Ultraschall Video-Engine is OFF","Ultraschall-API",0)
end

ultraschall.ApiDocTest=function()
  ultraschall.doc_works="off"
  --reaper.MB("Ultraschall Doc-Engine is OFF","Ultraschall-API",0)
end

ultraschall.ApiTagTest=function()
  ultraschall.tag_works="off"
  --reaper.MB("Ultraschall Tag-Engine is OFF","Ultraschall-API",0)
end

ultraschall.ApiBetaFunctionsTest=function()
  ultraschall.functions_beta_works="off"
  --reaper.MB("BETA-Ultraschall Functions-Engine is OFF","Ultraschall-API (BETA)",0)
end

ultraschall.ApiBetaGFXTest=function()
  ultraschall.gfx_beta_works="off"
  --reaper.MB("BETA-Ultraschall GUI-Engine is OFF","Ultraschall-API (BETA)",0)
end

ultraschall.ApiBetaVideoTest=function()
  ultraschall.video_beta_works="off"
  --reaper.MB("BETA-Ultraschall Video-Engine is OFF","Ultraschall-API (BETA)",0)
end

ultraschall.ApiBetaDocTest=function()
  ultraschall.doc_beta_works="off"
  --reaper.MB("BETA-Ultraschall Doc-Engine is OFF","Ultraschall-API (BETA)",0)
end

ultraschall.ApiBetaTagTest=function()
  ultraschall.tag_beta_works="off"
  --reaper.MB("BETA-Ultraschall Tag-Engine is OFF","Ultraschall-API (BETA)",0)
end



-- include the individual parts of the framework, if set to ON
ultraschall.US_Functions_Engine = dofile(script_path .. "ultraschall_functions_engine.lua")
if ultraschall.US_GFX_Engine~="OFF" then ultraschall.US_GFX_Engine = dofile(script_path .. "ultraschall_gfx_engine.lua") end
if ultraschall.US_Video_Engine~="OFF" then ultraschall.US_Video_Engine = dofile(script_path .. "ultraschall_video_engine.lua") end
if ultraschall.US_Doc_Engine~="OFF" then ultraschall.US_Doc_Engine = dofile(script_path .. "ultraschall_doc_engine.lua") end
if ultraschall.US_Tag_Engine~="OFF" then ultraschall.US_Tag_Engine = dofile(script_path .. "ultraschall_tag_engine.lua") end



-- if BETA-functions are available and usage of beta-functions is set to ON, include them. 
-- Functions, that are in both, the "normal" parts of the framework as well as in the beta-part, will use the beta-version,
-- if betafunctions are set to ON
if ultraschall.US_BetaFunctions==true then
  if reaper.file_exists(script_path.."ultraschall_functions_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_functions_engine_beta")==nil then ultraschall.BETA=dofile(script_path .. "ultraschall_functions_engine_beta.lua") end
  if reaper.file_exists(script_path.."ultraschall_gfx_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_gfx_engine_beta")==nil then ultraschall.BETA=dofile(script_path .. "ultraschall_gfx_engine_beta.lua") end 
  if reaper.file_exists(script_path.."ultraschall_video_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_video_engine_beta")==nil then ultraschall.BETA=dofile(script_path .. "ultraschall_video_engine_beta.lua") end
  if reaper.file_exists(script_path.."ultraschall_doc_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_doc_engine_beta")==nil then ultraschall.BETA=dofile(script_path .. "ultraschall_doc_engine_beta.lua") end
  if reaper.file_exists(script_path.."ultraschall_tag_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_tag_engine_beta")==nil then ultraschall.BETA=dofile(script_path .. "ultraschall_tag_engine_beta.lua") end
end


function ultraschall.ApiTest()
    -- show "Api Part-Engine"-messages, when calling ultraschall.ApiTest()
    ultraschall.ApiFunctionTest()
    ultraschall.ApiVideoTest()
    
    ultraschall.ApiDocTest()
    ultraschall.ApiTagTest()


    ultraschall.ApiBetaFunctionsTest()
    ultraschall.ApiBetaVideoTest()
    ultraschall.ApiBetaDocTest()
    ultraschall.ApiBetaTagTest()
    
    ultraschall.network_works="off"    
    
    reaper.MB("Ultraschall-API works successfully","Ultraschall API-TEST",0)
end


-- In case of necessary hotfixes, if the file ultraschall_hotfixes.lua exists, the functions in it will overwrite previously existing ones.
if reaper.file_exists(script_path.."ultraschall_hotfixes.lua") then ultraschall.Hotfix=dofile(script_path .. "ultraschall_hotfixes.lua") end