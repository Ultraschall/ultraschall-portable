# Table
```lua
local Table = require(public.table)
```


<section class="segment">

### Table.T(t) :id=table-t

Sets a table's metatable to allow it to access both the Table module and
Lua's native table functions via : syntax.


Because Lua allows function calls to omit parentheses when only one argument
is present, this allows tables to be created and passed to Table.T with a very
clean syntax:
```
local T = require("public.table").T


local myTable = T{3, 1, 5, 2, 4}


local output = myTable
  :sort()
  :map(function(n) return n * 2 end)
  :stringify()


Msg(output) -- {2, 4, 6, 8, 10}
```

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| table | The original table reference |

</section>
<section class="segment">

### Table.forEach(t, cb) :id=table-foreach

Iterates over a given table, passing each entry to the callback.


Entries are **not** guaranteed to be called in any specific order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the table and passed the arguments [value, key, t]. Any return value will be ignored. |

</section>
<section class="segment">

### Table.orderedForEach(t, cb) :id=table-orderedforeach

Identical to Table.forEach, but guaranteed to run in numerical order on only
the array portion of the given table.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the array portion of the table and passed the arguments [value, index, t]. Any returned value will be ignored. |

</section>
<section class="segment">

### Table.map(t, cb) :id=table-map

Iterates over the given table, calling `cb(value, key, t)` for each element
and collecting the returned values into a new table with the original keys.


Entries are **not** guaranteed to be called in any specific order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table | A table |
| cb | function | Will be called for each entry in the table and passed the arguments [value, key, t]. Should return a value. |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.orderedMap(t, cb) :id=table-orderedmap

Identical to Table.map, but guaranteed to run in numerical order on only
the array portion of the given table.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the table and passed the arguments [value, key, t]. Should return a value. |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.filter(t, cb) :id=table-filter

Creates a new table containing only those elements of the given table for
which cb(value, key, t) returns true.


**Not** guaranteed to access elements in any specific order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table | A table |
| cb | function | Will be called for each entry in the table and passed the arguments [value, key, t]. Should return a boolean. |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.orderedFilter(t, cb) :id=table-orderedfilter

Identical to Table.filter, but operates on only the array portion of the
table and is guaranteed to run in order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the table and passed the arguments [value, key, t]. Should return a boolean. |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.reduce(t, cb[, acc]) :id=table-reduce

Iterates over a given table with the given accumulator (or 0, if not provided)
and callback, using the returned value as the accumulator for the next
iteration.


**Not** guaranteed to run in order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the table and passed the arguments [accumulator, value, key, t]. Must return an accumulator. |

| **Optional** | []() | []() |
| --- | --- | --- |
| acc | any | An accumulator, defaulting to 0 if not specified. |

| **Returns** | []() |
| --- | --- |
| any | Returns the final accumulator |

</section>
<section class="segment">

### Table.orderedReduce(t, cb[, acc]) :id=table-orderedreduce

Identical to Table.reduce, but operates on only the array portion of the table
and is guaranteed to access elements in order.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Will be called for each entry in the table and passed the arguments [accumulator, value, key, t]. Must return an accumulator. |

| **Optional** | []() | []() |
| --- | --- | --- |
| acc | any | An accumulator, defaulting to 0 if not specified. |

| **Returns** | []() |
| --- | --- |
| any | Returns the final accumulator |

</section>
<section class="segment">

### Table.shallowCopy(t) :id=table-shallowcopy

Creates a shallow copy of the given table - that is, only the "top" level
of elements is considered. Any tables or functions are copied by reference
to the new table.


Adapted from: http://lua-users.org/wiki/CopyTable

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.deepCopy(t[, copies]) :id=table-deepcopy

Performs a deep copy of the given table - any tables are recursively
deep-copied to the new table.


To explicitly prevent child tables from being deep-copied, set `.__noRecursion
= true`. This particularly important when working with circular references, as
deep-copying will lead to a stack overflow.


Adapted from: http://lua-users.org/wiki/CopyTable

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.stringify(t[, maxDepth, currentDepth]) :id=table-stringify

Creates a string of the table's contents, indented to show nested tables.


If `t` contains classes, or a lot of nested tables, etc, be wary of using
larger values for maxDepth; this function will happily block its thread for
minutes at a time as the number of children grows.


Do **not** use this with recursive tables.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Optional** | []() | []() |
| --- | --- | --- |
| maxDepth | integer | Maximum depth of nested tables to process. Defaults to 2. |

| **Returns** | []() |
| --- | --- |
| string |  |

</section>
<section class="segment">

### Table.shallowEquals(a, b) :id=table-shallowequals

Performs a shallow comparison of two tables. Only "top-level" elements are
considered; functions and tables are compared by reference.

| **Required** | []() | []() |
| --- | --- | --- |
| a | table |  |
| b | table |  |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.deepEquals(a, b) :id=table-deepequals

