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
---    Audio Management Module    ---
-------------------------------------


function ultraschall.GetHWInputs_Aliasnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetHWInputs_Aliasnames</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      SWS=2.9.7
      Lua=5.3
    </requires>
    <functioncall>integer number_of_aliases, table aliases = ultraschall.GetHWInputs_Aliasnames()</functioncall>
    <description>
      Returns the aliasnames and their associated channels of the currently selected audio-device.
      
      The returned table is of the format
        table[index][1] - the name of the alias
        table[index][2] - the hardware-input-channel, associated to this aliasname
    </description>
    <retvals>
      integer number_of_aliases - the number of aliases available
      table aliases - a table, that contains all alias-names and their associated Hardware-Input-channels
    </retvals>
    <chapter_context>
      Audio Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_AudioManagement_Module.lua</source_document>
    <tags>audiomanagement, get, alias, names, input, channels</tags>
  </US_DocBloc>
  ]]
  local retval, Bdesc = reaper.GetAudioDeviceInfo("IDENT_IN", "")
  
  local Reaper_ini=reaper.get_ini_file()
  local retval, nums = reaper.BR_Win32_GetPrivateProfileString("alias_in_"..string.gsub(Bdesc," ","_"), "map_size", "Tudelu", Reaper_ini)
  
  local Table={}
  for i=0, nums-1 do  
--    retval, Table[i+1] = reaper.BR_Win32_GetPrivateProfileString("alias_in_"..string.gsub(Bdesc," ","_"), "name"..i, "Tudelu", Reaper_ini)
    Table[i+1]={}
    retval, Table[i+1][1] = reaper.BR_Win32_GetPrivateProfileString("alias_in_"..string.gsub(Bdesc," ","_"), "name"..i, "Tudelu", Reaper_ini)
    retval, Table[i+1][2] = reaper.BR_Win32_GetPrivateProfileString("alias_in_"..string.gsub(Bdesc," ","_"), "ch"..i, "Tudelu", Reaper_ini)
  end
  
  return tonumber(nums), Table
end

--A,B=ultraschall.GetHWInputs_Aliasnames()

function ultraschall.GetHWOutputs_Aliasnames()
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetHWOutputs_Aliasnames</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      SWS=2.9.7
      Lua=5.3
    </requires>
    <functioncall>integer number_of_aliases, table aliases = ultraschall.GetHWOutputs_Aliasnames()</functioncall>
    <description>
      Returns the aliasnames and their associated channels of the currently selected audio-device.
      
      The returned table is of the format
        table[index][1] - the name of the alias
        table[index][2] - the hardware-output-channel, associated to this aliasname
    </description>
    <retvals>
      integer number_of_aliases - the number of aliases available
      table aliases - a table, that contains all alias-names and their associated Hardware-Output-channels
    </retvals>
    <chapter_context>
      Audio Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_AudioManagement_Module.lua</source_document>
    <tags>audiomanagement, get, alias, names, output, channels</tags>
  </US_DocBloc>
  ]]
  local retval, Bdesc = reaper.GetAudioDeviceInfo("IDENT_OUT", "")
  
  local Reaper_ini=reaper.get_ini_file()
  local retval, nums = reaper.BR_Win32_GetPrivateProfileString("alias_out_"..string.gsub(Bdesc," ","_"), "map_size", "Tudelu", Reaper_ini)
  
  local Table={}
  for i=0, nums-1 do  
    Table[i+1]={}
    retval, Table[i+1][1] = reaper.BR_Win32_GetPrivateProfileString("alias_out_"..string.gsub(Bdesc," ","_"), "name"..i, "Tudelu", Reaper_ini)
    retval, Table[i+1][2] = reaper.BR_Win32_GetPrivateProfileString("alias_out_"..string.gsub(Bdesc," ","_"), "ch"..i, "Tudelu", Reaper_ini)
  end
  
  return tonumber(nums), Table
end

--A,B=ultraschall.GetHWOutputs_Aliasnames()
