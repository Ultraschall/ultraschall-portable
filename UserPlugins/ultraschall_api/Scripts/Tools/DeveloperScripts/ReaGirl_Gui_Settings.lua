--[[
################################################################################
# 
# Copyright (c) 2023-present Meo-Ada Mespotine mespotine.de
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

-- NOTE!! Osara is always enabled in this dialog so blind people can't shut themselves out of using this dialog!!!

dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
reaper.set_action_options(1)

reagirl.Settings_Override=true
--dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function toboolean(value, default)
    -- converts a value to boolean, or returns nil, if not convertible
    if type(value)=="boolean" then return value end
    if value=="" then return default end
    if value==nil then return end
    local value=value:lower()
    local truth=value:match("^\t*%s*()true\t*%s*$")
    local falseness=value:match("^\t*%s*()false\t*%s*$")
    
    if tonumber(truth)==nil and tonumber(falseness)~=nil then
      return false
    elseif tonumber(truth)~=nil and tonumber(falseness)==nil then
      return true
    end
end

testtext=""

function Image(element_id, filename, drag_destination)
  if drag_destination==tab1.image_dest then
    reaper.MB("Successfully dragged", "Dragged", 0)
  end
end

function Label(A,B,C)
end

function dropdownmenu(element_id, selection)

end

function BlinkSpeed(element_id, val)
  if reagirl.Slider_GetValue(tab1.slider_blink_every)==1 then val="" else val=math.floor(reagirl.Slider_GetValue(tab1.slider_blink_every)*33) end
  reaper.SetExtState("ReaGirl", "FocusRectangle_BlinkSpeed", val, true)
end

function BlinkTime(element_id, val)
  if reagirl.Slider_GetValue(tab1.slider_blink_for)==0 then val="" else val=math.floor(reagirl.Slider_GetValue(tab1.slider_blink_for)) end
  reaper.SetExtState("ReaGirl", "FocusRectangle_BlinkTime", val, true)
end

function HightLighting(element_id, val)
  if reagirl.Slider_GetValue(tab1.slider_blink_for)<0 then val="" else val=math.floor(reagirl.Slider_GetValue(tab1.slider_blink_for)) end
  reaper.SetExtState("ReaGirl", "Highlight_Intensity", val, true)
end

function CursorBlinkSpeed(element_id, val)
  if reagirl.Slider_GetValue(tab1.slider_blink_every_cursor)==1 then val="" else val=math.floor(reagirl.Slider_GetValue(tab1.slider_blink_every_cursor)*33) end
  reaper.SetExtState("ReaGirl", "Inputbox_BlinkSpeed", val, true)
end

function DragBlinkSpeed(element_id, val)
  if reagirl.Slider_GetValue(tab1.slider_blink_every_draggable)==0 then val="" else val=math.floor(reagirl.Slider_GetValue(tab1.slider_blink_every_draggable)*33) end
  reaper.SetExtState("ReaGirl", "highlight_drag_destination_blink", val, true)
end

function button_cancel()
  reagirl.Gui_Close()
end

function button_apply_and_close()
  reagirl.Gui_Close()
end


function SetUpNewGui()
  reagirl.Gui_New()
  
  if tabnumber==nil then tabnumber=1 end
  Tabs=reagirl.Tabs_Add(10, 10, 332, 517, "Settings", "Some ReaGirl Settings.", {"General", "Accessibility", "Development"}, tabnumber, nil, "Overview_Tabs")
  
  tab1={}
  --[[ Blinking Focus Rectangle ]]
  tab1.Label_General=reagirl.Label_Add(nil, nil, "General", "General settings.", false, nil, "General Label")
  reagirl.Label_SetBackdrop(tab1.Label_General, 300, 77) -- set a backdrop around the next few labels
  reagirl.NextLine()
  
  tab1.checkbox_tooltips_id = reagirl.Checkbox_Add(nil, nil, "Show tooltips when hovering above ui-element", "When checked, ReaGirl will show tooltips when hovering above ui-elements.", true, checkbox, "Tooltip checkbox")
  reagirl.Checkbox_LinkToExtstate(tab1.checkbox_tooltips_id, "ReaGirl", "show_tooltips", "false", "", true, true) 
  reagirl.NextLine()
  tab1.scroll_via_keyboard_id = reagirl.Checkbox_Add(nil, nil, "Scroll via keyboard", "When checked, ReaGirl allows scrolling via keyboard with the cursor keys, PgUp/PgDn, Home and End-key.", true, checkbox, "Scroll via keyboard checkbox")
  reagirl.Checkbox_LinkToExtstate(tab1.scroll_via_keyboard_id, "ReaGirl", "scroll_via_keyboard", "false", "", true, true)
  reagirl.NextLine()
  tab1.window_drag=reagirl.DropDownMenu_Add(nil, nil, 290, "Window dragging:", 110, "Choose, whether clicking in empty areas of the window allows dragging of the window(means, clicking where no ui-element is located).", {"let script decide", "always allow dragging", "never allow dragging"}, 1, dropdownmenu, "Window dragging drodownmenu")
  reagirl.DropDownMenu_LinkToExtstate(tab1.window_drag, "ReaGirl", "DragWindow", 1, true)
  
  reagirl.NextLine(10)
  tab1.Label_FocusRectangle=reagirl.Label_Add(nil, nil, "Focus Rectangle", "Settings for the focus rectangle.", false, nil, "Focus Rectangle label")
  reagirl.Label_SetBackdrop(tab1.Label_FocusRectangle, 300, 75) -- set a backdrop around the next few labels
  
  reagirl.NextLine()
  tab1.checkbox_blink_always_on = reagirl.Checkbox_Add(nil, nil, "Always show focus rectangle", "When checked, ReaGirl will show focus rectangle always, when unchecked, it will only show, when you tab through the gui with the tab-key.", false, checkbox, "Always show focus rectangle checkbox")
  reagirl.Checkbox_LinkToExtstate(tab1.checkbox_blink_always_on, "ReaGirl", "FocusRectangle_AlwaysOn", "false", "", true, true)
  reagirl.NextLine()
  tab1.slider_blink_every = reagirl.Slider_Add(nil, nil, 300, "Blink every", 110,  "Set the speed of the blinking of the focus rectangle.", "seconds", 0.4, 3, 0.1, 1, 1, BlinkSpeed1, "Focus Rectangle Blink Every Slider")
  reagirl.Slider_LinkToExtstate(tab1.slider_blink_every, "ReaGirl", "FocusRectangle_BlinkSpeed", 33, true, 33)
  
  reagirl.NextLine(-4)
  tab1.slider_blink_for = reagirl.Slider_Add(nil, nil, 300, "Blink for", 110,  "Set the duration of the blinking of the focus rectangle.", "seconds", 0, 10, 1, 0, 0, BlinkTime1, "Focus Rectangle Blink For Slider")
  reagirl.Slider_LinkToExtstate(tab1.slider_blink_for, "ReaGirl", "FocusRectangle_BlinkTime", 0, true, 1)
  
  -- [[ Blinking Inputbox-Cursor ]]
  reagirl.NextLine(15)
  tab1.Label_InputBox=reagirl.Label_Add(nil, nil, "Inputbox-Cursor", "Settings for the inputbox-cursor.", false, nil, "Inputbox cursor label")
  reagirl.Label_SetBackdrop(tab1.Label_InputBox, 300, 60) -- set a backdrop around the next few labels
  reagirl.NextLine()
  
  tab1.slider_blink_every_cursor=reagirl.Slider_Add(nil, nil, 300, "Blink every", 110,  "Set the speed of the blinking of the cursor.", "seconds", 0.4, 5, 0.1, 1, 1, CursorBlinkSpeed, "Cursor Blink Every slider")
  reagirl.Slider_LinkToExtstate(tab1.slider_blink_every_cursor, "ReaGirl", "Inputbox_BlinkSpeed", 33, true, 33)
  
  reagirl.NextLine()
  tab1.input_id = reagirl.Inputbox_Add(nil, nil, 290, "Test input:", 110,  "Input text to check cursor blinking speed.", testtext, nil, nil, "Test Input Inputbox")
  reagirl.Inputbox_SetEmptyText(tab1.input_id, "Test blink-speed here...")

  --[[ Highlighting ]]
  reagirl.NextLine(15)
  tab1.Label_Highlighting=reagirl.Label_Add(nil, nil, "Highlighting UI Elements", "Settings for the highlighting of ui-elements, when hovering above them.", false, nil, "Highlight UI Elements label")
  reagirl.Label_SetBackdrop(tab1.Label_Highlighting, 300, 40) -- set a backdrop around the next few labels
  reagirl.NextLine()
  
  tab1.highlighting = reagirl.Slider_Add(nil, nil, 285, "Highlight intensity", 110,  "Set the highlighting intensity when hovering above ui-elements; 0, no highlighting.", "", 0, 3, 0.25, 0.75, 0.75, Highlighting, "Highlight Intensity Slider")
  reagirl.Slider_LinkToExtstate(tab1.highlighting, "ReaGirl", "Highlight_Intensity", 0.075, true, 0.1)
  reagirl.NextLine(15)
  
  -- [[ Scaling Override ]]
  reagirl.NextLine(15)
  tab1.Label_Scaling=reagirl.Label_Add(nil, nil, "Scaling", "Settings for the scaling-factor of ReaGirl-Guis.", false, nil, "Scaling Label")
  reagirl.Label_SetBackdrop(tab1.Label_Scaling, 300, 40) -- set a backdrop around the next few labels
  reagirl.NextLine()
  scaling_override=tonumber(reaper.GetExtState("ReaGirl", "scaling_override", value, true))
  if scaling_override==nil then scaling_override2=0 else scaling_override2=scaling_override end
  tab1.slider_scale = reagirl.Slider_Add(nil, nil, 295, "Scale Override", 110,  "Set the default scaling-factor for all ReaGirl-Gui-windows; 0, scaling depends automatically on the scaling-factor in the prefs or the presence of Retina/HiDPI.", "", 0, 8, 1, 0, 0, ScaleOverride, "Scale Override Slider")
  reagirl.NextLine(15)
  
  -- [[ Blinking Drag-Destinations ]]
  reagirl.NextLine(15)
  
  function tudelu(A, B)
    reaper.MB("Successfully Dragged", "Dragged", 0)
  end
  
  tab1.Label_Draggable_UI_Elements=reagirl.Label_Add(nil, nil, "Draggable UI-elements", "Settings for draggable ui-elements.", false, tudelu, "Draggable label")
  --reagirl.Label_SetStyle(tab1.Label_Draggable_UI_Elements, 6, 0, 0)
  reagirl.Label_SetBackdrop(tab1.Label_Draggable_UI_Elements, 300, 115) -- set a backdrop around the next few labels
  
  reagirl.NextLine()
  tab1.checkbox_highlight_drag_destinations = reagirl.Checkbox_Add(nil, nil, "Highlight drag-destinations", "When checked, ReaGirl will highlight the ui-elements, where you can drag a draggable ui-element to, like Images or Labels for instance.", true, checkbox, "Highlight Drag Destinations Slider")
  reagirl.Checkbox_LinkToExtstate(tab1.checkbox_highlight_drag_destinations, "ReaGirl", "highlight_drag_destinations", "false", "", true, true)
  reagirl.NextLine()
  
  tab1.slider_blink_every_draggable=reagirl.Slider_Add(nil, nil, 300, "Blink every", 110,  "Set the speed of the blinking of the drag-destinations; 0=no blinking.", "seconds", 0, 5, 0.1, 0, 0, DragBlinkSpeed, "Drag Blink Every Slider")
  reagirl.Slider_LinkToExtstate(tab1.slider_blink_every_draggable, "ReaGirl", "highlight_drag_destination_blink", 0, true, 33)
  reagirl.NextLine(5)
  tab1.image_source=reagirl.Image_Add(50,nil,50,50,reaper.GetResourcePath().."/Data/track_icons/double_bass.png", "The source-image, an image of a double bass.", "Drag this double bass to the microphone.", Image, "Image Source")
  tab1.image_middle=reagirl.Image_Add(160,nil,25,25,reaper.GetResourcePath().."/Data/track_icons/folder_right.png", "Image of an arrow pointing to the drag-destination of the double bass.", "Graphics with an arrow pointing to the drag-destination of the double bass.",nil, "Image Middle")
  tab1.image_dest=reagirl.Image_Add(250,nil,50,50,reaper.GetResourcePath().."/Data/track_icons/mic_dynamic_1.png", "The destination image, an image of a microphone.", "The destination image, drag the double bass over here.",nil,"Image Destination")
  reagirl.Image_SetDraggable(tab1.image_source, true, {tab1.image_dest})
  
  reagirl.Tabs_SetUIElementsForTab(Tabs, 1, tab1)
  
  -- [[ Osara override ]]
  tab2={}
  reagirl.AutoPosition_SetNextUIElementRelativeTo(Tabs)
  reagirl.NextLine()
  tab2.Label_Osara=reagirl.Label_Add(nil, nil, "Accessibility settings", "Settings that influence accessibility.", false, nil, "Accessibility Label")
  reagirl.Label_SetBackdrop(tab2.Label_Osara, 300, 100) -- set a backdrop around the next few labels
  reagirl.NextLine()
  tab2.checkbox_osara_id = reagirl.Checkbox_Add(nil, nil, "Enable screen reader support(requires OSARA)", "Checking this will provide feedback to screen readers as you navigate. Feedback is delivered through OSARA so please make sure you have that installed.", true, checkbox, "Enable Screen Reader Checkbox")
  reagirl.Checkbox_LinkToExtstate(tab2.checkbox_osara_id, "ReaGirl", "osara_override", "false", "", true, true)

  reagirl.NextLine()
  tab2.checkbox_osara_move_mouse_id = reagirl.Checkbox_Add(nil, nil, "Move mouse when tabbing ui-elements", "Uncheck to prevent moving of the mouse when tabbing through ui-elements. Unchecking will make right-clicking for context menus more difficult, though.", true, checkbox, "Move Mouse When Tabbing Checkbox")
  reagirl.Checkbox_LinkToExtstate(tab2.checkbox_osara_move_mouse_id, "ReaGirl", "osara_move_mouse", "false", "", true, true)
  
  reagirl.NextLine()
  tab2.checkbox_osara_hover_mouse_id = reagirl.Checkbox_Add(nil, nil, "Report hovered ui-elements", "When checked, ReaGirl will report ui-elements the mouse is hovering above to the screen reader. Uncheck to prevent that.", true, checkbox, "Mouse Hover Checkbox")
  reagirl.Checkbox_LinkToExtstate(tab2.checkbox_osara_hover_mouse_id, "ReaGirl", "osara_hover_mouse", "false", "", true, true)  
  
  reagirl.NextLine()
  osara_enable_accmessage = reaper.GetExtState("ReaGirl", "osara_enable_accmessage")
  if osara_enable_accmessage=="" or osara_enable_accmessage=="true" then osara_enable_accmessage=true else osara_enable_accmessage=false end
  tab2.checkbox_osara_enable_acc_help = reagirl.Checkbox_Add(nil, nil, "Enable screen reader help-messages", "When checked, a short description on how to use a tabbed ui-element will be send to the screen reader as well. Uncheck to turn off the help-messages.", true, checkbox, "Enable Screen Reader Help")
  reagirl.Checkbox_LinkToExtstate(tab2.checkbox_osara_enable_acc_help, "ReaGirl", "osara_enable_accmessage", "false", "", true, true)  
  reagirl.NextLine(15)
  
  tab2.Label_Osara_Meters=reagirl.Label_Add(nil, nil, "Meters", "Settings that influence level-meters.", false, nil, "Screen Reader Meters Label")
  reagirl.Label_SetBackdrop(tab2.Label_Osara_Meters, 300, 40) -- set a backdrop around the next few labels
  reagirl.NextLine()
  tab2.meter_clip_report=reagirl.DropDownMenu_Add(nil, nil, 290, "Report clippings:", 100, "Report clippings of meters to the screen reader.", {"when gui has focus", "also when gui has no focus", "never"}, 1, dropdownmenu, "Report Clippings DropDownMenu")
  reagirl.DropDownMenu_LinkToExtstate(tab2.meter_clip_report, "ReaGirl", "osara_report_meter_clippings", 1, true)
  reagirl.Tabs_SetUIElementsForTab(Tabs, 2, tab2)
  
  tab3={}
  reagirl.AutoPosition_SetNextUIElementRelativeTo(Tabs)
  reagirl.NextLine()
  tab3.Label_Development=reagirl.Label_Add(nil, nil, "Development", "Settings for developers.", false, nil, "Development Label")
  reagirl.Label_SetBackdrop(tab3.Label_Development, 300, 85) -- set a backdrop around the next few labels
  
  reagirl.NextLine()
  tab3.checkbox_osara_debug_id = reagirl.Checkbox_Add(nil, nil, "Show screen reader messages in console", "Checking this will show the screen reader messages in the console for debugging purposes.", false, checkbox, "Show Screen Reader Messages In Console Checkbox")
  reagirl.Checkbox_LinkToExtstate(tab3.checkbox_osara_debug_id, "ReaGirl", "osara_debug", "", "true", false, true)  
  
  reagirl.NextLine()
  tab3.checkbox_show_ui_elements_debug_id = reagirl.Checkbox_Add(nil, nil, "Show gui-name and ui-element-name in console", "Checking this will show the gui-name and focused ui-element-name in the console.\n\nUse Tab/Shift+Tab to switch through them.\n\nThese names can be used with reagirl.Ext_SendEvent() to send clickevents to a certain ui-element.", false, checkbox, "Show Gui-Element In Console")
  reagirl.Checkbox_LinkToExtstate(tab3.checkbox_show_ui_elements_debug_id, "ReaGirl", "show_gui_and_ui_names", "", "true", false, true)  

  reagirl.NextLine(5)
  tab3.error_message_target=reagirl.DropDownMenu_Add(nil, nil, 290, "Show errors in:", 100, "Decide, whether ReaGirl-error-messages shall be shown only in IDE, in a dedicated MessageBox or in the ReaScript console window.", {"IDE", "Messagebox", "ReaScript console window"}, 1, dropdownmenu, "Show Error Messages In DropDownMenu")
  reagirl.DropDownMenu_LinkToExtstate(tab3.error_message_target, "ReaGirl", "Error_Message_Destination", 1, true)
  
  
  reagirl.Tabs_SetUIElementsForTab(Tabs, 3, tab3)
  
  --button_apply_and_close_id = reagirl.Button_Add(180, 537, 0, 0, "Apply and Close", "Apply the chosen settings and close window.", button_apply_and_close)
  button_cancel_id = reagirl.Button_Add(293, 557, 0, 0, "Close", "Close dialog.", button_cancel, "Close Button")
  reagirl.NextLine()
  tab4={}
  reagirl.AutoPosition_SetNextUIElementRelativeTo(Tabs)
  reagirl.NextLine()
end

reagirl.Gui_AtEnter(button_apply_and_close)

SetUpNewGui()
color=40
reagirl.Background_GetSetColor(true,color,color,color)
reagirl.Gui_Open("ReaGirl_Settings", true, "ReaGirl Settings (v."..reagirl.GetVersion()..")", "various settings for ReaGirl-Accessible Guis.", 352, 580, nil, nil, nil)
  
--reagirl.Window_ForceSize_Minimum(355, 470) -- set the minimum size of the window
--reagirl.Window_ForceSize_Maximum(355, 470) -- set the maximum size of the window


reagirl.ReScale=1

function main()
  reagirl.Gui_Manage()
  if reagirl.Key[1]==43 then reagirl.ReScale=reagirl.ReScale+1 end -- +
  if reagirl.Key[1]==45 then reagirl.ReScale=reagirl.ReScale-1 end -- -
  if B==true then
    reagirl.Elements.FocusedElement=i
    reagirl.Gui_ForceRefresh()
  end
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()
--reaper.ShowConsoleMsg("Tudelu")
