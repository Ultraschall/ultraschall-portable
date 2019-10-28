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
is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()

function ultraschall.RunChildScript_Main(filename_with_path, InitMsgFunction, ...)

  -- prepare the correct filename and extstate-name
  local path=filename_with_path:match("(.*/)")
  if path==nil then path=filename_with_path:match("(.*\\)") end
  local filename=filename_with_path:match("/(.*)%.")
  if filename==nil then filename=filename_with_path:match("\\(.*)%.") end
  local ext=filename_with_path:match(".*(%..*)")
  
  -- generate guid
  local guid=reaper.genGuid("")
  
  -- if given, pass over additional parameters to childscript
  AA={...}
  counter=0
  while AA[counter+1]~=nil do 
    counter=counter+1
    reaper.SetExtState("Ultraschall"..path..filename..guid:sub(2,-2)..ext, "parameters_"..counter, tostring(AA[counter]), false)
  end
  reaper.SetExtState("Ultraschall"..path..filename..guid:sub(2,-2)..ext, "parameters_count", tostring(counter), false)
  
  -- check, if file exists and if tempfile does not exist
  if reaper.file_exists(filename_with_path)==false then return nil end
  if reaper.file_exists(path..filename..guid:sub(2,-2)..ext)==true then return nil end
  
  -- check, if InitMsgFunction is a function and run it, if it exists
  if InitMsgFunction~=nil and type(InitMsgFunction)~="function" then return nil end
  if InitMsgFunction~=nil then InitMsgFunction(path..filename..guid:sub(2,-2)..ext) end
  
  -- copy script, register script, add channel, run childscript, unregister script
  local A=ultraschall.MakeCopyOfFile(filename_with_path, path..filename..guid:sub(2,-2)..ext)
  local B=reaper.AddRemoveReaScript(true, 0, path..filename..guid:sub(2,-2)..ext, true)
  reaper.SetExtState("Ultraschall"..path..filename..guid:sub(2,-2)..ext, "counter", 0, false)
  reaper.SetExtState("Ultraschall"..path..filename..guid:sub(2,-2)..ext, "channelcounter", 0, false)
  reaper.Main_OnCommand(B,0)
  local B=reaper.AddRemoveReaScript(false, 0, path..filename..guid:sub(2,-2)..ext, true)
  
  -- remove tempfile and return id of childscript
  os.remove(path..filename..guid:sub(2,-2)..ext)
  return path..filename..guid:sub(2,-2)..ext
end

function Tudelu(LULU)
  reaper.MB(LULU,"",0)
end

function ultraschall.HasChannel(channel, childscriptid)
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  if type(childscriptid)~="string" then childscriptid=filename end
  return reaper.HasExtState(childscriptid, channel)
end

function ultraschall.SendMessageToChildScript(childscriptid, channel, message)
  -- prepare variables
  local counter=tonumber(reaper.GetExtState("Ultraschall"..childscriptid, "counter"))
  local msgcounter=tonumber(reaper.GetExtState("Ultraschall"..childscriptid, "counter"..channel))
  if msgcounter==nil then msgcounter=-1 end

  -- if channel hasn't been used before, add it to our internal counter
  -- from which we know, which channels a certain childscript uses
  -- good for deleting them after finishing it
  if ultraschall.HasChannel(channel, childscriptid)==false then
    counter=reaper.GetExtState("Ultraschall"..childscriptid, "channelcounter")
    reaper.SetExtState("Ultraschall"..childscriptid, "channelcounter",tonumber(counter)+1,false)
    reaper.SetExtState("Ultraschall"..childscriptid, "channel"..tonumber(counter)+1,channel,false)
  end

  -- send message to channel  
  reaper.SetExtState("Ultraschall"..childscriptid, "counter", counter+1, false) -- any channel has been changed
  reaper.SetExtState("Ultraschall"..childscriptid, "counter"..channel, msgcounter+1, false) -- a specific channel has been changed
  reaper.SetExtState(childscriptid, channel, message, false)
end

function ultraschall.SendMessageToMasterScript(channel, message)
  -- prepare variables
  local is_new_value,childscriptid,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  local counter=tonumber(reaper.GetExtState("Ultraschall"..childscriptid, "counter"))
  local msgcounter=tonumber(reaper.GetExtState("Ultraschall"..childscriptid, "counter"..channel))
  if msgcounter==nil then msgcounter=-1 end

  -- if channel hasn't been used before, add it to our internal counter
  -- from which we know, which channels a certain childscript uses
  -- good for deleting them after finishing it
  if ultraschall.HasChannel(channel, childscriptid)==false then
    counter=reaper.GetExtState("Ultraschall"..childscriptid, "channelcounter")
    reaper.SetExtState("Ultraschall"..childscriptid, "channelcounter",tonumber(counter)+1,false)
    reaper.SetExtState("Ultraschall"..childscriptid, "channel"..tonumber(counter)+1,channel,false)
  end
  
  -- send message to channel
  reaper.SetExtState("Ultraschall"..childscriptid, "counter", counter+1, false) -- any channel has been changed
  reaper.SetExtState("Ultraschall"..childscriptid, "counter"..channel, msgcounter+1, false) -- a specific channel has been changed
  reaper.SetExtState(childscriptid, channel, message, false)
