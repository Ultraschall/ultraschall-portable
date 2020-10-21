# Doc Parser

One of the more annoying parts of maintaining a project like this is keeping documentation up to date. To simplify the process, Scythe can read [LDoc](https://stevedonovan.github.io/ldoc/)-style comments to generate Markdown from each module.

## Example

```lua
-- @module

local Message = {}

--- Prints arguments to the Reaper console. Each argument is sanitized with
-- `tostring`, and the string is ended by a line break.
-- @param ... any
Message.Msg = function (...)
  local out = {}
  for _, v in ipairs({...}) do
    out[#out+1] = tostring(v)
  end
  reaper.ShowConsoleMsg(table.concat(out, ", ").."\n")
end
```

## Tagging

All documentation must be written using inline (`--`) comments, followed by a space and one of several specific tags:

```lua
-- @param name string A name
```

Text within tags may use Markdown syntax. New lines of text will be joined with a space; for a true line break, add an empty comment line.

### Modules

#### `--- @module [name]`

The parser will examine all `.lua` files in the repository, but will only generate documentation if a `@module` tag is found within the first 10 lines. The `name` parameter is optional; if not found, the parser will use the require path of the module (i.e. `public.table`).

#### `-- [description]`

If used, _must_ be immediately after the `@module` tag. Provides a high-level description of the module.

#### `-- @require [require path]`

By default all modules will have a `require` example generated, of the form:

```lua
local Color = require("public.color")
```

If a module has multiple returns, requires any arguments, etc, use this tag to provide an example instead.

### Functions

#### `--- [description]`

The first line of a function's documentation _must_ begin with three dashes.

#### `@param [name] [type] [description]`

Parameters that are required by a function. Descriptions are usually helpful but may not be necessary in cases where the expected value is self-evident (`@param

#### `@option [name] [type] [description]`

Parameters that are not required by a function. If the function uses a default value, it should be noted in the description.

#### `@return [type] [description]`

Values that are returned by a function. If a function can return multiple values, use a separate `@return` tag for each:

```lua
-- @return string First name
-- @return string Last name
```

## Conventions

### Multiple types

If a parameter or return value can be of multiple types, separate them with a pipe character (`string|number`).

### Tables

I've denoted some values as being an `array` or `hash`; while many other languages implement these as distinct types, Lua combines both into `table`. Tables are generally used as if they were only one of the two, however, so this can serve as a easy shorthand for the expected table structure.

#### `array`

Tables using contiguous numeric indices, i.e. `{ "a", "b", "c" }`. Most of Lua's `table` functions expect a table to be in array form.

#### `hash`

Tables using key + value pairs, i.e. `{ a = 1, b = "hi", 4 = "four" }`. Most of Lua's `table` functions will behave unpredictably with hashes.
