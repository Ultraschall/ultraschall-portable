--[[
  Scythe example

  - Using images in a script

]]--

-- The core library must be loaded prior to anything else

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")
local Image = require("public.image")
local Sprite = require("public.sprite")
local Table = require("public.table")
local T = Table.T

local buttonImages = Image.loadFolder(Scythe.getContext().scriptPath .. "Working with Images/grid")

local Element = require("gui.element")

local ILabel = Element:new()
ILabel.__index = ILabel

ILabel.defaultProps = {
  name = "ilabel",
  type = "ILabel",

  x = 0,
  y = 0,
}


function ILabel:new(props)
  local ilabel = self:addDefaultProps(props)

  return setmetatable(ilabel, self)
end

function ILabel:init()
  self.sprite = Sprite:new({
    image = self.image,
    drawBounds = true,
  })
  self.sprite.rotate.unit = "pct"
  -- if not self.buffer then error("ILabel: The specified image was not found") end
end

function ILabel:draw()
  gfx.mode = 0
  self.sprite:draw(self.x, self.y)
end


GUI.elementClasses.ILabel = ILabel



local IButton = Element:new()
IButton.__index = IButton
IButton.defaultProps = {
  name = "ibutton",
  type = "IButton",

  x = 16,
  y = 32,
  w = 24,
  h = 24,

  caption = "IButton",
  font = 3,
  textColor = "txt",

  func = function () end,
  params = {},
  state = 0,
}

function IButton:new(props)
  local ibutton = self:addDefaultProps(props)

  return setmetatable(ibutton, self)
end

function IButton:init()
  self.sprite = Sprite:new({})
  self.sprite:setImage(self.image)
  self.sprite.frame = { w = self.w, h = self.h }
  if not self.sprite.image then error("IButton: The specified image was not found") end
end

function IButton:draw()
  gfx.mode = 0
  -- gfx.blit(self.buffer, 1, 0, self.state * self.w, 0, self.w, self.h, self.x, self.y, self.w, self.h)
  self.sprite:draw(self.x, self.y, self.state)
end

function IButton:onUpdate(state)
  if self.state > 0 and not self:containsPoint(state.mouse.x, state.mouse.y) then
    self.state = 0
    self:redraw()
  end

end

function IButton:onMouseOver()
  if self.state == 0 then
    self.state = 1
    self:redraw()
  end
end

function IButton:onMouseDown()
  self.state = 2
  self:redraw()
end

function IButton:onMouseUp(state)
  self.state = 0

  if self:containsPoint(state.mouse.x, state.mouse.y) then

    self:func(table.unpack(self.params))

  end
  self:redraw()
end

function IButton:onDoubleclick()

  self.state = 0

end

GUI.elementClasses.IButton = IButton

local buttons = T{}
for imagePath in Table.kpairs(buttonImages.images) do
  buttons[#buttons+1] = buttonImages.path.."/"..imagePath
end

local w, h = 31, 17
buttons = buttons:map(function(imagePath, idx)
  return GUI.createElement({
    name = "IBtn"..idx,
    type = "IButton",
    w = w,
    h = h,
    x = ((idx - 1) % 6) * w,
    y = math.floor((idx - 1) / 6) * h,
    image = imagePath,
    func = function(self, a, b, c) Msg(self.name, a, b, c) end,
    params = {"a", "b", "c"}
  })
end)



------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "Working with Images",
  w = 500,
  h = 500,
  anchor = "mouse"
})


local mainImage = GUI.createElement({
  name = "ilbl",
  type = "ILabel",
  image = Scythe.getContext().scriptPath .. "Working with Images/guybrush small.png",
  x = 200,
  y = 250,
  w = 100,
  h = 100,
})

local function updateRotation(self)
  mainImage.sprite.rotate.angle = self:val()
  mainImage:redraw()
end
local function updateScale(self)
  mainImage.sprite.scale = self:val()
  mainImage:redraw()
end


------------------------------------
-------- GUI Elements --------------
------------------------------------

local layer = GUI.createLayer({name = "Layer1", z = 1})

layer:addElements(table.unpack(buttons))
layer:addElements(
  GUI.createElement({
    name = "sldrScale",
    type = "Slider",
    x = 32,
    y = 200,
    horizontal = false,
    w = 192,
    min = 0.1,
    max = 2,
    defaults = 1,
    caption = "Scale",
    inc = 0.1,
    afterMouseDown = updateScale,
    afterMouseUp = updateScale,
    afterDoubleClick = updateScale,
    afterDrag = updateScale,
    afterWheel = updateScale,
  }),
  GUI.createElement({
    name = "sldrRot",
    type = "Slider",
    x = 64,
    y = 180,
    w = 192,
    min = -1,
    max = 1,
    defaults = 0,
    inc = 0.01,
    caption = "Rotate",
    afterMouseDown = updateRotation,
    afterMouseUp = updateRotation,
    afterDoubleClick = updateRotation,
    afterDrag = updateRotation,
    afterWheel = updateRotation,
  }),
  mainImage
)

window:addLayers(layer)
window:open()

GUI.Main()
