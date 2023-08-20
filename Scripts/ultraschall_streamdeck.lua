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

operationSystem = reaper.GetOS()
if string.match(operationSystem, "OS") then
  if reaper.file_exists(os.getenv("HOME").."/Library/Application Support/com.elgato.StreamDeck/Plugins/fm.ultraschall.ultradeck.sdPlugin/LUA/Ultraschall_StreamDeck_2.lua")==false then
    reaper.MB("Stream Deck-software not installed.", "Not installed", 0)
  end
  dofile(os.getenv("HOME").."/Library/Application Support/com.elgato.StreamDeck/Plugins/fm.ultraschall.ultradeck.sdPlugin/LUA/Ultraschall_StreamDeck_2.lua")
elseif string.sub(reaper.GetOS(),1,3)=="Win" then
  dofile(os.getenv("APPDATA")..[[\Elgato\StreamDeck\Plugins\com.elgato.controlcenter.sdPlugin\Ultraschall_StreamDeck_2.lua]])
  if reaper.file_exists(os.getenv("APPDATA")..[[\Elgato\StreamDeck\Plugins\com.elgato.controlcenter.sdPlugin\Ultraschall_StreamDeck_2.lua]])==false then
    reaper.MB("Stream Deck-software not installed.", "Not installed", 0)
  end
else
  reaper.ShowMessageBox("Stream Deck Plugin is only available on MacOS and Windows", "Wrong OS", 0)
end
