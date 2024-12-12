-- enable Ultraschall-API for the script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- 0. enable ReaGirl for the script
dofile(reaper.GetResourcePath().."/UserPlugins/reagirl.lua")
-- check for required version; alter the version-number if necessary
if reagirl.GetVersion()<1.0 then reaper.MB("Needs ReaGirl v"..(1.0).." to run", "Too old version", 2) return false end

-- 1. add the run-functions for the ui-elements

function ResolveScriptname(stringme)
  --stringme="$Date $Time $Extstate_Ultraschall_API_ScriptCreator_IDEW $Extstate_Ultraschall_API_ScriptCreator_IDEH"
  
  if stringme=="" then stringme=reaper.GetResourcePath().."/Scripts/temporary"..os.date():match("(.-) ")..os.date():match(".- (.*)") end
  stringme=stringme.." "
  
  stringme=string.gsub(stringme, "$Date", os.date():match("(.-) "))
  stringme=string.gsub(stringme, "$Time", os.date():match(".- (.*)"))
  
  stringme=string.gsub(stringme, "\\", "/")
  stringme=string.gsub(stringme, ":", "_")
  stringme=stringme:sub(1,-2)
  if stringme:sub(-4,-1)~=".lua" and stringme:sub(-4,-1)~=".eel" and stringme:sub(-3,-1)~=".py" then
    stringme=stringme..".lua"
  end
  if stringme:match("/")==nil then
    stringme=reaper.GetResourcePath().."/Scripts/"..stringme
  end
  
  return stringme
end

function CreateScript()
  local filename=ResolveScriptname(reagirl.Inputbox_GetText(tab1.inputbox_choose_file))
  
  us_api=reagirl.Checkbox_GetCheckState(tab1.checkbox_add_ultraschall_api)
  if us_api==true then us_api=1 else us_api=0 end
  reagirl_set=reagirl.Checkbox_GetCheckState(tab1.checkbox_add_reagirl)
  if reagirl_set==true then reagirl_set=2 else reagirl_set=0 end
  ultraschall.EditReaScript(filename,
                            us_api+reagirl_set, 
                            nil, 
                            x_pos, y_pos, width, height, showstate, watchlist_size, watchlist_size_row1, watchlist_size_row2, 
                            default_script_content)
  if reagirl.Checkbox_GetCheckState(tab1.checkbox_main)==true then reaper.AddRemoveReaScript(true, 0, filename, true) end
  if reagirl.Checkbox_GetCheckState(tab1.checkbox_media_explorer)==true then reaper.AddRemoveReaScript(true, 32063, filename, true) end
  if reagirl.Checkbox_GetCheckState(tab1.checkbox_midi_editor)==true then reaper.AddRemoveReaScript(true, 32060, filename, true) end
  if reagirl.Checkbox_GetCheckState(tab1.checkbox_midi_eventlist_editor)==true then reaper.AddRemoveReaScript(true, 32061, filename, true) end
  if reagirl.Checkbox_GetCheckState(tab1.checkbox_midi_inline_editor)==true then reaper.AddRemoveReaScript(true, 32062, filename, true) end
  reagirl.Gui_Close()
end

function Button(element_id)
  if element_id==tab1.button_add then
    CreateScript()
  elseif element_id==tab1.button_choose_file then
    retval, filename = reaper.GetUserFileNameForRead(reaper.GetResourcePath().."/Scripts/", "Choose Script", "*.lua;*.py;*.eel")
    if retval==true then
      reagirl.Inputbox_SetText(tab1.inputbox_choose_file, filename)
    end
  end
end

-- 2. start a new gui
reagirl.Gui_New()

-- 3. add the ui-elements and set their attributes
tab1={}
tab1.inputbox_choose_file = reagirl.Inputbox_Add(nil, nil, 300, "Scriptname", 80, "The name of the script to be created.\n\nWith wildcards, you can customize the filename, without having to type in stuff time and again.\n\n  \t$Date - the current date.\n  \t$Time - the current time.", "", nil, nil)
--reagirl.NextLine()
tab1.button_choose_file = reagirl.Button_Add(nil, nil, 0, 0, "Choose File", "Let's you choose an already existing scriptfile.", Button)
reagirl.NextLine()
tab1.checkbox_add_ultraschall_api = reagirl.Checkbox_Add(100, nil, "Enable Ultraschall-API in new script", "Enables Ultraschall-API to the new script.", true, CheckBox)
reagirl.NextLine()
tab1.checkbox_add_reagirl = reagirl.Checkbox_Add(100, nil, "Enable ReaGirl in new script", "Adds the basic ReaGirl-structure to the new script.", false, CheckBox)

reagirl.NextLine(10)
tab1.label_add_sections = reagirl.Label_Add(nil, nil, "Add to Section(s)", "Choose the sections to which you want to add the new script.", false, nil)
reagirl.NextLine()
tab1.checkbox_main = reagirl.Checkbox_Add(nil, nil, "Main", "Adds the script to the main-section.", true, CheckBox)
tab1.checkbox_media_explorer = reagirl.Checkbox_Add(114, nil, "Media Explorer", "Adds the script to the media explorer-section.", false, CheckBox)
reagirl.NextLine()
tab1.checkbox_midi_editor = reagirl.Checkbox_Add(nil, nil, "MIDI Editor", "Adds the script to the main-section.", false, CheckBox)
tab1.checkbox_midi_inline_editor = reagirl.Checkbox_Add(nil, nil, "MIDI Inline Editor", "Adds the script to the MIDI inline editor-section.", false, CheckBox)
tab1.checkbox_midi_eventlist_editor = reagirl.Checkbox_Add(nil, nil, "MIDI Eventlist Editor", "Adds the script to the MIDI eventlist editor-section.", false, CheckBox)
reagirl.Label_AutoBackdrop(tab1.label_add_sections, tab1.checkbox_midi_eventlist_editor)
reagirl.NextLine(10)
tab1.button_add = reagirl.Button_Add(-128, nil, 0, 0, "Create/Open Script", "Creates the new script. Opens an already existing script.", Button)

reagirl.Background_GetSetColor(true, 55, 55, 55)

reagirl.Gui_AtEnter(CreateScript)

-- 4. open the gui
reagirl.Gui_Open("ReaGirl Testdialog #1", false, "ReaGirl Testdialog #1", "a test dialog that features all available ui-elements.", nil, nil, nil, nil, nil)

-- 5. a main-function that runs the gui-management-function
function main()
  reagirl.Gui_Manage()

  if reagirl.Gui_IsOpen()==true then reaper.defer(main) end
end
main()
