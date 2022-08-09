dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

--reaper.SetExtState("Ultraschall_Shownotes", "running", "", false)
if reaper.GetExtState("Ultraschall_Shownotes", "running")~="" then return end -- deactivated for now, til NewMarkerInTown works
reaper.SetExtState("Ultraschall_Shownotes", "running", "true", false)

-- TODO:
--  Retina-Support missing

-- [[ Some Custom Settings ]]

-- Default Window position and size:
--    X and Y will be used the first time the preferences are opened
--    when closing the prefs, the prefs remember the position of the window for next time
WindowX     = 30 -- x-position
WindowY     = 30 -- y-position
WindowWidth = 400 -- width of the window
WindowHeight= 370 -- height of the window
WindowTitle = "Edit Shownote Attributes"

ToolTipWaitTime=30 -- the waittime-until tooltips are shown when hovering above them; 30~1 second

YDefault=50          -- The Y-position of the first GUI-Element. So if you want to move all of them lower, raise this value
XOffset=103          -- X-offset of the second element in the gui(usually text inputfields), so you can move the inputfields to the right together
                     -- if an explanation-text becomes too long to be drawn
Indentation1=17      -- The indentation of the attributes
Indentation2=15      -- The indentation of the attributes

-- [[ The following functions can be customized by you ]]

function main()
  -- This function manages all the drawing and positioning of the gui-elements.
  -- If you need more gui-elements, simply add them into here.
  -- All Gui-element-functions like DrawText(), InputText(), ManageCheckBox(), ManageButton() have
  -- a description of their parameters included. Just go to the function-definitions and read their comments.
  
  -- Now, let's add the individual UI-elements
  -- Header
--  Y=Y+10 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
--  DrawText(10, Y, "Edit Shownote Attributes", 85, "", 20) 
  
  NewMarkerInTown()
  
  -- Address - text and inputbox
  --  the length is linked to gfx.w, so it always uses the whole window for display
  Y=Y+11
  DrawText (Indentation1,  Y, "General Attributes", 85, "Set attributes for this shownote")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Title", 0, "The title of this Shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "title", "Enter title of this shownote", "Shownote Title")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Description", 0, "A description for this shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_description", "Describe this shownote", "Shownote Description")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Tags", 0, "Descriptive Tags for this shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_descriptive_tags", "Descriptive Tags for this shownote", "Shownote Description-Tags")

  Y=Y+25 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "Url Attributes", 85, "The url of this shownote")
  Y=Y+19 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Url", 0, "The url of this shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url", "The url of this shownote", "Shownote url")
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Description", 0, "Description of the url of this shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url_description", "Description of the url", "Shownote URL-Description")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Retrieval date yyyy-mm-dd", 0, "Retrieval Date of the url yyyy-mm-dd")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url_retrieval_date", "Retrieval Date of the url", "Shownote url-retrieval date")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Retrieval time hh:mm:ss", 0, "Retrieval Time of the url hh:mm:ss")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url_retrieval_time", "Retrieval Time of the url", "Shownote url-retrieval time")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Retrieval timezone UTC", 0, "Timezone of the retrieval time of the url in UTC")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url_retrieval_timezone_utc", "Timezone of the retrieval time of the url", "Shownote url-retrieval timezone")

  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "Archived copy of original url", 0, "The url of an archived version of the original url")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_url_archived_copy_of_original_url", "Archived url-copy of the url", "Shownote url-copy of original url")

  Y=Y+25 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1,  Y, "Additionals", 85, "Misc Attributes for this Shownote")
  
  Y=Y+20 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  DrawText (Indentation1+Indentation2,  Y, "WikiData-Uri", 0, "The WikiData-uri for the subject of this shownote")
  InputText(100+XOffset , Y, gfx.w-110-XOffset, "shwn_wikidata_uri", "WikiData-uri for this shownote's subject", "WikiData-uri")
  
  -- Is Shownote Advertisement
  --Y=Y+30 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  --ManageCheckBox(100+XOffset-1, Y,   "LeaFac_OBS",              "ALWAYS_CREATE_NEW_TRACK", false)
  --DrawText      (125+XOffset,   Y+2, "Always create new track", 0, "When checked, this will always create a new track when starting recording, so multiple files are always placed into new tracks. When unchecked, all files will be added to the same track.\n\nDefault is unchecked.")
    
  
  -- Check Settings and Done-buttons
  --  these are linked to gfx.w(right side of the window) so they are always aligned to the right-side of the window
  Y=Y+29 -- This holds the position of the next ui-element. I simply add a value, so it stays relative to the one above it.
  ManageButton(gfx.w-66, Y, "Close", QuitMe)
  
  
  
  -- make some mouse-management, run refresh the window again, until the window is closed, otherwise end script
  -- leave it untouched
  if Key~=-1 then OldCap2=gfx.mouse_cap&1 reaper.defer(RefreshWindow) end
