--[[
  Scythe testing tool
]]--

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")({dev = true})

local GUI = require("gui.core")
local Table = require("public.table")
local T = Table.T
local Test = require("testing.lib.core")
local Menu = require("public.menu")
local testFile = Scythe.getContext().scriptPath


------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "Test Runner",
  w = 356,
  h = 96,
  anchor = "mouse",
})



------------------------------------
-------- Logic ---------------------
------------------------------------


local recentFiles = T{}

local function loadRecentFiles()
  local fileStr = reaper.GetExtState("Scythe v3", "testRunner/recentFiles")
  if not fileStr or fileStr == "" then return end

  for file in fileStr:gmatch("[^|]+") do
    recentFiles[#recentFiles + 1] = file
  end
end

local function updateRecentFiles(file)
  local _, existsIdx = recentFiles:find(function(v) return v == file end)
  if existsIdx then
    recentFiles:insert(1, recentFiles:remove(existsIdx))
  else
    recentFiles:insert(1, file)
  end

  if #recentFiles > 10 then recentFiles[11] = nil end

  reaper.SetExtState("Scythe v3", "testRunner/recentFiles", recentFiles:concat("|"), true)
end

local function updateTestFile(file)
  testFile = file
  GUI.findElementByName("txt_file"):val(testFile)
end


local function showFilesMenu()
  gfx.x = window.state.mouse.x
  gfx.y = window.state.mouse.y

  local menuArr = Table.join({"Browse", ""}, recentFiles)

  return Menu.showMenu(menuArr)
end

local function selectFile()
  local idx, file = showFilesMenu()
  if not idx then return end

  if idx == 1 then
    _, file = reaper.GetUserFileNameForRead(testFile, "Choose a test file", ".lua")
    if file then
      updateRecentFiles(file)
    end
  end

  if file and file ~= testFile then updateTestFile(file) end
end

local testEnv = Table.shallowCopy(Test)
testEnv.Table = Table

-- Allow tests to hot-reload modules that the GUI is using
testEnv.require = function(str)
  package.loaded[str] = nil
  return require(str)
end

setmetatable(testEnv, {__index = _G})

local function runTests()
  local tests, ret, err

  reaper.ClearConsole()
  Msg("Running tests...\n")

  tests, err = loadfile(testFile, "bt", testEnv)
  if err then
    Msg("Failed to load test file:\n\t" .. testFile .. "\n\nError: " .. tostring(err))
  end

  Test.initialize()

  ret, err = pcall( function() tests() end)

  if not ret then
    Msg("Test file failed:\n\t" .. testFile .. "\n\nError: " .. tostring(err))
  end

  Msg("\nDone!\n")

  local log = Test.getLoggedData()
  Msg(
    "Ran " .. log.tests.total .. " tests in " .. log.suites.total .. " suites:\n" ..
    "\t" .. log.tests.passed .. " passed\n" ..
    "\t" .. log.tests.failed .. " failed\n" ..
    "\n\t" .. log.tests.skipped .. " tests skipped\n" ..
    "\t" .. log.suites.skipped .. " suites skipped"
  )


end




------------------------------------
-------- GUI Elements --------------
------------------------------------


local layer = GUI.createLayer({name = "Layer1", z = 1})

layer:addElements( GUI.createElements(
  {
    name = "txt_file",
    type = "Textbox",
    caption = "Test file:",
    x = 64,
    y = 8,
    w = 256,
  },
  {
    name = "btn_file",
    type = "Button",
    caption = "...",
    x = 324,
    y = 10,
    w = 24,
    h = 20,
    func = selectFile,
  },
  {
    name = "btn_go",
    type = "Button",
    caption = "Run Tests",
    x = 139,
    y = 48,
    w = 80,
    func = runTests

  }
))

window:addLayers(layer)
window:open()

loadRecentFiles()
if #recentFiles > 0 then
  updateTestFile(recentFiles[1])
end

GUI.Main()
