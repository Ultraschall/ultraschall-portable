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
---  Reaper User Interface Module ---
-------------------------------------


function ultraschall.GetVerticalZoom()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetVerticalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer vertical_zoom_factor = ultraschall.GetVerticalZoom()</functioncall>
  <description>
    Returns the vertical-zoom-factor.
    
    Returns -1 in case of error
  </description>
  <retvals>
    integer vertical_zoom_factor - the current vertical zoom-factor
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, vertical, zoom, factor</tags>
</US_DocBloc>
--]]
  -- prepare variables and check, whether config-variable vzoom2 is still a valid one
  local vzoom=reaper.SNM_GetIntConfigVar("vzoom2",-9)
  local checkvzoom=reaper.SNM_GetIntConfigVar("vzoom2",-10)
  -- if yes, return zoomfactor
  if vzoom==checkvzoom then 
    return vzoom
  else
    ultraschall.AddErrorMessage("GetVerticalZoom", "", "Unknown error while retrieving vertical zoom-level. Please contact the developers of the Ultraschall-Api!", -1) return -1
  end
end

--L=ultraschall.GetVerticalZoom()

function ultraschall.SetVerticalZoom(vertical_zoom_factor)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetVerticalZoom</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetVerticalZoom(integer vertical_zoom_factor)</functioncall>
  <description>
    Sets the vertical zoom factor.

    To set it relative to the current vertical-zoom-value, use Reaper's own API-function CSurf_OnZoom
    
    Returns -1 in case of error.
  </description>
  <parameters>
    integer vertical_zoom_factor - the current vertical zoom-factor
  </parameters>
  <retvals>
    integer retval - -1, in case of error
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, vertical, zoom, factor</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(vertical_zoom_factor)~="integer" then ultraschall.AddErrorMessage("SetVerticalZoom","vertical_zoom_factor", "Must be an integer", -1) return -1 end
  if vertical_zoom_factor<0 or vertical_zoom_factor>40 then ultraschall.AddErrorMessage("SetVerticalZoom","vertical_zoom_factor", "Must be between 0 and 40", -2) return -1 end

  -- prepare variables
  local OldVzoom=reaper.SNM_GetIntConfigVar("vzoom2",-20)
  local DiffVZoom=vertical_zoom_factor-OldVzoom

  -- do the zoom  
  reaper.CSurf_OnZoom(0, DiffVZoom)
end



function ultraschall.StoreArrangeviewSnapshot(slot, description, position, vzoom, vscroll)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>StoreArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.StoreArrangeviewSnapshot(integer slot, string description, boolean position, boolean vzoom, boolean vscroll)</functioncall>
  <description>
    Stores a new Arrangeview-snapshot, that includes the position, horizontal zoom, vertical zoom and vertical scroll.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
    string description - a description for this arrangeview-snapshot
    boolean position - true, store start and endposition of the current arrangeview; false, don't store start and endposition of current arrangeview(keep old position in slot, if existing)
    boolean vzoom - true, store current vertical-zoom-factor; false, don't store current vertical-zoom-factor(keep old zoomfactor in slot, if existing)
    boolean vscroll - true, store current vertical scroll-factor; false, don't store current vertival-scroll-factor
  </parameters>
  <retvals>
    integer retval - -1, in case of error
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, arrangeview, snapshot</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","slot", "Must be an integer", -1) return -1 end
  if slot<0 then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return -1 end
  if type(description)~="string" and description~=nil then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","description", "Must be a string(to set description) or nil(to keep old description)", -3) return -1 end
  if type(position)~="boolean" and position~=nil then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","position", "Must be boolean(to set with current start&end-position) or nil(to keep old start&end-position)", -4) return -1 end
  if type(vzoom)~="boolean" and vzoom~=nil then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","vzoom", "Must be boolean(to set with current vertical zoom) or nil(to keep old vertical zoom)", -6) return -1 end
  if type(vscroll)~="boolean" and vscroll~=nil then ultraschall.AddErrorMessage("StoreArrangeviewSnapshot","vscroll", "Must be boolean(to set with current vertical scroll) or nil(to keep old vertical scroll)", -7) return -1 end
  
  -- prepare variables
  local slot=tostring(slot)
  local start,ende=reaper.GetSet_ArrangeView2(0,false,0,0)
  local vzoom2=ultraschall.GetVerticalZoom()
  local hzoom=reaper.GetHZoomLevel()

  -- store start/end-position, verticalzoom and description; position and vzoom only, if parameters position and vzoom are set to true
  if position==true then 
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_start", start)
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_end", ende)
  elseif position==nil then 
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_start", -1)
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_end", -1)
  end

  if type(description)=="string" then 
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_description", description)
  elseif description==nil then
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_description", -1)
  end

  if vzoom==true then 
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom", vzoom2)
  elseif vzoom==false then
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom", -1)
  end
  
  local translation = reaper.JS_Localize("trackview", "DLG_102")
  
  local retval, vscroll2 = reaper.JS_Window_GetScrollInfo(reaper.JS_Window_Find(translation, true), "SB_VERT")
  
  if vscroll==true then
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll", vscroll2)
  elseif vscroll==false then
    reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll", -1)  
  end
  
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom", hzoom)  
end

--ultraschall.StoreArrangeviewSnapshot(1, "LSubisubisu", true, true, true, true)

function ultraschall.IsValidArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Checks, if an Arrangeview-snapshot-slot is valid(means set).
    
    Returns false in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>
  <retvals>
    boolean retval - true, if Arrangeview-Snapshot is valid; false, if Arrangeview-Snapshot is not existing
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, check, arrangeview, snapshot</tags>
</US_DocBloc>
--]]  
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("IsValidArrangeviewSnapshot","slot", "Must be an integer", -1) return false end
  if slot<0 then ultraschall.AddErrorMessage("IsValidArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return false end
  
  -- prepare variable
  slot=tostring(slot)
  
  -- check, whether there is valid information to retrieve from the Arrange-view-snapshot-slot
  if reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")~=0 or
     reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")~=0 then
     return true
  else
    return false
  end
end

--L=ultraschall.IsValidArrangeviewSnapshot(1)

function ultraschall.RetrieveArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RetrieveArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string description, number startposition, number endposition, integer vzoomfactor, number hzoomfactor, number vertical_scroll = ultraschall.RetrieveArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Retrieves an Arrangeview-snapshot and returns the startposition, endposition and vertical and horizontal zoom-factor as well as the number vertical-scroll-factor..
    
    Returns false in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>
  <retvals>
    boolean retval - false, in case of error; true, in case of success
    string description - a description for this arrangeview-snapshot
    number startposition - the startposition of the arrangeview
    number endposition - the endposition of the arrangeview
    integer vzoom - the vertical-zoomfactor(0-40)
    number hzoomfactor - the horizontal zoomfactor
    number vertical_scroll - the vertical scroll-value
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, arrangeview, snapshot, startposition, endposition, verticalzoom, horizontal zoom, vertical scroll</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot","slot", "Must be an integer", -1) return false end
  if slot<0 then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return false end
  if ultraschall.IsValidArrangeviewSnapshot(slot)==false then ultraschall.AddErrorMessage("RetrieveArrangeviewSnapshot", "slot", "No such slot available", -3) return false end

  -- prepare variables
  slot=tostring(slot)
  local _l, start, ende, description, vzoom, hzoom, vscroll
  
  -- get information from arrangeview-snapshot-slot and return it, if existing
  if reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")~=0 or
     reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")~=0 or
     reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")~="" then
     
     _l, start=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_start")
     _l, ende=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_end")
     _l, description=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_description")
     _l, vzoom=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom")
     _l, hzoom=reaper.GetProjExtState(0,"Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom")
     _l, vscroll=reaper.GetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll")
     return true, description, tonumber(start), tonumber(ende), tonumber(vzoom), tonumber(hzoom), tonumber(vscroll)
  else
    return false
  end
end

--A,B,C,D,E,F,G,H,I=ultraschall.RetrieveArrangeviewSnapshot(1)

function ultraschall.RestoreArrangeviewSnapshot(slot, position, vzoom, hcentermode, verticalscroll)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RestoreArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval, string description, number startposition, number endposition, integer vzoomfactor, number hzoomfactor, number vertical_scroll_factor = ultraschall.RestoreArrangeviewSnapshot(integer slot, optional boolean position, optional boolean vzoom, optional integer hcentermode, optional boolean verticalscroll)</functioncall>
  <description>
    Sets arrangeview to start/endposition and horizontal and vertical-zoom, as received from Arrangeview-Snapshot-slot. It returns the newly set start/endposition, vertical zoom, horizontal zoom and description of slot.
    
    Returns false in case of error.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
    optional boolean position - nil or true, set arrange to stored start and endposition(and it's horizontal-zoom); false, set only horizontal-zoom
    optional boolean vzoom - nil or true, set vertical-zoom; false, don't set vertical zoom
    optional integer hcentermode - decides, what shall be in the center of the zoomed horizontal view. Only available when position==false
                                 - The following are available:
                                 -  nil, keeps center of view in the center during zoom(default)
                                 -   -1, default selection, as set in the reaper-prefs, 
                                 -    0, edit-cursor or playcursor(if it's in the current zoomfactor of the view during playback/recording) in center,
                                 -    1, keeps edit-cursor in center of zoom
                                 -    2, keeps center of view in the center during zoom
                                 -    3, keeps in center of zoom, what is beneath the mousecursor
    optional boolean verticalscroll - true or nil, sets vertical scroll-value as well; false, doesn't set vertical-scroll-value
  </parameters>
  <retvals>
    boolean retval - false, in case of error; true, in case of success
    string description - a description for this arrangeview-snapshot
    number startposition - the startposition of the arrangeview
    number endposition - the endposition of the arrangeview
    integer vzoom - the vertical-zoomfactor(0-40)
    number hzoomfactor - the horizontal zoomfactor
    number vertical_scroll_factor - the vertical-scroll-factor
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, arrangeview, snapshot, startposition, endposition, verticalzoom, horizontalzoom</tags>
</US_DocBloc>
--]]
  -- check parameters
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","slot", "Must be an integer", -1) return false end
  if slot<0 then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","slot", "Must be bigger than 0", -2) return false end
  if ultraschall.IsValidArrangeviewSnapshot(slot)==false then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot", "slot", "No such slot available", -3) return false end
  if position~=nil and type(position)~="boolean" then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","position", "Must be nil(for true) or a boolean", -4) return false end
  if vzoom~=nil and type(vzoom)~="boolean" then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","vzoom", "Must be nil(for true) or a boolean", -5) return false end
  if vzoom==nil then vzoom=true end
  if position==false and hcentermode~=nil and math.type(hcentermode)~="integer" then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","hcentermode", "Must be nil or an integer", -6) return false end
  if hcentermode~=nil and (hcentermode<-1 or hcentermode>3) then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","hcentermode", "Must be nil or between -1 and 3", -7) return false end
  if verticalscroll~=nil and type(verticalscroll)~="boolean" then ultraschall.AddErrorMessage("RestoreArrangeviewSnapshot","verticalscroll", "Must be nil(for true) or a boolean", -8) return false end
    
  -- prepare variables by retrieving the snapshot-slot-information
  local bool, description, start, ende, vzoom3, hzoom, vscroll = ultraschall.RetrieveArrangeviewSnapshot(slot)
  local start2,ende2=reaper.GetSet_ArrangeView2(0,false,0,0)
  if start==-1 then start=start2 end
  if ende==-1 then ende=ende2 end
  
  if hcentermode==nil then hcentermode=3 end
  
  -- set arrangeview to the values
  if position==false then
    reaper.adjustZoom(hzoom, 1, true, hcentermode)
    start, ende =  reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
  else
    reaper.GetSet_ArrangeView2(0, true, 0, 0, start, ende)
  end
  
  
  if vzoom3~=-1 and vzoom==true then 
    ultraschall.SetVerticalZoom(vzoom3)
  end  
  
  if verticalscroll==true or verticalscroll==nil then
    local translation = reaper.JS_Localize("trackview", "DLG_102")
    
    reaper.JS_Window_SetScrollPos(reaper.JS_Window_Find(translation, true), "SB_VERT", vscroll)
  end
  reaper.UpdateArrange()
  return true, description, start, ende, vzoom, hzoom, vscroll
end


function ultraschall.DeleteArrangeviewSnapshot(slot)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>DeleteArrangeviewSnapshot</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.DeleteArrangeviewSnapshot(integer slot)</functioncall>
  <description>
    Deletes an ArrangeviewSnapshot-slot.
    
    Returns -1 if the slot is unset or slot is an invalid value.
  </description>
  <parameters>
    integer slot - the slot for arrangeview-snapshot
  </parameters>            
  <retvals>
    integer retval - -1 in case of an error; 0 in case of success
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, delete, arrangeview, snapshot, startposition, endposition, verticalzoom</tags>
</US_DocBloc>
--]]
  if math.type(slot)~="integer" then ultraschall.AddErrorMessage("DeleteArrangeviewSnapshot","slot", "Must be an integer!", -1) return -1 end

  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_start","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_end","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_description","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_hzoom","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vzoom","","")
  reaper.SetProjExtState(0, "Ultraschall", "ArrangeViewSnapShot_"..slot.."_vscroll","","")
  return 1
end


function ultraschall.SetIDEFontSize(fontsize)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetIDEFontSize</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetIDEFontSize(integer fontsize)</functioncall>
  <description>
    Sets the fontsize of Reaper's IDE (ReaScript/Video Processor/JSFX)
    New fontsize is valid for all IDE's opened after calling this function.
    
    Returns false in case of an error
  </description>
  <parameters>
    integer fontsize - the new font-size for Reaper's IDEs
  </parameters>
  <retvals>
    boolean retval - true, if setting was successful; false, if not
  </retvals>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, ide, fontsize, set</tags>
</US_DocBloc>
--]]
  if math.type(fontsize)~="integer" then ultraschall.AddErrorMessage("SetIDEFontSize","fontsize", "Must be an integer!", -1) return false end
  if fontsize<=-1 then ultraschall.AddErrorMessage("SetIDEFontSize","fontsize", "Must be bigger or equal 0!", -2) return false end
  return reaper.SNM_SetIntConfigVar("edit_fontsize", fontsize)
end

--ultraschall.SetIDEFontSize(16)

function ultraschall.GetIDEFontSize()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetIDEFontSize</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.77
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.GetIDEFontSize()</functioncall>
  <description>
    Returns the current fontsize of Reaper's IDE (ReaScript/Video Processor/JSFX)
  </description>
  <retvals>
    integer fontsize - the currently set fontsize within Reaper's IDEs
  </retvals>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, ide, fontsize, get</tags>
</US_DocBloc>
--]]
  local A=reaper.SNM_GetIntConfigVar("edit_fontsize", -1)
  local B=reaper.SNM_GetIntConfigVar("edit_fontsize", -2)
  if A==B then return A else return 16 end
end

--L=ultraschall.GetIDEFontSize()


function ultraschall.GetPlayCursorWidth()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPlayCursorWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>integer play_cursor_width = ultraschall.GetPlayCursorWidth()</functioncall>
  <description>
    Returns the width of the playcursor in pixels
    
    see <a href="#SetPlayCursorWidth">SetPlayCursorWidth</a> for setting the playcursor-width.
  </description>
  <retvals>
    integer play_cursor_width - the width of the playcursor in pixels
  </retvals>
  <chapter_context>
    User Interface
    Transport
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, playcursor, width</tags>
</US_DocBloc>
--]]
  local playcursormode=reaper.SNM_GetIntConfigVar("playcursormode", -1)
  return playcursormode
end

--A,B,C,D,E,F,G=ultraschall.GetPlayCursorWidth()

function ultraschall.SetPlayCursorWidth(play_cursor_width, persist)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetPlayCursorWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.941
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetPlayCursorWidth(integer play_cursor_width, boolean persist)</functioncall>
  <description>
    Sets a new playcursor-width.
    
    see <a href="#GetPlayCursorWidth">GetPlayCursorWidth</a> for getting the playcursor-width.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer play_cursor_width - the new width of the playcursor
    boolean persist - true, set the setting to reaper.ini so it persists after restarting Reaper; false, set it only for the time, until Reaper is restarted
  </parameters>
  <chapter_context>
    User Interface
    Transport
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, playcursor, width</tags>
</US_DocBloc>
--]]
  if math.type(play_cursor_width)~="integer" then ultraschall.AddErrorMessage("SetPlayCursorWidth", "play_cursor_width", "Must be an integer", -1) return false end
  if play_cursor_width<0 or play_cursor_width>2147483647 then ultraschall.AddErrorMessage("SetPlayCursorWidth", "play_cursor_width", "Must be between 0 and 2147483647", -2) return false end
  if type(persist)~="boolean" then ultraschall.AddErrorMessage("SetPlayCursorWidth", "persist", "Must be a boolean", -3) return false end
  
  local playcursormode=reaper.SNM_SetIntConfigVar("playcursormode", play_cursor_width)
  
  if playcursormode==false then ultraschall.AddErrorMessage("SetPlayCursorWidth", "playcursormode", "Couldn't set playcursormode, contact Ultraschall-Api-developers for this...", -4) return false end
  
  if persist==true then
    local A=ultraschall.SetIniFileValue("REAPER", "playcursormode", tostring(play_cursor_width), reaper.get_ini_file())
    if A==false then ultraschall.AddErrorMessage("SetPlayCursorWidth", "persist", "Couldn't set changed config to persist. Maybe a problem with accessing reaper.ini.", -5) return false end
  end
  return true    
end

--A=ultraschall.SetPlayCursorWidth(2,true)
--ultraschall.SetStartNewFileRecSizeState(true, false, 613, false)


function ultraschall.GetScreenWidth(want_workarea)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScreenWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer width = ultraschall.GetScreenWidth(optional boolean want_workarea)</functioncall>
  <description>
    returns the width of the screen in pixels.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer width - the width of the screen in pixels
  </retvals>
  <parameters>
    optional boolean want_workarea - true, returns workspace only; false, full monitor coordinates of the returned viewport; nil, will be seen as true
  </parameters>
  <chapter_context>
    User Interface
    Screen Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, screen, width</tags>
</US_DocBloc>
--]]
  if want_workarea~=nil and type(want_workarea)~="boolean" then ultraschall.AddErrorMessage("GetScreenWidth", "want_workarea", "Must be a boolean", -1) return -1 end  
  if want_workarea==nil then want_workarea=true end
  local left, top, right, bottom = reaper.my_getViewport(0,0,0,0,0,0,0,0, want_workarea)
  return right
