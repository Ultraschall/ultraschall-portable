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

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- A=ultraschall.GetUSExternalState("ultraschall_follow", "state")

commandid = reaper.NamedCommandLookup("_Ultraschall_Toggle_Follow")
buttonstate = reaper.GetToggleCommandStateEx(0, commandid)
if buttonstate <= 0 then buttonstate = 0 end

if reaper.GetPlayState() == 0 or reaper.GetPlayState() == 2 then -- 0 = Stop, 2 = Pause
  current_position = reaper.GetCursorPosition() -- Position of edit-cursor
else
    if buttonstate == 1 then -- follow mode is active
    current_position = reaper.GetPlayPosition() -- Position of play-cursor
--     elseif reaper.GetPlayState()~=0 then
--          current_position = reaper.GetPlayPosition() -- Position of play-cursor
  else
    current_position = reaper.GetCursorPosition() -- Position of edit-cursor
  end
end

marker_id, guid = ultraschall.GetTemporaryMarker()
ultraschall.StoreTemporaryMarker(-1)

if marker_id==-1 then
  runcommand("_Ultraschall_Center_Arrangeview_To_Cursor") -- scroll to cursor if not visible
  markernumber, guid, shownote_idx = ultraschall.AddShownoteMarker(current_position, "")
  ultraschall.pause_follow_one_cycle()
else
  retval, shownote_idx = ultraschall.IsMarkerShownote(marker_id)
end


dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")

function StoreAttributes(element_id, entered_text)
  if element_id==tab1.sn_ib_title then
    retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownote_idx, "shwn_title", entered_text, "")
  elseif element_id==tab1.sn_ib_url then
    retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownote_idx, "shwn_url", entered_text, "")
  elseif element_id==tab1.sn_ib_url_archive then
    retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownote_idx, "shwn_url_archived_copy_of_original_url", entered_text, "")
  elseif element_id==tab1.sn_ib_description then
    retval, content = ultraschall.GetSetShownoteMarker_Attributes(true, shownote_idx, "shwn_description", entered_text, "")
  end
end

function AtExit()
  reagirl.Gui_Close()
end

reagirl.Gui_New()

tab1={}
tab1.label_general = reagirl.Label_Add(nil, nil, "General", "General Shownote Metadata.", false, nil, label_general) 
reagirl.NextLine()
cap_width=85
retval, shownote_title = ultraschall.GetSetShownoteMarker_Attributes(false, shownote_idx, "shwn_title", "", "")
tab1.sn_ib_title = reagirl.Inputbox_Add(nil, nil, -20, "Title:", cap_width, "The title of this shownote.",  shownote_title, AtExit, StoreAttributes, "inputbox_shownote_title")
reagirl.NextLine()
retval, shownote_url = ultraschall.GetSetShownoteMarker_Attributes(false, shownote_idx, "shwn_url", "", "")
tab1.sn_ib_url = reagirl.Inputbox_Add(nil, nil, -20, "URL:", cap_width, "The url of this shownote.",  shownote_url, AtExit, StoreAttributes, "inputbox_shownote_title")
reagirl.NextLine()
retval, shownote_url_archive = ultraschall.GetSetShownoteMarker_Attributes(false, shownote_idx, "shwn_url_archived_copy_of_original_url", "", "")
tab1.sn_ib_url_archive = reagirl.Inputbox_Add(nil, nil, -20, "URL(archived):", cap_width, "Journalists often create archived copies of a referenced url(like with archive.org). \nThis gives proof later on, that certain contents you are referring to where available at the point of archiving the url. \nOtherwise, the content behind the shownote-url can change and therefore your claim in the podcast/article would not be backed up by the shownote-url-source anymore.\nIt's an insurance in case of issues and legal battles.",  shownote_url_archive, AtExit, StoreAttributes, "inputbox_shownote_title")
reagirl.NextLine()
retval, shownote_description = ultraschall.GetSetShownoteMarker_Attributes(false, shownote_idx, "shwn_description", "", "")
tab1.sn_ib_description = reagirl.Inputbox_Add(nil, nil, -20, "Description:", cap_width, "The description of this shownote. Describe, here, what in the linked document is relevant to this shownote.",  shownote_description, AtExit, StoreAttributes, "inputbox_shownote_title")

reagirl.Label_AutoBackdrop(tab1.label_general, tab1.sn_ib_description)

DateTime=os.date("*t")
if DateTime.month<10 then DateTime.month="0"..DateTime.month end
if DateTime.day<10 then DateTime.day="0"..DateTime.day end
Date=DateTime.year.."-"..DateTime.month.."-"..DateTime.day

if DateTime.hour<10 then DateTime.hour="0"..DateTime.hour end
if DateTime.min<10 then DateTime.min="0"..DateTime.min end
if DateTime.sec<10 then DateTime.sec="0"..DateTime.sec end
Time=DateTime.hour..":"..DateTime.min..":"..DateTime.sec

window_open, window_handler = reagirl.Gui_Open("Ultraschall Edit Shownote", false, "Edit Shownote", "Enter metadata for a shownote.", 300, 300, nil, nil, nil)


reagirl.Gui_AtEnter(AtExit)

reagirl.Gui_Manage(true)
reagirl.UI_Element_SetFocused(tab1.sn_ib_title)
