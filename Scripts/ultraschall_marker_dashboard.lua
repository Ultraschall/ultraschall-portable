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

  ------------------------------------------------------
  -- End of functions
  ------------------------------------------------------




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

  local OS=reaper.GetOS()
  if OS=="OSX32" or OS=="OSX64" then
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
  retval, result = reaper.GetUserInputs("Edit Chapter URL", 1, "URL- begins with http:// or https://,extrawidth=300" , old_url)

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

  chapter_offset = chapter_offset + chapter_pagelength
  return chapter_offset

end


function previousPage()

  chapter_offset = chapter_offset - chapter_pagelength
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
local _, _, w, h = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, 0)
maxlines = round2(h/60)

-- print(maxlines.."-"..rows)


if rows < 4 then rows = 4 end -- Minimalhöhe
if rows > maxlines then rows = maxlines end -- Maximalhöhe

WindowHeight = 175 + (rows * 36)


check_text = ""
image_sizes = {}

blankimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/blank.png"
placeholderimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/placeholder.png"
triangle = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/triangle.png"
green = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/glow_green.png"
red = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/glow_red.png"
yellow = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/glow_yellow.png"
add = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/add.png"
link = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/link.png"
fillrow = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/fillrow.png"


-- Grab all of the functions and classes from our GUI library

info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
gfx_path = script_path.."/Ultraschall_Gfx/Soundcheck/"
header_path = script_path.."/Ultraschall_Gfx/Headers/"
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall Marker Dashboard"
GUI.w, GUI.h = 820, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?

------------------------------------------------------
-- position always in the center of the screen
------------------------------------------------------

l, t, r, b = 0, 0, GUI.w, GUI.h
__, __, screen_w, screen_h = reaper.my_getViewport(l, t, r, b, l, t, r, b, 1)
GUI.x, GUI.y = (screen_w - GUI.w) / 2, (screen_h - GUI.h) / 2


  -- body
  ---- GUI Elements ----


------------------------------------------------------
--  Aufbau der nicht interkativen GUI-Elemente wie Logos etc.
------------------------------------------------------
marker_update_counter = ultraschall.GetMarkerUpdateCounter()
MarkerUpdateCounter = 0
chapterCount = 0
chapter_offset = 1
chapter_pagelength = maxlines
refresh_gui = false


function buildGui()

  -- print(chapter_offset)

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
  pos_url = 535
  pos_image = 472
  pos_name = 55
  pos_position = 400
  pos_headerlogo = 27
  pos_headertxt = pos_headerlogo + 70
  pos_number = 29

  -----------------


  if refresh_gui == true then

    rows = #tablesort

    -- print(maxlines.."-"..rows)
    if rows < 4 then rows = 4 end -- Minimalhöhe
    if rows > maxlines then rows = maxlines end -- Maximalhöhe
    WindowHeight = 175 + (rows * 36)

    -- GUI.y = (screen_h - GUI.h) / 2
    -- GUI.y = 300
    gfx.init("", 820, WindowHeight, 0) -- ändere nur die Höhe, aber nicht die Position (!)
    refresh_gui = false

  end


  GUI.elms = {}

  ----------------
  -- Header
  ----------------

  header = GUI.Area:new(0,0,820,90,0,1,1,"header_bg")
  table.insert(GUI.elms, header)

  logo = GUI.Pic:new(pos_headerlogo,  25,   0,  0,    1,   header_path.."chapters_logo.png")
  table.insert(GUI.elms, logo)

  headertxt = GUI.Pic:new(pos_headertxt,  36,   0,  0,    0.8,   header_path.."headertxt_marker.png")
  table.insert(GUI.elms, headertxt)





-- Ende Kopfzeile

