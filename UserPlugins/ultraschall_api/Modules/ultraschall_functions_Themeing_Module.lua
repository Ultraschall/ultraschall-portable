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
  local i=0
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
  local i=0
  local ParamsIdx ={}
  local tmp, desc, C, D, E, F
  tmp=1
  while tmp ~= nil do
    tmp, desc, C, D, E, F = reaper.ThemeLayout_GetParameter(i)    
    if tmp==nil then break end
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
function ultraschall.ApplyAllThemeLayoutParameters(ThemeLayoutParameters, persist, refresh)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ApplyAllThemeLayoutParameters</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ApplyAllThemeLayoutParameters(table ThemeLayoutParameters, boolean persist, boolean refresh)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    allows applying all theme-layout-parameter-values from a ThemeLayoutParameters-table, as gettable by [GetAllThemeLayoutParameters](#GetAllThemeLayoutParameters)
    
    the table ThemeLayoutParameters is of the following format:

    ThemeLayoutParameters[parameter_index]["name"] - the name of the parameter
    ThemeLayoutParameters[parameter_index]["description"] - the description of the parameter
    ThemeLayoutParameters[parameter_index]["value"] - the value of the parameter
    ThemeLayoutParameters[parameter_index]["value default"] - the defult value of the parameter
    ThemeLayoutParameters[parameter_index]["value min"] - the minimum value of the parameter
    ThemeLayoutParameters[parameter_index]["value max"] - the maximum value of the parameter
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    table ThemeLayoutParameters - a table, which holds all theme-layout-parameter-values to apply; set values to nil to use default-value
    boolean persist - true, the new values shall be persisting; false, values will not be persisting and lost after theme-change/Reaper restart
    boolean refresh - true, refresh the theme to show the applied changes; false, don't refresh
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, apply, all, parameters</tags>
</US_DocBloc>
]]
  if type(ThemeLayoutParameters)~="table" then ultraschall.AddErrorMessage("ApplyAllThemeLayoutParameters", "ThemeLayoutParameters", "must be a ThemeLayoutParameters-table, as created by GetAllThemeLayoutParameters", -1) return false end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("ApplyAllThemeLayoutParameters", "persist", "must be a boolean", -2) return false end
  if type(refresh)~="boolean" then ultraschall.AddErrorMessage("ApplyAllThemeLayoutParameters", "refresh", "must be a boolean", -3) return false end
  for i=1, #ThemeLayoutParameters do
    if ThemeLayoutParameters[i]["value"]~=nil then
      if ThemeLayoutParameters[i]["value"]>ThemeLayoutParameters[i]["value max"] or ThemeLayoutParameters[i]["value"]<ThemeLayoutParameters[i]["value min"] then
        ultraschall.AddErrorMessage("ApplyAllThemeLayoutParameters", "ThemeLayoutParameters", "entry: "..i.." \""..ThemeLayoutParameters[i]["name"].."\" - isnt within the allowed valuerange of this parameter("..ThemeLayoutParameters[i]["value min"].." - "..ThemeLayoutParameters[i]["value max"]..")", -7)
        return false
      end
    end
  end
  for i=1, #ThemeLayoutParameters do
    local val=ThemeLayoutParameters[i]["value"]
    if val==nil then val=ThemeLayoutParameters[i]["value default"] end
    reaper.ThemeLayout_SetParameter(i, val, persist)
  end  
  if refresh==true then
    reaper.ThemeLayout_RefreshAll()
  end
  return true
end

function ultraschall.GetThemeParameterIndexByName(parametername)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetThemeParameterIndexByName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer parameterindex, string retval, optional string desc, optional number value, optional number defValue, optional number minValue, optional number maxValue = ultraschall.GetThemeParameterIndexByName(string parametername)</functioncall>
  <description>
    allows getting a theme-parameter's values by its name
    
    returns nil in case of an error
  </description>
  <retvals>
    integer parameterindex - the index of the theme-parameter
    string retval - the name of the theme-parameter
    optional string desc - the description of the theme-parameter
    optional number value - the current value of the theme-parameter
    optional number defValue - the default value of the theme-parameter
    optional number minValue - the minimum-value of the theme-parameter
    optional number maxValue - the maximum-value of the theme-parameter
  </retvals>
  <parameters>
    string parametername - the name of the theme-parameter, whose attributes you want to get(default v6-Theme has usually paramX, where X is a number between 0 and 80, other themes may differ from that)
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, parameters, by name</tags>
</US_DocBloc>
]]
  if ultraschall.type(parametername)~="string" then ultraschall.AddErrorMessage("GetThemeParameterIndexByName", "parametername", "must be a string", -1) return end
  local retval=1
  local index=-1
  local desc, value, defValue, minValue, maxValue 
  while retval~=nil do
    index=index+1
    retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(index)
    if retval==parametername then return index, retval, desc, value, defValue, minValue, maxValue end
  end
  ultraschall.AddErrorMessage("GetThemeParameterIndexByName", "parametername", "no such parameter found", -2) 
end

--A={ultraschall.GetThemeParameterIndexByName("param1")}

