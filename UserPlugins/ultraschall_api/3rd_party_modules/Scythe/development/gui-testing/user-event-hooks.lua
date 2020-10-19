--[[
  Test script to make sure user events and hooks are being fired correctly
]]--

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")
local Table = require("public.table")
local Color = require("public.color")
local Font = require("public.font")

local events = {
  "MouseEnter",
  "MouseOver",
  "MouseLeave",
  "MouseDown",
  "MouseUp",
  "DoubleClick",
  "Drag",
  "RightMouseDown",
  "RightMouseUp",
  "RightDoubleClick",
  "RightDrag",
  "MiddleMouseDown",
  "MiddleMouseUp",
  "MiddleDoubleClick",
  "MiddleDrag",
  "Wheel",
  "Type",
}

local eventGrid = Table.reduce(events, function(grid, event)
  grid[event] = {0, 0}
  return grid
end, {})

local function fillCell(event, idx)
  eventGrid[event][idx] = 0.999
end

local function updateCell(event, idx)
  if eventGrid[event][idx] <= 0 then return end

  eventGrid[event][idx] = eventGrid[event][idx] * eventGrid[event][idx]
  return true
end

local function updateCells()
  local ret

  for _, event in pairs(events) do
    local updated = updateCell(event, 1)
    updated = updateCell(event, 2) or updated
    if updated then ret = true end
  end

  return ret
end




------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  w = 384,
  h = 384,
  name = "User Event Hooks",
})




------------------------------------
-------- GUI Elements --------------
------------------------------------


local layer = GUI.createLayer({name = "Layer1", z = 1})

local frm_grid = GUI.createElement({
  name = "frm_grid",
  type = "Frame",
  x = 64,
  y = 48,
  w = 256,
  h = 304,
})

function frm_grid:afterUpdate()
  if updateCells() then self:redraw() end
end

function frm_grid:draw()
  local labelWidth = 150
  local labelHeight = 24

  local pad = 4
  Color.set("backgroundDarkest")
  gfx.rect(self.x - pad, self.y - pad, self.w + 2*pad, self.h + 2*pad, true)
  Color.set("elementBody")
  gfx.rect(self.x - pad, self.y - pad, self.w + 2*pad, self.h + 2*pad, false)

  Font.set(4)

  local cellSize = {
    w = (self.w - labelWidth) / 2,
    h = (self.h - labelHeight) / #events
  }

  Color.set("text")

  gfx.x = self.x + labelWidth
  gfx.y = self.y
  gfx.drawstr("Before")

  gfx.x = self.x + labelWidth + cellSize.w
  gfx.drawstr("After")

  local cell

  for i, event in ipairs(events) do
    cell = eventGrid[event]

    gfx.x = self.x
    gfx.y = self.y + labelHeight + (i - 1) * cellSize.h
    Color.set("text")
    gfx.drawstr(event)
    Color.set("highlight")
    if cell[1] > 0 then
      gfx.a = cell[1]
      gfx.rect(
        self.x + labelWidth + pad,
        self.y + (i - 1) * cellSize.h + labelHeight + pad,
        cellSize.w - 2 * pad,
        cellSize.h - 2 * pad,
        true
      )
    end

    if cell[2] > 0 then
      gfx.a = cell[2]
      gfx.rect(
        self.x + labelWidth + cellSize.w + pad,
        self.y + (i - 1) * cellSize.h + labelHeight + pad,
        cellSize.w - 2 * pad,
        cellSize.h - 2 * pad,
        true
      )
    end

    gfx.a = 1
  end
end

local txt_box = GUI.createElement({
  name = "txt_box",
  type = "Textbox",
  x = 128,
  y = 8,
  w = 128,
  h = 20,
  caption = "Interact with me:",
})

for _, event in pairs(events) do
  txt_box["before"..event] = function(self)
    fillCell(event, 1)
    self:redraw()
  end
  txt_box["after"..event] = function(self)
    fillCell(event, 2)
    self:redraw()
  end
end




------------------------------------
------------------------------------
------------------------------------


layer:addElements(frm_grid, txt_box)

window:addLayers(layer)
window:open()

GUI.Main()
