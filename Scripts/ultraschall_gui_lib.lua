--[=[
  GUI Tutorial - LS GUI library demonstration
  by Lokasenna

  Provides functions and classes for adding a GUI to another LUA script.

  NOTE: This file is just a proof-of-concept demo, meant to accompany the
  tutorial thread here: http://forum.cockos.com/showthread.php?t=176662

  It's a little sloppy, probably has a few bugs, and definitely could do things
  much more efficiently. I would not suggest using it for a script intended
  for use by other people. A proper "release" version is forthcoming.




  Scripts using this should include the following block at the top of the file:


-- Grab everything from our GUI library
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
GUI = dofile(script_path .. "LS GUI.lua")


  All of the functions in this file can then be called like so:

  local newcolor = GUI.rgb2num(255, 192, 128)
           ^^^^



  To create the GUI elements, create a table in your script called GUI.elms
  and populate it like so

GUI.elms = {

  item1 = type:New(parameters),
  item2 = type:New(parameters),
  item3 = type:New(parameters),
  ...etc...

}

  See the :New method for each element below for a listing of its parameters


  For a working example, see the file "GUI Tutorial - LS GUI usage demo.lua"
  that should be included alongside this script.

]=]--



-- Create a master table to store all of our functions
-- After each function we'll read it into the table with:
--  GUI.xxx = xxx
local GUI = {}


retval, dpi = reaper.ThemeLayout_GetLayout("tcp", -3)
if dpi == "512" then
  dpi_scale = 2
  gfx.ext_retina = 1
else
  dpi_scale = 1
end


--[[  Font and color presets

  Can be set using the accompanying functions GUI.font
  and GUI.color. i.e.

  GUI.font(2)        applies the Header preset
  GUI.color("elm_fill")  applies the Element Fill color preset

  Colors are converted from 0-255 to 0-1 when GUI.Init() runs,
  so if you need to access the values directly at any point be
  aware of which format you're getting in return.

]]--

if reaper.GetOS()=="OSX32" or reaper.GetOS()=="OSX64" then
  font_size = 14 * dpi_scale
  font_size2 = 20 * dpi_scale
  font_face = "Helvetica"
else
  font_size = 16 * dpi_scale
  font_size2 = 22 * dpi_scale
  font_face = "Arial"
end

GUI.fonts = {

  {font_face, font_size},  -- 1. Title
  {font_face, font_size2},  -- 2. Header
  {font_face, font_size},  -- 3. Label
  {font_face, font_size}  -- 4. Value

}

GUI.colors = {

  wnd_bg = {44, 44, 44, 1},      -- Window BG
  elm_bg = {48, 48, 48, 1},      -- Element BG
  sld_bg = {60, 60, 60, 1},    -- Slider Background
  elm_frame = {70, 70, 70, 1},    -- Element Frame
  elm_highlight = {100, 100, 100, 1},    -- Element Highlight
  elm_fill = {200, 130, 64, 1},    -- Element Fill
  elm_outline = {32, 32, 32, 1},
  txt = {200, 200, 200, 1},      -- Text
  txt_green = {80, 250, 80, 1},      -- Text green
  txt_red = {250, 40, 40, 1},      -- Text red
  txt_yellow = {250, 250, 40, 1},      -- Text red
  txt_muted = {100, 100, 100, 1},      -- Text dark grey
  header_bg = {60, 60, 60, 1},    -- Header Background
  section_bg = {52, 52, 52, 1},    -- Header Background

  shadow = {0, 0, 0, 0.6}        -- Shadow. Don't call this with GUI.color

}

GUI.font = function (fnt)
  gfx.setfont(1, table.unpack(GUI.fonts[fnt]))
end

GUI.color = function (col)
  gfx.set(table.unpack(GUI.colors[col]))
end

-- A size setting for any elements using shadows
GUI.shadow_dist = 1

-- Draw the given string with a shadow
GUI.shadow = function (str)

  local x, y = gfx.x, gfx.y

  GUI.color("shadow")
  for i = 1, GUI.shadow_dist do
    gfx.x, gfx.y = x + i, y + i
    gfx.drawstr(str)
  end

  GUI.color("txt")
  gfx.x, gfx.y = x, y
  gfx.drawstr(str)

end


-- Initialize some mouse values
GUI.mouse = {

  x = 0,
  y = 0,
  cap = 0,
  down = false,
  wheel = 0

}

-- For use with external user functions. Returns the given element's current value or, if specified, sets a new one.
GUI.Val = function (elm, newval)

  if newval then
    GUI.elms[elm]:val(newval)
  else
    return GUI.elms[elm]:val()
  end

end


  ---- General functions ----


-- Print stuff to the Reaper console. For debugging purposes.
local function Msg(message)
  reaper.ShowConsoleMsg(tostring(message).."\n")
end
GUI.Msg = Msg


-- Take discrete RGB values and return the combined integer
-- (equal to hex colors of the form 0xRRGGBB)
local function rgb2num(red, green, blue)

  green = green * 256
  blue = blue * 256 * 256

  return red + green + blue

end
GUI.rgb2num = rgb2num


-- Convert a number to hexadecimal
local function num2hex(num)

    local hexstr = '0123456789abcdef'
    local s = ''

    while num > 0 do
      local mod = math.fmod(num, 16)
      s = string.sub(hexstr, mod+1, mod+1) .. s
      num = math.floor(num / 16)
    end

    if s == '' then s = '0' end
    return s

end
GUI.num2hex = num2hex


-- Convert a hex color to integers r,g,b
local function hex2rgb(num)

  if string.sub(num, 1, 2) == "0x" then
    num = string.sub(num, 3)
  end

  local red = string.sub(num, 1, 2)
  local blue = string.sub(num, 3, 4)
  local green = string.sub(num, 5, 6)

  red = tonumber(red, 16)
  blue = tonumber(blue, 16)
  green = tonumber(green, 16)

  return red, green, blue

end
GUI.hex2rgb = hex2rgb


-- Round a number to the nearest integer
local function round(num)
    return num % 1 >= 0.5 and math.ceil(num) or math.floor(num)
end
GUI.round = round


