local Table = require("public.table")
local T = Table.T

local Md = {}

local paramTemplate = function (param)
  if not param.name or not param.type then
    error("Invalid parameter structure:\n" .. Table.stringify(param))
  end
  return "| " .. param.name .. " | " .. param.type .. (param.description and (" | " .. param.description .. " |") or " |   |")
end

local tagTemplates = T{
  module = {
    header = nil,
    item = function (desc) return desc end,
  },
  require = {
    header = nil,
    item = function (req) return req end,
  },
  description = {
    header = nil,
    item = function (desc) return desc end,
  },
  param = {
    header = "| **Required** | []() | []() |\n| --- | --- | --- |",
    item = paramTemplate,
  },
  option = {
    header = "| **Optional** | []() | []() |\n| --- | --- | --- |",
    item = paramTemplate,
  },
  ["return"] = {
    header = "| **Returns** | []() |\n| --- | --- |",
    item = function (ret)
      return "| " .. ret.type .. (ret.description and (" | " .. ret.description .. " |") or " |   |")
    end,
  }
}
function Md.parseTags(tags)
  return tags:reduce(function(acc, tagArr, tagType)
    if #tagArr == 0 then return acc end

    local template = tagTemplates[tagType]
    if not template then
      error("Couldn't find tag template for: " .. tagType .. "\n\n" .. Table.stringify(tagArr))
    end

    local mdTag = T{ template.header }

    tagArr:orderedForEach(function(tag)
      local parsed = template.item(tag)
      mdTag:insert(parsed)
    end)

    acc[tagType] = mdTag:concat("\n")
    return acc
  end, T{})
end

-- This syntax is used by Docsify
local function customHeadingId(name)
  return " :id=" .. name:lower():gsub("[.:]", "-")
end

local function segmentWrapper(name, signature)
  local open = T{
    "<section class=\"segment\">\n",
    "### " .. signature .. customHeadingId(name),
    "",
  }

  local close = "\n</section>"

  return open:concat("\n"), close
end

function Md.parseSegment(name, signature, tags)
  local parsedTags = Md.parseTags(tags)

  local open, close = segmentWrapper(name, signature)

  local out = T{
    open,
    parsedTags.description
  }

  if parsedTags.param then
    out:insert("")
    out:insert(parsedTags.param)
  end

  if parsedTags.option then
    out:insert("")
    out:insert(parsedTags.option)
  end

  if parsedTags["return"] then
    out:insert("")
    out:insert(parsedTags["return"])
  end

  out:insert(close)

  return out:concat("\n")
end

function Md.parseHeader(header)
  local out = T{"# " .. header.name}

  if not header.tags.require or header.tags.require[1] ~= "" then
      out:insert("```lua")
      out:insert((header.tags.require)
        and header.tags.require:concat("\n")
        or ("local " .. header.name .. " = require(" .. header.requirePath .. ")")
      )
      out:insert("```")
  end

  if header.tags.description then
    out:insert(header.tags.description:concat("\n"))
  end

  local parsedTags = Md.parseTags(header.tags)

  if parsedTags.param then
    out:insert("")
    out:insert(parsedTags.param)
  end

  if parsedTags.option then
    out:insert("")
    out:insert(parsedTags.option)
  end

  if parsedTags["return"] then
    out:insert("")
    out:insert(parsedTags["return"])
  end

  return out:concat("\n")
end

return Md