end


function NewMarkerInTown()
  -- shall be used to have:
  --    1 Dialog open, that refreshes, if the dialog shall open for another marker.
  --    that way, you can use the edit-shownote-action without having thousands of edit-shownote-attributes-windows open
  --    easier that way
  --    can I add left-clicking to the menu for this too?
  -- deactivated for now...
  --if lol==nil then return end
  marker_id, guid = ultraschall.GetTemporaryMarker()
  ultraschall.StoreTemporaryMarker(-1)
  if marker_id==-1 then 
    marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
    retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
  end
  
  index2 = ultraschall.GetShownoteMarkerIDFromGuid(guid)
  if index2==-1 then return else index=index2 ultraschall.StoreTemporaryMarker(-1) return true end
end


-- [[ Custom Button functions ]]
--
-- here are some custom-functions used by the buttons.
-- If you want to add additional buttons, add their accompanying functions in this section

function GetShownoteAttributes()
  marker_id, guid = ultraschall.GetTemporaryMarker()
  ultraschall.StoreTemporaryMarker(-1)
  if marker_id==-1 then 
    marker_id = reaper.GetLastMarkerAndCurRegion(0, reaper.GetCursorPosition())
    retval, guid=reaper.GetSetProjectInfo_String(0, "MARKER_GUID:"..marker_id, "", false)
  end
  
  index = ultraschall.GetShownoteMarkerIDFromGuid(guid)
  if index==-1 then return end
  
  retval, marker_index, pos, name, shown_number, guid = ultraschall.EnumerateShownoteMarkers(index)  
  
  InitWindow()
  RefreshWindow() -- start the magic
end


function QuitMe() 
  -- this function quits the script
  local dockstate, x,y,w,h=gfx.dock(-1,0,0,0,0)
  reaper.SetExtState("Ultraschall_Shownotes", "Edit_Shownotes_x", x, true)
  reaper.SetExtState("Ultraschall_Shownotes", "Edit_Shownotes_y", y, true)
  reaper.SetExtState("Ultraschall_Shownotes", "running", "", false)
  
  gfx.quit()
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
  --            string section - the section, in which it's statechanges shall be stored(for instance LeaFac_OBS)
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
 if size==nil then 
  size=16
  if not string.match( reaper.GetOS(), "Win") then
     size = math.floor(size * 0.8)
   end
 end
 if mode==nil then mode=0 end
  gfx.set(0.8)
  gfx.x=x
  gfx.y=y+1
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

function InputText(x, y, width, attributename, InputTitle, InputText, onlynumbers)
  -- This adds a textbox, which, when clicked, opens an input-dialog, into which one can enter the new value.
  -- This value will then be stored as extstate.
  -- If the text exceeds the size of the inputbox, it will be truncated visually. To show the entire text,
  -- just hover above the inputbox and it will show it via tooltip.
  
  -- Parameters:
  --            integer x - the x-position in pixels
  --            integer y - the x-position in pixels
  --            integer width - the shown width of the text-box; shown text might be t
  --            string attributename - the attributename to set for this shownote-attribute
  --            string InputTitle - this will influence the title of the input-dialog
  --            string InputText - this will influence the text, next to the input-box in the input-dialog
  --            boolean onlynumbers - true, allows only entering numbers; false or nil, any text can be entered

  --local value=--reaper.GetExtState(section, key)
  local retval, value
  if attributename=="title" then
    retval, marker_index, pos, value, shown_number, guid = ultraschall.EnumerateShownoteMarkers(index)
  else
    retval, value = ultraschall.GetSetShownoteMarker_Attributes(false, index, attributename, "")
  end
