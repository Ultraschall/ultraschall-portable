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
---       Razor Edit Module       ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Razor-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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


function ultraschall.RazorEdit_ProjectHasRazorEdit()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_ProjectHasRazorEdit</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.RazorEdit_ProjectHasRazorEdit()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns, if the project has any razor-edits available.
  </description>
  <retvals>
    boolean retval - true, project has razor-edits; false, project has no razor-edits
  </retvals>
  <chapter_context>
    Razor Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, is, any</tags>
</US_DocBloc>
]]
  for i=0, reaper.CountTracks(0)-1 do
    local track=reaper.GetTrack(0,i)
    local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
    if B~="" then return true end
  end
  
  return false
end


--A=ultraschall.RazorEdit_ProjectHasRazorEdit()

function ultraschall.RazorEdit_GetAllRazorEdits()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RazorEdit_GetAllRazorEdits</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.24
    Lua=5.3
  </requires>
  <functioncall>integer number_razor_edits, table RazorEditTable = ultraschall.RazorEdit_GetAllRazorEdits()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns the number of Razor Edits available and all its entries as a handy table.concat
    
    The table is of the following format(index is the index of all available razor-edits):        
    
        RazorEditTable[index]["Start"] - the startposition of the RazorEdit in seconds
        RazorEditTable[index]["End"] - the endposition of the RazorEdit in seconds
        RazorEditTable[index]["IsTrack"] - true, it's a track-RazorEdit; false, it's RazorEdit for an envelope
        RazorEditTable[index]["Tracknumber"] - the number of the track, in which the RazorEdit happens
        RazorEditTable[index]["Track"] - the trackobject of the track, in which the RazorEdit happens
        RazorEditTable[index]["Envelope_guid"] - the guid of the envelope, in which the RazorEdit happens; "" if it's for the entire track
        
    The following are optional entries:
        RazorEdit[index]["Envelope"] - the TrackEnvelope-object, when RazorEdit is for an envelope; nil, otherwise
        RazorEdit[index]["Envelope_name"] - the name of the envelope, when RazorEdit is for an envelope; nil, otherwise    
  </description>
  <retvals>
    integer number_razor_edits - the number of razor_edits available in the current project; 0, if none
    table RazorEditTable - a table with all attributes of all Razor-Edits available
  </retvals>
  <chapter_context>
    Razor Edit
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_RazorEdit_Module.lua</source_document>
  <tags>razor edit, get, all, attributes</tags>
</US_DocBloc>
]]
  local RazorEdit={}
  local RazorEdit_count=0
  for a=0, reaper.CountTracks(0)-1 do
    local retval
    local track=reaper.GetTrack(0,a)
    local A,B=reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
    local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(B, " ")
    if count>1 then
      for i=1, count, 3 do
        RazorEdit_count=RazorEdit_count+1
        RazorEdit[RazorEdit_count]={}
        if individual_values[i+2]=="\"\"" then 
          RazorEdit[RazorEdit_count]["IsTrack"]=true
          
        elseif individual_values[i+2]:len()>4 then
          RazorEdit[RazorEdit_count]["IsTrack"]=false
          RazorEdit[RazorEdit_count]["Envelope"]=reaper.GetMediaTrackInfo_Value(track, "P_ENV:"..individual_values[i+2]:sub(2,-2))
          retval, RazorEdit[RazorEdit_count]["Envelope_name"] = reaper.GetEnvelopeName(RazorEdit[RazorEdit_count]["Envelope"])
        end
        RazorEdit[RazorEdit_count]["Tracknumber"]=a+1
        RazorEdit[RazorEdit_count]["Track"]=track
        RazorEdit[RazorEdit_count]["Start"]=tonumber(individual_values[i])
        RazorEdit[RazorEdit_count]["End"]=tonumber(individual_values[i+1])
        RazorEdit[RazorEdit_count]["Envelope_guid"]=individual_values[i+2]:sub(2,-2)
      end
    end
  end
  
  return RazorEdit_count, RazorEdit
end