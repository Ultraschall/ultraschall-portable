--[[
################################################################################
# 
# Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
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


if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

-- Open a new script
-- Version 1.0 written by Meo-Ada Mespotine 6th of December 2021 - licensed under MIT-license
--         1.1 allows now opening/adding already existing scripts; 
--             default path for scripts without path is now scripts-folder
--             scripts can also be copied from a different source into the scriptsfolder and then added(will only copy the chosen file, not possibly other ones!)


-- [[ Some Custom Settings ]]

-- Default Window position and size:
--    X and Y will be used the first time the preferences are opened
--    when closing the prefs, the prefs remember the position of the window for next time
WindowX     = 30 -- x-position
WindowY     = 30 -- y-position
WindowWidth = 550 -- width of the window
WindowHeight= 285 -- height of the window

ToolTipWaitTime=30 -- the waittime-until tooltips are shown when hovering above them; 30~1 second

YDefault=0          -- The Y-position of the first GUI-Element. So if you want to move all of them lower, raise this value
XOffset=43          -- X-offset of the second element in the gui(usually text inputfields), so you can move the inputfields to the right together
                    -- if an explanation-text becomes too long to be drawn


-- [[ The following functions can be customized by you ]]

function main()

  -- This function manages all the drawing and positioning of the gui-elements.
  -- If you need more gui-elements, simply add them into here.
  -- All Gui-element-functions like DrawText(), InputText(), ManageCheckBox(), ManageButton() have
  -- a description of their parameters included. Just go to the function-definitions and read their comments.
  
  -- Now, let's add the individual UI-elements
  --  the length is linked to gfx.w, so it always uses the whole window for display
  Y=Y+10 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (10,  Y, "Scriptname:", 0, "The scriptname you want to create.")
  InputText(100+XOffset, Y, gfx.w-215-XOffset, "Ultraschall_API_ScriptCreator", "Last_Used_Name", "", "Scriptname", "New Scriptname")
  ManageButton(gfx.w-112, Y-2, "Choose File", ChooseFile)
  Y=Y+24
  ManageButton(gfx.w-100, Y-2, "Wildcards", Wildcards)
--  Y=Y+22 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (67-XOffset,   Y, "Resolved As: ", 2, "The resolved filename of the script. Currently: "..ResolveScriptname(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name")), 14)
  DrawText (100+XOffset,   Y, ResolveScriptname(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name")), 2, "The resolved filename of the script. Currently: "..ResolveScriptname(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name")), 14)
  
  Y=Y+27 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageCheckBox(100+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_Ultraschall_API", true)
  DrawText      (123+XOffset,   Y, "Add Ultraschall-API to script", 0, "When checked, this will add the initialization-line of Ultraschall-API to the script, otherwise not.\n\nDefault is checked.")
    
  Y=Y+40 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText      (10,   Y, "Add to Section(s):", 0, "")
  ManageCheckBox(100+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_To_Main", false)
  DrawText      (123+XOffset,   Y, "Main", 0, "When checked, this will add the script to the main-section of the actionlist.\n\nDefault is checked.")
  ManageCheckBox(265+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_To_MediaExplorer", false)
  DrawText      (288+XOffset,   Y, "Media Explorer", 0, "When checked, this will add the script to the Media Explorer-section of the actionlist.\n\nDefault is checked.")
  Y=Y+24 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageCheckBox(100+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_To_Midi-Editor", false)
  DrawText      (123+XOffset,   Y, "MIDI-Editor", 0, "When checked, this will add the script to the Midi-editor-section of the actionlist.\n\nDefault is checked.")
  Y=Y+24 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageCheckBox(100+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_To_Midi-Eventlist-Editor", false)
  DrawText      (123+XOffset,   Y, "MIDI Eventlist Editor", 0, "When checked, this will add the script to the Midi-Eventlist-editor-section of the actionlist.\n\nDefault is checked.")
  ManageCheckBox(265+XOffset-1, Y,   "Ultraschall_API_ScriptCreator",              "Add_To_Midi-Inline-Editor", false)
  DrawText      (288+XOffset,   Y, "MIDI Inline Editor", 0, "When checked, this will add the script to the Midi Inline-editor-section of the actionlist.\n\nDefault is checked.")
  
  -- position of ide
  Y=Y+40 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText      (10,   Y, "IDE-position:", 0, "")
  DrawText (100+XOffset,  Y, "X:", 0, "X-position of the IDE.")
  InputText(120+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEX", 1, "X-Position of IDE", "X-Position(pixels)", true)
  DrawText (170+XOffset,  Y, "Y:", 0, "Y-position of the IDE.")
  InputText(190+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEY", 1, "Y-Position of IDE", "Y-Position(pixels)", true)
  DrawText (237+XOffset,  Y, "W:", 0, "Width of the IDE.")
  InputText(260+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEW", 1, "Width of IDE", "Width(pixels)", true)
  DrawText (310+XOffset,  Y, "H:", 0, "Height of the IDE.")
  InputText(330+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEH", 1, "Height of IDE", "Height(pixels)", true)

  -- watchlist
  --[[
  Y=Y+40 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText      (10,   Y, "IDE-position:", 0, "")
  DrawText (100+XOffset,  Y, "X:", 0, "X-position of the IDE.")
  InputText(120+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEX", 1, "X-Position of IDE", "X-Position(pixels)", true)
  DrawText (170+XOffset,  Y, "Y:", 0, "Y-position of the IDE.")
  InputText(190+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEY", 1, "Y-Position of IDE", "Y-Position(pixels)", true)
  DrawText (237+XOffset,  Y, "W:", 0, "Width of the IDE.")
  InputText(260+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEW", 1, "Width of IDE", "Width(pixels)", true)
  DrawText (310+XOffset,  Y, "H:", 0, "Height of the IDE.")
  InputText(330+XOffset, Y, 40, "Ultraschall_API_ScriptCreator", "IDEH", 1, "Height of IDE", "Height(pixels)", true)
  --]]
  
  -- Done-button
  --  these are linked to gfx.w(right side of the window) so they are always aligned to the right-side of the window
  Y=Y+30 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageButton(gfx.w-148, Y, "Add/Create Script", AddMe)
  Y=Y+30
  ManageButton(gfx.w-272, Y, "Copy to Scriptsfolder, then add script", AddMe2)

  -- make some mouse-management, run refresh the window again, until the window is closed, otherwise end script
  -- leave it untouched
  if Key==49 then section="Main"
  elseif Key==50 then section="Main(alt recording)"
  elseif Key==51 then section="Media Explorer"
  elseif Key==52 then section="MIDI Editor"
  elseif Key==53 then section="MIDI Eventlist Editor"
  elseif Key==54 then section="MIDI Inline Editor"
  
  --elseif Key==13 then InputText_NotDrawn("Ultraschall_API_ScriptCreator", "Last_Used_Name", "", "Scriptname", "New Scriptname")
  end
  if Key~=-1 then OldCap2=gfx.mouse_cap&1 reaper.defer(RefreshWindow) end
end



-- [[ Custom Button functions ]]
--
-- here are some custom-functions used by the buttons.
-- If you want to add additional buttons, add their accompanying functions in this section

function ResolveScriptname(stringme)
  --stringme="$Date $Time $Extstate:Ultraschall_API_ScriptCreator:IDEW $Extstate:Ultraschall_API_ScriptCreator:IDEH"
  stringme=stringme.." "
  
  stringme=string.gsub(stringme, "$Date", os.date():match("(.-) "))
  stringme=string.gsub(stringme, "$Time", os.date():match(".- (.*)"))
  
  for sec, key in string.gmatch(stringme, "$Extstate:(.-):(.-) ") do
    stringme=string.gsub(stringme, "$Extstate:"..sec..":"..key, reaper.GetExtState(sec,key))
  end
  stringme=string.gsub(stringme, "\\", "/")
  stringme=string.gsub(stringme, ":", "_")
  stringme=stringme:sub(1,-2)
  if stringme:sub(-4,-1)~=".lua" and stringme:sub(-4,-1)~=".eel" and stringme:sub(-3,-1)~=".py" then
    stringme=stringme..".lua"
  end
  if stringme:match("/")==nil then
    stringme="scripts/"..stringme
  end
  
  return stringme
end

function ChooseFile()
  local retval, filename=reaper.GetUserFileNameForRead(reaper.GetResourcePath().."/Scripts/", "Choose script to open", "")
  if retval==true then
    local temp
    if reaper.GetOS():match("Win")~=nil then
      temp=reaper.GetResourcePath().."\\Scripts\\"
    else
      temp=reaper.GetResourcePath().."/Scripts/"
    end
    if filename:sub(1,temp:len())==temp then
      filename=filename:sub(temp:len()+1, -1)
    end
    reaper.SetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name", filename, true)
  end
end

function AddMe() 
  -- this function quits the script and opens script in ide(optionally adding it to the actionlist)
  add_us_api = reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_Ultraschall_API")
  scriptname = reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name")
  idex = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEX"))
  idey = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEY"))
  idew = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEW"))
  ideh = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEH"))
  
  main_sec = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Main"))
  media_explorer= tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_MediaExplorer"))
  midi_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Editor"))
  midi_evtl_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Eventlist-Editor"))
  midi_inline_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Inline-Editor"))
  
  if add_us_api=="0" then add_us_api=false else add_us_api=true end

  scriptname=ResolveScriptname(scriptname)
--  print2(scriptname)
  retval, command_id = ultraschall.EditReaScript(reaper.GetResourcePath().."/"..scriptname, add_us_api, nil, idex, idey, idew, ideh)

  if main_sec==1 then reaper.AddRemoveReaScript(true, 0, reaper.GetResourcePath().."/"..scriptname, true) end
  if media_explorer==1 then reaper.AddRemoveReaScript(true, 32063, reaper.GetResourcePath().."/"..scriptname, true) end
  if midi_editor==1 then reaper.AddRemoveReaScript(true, 32060, reaper.GetResourcePath().."/"..scriptname, true) end
  if midi_evtl_editor==1 then reaper.AddRemoveReaScript(true, 32061, reaper.GetResourcePath().."/"..scriptname, true) end
  if midi_inline_editor==1 then reaper.AddRemoveReaScript(true, 32062, reaper.GetResourcePath().."/"..scriptname, true) end
end

function AddMe2() 
  -- this function quits the script and opens script in ide(optionally adding it to the actionlist)
  add_us_api = reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_Ultraschall_API")
  scriptname = reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name")
  idex = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEX"))
  idey = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEY"))
  idew = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEW"))
  ideh = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "IDEH"))
  
  main_sec = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Main"))
  media_explorer= tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_MediaExplorer"))
  midi_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Editor"))
  midi_evtl_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Eventlist-Editor"))
  midi_inline_editor = tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Add_To_Midi-Inline-Editor"))
  
  if add_us_api=="0" then add_us_api=false else add_us_api=true end

  scriptname=ResolveScriptname(scriptname)
  scriptname=string.gsub(scriptname, "\\", "/")
  
  if reaper.file_exists(scriptname)==false then 
    if reaper.file_exists(reaper.GetResourcePath().."/"..scriptname)==false then 
      print2("File "..scriptname.." does not exist, it must be created first!") 
      return 
    end
  end

  retval = ultraschall.MakeCopyOfFile(scriptname, reaper.GetResourcePath().."/Scripts/"..scriptname:match(".*/(.*)"))
  scriptname=reaper.GetResourcePath().."/Scripts/"..scriptname:match(".*/(.*)")
  retval, command_id = ultraschall.EditReaScript(scriptname, add_us_api, nil, idex, idey, idew, ideh)

  if main_sec==1 then A=reaper.AddRemoveReaScript(true, 0, scriptname, true) end
  if media_explorer==1 then A1=reaper.AddRemoveReaScript(true, 32063, scriptname, true) end
  if midi_editor==1 then A2=reaper.AddRemoveReaScript(true, 32060, scriptname, true) end
  if midi_evtl_editor==1 then A3=reaper.AddRemoveReaScript(true, 32061, scriptname, true) end
  if midi_inline_editor==1 then A4=reaper.AddRemoveReaScript(true, 32062, scriptname, true) end
end


function ExitMe() 
  -- this function quits the script
  dockstate, x,y,w,h=gfx.dock(-1,0,0,0,0)

  
  reaper.SetExtState("Ultraschall_API_ScriptCreator", "prefs_x", x, true)
  reaper.SetExtState("Ultraschall_API_ScriptCreator", "prefs_y", y, true)
  
  gfx.quit()
end

function Wildcards()
  local scriptname=ResolveScriptname(reaper.GetExtState("Ultraschall_API_ScriptCreator", "Last_Used_Name"))
  
  scriptname="\""..scriptname.."\""
  
  reaper.MB("With wildcards, you can customize the filename, without having to type in stuff time and again.\n\n  \t$Date - the current date\n  \t$Time - the current time\n  \t$Extstate:value:key - the value of an extstate. \n\t\tThat way, you can change several custom-filenames\n\t\tvia scripts in the background\n\nCurrent scriptname would be resolved as:\n\t"..scriptname, 
  "Scriptfilename-Wildcards", 
  0)
end

-- [[ GUI-element-functions ]]

-- here come the GUI-element functions. If you want to add another GUI-element into the preferences, just use one of these
-- functions to do it.
-- For those elements who can store stuff, you can set a section and key, into which the settings will be stored.
-- They are then stored as ExtStates using SetExtState. To retrieve these settings, use GetExtState in your script.
-- As "section" I used "LeaFac_OBS", and as key the name of the setting.
-- Set some of the values and have a look into reaper-extstate.ini to see, how this looks like. You quickly get the idea.
--
-- Important: it will NOT store them, when nothing has been clicked. So you need to have default-values in your
--            script, in case the user hasn't set any settings yet(in that case, GetExtState returns ""
--            The values returned by GetExtState are always strings, so integers and such must be converted
--            using integervalue=tonumber(value)

-- Now, all functions and an explanation, what they do, how and where they store the settings.
-- Also an explanation of the parameters.

function ManageCheckBox(x, y, section, key, default)
  -- This adds a checkbox. If that checkbox is clicked it will store a 1 into the extstate.
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string section - the section, in which its statechanges shall be stored(for instance LeaFac_OBS)
  --            string key - an explanatory name for the key, in which the value will be stored.
  --            boolean default - if no value is set until now, you can set this to a default in the checkbox to true(checked) or false(unchecked)
  
  local value=tonumber(reaper.GetExtState(section, key))
  if clickstate==true and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+20 and 
    gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if value==1 then
      reaper.SetExtState(section, key, 0, true)
      value=0
    else
      reaper.SetExtState(section, key, 1, true)
      value=1
    end
  end
  if default==false then default=0 else default=1 end
  if value==nil then value=tonumber(default)  end
  
  gfx.set(0.8)
  gfx.rect(x,y,20,20,0)
  gfx.set(1,1,0)
  if value==1 then gfx.rect(x+5, y+5, 10, 10, 1) end
end



function DrawText(x, y, text, mode, tooltip, size)
  -- This displays a text and optionally allows showing a tooltip
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string text - the text, that shall be shown
  --            integer mode - refer gfx.mode for this value
  --            string tooltip - when mouse hovers over text, show this as a tooltip
  --            integer size - the font-size of the text; omit it to use the default one
  --                         - remember, that fontsize on Mac is not the same on Windows.
  --                         - which means, these must be set for both systems individually.
 y=y+1
 if size==nil then 
  size=17
  if not string.match( reaper.GetOS(), "Win") then
     size = math.floor(size * 0.8)
   end
 end
 if mode==nil then mode=0 end
  gfx.set(0.8)
  gfx.x=x
  gfx.y=y
  gfx.setfont(1, "Arial", size, mode)
  gfx.drawstr(text)
  gfx.setfont(1, "Arial", size, 0)
  
  if tooltip~=nil and ShowToolTip==true and ToolTipShown==false and 
    gfx.mouse_x>=x and gfx.mouse_x<=x+gfx.measurestr(text) and
    gfx.mouse_y>=y and gfx.mouse_y<=y+gfx.texth then
    ALLAAAA=os.date()
    local X,Y=reaper.GetMousePosition()
    reaper.TrackCtl_SetToolTip(tooltip, X+15, Y, true) 
    ToolTipShown=true
  end
  mode=oldmode
end

function InputText(x, y, width, section, key, default, InputTitle, InputText, onlynumbers)
  -- This adds a textbox, which, when clicked, opens an input-dialog, into which one can enter the new value.
  -- This value will then be stored as extstate.
  -- If the text exceeds the size of the inputbox, it will be truncated visually. To show the entire text,
  -- just hover above the inputbox and it will show it via tooltip.
  
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            integer width - the shown width of the text-box; shown text might be t
  --            string section - the section, in which it's statechanges shall be stored(for instance LeaFac_OBS)
  --            string key - an explanatory name for the key, in which the value will be stored.
  --            string default - if no value is set until now, you can set this to a default in the inputfield
  --            string InputTitle - this will influence the title of the input-dialog
  --            string InputText - this will influence the text, next to the input-box in the input-dialog
  --            boolean onlynumbers - true, allows only entering numbers; false or nil, any text can be entered

  local value=reaper.GetExtState(section, key)
  if value=="" then value=default end
  if gfx.mouse_x>=x and gfx.mouse_x<=width+x and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if clickstate==true then
      retval, enteredtext = reaper.GetUserInputs(InputTitle, 1, InputText..",extrawidth=350", value)
      if retval==true then
        if onlynumbers==true and tonumber(enteredtext)==nil then
          reaper.MB("Only numbers can be entered in this field!", "Only numbers", 0)
          enteredtext=value
        else
          reaper.SetExtState(section, key, enteredtext, true)
        end
        reaper.JS_Window_SetFocus(gfx_hwnd)
        value=enteredtext
      end
    else
      if ShowToolTip==true and ToolTipShown==false then
        local X,Y = reaper.GetMousePosition()
        reaper.TrackCtl_SetToolTip(value, X+10, Y, true)
        ToolTipShown=true
      end
    end
  end
  gfx.x=x+2
  gfx.y=y+1
  gfx.set(0.17)
  gfx.rect(x-2,y,width,gfx.texth+1,1)
  gfx.set(0.3)
  gfx.rect(x,y+2,width,gfx.texth+1,0)
  gfx.set(0.8)
  gfx.rect(x-1,y+1,width,gfx.texth+1,0)
  gfx.drawstr(value, 0, width+x, y+gfx.texth+1)
end

function InputText_NotDrawn(section, key, default, InputTitle, InputText, onlynumbers)
  -- This adds a textbox, which, when clicked, opens an input-dialog, into which one can enter the new value.
  -- This value will then be stored as extstate.
  -- If the text exceeds the size of the inputbox, it will be truncated visually. To show the entire text,
  -- just hover above the inputbox and it will show it via tooltip.
  
  -- Parameters:
  --            string section - the section, in which it's statechanges shall be stored(for instance LeaFac_OBS)
  --            string key - an explanatory name for the key, in which the value will be stored.
  --            string default - if no value is set until now, you can set this to a default in the inputfield
  --            string InputTitle - this will influence the title of the input-dialog
  --            string InputText - this will influence the text, next to the input-box in the input-dialog
  --            boolean onlynumbers - true, allows only entering numbers; false or nil, any text can be entered

  local value=reaper.GetExtState(section, key)
  if value=="" then value=default end
    retval, enteredtext = reaper.GetUserInputs(InputTitle, 1, InputText..",extrawidth=150", value)
    if retval==true then
      if onlynumbers==true and tonumber(enteredtext)==nil then
        reaper.MB("Only numbers can be entered in this field!", "Only numbers", 0)
        enteredtext=value
      else
        reaper.SetExtState(section, key, enteredtext, true)
      end
      reaper.JS_Window_SetFocus(gfx_hwnd)
      value=enteredtext
  end
--  reaper.JS_Window_SetFocus(gfx_hwnd)
end

function ManageButton(x, y, buttontext, functioncall)
  -- This adds a button, which can be clicked on.
  -- As you might want to have additional functionality associated with that button,
  -- you can write a function that does, what you want. Then pass the name of the function
  -- as parameter functioncall and this function will run it, everytime the button was clicked
  
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            string buttontext - the text of the button
  --            function functioncall - the name of the function that shall be called. Just as it is, NOT as string!
  local clickoffset=0
  local width=gfx.measurestr(buttontext)+20
  if gfx.mouse_cap&1==1 and gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    clickoffset=2
  end

  gfx.set(0.8)
  
  local h=gfx.texth+4
  local r=2
  -- draw roundrectangle(code taken from Lokasenna's Gui Lib, inspired by mwe's EEL-sample
  gfx.set(0)
  x=x+clickoffset
  y=y+clickoffset
  -- Corners
  gfx.circle(x + r,         y + r    , r, 1, aa)      -- top-left
  gfx.circle(x + width - r, y + r    , r, 1, aa)      -- top-right
  gfx.circle(x + width - r, y + h - r, r, 1, aa)      -- bottom-right
  gfx.circle(x + r,         y + h - r, r, 1, aa)      -- bottom-left
  -- Ends
  gfx.rect(x, y + r, r, h - r * 2)
  gfx.rect(x + width - r, y + r, r + 1, h - r * 2)
  -- Body + sides
  gfx.rect(x + r, y, width - r * 2, h + 1)
  
  gfx.set(0.3)
  x=x+1
  y=y+1
  -- Corners
  gfx.circle(x + r,         y + r    , r, 1, aa)      -- top-left
  gfx.circle(x + width - r, y + r    , r, 1, aa)      -- top-right
  gfx.circle(x + width - r, y + h - r, r, 1, aa)      -- bottom-right
  gfx.circle(x + r,         y + h - r, r, 1, aa)      -- bottom-left
  -- Ends
  gfx.rect(x, y + r, r, h - r * 2)
  gfx.rect(x + width - r, y + r, r + 1, h - r * 2)
  -- Body + sides
  gfx.rect(x + r, y, width - r * 2, h + 1)

  gfx.set(0.3)
  x=x-clickoffset-1
  y=y-clickoffset-1
  
  gfx.x=x+clickoffset*2
  gfx.y=y+clickoffset+2
  gfx.set(0)
  gfx.drawstr(buttontext, 1, width+x+2, y+gfx.texth+4)
  gfx.x=x+clickoffset*2
  gfx.y=y+clickoffset+3
  gfx.set(0.8)
  gfx.drawstr(buttontext, 1, width+x+3, y+gfx.texth+6)

  if gfx.mouse_cap&1==0 and OldCap2==1 and 
     gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20 then
     functioncall()
  end
end  


-- [[ Initialization of the GUI-Window and some management functions]]
-- You can mostly ignore the following functions, as they do some management here and there.
-- So best is to leave them untouched.

-- Initialize window and some global variables; leave them untouched
Val=tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "prefs_x")) if Val~=nil then WindowX=Val end
Val=tonumber(reaper.GetExtState("Ultraschall_API_ScriptCreator", "prefs_y")) if Val~=nil then WindowY=Val end


--gfx.init("Create ", WindowWidth, WindowHeight, 0, WindowX, WindowY)
retval, gfx_hwnd = ultraschall.GFX_Init("Create new script", WindowWidth, WindowHeight, 0, WindowX, WindowY)
OldCap=0
OldCap2=0
size=17
if not string.match( reaper.GetOS(), "Win") then
   -- font-size-management on non-Windows-systems, so the font is properly scaled
   size = math.floor(size * 0.8)
end
gfx.setfont(1, "Arial", size, 0)
ToolTipCount=0

function GetMouseState()
  -- This does some mouse-stuff checking and the measuring ot the waittime, until tooltips are shown.
  -- Just leave it as it is.
  if OldMouseX==gfx.mouse_x and OldMouseY==gfx.mouse_y then 
    ToolTipCount=ToolTipCount+1
    if ToolTipCount>ToolTipWaitTime then
      ShowToolTip=true
    else
      ShowToolTip=false
      ToolTipShown=false
    end
  else
    ToolTipCount=0
    reaper.TrackCtl_SetToolTip("", 1, 1, true) 
  end
  OldMouseX=gfx.mouse_x
  OldMouseY=gfx.mouse_y

  -- this returns, if the left-mousebutton has been clicked.
  -- this is used in the main-function. Just leave it there and use its returnvalue, where needed.
  if gfx.mouse_cap&1==1 and OldCap==0 then OldCap=1 return true end
  if gfx.mouse_cap&1==0 and OldCap==1 then OldCap=0 end

  return false
end

function RefreshWindow()
  -- In here, I reset the window for further drawing operations, as well as checking, whether the user hit
  -- enter or esc to close the window.
  -- Just leave it as it is.
  Y=YDefault
  gfx.set(0.1)
  gfx.rect(0,0, gfx.w, gfx.h)
  clickstate=GetMouseState() -- get the clickstate, as needed by several functions
  Key=gfx.getchar()
  if Key==13 then AddMe() end
  if Key==27 then ExitMe() end
  main()
end

RefreshWindow() -- start the magic
