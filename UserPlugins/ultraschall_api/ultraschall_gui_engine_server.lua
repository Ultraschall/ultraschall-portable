  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2020 Ultraschall (http://ultraschall.fm)
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

-- Ultraschall-API GuiEngine Server(Dev-version) 4.1.003 - Meo Mespotine
-- powered by Adam Lovatt's wonderful GuiLib Scythe(guilib v3)

--[[
-- the following script is a basic demo-script
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

gfx.init()
function main()
  gfx.x=1
  gfx.y=1
  Char=gfx.getchar()
  if Char==65 then -- A - Opens gui
    B=A:Open()
    gfx.drawstr("Open")
  elseif Char==66 then -- B - Closes Gui
    gfx.drawstr("Close")
    A:Close()
  elseif Char==84 then -- T - Terminates Gui-Engine-Instance
    gfx.drawstr("Terminate")
    A:Terminate()
  elseif Char==73 then -- I - Initializes Gui-Engine-Instance
    gfx.drawstr("Initiate")
    A:Initiate()
  elseif Char==76 then -- L - Loads Gui-from File(not yet working)
    gfx.drawstr("LoadGUIFile")
    A:LoadGUIFile("HudelDudel.gui")
  end
  reaper.defer(main)
end


main()

A=ultraschall.GuiEngine_CreateInstance()
--]]

-- Changelog:
--   9th of June
--   opens, closes gui-window, messagequeue implemented, terminates gui-engine instance if needed

-- initialize Ultraschall-API and Scythe
dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
ScriptIdentifier=ultraschall.GetScriptIdentifier()
libPath=ultraschall.Api_Path.."/3rd_party_modules/Scythe/"
loadfile(libPath .. "scythe.lua")()
local Table = require("public.table")
GUI = require("gui.core")


-- Initializational Dev-stuff, must be managed by functions and messagequeue at a later point
local window = GUI.createWindow({
      -- initialization of the gui-window
      name = "My Script",
      w = 296,
      h = 248,
    })
    
-- End of Dev-stuff


function ultraschall.GUI_OpenGUI()
   -- opens the gui, doesn't load the GUI!!
   -- TODO: must reset the window-position
   window:open()   
end

function ultraschall.GUI_CloseGUI()
   -- closes the gui
   window:close()
end 

function ultraschall.GUI_LoadGUIFile()
   -- will, at some point, load the Gui from a GuiFile
   reaper.GetUserFileNameForRead("Demo Loader", "", "")
   print2("Not Yet Implemented")
end

function ultraschall.GUI_MessageQueue()
  -- Manages the messagequeue, which is populated by an external script to control this Gui-Engine-instance
  local Message=reaper.GetExtState(ScriptIdentifier.."-GuiEngine", "Message")

  local count, individual_values = ultraschall.CSV2IndividualLinesAsArray(Message,"\n")  
  --print("running: "..Message)
  for i=1, count do
    if individual_values[i]~="" then
      --print(i..individual_values[i])
    end
    if     individual_values[i]=="Open"  then ultraschall.GUI_OpenGUI()
    elseif individual_values[i]:sub(1,5)=="Load:" then ultraschall.GUI_LoadGUIFile(individual_values[i]:sub(6,-1))
    elseif individual_values[i]=="Close" then ultraschall.GUI_CloseGUI()
    elseif individual_values[i]=="Terminate" then ultraschall.GUI_CloseGUI() reaper.SetExtState(ScriptIdentifier.."-GuiEngine", "Message", "", false) return
    end
  end

  
  reaper.SetExtState(ScriptIdentifier.."-GuiEngine", "Message", "", false)
  reaper.defer(ultraschall.GUI_MessageQueue)
end

-- start the GUI-Engine-Messagequeue so we can communicate with it from the outside
ultraschall.GUI_MessageQueue()
-- start the GUI but without opening it
GUI.Main()