Recursively compares the contents of two tables. Will be `true` only if all
of `a`'s keys and values match all of table `b`s.

| **Required** | []() | []() |
| --- | --- | --- |
| a | table |  |
| b | table |  |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.fullSort(a, b) :id=table-fullsort

Sorts values of different types (bool < num < string < reference), e.g. for
use with `table.sort`.
```lua
local t = {"a", 1, {}, 5}
table.sort(t, Table.fullSort)
--> t == {1, 5, "a", {}}
```
Adapted from: http://lua-users.org/wiki/SortedIteration

| **Required** | []() | []() |
| --- | --- | --- |
| a | boolean&#124;num&#124;string&#124;reference |  |
| b | boolean&#124;num&#124;string&#124;reference |  |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.kpairs(t) :id=table-kpairs

Iterates through all table values in alphanumeric order.
```lua
for k, v in kpairs(t) do
```
Adapted from Programming In Lua, chapter 19.3.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| iterator |  |

</section>
<section class="segment">

### Table.invert(t) :id=table-invert

Swaps the keys and values in a given table.
```lua
local t = {a = 1, b = 2, c = 3, 4 = "d"}
local inverted = Table.invert(t)
--> {1 = "a", 2 = "b", 3 = "c", d = 4}
```
This will behave unpredictably if given a table where the same value exists
for multiple keys (e.g. booleans).

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.find(t, cb[, iter]) :id=table-find

Searches a table, returning the first value and index for which `cb(value,
key, t)` is truthy. If no match is found, will return `nil`.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function |  |

| **Optional** | []() | []() |
| --- | --- | --- |
| iter | iterator | Defaults to `ipairs` |

| **Returns** | []() |
| --- | --- |
| value&#124;nil |  |
| key |  |

</section>
<section class="segment">

### Table.any(t, cb) :id=table-any

Searches a table and returns `true` if `cb(value, key, t)` is truthy for any
element.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Should return a boolean. |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.all(t, cb) :id=table-all

Searches a table and returns `true` if `cb(value, key, t)` is truthy for all
elements.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Should return a boolean. |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.none(t, cb) :id=table-none

Searches a table and returns `true` if `cb(value, key, t)` is falsy for all
elements.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| cb | function | Should return a boolean. |

| **Returns** | []() |
| --- | --- |
| boolean |  |

</section>
<section class="segment">

### Table.fullLength(t) :id=table-fulllength

Returns the number of elements in a table, counting both indexed and keyed
elements.

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Returns** | []() |
| --- | --- |
| integer |  |

</section>
<section class="segment">

### Table.sortByKey(t, key) :id=table-sortbykey

Sorts a set of nested tables using a given key, returning the sorted values
as a dense table.
```lua
local t = { a = { val = 3 }, b = { val = 1 }, c = { val = 2 } }
local sorted = Table.sortByKey(t, "val")
--> { { val = 1 }, { val = 2 }, { val = 3 } }
```

| **Required** | []() | []() |
| --- | --- | --- |
| t | table | A table of tables |
| key | any | A key present in all of the tables |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.addMissingKeys(t, source) :id=table-addmissingkeys

Using `source` as a base, adds any key/value pairs to `t` for which `t[k] ==
nil`.


**Mutates the original table**

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |
| source | table |  |

| **Returns** | []() |
| --- | --- |
| table | Returns `t` |

</section>
<section class="segment">

### Table.sort(t[, func]) :id=table-sort

Wraps `table.sort` so it can be used in a method chain.


**Mutates the original table**

| **Required** | []() | []() |
| --- | --- | --- |
| t | table |  |

| **Optional** | []() | []() |
| --- | --- | --- |
| func | function | A sorting function |

| **Returns** | []() |
| --- | --- |
| table | Returns `t` |

</section>
<section class="segment">

### Table.join(...) :id=table-join

Merges any number of indexed tables sequentially into a new table.
```lua
local t = { {1, 2, 3}, {"a", "b", "c"}, {true, true, true} }
local joined = Table.join(t)
--> {1, 2, 3, "a", "b", "c", true, true, true}
```

| **Required** | []() | []() |
| --- | --- | --- |
| ... | table |  |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>
<section class="segment">

### Table.zip(...) :id=table-zip

Merges any number of indexed tables alternately into a new table.
```lua
local t = { {1, 2, 3}, {"a", "b", "c"}, {true, true, true} }
local zipped = Table.zip(t)
--> {1, "a", true, 2, "b", true, 3, "c", true}
```
If the tables are of uneven length, any remaining elements will
be added at the end.

| **Required** | []() | []() |
| --- | --- | --- |
| ... | table |  |

| **Returns** | []() |
| --- | --- |
| table |  |

</section>

----
_This file was automatically generated by Scythe's Doc Parser._
