--[[
  A demonstration of the Listbox, Menubar, and TextEditor classes
]]--

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end
loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")

local T = require("public.table").T


------------------------------------
-------- Menu functions ------------
------------------------------------


local mnu_file = {
  new = function()
    GUI.Val("txted_text", "file: new")
  end,
  open = function()
    GUI.Val("txted_text", "file: open")
  end,
  recent_blah = function()
    GUI.Val("txted_text", "file:\trecent files: blah.txt")
  end,
  recent_stuff = function()
    GUI.Val("txted_text", "file:\trecent files: stuff.txt")
  end,
  recent_readme = function()
    GUI.Val("txted_text", "file:\trecent files: readme.md")
  end,
  save = function()
    GUI.Val("txted_text", "file: save")
  end,
  save_as = function()
    GUI.Val("txted_text", "file: save as")
  end,
  print = function()
    GUI.Val("txted_text", "file: print")
  end,
  print_preview = function()
    GUI.Val("txted_text", "file: print preview")
  end,
  exit = function()
    GUI.quit = true
  end
}

local mnu_edit = {
  cut = function()
    GUI.Val("txted_text", "edit: cut")
  end,
  copy = function()
    GUI.Val("txted_text", "edit: copy")
  end,
  copy_path = function()
    GUI.Val("txted_text", "edit:\tcopy current path")
  end,
  copy_file = function()
    GUI.Val("txted_text", "edit:\tcopy current filename")
  end,
  copy_dir = function()
    GUI.Val("txted_text", "edit:\tcopy current directory path")
  end,
  paste = function()
    GUI.Val("txted_text", "edit: paste")
  end,
  delete = function()
    GUI.Val("txted_text", "edit: delete")
  end,
  select_all = function()
    GUI.Val("txted_text", "edit: select all")
  end
}

local mnu_view = {
  always_on_top = function()
    GUI.Val("txted_text", "view: always on top")
  end,
  toggle_full_screen = function()
    GUI.Val("txted_text", "view: toggle full-screen")
  end,
  hide_menu = function()
    GUI.Val("txted_text", "view: hide menu")
  end
}

local mnu_help = {
  help = function()
    GUI.Val("txted_text", "help: help")
  end,
  open_website = function()
    GUI.Val("txted_text", "help: open website")
  end,
  check_for_updates = function()
    GUI.Val("txted_text", "help: check for updates")
  end,
  about = function()
    GUI.Val("txted_text", "help: about")
  end
}

local mnu_params_func = function(self, label, param)
  GUI.Val("txted_text", "Parameter " .. label .. " was: " .. param)
end



------------------------------------
-------- Menu contents -------------
------------------------------------


-- This table is passed to the Menubar
-- Must be structured like this (.title, .options, etc)
local menus = {

  {title = "File", options = {
    {caption = "New",                       func = mnu_file.new},
    {caption = ""},
    {caption = "Open",                      func = mnu_file.open},
    {caption = ">Recent Files"},
      {caption = "blah.txt",                func = mnu_file.recent_blah},
      {caption = "stuff.txt",               func = mnu_file.recent_stuff},
      {caption = "<readme.md",              func = mnu_file.recent_readme},
    {caption = "Save",                      func = mnu_file.save},
    {caption = "Save As",                   func = mnu_file.save_as},
    {caption = ""},
    {caption = "#Print",                    func = mnu_file.print},
    {caption = "#Print Preview",            func = mnu_file.print_preview},
    {caption = ""},
    {caption = "Exit",                      func = mnu_file.exit}
  }},

  {title = "Edit", options = {
    {caption = "Cut",                       func = mnu_edit.cut},
    {caption = "Copy",                      func = mnu_edit.copy},
    {caption = ">Copy to Clipboard"},
      {caption = "Current full file path",  func = mnu_edit.copy_path},
      {caption = "Current filename",        func = mnu_edit.copy_file},
      {caption = "<Current directory path", func = mnu_edit.copy_dir},
    {caption = "Paste",                     func = mnu_edit.paste},
    {caption = "Delete",                    func = mnu_edit.delete},
    {caption = ""},
    {caption = "Select All",                func = mnu_edit.select_all}
  }},

  {title = "View", options = {
    {caption = "!Always On Top",            func = mnu_view.always_on_top},
    {caption = "Toggle Full-Screen",        func = mnu_view.toggle_full_screen},
    {caption = "Hide Menu",                 func = mnu_view.hide_menu}
  }},

  {title = "Help", options = {
    {caption = "Help",                      func = mnu_help.help},
    {caption = "#Open Website",             func = mnu_help.open_website},
    {caption = ""},
    {caption = "#Check For Updates",        func = mnu_help.check_for_updates},
    {caption = "About",                     func = mnu_help.about},
  }},

  {title = "Parameters", options = {
    {caption = "Parameter A",               func = mnu_params_func,    params = {"A", "hello!"}},
    {caption = "Parameter B",               func = mnu_params_func,    params = {"B", "bonjour!"}},
    {caption = "Parameter C",               func = mnu_params_func,    params = {"C", "g'day!"}},
    {caption = "Parameter D",               func = mnu_params_func,    params = {"D", "guten tag!"}},
  }},
}


