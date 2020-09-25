# A Basic Script

A Scythe UI consists of a window and one or more layers, each of which can contain multiple elements.

To begin, we load the `GUI` module.

```lua
local GUI = require("gui.core")
```

For this example we'll need a window, a layer, and an element.

```lua
local window = GUI.createWindow({
  name = "My Script",
  w = 96,
  h = 48,
})

local layer = GUI.createLayer({
  name = "My Layer"
})

local button = GUI.createElement({
  name = "My Button",
  type = "Button",
  x = 16,
  y = 16,
  caption = "Hi!"
})
```

For our button to do something, we'll use its `func` property. `func` is specific to the Button class, since doing something in response to a click is its sole reason for existing; other elements must handle user events differently.

```lua
button.func = function() reaper.ShowMessageBox("You clicked the button!", "Yay!", 0) end
```

This could have also been done by including `func = ...` with the other properties when we created the button.

Now we connect everything together.

```lua
layer:addElements(button)
window:addLayers(layer)
```

All that's left is to open the window and start the GUI's main loop.

```lua
window:open()
GUI.Main()
```

That's it! Save your script with a `.lua` extension, use _Run a script_ in Reaper's Action List to find it, and you should see it pop up in the center of your screen.

## The final script

```lua
local GUI = require("gui.core")

local window = GUI.createWindow({
  name = "My Script",
  w = 96,
  h = 48,
})

local layer = GUI.createLayer({
  name = "My Layer"
})

local button = GUI.createElement({
  name = "My Button",
  type = "Button",
  x = 16,
  y = 16,
  caption = "Hi!"
})

button.func = function() reaper.ShowMessageBox("You clicked the button!", "Yay!", 0) end

layer:addElements(button)
window:addLayers(layer)

window:open()
GUI.Main()
```