--  SLEM()
--  print2(value)
  --if value=="" then value=default end
  if gfx.mouse_x>=x and gfx.mouse_x<=x+width and 
     gfx.mouse_y>=y and gfx.mouse_y<=y+20
    then
    if clickstate==true then
      retval, enteredtext = reaper.GetUserInputs(InputTitle, 1, InputText..",separator=\b,extrawidth=150", value)
      if retval==true then
        if onlynumbers==true and tonumber(enteredtext)==nil then
          reaper.MB("Only numbers can be entered in this field!", "Only numbers", 0)
          enteredtext=value
        else
          if attributename=="title" then
            local retval = ultraschall.SetShownoteMarker(index, pos, enteredtext)
          else
            local retval, value = ultraschall.GetSetShownoteMarker_Attributes(true, index, attributename, enteredtext)
          end
        end
        value=enteredtext
      end
    else
      if ShowToolTip==true and ToolTipShown==false then
        local X,Y = reaper.GetMousePosition()
        reaper.TrackCtl_SetToolTip(InputTitle, X+10, Y, true)
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
function InitWindow()
  Valx=tonumber(reaper.GetExtState("Ultraschall_Shownotes", "Edit_Shownotes_x")) if Valx~=nil then WindowX=Valx end
  Valy=tonumber(reaper.GetExtState("Ultraschall_Shownotes", "Edit_Shownotes_y")) if Valy~=nil then WindowY=Valy end
  
  
  --gfx.init(WindowTitle, WindowWidth, WindowHeight, 0, WindowX, WindowY)
  retval, hwnd = ultraschall.GFX_Init(WindowTitle, WindowWidth, WindowHeight, 0, WindowX, WindowY)
  --AA,AA2=reaper.JS_Window_SetStyle(hwnd, "CAPTION")
  OldCap=0
  OldCap2=0
  size=16
  if not string.match( reaper.GetOS(), "Win") then
     -- font-size-management on non-Windows-systems, so the font is properly scaled
     size = math.floor(size * 0.8)
  end
  gfx.setfont(1, "Arial", size, 0)
  ToolTipCount=0
end

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
  gfx.set(0.1725)
  gfx.rect(0, 0, gfx.w, gfx.h)
  gfx.set(0.145)
  gfx.rect(0, 0, gfx.w, 42)
  gfx.x=0
  gfx.y=0
  gfx.blit(1,1,0)
  gfx.x=74
  gfx.y=12
  gfx.blit(2,0.7,0)
  clickstate=GetMouseState() -- get the clickstate, as needed by several functions
  Key=gfx.getchar()
  if Key==-1 or Key==13 or Key==27 then QuitMe() end
  main()
end

OldGetUserInputs=reaper.GetUserInputs

function reaper.GetUserInputs(...)
  local old = ultraschall.GetUSExternalState("modal_pos", "DLG436", "reaper-wndpos.ini")
  local windowposx, windowposy=reaper.GetMousePosition()
  local retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", windowposx.." "..windowposy, "reaper-wndpos.ini")
  local A,B=OldGetUserInputs(table.unpack({...}))
  local retval = ultraschall.SetUSExternalState("modal_pos", "DLG436", old, "reaper-wndpos.ini")
  return A,B
end

--ultraschall.StoreTemporaryMarker(1)--debug line!!
gfx.loadimg(1, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/edit_shownotes.png")
gfx.loadimg(2, reaper.GetResourcePath().."/Scripts/Ultraschall_Gfx/Headers/headertxt_edit_shownotes.png")


GetShownoteAttributes()


