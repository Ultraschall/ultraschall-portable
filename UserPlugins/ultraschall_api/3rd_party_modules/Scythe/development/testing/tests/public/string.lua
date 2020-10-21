local String = require("public.string")

describe("String.split", function()
  test("commas", function()
    local split = String.split("a,b,c,d,e", ",")
    expect(#split).toEqual(5)
    expect(split[1]).toEqual("a")
    expect(split[5]).toEqual("e")
  end)
  test("lines", function()
    local str = [[a
b
c
d
e
]]
    local split = String.split(str, "\n")
    expect(#split).toEqual(5)
    expect(split[1]).toEqual("a")
    expect(split[5]).toEqual("e")
  end)

  test("empty string", function()
    local split = String.split("", ",")
    expect(#split).toEqual(0)
  end)

  test("no pattern (should split @ characters)", function()
    local split = String.split("abcde")
    expect(#split).toEqual(5)
    expect(split[1]).toEqual("a")
    expect(split[5]).toEqual("e")
  end)

  test("no matches (should return the string)", function()
    local split = String.split("abcde", ",")
    expect(#split).toEqual(1)
    expect(split[1]).toEqual("abcde")
  end)
end)

describe("String.splitLines", function()
  test("lines", function()
    local str = [[a
b
c
d
e
]]
    local split = String.splitLines(str)
    expect(#split).toEqual(5)
    expect(split[1]).toEqual("a")
    expect(split[5]).toEqual("e")
  end)

  test("no lines", function()
    local split = String.splitLines("abcde")
    expect(#split).toEqual(1)
    expect(split[1]).toEqual("abcde")
  end)
end)
