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
---        Themeing Module        ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Ultraschall-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "Functions-Build", string, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  reaper.BR_Win32_WritePrivateProfileString("Ultraschall-Api-Build", "API-Build", string2, reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")  
  ultraschall={} 
  
  ultraschall.API_TempPath=reaper.GetResourcePath().."/UserPlugins/ultraschall_api/temp/"
end

function ultraschall.GetAllThemeLayoutNames()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllThemeLayoutNames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, table ThemeLayoutNames= ultraschall.GetAllThemeLayoutNames()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns all layout-names and values of the current theme
    
    the table ThemeLayoutNames is of the following format:
    
      ThemeLayoutNames[parameter_index]["layout section"] - the name of the layout-section of the parameter
      ThemeLayoutNames[parameter_index]["value"] - the value of the parameter
      ThemeLayoutNames[parameter_index]["description"] - the description of the parameter
    
    returns nil in case of an error
  </description>
  <retvals>
    integer index - the number of theme-layout-parameters available
    table ThemeLayoutParameters - a table with all theme-layout-parameter available in the current theme
  </retvals>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, all, parameters</tags>
</US_DocBloc>
]]
  local Aretval=true
  local Layoutnames={}
  local i=1
  while Aretval==true do
    Layoutnames[i]={}
    Aretval, Layoutnames[i]["layout section"] = reaper.ThemeLayout_GetLayout("seclist", i)
    Aretval, Layoutnames[i]["value"] = reaper.ThemeLayout_GetLayout(Layoutnames[i]["layout section"], -1)
    Aretval, Layoutnames[i]["description"] = reaper.ThemeLayout_GetLayout(Layoutnames[i]["layout section"], -2)
    
    i=i+1
  end
  table.remove(Layoutnames, i-1)
  return i-2, Layoutnames
end

--A,B,C=ultraschall.GetAllThemeLayoutNames()

--Q,R = reaper.ThemeLayout_GetLayout("trans", -1)

function ultraschall.GetAllThemeLayoutParameters()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllThemeLayoutParameters</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer index, table ThemeLayoutParameters = ultraschall.GetAllThemeLayoutParameters()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    returns all theme-layout-parameter attributes of the current theme
    
    the table ThemeLayoutParameters is of the following format:
    
      ThemeLayoutParameters[parameter_index]["name"] - the name of the parameter
      ThemeLayoutParameters[parameter_index]["description"] - the description of the parameter
      ThemeLayoutParameters[parameter_index]["value"] - the value of the parameter
      ThemeLayoutParameters[parameter_index]["value default"] - the defult value of the parameter
      ThemeLayoutParameters[parameter_index]["value min"] - the minimum value of the parameter
      ThemeLayoutParameters[parameter_index]["value max"] - the maximum value of the parameter
    
    returns nil in case of an error
  </description>
  <retvals>
    integer index - the number of theme-layout-parameters available
    table ThemeLayoutParameters - a table with all theme-layout-parameter available in the current theme
  </retvals>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, all, parameters</tags>
</US_DocBloc>
]]
  local i=1
  local ParamsIdx ={}
  
  while reaper.ThemeLayout_GetParameter(i) ~= nil do
    local tmp, desc, C, D, E, F = reaper.ThemeLayout_GetParameter(i)
    ParamsIdx[i]={}
    ParamsIdx[i]["name"]=tmp
    ParamsIdx[i]["description"]=desc
    ParamsIdx[i]["value"]=C
    ParamsIdx[i]["value default"]=D
    ParamsIdx[i]["value min"]=E
    ParamsIdx[i]["value max"]=F
    
    i = i + 1
  end
  
  return i-1, ParamsIdx
end
