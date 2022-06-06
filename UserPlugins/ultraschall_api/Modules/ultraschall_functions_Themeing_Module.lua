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
  <description>
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
  <description>
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

function ultraschall.Theme_Defaultv6_SetHideTCPElement(Layout, Element, if_mixer_visible, if_track_not_selected, if_track_not_armed, always_hide, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetHideTCPElement</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetHideTCPElement(string Layout, integer Element, boolean if_mixer_visible, boolean if_track_not_selected, boolean if_track_not_armed, boolean always_hide, boolean persist)</functioncall>
  <description>
    Hides/unhides elements from TCP when using the default Reaper 6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose element you want to hide/unhide; either "A", "B" or "C"
    integer Element - the element, whose hide-state you want to set
                    - 1, record arm
                    - 2, monitor
                    - 3, trackname
                    - 4, volume
                    - 5, routing
                    - 6, insert fx
                    - 7, envelope
                    - 8, pan and width
                    - 9, record mode
                    - 10, input
                    - 11, labels and values
                    - 12, meter values
    boolean if_mixer_visible - true, hide element, when mixer is visible; false, don't hide element, when mixer is visible
    boolean if_track_not_selected - true, hide element, when track is not selected; false, don't hide element when track is not selected
    boolean if_track_not_armed - true, hides element, when track is not armed; false, don't hide element when track is not armed
    boolean always_hide - true, always hides element; false, don't always hide element
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, hide, element, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "Layout", "must be either A, B or C", -1) return false end
  if math.type(Element)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "Element", "must be an integer", -2) return false end
  if Element<1 or Element>12 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "Element", "must be between 1 and 12", -3) return false end
  if type(if_mixer_visible)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "if_mixer_visible", "must be a boolean", -4) return false end
  
  if type(if_track_not_selected)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "if_track_not_selected", "must be a boolean", -5) return false end
  if type(if_track_not_armed)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "if_track_not_armed", "must be a boolean", -6) return false end
  if type(always_hide)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "always_hide", "must be a boolean", -7) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetHideTCPElement", "persist", "must be a boolean", -8) return false end

  local val=0
  if if_mixer_visible==true then val=val+1 end
  if if_track_not_selected==true then val=val+2 end
  if if_track_not_armed==true then val=val+4 end
  if always_hide==true then val=val+8 end
  
  local elementname
  if     Element==1 then elementname="Record_Arm" 
  elseif Element==2 then elementname="Monitor" 
  elseif Element==3 then elementname="Track_Name"
  elseif Element==4 then elementname="Volume"
  elseif Element==5 then elementname="Routing"
  elseif Element==6 then elementname="Effects"
  elseif Element==7 then elementname="Envelope"
  elseif Element==8 then elementname="Pan_&_Width"
  elseif Element==9 then elementname="Record_Mode"
  elseif Element==10 then elementname="Input"
  elseif Element==11 then elementname="Values"
  elseif Element==12 then elementname="Meter_Values"
  end

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, val, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--ultraschall.Theme_Defaultv6_HideTCPElement("A", 1, true, false, false, false, false)


function ultraschall.Theme_Defaultv6_GetHideTCPElement(Layout, Element)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetHideTCPElement</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, boolean if_mixer_visible, boolean if_track_not_selected, boolean if_track_not_armed, boolean always_hide = ultraschall.Theme_Defaultv6_GetHideTCPElement(string Layout, integer Element)</functioncall>
  <description>
    Get the current hides/unhide-state of elements from TCP when using the default Reaper 6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, getting was successful; false, getting was unsuccessful
    boolean if_mixer_visible - true, element is hidden, when mixer is visible; false, element is not hidden, when mixer is visible
    boolean if_track_not_selected - true, element is hidden, when track is not selected; false, element is not hidden when track is not selected
    boolean if_track_not_armed - true, element is hidden, when track is not armed; false, element is not hidden when track is not armed
    boolean always_hide - true, element is always hidden; false, element isn't always hidden
  </retvals>
  <parameters>
    string Layout - the layout, whose element-hide/unhide-state you want to get; either "A", "B" or "C"
    integer Element - the element, whose hide-state you want to get
                    - 1, record arm
                    - 2, monitor
                    - 3, trackname
                    - 4, volume
                    - 5, routing
                    - 6, insert fx
                    - 7, envelope
                    - 8, pan and width
                    - 9, record mode
                    - 10, input
                    - 11, labels and values
                    - 12, meter values
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, hide, element, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetHideTCPElement", "Layout", "must be either A, B or C", -1) return false end
  if math.type(Element)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetHideTCPElement", "Element", "must be an integer", -2) return false end
  if Element<1 or Element>12 then ultraschall.AddErrorMessage("Theme_Defaultv6_GetHideTCPElement", "Element", "must be between 1 and 12", -3) return false end

  local elementname
  if     Element==1 then elementname="Record_Arm" 
  elseif Element==2 then elementname="Monitor" 
  elseif Element==3 then elementname="Track_Name"
  elseif Element==4 then elementname="Volume"
  elseif Element==5 then elementname="Routing"
  elseif Element==6 then elementname="Effects"
  elseif Element==7 then elementname="Envelope"
  elseif Element==8 then elementname="Pan_&_Width"
  elseif Element==9 then elementname="Record_Mode"
  elseif Element==10 then elementname="Input"
  elseif Element==11 then elementname="Values"
  elseif Element==12 then elementname="Meter_Values"
  end

  local parameterindex, retval, desc, val, defValue, minValue, maxValue 
  = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return true, val&1~=0, val&2~=0, val&4~=0, val&8~=0
