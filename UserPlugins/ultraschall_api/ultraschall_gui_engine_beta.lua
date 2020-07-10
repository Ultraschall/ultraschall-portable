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
]] 

--dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

function ultraschall.GuiEngine_CreateInstance()
  -- this class creates a new GuiEngine-Object, with all it's methods and stuff
  local GuiEngine={}
  GuiEngine["GuiIdentifier"]=""
  GuiEngine["opened"]=false
  
  GuiEngine["Initiate"]=function (self) -- initiates a new Gui-Engine-instance and starts it
    local retval    
    retval, GuiEngine["GuiIdentifier"] = ultraschall.Main_OnCommandByFilename(ultraschall.Api_Path.."/ultraschall_gui_engine_server.lua")    
  end
  
  GuiEngine["Return_Guid"]=function (self, dudel) -- returns the guid of the GUI-engine-instance
    return GuiEngine["GuiIdentifier"]
  end
  
  GuiEngine["Destroy"]=function (self) 
   -- buggy, doesn't delete the returned table
   -- so probably we keep it in here for the time being but delete it anyhow at some point
    GuiEngine.Close()
    GuiEngine.Close=nil
    GuiEngine.Open=nil
    GuiEngine.Destroy=nil
    GuiEngine.LoadGUIFile=nil
    GuiEngine.Terminate=nil
    GuiEngine.Return_Guid=nil
    GuiEngine.Initiate=nil
    GuiEngine["GuiIdentifier"]=nil
    GuiEngine["opened"]=nil
    GuiEngine=nil 
  end
  
  GuiEngine["Open"]=function (self) -- tells the gui-engine-instance to open the gui in the gui-engine-instance
    if GuiEngine["GuiIdentifier"]=="" then return false end
    if GuiEngine["opened"]==false then
      local State=reaper.GetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message")
      reaper.SetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message", State.."Open\n",false)
      GuiEngine["opened"]=true
    end
  end
  
  GuiEngine["LoadGUIFile"]=function (self, GuiFile) -- tells the gui-engine-instance to load gui from a guifile
    if GuiEngine["GuiIdentifier"]=="" then return false end
    local State=reaper.GetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message")
    reaper.SetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message", "Load:"..GuiFile.."\n",false)
    GuiEngine["opened"]=true
  end
  
  GuiEngine["Close"]=function (self) -- tells the gui-engine-instance to close the gui-engine-instance
    if GuiEngine["GuiIdentifier"]=="" then return false end
    if GuiEngine["opened"]==true then
      local State=reaper.GetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message")
      reaper.SetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message", State.."Close\n",false)
      GuiEngine["opened"]=false
    end    
    return true
  end

  GuiEngine["Terminate"]=function (self) -- tells the gui-engine-instance to terminate itself altogether
    if GuiEngine["GuiIdentifier"]=="" then return false end
    local State=reaper.GetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message")
    reaper.SetExtState(GuiEngine["GuiIdentifier"].."-GuiEngine", "Message", State.."Terminate\n",false)
    GuiEngine["opened"]=false    
    GuiEngine["GuiIdentifier"]=""
    return true
  end
  
  return GuiEngine
end


--A=ultraschall.GuiEngine_CreateInstance()
--B=ultraschall.GuiEngine_CreateInstance()
--X=A:Return_Guid("huch")
--Y=B:Return_Guid("huch")

--B:Open()
--B:Close()
--B:Close()
--B:Close()

--P=0
function main()
  P=P+1
  if P==100 then
    B:Close()
    P=0
  elseif P==1 then
    B:Open()
    B:Open()
  end
  L=reaper.GetExtState(B["GuiIdentifier"], "Message")
  print3(B["GuiIdentifier"])
  reaper.defer(main)
end

--main()