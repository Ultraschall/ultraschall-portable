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
--- Configuration Settings Module ---
-------------------------------------


function ultraschall.GetSetConfigAcidImport(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAcidImport</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAcidImport(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "When importing media"-dropdownlist, as set in the Media with embedded tempo information-section in Preferences -> Video/REX/Misc
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "acidimport", as well as the reaper.ini-entry "REAPER -> acidimport"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - -1, an error occured
                   -  0, Adjust media to project tempo
                   -  1, Import media at source tempo
                   -  2, Always prompt when importing media with embedded tempo
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                   - -1, an error occured
                   -  0, Adjust media to project tempo
                   -  1, Import media at source tempo
                   -  2, Always prompt when importing media with embedded tempo
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Video/REX/Misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, tempo, get, set, persist, tempo, import, media</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAcidImport", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAcidImport", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAcidImport", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2 then ultraschall.AddErrorMessage("GetSetConfigAcidImport", "setting", "must be between 0 and 2", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("acidimport", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("acidimport", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "acidimport", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetAcidImport(true, 0, true)

function ultraschall.GetSetConfigActionMenu(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigActionMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigActionMenu(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Show recent actions"-entry, as set in the Actions-menu.
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "actionmenu", as well as the reaper.ini-entry "REAPER -> actionmenu"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, don't show recent actions - unchecked
                   - 1, show recent actions - checked
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, don't show recent actions - unchecked
                    - 1, show recent actions - checked
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Menus
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, actions, menu</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigActionMenu", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigActionMenu", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigActionMenu", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigActionMenu", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("actionmenu", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("actionmenu", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "actionmenu", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetActionMenu(true, 1, false)

function ultraschall.GetSetConfigAdjRecLat(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAdjRecLat</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAdjRecLat(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Use audio driver reported latency"-checkbox, as set in Preferences -> Recording
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "adjreclat", as well as the reaper.ini-entry "REAPER -> adjreclat"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                    - 0, don't use audio driver reported latency(off) - unchecked
                    - 1, don't use audio driver reported latency(on) - checked
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, don't use audio driver reported latency(off) - unchecked
                    - 1, don't use audio driver reported latency(on) - checked
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Recording
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, recording, adjreclat, audio, driver, latency</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecLat", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecLat", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAdjRecLat", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAdjRecLat", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("adjreclat", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("adjreclat", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "adjreclat", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetAdjRecLat(true, 1, true)

function ultraschall.GetSetConfigAdjRecManLat(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAdjRecManLat</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAdjRecManLat(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Output manual offset-samples"-inputbox, as set in Preferences -> Recording
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "adjrecmanlat", as well as the reaper.ini-entry "REAPER -> adjrecmanlat"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value; 0 to 2147483647; in samples
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value; 0 to 2147483647; in samples
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Recording
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, recording, adjrecmanlat, manual, output, offset, samples</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLat", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLat", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLat", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2147483647 then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLat", "setting", "must be between 0 and 2147483647", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("adjrecmanlat", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("adjrecmanlat", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "adjrecmanlat", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetAdjRecManLat(false, 0, true)

function ultraschall.GetSetConfigAfxCfg(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAfxCfg</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAfxCfg(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of the audioformat for "Apply FX, Glue, Freeze, etc", as set in the Project Settings->Media-dialog
    Only sets the format, not the individual format-settings(like bitrate, etc)!
    To keep the setting for new projects as standard-setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "afxcfg", as well as the reaper.ini-entry "REAPER -> afxcfg"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/newly set audioformat 
                   - 0, not set yet
                   - 1179012432, Video (ffmpeg/libav encoder)
                   - 1195984416, Video (GIF)
                   - 1279477280, Video (LCF)
                   - 1332176723, OGG Opus
                   - 1634297446, AIFF
                   - 1684303904, DDP
                   - 1718378851, FLAC
                   - 1769172768, Audio CD Image(CUE/BIN format)
                   - 1836069740, MP3 (encoder by LAME project)
                   - 1869047670, OGG Vorbis
                   - 2002876005, WAV
                   - 2004250731, WavPack lossless compressor
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the new set audioformat
                    - 1179012432, Video (ffmpeg/libav encoder)
                    - 1195984416, Video (GIF)
                    - 1279477280, Video (LCF)
                    - 1332176723, OGG Opus
                    - 1634297446, AIFF
                    - 1684303904, DDP
                    - 1718378851, FLAC
                    - 1769172768, Audio CD Image(CUE/BIN format)
                    - 1836069740, MP3 (encoder by LAME project)
                    - 1869047670, OGG Vorbis
                    - 2002876005, WAV
                    - 2004250731, WavPack lossless compressor
    boolean persist - true, this setting will be standard-setting for new projects after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Project Settings: Media
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, project settings, media, apply fx glue freeze</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAfxCfg", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAfxCfg", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAfxCfg", "setting", "must be an integer", -3) return -1 end
  if     setting==1179012432 then -- 1179012432, Video (ffmpeg/libav encoder)
  elseif setting==1195984416 then -- 1195984416, Video (GIF)
  elseif setting==1279477280 then -- 1279477280, Video (LCF)
  elseif setting==1332176723 then -- 1332176723, OGG Opus
  elseif setting==1634297446 then -- 1634297446, AIFF
  elseif setting==1684303904 then -- 1684303904, DDP
  elseif setting==1718378851 then -- 1718378851, FLAC
  elseif setting==1769172768 then -- 1769172768, Audio CD Image(CUE/BIN format)
  elseif setting==1836069740 then -- 1836069740, MP3 (encoder by LAME project)
  elseif setting==1869047670 then -- 1869047670, OGG Vorbis
  elseif setting==2002876005 then -- 2002876005, WAV
  elseif setting==2004250731 then -- 2004250731, WavPack lossless compressor
  else
    ultraschall.AddErrorMessage("GetSetConfigAfxCfg", "setting", "no such format", -4) return -1
  end
  if set==false then return reaper.SNM_GetIntConfigVar("afxcfg", 0)
  else 
    local temp=reaper.SNM_SetIntConfigVar("afxcfg", setting)
    if temp==false then ultraschall.AddErrorMessage("GetSetConfigAfxCfg", "setting", "Can't be set on runtime, yet. Project-Settings -> Media -> Format for Apply FX, Glue, Freeze, etc must be set to Custom first.", -5) return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "afxcfg", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--Temp2=reaper.SNM_SetIntConfigVar("projrecforopencopy", 2)
--Temp=reaper.SNM_GetIntConfigVar("projrecforopencopy", 0)
--A=ultraschall.GetSetAfxCfg(true, 1684303904, false)

function ultraschall.GetSetConfigAllStereoPairs(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAllStereoPairs</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAllStereoPairs(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Show non-standard stereo channel pairs(i.e Input2/Input3 etc)"-checkbox in the Channel naming/mapping-section, as set in Preferences -> Audio
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "allstereopairs", as well as the reaper.ini-entry "REAPER -> allstereopairs"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, don't show non standard stereo channel pairs(off) - unchecked
                   - 1, show non standard stereo channel pairs(on) - checked
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, don't show non standard stereo channel pairs(off) - unchecked
                    - 1, show non standard stereo channel pairs(on) - checked
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Audio
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, audio, stereo, pairs</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAllStereoPairs", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAllStereoPairs", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAllStereoPairs", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAllStereoPairs", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("allstereopairs", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("allstereopairs", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "allstereopairs", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAllStereoPairs(true, 0, true)


function ultraschall.GetSetConfigAlwaysAllowKB(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAlwaysAllowKB</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAlwaysAllowKB(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Allow keyboard commands even when mouse-editing"-checkbox, as set in Preferences -> General ->Advanced UI/system tweaks
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "alwaysallowkb", as well as the reaper.ini-entry "REAPER -> alwaysallowkb"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value; 0(don't allow) to 1(allow)
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value; 0 to 1
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Advanced UI
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, recording, allow, keyboard</tags>
</US_DocBloc>
--]]
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAlwaysAllowKB", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAlwaysAllowKB", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAlwaysAllowKB", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAlwaysAllowKB", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar("alwaysallowkb", -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar("alwaysallowkb", setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", "adjrecmanlat", tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAlwaysAllowKB(true, 2, true)

function ultraschall.GetSetConfigApplyFXTail(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigApplyFXTail</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigApplyFXTail(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Tail length when using Apply FX to items"-inputbox in milliseconds, as set in Preferences -> Media
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "applyfxtail", as well as the reaper.ini-entry "REAPER -> applyfxtail"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value; 0 to 2147483647
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value; 0 to 2147483647
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Media
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, recording, fxtail, apply fx, item</tags>
</US_DocBloc>
--]]
  local config_var="applyfxtail"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigApplyFXTail", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigApplyFXTail", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigApplyFXTail", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2147483647 then ultraschall.AddErrorMessage("GetSetConfigApplyFXTail", "setting", "must be between 0 and 2147483647", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigApplyFXTail(true, 0, true)

function ultraschall.GetSetConfigAdjRecManLatIn(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAdjRecManLatIn</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAdjRecManLatIn(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Input manual offset-samples"-inputbox, as set in Preferences -> Recording
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "adjrecmanlatin", as well as the reaper.ini-entry "REAPER -> adjrecmanlatin"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Recording
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, input, manual offset</tags>
</US_DocBloc>
--]]
  local config_var="adjrecmanlatin"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLatIn", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLatIn", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLatIn", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2147483647 then ultraschall.AddErrorMessage("GetSetConfigAdjRecManLatIn", "setting", "must be between 0 and 2147483647", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAdjRecManLatIn(true, -10, true)


function ultraschall.GetSetConfigAudioPrShift(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAudioPrShift</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAudioPrShift(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Preserve pitch in audio items when changing master playrate", as set in the contextmenu of the master-playrate in the transport-area as well as toggled by action 40671(all sections)
    This is a project-setting. That means, setting persist to true will have an effect on new projects create, but only after you restarted Reaper!
    
    This alters the configuration-variable "audioprshift", as well as the reaper.ini-entry "REAPER -> audioprshift"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, don't preserve pitch - unchecked
                   - 1, preserve pitch - checked
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
                   - 0, don't preserve pitch - unchecked
                   - 1, preserve pitch - checked
    integer setting - the current/new setting-value
    boolean persist - true, this setting will be kept for new projects, but only after restart of Reaper; false, old standard-project-setting will be kept
  </parameters>
  <chapter_context>
    Configuration Settings
    Transport: Contextmenu
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, preserve pitch, master playrate</tags>
</US_DocBloc>
--]]
  local config_var="audioprshift"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioPrShift", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioPrShift", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAudioPrShift", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAudioPrShift", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAudioPrShift(true, 1, true)

function ultraschall.GetSetConfigAudioCloseStop(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAudioCloseStop</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAudioCloseStop(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Close audio device when stopped and active(less responsive)"-checkbox, as set in Preferences -> Audio  
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "audioclosestop", as well as the reaper.ini-entry "REAPER -> audioclosestop"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Audio
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, audio close, when stopped</tags>
</US_DocBloc>
--]]
  local config_var="audioclosestop"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseStop", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseStop", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseStop", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAudioCloseStop", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAudioCloseStop(true, 1, true)

function ultraschall.GetSetConfigAudioThreadPr(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAudioThreadPr</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAudioThreadPr(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Audio thread priority"-dropdownlist, as set in Preferences -> Device  
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "audiothreadpr", as well as the reaper.ini-entry "REAPER -> audiothreadpr"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
             --1, ASIO Default / MMCSS Pro Audio / Time Critical  
             -0, Normal  
             -1, Above normal  
             -2, Highest  
             -3, Time Critical  
             -4, MMCSS / Time Critical  
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    --1, ASIO Default / MMCSS Pro Audio / Time Critical  
                    -0, Normal  
                    -1, Above normal  
                    -2, Highest  
                    -3, Time Critical  
                    -4, MMCSS / Time Critical  
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Device
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, audio, thread, priority</tags>
</US_DocBloc>
--]]
  local config_var="audiothreadpr"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioThreadPr", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioThreadPr", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAudioThreadPr", "setting", "must be an integer", -3) return -1 end
  if setting<-1 or setting>6 then ultraschall.AddErrorMessage("GetSetConfigAudioThreadPr", "setting", "must be between -1 and 6", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAudioThreadPr(true, -1, true)

function ultraschall.GetSetConfigAudioCloseTrackWnds(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAudioCloseTrackWnds</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAudioCloseTrackWnds(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Allow snap grid/track envelope/routing windows to stay open"-checkbox in Preferences -> General -> Advanced UI/system tweaks.  
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "autoclosetrackwnds", as well as the reaper.ini-entry "REAPER -> autoclosetrackwnds"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                    - 0, it is allowed(on) - checked  
                    - 1, it is not allowed(off) - unchecked  
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, it is allowed(on) - checked  
                    - 1, it is not allowed(off) - unchecked  
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Advanced UI
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, keep open, windows, routing, track envelope, snapgrid</tags>
</US_DocBloc>
--]]
  local config_var="autoclosetrackwnds"
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseTrackWnds", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseTrackWnds", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAudioCloseTrackWnds", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAudioCloseTrackWnds", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) end return setting end
  end
end

--A=ultraschall.GetSetConfigAudioCloseTrackWnds(true, 1, true)



function ultraschall.GetSetConfigAutoMute(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAutoMute</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAutoMute(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Gets/Sets the value of "Automute-dropdownlist in the section Mute"-settings, as set in Preferences -> Mute/Solo 
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "automute", as well as the reaper.ini-entry "REAPER -> automute"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, No automatic muting  
                   - 1, Automatically mute master track  
                   - 2, Automatically mute any track  
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, No automatic muting  
                    - 1, Automatically mute master track  
                    - 2, Automatically mute any track  
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Mute/Solo
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, automute, mute, solo</tags>
</US_DocBloc>
--]]
  local config_var="automute"
  local retval
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoMute", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoMute", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAutoMute", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2 then ultraschall.AddErrorMessage("GetSetConfigAutoMute", "setting", "must be between 0 and 2", -4) return -1 end
  if set==false then 
    return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then 
      return -1 
    else 
      if persist==true then 
        retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) 
      end 
      return setting 
    end
  end
end

function ultraschall.GetSetConfigAutoMuteFlags(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAutoMuteFlags</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAutoMuteFlags(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Sets the "Reset on playback start"-checkbox in section Mute-settings, as set in Preferences -> Mute/Solo  
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "automuteflags", as well as the reaper.ini-entry "REAPER -> automuteflags"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, Reset on playback start(on) - checked  
                   - 1, Reset on playback start(off) - unchecked  
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, Reset on playback start(on) - checked  
                    - 1, Reset on playback start(off) - unchecked  
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Mute/Solo
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, automute, flags, mute, solo</tags>
</US_DocBloc>
--]]
  local config_var="automuteflags"
  local retval
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoMuteFlags", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoMuteFlags", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAutoMuteFlags", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>1 then ultraschall.AddErrorMessage("GetSetConfigAutoMuteFlags", "setting", "must be between 0 and 1", -4) return -1 end
  if set==false then 
    return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then 
      retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) 
    end 
    return setting 
  end
  end
end

--A=ultraschall.GetSetConfigAutoMuteFlags(true, 0, true)


function ultraschall.GetSetConfigAutoSaveInt(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAutoSaveInt</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAutoSaveInt(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Sets the "Every x minutes"-inputbox from the Project saving-section, as set in Preferences -> Project. 
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "autosaveint", as well as the reaper.ini-entry "REAPER -> autosaveint"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0 to 2147483647; in seconds; higher values become negative
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0 to 2147483647 in seconds
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Project
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, autosave, project</tags>
</US_DocBloc>
--]]
  local config_var="autosaveint"
  local retval
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveInt", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveInt", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveInt", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2147483647 then ultraschall.AddErrorMessage("GetSetConfigAutoSaveInt", "setting", "must be between 0 and 2147483647", -4) return -1 end
  if set==false then 
    return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then 
      retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) 
    end 
    return setting 
  end
  end
end

--A=ultraschall.GetSetConfigAutoSaveInt(true, 100, true)

function ultraschall.GetSetConfigAutoSaveMode(set, setting, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSetConfigAutoSaveMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetSetConfigAutoSaveMode(boolean set, integer setting, boolean persist)</functioncall>
  <description>
    Sets the "Every x minutes"-dropdownlist from the Project saving-section, as set in Preferences -> Project. 
    To keep the setting after restart of Reaper, set persist=true
    
    This alters the configuration-variable "autosavemode", as well as the reaper.ini-entry "REAPER -> autosavemode"
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the current/new setting-value
                   - 0, when not recording  
                   - 1, when stopped  
                   - 2, any time  
  </retvals>
  <parameters>
    boolean set - true, set a new value; false, return the current value
    integer setting - the current/new setting-value
                    - 0, when not recording  
                    - 1, when stopped  
                    - 2, any time  
    boolean persist - true, this setting will be kept after restart of Reaper; false, setting will be lost after exiting Reaper
  </parameters>
  <chapter_context>
    Configuration Settings
    Preferences: Project
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>configurationsettings, get, set, persist, autosave, mode, project</tags>
</US_DocBloc>
--]]
  local config_var="autosavemode"
  local retval
  if ultraschall.type(set)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveMode", "set", "must be a boolean", -1) return -1 end
  if persist~=nil and ultraschall.type(persist)~="boolean" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveMode", "persist", "must be a boolean", -2) return -1 end
  if setting~=nil and ultraschall.type(setting)~="number: integer" then ultraschall.AddErrorMessage("GetSetConfigAutoSaveMode", "setting", "must be an integer", -3) return -1 end
  if setting<0 or setting>2 then ultraschall.AddErrorMessage("GetSetConfigAutoSaveMode", "setting", "must be between 0 and 2", -4) return -1 end
  if set==false then 
    return reaper.SNM_GetIntConfigVar(config_var, -33)
  else 
    local temp=reaper.SNM_SetIntConfigVar(config_var, setting)
    if temp==false then return -1 else if persist==true then 
      retval = ultraschall.SetIniFileExternalState("REAPER", config_var, tostring(setting), reaper.get_ini_file()) 
    end 
    return setting 
  end
  end
end

--A=ultraschall.GetSetConfigAutoSaveMode(true, 2, true)





function ultraschall.GetStartNewFileRecSizeState()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetStartNewFileRecSizeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean start_new_files, boolean offset_file_switches, integer max_rec_size = ultraschall.GetStartNewFileRecSizeState()</functioncall>
  <description>
    Returns, if Reaper shall start a file after a specified amount of MegaBytes as well, if the fileswitches shall be offset when multitrack-recording and the maximum filesize before starting a new file.
    
    see <a href="#SetStartNewFileRecSizeState">SetStartNewFileRecSizeState</a> for setting the current settings.
  </description>
  <retvals>
    boolean start_new_files - true, Reaper starts a new file, when a recorded file reaches max_rec_size; false, files are as long until recording stops
    boolean offset_file_switches - true, When recording multiple tracks, offset file switches for better performance; false, don't offset file-switches
    integer max_rec_size - the maximum length of a recorded file in MegaBytes, before Reaper shall start a new file; only applied when When recording multiple tracks, offset file switches for better performance=true
  </retvals>
  <chapter_context>
    Configuration Settings
    Recording
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>recordingmanagement, maximum, file, size, file, switch, offset, restart, recording, get</tags>
</US_DocBloc>
--]]
  local maxrecsize=reaper.SNM_GetIntConfigVar("maxrecsize", -1)
  local maxrecsize_use=reaper.SNM_GetIntConfigVar("maxrecsize_use", -1)
  local start_new_files, offset_file_switched
  if maxrecsize_use&1==0 then start_new_files=false else start_new_files=true end
  if maxrecsize_use&2==0 then offset_file_switches=false else offset_file_switches=true end
  return start_new_files, offset_file_switches, maxrecsize
end

--A,B,C,D,E,F,G=ultraschall.GetStartNewFileRecSizeState()

function ultraschall.SetStartNewFileRecSizeState(start_new_files, offset_file_switches, maxrecsize, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetStartNewFileRecSizeState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetStartNewFileRecSizeState(boolean start_new_files, boolean offset_file_switches, integer maxrecsize, boolean persist)</functioncall>
  <description>
    Sets, if Reaper shall start a file after a specified amount of MegaBytes as well, if the fileswitches shall be offset when multitrack-recording and the maximum filesize before starting a new file.
    
    see <a href="#GetStartNewFileRecSizeState">GetStartNewFileRecSizeState</a> for getting the current settings.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    boolean start_new_files - true, Reaper starts a new file, when a recorded file reaches max_rec_size; false, files are as long until recording stops
    boolean offset_file_switches - true, When recording multiple tracks, offset file switches for better performance; false, don't offset file-switches
    integer max_rec_size - the maximum length of a recorded file in MegaBytes, before Reaper shall start a new file; only applied when When recording multiple tracks, offset file switches for better performance=true
    boolean persist - true, set the setting to reaper.ini so it persists after restarting Reaper; false, set it only for the time, until Reaper is restarted
  </parameters>
  <chapter_context>
    Configuration Settings
    Recording
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ConfigurationSettings_Module.lua</source_document>
  <tags>recordingmanagement, maximum, file, size, file, switch, offset, restart, recording, set</tags>
</US_DocBloc>
--]]
  if type(start_new_files)~="boolean" then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "start_new_files", "Must be a boolean", -1) return false end
  if type(offset_file_switches)~="boolean" then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "offset_file_switches", "Must be a boolean", -2) return false end
  if math.type(maxrecsize)~="integer" then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "maxrecsize", "Must be an integer", -3) return false end
  if maxrecsize<0 or maxrecsize>2147483647 then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "maxrecsize", "Must be between 0 and 2147483647", -4) return false end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "persist", "Must be a boolean", -5) return false end
  
  local maxrecsize_use=0
  if start_new_files==true then maxrecsize_use=maxrecsize_use+1 end
  if offset_file_switches==true then maxrecsize_use=maxrecsize_use+2 end
  local maxrecsize2=reaper.SNM_SetIntConfigVar("maxrecsize", maxrecsize)
  local maxrecsize_use2=reaper.SNM_SetIntConfigVar("maxrecsize_use", maxrecsize_use)
  
  if maxrecsize2==false then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "maxrecsize", "Couldn't set maxrecsize, contact Ultraschall-Api-developers for this...", -6) return false end
  if maxrecsize_use2==false then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "start_new_files or offset_file_switches", "Couldn't set new value, contact Ultraschall-Api-developers for this...", -7) return false end
  
  if persist==true then
    local A=ultraschall.SetIniFileValue("REAPER", "maxrecsize", tostring(maxrecsize), reaper.get_ini_file())
    local B=ultraschall.SetIniFileValue("REAPER", "maxrecsize_use", tostring(maxrecsize_use), reaper.get_ini_file())
    if A==false or B==false then ultraschall.AddErrorMessage("SetStartNewFileRecSizeState", "persist", "Couldn't set changed config to persist. Maybe a problem with accessing reaper.ini.", -8) return false end
  end
  return true    
end

--ultraschall.SetStartNewFileRecSizeState(true, false, 613, false)