end


function ultraschall.GetScreenHeight(want_workarea)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScreenHeight</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer height = ultraschall.GetScreenHeight(optional boolean want_workarea)</functioncall>
  <description>
    returns the height of the screen in pixels.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer width - the height of the screen in pixels
  </retvals>
  <parameters>
    optional boolean want_workarea - true, returns workspace only; false, full monitor coordinates of the returned viewport; nil, will be seen as true
  </parameters>
  <chapter_context>
    User Interface
    Screen Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, screen, height</tags>
</US_DocBloc>
--]]
  if want_workarea~=nil and type(want_workarea)~="boolean" then ultraschall.AddErrorMessage("GetScreenHeight", "want_workarea", "Must be a boolean", -1) return -1 end  
  if want_workarea==nil then want_workarea=true end
  local left, top, right, bottom = reaper.my_getViewport(0,0,0,0,0,0,0,0, want_workarea)
  return bottom  
end

--A=ultraschall.GetScreenHeight()


function ultraschall.ShowMenu(Title,Entries,x,y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowMenu</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.95
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.ShowMenu(string Title, string Entries, integer x, integer y)</functioncall>
  <description>
    Draws a menu at position x,y.
    
    Entries is the string, that contains the Menuentries, separated by |
    Example: "Entry1|Entry2|Entry3"
    
    Each field can start with a special character
      # grays out the entry
      ! entry is checked
      > starts a new submenu, where every following entry will be part of the submenu
      < ends a submenu with this entry being the last one
    These special characters can be combined, however, grayed out entries don't open submenus, even if they are shown as submenus.
    A field with nothing in it || creates a separator.    
    
    The returned number follows the numbering of the clickable(!) entries. Even if grayed out-entries can't be selected, they count as well.
    However, opening-submenu-entries and separators don't count as clickable.
    That said, if you have one grayed out entry and one normal entry, the grayed out entry is 1, the normal entry(the only selectable one) is 2.
    
    The following entry 

      Normal1|>SubmenuOpener|Submenuentry1|<SubmenuEntry2Closer|#Grayed Out

    creates the following menu:
    
      Normal1
      SubmenuOpener >
        Submenuentry1
        SubmenuEntry2Closer
      Grayed Out
    
    One last thing: the title does not count as entry!
    
    Note for Mac-users: y-coordinates are "reversed", so y=0 is at the bottom
    Note for Linux: does not work on Linux yet.
    
    returns -1 in case of an error
  </description>
  <retvals>
    integer retval - the selected entry; 0, nothing selected
  </retvals>
  <parameters>
    string Title - the title shown on top of the menu
    string Entries - the individual entries. See above on how to create such an entry.
    integer x - the x-position of the menu
    integer y - the y-position of the menu
  </parameters>
  <chapter_context>
    User Interface
    Context Menus
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, create, menu, contextmenu</tags>
</US_DocBloc>
]]
  if type(Title)~="string" then ultraschall.AddErrorMessage("ShowMenu", "Title", "must be a string", -1) return -1 end
  if type(Entries)~="string" then ultraschall.AddErrorMessage("ShowMenu", "Entries", "must be a string", -2) return -1 end
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowMenu", "x", "must be an integer", -3) return -1 end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowMenu", "y", "must be an integer", -4) return -1 end
  if Entries=="" then ultraschall.AddErrorMessage("ShowMenu", "Entries", "must have at least one entry", -5) return -1 end
  if Title:len()<=5 then for i=5-Title:len(),1, -1 do Title=Title.." " end end

  local ownwindow=false
  if gfx.h==0 and gfx.w==0 then gfx.init("Ultraschall-Menu",0,0,0,x,y)
    gfx.x=-10
    gfx.y=-25
    ownwindow=true
  else
    local convx, convy = gfx.screentoclient(x, y)
    gfx.x=convx
    gfx.y=convy
  end
  
  local selection=gfx.showmenu("#"..Title.."||"..Entries)
  if ownwindow==true then gfx.quit() gfx.w=0 gfx.h=0 end
  return math.floor(selection)-1
end

--L=ultraschall.ShowMenu("","Normal1",-1,-1)




function ultraschall.IsValidHWND(HWND)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>IsValidHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.IsValidHWND(HWND hwnd)</functioncall>
  <description>
    Checks, if a HWND-handler is a valid one.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if running it was successful; false, if not
  </retvals>
  <parameters>
    HWND hwnd - the HWND-handler to check for
  </parameters>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, hwnd, is valid, check</tags>
</US_DocBloc>
]]
  if reaper.ValidatePtr(HWND, "HWND")==false then ultraschall.AddErrorMessage("IsValidHWND", "HWND", "Not a valid HWND.", -2) return false end
  if pcall(reaper.JS_Window_GetTitle, HWND, "")==false then ultraschall.AddErrorMessage("IsValidHWND", "HWND", "Not a valid HWND.", -1) return false end
  return true
end

--AAA=ultraschall.IsValidHWND(reaper.Splash_GetWnd("tudelu",nil))

--AAAAA=reaper.MIDIEditor_LastFocused_OnCommand(1)

function ultraschall.BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>BrowseForOpenFiles</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>string path, integer number_of_files, array filearray = ultraschall.BrowseForOpenFiles(string windowTitle, string initialFolder, string initialFile, string extensionList, boolean allowMultiple)</functioncall>
  <description>
    Opens a filechooser-dialog which optionally allows selection of multiple files.
    Unlike Reaper's own GetUserFileNameForRead, this dialog allows giving non-existant files as well(for saving operations).
    
    Returns nil in case of an error
  </description>
  <retvals>
    string path - the path, in which the selected file(s) lie; nil, in case of an error; "" if no file was selected
    integer number_of_files - the number of files selected; 0, if no file was selected
    array filearray - an array with all the selected files
  </retvals>
  <parameters>
    string windowTitle - the title shown in the filechooser-dialog
    string initialFolder - the initial-folder opened in the filechooser-dialog
    string initialFile - the initial-file selected in the filechooser-dialog, good for giving default filenames
    string extensionList - a list of extensions that can be selected in the selection-list.
                         - the list has the following structure(separate the entries with a \0): 
                         -       "description of type1\0type1\0description of type 2\0type2\0"
                         - the description of type can be anything that describes the type(s), 
                         - to define one type, write: *.ext 
                         - to define multiple types, write: *.ext;*.ext2;*.ext3
                         - the extensionList must end with a \0
    boolean allowMultiple - true, allows selection of multiple files; false, only allows selection of single files
  </parameters>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, dialog, file, chooser, multiple</tags>
</US_DocBloc>
]]
  if type(windowTitle)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "windowTitle",   "Must be a string.",  -1) return nil end  
  if type(initialFolder)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "initialFolder", "Must be a string.",  -2) return nil end  
  if type(initialFile)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "initialFile",   "Must be a string.",  -3) return nil end  
  if type(extensionList)~="string"  then ultraschall.AddErrorMessage("BrowseForOpenFiles", "extensionList", "Must be a string.",  -4) return nil end  
  if type(allowMultiple)~="boolean" then ultraschall.AddErrorMessage("BrowseForOpenFiles", "allowMultiple", "Must be a boolean.", -5) return nil end  
  
  local retval, fileNames = reaper.JS_Dialog_BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple)
  local path, filenames, count
  if allowMultiple==true then
    count, filenames = ultraschall.SplitStringAtNULLBytes(fileNames)
    path = filenames[1]
    table.remove(filenames,1)
  else
    filenames={}
    path, filenames[1]=ultraschall.GetPath(fileNames)
    count=2
  end
  if retval==0 then path="" count=1 filenames={} end
  return path, count-1, filenames
end

--A,B,C=ultraschall.BrowseForOpenFiles("Tudelu", "c:\\", "", "", true)

--A,B,C=reaper.JS_Dialog_BrowseForOpenFiles("Tudelu", "", "", "", false)

function ultraschall.HasHWNDChildWindowNames(HWND, childwindownames)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>HasHWNDChildWindowNames</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.HasHWNDChildWindowNames(HWND hwnd, string childwindownames)</functioncall>
  <description>
    Returns, whether the given HWND has childhwnds with a certain name in them. This is good for checking for valid Reaper-windows. 
    As gfx.init()-windows can have the same as Reaper's original-windows, this function gives you the chance for aditional checks.
    gfx.init windows don't have child-hwnds and other applications probably have child-hwnds with different names.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retal - true, the HWND has child-hwnds with that name(s); false, it doesn't
  </retvals>
  <parameters>
    HWND hwnd - the HWND, whose child-hwnd-names you want to check
    string childwindownames - a string with the names of the child-HWNDs the parameter hwnd must have. It is a \0-separated string, means, you put \0 in between the child-Hwnd-names.
  </parameters>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, check, childhwnd, hwnd, windows</tags>
</US_DocBloc>
]]
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(childwindownames,"\0")
  local retval, list = reaper.JS_Window_ListAllChild(HWND)
  local count2, individual_values2 = ultraschall.CSV2IndividualLinesAsArray(list)
  local Title={}
  for i=1, count2 do
    if individual_values2[i]~="" then
      local tempHwnd=reaper.JS_Window_HandleFromAddress(individual_values2[i])
      Title[i]=reaper.JS_Window_GetTitle(tempHwnd)
      for a=1, count do
        if Title[i]==individual_values[a] then individual_values[a]="found" end
      end
    end
  end
  for i=1, count do
    if individual_values[i]~="found" then return false end
  end
  return true
end

--reaper.ShowConsoleMsg("A")
--A2=reaper.JS_Window_Find("ReaScript console output", true)
--O2=ultraschall.HasHWNDChildWindowNames(A2, "Clear\0 Close")

function ultraschall.CloseReaScriptConsole()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>CloseReaScriptConsole</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.CloseReaScriptConsole()</functioncall>
  <description>
    Closes the ReaConsole-window, if opened.
    
    Returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, if there is a mute-point; false, if there isn't one
  </retvals>
  <chapter_context>
    API-Helper functions
    ReaScript Console
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, reaconsole, close</tags>
</US_DocBloc>
]]
  local translation = reaper.JS_Localize("ReaScript console output", "DLG_437")
  local retval,Adr=reaper.JS_Window_ListFind(translation, true)

--  if retval>1 then ultraschall.AddErrorMessage("CloseReaScriptConsole", "", "Multiple windows are open, that are named \"ReaScript console output\". Can't find the right one, sorry.", -1) return false end
  if retval==0 then ultraschall.AddErrorMessage("CloseReaScriptConsole", "", "ReaConsole-window not opened", -2) return false end
  local count2, individual_values2 = ultraschall.CSV2IndividualLinesAsArray(Adr)
  for i=1, count2 do
    local B=reaper.JS_Window_HandleFromAddress(individual_values2[i])
    if ultraschall.HasHWNDChildWindowNames(B, "Clear\0Close")==true then 
      reaper.JS_Window_Destroy(B) 
      return true 
    end
  end
  return false
end

--gfx.init("ReaScript console output")
--reaper.ShowConsoleMsg("Tudelu")
--LL,LL=ultraschall.CloseReaConsole()


function ultraschall.MB(caption, title, mbtype, button1_caption, button2_caption, button3_caption)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>MB</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    JS=1.215
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.MB(string msg, optional string title, optional integer type, optional string button1_caption, optional string button2_caption, optional string button3_caption)</functioncall>
  <description>
    Shows Messagebox with user-clickable buttons. Works like reaper.MB() but unlike reaper.MB, this function accepts omitting some parameters for quicker use.
    
    Important: This doesn't work on Mac, as you can not replace the button texts there in the first place. Sorry...
    
    You can change the text in the buttons with button1_caption, button2_caption and button3_caption.
        
    Returns -1 in case of an error
  </description>
  <parameters>
    string msg - the message, that shall be shown in messagebox
    optional string title - the title of the messagebox
    optional integer type - which buttons shall be shown in the messagebox, in that order
                            - 0, OK
                            - 1, OK CANCEL
                            - 2, ABORT RETRY IGNORE
                            - 3, YES NO CANCEL
                            - 4, YES NO
                            - 5, RETRY CANCEL
                            - nil, defaults to OK
    optional string button1_caption - caption of the first button
    optional string button2_caption - caption of the second button
    optional string button3_caption - caption of the third button
  </parameters>
  <retvals>
    integer - the button pressed by the user
                           - -1, error while executing this function
                           - 1, Button 1
                           - 2, Button 2
                           - 3, Button 3
  </retvals>
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, user, interface, input, dialog, messagebox</tags>
</US_DocBloc>
--]]
--  if ultraschall.IsOS_Windows()==false then ultraschall.AddErrorMessage("MB", "", "works only on Windows, sorry", 0) return -1 end
  if type(caption)~="string" then ultraschall.AddErrorMessage("MB", "caption", "must be a string", -1) return -1 end
  if title~=nil and type(title)~="string" then ultraschall.AddErrorMessage("MB", "title", "must be a string or nil", -2) return -1 end
  if mbtype~=nil and math.type(mbtype)~="integer" then ultraschall.AddErrorMessage("MB", "mbtype", "must be an integer or nil(defaults to 0)", -3) return -1 end
  if mbtype<0 or mbtype>5 then ultraschall.AddErrorMessage("MB","mbtype", "Must be between 0 and 5!", -4) return -1 end
  
  if button1_caption~=nil and type(button1_caption)~="string" then ultraschall.AddErrorMessage("MB", "button1_caption", "must be a string or nil", -5) return -1 end
  if button2_caption~=nil and type(button2_caption)~="string" then ultraschall.AddErrorMessage("MB", "button2_caption", "must be a string or nil", -6) return -1 end
  if button3_caption~=nil and type(button3_caption)~="string" then ultraschall.AddErrorMessage("MB", "button3_caption", "must be a string or nil", -7) return -1 end
  
  if button1_caption==nil then button1_caption="" end
  if button2_caption==nil then button2_caption="" end
  if button3_caption==nil then button3_caption="" end
  if mbtype==nil then mbtype=0 end
  if title==nil then title="" end
  local temptitle=reaper.genGuid("")  
  ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/SetMessageBox_Helper_Script.lua", temptitle, title, mbtype, button1_caption, button2_caption, button3_caption)

  local answer=reaper.MB(caption, temptitle, mbtype)

  if mbtype==0 and answer==1 then return 1
  elseif mbtype==1 and answer==1 then return 1
  elseif mbtype==1 and answer==2 then return 2
  elseif mbtype==2 and answer==3 then return 1
  elseif mbtype==2 and answer==4 then return 2
  elseif mbtype==2 and answer==5 then return 3
  elseif mbtype==3 and answer==6 then return 1
  elseif mbtype==3 and answer==7 then return 2
  elseif mbtype==3 and answer==2 then return 3
  elseif mbtype==4 and answer==6 then return 1
  elseif mbtype==4 and answer==7 then return 2
  elseif mbtype==5 and answer==4 then return 1
  elseif mbtype==5 and answer==2 then return 2
  end

  return answer
end


function ultraschall.GetTopmostHWND(hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTopmostHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>HWND topmost_hwnd, integer number_of_parent_hwnd, table all_parent_hwnds = ultraschall.GetTopmostHWND(HWND hwnd)</functioncall>
  <description>
    returns the topmost-parent hwnd of a hwnd, as sometimes, hwnds are children of a higher hwnd. It also returns the number of parent hwnds available and a list of all parent hwnds for this hwnd.
    
    A hwnd is a window-handler, which contains all attributes of a certain window.
    
    returns nil in case of an error
  </description>
  <parameters>
    HWND hwnd - the HWND, whose topmost parent-HWND you want to have
  </parameters>
  <retvals>
    HWND hwnd - the top-most parent hwnd available
    integer number_of_parent_hwnd - the number of parent hwnds, that are above the parameter hwnd
    table all_parent_hwnds - all available parent hwnds, above the parameter hwnd, including the topmost-hwnd
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, hwnd, topmost, parent hwnd, get, count</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidHWND(hwnd)==false then ultraschall.AddErrorMessage("GetTopmostHWND", "hwnd", "not a valid hwnd", -1) return nil end
  local count=1
  local other_hwnds={}
  while reaper.JS_Window_GetParent(hwnd)~=nil do  
     hwnd=reaper.JS_Window_GetParent(hwnd)
     other_hwnds[count]=hwnd
     count=count+1
  end
  return hwnd, count-1, other_hwnds
end

--A,B,C,D=ultraschall.GetTopmostHWND(reaper.JS_Window_GetFocus())

--reaper.MB(tostring(A).."\n"..tostring(B).."\n"..reaper.JS_Window_GetTitle(C[1])..                                                reaper.JS_Window_GetTitle(C[2]).."\n","",0)
--                                              ..reaper.JS_Window_GetTitle(C[3]),"",0)


function ultraschall.GetReaperWindowAttributes()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaperWindowAttributes</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>integer left, integer top, integer right, integer bottom, boolean active, boolean visible, string title, integer number_of_childhwnds, table childhwnds = ultraschall.GetReaperWindowAttributes()</functioncall>
  <description>
    returns many attributes of the Reaper Main-window, like position, size, active, visibility, childwindows
    
    A hwnd is a window-handler, which contains all attributes of a certain window.
    
    returns nil in case of an error
  </description>
  <parameters>
    HWND hwnd - the HWND, whose topmost parent-HWND you want to have
  </parameters>
  <retvals>
    integer left - the left position of the Reaper-window in pixels
    integer top - the top position of the Reaper-window in pixels
    integer right - the right position of the Reaper-window in pixels
    integer bottom - the bottom position of the Reaper-window in pixels
    boolean active - true, if the window is active(any child-hwnd of the Reaper-window has focus currently); false, if not
    boolean visible - true, Reaper-window is visible; false, Reaper-window is not visible
    string title - the current title of the Reaper-window
    integer number_of_childhwnds - the number of available child-hwnds that the Reaper-window currently has
    table childhwnds - a table with all child-hwnds in the following format:
                     -      childhwnds[index][1]=hwnd
                     -      childhwnds[index][2]=title
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, hwnd, reaper, main window, position, active, visible, child-hwnds</tags>
</US_DocBloc>
]]
  local hwnd=reaper.GetMainHwnd()
  local title = reaper.JS_Window_GetTitle(hwnd)
  local visible=reaper.JS_Window_IsVisible(hwnd)
  local num_child_windows, child_window_list = reaper.JS_Window_ListAllChild(hwnd)
  local childwindows={}
  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(child_window_list)
  for i=1, count do
    childwindows[i]={}
    childwindows[i][1]=reaper.JS_Window_HandleFromAddress(individual_values[i])
    childwindows[i][2]=reaper.JS_Window_GetTitle(childwindows[i][1])
  end
  
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)

  local hwnd_temp=ultraschall.GetTopmostHWND(reaper.JS_Window_GetFocus())
  if hwnd_temp==hwnd then active=true else active=false end
  
  return left, top, right, bottom, active, visible, title, count, childwindows
