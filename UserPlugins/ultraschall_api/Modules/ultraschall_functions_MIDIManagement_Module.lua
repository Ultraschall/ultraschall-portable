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
---     MIDI Management Module    ---
-------------------------------------

if type(ultraschall)~="table" then 
  -- update buildnumber and add ultraschall as a table, when programming within this file
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "Functions-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
  local retval, string = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "MIDIManagement-Module-Build", "", reaper.GetResourcePath().."/UserPlugins/ultraschall_api/IniFiles/ultraschall_api.ini")
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


function ultraschall.ZoomVertical_MidiEditor(zoomamt, HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ZoomVertical_MidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ZoomVertical_MidiEditor(integer zoomamt, optional HWND midieditor_hwnd)</functioncall>
  <description>
    Zooms within the Midi-Editor vertically.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if zooming was successful; false, if not
  </retvals>
  <parameters>
    integer zoomamt - the zoom-factor; positive values, zoom in; negative values, zoom out
    optional HWND midieditor_hwnd - the HWND of the MIDI-Editor, in which you want to zoom; nil, uses active MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>midimanagement, zoom, midieditor, vertically</tags>
</US_DocBloc>
]]
  -- check parameters and prepare correct zoom-actioncommandid
  if HWND==nil then HWND=reaper.MIDIEditor_GetActive() end
  if math.type(zoomamt)~="integer" then ultraschall.AddErrorMessage("ZoomVertical_MidiEditor","zoomamt", "Must be an integer!", -1) return false end
  if zoomamt>0 then actioncommandid=40111 -- zoom in
  elseif zoomamt<0 then actioncommandid=40112 -- zoom out
  else actioncommandid=65535 -- do nothing, when 0 is given as zoom-value
  end
  
  -- Now, do the zooming
  if zoomamt<0 then zoomamt=zoomamt*-1 end
  for i=1, zoomamt do
    reaper.MIDIEditor_OnCommand(HWND, actioncommandid)
  end
end

--ultraschall.ZoomVertical_MidiEditor(HWND, 5)

function ultraschall.ZoomHorizontal_MidiEditor(zoomamt, HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ZoomHorizontal_MidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ZoomHorizontal_MidiEditor(integer zoomamt, optional HWND midieditor_hwnd)</functioncall>
  <description>
    Zooms within the Midi-Editor horizontally.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if zooming was successful; false, if not
  </retvals>
  <parameters>
    integer zoomamt - the zoom-factor; positive values, zoom in; negative values, zoom out
    optional HWND midieditor_hwnd - the HWND of the MIDI-Editor, in which you want to zoom; nil, uses active MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>midimanagement, zoom, midieditor, horizontally</tags>
</US_DocBloc>
]]
  -- check parameters and prepare correct zoom-actioncommandid
  if HWND==nil then HWND=reaper.MIDIEditor_GetActive() end
  if math.type(zoomamt)~="integer" then ultraschall.AddErrorMessage("ZoomHorizontal_MidiEditor","zoomamt", "Must be an integer!", -1) return false end
  if zoomamt>0 then actioncommandid=1012 -- zoomin
  elseif zoomamt<0 then actioncommandid=1011 -- zoomout
  else actioncommandid=65535 -- nothing, when 0 is given
  end
  
  -- do the zooming
  if zoomamt<0 then zoomamt=zoomamt*-1 end -- 
  for i=1, zoomamt do
    reaper.MIDIEditor_OnCommand(HWND, actioncommandid)
  end
  return true
end

--ultraschall.ZoomHorizontal_MidiEditor(HWND, 5)


function ultraschall.OpenItemInMidiEditor(MediaItem)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>OpenItemInMidiEditor</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.OpenItemInMidiEditor(MediaItem MediaItem)</functioncall>
  <description>
    opens a given MediaItem in the MIDI-Editor
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if opening was successful; false, if not
  </retvals>
  <parameters>
    MediaItem MediaItem - the MediaItem to be opened in the MIDI-Editor
  </parameters>
  <chapter_context>
    MIDI Management
    MIDI Editor
  </chapter_context>
  <target_document>US_Api_Documentation</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>midimanagement, open, item, midieditor</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr2(0, MediaItem, "MediaItem*")==false then ultraschall.AddErrorMessage("OpenItemInMidiEditor","MediaItem", "Must be a MediaItem!", -1) return false end
  ultraschall.ApplyActionToMediaItem(MediaItem, 40153, 1, false)
  return true
end

--MediaItem=reaper.GetMediaItem(0,0)
--ultraschall.OpenItemInMidiEditor(MediaItem)

