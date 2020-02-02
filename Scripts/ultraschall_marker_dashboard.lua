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
  run_action("_Ultraschall_Consolidate_Chapterimages") -- lese alle Images aus und schreibe sie in die ProjExt
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


function encodeURI(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
   end
   return str
end


function editURL(idx)

  old_url = reaper.NF_GetSWSMarkerRegionSub(idx)

  --if olll==nil then return end

  retval, result = reaper.GetUserInputs("Edit Chapter URL", 1, "URL:,extrawidth=300" , old_url)

  if retval == true then
    new_url = reaper.NF_SetSWSMarkerRegionSub(result, idx) -- write new url
  end

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
WindowHeight = 60 + (rows * 30) +30
blankimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/blank.png"
placeholderimg = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/placeholder.png"
triangle = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/triangle.png"
green = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/glow_green.png"
red = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/glow_red.png"
add = reaper.GetResourcePath() .. "/Scripts/Ultraschall_Gfx/add.png"

-- Grab all of the functions and classes from our GUI library

info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "ultraschall_gui_lib.lua")

---- Window settings and user functions ----

GUI.name = "Ultraschall Marker Dashboard"
GUI.w, GUI.h = 800, WindowHeight   -- ebentuell dynamisch halten nach Anzahl der Devices-Einträge?

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

function buildGui()

  markertable = build_markertable()
  tablesort = makeSortedTable(markertable)

  GUI.elms = {}

  GUI.elms = {

  --     name          = element type          x    y    w   h  zoom    caption                                                              ...other params...

    label_table      = GUI.Lbl:new(          20, 20,                  "Nr.   Name                                                                              Position    Image    URL                                     Export Check",          0),
  }


  position = 30
  chapterCount = 0

  for _, key in ipairs(tablesort) do

    position = position + 30

    -- Linie
    line1 = GUI.Line:new(0, position-8, 800, position-8, "txt_muted")
    table.insert(GUI.elms, line1)
    line2 = GUI.Line:new(0, position-7, 800, position-7, "elm_outline")
    table.insert(GUI.elms, line2)

    -- Zeilen-Idikator
    if reaper.GetCursorPosition() == key then
      indicator = GUI.Pic:new(1, position-4, 25, 25, 0.5, triangle, "", ""),
      table.insert(GUI.elms, indicator)
    end

    -- Nr.
    chapterCount = chapterCount +1
    id = GUI.Lbl:new(20, position, tostring(chapterCount), 0)
    table.insert(GUI.elms, id)

    -- Name
    name = markertable[tostring(key)]["name"]
    if name and name ~= "" then
      id = GUI.Lbl:new(50, position, name, 0)
      table.insert(GUI.elms, id)
      name_func = editMarker
      green_indicator = GUI.Pic:new(765, position-4, 25, 25, 0.5, green, "", ""),
      table.insert(GUI.elms, green_indicator)


      -- URL - nur wenn Name gesetzt ist

      idx = markertable[tostring(key)]["idx"]
      mkrRgnSubOut = reaper.NF_GetSWSMarkerRegionSub(idx-1)
      url_displayed = string.sub(mkrRgnSubOut,1,31)
      if #mkrRgnSubOut > 31 then
        url_displayed = url_displayed .. "..."
      end

      if mkrRgnSubOut ~= "" then
        url_txt = GUI.Lbl:new(522, position, url_displayed, 0)
        table.insert(GUI.elms, url_txt)
        edit_url = GUI.Pic:new(522, position-5, 200, 25, 1, blankimg, editURL, idx-1),
        table.insert(GUI.elms, edit_url)
      else
        edit_url = GUI.Pic:new(522, position-5, 25, 25, 0.5, add, editURL, idx-1),
        table.insert(GUI.elms, edit_url)
      end




    elseif name and name == "" then
        id = GUI.Lbl:new(50, position, "[Missing - klick to edit]", 0)
        table.insert(GUI.elms, id)
        name_func = editMarker
        red_indicator = GUI.Pic:new(765, position-4, 25, 25, 0.5, red, "", ""),
        table.insert(GUI.elms, red_indicator)

    else
      id = GUI.Lbl:new(50, position, "[Missing - klick to edit]", 0)
      table.insert(GUI.elms, id)
      name_func = insertMarker
      red_indicator = GUI.Pic:new(765, position-4, 25, 25, 0.5, red, "", ""),
      table.insert(GUI.elms, red_indicator)
    end

    editlink = GUI.Pic:new(50, position-5, 200, 25, 1, blankimg, name_func, key),
    table.insert(GUI.elms, editlink)


    -- Position
    chapterposition = string.sub(ultraschall.SecondsToTime(key),1,8)
    id = GUI.Lbl:new(400, position, chapterposition, 0)
    table.insert(GUI.elms, id)

    imagelink = GUI.Pic:new(400, position-5, 60, 25, 1, blankimg, moveArrangeview, key),
    table.insert(GUI.elms, imagelink)

    -- Image

    image = markertable[tostring(key)]["adress"]
    if image then

      img_index = gfx.loadimg(0, placeholderimg)

      --[[

      if img_index then     -- there is an image
        preview_size = 25      -- preview size in Pixel, always square
        w, h = gfx.getimgdim(img_index)
        if w > h then     -- adjust size to the longer border
          img_ratio = preview_size / w
        else
          img_ratio = preview_size / h
        end
      end

      ]]

      img_ratio = 0.5
      -- image_url = encodeURI(image)

      imagepreview = GUI.Pic:new(480, position-5, 25, 25, img_ratio, placeholderimg, open_url, image)
      table.insert(GUI.elms, imagepreview)

    end





  end

end



GUI.func = buildGui -- Dauerschleife
GUI.freq = 0.3         -- Aufruf jede Sekunde



-- Open Soundcheck Screen, when it hasn't been opened yet

if reaper.GetExtState("Ultraschall_Windows", GUI.name) == "" then windowcounter=0 -- Check if window was ever opened yet(and external state for it exists already).  yes, use temporarily 0 as opened windows-counter;will be changed by ultraschall_gui_lib.lua later
else windowcounter=tonumber(reaper.GetExtState("Ultraschall_Windows", GUI.name)) end -- get number of opened windows


if windowcounter<1 then -- you can choose how many GUI.name-windows are allowed to be opened at the same time.
                        -- 1 means 1 window, 2 means 2 windows, 3 means 3 etc

  buildGui()
  GUI.Init()
  GUI.Main()
end

function atexit()
  reaper.SetExtState("Ultraschall_Windows", GUI.name, 0, false)
end

reaper.atexit(atexit)







--[[

for _, key in ipairs(tablesort) do

  print("---")

  output = key
  name = markertable[key]["name"]
  if name then
    output = output .. name
    print ("Name: " .. name)
  end
  adress = markertable[key]["adress"]
  if adress then output = output .. adress end

   -- .. markertable[key]["name"] .. markertable[key]["adress"]
  print (output)

end

]]

-- print(markertable)

-- end