end



--retval, number position, number pageSize, number min, number max, number trackPos = reaper.JS_Window_GetScrollInfo(identifier windowHWND, string scrollbar)

--A,B,C,D,E,F,G,H,I,J=ultraschall.GetReaperWindowAttributes()
--reaper.MB(tostring(A).." "..tostring(B).." "..tostring(C).." "..tostring(D).." "..tostring(E).." "..tostring(F).." "..tostring(G).." "..tostring(H).." "..tostring(I),"",0)


function ultraschall.Windows_Find(title, exact)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>Windows_Find</slug>
  <requires>
    Ultraschall=4.2
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer count_hwnds, array hwnd_array, array hwnd_adresses = ultraschall.Windows_Find(string title, boolean strict)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    Returns all Reaper-window-HWND-handler, with a given title. Can be further used with the JS\_Window\_functions of the JS-function-plugin.
    
    Doesn't return IDE-windows! Use [GetAllReaScriptIDEWindows](#GetAllReaScriptIDEWindows) to get them.
    
    returns -1 in case of an error
  </description>
  <parameters>
    integer count_hwnds - the number of windows found
    array hwnd_array - the hwnd-handler of all found windows
    array hwnd_adresses - the adresses of all found windows
  </parameters>
  <retvals>
    string title - the title the window has
    boolean strict - true, if the title must be exactly as given by parameter title; false, only parts of a windowtitle must match parameter title
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, find, hwnd, windows, reaper</tags>
</US_DocBloc>
]]
  if type(title)~="string" then ultraschall.AddErrorMessage("Windows_Find", "title", "must be a string", -1) return -1 end
  if type(exact)~="boolean" then ultraschall.AddErrorMessage("Windows_Find", "exact", "must be a boolean", -2) return -1 end
  local retval, list = reaper.JS_Window_ListFind(title, exact)
  local list=list..","
  local hwnd_list={}
  local hwnd_list2={}
  local count=0
  local parenthwnd
  for i=1, retval do
    local temp,offset=list:match("(.-),()")
    local temphwnd=reaper.JS_Window_HandleFromAddress(temp)
    parenthwnd=reaper.JS_Window_GetParent(temphwnd)
    while parenthwnd~=nil do
      if parenthwnd==reaper.GetMainHwnd() then
        count=count+1
        hwnd_list[count]=temphwnd
        hwnd_list2[count]=temp
      end    
      parenthwnd=reaper.JS_Window_GetParent(parenthwnd)
    end
    if Tudelu~=nil then
    end
    list=list:sub(offset,-1)
  end
  return count, hwnd_list, hwnd_list2
end

--A,B,C=ultraschall.Windows_Find("Reaper", false)

--gfx.init(" - ReaScript Development Environment")

function ultraschall.GetAllReaScriptIDEWindows()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetAllReaScriptIDEWindows</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer count_ide_hwnds, array ide_hwnd_array, array ide_titles = ultraschall.GetAllReaScriptIDEWindows()</functioncall>
  <description>
    Returns the hwnds and all titles of all Reaper-IDE-windows currently opened.
  </description>
  <retvals>
    integer count_ide_hwnds - the number of windows found
    array ide_hwnd_array - the hwnd-handler of all found windows
    array ide_titles - the titles of all found windows
  </retvals>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, get, hwnd, windows, reaper, ide</tags>
</US_DocBloc>
]]
  local translation = reaper.JS_Localize("ReaScript Development Environment", "DLG_114")
  local retval, list = reaper.JS_Window_ListFind("", false)
  local list=list..","
  local IDE_Array={}
  local IDE_Array_Title={}
  local count=0
  
  local temphwnd, retval2, list2, temp
  
  for i=1, retval do
    temphwnd=reaper.JS_Window_HandleFromAddress(list:match("(.-),"))
    if reaper.JS_Window_GetTitle(temphwnd):match(" - ReaScript Development Environment")~=nil then
      retval2, list2 = reaper.JS_Window_ListAllChild(temphwnd)
      list2=list2..","
      if retval2>0 then    
        temp={}
        for i=1, retval2-1 do
          temp[0]=reaper.JS_Window_HandleFromAddress(list2:match("(.-),"))
          --temp[i]=reaper.JS_Window_GetTitle(temp[0])
          list2=list2:match(",(.*)")
        end
        
        count=count+1
        IDE_Array[count]=reaper.JS_Window_GetParent(temp[0])
        IDE_Array_Title[count]=reaper.JS_Window_GetTitle(IDE_Array[count])
      end
    end
    list=list:match(",(.*)")
  end
  return count, IDE_Array, IDE_Array_Title
end


--PP,PPP,PPPP=ultraschall.GetAllReaScriptIDEWindows()

function ultraschall.GetReaScriptConsoleWindow()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetReaScriptConsoleWindow</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND reascript_console_hwnd = ultraschall.GetReaScriptConsoleWindow()</functioncall>
  <description>
    Returns the hwnd of the ReaScript-Console-window, if opened.
    
    returns nil when ReaScript-console isn't opened
  </description>
  <retvals>
    HWND reascript_console_hwnd - the window-handler to the ReaScript-console, if opened
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, get, hwnd, windows, reaper, console</tags>
</US_DocBloc>
]]
  local translation = reaper.JS_Localize("ReaScript console output", "DLG_437")
  local retval,Adr=reaper.JS_Window_ListFind(translation, true)
  local count2  
  
  if retval==0 then ultraschall.AddErrorMessage("GetReaScriptConsoleWindow", "", "ReaConsole-window not opened", -2) return nil end
  
  local count2, individual_values2 = ultraschall.CSV2IndividualLinesAsArray(Adr)
  
  for i=1, count2 do
    local B=reaper.JS_Window_HandleFromAddress(individual_values2[i])
    if ultraschall.HasHWNDChildWindowNames(B, "Clear\0Close")==true then return B end
  end
  ultraschall.AddErrorMessage("GetReaScriptConsoleWindow", "", "ReaConsole-window not opened", -2) 
  return nil
end

--gfx.init("ReaScript console output")
--reaper.ShowConsoleMsg("rOCK IT")
--A=ultraschall.GetReaScriptConsoleWindow()


function ultraschall.GetHWND_ArrangeViewAndTimeLine()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetHWND_ArrangeViewAndTimeLine</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.20
    JS=0.964
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>HWND arrange_view, HWND timeline, HWND TrackControlPanel, HWND TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()</functioncall>
  <description>
    Returns the HWND-Reaper-Windowhandler for the tracklist- and timeline-area in the arrange-view 
    
    Note: in later versions of Reaper, TracklistWindow and arrange_view became the same.
    
    returns nil in case of an error. Please report such an error, which means, that you should use ultraschall.ShowLastErrorMessage() to show that error and report the information requested(fruitful bugreports lead to a handwritten postcard as reward :) )
  </description>
  <retvals>
    HWND arrange_view - the HWND-window-handler for the tracklist-area of the arrangeview
    HWND timeline - the HWND-window-handler for the timeline/markerarea of the arrangeview
    HWND TrackControlPanel - the HWND-window-handler for the track-control-panel(TCP)(may not work anymore in an upcoming Reaper-release! Send me a note in that case!)
    HWND TrackListWindow - the HWND-window-handler for the tracklist-window
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, get, hwnd, arrangeview, timeline, trackview, tcp, track control panel</tags>
</US_DocBloc>
--]]

  -- preparation of variables
  local ARHWND, TLHWND, temphwnd, TCPHWND, TCPHWND2
  
  -- if we haven't stored the adress of the arrangeviewhwnd yet, let's go find them.
  if reaper.GetExtState("ultraschall", "arrangehwnd")=="" or
     reaper.GetExtState("ultraschall", "timelinehwnd")=="" or
     reaper.GetExtState("ultraschall", "tcphwnd")
  then
    -- prepare some values we need
    local Start, Stop = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)
    local Projectlength=reaper.GetProjectLength()

    -- get mainhwnd of Reaper and all of it's childhwnds
    local HWND=reaper.GetMainHwnd()    
    local retval, list = reaper.JS_Window_ListAllChild(HWND)    
    
    --Now, the magic happens
    
    
    -- [ Getting Arrangeview HWND] --
    
    -- split the hwnd-adresses into individual adresses
    local Count, Individual_values = ultraschall.CSV2IndividualLinesAsArray(list)
    
    
    -- get current scroll-state of all hwnds
    local ScrollState={}
    for i=1, Count do
      ScrollState[i]={}
      local temphwnd=reaper.JS_Window_HandleFromAddress(Individual_values[i])
    
      ScrollState[i]["retval"], ScrollState[i]["position"], ScrollState[i]["pageSize"], ScrollState[i]["min"], ScrollState[i]["max"], ScrollState[i]["trackPos"] = reaper.JS_Window_GetScrollInfo(temphwnd,"h")
      retval, ScrollState[i]["left"], ScrollState[i]["top"], ScrollState[i]["right"], ScrollState[i]["bottom"] = reaper.JS_Window_GetRect(temphwnd)
    end
    
    -- alter scrollstate
    reaper.GetSet_ArrangeView2(0, true, 0, 0, Start+100000,Stop+100000)
    
    -- check scrollstate of all hwnds for the one, whose scrollstate changed, as this is the arrange-view-hwnd
    for i=1, Count do
      temphwnd=reaper.JS_Window_HandleFromAddress(Individual_values[i])
      local retval, position, pageSize, min, max, trackPos = reaper.JS_Window_GetScrollInfo(temphwnd,"h")
      if position~=ScrollState[i]["position"] or 
         pageSize~=ScrollState[i]["pageSize"] or
         min~=ScrollState[i]["min"] or
         max~=ScrollState[i]["max"] or
         trackPos~=ScrollState[i]["trackPos"] then
        ARHWND=temphwnd 
        break
      end
    end

    -- in the unlikely case that I can't find a hwnd, return this error-message    
    if ARHWND==nil then ultraschall.AddErrorMessage("GetHWND_ArrangeViewAndTimeLine", "", 
          [[Couldn't find Arrangeview for some reason. Please report this to me as a bug and what you did to make this error happen!
  
  Please include in the bugreport your OS, the Reaper-version and the following information:
  ]]..Projectlength..", "..Start..", "..Stop..", "..reaper.GetHZoomLevel(), -1) return nil end
    
    -- reset arrangeview-scrolling to it's original state
    reaper.GetSet_ArrangeView2(0, true, 0, 0, Start,Stop)
    

    -- [ Getting Timeline HWND] --
    
    -- let's get the dimensions of the arrangeview-hwnd, as top, left and right-positions can be used
    -- to determine bottom, left, right of the timeline-hwnd
     local retval, left, top, right, bottom = reaper.JS_Window_GetRect(ARHWND)
    
    -- TimeLine: check all hwnds to find the one, that has right=right, left=left, bottom_timeline=top_arrangeview
    for i=1, Count do
      local temphwnd=reaper.JS_Window_HandleFromAddress(Individual_values[i])
      if ScrollState[i]["left"]==left and ScrollState[i]["right"]==right and ScrollState[i]["bottom"]==top then
        TLHWND=temphwnd 
        break
      end
    end
    
    -- TCP: check all hwnds to find the one, that has right<left, top=top, bottom_timeline=top_arrangeview
    for i=1, Count do
      local temphwnd=reaper.JS_Window_HandleFromAddress(Individual_values[i])
      if (reaper.GetToggleCommandState(42373)==0 and ScrollState[i]["right"]<=left 
          and ScrollState[i]["top"]==top 
          and ScrollState[i]["bottom"]==bottom-18) 
          or
          (reaper.GetToggleCommandState(42373)==1 and ScrollState[i]["left"]>=right
                    and ScrollState[i]["top"]==top 
                    and ScrollState[i]["bottom"]==bottom-18) 
          then
        if TCPHWND==nil then 
          TCPHWND=temphwnd 
        else 
          TCPHWND2=temphwnd
          if reaper.JS_Window_GetParent(TCPHWND2)==TCPHWND then TCPHWND=TCPHWND2 end
        end
      end
    end
    
    -- store the adresses of the found HWNDs of Arrangeview and Timeline into an extstate for further use, to prevent useless
    -- scroll-state-altering of the Arrangeview(which could cause stuck Arrangeviews, when done permanently)
    reaper.SetExtState("ultraschall", "arrangehwnd", reaper.JS_Window_AddressFromHandle(ARHWND), false)
    reaper.SetExtState("ultraschall", "timelinehwnd", reaper.JS_Window_AddressFromHandle(TLHWND), false)
    if TCPHWND~=nil then
        reaper.SetExtState("ultraschall", "tcphwnd", reaper.JS_Window_AddressFromHandle(TCPHWND), false)
    ultraschall.TLHWND=TCPHWND
    end
    ultraschall.ARHWND=ARHWND
    ultraschall.TLHWND=TLHWND
  else
    -- if the extstate already has stored the arrangeview-hwnd-address, just convert the one for arrangeview and timeline
    -- it into their handles and return them
    ARHWND=reaper.JS_Window_HandleFromAddress(tonumber(reaper.GetExtState("ultraschall", "arrangehwnd")))
    TLHWND=reaper.JS_Window_HandleFromAddress(tonumber(reaper.GetExtState("ultraschall", "timelinehwnd")))
    TCPHWND=reaper.JS_Window_HandleFromAddress(tonumber(reaper.GetExtState("ultraschall", "tcphwnd")))
    if TCPHWND=="" then TCPHWND=nil end
  end  
  return ARHWND, TLHWND, TCPHWND, reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
end

--reaper.SNM_SetIntConfigVar("mixerflag", 2)


function ultraschall.GetVerticalScroll()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetVerticalScroll</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>integer vertical_scroll_factor = ultraschall.GetVerticalScroll()</functioncall>
  <description>
    Gets the current vertical_scroll_value. The valuerange is dependent on the vertical zoom.
  </description>
  <retvals>
    integer vertical_scroll_factor - the vertical-scroll-factor
  </retvals>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>arrangeviewmanagement, get, vertical, scroll factor</tags>
</US_DocBloc>
--]]
  local retval, position = reaper.JS_Window_GetScrollInfo(ultraschall.GetHWND_ArrangeViewAndTimeLine(), "SB_VERT")
  
  return position
end

--A=ultraschall.GetVerticalScroll()

function ultraschall.SetVerticalScroll(scrollposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetVerticalScroll</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetVerticalScroll(integer scrollposition)</functioncall>
  <description>
    Sets the absolute vertical-scroll-factor.
    
    The possible value-range depends on the vertical-zoom.
    
    returns false in case of an error or if scrolling is impossible(e.g. zoomed out fully)
  </description>
  <retvals>
    boolean retval - true, if setting was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    integer scrollposition - the vertical scrolling-position
  </parameters>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>arrangeviewmanagement, set, vertical, scroll factor</tags>
</US_DocBloc>
--]]
  if math.type(scrollposition)~="integer" then ultraschall.AddErrorMessage("SetVerticalScroll", "scrollposition", "must be an integer", -1) return false end
  
  return reaper.JS_Window_SetScrollPos(ultraschall.GetHWND_ArrangeViewAndTimeLine(), "SB_VERT", scrollposition)
end

--A=ultraschall.SetVerticalScroll(100)

function ultraschall.SetVerticalRelativeScroll(relative_scrollposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetVerticalRelativeScroll</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetVerticalRelativeScroll(integer relative_scrollposition)</functioncall>
  <description>
    Sets the vertical-scroll-factor, relative to it's current position.
    
    The possible value-range depends on the vertical-zoom.
    
    returns false in case of an error or if scrolling is impossible(e.g. zoomed out fully)
  </description>
  <retvals>
    boolean retval - true, if setting was successful; false, if setting was unsuccessful
  </retvals>
  <parameters>
    integer scrollposition - the vertical scrolling-position
  </parameters>
  <chapter_context>
    User Interface
    Arrangeview Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>arrangeviewmanagement, set, relative, vertical, scroll factor</tags>
</US_DocBloc>
--]]
  if math.type(relative_scrollposition)~="integer" then ultraschall.AddErrorMessage("SetVerticalRelativeScroll", "relative_scrollposition", "must be an integer", -1) return false end
  
  local A=ultraschall.GetVerticalScroll()
  
  return reaper.JS_Window_SetScrollPos(ultraschall.GetHWND_ArrangeViewAndTimeLine(), "SB_VERT", A+relative_scrollposition)
end

--ultraschall.SetVerticalRelativeScroll(1)

function ultraschall.GetUserInputs(title, caption_names, default_retvals, values_length, caption_length, x_pos, y_pos)
--TODO: when there are newlines in captions, count them and resize these captions automatically, as well as move down the following captions and inputfields, so they
--      match the captionheights, without interfering into each other.
--      will need resizing of the window as well and moving OK and Cancel-buttons
--      if a caption ends with a newline, it will get the full width of the window, with the input-field moving one down, getting full length as well

