--[[
################################################################################
# 
# Copyright (c) 2014-present Ultraschall (http://ultraschall.fm)
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
# s
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

function is_playing_reverse()
    _ ,value=reaper.GetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle")  --check if reverse playing
    return (value=="1")
end

function GetPath(str)
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    separator = "\\"
  else
    separator = "/"
  end
  return str:match("(.*"..separator..")")
end

function main()
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  reverse_function = reaper.AddRemoveReaScript(true, 0, GetPath(filename).."ultraschall_shuttle_background_script.lua", true)

  if reverse_function ~= 0 then
    if is_playing_reverse() then
      reaper.SetProjExtState(0, "Ultraschall", "Reverse_Play_Shuttle", 2) --set reverse status to 2 -> button pressed again!
    else
      reaper.Main_OnCommand(reverse_function, 0) --start background script
    end
  else
    reaper.ShowMessageBox("the script file: "..GetPath(filename).."ultraschall_shuttle_background_script.lua".. " is missing.", "Warning: LUA Script missing.", 0)
  end
end

if reaper.GetPlayState() & 4 ~= 4 then -- do not start if recording!!
  reaper.defer(main) -- start without creating UNDO Points
end