end

--ultraschall.Theme_Defaultv6_SetHideTCPElement("A", 1, false, false, false, true, false)
--A={ultraschall.Theme_Defaultv6_GetHideTCPElement("A", 1)}

function ultraschall.Theme_Defaultv6_SetTCPNameSize(Layout, size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPNameSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPNameSize(string Layout, integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the trackname-label in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose trackname-label-size you want to set; either "A", "B" or "C"
    integer size - the new size of the tcp-trackname-label
                    - 0, auto
                    - 1, 20
                    - 2, 50
                    - 3, 80
                    - 4, 110
                    - 5, 140
                    - 6, 170
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, trackname, label, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPNameSize", "Layout", "must be either A, B or C", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPNameSize", "size", "must be an integer", -2) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPNameSize", "size", "must be between 0 and 6", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPNameSize", "persist", "must be a boolean", -4) return false end
  local elementname="LabelSize"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPNameSize("A", 6, false)

function ultraschall.Theme_Defaultv6_GetTCPNameSize(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPNameSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTCPNameSize(string Layout)</functioncall>
  <description>
    Gets the size of the trackname-label in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer size - the current size of the tcp-trackname-label
                    - 0, auto
                    - 1, 20
                    - 2, 50
                    - 3, 80
                    - 4, 110
                    - 5, 140
                    - 6, 170
  </retvals>
  <parameters>
    string Layout - the layout, whose trackname-size you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, trackname, label, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPNameSize", "Layout", "must be either A, B or C", -1) return end
  local elementname="LabelSize"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetTCPNameSize("C")

function ultraschall.Theme_Defaultv6_SetTCPVolumeSize(Layout, size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPVolumeSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPVolumeSize(string Layout, integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the volume in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose volume-size you want to set; either "A", "B" or "C"
    integer size - the new size of the tcp-volume
                    - 0, knob
                    - 1, 40
                    - 2, 70
                    - 3, 100
                    - 4, 130
                    - 5, 160
                    - 6, 190
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, volume, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPVolumeSize", "Layout", "must be either A, B or C", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPVolumeSize", "size", "must be an integer", -2) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPVolumeSize", "size", "must be between 0 and 6", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPVolumeSize", "persist", "must be a boolean", -4) return false end
  local elementname="vol_size"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPVolumeSize("A", 2, false)

function ultraschall.Theme_Defaultv6_GetTCPVolumeSize(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPVolumeSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTCPVolumeSize(string Layout)</functioncall>
  <description>
    Gets the size of the volume in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer size - the current size of the tcp-volume
                    - 0, knob
                    - 1, 40
                    - 2, 70
                    - 3, 100
                    - 4, 130
                    - 5, 160
                    - 6, 190
  </retvals>
  <parameters>
    string Layout - the layout, whose volume-size you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, volume, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPVolumeSize", "Layout", "must be either A, B or C", -1) return end
  local elementname="vol_size"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetTCPVolumeSize("A")

function ultraschall.Theme_Defaultv6_SetTCPInputSize(Layout, size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPInputSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPInputSize(string Layout, integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the input in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose input-size you want to set; either "A", "B" or "C"
    integer size - the new size of the tcp-input
                    - 0, MIN
                    - 1, 25
                    - 2, 40
                    - 3, 60
                    - 4, 90
                    - 5, 150
                    - 6, 200
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, input, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPInputSize", "Layout", "must be either A, B or C", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPInputSize", "size", "must be an integer", -2) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPInputSize", "size", "must be between 0 and 6", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPInputSize", "persist", "must be a boolean", -4) return false end
  local elementname="InputSize"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPInputSize("A", 2, false)

function ultraschall.Theme_Defaultv6_GetTCPInputSize(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPInputSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTCPInputSize(string Layout)</functioncall>
  <description>
    Gets the size of the input in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer size - the current size of the tcp-input
                    - 0, MIN
                    - 1, 25
                    - 2, 40
                    - 3, 60
                    - 4, 90
                    - 5, 150
                    - 6, 200
  </retvals>
  <parameters>
    string Layout - the layout, whose input-size you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, input, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPInputSize", "Layout", "must be either A, B or C", -1) return end
  local elementname="InputSize"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetTCPInputSize("B")

function ultraschall.Theme_Defaultv6_SetTCPMeterSize(Layout, size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPMeterSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPMeterSize(string Layout, integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the meter in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose meter-size you want to set; either "A", "B" or "C"
    integer size - the new size of the tcp-meter
                    - 1, 4
                    - 2, 10
                    - 3, 20
                    - 4, 40
                    - 5, 80
                    - 6, 160
                    - 7, 320
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, meter, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterSize", "Layout", "must be either A, B or C", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterSize", "size", "must be an integer", -2) return false end
  if size<1 or size>7 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterSize", "size", "must be between 1 and 7", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterSize", "persist", "must be a boolean", -4) return false end
  local elementname="MeterSize"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, size, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPMeterSize("A", 1, false)

function ultraschall.Theme_Defaultv6_GetTCPMeterSize(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPMeterSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTCPMeterSize(string Layout)</functioncall>
  <description>
    Gets the size of the meter in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer size - the current size of the tcp-meter
                    - 1, 4
                    - 2, 10
                    - 3, 20
                    - 4, 40
                    - 5, 80
                    - 6, 160
                    - 7, 320
  </retvals>
  <parameters>
    string Layout - the layout, whose meter-size you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, meter, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPMeterSize", "Layout", "must be either A, B or C", -1) return end
  local elementname="MeterSize"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return size
end

--A=ultraschall.Theme_Defaultv6_GetTCPMeterSize("A")

function ultraschall.Theme_Defaultv6_SetTCPMeterLocation(Layout, location, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPMeterLocation</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPMeterLocation(string Layout, integer location, boolean persist)</functioncall>
  <description>
    Sets the location of the meter in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose meter-location you want to set; either "A", "B" or "C"
    integer location - the new location of the tcp-meter
                    - 1, LEFT
                    - 2, RIGHT
                    - 3, LEFT IF ARMED
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, meter, location, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterLocation", "Layout", "must be either A, B or C", -1) return false end
  if math.type(location)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterLocation", "location", "must be an integer", -2) return false end
  if location<1 or location>3 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterLocation", "location", "must be between 1 and 3", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPMeterLocation", "persist", "must be a boolean", -4) return false end
  local elementname="MeterLoc"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, location, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPMeterLocation("A", 3, false)

function ultraschall.Theme_Defaultv6_GetTCPMeterLocation(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPMeterLocation</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer location = ultraschall.Theme_Defaultv6_GetTCPMeterLocation(string Layout)</functioncall>
  <description>
    Gets the location of the meter in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer location - the current location of the tcp-meter
                    - 1, Left
                    - 2, Right
                    - 3, Left if armed
  </retvals>
  <parameters>
    string Layout - the layout, whose meter-location you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, meter, location, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPMeterLocation", "Layout", "must be either A, B or C", -1) return end
  local elementname="MeterLoc"

  local A, B, C, location = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return location
end

--A=ultraschall.Theme_Defaultv6_GetTCPMeterLocation("A")

function ultraschall.Theme_Defaultv6_SetTCPFolderIndent(indent, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPFolderIndent(integer indent, boolean persist)</functioncall>
  <description>
    Sets the indentation of folders in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer indent - the indentation-setting of tcp-folders
                    - 0, None
                    - 1, 1/8
                    - 2, 1/4
                    - 3, 1/2
                    - 4, 1
                    - 5, 2
                    - 6, MAX
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, folder, indent, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(indent)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPFolderIndent", "indent", "must be an integer", -1) return false end
  if indent<0 or indent>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPFolderIndent", "indent", "must be between 0 and 6", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPFolderIndent", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="indent"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, indent+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPFolderIndent(6, false)

function ultraschall.Theme_Defaultv6_GetTCPFolderIndent()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer indent = ultraschall.Theme_Defaultv6_GetTCPFolderIndent()</functioncall>
  <description>
    Gets the indentation of folders in the tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer indent - the indentation-setting of tcp-folders
                    - 0, None
                    - 1, 1/8
                    - 2, 1/4
                    - 3, 1/2
                    - 4, 1
                    - 5, 2
                    - 6, MAX
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, folder, indent, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="indent"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetTCPFolderIndent()

function ultraschall.Theme_Defaultv6_SetTCPAlignControls(alignement, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPAlignControls</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPAlignControls(integer size, boolean persist)</functioncall>
  <description>
    Sets the alignment of controls in tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer alignement - the alignment-setting of tcp-controls
                    - 1, Folder Indent
                    - 2, Aligned
                    - 3, Extend Name
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, control, alignement, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(alignement)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPAlignControls", "alignement", "must be an integer", -1) return false end
  if alignement<1 or alignement>3 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPAlignControls", "alignement", "must be between 1 and 3", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPAlignControls", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="control_align"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname, alignement, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTCPAlignControls(1, false)

function ultraschall.Theme_Defaultv6_GetTCPAlignControls()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPAlignControls</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer alignement = ultraschall.Theme_Defaultv6_GetTCPAlignControls()</functioncall>
  <description>
    Gets the alignment of controls in the tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer alignement - the alignment-setting of tcp-controls
                    - 1, Folder Indent
                    - 2, Aligned
                    - 3, Extend Name
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, control, alignement, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="control_align"

  local A, B, C, alignement = ultraschall.GetThemeParameterIndexByDescription(Layout.."_tcp_"..elementname)
  return alignement
end

--A=ultraschall.Theme_Defaultv6_GetTCPAlignControls()

function ultraschall.Theme_Defaultv6_SetMCPAlignControls(alignement, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetMCPAlignControls</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetMCPAlignControls(integer alignement, boolean persist)</functioncall>
  <description>
    Sets the alignment of controls in mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer alignement - the alignment-setting of mcp-controls
                    - 1, Folder Indent
                    - 2, Aligned
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, control, alignement, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(alignement)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPAlignControls", "alignement", "must be an integer", -1) return false end
  if alignement<1 or alignement>2 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPAlignControls", "alignement", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPAlignControls", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="control_align"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname, alignement, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetMCPAlignControls(2, false)

function ultraschall.Theme_Defaultv6_GetMCPAlignControls()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetMCPAlignControls</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer alignement = ultraschall.Theme_Defaultv6_GetMCPAlignControls()</functioncall>
  <description>
    Gets the alignment of controls in the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer alignement - the alignment-setting of mcp-controls
                    - 1, Folder Indent
                    - 2, Aligned
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, control, alignement, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="control_align"

  local A, B, C, alignement = ultraschall.GetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname)
  return alignement
end

--A=ultraschall.Theme_Defaultv6_GetMCPAlignControls()

function ultraschall.Theme_Defaultv6_SetTransSize(size)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTransSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTransSize(integer size)</functioncall>
  <description>
    Sets the size of the transport-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer size - the transport-size
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, control, size, transport, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTransSize", "size", "must be an integer", -1) return false end
  if size<1 or size>3 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTransSize", "size", "must be between 1 and 3", -2) return false end
  if size==1 then size=""
  elseif size==2 then size="150%_"
  elseif size==3 then size="200%_"
  end
  local A=reaper.ThemeLayout_SetLayout("trans", size.."A")
  reaper.ThemeLayout_RefreshAll()
  return true
end

function ultraschall.Theme_Defaultv6_GetTransSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTransSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTransSize()</functioncall>
  <description>
    Gets the size of the transport-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer size - the transport-size
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, control, size, transport, default v6 theme</tags>
</US_DocBloc>
]]
  local A,B=reaper.ThemeLayout_GetLayout("trans", -1)
  if B=="A" then return 1
  elseif B=="150%_A" then return 2
  elseif B=="200%_A" then return 3
  end
end

--A=ultraschall.Theme_Defaultv6_SetTransSize(3)
--A=ultraschall.Theme_Defaultv6_GetTransSize()

function ultraschall.Theme_Defaultv6_SetTransPlayRateSize(size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTransPlayRateSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTransPlayRateSize(integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the playrate-slider in transport-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer size - the playrate-slidersize of transport-controls
                    - 0, Knob
                    - 1, 80
                    - 2, 130
                    - 3, 160
                    - 4, 200
                    - 5, 250
                    - 6, 310
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, control, size, playrate, transport, default v6 theme</tags>
</US_DocBloc>
]]
  
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTransPlayRateSize", "size", "must be an integer", -1) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTransPlayRateSize", "size", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTransPlayRateSize", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="rate_size"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_trans_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetTransPlayRateSize(6, false)

function ultraschall.Theme_Defaultv6_GetTransPlayRateSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTransPlayRateSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetTransPlayRateSize()</functioncall>
  <description>
    Gets the size of the playrate-slider in transport-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer size - the playrate-slidersize of transport-controls
                    - 0, Knob
                    - 1, 80
                    - 2, 130
                    - 3, 160
                    - 4, 200
                    - 5, 250
                    - 6, 310
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, control, size, playrate, transport, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="rate_size"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_trans_"..elementname)
  return size-1
end

function ultraschall.Theme_Defaultv6_SetEnvNameSize(size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetEnvNameSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetEnvNameSize(integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the name in envelopes when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer size - the size of the name in envelopes
                    - 0, Auto
                    - 1, 20
                    - 2, 50
                    - 3, 80
                    - 4, 110
                    - 5, 140
                    - 6, 170
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, size, name, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvNameSize", "size", "must be an integer", -1) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvNameSize", "size", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvNameSize", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="labelSize"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetEnvNameSize(2, false)

function ultraschall.Theme_Defaultv6_GetEnvNameSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetEnvNameSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetEnvNameSize()</functioncall>
  <description>
    Gets the size of the name in envelopes when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer size - the size of the name in envelopes
                    - 0, Auto
                    - 1, 20
                    - 2, 50
                    - 3, 80
                    - 4, 110
                    - 5, 140
                    - 6, 170
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, size, name, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="labelSize"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname)
  return size-1
end

function ultraschall.Theme_Defaultv6_SetEnvFaderSize(size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetEnvFaderSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetEnvFaderSize(integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the faders in envelopes when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer size - the size of the fader in envelopes
                    - 0, Knob
                    - 1, 40
                    - 2, 70
                    - 3, 100
                    - 4, 130
                    - 5, 160
                    - 6, 190
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, size, fader, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFaderSize", "size", "must be an integer", -1) return false end
  if size<0 or size>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFaderSize", "size", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFaderSize", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="fader_size"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

-- A=ultraschall.Theme_Defaultv6_SetEnvFaderSize(6, false)

function ultraschall.Theme_Defaultv6_GetEnvFaderSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetEnvFaderSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetEnvFaderSize()</functioncall>
  <description>
    Gets the size of the faders in envelopes when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer size - the size of the fader in envelopes
                    - 0, Knob
                    - 1, 40
                    - 2, 70
                    - 3, 100
                    - 4, 130
                    - 5, 160
                    - 6, 190
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, size, fader, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="fader_size"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetEnvFaderSize()

function ultraschall.Theme_Defaultv6_SetEnvFolderIndent(indentation, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetEnvFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetEnvFolderIndent(integer indentation, boolean persist)</functioncall>
  <description>
    Sets the indentation of the envelope in relation to the track-folder when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer indentation - the indentation of the enveloper in relation to the track-folder
                    - 1, Don't match track folder indent
                    - 2, Match track folder indent
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, folder, indent, match, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(indentation)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFolderIndent", "indentation", "must be an integer", -1) return false end
  if indentation<1 or indentation>2 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFolderIndent", "indentation", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvFolderIndent", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="folder_indent"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname, indentation-1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

-- A=ultraschall.Theme_Defaultv6_SetEnvFolderIndent(1, false)

function ultraschall.Theme_Defaultv6_GetEnvFolderIndent()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetEnvFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetEnvFolderIndent()</functioncall>
  <description>
    Gets the indentation of the envelope in relation to the track-folder when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer indentation - the indentation of the enveloper in relation to the track-folder
                    - 1, Don't match track folder indent
                    - 2, Match track folder indent
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, folder, indent, match, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="folder_indent"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_envcp_"..elementname)
  return size+1
end

--A=ultraschall.Theme_Defaultv6_GetEnvFolderIndent()

function ultraschall.Theme_Defaultv6_SetEnvSize(size)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetEnvSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetEnvSize(integer size)</functioncall>
  <description>
    Sets the size of the envelope-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer size - the envelope-size
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, control, size, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvSize", "size", "must be an integer", -1) return false end
  if size<1 or size>3 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetEnvSize", "size", "must be between 1 and 3", -2) return false end
  if size==1 then size=""
  elseif size==2 then size="150%_"
  elseif size==3 then size="200%_"
  end
  local A=reaper.ThemeLayout_SetLayout("envcp", size.."A")
  reaper.ThemeLayout_RefreshAll()
  return true
end


function ultraschall.Theme_Defaultv6_GetEnvSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetEnvSize</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetEnvSize()</functioncall>
  <description>
    Gets the size of the envelope-controls when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    integer size - the envelope-size
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, control, size, envelope, default v6 theme</tags>
</US_DocBloc>
]]
  local A,B=reaper.ThemeLayout_GetLayout("envcp", -1)
  if B=="A" then return 1
  elseif B=="150%_A" then return 2
  elseif B=="200%_A" then return 3
  end
end

--ultraschall.Theme_Defaultv6_SetEnvelopeSize(1)
--A1=ultraschall.Theme_Defaultv6_GetEnvelopeSize()

function ultraschall.Theme_Defaultv6_SetMCPFolderIndent(indentation, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetMCPFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetMCPFolderIndent(integer indentation, boolean persist)</functioncall>
  <description>
    Sets the folder-indentation in mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer indentation - the indentation of folders in mcp
                    - 0, None
                    - 1, 1/8
                    - 2, 1/4
                    - 3, 1/2
                    - 4, 1
                    - 5, 2
                    - 6, Max
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, folder indentation, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(indentation)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPFolderIndent", "alignement", "must be an integer", -1) return false end
  if indentation<0 or indentation>6 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPFolderIndent", "alignement", "must be between 1 and 2", -2) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPFolderIndent", "persist", "must be a boolean", -3) return false end
  local Layout="A"
  local elementname="indent"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname, indentation+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetMCPFolderIndent(0, false)

function ultraschall.Theme_Defaultv6_GetMCPFolderIndent()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetMCPFolderIndent</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer alignement = ultraschall.Theme_Defaultv6_GetMCPFolderIndent()</functioncall>
  <description>
    Gets the folder-indentaion in the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer indentation - the indentation of folders in mcp
                    - 0, None
                    - 1, 1/8
                    - 2, 1/4
                    - 3, 1/2
                    - 4, 1
                    - 5, 2
                    - 6, Max
  </retvals>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, folder, indentation, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  local Layout="A"
  local elementname="indent"

  local A, B, C, indentation = ultraschall.GetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname)
  return indentation-1
end

--A=ultraschall.Theme_Defaultv6_GetMCPAlignControls()

function ultraschall.Theme_Defaultv6_SetStyleMCPElement(Layout, Element, if_track_selected, if_track_not_selected, if_track_armed, if_track_not_armed, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetStyleMCPElement</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetStyleMCPElement(string Layout, integer Element, boolean if_track_selected, boolean if_track_not_selected, boolean if_track_armed, boolean if_track_not_armed, boolean persist)</functioncall>
  <description>
    Sets style of elements from MCP when using the default Reaper 6-theme when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose element you want to style-set; either "A", "B" or "C"
    integer Element - the element, whose style-state you want to set
                    - 1, extend with sidebar
                    - 2, Narrow form
                    - 3, Do meter expansion
                    - 4, Element labels
    boolean if_track_selected - true, if track is selected; false, if not
    boolean if_track_not_selected - true, if track is not selected; false, if not
    boolean if_track_armed - true, if track is armed; false, if not
    boolean if_track_not_armed - true, if track is unarmed; false, if not
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, style, element, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "Layout", "must be either A, B or C", -1) return false end
  if math.type(Element)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "Element", "must be an integer", -2) return false end
  if Element<1 or Element>4 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "Element", "must be between 1 and 12", -3) return false end
  if type(if_track_selected)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "if_track_selected", "must be a boolean", -4) return false end
  
  if type(if_track_not_selected)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "if_track_not_selected", "must be a boolean", -5) return false end
  if type(if_track_armed)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "if_track_armed", "must be a boolean", -6) return false end
  if type(if_track_not_armed)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "if_track_not_armed", "must be a boolean", -7) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetStyleMCPElement", "persist", "must be a boolean", -8) return false end

  local val=0
  
  if if_track_selected==true then val=val+1 end
  if if_track_not_selected==true then val=val+2 end
  if if_track_armed==true then val=val+4 end
  if if_track_not_armed==true then val=val+8 end
  
  local elementname
  if     Element==1 then elementname="Sidebar" 
  elseif Element==2 then elementname="Narrow" 
  elseif Element==3 then elementname="Meter_Expansion"
  elseif Element==4 then elementname="Labels"
  end

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname, val, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--ultraschall.Theme_Defaultv6_SetStyleMCPElement("C", 5, true, true, true, true, false)