--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUserInputs</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.11
    SWS=2.11.0
    JS=1.215
    Lua=5.3
  </requires>
  <functioncall>boolean retval, integer number_of_inputfields, table returnvalues = ultraschall.GetUserInputs(string title, table caption_names, table default_retvals, optional integer values_length, optional integer caption_length, optional integer x_pos, optional integer y_pos)</functioncall>
  <description>
    Gets inputs from the user.
    
    Important: This works only on Windows, currently.
    
    The captions and the default-returnvalues must be passed as an integer-index table.
    e.g.
      caption_names[1]="first caption name"
      caption_names[2]="second caption name"
      caption_names[1]="*third caption name, which creates an inputfield for passwords, due the * at the beginning"
      
   The number of entries in the tables "caption_names" and "default_retvals" decide, how many inputfields are shown. Maximum is 16 inputfields.
   You can safely pass "" as table-entry for a name, if you don't want to set it.
      
      The following example shows an input-dialog with three fields, where the first two the have default-values:
      
        retval, number_of_inputfields, returnvalues = ultraschall.GetUserInputs("I am the title", {"first", "second", "third"}, {1,"two"})   
     
   Note: Don't use this function within defer-scripts or scripts that are started by defer-scripts, as this produces errors.
         This is due limitations in Reaper, sorry.

   Note for Mac-Users: size of caption/retval-fields and positioning of the window doesn't work on Mac yet, but you can use these parameters anyways.
                       This is due Mac's way of having y-coordinate starting at the bottom and I will fix it as soon as I figured that out.

   returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, the user clicked ok on the userinput-window; false, the user clicked cancel or an error occured
    integer number_of_inputfields - the number of returned values; nil, in case of an error
    table returnvalues - the returnvalues input by the user as a table; nil, in case of an error
  </retvals>
  <parameters>
    string title - the title of the inputwindow
    table caption_names - a table with all inputfield-captions. All non-string-entries will be converted to string-entries. Begin an entry with a * for password-entry-fields.
                        - it can be up to 16 fields
                        - This dialog only allows limited caption-field-length, about 19-30 characters, depending on the size of the used characters.
                        - Don't enter nil as captionname, as this will be seen as end of the table by this function, omitting possible following captionnames!
    table default_retvals - a table with all default retvals. All non-string-entries will be converted to string-entries.
                          - it can be up to 16 fields
                          - Only enter nil as default-retval, if no further default-retvals are existing, otherwise use "" for empty retvals.
                          - for no default-retvals, write nil
    optional integer values_length - the extralength of the values-inputfield. With that, you can enhance the length of the inputfields. 
                            - 1-500(doesn't work on Mac yet)
    optional integer caption_length - the length of the caption in pixels; inputfields and OK, Cancel-buttons will be moved accordingly.(doesn't work on Mac yet)
    optional integer x_pos - the x-position of the GetUserInputs-dialog; nil, to keep default position(doesn't work on Mac yet)
    optional integer y_pos - the y-position of the GetUserInputs-dialog; nil, to keep default position(doesn't work on Mac yet)
  </parameters>
                           - keep in mind: on Mac, the y-position starts with 0 at the bottom, while on Windows and Linux, 0 starts at the top of the screen!
                           -               this is the standard-behavior of the operating-systems themselves.
  <chapter_context>
    User Interface
    Dialogs
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, dialog, get, user input</tags>
</US_DocBloc>
--]]
--  if ultraschall.IsOS_Windows()==false then ultraschall.AddErrorMessage("GetUserInputs", "", "works only on Windows, sorry", 0) return false end
  local count33, autolength
  if type(title)~="string" then ultraschall.AddErrorMessage("GetUserInputs", "title", "must be a string", -1) return false end
  if caption_names~=nil and type(caption_names)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be a table", -2) return false end
  if caption_names==nil then caption_names={""} end
  if default_retvals~=nil and type(default_retvals)~="table" then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be a table", -3) return false end
  if default_retvals==nil then default_retvals={""} end
  if values_length~=nil and math.type(values_length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be an integer", -4) return false end
  if values_length==nil then values_length=40 end
  if (values_length>500 or values_length<1) and values_length~=-1 then ultraschall.AddErrorMessage("GetUserInputs", "values_length", "must be between 1 and 500", -5) return false end
  if values_length==-1 then values_length=1 autolength=true end
  local count = ultraschall.CountEntriesInTable_Main(caption_names)
  local count2 = ultraschall.CountEntriesInTable_Main(default_retvals)
  if count>16 then ultraschall.AddErrorMessage("GetUserInputs", "caption_names", "must be no more than 16 caption-names!", -5) return false end
  if count2>16 then ultraschall.AddErrorMessage("GetUserInputs", "default_retvals", "must be no more than 16 default-retvals!", -6) return false end
  if count2>count then count33=count2 else count33=count end
  values_length=(values_length*2)+18
 
  if x_pos~=nil and math.type(x_pos)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "x_pos", "must be an integer or nil!", -7) return false end
  if y_pos~=nil and math.type(y_pos)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "y_pos", "must be an integer or nil!", -8) return false end
  if x_pos==nil then x_pos="keep" end
  if y_pos==nil then y_pos="keep" end
  
  if caption_length~=nil and math.type(caption_length)~="integer" then ultraschall.AddErrorMessage("GetUserInputs", "caption_length", "must be an integer or nil!", -9) return false end
  if caption_length==nil then caption_length=40 end
  caption_length=(caption_length*2)+18
  
  
  local captions=""
  local retvals=""  
  
  for i=1, count2 do
    if default_retvals[i]==nil then default_retvals[i]="" end
    retvals=retvals..tostring(default_retvals[i])..","
    if autolength==true and values_length<tostring(default_retvals[i]):len() then values_length=(tostring(default_retvals[i]):len()*6.6)+18 end
  end
  retvals=retvals:sub(1,-2)  
  
  for i=1, count do
    if caption_names[i]==nil then caption_names[i]="" end
    captions=captions..tostring(caption_names[i])..","
    --if autolength==true and length<tostring(caption_names[i]):len()+length then length=(tostring(caption_names[i]):len()*16.6)+18+length end
  end
  captions=captions:sub(1,-2)
  if count<count2 then
    for i=count, count2 do
      captions=captions..","
    end
  end
  captions=captions..",extrawidth="..values_length
  
  --print2(captions)
  -- fill up empty caption-names, so the passed parameters are 16 in count
  for i=1, 16 do
    if caption_names[i]==nil then
      caption_names[i]=""
    end
  end
  caption_names[17]=nil

  -- fill up empty default-values, so the passed parameters are 16 in count  
  local default_retvals2={}
  for i=1, 16 do
    if default_retvals[i]==nil then
      default_retvals2[i]=""
    else
      default_retvals2[i]=default_retvals[i]
    end
  end
  default_retvals2[17]=nil

  local numentries, concatenated_table = ultraschall.ConcatIntegerIndexedTables(caption_names, default_retvals2)
  
  local temptitle="Tudelu"..reaper.genGuid()
  
  
  ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/Scripts/GetUserInputValues_Helper_Script.lua", temptitle, title, 3, x_pos, y_pos, caption_length, values_length, "Tudelu", table.unpack(concatenated_table))
  
  local retval, retvalcsv = reaper.GetUserInputs(temptitle, count33, "A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16", "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16")
  if retval==false then reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false) return false end
  local Values=reaper.GetExtState(ultraschall.ScriptIdentifier, "values")
  --print2(Values)
  reaper.DeleteExtState(ultraschall.ScriptIdentifier, "values", false)
  local count2,Values=ultraschall.CSV2IndividualLinesAsArray(Values ,"\n")
  for i=count2, 17 do
    Values[i]=nil
  end
  return retval, count33, Values
end

--A,B,C,D=ultraschall.GetUserInputs("I got you", {"ShalalalaOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOHAH"}, {"HHHAAAAHHHHHHHHHHHHHHHHHHHHHHHHAHHHHHHHA"}, -1)




function ultraschall.GetRenderToFileHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderToFileHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetRenderToFileHWND()</functioncall>
  <description>
    returns the HWND of the Render to File-dialog, if the window is opened.
    
    returns nil if Render to File-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Render to File-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, render to file, hwnd, get</tags>
</US_DocBloc>
--]]

  local translation=reaper.JS_Localize("Render to File", "DLG_506")
  
  local presets=reaper.JS_Localize("Presets", "DLG_506")
  local monofiles=reaper.JS_Localize("Tracks with only mono media to mono files", "DLG_506")
  local render_to=reaper.JS_Localize("Render to", "DLG_506")
  
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            monofiles,
                                            render_to,
                                            presets)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--AAAA=ultraschall.GetRenderToFileHWND()



--AAA=ultraschall.GetRenderToFileHWND()

function ultraschall.GetActionsHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetActionsHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetActionsHWND()</functioncall>
  <description>
    returns the HWND of the Actions-dialog, if the window is opened.
    
    returns nil if the Actions-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Actions-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, actions, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Actions", "common")
  local find_shortcut=reaper.JS_Localize("Find shortcut...", "DLG_274")
  local add=reaper.JS_Localize("Add...", "DLG_274")
  local new=reaper.JS_Localize("New...", "DLG_274")
  local run_close=reaper.JS_Localize("Run/close", "actiondialog")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--AAA=ultraschall.GetActionsHWND()

function ultraschall.GetVideoHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetVideoHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetVideoHWND()</functioncall>
  <description>
    returns the HWND of the Video window, if the window is opened.
    
    due API-limitations on Mac and Linux: if more than one window called "Video Window" is opened, it will return -1
    I hope to find a workaround for that problem at some point...
    
    returns nil if the Video Window is closed or can't be determined
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Video Window
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, video, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Video Window", "common")
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  elseif reaper.GetOS():match("Win")~=nil then
    for i=count_hwnds, 1, -1 do
      if reaper.JS_Window_GetClassName(hwnd_array[i], "")=="REAPERVideoMainwnd" then 
        local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(hwnd_array[i])
        return hwnd_array[i], left, top, right, bottom
      end
    end
  else 
    if count_hwnds==1 then
      return hwnd_array[1]
    else
      ultraschall.AddErrorMessage("GetVideoHWND", "", "more than one window called Video Window opened. Can't determine the right one...sorry", -1)
      return nil
    end
  end
  return nil
end
--gfx.init(reaper.JS_Localize("Video Window", "common"))
--A=ultraschall.GetVideoHWND()

function ultraschall.GetRenderQueueHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderQueueHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetRenderQueueHWND()</functioncall>
  <description>
    returns the HWND of the Render-Queue-dialog, if the window is opened.
    
    returns nil if the Render-Queue-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Render-Queue-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, render queue, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Queued Renders", "DLG_427")
  local find_shortcut=reaper.JS_Localize("Render selected", "DLG_427")
  local add=reaper.JS_Localize("Remove selected", "DLG_427")
  local new=reaper.JS_Localize("Render all", "DLG_427")
  local run_close=reaper.JS_Localize("Close", "DLG_427")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetRenderQueueHWND()


function ultraschall.GetProjectSettingsHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectSettingsHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetProjectSettingsHWND()</functioncall>
  <description>
    returns the HWND of the Project Settings-dialog, if the window is opened.
    
    returns nil if the Project-Settings-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Project Settings-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, project settings, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Project Settings", "common")
  local find_shortcut=reaper.JS_Localize("Save as default project settings", "DLG_127")
  local add=reaper.JS_Localize("Pages", "DLG_127")
  local new=reaper.JS_Localize("OK", "DLG_127")
  local run_close=reaper.JS_Localize("Cancel", "DLG_127")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetProjectSettingsHWND()
--B=reaper.JS_Window_GetTitle(A)


function ultraschall.GetPreferencesHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreferencesHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetPreferencesHWND()</functioncall>
  <description>
    returns the HWND of the Preferences-dialog, if the window is opened.
    
    returns nil if the Preferences-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Preferences-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, preferences, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("REAPER Preferences", "DLG_128")
  local find_shortcut=reaper.JS_Localize("Tree1", "DLG_128")
  local add=reaper.JS_Localize("Find", "DLG_128")
  local new=reaper.JS_Localize("Apply", "DLG_128")
  local run_close=reaper.JS_Localize("Cancel", "DLG_128")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetPreferencesHWND()
--B=reaper.JS_Window_GetTitle(A)


function ultraschall.GetSaveLiveOutputToDiskHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSaveLiveOutputToDiskHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetSaveLiveOutputToDiskHWND()</functioncall>
  <description>
    returns the HWND of the "Save live output to disk(bounce)"-dialog, if the window is opened.
    
    returns nil if the "Save live output to disk(bounce)"-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the "Save live output to disk(bounce)"-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, bounce, save live output to disk, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Save live output to disk (bounce)", "DLG_242")
  local find_shortcut=reaper.JS_Localize("Save output only while playing or recording", "DLG_242")
  local add=reaper.JS_Localize("Stop saving output on first stop", "DLG_242")
  local new=reaper.JS_Localize("Don't save when below", "DLG_242")
  local run_close=reaper.JS_Localize("Browse...", "DLG_242")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetSaveLiveOutputToDiskHWND()
--B=reaper.JS_Window_GetTitle(A)

function ultraschall.GetConsolidateTracksHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetConsolidateTracksHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetConsolidateTracksHWND()</functioncall>
  <description>
    returns the HWND of the Consolidate Tracks-dialog, if the window is opened.
    
    returns nil if the Consolidate Tracks-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Consolidate Tracks-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, bounce, consolidate tracks, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Consolidate Tracks", "DLG_171")
  local find_shortcut=reaper.JS_Localize("Consolidation Settings", "DLG_171")
  local add=reaper.JS_Localize("Ignore silence shorter than", "DLG_171")
  local new=reaper.JS_Localize("seconds (can cause multiple files per track)", "DLG_171")
  local run_close=reaper.JS_Localize("(if required)", "DLG_171")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetConsolidateTracksHWND()
--B=reaper.JS_Window_GetTitle(A)

function ultraschall.GetExportProjectMIDIHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetExportProjectMIDIHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetExportProjectMIDIHWND()</functioncall>
  <description>
    returns the HWND of the "Export Project MIDI"-dialog, if the window is opened.
    
    returns nil if the "Export Project MIDI"-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the "Export Project MIDI"-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, bounce, export project midi, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Export Project MIDI", "DLG_285")
  local find_shortcut=reaper.JS_Localize("Consolidate time:", "DLG_285")
  local add=reaper.JS_Localize("Time selection only", "DLG_285")
  local new=reaper.JS_Localize("Embed SMPTE offset", "DLG_285")
  local run_close=reaper.JS_Localize("Embed project tempo/time signature changes", "DLG_285")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"..
                                            add.."\0"..
                                            new.."\0"..
                                            run_close)==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetExportProjectMIDIHWND()
--B=reaper.JS_Window_GetTitle(A)


function ultraschall.GetProjectDirectoryCleanupHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetProjectDirectoryCleanupHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetProjectDirectoryCleanupHWND()</functioncall>
  <description>
    returns the HWND of the "Project Directory Cleanup"-dialog, if the window is opened.
    
    returns nil if the "Project Directory Cleanup"-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the "Project Directory Cleanup"-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, bounce, project directory cleanup, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Project Directory Cleanup", "common")
  local find_shortcut=reaper.JS_Localize("Send files to recycle bin (safer)", "DLG_159")
  local add=reaper.JS_Localize("Explore", "DLG_159")
  local new=reaper.JS_Localize("Remove selected files", "DLG_159")
  local run_close=reaper.JS_Localize("CAUTION: files listed here are not used by the current project, but may be used in some other project.", "DLG_159")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            find_shortcut.."\0"
                                            ..add.."\0"
                                            ..new.."\0"
                                            ..run_close
                                            )==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetProjectDirectoryCleanupHWND()
--A=reaper.JS_Window_Find("Project Directory Cleanup1", true)
--B=reaper.JS_Window_GetTitle(A)

function ultraschall.GetBatchFileItemConverterHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetBatchFileItemConverterHWND</slug>
  <requires>
    Ultraschall=4.4
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetBatchFileItemConverterHWND()</functioncall>
  <description>
    returns the HWND of the "Batch File/Item Converter"-dialog, if the window is opened.
    
    returns nil if the "Batch File/Item Converter"-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the "Batch File/Item Converter"-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, bounce, batch file item converter, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Batch File/Item Converter", "DLG_444")
  local SourceFileDir=reaper.JS_Localize("Use source file directory", "DLG_444")
  local add=reaper.JS_Localize("Open...", "DLG_444")
  local convert_all=reaper.JS_Localize("Convert all", "DLG_444")
  --run_close=reaper.JS_Localize("Output format:", "DLG_444")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            SourceFileDir.."\0"..
                                            add.."\0"..
                                            convert_all
                                            )==true then return hwnd_array[i] end
    end
  end
  return nil
end

--A=ultraschall.GetBatchFileItemConverterHWND()
--B=reaper.JS_Window_GetTitle(A)


function ultraschall.SetReaScriptConsole_FontStyle(style)
  --[[
  <\US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>SetReaScriptConsole_FontStyle</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      Lua=5.3
    </requires>
    <functioncall>boolean retval = ultraschall.SetReaScriptConsole_FontStyle(integer style)</functioncall>
    <description>
      If the ReaScript-console is opened, you can change the font-style of it.
      You can choose between 19 different styles, with 3 being of fixed character length. It will change the next time you output text to the ReaScriptConsole.
      
      If you close and reopen the Console, you need to set the font-style again!
      
      You can only have one style active in the console!
      
      Returns false in case of an error
    </description>
    <retvals>
      boolean retval - true, displaying was successful; false, displaying wasn't successful
    </retvals>
    <parameters>
      integer length - the font-style used. There are 19 different ones.
                      - fixed-character-length:
                      -     1,  fixed, console
                      -     2,  fixed, console alt
                      -     3,  thin, fixed
                      - 
                      - normal from large to small:
                      -     4-8
                      -     
                      - bold from largest to smallest:
                      -     9-14
                      - 
                      - thin:
                      -     15, thin
                      - 
                      - underlined:
                      -     16, underlined, thin
                      -     17, underlined
                      -     18, underlined
                      - 
                      - symbol:
                      -     19, symbol
    </parameters>
    <chapter_context>
      User Interface
      Miscellaneous
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
    <tags>user interface, reascript, console, font, style</tags>
  <\/US_DocBloc>
--  ]]

  if math.type(style)~="integer" then ultraschall.AddErrorMessage("SetReaScriptConsole_FontStyle", "style", "must be an integer", -1) return false end
  if style>19 or style<1 then ultraschall.AddErrorMessage("SetReaScriptConsole_FontStyle", "style", "must be between 1 and 19", -2) return false end
  local reascript_console_hwnd = ultraschall.GetReaScriptConsoleWindow()
  if reascript_console_hwnd==nil then return false end
  local styles={32,33,36,31,214,37,218,1606,4373,3297,220,3492,3733,3594,35,1890,2878,3265,4392}
  local Textfield=reaper.JS_Window_FindChildByID(reascript_console_hwnd, 1177)
  reaper.ShowConsoleMsg(" ")
  reaper.JS_WindowMessage_Post(Textfield, "WM_SETFONT", styles[style] ,0,0,0)
  return true
end





