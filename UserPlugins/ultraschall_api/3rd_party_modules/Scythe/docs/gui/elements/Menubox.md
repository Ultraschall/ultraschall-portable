# Menubox
```lua
local Menubox = require(gui.elements.Menubox)
```


| **Optional** | []() | []() |
| --- | --- | --- |
| name | string | The element's name. Must be unique. |
| x | number | Horizontal distance from the left side of the window, in pixels |
| y | number | Vertical distance from the top of the window, in pixels |
| w | number | Width, in pixels |
| h | number | Height, in pixels |
| options | array | A list of options: `{"a", "b", "c"}`. Options use the same syntax as `gfx.showmenu` concerning separators, greying out, etc. |
| caption | string |  |
| captionFont | number | A font preset |
| textFont | number | A font preset |
| captionColor | string&#124;table | A color preset |
| textColor | string&#124;table | A color preset |
| bg | string&#124;table | A color preset |
| pad | number | Padding between the caption and the element frame |
| align | number | Alignment flags for the displayed value; see the API documentation for `gfx.drawstr` |
| retval | number | The selected item index |

<section class="segment">

### Menubox:val([newval]) :id=menubox-val

Get or set the selected item

| **Optional** | []() | []() |
| --- | --- | --- |
| newval | number | The selected item index |

| **Returns** | []() |
| --- | --- |
| number | The selected item index |
| string | The selected item's text |

</section>

----
_This file was automatically generated by Scythe's Doc Parser._