function ultraschall.Theme_Defaultv6_GetStyleMCPElement(Layout, Element)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetStyleMCPElement</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval, boolean is_track_is_selected, boolean if_track_not_selected, boolean is_track_is_armed, boolean if_track_not_armed = ultraschall.Theme_Defaultv6_GetStyleMCPElement(string Layout, integer Element)</functioncall>
  <description>
    Gets style of elements from MCP when using the default Reaper 6-theme when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, getting was successful; false, getting was unsuccessful
    boolean if_track_selected - true, if track is selected; false, if not
    boolean if_track_not_selected - true, if track is not selected; false, if not
    boolean if_track_armed - true, if track is armed; false, if not
    boolean if_track_not_armed - true, if track is unarmed; false, if not
  </retvals>
  <parameters>
    string Layout - the layout, whose element you want to style-get; either "A", "B" or "C"
    integer Element - the element, whose style-state you want to set
                    - 1, extend with sidebar
                    - 2, Narrow form
                    - 3, Do meter expansion
                    - 4, Element labels
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, style, element, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetStyleMCPElement", "Layout", "must be either A, B or C", -1) return false end
  if math.type(Element)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetStyleMCPElement", "Element", "must be an integer", -2) return false end
  if Element<1 or Element>4 then ultraschall.AddErrorMessage("Theme_Defaultv6_GetStyleMCPElement", "Element", "must be between 1 and 12", -3) return false end
  
  local elementname
  if     Element==1 then elementname="Sidebar" 
  elseif Element==2 then elementname="Narrow" 
  elseif Element==3 then elementname="Meter_Expansion"
  elseif Element==4 then elementname="Labels"
  end

  local parameterindex, retval, desc, val, defValue, minValue, maxValue 
  = ultraschall.GetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname)
  return true, val&1~=0, val&2~=0, val&4~=0, val&8~=0