function ultraschall.MoveChildWithinParentHWND(parenthwnd, childhwnd, relative, left, top, width, height)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>MoveChildWithinParentHWND</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      JS=0.972
      Lua=5.3
    </requires>
    <functioncall>integer newxpos, integer newypos, integer newrightpos, integer newbottompos, integer newrelativeleft, integer newrelativetop, integer newwidth, integer newheight = ultraschall.MoveChildWithinParentHWND(hwnd parenthwnd, hwnd childhwnd, boolean relative, integer left, integer top, integer width, integer height)</functioncall>
    <description>
      Moves a childhwnd within the coordinates of its parenthwnd.
      Good for moving gui-elements around without having to deal with screen-coordinates.
      
      You can decide, whether the new position shall be relative to its old position or absolute within the parenthwnd-position.
      
      The parent-hwnd must not be necessarily the parenthwnd of the childhwnd, so you can move the childhwnd relative to other hwnds as well, but
      keep in mind, that the childhwnd is only seeable within the boundaries of it's own parenthwnd!
      
      Returns nil in case of an error
    </description>
    <retvals>
      integer newxpos - the new x-position on the screen in pixels
      integer newypos - the new y-position on the screen in pixels
      integer newrightpos - the new right-position on the screen in pixels
      integer newbottompos - the new bottom-position on the screen in pixels
      integer newrelativex - the new x-position of the childhwnd, relative to it's position within the parenthwnd
      integer newrelativey - the new y-position of the childhwnd, relative to it's position within the parenthwnd
      integer newwidth - the new width of the childhwnd in pixels
      integer newheight - the new height of the childhwnd in pixels
    </retvals>
    <parameters>
      HWND parenthwnd - the parenthwnd of the childhwnd, within whose dimensions you want to move the childhwnd
      HWND childhwnd - the childhwnd, that you want to move
      boolean relative - true, new position will be relative to the old position; false, new position will be absolute within the boundaries of the parenthwnd
      integer left - the new x-position of the childhwnd in pixels
      integer top - the new y-position of the childhwnd in pixels
      integer width - the new width of the childhwnd in pixels; when relative=true then 0 keeps the old width; when relative=false then 0 is width of 0 pixels
      integer height - the new height of the childhwnd in pixels; when relative=true then 0 keeps the old height; when relative=false then 0 is height of 0 pixels
    </parameters>
    <chapter_context>
      User Interface
      Window Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
    <tags>user interface, move, childhwnd, hwnd, parenthwnd, relative, absolute, top, left, bottom, right, width, height</tags>
  </US_DocBloc>
  ]]
  if ultraschall.IsValidHWND(parenthwnd)==false then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "parenthwnd", "not a valid HWND", -1) return nil end
  if ultraschall.IsValidHWND(childhwnd)==false then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "childhwnd", "not a valid HWND", -2) return nil end
  if type(relative)~="boolean" then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "relative", "must be a boolean", -3) return nil end
  if math.type(left)~="integer" then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "left", "must be an integer", -4) return nil end
  if math.type(top)~="integer" then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "top", "must be an integer", -5) return nil end
  if math.type(width)~="integer" then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "width", "must be an integer", -6) return nil end
  if math.type(height)~="integer" then ultraschall.AddErrorMessage("MoveChildWithinParentHWND", "height", "must be an integer", -7) return nil end

  
  local a,b,c,d,e=reaper.JS_Window_GetClientRect(childhwnd)
  local a,bpar,cpar,dpar,epar=reaper.JS_Window_GetClientRect(parenthwnd)
  
  local newleft, newtop, newwidth, newheight, a1,b1,c1,d1,e1
  
  if relative==true then
    newleft=b-bpar
    newtop=c-cpar
    newwidth=d-b
    newheight=e-c
  else
    newleft=1
    newtop=1
    newwidth=0--d-b
    newheight=0--e-c
  end

  reaper.JS_Window_SetPosition(childhwnd,newleft+left,newtop+top,newwidth+width,newheight+height)
  a1,b1,c1,d1,e1=reaper.JS_Window_GetClientRect(childhwnd)

  return b1,c1,d1,e1, b1-bpar, c1-cpar, d1-b1, e1-c1
end

--A,B,C,D,E,F,G,H=ultraschall.MoveChildWithinParentHWND(reaper.GetMainHwnd(), reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1005), true, 2, 1, 1, 0)

function ultraschall.GetChildSizeWithinParentHWND(parenthwnd, childhwnd)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>GetChildSizeWithinParentHWND</slug>
    <requires>
      Ultraschall=4.00
      Reaper=5.965
      JS=0.972
      Lua=5.3
    </requires>
    <functioncall>integer xpos, integer ypos, integer width, integer height = ultraschall.GetChildSizeWithinParentHWND(hwnd parenthwnd, hwnd childhwnd)</functioncall>
    <description>
      Returns the position, height and width of a childhwnd, relative to the position of parenthwnd
      
      Returns nil in case of an error
    </description>
    <retvals>
      integer xpos - the x-position of the childhwnd relative to the position of the parenthwnd in pixels
      integer ypos - the y-position of the childhwnd relative to the position of the parenthwnd in pixels
      integer width - the width of the childhwnd in pixels
      integer height - the height of the childhwnd in pixels
    </retvals>
    <parameters>
      HWND parenthwnd - the parenthwnd of the childhwnd, whose position will be the base for position-calculation of the childhwnd
      HWND childhwnd - the childhwnd, whose dimensions you want to get, relative to the position of the parenthwnd
    </parameters>
    <chapter_context>
      User Interface
      Window Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
    <tags>user interface, get, childhwnd, hwnd, parenthwnd, relative, top, left, width, height</tags>
  </US_DocBloc>
  ]]
  if ultraschall.IsValidHWND(parenthwnd)==false then ultraschall.AddErrorMessage("GetChildSizeWithinParentHWND", "parenthwnd", "not a valid HWND", -1) return nil end
  if ultraschall.IsValidHWND(childhwnd)==false then ultraschall.AddErrorMessage("GetChildSizeWithinParentHWND", "childhwnd", "not a valid HWND", -2) return nil end
  local a,b,c,d,e=reaper.JS_Window_GetClientRect(childhwnd)
  local a,bpar,cpar,dpar,epar=reaper.JS_Window_GetClientRect(parenthwnd)
  return b-bpar, c-cpar, d-b, e-c
end

--A,B,C,D,E=ultraschall.GetChildSizeWithinParentHWND(reaper.GetMainHwnd(), reaper.GetMainHwnd())



function ultraschall.GetCheckboxState(hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetCheckboxState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.GetCheckboxState(HWND hwnd)</functioncall>
  <description>
    Gets the checked-state of a checkbox-hwnd.
    This function will not check, whether the hwnd is an actual checkbox!
    
    Returns nil in case of an error
  </description>
  <retvals>
    boolean retval - true, checkbox is checked; false, checkbox isn't checked
  </retvals>
  <parameters>
    HWND hwnd - the hwnd-handler of the checkbox
  </parameters>
  <chapter_context>
    User Interface
    UI-Elements
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, get, state, checkbox</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidHWND(hwnd)==false then ultraschall.AddErrorMessage("GetCheckboxState", "hwnd", "not a valid hwnd", -1) return end
  local state=reaper.JS_WindowMessage_Send(hwnd, "BM_GETCHECK", 0,0,0,0)
  if state==0 then return false elseif state==1 then return true end
end

function ultraschall.SetCheckboxState(hwnd, state)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetCheckboxState</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.975
    JS=0.972
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetCheckboxState(HWND hwnd, boolean state)</functioncall>
  <description>
    Sets the checked-state of a checkbox-hwnd.
    This function will not check, whether the hwnd is an actual checkbox!
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer retval - 0, in case of success
  </retvals>
  <parameters>
    HWND hwnd - the hwnd-handler of the checkbox
    boolean state - true, checkbox will be checked; false, checkbox will be unchecked
  </parameters>
  <chapter_context>
    User Interface
    UI-Elements
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, set, state, checkbox</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidHWND(hwnd)==false then ultraschall.AddErrorMessage("SetCheckboxState", "hwnd", "not a valid hwnd", -1) return end
  if type(state)~="boolean" then ultraschall.AddErrorMessage("SetCheckboxState", "state", "must be a boolean", -2) return end
  if state==true then state=1 else state=0 end
  return reaper.JS_WindowMessage_Send(hwnd, "BM_SETCHECK", state,0,0,0)
end

--hwnd = ultraschall.GetRenderToFileHWND()
--hwnd = reaper.JS_Window_FindChildByID(hwnd,1060)
--AA=ultraschall.SetCheckboxState(hwnd, false)

function ultraschall.GetRenderingToFileHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetRenderingToFileHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.977
    Lua=5.3
  </requires>
  <functioncall>HWND rendertofile_dialog = ultraschall.GetRenderingToFileHWND()</functioncall>
  <description>
    Gets the HWND of the Rendering to File-dialog, which is displayed while Reaper is rendering.
    
    returns nil in case of an error
  </description>
  <retvals>
    HWND rendertofile_dialog - the HWND of the render to file-dialog; nil, in case of an error
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>render, get, hwnd, render to file, dialog</tags>
</US_DocBloc>
]]
  local HWND=reaper.JS_Window_Find(reaper.JS_Localize("Rendering to File..." ,"DLG_124"), true)
  if HWND==nil then HWND=reaper.JS_Window_Find(reaper.JS_Localize("Finished in" ,"render"), false) end
  if HWND==nil then HWND=reaper.JS_Window_Find(reaper.JS_Localize("Rendering region " ,"render"), false) end
  if HWND==nil then ultraschall.AddErrorMessage("GetRenderingToFileHWND", "", "Can't find Rendering to File-window", -1) return end
  if ultraschall.IsValidHWND(HWND)==true then
    local Retval1 = ultraschall.HasHWNDChildWindowNames(HWND, reaper.JS_Localize("Launch File", "DLG_124"))
    local Retval2= ultraschall.HasHWNDChildWindowNames(HWND, reaper.JS_Localize("Automatically close when finished", "DLG_124"))
    local Retval3= ultraschall.HasHWNDChildWindowNames(HWND, reaper.JS_Localize("Render status", "DLG_124"))
    if Retval1==true and Retval2==true and Retval3==true then
      return HWND
    else
      ultraschall.AddErrorMessage("GetRenderingToFileHWND", "", "Can't find Rendering to File-window", -2) return
    end
  else
    ultraschall.AddErrorMessage("GetRenderingToFileHWND", "", "Can't find Rendering to File-window", -3) return
  end
end

--A=ultraschall.GetRenderingToFileHWND()


function ultraschall.GetReaperWindowPosition_Left()
-- Due to Api-limitations: when the reaper-window is too small, it returns a wrong value, up to 72 pixels too high!

  local temp,Technopop=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.get_ini_file())
  local temp,ElectricCafe=ultraschall.GetIniFileValue("REAPER", "dockheight_l", "", reaper.get_ini_file())

  local C,D,E,F,G,H,I,J,K,L=reaper.my_getViewport(1,2,3,4,5,6,7,8, true)
  local A1x,A2x= reaper.GetSet_ArrangeView2(0, false, 0,0)
  local puh

  for i=-E*2,E*2 do
    local T1,T2=reaper.GetSet_ArrangeView2(0, false, i+Technopop,i+Technopop+1)
    if T1==A1x then puh=i end
  end

  return puh-tonumber(ElectricCafe)-10
end

--A,B,C=ultraschall.GetReaperWindowPosition_Left()

function ultraschall.GetReaperWindowPosition_Right()
-- Due to Api-limitations: when the reaper-window is too small, it returns a wrong value, up to 72 pixels too high!

  local temp,Technopop=ultraschall.GetIniFileValue("REAPER", "leftpanewid", "", reaper.get_ini_file())

  local C,D,E,F,G,H,I,J,K,L=reaper.my_getViewport(1,2,3,4,5,6,7,8, true)
  local A1x,A2x= reaper.GetSet_ArrangeView2(0, false, 0,0)
  local puh

  for i=-E*2,E*2 do
    local T1,T2=reaper.GetSet_ArrangeView2(0, false, i,i+1)
    if T1==A2x then puh=i end
  end

  return puh
end

function ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(Xscreencoordinate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertScreen2ClientXCoordinate_ReaperWindow</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer Xclientcoordinate = ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(integer Xscreencoordinate)</functioncall>
  <description>
    Converts an x-screencoordinate into a x-coordinate within the Reaper-Main-Window.
    Due to Api-limitations, if the Reaper-window is too small, the position might be wrong up to about 74 pixels!
    
    returns -1 in case of error
  </description>
  <parameters>
    integer Xscreencoordinate - the screen-coordinate, you want to have converted to.
  </parameters>
  <retvals>
    integer Xclientcoordinate - coordinate within the main Reaper-window. Negative, if the coordinate is left of the edge of the window; -1, in case of error
  </retvals>
  <chapter_context>
    Reaper Element Positions
    Reaper Window
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>reaper, window, position, pixels, convert, screen, client</tags>
</US_DocBloc>
]]
  if math.type(Xscreencoordinate)~="integer" then ultraschall.AddErrorMessage("ConvertScreen2ClientXCoordinate_ReaperWindow", "Xscreencoordinate", "must be an integer", -1) return -1 end
  local A=ultraschall.GetReaperWindowPosition_Left()
  local B=ultraschall.GetReaperWindowPosition_Right()
  return Xscreencoordinate-A, B-Xscreencoordinate
end

--Xclientcoordinate = ultraschall.ConvertScreen2ClientXCoordinate_ReaperWindow(9)

function ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(Xclientcoordinate)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertClient2ScreenXCoordinate_ReaperWindow</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer Xscreencoordinate = ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(integer Xclientcoordinate)</functioncall>
  <description>
    Converts an x-clientcoordinate from within the main Reaper-window into a x-screencoordinate.
    Due to Api-limitations, if the Reaper-window is too small, the position might be wrong up to about 74 pixels!
    
    returns -1 in case of error
  </description>
  <parameters>
    integer Xclientcoordinate - the screen-coordinate, you want to have converted to. Negative, if left of the left edge of the main Reaper-window.
  </parameters>
  <retvals>
    integer Xscreencoordinate - coordinate within the screen.
  </retvals>
  <chapter_context>
    Reaper Element Positions
    Reaper Window
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>reaper, window, position, pixels, convert, screen, client</tags>
</US_DocBloc>
]]
  if math.type(Xclientcoordinate)~="integer" then ultraschall.AddErrorMessage("ConvertClient2ScreenXCoordinate_ReaperWindow", "Xclientcoordinate", "must be an integer", -1) return -1 end
  local A=ultraschall.GetReaperWindowPosition_Left()
  local B=ultraschall.GetReaperWindowPosition_Right()
  return Xclientcoordinate+A
end

--L2,L3=ultraschall.ConvertClient2ScreenXCoordinate_ReaperWindow(reaper.GetMousePosition())


function ultraschall.SetReaperWindowToSize(x,y)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetReaperWindowToSize</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    SWS=2.8.8
    Lua=5.3
  </requires>
  <functioncall>integer retval = ultraschall.SetReaperWindowToSize(integer width, integer height)</functioncall>
  <description>
    Sets the Reaper-Window to the size of w and h. The x and y-windowposition will be retained.
    
    Returns -1 in case of error.
  </description>
  <parameters>
    integer w - the new width of the Reaper-window in pixels
    integer h - the new height of the reaper-windows in pixels
  </parameters>
  <retvals>
    integer retval - -1 in case of error
  </retvals>
  <chapter_context>
    Reaper Element Positions
    Reaper Window
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>reaper, window, width, height, set</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("SetReaperWindowToSize","x", "only integer-numbers are allowed", -1) return -1 end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("SetReaperWindowToSize","y", "only integer-numbers are allowed", -2) return -1 end
  ultraschall.SetIniFileValue("Reaper", "setwndsize_x", x, reaper.get_ini_file())
  ultraschall.SetIniFileValue("Reaper", "setwndsize_y", y, reaper.get_ini_file())
  ultraschall.RunCommand("_SWS_SETWINDOWSIZE")
end


function ultraschall.ConvertYCoordsMac2Win(ycoord, height)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ConvertYCoordsMac2Win</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer conv_ycoord = ultraschall.ConvertYCoordsMac2Win(integer ycoord, optional integer height)</functioncall>
  <description>
    Converts the y-coordinate between Windows/Linux and MacOS-based systems.
    
    Note: MacOS y-coordinates begin at the bottom of the screen, while Windows and Linux y-coordinates begin at the top.
    With this function, you can convert between these two coordinate-systems
    
    returns nil in case of error
  </description>
  <parameters>
    integer ycoord - the y-coordinate to convert in pixels
    optional integer height - the height of the screen in pixels, which is the base for the conversion; nil, uses current screenheight
  </parameters>
  <retvals>
    integer conv_ycoord - the converted coordinate in pixels
  </retvals>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, convert, coordinate, mac, windows, linux, y</tags>
</US_DocBloc>
--]]
  if math.type(ycoord)~="integer" then ultraschall.AddErrorMessage("ConvertYCoordsMac2Win", "ycoord", "must be an integer", -1) return end
  if ycoord<0 then ultraschall.AddErrorMessage("ConvertYCoordsMac2Win", "ycoord", "must be bigger than 0", -2) return end
  local A,B,C,D
  if height==nil then A,B,C,height=reaper.my_getViewport(0,0,0,0,0,0,0,0,true) end
  return (ycoord-height)*-1
end

function ultraschall.GetMediaExplorerHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetMediaExplorerHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetMediaExplorerHWND()</functioncall>
  <description>
    returns the HWND of the Media Explorer, if the window is opened.
    
    returns nil if Media Explorer is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Media Explorer
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, media explorer, hwnd, get</tags>
</US_DocBloc>
--]]
  local A=reaper.GetToggleCommandState(50124)
  if A~=0 then return reaper.OpenMediaExplorer("", false) else return end
end 

--A=ultraschall.GetMediaExplorerHWND()


function ultraschall.GetTimeByMouseXPosition(xmouseposition)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTimeByMouseXPosition</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.981
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>number position = ultraschall.GetTimeByMouseXPosition(integer xposition)</functioncall>
  <description>
    Returns the projectposition at x-mouseposition.
    
    Returns nil in case of an error
  </description>
  <retvals>
    number position - the projectposition at x-coordinate in seconds
  </retvals>
  <parameters>
    integer xposition - the x-position in pixels, from which you would love to have the projectposition
  </parameters>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, projectposition, from x-position</tags>
</US_DocBloc>
--]]
  -- TODO: check, if mouse is above arrangeview and return an additional boolean parameter for that.
  if math.type(xmouseposition)~="integer" then ultraschall.AddErrorMessage("GetTimeByMouseXPosition", "xmouseposition", "must be an integer", -1) return nil end
  local Ax,AAx= reaper.GetSet_ArrangeView2(0, false, xmouseposition,xmouseposition+1)
  return Ax
