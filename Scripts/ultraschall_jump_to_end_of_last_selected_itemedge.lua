--[[
################################################################################
# 
# Copyright (c) 2014-2019 Ultraschall (http://ultraschall.fm)
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
--]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
preroll = ultraschall.GetUSExternalState("Ultraschall_Jump_To_Selected_ItemEdge", "SelItem_PrerollTime_End")
if preroll=="" then preroll=0 end

-- right
if reaper.CountSelectedMediaItems(0) > 0 then -- items are selected
    reaper.Main_OnCommand(41174,0)            -- move cursor to last selected item
end

if reaper.GetPlayState()~=0 then 
  -- if playstate isn't stopped, move the playcursor to the new position
    reaper.SetEditCurPos(reaper.GetCursorPosition()+preroll, true, true)
end