end

--A={ultraschall.Theme_Defaultv6_GetStyleMCPElement("A", 3)}

function ultraschall.Theme_Defaultv6_SetMCPBorderStyle(Layout, style, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetMCPBorderStyle</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetMCPBorderStyle(string Layout, integer style, boolean persist)</functioncall>
  <description>
    Sets the style of the border of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose mcp-borderstyle you want to set; either "A", "B" or "C"
    integer style - the new style of the border of the mcp
                    - 0, None
                    - 1, Left edge
                    - 2, Right edge
                    - 3, Root folders
                    - 4, Around folders
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, border, style, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPBorderStyle", "Layout", "must be either A, B or C", -1) return false end
  if math.type(style)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPBorderStyle", "style", "must be an integer", -2) return false end
  if style<0 or style>4 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPBorderStyle", "style", "must be between 0 and 6", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPBorderStyle", "persist", "must be a boolean", -4) return false end
  local elementname="border"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname, style+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetMCPBorderStyle("A", 2, false)

function ultraschall.Theme_Defaultv6_GetMCPBorderStyle(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetMCPBorderStyle</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetMCPBorderStyle(string Layout)</functioncall>
  <description>
    Gets the style of the border of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer style - the current syle of the border of the mcp
                    - 0, None
                    - 1, Left edge
                    - 2, Right edge
                    - 3, Root folders
                    - 4, Around folders
  </retvals>
  <parameters>
    string Layout - the layout, whose mcp-borderstyle you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, border, style, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetMCPBorderStyle", "Layout", "must be either A, B or C", -1) return end
  local elementname="border"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetTCPNameSize("A")

function ultraschall.Theme_Defaultv6_SetMCPMeterExpansion(Layout, size, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetMCPMeterExpansion</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetMCPMeterExpansion(string Layout, integer size, boolean persist)</functioncall>
  <description>
    Sets the size of the meter-expansion of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    string Layout - the layout, whose mcp-meter-expansion you want to set; either "A", "B" or "C"
    integer size - the new size of the meter-expansion of the mcp
                    - 0, None
                    - 1, +2 pixels
                    - 2, +4 pixels
                    - 3, +8 pixels
    boolean persist - true, this setting persists after restart of Reaper; false, this setting is only valid until closing Reaper
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, meter, expansion, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPMeterExpansion", "Layout", "must be either A, B or C", -1) return false end
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPMeterExpansion", "size", "must be an integer", -2) return false end
  if size<0 or size>3 then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPMeterExpansion", "size", "must be between 0 and 6", -3) return false end
  if type(persist)~="boolean"  then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPMeterExpansion", "persist", "must be a boolean", -4) return false end
  local elementname="meterExpSize"

  ultraschall.SetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname, size+1, persist, false)
  reaper.ThemeLayout_RefreshAll()
  return true
end

--A=ultraschall.Theme_Defaultv6_SetMCPMeterExpansion("A", 0, false)

function ultraschall.Theme_Defaultv6_GetMCPMeterExpansion(Layout)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetMCPMeterExpansion</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>integer size = ultraschall.Theme_Defaultv6_GetMCPMeterExpansion(string Layout)</functioncall>
  <description>
    Gets the meter-expansion of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns nil in case of an error
  </description>
  <retvals>
    integer size - the new size of the meter-expansion of the mcp
                    - 0, None
                    - 1, +2 pixels
                    - 2, +4 pixels
                    - 3, +8 pixels
  </retvals>
  <parameters>
    string Layout - the layout, whose mcp-meter-expansion you want to get; either "A", "B" or "C"
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, meter, expansion, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetMCPMeterExpansion", "Layout", "must be either A, B or C", -1) return end
  local elementname="meterExpSize"

  local A, B, C, size = ultraschall.GetThemeParameterIndexByDescription(Layout.."_mcp_"..elementname)
  return size-1
end

--A=ultraschall.Theme_Defaultv6_GetMCPMeterExpansion("A")

function ultraschall.Theme_Defaultv6_SetMCPSizeAndLayout(tracknumber, Layout, size)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetMCPSizeAndLayout</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetMCPSizeAndLayout(integer tracknumber, string Layout, integer size)</functioncall>
  <description>
    Sets the size and layout of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer tracknumber - the number of the track, whose MCP-layout and size you want to set(no master track supported)
    string Layout - the new mcp-layout; either "A", "B" or "C"
    integer size - the new size of the mcp
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, size, layout, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPSizeAndLayout", "Layout", "must be either A, B or C", -1) return false end
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPSizeAndLayout", "tracknumber", "must be an integer", -2) return false end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPSizeAndLayout", "tracknumber", "must be a valid tracknumber, 1 or higher", -3) return false end  
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPSizeAndLayout", "size", "must be an integer", -4) return false end
  if size<1 or size>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_SetMCPSizeAndLayout", "size", "must be between 1 and 3", -5) return false end  

  if size==1 then size=""
  elseif size==2 then size="150%_"
  elseif size==3 then size="200%_"
  end
  
  reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0, tracknumber-1), "P_MCP_LAYOUT", size..Layout, true)
  return true