end


function ultraschall.ShowTrackInputMenu(x, y, MediaTrack, HWNDParent)
 --[[
 <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
   <slug>ShowTrackInputMenu</slug>
   <requires>
     Ultraschall=4.00
     Reaper=5.92
     JS=0.986
     Lua=5.3
   </requires>
   <functioncall>boolean retval = ultraschall.ShowTrackInputMenu(integer x, integer y, optional MediaTrack MediaTrack, optional HWND HWNDParent)</functioncall>
   <description>
     Opens a TrackInput-context menu
     
     Returns false in case of error.
   </description>
   <parameters>
     integer x - x position of the context-menu in pixels
     integer y - y position of the context-menu in pixels
     optional MediaTrack MediaTrack - the MediaTrack, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected one
     optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
   </parameters>
   <retvals>
     boolean retval - true, opening the menu worked; false, there was an error
   </retvals>
   <chapter_context>
     User Interface
     Menu Management
   </chapter_context>
   <target_document>US_Api_Functions</target_document>
   <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
   <tags>userinterface, show, context menu, trackinput</tags>
 </US_DocBloc>
 --]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowTrackInputMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowTrackInputMenu", "y", "must be an integer", -2) return false end
  if MediaTrack~=nil and ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("ShowTrackInputMenu", "MediaTrack", "must be nil or a valid MediaTrack", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowTrackInputMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end
  reaper.ShowPopupMenu("track_input", x, y, HWNDParent, MediaTrack)
  return true
end

--ultraschall.ShowTrackInputMenu(100,200, MediaTrack, HWNDParent)

function ultraschall.ShowTrackPanelMenu(x, y, MediaTrack, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowTrackPanelMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowTrackPanelMenu(integer x, integer y, optional MediaTrack MediaTrack, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a TrackPanel-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional MediaTrack MediaTrack - the MediaTrack, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected one
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, trackpanel</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowTrackPanelMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowTrackPanelMenu", "y", "must be an integer", -2) return false end
  if MediaTrack~=nil and ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("ShowTrackPanelMenu", "MediaTrack", "must be nil or a valid MediaTrack", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowTrackPanelMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end

  reaper.ShowPopupMenu("track_panel", x, y, HWNDParent, MediaTrack)
  return true
end

--ultraschall.ShowTrackPanelMenu(100,200, MediaTrack, HWNDParent)

function ultraschall.ShowTrackAreaMenu(x, y, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowTrackAreaMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowTrackAreaMenu(integer x, integer y, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a TrackArea-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, trackarea</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowTrackAreaMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowTrackAreaMenu", "y", "must be an integer", -2) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowTrackAreaMenu", "HWNDParent", "must be nil or a valid HWND", -3) return false end

  reaper.ShowPopupMenu("track_area", x, y, HWNDParent)
  return true
end

--ultraschall.ShowTrackAreaMenu(100,200, HWNDParent)

function ultraschall.ShowTrackRoutingMenu(x, y, MediaTrack, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowTrackRoutingMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowTrackRoutingMenu(integer x, integer y, optional MediaTrack MediaTrack, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a TrackRouting-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional MediaTrack MediaTrack - the MediaTrack, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected one
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, trackrouting</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowTrackRoutingMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowTrackRoutingMenu", "y", "must be an integer", -2) return false end
  if MediaTrack~=nil and ultraschall.type(MediaTrack)~="MediaTrack" then ultraschall.AddErrorMessage("ShowTrackRoutingMenu", "MediaTrack", "must be nil or a valid MediaTrack", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowTrackRoutingMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end

  reaper.ShowPopupMenu("track_routing", x, y, HWNDParent, MediaTrack)
  return true
end

--ultraschall.ShowTrackRoutingMenu(100,200, reaper.GetTrack(0,0), HWNDParent)


function ultraschall.ShowRulerMenu(x, y, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowRulerMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowRulerMenu(integer x, integer y, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a Ruler-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, ruler</tags>
</US_DocBloc>
--]]
  -- MediaTrack=nil, use selected MediaTrack
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowRulerMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowRulerMenu", "y", "must be an integer", -2) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowRulerMenu", "HWNDParent", "must be nil or a valid HWND", -3) return false end

  reaper.ShowPopupMenu("ruler", x, y, HWNDParent, MediaTrack)
  return true
end

--ultraschall.ShowRulerMenu(100,200, HWNDParent)

function ultraschall.ShowMediaItemMenu(x, y, MediaItem, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowMediaItemMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowMediaItemMenu(integer x, integer y, optional MediaItem MediaItem, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a MediaItem-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional MediaItem MediaItem - the MediaItem, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected one
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, item, mediaitem</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowMediaItemMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowMediaItemMenu", "y", "must be an integer", -2) return false end
  if MediaItem~=nil and ultraschall.type(MediaItem)~="MediaItem" then ultraschall.AddErrorMessage("ShowMediaItemMenu", "MediaItem", "must be nil or a valid MediaItem", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowMediaItemMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end

  reaper.ShowPopupMenu("item", x, y, HWNDParent, MediaItem)
  return true
end

--ultraschall.ShowMediaItemMenu(100,200, reaper.GetMediaItem(0,0), HWNDParent)

function ultraschall.ShowEnvelopeMenu(x, y, TrackEnvelope, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowEnvelopeMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowEnvelopeMenu(integer x, integer y, optional TrackEnvelope TrackEnvelope, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a Track/TakeEnvelope-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    optional TrackEnvelope TrackEnvelope - the TrackEnvelope/TakeEnvelope, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected TrackEnvelope
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, item, track envelope, take envelope</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopeMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopeMenu", "y", "must be an integer", -2) return false end
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("ShowEnvelopeMenu", "TrackEnvelope", "must be nil or a valid TrackEnvelope", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowEnvelopeMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end

-- MediaTrack=nil, use selected MediaTrack
  reaper.ShowPopupMenu("envelope", x, y, HWNDParent, TrackEnvelope)
  return true
end

--ultraschall.ShowEnvelopeMenu(100,200, nil, HWNDParent)

function ultraschall.ShowEnvelopePointMenu(x, y, Pointidx, Trackenvelope, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowEnvelopePointMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowEnvelopePointMenu(integer x, integer y, integer Pointidx, optional TrackEnvelope TrackEnvelope, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a Track/TakeEnvelope-Point-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    integer Pointidx - the envelope-point, which shall be influenced by the context-menu
    optional TrackEnvelope TrackEnvelope - the TrackEnvelope/TakeEnvelope, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected TrackEnvelope
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, item, track envelope, take envelope, envelope point</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "y", "must be an integer", -2) return false end
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "TrackEnvelope", "must be nil or a valid TrackEnvelope", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end
  if math.type(Pointidx)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "Pointidx", "must be an integer", -5) return false end
  if Pointidx<0 then ultraschall.AddErrorMessage("ShowEnvelopePointMenu", "Pointidx", "must be bigger than/equal 0", -6) return false end

  reaper.ShowPopupMenu("envelope_point", x, y, HWNDParent, Trackenvelope, Pointidx, 0)
  return true
end

--ultraschall.ShowEnvelopePointMenu(100,200, nil, 0, HWNDParent)

function ultraschall.ShowEnvelopePointMenu_AutomationItem(x, y, Pointidx, AutomationIDX, Trackenvelope, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowEnvelopePointMenu_AutomationItem</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowEnvelopePointMenu_AutomationItem(integer x, integer y, integer Pointidx, integer AutomationIDX, optional TrackEnvelope TrackEnvelope, optional HWND HWNDParent)</functioncall>
  <description>
    Opens a Track/TakeEnvelope-Point-context menu for AutomationItems
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    integer Pointidx - the envelope-point, which shall be influenced by the context-menu
    integer AutomationIDX - the automation item-id within this Envelope, beginning with 1 for the first
    optional TrackEnvelope TrackEnvelope - the TrackEnvelope/TakeEnvelope, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected TrackEnvelope
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, item, track envelope, take envelope, envelope point, automation item</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "y", "must be an integer", -2) return false end
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "TrackEnvelope", "must be nil or a valid TrackEnvelope", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "HWNDParent", "must be nil or a valid HWND", -4) return false end
  if math.type(Pointidx)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "Pointidx", "must be an integer", -5) return false end
  if Pointidx<0 then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "Pointidx", "must be bigger than/equal 0", -6) return false end
  if math.type(AutomationIDX)~="integer" then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "AutomationIDX", "must be an integer", -7) return false end
  if AutomationIDX<1 then ultraschall.AddErrorMessage("ShowEnvelopePointMenu_AutomationItem", "AutomationIDX", "must be bigger than 0", -8) return false end

  reaper.ShowPopupMenu("envelope_point", x, y, HWNDParent, Trackenvelope, Pointidx, AutomationIDX)
  return true
end

--ultraschall.ShowEnvelopePointMenu_AutomationItem(100,200, nil, 1, 1, HWNDParent)


function ultraschall.ShowAutomationItemMenu(x, y, AutomationIDX, Trackenvelope, HWNDParent)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ShowAutomationItemMenu</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.92
    JS=0.986
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.ShowAutomationItemMenu(integer x, integer y, integer AutomationIDX, optional TrackEnvelope TrackEnvelope, optional HWND HWNDParent)</functioncall>
  <description>
    Opens an AutomationItem-context menu
    
    Returns false in case of error.
  </description>
  <parameters>
    integer x - x position of the context-menu in pixels
    integer y - y position of the context-menu in pixels
    integer AutomationIDX - the automation item-id within this Envelope which shall be influenced by the menu-selection of the opened context-menu, beginning with 1 for the first
    optional TrackEnvelope TrackEnvelope - the TrackEnvelope/TakeEnvelope, which shall be influenced by the menu-selection of the opened context-menu; nil, use the currently selected TrackEnvelope
    optional HWND HWNDParent - a HWND, in which the context-menu shall be shown in; nil, use Reaper's main window
  </parameters>
  <retvals>
    boolean retval - true, opening the menu worked; false, there was an error
  </retvals>
  <chapter_context>
    User Interface
    Menu Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, show, context menu, item, track envelope, take envelope, automation item</tags>
</US_DocBloc>
--]]
  if math.type(x)~="integer" then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "x", "must be an integer", -1) return false end
  if math.type(y)~="integer" then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "y", "must be an integer", -2) return false end
  if TrackEnvelope~=nil and ultraschall.type(TrackEnvelope)~="TrackEnvelope" then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "TrackEnvelope", "must be nil or a valid TrackEnvelope", -3) return false end
  if HWNDParent~=nil and ultraschall.IsValidHWND(HWNDParent)==false then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "HWNDParent", "must be nil or a valid HWND", -4) return false end
  if math.type(AutomationIDX)~="integer" then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "AutomationIDX", "must be an integer", -5) return false end
  if AutomationIDX<1 then ultraschall.AddErrorMessage("ShowAutomationItemMenu", "AutomationIDX", "must be bigger than 0", -6) return false end

  reaper.ShowPopupMenu("envelope_item", x, y, HWNDParent, Trackenvelope, AutomationIDX)
  return true
end

--ultraschall.ShowAutomationItemMenu(100,200, nil, 1, HWNDParent)

function ultraschall.GetSaveProjectAsHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetSaveProjectAsHWND</slug>
  <requires>
    Ultraschall=4.00
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetSaveProjectAsHWND()</functioncall>
  <description>
    returns the HWND of the Save As-dialog, if the window is opened.
    
    returns nil if the Save As-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Save As-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, hwnd, save as, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Save Project", "saveas")
  local subdirectory=reaper.JS_Localize("Create subdirectory for project", "DLG_185")
  local copyallmedia=reaper.JS_Localize("Copy all media into project directory, using:", "DLG_185")
  local convertmedia=reaper.JS_Localize("Convert media", "DLG_185")
  local format=reaper.JS_Localize("Format...", "DLG_185")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                            subdirectory.."\0"..
                                            copyallmedia.."\0"..
                                            convertmedia.."\0"..
                                            format)==true then return hwnd_array[i] end
    end
  end
  return nil
end

function ultraschall.SetHelpDisplayMode(helpcontent, mouseediting)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetHelpDisplayMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetHelpDisplayMode(integer helpcontent, boolean mouseediting)</functioncall>
  <description>
    sets the help-display-mode, as shown in the area beneath the track control panels.
    
    returns false in case of an error
  </description>
  <parameters>
    integer helpcontent - 0, No information display  
                        - 1, Reaper tips  
                        - 2, Track/item count  
                        - 3, selected track/item/envelope details  
                        - 4, CPU/RAM use, time since last save  
    boolean mouseediting - true, show mouse editing-help; false, don't show mouse editing-help
  </parameters>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <chapter_context>
    User Interface
    misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, show, help, helpcontent, mouseediting, tips</tags>
</US_DocBloc>
]]
  if math.type(helpcontent)~="integer" then ultraschall.AddErrorMessage("SetHelpDisplayMode", "mode", "must be an integer", -1) return false end
  if helpcontent<0 or helpcontent>4 then ultraschall.AddErrorMessage("SetHelpDisplayMode", "mode", "must be between 0 and 4", -2) return false end
  if mouseediting==false then helpcontent=helpcontent+65536 end
  if type(mouseediting)~="boolean" then ultraschall.AddErrorMessage("SetHelpDisplayMode", "mouseediting", "must be a boolean", -3) return false end
  return reaper.SNM_SetIntConfigVar("help", helpcontent)
end

function ultraschall.GetHelpDisplayMode()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetHelpDisplayMode</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>integer helpcontent, boolean mouseediting = ultraschall.GetHelpDisplayMode()</functioncall>
  <description>
    gets the current help-display-mode, as shown in the area beneath the track control panels.
  </description>
  <retvals>
    integer helpcontent - 0, No information display  
                        - 1, Reaper tips  
                        - 2, Track/item count  
                        - 3, selected track/item/envelope details  
                        - 4, CPU/RAM use, time since last save  
    boolean mouseediting - true, show mouse editing-help; false, don't show mouse editing-help
  </retvals>
  <chapter_context>
    User Interface
    misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, show, help, helpcontent, mouseediting, tips</tags>
</US_DocBloc>
]]
  local A1,B1=reaper.SNM_GetIntConfigVar("help", -999)
  local mouse_editing=A1&65536~=0
  A1=A1-65536
  return A1, mouse_editing
end

function ultraschall.WiringDiagram_SetOptions(show_send_wires, show_routing_controls, show_hardware_outputs)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WiringDiagram_SetOptions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.WiringDiagram_SetOptions(boolean show_send_wires, boolean show_routing_controls, boolean show_hardware_outputs)</functioncall>
  <description>
    sets the current wiring-display-options
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was not successful
  </retvals>
  <parameters>
    boolean show_send_wires - only show send wires on track mouseover; true, it's set; false, it's unset
    boolean show_routing_controls - show routing controls when creating send/hardware output; true, it's set; false, it's unset
    boolean show_hardware_outputs - only show hardware output/input wires on track mouseover; true, it's set; false, it's unset
  </parameters>
  <chapter_context>
    User Interface
    misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, wiring display, options</tags>
</US_DocBloc>
]]
  local mode=0
  if show_send_wires==true then mode=mode+1 end
  if show_routing_controls==true then mode=mode+8 end
  if show_hardware_outputs==true then mode=mode+16 end
  return reaper.SNM_SetIntConfigVar("wiring_options", mode)
end

function ultraschall.WiringDiagram_GetOptions()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>WiringDiagram_GetOptions</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    SWS=2.10.0.1
    Lua=5.3
  </requires>
  <functioncall>boolean show_send_wires, boolean show_routing_controls, boolean show_hardware_outputs = ultraschall.WiringDiagram_GetOptions()</functioncall>
  <description>
    gets the current wiring-display-options
  </description>
  <retvals>
    boolean show_send_wires - only show send wires on track mouseover; true, it's set; false, it's unset
    boolean show_routing_controls - show routing controls when creating send/hardware output; true, it's set; false, it's unset
    boolean show_hardware_outputs - only show hardware output/input wires on track mouseover; true, it's set; false, it's unset
  </retvals>
  <chapter_context>
    User Interface
    misc
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, wiring display, options</tags>
</US_DocBloc>
]]
  local mode=reaper.SNM_GetIntConfigVar("wiring_options", -99)
  return mode&1==1, mode&8==8, mode&16==16
end

function ultraschall.GetTCPWidth()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTCPWidth</slug>
  <requires>
    Ultraschall=4.00
    Reaper=6.02
    JS=0.998
    Lua=5.3
  </requires>
  <functioncall>integer width = ultraschall.GetTCPWidth()</functioncall>
  <description>
    Returns the current width of the TrackControlPanel.
  </description>
  <retvals>
    integer width - the width of the TCP
  </retvals>
  <chapter_context>
    User Interface
    Track Control Panel(TCP)
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, get, width, tcp, track control panel</tags>
</US_DocBloc>
]]  
  -- gets the hwnd of the help-display-area, which is beneath the TCP,
  -- and has the same width as the TCP. So this is, where we get out
  -- TCP-width from.
  -- Hope the devs will not make position of the helpdisplay customizeable.
  local Retval, Width, Height = reaper.JS_Window_GetClientSize(reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1259))
  return Width
end

--A=ultraschall.GetTCPWidth()

function ultraschall.VideoWindow_FullScreenToggle(toggle)
  --[[
  <US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
    <slug>VideoWindow_FullScreenToggle</slug>
    <requires>
      Ultraschall=4.1
      Reaper=6.05
      Lua=5.3
    </requires>
    <functioncall>boolean fullscreenstate = ultraschall.VideoWindow_FullScreenToggle(optional boolean toggle)</functioncall>
    <description>
      toggles fullscreen-state of Reaper's video-processor-window 
        
      returns nil in case of error
    </description>
    <retvals>
      boolean fullscreenstate - true, video-window is now fullscreen; false, video-window is NOT fullscreen
    </retvals>
    <parameters>
      optional boolean toggle - true, sets video-window to fullscreen; false, sets video-window to windowed; nil, toggle between fullscreen and nonfullscreen states
    </parameters>
    <chapter_context>
      User Interface
      Window Management
    </chapter_context>
    <target_document>US_Api_Functions</target_document>
    <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
    <tags>user interface, set, video window, fullscreen, windowed</tags>
  </US_DocBloc>
  --]]
  local Hwnd = ultraschall.GetVideoHWND()
  if Hwnd==nil then ultraschall.AddErrorMessage("VideoWindow_FullScreenToggle", "", "Video window not opened", -1) return end
  if toggle~=nil and type(toggle)~="boolean" then ultraschall.AddErrorMessage("VideoWindow_FullScreenToggle", "toggle", "must be a boolean or nil", -2) return end
  local CurState=ultraschall.GetUSExternalState("reaper_video", "fullscreen", "reaper.ini")=="1"
  if toggle==nil or toggle~=CurState then
    reaper.JS_WindowMessage_Send(Hwnd, "WM_LBUTTONDBLCLK", 1,1,0,0)
  end
  if toggle==nil then toggle=CurState==false end
  return toggle
