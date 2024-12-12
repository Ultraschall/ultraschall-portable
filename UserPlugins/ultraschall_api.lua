--[[
################################################################################
# 
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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

-- requires at least Reaper 7.03, SWS 2.10.0.1 and JS-extension 1.215

-- check for correct available versions
local ReaperVersion=reaper.GetAppVersion()
ReaperVersion=tonumber(ReaperVersion:match("(%d%.%d*)"))

if ultraschall_override==nil then  
  if ReaperVersion<7.03 then reaper.MB("Sorry, Reaper 7.03 or higher must be installed to use the API. \nGo to reaper.fm to get it.","Reaper version too old",0) return end
  if reaper.CF_LocateInExplorer==nil then reaper.MB("Sorry, SWS 2.10.0.1 or higher must be installed to use the API. \nGo to sws-extension.org to get it.","SWS missing",0) return end
  if reaper.JS_ReaScriptAPI_Version==nil or reaper.JS_ReaScriptAPI_Version()<1.215 then reaper.MB("Sorry, JS-extension-plugin 1.215 or higher must be installed to use the API. \nGo to https://github.com/juliansader/ReaExtensions/tree/master/js_ReaScriptAPI/ to get it.","JS-Extension plugin missing",0) return end
end
-- create ultraschall-table
ultraschall={}
ultraschall.temp, ultraschall.Script_Context=reaper.get_action_context()

-- include beta-functions(true) or not(false)
ultraschall.US_BetaFunctions=false

-- get the current system's separator
if reaper.GetOS():sub(1,3) == "Win" then ultraschall.Separator = "\\" else ultraschall.Separator = "/" end

-- get script-path for later use
ultraschall.Script_Context=string.gsub(ultraschall.Script_Context, "\\", "/")

-- get ultraschall-api-path
if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  ultraschall.Api_Path=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/"
else
  ultraschall.Api_Path=reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api/"
end

ultraschall.Api_InstallPath=ultraschall.Api_Path:sub(1,-2):match("(.*)/")
ultraschall.API_TempPath=ultraschall.Api_Path.."/temp/"
ultraschall.Api_ScriptPath=ultraschall.Api_Path.."/Scripts"


-- load the individual parts of the framework, if set to ON
dofile(ultraschall.Api_Path .. "ultraschall_functions_engine.lua")
dofile(ultraschall.Api_Path .. "ultraschall_gfx_engine.lua")
dofile(ultraschall.Api_Path .. "ultraschall_video_engine.lua")
dofile(ultraschall.Api_Path .. "ultraschall_doc_engine.lua")
dofile(ultraschall.Api_Path .. "ultraschall_tag_engine.lua")

-- if BETA-functions are available and usage of beta-functions is set to ON, include them. 
-- Functions, that are in both, the "normal" parts of the framework as well as in the beta-part, will use the beta-version,
-- if betafunctions are set to ON
if ultraschall.US_BetaFunctions==true then
  if reaper.file_exists(ultraschall.Api_Path.."ultraschall_functions_engine_beta.lua")==true and ultraschall.Script_Context:match("ultraschall_functions_engine_beta")==nil then     dofile(ultraschall.Api_Path .. "ultraschall_functions_engine_beta.lua")   end
end

function ultraschall.ApiTest() reaper.MB("Ultraschall-API works successfully","Ultraschall API-TEST", 0) end

-- allow debugging of functions
    -- show in ReaScript-console SetExtState and SetProjExtState-changes
if reaper.GetExtState("ultraschall_api", "debug_extstate")=="true" then
    ultraschall.temp_GetProjExtState=reaper.GetProjExtState
    ultraschall.temp_SetProjExtState=reaper.SetProjExtState

    ultraschall.temp_GetExtState=reaper.GetExtState
    ultraschall.temp_SetExtState=reaper.SetExtState

    function reaper.SetExtState(extname, key, value, persist)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print(ultraschall.Script_Context.."\n\tExtState -> Set: \""..tostring(extname).."\" \""..tostring(key).."\" \""..tostring(value).."\" "..tostring(persist))
      end
      return ultraschall.temp_SetExtState(extname, key, value, persist)
    end

    function reaper.SetProjExtState(proj, extname, key, value)
      if ultraschall.temp_GetExtState("ultraschall_api", "debug_extstate")=="true" then 
        print(ultraschall.Script_Context.."\n\tProjExtState -> Set: \""..tostring(extname).."\" \""..tostring(key).."\" \""..tostring(value).."\"")
      end
      return ultraschall.temp_SetProjExtState(proj, extname, key, value)
    end
end
-- end of debugging of functions