end

--ultraschall.Theme_Defaultv6_SetMCPSize(6, "A", 1)
--  ultraschall.SetTrackLayoutNames(3, "", "150%_A")
--  SLEM()


function ultraschall.Theme_Defaultv6_SetTCPSizeAndLayout(tracknumber, Layout, size)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_SetTCPSizeAndLayout</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_SetTCPSizeAndLayout(integer tracknumber, string Layout, integer size)</functioncall>
  <description>
    Sets the size and layout of the tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer tracknumber - the number of the track, whose TCP-layout and size you want to set(no master track supported)
    string Layout - the new tcp-layout; either "A", "B" or "C"
    integer size - the new size of the mcp
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, set, size, layout, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if Layout~="A" and Layout~="B" and Layout~="C" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPSizeAndLayout", "Layout", "must be either A, B or C", -1) return false end
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPSizeAndLayout", "tracknumber", "must be an integer", -2) return false end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPSizeAndLayout", "tracknumber", "must be a valid tracknumber, 1 or higher", -3) return false end  
  if math.type(size)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPSizeAndLayout", "size", "must be an integer", -4) return false end
  if size<1 or size>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_SetTCPSizeAndLayout", "size", "must be between 1 and 3", -5) return false end  
  
  if size==1 then size=""
  elseif size==2 then size="150%_"
  elseif size==3 then size="200%_"
  end
  
  reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0, tracknumber-1), "P_TCP_LAYOUT", size..Layout, true)
  return true