----------------------------------------------------------------------------------------------------
-- Zero State - es gibt noch keine Marker, also biete an einen an den Beginn des Projektes zu setzen
----------------------------------------------------------------------------------------------------

  if #tablesort == 0 then

    id = GUI.Lbl:new(400, 180, "There are no chapters yet.", 0)
    table.insert(GUI.elms, id)
    id = GUI.Lbl:new(400, 195, "It is recommendet to have at least one", 0)
    table.insert(GUI.elms, id)
    id = GUI.Lbl:new(400, 210, "at the beginning of a podcast!", 0)
    table.insert(GUI.elms, id)

    id = GUI.Btn:new(230, 180, 150, 45, "Create Chapter", insertMarker, "0")
    table.insert(GUI.elms, id)

  else

  ----------------
  -- Tabellenköpfe
  ----------------

    id = GUI.Lbl:new(pos_status, 120, "Status", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_number, 120, "#", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_name, 120, "Name", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_position, 120, "Position", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_image-10, 120, "Image", 0, "white")
      table.insert(GUI.elms, id)
    id = GUI.Lbl:new(pos_url-22, 120, "URL", 0, "white")
      table.insert(GUI.elms, id)
  end

  -------------

  position = 130

  -------------------------
  -- Navigations-Buttons
  -------------------------

  if chapter_offset < #tablesort - chapter_pagelength + 1 then
    buttonNext = GUI.Btn:new(714, 38, 80, 20,         " Next", nextPage, "")
    table.insert(GUI.elms, buttonNext)
  end

  if chapter_offset > chapter_pagelength then
    buttonPrevious = GUI.Btn:new(610, 38, 80, 20,         " Previous", previousPage, "")
    table.insert(GUI.elms, buttonPrevious)
  end

  ---------------------------------
  -- Schleife durch Marker der Page
  ---------------------------------

  for i = chapter_offset, chapter_offset + chapter_pagelength -1 do

    if tablesort[i] == nil then break end     -- Marker auf der Page sind zu ende
    key = tablesort[i]

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
    -- Name des Markers
    -------------------------

    name = markertable[tostring(key)]["name"]
    if name and name ~= "" then

      name_displayed = string.sub(name,1,40)
      if #name > 40 then
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
      url_displayed = string.sub(mkrRgnSubOut,1,31)
      if #mkrRgnSubOut > 31 then
        url_displayed = url_displayed .. "..."
      end

      if mkrRgnSubOut ~= "" then
        url_txt = GUI.Lbl:new(pos_url, position, url_displayed, 0)
        table.insert(GUI.elms, url_txt)
        edit_url = GUI.Pic:new(pos_url, position-5, 200, 25, 1, blankimg, editURL, idx)
        table.insert(GUI.elms, edit_url)
        open_exturl = GUI.Pic:new(pos_url-28, position-5, 25, 25, 0.5, link, ultraschall.OpenURL, mkrRgnSubOut)
        table.insert(GUI.elms, open_exturl)

      else
        edit_url = GUI.Pic:new(pos_url-28, position-5, 25, 25, 0.5, add, editURL, idx)
        table.insert(GUI.elms, edit_url)
      end


    elseif name and name == "" then
        id = GUI.Lbl:new(pos_name, position, "[Missing - click to edit]", 0)
        table.insert(GUI.elms, id)
        name_func = editMarker

        check_image = red
        check_text = "Chapters without Name will not be exported."

    else
      id = GUI.Lbl:new(pos_name, position, "[Missing - click to edit]", 0)
      table.insert(GUI.elms, id)
      name_func = insertMarker

      check_image = red
      check_text = "Chapters without Name will not be exported."

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
    if image then

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

      img_ratio = 0.5

      imagepreview = GUI.Pic:new(pos_image, position-5, 25, 25, img_ratio, placeholderimg, ultraschall.OpenURL, image)
      table.insert(GUI.elms, imagepreview)

    elseif name and name ~= "" then -- noch kein Bild zugeordnet

      add_image = GUI.Pic:new(pos_image, position-5, 25, 25, 0.5, add, addImage, key)
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
