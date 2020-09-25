local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

loadfile(libPath .. "scythe.lua")({ dev = true, printErrors = true })
local Table = require("public.table")
local T = Table.T
local File = require("public.file")

local context = Scythe.getContext()

local static = {
  author = "Lokasenna",
  donation = "https://paypal.me/Lokasenna",
  links = T{
    "Forum Thread https://forum.cockos.com/showthread.php?t=177772",
    "Scythe Website http://jalovatt.github.io/scythe",
  },
}

local REMOTE_URL_BASE = "https://github.com/jalovatt/scythe/raw/"
local LOCAL_FILE_BASE = "/Development/Scythe library v3/"

local function getCommitHash()
  local cmd = "/bin/sh -c 'cd " .. context.scriptPath .. "; git rev-parse HEAD;'"
  local ret, output = reaper.ExecProcess(
    cmd,
    3):match("([^\n\r]+)[\n\r]([^\n\r]+)")

  if ret ~= "0" then
    error("ExecProcess returned code " .. ret .. ":\n" .. output)
  end

  return output
end

local function getProvides(folder)
  local commitHash = getCommitHash()

  return File.getFilesRecursive(Scythe.libRoot..folder, function(name, _, isFolder)
    if isFolder and name:match("^%.git") then return false end
    return true
  end):reduce(function(acc, file)
    local relativePath = file.path:gsub(Scythe.libRoot, "")

    acc:insert((file.name:match("^Scythe_") and "[main]" or "[nomain]")
      .. " "
      .. LOCAL_FILE_BASE .. relativePath
      .. " "
      .. REMOTE_URL_BASE .. commitHash .. "/" .. relativePath
    )

    return acc;
  end, T{}):sort()
end

local function readFile(filename)
  local file, err = io.open(filename, "r")
  if err then
    error(err)
    return
  end

  local text = file:read("*all")
  file:close()

  return text
end

local function writeFile(filename, text)
  local file, err = io.open(filename, "w")
  if err then
    error(err)
    return
  end

  file:write(text)
  file:close()
end

local function promptForVersion(prevVersion)
  local ret, newVersion = reaper.GetUserInputs("Update version", 1, "New version number:,extrawidth=16", prevVersion)
  return (ret and newVersion ~= "") and newVersion or prevVersion
end

local function promptForChanges()
  local ret, changes = reaper.GetUserInputs("Update changelog", 1, "Changes:,extrawidth=64", "")
  return (ret and changes ~= "") and changes or "None"
end

return function(vars) Scythe.wrapErrors(function()
  Msg("Generating metapackage for /"..vars.folder)

  local provides = getProvides(vars.folder)
  local prevHeaderText = readFile(context.scriptPath .. vars.filename .. ".lua")
  local prevVersion = prevHeaderText:match("Version: ([%a%p%d]+)[\n\r]*")
  local newVersion = promptForVersion(prevVersion)

  local changes = promptForChanges()

  local output = T{
    "--[[",
    "Description: " .. vars.description,
    "Version: " .. newVersion,
    "Author: " .. static.author,
    "Links:",
    static.links:map(function(line) return "  " .. line end):concat("\n"),
    "Donation: " .. static.donation,
    "About:",
    vars.about:split("\n"):map(function(line) return (line:len() > 0 and "  " or "") .. line end):concat("\n"),
    "Changelog:",
    changes:split("\n"):map(function(line) return (line:len() > 0 and "  " or "") .. line end):concat("\n"),
    "Metapackage: true",
    "Provides:",
    provides:map(function(line) return "  " .. line end):concat("\n"),
    "]]--",
  }:concat("\n")

  local outputFile = context.scriptPath .. vars.filename .. ".lua"
  writeFile(outputFile, output)

  Msg("Wrote: " .. outputFile)
end) end