end

--ultraschall.Theme_Defaultv6_SetTCPSize(6, "A", 1)

function ultraschall.Theme_Defaultv6_GetTCPSizeAndLayout(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetTCPSizeAndLayout</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_GetTCPSizeAndLayout(integer tracknumber, string Layout, integer size)</functioncall>
  <description>
    Gets the size and layout of the tcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    string Layout - the current layout of the tcp; either "A", "B", "C" or ""(if no layout is set yet)
    integer size - the current size of the tcp
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </retvals>
  <parameters>
    integer tracknumber - the number of the track, whose TCP-layout and size you want to get(no master track supported)
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, size, layout, tcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPSizeAndLayout", "tracknumber", "must be an integer", -1) return end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_GetTCPSizeAndLayout", "tracknumber", "must be a valid tracknumber, 1 or higher", -2) return end  
  
  local retval, TCPLayout = reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0, tracknumber-1), "P_TCP_LAYOUT", "", false)
  
  local size 
  
  if TCPLayout:match("150") then size=2
  elseif TCPLayout:match("200") then size=3
  else size=1
  end
  
  return TCPLayout:sub(-1,-1), size
end

--A,B=ultraschall.Theme_Defaultv6_GetTCPSize(2)

function ultraschall.Theme_Defaultv6_GetMCPSizeAndLayout(tracknumber)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Theme_Defaultv6_GetMCPSizeAndLayout</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.Theme_Defaultv6_GetMCPSizeAndLayout(integer tracknumber, string Layout, integer size)</functioncall>
  <description>
    Gets the size and layout of the mcp when using default v6-theme
    
    This reflects the settings from the Theme-Adjuster.
    
    returns false in case of an error
  </description>
  <retvals>
    string Layout - the current layout of the mcp; either "A", "B", "C" or ""(if no layout is set yet)
    integer size - the current size of the mcp
                    - 1, normal
                    - 2, 150%
                    - 3, 200%
  </retvals>
  <parameters>
    integer tracknumber - the number of the track, whose MCP-layout and size you want to get(no master track supported)
  </parameters>
  <chapter_context>
    Themeing
    Default v6-Theme
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, size, layout, mcp, default v6 theme</tags>
</US_DocBloc>
]]
  if math.type(tracknumber)~="integer" then ultraschall.AddErrorMessage("Theme_Defaultv6_GetMCPSizeAndLayout", "tracknumber", "must be an integer", -1) return end
  if tracknumber<1 or tracknumber>reaper.CountTracks(0) then ultraschall.AddErrorMessage("Theme_Defaultv6_GetMCPSizeAndLayout", "tracknumber", "must be a valid tracknumber, 1 or higher", -2) return end  
  
  local retval, TCPLayout = reaper.GetSetMediaTrackInfo_String(reaper.GetTrack(0, tracknumber-1), "P_MCP_LAYOUT", "", false)
  
  local size 
  
  if TCPLayout:match("150") then size=2
  elseif TCPLayout:match("200") then size=3
  else size=1
  end
  
  return TCPLayout:sub(-1,-1), size
