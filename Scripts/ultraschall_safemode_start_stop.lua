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


--[[reaper.GetPlayState()

0=stop,
1=playing,
2=pause,
5=is recording
6=record paused
]]

dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

state = reaper.GetPlayState()

if state == 5 then -- is recording

    --[[type:
    0=OK,
    1=OKCANCEL,
    2=ABORTRETRYIGNORE,
     3=YESNOCANCEL,
     4=YESNO,
     5=RETRYCANCEL]]

  msgboxtype = 4
  title = "Stop Recording?"
  msg = "Stop the currently running recording. No more audio will be recorded to disk. You may disable this check in the Ultraschall settings."


  -- Safe-Mode Toggle-Logic
  SafeModeToggleState=ultraschall.GetUSExternalState("ultraschall_settings_recording_safemode", "Value","ultraschall-settings.ini")

  if SafeModeToggleState=="0" then -- If Safe-Mode is OFF, show no message-box
      result = 6
  elseif SafeModeToggleState=="1" then -- If Safe-Mode is ON or was never toggled, show the message-box
      result=reaper.ShowMessageBox( msg, title, msgboxtype )
  end

  if result == 6 then -- it's ok to stop the recording
    reaper.OnStopButton()
  end

elseif state == 1 then -- playing
    reaper.OnStopButton()

else -- pause or stop
    reaper.OnPlayButton()
end