end


function ultraschall.PreventUIRefresh()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>PreventUIRefresh</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer current_preventcount = ultraschall.PreventUIRefresh()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    like Reaper's own PreventUIRefresh, it allows you to prevent redrawing of the userinterface.
    
    Unlike Reaper's own PreventUIRefresh, this will manage the preventcount itself.
    
    this will not take into account usage of Reaper's own PreventUIRefresh, so you should use either
    
    To reallow refreshing of the UI, use [RestoreUIRefresh](#RestoreUIRefresh).
  </description>
  <retvals>
    integer current_preventcount - the number of times PreventUIRefresh has been called since scriptstart
  </retvals>
  <chapter_context>
    User Interface
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>user interface, prevent, ui, refresh</tags>
</US_DocBloc>
--]]
  if ultraschall.PreventUIRefresh_Value==nil then ultraschall.PreventUIRefresh_Value=0 end
  ultraschall.PreventUIRefresh_Value=ultraschall.PreventUIRefresh_Value+1
  reaper.PreventUIRefresh(1)
  return ultraschall.PreventUIRefresh_Value
end

function ultraschall.RestoreUIRefresh(full)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>RestoreUIRefresh</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer current_preventcount = ultraschall.RestoreUIRefresh(optional boolean full)</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    This reallows UI-refresh, after you've prevented it using [PreventUIRefresh](#PreventUIRefresh).
    
    If you set parameter full=true, it will reset all PreventUIRefresh-calls since scriptstart at once, otherwise you need to call this
    as often until the returnvalue current_preventcount equals 0.
    
    To get the remaining UI-refreshes to be restored, use [GetPreventUIRefreshCount](#GetPreventUIRefreshCount)
    
    If no UIRefreshes are available anymore, calling this function has no effect.
  </description>
  <retvals>
    integer current_preventcount - the remaining number of times PreventUIRefresh has been called since scriptstart
  </retvals>
  <parameters>
    optional boolean full - true, restores UIRefresh fully, no matter, how often PreventUIRefresh has been called before; false or nil, just reset one single call to PreventUIRefresh
  </parameters>
  <chapter_context>
    User Interface
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>user interface, restore, ui, refresh</tags>
</US_DocBloc>
--]]
  if full==true then 
    reaper.PreventUIRefresh(-ultraschall.PreventUIRefresh_Value)   
    ultraschall.PreventUIRefresh_Value=0
  else
    if ultraschall.PreventUIRefresh_Value>0 then 
      reaper.PreventUIRefresh(-1)
      ultraschall.PreventUIRefresh_Value=ultraschall.PreventUIRefresh_Value-1
    end
  end
  return ultraschall.PreventUIRefresh_Value
end

--A=ultraschall.PreventUIRefresh()
--B=ultraschall.RestoreUIRefresh(full)

function ultraschall.GetPreventUIRefreshCount()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetPreventUIRefreshCount</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.40
    Lua=5.3
  </requires>
  <functioncall>integer current_preventcount = ultraschall.GetPreventUIRefreshCount()</functioncall>
  <description markup_type="markdown" markup_version="1.0.1" indent="default">
    This returns the number of times [PreventUIRefresh](#PreventUIRefresh) has been called since scriptstart, minus possible restored UI refreshes.
    
    Use [RestoreUIRefresh](#RestoreUIRefresh) to restore UI-refresh 
  </description>
  <retvals>
    integer current_preventcount - the remaining number of times PreventUIRefresh has been called since scriptstart
  </retvals>
  <chapter_context>
    User Interface
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_Muting_Module.lua</source_document>
  <tags>user interface, get, remaining, ui, refresh</tags>
</US_DocBloc>
--]]
  if ultraschall.PreventUIRefresh_Value==nil then ultraschall.PreventUIRefresh_Value=0 end
  return ultraschall.PreventUIRefresh_Value
end


function ultraschall.SetItemButtonsVisible(Volume, Locked, Mute, Notes, PooledMidi, GroupedItems, PerTakeFX, Properties, AutomationEnvelopes, hide_when_take_less_than_px)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetItemButtonsVisible</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.10
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetItemButtonsVisible(optional boolean Volume, optional integer Locked, optional integer Mute, optional integer Notes, optional boolean PooledMidi, optional boolean GroupedItems, optional integer PerTakeFX, optional integer Properties, optional integer AutomationEnvelopes, optional integer hide_when_take_less_than_px)</functioncall>
  <description>
    allows setting, which item-buttons shall be shown
  
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting button was successful; false, buttons couldn't be set
  </retvals>
  <parameters>
    optional boolean Volume - true, show the volume knob; false, don't show the volume knob; nil, keep current setting
    optional integer Locked - sets state of locked/unlocked button
                            - nil, keep current state
                            - 0, don't show lockstate button
                            - 1, show locked button only
                            - 2, show unlocked button only
                            - 3, show locked and unlocked button
    optional integer Mute - sets state of mute/unmuted button
                            - nil, keep current state
                            - 0, don't show mute button
                            - 1, show mute button only
                            - 2, show unmuted button only
                            - 3, show muted and unmuted button
    optional integer Notes - sets state of itemnotes-button
                            - nil, keep current state
                            - 0, don't show item-note button
                            - 1, show itemnote existing-button only
                            - 2, show no itemnote existing-button only
                            - 3, show itemnote existing and no itemnote existing-button
    optional boolean PooledMidi - true, show the pooled midi-button; false, don't show the pooled midi-button; nil, keep current setting
    optional boolean GroupedItems - true, show the grouped item-button; false, don't show the grouped item-button; nil, keep current setting
    optional integer PerTakeFX - sets state of take fx-button
                            - nil, keep current state
                            - 0, don't show take-fx button
                            - 1, show active take fx-button only
                            - 2, show non active take fx-button only
                            - 3, show active and nonactive take fx-button
    optional integer Properties - show properties-button
                                - nil, keep current state
                                - 0, don't show item properties-button
                                - 1, show item properties-button
                                - 2, show item properties-button only if resampled media
    optional integer AutomationEnvelopes - sets state of envelope-button
                                        - nil, keep current state
                                        - 0, don't show envelope-button
                                        - 1, show active envelope-button only
                                        - 2, show non active envelope-button only
                                        - 3, show active and nonactive envelope-button
    optional integer hide_when_take_less_than_px - the value to hide when take is less than x pixels; 0 to 2147483647
  </parameters>
  <chapter_context>
    User Interface
    MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, set, media items, show, buttons</tags>
</US_DocBloc>
--]]
  if Volume~=nil and type(Volume)~="boolean" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "Volume", "must be nil or a boolean" , -1) return false end
  if Locked~=nil and math.type(Locked)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "Locked", "must be nil or an integer" , -2) return false end
  if Mute~=nil and math.type(Mute)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "Mute", "must be nil or an integer" , -3) return false end
  if Notes~=nil and math.type(Notes)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "Notes", "must be nil or an integer" , -4) return false end
  
  if PooledMidi~=nil and type(PooledMidi)~="boolean" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "PooledMidi", "must be nil or a boolean" , -5) return false end
  if GroupedItems~=nil and type(GroupedItems)~="boolean" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "GroupedItems", "must be nil or a boolean" , -6) return false end
  if PerTakeFX~=nil and math.type(PerTakeFX)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "PerTakeFX", "must be nil or an integer" , -7) return false end
  if Properties~=nil and math.type(Properties)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "Properties", "must be nil or an integer" , -8) return false end
  if AutomationEnvelopes~=nil and math.type(AutomationEnvelopes)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "AutomationEnvelopes", "must be nil or an integer" , -9) return false end
  if hide_when_take_less_than_px~=nil and math.type(hide_when_take_less_than_px)~="integer" then ultraschall.AddErrorMessage("SetItemButtonsVisible", "hide_when_take_less_than_px", "must be nil or an integer" , -10) return false end

  local State = reaper.SNM_GetIntConfigVar("itemicons", -99)
  if Locked~=nil then
    if Locked&1==0 and State&1~=0 then State=State-1 elseif Locked&1~=0 and State&1==0 then State=State+1 end
    if Locked&2==0 and State&2~=0 then State=State-2 elseif Locked&2~=0 and State&2==0 then State=State+2 end
  end

  if PerTakeFX~=nil then
    if PerTakeFX&1==0 and State&4~=0 then State=State-4 elseif PerTakeFX&1~=0 and State&4==0 then State=State+4 end
    if PerTakeFX&2==0 and State&8~=0 then State=State-8 elseif PerTakeFX&2~=0 and State&8==0 then State=State+8 end
  end

  if Mute~=nil then
    if Mute&1==0 and State&16~=0 then State=State-16 elseif Mute&1~=0 and State&16==0 then State=State+16 end
    if Mute&2==0 and State&32~=0 then State=State-32 elseif Mute&2~=0 and State&32==0 then State=State+32 end
  end
  
  if Notes~=nil then
    if Notes&1==0 and State&64~=0 then  State=State-64  elseif Notes&1~=0 and State&64 ==0 then State=State+64  end
    if Notes&2==0 and State&128~=0 then State=State-128 elseif Notes&2~=0 and State&128==0 then State=State+128 end
  end  
  
  if GroupedItems~=nil then
    if GroupedItems==false and State&256~=0 then  State=State-256  elseif GroupedItems==true and State&256==0 then State=State+256  end
  end  

  if Properties~=nil then
    if State&2048 == 2048 then State=State-2048 end
    if State&4096 == 4096 then State=State-4096 end
    if Properties==1 then State=State+2048
    elseif Properties==0 then State=State+4096
    end
  end
  
  if PooledMidi~=nil then
    if PooledMidi==true and State&8192~=0 then  State=State-8192  elseif PooledMidi==false and State&8192==0 then State=State+8192 end
  end  

  if Volume~=nil then
    if Volume==false and State&16384~=0 then  State=State-16384  elseif Volume==true and State&16384==0 then State=State+16384 end
  end  

  if AutomationEnvelopes~=nil then
    if AutomationEnvelopes&1==1 and State&262144~=0 then State=State-262144 elseif AutomationEnvelopes&1~=1 and State&262144==0 then State=State+262144 end
    if AutomationEnvelopes&2==0 and State&524288~=0 then State=State+524288 elseif AutomationEnvelopes&2~=0 and State&524288==0 then State=State-524288 end
  end  
  
  if hide_when_take_less_than_px~=nil then
    reaper.SNM_SetIntConfigVar("itemicons_minheight", hide_when_take_less_than_px)
  end
  reaper.SNM_SetIntConfigVar("itemicons", State)
  reaper.UpdateArrange()
  return true
end

function ultraschall.GetItemButtonsVisible()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetItemButtonsVisible</slug>
  <requires>
    Ultraschall=4.5
    Reaper=6.10
    SWS=2.9.7
    Lua=5.3
  </requires>
  <functioncall>boolean Volume, integer Locked, integer Mute, integer Notes, boolean PooledMidi, boolean GroupedItems, integer PerTakeFX, integer Properties, integer AutomationEnvelopes, integer hide_when_take_less_than_px = ultraschall.GetItemButtonsVisible()</functioncall>
  <description>
    gets, which item-buttons are be shown
  </description>
  <retvals>
    boolean Volume - true, shows the volume knob; false, doesn't show the volume knob
    integer Locked - gets visibility-state of locked/unlocked button
                            - 0, doesn't show lockstate button
                            - 1, shows locked button only
                            - 2, shows unlocked button only
                            - 3, shows locked and unlocked button
    integer Mute - gets visibility-state of mute/unmuted button
                            - 0, doesn't show mute button
                            - 1, shows mute button only
                            - 2, shows unmuted button only
                            - 3, shows muted and unmuted button
    integer Notes - gets visibility-state of itemnotes-button
                            - 0, doesn't show item-note button
                            - 1, shows itemnote existing-button only
                            - 2, shows no itemnote existing-button only
                            - 3, shows itemnote existing and no itemnote existing-button
    boolean PooledMidi - true, shows the pooled midi-button; false, don't show the pooled midi-button
    boolean GroupedItems - true, shows the grouped item-button; false, don't show the grouped item-button
    integer PerTakeFX - gets visibility-state of take fx-button
                            - 0, doesn't show take-fx button
                            - 1, shows active take fx-button only
                            - 2, shows non active take fx-button only
                            - 3, shows active and nonactive take fx-button
    integer Properties - gets visibility-state of properties-button
                                - 0, doesn't show item properties-button
                                - 1, shows item properties-button
                                - 2, shows item properties-button only if resampled media
    integer AutomationEnvelopes - gets visibility-state of envelope-button
                                        - 0, doesn't show envelope-button
                                        - 1, shows active envelope-button only
                                        - 2, shows non active envelope-button only
                                        - 3, shows active and nonactive envelope-button
    integer hide_when_take_less_than_px - the value to hide when take is less than x pixels; 0 to 2147483647
  </retvals>
  <chapter_context>
    User Interface
    MediaItems
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_engine.lua</source_document>
  <tags>user interface, media items, get, show, buttons</tags>
</US_DocBloc>
--]]
  local State = reaper.SNM_GetIntConfigVar("itemicons", -99)
  local State2 = reaper.SNM_GetIntConfigVar("itemicons_minheight", -99)
  
  local Volume, Locked, Mute, Notes, PooledMidi, GroupedItems, PerTakeFX, Properties, AutomationEnvelopes=false,0,0,0,false,false,0,0,0
  if State&1~=0 then Locked=Locked+1 end
  if State&2~=0 then Locked=Locked+2 end
  
  if State&4~=0 then PerTakeFX=PerTakeFX+1 end
  if State&8~=0 then PerTakeFX=PerTakeFX+2 end
  
  if State&16~=0 then Mute=Mute+1 end
  if State&32~=0 then Mute=Mute+2 end
  
  if State&64 ~=0 then Notes=Notes+1 end
  if State&128~=0 then Notes=Notes+2 end
  
  GroupedItems=State&256~=0
  
  if State&2048~=0 then Properties=Properties+1 
  elseif State&4096==0 then Properties=Properties+2 end
  
  PooledMidi=State&8192==0
  
  Volume=State&16384==0
  
  if State&262144==0 then AutomationEnvelopes=AutomationEnvelopes+1 end
  if State&524288~=0 then AutomationEnvelopes=AutomationEnvelopes+2 end  
  
  return Volume, Locked, Mute, Notes, PooledMidi, GroupedItems, PerTakeFX, Properties, AutomationEnvelopes
end

function ultraschall.TCP_SetWidth(width)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>TCP_SetWidth</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.TCP_SetWidth(integer width)</functioncall>
  <description>
    allows setting the width of the tcp.
    
    returns false in case of an error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    integer width - the new width of the tcp in pixels; 0 and higher
  </parameters>
  <chapter_context>
    User Interface
    Track Control Panel(TCP)
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>userinterface, set, width, tcp, track control panel</tags>
</US_DocBloc>
]]
  -- initial code by amagalma
  if ultraschall.type(width)~="number: integer" then ultraschall.AddErrorMessage("TCP_SetWidth", "width", "must be an integer", -1) return false end
  if width<0 then ultraschall.AddErrorMessage("TCP_SetWidth", "width", "must be bigger or equal 0", -2) return false end

  local main = reaper.GetMainHwnd()
  local _, _, tcp_hwnd, tracklist = ultraschall.GetHWND_ArrangeViewAndTimeLine()
  local x,y = 0,0 
  local _, _, _, av_r = reaper.JS_Window_GetRect(tracklist) 
  
  local _, main_x = reaper.JS_Window_GetRect(main) 
  local _, tcp_x, tcp_y, tcp_r = reaper.JS_Window_GetRect(tcp_hwnd) 

  if tcp_r < av_r then
    x,y = reaper.JS_Window_ScreenToClient(main, tcp_x+(tcp_r-tcp_x)+2, tcp_y)
    reaper.JS_WindowMessage_Send(main, "WM_LBUTTONDOWN", 1, 0, x, y) -- mouse down message at splitter location
    reaper.JS_WindowMessage_Send(main, "WM_LBUTTONUP", 0, 0, (tcp_x+width)-main_x-2, y) -- set width, mouse up message
  else -- ' TCP is on right side
    x,y = reaper.JS_Window_ScreenToClient(main, tcp_x-5, tcp_y)
    reaper.JS_WindowMessage_Send(main, "WM_LBUTTONDOWN", 1, 0, x, y)
    reaper.JS_WindowMessage_Send(main, "WM_LBUTTONUP", 0, 0, (tcp_r-width)-main_x-8, y)
  end 
  return true
end

--ultraschall.TCP_SetWidth(300)

function ultraschall.GetTrackManagerHWND()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetTrackManagerHWND</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND hwnd = ultraschall.GetTrackManagerHWND()</functioncall>
  <description>
    returns the HWND of the Track Manager-dialog, if the window is opened.
    
    returns nil if Track Manager-dialog is closed
  </description>
  <retvals>
    HWND hwnd - the window-handler of the Track Manager-dialog
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, track manager, hwnd, get</tags>
</US_DocBloc>
--]]
  local translation=reaper.JS_Localize("Track Manager", "common")
 
  local selection=reaper.JS_Localize("Set selection from:", "DLG_469")
  local show_all=reaper.JS_Localize("Show all", "DLG_469")
  local mcp=reaper.JS_Localize("MCP", "trackmgr")
  
  local count_hwnds, hwnd_array, hwnd_adresses = ultraschall.Windows_Find(translation, true)
  if count_hwnds==0 then return nil
  else
    for i=count_hwnds, 1, -1 do
      if ultraschall.HasHWNDChildWindowNames(hwnd_array[i], 
                                           selection,
                                           show_all,
                                           mcp)==true then return hwnd_array[i] end
    end
  end
  return nil
end