end

function ultraschall.GetTrack_ThemeElementPositions(track)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrack_ThemeElementPositions</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>table ThemeElements = ultraschall.GetTrack_ThemeElementPositions(MediaTrack track)</functioncall>
  <description>
    returns a list of all theme-elements for a track
    
    the table ThemeElements is of the following format:
    
      ThemeLayoutNames[index]["element"] - the name of the theme-element 
      ThemeLayoutNames[index]["x"] - the x-position of the theme-element
      ThemeLayoutNames[index]["y"] - the y-position of the theme-element
      ThemeLayoutNames[index]["w"] - the width of the theme-element
      ThemeLayoutNames[index]["h"] - the height of the theme-element
      ThemeLayoutNames[index]["visible"] - true, the theme element is visible; false, the theme-element is invisible(width and heigh=0)
    
    returns nil in case of an error
  </description>
  <retvals>
    table ThemeElements - a table with all walter-theme elements, their positions and their visibility-state
  </retvals>
  <parameters>
    MediaTrack track - the track, whose Walter-theme-element-positions you want to query
  </parameters>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, all, track element positions, visibility</tags>
</US_DocBloc>
]]
  if ultraschall.type(track)~="MediaTrack" then ultraschall.AddErrorMessage("GetTrack_ThemeElementPositions", "track", "must be a MediaTrack", -1) return end
  local WalterElements={}
  for i=1, #ultraschall.WalterElements do
    local Aretval, AstringNeedBig = reaper.GetSetMediaTrackInfo_String(track, "P_UI_RECT:"..ultraschall.WalterElements[i], "", false)
    if Aretval==true then
      WalterElements[#WalterElements+1]={}
      WalterElements[#WalterElements]["element"]=ultraschall.WalterElements[i]
      WalterElements[#WalterElements]["x"], WalterElements[#WalterElements]["y"], WalterElements[#WalterElements]["w"], WalterElements[#WalterElements]["h"]=AstringNeedBig:match("(.-) (.-) (.-) (.*)")
      WalterElements[#WalterElements]["x"]=tonumber(WalterElements[#WalterElements]["x"])
      WalterElements[#WalterElements]["y"]=tonumber(WalterElements[#WalterElements]["y"])
      WalterElements[#WalterElements]["w"]=tonumber(WalterElements[#WalterElements]["w"])
      WalterElements[#WalterElements]["h"]=tonumber(WalterElements[#WalterElements]["h"])
      WalterElements[#WalterElements]["visible"]=(WalterElements[#WalterElements]["h"]~=0 or WalterElements[#WalterElements]["w"]~=0)
    end
  end
  return WalterElements
end

function ultraschall.GetAllThemeElements()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllThemeElements</slug>
  <requires>
    Ultraschall=4.3
    Reaper=6.43
    Lua=5.3
  </requires>
  <functioncall>table ThemeElements = ultraschall.GetAllThemeElements()</functioncall>
  <description>
    returns a list of all theme-element-names available

    returns nil in case of an error
  </description>
  <retvals>
    table ThemeElements - a table with all walter-theme elements-names available
  </retvals>
  <chapter_context>
    Themeing
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Themeing_Module.lua</source_document>
  <tags>theme management, get, all, theme element, names</tags>
</US_DocBloc>
]]
  local WalterElements={}
  for i=1, #ultraschall.WalterElements do
    WalterElements[i]=ultraschall.WalterElements[i]
  end
  return WalterElements
end

