local Table = require("public.table")
local T = Table.T

local commonParams = T{
  {
    name = "name",
    type = "string",
    description = "The element's name. Must be unique.",
  },
  {
    name = "x",
    type = "number",
    description = "Horizontal distance from the left side of the window, in pixels",
  },
  {
    name = "y",
    type = "number",
    description = "Vertical distance from the top of the window, in pixels",
  },
  {
    name = "w",
    type = "number",
    description = "Width, in pixels",
  },
  {
    name = "h",
    type = "number",
    description = "Height, in pixels",
  },
}

local function nameFromSignature(sig)
  local key = sig:match("(.+) = function") or sig:match("function (.+) ?%(")
  local stripped = key:match("^local (.+)")

  return stripped or key
end

local escapes = T{
  ["|"] = "&#124;",
  ["\n"] = "<br>",
}

local function escapeForTable(str)
  return escapes:reduce(function(acc, new, old)
    return acc:gsub(old, new)
  end, str)
end

local function paramParser(paramStr)
  local param = {}
  param.name, param.type, param.description = paramStr:match("([^ ]+) +([^ ]+) *(.*)")
  param.type = escapeForTable(param.type)
  param.description = escapeForTable(param.description)
  return param
end

local function returnParser(returnStr)
  local ret = {}
  ret.type, ret.description = returnStr:match("([^ ]+) *(.*)")
  ret.type = ret.type:gsub("|", "&#124;")
  ret.description = ret.description:gsub("|", "&#124;")
  return ret
end

local function textParser(text) return text end

local parseTag = {
  module = textParser,
  ["require"] = textParser,
  description = textParser,
  commonParams = function() return commonParams end,
  param = paramParser,
  option = paramParser,
  ["return"] = returnParser,
}

local Segment = T{}
Segment.__index = Segment
function Segment:new(line)
  local isModule, name = line:match("(@module) ?(.*)")

  local segment = {
    name = name,
    rawTags = T{},
    signature = nil,
    tags = T{},
    currentTag = {
      type = "description",
      content = T{},
    },
    isModule = isModule,
  }

  if not isModule then
    segment.currentTag.content:insert(line)
  end

  return setmetatable(segment, self)
end

function Segment:closeTag()
  local tagType = self.currentTag.type
  if not tagType then
    error("Error closing segment - no current tag type:\n"..self:stringify())
  end

  local tag = self.currentTag.content:concat(
    (tagType == "description" or tagType == "module") and "\n" or " "
  )

  if not self.rawTags[tagType] then self.rawTags[tagType] = T{} end
  self.rawTags[tagType]:insert(tag)

  if tagType == "commonParams" then
    self.tags.option = Table.deepCopy(commonParams)
  else
    local parsed = parseTag[tagType](tag)

    if not self.tags[tagType] then self.tags[tagType] = T{} end

    self.tags[tagType]:insert(parsed)
  end
  self.currentTag = nil
end

function Segment:push(line)
  if line:match("^@") then
    self:closeTag()
    local tag, rest = line:match("@([^ ]+) ?(.*)")

    self.currentTag = T{
      type = tag,
      content = T{rest}
    }
  else
    self.currentTag.content:insert((line ~= "" and line or "\n"))
  end
end

--[[
Given:
-- @param t     table    This is a table.
-- @param cb    function    This is a callback function.
-- @option iter iterator  Defaults to `ipairs`
-- @return      value|boolean     Returns `t`
-- @return      key
Table.find = function(t, cb, iter)
Expected:
Table.find(t, cb[, iter])
]]--
function Segment:generateSignature()
  if #self.args == 0 then return self.name .. "()" end

  local args = self.args:reduce(function (acc, arg)
    local argType = self.tags.param and self.tags.param:find(function(v) return v.name == arg end)
      and 1
      or 2

    acc[argType]:insert(arg)
    return acc
  end, {T{}, T{}})

  local optionSig = ""
  if #args[2] > 0 then
    optionSig = ((#args[1] > 0) and "[, " or "[") .. args[2]:concat(", ") .. "]"
  end

  return self.name .. "(" .. args[1]:concat(", ") .. optionSig .. ")"
end

function Segment:finalize(line)
  self:closeTag()

  if not self.isModule then
    self.args = line:match("%((.-)%)"):split("[^ ,]+")
    self.name = nameFromSignature(line)
    self.signature = self:generateSignature()
  end
end

local Doc = {}
function Doc.fromFile(path)
  local segments = T{}
  local file, err = io.open(path)
  if not file then
    error("Error opening " .. path .. ": " .. err)
    return nil
  end

  local module
  local currentSegment
  local n = 0
  local isModule = false

  for line in file:lines() do
    n = n + 1
    if not isModule and n == 10 then
      if n == 10 then
        break
      end
    -- A new segment
    elseif line:match("^%-%-%- ") then
      local lineContent = line:match("^%-%-%- (.+)")
      if not lineContent then
        error("Error opening doc segment at line " .. n .. " of:\n" .. path .. "\n\nLine: " .. tostring(line))
      end

      currentSegment = Segment:new(lineContent)
      if currentSegment.isModule then
        isModule = true
      end

      if not isModule then break end

    elseif currentSegment then
      -- Actual code
      if not line:match("^%-%-") then
        currentSegment:finalize(line)
        if currentSegment.isModule then
          module = currentSegment
        else
          segments:insert(currentSegment)
        end

        currentSegment = nil
      -- Continue the current segment
      else
        currentSegment:push(line:match("^%-%-+ (.+)") or "")
      end
    end
  end

  if not module then return end

  module.subPath = path:match(Scythe.libRoot .. "[^\\/]*[\\/](.+)%.lua")
  module.requirePath = module.subPath:gsub("[\\/]", ".")
  if not module.name or module.name == "" then module.name = module.requirePath end

  return module, (#segments > 0 and segments or nil)
end

return Doc
