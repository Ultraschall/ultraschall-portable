# Testing

In the interest of preventing as many bugs as possible, and also making future changes easier to do safely, Scythe includes a basic testing library.

## Goals

I'd like to see v3 go out the door with a test file for every module in the `public` folder, since they're specifically intended for use by external scripts. GUI functionality will be a bit trickier, but will hopefully have at least a basic set of tests in addition to more thorough demo scripts for checking each class' functionality.

## Running tests

The test front-end can be found at `library/test/test-gui.lua`. Opening it will prompt you to select a file - `library/public/tests/color.lua` is a good place to start.

Choose "Run Tests", and you should see the following output in your console:

```text
Running tests...

Color.fromRgba
  red
  blue
  maroon
  gray
  not lime
  not purple
Color.toRgba
  red
  blue
  maroon
  gray
```

This script calls each of the `Color` functions with a variety of input values and makes sure that the output is what we expect. Tests that pass aren't noteworthy, so it just logs the test's name.

A test that fails, on the other hand, will let you know what the problem is:

```text
Color.toHex
  RGB
    fail
      expected 00EF55 to equal 00FF55
  RGBA
  White
  Black
```

## Writing tests

The test environment provides its own functions as global variables for your test script, so only the module being tested needs to be imported.

```lua
local Color = require("public.color")
```

Tests are written as a set of functions - the syntax will be familiar to anyone who has used test libraries in other languages such as Javascript or Ruby.

```lua
describe("Color.toHex", function()
  test("RGB", function()
    local col = Color.toHex(0, 1, 0.33333)
    expect(col).toEqual("00FF55")
  end)
  test("RGBA", function()
    local col = Color.toHex(0.8, 0.5333, 0.1373, 1)
    expect(col).toEqual("CC8823FF")
  end)
  test("White", function()
    local col = Color.toHex(1, 1, 1, 1)
    expect(col).toEqual("FFFFFFFF")
  end)
  test("Black", function()
    local col = Color.toHex(0, 0, 0)
    expect(col).toEqual("000000")
  end)
end)
```

- `describe` defines a block of tests. It isn't strictly necessary, but you can see from the output above that it's useful to state what function or logic is being tested. It accepts a name or message, and a function that will run all of the tests when called.
- `test` likewise defines a set of expectations. It again takes a message, which are admittedly rather vague in the example above, and a function containing the specific test code.
- `expect` takes a value and returns an object with several methods attached known as _matchers_, such as `toEqual` in this example, that are used to compare the given value with an expected result.
  Matchers available at the time of this writing:
  - `toEqual`: Checks that `a == b`. In the case of tables this is a comparison by reference, so only the same actual table will match, not just the same set of values.
  - `toNotEqual`: Checks that `a ~= b`.
  - `toShallowEqual`: Checks that `a` and `b` are equal at the top level. Any values that are tables or functions will be compared by reference.
  - `toAlmostEqual`: Checks that `a` and `b` are equal down to a given number of decimal places, defaulting to 3. That is, `(a - b) <= 0.001`. This matcher accepts a second value if you need to specify a different number of places.
  - `toDeepEqual`: Checks that two tables have the same keys and values, recursively checking any subtables it finds.
  - `toNotDeepEqual`: Checks that two tables do not have the same keys and values.
  - `toAlmostDeepEqual`: Similar to `toDeepEqual`, but uses the same logic as `toAlmostEqual` when comparing numbers. This matcher can be handy if comparing the output of color functions (a table) to an external source such as a website, as the color functions used here don't round their output at all.
