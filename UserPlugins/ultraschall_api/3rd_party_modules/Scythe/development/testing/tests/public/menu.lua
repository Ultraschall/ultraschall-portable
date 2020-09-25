local menuVal

local Menu = requireWithMocks("public.menu", {
  gfx = { showmenu = function() return menuVal end }
})

describe("Menu.parseString", function()
  test("parses a basic set of options", function()
    local str = "1|2|3|4|5|6.12435213613"

    local sepsOut = Menu.parseString(str)
    expect(#sepsOut).toEqual(0)
  end)

  test("parses a set of options with separators", function()
    local str = "1|2||3|4|5||6.12435213613"

    local sepsOut = Menu.parseString(str)
    expect(#sepsOut).toEqual(2)
    expect(sepsOut[1]).toEqual(3)
    expect(sepsOut[2]).toEqual(7)
  end)

  test("parses a set of options with nesting", function()
    local str = "1|2|>3|3.1|3.2|<3.3|4|>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"

    local sepsOut = Menu.parseString(str)
    expect(#sepsOut).toEqual(2)
    expect(sepsOut[1]).toEqual(3)
    expect(sepsOut[2]).toEqual(8)
  end)

  test("parses a set of options with nesting and separators", function()
    local str = "1||2|>3|3.1|3.2|<3.3||4||>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"

    local sepsOut = Menu.parseString(str)
    expect(#sepsOut).toEqual(5)
    expect(sepsOut).toShallowEqual({2,4,8,10,11})
  end)
end)

describe("Menu.parseTable", function()
  test("parses a basic set of options", function()
    local arrIn = {1, 2, 3, 4, 5, 6.12435213613}
    local expected = "1|2|3|4|5|6.12435213613"

    local strOut, sepsOut = Menu.parseTable(arrIn)
    expect(strOut).toEqual(expected)
    expect(#sepsOut).toEqual(0)
  end)

  test("parses a set of options with separators", function()
    local arrIn = {1, 2, "", 3, 4, 5, "", 6.12435213613}
    local expected = "1|2||3|4|5||6.12435213613"

    local strOut, sepsOut = Menu.parseTable(arrIn)
    expect(strOut).toEqual(expected)
    expect(#sepsOut).toEqual(2)
    expect(sepsOut[1]).toEqual(3)
    expect(sepsOut[2]).toEqual(7)
  end)

  test("parses a set of options with nesting", function()
    local arrIn = {1, 2, ">3", 3.1, 3.2, "<3.3", 4, ">5", 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, "<5.7", 6.12435213613}
    local expected = "1|2|>3|3.1|3.2|<3.3|4|>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"

    local strOut, sepsOut = Menu.parseTable(arrIn)
    expect(strOut).toEqual(expected)
    expect(#sepsOut).toEqual(2)
    expect(sepsOut[1]).toEqual(3)
    expect(sepsOut[2]).toEqual(8)
  end)

  test("parses a set of options with nesting and separators", function()
    local arrIn = {1, "", 2, ">3", 3.1, 3.2, "<3.3", "", 4, "", ">5", 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, "<5.7", 6.12435213613}
    local expected = "1||2|>3|3.1|3.2|<3.3||4||>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"

    local strOut, sepsOut = Menu.parseTable(arrIn)
    expect(strOut).toEqual(expected)
    expect(#sepsOut).toEqual(5)
    expect(sepsOut).toShallowEqual({2,4,8,10,11})
  end)

  test("uses a parseKey to get the displayed value", function()
    local arrIn = {
      {caption = "a", value = 11},
      {caption = "b", value = 12},
      {caption = "c", value = 13},
      {caption = "d", value = 14},
      {caption = "e", value = 15},
      {caption = "f", value = 16},
    }

    local strOut, sepsOut = Menu.parseTable(arrIn, "caption")
    expect(strOut).toEqual("a|b|c|d|e|f")
    expect(#sepsOut).toEqual(0)
  end)
end)

describe("Menu.getTrueIndex", function()
  test("", function()
    local str = "1|2||3|4|5||6.12435213613"
    local separators = {3, 7}
    expect(Menu.getTrueIndex(str, 1, separators)).toEqual(1)
    expect(Menu.getTrueIndex(str, 3, separators)).toEqual(4)
    expect(Menu.getTrueIndex(str, 6, separators)).toEqual(8)
    expect(Menu.getTrueIndex(str, 7, separators)).toEqual(9)
  end)

  test("", function()
    local str = "1||2|>3|3.1|3.2|<3.3||4||>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"
    local separators = {2, 4, 8, 10, 11}
    expect(Menu.getTrueIndex(str, 1, separators)).toEqual(1)
    expect(Menu.getTrueIndex(str, 4, separators)).toEqual(6)
    expect(Menu.getTrueIndex(str, 8, separators)).toEqual(13)
    expect(Menu.getTrueIndex(str, 10, separators)).toEqual(15)
    expect(Menu.getTrueIndex(str, 11, separators)).toEqual(16)
  end)
end)

describe("Menu.showMenu", function()
  local idx, val

  test("handles a string with separators", function()
    local str = "1|2||3|4|5||6.12435213613"

    menuVal = 3
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(4)
    expect(val).toEqual("3")

    menuVal = 5
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(6)
    expect(val).toEqual("5")

    menuVal = 6
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(8)
    expect(val).toEqual("6.12435213613")
  end)

  test("handles a string with nesting and separators", function()
    local str = "1||2|>3|3.1|3.2|<3.3||4||>5|5.1|5.2|5.3|5.4|5.5|5.6|<5.7|6.12435213613"

    menuVal = 3
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(5)
    expect(val).toEqual("3.1")

    menuVal = 5
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(7)
    expect(val).toEqual("<3.3")

    menuVal = 12
    idx, val = Menu.showMenu(str)
    expect(idx).toEqual(17)
    expect(val).toEqual("5.6")
  end)

  test("handles a basic table", function()
    local arr = {1, 2, 3, 4, "", 5, 6.12435213613}

    menuVal = 3
    idx, val = Menu.showMenu(arr)
    expect(idx).toEqual(3)
    expect(val).toEqual(3)

    menuVal = 4
    idx, val = Menu.showMenu(arr)
    expect(idx).toEqual(4)
    expect(val).toEqual(4)

    menuVal = 6
    idx, val = Menu.showMenu(arr)
    expect(idx).toEqual(7)
    expect(val).toEqual(6.12435213613)
  end)

  test("handles a table with a parseKey", function()
    local arr = {
      {caption = "a", value = 11},
      {caption = "b", value = 12},
      {caption = "c", value = 13},
      {caption = "d", value = 14},
      {caption = "e", value = 15},
      {caption = "f", value = 16},
    }

    menuVal = 4
    idx, val = Menu.showMenu(arr, "caption")
    expect(idx).toEqual(4)
    expect(val).toEqual(arr[4])

    menuVal = 6
    idx, val = Menu.showMenu(arr, "caption")
    expect(idx).toEqual(6)
    expect(val).toEqual(arr[6])
  end)

  test("handles a table with a parseKey and valueKey", function()
    local arr = {
      {caption = "a", value = 11},
      {caption = "b", value = 12},
      {caption = "c", value = 13},
      {caption = "d", value = 14},
      {caption = "e", value = 15},
      {caption = "f", value = 16},
    }

    menuVal = 4
    idx, val = Menu.showMenu(arr, "caption", "value")
    expect(idx).toEqual(4)
    expect(val).toEqual(14)

    menuVal = 6
    idx, val = Menu.showMenu(arr, "caption", "value")
    expect(idx).toEqual(6)
    expect(val).toEqual(16)
  end)
end)
