local testVars = {
  x = 1,
  y = 2,
  z = 2,
}

local testVars2 = testVars
local testVars3 = {
  x = 1,
  y = 1,
  z = 2,
}

local testVars4 = {
  x = 2,
  y = 1,
  z = 2,
}

local testVars5 = {
  x = {
    a = {1, 2, 3},
    b = {4, 5, 6},
    c = testVars2,
  },
  y = {
    d = testVars,
    e = {"a", "b", "c"}
  },
}

local testVars6 = {
  x = {
    a = {1, 2, 3},
    b = {4, 5, 6},
    c = testVars2,
  },
  y = {
    d = testVars,
    e = {"a", "b", "c"}
  },
}

describe("basic test", function()
  test("should compare numbers", function()
    expect(testVars.x == 1).toEqual(true)
    expect(testVars.x == testVars.z).toEqual(false)
    expect(testVars.z).toEqual(2)
  end)

  test("should compare by reference", function()
    expect(testVars).toEqual(testVars2)
    expect(testVars).toNotEqual(testVars3)
  end)

  test("should deep-compare", function()
    expect(testVars).toDeepEqual(testVars2)
    expect(testVars).toNotDeepEqual(testVars3)
    expect(testVars).toNotDeepEqual(testVars4)
    expect(testVars5).toDeepEqual(testVars6)
    expect(testVars5.x).toDeepEqual(testVars6.x)
  end)
end)
