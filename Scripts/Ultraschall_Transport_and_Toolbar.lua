-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
-- check for required version; alter the version-number if necessary
--if reagirl.GetVersion()<1.33 then reaper.MB("Needs ReaGirl v"..(1.33).." to run", "Too old version", 2) return false end

-- 1. add the run-functions for the ui-elements

function ReadIniEntries()
  SetupToolbar={}
  for i=0, 512 do
    retval, toolbarentry_icon = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 29", "icon_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    retval, toolbarentry_action = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 29", "item_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    if toolbarentry_action=="" then break end
    toolbarentry_action, toolbarentry_text=toolbarentry_action:match("(.-) (.*)")
    SetupToolbar[#SetupToolbar+1]={}
    SetupToolbar[#SetupToolbar]["icon"]=toolbarentry_icon
    SetupToolbar[#SetupToolbar]["action"]=toolbarentry_action
    SetupToolbar[#SetupToolbar]["text"]=toolbarentry_text
    if toolbarentry_action=="65535" and SetupToolbar[#SetupToolbar]["icon"]:sub(1,4)=="text" then
      SetupToolbar[#SetupToolbar]["header"]=true
    else
      SetupToolbar[#SetupToolbar]["header"]=false
    end
  end
  
  RecordingToolbar={}
  for i=0, 512 do
    retval, toolbarentry_icon = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 30", "icon_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    retval, toolbarentry_action = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 30", "item_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    if toolbarentry_action=="" then break end
    toolbarentry_action, toolbarentry_text=toolbarentry_action:match("(.-) (.*)")
    RecordingToolbar[#RecordingToolbar+1]={}
    RecordingToolbar[#RecordingToolbar]["icon"]=toolbarentry_icon
    RecordingToolbar[#RecordingToolbar]["action"]=toolbarentry_action
    RecordingToolbar[#RecordingToolbar]["text"]=toolbarentry_text
    if toolbarentry_action=="65535" and RecordingToolbar[#RecordingToolbar]["icon"]:sub(1,4)=="text" then
      RecordingToolbar[#RecordingToolbar]["header"]=true
    else
      RecordingToolbar[#RecordingToolbar]["header"]=false
    end
  end
  
  PostproductionToolbar={}
  for i=0, 512 do
    retval, toolbarentry_icon = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 31", "icon_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    retval, toolbarentry_action = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 31", "item_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    if toolbarentry_action=="" then break end
    toolbarentry_action, toolbarentry_text=toolbarentry_action:match("(.-) (.*)")
    PostproductionToolbar[#PostproductionToolbar+1]={}
    PostproductionToolbar[#PostproductionToolbar]["icon"]=toolbarentry_icon
    PostproductionToolbar[#PostproductionToolbar]["action"]=toolbarentry_action
    PostproductionToolbar[#PostproductionToolbar]["text"]=toolbarentry_text
    if toolbarentry_action=="65535" and PostproductionToolbar[#PostproductionToolbar]["icon"]:sub(1,4)=="text" then
      PostproductionToolbar[#PostproductionToolbar]["header"]=true
    else
      PostproductionToolbar[#PostproductionToolbar]["header"]=false
    end
  end
  
  ExportToolbar={}
  for i=0, 512 do
    retval, toolbarentry_icon = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 32", "icon_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    retval, toolbarentry_action = reaper.BR_Win32_GetPrivateProfileString("Floating toolbar 32", "item_"..i, "", reaper.GetResourcePath().."/reaper-menu.ini")
    if toolbarentry_action=="" then break end
    toolbarentry_action, toolbarentry_text=toolbarentry_action:match("(.-) (.*)")
    ExportToolbar[#ExportToolbar+1]={}
    ExportToolbar[#ExportToolbar]["icon"]=toolbarentry_icon
    ExportToolbar[#ExportToolbar]["action"]=toolbarentry_action
    ExportToolbar[#ExportToolbar]["text"]=toolbarentry_text
    if toolbarentry_action=="65535" and ExportToolbar[#ExportToolbar]["icon"]:sub(1,4)=="text" then
      ExportToolbar[#ExportToolbar]["header"]=true
    else
      ExportToolbar[#ExportToolbar]["header"]=false
    end
  end
end

function BuildToolbar()
  local icon, mode, y, Toolbar, temp_element_id, temp
  
  reagirl.ToolbarButton_Add(nil, 100, reaper.GetResourcePath().."/ColorThemes/Ultraschall_5/toolbar_revert.png", 2, 1, {"Setup Mode Deactivated", "Setup Mode Activated"}, 5, "Setup Mode", "Click this if you want to set up your new project.", SetupMode_FunFunc, "SetupMode_Toolbarbutton")
  reagirl.ToolbarButton_Add(nil, 100, reaper.GetResourcePath().."/ColorThemes/Ultraschall_5/toolbar_rippleone.png", 2, 1, {"Record Mode Deactivated", "Record Mode Activated"}, 133, "Setup Mode", "Click this if you want to record your project.", RecordMode_FunFunc, "RecordMode_Toolbarbutton")
  reagirl.ToolbarButton_Add(nil, 100, reaper.GetResourcePath().."/ColorThemes/Ultraschall_5/toolbar_rippleone.png", 2, 1, {"Postproduction Mode Deactivated", "Postproduction Mode Activated"}, 133, "Setup Mode", "Click this if you want to edit your project.", PostProcMode_FunFunc, "PostProcMode_Toolbarbutton")
  reagirl.ToolbarButton_Add(nil, 100, reaper.GetResourcePath().."/ColorThemes/Ultraschall_5/toolbar_rippleone.png", 2, 1, {"Export Mode Deactivated", "Export Mode Activated"}, 133, "Setup Mode", "Click this if you want to export your project.", ExportMode_FunFunc, "ExportMode_Toolbarbutton")
  
  decor_rectangle_guid = reagirl.DecorRectangle_Add(147, 100, 1, 30, 0, 255, 255, 1)
  
  
  Toolbar=ExportToolbar
  for i=1, #Toolbar do
  --TODO: Der Button, der nach dem Gap kommen sollte, verschwindet hinter dem letzten Button -> go fix it
    if i==1 then posx=163 else posx=nil end
    if Toolbar[i]["header"]==true then 
      y=80
      temp_element_id=reagirl.Label_Add(posx, y, Toolbar[i]["text"], Toolbar[i]["text"]..".", false)     
      temp=false
      mode=3
      icon=""
    else 
      y=100 
      if Toolbar[i]["icon"]=="text" then
        mode=3
        icon=""
      elseif Toolbar[i]["icon"]=="" then 
        mode=3
      else 
        mode=5
        icon=reaper.GetResourcePath().."/ColorThemes/Ultraschall_5/"..Toolbar[i]["icon"]
      end
    end
    if Toolbar[i]["text"]==nil then
      temp=false
      if old_tb_button~=nil then
        local x=reagirl.UI_Element_GetSetPosition(old_tb_button, false, 0, 0)
        reagirl.AutoPosition_SetNextUIElementAtPosition(x, 100)
        
      end
    end
    
    if temp~=false then
      
      old_tb_button=reagirl.ToolbarButton_Add(posx, y, icon, 2, 1, {"Setup Mode Deactivated", "Setup Mode Activated"}, 128+mode, tostring(i), "Click this if you want to set up your new project.", SetupMode_FunFunc, "SetupMode_Toolbarbutton")
    end
    
    temp=nil
    if temp_element_id~=nil then 
      x=reagirl.UI_Element_GetSetPosition(temp_element_id, false, 0, 0)
      reagirl.AutoPosition_SetNextUIElementAtPosition(x, 100)
      temp_element_id=nil
    end
    
  end
end

function RebuildGui()
  reagirl.Gui_New()
  ReadIniEntries()
  BuildToolbar()
end


-- 2. start a new gui
--RebuildGui()
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes

 
-- 4. open the gui
reagirl.Gui_Open("My Dialog Name", false, "Dialog Title", "A short explanation of my dialog.", 355, 225, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
function main()
  reagirl.Gui_Manage()
  retval, size, accessedTime, modifiedTime = reaper.JS_File_Stat(reaper.GetResourcePath().."/reaper-menu.ini")
  if modifiedTime~=modifiedTime_old then RebuildGui() end
  modifiedTime_old=modifiedTime
  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()