function ultraschall.SetTimeUnit(transport_unit, ruler_unit, ruler_unit2)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetTimeUnit</slug>
  <requires>
    Ultraschall=4.1
    Reaper=6.02
    Lua=5.3
  </requires>
  <functioncall>boolan retval = ultraschall.SetTimeUnit(optional integer transport_unit, optional integer ruler_unit, optional integer ruler_unit2)</functioncall>
  <description>
    Sets the time-unit for transport, ruler and secondary ruler
    
    returns false in case of error
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    optional integer transport_unit - the unit for the transport
                                    - nil, keep current
                                    - 0, seconds
                                    - 1, samples
                                    - 2, Minutes:Seconds
                                    - 3, Measures.Beats/minutes:Seconds
                                    - 4, Measures.Beats
                                    - 5, Hours:Minutes:Seconds:Frames
                                    - 6, Absolute frames
    optional integer ruler_unit - the unit for the ruler
                                - nil, keep current
                                - 0, seconds
                                - 1, samples
                                - 2, Minutes:Seconds
                                - 3, Measures.Beats/minutes:Seconds
                                - 4, Measures.Beats
                                - 5, Hours:Minutes:Seconds:Frames
                                - 6, Absolute frames
                                - 7, Measures.Beats(minimal)/minutes:Seconds
                                - 8, Measures.Beats(minimal)
    optional integer ruler_unit2 - the unit for the secondary ruler
                                 - nil, keep current
                                 - 0, seconds
                                 - 1, samples
                                 - 2, Minutes:Seconds
                                 - 3, Hours:Minutes:Seconds:Frames
                                 - 4, Absolute frames
                                 - 5, None
  </parameters>
  <chapter_context>
    User Interface
    Transport and Ruler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, transport, ruler, set, time unit</tags>
</US_DocBloc>
]]
  if transport_unit~=nil and ultraschall.type(transport_unit)~="number: integer" then ultraschall.AddErrorMessage("SetTimeUnit", "transport_unit", "must be an integer", -1) return false end
  if transport_unit~=nil then
    if transport_unit<0 or transport_unit>6 then 
      ultraschall.AddErrorMessage("SetTimeUnit", "transport_unit", "must be between 0 and 6", -2) 
      return false 
    end
  end
  if ruler_unit~=nil and ultraschall.type(ruler_unit)~="number: integer" then ultraschall.AddErrorMessage("SetTimeUnit", "ruler_unit", "must be an integer", -3) return false end
  if ruler_unit~=nil then
    if ruler_unit<0 or ruler_unit>8 then 
      ultraschall.AddErrorMessage("SetTimeUnit", "ruler_unit", "must be between 0 and 8", -4)
      return false 
    end
  end
  if ruler_unit2~=nil and ultraschall.type(ruler_unit2)~="number: integer" then ultraschall.AddErrorMessage("SetTimeUnit", "ruler_unit2", "must be an integer", -5) return false end
  if ruler_unit2~=nil then
    if ruler_unit2<0 or ruler_unit2>5 then 
      ultraschall.AddErrorMessage("SetTimeUnit", "ruler_unit2", "must be between 0 and 8", -6)
      return false 
    end
  end
  if     transport_unit==0 then cmdid=40412 -- seconds
  elseif transport_unit==1 then cmdid=40413 -- samples
  elseif transport_unit==2 then cmdid=40410 -- Minutes:Seconds
  elseif transport_unit==3 then cmdid=40534 -- Measures.Beats/minutes:Seconds
  elseif transport_unit==4 then cmdid=40411 -- Measures.Beats
  elseif transport_unit==5 then cmdid=40414 -- Hours:Minutes:Seconds:Frames
  elseif transport_unit==6 then cmdid=41972 -- Absolute frames
  end
  if transport_unit~=nil then reaper.Main_OnCommand(cmdid, 0) end

  if     ruler_unit==0 then cmdid=40368 -- seconds
  elseif ruler_unit==1 then cmdid=40369 -- samples
  elseif ruler_unit==2 then cmdid=40365 -- Minutes:Seconds
  elseif ruler_unit==3 then cmdid=40366 -- Measures.Beats/minutes:Seconds
  elseif ruler_unit==4 then cmdid=40367 -- Measures.Beats
  elseif ruler_unit==5 then cmdid=40370 -- Hours:Minutes:Seconds:Frames
  elseif ruler_unit==6 then cmdid=41973 -- Absolute frames
  elseif ruler_unit==7 then cmdid=41918 -- Measures.Beats(minimal)/minutes:Seconds
  elseif ruler_unit==8 then cmdid=41916 -- Measures.Beats(minimal)
  end
  if ruler_unit~=nil then reaper.Main_OnCommand(cmdid, 0) end
  
  if     ruler_unit2==0 then cmdid=42362 -- seconds
  elseif ruler_unit2==1 then cmdid=42363 -- samples
  elseif ruler_unit2==2 then cmdid=42361 -- Minutes:Seconds
  elseif ruler_unit2==3 then cmdid=42364 -- Hours:Minutes:Seconds:Frames
  elseif ruler_unit2==4 then cmdid=42365 -- Absolute frames
  elseif ruler_unit2==5 then cmdid=42360 -- None
  end
  if ruler_unit2~=nil then reaper.Main_OnCommand(cmdid, 0) end
  
  return true
end

function ultraschall.ReturnAllChildHWND(hwnd)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>ReturnAllChildHWND</slug>
  <requires>
    Ultraschall=4.1
    Reaper=5.965
    JS=0.962
    Lua=5.3
  </requires>
  <functioncall>integer count_of_hwnds, table hwnds = ultraschall.ReturnAllChildHWND(HWND hwnd)</functioncall>
  <description>
    Returns all child-window-handler of hwnd.
    
    Returns -1 in case of an error
  </description>
  <retvals>
    integer count_of_hwnds - the number of found child-window-handler
    table hwnds - the found child-window-handler of hwnd
  </retvals>
  <parameters>
    HWND hwnd - the HWND-handler to check for
  </parameters>
  <chapter_context>
    User Interface
    Window Management
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>window, hwnd, get, all, child</tags>
</US_DocBloc>
]]
  if ultraschall.IsValidHWND(hwnd)==false then ultraschall.AddErrorMessage("ReturnAllChildHWND", "hwnd", "must be a valid hwnd", -1) return -1 end
  local Aretval, Alist = reaper.JS_Window_ListAllChild(hwnd)
  local HWND={}
  local count=0
  for k in string.gmatch(Alist..",", "(.-),") do
    count=count+1
    HWND[count]=reaper.JS_Window_HandleFromAddress(k)
  end
  return count, HWND
end

function ultraschall.SetUIScale(scaling)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>SetUIScale</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.17
    Lua=5.3
  </requires>
  <functioncall>boolean retval = ultraschall.SetUIScale(number scaling)</functioncall>
  <description>
    Sets the UI-scaling of Reaper's UI.
    
    Works only, if the "Scale UI elements of track/mixer panels, tansport, etc, by:"-checkbox is enabled in Preferences -> General -> Advanced UI/system tweaks-dialog, 
    by setting the value in the dialog to anything else than 1.0.
    
    returns false in case of an error.
  </description>
  <retvals>
    boolean retval - true, setting was successful; false, setting was unsuccessful
  </retvals>
  <parameters>
    number scaling - the scaling-factor; safe range is between 0.30 and 3.00, though higher is supported
  </parameters>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, uiscaling, set</tags>
</US_DocBloc>
--]]
  if type(scaling)~="number" then ultraschall.AddErrorMessage("SetUIScale", "scaling", "must be a number", -1) return false end
  if scaling<0 then ultraschall.AddErrorMessage("SetUIScale", "scaling", "must be 0 or higher", -2) return false end
  local B,BB=reaper.BR_Win32_GetPrivateProfileString("REAPER", "uiscale", "", reaper.get_ini_file())
  if BB=="1.00000000" then ultraschall.AddErrorMessage("SetUIScale", "", "Works only, if the \n\n   \"Scale UI elements of track/mixer panels, tansport, etc, by:\"-checkbox \n\nis enabled in \n\n    Preferences -> General -> Advanced UI/system tweaks-dialog,\n\n by setting the value in the dialog to anything else than 1.0.", -3) return false end
  return reaper.SNM_SetDoubleConfigVar("uiscale", scaling)
end

--B=ultraschall.SetUIScale(1)

function ultraschall.GetUIScale()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetUIScale</slug>
  <requires>
    Ultraschall=4.2
    Reaper=6.17
    Lua=5.3
  </requires>
  <functioncall>number uiscale = ultraschall.GetUIScale()</functioncall>
  <description>
    Gets the current UI-scaling of Reaper's UI.
    
    returns false in case of an error.
  </description>
  <retvals>
    number uiscale - the current scaling-factor of Reaper's UI
  </retvals>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, uiscaling, get</tags>
</US_DocBloc>
--]]
  return reaper.SNM_GetDoubleConfigVar("uiscale", -1)
end

function ultraschall.GetHWND_Transport()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetHWND_Transport</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.965
    SWS=2.10.0.1
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>integer transport_position, boolean floating, boolean hidden, HWND transport_hwnd, integer x, integer y, integer right, integer bottom = ultraschall.GetHWND_Transport()</functioncall>
  <description>
    returns the HWND of the Transport-area and its visible position/docking-state
  </description>
  <retvals>
    integer transport_position - the position of the transport-area
                               - -1, transport is docked in docker
                               - 1, transport is top of main
                               - 2, transport is at the bottom
                               - 3, transport is above the ruler
                               - 4, transport is below arrange
    boolean floating - true, transport is floating; false, transport is docked in main-window or docker
    boolean hidden - true, transport is hidden(its hwnd might still be available); false, transport is visible
    HWND transport_hwnd - the window-handler of transport
    integer x - x-position of transport in pixels
    integer y - y-position of transport in pixels
    integer right - right position of transport in pixels
    integer bottom - bottom position of transport in pixels
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, transport, position, docking-state, hwnd, get</tags>
</US_DocBloc>
--]]
  local transport=reaper.JS_Localize("Transport", "DLG_188")
  local status=reaper.JS_Localize("status", "DLG_188")
  local HWND=reaper.GetMainHwnd()
  local transport_position
  if reaper.GetToggleCommandState(41608)==1 then
    transport_position=-1 -- docker
  elseif reaper.GetToggleCommandState(41606)==1 then
    transport_position=1 -- top of main
  elseif reaper.GetToggleCommandState(41605)==1 then
    transport_position=2 -- bottom of main
  elseif reaper.GetToggleCommandState(41604)==1 then
    transport_position=3 -- above ruler of main
  elseif reaper.GetToggleCommandState(41603)==1 then
    transport_position=4 -- below arrange of main
  end
  local floating=false
  local Transport=reaper.JS_Window_FindChild(HWND, transport, true)
  if Transport==nil then
    Transport=reaper.JS_Window_Find(transport, true)
    transport_position=-1
    floating=true
  end
  local retval,x,y,w,h
  if ultraschall.HasHWNDChildWindowNames(Transport, status)==true then
    retval,x,y,w,h = reaper.JS_Window_GetRect(Transport)
  end
  
  local retval, hidden = reaper.BR_Win32_GetPrivateProfileString("REAPER", "transport_vis", "", reaper.get_ini_file())
  
  if tonumber(hidden)==0 then 
    hidden=true 
  else 
    hidden=false
  end
  
  return transport_position, floating, hidden, Transport, x, y, w, h
end


function ultraschall.GetHWND_TCP()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetHWND_TCP</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND tcp_hwnd, boolean tcp_right, integer x, integer y, integer right, integer bottom = ultraschall.GetHWND_TCP()</functioncall>
  <description>
    returns the HWND of the TrackControlPanel and its visible area including right or left of arrange-view
  </description>
  <retvals>
    HWND tcp_hwnd - the window-handler of tcp
    boolean tcp_right - true, tcp is on right side of arrange view; false, tcp is on left side of the arrange view
    integer x - x-position of tcp in pixels
    integer y - y-position of tcp in pixels
    integer right - right position of tcp in pixels
    integer bottom - bottom position of tcp in pixels
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, tcp, track control panel, is right, position, hwnd, get</tags>
</US_DocBloc>
--]]
  local arrange_view, timeline, TrackControlPanel, TrackListWindow = ultraschall.GetHWND_ArrangeViewAndTimeLine()
  local tcp_right=reaper.GetToggleCommandState(42373)==1
  local retval, x2, y2, w2, h2 = reaper.JS_Window_GetClientRect(TrackControlPanel)
  return TrackControlPanel, tcp_right, x2, y2, w2, h2
end

function ultraschall.GetHWND_ArrangeView()
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetHWND_ArrangeView</slug>
  <requires>
    Ultraschall=4.6
    Reaper=5.965
    JS=0.963
    Lua=5.3
  </requires>
  <functioncall>HWND arrange_view_hwnd, integer x, integer y, integer right, integer bottom = ultraschall.GetHWND_ArrangeView()</functioncall>
  <description>
    returns the HWND of the ArrangeView and its visible area
  </description>
  <retvals>
    HWND arrange_view_hwnd - the window-handler of arrange-view
    integer x - x-position of arrange-view in pixels
    integer y - y-position of arrange-view in pixels
    integer right - right position of arrange-view in pixels
    integer bottom - bottom position of arrange-view in pixels
  </retvals>
  <chapter_context>
    User Interface
    Reaper-Windowhandler
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>user interface, window, arrange-view, position, hwnd, get</tags>
</US_DocBloc>
--]]
  local Hwnd=reaper.GetMainHwnd()
  local arrange=reaper.JS_Window_FindChildByID(Hwnd, 1000)
  local retval, x2, y2, w2, h2 = reaper.JS_Window_GetClientRect(arrange)
  return arrange, x2, y2, w2, h2
end

function ultraschall.GetScaleRangeFromDpi(dpi)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetScaleRangeFromDpi</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>number minimum_scale_for_dpi, number maximum_scale_for_dpi = ultraschall.GetScaleRangeFromDpi(integer dpi)</functioncall>
  <description>
    Returns the scale-range for a specific dpi between 0 and 1539 dpi.
    
    Can be used to find out, which scale a gui-script needs to use when a specific dpi-value is present in Reaper's UI.
    
    Note: each dpi represents a minimum/maximum range of a scaling factor. So every scaling-factor within that range is part of a specific dpi!
    
    Returns nil in case of an error
  </description>
  <retvals>
    number minimum_scale_for_dpi - the minimum scale-value for this dpi-value
    number maximum_scale_for_dpi - the maximum scale-value for this dpi-value
  </retvals>
  <parameters>
    integer dpi - the dpi-value to convert into its scale-range-representation; 0-1539 dpi
  </parameters>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>helper functions, get, convert, dpi, scale, scale range</tags>
</US_DocBloc>
]]
  if math.type(dpi)~="integer" then ultraschall.AddErrorMessage("GetScaleRangeFromDpi", "dpi", "must be an integer", -1) return end
  if dpi<0 or dpi>1539 then ultraschall.AddErrorMessage("GetScaleRangeFromDpi", "dpi", "must be between 0 and 1540", -2) return end
  local val=0.001
  local val2=0.001
  local _
  if ultraschall.LastUsedDPI~=dpi then
    _, val = ultraschall.GetIniFileValue("DPI", tostring(dpi), "", ultraschall.Api_Path.."/IniFiles/dpi2scale.ini")
    _, val2=ultraschall.GetIniFileValue("DPI", tostring(dpi+1), "", ultraschall.Api_Path.."/IniFiles/dpi2scale.ini")
    --if tonumber(val2)==nil then print2(dpi, dpi+1) end
    val2=tonumber(val2)-0.001
    
    ultraschall.LastUsedDPI=dpi
    ultraschall.LastusedScaleRange1=val
    ultraschall.LastusedScaleRange2=val2
  else
    val=ultraschall.LastusedScaleRange1
    val2=ultraschall.LastusedScaleRange2
  end
  
  return tonumber(val), tonumber(val2)
end

function ultraschall.GetDpiFromScale(scale)
--[[
<US_DocBloc version="1.0" spok_lang="en" prog_lang="*">
  <slug>GetDpiFromScale</slug>
  <requires>
    Ultraschall=4.7
    Reaper=5.965
    Lua=5.3
  </requires>
  <functioncall>integer dpi = ultraschall.GetScaleRangeFromDpi(number scale)</functioncall>
  <description>
    Returns the dpi for a specific scale, between 0.001 and 6.000.
    
    Note: each dpi represents a minimum/maximum range of a scaling factor. So every scaling-factor within that range is part of a specific dpi!
    
    Returns nil in case of an error
  </description>
  <retvals>
    integer dpi - the dpi-value to convert into its scale-range-representation; 0-1539 dpi
  </retvals>
  <parameters>
    number scale - the scale-value to convert into its dpi-representation; 0.001 to 6.000 is supported
  </parameters>
  <chapter_context>
    User Interface
    Miscellaneous
  </chapter_context>
  <target_document>US_Api_Functions</target_document>
  <source_document>Modules/ultraschall_functions_ReaperUserInterface_Module.lua</source_document>
  <tags>helper functions, get, convert, dpi, scale</tags>
</US_DocBloc>
]]
  if type(scale)~="number" then ultraschall.AddErrorMessage("GetDpiFromScale", "scale", "must be a number", -1) return end
  if scale<0.001 or scale>6 then ultraschall.AddErrorMessage("GetDpiFromScale", "scale", "must be between 0.001 and 6", -2) return end
  local start=0
  if scale<0.2 then start=0
  elseif scale>=0.2 then start=51
  elseif scale>=0.4 then start=102
  elseif scale>=0.6 then start=153
  elseif scale>=0.8 then start=204
  elseif scale>=1 then start=256
  elseif scale>=1.2 then start=307
  elseif scale>=1.4 then start=358
  elseif scale>=1.6 then start=409
  elseif scale>=1.8 then start=461
  elseif scale>=2 then start=512
  elseif scale>=2.2 then start=506
  elseif scale>=2.4 then start=614
  elseif scale>=2.6 then start=666
  elseif scale>=2.8 then start=717
  elseif scale>=3 then start=768
  elseif scale>=5 then start=1024
  end
  
  local dpi, scale_in, scale_out
  local oldval=0.001
  if ultraschall.LastUsedScale~=scale then
    for i=start, 1539 do
      scale_in, scale_out = ultraschall.GetScaleRangeFromDpi(i)
      if scale>=scale_in-0.001 and scale<=scale_out+.001 then
        ultraschall.LastUsedScale=scale
        ultraschall.LastUsedScaleDPI=i
        return i
      end
    end
  else
    dpi=ultraschall.LastUsedScaleDPI
    return tonumber(dpi), 2
  end
end