function ultraschall.SetThemeParameterIndexByName(parametername, value, persist, strict)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetThemeParameterIndexByName</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetThemeParameterIndexByName(string parametername, integer value, boolean persist, optional boolean strict)</functioncall>
  <description>
    allows setting the theme-parameter value by its name
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string parametername - the name of the theme-parameter, whose attributes you want to set(default v6-Theme has usually paramX, where X is a number between 0 and 80, other themes may differ from that)
    integer value - the new value to set
    boolean persist - true, the new value shall persist; false, the new value shall only be used until Reaper is closed
    optional boolean strict - true or nil, only allow values within the minimum and maximum values of the parameter; false, allows setting values out of the range
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, parameter, value, by name</tags>
</US_DocBloc>
]]
  if ultraschall.type(parametername)~="string" then ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "parametername", "must be a string", -1) return false end
  if ultraschall.type(value)~="number: integer" then ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "value", "must be an integer", -2) return false end
  if ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "persist", "must be a boolean", -3) return false end
  if strict~=nil and ultraschall.type(strict)~="boolean" then ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "strict", "must be nil(for true) or a boolean", -4) return false end
  ultraschall.SuppressErrorMessages(true)
  local index, retval, desc, pvalue, defValue, minValue, maxValue = ultraschall.GetThemeParameterIndexByName(parametername)
  ultraschall.SuppressErrorMessages(false)
  if index==nil then ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "parametername", "no such parameter found", -5) return false end
  if strict~=false then
    if maxValue~=nil and minValue~=nil and (value>maxValue or value<minValue) then
      ultraschall.AddErrorMessage("SetThemeParameterIndexByName", "value", "value "..value.." out of valid bounds between "..minValue.." and "..maxValue, -6) 
      return false
    end
  end
  return reaper.ThemeLayout_SetParameter(index, value, persist)
end

function ultraschall.GetThemeParameterIndexByDescription(description)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetThemeParameterIndexByDescription</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer parameterindex, string retval, optional string desc, optional number value, optional number defValue, optional number minValue, optional number maxValue = ultraschall.GetThemeParameterIndexByDescription(string description)</functioncall>
  <description>
    allows getting a theme-parameter's values by its description
    
    returns nil in case of an error
  </description>
  <retvals>
    integer parameterindex - the index of the theme-parameter
    string retval - the name of the theme-parameter
    optional string desc - the description of the theme-parameter
    optional number value - the current value of the theme-parameter
    optional number defValue - the default value of the theme-parameter
    optional number minValue - the minimum-value of the theme-parameter
    optional number maxValue - the maximum-value of the theme-parameter
  </retvals>
  <parameters>
    string description - the description of the theme-parameter, whose attributes you want to get
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, parameters, by description</tags>
</US_DocBloc>
]]
  if ultraschall.type(description)~="string" then ultraschall.AddErrorMessage("GetThemeParameterIndexByDescription", "description", "must be a string", -1) return end
  local retval=1
  local index=-1
  local desc, value, defValue, minValue, maxValue 
  while retval~=nil do
    index=index+1
    retval, desc, value, defValue, minValue, maxValue = reaper.ThemeLayout_GetParameter(index)
    if desc==description then return index, retval, desc, value, defValue, minValue, maxValue end
  end
  ultraschall.AddErrorMessage("GetThemeParameterIndexByDescription", "description", "no such parameter found", -2) 
end

--A={ultraschall.GetThemeParameterIndexByDescription("A_tcp_LabelMeasure")}

function ultraschall.SetThemeParameterIndexByDescription(description, value, persist, strict)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetThemeParameterIndexByDescription</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetThemeParameterIndexByDescription(string description, integer value, boolean persist, optional boolean strict)</functioncall>
  <description>
    allows setting the theme-parameter value by its description
    
    returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string description - the description of the theme-parameter, whose attributes you want to set
    integer value - the new value to set
    boolean persist - true, the new value shall persist; false, the new value shall only be used until Reaper is closed
    optional boolean strict - true or nil, only allow values within the minimum and maximum values of the parameter; false, allows setting values out of the range
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, parameter, value, by description</tags>
</US_DocBloc>
]]
  if ultraschall.type(description)~="string" then ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "description", "must be a string", -1) return false end
  if ultraschall.type(value)~="number: integer" then ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "value", "must be an integer", -2) return false end
  if ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "persist", "must be a boolean", -3) return false end
  if strict~=nil and ultraschall.type(strict)~="boolean" then ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "strict", "must be nil(for true) or a boolean", -4) return false end
  ultraschall.SuppressErrorMessages(true)
  local index, retval, desc, pvalue, defValue, minValue, maxValue = ultraschall.GetThemeParameterIndexByDescription(description)
  ultraschall.SuppressErrorMessages(false)
  if index==nil then ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "description", "no such parameter found", -5) return false end
  if strict~=false then
    if maxValue~=nil and minValue~=nil and (value>maxValue or value<minValue) then
      ultraschall.AddErrorMessage("SetThemeParameterIndexByDescription", "value", "value "..value.." out of valid bounds between "..minValue.." and "..maxValue, -6) 
      return false
    end
  end
  return reaper.ThemeLayout_SetParameter(index, value, persist)
end

--AAA=ultraschall.SetThemeParameterIndexByDescription("A_tcp_Record_Arm", 2, false, true)