-- Improved roundrect() function with fill, adapted from mwe's EEL example.
local function roundrect(x, y, w, h, r, antialias, fill)

  local aa = antialias or 1
  fill = fill or 0

  if fill == 0 or false then
    gfx.roundrect(x, y, w, h, r, aa)
  elseif h >= 2 * r then

    -- Corners
    gfx.circle(x + r, y + r, r, 1, aa)      -- top-left
    gfx.circle(x + w - r, y + r, r, 1, aa)    -- top-right
    gfx.circle(x + w - r, y + h - r, r , 1, aa)  -- bottom-right
    gfx.circle(x + r, y + h - r, r, 1, aa)    -- bottom-left

    -- Ends
    gfx.rect(x, y + r, r, h - r * 2)
    gfx.rect(x + w - r, y + r, r + 1, h - r * 2)

    -- Body + sides
    gfx.rect(x + r, y, w - r * 2, h + 1)

  else

    r = h / 2 - 1

    -- Ends
    gfx.circle(x + r, y + r, r, 1, aa)
    gfx.circle(x + w - r, y + r, r, 1, aa)

    -- Body
    gfx.rect(x + r, y, w - r * 2, h)

  end

end
GUI.roundrect = roundrect


-- Improved triangle() function with optional non-fill
local function triangle(fill, ...)

  -- Pass any calls for a filled triangle on to the original function
  if fill == 1 then

    gfx.triangle(...)

  else

    -- Store all of the provided coordinates into an array
    local coords = {...}

    -- Duplicate the first pair at the end, so the last line will
    -- be drawn back to the starting point.
    coords[#coords + 1] = coords[1]
    coords[#coords + 1] = coords[2]

    -- Draw a line from each pair of coords to the next pair.
    for i = 1, #coords - 2, 2 do

      gfx.line(coords[i], coords[i+1], coords[i+2], coords[i+3])

    end

  end

end
GUI.triangle = triangle

--[[
  Takes an angle in radians (leave out pi) and a radius, returns x, y
  Will return coordinates relative to an origin of 0, or absolute
  coordinates if an origin point is specified
]]--
local function polar2cart(angle, radius, ox, oy)

  local angle = angle * math.pi
  local x = radius * math.cos(angle)
  local y = radius * math.sin(angle)


  if ox and oy then x, y = x + ox, y + oy end

  return x, y

end


-- Are these coordinates inside the given element?
local function IsInside(elm, x, y)

  local inside =
    x >= elm.x and x < (elm.x + elm.w) and
    y >= elm.y and y < (elm.y + elm.h)

  return inside

end
GUI.IsInside = IsInside




  ---- Our main functions ----


function Init()

  -- Create the window
  gfx.clear = GUI.rgb2num(table.unpack(GUI.colors.wnd_bg))
  gfx.init(GUI.name, GUI.w, GUI.h, 0, GUI.x, GUI.y)  -- 0 means "undocked", 1 would dock it in the first dock position (Mixer)

-- mespotine hack
-- If a window is opened, there is a new external state written:
-- [Ultraschall_Windows]
-- GUI.name = number of windows
--
-- example - if one colorpicker window is open
-- [Ultraschall_Windows]
-- Ultraschall Color Picker = 1.0
--
-- example - if no(!) colorpicker window is open
-- [Ultraschall_Windows]
-- Ultraschall Color Picker = 0.0
--
-- example - if ten colorpicker windows are open
-- [Ultraschall_Windows]
-- Ultraschall Color Picker = 10.0
--
-- if colorpicker window wasn't opened yet or there is a nil value, or the number of open windows is "negative" in the external states, it will revert to 0 first, before counting up and opening a new window

windownumber=reaper.GetExtState("Ultraschall_Windows",GUI.name)
if windownumber=="" then windownumberint=0
else windownumberint=tonumber(windownumber) end

if windownumberint<=0 then windownumberint=0 end

-- reaper.MB(tostring(windownumberint),"GUI"..GUI.name,0)
windownumberint=windownumberint+1
-- reaper.MB(tostring(windownumberint),"GUI"..GUI.name,0)
reaper.SetExtState("Ultraschall_Windows",GUI.name,windownumberint,true)


  -- Initialize any variables that are necessary
  GUI.last_time = 0

  -- Convert color presets from 0..255 to 0..1
  for i, col in pairs(GUI.colors) do
    col[1], col[2], col[3] = col[1] / 255, col[2] / 255, col[3] / 255
  end

end

GUI.Init = Init


function Main()


  -- Update mouse and keyboard state
  GUI.mouse.x, GUI.mouse.y = gfx.mouse_x, gfx.mouse_y
  GUI.mouse.cap = gfx.mouse_cap
  GUI.char = gfx.getchar()

  --  (Escape key)  (Window closed)
  if GUI.char == 27       -- escape
  or GUI.char == 26164.0  -- alt+f4
  or GUI.char == 23.0     -- cmd+w(?)
  or GUI.char == -1 then  -- window is closed by the user
  windownumber=reaper.GetExtState("Ultraschall_Windows",GUI.name)
--  reaper.MB(windownumber,"pre",0)
    reaper.SetExtState("Ultraschall_Windows",GUI.name,windownumber-1,true)
    abort = true
-- reaper.MB(reaper.GetExtState("Ultraschall_Windows",GUI.name),"post",0)
    return 0
  else
    reaper.defer(GUI.Main)
  end

  -- Update each element
  for key, elm in pairs(GUI.elms) do
    GUI.Update(elm)
  end

  -- If the user gave us a function to run, check
  -- to see if it needs to be run again, and do so.
  if GUI.func then

    GUI.freq = GUI.freq or 1

    local new_time = reaper.time_precise()
    if new_time - GUI.last_time >= GUI.freq then
      GUI.func()
      GUI.last_time = new_time

    end
  end


  gfx.update()

end

GUI.Main = Main





function Update(elm)

  local x, y = GUI.mouse.x, GUI.mouse.y
  local char = GUI.char

  -- Left button down
  if GUI.mouse.cap&1==1 then

    -- If it wasn't down already...
    if not GUI.mouse.down then



      -- Was a different element clicked?
      if not IsInside(elm, x, y) or elm.type == "Area" then -- Area darf nicht klickbare Elemente überdecken

        elm.focus = false

      else

        -- print(elm.type)

      GUI.mouse.down = true
      GUI.mouse.ox, GUI.mouse.oy = x, y
      GUI.mouse.lx, GUI.mouse.ly = x, y
      elm.focus = true
      elm:onmousedown()


      end

      -- Double clicked?
      if GUI.mouse.uptime and reaper.time_precise() - GUI.mouse.uptime < 0.15 then
        elm:ondoubleclick()
      end

    --     Dragging?                   Did the mouse start out in this element?
    elseif (x ~= GUI.mouse.lx or y ~= GUI.mouse.ly) and IsInside(elm, GUI.mouse.ox, GUI.mouse.oy) then

      if elm.focus ~= nil then elm:ondrag() end

      GUI.mouse.lx, GUI.mouse.ly = x, y

    end

  -- If it was originally clicked in this element and has now been released
  elseif GUI.mouse.down and IsInside(elm, GUI.mouse.ox, GUI.mouse.oy) and elm.type ~= "Area" then -- Area darf nicht klickbare Elemente überdecken

    elm:onmouseup()
    GUI.mouse.down = false
    GUI.mouse.ox, GUI.mouse.oy = -1, -1
    GUI.mouse.lx, GUI.mouse.ly = -1, -1
    GUI.mouse.uptime = reaper.time_precise()

  end

  -- If the element is in focus and the user typed something
  if elm.focus and char ~= 0 then elm:ontype(char) end

  -- Draw the element
  elm:draw()

end

GUI.Update = Update





  ---- Element classes ----


--[[  ColorPic class.

  ---- User parameters ----
x, y      Coordinates of top-left corner
w, h       width and height
t         table with color values

]]--

-----------------------------------------------------------------------------
-- Area - New

local Area = {}
function Area:new(x, y, w, h, r, antialias, fill, color)

  local roundarea = {}
  roundarea.type = "Area"
  roundarea.x, roundarea.y, roundarea.w, roundarea.h, roundarea.r = x * dpi_scale
  , y * dpi_scale
  , w * dpi_scale
  , h * dpi_scale
  , r * dpi_scale
  roundarea.antialias = antialias
  roundarea.fill = fill
  roundarea.color = color or "txt"
  roundarea.focus = false

  setmetatable(roundarea, self)
    self.__index = self
    return roundarea

end

-- Area - Draw
function Area:draw()

  GUI.color(self.color)
  GUI.roundrect(self.x, self.y, self.w, self.h, self.r, self.antialias, self.fill)

end

-- Area - Unused methods.

function Area:onmousedown() end
function Area:onmouseup() end
function Area:ondoubleclick() end
function Area:ondrag() end
function Area:ontype() end

GUI.Area = Area


---------------------------------------------------------

-----------------

-- ColorPic - New
local ColorPic = {}
function ColorPic:new(x, y, w, h, t)

  local colorpicker = {}
  colorpicker.type = "ColorPic"
  colorpicker.table = t
  colorpicker.x, colorpicker.y, colorpicker.w, colorpicker.h = x * dpi_scale
  , y * dpi_scale
  , w * dpi_scale
  , h * dpi_scale

  colorpicker.num = 20
  colorpicker.state = 0

  setmetatable(colorpicker, self)
    self.__index = self
    return colorpicker

end


-- ColorPic - Zeichnen

function ColorPic:draw()
  local key, value, r , g ,b = ""
  local offset = 0
  local x, y, table = self.x, self.y, self.table
  for i=0, self.num-1, 1  do
    r, g, b = reaper.ColorFromNative(table[i])
    gfx.set(r/255, g/255, b/255, 1)
    GUI.roundrect(x + offset*44 * dpi_scale
    , y, 40 * dpi_scale
    , 30 * dpi_scale
    , 2 * dpi_scale
    , 1 * dpi_scale
    , 1 * dpi_scale
  )
    if offset == 3 then
      offset = 0
      y = y + 34 * dpi_scale

    else
      offset = offset + 1

    end
  end
end

-- ColorPic - Mouseclick

function ColorPic:onmousedown()
  -- If the button was released on the button, run func
  GUI.mouse.x = GUI.mouse.x / dpi_scale
  GUI.mouse.y = GUI.mouse.y / dpi_scale

  if IsInside(self, GUI.mouse.x, GUI.mouse.y) then
    col = (GUI.mouse.x+20) / 44 - 1
    col = GUI.round(col)
    row = GUI.round((GUI.mouse.y+16) / 34 -1)

    colnumber = col + 4 * row
    if colnumber < 0 then colnumber = 0 end
    if colnumber > 19 then colnumber = 19 end
    -- GUI.Msg(colnumber)
    col = self.table[colnumber]
    -- GUI.Msg(col)

    ----------------------------------
    -- step 3: assign colors to tracks
    ----------------------------------
    nothingselected = false
    countTracks = reaper.CountSelectedTracks(0)
    countItems = reaper.CountSelectedMediaItems(0)

    if countTracks == 0 and countItems == 0 then  -- no track or items selected
      nothingselected = true
        reaper.Main_OnCommand(40296,0)         -- select all tracks
        countTracks = reaper.CountSelectedTracks(0)
    end

    reaper.Undo_BeginBlock()
    if countTracks > 0 then -- SELECTED TRACKS LOOP
        for j = 0, countTracks-1 do
            track = reaper.GetSelectedTrack(0, j)
          reaper.SetTrackColor (track, col) --set Color to track
        end
    end

     if countItems > 0 then -- SELECTED ITEMS LOOP
        for j = 0, countItems-1 do
            item = reaper.GetSelectedMediaItem(0, j)
          reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", col|16777216)
          reaper.UpdateArrange()
        end
    end

    if nothingselected == true then        -- restore selection state
      reaper.Main_OnCommand(40297,0)         -- unselect all tracks
    end

    reaper.Undo_EndBlock("Ultraschall Color Picker", 1)

  end
end

-- ColorPic - Unused methods.

function ColorPic:onmouseup() end
function ColorPic:ondoubleclick() end
function ColorPic:ondrag() end
function ColorPic:ontype() end

GUI.ColorPic = ColorPic


function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

  ---- Element classes ----


--[[  Pic class.

  ---- User parameters ----
x, y      Coordinates of top-left corner
source      Image Source
action       onclick action

]]--



-----------------

-- picture - New
local Pic = {}
function Pic:new(x, y, w, h, zoom, source, func, ... )

  local picture = {}
  picture.type = "Pic"

  picture.x, picture.y = x * dpi_scale, y * dpi_scale
  picture.w, picture.h = w * dpi_scale, h * dpi_scale

  local cap = source:match("(.+)%..+")
  retina_img = cap.."_x2"..".png"

  if dpi_scale == 2 and file_exists(retina_img) then
    picture.zoom = zoom
    picture.source = retina_img
  else
    picture.zoom = zoom * dpi_scale
    picture.source = source
  end



  picture.func = func
  picture.params = {...}

  setmetatable(picture, self)
    self.__index = self
    return picture

end


-- picture - Draw
function Pic:draw()

  local x, y, zoom = self.x, self.y, self.zoom

  buffer_id = 0 -- top layer
  loadimg = gfx.loadimg(buffer_id, self.source)
  gfx.x, gfx.y = x, y
  gfx.blit(buffer_id,zoom,0)

end


function Pic:onmousedown()
  if self.func and self.func ~= "" then
    if IsInside(self, GUI.mouse.x, GUI.mouse.y) then
      self.func(table.unpack(self.params))
    end
  end
end


-- picture - Unused methods.

function Pic:onmouseup() end
function Pic:ondoubleclick() end
function Pic:ondrag() end
function Pic:ontype() end


GUI.Pic = Pic




  ---- Element classes ----


--[[  SubPic class.

  ---- User parameters ----
x, y      Coordinates of top-left corner
source      Image Source
action       onclick action

]]--


-----------------

-- picture - New
local Subpic = {}
function Subpic:new(x, y, w, h, zoom, source, offset_x, offset_y, ... )

  local picture = {}
  picture.type = "Subpic"

  picture.x, picture.y = x , y  * dpi_scale
  picture.w, picture.h = w , h
  picture.offset_x, picture.offset_y = offset_x
  , offset_y
  picture.zoom = zoom * dpi_scale
  picture.source = source
  picture.params = {...}

  setmetatable(picture, self)
    self.__index = self
    return picture

end


-- picture - Draw
function Subpic:draw()

  local x, y, zoom, w, h, offset_x, offset_y = self.x, self.y, self.zoom, self.w, self.h, self.offset_x, self.offset_y

  buffer_id = 0 -- top layer
  loadimg = gfx.loadimg(buffer_id, self.source)
  gfx.x, gfx.y = x, y
  gfx.blit(buffer_id,zoom,0, offset_x, offset_y, w, h)

end


-- picture - Unused methods.

function Subpic:onmousedown() end
function Subpic:onmouseup() end
function Subpic:ondoubleclick() end
function Subpic:ondrag() end
function Subpic:ontype() end


GUI.Subpic = Subpic


--[[  Line class.

  ---- User parameters ----
x, y      Coordinates of top-left corner
x2, y2      Coordinates for the end

]]--


-----------------

-- picture - New
local Line = {}
function Line:new(x, y, x2, y2, color)

  local drawline = {}
  drawline.type = "Line"
  drawline.x, drawline.y = x * dpi_scale, y * dpi_scale
  drawline.x2, drawline.y2 = x2 * dpi_scale, y2 * dpi_scale
  drawline.w, drawline.h = 1 * dpi_scale, 1 * dpi_scale
  drawline.color = color or "txt"

  setmetatable(drawline, self)
    self.__index = self
    return drawline

end


-- picture - Draw
function Line:draw()

  local x, y, x2, y2 = self.x, self.y, self.x2, self.y2

  buffer_id = 0 -- top layer
  gfx.x, gfx.y = x, y
  GUI.color(self.color)
  gfx.line(x,y,x2,y2)

end

-- Line - Unused methods.

function Line:onmousedown() end
function Line:onmouseup() end
function Line:ondoubleclick() end
function Line:ondrag() end
function Line:ontype() end

GUI.Line = Line


-----------------

-- Lbl - New
local Lbl = {}
function Lbl:new(x, y, caption, shadow, color, size)


  local label = {}
  label.type = "Lbl"
  label.color = color or "txt"
  label.x, label.y = x * dpi_scale, y * dpi_scale
  label.size = size or 1

  -- Placeholders for these values, since we don't need them
  -- but some functions will throw a fit if they aren't there
  label.w, label.h = 0, 0

  label.caption = caption

  label.shadow = shadow or 0

  setmetatable(label, self)
    self.__index = self
    return label

end


-- Lbl - Draw
function Lbl:draw()

  local x, y = self.x, self.y

  GUI.font(self.size)

  -- Shadow
  if self.shadow ~= 0 then

    GUI.color("shadow")
    local dist = GUI.shadow_dist
    for i = 1, GUI.shadow_dist do

      gfx.x, gfx.y = x + i, y + i
      gfx.drawstr(self.caption)

    end

  end

  -- Text
  GUI.color(self.color)
  gfx.x, gfx.y = x, y
  gfx.drawstr(self.caption)


end


-- Lbl - Unused methods.
function Lbl:onmousedown() end
function Lbl:onmouseup() end
function Lbl:ondoubleclick() end
function Lbl:ondrag() end
function Lbl:ontype() end


GUI.Lbl = Lbl


--[[  Sldr class.

  ---- User parameters ----
x, y, w      Coordinates of top-left corner, width. Height is fixed.
caption      Label / question
min, max    Minimum and maximum slider values
steps      How many steps between min and max
default      Where the slider should start

  ---- Additional values ----
retval      Current value of the slider

]]--

-- Sldr - New
local Sldr = {}
function Sldr:new(x, y, w, caption, min, max, steps, value, actualstep, sectionName)

  local sldr = {}
  sldr.type = "Sldr"

  sldr.x, sldr.y, sldr.w, sldr.h = x * dpi_scale
  , y * dpi_scale
  , w * dpi_scale
  , 8 * dpi_scale


  sldr.caption = caption
  sldr.sectionname = sectionName

  sldr.min, sldr.max = min, max
  sldr.steps = steps
  sldr.default= actualstep
  sldr.curstep = tonumber(actualstep)

  sldr.curval = value
  sldr.retval = ((max - min) / steps) * sldr.curstep + min


  setmetatable(sldr, self)
  self.__index = self
  return sldr

end


-- Sldr - Draw
function Sldr:draw()


  local x, y, w, h = self.x, self.y, self.w, self.h

  local steps = self.steps
  local curstep = self.curstep

  local offset = 0

  -- Size of the handle
  local radius = 8 * dpi_scale



  -- Draw track
  GUI.color("sld_bg")
  GUI.roundrect(x+offset, y, w, h, 4, 1, 1)
  GUI.color("elm_outline")
  GUI.roundrect(x+offset, y, w, h, 4, 1, 0)


  -- limit everything to be drawn within the square part of the track
  x, w = x + 4 * dpi_scale
  , w - 8 * dpi_scale


  local inc = w / steps

  -- Draw ticks
--[[
  if self.ticks == 1 or true then

    GUI.color("elm_frame")

    for i = 0, steps do
      gfx.line(x + i * inc, y - 4, x + i * inc, y - h, 1)
      gfx.line(x + i * inc, y + h + 4, x + i * inc, y + h + h, 1)
    end

  end
]]--

  -- Draw handle + outline
  local ox, oy = x + inc * curstep, y + (h / 2)

  GUI.color("shadow")
  for i = 1, GUI.shadow_dist do

    gfx.circle(ox + i + offset, oy + i, radius - 1, 1, 1)

  end

  GUI.color("txt")
  gfx.circle(ox + offset, oy, radius - 1, 1, 1)

  GUI.color("elm_outline")
  gfx.circle(ox + offset , oy, radius, 0, 1)


  -- Draw caption
  GUI.font(3)
  GUI.color("txt")

  local str_w, str_h = gfx.measurestr(self.caption)

  gfx.x = x - 188 * dpi_scale
  gfx.y = y - 2 * dpi_scale

  gfx.drawstr(self.caption)


  -- Draw value
  self.retval = ((self.max - self.min) / steps) * curstep + self.min

  GUI.font(4)

  local str_w, str_h = gfx.measurestr(self.retval)
  gfx.x = x - 35 * dpi_scale
  gfx.y = y -2 * dpi_scale

  value_truncated = string.format("%." .. (1 or 0) .. "f", self.retval)

  gfx.drawstr(value_truncated)

end


-- Sldr - Mouse down
function Sldr:onmousedown()

  -- Snap to the nearest value
  self.curval = (GUI.mouse.x - self.x) / self.w
  if self.curval > 1 then self.curval = 1 end
  if self.curval < 0 then self.curval = 0 end

  self.curstep = round(self.curval * self.steps)

end


-- Sldr - Dragging
function Sldr:ondrag()

  local x = GUI.mouse.x
  local lx = GUI.mouse.lx

  -- Ctrl?
  local ctrl = GUI.mouse.cap&4==4

  -- A multiplier for how fast the slider should move
  -- Higher values = slower
  --          Ctrl  Normal
  local adj = ctrl and 1200 or 150

  self.curval = self.curval + ((x - lx) / adj)
  if self.curval > 1 then self.curval = 1 end
  if self.curval < 0 then self.curval = 0 end

  self.curstep = round(self.curval * self.steps)



end


-- Sldr - Unused methods
function Sldr:onmouseup() end
function Sldr:ondoubleclick() end
function Sldr:ontype() end


GUI.Sldr = Sldr



--[[  Knob class.

  ---- User parameters ----
x, y, w      Coordinates of top-left corner, width. Height is fixed.
caption      Label / question
min, max    Minimum and maximum slider values
steps      How many steps between min and max
default      Where the slider should start
ticks      (1) display tick marks, (0) no tick marks

  ---- Additional values ----
retval      Current value of the knob

]]--

-- Knob - New.
local Knob = {}
function Knob:new(x, y, w, caption, min, max, steps, default, ticks)

  local knb = {}
  knb.type = "Knob"

  knb.x, knb.y, knb.w, knb.h = x, y, w, w

  knb.caption = caption

  knb.min, knb.max = min, max

  knb.steps, knb.ticks = steps, ticks or 0

  -- Determine the step angle
  knb.stepangle = (3 / 2) / knb.steps

  knb.default, knb.curstep = default, default

  knb.retval = ((max - min) / steps) + min
  knb.curval = knb.curstep / knb.steps

  setmetatable(knb, self)
  self.__index = self
  return knb

end




-- Knob - Draw
function Knob:draw()


  local x, y, w = self.x, self.y, self.w

  local caption = self.caption

  local min, max = self.min, self.max

  local default = self.default

  local ticks = self.ticks
  local stepangle = self.stepangle

  local curstep = self.curstep

  local steps = self.steps

  local r = w / 2
  local o = {x = x + r, y = y + r}


  -- Figure out where the knob is pointing
  local curangle = (-5 / 4) + (curstep * stepangle)


  -- Ticks and labels
  if ticks > 0 then

    GUI.font(4)

    for i = 0, steps do

      local angle = (-5 / 4 ) + (i * stepangle)

      GUI.color("elm_frame")

      -- Tick marks
      local x1, y1 = polar2cart(angle, r * 1.2, o.x, o.y)
      local x2, y2 = polar2cart(angle, r * 1.6, o.x, o.y)

      gfx.line(x1, y1, x2, y2)

      -- Highlight the current value
      if i == curstep then
        GUI.color("elm_fill")
      else
        GUI.color("txt")
      end

      -- Values
      local str = tostring(i + min)
      local cx, cy = polar2cart(angle, r * 2, o.x, o.y)
      local str_w, str_h = gfx.measurestr(str)
      gfx.x, gfx.y = cx - str_w / 2, cy - str_h / 2

      gfx.drawstr(str)


    end
  end


  -- Knob:

  -- Figure out the points of the triangle
  local curangle = (-5 / 4) + (curstep * stepangle)

  local Ax, Ay = polar2cart(curangle, 1.4 * r, o.x, o.y)
  local Bx, By = polar2cart(curangle + 1/2, r - 1, o.x, o.y)
  local Cx, Cy = polar2cart(curangle - 1/2, r - 1, o.x, o.y)

  -- Shadow
  GUI.color("shadow")
  local dist = GUI.shadow_dist
  for i = 1, dist do
    gfx.triangle(Ax + i, Ay + i, Bx + i, By + i, Cx + i, Cy + i)
    gfx.circle(o.x + i, o.y + i, r, 1)
  end


  -- Head
  GUI.color("elm_fill")
  GUI.triangle(1, Ax, Ay, Bx, By, Cx, Cy)
  GUI.color("elm_outline")
  GUI.triangle(0, Ax, Ay, Bx, By, Cx, Cy)

  -- Body
  GUI.color("elm_frame")
  gfx.circle(o.x, o.y, r, 1)
  GUI.color("elm_outline")
  gfx.circle(o.x, o.y, r, 0)

  self.retval = self.curval


end


-- Knob - Dragging.
function Knob:ondrag()

  local y = GUI.mouse.y
  local ly = GUI.mouse.ly

  -- Ctrl?
  local ctrl = GUI.mouse.cap&4==4

  -- Multiplier for how fast the knob turns
  -- Higher = slower
  --          Ctrl  Normal
  local adj = ctrl and 1200 or 150

  self.curval = self.curval + ((ly - y) / adj)
  if self.curval > 1 then self.curval = 1 end
  if self.curval < 0 then self.curval = 0 end

  self.curstep = round(self.curval * self.steps)


end


-- Unused methods.
function Knob:onmousedown() end
function Knob:onmouseup() end
function Knob:ondoubleclick() end
function Knob:ontype() end


GUI.Knob = Knob


--[[  OptLst class. Adapted from eugen2777's simple GUI template.

  ---- User parameters ----
x, y, w, h    Coordinates of top-left corner, width, overall height *including caption*
caption      Title / question
opts      String separated by commas, just like for GetUserInputs().
        ex: "Alice,Bob,Charlie,Denise,Edward"
pad        Padding between the caption and each option


  ---- Additional values ----
curopt      Currently-selected option number, starting from 1.
numopts      How many options there are
optarray[]    The opts string that was given, split into a table.
        ex: optarray[1] = "Alice"
retval      The current option name
]]--

-- OptLst - New.
local OptLst = {}
function OptLst:new(x, y, w, h, caption, opts, pad)

  local opt_lst = {}
  opt_lst.type = "OptLst"

  opt_lst.x, opt_lst.y, opt_lst.w, opt_lst.h = x, y, w, h

  opt_lst.caption = caption

  opt_lst.pad = pad

  -- Parse the string of options into a table
  opt_lst.optarray = {}
  local tempidx = 1
  for word in string.gmatch(opts, '([^,]+)') do
    opt_lst.optarray[tempidx] = word
    tempidx = tempidx + 1
  end

  opt_lst.numopts = tempidx - 1

  -- Currently-selected option
  opt_lst.curopt, opt_lst.state = 1, 1

  opt_lst.retval = opt_lst.optarray[opt_lst.curopt]


  setmetatable(opt_lst, self)
    self.__index = self
    return opt_lst

end


-- OptLst - Draw.
function OptLst:draw()


  local x, y, w, h = self.x, self.y, self.w, self.h

  local pad = self.pad

  -- Draw the list frame
  GUI.color("elm_frame")
  gfx.rect(x, y, w, h, 0)


  -- Draw the caption
  GUI.color("txt")
  GUI.font(2)

  local str_w, str_h = gfx.measurestr(self.caption)
  self.capheight = str_h

  gfx.x = x + (w - str_w) / 2
  gfx.y = y + pad

  gfx.drawstr(self.caption)

  GUI.font(3)

  -- Draw the options
  local optheight = (h - self.capheight - 2 * pad) / self.numopts
  local cur_y = y + self.capheight + pad
  local radius = 10

  for i = 1, self.numopts do


    gfx.set(r, g, b, 1)

    -- Option bubble
    GUI.color("elm_frame")
    gfx.circle(x + 2 * radius, cur_y + optheight / 2, radius, 0)

    -- Fill in the selected option and set its label to the window's bg color
    if i == self.state then
      GUI.color("elm_fill")
      gfx.circle(x + 2 * radius, cur_y + optheight / 2, radius * 0.5, 1)
    end

    -- Labels
    GUI.color("txt")
    local str_w, str_h = gfx.measurestr(self.optarray[i])

    gfx.x = x + 4 * radius
    gfx.y = cur_y + (optheight - str_h) / 2
    gfx.drawstr(self.optarray[i])

    cur_y = cur_y + optheight


  end

  self.retval = self.optarray[self.curopt]


end


-- OptLst - Mouse down.
function OptLst:onmousedown()

  --See which option it's on
  local adj_y = self.y + self.capheight + self.pad
  local adj_h = self.h - self.capheight - self.pad
  local mouseopt = (GUI.mouse.y - adj_y) / adj_h

  mouseopt = math.floor(mouseopt * self.numopts) + 1

  self.state = mouseopt

end


function OptLst:onmouseup()

  -- Set the new option, or revert make to the original
  -- if the cursor isn't on the list anymore
  if IsInside(self, GUI.mouse.x, GUI.mouse.y) then
    self.curopt = self.state
  else
    self.state = self.curopt
  end

end


function OptLst:ondrag()

  self:onmousedown()

end


-- OptLst - Unused methods.

function OptLst:ondoubleclick() end
function OptLst:ontype() end


GUI.OptLst = OptLst



--[[  Checklist class. Adapted from eugen2777's simple GUI template.
  ---- User parameters ----
x, y, w, h    Coordinates of top-left corner, width, overall height *including caption*
caption      Title / question
opts      String separated by commas, just like for GetUserInputs().
        ex: "Alice,Bob,Charlie,Denise,Edward"
pad        Padding between the caption and each option
value     selected an/aus (numerischer Wert 0/1)
]]--

-- Checklist - New
local Checklist = {}
function Checklist:new(x, y, w, h, caption, opts, pad, value, sectionName)



  local chk = {}
  chk.type = "Checklist"
  chk.sectionname = sectionName

  chk.x, chk.y, chk.w, chk.h = x * dpi_scale
  , y * dpi_scale
  , w * dpi_scale
  , h * dpi_scale


  chk.caption = caption

  chk.pad = pad

  -- Parse the string of options into a table
  chk.optarray, chk.optsel = {}, {}
  local tempidx = 1
  for word in string.gmatch(opts, '([^,]+)') do
    chk.optarray[tempidx] = word
    chk.optsel[tempidx] = value
    tempidx = tempidx + 1
  end

  chk.retval = chk.optsel

  chk.numopts = tempidx - 1

  setmetatable(chk, self)
    self.__index = self
    return chk

end


-- Checklist - Draw
function Checklist:draw()


  local x, y, w, h = self.x, self.y, self.w, self.h

  local pad = self.pad

  -- Draw the element frame

  if self.numopts > 1 then

    GUI.color("elm_frame")
    gfx.rect(x, y, w, h, 0)

  end


  GUI.font(2)

  -- Draw the caption
  local str_w, str_h = gfx.measurestr(self.caption)
  self.capheight = str_h
  gfx.x = x + (w - str_w) / 2
  gfx.y = y * dpi_scale
  GUI.shadow(self.caption)


  -- Draw the options
  GUI.color("txt")
  local optheight = (h - str_h - 2 * pad) / self.numopts
  local cur_y = y + str_h + pad
  local size = 20 * dpi_scale

  GUI.font(3)

  for i = 1, self.numopts do


    -- Draw the option frame
    GUI.color("elm_frame")
    gfx.rect(x + size / 2, cur_y + (optheight - size) / 2, size, size, 0)

    if dpi_scale == 2 then -- etwas dickere Kästen für Retina
      gfx.rect((x + size / 2) -1 , (cur_y + (optheight - size) / 2) -1, size+2, size+2, 0)
    end

    -- Fill in if selected
    -- modifiziert von boolean zu number (0/1) da sonst Typen-Fledermausland beim Speichern in .ini
    if self.optsel[i] == 1 then

      GUI.color("elm_fill")
      gfx.rect(x + size * 0.75, cur_y + (optheight - size) / 2 + size / 4, size / 2, size / 2, 1)

    end

    local str_w, str_h = gfx.measurestr(self.optarray[i])
    gfx.x = x + 2 * size
    gfx.y = cur_y + (optheight - str_h) / 2

    if self.numopts == 1 then
      GUI.shadow(self.optarray[i])
    else
      GUI.color("txt")
      gfx.drawstr(self.optarray[i])
    end

    cur_y = cur_y + optheight

  end

end


-- Checklist - Get/set value. Returns a table of boolean values for each option.
function Checklist:val(...)

  if ... then
    local newvals = {...}
    for i = 1, self.numopts do
      self.optsel[i] = newvals[i]
    end
  else
    return self.optsel
  end

end


-- Checklist - Mouse down
function Checklist:onmousedown()

  -- See which option it's on
  local adj_y = self.y + self.capheight
  local adj_h = self.h - self.capheight
  local mouseopt = (GUI.mouse.y - adj_y) / adj_h
  mouseopt = math.floor(mouseopt * self.numopts) + 1

  -- Make that the current option
  -- self.optsel[mouseopt] = not self.optsel[mouseopt]
  -- modifiziert von boolean zu number (0/1) da sonst Typen-Fledermausland beim Speichern in .ini

  if self.optsel[mouseopt] == 0 then self.optsel[mouseopt] = 1 else self.optsel[mouseopt] = 0 end

  self:val()

end

-- Checklist - Unused methods.
function Checklist:onwheel() end
function Checklist:onmouseup() end
function Checklist:ondoubleclick() end
function Checklist:ondrag() end
function Checklist:ontype() end


GUI.Checklist = Checklist



--[[  Btn class. Adapted from eugen2777's simple GUI template.

  ---- User parameters ----
x, y, w, h    Coordinates of top-left corner, width, height
caption      Label / question
func      Function to perform when clicked
...        If provided, any parameters to pass to that function.

]]--

-- Btn - New
local Btn = {}
function Btn:new(x, y, w, h, caption, func, ...)

  local btn = {}
  btn.type = "Btn"

  btn.x, btn.y, btn.w, btn.h = x * dpi_scale
  , y * dpi_scale
  , w * dpi_scale
  , h * dpi_scale


  btn.caption = caption

  btn.func = func
  btn.params = {...}

  btn.state = 0

  setmetatable(btn, self)
  self.__index = self
  return btn

end


-- Btn - Draw.
function Btn:draw()


  local x, y, w, h = self.x, self.y, self.w, self.h
  local r, g, b = self.r, self.g, self.b
  local state = self.state

  -- Draw the shadow
  if state == 0 then
    local dist = GUI.shadow_dist
    GUI.color("shadow")
    for i = 1, dist do
      GUI.roundrect(x - i, y - i, w, h, 4 * dpi_scale
      , 1 * dpi_scale
      , 1 * dpi_scale
    )
      GUI.roundrect(x + i, y + i, w, h, 4 * dpi_scale
      , 1 * dpi_scale
      , 1 * dpi_scale
    )
    end
    GUI.color("shadow")
    GUI.roundrect(x , y - 2 * dpi_scale
    , w, h, 4 * dpi_scale
    , 1 * dpi_scale
    , 1 * dpi_scale
  )
    GUI.color("elm_highlight")
    GUI.roundrect(x , y - 1 * dpi_scale
    , w, h, 4 * dpi_scale
    , 1 * dpi_scale
    , 1 * dpi_scale
  )
  end

  -- Draw the button
  GUI.color("elm_frame")
  GUI.roundrect(x + 1 * state, y + 1 * state, w, h, 4 * dpi_scale
  , 1 * dpi_scale
  , 1 * dpi_scale
)


  -- Draw the caption
  GUI.color("txt")
  GUI.font(4)

  if reaper.GetOS() == "OSX64" then
    btn_offset = 3 * dpi_scale

  else
    btn_offset = 1 * dpi_scale

  end

  local str_w, str_h = gfx.measurestr(self.caption)
  gfx.x = x + 1 * state + ((w - str_w) / 2) - 2 * dpi_scale

  gfx.y = y + 1 * state + ((h - str_h) / 2) - 2 * dpi_scale

  gfx.y = gfx.y + btn_offset
  gfx.drawstr(self.caption)

end


-- Btn - Mouse down.
function Btn:onmousedown()

  self.state = 1

end


-- Bton - Mouse up.
function Btn:onmouseup()

  self.state = 0

  -- If the button was released on the button, run func
  if IsInside(self, GUI.mouse.x, GUI.mouse.y) then

    self.func(table.unpack(self.params))

  end

end


-- Btn - Unused methods.
function Btn:ondoubleclick() end
function Btn:ondrag() end
function Btn:ontype() end


GUI.Btn = Btn




--[[  TxtBox class. Adapted from schwa's example code.

  ---- User parameters ----
x, y, w, h    Coordinates of tep-left corner, width, height
pad        Padding between the left side and first character.


  ---- Additional values ----
retval      Text in the box
caret      Current caret position
sel        Length of selection
focus      Whether or not the box is active

]]--

-- TxtBox - New
local TxtBox = {}
function TxtBox:new(x, y, w, h, caption, pad)

  local txt = {}
  txt.type = "TxtBox"

  txt.x, txt.y, txt.w, txt.h = x, y, w, h

  txt.caption = caption
  txt.pad = pad

  txt.caret = 0
  txt.sel = 0
  txt.blink = 0
  txt.retval = ""
  txt.focus = false

  setmetatable(txt, self)
  self.__index = self
  return txt

end


-- TxtBox - Draw.
function TxtBox:draw()


  local x, y, w, h = self.x, self.y, self.w, self.h

  local caption = self.caption
  local caret = self.caret
  local sel = self.sel
  local text = self.retval
  local focus = self.focus
  local pad = self.pad


  -- Draw the caption
  GUI.font(3)
  GUI.color("txt")
  local str_w, str_h = gfx.measurestr(caption)
  gfx.x = x
  gfx.y = y - str_h - pad
  gfx.drawstr(caption)

  -- Draw the textbox frame, and make it brighter if focused.
  if focus then

    GUI.color("elm_fill")
    gfx.rect(x + 2, y + 2, w - 4, h - 4, 0)

  else

    GUI.color("elm_frame")
  end

  gfx.rect(x, y, w, h, 0)

  -- Draw the text
  GUI.color("txt")
  GUI.font(3)
  str_w, str_h = gfx.measurestr(text)
  gfx.x = x + pad
  gfx.y = y + (h - str_h) / 2
  gfx.drawstr(text)

  -- Is any text selected?
  if sel ~= 0 then

    -- Use the caret and selection positions to figure out the dimensions
    local sel_start, sel_end = caret, caret + sel
    if sel_start > sel_end then sel_start, sel_end = sel_end, sel_start end
    local x_start = gfx.measurestr(string.sub(text, 0, sel_start))


    local w_sel = gfx.measurestr(string.sub(text, sel_start + 1, sel_end))


    -- Draw the selection highlight
    GUI.color("txt")
    gfx.rect(x + x_start + pad, y + 4, w_sel, h - 8, 1)

    -- Draw the selected text
    GUI.color("wnd_bg")
    gfx.x, gfx.y = x + x_start + pad, y + (h - str_h) / 2
    gfx.drawstr(string.sub(text, sel_start + 1, sel_end))

  end

  -- If the box is focused, draw the caret...
  if focus then

    -- ...but only for half of the blink cycle
    if self.blink < 8 then

      local caret_x = x + pad + gfx.measurestr(string.sub(text, 0, caret))

      gfx.set(r, g, b, 1)
      gfx.line(caret_x, y + 4, caret_x, y + h - 8)

    end

    -- Increment the blink cycle
    self.blink = (self.blink + 1) % 16

  end

  self.retval = text

end


-- TxtBox - Get the closest character position to the mouse.
function TxtBox:getcaret()

  local len = string.len(self.retval)
  GUI.font(3)

  for i = 1, len do

    w = gfx.measurestr(string.sub(self.retval, 1, i))
    if GUI.mouse.x < (self.x + self.pad + w) then return i - 1 end

  end

  return len

end


-- TxtBox - Mouse down.
function TxtBox:onmousedown()

  local x, y = GUI.mouse.x, GUI.mouse.y

  -- Was the mouse clicked inside this element?
  self.focus = IsInside(self, x, y)
  if self.focus then

    -- Place the caret on the nearest character and reset the blink cycle
    self.caret = self:getcaret()
    self.cursstate = 0
    self.sel = 0
    self.caret = self:getcaret()

  end

end


-- TxtBox - Double-click.
function TxtBox:ondoubleclick()

  local len = string.len(self.retval)
  self.caret, self.sel = len, -len

end


-- TxtBox - Mouse drag.
function TxtBox:ondrag()

  self.sel = self:getcaret() - self.caret

end


-- TxtBox - Typing.
function TxtBox:ontype(char)


  GUI.font(3)

  local caret = self.caret
  local text = self.retval
  local maxlen = gfx.measurestr(text) >= (self.w - (self.pad * 3))


  -- Is there text selected?
  if self.sel ~= 0 then

    -- Delete the selected text
    local sel_start, sel_end = caret, caret + self.sel
    if sel_start > sel_end then sel_start, sel_end = sel_end, sel_start end

    text = string.sub(text, 0, sel_start)..string.sub(text, sel_end + 1)
    --self.sel = 0

  end

  -- Left arrow
  if char == 0x6C656674 then
    if caret > 0 then self.caret = caret - 1 end

  -- Right arrow
  elseif char == 0x72676874 then
    if caret < string.len(text) then self.caret = caret + 1 end

  -- Backspace
  elseif char == 8 then
    if string.len(text) > 0 and self.sel == 0 then
      text = string.sub(text, 1, caret - 1)..(string.sub(text, caret + 1))
      self.caret = caret - 1
    end

  -- Delete
  elseif char == 6579564 then

    if string.len(text) > 0 and self.sel == 0 then
      text = string.sub(text, 1, caret)..(string.sub(text, caret + 2))
    end

  -- Any other valid character, as long as we aren't at max length
  elseif char >= 32 and char <= 125 and maxlen == false then

    -- Insert the typed character at the caret position
    text = string.format("%s%c%s", string.sub(text, 1, caret), char, string.sub(text, caret + 1))
    self.caret = self.caret + 1

  end

  self.retval = text
  self.sel = 0

end


-- TxtBox - Unused methods.
function TxtBox:onmouseup() end


GUI.TxtBox = TxtBox




-- Make our table full of functions available to the original script that called this one
return GUI
