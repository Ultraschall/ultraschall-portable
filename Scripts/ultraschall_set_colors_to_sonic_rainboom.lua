--[[
################################################################################
# 
# Copyright (c) 2014-2017 Ultraschall (http://ultraschall.fm)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
################################################################################
]]



-- Print Message to console (debugging)
function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

function rgb_swap (color)
  os = reaper.GetOS()
  if string.match(os, "OSX") then 
    r, g, b = reaper.ColorFromNative(color)
    -- Msg(r .."-".. g .."-".. b.."-" ..color)
    color = reaper.ColorToNative(b, g, r) -- swap r and b for OSX
    -- Msg(" - "..color)
  end
  return color
end

-----------------------
-- Step 1 : get started
-----------------------

max_color = 20  -- Number of colors to cycle

curtheme = reaper.GetLastColorThemeFile()
os = reaper.GetOS()
nothingselected = false

if (reaper.CountSelectedTracks(0) == 0) then  -- no track selected
  nothingselected = true
  reaper.Main_OnCommand(40296,0)         -- select all tracks
end

---------------------------------------------------------
-- Step 2 : build table with color values from theme file
---------------------------------------------------------

t = {}   -- initiate table
t_invers = {}
file = io.open(curtheme, "r");
  
for line in file:lines() do
  index = string.match(line, "group_(%d+)")  -- use "Group" section
  index = tonumber(index)
    if index then
      if index < max_color then
      color_int = string.match(line, "=(%d+)")  -- get the color value
        if string.match(os, "OSX") then 
          r, g, b = reaper.ColorFromNative(color_int)
          color_int = reaper.ColorToNative(b, g, r) -- swap r and b for OSX
        end
      t[index] = color_int  -- put color into table
      t_invers[rgb_swap(color_int)] = index -- build the inverted table
    end
  end
end



-- for key,value in pairs(t) do Msg(value) end

----------------------------------
-- step 3: assign colors to tracks
----------------------------------

countTracks = reaper.CountSelectedTracks(0)
-- step = math.floor(max_color / countTracks + 0.5) 
-- if step == 0 then step = 1 end
step = 1  -- smooth gradient

if countTracks > 0 then -- SELECTED TRACKS LOOP
  track = reaper.GetSelectedTrack(0, 0)
  color = reaper.GetTrackColor(track)
  color = rgb_swap(color)
  if t_invers[color] and t_invers[color] > 0 then     
    k = t_invers[color]                   --start with a different color
  else
    k = 0
  end
    for j = 0, countTracks-1 do
        track = reaper.GetSelectedTrack(0, j)
        reaper.SetTrackColor (track, t[k]) --set Color to track
        k = k + step
        if k >= max_color then k = 0  end -- there are more tracks than colors, so start from the beginning
    end
end

if nothingselected == true then
  reaper.Main_OnCommand(40297,0)         -- unselect all tracks
end
