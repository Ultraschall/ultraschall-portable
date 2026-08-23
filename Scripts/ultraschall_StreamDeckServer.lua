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
--[[
-- Alter Code zum Starten des StreamDecks. Wird der noch gebraucht?

operationSystem = reaper.GetOS()

if string.match(operationSystem, "OS") then
  if reaper.file_exists(os.getenv("HOME").."/Library/Application Support/com.elgato.StreamDeck/Plugins/fm.ultraschall.ultradeck.sdPlugin/LUA/Ultraschall_StreamDeck_2.lua")==false then
    reaper.MB("Stream Deck-software not installed.", "Not installed", 0)
    return
  end
  dofile(os.getenv("HOME").."/Library/Application Support/com.elgato.StreamDeck/Plugins/fm.ultraschall.ultradeck.sdPlugin/LUA/Ultraschall_StreamDeck_2.lua")
elseif string.sub(reaper.GetOS(),1,3)=="Win" then
  if reaper.file_exists(os.getenv("APPDATA").."\Elgato\StreamDeck\Plugins\com.elgato.controlcenter.sdPlugin\Ultraschall_StreamDeck_2.lua")==false then
    reaper.MB("Stream Deck-software not installed.", "Not installed", 0)
    return
  end
  dofile(os.getenv("APPDATA").."\Elgato\StreamDeck\Plugins\com.elgato.controlcenter.sdPlugin\Ultraschall_StreamDeck_2.lua")
else
  reaper.ShowMessageBox("Stream Deck Plugin is only available on MacOS and Windows", "Wrong OS", 0)
  return
end
--]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

-- send shortcuts from the streamdeck by setting the extstate via WebRC to
--    section="Ultraschall StreamDeck"
--    key=    "StreamDeckButton_XXX pressed", 
--    value=  "1"
-- where XXX is a number between 1(without leading 0!) and 255. 
-- 
-- This will prompt the StreamDeck-Server in Ultraschall to send the shortcut "StreamDeckButton_XXX" as a local 
-- osc-message that is accepted as shortcut by Reaper.
-- For instante:
--    setion= "Ultraschall StreamDeck"
--    key=    "StreamDeckButton_001 pressed"
--    value=  "1"
-- will send the shortcut
--    StreamDeckButton_001
-- to Reaper.

-- The server will set up extstates, that contain all the information of the action linked to a StreamDeckButton_XXX-shortcut.
-- The extstates are of the following format(XXX is from 1(without leading 0!) to 255) and are stored as strings:
-- Section:
--  "Ultraschall StreamDeck"
-- Keys:
--  "StreamDeckButton_XXX action command id"] - the action command id, to which it is associated; "" if not associated
--  "StreamDeckButton_XXX section"] - the setion to which it is associated; "" if not associated
--  "StreamDeckButton_XXX toggle state"] - toggle state of the action; -1, not available, 0, off, 1, on; "" if not associated
--  "StreamDeckButton_XXX action description"] - description of the associated action; "" if not associated
--  "StreamDeckButton_XXX additional text"] - possible additional text(soundboard-slot-filename, etc), "" if not given
--
-- Just use them from the WebRC as needed to toggle images in the StreamDeckButtons.

reaper.set_action_options(3)

function main()
  -- get the number of available StreamDeckButtons from the WebRC via ExtState
  -- if not available, the server will check for 255 StreamDeck-buttons
  NumberSDButtons=tonumber(reaper.GetExtState("Ultraschall StreamDeck", "StreamDeckButtons Count"))
  if NumberSDButtons==nil then NumberSDButtons=255 end
  
  -- update StreamDeckAction-States and set them via extstate for retrieval in WebRC
  -- includes current toggle states of with SD-buttons-associated actions
  CurStreamDeckActionStates, SD_Buttons=ultraschall.GetStreamDeckActions(NumberSDButtons)
  
  -- Check, if WebRC sent via Extstate, that a StreamDeck-button has been pressed and send
  -- corresponding local OSC-message as shortcut
  for i=1, NumberSDButtons do
    if reaper.GetExtState("Ultraschall StreamDeck", "StreamDeckButton_"..i.." pressed")=="1" then
      reaper.SetExtState("Ultraschall StreamDeck", "StreamDeckButton_"..i.." pressed", "", false)
      local tts=string.gsub(SD_Buttons["StreamDeckButton_"..i],"%(Ultraschall%)", "")
      tts=string.gsub(tts,"^Script:", "")
      tts=string.gsub(tts,"^Custom:", "")
      
      -- output started action to screenreader, when the action itself doesn't send a message to screenreader
      if reaper.osara_outputMessage~=nil and reaper.GetExtState("ultraschall TTS", "StreamDeckServer")=="true" then
        reaper.osara_outputMessage(tts)
      end
      reaper.OscLocalMessageToHost("StreamDeckButton_"..i, 0)
    end
  end
  reaper.defer(main)
end

main()
