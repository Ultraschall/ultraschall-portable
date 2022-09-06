--[[
################################################################################
#
# Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

------------------------------------------------------
-- Open a URL in a browser - OS agnostic
------------------------------------------------------

function ConsolidateChapterImages()
  function CountProjectValues(section)

    for i = 0, 100 do
      if not reaper.EnumProjExtState (0, section, i) then
        return i
      end
    end
  end

  ------------------------------------------------------
  -- Befindet sich eine position in Nähe eines Markers?
  ------------------------------------------------------

  function NearMarker(position)

    number_of_normalmarkers, normalmarkersarray = ultraschall.GetAllNormalMarkers()
    -- print(number_of_normalmarkers)

    for i = 1, number_of_normalmarkers do

      local marker_position = normalmarkersarray[i][0]

      if position - marker_position < 2 and position - marker_position > -2 then
        return marker_position
      end

    end
    return false

  end



function GetPath(str,sep)
    return str:match("(.*"..sep..")")
end

function GetFileName(url)
	return url:match("^.+/(.+)$")
end

function GetFileExtension(url)
  return url:match("^.+(%..+)$")
end


function GetProjectPath()

	retval, project_path_name = reaper.EnumProjects(-1, "")
	if project_path_name ~= "" then
		dir = GetPath(project_path_name, separator)
		-- name = string.sub(project_path_name, string.len(dir) + 1)
		-- name = string.sub(name, 1, -5)
		-- name = name:gsub(dir, "")
    return dir
  end

end


function ResizeJPG(filename_with_path, outputfilename_with_path, aspectratio, width, height, quality)

  local Identifier, Identifier2, squaresize, NewWidth, NewHeight, Height, Width, Retval, filetype
  filetype = GetFileExtension(filename_with_path)
  if filetype == ".png" then
    Identifier=reaper.JS_LICE_LoadPNG(filename_with_path)
  else
    Identifier=reaper.JS_LICE_LoadJPG(filename_with_path)
  end
  Width=reaper.JS_LICE_GetWidth(Identifier)
  Height=reaper.JS_LICE_GetHeight(Identifier)

  if aspectratio==true then

      squaresize=height
      NewHeight=squaresize
      NewWidth=((100/Height)*Width)
      NewWidth=NewWidth/100
      NewWidth=math.floor(squaresize*NewWidth)
    --end
  else
    NewHeight=height
    NewWidth=width
  end

  Identifier2=reaper.JS_LICE_CreateBitmap(true, NewWidth, NewHeight)
  reaper.JS_LICE_ScaledBlit(Identifier2, 0, 0, NewWidth, NewHeight, Identifier, 0, 0, Width, Height, 1, "COPY")
  Retval=reaper.JS_LICE_WriteJPG(outputfilename_with_path, Identifier2, quality)
  reaper.JS_LICE_DestroyBitmap(Identifier)
  reaper.JS_LICE_DestroyBitmap(Identifier2)
  if Retval==false then ultraschall.AddErrorMessage("ResizeJPG", "outputfilename_with_path", "Can't write outputfile", -9) return false end
end

function exportChapters()

  commandid = reaper.NamedCommandLookup("_ULTRASCHALL_SAVE_CHAPTERS")
  reaper.Main_OnCommand(commandid,0)

end

  ------------------------------------------------------
  -- End of functions
  ------------------------------------------------------


if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then     separator = "\\" else separator = "/" end

  retval = ultraschall.DeleteProjExtState_Section("chapterimages") -- erst mal alles löschen
  retval2 = ultraschall.DeleteProjExtState_Section("lostimages") -- erst mal alles löschen


  ------------------------------------------------------
  -- Schreibe die Kapitelbilder, getrennt nach zugeordnet zu Markern und "lost"
  ------------------------------------------------------

  itemcount = reaper.CountMediaItems(0)

  if itemcount > 0 then
    for i = 0, itemcount-1 do -- gehe alle Items durch

      media_item = reaper.GetMediaItem(0, i)

      take = reaper.GetActiveTake(media_item)
      if take==nil then take=reaper.GetMediaItemTake(media_item, 0) end
      if take~=nil then

          src = reaper.GetMediaItemTake_Source(take)
          filename = reaper.GetMediaSourceFileName(src, "")
          fileformat, supported_by_reaper, mediatype = ultraschall.CheckForValidFileFormats(filename)

          if mediatype == "Image" then

            item_position = ultraschall.GetItemPosition(media_item)

            -- print (ultraschall.GetMarkerByTime(position, true))
            -- if ultraschall.GetMarkerByTime(position, true) ~= "" then  -- da liegt auch ein Marker, alles gut

            position = NearMarker(item_position)

            if position then

              section = "chapterimages"

            else  -- Bild liegt ohne Marker rum
              section = "lostimages"
              position = item_position

            end

            imagecount = reaper.SetProjExtState(0, section, position, filename)
            --reaper.SetExtState(section, position, filename, true) -- nur debugging

          end
      end
    end
  end

  ------------------------------------------------------
  -- Schreibe die URLs der Chapters
  ------------------------------------------------------

  number_of_normalmarkers, normalmarkersarray = ultraschall.GetAllNormalMarkers()
  -- print(number_of_normalmarkers)

  for i = 1, number_of_normalmarkers do

    position = tostring(normalmarkersarray[i][0])
    idx = normalmarkersarray[i][2]
    old_url = ultraschall.GetMarkerExtState(idx, "url")
    if old_url and old_url ~= "" then
      -- print (i .. "-" .. position .. old_url)
      urlcount = reaper.SetProjExtState(0, "chapterurls", position, old_url)
    end

  end
end

function open_url(url)

  local operationSystem = reaper.GetOS()
  if string.match(operationSystem, "OS") then -- Mac
    os.execute("open ".. '\"' .. url .. '\"')
  else
    os.execute("start ".. '\"' .. url .. '\"')
  end
end

------------------------------------------------------
--  Show the GUI menu item. Wird verwendet, um Info-Texte hinter den Buttons anzuzeigen.
------------------------------------------------------

function show_menu(str)

  gfx.x, gfx.y = GUI.mouse.x+20, GUI.mouse.y-10
  selectedMenu = gfx.showmenu(str)
  return selectedMenu

end

------------------------------------------------------
--  führe eine Funktion aus nach Namen
------------------------------------------------------

function run_action(commandID)

  local CommandNumber = reaper.NamedCommandLookup(commandID)
  reaper.Main_OnCommand(CommandNumber,0)

end

------------------------------------------------------
--  Bau den Table mit allen Einträgen der Marker und Bilder auf
------------------------------------------------------

function build_markertable()

  markertable = {}
--  run_action("_Ultraschall_Consolidate_Chapterimages") -- lese alle Images aus und schreibe sie in die ProjExt
  ConsolidateChapterImages()
  number_of_normalmarkers, normalmarkersarray = ultraschall.GetAllNormalMarkers()
  -- print(number_of_normalmarkers)

  for i = 1, number_of_normalmarkers do

    position = tostring(normalmarkersarray[i][0])

    markertable[position] = {}
    markertable[position]["name"] = normalmarkersarray[i][1]
    markertable[position]["idx"] = normalmarkersarray[i][2]
  end

-- Gehe die Bilder mit Kapitelmarke durch

  for i = 0, 100 do

    retval, image_position, image_adress = reaper.EnumProjExtState (0, "chapterimages", i)
    if retval then

      -- markertable[image_position] = {}
      if markertable[image_position] then
        markertable[image_position]["adress"] = image_adress
      end

    else
      break
    end
  end

  -- Gehe die Bilder ohne Marke durch

  for i = 0, 100 do

    retval, image_position, image_adress = reaper.EnumProjExtState (0, "lostimages", i)
    if retval then

      -- print(image_position)
      markertable[image_position] = {}
      markertable[image_position]["adress"] = image_adress

    else
      break
    end
  end


  return markertable

end

------------------------------------------------------
-- Sortiere einen Table nach Index in einen neuen Table
------------------------------------------------------

function makeSortedTable(orig_table)
  tablesort = {}
  for key in pairs(orig_table) do
    table.insert( tablesort, tonumber(key) )
  end
  table.sort(tablesort)
  return tablesort
end

------------------------------------------------------
-- Versetze den Cursor und zentriere den View darauf
------------------------------------------------------

function moveArrangeview(cursor_position)

  actual_cursor = reaper.GetCursorPosition()
  cursor_offset = cursor_position - actual_cursor
  reaper.MoveEditCursor(cursor_offset, false)
  runcommand("_Ultraschall_Center_Arrangeview_To_Cursor")

end

------------------------------------------------------
-- Versetze den Cursor und zeige einen Hilfetext zum einfügen von Bildern an
------------------------------------------------------

function addImage(cursor_position)

  moveArrangeview(cursor_position)
  show_menu("Drag and Drop an image on an empty track at this position")

end


------------------------------------------------------
-- Editiert einen Marker an der Zeitposition
------------------------------------------------------

function editMarker(cursor_position)

  actual_cursor = reaper.GetCursorPosition()
  cursor_offset = cursor_position - actual_cursor
  reaper.MoveEditCursor(cursor_offset, false)
  runcommand(40614)

end

------------------------------------------------------
-- Löscht einen Marker an der Zeitposition
------------------------------------------------------

function deleteMarker(cursor_position)

  actual_cursor = reaper.GetCursorPosition()
  cursor_offset = cursor_position - actual_cursor
  reaper.MoveEditCursor(cursor_offset, false)
  runcommand(40613)

end


------------------------------------------------------
-- Setzt einen Marker an der Zeitposition
------------------------------------------------------

function insertMarker(cursor_position)

  actual_cursor = reaper.GetCursorPosition()
  cursor_offset = cursor_position - actual_cursor
  reaper.MoveEditCursor(cursor_offset, false)
  runcommand("_Ultraschall_Set_NamedMarker")

end

------------------------------------------------------
-- URL editieren: wird über die Subtitles Funktion von Markern (SWS) geregelt
------------------------------------------------------

function editURL(idx)

  old_url = ultraschall.GetMarkerExtState(idx, "url")
  if old_url == nil then
    old_url = ""
  end
  retval, result = reaper.GetUserInputs("Edit Chapter URL", 1, "Begins with http:// or https://,extrawidth=300" , old_url)

  if retval == true then
    if (result:match("https?://(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w%w%w?%w?)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%%#=-]*))")) or result == "" then
      -- new_url = reaper.NF_SetSWSMarkerRegionSub(result, idx) -- write new url
      new_url = ultraschall.SetMarkerExtState(idx, "url", result)
      -- print(new_url)
      -- print(result)
    else
      editURL(idx)
    end


  end
end


-- Round a number to the nearest integer
function round2(num)
  return num % 1 >= 0.5 and math.ceil(num) or math.floor(num)
end


function nextPage()

  if chapter_offset + chapter_pagelength <= #tablesort then
    chapter_offset = chapter_offset + chapter_pagelength
  end
  return chapter_offset

end

function previousPage()

  chapter_offset = chapter_offset - chapter_pagelength
  if chapter_offset < 1 then chapter_offset = 1 end
  return chapter_offset

end



------------------------------------------------------
--  End of functions
------------------------------------------------------


------------------------------------------------------
--  Setze Variablen
------------------------------------------------------


markertable = build_markertable()
tablesort = makeSortedTable(markertable)
rows = #tablesort

maxlines = ultraschall.GetUSExternalState("ultraschall_markerdashboard", "maxlines")

if maxlines == "" then
  local _, _, w, h = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, 0)
  maxlines = round2(h/60)
  retval = ultraschall.SetUSExternalState("ultraschall_markerdashboard", "maxlines", tostring(maxlines))
else
  maxlines = tonumber(maxlines)
end


dir = GetProjectPath()

-- lege ein thumbs Verzeichnis an für Vorschaubilder

if reaper.GetProjectName(0, "") ~= "" then

  thumbsDir = dir.."thumbs"

  if ultraschall.DirectoryExists(dir, "thumbs") ~= true then
    reaper.RecursiveCreateDirectory(thumbsDir, 0)
  end
end



-- print(maxlines.."-"..rows)


if rows < 4 then rows = 4 end -- Minimalhöhe
if rows > maxlines then rows = maxlines end -- Maximalhöhe

WindowHeight = 135 + (rows * 36)


check_text = ""
image_sizes = {}

blankimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/blank.png"
placeholderimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/placeholder.png"
triangle = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/triangle.png"
green = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/glow_green.png"
red = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/glow_red.png"
yellow = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/glow_yellow.png"
add = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/marker_add.png"
trash = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/marker_trash.png"
link = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/marker_link.png"
fillrow = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/MarkerDashboard/fillrow.png"


-- Grab all of the functions and classes from our GUI library

info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
gfx_path = script_path.."/Ultraschall_Gfx/Soundcheck/"
header_path = script_path.."/Ultraschall_Gfx/Headers/"
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall 5 - Marker Dashboard"
GUI.w, GUI.h = 820, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?


-- hole die letzte Fensterposition aus der ultraschall.ini

GUI.x = ultraschall.GetUSExternalState("ultraschall_markerdashboard", "xpos")
GUI.y = ultraschall.GetUSExternalState("ultraschall_markerdashboard", "ypos")

-- Wenn keine gespeichert, positioniere mittig im REAPER-Fenster

if GUI.x == "" or GUI.y == "" then
  l, t, r, b = 0, 0, GUI.w, GUI.h
  __, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
  GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2
end


------------------------------------------------------
--  Aufbau der nicht interkativen GUI-Elemente wie Logos etc.
------------------------------------------------------
marker_update_counter = ultraschall.GetMarkerUpdateCounter()
MarkerUpdateCounter = 0
chapterCount = 0
chapter_offset = 1
chapter_pagelength = maxlines
refresh_gui = true
firstrun = true


function buildGui()


  rebuild_gui = true
  -------------------------
  -- Aufbau der Daten
  -------------------------

  if marker_update_counter ~= ultraschall.GetMarkerUpdateCounter() or MarkerUpdateCounter==5 then
    markertable = build_markertable()

    tablesort = makeSortedTable(markertable)
    ultraschall.RenumerateMarkers(0, 1) -- nur die normalen, keine Edit oder planned
    MarkerUpdateCounter=0

  end

  if marker_update_counter ~= ultraschall.GetMarkerUpdateCounter() then -- Höhe des Fensters nur dann aktualisieren, wenn sich Anzahl der Marker verändert hat
    refresh_gui = true
  end


  marker_update_counter = ultraschall.GetMarkerUpdateCounter()
  MarkerUpdateCounter=MarkerUpdateCounter+1

  -------------------------
  -- Positionen der Spalten
  -------------------------

  pos_status = 753
  pos_url = 537
  pos_image = 460
  pos_name = 55
  pos_position = 380
  pos_headerlogo = 27
  pos_headertxt = pos_headerlogo + 70
  pos_number = 29
  pos_trashbin = 715

  -----------------

  header_height = 42

  -----------------------------------------------------
  -- Die Höhe des Dashboard wurde von NutzerIn geändert
  -----------------------------------------------------

  if gfx.h/dpi_scale ~= WindowHeight and gfx.h > 0 then

    -- print(gfx.h/dpi_scale.."-"..WindowHeight)

    maxlines = round2((gfx.h-(135*dpi_scale))/dpi_scale/36)
    retval = ultraschall.SetUSExternalState("ultraschall_markerdashboard", "maxlines", tostring(maxlines)) -- schreibe die neue Höhe in die ultraschall.ini
    chapter_pagelength = maxlines
    refresh_gui = true

  end


  -----------------------------------------------------
  -- Das Dashboard muss in der Höhe oder Position abgepasst werden
  -----------------------------------------------------

  dockState, xpos, ypos, width, height = gfx.dock(-1, 0, 0, 0, 0) -- hole die aktuelle Position des GFX Fensters

  if firstrun == true then -- beim ersten Aufruf werden die bisherigen Werte genommen
    firstrun = false
  else
    if xpos ~= GUI.x or ypos ~= GUI.y then -- Fenster wurde verschoben, daher neue Werte holen

      GUI.x = xpos
      GUI.y = ypos
      retval = ultraschall.SetUSExternalState("ultraschall_markerdashboard", "xpos", tostring(xpos)) -- schreibe die neue X-Position
      retval = ultraschall.SetUSExternalState("ultraschall_markerdashboard", "ypos", tostring(ypos)) -- schreibe die neue X-Position

    end
  end

  if refresh_gui == true then

    rows = #tablesort

    -- print(maxlines.."-"..rows)
    if rows < 4 then rows = 4 end -- Minimalhöhe
    if rows > maxlines then rows = maxlines end -- Maximalhöhe
    WindowHeight = 135 + (rows * 36)

    gfx.init("", 820, WindowHeight, 0, GUI.x, GUI.y)

    refresh_gui = false

  end






  GUI.elms = {}

  ----------------
  -- Header
  ----------------

  header = GUI.Area:new(0,0,820,header_height,0,1,1,"header_bg")
  table.insert(GUI.elms, header)

  logo = GUI.Pic:new(0,  0,   0,  0,    1,   header_path.."chapters_logo.png")
  table.insert(GUI.elms, logo)

  headertxt = GUI.Pic:new(74,  10,   0,  0,    0.8,   header_path.."headertxt_marker.png")
  table.insert(GUI.elms, headertxt)

  button_help = GUI.FlatBtn:new(724, 12, 75, 20,         " Help", ultraschall.OpenURL, "https://ultraschall.github.io/ultraschall-manual/en/docs/export#1-marker-dashboard")
  table.insert(GUI.elms, button_help)




-- Ende Kopfzeile

----------------------------------------------------------------------------------------------------
-- Zero State - es gibt noch keine Marker, also biete an einen an den Beginn des Projektes zu setzen
----------------------------------------------------------------------------------------------------

  if #tablesort == 0 then

    id = GUI.Lbl:new(400, 120, "There are no chapters yet.", 0)
    table.insert(GUI.elms, id)
    id = GUI.Lbl:new(400, 135, "It is recommendet to have at least one", 0)
    table.insert(GUI.elms, id)
    id = GUI.Lbl:new(400, 150, "at the beginning of a podcast!", 0)
    table.insert(GUI.elms, id)

    id = GUI.Btn:new(230, 120, 150, 45, "Create Chapter", insertMarker, "0")
    table.insert(GUI.elms, id)

  else

  ----------------
  -- Tabellenköpfe
  ----------------

    id = GUI.Lbl:new(pos_status, header_height + 20, "Status", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_number, header_height + 20, "#", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_name, header_height + 20, "Name", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_position, header_height + 20, "Position", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_image-10, header_height + 20, "Image", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_url-22, header_height + 20, "URL", 0, "white")
      table.insert(GUI.elms, id)
  end

  -------------

  position = header_height + 20

  -------------------------
  -- Navigations-Buttons
  -------------------------

  if #tablesort > 0 then

    if chapter_offset < #tablesort - chapter_pagelength + 1 then
      buttonNext = GUI.Btn:new(415, WindowHeight - 30, 80, 20,         " Next >", nextPage, "")
      table.insert(GUI.elms, buttonNext)
    else
      buttonNext = GUI.Btn:new(415, WindowHeight - 30, 80, 20,         " Next >", "", "")
      table.insert(GUI.elms, buttonNext)
    end

    if chapter_offset > chapter_pagelength then
      buttonPrevious = GUI.Btn:new(325, WindowHeight - 30, 80, 20,         " < Previous", previousPage, "")
      table.insert(GUI.elms, buttonPrevious)
    else
      buttonPrevious = GUI.Btn:new(325, WindowHeight - 30, 80, 20,         " < Previous", "", "")
      table.insert(GUI.elms, buttonPrevious)
    end

    buttonExport = GUI.Btn:new(715, WindowHeight - 30, 80, 20,         " Export", exportChapters, "")
    table.insert(GUI.elms, buttonExport)

  end
  ---------------------------------
  -- Schleife durch Marker der Page
  ---------------------------------

  for i = chapter_offset, chapter_offset + chapter_pagelength -1 do

    if tablesort[i] == nil then break end     -- Marker auf der Page sind zu ende
    key = tablesort[i]
    name = markertable[tostring(key)]["name"]

    position = position + 36

    -------------------------
    -- Zeilen-Idikator
    -------------------------

    if reaper.GetCursorPosition() == key then
      rowcolor = "elm_frame"
    else
      rowcolor = "section_bg"
    end

    block = GUI.Area:new(24,position-9,718, 30,5,1,1,rowcolor)
    table.insert(GUI.elms, block)

    -------------------------
    -- Nummer des Markers
    -------------------------

    chapterCount = i
    id = GUI.Lbl:new(pos_number, position, tostring(chapterCount), 0)
    table.insert(GUI.elms, id)

    -------------------------
    -- Trashbin
    -------------------------

    if rowcolor == "elm_frame" and name then
      trashbin = GUI.Pic:new(pos_trashbin, position-6, 25, 25, 1, trash, deleteMarker, key)
    else
      trashbin = GUI.Pic:new(pos_trashbin, position-6, 25, 25, 1, blankimg, moveArrangeview, key)
    end

    table.insert(GUI.elms, trashbin)

    -------------------------
    -- Name des Markers
    -------------------------

    if name and name ~= "" then

      name_displayed = string.sub(name,1,38)
      if #name > 38 then
        name_displayed = name_displayed .. "..."
      end

      id = GUI.Lbl:new(pos_name, position, name_displayed, 0)
      table.insert(GUI.elms, id)
      name_func = editMarker

      check_image = green
      check_text = "Good to go!"

      ----------------------------------
      -- URL - nur wenn Name gesetzt ist
      ----------------------------------

      idx = markertable[tostring(key)]["idx"]
      mkrRgnSubOut = ultraschall.GetMarkerExtState(idx, "url")
      if mkrRgnSubOut == nil then
        mkrRgnSubOut = ""
      end
      url_displayed = string.sub(mkrRgnSubOut,1,26)
      if #mkrRgnSubOut > 26 then
        url_displayed = url_displayed .. "..."
      end

      if mkrRgnSubOut ~= "" then
        url_txt = GUI.Lbl:new(pos_url, position, url_displayed, 0)
        table.insert(GUI.elms, url_txt)
        edit_url = GUI.Pic:new(pos_url, position-5, 200, 25, 1, blankimg, editURL, idx)
        table.insert(GUI.elms, edit_url)
        open_exturl = GUI.Pic:new(pos_url-28, position-5, 25, 25, 1, link, ultraschall.OpenURL, mkrRgnSubOut)
        table.insert(GUI.elms, open_exturl)

      else
        edit_url = GUI.Pic:new(pos_url-28, position-5, 25, 25, 1, add, editURL, idx)
        table.insert(GUI.elms, edit_url)
      end

      if string.len(name) > 62 then
        check_image = red
        check_text = "The title is too long ("..string.len(name)..") - it must be < 63 characters"
      end

    elseif name and name == "" then -- es gibt einen Marker, der hat aber keinen Namen
        id = GUI.Lbl:new(pos_name, position, "[Name missing - click to edit]", 0, "txt_yellow")
        table.insert(GUI.elms, id)
        name_func = editMarker

        check_image = red
        check_text = "Chapters without Name will not be exported."

    else
      id = GUI.Lbl:new(pos_name, position, "[Marker missing - click to create]", 0, "txt_yellow")
      table.insert(GUI.elms, id)
      name_func = insertMarker

      check_image = red
      check_text = "This image needs a marker.|Please move to an existing marker or create a new one."

    end

    editlink = GUI.Pic:new(pos_name-20, position-5, 350, 25, 1, blankimg, name_func, key),
    table.insert(GUI.elms, editlink)

    -------------------------
    -- Position des Markers
    -------------------------

    chapterposition = string.sub(ultraschall.SecondsToTime(key),1,8)
    id = GUI.Lbl:new(pos_position, position, chapterposition, 0)
    table.insert(GUI.elms, id)

    poslink = GUI.Pic:new(pos_position, position-5, 60, 25, 1, blankimg, moveArrangeview, key),
    table.insert(GUI.elms, poslink)

    -------------------------
    -- Image
    -------------------------





    image = markertable[tostring(key)]["adress"]

    if image and reaper.GetProjectName(0, "") == "" and savewarning ~= true then

      Message = "?;MarkerContext;".."Save your project to use chapter images."
      reaper.SetExtState("ultraschall_messages", "message_0", Message, false)
      reaper.SetExtState("ultraschall_messages", "message_count", "1", false)
      savewarning = true

    elseif image and reaper.GetProjectName(0, "") ~= "" then

      img_index = gfx.loadimg(0, placeholderimg)

      if img_index then     -- there is an image

        if not image_sizes[image] then

          image_sizes[image] = {}
          image_test = gfx.loadimg(0, image)
          w, h = gfx.getimgdim(image_test)

          image_sizes[image]["w"] = w
          image_sizes[image]["h"] = h

        else
          w = image_sizes[image]["w"]
          h = image_sizes[image]["h"]
        end

        if w ~= h or w > 1400 or h > 1400 then

          ratio_text = "|This chapter image is not square."
          size_text = "|This chapter image is larger than 1400px."
          proceed_text = "|You may proceed, but it may cause problems in several podcatchers."

          image_warning_text = ""
          if w ~= h then
            image_warning_text = image_warning_text .. ratio_text
          end
          if w > 1400 or h > 1400 then
            image_warning_text = image_warning_text .. size_text
          end

          if check_image == green then -- Grüne OK-Meldung wird ersetzt
            check_image = yellow
            check_text = image_warning_text .. proceed_text
          else
            check_text = check_text .. image_warning_text .. proceed_text -- rote Warnung bleibt bestehen und Gelbe nur angehängt
          end

        end

      end

      -- print (key)
      -- print (GetProjectPath())


      thumbURL = thumbsDir..separator..key..".jpg"

      -- fileformat, supported_by_reaper, mediatype = ultraschall.CheckForValidFileFormats(thumbURL)

      if reaper.file_exists(thumbURL) == false then
        retval = ResizeJPG(image, thumbURL, true, 50, 53, 90)
      end


      img_ratio = 0.5

      imagepreview = GUI.Pic:new(pos_image-8, position-7, 25, 25, img_ratio, thumbURL, ultraschall.OpenURL, image)
      table.insert(GUI.elms, imagepreview)

    elseif name and name ~= "" then -- noch kein Bild zugeordnet

      add_image = GUI.Pic:new(pos_image-8, position-5, 25, 25, 1, add, addImage, key)
      table.insert(GUI.elms, add_image)

    end

    -------------------------
    -- Status
    -------------------------

    if check_image == red then
      state_color = "txt_red"
    elseif check_image == yellow then
      state_color = "txt_yellow"
    else
      state_color = "txt_green"
    end

    light = GUI.Area:new(pos_status,position-4,10,20,3,1,1,state_color)
    table.insert(GUI.elms, light)

    buttonWarning = GUI.Btn:new(pos_status+20, position-4, 20, 20,         " ?", show_menu, check_text)
    table.insert(GUI.elms, buttonWarning)


  end

end


------------------------------------------------------
--  Ende der Funktionen, Beginn Hauptteil
------------------------------------------------------


GUI.func = buildGui   -- Dauerschleife
GUI.freq = 0.3        -- Aufruf jede 1/3 Sekunde


if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows


if reaper.GetPlayState() == 5 then

  Message = "!;ExportContext;".."Stop the recording first to open the Markers Dashboard"

  reaper.SetExtState("ultraschall_messages", "message_0", Message, false) -- nur debugging
  reaper.SetExtState("ultraschall_messages", "message_count", "1", false) -- nur debugging

elseif windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  buildGui()
  GUI.Init()
  GUI.Main()
end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)