end

function ultraschall.ReceiveMessageAsChildScript(channel)
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  return reaper.GetExtState(filename, channel), reaper.GetExtState("Ultraschall"..filename, "counter"..channel)
end

function ultraschall.ReceiveMessageAsMasterScript(childscriptid, channel)
  return reaper.GetExtState(childscriptid, channel), reaper.GetExtState("Ultraschall"..childscriptid, "counter"..channel)
end

function ultraschall.GetAllChildsChannelUpdCounters(childscriptid)
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  if type(childscriptid)=="string" then filename=childscriptid end
  local counter=reaper.GetExtState("Ultraschall"..filename, "counter")
  if counter=="" then return -1 else return counter end
end

function ultraschall.GetOneChildsChannelUpdCounter(channel, childscriptid)
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  if type(childscriptid)=="string" then filename=childscriptid end
  local counter=reaper.GetExtState("Ultraschall"..filename, "counter"..channel)
  if counter=="" then return -1 else return counter end
end

function ultraschall.GetChildScriptArguments(childscriptid)
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  if type(childscriptid)=="string" then filename=childscriptid end
  count=reaper.GetExtState("Ultraschall"..filename, "parameters_count")
  if count=="" then count=0 end
  args={}
  for i=1, count do
    args[i]=reaper.GetExtState("Ultraschall"..filename, "parameters_"..i)
  end
  return count, args
end

function ultraschall.GetChildsChannelsAndMessages(childscriptid)
  local counter=reaper.GetExtState("Ultraschall"..childscriptid, "channelcounter")
  local chans={}
  for i=1, counter do
    chans[i]={reaper.GetExtState("Ultraschall"..childscriptid, "channel"..i), 1}
    chans[i][2]=reaper.GetExtState(childscriptid, chans[i][1])
  end
  return counter, chans
end

function ultraschall.DeleteAllChildsChannelsAndMessages(childscriptid)
-- still missing: parameters and counters and ultraschall..childscript deletion

  local counter=reaper.GetExtState("Ultraschall"..childscriptid, "channelcounter")
  local chans={}
  for i=1, counter do
    chans=reaper.GetExtState("Ultraschall"..childscriptid, "channel"..i)
    reaper.DeleteExtState(childscriptid, chans, false)
    reaper.DeleteExtState("Ultraschall"..childscriptid, "channel"..i, false)
  end
  
  reaper.GetExtState("Ultraschall"..childscriptid, "channelcounter")
  
  
  return counter, chans
end

function ultraschall.GetAvailableChildScripts()
  -- Hmm...how to do that one?
end

function ultraschall.ClearChildChannel(childscriptid, channel)
  -- Hmm...how to delete safely all channels?
  -- We need that, to clean up after us...
end

if filename:match("Child")~=nil then 
--B,C=ultraschall.ReceiveMessageAsMasterScript("c:\\testF5741A96-4F52-4855-B1C1-E25721A79901.lua", "Hula")
--A=ultraschall.RunChildScript_Main("c:\\test.lua", Tudelu, "Lula", "Dula")
--L=ultraschall.GetAllChildChannelCounters("Command")
--B=ultraschall.RunChildScript_Main("c:\\test.lua", 0)
--C=ultraschall.RunChildScript_Main("c:\\test.lua", 0)
--D=ultraschall.RunChildScript_Main("c:\\test.lua", 0)
--E=ultraschall.RunChildScript_Main("c:\\test.lua", 0)
A="c:\\test0EEFBD48-63FC-41D1-B2C9-7FAF3B8813AB.lua"
--ultraschall.SendMessageToChildScript(A, "Command23", "tudelu23")
L,LL=ultraschall.GetChildsChannelsAndMessages(A)
--ultraschall.SendMessageToChildScript(B, "Command", "quit")
--ultraschall.SendMessageToChildScript(C, "Command", "quit")
--ultraschall.SendMessageToChildScript(D, "Command", "quit")
--ultraschall.SendMessageToChildScript(E, "Command", "quit")
--ultraschall.GetChildScriptArguments()
end
