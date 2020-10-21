local Table = require("public.table")[1]

local function Msg(msg, indents)
  local str = string.rep("\t", indents or 0) .. msg
  if (reaper) then
    reaper.ShowConsoleMsg(str)
    reaper.ShowConsoleMsg("\n")
  else
    print(str)
  end
end


local function validateMsg(msg)
  return ((msg and msg ~= "") and msg or ".")
end

local loggedData = {suites = {}, tests = {}}
local currentTestPassed

local Test = {}

function Test.initialize()
  loggedData.suites.ran = 0
  loggedData.suites.skipped = 0
  loggedData.tests.ran = 0
  loggedData.tests.failed = 0
  loggedData.tests.passed = 0
  loggedData.tests.skipped = 0
end

function Test.getLoggedData()
  loggedData.suites.total = loggedData.suites.ran + loggedData.suites.skipped
  loggedData.tests.total = loggedData.tests.ran + loggedData.tests.skipped

  return loggedData
end

local log = {
  suiteRan = function() loggedData.suites.ran = loggedData.suites.ran + 1 end,
  suiteSkipped = function() loggedData.suites.skipped = loggedData.suites.skipped + 1 end,
  testRan = function() loggedData.tests.ran = loggedData.tests.ran + 1 end,
  testPassed = function() loggedData.tests.passed = loggedData.tests.passed + 1 end,
  testSkipped = function() loggedData.tests.skipped = loggedData.tests.skipped + 1 end,
  testFailed = function() loggedData.tests.failed = loggedData.tests.failed + 1 end,
}

function Test.describe(msg, cb)
  log.suiteRan()
  Msg(validateMsg(msg))
  cb()
  Msg(" ")
end

function Test.xdescribe(msg)
  log.suiteSkipped()
  Msg(validateMsg(msg) .. " (skipped)")
end

function Test.test(msg, cb)
  currentTestPassed = true
  log.testRan()

  Msg(validateMsg(msg), 1)
  cb()

  if currentTestPassed then
    log.testPassed()
  else
    log.testFailed()
  end

end
Test.it = Test.test

function Test.xtest(msg)
  log.testSkipped()
  Msg(validateMsg(msg) .. " (skipped)", 1)
end
Test.xit = Test.xtest

local function pass()
  return true
end

local function fail(str, a, b)
  Msg("fail", 2)
  Msg("expected " .. tostring(a) .. " " .. str .. " " .. tostring(b), 3)

  currentTestPassed = false
  log.testFailed()

  return false
end


local function shallowEquals(a, b)
  for k, v in pairs(a) do
    if b[k] ~= v then return false end
  end

  for k, v in pairs(b) do
    if (not a[k] and v ~= nil) then return false end
  end

  return true
end


-- Returns true if a and b are equal to the given number of decimal places
local function almostEquals(a, b, places)
  return math.abs(a - b) <= (1 / (10^(places or 1)))
end

local function deepEquals(a, b)
  for k, v in pairs(a) do
    if b[k] ~= v then
      if (type(v) == "table" and type(b[k]) == "table") then
        if not deepEquals(v, b[k]) then
          return false
        end
      else
        return false
      end
    end
  end

  for k, v in pairs(b) do
    if (not a[k] and v ~= nil) then
      return false
    end
  end

  return true
end

local function almostDeepEquals(a, b, places)
  for k, v in pairs(a) do
    if b[k] ~= v and not (type(b[k]) == "number" and type(v) == "number" and almostEquals(b[k], v, places)) then
      if (type(v) == "table" and type(b[k]) == "table") then
        if not almostDeepEquals(v, b[k], places) then
          return false
        end
      else
        return false
      end
    end
  end

  for k, v in pairs(b) do
    if (not a[k] and v ~= nil) then
      return false
    end
  end

  return true
end

local function includes(t, a)
  for _, b in pairs(t) do
    if a == b then return true end
  end

  return false
end

local function matcher(exp)
  local matchers = {
    toEqual = function(compare)
      if (exp == compare) then
        return pass()
      else
        return fail("to equal", exp, compare)
      end
    end,
    toNotEqual = function(compare)
      if (exp == compare) then
        return fail("to not equal", exp, compare)
      else
        return pass()
      end
    end,
    toAlmostEqual = function(compare, places)
      if not places then places = 3 end
      if (almostEquals(exp, compare, places)) then
        return pass()
      else
        return fail("to almost equal (to "..places.." places)", exp, compare)
      end
    end,
    toShallowEqual = function(compare)
      if (shallowEquals(exp, compare)) then
        return pass()
      else
        return fail(
          "to shallow-equal",
          "table:\n\n" .. Table.stringify(exp, 1) .. "\n\n",
          "table:\n\n" .. Table.stringify(compare, 1) .. "\n\n"
        )
      end
    end,
    toNotShallowEqual = function(compare)
      if (shallowEquals(exp, compare)) then
        return fail("to not shallow-equal", exp, compare)
      else
        return pass()
      end
    end,
    toDeepEqual = function(compare)
      if (deepEquals(exp, compare)) then
        return pass()
      else
        return fail("to deep-equal", exp, compare)
      end
    end,
    toNotDeepEqual = function(compare)
      if (deepEquals(exp, compare)) then
        return fail("to not deep-equal", exp, compare)
      else
        return pass()
      end
    end,
    toAlmostDeepEqual = function(compare, places)
      if not places then places = 3 end
      if (almostDeepEquals(exp, compare, places)) then
        return pass()
      else
        return fail("to almost deep-equal (to "..places.." places)", exp, compare)
      end
    end,
    toInclude = function(compare)
      if (includes(exp, compare)) then
        return pass()
      else
        return fail(
          "to include:",
          "table: \n\n" ..Table.stringify(exp, 1) .. "\n\n",
          compare
        )
      end
    end
  }

  return matchers
end

function Test.expect(val)
  return matcher(val)
end

--[[
  For test suites that need to override existing global functions, i.e.:

    mocks = {
      reaper = {
        ShowConsoleMsg = function() stuff end
      },
    }

  Uses metatables to provide access to the rest of the i.e. reaper functions.
  ** Only sets metatables for the first level of tables **
]]--
function Test.requireWithMocks(requirePath, mocks)
  local path = Scythe.libPath .. requirePath:gsub("%.", "/") .. ".lua"

  local env = setmetatable({}, {__index = _G})
  for k, v in pairs(mocks) do
    env[k] = setmetatable(v, {__index = _G[k]})
  end

  return loadfile(path, "bt", env)()
end

return Test