------------------------------------
-------- Listbox contents ----------
------------------------------------


local items = T{

  {"Pride and Prejudice",
[[It is a truth universally acknowledged, that a single man in possession of a good fortune
must be in want of a wife.]]},

  {"100 Years of Solitude",
[[Many years later, as he faced the firing squad, Colonel Aureliano Buendía was to remember
that distant afternoon when his father took him to discover ice.]]},

  {"Lolita",
[[Lolita, light of my life, fire of my loins.]]},

  {"1984",
[[It was a bright cold day in April, and the clocks were striking thirteen.]]},

  {"A Tale of Two Cities",
[[It was the best of times, it was the worst of times, it was the age of wisdom, it was the
age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the
season of Light, it was the season of Darkness, it was the spring of hope, it was the winter
of despair.]]},

  {"The Catcher in the Rye",
[[If you really want to hear about it, the first thing you’ll probably want to know is where
I was born, and what my lousy childhood was like, and how my parents were occupied and all
before they had me, and all that David Copperfield kind of crap, but I don’t feel like going
into it, if you want to know the truth.]]},

  {"City of Glass",
[[It was a wrong number that started it, the telephone ringing three times in the dead of
night, and the voice on the other end asking for someone he was not.]]},

  {"The Stranger",
[[Mother died today.]]},

  {"Waiting",
[[Every summer Lin Kong returned to Goose Village to divorce his wife, Shuyu.]]},

  {"Notes from Underground",
[[I am a sick man . . . I am a spiteful man.]]},

  {"Paradise",
[[They shoot the white girl first.]]},

  {"The Old Man and the Sea",
[[He was an old man who fished alone in a skiff in the Gulf Stream and he had gone
eighty-four days now without taking a fish.]]},

  {"The Crow Road",
[[It was the day my grandmother exploded.]]},

  {"Catch-22",
[[It was love at first sight.]]},

  {"Imaginative Qualities of Actual Things",
[[What if this young woman, who writes such bad poems, in competition with her husband,
whose poems are equally bad, should stretch her remarkably long and well-made legs out
before you, so that her skirt slips up to the tops of her stockings?]]}

}

local titles = items:map(function(val) return val[1] end)


local function addText()
  -- Get the list box's selected item(s)
  local selected = GUI.Val("lst_titles")

  -- Make sure it's a table, just to be consistent with the multi-select logic
  if type(selected) == "number" then selected = {[selected] = true} end

  -- Grab the text for all selected items, then combine it into one string
  local str = selected:reduce(
    function(acc, val, i)
      if val then acc[#acc + 1] = items[i][2] end
      return acc
    end,
    T{}
  )
  :concat("\n\n")

  GUI.Val("txted_text", str)
end


------------------------------------
-------- Window settings -----------
------------------------------------


local window = GUI.createWindow({
  name = "Menubar, Listbox, and TextEditor",
  x = 0,
  y = 0,
  w = 800,
  h = 272,
  anchor = "mouse",
  corner = "C",
})


window:addLayers(
  GUI.createLayer({name = "Layer1", z = 1})
    :addElements(
      GUI.createElements(
        {
          name = "mnu_menu",
          type = "Menubar",
          x = 0,
          y = 0,
          w = window.currentW,
          menus = menus,
        },
        {
          name = "lst_titles",
          type = "Listbox",
          x = 16,
          y = 40,
          w = 300,
          h = 208,
          caption = "",
          multi = true,
          list = titles,
          afterDoubleClick = function(self) addText() end
        },
        {
          name = "btn_go",
          type = "Button",
          x = 324,
          y = 104,
          w = 32,
          h = 24,
          caption = "-->",
          func = addText
        },
        {
          name = "txted_text",
          type = "TextEditor",
          x = 364,
          y = 40,
          w = 420,
          h = 208,
          retval = "Select an item\n  or two\n    or three\n      or everything in the list\n\nand click the button!",
        }
      )
    )
)


window:open()

GUI.Main()
