# Scythe 3.x changelog

## February 9, 2020

- v3.0.0! Yay!
- Added a script to regenerate the documentation from a source folder
- Lots of documentation updates

## January 19, 2020

- Added a script to generate ReaPack metapackages
- Restructured the repo so that the ReaPack packages only include relevant files

## January 17, 2020

- Added more documentation, updated doc parser logic.

## November 16, 2019

- Updated docs and moved them to a top-level folder; most of the public modules are now documented.
- Added a public `file` module with helpers for iterating over files/folders
- Added a documentation parser (`deployment/doc-parser/doc-parser.lua`). Modules can use [LDoc](https://stevedonovan.github.io/ldoc/)-style comments to document functions, and the parser will generate Markdown from them.

## November 11, 2019

- Added `self` to Button and Menubar's `func` arguments. Usage:

  ```lua
  func = function(self, a, b, c) Msg(self.name, a, b, c) end,
  params = {"a", "b", "c"}
  ```

## October 27, 2019

- Reimplemented developer menu, allowing an element's parameters to be printed to the console. To access it, switch to developer mode (`Ctrl + Alt + Shift + Z`), then `Ctrl + Right-click` any element.

## October 26, 2019

- Added wrappers for working with system-native colors:
  - `Color.toNative(color)` will accept a string preset (`"background"`) or a table of RGB values (`{0.5, 0.75, 1}`).
  - `Color.fromNative(nativeColor)` will accept a system-native color, such as those returned by `reaper.GR_SelectColor()`, and return a table of RGB values (`{0.5, 0.75, 1}`).
- Renamed color presets for clarity.
- Moved the GUI font and color presets into `gui/theme.lua`.

## October 12, 2019

- Added a way to bypass elements' input events. To use it, add a `before` event handler that sets `preventDefault = true` on its input state, i.e:

  ```lua
  function my_btn:beforeMouseUp(state) state.preventDefault = true end
  ```

  Note that preventing some events may cause unexpected behavior, for instance if a MouseUp event makes use of data stored by the preceding MouseDown.

- Added the ability to validate a Textbox's input. To use it, set `myTextbox.validator = function(text) ...do something... end`. The validator will be called with the current text whenever the textbox loses focus. If the validator returns `false` or `nil`, the textbox will reset to the text it had when it last gained focus.

  Setting `myTextbox.validateOnType = true` will call the validator whenever a new character is entered or a value is pasted.

- Pulled any logic that was in `:new` methods out to `:recalculateInternals`, which should make a GUI builder easier to implement in v3.

## October 1, 2019

- Replaced an automatic call to `reaper.get_action_context()` with a dedicated function that wraps and memoizes the returned values. This was necessary to avoid messing up user scripts that require access to the initial MIDI context.

## September 3, 2019

- Added a UI test script for user events and hooks

## July 21, 2019

- Moved `Element:update()` up to the Window class, eliminating a whole bunch of redundant processing. Shouldn't break anything.

## July 13, 2019

- Added functions for queueing messages so that Reaper isn't choked by constantly updating the console:
  - `qMsg(...)`: Stores all arguments in an internal table
  - `printQMsg`: Concatenates and prints the table contents

  In the event of a script error, any remaining messages in the queue are printed out.

- Added `requireWithMocks(requirePath, mocks)` for test suites that need to override `reaper`/`gfx`/etc. functions.

## June 30, 2019

- Slider and Knob use real values for their _default_ props rather than steps.

## June 29, 2019

- Added before + after event hooks for all input events:
  `myElement:beforeMouseUp = function() Msg("before mouse up") end`

## June 22, 2019

- Added Table functions:
  - `join`: Accepts any number of indexed tables, returning a new table with their values joined sequentially
  - `zip`: Accepts any number of indexed tables, returning a new table with their values joined alternately

## June 21, 2019

- Added a public Menu module, which wraps gfx.showmenu to provide more useful output and work with menus in a table form. Replaces all uses of gfx.showmenu with the wrapped version.

## June 12, 2019

- **Breaking:** _GUI.Init_ has been removed, since it wasn't doing anything anymore now that we have the window class. Starting a script just requires:

  ```lua
  myWindow:open()
  GUI.Main()
  ```

- Moved `error.lua` to the public folder so non-GUI scripts can make use of it
- Replaced all instances of `gfx.mouse_cap & number == number` with state flags: `if (state.kb.shift) then`

## June 09, 2019

- If `Element.output` is given a string, any occurrences of `%val%` will be replaced with the element's value
- **Breaking:** Menubar items use named parameters rather than an indexed table.
- Menubar items can now have a table of `params` that will be unpacked as arguments to `func`.

  ```lua
  {caption = "Menu Item", func = mnu_item, params = {"hello", "world!"}},
  ```

## June 08, 2019

- **Breaking:** Restructured the library to keep dev stuff in its own folder
- Scripts can load the library with `loadfile(libPath .. "scythe.lua")({dev = true})` to have the development folder added to _package.path_.
- Added tests for most public modules

## June 01, 2019

- Added a basic test framework and GUI
- Added tests for all functions in `public.color`

## May 25, 2019

- First release for public development
- Added ColorPicker class
- Uses 0-1 internally for all colors
