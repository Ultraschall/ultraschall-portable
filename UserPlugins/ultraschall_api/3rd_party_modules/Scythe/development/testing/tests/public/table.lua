local Table = require("public.table")

describe("Table.forEach", function()
  test("performs an operation on every element", function()
    local t = {2, 4, 6}
    local sum = 0
    Table.forEach(t, function(val)
      sum = sum + val
    end)
    expect(sum).toEqual(12)
  end)
end)

describe("Table.orderedForEach", function()
  test("performs an operation on every element", function()
    local t = {2, 4, 6}
    local sum = 0
    Table.forEach(t, function(val)
      sum = sum + val
    end)
    expect(sum).toEqual(12)
  end)

  test("accesses the elements in order", function()
    local t = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
    local out = {}
    Table.forEach(t, function(val)
      out[#out+1] = val
    end)
    expect(table.concat(t)).toEqual("abcdefghijklmnopqrstuvwxyz")
  end)
end)

describe("Table.map", function()
  test("returns a table", function()
    local out = Table.map({})
    expect(type(out)).toEqual("table")
  end)

  test("performs an operation on every element", function()
    local t = {2, 4, 6}
    local out = Table.map(t, function(val)
      return val * 2
    end)
    table.sort(out)
    expect(out[1]).toEqual(4)
    expect(out[2]).toEqual(8)
    expect(out[3]).toEqual(12)
  end)
end)

describe("Table.orderedMap", function()
  test("returns a table", function()
    local out = Table.orderedMap({})
    expect(type(out)).toEqual("table")
  end)

  test("accesses the elements in order", function()
    local t = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
    local out = Table.orderedMap(t, function(val)
      return val
    end)
    expect(table.concat(out)).toEqual("abcdefghijklmnopqrstuvwxyz")
  end)

  test("performs an operation on every element", function()
    local t = {2, 4, 6}
    local out = Table.orderedMap(t, function(val)
      return val * 2
    end)
    expect(out[1]).toEqual(4)
    expect(out[2]).toEqual(8)
    expect(out[3]).toEqual(12)
  end)
end)

describe("Table.filter", function()
  test("returns a table", function()
    local out = Table.filter({})
    expect(type(out)).toEqual("table")
  end)

  test("filters elements based on a condition", function()
    local input = {1, 2, 3, 4, 5, 6, 7, 8}
    local out = Table.filter(input, function(val)
      return (val % 2 == 0)
    end)
    expect(#out).toEqual(4)
  end)

end)

describe("Table.orderedFilter", function()
  test("returns a table", function()
    local out = Table.orderedFilter({})
    expect(type(out)).toEqual("table")
  end)

  test("filters elements based on a condition", function()
    local input = {1, 2, 3, 4, 5, 6, 7, 8}
    local out = Table.orderedFilter(input, function(val)
      return (val % 2 == 0)
    end)
    expect(#out).toEqual(4)
  end)

  test("accesses the elements in order", function()
    local input = {"a", "b", "c", "d", "e", "f", "g", "h", "i"}
    local out = Table.orderedFilter(input, function(val)
      return (string.match("bidding", val))
    end)
    expect(out[1]).toEqual("b")
    expect(out[2]).toEqual("d")
    expect(out[3]).toEqual("g")
    expect(out[4]).toEqual("i")
  end)
end)

describe("Table.reduce", function()
  test("passes and returns the given accumulator", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local source = {}

    local out = Table.reduce(t, function(acc)
      return acc
    end, source)
    expect(out).toEqual(source)

  end)

  test("defaults the accumulator to 0", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local out = Table.reduce(t, function(acc)
      return acc
    end)

    expect(out).toEqual(0)
  end)

  test("performs an operation on every element", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local out = Table.reduce(t, function(acc, val)
      return acc + val
    end)

    expect(out).toEqual(28)
  end)
end)

describe("Table.orderedReduce", function()
  test("passes and returns the given accumulator", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local source = {}

    local out = Table.orderedReduce(t, function(acc)
      return acc
    end, source)
    expect(out).toEqual(source)

  end)

  test("defaults the accumulator to 0", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local out = Table.orderedReduce(t, function(acc)
      return acc
    end)

    expect(out).toEqual(0)
  end)

  test("performs an operation on every element", function()
    local t = {1, 2, 3, 4, 5, 6, 7}
    local out = Table.orderedReduce(t, function(acc, val)
      return acc + val
    end)

    expect(out).toEqual(28)
  end)

  test("accesses the elements in order", function()
    local input = {"a", "b", "c", "d", "e", "f", "g", "h", "i"}
    local out = Table.orderedReduce(input, function(acc, val)
      acc[#acc + 1] = val
      return acc
    end, {})

    local outStr = Table.concat(out)
    expect(outStr).toEqual("abcdefghi")
  end)
end)

describe("Table.shallowCopy", function()
  test("returns a table", function()
    local out = Table.shallowCopy({})
    expect(type(out)).toEqual("table")
  end)

  test("has the same content (primitives)", function()
    local tIn = {1, 2, 3, a = 4, b = 5}
    local tOut = Table.shallowCopy(tIn)
    expect(#tOut).toEqual(3)
    expect(tOut.a).toEqual(4)
    expect(tOut.b).toEqual(5)
  end)

  test("has the same content (table references)", function()
    local tIn = {a = {1, 2, 3}, b = 1, c = 2}
    local tOut = Table.shallowCopy(tIn)
    expect(tOut.a).toEqual(tIn.a)
  end)
end)

describe("Table.deepCopy", function()
  test("returns a new table", function()
    local tIn = {}
    local tOut = Table.deepCopy(tIn)
    expect(type(tOut)).toEqual("table")
    expect(tOut).toNotEqual(tIn);
  end)

  test("has the same content (primitives)", function()
    local tIn = {1, 2, 3, a = 4, b = 5}
    local tOut = Table.deepCopy(tIn)
    expect(#tOut).toEqual(3)
    expect(tOut.a).toEqual(4)
    expect(tOut.b).toEqual(5)
  end)

  test("does not have the same tables", function()
    local tIn = {a = {1, 2, 3}, b = 1, c = 2}
    local tOut = Table.deepCopy(tIn)
    expect(tOut.a).toNotEqual(tIn.a)
  end)

  test("deep-copies tables recursively", function()
    local tIn = {a = {b = {c = "test"}}}
    local tOut = Table.deepCopy(tIn)
    expect(tOut.a).toNotEqual(tIn.a)
    expect(tOut.a.b).toNotEqual(tIn.a.b)
    expect(tOut.a.b.c).toEqual("test")
  end)

  test("returns references to any elements with .__noRecursion", function()
    local tIn = {a = {
      b = {
        c = "test",
        __noRecursion = true
      }
    }}
    local tOut = Table.deepCopy(tIn)
    expect(tOut.a).toNotEqual(tIn.a)
    expect(tOut.a.b).toEqual(tIn.a.b)
    expect(tOut.a.b.c).toEqual("test")
  end)
end)

describe("Table.stringify", function()
  test("stringifies a table", function()
    local t = {
      a = 1,
      b = 2,
      c = 3,
    }
    local str = Table.stringify(t)
    expect(str:match("a = 1")).toEqual("a = 1")
    expect(str:match("b = 2")).toEqual("b = 2")
    expect(str:match("c = 3")).toEqual("c = 3")
  end)


  test("indents a nested table", function()
    local t = {
      a = 1,
      b = 2,
      c = 3,
      d = {
        e = 4,
        f = {
          g = 5
        },
      },
    }
    local str = Table.stringify(t)
    expect(str:match("  e = 4")).toEqual("  e = 4")
    expect(str:match("    g = 5")).toEqual("    g = 5")
  end)

  test("stops at the given max. depth", function()
    local t = {
      a = 1,
      b = 2,
      c = 3,
      d = {
        e = 4,
        f = {
          g = 5,
          h = {
            i = 6,
            j = {
              k = 7
            },
          },
        },
      },
    }
    local str = Table.stringify(t, 2)
    expect(str:match("i")).toEqual(nil)
    expect(str:match("k")).toEqual(nil)
  end)

  test("stops at elements with .__noRecursion", function()
    local t = {
      a = 1,
      b = 2,
      c = 3,
      d = {
        e = 4,
        __noRecursion = true,
        f = {
          g = 5,
          h = {
            i = 6,
            j = {
              k = 7
            },
          },
        },
      },
    }
    local str = Table.stringify(t)
    expect(str:match("g")).toEqual(nil)
  end)

end)

describe("Table.shallowEquals", function()
  test("should consider a table equal to itself", function()
    local t = {}
    expect(Table.shallowEquals(t, t)).toEqual(true)
  end)

  test("should consider two tables with the same primitive content equal", function()
    local a = {1, 2, 3, a = 4, b = 5}
    local b = {1, 2, 3, a = 4, b = 5}
    expect(Table.shallowEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with different primitive content unequal", function()
    local a = {1, 3, 3, a = 4, b = 5}
    local b = {1, 2, 3, a = 4, b = 5}
    expect(Table.shallowEquals(a, b)).toEqual(false)
  end)

  test("should consider two tables with the same nested tables equal", function()
    local t = {}
    local a = {t = t}
    local b = {t = t}

    expect(Table.shallowEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with different nested tables unequal", function()
    local a = {t = {}}
    local b = {t = {}}

    expect(Table.shallowEquals(a, b)).toEqual(false)
  end)

end)

describe("Table.deepEquals", function()
  test("should consider a table equal to itself", function()
    local t = {}
    expect(Table.deepEquals(t, t)).toEqual(true)
  end)

  test("should consider two tables with the same primitive content equal", function()
    local a = {1, 2, 3, a = 4, b = 5}
    local b = {1, 2, 3, a = 4, b = 5}
    expect(Table.deepEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with different primitive content unequal", function()
    local a = {1, 3, 3, a = 4, b = 5}
    local b = {1, 2, 3, a = 4, b = 5}
    expect(Table.deepEquals(a, b)).toEqual(false)
  end)

  test("should consider two tables with the same nested tables equal", function()
    local t = {}
    local a = {t = t}
    local b = {t = t}

    expect(Table.deepEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with nested tables equal", function()
    local a = {t = {}}
    local b = {t = {}}

    expect(Table.deepEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with identical deeply nested tables equal", function()
    local a = {t1 = {1, 2, 3}, t2 = {a = {4, 5}, b = {6, 7}}, t3 = {t4 = {t5 = {8, 9, 10}}, func = math.sin}}
    local b = {t1 = {1, 2, 3}, t2 = {a = {4, 5}, b = {6, 7}}, t3 = {t4 = {t5 = {8, 9, 10}}, func = math.sin}}

    expect(Table.deepEquals(a, b)).toEqual(true)
  end)

  test("should consider two tables with different deeply nested tables equal", function()
    local a = {t1 = {1, 2, 4}, t2 = {a = {4, 5}, b = {6, 7}}, t3 = {t4 = {t5 = {8, 9, 10}}, func = math.sin}}
    local b = {t1 = {1, 2, 3}, t2 = {a = {4, 5}, b = {6, 2}}, t3 = {t6 = {t5 = {8, 9, 10}}, func = math.cos}}

    expect(Table.deepEquals(a, b)).toEqual(false)
  end)
end)

describe("Table.fullSort", function()
  test("sorts strings", function()
    expect(Table.fullSort("a", "b")).toEqual(true)
    expect(Table.fullSort("d", "h")).toEqual(true)
    expect(Table.fullSort("hello there", "the quick brown fox")).toEqual(true)
    expect(Table.fullSort("n", "e")).toEqual(false)
    expect(Table.fullSort("t", "q")).toEqual(false)
    expect(Table.fullSort("good night", "good morning")).toEqual(false)
  end)

  test("sorts numbers", function()
    expect(Table.fullSort(1, 2)).toEqual(true)
    expect(Table.fullSort(80893, 2838423)).toEqual(true)
    expect(Table.fullSort(87, 43)).toEqual(false)
    expect(Table.fullSort(32452, 2341)).toEqual(false)
  end)

  test("sorts booleans < numbers", function()
    expect(Table.fullSort(true, false)).toEqual(true)
    expect(Table.fullSort(false, true)).toEqual(false)
  end)

  test("sorts numbers < strings", function()
    expect(Table.fullSort(1, "a")).toEqual(true)
    expect(Table.fullSort(80893, "hello there")).toEqual(true)
    expect(Table.fullSort("good night", 43)).toEqual(false)
    expect(Table.fullSort("test", 2341)).toEqual(false)
  end)

  test("sorts alphanumeric strings as num < str", function()
    expect(Table.fullSort("1e", "a")).toEqual(true)
    expect(Table.fullSort("80893", "hello there")).toEqual(true)
    expect(Table.fullSort("good night", "43 things")).toEqual(false)
    expect(Table.fullSort("test", "2341")).toEqual(false)
  end)

  test("sorts strings < references", function()
    local t = {}
    expect(Table.fullSort("math.sin", math.sin)).toEqual(true)
    expect(Table.fullSort("table", t)).toEqual(true)
    expect(Table.fullSort(t, tostring(t))).toEqual(false)
    expect(Table.fullSort(expect, "expect")).toEqual(false)
  end)
end)

describe("Table.kpairs", function()
  test("iterates over numeric keys in order", function()
    local tIn = {1, 2, 3, 4}
    local tOut = {}
    for _, v in Table.kpairs(tIn) do
      table.insert(tOut, v)
    end

    expect(tOut[1]).toEqual(1)
    expect(tOut[2]).toEqual(2)
    expect(tOut[3]).toEqual(3)
    expect(tOut[4]).toEqual(4)
  end)

  test("iterates over string keys in order", function()
    local tIn = {b = 2, c = 3, a = 1, d = 4}
    local tOut = {}
    for _, v in Table.kpairs(tIn) do
      table.insert(tOut, v)
    end

    expect(tOut[1]).toEqual(1)
    expect(tOut[2]).toEqual(2)
    expect(tOut[3]).toEqual(3)
    expect(tOut[4]).toEqual(4)
  end)

  test("iterates over mixed keys in alphanumeric order", function()
    local tIn = {a = 1, 2, 3, d = 4}
    local tOut = {}
    for _, v in Table.kpairs(tIn) do
      table.insert(tOut, v)
    end

    expect(tOut[1]).toEqual(2)
    expect(tOut[2]).toEqual(3)
    expect(tOut[3]).toEqual(1)
    expect(tOut[4]).toEqual(4)
  end)

end)

describe("Table.invert", function()
  test("inverts the contents of a table", function()
    local t = {}
    local tIn = {4, 5, 6, a = "hello", b = "world", c = t, d = math.sin}
    local tOut = Table.invert(tIn)

    expect(tOut[4]).toEqual(1)
    expect(tOut[5]).toEqual(2)
    expect(tOut[6]).toEqual(3)

    expect(tOut.hello).toEqual("a")
    expect(tOut.world).toEqual("b")

    expect(tOut[t]).toEqual("c")
    expect(tOut[math.sin]).toEqual("d")
  end)

end)

describe("Table.find", function()
  test("returns the value if there is a match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.find(t, function(val) return val == "hello" end)).toEqual("hello")
    expect(Table.find(t, function(val) return val % 2 == 0 end)).toEqual(2)
  end)

  test("returns false if there is no match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.find(t, function(val) return val == "goodbye" end)).toEqual(nil)
    expect(Table.find(t, function(val) return tonumber(val) and (val % 4 == 0) end)).toEqual(nil)
  end)

  test("returns the index of the match", function()
    local t = {1, 2, 3, "hello", "world"}

    local _, idx = Table.find(t, function(val) return val == "world" end)

    expect(idx).toEqual(5)
  end)
end)

describe("Table.any", function()
  test("returns true if any entries match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.any(t, function(val) return val end)).toEqual(true)
    expect(Table.any(t, function(val) return tostring(val):len() < 5 end)).toEqual(true)
  end)

  test("returns false if no entries match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.any(t, function(val) return type(val) == "boolean" end)).toEqual(false)
    expect(Table.any(t, function(val) return tostring(val):len() == 3 end)).toEqual(false)
  end)
end)

describe("Table.all", function()
  test("returns true if all entries match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.all(t, function(val) return val end)).toEqual(true)
    expect(Table.all(t, function(val) return tostring(val):len() < 10 end)).toEqual(true)
  end)

  test("returns false if at least one entry doesn't match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.all(t, function(val) return type(val) == "number" end)).toEqual(false)
    expect(Table.all(t, function(val) return tostring(val):len() < 5 end)).toEqual(false)
  end)
end)

describe("Table.none", function()
  test("returns false if any entries match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.none(t, function(val) return val end)).toEqual(false)
    expect(Table.none(t, function(val) return tostring(val):len() < 5 end)).toEqual(false)
  end)

  test("returns true if no entries match", function()
    local t = {1, 2, 3, "hello", "world"}

    expect(Table.none(t, function(val) return type(val) == "boolean" end)).toEqual(true)
    expect(Table.none(t, function(val) return tostring(val):len() == 3 end)).toEqual(true)
  end)
end)

describe("Table.fullLength", function()
  test("", function()
    local t = {1, 2, 3, a = "4", b = "5"}
    expect(Table.fullLength(t)).toEqual(5)
  end)

  test("", function()
    local t = {1, 2, 3, a = "4", b = "5", 1, 2, 3, aa = "4", bb = "5"}
    expect(Table.fullLength(t)).toEqual(10)
  end)
  test("", function()
    local nested = {}
    local t = {1, 2, 3, a = "4", b = "5", [nested] = 4, [math.sin] = 5}
    expect(Table.fullLength(t)).toEqual(7)
  end)

end)

describe("Table.sortByKey", function()
  test("", function()
    local tIn = {
      {z = 4},
      {z = 1},
      {z = 2},
      {z = 8},
      {z = 10},
      {z = 3},
      {z = 7},
    }

    local tOut = Table.sortByKey(tIn, "z")

    expect(tOut[1].z).toEqual(1)
    expect(tOut[2].z).toEqual(2)
    expect(tOut[3].z).toEqual(3)
    expect(tOut[4].z).toEqual(4)
    expect(tOut[5].z).toEqual(7)
    expect(tOut[6].z).toEqual(8)
    expect(tOut[7].z).toEqual(10)
  end)

end)

describe("Table.addMissingKeys", function()
  test("returns the original table", function()
    local tIn = {a = 1, b = 2}
    local source = {a = 4, b = 3, c = 8, d = 9}

    local tOut = Table.addMissingKeys(tIn, source)

    expect(tIn).toEqual(tOut)
  end)

  test("adds missing keys to the table", function()
    local t = {a = 1, b = 2}
    local source = {a = 4, b = 3, c = 8, d = 9}

    expect(t.c).toEqual(nil)
    expect(t.d).toEqual(nil)

    Table.addMissingKeys(t, source)

    expect(t.c).toEqual(8)
    expect(t.d).toEqual(9)
  end)

  test("doesn't alter the existing keys", function()
    local t = {a = 1, b = 2}
    local source = {a = 4, b = 3, c = 8, d = 9}

    expect(t.a).toEqual(1)
    expect(t.b).toEqual(2)

    Table.addMissingKeys(t, source)

    expect(t.a).toEqual(1)
    expect(t.b).toEqual(2)
  end)

end)

describe("Table.sort", function()
  test("returns the original table", function()
    local tIn = {6, 3, 1, 5, 2, 4}
    local tOut = Table.sort(tIn)

    expect(tIn).toEqual(tOut)
  end)

  test("sorts the table", function()
    local tIn = {6, 3, 1, 5, 2, 4}
    local tOut = Table.sort(tIn)

    expect(tOut[1]).toEqual(1)
    expect(tOut[2]).toEqual(2)
    expect(tOut[3]).toEqual(3)
    expect(tOut[4]).toEqual(4)
    expect(tOut[5]).toEqual(5)
    expect(tOut[6]).toEqual(6)
  end)

  test("sorts the table using a given function", function()
    local tIn = {6, 3, 1, 5, 2, 4}
    local tOut = Table.sort(tIn, function(a, b)
      return b < a
    end)

    expect(tOut[1]).toEqual(6)
    expect(tOut[2]).toEqual(5)
    expect(tOut[3]).toEqual(4)
    expect(tOut[4]).toEqual(3)
    expect(tOut[5]).toEqual(2)
    expect(tOut[6]).toEqual(1)
  end)
end)

describe("Table.join", function()
  test("should return a non-equal copy of one table", function()
    local tIn = {1, 2, 3}
    local tOut = Table.join(tIn)

    expect(tOut).toNotEqual(tIn)
    expect(tOut).toShallowEqual(tIn)
  end)

  test("should join two tables sequentially", function()
    local tA = {1, 2, 3}
    local tB = {4, 5, 6}

    expect(Table.join(tA, tB)).toShallowEqual({1, 2, 3, 4, 5, 6})
  end)

  test("should join five tables sequentially", function()
    local tA = {1, 2, 3}
    local tB = {4, 5, 6}
    local tC = {7, 8, 9}
    local tD = {10, 11, 12}
    local tE = {13, 14, 15}

    local tOut = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
    expect(Table.join(tA, tB, tC, tD, tE)).toShallowEqual(tOut)
  end)
end)

describe("Table.zip", function()
  test("should return a non-equal copy of one table", function()
    local tIn = {1, 2, 3}
    local tOut = Table.zip(tIn)

    expect(tOut).toNotEqual(tIn)
    expect(tOut).toShallowEqual(tIn)
  end)

  test("should join two tables alternately", function()
    local tA = {1, 2, 3}
    local tB = {4, 5, 6}

    expect(Table.zip(tA, tB)).toShallowEqual({1, 4, 2, 5, 3, 6})
  end)

  test("should join three tables alternately", function()
    local tA = {1, 2, 3}
    local tB = {4, 5, 6}
    local tC = {7, 8, 9}

    local tOut = {1, 4, 7, 2, 5, 8, 3, 6, 9}
    expect(Table.zip(tA, tB, tC)).toShallowEqual(tOut)
  end)

  test("should zip two tables of unequal length with the excess appended", function()
    local tA = {1, 2, 3, "a", "b", "c"}
    local tB = {4, 5, 6}

    expect(Table.zip(tA, tB)).toShallowEqual({1, 4, 2, 5, 3, 6, "a", "b", "c"})
  end)

  test("should zip four tables of unequal length with the excess appended", function()
    local tA = {1, 2, 3}
    local tB = {4, 5, 6, 7}
    local tC = {8, 9, 10, 11, 12}
    local tD = {13, 14, 15, 16, 17, 18, 19, 20}

    local expected = {1, 4, 8, 13, 2, 5, 9, 14, 3, 6, 10, 15, 7, 11, 16, 12, 17, 18, 19, 20}

    expect(Table.zip(tA, tB, tC, tD)).toShallowEqual(expected)
  end)
end)
